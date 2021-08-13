Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378C73EBD35
	for <lists+io-uring@lfdr.de>; Fri, 13 Aug 2021 22:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhHMURw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 16:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234198AbhHMURv (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 13 Aug 2021 16:17:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B5F4610CC;
        Fri, 13 Aug 2021 20:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628885844;
        bh=BSAHNaF2hq41VI5supF0uF+3EBwFFPHhfcd9ufAOMmM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MAwG61mOYN7IhRo4JZHLdA0ZCaTjY7dxtcDwP4gVtPQ2m4eO3ZeJF1xPFzBJBacIA
         /8sRDlI5ULE+UyJGNPtkT+wBX6J1uadgg9dVzNAJB+k4cjrNzFI/xnRO4Kz5vdQxR5
         cUMGI9U+IbZNcGifM12lQMuirGg+TkM0jH07xUTFh3GzpUhSdqsrTZmt5yQG76ydGr
         FTTmXs6+TufDl7NxLyzIoAqwmkfYRqfwcuXheWiskKLDao/Rlj9XAJrDDvsL3LWgnQ
         +gELDoXB+RhTBZLYLaBzEZsiJi8tg4tVh5IOEiFBiCUKkNwhkbpBQCj/+HCX3njaGS
         71fH6tWIgxZug==
Date:   Fri, 13 Aug 2021 13:17:22 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 4/6] block: clear BIO_PERCPU_CACHE flag if polling isn't
 supported
Message-ID: <20210813201722.GB2661@dhcp-10-100-145-180.wdc.com>
References: <20210812154149.1061502-1-axboe@kernel.dk>
 <20210812154149.1061502-5-axboe@kernel.dk>
 <20210812173143.GA3138953@dhcp-10-100-145-180.wdc.com>
 <b60e0031-77b0-fe27-2b52-437ba21babcb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b60e0031-77b0-fe27-2b52-437ba21babcb@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 12, 2021 at 11:41:58AM -0600, Jens Axboe wrote:
> Indeed. Wonder if we should make that a small helper, as any clear of
> REQ_HIPRI should clear BIO_PERCPU_CACHE as well.
> 
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 7e852242f4cc..d2722ecd4d9b 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -821,11 +821,8 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
>  		}
>  	}
>  
> -	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags)) {
> -		/* can't support alloc cache if we turn off polling */
> -		bio_clear_flag(bio, BIO_PERCPU_CACHE);
> -		bio->bi_opf &= ~REQ_HIPRI;
> -	}
> +	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> +		bio_clear_hipri(bio);

Since BIO_PERCPU_CACHE doesn't work without REQ_HIRPI, should this check
look more like this?

	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
		bio->bi_opf &= ~REQ_HIPRI;
	if (!(bio->bi_opf & REQ_HIPRI))
		bio_clear_flag(bio, BIO_PERCPU_CACHE);

I realise the only BIO_PERCPU_CACHE user in this series never sets it
without REQ_HIPRI, but it looks like a problem waiting to happen if
nothing enforces this pairing: someone could set the CACHE flag on a
QUEUE_FLAG_POLL enabled queue without setting HIPRI and get the wrong
bio_put() action.
