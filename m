Return-Path: <io-uring+bounces-3906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9079AB0FE
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:38:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4465A1F24148
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A6A19E97F;
	Tue, 22 Oct 2024 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivL/y0fE"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFFC558A5;
	Tue, 22 Oct 2024 14:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729607880; cv=none; b=czUoRNf2wNum33oGYLh5W8SwJWlk0jNvb3acFdJlyfuPH+M3Q3npj5Z8iKCw3tW3b3JP4V9M0yjZOri85/cI0gledPiSkH0LTavvdrBIvIYEMQLHu+VjC5MhsS/9qwvuPplMX8LUj9A0W8mg7dRL53eBmm25TH4lFaoLDnyLu/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729607880; c=relaxed/simple;
	bh=p8jy6tdnkz723LntVeZITPLHFVxOn5i0CPMPqySErvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqtnC7uQZ6sYoGFyx/t9r2rjtpwVFn2yh1E0EQPMKCaOQMbfyY/jkyr+DXnTEsZjlQagbC5W/8GkuusqBpYy+6mNo1DNpiK7Uss3w3kO9vo/Sko6iR2EtNbWVO1VJs7XH3wMFhOwmUL+CFceE3ulYxad/Q1MpA7oowAmnPshKZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivL/y0fE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C45C4CEC3;
	Tue, 22 Oct 2024 14:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729607879;
	bh=p8jy6tdnkz723LntVeZITPLHFVxOn5i0CPMPqySErvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ivL/y0fEKyi7iD+u35NDeLqW0E6Lrz5NIplvCGuMqxND+xRNwNHrHvm6/y+WuMlkx
	 VlG+GuWFHDiF2y72ckcH0ZXfDuNlDq6UMIJAd7MLrvAJ7sz1phEoDVb86lucGIIKDT
	 GD9xXU1iY64Ii3YGGnjPVD0DPkCzB14WDYWiRk/Txoiue72azE001DVvlypP194JsV
	 ljFpCcmD7FR8y9YS/tf8z4pafahLex+fwjf0ptffHUyDwmet/dxxYqxjQRMircXORN
	 LTrYgh3r1ciNs7Nfu5iB8q3QTzyhvK0t4uePDYiL7ojlVgI2sn3XqZzvruY5B3GP4B
	 sO58BjR2qPI7A==
Date: Tue, 22 Oct 2024 08:37:56 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, axboe@kernel.dk,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, javier.gonz@samsung.com,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv8 1/6] block, fs: restore kiocb based write hint
 processing
Message-ID: <Zxe4xL-sM5yF2isM@kbusch-mbp>
References: <20241017160937.2283225-1-kbusch@meta.com>
 <20241017160937.2283225-2-kbusch@meta.com>
 <20241018055032.GB20262@lst.de>
 <ZxZ3o_HzN8HN6QPK@kbusch-mbp>
 <20241022064309.GA11161@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022064309.GA11161@lst.de>

On Tue, Oct 22, 2024 at 08:43:09AM +0200, Christoph Hellwig wrote:
> On Mon, Oct 21, 2024 at 09:47:47AM -0600, Keith Busch wrote:
> > On Fri, Oct 18, 2024 at 07:50:32AM +0200, Christoph Hellwig wrote:
> > > On Thu, Oct 17, 2024 at 09:09:32AM -0700, Keith Busch wrote:
> > > >  {
> > > >  	*kiocb = (struct kiocb) {
> > > >  		.ki_filp = filp,
> > > >  		.ki_flags = filp->f_iocb_flags,
> > > >  		.ki_ioprio = get_current_ioprio(),
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
> Eww.  You actually pointed out a real problem here: if a device
> has multiple partitions the write streams as of this series are
> shared by them, which breaks their use case as the applications or
> file systems in different partitions will get other users of the
> write stream randomly overlayed onto theirs.
> 
> So either the available streams need to be split into smaller pools
> by partitions, or we just assigned them to the first partition to
> make these scheme work for partitioned devices.
> 
> Either way mixing up the per-inode hint and the dynamic one remains
> a bad idea.

No doubt it's almost certainly not a good idea to mix different stream
usages, but that's not the kernels problem. It's user space policy. I
don't think the kernel needs to perform any heroic efforts to split
anything here. Just keep it simple.

