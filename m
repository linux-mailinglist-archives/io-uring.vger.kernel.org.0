Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B24AE50B669
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 13:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447158AbiDVLvk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 07:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447161AbiDVLvj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 07:51:39 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AF34505C
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:46 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23M0bCoL022202
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Y97cttDG1kcfx2CU8scC7NBTd5KmpGDwARAh4Y2LmEs=;
 b=fc5KzfRCYHdUxHT7kara/PNHwl0MNCFCdCJFdnnSho2QATzXqIRG64UZTlbmS3hodEwV
 5yPEYvYSlp66l5SGfeR6fcjMFGGXNQgjktfmDQB3U6dYnEiA0RVaGm1mFkE43R0cEh5a
 lz7GKCdPF9qkqjqoe9GifNWqLvyVHHKNhUw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fkhyr2q6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 04:48:46 -0700
Received: from twshared6486.05.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Apr 2022 04:48:45 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 975DC7DC56B5; Fri, 22 Apr 2022 04:48:31 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing 4/7] test: use unique filenames
Date:   Fri, 22 Apr 2022 04:48:12 -0700
Message-ID: <20220422114815.1124921-5-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220422114815.1124921-1-dylany@fb.com>
References: <20220422114815.1124921-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: M9KA_jUjKI8v2AxTaFfbivQYt3h34OjE
X-Proofpoint-ORIG-GUID: M9KA_jUjKI8v2AxTaFfbivQYt3h34OjE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_03,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Allow tests to be run in parallel

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/openat2.c       | 6 +++---
 test/sq-poll-dup.c   | 2 +-
 test/sq-poll-share.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/test/openat2.c b/test/openat2.c
index 379c61e..34c0f85 100644
--- a/test/openat2.c
+++ b/test/openat2.c
@@ -246,12 +246,12 @@ int main(int argc, char *argv[])
 	}
=20
 	if (argc > 1) {
-		path =3D "/tmp/.open.close";
+		path =3D "/tmp/.open.at2";
 		path_rel =3D argv[1];
 		do_unlink =3D 0;
 	} else {
-		path =3D "/tmp/.open.close";
-		path_rel =3D ".open.close";
+		path =3D "/tmp/.open.at2";
+		path_rel =3D ".open.at2";
 		do_unlink =3D 1;
 	}
=20
diff --git a/test/sq-poll-dup.c b/test/sq-poll-dup.c
index 0076a31..6a72b82 100644
--- a/test/sq-poll-dup.c
+++ b/test/sq-poll-dup.c
@@ -164,7 +164,7 @@ int main(int argc, char *argv[])
 	if (argc > 1) {
 		fname =3D argv[1];
 	} else {
-		fname =3D ".basic-rw";
+		fname =3D ".basic-rw-poll-dup";
 		t_create_file(fname, FILE_SIZE);
 	}
=20
diff --git a/test/sq-poll-share.c b/test/sq-poll-share.c
index 2f1c1dd..7bb7626 100644
--- a/test/sq-poll-share.c
+++ b/test/sq-poll-share.c
@@ -82,7 +82,7 @@ int main(int argc, char *argv[])
 	if (argc > 1) {
 		fname =3D argv[1];
 	} else {
-		fname =3D ".basic-rw";
+		fname =3D ".basic-rw-poll-share";
 		t_create_file(fname, FILE_SIZE);
 	}
=20
--=20
2.30.2

