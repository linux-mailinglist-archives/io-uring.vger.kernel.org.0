Return-Path: <io-uring+bounces-1854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ECCA8C1E25
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 08:34:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A39611F22BA6
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 06:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839BB56B9C;
	Fri, 10 May 2024 06:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jdyWyMgS"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5105C2940D;
	Fri, 10 May 2024 06:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715322843; cv=none; b=YQlhI39pggUGQYYioV84/+v/ds2kDl1JfRN5Ag7HlpAMmAnNMWgjm92Ge+RAJaWKA5RGwhqmMERnbMnZ+eq3dj7KtAdRwa6BXN0gvxmnKwU8slvRKuAMzr+hFzLHgUpQW3yi0dTX2yrhw/83eOxjgKOg04o7dSKAAW4QuSZvN+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715322843; c=relaxed/simple;
	bh=wVgOOLtVKMV7bsilEbUlznVvVGVC/ysLZc58xE9C6/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0mbDgFSg6hK5z9U7easKBmrJo4UC5L80vOg7hTPDeahY/blLt8v3CmNXr5L6/OkbE8uGlN1pMZwS4w0bBSCjHzFSThIHOJc+SYflkum0S3qoeS7UNZI6piDv9kEEHEHFTnAE9Yv20P3NA8bMy9zsxpv3fbtpBBZH30DBl+DOpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jdyWyMgS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C318BC113CC;
	Fri, 10 May 2024 06:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715322842;
	bh=wVgOOLtVKMV7bsilEbUlznVvVGVC/ysLZc58xE9C6/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jdyWyMgS+v9qUGAFlHih7XgvQwrmsyDQCIOGDIKvOfqMEFtpGPQ0OGCTu8jYydX/R
	 D5aAXl+I3zxvW5NV9UXZpfwVEJ+cUvSc6GFxu267oR/eyntQ+aO7DUNJWJtaGnni47
	 5yiXHQuv2uRwexYJnTqAVm4IxxgkCHS2sX7PBkpAWGQ+xjDDk1Z+FmTypT8l0+3tns
	 YAVR2sp3FWUjEdwhxPam5R0321D2eTUJUx7qVrlAA/Tdugfyfca6c1Ao6f1pHPlIp5
	 zi02q1WopIt+CS92a/E7+wnTqhdrRX2WrjomGr6uAH+TwysbzNY1rm6tT5Ire4VWc9
	 cMw7Z7GkywhrQ==
Date: Fri, 10 May 2024 08:33:54 +0200
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
Message-ID: <20240510-abnehmen-klammheimlich-36242d03b7a0@brauner>
References: <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
 <ZjoKX4nmrRdevyxm@phenom.ffwll.local>
 <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com>
 <CAKMK7uGzhAHHkWj0N33NB3OXMFtNHv7=h=P-bdtYkw=Ja9kwHw@mail.gmail.com>
 <CAHk-=whFyOn4vp7+++MTOd1Y3wgVFxRoVdSuPmN1_b6q_Jjkxg@mail.gmail.com>
 <CAHk-=wixO-fmQYgbGic-BQVUd9RQhwGsF4bGk8ufWDKnRS1v_A@mail.gmail.com>
 <CAHk-=wjmC+coFdA_k6_JODD8_bvad=H4pn4yGREqOTm+eMB+rg@mail.gmail.com>
 <20240509-kutschieren-tacker-c3968b8d3853@brauner>
 <CAHk-=wgKdWwdVUvjSNLL-ne9ezQN=BrwN34Kq38_=9yF8c03uA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgKdWwdVUvjSNLL-ne9ezQN=BrwN34Kq38_=9yF8c03uA@mail.gmail.com>

On Thu, May 09, 2024 at 08:48:20AM -0700, Linus Torvalds wrote:
> On Thu, 9 May 2024 at 04:39, Christian Brauner <brauner@kernel.org> wrote:
> >
> > Not worth it without someone explaining in detail why imho. First pass
> > should be to try and replace kcmp() in scenarios where it's obviously
> > not needed or overkill.
> 
> Ack.
> 
> > I've added a CLASS(fd_raw) in a preliminary patch since we'll need that
> > anyway which means that your comparison patch becomes even simpler imho.
> > I've also added a selftest patch:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs.misc
> 
> LGTM.
> 
> Maybe worth adding an explicit test for "open same file, but two
> separate opens, F_DUPFD_QUERY returns 0? Just to clarify the "it's not
> testing the file on the filesystem for equality, but the file pointer
> itself".

Yep, good point. Added now.

