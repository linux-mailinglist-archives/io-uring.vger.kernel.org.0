Return-Path: <io-uring+bounces-1099-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F9487E98E
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 13:48:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAB43B21854
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 12:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981492EAE6;
	Mon, 18 Mar 2024 12:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PEJ6eKb5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBEA33CF1;
	Mon, 18 Mar 2024 12:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710766080; cv=none; b=PYcKq7G79tg0VfBBPFI1x7nT7ZkN7I9KOQNLvgijOshmiyG80m3OPvbpbNoBarRe4ygAV1a97fIodaiEjFrUgSHJDOGZ/iCwQovUXwM+IzBT3GOgWTyK2NUjxcrOOJZBpD64HARRiFMxS5/zlNaZJUNWU6BxTu1BMpfTOSsY8zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710766080; c=relaxed/simple;
	bh=NJO/OzF1aEQatl4gEGcESSz+6SPZB88Lyx//qMfh00M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oIAmBF5KIvP4TaoRRPd5HFsWg42cSyvioPDqz/6CwX0qkEplS0t3NHI3Bc6A3tWud2obl36QeQZlfi5LZPGomxfYn4hkj9xCMrcv+yhTvT/P1v1Na0Eo1J404rk2VzeZRfXihzlIYVmaXVrszaQ/eRS+q7sELZNg98/2ooJJFws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PEJ6eKb5; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a466fc8fcccso514933466b.1;
        Mon, 18 Mar 2024 05:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710766077; x=1711370877; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eqXURLQe9rpwYXz0H2JbltKjmZxipM6zc+gmhvKvKfQ=;
        b=PEJ6eKb5ikvg84xjWgmiBZ+qPzgULkeRCTjt1qhwMyjd9HxwGJcQBndAwf/IAhIyNP
         HjswQmJrKwooB1h6NX1Orffak0e1xzpgCkGMdNj4IBpA2IkqAiTxtjo8lNZD7DY4Ocdf
         YkU8QCbIZeD/Ye8ULmc329H/c2X2YVFkR9DWvsbTuo8+H3G1oKlxdurlDMHUvfbLOXW1
         G0JIJJdLG34XD4JtqWdxNjg9NoGY+Eu9QmeqZray5xBAuRjl3YcXUYRltffLYkPzc2R1
         SIAkoRpfXwSMl9PPeop+i1Y0r6WDQcieB/Ddxnf0KCJX6Byf3OlKXLUPQOFhv8AfJ5Ch
         Mmow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710766077; x=1711370877;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eqXURLQe9rpwYXz0H2JbltKjmZxipM6zc+gmhvKvKfQ=;
        b=RtWZ28F2zkIUs7xEOgPpMIHN8HAa3Sn6iQJ+8mLH9KT3H8niNDj5VQDEl6tUGCexQJ
         UPYAM0FBuFZdQfkpE7z1IuN13k+LK4BWBX2w1vuJTKCgVXtTm9uzcKVF4m6hoc4eeKUN
         xJLiEnVXR271l4a0Do2Au0GHio0nK7DRF5GUT/SGbT2iFI8zUQfzA51Xf1EEDO4ADEj7
         O4sXMLruhwVmZmBpXadwHMOEbLXiepzP8xQwpZHTdlJDmL7/YsnBZB2YciDH7gmtVhBc
         GNMYfNP7ackeZVINKs+W2DPN6RaC4dHNxb2GL+H84k/bYjn8LcJqGcouZvJ46ryUHUIE
         6m8g==
X-Forwarded-Encrypted: i=1; AJvYcCUu3xfplL2GkfFG/ICEf6IoO0K53YLI48hWpuqP1Esv+WBeakASdF/DvqIp0V5AGveiYihNzXOlLACwtdJGaDDZAvFba2yg3IolAbI=
X-Gm-Message-State: AOJu0Yza2hX2mdQNEYRUPJwhlEWzRGtsrZu7CW/hE814bao6xDCEmn2J
	EWaTeWap+SC5bMA93aA7jVQ5IktfN/rDwZEBL2HM9HkMr8zS39RmtkaSX5Sc
X-Google-Smtp-Source: AGHT+IGy9tjxfnOCO86MR0H3gZf3/TqZa19jGUpGSxZLiitEfmnYZSRJ50Nlg10eiNLk6YY3AC4ICA==
X-Received: by 2002:a17:906:a415:b0:a46:1f6d:3047 with SMTP id l21-20020a170906a41500b00a461f6d3047mr7801570ejz.4.1710766077077;
        Mon, 18 Mar 2024 05:47:57 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2181? ([2620:10d:c092:600::1:e42b])
        by smtp.gmail.com with ESMTPSA id cu2-20020a170906e00200b00a4660b63502sm4887794ejb.12.2024.03.18.05.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 05:47:56 -0700 (PDT)
Message-ID: <1f5c02ad-f25a-46ea-96e6-649997aea3c2@gmail.com>
Date: Mon, 18 Mar 2024 12:46:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/14] io_uring/cmd: make io_uring_cmd_done irq safe
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <faeec0d1e7c740a582f51f80626f61c745ed9a52.1710720150.git.asml.silence@gmail.com>
 <Zff25z0fPGBPfJs1@fedora> <4c6a5b55-2833-4ef7-a514-577fe61160dd@gmail.com>
 <Zfgsk8mND0cah3DP@fedora>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zfgsk8mND0cah3DP@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/24 11:59, Ming Lei wrote:
> On Mon, Mar 18, 2024 at 11:50:32AM +0000, Pavel Begunkov wrote:
>> On 3/18/24 08:10, Ming Lei wrote:
>>> On Mon, Mar 18, 2024 at 12:41:48AM +0000, Pavel Begunkov wrote:
>>>> io_uring_cmd_done() is called from the irq context and is considered to
>>>> be irq safe, however that's not the case if the driver requires
>>>> cancellations because io_uring_cmd_del_cancelable() could try to take
>>>> the uring_lock mutex.
>>>>
>>>> Clean up the confusion, by deferring cancellation handling to
>>>> locked task_work if we came into io_uring_cmd_done() from iowq
>>>> or other IO_URING_F_UNLOCKED path.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    io_uring/uring_cmd.c | 24 +++++++++++++++++-------
>>>>    1 file changed, 17 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>> index ec38a8d4836d..9590081feb2d 100644
>>>> --- a/io_uring/uring_cmd.c
>>>> +++ b/io_uring/uring_cmd.c
>>>> @@ -14,19 +14,18 @@
>>>>    #include "rsrc.h"on   #include "uring_cmd.h"
>>>> -static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
>>>> -		unsigned int issue_flags)
>>>> +static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd)
>>>>    {
>>>>    	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
>>>>    	struct io_ring_ctx *ctx = req->ctx;
>>>> +	lockdep_assert_held(&ctx->uring_lock);
>>>> +
>>>>    	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE))
>>>>    		return;
>>>>    	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
>>>> -	io_ring_submit_lock(ctx, issue_flags);
>>>>    	hlist_del(&req->hash_node);
>>>> -	io_ring_submit_unlock(ctx, issue_flags);
>>>>    }
>>>>    /*
>>>> @@ -44,6 +43,9 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>>>    	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
>>>>    	struct io_ring_ctx *ctx = req->ctx;
>>>> +	if (WARN_ON_ONCE(ctx->flags & IORING_SETUP_IOPOLL))
>>>> +		return;
>>>> +
>>>
>>> This way limits cancelable command can't be used in iopoll context, and
>>> it isn't reasonable, and supporting iopoll has been in ublk todo list,
>>> especially single ring context is shared for both command and normal IO.
>>
>> That's something that can be solved when it's needed, and hence the
>> warning so it's not missed. That would need del_cancelable on the
>> ->iopoll side, but depends on the "leaving in cancel queue"
>> problem resolution.
> 
> The current code is actually working with iopoll, so adding the warning
> can be one regression. Maybe someone has been using ublk with iopoll.

Hmm, I don't see ->uring_cmd_iopoll implemented anywhere, and w/o
it io_uring should fail the request:

int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
{
	...
	if (ctx->flags & IORING_SETUP_IOPOLL) {
		if (!file->f_op->uring_cmd_iopoll)
			return -EOPNOTSUPP;
		issue_flags |= IO_URING_F_IOPOLL;
	}
}

Did I miss it somewhere?

-- 
Pavel Begunkov

