Return-Path: <io-uring+bounces-2134-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 864698FDE3A
	for <lists+io-uring@lfdr.de>; Thu,  6 Jun 2024 07:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B0C51C23CAB
	for <lists+io-uring@lfdr.de>; Thu,  6 Jun 2024 05:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AAC38F9A;
	Thu,  6 Jun 2024 05:44:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C2012E5D;
	Thu,  6 Jun 2024 05:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717652673; cv=none; b=bHuUGntvudecMaRvFz2cZ+V+gCgQKjxsug3QQcUKZxrZZYTjLX6rwey4BjjznMOmeF+VYV6q9pvkzdEiRwq0ersE/T5SLFQQ0Kn3rkrPKTulvpfehs1jSWyFgqdVtebDvjxmUv60aa+1ZehwJisTPNTUaOhXjnrNTW4gLny4E/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717652673; c=relaxed/simple;
	bh=pFUxtO8l3MYBon5QqmQZ++UCuItVyzbyjikb4L80ed8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8W1sWF9cYi8CpCmIpF1+/dI0IULIPrfFW8TB8U32l5DK7nRHQranlq0NaCxsy0Inen0XBArf4s7uL9W2L8SEhBq4/BYI02S0Tkc8Nfp0oyfY+vHsstsXX9R62aLEcjLYOgfj73qEIqpJl7LFp2hkbj1mLHVv8kcxZtjv8qohyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 82BB368CFE; Thu,  6 Jun 2024 07:44:25 +0200 (CEST)
Date: Thu, 6 Jun 2024 07:44:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
	axboe@kernel.dk, kbusch@kernel.org, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
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
Message-ID: <20240606054425.GC9123@lst.de>
References: <20240602140912.970947-1-john.g.garry@oracle.com> <20240602140912.970947-5-john.g.garry@oracle.com> <749f9615-2fd2-49a3-9c9e-c725cb027ad3@suse.de> <a84ad9de-a274-4bdf-837a-03c38a32288a@oracle.com> <ee20a47d-3131-41c2-a2fc-39017f535527@suse.de> <76850f4f-0bd0-48ae-92f4-e3af38039938@oracle.com> <20240605083245.GC20984@lst.de> <09907144-45ca-4a48-8831-2f98518cbca4@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09907144-45ca-4a48-8831-2f98518cbca4@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 05, 2024 at 12:21:51PM +0100, John Garry wrote:
> I assume that you are talking about something like 
> queue_limits_max_zone_append_sectors().

Or rather how that is passed to bio_add_hw_page, yes.

> Anyway, below is the prep patch I was considering for this re-use. It's 
> just renaming any infrastructure for "chunk_sectors" to generic 
> "boundary_sectors".

Looks reasonable.  Note that the comment above blk_boundary_sectors_left
could use a line break.


