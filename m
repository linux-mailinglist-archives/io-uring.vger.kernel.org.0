Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81065233629
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 17:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgG3P7s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 11:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgG3P7r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 11:59:47 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3232C061574;
        Thu, 30 Jul 2020 08:59:46 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id f24so8002355ejx.6;
        Thu, 30 Jul 2020 08:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wd33f2D/h4PcgaV0nXqpx6aSm+kT8PptW8Hl5mbozss=;
        b=I0OErlVkq4M4V9d9PqGtUTwFzQlckaRlAv5g5goQ1OWGmpd3mdLo5VdoGTyZEtnBHw
         YA2jM82jJWn0+xh2h3j+0M06FrU/RrDMUOvEI+ONUMnd4+oHKAPlzsvHwWuBX42ETUz2
         Rpu46zOORipC9fgep425koBRNg7op90I/UFQ10FzjSNzglY2pyeUv7hkGG49UJ2G5WSd
         4l+pwX2VnOwWYR0wzXLHUdzizDOFEEkiRXprHZXTuUYUTTgyPtXP8FG4OJ/pwayxTVxR
         1nnjDDIiChH9mhNJ41MIxjfJSyPQt415Kc4JZUdU9FA2N1MH3adQgjmpTpi67Km9RP2o
         aghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wd33f2D/h4PcgaV0nXqpx6aSm+kT8PptW8Hl5mbozss=;
        b=CaqmGIMPSEY2rnfFlcoOubw/bl2yvhE3p6TcfA84qVDTLbZbLE91DUPv3lJVblExBz
         ur+4T+VTFB0oUJFJ99vtFJMXt+ctTlrXoYA/sIKioh8/7qnmk3soV/+99HkC0Ir4eeoz
         OvfNfk9YGdZ7KhYRW3kibPDVvEGA+Dnjd/kwwFpec8IX8ECwhEuQgxIWQZfwN6f13znK
         Q12oc/RL2eumvdPPbo4ssBXBF0qVZNE9500ACYlPbQgXVaaVNqvpO6qJwT9fwxh+qpOn
         KFPtTjll1KdeqSjuCtu1eRbzYp90C1yMrV1PW3hoDs6ZC35b+NAS0uByMPOiB+6XMJTs
         RttQ==
X-Gm-Message-State: AOAM532UC0tevfv68bDIMlG+pcf77Fe2lJ2XjnwOrtD89n/uyklNFDzq
        69Jkklj5kQZoPnyQdT1ap5g=
X-Google-Smtp-Source: ABdhPJz5eB+KGh2glC/CMjn1WMXD9J6IpdbmzIjCrVaMZrLYoDjmJ/5uKKzl8GKS4Nw6YiIgZZ2lfQ==
X-Received: by 2002:a17:906:b046:: with SMTP id bj6mr3370177ejb.349.1596124785467;
        Thu, 30 Jul 2020 08:59:45 -0700 (PDT)
Received: from [192.168.43.105] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id lc18sm6525610ejb.29.2020.07.30.08.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 08:59:44 -0700 (PDT)
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, bcrl@kvack.org
Cc:     willy@infradead.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-api@vger.kernel.org,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6@epcas5p3.samsung.com>
 <1595605762-17010-7-git-send-email-joshi.k@samsung.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
Message-ID: <2d3c8287-55cf-0150-acd6-19feb9e85771@gmail.com>
Date:   Thu, 30 Jul 2020 18:57:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1595605762-17010-7-git-send-email-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/07/2020 18:49, Kanchan Joshi wrote:
> From: SelvaKumar S <selvakuma.s1@samsung.com>
> 
> Repurpose [cqe->res, cqe->flags] into cqe->res64 (signed) to report
> 64bit written-offset for zone-append. The appending-write which requires
> reporting written-location (conveyed by IOCB_ZONE_APPEND flag) is
> ensured not to be a short-write; this avoids the need to report
> number-of-bytes-copied.
> append-offset is returned by lower-layer to io-uring via ret2 of
> ki_complete interface. Make changes to collect it and send to user-space
> via cqe->res64.
> 
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
> ---
>  fs/io_uring.c                 | 49 ++++++++++++++++++++++++++++++++++++-------
>  include/uapi/linux/io_uring.h |  9 ++++++--
>  2 files changed, 48 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7809ab2..6510cf5 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
...
> @@ -1244,8 +1254,15 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>  		req->flags &= ~REQ_F_OVERFLOW;
>  		if (cqe) {
>  			WRITE_ONCE(cqe->user_data, req->user_data);
> -			WRITE_ONCE(cqe->res, req->result);
> -			WRITE_ONCE(cqe->flags, req->cflags);
> +			if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
> +				if (likely(req->result > 0))
> +					WRITE_ONCE(cqe->res64, req->rw.append_offset);
> +				else
> +					WRITE_ONCE(cqe->res64, req->result);
> +			} else {
> +				WRITE_ONCE(cqe->res, req->result);
> +				WRITE_ONCE(cqe->flags, req->cflags);
> +			}
>  		} else {
>  			WRITE_ONCE(ctx->rings->cq_overflow,
>  				atomic_inc_return(&ctx->cached_cq_overflow));
> @@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
>  	cqe = io_get_cqring(ctx);
>  	if (likely(cqe)) {
>  		WRITE_ONCE(cqe->user_data, req->user_data);
> -		WRITE_ONCE(cqe->res, res);
> -		WRITE_ONCE(cqe->flags, cflags);
> +		if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
> +			if (likely(res > 0))
> +				WRITE_ONCE(cqe->res64, req->rw.append_offset);

1. as I mentioned before, that's not not nice to ignore @cflags
2. that's not the right place for opcode specific handling
3. it doesn't work with overflowed reqs, see the final else below

For this scheme, I'd pass @append_offset as an argument. That should
also remove this extra if from the fast path, which Jens mentioned.

> +			else
> +				WRITE_ONCE(cqe->res64, res);
> +		} else {
> +			WRITE_ONCE(cqe->res, res);
> +			WRITE_ONCE(cqe->flags, cflags);
> +		}
>  	} else if (ctx->cq_overflow_flushed) {
>  		WRITE_ONCE(ctx->rings->cq_overflow,
>  				atomic_inc_return(&ctx->cached_cq_overflow));
> @@ -1943,7 +1967,7 @@ static inline void req_set_fail_links(struct io_kiocb *req)
>  		req->flags |= REQ_F_FAIL_LINK;
>  }
>  


-- 
Pavel Begunkov
