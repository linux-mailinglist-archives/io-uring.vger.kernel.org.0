Return-Path: <io-uring+bounces-10230-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E385DC0C32A
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 08:53:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 834F34F1615
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 07:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0B52E4278;
	Mon, 27 Oct 2025 07:51:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D0B2E4241;
	Mon, 27 Oct 2025 07:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761551509; cv=none; b=LrQFjmJB2X94O0g01agl7Uy7g4SriW25Gf2iEXx7/Fuitdkte450KEsoKfDP4tOS9vG0spcIwuX3wFLH42rfKO20o2GgUSMLjtMxYD267awi7yB4DnL5jJoU1vBlgD/+S7c2qs4JuMIZA6gtfmCUeW1X80MbqAe7EpuFgEbVF1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761551509; c=relaxed/simple;
	bh=f3iwptgJ39Cvn/1R/92zDLiiyDlPBo6yDS5IVREqL2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHvMWMqFFT/Wfp32mHhtxIZhl+se8OunbViA2tZTC7XZfgjFtPalP85qCumC8knVxzoZY4fj+OD1qs55TGPWx1C52imqQBw5EbMkoF8e930sjcz6TtxrdD2/I+jMUIGHKueVeDlFcup3hsLd709RKn8uHFmlMPxi7OH4AJeMCqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ACB27227A87; Mon, 27 Oct 2025 08:51:42 +0100 (CET)
Date: Mon, 27 Oct 2025 08:51:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <miklos@szeredi.hu>,
	Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] io_uring/uring_cmd: avoid double indirect call
 in task work dispatch
Message-ID: <20251027075142.GA14661@lst.de>
References: <20251027020302.822544-1-csander@purestorage.com> <20251027020302.822544-5-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027020302.822544-5-csander@purestorage.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +static void blk_cmd_complete(struct io_tw_req tw_req, io_tw_token_t tw)
>  {
> +	unsigned int issue_flags = IO_URING_CMD_TASK_WORK_ISSUE_FLAGS;

In most of these ioctl handlers issue_flags only has a single user,
so you might as well pass it directly.

In fact asm most external callers of io_uring_cmd_done pass that, would
a helper that just harcodes it make sense and then maybe switch the
special cases to use __io_uring_cmd_done directly?


