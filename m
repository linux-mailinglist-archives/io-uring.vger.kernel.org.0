Return-Path: <io-uring+bounces-6247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98ED2A26BA8
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 07:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DAA218873A3
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 06:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC28F13AA38;
	Tue,  4 Feb 2025 06:00:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B90825A655;
	Tue,  4 Feb 2025 06:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738648839; cv=none; b=rnDBVbzT20VWxp4bGE60xwc2A0S0/eyNzjs0Yz+sFv5pYiHMlMnFe85pavEhRM1n//5z4DuQG1ftwRnbBQIxyXnaWBU7J9vFZCyRulgkBntRNW9mbkAOxmO+imF08IpEEghyDUbeAyYm8BZ052fSsvJutDz6sjm0/S94yus54cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738648839; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBUONwPgyY2uOcFpunv4nPTTk2Rg+IZ20zCuIVRR1PpKxsQhnBdiEL7tZuMGIsw+JiFLFRwuocp7LIsDN+KT8oqmhQ2CO28u8VpYrBG/pRfbzAzqzCrm9dGcWjJBYSsnzTSW/92gw2YnkbKyZEylDkmDU1PUuIA2jT5akUXlfvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 03DF668AFE; Tue,  4 Feb 2025 07:00:31 +0100 (CET)
Date: Tue, 4 Feb 2025 07:00:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	asml.silence@gmail.com, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCHv2 06/11] io_uring: enable per-io write streams
Message-ID: <20250204060031.GA29177@lst.de>
References: <20250203184129.1829324-1-kbusch@meta.com> <20250203184129.1829324-7-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203184129.1829324-7-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


