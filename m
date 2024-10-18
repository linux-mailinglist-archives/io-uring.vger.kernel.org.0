Return-Path: <io-uring+bounces-3811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD849A3955
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 11:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 191221C249D9
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 09:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F7018E76D;
	Fri, 18 Oct 2024 09:03:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3045185B5D;
	Fri, 18 Oct 2024 09:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729242193; cv=none; b=Ak4vJPV2iiT+vrsF3PSrsdzUgp+w1YE4YOFvKhHsIRHhldtnGQymtjVCZGlpwTOcHUXm/bDRBUgFfsqgoq1whwJDZi4JwRU4sRT3EolRuqzTh9XLN01jTxxALimm4dW//cLJd6gQSd1nCxmLswejn2wcxxrpMYtjtPRwYiWR8hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729242193; c=relaxed/simple;
	bh=VKQdHcOpELpCo5uOMOfX377mh2KRhHKVI3Lge1ZUF+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SpucI76fU8pkkhoBgzEqKh1MZAcV23UztW8NxW44WQRMacktYPZ726krAXL/H4/Ph/P6v2dc3If56zhY87/PN176FCdmIOx/vTi006TjWbsobt3RDLt7UHOJIeogc0024Viv1QRSc3/3N5oCemiBB5cmh5I5MNYMkmoJzF1CHx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6CE38227AB1; Fri, 18 Oct 2024 11:02:59 +0200 (CEST)
Date: Fri, 18 Oct 2024 11:02:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com
Subject: Re: [PATCH v4 11/11] scsi: add support for user-meta interface
Message-ID: <20241018090259.GA30253@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113757epcas5p42b95123c857e5d92d9cdec55e190ce4e@epcas5p4.samsung.com> <20241016112912.63542-12-anuj20.g@samsung.com> <20241017113923.GC1885@green245> <20241017143918.GC21905@lst.de> <20241018082648.GA32006@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018082648.GA32006@green245>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 18, 2024 at 01:56:48PM +0530, Anuj Gupta wrote:
> > Just curious, do you have any user of the more fine grained checking
> > in NVMe?  If not we could support the SCSI semantics only and emulate
> > them using the fine grained NVMe semantics and have no portability
> > problems.
>  
> We can choose to support scsi semantics only and expose only the valid
> scsi combinations to userspace i.e.
> 
> 1. no check
> 2. guard check only
> 3. ref + app check only
> 4. guard + ref + app check
> 
> Something like this [*] on top of this series, untested though. Does
> this align with what you have in mind?

That is indeed what I had in mind.  But I'd really like to hear from
Martin on this as well.


