Return-Path: <io-uring+bounces-3161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A86299765B6
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 11:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA4C61C23102
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 09:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7FD18C90C;
	Thu, 12 Sep 2024 09:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qF0anm2+"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E568A13BAE7;
	Thu, 12 Sep 2024 09:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726133564; cv=none; b=g5X7m/Wo0squLwcfSFDuKB1CRIMsXbAxXa/9SDNYS7HKLHHh+NlIiZspiF7nVENExoezD5vzEDUOBd7PuCnrzZkMEfv1OZysSpgScULKX8iHI1DfnW1oqS8BZg/3yOb803KE0Hlod+wjPP8Ac40u3khTVYGcPMoiXJJWDtx1V6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726133564; c=relaxed/simple;
	bh=n35qMkqNikSgVY2Dl9iFW23QY9JJFH2dYr31jQSdmYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kj1fe+lkkhHMwShOMpg0nQZ/diOhYdNUQUjCRtw3tXDe1R53GJvwdRQWLJPRoVypPuewywP8QcK7qMLarRthksEeXeUYzIwlyA3hXmUGz6PJ7yPgdkDgf+aofQiuToDQsM3tRJOGyOfBGYX71CKtQ43YqDqECIaCzIRbuOuyDK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qF0anm2+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n35qMkqNikSgVY2Dl9iFW23QY9JJFH2dYr31jQSdmYQ=; b=qF0anm2+DvXS/vszjMXYVq+GWN
	srWNKl/S4VJBxhdAPwnxSXu8Wce6GZnyW8dSocqvotRO8cC2i1odx/lO2FScwVxfeKvxB0+uapkbE
	jhUR92u5Z98zAfQ7QKdAUjjSz6+blN10P7c3Y61Y65A+zH2YAfMzNYB/OTXPojX5r6AFlGXPHHzIc
	Ga+osctonojo087sdZd1J6dRyGjdtncVSMPB17u+Sq2DLJ3i83f0qtq36aCO5l7sGo7mFv5l017wV
	qJYczis9D65Ce/+GILYDABU2a53QDqNlJcEUEJOvtNpKDomj/+yhW3t7w7IhnXS88cgjzCTtl2jKe
	idpAd3/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sogBu-0000000CXzj-0nEq;
	Thu, 12 Sep 2024 09:32:42 +0000
Date: Thu, 12 Sep 2024 02:32:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>,
	Conrad Meyer <conradmeyer@meta.com>
Subject: Re: [PATCH v5 6/8] block: implement write zeroes io_uring cmd
Message-ID: <ZuK1OlmycUeN3S7d@infradead.org>
References: <cover.1726072086.git.asml.silence@gmail.com>
 <8e7975e44504d8371d716167face2bc8e248f7a4.1726072086.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e7975e44504d8371d716167face2bc8e248f7a4.1726072086.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Sep 11, 2024 at 05:34:42PM +0100, Pavel Begunkov wrote:
> Add a second io_uring cmd for block layer implementing asynchronous
> write zeroes. It reuses helpers we've added for async discards, and
> inherits the code structure as well as all considerations in regards to
> page cache races. It has to be supported by underlying hardware to be
> used, otherwise the request will fail. A fallback version is implemented
> separately in a later patch.

Except that as far as I can tell it doesn't implement a fallback, but
an entirely different command leading to applications breaking when
just using the command and the hardware doesn't support it.

Nacked-by: Christoph Hellwig <hch@lst.de>

to this incomplete API that will just create incompatbilities.


