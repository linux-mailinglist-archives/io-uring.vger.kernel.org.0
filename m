Return-Path: <io-uring+bounces-5442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A999ED084
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 16:55:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2877E28D8CF
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 15:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29EB1D9350;
	Wed, 11 Dec 2024 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9pGK4Pt"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5271D63E5;
	Wed, 11 Dec 2024 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733932504; cv=none; b=gnsB/eQ3Rh5T/itutyT/R0tDQ/W7mCyOr8CPa2zy6Yj+mv298g38vQQi+XNaDukf/a8qzdKExaZVUKR/zVfLQIwcL3jhXpr8PT0FANYXkbyjQPtXvET11UoqTjL2UxVT4otHU+I0RPrDU0abT7cIMfnVqkizgGxQkerihkEocQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733932504; c=relaxed/simple;
	bh=RXF+v+iA4+BiB0Hp3z1G8RrN4yADVTbgODi8hIUiO1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEJAoJBTFW1y5/ZPO23XXq8r50fwCB5vEpJtNTgz7BVuBVI8ovgqhVot0wEZzp4vXd6f7H8enf5VkADBsgENzrXefPEOPD5DstLKo3JtZGVZVuzj0Ld03d8fV9Tka22qZo88Q6yu3IrcKM/0/5AK2wvC+L7rT+z+WOSfOKBOTW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9pGK4Pt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5469BC4CED4;
	Wed, 11 Dec 2024 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733932504;
	bh=RXF+v+iA4+BiB0Hp3z1G8RrN4yADVTbgODi8hIUiO1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O9pGK4Pt++zvdFBgklMPWCnAFvBiDe4YY05JqNPcVx6H1GiCpOaClb3Lo2dEk5XzD
	 gPUBNpojjR7vfBI0DnyF+58ki1fIhfk30JuNQD2zYWjYHoD4Yk8Ya3JESiO7Zvr7BT
	 Sb/l7w3NXRvHLWVbo52B9XzyQJukl29QTegIjDo1WFO9zRKZVYBfTARlEDZlxBRJwu
	 9eh6toLFzVftkFEgU7iYWShvgSU/y9CzI5QQ+t4CJkv5CEjGwdz2dcBzBq5f9wSJJm
	 26iq7dZU4fjzYgJ44hB+EBom7yvU1RU0D4qAAb9K6PfgXrLA+uxPU+OQBd4X4uk+M9
	 7PMmoFXJv0YSg==
Date: Wed, 11 Dec 2024 08:55:01 -0700
From: Keith Busch <kbusch@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
	joshi.k@samsung.com
Subject: Re: [PATCHv13 10/11] nvme: register fdp parameters with the block
 layer
Message-ID: <Z1m11Vz7eIj-sxtq@kbusch-mbp.dhcp.thefacebook.com>
References: <20241210194722.1905732-1-kbusch@meta.com>
 <20241210194722.1905732-11-kbusch@meta.com>
 <a8964dab-8075-4417-bcf3-87c67fe758c0@oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8964dab-8075-4417-bcf3-87c67fe758c0@oracle.com>

On Wed, Dec 11, 2024 at 09:30:37AM +0000, John Garry wrote:
> On 10/12/2024 19:47, Keith Busch wrote:
> > +static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
> > +				      struct nvme_ns_info *info, u8 fdp_idx)
> > +{
> > +	struct nvme_fdp_config_log hdr, *h;
> > +	struct nvme_fdp_config_desc *desc;
> > +	size_t size = sizeof(hdr);
> > +	int i, n, ret;
> > +	void *log;
> > +
> > +	ret = nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
> > +			       NVME_CSI_NVM, &hdr, size, 0, info->endgid);
> > +	if (ret) {
> > +		dev_warn(ctrl->device,
> > +			 "FDP configs log header status:0x%x endgid:%x\n", ret,
> > +			 info->endgid);
> 
> About endgid, I guess that there is a good reason but sometimes "0x" is
> prefixed for hex prints and sometimes not. Maybe no prefix is used when we
> know that the variable is to hold a value from a HW register / memory
> structure - I don't know.

%d for endgid is probably a better choice.
 
> further nitpicking: And ret holds a kernel error code - the driver seems
> inconsistent for printing this. Sometimes it's %d and sometimes 0x%x.

It's either an -errno or an nvme status. "%x" is easier to decode if
it's an nvme status, which is probably the more interesting case to
debug.
 
> > +		return ret;
> > +	}
> > +
> > +	size = le32_to_cpu(hdr.sze);
> > +	h = kzalloc(size, GFP_KERNEL);
> > +	if (!h) {
> > +		dev_warn(ctrl->device,
> > +			 "failed to allocate %lu bytes for FDP config log\n",
> > +			 size);
> 
> do we normally print ENOMEM messages? I see that the bytes is printed, but I
> assume that this is a sane value (of little note).

I suppose not.

> > +		return -ENOMEM;
> > +	}
> > +
> > +	ret = nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
> > +			       NVME_CSI_NVM, h, size, 0, info->endgid);
> > +	if (ret) {
> > +		dev_warn(ctrl->device,
> > +			 "FDP configs log status:0x%x endgid:%x\n", ret,
> > +			 info->endgid);
> > +		goto out;
> > +	}
> > +
> > +	n = le16_to_cpu(h->numfdpc) + 1;
> > +	if (fdp_idx > n) {
> > +		dev_warn(ctrl->device, "FDP index:%d out of range:%d\n",
> > +			 fdp_idx, n);
> > +		/* Proceed without registering FDP streams */> +		ret = 0;
> 
> nit: maybe you want to be explicit, but logically ret is already 0

Yeah, we know its zero already, but there are static analyisis tools
that think returning without setting an error return code was a mistake,
and that we really meant to return something else like -EINVAL. We
definitely want to return 0 here, so this setting exists only to prevent
future "help".

