Return-Path: <io-uring+bounces-11611-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3ABED19F57
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 16:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 93E823055E11
	for <lists+io-uring@lfdr.de>; Tue, 13 Jan 2026 15:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44D538FEE9;
	Tue, 13 Jan 2026 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="fcnvYsok"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67580313E05;
	Tue, 13 Jan 2026 15:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768318713; cv=none; b=E0FQe3YupqSqwHIuPah1T3HF7T1DtmE4ffDvJMfbywFsoKh5yhepdMzBZeN7MccXyPnqgocLrXxUhIlSSCTSyY6XRF+GKk0NOsfvig/0/zYPOWHs3Qyo4I+YeXsB9C+5LMn4SBIqKT5i1jsmZMHdr0V+py17A/S4bxJdyDRhaH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768318713; c=relaxed/simple;
	bh=JV45WpGgkA1gkSKDj9H7W5qSLrG8YKyW24LsReSJPDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ynw6iDkAKX+vzxPqc5jxeXUEwluNJZEavra9u1IDMp0RIhDnTBIpVjASPoCR6eXhaOia3ZSESLsGlVeEbzShrpRibxb5KDNTOHlWSUvEkZRlDVYEK7FlpvXgJCUVokp4uTZb017PaEAFoMLMUa/qjUeFFkni0/ywJWA5Ly69cTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=fcnvYsok; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Tz5Q+c5vqDuIgduq1msZrWvHsIIB7/fDbpEbXxUeUkc=; b=fcnvYsokalJKb45vHYaPBoEF6e
	xQFcnDNym6MYTryK2DEpoAOPVJbxA/CTFfgCJ3o6+g+dIRYllyBMqJRwMNgwfwrccTuQ8qxlLUnmC
	PTIMLzxETEy+ULLpCYnn9c42DJ2Qez7XSQQgiMRzkMcCssOh0J4GR+nfk6yiuGXJP0WfObcL/FjIR
	cA07IJ4gLWbjkm+GW0hmj60GbBOZH51AMuoihhwsXb6gKbtMviO8TRUu3gYle8IuX4Be59LpSbhpL
	E5vTSfm+xwO+Ix7E+qsL0ZSgp31NiYfy03jzyoFzTWoAuVR/VBIJrH9demxgt7bEkB3Dz7EUDa0C/
	UDbahjYQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfgUr-0000000FDmI-2qCF;
	Tue, 13 Jan 2026 15:39:53 +0000
Date: Tue, 13 Jan 2026 15:39:53 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com,
	paul@paul-moore.com, axboe@kernel.dk, audit@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/59] struct filename: saner handling of long names
Message-ID: <20260113153953.GN3634291@ZenIV>
References: <20260108073803.425343-1-viro@zeniv.linux.org.uk>
 <20260108073803.425343-16-viro@zeniv.linux.org.uk>
 <dc5b3808-6006-4eb1-baec-0b11c361db37@sirena.org.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc5b3808-6006-4eb1-baec-0b11c361db37@sirena.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Jan 13, 2026 at 03:31:14PM +0000, Mark Brown wrote:

> I'm seeing a regression in -next in the execveat kselftest which bisects
> to 2a0db5f7653b ("struct filename: saner handling of long names").  The
> test triggers two new failures with very long filenames for tests that
> previously succeeded:
> 
> # # Failed to open length 4094 filename, errno=36 (File name too long)
> # # Invoke exec via root_dfd and relative filename
> # # child execveat() failed, rc=-1 errno=36 (File name too long)
> # # child 9501 exited with 36 neither 99 nor 99
> # not ok 48 Check success of execveat(8, 'opt/kselftest/exec/x...yyyyyyyyyyyyyyyyyyyy', 0)... 
> # # Failed to open length 4094 filename, errno=36 (File name too long)
> # # Invoke script via root_dfd and relative filename
> # # child execveat() failed, rc=-1 errno=36 (File name too long)
> # # child 9502 exited with 36 neither 127 nor 126
> # not ok 49 Check success of execveat(8, 'opt/kselftest/exec/x...yyyyyyyyyyyyyyyyyyyy', 0)... 

Could you check if replacing (in include/linux/fs.h)

#define EMBEDDED_NAME_MAX       192 - sizeof(struct __filename_head)

with

#define EMBEDDED_NAME_MAX       (192 - sizeof(struct __filename_head))

is sufficient for fixing that reproducer?

