Return-Path: <io-uring+bounces-226-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF8F380488F
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 05:31:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D3051F21407
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 04:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DD0A52;
	Tue,  5 Dec 2023 04:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="io/7Mq7r"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD305D52C;
	Tue,  5 Dec 2023 04:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672CDC433C7;
	Tue,  5 Dec 2023 04:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701750685;
	bh=lGZYwUIiKu4amlIwXobviw/VD3ZIr0JStDMMtmlRVqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=io/7Mq7rfMew8JjYKie/TIiJ1z8iLJuyykuKr8VbTDZ1TIYZjAcQAVIJHXCDh1/rw
	 gG1UHHis2iF3GTzBKMpWCN0KmHM7EvkvB6hVcXPUCLXq3g8KtHxWJucdK5WaIOEnp0
	 Rum18VZRLXCJbTmQ10iOT4gu1EVs0sNrcOianBMvk812UkWmlbAIznjvWbYqfq4GKZ
	 myfLjudjTWLYgE7VkXwxNk+2hjqIqOO4hACfWOnQQOiBT7WR9S6/AV8P2anKlwPbWp
	 JkRsCqB+ozBBHquMrfJU0K5fTk/n6RmhdD5Pael6TuVoKUjjswpgIGeMxtiLLpfbnO
	 QuERztJk7CvMA==
Date: Mon, 4 Dec 2023 21:31:21 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Keith Busch <kbusch@meta.com>,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	asml.silence@gmail.com, linux-security-module@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Message-ID: <ZW6nmR2ytIBApXE0@kbusch-mbp>
References: <20231204175342.3418422-1-kbusch@meta.com>
 <x49zfypstdx.fsf@segfault.usersys.redhat.com>
 <ZW4hM0H6pjbCpIg9@kbusch-mbp>
 <ZW6jjiq9wXHm5d10@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW6jjiq9wXHm5d10@fedora>

On Tue, Dec 05, 2023 at 12:14:22PM +0800, Ming Lei wrote:
> On Mon, Dec 04, 2023 at 11:57:55AM -0700, Keith Busch wrote:
> > On Mon, Dec 04, 2023 at 01:40:58PM -0500, Jeff Moyer wrote:
> > > I added a CC: linux-security-module@vger
> > > Keith Busch <kbusch@meta.com> writes:
> > > > From: Keith Busch <kbusch@kernel.org>
> > > >
> > > > The uring_cmd operation is often used for privileged actions, so drivers
> > > > subscribing to this interface check capable() for each command. The
> > > > capable() function is not fast path friendly for many kernel configs,
> > > > and this can really harm performance. Stash the capable sys admin
> > > > attribute in the io_uring context and set a new issue_flag for the
> > > > uring_cmd interface.
> > > 
> > > I have a few questions.  What privileged actions are performance
> > > sensitive? I would hope that anything requiring privileges would not
> > > be in a fast path (but clearly that's not the case).
> > 
> > Protocol specifics that don't have a generic equivalent. For example,
> > NVMe FDP is reachable only through the uring_cmd and ioctl interfaces,
> > but you use it like normal reads and writes so has to be as fast as the
> > generic interfaces.
> 
> But normal read/write pt command doesn't require ADMIN any more since 
> commit 855b7717f44b ("nvme: fine-granular CAP_SYS_ADMIN for nvme io commands"),
> why do you have to pay the cost of checking capable(CAP_SYS_ADMIN)?

Good question. The "capable" check had always been first so even with
the relaxed permissions, it was still paying the price. I have changed
that order in commit staged here (not yet upstream):

  http://git.infradead.org/nvme.git/commitdiff/7be866b1cf0bf1dfa74480fe8097daeceda68622

Note that only prevents the costly capable() check if the inexpensive
checks could make a determination. That's still not solving the problem
long term since we aim for forward compatibility where we have no idea
which opcodes, admin identifications, or vendor specifics could be
deemed "safe" for non-root users in the future, so those conditions
would always fall back to the more expensive check that this patch was
trying to mitigate for admin processes.

