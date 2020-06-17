Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143A91FD506
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 21:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgFQTEF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 15:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgFQTEE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 15:04:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C28C06174E;
        Wed, 17 Jun 2020 12:04:04 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t18so3522570wru.6;
        Wed, 17 Jun 2020 12:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7xgcuWwtlXFZnBIJs6APaik8rLGmHnbZMKrx6epdsHo=;
        b=deOwJ/Pj1GFoMegR3Tg605o4VnxNQWsn7H74X42Gp6aWXzrsjf3uWz/I9uQY6AqLlz
         PFnVUnv4xB7aQuGr7onQUIZyuXqkdWqKtYtf5LdEftv2Uq6hardLZpGhsnNAYgZ2BbTY
         KeOWIeWF8ejn3+Yen5u5wNVqzQ5EIFXLEVm640qiiMs2ZnLf9QnKtlqfdFsOhcUy/PJ4
         n/EIdyLPuRu0nUXnrPnt9aYEhLKA3BCn65UEcNgEVaZIcydnuHXBLZxIXCYgWfAs60DQ
         TmjSDuhqFDcMfPOxwU6EjiulrLImXIYK5AmurCDpyMDmVugCSMnBw0y6NIPSonGQr0HQ
         jbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7xgcuWwtlXFZnBIJs6APaik8rLGmHnbZMKrx6epdsHo=;
        b=hWs5QIWC2uqS0HecrbBBN7+GnfSXZL5O8YQPQEGPCjXI1G7hg1Qu4V9R8ydDZw2BEj
         0YfyHiT0wf/+eSTONpk4ENUXQpkFWDbZRjc4062wg2oqKHSW3qOmsbS+7utHz8uQqrCU
         EeSacSVxcQAnR17tkBCVhAxtCtuspBvECWCodvr5KYEmp2ynJOFAh3nEzWj3rjd/dOpD
         EYnqX0lL4iyrsUBfg8gGz5EGff+h6YY7v45NXWshsmsfYIRTEkyCddF87mFNBWdz2G5b
         Yd+RIsCeKr44f9P/JwS+9JtpVlb7/lzYLDFo7rD6g1KvK1W9vPriEYetaHDMQexgMmTY
         /UWg==
X-Gm-Message-State: AOAM532ef9doXxvs6LtNQ0PViBVHso/wGX29D2xigpbHXq1XOqErSDIq
        P0abjqwq0PpWaYvrT+BbQ1Y=
X-Google-Smtp-Source: ABdhPJzq6CXHndWVLtEUuelbADTl7dTkwspDtiwcj6b2KcdOQR0lTrow3ifX+j8YIlED+FNuQFk0YA==
X-Received: by 2002:adf:e850:: with SMTP id d16mr729457wrn.426.1592420642774;
        Wed, 17 Jun 2020 12:04:02 -0700 (PDT)
Received: from [192.168.43.243] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id r7sm633053wmh.46.2020.06.17.12.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 12:04:02 -0700 (PDT)
Subject: Re: [PATCH 1/3] fs,block: Introduce IOCB_ZONE_APPEND and direct-io
 handling
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <CGME20200617172702epcas5p4dbf4729d31d9a85ab1d261d04f238e61@epcas5p4.samsung.com>
 <1592414619-5646-2-git-send-email-joshi.k@samsung.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <174ea4b1-f0a4-3375-76ea-4f7c6808f212@gmail.com>
Date:   Wed, 17 Jun 2020 22:02:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1592414619-5646-2-git-send-email-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/06/2020 20:23, Kanchan Joshi wrote:
> From: Selvakumar S <selvakuma.s1@samsung.com>
> 
> Introduce IOCB_ZONE_APPEND flag, which is set in kiocb->ki_flags for
> zone-append. Direct I/O submission path uses this flag to send bio with
> append op. And completion path uses the same to return zone-relative
> offset to upper layer.
> 
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
> ---
>  fs/block_dev.c     | 19 ++++++++++++++++++-
>  include/linux/fs.h |  1 +
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 47860e5..4c84b4d0 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -185,6 +185,10 @@ static unsigned int dio_bio_write_op(struct kiocb *iocb)
>  	/* avoid the need for a I/O completion work item */
>  	if (iocb->ki_flags & IOCB_DSYNC)
>  		op |= REQ_FUA;
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	if (iocb->ki_flags & IOCB_ZONE_APPEND)
> +		op |= REQ_OP_ZONE_APPEND | REQ_NOMERGE;
> +#endif
>  	return op;
>  }
>  
> @@ -295,6 +299,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
>  	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);
>  }
>  
> +#ifdef CONFIG_BLK_DEV_ZONED
> +static inline long blkdev_bio_end_io_append(struct bio *bio)
> +{
> +	return (bio->bi_iter.bi_sector %
> +		blk_queue_zone_sectors(bio->bi_disk->queue)) << SECTOR_SHIFT;

IIRC, zone_size is pow2 and bit operations should suffice.
Anyway, this can use a temporary variable.

> +}
> +#endif
> +
>  static void blkdev_bio_end_io(struct bio *bio)
>  {
>  	struct blkdev_dio *dio = bio->bi_private;
> @@ -307,15 +319,20 @@ static void blkdev_bio_end_io(struct bio *bio)
>  		if (!dio->is_sync) {
>  			struct kiocb *iocb = dio->iocb;
>  			ssize_t ret;
> +			long res = 0;
>  
>  			if (likely(!dio->bio.bi_status)) {
>  				ret = dio->size;
>  				iocb->ki_pos += ret;
> +#ifdef CONFIG_BLK_DEV_ZONED
> +				if (iocb->ki_flags & IOCB_ZONE_APPEND)
> +					res = blkdev_bio_end_io_append(bio);
> +#endif
>  			} else {
>  				ret = blk_status_to_errno(dio->bio.bi_status);
>  			}
>  
> -			dio->iocb->ki_complete(iocb, ret, 0);
> +			dio->iocb->ki_complete(iocb, ret, res);
>  			if (dio->multi_bio)
>  				bio_put(&dio->bio);
>  		} else {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6c4ab4d..dc547b9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -315,6 +315,7 @@ enum rw_hint {
>  #define IOCB_SYNC		(1 << 5)
>  #define IOCB_WRITE		(1 << 6)
>  #define IOCB_NOWAIT		(1 << 7)
> +#define IOCB_ZONE_APPEND	(1 << 8)
>  
>  struct kiocb {
>  	struct file		*ki_filp;
> 

-- 
Pavel Begunkov
