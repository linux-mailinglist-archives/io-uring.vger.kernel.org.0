Return-Path: <io-uring+bounces-2241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4017990BA38
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 20:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1C7E1F22692
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 18:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FF9198A3F;
	Mon, 17 Jun 2024 18:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2++ArIa"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E958E155C8D;
	Mon, 17 Jun 2024 18:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718650566; cv=none; b=AonyyqClKaKWbmTpiWBXoZnp3FmeVa5ctFaDUQb66WOgiFr+Sozib5aDlVE2ZPZaOI5hgUPQg8Su3l6HFsrh+NvWFIeTdVL8iyYj1P+ZizJDt6PSYHQ13XL2tLJH99pt7R5kFRUBt2BbNU50ojoKXuYWY/L9JcrkByl5MlPhuXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718650566; c=relaxed/simple;
	bh=g7rkmBq2pe99Z9GXbL+NVIJ/TMOoi7Iw0Lv6xVkToJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEZcBXYbnz/FMDS3ZeaTiPWFAM9mPfVnyXQ3gzbuZi6JZfsXTg0r6gbvz15RJesPY1ZIhcHKwmuc7HcI81ttit/rKABZsYYUKeDj24bSKZWS2lEk+1Y6poo/dllsR5RDjHqFAMyuRCMDuTBwB54b8v7lo2CcetUz3fKAZzzSK+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2++ArIa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D93C2BD10;
	Mon, 17 Jun 2024 18:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718650565;
	bh=g7rkmBq2pe99Z9GXbL+NVIJ/TMOoi7Iw0Lv6xVkToJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q2++ArIah/012FcoT7zryRSne2YU6H2RPdG7iBKuyfQrmxZbyv8Lx4xKP1XbxfRi4
	 P9yShjbbBNPd5Z+pIYeIP1Db5YS3Pve2dMGtJ9MQbacqJtlAi1nHOUDKGST7luNl4S
	 VT18yi6V9xiXWwuA1BAw5GJ4ydADTYRJMgezFx/borqv2g1Db4c7nv8jdEQcKkhy3o
	 woEvNwsvdZ7EbXMnP814TsTEFIfxu95enQlEl1cSSv74R1Y4gUneBRc9DPkS12+urf
	 6Erloj4I/sy3l2ecNNL80cFuj7jcXnVSsypQZ5zSuGonuDfO67EpStjz+LnqYx4GrU
	 aGcp51DpIckgg==
Date: Mon, 17 Jun 2024 12:56:01 -0600
From: Keith Busch <kbusch@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
	martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
	djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de, Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v8 05/10] block: Add core atomic write support
Message-ID: <ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
 <20240610104329.3555488-6-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610104329.3555488-6-john.g.garry@oracle.com>

On Mon, Jun 10, 2024 at 10:43:24AM +0000, John Garry wrote:
> +static void blk_validate_atomic_write_limits(struct queue_limits *lim)
> +{
> +	unsigned int boundary_sectors_hw;
> +
> +	if (!lim->atomic_write_hw_max)
> +		goto unsupported;
> +
> +	boundary_sectors_hw = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
> +
> +	if (boundary_sectors_hw) {
> +		/* It doesn't make sense to allow different non-zero values */
> +		if (lim->chunk_sectors &&
> +		    lim->chunk_sectors != boundary_sectors_hw)
> +			goto unsupported;

I'm not sure I follow why these two need to be the same. I can see
checking for 'chunk_sectors % boundary_sectors_hw == 0', but am I
missing something else?

The reason I ask, zone block devices redefine the "chunk_sectors" to
mean the zone size, and I'm pretty sure the typical zone size is much
larger than the any common atomic write size.

