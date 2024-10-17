Return-Path: <io-uring+bounces-3765-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D45D89A1CC7
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 10:14:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11BD01C27271
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 08:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0209A1D0BAE;
	Thu, 17 Oct 2024 08:14:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36C41CF7C7;
	Thu, 17 Oct 2024 08:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729152856; cv=none; b=Lml8iXi45p+iQTBkwg7CLeGUVB7PGSiCydROOl67ZjlXwyN4MJqXLKKynRimhXX6MqH3t3xW1Sz5X57RA3oqGVaQV31yOCdAWZlpA0WgxSb+emHfXr16GwtUNjC3J0j9x0cRCoMWq9sVfV9lvXpq4JgDQUxdcDrhy+Le430ePKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729152856; c=relaxed/simple;
	bh=mcKVoh+gS4jTs1j/l4oE2tS25y2sVhESsFLmIua8Fz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dy4wZzirnWrPe/mmvtEJQXCuMyk3v/8RXfSKnKcBt8iwaWkPmByCNakpzgx7jwXz/HvCZIJRtGv2P1YuweV3QT5Ps8X/xEi/79ARfDIYDgK2r90S4kRHlh3tnBZL3gKtcsEGtLbWGVVmlFWYYjcYtaXZ4i1S2/9CDLH2A5p9nIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 660A4227A8E; Thu, 17 Oct 2024 10:14:08 +0200 (CEST)
Date: Thu, 17 Oct 2024 10:14:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 10/11] nvme: add support for passing on the
 application tag
Message-ID: <20241017081408.GC27241@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113755epcas5p2d563b183a9f4e19f5c02d73255282342@epcas5p2.samsung.com> <20241016112912.63542-11-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-11-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But I think this should be moved to before the user of this is added.


