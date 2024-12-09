Return-Path: <io-uring+bounces-5340-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 055749E9BAA
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:29:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80F6D1886CA0
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6E61474C9;
	Mon,  9 Dec 2024 16:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkqQkaht"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D78A146D57;
	Mon,  9 Dec 2024 16:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733761786; cv=none; b=mMKXKJAW10MX/6mXNAs7Yzds43b8annZ75k8gy/l6FrOrxaFKaGBSEZeJXaQkYcBwJQTtYZlACgA4UpXSv1V2utV12GwNieH6Uqtriva788AfG+Jp6Ox4keeoylL7ZvlGbe1KzW27p+/5E4CgWS7MKe5GJE7wd39BdS2KVWOua0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733761786; c=relaxed/simple;
	bh=s0ZJKQcRZlj/F3HdodiOs2sWsKd6fLpep2dSp6CdnhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZF0cEbrIgRJ1fZ5mT+m7LRlCvE+PwNMe+xQXTRqhqnVC1feZlbAsqFyC+xePeT3cCfREIxaxOw5z9zroYBrnaaN/q2GQtUjFb+TCDAdnnCZ5vJPBMcDFJ2766LozIfqLTailjGumvQTPv6tYuDUdRjJjsfGXNuFuVvfw/bofAvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkqQkaht; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE57C4CEDE;
	Mon,  9 Dec 2024 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733761785;
	bh=s0ZJKQcRZlj/F3HdodiOs2sWsKd6fLpep2dSp6CdnhI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hkqQkahtR+OmH6AYMvoDAEUl+Sxxv/9Yi2/J37SmxMHZTnEjV+gen2QtnJpgwY06J
	 VwhQ9zg5T5nGmX68lVpnmrlUF+Tq9VrWvkWT+7kNO2LTuxvkHU/628o5v5qsonc0no
	 aJUKkk6jt6xIOzV24qEu+xM0yo5lQmiCYKw22dTe8sdb96Nl1lXL4kblijQJY47zom
	 1+x/MDCib3CjopldXPfgFMkWCiWZr+fvyZNlBImKU95dVhJcpw6mY2KiTRAeO8M0ra
	 1fDQgEyCSnvX+MoBH0mm7n+hmHRXs1jHxJiHx7Daagpb+TWAp2tjnU01wMHYOBF8hq
	 vI/Iy7x6ZpgcA==
Date: Mon, 9 Dec 2024 09:29:42 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
	joshi.k@samsung.com
Subject: Re: [PATCHv12 11/12] nvme: register fdp parameters with the block
 layer
Message-ID: <Z1ca9liGKpasQ-vG@kbusch-mbp.dhcp.thefacebook.com>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241206221801.790690-12-kbusch@meta.com>
 <20241209131819.GA16038@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209131819.GA16038@lst.de>

On Mon, Dec 09, 2024 at 02:18:19PM +0100, Christoph Hellwig wrote:
> > +	n = le16_to_cpu(h->numfdpc) + 1;
> > +	if (fdp_idx > n)
> > +		goto out;
> > +
> > +	log = h + 1;
> > +	do {
> > +		desc = log;
> > +		log += le16_to_cpu(desc->dsze);
> > +	} while (i++ < fdp_idx);
> 
> Maybe a for loop makes it easier to avoid the uninitialized variable,
> e.g.
> 
> 	for (i = 0; i < fdp_index; i++) {
> 		..

Yeah, okay. I was just trying to cleverly have a single place where the
descriptor is set. A for-loop needs to set it both within and after the
loop.

> > +	if (ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
> > +		ret = nvme_query_fdp_info(ns, info);
> > +		if (ret)
> > +			dev_warn(ns->ctrl->device,
> > +				"FDP failure status:0x%x\n", ret);
> > +		if (ret < 0)
> > +			goto out;
> > +	}
> 
> Looking at the full series with the next patch applied I'm a bit
> confused about the handling when rescanning.  AFAIK the code now always
> goes into nvme_query_fdp_info when NVME_CTRL_ATTR_FDPS even if
> head->plids/head->nr_plids is already set, and that will then simply
> override them, even if they were already set.

I thought you could change the FDP configuration on a live namespace
with the Set Feature command, so needed to account for that. But the
spec really does restrict that feature to endurance groups without
namespaces, so I was mistaken and we can skip re-validiting FDP state
after the first scan.

