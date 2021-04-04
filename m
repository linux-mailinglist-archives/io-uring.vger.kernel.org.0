Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3573537D4
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 13:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhDDLG7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 07:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbhDDLG7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 07:06:59 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919F3C061756
        for <io-uring@vger.kernel.org>; Sun,  4 Apr 2021 04:06:54 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so4342122wmj.2
        for <io-uring@vger.kernel.org>; Sun, 04 Apr 2021 04:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OmZ5xZe1lZ7F0tN9F1ULn+NNiAaWx14G07y/5QqiTas=;
        b=l8+u/qmAbW6RYGW/h7m+2lUbBVI7NMCiYmx6Lf0eioguyNMPBiaDW20ddYksaGEAwY
         7NKQHC1Rhqb7yrCVvG7J9NCynRKODjAP3jwTY/SB3fU2A4EKh/FEmVF09GC6E+0ll2jq
         KkQ0JfDiU662p8VOl/YKApfTawx59LoiiFQp5gycBpfvnRbLoaSY+j0HxMrBfQWQxamy
         lLIq0vOsxX0UGeMvZOwK3apj4aXX0EyPuaCB6ISKe9kYAle73GG9j9dOlnmjSGW0Xy4Q
         nfuYkuY+dpJ9lJwQ84TQPUw9kk+3PliP/infj1WHFwFAIE4geQOXhgmMIu45kb6tlHRG
         hkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OmZ5xZe1lZ7F0tN9F1ULn+NNiAaWx14G07y/5QqiTas=;
        b=Pn0lgVdbNGlzLDRP5SCiyAFWuX7fy312GuF3Pjp04vsjUHok2n08tFxOYS07ixjaqG
         utycF20OOAB8sWybGpqsbA+uRYsD5TEQzMYHH8/hZiDOMGn5jN7Y523kuFhPPadCo2D2
         T/sY/v0yfOvOMtcSugbbMaeCO7eqC7AsRHmmbk4wPrCDgDmdkgskstHZ4V+5n2ffV46c
         Ej2FWhC8K7bBi6WY22djjg6qBWfJYnBeEw1zMkp5JgJyst28q/dhOfgldCyrEwKL0Xrm
         vxUnOmQxVTk3kn8e3ppN7ayP3+JNmeD3cTtcataVxc8adlEpfZqT4+evYeNCRwwIw7k9
         6+6g==
X-Gm-Message-State: AOAM531AFZ0LW/FbORVI1vEvaqBEwPXpFKEVf+vpT1x+iI9vmGzT05Ob
        av0M2m3HoSLzoR04HMQewlmwRTuE4qUmRw==
X-Google-Smtp-Source: ABdhPJxBXonlAZ1vOMQFhHZQtzo0PA/G/BhBFyVKBGYrCij11r2yUrYHFypubCTyOE3RC4h6Mv/s2w==
X-Received: by 2002:a05:600c:218d:: with SMTP id e13mr8751488wme.114.1617534412767;
        Sun, 04 Apr 2021 04:06:52 -0700 (PDT)
Received: from [192.168.8.132] ([148.252.129.227])
        by smtp.gmail.com with ESMTPSA id b66sm8213828wmb.48.2021.04.04.04.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 04:06:52 -0700 (PDT)
Subject: Re: [PATCH] io_uring: don't mark S_ISBLK async work as unbounded
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
References: <a96971ea-2787-149a-a4bd-422fa696a586@kernel.dk>
 <48023516-ac7d-8393-f603-f9bf4faa722f@linux.alibaba.com>
 <a4661870-a839-f949-e5cf-18022d070384@gmail.com>
 <2c0ce39f-3ccb-3e25-9dcf-d9876c30efb1@gmail.com>
 <5264e0da-42f2-0629-f0a7-7c78eeee6deb@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <0b08f517-c534-3864-7867-026533cd1420@gmail.com>
Date:   Sun, 4 Apr 2021 12:02:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5264e0da-42f2-0629-f0a7-7c78eeee6deb@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/04/2021 11:57, Hao Xu wrote:
> 在 2021/4/2 下午6:48, Pavel Begunkov 写道:
>> On 02/04/2021 11:32, Pavel Begunkov wrote:
>>> On 02/04/2021 09:52, Hao Xu wrote:
>>>> 在 2021/4/1 下午10:57, Jens Axboe 写道:
>>>>> S_ISBLK is marked as unbounded work for async preparation, because it
>>>>> doesn't match S_ISREG. That is incorrect, as any read/write to a block
>>>>> device is also a bounded operation. Fix it up and ensure that S_ISBLK
>>>>> isn't marked unbounded.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>
>>>> Hi Jens, I saw a (un)bounded work is for a (un)bounded worker to
>>>> execute. What is the difference between bounded and unbounded?
>>>
>>> Unbounded works are not bounded in execution time, i.e. they may take
>>> forever to complete. E.g. recv depends on the other end to send something,
>>> that not necessarily will ever happen.
>>
>> To elaborate a bit, one example of how it's used: because unbounded may
>> stay for long, it always spawns a new worker thread for each of them.
>>
>> If app submits SQEs as below, and send's are not actually sent for execution
>> but stashed somewhere internally in a list, e.g. waiting for a worker thread
>> to get free, it would just hang from the userspace perspective.
>>
>> recv(fd1), recv(fd1), send(fd1), send(fd1)
>>
> Hi Pavel, thank you for the patient explanation, I got the meaning of
>  bound/unbond now, but it seems there is no difference handling bounded and unbounded work in the current code?

It was used in io-wq, so see in io-wq.[c,h] files. Not sure about 5.12+, but
a quick look shows: 

wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
...
wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
			task_rlimit(current, RLIMIT_NPROC);



>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 6d7a1b69712b..a16b7df934d1 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -1213,7 +1213,7 @@ static void io_prep_async_work(struct io_kiocb *req)
>>>>>        if (req->flags & REQ_F_ISREG) {
>>>>>            if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
>>>>>                io_wq_hash_work(&req->work, file_inode(req->file));
>>>>> -    } else {
>>>>> +    } else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
>>>>>            if (def->unbound_nonreg_file)
>>>>>                req->work.flags |= IO_WQ_WORK_UNBOUND;
>>>>>        }
>>
> 

-- 
Pavel Begunkov
