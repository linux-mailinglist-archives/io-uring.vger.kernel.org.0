Return-Path: <io-uring+bounces-2973-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A34963938
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 06:06:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F5A5B20D5E
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 04:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743BB38FB9;
	Thu, 29 Aug 2024 04:06:42 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5451870;
	Thu, 29 Aug 2024 04:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724904402; cv=none; b=RUznWDKdmdMnYAzCdEURTvexeoP7WbhuSQxiguyv2T/tRjYxJmkPL+B19/lN2c7HINxW2Usy3mOjAibrI4s5c/LqBuUHZnSUDQ/+FYrMYIBuh9jCd3lJm4+FA6jFg1gAa6SRPRN1pBfF99liukyEROBMWXKglEi0AS2DbmeIYFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724904402; c=relaxed/simple;
	bh=Nf2gbwERMDJqs8rnCKIOIi2IKem0YYz9oFEMU5wDj2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmgZaiqwZjt5uIsMzhj689ft4z88/l6hPPjkpt5gpCHtYYmwpmCquaxHqIaTiZIK7iKgP6aWWkf8pWTuRYmYkkK4OI/9QxQEwbPyEVUW3K8u/AvDWFRdjAppIf6DUhEllMwhNo2gO8pfTf+u/SINsL/ULOIOO9Vepuj2s9hHprs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1047768AA6; Thu, 29 Aug 2024 06:06:38 +0200 (CEST)
Date: Thu, 29 Aug 2024 06:06:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kanchan Joshi <joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk,
	kbusch@kernel.org, asml.silence@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 07/10] block: introduce
 BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags
Message-ID: <20240829040637.GC4211@lst.de>
References: <20240823103811.2421-1-anuj20.g@samsung.com> <CGME20240823104629epcas5p3fea0cb7e66b0446ddacf7648c08c3ba8@epcas5p3.samsung.com> <20240823103811.2421-8-anuj20.g@samsung.com> <20240824083553.GF8805@lst.de> <fe85a641-c974-3fa7-43f1-eacbb7834210@samsung.com> <yq1plpsauu5.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1plpsauu5.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 28, 2024 at 11:16:53PM -0400, Martin K. Petersen wrote:
> I thought we had tentatively agreed to let the block layer integrity
> flags only describe what the controller should do? And then let sd.c
> decide what to do about RDPROTECT/WRPROTECT (since host-to-target is a
> different protection envelope anyway). That is kind of how it works
> already.

Yes, that should easier to manage.


