Return-Path: <io-uring+bounces-6346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B250A31208
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 17:49:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7820018819B0
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 16:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BF825E47A;
	Tue, 11 Feb 2025 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sZUvb4jN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C636125E456;
	Tue, 11 Feb 2025 16:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739292481; cv=none; b=Kzkysh/0VCMLRY6j0HzfPMxWAY8SSHENRHegKpjHsGrya0gB0eNDGEfbFVq0RjxjN+WmHo88OyWF0qcyprLry1x0FSAZTK3TJ+7JMUWaXMJ+CwoBVb13vAwoObrIC+nb6WaNgjxAlXq8+RF7g6Hs69aP3pGKAOyV1VcjYVmhTIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739292481; c=relaxed/simple;
	bh=kb4UM6y8G5HP+N08p5oQOse4kpNNJSrfsJ69HuhENPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2BJ3RU+PoBCB1f+nEgtg1eGHlqlJW+JVAMVe+MMvxIZ7ZXRfe1CqmWxsEVbOUzkVkPO72KfrQDp6tVgHRNNxgIgigH7/2jLbCyvUxICypDSFbcJZxCP/cPx2WEziEstLV702k227jEiQEZijppTUAqHISvHUFAYsWavJ30i5Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sZUvb4jN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF27C4CEE5;
	Tue, 11 Feb 2025 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739292481;
	bh=kb4UM6y8G5HP+N08p5oQOse4kpNNJSrfsJ69HuhENPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sZUvb4jNgsUfi3iy8kRx/Gr2yQIz8JPMDF6FFqNjpiQ/b0heGesu8WfNYsd5WDpOV
	 JmQfJBTL6MKkwScqq/MvLMCw8ZCV5SINmVymFWkv6Tr7FJ5Iq5ZohoGGLIFRT4CV7e
	 viEJ8aoclFe9GWfxaQDZrkxd/PCO3voelaDK+0B2b8ZvOURJ7krCn+hGOjycQUtuW4
	 vEr4LfLrj1gmC/4QQebViJMpeVdgczLc07bir21uPJZ59aDDkzp12oCIHZ6HYRCXtR
	 /XDztJjJ+7e7yMyzothCnGLozBseHVmtf1AH8zlxNhjo7MHzA1gxDsROWc8F52uc+Y
	 0VAN8k/rSDTFA==
Date: Tue, 11 Feb 2025 09:47:58 -0700
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv2 6/6] io_uring: cache nodes and mapped buffers
Message-ID: <Z6t_PhKAOqr832cR@kbusch-mbp>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-7-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211005646.222452-7-kbusch@meta.com>

On Mon, Feb 10, 2025 at 04:56:46PM -0800, Keith Busch wrote:
> +static __cold int io_rsrc_buffer_alloc(struct io_buf_table *table, unsigned nr)
> +{
> +	const int imu_cache_size = struct_size_t(struct io_mapped_ubuf, bvec,
> +						 IO_CACHED_BVECS_SEGS);
> +	int ret;
> +
> +	BUILD_BUG_ON(imu_cache_size != 512);

This isn't accurate for 32-bit machines.

