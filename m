Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65B7592FBE
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbiHONVX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbiHONVW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:21:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D2717A8C
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:20 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27F4cI3H008379
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8IMoy5YhFItspIbZv9amYbOYgZLW19eI6cJ3b/bOp2U=;
 b=iRM1q/mJHeMkxY8azfDJBliBR2E479svq73aPrwcQSy3y34G6Ee5r77pzkUexyr7xeir
 Q9+/q8E6XVFRE3Of7nzg/04xtgQ/akL8hwhARDKa/Om5lN1n8qj/TKjuAs8Uh665fhQq
 mJGkcI9bliAWZ7tgTDVMW5pTESUN5LIgDD8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hx7f8tm7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:21:19 -0700
Received: from twshared25684.07.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 06:21:19 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 1640949B72E0; Mon, 15 Aug 2022 06:09:55 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 03/11] add a t_probe_defer_taskrun helper function for tests
Date:   Mon, 15 Aug 2022 06:09:39 -0700
Message-ID: <20220815130947.1002152-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815130947.1002152-1-dylany@fb.com>
References: <20220815130947.1002152-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: GFRzMg18t0PVAZS8nz2gYFC0aMP1I4no
X-Proofpoint-ORIG-GUID: GFRzMg18t0PVAZS8nz2gYFC0aMP1I4no
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
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
 test/helpers.c | 12 ++++++++++++
 test/helpers.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/test/helpers.c b/test/helpers.c
index 014653313f41..12ae727accef 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -235,3 +235,15 @@ errno_cleanup:
 	close(fd[1]);
 	return ret;
 }
+
+bool t_probe_defer_taskrun(void)
+{
+	struct io_uring ring;
+	int ret;
+
+	ret =3D io_uring_queue_init(1, &ring, IORING_SETUP_DEFER_TASKRUN);
+	if (ret < 0)
+		return false;
+	io_uring_queue_exit(&ring);
+	return true;
+}
diff --git a/test/helpers.h b/test/helpers.h
index 6d5726c9deb6..efce4b344f87 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -75,6 +75,8 @@ enum t_setup_ret t_register_buffers(struct io_uring *ri=
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

