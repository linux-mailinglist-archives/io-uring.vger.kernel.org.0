Return-Path: <io-uring+bounces-10857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35C83C94B43
	for <lists+io-uring@lfdr.de>; Sun, 30 Nov 2025 05:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E67493A584E
	for <lists+io-uring@lfdr.de>; Sun, 30 Nov 2025 04:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524F723507B;
	Sun, 30 Nov 2025 04:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="t3voSP2k"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CF42264A3;
	Sun, 30 Nov 2025 04:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764475578; cv=none; b=QNAuXn6JP9ojRbozF/FLapU1TlS98sFwkKapkLICv9cBDRFBYlqiCai0VU8/zOabhLRMWvFDd8hA0q3yLNRuiu22mRbbfewi+KEK2VhyhOX7FT8xV+kUTiC/y5ZKUIczaYc5aWVAQlfL4iaqQRlktc0Y+p6WIUqz6X3tjGhcWy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764475578; c=relaxed/simple;
	bh=YNwIIfYqBO5+cdBdyu3c4hgHy4Nx4rxTPpQ67H5JgcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JfVkVoECnLdJgxYdXuAXcrXyv+UglpiQgr3fdW5fLVtY6G6OGOXx1ZMnHjVYMk0M9/Nkww+tCm0crd76wSjmpGrAX9pK6COlWNVCfaFinc/O2UsAIYC8bTrUrlSiI/QJuA1qLbyAOFoLDno8qWEZlCpKeiAjb65QE1Rkm0+2+wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=t3voSP2k; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nSdskNHmgV0YSm/A01QBV/qnJdvBNgWDr8yK34gImqQ=; b=t3voSP2kqv8pj6GI/GYGftb1VU
	lRYTA2VNBKjMhwtyWHENBuqvIrEtu9amW4M0r1UOkUDaCoTVbXi7KoeOXCBv+ydiU2mopiZmY7Q3D
	3JZE+iGEL87a//XpF2pFPdyl6u9m8e9VMn5hp4OrAhsYxTrNoNbyy3TKFVurw6cTb+hpaqXC6sTsI
	1RrbpFi5WDk96Lw0lxqtK+f3aVk9yBK55INWdq2qb/8QxDNt80Hpvi3uGrTmr/4rhrXGgbxxfBSOC
	VOXR0HLLbFs1htqGJ/S1cBUJ1Byp9k+6q9HLmlm/AbtaOunbUuNrxOtphlg5cD4HfizrbrZWAWYms
	LBAHWk1Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPYha-0000000Dcf2-1e0j;
	Sun, 30 Nov 2025 04:06:22 +0000
Date: Sun, 30 Nov 2025 04:06:22 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com,
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v2 15/18] struct filename: saner handling of long
 names
Message-ID: <20251130040622.GO3538@ZenIV>
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
 <20251129170142.150639-16-viro@zeniv.linux.org.uk>
 <CAGudoHFjycOW1ROqsm1_8j47AGawjXC3kVctvWURFvSDvhq2jg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHFjycOW1ROqsm1_8j47AGawjXC3kVctvWURFvSDvhq2jg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sat, Nov 29, 2025 at 06:33:22PM +0100, Mateusz Guzik wrote:

> This makes sizeof struct filename 152 bytes. At the same time because
> of the SLAB_HWCACHE_ALIGN flag, the obj is going to take 192 bytes.
> 
> I don't know what would be the nice way to handle this in Linux, but
> as is this is just failing to take advantage of memory which is going
> to get allocated anyway.
> 
> Perhaps the macro could be bumped to 168 and the size checked with a
> static assert on 64 bit platforms?

Could be done, even though I wonder how much would that really save.

> Or some magic based on reported
> cache line size.

No comments.  At least, none suitable for polite company.

BTW, one thing that might make sense is storing the name length in there...

