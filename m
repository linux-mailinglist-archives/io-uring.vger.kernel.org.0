Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02B1401EA2
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 18:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbhIFQnW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 12:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhIFQnV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 12:43:21 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38626C061575
        for <io-uring@vger.kernel.org>; Mon,  6 Sep 2021 09:42:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d5so4628606pjx.2
        for <io-uring@vger.kernel.org>; Mon, 06 Sep 2021 09:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HYsM5OYIUPQEfKu40HECI8v18D5MIHHqHItVXWTlUxs=;
        b=XNmPPh6HANzn4mQ/x/hLWFTL0c26xysz9Gk1It9StqeqkV8zDNWMgGK228t8X3O2D+
         IVrfcgV3dZjUUHXFAiWz4F7NxNcIn4nT7tQCjutHMajMQxmdb+iFlNBUzNqFnqTQ5ee4
         HtYC4t4RHMr19wShmNZiwK3cLlq6bQg+Bk7VNzuSs/hI2mR3hENjUKP/NwdF9LdTlvwK
         gPkFczdlgtQtYVxE7K20Nf0HMs+pARdhtnBFSoV4/JnElB+n9cK+fowpSTGXjs6ldRcq
         oEGihXmdWhtR5+QDwpR8O6XcpErSaN3qx4PW8DVrixw4PiYbz5eTzs4d8Fkl5J9X/t4/
         hsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HYsM5OYIUPQEfKu40HECI8v18D5MIHHqHItVXWTlUxs=;
        b=Jl2SrajKrcomCpAunOitSko8diSb+VFn2rlXzD+4pngmyKJiFfAlB+a8bKQd4hxiSL
         162qdCOgGNrR3tOGCgXFhBhWQlAfu7I6V1GHU3Lgn33KLHI7z3iMEhriq98MjEOvhxVY
         yvXWghLOHXbJDngt7I/7AvIw7uBSD8GkaV1N8dEsBIncVYyRrRHy2J5i9lnc1OoGRECn
         sdk4SQ1Te5aXh5e2BQsPZ3sY1OypM5d10zizGYjfg0xeGyr7r2dz7AyuVC1FSrg+6B/N
         X3VSILrnyW04zpxs4HV4w9Fl3C1UPxVLVlkg9BI3bLhDrAdVganM8V+60AA//kCS7veB
         itqw==
X-Gm-Message-State: AOAM531s+9WV3XBAqNN6SuUV4VQ3YZgOx+C7OJMoUIjAenwFNZ5VVFTU
        M14Si+/kN28LA2HfBJVMwz1fCw==
X-Google-Smtp-Source: ABdhPJzpBMukTxICan22gMo58pzFJz/1Hn0ZmAhvcPMyST1YUAc0u8kx3COqklo5Slo9AHFg6yyhfw==
X-Received: by 2002:a17:90b:3ec7:: with SMTP id rm7mr34732pjb.124.1630946536527;
        Mon, 06 Sep 2021 09:42:16 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 126sm8384398pfv.72.2021.09.06.09.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 09:42:16 -0700 (PDT)
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
 <95387504-3986-77df-7cb4-d136dd4be1ec@linux.alibaba.com>
 <c61bfb5a-036d-43be-e896-239b1c8ca1c3@kernel.dk>
 <701e50f5-2444-5b56-749b-1c1affc26ce9@gmail.com>
 <f332dbc6-5304-9676-ffc1-008e153d667b@kernel.dk>
 <c8298d9a-bef8-8128-ada6-b2edfabad292@linux.alibaba.com>
 <be69610d-a615-c826-b376-298a617bc2f0@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0328b6fe-9100-1ae4-e3cc-9dccc36ed141@kernel.dk>
Date:   Mon, 6 Sep 2021 10:42:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <be69610d-a615-c826-b376-298a617bc2f0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/21 9:32 AM, Pavel Begunkov wrote:
> On 9/6/21 1:35 PM, Hao Xu wrote:
>> 在 2021/9/6 上午3:44, Jens Axboe 写道:
>>> On 9/4/21 4:46 PM, Pavel Begunkov wrote:
>>>> On 9/4/21 7:40 PM, Jens Axboe wrote:
>>>>> On 9/4/21 9:34 AM, Hao Xu wrote:
>>>>>> 在 2021/9/4 上午12:29, Jens Axboe 写道:
>>>>>>> On 9/3/21 5:00 AM, Hao Xu wrote:
>>>>>>>> Update io_accept_prep() to enable multishot mode for accept operation.
>>>>>>>>
>>>>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>>>>> ---
>>>>>>>>    fs/io_uring.c | 14 ++++++++++++--
>>>>>>>>    1 file changed, 12 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>>> index eb81d37dce78..34612646ae3c 100644
>>>>>>>> --- a/fs/io_uring.c
>>>>>>>> +++ b/fs/io_uring.c
>>>>>>>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>>    static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>>    {
>>>>>>>>        struct io_accept *accept = &req->accept;
>>>>>>>> +    bool is_multishot;
>>>>>>>>           if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>>>>>>            return -EINVAL;
>>>>>>>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>>        accept->flags = READ_ONCE(sqe->accept_flags);
>>>>>>>>        accept->nofile = rlimit(RLIMIT_NOFILE);
>>>>>>>>    +    is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>>>>>>>> +    if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>>>>>>>> +        return -EINVAL;
>>>>>>>
>>>>>>> I like the idea itself as I think it makes a lot of sense to just have
>>>>>>> an accept sitting there and generating multiple CQEs, but I'm a bit
>>>>>>> puzzled by how you pass it in. accept->flags is the accept4(2) flags,
>>>>>>> which can currently be:
>>>>>>>
>>>>>>> SOCK_NONBLOCK
>>>>>>> SOCK_CLOEXEC
>>>>>>>
>>>>>>> While there's not any overlap here, that is mostly by chance I think. A
>>>>>>> cleaner separation is needed here, what happens if some other accept4(2)
>>>>>>> flag is enabled and it just happens to be the same as
>>>>>>> IORING_ACCEPT_MULTISHOT?
>>>>>> Make sense, how about a new IOSQE flag, I saw not many
>>>>>> entries left there.
>>>>>
>>>>> Not quite sure what the best approach would be... The mshot flag only
>>>>> makes sense for a few request types, so a bit of a shame to have to
>>>>> waste an IOSQE flag on it. Especially when the flags otherwise passed in
>>>>> are so sparse, there's plenty of bits there.
>>>>>
>>>>> Hence while it may not be the prettiest, perhaps using accept->flags is
>>>>> ok and we just need some careful code to ensure that we never have any
>>>>> overlap.
>>>>
>>>> Or we can alias with some of the almost-never-used fields like
>>>> ->ioprio or ->buf_index.
>>>
>>> It's not a bad idea, as long as we can safely use flags from eg ioprio
>>> for cases where ioprio would never be used. In that sense it's probably
>>> safer than using buf_index.
>>>
>>> The alternative is, as has been brougt up before, adding a flags2 and
>>> reserving the last flag in ->flags to say "there are flags in flags2".
>>> Not exactly super pretty either, but we'll need to extend them at some
>>> point.
>> I'm going to do it in this way, there is another thing we have to do:
>> extend req->flags too, since flags we already used > 32 if we add
>> sqe->ext_flags
> 
> We still have 2 bits left, and IIRC you wanted to take only 1 of them.
> We don't need extending it at the moment, it sounded to me like a plan
> for the future. No extra trouble for now

Right, and it should be a separate thing anyway. But as you say, there's
still 2 bits left, this is more about longer term planning than this
particular patchset.

> Anyway, I can't think of many requests working in this mode, and I think
> sqe_flags should be taken only for features applicable to all (~most) of
> requests. Maybe we'd better to fit it individually into accept in the
> end? Sounds more plausible tbh

That's why I suggested making it op private instead, I don't
particularly like having io_uring wide flags that are only applicable to
a (very) small subset of requests. And there's also precedence here
already in terms of poll supporting mshot with a private flag.

-- 
Jens Axboe

