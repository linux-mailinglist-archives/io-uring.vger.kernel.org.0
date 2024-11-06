Return-Path: <io-uring+bounces-4468-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 525279BDA1B
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 01:14:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF7C2B22445
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 00:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165EE36C;
	Wed,  6 Nov 2024 00:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fhs0oB/E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4566128EF;
	Wed,  6 Nov 2024 00:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730852045; cv=none; b=l85ilTP3+Mu7bBonj1TOZAtM4L2vBbs7c5ZbQqOp0ZZhmNTa1L+YGYUCZK+gD8EeevScXrFDLs5J1qcC2b4D0BCTyssYfiTKFf2A4swA67oUlHlaoKdCglAavUaoDph/FnfKFShqPRCkcYK1ZtjSSTlF0bNlRSiu/XScqq7siuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730852045; c=relaxed/simple;
	bh=CLjeLCitBOIdpXLVgKbgilth4DryvAcz2ykb5YB0kNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uED0iJxQ1sjYm6jeDortVdnjMu/r3UarvsEkmaj7dfssoizrHXUZFXSHUSgCZvIr+Ska/Tjin/17bP2/yvQqCGfFZzaN3uOTXY0A07ZT1Zjc4/BYBjot+yJTQym69kEGh588NHNEGS2hTJ3q2FRF8hR5/dW5MGffZ47FpQXtMAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fhs0oB/E; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539fb49c64aso8536715e87.0;
        Tue, 05 Nov 2024 16:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730852041; x=1731456841; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8jXeg9pReJwGXB164jjgXYBj7jxz6WhOxzHtjfIF4NQ=;
        b=Fhs0oB/EC/d4thZJmE4l1R8NldVNKLQhDHeHoUn8PcreAo799UN+ARcUAcQZNtV3QQ
         U4QWFsEiFiMVK0VMGvCWCA5SmTZCk1IRYIsieXynFvFqNV1KRedE2QM0TPb2gY7LbTIS
         5ohLIU4qVTc0OnGGbm9tMm66KWxSlJ12oAB1OMK/3xzFlQPFqMTl28ShWYZy6O0HKSjC
         CtV4WfWM52n8EcW51Eivw/SmxjkXYL5xUVn+FpnUPWMh6BXkRsauKFLdE2j/CC2AXycd
         h/5XLbhKcDAy2qzrWxE0TBEQ3JcrSdbuE7r73ml8mY5Qp7CpL87bpHcsBDJjpl/6fgzZ
         dmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730852041; x=1731456841;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8jXeg9pReJwGXB164jjgXYBj7jxz6WhOxzHtjfIF4NQ=;
        b=fa2v0RHfUDnreUAZcqxAK9mWXxi3at1qrhiTrbA8JmrlgqP51vqtiY8UE3c2w+EVpl
         +ZVG6u0L5EXhQrtmv6SOTA3QHWsCdRQxs7+ia+pDQl4+WtjrMmMyzLf1N0Qz3CWmxmvJ
         btZrq0uB9qhWEzlsDxrM3K+p5mtq2fmgF6XLhamRVDJ3JRXBlTziXTUJrx/Yi4FKZemE
         3J/RLbZTQQ8rvRxRkQGgjzCjIkhmwUhL7XIlFcEju9+Ek+8c7mGJjuBoLc8A8MJ9WRaE
         vdoSuA+KgLGipmUdjNT1+E98nDXnIaLgQJZfAavIrp7YYpP9mI+wzjbXfY2s3Ao//024
         6pCw==
X-Forwarded-Encrypted: i=1; AJvYcCVS5zcck6wUmn2PPWYhGUXMpL6eJnYAarJxesEYgFnlzBUKRX8wuffHW1ohxkaIBUPLvTOb/Xj4xw==@vger.kernel.org, AJvYcCW497YWtccTowVs5B3+NV98f1nWF3EOj3WuUGFUspYGwaYHoIjW8wzOAt4Ccu2VVX325gA3Kq8h7oAnxCBHIA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwm8TY4XARFyZVRDoyBVIquM9+U/4sC25zvcfjAprfPiiA4yts
	J1/VRZr/Ew7J9bXi01Ahi2xDYMZSm15+5Yrkkcz9shqJsKmeODgE
X-Google-Smtp-Source: AGHT+IFckLgFQlbFeWhMkSJ1WTlN3deXJQi75DLShSxEBJGJi9p3mygB0Q1munQK2N6INmFjGa60yQ==
X-Received: by 2002:a05:6512:6c4:b0:535:6baa:8c5d with SMTP id 2adb3069b0e04-53d65de4d1bmr11310246e87.20.1730852040949;
        Tue, 05 Nov 2024 16:14:00 -0800 (PST)
Received: from [192.168.42.189] ([148.252.145.116])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb16a10cfsm197987166b.9.2024.11.05.16.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 16:14:00 -0800 (PST)
Message-ID: <1ec098a7-8c69-4d9b-8d81-ccb0f4c35904@gmail.com>
Date: Wed, 6 Nov 2024 00:14:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
 <b4e388fe-4986-4ce7-b696-31f2d725cf1c@gmail.com>
 <473a3eb3-5472-4f1c-8709-f30ef3bee310@ddn.com>
 <f8e7a026-da8a-4ce4-9b76-24c7eef4a80a@gmail.com>
 <9db7b714-55f4-4017-9d30-cdb4aeac2886@ddn.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9db7b714-55f4-4017-9d30-cdb4aeac2886@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/24 23:02, Bernd Schubert wrote:
> On 11/5/24 02:08, Pavel Begunkov wrote:
>> On 11/4/24 22:15, Bernd Schubert wrote:
>>> On 11/4/24 01:28, Pavel Begunkov wrote:
>> ...
>>>> In general if you need to change something, either stick your
>>>> name, so that I know it might be a derivative, or reflect it in
>>>> the commit message, e.g.
>>>>
>>>> Signed-off-by: initial author
>>>> [Person 2: changed this and that]
>>>> Signed-off-by: person 2
>>>
>>> Oh sorry, for sure. I totally forgot to update the commit message.
>>>
>>> Somehow the initial version didn't trigger. I need to double check to
>>
>> "Didn't trigger" like in "kernel was still crashing"?
> 
> My initial problem was a crash in iov_iter_get_pages2() on process
> kill. And when I tested your initial patch IO_URING_F_TASK_DEAD didn't
> get set. Jens then asked to test with the version that I have in my
> branch and that worked fine. Although in the mean time I wonder if
> I made test mistake (like just fuse.ko reload instead of reboot with
> new kernel). Just fixed a couple of issues in my branch (basically
> ready for the next version send), will test the initial patch
> again as first thing in the morning.

I see. Please let know if it doesn't work, it's not specific
to fuse, if there is a problem it'd also affects other core
io_uring parts.

>> FWIW, the original version is how it's handled in several places
>> across io_uring, and the difference is a gap for !DEFER_TASKRUN
>> when a task_work is queued somewhere in between when a task is
>> started going through exit() but haven't got PF_EXITING set yet.
>> IOW, should be harder to hit.
>>
> 
> Does that mean that the test for PF_EXITING is racy and we cannot
> entirely rely on it?

No, the PF_EXITING check was fine, even though it'll look
different now for unrelated reasons. What I'm saying is that the
callback can get executed from the desired task, i.e.
req->task == current, but it can happen from a late exit(2)/etc.
path where the task is botched and likely doesn't have ->mm.

-- 
Pavel Begunkov

