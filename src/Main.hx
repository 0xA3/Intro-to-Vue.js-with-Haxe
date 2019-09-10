import js.Syntax;
import js.Lib;

class Main {
	
	static function main() {

		Vue.config.devtools = true;
		
		var eventBus = new Vue();
		
		Vue.component( 'product', {
			props: {
				premium: {
					type: Bool,
					required: true
				}
			},
			template: '
				<div class="product">
				
				<div class="product-image">
					<img :src="image">
				</div>
				<div class="product-info">
					<h1>{{ title }}</h1>
					<p v-if="inStock">In Stock</p>
					<p v-else>Out of Stock</p>
					<p>Shipping: {{ shipping }}</p>
					<ul>
						<li v-for="detail in details">{{ detail }}</li>
					</ul>
					<div v-for="(variant, index) in variants"
						:key="variant.variantId"
						class= "color-box"
						:style="{ backgroundColor: variant.variantColor }"
						@mouseover="updateProduct(index)">
					</div>
					
					<button v-on:click="addToCart"
						:disabled="!inStock"
						:class="{ disabledButton: !inStock }"
						>Add to Cart
					</button>

					<product-tabs :reviews="reviews"></product-tabs>

				</div>
			',
			data: () -> {
				product: "Socks",
				brand: "Vue Masterful",
				selectedVariant: 0,
				details: ["80% cotton", "20% polyester", "Gener-neutral"],
				variants: [
					{
						variantId: 2234,
						variantColor: "green",
						variantImage: 'https://www.vuemastery.com/images/challenges/vmSocks-green-onWhite.jpg',
						variantQuantity: 10
					},
					{
						variantId: 2235,
						variantColor: "blue",
						variantImage: 'https://www.vuemastery.com/images/challenges/vmSocks-blue-onWhite.jpg',
						variantQuantity: 0
					}
				],
				reviews: []
			},
			methods: {
				addToCart: () -> Lib.nativeThis.$emit( 'add-to-cart', Lib.nativeThis.variants[Lib.nativeThis.selectedVariant].variantId ),
				updateProduct: ( index ) -> Lib.nativeThis.selectedVariant = index,
			},
			computed: {
				title: () -> '${Lib.nativeThis.brand} ${Lib.nativeThis.product}',
				image: () -> Lib.nativeThis.variants[Lib.nativeThis.selectedVariant].variantImage,
				inStock: () -> Lib.nativeThis.variants[Lib.nativeThis.selectedVariant].variantQuantity,
				shipping: () -> Lib.nativeThis.premium ? "Free" : "2.99"

			},
			mounted: () -> {
				// eventBus.on( 'review-submitted', productReview -> Lib.nativeThis.reviews.push( productReview ));
				eventBus.on( 'review-submitted', Syntax.code("productReview => this.reviews.push( productReview )"));
			}
		});
		
		Vue.component( 'product-review', {
			template: '
				<form class="review-form" @submit.prevent="onSubmit">
					
					<p v-if="errors.length">
						<b>Please correct the following error(s)</b>
						<ul>
							<li v-for="error in errors">{{ error }}</li>
						</ul>
					</p>
					<p>
						<label for="name">Name:</label>
						<input id="name" v-model="name" placeholder="name">
					</p>

					<p>
						<label for="review">Review:</label>
						<textarea id="review" v-model="review"></textarea>
					</p>

					<p>
						<label for="rating">Rating:</label>
						<select id="rating" v-model.number="rating">
						<option>5</option>
						<option>4</option>
						<option>3</option>
						<option>2</option>
						<option>1</option>
						</select>
					</p>

					<p>
						<input type="submit" value="Submit">
					</p>

				</form>
			',
			data: () -> {
				return {
					name: null,
					review: null,
					rating: null,
					errors: []
				}
			},
			methods: {
				onSubmit: () -> {
					Lib.nativeThis.errors = [];
					if( Lib.nativeThis.name != null && Lib.nativeThis.review != null && Lib.nativeThis.rating != null ) {
						final productReview = {
							name: Lib.nativeThis.name,
							review: Lib.nativeThis.review,
							rating: Lib.nativeThis.rating
						}
						eventBus.emit( 'review-submitted', productReview );
						Lib.nativeThis.name = null;
						Lib.nativeThis.review = null;
						Lib.nativeThis.rating = null;
					} else {
						if( Lib.nativeThis.name == null ) Lib.nativeThis.errors.push( "Name required." );
						if( Lib.nativeThis.review == null ) Lib.nativeThis.errors.push( "Review required." );
						if( Lib.nativeThis.rating == null ) Lib.nativeThis.errors.push( "Rating required." );
					}
				}
			}
		});

		Vue.component( 'product-tabs', {
			props: {
				reviews: {
					type: Array,
					required: true
				}
			},
			template: '
				<div>
					<div>
						<span 	class="tab" 
								:class="{ activeTab: selectedTab === tab }"
								v-for="(tab, index) in tabs"
								:key="index"
								@click="selectedTab = tab">
								{{ tab }}
								</span>
					</div>

					<div v-show="selectedTab === \'Reviews\'">
						<p v-if="!reviews.length">There are no reviews yet.</p>
						<ul>
							<li v-for="review in reviews">
								<p>{{ review.name }}</p>
								<p>Rating: {{ review.rating }}</p>
								<p>{{ review.review }}</p>
							</li>
						</ul>
					</div>

					<product-review v-show="selectedTab === \'Make a Review\'"></product-review>
				</div>
			',
			data: () -> {
				return {
					tabs:['Reviews', 'Make a Review'],
					selectedTab: 'Reviews' // set from @click
				}
			}
		});

		final app = new Vue({
			el: '#app',
			data: {
				premium: true,
				cart: []
			},
			methods: {
				updateCart: ( id ) -> Lib.nativeThis.cart.push( id )
			}
		});
	}
}
