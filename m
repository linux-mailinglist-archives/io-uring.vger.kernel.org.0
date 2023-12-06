Return-Path: <io-uring+bounces-249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B36AB806570
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 04:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E3E42820CF
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 03:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D47C6FC6;
	Wed,  6 Dec 2023 03:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DtRYbOA4"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5F71B1
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 19:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701832117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JJlJspfrBuALAvTn0p2X3IEh4nGAcAADWiZo61JlgsA=;
	b=DtRYbOA4pYyff0dqWYC/3DE10NSy0NUvcqLh+rlla+G0vnjqLbE3ZHw2sbyc+Ek0oXUPtP
	+h84mZoUb4EG3D20DRf+vpJWajrFK7QPXUialDJTVqWa7Ds/RKWLGJwrZBzXVlevmSMINB
	GESN4j4pu1EKnf+Oab1bYklqmdlTGTI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-Uj0iBqCaNJiZCR-08QATHg-1; Tue,
 05 Dec 2023 22:08:31 -0500
X-MC-Unique: Uj0iBqCaNJiZCR-08QATHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37B2629AB3F1;
	Wed,  6 Dec 2023 03:08:31 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 21E512026D66;
	Wed,  6 Dec 2023 03:08:23 +0000 (UTC)
Date: Wed, 6 Dec 2023 11:08:17 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Keith Busch <kbusch@meta.com>,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
	axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	asml.silence@gmail.com, linux-security-module@vger.kernel.org,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
Message-ID: <ZW/loVJu0+11+boh@fedora>
References: <20231204175342.3418422-1-kbusch@meta.com>
 <x49zfypstdx.fsf@segfault.usersys.redhat.com>
 <ZW4hM0H6pjbCpIg9@kbusch-mbp>
 <ZW6jjiq9wXHm5d10@fedora>
 <ZW6nmR2ytIBApXE0@kbusch-mbp>
 <ZW60WPf/hmAUoxPv@fedora>
 <ZW9FhsBXdPlN6qrU@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW9FhsBXdPlN6qrU@kbusch-mbp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Tue, Dec 05, 2023 at 08:45:10AM -0700, Keith Busch wrote:
> On Tue, Dec 05, 2023 at 01:25:44PM +0800, Ming Lei wrote:
> > On Mon, Dec 04, 2023 at 09:31:21PM -0700, Keith Busch wrote:
> > > Good question. The "capable" check had always been first so even with
> > > the relaxed permissions, it was still paying the price. I have changed
> > > that order in commit staged here (not yet upstream):
> > > 
> > >   http://git.infradead.org/nvme.git/commitdiff/7be866b1cf0bf1dfa74480fe8097daeceda68622
> > 
> > With this change, I guess you shouldn't see the following big gap, right?
> 
> Correct.
>  
> > > Before: 970k IOPs
> > > After: 1750k IOPs
>  
> > > Note that only prevents the costly capable() check if the inexpensive
> > > checks could make a determination. That's still not solving the problem
> > > long term since we aim for forward compatibility where we have no idea
> > > which opcodes, admin identifications, or vendor specifics could be
> > > deemed "safe" for non-root users in the future, so those conditions
> > > would always fall back to the more expensive check that this patch was
> > > trying to mitigate for admin processes.
> > 
> > Not sure I get the idea, it is related with nvme's permission model for
> > user pt command, and:
> > 
> > 1) it should be always checked in entry of nvme user pt command
> > 
> > 2) only the following two types of commands require ADMIN, per commit
> > 855b7717f44b ("nvme: fine-granular CAP_SYS_ADMIN for nvme io commands")
> > 
> >     - any admin-cmd is not allowed
> >     - vendor-specific and fabric commmand are not allowed
> > 
> > Can you provide more details why the expensive check can't be avoided for
> > fast read/write user IO commands?
> 
> It's not necessarily about the read/write passthrough commands. It's for
> commands we don't know about today. Do we want to revisit this problem
> every time spec provides another operation? Are vendor unique solutions
> not allowed to get high IOPs access?

Except for read/write, what other commands are performance sensitive?

> 
> Secondly, some people have rediscovered you can abuse this interface to
> corrupt kernel memory, so there are considerations to restricting this

Just wondering why ADMIN won't corrupt kernel memory, and only normal
user can, looks it is kernel bug instead of permission related issue.

> to CAP_SYS_ADMIN anyway, so there's no cheap check available today if we
> have to go that route.

If capable(CAP_SYS_ADMIN) is really slow, I am wondering why not
optimize it in task_struct?


Thanks, 
Ming


