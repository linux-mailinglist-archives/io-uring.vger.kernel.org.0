Return-Path: <io-uring+bounces-13198-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4HguGdUu9WknJQIAu9opvQ
	(envelope-from <io-uring+bounces-13198-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 00:53:09 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CF40F4B01BB
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 00:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A327301F190
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2026 22:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C3736D9F1;
	Fri,  1 May 2026 22:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sa/gNfIh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A353E36E483
	for <io-uring@vger.kernel.org>; Fri,  1 May 2026 22:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777675978; cv=none; b=GEQplcipv1khx8Ei31eJ7S5EXNlLojT9jnc+kSzTqbyYeGnOFkZTZ8kRtu9neBfkudFnL1HMwlm9VmdMe6UCipFjdc22Hk/JMJXla0ilkKK5XYZyT1IDd0dIU3FbWsX2EB9yqcARCtL3EDwYHRypZyxOP+l+8wC+x9sajEtPrww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777675978; c=relaxed/simple;
	bh=eCti1xRsMGpyyZrSZkycdAP+G/8UNY44EFUBVRuS/ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar/QNmeehb2YTQlO2ZztmzGQ4t6jEtjee381fMiBYJGE8b7HQBJpLa6O3p28q4fNWsJdGZyJnd/FYllcvDX48sp6+bB5WXwWZsUKwKDKgdFhpSIeRh4hplPA4ERGg+tNfo5Ne9SGLoj3YYqIxKNXTxWDOk/WPVDkudc/rDlRRgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sa/gNfIh; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488af9fdaa7so12382305e9.1
        for <io-uring@vger.kernel.org>; Fri, 01 May 2026 15:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777675975; x=1778280775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oStFlhcdakP6edPipTY7ZxFrfWf7cQBJS3cGZ4Djgkk=;
        b=sa/gNfIhGoU7vNrOsyd6p86c5Hd7D5Pu7SL4q1AoqoNcaRmEPQCdjihlKf/ODIY2Eo
         aLGDkIR9jtEJzoYhAA5iPhc03QQk1UKM21N01c8ZJL+/ncLDz5JnB9IEcLE6hYxxbUzn
         H+JtSFWcveQRf5ww5dZaN14lc2x4u70WlzsB9lYjJuBAuQGAv4a/yDmTT1Ur5bQmeE/u
         cD5T78CpdMjvekrwOEE4fEWqFTwWJspRV2ZM9OFGtkRPR7MCl9UaMhJzxtox2BkzzQkS
         BXmj4Tl4S8NaA5pc0j8FCMTyEq4wJTF97/oZ3L/WBJ9dtNWej7YqIK6uVJyHlWrzkeKe
         HtOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777675975; x=1778280775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oStFlhcdakP6edPipTY7ZxFrfWf7cQBJS3cGZ4Djgkk=;
        b=aFk/EeSW4WhiNBSWNREDxldcc2O5WghPXl3sUwGpUDqYEROQFyJQuaByoB2KfqxJFL
         2rJ9UM3vX00UPobL0SiQu2sSzTA9EqJT9tSd6iiuPY4MEGma/+erMG0bU74ytxFX/QvO
         CkgbOA66rrpm9rY5uJay6MqDYYiFiTwy3iMZuTfnH+6DFaohmIfwaWEbSVo+HctaVA/A
         w+p9WEYerGX1ky2aePmnqCMd1PY0KiugwBMCATIyZMOdtQmWTQ7rU8kRRFvEIV8TjDjg
         C99zk8PYZRH7N2kOPvr6C/DdCATdbq0Gj8hzkzi1xnLA6QAgmtNhd/hOFEbpVgo3H24M
         SfNg==
X-Forwarded-Encrypted: i=1; AFNElJ+fvXffXz4ey6tzczWp8HKDxpqo5HgUpgaTCTs1+nWeFni4/R3WwEuqnb1DDXK+XNRYr+mSMisa3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzA5v90H9sACf25DFJzAWRzq7lgj6Pr2oL6iBlS4sP2+N7bEWJ2
	ZNRzuwPN5bX/R9V++b7iEe9O7+2G3olZpwg9VGDhM0OelnEMdn1vYiJ/5mpMdcpD
X-Gm-Gg: AeBDieviUNSvg7XYAjFHgbFwW6S7ybRbmVSeg3OSdQ7104My9Za5Blrj3ipdw46+Ab2
	7qtlFWPsSBFk1gS3g0XQkQBtQugQ/pKmcodTcGRsAV29Hh3c2MThIZ2a9iZPyaCr2fvGRM36weE
	sTxfCzE6ssnH/Tls+7ki48938DCZb8O7NEG8BPr+N+ACzLmPPo4W+8U6z7D3h7B+apIm3RBa+Zd
	JnW/B6SNrH9+QHWi+lrKTL/mssIwh7EB/4l+ZaXhKAALudeGkWa3tLPY081NrvTrmBKs8taZnUK
	ojAAULCz8zIF1REdem8pVVmXdyeSxlq/lWN5dhDbe5HcTWtxITGe5YMBu3g4t4XDDwNQZvJvfwc
	jbetwyYJr/8epi1KBdi4pBxK5eZtLChBrMW0C+pgLu9CgJpcqQB/qf0FkwSuj4cnaU/BCP0MiPe
	/5/UyIilMBuyHj38dlksQ/vKWdKu5/p0Y+JNd5oOTRmrPlkWGYiB9wrKr8aBqJ9BR8fN9y5M6Bi
	iIgBBINrpPpCONOyd0tdDvCkw==
X-Received: by 2002:a05:600c:800f:b0:488:ffb1:494c with SMTP id 5b1f17b1804b1-48a9863a372mr14640435e9.12.1777675975040;
        Fri, 01 May 2026 15:52:55 -0700 (PDT)
Received: from localhost.localdomain ([77.124.36.154])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fe93266sm23857045e9.3.2026.05.01.15.52.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 01 May 2026 15:52:54 -0700 (PDT)
From: Kai Aizen <kai.aizen.dev@gmail.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	axboe@kernel.dk,
	io-uring@vger.kernel.org
Subject: [PATCH 6.1.y] io_uring/poll: fix multishot recv missing EOF on wakeup race
Date: Sat,  2 May 2026 01:51:56 +0300
Message-ID: <20260501225250.90152-3-kai.aizen.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501225250.90152-1-kai.aizen.dev@gmail.com>
References: <20260501225250.90152-1-kai.aizen.dev@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CF40F4B01BB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13198-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kaiaizendev@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:email]

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a68ed2df72131447d131531a08fe4dfcf4fa4653 ]

When a socket send and shutdown() happen back-to-back, both fire
wake-ups before the receiver's task_work has a chance to run. The first
wake gets poll ownership (poll_refs=1), and the second bumps it to 2.
When io_poll_check_events() runs, it calls io_poll_issue() which does a
recv that reads the data and returns IOU_RETRY. The loop then drains all
accumulated refs (atomic_sub_return(2) -> 0) and exits, even though only
the first event was consumed. Since the shutdown is a persistent state
change, no further wakeups will happen, and the multishot recv can hang
forever.

Check specifically for HUP in the poll loop, and ensure that another
loop is done to check for status if more than a single poll activation
is pending. This ensures we don't lose the shutdown event.

Backport notes for linux-6.1.y:
  - In 6.1.y the do-while masks v in the while-condition itself, so
    v can carry IO_POLL_RETRY_FLAG/IO_POLL_CANCEL_FLAG bits when we
    reach the multishot branch.  The HUP check therefore compares
    `(v & IO_POLL_REF_MASK) != 1` rather than the upstream `v != 1`.
  - io_poll_issue takes `bool *locked` here (renamed to `ts` in 6.6+).
  - 6.1.y has no IOU_REQUEUE return path; only IOU_STOP_MULTISHOT.

CVE: CVE-2026-23473
Cc: stable@vger.kernel.org # 6.1.y
Fixes: dbc2564cfe0f ("io_uring: let fast poll support multishot")
Reported-by: Francis Brosseau <francis@malagauche.com>
Link: https://github.com/axboe/liburing/issues/1549
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[backport for linux-6.1.y, verified 2026-05-01]
---
 io_uring/poll.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -303,7 +303,13 @@ static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
 		} else {
-			int ret = io_poll_issue(req, locked);
+			int ret;
+
+			/* multiple refs and HUP, ensure we loop once more */
+			if ((req->cqe.res & (POLLHUP | POLLRDHUP)) &&
+			    (v & IO_POLL_REF_MASK) != 1)
+				v--;
+			ret = io_poll_issue(req, locked);
 			io_kbuf_recycle(req, 0);

 			if (ret == IOU_STOP_MULTISHOT)
--
2.43.0


