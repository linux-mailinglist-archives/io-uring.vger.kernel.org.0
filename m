Return-Path: <io-uring+bounces-5903-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC1EA13028
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:46:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 469FF3A3C2B
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 00:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A50C13B;
	Thu, 16 Jan 2025 00:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SaSBli8v"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DBA1372;
	Thu, 16 Jan 2025 00:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736988377; cv=none; b=JYeZAfeSV8O2B23ku9hBMJsdVLMMnON802LPhMrkdXHf3AXNGafL9f0Yh7EVVa+6Q9B6Loc2ktut8jHRl4akd3yH7vihuaeGrA960l3b4roGlSGA4H+97VCQKLr9joeYHEiFL0YbMVz2I7pDRZ/gUpSheW6Z6ECo9y3iwCmaeEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736988377; c=relaxed/simple;
	bh=psYx8CafJ6z47v1zMdeFnbkS/0Ig7nN1TZUByWYoV+0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nnZgjCDI0LVGM5PtlHrH+tinu4x8TMB2BLHrIrQTbajRz/3V14IqoUTPE2DRhNfMqFxspT8CHCImURsHVTMFCD50hdWLG5f/1PSteYLozH2VDz+ClHL080qJi15lkloNfMX3RjY2qMWdzeO8S3XQ8RQTvKW8BYaPb/sJmdQALxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SaSBli8v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF5EC4CED1;
	Thu, 16 Jan 2025 00:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736988376;
	bh=psYx8CafJ6z47v1zMdeFnbkS/0Ig7nN1TZUByWYoV+0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SaSBli8vJ7SSeAw2JMDObrmk8/YoscLfYdAG4gSqC/MUHsltQjo1AT+6+K4cwuhru
	 JGHFHTuPqhFQIrXtzSFFe4WWdCNo5X2XnqHI5MPtb42bb/sdMQrC+dd16VpKAYEDYD
	 vFB2gu5atJSoce38pnCfBnwWR4VIkUtc0FcW+iRRPg5PqaNIJYUEEmV+COdNozg4Yp
	 /ULZir+I+6KMdg7yGjf5hKfvfuAOpJMUAhHE0p5R4mF2wFJkYyNgJ3VXjnFnvVsZsc
	 HSScqxnf4N0qkkeLDk93D5sv3ZyMv1gwzx1R7/p0Ek53dvNHr++LpCsXYeV0nF2fif
	 KNVV3a0i+I51Q==
Date: Wed, 15 Jan 2025 16:46:15 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 08/22] net: page_pool: add callback for mp
 info printing
Message-ID: <20250115164615.037c34bf@kernel.org>
In-Reply-To: <20250108220644.3528845-9-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-9-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Jan 2025 14:06:29 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Add a mandatory callback that prints information about the memory
> provider to netlink.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

