Return-Path: <io-uring+bounces-1654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A0FE8B44AE
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 09:02:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89007284356
	for <lists+io-uring@lfdr.de>; Sat, 27 Apr 2024 07:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C8D41A89;
	Sat, 27 Apr 2024 07:02:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8FC381C7;
	Sat, 27 Apr 2024 07:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714201347; cv=none; b=YAlmt1GXEYp664d3aOnrBpY6QZsf1I/P4YVM+mYJHqS7G1692UKt2Oz7TcPRaaKb2kM5+XI0I9v7iKlBxHoJbuv9nXd79NgHZtnBm/2zdeqFSRxD1x8H66NyS7pxA9yTzpfCWCoPgt4CFG7XMYyZ6b/JyCNj9ce1KwxKcfBQdxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714201347; c=relaxed/simple;
	bh=yXd3lrDuHfNexNCLKog2Cj54JzOldHcoWHE80WgEnOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qA5rV49xcwLEMsPpKwuZgTYgLHast8dNG1RMZO2McR6CJLOTdzFynCy40aUVEt8qeu8Q/Gx4yGROXiM2cmWhl4DVQMydxXFpE4yUrPVw3TOAGmBu0GmiPUGlPMD89n+LM6FiiQSFxy7bJKcI3zONAkz8NRv5Tfkp/aSdEFgsmYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 63E76227AA8; Sat, 27 Apr 2024 09:02:14 +0200 (CEST)
Date: Sat, 27 Apr 2024 09:02:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	hch@lst.de, brauner@kernel.org, asml.silence@gmail.com,
	dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 01/10] block: set bip_vcnt correctly
Message-ID: <20240427070214.GA3873@lst.de>
References: <20240425183943.6319-1-joshi.k@samsung.com> <CGME20240425184651epcas5p3404f2390d6cf05148eb96e1af093e7bc@epcas5p3.samsung.com> <20240425183943.6319-2-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425183943.6319-2-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 26, 2024 at 12:09:34AM +0530, Kanchan Joshi wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Set the bip_vcnt correctly in bio_integrity_init_user and
> bio_integrity_copy_user. If the bio gets split at a later point,
> this value is required to set the right bip_vcnt in the cloned bio.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Please add a Fixes tag and submit it separately from the features.

I'm actually kinda surprised the direct user mapping of integrity data
survived so far without this.


