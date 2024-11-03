Return-Path: <io-uring+bounces-4375-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA85C9BA887
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3443F28123A
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 22:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67041632C0;
	Sun,  3 Nov 2024 22:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TVdPtdAz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE312154C08;
	Sun,  3 Nov 2024 22:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730673083; cv=none; b=FaTEUNfIkY29fK/ziI4reG7kZdmfyapZ97y4DWAMwY4S34/wOZT8CYsm3uSpNOnxcaJf74zfKwK3CGRdpqPfgFWSmHZtDb0ejC18DuwNjg45pU5GhXvhmOWIbn4zU/BXa0KVtxhA7uD3ifRc2DcO5sha0HgnpZpNL5mJQWaLQTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730673083; c=relaxed/simple;
	bh=hhtn9HCvafeK3eDppZtxCQW/RpzVXm7nW+bUvrH5ceI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TtezmtpBTZP+zn10414TNj9zLB8TqDD3m9BrWuPoSeQesVOI9oGQPEGP4h4ntEh8sGmT4IcitKeICNZr7Uz20SS66yU9xMNb2X6iamaHC1gWAkBjh9cu4SzUXQIIaf6MTR3URQEZxyvE+1QatA08i1EZznRZqZ1V1wvr1ZGFSu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TVdPtdAz; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43159c9f617so27808955e9.2;
        Sun, 03 Nov 2024 14:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730673080; x=1731277880; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XGrK+KTHRBvs0q/y6HvC4FviTAm+itFMEXAEERpVRz0=;
        b=TVdPtdAzPgL9R0FcnCDY+wXNLHTBi8G8eZlPKNHWUlnLTiembI8LqmKzieAJGsTCyh
         NFUV4EYFNN+/QZwGg7LuBKDEo7w/xWdFnDWNQT0MhEzs+KZG/yrARtAUSHWTfPhKWCCu
         LDJIXGQhk5lrPV74Tgn3l7DYjx0tdZTw95MCYGqsxpJPE/UN2BIsNtpjjmQW3WVBX1Pq
         fkusutaxBAUsTipFZmmdA29fZYCSfSEKAo9lEKm4m3fOn8ZcBEV/I5dV0N6o0Yi3v2Y8
         NQixhtdbEIcf4tcbJ/PCmcRozVXiqdSYncsyPOVh/GZFfMP2UZaaT5YEUDjt/u0v5s1i
         KK4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730673080; x=1731277880;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XGrK+KTHRBvs0q/y6HvC4FviTAm+itFMEXAEERpVRz0=;
        b=SiYmNzp4ImgZiPnExGOKdHrWCrBnSnYaCvEB8n0Uv1OqZ48G1PP09ig/1py9Pg550U
         bVukZ2h14gaYe/BNwp08aotcx2EKdXH/grMH40NlGX+894SkAUtZCkBhb6dPA8c1n7k2
         NP3ir3EpQqoCouBpOytmASh+YuAjiZITGBLz2R5N5tVuNYSHaEk35R2cUBigMgC9JhPo
         WXss3sa2esbkFwqdYeiCR/cIrdYsK96o8TDOBdMoGfT0HDk5gaXCdH4Xsfb8gT+y7m72
         HwSckTxR248sE6L8ZwDCpYlfGVRSFhtb68AwLPj6UVvw+AFZMKFpbAkM2FydDvYDoudW
         q6tw==
X-Forwarded-Encrypted: i=1; AJvYcCU3AyycmDxQOPELKcm7/yDCQxiLRbnvXeaK1ftY53ENHXETGM/s5vGgW7MuGIaFrlezmePiiX7q2b7lTQw=@vger.kernel.org, AJvYcCXFnHAYdmSbqbiXm1s9bulsqD+z1vbNO7DmwnLlEz1uZpsvWirPnAgdfq5G5aYbfIzdeMt7H2lV4w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5G1z7oUNlzgiRihU6fHtN0+7X7mHTK3fkA5tJG6vM2kHc/vgr
	VuIc8LsGkQov+L8EULfsNhQQ8js2M+i94FpcyCVBcFBEWppwQ08B
X-Google-Smtp-Source: AGHT+IFIovAu2JOjQRZyT1MDER7onmVD1Wyw++CyRxJTX4tEceAMw2uubDP/1GC4E5HJ/SWENQlxag==
X-Received: by 2002:a05:600c:500a:b0:431:561b:b32a with SMTP id 5b1f17b1804b1-4319acb8ce7mr274677125e9.19.1730673080050;
        Sun, 03 Nov 2024 14:31:20 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10b7d20sm11661095f8f.7.2024.11.03.14.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 14:31:19 -0800 (PST)
Message-ID: <4802ef4c-84ca-4588-aa34-6f1ffa31ac49@gmail.com>
Date: Sun, 3 Nov 2024 22:31:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <20241025122247.3709133-6-ming.lei@redhat.com>
 <4576f723-5694-40b5-a656-abd1c8d05d62@gmail.com> <ZyGBlWUt02xJRQii@fedora>
 <bbf2612e-e029-460f-91cf-e1b00de3e656@gmail.com> <ZyGURQ-LgIY9DOmh@fedora>
 <40107636-651f-47ea-8086-58953351c462@gmail.com> <ZyQpH8ttWAhS9C5G@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZyQpH8ttWAhS9C5G@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/24 01:04, Ming Lei wrote:
> On Thu, Oct 31, 2024 at 01:16:07PM +0000, Pavel Begunkov wrote:
>> On 10/30/24 02:04, Ming Lei wrote:
>>> On Wed, Oct 30, 2024 at 01:25:33AM +0000, Pavel Begunkov wrote:
>>>> On 10/30/24 00:45, Ming Lei wrote:
>>>>> On Tue, Oct 29, 2024 at 04:47:59PM +0000, Pavel Begunkov wrote:
>>>>>> On 10/25/24 13:22, Ming Lei wrote:
>>>>>> ...
>>>>>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>>>>>> index 4bc0d762627d..5a2025d48804 100644
>>>>>>> --- a/io_uring/rw.c
>>>>>>> +++ b/io_uring/rw.c
>>>>>>> @@ -245,7 +245,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
>>>>>>>      	if (io_rw_alloc_async(req))
>>>>>>>      		return -ENOMEM;
>>>>>>> -	if (!do_import || io_do_buffer_select(req))
>>>>>>> +	if (!do_import || io_do_buffer_select(req) ||
>>>>>>> +	    io_use_leased_grp_kbuf(req))
>>>>>>>      		return 0;
>>>>>>>      	rw = req->async_data;
>>>>>>> @@ -489,6 +490,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
>>>>>>>      		}
>>>>>>>      		req_set_fail(req);
>>>>>>>      		req->cqe.res = res;
>>>>>>> +		if (io_use_leased_grp_kbuf(req)) {
>>>>>>
>>>>>> That's what I'm talking about, we're pushing more and
>>>>>> into the generic paths (or patching every single hot opcode
>>>>>> there is). You said it's fine for ublk the way it was, i.e.
>>>>>> without tracking, so let's then pretend it's a ublk specific
>>>>>> feature, kill that addition and settle at that if that's the
>>>>>> way to go.
>>>>>
>>>>> As I mentioned before, it isn't ublk specific, zeroing is required
>>>>> because the buffer is kernel buffer, that is all. Any other approach
>>>>> needs this kind of handling too. The coming fuse zc need it.
>>>>>
>>>>> And it can't be done in driver side, because driver has no idea how
>>>>> to consume the kernel buffer.
>>>>>
>>>>> Also it is only required in case of short read/recv, and it isn't
>>>>> hot path, not mention it is just one check on request flag.
>>>>
>>>> I agree, it's not hot, it's a failure path, and the recv side
>>>> is of medium hotness, but the main concern is that the feature
>>>> is too actively leaking into other requests.
>>> The point is that if you'd like to support kernel buffer. If yes, this
>>> kind of change can't be avoided.
>>
>> There is no guarantee with the patchset that there will be any IO done
>> with that buffer, e.g. place a nop into the group, and even then you
> 
> Yes, here it depends on user. In case of ublk, the application has to be
> trusted, and the situation is same with other user-emulated storage, such
> as qemu.
> 
>> have offsets and length, so it's not clear what the zeroying is supposed
>> to achieve.
> 
> The buffer may bee one page cache page, if it isn't initialized
> completely, kernel data may be leaked to userspace via mmap.
> 
>> Either the buffer comes fully "initialised", i.e. free of
>> kernel private data, or we need to track what parts of the buffer were
>> used.
> 
> That is why the only workable way is to zero the remainder in
> consumer of OP, imo.

If it can leak kernel data in some way, I'm afraid zeroing of the
remainder alone won't be enough to prevent it, e.g. the recv/read
len doesn't have to match the buffer size.

So likely leased buffers should come to io_uring already
initialised, or more specifically it shouldn't contain any data
that the user space (ublk user space) is not supposed to see.
The other way is to track what parts of the buffer were actually
filled.

-- 
Pavel Begunkov

