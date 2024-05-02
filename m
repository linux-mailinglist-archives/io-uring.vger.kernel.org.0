Return-Path: <io-uring+bounces-1703-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B618C8B9518
	for <lists+io-uring@lfdr.de>; Thu,  2 May 2024 09:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16ACBB21386
	for <lists+io-uring@lfdr.de>; Thu,  2 May 2024 07:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1619320DD2;
	Thu,  2 May 2024 07:12:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7575F1CA96;
	Thu,  2 May 2024 07:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714633950; cv=none; b=SlkLNhcgu249bvmgsNkN7mNW7gdMMnQNr97GY/WP+knYPJKgUX5r2X82Gx11ErXAgNVYxWbqueKoeoCmue9pYu/8P2Cy4tzUTNSVhu1HSiucVLSsg15n1TMeyg7gZEv4i8fLWcEXUMcRSu5e1O/vhxfy6+/2jDDbdLR+WdgnwDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714633950; c=relaxed/simple;
	bh=2+xSLSUsby2BC/4YL1v9fwY61kfRQYM6OLvY0e6r1ZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QT9z4CgBUlIps2kKBhKPYhUDwWH066c20gOCnCTk4BxcHepIsDihWcWG7zG9gPFX9quEIn6LFhjtXfQsxMKsW35woF/vAi/9ZOpPuKWAJ2SLCnVMHHOoUQCmRge04B7E82X1NrmcxrU1KnvvLTGqeLD56z/FSHXGPbqY47IQbeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 496A1227A87; Thu,  2 May 2024 09:12:22 +0200 (CEST)
Date: Thu, 2 May 2024 09:12:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	martin.petersen@oracle.com, kbusch@kernel.org, brauner@kernel.org,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 04/10] block: avoid unpinning/freeing the bio_vec
 incase of cloned bio
Message-ID: <20240502071221.GA31379@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184658epcas5p2adb6bf01a5c56ffaac3a55ab57afaf8e@epcas5p2.samsung.com> <20240425183943.6319-5-joshi.k@samsung.com> <20240427070508.GD3873@lst.de> <03cb6ac3-595f-abb1-324b-647ed84cfe6b@samsung.com> <20240429170929.GB31337@lst.de> <ebeca5f1-8d80-e4d4-cf45-9a14ef1413a5@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebeca5f1-8d80-e4d4-cf45-9a14ef1413a5@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 01, 2024 at 06:32:45PM +0530, Kanchan Joshi wrote:
> Can you please tell what function(s) in bio data path that need this 
> conversion?
> To me data path handling seems similar. Each cloned bio will lead to 
> some amount of data transfer to pinned user-memory. The same is 
> happening for meta transfer here.

Well, everywhere.  e.g. for direct I/O everything is just driven from
the fs/direct-io.c and and fs/iomap/direct-io.c code without any
knowledge in the underlying driver if data has been pinned (no bounce
buffering in this case).  Or for passthrough I/O none of the underlying
logic knows about the pinning or bounce buffering, everything is handled
in block/blk-map.c.

