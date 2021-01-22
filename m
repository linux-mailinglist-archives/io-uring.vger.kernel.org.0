Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF502FFF86
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 10:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbhAVJtj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jan 2021 04:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbhAVJpz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jan 2021 04:45:55 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82132C06178B
        for <io-uring@vger.kernel.org>; Fri, 22 Jan 2021 01:45:15 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id g15so3335434pgu.9
        for <io-uring@vger.kernel.org>; Fri, 22 Jan 2021 01:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=41FF8P+aINFDEIt7lk2b02nP5pWVj+Sf9m2PTgqq1jE=;
        b=ULscACPQJ6RNVT43/pW8OFXq4bcjDnA1elY91LwWTuhkoCVh0FBBQdkczb2ZiMXDo+
         aCsOaRBTIc3qqf70FrZKN7POSIEzPwxxJMmj4EVj1NO1VfXppjcmc8HgNTku23xQPDj3
         11QUbqCr/prsWHRbJ3ysE2cPG1c7chYM23jNjxb+fbvqexVeez1Nqm/gfHei6PIN9FKW
         IaXBR7WGhBF9/muPE2shblRjt+iJMCuEud5jOcOya8WdonLPTsffO336UxR1MJ1ZyqEA
         w+tIkB5n2uYsfxdotf66Ka/XWapTNh9sz3bVh5rtQHjyTYbxnm7L276uRqoO9mXFJ1eW
         GxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=41FF8P+aINFDEIt7lk2b02nP5pWVj+Sf9m2PTgqq1jE=;
        b=MXyLtO+6mJ7ihI6sJt6NgQcHz1dKZoqETtl7pNaqpoqEwj7clOwyJ+TnbTxYwnlq2s
         gLL1FSwagE8DYihIPuCVTi0YLF2KDdSyPz+6mahw8w6GzbU8JWiveWic8XuXrvHYfWi/
         dp3BMF9rDLKDpFrIlm2CcMvV/cv77s/HziKYiLsgeb16lIpQU2k6PE792zGk6Bj3zi4k
         8aRB/eU+GjpvL7oTK72hdZwbdGDY2ad0U+aektv127OyEEFVlv9ubdeHE1heKvCts8/a
         xMKYZnvofalGXkNq67LF0UyMaRGyVWkxHHIcPRshdPCj1hZ9Jd7m3Z0W37pECBpcEuDE
         5ZtQ==
X-Gm-Message-State: AOAM5319Vg5Gl1vlwSgYtr9AhAWlCgZ/u0hF/o1cpSd/hERCWsjttFU0
        RsQdIw2DaVWEiHNT3u5UvGDUu97amDY=
X-Google-Smtp-Source: ABdhPJxn33uZdX78AXsWe1EA/0O0qO1Na2N7481n9a3AR8W9mfNiIrlrx4/T2QRs/eTUP68yynDx7g==
X-Received: by 2002:a05:6a00:238b:b029:1b4:af1d:d3ff with SMTP id f11-20020a056a00238bb02901b4af1dd3ffmr3864479pfc.66.1611308714717;
        Fri, 22 Jan 2021 01:45:14 -0800 (PST)
Received: from B-D1K7ML85-0059.local ([47.89.83.85])
        by smtp.gmail.com with ESMTPSA id gf23sm8522688pjb.42.2021.01.22.01.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 01:45:14 -0800 (PST)
Subject: Re: [PATCH 0/3] files cancellation cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1611109718.git.asml.silence@gmail.com>
From:   Joseph Qi <jiangqi903@gmail.com>
Message-ID: <246d838d-0fce-d3c3-dcfc-9cbf9fa72de1@gmail.com>
Date:   Fri, 22 Jan 2021 17:45:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <cover.1611109718.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Seems this series can also resolve a possible deadlock case I'm looking
into.

CPU0:
...
io_kill_linked_timeout  // &ctx->completion_lock
io_commit_cqring
__io_queue_deferred
__io_queue_async_work
io_wq_enqueue
io_wqe_enqueue  // &wqe->lock

CPU1:
...
__io_uring_files_cancel
io_wq_cancel_cb
io_wqe_cancel_pending_work  // &wqe->lock
io_cancel_task_cb  // &ctx->completion_lock

Thanks,
Joseph

On 1/20/21 10:32 AM, Pavel Begunkov wrote:
> Carefully remove leftovers from removing cancellations by files
> 
> Pavel Begunkov (3):
>   io_uring: remove cancel_files and inflight tracking
>   io_uring: cleanup iowq cancellation files matching
>   io_uring: don't pass files for cancellation
> 
>  fs/io_uring.c | 168 ++++++++++----------------------------------------
>  1 file changed, 32 insertions(+), 136 deletions(-)
> 
