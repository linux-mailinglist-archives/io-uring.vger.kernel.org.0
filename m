Return-Path: <io-uring+bounces-2888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A651F95AD9E
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 08:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9A071C22328
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 06:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9983D42077;
	Thu, 22 Aug 2024 06:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XO+fDA94"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559B2249F9;
	Thu, 22 Aug 2024 06:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308579; cv=none; b=MsLnmcXx0oEJYPAwOBtxHHzq6/rR+G8+FFcs+0BZ61JrfzsFpLJhfIsVXXgO0FI4jeZVlwB6/zcCx6aqWWuFfWEnJPLW8WakF8kpbUUiTg8ifGr2CRsX0xDMbxWbuVswYyT2KJ5FsK5hno1slx7WWyqeBWNSWwmTo4G8C3Cor1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308579; c=relaxed/simple;
	bh=VKaiCtsmN1aBNjk9Xs6TgBGT9aKepOtJnZ10tgCDRAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Enc0+qIS35XDPKAkI2ku0dYk29n1gPslB4vJFB87x6IpafBscUC2EysyO1Gg8ZMrzv41EuX45x7CIt5cVV6p9N7HrsbCqUpR0Uk1maOHlFZ1i+0lSRR0zfGX8cQMeLLt2HzEj3EbiE7GpcxkKPAD2Gwv6gUS46+UnK4bghMQ4ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XO+fDA94; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VJgOW0ZygHE79ideUxiyls7o3JuXQJ4tAsmhI265dkA=; b=XO+fDA94jWzmKNQbLS/3vCp5pL
	tXp0oDjNc17eDu6WCWx0YsrQCDbPb1vNIllqfuef7fKhmny98jYObBPExfUFxosuJeb8ydbbLcXVD
	sHQW5cppsy+OxnmjW0Xf8jzFNhQUmme+2/wjxESmadIBaX37OnTqt/JxNdHIxftmSDDHAxi6c0HWy
	XQZfrkOKu8VbY5t15641LEwY7yvJktRiNdHmMaQmgH5HrVTi5TN2JcoQHKX0WRIglgvcRUaHohLjJ
	qHrFEGWF0jFnaHvpAdEMm9raT5KL+XbGAEV7Tgj9JZuYN5rvQmgC6+G0ci7EuA/QwyOu8rKrAbJht
	wDs5Rq9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sh1Qf-0000000BdIf-3dAW;
	Thu, 22 Aug 2024 06:36:17 +0000
Date: Wed, 21 Aug 2024 23:36:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 7/7] block: implement async secure erase
Message-ID: <ZsbcYakQS-UQIL5W@infradead.org>
References: <cover.1724297388.git.asml.silence@gmail.com>
 <5ee52b6cc60fb3d4ecc3d689a3b30eabf4359dba.1724297388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ee52b6cc60fb3d4ecc3d689a3b30eabf4359dba.1724297388.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 04:35:57AM +0100, Pavel Begunkov wrote:
> Add yet another io_uring cmd implementing async secure erases.
> It has same page cache races as async discards and write zeroes and
> reuses the common paths in general.

How did you test this?  Asking because my interruption fix for secure
discard is still pending because I could not find a test environment
for it.  And also because for a "secure" [1] erase proper invalidation
of the page cache actually matters, as otherwise you can still leak
data to the device.

[2] LBA based "secure" erase can't actually be secure on any storage
device that can write out of place.  Which is all of flash, but also
modern HDDs when encountering error.  It's a really bad interface
we should never have have started to support.


