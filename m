Return-Path: <io-uring+bounces-10638-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DC922C5E1EF
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 17:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 85FFE4EC89E
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 15:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 557F832939D;
	Fri, 14 Nov 2025 15:26:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8EA32939F;
	Fri, 14 Nov 2025 15:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763133978; cv=none; b=Kvyu3igmd5fqIja0MkZlxF5oJciST+nNOk+x6RB+qS0jTQ7K3+txVr9uAa/r/bk8wBt+gKoZsRP16MRq/+nfnczrfxbOnqrU96FZDJp4i6eViq7gReolrTTqMplXYKNcjZ/Je7Ug3h5AM7rKI5d794G4Nr4FZDCOBkg8p+xA1O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763133978; c=relaxed/simple;
	bh=VvRjqszoVk+17tn2dfFxpE53PNejpQcUr9D5zeuyduI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gAmi7tGSVapH02CNSAPAx/DG5a2r6uXwJo2ZcugghB80rCmMbTaX4DtyRj+cWJu/suRVNv8B8TlHiNMDt47zzBD/ghVg6HmTwnejzB/jWoawWzGUXBYuO8xUxyElYwh5zVnHVSQpTbIBuPvM+CZOJgZ9y8ZqojPTVFjDPpXWVuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7A538227A88; Fri, 14 Nov 2025 16:26:11 +0100 (CET)
Date: Fri, 14 Nov 2025 16:26:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, io-uring@vger.kernel.org,
	devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 06/14] organgefs: use inode_update_timestamps directly
Message-ID: <20251114152611.GC30351@lst.de>
References: <20251114062642.1524837-1-hch@lst.de> <20251114062642.1524837-7-hch@lst.de> <4990df3273eb868aa21dde745c1ae2636af4cdd8.camel@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4990df3273eb868aa21dde745c1ae2636af4cdd8.camel@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 14, 2025 at 09:06:33AM -0500, Jeff Layton wrote:
> Please do fix the spelling of orangefs in the subject line. It'll be
> hard to grep for otherwise...

Ooops, sorry.


