Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DEE401DA3
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 17:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhIFPdl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 11:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbhIFPdl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 11:33:41 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134F5C061575
        for <io-uring@vger.kernel.org>; Mon,  6 Sep 2021 08:32:36 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g135so4865546wme.5
        for <io-uring@vger.kernel.org>; Mon, 06 Sep 2021 08:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4DuIOQxH0Sf64MumXBEm1V9tgRig1Lv2JcqSMOmoGgg=;
        b=ZDGStvwK2OJwBcGBKDHY2gTRgC5mL8GdWqMCgU3G5KnkR/bqDibw/rNhM6lVwyLOaS
         9qujyOm3Yg8MnJ1HrrGsLgu6y4vJgfMyI0WE5kUPmmno5TrkXpqkrwqb0Ml8Nym2AH9/
         EeYK1fS310peLlMx1hYoBEhWuI5spcQdehD8USe6CGvA63HzdeBGsBTf7m3+mJtNkuEq
         XSpPYAbUnuakV3QRrw/dJVdypjq5/r4MDFX7y9dzM3u9HuUzVgDlRxO18BiWcozvhswq
         fl0Nza2u8CwSaX4/sNyioRhNrGnGm9nZDUBms1o4JyLXjMw5YxNPUA9w/yI2qHXorr6W
         yJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4DuIOQxH0Sf64MumXBEm1V9tgRig1Lv2JcqSMOmoGgg=;
        b=nTvAKbXl1Z9EfwIuvUW2IsRNbS2IQHClrqdQvZm0hJC6cthbX1CMk6IeptgHJ7EDCH
         jcMLcM1JC1c0Y0VPRSNcWnZTSkeItGxNYMihLkCpWBnralgeauMCA5lfN9l2DeFHLbHA
         q70Z2b+u1V7ywec9dM1hh8jsNodv7ZpohYv4rB2adSHYitbFau2qLy8poN+Y8ASLF6h9
         K9Uxb2g8TWYOsJVK2yIc/m5om56XPzcXTssj3Dv9YR/Ohc8ZjQhdBkQq+X1XfGNI/nft
         Zb/DwSTvuAxHod++KpC3gQ4RAAhWgPsId5DOVVELNNTJtdNGkJVzKfjScEd1hOYiis60
         VcKQ==
X-Gm-Message-State: AOAM530Lb1WrkXw3c4uJB9AogEwRxE3tHJzJkQbsFkqfNXBMg5t/VZss
        HoUsbqMCria2GWTDE3BDZXJCwfp71VM=
X-Google-Smtp-Source: ABdhPJzKH6mU0p2xzCyO86H7OAVyUMDS72SFNLbtfEuHdh3w+73tNLvO4kPEOn8OKgIOKVRXc/jSEg==
X-Received: by 2002:a1c:ed0a:: with SMTP id l10mr12313748wmh.140.1630942354630;
        Mon, 06 Sep 2021 08:32:34 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.4])
        by smtp.gmail.com with ESMTPSA id c13sm8225541wru.73.2021.09.06.08.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 08:32:34 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
 <95387504-3986-77df-7cb4-d136dd4be1ec@linux.alibaba.com>
 <c61bfb5a-036d-43be-e896-239b1c8ca1c3@kernel.dk>
 <701e50f5-2444-5b56-749b-1c1affc26ce9@gmail.com>
 <f332dbc6-5304-9676-ffc1-008e153d667b@kernel.dk>
 <c8298d9a-bef8-8128-ada6-b2edfabad292@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
Message-ID: <be69610d-a615-c826-b376-298a617bc2f0@gmail.com>
Date:   Mon, 6 Sep 2021 16:32:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c8298d9a-bef8-8128-ada6-b2edfabad292@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/21 1:35 PM, Hao Xu wrote:
> 在 2021/9/6 上午3:44, Jens Axboe 写道:
>> On 9/4/21 4:46 PM, Pavel Begunkov wrote:
>>> On 9/4/21 7:40 PM, Jens Axboe wrote:
>>>> On 9/4/21 9:34 AM, Hao Xu wrote:
>>>>> 在 2021/9/4 上午12:29, Jens Axboe 写道:
>>>>>> On 9/3/21 5:00 AM, Hao Xu wrote:
>>>>>>> Update io_accept_prep() to enable multishot mode for accept operation.
>>>>>>>
>>>>>>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>>>>>>> ---
>>>>>>>    fs/io_uring.c | 14 ++++++++++++--
>>>>>>>    1 file changed, 12 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>> index eb81d37dce78..34612646ae3c 100644
>>>>>>> --- a/fs/io_uring.c
>>>>>>> +++ b/fs/io_uring.c
>>>>>>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>    static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>    {
>>>>>>>        struct io_accept *accept = &req->accept;
>>>>>>> +    bool is_multishot;
>>>>>>>           if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>>>>>            return -EINVAL;
>>>>>>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>        accept->flags = READ_ONCE(sqe->accept_flags);
>>>>>>>        accept->nofile = rlimit(RLIMIT_NOFILE);
>>>>>>>    +    is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>>>>>>> +    if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>>>>>>> +        return -EINVAL;
>>>>>>
>>>>>> I like the idea itself as I think it makes a lot of sense to just have
>>>>>> an accept sitting there and generating multiple CQEs, but I'm a bit
>>>>>> puzzled by how you pass it in. accept->flags is the accept4(2) flags,
>>>>>> which can currently be:
>>>>>>
>>>>>> SOCK_NONBLOCK
>>>>>> SOCK_CLOEXEC
>>>>>>
>>>>>> While there's not any overlap here, that is mostly by chance I think. A
>>>>>> cleaner separation is needed here, what happens if some other accept4(2)
>>>>>> flag is enabled and it just happens to be the same as
>>>>>> IORING_ACCEPT_MULTISHOT?
>>>>> Make sense, how about a new IOSQE flag, I saw not many
>>>>> entries left there.
>>>>
>>>> Not quite sure what the best approach would be... The mshot flag only
>>>> makes sense for a few request types, so a bit of a shame to have to
>>>> waste an IOSQE flag on it. Especially when the flags otherwise passed in
>>>> are so sparse, there's plenty of bits there.
>>>>
>>>> Hence while it may not be the prettiest, perhaps using accept->flags is
>>>> ok and we just need some careful code to ensure that we never have any
>>>> overlap.
>>>
>>> Or we can alias with some of the almost-never-used fields like
>>> ->ioprio or ->buf_index.
>>
>> It's not a bad idea, as long as we can safely use flags from eg ioprio
>> for cases where ioprio would never be used. In that sense it's probably
>> safer than using buf_index.
>>
>> The alternative is, as has been brougt up before, adding a flags2 and
>> reserving the last flag in ->flags to say "there are flags in flags2".
>> Not exactly super pretty either, but we'll need to extend them at some
>> point.
> I'm going to do it in this way, there is another thing we have to do:
> extend req->flags too, since flags we already used > 32 if we add
> sqe->ext_flags

We still have 2 bits left, and IIRC you wanted to take only 1 of them.
We don't need extending it at the moment, it sounded to me like a plan
for the future. No extra trouble for now

Anyway, I can't think of many requests working in this mode, and I think
sqe_flags should be taken only for features applicable to all (~most) of
requests. Maybe we'd better to fit it individually into accept in the
end? Sounds more plausible tbh

p.s. yes, there is IOSQE_BUFFER_SELECT, but I don't think that was the
best solution, but in any case it's history.

-- 
Pavel Begunkov
