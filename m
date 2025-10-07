Return-Path: <io-uring+bounces-9908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 348F6BC0581
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 08:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FD7E189CAF7
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 06:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4712C1F936;
	Tue,  7 Oct 2025 06:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XlGBxVrO"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39EC1D7E41;
	Tue,  7 Oct 2025 06:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759818802; cv=none; b=lPiXWB7j6m0AdsrTvKJm5EYuYm/uxHoShYkpdtQI8+q0kaeLaANAHOdACvSrCZHQOE6MaV5kOdFweMKwFODqcdb68CH2JAVWBFXu4SAQ2/ts8s7ZR0F/fucVBLsZCs7aRmlJicClElcQrwGEee3iTXc9Dt5lDIlDjkA+b04ZPJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759818802; c=relaxed/simple;
	bh=6WXeHyLqz/3hzI1qpD8zClbG7l4RzXiMFgiQMqQvHdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EAea3eDzC6btOs/m3i8TwkJEeLPHxbWI01+C8ypcCrgVqm6cW+ptPYKYsSnOFkR8cZ/e8HqoT/jHsb92NUzyU9pU94+SlOPL9xfPo7f+gaS8/+UXE833ZppbiDL1kGJBZqT8PEWeOYNxs7qqy8TUbMOmO+0b0psz+QBcRaswu0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XlGBxVrO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8nHrEDFMgU2PWvCGKXkRqt0J6PV5fTZTmGr4X1Gx/wM=; b=XlGBxVrO/oeHup++rky/KRKst1
	/QBvNwL9RcmvU7llfXtCT7s3vkglGimotL3mBCaNN2FMNPWvAZWJCSJ6EgIcXlzOZHrCGnHi/RICK
	lCRC3Bd0BZnRM/NoK5AhmmoIOU54bbK/OkjLK2mWzW26FrV1e2mqbU10QLwoZ+ORXZ9+5M68JJ9vI
	HIj17T6l+pvCPONdPSkeji+VoY2bmF2MJW3xmmfXp9wJ/IeKKfUNg1CQ0zu2ndT5ImO9tlTnaL1Hx
	b6CblLMKCRIAoo9by1fzNUR8HjrdfOxNVFPFdT/4vNZD/5cw9ORRzHzcoIfRP9akerZu1hg/x/ADO
	HnnGHfVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v61G9-00000001N5L-3jLs;
	Tue, 07 Oct 2025 06:33:17 +0000
Date: Mon, 6 Oct 2025 23:33:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH V4 6/6] loop: add hint for handling aio via IOCB_NOWAIT
Message-ID: <aOS0LdM6nMVcLPv_@infradead.org>
References: <20250928132927.3672537-1-ming.lei@redhat.com>
 <20250928132927.3672537-7-ming.lei@redhat.com>
 <aN92BCY1GQZr9YB-@infradead.org>
 <aOPPpEPnClM-4CSy@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOPPpEPnClM-4CSy@fedora>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 06, 2025 at 10:18:12PM +0800, Ming Lei wrote:
> On Fri, Oct 03, 2025 at 12:06:44AM -0700, Christoph Hellwig wrote:
> > On Sun, Sep 28, 2025 at 09:29:25PM +0800, Ming Lei wrote:
> > > - there isn't any queued blocking async WRITEs, because NOWAIT won't cause
> > > contention with blocking WRITE, which often implies exclusive lock
> > 
> > Isn't this a generic thing we should be doing in core code so that
> > it applies to io_uring I/O as well?
> 
> No.
> 
> It is just policy of using NOWAIT or not, so far:
> 
> - RWF_NOWAIT can be set from preadv/pwritev
> 
> - used for handling io_uring FS read/write
> 
> Even though loop's situation is similar with io-uring, however, both two are
> different subsystem, and there is nothing `core code` for both, more importantly
> it is just one policy: use it or not use it, each subsystem can make its
> own decision based on subsystem internal.

I fail to parse what you say here.  You are encoding special magic
about what underlying file systems do in an upper layer.  I'd much
rather have a flag similar FOP_DIO_PARALLEL_WRITE that makes this
limitation clear rather then opencoding it in the loop driver while
leabing the primary user of RWF_NOWAIT out in the cold.


