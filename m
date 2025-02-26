Return-Path: <io-uring+bounces-6820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AEC5A46BDE
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 21:05:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DF4B188AB5B
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 20:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D002641F7;
	Wed, 26 Feb 2025 20:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/8mBCQ4"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79148262D12;
	Wed, 26 Feb 2025 20:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740600041; cv=none; b=nsa3CC+CzJEb73tHwihI4R2bcpwAQW3rHQoL8OJKdZ8AQ5RbPO7moear2r6jsboO8V63MAhIsxEr2bGaeqVdwULH3V/wthylYCE6HovPdmDmf+tmvV/ZKwpdqqjZqs4Pw0OjGw9cQb8TGBgBtm2BuikcQO3fO4IXOApyAdsptVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740600041; c=relaxed/simple;
	bh=s8TR3mzU4dAMr2KyS/iGUHeMjkOW+Z7uBLL2Cfc8pv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eVkfhbc4AT4szD4/2APkZEpbyEIp7f2Jgx/W9dUmWf5N/rB58qDwKnx+d2PrFBEh1vtsBExsZgl9x3LWtzTCiRzQmRBsER4mTsPyea6PY685+FPUIGCjc/Ju7ashLJNxLm8eGLrbGGdA7lJKsBA7khTlDNc6IO2lUfH4SbwyPDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/8mBCQ4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3280C4CED6;
	Wed, 26 Feb 2025 20:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740600041;
	bh=s8TR3mzU4dAMr2KyS/iGUHeMjkOW+Z7uBLL2Cfc8pv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H/8mBCQ41anFup23sLTi2aX6kI1lAvfNfisC4VpALVIUdEdyqz1s/RnGg2Gb0m8By
	 BhGak0lQ6yLccO52xvYlgpkvy6j34JYqx8v9jKBln0uUPLVtau0fVmGKH1+IyfueLZ
	 AAe3vmi3ajnzEMG/d4KcU3Ak7PISIxRRdA3j6TwLNiScj0GwrufM/EEsD8aPWdvAr9
	 hEz3nMXGnbf8se/MR/U3Gagjys9Hslf01IB5RmeRNZHK8/W/K+d9aSepbvAHjMFPgx
	 XQhROwkwuHJFESs5lROHb58sICPYDdvLVuzdMUuDvoK6GTHCmKgb95mmvK6tdbIM0q
	 IuD9DR2ZPeNhQ==
Date: Wed, 26 Feb 2025 13:00:38 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
	asml.silence@gmail.com, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, linux-nvme@lists.infradead.org
Subject: Re: [PATCHv7 6/6] io_uring: cache nodes and mapped buffers
Message-ID: <Z79y5hdS6EjuTEr5@kbusch-mbp>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-7-kbusch@meta.com>
 <83b85824-ddef-475e-ba83-b311f1a7b98f@kernel.dk>
 <e20b3f2f-9842-49a8-9f78-c469957e66f5@kernel.dk>
 <5f46cba6-0a11-457f-8591-732f709e7fea@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f46cba6-0a11-457f-8591-732f709e7fea@kernel.dk>

On Wed, Feb 26, 2025 at 12:58:21PM -0700, Jens Axboe wrote:
> On 2/26/25 12:43 PM, Jens Axboe wrote:
> > Ignore this one, that was bogus. Trying to understand a crash in here.
> 
> Just to wrap this up, it's the combining of table and cache that's the
> issue. The table can get torn down and freed while nodes are still
> alive - which is fine, but not with this change, as there's then no
> way to sanely put the cached entry.

Yes, the imu can outlive the table it came from, which means Pavel was
right to suggest I not tied the cache to the table. Thanks for pointing
this out.

