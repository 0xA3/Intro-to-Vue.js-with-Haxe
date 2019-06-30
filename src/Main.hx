import js.Lib;

class Main {
	
	static function main() {
		
		final app = new Vue({
			el: '#app',
			data: {
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
				inStock: () -> Lib.nativeThis.variants[Lib.nativeThis.selectedVariant].variantQuantity
			}
		});
	}
}
