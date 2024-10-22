Return-Path: <io-uring+bounces-3891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC9109A9931
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 08:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DD43283466
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 06:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4324437C;
	Tue, 22 Oct 2024 06:04:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8E13232;
	Tue, 22 Oct 2024 06:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729577098; cv=none; b=nAj85Saw+w15PqdHuo4pzQIuhvPiVWgRu+SVXosvponLgEVIgCkWSDTUrffMGccLaTUehpKwPljqw1DeUJ1+MRHX2Y1nQIedossz1BVShY4NgdbBxxSYVs+4dGVqtWfZ6CIodEiJ8TpmZ6s7izQsyyXiQsiu2Pr3yP9Bv8HIs6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729577098; c=relaxed/simple;
	bh=/3caapW7JMxfZnIqE1mdJlYhb84GAJEK7xGHy0Y5RF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QcsStBEgqZwNblso37kJNm5KMiP/SjLi85qNVzCB33BkC8Mg9fVgDoFtmlE0PJnCrRlSJFdYFDXUxeU1FEntNdha+xwSDbjytlTJSvFTCsb8j7w7QB/62VkMse1zZtrEtlKil2pbfA+tcEW2yIvnOBAlneR38rpYl3XLN9iYnXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A37FB227AAC; Tue, 22 Oct 2024 08:04:51 +0200 (CEST)
Date: Tue, 22 Oct 2024 08:04:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
	kbusch@kernel.org, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 04/11] block: define meta io descriptor
Message-ID: <20241022060451.GB10327@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289@epcas5p3.samsung.com> <20241016112912.63542-5-anuj20.g@samsung.com> <yq1h694lwnm.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1h694lwnm.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 21, 2024 at 10:11:35PM -0400, Martin K. Petersen wrote:
> Glad to see the seed added. In NVMe it can be a 64-bit value so we
> should bump the size of that field in the user API.
> 
> Not sure what to do about the storage tag. For Linux that would probably
> be owned by the filesystem (as opposed to the application). But I guess
> one could envision a userland application acting as a storage target and
> in that case the tag would need to be passed to the kernel.

Right now the series only supports PI on the block device.  In that
case the userspace application can clearly make use of it.  If we
want to support PI on file systems (which I'd really like to do for
XFS) both ownership models might make sense depending on the file
system, although I think just giving it to the application is going
to be the only thing we'll see for a while.  Maybe we need a way
to query if the application can use the app tag? 


