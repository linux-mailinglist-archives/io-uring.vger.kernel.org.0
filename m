Return-Path: <io-uring+bounces-1496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBFD8A03D2
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 01:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A50032884A1
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 23:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4381322071;
	Wed, 10 Apr 2024 22:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xg6MVqbj"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3C323BB;
	Wed, 10 Apr 2024 22:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712789894; cv=none; b=laCATZHqyGAH41lVlifMfOU9epYuBrrD+l9aC+tNFJgWrCqiDdQiDa77dml1ioS+gZTsqD3D0Zs8BsbWmdlv+tiee6vi67xdDEs7x0hXNX6EhjdF/NoiGo7/ImcVsRC2qbDfQ7fvkwlFKvZHlSlPSKvq3MyC/b5fflFp8Zxsxos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712789894; c=relaxed/simple;
	bh=G/3/K/ucg1psjthnAeRePnc+uMtdwWf49MtcAFpd13Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TNUh+eeKhwXDKINJq7PCnIfCF/m69ejrfgF9SvQ+s3ta0yq//8IYMoZBYydDVFK9AJJ22UtB7oqvC3YxXmAxNw3P2QJobl0mjdRPzf00XMyW4ipci2V4kSF/8TESslDvFP9tODM+A4uGZJA9F5dLCvA81PlY/5zXnGDDKzFleR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xg6MVqbj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mqqt3O5CMVOhP6KJ0RUdsxRDGEHT2Fm8gtdzEX2uSXA=; b=xg6MVqbjel8leokTlnY6ne9O3I
	U/wOCrXnOAB9HrQTUQcVsZ2ABux6RmXFknxfbaxax+1lINyY86qi47VD5qbBh0x1D2OvD2ZlNBO39
	c2Eh6sFEYYbKMcJWK31OLDtVz0EnlAp1LxhIPhaMq3fuZLPchyyw72Y3a8t0TYjkdtKA19IkUxCbB
	nE+lKRzuMMSXAK/zFdp/QjQUQ6CKVvqCWbpwyHkb+5VJU2kclc0paEM7FZw5pfKQ9j29PV2xzKFaL
	jaotNmuqTIfY1LrTe4ijIYVfLpkNuChxU0TeidwlWzXl3I77yz+cie2GTF/EYBQIigohZd9dlGzFv
	vlD7Q3+A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rugtL-00000009MGy-3r8e;
	Wed, 10 Apr 2024 22:58:07 +0000
Date: Wed, 10 Apr 2024 15:58:07 -0700
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
Subject: Re: [PATCH v6 01/10] block: Pass blk_queue_get_max_sectors() a
 request pointer
Message-ID: <ZhcZf4qLLZi8v0U2@bombadil.infradead.org>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <20240326133813.3224593-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326133813.3224593-2-john.g.garry@oracle.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, Mar 26, 2024 at 01:38:04PM +0000, John Garry wrote:
> Currently blk_queue_get_max_sectors() is passed a enum req_op. In future
> the value returned from blk_queue_get_max_sectors() may depend on certain
> request flags, so pass a request pointer.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: John Garry <john.g.garry@oracle.com>

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis

