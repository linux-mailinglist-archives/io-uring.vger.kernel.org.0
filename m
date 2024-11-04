Return-Path: <io-uring+bounces-4430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A05B9BBA84
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:43:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5EE61F21ABD
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22DC71C2DA4;
	Mon,  4 Nov 2024 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UCPv7J5+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689C22BB04
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730738621; cv=none; b=PIyLXcZ1MIdEgnOzFIiNgrZJghpaoHaEuswu6TWci4riFe8NQCprJtFPChX0OuU61s8lE2hzN0oMOTAtjZVx4Cf3vT7bJpX9b+X+jQpeAh2m79Eh82Ydudmnm9BU5rftQJp52BZOofZQ4Zpva2XzqNnLzWiVtUfE0fARa84uE0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730738621; c=relaxed/simple;
	bh=2Oiz/V4SPZZ7xlHfsjquRg7nz+trK41EvlwI2GunTCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EXcUxisO8CS2LPo16tnthTcyfuA/N1rE/Z60zzehZrBzb5pOiaRCsdiYohtVHTgOlSrp76uHeDtvD+H5iqNihU3bYk4Zllb/Q0aIi2F8FRFvuYu5ne7Dpq7XPZt90hsMBLZUABR2EkfaVjrNF5y5aJhy8ixNzWQaozmTde/iRo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UCPv7J5+; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso728916166b.1
        for <io-uring@vger.kernel.org>; Mon, 04 Nov 2024 08:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730738618; x=1731343418; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aZ0d819uPQEY1l3kSk7ihyaPd/+TT6aOWxlPjglC35Q=;
        b=UCPv7J5+7Wa3DeaAsGYP5A4iRh49X1/CLoLOcV5MWZU6TWnsy+RYM4J+bo+0wIUe2V
         0Y1o5AW0IFqTStgCFYeHTumAj3aMEih+xHWwB7E3GRrrzkzl4Zf9vXQ0OgqM0Bj8cMbh
         rubumgt0r1BHdPeEJgrAfaBMhZ42XS5e6YbtyktqHUbL5FXSjHs7Dek9/YvD9/DlGmPt
         V/lCrrC98Iiu9yE9fMgR7l+nU2pFlKllg4kQZrNwomqpbt8StyxiQXeVWIRlhXFRp97t
         qPuuozaEwhpCSGn+L4Jkvto/cg1zhy33th/Zp7vTdn/Gzkkf5D2ji70hSJkDexSzD/Ub
         c9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730738618; x=1731343418;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aZ0d819uPQEY1l3kSk7ihyaPd/+TT6aOWxlPjglC35Q=;
        b=D+2rv8uD5611qMwz4Pcc2CVEnHpCZvUNRJkdJP4EGo106lpraUx35Y90Y5yV3bHyB9
         eOCunIwKS1jfbmtEQean/lO51Xm7To0MCT7UmxJ0I2ZNOntiBBqacuwDLr6c8HrcjIVx
         Tld6nbruDhR91FcTsR8oUwNRKW8Mek6/2iuiVyLihhV7g0M11wqQwdYbO8vfpfXxOZj9
         4h4Vd3gAaKmF3bjyw2rK5GplsOXxwhdmEXSAARd+gBoxgKGNXtB3BgLpZaQKgdXwOETW
         ounPzwtrsXkrvt0euD7vw2XfVizyV4FN1SOKOZwiK8cpD4Pdp79mNYnQkReqJPR+aY4C
         +Yag==
X-Forwarded-Encrypted: i=1; AJvYcCVQqfFvR9Haijt4px6RZ6F6xTJribESswcGpt9FxqoEE6IROefA/I2Nr+ij00htQn7OFrTVjrC+hw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMkIlV3NvxFFmk1rxBUUQdpNpRoL8VnZTEVUilUUvhGkFv8Lgn
	MPye3nS07Ua/AjW2sCoyEraRCHhHLhWRXKjoCtX9bIqJFRg37B4bMREbNw==
X-Google-Smtp-Source: AGHT+IF0p3UAGdAQCFeQTllFinzbT2U3nqdHwulXfMnsx59MExlSppxZvvbRqEat89WpMlrQbwPTqA==
X-Received: by 2002:a17:907:7f06:b0:a99:5d03:4687 with SMTP id a640c23a62f3a-a9de5ed3e39mr3079308666b.21.1730738617478;
        Mon, 04 Nov 2024 08:43:37 -0800 (PST)
Received: from [192.168.42.71] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb17f89f5sm3051866b.145.2024.11.04.08.43.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 08:43:37 -0800 (PST)
Message-ID: <15accb24-3edf-40de-bbec-94f8d146d01d@gmail.com>
Date: Mon, 4 Nov 2024 16:43:43 +0000
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
 <573a63c4-0cb7-4ecf-a4b1-b1b0e208020e@gmail.com>
 <8e84b4ee-e94f-4b78-bb94-89ea2ad00996@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8e84b4ee-e94f-4b78-bb94-89ea2ad00996@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 16:16, Jens Axboe wrote:
> On 11/4/24 8:41 AM, Pavel Begunkov wrote:
>> On 11/3/24 17:49, Jens Axboe wrote:
>>> Rather than store the task_struct itself in struct io_kiocb, store
>>> the io_uring specific task_struct. The life times are the same in terms
>>> of io_uring, and this avoids doing some dereferences through the
>>> task_struct. For the hot path of putting local task references, we can
>>
>> Makes me wonder, is __io_submit_flush_completions() the only hot
>> place it tries to improve? It doesn't have to look into the task
>> there but on the other hand we need to do it that init.
>> If that's costly, for DEFER_TASKRUN we can get rid of per task
>> counting, the task is pinned together with the ctx, and the task
>> exit path can count the number of requests allocated.
>>
>> if (!(ctx->flags & DEFER_TASKRUN))
>>      io_task_get_ref();
>>
>> if (!(ctx->flags & DEFER_TASKRUN))
>>      io_task_put_ref();
>>
>> But can be further improved
> 
> Avoid task refs would surely be useful. For SINGLE_ISSUER, no?

Perhaps, but it doesn't imply single waiter / completer task.
IOPOLL would need to be checked and possibly there might be
races with io-wq. In general, all optimisations just got
shifted into DEFER_TASKRUN and SINGLE_ISSUER is not that useful
apart from carrying the semantics.

-- 
Pavel Begunkov

