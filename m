Return-Path: <io-uring+bounces-223-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E366803E86
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 20:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1F5A1C209CF
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 19:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C31A3174C;
	Mon,  4 Dec 2023 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kxw+4Sa5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591492E847;
	Mon,  4 Dec 2023 19:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70582C433C7;
	Mon,  4 Dec 2023 19:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701718662;
	bh=0B6qI7yaImDylh0YMgRVbhCUJKzhgt+Boa80ygB2x2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kxw+4Sa5aWZsRGjXXiOHaG8CDEWcJlA5x5hnxHIRWPRej0cwRs6208xvHr8NityLR
	 D2YPCyfYf3HvefW47SdvcmD5BSKOg6C/ltGeCDMJvEiK3N0Wdr95QzjjZn2SVQ4yZo
	 XnyB8Girl3wrr+wuOzERc2oVoM9PtUBJcpC6fja9bcXjNXhCCYaQ0t6DAtrWFyVxKv
	 biwGmCx6zcNSHB0JcW3IK3VxmOXYBgjBUTWTAhWbW0PnCSl5PZrtvhp404vXqWSPb4
	 BEYrnvI+Hi4pZdTD6rr4hBcRTxkjBV5wVNcJp3N3lPSNkC6NJjP5rY2ePXEflOqIJv
	 KdiE3phqDFmSw==
Date: Mon, 4 Dec 2023 12:37:38 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	hch@lst.de, sagi@grimberg.me, asml.silence@gmail.com,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Message-ID: <ZW4qggTr44dWT4ft@kbusch-mbp>
References: <20231204175342.3418422-1-kbusch@meta.com>
 <x49zfypstdx.fsf@segfault.usersys.redhat.com>
 <9c1ee0ee-ccae-4013-83f4-92a2af7bdf42@kernel.dk>
 <x49sf4hsrgx.fsf@segfault.usersys.redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49sf4hsrgx.fsf@segfault.usersys.redhat.com>

On Mon, Dec 04, 2023 at 02:22:22PM -0500, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
> > On 12/4/23 11:40 AM, Jeff Moyer wrote:
> >> Finally, as Jens mentioned, I would expect dropping priviliges to, you
> >> know, drop privileges.  I don't think a commit message is going to be
> >> enough documentation for a change like this.
> >
> > Only thing I can think of here is to cache the state in
> > task->io_uring->something, and then ensure those are invalidated
> > whenever caps change.
> 
> I looked through the capable() code, and there is no way that I could
> find to be notified of changes.

Something like LSM_HOOK_INIT on 'capset', but needs to work without
CONFIG_SECURITY.

