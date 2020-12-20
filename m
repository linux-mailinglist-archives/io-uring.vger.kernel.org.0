Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9112DF283
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 01:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgLTA0W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 19:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgLTA0W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 19:26:22 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D5CC0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 16:25:32 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id x18so3558734pln.6
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 16:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gNLIOu8tTyVVL19A/QSHj+dNxiqj8A9cjBSjYHB4lAc=;
        b=lZ82ppCkAyKsgW0VEWYDXPBhFpn2VfKkdQtfWt2C9uLsj3oaLRMXjRUvCHNL+HCfvS
         4R+5q9JR7Ip1+lucBxMbp1PxXat+i9LcLS2NGZ6ecjCvfiArAq6R59uCndieWBfkzg63
         b4FSUVrq/AUvqRgRxGIpQTyCl4EpBEylFsLyUydbuF6h/CXB0ZWE8AylDhay/s+8o4Ak
         XQryDwhDBlXOX8+oB91/XSQH6n1qdaGQjWauM/0a06SuMRdZp7nDoLd484IhPkzUZLO3
         cOM5C5v3rjmnw0JLyE/JRirMNkNQjkjfD+UbG2dgbmGzXcK3XjTokm28uMIKqf7HH6EF
         pyJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gNLIOu8tTyVVL19A/QSHj+dNxiqj8A9cjBSjYHB4lAc=;
        b=JpQrQhINJNW0sRXntHeriEmaO8AlrMy+rsuTSjPGSSILPkxzyCyLK8PewM7MeK3GZb
         x0CChnlHnyJ/o7vih3VBMmGZlDIY3IgSNUlv+FSJCkyYe2xqjbNSZHcloxl+2QgdSPy8
         4qkJvNA/ytYRgcuLa6f1t5hIY8n+PRi1MaUInCK1ukq8A54A5ZE03WlCwuXbo8VrEmDN
         PzwtX22Tz5Mmi6HQNrzQO2hAE+ks3sGdl0RD+Agv+NRpQTK87PBWvNFVaPvpw/C0xorq
         kTx0jbA22LC47an/LMJtYQ6KDOqCTKBjsBHnG7pObFyfGMcZTPNjXG0sJEiB8PUE6Syi
         TidQ==
X-Gm-Message-State: AOAM530kQ5blToSkBHTwgS/hBxCRIrlqNRDcXFflAWWE4l4VD4q2gG+9
        +8hrX4hc2w2g+l72Z6W2yTXP0JgarbMINA==
X-Google-Smtp-Source: ABdhPJyWDKo8N6E69QVOekbl/s4X7W+Ye3/ZVQwSfRtNQzVDThka+cY8jsdLy2dLQhzyR3xng4gmbg==
X-Received: by 2002:a17:902:a5cb:b029:dc:2706:4cc8 with SMTP id t11-20020a170902a5cbb02900dc27064cc8mr10630156plq.62.1608423931489;
        Sat, 19 Dec 2020 16:25:31 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v21sm11973033pfm.154.2020.12.19.16.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 16:25:30 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Josef <josef.grieb@gmail.com>
Cc:     Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
 <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk>
 <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
Date:   Sat, 19 Dec 2020 17:25:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <986c85af-bb77-60d4-8739-49b662554157@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/19/20 4:42 PM, Pavel Begunkov wrote:
> On 19/12/2020 23:13, Jens Axboe wrote:
>> On 12/19/20 2:54 PM, Jens Axboe wrote:
>>> On 12/19/20 1:51 PM, Josef wrote:
>>>>> And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
>>>>> file descriptor. You probably don't want/mean to do that as it's
>>>>> pollable, I guess it's done because you just set it on all reads for the
>>>>> test?
>>>>
>>>> yes exactly, eventfd fd is blocking, so it actually makes no sense to
>>>> use IOSQE_ASYNC
>>>
>>> Right, and it's pollable too.
>>>
>>>> I just tested eventfd without the IOSQE_ASYNC flag, it seems to work
>>>> in my tests, thanks a lot :)
>>>>
>>>>> In any case, it should of course work. This is the leftover trace when
>>>>> we should be exiting, but an io-wq worker is still trying to get data
>>>>> from the eventfd:
>>>>
>>>> interesting, btw what kind of tool do you use for kernel debugging?
>>>
>>> Just poking at it and thinking about it, no hidden magic I'm afraid...
>>
>> Josef, can you try with this added? Looks bigger than it is, most of it
>> is just moving one function below another.
> 
> Hmm, which kernel revision are you poking? Seems it doesn't match
> io_uring-5.10, and for 5.11 io_uring_cancel_files() is never called with
> NULL files.
> 
> if (!files)
> 	__io_uring_cancel_task_requests(ctx, task);
> else
> 	io_uring_cancel_files(ctx, task, files);

Yeah, I think I messed up. If files == NULL, then the task is going away.
So we should cancel all requests that match 'task', not just ones that
match task && files.

Not sure I have much more time to look into this before next week, but
something like that.

The problem case is the async worker being queued, long before the task
is killed and the contexts go away. But from exit_files(), we're only
concerned with canceling if we have inflight. Doesn't look right to me.

-- 
Jens Axboe

