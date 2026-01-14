Return-Path: <io-uring+bounces-11703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B22B0D1F7E7
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 15:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 61D56301896F
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 14:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC822D8382;
	Wed, 14 Jan 2026 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="f3bGrPVr"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A361722B5A5;
	Wed, 14 Jan 2026 14:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768401272; cv=none; b=lldvE1sCGhjB98DbqKDgLcwijzOJw8NyOGCma7vdlOO+0ZOa3W824lfnwaWWhudgwLBQl6J0VE8DcubnoIyu1aD3HFVlJGOPiFahak9AhtVFaVOgRYSOzqQjuuXWogXD4Vtp+p95/sTCoITXwnDf+i/qM7ieHNHMaIHkTkivjH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768401272; c=relaxed/simple;
	bh=ZQCFuaMuCZ3Fu7pNmusE4ZOKXKRidmsWIk+RMzHZ0b0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Su8UQ0gTUoPMMRqre8y75zRwvbjGclAbeT7tqeLF7d3MqlX5vIWna9QajuT+ZGzvyxH7khz4WmmWhqZIy1Oa2ODWzS9IP8OhB1AKOLQCFIETy8qZFYXR0aaRpS/frtxkf1zPZkrEuIme/Zr1tyCwmiH7x8bffvu3BxxzteecZ84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=f3bGrPVr; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JxQTzize1ybaWGG7/nlCFJTtSbJaJEnLC2I8YdrbeGg=; b=f3bGrPVrmYamelS0/7LRAc7CXk
	v28l1qrBt9urctNj/Np9fcuZ3dA1gdP/pOTbWAKzlF7Xv+E+N61qE9Hg1b60SW4kfKTi+88KGAyJy
	Fsd1NuOpb3EYmYdSlS0CKZV4UkUgg5ogKMVZWEjHRrDGR66ZYlZVqJuEo0Bl4fj9l0H6xfE0XJoCo
	T7bYZtyPIguza0GYdpzPbbivC6U+4gWAhQPVz+T03QW43e2+FyHlDGWzEW3cfGYn/JgM6dAC3UmZc
	5/j1XgUddqn6oeqGGv1esdPCOUB1UwCJFyHBPqxj9PHHzpUYXbmovM3Lp/gYGOcjNgBhZBnxV3XyU
	jeNBWzUA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vg1yV-0000000HZwl-30yI;
	Wed, 14 Jan 2026 14:35:55 +0000
Date: Wed, 14 Jan 2026 14:35:55 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>, Paul Moore <paul@paul-moore.com>,
	Jens Axboe <axboe@kernel.dk>, audit@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 68/68] sysfs(2): fs_index() argument is _not_ a
 pathname
Message-ID: <20260114143555.GV3634291@ZenIV>
References: <20260114043310.3885463-1-viro@zeniv.linux.org.uk>
 <20260114043310.3885463-69-viro@zeniv.linux.org.uk>
 <20260114104155.708180fc@pumpkin>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114104155.708180fc@pumpkin>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Jan 14, 2026 at 10:41:55AM +0000, David Laight wrote:
> On Wed, 14 Jan 2026 04:33:10 +0000
> Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> > ... it's a filesystem type name.
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> >  fs/filesystems.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/filesystems.c b/fs/filesystems.c
> > index 95e5256821a5..0c7d2b7ac26c 100644
> > --- a/fs/filesystems.c
> > +++ b/fs/filesystems.c
> > @@ -132,24 +132,21 @@ EXPORT_SYMBOL(unregister_filesystem);
> >  static int fs_index(const char __user * __name)
> >  {
> >  	struct file_system_type * tmp;
> > -	struct filename *name;
> > +	char *name __free(kfree) = strndup_user(__name, PATH_MAX);
> >  	int err, index;
> >  
> > -	name = getname(__name);
> > -	err = PTR_ERR(name);
> >  	if (IS_ERR(name))
> > -		return err;
> > +		return PTR_ERR(name);
> 
> Doesn't that end up calling kfree(name) and the check in kfree() doesn't
> seem to exclude error values.

include/linux/slab.h:523:DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))

kfree() the function won't be even called in that case...

