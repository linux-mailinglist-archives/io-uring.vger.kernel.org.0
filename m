Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25FB50BC78
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353999AbiDVQEv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 12:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358387AbiDVQEu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 12:04:50 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E765BE5D
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:57 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23MBr8HW004687
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fSGs6eEPffIdFJ5xIrJCFong3VkIDjVHenYBkcoEx5A=;
 b=UFIwwYpzBTHdvrNHf3LuPNo27WRWx6zjGs+f0PuHPBZ46/DSWXX8SNRozG+nPzy80mNO
 HUWSxra5f8Ce3Kj3QTU90G2bo9QN541wb33Yy2GoE5ihgGAF6sRBOAziyCoMyHNDqYGR
 PVtoUaoKRkcrGN7keMFdrHRRpymQzbIIdAo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fkuvh1g16-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 09:01:56 -0700
Received: from twshared41237.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 22 Apr 2022 09:01:55 -0700
Received: by devbig039.lla1.facebook.com (Postfix, from userid 572232)
        id 9244B7E01537; Fri, 22 Apr 2022 09:01:40 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v2 2/7] test: use unique path for socket
Date:   Fri, 22 Apr 2022 09:01:27 -0700
Message-ID: <20220422160132.2891927-3-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220422160132.2891927-1-dylany@fb.com>
References: <20220422160132.2891927-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: nSyvZuSdGyjclNPhj7t__ufzadzFBIIj
X-Proofpoint-ORIG-GUID: nSyvZuSdGyjclNPhj7t__ufzadzFBIIj
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

Do not collide if multiple tests are running at once.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 test/accept-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/accept-test.c b/test/accept-test.c
index 71d9d80..4a904e4 100644
--- a/test/accept-test.c
+++ b/test/accept-test.c
@@ -35,7 +35,7 @@ int main(int argc, char *argv[])
=20
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family =3D AF_UNIX;
-	memcpy(addr.sun_path, "\0sock", 6);
+	memcpy(addr.sun_path, "\0sock2", 7);
=20
 	ret =3D bind(fd, (struct sockaddr *)&addr, addrlen);
 	assert(ret !=3D -1);
--=20
2.30.2

