Return-Path: <io-uring+bounces-9972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CE33FBD1AD3
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 08:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 586154F04B9
	for <lists+io-uring@lfdr.de>; Mon, 13 Oct 2025 06:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624822E2846;
	Mon, 13 Oct 2025 06:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i9gLTuyT"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854272E0902;
	Mon, 13 Oct 2025 06:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336789; cv=none; b=rdxJyvhZJ8QkCApr9asqaPBOMpIgyTz5uZrK6aZ915dtqnQEBSEQm+07vilC5oSij5BUify6vXg5HESRqvpIPI6SnixcRE+UL9cwoIN9TnGLcOaDjryykDYRUj2J4lIgTTcjMzy+PqCN5YRwzUqfGD1aiJR54qPcVcD3wZXROqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336789; c=relaxed/simple;
	bh=vbKncTUnW0SDgxIMV/xZOHOGhSy4m/PbQfk2ZEL7F34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y56F6iFDTuTDqNEy2of7O52MMuGb7Lvn3SrFi7laB+49vg1eiEao5oBbUOspbkfFtEjjIG8kwhXEv46CFM7aEieOWYqnr86ky/5W1gbLCO744Et5wR3fYTpbhHgvdlh2yaiOB8yJFf8WRH8Dwek67yETvg+dVOFvaAVOMVQ2GTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i9gLTuyT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kIugL04z9TJ0M/06doyNc0me9LOxYYhXKGY7hU7qIYs=; b=i9gLTuyTpsPUOnpl7T1yAsaW6n
	apUI7yby3tuZZLYxHc5Vzgon9ZxSdrRB3N1XrDjdXLW7FsfksXepGLIjppFDMzW9PXBemX9rDVFnu
	cq8+uaMukIUxQcjHTBWzAjE8MlzPVSUJnYYISZbUo8A8Nld0RYl3gJ9/h4gDpvDhVA2KH1/5mvCd5
	BqeY0lULi2AN32ybEl13VTyfwAgw1wxOZdzer7SSr75URabqpa6NsQyobqi/m80y3g7hv2hZSgBPo
	btWHV0mz6wf4QMD3NIUL9z96dkO8094QlUMAJm8u6U34E/ZooV2iDms4HgZzGPC18kUNVSjC2Otg7
	TjIIV5DQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8C0m-0000000CNjo-2bVN;
	Mon, 13 Oct 2025 06:26:24 +0000
Date: Sun, 12 Oct 2025 23:26:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH V4 6/6] loop: add hint for handling aio via IOCB_NOWAIT
Message-ID: <aOybkCmOCsOJ4KqQ@infradead.org>
References: <20250928132927.3672537-1-ming.lei@redhat.com>
 <20250928132927.3672537-7-ming.lei@redhat.com>
 <aN92BCY1GQZr9YB-@infradead.org>
 <aOPPpEPnClM-4CSy@fedora>
 <aOS0LdM6nMVcLPv_@infradead.org>
 <aOUESdhW-joMHvyW@fedora>
 <aOX88d7GrbhBkC51@infradead.org>
 <aOcPG2wHcc7Gfmt9@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOcPG2wHcc7Gfmt9@fedora>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 09, 2025 at 09:25:47AM +0800, Ming Lei wrote:
> Firstly this FS flag isn't available, if it is added, we may take it into
> account, and it is just one check, which shouldn't be blocker for this
> loop perf improvement.
> 
> Secondly it isn't enough to replace nowait decision from user side, one
> case is overwrite, which is a nice usecase for nowait.

Yes.  But right now you are hardcoding heuristics which is overall a
very minor user of RWF_NOWAIT instead of sorting this out properly.


