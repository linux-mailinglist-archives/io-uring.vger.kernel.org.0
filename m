Return-Path: <io-uring+bounces-6436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBECEA3619D
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 16:26:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9519316B823
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 15:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5C6266F08;
	Fri, 14 Feb 2025 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/rfFuvA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EA9266EFD;
	Fri, 14 Feb 2025 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739546781; cv=none; b=YTEEOijibkiQwbAavxF7JqVzrW8Yiie5ZIExfn+dubpfObuxNlStdjDYUVu7ERGae8nxSrD84XkEOc6HSN3gnN6JOJTKNr4XPE+yXrQqDLFT+vctuBs4exbOrK+czKQ83eprZ+Q3JV3CDj9unsV7H/Jk4ZSYaRzc6ocCRFoWaT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739546781; c=relaxed/simple;
	bh=CuJ2gzdoI2RP5H2P4WDu+5TgwOgiUndF6rIhVTEIIjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fPT7VJBY+wuzCBI18TZwDrWb6sTaJteAUD4qQvdm4aZN5BBapEycB5GpYV4zo5CQ3pOGYZ5tBRfEGOaxMCY0qyhGXkLOxCmwBybNzlpzGI2UlXypHci05jVGNiewPDvVfC3uJod3mpVV2FWQi5j+4g/lVK+EhxKb5M9NpT0PA/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/rfFuvA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696E8C4CED1;
	Fri, 14 Feb 2025 15:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739546780;
	bh=CuJ2gzdoI2RP5H2P4WDu+5TgwOgiUndF6rIhVTEIIjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a/rfFuvAk2s9Qvb+V6KthceRnM2FCCRkj0Vupjq3NNsO7N7vFCx4X+1c+7UA9VChq
	 Nv6L2ubXcO82rScFtXw07v7w4aeTbw/c4bGc6OHRXt6Ybv33Tgk1csMMQtkPAcPSdE
	 QurUCWIYZH2DdvO3p8gYAIAkXhOYgktrmXgyw6tjR28wvMzrKRxFUghsH9tT7EngHb
	 fuY60Rl4TYV59HJptBi6IbtbReS575bMZwjz3SyVEqHlqsQsDRcn6h2X4IaiQaghAG
	 EnNqWgWo5QAC00zb1CPpGUaRzIBxthpJaj3Ox8ggEQliEdZ8juEtrPMph69so5pZNs
	 wNKdBgFNBf7nA==
Date: Fri, 14 Feb 2025 08:26:17 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com
Subject: Re: [PATCHv2 3/6] io_uring: add support for kernel registered bvecs
Message-ID: <Z69gmZs4BcBFqWbP@kbusch-mbp>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-4-kbusch@meta.com>
 <Z664w0GrgA8LjYko@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z664w0GrgA8LjYko@fedora>

On Fri, Feb 14, 2025 at 11:30:11AM +0800, Ming Lei wrote:
> On Mon, Feb 10, 2025 at 04:56:43PM -0800, Keith Busch wrote:
> > +
> > +	node->release = release;
> > +	node->priv = rq;
> > +
> > +	nr_bvecs = blk_rq_nr_phys_segments(rq);
> > +	imu = kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
> > +	if (!imu) {
> > +		kfree(node);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	imu->ubuf = 0;
> > +	imu->len = blk_rq_bytes(rq);
> > +	imu->acct_pages = 0;
> > +	imu->nr_bvecs = nr_bvecs;
> > +	refcount_set(&imu->refs, 1);
> > +	node->buf = imu;
> 
> request buffer direction needs to be stored in `imu`, for READ,
> the buffer is write-only, and for WRITE, the buffer is read-only,
> which isn't different with user mapped buffer.
> 
> Meantime in read_fixed/write_fixed side or buffer lookup abstraction
> helper, the buffer direction needs to be validated.

I suppose we could add that check, but the primary use case doesn't even
use those operations. They're using uring_cmd with the FIXED flag, and
io_uring can't readily validate the data direction from that interface.

