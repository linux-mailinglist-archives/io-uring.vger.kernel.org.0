Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55C05E7E1B
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 17:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiIWPUQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 11:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIWPUL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 11:20:11 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B699DA7A9B
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 08:20:09 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28N2cG4L028049
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 08:20:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Vt6+xcno16DPXIy0VsLATJV5+BZjFElXkNPf5XRiPsk=;
 b=E+/I3dnRRdEgnRUzmeQGdq9o1f1izDYDw7m+SZ/emA/tAykwWv56s7N9a5hP1RpNwKFy
 yj2p7jkaH0SO88g7X7nhiHt03dmHQPDmilFP4rw29NZ3Qrs8y4Q1P7t5W4T3tzmv56M6
 NImo2N6IG4kGWjrOguPte6kcx65cu2iE6lo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3js46guqk9-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 08:20:08 -0700
Received: from twshared3888.09.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 08:19:29 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id ADD426951ECD; Fri, 23 Sep 2022 08:19:18 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>,
        <syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com>
Subject: [PATCH liburing] test invalid sendmsg and recvmsg
Date:   Fri, 23 Sep 2022 08:18:58 -0700
Message-ID: <20220923151858.968528-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4M08DF7Qafyun97hOsiE62EK-hcuQh4T
X-Proofpoint-GUID: 4M08DF7Qafyun97hOsiE62EK-hcuQh4T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_04,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Syzbot found a double free bug due to failure in sendmsg.
This test exposes the bug.

Reported-by: syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/send_recv.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/test/send_recv.c b/test/send_recv.c
index a7b001aa0d6e..3eb31afa0e63 100644
--- a/test/send_recv.c
+++ b/test/send_recv.c
@@ -257,6 +257,47 @@ static int test(int use_sqthread, int regfiles)
 	return (intptr_t)retval;
 }
=20
+static int test_invalid(void)
+{
+	struct io_uring ring;
+	int ret, i;
+	int fds[2];
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+
+	ret =3D t_create_ring(8, &ring, 0);
+	if (ret)
+		return ret;
+
+	ret =3D t_create_socket_pair(fds, true);
+	if (ret)
+		return ret;
+
+	sqe =3D io_uring_get_sqe(&ring);
+	io_uring_prep_sendmsg(sqe, fds[0], NULL, MSG_WAITALL);
+	sqe->flags |=3D IOSQE_ASYNC;
+
+	sqe =3D io_uring_get_sqe(&ring);
+	io_uring_prep_recvmsg(sqe, fds[1], NULL, 0);
+	sqe->flags |=3D IOSQE_ASYNC;
+
+	ret =3D io_uring_submit_and_wait(&ring, 2);
+	if (ret !=3D 2)
+		return ret;
+
+	for (i =3D 0; i < 2; i++) {
+		ret =3D io_uring_peek_cqe(&ring, &cqe);
+		if (ret || cqe->res !=3D -EFAULT)
+			return -1;
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	io_uring_queue_exit(&ring);
+	close(fds[0]);
+	close(fds[1]);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
@@ -264,6 +305,12 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return 0;
=20
+	ret =3D test_invalid();
+	if (ret) {
+		fprintf(stderr, "test_invalid failed\n");
+		return ret;
+	}
+
 	ret =3D test(0, 0);
 	if (ret) {
 		fprintf(stderr, "test sqthread=3D0 failed\n");

base-commit: d251ed9d6c8acc5037e1c4e124d03c1f95a9ca6d
--=20
2.30.2

