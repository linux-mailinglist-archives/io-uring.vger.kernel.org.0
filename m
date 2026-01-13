Return-Path: <io-uring+bounces-11617-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF17D1AEFE
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 20:06:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F36B3016DE4
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 19:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E79335771C;
	Tue, 13 Jan 2026 19:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="NkjJirpc"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A053570D6;
	Tue, 13 Jan 2026 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768331141; cv=none; b=E4EvYGDUQstWU5F6Whpc+2jsLWScqFNVg0vaIWklLVnxV5ubVNV3zYJcWnTiodhp0zanKPX2ON+PI/7PoJlEVDXoV9ybN3orSA7iqeIhWc3huT7ZE+5L6tEx1yzk6cSQDVX7rc6u8FYIbemxP1NBi21F2sswrcYwoBrIsI30XN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768331141; c=relaxed/simple;
	bh=wu2ToQdgBhgHCk0SMRuUYKoigLiRakf77u0rPqPRCa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IPX3jXo6Y1NODrZzORlCw+gKhKkaWGukZifSEklM9xviDnB6Fo3HDNRkTdfM3kZb/tzsL8xjW2gh/qoSHQOvHEmRA5KMvOc81jIxrRlBdIHOEo9fEmLijCXzvwHqiaY22D1euUNcUqfPpl0p+EAy9UgFWjhD80oo4W1qqnqlmUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=NkjJirpc; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lPg+mldV0tHpP5Arkhs5w91g4oKcpmQv2d6ztcobjyo=; b=NkjJirpcLC9kdmGT5sTwA+Ed6l
	20LRtJAF/cvV26OMlMIfhCEwSPSyzydcgaqVScsqee8TF2tki/94j8TuJFLLQIXoYuISAB7mYQQdr
	KsNxLoEEMqdox0dnSntl0BeazyM03C/D9sAdveMM01GNntrp2VDVkqfcn8Vq046Wd9Tu0ZuPlcOF7
	D5kqyCaTxXJq/PKAaX/5J8aQR+/qmkKs/xt3HrJ32ti5timEzat9Cg9j6jXDYZyoAVg3Y3iNYbMUZ
	NucH8xBTWFhodWvKUl2a+Y/lNk6MhshrdRwmfaahrT4DCqD70Ofg9kvBRBkZSFe0R9ZwukpigHh5W
	R6Y+4RHw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfjjJ-0000000FTeo-2Kte;
	Tue, 13 Jan 2026 19:07:01 +0000
Date: Tue, 13 Jan 2026 19:07:01 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com,
	paul@paul-moore.com, axboe@kernel.dk, audit@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/59] struct filename: saner handling of long names
Message-ID: <20260113190701.GO3634291@ZenIV>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
 <20260108073803.425343-16-viro@zeniv.linux.org.uk>
 <dc5b3808-6006-4eb1-baec-0b11c361db37@sirena.org.uk>
 <20260113153953.GN3634291@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113153953.GN3634291@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Jan 13, 2026 at 03:39:53PM +0000, Al Viro wrote:
> On Tue, Jan 13, 2026 at 03:31:14PM +0000, Mark Brown wrote:
> 
> > I'm seeing a regression in -next in the execveat kselftest which bisects
> > to 2a0db5f7653b ("struct filename: saner handling of long names").  The
> > test triggers two new failures with very long filenames for tests that
> > previously succeeded:
> > 
> > # # Failed to open length 4094 filename, errno=36 (File name too long)
> > # # Invoke exec via root_dfd and relative filename
> > # # child execveat() failed, rc=-1 errno=36 (File name too long)
> > # # child 9501 exited with 36 neither 99 nor 99
> > # not ok 48 Check success of execveat(8, 'opt/kselftest/exec/x...yyyyyyyyyyyyyyyyyyyy', 0)... 
> > # # Failed to open length 4094 filename, errno=36 (File name too long)
> > # # Invoke script via root_dfd and relative filename
> > # # child execveat() failed, rc=-1 errno=36 (File name too long)
> > # # child 9502 exited with 36 neither 127 nor 126
> > # not ok 49 Check success of execveat(8, 'opt/kselftest/exec/x...yyyyyyyyyyyyyyyyyyyy', 0)... 
> 
> Could you check if replacing (in include/linux/fs.h)
> 
> #define EMBEDDED_NAME_MAX       192 - sizeof(struct __filename_head)
> 
> with
> 
> #define EMBEDDED_NAME_MAX       (192 - sizeof(struct __filename_head))
> 
> is sufficient for fixing that reproducer?

FWIW, an unpleasant surprise is that LTP apparently doesn't test that
case anywhere - the effect of that braino is to lower the cutoff for
name length by 48 characters and there's not a single test in there
that would test that ;-/

chdir04 does check that name component is not too long, but that's
a different codepath - it's individual filesystem's ->lookup() rejecting
a component.

Oh, well - not hard to add (to the same chdir04, for example)...

