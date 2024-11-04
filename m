Return-Path: <io-uring+bounces-4418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C6C99BB983
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:57:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ECE89B216EC
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CBA61C4A0B;
	Mon,  4 Nov 2024 15:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cgOYAyw0"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4011C4A08
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730735780; cv=none; b=oeQ06egnfVA2HzG2BRU1FOTSHuAqpcLkRCl1bY4pTgK5Nza7rDk9u0CIXkUG0fPzj/lITcbdkFyTGLESFU9IGIVZ/ayRXvQaUiHck5NO49zAGuy0gQA7CTgpw7xPERXfV2vD91wFjojF1EyPyP5BHseU7FwA1YkyrxyQBGL49nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730735780; c=relaxed/simple;
	bh=kiDECaI0AWHYPH5JLwOA24dofwPFZLB6krkqJmB3MJE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=kAxJPf+nDEZcsrPTWqaSuMdPdtrClURQrf56cZboTsRHsJ9VhyOB1iEhe+FztPJKEtQt3/ZK/LDTRGbwmgEqxp06aL8DK3rIqR/3BN+mvCMGEDY43rhGCFPYS8MMS6fVZ/bSmLhY4KbwQYvbeYq49cRGbcaWxTMrLWb8O9VetRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cgOYAyw0; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241104155616epoutp04f0258a14beb98c8cd78453b6d5efef50~EzwTTOHwt1807018070epoutp04D
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241104155616epoutp04f0258a14beb98c8cd78453b6d5efef50~EzwTTOHwt1807018070epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730735776;
	bh=vOQQVCfmsj6BRfW+8n256TUsH7a5gLQ8OtUonlD8T9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgOYAyw0D7uhDt2m4aKRossOZP1YsF08LnFOJy0N6PyYBYzayuKbQD1Y0VVH1en0X
	 BmGAMsQ0Pa7BeEJYsGoZ1nHzCrJZXBraifPxvlZRudOiaI0PrJjgioA04EhBn2KxwH
	 yH6rD5QRO02Q504ZYuqhc2xd6uBmvVgsHpsRsO1k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241104155615epcas5p166d626bcfc632b5db6e3428cfeac4372~EzwSdgayn1118411184epcas5p1S;
	Mon,  4 Nov 2024 15:56:15 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Xhx0F6hjwz4x9Pq; Mon,  4 Nov
	2024 15:56:13 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EE.8A.09770.D9EE8276; Tue,  5 Nov 2024 00:56:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c~EyX3cRTse3053330533epcas5p27;
	Mon,  4 Nov 2024 14:14:59 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241104141459epsmtrp1ba012467fb5cb68db8d2e8e658d49a01~EyX3bTU9T1329813298epsmtrp1g;
	Mon,  4 Nov 2024 14:14:59 +0000 (GMT)
X-AuditID: b6c32a4a-bbfff7000000262a-d7-6728ee9dad00
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	55.8D.07371.2E6D8276; Mon,  4 Nov 2024 23:14:58 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141456epsmtip2d25f1b8da45b93c34906c48e6afea0cb~EyX02Qfgj3121331213epsmtip2G;
	Mon,  4 Nov 2024 14:14:56 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v7 06/10] io_uring/rw: add support to send metadata along
 with read/write
Date: Mon,  4 Nov 2024 19:35:57 +0530
Message-Id: <20241104140601.12239-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104140601.12239-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmlu7cdxrpBg9fGFl8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gD9pKRQlphTChQKSCwuVtK3synKLy1JVcjILy6x
	VUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzjjZPp+x4J9rxfZZR1gbGO9YdDFyckgI
	mEg87X/FCmILCexmlDj9S72LkQvI/sQocWh3LxuE841RYs32e0AOB1jHyvYqiPheRon5H48z
	QjifGSXurz7FDDKKTUBd4sjzVrCEiMAeRonehadZQBxmgQlMEu0T57CDVAkLREu827ocrINF
	QFXieMc/FhCbV8BSouf+TCaIA+UlZl76DlbPKWAlMefvXagaQYmTM5+A2cxANc1bZzODLJAQ
	uMEhsXzKHnaIZheJadcfsUHYwhKvjm+BiktJvOxvg7LTJX5cfgq1rECi+dg+RgjbXqL1VD8z
	yM/MApoS63fpQ4RlJaaeWscEsZdPovf3E6hWXokd82BsJYn2lXOgbAmJvecaoGwPiZUblkLD
	tJdR4uTJZsYJjAqzkPwzC8k/sxBWL2BkXsUomVpQnJueWmxaYJSXWg6P5uT83E2M4ISu5bWD
	8eGDD3qHGJk4GA8xSnAwK4nwzktVTxfiTUmsrEotyo8vKs1JLT7EaAoM8InMUqLJ+cCcklcS
	b2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA1P54ekPm7amztzs/PN6
	KKfNrFePzPpumM29bO/20tJuf8h39r0Km7f+/7Kgxy/gf89nzj42Rft3T9l1Hh0z5fgcZ9ni
	9NbzxZ2fzy5PU9/y7yfHhT/z51UaHz70YF2y95sz83Qst6u3GB/7Wrmty96TbUH6+lW7eMzz
	73Fw3bw86YHa9mTeGp+Y7mf58/nsj/JtiWNV7uD46eGx4FGi6RGeeM2uifpTpZIfnspa8+vD
	65faZnXW7aE7J7/iTufLUGTumWB95JT9v0u/k1OUJUPqzswV91/78Kq/89Pr9TaRs21v63Dc
	1LqY8mejb7XuVL71JfdnHric8vD183USB459ypEtmHTF00b5YPX1OysSlFiKMxINtZiLihMB
	ooqZkXEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSvO7jaxrpBt9kLT5+/c1i0TThL7PF
	nFXbGC1W3+1ns3h9+BOjxc0DO5ksVq4+ymTxrvUci8Xs6c1MFkf/v2WzmHToGqPF3lvaFnv2
	nmSxmL/sKbtF9/UdbBbLj/9jsjj/9zirxflZc9gdhDx2zrrL7nH5bKnHplWdbB6bl9R77L7Z
	wObx8ektFo++LasYPc4sOMLu8XmTnMemJ2+ZAriiuGxSUnMyy1KL9O0SuDJOts9nLPjnWrF9
	1hHWBsY7Fl2MHBwSAiYSK9uruhi5OIQEdjNKzFiwmbGLkRMoLiFx6uUyKFtYYuW/5+wQRR8Z
	Jf7evAmWYBNQlzjyvBXMFhE4wSgxf6IbSBGzwAwmiZ5fK9hANggLREoc6SgHqWERUJU43vGP
	BcTmFbCU6Lk/kwligbzEzEvf2UFsTgEriTl/74LVCAHVbGq6BFUvKHFy5hMwmxmovnnrbOYJ
	jAKzkKRmIUktYGRaxSiZWlCcm56bbFhgmJdarlecmFtcmpeul5yfu4kRHG1aGjsY783/p3eI
	kYmD8RCjBAezkgjvvFT1dCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8hjNmpwgJpCeWpGanphak
	FsFkmTg4pRqYrgtJcBSV+hhvCrhZEsaTrnD1hMd/AdXJzdsPX5/gLPGI2++hdG/n6nv/Kk2b
	50kK688XaLq0TWzl9Yr0Mz2LD/Pnfz/TJbT05HmjVo/mlxxBT5VuOCtM2/PQMEneqir7yYvi
	tYkOZkcy3W7/1fS5uiyk5+27yCVWM8KeLk26qHB+w2/FI0r2HmFzl10PTwwXt74kptIz427h
	5ll3uEIyrZ/y8scsZkub3r/boWfh+ZNmcVtXBlr9X2T1Yqoj/wxH0crlExkFoqatj5x5+2LM
	jN6r7hvXFUyQyP1yyl5r1y4uDv9tc3kDeZ9OS/LwY4/aV8f81aN61ZpfXIw7OmZkXVx91c9x
	imOkZaws325ZJZbijERDLeai4kQAuEwAbCUDAAA=
X-CMS-MailID: 20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c
References: <20241104140601.12239-1-anuj20.g@samsung.com>
	<CGME20241104141459epcas5p27991e140158b1e7294b4d6c4e767373c@epcas5p2.samsung.com>

This patch adds the capability of passing integrity metadata along with
read/write. A new meta_type field is introduced in SQE which indicates
the type of metadata being passed. A new 'struct io_uring_sqe_ext'
represents the secondary SQE space for read/write. The last 32 bytes of
secondary SQE is used to pass following PI related information:

- flags: integrity check flags namely
IO_INTEGRITY_CHK_{GUARD/APPTAG/REFTAG}
- len: length of the pi/metadata buffer
- buf: address of the metadata buffer
- seed: seed value for reftag remapping
- app_tag: application defined 16b value

Application sets up a SQE128 ring, prepares PI information within the
second SQE. The patch processes this information to prepare uio_meta
descriptor and passes it down using kiocb->private.

Meta exchange is supported only for direct IO.
Also vectored read/write operations with meta are not supported
currently.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/io_uring.h | 30 ++++++++++++
 io_uring/io_uring.c           |  8 ++++
 io_uring/rw.c                 | 88 ++++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 +++++-
 4 files changed, 137 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 024745283783..7f01124bedd5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -92,6 +92,10 @@ struct io_uring_sqe {
 			__u16	addr_len;
 			__u16	__pad3[1];
 		};
+		struct {
+			__u16	meta_type;
+			__u16	__pad4[1];
+		};
 	};
 	union {
 		struct {
@@ -107,6 +111,32 @@ struct io_uring_sqe {
 	};
 };
 
+enum io_uring_sqe_meta_type_bits {
+	META_TYPE_PI_BIT,
+	/* not a real meta type; just to make sure that we don't overflow */
+	META_TYPE_LAST_BIT,
+};
+
+/* meta type flags */
+#define META_TYPE_PI	(1U << META_TYPE_PI_BIT)
+
+/* Second half of SQE128 for IORING_OP_READ/WRITE */
+struct io_uring_sqe_ext {
+	__u64	rsvd0[4];
+	/* if sqe->meta_type is META_TYPE_PI, last 32 bytes are for PI */
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
index 44a772013c09..116c93022985 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3875,7 +3875,9 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
+	BUILD_BUG_SQE_ELEM(44, __u16,  meta_type);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
+	BUILD_BUG_SQE_ELEM(46, __u16,  __pad4[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
@@ -3902,6 +3904,12 @@ static int __init io_uring_init(void)
 	/* top 8bits are for internal use */
 	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
 
+	BUILD_BUG_ON(sizeof(struct io_uring_sqe_ext) !=
+		     sizeof(struct io_uring_sqe));
+
+	BUILD_BUG_ON(META_TYPE_LAST_BIT >
+		     8 * sizeof_field(struct io_uring_sqe, meta_type));
+
 	io_uring_optable_init();
 
 	/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 30448f343c7f..eb19b033df24 100644
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
+	u16 meta_type;
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
+	meta_type = READ_ONCE(sqe->meta_type);
+	if (meta_type) {
+		if (READ_ONCE(sqe->__pad4[0]) || !(meta_type & META_TYPE_PI))
+			return -EINVAL;
+		ret = io_prep_rw_pi(req, sqe, rw, ddir);
+	}
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -409,7 +474,10 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	if (rw->kiocb.ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -794,7 +862,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -823,6 +891,18 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
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
 
@@ -897,6 +977,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	if (kiocb->ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 
 	do {
 		/*
@@ -1101,6 +1183,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
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


