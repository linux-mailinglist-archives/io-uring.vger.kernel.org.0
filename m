Return-Path: <io-uring+bounces-5735-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0327EA0463C
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 17:29:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 719583A50C7
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB51F1F63C6;
	Tue,  7 Jan 2025 16:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NVIBZWES"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51621F4E51
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736267251; cv=none; b=W2JsMh+THjPClW66a8kl4lz82qp4PM/px+2fFnGlXiUs8ekVzxAy4vKdcoPo1HmhAkoolikZQG9XukVCrjaqdGrKNFCgcgefSnILL9zz079mQyKDEZHpvM4V0T9lulpRUi0ZEKlPiC5B304wpJDwdy338Qa9MfTjbAuWLrK3HY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736267251; c=relaxed/simple;
	bh=yGuRD7QZk6cYtj4E9Vk0EzX46qN+zYWmpGqZmS/1I5s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LXTLMmL4b/BQig9elldRU7/PwDxitc+NNpsDHrh8jWk2qOtnE6REp8kxFs2OyVtIYukOjvXprk2iumC2wKA/du9LJ0NL0vqXSSzxmaFnTMhX4fdCzMwDH2mpNa3tPocJbKUTOYClh3+iz2wRkUPl2HdT+9/qI2PsLePb+kXMZWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NVIBZWES; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736267247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=yysKQ0vVyHHixdI3EvvINEv3gtl53bkWe5u1MGCf7qg=;
	b=NVIBZWESnoMAQw0PQDbfrSnF9BptMa6UcaW6IuSGQ6L4LR7IJK5n8yF/YU5vsZWtfdYhG+
	6Athyf9AHbFYMwMFkbjl2suGKJNEcyWpIZn1AjFf8fMtlM1FkmgGNLXF7EVWenATegvEVL
	WAnjNaXttLJuQCK0uTAiZbvBMy0RoNA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-tD2jZvbsMu-YwFIpvXlP_Q-1; Tue,
 07 Jan 2025 11:27:23 -0500
X-MC-Unique: tD2jZvbsMu-YwFIpvXlP_Q-1
X-Mimecast-MFC-AGG-ID: tD2jZvbsMu-YwFIpvXlP_Q
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 308F21955F69;
	Tue,  7 Jan 2025 16:27:20 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.23])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 099C2195606C;
	Tue,  7 Jan 2025 16:27:14 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  7 Jan 2025 17:26:55 +0100 (CET)
Date: Tue, 7 Jan 2025 17:26:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Manfred Spraul <manfred@colorfullife.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	WangYuli <wangyuli@uniontech.com>, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/5] poll_wait: add mb() to fix theoretical race between
 waitqueue_active() and .poll()
Message-ID: <20250107162649.GA18886@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Linus,

I misread fs/eventpoll.c, it has the same problem. And more __pollwait()-like
functions, for example p9_pollwait(). So 1/5 adds mb() into poll_wait(), not
into __pollwait().

WangYuli, after 1/5 we can reconsider your patch.

Oleg.
---

 include/linux/poll.h | 26 ++++++++++++--------------
 include/net/sock.h   | 17 +++++++----------
 io_uring/io_uring.c  |  9 ++++-----
 3 files changed, 23 insertions(+), 29 deletions(-)


