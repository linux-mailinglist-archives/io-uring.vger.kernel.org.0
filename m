Return-Path: <io-uring+bounces-5527-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7032F9F56BA
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 20:14:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38FEA18838A1
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 19:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40FFA13EFF3;
	Tue, 17 Dec 2024 19:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b="BiCfzlNz";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KiWAHpNc"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1572B442F
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 19:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734462893; cv=none; b=cIdGPPHPkbjEA/o/6JDSv+RxCCjQH9fCb1Lpese4zmSKDG7Kaw43fPv+DJE6PZqc9g31eQF98ZTTYA2ltZtSQEaphSJOpRYwhSqXQvjMkCLZEpW+cxmAnezyiWkb6ngncXtvovOgpBwLOtLtiI56za7i7ItCZ7As0TKqXh+FeWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734462893; c=relaxed/simple;
	bh=Kju+EShWacB+iMaqrJ7JKxNeaTrleMlHC8s4l8ALL2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0REXlMSvaystTw0zYb/vugPjCRlXTgAg0+m3BHVX8CtzFTxHh6Ftslvu/1GCQw0MUesJPFBTbeeIrQtNlm75rMsq1cGERNc+Bo759a4H2O6XfSr2Yaris4YaNw/odRKr4SmCpuXTDUp0WFSq06vaPVn62KXhlnoO2jC8pSfoGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org; spf=pass smtp.mailfrom=joshtriplett.org; dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b=BiCfzlNz; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KiWAHpNc; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joshtriplett.org
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id E9BA4114014E;
	Tue, 17 Dec 2024 14:14:48 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 17 Dec 2024 14:14:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	joshtriplett.org; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1734462888;
	 x=1734549288; bh=kDOLcef3jeuvNsxFYtyM772Bsppb3I84ASeaEOoxEsk=; b=
	BiCfzlNzT0CfIOFa/kOivE7vx7ZAWUIw8rCPXX0WFIekMLrq+DYrzUwUJl6v5LbH
	NMINCMbIXaJktUe36LtBhZOYV7GRbY4t+5olsewFGyLIyoq1glxft4tQoH/didrK
	OUpoAH2gpTO/mxZJvoFh5dyetFU1LdItlBLPNz9knQszuBWEk/HWjm1AhTPnhYGJ
	MGa4LclqCTYtJGlM0mN9ixWDuzVcYYPfrgHKklzpO44xIVYKYfm6J7Z5jcmGZPxO
	8ebQIyT48FKr529su5abs70I2yu+IDXC3OTzbHIpAW6u3CKJdaluNvcSMFhq15pi
	CB/a/fgCy7pL060deJpVJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1734462888; x=1734549288; bh=kDOLcef3jeuvNsxFYtyM772Bsppb3I84ASe
	aEOoxEsk=; b=KiWAHpNcjMLFZKWyQLC3BJSLeMZKg9RHs6kw52bUdQfyQFUMRXg
	ML+X4vynx+EXE53/LhzVvC/UC8MT+aMWX4XZIBaQr8GcyJffBX3a5/wbpR6JccTr
	DEvlzPX2B4cEVAZ176iwG395ATsndN2GpMJOfBrBWSq3IOyIHiuttUBIqP7ZvYv8
	w+/kGoHMryney4giOjAOZfjfVmfPOAc7hgrgIMNbvwmG7NKKXO1zLZ/Yh9yRkfrC
	89UUOrdFhgw4q7lNZ3LAlaaayrjEjvhb+BGGSaHOdG6M+dO78Tw16NAYCY4b1kuh
	crZlr98JGiOhHv1ODppEJsIq3TG8lndBmQg==
X-ME-Sender: <xms:qM1hZxG7N30o7mBtCUyGMlbgpQu5VfRoHMbLbAEI0xg43OZ6kit9IQ>
    <xme:qM1hZ2UIbtwA8OjI3iGycxTxSwIP6PVJnRoafqL8pkFL5qh3W2_tMdVM2w7LTtUXk
    NLDDgYMWBD7S__shJQ>
X-ME-Received: <xmr:qM1hZzKp4AC0Tyj3HgLERpvLA5kXrP84nzJ-_Xxfyuan1SKo2aYDguo3OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrleehgdduvdegucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:qM1hZ3FiptISB-liCqlVeZnsGEiFnqLOZ8xUJMQNoAjlr-2BD31R3Q>
    <xmx:qM1hZ3U0uSccAmcll7nyYijjN0PHnt5h5qQ3cpCoyrXZkuWstYgXIA>
    <xmx:qM1hZyMQv6GbpX-RAsMCiOrtRjv_0rAqGML3kEoqUT7KH9wekAgUFQ>
    <xmx:qM1hZ23iujNB-gyV_WiPaSRVOBBuV7_3sBCyisia2LtqCyt9yLN9-w>
    <xmx:qM1hZ9xxa3-1ikIJ7PNGlXqMIp_eoE2VrHy2_JzI0NWdusUd469jGYVe>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Dec 2024 14:14:47 -0500 (EST)
Date: Tue, 17 Dec 2024 11:14:46 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, axboe@kernel.dk,
	io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 7/9] io_uring: Introduce IORING_OP_CLONE
Message-ID: <Z2HNpmgUzUqXhFM_@localhost>
References: <20241209234316.4132786-1-krisman@suse.de>
 <20241209234316.4132786-8-krisman@suse.de>
 <4100233a-a715-4c62-89e4-ab1054f97fce@gmail.com>
 <Z1nLRcwaKPv7lAsB@localhost>
 <c51a815f-89f3-483d-bfc6-0f7877885aa8@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c51a815f-89f3-483d-bfc6-0f7877885aa8@gmail.com>

On Tue, Dec 17, 2024 at 11:03:27AM +0000, Pavel Begunkov wrote:
> On 12/11/24 17:26, Josh Triplett wrote:
> > On Wed, Dec 11, 2024 at 01:37:40PM +0000, Pavel Begunkov wrote:
> > > Also, do you block somewhere all other opcodes? If it's indeed
> > > an under initialised task then it's not safe to run most of them,
> > > and you'd never know in what way, unfortunately. An fs write
> > > might need a net namespace, a send/recv might decide to touch
> > > fs_struct and so on.
> > 
> > I would not expect the new task to be under-initialised, beyond the fact
> > that it doesn't have a userspace yet (e.g. it can't return to userspace
> 
> I see, that's good. What it takes to setup a userspace? and is
> it expensive? I remember there were good numbers at the time and
> I'm to see where the performance improvement comes from. Is it
> because the page table is shared? In other word what's the
> difference comparing to spinning a new (user space) thread and
> executing the rest with a new io_uring instance from it?

The goal is to provide all the advantages of `vfork` (and then some),
but without the incredibly unsafe vfork limitations.

Or, to look at it a different way, posix_spawn but with all the power of
io_uring available rather than a handful of "spawn attributes".

> > without exec-ing first); if it is, that'd be a bug. It *should* be
> > possible to do almost any reasonable opcode. For instance, reasonable
> > possibilities include "write a byte to a pipe, open a file,
> > install/rearrange some file descriptors, then exec".

