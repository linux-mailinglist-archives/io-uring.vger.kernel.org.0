Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9111B1607
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2020 21:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgDTTkp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Apr 2020 15:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgDTTkp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Apr 2020 15:40:45 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA07C061A0C
        for <io-uring@vger.kernel.org>; Mon, 20 Apr 2020 12:40:45 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a32so315796pje.5
        for <io-uring@vger.kernel.org>; Mon, 20 Apr 2020 12:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=crfRAQ43ge1CHQV5uG3ZCQRSUiv0vgP1i6rewJuDm8w=;
        b=PNkN3a33VBD76bwnRlQGAdcoo4qu3vBYufcWqh9DvJiLUNX3qUhCDJur/R4f81+NyC
         Li1t2ZcZz8PU8ATF5r1EjhFu/niv8mpCTMQJaykbL7kc9WyhYmGzMY2GD/sxLFWhnYhk
         KnqnPQ08Fu8fGYlOC8tow8pDIiCzbNh5uqm8x+/p0lks84VDLDX2aPWhxgLr1z6dcbeD
         vt9y01ezFHCFMzCPh2PPL+9R0icCE4zhNL3jLDam+/pXGvh3LTJGyPeGV81+uVCHIDp5
         ZTWIX7790gMBPi4f5h4cJwVkbJpaT/tzoObaMf5nOk9eFOuHcip1labMqSKXOp/NE42a
         p6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=crfRAQ43ge1CHQV5uG3ZCQRSUiv0vgP1i6rewJuDm8w=;
        b=VAYp+ETdumbt189eguGPjD8+0abGE+YSM5bfU7LiOO1A+PeudC9YT8rMnO4vnQK8t7
         /zOjh/H9teg3cc/s6ft+/8ClPI+AIPfnnobpLH1qnE4ybON+LMkr8hBAs6IZTXb/NM2+
         5nVYR6MKRf8ni37eWAEmNt7tMYUYh+3G42VQyHWBWBB56GaTDqb4RoIwY/p0cPZopjf/
         kxuQAIphQZobuWzMioUvlQUdSMJKSrOnDz7CuRcbbSMhcyY8hxAj7FqSkj3RqFoZw9G8
         Avm0WWzbgGKOsMlyZ3TNqFK1Ng+Lyd2w2bTlEaip/xptcDEdBPrle6z8LNzRNJ1GLbji
         VXEA==
X-Gm-Message-State: AGi0Pub9SYQDqwxsF4AFt+zSZyEtnimB6y5nbMl0OM3kw8mKJ5mvxIjf
        V5+U3YpL9sc+tH86OJgQjDxQmA==
X-Google-Smtp-Source: APiQypLeJdTJ2fJM1do4hReG8gEvplWurwkuXAVWnImM5hulRFvatqG5fZlyRHR9/wqsYonnONJJEw==
X-Received: by 2002:a17:90a:ad02:: with SMTP id r2mr1158906pjq.63.1587411644566;
        Mon, 20 Apr 2020 12:40:44 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id l30sm162213pje.34.2020.04.20.12.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 12:40:44 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: trigger timeout after any sqe->off CQEs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1587229607.git.asml.silence@gmail.com>
 <28005ea0de63e15dbffd87a49fe9b671f1afa87e.1587229607.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <88cbde3c-52a1-7fb3-c4a7-b548beaa5502@kernel.dk>
Date:   Mon, 20 Apr 2020 13:40:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <28005ea0de63e15dbffd87a49fe9b671f1afa87e.1587229607.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/20 11:20 AM, Pavel Begunkov wrote:
> +static void __io_flush_timeouts(struct io_ring_ctx *ctx)
> +{
> +	u32 end, start;
> +
> +	start = end = ctx->cached_cq_tail;
> +	do {
> +		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
> +							struct io_kiocb, list);
> +
> +		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
> +			break;
> +		/*
> +		 * multiple timeouts may have the same target,
> +		 * check that @req is in [first_tail, cur_tail]
> +		 */
> +		if (!io_check_in_range(req->timeout.target_cq, start, end))
> +			break;
> +
> +		list_del_init(&req->list);
> +		io_kill_timeout(req);
> +		end = ctx->cached_cq_tail;
> +	} while (!list_empty(&ctx->timeout_list));
> +}
> +
>  static void io_commit_cqring(struct io_ring_ctx *ctx)
>  {
>  	struct io_kiocb *req;
>  
> -	while ((req = io_get_timeout_req(ctx)) != NULL)
> -		io_kill_timeout(req);
> +	if (!list_empty(&ctx->timeout_list))
> +		__io_flush_timeouts(ctx);
>  
>  	__io_commit_cqring(ctx);
>  

Any chance we can do this without having to iterate timeouts on the
completion path?

-- 
Jens Axboe

