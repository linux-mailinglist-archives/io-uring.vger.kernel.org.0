Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF7855E7FA
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 18:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347731AbiF1PEc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 11:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347720AbiF1PEb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 11:04:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD64192A3
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:30 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SAE6Vq013125
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=rJDn4mTH+FztlGFytSbqUBIqiZ4DyJ/3UGqMxMNnJTk=;
 b=VBBU4xKHhUjwSD/8TJ+GbEwNcRoQZl2SLBKSCZalqgfHvfFYduKpJLmARtQt9nOnYjGT
 IraYvGs/k40QowfwpxLG0Vz5GR+6knwECOk8mY3NVsZR9Wfj+CYfhVuK/vGuu+9GOAzb
 gJg2ALCFe9n/b5dhroPjlq7kJ2TmmPKz2zM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gyxx31ytw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 08:04:29 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 28 Jun 2022 08:04:26 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id C18C1244BD59; Tue, 28 Jun 2022 08:04:18 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 3/4] add recv-multishot test
Date:   Tue, 28 Jun 2022 08:04:13 -0700
Message-ID: <20220628150414.1386435-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628150414.1386435-1-dylany@fb.com>
References: <20220628150414.1386435-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 028fMTDhAnRImmUgh-gjY-N-CWuMU_d-
X-Proofpoint-ORIG-GUID: 028fMTDhAnRImmUgh-gjY-N-CWuMU_d-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

add a test for multishot receive functionality

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/Makefile         |   1 +
 test/recv-multishot.c | 308 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 309 insertions(+)
 create mode 100644 test/recv-multishot.c

diff --git a/test/Makefile b/test/Makefile
index e3204a7..73a0001 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -124,6 +124,7 @@ test_srcs :=3D \
 	read-write.c \
 	recv-msgall.c \
 	recv-msgall-stream.c \
+	recv-multishot.c \
 	register-restrictions.c \
 	rename.c \
 	ringbuf-read.c \
diff --git a/test/recv-multishot.c b/test/recv-multishot.c
new file mode 100644
index 0000000..38ec615
--- /dev/null
+++ b/test/recv-multishot.c
@@ -0,0 +1,308 @@
+// SPDX-License-Identifier: MIT
+
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <pthread.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+
+enum early_error_t {
+	ERROR_NONE  =3D 0,
+	ERROR_NOT_ENOUGH_BUFFERS =3D 1,
+	ERROR_EARLY_CLOSE_SENDER =3D 2,
+	ERROR_EARLY_CLOSE_RECEIVER =3D 3,
+};
+
+struct args {
+	bool recvmsg;
+	bool stream;
+	bool wait_each;
+	enum early_error_t early_error;
+};
+
+static int test(struct args *args)
+{
+	int const N =3D 8;
+	int const N_BUFFS =3D N * 64;
+	int const min_cqes =3D 2;
+	struct io_uring ring;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int fds[2], ret, i, j, total_sent_bytes =3D 0, total_recv_bytes =3D 0;
+	int send_buff[256];
+	int *recv_buffs[N_BUFFS];
+	int *at;
+	struct io_uring_cqe recv_cqe[N_BUFFS];
+	int recv_cqes =3D 0;
+	bool early_error =3D false;
+	bool early_error_started =3D false;
+	struct msghdr msg =3D { };
+	struct __kernel_timespec timeout =3D {
+		.tv_sec =3D 1,
+	};
+
+
+	memset(recv_buffs, 0, sizeof(recv_buffs));
+
+	ret =3D io_uring_queue_init(32, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return ret;
+	}
+
+	ret =3D t_create_socket_pair(fds, args->stream);
+	if (ret) {
+		fprintf(stderr, "t_create_socket_pair failed: %d\n", ret);
+		return ret;
+	}
+
+	for (i =3D 0; i < ARRAY_SIZE(send_buff); i++)
+		send_buff[i] =3D i;
+
+	for (i =3D 0; i < ARRAY_SIZE(recv_buffs); i++) {
+		/* prepare some different sized buffers */
+		int buffer_size =3D (i % 2 =3D=3D 0 && args->stream) ? 1 : N * sizeof(=
int);
+
+		recv_buffs[i] =3D malloc(sizeof(*at) * buffer_size);
+
+		if (i > 2 && args->early_error =3D=3D ERROR_NOT_ENOUGH_BUFFERS)
+			continue;
+
+		sqe =3D io_uring_get_sqe(&ring);
+		io_uring_prep_provide_buffers(sqe, recv_buffs[i],
+					buffer_size * sizeof(*recv_buffs[i]), 1, 7, i);
+		if (io_uring_submit_and_wait_timeout(&ring, &cqe, 1, &timeout, NULL) !=
=3D 0) {
+			fprintf(stderr, "provide buffers failed: %d\n", ret);
+			ret =3D -1;
+			goto cleanup;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	sqe =3D io_uring_get_sqe(&ring);
+	if (args->recvmsg) {
+		memset(&msg, 0, sizeof(msg));
+		msg.msg_namelen =3D sizeof(struct sockaddr_in);
+		io_uring_prep_recvmsg(sqe, fds[0], &msg, 0);
+	} else {
+		io_uring_prep_recv(sqe, fds[0], NULL, 0, 0);
+	}
+	sqe->flags |=3D IOSQE_BUFFER_SELECT;
+	sqe->buf_group =3D 7;
+	sqe->addr2 |=3D IORING_RECV_MULTISHOT;
+	io_uring_sqe_set_data64(sqe, 1234);
+	io_uring_submit(&ring);
+
+	at =3D &send_buff[0];
+	total_sent_bytes =3D 0;
+	for (i =3D 0; i < N; i++) {
+		int to_send =3D sizeof(*at) * (i+1);
+
+		total_sent_bytes +=3D to_send;
+		if (send(fds[1], at, to_send, 0) !=3D to_send) {
+			if (early_error_started)
+				break;
+			fprintf(stderr, "send failed %d\n", errno);
+			ret =3D -1;
+			goto cleanup;
+		}
+
+		if (i =3D=3D 2) {
+			if (args->early_error =3D=3D ERROR_EARLY_CLOSE_RECEIVER) {
+				/* allow previous sends to complete */
+				usleep(1000);
+
+				sqe =3D io_uring_get_sqe(&ring);
+				io_uring_prep_recv(sqe, fds[0], NULL, 0, 0);
+				io_uring_prep_cancel64(sqe, 1234, 0);
+				sqe->flags |=3D IOSQE_CQE_SKIP_SUCCESS;
+				io_uring_submit(&ring);
+				early_error_started =3D true;
+			}
+			if (args->early_error =3D=3D ERROR_EARLY_CLOSE_SENDER) {
+				early_error_started =3D true;
+				shutdown(fds[1], SHUT_RDWR);
+				close(fds[1]);
+			}
+		}
+		at +=3D (i+1);
+
+		if (args->wait_each) {
+			ret =3D io_uring_wait_cqes(&ring, &cqe, 1, &timeout, NULL);
+			if (ret) {
+				fprintf(stderr, "wait_each failed: %d\n", ret);
+				ret =3D -1;
+				goto cleanup;
+			}
+			while (io_uring_peek_cqe(&ring, &cqe) =3D=3D 0) {
+				recv_cqe[recv_cqes++] =3D *cqe;
+				if (cqe->flags & IORING_CQE_F_MORE) {
+					io_uring_cqe_seen(&ring, cqe);
+				} else {
+					early_error =3D true;
+					io_uring_cqe_seen(&ring, cqe);
+				}
+			}
+			if (early_error)
+				break;
+		}
+	}
+
+	close(fds[1]);
+
+	/* allow sends to finish */
+	usleep(1000);
+
+	if ((args->stream && !early_error) || recv_cqes < min_cqes) {
+		ret =3D io_uring_wait_cqes(&ring, &cqe, 1, &timeout, NULL);
+		if (ret && ret !=3D -ETIME) {
+			fprintf(stderr, "wait final failed: %d\n", ret);
+			ret =3D -1;
+			goto cleanup;
+		}
+	}
+
+	while (io_uring_peek_cqe(&ring, &cqe) =3D=3D 0) {
+		recv_cqe[recv_cqes++] =3D *cqe;
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	ret =3D -1;
+	at =3D &send_buff[0];
+	if (recv_cqes < min_cqes) {
+		fprintf(stderr, "not enough cqes: have=3D%d vs %d\n", recv_cqes, min_c=
qes);
+		goto cleanup;
+	}
+	for (i =3D 0; i < recv_cqes; i++) {
+		bool const is_last =3D i =3D=3D recv_cqes - 1;
+		int *this_recv;
+
+		cqe =3D &recv_cqe[i];
+
+		if (cqe->res <=3D 0 || (args->stream && is_last)) {
+			if (!is_last) {
+				fprintf(stderr, "not last cqe had error %d\n", i);
+				goto cleanup;
+			}
+
+			switch (args->early_error) {
+			case ERROR_NOT_ENOUGH_BUFFERS:
+				if (cqe->res !=3D -ENOBUFS) {
+					fprintf(stderr,
+						"ERROR_NOT_ENOUGH_BUFFERS: res %d\n", cqe->res);
+					goto cleanup;
+				}
+				break;
+			case ERROR_EARLY_CLOSE_RECEIVER:
+				if (cqe->res !=3D -ECANCELED) {
+					fprintf(stderr,
+						"ERROR_EARLY_CLOSE_RECEIVER: res %d\n", cqe->res);
+					goto cleanup;
+				}
+				break;
+			case ERROR_NONE:
+			case ERROR_EARLY_CLOSE_SENDER:
+				if (cqe->res !=3D 0) {
+					fprintf(stderr, "early error: res %d\n", cqe->res);
+					goto cleanup;
+				}
+				break;
+			};
+
+			if (cqe->flags & IORING_CQE_F_BUFFER) {
+				fprintf(stderr, "final BUFFER flag set\n");
+				goto cleanup;
+			}
+
+			if (cqe->flags & IORING_CQE_F_MORE) {
+				fprintf(stderr, "final MORE flag set\n");
+				goto cleanup;
+			}
+
+			continue;
+		}
+
+		total_recv_bytes +=3D cqe->res;
+		if (!(cqe->flags & IORING_CQE_F_BUFFER)) {
+			fprintf(stderr, "BUFFER flag not set\n");
+			goto cleanup;
+		}
+		if (!(cqe->flags & IORING_CQE_F_MORE)) {
+			fprintf(stderr, "MORE flag not set\n");
+			goto cleanup;
+		}
+		if (cqe->res % 4 !=3D 0) {
+			/*
+			 * doesn't seem to happen in practice, would need some
+			 * work to remove this requirement
+			 */
+			fprintf(stderr, "unexpectedly aligned buffer cqe->res=3D%d\n", cqe->r=
es);
+			goto cleanup;
+		}
+
+		/* check buffer arrived in order (for tcp) */
+		this_recv =3D recv_buffs[cqe->flags >> 16];
+		for (j =3D 0; args->stream && j < cqe->res / 4; j++) {
+			int sent =3D *at++;
+			int recv =3D *this_recv++;
+
+			if (sent !=3D recv) {
+				fprintf(stderr, "recv=3D%d sent=3D%d\n", recv, sent);
+				goto cleanup;
+			}
+		}
+	}
+
+	if (args->early_error =3D=3D ERROR_NONE && total_recv_bytes < total_sen=
t_bytes) {
+		fprintf(stderr,
+			"missing recv: recv=3D%d sent=3D%d\n", total_recv_bytes, total_sent_b=
ytes);
+		goto cleanup;
+	}
+
+	/* check the final one */
+	cqe =3D &recv_cqe[recv_cqes-1];
+
+	ret =3D 0;
+cleanup:
+	for (i =3D 0; i < ARRAY_SIZE(recv_buffs); i++)
+		free(recv_buffs[i]);
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring);
+
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+	int loop;
+
+	if (argc > 1)
+		return 0;
+
+	for (loop =3D 0; loop < 32; loop++) {
+		struct args a =3D {
+			.early_error =3D loop & 0x03,
+			.stream =3D loop & 0x04,
+			.recvmsg =3D loop & 0x08,
+			.wait_each =3D loop & 0x10,
+		};
+		ret =3D test(&a);
+		if (ret) {
+			fprintf(stderr,
+				"test stream=3D%d recvmsg=3D%d wait_each=3D%d early_error=3D%d faile=
d\n",
+				a.stream, a.recvmsg, a.wait_each, a.early_error);
+			return ret;
+		}
+	}
+	return 0;
+}
--=20
2.30.2

