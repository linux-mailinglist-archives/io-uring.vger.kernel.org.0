Return-Path: <io-uring+bounces-2440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB1389268FF
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 21:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 691521F251DB
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 19:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E9F17A920;
	Wed,  3 Jul 2024 19:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CedaY4tH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079831DA316;
	Wed,  3 Jul 2024 19:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720035218; cv=none; b=ERUKQUJJ/AZkbx1+NNBiNIYiGZ35vXbK8q7buDXyOh+Z5ogDSrr+paWI3dQHKXUlB96CtCcXCw/a6NcPM4F2mSpDSV2aI6xjQTfN/u6TwvFsHwnAABE4ASCyO0md0KzfrOrItUSfPrPFF/H724jY2qAPDNcTPIm7xWTDWw9reCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720035218; c=relaxed/simple;
	bh=LyyAgN3u1D8S7xAav8O5sJ+Q6VhsaMO3FGIELiJKk5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtFijHS0VjCY6T4Txzf7A4GqTj487RiDHKlHfxcCC/XUTzu0EtIzpGks55URbQzRSdd8OeVNM0xflSy6u1prahmDyFN20D6WF5dYpxeP1tkHtYyT0YMnU1brMCQlQmmAFi58WtAmhya2VIDyOkUY23s2hUaxur40iMwoxeCChaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CedaY4tH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE891C2BD10;
	Wed,  3 Jul 2024 19:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720035217;
	bh=LyyAgN3u1D8S7xAav8O5sJ+Q6VhsaMO3FGIELiJKk5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CedaY4tHPiBsu4Pz6KyYbTIefSgNKbgQNU4iTXnMTQTRm3YXIYIc2Kb5HfzByZbVy
	 OdgypwTw0WltNZ0ZvrsZ6JVVEXb8uWEYxWWdqKaMbrfAZWoxqNeoFNOPO3S6asv6WZ
	 vtMRLRHJP3kdfoMxoy80RLhDLp0WTYy705co3xIlUhh2LIYiqxp25uB5oF713ILbU4
	 6bw0cq5SNH5a3lO1rkY5YqZ4ayLqCIbUhXGS3Zsytab5sMDGDqHd82GjZIqbGKu+ub
	 DF8OvHhk68NyfVkPcxl7vSCGOn42RbAO9YzbcoIJQhik+BM4RuqYSn92LbHypgLsdN
	 9PwhP8+qUsYJw==
Date: Wed, 3 Jul 2024 21:33:31 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Xi Ruoyao <xry111@xry111.site>, libc-alpha@sourceware.org, 
	"Andreas K. Huettel" <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	loongarch@lists.linux.dev
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
Message-ID: <20240703-hobel-benachbarten-c475d3eb589b@brauner>
References: <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
 <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
 <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
 <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
 <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com>
 <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
 <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
 <CAHk-=wii3qyMW+Ni=S6=cV=ddoWTX+qEkO6Ooxe0Ef2_rvo+kg@mail.gmail.com>
 <e40b8edeea1d3747fe79a4f9f932ea4a8d891db0.camel@xry111.site>
 <CAHk-=wiJh1egNXJN7AsqpE76D4LCkUQTj+RboO7O=3AFeLGesw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiJh1egNXJN7AsqpE76D4LCkUQTj+RboO7O=3AFeLGesw@mail.gmail.com>

On Wed, Jul 03, 2024 at 12:05:04PM GMT, Linus Torvalds wrote:
> On Wed, 3 Jul 2024 at 11:48, Xi Ruoyao <xry111@xry111.site> wrote:
> >
> > Fortunately LoongArch ILP32 ABI is not finalized yet (there's no 32-bit
> > kernel and 64-bit kernel does not support 32-bit userspace yet) so we
> > can still make it happen to use struct statx as (userspace) struct
> > stat...
> 
> Oh, no problem then. If there are no existing binaries, then yes,
> please do that,
> 
> It avoids the compat issues too.
> 
> I think 'struct statx' is a horrid bloated thing (clearing those extra
> "spare" words is a pain, and yes, the user copy for _regular_ 'stat()'
> already shows up in profiles), but for some new 32-bit platform it's
> definitely worth the pain just to avoid the compat code or new
> structure definitions.

Fwiw, that's why I prefer structs versioned by size which we added clean
handling for via copy_struct_from_user() as in e.g., struct clone_args,
struct mount_setattr, struct mnt_id_req and so on because then you don't
have such problems.

If the struct gets extended 100 times each time adding a 64 bit value
but all the caller cares about is the base information then they can
just pass the first, minimal struct version and be done with it. No need
to reserve any space for unknown future extensions as well.

