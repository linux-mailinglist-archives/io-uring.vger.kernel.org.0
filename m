Return-Path: <io-uring+bounces-1656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A528B44B2
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 09:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C985A282F91
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 07:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08AC241A89;
	Sat, 27 Apr 2024 07:04:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907F540856;
	Sat, 27 Apr 2024 07:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714201452; cv=none; b=VH9AEWSPy9ThVVr3T33t6csgMBxQVrzmuYlDBLhwKIDNBkP3vtREBL6T5V8Ie8aoJ5W75j0V/sjIGekH58vhWHdPN19B3KS1HcJk3pudXrGys0R7vbm+/omH1+nyTOf3gjE2iAIcdB0GJZ9J88Mk6WSoFuDX+8pVnwZbGdgMbgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714201452; c=relaxed/simple;
	bh=AvOoFGKdz9I6Rip7p+4J93oE5u8f6bKdHkL4QuJK3Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AyoZLXyk1sdx2SQTHdrGiSe6xJSLBle6gKSoF2ygdTpfBe8DRG0y2n0sG2Z/9RqwGId7c9CQUk44t9aj2iNWGhsf/ds4cJEAuCZc9KD16wqMtI3eM7JDTE6xb0chQ5QfMPXMe+j9WroxZU5rI5hELRI1uzZW7OIiCf6zf4gXpcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8A355227AA8; Sat, 27 Apr 2024 09:04:08 +0200 (CEST)
Date: Sat, 27 Apr 2024 09:04:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org, asml.silence@gmail.com,
	dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 03/10] block: copy result back to user meta buffer
 correctly in case of split
Message-ID: <20240427070408.GC3873@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184656epcas5p42228cdef753cf20a266d12de5bc130f0@epcas5p4.samsung.com> <20240425183943.6319-4-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425183943.6319-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 26, 2024 at 12:09:36AM +0530, Kanchan Joshi wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> In case of split, the len and offset of bvec gets updated in the iter.
> Use it to fetch the right bvec, and copy it back to user meta buffer.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>

Looks good, but needs a fixes tag.


