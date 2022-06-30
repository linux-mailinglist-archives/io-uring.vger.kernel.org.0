Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D601562095
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 18:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbiF3QuB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 12:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbiF3QuA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 12:50:00 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442E5338B1
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:49:59 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25U9O6gB005950
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:49:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BgsJG9kFUEMe2IR+vcew8VN1c9zibc9zH6+/i3pXAsw=;
 b=jkeZrA3dH2m65GQsZxmOQDF0fpvDpH/TFP8JqbGdUuwCyV2fF0sENcBT2IcA+4NQzyd5
 ZM0rrQOd8dBKJxPkPIuMyPItKHhdMxi5LOmY13S4jwFguG7VbqKf7ufVtxpBBOFmJvWW
 9FXBh2ySNx+cPMqxryuQ1vYxBuAYCql2Avo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3h195a2w8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 09:49:58 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub204.TheFacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 09:49:57 -0700
Received: from twshared18317.08.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 09:49:56 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id AE84825D4D25; Thu, 30 Jun 2022 09:49:27 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <kernel-team@fb.com>,
        "Dylan Yudaken" <dylany@fb.com>
Subject: [PATCH v3 liburing 5/7] add recv-multishot test
Date:   Thu, 30 Jun 2022 09:49:16 -0700
Message-ID: <20220630164918.3958710-6-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630164918.3958710-1-dylany@fb.com>
References: <20220630164918.3958710-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: -n-ma4hnEwbH2HSnDpI7gMXNrmAzMfMU
X-Proofpoint-ORIG-GUID: -n-ma4hnEwbH2HSnDpI7gMXNrmAzMfMU
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

add a test for multishot receive functionality

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/Makefile         |   1 +
 test/recv-multishot.c | 343 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 344 insertions(+)
 create mode 100644 test/recv-multishot.c

diff --git a/test/Makefile b/test/Makefile
index ad47d2d..e718583 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -125,6 +125,7 @@ test_srcs :=3D \
 	read-write.c \
 	recv-msgall.c \
 	recv-msgall-stream.c \
+	recv-multishot.c \
 	register-restrictions.c \
 	rename.c \
 	ringbuf-read.c \
diff --git a/test/recv-multishot.c b/test/recv-multishot.c
new file mode 100644
index 0000000..e91f585
--- /dev/null
+++ b/test/recv-multishot.c
@@ -0,0 +1,343 @@
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
+	ERROR_NOT_ENOUGH_BUFFERS,
+	ERROR_EARLY_CLOSE_SENDER,
+	ERROR_EARLY_CLOSE_RECEIVER,
+	ERROR_EARLY_OVERFLOW,
+	ERROR_EARLY_LAST
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
+	int const N_CQE_OVERFLOW =3D 4;
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
+	if (args->early_error =3D=3D ERROR_EARLY_OVERFLOW) {
+		struct io_uring_params params =3D {
+			.flags =3D IORING_SETUP_CQSIZE,
+			.cq_entries =3D N_CQE_OVERFLOW
+		};
+
+		ret =3D io_uring_queue_init_params(N_CQE_OVERFLOW, &ring, &params);
+	} else {
+		ret =3D io_uring_queue_init(32, &ring, 0);
+	}
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
+		io_uring_prep_recvmsg_multishot(sqe, fds[0], &msg, 0);
+	} else {
+		io_uring_prep_recv_multishot(sqe, fds[0], NULL, 0, 0);
+	}
+	sqe->flags |=3D IOSQE_BUFFER_SELECT;
+	sqe->buf_group =3D 7;
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
+		cqe =3D &recv_cqe[i];
+
+		bool const is_last =3D i =3D=3D recv_cqes - 1;
+
+		bool const should_be_last =3D
+			(cqe->res <=3D 0) ||
+			(args->stream && is_last) ||
+			(args->early_error =3D=3D ERROR_EARLY_OVERFLOW &&
+			 !args->wait_each && i =3D=3D N_CQE_OVERFLOW);
+		int *this_recv;
+
+
+		if (should_be_last) {
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
+			case ERROR_EARLY_OVERFLOW:
+				if (cqe->res < 0) {
+					fprintf(stderr,
+						"ERROR_EARLY_OVERFLOW: res %d\n", cqe->res);
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
+			case ERROR_EARLY_LAST:
+				fprintf(stderr, "bad error_early\n");
+				goto cleanup;
+			};
+
+			if (cqe->res <=3D 0 && cqe->flags & IORING_CQE_F_BUFFER) {
+				fprintf(stderr, "final BUFFER flag set\n");
+				goto cleanup;
+			}
+
+			if (cqe->flags & IORING_CQE_F_MORE) {
+				fprintf(stderr, "final MORE flag set\n");
+				goto cleanup;
+			}
+
+			if (cqe->res <=3D 0)
+				continue;
+		} else {
+			if (!(cqe->flags & IORING_CQE_F_MORE)) {
+				fprintf(stderr, "MORE flag not set\n");
+				goto cleanup;
+			}
+		}
+
+		if (!(cqe->flags & IORING_CQE_F_BUFFER)) {
+			fprintf(stderr, "BUFFER flag not set\n");
+			goto cleanup;
+		}
+
+		total_recv_bytes +=3D cqe->res;
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
+	int early_error =3D 0;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	for (loop =3D 0; loop < 7; loop++) {
+		struct args a =3D {
+			.stream =3D loop & 0x01,
+			.recvmsg =3D loop & 0x02,
+			.wait_each =3D loop & 0x4,
+		};
+		for (early_error =3D 0; early_error < ERROR_EARLY_LAST; early_error++)=
 {
+			a.early_error =3D (enum early_error_t)early_error;
+			ret =3D test(&a);
+			if (ret) {
+				fprintf(stderr,
+					"test stream=3D%d recvmsg=3D%d wait_each=3D%d early_error=3D%d fail=
ed\n",
+					a.stream, a.recvmsg, a.wait_each, a.early_error);
+				return T_EXIT_FAIL;
+			}
+		}
+	}
+
+	return T_EXIT_PASS;
+}
--=20
2.30.2

