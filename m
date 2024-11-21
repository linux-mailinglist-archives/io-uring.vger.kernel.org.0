Return-Path: <io-uring+bounces-4934-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E555D9D508E
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 17:17:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 899F3B210E5
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21EAD55C29;
	Thu, 21 Nov 2024 16:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJrOxSO+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A60119A
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732205862; cv=none; b=az1C/3haEZa54s/Wml8/Blut82Fn3gkgrjcey96D3CujMTcSt/AhvjSu1R100X8f5ztLzCDcyUgoZmmxkw3K4eqcah5bqTsivT+a31tKExNF53XGerliVs4j6B7oK9r+RP6TpKiKV/UJoqA0QQEcNJOjvP8yancLlyl0d61NjFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732205862; c=relaxed/simple;
	bh=MbmCTckO9u7WcNeuwkMAIjrw8P5WWhnYBFbPswg5o8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=d47EZCo2mCA2g8tUNuOwIGE0aErJBY/rb2BridlMsCegOFxVC26Ph5dgWKR1OSSgXXxq8FnpqA8vs3+u/YCCK39OBIZrKI+VmgQnEGJE1yUdy6xn2+orBiKkGZzGPQpBIamvGWhQUHxQUSN/zdD0w2sD5LOjK38x+tIQAWWhqn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJrOxSO+; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5cfabc686c8so1378359a12.0
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 08:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732205859; x=1732810659; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7sPHg6EcpO1jT1ViyRv9KvH38kjphWL1Z7991YBHzXc=;
        b=KJrOxSO+g7Dy0UyDQmWKZhWawE3Phm8Y7KJHi6rLTod1AnHFWcoFwzPlOl7sYfzfN5
         rNEP+pKSbClr5Dr5V6vSiRJL0x4F+15wpNi47QnOGs7luFNZqsWAuTQH133MRBRd2Lga
         uMYc3I/TRUmtRIuOaVJE9RYUkaTfPR/Kz75tA49C/XA9IWCKo/AyhyugKLqXc1xP2CDP
         JnSoY8L/lZEwhkgYudASfVGCsmLzHXW222/kz8qYJ8MMWVSVLdb31oW49yPHxKgN+DU1
         pI3F0WeZnO94hKuUL5DTcWKXZ294zPxGtdKNRBpiLE8L5tNZBanr1OflwYGca0fkEObh
         xBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732205859; x=1732810659;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7sPHg6EcpO1jT1ViyRv9KvH38kjphWL1Z7991YBHzXc=;
        b=B6rtSgHqcQYvEbv7HL/TfRXxqqH0/giJzaGdF1aVZS1uw4fV9aXaDQoQoOD9lVs+2H
         kZUnRi7jIkhff+ioFh29XMRFDs7CQsOXrnaW7Ma3o5pkRYs1UxVcr9YFLCJa6+bzWbRq
         uFUnuXgXK1w/5Kzna0iCt9Q9UHAejotjupbLWMagQiGoAVY5sMWcDap/tOwmWtFj+BzM
         8ZicywReM2DKqnKI9qj6O3sC4/U9yJ7Tk6CoSSWQOztc5dCBDPbvTQGo2M8kgSONhqnQ
         IwqoXBDjYDEm0//sWkB//BLvqoHmfWY9yfxO1lYjbgqf5pz+oTc3IivJe9tL1ZciGnRV
         jnfw==
X-Forwarded-Encrypted: i=1; AJvYcCV22eSisMJIgJ7t/zdCGqG8WE/uaDIeaVZpl/wIVZt+YbZTSfMdEGWbVc9IHvcvdUT/Mi5be+LS+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKEaKwg4zWt2jezgQ+xPrA4RRFZaAEswLBM9Zwbo6P4xPnAzCz
	zOo4gA3tAaKn4fMqQBTdVB0SPoEnR6MVTGY28WjZ4voSlKBdR0II
X-Gm-Gg: ASbGncsqS2KCp7ZjxUVQY5lF22GXYiNaklx3CKXawAOH9KxQMEg+QLB3wCNbkLOcXGV
	toKRCUgKcNzWmMLf6ngYqyOeLyZnSe/SVOErcwEXZvsSp/aGWlGfks9k+PxsatxZFlGfIG0DDu9
	hsnp9sNTUXJOCHQFhwWil1Cx2SKckJgcUfag4cYMrK0T8m0hFgXKGr2p3yFG6BXVEKAnyJ3x3Wz
	8b432+X+KMOKhoSdAka59AA9uyjmfJoYhPaCxPPmYZKwYSfhLbJpudCS1s7SA==
X-Google-Smtp-Source: AGHT+IHXjgD6Wk1MnZtaQFbg1wiMTxfqFdo6XhsiwtSTq/ScorNNViYYi0GcDNoRFdWbnFFnLHwBfQ==
X-Received: by 2002:a17:907:9452:b0:a9a:67a9:dc45 with SMTP id a640c23a62f3a-aa4dd50a559mr772475866b.3.1732205858604;
        Thu, 21 Nov 2024 08:17:38 -0800 (PST)
Received: from [192.168.42.237] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f419d412sm97357666b.84.2024.11.21.08.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 08:17:38 -0800 (PST)
Message-ID: <357a3a72-5918-44e1-b84f-54ae093cf419@gmail.com>
Date: Thu, 21 Nov 2024 16:18:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
 <9859667c-0fbf-4aa5-9779-dae91a9c128b@kernel.dk>
 <3e6a574c-27ae-47f4-a3e3-2be2c385f89b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3e6a574c-27ae-47f4-a3e3-2be2c385f89b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 15:22, Jens Axboe wrote:
> On 11/21/24 8:15 AM, Jens Axboe wrote:
>> I'd rather entertain NOT using llists for this in the first place, as it
>> gets rid of the reversing which is the main cost here. That won't change
>> the need for a retry list necessarily, as I think we'd be better off
>> with a lockless retry list still. But at least it'd get rid of the
>> reversing. Let me see if I can dig out that patch... Totally orthogonal
>> to this topic, obviously.
> 
> It's here:
> 
> https://lore.kernel.org/io-uring/20240326184615.458820-3-axboe@kernel.dk/
> 
> I did improve it further but never posted it again, fwiw.

io_req_local_work_add() needs a smp_mb() after unlock, see comments,
release/unlock doesn't do it.

-- 
Pavel Begunkov

