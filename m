Return-Path: <io-uring+bounces-13300-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iG6SNZIyBGqNFQIAu9opvQ
	(envelope-from <io-uring+bounces-13300-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 10:13:06 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A1052F656
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 10:13:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 75591301A2CD
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2026 08:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE80A3D9DB4;
	Wed, 13 May 2026 08:12:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C853D4128;
	Wed, 13 May 2026 08:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778659976; cv=none; b=mFEm1fS5Ilcl7/xRoCQRpOXrF/1cNDNCBiI6OoCuvW4xaejNF6/RIMwm0Zm/QNx4sE7mxk+pcGuh4bxavCv9mE8DQZ7dbkihMSnyEMsW0YndJKzkxFWL1mISjpWx1wnqZYx/b0AFlU5Kgqso5FuASgxEEBNcceB3RGV5BCXUy6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778659976; c=relaxed/simple;
	bh=TpAYosl9slccEP2FBB7SSfbQm6lJiZx763AlF73vs64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAgQ2bVx+qLhqOrvy7tFEAKqvfw0cJZewnUYKqtCFiG9yjgdXKhoMMPH+0cb34y2nYNPWDU54W5G+E3mvquWzteE+xj38ngmAhdyMntzCCVbX6zDJoCGKPnJRtuu9M5MAjev7F4D+COLfUbPMgTGxF4L3EifsZ0vFcIFCAS5i8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C4F8068BEB; Wed, 13 May 2026 10:12:38 +0200 (CEST)
Date: Wed, 13 May 2026 10:12:38 +0200
From: Christoph Hellwig <hch@lst.de>
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
Subject: Re: [PATCH v3 03/10] block: move bvec init into __bio_clone
Message-ID: <20260513081238.GC5477@lst.de>
References: <cover.1777475843.git.asml.silence@gmail.com> <43a91f54d61d3329316e40c69ace781b4d35fe0b.1777475843.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43a91f54d61d3329316e40c69ace781b4d35fe0b.1777475843.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: D5A1052F656
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13300-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,lst.de:mid]
X-Rspamd-Action: no action

On Wed, Apr 29, 2026 at 04:25:49PM +0100, Pavel Begunkov wrote:
> To quote Cristoph: "Historically __bio_clone itself does not clone the

It's Christoph.

> payload, just the bio. But we got rid of the callers that want to clone
> a bio but not the payload long time ago". So let's move ->bi_io_vec
> assignment into __bio_clone(), so we have a single point where it's set.

but this he-said, she-said is totally irrelevant.

Please state here why this is useful/important, which matters for anyone
trying to understand the code in the future.


