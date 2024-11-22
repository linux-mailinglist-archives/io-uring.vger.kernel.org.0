Return-Path: <io-uring+bounces-4982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ED8D9D62AF
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 18:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20165B20F8F
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9DB1DE2BD;
	Fri, 22 Nov 2024 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gu3doCMg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E79E1632E0
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 17:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294837; cv=none; b=h4XvxqjT6aG10+H2PqQWB5P4votWm6BaeECgbdpHR7uNE3pLAnc8gmOya4Mh3TqjJYHh+7WplSAJgGkL4pL42o9mnxpaSn09m2W4X0Hm9/oFUM+q5cLqWYqGNeUNvhtPMpQfheHvLo0VZ7FGVtn7rYnPUJDEAB82tDLoiBHMB/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294837; c=relaxed/simple;
	bh=wXZQ2OfUyAeZwYfE5GVWQloodWA+tAL1YGdRSb071bA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UNvjgyfT5kyPbaVr9Fooha3D6cv31jlufpsL5UBpUhP+Nu9cLshZZmFpMsOwdcJSFg5NjvJpzngcwRC5xi3fd4Zf4CLVbQQpdcXQ+4EITn2MK5UrTiXQQ+T9mDuctwXmw5ZyZkV9P4nFEWHVr2l5sW4HJTyMnNtffV9O1ASL+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gu3doCMg; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53d9ff92edaso2760527e87.1
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 09:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732294833; x=1732899633; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PwsUrgiaNwqbA5hkdgr7EclDnByd+6Ag4fdolzFXIEU=;
        b=gu3doCMgSHiF599AukbMJCwmKPQoyiPGkvuC32WR9sFk1E6DiFguIVUqC3TVeZ3Iwo
         GPpIHkgNkAeTNC6Z8Nvh+nENCTTYZrBtp++CPd6S3+N7OYgGQ/dlYmw2q+3hQcY+eTFO
         6+bjXguBYxeWDk75dGfTK0PQjjZ5FET5sKgpsgvQ+xlApaTbomczqRG2M5NNn1+ZH9A6
         7TjVHmO5uh6m5Za/4/8njBPn6TVkkuDVOB1KBhRmomQxIpYGRb6YZvElY/0e4UsP7EDv
         OcF/qQaLXAdKeRqIR6pOejT3pquzWM7fMvGZXCgxDc6e2SwTZufRfofQDqF3T7w8VlsO
         qfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732294833; x=1732899633;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PwsUrgiaNwqbA5hkdgr7EclDnByd+6Ag4fdolzFXIEU=;
        b=eeRZuZKQGDz2iZ6yBo6yvRu1vqcJjeVdfd4x8jbrtReAfftSbuVXTu0E3RpS8/JOBI
         8YDnzT/be2p7V6Wx1GlRvf59Ptnzj7AepBNN7peNt6SKX8lAPVRuNTEXTbMUES/H+l1L
         Ak6hCTvFXWDeaOOw58jiEqEzbb9+5UUJplhWgIPYYfoO6z294Mzl9OY1FEJJyQqckoH4
         eK32soBFbZwUYb8iTN/hHRR7OBxj6blLu/LXIuucrPMxy/HyDwghWfC15YN9nXPeBT27
         nasu0dC+YlfxSxAnbNmM5MMSwBDSoeU5MikRKtiaacLdbT7hmTRZUPhUqjqYhEYLL+wo
         ONbg==
X-Forwarded-Encrypted: i=1; AJvYcCUCuHT2mwqxvgYVYEzxokAJaVI2DOW9oqeIZJ0UnlB4pZXZho29ezf1ugmboaoMlp3EdO+YF2kTtg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc9LAMLIVp+riKBFoerdJoEhXJPq/O635/an8mBN5s+DWG9kv2
	fmjmNGJuoRHDnZfus7oddn0FSKMgHGSOhwFRdEr5yLyGkBTZaO0K
X-Gm-Gg: ASbGncvjm0VM4MTAD1gruBwqhokpeq0zKMjMMNCLiJHNRidwYw0VLGCPmTPqT3/I1JB
	bL8Y+DXh1Nk7Vw9FWUqY0+s15hIQd44VSATadj7BmQQxGYvRzkZ9UXX0RTqzSj73eOpSq78HbeQ
	KNESZplBwzxKAM0u7haKI1/ag0yR2sETU56qav9lPcZrwIL6E4nqes+azF28XyBTnj1pvP9H3Ga
	+inuWxTk7pqVc08PyrVzbdov7RT06vXUCgQD9j7dvIfYNj5k+PnSyK8XFU=
X-Google-Smtp-Source: AGHT+IFwaN2i08PPlF/MgJGIH8zPrsIq5jRJ5NREAg3cgejsfic270fk46gFqKeO5jAyR3tAH0tmiw==
X-Received: by 2002:a05:6512:1303:b0:53d:cb7e:225a with SMTP id 2adb3069b0e04-53dd36aa62cmr2486567e87.24.1732294832989;
        Fri, 22 Nov 2024 09:00:32 -0800 (PST)
Received: from [192.168.42.9] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b57bbafsm119269166b.155.2024.11.22.09.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 09:00:32 -0800 (PST)
Message-ID: <c7c5f1e6-e794-4cef-a45e-773e05aa4d71@gmail.com>
Date: Fri, 22 Nov 2024 17:01:26 +0000
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
 <357a3a72-5918-44e1-b84f-54ae093cf419@gmail.com>
 <375a1b30-5e68-439d-be55-444eaa19d7ef@kernel.dk>
 <c2f80710-7253-4dfb-a275-6698f65ab25c@gmail.com>
 <80eeba88-2738-405e-b539-516d67f0dcd2@kernel.dk>
 <e7a2ed0e-fe0a-4a19-86bf-90bd38bc6b61@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e7a2ed0e-fe0a-4a19-86bf-90bd38bc6b61@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 17:05, Jens Axboe wrote:
> On 11/21/24 9:57 AM, Jens Axboe wrote:
>> I did run a basic IRQ storage test as-is, and will compare that with the
>> llist stuff we have now. Just in terms of overhead. It's not quite a
>> networking test, but you do get the IRQ side and some burstiness in
>> terms of completions that way too, at high rates. So should be roughly
>> comparable.
> 
> Perf looks comparable, it's about 60M IOPS. Some fluctuation with IRQ

60M with iopoll? That one normally shouldn't use use task_work

> driven, so won't render an opinion on whether one is faster than the
> other. What is visible though is that adding and running local task_work
> drops from 2.39% to 2.02% using spinlock + io_wq_work_list over llist,

Do you summed it up with io_req_local_work_add()? Just sounds a bit
weird since it's usually run off [soft]irq. I have doubts that part
became faster. Running could be, especially with high QD and
consistency of SSD. Btw, what QD was it? 32?

> and we entirely drop 2.2% of list reversing in the process.

We actually discussed it before but in some different patchset,
perf is not helpful much here, the overhead and cache loading
moves around a lot between functions.

I don't think we have a solid proof here, especially for networking
workloads, which tend to hammer it more from more CPUs. Can we run
some net benchmarks? Even better to do a good prod experiment.

-- 
Pavel Begunkov

