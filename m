Return-Path: <io-uring+bounces-2972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75F0C963934
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 06:06:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF34D1C21391
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 04:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC2842A9D;
	Thu, 29 Aug 2024 04:06:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315C31870;
	Thu, 29 Aug 2024 04:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724904375; cv=none; b=jSF3nP5CMXvjtiBFjLgJOPX9L7ejUIsRtJrlHsF/4ekROc901W3OpqVQ4tB48XbI99/n1KgVrbP/xhmKJ2J/f9SucW39yYIcvj+Itu67TDpmPJPXgnIrGXOjhtXWSXa3gn0tRE+gsJ+to0pcewUz7kwmv2PdpYJTUGtx8N6nOQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724904375; c=relaxed/simple;
	bh=WvmkehQFC0HgTYlLJK3hfjBLDWKNM79cJfJ4FEkoAfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OB3alWb+Yle0v3QA79Ezd1nKOiwdnboWi+GqlkTfU44AoOiooN2eDR6UH4aS86vRNl2hzSzig7HxhNYzFKOo85midPIYgo6xMHPgYmhdG1KmE1PhZJProlFxVaYlukRDw1IL/XKbdTerpYIVzIGj8ha3CmKm9OtcWjBTs+o/2c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CE6B068AA6; Thu, 29 Aug 2024 06:06:09 +0200 (CEST)
Date: Thu, 29 Aug 2024 06:06:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 07/10] block: introduce
 BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
Message-ID: <20240829040609.GB4211@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104629epcas5p3fea0cb7e66b0446ddacf7648c08c3ba8@epcas5p3.samsung.com> <20240823103811.2421-8-anuj20.g@samsung.com> <20240824083553.GF8805@lst.de> <fe85a641-c974-3fa7-43f1-eacbb7834210@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe85a641-c974-3fa7-43f1-eacbb7834210@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 28, 2024 at 07:12:22PM +0530, Kanchan Joshi wrote:
> On 8/24/2024 2:05 PM, Christoph Hellwig wrote:
> > How do we communicate what flags can be combined to the upper layer
> > and userspace given the SCSI limitations here?
> 
> Will adding a new read-only sysfs attribute (under the group [*]) that 
> publishes all valid combinations be fine?
> 

That's not a good application interface.  Finding the sysfs file is
already a pain for direct users of the block device, and almost
impossible when going through a file system.


