Return-Path: <io-uring+bounces-11811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B340ED3AE56
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 16:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3947F30146D0
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 15:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0565B31985E;
	Mon, 19 Jan 2026 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="G0IRJwji"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7DC34FF59
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768835249; cv=none; b=fQAqxH2ue/SZ/qAHU7qSy1dv8VMrp5NzYLc4bhtT6eBJIuM68nhC5tG34XrXS6p8EkTdTkHVolKydVr4mEoWkLGczbdehixegm8vEtt8vNGOR23KR48pLsO6VoPKH90Vzc9pMTSCwIAGp1KLRCxTgyh9cZ62IvyOooCIcrKTCaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768835249; c=relaxed/simple;
	bh=JM7VN05whJCE8jBj3BeZK69T5QEE8FUa4uiPivIbJPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=p1BMIZjfXcgSQ+M6P5YFFiUjLx4aPVlp8jdljHuvzMQyJdt/TqLGyFG/6A8QkiOHo8FDZIpt4C6/YA2QDfrMbEHZayddSd5uJuoPT1UejZI4u3goh9wDDVZ2OdOkUyG1oMYPHEhSRtvCV4EPxxvVLigyfrSymgeOnNbD6+LUZdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=G0IRJwji; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260119150718epoutp01dfad077cd0d2635e779c5120b386f769~MKkc0HjjX2803828038epoutp01D
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 15:07:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260119150718epoutp01dfad077cd0d2635e779c5120b386f769~MKkc0HjjX2803828038epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768835238;
	bh=0jeav41QIUHWhSoDptzFRbTAmSL8MmZG7TIS0IJTjF0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=G0IRJwji7sPyc+jIq90I3dnYiNcvMoDQ/vCsQ2NEnjrh4hkgspGZV5ewKA7BQpC3P
	 PA24GLS2wsQO2AzrrI8zQI0dDTI5X3UQslpIzZh3IMvzPuZNzudDr6xPp74QgD2mw7
	 yVR9qPhIBn4JszRLcQuDZIbpgWAOkGEqj2BW+bDI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260119150718epcas5p1f2155df96dd92bf19d47d1e967a301df~MKkcM6_bH2049720497epcas5p1K;
	Mon, 19 Jan 2026 15:07:18 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dvv2F2Wh8z3hhT3; Mon, 19 Jan
	2026 15:07:17 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260119150716epcas5p3b1139cbdabe33c2e7d65832c32516fa1~MKka7CoCN2047920479epcas5p3-;
	Mon, 19 Jan 2026 15:07:16 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260119150714epsmtip231525018180c6659701036326a13e695~MKkY17Sj80973609736epsmtip2L;
	Mon, 19 Jan 2026 15:07:14 +0000 (GMT)
Message-ID: <ebb64c7a-e379-4c83-a7ce-89f9e9419257@samsung.com>
Date: Mon, 19 Jan 2026 20:37:13 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] nvme: optimize passthrough IOPOLL completion for
 local ring context
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260116074641.665422-1-ming.lei@redhat.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260119150716epcas5p3b1139cbdabe33c2e7d65832c32516fa1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116074819epcas5p37afab1cd05fdf9e0555a14b5fe89c2dd
References: <CGME20260116074819epcas5p37afab1cd05fdf9e0555a14b5fe89c2dd@epcas5p3.samsung.com>
	<20260116074641.665422-1-ming.lei@redhat.com>

On 1/16/2026 1:16 PM, Ming Lei wrote:
> Hello,
> 
> The 1st patch passes `struct io_comp_batch *` to rq_end_io_fn callback.
> 
> The 2nd patch completes IOPOLL uring_cmd inline in case of local ring
> context, and improves IOPS by ~10%.

For me this was ~5%, but I suppose this is sensitive to the 
setup/config. Changes looked good to me, so

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

