Return-Path: <io-uring+bounces-1495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7D038A03C6
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 00:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 725AD28D3F4
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 22:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20103F8F1;
	Wed, 10 Apr 2024 22:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GJtMIjNj"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52A13E497;
	Wed, 10 Apr 2024 22:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712789630; cv=none; b=WMFjsvfmAz3mkQuuf0gAYiAwbccdIKbfhw59oD0ebmKRM1HXCfKehGrzup8EaGId7usS+UOrErUilUn7vqZUCg6/SUyzM+p5L6aac5pHxJEq8mBiX8EogRog/jXI/BTKJS/vhNHtBd6EKBgAo3HfffpcBbWN+ApaXbUqoXZl8i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712789630; c=relaxed/simple;
	bh=+SF8fRD5qtMuzpo19NhWUcRSgrgCUtWHLitNvMbRUCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PzH5o2zLqz1Ucxv/KxItPwVC8RO05pgjTiAq+X/C/6knB/DlE/Gmm84uq5cJrtwiMe5+KKdSLZO6F5TLJU94tdX55NNWjAsK8ZuXlzbi9nzwpFkjAdhjYFg1Wzm3ky8zeyFCZ4Vbj9atOwx5f9b5t2oVqoH57qwp6FRWFcGsvQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GJtMIjNj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+0GBmcwTyMhAOkoLxmQrxueXW3lGrGIZ8d1OHjV7ylM=; b=GJtMIjNjW41SrtG8JRyeUyv1YK
	3/LJY8P60iIIigbcUK7nRIOG5SAxG9rk+7qqoUeoeruVCBueT9pP2tC+GnYuXFaJs3z9so25cEihh
	Xo7Gc5b+4nEQcKGzf68LqxzhWau+RLyP2fh/nQ9rV9kFMewdxavcXr90oaxnCSXWYDEKUFwuZIBuA
	4RewKyRIxhxMa/ug9Fqqj+ecU9DLl6OIIm3wes6nThakVfuKPbIcCZfTOkqViwwdAu4SOk0oZTTXv
	4pQKbDIKxSS51l/NZa3AZXDpH4pdhSjuxGDTtBUHefUTa2VxgbhtP0jzBsv1wU7ao3k/TI4T9Kwep
	YEzX5s9w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rugp4-00000009KiJ-11gu;
	Wed, 10 Apr 2024 22:53:42 +0000
Date: Wed, 10 Apr 2024 15:53:41 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org
Subject: Re: [PATCH v6 02/10] block: Call blkdev_dio_unaligned() from
 blkdev_direct_IO()
Message-ID: <ZhcYddRtAoMghtvr@bombadil.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <20240326133813.3224593-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326133813.3224593-3-john.g.garry@oracle.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, Mar 26, 2024 at 01:38:05PM +0000, John Garry wrote:
> blkdev_dio_unaligned() is called from __blkdev_direct_IO(),
> __blkdev_direct_IO_simple(), and __blkdev_direct_IO_async(), and all these
> are only called from blkdev_direct_IO().
> 
> Move the blkdev_dio_unaligned() call to the common callsite,
> blkdev_direct_IO().
> 
> Pass those functions the bdev pointer from blkdev_direct_IO() as it is non-
> trivial to calculate.
> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

I think this patch should just be sent separately already and not part
of this series.

  Luis

