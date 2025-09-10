Return-Path: <io-uring+bounces-9700-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DC14B513A0
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 12:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B26556334D
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 10:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC7C2314A8D;
	Wed, 10 Sep 2025 10:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="J1toTbC0"
X-Original-To: io-uring@vger.kernel.org
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120B73126B5;
	Wed, 10 Sep 2025 10:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.167.242.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499248; cv=none; b=XK0Aw+uitbjPjlH4sz4hDuraN3bwRfuQWhyUJDoF/E+a4bxwDZNtQN1AVsf1a4hRVchDpbtxw4U98wAuKgyEswtLw0bWP2Q0SKlO/+pm976z4JvZYD2d0T26PgEvAiEtva6k++hEkAAV+pG8dqVAUgE11KpPHszEijRPUJzIUcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499248; c=relaxed/simple;
	bh=Ju9IhFGWUedr02UBHhYV41hTSD6lcTpnCP+UJ4XoX74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQme6MFRAYmjb1uOyLg3uUaaQBgQ9PkAHp4Gt71557rpgSgqe8vI4m1KGcpsoMjGjFUE7bzTT4OdJ7uOIdiNLbg7H2TwZ+iIxKzA4l4xqq8F4E7P29NfxwWcunyX8FIJlkHiX0oRyikVse9fgSVbdGq33gOqVnzXkVXIoECN/NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com; spf=pass smtp.mailfrom=ideasonboard.com; dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b=J1toTbC0; arc=none smtp.client-ip=213.167.242.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideasonboard.com
Received: from pendragon.ideasonboard.com (81-175-209-231.bb.dnainternet.fi [81.175.209.231])
	by perceval.ideasonboard.com (Postfix) with UTF8SMTPSA id 9546AC6F;
	Wed, 10 Sep 2025 12:12:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1757499171;
	bh=Ju9IhFGWUedr02UBHhYV41hTSD6lcTpnCP+UJ4XoX74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J1toTbC0HaVbEB35LQl1Cf0s6f6QX+8pxZinL9WhLEOBzqQZ/wGr4FIhZIDZ2pcQp
	 GB74W7wm2vDjcIpe7/ZHB4OucQtDc8T2uRDotbR1R6VQfTbrgE/VyMeiTIVSolWgZO
	 s+FHco2w6L1glxDVS8J6nDO68ljjMV3wWOrFVgms=
Date: Wed, 10 Sep 2025 13:13:42 +0300
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, konstantin@linuxfoundation.org,
	csander@purestorage.com, io-uring@vger.kernel.org,
	torvalds@linux-foundation.org, workflows@vger.kernel.org
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <20250910101342.GD20904@pendragon.ideasonboard.com>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <20250909163214.3241191-1-sashal@kernel.org>
 <20250909172258.GH18349@pendragon.ideasonboard.com>
 <72dd17ad-5467-49d3-9f40-054b1bf875d5@kernel.dk>
 <aMB3_VgB4mwp-bzP@laps>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aMB3_VgB4mwp-bzP@laps>

On Tue, Sep 09, 2025 at 02:54:53PM -0400, Sasha Levin wrote:
> On Tue, Sep 09, 2025 at 11:26:19AM -0600, Jens Axboe wrote:
> > On 9/9/25 11:22 AM, Laurent Pinchart wrote:
> >> On Tue, Sep 09, 2025 at 12:32:14PM -0400, Sasha Levin wrote:
> >>> Add a new 'b4 dig' subcommand that uses AI agents to discover related
> >>> emails for a given message ID. This helps developers find all relevant
> >>> context around patches including previous versions, bug reports, reviews,
> >>> and related discussions.
> >>
> >> That really sounds like "if all you have is a hammer, everything looks
> >> like a nail". The community has been working for multiple years to
> >> improve discovery of relationships between patches and commits, with
> >> great tools such are lore, lei and b4, and usage of commit IDs, patch
> >> IDs and message IDs to link everything together. Those provide exact
> >> results in a deterministic way, and consume a fraction of power of what
> >> this patch would do. It would be very sad if this would be the direction
> >> we decide to take.
> >
> > Fully agree, this kind of lazy "oh just waste billions of cycles and
> > punt to some AI" bs is just kind of giving up on proper infrastructure
> > to support maintainers and developers.
> 
> This feels like a false choice: why force a pick between b4-dig-like tooling
> and improving our infra? They can work together. As tagging and workflows
> improve, those gains will flow into the tools anyway.
> 
> It's like saying we should skip -rc releases because they mean we've given up
> on bug free code.

I really have trouble thinking this is a honest argument. We're
discussing the topic in the context of a project where we reject
thousands of patches all the time when they don't go in the right
direction.

Throwing an LLM at the problem is not just a major waste of power, it
also hurts as it will shift the focus away from improving the
deterministic tools we've been working on. Using an LLM here only
benefits the companies that make money from those proprietary tools.

> Perfect is the enemy of the good. You're arguing against a tool that works now,
> just because it's not ideal, and to chase perfection instead. I'd rather be
> "lazy" and skip the endless lore hunts.

Nobody will stop you from being lazy or anything else. I'll however push
back against the bad influence on others.

-- 
Regards,

Laurent Pinchart

