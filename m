Return-Path: <io-uring+bounces-10727-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A9BC7ACC4
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 17:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B00773806BC
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 16:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30C334CFDE;
	Fri, 21 Nov 2025 16:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KcHzRxxo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4AE34C9A6
	for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763741557; cv=none; b=fZiXkR3obknFAVIlRbsuDnwjyIZGheQZ+k2V8Mi/uOXVDVVqd5Yo6LgJdpDmQ5SXZQu2RjBntDqEelVE6n80CwroLkecK6YxyQ+TP5epWfO8B5qYP8fPY9+riKBEMIaRw7ZpTa4SYzUbuMd9Z+IjhGwxg0JbrlyhROEQaLajKDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763741557; c=relaxed/simple;
	bh=ZgqPfaK6VWEXZdLqNt0iEnR3nGhXa8URQijIh9dbPo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZqBMa9RtZQDVXI0ZRAmo8PzpsDYiIoL1pXy6MX12KDweV0SdYvleY9Ez14MFzHvA2z/uqDihdD7ol0le7/wmJXrIunXTqWEBppPUl7DK0NGDMaViGz2KmNTJB/pbcqGd0Nq7HeaH1ulkvAdZ6Nj2ibx4t/ETqv6nxo6AnFtPWcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KcHzRxxo; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47774d3536dso17713035e9.0
        for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 08:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763741548; x=1764346348; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gqIKEwT/rUMqsaYUty5E6HMF8PGsa9QB4kUVO+4IgS8=;
        b=KcHzRxxoMReSNyiA+xvzcjUUj3J7kziDZadgk9+7b4pZh/0kM/Et09agLfXz9GIK1s
         Oe5RLS2fwvyZJis70zeRfdyRA3TFDwgtAsHoFwg+1j+UjrB/ljV5z3qmTtJRIXpN2vG9
         QpApgc6kL8CTFIJLBe5KehLHosvg0LFir/9dWjtbiq2P8oPVa+hJfGt/huBnuebJqjyE
         kT4mgOWcPZucaF6qBlIQjvo5txadb5YqV6QMAqJRbPTpOhIQXkrsi4Qt6TglFkec6IPr
         twj7yJ8GKKZ4towtDGH1btEq2Efo7tTyJBeGnzGdzm0a52ucQ1WkafIk8Xyb/0u3iofO
         Pjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763741548; x=1764346348;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gqIKEwT/rUMqsaYUty5E6HMF8PGsa9QB4kUVO+4IgS8=;
        b=Xe2xUOIZv2gs9VJnIOXnfDXGv3TCEqMazu2aSwONQCyBXL3D0CSCt7VP1GRoY3rDVo
         pQMm4GKo/rA+NLYblXTAu/nm3VpwJ6VqLIbEgJgE2DgSCtq1FeHoYifWpIOFzE7FDzga
         v/HA73AeaOjflK1Cf1I5/r6qyjLIcy8Vip3PI0Aypt8rrsIIsPL3+tNrzMwXYuNDokNR
         3jNe3nIOtHu5n8fIT03N9FcxC928ZsCBZexB4Xjoq3Lo3eG6SrKXgYPakUd9Y0tNRbFJ
         C6c+WC3dpGbcK/C2kGaBin5VBzzuvJy1cg/Ha3g4j0NwiXQQhPe9ykTkU5M71S/jlGiJ
         Ge2w==
X-Gm-Message-State: AOJu0Yx/Yf7UNFVHPuZxig9pi14E61+R3W1DSa5Ni59S0wKu5kFg4daD
	ZdZz5gRgkFAG7DhIzO0cRfqLrJxcOyuVEWTdfA75DFtoBseg5Rt5Zn/dz4D7QQ==
X-Gm-Gg: ASbGncvAmkg94E+UWFWYfpFuFmrqjHKHRL7K6kTWOb4F3c3Caz63ho2tAJmj+R6IEZ+
	vTqaTBAQKmCyxoqKCPA626f9mSt6RH2uxXvcPf+DxYjLUcdVUskmh6K/VFOnzd5iX6Bxj2Y49v8
	VoSdq8w0pUiX+yQqL7NpXCnaGXhckF31EqrY6cZcbWRrKLXMAzaEu6cNBFtC9GY13mXFg8xsy1t
	LCM2bRRizl3lvR+YoR6n8wr3Ez5ijpo7APfqPnjRhTjd7yzNypFo6uOaA1aFMUWXgJ9vY8QAfAq
	T3MIp48DfHW921KaMvCGy8btC5Hi55cab0bW8DaT/Mrcpo1i6hlvzbGUzITQPnyf+wDsfW/ctqS
	KJB642UXhsNKjgy7f3dubvGr5kSlIFBdOlXQ55vIRqcClhnHLQx0qQqW1eOIaknTHfzwv1+4N58
	ZAzq3nFuDX5BcSvA6yC/F7shK/IxkitlboPN6nGjMCSi8=
X-Google-Smtp-Source: AGHT+IFlt0JhjSE9IV98wA3TZU9MPZgJtJ2z9Blxl9S9eSJcFCrFmdXcolTY3ZBMyw9cni0ADFDsXg==
X-Received: by 2002:a05:600c:2155:b0:475:de06:dbaf with SMTP id 5b1f17b1804b1-477b9efe351mr50829945e9.17.1763741547704;
        Fri, 21 Nov 2025 08:12:27 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7bc2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bd1580cbsm29401865e9.2.2025.11.21.08.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 08:12:27 -0800 (PST)
Message-ID: <1994a586-233a-44cd-813d-b95137c037f0@gmail.com>
Date: Fri, 21 Nov 2025 16:12:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/10] selftests/io_uring: add bpf io_uring selftests
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
 Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>
References: <cover.1763031077.git.asml.silence@gmail.com>
 <6143e4393c645c539fc34dc37eeb6d682ad073b9.1763031077.git.asml.silence@gmail.com>
 <aRcp5Gi41i-g64ov@fedora> <82fe6ace-2cfe-4351-b7b4-895e9c29cced@gmail.com>
 <aR5xxLu-3Ylrl2os@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aR5xxLu-3Ylrl2os@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/25 01:41, Ming Lei wrote:
> On Wed, Nov 19, 2025 at 07:00:41PM +0000, Pavel Begunkov wrote:
>> On 11/14/25 13:08, Ming Lei wrote:
>>> On Thu, Nov 13, 2025 at 11:59:47AM +0000, Pavel Begunkov wrote:
>> ...
>>>> +	bpf_printk("queue nop request, data %lu\n", (unsigned long)reqs_to_run);
>>>> +	sqe = &sqes[sq_hdr->tail & (SQ_ENTRIES - 1)];
>>>> +	sqe->user_data = reqs_to_run;
>>>> +	sq_hdr->tail++;
>>>
>>> Looks this way turns io_uring_enter() into pthread-unsafe, does it need to
>>> be documented?
>>
>> Assuming you mean parallel io_uring_enter() calls modifying the SQ,
>> it's not different from how it currently is. If you're sharing an
>> io_uring, threads need to sync the use of SQ/CQ.
> 
> Please see the example:
> 
> thread_fn(struct io_uring *ring)
> {
> 	while (true) {
> 		pthread_mutex_lock(sqe_mutex);
> 		sqe = io_uring_get_sqe(ring);
> 		io_uring_prep_op(sqe);
> 		pthread_mutex_unlock(sqe_mutex);
> 
> 		io_uring_enter(ring);
> 
> 		pthread_mutex_lock(cqe_mutex);
> 		io_uring_wait_cqe(ring, &cqe);
> 		io_uring_cqe_seen(ring, cqe);
> 		pthread_mutex_unlock(cqe_mutex);
> 	}
> }
> 
> `thread_fn` is supposed to work concurrently from >1 pthreads:
> 
> 1) io_uring_enter() is claimed as pthread safe
> 
> 2) because of userspace lock protection, there is single code path for
> producing sqe for SQ at same time, and single code path for consuming sqe
> from io_uring_enter().
> 
> With bpf controlled io_uring patches, sqe can be produced from io_uring_enter(),
> and cqe can be consumed in io_uring_enter() too, there will be race between
> bpf prog(producing sqe, or consuming cqe) and userspace lock-protected
> code block.

BPF is attached by the same process/user that creates io_uring. The
guarantees are same as before, the user code (which includes BPF)
should protect from concurrent mutations.

In this example, just extend the first critical section to
io_uring_enter(). Concurrent io_uring_enter() will be serialised
by a mutex anyway. But let me note, that sharing rings is not
a great pattern in either case.

-- 
Pavel Begunkov


