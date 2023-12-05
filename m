Return-Path: <io-uring+bounces-243-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F08E80629E
	for <lists+io-uring@lfdr.de>; Wed,  6 Dec 2023 00:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF3532820D5
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 23:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74E37405D2;
	Tue,  5 Dec 2023 23:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RyvrE1Qz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AB5405CD
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 23:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782EBC433C8;
	Tue,  5 Dec 2023 23:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701817366;
	bh=dN3KFjiqJ5nFfZOPfoBLHBeTWj0W7V/PNc/ZAvqZuRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RyvrE1QzQDbLPfylh4Z2QVxOp2YDD3SKsVaSsQ3/fFRks54PwrN9T9XwTdVPJDAjn
	 IPjUJ3Sxj2sIsjhorQRtWOE3XCsELeD5JeM+NLcdcsbx4h2JjeO4Al6gdhsOqxg0GK
	 CJ+HesuliHpCeeGVK0APc3DfWmHjvAjApo+xGUqGQ+fMao8vqIREyuAkLBp0NCd32B
	 EOfIqCP9Wef9n4hZ0cocoRPeVo1kaxpc7JVkD+Pc4pn+KXJn7DlRkDU4chlz9JUhCa
	 qdpPuFAHX2Si19IqYUJnft0puiJithb0HSuZ1bU6OFYBvv0aoDyv22XuzqwlUrrwl1
	 DnhIVOhuFjJcw==
Date: Tue, 5 Dec 2023 16:02:43 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
	asml.silence@gmail.com
Subject: Re: [PATCH] io_uring: save repeated issue_flags
Message-ID: <ZW-sE1hOG4EB3ktS@kbusch-mbp>
References: <20231205215553.2954630-1-kbusch@meta.com>
 <43ff7474-5174-4738-88d9-9c43517ae235@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43ff7474-5174-4738-88d9-9c43517ae235@kernel.dk>

On Tue, Dec 05, 2023 at 03:00:52PM -0700, Jens Axboe wrote:
> >  		if (!file->f_op->uring_cmd_iopoll)
> >  			return -EOPNOTSUPP;
> > -		issue_flags |= IO_URING_F_IOPOLL;
> >  		req->iopoll_completed = 0;
> >  	}
> >  
> > +	issue_flags |= ctx->issue_flags;
> >  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
> >  	if (ret == -EAGAIN) {
> >  		if (!req_has_async_data(req)) {
> 
> I obviously like this idea, but it should be accompanied by getting rid
> of ->compat and ->syscall_iopoll in the ctx as well?

Yeah, I considered that, and can incorporate it here. Below is a snippet
of what I had earlier to make that happen, but felt the purpose for the
"issue_flags" was uring_cmd specific and disconnected from everyone
else. Maybe I'm overthinking it...

diff --git a/io_uring/net.c b/io_uring/net.c
index 75d494dad7e2c..c11313e77495c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -549,7 +549,7 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	iomsg->msg.msg_iter.nr_segs = 0;

 #ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
+	if (req->ctx->issue_flags & IO_URING_F_COMPAT)
 		return __io_compat_recvmsg_copy_hdr(req, iomsg);
 #endif

