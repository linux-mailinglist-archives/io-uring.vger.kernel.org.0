Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5237720F77E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 16:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730997AbgF3Oqy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 10:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgF3Oqx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 10:46:53 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C473C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:46:53 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id h28so16517774edz.0
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wghaAbfyDFGyPUK1mmCYaaGGcYp73KDRNm+CVhCYUv0=;
        b=TDkQWrXn9MVecEM+rjeUJ2U4hxHrKrB+uKspNe2AUzd56sYgza2wFh2QZ4X1fcuRMg
         /TB8hQXKdkRmomrvc/ZYGkBEEGs2GBmUQywlGoZxOa9X651yvrNF4mFHhC4UaSkp/sWN
         GoLIQkWpyiKs89Fugc3g6wgiKX0uK9oe4TGVv4Ypbr9roJLQq6jWKEJu7akH9k0FJess
         9Fk8es+ujce9s5w0ZxlLeHqMV3hPRMTAouk/29I4bOnjnZS6lj/btMGWPjam+gjOdfZv
         XiPnu3mXqD06NITTHBD1HZwLay3H9RayZDUBZfHpyWhIvlj2ZuEkiGzYMPNEDUst1uuM
         Utgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wghaAbfyDFGyPUK1mmCYaaGGcYp73KDRNm+CVhCYUv0=;
        b=VOpdMCicj3zNvXBZ5+VTGCrrkRw3Vj2MJIcsR6T//YOMmVSoBd5FglZLxT9tXmuZOA
         Z6aSp28dRnOVXsrcI5zOu+tcmV9kkbjohlE1UjvVJlm4LOR6dpzFhBLe9B3AKpynmwk2
         Ufr2Xa113OJrPu6eioMKs5mKRTqrvcX1iuHK6Fo0aDTLqA1OmqEoxiJ8wmTqiIjrSQGJ
         6ZeVXcBz1WMvD8Jm7aabmCP9eokgqW3kEfeZ7v52gT8YcPGaO2484r7VG/4psJijjMhB
         gGFJtXYDiMnAfvDEzdZuyy0Z1E5e0ycOlknqMuzfEreE5YUXW+wzUpycL8WYutiyBYz/
         j2DQ==
X-Gm-Message-State: AOAM5325oJqAyrPtYfuqe+ecqyuBNQoC1scwMQHX0lWRUGj7aR3/qtOf
        yqixG+eIo6UCcO7NpN83iSTgt7eC
X-Google-Smtp-Source: ABdhPJxU25z6yLQBLMIkZsmvYIG5eRp2v0SD8DwaKKweEjNaMt1FvZrGp64sQyiIdbdZ1XFXSl4gnw==
X-Received: by 2002:a50:c219:: with SMTP id n25mr23668217edf.306.1593528411594;
        Tue, 30 Jun 2020 07:46:51 -0700 (PDT)
Received: from [192.168.43.125] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id cd11sm2209497ejb.57.2020.06.30.07.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 07:46:50 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1593519186.git.asml.silence@gmail.com>
 <a306de0c1e191b12bb4183b26f4df3e66b2a770c.1593519186.git.asml.silence@gmail.com>
 <12778c43-c890-c983-29a1-fe732e39fec5@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/8] io_uring: fix io_fail_links() locking
Message-ID: <a4abc5d0-6c65-1de6-1097-5b67a62cb37f@gmail.com>
Date:   Tue, 30 Jun 2020 17:45:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <12778c43-c890-c983-29a1-fe732e39fec5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/06/2020 17:38, Jens Axboe wrote:
> On 6/30/20 6:20 AM, Pavel Begunkov wrote:
>> 86b71d0daee05 ("io_uring: deduplicate freeing linked timeouts")
>> actually fixed one bug, where io_fail_links() doesn't consider
>> REQ_F_COMP_LOCKED, but added another -- io_cqring_fill_event()
>> without any locking
>>
>> Return locking back there and do it right with REQ_F_COMP_LOCKED
>> check.
> 
> Something like the below is much better, and it also makes it so that
> the static analyzers don't throw a fit. I'm going to fold this into
> the original.

Good point about analyzers, even uninitialised flags there is a warning.
This pattern usually prevents inlining, but don't care about
io_fail_links().

> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e1410ff31892..a0aea78162a6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1600,7 +1600,7 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
>  /*
>   * Called if REQ_F_LINK_HEAD is set, and we fail the head request
>   */
> -static void io_fail_links(struct io_kiocb *req)
> +static void __io_fail_links(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  
> @@ -1620,6 +1620,23 @@ static void io_fail_links(struct io_kiocb *req)
>  	io_cqring_ev_posted(ctx);
>  }
>  
> +static void io_fail_links(struct io_kiocb *req)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	if (!(req->flags & REQ_F_COMP_LOCKED)) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&ctx->completion_lock, flags);
> +		__io_fail_links(req);
> +		spin_unlock_irqrestore(&ctx->completion_lock, flags);
> +	} else {
> +		__io_fail_links(req);
> +	}
> +
> +	io_cqring_ev_posted(ctx);
> +}
> +
>  static void io_req_find_next(struct io_kiocb *req, struct io_kiocb **nxt)
>  {
>  	if (likely(!(req->flags & REQ_F_LINK_HEAD)))
> 

-- 
Pavel Begunkov
