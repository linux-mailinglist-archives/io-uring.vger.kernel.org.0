Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A375AD3D0
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbiIENZB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbiIENZA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:25:00 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4567715726
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:24:59 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 285BkDnY009235
        for <io-uring@vger.kernel.org>; Mon, 5 Sep 2022 06:24:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=xQsdTa8TgbkhagguoxnaKU57QbO73paFepvRMH2t8WM=;
 b=oeR69H0xfS0bSLHxXUigeR76/8vS/vBmsSa3qFuAYLdIgppXMMSdqoPr0ZI1VM0/OrPM
 LV3HqEEWeLEE0/rL+VhJozyXd62gdCx2xk9L6KaoGE2Up4h4LjbYnm8DIjQZpiy1lm4g
 k5JsoBGf5gBP3iZc2Z6PBwDzbvnYAOptTyA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jc2kx0wn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 06:24:58 -0700
Received: from twshared3888.09.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Sep 2022 06:24:57 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 268935AC5170; Mon,  5 Sep 2022 06:24:50 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v3 04/11] add a t_probe_defer_taskrun helper function for tests
Date:   Mon, 5 Sep 2022 06:22:51 -0700
Message-ID: <20220905132258.1858915-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220905132258.1858915-1-dylany@fb.com>
References: <20220905132258.1858915-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: YkW_IyWLTTRb6wDjWImbJ6d6uzuRH1HB
X-Proofpoint-GUID: YkW_IyWLTTRb6wDjWImbJ6d6uzuRH1HB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-05_09,2022-09-05_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Help tests to determine if they can use IORING_SETUP_DEFER_TASKRUN

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/helpers.c | 17 +++++++++++++++--
 test/helpers.h |  2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/test/helpers.c b/test/helpers.c
index 4d5c402f8fb2..8fb32b8fa982 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -75,7 +75,7 @@ static void __t_create_file(const char *file, size_t si=
ze, char pattern)
 {
 	ssize_t ret;
 	char *buf;
-	int fd;=20
+	int fd;
=20
 	buf =3D t_malloc(size);
 	memset(buf, pattern, size);
@@ -112,7 +112,7 @@ struct iovec *t_create_buffers(size_t buf_num, size_t=
 buf_size)
 	vecs =3D t_malloc(buf_num * sizeof(struct iovec));
 	for (i =3D 0; i < buf_num; i++) {
 		t_posix_memalign(&vecs[i].iov_base, buf_size, buf_size);
-		vecs[i].iov_len =3D buf_size;=20
+		vecs[i].iov_len =3D buf_size;
 	}
 	return vecs;
 }
@@ -253,3 +253,16 @@ errno_cleanup:
 	close(fd[1]);
 	return ret;
 }
+
+bool t_probe_defer_taskrun(void)
+{
+	struct io_uring ring;
+	int ret;
+
+	ret =3D io_uring_queue_init(1, &ring, IORING_SETUP_SINGLE_ISSUER |
+					    IORING_SETUP_DEFER_TASKRUN);
+	if (ret < 0)
+		return false;
+	io_uring_queue_exit(&ring);
+	return true;
+}
diff --git a/test/helpers.h b/test/helpers.h
index 9ad99472b288..5e9bb2613ab2 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -82,6 +82,8 @@ enum t_setup_ret t_register_buffers(struct io_uring *ri=
ng,
 				    const struct iovec *iovecs,
 				    unsigned nr_iovecs);
=20
+bool t_probe_defer_taskrun(void);
+
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
=20
 #ifdef __cplusplus
--=20
2.30.2

