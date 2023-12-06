Return-Path: <io-uring+bounces-248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D5580646F
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 02:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C7271F21416
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 01:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6698546B1;
	Wed,  6 Dec 2023 01:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkueZjm2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD3AD3
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 17:54:17 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-40c09ba723eso36620715e9.2
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 17:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701827656; x=1702432456; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bacr0r3tQEaAMPzcBRje7nys+tVb8vx8xzf05Kb8d8M=;
        b=YkueZjm2gR4KKZAolkG/Gib8bYjLiA/VgOkr9Dzr0d/SdjuXQJhzUnhSB6MAa5Ad36
         Rj+jjKl3lxN1N9iSdcxRD5pYzvn2pZ/uEuH2CSfGcZBQX3rvdVpF353S1Hka10w6j8wo
         OMO0L/DuXCZjAFSF6QxEhGzhoSydHn3sj6QEMVFICwzJ2u21VS1/lEamy4CwgboHDZe5
         cB3jKsqc7XvXJnqF/NZFz4s8Wld2dkUA9XEyPlwP7xgKwUP119pUvMQUaZtSjJhOQLXY
         +UyBTpUldEIkSfLdAmNJlm9HqZb9BGE+SNjDWtiUcNX3LtHRKovNvBlVZA7HgKbwvezd
         1R0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701827656; x=1702432456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bacr0r3tQEaAMPzcBRje7nys+tVb8vx8xzf05Kb8d8M=;
        b=ZFTQFTuKmb8LwlSgkAydeC5FC2/0cnRaKQxuE1gQZbhxoJLDSDvH1pCMJRECZbJbx5
         KUPmXyleMtfd7PxoIfot/nSxw4MqIJy1aJ0PcriOa3vxzXy34KjGI506nuYdz1Dto71R
         q70UWMC0eVtHH5Hv+8DDSK0OaJHcweC0gV5sQbzoutT5xkFbYLFXCpu844ZLFTz/521t
         gCx/56GG7hbl9xa89iET4L0XPuSh1/51rUXm/XShY8H6ZMc0c8ykqf5bFi60JxfxVaP9
         9lDfDBmvC7YZ5WDc/V6J+y10IAeOuRSyX090Z/KTlMwcfvSGCuByWqnh5yU/evR7NjIg
         ODjQ==
X-Gm-Message-State: AOJu0YwAsMsOSG/ENal/5pGKCmySrcsbQSs9Q0o3yMxvY0inVZNjlTTx
	GFy1GTmXso5u+PE6IEMeKfOFqV+vcg0=
X-Google-Smtp-Source: AGHT+IH5FdWJcNIkTQ6TVKkYEZRKp7j1f37rdHj862OW7i2KBZY6t7aJIDWN0xzlyKddxI+nuRTUsQ==
X-Received: by 2002:a05:600c:4981:b0:40c:1dd1:295c with SMTP id h1-20020a05600c498100b0040c1dd1295cmr38434wmp.199.1701827656160;
        Tue, 05 Dec 2023 17:54:16 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.209])
        by smtp.gmail.com with ESMTPSA id uz14-20020a170907118e00b00a0104d5758dsm7451261ejb.50.2023.12.05.17.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 17:54:15 -0800 (PST)
Message-ID: <e657b9ad-b02d-407c-99f7-65e263149fd2@gmail.com>
Date: Wed, 6 Dec 2023 01:51:38 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: save repeated issue_flags
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
 io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <20231205215553.2954630-1-kbusch@meta.com>
 <43ff7474-5174-4738-88d9-9c43517ae235@kernel.dk>
 <db385b87-d954-4147-a3b3-614b428c5a1e@gmail.com>
 <b74537a8-e313-457d-bcf0-e027ddabaa3c@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b74537a8-e313-457d-bcf0-e027ddabaa3c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/6/23 01:41, Jens Axboe wrote:
> On 12/5/23 6:26 PM, Pavel Begunkov wrote:
>> On 12/5/23 22:00, Jens Axboe wrote:
>>> On 12/5/23 2:55 PM, Keith Busch wrote:
>>>> From: Keith Busch <kbusch@kernel.org>
>>>>
>>>> No need to rebuild the issue_flags on every IO: they're always the same.
>>>>
>>>> Suggested-by: Jens Axboe <axboe@kernel.dk>
>>>> Signed-off-by: Keith Busch <kbusch@kernel.org>
>>>> ---
>> [...]
>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>> index 8a38b9f75d841..dbc0bfbfd0f05 100644
>>>> --- a/io_uring/uring_cmd.c
>>>> +++ b/io_uring/uring_cmd.c
>>>> @@ -158,19 +158,13 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>>        if (ret)
>>>>            return ret;
>>>>    -    if (ctx->flags & IORING_SETUP_SQE128)
>>>> -        issue_flags |= IO_URING_F_SQE128;
>>>> -    if (ctx->flags & IORING_SETUP_CQE32)
>>>> -        issue_flags |= IO_URING_F_CQE32;
>>>> -    if (ctx->compat)
>>>> -        issue_flags |= IO_URING_F_COMPAT;
>>>>        if (ctx->flags & IORING_SETUP_IOPOLL) {
>>>>            if (!file->f_op->uring_cmd_iopoll)
>>>>                return -EOPNOTSUPP;
>>>> -        issue_flags |= IO_URING_F_IOPOLL;
>>>>            req->iopoll_completed = 0;
>>>>        }
>>>>    +    issue_flags |= ctx->issue_flags;
>>>>        ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>>>>        if (ret == -EAGAIN) {
>>>>            if (!req_has_async_data(req)) {
>>>
>>> I obviously like this idea, but it should be accompanied by getting rid
>>> of ->compat and ->syscall_iopoll in the ctx as well?
>>
>> This all piggy backing cmd specific bits onto core io_uring issue_flags
>> business is pretty nasty. Apart from that, it mixes constant io_uring
>> flags and "execution context" issue_flags. And we're dancing around it
>> not really addressing the problem.
>>
>> IMHO, cmds should be testing for IORING_SETUP flags directly via
>> helpers, not renaming them and abusing core io_uring flags. E.g. I had
>> a patch like below but didn't care enough to send:
>>
>>
>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>> index 909377068a87..1a82a0633f16 100644
>> --- a/drivers/block/ublk_drv.c
>> +++ b/drivers/block/ublk_drv.c
>> @@ -2874,7 +2874,7 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
>>   
>>       ublk_ctrl_cmd_dump(cmd);
>>   
>> -    if (!(issue_flags & IO_URING_F_SQE128))
>> +    if (!(io_uring_cmd_get_ctx_flags(cmd) & IORING_SETUP_SQE128))
>>           goto out;
>>   
>>       ret = ublk_check_cmd_op(cmd_op);
>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>> index d69b4038aa3e..8a18a705ff31 100644
>> --- a/include/linux/io_uring/cmd.h
>> +++ b/include/linux/io_uring/cmd.h
>> @@ -79,4 +79,11 @@ static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd
>>       return cmd_to_io_kiocb(cmd)->task;
>>   }
>>   
>> +static inline unsigned io_uring_cmd_get_ctx_flags(struct io_uring_cmd *cmd)
>> +{
>> +    struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
>> +
>> +    return ctx->flags;
>> +}
>> +
>>   #endif /* _LINUX_IO_URING_CMD_H */
> 
> Yeah this is fine too, I just don't like our current scheme of having to
> mirror state in issue flags. Consolidating one way or another would be
> really nice.

Just hiding ->compat into the cache won't help it, most of the cmd
flags mirror IORING_SETUP_*, so unless it checks IORING_SETUP_* directly
there will be this duplication.

-- 
Pavel Begunkov

