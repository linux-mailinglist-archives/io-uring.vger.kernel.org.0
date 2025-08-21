Return-Path: <io-uring+bounces-9154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57334B2F00B
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 09:47:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2625116DB30
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 07:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A70E2741C9;
	Thu, 21 Aug 2025 07:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RilZfr5U"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17CF19F135;
	Thu, 21 Aug 2025 07:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755762466; cv=none; b=fIS5h3DcFVb7ZRQBSMYg/ehGXfb62tWJMjD3qmo6skFjEILeovRmQylhDX7vaVsutqKc77aVUZQa4AfkznNrfCPQMNFFgfrMX3gbYpZhMrrxrlnyojc5tsFYaryXRzuedUVKLw3G07Cch9Kk4efqD+3DlZoqyA4ZXCZz35EJ+Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755762466; c=relaxed/simple;
	bh=eEvFGmHk4o/xiRTP7rYXNelXLR+78ohx+6Uf3/9nIYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f88abJLM203a+vR+XHj1FQhUO5TsqXvvz6KP6qxHh8ocE+VbbKRc3BHt3zPwdZ7c1gV7cjXE+q5eTy0CJDhQFHSKHRPYyDyBDsPyIpNsOL4JkOlsQtkFDsiq2UDvd2qfA7NXb72E4YrQPTAHK9VFGtAXpCCOK5zSSvwUQxXgURs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RilZfr5U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9B2C19421;
	Thu, 21 Aug 2025 07:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755762465;
	bh=eEvFGmHk4o/xiRTP7rYXNelXLR+78ohx+6Uf3/9nIYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RilZfr5UKaSKIoAFq/Q157n2pcqvRnrUDTnYbKIu9RjOm7/SlxZ3dO2UgCSb9ECGM
	 pKBmVy8XWH6MggyREIF02kmb88faATfH0pVt8dWztV++pjuWxViirYSwJqwMAJFQ47
	 wfZkJ08cwLrT67YgeJUkjHOnTv4KZWg6XRSUdl/oSPgFTi8qfnZ4hSrWzMet5qQacX
	 HkAN1wRxypLP4OrU7Rroc3tvV9Dz0FMyWhs51vl7YVV21GSbstBHSXAOZUEnVw7wnd
	 kKGq5La0JjnUuKPlJ0x6DMknEwhdYAd6TEMdqn98M/uOWSgZG6v2cdSCrbAdT6UCyz
	 x/h7h1YLieLqg==
Date: Thu, 21 Aug 2025 09:47:41 +0200
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org
Subject: Re: [PATCHSET RFC 0/6] add support for name_to, open_by_handle_at(2)
 to io_uring
Message-ID: <20250821-putzig-bockig-ad93ba46e12e@brauner>
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
 <e914d653-a1b6-477d-8afa-0680a703d68f@kernel.dk>
 <DC6X58YNOC3F.BPB6J0245QTL@gmail.com>
 <CAOQ4uxj=XOFqHBmYY1aBFAnJtSkxzSyPu5G3xP1rx=ZfPfe-kg@mail.gmail.com>
 <DC7CIXI2T3FD.1I8C9PE5V0TRI@gmail.com>
 <CAOQ4uximiUryMV=z_3TrEN1KCSA-2YdCt0t7v1M1gRZpnWec=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uximiUryMV=z_3TrEN1KCSA-2YdCt0t7v1M1gRZpnWec=Q@mail.gmail.com>

On Wed, Aug 20, 2025 at 09:58:15PM +0200, Amir Goldstein wrote:
> On Wed, Aug 20, 2025 at 5:00 PM Thomas Bertschinger
> <tahbertschinger@gmail.com> wrote:
> >
> > On Wed Aug 20, 2025 at 2:34 AM MDT, Amir Goldstein wrote:
> > > On Wed, Aug 20, 2025 at 4:57 AM Thomas Bertschinger
> > > <tahbertschinger@gmail.com> wrote:
> > >> Any thoughts on that? This seemed to me like there wasn't an obvious
> > >> easy solution, hence why I just didn't attempt it at all in v1.
> > >> Maybe I'm missing something, though.
> > >>
> > >
> > > Since FILEID_IS_CONNECTABLE, we started using the high 16 bits of
> > > fh_type for FILEID_USER_FLAGS, since fs is not likely expecting a fh_type
> > > beyond 0xff (Documentation/filesystems/nfs/exporting.rst):
> > > "A filehandle fragment consists of an array of 1 or more 4byte words,
> > > together with a one byte "type"."
> > >
> > > The name FILEID_USER_FLAGS may be a bit misleading - it was
> > > never the intention for users to manipulate those flags, although they
> > > certainly can and there is no real harm in that.
> > >
> > > These flags are used in the syscall interface only, but
> > > ->fh_to_{dentry,parent}() function signature also take an int fh_flags
> > > argument, so we can use that to express the non-blocking request.
> > >
> > > Untested patch follows (easier than explaining):
> >
> > Ah, that makes sense and makes this seem feasible. Thanks for pointing
> > that out!
> >
> > It also seems that each FS could opt in to this with a new EXPORT_OP
> > flag so that the FSes that want to support this can be updated
> > individually. Then, updating most or every exportable FS isn't a
> > requirement for this.
> 
> Makes a lot of sense. yes.
> 
> >
> > Do you have an opinion on that, versus expecting every ->fh_to_dentry()
> > implementation to respect the new flag?
> 
> Technically, you do not need every fs to respect this flag, you only need them
> to not ignore it.
> 
> Generally, if you pass (fileid_type | EXPORT_FH_CACHED) as the type
> argument, most filesystems will not accept this value anyway and return
> NULL or PTR_ERR(-ESTALE), so not ignoring.
> 
> But I think it is much preferred to check the opt-in EXPORT_OP
> flag and return EAGAIN from generic code in the case that fs does
> not support non-blocking decode.
> 
> And fs that do opt in should probably return PTR_ERR(-EAGAIN)
> when the file type is correct but non-blocking decode is not possible.

I like your idea as it's in line with other extensions we've done
recently to open_by_handle_at().

