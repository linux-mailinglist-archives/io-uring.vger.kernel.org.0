Return-Path: <io-uring+bounces-5319-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 832BE9E9686
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 14:23:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 230A328305B
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 13:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00251A23BA;
	Mon,  9 Dec 2024 13:18:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715921A238B;
	Mon,  9 Dec 2024 13:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733750306; cv=none; b=g8TyduTjwRNfYhEDwAj4ZVCYLQ0sjYNWwWXvNrXQTvIDd2Bufhe+XLCpbF/ixM0e5WRcgPGRDoT0c1Eks+p6BLcLYMtaMbhJhAmlzLpiplwbGNsdd2hLmcUigR/sDvuN4sB3yh5ofxN9QTZHlYszcLGEObr0QYLen7T+yEsc+us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733750306; c=relaxed/simple;
	bh=Hdemvw6Baj4yVB7LxBoVj/o9obmxvG3nn5l0hCBx/OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqmowgGh7O78Vifxa7B2m2gM4zWo7wBNFnfHPmDRr6rIMf1VSZLVHKMvlmbrnwUa6kHzRujteMGL8pxKhke9+iVGza47rf8Vegud/AFEZLoOxgagNXaESQbgPOCIu/Kv0p2Xzy312bPYbBrLuKn/guOCEBMiMSAKGE50mNJ0Ie8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AF3DA68D09; Mon,  9 Dec 2024 14:18:19 +0100 (CET)
Date: Mon, 9 Dec 2024 14:18:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv12 11/12] nvme: register fdp parameters with the block
 layer
Message-ID: <20241209131819.GA16038@lst.de>
References: <20241206221801.790690-1-kbusch@meta.com> <20241206221801.790690-12-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206221801.790690-12-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +static int nvme_check_fdp(struct nvme_ns *ns, struct nvme_ns_info *info,
> +			  u8 fdp_idx)

Maybe nvme_query_fdp_runs or something else that makes it clear this
is trying to find the runs field might make sense to name this a little
bit more descriptively.



> +{
> +	struct nvme_fdp_config_log hdr, *h;
> +	struct nvme_fdp_config_desc *desc;
> +	size_t size = sizeof(hdr);
> +	int i, n, ret;
> +	void *log;
> +
> +	info->runs = 0;
> +	ret = nvme_get_log_lsi(ns->ctrl, 0, NVME_LOG_FDP_CONFIGS, 0, NVME_CSI_NVM,

Overly long line here, and same for the second call below.

> +			   (void *)&hdr, size, 0, info->endgid);

And this cast isn't actually needed.

> +	n = le16_to_cpu(h->numfdpc) + 1;
> +	if (fdp_idx > n)
> +		goto out;
> +
> +	log = h + 1;
> +	do {
> +		desc = log;
> +		log += le16_to_cpu(desc->dsze);
> +	} while (i++ < fdp_idx);

Maybe a for loop makes it easier to avoid the uninitialized variable,
e.g.

	for (i = 0; i < fdp_index; i++) {
		..

> +	if (ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
> +		ret = nvme_query_fdp_info(ns, info);
> +		if (ret)
> +			dev_warn(ns->ctrl->device,
> +				"FDP failure status:0x%x\n", ret);
> +		if (ret < 0)
> +			goto out;
> +	}

Looking at the full series with the next patch applied I'm a bit
confused about the handling when rescanning.  AFAIK the code now always
goes into nvme_query_fdp_info when NVME_CTRL_ATTR_FDPS even if
head->plids/head->nr_plids is already set, and that will then simply
override them, even if they were already set.

Also the old freeing of head->plids in nvme_free_ns_head seems gone in
this version.

Last not but least "FDP failure" is probably not a very helpful message
when it could come from about half a dozen different commands sent to
the device.


