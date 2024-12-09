Return-Path: <io-uring+bounces-5315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E3709E9496
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 13:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 482D31636D5
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 12:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2308822371C;
	Mon,  9 Dec 2024 12:44:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CD9184545;
	Mon,  9 Dec 2024 12:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733748274; cv=none; b=O7xLr80KX/QXJhC11wSyhjzUWOzrzr8tw3UlHRNwyCIy84hGhPVKq078BVxv+S5JSopa57sjghKKJtOv5PD2wKzAHnmoImkkR3L+ROxB6FexK4EfJieMNqbbjHIh/GqnM/KCmWVIJyucXlInB9tYmfK98RQ1xL8P9vvBTQTZ4BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733748274; c=relaxed/simple;
	bh=/LfXVqgbf3ucFNgzXBGj/R4r0+6y9xamFU2lQ/HfMWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tqyBHMsFMDCVyY011SQbFJHcvs6qSPcNbT+3vA19s7fU0q9ov1589ojoIBn80yjrHnY5S4UEroglrU8EV+8xFODBzc2PQqyM4TiS/tzn/GIT8EhdhRJfbGpSF1UljRSTVqbof4aDXzlm5EabfPT1zMPnYUi+r+7+oR4Ubw9sy1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB39C68D09; Mon,  9 Dec 2024 13:44:25 +0100 (CET)
Date: Mon, 9 Dec 2024 13:44:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: kernel test robot <lkp@intel.com>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
	joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv12 11/12] nvme: register fdp parameters with the block
 layer
Message-ID: <20241209124425.GA14066@lst.de>
References: <20241206221801.790690-12-kbusch@meta.com> <202412071144.9uXFLnls-lkp@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202412071144.9uXFLnls-lkp@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 09, 2024 at 12:05:27PM +0800, kernel test robot wrote:
> >> drivers/nvme/host/core.c:2187:11: warning: variable 'i' is uninitialized when used here [-Wuninitialized]
>     2187 |         } while (i++ < fdp_idx);
>          |                  ^
>    drivers/nvme/host/core.c:2160:7: note: initialize the variable 'i' to silence this warning
>     2160 |         int i, n, ret;
>          |              ^
>          |               = 0
>    2 warnings generated.

Yeah, looks like this is uninitialized.  Did I mention I hate these
variable length log entries in nvme?  They've already been a major
pain in ANA before..


