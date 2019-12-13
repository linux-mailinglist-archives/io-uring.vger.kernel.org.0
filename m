Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70CD11E287
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 12:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLMLJw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 06:09:52 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34967 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfLMLJw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 06:09:52 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so1416508pgk.2
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2019 03:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k5/Ud5RgNgyiqZoWMSmF8/h0WmxNGA2PIyKDbeocPxA=;
        b=t0EBKV44xmjP/LLBpWuOOtXpm5KFssGsZescbwXlMM4iuCslR+//ggbr1d6JwzpiF1
         hi5VfmgKED7BIACg0Rfh0439T7Z6NETnZgKPxAX3SRJRwaPC0AlU8eFsmijILD23+arY
         I6RiIaEtJGpRxjZWqiwW5vajONQIK5JrqOKpfUlIklWWqShF+WyS7fZSM7X6wOJdVHFA
         RigSCs4yTSnZXUPME65tGjR043pR8KKsknSp5kLGc+fMmqayx7toTn9cFlxeJsj0PgIP
         VRI16avT/54gBk0/SbfiEajcDx3MNbVvdhXoZEPZ6vLNc8kW14DBdkgHatUwR0zPL2T+
         F4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k5/Ud5RgNgyiqZoWMSmF8/h0WmxNGA2PIyKDbeocPxA=;
        b=ENZQpNBEbfd4ATRdGVwwEH5ImSdiCXXbWRd1TXzlVwoByio2tYU55wS6g8KxNEpcs9
         g5oVrGcjo9jeJ0Q3IIDHlvt1WHVlp9mgviYuhRJ+qtdNTS770zif6oBUW3len8iYmlxF
         NQetfHhoDAZEqp6zU2fLf6CZi5NfAYHFYUaW+l6AJNuzroNrsZ2+9FS133yuJpzCb2Nw
         fBOtIrtG0Bk9tiseuma6kS2bEF3Y3SGeI53C299bzm6VXYYMZ94zUhlD8ZJMjDYXSC1I
         eAoeMeq8yBmqf94AgnPteCQY/CuDsKkGxLKxCt3YKh7w9jxkAqeHu5CdEHl/UKM0IgNd
         OUzw==
X-Gm-Message-State: APjAAAVF7jcKw+fQiXE+SY/thJiqUa87SmeLcYwvwn0GDarfTKirmhMx
        0J9NleZ0uqssQuyohfzJCAtv6oPNg4c=
X-Google-Smtp-Source: APXvYqxyZ5eh2gqo7/IFAkq2IAwBr5H6A9OpaU1j1iBzLCQ3+tDFt8UFL0wlEkgGmHeVT79OhxNuNQ==
X-Received: by 2002:a63:5056:: with SMTP id q22mr15989204pgl.20.1576235390972;
        Fri, 13 Dec 2019 03:09:50 -0800 (PST)
Received: from nuc.home (c-24-143-123-17.customer.broadstripe.net. [24.143.123.17])
        by smtp.gmail.com with ESMTPSA id d22sm10399370pgg.52.2019.12.13.03.09.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 03:09:50 -0800 (PST)
From:   Brian Gianforcaro <b.gianfo@gmail.com>
To:     io-uring@vger.kernel.org
Subject: [PATCH] io_uring: Fix stale comment and a few typos.
Date:   Fri, 13 Dec 2019 03:09:50 -0800
Message-Id: <20191213110950.124702-1-b.gianfo@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

- Fix a few typos found while reading the code.

- Fix stale io_get_sqring comment referencing s->sqe,
  the 's' parameter was renamed to 'req', but the
  comment still holds.

Signed-off-by: Brian Gianforcaro <b.gianfo@gmail.com>
---
 fs/io-wq.c    | 2 +-
 fs/io_uring.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 74b40506c5d9..e6b2cd5a709c 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -934,7 +934,7 @@ static enum io_wq_cancel io_wqe_cancel_work(struct io_wqe *wqe,
 	/*
 	 * Now check if a free (going busy) or busy worker has the work
 	 * currently running. If we find it there, we'll return CANCEL_RUNNING
-	 * as an indication that we attempte to signal cancellation. The
+	 * as an indication that we attempt to signal cancellation. The
 	 * completion will run normally in this case.
 	 */
 	rcu_read_lock();
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 405be10da73d..0896f495665b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1175,7 +1175,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 }
 
 /*
- * Poll for a mininum of 'min' events. Note that if min == 0 we consider that a
+ * Poll for a minimum of 'min' events. Note that if min == 0 we consider that a
  * non-spinning poll check - we'll still enter the driver poll loop, but only
  * as a non-spinning completion check.
  */
@@ -2567,7 +2567,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 
 		/*
 		 * Adjust the reqs sequence before the current one because it
-		 * will consume a slot in the cq_ring and the the cq_tail
+		 * will consume a slot in the cq_ring and the cq_tail
 		 * pointer will be increased, otherwise other timeout reqs may
 		 * return in advance without waiting for enough wait_nr.
 		 */
@@ -3414,7 +3414,7 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 }
 
 /*
- * Fetch an sqe, if one is available. Note that s->sqe will point to memory
+ * Fetch an sqe, if one is available. Note that req->sqe will point to memory
  * that is mapped by userspace. This means that care needs to be taken to
  * ensure that reads are stable, as we cannot rely on userspace always
  * being a good citizen. If members of the sqe are validated and then later
@@ -3676,7 +3676,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
 	struct io_ring_ctx *ctx = iowq->ctx;
 
 	/*
-	 * Wake up if we have enough events, or if a timeout occured since we
+	 * Wake up if we have enough events, or if a timeout occurred since we
 	 * started waiting. For timeouts, we always want to return to userspace,
 	 * regardless of event count.
 	 */

base-commit: 37d4e84f765bb3038ddfeebdc5d1cfd7e1ef688f
-- 
2.24.0

