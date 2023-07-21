Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120CA75CF42
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjGUQ3v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjGUQ3e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:29:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69D65BA0;
        Fri, 21 Jul 2023 09:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BCAF61CC1;
        Fri, 21 Jul 2023 16:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AF3C433C7;
        Fri, 21 Jul 2023 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689956753;
        bh=TnYLR5mP9URKTE2iskO6AsLl9hWvACyBXLDNoo0m/+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=roE/w42fYU8/mHX/hZwUvxHokR0W/uvRM4tx6isF3mzJPOdivOp1YIyIlXMHjA99q
         jVaBiQvKXs8tr8kGqvkERPnX2GmLQHAGrf665H6ZUJBoS9HiKJC2pfQG0w4K3gXyyg
         ekJHx2rkfO4MhxqaL+l+qi5zsGMfRi/e2RXTXHTR2ts+cUQWmtfks/2Z7bn3bEicUa
         W66a8stGowN8BTmxrxIsevxUEqzaxnAXDuX5gm1EkjOPkKtcatSgdg6DSjAPdwpDEB
         gR4j0jIZP+6jTzslCh5awzxSPueIfBTYNEMsVbpY40YAcIlcVZGrtNVfqV5RalfQUZ
         tgH9jzVlagQ7A==
Date:   Fri, 21 Jul 2023 09:25:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 3/9] iomap: treat a write through cache the same as FUA
Message-ID: <20230721162553.GS11352@frogsfrogsfrogs>
References: <20230721161650.319414-1-axboe@kernel.dk>
 <20230721161650.319414-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721161650.319414-4-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 21, 2023 at 10:16:44AM -0600, Jens Axboe wrote:
> Whether we have a write back cache and are using FUA or don't have
> a write back cache at all is the same situation. Treat them the same.
> 
> This makes the IOMAP_DIO_WRITE_FUA name a bit misleading, as we have
> two cases that provide stable writes:
> 
> 1) Volatile write cache with FUA writes
> 2) Normal write without a volatile write cache
> 
> Rename that flag to IOMAP_DIO_STABLE_WRITE to make that clearer, and
> update some of the FUA comments as well.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/iomap/direct-io.c | 29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index c654612b24e5..17b695b0e9d6 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -21,7 +21,7 @@
>   * iomap.h:
>   */
>  #define IOMAP_DIO_INLINE_COMP	(1 << 27)
> -#define IOMAP_DIO_WRITE_FUA	(1 << 28)
> +#define IOMAP_DIO_WRITE_THROUGH	(1 << 28)
>  #define IOMAP_DIO_NEED_SYNC	(1 << 29)
>  #define IOMAP_DIO_WRITE		(1 << 30)
>  #define IOMAP_DIO_DIRTY		(1 << 31)
> @@ -222,7 +222,7 @@ static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
>  /*
>   * Figure out the bio's operation flags from the dio request, the
>   * mapping, and whether or not we want FUA.  Note that we can end up
> - * clearing the WRITE_FUA flag in the dio request.
> + * clearing the WRITE_THROUGH flag in the dio request.
>   */
>  static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
>  		const struct iomap *iomap, bool use_fua)
> @@ -236,7 +236,7 @@ static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
>  	if (use_fua)
>  		opflags |= REQ_FUA;
>  	else
> -		dio->flags &= ~IOMAP_DIO_WRITE_FUA;
> +		dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
>  
>  	return opflags;
>  }
> @@ -276,11 +276,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		 * Use a FUA write if we need datasync semantics, this is a pure
>  		 * data IO that doesn't require any metadata updates (including
>  		 * after IO completion such as unwritten extent conversion) and
> -		 * the underlying device supports FUA. This allows us to avoid
> -		 * cache flushes on IO completion.
> +		 * the underlying device either supports FUA or doesn't have
> +		 * a volatile write cache. This allows us to avoid cache flushes
> +		 * on IO completion.
>  		 */
>  		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
> -		    (dio->flags & IOMAP_DIO_WRITE_FUA) && bdev_fua(iomap->bdev))
> +		    (dio->flags & IOMAP_DIO_WRITE_THROUGH) &&
> +		    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
>  			use_fua = true;
>  	}
>  
> @@ -560,12 +562,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  
>  		       /*
>  			* For datasync only writes, we optimistically try
> -			* using FUA for this IO.  Any non-FUA write that
> -			* occurs will clear this flag, hence we know before
> -			* completion whether a cache flush is necessary.
> +			* using WRITE_THROUGH for this IO. Stable writes are

"...using WRITE_THROUGH for this IO.  This flag requires either FUA
writes through the device's write cache, or a normal write..."

> +			* either FUA with a write cache, or a normal write to
> +			* a device without a volatile write cache. For the
> +			* former, Any non-FUA write that occurs will clear this
> +			* flag, hence we know before completion whether a cache
> +			* flush is necessary.
>  			*/
>  			if (!(iocb->ki_flags & IOCB_SYNC))
> -				dio->flags |= IOMAP_DIO_WRITE_FUA;
> +				dio->flags |= IOMAP_DIO_WRITE_THROUGH;
>  		}
>  
>  		/*
> @@ -627,10 +632,10 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		iomap_dio_set_error(dio, ret);
>  
>  	/*
> -	 * If all the writes we issued were FUA, we don't need to flush the
> +	 * If all the writes we issued were stable, we don't need to flush the

"If all the writes we issued were already written through to the media,
we don't need to flush..."

With those fixes,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


>  	 * cache on IO completion. Clear the sync flag for this case.
>  	 */
> -	if (dio->flags & IOMAP_DIO_WRITE_FUA)
> +	if (dio->flags & IOMAP_DIO_WRITE_THROUGH)
>  		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
>  
>  	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
> -- 
> 2.40.1
> 
