Return-Path: <io-uring+bounces-5736-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3F84A04647
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 17:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37E613A705B
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01FD41F7089;
	Tue,  7 Jan 2025 16:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RoHZlS6P"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBD31F7090
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736267278; cv=none; b=pJ/eVMoKt0gsXsLxNDdWwr3107CK7n+pt36CRKHI9zMEjLHCy1Ho20PtDL3UqBkEexGUPRmG/sZMieVcKOU7v4L/WBE4GPhBfqgoBihyTevx4YAAHNVUrFKAmoKiBfOqlKYyUGwrcAHvj9nyiEzHkOWHdgHjj8nboP6si8FB4E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736267278; c=relaxed/simple;
	bh=dmHj3dmkOxAQoBGRaUgSFco2HaCv1Up75FAsMyu9T+c=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=gJrS0TEqH+/nrdQQL3aycCYUiEfensKooClvBYqEBl9bm8VzOsw0M8ccwAyWmVAq0RJkdZ1sF3JWMPN96DX2/i2/NHFdmUE2y1DR6gCokPQqadks1C6nFY5pb8pKb2xmHuQMGq2fLIv56+ehr3EFcNRIWxkd7aXsNV9NpFRTEEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RoHZlS6P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736267275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=ZbRXxXmg9OkxN0j4zEVJR2Rc1pGGwym27qVLcHNh0nE=;
	b=RoHZlS6PgRelKbqHf6bKkdMxkQcWxUuAg2E5NDwU+idHJv7vzU3OBfoPm+IhnVVoLTIQuf
	gYCQH/+BbaU8Ll2gBH0Do4ilUuUZTQyH0PJJQ25bVBt7TWbEUeKiEX05qKli70mfxwVtXY
	8QoymElOjsAKdE8NlolA1HlKZGdK01s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-jKm-_prrN7WFvwE98lj3oQ-1; Tue,
 07 Jan 2025 11:27:49 -0500
X-MC-Unique: jKm-_prrN7WFvwE98lj3oQ-1
X-Mimecast-MFC-AGG-ID: jKm-_prrN7WFvwE98lj3oQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC54C1955E84;
	Tue,  7 Jan 2025 16:27:47 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.23])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 4A700195606B;
	Tue,  7 Jan 2025 16:27:42 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  7 Jan 2025 17:27:23 +0100 (CET)
Date: Tue, 7 Jan 2025 17:27:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Manfred Spraul <manfred@colorfullife.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	WangYuli <wangyuli@uniontech.com>, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/5] poll_wait: add mb() to fix theoretical race between
 waitqueue_active() and .poll()
Message-ID: <20250107162717.GA18922@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107162649.GA18886@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

As the comment above waitqueue_active() explains, it can only be used
if both waker and waiter have mb()'s that pair with each other. However
__pollwait() is broken in this respect.

This is not pipe-specific, but let's look at pipe_poll() for example:

	poll_wait(...); // -> __pollwait() -> add_wait_queue()

	LOAD(pipe->head);
	LOAD(pipe->head);

In theory these LOAD()'s can leak into the critical section inside
add_wait_queue() and can happen before list_add(entry, wq_head), in this
case pipe_poll() can race with wakeup_pipe_readers/writers which do

	smp_mb();
	if (waitqueue_active(wq_head))
		wake_up_interruptible(wq_head);

There are more __pollwait()-like functions (grep init_poll_funcptr), and
it seems that at least ep_ptable_queue_proc() has the same problem, so the
patch adds smp_mb() into poll_wait().

Link: https://lore.kernel.org/all/20250102163320.GA17691@redhat.com/
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/poll.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/poll.h b/include/linux/poll.h
index d1ea4f3714a8..fc641b50f129 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -41,8 +41,16 @@ typedef struct poll_table_struct {
 
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
 {
-	if (p && p->_qproc && wait_address)
+	if (p && p->_qproc && wait_address) {
 		p->_qproc(filp, wait_address, p);
+		/*
+		 * This memory barrier is paired in the wq_has_sleeper().
+		 * See the comment above prepare_to_wait(), we need to
+		 * ensure that subsequent tests in this thread can't be
+		 * reordered with __add_wait_queue() in _qproc() paths.
+		 */
+		smp_mb();
+	}
 }
 
 /*
-- 
2.25.1.362.g51ebf55


