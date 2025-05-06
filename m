Return-Path: <io-uring+bounces-7872-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52376AACAE1
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 18:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C05C9163F7A
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 16:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09888283FDC;
	Tue,  6 May 2025 16:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iort1L32"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDCB4B1E6E;
	Tue,  6 May 2025 16:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746548797; cv=none; b=ltdaG40jtHUg8ig7iZ6snemfskcsSz/A4lkwujc63g/8217p9LaUvTm9lLAWNtWCIfzfiywEf+n1/i+ilJPVyxjXRAD4JALFv/SxZSAyWo4q6NzTXgBMbclMPxcdJq9Sxwm/XvAqyAWQqq48QXCsZ9Wl2s1BKMI781SD4o7muj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746548797; c=relaxed/simple;
	bh=ZjL7t4BsSulzlwJzRDQ/LXLV59ln6cU8XfSSUAZxHBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4UzRHasZHQvSrmOYvsg4YJtB1n//c7TRDZOImDWhtZaSaPm34d7fQu/4tF3laJXPTpirglbwSqZFHAZciESymATHZlPxFqQaCMYhhnlFdmV0M+gS9ZeigF6AhbuWxOFlxz/p77dGD4fMvrb9fFs8sQT9YBNgEn0rtl6Yv7Hky8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iort1L32; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811B1C4CEE4;
	Tue,  6 May 2025 16:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746548797;
	bh=ZjL7t4BsSulzlwJzRDQ/LXLV59ln6cU8XfSSUAZxHBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iort1L32mdtiprBQnnykO9ASrBPh/VLReTrk2dBR5A+C1npSh8Fqb76YUQPy01ecz
	 PRzD3S3HnCpZNEzIrfZp2XU3u31kDSSsGljaVvFaKoCvPolcpmZU3ig8KCJSNUthi0
	 Iwvn+1+oyiDP2eaF/NFcZVNEpmByjWFWPKtHlF9VWRPEX1AXrzFBI9C3vBl87mpBGo
	 azAeFB5TpAm3puJhQ+KP0Ivdq9hfQCfWROOCIn5wwo7kItLKxYcxAGUi+2RLhWlmAZ
	 EcKAPIO4XDBLu8kKpS7pIPCcWpq8sv1s6HbTEd6JpovwHfJQD/d7QU7qBucZD5Y6oM
	 qGuw4iLmEi7eQ==
Date: Tue, 6 May 2025 10:26:34 -0600
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH v16 10/11] nvme: register fdp parameters with the block
 layer
Message-ID: <aBo4OiOOY3tCh_02@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20250506122651epcas5p4100fd5435ce6e6686318265b414c1176@epcas5p4.samsung.com>
 <20250506121732.8211-1-joshi.k@samsung.com>
 <20250506121732.8211-11-joshi.k@samsung.com>
 <CADUfDZqqqQVHqMpVaMWre1=GZfu42_SOQ5W9m0vhSZYyp1BBUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZqqqQVHqMpVaMWre1=GZfu42_SOQ5W9m0vhSZYyp1BBUA@mail.gmail.com>

On Tue, May 06, 2025 at 09:13:33AM -0700, Caleb Sander Mateos wrote:
> On Tue, May 6, 2025 at 5:31 AM Kanchan Joshi <joshi.k@samsung.com> wrote:
> > @@ -2225,6 +2361,12 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
> >         if (!nvme_init_integrity(ns->head, &lim, info))
> >                 capacity = 0;
> >
> > +       lim.max_write_streams = ns->head->nr_plids;
> > +       if (lim.max_write_streams)
> > +               lim.write_stream_granularity = max(info->runs, U32_MAX);
> 
> What is the purpose of this max(..., U32_MAX)? Should it be min() instead?

You're right, should have been min. Because "runs" is a u64 and the
queue_limit is a u32, so U32_MAX is the upper limit, but it's not
supposed to exceed "runs". 

