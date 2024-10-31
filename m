Return-Path: <io-uring+bounces-4257-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 604B39B74C5
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 07:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 246862825FA
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 06:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD801482F5;
	Thu, 31 Oct 2024 06:55:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7921487ED;
	Thu, 31 Oct 2024 06:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730357744; cv=none; b=FhCd+lvK8bS1hZ5GH9l5MlrYyibURBJE/N0KzOdRNBD/VugAXBi5EmpFpP/U8FGq0GiCzFAW0qbT3qYtgje7uGC1NWnOK2OIjEGroXHusrqIuZi2THi5gHTeIuZNCPyHU8HsSRrjv362oPu8VuPDMnIvl2UDoBM8w/e21ZZeSW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730357744; c=relaxed/simple;
	bh=QLDIAaSD9844H1amX6uRVboWINL3zB7PYQjgIeituFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KxwsUlM9qFhR+o0sOL88hrsCwzaCHVlKXTrfcGe1sWyzV6tYSVtRpimqIoUSDrYO8Dzjs1E5jqusGcChpIYxbTXOZei0/shEHgFFtrrxBL9/Vlcce8/e8G1Owg4tFFG6SIb2sbPYqA5BzWaHSKMp28I4mFDW4Irdg1NzDfr5bBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CB0C7227AAD; Thu, 31 Oct 2024 07:55:35 +0100 (CET)
Date: Thu, 31 Oct 2024 07:55:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com,
	vishak.g@samsung.com, anuj1072538@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v6 04/10] fs, iov_iter: define meta io descriptor
Message-ID: <20241031065535.GA26299@lst.de>
References: <20241030180112.4635-1-joshi.k@samsung.com> <CGME20241030181008epcas5p333603fdbf3afb60947d3fc51138d11bf@epcas5p3.samsung.com> <20241030180112.4635-5-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030180112.4635-5-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 30, 2024 at 11:31:06PM +0530, Kanchan Joshi wrote:
> +typedef __u16 uio_meta_flags_t;

I would have just skipped the typedef, but I don't have strong feelings
here.

Reviewed-by: Christoph Hellwig <hch@lst.de>

