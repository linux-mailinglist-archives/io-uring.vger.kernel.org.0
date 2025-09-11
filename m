Return-Path: <io-uring+bounces-9724-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07424B52532
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 02:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AEE37BBB5C
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 00:51:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B671ACEDC;
	Thu, 11 Sep 2025 00:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="hrzQDUDs"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E79617D2;
	Thu, 11 Sep 2025 00:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757551998; cv=none; b=iG+mPcqO8ejceyfk+gLUUWYJ/DXMRSLbb+K/CSrf3a/ezSP3pSnsioq7qIcTKpktQmzFB62LeBsBpwpPR2ivwVSAy5uq6ngnTmE0g48F+kizlTfV2IY87ntnAWgBIqEuC2qCX4QywrAuSDgrPOV+lzyr+1ZJTUPaD58zgAiVWcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757551998; c=relaxed/simple;
	bh=mtvQYI07gAg/rmtniXZgDwCf2BFWI6g9dA6zxM8CNtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PgAXvzUavPhw3gy9TmGbxelhL3BcGdP10N+uLQlpXxRh4r8h4mBk63Wg354Yx6k7xLFIdDsocL8GlgWZ8moO6H9TI3kP0xCG7dVnbh87E1BeO7+hEXDYhbrNoqDfW3OqW21oa+AFP+j1816LQb/LbTek5WOEAH3qsP9LyizGeT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=hrzQDUDs; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LxE88Yw29XtmMzQcqQYIxxuI/lwirl5m7cem0u7Gy20=; b=hrzQDUDs/KJ/qxdeZX4U0NXSHv
	qjq2SzKpS1hcoxUm5gcgIT1fCfcNrEWS6FC1FHBPidVEXMJeTMU4Mb08Wh2yOge9yirYHppu8Ef8x
	qbOpRUM6Tph10gPNJTVfqTsoV6AlL9QOwtcJ/4OLkoq2erdB7fwSC8yPjeUh9eRIl008ZTqUb7emE
	SAtxmQHEP2s1BgVeTGMkWrVB+M3Xr8bgkU25DlbI0Jy6ftEYC/PWIXSl3aUpmk+LkUxZnRWoNBR+q
	OO1wh8mW72b0fREUtBqf+mFBbYY8uHblRlxLWYo97cx5uEfFFNNdJ8RlLLVSht6d/mdAIqrsCvnvU
	drtebSXg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwVYm-0000000AGMx-0Rmi;
	Thu, 11 Sep 2025 00:53:12 +0000
Date: Thu, 11 Sep 2025 01:53:12 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 04/10] fhandle: create do_filp_path_open() helper
Message-ID: <20250911005312.GU31600@ZenIV>
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
 <20250910214927.480316-5-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910214927.480316-5-tahbertschinger@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Sep 10, 2025 at 03:49:21PM -0600, Thomas Bertschinger wrote:
> This pulls the code for opening a file, after its handle has been
> converted to a struct path, into a new helper function.
> 
> This function will be used by io_uring once io_uring supports
> open_by_handle_at(2).

Not commenting on the rest of patchset, but...

Consider the choice of name NAKed with extreme prejudice.  "filp"
thing should die; please, do not introduce more instances.

It has crawled out of Minix guts, where AST had been tasteless enough
to call a structure the represents an open file (which is called struct
file on all Unices, Linux included) "struct filp" instead, the identifier
standing for "file and position", nevermind that he did include more
state than that - the damn thing (in OSD&I appendix) is
struct filp {
  mask_bits filp_mode;		/* RW bits, telling how file is opened */
  int filp_count;		/* how many file descriptors share this slot? */
  struct inode *filp_ino;	/* pointer to the inode */
  file_pos filp_pos;		/* file position */
}


Linus used "struct file" from the very beginning; unfortunately, if you
grep for filp in 0.01 you'll see a plenty of those - in form of
0.01:fs/file_dev.c:int file_write(struct m_inode * inode, struct file * filp, char * buf, int count)
as well as
0.01:fs/ioctl.c:        struct file * filp;
0.01:fs/ioctl.c:        if (fd >= NR_OPEN || !(filp = current->filp[fd]))
which was both inconsistent *and* resembling hungarian notation just
enough to confuse (note that in the original that 'p' does *NOT* stand for
"pointer" - it's "current IO position").  Unfortunately, it was confusing
enough to stick around; at some point it even leaked into function names
(filp_open(); that one is my fault - sorry for that brainfart).

Let's not propagate that wart any further, please.  If you are opening a file,
put "file" in the identifier.

