Return-Path: <io-uring+bounces-10534-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A19C515A1
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 10:28:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3511189BB0F
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 09:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792AA2F998D;
	Wed, 12 Nov 2025 09:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTK7B/Kx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9AA2C0262;
	Wed, 12 Nov 2025 09:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939622; cv=none; b=Noi3PxLXgUoNieueP41eQ90sBl8mI0VHx/eqU6o5ck9RhXes23c+7lLq2u4J/0+wl5YwwuRRpeZJD6wnGp8i8zOhByqt/kmVS79WvVEvPfOIG5KUfjQ+akbF97WU1GM0RTl3AUmg/1uGGvBJRtj3Q0q54zO226pcdCPW2iNwtL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939622; c=relaxed/simple;
	bh=tzj3k6L3b4wtUUGs2kY8wMsmgxCApPIQYNMfJWD2J+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+f7apY3NrbFcIgrefpgA3dvSNiZ2Be0PWTGMhfBRyEQcNSpfNgsSwLq0IdyLVnYn6Oo4CGDrojRyDRZRsEh3vWjFApGTV9X8ICBlc8KBWBCKWnFF1BwBcbNJUwRy0u4pMENSgV6m9YGRlwKsKXeOYz3MEpaF1LVcNtdf5L+CYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aTK7B/Kx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEFFC19423;
	Wed, 12 Nov 2025 09:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762939621;
	bh=tzj3k6L3b4wtUUGs2kY8wMsmgxCApPIQYNMfJWD2J+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aTK7B/Kx5Eli+wyOD3suTessJcs4rf+yTWEZ++vJtNHAcAg6yxtbYL9hR96MF5bgz
	 wfxV2wIYNdpd5gEseFk9ubxg00l8S6vO4hrBFATt5wGZ/y6S57cHqqi09j1KN662ua
	 +DNpDzpz6IbsrmmwGsiNCPxfbZJ+Gg2gb3QAuo57AIm2ZC63D4U3FlRBGywTo3NKtn
	 WKgeft3sXG0bUqW4WfLlbfiaBdHjA1HJhiExdCoSwGvlR/ohHLc+DX7DdeSBkfWYuN
	 5uCcBHoueZus3VJEtVAg5bQJuBtC4huAx0WE/IkfjRmigblelXz2WcCfOWU8aGeNNA
	 +1ZJMikl95tQg==
Date: Wed, 12 Nov 2025 10:26:57 +0100
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
Message-ID: <20251112-warzen-zusichern-8aa56fe3a744@brauner>
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk>
 <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAHk-=wjA=iXRyu1-ABST43vdT60Md9zpQDJ4Kg14V3f_2Bf+BA@mail.gmail.com>
 <20251110051748.GJ2441659@ZenIV>
 <CAHk-=wgBewVovNTK4=O=HNbCZSQZgQMsFjBTq6bNFW2FZJcxnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgBewVovNTK4=O=HNbCZSQZgQMsFjBTq6bNFW2FZJcxnQ@mail.gmail.com>

On Mon, Nov 10, 2025 at 08:41:45AM -0800, Linus Torvalds wrote:
> On Sun, 9 Nov 2025 at 21:17, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > That's more about weird callers of getname(), but...
> >
> > #ifdef CONFIG_SYSFS_SYSCALL
> > static int fs_index(const char __user * __name)
> > {
> >         struct file_system_type * tmp;
> >         struct filename *name;
> >         int err, index;
> >
> >         name = getname(__name);
> 
> Yeah, ok, this is certainly a somewhat unusual pattern in that "name"
> here is not a pathname, but at the same time I can't fault this code
> for using a convenient function for "allocate and copy a string from
> user space".
> 
> > Yes, really - echo $((`sed -ne "/.\<$1$/=" </proc/filesystems` - 1))
> > apparently does deserve a syscall.  Multiplexor, as well (other
> > subfunctions are about as hard to implement in userland)...
> 
> I think those are all "crazy legacy from back in the dark ages when we
> thought iBCS2 was a goal".
> 
> I doubt anybody uses that 'sysfs()' system call, and it's behind the
> SYSFS_SYSCALL config variable that was finally made "default n" this
> year, but has actually had a help-message that called it obsolete
> since at least 2014.
> 
> The code predates not just git, but the bitkeeper history too - and
> we've long since removed all the actual iBCS2 code (see for example
> commit 612a95b4e053: "x86: remove iBCS support", which removed some
> binfmt left-overs - back in 2008).
> 
> > IMO things like "xfs" or "ceph" don't look like pathnames - if
> > anything, we ought to use copy_mount_string() for consistency with
> > mount(2)...
> 
> Oh, absolutely not.
> 
> But that code certainly could just do strndup_user(). That's the
> normal thing for "get a string from user space" these days, but it
> didn't historically exist..
> 
> That said, I think that code will  just get removed, so it's not even
> worth worrying about. I don't think anybody even *noticed* that we
> made it "default n" after all these years.

Nobody noticed at all when I flipped the switch earlier this year. I
explicitly dit it to prepare for removal of the sysfs() system call so
I'm happy to pull the trigger any time!

https://lore.kernel.org/all/20250415-dezimieren-wertpapier-9fd18a211a41@brauner

