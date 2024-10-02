Return-Path: <io-uring+bounces-3381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A9AB98DF3F
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 17:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C623F286E39
	for <lists+io-uring@lfdr.de>; Wed,  2 Oct 2024 15:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4369A1CF7D2;
	Wed,  2 Oct 2024 15:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qLgEh+s5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100F5748F;
	Wed,  2 Oct 2024 15:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727883200; cv=none; b=fmedNMhp6Up7HCp0JdS2jxJF3ZjwlZEl8yxIaGAeqgDhC1ltfL6s3jy/hBBWWoZU6QAS2sX3OJi6jAUUFuIs31NneLW81zrLdbUzEfa2yJEx1TOi2Xccqbtn4mgQMdl+3T6xPe7FAY35S9R5oS6ajaON0Vx5+9rWQ3fL6XUDoII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727883200; c=relaxed/simple;
	bh=Qu1woXcrjhp6mj151jH+MKv52DBKg49ddjc4vbsUAmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hguj8qyTEMoMUDnuuy+j7lNLyZRH5SESiwlb3kh7la9/VdtwT8HDfufVnbt5nQ7L7XofZGaj0WhknlAi8RbayTwDD3umKlgxZlhVKpi4dRdUKqnJWURyBupPSBM3hO8OyAdE7cEFO5YODyALIZNzRdP8SIz/fM9597DOC6Cnp14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qLgEh+s5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADABC4CEC2;
	Wed,  2 Oct 2024 15:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727883199;
	bh=Qu1woXcrjhp6mj151jH+MKv52DBKg49ddjc4vbsUAmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qLgEh+s5Rk39ZYsz061N3zRQj1PrUxxnAh2ujTPzy7wuBwiCFzMzImY8PeFfsOyX+
	 dY3R2xMGK0UDX+Tkm+dcy1WzCapWGbN3e/kiItmXxtt5OBK1SbhLOn08jiz/3Fvlvu
	 2lRoONetfV0k+URzRpp3MC0UTnJELwk5dswLvGxU1dJJVun3tyUAm88GUdKcmbWnx9
	 rDIoyfemGaeJ8kWI5QVcWgE/Z+ZPQJfWEvX57eTHQtrwd86c+L9AzsOjFSOKpEj+CQ
	 xC39H3wqhlT+GygAKBAYtO9N+hiy58Iezn5CbVOviY0FvYGm3JOiAMOkBfDRczf7jN
	 hraPj+0SHpJzQ==
Date: Wed, 2 Oct 2024 09:33:16 -0600
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
Message-ID: <Zv1nvIcENHnBcd2G@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20240930182052epcas5p37edefa7556b87c3fbb543275756ac736@epcas5p3.samsung.com>
 <20240930181305.17286-1-joshi.k@samsung.com>
 <20241001092047.GA23730@lst.de>
 <99c95f26-d6fb-4354-822d-eac94fdba765@kernel.dk>
 <20241002075140.GB20819@lst.de>
 <f14a246b-10bf-40c1-bf8f-19101194a6dc@kernel.dk>
 <20241002151344.GA20364@lst.de>
 <Zv1kD8iLeu0xd7eP@kbusch-mbp.dhcp.thefacebook.com>
 <20241002151949.GA20877@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002151949.GA20877@lst.de>

On Wed, Oct 02, 2024 at 05:19:49PM +0200, Christoph Hellwig wrote:
> > Nothing prevents future improvements in that direction. It just seems
> > out of scope for what Kanchan is trying to enable for his customer use
> > cases. This patch looks harmless.
> 
> It's not really.  Once we wire it up like this we mess up the ability
> to use the feature in other ways.  Additionally the per-I/O hints are
> simply broken if you want a file system in the way as last time,
> and if I don't misremember you acknowledged in person last week.

You remember right. I also explained the use cases for per-io hints are
to replace current passthrough users with generic read/write paths that
have all the memory guard rails, read/write stats, and other features
that you don't get with passthrough. This just lets you accomplish the
same placement hints with the nvme raw block device that you get with
the nvme char device.

