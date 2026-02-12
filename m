Return-Path: <io-uring+bounces-12180-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gKDXEc+/jWkZ6gAAu9opvQ
	(envelope-from <io-uring+bounces-12180-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 12:55:59 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC21612D336
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 12:55:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 560C7303E761
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 11:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E89634DCE2;
	Thu, 12 Feb 2026 11:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AUCM/s7K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BEF296BD2
	for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770897355; cv=none; b=bJQwJ+WNxUnnGGTCLdkHrjMjvsUYzcX9DPXKJwhVxzAc/4QgxF+zliJRCRBjm52rrhjzcg1s697hqJwEBgQvX36MvIZo14FaOBvf2FrvvEaSCPNc7YrgJ8gyVwfxJKHmzdIyuMNoJuXlch8eTdFRuAXtRiaRxvqMG2RmmbKr2lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770897355; c=relaxed/simple;
	bh=YCtOu2KV9/mCl7mKppEFkkBunz1ia1iUmnfhM1UNwIw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A72no6wl0LBs4/9QeOeOhasAg6ewjj6W66/bszaEq0+PsUDxDuONklAix9KoCmM2idHhGz1fCR8/GVUR6GLSPWW8sTZ8mZagohN/5whuFzhqQgmbOapZPtFzpamAwcAoCz2exT/W6YOPab5vqclXAJB6JGVlOJt+pgBJouDObN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AUCM/s7K; arc=none smtp.client-ip=209.85.216.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-3538952a464so772778a91.2
        for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 03:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770897354; x=1771502154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CyiHM3zBArshMUcVKv1ZlKJW//HEodrChAZzOzlZz4c=;
        b=AUCM/s7K+ZKpx8L+CzjtuVnMcIDF+7VrIZJtnHQaZ0idx71ghm4HL0FjAIKdRLyepf
         fY2LlBXZEe+oSM9rssnSX+kPsOp15GVmji4J7ApqJwG7sjRIAXf+A+RaV8dLUhz6isIG
         xf1GQDduVrMkSfh8gya0TEXSySzhxbZqVhcd7BOTQ1/nDvojJvIkucWUUj4koXvFf2QR
         XcUK724YnzOaEk19WiLMYzJUQnEMiJurb2gNE3QTBy6tez1LLdqJVO0CVfYLMpWxH4yn
         cnH/CLCDlUCp8gLYf0WajfQfIQKwUfbUIH7txfVD0k3o/NHYI5td2VDg/wACK5SDpxWa
         P9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770897354; x=1771502154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CyiHM3zBArshMUcVKv1ZlKJW//HEodrChAZzOzlZz4c=;
        b=IWyk/yijz6TA42OqgYh0W/g+tmFEdHAasE/fhV5vnwdnh6aR5o4upNSD/gEYgC9UdH
         F4KZpdkXyFWzbEUcTwfkmjhKMefFuTie05uM/AFrHVa/x30OFUkx1sY6pGPObGu7VF+3
         9eRmtga3xe0xQBoUjPKVtGes9kSgAn3pZhnmxbZhwVIPm8pBYTKCFE1gm4ZenUQSyrRD
         JsdTi0EFHYs2I0R03YMFf7VvVS23O/yIZLRqhmdBAOT7U8vWyg/NxfMaLLvjs755PqDK
         xPEvTUsw9qT4ag9vIUxERzCP8fSKpiKEetqQPRptY6Aq+TDZkcYtjK1bWwnzp7khrNBv
         NVPQ==
X-Gm-Message-State: AOJu0Yz81BsnnDr3WmFDdVzEH+4ZFW00vxsJ4WFhL2MIK2LeBggWvYfU
	QctmU+7BI0AH2UXogl7v2T4hgKn0mxCCbH8tF8KXS0WPb9aCUXtbf0k/
X-Gm-Gg: AZuq6aJ7m+Stn9riYvE6wHfiWX1bGbhgbf3wJ/6krgofRIlFzwCUiEwGB6qKCVbz3lh
	bsYCR0zkO3HUmxAZMO1lm8+9I9Ucz3t8FS4o5UM985pHITwQXBS+rx4TZcDhaIXvTwYhTWAXIZr
	Q/Dl505i+CWWKWRJpMmEPK8z56aSbpTarObSs3GGQsot/nX386uO1KWQenAYR8F9bse80v3+71j
	rJYMdEu9wrbtVxdKzU9r7lFIUo8DqrpIic3Mdtv4NzJz/35ZVkuTjRzezHd4r7ZE9kYn9q37DkP
	QW5gPt8g9SK2ELXSkjrB5Em057SIzSchhUimjET3HvuZgtSwvMkO8K+WWboGPpzqc8KgDOyu4bp
	SvydY8NJG2Hc6sMaf8NTjZNXyW2UM8LzFXhQZPdq04vdDhiMdyWr4hzSl6GN51f0YeRruLKuQtK
	B6/GHz661DF4B4LlpayX9x0HVvjWot4ciGlzV3VG3/yV5O0DKh3kXG+NinpjOcPXdQr8h57cvU7
	UduoCT4SlnoqRc=
X-Received: by 2002:a17:90b:4c12:b0:354:a57c:65ef with SMTP id 98e67ed59e1d1-3568f41081cmr1771779a91.6.1770897353698;
        Thu, 12 Feb 2026 03:55:53 -0800 (PST)
Received: from cute.. ([2405:201:31:d01f:1c4d:265b:8163:813b])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e1967c6fasm5631830a12.1.2026.02.12.03.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 03:55:53 -0800 (PST)
From: Soham Kute <officialsohamkute@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com,
	Soham Kute <officialsohamkute@gmail.com>
Subject: [PATCH] io_uring: fix list corruption race in io_pollfree_wake()
Date: Thu, 12 Feb 2026 17:24:58 +0530
Message-Id: <20260212115458.9149-1-officialsohamkute@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,syzkaller.appspotmail.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12180-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[officialsohamkute@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,ab12f0c08dd7ab8d057c];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,appspotmail.com:email]
X-Rspamd-Queue-Id: AC21612D336
X-Rspamd-Action: no action

io_pollfree_wake() removes the poll wait entry without holding
the waitqueue head lock. Other removal paths take the head lock,
so this can race and lead to list corruption detected by list_debug.

Acquire the waitqueue lock before calling io_poll_remove_waitq(),
matching the locking used in io_poll_remove_entry().

Reported-by: syzbot+ab12f0c08dd7ab8d057c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab12f0c08dd7ab8d057c
Signed-off-by: Soham Kute <officialsohamkute@gmail.com>
---
 io_uring/poll.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index aac4b3b88..006154355 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -383,10 +383,17 @@ static void io_poll_cancel_req(struct io_kiocb *req)
 
 static __cold int io_pollfree_wake(struct io_kiocb *req, struct io_poll *poll)
 {
+	struct wait_queue_head *head;
 	io_poll_mark_cancelled(req);
 	/* we have to kick tw in case it's not already */
 	io_poll_execute(req, 0);
-	io_poll_remove_waitq(poll);
+	/* Pairs with smp_store_release() in io_poll_remove_waitq() */
+	head = smp_load_acquire(&poll->head);
+	if (head) {
+		spin_lock_irq(&head->lock);
+		io_poll_remove_waitq(poll);
+		spin_unlock_irq(&head->lock);
+	}
 	return 1;
 }
 
-- 
2.34.1


