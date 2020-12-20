Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16842DF28D
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 02:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgLTBAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 20:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgLTBAG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 20:00:06 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E23C0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 16:59:21 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id e25so7139139wme.0
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 16:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sRLdyC4Q25NFzY6pW6772mSGdtCD1oZhQdtCtqWKoyA=;
        b=QovfEtcqsNHBcIkj1h+0AUpoB1P451rdpiyLQjNkpIHjIHruzRxhwisz/y5YCtXOEk
         Y7Oh2ugNL+0L23Pxg2Zf0O/GeuQQ5qGuq9T03W/FpUIrDVuWoPQ9weOK/qMO5n/NR/z7
         8mNPXzBo2d0y9IYgcYfxy1XhRDwfhjsKgR8ajEQvO8Y22c6hOP3b+0ECicJtqO3I9s20
         yKaultfwDiZf1fLHE6Y75mQQv5T4O0W+1/Rl+nvObvegxO0K4GdyvMtCcRzZ9M6PFrI9
         D83jC3hZ3fA/e+FXY7yfS2HBRxH/Xa2SXG3ne7zXrobrR95RUG3a0uD7l80EzJ8x0MEY
         2NuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sRLdyC4Q25NFzY6pW6772mSGdtCD1oZhQdtCtqWKoyA=;
        b=aDSD4tjhltfIG8KoMHmjh2C9mn9LQtuT9qse1kRX8X2Yg67RWtskBeeqjdRZFOA8ZT
         Vmu/YxszJs48VO2LMnoatqQ93A5Bi+w3+epKdoeRn4gckOQ3S2fUqnBR0/40zhUEhXdt
         kzviCSMYRH8mZFo/xlzprVlYLtOm1kEBPA4mfT+9v2NrUnL87d4xEgM7tQb3uP+z6LYq
         4AesL7Z0qmoirUeeaJA8Tz3PMiGRHAVgHqycRl3zxwGvbyySRbzxrQYSWW7aFHgZg+Pm
         mt9ZbNpmIgxVEQrw7RXu4U2nd8Wx3GgHmlKN/hp/D07+ev3IDGVoKd7mGdiqVLcVNIN6
         eeOg==
X-Gm-Message-State: AOAM530qMJiZztK72HNMq6dpQM2eX6ZzszinioEaZ0KkiZozhCFH24Xs
        lxDCYYIM80Id2Kybmo4vyCNrAG2gUf+0uw==
X-Google-Smtp-Source: ABdhPJxA02vjUNtkf/LHJa707uDOq/QTmcrsVUp/X+CALBpuomAhQO3WRaixO1ZxJh8pRlEtnTnr+g==
X-Received: by 2002:a05:600c:2652:: with SMTP id 18mr9787914wmy.54.1608425958497;
        Sat, 19 Dec 2020 16:59:18 -0800 (PST)
Received: from [192.168.8.133] ([85.255.237.164])
        by smtp.gmail.com with ESMTPSA id n17sm16807590wmc.33.2020.12.19.16.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 16:59:17 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>
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
 <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
Message-ID: <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com>
Date:   Sun, 20 Dec 2020 00:55:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/12/2020 00:25, Jens Axboe wrote:
> On 12/19/20 4:42 PM, Pavel Begunkov wrote:
>> On 19/12/2020 23:13, Jens Axboe wrote:
>>> On 12/19/20 2:54 PM, Jens Axboe wrote:
>>>> On 12/19/20 1:51 PM, Josef wrote:
>>>>>> And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
>>>>>> file descriptor. You probably don't want/mean to do that as it's
>>>>>> pollable, I guess it's done because you just set it on all reads for the
>>>>>> test?
>>>>>
>>>>> yes exactly, eventfd fd is blocking, so it actually makes no sense to
>>>>> use IOSQE_ASYNC
>>>>
>>>> Right, and it's pollable too.
>>>>
>>>>> I just tested eventfd without the IOSQE_ASYNC flag, it seems to work
>>>>> in my tests, thanks a lot :)
>>>>>
>>>>>> In any case, it should of course work. This is the leftover trace when
>>>>>> we should be exiting, but an io-wq worker is still trying to get data
>>>>>> from the eventfd:
>>>>>
>>>>> interesting, btw what kind of tool do you use for kernel debugging?
>>>>
>>>> Just poking at it and thinking about it, no hidden magic I'm afraid...
>>>
>>> Josef, can you try with this added? Looks bigger than it is, most of it
>>> is just moving one function below another.
>>
>> Hmm, which kernel revision are you poking? Seems it doesn't match
>> io_uring-5.10, and for 5.11 io_uring_cancel_files() is never called with
>> NULL files.
>>
>> if (!files)
>> 	__io_uring_cancel_task_requests(ctx, task);
>> else
>> 	io_uring_cancel_files(ctx, task, files);
> 
> Yeah, I think I messed up. If files == NULL, then the task is going away.
> So we should cancel all requests that match 'task', not just ones that
> match task && files.
> 
> Not sure I have much more time to look into this before next week, but
> something like that.
> 
> The problem case is the async worker being queued, long before the task
> is killed and the contexts go away. But from exit_files(), we're only
> concerned with canceling if we have inflight. Doesn't look right to me.

In theory all that should be killed in io_ring_ctx_wait_and_kill(),
of course that's if the ring itself is closed.

Guys, do you share rings between processes? Explicitly like sending 
io_uring fd over a socket, or implicitly e.g. sharing fd tables
(threads), or cloning with copying fd tables (and so taking a ref
to a ring).
In other words, if you kill all your io_uring applications, does it
go back to normal?

-- 
Pavel Begunkov
