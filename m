Return-Path: <io-uring+bounces-5444-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A17419ED35A
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 18:26:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6E811670CF
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 17:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABBA1FECAF;
	Wed, 11 Dec 2024 17:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b="fThoqajJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="av+OjZMZ"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4E41F9F45
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 17:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733937995; cv=none; b=mNa+VaQoPzATvp/N7Xci74BnMxJ5wLps5vIjNAgrJloqqC5QYIsWw3OYg/hlqr132DrZ4W+uZoDzQNLJaHamGBMl9YuUZOVXiJvYK/iQ4EWCRHt0nAaGf1qWsgdmbc3e66DkYWNSAJRBmF4cc7oGt8q7kLn5r7Vk9FPbr2YiQdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733937995; c=relaxed/simple;
	bh=0DLBc0YB2AgZ/zHPBAc+RzrROjhQT69O+uruipA8xMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtePZ2036GPVG/3t+O2fqPWV45d8/jcLH/wkGScyWk9imVKvp9mnpa6dixhvXL8KnQDNmDHtbUZC3z+Jr9VS5DyxU0bMW0esUo4vj6Q9/1jh8a4BTZ6rZwe83PeetN7e7mEbaRP6b1GzPtsjwihgCtW40XKPeX6Q7hJrA7hl5TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org; spf=pass smtp.mailfrom=joshtriplett.org; dkim=pass (2048-bit key) header.d=joshtriplett.org header.i=@joshtriplett.org header.b=fThoqajJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=av+OjZMZ; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joshtriplett.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joshtriplett.org
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 84EC411400DB;
	Wed, 11 Dec 2024 12:26:31 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 11 Dec 2024 12:26:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	joshtriplett.org; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1733937991;
	 x=1734024391; bh=0DLBc0YB2AgZ/zHPBAc+RzrROjhQT69O+uruipA8xMM=; b=
	fThoqajJi92B1yFB/nUz5IKXYtjn6qeyJ8fGbDTpxSZDEcA5J7lzEJz4qRbUustF
	dPuEiLvxE/xQW072FVHlC4xIn3iaJr11B4k/djtqzjZYlOo9ib13KRKJmxEO1kkg
	t9VKYJsaWcUlWppRTA1iK9XWJR3ecQd0/icIVKURbGif2bnktDUrPX+R37o7gFvu
	00bvmwvXNxFALyBS3k3x5WzwWLrlr/U++TDEQJlU0jda5KsDbf5u14+VBZtYdh1W
	KcB05fwLVr1FVvJ9MUtMy03lXS0bpgVGpCOubhltvlGTSHb9ONomVefmo99/o7gK
	iBYUctYQygMBESz8AITWTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1733937991; x=1734024391; bh=0DLBc0YB2AgZ/zHPBAc+RzrROjhQT69O+ur
	uipA8xMM=; b=av+OjZMZXw5Maok75CvBj1LKEBwEVG+C4gCQt8T39XRHnz+4lyJ
	rYLHd+9n+kPD0ui4VSusTUF7AuuwaDjUYBX+QbBRPtLoJU0TjClcUt4+UFkPQ02a
	JoS0yRe6GVYbApKk453tzvhVLcj9a36O0U7aSn/Ck4i9Xx/jZOpNJBzhPvJ+lZUw
	O1cPa9LEOWLtvUjtqz+rGrIWWUn1UpQU1olFSf497g91LxNpXVL5senK3nCxPzKP
	F0vau6f4/GxCGMlsBMTQ91me+xt23AxPV/oPGosqyrY2rSz8SYiOETghxiN8Ooc8
	Z9J3pwGNCT0BB+csqtcNXw1OhvSBkPr+N+Q==
X-ME-Sender: <xms:R8tZZ4niGq3vNIsFyh2umbX832g9g8acdLjzhCHgWIOoMeXKjAMlYw>
    <xme:R8tZZ32mO8j7Za8ydf3b_zHP1qLSLvpI4snmeb0-0swRAFS5DlKqBkp4FGYttXJQW
    Ves7OxplGNTaRISt7k>
X-ME-Received: <xmr:R8tZZ2qJlrEPAL2gIPUknWUujS7FHdkTKe5CqxbMh2SHbm83-8a1Pwo0ek_2AKokiqyTqnDFGH1ixe6OqX2xKngFWnOQug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrkedtgddutddtucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:R8tZZ0kqKbsljbwuhKj5jtO9rv2lAkwGeFUHGE2sxNY9NdpkBlW5kQ>
    <xmx:R8tZZ21bFDIrDQb9KN9L3-sApxnT6uUfDbO-Nf--QfgDM_4ao26BwQ>
    <xmx:R8tZZ7t3Meyma1pF0sPMBNwbeLpBeK--tyONESbO2LVFkK02bMENvQ>
    <xmx:R8tZZyWOo_82h8Bkb6-T7BkSvaSnjz0IJByPX7vq8m3GR_B7awHDvA>
    <xmx:R8tZZ5TcqGSjVfbRu1XF3iuGlAoN4F7QxWeoAa0QgB2NbB3tDDGeQiiX>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Dec 2024 12:26:30 -0500 (EST)
Date: Wed, 11 Dec 2024 09:26:29 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, axboe@kernel.dk,
	io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 7/9] io_uring: Introduce IORING_OP_CLONE
Message-ID: <Z1nLRcwaKPv7lAsB@localhost>
References: <20241209234316.4132786-1-krisman@suse.de>
 <20241209234316.4132786-8-krisman@suse.de>
 <4100233a-a715-4c62-89e4-ab1054f97fce@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4100233a-a715-4c62-89e4-ab1054f97fce@gmail.com>

On Wed, Dec 11, 2024 at 01:37:40PM +0000, Pavel Begunkov wrote:
> Also, do you block somewhere all other opcodes? If it's indeed
> an under initialised task then it's not safe to run most of them,
> and you'd never know in what way, unfortunately. An fs write
> might need a net namespace, a send/recv might decide to touch
> fs_struct and so on.

I would not expect the new task to be under-initialised, beyond the fact
that it doesn't have a userspace yet (e.g. it can't return to userspace
without exec-ing first); if it is, that'd be a bug. It *should* be
possible to do almost any reasonable opcode. For instance, reasonable
possibilities include "write a byte to a pipe, open a file,
install/rearrange some file descriptors, then exec".

