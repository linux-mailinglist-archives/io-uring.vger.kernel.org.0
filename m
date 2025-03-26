Return-Path: <io-uring+bounces-7245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6352DA70FA2
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 04:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC9B63AD384
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 03:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E7917578;
	Wed, 26 Mar 2025 03:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nbZmNViN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D03310E4;
	Wed, 26 Mar 2025 03:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742960866; cv=none; b=PONRSmXqBX6PIn5VY3EcJ+VLK5AfhQDAAfLqlnHTNaETeNrdyolVqlRsGuGUCbNB872U90QhOvhbJhFPoSh1Z+lbEvSUy52qxoa4D7ILQO2064bBv5kug54Hqm/6NzN8+CTDYO4meo0BW+Wh/Lex5TmPGWLbQHwLrZ2ftYM0teE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742960866; c=relaxed/simple;
	bh=bYXS2SsX/Qi2gSv2wWb1FHs98/UR/lhfVEIgUK70Scw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Miezrr+5VJhMW2neW/C4KdN2UBEkO/Bayp5NgwJKy/S4xt3ncO+kqOb/3F0nEKF9n78zSNZZaC25bA3MkkpK214FjvqpBAWuyhgvxap0DANDnSAFGicauY0APzsA0KHcq9gCn2xV1QNVad1JmBK/AcDH4YJNAGOpQRxV2y+Rz7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nbZmNViN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433C9C4CEE2;
	Wed, 26 Mar 2025 03:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742960866;
	bh=bYXS2SsX/Qi2gSv2wWb1FHs98/UR/lhfVEIgUK70Scw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nbZmNViNSaeDldYLoMtg6puSuGB8XRZJuZOaotC6DrFrEcGt8+NgPrqr7L57ALNIh
	 siTD5bPIdv3l/wPCfUQ//c/DW4Xl3lnAU793oMQV0TpPfeT8TM//QBmuJCVRUWA246
	 KxjFrrOydPctMiqAJyKUtMC+U4BzyQAGqqZFVsaIRG7I9+eE905tR1O0a+d3oWJAGh
	 306sAM2cm94t+6+x5S8yCHrvZALSWQ1sCpCBOHAwolLsY8RzZolfWWMdYWBR+cxYuU
	 Q0AD9+cT0nGqZNzV+4au+QGwXE19tkcQS5s6O+ZkDx2I9iCdBH81TMiwuB3kp/XCD6
	 d7nk7XuoWRMRQ==
Date: Tue, 25 Mar 2025 23:47:43 -0400
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Xinyu Zhang <xizhang@purestorage.com>,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] nvme_map_user_request() cleanup
Message-ID: <Z-N439fyHEyweXq0@kbusch-mbp>
References: <20250324200540.910962-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250324200540.910962-1-csander@purestorage.com>

On Mon, Mar 24, 2025 at 02:05:37PM -0600, Caleb Sander Mateos wrote:
> The first commit removes a WARN_ON_ONCE() checking userspace values.
> The last 2 move code out of nvme_map_user_request() that belongs better
> in its callers, and move the fixed buffer import before going async.
> As discussed in [1], this allows an NVMe passthru operation submitted at
> the same time as a ublk zero-copy buffer unregister operation to succeed
> even if the initial issue goes async. This can improve performance of
> userspace applications submitting the operations together like this with
> a slow fallback path on failure. This is an alternate approach to [2],
> which moved the fixed buffer import to the io_uring layer.
> 
> There will likely be conflicts with the parameter cleanup series Keith
> posted last month in [3].
> 
> The series is based on block/for-6.15/io_uring, with commit 00817f0f1c45
> ("nvme-ioctl: fix leaked requests on mapping error") cherry-picked.

Thanks, I've queued these up internally for 6.15; the next nvme pull
request will need to rebase once the upstream branches sync with the
existing outstanding pulls, so this series will be included in the next
one for this merge window after that happens.

