Return-Path: <io-uring+bounces-247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F074806435
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 02:41:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 185F8281F5C
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 01:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8138110E1;
	Wed,  6 Dec 2023 01:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="o5srgOQv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C5C1B8
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 17:41:06 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-7b37846373eso27385239f.0
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 17:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701826865; x=1702431665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dNLycGPyQoFkPiHsm1MMMkCiI7Zdyltf+g/+AhqwsxU=;
        b=o5srgOQv+0LvI1X1iCxfTwnWU70BB2uAjyiJ1PpUoym/Qcy1KHesM4dFL/PFfNRSav
         3s5eIlaf1SDdnqNrGu7zHgGyGFMZJmfOENMW8anx022Bdk/MIOZ7ZYpQJmreDyf8x6/a
         wdgzBxePny7/qi4hXjd7hbAAKuDSRve+ZBS1SqPnB2suox6myvV0xiVQaK1vuMO5XnI6
         /GHoeEKvu6Au7t/VDC05mjJT5TjFO09BD9S7U7h0+Jar/X6dAcPKg8aemI0YFmpC/Jj3
         jwZkP3J9Ux2CZTJJR6QuLZ+pWv8z1u7COalt32R/IdG38Vn6U0aJYVJJ64vW2qw1It4z
         vUsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701826865; x=1702431665;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dNLycGPyQoFkPiHsm1MMMkCiI7Zdyltf+g/+AhqwsxU=;
        b=r923oQXrpntg4rBDZBDd8aA+ISZUDx+UoVzHPBNvqZkYQbgZig0IWHDOyCUv1iLe26
         oKW/LygHDju4+27+jF/UJApH9Po4Ex05n4w/haJGqRVfHgyYTJ4WTJY7qSuNA4LvBUxM
         wjeSXUcA9NueDruy1smJO46RG987hl+1YcKjyRPlaD5eZjT4oypZFJM+YDhhHPtWfwh2
         PysQ6jakFlvkkdIk21Xx1F/7s7ymBjg3E41IP6Ja3XwfXetcadY7Rj33xbN2C5rSoDWA
         8B1nvWajcvAgrHq1BPGyx4XCbFOAU+j0V6TXhZpbFeQiTqBFsVz08FNlL6q4BvAoz+Xm
         0kNA==
X-Gm-Message-State: AOJu0YwYvW3WYMqDHkA/Ag1XeI4A+Awsw9j8ESXpz5mQcPMy49JEZg61
	2wDMjH2OgWBTjXaw6/9czDxZ0g==
X-Google-Smtp-Source: AGHT+IEqw5qtiRed7LsH2V+HFTZOII3zoM/L3iM1/oxqq5fvBX/O2Kz4nZmXwgAn0lfMJANyy8D6MQ==
X-Received: by 2002:a05:6e02:1a0f:b0:35c:ac42:f9a4 with SMTP id s15-20020a056e021a0f00b0035cac42f9a4mr637717ild.1.1701826865399;
        Tue, 05 Dec 2023 17:41:05 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id s25-20020a639259000000b00578afd8e012sm5513703pgn.92.2023.12.05.17.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 17:41:04 -0800 (PST)
Message-ID: <b74537a8-e313-457d-bcf0-e027ddabaa3c@kernel.dk>
Date: Tue, 5 Dec 2023 18:41:03 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: save repeated issue_flags
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Keith Busch <kbusch@meta.com>,
 io-uring@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>
References: <20231205215553.2954630-1-kbusch@meta.com>
 <43ff7474-5174-4738-88d9-9c43517ae235@kernel.dk>
 <db385b87-d954-4147-a3b3-614b428c5a1e@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <db385b87-d954-4147-a3b3-614b428c5a1e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/23 6:26 PM, Pavel Begunkov wrote:
> On 12/5/23 22:00, Jens Axboe wrote:
>> On 12/5/23 2:55 PM, Keith Busch wrote:
>>> From: Keith Busch <kbusch@kernel.org>
>>>
>>> No need to rebuild the issue_flags on every IO: they're always the same.
>>>
>>> Suggested-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: Keith Busch <kbusch@kernel.org>
>>> ---
> [...]
>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>> index 8a38b9f75d841..dbc0bfbfd0f05 100644
>>> --- a/io_uring/uring_cmd.c
>>> +++ b/io_uring/uring_cmd.c
>>> @@ -158,19 +158,13 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>>       if (ret)
>>>           return ret;
>>>   -    if (ctx->flags & IORING_SETUP_SQE128)
>>> -        issue_flags |= IO_URING_F_SQE128;
>>> -    if (ctx->flags & IORING_SETUP_CQE32)
>>> -        issue_flags |= IO_URING_F_CQE32;
>>> -    if (ctx->compat)
>>> -        issue_flags |= IO_URING_F_COMPAT;
>>>       if (ctx->flags & IORING_SETUP_IOPOLL) {
>>>           if (!file->f_op->uring_cmd_iopoll)
>>>               return -EOPNOTSUPP;
>>> -        issue_flags |= IO_URING_F_IOPOLL;
>>>           req->iopoll_completed = 0;
>>>       }
>>>   +    issue_flags |= ctx->issue_flags;
>>>       ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>>>       if (ret == -EAGAIN) {
>>>           if (!req_has_async_data(req)) {
>>
>> I obviously like this idea, but it should be accompanied by getting rid
>> of ->compat and ->syscall_iopoll in the ctx as well?
> 
> This all piggy backing cmd specific bits onto core io_uring issue_flags
> business is pretty nasty. Apart from that, it mixes constant io_uring
> flags and "execution context" issue_flags. And we're dancing around it
> not really addressing the problem.
> 
> IMHO, cmds should be testing for IORING_SETUP flags directly via
> helpers, not renaming them and abusing core io_uring flags. E.g. I had
> a patch like below but didn't care enough to send:
> 
> 
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 909377068a87..1a82a0633f16 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -2874,7 +2874,7 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
>  
>      ublk_ctrl_cmd_dump(cmd);
>  
> -    if (!(issue_flags & IO_URING_F_SQE128))
> +    if (!(io_uring_cmd_get_ctx_flags(cmd) & IORING_SETUP_SQE128))
>          goto out;
>  
>      ret = ublk_check_cmd_op(cmd_op);
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index d69b4038aa3e..8a18a705ff31 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -79,4 +79,11 @@ static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd
>      return cmd_to_io_kiocb(cmd)->task;
>  }
>  
> +static inline unsigned io_uring_cmd_get_ctx_flags(struct io_uring_cmd *cmd)
> +{
> +    struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> +
> +    return ctx->flags;
> +}
> +
>  #endif /* _LINUX_IO_URING_CMD_H */

Yeah this is fine too, I just don't like our current scheme of having to
mirror state in issue flags. Consolidating one way or another would be
really nice.

-- 
Jens Axboe


