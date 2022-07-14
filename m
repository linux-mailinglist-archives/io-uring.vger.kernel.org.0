Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5534A574C80
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 13:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238360AbiGNLyp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 07:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiGNLyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 07:54:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038FA3193D
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 04:54:44 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E6xUH6031151
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 04:54:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=EQhqim7b0p6f5vQfy63CHRO9xufuvE8bKUE/IYStGXI=;
 b=aaNv8Jqh8DPy6dXQOR3u5GC9gB9IROVVxLH8VekMdYxF4Iq1GyVsjcVloOZ2+6tge8fX
 d2hFiVtQKaWaMF7DBAFW71ydyI7qAYfDnH0w/ajwOLpant8JefdkizFSECYeGrpvFgSU
 vUDQomJfYvG0M9ZtL/kpKSZ9hDYY9o4xzZE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hae0w19kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 04:54:43 -0700
Received: from twshared25478.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 14 Jul 2022 04:54:42 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A2F792FD10D0; Thu, 14 Jul 2022 04:54:31 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH RFC v2 liburing 2/2] add tests for multishot recvmsg
Date:   Thu, 14 Jul 2022 04:54:28 -0700
Message-ID: <20220714115428.1569612-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220714115428.1569612-1-dylany@fb.com>
References: <20220714115428.1569612-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: By_H7WVzIjDhnGZkUtb3xGEEvj5OYwXD
X-Proofpoint-ORIG-GUID: By_H7WVzIjDhnGZkUtb3xGEEvj5OYwXD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_08,2022-07-14_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Expand the multishot recv test to include recvmsg.
This also checks that sockaddr comes back, and that control messages work
properly.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/recv-multishot.c | 180 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 161 insertions(+), 19 deletions(-)

diff --git a/test/recv-multishot.c b/test/recv-multishot.c
index 9df8184..a322e43 100644
--- a/test/recv-multishot.c
+++ b/test/recv-multishot.c
@@ -27,20 +27,45 @@ enum early_error_t {
 struct args {
 	bool stream;
 	bool wait_each;
+	bool recvmsg;
 	enum early_error_t early_error;
 };
=20
+static int check_sockaddr(struct sockaddr_in *in)
+{
+	struct in_addr expected;
+
+	inet_pton(AF_INET, "127.0.0.1", &expected);
+	if (in->sin_family !=3D AF_INET) {
+		fprintf(stderr, "bad family %d\n", (int)htons(in->sin_family));
+		return -1;
+	}
+	if (memcmp(&expected, &in->sin_addr, sizeof(in->sin_addr))) {
+		char buff[256];
+		const char *addr =3D inet_ntop(AF_INET, &in->sin_addr, buff, sizeof(bu=
ff));
+
+		fprintf(stderr, "unexpected address %s\n", addr ? addr : "INVALID");
+		return -1;
+	}
+	return 0;
+}
+
 static int test(struct args *args)
 {
 	int const N =3D 8;
 	int const N_BUFFS =3D N * 64;
 	int const N_CQE_OVERFLOW =3D 4;
 	int const min_cqes =3D 2;
+	int const NAME_LEN =3D sizeof(struct sockaddr_storage);
+	int const CONTROL_LEN =3D CMSG_ALIGN(sizeof(struct sockaddr_storage))
+					+ sizeof(struct cmsghdr);
 	struct io_uring ring;
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
-	int fds[2], ret, i, j, total_sent_bytes =3D 0, total_recv_bytes =3D 0;
+	int fds[2], ret, i, j;
+	int total_sent_bytes =3D 0, total_recv_bytes =3D 0, total_dropped_bytes=
 =3D 0;
 	int send_buff[256];
+	int *sent_buffs[N_BUFFS];
 	int *recv_buffs[N_BUFFS];
 	int *at;
 	struct io_uring_cqe recv_cqe[N_BUFFS];
@@ -50,7 +75,7 @@ static int test(struct args *args)
 	struct __kernel_timespec timeout =3D {
 		.tv_sec =3D 1,
 	};
-
+	struct msghdr msg;
=20
 	memset(recv_buffs, 0, sizeof(recv_buffs));
=20
@@ -75,21 +100,42 @@ static int test(struct args *args)
 		return ret;
 	}
=20
+	if (!args->stream) {
+		bool val =3D true;
+
+		/* force some cmsgs to come back to us */
+		ret =3D setsockopt(fds[0], IPPROTO_IP, IP_RECVORIGDSTADDR, &val,
+				 sizeof(val));
+		if (ret) {
+			fprintf(stderr, "setsockopt failed %d\n", errno);
+			goto cleanup;
+		}
+	}
+
 	for (i =3D 0; i < ARRAY_SIZE(send_buff); i++)
 		send_buff[i] =3D i;
=20
 	for (i =3D 0; i < ARRAY_SIZE(recv_buffs); i++) {
 		/* prepare some different sized buffers */
-		int buffer_size =3D (i % 2 =3D=3D 0 && args->stream) ? 1 : N * sizeof(=
int);
+		int buffer_size =3D (i % 2 =3D=3D 0 && (args->stream || args->recvmsg)=
) ? 1 : N;
+
+		buffer_size *=3D sizeof(int);
+		if (args->recvmsg) {
+			buffer_size +=3D
+				sizeof(struct io_uring_recvmsg_out) +
+				NAME_LEN +
+				CONTROL_LEN;
+		}
=20
-		recv_buffs[i] =3D malloc(sizeof(*at) * buffer_size);
+		recv_buffs[i] =3D malloc(buffer_size);
=20
 		if (i > 2 && args->early_error =3D=3D ERROR_NOT_ENOUGH_BUFFERS)
 			continue;
=20
 		sqe =3D io_uring_get_sqe(&ring);
 		io_uring_prep_provide_buffers(sqe, recv_buffs[i],
-					buffer_size * sizeof(*recv_buffs[i]), 1, 7, i);
+					buffer_size, 1, 7, i);
+		memset(recv_buffs[i], 0xcc, buffer_size);
 		if (io_uring_submit_and_wait_timeout(&ring, &cqe, 1, &timeout, NULL) !=
=3D 0) {
 			fprintf(stderr, "provide buffers failed: %d\n", ret);
 			ret =3D -1;
@@ -99,7 +145,19 @@ static int test(struct args *args)
 	}
=20
 	sqe =3D io_uring_get_sqe(&ring);
-	io_uring_prep_recv_multishot(sqe, fds[0], NULL, 0, 0);
+	if (args->recvmsg) {
+		unsigned int flags =3D 0;
+
+		if (!args->stream)
+			flags |=3D MSG_TRUNC;
+
+		memset(&msg, 0, sizeof(msg));
+		msg.msg_namelen =3D NAME_LEN;
+		msg.msg_controllen =3D CONTROL_LEN;
+		io_uring_prep_recvmsg_multishot(sqe, fds[0], &msg, flags);
+	} else {
+		io_uring_prep_recv_multishot(sqe, fds[0], NULL, 0, 0);
+	}
 	sqe->flags |=3D IOSQE_BUFFER_SELECT;
 	sqe->buf_group =3D 7;
 	io_uring_sqe_set_data64(sqe, 1234);
@@ -111,6 +169,7 @@ static int test(struct args *args)
 		int to_send =3D sizeof(*at) * (i+1);
=20
 		total_sent_bytes +=3D to_send;
+		sent_buffs[i] =3D at;
 		if (send(fds[1], at, to_send, 0) !=3D to_send) {
 			if (early_error_started)
 				break;
@@ -202,9 +261,12 @@ static int test(struct args *args)
 			(args->early_error =3D=3D ERROR_EARLY_OVERFLOW &&
 			 !args->wait_each && i =3D=3D N_CQE_OVERFLOW);
 		int *this_recv;
+		int orig_payload_size =3D cqe->res;
=20
=20
 		if (should_be_last) {
+			int used_res =3D cqe->res;
+
 			if (!is_last) {
 				fprintf(stderr, "not last cqe had error %d\n", i);
 				goto cleanup;
@@ -234,7 +296,22 @@ static int test(struct args *args)
 				break;
 			case ERROR_NONE:
 			case ERROR_EARLY_CLOSE_SENDER:
-				if (cqe->res !=3D 0) {
+				if (args->recvmsg && (cqe->flags & IORING_CQE_F_BUFFER)) {
+					void *buff =3D recv_buffs[cqe->flags >> 16];
+					struct io_uring_recvmsg_out *o =3D
+						io_uring_recvmsg_validate(buff, cqe->res, &msg);
+
+					if (!o) {
+						fprintf(stderr, "invalid buff\n");
+						goto cleanup;
+					}
+					if (o->payloadlen !=3D 0) {
+						fprintf(stderr, "expected 0 payloadlen, got %u\n",
+							o->payloadlen);
+						goto cleanup;
+					}
+					used_res =3D 0;
+				} else if (cqe->res !=3D 0) {
 					fprintf(stderr, "early error: res %d\n", cqe->res);
 					goto cleanup;
 				}
@@ -254,7 +331,7 @@ static int test(struct args *args)
 				goto cleanup;
 			}
=20
-			if (cqe->res <=3D 0)
+			if (used_res <=3D 0)
 				continue;
 		} else {
 			if (!(cqe->flags & IORING_CQE_F_MORE)) {
@@ -268,7 +345,61 @@ static int test(struct args *args)
 			goto cleanup;
 		}
=20
+		this_recv =3D recv_buffs[cqe->flags >> 16];
+
+		if (args->recvmsg) {
+			struct io_uring_recvmsg_out *o =3D io_uring_recvmsg_validate(
+				this_recv, cqe->res, &msg);
+
+			if (!o) {
+				fprintf(stderr, "bad recvmsg\n");
+				goto cleanup;
+			}
+			orig_payload_size =3D o->payloadlen;
+
+			if (!args->stream) {
+				orig_payload_size =3D o->payloadlen;
+
+				struct cmsghdr *cmsg;
+
+				if (o->namelen < sizeof(struct sockaddr_in)) {
+					fprintf(stderr, "bad addr len %d",
+						o->namelen);
+					goto cleanup;
+				}
+				if (check_sockaddr((struct sockaddr_in *)io_uring_recvmsg_name(o)))
+					goto cleanup;
+
+				cmsg =3D io_uring_recvmsg_cmsg_firsthdr(o, &msg);
+				if (!cmsg ||
+				    cmsg->cmsg_level !=3D IPPROTO_IP ||
+				    cmsg->cmsg_type !=3D IP_RECVORIGDSTADDR) {
+					fprintf(stderr, "bad cmsg");
+					goto cleanup;
+				}
+				if (check_sockaddr((struct sockaddr_in *)CMSG_DATA(cmsg)))
+					goto cleanup;
+				cmsg =3D io_uring_recvmsg_cmsg_nexthdr(o, &msg, cmsg);
+				if (cmsg) {
+					fprintf(stderr, "unexpected extra cmsg\n");
+					goto cleanup;
+				}
+
+			}
+
+			this_recv =3D (int *)io_uring_recvmsg_payload(o, &msg);
+			cqe->res =3D io_uring_recvmsg_payload_length(o, cqe->res, &msg);
+			if (o->payloadlen !=3D cqe->res) {
+				if (!(o->flags & MSG_TRUNC)) {
+					fprintf(stderr, "expected truncated flag\n");
+					goto cleanup;
+				}
+				total_dropped_bytes +=3D (o->payloadlen - cqe->res);
+			}
+		}
+
 		total_recv_bytes +=3D cqe->res;
+
 		if (cqe->res % 4 !=3D 0) {
 			/*
 			 * doesn't seem to happen in practice, would need some
@@ -278,9 +409,20 @@ static int test(struct args *args)
 			goto cleanup;
 		}
=20
-		/* check buffer arrived in order (for tcp) */
-		this_recv =3D recv_buffs[cqe->flags >> 16];
-		for (j =3D 0; args->stream && j < cqe->res / 4; j++) {
+		/*
+		 * for tcp: check buffer arrived in order
+		 * for udp: based on size validate data based on size
+		 */
+		if (!args->stream) {
+			int sent_idx =3D orig_payload_size / sizeof(*at) - 1;
+
+			if (sent_idx < 0 || sent_idx > N) {
+				fprintf(stderr, "Bad sent idx: %d\n", sent_idx);
+				goto cleanup;
+			}
+			at =3D sent_buffs[sent_idx];
+		}
+		for (j =3D 0; j < cqe->res / 4; j++) {
 			int sent =3D *at++;
 			int recv =3D *this_recv++;
=20
@@ -291,15 +433,14 @@ static int test(struct args *args)
 		}
 	}
=20
-	if (args->early_error =3D=3D ERROR_NONE && total_recv_bytes < total_sen=
t_bytes) {
+	if (args->early_error =3D=3D ERROR_NONE &&
+	    total_recv_bytes + total_dropped_bytes < total_sent_bytes) {
 		fprintf(stderr,
-			"missing recv: recv=3D%d sent=3D%d\n", total_recv_bytes, total_sent_b=
ytes);
+			"missing recv: recv=3D%d dropped=3D%d sent=3D%d\n",
+			total_recv_bytes, total_sent_bytes, total_dropped_bytes);
 		goto cleanup;
 	}
=20
-	/* check the final one */
-	cqe =3D &recv_cqe[recv_cqes-1];
-
 	ret =3D 0;
 cleanup:
 	for (i =3D 0; i < ARRAY_SIZE(recv_buffs); i++)
@@ -320,18 +461,19 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return T_EXIT_SKIP;
=20
-	for (loop =3D 0; loop < 4; loop++) {
+	for (loop =3D 0; loop < 8; loop++) {
 		struct args a =3D {
 			.stream =3D loop & 0x01,
 			.wait_each =3D loop & 0x2,
+			.recvmsg =3D loop & 0x04,
 		};
 		for (early_error =3D 0; early_error < ERROR_EARLY_LAST; early_error++)=
 {
 			a.early_error =3D (enum early_error_t)early_error;
 			ret =3D test(&a);
 			if (ret) {
 				fprintf(stderr,
-					"test stream=3D%d wait_each=3D%d early_error=3D%d failed\n",
-					a.stream, a.wait_each, a.early_error);
+					"test stream=3D%d wait_each=3D%d recvmsg=3D%d early_error=3D%d fail=
ed\n",
+					a.stream, a.wait_each, a.recvmsg, a.early_error);
 				return T_EXIT_FAIL;
 			}
 			if (no_recv_mshot)
--=20
2.30.2

