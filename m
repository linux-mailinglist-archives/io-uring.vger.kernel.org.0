Return-Path: <io-uring+bounces-254-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC282807A23
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 22:09:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 788501F218D1
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 21:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE396E5AE;
	Wed,  6 Dec 2023 21:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gi4Lqhby"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEC343172
	for <io-uring@vger.kernel.org>; Wed,  6 Dec 2023 21:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F45C433C9;
	Wed,  6 Dec 2023 21:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701896950;
	bh=JuJgyMldVXzQChTKlWDXxmWauy6oPTyPDFAKlAkaknE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gi4LqhbyIWvY2yR0AzEIKyQjn3gXERvoRS5MMOHiszRHBwLlagGu4F2vjPH4bzTwh
	 7HFtxRxLN+ATqglH+lSvtH7FF6vF5l7qRoT+M1ozYM0z4o7ll3u364i/UpM9HRc3sq
	 XGs4MiMDVG+QEN6JTuq1Rd3591nTJ8j/y9da2fCpl33qm7YxBuTY/E81sOpnp1D1MI
	 MChBxxZmBMJPLkhF8SAF1oes4YBkpvC3OoSzCXhxhmx9hTsRc27JCAjrbbcfO44R9j
	 /z2XbS1N6HddRc64oJIL9RR3MaqYySMCtq0qVpVdCFGrP27Tq8n59EDkCFuMG2jq1b
	 KqZkiZWx9dg9g==
Date: Wed, 6 Dec 2023 14:09:07 -0700
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	hch@lst.de, sagi@grimberg.me, asml.silence@gmail.com
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Message-ID: <ZXDi89EjHYYGK8JO@kbusch-mbp>
References: <20231204175342.3418422-1-kbusch@meta.com>
 <CGME20231204180804epcas5p30002c71ae22125ae84549258d1cf6fe5@epcas5p3.samsung.com>
 <a387fd6a-7d4c-49e0-bb89-be129b10781c@kernel.dk>
 <4cc1ba06-ecfd-b351-962e-27042767657e@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cc1ba06-ecfd-b351-962e-27042767657e@samsung.com>

On Tue, Dec 05, 2023 at 09:51:13PM +0530, Kanchan Joshi wrote:
> Does it sound any better if this 'super ring' type of ability is asked 
> explicitly by a setup flag say IORING_SETUP_CAPABLE_ONCE.

Just my opinion: that option sounds good!

