Return-Path: <io-uring+bounces-3310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C88CA9867BE
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 22:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF3EF1C214B9
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 20:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB8814A4F0;
	Wed, 25 Sep 2024 20:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="XhYaYOrI"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D46F1BC2A;
	Wed, 25 Sep 2024 20:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727297068; cv=none; b=JULPIgD5oM/3QbtK7i1Uvd4Un7BAV8oqlUZ+mo4rKK2v0KSUwKvfT6Qyrak4YkX2Vxagj96YgvjLDw50QF2elML2/8hXZzree16GMWSO9Q/whooP5GPB7R4X210o7PUJpeqHiDOPZIY+sBgueSpJMLIDo3B1vzCCONedonkBzPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727297068; c=relaxed/simple;
	bh=Fbk6O5CAotAlftvkhWP4DuezN7VHV3+NGddthWwAmIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSc8EtaL/EjZI5jOxVOCKjbCmBzF1fDvsEb3yUfgoihgXX5ttqrha2X1xBh152tmXpbSiO8XkzGaUNO7b3cYKhpKqqT6Pk0b3OfLxKsyI69bIFxFzTD0n1i76lphtRB4JbtuQT0AuROihMVdqbLIF/Gv9cHISKJtQyOU8xHTRx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=XhYaYOrI; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lbB2gk8PARMA53Ap/ekp66bi0vpth8/kBuQrxO9N+Ec=; b=XhYaYOrI5CUVp0HGSxdh2o4t17
	/4RxVTRov8uPrNoXzBJDmE0AVVnbASFK4lmtSLOmNUn4Owj45AmyDYJN4nnJkyTemuLiV3C5ZADhm
	XAcyqe0IEOLOkDxSIekUqjhxJpvMNKYIxvvznOr+eC02zYuO08GzZlOZOuvNZE7EU20mMvKhCtcJj
	RBCDiCTdbkOO93ot/gosR1EUvKRthwRapPaNNla2CXOrzEJ9x+O/MtyXhwg9DkG3RiUPmumFAMEcP
	hB08qFt2U/xaq+Y3SjNCYbi7S3ieV5YiEgCdhVg6AP+MLBQOGYd+CXFSlGxUYAx24UgYG4lKJMQZX
	P3BMM63w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1stYs3-0000000FVOK-0nNV;
	Wed, 25 Sep 2024 20:44:23 +0000
Date: Wed, 25 Sep 2024 21:44:23 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240925204423.GK3550746@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
 <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
 <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
 <20240923144841.GA3550746@ZenIV>
 <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
 <20240923203659.GD3550746@ZenIV>
 <CAHC9VhSq=6MK=HKCJ8KCjYNQZ4j_eCSgTpuYyHtk2T-_m2Br3Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSq=6MK=HKCJ8KCjYNQZ4j_eCSgTpuYyHtk2T-_m2Br3Q@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Sep 23, 2024 at 08:11:51PM -0400, Paul Moore wrote:

> >         * get rid of the "repeated getname() on the same address is going to
> > give you the same object" - that can't be relied upon without audit, for one
> > thing and for another... having a syscall that takes two pathnames that gives
> > different audit log (if not predicate evaluation) in cases when those are
> > identical pointers vs. strings with identical contenst is, IMO, somewhat
> > undesirable.  That kills filename->uaddr.
> 
> /uaddr/uptr/ if I'm following you correctly, but yeah, that all seems good.

BTW, what should we do when e.g. mkdir(2) manages to get to the parent, calls
audit_inode() to memorize that one and then gets -ESTALE from nfs_mkdir()?
We repeat the pathwalk, this time with LOOKUP_REVAL (i.e. make sure to ask
the server about each NFS directory we are visiting, even if it had been seen
recently) and arrive to a different directory, which is not stale and where
subdirectory creation succeeds.

The thing is, we call audit_inode(...., AUDIT_INODE_PARENT) twice.  With the
same name, but with different inodes.  Should we log both, or should the
latter call cannibalize the audit_names instance from the earlier?

