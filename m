Return-Path: <io-uring+bounces-10491-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9EB1C450E0
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 07:06:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D2AE3B059B
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 06:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31EA01DF723;
	Mon, 10 Nov 2025 06:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="FBdtnYVe"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C63219AD90;
	Mon, 10 Nov 2025 06:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762754759; cv=none; b=AuKMTfsRoEzt0bRp/pVTc41bUNm6apjgC9EJAu0zdG02V3whO+MEtba/hUqSiSpUd12rZg6PRe4O6UbjDyt9gwe2tU8Q3uV2cJf1AWZV0a0oS2yL+nC+Pb0TFlSPGkbaviR8mdQI4CufibqHk43nKiWzw7Fomrfr4EsQrQY3lsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762754759; c=relaxed/simple;
	bh=5hnuQwBoDMeAHYrHm0TeQwnfrEuCUFn1bu1+/rj82/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jw+geZ5nXArAlUy0EU+HNdiAnhgpld5wpRqyYFdMyWG6afeL5JBsilBTo0MWtHjeZpbSrTqKg/P7D3kwpnqZH0nMquzF6OZS/Cx38UuhBn4rD9jhQedyKZitrD4jlyH2iq16922SaX/gTUNyhScyOc/m/aZscOmn+lcvFl7nFso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=FBdtnYVe; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gZvO8hZQKtdAilCuux15vtrxVL+SygmqYUJhjJXxGE4=; b=FBdtnYVeLcH2rZuYO3IBfAaPCG
	vfYO5AmY5jvlcep+xflDzxNZptN+uomZhbUGqGd/UAebs2Kt+phCnBDwJ/qbPZFkEz0OGM4CHPEZQ
	3Jiy33yNb26EBOY/bbCWtCYnOJIze2MzDGZuh5BVhjT5/EEmPxWrECLFSOe5YdmkM4a3bt8m3Sfob
	lkxWDpuoP2Tm70J2uFJBpCmABTO4ZURgrOtjwJ/JtwiwzLbyigrnZ3scgGbc6HC9Mw2VF66C3HHfd
	Av4XosgDaSpt5P691Y4JPFGwErcRmPCQ4lhRiaFuqE7EIqgDyrcD/ro1xa6dWwqrpIyAMvgDpuOjP
	7zcR76hA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIL2I-00000000B4f-17Uz;
	Mon, 10 Nov 2025 06:05:54 +0000
Date: Mon, 10 Nov 2025 06:05:54 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk,
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
Message-ID: <20251110060554.GK2441659@ZenIV>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk>
 <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Nov 09, 2025 at 02:18:04PM -0800, Linus Torvalds wrote:
> On Sun, 9 Nov 2025 at 11:18, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Hmm? Comments?
> 
> Oh, and while double-checking bad users, I note that ntfs3 does
> 
>         uni = kmem_cache_alloc(names_cachep, GFP_NOWAIT);
> ...
>         kmem_cache_free(names_cachep, uni);
> 
> which is all complete and utter bogosity. I have no idea why anybody
> ever thought that was acceptable. It's garbage.

	So's ntfs_d_compare() right next to it - and there they *still*
hadn't bothered with non-blocking allocation while under ->d_lock and
rcu_read_lock()...

