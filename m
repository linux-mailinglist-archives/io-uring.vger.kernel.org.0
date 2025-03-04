Return-Path: <io-uring+bounces-6944-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65428A4E614
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7503017F2E2
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 16:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C656F299B22;
	Tue,  4 Mar 2025 16:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zlgcu/Av"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C42299B3B;
	Tue,  4 Mar 2025 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741104425; cv=none; b=PG+wBevf27jW53w6COqFHsOEJL47kQw3ouT0vJf3xOURweh+lGqkpRx8qbLX5og3USXLorgfRtJZeNbOGUMr24cF7z4Ff2f1/UbML/QOaHnt628tQmWh0Z3oK7ftLqF2lzw1P33MWiM3MgS37cz2Wgx2TLU/1nOxn+OEi3fu7zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741104425; c=relaxed/simple;
	bh=Qwvxq9hfhodLJ0lNY1Di8fwhYJRxmCyMZSYThpZzGmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IPdBJLzLB4Q5wqf4HqnR1qbsGKPmlZQKnakgjVZrNg502Hppxm8KG3aGD9boPbhV9hoBVB4wDipPokSVpkByNaKNRcGrmNpZy+af6pymPHkymFBHtBYzRLNVuOF0f6o2aq2qtG80vXj+SMTf/pMMhrFl5fo2iEnnP4y9Ksmvudk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zlgcu/Av; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tNMN/f1j1gzW/Js7YAr7BaHV+/Y/BODCkrWKfzumSeg=; b=zlgcu/AvoDZvGeSx+xW8jvDX50
	De/feyis2k36xRZo7oqutL+p7uteV6ziiinga/56bOV+d6h2HRqfAApkrianHSJe7MC1hWcGIhAdH
	I/rzf7i+6aoFhiSUateHGPBQhPfzeSl1+H587e4luX+LjfRPg55pBPBQi7oXq+UdsZ8F/Aw+pSqPf
	Bof65OYKSzJq96QqawjF7fqcajt17cGEeY7mci4WQmZvRmjd7K/l5BcugXs6j6Yz0wwzjxcFBHKDT
	LBQs9J70xHhbkfiXvtjzkXkghcq0VYvcz9m0aujftnmdbQ8op4iTr4a9ShSEGpho6pn/psuHmIOmk
	yf9BWYUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tpUnP-00000005LwD-3BKk;
	Tue, 04 Mar 2025 16:07:03 +0000
Date: Tue, 4 Mar 2025 08:07:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
Message-ID: <Z8clJ2XSaQhLeIo0@infradead.org>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 04, 2025 at 12:18:07PM +0000, Pavel Begunkov wrote:
>  	    ((dio->flags & IOMAP_DIO_NEED_SYNC) && !use_fua) ||
> -	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
> +	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
>  		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
>  
> +		if (!is_sync_kiocb(dio->iocb) &&
> +		    (dio->iocb->ki_flags & IOCB_NOWAIT))
> +			return -EAGAIN;

Black magic without comments explaining it.

> +	if (!is_sync_kiocb(dio->iocb) && (dio->iocb->ki_flags & IOCB_NOWAIT)) {
> +		/*
> +		 * This is nonblocking IO, and we might need to allocate
> +		 * multiple bios. In this case, as we cannot guarantee that
> +		 * one of the sub bios will not fail getting issued FOR NOWAIT
> +		 * and as error results are coalesced across all of them, ask
> +		 * for a retry of this from blocking context.
> +		 */
> +		if (bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS + 1) >
> +					  BIO_MAX_VECS)

This is not very accurate in times of multi-page bvecs and large order
folios all over.

I think you really need to byte the bullet and support for early returns
from the non-blocking bio submission path.


