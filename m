Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1802056208D
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 18:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiF3Qtz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 12:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbiF3Qty (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 12:49:54 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9541A34BB5
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:49:53 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U7Upi3009340
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:49:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=53oXaBrbyxbuR+jliZ3ScyXLbRt6PukSFMYajnLqWxc=;
 b=TmHAkKEgh+udU2eznRuTfKjTnYMq/vTTv/euE1vDsMxygBQ4zLnIQekklxlbUOxa7JsM
 xC/1R3Pq9F+E/XkXEvh30WWw4ugXc7j6PC8s0BSrFbZbiujhsr0E+n0XOC/FPce+cKK8
 6Eyv0WSx6LpajNnI3tlsMo2cvlA6aCrBaxY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h17geuvcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:49:52 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub101.TheFacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 09:49:49 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 09:49:49 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 514E025D4CD3; Thu, 30 Jun 2022 09:49:24 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        "Dylan Yudaken" <dylany@fb.com>
Subject: [PATCH v3 liburing 1/7] add t_create_socket_pair
Date:   Thu, 30 Jun 2022 09:49:12 -0700
Message-ID: <20220630164918.3958710-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630164918.3958710-1-dylany@fb.com>
References: <20220630164918.3958710-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: VXrd4jywbxi4VGTnZ9yGMG9YP9gnu0m7
X-Proofpoint-GUID: VXrd4jywbxi4VGTnZ9yGMG9YP9gnu0m7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_12,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a useful tool for making networking tests, and does not require a
hard coded port which is useful

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/helpers.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++
 test/helpers.h |  5 +++
 2 files changed, 95 insertions(+)

diff --git a/test/helpers.c b/test/helpers.c
index 491822e..3660cc0 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -10,6 +10,10 @@
 #include <unistd.h>
 #include <sys/types.h>
=20
+#include <arpa/inet.h>
+#include <netinet/ip.h>
+#include <netinet/tcp.h>
+
 #include "helpers.h"
 #include "liburing.h"
=20
@@ -143,3 +147,89 @@ enum t_setup_ret t_register_buffers(struct io_uring =
*ring,
 	fprintf(stderr, "buffer register failed: %s\n", strerror(-ret));
 	return ret;
 }
+
+int t_create_socket_pair(int fd[2], bool stream)
+{
+	int ret;
+	int type =3D stream ? SOCK_STREAM : SOCK_DGRAM;
+	int val;
+	struct sockaddr_in serv_addr;
+	struct sockaddr *paddr;
+	size_t paddrlen;
+
+	type |=3D SOCK_CLOEXEC;
+	fd[0] =3D socket(AF_INET, type, 0);
+	if (fd[0] < 0)
+		return errno;
+	fd[1] =3D socket(AF_INET, type, 0);
+	if (fd[1] < 0) {
+		ret =3D errno;
+		close(fd[0]);
+		return ret;
+	}
+
+	val =3D 1;
+	if (setsockopt(fd[0], SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val)))
+		goto errno_cleanup;
+
+	memset(&serv_addr, 0, sizeof(serv_addr));
+	serv_addr.sin_family =3D AF_INET;
+	serv_addr.sin_port =3D 0;
+	inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr);
+
+	paddr =3D (struct sockaddr *)&serv_addr;
+	paddrlen =3D sizeof(serv_addr);
+
+	if (bind(fd[0], paddr, paddrlen)) {
+		fprintf(stderr, "bind failed\n");
+		goto errno_cleanup;
+	}
+
+	if (stream && listen(fd[0], 16)) {
+		fprintf(stderr, "listen failed\n");
+		goto errno_cleanup;
+	}
+
+	if (getsockname(fd[0], &serv_addr, (socklen_t *)&paddrlen)) {
+		fprintf(stderr, "getsockname failed\n");
+		goto errno_cleanup;
+	}
+	inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr);
+
+	if (connect(fd[1], &serv_addr, paddrlen)) {
+		fprintf(stderr, "connect failed\n");
+		goto errno_cleanup;
+	}
+
+	if (!stream) {
+		/* connect the other udp side */
+		if (getsockname(fd[1], &serv_addr, (socklen_t *)&paddrlen)) {
+			fprintf(stderr, "getsockname failed\n");
+			goto errno_cleanup;
+		}
+		inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr);
+
+		if (connect(fd[0], &serv_addr, paddrlen)) {
+			fprintf(stderr, "connect failed\n");
+			goto errno_cleanup;
+		}
+		return 0;
+	}
+
+	/* for stream case we must accept and cleanup the listen socket */
+
+	ret =3D accept(fd[0], NULL, NULL);
+	if (ret < 0)
+		goto errno_cleanup;
+
+	close(fd[0]);
+	fd[0] =3D ret;
+
+	return 0;
+
+errno_cleanup:
+	ret =3D errno;
+	close(fd[0]);
+	close(fd[1]);
+	return ret;
+}
diff --git a/test/helpers.h b/test/helpers.h
index 3179687..fbfd7d1 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -59,6 +59,11 @@ void t_create_file_pattern(const char *file, size_t si=
ze, char pattern);
  */
 struct iovec *t_create_buffers(size_t buf_num, size_t buf_size);
=20
+/*
+ * Helper for creating connected socket pairs
+ */
+int t_create_socket_pair(int fd[2], bool stream);
+
 /*
  * Helper for setting up a ring and checking for user privs
  */
--=20
2.30.2

