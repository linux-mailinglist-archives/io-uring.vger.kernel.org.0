Return-Path: <io-uring+bounces-11729-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0E3D24A9B
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 14:06:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9EA23305F533
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 13:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40C2139C65B;
	Thu, 15 Jan 2026 13:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c/DLxB4d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69AB274B2B
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 13:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768482377; cv=none; b=X89KgyChz0JGgmZYLfZNK8WUwl5yTDpTvO4kbMJVZrEL4GzXx/cZOyDC0PvwEAzx9DjJRq2pD+RdmYuZuYCj92Z4QsWbDo3RBMFPZI5VNgURF+83RaYIO0x5n71+7YmrcthyvDIJPaOzO8aeVI0EBUnDAC/N7pmB9310u/DlQrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768482377; c=relaxed/simple;
	bh=GT0N3+XKesFnNC3tQwSGHX0Pg8v09gSm0vnded6Rtmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fFQ1mgcC1Et3Hlya6PJ3nftgaXBwQOHqv64wh9kAIlNNuMbk7ZgRLFtOUBRhaZnXx9aXXrs6tbEbwgY3f7+frPAIMqLMlF+CGAXKk+KOpPA4Tp+1NODtRvlf5nTvO78Kxdu9htcBcLpIqzAiFUaAId1NGZM/VFOqmh0T/DSDlMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c/DLxB4d; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4327555464cso489556f8f.1
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 05:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768482374; x=1769087174; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pFA7aiuD4IC/rmkIBmGbxgTyFB7POjZYLBxN0HNTYw8=;
        b=c/DLxB4dx4GIjxsyehNE4Gj0lvQUvawzUdRjF7q3sOjnP1PqH0DxZLArmZCizO9HOO
         nGozOtSQKBZU83bDlInQjFDXi52CsK048oa1fZ5P4DWKTfnLb2cjFDGEtugbjD8ir/1U
         NgWRHVn5nMFmKucfi822plZzR1pturMcly9GoeQDCOtD8aMyQzKNNxS4RRowXQX72v4W
         tRF/ThEQ4ITME6QUK/JJktf+nvxMR+iOTN77cL0WAk3rNT4C/RY4cpYyJCCeQYsSB5BG
         6juh2WEw2rOJeCXl/DFBKn0u4/wNcvO2xs1fj8SgtJJRwkvR4jVdRwd7wHyr3cgfCqdx
         Xncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768482374; x=1769087174;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pFA7aiuD4IC/rmkIBmGbxgTyFB7POjZYLBxN0HNTYw8=;
        b=D/nwV83XrsPkB/zTEBaJQuygsVdaIBDS6moNfTDmYVawNNveTdZMNBu3/gTOnBGRnO
         E4krE6N/zWScn5B1BQNISSwThX9HZnijwQUzaXReKBJYvYp8ICDwROn1dqpOgUpbzlaz
         ZnV3sS3BzR3HhfsHDpQ5bzysrPcQVNKoIby0JRcsfd3kNcJJHHuHz6iEIzM4Mvc3ELfA
         UNovfsFaAezXUtTESzYBosqmyaFIySN9Lkl2UTX7GCnyoHMcKkSWSilnUH4Mj6LfQflJ
         s3NSBAYcqmWAvx4JAzhJASK2cg0+k9tGJCJWILTLlTpmfculDThCZunbLHJ0qfI3H7ZR
         XlyA==
X-Gm-Message-State: AOJu0YycGRxY17511uNBYEaSenkdkNV/byFVKoii3ZdkW2D4K/meuKww
	QHLL5rqSGohqSBgAAX14zZ3BPiqkujIF2uWa+roi/mzhKSt/i8cDH9r4nvE/BA==
X-Gm-Gg: AY/fxX7IPahgqxNDN/ZBnfTRcPse0Znzoi54ibKvjC0nNuDxYxWoGZvSfT3Ku1dtRWg
	7T2NmbtWu54Pd7s2dqi7/TMB3x/7EuG4ObUk/O0Ff7B8G+Sz0FgZhX37NgMfUMR4iMtXaHYMiJ3
	JgouBf6bkZwGeq4pRuDIsPE0omybAmnHxA2BTk/juwHx793GfajFnzvAhmUQcf/voZPLwde/NIQ
	RkIF/239d/ZgDaiXz69Yx9eSgNsDM2zk0yTt+PPJMaExlcNbMb93fUkImIBJf7rcoiO38/9kRY0
	FE9YtkfC7oy2pj2Yh7X41gbJHIXQsF2dfoJfQfuvsuSiipEP4Yf3ETe+j5sjg0RaV50bD+5v+ch
	UkXtsggnerSyihtVvcWItRthJ+BoZz5uBsFzfL2b2nCr+VhUuWyJgFNdENq39eK4RNZ/K8wi58S
	Zk/RJwIc9o8u/gEMlpovgK1UK03mX5vPzDbIOw7iVdJdtWAOCDzak8tjWDAY/fr71wyCbDpi1PN
	MYTcJS88HUrywDjSsW2IsEexiwigcrcoUsMTizESfY3g7lPemcwGukRFOvrrIuw0g==
X-Received: by 2002:a05:6000:1a8a:b0:42b:2ac7:7942 with SMTP id ffacd0b85a97d-4342c3ed56cmr8652564f8f.5.1768482373672;
        Thu, 15 Jan 2026 05:06:13 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-434af6fc833sm5717862f8f.38.2026.01.15.05.06.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 05:06:13 -0800 (PST)
Message-ID: <53767b80-846d-47ee-a69b-f037a9a2d4da@gmail.com>
Date: Thu, 15 Jan 2026 13:06:08 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
To: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
 <87ldi12o91.fsf@mailhost.krisman.be>
 <d3a4a02e-0bcc-41fd-994e-1b109f99eeaa@kernel.dk>
 <9f032fbc-f461-4243-9561-2ce7407041f1@gmail.com>
 <5f026b78-870f-4cfd-b78b-a805ca48264b@gmail.com>
 <c805f085-2e13-40ee-a615-e002165996c6@gmail.com>
 <adda36d5-0fe0-466c-a339-7bd9ffec1e23@kernel.dk>
 <d8f24928-bcc8-4772-a9b2-d6d5d1bbca72@gmail.com>
 <988a3d72-a58b-45a4-8d98-8928de4f3ecf@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <988a3d72-a58b-45a4-8d98-8928de4f3ecf@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/26 23:53, Jens Axboe wrote:
...
>>>> And the compiler is smart enough to optimise it out since
>>>> it's all on stack.
>>>
>>> Not sure I follow these emails. For the normal case,
>>> io_validate_ext_arg() copies in the args via a normal user copy, which
>>> depending on options and the arch (or even sub-arch, amd more expensive)
>>> is more or less expensive.
>>
>> In the end, after prep that is still just a move instruction, e.g.
>> for x86. And it loads into a register and stores it into ext_arg,
>> just like with registration. User copy needs to prepare page fault
>> handling / etc., which could be costly (e.g. I see stac + lfence
>> in asm), but that's not exactly about avoiding copies.
> 
> Those are implementation details. The user copy is stac/clac, and then
> the loads. This is what makes it more expensive. I don't want to be
> writing about stac/clac in the man page, that's irrelevant to the user.

Confused why would you be thinking about putting that into the
man page. I'm saying that it claims copy avoidance, but there is
no difference in the number of copies. It's also uncomfortable
that it's in a commit with my name attached, while the change
wouldn't fall under the "language edits" note.

-- 
Pavel Begunkov


