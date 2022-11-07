Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D7661FC6E
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 19:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiKGSAH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 13:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbiKGR7p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 12:59:45 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B5B2A962
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 09:56:22 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7Glixq007970
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 09:56:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=IrY4FfXRGP3pHaS7CSwjdJr9fKO0nPIkNCwM9wSvb68=;
 b=mWEUF2nkXD3j+I+tgK86OdnSPMhwn1i9moNNp1lJzMS4nR2EaWLCnns6NiNVX4NGKeRj
 CIOxnufDsrElrXJeksU/asCbU+JUVxHmdM8otUvvYKZF2FnW+96rZ2sfkEHawKheQ4iD
 BOH5UocvIa6ojjG8kayoefJwp+yxMr1oWopl1wttJ0b0EFSq8BBBQb/m4FlMeMjrBvLc
 GUgnCg2mC0B1lUEbne08RiZEG6/nYkVwTCevTc6PI5SHx7W5TDdNJ/e8PQx4i5e9Jf0h
 jm5IeiRH4IGDpYIwWLDCA1KMIpcsIG3t30LGpq/lKuCh3ULlqyTGuP07AR9ESfKohzwA dw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knmxss1mw-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 09:56:21 -0800
Received: from twshared27579.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 09:56:19 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id B1BA2ADF1C9E; Mon,  7 Nov 2022 09:56:11 -0800 (PST)
From:   Keith Busch <kbusch@meta.com>
To:     <viro@zeniv.linux.org.uk>, <axboe@kernel.dk>,
        <io-uring@vger.kernel.org>
CC:     <asml.silence@gmail.com>, <linux-fsdevel@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 4/4] iov_iter: move iter_ubuf check inside restore WARN
Date:   Mon, 7 Nov 2022 09:56:10 -0800
Message-ID: <20221107175610.349807-5-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107175610.349807-1-kbusch@meta.com>
References: <20221107175610.349807-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: tJxP4RLspSsIRo3CN3DkKTpRCuOD2VUk
X-Proofpoint-GUID: tJxP4RLspSsIRo3CN3DkKTpRCuOD2VUk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

io_uring is using iter_ubuf types for single vector requests. We expect
state restore may happen for this type now, and it is already handled
correctly, so move the check inside the warning to suppress it.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 lib/iov_iter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 07adf18e5e40..aa192a386bd7 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1880,8 +1880,8 @@ int import_ubuf(int rw, void __user *buf, size_t le=
n, struct iov_iter *i)
  */
 void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state)
 {
-	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i)) &&
-			 !iov_iter_is_kvec(i) && !iter_is_ubuf(i))
+	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i) &&
+			 !iter_is_ubuf(i)) && !iov_iter_is_kvec(i))
 		return;
 	i->iov_offset =3D state->iov_offset;
 	i->count =3D state->count;
--=20
2.30.2

