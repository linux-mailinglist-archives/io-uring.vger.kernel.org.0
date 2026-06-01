Return-Path: <io-uring+bounces-13585-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 41VaEyG4HWoBdQkAu9opvQ
	(envelope-from <io-uring+bounces-13585-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 18:49:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AE1E9622CC7
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 18:49:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E223930422C7
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2026 16:45:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA33B2FDC27;
	Mon,  1 Jun 2026 16:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZDQ47hxT"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C5A310779
	for <io-uring@vger.kernel.org>; Mon,  1 Jun 2026 16:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780332337; cv=none; b=j0fETKtnLnwvM3HLEcwTokMPfsREZ7FjOXZ26tuA+rBYAQQft9ygHQLp4LNSHUXs2NI8M8XeMEFghiZI6yP/QEeJXZB1szPg3D7/NlHTaVuprFupPO7JoU8zyvN6VjYpShX8ZJrk3t7g78RpHkvYbXEpWrKWNog8XIn5j7XQbkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780332337; c=relaxed/simple;
	bh=MF6qNHFbYG0C3TPC4SLnlZR31Em3ARNjtO+1WJk4XdU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=l5h5NRJzdhYpZsb99u6GgIMBf2lj+xDTOY7uvnX46AtSktrMFhUMGvO81Ct7z0YccJJ1ol7pBO/cROXpfgoayb0i/9NHS4TMmlrXD/JZBqAtIfxV6XfdsThXD0HjIVJMoe2qHJ6SP0xtYxDRjBqTuFMAMJkKZ5jc1c4cpepM8jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZDQ47hxT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780332334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H7maQD8iDNCQoNvXdje5uwRzgUR/4Wrx5agSx6b7VYg=;
	b=ZDQ47hxT05HdjHupnU9McE9qoLivYGqOZISjWkRFgD8wcPjI8iDPFNV+PplEd9JOmuJhbv
	IqfOJ4b2g2q5PBAoE0/aDI2JX0ARZj9CSuFSZ+4tjBTdVxusYibxDyTC7h9nijw4O+VpfX
	3LYqzUriY4+FsiyTkHlvhTQmnqXMGkM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-Il7x4OeTPBumbYWOrsOLWw-1; Mon,
 01 Jun 2026 12:45:31 -0400
X-MC-Unique: Il7x4OeTPBumbYWOrsOLWw-1
X-Mimecast-MFC-AGG-ID: Il7x4OeTPBumbYWOrsOLWw_1780332330
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E115E1956080;
	Mon,  1 Jun 2026 16:45:29 +0000 (UTC)
Received: from [10.44.49.105] (unknown [10.44.49.105])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C234F1800352;
	Mon,  1 Jun 2026 16:45:27 +0000 (UTC)
Date: Mon, 1 Jun 2026 18:45:21 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Fengnan <changfengnan@bytedance.com>
cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org, 
    agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH RESEND] dm: limit target bio polling to one shot
In-Reply-To: <c37f0749-1ae9-48ca-b402-38a552767b12@bytedance.com>
Message-ID: <eec40ac4-3d39-8d8f-b32f-9f2eaa826531@redhat.com>
References: <20260513091349.2194-1-changfengnan@bytedance.com> <c37f0749-1ae9-48ca-b402-38a552767b12@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811712-651475170-1780332329=:1690835"
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	CTYPE_MIXED_BOGUS(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13585-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,vger.kernel.org,redhat.com,kernel.org,lists.linux.dev];
	MIME_TRACE(0.00)[0:+,1:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpatocka@redhat.com,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: AE1E9622CC7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811712-651475170-1780332329=:1690835
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 28 May 2026, Fengnan wrote:

> ping..

Hi

I already staged this patch in the linux-dm repository.

Mikulas

> 在 2026/5/13 17:13, Fengnan Chang 写道:
> > dm_poll_bio() is the ->poll_bio() callback for a stacked dm device.
> > The caller only knows about the dm queue, so it may decide to do a
> > spinning poll if it thinks a single queue is being polled. Passing those
> > flags unchanged to the mapped clone lets blk_mq_poll() spin on a target
> > queue from inside dm_poll_bio().
> >
> > With io_uring IOPOLL on a dm-stripe target this can keep a task in
> >
> >    dm_poll_bio() -> bio_poll() -> blk_mq_poll()
> >
> > long enough to trigger an RCU CPU stall, before io_uring gets back to
> > io_iopoll_check() and its need_resched() check.
> >
> > Keep dm's ->poll_bio() bounded by forcing one-shot polling for target
> > bios. The caller can invoke dm_poll_bio() again if it wants to keep
> > polling, and it also gets a chance to reap completions or reschedule
> > between passes.
> >
> > Fixes: f22ecf9c14c1 ("blk-mq: delete task running check in blk_hctx_poll()")
> > Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> > ---
> >   drivers/md/dm.c | 13 +++++++++++--
> >   1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index e178fe19973ea..8f44fbbcf3da2 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -2098,8 +2098,17 @@ static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
> >   	WARN_ON_ONCE(!dm_tio_is_normal(&io->tio));
> >   
> >   	/* don't poll if the mapped io is done */
> > -	if (atomic_read(&io->io_count) > 1)
> > -		bio_poll(&io->tio.clone, iob, flags);
> > +	if (atomic_read(&io->io_count) > 1) {
> > +		/*
> > +		 * DM hides the target queues from the upper poller, which may
> > +		 * decide it is safe to spin on a single stacked queue.  Do not
> > +		 * pass that spinning policy down to a target queue: one slow
> > +		 * clone could keep the task inside dm_poll_bio() for a long
> > +		 * time.  Poll target bios once and let the caller decide
> > +		 * whether to keep polling, reap completions or reschedule.
> > +		 */
> > +		bio_poll(&io->tio.clone, iob, flags | BLK_POLL_ONESHOT);
> > +	}
> >   
> >   	/* bio_poll holds the last reference */
> >   	return atomic_read(&io->io_count) == 1;
> 
---1463811712-651475170-1780332329=:1690835--


