Return-Path: <io-uring+bounces-2703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C61CD94F136
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 17:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 454D8B25BBA
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 15:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C3B1153BF6;
	Mon, 12 Aug 2024 15:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3CdMYtw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFC91E504;
	Mon, 12 Aug 2024 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723475004; cv=none; b=YMbztLkFK3nA874KchpOz2ISlZSiShfpJNiO3by/+/j91TDwLci6Gl9afqnGs72wd2bIRGGXk02QXI3n0tzL4As/nCRl7e4qHWfWTqMe+VwY/pixkVZMbNGaC1O4zP1rv6gFXpSnkGDFHBhvmwcfn9u019gwVWtQIGuhOCzBLpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723475004; c=relaxed/simple;
	bh=QwP0vGEK4sodQeENKkw2OjgxGCSKK/RmzQvfNDTIaQQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nc8eojbH+AAmI8SnavgjqHdLiO7bkAdm5kPP0ZqTexUpBC3RPekwmcVdPKVsFsjQUha2Npj8myU6XmlyJQdpt148MYLnskyrVYCFxH09avt4WPzEaAGQ17dycKfX0A/yTTFgKXkhjl52hwq47NsuP4LQY+LIUyxLlT3oauaUFZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A3CdMYtw; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42816ca782dso34102035e9.2;
        Mon, 12 Aug 2024 08:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723475001; x=1724079801; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JtvyEdKnl129bGdPA8p9XAq76/4RIujBwi8fVV3N7ko=;
        b=A3CdMYtwwoSthjApoFOHSkbSeygcUiMlpRxzqdr/fOlbRY3NeUmZZY0MUmlwzI8Vij
         eYHu6TnLNQ00K4AmKfg7/CSljKjF673uRrJZFPtZ5ZOeLpzotpksYVh9RhftiLY1iIp4
         mnHHKvc76qYZLBH44UPw0ROTP3IsgduYkgBczV/bKPQlFIzd/+BzBLCMMCW/WYKZPgsk
         Tl0EFUhu0m367cL5lHbqcHuM2xt/uHyCt/BsUTHvlBDaCdZbFQlqZrzCkD7A0rD5F68b
         spA0XmRnAwO8TUeFNUyckIj8NujdDQbHlcmj5vHm1gF09eSf6fh53uY+cYJbjGQ1o+Od
         BuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723475001; x=1724079801;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JtvyEdKnl129bGdPA8p9XAq76/4RIujBwi8fVV3N7ko=;
        b=rETiRnemtmmYfWOc3Uon5d4ztb5OSnStjgjZ97f9zu1dgv8c4VYLWcohbjyK8VA+Wk
         P27zLlDkHXFvuePAxkverMMQHCaPaAK2+MQGd51mE0O3WthPVWyQ4mpIlWnXT7VFCxFj
         TfsXVgku1gvCxfkY+zciOS4KpZ16XCLmjlNrJhtsmBi4+hKyHresL2ztlgjka1wTnjEu
         Q4Igc4Im6NdwmAtwgamq7wUhIiyTTqlfHT7gEDZJYwlI0Q6G41aO7OFEKH9m2QI4qyb9
         ABi9TMZqfhOe9mjg0L49YWkrRaHqYKIHauO96DkqDODn2WWMOrNt3owLAHYZHEVj0U63
         es4w==
X-Forwarded-Encrypted: i=1; AJvYcCV3XVYw01AjdrpPyijynNBlcIYuFNt2eY092C1zaPmReKdn80qMi9Drnf1s8SU5qdrjNEc20tYz4Xo+3RW21K5xtm0nPLBrGtM=
X-Gm-Message-State: AOJu0YxBbHoTnAR9CalOATz22PKa4fUv57qTg0MH2EQA4OsbzGcAzIzC
	oQ5xTznJL8n09EMl2Sb7cVtceu5Ia2Vk3HvJQu0tOhk7Ht4DVIzk0VMD8mUU
X-Google-Smtp-Source: AGHT+IFVGL89yyQWV91H1VKNCyGPDmxSxPR8YjhTs/YbqMc6TP8W39+rrnwvolD9NRYXHYpYu461mQ==
X-Received: by 2002:a5d:694f:0:b0:367:8876:68e6 with SMTP id ffacd0b85a97d-3716cd1fe1amr358504f8f.48.1723475000675;
        Mon, 12 Aug 2024 08:03:20 -0700 (PDT)
Received: from [192.168.42.116] ([85.255.232.227])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4c93833asm7784641f8f.41.2024.08.12.08.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 08:03:20 -0700 (PDT)
Message-ID: <899fdd00-a3ab-43df-8f4a-04b36fdcddb4@gmail.com>
Date: Mon, 12 Aug 2024 16:03:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add io_uring interface for encoded reads
To: Mark Harmstone <maharmstone@meta.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20240809173552.929988-1-maharmstone@fb.com>
 <Zrnxgu7vkVDgI6VU@infradead.org>
 <ac79ec76-200e-44bd-80fc-08ca38c565d0@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ac79ec76-200e-44bd-80fc-08ca38c565d0@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/24 15:46, Mark Harmstone wrote:
> On 12/8/24 12:26, Christoph Hellwig wrote:
>> What is the point if this doesn't actually do anything but returning
>> -EIOCBQUEUED?
> 
> It returns EIOCBQUEUED to say that io_uring has queued the request, and
> adds the task to io_uring's thread pool for it to be completed.

No, it doesn't. With your patch it'll be executed by the
task submitting the request and seemingly get blocked,
which is not how an async interface can work.

I'll comment on the main patch.


>> Note that that the internals of the btrfs encoded read is built
>> around kiocbs anyway, so you might as well turn things upside down,
>> implement a real async io_uring cmd and just wait for it to complete
>> to implement the existing synchronous ioctl.
> 
> I'd have to look into it, but that sounds like it could be an
> interesting future refactor.
> 
> Mark

-- 
Pavel Begunkov

