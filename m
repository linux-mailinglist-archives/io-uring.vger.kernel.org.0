Return-Path: <io-uring+bounces-9662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE7EB4FC36
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 15:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 827611BC205A
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 13:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F9F2857DE;
	Tue,  9 Sep 2025 13:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1L1RwJC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA5A21B9F6;
	Tue,  9 Sep 2025 13:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757423842; cv=none; b=sDh86awGtBctHFGGo2I/1nLRhOVMci1EOvOLtP9qozKsb1xQi2TmsoJ/Zj1ViJbSDOUG+lrEzUUcAcjNM7d/zX8RQwglcHJC6xPCf1h6Mt+lzeuHLWDnkYnO5YJ9Z07KXf/oOPOvW6eFhhhLXcfY8/EjtWGw2++eipI0Pr9tSCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757423842; c=relaxed/simple;
	bh=hRxld0LQgbxPOlzudrdWuevDjVRV7o89tn8SOw9Mu7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8aIpdmWjKuIu81Izu1H02RpfMkGq15TLeOr8pwMg//RzSDBbgACITsfMgtQe5MqKWoVJGXddkQhAt7sIpncNPv44ueSdZz8w1VPK9/kk0BdQfEHUYiJBKGk6K2nf5oPznjsd5vkA6jOZWGSUfNOspHV6lJXtEKtwgeDk+mv5dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1L1RwJC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF42C4CEF4;
	Tue,  9 Sep 2025 13:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757423840;
	bh=hRxld0LQgbxPOlzudrdWuevDjVRV7o89tn8SOw9Mu7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1L1RwJCw9YLWyfXu0dgC8lxdvgHmQCMs0JewlmU3hj2DaLCUqN0q1FKoTI/bM2GQ
	 TVWA+rmVdWFRCii+Ymul3fHAowoE+GgSD4owH759ghy4Ou8jfrcFTbBK4k+BZlhFMI
	 r9XN9ODtSSM1Kp0v5A5I1wLtT4lOkC9HesOTe+3P6Yadi9W37rs5jzqACeZtS9sbYp
	 a8mzd4KhMhuV3OcteN2gBIWySU+52UAPtrVeXfvca19eflqAN56c6XFVmPveH89M/J
	 C9pd6RCQnKgsbzduwA+lXTOG0gvHSal494AjgRSehDDAcpz/VxuRCe7Dok+JDPdrmn
	 6GkmwamawT+fQ==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, dan.j.williams@intel.com
Cc: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>,
 io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject:
 Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
Date: Tue, 09 Sep 2025 15:17:15 +0200
Message-ID: <5922560.DvuYhMxLoT@rafael.j.wysocki>
Organization: Linux Kernel Development
In-Reply-To: <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
References:
 <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

On Monday, September 8, 2025 10:11:00 PM CEST dan.j.williams@intel.com wrote:
> Konstantin Ryabitsev wrote:
> > (Changing the subject and aiming this at workflows.)
> > 
> > On Fri, Sep 05, 2025 at 11:06:01AM -0700, Linus Torvalds wrote:
> > > On Fri, 5 Sept 2025 at 10:45, Konstantin Ryabitsev
> > > <konstantin@linuxfoundation.org> wrote:
> > > >
> > > > Do you just want this to become a no-op, or will it be better if it's used
> > > > only with the patch.msgid.link domain namespace to clearly indicate that it's
> > > > just a provenance link?
> > > 
> > > So I wish it at least had some way to discourage the normal mindless
> > > use - and in a perfect world that there was some more useful model for
> > > adding links automatically.
> > > 
> > > For example, I feel like for the cover letter of a multi-commit
> > > series, the link to the patch series submission is potentially more
> > > useful - and likely much less annoying - because it would go into the
> > > merge message, not individual commits.
> > 
> > We do support this usage using `b4 shazam -M` -- it's the functional
> > equivalent of applying a pull request and will use the cover letter contents
> > as the initial source of the merge commit message. I do encourage people to
> > use this more than just a linear `git am` for series, for a number of reasons:
> 
> For me, as a subsystem downstream person the 'mindless' patch.msgid.link
> saves me time when I need to report a regression, or validate which
> version of a patch was pulled from a list when curating a long-running
> topic in a staging tree. I do make sure to put actual discussion
> references outside the patch.msgid.link namespace and hope that others
> continue to use this helpful breadcrumb.

Same here.

Every time one needs to connect a git commit with a patch that it has come from,
the presence of patch.msgid.link saves a search of a mailing list archive (if
all goes well, or more searches otherwise).

On a global scale, that's quite a number of saved mailing list archive searches.

Cheers, Rafael




