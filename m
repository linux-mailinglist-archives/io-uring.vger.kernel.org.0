Return-Path: <io-uring+bounces-4475-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2303A9BDE4D
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 06:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB323284F5F
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 05:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F4918A922;
	Wed,  6 Nov 2024 05:33:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91CD189902;
	Wed,  6 Nov 2024 05:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730871190; cv=none; b=WPdu6OulgnKKWr8PMtJ88HdY2oxhCw3ATw7IxuwEBhHj9WD70pyUaJ4OHJUTW3C8/WE8hXD/zYwmb22S/mLJSUHZm5oVEV1ty7yqUy47/649u3OyL7e+Uu0p8yuRUGze/EnORAT0NoGC9oqiZIvui5HjbDq/rXIEMEfWUN3BBv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730871190; c=relaxed/simple;
	bh=w0jh5uHA+frUCXbRp+ZJoNeapmaWVUF+dvhfNaOuYAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgcteQVdXxDBW4LSL/CIWtI2h39HxaP/rMTC/YTNdD3qIWCPm8yn4Rt2Aig3jen3OaFssoEZ1LLRdAxikA1BS/eb010y3QZ7SG+GTzUZ6vNysdbQro6pnviOXcFf5C6nxTM8RLdBGiBQBfzv3Qojd1MBOJ9BON/7OxHb1uCRMdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 45C3868AFE; Wed,  6 Nov 2024 06:33:04 +0100 (CET)
Date: Wed, 6 Nov 2024 06:33:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj gupta <anuj1072538@gmail.com>,
	Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk,
	kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 06/10] io_uring/rw: add support to send metadata
 along with read/write
Message-ID: <20241106053303.GB31192@lst.de>
References: <20241104140601.12239-1-anuj20.g@samsung.com> <CGME20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c@epcas5p2.samsung.com> <20241104140601.12239-7-anuj20.g@samsung.com> <20241105095621.GB597@lst.de> <CACzX3AuNFoE-EC_xpDPZkoiUk1uc0LXMNw-mLnhrKAG4dnJzQw@mail.gmail.com> <20241105135657.GA4775@lst.de> <b52ecf88-1786-4b6f-b8f3-86cccaa51917@samsung.com> <20241105160051.GA7599@lst.de> <51b67939-cbd8-4213-967a-9c6b2ecd5813@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51b67939-cbd8-4213-967a-9c6b2ecd5813@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 05, 2024 at 10:08:46PM +0530, Kanchan Joshi wrote:
> We both mean the same. Currently read/write don't [need to] use big SQE 
> as all the information is there in the first SQE.
> Down the line there may be users fighting for space in SQE. The flag 
> (meta_type) may help a bit when that happens.

IFF we ever have a fight we need to split command or add an even bigger
SQE.`

> What I rather meant in this statement was - one can setup a ring with 
> SQE128 today and send IORING_OP_READ/IORING_OP_WRITE. That goes fine 
> without any processing/error as SQE128 is skipped completely. So relying 
> only on SQE128 flag to detect the presence of PI is a bit fragile.

Maybe the right answer is to add

READ_LARGE/WRITE_LARGE (better names welcome) commands that are defined
to the entire 128-byte SQE, and then we have a bitmap of what extra
features are supported in it, with descriptive names for each feature.
Not trying to have one command for 64 vs 128 byte SQE might also be
useful to have a more straight forward layout in general (although I
haven't checked for that, just speaking from experience in other
protocols).

