Return-Path: <io-uring+bounces-2932-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4606295DCE5
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 10:24:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 718C31C210FC
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 08:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE7D5186A;
	Sat, 24 Aug 2024 08:24:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA5E155730;
	Sat, 24 Aug 2024 08:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724487876; cv=none; b=hDBUsNzNHml3u/aiBxLdhd4ViYeiIHJpimNsVqVMFQ2EQ5cIpQaFk+Tz2O7CDjHPpfHDsypKee7+BMHPzowgKRaXWpwIKT+Sag1iTN/tRbCeNdTNekjzi1GYzQbOTWCYBPKgWJUOD7BvcNm6GXnx8v+6ln54xzZGtlOfAjGw8m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724487876; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=urYlNyJVgNstMRCPvAu4Ri9em6f8JwmaO79/DLo3BR1iLq6Sz1ncwmp0spqyNb58ZnLfaD1DYfygFa+Mf8bY+RLCemvQPkHGOMUkoX4xWWOESEoPIQ+3E9WjBPmwGe8d6arXgBJonJNzJ97pvc7x5eyrdLKdcUT7+KXA44I7BTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1C257227A87; Sat, 24 Aug 2024 10:24:30 +0200 (CEST)
Date: Sat, 24 Aug 2024 10:24:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 01/10] block: define set of integrity flags to be
 inherited by cloned bip
Message-ID: <20240824082430.GA8805@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104616epcas5p4bd315bd116ea7e32b1abf7e174af64a1@epcas5p4.samsung.com> <20240823103811.2421-2-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823103811.2421-2-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

