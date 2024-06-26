Return-Path: <io-uring+bounces-2356-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA8D9184FE
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 16:56:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53B2FB2AAAF
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 14:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16672188CC6;
	Wed, 26 Jun 2024 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIa6qEx1"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BF0185E56;
	Wed, 26 Jun 2024 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719412551; cv=none; b=lkftixY2k+jZDv8entFMi8Bb9BcjVFEBtTxaeu2Z+5e4/pjYEd6p07ZErthbA9vihVGAHREZk058Vg21uUJNwoP32cR95HgPWiOsPrgMWSc7hAWdWt1L+XTPbCygd86csU3hGwfvCMw3/DEGjpgaVvARHPXtCxqDsJ64F1pHNKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719412551; c=relaxed/simple;
	bh=hSAGlFcDGCBe8j/KBvTOtfot2WD0pgkHaRN4Bt6K8XM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LOi5RoayjEPwvhmtAuCGMdg+i6R1JuvXh99IpyRbpzvu7/1yODrtQN1xg6PEEnUbZ6GbrHY4aCRrpq3UOBaLck121Ha+sJ9iujC8KNCBpGTjdYPnLnZwKznv3RCcfXvpOgFc5OHp/owqM8QObD9wGjes6ztUPJYJoLHXvNkvGLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIa6qEx1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE30C116B1;
	Wed, 26 Jun 2024 14:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719412550;
	bh=hSAGlFcDGCBe8j/KBvTOtfot2WD0pgkHaRN4Bt6K8XM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cIa6qEx16kAoJqXOuMqm/7/SKWYYqrdK5ttvvwc+PEg/TmjtIvoKpsKXnKdRF8dkY
	 2GKoZr7yhuiUp4QaHuKZsTObFc8WXIbdG08idt9UCJgdn44G5YzuaQ5VCNeHjyViOt
	 0o2BkPYYWJ7RCmzCXeKQ5LWtNyDHjy9NlZke2mvPXf6t6BiOUAMBzsdpcEv/j3iLsp
	 vce4zdEZ/58asBJeGkoFeecmSXzi9oibpfaIyoHydawOXumTXJHr2sYs6YAPLuFGkh
	 bOxWHhN3vSdOeFZPXgn20OzRPE4V3ZsDXgt6JdDz4aIH077VvAw99MDhGzBZWY0ZS0
	 jeF9znO5rzVUg==
Date: Wed, 26 Jun 2024 16:35:45 +0200
From: Christian Brauner <brauner@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Xi Ruoyao <xry111@xry111.site>, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	axboe@kernel.dk, torvalds@linux-foundation.org, loongarch@lists.linux.dev
Subject: Re: [PATCH v3] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
Message-ID: <20240626-stehplatz-radius-cbf511594b34@brauner>
References: <20240625151807.620812-1-mjguzik@gmail.com>
 <0763d386dfd0d4b4a28744bac744b5e823144f0b.camel@xry111.site>
 <CAGudoHH4LORQUXp18s8CPPLHQMi=qG9aHsCXTp2cXuT6J9PK6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHH4LORQUXp18s8CPPLHQMi=qG9aHsCXTp2cXuT6J9PK6A@mail.gmail.com>

On Wed, Jun 26, 2024 at 03:39:47PM GMT, Mateusz Guzik wrote:
> On Wed, Jun 26, 2024 at 4:59 AM Xi Ruoyao <xry111@xry111.site> wrote:
> >
> > On Tue, 2024-06-25 at 17:18 +0200, Mateusz Guzik wrote:
> > > +     if ((sx->flags & (AT_EMPTY_PATH | AT_STATX_SYNC_TYPE)) ==
> > > +         (AT_EMPTY_PATH | AT_STATX_SYNC_TYPE) &&
> > > +         vfs_empty_path(sx->dfd, path)) {
> > >               sx->filename = NULL;
> > > -             return ret;
> >
> > AT_STATX_SYNC_TYPE == AT_STATX_FORCE_SYNC | AT_STATX_DONT_SYNC but
> > AT_STATX_FORCE_SYNC and AT_STATX_DONT_SYNC obviously contradicts with
> > each other.  Thus valid uses of statx won't satisfy this condition.
> >
> 
> I don't know wtf I was thinking, this is indeed bogus.
> 
> > And I guess the condition here should be same as the condition in
> > SYSCALL_DEFINE5(statx) or am I wrong?
> >
> 
> That I disagree with. The AUTOMOUNT thing is a glibc-local problem for
> fstatat. Unless if you mean the if should be of similar sort modulo
> the flag. :)
> 
> I am going to fix this up and write a io_uring testcase, then submit a
> v4. Maybe today or tomorrow.

Fwiw, I had already dropped the io_uring bits when I pushed to
#vfs.mount. So just put that as a separate patch on top.

