Return-Path: <io-uring+bounces-4660-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA089C7C14
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 20:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7F6EB36D97
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 19:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2C6204001;
	Wed, 13 Nov 2024 19:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDymXMZh"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA3322611;
	Wed, 13 Nov 2024 19:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731524620; cv=none; b=TiC3IfTtKFubwniy4iX6f3CMMv+CD++6EYOqOmFcDhNc9rm37iH/R9CG+NgXMI6yWoR3ScBOw3awEHLUp7VXKODVR8Sc9sKS7S2wVBINmZ0Yd8NFXjvwz+WK4t6czVuWBgtKzF8xu7UTPWyNyddl76eRTwtr/IBrrmH6qsMRbFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731524620; c=relaxed/simple;
	bh=Ih6n3afma8hugiSd02MVTojr13PQh5SNuHn4AQX0Ya8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JiBdecjgPp++bTAKyHJRUfe6b2m03AaoNAvIH3SNudhuInYKI1C2/RaFa2udqOEHlvKequjyOa2xbFqRtnMTC7JObaZCslMaOzXP9JM/0ML8wz+dCOXEoHbGhHFh4RlcHMbD8vlPXDeo9t3zWJZ5VYiygTD/IPkMrncCBlErKOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDymXMZh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7ADC4CEC3;
	Wed, 13 Nov 2024 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731524619;
	bh=Ih6n3afma8hugiSd02MVTojr13PQh5SNuHn4AQX0Ya8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bDymXMZhLQ/Vq6S0sM45/V1tPovTNJlSfrT0cPHtmiD8HHMfGQ8PKT0jhI43uvbYl
	 AzuinSRrll9KcFaatx/X6OO26gB06Zp710v16Qy0Iusrb8jBXtibVzv1vD59ihx7e2
	 kpv3xJf+tKSeyjhxLS7zayx2ni9+WxH1bt8dd3uU7fouCUHxHVTRImH6o5hfRXzvi1
	 cmwjoQZMZHZ4/gUofMCHPpV7KlxmHem54qM1fYptYarl3+1eFKNXuE0BHa6K4xof35
	 hKElXIDUnh3N10qMNtYqewYAUEbEPtRzipapGy7V5iU2D3wpXYMbSvx1maqrtKlj5r
	 2nhpBBd+zl0VA==
Date: Wed, 13 Nov 2024 12:03:36 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/6] virtio_blk: reverse request order in virtio_queue_rqs
Message-ID: <ZzT4CHjrmD5mW2we@kbusch-mbp>
References: <20241113152050.157179-1-hch@lst.de>
 <20241113152050.157179-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113152050.157179-3-hch@lst.de>

On Wed, Nov 13, 2024 at 04:20:42PM +0100, Christoph Hellwig wrote:
> in rotational devices.  Fix this by rewriting nvme_queue_rqs so that it

You copied this commit message from the previous one for the nvme
driver. This message should say "virtio_queue_rqs".

