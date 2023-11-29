Return-Path: <io-uring+bounces-170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B88207FDD26
	for <lists+io-uring@lfdr.de>; Wed, 29 Nov 2023 17:35:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59CCFB20ED4
	for <lists+io-uring@lfdr.de>; Wed, 29 Nov 2023 16:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338C83AC25;
	Wed, 29 Nov 2023 16:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNKHpEYx"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A4539862;
	Wed, 29 Nov 2023 16:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E37C433C9;
	Wed, 29 Nov 2023 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701275727;
	bh=eOjkRPVgX0VcHNh7RX+k1LOyqo1PtzlUuZb0jt0NekI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bNKHpEYxm2MblF/x9ck6IR8M74a3B/2DUKLTdYCZvJSvH069KjVLP52RxPFKLBH94
	 BvmXPN3Jh/xayNb7sh0GfQ0CqzhA5VetVG1cHAFpnsR9phLheWfNCdrYy/e1JlpQWj
	 s5MfMaunxJ6GYGlP1mp+eoIpLPwQCOIBMqL0oeCErCBuEOPzAFvnh1Yd7VI6BJ3ci/
	 /9CZsUD8olOADonP1zLnBZmV2muokDFyNNqtHGX2SVfTL0gyUXyoxsVxscR+m4f6XZ
	 ad9hY6n/othTAHB6CnoYUo/ToXwCU1d8MRFmJjP7y6V1MgNO/Eu0HP0RRNzTPkIo4q
	 xGLy50AN2EpCA==
Date: Wed, 29 Nov 2023 09:35:24 -0700
From: Keith Busch <kbusch@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	ming.lei@redhat.com
Subject: Re: [PATCHv4 1/4] block: bio-integrity: directly map user buffers
Message-ID: <ZWdoTOtNbomVQFd3@kbusch-mbp.dhcp.thefacebook.com>
References: <20231128222752.1767344-1-kbusch@meta.com>
 <CGME20231128222827epcas5p19beb5067fa55290aef73f96dee91c4ec@epcas5p1.samsung.com>
 <20231128222752.1767344-2-kbusch@meta.com>
 <249c59bb-794b-f8ec-c4e7-17308ecf7f2a@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <249c59bb-794b-f8ec-c4e7-17308ecf7f2a@samsung.com>

On Wed, Nov 29, 2023 at 08:48:41PM +0530, Kanchan Joshi wrote:
> On 11/29/2023 3:57 AM, Keith Busch wrote:
> > If the user address can't directly be used for reason, like too many
> > segments or address unalignement, fallback to a copy of the user vec
> > while keeping the user address pinned for the IO duration so that it
> > can safely be copied on completion in any process context.
> 
> The pinning requirement is only for read. But code keeps user-memory 
> pinned for write too. Is there any reason?

It just makes the completion simpler. I'll split the cases so we unpin
on writes after the copy during setup.

