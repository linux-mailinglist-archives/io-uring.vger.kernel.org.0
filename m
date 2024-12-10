Return-Path: <io-uring+bounces-5409-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D6819EB4B3
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 16:23:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35E3B166991
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 15:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254851B87FA;
	Tue, 10 Dec 2024 15:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VEAnlEGo"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD6E1AC428;
	Tue, 10 Dec 2024 15:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733844206; cv=none; b=R5fLnIfq78LjXtRyKHiK/EIU5rXa5f1/vzlNeFQQWCWYr76wxOwhn+JlLX+eQG6Ckp15FpRwt9eYqon+rS3gU3bP7WqFz9hnndrDi3HvfSeQMIedOHJU44w8bPqYXxD/XkoeUhBeqh6ZsAFGGWzXwEHHNNHapd91EYoHMMTe954=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733844206; c=relaxed/simple;
	bh=kFDZ4fWXe1UmPyq/gUpaBBV7FEi+rMVfAazaCxJB3PE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cuFKj7PUadIWza79vIs4nvSWCGYOaY0k4AwBTc6CtZmiVURLlqg9UGMrkS3r45wZR+abbMMky7KPkKK7DASt5IUz43VjS0O2PbF3fKd2GWgcefUxmwJ4gYzAFM5FHfBVpcm/OfQo3r00dA2Ef3JHeQ3Ikff6l46y89aKZ3bDev0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VEAnlEGo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47969C4CED6;
	Tue, 10 Dec 2024 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733844205;
	bh=kFDZ4fWXe1UmPyq/gUpaBBV7FEi+rMVfAazaCxJB3PE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VEAnlEGo5GmYtpBwE/exjIHzNAkVwXL4KcgeYoGd2JG2HF/u6aSWiz+YULBIhmKjD
	 U4fQlv2swb/HIbucsgBYdyid6KAD9kUH9eUKNWdv3FFRbfy5YK45s/u1E7xwBKurcl
	 YRXWOU3wNoTS6FkD6rexkAGNZxW0J4qrq2ct1ZZe3N23N6vmjUtqkHqiuye+P3GeyO
	 825jDV+O8icw4WPw+CNBl2nDa75JbXljzBv3FCQAedcSi1JFcgCkIpyWlfYYtvXsJU
	 s4dYbSSkcbUT6cOGa8do60E5xxiWYReYQ+MA0NJV+wY62rWs/OmloocTZz62stjFhj
	 EeW5MEUSL1u0Q==
Date: Tue, 10 Dec 2024 08:23:22 -0700
From: Keith Busch <kbusch@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Keith Busch <kbusch@meta.com>,
	axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, lkp@intel.com,
	oe-kbuild-all@lists.linux.dev, sagi@grimberg.me,
	asml.silence@gmail.com, anuj20.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCHv12 11/12] nvme: register fdp parameters with the block
 layer
Message-ID: <Z1hc6l0bCq2VL-LM@kbusch-mbp.dhcp.thefacebook.com>
References: <20241206221801.790690-12-kbusch@meta.com>
 <8d69680a-a958-4e9d-a1ba-097489fe98d1@stanley.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d69680a-a958-4e9d-a1ba-097489fe98d1@stanley.mountain>

On Tue, Dec 10, 2024 at 11:45:43AM +0300, Dan Carpenter wrote:
> 04ca0849938146 Keith Busch   2024-12-06  2226  	ret = nvme_submit_sync_cmd(ns->queue, &c, ruhs, size);
> 04ca0849938146 Keith Busch   2024-12-06  2227  	if (ret)
> 04ca0849938146 Keith Busch   2024-12-06  2228  		goto free;
> 04ca0849938146 Keith Busch   2024-12-06  2229  
> 04ca0849938146 Keith Busch   2024-12-06  2230  	head->nr_plids = le16_to_cpu(ruhs->nruhsd);
> 04ca0849938146 Keith Busch   2024-12-06  2231  	if (!head->nr_plids)
> 04ca0849938146 Keith Busch   2024-12-06 @2232  		goto free;
> 
> ret = -EINVAL?

It's very much on purpose to return "0" here. Returning a negative error
has the driver fail the namespace disk creation. Seeing a stream
configuration the driver doesn't support just means you don't get to use
the block layer's write stream features. You should still be able to use
your namespace the same as before the driver started checking these
configs, otherwise it's a regression since such namespaces are usable
today.

