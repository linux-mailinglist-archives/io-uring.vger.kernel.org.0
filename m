Return-Path: <io-uring+bounces-10515-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F33C4A9A7
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 02:34:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B04633B9939
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 01:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848AE34A795;
	Tue, 11 Nov 2025 01:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Rz1JaZiJ"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2565434A777;
	Tue, 11 Nov 2025 01:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823779; cv=none; b=fHttkBTPR/FSX5VtxpG9w8xjmGZEySK1jU2nBzONDc9xaAPefgVDf0YqSSpZD21eDBjW2nZG/Yw2rkgfotMwuxLd4kwok7Ye8r0Mt4sXUidPXR340JtP+7A1hXOm/UYWDcVCC6dWmy2JnPO+8YIzyilAPmcMrESP1sZHXYer3V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823779; c=relaxed/simple;
	bh=XImp6UKfQMc8nWLP3InWK+vRI+Q+z5Bl+A73Vs5CEEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7oiBUxi8sFp7CF+8TiXOOgAVQcyV58owl8rosSuNpCAJbkBT+etSoIKrTgLiiH8atlhZmUn5OKhOLKLp7Pitpn/RqoUpuPPbz+MQu6K0MO6HvNIdPtAxpvXMXwXsGOqdfq+DnzT1AfqPNOs+1olMGifUvqnlNlb1W+O4rMkvT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Rz1JaZiJ; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KwPHQTrb85GpboWuTxokP9UMdwAPwbBgiUZWHNypQ3w=; b=Rz1JaZiJTnnu+m0OT1p6Lsdd4F
	pVNA1rm3N9h9ByhwiUI3zZaxgDn7TlxjGCJf5ynzy5pVlyvlgqDMFzyLhYYr9siAky52pP76WEgGu
	pYa+CwrK19bzwTt8kH2tRb2doANF0ftVrakit1pfmSFwU08NimGIGDd3Nr/+BQvnOG1rjSPnEj+S2
	3B/7SZX9c+ibKpjmpeXQ6D2ycIiFwhpdPrwAsNSF+G+e+sjl4aMWz9MpoUZvpPsSxZO1JeJwoemO7
	/xwcQbqCWv2SqpCutWsVHVBHAtpXaZCXQEbsi/5+VwCayoAyv/O160aAWBIkdxoyhFM72xhhYVOhz
	axdNbV0A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIczV-00000005F74-3eh0;
	Tue, 11 Nov 2025 01:16:13 +0000
Date: Tue, 11 Nov 2025 01:16:13 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
	mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk,
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
Message-ID: <20251111011613.GO2441659@ZenIV>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk>
 <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
 <20251110051748.GJ2441659@ZenIV>
 <CAHk-=wgBewVovNTK4=O=HNbCZSQZgQMsFjBTq6bNFW2FZJcxnQ@mail.gmail.com>
 <20251110195833.GN2441659@ZenIV>
 <CAHk-=wi3vpw5W6rV6VKxa9PYF3Xwn5_6AT=OwqBWO79g6N1B_A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi3vpw5W6rV6VKxa9PYF3Xwn5_6AT=OwqBWO79g6N1B_A@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Nov 10, 2025 at 12:52:57PM -0800, Linus Torvalds wrote:
> On Mon, 10 Nov 2025 at 11:58, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > If we go that way, do you see any problems with treating
> > osf_{ufs,cdfs}_mount() in the same manner?  Yes, these are pathnames,
> 
> Hmm. In those cases, the ENAMETOOLONG thing actually does make sense -
> exactly because they are pathnames.
> 
> So I think that in those two places using getname() is fairly natural
> and gets us the natural error handling too. No?

Seeing that we don't do that for native mount(2)...  Hell knows -
the thing is, import is done early in syscall, before we know what
does that particular filesystem type expect.  It's not always a pathname
of any sort.

Note that empty string for the first argument of mount(2) is perfectly
fine - for some values of the 5th (flags) and 3rd (type) ones.
So plain getname() is not an option and we do, unfortunately, need the
sucker imported before we start parsing the flags, etc.

I'd love to take security_sb_mount() - it's an utter shitshow of API,
inherently racy, etc., but currently it takes a kernelspace string for
the first argument (dev_name) and is called before we'd even started
to look at flags (so the instances have to essentially duplicate flags
parsing, among other things).

But that's a lot of massage and it will require the LSM crowd acceptance ;-/
If earlier attempts are anything to go by, there will be a lot of
resistance.

BTW, take a look at apparmor_sb_mount() and aa_bind_mount().  Compare
the calls of kern_path() in aa_bind_mount() and in do_loopback() and
note that the damn thing relies upon both pathwalks resolving to the
same location...

