Return-Path: <io-uring+bounces-9622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26716B46EDA
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 15:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCDAB167541
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 13:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF40729D27E;
	Sat,  6 Sep 2025 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V14Xsm78"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9EC283FE0;
	Sat,  6 Sep 2025 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757166698; cv=none; b=HZNuQBvwI79KcBQbq4rv5Acj4c5uowilufC/5VXvnhnkgUB9bwYATTGOaCjAZ1wbb3MIp7BV8LVcjkbOL9f70Nis5FQswhEMFaU21+Ds2pnnC8HV++3WR1z3ZVLy+UlZRnKakHlF932XbVbb5Ihbze/CxyMBdfmrDLQa/FLhbdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757166698; c=relaxed/simple;
	bh=UsOZU8x6O2j2h5+PWtcrTLOL5O/0Xuhq8HGu99szL/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7TKmDC2rqyaw/flE9egEOlSl8zDUkLMpn7NcdD1D88tWPdmglD1Gf8AU6jf/G/zLVgiJ2WXOVZ+h9W13Gyv+fTcPRUSsNGObsDGb8QTDsZAbhBjKxDXPilZcUskCLl5M02L+bBMgaKTa1a14I8J8qfkKjncq0j+H79Pg5kbn2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V14Xsm78; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B758C4CEE7;
	Sat,  6 Sep 2025 13:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757166698;
	bh=UsOZU8x6O2j2h5+PWtcrTLOL5O/0Xuhq8HGu99szL/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V14Xsm78AIYPaG5nNZJINK5Ut0IJrPPvYhONtdGHlXvzGn/1X38WoUMEn98R+qhyR
	 yeX+HONE8axL+L/wiedgaxZKqeYOPepoimgdK6UoWzwFUyyVlGKrrPVAULGiXRmDhX
	 DsxJFth6hWtVpooaVVReH8LJeaU+ZueIhrcPZIp0=
Date: Sat, 6 Sep 2025 09:51:33 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Jens Axboe <axboe@kernel.dk>, Caleb Sander Mateos <csander@purestorage.com>, 
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <20250906-almond-tench-of-aurora-3431ee@lemur>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
 <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <2025090614-busily-upright-444d@gregkh>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2025090614-busily-upright-444d@gregkh>

On Sat, Sep 06, 2025 at 01:27:04PM +0200, Greg KH wrote:
> > Obviously, we don't want to use the cover letter as-is, which is why b4 will
> > open the configured editor to let the maintainer pulling in the series make
> > any changes to the cover letter before it becomes the merge commit.
> 
> I like this a lot, and just tried it, but it ends up applying the
> patches from the list without my signed-off-by, which will cause
> linux-next to complain when it sees that I committed patches without
> that.
> 
> Did I miss an option to `b4 shazam`?  Does it need to add a -s option
> like `b4 am` has?

Yes, most of the time you'll want to run it as `b4 shazam -Ms`.

Unfortunately, `shazam -M` is not perfect, because we do need to know the
base-commit, and there's still way too many series sent without this info. We
do some magic trying to figure out where the series might belong (basically,
by comparing blob hashes and trying to find the tree with the same set of blob
hashes as in the patch), but it only works if you have the same local repo as
the contributor.

Best regards,
-K

