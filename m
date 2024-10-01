Return-Path: <io-uring+bounces-3350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D62798C357
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 18:25:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29B22285FC4
	for <lists+io-uring@lfdr.de>; Tue,  1 Oct 2024 16:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157871CB51D;
	Tue,  1 Oct 2024 16:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kt3ZiVnQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80DC1CB513;
	Tue,  1 Oct 2024 16:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727799827; cv=none; b=gXorZmRAX8V7DKRWkARnpD3AVVS4in2atOjhm6TQO2WgPsd7H/BSvSqNBSBV+pelnk8P0iAUu5JSz1ufptU7dEMZVjLPAE+hCCoFo1tGIQUxJ+MoIjpgjp67duWfFUwg+m+Toy5rKXuZX+uD2cDoC6STTU/vM4+I3Y84CCziU+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727799827; c=relaxed/simple;
	bh=w1g+MZ8OSr/yI8Fxcdx00lY1A/TRv9HBlLNAipFFr4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8gCg8VxswC6m8scLTsmQbqI9FB4MsfgtGSbQ4EL/ruiKDrlFFex5WvAk7HMvu3kWXxAzppxFquppi40PIqFIn3iNR/hLaezpxMObcSIPzI0s68aAgRNCNANVe/CovO/1slieSgrIcRcwjK37uhR/MTuSTSSdzs3NpAOyKJu8jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kt3ZiVnQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70583C4CEC6;
	Tue,  1 Oct 2024 16:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727799826;
	bh=w1g+MZ8OSr/yI8Fxcdx00lY1A/TRv9HBlLNAipFFr4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kt3ZiVnQmIb8+1XZ90iic2VM1jfsyrND5B4ffPweDTWhMOiqLSg8NggcpsKJQQzAT
	 fYshWYHV3OCZHoBd3QpRA5vaJ3H0uTIhvQyFK+mkjycQJSz9PyeA/VFKMUVw2wcjTW
	 nww5w4oxIPPZj4JftoHAFJhDqITWfTH0S69I4fi7pUPsUBM1rDw3xUqdCUu/hFpelN
	 w+8rsT0uQYEfA+rU72UpXCZYEttyUltTImUSsrEM+6i8dljg1UQMSXBEzZOPkUSBQx
	 gwYl6aUzfgi/lBIwG07o3VQYJkRInrnFRxFre40mKG4OHMTIeYTcIZtbSOFW6Odseq
	 KeNx+LcN5mT+w==
Date: Tue, 1 Oct 2024 10:23:43 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hare@suse.de,
	sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org,
	bcrl@kvack.org, dhowells@redhat.com, bvanassche@acm.org,
	asml.silence@gmail.com, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <ZvwiD0v3ASF8Hap2@kbusch-mbp.mynextlight.net>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com>
 <20241001092047.GA23730@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001092047.GA23730@lst.de>

On Tue, Oct 01, 2024 at 11:20:48AM +0200, Christoph Hellwig wrote:
> Any reason you completely ignored my feedback on the last version
> and did not even answer?
> 
> That's not a very productive way to work.

I think because he's getting conflicting feedback. The arguments against
it being that it's not a good match, however it's the same match created
for streams, and no one complained then, and it's an existing user ABI.
FDP is a the new "streams", so I really don't see a big deal here. I
understand you have use cases that have filesystems intercept the hints
for different types of devices, but I don't see these use cases as
mutally exclusive. Supporting this one doesn't prevent other uses.

