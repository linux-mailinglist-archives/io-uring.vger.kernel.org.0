Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A625EBFA2
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 12:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiI0KWX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 06:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiI0KWU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 06:22:20 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EF8D588F
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 03:22:17 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28RA7lqG003283
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 03:22:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+SRcvzb41Rtgh4x4PJiua4BGylv2A3kiLeZ/7CPzzhs=;
 b=OIuqPf7Bl5viJ79WABiJhq8cbotR+eZ2OURzfe6Ftp2PuiGHekKJ2wLnOTFolkSGtZGN
 JxmPVXTeXekLbB8hD/xG6fzahXKYy9SbDYCSZM2UPC+ZWUg9d8fsKYScmw649+BrfkCW
 kqr0fqp1Ur7RKU86Lgn3jewrEh5fshBIvVA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jsyn09se0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 03:22:17 -0700
Received: from twshared3028.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 03:22:16 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 2CACA6B9F4CD; Tue, 27 Sep 2022 03:22:05 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 3/3] give open-direct-pick.c a unique path
Date:   Tue, 27 Sep 2022 03:22:02 -0700
Message-ID: <20220927102202.69069-4-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220927102202.69069-1-dylany@fb.com>
References: <20220927102202.69069-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 1Y_9jqc9KWI1TBVZShRkTN-_MC9NH-uN
X-Proofpoint-ORIG-GUID: 1Y_9jqc9KWI1TBVZShRkTN-_MC9NH-uN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_03,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This was making make runtest-parallel flaky

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/open-direct-pick.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/open-direct-pick.c b/test/open-direct-pick.c
index b1597e73231e..a1edf8464dc8 100644
--- a/test/open-direct-pick.c
+++ b/test/open-direct-pick.c
@@ -158,7 +158,7 @@ int main(int argc, char *argv[])
 		return 0;
 	}
=20
-	path =3D "/tmp/.open.close";
+	path =3D "/tmp/.open.direct.pick";
 	t_create_file(path, 4096);
=20
 	ret =3D test_openat(&ring, path);
--=20
2.30.2

