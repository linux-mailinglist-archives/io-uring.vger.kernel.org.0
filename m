Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561B55933D9
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 19:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiHORJd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 13:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiHORJc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 13:09:32 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A427527B1F
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 10:09:31 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FBOVZV007753
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 10:09:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=HnWsEyICVZdmWkyPKqdrWkSBy+duAZhGoHPaEwTlAts=;
 b=Dx0nWKY6EF+Flb1UKUQ7tokkC6FYMPTzq73tTDziMaBL9qwkqpLT7OENHwRzqtWEQM0g
 QLrRBStYon0UEFr7AJgzE7PtGW+k111BBOkow4ioMKj+sW5wodqP2LRpYa0Ncdziif68
 faspN+pGMVTRp3Wpy+suHIJ4gdzCdI+uY1o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hyn83t6re-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 10:09:30 -0700
Received: from twshared6324.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 10:09:27 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id BE84749E2E57; Mon, 15 Aug 2022 10:09:20 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] handle buffered writes in read-write test
Date:   Mon, 15 Aug 2022 10:09:14 -0700
Message-ID: <20220815170914.3094167-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: _o4Npz3W2jT4JYOGrdDHDCWbNdorJd8h
X-Proofpoint-GUID: _o4Npz3W2jT4JYOGrdDHDCWbNdorJd8h
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

When buffered writes are used then two things change:
1 - signals will propogate to the submit() call (as they would be
effectively ignored when going async)
2 - CQE ordering will change

Fix the read-write for both of these cases by ignoring the signal and
handling CQE ordering.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/read-write.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/test/read-write.c b/test/read-write.c
index c5cc469f258d..f50e8242afa4 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -759,6 +759,7 @@ static int test_write_efbig(void)
 			goto err;
 		}
 		io_uring_prep_writev(sqe, fd, &vecs[i], 1, off);
+		io_uring_sqe_set_data64(sqe, i);
 		off +=3D BS;
 	}
=20
@@ -774,7 +775,7 @@ static int test_write_efbig(void)
 			fprintf(stderr, "wait_cqe=3D%d\n", ret);
 			goto err;
 		}
-		if (i < 16) {
+		if (cqe->user_data < 16) {
 			if (cqe->res !=3D BS) {
 				fprintf(stderr, "bad write: %d\n", cqe->res);
 				goto err;
@@ -819,6 +820,8 @@ int main(int argc, char *argv[])
 		t_create_file(fname, FILE_SIZE);
 	}
=20
+	signal(SIGXFSZ, SIG_IGN);
+
 	vecs =3D t_create_buffers(BUFFERS, BS);
=20
 	/* if we don't have nonvec read, skip testing that */

base-commit: 15cc446cb8b0caa5c939423d31182eba66141539
--=20
2.30.2

