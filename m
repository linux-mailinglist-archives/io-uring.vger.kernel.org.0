Return-Path: <io-uring+bounces-4390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A7F69BAA11
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 02:08:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBFEB1C20AC9
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 01:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93FBC64A8F;
	Mon,  4 Nov 2024 01:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LZ8moKd2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A062161FD8;
	Mon,  4 Nov 2024 01:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730682483; cv=none; b=Z4jha/YtKWQ6FU0Up2wDRUo5kO6uOJu9YCerhAaX6YDq313eiifblP4s6t+ltHGrebykC0QDFfrthGXZUCWQ2G7b2/SqjOG2iSzkg0cFjzbRjB2Yl3n+w1D+6dL16vytuhYaJBWeQpFwlI2olJEP1LMmuC+xS+92GlPD0EzmMmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730682483; c=relaxed/simple;
	bh=s2yGMAkH/4YtbPPz4G6fiXcbcU0OquZs4d2LcQGE3k4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M9CUkVf2GeAFV4LKqqOCxXCGCHAdThuyI6T0thh34LMQNEA/mvs8ZapwumSXjz2lqNZ5wFEU6AqN00R3AJRxGl4qpwLZyBsm2B6mGFhMeQryX43JRi3X6TDIGvXzlOA2UKOTzH+2BMmI37EJyvNPcT+ParmBLB6AIX7oVbqfhXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LZ8moKd2; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-431688d5127so28426975e9.0;
        Sun, 03 Nov 2024 17:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730682480; x=1731287280; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=elUM2cPNXhblAteuQ5GGbCd8S7We8l81+E3gqzNbeUg=;
        b=LZ8moKd2mSBABmnMxYVI/33MGU0bB8Qpj2pixTqN0ngEIZ5DTkxpa8nUx8h8eP1xdF
         SQdLQHCKJz2FWuvNIBUmUnIKpLi7o1lsbfR0t10/QKwAzRO2g0Dzs2AKqhaUreGblElG
         JN0EYOmbcr7iZ0JvZASgxI0k5qoMnc5ha/whu3cAJ3G5xrk/mk341AGbqgq5iY0UmeMV
         0Sxut7DpjPkSWUiBhc4Gp0ZNQFfHI3D75marJNgYU4/tISVVnKh73Wu5Ijicv5UUqkxP
         ry1Qs8UhlWh278AI+U8lHUtK04RJKAqrDPSwnydOISNDH5/Djw0UGWmVWikXA97YZYSb
         NgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730682480; x=1731287280;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=elUM2cPNXhblAteuQ5GGbCd8S7We8l81+E3gqzNbeUg=;
        b=PgYtNmYYthbjCz0Rk6FIpJ8eLfUCfQaBkGOfRuw1gy5B86lQ/kp6Q2dBT4KLqGPDwc
         XhMitME3soEnf+6OGQyi2uGlueyWVVJ+QRtIJF8MQndIbyI4uFmPOtPRaYn1t8HHSbLt
         2Z66svPUhd51xGOCPWFxn2C5W37VndjHpYiljlduAsClAZ1KV1cVpvW81OcSaSYt9am/
         ApbjR0tODHv3JACFK5a68liKUJ99q4LmkIEHjEpgw5SAy4+xd1jr4yAUXKg1qKez8vS8
         83xCFNVoG22liC6EJEAPDknc4z8/FHZ1q/SmwJdDUwR7zjBJx39C0W27Gfqv9GjneHoS
         9rAw==
X-Forwarded-Encrypted: i=1; AJvYcCWxWrlJCIlx6u66id9QjDZy8zTzz+4ok0xsWyT851Jwkvif8E6Lgy299g8G5RW3D7izhf61JUXC+g==@vger.kernel.org, AJvYcCX7Bjs2UW+8ae+jX0szHvZPfh3yxYaZ/yvQHMHqWuCW1y37vvq/CY75yyd8IMrMU+pPtyxWj4PIH0Gk7+4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwD5HknZS7SNLIyndZleqjV6hMPJsyU3SwmZmiMToA2fIL8N375
	0iX1jlYLiqNZzOUKsA59q0PSxso75fjO8ObPX0H/3Y8GxZEaviHn
X-Google-Smtp-Source: AGHT+IFvIGbOP+EgUOpXHoLu1xdOrJBoJMELWDng7t0hNOYGNK9YjtjRknrZEh3k66UfoSi/z7iw4g==
X-Received: by 2002:a05:600c:1548:b0:42f:80f4:ab31 with SMTP id 5b1f17b1804b1-4319acadc1emr263253605e9.18.1730682479828;
        Sun, 03 Nov 2024 17:07:59 -0800 (PST)
Received: from [192.168.42.207] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d6848b5sm136711305e9.32.2024.11.03.17.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 17:07:59 -0800 (PST)
Message-ID: <0cd7e62b-3e5d-46f2-926b-5e3c3f65c7dd@gmail.com>
Date: Mon, 4 Nov 2024 01:08:04 +0000
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
 <4802ef4c-84ca-4588-aa34-6f1ffa31ac49@gmail.com> <ZygSWB08t1PPyPyv@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZygSWB08t1PPyPyv@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 00:16, Ming Lei wrote:
> On Sun, Nov 03, 2024 at 10:31:25PM +0000, Pavel Begunkov wrote:
>> On 11/1/24 01:04, Ming Lei wrote:
>>> On Thu, Oct 31, 2024 at 01:16:07PM +0000, Pavel Begunkov wrote:
>>>> On 10/30/24 02:04, Ming Lei wrote:
>>>>> On Wed, Oct 30, 2024 at 01:25:33AM +0000, Pavel Begunkov wrote:
>>>>>> On 10/30/24 00:45, Ming Lei wrote:
>>>>>>> On Tue, Oct 29, 2024 at 04:47:59PM +0000, Pavel Begunkov wrote:
>>>>>>>> On 10/25/24 13:22, Ming Lei wrote:
>>>>>>>> ...
>>>>>>>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>>>>>>>> index 4bc0d762627d..5a2025d48804 100644
>>>>>>>>> --- a/io_uring/rw.c
>>>>>>>>> +++ b/io_uring/rw.c
>>>>>>>>> @@ -245,7 +245,8 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
>>>>>>>>>       	if (io_rw_alloc_async(req))
>>>>>>>>>       		return -ENOMEM;
>>>>>>>>> -	if (!do_import || io_do_buffer_select(req))
>>>>>>>>> +	if (!do_import || io_do_buffer_select(req) ||
>>>>>>>>> +	    io_use_leased_grp_kbuf(req))
>>>>>>>>>       		return 0;
>>>>>>>>>       	rw = req->async_data;
>>>>>>>>> @@ -489,6 +490,11 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
>>>>>>>>>       		}
>>>>>>>>>       		req_set_fail(req);
>>>>>>>>>       		req->cqe.res = res;
>>>>>>>>> +		if (io_use_leased_grp_kbuf(req)) {
>>>>>>>>
>>>>>>>> That's what I'm talking about, we're pushing more and
>>>>>>>> into the generic paths (or patching every single hot opcode
>>>>>>>> there is). You said it's fine for ublk the way it was, i.e.
>>>>>>>> without tracking, so let's then pretend it's a ublk specific
>>>>>>>> feature, kill that addition and settle at that if that's the
>>>>>>>> way to go.
>>>>>>>
>>>>>>> As I mentioned before, it isn't ublk specific, zeroing is required
>>>>>>> because the buffer is kernel buffer, that is all. Any other approach
>>>>>>> needs this kind of handling too. The coming fuse zc need it.
>>>>>>>
>>>>>>> And it can't be done in driver side, because driver has no idea how
>>>>>>> to consume the kernel buffer.
>>>>>>>
>>>>>>> Also it is only required in case of short read/recv, and it isn't
>>>>>>> hot path, not mention it is just one check on request flag.
>>>>>>
>>>>>> I agree, it's not hot, it's a failure path, and the recv side
>>>>>> is of medium hotness, but the main concern is that the feature
>>>>>> is too actively leaking into other requests.
>>>>> The point is that if you'd like to support kernel buffer. If yes, this
>>>>> kind of change can't be avoided.
>>>>
>>>> There is no guarantee with the patchset that there will be any IO done
>>>> with that buffer, e.g. place a nop into the group, and even then you
>>>
>>> Yes, here it depends on user. In case of ublk, the application has to be
>>> trusted, and the situation is same with other user-emulated storage, such
>>> as qemu.
>>>
>>>> have offsets and length, so it's not clear what the zeroying is supposed
>>>> to achieve.
>>>
>>> The buffer may bee one page cache page, if it isn't initialized
>>> completely, kernel data may be leaked to userspace via mmap.
>>>
>>>> Either the buffer comes fully "initialised", i.e. free of
>>>> kernel private data, or we need to track what parts of the buffer were
>>>> used.
>>>
>>> That is why the only workable way is to zero the remainder in
>>> consumer of OP, imo.
>>
>> If it can leak kernel data in some way, I'm afraid zeroing of the
>> remainder alone won't be enough to prevent it, e.g. the recv/read
>> len doesn't have to match the buffer size.
> 
> The leased kernel buffer size is fixed, and the recv/read len is known
> in case of short read/recv, the remainder part is known too, so can you
> explain why zeroing remainder alone isn't enough?

"The buffer may bee one page cache page, if it isn't initialized
completely, kernel data may be leaked to userspace via mmap."

I don't know the exact path you meant in this sentence, but let's
take an example:

1. The leaser, e.g. ublk cmd, allocates an uninitialised page and
leases it to io_uring.

2. User space (e.g. ublk user space impl) does some IO to fill
the buffer, but it's buggy or malicious and fills only half of
the buffer:

recv(leased_buffer, offset=0, len = 2K);

So, one half is filled with data, the other half is still not
initialsed.

3. The lease ends, and we copy full 4K back to user space with the
unitialised chunk.

You can correct me on ublk specifics, I assume 3. is not a copy and
the user in 3 is the one using a ublk block device, but the point I'm
making is that if something similar is possible, then just zeroing is not
enough, the user can skip the step filling the buffer. If it can't leak
any private data, then the buffer should've already been initialised by
the time it was lease. Initialised is in the sense that it contains no
kernel private data and no data we shouldn't be able to see like
private memory of an unrelated user process or such.

-- 
Pavel Begunkov

