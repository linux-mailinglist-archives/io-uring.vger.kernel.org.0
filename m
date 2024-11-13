Return-Path: <io-uring+bounces-4662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D1D79C7BFA
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 20:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 015B8281639
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 19:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188BC2038B1;
	Wed, 13 Nov 2024 19:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dm3k+LWb"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1B616DEB4;
	Wed, 13 Nov 2024 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731525053; cv=none; b=Cikebar4lS4KR/AszMNS2y2Jz5yQyJfeT5PrhvHQGv29P53M7H0KW5MPwYpkKYAO3UshqKr+Z2lHqPVQbp1wpmOgFkndqPwGfhlAA0pbmcc73rSPEb6HyCW8cr7GEaob/T7UGYBosq6mmG2WjfKpnAPha3kB56lXxjPhY1TBkis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731525053; c=relaxed/simple;
	bh=U5mxNLV0SHjT1ykqhZxsaYkGqsbIpfIhRjrw4HyI1bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HT5CyfZscPGoFOMIYhDVLdmxcukkh2TYmaUOqWC5SfRHXa4cZFxT0Iurj9V7ogksrNEhqht99Jr5eKtWNE3vTWPGXTkANDE6eVnOP3hx4lvsltJRnkQctVSU3Goqrdz2Ae72BqoY80yHwvbOKVZ/B/LK0/1etAMi7Yx6SI7Yv0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dm3k+LWb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F2FC4CEC3;
	Wed, 13 Nov 2024 19:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731525052;
	bh=U5mxNLV0SHjT1ykqhZxsaYkGqsbIpfIhRjrw4HyI1bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dm3k+LWb6/toGQUBpgxcAWnL08tMjamqR6pJHHBdZ2rID2pk5Y0MioCeVgFmE7exh
	 58XdkdK8EGaRukiKYDMTMQLAZmlTtQ7eTBVDfGOrHGdyRIVlU6re1RqwKnNuGygyd1
	 bafzpoSc/DhBylGYW7Na5DTu3dVU+LnWxo64E3I0XMV1ktrsJuAJ5+YBz1Y8pdX9tj
	 SvmRd8bG3aY3ysDnnSgPsm1SNGmwI+bahCEOC2vQssujk5AkMLVV3ZLol9zhWXS8Ey
	 o2QvnjJOYt1tJSFldgQn0dhsuTbG1lpEam9ygjGBk5V7obNiy7lP0WXMwNVwgurTrg
	 eVWCMW8CCmSdA==
Date: Wed, 13 Nov 2024 12:10:49 -0700
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/6] nvme-pci: reverse request order in nvme_queue_rqs
Message-ID: <ZzT5ubYLImyhNrCp@kbusch-mbp>
References: <20241113152050.157179-1-hch@lst.de>
 <20241113152050.157179-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113152050.157179-2-hch@lst.de>

On Wed, Nov 13, 2024 at 04:20:41PM +0100, Christoph Hellwig wrote:
> blk_mq_flush_plug_list submits requests in the reverse order that they
> were submitted, which leads to a rather suboptimal I/O pattern especially
> in rotational devices.  Fix this by rewriting nvme_queue_rqs so that it
> always pops the requests from the passed in request list, and then adds
> them to the head of a local submit list.  This actually simplifies the
> code a bit as it removes the complicated list splicing, at the cost of
> extra updates of the rq_next pointer.  As that should be cache hot
> anyway it should be an easy price to pay.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

