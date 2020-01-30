Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800F314DE48
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 17:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgA3QAT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 11:00:19 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46473 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgA3QAT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 11:00:19 -0500
Received: by mail-il1-f195.google.com with SMTP id t17so3431493ilm.13
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2020 08:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VT2ghYTpLFNEYrs5riJEpDNoXC8GQvHXGaOWeNTgniA=;
        b=BQ90k3IAz+CsA1MiSEUw9NN36rn8Y3y+O2SxB2jPwfvVba3R16FS+7k8u0w2sxNXQR
         1j9FidlN0TRR3kxGs4zsI7x5sgIjkoF1B7yFocktwBFuO8W1h/dYjrDkmaUHweG6B9Sf
         69/AuKAeXoAv7+AjE+TgSUwE6YFaG0tVpE/+3EkjlI6hWFR1qmupwlLaWxKT/hYK3oZK
         4czCTKE+87oKMxpLr4AahQIlJKaKzsn2FKCiNJrldR5p9cA9A2qrAoPpKs9JcIkJrpJ8
         MHv1+j41/T7O/5i44CrDOUrbNZcJ4U4HUU0AeilG1Z5lgL3QyqgCwyVvc2SBxuct6E3m
         Umfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VT2ghYTpLFNEYrs5riJEpDNoXC8GQvHXGaOWeNTgniA=;
        b=poB1J4wX7JLknliElbNPqA8djs6x6pvkqJdSGEtIKWObOPJaewAOlk7hIku1xtMeaA
         nJ0kkYIMz94xQDHnACCdWathi32sIrmg4TR27U42acdojK3D5lr8eV4tBvLiTixamqwu
         mBV/Vv6+kDwuuvc8hG9GDpo7I5AVTZ5rEBC4WR6kXX8sX2vkyNk0DWeosTCiRB5vTita
         s2heMvGi981tuTgAetN6XAYaP+Rm/zAVj5gOQ31KMAMdh/BWKtsHbklWMr+Wo4K9bfNC
         DcYi/hhgArhAtAXsjZNiWeJOSM2QrKghgO+hau3QjQWOtnpTizNIXa+0dtuGtMc/a+zc
         Kwpw==
X-Gm-Message-State: APjAAAXBE1NhMKlJ2IsjxNDxj+YFsrRMiAxp56AGMdLicG5XXfdORG/r
        mrkqFrXP3pIv3DkG4vXq8rGg7F+rHM5+NA==
X-Google-Smtp-Source: APXvYqwgO9als+Rfgsr1uvYL7t8z+y0+AU9SA2NshRtwuMd5DV/kdZKdgr/swVVUPMkaikO8KxGsrA==
X-Received: by 2002:a92:9a56:: with SMTP id t83mr5140672ili.200.1580400017024;
        Thu, 30 Jan 2020 08:00:17 -0800 (PST)
Received: from trueserverstrongandfree.hitronhub.home ([2607:fea8:8400:f64::7])
        by smtp.googlemail.com with ESMTPSA id x62sm1979086ill.86.2020.01.30.08.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 08:00:16 -0800 (PST)
From:   Glauber Costa <glauber@scylladb.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Glauber Costa <glauber@scylladb.com>,
        Avi Kivity <avi@scylladb.com>
Subject: [PATCH v2 liburing] add helper functions to verify io_uring functionality
Date:   Thu, 30 Jan 2020 11:00:13 -0500
Message-Id: <20200130160013.21315-1-glauber@scylladb.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is common for an application using an ever-evolving interface to want
to inquire about the presence of certain functionality it plans to use.

Information about opcodes is stored in a io_uring_probe structure. There
is usually some boilerplate involved in initializing one, and then using
it to check if it is enabled.

This patch adds two new helper functions: one that returns a pointer to
a io_uring_probe (or null if it probe is not available), and another one
that given a probe checks if the opcode is supported.

Signed-off-by: Glauber Costa <glauber@scylladb.com>
CC: Avi Kivity <avi@scylladb.com>
---
 src/include/liburing.h | 11 +++++++++++
 src/liburing.map       |  1 +
 src/setup.c            | 19 +++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 83d11dd..da52ca6 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -72,6 +72,17 @@ struct io_uring {
 /*
  * Library interface
  */
+
+/*
+ * return an allocated io_uring_probe structure, or NULL if probe fails (for
+ * example, if it is not available). The caller is responsible for freeing it
+ */
+extern struct io_uring_probe *io_uring_get_probe(struct io_uring *ring);
+
+static inline int io_uring_opcode_supported(struct io_uring_probe *p, int op) {
+	return (p->last_op > op) && (p->ops[op].flags & IO_URING_OP_SUPPORTED);
+}
+
 extern int io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
 	struct io_uring_params *p);
 extern int io_uring_queue_init(unsigned entries, struct io_uring *ring,
diff --git a/src/liburing.map b/src/liburing.map
index b45f373..ac8288a 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -72,4 +72,5 @@ LIBURING_0.4 {
 		io_uring_register_probe;
 		io_uring_register_personality;
 		io_uring_unregister_personality;
+		io_uring_get_probe;
 } LIBURING_0.3;
diff --git a/src/setup.c b/src/setup.c
index c53f234..c03274c 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -4,6 +4,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <string.h>
+#include <stdlib.h>
 
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
@@ -167,3 +168,21 @@ void io_uring_queue_exit(struct io_uring *ring)
 	io_uring_unmap_rings(sq, cq);
 	close(ring->ring_fd);
 }
+
+struct io_uring_probe *io_uring_get_probe(struct io_uring *ring)
+{
+	struct io_uring_probe *probe;
+	int r;
+
+	size_t len = sizeof(*probe) + 256 * sizeof(struct io_uring_probe_op);
+	probe = malloc(len);
+	memset(probe, 0, len);
+	r = io_uring_register_probe(ring, probe, 256);
+	if (r < 0)
+		goto fail;
+
+	return probe;
+fail:
+	free(probe);
+	return NULL;
+}
-- 
2.20.1

