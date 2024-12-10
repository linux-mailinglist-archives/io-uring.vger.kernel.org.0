Return-Path: <io-uring+bounces-5420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B65B9EBB6B
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 22:02:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82F091682BA
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 21:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8252B22FAC5;
	Tue, 10 Dec 2024 21:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b="exEi167u";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UVy2CqM0"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8590D1BD9E9
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 21:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733864523; cv=none; b=LNyGjg3iEjZGulqd+PVpu7Ac3DlufpFAKsIYghGZNjEYFam9ndgIzXU/xkWg70xGaJ/eKAZ95qjfKNjzouSfpQeWsfP5dqLM+IAfXl8ayI4Zp3EAVT6NtcN8rcNwAB+GZbz1bMQKL9TWC52z31d0eIlrzzUZEGqL/lcTQvxA3qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733864523; c=relaxed/simple;
	bh=4r1TMo05ra0mRXeuWRpErjhCqtx44GbwwijeoKgDTO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVDK2Iq5kC5u8AmomP5znWoA7yTUov2Jb3SzqbxsOp+sz2Ek5MqLVIpPO8cqOItISHPagvZYjtTSkUuqQ+7IZycYBuuGFhYJ2Tk7ztIJhPSh4HqhqDFiGSTi9SUAHy0cY17y5i10S9VgHJfJxMRE2/hpFhQDxL7ihh3ycCJf2q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org; spf=pass smtp.mailfrom=joshtriplett.org; dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b=exEi167u; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UVy2CqM0; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joshtriplett.org
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5FF3A1140174;
	Tue, 10 Dec 2024 16:01:59 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 10 Dec 2024 16:01:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	joshtriplett.org; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1733864519;
	 x=1733950919; bh=7CBmR5FSshZ4hRU++KIi+gfh7UPAc3EVL7C+EHW4XhI=; b=
	exEi167u5kkiMlqJV53GZrg2J3riB29TiIJPifMCHEfsT1oaaFGMNfcVhQc8RgFl
	R3otq5cezxR4Ylb/vgsGJPsIEy9R67zn/iQvW/eC9o8qBWl6UN6kijoBfbXZcEL3
	TEDAbklnW46rTKcHw4wBULPXvR4ValaoyUEOXulCudmRZmDSf2jEfSnklxYnc2b5
	Qis7I/Ldp4/jCqz2z/XmHAR0bRguKTLwRinBC48wYT0oVsu1vf+XjhOUF1pDb5fS
	KpjP3OzQCVEpOOKWiqCUf7QVVnk75q0hZg/nwv7OolE2lPd7EmoyglR2Q5/6Bx3M
	xN3tYdsZkUkJ76J4RAXabg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1733864519; x=1733950919; bh=7CBmR5FSshZ4hRU++KIi+gfh7UPAc3EVL7C
	+EHW4XhI=; b=UVy2CqM0s1Gu/GxWLuBRa/bsu9yGiXSj9Yn8Dnu6VTugVWZNf+A
	fkw6Z764xV9a6jhsxAXIE2a/4xzJHzMYNZOKnlKlmCtmAvnlkvyQ1I/UBVFYp7Mm
	CVsfMW+0N4THqhtZOTFq2SZd/OnD4csm1IKet88GZ5q/6Pkun3W69S36FpvR2Ske
	FByllVGvyKbrdhhzEJFLqizxB0RKvkVmMSH/DxpVH9XKetnywTYDY+t3Rmzi0ryZ
	ZJkWVAp2sAx+GfQ+lAHjLiN3mUcSqu5/59/eTndvGGB3PFCCKFTkaADmy/HK7jZ6
	RkJppqkpQXiZoLBHCgFVeHrT1o8doYRl1+A==
X-ME-Sender: <xms:RqxYZxKX9P7vNMA7T6FDDmyD6VuRoeociHpRjTg_NdNZSrb1yCNZZg>
    <xme:RqxYZ9KabHZ4FcUakl27gWqsaAi-slyp8rlbYuhhkzeq54PuowHmSO2yOZshbZhVo
    HVkKa_MAd7Ir4j5xLQ>
X-ME-Received: <xmr:RqxYZ5vvTsy4omarrXYC9BW-4nCMnZOkfSn2t7Q8ZiaPbe09aMsLeVKtzIhi8NuVdhOfL1GtWapTswwrRpLRiI0XBI8aNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrjeekgddugedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvden
    ucfhrhhomheplfhoshhhucfvrhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplh
    gvthhtrdhorhhgqeenucggtffrrghtthgvrhhnpeduieegheeijeeuvdetudefvedtjeef
    geeufefghfekgfelfeetteelvddtffetgfenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
    pdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehkrh
    hishhmrghnsehsuhhsvgdruggvpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgu
    khdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtph
    htthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:RqxYZyazqHohJlmofNWZ_q-Ii92EfJ5Vh_UVbMX-DU2164eoKWU8nA>
    <xmx:RqxYZ4YvFCLsV2WjN9R2On018fg20b7W8Vgu8y4P-Pb-qvSHqDGWEQ>
    <xmx:RqxYZ2A8uSnh8_OMk67qf-A3wZiJqgIl0XmnAj-2z6TE8yasNQd7dw>
    <xmx:RqxYZ2aGOosGhyf5yObcskaqESYupgZ5mZq-h61-pqHnkjtQTbxW9g>
    <xmx:R6xYZ_U7tGc-rcixq7tpnfA6TZd_WTMjIV73pGGrtSjNT8SEgbxPRDUl>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Dec 2024 16:01:58 -0500 (EST)
Date: Tue, 10 Dec 2024 13:01:57 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 9/9] io_uring: Introduce IORING_OP_EXEC command
Message-ID: <Z1isRTCg2pkJW_Ev@localhost>
References: <20241209234316.4132786-1-krisman@suse.de>
 <20241209234316.4132786-10-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209234316.4132786-10-krisman@suse.de>

On Mon, Dec 09, 2024 at 06:43:11PM -0500, Gabriel Krisman Bertazi wrote:
> From: Josh Triplett <josh@joshtriplett.org>
> 
> This command executes the equivalent of an execveat(2) in a previously
> spawned io_uring context, causing the execution to return to a new
> program indicated by the SQE.
> 
> As an io_uring command, it is special in a few ways, requiring some
> quirks. First, it can only be executed from the spawned context linked
> after the IORING_OP_CLONE command; In addition, the first successful
> IORING_OP_EXEC command will terminate the link chain, causing
> further operations to fail with -ECANCELED.
> 
> There are a few reason for the first limitation: First, it wouldn't make
> much sense to execute IORING_OP_EXEC in an io-wq, as it would simply
> mean "stealing" the worker thread from io_uring; It would also be
> questionable to execute inline or in a task work, as it would terminate
> the execution of the ring.  Another technical reason is that we'd
> immediately deadlock (fixable), because we'd need to complete the
> command and release the reference after returning from the execve, but
> the context has already been invalidated by terminating the process.
> All in all, considering io_uring's purpose to provide an asynchronous
> interface, I'd (Gabriel) like to focus on the simple use-case first,
> limiting it to the cloned context for now.

This seems like a reasonable limitation for now. I'd eventually like to
handle things like "install these fds, do some other setup calls, then
execveat" as a ring submission (perhaps as a synchronous one), but
leaving that out for now seems reasonable.

The combination of clone and exec should probably get advertised as a
new capability. If we add exec-without-clone in the future, that can be
a second new capability.

The commit message should probably also document the rationale for dfd
not accepting a ring index (for now) rather than an installed fd. That
*also* seems like a perfectly reasonable limitation for now, just one
that needs documenting.

Otherwise, LGTM, and thank you again for updating this!

