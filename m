Return-Path: <io-uring+bounces-6248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B546AA26BAB
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 07:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72C6618875C2
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 06:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B72813AA38;
	Tue,  4 Feb 2025 06:01:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF7325A655;
	Tue,  4 Feb 2025 06:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738648876; cv=none; b=rUvtjF8lFisQs9blrzgiXWyZyjydufpNdSkDYNl2kxwr7QKSZ6RkHNiGroQDnKaogNYyNi+UyRGS8bRkwcOEs2yybN9V1Ip3DusmKpeaEI8jVdz59cpFfBYCf1ygBF8h7NsB6MQC5nIQ2Bj5XhnI8uzIs5FcMFD9wkT4CbbSbCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738648876; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bPs+Wt+SYAntbfZEtBUUWcLiptdmaolq73+34a4j9jNfj//V37wEsRnP4kHZpZma+8Fj4XmMW5XNbis27stoNnlxHvXn3PYRRP/mTLlkJ5ENvMNu/lSV2w4c6Ht4Nupzff9gB20tCKW3NY+eUb/lFECadN9nHbM4m0xxzB3frRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9ADEE68AFE; Tue,  4 Feb 2025 07:01:10 +0100 (CET)
Date: Tue, 4 Feb 2025 07:01:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	asml.silence@gmail.com, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCHv2 10/11] nvme: register fdp parameters with the block
 layer
Message-ID: <20250204060110.GB29177@lst.de>
References: <20250203184129.1829324-1-kbusch@meta.com> <20250203184129.1829324-11-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203184129.1829324-11-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


