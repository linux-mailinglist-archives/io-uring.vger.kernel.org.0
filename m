Return-Path: <io-uring+bounces-5339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 143EE9E9B39
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:07:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BD8F1884462
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 16:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10DB684D29;
	Mon,  9 Dec 2024 16:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6gHRaGT"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA20233139;
	Mon,  9 Dec 2024 16:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733760459; cv=none; b=n6WlsA0IjQwwMfaOR86J2w0AysERCCc4l/p6x/FNDvaUdbQtc/LHJu0mVDuuVkUS67cAmc6XhYn6G+GE80wetfO3vyHNwA+VMzabR0erQ5IeTMN6xNIwb6DDG40FcFtETg1ZP6W9NDy1/ABmjRxqnmPTx2It+QBw+FDubq19ODM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733760459; c=relaxed/simple;
	bh=OnU+8GBt5pKp2SZ7nwC0/d71cQLLpJdR1aRrsY3v1GQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LjfKsVI8ztkMXGvcmUXq3p1DIykxhTVAt/2HYKJ6GeKQ8WxDNYPipiC5HTOK7DvsYcONWs6bABDRdysSyuDo7ceskSXPwwkF8dtX9G0Rg5fFT4C45ze0eNsssxGqyNWFB0ZaJbMqB/JRH/OjcHbAjptA7wzsc4BM9FgN18+lcZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6gHRaGT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DDEC4CEDE;
	Mon,  9 Dec 2024 16:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733760458;
	bh=OnU+8GBt5pKp2SZ7nwC0/d71cQLLpJdR1aRrsY3v1GQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K6gHRaGTrCmeg3ha+s2ZhK6C2A8Z8dvwEMmkvjx/LHbPlbhWuo7FQtV1RoJR8Ttdv
	 3hWMOOdVMDoe5cBnpC/S0ZqtVTZrlV5+AnDyO9Tn/WCBQ0EOGyos5ENuZ5K0rk6gJ2
	 6HzSnE5hSyLhZVCiHqBuJ+aExCMULICr8WtwDwkGsg77EtIY5RzwrOa1+5GUo7L0zp
	 2MEht1epHewFktReXkDKyPKO/3lQNcZV/t0B4ZjhiJcpL8Jmbri0Gke6P8g78A6Th5
	 kqM2BQ7mqI0B5OX6yKKFrcW2z6wEsACS/rQqml8GsYg2X8tS2gB9EROPKUnjaAbv6n
	 E9YvQSCAwngMg==
Date: Mon, 9 Dec 2024 09:07:35 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
	joshi.k@samsung.com
Subject: Re: [PATCHv12 00/12] block write streams with nvme fdp
Message-ID: <Z1cVx-EmaTgdFgVN@kbusch-mbp.dhcp.thefacebook.com>
References: <20241206221801.790690-1-kbusch@meta.com>
 <20241209125511.GB14316@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209125511.GB14316@lst.de>

On Mon, Dec 09, 2024 at 01:55:11PM +0100, Christoph Hellwig wrote:
> I just compared this to a crude rebase of what I last sent out, and
> AFAICS the differences are:
> 
>  1) basically all new io_uring handling due to the integrity stuff that
>    went in
>  2) fixes for the NVMe FDP log page parsing
>  3) drop the support for the remapping of per-partition streams

Yep, pretty much. I will revisit the partition mapping. I just haven't
heard any use cases for divvying the streams up this way, so it's not
clear to me what the interface needs to provide.

> One thing that came I was pondering for a new version is if statx
> really is the right vehicle for this as it is a very common fast-path
> information.  If we had a separate streaminfo ioctl or fcntl it might
> be easier to leave a bit spare space for extensibility.  I can try to
> prototype that or we can leave it as-is because everyone is tired of
> the series.

Oh sure. I can live without the statx parts from this series if you
prefer we take additional time to consider other approaches. We have the
sysfs block attributes reporting the same information, and that is okay
for now.

