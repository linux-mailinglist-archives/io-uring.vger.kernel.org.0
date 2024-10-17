Return-Path: <io-uring+bounces-3760-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0761A9A1C1B
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 09:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF26C1F238FF
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 07:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345361CEE90;
	Thu, 17 Oct 2024 07:57:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A61CBE9E;
	Thu, 17 Oct 2024 07:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729151857; cv=none; b=lYcA96SiiYnQ9+0bYk8vusW9SB3eiIecM5slIi1ku0T/fc1F6ihQ2inj8IF/ZBlVYGMAVTL1MPxU26ka/Ib0sQLe64oOOaHyWQRf2OIysljsNaH4Bpld5DJI7w9fY84cphZnKfxUzX+s9WnryOHizDi08zrMbAa6gaFjeWwxuqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729151857; c=relaxed/simple;
	bh=Q5BCWCw8yFqGhxKkksUSu435GeAtcNC8pgUrqLTSncM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BREopQ0/oU4/KNeVYsUmxIZt9NSfa7mS1jxCjlOOmd2tBMmDLRfEtkO+ZOnkaM04C4wSmG9mFVNgWrw02KzptsuRBeQSCYod8OySYdE+/XrXrDQi7JG//xccex4QnZFJHvkdkuQU23Zp+J5F/aGN1ZnJIQOeXaFqfp5IE7NtbGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2800D227A87; Thu, 17 Oct 2024 09:57:31 +0200 (CEST)
Date: Thu, 17 Oct 2024 09:57:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	anuj1072538@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v4 04/11] block: define meta io descriptor
Message-ID: <20241017075730.GB25343@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289@epcas5p3.samsung.com> <20241016112912.63542-5-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016112912.63542-5-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 16, 2024 at 04:59:05PM +0530, Anuj Gupta wrote:
> +/* flags for integrity meta */
> +typedef __u16 __bitwise meta_flags_t;
> +
> +struct uio_meta {
> +	meta_flags_t	flags;

Please either add the actual flags here, or if there is a good reason to
do that later add the meta_flags_t type and the member when adding
it.  Also maybe the type name wants a prefix, maybe uio?

Also from looking at the reset of the series uio_meta is in no way
block specific and referenced from io_uring.  So this probably should
go into uio.h?

