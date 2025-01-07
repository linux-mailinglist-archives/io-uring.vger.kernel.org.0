Return-Path: <io-uring+bounces-5738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3362A04644
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 17:29:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF99E1887230
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC5C1F4710;
	Tue,  7 Jan 2025 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQxbKBRi"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937211F6690
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736267290; cv=none; b=kBMIWH3aC5H04NHsSpanqLkMy6zpCIVk4V3uimx9lIqgOU2XCZlDdBcPn57mQW2hyuCkWhekOnKmhXuys65uxxxj9Nzz6kBKeU9B3RAhfM0qatfNyagJwCMtvoVhRDZOvj11nIZrXl3zusKjxkyOf8/t9NjxhxSqiweb2xYLFi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736267290; c=relaxed/simple;
	bh=8KUvX1mipGlvZnr3pyDyRpQyKInPgruNqY+hjvSMHr8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Fl/SWZjolr2/iQtiHEJzVCtw1qriKBkEJn4c7q+zumwAKDIvLY4OZ23COxn++F7ysX85UpJjyNT+CptQ5I2a2w1l53FQ9l+0kiLklDYyOTuYJFC8qsGNPJCYqTqrwOANVWHz3XXleL3wuIhDoRRUTKjy+j401mXpZvBNlE8AQLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQxbKBRi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736267287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=0Hkc/r/J05Eu+h5oxPQEivv9ALULDWls00aLQM9qKG8=;
	b=EQxbKBRiJzMNDZh2ZfOu4hDGPC3zFxDWv7XBgaH+DeuL/8iI/PabhhjozZV0n2ymoTP9tx
	EM1jsXsOW8qNmWNAHTZLL62R5jWi8q+/3A24X+U4vLtqylqJLCMy/Mx/aQex4VANoOq4o7
	9uDomzzDl/L2WFiS1AItvjh1ljW82Ek=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-PDawU3_sPHyeaIXWivLkAg-1; Tue,
 07 Jan 2025 11:28:02 -0500
X-MC-Unique: PDawU3_sPHyeaIXWivLkAg-1
X-Mimecast-MFC-AGG-ID: PDawU3_sPHyeaIXWivLkAg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 367B219560B9;
	Tue,  7 Jan 2025 16:28:00 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.23])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 197E01956088;
	Tue,  7 Jan 2025 16:27:55 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  7 Jan 2025 17:27:35 +0100 (CET)
Date: Tue, 7 Jan 2025 17:27:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Manfred Spraul <manfred@colorfullife.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	WangYuli <wangyuli@uniontech.com>, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/5] io_uring_poll: kill the no longer necessary barrier
 after poll_wait()
Message-ID: <20250107162730.GA18940@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Now that poll_wait() provides a full barrier we can remove smp_rmb() from
io_uring_poll().

In fact I don't think smp_rmb() was correct, it can't serialize LOADs and
STOREs.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 io_uring/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 06ff41484e29..a64a82b93b86 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2809,13 +2809,12 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 
 	if (unlikely(!ctx->poll_activated))
 		io_activate_pollwq(ctx);
-
-	poll_wait(file, &ctx->poll_wq, wait);
 	/*
-	 * synchronizes with barrier from wq_has_sleeper call in
-	 * io_commit_cqring
+	 * provides mb() which pairs with barrier from wq_has_sleeper
+	 * call in io_commit_cqring
 	 */
-	smp_rmb();
+	poll_wait(file, &ctx->poll_wq, wait);
+
 	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
-- 
2.25.1.362.g51ebf55


