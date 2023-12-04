Return-Path: <io-uring+bounces-219-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 804C1803DD1
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 19:58:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B28FA1C20A77
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 18:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2732FC31;
	Mon,  4 Dec 2023 18:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Br4L24tP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A592FC20;
	Mon,  4 Dec 2023 18:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC67C433C7;
	Mon,  4 Dec 2023 18:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701716278;
	bh=aPVj9XXl+eRYnePRnmQ+vWxwVHPDe57ND1UdEZVfc00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Br4L24tPwBBeQzb7SaBAjh5gs52tLThxz5a9xZZf3Ih+92YiX6JVVf2u55xvtfDt5
	 CtOWxn08iOEd2/lIMP5A5NEf5bn0S5YMqmmLN0P90rOkkeZITdqRINxGI4vAYnW4Zq
	 7A2CVx0syvQH8uuc6wBJFMzPc2KI6udtjMiRqb8Wp0LWorMlx53vfAzD5M7PRXiFkJ
	 /d0NEHAD+ZANV+j3CUwESxkzhAa6YxibLNUA9PZLPThYBV4v9iWeVLQguYZWNrGnOR
	 88Nk+4GtrS2cBbqr2zRl/fCaWLOJv/f3ZbtWrLfU7GhlTtyfqtfZgyTfeJSDLQ4fmT
	 QObQoZRZMZweg==
Date: Mon, 4 Dec 2023 11:57:55 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, asml.silence@gmail.com,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Message-ID: <ZW4hM0H6pjbCpIg9@kbusch-mbp>
References: <20231204175342.3418422-1-kbusch@meta.com>
 <x49zfypstdx.fsf@segfault.usersys.redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zfypstdx.fsf@segfault.usersys.redhat.com>

On Mon, Dec 04, 2023 at 01:40:58PM -0500, Jeff Moyer wrote:
> I added a CC: linux-security-module@vger
> Keith Busch <kbusch@meta.com> writes:
> > From: Keith Busch <kbusch@kernel.org>
> >
> > The uring_cmd operation is often used for privileged actions, so drivers
> > subscribing to this interface check capable() for each command. The
> > capable() function is not fast path friendly for many kernel configs,
> > and this can really harm performance. Stash the capable sys admin
> > attribute in the io_uring context and set a new issue_flag for the
> > uring_cmd interface.
> 
> I have a few questions.  What privileged actions are performance
> sensitive? I would hope that anything requiring privileges would not
> be in a fast path (but clearly that's not the case).

Protocol specifics that don't have a generic equivalent. For example,
NVMe FDP is reachable only through the uring_cmd and ioctl interfaces,
but you use it like normal reads and writes so has to be as fast as the
generic interfaces.

The same interfaces can be abused, so access needs to be restricted.

> What performance benefits did you measure with this patch set in place
> (and on what workloads)? 

Quite a bit. Here's a random read high-depth workload on a single
device test:

Before: 970k IOPs
After: 1750k IOPs

> What happens when a ring fd is passed to another process?
> 
> Finally, as Jens mentioned, I would expect dropping priviliges to, you
> know, drop privileges.  I don't think a commit message is going to be
> enough documentation for a change like this.

Yeah, point taken.

