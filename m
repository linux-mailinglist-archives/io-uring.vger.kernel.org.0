Return-Path: <io-uring+bounces-12469-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAMjAkv5oWknyAQAu9opvQ
	(envelope-from <io-uring+bounces-12469-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 21:06:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E4C1BD339
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 21:06:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 35F1B30C5B7F
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 20:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E983346BF;
	Fri, 27 Feb 2026 20:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fKS94CwA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371FF4218A8
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 20:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772222755; cv=none; b=KXfvAiYywJzFthrnQYXVM7JyqI6zn4htmVowzdDLBCQSVPbdcWLoJjTl5/ttUmxwd2TZhYvwsSSTLNdvtEQTMXYTcBZbw4BY/XYB0o/lTZloo/tFc2W9qCQTnFBWlV3WHKOSvHaVHnaiw9gw8+klV3j5wdqUBo48wojJLZXQUrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772222755; c=relaxed/simple;
	bh=k9io99d/tyAXYmYv61T29R8zd4lRbNHO1Vz/AUydSoo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=VZTCVI4CtqI+JGDvIqjUUR5zN26xdlxk0Nn7Fya1Q+mHdEU3xbFaBck+fA8nlpiepZF/kWzlaBVAVURbLsK8+9B+bbvfFlhmZEahWbZafABW10krmjRT1mwtcq/npn77+gYs/+drAoRAVbyJWc4zbHExTZiv6HVQ5wapV77JWbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fKS94CwA; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4806ce0f97bso20097115e9.0
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 12:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772222752; x=1772827552; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=80N7RgSjtp+iVOpKN1mjgTzo46nZb29UdWriVCAO4DA=;
        b=fKS94CwAlc/TFM3713KKlCOfggNmdaWBVe7BMJlA6gcT4D/SpDP2ltgVceMQf/pxxC
         oATOSkugUMuav/PD62zBQBXUjTuuJVlWI2qCFtZL5LyPydtDiKZYx1VxLEV3Rx1t5Bu5
         o8j/6t5bpd07jVPomrA1Uq3xGiw57D+/gAlPswjrNfi1w8SNQkpezzTr9+BFl+Lk3O+Y
         oKMG8rKlpWec9mWoMty89MKNdX1V1RW4Nm1RjxyPX3RewrBRlZvAurDWwKJQJrWN+JBn
         ezBb8Z01cLnHgc6UxOrzSnoo1pZjRt4PjLtTxdhhsdcNa4NmZgmESzvajQPp3FUixw0i
         ueFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772222752; x=1772827552;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=80N7RgSjtp+iVOpKN1mjgTzo46nZb29UdWriVCAO4DA=;
        b=MlCSaMTyZ346Jm6EtGPKVSJwXcxMcv7iBC3DV8MChLspJOJ8e1i4oj3hT2YEyDtlDK
         2YtheOQVBeRepKkU4ZNP8Wt9IBd+T6nKjE152C61iwAfcvp9fpue1Rh7DGmoBlJh02Br
         5Mrq161Mww9ubMOGZAkIB8SUnhlklCQZ/sDiMA2aAA1TYKwbcLpl0fAlcdE+liKVS/QV
         Z+6wB/eWjMQByN9dlSoC8jycYZ9e9tH1AA78WgTtLJ5y+BTWbOFWvk96qafqFGGmNG8I
         2QN9yrvEfYDzkYxxmvXyRE+I26WDP/dOyfMXfOT05P0Sh90+WbNYgVhYbsMuUmR3fXYo
         dt2w==
X-Forwarded-Encrypted: i=1; AJvYcCVczCh3An1raTzdOUj31v3ISeNx0f9cZSJ1/jhNqAaQiXmblGnoI4eZQTEjn2vcwGfNqosS7t5xDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzaOGmte31Dv5cIVhzSXZuGeQH3KSJxA0CKKQJ3jdbJ8HxRPaa5
	+qrOABDLDfKr81hNNHBu9pqX4STkdMOQR3yLX7raVZQiSU/WqNi+5fzi
X-Gm-Gg: ATEYQzyaIpxa947WHDhvTu1XNjKgRafcMvsnci04AZtCumyOYCTlslmADwBe+U//F2+
	ice4lKZFQWqatM6O8nDxv9OwZBrCedS447lX8pMVwJHZJRxYP0PLNYbWp6Jr/HtrtgGYhcdEYXT
	fApd+AqBLow5hLiuUOCAJNotgKkTO9TuxsXiNn8I2TZCWXVJfCwD0IY4uG96q4+aC3iBJKM2dtZ
	KX+Z9BeW6pi7RzJnssuUAnBxeaOQCf8MTcfGxz7eO74pzXUTYuPv+owXImba1TASzBMJkI+Kz85
	QMhYjEG8uUEN0Axx0P2CUJvxa95s6HjnTaGfiYKTsLUySgXYfV9X8zV6T6/bRe8QMGpAC7pqvBx
	tqMTjjNFYzFZjaLh+3qWvlhmY1INr5X/Q2N8HyG5qHjqcYc4+V7lqnKP/8Kda++YReHBOFduvJt
	MIeV9EVtiQRTVKnwuVspOk3fMRYhZFV2YDQaYHfw+lt9CdeVkPHyjIaSm6YaFze3BgSzgQq5M4p
	kgUv1i1r82EUsZs14CQyGZE22kkt5DWTgdm1LCIpXB7bXcvkxMWZXqlWS5IRqlBl/rwoUic77uo
	Vw==
X-Received: by 2002:a05:600c:6085:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-483c9bb4ce4mr71248125e9.15.1772222752361;
        Fri, 27 Feb 2026 12:05:52 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb29715sm168629085e9.0.2026.02.27.12.05.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Feb 2026 12:05:51 -0800 (PST)
Message-ID: <000f7db7-5546-4680-bef2-84ce740ad8fd@gmail.com>
Date: Fri, 27 Feb 2026 20:05:48 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
 io-uring@vger.kernel.org, csander@purestorage.com, krisman@suse.de,
 bernd@bsbernd.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com>
 <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <aYykILfX_u9-feH-@infradead.org>
 <bd488a4e-a856-4fa5-b2bb-427280e6a053@gmail.com>
 <aY7QX-BIW-SMJ3h_@infradead.org>
 <34cf24a3-f7f3-46ed-96be-bf716b2db060@gmail.com>
 <CAJnrk1a+YuPpoLghA01uJhEKrhmrLhQ+5bw2OeeuLG3tG8p6Ew@mail.gmail.com>
 <7a62c5a9-1ac2-4cc2-a22f-e5b0c52dabea@gmail.com>
 <CAJnrk1Y5iTOhj4_RbnR7RJPkr7fFcCdh1gY=3Hm72M91D-SnyQ@mail.gmail.com>
 <11869d3d-1c40-4d49-a6c2-607fd621bf91@gmail.com>
 <CAJnrk1Zr=9RMGpNXpe6=fSDkG2uVijB9qa1vENHpQozB3iPQtg@mail.gmail.com>
 <94ae832e-209a-4427-925c-d4e2f8217f5a@gmail.com>
 <CAJnrk1a1FAARebZ0Aqw18zxtOy8WTMb2UfcAK6jQaigXiZbTfQ@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAJnrk1a1FAARebZ0Aqw18zxtOy8WTMb2UfcAK6jQaigXiZbTfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12469-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 75E4C1BD339
X-Rspamd-Action: no action

On 2/24/26 22:19, Joanne Koong wrote:
> On Mon, Feb 23, 2026 at 12:00 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 2/21/26 02:14, Joanne Koong wrote:
>>> On Fri, Feb 20, 2026 at 4:53 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> ...
>>>> So I'm asking whether you expect that a server or other user space
>>>> program should be able to issue a READ_OP_RECV, READ_OP_READ or any
>>>> other similar request, which would consume buffers/entries from the
>>>> km ring without any fuse kernel code involved? Do you have some
>>>> use case for that in mind?
>>>
>>> Thanks for clarifying your question. Yes, this would be a useful
>>> optimization in the future for fuse servers with certain workload
>>> characteristics (eg network-backed servers with high concurrency and
>>> unpredictable latencies). I don't think the concept of kmbufrings is
>>> exclusively fuse-specific though (for example, Christoph's use case
>>> being a recent instance);
>>
>> Sorry, I don't see relevance b/w km rings and what Christoph wants.
>> I explained why in some sub-thread, but maybe someone can tell
>> what I'm missing.
>>
>>> I think other subsystems/users that'll use
>>> kmbuf rings would also generically find it useful to have the option
>>> of READ_OP_RECV/READ_OP_READ operating directly on the ring.
>>
>> Yep, it could be, potentially, it's just the patchset doesn't plumb
>> it to other requests and uses it within fuse. It's just cases like
> 
> This patchset just represents the most basic foundation. The
> optimization patches (eg incremental buffer consumption, plumbing it
> to other io-uring requests, etc) were to be follow-up patchsets that
> would be on top of this.

Got it. Any understanding how the work flow would look like if used
with non-cmd io_uring requests? Is there some particular use case
you have in mind for fuse servers?

>> that always make me wonder, here it was why what is basically an
>> internal kernel fuse API is exposed as an io_uring uapi. Maybe there
> 
> It's not really an internal kernel fuse API. There's nothing
> fuse-specific about it - the infrastructure that's added is the
> infrastructure for a generic buffer ring.
> 
> The memory that backs the buffers for the buf ring needs to be
> io-uring specific. io-uring already has all the infrastructure for
> buffer rings. So I'm not really fully understanding why it's better in
> this case to just have the fuse kernel code re-implement all the logic
> for a buffer ring and go through these layers of indirection to use
> registered buffers, instead of just leveraging what's already in
> io-uring.

It's simple. If user space (i.e. fuse server) knows the buffer
address prior to request submission, then it should either use plain
user addresses or registered buffers. Introducing a major io_uring
uapi extension that does the same thing as registered buffers but
for regions, as you suggested, is not the right approach.

...
>> It's up to the user (i.e. fuse server) to either use OP_READ/etc. using
>> user addresses that you have in your design from mmap()ing regions, or
>> registering it and using OP_READ_FIXED.
> 
> Yes but I don't think this solves the concern of userspace being able
> to unregister the memory region at any time (eg while not doing
> io-uring requests) while the kernel still points to those addresses
> for the backing buffers of the bufring, since there's no callback that

If you allow normal requests to use it, a fuse callback on region
unregistration wouldn't help anyway.

> gets triggered in the subsystem when a memory region is unregistered,
> which means there will need to be extra per I/O overhead for having to
> ensure the memory region is still valid. Though since there's no uapi
> for unregistering a memory region this is not a concern, unless this
> is planned to be added in the future.

You can assume it's not going to be unregistered.

-- 
Pavel Begunkov


