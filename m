Return-Path: <io-uring+bounces-3160-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B8A9765A9
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 11:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D5E91C23189
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 09:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FF21A0BDD;
	Thu, 12 Sep 2024 09:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZX79e4j5"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EA21A0BCB;
	Thu, 12 Sep 2024 09:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726133467; cv=none; b=u7FdCP6li46h7TaZaa4yQ6ehLyAeD1hXaj0p21k2T8h8fZG+jyEQbD8aNalNCIvPY0QQiznuAgop3S+e8s95YrYpwylbl40YtwbqdsFCIkym2Mkw4ptfC7gdzJoFtD3p5LIWRbDAkZ1pGycV8ZUMCCjV8qeSRBh7lt3SIGlJQyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726133467; c=relaxed/simple;
	bh=o8ezR3WNgwF0dzqPJg5vLYdqQt2UsY2WIjtzrhvzchw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IlWxPnan4//EnqYeQZq7z/lkNC5qI6ayCZUI8/tINNOkQAJODPFcTSNkdBrHxKYScVWkuF/o/aDgOV9iliS6UQLI25yn2rS+o9OCqZ65JZjv3JYigmjNM7G5wcvJD4iW/Nb/DZ9lQhxo2fjkZ2woKBvztOU1aNi74Rd+1Jn6bDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZX79e4j5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fEDX5bM20mH2/Omar9IVkN5H60WcnkX1hb9UHnysmfw=; b=ZX79e4j51fts132lM3D1lXFya/
	TtuSDTUVkEboUc66IH1Crwjig2qJX78vBHx0SSZWiX1M9V7t9CWP183p9FAMobkFBB9GswQ1Icq8J
	3Dr60zE+ltv651gj33qsxUlbRk974LUehp6CI/SmZxXf9gZWMGOO5MDjvw5Owa7/PD+HPI+7ljZkn
	4JJjCeEqLuGb3N/VGD/GiPXPQMrvkFLUTU6GiJJv6B5ue2ya9erzANwkP9Sktgh3xwX8pHCWm7Iz0
	n00bHY7QDVsNtlVVOSYIW+GFQUVWYXtQ08nNtTbsnkuqXo7rimIBau7yMGbu1Tnj96J5oSnBHI+/a
	DfmAOkiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sogAK-0000000CXHZ-2nAw;
	Thu, 12 Sep 2024 09:31:04 +0000
Date: Thu, 12 Sep 2024 02:31:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>,
	Conrad Meyer <conradmeyer@meta.com>
Subject: Re: [PATCH v5 5/8] block: implement async io_uring discard cmd
Message-ID: <ZuK02DNxedLnmL9j@infradead.org>
References: <cover.1726072086.git.asml.silence@gmail.com>
 <2b5210443e4fa0257934f73dfafcc18a77cd0e09.1726072086.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b5210443e4fa0257934f73dfafcc18a77cd0e09.1726072086.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> + * io_uring block file commands, see IORING_OP_URING_CMD.
> + * It's a different number space from ioctl(), reuse the block's code 0x12.
> + */
> +#define BLOCK_URING_CMD_DISCARD			_IO(0x12, 0)

Please just start out at some arbitrary boundary, but don't reuse
the ioctl code from an ioctl that does something vaguely similar for
no good reason.

The rest looks good.

