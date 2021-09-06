Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CAA401C51
	for <lists+io-uring@lfdr.de>; Mon,  6 Sep 2021 15:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242474AbhIFNdF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Sep 2021 09:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241526AbhIFNc6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Sep 2021 09:32:58 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF485C061575
        for <io-uring@vger.kernel.org>; Mon,  6 Sep 2021 06:31:53 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f129so6848534pgc.1
        for <io-uring@vger.kernel.org>; Mon, 06 Sep 2021 06:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r6pD3nqf5YZJfd7oARZuMlgtyxTG1WAuFZjNoAswQjU=;
        b=S8H/DYsfUsFZZmKxaGzNeOXzE4uj5bCDFsO1rW9ipg6YL5QylA1S48mW/Tlgc5aUkp
         jSSYrQqdvHHxy3c+oPdquNKq4lNUJMLL2hYpVI73o09yFwyXjD7Acyf+X8mgS4OH/eDN
         gNzcQkg2UIhY6z0LGXANIt7kKmdYI+z4Yom9VgbkcfIwXU2GppKi14cdNiPjSe7uYb/N
         1Eo1YZs4bVd2PruSi9cP86bRD/WGhpDb2V7AvRel97eIZfJ69Am/muSGOxOosWjDSmzt
         bMOHXjfgoIItwXt0VyaTHlTxTvdxcr2gzPaZzWM4/P4aoNMVASn2YkoM393t04+CWuFf
         9ziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r6pD3nqf5YZJfd7oARZuMlgtyxTG1WAuFZjNoAswQjU=;
        b=YwSZ+ZUeOta0JMxCroWJZZ5XNa5Re0zjECveoHJl7b0EFn8o05rzWLvinZjj0V2UGA
         7LU5DAegPmQMcifHJucpvbyj9H5sOnG1NWqJz0nMhZfnGMQhBda4KJJrfT22D+PdhBCs
         rCQ1ArEOlCDniPVaXdM2djYAxnAp9T0oWLeVgLZKTw4Eab66rxc9SNeM/LUZJ+Ty+RX1
         GWmKOLxdH1wrFNnY1wZXDJU2q2zem/F9ger3mBX7yMv75UCbFr0L7SGVDPlZJsFUeYDT
         32lRxxwPpf+TskO/h4d70GiJKEIB2eTssJ0btTZ/Gz3Fu7BUbVAGe8L0Zumo0JU24Rp0
         9OAQ==
X-Gm-Message-State: AOAM5337EmIhSk/R8rPntHtMJ1xNkG+0npu1YPEhKBRqKlfaTcC7+7vq
        QoMOwh3L3JxmvJbJWUe6Ree4Jg==
X-Google-Smtp-Source: ABdhPJyPmnSJGNQgYSgEmpmgXh+gdKW0jeV9zFP2K5A3XF4RmrV7/ZEFOUCteNjWsonzSB2UmUuWxA==
X-Received: by 2002:a62:65c7:0:b029:3c3:4eff:1b26 with SMTP id z190-20020a6265c70000b02903c34eff1b26mr11971076pfb.48.1630935113354;
        Mon, 06 Sep 2021 06:31:53 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id t68sm9898177pgc.59.2021.09.06.06.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 06:31:52 -0700 (PDT)
Subject: Re: [PATCH 6/6] io_uring: enable multishot mode for accept
To:     Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210903110049.132958-1-haoxu@linux.alibaba.com>
 <20210903110049.132958-7-haoxu@linux.alibaba.com>
 <e52f36e3-0b24-9b0c-96ac-f2eadca179af@kernel.dk>
 <95387504-3986-77df-7cb4-d136dd4be1ec@linux.alibaba.com>
 <c61bfb5a-036d-43be-e896-239b1c8ca1c3@kernel.dk>
 <701e50f5-2444-5b56-749b-1c1affc26ce9@gmail.com>
 <f332dbc6-5304-9676-ffc1-008e153d667b@kernel.dk>
 <c8298d9a-bef8-8128-ada6-b2edfabad292@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <004fdfbb-154f-f7c4-d65b-a9c3de1a03d8@kernel.dk>
Date:   Mon, 6 Sep 2021 07:31:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c8298d9a-bef8-8128-ada6-b2edfabad292@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/6/21 6:35 AM, Hao Xu wrote:
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
>>>>>>>    fs/io_uring.c | 14 ++++++++++++--
>>>>>>>    1 file changed, 12 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>> index eb81d37dce78..34612646ae3c 100644
>>>>>>> --- a/fs/io_uring.c
>>>>>>> +++ b/fs/io_uring.c
>>>>>>> @@ -4861,6 +4861,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>    static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>    {
>>>>>>>    	struct io_accept *accept = &req->accept;
>>>>>>> +	bool is_multishot;
>>>>>>>    
>>>>>>>    	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>>>>>    		return -EINVAL;
>>>>>>> @@ -4872,14 +4873,23 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>    	accept->flags = READ_ONCE(sqe->accept_flags);
>>>>>>>    	accept->nofile = rlimit(RLIMIT_NOFILE);
>>>>>>>    
>>>>>>> +	is_multishot = accept->flags & IORING_ACCEPT_MULTISHOT;
>>>>>>> +	if (is_multishot && (req->flags & REQ_F_FORCE_ASYNC))
>>>>>>> +		return -EINVAL;
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

As far as I can tell from a quick look, there's still plenty of flags
left for REQ_F additions, about 8 of them. Don't expand req->flags if we
can avoid it, just add some safeguards to ensure we don't mess up.

Since we haven't really been tight on req->flags before, there's also
some low hanging fruit there that will allow us to reclaim some of them
if we need to.

-- 
Jens Axboe

