Return-Path: <io-uring+bounces-8263-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41333AD08DA
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 21:59:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69D601891DFE
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 19:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3E7215073;
	Fri,  6 Jun 2025 19:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IsBEblEU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA63E1534EC;
	Fri,  6 Jun 2025 19:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749239963; cv=none; b=Q6XTxewO9rVUd0N5IId2UkVlkbWzTo2F7bR+asOwDMRKJPoX1lB6M2jnt7JlA9XiyGl0MHT94EeePlWWPhY/NNqmeGyN+6BkPLcyBvvcAglTfVIEyRyQJsWBCCuqnLRwpZ/OA3vg4RnaAndnaLwLYppLtuyeU9i57MHPuAedfiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749239963; c=relaxed/simple;
	bh=cF3i1INmzxHotStY6F4mgjH7GBYziuXpGsn4ZWbItic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JUuvpaBoO8Tc8hWnWzSLtHNYuLQ57ieTK9noqFylp7p4wII3h6Tf7H0J/yorDtjNimM1p3RKNoY714uFAQkg2Edephl76NGZvaf35rDm6hw/DEyGHsvset1fM+S8inWTe17i96Y/4qLgpRbmd3YNIkK5cDtxP16nBKhRjkA/m2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IsBEblEU; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45300c82c1cso120095e9.3;
        Fri, 06 Jun 2025 12:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749239960; x=1749844760; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WgMKogE+w0FLvT0S9tcfLKtpLGtygafazcLhHppciws=;
        b=IsBEblEUCWAoCiY3IpC0cwLWG+XEcBpisCBusAQqKHh+4kapLmNTjBIIDiy/P1v+dX
         dHmH6kG88nBZpKbVmma2jnHsPbcGDk86srkXwyOLHhyeVFN2Vp6cJkUXYlcO7FHdPHXt
         us5z0NQ4XjbnWum52P7oc5V+UBWhUENB7DTh9y+4OjqTOAsZJ/PnPEPvoX63x4a0jcPA
         jz50UPjYsYtSshSrOoXz6ZbEfhy2XJM2a9QCq1cIHeXew5yRmPgRz7IcaI3aONZVZ3rV
         G5x1FWXmr77uoHo5wnPnQR6c1nDs7xPomYIGKfP+DHZec1M40cqesYZtw+nyCwgwEoEX
         FtKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749239960; x=1749844760;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WgMKogE+w0FLvT0S9tcfLKtpLGtygafazcLhHppciws=;
        b=tY9bCSN22ktsfuaoqBCgZTBDuNp34CY+3zgMfKd25UaDo/cAyee133o+Vt7PCFczkE
         qjpsH+KBNj1EZAFlQapdimPasWlgKQOUC67zCUz1uC7NbHVeku2/Z/+9xquxla/AVpxp
         ri2gv37yzP2owFr0vpqClcgg9NLExovEhM6EAnnTBBGgrTUwoq9CXGUe3e15NRbfh3SO
         5VUZb50r2162Sl+b/uBtg1jasE55N9NilNK/5s5LVKCS6mGw1M2vm+o5SAeH7kVPMScK
         rhkEso0r2ATHqENEgiQEyxQoJSgDmuAoKFhtGWFJWoNCC2naqVdzo8lVtZmFLnxRh1vm
         h8qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVViv2RDDWijlsXpN0I18PBirmDLQgQhE3RVW38Zza9saFs8Hhz9aCDaLE918ELtyUmJw1wA46m2Og3A68@vger.kernel.org, AJvYcCVkln25PssYPKoD5Tgvy5rAwnEjoSFgLPDQFSf3qI/igJiRswhhsTOqzzpVUJkCmBTMLrU=@vger.kernel.org, AJvYcCWM8SJiix0bF7BC0CyStjAhvA5/ums8vPYBC82oGmX8avfzVSajdR+R1bC4ltq2ERR56aXtJcV+fzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX2bIXeiQOSWu62mBHJ87fIsopzGAaXeKk56nM+85hRUBHDqH1
	ra7i/0J6/wx8epUzBF4VPhJ/RvAEU5ZBsyfJo5qkDaf0BYvzmCrNg1doMVknoQ==
X-Gm-Gg: ASbGncs9ktemnqqqe0QwKoQYHYi3cIugxk7Huuhlas00t/+urZcNfHx+RRwmrz6KJ8L
	wim3GpgzUv19Tj+28BAIr+ei9h4XTU201w56BS/Wwsi0fbGXa6T3yjU3L1yO1UooSEo1BMf9HYT
	KD650e7Yr0jGYgR3kgdabGIlS4RuizgDKGZJAdjshyCN3JbVqGwxiC4lM389yDAhb5gV9FRjHub
	uHh1Jm75zLdzPYpT4VYuyDqzZA7Z3+0k3Br8lP7l36Gf1UiphtDKnkMt5Gye5p0MV5yGQoT/F6M
	V1B6anms24BSJguU/633OU8WodkMndRTE7nQ+Pdfp22S7T2n312crFr+mBgnRA==
X-Google-Smtp-Source: AGHT+IF8Be/8hvJLKt9Wkfm7L0GTwkTnlcZ/O88biSQ1kMjH+e6QfycT5Y63BkTYLEnP3ilLcjjNFg==
X-Received: by 2002:a05:600c:8b55:b0:43c:f629:66f4 with SMTP id 5b1f17b1804b1-452012b32cdmr51229305e9.0.1749239959673;
        Fri, 06 Jun 2025 12:59:19 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.145.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-452730d175dsm31565675e9.35.2025.06.06.12.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 12:59:18 -0700 (PDT)
Message-ID: <4efddaee-3d1c-4953-a64d-bbe69f837955@gmail.com>
Date: Fri, 6 Jun 2025 21:00:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 3/5] io_uring/bpf: implement struct_ops registration
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1749214572.git.asml.silence@gmail.com>
 <f43e5d4e5e1797312ef3ee7986f4447bddac1d3c.1749214572.git.asml.silence@gmail.com>
 <9b9199f0-347b-42fb-984a-761f0e738837@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9b9199f0-347b-42fb-984a-761f0e738837@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 15:57, Jens Axboe wrote:
...>> @@ -50,20 +52,83 @@ static int bpf_io_init_member(const struct btf_type *t,
>>   			       const struct btf_member *member,
>>   			       void *kdata, const void *udata)
>>   {
>> +	u32 moff = __btf_member_bit_offset(t, member) / 8;
>> +	const struct io_uring_ops *uops = udata;
>> +	struct io_uring_ops *ops = kdata;
>> +
>> +	switch (moff) {
>> +	case offsetof(struct io_uring_ops, ring_fd):
>> +		ops->ring_fd = uops->ring_fd;
>> +		return 1;
>> +	}
>> +	return 0;
> 
> Possible to pass in here whether the ring fd is registered or not? Such
> that it can be used in bpf_io_reg() as well.

That requires registration to be done off the syscall path (e.g. no
workers), which is low risk and I'm pretty sure that's how it's done,
but in either case that's not up to io_uring and should be vetted by
bpf. It's not important to performance, and leaking that to other
syscalls is a bad idea as well, so in the meantime it's just left
unsupported.

>> +static int io_register_bpf_ops(struct io_ring_ctx *ctx, struct io_uring_ops *ops)
>> +{
>> +	if (ctx->bpf_ops)
>> +		return -EBUSY;
>> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>> +		return -EOPNOTSUPP;
>> +
>> +	percpu_ref_get(&ctx->refs);
>> +	ops->ctx = ctx;
>> +	ctx->bpf_ops = ops;
>>   	return 0;
>>   }
> 
> Haven't looked too deeply yet, but what's the dependency with
> DEFER_TASKRUN?
Unregistration needs to be sync'ed with waiters, and that can easily
become a problem. Taking the lock like in this set in not necessarily
the right solution. I plan to wait and see where it goes rather
than shooting myself in the leg right away.

-- 
Pavel Begunkov


