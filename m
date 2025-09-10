Return-Path: <io-uring+bounces-9706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE50B518D7
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 16:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94F6A188B4CD
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 14:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8868E322A0E;
	Wed, 10 Sep 2025 14:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=donacou.ch header.i=@donacou.ch header.b="l9tlwE/C";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dMrrQkSs"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FDB26FA77;
	Wed, 10 Sep 2025 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757513051; cv=none; b=TiPGNG03qMw2cEC5oifsRQvAxzvri6NioKLiyMX2X4YVU28p2dPCjZjM7k0kpiPsKqK9R5uaHisE743UpqvxJceuAFgJ3ClPuE9kT8Ha1k7RnyTq76CP7hoxPs0cD90EVZQ6iLMLFZDdhpBSc36P3ptWt4IM4uC2CkQZcsPxKoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757513051; c=relaxed/simple;
	bh=uUFAoktO277xXwHHnswYPQKvbx+QmoiX+wDMEuUdm/g=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=s0W+Yyw1d/Q/SCwybxuv8nY3SKyq/rVN5DTuPopJMnjN0L0fI+ZU6tHne2AJsNripfjfTWxJp/CbOFJJDIxts3stV9baivUugeco3l3Chp45+pGpAy3jEN7iBDyLFDlWCvUvDe5ccKHA3OX/O4cIW5Lj1e3ToFlRHcTebdZ6v50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=donacou.ch; spf=pass smtp.mailfrom=donacou.ch; dkim=pass (2048-bit key) header.d=donacou.ch header.i=@donacou.ch header.b=l9tlwE/C; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dMrrQkSs; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=donacou.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=donacou.ch
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id E660CEC044E;
	Wed, 10 Sep 2025 10:04:07 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-06.internal (MEProxy); Wed, 10 Sep 2025 10:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=donacou.ch; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1757513047;
	 x=1757599447; bh=3Nuaa+FoSrAxipH9n0l4tF6X+2obMMAQMJqsmRgL2c8=; b=
	l9tlwE/C9WUogEbHgyOlQIf0QymIUkvJyMxRMPitRzg/FkZD9P29HGA/jBJJaT5Z
	hIMQ8XX8s1/UKj109XkhUxpmTnkoMFpBr4OgCBgEYIaGbn/1Ixmt542YXlla65Gt
	xEnGHwyQ7VRfLRcHHN1/xnuLZvPdq+n0gvmzE53rYXZCJO56vcIX1BWNodzVl94O
	C5Lqr+T2eHOm7g6fBfdScHByTEo9qBrZf+KSv/w5vGo0EMDOZDWrPtG9pNduokSm
	VqdXt/WrUN1uQ4+GKOfAfA/WM9+C1yXzTruyDT16lHh5R0Rl4r/RzZH/I6qdmf3I
	msozoe4B0v/vQ6zLp3fjCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1757513047; x=
	1757599447; bh=3Nuaa+FoSrAxipH9n0l4tF6X+2obMMAQMJqsmRgL2c8=; b=d
	MrrQkSsXutiVu49JEqI6vnAFpKvT8A6QNqvfM9kPFvVCVSSaaPAPYQnJclPCpGsp
	SdjQuOvrJ/jb6SE3iGQ4qBkWgu4EbQbkkCrWXSsYvMMV8+Ko2YVylXT335au1vQI
	craNWyKZOwCYjeGMqIdt1Y+A+ElKK+kazHb1c30gkDJMl9GOeFg325dDwXZxL6xJ
	w1/xsTIY3pYom5hE5rWbqCNHtwko+lHJTGGVafRclV1f+jDlUvrhCnhXJH7S7xYh
	YfUB02q3CTpJgGgX99GLroYIaP+zc8U+Ubkoc/zsThr4ISyBuk8WpVSAjGCGbXtf
	sy+5NIajuS0UNRQ+AxDtg==
X-ME-Sender: <xms:V4XBaG8fEFhl1flxgvC3qg_bRGSEPGU8e5cZuM8WiH3DJMUMLhJAmw>
    <xme:V4XBaGs4ZX-O_x2EggLhVA-fohGgdBDE51IQviKCsOO3p13ZbVo5VXlIca3K7p6Uv
    Uc4YqMNU0y0dah2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeegkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetnhgurhgv
    ficuffhonhgrqdevohhutghhfdcuoegrnhgurhgvfiesughonhgrtghouhdrtghhqeenuc
    ggtffrrghtthgvrhhnpeejteduiedtfffhhfffgeevvdefheduheegjeduteffteduvdfh
    jeegffduledvieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegrnhgurhgvfiesughonhgrtghouhdrtghhpdhnsggprhgtphhtthhopeekpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehlrghurhgvnhhtrdhpihhntghhrghrth
    esihguvggrshhonhgsohgrrhgurdgtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhn
    vghlrdgukhdprhgtphhtthhopehsrghshhgrlheskhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgt
    phhtthhopehkohhnshhtrghnthhinheslhhinhhugihfohhunhgurghtihhonhdrohhrgh
    dprhgtphhtthhopegtshgrnhguvghrsehpuhhrvghsthhorhgrghgvrdgtohhmpdhrtghp
    thhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epfihorhhkfhhlohifshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:V4XBaMJrumzWH892lXeHhEz1bgXykBCz7cc4cjp1iFta4-7ByKla3Q>
    <xmx:V4XBaC5-y92JbCH0zV4XUAn-VIl5bgNzyHLGZddtUdQWP01TJRbP3g>
    <xmx:V4XBaOftHaxM-2tiHzDrJju2TOWDpwHj-4TGhCXPGPbgVrBhJji-UA>
    <xmx:V4XBaFGqjVZBWIpW557ZR195MEUdh9izNqns44KGWhDb_hPL2G2HzQ>
    <xmx:V4XBaPQyIRrl_KVyuOwUGZpIDcjEIsafSbI9rSsAdoIjChsta8nMA8cz>
Feedback-ID: i594043eb:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 41D8A78026F; Wed, 10 Sep 2025 10:04:07 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A6d2yW3kTJ_V
Date: Wed, 10 Sep 2025 10:03:40 -0400
From: "Andrew Dona-Couch" <andrew@donacou.ch>
To: "Konstantin Ryabitsev" <konstantin@linuxfoundation.org>,
 "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Sasha Levin" <sashal@kernel.org>, axboe@kernel.dk,
 csander@purestorage.com, "io_uring Mailing List" <io-uring@vger.kernel.org>,
 torvalds@linux-foundation.org, workflows@vger.kernel.org
Message-Id: <ce7536b4-e83c-4a0f-a46a-0bb0c8eb3610@app.fastmail.com>
In-Reply-To: <20250910-augmented-ludicrous-tortoise-0a53bd@lemur>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <20250909163214.3241191-1-sashal@kernel.org>
 <20250909172258.GH18349@pendragon.ideasonboard.com>
 <20250910-augmented-ludicrous-tortoise-0a53bd@lemur>
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

What a remarkable discussion!  The arguments being made lay bare an important difference in perspective.

> you're still choosing to attack because it's LLM based and you have something
> personal against that.

This argument seems an utter abrogation of an engineer's core responsibility to understand the tools they use.  The concerns raised against LLMs here were specific and technical, were they not?

> I don't want to go too far down the "wasting resources path," because,
> honestly, a kid playing videogames for a weekend will waste more power than a
> maintainer submitting a couple of threads for analysis.

Quite disingenuous to treat the marginal cost of a single search as if it accounted for the true cost to society of making the product available.

I appreciate the careful consideration of maintainers here who work to keep the focus of development on real humans and a thoughtful and deliberative processes.

Thanks,
Andrew




-- 
We all do better when we all do better.  -Paul Wellstone

On Wed, Sep 10, 2025, at 09:38, Konstantin Ryabitsev wrote:
> On Tue, Sep 09, 2025 at 08:22:58PM +0300, Laurent Pinchart wrote:
>> On Tue, Sep 09, 2025 at 12:32:14PM -0400, Sasha Levin wrote:
>> > Add a new 'b4 dig' subcommand that uses AI agents to discover related
>> > emails for a given message ID. This helps developers find all relevant
>> > context around patches including previous versions, bug reports, reviews,
>> > and related discussions.
>> 
>> That really sounds like "if all you have is a hammer, everything looks
>> like a nail". The community has been working for multiple years to
>> improve discovery of relationships between patches and commits, with
>> great tools such are lore, lei and b4, and usage of commit IDs, patch
>> IDs and message IDs to link everything together. Those provide exact
>> results in a deterministic way, and consume a fraction of power of what
>> this patch would do. It would be very sad if this would be the direction
>> we decide to take.
>
> I don't want to go too far down the "wasting resources path," because,
> honestly, a kid playing videogames for a weekend will waste more power than a
> maintainer submitting a couple of threads for analysis.
>
> I've already worked on plugging in LLMs into summarization, so I'm not alien
> or opposed to this approach. I'd like to make this available to maintainers
> who find it useful, and completely out of the way for those maintainers who
> hate the whole idea. :)
>
> Best wishes,
> -K

