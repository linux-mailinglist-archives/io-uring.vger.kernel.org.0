Return-Path: <io-uring+bounces-2364-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18448919F34
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 08:23:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51A2F285A39
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 06:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B866D208D7;
	Thu, 27 Jun 2024 06:23:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F384F29CA;
	Thu, 27 Jun 2024 06:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719469410; cv=none; b=mbfTggKJC5HaTmLQoo2rr42M1pTDit+4QF+XZCMt/ibU/fwkcjD0mRMQeQVkB9K1s3TgezUVcUf6uYXZicIFSzNSWDUaHLuk4G3ks65U6hSoUNHrwcqoHQeuJgVJrRrL1G61KvIP3FrDfi3RN34Wl1Ho3i6SJ/HOu5/fiCJb5R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719469410; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oLSugn6cyUOeWK/6v5QiZiI3wUBps3sBnXVdwYVhRvP6G7BAZYXBfc2SujIHrCvtRMd70k6NfFPQR5/KXMe5AyLuTthXijhNzdQSj65aj/GspZi2A0NCHqkj91hstbNa/CEAaiPCluVklBXL7p8qCpST7HMUGoKrqEHRJgcbvC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F2A4968AFE; Thu, 27 Jun 2024 08:23:25 +0200 (CEST)
Date: Thu, 27 Jun 2024 08:23:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 06/10] block: modify bio_integrity_map_user to
 accept iov_iter as argument
Message-ID: <20240627062325.GE16047@lst.de>
References: <20240626100700.3629-1-anuj20.g@samsung.com> <CGME20240626101521epcas5p42b0c1c0e123996b199e058bae9a69123@epcas5p4.samsung.com> <20240626100700.3629-7-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240626100700.3629-7-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


