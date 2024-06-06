Return-Path: <io-uring+bounces-2133-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1EB58FDE32
	for <lists+io-uring@lfdr.de>; Thu,  6 Jun 2024 07:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 212982872DC
	for <lists+io-uring@lfdr.de>; Thu,  6 Jun 2024 05:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8EC3AC0F;
	Thu,  6 Jun 2024 05:41:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850D7CA6F;
	Thu,  6 Jun 2024 05:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717652511; cv=none; b=QqUhxkka2lVneQfL7I6lYSYCwAr36RbEhc5dMdeTR0fC+nycUdcKsd8XKTVv7Zy0AiFxPAukhj6bHEHK+R5ffDA+2ggR87oHHuqa6uNdfDjsXLjqMBl9nx8r9ZkagiM9CP7OWNe26zRSAMq38bgBRfBh84/JbFX0tQmYs+Uk0ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717652511; c=relaxed/simple;
	bh=8HB3h2MFtgnlhVUGhlc62c46kh4NgGxbN7o6c6UXwRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFf4g+XdSFfHNxKRMVI5DVLF+CUzRHC48JDDwC/F8XBRVQe24TKnTBDJoFTbGVuyCE0bwC2gAFXn7J+WJROY4vYJTH22x6b/bpmCHaKTkYsavp0gDhZBzeR8LKo36IEH8dSnI/oXocKTA4cDh3N80mocOlsh/z2hNFOsGz4Pvro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5391A68CFE; Thu,  6 Jun 2024 07:41:44 +0200 (CEST)
Date: Thu, 6 Jun 2024 07:41:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
	djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	dchinner@redhat.com, jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org,
	Prasad Singamsetty <prasad.singamsetty@oracle.com>
Subject: Re: [PATCH v7 2/9] fs: Initial atomic write support
Message-ID: <20240606054143.GB9123@lst.de>
References: <20240602140912.970947-1-john.g.garry@oracle.com> <20240602140912.970947-3-john.g.garry@oracle.com> <20240605083015.GA20984@lst.de> <fbb835ff-f1ae-4b59-8cb3-22a11449d781@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbb835ff-f1ae-4b59-8cb3-22a11449d781@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 05, 2024 at 11:48:12AM +0100, John Garry wrote:
> I have no strong attachment to that name (atomic).
>
> For both SCSI and NVMe, it's an "atomic" feature and I was basing the 
> naming on that.
>
> We could have RWF_NOTEARS or RWF_UNTEARABLE_WRITE or RWF_UNTEARABLE or 
> RWF_UNTORN or similar. Any preference?

No particular preference between any of the option including atomic.
Just mumbling out aloud my thoughts :)

> For io_uring/rw.c, we have io_write() -> io_rw_init_file(..., WRITE), and 
> then later we set IOCB_WRITE, so would be neat to use there. But then 
> do_iter_readv_writev() does not set IOCB_WRITE - I can't imagine that 
> setting IOCB_WRITE would do any harm there. I see a similar change in 
> https://lore.kernel.org/linux-fsdevel/167391048988.2311931.1567396746365286847.stgit@warthog.procyon.org.uk/
>
> AFAICS, setting IOCB_WRITE is quite inconsistent. From browsing through 
> fsdevel on lore, there was some history in trying to use IOCB_WRITE always 
> instead of iov_iter direction. Any idea what happened to that?
>
> I'm just getting the feeling that setting IOCB_WRITE in 
> kiocb_set_rw_flags() is a small part - and maybe counter productive - of a 
> larger job of fixing IOCB_WRITE usage.

Someone (IIRC Dave H.) want to move it into the iov_iter a while ago.
I think that is a bad idea - the iov_iter is a data container except
for the shoehorned in read/write information doesn't describe the
operation at all.  So using the flag in the iocb seems like the better
architecture.  But I can understand that you might want to stay out
of all of this, so let's not touch IOCB_WRITE here.


