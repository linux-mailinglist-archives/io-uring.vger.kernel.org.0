Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042691ED124
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 15:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgFCNr5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 09:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgFCNr4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 09:47:56 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39727C08C5C0
        for <io-uring@vger.kernel.org>; Wed,  3 Jun 2020 06:47:56 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l26so1992486wme.3
        for <io-uring@vger.kernel.org>; Wed, 03 Jun 2020 06:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uj9cHWNx3SajyHvnxZ5VKm90WkptFERmZZIM+IRxJB4=;
        b=fDb5Y5tn62Pb1OU5aL5vPNWNWRgtFmYWFCnqW8j4u++iJjBTmeq+UuTTZnV46kZkSa
         YxYGVT4F03/pe+S65Bl8mTtOGy+jCohmtE91W6j5BeH6wjqGnr5iUDQjjw3Z+xX4lnbq
         a/XYuqDF1NSVC1UUOvHQEcHZ/cA2AdA357q12qaBLPJ3CgIZK7R7nxS9EzluDDx/TJ3f
         9M8vMOlJjuGaiq3XxmwkULayp1Px/bE9a++viEU623tTm2fb0E/G2DnASXKRjv37/Pat
         0tn4MCpXvrBkOxUC1ms02Wl+iU0Z5P8HoZJjK0oY6Vdrk/SzZJCrlyWT97sHhhODi6r6
         LTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Uj9cHWNx3SajyHvnxZ5VKm90WkptFERmZZIM+IRxJB4=;
        b=WBRyKEJLyFVbu96Y84E94AVj82wL/Vdvp7OcS3Y6gxvo1BQqhqMEj7ALXoXDEKxjYM
         5zzu1YC27XKGig2lNlxDnTu6iYCwMnhJzwrFPNxfXaoGg2vfL7cEf0W0wm7Tg8hca04k
         JNHxgRq5LSxhE7SydWQfJFr5RpCkhWkbIAOtB+8pLym0nh+v3W7ugRb+1/ZlkMUN0jdn
         u7k1bdoPOBaGquavPQZMZ2PQsnC6dFbfghipkHoZRYZp248nxzvA7/cxWtsyiMzL8z6g
         ZLz4yhPoHzxCF5pt/jLx/nHRtuyX3xH5TTeL604fLcNYK4z4Na8nDaC6Dtxlx9uqw1fT
         ZuVQ==
X-Gm-Message-State: AOAM532HyOmm6No5TPlvPe3EF2k4Tf5jLru2y6BUY2q9EwCo/mXq1rm7
        q7pwuZWTNV1l4XEUWkPad6XBGhNs
X-Google-Smtp-Source: ABdhPJwQ0Fmky/1G2PHt/c+UIKBOD1dPGNFEnnBY6kIa3xh3QxjIDh67DVE+J7vwi3yQBgearAXCuQ==
X-Received: by 2002:a05:600c:2218:: with SMTP id z24mr8562129wml.24.1591192074763;
        Wed, 03 Jun 2020 06:47:54 -0700 (PDT)
Received: from [192.168.43.154] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id k17sm2962399wmj.15.2020.06.03.06.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 06:47:54 -0700 (PDT)
Subject: Re: [PATCH v5 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
 <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
 <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <8accdc46-53c9-cf89-1e61-51e7c269411c@gmail.com>
Date:   Wed, 3 Jun 2020 16:46:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/06/2020 04:16, Xiaoguang Wang wrote:
> hi Jens, Pavel,
> 
> Will you have a look at this V5 version? Or we hold on this patchset, and
> do the refactoring work related io_wq_work firstly.

It's entirely up to Jens, but frankly, I think it'll bring more bugs than
merits in the current state of things.

> 
> 
>> Basically IORING_OP_POLL_ADD command and async armed poll handlers
>> for regular commands don't touch io_wq_work, so only REQ_F_WORK_INITIALIZED
>> is set, can we do io_wq_work copy and restore.
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>> V3:
>>    drop the REQ_F_WORK_NEED_RESTORE flag introduced in V2 patch, just
>>    use REQ_F_WORK_INITIALIZED to control whether to do io_wq_work copy
>>    and restore.
>> ---
>>   fs/io_uring.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 8e022d0f0c86..b761ef7366f9 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4527,7 +4527,8 @@ static void io_async_task_func(struct callback_head *cb)
>>       spin_unlock_irq(&ctx->completion_lock);
>>         /* restore ->work in case we need to retry again */
>> -    memcpy(&req->work, &apoll->work, sizeof(req->work));
>> +    if (req->flags & REQ_F_WORK_INITIALIZED)
>> +        memcpy(&req->work, &apoll->work, sizeof(req->work));
>>       kfree(apoll);
>>         if (!canceled) {
>> @@ -4624,7 +4625,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>>           return false;
>>         req->flags |= REQ_F_POLLED;
>> -    memcpy(&apoll->work, &req->work, sizeof(req->work));
>> +    if (req->flags & REQ_F_WORK_INITIALIZED)
>> +        memcpy(&apoll->work, &req->work, sizeof(req->work));
>>       had_io = req->io != NULL;
>>         get_task_struct(current);
>> @@ -4649,7 +4651,8 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>>           if (!had_io)
>>               io_poll_remove_double(req);
>>           spin_unlock_irq(&ctx->completion_lock);
>> -        memcpy(&req->work, &apoll->work, sizeof(req->work));
>> +        if (req->flags & REQ_F_WORK_INITIALIZED)
>> +            memcpy(&req->work, &apoll->work, sizeof(req->work));
>>           kfree(apoll);
>>           return false;
>>       }
>> @@ -4694,7 +4697,9 @@ static bool io_poll_remove_one(struct io_kiocb *req)
>>                * io_req_work_drop_env below when dropping the
>>                * final reference.
>>                */
>> -            memcpy(&req->work, &apoll->work, sizeof(req->work));
>> +            if (req->flags & REQ_F_WORK_INITIALIZED)
>> +                memcpy(&req->work, &apoll->work,
>> +                       sizeof(req->work));
>>               kfree(apoll);
>>           }
>>       }
>>

-- 
Pavel Begunkov
