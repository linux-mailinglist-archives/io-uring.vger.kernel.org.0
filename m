Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0374514EEE3
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 16:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgAaPAI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 10:00:08 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:33901 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbgAaPAI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 10:00:08 -0500
Received: by mail-il1-f193.google.com with SMTP id l4so6410203ilj.1
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 07:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Au+SY6QFm7OTQRTj89MVSx0yvbGJKqMXQve3PdwinU=;
        b=j3WDsaiu3X34IXRXGkHfg4vt3xO30uY7eZKoLlvKLEpudLV5MjyG1g4LCxe6j3aed4
         LPfHmMn+wg7rydwyUTAdjK4HaPXYeLk7f7GIKHNbMTDSn8QLAo/fyWRVmOkUnl77Rubk
         aUS9P9I49VufCKXuCjKU1FPytATfI3ItbPLSZedF+FtNXkZMhzfZ9ngZDtPjWjrwapFf
         hpFWht8WzEgA0IhvKmBnxhIXtRLa/oMtbrPiD7eQdCXnnN9ZVRf6VJNrLqNtB2dfnYCg
         8nc9xzfs6/AofnPp/dGJOEgonlZeRgbkwiphPafPWEemEhwk/CIwH9OVWxIT1pLdyhw7
         zSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Au+SY6QFm7OTQRTj89MVSx0yvbGJKqMXQve3PdwinU=;
        b=L7vi2iP+uiAiDnEc44gWlEbSpN0VsOQFZqHQVRELUOh9PfypUlTvcF9L/3pjA1+HGx
         sqM6+7+GE5MBaQHo+pBUJORtDxV5mB+eIyMpn3CGvYX778VugpSAl3h5KHN3rkRW5g8g
         xvRRvMrYWMLb4T7ts9xXtP7l15zMy2II1Pv/NtPKo3qm0Dd7QNQspWjnFKeYRjpm4aJZ
         QNRTSa4xGyMLs1qHPR9UXcX7wBkIfK9xDKECIIQsmtroCtuZngn330JDJEPUIGucIebe
         gA4jya0rjlAyHOXEtKxQXGrPEFzWOmhN0/xryFHMPEi+iurrJVns5fkd9b63QCmUHGtq
         DdCg==
X-Gm-Message-State: APjAAAV+HaOJDiZ3V+GZGRw5mGXv81gqdFk8rIpVHvCyVVXaQVWJVwkr
        aEa/LnnIHg7fMpkQKQI0OIA1k7DbGJZ/SQ==
X-Google-Smtp-Source: APXvYqx6jZY/sQ+G6dXyMI3vqIFGokudgfgxDYaYGvnLyDMpCLS26XD26g822tsA1y+sQlpELIMCRA==
X-Received: by 2002:a92:a186:: with SMTP id b6mr3103206ill.101.1580482807035;
        Fri, 31 Jan 2020 07:00:07 -0800 (PST)
Received: from trueserverstrongandfree.hitronhub.home ([2607:fea8:8400:f64::7])
        by smtp.googlemail.com with ESMTPSA id u64sm3121959ilc.78.2020.01.31.07.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 07:00:06 -0800 (PST)
From:   Glauber Costa <glauber@scylladb.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Glauber Costa <glauber@scylladb.com>
Subject: [PATCH liburing] add another helper for probing existing opcodes
Date:   Fri, 31 Jan 2020 10:00:02 -0500
Message-Id: <20200131150002.4191-1-glauber@scylladb.com>
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
 src/include/liburing.h |  4 +++-
 src/liburing.map       |  1 +
 src/setup.c            | 15 ++++++++++++++-
 test/probe.c           |  2 +-
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 39db902..aa11282 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -77,7 +77,9 @@ struct io_uring {
  * return an allocated io_uring_probe structure, or NULL if probe fails (for
  * example, if it is not available). The caller is responsible for freeing it
  */
-extern struct io_uring_probe *io_uring_get_probe(struct io_uring *ring);
+extern struct io_uring_probe *io_uring_get_probe_ring(struct io_uring *ring);
+/* same as io_uring_get_probe_ring, but takes care of ring init and teardown */
+extern struct io_uring_probe *io_uring_get_probe();
 
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
index c03274c..4fc35ea 100644
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
@@ -186,3 +186,16 @@ fail:
 	free(probe);
 	return NULL;
 }
+
+struct io_uring_probe *io_uring_get_probe() {
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

