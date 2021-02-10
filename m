Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CCE315D00
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 03:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbhBJCNX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 21:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbhBJCLp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 21:11:45 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E8FC061574
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 18:10:59 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id n10so207626pgl.10
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 18:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6B2uUC+fh8Iv7Nm6r+ous1Q/3kUu8DTfoMNZRWLzeuA=;
        b=knbNtD7anaslUvAHKHpAJZeWCBZnVYAamPqyaXISXwJe5uGNmccSkrlk/lb9s5qFls
         5acE+rD25/U3g+MmL9lxUFDXCl5w1vRdTSq8tFikMnuHHQUkMSNpfRYTeNGkEVm7Bhay
         I70KZk9YD94Hdt/jvZ5iTTOIWFYeZ2/XN9nVyifMn25RmH+8np5eQFjQuZ5MKGZVAxDC
         qAJLIVWlJ6JPxnM/i4gTHzkSxFggtMtMzTTpjs5/fmq0MMm33L8TyU2sBcy/fd8oNoc9
         cnrvAv7r1AGwmAyQfdwoWxVBoHblmIkB5vC9f0YqNaYDxLJW7e4oIQCQFZUjDNRsUkcQ
         tXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6B2uUC+fh8Iv7Nm6r+ous1Q/3kUu8DTfoMNZRWLzeuA=;
        b=kQ+1KdBlL2GbhpYAO3SkRhwml75qNKcAM/k0nW4Z898O4LDL2nYqyfEiVQHcM0EoFB
         nflHtsQEjaNupAN92ow+SakTfZGRlw9zMNK+eVFPtSt9MuG2kwQB6QrPj6fCKjJ1dGK8
         ERG5FWTZr1JZB7MwuGUvoG6Mv/MJf75Y4A/b6VA4WjDcfekA+tUNl5LLBo61KrYeiXyu
         adbDszIoFPv08ln2d+yAHPIZ7+lyOh4C4GAegDyeKINEXYE/aG2nbaRSQShZkZsuTSLz
         P5cWpRLY/XzfY/dwI8zT5/fU4NwwWxSKhmNp+ZxHVUiirYTfaETrciBy5gfhzhmbie+c
         eQhg==
X-Gm-Message-State: AOAM533TUBqSFj3fBOn444XsDiWN77ysKJZr/woF3jJB20iL8mbrH9rI
        FMNlj7n4vejsGmK/km0NX3W+/8d+Z/TWIw==
X-Google-Smtp-Source: ABdhPJxqKz4JqP+dacN+ONOqJGQQtxi00wuxQU84CUZS8SbOZXgL4+Rr6r6+pTuFSHoW3xdJVIwIBA==
X-Received: by 2002:a05:6a00:16cd:b029:1c9:6f5b:3d8c with SMTP id l13-20020a056a0016cdb02901c96f5b3d8cmr1042111pfc.1.1612923058985;
        Tue, 09 Feb 2021 18:10:58 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p19sm292780pjo.7.2021.02.09.18.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 18:10:58 -0800 (PST)
Subject: Re: [PATCH 17/17] io_uring: defer flushing cached reqs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612915326.git.asml.silence@gmail.com>
 <e9ba205c3894e88cfbca879b386bbce19c34d150.1612915326.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0cb0e80a-2997-b5d9-3bd3-74f7f3745993@kernel.dk>
Date:   Tue, 9 Feb 2021 19:10:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e9ba205c3894e88cfbca879b386bbce19c34d150.1612915326.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/9/21 5:03 PM, Pavel Begunkov wrote:
> Awhile there are requests in the allocation cache -- use them, only if
> those ended go for the stashed memory in comp.free_list. As list
> manipulation are generally heavy and are not good for caches, flush them
> all or as much as can in one go.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 64d3f3e2e93d..17194e0d62ff 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1953,25 +1953,34 @@ static inline void io_req_complete(struct io_kiocb *req, long res)
>  	__io_req_complete(req, 0, res, 0);
>  }
>  
> +static void io_flush_cached_reqs(struct io_submit_state *state)
> +{
> +	do {
> +		struct io_kiocb *req = list_first_entry(&state->comp.free_list,
> +						struct io_kiocb, compl.list);
> +
> +		list_del(&req->compl.list);
> +		state->reqs[state->free_reqs++] = req;
> +		if (state->free_reqs == ARRAY_SIZE(state->reqs))
> +			break;
> +	} while (!list_empty(&state->comp.free_list));
> +}
> +
>  static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
>  {
>  	struct io_submit_state *state = &ctx->submit_state;
>  
>  	BUILD_BUG_ON(IO_REQ_ALLOC_BATCH > ARRAY_SIZE(state->reqs));
>  
> -	if (!list_empty(&state->comp.free_list)) {
> -		struct io_kiocb *req;
> -
> -		req = list_first_entry(&state->comp.free_list, struct io_kiocb,
> -					compl.list);
> -		list_del(&req->compl.list);
> -		return req;
> -	}
> -
>  	if (!state->free_reqs) {
>  		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
>  		int ret;
>  
> +		if (!list_empty(&state->comp.free_list)) {
> +			io_flush_cached_reqs(state);
> +			goto out;
> +		}

I think that'd be cleaner as:

	if (io_flush_cached_reqs(state))
		goto got_req;

and have io_flush_cached_reqs() return true/false depending on what it did.

-- 
Jens Axboe

