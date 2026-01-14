Return-Path: <io-uring+bounces-11625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C31D1C1AE
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 03:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 78DA93015A8D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 02:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEFA42F4A1E;
	Wed, 14 Jan 2026 02:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="XbAgfl2y"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211E52F3622;
	Wed, 14 Jan 2026 02:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768356872; cv=none; b=OUtVtF1r7ZDoNqKGAvHieTU7UTIe06JmUf3PZLi4J/Gl+5dLtVMbi1Q8OPacFgSadFDZo1dAQvxqc42Xnff6HzNl6YjwCdUAjYtXExbtxdK/W7IKEGZfCT8agp747g6v+6gxqgExBEMIQfdlo1AHGMdW08E1TmLDFfVzq0eUJYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768356872; c=relaxed/simple;
	bh=Eim62QYQFqESfG3IRHpapS5368rCfGBliTb2sBVF3mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQFMzV7iXPJWXX4UNZmfX6RBOdHmrsZpIq37z9RFEiBY6GC1R5rwMcgOa4eJu0YIiDKymJ3E/VHwqeblQW7DEJ/1AOItDH7bJc9RcTywFsyImMKk4yrym3mYIMjwEjqIvUX5SFPWeACqqpHpJiLiIT+gHO5mvvm59yGSbNmk66A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=XbAgfl2y; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F07Bb/XS0FjFTzJIkMaLPMnHJ9Snwoe579dmrCa3XIE=; b=XbAgfl2y1V5iQoSQgOO+poTzHo
	6D+Y7KG5bqTZOFyizgAELwoeBbyC6zS8PLRaxyGCsE78wVuDpbFjfPMk82G7d6B8F9h5Fi6UeNXQI
	MoTyKhXMGRanv0UO8lmMN6M4/azRL9sZidwq5cpBkvZSDh7gnhff+kf02jtxOFsFnm0nJhXKVPCva
	3ygcCSH4QrfdZUVqCtAOdW2Xzol82jYLaufntdN5PCEMsfyCjwBYhdDDtirgPxX4TqEPYYtp5hukz
	2YrQkRlZ+SeS3rZ8wm/kFsFgAwsvMcd3kPk1RkT32GjOL++WlUdv4rTjWYQthS5nH3i1hrRpls0fy
	27T/NwuQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vfqQF-0000000G4QI-10Vm;
	Wed, 14 Jan 2026 02:15:47 +0000
Date: Wed, 14 Jan 2026 02:15:47 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, mjguzik@gmail.com,
	paul@paul-moore.com, axboe@kernel.dk, audit@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [RFC PATCH 0/8] experimental struct filename followups
Message-ID: <20260114021547.GR3634291@ZenIV>
References: <20260108074201.435280-1-viro@zeniv.linux.org.uk>
 <20260112-manifest-benimm-be85417d4f06@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112-manifest-benimm-be85417d4f06@brauner>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Jan 12, 2026 at 11:00:10AM +0100, Christian Brauner wrote:
> On Thu, Jan 08, 2026 at 07:41:53AM +0000, Al Viro wrote:
> > This series switches the filename-consuming primitives to variants
> > that leave dropping the reference(s) to caller.  These days it's
> > fairly painless, and results look simpler wrt lifetime rules:
> > 	* with 3 exceptions, all instances have constructors and destructors
> > happen in the same scope (via CLASS(filename...), at that)
> > 	* CLASS(filename_consume) has no users left, could be dropped.
> > 	* exceptions are:
> > 		* audit dropping the references it stashed in audit_names
> > 		* fsconfig(2) creating and dropping references in two subcommands
> > 		* fs_lookup_param() playing silly buggers.
> > 	  That's it.
> > If we go that way, this will certainly get reordered back into the main series
> > and have several commits in there ripped apart and folded into these ones.
> > E.g. no sense to convert do_renameat2() et.al. to filename_consume, only to
> > have that followed by the first 6 commits here, etc.
> > 
> > For now I've put those into #experimental.filename, on top of #work.filename.
> > Comments would be very welcome...
> 
> Yeah, that looks nice. I like this a lot more than having calleee
> consume it.
> Reviewed-by: Christian Brauner <brauner@kernel.org>

FWIW, I've folded that into #work.filename and reordered the things to a somewhat
saner shape.  Will post the updated series shortly.

Open questions:

	* Exports.  Currently we have getname_kernel() and putname()
exported, while the rest of importers is not.  There is exactly one
module using those - ksmbd, and both users in it are doing only one
thing to resulting filename: passing it to vfs_path_parent_lookup().
No other callers of vfs_path_parent_lookup() exist.

	Options:
A) replace vfs_path_parent_lookup() with
int path_parent_root(const char *filename, unsigned int flags,
                     struct path *parent, struct qstr *last, int *type,
		     const struct path *root)
{
	CLASS(filename_kernel, name)(filename);
	return  __filename_parentat(AT_FDCWD, name, flags, parent, last,
					    type, root);
}
have that exported and used in fs/smb/server/vfs.c instead of
vfs_path_parent_lookup(); unexport getname_kernel() and putname().

B) make the rest of importers (well, CLASS(filename...), really) usable
for modules as well.  Then we probably want to publish filename_lookup()
as well.  Unattractive, IMO...

	* LOOKUP_EMPTY.  IMO putting it into LOOKUP_... space had been
a mistake.  We are actually pretty close to being able to extract it
from there; I'd love to make getname_flags() take boolean instead of this
"unsigned int, but we only care about one bit in it" thing.
	There's only one obstacle - modular callers of user_path_at() that
would possibly pass LOOKUP_EMPTY in flags.  Right now there's none (in-tree,
that is)- we have only 3 modular callers in the first place and they pass
only 0 or LOOKUP_FOLLOW in flags.
	I would rather provide user_path_maybe_null() if/when such beasts
appear; it's saner for any new API anyway.  I really wish we'd done it that
way for fspick(2), but it's too late to change now...
	Note that existing non-modular callers are better off with
CLASS(filename_...) + filename_lookup().  Modular ones can't do that,
due to the lack of exports; TBH, I'd rather keep that machinery internal
to the core kernel...

	Comments?

