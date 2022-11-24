Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AE6637688
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 11:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiKXKbB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 05:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKXKaz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 05:30:55 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1F5CFE90
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:30:54 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2ANHsAIO030046
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:30:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=876XmUNbUJSAwowMEwFdHFm3FXR4aUcKSzFkgqkGecw=;
 b=IBeqa6DyX71wcIcgZ3g/bHg5IQgcoB3KmP0KNtbzQagekXv8SNhSccfqqPYn25wANfsr
 VxnTUeJULU3MJuXmh/HG9YNPMKKEzsqHEkeYeqyFKEa3gpB32CmKLYYYdxCnYhSZPQY/
 2zH5ZpPQAkpto+WAbnVhsTsIhX0fU9LzTl1aF+nvFeAWTBmouUxcEWXEcWuSKk6eQf++
 VYK/jJhl5wffgxyhYhFsOEJIfC+STL7McQZqrO3trEC13fLgqNpRxGQtED4Q0fSc3GXJ
 G3xbIi+uxW6bjlLGyIqvogw5DTg1Sf7Vgor6Sl7B6eNiiCO5bzwnoHRL10d5jz8F41oZ Bw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3m1c7rhre8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 02:30:53 -0800
Received: from twshared0705.02.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 02:30:51 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 5B63FA17DB91; Thu, 24 Nov 2022 02:30:43 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, Dylan Yudaken <dylany@meta.com>
Subject: [PATCH liburing 1/2] Add a test for errors in multishot recv
Date:   Thu, 24 Nov 2022 02:30:41 -0800
Message-ID: <20221124103042.4129289-2-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124103042.4129289-1-dylany@meta.com>
References: <20221124103042.4129289-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: nvdyiPjc_cOA8wc3ejRZHGpGFUHcE0N9
X-Proofpoint-ORIG-GUID: nvdyiPjc_cOA8wc3ejRZHGpGFUHcE0N9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In a later kernel release there will be deferred completions of multishot
ops. Add a test to ensure ordering is preserved when there is an error
during the multishot operation.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 test/recv-multishot.c | 85 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/test/recv-multishot.c b/test/recv-multishot.c
index ed26a5f78759..08a2e8629f5b 100644
--- a/test/recv-multishot.c
+++ b/test/recv-multishot.c
@@ -9,6 +9,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <pthread.h>
+#include <assert.h>
=20
 #include "liburing.h"
 #include "helpers.h"
@@ -469,6 +470,84 @@ cleanup:
 	return ret;
 }
=20
+static int test_enobuf(void)
+{
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqes[16];
+	char buffs[256];
+	int ret, i, fds[2];
+
+	if (t_create_ring(8, &ring, 0) !=3D T_SETUP_OK) {
+		fprintf(stderr, "ring create\n");
+		return -1;
+	}
+
+	ret =3D t_create_socket_pair(fds, false);
+	if (ret) {
+		fprintf(stderr, "t_create_socket_pair\n");
+		return ret;
+	}
+
+	sqe =3D io_uring_get_sqe(&ring);
+	assert(sqe);
+	/* deliberately only 2 provided buffers */
+	io_uring_prep_provide_buffers(sqe, &buffs[0], 1, 2, 0, 0);
+	io_uring_sqe_set_data64(sqe, 0);
+
+	sqe =3D io_uring_get_sqe(&ring);
+	assert(sqe);
+	io_uring_prep_recv_multishot(sqe, fds[0], NULL, 0, 0);
+	io_uring_sqe_set_data64(sqe, 1);
+	sqe->buf_group =3D 0;
+	sqe->flags |=3D IOSQE_BUFFER_SELECT;
+
+	ret =3D io_uring_submit(&ring);
+	if (ret !=3D 2) {
+		fprintf(stderr, "bad submit %d\n", ret);
+		return -1;
+	}
+	for (i =3D 0; i < 3; i++) {
+		do {
+			ret =3D write(fds[1], "?", 1);
+		} while (ret =3D=3D -1 && errno =3D=3D EINTR);
+	}
+
+	ret =3D io_uring_wait_cqes(&ring, &cqes[0], 4, NULL, NULL);
+	if (ret) {
+		fprintf(stderr, "wait cqes\n");
+		return ret;
+	}
+
+	ret =3D io_uring_peek_batch_cqe(&ring, &cqes[0], 4);
+	if (ret !=3D 4) {
+		fprintf(stderr, "peek batch cqes\n");
+		return -1;
+	}
+
+	/* provide buffers */
+	assert(cqes[0]->user_data =3D=3D 0);
+	assert(cqes[0]->res =3D=3D 0);
+
+	/* valid recv */
+	assert(cqes[1]->user_data =3D=3D 1);
+	assert(cqes[2]->user_data =3D=3D 1);
+	assert(cqes[1]->res =3D=3D 1);
+	assert(cqes[2]->res =3D=3D 1);
+	assert(cqes[1]->flags & (IORING_CQE_F_BUFFER | IORING_CQE_F_MORE));
+	assert(cqes[2]->flags & (IORING_CQE_F_BUFFER | IORING_CQE_F_MORE));
+
+	/* missing buffer */
+	assert(cqes[3]->user_data =3D=3D 1);
+	assert(cqes[3]->res =3D=3D -ENOBUFS);
+	assert(!(cqes[3]->flags & (IORING_CQE_F_BUFFER | IORING_CQE_F_MORE)));
+
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
@@ -509,5 +588,11 @@ int main(int argc, char *argv[])
 		}
 	}
=20
+	ret =3D test_enobuf();
+	if (ret) {
+		fprintf(stderr, "test_enobuf() failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
 	return T_EXIT_PASS;
 }

base-commit: b90a28636e5b5efe6dc1383acc90aec61814d9ba
--=20
2.30.2

