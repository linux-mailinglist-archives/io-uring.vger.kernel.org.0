Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220A714EFBF
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 16:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgAaPh7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 10:37:59 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:45095 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbgAaPh7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 10:37:59 -0500
Received: by mail-io1-f67.google.com with SMTP id i11so8542464ioi.12
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 07:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ehzzChDGtnLCMec9I8eTTtqGeqadiK5tF8TQ5oSrtmU=;
        b=uIEO7ayLrO2JxCUPzGxGodSNyyK0kxVRH1B7y2I3MQirhw1L5BzPMQ3HYcnhQVpVHw
         ZDEWguT3u/Bu24j2Zgj3WQDRSK8NnkaBVZAGVChgekFwHGswrXwQrR2ePZ0+qAx05osX
         J8wSuMnYwucjJyKQHTFSBfBkjL/ykdg5xhhopTQctZQo60HVRGRbYSQoMfzl4FxWTxLT
         NArQtmBiZWJdg7vgLMk0tbxWLa4fWmyXVPrS76NViPNvynggfKU73SAPNq/meE0m66HD
         3Om19LHfTmyvguJRXUgvoo9fzDckJ1lOoLEPHRCbywyO15CFvUHtLgLarzCUwtzSAGT1
         Rfxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ehzzChDGtnLCMec9I8eTTtqGeqadiK5tF8TQ5oSrtmU=;
        b=AXD1djgAXqcrv42NZvodwpyt/lXrRptHq8Z22UdqmctijB6fmiqYZdzCuoQJ0Wf5gW
         hGSlooW0iIpUIW1yC2s4s6SqIK6LC6wDtv/cczPARcS1oWsnOU0qJ/m96UlfqtwAVx4+
         os9y5JP+z5weQh2gGr9MFG2Qxs0CoWTILS1eIVPgruRy21T5FJL76tkY801ojj1Rq+SL
         DdQ2Y/WSgLE0cUOC5gNKJOJyJTJiFqbcO+jS+So2/MWvo5nxRNKmFL8b5FAsNgPxVs1U
         vTdX76+57WUL93ptDPz7I+kiZAw+BWtEFLLObQ4nS0HiqhcVjwJsv+LfpHvvH1vqSclB
         FFKQ==
X-Gm-Message-State: APjAAAWSzVHBoKJ/ojaipIMy6rnsD9y2EyQbKh39asd/cFL630D+m5DL
        /vKNYC23MoyzIn9hKdnrjUXUXT5N4RCW8A==
X-Google-Smtp-Source: APXvYqzxQWWo7krTl/EmYmXFWCXeR8rWuWEg6aX0FBWt2TgdhSQ/puVOWTudPGKkF2XneRUfAxqB0A==
X-Received: by 2002:a6b:6f17:: with SMTP id k23mr8986224ioc.75.1580485076854;
        Fri, 31 Jan 2020 07:37:56 -0800 (PST)
Received: from trueserverstrongandfree.hitronhub.home ([2607:fea8:8400:f64::7])
        by smtp.googlemail.com with ESMTPSA id i13sm2527398ioi.67.2020.01.31.07.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 07:37:55 -0800 (PST)
From:   Glauber Costa <glauber@scylladb.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Glauber Costa <glauber@scylladb.com>
Subject: [PATCH liburing v2] add another helper for probing existing opcodes
Date:   Fri, 31 Jan 2020 10:37:44 -0500
Message-Id: <20200131153744.4750-1-glauber@scylladb.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are situations where one does not have a ring initialized yet, and
yet they may want to know which opcodes are supported before doing so.

We have recently introduced io_uring_get_probe(io_uring*) to do a
similar task when the ring already exists. Because this was committed
recently and this hasn't seen a release, I thought I would just go ahead
and change that to io_uring_get_probe_ring(io_uring*), because I suck at
finding another meaningful name for this case (io_uring_get_probe_noring
sounded way too ugly to me)

A minimal ring is initialized and torn down inside the function.

Signed-off-by: Glauber Costa <glauber@scylladb.com>
---
v2: style changes
---
 src/include/liburing.h |  4 +++-
 src/liburing.map       |  1 +
 src/setup.c            | 16 +++++++++++++++-
 test/probe.c           |  2 +-
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 39db902..faed2e7 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -77,7 +77,9 @@ struct io_uring {
  * return an allocated io_uring_probe structure, or NULL if probe fails (for
  * example, if it is not available). The caller is responsible for freeing it
  */
-extern struct io_uring_probe *io_uring_get_probe(struct io_uring *ring);
+extern struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring);
+/* same as io_uring_get_probe_ring, but takes care of ring init and teardown */
+extern struct io_uring_probe *io_uring_get_probe(void);
 
 static inline int io_uring_opcode_supported(struct io_uring_probe *p, int op)
 {
diff --git a/src/liburing.map b/src/liburing.map
index ac8288a..8daa432 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -73,4 +73,5 @@ LIBURING_0.4 {
 		io_uring_register_personality;
 		io_uring_unregister_personality;
 		io_uring_get_probe;
+		io_uring_get_probe_ring;
 } LIBURING_0.3;
diff --git a/src/setup.c b/src/setup.c
index c03274c..3638d1b 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -169,7 +169,7 @@ void io_uring_queue_exit(struct io_uring *ring)
 	close(ring->ring_fd);
 }
 
-struct io_uring_probe *io_uring_get_probe(struct io_uring *ring)
+struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring)
 {
 	struct io_uring_probe *probe;
 	int r;
@@ -186,3 +186,17 @@ fail:
 	free(probe);
 	return NULL;
 }
+
+struct io_uring_probe *io_uring_get_probe(void)
+{
+	struct io_uring ring;
+	struct io_uring_probe* probe = NULL;
+
+	int r = io_uring_queue_init(2, &ring, 0);
+	if (r < 0)
+		return NULL;
+
+	probe = io_uring_get_probe_ring(&ring);
+	io_uring_queue_exit(&ring);
+	return probe;
+}
diff --git a/test/probe.c b/test/probe.c
index 34f2028..b85b089 100644
--- a/test/probe.c
+++ b/test/probe.c
@@ -45,7 +45,7 @@ static int test_probe_helper(struct io_uring *ring)
 {
 	struct io_uring_probe *p;
 
-	p = io_uring_get_probe(ring);
+	p = io_uring_get_probe_ring(ring);
 	if (!p) {
 		fprintf(stderr, "Failed getting probe data\n");
 		return 1;
-- 
2.20.1

