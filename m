Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0E861FC70
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 19:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbiKGSAN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 13:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiKGR7r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 12:59:47 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D1A2A95C
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 09:56:24 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2A7GlmMo030717
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 09:56:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=fviXk0LNnrl5sy4e4CtOb1CjSHn6NFyFT8uwVNkAmF0=;
 b=ah09K/zJJOQVmAgrVycHLsq3Z79Wib27q9M2d7FBm702V9fbhplzmkV9VLrZXIbbre6V
 LjVLGeyEYwEqE9xIME9w8TJGHfW2+Ror0Uh1aBQp2Ahy+iLKtnodUBMRQnoeRDo+iwbE
 yzG47IdjpZe5iWudeCQmBphNrt3dWHKgN3MQynQ7e0w/kTaytFEoAc7dRkub/5ULiMoa
 FKBlmw0RS2n/6E1pyaxJLCuEsu+jzQMY4BmgUyn7XZTl3WtOqpf0XBydN/2+nFwvoKZD
 0bqSTcIo8R1iDEZUlLfsEUYENOZwzoQ48Vrahht74CFLKv70qdI+v4GxvglUiJr0AV0f pQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3knkgvh5t5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 09:56:23 -0800
Received: from twshared2001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 09:56:21 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 6682DADF1C99; Mon,  7 Nov 2022 09:56:11 -0800 (PST)
From:   Keith Busch <kbusch@meta.com>
To:     <viro@zeniv.linux.org.uk>, <axboe@kernel.dk>,
        <io-uring@vger.kernel.org>
CC:     <asml.silence@gmail.com>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/4] iov: add import_ubuf()
Date:   Mon, 7 Nov 2022 09:56:07 -0800
Message-ID: <20221107175610.349807-2-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107175610.349807-1-kbusch@meta.com>
References: <20221107175610.349807-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: JoFbtjfejfaIFLvvvG3t344apvbVXaD3
X-Proofpoint-GUID: JoFbtjfejfaIFLvvvG3t344apvbVXaD3
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

From: Jens Axboe <axboe@kernel.dk>

Like import_single_range(), but for ITER_UBUF.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/uio.h |  1 +
 lib/iov_iter.c      | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 2e3134b14ffd..27575495c006 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -337,6 +337,7 @@ ssize_t __import_iovec(int type, const struct iovec _=
_user *uvec,
 		 struct iov_iter *i, bool compat);
 int import_single_range(int type, void __user *buf, size_t len,
 		 struct iovec *iov, struct iov_iter *i);
+int import_ubuf(int type, void __user *buf, size_t len, struct iov_iter =
*i);
=20
 static inline void iov_iter_ubuf(struct iov_iter *i, unsigned int direct=
ion,
 			void __user *buf, size_t count)
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index c3ca28ca68a6..07adf18e5e40 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1855,6 +1855,17 @@ int import_single_range(int rw, void __user *buf, =
size_t len,
 }
 EXPORT_SYMBOL(import_single_range);
=20
+int import_ubuf(int rw, void __user *buf, size_t len, struct iov_iter *i=
)
+{
+	if (len > MAX_RW_COUNT)
+		len =3D MAX_RW_COUNT;
+	if (unlikely(!access_ok(buf, len)))
+		return -EFAULT;
+
+	iov_iter_ubuf(i, rw, buf, len);
+	return 0;
+}
+
 /**
  * iov_iter_restore() - Restore a &struct iov_iter to the same state as =
when
  *     iov_iter_save_state() was called.
--=20
2.30.2

