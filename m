Return-Path: <io-uring+bounces-1734-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C30AE8BB6DB
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 00:08:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFAC3B214C8
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 22:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA90558ADD;
	Fri,  3 May 2024 22:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="THwtsig7"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14332537E9;
	Fri,  3 May 2024 22:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714774075; cv=none; b=RjQiPjpRWt+6e53oQ+9DtBfGrsABGT39gBrn8XoUqJFMi/mx+EOLDlEwCVpvAaTD9wYOGlI2Goe+3oycuwhUzsOsGrcOCE9uEwa3cF8FNYuPBcVZ6MgnT8UQ8wwlrX9gUbelHsBDUDEaUUr3/wZ4zkbK9Ew39tYv1KbvznpDIy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714774075; c=relaxed/simple;
	bh=E6hdO7SCZY8q59Do/GPMTxkc90wKH/Eit3OmFw/NAvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RaqSs0BlTbCNy3by+zUyUT/s5KdOpoXsFT4oCgNH6Mim8l2+efAWDRESo6wOKca0BY0XcNx4uVFLr8hDyai8MwhC8PcyvuM7Jtlvkf/nS6BsusBUmFcmUtBRCVk/jYtSSodsp3WloBSN8WE4LtCaGB/EHOOkp5M7997+4BHvFEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=THwtsig7; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9IJ94F6D0hpL++k4cqV+mmpX37sPSJD4rkpmP5mQjAo=; b=THwtsig7+WAGUxhmJpiJpR9PpS
	dM05ePoKzCIBs8+7lHyp2MYwmUH+LkQoxFyS7J8MCf3nIVV6rhZHD+yoHk0cBUbKkW/VwL9wGwSlH
	FIiDgOtzJmmMBhSn+6zSf5+4VLvUrVDD1OA1Xvwarz4ztGra7C11jwxp9soa7j9BITqTMU01S/hN9
	bHOKJmd/37v/eZ5fAcBjKRLO3qSZI7TUi41kh6kFaPjPKQDwUBIJ0vhiYAKp3NVN7RHtNTas5JdV4
	xLWmh4Pxfnvbotxd93o72B8taYfTfsq9oNE8cs24NFEfZi6QMXsVXGTFetDToWXKjyc9lEN+MyX+L
	aeB8WzRQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1s314C-00BAkU-39;
	Fri, 03 May 2024 22:07:45 +0000
Date: Fri, 3 May 2024 23:07:44 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keescook@chromium.org, axboe@kernel.dk, brauner@kernel.org,
	christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name,
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	minhquangbui99@gmail.com, sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240503220744.GE2118490@ZenIV>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240503214531.GB2118490@ZenIV>
 <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
 <20240503220145.GD2118490@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503220145.GD2118490@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, May 03, 2024 at 11:01:45PM +0100, Al Viro wrote:

> Having ->poll() instance itself grab reference is really asking for problem,
> even on the boxen that have CONFIG_EPOLL turned off.  select(2) is enough;
> it will take care of references grabbed by __pollwait(), but it doesn't
> know anything about the references driver has stashed hell knows where for
> hell knows how long.

Suppose your program calls select() on a pipe and dmabuf, sees data to be read
from pipe, reads it, closes both pipe and dmabuf and exits.

Would you expect that dmabuf file would stick around for hell knows how long
after that?  I would certainly be very surprised by running into that...

