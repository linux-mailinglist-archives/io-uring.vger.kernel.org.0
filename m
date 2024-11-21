Return-Path: <io-uring+bounces-4947-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9639D5601
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 00:03:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 494051F214F7
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 23:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD1A1D89FD;
	Thu, 21 Nov 2024 23:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gDlZm9Ed"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E651DACB8
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 23:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732230234; cv=none; b=cfkysK7sQCH+rq+kkzkAfisr8jZEsB7QpWHaWKURt8pK21Adi07EOUaCl/EkdNBJaHqlVzP7kXnk/i//I0T7tH4mJbj6FonNZ8u3OsFAE7yiDQoXG0tqN+ovTLkEgW54vNTwjgyNNDPVIJ/+EH4XpM99NksAUDGRubo4umhKbyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732230234; c=relaxed/simple;
	bh=4bIsON2htK0P0eKxlrP++9d4af9WOy0gCTsP7linEr8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bWLWL01QspuyRNZNdmhHRhQshUR2jFEHrRxwtTOY+UBev8eWjzA2m7tMaHoJvLRyTOhkAgaiW90XeWYUBLNIH5t6jycOEDW43eQGLSvXtRaMw8B6EI8Rc4S7FFG3hId7dBzPVnGr4bnAKeLG/WNmvoQMyZfupBk8kxbLWCSj9ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gDlZm9Ed; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3C51A254021E;
	Thu, 21 Nov 2024 18:03:51 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 21 Nov 2024 18:03:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1732230231; x=1732316631; bh=yBt54T6Z7Wdu9jSCdeNN3k62g9FFWJtWhbB
	w8fda7UI=; b=gDlZm9EdSmXRXAV2K0gMmeTsHxl/lq/ehOO7MlZNk+MjcRPuFc1
	NGZLNXAszgCp76uLGeEvLIEPhqCLzLCXehYPOh/LPGrULZ51XpwPBSvmErMCVsUx
	jrTso+Bob4sDtA32WzbZwCgPESpWQd7zLqeT/r51fZSacdO6lqSHo+2vdmLKw8om
	95U2/42vQlJh7l7vAIpCf59Ad/xYwhkRnv6a+vFlbuU818t0XOV1uDPm64XNu+H5
	wWGTc8c2MHlhJF1ye2W8RNN6yux4sDmIUXVIbpxcorWyXDHuE/SBiEzS8f1Jl5RZ
	slLIBCg1baYnp7EWW1qsIc8XF0d2epKAurA==
X-ME-Sender: <xms:Vrw_Zy9IsepOpc6NTqvmIFCOSmuqiJ53X02JERkjzmdKuYvvcRnMdQ>
    <xme:Vrw_ZysSoMlj5QtNcWf9hEALH88F9M4GvFEcDhufC9n3VxLTdHE-nksnfGHy5cuZX
    TThuOY9u7f0NNuXLkY>
X-ME-Received: <xmr:Vrw_Z4C2fqpQDBbtOwQ0wcnPqSg1LHfjTufhV6sQdmw4jrIDUD5ph7Us6ticO2eSgtwTl-yaaug9npvbww5_ngcTzqTjU7qgWOM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrfeejgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpeffhffvvefujgfkfhggtgesthdtredttddtvdenucfh
    rhhomhephfhinhhnucfvhhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdroh
    hrgheqnecuggftrfgrthhtvghrnhepieetuefgfffgveefteeitdefffduudduleevveev
    leevuddtgfeugfeklefhvddvnecuffhomhgrihhnpegsohhothhlihhnrdgtohhmnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthhgrihhn
    sehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtohephedpmhhouggvpehsmh
    htphhouhhtpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthho
    pehgvggvrhhtsehlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopehlihhnuhigse
    hrohgvtghkqdhushdrnhgvthdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmieekkheslhhishhtshdrlh
    hinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:Vrw_Z6cgzvIsjteu4i70YyAHUhowS2UXjM14iPIoOuubXaLW38M8TA>
    <xmx:Vrw_Z3O1Ubti96jPBCyrCaAJ5U67vIcnjk5mWHrCbapvta30VmfryA>
    <xmx:Vrw_Z0kwuqslyx8KTAaNL7G5BS4a4Wv4qIfoXztD_XDu4lK_uJUGXQ>
    <xmx:Vrw_Z5u2kamRMYUN6a02y5WECaCRBx6IhD-a0m3NJ3HxqWHLefJe-A>
    <xmx:V7w_Z8pdi1q14fwv1sEqTF1toY4BJDtv5Vo4txY6YCX-dLJPFIYD2JnS>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Nov 2024 18:03:48 -0500 (EST)
Date: Fri, 22 Nov 2024 10:04:20 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Jens Axboe <axboe@kernel.dk>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, 
    Guenter Roeck <linux@roeck-us.net>, io-uring@vger.kernel.org, 
    linux-m68k <linux-m68k@lists.linux-m68k.org>
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU
 io_kiocb cache
In-Reply-To: <5a7528c4-4391-4bd9-bbdb-a0247f3c76a9@kernel.dk>
Message-ID: <19a859ee-a2f8-231b-121b-bcd6df3f7ae5@linux-m68k.org>
References: <20241029152249.667290-1-axboe@kernel.dk> <20241029152249.667290-4-axboe@kernel.dk> <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net> <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk> <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net>
 <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com> <5a7528c4-4391-4bd9-bbdb-a0247f3c76a9@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Tue, 19 Nov 2024, Jens Axboe wrote:

> On 11/19/24 10:49 AM, Geert Uytterhoeven wrote:
> 
> > 
> > The minimum alignment for multi-byte integral values on m68k is 2 
> > bytes.
> > 
> > See also the comment at 
> > https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tree.h#L46
> 
> Maybe it's time we put m68k to bed? :-)
> 

When Linux ceases to implement Unix, it may well lose its relevance to 
systems which were designed to run Unix. That hasn't happened yet, AFAIK.

If the legacy Unix ABI were to be replaced, would it need syscalls at all? 
Could io_uring offer a better alternative, for a hypothetical new ABI?

