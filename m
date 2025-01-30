Return-Path: <io-uring+bounces-6186-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC35A229D7
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 09:51:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA6E6188798C
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 08:51:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 139341AF0D5;
	Thu, 30 Jan 2025 08:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="vjdEmCTA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="L+uznQEE"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA081922D8;
	Thu, 30 Jan 2025 08:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738227073; cv=none; b=iE899nkKXNoxmLQj6oMgjMJLPLvs6YgCFkB5D8pPhUvIKecxFdxTvI1xDSu4LxsFWE+by9uCTAgMPUpr+xVDWcpMdthf2SsTWafyf4MG1pbh1ewD6AaMPuIWYOyBE+F9W9cRha+Tq4FkIw1qNiMz8/EsgaIWCMWHtlW0iZ+v6bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738227073; c=relaxed/simple;
	bh=ybJ34VRE+yB38dGXPDJwu1C1v6BXAzq008gahZppNTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OV7wP2Bz8vI/OHL+3svSchsDTioYJsyAjGGz6eukSyjXsHyfERMsTXAGqQn9/2V/W2wNunGJhFIx5+3z7zXX93rJ/ggsupLqc1Oj6OI6DpqJGeod1kwMbnnhMKq/bqKwuqSKQsboCtsmaJkQ8phImZcQ1FKbTDJSexGaNvYxQDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com; spf=pass smtp.mailfrom=kroah.com; dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b=vjdEmCTA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=L+uznQEE; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kroah.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kroah.com
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 7C9471140117;
	Thu, 30 Jan 2025 03:51:08 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 30 Jan 2025 03:51:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1738227068; x=1738313468; bh=5yr9ViFbki
	C3MNrNLYa+pJvgCeqHEbp+4tHMwTThKc4=; b=vjdEmCTA5ulGZakAFZS2nfMJbZ
	vEf0+rbt7508/jljNHHMBTnvPvJJ3QNrZs+B2cdW/dZOMvZc+r8asTeJgbTf43wD
	TTApfbNlJTT7cUzPQHyIKgHWTcNUZSF9p6jTsLzrKhl//MpM4EyYSxri6uYP77po
	UM494/m8Es4BAzzxX6dcoGwY1AyuMFAJA5t4ZMuXGbItbfZH73IjkL7wHuisYPlj
	SFn8Clx/CgcolrwfTfsoEUJsSS7dgcZoOQBrk/FKS9pcCwz+KfXz7+cJRPTe3n7c
	HspSGkQO90/kyTYXtHm2p/MWcQrSVnP4gVGlueaJS3pbnOPDrNYnVwwUO/CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1738227068; x=1738313468; bh=5yr9ViFbkiC3MNrNLYa+pJvgCeqHEbp+4tH
	MwTThKc4=; b=L+uznQEE4WUFGuZRf30ZGnzQ0VH3dlYxogRLMlRNntr/slLMDSB
	FG2J0mx5JdQUtCZQIjIcyLZJySP22lYGLpzTUzZT2hvFeZxGy4KkFc61I0K1LlUy
	A4S2yaZh6obHaw65SQqS4WBeonErvZ4+8V4QVljcFNkbIZ4OegRahntBSQpO1Dfp
	pZUx3m6DSuKynS3YUkf50t6XET5jLvs+UJ5EEigkGqaAFnGr7xWIQY4u5QkHUtpb
	zJ3xh9jvgSIHzbl9TN4buPb919pLls91pcvmpmaqbYC7rPkwLXC7a6dlCl2DtmAc
	4bT0+2JRs9Kh4vmz6FWscKPnk+GPnq8tRmA==
X-ME-Sender: <xms:ez2bZ_Q350Rw2BGwR2Y54UBGtNKRMBbr03iAxyy8CF1ZjjtWxC_sFw>
    <xme:ez2bZwwnnofXziZkV4654Rj7nISXbYNmCG4c8NkxTxh1uQZ9GMDxEMVrcFLN09zDS
    6mWrKC1ktiOgA>
X-ME-Received: <xmr:ez2bZ03A2zPUPGI8kll4PnGRSmDc6gm6z1Tr80fOrFQkXa4Fw-ZBOskclveKvBPA0CBqrxC3Q-VwJA7dEKgdOCXc1tO9Ni_CKMncYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdehfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvve
    fukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcumffjuceoghhrvghg
    sehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeejudeggffgffffhffhvdfhgf
    ehvdetgeetuefhieefhfeuvedvfeefudeghefgkeenucffohhmrghinhepuggvsghirghn
    rdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhhiiigvthgrohdusehhuhgrfigvihdrtghomhdprh
    gtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthho
    pehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsth
    grsghlvgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopeigrghnsegthhgr
    rhgsohhnnhgvthdrtghomhdprhgtphhtthhopegtrghrnhhilhesuggvsghirghnrdhorh
    hg
X-ME-Proxy: <xmx:ez2bZ_B6NdX2ymxdO0S8RAY6tr-YKyVDvgJbRkcq2rRvfjdhpx4q4g>
    <xmx:ez2bZ4i8vIVWTowLRQdkSozY9-XM0Golf7fEvopAY-xOkbDZUUg5Zw>
    <xmx:ez2bZzoSBcH3zxRpe-BghIRgIJLznFfTiZJpoewmlMZ6lUIJLnVNIg>
    <xmx:ez2bZzhwnkkBkm-9zGt-9AqALDcsPkKX0rtPu0nagK8kdzryF7g7Yg>
    <xmx:fD2bZ5buJm6xjmxhPNalbuO5-884LgiBptIxDzX2jQKThJVueUv2aorY>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Jan 2025 03:51:07 -0500 (EST)
Date: Thu, 30 Jan 2025 09:51:03 +0100
From: Greg KH <greg@kroah.com>
To: lizetao <lizetao1@huawei.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Xan Charbonnet <xan@charbonnet.com>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH stable-6.1 1/1] io_uring: fix waiters missing wake ups
Message-ID: <2025013058-outnumber-relapse-f270@gregkh>
References: <760086647776a5aebfa77cfff728837d476a4fd8.1737718881.git.asml.silence@gmail.com>
 <da9d505df3f648ad8660ad6e53a6f77c@huawei.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da9d505df3f648ad8660ad6e53a6f77c@huawei.com>

On Sat, Jan 25, 2025 at 06:59:06AM +0000, lizetao wrote:
> 
> 
> > -----Original Message-----
> > From: Pavel Begunkov <asml.silence@gmail.com>
> > Sent: Saturday, January 25, 2025 2:54 AM
> > To: io-uring@vger.kernel.org; stable@vger.kernel.org
> > Cc: asml.silence@gmail.com; Xan Charbonnet <xan@charbonnet.com>;
> > Salvatore Bonaccorso <carnil@debian.org>
> > Subject: [PATCH stable-6.1 1/1] io_uring: fix waiters missing wake ups
> > 
> > [ upstream commit 3181e22fb79910c7071e84a43af93ac89e8a7106 ]
> > 
> > There are reports of mariadb hangs, which is caused by a missing barrier in the
> > waking code resulting in waiters losing events.
> > 
> > The problem was introduced in a backport
> > 3ab9326f93ec4 ("io_uring: wake up optimisations"), and the change restores
> > the barrier present in the original commit
> > 3ab9326f93ec4 ("io_uring: wake up optimisations")
> > 
> > Reported by: Xan Charbonnet <xan@charbonnet.com>
> > Fixes: 3ab9326f93ec4 ("io_uring: wake up optimisations")
> > Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1093243#99
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  io_uring/io_uring.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c index
> > 9b58ba4616d40..e5a8ee944ef59 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct
> > io_ring_ctx *ctx)
> >  	io_commit_cqring(ctx);
> >  	spin_unlock(&ctx->completion_lock);
> >  	io_commit_cqring_flush(ctx);
> > -	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> > +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
> > +		smp_mb();
> >  		__io_cqring_wake(ctx);
> > +	}
> >  }
> > 
> >  void io_cq_unlock_post(struct io_ring_ctx *ctx)
> > --
> > 2.47.1
> > 
> 
> Reviewed-by: Li Zetao <lizetao1@huawei.com>

Now queued up, thanks.

greg k-h

