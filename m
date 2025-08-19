Return-Path: <io-uring+bounces-9056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F4DB2BEAB
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 12:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8D871889422
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 10:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C99E322743;
	Tue, 19 Aug 2025 10:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efWNmM2L"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B2D31985A;
	Tue, 19 Aug 2025 10:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755598473; cv=none; b=lWXmgVIBkGhAqJXtRXRGC7oJnO4B5VB3Z4dnH9/GgS5rGbXmBRQHSTbINORELJxrP8O51M/i8a1JalLjZEiHLpUr0RR2RS/4Qpqo/ev7BUnNLDRpjJUUUJo3N3+FEZNSG6uAqauUQsGX8dIvF88l+MUXzaVXS+dNmF8s3GIdo/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755598473; c=relaxed/simple;
	bh=TiLlIk4Fixo6wPEGz4mvdKa8pnoU6LhJEhVBh2gxK00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QcjdV6kv+dd4W3t6b1wWDcihnn8mL8Qh3zTiSS85sKlEgWEyiiQH16dFWO1D8a+fbVEqcpMKl44bm1vD8NftnXn/qKYIuq10JDYf1nc8fn2j2jL+b7dtTE68xSWvYJVyeGDWlEfXwBLFZseeenHXtpC366BsL9vrtnotFYuxvEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efWNmM2L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CCDC4CEF1;
	Tue, 19 Aug 2025 10:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755598471;
	bh=TiLlIk4Fixo6wPEGz4mvdKa8pnoU6LhJEhVBh2gxK00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=efWNmM2L6Ah0+EStqwlMp5Fl8iNHaCsx40H/IlRXq56nk5MUnzcCQ0n8RW+TDb4R/
	 kBz1jHYYn81X4ap1++GUHWcjHgSaqHPLEPBxz/OJ6/VXuyyGYu1UNDByxOemte7ibA
	 /0JEh4WMykGAxEmaVqqezwjqjmLrT5yu8wgj3GqwtODW1POmb/PQ67QwDcwPZFQ8RN
	 +XXvPRrHsVr8LarDG2Td7UnruAMAY86LPFJZqnW2Y7fuu5JqNMa+rD2UVQSaesD/+v
	 Ddbzn71uuyV7Lrvj7tAI725+Vx3++1EFgrm7llchNUO8j0am5WxF6oA/e+hp0HEE9r
	 OJRkmB7hDlUzA==
Date: Tue, 19 Aug 2025 12:14:26 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add a FMODE_ flag to indicate IOCB_HAS_METADATA
 availability
Message-ID: <20250819-verrichten-bagger-d139351bb033@brauner>
References: <20250819082517.2038819-1-hch@lst.de>
 <20250819082517.2038819-2-hch@lst.de>
 <20250819-erwirbt-freischaffend-e3d3c1e8967a@brauner>
 <20250819092219.GA6234@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250819092219.GA6234@lst.de>

On Tue, Aug 19, 2025 at 11:22:19AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 19, 2025 at 11:14:41AM +0200, Christian Brauner wrote:
> > It kind of feels like that f_iocb_flags should be changed so that
> > subsystems like block can just raise some internal flags directly
> > instead of grabbing a f_mode flag everytime they need to make some
> > IOCB_* flag conditional on the file. That would mean changing the
> > unconditional assigment to file->f_iocb_flags to a |= to not mask flags
> > raised by the kernel itself.
> 
> This isn't about block.  I will be setting this for a file system
> operation as well and use the same io_uring code for that.  That's
> how I ran into the issue.

Yes, I get that. That's not what this is about. If IOCB_* flags keep
getting added that then need an additional opt-out via an FMODE_* flag
it's very annoying because you keep taking FMODE_* bits. The thing is
that it should be possible to keep that information completely contained
to f_iocb_flags without polluting f_mode.

