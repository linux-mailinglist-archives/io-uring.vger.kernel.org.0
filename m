Return-Path: <io-uring+bounces-4838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04C859D2DC6
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 19:19:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E16EB2F8F8
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 18:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD621D0438;
	Tue, 19 Nov 2024 18:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N8EeqhnQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB26943179;
	Tue, 19 Nov 2024 18:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732040261; cv=none; b=Rq0UO7DAYDVkHKQXeWG/CjEdX0oQWGBmEieRt54t9xwYpW1ugQJ7l9U4bfvQeNN0QoEPhMoAmloyQov1wipEJL62t8/SKqssAoupj44kctOD1lgq6EHT4HTvPKWwkLIyE/cx8YV5fQFspmVSscT6t1bpWBwZ8ayZoMG1+GeLG7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732040261; c=relaxed/simple;
	bh=1Rx6a5V84mNsHyGKKeXNKMM/vPdlFSELDYwqEbiBPeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rhwngnu3Zo4z9O2XzTT2U+gVi4cOsJI0KQLcrQIPunWkmdbjEip72ZBvTiZmhQcVTEID3rn8yF67b04soWKr83u7KWIjZOEk7fF5ldfTgNGd8lW8XtX0BY0JEOihPJmlURGSOmTTCry8uyoraqzTYstkvAPXSkNiUHbjREPdosA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N8EeqhnQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE76C4CECF;
	Tue, 19 Nov 2024 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732040260;
	bh=1Rx6a5V84mNsHyGKKeXNKMM/vPdlFSELDYwqEbiBPeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N8EeqhnQi6uKCJjvjP6uWGWQ8590S9VIKoLh/HP/xmwfn+waAhC5hVS6XeGvcfHjM
	 WbJkdkFCu5UF/JOREe3/7z8j1PG4tOC52enCBYjrNVysiReas4HAZYXZk8RpbJACAr
	 fYj/9RvaTp0FA9LEtZXQ14k2n/5lEc/KwZjItXNX4Vt+w+ZsYjR0/nVE7/Hk0PtqXZ
	 yy3boh8RLCcHgPcsZGw+PWUo3IyDOiDjchIBIiq6YQ5hpJSTx9Vfr9wCRSCx2NahZD
	 TrTS0wtbty5NsrIWSDF7LrJ6fkG66Jlm+zyLpMoNF/N5+igSMjrHB0XBS/K8dOKrcS
	 6kXkMdfjTLQwA==
Date: Tue, 19 Nov 2024 11:17:36 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>, Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>, Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH 14/15] nvme: enable FDP support
Message-ID: <ZzzWQFyq0Sv7cuHb@kbusch-mbp>
References: <20241119121632.1225556-1-hch@lst.de>
 <20241119121632.1225556-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119121632.1225556-15-hch@lst.de>

On Tue, Nov 19, 2024 at 01:16:28PM +0100, Christoph Hellwig wrote:
> +static int nvme_read_fdp_config(struct nvme_ns *ns, struct nvme_ns_info *info)
> +{
> +	struct nvme_fdp_config result;
> +	struct nvme_fdp_config_log *log;
> +	struct nvme_fdp_config_desc *configs;
> +	size_t log_size;
> +	int error;
> +
> +	error = nvme_get_features(ns->ctrl, NVME_FEAT_FDP, info->endgid, NULL,
> +			0, &result);
> +	if (error)
> +		return error;
> +
> +	if (!(result.flags & FDPCFG_FDPE)) {
> +		dev_warn(ns->ctrl->device, "FDP not enable in current config\n");
> +		return -EINVAL;
> +	}
> +
> +	log_size = sizeof(*log) + (result.fdpcidx + 1) * sizeof(*configs);
> +	log = kmalloc(log_size, GFP_KERNEL);
> +	if (!log)
> +		return -ENOMEM;
> +
> +	error = nvme_get_log_lsi(ns->ctrl, info->nsid, NVME_LOG_FDP_CONFIGS,
> +			0, 0, log, log_size, 0, info->endgid);
> +	if (error) {
> +		dev_warn(ns->ctrl->device,
> +			"failed to read FDP config log: 0x%x\n", error);
> +		goto out_free_log;
> +	}
> +
> +	if (le32_to_cpu(log->size) < log_size) {
> +		dev_warn(ns->ctrl->device, "FDP log too small: %d vs %zd\n",
> +				le32_to_cpu(log->size), log_size);
> +		error = -EINVAL;
> +		goto out_free_log;
> +	}
> +
> +	configs = (struct nvme_fdp_config_desc *)(log + 1);
> +	if (le32_to_cpu(configs[result.fdpcidx].nrg) > 1) {
> +		dev_warn(ns->ctrl->device, "FDP NRG > 1 not supported\n");

Why not support multiple reclaim groups?

> +		return -EINVAL;
> +	}

> +	ns->head->runs = le64_to_cpu(configs[result.fdpcidx].runs);

The config descriptors are variable length, so you can't just index into
it. You have to read each index individually to get the next index's offset.
Something like:

	struct nvme_fdp_config_desc *configs;
	void *l;
	int i;

	...

	l = log + 1;
	for (i = 0; i < result.fdpcidx; i++) {
		configs = l;
		l += le16_to_cpu(configs->size);
	}
	ns->head->runs = le64_to_cpu(configs->runs);

