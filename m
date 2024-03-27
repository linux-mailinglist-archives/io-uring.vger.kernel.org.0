Return-Path: <io-uring+bounces-1252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C543C88ECB9
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 18:35:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 811C329D3D1
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 17:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BA6137772;
	Wed, 27 Mar 2024 17:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S8ZLgAyM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E8D14C5AA
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 17:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560897; cv=none; b=LHP6asI996n5nuNjDrKI3PGrFMu5ZW/KP+Zpz7pVI9HuZH0D97CFN6elvJtr99Sb+Nfml9OfJYOpKcXzDaHY2CVyepQwFUcHpCPQAIZqb47BiqPpGv7mNyvriBNBqdAIC+JfSPIU6pOl8Gx7qeL3MN8dX+MJVHnVYJdZ9w+CEQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560897; c=relaxed/simple;
	bh=Mi4Qyo0CmTIxbcIb5tASsHujGumRqwyqIU/cB+pds8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IyMTKNLY4FZQ2pHFap9pO5Z0ix0qEtpLynI3PckJQe2BLZ5wIe61DhH07h6GT/bm6OkP6ir1ZxxPkZ/F90L3ryDxUJLIqdYywZamY9QjVXpG43niex4Yxk6MxUl4OHuriWWeYBByyjTWkiKhM+n0d/7jqkMLbPscSscCsgSwZTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S8ZLgAyM; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dde24ec08cso102845ad.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 10:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711560894; x=1712165694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wk9T4tBUDgIbB9GYm0QE1l7GKckPrlTsPGwF+46eGqA=;
        b=S8ZLgAyMEiCfdczOMI8sjQ1ydjwY0jyVk/5SSMcYzyO9XTDwFraV2UCW29/8Ueg26q
         H8yfM0w0NDlJjG8jKZpVjWnSH94RIvlPOMuJ/1LV7ije5cU25JH2ijYXWdjMJhWFKHAm
         ttO0ik4q+7dzGPpZK0sR5MAx6isIzaiwXT8qRy+oUsn392CAAqEXiYlPUP4xGECjCz3p
         +6u3hK0ACyIOm7dSIAraXjMd2NHb7VRx87TPw2cJh3DezvFboj1jfl7FhRjZBhJ6FvQw
         UmdQ0dRV3XLxkb0Hb8J0+dc1P6SmuCQlXIdFu2M0Pxpi+EdUsTf8logWNQUGCIrTGVQg
         d/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560894; x=1712165694;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wk9T4tBUDgIbB9GYm0QE1l7GKckPrlTsPGwF+46eGqA=;
        b=cW6lAy5pDNK90Ev9PWXqRWAkP8nbODFNcGk9CPaSoNkbZYkrc14ytc4MURM7R5uf89
         A06P8Y/H2FaR4+ZxeYiLjpqnZcTerMZzQv5GMHzHq3UBm7wpZHsVzW+61echScDc62ev
         vHwk1K5DFJGJqsl7FBb1UovvskuIa0qhywXEwfqmHwGpLlct097/NRd7tVR3QmxYeSdI
         UVpQK4dW+l7QNPp+fCZHpIewam6HYkGwp2dl55e1rNa6nyzTpqemrmKZyXcmnh/Cra7h
         2qmuvuWk9BmIWEcL87nrV04sNvROaswqLvI7LxFw4OEuD/WAndRBca7cLGryUM3wKSNf
         q5iw==
X-Forwarded-Encrypted: i=1; AJvYcCW+EqTeMX/Iyl8tpxDZAjsDCy8Na7Z+QXZv/yneupT4d1zwtylu6rBXiHSTysoWeQW+PPflED4JYe5JRafGwJr1KFjVIvm6wzM=
X-Gm-Message-State: AOJu0Yzn5jYawm35BrqZuwIqtXH/frV96cyJmyjpN6M9VR2QWVxZiZAP
	CbodNe1GG1Dn13QaSRtwH/z119N6tBb/chWgs6+xeRs6uNJmGywsPAVCwC40S/YdjB6UN7iK8LR
	y
X-Google-Smtp-Source: AGHT+IEcZD2VTlwISc0jX5ikcCIrzkVSrXMLKTbFsMMO4jiix3W5nLn/EQEA2m4eoJMT4B3+t0zvUg==
X-Received: by 2002:a17:902:ee52:b0:1e0:c887:f938 with SMTP id 18-20020a170902ee5200b001e0c887f938mr359323plo.3.1711560893700;
        Wed, 27 Mar 2024 10:34:53 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id o21-20020a170902779500b001e132fe4cabsm1839174pll.88.2024.03.27.10.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 10:34:53 -0700 (PDT)
Message-ID: <95254b07-e5bc-4e63-9ff8-93848d9f87ba@kernel.dk>
Date: Wed, 27 Mar 2024 11:34:52 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: switch deferred task_work to an
 io_wq_work_list
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240326184615.458820-1-axboe@kernel.dk>
 <20240326184615.458820-3-axboe@kernel.dk>
 <22f87633-9efa-4cd2-ab5d-e6d225b28ad5@gmail.com>
 <7662a22e-caeb-4ffd-a4ee-482ff809e628@kernel.dk>
 <bb1b7259-5112-4c9b-a5f4-b5d9d95cfe68@kernel.dk>
 <24b6c05a-dc61-48ca-a359-66910a113ec5@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <24b6c05a-dc61-48ca-a359-66910a113ec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/24 11:28 AM, Pavel Begunkov wrote:
> On 3/27/24 16:37, Jens Axboe wrote:
>> On 3/27/24 9:45 AM, Jens Axboe wrote:
>>>> smp_mb(), see the comment below, and fwiw "_after_atomic" would not
>>>> work.
>>>
>>> For this one, I think all we need to do is have the wq_list_empty()
>>> check be fully stable. If we read:
>>>
>>> nr_wait = atomic_read(&ctx->cq_wait_nr);
>>>
>>> right before a waiter does:
>>>
>>> atomic_set(&ctx->cq_wait_nr, foo);
>>> set_current_state(TASK_INTERRUPTIBLE);
>>>
>>> then we need to ensure that the "I have work" check in
>>> io_cqring_wait_schedule() sees the work. The spin_unlock() has release
>>> semantics, and the current READ_ONCE() for work check sbould be enough,
>>> no?
>>
>> To answer my own question - no, it's not enough. Let me think about this
>> a bit.
> 
> Right, to my knowledge release does nothing for write; read;
> ordering, and all ops after can leak before the barrier.

Yeah, it needs an smp_mb() before that atomic_read() on the task work
add side.

-- 
Jens Axboe


