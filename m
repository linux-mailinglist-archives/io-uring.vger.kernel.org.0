Return-Path: <io-uring+bounces-12006-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2IjjBpslfmlQWAIAu9opvQ
	(envelope-from <io-uring+bounces-12006-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 16:54:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 99884C2CBF
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 16:54:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8D96D301BA47
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 15:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855A333986D;
	Sat, 31 Jan 2026 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1/qmmZkQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C2A335555
	for <io-uring@vger.kernel.org>; Sat, 31 Jan 2026 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769874840; cv=none; b=dzLi1HU+VbyP3x3EzeuDFylxZLYhzp54Rtp62aOGLbSy9otVNAWbIku892pBeIJ4KqKu90G2dpzKkFi+ioxXXECu71rHonANbu9ZFduLQVXhION4Eb0oDAmE6RZFxko/4gQXStAJff7PUx1HJ5zGnh478kruOSZa2sL1UUctgjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769874840; c=relaxed/simple;
	bh=gPxfc1Or7MT2TMudnUd49s5dM7oxPJDUq2h82ELaFPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aiXlbN/rerWgJcTZhh+Q0uqMZBdlRgErlUUZ4GjcVW3R6TLm8JVqUgCoCqRQBT1atz7+LV3lNeigKZIn9cIbkbvDEcwQsxzfi7O2MjuLV8dna7V5nnbwwfLcGwNpOP6mwYylXs/mDwOgdcqxUJR/Tmj+EOKQZg45hRnd6awBiwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1/qmmZkQ; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45efe81556fso2139107b6e.2
        for <io-uring@vger.kernel.org>; Sat, 31 Jan 2026 07:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769874837; x=1770479637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=es4JeecL4qbaq7ZMUlzngsGo7GQdpeuMD9cshqCD5BM=;
        b=1/qmmZkQfk4elnkxUBpqoKRBAIivPPZdTNmiwiENMhuOS/QNdRTSkGOweWlC9X1KRI
         cRvXaAIDutBaTjj9p1e6bq24dcSaZWTUEAGKrkDnA9qmF12rg1AjbBar7lrHiWgnxcHo
         Yi8q3pGLIXW45c5VR53s4g8SyNM8e9IxlrUTed5w+lWMcpEgxWclCMLKyz9KVkTreuLN
         0Yh0NLzGV+ycaLPti7ydUniUYwde4pukoltkPUYFveJhVTLezSUwva0ZWtXF3B1REL8/
         BY16sbbnabFPkkF65EpRjccfNyYtrWtf88SZH4sbOvzC7WFsZNPaAZDimoFSsTpmuC5M
         PR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769874837; x=1770479637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=es4JeecL4qbaq7ZMUlzngsGo7GQdpeuMD9cshqCD5BM=;
        b=wQRxnQtbZaT1H3ChHG0t/zaZB7ozuAfvZlVvyu5LJYv9Zn5sU0wpkubfxaeKZWx+pG
         ssxaiFSJ8AnzdyfhzuECHcEOecMwOcW59zWLaI/GPGQKb/C5vba6fDG5iUmuXdBl0cNY
         juaVUmfwYV7uV1pqthzNM4q2ca0oc1f1yfG/1nOMYW5eztmPBSlUAuXwP+8JBtULAkdf
         8+kZZTSsKB9XB/E/io84qgfhqbX1CXLNB8VipQCS4XgvqFi+/RjGlQVPrtIaJwvCfesW
         KsTh+3Vy/I/d8Vo1fdbG+wIRNgBxpDfxWuohN4NuEIlGFfdVXT164r03IleGJOZAURZR
         WKYA==
X-Forwarded-Encrypted: i=1; AJvYcCWIC2HWeQzC/OWx3LOsxStnNQG2dBKUZuFI/TPV1zYDPLOnBDKsAR+TCa8YzV49Ohu1X7Vn9W0DxA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCusLAtaib6EJ3m7QVZKiL4Ag2Q/mSp6Ig/vgrQo5oev+xKGFI
	wIY6jbq7QJPrsHrYwyT4xQv38Nl7kKzbSd+dL1qoPDsjEZPdjX2UvGAHQcLMnWGAxKU=
X-Gm-Gg: AZuq6aKjplUb+ZI1bAQ/BLr/BoKgz19S8KI1UTC3l+jp0RX7BrIAn6wK/nqdsSDWHC4
	LFVM0xFXZ5oW5NRTPdXiL/vQo0EI9MwLusShBx3DjRueOsDWjHfA+cw5x4o9d0dWu2hgDohOzPM
	z+4fM5x3hTB7QkoynF8ibQsh78D2c3QAPpo1N6P+W6GX5Ny4rmk36Pn0XpV05sT98DYrLUFCnoc
	4kY17r60GWgnVl6CgFnLVmPrIhHrGcyO0yVhYpPyphjxjUrMN7QUigk/kUylO+QHJzxW9JaWKhV
	4Sd3mRbMnY6uLMuvlvcXiD0RYMzQwOInKuSwC5QvRwNMe2ME/s171BLZqKKrJ0CNQPaWRlVkLqP
	JsHtyWvQnlmRMs1+7t5Zq+TDjC3xiB4VE/z38Mzva8UfcMDrfqKdjR22B68p/HT66SFCV73r5W0
	UJSnNhtb75d/7oFZJ5rILCpK4tMC8FOhUQph2fLerJyabeXhcQE7Gup9xP2UJpbQsNlmqXQQ==
X-Received: by 2002:a05:6808:4fcd:b0:44f:f747:f9f with SMTP id 5614622812f47-45f34cd0c5cmr3020550b6e.36.1769874837163;
        Sat, 31 Jan 2026 07:53:57 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45f08fb635csm6413741b6e.21.2026.01.31.07.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Jan 2026 07:53:56 -0800 (PST)
Message-ID: <c52642da-6938-41c6-814f-831f57ecaa8d@kernel.dk>
Date: Sat, 31 Jan 2026 08:53:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next RFC 0/3] net: move .getsockopt away from __user
 buffers
To: David Laight <david.laight.linux@gmail.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>,
 Willem de Bruijn <willemb@google.com>, metze@samba.org,
 Stanislav Fomichev <sdf@fomichev.me>, io-uring@vger.kernel.org,
 bpf@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <20260130-getsockopt-v1-0-9154fcff6f95@debian.org>
 <20260130205227.6fb1d9ad@pumpkin>
 <CAHk-=wiiPxGrVxFzzf1nbx7_0abjZkhmd9oPximUxUyDM7gwug@mail.gmail.com>
 <20260131153735.3c9273a8@pumpkin>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260131153735.3c9273a8@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12006-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,linux-foundation.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux-foundation.org:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 99884C2CBF
X-Rspamd-Action: no action

On 1/31/26 8:37 AM, David Laight wrote:
> On Fri, 30 Jan 2026 17:19:55 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Fri, 30 Jan 2026 at 14:40, David Laight <david.laight.linux@gmail.com> wrote:
>>>
>>> There is not much point making the 'optval' parameter more than
>>> a structure of a user and kernel address - one of which will be NULL.  
>>
>> That's exactly what we do *NOT* want. Because people will get it
>> wrong, and then we're back to the bad old days where trivial bugs
>> result in security issues.
> 
> It can still be a (semi-)transparent structure that code isn't allowed
> to change. That is no different from using iov_iter.

Then why not just use iov_iter?! FWIW, I fully agree with Linus on this
one. We have an existing abstraction, we should use it. We've previously
optimized common cases, like ITER_UBUF, if that ended up being
important. We're better off using iov_iter and improving that, rather
than some new mixed pointer abomination.

>> Can you point to an actual case where setsockopt / getsockopt would be
>> performance-critical? Typically you do it once or twice.
> 
> IIRC a really horrid one - I think for async io.
> That is also one of the few where the supplied length is a lie.

Huh?

-- 
Jens Axboe

