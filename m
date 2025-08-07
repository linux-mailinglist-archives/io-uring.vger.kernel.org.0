Return-Path: <io-uring+bounces-8894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B27AFB1D25B
	for <lists+io-uring@lfdr.de>; Thu,  7 Aug 2025 08:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D139F165BF4
	for <lists+io-uring@lfdr.de>; Thu,  7 Aug 2025 06:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3197212FAD;
	Thu,  7 Aug 2025 06:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="XFurapCN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953521CBA18
	for <io-uring@vger.kernel.org>; Thu,  7 Aug 2025 06:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754547433; cv=none; b=Yg1GgVGc83of2F3fiZk2n4ghKx+nKI4o/eM+bzAORhccGnGk6WlmUgL7IlfNtW9g4Mn0JL/MiaVFkcp35Oh8bx9Ph/fcnUa8XvhLUI9Wg3m26CuquPb65ZvDaTG+SmuUYyZx5Q8Ty+2xmV9YDy8ytCZDSbOMnfMB/niTdNlQlMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754547433; c=relaxed/simple;
	bh=aTI7KRMb+mTuV/VHOg0lvKzCQkP79foiGNftYWWJCNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BcK+J3iPSmD8asu3CUZKkgVDPm5wfTDB4htdobwlakOpRu86IHaJewl3qO8Gd7wz+E4aNKXhZduhsIeKfctcNTMFPrmTJ+N8j0Nub2D14rx0KqCUS5WmDvXNdAjyytVDWgsKmBuZKmYkeRm8c0ib5labjKfp/p/fZ2j8x5RFTeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=XFurapCN; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b3226307787so454038a12.1
        for <io-uring@vger.kernel.org>; Wed, 06 Aug 2025 23:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1754547432; x=1755152232; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ce659OtSUkmpdV6NFKc1K9485Iy6jSsKTUwN0rRmfcw=;
        b=XFurapCNEZTdArLKizqI2uckQ6MwjfbfXjKuUmaP/r4ksrCj+Cnn9kITcGjGMrv47r
         noueJKpFrIGCynhLQFB4GsS1ncTSRcbHpQcfwP5mfk1pDjCFBJDoS2nkPH6VowtU+phj
         WJ+57AduyykJpShz3Hp2uMOrlwE960sRX5sXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754547432; x=1755152232;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ce659OtSUkmpdV6NFKc1K9485Iy6jSsKTUwN0rRmfcw=;
        b=iubCwveV8+C7RAAnNTvA/s86WAkUdH3K6am6yLlo+kVsRPWZdKVY7Ql+HeuxDYHwz/
         D9NPEsL3rgjpVHl/3neFFebLYPwGag7dGUXEf0HyFk/HDvbrdIgLBGC+PumFTsJjZJAv
         JyOr2tv6swI3SBN8E3xfc4KDVFnpKdQhRewhDVln1Tl0zRoLBu9T7CPXjSGdcDnYX0y7
         Z5hwNGfNJ2cw1kbu4keESbS1BeevEYS07yykQHrTM1DCJTwT6dI5MfAVNKcIm5I3I1Eb
         Gnwc3znX3eB5JkAsgSLfRM+hgB5zctaMMbQKYGWyW7CP7QPAGLxJj3GCJvCbe+KnXWDi
         K0jA==
X-Forwarded-Encrypted: i=1; AJvYcCX8hVTEgAK5njjNZcSYVPafjGJVxTMQ+KjG9iVf9BI/7WmNGQlBqbaFP0sr0bM8iWoYA18jx0G/Qw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4fYito6JAwkSxFV7//25+GDXl7vFmY7vkdFj4/hOSJti2m1MN
	OwhI8k4ITCXJIMVJ1iFRUnCi9yihgNhLYno4O0JZPhekJKqZ8XzDfVT3YOhU3oBEF/M=
X-Gm-Gg: ASbGncu7+DEA8wPgYn5UA6uGrlJYnBmqVtrJng1933seiolkrH318koT/UVco6r4Hwe
	qV+jL4IrqYpqjOM6NSlXpcgu2gzj+X7ckSf6mQEY9/Aegqj9Go3lt4rU8MOYXRHS4N9OSGd2/j/
	yIBOtpVRjxqsGYDoSYBBs/BQKKY4VYn84rwmF9iVHiW8aoO0XtLpZF4DsJpy3pNaFi5YqhbtSlz
	OoVL/buuaR/oe8Se6UrD4Wi0/b73KDNToA2Jq35zVV265l7MB15GeDkNMHV506qRHrQ9mqYl6nW
	/Bv1jpWlcYRC3tO17I7EtrMpdcbpNTrSSZvuUUOFE+9r/Gw+NtG+UtdLMKMf06tX/p7/Msk8Ih+
	1t0pglaaV81+t8ftUlRyArguHikXHgJhXi4/D8AH9XvfJ6zfIgMRtrtMh
X-Google-Smtp-Source: AGHT+IH0frrBX/8KPXvenJx9gfme9Uust8UCZ54LaxAoHIwgcXp84/Tzc+gQadT1iW0DZKCuiadR2Q==
X-Received: by 2002:a17:902:d551:b0:240:5523:6658 with SMTP id d9443c01a7336-242a0b874b6mr70085135ad.29.1754547431644;
        Wed, 06 Aug 2025 23:17:11 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0f76bsm175262285ad.59.2025.08.06.23.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 23:17:11 -0700 (PDT)
Date: Thu, 7 Aug 2025 15:17:02 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] rust: miscdevice: abstraction for uring-cmd
Message-ID: <aJRE2CouQ4bSvCOf@sidongui-MacBookPro.local>
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <60A6421A-813F-4A93-88AF-4AE3027E1FA3@collabora.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60A6421A-813F-4A93-88AF-4AE3027E1FA3@collabora.com>

On Fri, Aug 01, 2025 at 11:13:29AM -0300, Daniel Almeida wrote:
> Hi Sidong,
> 
> > On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wrote:
> > 
> > This patch series implemens an abstraction for io-uring sqe and cmd and
> > adds uring_cmd callback for miscdevice. Also there is an example that use
> > uring_cmd in rust-miscdevice sample.
> > 
> > I received a email from kernel bot that `io_tw_state` is not FFI-safe.
> > It seems that the struct has no field how can I fix this?
> > 
> > Changelog:
> > v2:
> > * use pinned &mut for IoUringCmd
> > * add missing safety comments
> > * use write_volatile for read uring_cmd in sample
> 
> Why is v2 an RFC when v1 wasn´t? Can you mention it on the changelog?

It was just miss. v1 should be also RFC. I'll mention it for next v3.

Thanks,
Sidong
> 
> > 
> > Sidong Yang (4):
> >  rust: bindings: add io_uring headers in bindings_helper.h
> >  rust: io_uring: introduce rust abstraction for io-uring cmd
> >  rust: miscdevice: add uring_cmd() for MiscDevice trait
> >  samples: rust: rust_misc_device: add uring_cmd example
> > 
> > rust/bindings/bindings_helper.h  |   2 +
> > rust/kernel/io_uring.rs          | 183 +++++++++++++++++++++++++++++++
> > rust/kernel/lib.rs               |   1 +
> > rust/kernel/miscdevice.rs        |  41 +++++++
> > samples/rust/rust_misc_device.rs |  34 ++++++
> > 5 files changed, 261 insertions(+)
> > create mode 100644 rust/kernel/io_uring.rs
> > 
> > -- 
> > 2.43.0
> > 
> > 
> 
> - Daniel

