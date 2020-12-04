Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0979E2CED71
	for <lists+io-uring@lfdr.de>; Fri,  4 Dec 2020 12:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbgLDLsI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Dec 2020 06:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbgLDLsI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Dec 2020 06:48:08 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB9EC0613D1;
        Fri,  4 Dec 2020 03:47:27 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id g14so4999505wrm.13;
        Fri, 04 Dec 2020 03:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UclILjREAUdtSCUnNunr1tBo79Qe+ptgrQIOw+TFsoM=;
        b=IZJp/928EbYWlLCdaAxmvn43bZP4sYw40tYOrIOI3CdMqabuLncFThj9ZskC2xlqTw
         /h93HBKSWW7KGlwkf6DYp2F2ykACszeUDxs3PKy2AvcoZGJZHddxeEhDjWUlSKs1wski
         fvNf/3c8IkhFUjNZHYQ9rRNC7+PaySvoNusa5+LfGsc7Lyxd3oL6vXRnirHJUmGwAh+6
         3mMnqm7NRHbI39/5+z+sfO9dYuqQsPf/gV3mDCaOR/jo/iVdVkZaASOtTITixwFTNVpP
         qyFGNTL2qQIRHtRyxOEHDYYBs2IyKN7oFBbEmJdwBfdEAXCNi5agy1lMaIoJLr4o+JOX
         oY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UclILjREAUdtSCUnNunr1tBo79Qe+ptgrQIOw+TFsoM=;
        b=kW+szsF0qfBE7TB9mlicZV4OLn4epWFXdeW0dRA+X2sbsAdTxmEg6qtZ1BOcD5DBqy
         Ik5kFHmPwld0l/6ww5I7B/UfpuTbni4mZBDkG5IFznmEcKj2d6xNbtBl55/XG8DTRi1W
         /JFY/xFqRzEsQWNPO6wYPkIBNh6xJIWNjcNKxM99u9GeFdXC/goxRipL/NAxqiWB0SxM
         VQgmB5Pw+c1j3PA+4Gjc/lTeYs825s/r7xJpYpUaKwhp/v62ZuUAJQvZFmpGuhnQJhTM
         IcAJddTYJXEEeuVeDet/FEojNbIqijvrOOESrdX2eaQxK5RrmJMd9BTu0tzfYm0L/qEl
         LrCg==
X-Gm-Message-State: AOAM532e3jg2KpnszCiYndnpnJ5XWfFPBiBkaKKJGOV2c3wfqBwqbFa1
        SF6hrz4HrqmwZMPpJjH/etvZ+cLqKNZUreI/
X-Google-Smtp-Source: ABdhPJw+zzAIT76+0aIQMwoRW4rYVeC9sXvMQvmUnFTeVJ7Z6HxCwbu3zAQSqY3c9tPaFvyRoRFv1w==
X-Received: by 2002:a5d:5146:: with SMTP id u6mr4762003wrt.66.1607082446373;
        Fri, 04 Dec 2020 03:47:26 -0800 (PST)
Received: from [192.168.1.118] (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id h20sm2742058wmb.29.2020.12.04.03.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 03:47:25 -0800 (PST)
To:     Hao Xu <haoxu@linux.alibaba.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        linux-block@vger.kernel.org
References: <1607075096-94235-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 RESEND] iomap: set REQ_NOWAIT according to IOCB_NOWAIT
 in Direct IO
Message-ID: <e1faa714-7cb5-977f-1a87-5244adebe90d@gmail.com>
Date:   Fri, 4 Dec 2020 11:44:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1607075096-94235-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/12/2020 09:44, Hao Xu wrote:
> Currently, IOCB_NOWAIT is ignored in Direct IO, REQ_NOWAIT is only set
> when IOCB_HIPRI is set. But REQ_NOWAIT should be set as well when
> IOCB_NOWAIT is set.

I believe Jens took my patch fixing that for blkdev_direct_IO*()
(but not iomap) a while ago.

BTW, even though get_maintainer.pl doesn't think so, AFAIK
fs/block_dev.c is managed by linux-block@vger.kernel.org. Please CC it
next time.

> Suggested-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> Hi all,
> I tested fio io_uring direct read for a file on ext4 filesystem on a
> nvme ssd. I found that IOCB_NOWAIT is ignored in iomap layer, which
> means REQ_NOWAIT is not set in bio->bi_opf. This makes nowait IO a
> normal IO. Since I'm new to iomap and block layer, I sincerely ask
> yours opinions in case I misunderstand the code which is very likely
> to happen.:)
> The example I use: io_uring direct randread, the first try is with
> IOCB_NOWAIT but not IOCB_HIPRI, the IOCB_NOWAIT is ignored in block
> layer which I think is not the designed behaviour.
> 
> I found that Konstantin found this issue before in May
> 2020 (https://www.spinics.net/lists/linux-block/msg53275.html), here add
> his signature, add Jeffle's as well since he gave me some help.
> 
> v1->v2:
> * add same logic in __blkdev_direct_IO_simple()
> v2->v3:
> * add same logic in do_blockdev_direct_IO()
> 
>  fs/block_dev.c       | 7 +++++++
>  fs/direct-io.c       | 6 ++++--
>  fs/iomap/direct-io.c | 3 +++
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 9e84b1928b94..ca6f365c2f14 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -263,6 +263,10 @@ static void blkdev_bio_end_io_simple(struct bio *bio)
>  		bio.bi_opf = dio_bio_write_op(iocb);
>  		task_io_account_write(ret);
>  	}
> +
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		bio.bi_opf |= REQ_NOWAIT;
> +
>  	if (iocb->ki_flags & IOCB_HIPRI)
>  		bio_set_polled(&bio, iocb);
>  
> @@ -417,6 +421,9 @@ static void blkdev_bio_end_io(struct bio *bio)
>  			task_io_account_write(bio->bi_iter.bi_size);
>  		}
>  
> +		if (iocb->ki_flags & IOCB_NOWAIT)
> +			bio->bi_opf |= REQ_NOWAIT;
> +
>  		dio->size += bio->bi_iter.bi_size;
>  		pos += bio->bi_iter.bi_size;
>  
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index d53fa92a1ab6..b221ed351c1c 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -1206,11 +1206,13 @@ static inline int drop_refcount(struct dio *dio)
>  	if (iov_iter_rw(iter) == WRITE) {
>  		dio->op = REQ_OP_WRITE;
>  		dio->op_flags = REQ_SYNC | REQ_IDLE;
> -		if (iocb->ki_flags & IOCB_NOWAIT)
> -			dio->op_flags |= REQ_NOWAIT;
>  	} else {
>  		dio->op = REQ_OP_READ;
>  	}
> +
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		dio->op_flags |= REQ_NOWAIT;
> +
>  	if (iocb->ki_flags & IOCB_HIPRI)
>  		dio->op_flags |= REQ_HIPRI;
>  
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 933f234d5bec..2e897688ed6d 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -64,6 +64,9 @@ static void iomap_dio_submit_bio(struct iomap_dio *dio, struct iomap *iomap,
>  {
>  	atomic_inc(&dio->ref);
>  
> +	if (dio->iocb->ki_flags & IOCB_NOWAIT)
> +		bio->bi_opf |= REQ_NOWAIT;
> +
>  	if (dio->iocb->ki_flags & IOCB_HIPRI)
>  		bio_set_polled(bio, dio->iocb);
>  
> 

-- 
Pavel Begunkov
