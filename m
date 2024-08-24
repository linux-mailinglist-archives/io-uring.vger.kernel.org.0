Return-Path: <io-uring+bounces-2937-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A461C95DCFC
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 10:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1CAD1C20AB3
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 08:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBCD1509B6;
	Sat, 24 Aug 2024 08:36:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D245680;
	Sat, 24 Aug 2024 08:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724488560; cv=none; b=HMTnRj+8LthmykxSfeyDBBYLK+FjuRTkyUBIdr1h8V0jinhqThttAcaG4xq0fWx5gS7kxoAy4tUYrfDA6pHYqWXPdf+d9HhyTU8HuYDFSSA+OdFoOjc79plIWV7r2RUwlmzRyF7SDWbJpa1ydne6Eo0QxhaGXMK7zzT0OcLKX2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724488560; c=relaxed/simple;
	bh=9T3MSHdSV/lwDH1GoEHu/O+lH/qMKvZgfb0xWzXHLow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bBHS2K5MbBUc0tvvpgZFjOOTuuqKmGtMmcQRWt+idmKz/F5dvliXcN8bcpCI/JQw4zWgwzJE9P96kCRAdIxJQFf6+0GvVo8OqcCEv+o46wv7ck9sW4b6tMVYnY5n3MtFhl7hq4GJmKDzsFiMNnGsO0HOlQp8f0ZkC5ZriI65a70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 24352227A87; Sat, 24 Aug 2024 10:35:54 +0200 (CEST)
Date: Sat, 24 Aug 2024 10:35:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 07/10] block: introduce
 BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
Message-ID: <20240824083553.GF8805@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104629epcas5p3fea0cb7e66b0446ddacf7648c08c3ba8@epcas5p3.samsung.com> <20240823103811.2421-8-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823103811.2421-8-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

This patch came in twice, once with a "block" and once with a
"block,nvme" prefix.  One should be fine, and I think just block is
the right one.

How do we communicate what flags can be combined to the upper layer
and userspace given the SCSI limitations here?

> --- a/include/linux/bio-integrity.h
> +++ b/include/linux/bio-integrity.h
> @@ -11,6 +11,9 @@ enum bip_flags {
>  	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
>  	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
>  	BIP_COPY_USER		= 1 << 5, /* Kernel bounce buffer in use */
> +	BIP_CHECK_GUARD		= 1 << 6,
> +	BIP_CHECK_REFTAG	= 1 << 7,
> +	BIP_CHECK_APPTAG	= 1 << 8,

Maybe describe the flags here like the other ones?


