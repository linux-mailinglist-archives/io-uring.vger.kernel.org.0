Return-Path: <io-uring+bounces-3779-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F9C9A252A
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:35:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0333D1C231F1
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 14:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA0A1DE4D7;
	Thu, 17 Oct 2024 14:35:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7791DE881;
	Thu, 17 Oct 2024 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729175705; cv=none; b=PUb+HgNjO9PIMpSDK8c4HOG9s8cHSGA9zPOKOFQjtdm98PqiuhzHoLPViauXyJUdBVirdv+RNY/2hNFZW4nrJGHFGetKAbdQdZcfBZO5hANFp6r+1N1uCfrRmvAeL0IV+09obFRkp4GqKXVzqhO6lBz7xazCdDdkCLKkk0Nx50k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729175705; c=relaxed/simple;
	bh=9zaYnG8LBfw3AFTBnKZAJnThYnyZyHG9WIVT4s9S7mA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItU2pm89xMrEmUNzCDAO1efDEddzDDOLxEy12NzqlGVx1Cj+C+FHoBxVvTNFnAdnrtfTs3BEQZf78QZhUvDDjz35n7c4Wlq7JbeFEVf9xHTbRtrsIJ3aiK9XQKgaFczvFZ8YIENUQvh+MUAfUPZYc51f9ldszm03fsTfcL1O0IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 041FC227A8E; Thu, 17 Oct 2024 16:34:58 +0200 (CEST)
Date: Thu, 17 Oct 2024 16:34:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
	axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com
Subject: Re: [PATCH v4 06/11] block: add flags for integrity meta
Message-ID: <20241017143457.GA21905@lst.de>
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113745epcas5p1723d91b979fd0e597495fef377ad0f62@epcas5p1.samsung.com> <20241016112912.63542-7-anuj20.g@samsung.com> <20241017080015.GD25343@lst.de> <20241017104502.GA1885@green245> <20241017120102.GA10883@lst.de> <CACzX3AtdmWgEggmQsfqHU-GjdbQHTq9DwCzW07VG9zaoXaWfgA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACzX3AtdmWgEggmQsfqHU-GjdbQHTq9DwCzW07VG9zaoXaWfgA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 17, 2024 at 06:29:32PM +0530, Anuj gupta wrote:
> The last iteration of this series added these flags as io-uring flags [1].
> Based on feedback received [2], I moved it here in this version.
> Should I move them back to io-uring?

Maybe I misread the patch back then, but IIRC at that point the flag
was also used on the bio and not just in the uapi?

As of this series it is used in the uapi, and in the block layer.

Based on that uapi/linux/fs.h might be the best place.

