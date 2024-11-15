Return-Path: <io-uring+bounces-4714-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 757939CDB28
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 10:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC249B223A8
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 09:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF54416D9DF;
	Fri, 15 Nov 2024 09:10:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD2018785D;
	Fri, 15 Nov 2024 09:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731661835; cv=none; b=JwSL/Y5Svvj23uLumpq3EhKvqKjXveSr6CmJ+YtYU515xDOWXa6Fb9Fg8xHbkn3eRg7Vo9gJLTI0Baj+x6dnJEEEgOSMkSBCQke+uEiN1EwsSESucoDC6rn6hQC3mYzgPAAh0o5KuIURhptU3CsPpLMNgk8KckJ1LZrWjt5vPWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731661835; c=relaxed/simple;
	bh=Pm75xYlE75CbvokVYLXl+3gSwliF/tT8QchOJ2JV2dQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jI2U9m9YttDR8yQ6FFljN/Dfi3PNmOrntf81/LRKYMOpVxu3jbdIYhqLAbhApGkavVA0fbWHDY3EbkRXNIs1UjrPfhuMwsTpjiO+ZDhTb7mwsrBloU/xLdzKXDrfT+ig9l49qxZ1p0e9ieUwLjhMML7hhT41X4YIBrKC77Zy4cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 00DA968C7B; Fri, 15 Nov 2024 10:10:27 +0100 (CET)
Date: Fri, 15 Nov 2024 10:10:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 4/6] block: add a rq_list type
Message-ID: <20241115091027.GA1149@lst.de>
References: <20241113152050.157179-1-hch@lst.de> <20241113152050.157179-5-hch@lst.de> <20241114201103.GA2036469@thelio-3990X>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114201103.GA2036469@thelio-3990X>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 14, 2024 at 01:11:03PM -0700, Nathan Chancellor wrote:
> This change as commit a3396b99990d ("block: add a rq_list type") in
> next-20241114 causes errors when CONFIG_BLOCK is disabled because the
> definition of 'struct rq_list' is under CONFIG_BLOCK. Should it be moved
> out?

Yes, this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


