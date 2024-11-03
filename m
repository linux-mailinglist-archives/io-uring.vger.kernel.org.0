Return-Path: <io-uring+bounces-4374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92F7D9BA87E
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41DEE1F20FDA
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D254918BC27;
	Sun,  3 Nov 2024 22:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NPdKULJ8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F69AC2FB
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 22:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730672315; cv=none; b=OsdJ0VXIp/r9chqbxgn2rQVsAEGDTzmKLfb7a90v0yDAcpuSCrSNfFrqD/FSRuoSOGb4DHZSIHr3+gYKYdzuHjIR4VjJu4kDv/YEH/GAZFAuuBDQTdW8s7uuskmX4CQpH0+FvG4ziDijZvXuhV2nOdWkJZJq5BiXHWopcoy87sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730672315; c=relaxed/simple;
	bh=j2IMa55Kf51bV2yBdHxAkZC3Yr3JwhR84+uQXjD8UzE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SZ7jzxa4Dc3FkLbDa5FHWT0HqZqY5xGNkf8V9fgk4HFNHVYtU3JcZDf8JW2iBc7zIbECG0D6WYE0P8ho52W3843H9WApCy+Gd3zFTT/tI6zLhZ9laxwjOCy0x3q8L5rJApWmkFkF+QDdNg6c3IT/wJqER9ewSE0ReoHAFJbO7r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NPdKULJ8; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7eda47b7343so2240369a12.0
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 14:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730672312; x=1731277112; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wSRVzj6LrK5JoywxshhGMKZh92xKUrfjp4yCEYQUtxg=;
        b=NPdKULJ8KqV+zWZcpq/7nyaIV5CojjIOhNrppxCRk1q2kQHYLc9lXeYhMrulFFt5sB
         iNLmla5vEcpHqT5MIZQifl+20IUSC7zeH6LVBnksxZ0KaNyB02zx7BbTScmC8g8c7UXO
         5HZYdZrBlG4EqOGtNq1Xu4sseHUSp6Ue83GJd3e7vd2hHNs4TPqT3Xf6fRJHdZu0AI3d
         C6NUnCdHvV/ydTtWhbgml2yd9zGlYZM5tLHmD3+qHZvLM4U6/yixcv7W6vIM907q07Cm
         QBlvWWhySHKtxUW4LeLdq+4mBe8WBPFBnUukyrfLaH8vKfpeOftMxNeZ7cn8OA2ofXCS
         Ff8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730672312; x=1731277112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wSRVzj6LrK5JoywxshhGMKZh92xKUrfjp4yCEYQUtxg=;
        b=UxZ+mTQvD5rV0Beu8H89+MsqVSEj49z4eCUFONyivUdJAW3gxJ4F7Iy8d6b6MDY2AX
         JfkeaxobhbWZl5d8iT/y6xBdJiblkrefaQj9GpZAfhczlRDQ6Mc2dUJ2Egc2fg9lO/ib
         B/FgJSAHZjhteUD043/UHWyUWuqy4DX8VKxQRKqVkk5no2PeLHVPlsg22jIKSA3pVJc6
         W/F16ClHfFvDyu3teRwHXycNnGsHAeTSWOFkmF7arO5s3vT/WN+LWtVaf4GLxr0We5fo
         6l9Hpi29wN0HJXefBEfd3Yl14PMD1E26Cbdb7OpPsA2U9CNCkcDC1kP51q9IT1CR9t9B
         FHPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVV1cSQpaMKVZJxCkms1wKlfm48SYZMIbffz8JtBl/KYMZ9FQs4ZVCBQ6n4/Uuviu58jX24OV3mA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx36r+xOQ3W8vk3/Rsk4enHayC6/WL0mo8ONAZGGFeDaJcslMck
	HnJ0idS/zWlyRFLhKz++NRyakiiYDfPWUDk2DsYO2M6XOMUSqNQy0E4EJpy8h/Gow8gVcKNG/Af
	gXcI=
X-Google-Smtp-Source: AGHT+IF9z11aQfSCfvlNllW1R97Dr8cHuQlXO4CHQns37eVtdrc5JO99SkAOiBZeH9iWMW70/gFN8A==
X-Received: by 2002:a17:902:fc8f:b0:20c:f648:e39b with SMTP id d9443c01a7336-210c6872d40mr437940105ad.11.1730672312018;
        Sun, 03 Nov 2024 14:18:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211056ee4b0sm50116565ad.16.2024.11.03.14.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:18:31 -0800 (PST)
Message-ID: <d4077350-ac9e-49ac-8720-ee861b626cb8@kernel.dk>
Date: Sun, 3 Nov 2024 15:18:30 -0700
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <69530f83-ea01-4f06-8635-ce8d2405e7ef@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/3/24 3:05 PM, Pavel Begunkov wrote:
> On 11/3/24 21:54, Jens Axboe wrote:
>> On 11/3/24 2:47 PM, Pavel Begunkov wrote:
>>> On 11/3/24 17:49, Jens Axboe wrote:
>>> ...
>>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>> ...
>>>>        nd->head = prev_nd->head;
>>>> @@ -115,7 +115,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>>>>        notif->opcode = IORING_OP_NOP;
>>>>        notif->flags = 0;
>>>>        notif->file = NULL;
>>>> -    notif->task = current;
>>>> +    notif->tctx = current->io_uring;
>>>>        io_get_task_refs(1);
>>>>        notif->file_node = NULL;
>>>>        notif->buf_node = NULL;
>>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>>> index 7db3010b5733..56332893a4b0 100644
>>>> --- a/io_uring/poll.c
>>>> +++ b/io_uring/poll.c
>>>> @@ -224,8 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
>>>>    {
>>>>        int v;
>>>>    -    /* req->task == current here, checking PF_EXITING is safe */
>>>> -    if (unlikely(req->task->flags & PF_EXITING))
>>>> +    if (unlikely(current->flags & PF_EXITING))
>>>>            return -ECANCELED
>>>
>>> Unlike what the comment says, req->task doesn't have to match current,
>>> in which case the new check does nothing and it'll break in many very
>>> interesting ways.
>>
>> In which cases does it not outside of fallback?
> 
> I think it can only be fallback path

I think so too, that's what I was getting at. Hence I think we should just
change these PF_EXITING checks to be PF_KTHREAD instead. If we're invoked
from that kind of context, cancel.

I'll adjust.

-- 
Jens Axboe


