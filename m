Return-Path: <io-uring+bounces-5887-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D16DFA1295F
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 18:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DC597A2FA2
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 17:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60EF119E997;
	Wed, 15 Jan 2025 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="mbWkxXCO";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="DoGdmP2W"
X-Original-To: io-uring@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C531C194A54;
	Wed, 15 Jan 2025 17:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736960736; cv=none; b=VL0Opw8mqUO+BC+7dXqGw4s4AQbM661t2IXEqvDmTh0eOhoZfS4MJYW6F7fabLhMzUF0LckHYMusxd0Y5nB9eFrtQNksQzx1PaazhEtGymvCbLXNNtLJ1UWqr/Id5gJkB8xOfTCQ4bQpMTs3AqT7/+piJPZwXcCvm3Mhw2gXgNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736960736; c=relaxed/simple;
	bh=8DhqiL6dI9MFx1FCyboSYktsvc60YdWiCsxiT5pA+tk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=byGEFGenRJZC2pPxOf8yEmEjtToXuW109wUCcN59xcSkrKPCg1A1q/IhI3ANym8Xhv2VV084ChR1SsQ+XFmScqHcxpaHAjxJFIpv3eyqPIwnANibnI7SmynaPR0T7hFvnwHiBNSDaueMTyBK4Cp5Fof99vAXIUkgVRo/ysf+dNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=mbWkxXCO; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=DoGdmP2W; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1736960732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H7KjiSATnPHYpJGXMzRen2NwHGxJvHF9lUtc2zl2Bdc=;
	b=mbWkxXCOZU+SFtOO1Y1R8z/IJoPAtzXmivb+0MERGT2Ng0r2rnzsGnolk3Ae/ElNS+N2UJ
	O45t6X3b6wyGuZsy62N68TvjQI0wJtmT+jpH/YuNqI8IxPyeEzoj7mhgeQK/+2HawCEFPz
	hiDSuIlcmKUpfJBIfXGsV6zaCReETda+O8TEgYDeoEtwahVeuJ0QSf/+KZ3TTfpQZ+OH2O
	fYjs5Kw5/hE4sbiYH9o+B0B8fcaOTScG4ADq9UHOTMFocrLzrOWbMGMTOoVvg6CPkAOUVF
	7/XrG7loS2ykmFrTwFNYVyekJ8BTybR1IxSlZV640WPvgkp8f5QNn40e8DZDOQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1736960732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H7KjiSATnPHYpJGXMzRen2NwHGxJvHF9lUtc2zl2Bdc=;
	b=DoGdmP2WhbbWswzIXyP0EfhK37+OhZxpBv590kswOiEWNJfSgeAlNGBKyUoHSf9t5//B5w
	x4QRaCDDx9sTzADQ==
To: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Darren
 Hart <dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
 =?utf-8?Q?Andr=C3=A9?=
 Almeida <andrealmeid@igalia.com>, kernel list
 <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
Subject: Re: futex+io_uring: futex_q::task can maybe be dangling (but is not
 actually accessed, so it's fine)
In-Reply-To: <5603e468-9891-46a3-9ef7-13830cc975e5@kernel.dk>
References: <CAG48ez2HHU+vSCcurs5TsFXiEfUhLSXbEzcugBSTBZgBWkzpuA@mail.gmail.com>
 <3b78348b-a804-4072-b088-9519353edb10@kernel.dk>
 <20250113143832.GH5388@noisy.programming.kicks-ass.net>
 <877c6wcra6.ffs@tglx> <30a6d768-b1b8-4adf-8ff0-9f54edde9605@kernel.dk>
 <5603e468-9891-46a3-9ef7-13830cc975e5@kernel.dk>
Date: Wed, 15 Jan 2025 18:05:32 +0100
Message-ID: <87msfsatyb.ffs@tglx>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Jan 15 2025 at 08:32, Jens Axboe wrote:
> Here's the raw patch. Should've done this initially rather than just
> tackle __futex_queue(), for some reason I thought/assumed that
> futex_queue() was more widely used.

'git grep' is pretty useful to validate such assumptions :)

> What do you think?

Looks about right.

Thanks,

        tglx

