Return-Path: <io-uring+bounces-10187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB4DC06625
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 15:02:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B79634FFEAB
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 13:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778A931B803;
	Fri, 24 Oct 2025 13:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cLFrjVWI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E9031B114
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 13:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761310881; cv=none; b=pHDjsYGIdlYVXrM4iTjXwKPK4+fqly+xwN6CRPz4OEbGT01l7t6QtcegQRjzGrbWde+3y0q4S9LUcFtzN+bxR2gIzRCHF3H//ZdafPgc7W0yhv4blquLncvJYtsmz/hL5KhOEpr8Gui5P+RH8PHB39MjYeCWl1Y2ozOG0CsjB9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761310881; c=relaxed/simple;
	bh=f7UbUA5LJOa66b3nzPxh+hNtLqNDKnoi8F7izy8OU4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uF+l/TW5EbJon5HJ4Mfeg8sg6E0Ln4zSzNXAXhEg0Q+SQcuhoyDnB8BPfIgQYUFJQBJFuf8lGTPVbct+X7FvOwjqslw4wHzeVlLXM2JmCpagJ86xxg+fJ/XCgVqNOKcd2HE0Nzgi/XjsxSQrZbAddN2lqh2g6h34icuFZuMrN5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cLFrjVWI; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-430da09aa87so9803165ab.2
        for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 06:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761310878; x=1761915678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KWEW053UFU2OjqR3n7wSbRDn2Q1gyHVFRCkY9g7mqfg=;
        b=cLFrjVWI4NbRi2iDfLOyBv9HcLimVwl7CWsiq96+LrKYzti0uRzFMsCmQIB+t1OXgI
         e9B28gTAk/39+H1kxtsOrp4PUH8lML+yqzmdVSlJi86EMHPnTczn+okl9g8H6vleh+yy
         sl1vn2OThK5sSEyA10VCiDwvcOEUgV/q/Uh+2XwRMDg9MdUck7qaerv5cmXxS4QjnZSc
         ryL1riyc8SZHoBBCJQ0k/ZOfFx1xTLHZZFEkXIC7pV8aQpaeEofDCwxx0HAuUUahN41F
         nIrPo/MOmcuVqtRrAyODsdYILcWs8vqPGMcdM0cBAqa1WlHGIDZ01CnzWqwtqXHqj8sG
         kmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761310878; x=1761915678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KWEW053UFU2OjqR3n7wSbRDn2Q1gyHVFRCkY9g7mqfg=;
        b=FzGWiYusKPap268J9ir7B4q6mTNqEprCL6aPo4m3dfnrAu/FnWv607Lk7yw/QF1FM1
         pW/cdTdwY2MBcSN/AQ+bzMJVvT+x8vowBvU0+ms+FMzemeVpIxQEuRiUTfymM1HciTZI
         BUnbA6572W4G4J5J3CGZcZDEMogmN6SE25jxxn1N59DEJ4rWJ+HYh7JXkAPhKlIF4a4H
         iJnEasPFquouWDJD5HMyci8rgQPk6/sHhiID+SpR0Ccpe1i9EgRO5mywD8a+hybxuQeQ
         C9CblamnVnxZ4B32dtSvEhCm0/TL6MMQa0/2DkXI3paBgngHQBlJMTXPFIfjlqeGz+rt
         oeVA==
X-Forwarded-Encrypted: i=1; AJvYcCWy3DoQAhaag4+lOKQNapqY+k8YFG+hxx5SCACXXyaerCOJkDmPcuGDzVi5rvJkVsQwoOmi16VDwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyK5tsYvbWUy00708Iew71LuQqWA0ibEahVvkpB/xZS4tFQZRzK
	dzH5nwcJOpBnOUn57C6Xbz2nZmfnZ9PGWrYUAYJZ5YMKLSlHA8TOjBIYDGLY6p/AssQAf8UN7bs
	Q9JuvQlw=
X-Gm-Gg: ASbGncsnOjpf0Af+2y6PeOigMmr1ytDZzIH+0eHIviQEDbjm5YH6VzDTrcP82iddVZu
	hJx4uOHXTkRAr5KzZItXIZmNScHvPJK8EaLjbbr+ooFQOP61/HEVSuKwZw4lGifZWf/pqpKLMdB
	6nVhIC3dv3+lhQiEpCq0+dq8gxRlxF0CVkttaJVFLDom/qeg7mXenIpQ1Dz0AXDdGn3pgUNTucL
	EPcTSPuN87bgZ5PlDUh3HSja6a5YTZgTOyp4g5TXzBlaGhbrp3kUQFZgQjlaABn3FsYND8PIu4E
	nAb8mEeYPkSHZEgSBuY6RvXV1haj5txP+U4CUNND0qpihl67dEElcb0r3RYBnoNkVlnPp4U37rM
	vxk4xpUsB19wIlYAOU+RqmO4JsocbRlPZAYb+DQkxtvzCsvbPSI65vdckkJIraqjxKgHyA8UdKA
	==
X-Google-Smtp-Source: AGHT+IGpvX5SQasHnb2hnXJKXCopVxmccJ7n56Ub1lHMlmleJ7FVE++8WbJKETpki6AXprqZOR5QDA==
X-Received: by 2002:a05:6e02:1a42:b0:430:b338:e55 with SMTP id e9e14a558f8ab-430c53068c3mr412734055ab.29.1761310877249;
        Fri, 24 Oct 2025 06:01:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-431dbc3185asm21743765ab.14.2025.10.24.06.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 06:01:16 -0700 (PDT)
Message-ID: <e3c4b0c5-72e1-4a2d-a9bf-2e57b1e191ae@kernel.dk>
Date: Fri, 24 Oct 2025 07:01:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] io_uring zcrx: allow sharing of ifqs with other
 instances
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20251023213922.3451751-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251023213922.3451751-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/23/25 3:39 PM, David Wei wrote:
> Each ifq is bound to a HW RX queue with no way to share this across
> multiple io_uring instances. It is possible that one io_uring instance
> will not be able to fully saturate an entire HW RX queue. To handle more
> work the only way is to add additional io_uring instances w/ ifqs, but
> HW RX queues are a limited resource on a system.
> 
> From userspace it is possible to move work from this io_uring instance
> w/ an ifq to other threads, but this will incur context switch overhead.
> What I'd like to do is share an ifq (and hence a HW RX queue) across
> multiple rings.
> 
> Add a way for io_uring instances to clone an ifq from another. This is
> done by passing a new flag IORING_ZCRX_IFQ_REG_CLONE in the registration
> struct io_uring_zcrx_ifq_reg, alongside the fd and ifq id of the ifq to
> be cloned.
> 
> The cloned ifq holds two refs:
>   1. On the source io_ring_ctx percpu_ref
>   2. On the source ifq refcount_t
> 
> This ensures that the source ifq and ring ctx remains valid while there
> are proxies.
> 
> The only way to destroy an ifq today is to destroy the entire ring, so
> both the real ifq and the proxy ifq are freed together.
> 
> At runtime, io_zcrx_recv_frag checks the ifq in the net_iov->priv field.
> This is expected to be the primary ifq that is bound to a HW RX queue,
> and is what prevents another ring from issuing io_recvzc on a zero copy
> socket. Once a secondary ring clones the ifq, this check will pass.
> 
> It's expected for userspace to coordinate the sharing and
> synchronisation of the refill queue when returning buffers. The kernel
> is not involved at all.
> 
> It's also expected userspace to distributed accepted sockets with
> connections steered to zero copy queues across multiple rings for load
> balancing.

I think this would be a lot easier to review, if you split out a few
things. Like:

The locking of two rings, just make that a prep patch. You also need
to change the name, it's too generic. That was fine when it was a
static in a single file, but should be better now.

Add the reference counting. It looks a bit suspicious on the
io_shutdown_zcrx_ifqs() side, having it separate would also make
that clearer.

And then you can have the meat of it on top of those.

Side note - you need to check the return value of kzalloc(), it can
indeed return NULL.

-- 
Jens Axboe

