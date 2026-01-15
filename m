Return-Path: <io-uring+bounces-11750-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47952D289AD
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 22:05:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BD8B03007C1B
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 21:05:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C8E32693E;
	Thu, 15 Jan 2026 21:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="YjTt2l91"
X-Original-To: io-uring@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE81A326939
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 21:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768511133; cv=none; b=qSZIi3G+DXZqyPLGSdpP03Tmtf79IShvDFspZVA3CMzZ8ekOkktzZnTc+hj2849qIrfQQVJMf7ODounYTfDYeGbKXKzxt8+lkHat2iEE4B3JiuKI7i61BOnWhe75X7BuXXTEE+z0U+vBgvUtJKDn5y54Uz7tVT17KCKxBiyy+4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768511133; c=relaxed/simple;
	bh=qhLfUPClJjzfRmaSAvbBlyzS72u0fDZOB2S+Y/LiVpA=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TXDblJQisVySqGAoBK+Sra/AcjKNFWTRVBM4EaeqGtDVSMf8gNZnJiQ1BexhF+vbZ2fNFhVZ4rrUYF/hwa4R0y7ZMMDQ5dEssuP1dHwEUHSyoiOurCwdYZxwIpsMz38iL9dVER3LrhkkNf1nZWyX95fTPBpHbhHFv0w2TUCDSYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=YjTt2l91; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net F023C40C46
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1768511130; bh=86FDuOr0C0Ggfi1fzf4NYpcuSc3ZacI94+0ORwaU1Uk=;
	h=From:To:Subject:In-Reply-To:References:Date:From;
	b=YjTt2l91863RPYfvqur4Y6uaEuAx+kums1BOctNydE9Ccd7nEcOUJbAj9QnN93MSB
	 dyFBgA2vWnT1clvExsmnRknC3EsbZAHF4/+EI3XEFutC13n0uDboJ4kf7QIEF2Ukmm
	 UwyaPizcIvHutSyW++1IlrEoZk3eqcaDtIsIekvo0512xH/I9Tt5pvUstvSNmSg3zr
	 qEYx6s+8esZhhYSitIUg3VieDGcdKNx5wZcWyo5UNcL6CW6anAsQvDsDdEdfo3KytX
	 7jqxe97QirrHyZuZZ1j8jSMEMZDbM+sqGzefH5U2J2K//+7Xy9FtHifSlpLEiG48hS
	 WTQzbfmm2ioug==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id F023C40C46;
	Thu, 15 Jan 2026 21:05:29 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] io_uring: add support for BPF filtering for opcode
 restrictions
In-Reply-To: <9c57ec11-bd72-4caf-8c4b-b46c84f67ef3@kernel.dk>
References: <20260115165244.1037465-1-axboe@kernel.dk>
 <20260115165244.1037465-3-axboe@kernel.dk> <874iomskkh.fsf@trenco.lwn.net>
 <9c57ec11-bd72-4caf-8c4b-b46c84f67ef3@kernel.dk>
Date: Thu, 15 Jan 2026 14:05:29 -0700
Message-ID: <87h5smr3hi.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jens Axboe <axboe@kernel.dk> writes:

> On 1/15/26 1:11 PM, Jonathan Corbet wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>> 
>>> This adds support for loading BPF programs with io_uring, which can
>>> restrict the opcodes performed. Unlike IORING_REGISTER_RESTRICTIONS,
>>> using BPF programs allow fine grained control over both the opcode
>>> in question, as well as other data associated with the request.
>>> Initially only IORING_OP_SOCKET is supported.
>> 
>> A minor nit...
>> 
>> [...]
>> 
>>> +/*
>>> + * Run registered filters for a given opcode. Return of 0 means that the
>>> + * request should be allowed.
>>> + */
>>> +int __io_uring_run_bpf_filters(struct io_restriction *res, struct io_kiocb *req)
>>> +{
>> 
>> That comment seems to contradict the actual logic in this function, as
>> well as the example BPF program in the cover letter.  So
>> s/allowed/blocked/?
>
> Are you talking about __io_uring_run_bpf_filters() or the filters
> themselves? For the former, 0 does indeed mean "yep let it rip", for the
> filters it's 0/1 where 0 is deny and 1 is allow. I should probably make
> the comment more explicit on that front...

Ah, yes, I got confused between the two, sorry for the noise.

jon

