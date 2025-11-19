Return-Path: <io-uring+bounces-10659-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 439CBC6CE99
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 07:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B49894E5E1E
	for <lists+io-uring@lfdr.de>; Wed, 19 Nov 2025 06:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD150314B69;
	Wed, 19 Nov 2025 06:25:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A403148B7;
	Wed, 19 Nov 2025 06:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763533512; cv=none; b=h/5ci0kHermGe4ivdn7HeHd9GeNnJNiCACYdkSFY0o31/HXTbkVba5t18NbFc48wuaEuPymnKj1+6/97oeM5bCf6X+ehEbLMMCu5TrvuuqIUDkQLZqrgmcxgpU/GAGzgt1THsB+fLP4LWyXTf7dgHcZyY7VSu6Z4F70RHhsKfoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763533512; c=relaxed/simple;
	bh=AqAHNkrHxx42jEBoafUC+KtV3iXc+xj17wNWRju+99A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5uYNvxLjaRh5Rl5dc0gUk8Y8olYpCY9K6IDAvdGHnf/84W9jy9nXD7kKHLkJhYODykSDtBHgFu5VFm4LiozYucUHKXA5k4eJD4wICY/cdULDdZ3mR4nf7QPk8P51iRngWSP93PA1RAUe34TQw9k7skssKZ4hien/EpwwbPwHH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C1E6768AFE; Wed, 19 Nov 2025 07:25:01 +0100 (CET)
Date: Wed, 19 Nov 2025 07:25:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
	Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Carlos Maiolino <cem@kernel.org>, Stefan Roesch <shr@fb.com>,
	Jeff Layton <jlayton@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"gfs2@lists.linux.dev" <gfs2@lists.linux.dev>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"devel@lists.orangefs.org" <devel@lists.orangefs.org>,
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 05/14] fs: remove inode_update_time
Message-ID: <20251119062501.GA20592@lst.de>
References: <20251114062642.1524837-1-hch@lst.de> <20251114062642.1524837-6-hch@lst.de> <813f36d3-2431-4266-bb2e-faa3fc2a8fd7@nvidia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <813f36d3-2431-4266-bb2e-faa3fc2a8fd7@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 17, 2025 at 06:59:25AM +0000, Chaitanya Kulkarni wrote:
> > -	ret = inode_update_time(inode, sync_mode);
> > +	if (inode->i_op->update_time)
> > +		ret = inode->i_op->update_time(inode, sync_mode);
> > +	else
> > +		generic_update_time(inode, sync_mode);
> >   	mnt_put_write_access_file(file);
> >   	return ret;
> >   }
> 
> do you need to catch the value from generic_update_time() to match
> if case ? although original code was returning 0 for generic_update_time()
> case :

Yes.  It doesn't matter for this series, but it's good future-proofing.


