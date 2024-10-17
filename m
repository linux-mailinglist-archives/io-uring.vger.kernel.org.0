Return-Path: <io-uring+bounces-3762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10FB19A1C41
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 10:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B13351F24B24
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 08:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D3117DFEF;
	Thu, 17 Oct 2024 08:00:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC9C16EB76;
	Thu, 17 Oct 2024 08:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729152021; cv=none; b=j7/oKcXTYj+VEzPUJNvFgWObXZN2xvy1l99wpbI0zgs6Nv8XqMqVJzkhKB49dUu0Dj0JHcWpNr4VtvFoxuvzfUtkkTfvxMr5237cgqBdqa5fjEzMkv6z0z6H7HER/0VOOURlN7sT74xUD7e9xwFPSPKG9kCdZsmJC3EqUO99syI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729152021; c=relaxed/simple;
	bh=O4pOSAM/QbmEd9QrryyctoQM6C1y7if8xIZsP2JY3v8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BEa1WyagWE0ZBiw24cvdMT3dMW/U0s4OuyWkMSDBPFmFum4VMUunHKxLmtkFscP80EJ8MvBTIGqod8sD8v2TKlHHEnQDxeby69LogiTiu92qBc2Y1OaHb4x0vSRDFj18axfCxHaSl9Rdr/eovnnZGXKwSDhRcmuUqQrAtVZ9hKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E8666227A87; Thu, 17 Oct 2024 10:00:15 +0200 (CEST)
Date: Thu, 17 Oct 2024 10:00:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com
Subject: Re: [PATCH v4 06/11] block: add flags for integrity meta
Message-ID: <20241017080015.GD25343@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113745epcas5p1723d91b979fd0e597495fef377ad0f62@epcas5p1.samsung.com> <20241016112912.63542-7-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-7-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 16, 2024 at 04:59:07PM +0530, Anuj Gupta wrote:
> Add flags to describe checks for integrity meta buffer. These flags are
> specified by application as io_uring meta_flags, added in the next patch.

These are now blkdev uapis, but io_uring ones even if currently only
the block file operations implement them.  I do plan to support these
through file systems eventually.


