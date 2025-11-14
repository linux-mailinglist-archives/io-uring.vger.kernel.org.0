Return-Path: <io-uring+bounces-10639-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B5DDEC5E406
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 17:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2E8143880F6
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 15:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7763E32ED52;
	Fri, 14 Nov 2025 15:28:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61DA32ED45;
	Fri, 14 Nov 2025 15:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763134130; cv=none; b=h/uLTsPzdQ9kFB7kf7/t3VgEtMc0UqmqyARUrruxtVgn1WqE9BsMSYMrbCA2o8MM34Iou6rMjGj7yG1WC4sKljufh3pz2PBMsRkbNFB4+GerGcUROxzJzHQV7MgWobLnaaLAU4kuo5Os/HyPihx2gi/tJTEhOOdlm4xuMs2u5m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763134130; c=relaxed/simple;
	bh=BM70eZB9FbP/9B/6S//Ss+GV4VqUXiu6YIrLW20c0A4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nEKr+mYtwDnIGLcc0187bGK5pDJZJ+7PMMkShGufCO+vjBkKTPG45IWnrCH88DANNc+CbAU4/rtJBHw68Fw6aHpbWxhD1wsgJFi1NdprwOl3vBf69bMpciCxaw5XABUzwqNcBVfisTj7I5NNa0tpULAnleQkUfELPCqLLsxc4CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBCCD227A88; Fri, 14 Nov 2025 16:28:40 +0100 (CET)
Date: Fri, 14 Nov 2025 16:28:40 +0100
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
Subject: Re: re-enable IOCB_NOWAIT writes to files
Message-ID: <20251114152840.GD30351@lst.de>
References: <20251114062642.1524837-1-hch@lst.de> <b7e8d5e3a0ce8da103f4591afc1f4a9c683ef3c7.camel@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7e8d5e3a0ce8da103f4591afc1f4a9c683ef3c7.camel@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 14, 2025 at 09:04:58AM -0500, Jeff Layton wrote:
> This all looks pretty reasonable to me. There are a few changelog and
> subject line typos, but the code changes look fine. You can add:

Please tell me about them so I can fix them. 

> As far as nfsd's usage of FMODE_NOCMTIME, it looks OK to me. That's
> implemented today by the check in file_modified_flags(), which is
> generic and should work across filesystems.

Nothing requires file_update_time / file_modified_flags are helpers
that a file system may or may not call.  I've not done an audit
if everyone actually uses them.


