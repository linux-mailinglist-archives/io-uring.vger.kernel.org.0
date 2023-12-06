Return-Path: <io-uring+bounces-253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF188073B6
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 16:32:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B773828196C
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 15:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D5C3FE38;
	Wed,  6 Dec 2023 15:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTmU6kHK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44913D98C;
	Wed,  6 Dec 2023 15:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FA1C433C7;
	Wed,  6 Dec 2023 15:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701876718;
	bh=hAqLNmw1CUfJ61iCun+b5KBpjW9OiI64D5DKsIg/2B0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GTmU6kHKUVBNZbTEGud+JA0mzs+8si27WjOy2KPVoJWYTiTW5RXUCHFEIQAHHJWDU
	 mHpbhVvMzsIpqDSzpqQtFtkUMzTi0vC779plDPuAH1lKgmZz2YjLPpgBlD5omS40K4
	 JzrDMkx0k5XlPQHgDoRuXUPPcDke/D6VK5oaeRo7kAjKf/CddpHGC4RzFR009LXE4j
	 TtQBOapJ4WWYkuAyGMSE2nAV35S2ABsD4qhxJXKiptIGjBsd2lGFQLiP/dfs1Z4WHO
	 UFTph6l6OdP14Clz5qFzU3DSWlqGMOXbU8aTDEgvEAGzneuXxMuVAaBB3iqj/1+yZf
	 dlflsS7oX59oQ==
Date: Wed, 6 Dec 2023 08:31:54 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Keith Busch <kbusch@meta.com>,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	asml.silence@gmail.com, linux-security-module@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Message-ID: <ZXCT6mpt2Tq0k-Nw@kbusch-mbp>
References: <20231204175342.3418422-1-kbusch@meta.com>
 <x49zfypstdx.fsf@segfault.usersys.redhat.com>
 <ZW4hM0H6pjbCpIg9@kbusch-mbp>
 <ZW6jjiq9wXHm5d10@fedora>
 <ZW6nmR2ytIBApXE0@kbusch-mbp>
 <ZW60WPf/hmAUoxPv@fedora>
 <ZW9FhsBXdPlN6qrU@kbusch-mbp>
 <ZW/loVJu0+11+boh@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW/loVJu0+11+boh@fedora>

On Wed, Dec 06, 2023 at 11:08:17AM +0800, Ming Lei wrote:
> On Tue, Dec 05, 2023 at 08:45:10AM -0700, Keith Busch wrote:
> > 
> > It's not necessarily about the read/write passthrough commands. It's for
> > commands we don't know about today. Do we want to revisit this problem
> > every time spec provides another operation? Are vendor unique solutions
> > not allowed to get high IOPs access?
> 
> Except for read/write, what other commands are performance sensitive?

It varies by command set, but this question is irrelevant. I'm not
interested in gatekeeping the fast path.
 
> > Secondly, some people have rediscovered you can abuse this interface to
> > corrupt kernel memory, so there are considerations to restricting this
> 
> Just wondering why ADMIN won't corrupt kernel memory, and only normal
> user can, looks it is kernel bug instead of permission related issue.

Admin can corrupt memory as easily as a normal user through this
interface. We just don't want such capabilities to be available to
regular users.

And it's a user bug: user told the kernel to map buffer of size X, but
the device transfers size Y into it. Kernel can't do anything about that
(other than remove the interface, but such an action will break many
existing users) because we fundamentally do not know the true transfer
size of a random command. Many NVMe commands don't explicitly encode
transfer lengths, so disagreement between host and device on implicit
lengths risk corruption. It's a protocol "feature".

> > to CAP_SYS_ADMIN anyway, so there's no cheap check available today if we
> > have to go that route.
> 
> If capable(CAP_SYS_ADMIN) is really slow, I am wondering why not
> optimize it in task_struct?

That's an interesting point to look into. I was hoping to not touch such
a common struct, but I'm open to all options.

