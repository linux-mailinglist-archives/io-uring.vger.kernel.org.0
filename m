Return-Path: <io-uring+bounces-2434-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 951DE92685B
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 20:39:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54CBF28F4C3
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 18:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35298180A99;
	Wed,  3 Jul 2024 18:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzOXONpn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ABE1DA313;
	Wed,  3 Jul 2024 18:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720031987; cv=none; b=PqB/VqA/8CR5DJ1QJUctEUC8qQi4iuX+o+1veSjAU9+qK4DIXJPJxRWvgOe4LUxkUX+DaMVkB/l83vUNou1zy2G5R3sGCNNmVXenHMOXjMblIXLPR9va/PdXJVCm7pe2XiyGh+DgmtbmaE6W3vDyZXZSh54DsL78tDl4vjhFcho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720031987; c=relaxed/simple;
	bh=ejwNsfavbbibHuM6+4Aoodi8uXxLq1+tHWb1BLL3xp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhfGUkMZlVM4nqa+rE5NwpoAoGuYMW53NzdFvIg2r8LlpfCW6n4AIe5epOhBWnnFJpR43vDpommcWKmshf7KJssXU2O9RYRsM1sj1rpotIAWGTaByVSFYapM1k+YlHb3q1nK5MK5SCZ44ueyyF2FnRgnjbAkO0ySXXpK76SFDCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BzOXONpn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07893C2BD10;
	Wed,  3 Jul 2024 18:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720031986;
	bh=ejwNsfavbbibHuM6+4Aoodi8uXxLq1+tHWb1BLL3xp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BzOXONpnwzAdkOCUuIYyptRBW+BNttayZXybFSt6HZk8NFgu08CyVHX5LkcNLSq0X
	 WVoLWkr4aZ2ppEzY9JyGWZNu4+REqVMmT2WEzPE6OlMNbxTOgDBDiZQ2eGyJzDyPF3
	 HrgH/uqvWEpXa9rGTl9skW6YUuqzNa3ccBrRyLDi1bBZjmpdPInf2LTzFfxE7oMAJ2
	 itIWEeTyvSH1sUZRCoW1XnCPtMJyHXJC25gFel3VfiwX3QshKfMP4S9lq1p9WZSKtg
	 6At8txdSFtRiS017wXzVNeiZy5eVWI1/o24vpmfXiwdZGTQQwmIJmfpITMyhxXdU/m
	 7WwRBNzCDITxQ==
Date: Wed, 3 Jul 2024 20:39:39 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xi Ruoyao <xry111@xry111.site>, libc-alpha@sourceware.org, 
	"Andreas K. Huettel" <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	loongarch@lists.linux.dev
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
Message-ID: <20240703-zusagen-allzu-214f7651ecfd@brauner>
References: <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
 <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
 <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
 <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
 <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com>
 <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
 <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
 <CAHk-=wii3qyMW+Ni=S6=cV=ddoWTX+qEkO6Ooxe0Ef2_rvo+kg@mail.gmail.com>
 <20240703-begossen-extrem-6ed55a165113@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240703-begossen-extrem-6ed55a165113@brauner>

On Wed, Jul 03, 2024 at 08:14:15PM GMT, Christian Brauner wrote:
> On Wed, Jul 03, 2024 at 10:54:53AM GMT, Linus Torvalds wrote:
> > On Wed, 3 Jul 2024 at 10:40, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > Oh wow. Shows just *how* long ago that was - and how long ago I looked
> > > at 32-bit code. Because clearly, I was wrong.
> > 
> > Ok, so clearly any *new* 32-bit architecture should use 'struct statx'
> > as 'struct stat', and at least avoid the conversion pain.
> > 
> > Of course, if using <asm-generic/stat.h> like loongarch does, that is
> > very much not what happens. You get those old models with just 'long'.
> > 
> > So any architecture that didn't do that 'stat == statx' and has
> > binaries with old stat models should just continue to have them.
> > 
> > It's not like we can get rid of the kernel side code for that all _anyway_.
> 
> Fwiw, the original motivation for that whole "let's do NULL with
> AT_EMPTY_PATH" (somewhat independent from the generic use of it) that
> somehow morphed into this discussion was that the Chrome Sandbox has
> rewrites fstatat() system calls to fstat() via SECCOMP_RET_TRAP:
> 
>   if (args.nr == __NR_fstatat_default) {
>     if (*reinterpret_cast<const char*>(args.args[1]) == '\0' &&
>         args.args[3] == static_cast<uint64_t>(AT_EMPTY_PATH)) {
>       return syscall(__NR_fstat_default, static_cast<int>(args.args[0]),
>                      reinterpret_cast<default_stat_struct*>(args.args[2]));
>     }
> 
> while also disabling statx() completely because they can't (easily)
> rewrite it and don't want to allow it unless we have NULL for
> AT_EMPTY_PATH (which we'll have soon ofc).
> 
> In any case in [1] I proposed they add back fstat()/fstatat64() which
> should get that problem solved because they can rewrite that thing.
> 
> In any case, which one of these does a new architecture have to add for
> reasonable backward compatibility:

Going by riscv added in 2017 it would be:

newstat()
newlstat()
newfstat()
newfstatat()
statx()

> 
> fstat()
> fstat64()
> fstatat64()
> 
> lstat()
> lstat64()
> 
> stat()
> stat64()
> statx()
> 
> newstat()
> newlstat()
> newfstat()
> newfstatat()
> 
> Because really that's a complete mess and we have all sorts of overflow
> issues and odd failures in the varioius variants. And the userspace
> ifdefery in libcs is just as bad if not very much worse.
> 
> [1]: https://lore.kernel.org/lkml/20240226-altmodisch-gedeutet-91c5ba2f6071@brauner

