Return-Path: <io-uring+bounces-2106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E5FD98FC697
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 10:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32EA3B29A84
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 08:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F041946C4;
	Wed,  5 Jun 2024 08:31:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F407E1946C1;
	Wed,  5 Jun 2024 08:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717576308; cv=none; b=cD9GTrt8zoRGIb3XGD3XoKshlVDSKzSS1C5w+xLMaPLVf969pMchGjEw6T+96P/0+Ind8O+FY7daECv6/QwcXyV799Gq1PktQ2B45lrZ4khbu9k/AnMerAZbtgc/4cBBlQgiyN30ZJIiZ+PUrfuxihgQQyoRY3H+q8hdT+Ga4yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717576308; c=relaxed/simple;
	bh=zvUVd27CD1K4FaFoCrMfpVqXDatBKNErQYwVEI5K/7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t32bfYzED/zXVHStl7GWHh7baisznigGSW49fi5SFHq0vYLaWSZ+lfH1bYRVeZrY6ntzy0N+yLimigd7V6ZjOIntvVaTQ6F9RT7eGkomZk8gl8sPm36WXFCCEH13G+spT58H96WNoe8iUBjrpwoILwD7rqWrIqaMxXeahNfyELo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A2C0A227A8E; Wed,  5 Jun 2024 10:31:41 +0200 (CEST)
Date: Wed, 5 Jun 2024 10:31:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk,
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
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
Message-ID: <20240605083140.GB20984@lst.de>
References: <20240602140912.970947-1-john.g.garry@oracle.com> <20240602140912.970947-5-john.g.garry@oracle.com> <749f9615-2fd2-49a3-9c9e-c725cb027ad3@suse.de> <a84ad9de-a274-4bdf-837a-03c38a32288a@oracle.com> <ee20a47d-3131-41c2-a2fc-39017f535527@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee20a47d-3131-41c2-a2fc-39017f535527@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 03, 2024 at 02:31:04PM +0200, Hannes Reinecke wrote:
> We currently use chunk_sectors for quite some different things, most 
> notably zones boundaries, NIOIB, raid stripes etc.
> So I don't have an issue adding another use-case for it.

So as zone as a device supports atomic/untorn writes you limit all
I/O including reads to the boundaries?  I can't see how that would
ever make sense.


