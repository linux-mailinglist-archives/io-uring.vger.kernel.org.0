Return-Path: <io-uring+bounces-1840-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC9778C0EEC
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 13:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64BE1B2117A
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 11:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FE313172D;
	Thu,  9 May 2024 11:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b6oJLrKg"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2FE13172A;
	Thu,  9 May 2024 11:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715254740; cv=none; b=uYETSHc9rDQvRAGBPG/o40TiMZYqmgct1PPk0rHL8Rt8YRWH04ega2ewlHAv38r0ytSpKFTrRnOORkBt5uEQNwFQoqeLCseZR35x91mmUTmDpNziPXkD8LKtyu9UKVzStRvm/QtEtYd0EiReaHQfn4MaOkpbz7VELXJfKYx32sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715254740; c=relaxed/simple;
	bh=ziw08gHcd8mjdUarjJlC5MxDSSrwq+SNZaIBS6tHOrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ffRKvGTVlcCsQiihZM2sSUHmCNytRGVi39D9cO/+PgivZBPyhFawMCEvcPSLiEX4bsi0ARjGRa+SaNhDH/ztQLOpXOJxzdSz4mKuYft2TidT8VQnZjWLOHZXXQX1vRXYIrZTK17Qp4Z2QRjlh7rzcfoR9RpIfeqT+lerMLK1D4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b6oJLrKg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E980C116B1;
	Thu,  9 May 2024 11:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715254740;
	bh=ziw08gHcd8mjdUarjJlC5MxDSSrwq+SNZaIBS6tHOrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b6oJLrKgWptVKfS1b1DJld2kF473qcRQlYA9NcglxVQ3muP9XFveN76SPmN4h0W/q
	 NtuRMy302BNatpVrMjzy+J4i2PGajKdd8X7yLnVS5aPgyB9cB3k2SQlym7AmJBtxVJ
	 KwZKFNH1145vKFZGaBVPfwBsQtQqbJPwX0vrIbL1M6b9L/9vg3XpgjB5Ecpu6Wn0qs
	 n5S+yKpK5ZdFiq8Ms5VkVDikYeWo+2/jla9RqHZA9C3ODKbkhq6tc8y2/ZU9HpzQBU
	 MAP4RUarW1r2oACdn0WMre9CPv0H5pS1yjNETR0xZt45kIBnasjBrwt5ML1ySGfTnS
	 S7pDSxU6Dq/eA==
Date: Thu, 9 May 2024 13:38:52 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Simon Ser <contact@emersion.fr>, 
	Pekka Paalanen <pekka.paalanen@collabora.com>, 
	Christian =?utf-8?B?S8O2bmln?= <ckoenig.leichtzumerken@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better
 about file lifetimes
Message-ID: <20240509-kutschieren-tacker-c3968b8d3853@brauner>
References: <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
 <ZjoKX4nmrRdevyxm@phenom.ffwll.local>
 <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com>
 <CAKMK7uGzhAHHkWj0N33NB3OXMFtNHv7=h=P-bdtYkw=Ja9kwHw@mail.gmail.com>
 <CAHk-=whFyOn4vp7+++MTOd1Y3wgVFxRoVdSuPmN1_b6q_Jjkxg@mail.gmail.com>
 <CAHk-=wixO-fmQYgbGic-BQVUd9RQhwGsF4bGk8ufWDKnRS1v_A@mail.gmail.com>
 <CAHk-=wjmC+coFdA_k6_JODD8_bvad=H4pn4yGREqOTm+eMB+rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wjmC+coFdA_k6_JODD8_bvad=H4pn4yGREqOTm+eMB+rg@mail.gmail.com>

On Wed, May 08, 2024 at 10:14:44AM -0700, Linus Torvalds wrote:
> On Wed, 8 May 2024 at 09:19, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So since we already have two versions of F_DUPFD (the other being
> > F_DUPFD_CLOEXEC) I decided that the best thing to do is to just extend
> > on that existing naming pattern, and called it F_DUPFD_QUERY instead.
> >
> > I'm not married to the name, so if somebody hates it, feel free to
> > argue otherwise.
> 
> Side note: with this patch, doing
> 
>    ret = fcntl(fd1, F_DUPFD_QUERY, fd2);
> 
> will result in:
> 
>  -1 (EBADF): 'fd1' is not a valid file descriptor
>  -1 (EINVAL): old kernel that doesn't support F_DUPFD_QUERY
>  0: fd2 does not refer to the same file as fd1
>  1: fd2 is the same 'struct file' as fd1
> 
> and it might be worth noting a couple of things here:
> 
>  (a) fd2 being an invalid file descriptor does not cause EBADF, it
> just causes "does not match".
> 
>  (b) we *could* use more bits for more equality
> 
> IOW, it would possibly make sense to extend the 0/1 result to be
> 
> - bit #0: same file pointer
> - bit #1: same path
> - bit #2: same dentry
> - bit #3: same inode
> 
> which are all different levels of "sameness".

Not worth it without someone explaining in detail why imho. First pass
should be to try and replace kcmp() in scenarios where it's obviously
not needed or overkill.

I've added a CLASS(fd_raw) in a preliminary patch since we'll need that
anyway which means that your comparison patch becomes even simpler imho.
I've also added a selftest patch:

https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs.misc

?

