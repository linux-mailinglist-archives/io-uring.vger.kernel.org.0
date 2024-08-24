Return-Path: <io-uring+bounces-2936-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5813095DCF6
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 10:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64E651C21045
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 08:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7CF248CCC;
	Sat, 24 Aug 2024 08:34:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745A141C72;
	Sat, 24 Aug 2024 08:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724488444; cv=none; b=mMMCpeeniHwsuinKIFXKPEamCpgzL0XybDggzZPcT7zwHZjHJt43IbqMHWnI2xOWmwEjeV/fj5K7jvHzhdwmlndhYTAZKnxdtaXCuoGdhyc2nkqi1RCKx0idti8lVNaRHTGYMudtvvCPrbo3EAMorvQNaVt3UiGjrnbpDhNImGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724488444; c=relaxed/simple;
	bh=ceQQyUPY742SmsxoELgTMY/TBHS9xSf3qibZl6L9cRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3Gk85np2VhXL24LX+XcMTIcTEghTLCHTo86jiOzFty6haBQcvpGe6M1oz6+7ibBzT7o5ZwBishzp54SHS7cLGYQ7U/XQmIPPmk5rHgcePLBmdDPTmBtDsvgWIyOmV4//GNc5tPgXw5vVKkD9sXkHFovrwFXC+J6P+t0cSEJs+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2D201227A87; Sat, 24 Aug 2024 10:33:59 +0200 (CEST)
Date: Sat, 24 Aug 2024 10:33:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 06/10] io_uring/rw: add support to send meta along
 with read/write
Message-ID: <20240824083358.GE8805@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104627epcas5p2abcd2283f6fb3301e1a8e828e3c270ae@epcas5p2.samsung.com> <20240823103811.2421-7-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823103811.2421-7-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +#define IOCB_HAS_META		(1 << 22)

.. METADATA?

Also the fs infrastructure should probably be split from io_uring.

> +/*
> + * flags for integrity meta
> + */
> +#define INTEGRITY_CHK_GUARD	(1U << 0) /* enforce guard check */
> +#define INTEGRITY_CHK_APPTAG	(1U << 1) /* enforce app tag check */
> +#define INTEGRITY_CHK_REFTAG	(1U << 2) /* enforce ref tag check */

This gets used all over the block layer.  I don't think it should be
in an io_uring specific header even if that is the initial user.

We might also gain a bit more flexibility by splitting the userspace
API from the in-kernel flags even if there is no strong needs for that
yet.


