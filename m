Return-Path: <io-uring+bounces-4379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F379BA969
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59DF3B21CFB
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B4C18C010;
	Sun,  3 Nov 2024 22:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="E8LFIlN3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE8018C32C
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 22:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730674286; cv=none; b=bnFFbkcWZrnw7h3E/ACeySGveFKrIVUHzYxGg6iYMp5J8SgDglEuZC/+eAFTfSksAlOz5ZmG1Qd0IOTkb4OrnckQavHBK6z4B9PMoj9je9MamSDy6C8kk5aeNtp07fG9SRkzOFhPBLQAQ98YW/Kgc8FwbUvYxtghIP2ujqYIC9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730674286; c=relaxed/simple;
	bh=rc4iilvq2Hss3oj7tFB8x5fcnd8bpO4LqE+XFrvn2tE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KXorHxUUdhH7KUrq9rXYFZKKwJqjSp8BP/cjb+e/TWJW2Z0yLfIGBnVQ5vakMHmJ+EMOKY6Jz/4PH3yHXwNDbqJgwdD59tDCiRcXX4tOJ80/ZiUg1+4RdFwwI43aIOWzOEuHAFecfaQ8uI+9gFlDfHPmc9XTIbgthISiCVH/jY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=E8LFIlN3; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-71e61b47c6cso3241615b3a.2
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 14:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730674284; x=1731279084; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=prBc6cdWDBNr9BG1zdBF/MSqFtzOgVTInCG3aPrJtdQ=;
        b=E8LFIlN3iEJudijbpxYAB0A6aL0dgwiVbkW9DQAShlBdd8KdUYZJDzBfesuJv1f81s
         8wgsYbcBY0GStL6DFYX1O5R+tWzF0g9NFDhGBiXZQGC+8L8WYwJ+tjcUcD/Rp+oV7ieT
         TpwiJPJFFVgsoJgruX8uhW8XjgO9QVDQ8ZEBoCF9HW326aArDdJJk35BzqtsmC7OSKN2
         ir96PH7mvOEQ+heNWzdi6DlxPMEXZHkp9bRglgiYjUo96k5PfYr6AddUtwbMY/+D+cHx
         DlY4pVRkVkcKBqFnOreTpk+HdR49uF5wiDNylccPRCc4ykU5swL9qwtssN8wI16PQsXU
         JUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730674284; x=1731279084;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=prBc6cdWDBNr9BG1zdBF/MSqFtzOgVTInCG3aPrJtdQ=;
        b=Bwh+bmfNM/YlVX4zbFC+mf7fdoeS0UXLSu2QluqrfvqrikD6xrVBQY19G04PUQXZUq
         l6BDnAb7zltt8g63Iy34is45bTBJdST+VwGLXA+Fay2FH4+eU+RokA/aQ7ek2ZluqhT8
         Lb5LosYN+sM7Ny47SzVPJwHl9sq1+fMBTcGjoYyLf4UgwpaLhp4j/Yl2wGDCDgO+BCQP
         YYsSMjEumB/S8HQTyC1VKVW47xR9xO88+p7O1TKkZ32w9N+BY74aK0OYVoaGv4yE9mbL
         9uqkdVRcg4T7AWQRtALSZCcRDaXKzJpzGYl+314U+VKOiz+EWL46HBBiO3sUWPw3RmcD
         uyXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJVy/nPq41ObrNb2Pft7Hx3Jm41D73uG1WKLLkOlz1NucdzMiUdlpycT39Ozw/wuvGG9rjejjUrg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxOe2ub1hgLljL6/fZg+WLTE3YmPUySspMV4v+VwZIrbb8sugH8
	fwDTwmF3aqVG0gjShgX0EJH5ghxN4TetbBiyyZYzg3mf+JusBhz6IenzuHcwVGcVdFmySrBxwN8
	VZ7o=
X-Google-Smtp-Source: AGHT+IF4ZXyU8y+HNKrPFCbIXUOpz6Nl1Sn3HqZpODif2sQ/k/kRxOSBlmWGH+//QD4Uc5lcM3xoJA==
X-Received: by 2002:a05:6a00:b55:b0:71e:744a:3fbd with SMTP id d2e1a72fcca58-7206306df29mr41807488b3a.20.1730674284080;
        Sun, 03 Nov 2024 14:51:24 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc2ebebcsm6451010b3a.172.2024.11.03.14.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:51:23 -0800 (PST)
Message-ID: <81330ac7-6c9b-4515-8dce-6294fcd45641@kernel.dk>
Date: Sun, 3 Nov 2024 15:51:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: move struct io_kiocb from task_struct to
 io_uring_task
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241103175108.76460-1-axboe@kernel.dk>
 <20241103175108.76460-4-axboe@kernel.dk>
 <8025a63c-6e3c-41b5-a46e-ff0d3b8dd43b@gmail.com>
 <639914bc-0772-41dd-af28-8baa58811354@kernel.dk>
 <69530f83-ea01-4f06-8635-ce8d2405e7ef@gmail.com>
 <d4077350-ac9e-49ac-8720-ee861b626cb8@kernel.dk>
 <03d7e082-259a-4063-8a98-5a919ce0fe3e@gmail.com>
 <40c07820-e6e2-4d90-a095-31bb59cedb8d@kernel.dk>
 <4cd58a90-2cbb-443c-84ab-9a9e0805e72b@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4cd58a90-2cbb-443c-84ab-9a9e0805e72b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/24 3:47 PM, Pavel Begunkov wrote:
> On 11/3/24 22:40, Jens Axboe wrote:
>> On 11/3/24 3:36 PM, Pavel Begunkov wrote:
>>> On 11/3/24 22:18, Jens Axboe wrote:
>>>> On 11/3/24 3:05 PM, Pavel Begunkov wrote:
>>>>> On 11/3/24 21:54, Jens Axboe wrote:
>>>>>> On 11/3/24 2:47 PM, Pavel Begunkov wrote:
>>>>>>> On 11/3/24 17:49, Jens Axboe wrote:
>>>>>>> ...
>>>>>>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>>>>>> ...
>>>>>>>>          nd->head = prev_nd->head;
>>>>>>>> @@ -115,7 +115,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>>>>>>>>          notif->opcode = IORING_OP_NOP;
>>>>>>>>          notif->flags = 0;
>>>>>>>>          notif->file = NULL;
>>>>>>>> -    notif->task = current;
>>>>>>>> +    notif->tctx = current->io_uring;
>>>>>>>>          io_get_task_refs(1);
>>>>>>>>          notif->file_node = NULL;
>>>>>>>>          notif->buf_node = NULL;
>>>>>>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>>>>>>> index 7db3010b5733..56332893a4b0 100644
>>>>>>>> --- a/io_uring/poll.c
>>>>>>>> +++ b/io_uring/poll.c
>>>>>>>> @@ -224,8 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
>>>>>>>>      {
>>>>>>>>          int v;
>>>>>>>>      -    /* req->task == current here, checking PF_EXITING is safe */
>>>>>>>> -    if (unlikely(req->task->flags & PF_EXITING))
>>>>>>>> +    if (unlikely(current->flags & PF_EXITING))
>>>>>>>>              return -ECANCELED
>>>>>>>
>>>>>>> Unlike what the comment says, req->task doesn't have to match current,
>>>>>>> in which case the new check does nothing and it'll break in many very
>>>>>>> interesting ways.
>>>>>>
>>>>>> In which cases does it not outside of fallback?
>>>>>
>>>>> I think it can only be fallback path
>>>>
>>>> I think so too, that's what I was getting at. Hence I think we should just
>>>> change these PF_EXITING checks to be PF_KTHREAD instead. If we're invoked
>>>> from that kind of context, cancel.
>>>
>>> Replacing with just a PF_KTHREAD check won't be right, you can
>>> get here with the right task but after it has been half killed and
>>> marked PF_EXITING.
>>
>> Right, but:
>>
>> if (current->flags & (PF_EXITING | PF_KTHREAD))
>>     ...
>>
>> should be fine as it'll catch both cases with the single check.
> 
> Was thinking to mention it, it should be fine buf feels wrong. Instead
> of directly checking what we want, i.e. whether the task we want to run
> the request from is dead, we are now doing "let's check if the task
> is dead. Ah yes, let's also see if it's PF_KTHREAD which indirectly
> implies that the task is dead because of implementation details."
> 
> Should be fine to leave that, but why not just leave the check
> how it was? Even if it now requires an extra deref through tctx.

I think it'd be better with a comment, I added one that says:

/* exiting original task or fallback work, cancel */

We can retain the original check, but it's actually a data race to check
->flags from a different task. Yes for this case we're in fallback work
and the value should be long since stable, but seems prudent to just
check for the two criteria we care about. At least the comment will be
correct now ;-)

The extra deref mostly doesn't matter here, only potentially for
io_req_task_submit().

-- 
Jens Axboe

