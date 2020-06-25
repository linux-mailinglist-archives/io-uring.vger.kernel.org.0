Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D48120A604
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 21:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406766AbgFYTmC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 15:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406069AbgFYTmB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 15:42:01 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421D8C08C5C1;
        Thu, 25 Jun 2020 12:42:01 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u26so7396194wmn.1;
        Thu, 25 Jun 2020 12:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5d7yXKsJreT4Cu2Emc3DWVDyO2KlqiIjpk5Uc0grAno=;
        b=HjfSUyCJNlrbOK3ZphHfy1CFNMGdjX43SUMxvrEDi0TC+s0SRLvtxkr7LJYiEVYIJ2
         41zxxwb0xG7lo1OxhQfdinh5CyAV75rQ9ao1jrv7zd12YLt7ZKxDQzolrswIrWf6O+xc
         VsNGN88J8CNZ4QC7cnadRnEwVbsr1Mu5VuT5lQ8pDfkgEvBd1mhQzQGnCR1jBQxLbgRx
         0Tsx51nEqHZl54c+S97Ii5DXnMQFYroicheOAoSdlzEfqYFRfsTLMYJxmPrGcbEmCS/c
         6NKQ2g4UbLQ18KNH4cDHlwe5/4P2zDqcQos8etaYgqYDdME49pXkFP/obHDg9bQR8ULM
         /DzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5d7yXKsJreT4Cu2Emc3DWVDyO2KlqiIjpk5Uc0grAno=;
        b=iszhr9hJvmpfn8rbp6OYIvkuvAcj1eGz38wN3bR2UdoasSqpCUmbLSBhvIQYbrmp7w
         FBDPtPlciZGQimN+H1+ZzplV+74Dd7czro4aJVmi11KADoiZJbRoWPm8lXvQitt89VBn
         PmLqpeqe8JuI27yBqrY9i9leN14vxDZ7UWBY9s8jMaU+1zsHddH1y30qsuYLGOHjJDd5
         n8d1JmW0B5lQtNtE0B4dj1JToSMPRGekvRJjXbcC9SBCaMqgFbfvKtVVUNMvoZBIqTlA
         tDgqgK74fOTXkiOaRs3cPiSr+FtO+YephxkXyXnmRDTgoiCMUKAeEPzUBTt8kZxbIXBA
         zb4g==
X-Gm-Message-State: AOAM533NpFxip1DpE2Q7KAZfEWmZ3X/GSOgbDD44hQvJ0o/az7oWwNcO
        UbaqFKbjMbRqGmlJcKxaFQ0haouoYeE=
X-Google-Smtp-Source: ABdhPJzP2TnATqF19pBthUKOaGqcad72qTWZ4up9MKhpGE4rVgHCsc9RU27lXnQ8I7ETdE8/+uPH4Q==
X-Received: by 2002:a1c:2503:: with SMTP id l3mr5049987wml.188.1593114119871;
        Thu, 25 Jun 2020 12:41:59 -0700 (PDT)
Received: from [192.168.43.154] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id d201sm13529261wmd.34.2020.06.25.12.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 12:41:59 -0700 (PDT)
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     Damien.LeMoal@wdc.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, mb@lightnvm.io,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        selvakuma.s1@samsung.com, nj.shetty@samsung.com,
        javier.gonz@samsung.com
References: <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
 <CGME20200625171838epcas5p449183e12770187142d8d55a9bf422a8d@epcas5p4.samsung.com>
 <1593105349-19270-3-git-send-email-joshi.k@samsung.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 2/2] io_uring: add support for zone-append
Message-ID: <e84be715-923d-90a2-f3c6-3cd2503ca69b@gmail.com>
Date:   Thu, 25 Jun 2020 22:40:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1593105349-19270-3-git-send-email-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/06/2020 20:15, Kanchan Joshi wrote:
> From: Selvakumar S <selvakuma.s1@samsung.com>
> 
> For zone-append, block-layer will return zone-relative offset via ret2
> of ki_complete interface. Make changes to collect it, and send to
> user-space using ceq->flags.
> Detect and report early error if zone-append is requested with
> fixed-buffers.
> 
> Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
> ---
>  fs/io_uring.c | 32 ++++++++++++++++++++++++++++++--
>  1 file changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 155f3d8..31a9da58 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -402,6 +402,8 @@ struct io_rw {
>  	struct kiocb			kiocb;
>  	u64				addr;
>  	u64				len;
> +	/* zone-relative offset for append, in sectors */
> +	u32			append_offset;
>  };
>  
>  struct io_connect {
> @@ -541,6 +543,7 @@ enum {
>  	REQ_F_NO_FILE_TABLE_BIT,
>  	REQ_F_QUEUE_TIMEOUT_BIT,
>  	REQ_F_WORK_INITIALIZED_BIT,
> +	REQ_F_ZONE_APPEND_BIT,
>  
>  	/* not a real bit, just to check we're not overflowing the space */
>  	__REQ_F_LAST_BIT,
> @@ -598,6 +601,8 @@ enum {
>  	REQ_F_QUEUE_TIMEOUT	= BIT(REQ_F_QUEUE_TIMEOUT_BIT),
>  	/* io_wq_work is initialized */
>  	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
> +	/* to return zone relative offset for zone append*/
> +	REQ_F_ZONE_APPEND	= BIT(REQ_F_ZONE_APPEND_BIT),

Do we need a new flag? We can check for IOCB_ZONE_APPEND, flags are always
close by in req->rw.kiocb.ki_flags. May require to be careful about not
setting it for read, so not screwing buf select.

>  };
>  
>  struct async_poll {
> @@ -1745,6 +1750,8 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>  
>  		if (req->flags & REQ_F_BUFFER_SELECTED)
>  			cflags = io_put_kbuf(req);
> +		if (req->flags & REQ_F_ZONE_APPEND)
> +			cflags = req->rw.append_offset;
>  
>  		__io_cqring_fill_event(req, req->result, cflags);
>  		(*nr_events)++;
> @@ -1943,7 +1950,7 @@ static inline void req_set_fail_links(struct io_kiocb *req)
>  		req->flags |= REQ_F_FAIL_LINK;
>  }
>  
> -static void io_complete_rw_common(struct kiocb *kiocb, long res)
> +static void io_complete_rw_common(struct kiocb *kiocb, long res, long res2)
>  {
>  	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
>  	int cflags = 0;
> @@ -1953,8 +1960,14 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
>  
>  	if (res != req->result)
>  		req_set_fail_links(req);
> +
>  	if (req->flags & REQ_F_BUFFER_SELECTED)
>  		cflags = io_put_kbuf(req);
> +
> +	/* use cflags to return zone append completion result */
> +	if (req->flags & REQ_F_ZONE_APPEND)
> +		cflags = res2;
> +
>  	__io_cqring_add_event(req, res, cflags);
>  }
>  
> @@ -1962,7 +1975,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
>  {
>  	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
>  
> -	io_complete_rw_common(kiocb, res);
> +	io_complete_rw_common(kiocb, res, res2);
>  	io_put_req(req);
>  }
>  
> @@ -1975,6 +1988,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
>  
>  	if (res != req->result)
>  		req_set_fail_links(req);
> +	if (req->flags & REQ_F_ZONE_APPEND)
> +		req->rw.append_offset = res2;
> +
>  	req->result = res;
>  	if (res != -EAGAIN)
>  		WRITE_ONCE(req->iopoll_completed, 1);
> @@ -2127,6 +2143,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  	if (kiocb->ki_flags & IOCB_NOWAIT)
>  		req->flags |= REQ_F_NOWAIT;
>  
> +	if (kiocb->ki_flags & IOCB_ZONE_APPEND)
> +		req->flags |= REQ_F_ZONE_APPEND;
> +
>  	if (force_nonblock)
>  		kiocb->ki_flags |= IOCB_NOWAIT;
>  
> @@ -2409,6 +2428,14 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>  
>  	opcode = req->opcode;
>  	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
> +		/*
> +		 * fixed-buffers not supported for zone-append.
> +		 * This check can be removed when block-layer starts
> +		 * supporting append with iov_iter of bvec type
> +		 */
> +		if (req->flags == REQ_F_ZONE_APPEND)

s/==/&/

> +			return -EINVAL;
> +
>  		*iovec = NULL;
>  		return io_import_fixed(req, rw, iter);
>  	}
> @@ -2704,6 +2731,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
>  		req->rw.kiocb.ki_flags &= ~IOCB_NOWAIT;
>  
>  	req->result = 0;
> +

Extra \n

>  	io_size = ret;
>  	if (req->flags & REQ_F_LINK_HEAD)
>  		req->result = io_size;
> 

-- 
Pavel Begunkov
