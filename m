Return-Path: <io-uring+bounces-4152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE1F9B5537
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 22:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F2D6B219CB
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 21:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86BE3208991;
	Tue, 29 Oct 2024 21:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Djatruc7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544AF1E1A2D;
	Tue, 29 Oct 2024 21:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730238050; cv=none; b=Zyl0vXrwROM3kMn1meAzxsVEmDfnyj0wQfbaolKnd1MswsasEZ6cdGwimmL8dH+jj+l2kvEFruWaw1HyYPg/GRkfELvoPt3J2+gUdfboGb9Izleowd1RmTIDnTOFmJJh+4ME5Oz2mNS/ZpXW9aRAaghiNZU3G1dmdapzSe4o3u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730238050; c=relaxed/simple;
	bh=hHya4CFWWb9IorKtvtVVxz2dO0bXEsa0J6T54piHyvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLQQ5CPkwSC5WHCxzdq6GBquuVrZtNFnupLKT4GCAphWn8cgfMY+Q0ZL3zvGvIOWOzIrWZlnnqyskKl0xrg27nVM68qkGaMy3776JTFqtdDh+DqhaDVIATC2vnXSHmuSfiHXhVSOpNEapWmoJclwsixMgDxTGgZZ4FBZkkZPon4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Djatruc7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AB3C4CECD;
	Tue, 29 Oct 2024 21:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730238049;
	bh=hHya4CFWWb9IorKtvtVVxz2dO0bXEsa0J6T54piHyvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Djatruc70fMox7Zoi6qtwtgU4iCwwXMXuw9Bf62dCNMei5GIcjJD9t2Y/ahwZpZbF
	 b+ClRYRx5PnFK7468VU4FlgzDob3tEca2+cGL06VurZHzZTuSWuqsUty7qtt0Qye4R
	 J2mLZ2GL9nUF5S00tlDONog/BGvM4BZfq+IxJ/3vJqk7UG0gpxfPXtOUgmYJtQ9kcs
	 DEanJCXZS6x2DWxNjbqMa6/5S0YlnTvs+4pQchAT/8QVwoAT5B9gZnB1Q7o3DF3RH8
	 jaErNIzyq5SzHSEicPlImnwvvKwuSwQ4epnLsKcnFLwG1aQf7RkiLvhtN+V6sfbTLN
	 rZKOxayvBqYXg==
Date: Tue, 29 Oct 2024 15:40:46 -0600
From: Keith Busch <kbusch@kernel.org>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	vishak.g@samsung.com, linux-fsdevel@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v5 08/10] nvme: add support for passing on the
 application tag
Message-ID: <ZyFWXqinEAjuJtfe@kbusch-mbp.dhcp.thefacebook.com>
References: <20241029162402.21400-1-anuj20.g@samsung.com>
 <CGME20241029163230epcas5p18172a7e54687e454e4ecb65840810c4e@epcas5p1.samsung.com>
 <20241029162402.21400-9-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029162402.21400-9-anuj20.g@samsung.com>

On Tue, Oct 29, 2024 at 09:54:00PM +0530, Anuj Gupta wrote:
> From: Kanchan Joshi <joshi.k@samsung.com>
> 
> With user integrity buffer, there is a way to specify the app_tag.
> Set the corresponding protocol specific flags and send the app_tag down.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

