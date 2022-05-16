Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF94528AF1
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343915AbiEPQtF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343906AbiEPQtA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:49:00 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D3B3CFC8
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:53 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GEAwxb006821
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=4KklUZPFX9fktoVM6Kmf3n/HljyGufq7o2WF5gt1Xgo=;
 b=dm8EctE0QrZ0gN2+q2lq3cWBuC/W5vK89F/UPK9Gpq1bhKUKogfBhL239fCCI5iMbQbR
 Zo+PVcuq8LckfaY6jHFgMDhcjRMnfhxW4Wwf6oYoYnYHV6vEaiOT372VxtsmoGk89JLA
 QRuS3+O6B/Hw9m9mh6GxXQZW6yOrdojJP0g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g2a5yakgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:52 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 09:48:51 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 8FF8FF146DEB; Mon, 16 May 2022 09:48:25 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v2 14/16] iomap: use balance_dirty_pages_ratelimited_flags in iomap_write_iter
Date:   Mon, 16 May 2022 09:47:16 -0700
Message-ID: <20220516164718.2419891-15-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220516164718.2419891-1-shr@fb.com>
References: <20220516164718.2419891-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: RDiUZZwbGwE0yP4lTd8_Oa_PUnjlYZUM
X-Proofpoint-GUID: RDiUZZwbGwE0yP4lTd8_Oa_PUnjlYZUM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This replaces the call to balance_dirty_pages_ratelimited() with the
call to balance_dirty_pages_ratelimited_flags. This allows to specify if
the write request is async or not.

In addition this also moves the above function call to the beginning of
the function. If the function call is at the end of the function and the
decision is made to throttle writes, then there is no request that
io-uring can wait on. By moving it to the beginning of the function, the
write request is not issued, but returns -EAGAIN instead. io-uring will
punt the request and process it in the io-worker.

By moving the function call to the beginning of the function, the write
throttling will happen one page later.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/iomap/buffered-io.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ceb3091f94c2..41a8e0bb2edd 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -794,6 +794,11 @@ static loff_t iomap_write_iter(struct iomap_iter *it=
er, struct iov_iter *i)
 		bytes =3D min_t(unsigned long, PAGE_SIZE - offset,
 						iov_iter_count(i));
 again:
+		status =3D balance_dirty_pages_ratelimited_flags(iter->inode->i_mappin=
g,
+						(iter->flags & IOMAP_NOWAIT));
+		if (unlikely(status))
+			break;
+
 		if (bytes > length)
 			bytes =3D length;
=20
@@ -842,8 +847,6 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 		pos +=3D status;
 		written +=3D status;
 		length -=3D status;
-
-		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
 	} while (iov_iter_count(i) && length);
=20
 	return written ? written : status;
--=20
2.30.2

