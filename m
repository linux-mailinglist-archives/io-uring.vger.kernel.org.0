Return-Path: <io-uring+bounces-3371-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF0698CE10
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 09:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82BFC284A7C
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 07:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A1F19414E;
	Wed,  2 Oct 2024 07:49:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B1219415D;
	Wed,  2 Oct 2024 07:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727855377; cv=none; b=J8x+mD0Fm9U0qR37I62lDZx0cdQWb4oc6qOL8CL9Zrvlvdbyg+5BVWwC+0HNZVbAc2xAHLpmXA8rgPrdms+B1JP1qD+VbCFYg1nDcZdgaG0ZabLM05elf6bMbor9K8nY458ihL73+/NNQZm1wM/SuzZjZ19s0OiT7ct94BzKEmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727855377; c=relaxed/simple;
	bh=vPWbc2Ri7KiG6whnBfdboUqN6Pzm86Buv0Kee2g97gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6YxgEpWVd/w6dKFVKtUr93+Q2wx1g7lAQXgxgW5LBcO6VP4AhVfU16eOaOELMz8E+04Om66dh5J98lj1QPdVtobRG4hMnXRW7j2OF/JCEG9q4uJJeIj/mgXvhProINNQ19qUEtoRFm61XpFHRZNm5+f2ngHfi0SRrZ1UTXvXLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A8387227A8E; Wed,  2 Oct 2024 09:49:26 +0200 (CEST)
Date: Wed, 2 Oct 2024 09:49:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	axboe@kernel.dk, hare@suse.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241002074926.GA20819@lst.de>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com> <20240930181305.17286-1-joshi.k@samsung.com> <20241001092047.GA23730@lst.de> <ZvwiD0v3ASF8Hap2@kbusch-mbp.mynextlight.net>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvwiD0v3ASF8Hap2@kbusch-mbp.mynextlight.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 01, 2024 at 10:23:43AM -0600, Keith Busch wrote:
> I think because he's getting conflicting feedback. The arguments against
> it being that it's not a good match, however it's the same match created
> for streams, and no one complained then, and it's an existing user ABI.

People complained, and the streams code got removed pretty quickly
because it did not work as expected.  I don't think that counts as
a big success.


