Return-Path: <io-uring+bounces-6955-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 417EBA4F173
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 00:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07B397A2FE2
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 23:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B1F1278115;
	Tue,  4 Mar 2025 23:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="E98yaOnf"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4327B1F8BCC;
	Tue,  4 Mar 2025 23:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130816; cv=none; b=nDe1pltw7OOoEJXOIU5HThFjDFLZmOOlqvSLiJrYgA+6fMVW8lKW9PlguR19u5gq5zsbdkgWiA3E6dHA7Gd0F9iUua/+e+PZOF5/ZuH6V4rAh4QC4oibzBv/BUz/WJt0qUqgMDY5sQxQ6svbrAPGf8fos5szwEUxVbdcdXbcD5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130816; c=relaxed/simple;
	bh=kTNKJR0fKUJJ79sSUr0DpfC48A7byd4R+dF5N1ruwLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPO5AsoyqQYndPleNh0Nntvaj69KchyYGdIaKL/ZWgfa9/u2MEBNGXhpWC7nZqlixfMQgE4fooVsRoiKOyc6QY7K1Kvwi749oQ8V3Cr/hi6JnRALeDWqM5W7HaFywCrz/Hum+ea3kOeIPZE9ToW7gzLA4B2e+M0Bodcm//eqp10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=E98yaOnf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dR3USr0Xg7Onjmq/cb1Ybh5GGvxczZ5NgxfkLQe8DBs=; b=E98yaOnfPCvBzxR2luCEXGesiD
	bXnCEaSgE+jDEBk2kS4UYovthJ0sniVy/FcsyV4vnAsXEra5HRd9O7fGJ1AAEX9GXBD+cTOTFXhYI
	rWm6AY7skHuU83csSVTrzWGilC+JyFQN2RlBjMv+AyGHjTR9ziFIMLJup9OPtZa/Wxf8YkX/dcA28
	WkNlG0KO2WiPDv/wHrd1VuEUysCo5CRelbP9V198eH9+OKREkgHesReIywDNfCAOkCfuTmG2kwwal
	RU1ysUKuZfdu32bqXr1oAiUz14igVQoGwMXMxMMVfrNzT/hraS9LU4bameVvr+3Ecb++Y1K5ot5AI
	ThD6jnjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpbf3-00000006Wge-1vYR;
	Tue, 04 Mar 2025 23:26:53 +0000
Date: Tue, 4 Mar 2025 15:26:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	io-uring@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8eMPU7Tvduo0IVw@infradead.org>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <Z8cxVLEEEwmUigjz@infradead.org>
 <1e7bbcdf-f677-43e4-b888-7a4614515c62@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e7bbcdf-f677-43e4-b888-7a4614515c62@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 04, 2025 at 10:36:16AM -0700, Jens Axboe wrote:
> stable and actual production certainly do. Not that this should drive
> upstream development in any way, it's entirely unrelated to the problem
> at hand.

And that's exactly what I'm saying.  Do the right thing instead of
whining about backports to old kernels.


