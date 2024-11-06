Return-Path: <io-uring+bounces-4495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3927A9BF045
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9BC12859CD
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47B262040B4;
	Wed,  6 Nov 2024 14:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CfFSniI9"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3943A202F6F
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903360; cv=none; b=CYZjsCTlnjTm6rf3KAD0422vmhwr/A/YWJabWHD/3Ud5j3/9UWdpN55TYtoqkqrhzmZwxDlaHHOjGSLnaKFpehtacy7dbeMv5c/gIIWcs+D7QikIs5znzsNF+4T23qMNqHkIcnNVDazNc4HTad2M3OtEsmtxtCvaawbrtoyqtPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903360; c=relaxed/simple;
	bh=vjxdBdp64rm8RjorcVn2hOzHxOGxKLwK2a0ZXuTRBZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=FXCN/zOkmerGnGMfy+XXiJa9kSM8i51PGetYQb3hShU3sOHXsW17u99bZgDa6lzJ2EYHd4rm1MzMboaa1wlcRWASLVLb9mwKQoHd6S4YuKdGTXDGAEaZSaBnmIug03tGqrajblLL4unKQd9U+uMpNRACwwD6X1wWCu8pOzGo9zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CfFSniI9; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241106142916epoutp0295f2364ac5712ba93385f0597b5d6b0f~FZ26eZlTj1325913259epoutp02g
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:29:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241106142916epoutp0295f2364ac5712ba93385f0597b5d6b0f~FZ26eZlTj1325913259epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730903356;
	bh=IxUlGcaj6NqxOHXfHU9yU0+wSoAwPoFgg7rzz4PBUT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfFSniI9eiUp3YwMEf0moYv5oSFUJTcab7ougKl2X3MuYkcQXuQxn1IfqTa33h5K5
	 L7PKtvK5CvznHy9427PLmpzNqmgs2UzYHO3+4qHcXjUzRhXbX1oOLTuM96x9rXyHMd
	 qPe4C/o2hs/XaiTMJTg9Byvv8PlhyVGNn26qycKc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241106142915epcas5p36b0274ba7970aba75b9bbbc1914447ec~FZ25oIHmk2414024140epcas5p3W;
	Wed,  6 Nov 2024 14:29:15 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Xk6yx6XpVz4x9Pt; Wed,  6 Nov
	2024 14:29:13 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0E.EC.08574.93D7B276; Wed,  6 Nov 2024 23:29:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f~FYMTUFsua1874618746epcas5p23;
	Wed,  6 Nov 2024 12:27:10 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241106122710epsmtrp242b0e382b2244a9243bc06d80c9a88d1~FYMTTS-BB2560925609epsmtrp2a;
	Wed,  6 Nov 2024 12:27:10 +0000 (GMT)
X-AuditID: b6c32a44-93ffa7000000217e-cc-672b7d392eb3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	4B.75.18937.E906B276; Wed,  6 Nov 2024 21:27:10 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241106122707epsmtip1075b119a12728ffebf749e14a016be02~FYMQwKDe70829608296epsmtip1_;
	Wed,  6 Nov 2024 12:27:07 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v8 06/10] io_uring/rw: add support to send metadata along
 with read/write
Date: Wed,  6 Nov 2024 17:48:38 +0530
Message-Id: <20241106121842.5004-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241106121842.5004-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf0xTVxj1vvd8LRjms7Bw7aY2z6EDBrRaulsibNkIPJxRkm0uIgYrfSkI
	tLWvRXEhogyJDiw/Yhg/HN0kInTBrSDCoGYBlIgDJ6AVlYUZ6pwIjoJxGQPW9sHmf+fce853
	7vfde4W46CEpFqZrjaxBq8qkSV+itTs4OEyZG6qRFlfI0PSLOQKdKJnHUU1jK0DWUTOJJrpd
	AI381I6hBus1DE0VDBCouiIfQ9cWJ0lU1nUXIPv9UNRpv0Gg2gtOAfrS0Uai+t4FDN2a712J
	blXVCN4XMe1VowJmqN/E2BpPkUxz3TGmYySPZKad9wnmTEsjYH629AiYGdt6xjY+iSX6JmVs
	S2NVatYgYbWpOnW6VhNNf/RxyocpkQqpLEymRO/SEq0qi42mY3ckhsWlZ7p7oiXZqkyTeylR
	xXF0RMw2g85kZCVpOs4YTbN6daZerg/nVFmcSasJ17LGKJlUuiXSLdyfkXanI1d/mzniuncZ
	5AFn1GngI4SUHDqmG/DTwFcoojoAXFiwYzxxAThW+ivhUXlJS5P/sqPO/ouAF7UDODv4dInM
	AGh+/szrIKnNsOf3AuDZCKA6ASz+5ibhIThVgsHC0hqBR+VP7YXHrX3AgwkqCDq7yzEP9qMQ
	HLO4MD5vA6wcfOnV+1BK2D/TCnjNGnijctybhrs1+ZervV1AalgIux//7RYJ3SQW/nN9JV/H
	Hz7tbRHwWAxnpuwkjzXwryHnUpYe5l+/Cnj8HizoM+OeMjgVDC/9GMEvr4Nn+5owPvY1WDw3
	vmT1g21fL2MaFjbULGEI7QN5GH8aBv7hUPLDKgLwTuEzsgRIql7ppuqVbqr+T7YAvBGsZfVc
	loZNjdTLtOzh/y45VZdlA95nHhLbBu7VLoR3AUwIugAU4nSA366kUI3IT63KOcoadCkGUybL
	dYFI97hLcfHrqTr3P9EaU2RypVSuUCjkyq0KGR3oN1FwTi2iNCojm8Gyetaw7MOEPuI87HPb
	V4GFDnPAahtxquJqwqdzDvlopzUkIVSf81t8zhpXkyE2xPrt9gNfzM8trh6kH80HbbwYkdBa
	41CUh0nfmeKkP3yGxqKuEOeiLRuLDh72fSt5/7GB8280mEW1m5pXXNr75uLz3fHxD3Y/LOrz
	76l9+8x0yRVTcuUD41Fs3yPiRdvwzZ6J2j3H8bSiOlP5Y7Ei7jZnqSu2bkX7Ag7uSVAcwISr
	RtYudJbBnR9k158sG5HcXZe7RRs0PJkcuGtzzNgQp17/3Yn6sJBop87w/aLG8mfzzg1JO1zb
	jySKDxGHXsbhUU9iznOzobMNs0/iZavGok6S1Z0XfbMFxSv6RJbx/k9ogktTyUJwA6f6FzjP
	pbRvBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnO68BO10g9uvuSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orhsUlJzMstSi/TtErgyru6uLbjoUfHp
	xlbGBsanVl2MnBwSAiYSS/ZeYO9i5OIQEtjOKDGxbTkzREJC4tTLZYwQtrDEyn/PoYo+Mkqc
	XLoIrIhNQF3iyPNWsCIRgROMEvMnuoEUMQvMYJLo+bWCDSQhLBAp8WfzAbAiFgFViaeHJzOB
	2LwCFhIPFnxigtggLzHz0nd2EJtTwFLi7OdtYPVCQDV/FvQxQ9QLSpyc+YQFxGYGqm/eOpt5
	AqPALCSpWUhSCxiZVjGKphYU56bnJhcY6hUn5haX5qXrJefnbmIER5pW0A7GZev/6h1iZOJg
	PMQowcGsJMLrH6WdLsSbklhZlVqUH19UmpNafIhRmoNFSZxXOaczRUggPbEkNTs1tSC1CCbL
	xMEp1cC0zGVLbaKYyt/f297H3ruSp1YcynjH65ph2C62SPEJl440mQofOxYby//He4d5xImu
	9VcCt+zly2aTl2pdJD7NgLVv5uopysefuzy+s/KNkOcTtmxtw39iukGWaStnSXWWqbBFSK76
	2rPTI33jAx5H4YmV2ZfVdtxQ2tiREBWw5+nvrQee1R/vkE5ysk2/1KDDVrs94vyV9zum7jL+
	zGi15HrN+0xRy7VsnNpnJ/PPfldrO7NzMs+dvzeql15PvpGVMTX1kHcI2x3RplsLnzGcmbpg
	StXPzX6OArl/H5zn4lPTczBSKckwVLl8XCF8+tsD7Lv3f14oWiISE2LrbOX1+t3DY30M95l2
	bK0QuxSqxFKckWioxVxUnAgA9/SX5iMDAAA=
X-CMS-MailID: 20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f
References: <20241106121842.5004-1-anuj20.g@samsung.com>
	<CGME20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f@epcas5p2.samsung.com>

This patch adds the capability of passing integrity metadata along with
read/write. A new ext_cap (extended_capability) field is introduced in SQE
which indicates the type of extra information being sent. A new
'struct io_uring_sqe_ext' represents the secondary SQE space for
read/write. In future if another extension needs to be added, then one
needs to:
1. Add extra fields in the sqe/secondary-sqe
2. Introduce a ext_cap flag indicating additional values that have been
passed

The last 32 bytes of secondary SQE is used to pass following PI related
information:

- flags: integrity check flags namely
IO_INTEGRITY_CHK_{GUARD/APPTAG/REFTAG}
- len: length of the pi/metadata buffer
- buf: address of the metadata buffer
- seed: seed value for reftag remapping
- app_tag: application defined 16b value

Application sets up a SQE128 ring, prepares PI information within the
second SQE and sets the ext_cap field to EXT_CAP_PI.  The patch processes
this information to prepare uio_meta descriptor and passes it down using
kiocb->private.

Meta exchange is supported only for direct IO.
Also vectored read/write operations with meta are not supported
currently.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/io_uring.h | 34 ++++++++++++++
 io_uring/io_uring.c           |  8 ++++
 io_uring/rw.c                 | 88 ++++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 +++++-
 4 files changed, 141 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 56cf30b49ef5..449e7627b1b5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -92,6 +92,11 @@ struct io_uring_sqe {
 			__u16	addr_len;
 			__u16	__pad3[1];
 		};
+		struct {
+			/* flags indicating additional information being passed */
+			__u16	ext_cap;
+			__u16	__pad4[1];
+		};
 	};
 	union {
 		struct {
@@ -107,6 +112,35 @@ struct io_uring_sqe {
 	};
 };
 
+enum io_uring_sqe_ext_cap_bits {
+	EXT_CAP_PI_BIT,
+	/*
+	 * not a real extended capability; just to make sure that we don't
+	 * overflow
+	 */
+	EXT_CAP_LAST_BIT,
+};
+
+/* extended capability flags */
+#define EXT_CAP_PI	(1U << EXT_CAP_PI_BIT)
+
+/* Second half of SQE128 for IORING_OP_READ/WRITE */
+struct io_uring_sqe_ext {
+	__u64	rsvd0[4];
+	/* if sqe->ext_cap is EXT_CAP_PI, last 32 bytes are for PI */
+	union {
+		__u64	rsvd1[4];
+		struct {
+			__u16	flags;
+			__u16	app_tag;
+			__u32	len;
+			__u64	addr;
+			__u64	seed;
+			__u64	rsvd;
+		} rw_pi;
+	};
+};
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b590e50f09e7..6e582fe93bc4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4165,7 +4165,9 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
+	BUILD_BUG_SQE_ELEM(44, __u16,  ext_cap);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
+	BUILD_BUG_SQE_ELEM(46, __u16,  __pad4[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
@@ -4192,6 +4194,12 @@ static int __init io_uring_init(void)
 	/* top 8bits are for internal use */
 	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
 
+	BUILD_BUG_ON(sizeof(struct io_uring_sqe_ext) !=
+		     sizeof(struct io_uring_sqe));
+
+	BUILD_BUG_ON(EXT_CAP_LAST_BIT >
+		     8 * sizeof_field(struct io_uring_sqe, ext_cap));
+
 	io_uring_optable_init();
 
 	/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 768a908ca2a8..e60bf0ed4c4f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -257,11 +257,64 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 	return 0;
 }
 
+static inline void io_meta_save_state(struct io_async_rw *io)
+{
+	io->meta_state.seed = io->meta.seed;
+	iov_iter_save_state(&io->meta.iter, &io->meta_state.iter_meta);
+}
+
+static inline void io_meta_restore(struct io_async_rw *io)
+{
+	io->meta.seed = io->meta_state.seed;
+	iov_iter_restore(&io->meta.iter, &io->meta_state.iter_meta);
+}
+
+static inline const void *io_uring_sqe_ext(const struct io_uring_sqe *sqe)
+{
+	return (sqe + 1);
+}
+
+static int io_prep_rw_pi(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			   struct io_rw *rw, int ddir)
+{
+	const struct io_uring_sqe_ext *sqe_ext;
+	const struct io_issue_def *def;
+	struct io_async_rw *io;
+	int ret;
+
+	if (!(req->ctx->flags & IORING_SETUP_SQE128))
+		return -EINVAL;
+
+	sqe_ext = io_uring_sqe_ext(sqe);
+	if (READ_ONCE(sqe_ext->rsvd0[0]) || READ_ONCE(sqe_ext->rsvd0[1])
+	    || READ_ONCE(sqe_ext->rsvd0[2]) || READ_ONCE(sqe_ext->rsvd0[3]))
+		return -EINVAL;
+	if (READ_ONCE(sqe_ext->rw_pi.rsvd))
+		return -EINVAL;
+
+	def = &io_issue_defs[req->opcode];
+	if (def->vectored)
+		return -EOPNOTSUPP;
+
+	io = req->async_data;
+	io->meta.flags = READ_ONCE(sqe_ext->rw_pi.flags);
+	io->meta.app_tag = READ_ONCE(sqe_ext->rw_pi.app_tag);
+	io->meta.seed = READ_ONCE(sqe_ext->rw_pi.seed);
+	ret = import_ubuf(ddir, u64_to_user_ptr(READ_ONCE(sqe_ext->rw_pi.addr)),
+			  READ_ONCE(sqe_ext->rw_pi.len), &io->meta.iter);
+	if (unlikely(ret < 0))
+		return ret;
+	rw->kiocb.ki_flags |= IOCB_HAS_METADATA;
+	io_meta_save_state(io);
+	return ret;
+}
+
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      int ddir, bool do_import)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned ioprio;
+	u16 ext_cap;
 	int ret;
 
 	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
@@ -279,11 +332,23 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		rw->kiocb.ki_ioprio = get_current_ioprio();
 	}
 	rw->kiocb.dio_complete = NULL;
+	rw->kiocb.ki_flags = 0;
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
-	return io_prep_rw_setup(req, ddir, do_import);
+	ret = io_prep_rw_setup(req, ddir, do_import);
+
+	if (unlikely(ret))
+		return ret;
+
+	ext_cap = READ_ONCE(sqe->ext_cap);
+	if (ext_cap) {
+		if (READ_ONCE(sqe->__pad4[0]) || !(ext_cap & EXT_CAP_PI))
+			return -EINVAL;
+		ret = io_prep_rw_pi(req, sqe, rw, ddir);
+	}
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -410,7 +475,10 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	if (rw->kiocb.ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -795,7 +863,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -829,6 +897,18 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		kiocb->ki_complete = io_complete_rw;
 	}
 
+	if (kiocb->ki_flags & IOCB_HAS_METADATA) {
+		struct io_async_rw *io = req->async_data;
+
+		/*
+		 * We have a union of meta fields with wpq used for buffered-io
+		 * in io_async_rw, so fail it here.
+		 */
+		if (!(req->file->f_flags & O_DIRECT))
+			return -EOPNOTSUPP;
+		kiocb->private = &io->meta;
+	}
+
 	return 0;
 }
 
@@ -903,6 +983,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	if (kiocb->ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 
 	do {
 		/*
@@ -1126,6 +1208,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 ret_eagain:
 		iov_iter_restore(&io->iter, &io->iter_state);
+		if (kiocb->ki_flags & IOCB_HAS_METADATA)
+			io_meta_restore(io);
 		if (kiocb->ki_flags & IOCB_WRITE)
 			io_req_end_write(req);
 		return -EAGAIN;
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 3f432dc75441..2d7656bd268d 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -2,6 +2,11 @@
 
 #include <linux/pagemap.h>
 
+struct io_meta_state {
+	u32			seed;
+	struct iov_iter_state	iter_meta;
+};
+
 struct io_async_rw {
 	size_t				bytes_done;
 	struct iov_iter			iter;
@@ -9,7 +14,14 @@ struct io_async_rw {
 	struct iovec			fast_iov;
 	struct iovec			*free_iovec;
 	int				free_iov_nr;
-	struct wait_page_queue		wpq;
+	/* wpq is for buffered io, while meta fields are used with direct io */
+	union {
+		struct wait_page_queue		wpq;
+		struct {
+			struct uio_meta			meta;
+			struct io_meta_state		meta_state;
+		};
+	};
 };
 
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-- 
2.25.1


