Return-Path: <io-uring+bounces-11432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 03312CFC648
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 08:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 81E933004ECB
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 07:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3ECD2571A0;
	Wed,  7 Jan 2026 07:36:43 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5680926ED59;
	Wed,  7 Jan 2026 07:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767771403; cv=none; b=izs4LDDm1eeyuOsXXUlRlmMdfdLREcEgL6b5jXG+AXDoxsbpndNznNTnJJ2TScG7CqlgdxnSBiN7ta8qg2xLpdVSs4SO52cyOfDtgMmb60atXw3JZLvmU4kI1pACjJjPK8CkE2V11tynJGAUNYmKOJJm8v08oOL/fUwVzrqD2kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767771403; c=relaxed/simple;
	bh=DvC2d6O80zSDXFWkvBeIdKTiYVELIbllnOjfWZ27DHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TOyEzJmGgCNB+H0hIOcKdRKjivfmhigMEO6QaJ9EH278DcwGFAH/kIsr0k5X/UfiiG3pK3ZVjp7ZRXaG78lXFn8GDbwgByLXryCAH4iCm3SWmlwyj4Bch4FSgyqua4Tf/Ye14oFun+MWaA11iKpN6zkl7jxr2nAkjwK4Js/13fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 78F41227A87; Wed,  7 Jan 2026 08:36:39 +0100 (CET)
Date: Wed, 7 Jan 2026 08:36:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, io-uring@vger.kernel.org,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 05/11] fs: refactor ->update_time handling
Message-ID: <20260107073639.GC17448@lst.de>
References: <20260106075008.1610195-1-hch@lst.de> <20260106075008.1610195-6-hch@lst.de> <b208c2a6e1a3ab44e3c820af106b5be99279d986.camel@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b208c2a6e1a3ab44e3c820af106b5be99279d986.camel@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 06, 2026 at 07:09:04AM -0500, Jeff Layton wrote
> On Tue, 2026-01-06 at 08:49 +0100, Christoph Hellwig wrote:
> > Pass the type of update (atime vs c/mtime plus version) as an enum

[...]

I scrolled through this but only found a full quote but no actual reply
from you.

Can you please follow standard email protocol and only quote relevant
parts?


