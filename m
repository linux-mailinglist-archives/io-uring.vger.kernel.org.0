Return-Path: <io-uring+bounces-227-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6276E80494C
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 06:26:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4CE1B20C68
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 05:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471F28F6B;
	Tue,  5 Dec 2023 05:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gpQ586ja"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDE0101
	for <io-uring@vger.kernel.org>; Mon,  4 Dec 2023 21:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701753962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UItdnX8ajj27d5Qso73kxc+PaX4o0omDbnZKQK9rTcs=;
	b=gpQ586jaC230LhcJLHPoJ1GX7hNfSuAKPXQksdGsLd6JGb9sORGwCOfO97w1sISBFk8aFU
	kkJkNlhuIX5WIw8pzEqF5Aztkvij5EbjjsMYkIBWAEflrxEFM2oPRjU+pcwWvK3SrgKyJW
	LzAZJkR0/azujvMgGgtYzjCEfYs7QyU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-VYnt0zC1PLC1jjSTgEIXlA-1; Tue,
 05 Dec 2023 00:25:56 -0500
X-MC-Unique: VYnt0zC1PLC1jjSTgEIXlA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 700411C068DE;
	Tue,  5 Dec 2023 05:25:55 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F6671C060AF;
	Tue,  5 Dec 2023 05:25:48 +0000 (UTC)
Date: Tue, 5 Dec 2023 13:25:44 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Keith Busch <kbusch@meta.com>,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	asml.silence@gmail.com, linux-security-module@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Message-ID: <ZW60WPf/hmAUoxPv@fedora>
References: <20231204175342.3418422-1-kbusch@meta.com>
 <x49zfypstdx.fsf@segfault.usersys.redhat.com>
 <ZW4hM0H6pjbCpIg9@kbusch-mbp>
 <ZW6jjiq9wXHm5d10@fedora>
 <ZW6nmR2ytIBApXE0@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW6nmR2ytIBApXE0@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Mon, Dec 04, 2023 at 09:31:21PM -0700, Keith Busch wrote:
> On Tue, Dec 05, 2023 at 12:14:22PM +0800, Ming Lei wrote:
> > On Mon, Dec 04, 2023 at 11:57:55AM -0700, Keith Busch wrote:
> > > On Mon, Dec 04, 2023 at 01:40:58PM -0500, Jeff Moyer wrote:
> > > > I added a CC: linux-security-module@vger
> > > > Keith Busch <kbusch@meta.com> writes:
> > > > > From: Keith Busch <kbusch@kernel.org>
> > > > >
> > > > > The uring_cmd operation is often used for privileged actions, so drivers
> > > > > subscribing to this interface check capable() for each command. The
> > > > > capable() function is not fast path friendly for many kernel configs,
> > > > > and this can really harm performance. Stash the capable sys admin
> > > > > attribute in the io_uring context and set a new issue_flag for the
> > > > > uring_cmd interface.
> > > > 
> > > > I have a few questions.  What privileged actions are performance
> > > > sensitive? I would hope that anything requiring privileges would not
> > > > be in a fast path (but clearly that's not the case).
> > > 
> > > Protocol specifics that don't have a generic equivalent. For example,
> > > NVMe FDP is reachable only through the uring_cmd and ioctl interfaces,
> > > but you use it like normal reads and writes so has to be as fast as the
> > > generic interfaces.
> > 
> > But normal read/write pt command doesn't require ADMIN any more since 
> > commit 855b7717f44b ("nvme: fine-granular CAP_SYS_ADMIN for nvme io commands"),
> > why do you have to pay the cost of checking capable(CAP_SYS_ADMIN)?
> 
> Good question. The "capable" check had always been first so even with
> the relaxed permissions, it was still paying the price. I have changed
> that order in commit staged here (not yet upstream):
> 
>   http://git.infradead.org/nvme.git/commitdiff/7be866b1cf0bf1dfa74480fe8097daeceda68622

With this change, I guess you shouldn't see the following big gap, right?

> Before: 970k IOPs
> After: 1750k IOPs

> 
> Note that only prevents the costly capable() check if the inexpensive
> checks could make a determination. That's still not solving the problem
> long term since we aim for forward compatibility where we have no idea
> which opcodes, admin identifications, or vendor specifics could be
> deemed "safe" for non-root users in the future, so those conditions
> would always fall back to the more expensive check that this patch was
> trying to mitigate for admin processes.

Not sure I get the idea, it is related with nvme's permission model for
user pt command, and:

1) it should be always checked in entry of nvme user pt command

2) only the following two types of commands require ADMIN, per commit
855b7717f44b ("nvme: fine-granular CAP_SYS_ADMIN for nvme io commands")

    - any admin-cmd is not allowed
    - vendor-specific and fabric commmand are not allowed

Can you provide more details why the expensive check can't be avoided for
fast read/write user IO commands?

Thanks, 
Ming


