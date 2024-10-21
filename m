Return-Path: <io-uring+bounces-3873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9F29A8FED
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 21:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9923F28431C
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 19:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09EC61FCC4B;
	Mon, 21 Oct 2024 19:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i87kZedR"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F331991AE;
	Mon, 21 Oct 2024 19:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729539320; cv=none; b=kiuVnFdOqApKWR2dyMFGClYMkSk3cNGSJQkJnA0+73whuXIcpP1edI4GT3CEAHC+5ZVxHaR5ZNH2tfil6AvLIZ0i4u9jxhaX2bbrYv0ge6zuQaLfQx7VwIJuZfi7Bw1gJIwXABCPn8yxhm3mGXtiA3++eoKsgURRPd0ipiFOJGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729539320; c=relaxed/simple;
	bh=S+eoZ9PsMFOj075TBAMfbklJrhMw50VOHQse4okNSPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q/QQyZ0bsS09JeQNNA1DScQXLc0QXaksXWbWqQL+kMpU1uiVjE2RHOThxhcZ+ob1mq1vaYDNolNXg3f5iP/Y55Yii6pOCh1Z3hhoQed/fl/cdD12FSxZ404H3K+05fluVPF523ftQWN6U2l0rhD7QVM5u7n1JOby3bcuO399Qr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i87kZedR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F80C4CEE9;
	Mon, 21 Oct 2024 19:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729539318;
	bh=S+eoZ9PsMFOj075TBAMfbklJrhMw50VOHQse4okNSPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i87kZedRPyejz9h+qiOBKWrrI2Whc6Xb01cPDQ/kj7/qwvJaLkvkgxhv5GL+bJH1c
	 xy1+Vo8vn2FdmizpfWFhUWLNOml0K/7bR57ZR/PlAp/M4AwQJ+kkbbBj1p2qNWk0GN
	 Y36wzVsmOYlnJaseXmmzx9OgUrHmZ5gKo4W16l12ejzYbXou2W/lctU6x7DpQqK0QI
	 o0JNDtEXYXDl9ZCl9hfjp6TnUZK+SPvNFltBBsA29zFE5aU7FcWj8bcefhntVRw6ni
	 IQrRelotOl5lnpQMNxj7B1WOGQrNJqMXq6MvTg+Jr6a1PNgabD2CCIx1Vok/YpIwoo
	 4X+JmF/7fYgug==
Date: Mon, 21 Oct 2024 13:35:15 -0600
From: Keith Busch <kbusch@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, joshi.k@samsung.com,
	javier.gonz@samsung.com, Nitesh Shetty <nj.shetty@samsung.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 1/6] block, fs: restore kiocb based write hint
 processing
Message-ID: <Zxas8xGoydNLGwsc@kbusch-mbp>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-2-kbusch@meta.com>
 <20241018055032.GB20262@lst.de>
 <ZxZ3o_HzN8HN6QPK@kbusch-mbp>
 <a87c67aa-b1fe-48dc-9b5a-bc6732931298@acm.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a87c67aa-b1fe-48dc-9b5a-bc6732931298@acm.org>

On Mon, Oct 21, 2024 at 10:09:57AM -0700, Bart Van Assche wrote:
> On 10/21/24 8:47 AM, Keith Busch wrote:
> > On Fri, Oct 18, 2024 at 07:50:32AM +0200, Christoph Hellwig wrote:
> > > On Thu, Oct 17, 2024 at 09:09:32AM -0700, Keith Busch wrote:
> > > >   {
> > > >   	*kiocb = (struct kiocb) {
> > > >   		.ki_filp = filp,
> > > >   		.ki_flags = filp->f_iocb_flags,
> > > >   		.ki_ioprio = get_current_ioprio(),
> > > > +		.ki_write_hint = file_write_hint(filp),
> > > 
> > > And we'll need to distinguish between the per-inode and per file
> > > hint.  I.e. don't blindly initialize ki_write_hint to the per-inode
> > > one here, but make that conditional in the file operation.
> > 
> > Maybe someone wants to do direct-io with partions where each partition
> > has a different default "hint" when not provided a per-io hint? I don't
> > know of such a case, but it doesn't sound terrible. In any case, I feel
> > if you're directing writes through these interfaces, you get to keep all
> > the pieces: user space controls policy, kernel just provides the
> > mechanisms to do it.
> 
> Is it important to support partitions on top of FDP namespaces? 

It's already used with partitions, so yes, it's important. Breaking that
as a condition to make it work with the block stack is a non-starter.

