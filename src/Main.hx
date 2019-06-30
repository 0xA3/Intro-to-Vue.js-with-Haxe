import js.Lib;

class Main {
	
	static function main() {

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
					
					<div class="cart">
						<p>Cart({{ cart }})</p>
					</div>
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
				cart: 0
			},
			methods: {
				addToCart: () -> Lib.nativeThis.cart += 1,
				updateProduct: ( index ) -> Lib.nativeThis.selectedVariant = index
			},
			computed: {
				title: () -> '${Lib.nativeThis.brand} ${Lib.nativeThis.product}',
				image: () -> Lib.nativeThis.variants[Lib.nativeThis.selectedVariant].variantImage,
				inStock: () -> Lib.nativeThis.variants[Lib.nativeThis.selectedVariant].variantQuantity,
				shipping: () -> Lib.nativeThis.premium ? "Free" : "2.99"

			}
		});
		
		final app = new Vue({
			el: '#app',
			data: {
				premium: true
			}
		});
	}
}
