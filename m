Return-Path: <io-uring+bounces-10947-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62791CA343D
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 11:43:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6CDA6309041D
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 10:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644EB2EDD6B;
	Thu,  4 Dec 2025 10:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="noxH6+8O"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C9D296BC9;
	Thu,  4 Dec 2025 10:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764844956; cv=none; b=soqoWhDm9ijMuBb4E1qxX6+MGL81QJCNTRSg16mYFhcYEPM6cSX5k9dzRrDBPA+r8z0TIlmrRxXZT4lNraEWvAYcH3ih9DdxBLkoCTeYcrJC79FAKO1qd3a6/IXefVttpV2j1mDV++nXj5war0g0A3mM17hWbZFY1hK946u4iP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764844956; c=relaxed/simple;
	bh=Sk0c9ySLwyv3PWosm5D9ylr49lwjLw3H0vMtp33qokk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VT6jgUuh6I4OEiKA7ZQqcgQvMO3mlR7LltzTyRUChIcv6iO9Fbd+pZpV7L5LlwWSWC4IBMmZ4+ofmA2r0TEqpg+7T4qdbZ4tw8b6IQZtgpNH9Egc0i/yJN8SfiVSWCpoNPU8w4aTR4ubpZZv+Vwhiq0fKQFd0SPgtQoQRgQr1Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=noxH6+8O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mYIPCZ9n2K8+l0Gix4a6otBKT7xg4fSdpmU162wQnJQ=; b=noxH6+8Od8sMzmzZRt5gUssBuP
	GOmRIOq3Vz9f3o9mJfOjdsj5HEh52s/Y1/M8eh/Zks06QpLfEGmxbQJ22mK/bNnPVDE4mD51iXsuV
	pwKj+fW9AYwmpuWFCD2Wp1d/OjkAvxLGUCU152XKOI2imx8GHsBjuUX5KDNn5rEXAMdFsneRgwxn+
	dpHNojBUcJ4Ls45KjBL12q+jkihtWZFg8Cp79yX87Gekt4KzaQPzco7oAnOxAg5HW7wPdfd4gY666
	I+7+YhnCA/2ijaKoskULXk0V45aToHmyXggBIDPd9ua32Kw7Jcoci0bMptHXlcqXzoCJs2qysJ2wo
	chCfON3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR6n9-00000007r23-1Ff2;
	Thu, 04 Dec 2025 10:42:31 +0000
Date: Thu, 4 Dec 2025 02:42:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [RFC v2 01/11] file: add callback for pre-mapping dmabuf
Message-ID: <aTFllxgsNCzGdzKB@infradead.org>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Nov 23, 2025 at 10:51:21PM +0000, Pavel Begunkov wrote:
> +static inline struct dma_token *
> +dma_token_create(struct file *file, struct dma_token_params *params)
> +{
> +	struct dma_token *res;
> +
> +	if (!file->f_op->dma_map)
> +		return ERR_PTR(-EOPNOTSUPP);
> +	res = file->f_op->dma_map(file, params);

Calling the file operation ->dmap_map feels really misleading.

create_token as in the function name is already much better, but
it really is not just dma, but dmabuf related, and that should really
be encoded in the name.

Also why not pass the dmabuf and direction directly instead of wrapping
it in the odd params struct making the whole thing hard to follow?

