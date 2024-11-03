Return-Path: <io-uring+bounces-4376-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 299329BA948
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0DAD2838FE
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DBEC18B478;
	Sun,  3 Nov 2024 22:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MdCMIsJn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6BA188736
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 22:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673365; cv=none; b=f8iaTYMPBX8xGI0TPuVsciCF8NmL8esoOoHYG9QkvpZZnlh8BT0WT73Jb5eZLBE8Oljt3/d91xV/Jq+hqMw2RfmVrKa3ec5CNU5tD10JOEfMmtZQ1SKdOXiyy87RXkdSdghre4+DuOmXFCSmW4tRFTH2NMx4TzkhM2QibuVPf2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673365; c=relaxed/simple;
	bh=S71J6lbv8qsindEEyeUsgQ7WS9dxx5mNR39y8tmwk7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NVQPS+l/iDRHWWF236Wjm69KmMu27W1KFCBLErJ0Xc5+rlB0LxpIlISPORCWa4kArNj1jbKgKugNKrM1MYhRuJoXP4E0m2Vy6pefsloY3ULGiwapI3PBWsJu6JY09PdW1Wu2tLSCqmAu3IBmwzRpM+FbsRweEAN7S6qO6Ec9+wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MdCMIsJn; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2feeb1e8edfso12385281fa.1
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 14:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730673362; x=1731278162; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PlBm1HyinlcegN4NGoUaTueHw+0SOUGNy+WhM63ZzQ4=;
        b=MdCMIsJnj3kZDWcRaSy9vijjBaQ3K9I3VO9+FqdRfNkCMEgyFr8jNbcLNSfAn1bwhg
         f1aaLuo+wn7lKC2p0U9rmNdEQ4IdXqVm6FQe/Kj7oRyZl0KshDoDjW46poLjYI6pB0y8
         wo6l1E+V0ebFviAONYhe48ahMzyuv8a0Q7QNdj2K7krg4U9OowMt8jk0bB1E5JRGQtD8
         xoFWH405pgKCpwrnou/fTPDkwnsh+xaZkiOKWADhMztOyeZsTFeOU/pHqWnM2Y6a4imv
         lyO4bhuCCXSQRl0UxpAoD/pwcPk3QGsFOpXKxaeYZgPsI/oB4FL+RJ2Q4dANekmY9Q72
         s6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730673362; x=1731278162;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PlBm1HyinlcegN4NGoUaTueHw+0SOUGNy+WhM63ZzQ4=;
        b=MGSgDolq4Goe05aY5/Lj2S1XTKVC/iQZRnlmq9vFoL9pI9xsTgqDylKpPzcZebCje9
         5kr4ZruC4TU4cugReaN3oJK508jWPn9HLsBaikyXiWkIDBFEWOuxdxnwShlDYM5EMArC
         xKo+73Vl+5nMAHzFbEuYYEEiMe7GcNFP88oBaTwZKkEG4IFrBTIjGIcc2ApGd7Kooquu
         kly5sVQONzRlY0RUA8hGDcdLOHgFWIyroxyNAdgbgLV4D7sjnvLCbAe99U2f2ZXI00XF
         sZbDQ2tfhjplNtl10KoEvEOa98bCxiF7QxChid6EyYo6PDlBuVw8uGL+jjufP0To6aXa
         G4PQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/1tmQ30KjiwYR+vYuywzGCgvVTOk/GzpKhMSciAbwzGbuK1AqbxIHZOU3cZ6N9HqczFZv/x6Tlw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwcCu6rrGBXETkLwMlBXFyV2a2dDtvSDTKFvd2qMJJI7FC4a9g5
	I3rzTYR79lGitWBwuPZKUlUN36zE6jFmQFug0ToCAOf3A712ALJN
X-Google-Smtp-Source: AGHT+IEbp1ZznTz5ma9JWRtQfO50Cr5jCTzqTnAFpyYSLFZch1YXRMdxd+245y05EaTbu4J1B4j13w==
X-Received: by 2002:a2e:b8ca:0:b0:2fb:51a:d2a with SMTP id 38308e7fff4ca-2fedb7a223cmr62839321fa.12.1730673361455;
        Sun, 03 Nov 2024 14:36:01 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e565e0969sm474189966b.101.2024.11.03.14.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:36:00 -0800 (PST)
Message-ID: <03d7e082-259a-4063-8a98-5a919ce0fe3e@gmail.com>
Date: Sun, 3 Nov 2024 22:36:06 +0000
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
 <69530f83-ea01-4f06-8635-ce8d2405e7ef@gmail.com>
 <d4077350-ac9e-49ac-8720-ee861b626cb8@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d4077350-ac9e-49ac-8720-ee861b626cb8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/3/24 22:18, Jens Axboe wrote:
> On 11/3/24 3:05 PM, Pavel Begunkov wrote:
>> On 11/3/24 21:54, Jens Axboe wrote:
>>> On 11/3/24 2:47 PM, Pavel Begunkov wrote:
>>>> On 11/3/24 17:49, Jens Axboe wrote:
>>>> ...
>>>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>>> ...
>>>>>         nd->head = prev_nd->head;
>>>>> @@ -115,7 +115,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>>>>>         notif->opcode = IORING_OP_NOP;
>>>>>         notif->flags = 0;
>>>>>         notif->file = NULL;
>>>>> -    notif->task = current;
>>>>> +    notif->tctx = current->io_uring;
>>>>>         io_get_task_refs(1);
>>>>>         notif->file_node = NULL;
>>>>>         notif->buf_node = NULL;
>>>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>>>> index 7db3010b5733..56332893a4b0 100644
>>>>> --- a/io_uring/poll.c
>>>>> +++ b/io_uring/poll.c
>>>>> @@ -224,8 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
>>>>>     {
>>>>>         int v;
>>>>>     -    /* req->task == current here, checking PF_EXITING is safe */
>>>>> -    if (unlikely(req->task->flags & PF_EXITING))
>>>>> +    if (unlikely(current->flags & PF_EXITING))
>>>>>             return -ECANCELED
>>>>
>>>> Unlike what the comment says, req->task doesn't have to match current,
>>>> in which case the new check does nothing and it'll break in many very
>>>> interesting ways.
>>>
>>> In which cases does it not outside of fallback?
>>
>> I think it can only be fallback path
> 
> I think so too, that's what I was getting at. Hence I think we should just
> change these PF_EXITING checks to be PF_KTHREAD instead. If we're invoked
> from that kind of context, cancel.

Replacing with just a PF_KTHREAD check won't be right, you can
get here with the right task but after it has been half killed and
marked PF_EXITING.

-- 
Pavel Begunkov

