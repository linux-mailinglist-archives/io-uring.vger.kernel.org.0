Return-Path: <io-uring+bounces-11702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F3CD1F79C
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1DD0F3024256
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 14:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47482D94BB;
	Wed, 14 Jan 2026 14:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jg5xEf4N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072732F0C74
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 14:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768401011; cv=none; b=IcUi1ULjZCTASQQJj3+KarUxwHSwf49xM9ID64FVxngrYmesON+Pm55F/j4xez9IJ3+vZF0GgcMHGO3trV6/B1DGegciw9+Z0Jb6mOfvUBko8OEEQg8pEztDSu5ZFuCP3Zj4IAr5XS6y/5ulkIcP9LNpnB/5RFN29Kx8p/WHbmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768401011; c=relaxed/simple;
	bh=SU+kkirETNs8jAWpAjYuKFekuva5uhCumvyDupeuCVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EvMafp35s4AQf5rqMANqHU5T9UyN8tJEfQiozFoGOiDU7bAAh5iJM0t+uW2scSUiOdZa6ICbKinNJQJYEnB9XY8gG/MfR74wiRBF3RtDbsJc2oeKNu3QPGo9ECZhjp7xU0DZJgsFWkR3xtmZqe7fgHIbQd+kYmewYtkVy+Qwpng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jg5xEf4N; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42fb5810d39so4637486f8f.2
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 06:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768401008; x=1769005808; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bz5imuHpTuoEPiLMVSt5jMTW2HEowZkirz4/Wen75rM=;
        b=jg5xEf4N/gzE0Eu8x3tDU72VlqIV3WSzndNdJfL5gMGSwTb2oLeasCckabBDWjZ9M3
         Ni4BFdxRKFkRtGS9EtRMtKYPNEFAYGX8IuJzyqZRSR7xy7KRZTBeur5/fTFxzg7DTiQ0
         bRgds3C8LJ6+0tee9sGQ9hGNUMJvrhFJw/aizYSx986GqxKVDN6DSiNeGXjK4hAit0w7
         +ie+0ljgl4/DeemfpAhE7TvQJ7dhUjvWOVG0v129ioxnahorEf5fd2uoEshInmZeWXkq
         FgS+H8Mw7faRhlyLK4X7LNlewXhbTQHvZh0SNVWLDXBMEJvzgCa9kwHYc32x7OqzknmO
         dhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768401008; x=1769005808;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bz5imuHpTuoEPiLMVSt5jMTW2HEowZkirz4/Wen75rM=;
        b=pnIZrmitO8qQQOGnC5mwXiKNclpJEUCuhGP3RmJYjZJAofFap/k/6v0SgZEx573wLw
         HftGxFG8vZ4dm+orNJ39HdcHvtrtquU5+bRTYJwUaTlRCbB5KgK5ZXgYgQbcNBPaHSaM
         9EjboWAgQb2sJFLGoU57pdS6p9kKWz+5aHPd3s4xvn5DumMmtRcI65dz028FPsqBs/a/
         Hptb5kz6EUtf7zoznZyXHjHescH1FKIwlKfdREMV2WJI+czkPbt97Mv9VjLxk4U/w+4V
         MKWhSTNMYgOvk74dEShaiB72f+p6cdMtUNJfEGrcItISoeL3a5Wfs8ApvnzgczM1hPm8
         5z0g==
X-Gm-Message-State: AOJu0YxCdCfq+2pE6FNg9WNw2zrJe8w8gKjRUTBMiTAkPmPexT0yAJq4
	DhUWIcNDQpNjqXqL3dvQJfA/2BR67OwbLHDnfrFAlVNXFoH3F18N0Ec89/T1sA==
X-Gm-Gg: AY/fxX4NbuFrO4ObO48ASsAaNCtZJqdCZZM65OALmU7g9HbItYPoCj+3XRoHWC4kzgg
	ItusbOCvJEn/US8TdnqpzAVu+nHfh6cX8MBnVv79DslFNfP1dGqmd9tH8vLBta6pB+5VmeOyw8k
	T9nl2Is5ZC7+6ekTZo+RNau23nt/pXBD4ThBWrI6e++g8M3dupHIuB55zce+bXiul1/spWOWSHT
	3jDCu3uKTEBibNcPzCvcZXbTkidZgVT+u+hOmU6MRe/2ESVHf7o+CVwQBIaDYRkcK49gozxtUWx
	68+EiTQlsWuRVTY2fuDbsj7XJbzlC9Oy5vDalX9vSzRNXOMfih3C7AgDU+HW6UlR+64yP4JpKG2
	XOzXhrtiUd+PFbl1l05j+qSiBpZL94eLak6op8pU7/nI7Oa9nfJK2FFKUcBl1WTiVqjb5lCvYSU
	flLG8N5m3i5H5eMVbwSTStSNgU5EuJrPj8szSFo/jmV5+cdPRvvpDvRCfbgIF34mlq6VN/uwJ3q
	DoZXKfqwLYJD9nhcs0TwO1Lie3J64FbJKawr1Hm5jMiWus=
X-Received: by 2002:a05:6000:178e:b0:432:84f9:8bed with SMTP id ffacd0b85a97d-4342c503a8emr3462032f8f.28.1768401008139;
        Wed, 14 Jan 2026 06:30:08 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:b3cc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5dfa07sm50461305f8f.25.2026.01.14.06.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 06:30:07 -0800 (PST)
Message-ID: <726eb675-c3c9-4a81-abd6-e5bd44e383fe@gmail.com>
Date: Wed, 14 Jan 2026 14:30:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
 <87ldi12o91.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87ldi12o91.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/13/26 21:31, Gabriel Krisman Bertazi wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
>> Describe the region API. As it was created for a bunch of ideas in mind,
>> it doesn't go into details about wait argument passing, which I assume
>> will be a separate page the region description can refer to.
>>
> 
> Hey, Pavel.

Hey Gabriel,

thanks for taking a look

...
>> +.BR io_uring_register_region (3)
>> +function registers a memory region to io_uring. The memory region can after be
>> +used, for example, to pass waiting parameters to the
>> +.BR io_uring_enter (2)
>> +system call in an efficient manner. The
>> +.IR ring
> 
> .I ring

I copied most of the macro choices from another liburing man
page, I can't say if diverging them worth it and/or what is
more commonly used. But in either case, I don't have any
opinion on that.

...
>> +.I region_uptr
>> +field must contain a pointer to an appropriately filled
>> +.B struct io_uring_region_desc.
> 
> .IR struct io_uring_region_desc .
> 
>> +.PP
>> +The
>> +.I flags
>> +field must contain a bitmask of the following values:
>> +.TP
>> +.B IORING_MEM_REGION_REG_WAIT_ARG
>> +allows to use the region topass waiting parameters to the
> 
> "to pass"

Oops, slipped through, thanks!

>> +.BR io_uring_enter (2)
>> +system call. If set, the registration is only allowed while the ring
>> +is in a disabled mode.
> 
> While the ring is disabled.

I was thinking that "disabled state" is clearer, but I guess doesn't
really matter, especially since R_DISABLED is mentioned.


>> +.I user_addr
>> +field must contain a pointer to the memory the user wants to register. It's
>> +only valid if
>> +.B IORING_MEM_REGION_TYPE_USER
>> +is set, and should be zero otherwise.
> 
> must be set to zero otherwise.

Agreed, "must" is more appropriate here.

...
>> +The
>> +.I flags
>> +field must contain a bitmask of the following values:
>> +.TP
>> +.B IORING_MEM_REGION_TYPE_USER
>> +tells the kernel to use memory specified by the
>> +.I user_addr
>> +field. If not set, the kernel will allocate memory for the region, which can
>> +then be mapped into the user space.
>> +
>> +.PP
>> +On a successful registration of a region with kernel provided memory, the
> 
> "On success, the"

The "kernel provided memory" part is important here, which is why the
sentence is expanded.

-- 
Pavel Begunkov


