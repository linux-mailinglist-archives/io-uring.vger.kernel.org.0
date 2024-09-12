Return-Path: <io-uring+bounces-3159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4691497658D
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 11:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6BAF1F24D5E
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 09:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F6519CC27;
	Thu, 12 Sep 2024 09:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="brCrAwpz"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98949199EB8;
	Thu, 12 Sep 2024 09:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726133353; cv=none; b=KQrvvUog0pF2y+OiM18OgDfIihADiz2XBT3Oor6r1OHuyq/ZJopo5BShxuNJgKDcS+N/YeaArAn/H1u8+/OTOk80PNya5Io7SdrbC0hu3c8vSKB84ih8BASDiq22x97nJ/6AEHu2cKGz6y2M/oSyZCSwo03mIgfEayUgMjHDQRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726133353; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N49bJMu86ke9gg21vbkzZTlpd+oRZP1cDs9VW+1tAfGTShHZr8KSIX7T1y4ezLF+IbQ5I82o5GeGQ+Di1vHMK4jxirKN9c64xPomylZUbGZDoyuUh6kMOSHASW1eqVXWQ+kHbakybcvNY3RqvDBnvdYXZQ/Y7poI0VXiiYJIi78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=brCrAwpz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=brCrAwpzo66yaXnxZR8Td7aFRG
	WUoFwi2+j7oH6eDFjlz6CAkzlIgqsDKaUPdDhWPhzryl9wHwpq5j08cEhvMNp7WGGK8vB4+4oF+gD
	4/MWSp8OW5DyzAGeEhsEkhgl+dAtJqbL13qRaH6qsjTvgLi6dw8hoDVE/6KyqIZVMcddwmTTmAspR
	djUYX8vB5eRvB64jctUCZyI8qdoFGzVgOeuo6mJM1WBssoC2GlgeuW6mQIsyzmyMyju2mG1CKXUbu
	bo0+Qo3cFRdQbIrS4cLE9dDRUlF2LpYabBpFmAFj3ZryMRB6H4voshHOjUQHByZRhZonWQ+0i7eXJ
	UKJeediw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sog8U-0000000CWpw-26uv;
	Thu, 12 Sep 2024 09:29:10 +0000
Date: Thu, 12 Sep 2024 02:29:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 4/8] block: introduce blk_validate_byte_range()
Message-ID: <ZuK0Zse23NLlHczb@infradead.org>
References: <cover.1726072086.git.asml.silence@gmail.com>
 <19a7779323c71e742a2f511e4cf49efcfd68cfd4.1726072086.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19a7779323c71e742a2f511e4cf49efcfd68cfd4.1726072086.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


