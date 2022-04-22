Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EBF50BC75
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354566AbiDVQEz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 12:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355269AbiDVQEw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 12:04:52 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E795676B
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:58 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 23MFR6iN017738
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+CMYUwIy0ADLCyzRaPQCP3M911g2i8eQE9gvJ5GkkcM=;
 b=O652INoP8QLLAXS2sImQm2Z5L+MsQsh0XzO4sNbk+HxTk1RkQmPrkBtB2Gn5aKnMNmlF
 +zGyRd+GGLuY72iVN+y7V4mbi8LUhq1xQViktVzenQzDQkOT3HkTmL9/cx2nZ4wqszYR
 fpAOP/BEdAcO0xWKbOHsOF+eH5HJ9yvTaZ4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fkc2vep3d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:57 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Apr 2022 09:01:55 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 2DD237E01535; Fri, 22 Apr 2022 09:01:40 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 1/7] test: handle mmap return failures in pollfree test
Date:   Fri, 22 Apr 2022 09:01:26 -0700
Message-ID: <20220422160132.2891927-2-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220422160132.2891927-1-dylany@fb.com>
References: <20220422160132.2891927-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: DVSKPTHxKtGVbh94A55ffgENh2aVWWYf
X-Proofpoint-ORIG-GUID: DVSKPTHxKtGVbh94A55ffgENh2aVWWYf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_04,2022-04-22_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sometimes these mmap's fail, and it causes SEGFAULTS.
I assume this was accidentally left off when this was originally landed.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/pollfree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/pollfree.c b/test/pollfree.c
index e2511df..d753ffe 100644
--- a/test/pollfree.c
+++ b/test/pollfree.c
@@ -406,10 +406,10 @@ int main(int argc, char *argv[])
   ret =3D mmap((void *)0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
   if (ret =3D=3D MAP_FAILED)
     return 0;
-  mmap((void *)0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
+  ret =3D mmap((void *)0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
   if (ret =3D=3D MAP_FAILED)
     return 0;
-  mmap((void *)0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
+  ret =3D mmap((void *)0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
   if (ret =3D=3D MAP_FAILED)
     return 0;
   loop();
--=20
2.30.2

