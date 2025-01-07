Return-Path: <io-uring+bounces-5739-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A906FA04648
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 17:30:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C043F166041
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EEB1F4737;
	Tue,  7 Jan 2025 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LdCvTKl2"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C4F1F76DE
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 16:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736267298; cv=none; b=KIRxTQdwfr1fcp5OlhQ8RkY7YRxilLcYBU4uIR3LHJ0+EVlo4e0IIg276qGQc2afvUnXHbr2iZn3sHMkoWZVktWY8rkvrWiPCUdGgXZaufpknE4CGVXuwHw0S3tV0/pOFNnf/5esZljeY8kpsQxv+kRzsIIkB9u6C2FrDO+rOIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736267298; c=relaxed/simple;
	bh=D78ycDc0GJSDzjMxkMcR0mWhHo7fjIfKpgWtS/LY+8M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=WKd/SwBoAuZn2Z4v81RcmcgEE1looGGpCN73q8uYOZBeBQ1JBJGKOqZ4zBwzUHVNzSstodTq3tmLmWDm8GgKRQFcgIraPqKaLAuQzRBDFiC3/B5NDjpApLtzMLXpszKtu29E03kd2lgwQngPpYy6k7gxTJr5Y6ZX2p9DEIMr1G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LdCvTKl2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736267294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=tqnBBbQoUY3GF4Dg2U11xguk1LdJlHU1RyqHwXPwrJE=;
	b=LdCvTKl2IHPLc4iyNqlVklemMIr7TpSqRxMJYHv9wFwJOdAQskmfx3muX7J5vSe9gykITP
	PS6vsmmrNIQTfAmTVTmRD2E8dtk4BopMzIB18qNI61W2VO42sv7rZ1jEiHYLnNmWozqpjW
	ykObZgEW+0uzGmPWpPyFaySPFOTWwrE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-l6jgmbfNP5Cnuudsv6Q33Q-1; Tue,
 07 Jan 2025 11:28:09 -0500
X-MC-Unique: l6jgmbfNP5Cnuudsv6Q33Q-1
X-Mimecast-MFC-AGG-ID: l6jgmbfNP5Cnuudsv6Q33Q
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B471B1955E9F;
	Tue,  7 Jan 2025 16:28:06 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.23])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3E3881956088;
	Tue,  7 Jan 2025 16:28:01 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  7 Jan 2025 17:27:42 +0100 (CET)
Date: Tue, 7 Jan 2025 17:27:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Manfred Spraul <manfred@colorfullife.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	WangYuli <wangyuli@uniontech.com>, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 4/5] sock_poll_wait: kill the no longer necessary barrier
 after poll_wait()
Message-ID: <20250107162736.GA18944@redhat.com>
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

Now that poll_wait() provides a full barrier we can remove smp_mb() from
sock_poll_wait().

Also, the poll_does_not_wait() check before poll_wait() just adds the
unnecessary confusion, kill it. poll_wait() does the same "p && p->_qproc"
check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/net/sock.h | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 7464e9f9f47c..305f3ae5edc2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2291,7 +2291,7 @@ static inline bool skwq_has_sleeper(struct socket_wq *wq)
 }
 
 /**
- * sock_poll_wait - place memory barrier behind the poll_wait call.
+ * sock_poll_wait - wrapper for the poll_wait call.
  * @filp:           file
  * @sock:           socket to wait on
  * @p:              poll_table
@@ -2301,15 +2301,12 @@ static inline bool skwq_has_sleeper(struct socket_wq *wq)
 static inline void sock_poll_wait(struct file *filp, struct socket *sock,
 				  poll_table *p)
 {
-	if (!poll_does_not_wait(p)) {
-		poll_wait(filp, &sock->wq.wait, p);
-		/* We need to be sure we are in sync with the
-		 * socket flags modification.
-		 *
-		 * This memory barrier is paired in the wq_has_sleeper.
-		 */
-		smp_mb();
-	}
+	/* Provides a barrier we need to be sure we are in sync
+	 * with the socket flags modification.
+	 *
+	 * This memory barrier is paired in the wq_has_sleeper.
+	 */
+	poll_wait(filp, &sock->wq.wait, p);
 }
 
 static inline void skb_set_hash_from_sk(struct sk_buff *skb, struct sock *sk)
-- 
2.25.1.362.g51ebf55


