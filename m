Return-Path: <io-uring+bounces-8427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 295C6ADF16B
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 17:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CADDF17A2CD
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 15:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F441ADC98;
	Wed, 18 Jun 2025 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxDROtkq"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B3442049;
	Wed, 18 Jun 2025 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750260656; cv=none; b=CnYS8DZ+Wj51BAA2a7dUA/AuoaD3ik1fj+gLf34GTb1uSvfUW4ES5eBSLTlmX0kpY8yxDQHP/UGaDyva0UVWy2++2Go0k0VNncM0Ds265egHHRpbUpoOvYdeQPH42n8B8WgRBCixSgciyjr/2FDOXwUVNSnD+dEJnmAafeFbTlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750260656; c=relaxed/simple;
	bh=GCX1vWGNkeJKskqfNtdVsGwTEWueDq3DcbgaDkayPls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMDd1+gQX1HYct4yhTujB6uDFCLaIRPPGktAWdz9+dHTIP14oSXhAdsPJs7gA//IPnsDwEfLMbJfTLxNhtZ9pQbKcvRXNeb4dgEnq4YZsiqbwzhKAg4tN5lDmWd0rCdqow1mldI7sBZirva433EVijSAuhzfcOGH0u1IvCWRhys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxDROtkq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE58C4CEE7;
	Wed, 18 Jun 2025 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750260655;
	bh=GCX1vWGNkeJKskqfNtdVsGwTEWueDq3DcbgaDkayPls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UxDROtkqN2LBa1YHF2fl2N+AKcY2m3+B93whvfwg6c7pkdBzZYPmBUHgiGEVIKdCn
	 AiZ2NwHR1W6gjot6YAOOOM1aAVieCaOKmkXJCZFZhwLnKQ2ghmFzdovf2/z2aP4MH/
	 YWKPiFvpENr+zdyIm704aXqicQLMiaG1HTJ4xM2966e4T2PgBW3fl3PNWD/3w1o03a
	 9cBGEERkLUWyVJywumbCnzl0Ko8ElSXsov6uN13J/hqUVaaFCbMVm4coViUjqHFD0X
	 caoDnHkj2JuhOPCQcemHH576MDMOze1kLUBJAPcaM1CBaPYaQKnand4ZRLQVdHjfgH
	 upnCoMrBbfRTA==
Date: Wed, 18 Jun 2025 09:30:51 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bernd Schubert <bschubert@ddn.com>
Cc: "xiaobing.li" <xiaobing.li@samsung.com>, amir73il@gmail.com,
	asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
	joannelkoong@gmail.com, josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org, miklos@szeredi.hu,
	tom.leiming@gmail.com, kun.dou@samsung.com, peiwei.li@samsung.com,
	xue01.he@samsung.com, cliang01.li@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring.
Message-ID: <aFLbq5zYU6_qu_Yk@kbusch-mbp>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <CGME20250618105918epcas5p472b61890ece3e8044e7172785f469cc0@epcas5p4.samsung.com>
 <20250618105435.148458-1-xiaobing.li@samsung.com>
 <dc5ef402-9727-4168-bdf4-b90217914841@ddn.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc5ef402-9727-4168-bdf4-b90217914841@ddn.com>

On Wed, Jun 18, 2025 at 03:13:41PM +0200, Bernd Schubert wrote:
> On 6/18/25 12:54, xiaobing.li wrote:
> > 
> > Hi Bernd,
> > 
> > Do you have any plans to add zero copy solution? We are interested in
> > FUSE's zero copy solution and conducting research in code.
> > If you have no plans in this regard for the time being, we intend to
> >  submit our solution.
> 
> Hi Xiobing,
> 
> Keith (add to CC) did some work for that in ublk and also planned to
> work on that for fuse (or a colleague). Maybe Keith could
> give an update.

I was initially asked to implement a similar solution that ublk uses for
zero-copy, but the requirements changed such that it won't work. The
ublk server can't directly access the zero-copy buffers. It can only
indirectly refer to it with an io_ring registered buffer index, which is
fine my ublk use case, but the fuse server that I was trying to
enable does in fact need to directly access that data.

My colleauge had been working a solution, but it required shared memory
between the application and the fuse server, and therefore cooperation
between them, which is rather limiting. It's still on his to-do list,
but I don't think it's a high priority at the moment. If you have
something in the works, please feel free to share it when you're ready,
and I would be interested to review.

