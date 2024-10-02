Return-Path: <io-uring+bounces-3378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C92F98DEBA
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 17:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDAFF1F26B58
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 15:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A5E1D0B97;
	Wed,  2 Oct 2024 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PiCvDTWX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D461D0B8B;
	Wed,  2 Oct 2024 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727882259; cv=none; b=aI6cTq6KQiRbgQyNgFN0zijXgdYxPDToTJz1w5NLRHgZ6nVMVpX5DinrxOVybBfq+5qxwHV+wbaCI3w9qJwlYa7/Me1WGyzF/3p/iMe/YgXC+YiQ/YJuOwqPY2c0o7wSf1PFhKPgjcQdy1nr09kOSZd2gb7GB65BK2TPd2DVvMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727882259; c=relaxed/simple;
	bh=ncfHnDDIrlsZ5cv1DqDqNYuQtlTPW4NktXBA1Q3cPL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iAEB6nXMGc1/I4AH4UxsE3WStFbGYEI2X+d9HNUFyH3vJocDpugRQ9GtgBuP6GUAGCbPXjtw9Yl6AKRBarljPloQpE2/GbbriB4AhMd0LUlX5L3U3/dBnK4al+QTsJBU2rmywIqC9/pqVLLMqi+nhcWMFmxDjgg0a4Ok9SEy6UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PiCvDTWX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF02C4CECD;
	Wed,  2 Oct 2024 15:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727882258;
	bh=ncfHnDDIrlsZ5cv1DqDqNYuQtlTPW4NktXBA1Q3cPL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PiCvDTWXEQOSQi04Hf+D0gfF9g3t3uYK54HODlBfgBSmb4j6zCUNjfO6Xg7JbRQcN
	 ypabAKkcQw3ZmG0HNs5h4GZcKtSABifQex7u9gRsGMahmHmrw28U7VhdVUEdOWaM3k
	 jVcSRQEXgfLonFcqVMl/DyhNaDvvdzMQ7W0Dx00zOoS/9WWWZ4Otv9clvYduUO0Fq4
	 s4YdnwFod+8Xu7Hm17K4pAuOFvL+NaiAjlTNI/mnUJ52ttBxnb6doCAVKB/8QZvt2L
	 9BCOe8TT6yBck17+aqbKek/D/atOGlodaaroLEcgkKykJUyczO6oB5RC+QpTmCnMx1
	 wcCZw8qd93pxg==
Date: Wed, 2 Oct 2024 09:17:35 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	hare@suse.de, sagi@grimberg.me, martin.petersen@oracle.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-aio@kvack.org, gost.dev@samsung.com, vishak.g@samsung.com,
	javier.gonz@samsung.com
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com>
 <20241001092047.GA23730@lst.de>
 <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
 <20241002075140.GB20819@lst.de>
 <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
 <20241002151344.GA20364@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002151344.GA20364@lst.de>

On Wed, Oct 02, 2024 at 05:13:44PM +0200, Christoph Hellwig wrote:
> 
> Well, he finally started on the right approach and gave it up after the
> first round of feedback.  That's just a bit weird.

Nothing prevents future improvements in that direction. It just seems
out of scope for what Kanchan is trying to enable for his customer use
cases. This patch looks harmless.

