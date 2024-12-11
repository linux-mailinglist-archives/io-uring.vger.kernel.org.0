Return-Path: <io-uring+bounces-5446-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C93859ED3BC
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 18:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CBC3280E1B
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 17:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2520D1DE2A0;
	Wed, 11 Dec 2024 17:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b="N/O8Eg+V";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="IuckqzLg"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52791DDC19
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 17:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733938492; cv=none; b=pUto804z1dTbH7DDl3GpxG7hHh+oNxR6Cn35LzR76KrOAD7MmBOyCCphELsR6iTeVXleBIvL62I0/0KusOxneZTPFseFaiKaLJBwi+TF5U46m06UcEKHHhJ9Wc160sPDKV6ec15RW2JkXHr1qGlSDpOvKt40No2hUlZB54Kznus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733938492; c=relaxed/simple;
	bh=+x6VENLo9WiZ/QHGgMi+eZE/tHMdS35kGDP2uQjRmpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ceDp4bkNcGj2++DHfeZzppUVaq6mQpMXJaVSpadss2u9D0PxoBx55hUAqZ9MTTd54bwNPHYOWsGyjVFKehRjCv0pwPPrWX3ZtrEAzegK6+f1ZRyLGkAOxc1Mf+0ufKHkg7SZXyJNZKgeR0WyhkJm13MJ/eFxvvrOqlEXD2bkJj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org; spf=pass smtp.mailfrom=joshtriplett.org; dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b=N/O8Eg+V; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=IuckqzLg; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joshtriplett.org
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C36CA11400AF;
	Wed, 11 Dec 2024 12:34:48 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 11 Dec 2024 12:34:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	joshtriplett.org; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1733938488;
	 x=1734024888; bh=l0KeTUe4gEhaRbNt+AWr7a73fPenG5tTHycYDlleLj4=; b=
	N/O8Eg+VOBD2M4u5VBeEGbLCLQ35ALYYMUIGxf5ihK8DMIeWuAsnxIC5Su9jd+It
	ft3wGkUGfxI0bPtuEjVBd2x6IiWAHtIqYDJBTqSonPUSLDRx275VthDO/Jqpu8yv
	5qDDGRd5hqB9XdTeH+WFzZd4KmZGFsQm7g8j3BfCkLq6N844pyzaKYqhimFYJmBs
	JEiqkcrLyrNlrTqrVv34aV8ns3D7fH9D5hWi5+Zmn4akmuzWh+OaOm1gF2KGVYpS
	Pq5h3pihoIRn2flVrTwwroLu89w2P2yNbn4YyScikfp6MNbc0eojWY17sg//lmWO
	GvAwEgxMFD0ytEVY6lxnSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1733938488; x=1734024888; bh=l0KeTUe4gEhaRbNt+AWr7a73fPenG5tTHyc
	YDlleLj4=; b=IuckqzLgJ+MUPwl9Ih+WLPjeG0FSFKOoFz7sJ3E+gC5XdTYdLTq
	/R60pY9nwtbXZ7V1yNYQq2MAQG4rI//i4rpmwFjAz7EOdTe++BfGYMJQiExoWO3R
	SpNqbZr0h6Lh1bDHsOibR2VG035L2dk159a4GpF3IZhZGc16u5tH9ZeYeGZp2u0w
	Sg6op9DcjG+xJ6P5kAXsjaPLNbiy8EhH8QXVWDodz8kuWlc5+u6URToyb6FcMjlk
	6vqJY4+hGZD3sYQVpdvZ6bA5bpewtTxlxZFoDihzHqCm+Fsxvy+hnY+W1TpxisS1
	a1z2603bGpKuyHOXFNB/R0FDI+wbEtCD6/w==
X-ME-Sender: <xms:OM1ZZ41mUUpxaJAmm_nZWsZCyoVkHyLSEIgbzGYR2x0tx8wGDNfQDA>
    <xme:OM1ZZzF0vd4YbI7bj-ONZoiKO4rokMB4bo6k44uXDniYrIfH8b6QTOv9pQ-pqMQ5I
    mVQpQkerBA-kmBsHA4>
X-ME-Received: <xmr:OM1ZZw7Xmp9ISmSIoGjXWFp6psYr9HUgeMNxyvhYFv8BGI76bP2AI5n2n53YQTtIN2vvIKOXL8KDHuODiL8HLgvghZ7RHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrkedtgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvden
    ucfhrhhomheplfhoshhhucfvrhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplh
    gvthhtrdhorhhgqeenucggtffrrghtthgvrhhnpeduieegheeijeeuvdetudefvedtjeef
    geeufefghfekgfelfeetteelvddtffetgfenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
    pdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrsh
    hmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopehkrhhishhmrghn
    sehsuhhsvgdruggvpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtph
    htthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:OM1ZZx2R77vLoAPdhUkXz7aaRFMxDNrOkYAUDEogaFIdlLRXVxTpxQ>
    <xmx:OM1ZZ7GbYGp-LF5EBc0iENCX52h5LEv3wsQjKaj4YXh0cdmmpeMk_g>
    <xmx:OM1ZZ6_sFZ06FeEm4ILKS2SrRtaS3yd-3lT3Morp6twGl2zSDxtgMA>
    <xmx:OM1ZZwmS7Pru4SPURon8OTS4Hf8ILgjSFX6gUVs4RRw5zRdRrbdEBA>
    <xmx:OM1ZZ_j4cE57fLoIAbYFDMkLfY_UbLNsWcSooMMn-O8XHYacXUUFConY>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Dec 2024 12:34:47 -0500 (EST)
Date: Wed, 11 Dec 2024 09:34:46 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, axboe@kernel.dk,
	io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
Message-ID: <Z1nNNr_a4P0bgihN@localhost>
References: <20241209234316.4132786-1-krisman@suse.de>
 <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>

On Wed, Dec 11, 2024 at 02:02:14PM +0000, Pavel Begunkov wrote:
> 1) It creates a special path that tries to mimick the core
> path, but not without a bunch of troubles and in quite a
> special way.
> 
> 2) There would be a special set of ops that can only be run
> from that special path.

The goal would be for the exec op to work just fine from the normal
path, too, for processes that want to do the equivalent of "do several
syscalls then exec to replace myself", rather than doing a fork/exec.
The current implementation defers supporting exec on a non-clone ring,
but I'd expect that limitation to be lifted in the future.

> 3) And I don't believe that path can ever be allowed to run
> anything but these ops from (2) and maybe a very limited subset
> of normal ops like nop requests but no read/write/send/etc. (?)

I would ideally expect it to be able to run almost *any* op, in the
context of the new process: write, send, open, accept, connect,
unlinkat, FIXED_FD_INSTALL, ring messaging, ...

> 4) And it all requires links, which already a bad sign for
> a bunch of reasons.

In theory you don't *have* to have everything linked for a batch of
operations like this, as long as it's clear what to run in the new task.

> At this point it raises a question why it even needs io_uring
> infra? I don't think it's really helping you. E.g. why not do it
> as a list of operation in a custom format instead of links?

Because, as mentioned above, the intention *is* to support almost any
io_uring operation, not just a tiny subset.

