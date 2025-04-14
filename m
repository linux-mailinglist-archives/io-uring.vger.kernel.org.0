Return-Path: <io-uring+bounces-7456-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFFA3A87D20
	for <lists+io-uring@lfdr.de>; Mon, 14 Apr 2025 12:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 881471712FA
	for <lists+io-uring@lfdr.de>; Mon, 14 Apr 2025 10:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8952265601;
	Mon, 14 Apr 2025 10:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnnv8NV0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4DB264FB2;
	Mon, 14 Apr 2025 10:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744625419; cv=none; b=bnvNCPKHXD8Qa3vCNWim9Bfgmbj8R6UV/Jz3W2tbIaioEOkT5Gwp04jxAF/f4QRq+vYRq1MyJQLXyfhpaHIXxLbMt9+qANytOiAIXQtuowG+4lAjvOa6l7ALyGOoPfZihZa6p9CCu3WyyLIlOJB6T/0HbrlltGjKL/O5+pu0Cg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744625419; c=relaxed/simple;
	bh=iCioN6LF6iNblfboM6DaqDV8WyMze/RA3c88M9EvxYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KcspASn6383M/dVpuxcLfW06ujvpNABbnmm7WuR+UTNi69zPEsiNdq8INlkiEL8htlmkNg3SeckAw8DjNDTqIlVb4NFVkpEkaQfqDTxctAZBOtQuImOoC0+dsDrLEzx9S3yMDBn6t35Bl+fY16LlJLe3BOk1mGr2OPEdjtXlTxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnnv8NV0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FC1C4CEE2;
	Mon, 14 Apr 2025 10:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744625414;
	bh=iCioN6LF6iNblfboM6DaqDV8WyMze/RA3c88M9EvxYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bnnv8NV0edc7rpet+ps0Y/FDPgio/eDpwYy/Ue4YEddWXZaQxJHfPqma8nc4cBWnY
	 F2dkQfawoW0tEaJcfT/wBOtOC2vDHyrkOesMqGehqFMX0HWd4/HzpIUyrNpIVtaU2J
	 VJGLX3YrX63AY7fD75ZG0LKiZTgYWGWi7s6tJPvJwarAmejC547d9g1ss45gs+5nfh
	 kUwEupq5Qt1upeLXvsrtHwwWlnFy7R77hgbb3uLBAGb/I7u5STdPHh1ri5uPSWRfxR
	 MWHvEkxo08vUAd9VJD6eZc5pa+6paHENgnhweYPzdQAL6kAke7aKJn57k7YdzGT4XP
	 sZhJwpemVkHhg==
Date: Mon, 14 Apr 2025 12:10:10 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/5] fs: gate final fput task_work on PF_NO_TASKWORK
Message-ID: <20250414-unwiderruflich-daheim-8e14b89e7845@brauner>
References: <20250409134057.198671-1-axboe@kernel.dk>
 <20250409134057.198671-2-axboe@kernel.dk>
 <20250411-teebeutel-begibt-7d9c0323954b@brauner>
 <87fcae79-674c-4eea-8e65-4763c6fced44@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87fcae79-674c-4eea-8e65-4763c6fced44@kernel.dk>

On Fri, Apr 11, 2025 at 08:37:51AM -0600, Jens Axboe wrote:
> On 4/11/25 7:48 AM, Christian Brauner wrote:
> > Seems fine. Although it has some potential for abuse. So maybe a
> > VFS_WARN_ON_ONCE() that PF_NO_TASKWORK is only used with PF_KTHREAD
> > would make sense.
> 
> Can certainly add that. You'd want that before the check for
> in_interrupt and PF_NO_TASKWORK? Something ala
> 
> 	/* PF_NO_TASKWORK should only be used with PF_KTHREAD */
> 	VFS_WARN_ON_ONCE((task->flags & PF_NO_TASKWORK) && !(task->flags & PF_KTHREAD));
> 
> ?

Yeah, sounds good!

