Return-Path: <io-uring+bounces-4371-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF139BA868
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:54:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0E791C20D82
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 21:54:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27C1618C927;
	Sun,  3 Nov 2024 21:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GFQaBKF2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED1E16B38B
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 21:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730670875; cv=none; b=R8vAAxntTtE0H88pLodoY/MC5g8bKVBLMVql0U+VTZZYJySDuTi8/cf+2HnHiI/5FEJm3du6/fhNapSR6AjJM77mYByPZeoM5Ee5pUukupubxShQCAiFrv4WQJAeby5zsiEudBERP3qU/lOYU9quHadE+fGsEjUS05J6vsDsafU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730670875; c=relaxed/simple;
	bh=NLz9ZbTCBEkBAplGaDLXQxXRxGA4epqstaXCGvWqiDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ovzeymq4iuyJUPhLmdlJKYd9ltOJkOB4YbEhsTe9Wx34p0DO/TBUXMk5ws2dFT1/hyMamn9cRkQIXEU69EiKm0G/ZRj14vaNXCsQGYwfh24PovXdBn0FESxlsbuDs6Kj51/XwkF0ktJlu8MKjH4PDf+V6dQK7i39+wyLvcRWCWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GFQaBKF2; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2e91403950dso2525264a91.3
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 13:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730670871; x=1731275671; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EiUtd6IQ7yaJCNDI4AVV6ftSo8mhzSjBhp9LyfP+CiA=;
        b=GFQaBKF2RKaAcbkwkPDVNZdkGHoG7CGDUuY1ED2h2FfHjotp2gwPa4AfJ6Atwwhl+8
         h+thsYE/XlTWLEBGgtin8HOYVCiYZjpeeKrO8j+nQqIE1hGeQvad3btJHJbZGjMkdlCd
         PK/M9Xu69nMQ1JXkO/PaziHLTdqxKI+F0EvfV88M/CWLjkDgileJqwRsVY47bsJYb5DU
         ftZp+Wk3Iv2ky6qZP4jMD2yG+8JcOw/8CDf3W+he9sfHwQxePf/MIgHC2sRiInQk3oF4
         MTCzud985IJv4g6kvVWRxVBDqDHYA0BJTgUJvfXD1FryG+FFlWbaLsQDptBCg9cC0qRX
         OHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730670871; x=1731275671;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EiUtd6IQ7yaJCNDI4AVV6ftSo8mhzSjBhp9LyfP+CiA=;
        b=MAl/7AZ5xahL9w0/ko3Tlng7rYdYngTROcnQqp2KAljeza1E64QtJUO4Rgr+SJqG6u
         3Ar3up0BRLdJeWfb98mfLPvsLTndnnTTWRRHRtbcLoK5NYE9iM27xLkA7NXPk/gTqIcE
         MGvUpq/cPtMD+TMSvMHLmZ1EKD51o4CfSappREgj1LlzQALB1/k/e2AuJAnv0pekFkkH
         A3HE4GhJ68NgCjbbctnPXuQF46HGamK5kMpgyUO3hHUGln0zr9/0WiCmqQJVvFrpJd8d
         svGoBfkv/gal3Tlywm88uECRIA9fwo+lhDZ6IsNM25Yezagun0N6MsfOxb+HF0pnfknm
         KCWw==
X-Forwarded-Encrypted: i=1; AJvYcCU9ms756DbofZfPCOVb+EpPFK8KMaUFjRrgINGB7NkuIHMHt9oZOYnL+VUoELmtXTiiYJC8mQ3scQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwuHHH0a+iUeCrUF7Kny24tQldo91Mvo6r76s9It9lda9MnIhuo
	n/MRLblMRdhrW3aKwcjZ3qMxwU3ThiiUqjhQk5P+8g79kOIOZt8ACWTan65/iIzhLao+eihjxZC
	VQo4=
X-Google-Smtp-Source: AGHT+IHZeJsH0zTEVjrw45FZhLVcdHCtO+j2PqFkQD7Ma5FyQeb1fuQZlW3L/zLEL25/Bl01sy3Y5w==
X-Received: by 2002:a17:90a:17aa:b0:2e5:5ab5:ba52 with SMTP id 98e67ed59e1d1-2e8f1086262mr34826565a91.20.1730670871548;
        Sun, 03 Nov 2024 13:54:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93d97c737sm6296688a91.0.2024.11.03.13.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 13:54:30 -0800 (PST)
Message-ID: <639914bc-0772-41dd-af28-8baa58811354@kernel.dk>
Date: Sun, 3 Nov 2024 14:54:29 -0700
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8025a63c-6e3c-41b5-a46e-ff0d3b8dd43b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/3/24 2:47 PM, Pavel Begunkov wrote:
> On 11/3/24 17:49, Jens Axboe wrote:
> ...
>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> ...
>>       nd->head = prev_nd->head;
>> @@ -115,7 +115,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>>       notif->opcode = IORING_OP_NOP;
>>       notif->flags = 0;
>>       notif->file = NULL;
>> -    notif->task = current;
>> +    notif->tctx = current->io_uring;
>>       io_get_task_refs(1);
>>       notif->file_node = NULL;
>>       notif->buf_node = NULL;
>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>> index 7db3010b5733..56332893a4b0 100644
>> --- a/io_uring/poll.c
>> +++ b/io_uring/poll.c
>> @@ -224,8 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
>>   {
>>       int v;
>>   -    /* req->task == current here, checking PF_EXITING is safe */
>> -    if (unlikely(req->task->flags & PF_EXITING))
>> +    if (unlikely(current->flags & PF_EXITING))
>>           return -ECANCELED
> 
> Unlike what the comment says, req->task doesn't have to match current,
> in which case the new check does nothing and it'll break in many very
> interesting ways.

In which cases does it not outside of fallback?

-- 
Jens Axboe


