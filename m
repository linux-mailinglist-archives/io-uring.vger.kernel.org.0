Return-Path: <io-uring+bounces-1109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 852B787EB2B
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 15:40:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0580B217B2
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 14:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47D71E48A;
	Mon, 18 Mar 2024 14:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TZyT7g84"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499D71E896
	for <io-uring@vger.kernel.org>; Mon, 18 Mar 2024 14:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710772804; cv=none; b=a0Ry1h7IA5q4WOHJ+icjLO4NfwyziU+6Dh83d5SHm3NCNJjuHh87rNi0XbJRFDc4i1ch8O5mfPfaFRyLFe9P9v1B/+w8GGgnB4nCsW+BGvJiAf8I0xyxaCeUKCdTZQm6ZUxcHKabqQEaW7vZPfSMfddanQBvfKHteaWt6O7+W5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710772804; c=relaxed/simple;
	bh=mDb4fKjuX1xZ4RuUReBdzrB45DUXByBKBIZZ+nG/0t8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXoXtxEqNsXpRLPjria0UiyF+ybH9ofsV39b9QN/0sIGp8RZnqgR4vlbuJ0ykSvwgrWT+6RNtnB74PEjXhI8mAB0CgriO2MJIYAxnvg/0BnG4FYF/O1IObSVPl7OeroiUvM2Rf5t2Xp9JwzJPYvTTmhh9LFb2s5LAipYrRNGSUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TZyT7g84; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710772802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gA+MIz9ZKVSW6ey9YkrgV5BYJeuSIfMh0t2b+VLIzPs=;
	b=TZyT7g84mM7Dk6RpGF2rw0GIdTIPirjjvCGxiGUCXigLlim1B9au+7oGMC8bnv4yAcb535
	PsG69Ugen+I4MteIMmwv+545E8yNzkQENGw2btBx6Yov8zRskvRZu2UxYICTZtpIBEb252
	wEmmXiwPKTMF+oDvKM1yUm9Do8rAs3U=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-3Ae3EurMMreViBA-jFmHAw-1; Mon,
 18 Mar 2024 10:39:59 -0400
X-MC-Unique: 3Ae3EurMMreViBA-jFmHAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 863E529AC036;
	Mon, 18 Mar 2024 14:39:58 +0000 (UTC)
Received: from fedora (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 075103C22;
	Mon, 18 Mar 2024 14:39:54 +0000 (UTC)
Date: Mon, 18 Mar 2024 22:39:30 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v2 05/14] ublk: don't hard code IO_URING_F_UNLOCKED
Message-ID: <ZfhSIt/4w+z6/5U2@fedora>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <a3928d3de14d2569efc2edd7fb654a4795ae7f86.1710720150.git.asml.silence@gmail.com>
 <Zff4ShMEcL1WKZ1Q@fedora>
 <61b29658-e6a9-449f-a850-1881af1ecbee@gmail.com>
 <2095ac3e-5e5f-4ea2-a906-a924a25c121a@gmail.com>
 <8bf6d549-cf66-4412-bebd-fd6e98166552@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bf6d549-cf66-4412-bebd-fd6e98166552@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Mon, Mar 18, 2024 at 02:32:16PM +0000, Pavel Begunkov wrote:
> On 3/18/24 13:37, Pavel Begunkov wrote:
> > On 3/18/24 12:52, Pavel Begunkov wrote:
> > > On 3/18/24 08:16, Ming Lei wrote:
> > > > On Mon, Mar 18, 2024 at 12:41:50AM +0000, Pavel Begunkov wrote:
> > > > > uring_cmd implementations should not try to guess issue_flags, just use
> > > > > a newly added io_uring_cmd_complete(). We're loosing an optimisation in
> > > > > the cancellation path in ublk_uring_cmd_cancel_fn(), but the assumption
> > > > > is that we don't care that much about it.
> > > > > 
> > > > > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > > > > Link: https://lore.kernel.org/r/2f7bc9fbc98b11412d10b8fd88e58e35614e3147.1710514702.git.asml.silence@gmail.com
> > > > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > > > ---
> > > > >   drivers/block/ublk_drv.c | 18 ++++++++----------
> > > > >   1 file changed, 8 insertions(+), 10 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> > > > > index bea3d5cf8a83..97dceecadab2 100644
> > > > > --- a/drivers/block/ublk_drv.c
> > > > > +++ b/drivers/block/ublk_drv.c
> > > > > @@ -1417,8 +1417,7 @@ static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
> > > > >       return true;
> > > > >   }
> > > > > -static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
> > > > > -        unsigned int issue_flags)
> > > > > +static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io)
> > > > >   {
> > > > >       bool done;
> > > > > @@ -1432,15 +1431,14 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
> > > > >       spin_unlock(&ubq->cancel_lock);
> > > > >       if (!done)
> > > > > -        io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
> > > > > +        io_uring_cmd_complete(io->cmd, UBLK_IO_RES_ABORT, 0);
> > > > >   }
> > > > >   /*
> > > > >    * The ublk char device won't be closed when calling cancel fn, so both
> > > > >    * ublk device and queue are guaranteed to be live
> > > > >    */
> > > > > -static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
> > > > > -        unsigned int issue_flags)
> > > > > +static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd)
> > > > >   {
> > > > >       struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
> > > > >       struct ublk_queue *ubq = pdu->ubq;
> > > > > @@ -1464,7 +1462,7 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
> > > > >       io = &ubq->ios[pdu->tag];
> > > > >       WARN_ON_ONCE(io->cmd != cmd);
> > > > > -    ublk_cancel_cmd(ubq, io, issue_flags);
> > > > > +    ublk_cancel_cmd(ubq, io);
> > > > 
> > > > .cancel_fn is always called with .uring_lock held, so this 'issue_flags' can't
> > > > be removed, otherwise double task run is caused because .cancel_fn
> > > > can be called multiple times if the request stays in ctx->cancelable_uring_cmd.
> > > 
> > > I see, that's exactly why I was asking whether it can be deferred
> > > to tw. Let me see if I can get by without that patch, but honestly
> > > it's a horrible abuse of the ring state. Any ideas how that can be
> > > cleaned up?
> > 
> > I assume io_uring_try_cancel_uring_cmd() can run in parallel with
> > completions, so there can be two parallel calls calls to ->uring_cmd
> > (e.g. io-wq + cancel), which gives me shivers. Also, I'd rather
> > no cancel in place requests of another task, io_submit_flush_completions()
> > but it complicates things.
> 
> I'm wrong though on flush_completions, the task there cancels only
> its own requests
> 
> io_uring_try_cancel_uring_cmd() {
> 	...
> 	if (!cancel_all && req->task != task)
> 		continue;
> }
> 
> 
> > Is there any argument against removing requests from the cancellation
> > list in io_uring_try_cancel_uring_cmd() before calling ->uring_cmd?
> > 
> > io_uring_try_cancel_uring_cmd() {
> >      lock();
> >      for_each_req() {
> >          remove_req_from_cancel_list(req);
> >          req->file->uring_cmd();
> >      }
> >      unlock();

Also the req may not be ready to cancel in ->uring_cmd(), so it
should be allowed to retry in future if it isn't canceled this time.


Thanks,
Ming


