Return-Path: <io-uring+bounces-8268-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 162E6AD0956
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 23:07:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7976418917AC
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 21:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA55221F2C;
	Fri,  6 Jun 2025 21:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rjshIgDG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E8B21CA03
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 21:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749244069; cv=none; b=gbV8oXYEdceb5i/3uX6Jgt0VWDEqYPQaT8BmMQtTUMyixU3GZXnxR5un7aB8c8DKI+VB47MeyGHBzNUk3TWsVVQ+OAG+ImGkwyEv85q0l+Y6qcX8yosls98xakJTsluo6pp9DCb+MKTjGBeAvkn5XFAvOQzYayDWgXzzYLKmtX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749244069; c=relaxed/simple;
	bh=oYvImI87ZwK1+8Epiw2C+eaTq7mhyhmpSEcpLdClPlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QpMBZkl6llU5I6j3gESSlVhbv8f1ypJCy9P6KXehbzIIvifZ8CR3RAQbnRSUfTGAR20Xhr44zhuAfXY6u9pwasAkAWv8MpA5nA5WHmnHMfiAh6H2ZclB6gGaIt9yIOmUR98fvKjKmp7O6KLgdPurOfZrAx2tB7obaEAeVrooEpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rjshIgDG; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-86cef0b4d96so67857839f.0
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 14:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749244066; x=1749848866; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cp7UGG+KTG1wD09K844XDRVXwMgGVHgZtytJ6OGTY2s=;
        b=rjshIgDGzFhwHmr6x1XgNKLnUVTIjI+Ud8QKjs4CVlvBED+PdkQEltq7q2T4BTBmj1
         L0B/hwCgCoR3FEdkDr1vn5fvJvF++0R29XxB/anKLVkbDJ9iFOYT0nJdttj9yYXdG/yO
         38MzsldLvANODC81jbBw9wbTSu+9HQT8tuJFtjKah/1EbliWakGVftGoQvtY17EvfZUL
         Lyyt8nbZNPfAkoTM9acnkT7daVkypAIjJwYsr2I1Jkh2Oe8ngHAbsTtB9+n+yNDcPqZn
         pl4dZDBAaHV+fv6jMrko7+SlPri6cjCpvUeF0WSi7DfU0DdsrTsGiYC7SdROgkqWvsxk
         VBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749244066; x=1749848866;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cp7UGG+KTG1wD09K844XDRVXwMgGVHgZtytJ6OGTY2s=;
        b=CN19u40fApfAIwaJIMaIU0xaBnQvaRpQOHwIoefhGWxksK1IGe1vo+WXD42MeGXH8x
         YN57F0ZsG7vaGA8GWDW5rlhch0kBJV6bgLQs9cf2SC6pyVSJe2R8la7JNIpSbLnaPDd0
         ZX78Bj4X4i0oW/5tTAhxBlhJIhSNPIVk1C61Xph8aurI7HW32SJy7HblQdx5n5lHRS6B
         xdZK/dK3vrZtEqVgdqJwRNnPPVZOR9McNRvvoAioQJT5AAd23JE/9q9iHP5ASzhr215I
         G8eT020hedyQabAaLDIemnu+8CBzwNz+1RYXYtcAw8uXvd8x8phAGmeEoZsprIgtciJL
         Oc5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWzLP+k1fvdQqlnE4AGxf2j56EMtJaCVZmlfxxWAZROKpi3UUkUH6Umq3QUBrGCL4JSCC+6JibfHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YybTFCUsBI0jmsqrc2ez4LDFdXSI2dR47Mt3jiHKKl9OCNqHlnj
	qr8ikwE6hjOHlbX25avicBKr3mUxIao95dbwXqvyHq6tiPHa6dGYcSpIMuDbGr+iIyY=
X-Gm-Gg: ASbGnctK4QvzJj7qR0cH0vcdng9XJQbQyzjp+1W9VQ1x61yuno63bTanAwVoXxg0uGm
	iSMi43KaexUxrSl57HiMzyf6H61kwV3rM9b4ZwBafDGUy7WBxQCKmzNTg0ohInqUkQo6u+mo8Cg
	RaevMH6gziBF0AGOce+xAXBArnjALSqUUYZdUZeu/ECu2ePoHuKfVviumMUn1Rs7Ah09BUyHjJd
	RArjkWt8XWeGeieKmBWyUFsGMQ/8n7N2M6h6gttq35BtyaB0QuXYGnPt3yl8kD1Kx9MbibjMDxp
	0DxYPr+/FwFD/EBufrx+qKhgCoJF3NdGXrLj8EE3e03rG2qGbhvh107oQP4=
X-Google-Smtp-Source: AGHT+IE69PpGWrIKfyhUPVdTEvtXRbHnKXqo21mxoAqyj1x89jdHRK1iXq5VkzfQ7maktedb60dqBQ==
X-Received: by 2002:a05:6e02:156c:b0:3dd:cacd:8fd3 with SMTP id e9e14a558f8ab-3ddce4c2e56mr61684385ab.22.1749244066532;
        Fri, 06 Jun 2025 14:07:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf253162sm5782575ab.48.2025.06.06.14.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 14:07:45 -0700 (PDT)
Message-ID: <3f3e1bb3-70cd-4e7c-b217-373f5c18e0db@kernel.dk>
Date: Fri, 6 Jun 2025 15:07:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 3/5] io_uring/bpf: implement struct_ops registration
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1749214572.git.asml.silence@gmail.com>
 <f43e5d4e5e1797312ef3ee7986f4447bddac1d3c.1749214572.git.asml.silence@gmail.com>
 <9b9199f0-347b-42fb-984a-761f0e738837@kernel.dk>
 <4efddaee-3d1c-4953-a64d-bbe69f837955@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4efddaee-3d1c-4953-a64d-bbe69f837955@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 2:00 PM, Pavel Begunkov wrote:
> On 6/6/25 15:57, Jens Axboe wrote:
> ...>> @@ -50,20 +52,83 @@ static int bpf_io_init_member(const struct btf_type *t,
>>>                      const struct btf_member *member,
>>>                      void *kdata, const void *udata)
>>>   {
>>> +    u32 moff = __btf_member_bit_offset(t, member) / 8;
>>> +    const struct io_uring_ops *uops = udata;
>>> +    struct io_uring_ops *ops = kdata;
>>> +
>>> +    switch (moff) {
>>> +    case offsetof(struct io_uring_ops, ring_fd):
>>> +        ops->ring_fd = uops->ring_fd;
>>> +        return 1;
>>> +    }
>>> +    return 0;
>>
>> Possible to pass in here whether the ring fd is registered or not? Such
>> that it can be used in bpf_io_reg() as well.
> 
> That requires registration to be done off the syscall path (e.g. no
> workers), which is low risk and I'm pretty sure that's how it's done,
> but in either case that's not up to io_uring and should be vetted by
> bpf. It's not important to performance, and leaking that to other
> syscalls is a bad idea as well, so in the meantime it's just left
> unsupported.

Don't care about the performance as much as it being a weird crinkle.
Obviously not a huge deal, and can always get sorted out down the line.

>>> +static int io_register_bpf_ops(struct io_ring_ctx *ctx, struct io_uring_ops *ops)
>>> +{
>>> +    if (ctx->bpf_ops)
>>> +        return -EBUSY;
>>> +    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>>> +        return -EOPNOTSUPP;
>>> +
>>> +    percpu_ref_get(&ctx->refs);
>>> +    ops->ctx = ctx;
>>> +    ctx->bpf_ops = ops;
>>>       return 0;
>>>   }
>>
>> Haven't looked too deeply yet, but what's the dependency with
>> DEFER_TASKRUN?
> Unregistration needs to be sync'ed with waiters, and that can easily
> become a problem. Taking the lock like in this set in not necessarily
> the right solution. I plan to wait and see where it goes rather
> than shooting myself in the leg right away.

That's fine, would be nice with a comment or something in the commit
message to that effect at least for the time being.

-- 
Jens Axboe

