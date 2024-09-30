Return-Path: <io-uring+bounces-3333-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00DF998ABFD
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAD9B281A11
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 18:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFA9199957;
	Mon, 30 Sep 2024 18:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QsHPA+I/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CC41990AE
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 18:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727720469; cv=none; b=Yl0MgSRT4gd7bJ/DoOHI7x1lOFlH0iIoNVFSFMlKl1jIEzI0spa3z2RihmyYbFHexmzSChwFVj1Uf/qqvLotRbsRN/SblLaDJ309BraIvbiGOYiWGgHCQ/uGSH90q+kNKOkoFPP7UGWAHdCmTe28RDT1bL8ipWY539vwGRL6Vrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727720469; c=relaxed/simple;
	bh=WMXM6grgrfQu3eqcKrunC0fA5XqYfx91KUbAlUnvoPo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=MxGBwyScCScJK2b3NHUAcT6GgyZbPzboD2eiiBksFtw6PwY215DdKXlGk8rLk0B37l8HKfE57UwtCQtJiTsSlgZPAu6TSXCowRkxXu7q0lOQhtmIaSeVe5QGCXcT7/AG1TdK+fO4jiEoUQBrNmGXNluh/BqabcTn31AAEiVD3EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QsHPA+I/; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240930182106epoutp04de67af3e820a41ade2ec56ea4d77ad0f~6GJw9SBog3066130661epoutp04B
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 18:21:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240930182106epoutp04de67af3e820a41ade2ec56ea4d77ad0f~6GJw9SBog3066130661epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727720466;
	bh=i2W31PSDLoXfDAIGVqVKpmMhkKotr8fjX0j5n03WZq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsHPA+I/QTBw7l8n7nxWCl2wIhOubxu9YLtUz9UhKWuRiF9vhY2n5mZlXz4zXXnSx
	 XXqCt6hLjX6mmjoEJ9MvdNZp60FNPVJ6/fnkHxixASo4rQO2RIADuexzqVJu7feC7W
	 x58eX3Vftk7OorkD2vBE0GaVD4dLG2+dH9YF5Kmo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240930182105epcas5p1fb18814d8840786678374931f0f92e5d~6GJwXLI273030330303epcas5p1P;
	Mon, 30 Sep 2024 18:21:05 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XHTsX0Pwjz4x9Pp; Mon, 30 Sep
	2024 18:21:04 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	81.F6.18935.F0CEAF66; Tue,  1 Oct 2024 03:21:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240930182103epcas5p4c9e91ca3cdf20e900b1425ae45fef81d~6GJuPNzpG2069720697epcas5p4T;
	Mon, 30 Sep 2024 18:21:03 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240930182103epsmtrp225c56587c62c66cc2420497c3a7c41b0~6GJuNAoh_2734327343epsmtrp2p;
	Mon, 30 Sep 2024 18:21:03 +0000 (GMT)
X-AuditID: b6c32a50-a99ff700000049f7-74-66faec0f0586
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B4.29.07371.F0CEAF66; Tue,  1 Oct 2024 03:21:03 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240930182100epsmtip2e761add8ecf8f9113294676db34a2524~6GJrCcr9X2505325053epsmtip2N;
	Mon, 30 Sep 2024 18:20:59 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, hare@suse.de,
	sagi@grimberg.me, martin.petersen@oracle.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org,
	dhowells@redhat.com, bvanassche@acm.org, asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com, Kanchan
	Joshi <joshi.k@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>
Subject: [PATCH v7 3/3] io_uring: enable per-io hinting capability
Date: Mon, 30 Sep 2024 23:43:05 +0530
Message-Id: <20240930181305.17286-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240930181305.17286-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te1BUVRzm3Hv3AblyW1BOS7HbCjbALOwm4FkHspCBO0oT5tSM1Qzt7F4e
	7bK77SOpDAiElEnkFcpi4QPbhDHkIaKyZkvE4Gs1sFgIXF4zJgIKiCFC7bJY/vf9fuf7zne+
	35kfG+fms3jsdLWB1qllKiHTi2hpDw4Red97nCLuL9iEDte2AFQ3cICJCpeaCTTePg1Qxf15
	HE3mLhDIfukchtqOlWLoZF0HhibzrxOo6mAehkbrTTga+XOGhTr+mWCiUuvvAJVX5AJk6QtF
	bZYuAlV/P8ZC5s4lDLUsVOPox/EpAtkWOxnIZjrMeh1S3T3bqHOmARZlG2wgqO5rRqqxdh+T
	apwuZVFNNdnUBXsOk3ow1kdQUxdvMami5lpAXT3yi/PwyufUTGMA1Tg6gSV5v6eMTqNlClon
	oNVyjSJdnRoj3LYjeUtyZJRYIpJI0UahQC3LoGOEcYlJovh0lXMQQsEnMpXR2UqS6fXC8Nei
	dRqjgRakafSGGCGtVai0EdowvSxDb1SnhqlpwyaJWPxqpJP4oTLtyb2PtafDM090LTJzwOX1
	hcCTDckIOPuggVkIvNhcsg3A8f2dwF1MA3jcVMxysbjkHIC3H+9+qrDkDeJukgXAG5X3CXcx
	A6C97LZTwWYzyWB4o8zo6vuS5Ri019USLjVO1mDwD4e3C/uQsbDjqg1zYYIMgnWnFpbdOCSC
	JUfrcbcbH1b+9mi570lKYVn3XtzNeR52VY6u3MmHeWeqll8ESbMn7DebMbc4Dn5Tf5Dlxj7w
	bmfzCubBmUkL042V0DHsINx4N2xtKmK48WaY86SX4QqDO8PUnw93e62G+xdGMVcbkhy4t4Dr
	Zr8MB0vHVpR+cOhQzQqmYPGsY2W8XwM4VPEloxjwTc9EMD0TwfS/2xGA1wIerdVnpNLySK1E
	pKZ3/fexck1GI1jeh5CkVlB3ejHMCjA2sALIxoW+nEHrfAqXo5B9+hmt0yTrjCpabwWRziGX
	4Lw1co1zodSGZEmEVBwRFRUVId0QJRH6ccbzv1VwyVSZgVbStJbWPdVhbE9eDqbXHg/c0OYf
	vNYn9Modxg+/iqKD3j/z8GgBaX83uTvkQiv5zslrWbuyY9uLGE3PLUkT9+30LBMFQo/hljSP
	7zpVsylMzNwuyZWNTeVSZoHQfvdhDF9e8ub1vlibI6B/8+SMb9XPQLn4182sj7ZkBr0gGMZ6
	eAGJnKGeNfRX8VsvqQIj/7af2GjWM1+ZPJuN+z/if8DNVu7U+f20NvqlbK+BhNyzIsdND48S
	fP35LOUXccSLq7ZXFc3P3dlzaGuvsvoANhITcGpCujohNFwzGhK9Q/52r8+If5JPucUahvdl
	im+Velz0uyxoS1i3PZReN9eulxwrfit+1RuKYL6tpSEsf4+Q0KfJJCG4Ti/7FxVwYteYBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWy7bCSvC7/m19pBucf8VvMWbWN0WL13X42
	i65/W1gsXh/+xGgx7cNPZot3Tb9ZLG4e2MlksWfRJCaLlauPMlm8az3HYjF7ejOTxZP1s5gt
	Ht/5zG5x9P9bNotJh64xWkyZ1sRosfeWtsWevSdZLOYve8pusfz4PyaLbb/nM1use/2exeL8
	3+OsFudnzWF3kPC4fMXbY+esu+we5+9tZPG4fLbUY9OqTjaPTZ8msXtsXlLvsftmA5vHx6e3
	WDze77vK5tG3ZRWjx5kFR4CSp6s9Pm+S89j05C1TAH8Ul01Kak5mWWqRvl0CV8afN4UFG/Qr
	lp78y9bAeEqti5GTQ0LARGJv8z3mLkYuDiGB3YwSD+/3sUMkxCWar/2AsoUlVv57zg5R9JFR
	ovntK7YuRg4ONgFNiQuTS0HiIgIrmCS2PfnLAuIwC2xgkmhZsgesW1jASeLomfNMIDaLgKrE
	6rW/weK8AhYSExeuZ4bYIC8x89J3sDingKXE5MsdYHEhoJo7P9qZIeoFJU7OfMICYjMD1Tdv
	nc08gVFgFpLULCSpBYxMqxglUwuKc9Nzkw0LDPNSy/WKE3OLS/PS9ZLzczcxgmNbS2MH4735
	//QOMTJxMB5ilOBgVhLhvXfoZ5oQb0piZVVqUX58UWlOavEhRmkOFiVxXsMZs1OEBNITS1Kz
	U1MLUotgskwcnFINTAnPbkYUf3l+5euLU7GPDSI5wqM5mYsV3xnUvui4HJ0SPG/SG7vlXeUu
	wYuuX33zbvPi+uo306bZ6EgtSRSrrvdkUXBQvTyb33uPoXLyhN3drfK93I8FT6RFsaXN/PN0
	/YI0mZZAVyGra38PyL/tm1zsre1QcXe30Y7X7cG80wMPvcuMFvYU2Bt5Z1ukt4+JZUrIppUb
	l1ryCnc73DNw9ysrElgwt5zJ9/KeixaPZ35jjF2Z8KV1YZD5zSu/n+89qa0xxS/5mmyAS/wt
	pUfHjtSoztBJOnIwwlbHuUxSPj2BJTPPxjWU4fmT9tWJpRfK+3QqH50psEwuWdMmaB4xqyj/
	yYtMpioO/wgup2IlluKMREMt5qLiRAALEIshXAMAAA==
X-CMS-MailID: 20240930182103epcas5p4c9e91ca3cdf20e900b1425ae45fef81d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240930182103epcas5p4c9e91ca3cdf20e900b1425ae45fef81d
References: <20240930181305.17286-1-joshi.k@samsung.com>
	<CGME20240930182103epcas5p4c9e91ca3cdf20e900b1425ae45fef81d@epcas5p4.samsung.com>

With F_SET_RW_HINT fcntl, user can set a hint on the file inode, and
all the subsequent writes on the file pass that hint value down.
This can be limiting for large files (and for block device) as all the
writes can be tagged with only one lifetime hint value.
Concurrent writes (with different hint values) are hard to manage.
Per-IO hinting solves that problem.

Allow userspace to pass additional metadata in the SQE.
The type of passed metadata is expressed by a new field

	__u16 meta_type;

At this point one type META_TYPE_LIFETIME_HINT is supported.
With this type, user can pass lifetime hint values in the new field

	__u64 lifetime_val;

This accepts all lifetime hint values that are possible with
F_SET_RW_HINT fcntl.

The write handlers (io_prep_rw, io_write) send the hint value to
lower-layer using kiocb. This is good for upporting direct IO,
but not when kiocb is not available (e.g., buffered IO).

When per-io hints are not passed, the per-inode hint values are set in
the kiocb (as before). Otherwise, these take the precedence on per-inode
hints.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 fs/fcntl.c                    | 22 ----------------------
 include/linux/rw_hint.h       | 24 ++++++++++++++++++++++++
 include/uapi/linux/io_uring.h | 19 +++++++++++++++++++
 io_uring/rw.c                 | 25 ++++++++++++++++++++++++-
 4 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 22dd9dcce7ec..a390a05f4ef8 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -334,28 +334,6 @@ static int f_getowner_uids(struct file *filp, unsigned long arg)
 }
 #endif
 
-static bool rw_hint_valid(u64 hint)
-{
-	BUILD_BUG_ON(WRITE_LIFE_NOT_SET != RWH_WRITE_LIFE_NOT_SET);
-	BUILD_BUG_ON(WRITE_LIFE_NONE != RWH_WRITE_LIFE_NONE);
-	BUILD_BUG_ON(WRITE_LIFE_SHORT != RWH_WRITE_LIFE_SHORT);
-	BUILD_BUG_ON(WRITE_LIFE_MEDIUM != RWH_WRITE_LIFE_MEDIUM);
-	BUILD_BUG_ON(WRITE_LIFE_LONG != RWH_WRITE_LIFE_LONG);
-	BUILD_BUG_ON(WRITE_LIFE_EXTREME != RWH_WRITE_LIFE_EXTREME);
-
-	switch (hint) {
-	case RWH_WRITE_LIFE_NOT_SET:
-	case RWH_WRITE_LIFE_NONE:
-	case RWH_WRITE_LIFE_SHORT:
-	case RWH_WRITE_LIFE_MEDIUM:
-	case RWH_WRITE_LIFE_LONG:
-	case RWH_WRITE_LIFE_EXTREME:
-		return true;
-	default:
-		return false;
-	}
-}
-
 static long fcntl_get_rw_hint(struct file *file, unsigned int cmd,
 			      unsigned long arg)
 {
diff --git a/include/linux/rw_hint.h b/include/linux/rw_hint.h
index 309ca72f2dfb..f4373a71ffed 100644
--- a/include/linux/rw_hint.h
+++ b/include/linux/rw_hint.h
@@ -21,4 +21,28 @@ enum rw_hint {
 static_assert(sizeof(enum rw_hint) == 1);
 #endif
 
+#define	WRITE_LIFE_INVALID	(RWH_WRITE_LIFE_EXTREME + 1)
+
+static inline bool rw_hint_valid(u64 hint)
+{
+	BUILD_BUG_ON(WRITE_LIFE_NOT_SET != RWH_WRITE_LIFE_NOT_SET);
+	BUILD_BUG_ON(WRITE_LIFE_NONE != RWH_WRITE_LIFE_NONE);
+	BUILD_BUG_ON(WRITE_LIFE_SHORT != RWH_WRITE_LIFE_SHORT);
+	BUILD_BUG_ON(WRITE_LIFE_MEDIUM != RWH_WRITE_LIFE_MEDIUM);
+	BUILD_BUG_ON(WRITE_LIFE_LONG != RWH_WRITE_LIFE_LONG);
+	BUILD_BUG_ON(WRITE_LIFE_EXTREME != RWH_WRITE_LIFE_EXTREME);
+
+	switch (hint) {
+	case RWH_WRITE_LIFE_NOT_SET:
+	case RWH_WRITE_LIFE_NONE:
+	case RWH_WRITE_LIFE_SHORT:
+	case RWH_WRITE_LIFE_MEDIUM:
+	case RWH_WRITE_LIFE_LONG:
+	case RWH_WRITE_LIFE_EXTREME:
+		return true;
+	default:
+		return false;
+	}
+}
+
 #endif /* _LINUX_RW_HINT_H */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 86cb385fe0b5..951e35226229 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -92,12 +92,23 @@ struct io_uring_sqe {
 			__u16	addr_len;
 			__u16	__pad3[1];
 		};
+		struct {
+			/* Bit field to express 16 meta types */
+			__u16	meta_type;
+			__u16	__pad4[1];
+		};
 	};
 	union {
 		struct {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			/* First meta type specific fields */
+			__u64	lifetime_val;
+			/* For future use */
+			__u64	__pad5[1];
+		};
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
@@ -107,6 +118,14 @@ struct io_uring_sqe {
 	};
 };
 
+enum io_uring_sqe_meta_type_bits {
+	META_TYPE_LIFETIME_HINT_BIT
+};
+
+/* this meta type covers write hint values supported by F_SET_RW_HINT fcntl */
+#define META_TYPE_LIFETIME_HINT	(1U << META_TYPE_LIFETIME_HINT_BIT)
+
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 510123d3d837..bf45ee8904a4 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -269,6 +269,24 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		rw->kiocb.ki_ioprio = get_current_ioprio();
 	}
 	rw->kiocb.dio_complete = NULL;
+	if (ddir == ITER_SOURCE) {
+		u16 mtype = READ_ONCE(sqe->meta_type);
+
+		rw->kiocb.ki_write_hint = WRITE_LIFE_INVALID;
+		if (mtype) {
+			u64 lhint = READ_ONCE(sqe->lifetime_val);
+
+			if (READ_ONCE(sqe->__pad4[0]) ||
+			    READ_ONCE(sqe->__pad5[0]))
+				return -EINVAL;
+
+			if (mtype != META_TYPE_LIFETIME_HINT ||
+			    !rw_hint_valid(lhint))
+				return -EINVAL;
+
+			rw->kiocb.ki_write_hint = lhint;
+		}
+	}
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
@@ -1023,7 +1041,12 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 	req->cqe.res = iov_iter_count(&io->iter);
-	rw->kiocb.ki_write_hint = file_write_hint(rw->kiocb.ki_filp);
+	/*
+	 * Use per-file hint only if per-io hint is not set.
+	 * We need per-io hint to get precedence.
+	 */
+	if (rw->kiocb.ki_write_hint == WRITE_LIFE_INVALID)
+		rw->kiocb.ki_write_hint = file_write_hint(rw->kiocb.ki_filp);
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-- 
2.25.1


