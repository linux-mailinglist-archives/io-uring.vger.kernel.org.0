Return-Path: <io-uring+bounces-4493-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C63C9BF035
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E13D1F249C8
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 654042022F9;
	Wed,  6 Nov 2024 14:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gbg5JLxy"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A034C2022E5
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903341; cv=none; b=rl3bolze8ePcIGgSUqZz3ch8Ir2ICWg0QO7adWVorBWg+DM/8QdNCpWxA5bsRwJVyNHVBZCh8r2yzVbLCAE3EhGcuJx76SL6nZumQ6/FtSKulTIZWH7/OfugdBmTK+z8x8AJaWyFi6sY6ecnln4lajpmsEpp4J8pDQ4YCZIe7tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903341; c=relaxed/simple;
	bh=uDUb87C52DXoVA3KvOoAoNEyjHqrw30MJR/Iqxaidaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=IrTlUoQsf8hHBiVpU6Bw4Ygu22ODg2uCEcPgK+FN8qnxCwtYnzJBDUDQWY5fXwLiWezj6IVDZgU8N9UU80Em+gRLCCOJh6PFOy8F72XGDQu1fMhIjHFoLXbKy3nWbmIUG5YaxYOFph+udEwrBmSZF/Mw6r2BdzByV7jhIdeqAro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gbg5JLxy; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241106142857epoutp035e541c3577b183a0fe4b1544260c8744~FZ2pIS_x_2254722547epoutp03D
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:28:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241106142857epoutp035e541c3577b183a0fe4b1544260c8744~FZ2pIS_x_2254722547epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730903338;
	bh=sPCiH7C8otAPeKBQxafGfpBc//4CVwTtOappMXTNYFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbg5JLxy/xiTiY9CuIiwgTmSAQOcbuN/Ud63w2R7VlT4/1GVgD7RL9mt0ufzemj3Y
	 hnq3uR4bSXQWmPkDAneWxqWQ9b32gKU8/GgRd5G2pj8g9KNjLv009F7kdA1Hc/p5no
	 9Rb3+9ULk1qnq95VfOvwLvcRrlJpKXOnWiP+nep0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241106142857epcas5p263a7bc31e0dbaab8e5a1cba44ac3d8d6~FZ2oU87bL1484514845epcas5p2Z;
	Wed,  6 Nov 2024 14:28:57 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Xk6yb2jBpz4x9Pp; Wed,  6 Nov
	2024 14:28:55 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BB.44.37975.72D7B276; Wed,  6 Nov 2024 23:28:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241106122704epcas5p37a156fb2738c3b8194e8f81c26a07878~FYMOMslh43242132421epcas5p33;
	Wed,  6 Nov 2024 12:27:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241106122704epsmtrp200a3457ab68e63807ffbfa37626d1ccf~FYMOL2gb62562525625epsmtrp2O;
	Wed,  6 Nov 2024 12:27:04 +0000 (GMT)
X-AuditID: b6c32a50-085ff70000049457-2d-672b7d27f000
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F6.01.35203.8906B276; Wed,  6 Nov 2024 21:27:04 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241106122702epsmtip1ef7339d3a33088bb9e994ec2c051e80a~FYMLqURmC0829608296epsmtip19;
	Wed,  6 Nov 2024 12:27:01 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v8 04/10] fs, iov_iter: define meta io descriptor
Date: Wed,  6 Nov 2024 17:48:36 +0530
Message-Id: <20241106121842.5004-5-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241106121842.5004-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmhq56rXa6wZRTAhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUdk2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA/KSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0ts
	lVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM5ZM0y24wlux+NpCtgbG2dxdjJwcEgIm
	EnN79jN1MXJxCAnsYZR4OnkrC4TziVFi/q6jbBDON0aJtStWscG0nPv0lBHEFhLYyyjRewaq
	6DOjxNXrj5lAEmwC6hJHnrcygiREQOb2LjwNNpdZYAKTRPvEOewgVcICjhJ3ln1iAbFZBFQl
	5ixsYgaxeQUsJGY9/8cOsU5eYual72A2p4ClxNnP2xghagQlTs58AtbLDFTTvHU2M8gCCYEb
	HBJdL76zQDS7SGxY38cMYQtLvDq+BWqolMTnd3uh/kmX+HH5KROEXSDRfGwfI4RtL9F6qh+o
	lwNogabE+l36EGFZiamn1jFB7OWT6P39BKqVV2LHPBhbSaJ95RwoW0Ji77kGKNtDYunFj+yQ
	4OphlDj3+AHTBEaFWUj+mYXkn1kIqxcwMq9ilEotKM5NT002LTDUzUsth8dzcn7uJkZwStcK
	2MG4esNfvUOMTByMhxglOJiVRHj9o7TThXhTEiurUovy44tKc1KLDzGaAkN8IrOUaHI+MKvk
	lcQbmlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXAxHvq+8c/Lx87Rc3r
	X3CbK8/pi/dTg/dmDmVMas4RKld+xWV9nul7JErTekH1j0MpM5dH7O89kHj/w7SL/6r+bFq6
	6CHHMoZYQ5H1M6Z8yDqbx3ZMg6EiZ+eGm/VV7CF/psyV4ekK3bspyfDP/dTWo55bww/VfJ/A
	L7AjguFVYsQKrcNbDt6vtdPw2MuVLCtnH1/ItueR39K+9WG9b56+Ttg5/3TVp+RjfSxLp/Bw
	Bk/bNy/ztsJUHf6gjXulJPVvltk8yXRS64lwPy3Fm8K0xtYjwHZn2JwQlvRXXN+KdCY7LtvJ
	oyBe2Vm8z3vJ7wVvKp9zsO9m0NJSzOo/oJRxeXaV5r3vijwLk+u9TszfpsRSnJFoqMVcVJwI
	AEQ0a2JyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSnO6MBO10g+ffNSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orhsUlJzMstSi/TtErgylkzTLbjCW7H4
	2kK2BsbZ3F2MnBwSAiYS5z49Zexi5OIQEtjNKDHj8j8miISExKmXyxghbGGJlf+es0MUfWSU
	2PJoKwtIgk1AXeLI81awIhGBE4wS8ye6gRQxC8xgkuj5tYINJCEs4ChxZ9knsAYWAVWJOQub
	mEFsXgELiVnP/7FDbJCXmHnpO5jNKWApcfbzNrChQkA1fxb0QdULSpyc+QRsDjNQffPW2cwT
	GAVmIUnNQpJawMi0ilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOOK0NHcwbl/1Qe8Q
	IxMH4yFGCQ5mJRFe/yjtdCHelMTKqtSi/Pii0pzU4kOM0hwsSuK84i96U4QE0hNLUrNTUwtS
	i2CyTBycUg1Mh9LzTsY9rros8jPWXXkG2yWjTv6N+TuVX8iymBSxPZvvc+HH/ymyCx98LHma
	dqt8Wcb3s896WRfECajOqP1Y8tk7KaWUO/yUbMXSP3s4+HQNBOK+CZc1/59hH/BQsJl99SOe
	X8wGra9MuK+ciPncI20rKOo5afvNHofD0+Z9DNKc+ufP7vPSs19Ode68dXtSyTSBacqLPa6F
	HOMSfT371lIRF5eGXyG3E/LE07Z85Ss4nir97Fr2098/i70fXo5grnr16kLBfRM7KZY2oWUl
	rH6LjeWn23QIvgjc4mafEBy94FrUtXClGUs4/08oDduWOZXRtk/is/gtd54S0b+LsjUZ3+8J
	OBha1xmsuyVIiaU4I9FQi7moOBEAVFbo8ScDAAA=
X-CMS-MailID: 20241106122704epcas5p37a156fb2738c3b8194e8f81c26a07878
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122704epcas5p37a156fb2738c3b8194e8f81c26a07878
References: <20241106121842.5004-1-anuj20.g@samsung.com>
	<CGME20241106122704epcas5p37a156fb2738c3b8194e8f81c26a07878@epcas5p3.samsung.com>

Add flags to describe checks for integrity meta buffer. Also, introduce
a  new 'uio_meta' structure that upper layer can use to pass the
meta/integrity information.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/uio.h     | 9 +++++++++
 include/uapi/linux/fs.h | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 853f9de5aa05..8ada84e85447 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -82,6 +82,15 @@ struct iov_iter {
 	};
 };
 
+typedef __u16 uio_meta_flags_t;
+
+struct uio_meta {
+	uio_meta_flags_t	flags;
+	u16			app_tag;
+	u64			seed;
+	struct iov_iter		iter;
+};
+
 static inline const struct iovec *iter_iov(const struct iov_iter *iter)
 {
 	if (iter->iter_type == ITER_UBUF)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 753971770733..9070ef19f0a3 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -40,6 +40,15 @@
 #define BLOCK_SIZE_BITS 10
 #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
 
+/* flags for integrity meta */
+#define IO_INTEGRITY_CHK_GUARD		(1U << 0) /* enforce guard check */
+#define IO_INTEGRITY_CHK_REFTAG		(1U << 1) /* enforce ref check */
+#define IO_INTEGRITY_CHK_APPTAG		(1U << 2) /* enforce app check */
+
+#define IO_INTEGRITY_VALID_FLAGS (IO_INTEGRITY_CHK_GUARD | \
+				  IO_INTEGRITY_CHK_REFTAG | \
+				  IO_INTEGRITY_CHK_APPTAG)
+
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
-- 
2.25.1


