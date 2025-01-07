Return-Path: <io-uring+bounces-5740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D0EAA0465B
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 17:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12C233A6CC7
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7261D1F4E3C;
	Tue,  7 Jan 2025 16:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SR2PUHRB"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852271F8660
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736267305; cv=none; b=GO8zVZjRwiA0RlqVpB3K3iQL9kkdpEpcTdabrIFGucK22a2Z3/e4mj29L0uuCseMdZe5HProUDxLUMjuxZwLX9+hXPnPjqcS2k8sNO4oAlyMvv3DbIXmzT54V11A/1WONBmP5e0UZWRBgLEbd8aSLRyyRj3SeTOzE4tQ3Zw0rgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736267305; c=relaxed/simple;
	bh=747ikJyTyNIg0mXhy/B6zmZu9JIIYkk8XQpmBk8Hquo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=sLGRxIGrjxMDPo/RW46c+Xipycz50MQAPMEqG1aR2EKOROVL3gERJcqvuw6Ie7lJWbj524UzbE5o3TBPBESdeLvcKrSis/QO9o9FAcCAV/6m3otzm8o0r/S2OXvElBlIw9SLo1EC01GhuZoQUzQv+ptlR4T4gFs76kfW4MmgEys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SR2PUHRB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736267299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=ggzPhdIvprjKO6zo/NvbJC2/YROGoQldUxo9aidxPIM=;
	b=SR2PUHRBsiiGw+qdZ8IlIAf/Efu4wB/CXx7pxl4zxytAEGb6o+mmis/Ln/1jxIPJW0fm2C
	4XtGv+b15kQ/LrGBja0EQ528yzX2gBMbkBUJkmrb9tiJ/uQUdgu/ZTzOktBlQOdWLBAWGF
	JBs7NvI2GUrhWONOAxOJxf4XeGWwjVI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-670-vfGwU8W8OU6n2Z7y0dIW_Q-1; Tue,
 07 Jan 2025 11:28:15 -0500
X-MC-Unique: vfGwU8W8OU6n2Z7y0dIW_Q-1
X-Mimecast-MFC-AGG-ID: vfGwU8W8OU6n2Z7y0dIW_Q
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8223619560A6;
	Tue,  7 Jan 2025 16:28:13 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.23])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id DC6A7195606C;
	Tue,  7 Jan 2025 16:28:08 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  7 Jan 2025 17:27:49 +0100 (CET)
Date: Tue, 7 Jan 2025 17:27:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Manfred Spraul <manfred@colorfullife.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	WangYuli <wangyuli@uniontech.com>, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 5/5] poll: kill poll_does_not_wait()
Message-ID: <20250107162743.GA18947@redhat.com>
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

It no longer has users.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/poll.h | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/linux/poll.h b/include/linux/poll.h
index 57b6d1ccd8bf..12bb18e8b978 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -25,14 +25,14 @@
 
 struct poll_table_struct;
 
-/* 
+/*
  * structures and helpers for f_op->poll implementations
  */
 typedef void (*poll_queue_proc)(struct file *, wait_queue_head_t *, struct poll_table_struct *);
 
 /*
- * Do not touch the structure directly, use the access functions
- * poll_does_not_wait() and poll_requested_events() instead.
+ * Do not touch the structure directly, use the access function
+ * poll_requested_events() instead.
  */
 typedef struct poll_table_struct {
 	poll_queue_proc _qproc;
@@ -53,16 +53,6 @@ static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_addres
 	}
 }
 
-/*
- * Return true if it is guaranteed that poll will not wait. This is the case
- * if the poll() of another file descriptor in the set got an event, so there
- * is no need for waiting.
- */
-static inline bool poll_does_not_wait(const poll_table *p)
-{
-	return p == NULL || p->_qproc == NULL;
-}
-
 /*
  * Return the set of events that the application wants to poll for.
  * This is useful for drivers that need to know whether a DMA transfer has
-- 
2.25.1.362.g51ebf55


