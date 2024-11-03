Return-Path: <io-uring+bounces-4377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A019BA950
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:40:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51C5F1F2117E
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB09E165F1A;
	Sun,  3 Nov 2024 22:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Jgaf5+DH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A68154C08
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 22:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673619; cv=none; b=gjqLOw8Ct2DbzB6TsDtKJTyxZy5NoIlh2g24bZErcqzumg+sZJosmcpw8h+stv7sVVY/aLGtzmbyKAGFF1rsmuK8TD6+9xdJAqC9rO5xiX+6a1sa72m/e8cAof5/z+aGORteVRfDRspK4B9BKGot5Bl3f/+2kOfIRcSAIa8/X50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673619; c=relaxed/simple;
	bh=khYVyRi2cYLuLt245jotUh/gWe/kAzIaXy79HhdfXmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=e61G3G3/36NqxUmG8kebiWW1r9y0zyGpQ/zqNi7kjykM6ImQ8xQEL2T9ip/HxyTrXE6VzzEHSKz5Mc9xFNsnt+/gptnWX7wQHZF5gTTkDesAeK+VLxMT8MtMibOoP0M2JC3ji9ElWUhGVlfFkqy/Wfy+0YoJc9M50g5qX+XJo40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Jgaf5+DH; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-71e625b00bcso3219116b3a.3
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 14:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730673616; x=1731278416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3xKOXfj61BUicoC/tWvlMf38SAAwmCYPMhu8DQjgGK8=;
        b=Jgaf5+DHA6VdlP/EV964afhj1PrCTL1zXCEIYW/W5vi0RKdkmaTGXy8DnP2ThDEs+7
         ezMspFHJ+pPXhjwObxHYXTcHkjSAmTKlceJCzTtBv2WQtAcRjYW2oGZzbnPJ4FY3PzCr
         u8579TDu9Fd2UZ+JraxZzC5VhH+jNipvhRU3HnzE9RQ3RkPG9hXYPbEPsx94PwcnCNeS
         MK6OPzNvVcovHVzFUFabbObkNp1mOoO3PoAg4tYZSucxOuYVAOWscJj/qKuH7A1h3IWH
         NitExNK7aKbBaHReN4z659fKsBltiXcoKn2yV8DMRdvoXy7UHpoXNacM0MhTEEwkz9in
         oxXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730673616; x=1731278416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3xKOXfj61BUicoC/tWvlMf38SAAwmCYPMhu8DQjgGK8=;
        b=cfQiF0F6n1aLfvu0rQnTK2wZHKLu2TJZgoeNxZJsjsXO+sRhXeXX9ORcXsVlwDk4Zj
         ZveXdslK+532BPGIYL2McZBpwCftVrM5HRp5wCvk2zV9wHS3CkQbtWsYEBICnQh9bEHy
         L+Y8rlCqsGu8bXk9AHbr2ohdXnQhyUFXRqf2P4rFJ641CuvGem1PmKFuHGs4Z/Fin5gF
         zm6GF13u5oIz1p5uUq70V6iG2242q45/pRa2DmlMJsvAhh9ZctBX2FSGg6H2MgbU+YT9
         9fe/NSOcGXvNhdgQPnXDiuM4ebISEVvDsFsDgb+8eNX4uiL2fnKFSvcOAmcbi27rSdmS
         PINA==
X-Forwarded-Encrypted: i=1; AJvYcCWO1NB/6kPd6s1jR61AuRrFq1xiiDRchMWfAdd+R4PzjhM4UJnhb97bmopIEfQZ6oAo9q2m3bZtSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWq2BH3T4aoegS0DuaoaTZz9VkJZyalXNF+NTlxOXXLLIdMnbN
	yg4YpIAWcNBy9FsN+aKh6/AiCGaHKfiZ6cKxhqwNI0HJI18sZehKiM3jLtIHJw3tlhOxsmzWqHv
	eBYY=
X-Google-Smtp-Source: AGHT+IGnNFWFpeCxKrLkwL/8s1V2JvI8Vrk7TAJOa3PB7XNHEC2WUkdqPxr5lKGEtkvo7eY6mvVczg==
X-Received: by 2002:a05:6a00:1910:b0:71e:4c34:e294 with SMTP id d2e1a72fcca58-720b9c0633amr19559637b3a.7.1730673615852;
        Sun, 03 Nov 2024 14:40:15 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc2c498esm6326219b3a.97.2024.11.03.14.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:40:15 -0800 (PST)
Message-ID: <40c07820-e6e2-4d90-a095-31bb59cedb8d@kernel.dk>
Date: Sun, 3 Nov 2024 15:40:14 -0700
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <03d7e082-259a-4063-8a98-5a919ce0fe3e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/24 3:36 PM, Pavel Begunkov wrote:
> On 11/3/24 22:18, Jens Axboe wrote:
>> On 11/3/24 3:05 PM, Pavel Begunkov wrote:
>>> On 11/3/24 21:54, Jens Axboe wrote:
>>>> On 11/3/24 2:47 PM, Pavel Begunkov wrote:
>>>>> On 11/3/24 17:49, Jens Axboe wrote:
>>>>> ...
>>>>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>>>> ...
>>>>>>         nd->head = prev_nd->head;
>>>>>> @@ -115,7 +115,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>>>>>>         notif->opcode = IORING_OP_NOP;
>>>>>>         notif->flags = 0;
>>>>>>         notif->file = NULL;
>>>>>> -    notif->task = current;
>>>>>> +    notif->tctx = current->io_uring;
>>>>>>         io_get_task_refs(1);
>>>>>>         notif->file_node = NULL;
>>>>>>         notif->buf_node = NULL;
>>>>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>>>>> index 7db3010b5733..56332893a4b0 100644
>>>>>> --- a/io_uring/poll.c
>>>>>> +++ b/io_uring/poll.c
>>>>>> @@ -224,8 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
>>>>>>     {
>>>>>>         int v;
>>>>>>     -    /* req->task == current here, checking PF_EXITING is safe */
>>>>>> -    if (unlikely(req->task->flags & PF_EXITING))
>>>>>> +    if (unlikely(current->flags & PF_EXITING))
>>>>>>             return -ECANCELED
>>>>>
>>>>> Unlike what the comment says, req->task doesn't have to match current,
>>>>> in which case the new check does nothing and it'll break in many very
>>>>> interesting ways.
>>>>
>>>> In which cases does it not outside of fallback?
>>>
>>> I think it can only be fallback path
>>
>> I think so too, that's what I was getting at. Hence I think we should just
>> change these PF_EXITING checks to be PF_KTHREAD instead. If we're invoked
>> from that kind of context, cancel.
> 
> Replacing with just a PF_KTHREAD check won't be right, you can
> get here with the right task but after it has been half killed and
> marked PF_EXITING.

Right, but:

if (current->flags & (PF_EXITING | PF_KTHREAD))
	...

should be fine as it'll catch both cases with the single check.

-- 
Jens Axboe

