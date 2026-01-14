Return-Path: <io-uring+bounces-11712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FA28D20049
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 17:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 667943017864
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 16:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0A33A1CF7;
	Wed, 14 Jan 2026 16:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQ3bwKwB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B35C3A0B2E;
	Wed, 14 Jan 2026 16:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768406453; cv=none; b=BLyxPfIIwxnbOe8SJOfPlfmX42r/6siOEk6LBMDNRVcLqPZVDLKWXJBYFdxURVusDaxOxhW+xnFvtoBSFQ3zAimAUUKZ+Ku2LYb2LGQrMgNFB4PjljYbVEk41xlkKbkbHNJXaaASc9idxKDSHAAP2odRFyLl5RCDOOrlqQYEJjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768406453; c=relaxed/simple;
	bh=SWwn1uBvvEbF5VZfqj8XM5G1nX7YWWVCpN2c72ulevc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iy3A2qZndbZZEWq8xs9IjMXiYg915RSYylQe/XsPvtMqxt595fz2JvVizm+JiWH84uhny02oZijEK2t97Q3mT4JaitGSOdF2tad1G6ZeJeI91JhosAQ5+2/28yU3k/yvWtdhkDwa6XpKl9pfVsgA6b13wF2VQLG2lC+nOHBWAgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQ3bwKwB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC9CC4CEF7;
	Wed, 14 Jan 2026 16:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768406453;
	bh=SWwn1uBvvEbF5VZfqj8XM5G1nX7YWWVCpN2c72ulevc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nQ3bwKwBdfeJYMr6e1jBoF3kct68djGmXYlmFIpBb2Sr9gXV8A0Om+jivFiD8yx8O
	 IsLEbRhvS4IY03gJIRua5u27QAuAyL4XuY3xfnwQAQE5yjirZGX1YJFpXn6eXnrd8c
	 pRVrCDfroLj+HI8YiXnwi64UwMIYgfuI1X7wVD226TBFdYgPZuacm7NGT3utGJ0+pR
	 fqvwHp5DXdjYvmkiuN5+GCfCGdmIfoNlhqPPwJkYfHTtyjaygViTgBlm3Co96dAL9G
	 iWHlyGRPF3b3zz9RbChPRQjFKQ9W2DMZq0nwammgkzQv+vfeJ4I+EXhmdpnBv+N0Z2
	 8kH9/uS9Ilczg==
Date: Wed, 14 Jan 2026 17:00:48 +0100
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, jack@suse.cz, mjguzik@gmail.com, paul@paul-moore.com, 
	axboe@kernel.dk, audit@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] experimental struct filename followups
Message-ID: <20260114-wildschwein-halbieren-bf41844e3f38@brauner>
References: <20260108074201.435280-1-viro@zeniv.linux.org.uk>
 <20260112-manifest-benimm-be85417d4f06@brauner>
 <20260114021547.GR3634291@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260114021547.GR3634291@ZenIV>

On Wed, Jan 14, 2026 at 02:15:47AM +0000, Al Viro wrote:
> On Mon, Jan 12, 2026 at 11:00:10AM +0100, Christian Brauner wrote:
> > On Thu, Jan 08, 2026 at 07:41:53AM +0000, Al Viro wrote:
> > > This series switches the filename-consuming primitives to variants
> > > that leave dropping the reference(s) to caller.  These days it's
> > > fairly painless, and results look simpler wrt lifetime rules:
> > > 	* with 3 exceptions, all instances have constructors and destructors
> > > happen in the same scope (via CLASS(filename...), at that)
> > > 	* CLASS(filename_consume) has no users left, could be dropped.
> > > 	* exceptions are:
> > > 		* audit dropping the references it stashed in audit_names
> > > 		* fsconfig(2) creating and dropping references in two subcommands
> > > 		* fs_lookup_param() playing silly buggers.
> > > 	  That's it.
> > > If we go that way, this will certainly get reordered back into the main series
> > > and have several commits in there ripped apart and folded into these ones.
> > > E.g. no sense to convert do_renameat2() et.al. to filename_consume, only to
> > > have that followed by the first 6 commits here, etc.
> > > 
> > > For now I've put those into #experimental.filename, on top of #work.filename.
> > > Comments would be very welcome...
> > 
> > Yeah, that looks nice. I like this a lot more than having calleee
> > consume it.
> > Reviewed-by: Christian Brauner <brauner@kernel.org>
> 
> FWIW, I've folded that into #work.filename and reordered the things to a somewhat
> saner shape.  Will post the updated series shortly.
> 
> Open questions:
> 
> 	* Exports.  Currently we have getname_kernel() and putname()
> exported, while the rest of importers is not.  There is exactly one

Tbh, I don't find that too bad. It would be elegant if we could wipe
that completely but I don't think that this is a big deal...

