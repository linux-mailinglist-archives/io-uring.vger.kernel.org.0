Return-Path: <io-uring+bounces-11583-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CCD85D11B44
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 11:04:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A059F300A7A5
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 10:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B2728AAEB;
	Mon, 12 Jan 2026 10:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pcA+4sQZ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D92292B54;
	Mon, 12 Jan 2026 10:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212264; cv=none; b=V9qNH2EGs4R9fSQgDBzPwsSz+z8LSzRtRSRVyz4y8npzbmcd+9U825FNq/A+RnUPSJ/h7rMaqWriHyXpDxAJsoH91exxDJQLIw/54EO8Vub0hsIucBNWI3+WNv+9tvpXBJuUBVJzhzKh0qUHr6t+dhnagxEr95EjOhuoDfBtB00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212264; c=relaxed/simple;
	bh=AkmUv9RHQQCP7czZn+JPAkCEz9sqfQvYmWRULDwKJ1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKsBRz3jMfOdfadRgQsdcOD2AHUjaWUV5YupZTaoAgQhaX1KKQVT7ecvqvvIV2iD8E3EUCQo43RZjPLuXTjbT/QHDN9D7hk4ksX9eH/I/U3/Xcw0vIJkL5gpkQTmiE+ll/goL1Kl+y9TMub12HrehSzh+2Gx/hICcAQvIZ5eSHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pcA+4sQZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B727C16AAE;
	Mon, 12 Jan 2026 10:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768212263;
	bh=AkmUv9RHQQCP7czZn+JPAkCEz9sqfQvYmWRULDwKJ1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pcA+4sQZdXRGTPbk3jl7RSZxEdWcJV1w2GrIiyTNmdt3uczv3CsnKSct2x6hj4TGr
	 PnztyirMSb20Eu+vut63R/4+QU+fqqO/FI4zbel7cgYFXcFiYB+qXvnj9TkAsuzpp6
	 TPekQge7W7dmN6BL/kHHJXcoj9IEqJckUodmzBr7Z7FecfsmB3GCnbeRI82GcaEj2y
	 HIIuBlIHYuSaPoUFeTg964kp/cbdm9WIdKQR5vNO4Qipc8NSB/LCv+0EEOdfimbScy
	 JP+2olI4hfgixDmUOGjhjK0aO+qDbNU+rtP9vlSIawrDn3jJWfnWmkVlcutpmjPnLk
	 +Hl8iGkypbiTw==
Date: Mon, 12 Jan 2026 11:04:17 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, 
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>, 
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, io-uring@vger.kernel.org, 
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: re-enable IOCB_NOWAIT writes to files v4
Message-ID: <20260112-adelstitel-propaganda-ef80e3d2f8ca@brauner>
References: <20251223003756.409543-1-hch@lst.de>
 <20251224-zusah-emporsteigen-764a9185a0a1@brauner>
 <20260106062409.GA16998@lst.de>
 <20260106-bequem-albatros-3c747261974f@brauner>
 <20260107073247.GA17448@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260107073247.GA17448@lst.de>

On Wed, Jan 07, 2026 at 08:32:47AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 06, 2026 at 10:43:49PM +0100, Christian Brauner wrote:
> > > Umm, as in my self reply just before heading out for vacation, Julia
> > > found issues in it using static type checking tools.  I have a new
> > > version that fixes that and sorts out the S_* mess.  So please drop
> > > it again for now, I'll resend the fixed version ASAP.
> > 
> > It has never been pushed nor applied as I saw your mail right before all
> > of that.
> 
> Thanks.  But maybe you can fix up the applied messages to be more
> specific?  We had various issues in the past with them, where they
> were sent, but things did not end up in the tree for various reasons.

What are you thinking of exactly?

