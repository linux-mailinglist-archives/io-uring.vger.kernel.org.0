Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BA42EE808
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 22:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbhAGVzv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 16:55:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727897AbhAGVzv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 16:55:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610056464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQxmIDqzaedRbnlCPKoFGCvuFhDnRbV9Q5RchM71+Tk=;
        b=dN91uMFSF2v8cQXsAI1BejRZ6hjNoyEToxQEVbZtEnLw4anD+r3YW5aDnohUqkXTJqkhlj
        P8GXbaf5gyJI9cHCtDWFIsPF/gOXoQMl/L6969wJD7PYQPEf0qsMQbkOEau0AdiN4JEOwm
        JUySGxsF+xzUQM2798eSXniWOqHUDtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-yYgM9F01OjCXNFqdCaiQ-w-1; Thu, 07 Jan 2021 16:54:20 -0500
X-MC-Unique: yYgM9F01OjCXNFqdCaiQ-w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37B40190A7A0;
        Thu,  7 Jan 2021 21:54:19 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A06360BF1;
        Thu,  7 Jan 2021 21:54:15 +0000 (UTC)
Date:   Thu, 7 Jan 2021 16:54:15 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 5/7] dm: always return BLK_QC_T_NONE for bio-based
 device
Message-ID: <20210107215415.GE21239@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-6-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223112624.78955-6-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23 2020 at  6:26am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Currently the returned cookie of bio-based device is not used at all.
> 
> In the following patches, bio-based device will actually return a
> pointer to a specific object as the returned cookie.

In the following patch, ...

> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

> ---
>  drivers/md/dm.c | 26 ++++++++++----------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 5b2f371ec4bb..03c2b867acaa 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1252,14 +1252,13 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
>  }
>  EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
>  
> -static blk_qc_t __map_bio(struct dm_target_io *tio)
> +static void __map_bio(struct dm_target_io *tio)
>  {
>  	int r;
>  	sector_t sector;
>  	struct bio *clone = &tio->clone;
>  	struct dm_io *io = tio->io;
>  	struct dm_target *ti = tio->ti;
> -	blk_qc_t ret = BLK_QC_T_NONE;
>  
>  	clone->bi_end_io = clone_endio;
>  
> @@ -1278,7 +1277,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
>  	case DM_MAPIO_REMAPPED:
>  		/* the bio has been remapped so dispatch it */
>  		trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);
> -		ret = submit_bio_noacct(clone);
> +		submit_bio_noacct(clone);
>  		break;
>  	case DM_MAPIO_KILL:
>  		free_tio(tio);
> @@ -1292,8 +1291,6 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
>  		DMWARN("unimplemented target map return value: %d", r);
>  		BUG();
>  	}
> -
> -	return ret;
>  }
>  
>  static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
> @@ -1380,7 +1377,7 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
>  	}
>  }
>  
> -static blk_qc_t __clone_and_map_simple_bio(struct clone_info *ci,
> +static void __clone_and_map_simple_bio(struct clone_info *ci,
>  					   struct dm_target_io *tio, unsigned *len)
>  {
>  	struct bio *clone = &tio->clone;
> @@ -1391,7 +1388,7 @@ static blk_qc_t __clone_and_map_simple_bio(struct clone_info *ci,
>  	if (len)
>  		bio_setup_sector(clone, ci->sector, *len);
>  
> -	return __map_bio(tio);
> +	__map_bio(tio);
>  }
>  
>  static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
> @@ -1405,7 +1402,7 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
>  
>  	while ((bio = bio_list_pop(&blist))) {
>  		tio = container_of(bio, struct dm_target_io, clone);
> -		(void) __clone_and_map_simple_bio(ci, tio, len);
> +		__clone_and_map_simple_bio(ci, tio, len);
>  	}
>  }
>  
> @@ -1450,7 +1447,7 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
>  		free_tio(tio);
>  		return r;
>  	}
> -	(void) __map_bio(tio);
> +	__map_bio(tio);
>  
>  	return 0;
>  }
> @@ -1565,11 +1562,10 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
>  /*
>   * Entry point to split a bio into clones and submit them to the targets.
>   */
> -static blk_qc_t __split_and_process_bio(struct mapped_device *md,
> +static void __split_and_process_bio(struct mapped_device *md,
>  					struct dm_table *map, struct bio *bio)
>  {
>  	struct clone_info ci;
> -	blk_qc_t ret = BLK_QC_T_NONE;
>  	int error = 0;
>  
>  	init_clone_info(&ci, md, map, bio);
> @@ -1613,7 +1609,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
>  
>  				bio_chain(b, bio);
>  				trace_block_split(b, bio->bi_iter.bi_sector);
> -				ret = submit_bio_noacct(bio);
> +				submit_bio_noacct(bio);
>  				break;
>  			}
>  		}
> @@ -1621,13 +1617,11 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
>  
>  	/* drop the extra reference count */
>  	dec_pending(ci.io, errno_to_blk_status(error));
> -	return ret;
>  }
>  
>  static blk_qc_t dm_submit_bio(struct bio *bio)
>  {
>  	struct mapped_device *md = bio->bi_disk->private_data;
> -	blk_qc_t ret = BLK_QC_T_NONE;
>  	int srcu_idx;
>  	struct dm_table *map;
>  
> @@ -1657,10 +1651,10 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
>  	if (is_abnormal_io(bio))
>  		blk_queue_split(&bio);
>  
> -	ret = __split_and_process_bio(md, map, bio);
> +	__split_and_process_bio(md, map, bio);
>  out:
>  	dm_put_live_table(md, srcu_idx);
> -	return ret;
> +	return BLK_QC_T_NONE;
>  }
>  
>  /*-----------------------------------------------------------------
> -- 
> 2.27.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

