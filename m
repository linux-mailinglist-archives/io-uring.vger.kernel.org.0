Return-Path: <io-uring+bounces-13231-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sNOtBRe8+Gnh0AIAu9opvQ
	(envelope-from <io-uring+bounces-13231-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 17:32:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0655F4C0B86
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 17:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1481A300A59B
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 15:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517573E0C4F;
	Mon,  4 May 2026 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KRCydiHt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE873D348B
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 15:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777908618; cv=none; b=g9UdtadnaznRBuES3dIDrhA0lWt5iw/4G9LB8u68w+6MVmTdPHWVA7lf/IkJj9a6ZtSPC28ZMJ9stsPmwWU9qvzBgJ5NcDNP7bWf6+iWHyt2jgAZ1NOfegOfCAHo6gxavYrfZBWuNl1edWhvhPMSs4yhsSu5jkVGJxtkWeQLcnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777908618; c=relaxed/simple;
	bh=6QwUQCcZs6tvnhRhV82Gt4iwhALrIcfYYBRUBpS70Xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIzDNS8i0st9VYPG1ms14axap7vf396XaW8M7SXqkh6Nx1JiPFVTSkt5sekTU4E/m0VNQN/UR4/1mTtY4c5Og7yl90Oc3IyBZyWHrvP1GAp05STqZzXmRLn7g1RaVGVbL2ztsun7/F21yS/9ZYwH3qNSLqGnTUPIqPB3BZqF8oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KRCydiHt; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso33782005e9.3
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 08:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777908615; x=1778513415; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JTReAJBRtrEN050pOinCvG1qLugpFlFxRiDBF5vEgm4=;
        b=KRCydiHtndzdGf5TkyPWPK008OR44tmdTzRSw2JTkci3b8zxWdo6LUsffiYnvHOIHZ
         byvbAFU+RxD4lCtq0X+S2IM4H0QbB6OZMCBxc7pin9y6EX+SuPXA5gMhhWyeXfpWAAV2
         Ks2/rvJXblg6QPna/4dBmIaDduBtVsMUv7M+b8K74EgNRC5F6jdMSS0X6eDO4NIB2O8E
         FByWC3qNVSk5GNL8bwbGWbQyiohl2FuRsikc2DbQXJqAFZMniHDWsJjhrCZRbrQpJSz+
         eFYbBUm/AxpKp0NDVg0mO4O7XcgZ22nVwUnW81OZx2sRwS1e6QUjjoB+WkcRsrYrQtxs
         dBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777908615; x=1778513415;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JTReAJBRtrEN050pOinCvG1qLugpFlFxRiDBF5vEgm4=;
        b=iHjEr4xQ54YCeFrKxX/aJ37gEB6aK0h7ZXQo195KMyUyQ21LukaDtHW4si6f8qjmzB
         YmZodAE0TWOIyBEeQk2ibPvawXOOhwyg/qkCDkYScAVL7WuY1UMol+d+jWMEAZsl5QpJ
         Oy2G1YRfmcYvbd+HL/7GCZor4vveGgPa7Qtb/pENw9qXQRcn3VWXjo+dKSqLUpAS/KIu
         sNiAhdXn3DxlpQybby1tJBl9LhDrMgQ6JfxLgbwDhlvmm3US3/yGZJX9Qe493uOW6Lhr
         /OwXRfu6DmwQryl0peUwyzMNWn3f1Z8G/7ctwSaA8PvAozBApboKKY9PMouB9k+2Yahi
         aXvQ==
X-Forwarded-Encrypted: i=1; AFNElJ8b7D2R/5DK5esCz3YZmAmY24IxiCo62VAbpyGjj171ssd8L4aS87oD4QQnUecHOIiBktUvoSKukw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsA1pkwQE7Mtsf1eL6Vw2bCwmxVtgk6lUCogA5Oyfmq9lR6Env
	A8mSTEmZSGCwq/iNY7rZ6TluE2prOX2xG7glRN6CVt3Q/wX0GeMeucwF
X-Gm-Gg: AeBDieu+29u7JpFlEtoKMPHdncfcTg1zDg4rxNQMxy49fMJgEvwm4n/OkuzIU5xkqIw
	HYauAmoU1eIl1gIe/q13/lBLMyUPPqCOpIXj0LPpG3YUytwl6lc66Y6UdJf3MC7g1EGIeMn2O62
	3abtjjrNmZg074XoyT4rSHrvc3DivOgFBnvLijijvE1mOm2fX0LUIFkg4jt9vd+G4K3zXp0L29T
	CeLpHHDJgtYXg5147sSJojln+lAyQtRDvwlHyq+JvDUOrVqW1XM5NpNH5kwy9SQ8i3Jd/itxuCm
	uhg7vXrp/7mN2uvlktgL77gyr+Cg+nci3qnXs6vWlkGSL+bgZLjpeXebssZLetHDBgQjN9s/qTD
	ZOGLwJOAq9D1o6Zch15/mWKIcbY/VyC0LL/ZPaFQEBQBlB68bxJ7sJyVPF9P+p/YwOiyEmmDZsZ
	3sc0sv8XZOMpbP/d/c2b5WxJlY0KXxHd4WgHQrZbcae6L1PxpZ7DMqCE7IZbMWGjnuDEembH+4r
	yl8FjiNHa8SqHum5N9VPZdn
X-Received: by 2002:a05:600c:4f91:b0:489:1ba8:5be9 with SMTP id 5b1f17b1804b1-48a98676b26mr157938505e9.29.1777908614504;
        Mon, 04 May 2026 08:30:14 -0700 (PDT)
Received: from fedora (185-147-212-251.par.as62651.net. [185.147.212.251])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a8ea7cfd2sm25250825f8f.2.2026.05.04.08.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 08:30:13 -0700 (PDT)
Date: Mon, 4 May 2026 23:29:55 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v3 00/10] Add dmabuf read/write via io_uring
Message-ID: <afi7c-VUJWOLlC1m@fedora>
References: <cover.1777475843.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1777475843.git.asml.silence@gmail.com>
X-Rspamd-Queue-Id: 0655F4C0B86
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13231-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tomleiming@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On Wed, Apr 29, 2026 at 04:25:46PM +0100, Pavel Begunkov wrote:
> The patch set allows to register a dmabuf to an io_uring instance for
> a specified file and use it with io_uring read / write requests. The
> infrastructure is not tied to io_uring and there could be more users
> in the future. A similar idea was attempted some years ago by Keith [1],
> from where I borrowed a good number of changes, and later was brough up
> by Tushar and Vishal from Intel.
> 
> It's an opt-in feature for files, and they need to implement a new
> file operation to use it. Only NVMe block devices are supported in this
> series. The user API is built on top of io_uring's "registered buffers",
> where a dmabuf is registered in a special way, but after it can be used
> as any other "registered buffer" with IORING_OP_{READ,WRITE}_FIXED
> requests. It's created via a new file operation and the resulted map is
> then passed through the I/O stack in a new iterator type. There is some
> additional infrastructure to bind it all, which also counts requests
> using a dmabuf map and managing lifetimes, which is used to implement
> map invalidation.
> 
> It was tested for GPU <-> NVMe transfers. Also, as it maintains a
> long-term dma mapping, it helps with the IOMMU cost. The numbers
> below are for udmabuf reads previously run by Anuj for different
> IOMMU modes:

Plain registered buffer is long-live too, which raises question: does this
framework need to take it into account from beginning?

BTW, inspired by this approach, I adds similar feature to ublk via UBLK_IO_F_SHMEM_ZC
which can maintain long-term vfio dma mapping over registered user-place aligned buffer.



Thanks, 
Ming

