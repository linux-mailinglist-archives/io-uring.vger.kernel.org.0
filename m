Return-Path: <io-uring+bounces-4737-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 890C39CF387
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 19:04:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34F0E1F2407A
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 18:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9651D79A5;
	Fri, 15 Nov 2024 18:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mLRtysRU"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543671CDA3F;
	Fri, 15 Nov 2024 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731693850; cv=none; b=rAqIcITMHiCqErRmW0l3rs4XWH+0XYpQZwX/V1CDeO5SGMpj+gbVuTHnSOXSeX+ZlZE/jFIsqqa5EkvyN0k3uPMX6+s1xsSaHFO/5PKXXy6XTTk0vqPdDbwrPgyY6AOFg8YnJcgUnRxkhIV5xZquozt/PgQ9F9uRIcJ3wsSJVUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731693850; c=relaxed/simple;
	bh=LPDOMZz6KV6iIi1jEYmzOnjPnCesxzIIxDTmzHaPhFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfsToVQmLDqKiA/k4qrDywdSqNzEAaxdl88Z4bQsB0aebLohdh/Ju6R0yCUz+C2kfnG/MHkDyYUXLv0og3mv1bP9XQd2QB2T2F27MKNlXTdfBzOIDP6IC2HB8Tx3slP7Zljc0rpzJP7JXNXUVdlOAR9yIBrUZvYVcwc3nic6rPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mLRtysRU; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=E2BNdGt9ER/nWRwbgvy7UUTAJ2vjHj29ke2nprS1nqE=; b=mLRtysRUSQWEXTgW0c4C6kFIrP
	2DbechyxUleqgdzwz+N6MegMggR0Uyr3mTxTTI9dNesYFLPGVl+DtM7fVkThDaFww6S4A9Vtm9OAC
	T8Ux6eQr0HDmFTqJVmuhaBXyJ/hI1075TQBZUNQzmTW4xnN7twG4vu0Tmmfu2/KlQ5+Yjj5HhiTVo
	XH0D0+YvgPnm/I8BcYTadFTYdW5uHe9MrXEluzEVrszfaQOPKAFLW2IkbuXyqZzR/bojlfPXBZKfn
	isHFuCTBr9HyMXSo4fzJOn6H3Wg2h6FYNDpd0gzcoI70i77zpzW7XKbUZKlf2CZSvQclgdYJ+3qzR
	onR+8a5Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tC0fp-00000000AIu-1usX;
	Fri, 15 Nov 2024 18:04:01 +0000
Date: Fri, 15 Nov 2024 18:04:01 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v9 06/11] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <ZzeNEcpSKFemO30g@casper.infradead.org>
References: <20241114104517.51726-1-anuj20.g@samsung.com>
 <CGME20241114105405epcas5p24ca2fb9017276ff8a50ef447638fd739@epcas5p2.samsung.com>
 <20241114104517.51726-7-anuj20.g@samsung.com>
 <20241114121632.GA3382@lst.de>
 <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fa101c9-1b38-426d-9d7c-8ed488035d4a@gmail.com>

On Thu, Nov 14, 2024 at 01:09:44PM +0000, Pavel Begunkov wrote:
> With SQE128 it's also a problem that now all SQEs are 128 bytes regardless
> of whether a particular request needs it or not, and the user will need
> to zero them for each request.

The way we handled this in NVMe was to use a bit in the command that
was called (iirc) FUSED, which let you use two consecutive entries for
a single command.

Some variant on that could surely be used for io_uring.  Perhaps a
special opcode that says "the real opcode is here, and this is a two-slot
command".  Processing gets a little spicy when one slot is the last in
the buffer and the next is the the first in the buffer, but that's a SMOP.

