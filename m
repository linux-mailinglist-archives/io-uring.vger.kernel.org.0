Return-Path: <io-uring+bounces-3098-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43951972B42
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 09:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E05971F250BB
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 07:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB6F5183094;
	Tue, 10 Sep 2024 07:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qwSBJk87"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0111531D6;
	Tue, 10 Sep 2024 07:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725954903; cv=none; b=eF8PdSwLypdLMDp23RQ8lS1C85Fw4fwDaZD64iOM2iI1mpksD3EMfy+wgDEDGjoomYbJqlvfxg0T2TdbRJCZPtKmmm8H+28WAqfe8oiDrm3DmL/vvs5jA9E1ML0yrZp4VIN4GYgrjZ/N7GZcVfwNFw7kFXvkNHqPSYG9PD7jbCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725954903; c=relaxed/simple;
	bh=119DqnyhRGjPU45aVcHooh2FEPVT6S76KbUx3Klcbo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EndR6GB5xFFhzm+wnAcLLzbevn57H7EnjNKZG3Gt6/j+mAqi+lVI3XDuEdmpaQM7F82wlYwJReCLH7DAtcssPp92Jyo2HaPLCF4IWtQuCa+akVwGCM/bONOwtmFkfV3zzvNlIq56HinXHYOH/Ly7JqcB/1Ws5oqMLzeC+zY1gAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qwSBJk87; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/ZPkCZmbikRSq/2b+QWw33g2N1kYN0TfRZpBZuVjOHA=; b=qwSBJk87Z3jmZakvlsD5Dv3kuB
	q1u+ewyu5wRQP8Nug7n+3q03WXKQTHA9Da5VHzZUSRCbBBbvY5S2tT19Wob/5366XzraBxGAmFnGn
	Vkru5EwK3cSiu1MCFOixr3LrkIXh2tSLcZKfpoX/KZJ8mbkn55wKfR9hTRumgihoxIyQ4xMxclNAe
	NiyaHoqlLAew7gQn3vYH1lOQTFaV2SrUXyOW3IcW9fQmQ34tAfD/2gl+Wk3d9em074EjBj5m7MxBz
	6/x5BG1+SMFPBAaYAwwk4iIU0QyVFnlmXBJ3inFR2b4OdpmaPLy26JjkFw8icL8VLWrHaiqdTddpK
	/lPEhIDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snviH-00000004ggT-0MGE;
	Tue, 10 Sep 2024 07:55:01 +0000
Date: Tue, 10 Sep 2024 00:55:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
	linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 4/8] block: introduce blk_validate_byte_range()
Message-ID: <Zt_7VXA1sMqVz9th@infradead.org>
References: <cover.1725621577.git.asml.silence@gmail.com>
 <fa8054b786555785c7a181fbd977539342960fe4.1725621577.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa8054b786555785c7a181fbd977539342960fe4.1725621577.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 06, 2024 at 11:57:21PM +0100, Pavel Begunkov wrote:
> +static int blk_validate_byte_range(struct block_device *bdev,
> +				   uint64_t start, uint64_t len)

A little comment explaining what it validates would be useful here.


