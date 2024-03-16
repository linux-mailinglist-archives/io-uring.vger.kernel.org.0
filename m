Return-Path: <io-uring+bounces-1011-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3946A87D9AF
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 10:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F0221C20B7A
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 09:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F4614292;
	Sat, 16 Mar 2024 09:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jPUQRiCF"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EBE259C
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710582821; cv=none; b=g92Lnjrb8jj3iiqY9mID9IiVMbxUZktepk7cH+tHRpCJHkR+lTFk4GctQYCNVLIXmAFDbc42xv2/yiqnnAznkYU2qgmPyTmBz826Hz630MuN8FKt/+qh5bKB86OW7M2Uj1Is985v2KHRm1NI3Y+CXUqTgM7qHqZ7UgvVX8J4akU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710582821; c=relaxed/simple;
	bh=zyve2/LxtA7qSEnDruyZc2x/q7iS+YzUMJg77Fg0TpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oUp0MhUkpz2eW+mp+HnyWT/ngdzihTF0gAxw6Yw13SsjhvgFQW2bnSRvvEdfzt2BLtgK6SOB2l2pLhQ017Yc/GnxJvISt3jzJ1SM4eHFkGa9OwkeFd+xI8lVE5INp3Pg7YphxTNxOEm84bfahZOg3X0IV0N/wSdC/IEmkNLPn8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jPUQRiCF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710582818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1H+uemX9BGv+8KG6vyG3ychhQxKj/lPn15aAXLl8yzc=;
	b=jPUQRiCFYrkDHyAwv2jEfYiOYZjlk6h8BXKhscrii33Gw7iHIqd8etQL2Qtj/xvRu4n5se
	1JpNB/lW1a1ET8IWq9e33pQRIUTTRpoNnXyuL3ffrbEwiQ+9RVd2G7S4D4UQwRq/TjTTqf
	anZ/wv/JFB5m//QrMRrG/e8HxmRoUrA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518--st0MXhQMf6kEk7VZrsTGA-1; Sat,
 16 Mar 2024 05:53:36 -0400
X-MC-Unique: -st0MXhQMf6kEk7VZrsTGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEDAC3804061;
	Sat, 16 Mar 2024 09:53:35 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C3DCE3C21;
	Sat, 16 Mar 2024 09:53:32 +0000 (UTC)
Date: Sat, 16 Mar 2024 17:53:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Message-ID: <ZfVsBE+DsBYGu5RU@fedora>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfT+CDCl+07rlRIp@fedora>
 <CAFj5m9LXFxaeVyWgPGMiJLaueXkpcLz=506Bp_mhpjKU59eEnw@mail.gmail.com>
 <6dcd9e5d-f5c7-4c05-aa48-1fab7b0072ea@gmail.com>
 <ZfUX/kSYOW6we1SB@fedora>
 <f538b6a2-3898-4028-a63c-7641f02f5bdf@gmail.com>
 <a2ae9037-d115-404e-9304-7b0959565836@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a2ae9037-d115-404e-9304-7b0959565836@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Sat, Mar 16, 2024 at 04:20:25AM +0000, Pavel Begunkov wrote:
> On 3/16/24 04:13, Pavel Begunkov wrote:
> > On 3/16/24 03:54, Ming Lei wrote:
> > > On Sat, Mar 16, 2024 at 02:54:19AM +0000, Pavel Begunkov wrote:
> > > > On 3/16/24 02:24, Ming Lei wrote:
> > > > > On Sat, Mar 16, 2024 at 10:04 AM Ming Lei <ming.lei@redhat.com> wrote:
> > > > > > 
> > > > > > On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
> > > > > > > 
> > > > > > > On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
> > > > > > > > Patch 1 is a fix.
> > > > > > > > 
> > > > > > > > Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
> > > > > > > > misundertsandings of the flags and of the tw state. It'd be great to have
> > > > > > > > even without even w/o the rest.
> > > > > > > > 
> > > > > > > > 8-11 mandate ctx locking for task_work and finally removes the CQE
> > > > > > > > caches, instead we post directly into the CQ. Note that the cache is
> > > > > > > > used by multishot auxiliary completions.
> > > > > > > > 
> > > > > > > > [...]
> > > > > > > 
> > > > > > > Applied, thanks!
> > > > > > 
> > > > > > Hi Jens and Pavel,
> > > > > > 
> > > > > > Looks this patch causes hang when running './check ublk/002' in blktests.
> > > > > 
> > > > > Not take close look, and  I guess it hangs in
> > > > > 
> > > > > io_uring_cmd_del_cancelable() -> io_ring_submit_lock
> > > > 
> > > > Thanks, the trace doesn't completely explains it, but my blind spot
> > > > was io_uring_cmd_done() potentially grabbing the mutex. They're
> > > > supposed to be irq safe mimicking io_req_task_work_add(), that's how
> > > > nvme passthrough uses it as well (but at least it doesn't need the
> > > > cancellation bits).
> > > > 
> > > > One option is to replace it with a spinlock, the other is to delay
> > > > the io_uring_cmd_del_cancelable() call to the task_work callback.
> > > > The latter would be cleaner and more preferable, but I'm lacking
> > > > context to tell if that would be correct. Ming, what do you think?
> > > 
> > > I prefer to the latter approach because the two cancelable helpers are
> > > run in fast path.
> > > 
> > > Looks all new io_uring_cmd_complete() in ublk have this issue, and the
> > > following patch should avoid them all.
> > 
> > The one I have in mind on top of the current tree would be like below.
> > Untested, and doesn't allow this cancellation thing for iopoll. I'll
> > prepare something tomorrow.
> > 
> > 
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index e45d4cd5ef82..000ba435451c 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -14,19 +14,15 @@
> >   #include "rsrc.h"
> >   #include "uring_cmd.h"
> > 
> > -static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
> > -        unsigned int issue_flags)
> > +static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd)
> >   {
> >       struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> > -    struct io_ring_ctx *ctx = req->ctx;
> > 
> >       if (!(cmd->flags & IORING_URING_CMD_CANCELABLE))
> >           return;
> > 
> >       cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
> > -    io_ring_submit_lock(ctx, issue_flags);
> >       hlist_del(&req->hash_node);
> > -    io_ring_submit_unlock(ctx, issue_flags);
> >   }
> > 
> >   /*
> > @@ -80,6 +76,15 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
> >       req->big_cqe.extra2 = extra2;
> >   }
> > 
> > +static void io_req_task_cmd_complete(struct io_kiocb *req,
> > +                     struct io_tw_state *ts)
> > +{
> > +    struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> > +
> > +    io_uring_cmd_del_cancelable(ioucmd);
> > +    io_req_task_complete(req, ts);
> > +}
> > +
> >   /*
> >    * Called by consumers of io_uring_cmd, if they originally returned
> >    * -EIOCBQUEUED upon receiving the command.
> > @@ -89,8 +94,6 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
> >   {
> >       struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> > 
> > -    io_uring_cmd_del_cancelable(ioucmd, issue_flags);
> > -
> >       if (ret < 0)
> >           req_set_fail(req);
> > 
> > @@ -105,7 +108,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
> >               return;
> 
> Not very well thought through... Here should be a *del_cancelable call
> as well

Thanks for the fix!

The patch works after adding io_uring_cmd_del_cancelable() in the branch of
`else if (issue_flags & IO_URING_F_COMPLETE_DEFER)'.


Thanks,
Ming


