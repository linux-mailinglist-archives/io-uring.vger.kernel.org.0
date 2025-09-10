Return-Path: <io-uring+bounces-9705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0117BB51809
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 15:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B05E1175160
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 13:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B33306B33;
	Wed, 10 Sep 2025 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKsGywPG"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0ED1494CC;
	Wed, 10 Sep 2025 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757511491; cv=none; b=LclHJiAAIVi4pdaUhXQ7uIcUkL9PzulumGUEkA853trsk0h1BchSaef5LnLGfCwJ6lYHLfZJ9KoikGk5SXZcndSbBzQezHH/i8VkZCxzhu9xMPeNNwROa9Xc9yO8TcD8STWQSkC2XfcjCLeZ0mdL9YdelO2gB+Jb8tqr4Q0rRPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757511491; c=relaxed/simple;
	bh=OLQSadqn5sk7Ywbb2Knr3epvYKMxJSzK4qTU8lUhQns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OfvxXjsFcKWWwriAn+Uecc8bXS+EL++FRC19PXlviMHscbhfUy6F+S+Qpzfnxuc7qbXF5Tj7+f0TEps6oFAg7kSlE1pKchbsvIsZuwMrzQXicIIm3pLBDX0/oRap1/Pmil6LE28snhAW3IaSLqZlfzokJi7IZYVNFjGCwW12bzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKsGywPG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1115DC4CEF0;
	Wed, 10 Sep 2025 13:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757511491;
	bh=OLQSadqn5sk7Ywbb2Knr3epvYKMxJSzK4qTU8lUhQns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qKsGywPGCBoq7Z0SnP6tkDmpnlZkhXSTMKKH1ZAiPLFAXwMKe07C4m3RngBFq1t1M
	 QDB70Q1Qim8E5IcBPUr7KZJFuyNTuO1At6m/aUst7wVSVvQTpJlxo3sqGLXFiYkcLx
	 ECKJMgZJ2DpimqURtoGP3pGKins8aWGhAagolpmY=
Date: Wed, 10 Sep 2025 09:38:09 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sasha Levin <sashal@kernel.org>, axboe@kernel.dk, 
	csander@purestorage.com, io-uring@vger.kernel.org, torvalds@linux-foundation.org, 
	workflows@vger.kernel.org
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <20250910-augmented-ludicrous-tortoise-0a53bd@lemur>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <20250909163214.3241191-1-sashal@kernel.org>
 <20250909172258.GH18349@pendragon.ideasonboard.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250909172258.GH18349@pendragon.ideasonboard.com>

On Tue, Sep 09, 2025 at 08:22:58PM +0300, Laurent Pinchart wrote:
> On Tue, Sep 09, 2025 at 12:32:14PM -0400, Sasha Levin wrote:
> > Add a new 'b4 dig' subcommand that uses AI agents to discover related
> > emails for a given message ID. This helps developers find all relevant
> > context around patches including previous versions, bug reports, reviews,
> > and related discussions.
> 
> That really sounds like "if all you have is a hammer, everything looks
> like a nail". The community has been working for multiple years to
> improve discovery of relationships between patches and commits, with
> great tools such are lore, lei and b4, and usage of commit IDs, patch
> IDs and message IDs to link everything together. Those provide exact
> results in a deterministic way, and consume a fraction of power of what
> this patch would do. It would be very sad if this would be the direction
> we decide to take.

I don't want to go too far down the "wasting resources path," because,
honestly, a kid playing videogames for a weekend will waste more power than a
maintainer submitting a couple of threads for analysis.

I've already worked on plugging in LLMs into summarization, so I'm not alien
or opposed to this approach. I'd like to make this available to maintainers
who find it useful, and completely out of the way for those maintainers who
hate the whole idea. :)

Best wishes,
-K

