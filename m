Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B198400D60
	for <lists+io-uring@lfdr.de>; Sun,  5 Sep 2021 00:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhIDWri (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Sep 2021 18:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbhIDWrh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Sep 2021 18:47:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA78C061575
        for <io-uring@vger.kernel.org>; Sat,  4 Sep 2021 15:46:35 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o39-20020a05600c512700b002e74638b567so2075493wms.2
        for <io-uring@vger.kernel.org>; Sat, 04 Sep 2021 15:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5SNrx75khQuBuWJRSWtmrn25YI7M7cveFi7fOSNnYMw=;
        b=nHK3TeGvi9FXA1YKzMKYzNAlXYd7jca7202CUmh4BjnyYnmgKXL62pQEbEchOykC7U
         BqvK6HkEvh5AloVn90LkIvEtABPnOzbeIJteKKiXdL09SVqYzr2XAJZvlLPnS2gNf1S1
         Gjtb3W8AaD3HdhmR0uSqu6MEY6OOGUVIMJAlTHQCGQL7Xqa1xErd4UZbjfDMUBrrn8KL
         SkAkdEne03afMph6GpS7BRuoBJLLY7+eNuYwbkahM2Xf5AgUN+imlh6WM71PXzZvx2l9
         vorLzOHxPhEEv8IVWK5gL8q1sf4ZqnUvZM3Cynz7Hxove1z6zdPlthuPfzxTiG7QY8zQ
         742w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5SNrx75khQuBuWJRSWtmrn25YI7M7cveFi7fOSNnYMw=;
        b=IAQwZdiediPVpaLHd5I6STohanNj6el/Ouuo5QaPEeqk8H7B73r0rsY1Er3eVJmVKi
         RMc8r8Gsf8K+mT+CenvH2bgo3UmJHQcRMzW15y1+w4LXVCQa9FyfMwA6D+LcqBi5ndJE
         u+r6lghjJcD+kXCZflceEnylZ98dEHYT676pk/3zu6Xl5Oj15VujccqA1g9Q8C5k8yRL
         4sK3WLM0beq9CNUFIGaSduX9IydIo8J3oj322JBooG74alrHHsfX5n4qGIHGALO7Quld
         gir/MHiFyKCfqQlAC/g8a12PqIWGA97OzbOjkbM+zAwXhwVsj2WaYMDQBynDWloz3WAQ
         IyKA==
X-Gm-Message-State: AOAM532Y9sKrTc9ONgCs/VVCjsu1tBaPkL6EVd3hH4YA28cpYCXlIrSJ
        5tDku1PbdbumRyXLDsv8vs5XWmwFpgw=
X-Google-Smtp-Source: ABdhPJxOFmfHTvNpnPx5GaQO8XnJKjIbMwF1viGTQc86SByB26JkPrvDOzV5zgWiMVfh5vu3xEmhqg==
X-Received: by 2002:a1c:2310:: with SMTP id j16mr4713098wmj.185.1630795593852;
        Sat, 04 Sep 2021 15:46:33 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id i4sm3563319wmd.5.2021.09.04.15.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Sep 2021 15:46:33 -0700 (PDT)
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
 <95387504-3986-77df-7cb4-d136dd4be1ec@linux.alibaba.com>
 <c61bfb5a-036d-43be-e896-239b1c8ca1c3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <701e50f5-2444-5b56-749b-1c1affc26ce9@gmail.com>
Date:   Sat, 4 Sep 2021 23:46:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c61bfb5a-036d-43be-e896-239b1c8ca1c3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/4/21 7:40 PM, Jens Axboe wrote:
> On 9/4/21 9:34 AM, Hao Xu wrote:
>> 在 2021/9/4 上午12:29, Jens Axboe 写道:
>>> On 9/3/21 5:00 AM, Hao Xu wrote:
>>>> Update io_accept_prep() to enable multishot mode for accept operation.
>>>>
>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>> ---
>>>>   fs/io_uring.c | 14 ++++++++++++--
>>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index eb81d37dce78..34612646ae3c 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>>   static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>   {
>>>>   	struct io_accept *accept = &req->accept;
>>>> +	bool is_multishot;
>>>>   
>>>>   	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>>   		return -EINVAL;
>>>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>   	accept->flags = READ_ONCE(sqe->accept_flags);
>>>>   	accept->nofile = rlimit(RLIMIT_NOFILE);
>>>>   
>>>> +	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>>>> +	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>>>> +		return -EINVAL;
>>>
>>> I like the idea itself as I think it makes a lot of sense to just have
>>> an accept sitting there and generating multiple CQEs, but I'm a bit
>>> puzzled by how you pass it in. accept->flags is the accept4(2) flags,
>>> which can currently be:
>>>
>>> SOCK_NONBLOCK
>>> SOCK_CLOEXEC
>>>
>>> While there's not any overlap here, that is mostly by chance I think. A
>>> cleaner separation is needed here, what happens if some other accept4(2)
>>> flag is enabled and it just happens to be the same as
>>> IORING_ACCEPT_MULTISHOT?
>> Make sense, how about a new IOSQE flag, I saw not many
>> entries left there.
> 
> Not quite sure what the best approach would be... The mshot flag only
> makes sense for a few request types, so a bit of a shame to have to
> waste an IOSQE flag on it. Especially when the flags otherwise passed in
> are so sparse, there's plenty of bits there.
> 
> Hence while it may not be the prettiest, perhaps using accept->flags is
> ok and we just need some careful code to ensure that we never have any
> overlap.

Or we can alias with some of the almost-never-used fields like
->ioprio or ->buf_index.

> Probably best to solve that issue in include/linux/net.h, ala:
> 
> /* Flags for socket, socketpair, accept4 */
> #define SOCK_CLOEXEC	O_CLOEXEC
> #ifndef SOCK_NONBLOCK
> #define SOCK_NONBLOCK	O_NONBLOCK
> #endif
> 
> /*
>  * Only used for io_uring accept4, and deliberately chosen to overlap
>  * with the O_* file bits for read/write mode so we won't risk overlap
>  * other flags added for socket/socketpair/accept4 use in the future.
>  */
> #define SOCK_URING_MULTISHOT	00000001
> 
> which should be OK, as these overlap with the O_* filespace and the
> read/write bits are at the start of that space.
> 
> Should be done as a prep patch and sent out to netdev as well, so we can
> get their sign-off on this "hack". If we can get that done, then we have
> our flag and we can just stuff it in accept->flags as long as we clear
> it before calling into accept from io_uring.
> 

-- 
Pavel Begunkov
