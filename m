Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78E258AE0B
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 18:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241167AbiHEQZ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 12:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240789AbiHEQZp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 12:25:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A33E74362
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 09:24:57 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275G7biN003095
        for <io-uring@vger.kernel.org>; Fri, 5 Aug 2022 09:24:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=7eLK7n5MSmjwsNp02AHb8YY5HXvpcfFEurh3XLNu31E=;
 b=GFCeQG1BSKObhcSU4vgJA4D+79FS9WYu9uXTAU77Ymcyq3KAaYSQ8+T2E9H2F5Wj8U1r
 ISuWFaKvZC0GdEPM3+ETCUBDwMZ0WUwcS4nzhYCXCQ6ZpGNP93gi6b1njnTj6CerHn1V
 FkRY1HJrbVe8lpCrqa0l72JTbm1fVAGR3Z0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hrfvf84e9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 05 Aug 2022 09:24:56 -0700
Received: from twshared33626.07.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 5 Aug 2022 09:24:55 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id D1D317037505; Fri,  5 Aug 2022 09:24:45 -0700 (PDT)
From:   Keith Busch <kbusch@fb.com>
To:     <linux-nvme@lists.infradead.org>, <linux-block@vger.kernel.org>,
        <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 3/7] iov_iter: introduce type for preregistered dma tags
Date:   Fri, 5 Aug 2022 09:24:40 -0700
Message-ID: <20220805162444.3985535-4-kbusch@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220805162444.3985535-1-kbusch@fb.com>
References: <20220805162444.3985535-1-kbusch@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: WdZRghHV6nbKHzgijQa-v29J8dMmetcs
X-Proofpoint-ORIG-GUID: WdZRghHV6nbKHzgijQa-v29J8dMmetcs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_08,2022-08-05_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Introduce a new iov_iter type representing a pre-registered DMA address
tag. The tag is an opaque cookie specific to the lower level driver that
created it, and can be referenced at any arbitrary offset.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/uio.h |  9 +++++++++
 lib/iov_iter.c      | 27 ++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 34ba4a731179..a55e4b86413a 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -26,6 +26,7 @@ enum iter_type {
 	ITER_PIPE,
 	ITER_XARRAY,
 	ITER_DISCARD,
+	ITER_DMA_TAG,
 };
=20
 struct iov_iter_state {
@@ -46,6 +47,7 @@ struct iov_iter {
 		const struct bio_vec *bvec;
 		struct xarray *xarray;
 		struct pipe_inode_info *pipe;
+		void *dma_tag;
 	};
 	union {
 		unsigned long nr_segs;
@@ -85,6 +87,11 @@ static inline bool iov_iter_is_bvec(const struct iov_i=
ter *i)
 	return iov_iter_type(i) =3D=3D ITER_BVEC;
 }
=20
+static inline bool iov_iter_is_dma_tag(const struct iov_iter *i)
+{
+	return iov_iter_type(i) =3D=3D ITER_DMA_TAG;
+}
+
 static inline bool iov_iter_is_pipe(const struct iov_iter *i)
 {
 	return iov_iter_type(i) =3D=3D ITER_PIPE;
@@ -229,6 +236,8 @@ void iov_iter_kvec(struct iov_iter *i, unsigned int d=
irection, const struct kvec
 			unsigned long nr_segs, size_t count);
 void iov_iter_bvec(struct iov_iter *i, unsigned int direction, const str=
uct bio_vec *bvec,
 			unsigned long nr_segs, size_t count);
+void iov_iter_dma_tag(struct iov_iter *i, unsigned int direction, void *=
dma_tag,
+			unsigned int dma_offset, size_t count);
 void iov_iter_pipe(struct iov_iter *i, unsigned int direction, struct pi=
pe_inode_info *pipe,
 			size_t count);
 void iov_iter_discard(struct iov_iter *i, unsigned int direction, size_t=
 count);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 507e732ef7cf..ebdf81473526 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1070,6 +1070,9 @@ void iov_iter_advance(struct iov_iter *i, size_t si=
ze)
 		iov_iter_iovec_advance(i, size);
 	} else if (iov_iter_is_bvec(i)) {
 		iov_iter_bvec_advance(i, size);
+	} else if (iov_iter_is_dma_tag(i)) {
+		i->iov_offset +=3D size;
+		i->count -=3D size;
 	} else if (iov_iter_is_pipe(i)) {
 		pipe_advance(i, size);
 	} else if (unlikely(iov_iter_is_xarray(i))) {
@@ -1201,6 +1204,21 @@ void iov_iter_bvec(struct iov_iter *i, unsigned in=
t direction,
 }
 EXPORT_SYMBOL(iov_iter_bvec);
=20
+void iov_iter_dma_tag(struct iov_iter *i, unsigned int direction,
+			void *dma_tag, unsigned int dma_offset,
+			size_t count)
+{
+	WARN_ON(direction & ~(READ | WRITE));
+	*i =3D (struct iov_iter){
+		.iter_type =3D ITER_DMA_TAG,
+		.data_source =3D direction,
+		.dma_tag =3D dma_tag,
+		.iov_offset =3D dma_offset,
+		.count =3D count
+	};
+}
+EXPORT_SYMBOL(iov_iter_dma_tag);
+
 void iov_iter_pipe(struct iov_iter *i, unsigned int direction,
 			struct pipe_inode_info *pipe,
 			size_t count)
@@ -1335,6 +1353,9 @@ bool iov_iter_is_aligned(const struct iov_iter *i, =
unsigned addr_mask,
 	if (iov_iter_is_bvec(i))
 		return iov_iter_aligned_bvec(i, addr_mask, len_mask);
=20
+	if (iov_iter_is_dma_tag(i))
+		return !(i->iov_offset & addr_mask);
+
 	if (iov_iter_is_pipe(i)) {
 		unsigned int p_mask =3D i->pipe->ring_size - 1;
 		size_t size =3D i->count;
@@ -2124,8 +2145,8 @@ EXPORT_SYMBOL(import_single_range);
  */
 void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state)
 {
-	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i)) &&
-			 !iov_iter_is_kvec(i))
+	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i) &&
+			 !iov_iter_is_dma_tag(i)) && !iov_iter_is_kvec(i))
 		return;
 	i->iov_offset =3D state->iov_offset;
 	i->count =3D state->count;
@@ -2141,7 +2162,7 @@ void iov_iter_restore(struct iov_iter *i, struct io=
v_iter_state *state)
 	BUILD_BUG_ON(sizeof(struct iovec) !=3D sizeof(struct kvec));
 	if (iov_iter_is_bvec(i))
 		i->bvec -=3D state->nr_segs - i->nr_segs;
-	else
+	else if (!iov_iter_is_dma_tag(i))
 		i->iov -=3D state->nr_segs - i->nr_segs;
 	i->nr_segs =3D state->nr_segs;
 }
--=20
2.30.2

