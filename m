Return-Path: <io-uring+bounces-5737-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E5DBA0464D
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 17:30:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9DBF3A6CF7
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 16:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534631F755D;
	Tue,  7 Jan 2025 16:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JiZ5Hbpa"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC1A1F7544
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 16:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736267282; cv=none; b=E1MHE2JTn/cC6t0Zd8qAMusPqgSfrFE1KMnJdzzQM8qf1/ZUezDmVl5eYO3gvAXekgSkyq0qr7/ox7mIKjy68cBY3v2Kk7eWKFQJB8ZYc0ksIm2XnNFnwj2WA9aoJj93k2snCxe6lEh4Zj9AdMffkBsqHgwuXIOM2JGh/+1lhAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736267282; c=relaxed/simple;
	bh=ro5SOHPGE494O8O02u5koqsBJ1Cw4yZfst2ne6UUoFY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=NeaAAxSVerc+kw0GUn4a0SKdgIibGJ7ooxJILlHSNxkujX6uX2Lxn0Fl30UolMSZNdiRazgEk5EvZxhztvZgMTqs6QeM4haMrrW8WiuvrrVQZNbmRVIHsUF8TkVAENdhDV7sumd5VgyaGWykAvO6sPkznhvXE9t4g1rOdy4rCes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JiZ5Hbpa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736267279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=HDclS/DES8DLCo0SqLfzizwQKhbxuQktc23NSw3frko=;
	b=JiZ5HbparDu+Vvhoi6CZXgo8OQtmjLMmZxLJuJ3YVmffGwL6wAp/Trb5AX4stuMmbSUHF9
	MVbSpLFMCnuDMAGPbKUHK5Rh63BeC6PLfLbfQxkk8aZAuMifPYCyitim2Lib4G2aih6O3R
	xZMb2C3f37/9PqEKXaRFXDDqtDy4WEI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-q_1yp0tVNjyYqvWtWX8FjQ-1; Tue,
 07 Jan 2025 11:27:55 -0500
X-MC-Unique: q_1yp0tVNjyYqvWtWX8FjQ-1
X-Mimecast-MFC-AGG-ID: q_1yp0tVNjyYqvWtWX8FjQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1449119560BD;
	Tue,  7 Jan 2025 16:27:54 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.23])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id EC1FF195395A;
	Tue,  7 Jan 2025 16:27:49 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  7 Jan 2025 17:27:29 +0100 (CET)
Date: Tue, 7 Jan 2025 17:27:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Manfred Spraul <manfred@colorfullife.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	WangYuli <wangyuli@uniontech.com>, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/5] poll_wait: kill the obsolete wait_address check
Message-ID: <20250107162724.GA18926@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This check is historical and no longer needed, wait_address is never NULL.
These days we rely on the poll_table->_qproc check. NULL if select/poll
is not going to sleep, or it already has a data to report, or all waiters
have already been registered after the 1st iteration.

However, poll_table *p can be NULL, see p9_fd_poll() for example, so we
can't remove the "p != NULL" check.

Link: https://lore.kernel.org/all/20250106180325.GF7233@redhat.com/
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/poll.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/poll.h b/include/linux/poll.h
index fc641b50f129..57b6d1ccd8bf 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -41,7 +41,7 @@ typedef struct poll_table_struct {
 
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
 {
-	if (p && p->_qproc && wait_address) {
+	if (p && p->_qproc) {
 		p->_qproc(filp, wait_address, p);
 		/*
 		 * This memory barrier is paired in the wq_has_sleeper().
-- 
2.25.1.362.g51ebf55


