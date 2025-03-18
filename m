Return-Path: <io-uring+bounces-7103-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9CFBA66AA1
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 07:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B22E3B2424
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 06:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2FB19F47E;
	Tue, 18 Mar 2025 06:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PEb+T0ZM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392E346426
	for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 06:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742279915; cv=none; b=ruU+28qIr+x2TCgvwjJ8f+BTYbK0sjAMWcjZ7k1st4qmPwKP1GZ6BS6LuX+WEdjvxWR0/uQAlSdTzn74XsXknp0EMp3PwpB7+BYX29y3owG+dvM67KwGV0/RheISCK6s4Ay7Igh/jSzEpnpmicyX1DjWq4YPj77/BGJDdrwsBCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742279915; c=relaxed/simple;
	bh=hasqdvqfoBjdQ2p8EKWtyOLNW1RYaQ6grbm/M5KjMBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=K0j4dSXBB80DSPuQ2CM1C1g8RodSAi9tMN3m7UUtxpM9hcxueDK5Q2O7X9KVQnURO/lpyTyYBdao8yk3Sj+u/OsnrtiEgugsc6/70YJIGdu2FAXBD86YwqRXvubdsgJdEA5wfxEytedQjuIzb1sqGctLozM8CPUlVH8EfcIO1Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PEb+T0ZM; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4393dc02b78so18288655e9.3
        for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 23:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742279911; x=1742884711; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y0JB/622jUc7ROxuFmcYxy/RMyD/NKcsl7EkhpEMgHc=;
        b=PEb+T0ZMETeuvQ85Q0/a3K3NIyrWxPmhyH/3di54pIZwbuSXNMBYDopkWfkc84nzi6
         Osxb+hdJAsHXGPy+8gjMExX7xe+gqKpzyY6Vw/HaUGs9IJPzQ4grtbnXWtzw1+bO/8HD
         LryOck1iq4LoR4l/2aP17wcJMZsb9ARIvBl7c8O7ft5a2BYopVWJqvhkmyb7L6DGTAxo
         90ML6q+/ySvX7ybDFmTeihEsMVeZ0MllDp3YMgnNGd+jIr+V482OPAMvJopS+qasytN9
         nJ1HDUtq9o2Y1DdmuExFqpAd0xGk6NK8UsWvhAWnv26yxWUvXu8yMfDMnBj5t34X0SNB
         uMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742279911; x=1742884711;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y0JB/622jUc7ROxuFmcYxy/RMyD/NKcsl7EkhpEMgHc=;
        b=e1PNLXDAiirxyNcymZLgp7ByDxAYtzvqpnp1Ni0zlVuYBv0tf6/rvMUROIT5Tbvzau
         YtraehgsHXSFQdS1YNqOqmTgkkbjfuc0kTXRQsMNffWvzNwiAbCpdmJhCF4HwEbxFlky
         FdeEpHImrxHLZnFTPYJasXlnlgbL5hHn7//3LiGpr39Hqel61q94gyT8O1xGxOZ2UnvE
         2HWfEM0Ji1qdjQ9PRESLDq+QFfcDe1iO+DjUh9e47QvAoS6ZmO+aOv78+Oc4ZXz3isz7
         iMVA0u1fHYUQPnoROhjVbMGh1UYcWdG7NYUtZZgem560GPJy0z5hnxyZzyzrjMHIcgyt
         k1+A==
X-Forwarded-Encrypted: i=1; AJvYcCVz9gfeGn3fLjOeB094RyeEiKq0To68zRwWrpZ5ocnJB4h8DJ6ttXP9Zd6K7JLID/rwJlR8IhrE+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwEyMrONpSZxVsdI5ryTpgNFnFCVP0AJnVTnDfm2EhF2YI9xkGY
	hgY0OjJGu4Qa41G4zcI7PJfN4reHf1G4bEy+yPCYbX5Py9Hof7+G7Zc2JNOW
X-Gm-Gg: ASbGncsH+oSkeH+4tLlKMan/dQj9pNXk5LbBaaT+5/f1FgCgAIJAcHXj/RsaWUbgf4h
	Ib2jY0RqCF2Ue+s6DDGmWc4a3cYq8Qunh74N7gwCSnQSEtNCvCE7Q1837GEeWHdjLY++rbGsrZn
	GEM6h0BicPVCOp7jkkuLVHCGAtyebO1ftjNFeRM3WYhocDcgi9khwifC8Pw+kifNhIEJ/LtlNo+
	apKot5CUipHZDNhgE2kGlXKnwDXwo3WWJjmsTYXLKwC2oXag42G584Bt1gzwek36+7cm691TxSt
	Ai90dyweZTUaw5+SJmpmpcVjxZ1P5qpgZAmhy8vJCU4Dy8eC1yMoAJo7eBc1aY39jl1+S9JLryS
	eSLKtWAdK
X-Google-Smtp-Source: AGHT+IHEHee7IS1UYO52IQVFRd0wr6lnRzXPPDNKwavgm96HIhjleS/bdWGU9BWuRIAxq6trGaOHYg==
X-Received: by 2002:a05:600c:2d45:b0:43d:2313:7b49 with SMTP id 5b1f17b1804b1-43d3c956e2amr4334305e9.12.1742279911146;
        Mon, 17 Mar 2025 23:38:31 -0700 (PDT)
Received: from [172.17.3.89] (philhot.static.otenet.gr. [79.129.48.248])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d3cd70c26sm5761435e9.2.2025.03.17.23.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 23:38:30 -0700 (PDT)
Message-ID: <42d8e234-21b0-49d9-b048-421f4d4a30b6@gmail.com>
Date: Tue, 18 Mar 2025 06:39:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: enable toggle of iowait usage when waiting
 on CQEs
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <f548f142-d6f3-46d8-9c58-6cf595c968fb@kernel.dk>
 <c8e9602a-a510-4e7a-b4e9-1234e7e17ca9@gmail.com>
 <37fcb9fb-a396-477e-9fe5-ab530c5c26b5@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <37fcb9fb-a396-477e-9fe5-ab530c5c26b5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 14:07, Jens Axboe wrote:
> On 3/16/25 12:57 AM, Pavel Begunkov wrote:
>> On 3/14/25 18:48, Jens Axboe wrote:
>>> By default, io_uring marks a waiting task as being in iowait, if it's
>>> sleeping waiting on events and there are pending requests. This isn't
>>> necessarily always useful, and may be confusing on non-storage setups
>>> where iowait isn't expected. It can also cause extra power usage, by
>>
>> I think this passage hints on controlling iowait stats, and in my opinion
>> we shouldn't conflate stats and optimisations. Global iowait stats
>> is there to stay, but ideally we want to never account io_uring as iowait.
>> That's while there were talks about removing optimisation toggle at all
>> (and do it as internal cpufreq magic, I suppose).
>>
>> How about posing it as an optimisation option only and that iowait stat
>> is a side effect that can change. Explicitly spelling that in the commit
>> message and in a comment on top of the flag in an attempt to avoid the
>> uapi regression trap. We'd also need it in the option's man when it's
>> written. And I'd also add "hint" to the flag name, like
>> IORING_ENTER_HINT_NO_IOWAIT, as we might need to nop it if anything
>> changes on the cpufreq side.
> 
> Having potentially the control of both would be useful, the stat

It's not the right place to control the stat accounting though,
apps don't care about iowait, it's usually monitored by a different
entity / person from outside the app, so responsibilities don't
match. It's fine if you fully control the stack, but just imagine
a bunch of apps using different frameworks with io_uring inside
that make different choices about it. The final iowait reading
would be just a mess. With this patch at least we can say it's
an unfortunate side effect.
If we can separately control the accounting, a sysctl knob would
probably be better, i.e. to be set globally from outside of an
app, but I don't think we care enough to add extra logic / overhead
for handling it.

> accounting and the cpufreq boosting. I do think the current name is
> better, though, the hint doesn't really add anything. I think we'd want

"Hint" tells the user that it's legit for the kernel to ignore
it, including the iowait stat differences the user may see. And
we may actually need to drop the flag if task->iowait knob will
get hidden from io_uring in the future. The main benefit here
is for it to be in the name, because there are always those who
don't read comments.


> to have it be clear on one controlling accounting only. Maybe adding
> both flagts now would be the better choice, except you'd get -EINVAL if
> you set IORING_ENTER_IOWAIT_BOOST. And then you'd need two FEAT flags,
> which is pretty damn wasteful.
> 
> Hmm...
> 

-- 
Pavel Begunkov


