Return-Path: <io-uring+bounces-11587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D62D12BC1
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 14:22:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1C1F730136E9
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 13:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52109357717;
	Mon, 12 Jan 2026 13:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNIEc6Wc"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5452222C4;
	Mon, 12 Jan 2026 13:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224138; cv=none; b=t1Xg8YYG6z6x2lskhqKVauWy/jezXctUPXfOev0+TPTqN2WcxaXh3+GyBw2PTjiK4M32+ujdyuTaUB0M2VEqH0oJOD4/gpR+mt4vL0WxEbgluluqBG0cvIb/CycVkFyq/una4HhDKJ9kJqrF7rnnSOrLjKSV+5oDmnj/eb+QtPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224138; c=relaxed/simple;
	bh=BDUIckWVUD1RagFJ5xtI1INGnjOo0Mtn45L5+aqLxUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxcgSYj0Psp8X01sLLTBGqY0ksQ1xEwHLmTrvsHZ5lgE6pbzyqc8YtyIH4RwBvuvfD4BEdd2HimhtT5Gepw6DKHoiXDgTNVTAqdEeywREDVQWM4hMhFy2L6k8x70NiDZGkeA4qO2SWHQYc+ebg+gtTD2rKm6J65eqJj9iMl1K60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNIEc6Wc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D36AC19422;
	Mon, 12 Jan 2026 13:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768224137;
	bh=BDUIckWVUD1RagFJ5xtI1INGnjOo0Mtn45L5+aqLxUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LNIEc6WcDx/szM8jktnG2voPpypdHDEA3wNwBsS5urMtvVE/RJR4Qx+GlS2vTfgdL
	 z3g0WuJBsYVMpOlpti9ggZFdF2XlmmEqFtVAtthTSnvQDbiaSwRRshgiK5wt+Hv4Op
	 gMgXisTKe9rQ2wpuEf56WS8TQjShDXGVrTVnkYWTpnkz2yPcB21TzwF7D+jAypeJde
	 guQZ9tsxbFISMUtu+DdRRSEp33HOe+1UGmKeveLm1+VzC3l5QaOfFQRPNzRuHAJZ4p
	 t7onerDFPgLsmiZZzPb2urdwXIucijdwljWTYh6SIa9RV9g8WRyD6sTf8WYWuDcdOt
	 j4TC128wA5czQ==
Date: Mon, 12 Jan 2026 14:22:11 +0100
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
Message-ID: <20260112-canceln-skript-95f066b9fcc1@brauner>
References: <20251223003756.409543-1-hch@lst.de>
 <20251224-zusah-emporsteigen-764a9185a0a1@brauner>
 <20260106062409.GA16998@lst.de>
 <20260106-bequem-albatros-3c747261974f@brauner>
 <20260107073247.GA17448@lst.de>
 <20260112-adelstitel-propaganda-ef80e3d2f8ca@brauner>
 <20260112100558.GA7670@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260112100558.GA7670@lst.de>

On Mon, Jan 12, 2026 at 11:05:58AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 12, 2026 at 11:04:17AM +0100, Christian Brauner wrote:
> > On Wed, Jan 07, 2026 at 08:32:47AM +0100, Christoph Hellwig wrote:
> > > On Tue, Jan 06, 2026 at 10:43:49PM +0100, Christian Brauner wrote:
> > > > > Umm, as in my self reply just before heading out for vacation, Julia
> > > > > found issues in it using static type checking tools.  I have a new
> > > > > version that fixes that and sorts out the S_* mess.  So please drop
> > > > > it again for now, I'll resend the fixed version ASAP.
> > > > 
> > > > It has never been pushed nor applied as I saw your mail right before all
> > > > of that.
> > > 
> > > Thanks.  But maybe you can fix up the applied messages to be more
> > > specific?  We had various issues in the past with them, where they
> > > were sent, but things did not end up in the tree for various reasons.
> > 
> > What are you thinking of exactly?
> 
> Only send out the applied message when something is actually pushed
> to the public tree?

When that happens it usually means that it's still waiting on tests.
I can pay more attention to this but don't expect it to be perfect in
all cases.

