Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E24452C7CC
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiERXiP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiERXiG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:38:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B34BA570
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:49 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6ETB011540
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=YqpL7bjIpVC1T97cqx5/U3u744Lv+NFWKctjbk1tsPQ=;
 b=O1yAb8w1N1LFimCUIL56ovslFW04+3z1OBoK0HbYYJD3Hg8811rHF5Lil5O5Y4VLZ3e3
 ulSJsERiQrFtWbMGxyYFJUuXFE8hlHLPIZ94ZOayu1XuOy6BSMoH2JF95wUxJonWRjRk
 VvisvwnPyknlbE3H4mF27BmlTk/eVcEzbTU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4frtanqc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:49 -0700
Received: from twshared11660.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 18 May 2022 16:37:46 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 19715F3ED871; Wed, 18 May 2022 16:37:13 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v3 16/18] iomap: Use balance_dirty_pages_ratelimited_flags in iomap_write_iter
Date:   Wed, 18 May 2022 16:37:07 -0700
Message-ID: <20220518233709.1937634-17-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518233709.1937634-1-shr@fb.com>
References: <20220518233709.1937634-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: am50qgpKzEOq4nEdiexpe2pWTEcOZIrN
X-Proofpoint-ORIG-GUID: am50qgpKzEOq4nEdiexpe2pWTEcOZIrN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
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
 fs/iomap/buffered-io.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index b029e2b10e07..2b85ddfa6ea1 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -784,6 +784,7 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 	do {
 		struct folio *folio;
 		struct page *page;
+		struct address_space *i_mapping =3D iter->inode->i_mapping;
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
@@ -792,6 +793,14 @@ static loff_t iomap_write_iter(struct iomap_iter *it=
er, struct iov_iter *i)
 		bytes =3D min_t(unsigned long, PAGE_SIZE - offset,
 						iov_iter_count(i));
 again:
+		if (iter->flags & IOMAP_NOWAIT) {
+			status =3D balance_dirty_pages_ratelimited_async(i_mapping);
+			if (unlikely(status))
+				break;
+		} else {
+			balance_dirty_pages_ratelimited(i_mapping);
+		}
+
 		if (bytes > length)
 			bytes =3D length;
=20
@@ -815,7 +824,7 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
r, struct iov_iter *i)
 			break;
=20
 		page =3D folio_file_page(folio, pos >> PAGE_SHIFT);
-		if (mapping_writably_mapped(iter->inode->i_mapping))
+		if (mapping_writably_mapped(i_mapping))
 			flush_dcache_page(page);
=20
 		copied =3D copy_page_from_iter_atomic(page, offset, bytes, i);
@@ -840,8 +849,6 @@ static loff_t iomap_write_iter(struct iomap_iter *ite=
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

