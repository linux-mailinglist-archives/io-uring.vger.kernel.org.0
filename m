Return-Path: <io-uring+bounces-4373-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB50F9BA873
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:05:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 725C11F20F39
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE8718595E;
	Sun,  3 Nov 2024 22:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHQXsyRt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D505F9E4
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 22:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730671514; cv=none; b=shOA3A7n0BBC9omqFmpRxMKBobABBiX1sjhUbJ+BMavniMdpfv6w2zDSf5cac7Qjpup02M8/AE/MwDoMwoisfhGydHbj34pgVOjIRbnk+NUTGskdD0ylLKU95AXOgRxvBDY8h5+PmOqJMV6Hwz1nWyoVuCetS4fNgE3SW9qJ22o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730671514; c=relaxed/simple;
	bh=uvASm88dQb/yZzOJA4yaLOu+n4q1DXGE5bWN8rT9GH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=egxaiX5NCkG5WBrg/HH/CkSEr6SuoPYomftmMOjZg4Dl4yFu4IVZ6Mg3xzG7fALeIyEhLQnkL5XdpVtoji5BqtA4YujsjwJhPwYyfbmFaB91fLhIAnkSvO70hkZUa7sTQuE1DmFiAthBrX51lXRSNo1sxbkZMdftUo1So+lJwuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHQXsyRt; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4315e9e9642so30734695e9.0
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 14:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730671511; x=1731276311; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Nw8brlrP64FSGrrKl0F87SVuwrl5af3912Pr/GqQkbM=;
        b=RHQXsyRtGSk4tOh9C22aOBGpkJXQi9v82Y5TYYelfacPMa1ix0tgRjHzCoKn8mF4mH
         Lhv7qZ4StXaCSeOFKFvUKEUW5N1Fxc7jiFfQeMWnXfdZaQUB5ORQ66SdehMUWi6mR26Y
         VkXUh5LXh1ZNScxlbPpaGNmGoWN5WVa3VJsePLywMuWECVE48rrTJEyNykhXKLugmnVw
         oO50t538ETMEBsy2IEj8dMQ5HWo3cIxBivEUEbqeFy4HJ6KdD4Z0eMeHC5gZqDD9nzoJ
         grSglOvguNUaEHMudNDkJ0B0s9y5Z1Hnyt2upM3AW6ygzHITe8ufga9IZe7s/bSR7Bzq
         1ufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730671511; x=1731276311;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nw8brlrP64FSGrrKl0F87SVuwrl5af3912Pr/GqQkbM=;
        b=Q9iTXAH+PH1kMG5fMv/LaKzhETpEdNIylJyDPLYuJmvOfSaNagkjTbgC3gEqNKBN7R
         BaZ/tUCnVbX4V4F2S5iDmIBhVY/cK85iOVH2YYwsWE3s2dZMr+oWCs5PSmoRykS5yqEo
         SSzADPVjy0GNodPk7xp1uFDWmDr8mgLXZFu9ZQ/3RMfcbK4WjNmuqDLLz1QMpn2/9AdP
         8a/ljuTjaQZEVzJ6/rF2B47QkkdGLF/9kPbl7fBXcmNXFVtZEeOl/XiXB4ApgXeDXk4U
         Cv2nnZM37rCWXLnXKove3U2oA4tF3XjBl2un8FnHBbUGyhSWnu3mPlY3u9oyFAddVKAc
         LEHw==
X-Forwarded-Encrypted: i=1; AJvYcCV1KhMjmUQyWROxZx+2HggnDkgHNRLtj/k2qIvoaYLeL8u0+MzfqgxDxUqcOrr4o5N+OMV2gBi1kw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi1Q+fQ9dSgKR4PCgFUbdrg5uzrBh3nUdOey1OVxs5EFOOOTJo
	TWb8idjJqDyudt2dW/MKaVIOpmrJcRyPgssDNjWblImhOMtDptm7
X-Google-Smtp-Source: AGHT+IGw0CcR1UqsiGJTL+unQ4ov/3q1pKtXag9e1z5GqkHB/1md1LoqLZha14qafMyMcig+X7aOhA==
X-Received: by 2002:a05:600c:3c8d:b0:431:508a:1a7b with SMTP id 5b1f17b1804b1-4327b801250mr117967955e9.34.1730671511437;
        Sun, 03 Nov 2024 14:05:11 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10b7d2bsm11512212f8f.16.2024.11.03.14.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:05:10 -0800 (PST)
Message-ID: <69530f83-ea01-4f06-8635-ce8d2405e7ef@gmail.com>
Date: Sun, 3 Nov 2024 22:05:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: move struct io_kiocb from task_struct to
 io_uring_task
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241103175108.76460-1-axboe@kernel.dk>
 <20241103175108.76460-4-axboe@kernel.dk>
 <8025a63c-6e3c-41b5-a46e-ff0d3b8dd43b@gmail.com>
 <639914bc-0772-41dd-af28-8baa58811354@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <639914bc-0772-41dd-af28-8baa58811354@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/3/24 21:54, Jens Axboe wrote:
> On 11/3/24 2:47 PM, Pavel Begunkov wrote:
>> On 11/3/24 17:49, Jens Axboe wrote:
>> ...
>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>> ...
>>>        nd->head = prev_nd->head;
>>> @@ -115,7 +115,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>>>        notif->opcode = IORING_OP_NOP;
>>>        notif->flags = 0;
>>>        notif->file = NULL;
>>> -    notif->task = current;
>>> +    notif->tctx = current->io_uring;
>>>        io_get_task_refs(1);
>>>        notif->file_node = NULL;
>>>        notif->buf_node = NULL;
>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>> index 7db3010b5733..56332893a4b0 100644
>>> --- a/io_uring/poll.c
>>> +++ b/io_uring/poll.c
>>> @@ -224,8 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
>>>    {
>>>        int v;
>>>    -    /* req->task == current here, checking PF_EXITING is safe */
>>> -    if (unlikely(req->task->flags & PF_EXITING))
>>> +    if (unlikely(current->flags & PF_EXITING))
>>>            return -ECANCELED
>>
>> Unlike what the comment says, req->task doesn't have to match current,
>> in which case the new check does nothing and it'll break in many very
>> interesting ways.
> 
> In which cases does it not outside of fallback?

I think it can only be fallback path

-- 
Pavel Begunkov

