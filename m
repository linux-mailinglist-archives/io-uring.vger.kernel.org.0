Return-Path: <io-uring+bounces-3266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A982497ED5A
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 16:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D973E1C2109C
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 14:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64C578283;
	Mon, 23 Sep 2024 14:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="mjmEVYwA"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0960076056;
	Mon, 23 Sep 2024 14:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727102927; cv=none; b=SJ1WpfD3hy3Dj3k4YOle0xznxE0Ea320TEbpeao67TuYj9SBICjhrxNkvvRgpyYAF62zvf4DJYprL9zxGAFmm/JBH9pAYPN1pQ36DO5QKGd7NMKQ6W77ZRzUlgj+rhCYze1Y+Z+oBAFug+pfQpcJ2/5hhwVOmgh8REXedco7tf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727102927; c=relaxed/simple;
	bh=EhpXs2M7C4l+N3EjpvmcNP9axElbk0sRkPBOPzG2oyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlO/UJtvMyeyVBadbsQTDQyEMGSznKcuDFeHHYa1TWlzy5sx9wJ/kFiTI7+FZ185kwOmyjlPoXqGpCEqveq8GhQfgFGKIC/5m2sTERgZVGMcZrl2RQJPnjZWvz6BGg23tf3XcWWRZkbWgD/rCD6AbwZVBjcPIb9fW8Dop7vL8JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=mjmEVYwA; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BNgewA9YeKWfGeEjE8HGltZneaOAbMnY+HPJeabU/pA=; b=mjmEVYwAwch7/YJ3dDArUg4R7v
	dhnrYmz4DzBPEdUTu1FUZ0Yze+TGfwdwHsC4obXYlrWOZDhhmORRAlF4z3vN+bJgqHt8IyEt8/Ivf
	IescV0yUfMqlVP1yuXMPEmuEPkOrWr3fxXpUgmuByWgSz0ZiJuljhEqKyyVS2wMZFXl6sZPUd+Ed3
	xL2IXC17UfoS1e7vy0c5PkTJroNQxp6mebn1bNDPuPpw9bliI2xSaCmvcvVAOrsvTS9hLTyZx4HWW
	BpGpQVqnYjXhRoC+ySqS9P4tm5Sik2mlx58pQOOymXKnF5PXJgUJgImRMtIdRHh1OG0I/xREf5aKe
	QNObSzzw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sskMj-0000000EuKA-3rDr;
	Mon, 23 Sep 2024 14:48:41 +0000
Date: Mon, 23 Sep 2024 15:48:41 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240923144841.GA3550746@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
 <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
 <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Sep 23, 2024 at 08:54:03AM -0400, Paul Moore wrote:
> [Sorry for the delay, between flying back home, and just not wanting
> to think about the kernel for a day, I took the weekend "off".]
> 
> Jens and I have talked about similar issues in the past, and I think
> the only real solution to ensure the correctness of the audit records
> and provide some consistency between the io_uring approach and
> traditional syscalls, is to introduce a mechanism where we
> create/clone an audit_context in the io_uring prep stage to capture
> things like PATH records, stash that audit_context in the io_kiocb
> struct, and then restore it later when io_uring does/finishes the
> operation.  I'm reasonably confident that we don't need to do it for
> all of the io_uring ops, just the !audit_skip case.
> 
> I'm always open to ideas, but everything else I can think of is either
> far too op-specific to be maintainable long term, a performance
> nightmare, or just plain wrong with respect to the audit records.
> 
> I keep hoping to have some time to code it up properly, but so far
> this year has been an exercise in "I'll just put this fire over here
> with the other fire".  Believe it or not, this is at the top of my
> TODO list, perhaps this week I can dedicate some time to this.

What are the requirements regarding the order of audit_names in
the ->names_list?  I really don't like the idea of having struct filename
tied to audit_context - io_uring is not the only context where it might
make sense to treat struct filename as first-class citizens.

And having everything that passed through getname()/getname_kernel()
shoved into ->names_list leads to very odd behaviour, especially with
audit_names conversions in audit_inode()/audit_inode_child().

Look at the handling of AUDIT_DEV{MAJOR,MINOR} or AUDIT_OBJ_{UID,GID}
or AUDIT_COMPARE_..._TO_OBJ; should they really apply to audit_names
resulting from copying the symlink body into the kernel?  And if they
should be applied to audit_names instance that had never been associated
with any inode, should that depend upon the string in those being
equal to another argument of the same syscall?

I'm going through the kernel/auditsc.c right now, but it's more of
a "document what it does" - I don't have the specs and I certainly
don't remember such details.

