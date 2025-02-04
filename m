Return-Path: <io-uring+bounces-6249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFD86A26BAF
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 07:01:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8509E164C31
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 06:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95BBE1F9F5C;
	Tue,  4 Feb 2025 06:01:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B75625A655;
	Tue,  4 Feb 2025 06:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738648887; cv=none; b=MfiBFHIeYXqv+1tDjwJTq3np3icSUM5XADIXqaBen5cbjSi/+Fr+2EbKVLuDgUeN6fxjC+82FYlD/qeNZQI8kIADofzCPz/uG/dCAPBy1EKgoLJbK5+ujwV/OBRognSpScyd/HqV4f5sTfRgRX7pq1+/7ayQOfdGxUkb+pD6lWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738648887; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAsd85o4DxWCPWd+dEhXmoG+DE2AKmFtUkYMn/Uc61R011RwZrNAFpVI7rTxPeIKuIhs0IEhEiYtI+F4/W1Q8rlI9ZleG4yyCaCGIOnglsdryMDsVh+2DeT/p2CO5w96XWNvkR+lcYfaLya9BGRK//2uDJPz1OQDE/OJHcUREZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0369A68D07; Tue,  4 Feb 2025 07:01:21 +0100 (CET)
Date: Tue, 4 Feb 2025 07:01:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	asml.silence@gmail.com, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCHv2 11/11] nvme: use fdp streams if write stream is
 provided
Message-ID: <20250204060121.GC29177@lst.de>
References: <20250203184129.1829324-1-kbusch@meta.com> <20250203184129.1829324-12-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203184129.1829324-12-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


