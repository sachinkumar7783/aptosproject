module MyModule::DigitalArtGallery {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;

    /// Struct representing a digital art piece.
    struct ArtPiece has store, key {
        title: vector<u8>,      // Title of the art piece
        price: u64,             // Price of the art piece in tokens
        is_sold: bool,          // Whether the art piece has been sold
    }

    /// Function for an artist to list a digital art piece for sale.
    public fun list_art(artist: &signer, title: vector<u8>, price: u64) {
        let art = ArtPiece {
            title,
            price,
            is_sold: false,
        };
        move_to(artist, art);
    }

    /// Function for a buyer to purchase a listed art piece.
    public fun purchase_art(buyer: &signer, artist_address: address) acquires ArtPiece {
        let art = borrow_global_mut<ArtPiece>(artist_address);

        // Ensure the art piece has not been sold
        assert!(!art.is_sold, 1);

        // Transfer the price from the buyer to the artist
        let payment = coin::withdraw<AptosCoin>(buyer, art.price);
        coin::deposit<AptosCoin>(artist_address, payment);

        // Mark the art piece as sold
        art.is_sold = true;
    }
}
