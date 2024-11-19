Return-Path: <io-uring+bounces-4839-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 452F29D2E55
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 19:49:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20E34B313CA
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 18:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED0DC1D1F63;
	Tue, 19 Nov 2024 18:24:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BAC1D1F56;
	Tue, 19 Nov 2024 18:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732040674; cv=none; b=c3FFu1KETK0rJGcPOB46alzULHG+m3BWrcpX+8yWhHkBDzpOVCACGV1I9Eku+jBqNMzRTBG0xLA09ToemL1DB9eMoD3RtLk7aEJ6n96KvOReTRipRV8bS9YwhbWaq5UD53kGccR6QN4KmarTAZ7Dqh3txHrXgJ5ISWQYfyFyJAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732040674; c=relaxed/simple;
	bh=HAmZhrf/ImLigxRe22woWwNaCskR7GALOeADMe+y8TM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwFkFPUmT/0dnyFndwtY1ohGwJvFNt35oYzh8E/gAJoaFOp3X9WjYYF5jhoB6ivqTV8mQlYAXy0pcwNc3NM3qGEqj/j+wwPJgV4OXC0OsDKdVT5wqdsMY5/xNFiqEuJYhpVSrSk+DGTZodE+Iipfnyxywlz1ujFtBKbmdzwpG/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8E0F268D8D; Tue, 19 Nov 2024 19:24:27 +0100 (CET)
Date: Tue, 19 Nov 2024 19:24:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>, Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>, Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH 14/15] nvme: enable FDP support
Message-ID: <20241119182427.GA20997@lst.de>
References: <20241119121632.1225556-1-hch@lst.de> <20241119121632.1225556-15-hch@lst.de> <ZzzWQFyq0Sv7cuHb@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzzWQFyq0Sv7cuHb@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 19, 2024 at 11:17:36AM -0700, Keith Busch wrote:
> > +	if (le32_to_cpu(configs[result.fdpcidx].nrg) > 1) {
> > +		dev_warn(ns->ctrl->device, "FDP NRG > 1 not supported\n");
> 
> Why not support multiple reclaim groups?

Can you come up with a sane API for that?  And can you find devices in
the wild that actually support it?

> > +	ns->head->runs = le64_to_cpu(configs[result.fdpcidx].runs);
> 
> The config descriptors are variable length, so you can't just index into
> it. You have to read each index individually to get the next index's offset.
> Something like:

Indeed.  The current code only works when the first config is selected.


