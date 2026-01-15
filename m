Return-Path: <io-uring+bounces-11748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC3BD28552
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 21:11:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5698F30034B9
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 20:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E7DD31ED7A;
	Thu, 15 Jan 2026 20:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="DbbG0xvb"
X-Original-To: io-uring@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68532320382
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 20:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768507887; cv=none; b=I35bO36W+kwtLshvt4vhTcGYuIsO3nQXirXTLCrZaLMNQQF67RWNzzSWQaeCqMZZXGX7Bhomnw7HFAzKpHYRJXllHTao8IdRDovysXr7rfB6SQ+xawSmCoYDplZMjS7qTg9RWL2gbVVn0XnVyALyW+bTVgn1gLEw9/uM/lrivHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768507887; c=relaxed/simple;
	bh=A10cHBVZ8s90qH2Hiwgyj2ghDRxzy4pDL5WpSNleP0Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=saSQNRoviNsZcDz9Mj3fkiw9tkhbnoXGDn820chgS+QZJh5T3SzzOWxVZMbiOtC536+yTJCd8zRvDYiZvkJuMAzj6jOWwj1KP7+zXqv78J67qZ/lYcWulL1+07nMxLExr7SGJrKR3W+kZT2GOJvdgkV2qE7en1Wb/K3A5lcfu6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=DbbG0xvb; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net C902D40C46
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1768507872; bh=TU4wOh4k5wVmL5F+8M1b8flAqVVN9TVk+49y/Vnuxx4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DbbG0xvbVWzqUv+xo+8IK5JsXI3YAOHB/7TJMcUm+OAvOwlPddUWL4lC8GdyKon3H
	 u2tFBudzHAwubAYFCKJfIWdny+rZub14KULLK2XTWScaV/xWKtMOp1ivcjAmuLVyWh
	 avD1BwFJUJVTkQlNZIYCFGTcwZwG7HCJb/dTtoKmgCz6fmZCMI8UCYTbU0iDymfyXR
	 CsYfSdX+l458HVcI5QCM7Te6ub8pwuf/mezuWYyQbHV4w4FfjHuc3iGM1ZroH0YJad
	 CxF82ncVM+5WsK3852GQs9P/WKEMa9AVuxPcetIgbsxzKAmYAiezaba6BIspiJmbDx
	 wbsfMRZgPcu4w==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id C902D40C46;
	Thu, 15 Jan 2026 20:11:11 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/3] io_uring: add support for BPF filtering for opcode
 restrictions
In-Reply-To: <20260115165244.1037465-3-axboe@kernel.dk>
References: <20260115165244.1037465-1-axboe@kernel.dk>
 <20260115165244.1037465-3-axboe@kernel.dk>
Date: Thu, 15 Jan 2026 13:11:10 -0700
Message-ID: <874iomskkh.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jens Axboe <axboe@kernel.dk> writes:

> This adds support for loading BPF programs with io_uring, which can
> restrict the opcodes performed. Unlike IORING_REGISTER_RESTRICTIONS,
> using BPF programs allow fine grained control over both the opcode
> in question, as well as other data associated with the request.
> Initially only IORING_OP_SOCKET is supported.

A minor nit...

[...]

> +/*
> + * Run registered filters for a given opcode. Return of 0 means that the
> + * request should be allowed.
> + */
> +int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
> +{

That comment seems to contradict the actual logic in this function, as
well as the example BPF program in the cover letter.  So
s/allowed/blocked/?

Thanks,

jon

