Return-Path: <io-uring+bounces-3158-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD9E4976587
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 11:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73D4D1F27FDE
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 09:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F115191499;
	Thu, 12 Sep 2024 09:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NYk6DV4A"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6CD18FDC8;
	Thu, 12 Sep 2024 09:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726133330; cv=none; b=Cb5IuMvGad/6i7A45NUhVm3azF6xMmDacVuT65x/4HRxnWzsO2lZ7PlL/c1dTgdIxfvW3odRx8QXZoiNL0BrWTiiQyavcgOdf9okmQMt0vDxo6kGMmX1kNHoueCltgBJGVte6DahYcEREsVJqit5AjW2iFmYO/sWlkC2jtzU1zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726133330; c=relaxed/simple;
	bh=Gp4hfwblcq7g2bvRKOKH9Ji0D8DEUp1SSs4VrWlRk2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OqBMsO9qIKzwFo5zxTcbGxSllvKaBag8YxaACf7CQ6EI7KEWA8CSVqifFziLQuoGoMTGVNBiGIaxIvdry1dQ91znWfZNjK5zWHj9dakcwVkn2U/uyPOu2FNvnNI801YmSc4IuSdjr/FqY9rAGYU+u/eotQyQl+zjEJQoLS1G/XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NYk6DV4A; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eAmkBNXobr2RxYsdS5bAIh0eBkEdCd/pvZs+9hqhqK8=; b=NYk6DV4A/GDMh5wbsVzY0HsqNs
	Mk9uX42oCoIgUygO+z1z9E9tEeGSPz7nA/7s4wtRVqLucqWDqZ57z8dYILVw3FdivKPXjxh4iEFlU
	+TkKpmOvq4zg5dnXZILCaLcaI99jYnohMuQOBWcPqiXeVrvV7OxxHNAKoAr9JhjZZ1CT8UrEciH12
	rpAUohxonIjQmFQjQAAoBNbMasiM2rlHrY4oUivC3iMM7uMxo18FMGr6oDTc9kf1xicW4VVTQ2o1S
	ElBk7kBQoOlfY+zsnTlEHrI1WtVT4H+5glFkDySSm4fZ58XkpDyz2N1F7G0CknDyyCRWKFw91qfGl
	xvlSnp4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sog87-0000000CWim-3IbK;
	Thu, 12 Sep 2024 09:28:47 +0000
Date: Thu, 12 Sep 2024 02:28:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 5/8] block: implement async discard as io_uring cmd
Message-ID: <ZuK0T_yiPl1Pi9wW@infradead.org>
References: <cover.1725621577.git.asml.silence@gmail.com>
 <7fc0a61ae29190a42e958eddfefd6d44cdf372ad.1725621577.git.asml.silence@gmail.com>
 <Zt_8wlXTyS2E7Xbe@infradead.org>
 <430ca5b3-6ee1-463b-9e4e-5d0b934578cc@gmail.com>
 <ZuBU6Nn3lS21FN_Y@infradead.org>
 <a9a447c7-6b6d-4a49-ac16-e6b8e97908b6@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9a447c7-6b6d-4a49-ac16-e6b8e97908b6@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 10, 2024 at 09:22:37PM +0100, Pavel Begunkov wrote:
> 
> while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects, gfp))) {
> 	if (nowait)
> 		bio->bi_opf |= REQ_NOWAIT;
> 	prev = bio_chain_and_submit(prev, bio);
> 	if (nowait)
> 		break;
> }
> 
> Like this? I need to add nr_sects==0 post loop checking either way,
> but I don't see how this break would be better any better than
> bio_put before the submit from v2.

You don't need the bio_chain_and_submit as bio is guaranteed to be NULL
here.

> > How would adding a proper header instead of bloating fs.h not be
> > part of the series adding the first ever block layer uring_cmds?
> 
> Because, apparently, no one have ever gave a damn about it.
> I'll add it for you, but with header probing instead of a simple
> ifdef I'd call it a usability downgrade.

blk ioctls have historically been in fs.h, and keeping it that way
instead of moving some in the same range makes perfect sense.

Adding new commands to this mess absolutely does not.


