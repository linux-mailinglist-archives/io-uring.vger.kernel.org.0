Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CDC5783C3
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 15:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiGRNet (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jul 2022 09:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGRNet (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jul 2022 09:34:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C9319C17
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 06:34:48 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26HNs71Q017139
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 06:34:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=skKW5lecG5UJMyYQlcRl3AZpJeI32OEzD6WreotObqg=;
 b=EU5gUlhTGOd6Ox1vkrkz7kOhucAX17gehdWRVC2T9Nulj7EeB20ZsxYHdhpnrBOwvIcd
 HvkkE/BWQaRAQrs5sLYbiXV57HWjg4RELxAeQKmKpVReToBs9xb6ybzzF+je8VgZzJ3J
 asuHOsU5AOfA8E3fz27C4C+Q65qUpj967MA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hbtetgw91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 18 Jul 2022 06:34:48 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub203.TheFacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 18 Jul 2022 06:34:47 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 18 Jul 2022 06:34:47 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 259B13319DD8; Mon, 18 Jul 2022 06:34:36 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing] fix io_uring_recvmsg_cmsg_nexthdr logic
Date:   Mon, 18 Jul 2022 06:34:29 -0700
Message-ID: <20220718133429.726628-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: imGtum2gjjvwJYNjuCfguqJOoodAnVeM
X-Proofpoint-ORIG-GUID: imGtum2gjjvwJYNjuCfguqJOoodAnVeM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_12,2022-07-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_recvmsg_cmsg_nexthdr was using the payload to delineate the end
of the cmsg list, but really it needs to use whatever was returned by the
kernel.

Reported-by: Jens Axboe <axboe@kernel.dk>
Fixes: 874406f ("add multishot recvmsg API")
Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 src/include/liburing.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 583b917..fc7613d 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -745,7 +745,8 @@ io_uring_recvmsg_cmsg_nexthdr(struct io_uring_recvmsg=
_out *o, struct msghdr *m,
=20
 	if (cmsg->cmsg_len < sizeof(struct cmsghdr))
 		return NULL;
-	end =3D (unsigned char *) io_uring_recvmsg_payload(o, m);
+	end =3D (unsigned char *) io_uring_recvmsg_cmsg_firsthdr(o, m) +
+		o->controllen;
 	cmsg =3D (struct cmsghdr *)((unsigned char *) cmsg +
 			CMSG_ALIGN(cmsg->cmsg_len));
=20
--=20
2.30.2

