Return-Path: <io-uring+bounces-2107-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF7F8FC679
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 10:33:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61E391C224AA
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 08:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FAA4A11;
	Wed,  5 Jun 2024 08:32:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C4D4962C;
	Wed,  5 Jun 2024 08:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717576371; cv=none; b=NHsNYTXaY07V4I/YWSkvWcAVAbA54rh/kfDECdsL5pQibd95zZWRSnlBOtsjtpRyzlK1q7ea6jbF7GO4V9z4xXKjUdZ4LLZjIS9CjRrnzJQzWDKJnF0yuWY7CERbME4Wbf9EfFsP+BbDE5P/dpUMLq9OutjwFBPZOhSG1IOjd80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717576371; c=relaxed/simple;
	bh=b/ObxG1GZpzF8QN6XmS3pDXqPfQIe/hDt6IZgEOHG/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZK2S1duhKq8HGz7Jm4G/nPc7DDZLqHDqi+9evKV2BdJMpHIgGltxguCcNH6+PsyKMPkNAhgT7zn2SHX2SNvpR/tgMDpZtA3Bb0cDpeu9ebXj1gaLKpOxthklBWz/H9ZLPUfi1vgYpVjp/jf1woR0eGeUwuXJ2hdYkl4PsFhaR5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 91D4267373; Wed,  5 Jun 2024 10:32:46 +0200 (CEST)
Date: Wed, 5 Jun 2024 10:32:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, axboe@kernel.dk, kbusch@kernel.org,
	hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org,
	Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v7 4/9] block: Add core atomic write support
Message-ID: <20240605083245.GC20984@lst.de>
References: <20240602140912.970947-1-john.g.garry@oracle.com> <20240602140912.970947-5-john.g.garry@oracle.com> <749f9615-2fd2-49a3-9c9e-c725cb027ad3@suse.de> <a84ad9de-a274-4bdf-837a-03c38a32288a@oracle.com> <ee20a47d-3131-41c2-a2fc-39017f535527@suse.de> <76850f4f-0bd0-48ae-92f4-e3af38039938@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76850f4f-0bd0-48ae-92f4-e3af38039938@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 03, 2024 at 02:29:26PM +0100, John Garry wrote:
> I think that some of the logic could be re-used. 
> rq_straddles_atomic_write_boundary() is checked in merging of reqs/bios (to 
> see if the resultant req straddles a boundary).
>
> So instead of saying: "will the resultant req straddle a boundary", 
> re-using path like blk_rq_get_max_sectors() -> blk_chunk_sectors_left(), we 
> check "is there space within the boundary limit to add this req/bio". We 
> need to take care of front and back merges, though.

Yes, we've used the trick to pass in the relevant limit in explicitly
to reuse infrastructure in other places, e.g. max_hw_sectors vs
max_zone_append_sectors for adding to a bio while respecting hardware
limits.


