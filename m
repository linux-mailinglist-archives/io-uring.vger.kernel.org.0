Return-Path: <io-uring+bounces-11820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F78DD3B854
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 21:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0432E3005182
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 20:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A112C2346;
	Mon, 19 Jan 2026 20:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QFH7/Ugl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7F823FC54
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 20:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854588; cv=none; b=cnl8n8/p0omFLn9uxeTDM5BBxEYd48bQRxFY2OJXzf4WjRLwhNGPt0BicgW1pEXcBj7FIYr7O3f5N9LfH9pKDqa49fEWVvBFiyjDSfcH5tef/X1VN7jGZfjlzhHF3qHjspRunA0J23b4thvMQUUqskIjR/d+YdpsvY7WJyuy4oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854588; c=relaxed/simple;
	bh=zJ3hukRztLxL5/egMFDcADyI9UyDGfKu7ETuZtJh1sg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vuk0SuwopjSm7CP4im05w3QEsedmmzYgbGHyoajhP/o4kle6EBIEgJeIblzsQKXxKWnQFFrKQoDUHP7Msq8I1YQ8yac2WV0u5PyqQLZzKV9OVn21sE70xKGsmFonT5jE8kc+27sXKzlsa7W6RKcLy9iLJOxO/BftnPbnUL5Zucc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QFH7/Ugl; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7d122733808so783508a34.2
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 12:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768854585; x=1769459385; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JFBoCaOxnE3HOsUkOP7goV2xkOGrGLv8yUckcfA1zJ8=;
        b=QFH7/UglJB4JGNSQ7Jyf1yy99b3nPUc6lcqy0OsaqwZfFlw18ooika7SFBw7e6DfNR
         kajw0MrfLfF4StYYsrWzLqWJEeWFS6427x+GP6mx8MV/SJsoKMIfZOW8R8zG7ULKOgIr
         BoNo540GpIV7iklbC8dnKdYrxJJHv7pgjRNZhks1B7F9JwgaSHZvhz06G/y8qNpWK5Lj
         Ryd5SmqpALjtTAaLT6DFF80zwcM2nE7gcV4BD/p9qlLihMHst5rCYYfbGYtWAtdruLxI
         eRv0FLno4x8Oak2GZPqQCzsayNJldq4otNDCHq8e68kiTtaw7qGOtgrLWRcxsizYw51J
         eOTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768854585; x=1769459385;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JFBoCaOxnE3HOsUkOP7goV2xkOGrGLv8yUckcfA1zJ8=;
        b=s51+XkEW0b156RURg0mAW7dZ0NU7UMoaNjo5Q2EawK1jfKuwNqzMxhO03NVRUGERvE
         FmOp59JqYIDV+Ixy7rK3vjzX6oa1jT39Pxx2Vf1CdMtRgZtESgpMHNkxMuNdjwMsgBi7
         BipIb1bzby2skoQg+mzxfHAiziqvKz5pHxU5wxMp4Cd/Oes+398gAS9KT29FC99mE6B3
         AaMrqgTKQilP5/QMm5MKraajIpnCtmqtFQXBCDgdkxs8bF/Lnf/iZuTGfTwpeA2TeTvn
         WATiFCexnwVJsjojnz1U/p5bZGw5b2HeVDb4e4COX2r1wJo/dPlQvL8kKbPCB2e+WtNM
         EGug==
X-Gm-Message-State: AOJu0YxGOKkr5zoqk++brHC95GdJBC5pJXAD1KeNiod+7jBEQqSG088X
	R8mHuyrErOFEIkSRTsLgfS0tJKf3fVPCNax7KWBS/p8sOyLpHKqfkoSVBjuvrMR1kso=
X-Gm-Gg: AY/fxX6iXVnm7kFWNE7ez2FpglP8xxo1BDga7EN8xV20aZpAOZBjJEPiMGsyAq4sW4P
	ucOffHqGGJkslpzFmJ2q/ZgZoJ0d0C9F+8qHMq9/Un1CGJAmTa1h6C4uRZDaBE+LWYL9K0s/3FM
	uXj19Gu5zjWdZVSusbcuMFJ7A5AFbGH1CYPDMrICIaxBU/gupbEJRSgBVMAfGZb+2zfCg7JpocU
	tSai2XttNLh0PjCUUbCyYZ6/3TPmnJee+EuJDQP5FV4JSBykWkB1K1KyQUCqmuFGKoqNqGaB4VN
	91RJU0cNkJieXJtEvJB7RemKkyUKBEUD0NoZS4ZvNTMsuUUivZOySlRNpy54rFRRJ1k1hHGS+Ka
	FKn5eRuJnDqRau3nHKhMxiZvQtXYXN2yzkkBzCz3wVOSKKwsMELA4NTFhWaDhTz0lb0LkpMv8IB
	5zQE7FyLydsOaQFV6RCrq2wxZeiy7jT/XSwxyEThpwQ4i4lXWvjsqJlB9Ivsa9rKKy6sryDg==
X-Received: by 2002:a05:6830:6f8f:b0:7c7:6cf2:b77 with SMTP id 46e09a7af769-7cfe026e302mr5737688a34.32.1768854585587;
        Mon, 19 Jan 2026 12:29:45 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0e94b2sm7215403a34.7.2026.01.19.12.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 12:29:45 -0800 (PST)
Message-ID: <4d69cb42-5eff-4233-bfb1-1fbd63d85356@kernel.dk>
Date: Mon, 19 Jan 2026 13:29:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] io_uring: allow registration of per-task restrictions
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: io-uring@vger.kernel.org, brauner@kernel.org, Jann Horn
 <jannh@google.com>, Kees Cook <kees@kernel.org>
References: <20260118172328.1067592-1-axboe@kernel.dk>
 <20260118172328.1067592-7-axboe@kernel.dk>
 <2026-01-19-undead-spiral-scalpel-grandson-R0Uhz9@cyphar.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026-01-19-undead-spiral-scalpel-grandson-R0Uhz9@cyphar.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

>> +static int io_register_restrictions_task(void __user *arg, unsigned int nr_args)
>> +{
>> +	struct io_uring_task_restriction __user *ures = arg;
>> +	struct io_uring_task_restriction tres;
>> +	struct io_restriction *res;
>> +	int ret;
> 
> You almost certainly want to copy the seccomp logic of disallowing the
> setting of restrictions unless no_new_privs is set or the process has
> CAP_SYS_ADMIN.

(this is why I missed it, it's 288 lines down of quoted email?)

Good point, yes can do.

> While seccomp is more dangerous in this respect (as it allows you to
> modify the return value of a syscall), being able to alter the execution
> of setuid binaries usually leads to security issues, so it's probably
> best to just copy what seccomp does here.

Agree, that was kind of my goal, just largely mimic that part to avoid
surprises.

>> +	/* Disallow if task already has registered restrictions */
>> +	if (current->io_uring_restrict)
>> +		return -EPERM;
> 
> I guess specifying "stacked" restrictions (a-la seccomp) is intended as
> future work?

You can stack already, you just stack within the current set.

> This is kind of critical for both nesting use-cases and for making this
> usable more widely (I imagine systemd will want to set system-wide
> restrictions which would lock out programs from being able to set their
> own process-wide restrictions -- nested containers are also a fairly
> common use-case these days too).
> 
> (For containers we would probably only really use the cBPF stuff but it
> would be nice for them to both be stackable -- if only for the reason
> that you could set them in any order.)

Agree and this is why you can already do that.

>> +	if (nr_args != 1)
>> +		return -EINVAL;
>> +
>> +	if (copy_from_user(&tres, arg, sizeof(tres)))
>> +		return -EFAULT;
>> +
>> +	if (tres.flags)
>> +		return -EINVAL;
>> +	if (!mem_is_zero(tres.resv, sizeof(tres.resv)))
>> +		return -EINVAL;
> 
> I would suggest using copy_struct_from_user() to make extensions easier,
> but I don't know if that is the kind of thing you feel necessary for
> io_uring APIs.

I don't disagree with that, but the io_uring uapi in this regard has
been extensible in the past with just reserved fields. Hence I'd rather
just stick with that approach, rather than make this case "special".

>> +static int io_register_bpf_filter_task(void __user *arg, unsigned int nr_args)
>> +{
>> +	struct io_restriction *res;
>> +	int ret;
>> +
>> +	if (nr_args != 1)
>> +		return -EINVAL;
> 
> Same comment as above about no_new_privs / CAP_SYS_ADMIN.

Agree, will make that change.

-- 
Jens Axboe

