Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC52D362BF2
	for <lists+io-uring@lfdr.de>; Sat, 17 Apr 2021 01:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhDPXmf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 19:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbhDPXmf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 19:42:35 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04388C061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 16:42:10 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n127so3303556wmb.5
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 16:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kCkJUUGP/jAneol4/6D3/WWnKggJA199JkwaCpkdsNI=;
        b=hHnKPVrqr3dh8l3NIsmSC5s9T+Awc1kYZ0vRnB3mHnsEY72JQrwnd1E0MqLBHjz6Y4
         Mir3cqa3K+5O+vOlfwM2sAdh1fh9O2kEZCMlYeX0XIyfCCmAG7sA2Sy1JNn066dlbGBH
         tSc3xaafQA5A7sce5v4oC310F/jMUv+U+M4OFHZ4M+jYgLT0G33RTTLCV6RqovKAT/DZ
         EuETOo8tD/0Tpbgyreq6gDSzFcye/7ZpxJ7JqsSaX/jIPFoWonzNHCri1ceJb7GQ1mvB
         1tUUqUBqijwZqYFD+5LeJwUmm0+2cRpUXm0HRALREtqVicoZukEKlxpmqJeRbbdUSesb
         urWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kCkJUUGP/jAneol4/6D3/WWnKggJA199JkwaCpkdsNI=;
        b=Psr8tGSuTL2QiLqN1c/yp3WeXi9Pef+BV1VNgJkk/Mv6VfsC1QPDy8k9GZx9vMLQP4
         7aLZGNOGO1DAkV3lQ5tJp8jGJPOtmEw7RDfjAsKHMWopDtGUkBODB+8hvkD1v8GsNvUU
         QMivmIlsZb91ASZW4EzRkCa15A+nAhxeVj8ZR3jNOXMOX+JXZWJdtD4gPogtFGSY0Hlm
         4Bo2akebbU1QTy85YNsvRHsU4DPGkE0WiWvq1KjlSHIVK6RgdGIX3+THNhR35Zvq7n3b
         DozAx+eof16rG9M7LiG74mqt++bbMWhQ2QyOO/+ohq64t2/N2XHrrMVLwONWUfsnFg1I
         ymLA==
X-Gm-Message-State: AOAM532+EnecuoPDTC795Bva8zLwmh1wXx9E57Pifa69uXRA9JKuY0Du
        RqCX/9RBuYOYwaxNYE79WsZymkBnqdM8gw==
X-Google-Smtp-Source: ABdhPJx4bgC2yOBNcP4OxnoTmUUcUNj1g6+Hxvis2eRDtZvSwwx+c7KiRXpW5ye1E4eyJrGEvAD6+Q==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr10296884wmk.52.1618616527894;
        Fri, 16 Apr 2021 16:42:07 -0700 (PDT)
Received: from [192.168.8.194] ([148.252.132.77])
        by smtp.gmail.com with ESMTPSA id i15sm11379784wrr.73.2021.04.16.16.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 16:42:07 -0700 (PDT)
Subject: Re: [PATCH 2/3] io_uring: put flag checking for needing req cleanup
 in one spot
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20210416161018.879915-1-axboe@kernel.dk>
 <20210416161018.879915-3-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <0451cd0b-1f86-9a36-ed61-d68f99ccd90f@gmail.com>
Date:   Sat, 17 Apr 2021 00:37:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210416161018.879915-3-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/04/2021 17:10, Jens Axboe wrote:
> We have this in two spots right now, which is a bit fragile. In
> preparation for moving REQ_F_POLLED cleanup into the same spot, move
> the check into a separate helper so we only have it once.

Perfect, others look good to me as well

> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 4803e31e9301..8e6dcb69f3e9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1598,10 +1598,15 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
>  	}
>  }
>  
> +static inline bool io_req_needs_clean(struct io_kiocb *req)
> +{
> +	return req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP);
> +}
> +
>  static void io_req_complete_state(struct io_kiocb *req, long res,
>  				  unsigned int cflags)
>  {
> -	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
> +	if (io_req_needs_clean(req))
>  		io_clean_op(req);
>  	req->result = res;
>  	req->compl.cflags = cflags;
> @@ -1713,10 +1718,8 @@ static void io_dismantle_req(struct io_kiocb *req)
>  
>  	if (!(flags & REQ_F_FIXED_FILE))
>  		io_put_file(req->file);
> -	if (flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
> -		     REQ_F_INFLIGHT)) {
> +	if (io_req_needs_clean(req) || (req->flags & REQ_F_INFLIGHT)) {
>  		io_clean_op(req);
> -
>  		if (req->flags & REQ_F_INFLIGHT) {
>  			struct io_uring_task *tctx = req->task->io_uring;
>  
> 

-- 
Pavel Begunkov
