Return-Path: <io-uring+bounces-1007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8943A87D8B5
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 04:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20EA1B21166
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 03:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8198D46BA;
	Sat, 16 Mar 2024 03:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I7UPAKU6"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1524C6D
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 03:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710561300; cv=none; b=nIWHYvL7CkSXZDygpZIKeb40JTr23r1wKWWlb9AO6/LowTuVESis6q05qHf3VM7tZeX3xKGK4hMUUCy7y1vs/08JH0DZk3THCHcmF/eBY8fnaU+alGT4MnV4pdfXog/+hCiIQZ+Vzt6HZfPYrROgddJtmzRieNVScy2sm+q49kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710561300; c=relaxed/simple;
	bh=Kr0tAB3ics3hhu0pRWrpEbmzeSfD6n3/pdI8EvhMoE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLwkiHhz88bbxfIUrKKQ/as3I+LHl6IRMW5CWNlCGR5WE845GWCtfCPE8NRAh9Cez53qRvGaBjyUuBjy5e3TgcTYStsWQaHHOjamnsIkGjNUFlfvLQAdRVHQzUzq+2niOW3rRw+0QGfjgZ2b9A/2eqU94mNrIGZ5izWpGolGjSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I7UPAKU6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710561296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wRMC3s1CubB2QgBCjKkzovrdGLFoFsV4TQVUa2iTXmQ=;
	b=I7UPAKU6sjQR7OAnKRdWaSfuBtGQbr5Iqnh0xESdqtnh6F9EaYdjhN2Ae5kATTcaJlcBA7
	GR+wP2OOOkMBaYx/QIkcxxf5JJ9PbSCOZzKBnXRwLLYGXDHl5ukPSjkwabwCzhFlcQfAcO
	D4qz8hd/XA92nRYTvLyktHP7QPweMv0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-v6rssEQPOFK2Vqp9D9sZnA-1; Fri, 15 Mar 2024 23:54:51 -0400
X-MC-Unique: v6rssEQPOFK2Vqp9D9sZnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5EF580F7E4;
	Sat, 16 Mar 2024 03:54:50 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C119B1C060A4;
	Sat, 16 Mar 2024 03:54:46 +0000 (UTC)
Date: Sat, 16 Mar 2024 11:54:38 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
	ming.lei@redhat.com
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Message-ID: <ZfUX/kSYOW6we1SB@fedora>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfT+CDCl+07rlRIp@fedora>
 <CAFj5m9LXFxaeVyWgPGMiJLaueXkpcLz=506Bp_mhpjKU59eEnw@mail.gmail.com>
 <6dcd9e5d-f5c7-4c05-aa48-1fab7b0072ea@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6dcd9e5d-f5c7-4c05-aa48-1fab7b0072ea@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Sat, Mar 16, 2024 at 02:54:19AM +0000, Pavel Begunkov wrote:
> On 3/16/24 02:24, Ming Lei wrote:
> > On Sat, Mar 16, 2024 at 10:04 AM Ming Lei <ming.lei@redhat.com> wrote:
> > > 
> > > On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
> > > > 
> > > > On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
> > > > > Patch 1 is a fix.
> > > > > 
> > > > > Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
> > > > > misundertsandings of the flags and of the tw state. It'd be great to have
> > > > > even without even w/o the rest.
> > > > > 
> > > > > 8-11 mandate ctx locking for task_work and finally removes the CQE
> > > > > caches, instead we post directly into the CQ. Note that the cache is
> > > > > used by multishot auxiliary completions.
> > > > > 
> > > > > [...]
> > > > 
> > > > Applied, thanks!
> > > 
> > > Hi Jens and Pavel,
> > > 
> > > Looks this patch causes hang when running './check ublk/002' in blktests.
> > 
> > Not take close look, and  I guess it hangs in
> > 
> > io_uring_cmd_del_cancelable() -> io_ring_submit_lock
> 
> Thanks, the trace doesn't completely explains it, but my blind spot
> was io_uring_cmd_done() potentially grabbing the mutex. They're
> supposed to be irq safe mimicking io_req_task_work_add(), that's how
> nvme passthrough uses it as well (but at least it doesn't need the
> cancellation bits).
> 
> One option is to replace it with a spinlock, the other is to delay
> the io_uring_cmd_del_cancelable() call to the task_work callback.
> The latter would be cleaner and more preferable, but I'm lacking
> context to tell if that would be correct. Ming, what do you think?

I prefer to the latter approach because the two cancelable helpers are
run in fast path.

Looks all new io_uring_cmd_complete() in ublk have this issue, and the
following patch should avoid them all.

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 97dceecadab2..1f54da0e655c 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1417,6 +1417,12 @@ static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
 	return true;
 }
 
+static void ublk_cancel_cmd_cb(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	io_uring_cmd_done(cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
+}
+
 static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io)
 {
 	bool done;
@@ -1431,7 +1437,7 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io)
 	spin_unlock(&ubq->cancel_lock);
 
 	if (!done)
-		io_uring_cmd_complete(io->cmd, UBLK_IO_RES_ABORT, 0);
+		io_uring_cmd_complete_in_task(io->cmd, ublk_cancel_cmd_cb);
 }
 
 /*
@@ -1775,10 +1781,9 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 	return -EIOCBQUEUED;
 
  out:
-	io_uring_cmd_complete(cmd, ret, 0);
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
 			__func__, cmd_op, tag, ret, io->flags);
-	return -EIOCBQUEUED;
+	return ret;
 }
 
 static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
@@ -2928,10 +2933,9 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (ub)
 		ublk_put_device(ub);
  out:
-	io_uring_cmd_complete(cmd, ret, 0);
 	pr_devel("%s: cmd done ret %d cmd_op %x, dev id %d qid %d\n",
 			__func__, ret, cmd->cmd_op, header->dev_id, header->queue_id);
-	return -EIOCBQUEUED;
+	return ret;
 }
 
 static const struct file_operations ublk_ctl_fops = {



Thanks,
Ming


