Return-Path: <io-uring+bounces-238-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C211680590B
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 16:45:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2FAF1C20ED9
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 15:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C2E5F1F0;
	Tue,  5 Dec 2023 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOllAY9q"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CDF5F1D8;
	Tue,  5 Dec 2023 15:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1299C433C7;
	Tue,  5 Dec 2023 15:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701791113;
	bh=0Y2l+6X6yAzUwntjk32nri6/kEK8xQ9ERpsa5g3ublU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IOllAY9qdJbBqLupXffhTZZMX0SZMUbRY4e1fkbgI0Lqyup8GE3P0tsEEJub86t+g
	 PBuu/6EZewsAPPHzyVcGD8DaHwTuFGZ2QZp2n2Jzq7I81MWQEx5xRRIn19prZvlwAM
	 42VHYYq0j8LAIJOMVfyWRiKhsWXqhWvAcg5cVMzMLrDCNmMb3vk7KM9eRXf4AWiE4d
	 r3tOk8SPsXnwd9iJYHFbNtGXFJm3GP8VgHu7pM90Kv/ZJwepcWpaFvPT09Jn4yjpIK
	 PCq3FaR/lepelX2IJx3ADAbvd3f2y3TYKn6Oqx8OD+vw6T2pXUXeyXQL646dMpnCU5
	 1oIhkddlEmJhg==
Date: Tue, 5 Dec 2023 08:45:10 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Keith Busch <kbusch@meta.com>,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	asml.silence@gmail.com, linux-security-module@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Message-ID: <ZW9FhsBXdPlN6qrU@kbusch-mbp>
References: <20231204175342.3418422-1-kbusch@meta.com>
 <x49zfypstdx.fsf@segfault.usersys.redhat.com>
 <ZW4hM0H6pjbCpIg9@kbusch-mbp>
 <ZW6jjiq9wXHm5d10@fedora>
 <ZW6nmR2ytIBApXE0@kbusch-mbp>
 <ZW60WPf/hmAUoxPv@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW60WPf/hmAUoxPv@fedora>

On Tue, Dec 05, 2023 at 01:25:44PM +0800, Ming Lei wrote:
> On Mon, Dec 04, 2023 at 09:31:21PM -0700, Keith Busch wrote:
> > Good question. The "capable" check had always been first so even with
> > the relaxed permissions, it was still paying the price. I have changed
> > that order in commit staged here (not yet upstream):
> > 
> >   http://git.infradead.org/nvme.git/commitdiff/7be866b1cf0bf1dfa74480fe8097daeceda68622
> 
> With this change, I guess you shouldn't see the following big gap, right?

Correct.
 
> > Before: 970k IOPs
> > After: 1750k IOPs
 
> > Note that only prevents the costly capable() check if the inexpensive
> > checks could make a determination. That's still not solving the problem
> > long term since we aim for forward compatibility where we have no idea
> > which opcodes, admin identifications, or vendor specifics could be
> > deemed "safe" for non-root users in the future, so those conditions
> > would always fall back to the more expensive check that this patch was
> > trying to mitigate for admin processes.
> 
> Not sure I get the idea, it is related with nvme's permission model for
> user pt command, and:
> 
> 1) it should be always checked in entry of nvme user pt command
> 
> 2) only the following two types of commands require ADMIN, per commit
> 855b7717f44b ("nvme: fine-granular CAP_SYS_ADMIN for nvme io commands")
> 
>     - any admin-cmd is not allowed
>     - vendor-specific and fabric commmand are not allowed
> 
> Can you provide more details why the expensive check can't be avoided for
> fast read/write user IO commands?

It's not necessarily about the read/write passthrough commands. It's for
commands we don't know about today. Do we want to revisit this problem
every time spec provides another operation? Are vendor unique solutions
not allowed to get high IOPs access?

Secondly, some people have rediscovered you can abuse this interface to
corrupt kernel memory, so there are considerations to restricting this
to CAP_SYS_ADMIN anyway, so there's no cheap check available today if we
have to go that route.

Lastly (and least important), there are a lot of checks happening in the
"quick" path that I am trying to replace with a single check. While each
invidividual check isn't too bad, they start to add up.

