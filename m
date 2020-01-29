Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD0E14D125
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 20:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgA2TU0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 14:20:26 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:42418 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgA2TU0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 14:20:26 -0500
Received: by mail-io1-f66.google.com with SMTP id n11so998957iom.9
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 11:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tARdTrkr17b1Gsla+LK2e3Xp7U7ZfWeXdms5wggV1a0=;
        b=hdbZf8h03ULhfhJC8C3m3qSLKqfyseOZO0s1CSCqdPubCPi/g/aPN3i1eVzVoOsvfD
         BdMO0fnPTdScPPw/EDo4f3WJwhEaxCB9UJADTFm9YibxnQww4O4v5ck04FqZP1Kk9Wyl
         aPJnJd9sqmCVZhzvXxOhUxKyku2U1p5YHbhDYQEgiIRKlT4tguzZAE4X7/XRLcRNbzN8
         /h2X0r8QzmdxrPEuLnmvj4FUREXjA77r+EPqJ5Q53C4uVQG8in/rqezyOaBp9d/Vm9BF
         7nI7u9DUR16YNygCgmuWYnfteQkfIQGjcIyMlU/ngjf8n9Vtue3cok6TyCF8bVTvBSsS
         lzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tARdTrkr17b1Gsla+LK2e3Xp7U7ZfWeXdms5wggV1a0=;
        b=Jfa6qkhMr+VVJtN6mUvQKbqW7aQ/HGaLlQ2ET0oe3Um1EkSoMQ4NfWwmDk5dMSYU+t
         PSVhBMeJDpQUy5HX0Rgpra7bFcETAlZWWj6EXvXjNQS8X767XBnW5edcdwGo1pzed+Ac
         ++UNsdb0E5pv3gFUPT7ykKCMNMMFYiGVWa/SBME+sqdb2BD7klBNLO301mq11ItFKg+H
         gaJVfliY2uXyLPe6ZxeAOOVCmut5RsJ86OTeX5nsr52tGprOiQNtj7e9ZhwzcNtttRRi
         hxuORfYZV9IH3h7i3p1L1uid3jvtiqPJ27fiHcF47lYqw+HT1TbiQlEqBRlCfoZeHX8b
         /0Ag==
X-Gm-Message-State: APjAAAWSJfwGOqgL40J0G4HfZw/oU5WRBhMVJwTlvBfnL+tORLTQi1H8
        fOgDssvs8wyQa18tp4TDp2VIDnHvQthmmA==
X-Google-Smtp-Source: APXvYqxl1y3XhXVONmuH2FfMJxdM1XqR/nJOtx28CSjzCXJWLbvSFezCglwyv6Ptr7tla1kdhbX3yg==
X-Received: by 2002:a5d:8043:: with SMTP id b3mr923448ior.192.1580325623920;
        Wed, 29 Jan 2020 11:20:23 -0800 (PST)
Received: from trueserverstrongandfree.hitronhub.home ([2607:fea8:8400:f64::7])
        by smtp.googlemail.com with ESMTPSA id t2sm990114ild.34.2020.01.29.11.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 11:20:23 -0800 (PST)
From:   Glauber Costa <glauber@scylladb.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Glauber Costa <glauber@scylladb.com>,
        Avi Kivity <avi@scylladb.com>
Subject: [PATCH] add a helper function to verify io_uring functionality
Date:   Wed, 29 Jan 2020 14:20:16 -0500
Message-Id: <20200129192016.6407-1-glauber@scylladb.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is common for an application using an ever-evolving interface to want
to inquire about the presence of certain functionality it plans to use.

The boilerplate to do that is about always the same: find places that
have feature bits, match that with what we need, rinse, repeat.
Therefore it makes sense to move this to a library function.

We have two places in which we can check for such features: the feature
flag returned by io_uring_init_params(), and the resulting array
returning from io_uring_probe.

I tried my best to communicate as well as possible in the function
signature the fact that this is not supposed to test the availability
of io_uring (which is straightforward enough), but rather a minimum set
of requirements for usage.

Signed-off-by: Glauber Costa <glauber@scylladb.com>
CC: Avi Kivity <avi@scylladb.com>
---
 src/include/liburing.h | 13 +++++++++++++
 src/liburing.map       |  1 +
 src/setup.c            | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 83d11dd..d740083 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -72,6 +72,19 @@ struct io_uring {
 /*
  * Library interface
  */
+
+/* Checks that io_uring is modern enough for a particular case.
+ * Check it by verifying that:
+ *
+ *  - io_uring is available
+ *  - the io_uring_probe call is available, so opcodes can be checked
+ *  - all opcodes the application wants to use are supported
+ *  - the features requested are present.
+ *
+ *  return 0 if io_uring is not usable, 1 otherwise.
+ */
+extern int io_uring_check_minimum_support(const int* operations, int noperations, int features);
+
 extern int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
 	struct io_uring_params *p);
 extern int io_uring_queue_init(unsigned entries, struct io_uring *ring,
diff --git a/src/liburing.map b/src/liburing.map
index b45f373..579d4de 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -72,4 +72,5 @@ LIBURING_0.4 {
 		io_uring_register_probe;
 		io_uring_register_personality;
 		io_uring_unregister_personality;
+		io_uring_check_minimum_support;
 } LIBURING_0.3;
diff --git a/src/setup.c b/src/setup.c
index c53f234..7e46219 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -4,6 +4,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <string.h>
+#include <stdlib.h>
 
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
@@ -167,3 +168,41 @@ void io_uring_queue_exit(struct io_uring *ring)
 	io_uring_unmap_rings(sq, cq);
 	close(ring->ring_fd);
 }
+
+int io_uring_check_minimum_support(const int* operations, int noperations, int features)
+{
+	struct io_uring_params p;
+	struct io_uring_probe* probe;
+	struct io_uring ring;
+	int r;
+	int i;
+	int ret = 0;
+
+	memset(&p, 0, sizeof(p));
+	r = io_uring_queue_init_params(2, &ring, &p);
+	if (r < 0)
+		return ret;
+
+	if ((p.features & features) != features)
+		goto exit;
+
+	size_t len = sizeof(*probe) + 256 * sizeof(struct io_uring_probe_op);
+	probe = malloc(len);
+	memset(probe, 0, len);
+	r = io_uring_register_probe(&ring, probe, 256);
+	if (r < 0)
+		goto exit;
+
+	for (i = 0; i < noperations; i++) {
+		int op = operations[i];
+		if (probe->last_op < op)
+			goto exit;
+
+		if (!(probe->ops[op].flags & IO_URING_OP_SUPPORTED))
+			goto exit;
+	}
+	ret = 1;
+exit:
+	io_uring_queue_exit(&ring);
+	return ret;
+}
-- 
2.20.1

