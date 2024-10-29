Return-Path: <io-uring+bounces-4140-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 173699B5068
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 18:24:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA560286280
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BB4F1DC18F;
	Tue, 29 Oct 2024 17:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="J9U1lBMr"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC7D1DBB0D
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730222643; cv=none; b=IldNS9FKnV2+j8LIrK460X3n/VeGzFSKBkq0GjPoRZL8+dOtS66hLIvA5xRzlDto3crjhu2+YdZANRUoQb73GZ6odha1JvzLqc7Dn5/buq7YMA13UqKdUVS7svamuwPyh+dSJoQnC/NFWRlYTinnv+dXb3gp/qwE/hG3kaeIa48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730222643; c=relaxed/simple;
	bh=kVVqpch4W3C7vaedFKwtfznSdsSPmraBgqU1G7FqsVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=i7yBQXInLyULxFTQlQ9Y4nXSaG9fjyZdRhI4gnFksgK0gJmlAtC6b0kqhUxtaQjBD2gDanQ8sgw3nc6YsVeTq9mGctsKgmfFWUUqUBFnT4EqxMynYPAHbZOFh5jjZYAaWv7ckduIY2zRofqGEma2de42HSsYysN4Fup+1Q6OiuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=J9U1lBMr; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241029172357epoutp01b5275a6c309a4392b192ad153ffa47ce~C-FJk-x9P2917429174epoutp01b
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 17:23:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241029172357epoutp01b5275a6c309a4392b192ad153ffa47ce~C-FJk-x9P2917429174epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730222637;
	bh=tHAbilR2K4P3xVmFkTJzSdUKF5Ld+Fwe7sWbBnlCjJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9U1lBMrOzHQ5+anQTCPkUUrXW35rOGWLafYJ99tjZE1IP+ESkb05kwW8SxuaEhjC
	 fJqAqeufHbM8wEaDtF+QeQqk1yBWkkafRGPWo748Jz0XoPmdCrT2X7Ec4VYcuu0Ygj
	 E3CZZHaWhA3lD8BEda1G1QN0JYM7JyyuLxlImw+k=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241029172357epcas5p2015b9120eb423b446185217025ccc962~C-FJDQ9Wj0233702337epcas5p2S;
	Tue, 29 Oct 2024 17:23:57 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XdHDC6PQJz4x9Pv; Tue, 29 Oct
	2024 17:23:55 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	60.6F.09800.B2A11276; Wed, 30 Oct 2024 02:23:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241029163225epcas5p24ec51c7a9b6b115757ed99cadcc3690c~C_YJmJnkX2264422644epcas5p2M;
	Tue, 29 Oct 2024 16:32:25 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241029163225epsmtrp1e30ac6a04ff99e5320275f75c8cd10e5~C_YJkUSfC0708307083epsmtrp1T;
	Tue, 29 Oct 2024 16:32:25 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-e6-67211a2bacfd
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	DD.09.18937.91E01276; Wed, 30 Oct 2024 01:32:25 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241029163222epsmtip2b2e748905798ff147e75e4ebcfa74b85~C_YHIAakw0998409984epsmtip2Y;
	Tue, 29 Oct 2024 16:32:22 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v5 06/10] io_uring/rw: add support to send metadata along
 with read/write
Date: Tue, 29 Oct 2024 21:53:58 +0530
Message-Id: <20241029162402.21400-7-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241029162402.21400-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmlq62lGK6wY3t+hYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJouj/9+yWUw6dI3RYu8tbYs9
	e0+yWMxf9pTdovv6DjaL5cf/MVmc/3uc1eL8rDnsDkIeO2fdZfe4fLbUY9OqTjaPzUvqPXbf
	bGDz+Pj0FotH35ZVjB5nFhxh9/i8Sc5j05O3TAFcUdk2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA/KSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0ts
	lVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM3p2X2Ar6HGq2Lx+JlMD4z7TLkZODgkB
	E4l7C9+xdDFycQgJ7GaU2N86lR3C+cQo8fjeVwRn86kzbDAt037PZoNI7GSU2LB0DZTzmVHi
	29EtLCBVbALqEkeetzKCJEQE9jBK9C48DbaFWWACk0T7xDnsIFXCAtESc75tZQKxWQRUJaat
	vsIMYvMKWErc23eUFWKfvMTMS9/B6jkFrCSOHd3DBFEjKHFy5hOwbcxANc1bZzND1N/gkHjQ
	7AVhu0jcPzMZ6m5hiVfHt7BD2FISL/vboOx0iR+XnzJB2AUSzcf2MULY9hKtp/qBZnIAzdeU
	WL9LHyIsKzH11DomiLV8Er2/n0C18krsmAdjK0m0r5wDZUtI7D3XAGV7SPTNusYMCa1eRom3
	axYyTWBUmIXknVlI3pmFsHoBI/MqRsnUguLc9NRi0wLjvNRyeDwn5+duYgSndC3vHYyPHnzQ
	O8TIxMF4iFGCg1lJhHd1rGy6EG9KYmVValF+fFFpTmrxIUZTYHhPZJYSTc4HZpW8knhDE0sD
	EzMzMxNLYzNDJXHe161zU4QE0hNLUrNTUwtSi2D6mDg4pRqYypZHvxDW2JwrVOD33+T0m2PM
	Ew96WX0q7u0+z55j+lznjGTxCaGm+xe/mC/bs0+CMUD48eaARVOEr76wfc+VymXXW6/DfOZ5
	fc2xiLV55013/r8yUdpgm+gvAYGfM94q2YW1fliesG7dE6Hgq833NlVeZ7n56OHn1cJ+k/0y
	DX0nnJldNUHh59PEj6lPJrdMsDzBUnGQ70plqDyHCGt1pmpbw/68i3cjXx+7U9SlHRd+Siby
	72wpV7ctD37Yu/3SPJh29vQy1r2buiZsOSd8cF9zp7qi1KTQm/sl26tWqQuULp+7wl/93+ua
	8uo66Y+rV086tPVzs/rMVQ1OM9w+HvhgtGD9Ag2NRT8LFDX3NCixFGckGmoxFxUnAgAFeQqQ
	cgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJXleSTzHdYNIfLouPX3+zWDRN+Mts
	MWfVNkaL1Xf72SxeH/7EaHHzwE4mi5WrjzJZvGs9x2Ixe3ozk8XR/2/ZLCYdusZosfeWtsWe
	vSdZLOYve8pu0X19B5vF8uP/mCzO/z3OanF+1hx2ByGPnbPusntcPlvqsWlVJ5vH5iX1Hrtv
	NrB5fHx6i8Wjb8sqRo8zC46we3zeJOex6clbpgCuKC6blNSczLLUIn27BK6Mnt0X2Ap6nCo2
	r5/J1MC4z7SLkZNDQsBEYtrv2WxdjFwcQgLbGSWerj/BDJGQkDj1chkjhC0ssfLfc3aIoo+M
	Egfe/2MFSbAJqEsced4KViQicIJRYv5EN5AiZoEZTBI9v1YAjeXgEBaIlPgxPxykhkVAVWLa
	6itgC3gFLCXu7TvKCrFAXmLmpe/sIDangJXEsaN7mEBahYBqTk5ygygXlDg58wkLiM0MVN68
	dTbzBEaBWUhSs5CkFjAyrWIUTS0ozk3PTS4w1CtOzC0uzUvXS87P3cQIjjOtoB2My9b/1TvE
	yMTBeIhRgoNZSYR3daxsuhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFe5ZzOFCGB9MSS1OzU1ILU
	IpgsEwenVAPTxIkKPFaWL+7s+GjK6qB/JurNMaPlL2IucLE8Wnh617FXsTsMribe07OR8s5r
	YVw+K2bS9vw9m3YIz/RZzrhAZ9qq9oPPu9xOBN+MydzP8nWl1gYx55yZ54qcli73nap436wy
	r+GlxOnJRtI8P8UDP7Sv6w3edMyt5YLJlyOtCu2xCccnbNSwblGfn8v2d69Y/NnjZTIP3txg
	PrznUaqjTHIZj7dzoWzq/msPmd399Ut+K5X4pnQndYb13PrQvVS76Hi+TsuCY46b1m6Ts3u2
	bWFrhbzO78IlRx7MyeHdF7Ks0odt/4EHEgKW7/f+TP5UNu3qpWg7+wgtxrY9xXMMa5OuNb8z
	DppsFVJTJ/lCiaU4I9FQi7moOBEAqUTueSIDAAA=
X-CMS-MailID: 20241029163225epcas5p24ec51c7a9b6b115757ed99cadcc3690c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241029163225epcas5p24ec51c7a9b6b115757ed99cadcc3690c
References: <20241029162402.21400-1-anuj20.g@samsung.com>
	<CGME20241029163225epcas5p24ec51c7a9b6b115757ed99cadcc3690c@epcas5p2.samsung.com>

This patch adds the capability of sending metadata along with read/write.
A new meta_type field is introduced in SQE which indicates the type of
metadata being passed. This meta is represented by a newly introduced
'struct io_uring_meta_pi' which specifies information such as flags,buffer
length,seed and apptag. Application sets up a SQE128 ring, prepares
io_uring_meta_pi within the second SQE.
The patch processes the user-passed information to prepare uio_meta
descriptor and passes it down using kiocb->private.

Meta exchange is supported only for direct IO.
Also vectored read/write operations with meta are not supported
currently.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/uapi/linux/io_uring.h | 29 +++++++++++++
 io_uring/io_uring.c           |  9 ++++
 io_uring/rw.c                 | 79 ++++++++++++++++++++++++++++++++++-
 io_uring/rw.h                 | 14 ++++++-
 4 files changed, 128 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 024745283783..4dab2b904394 100644
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
@@ -105,6 +109,31 @@ struct io_uring_sqe {
 		 */
 		__u8	cmd[0];
 	};
+	/*
+	 * If the ring is initialized with IORING_SETUP_SQE128, then
+	 * this field is starting offset for 64 bytes of data. For meta io
+	 * this contains 'struct io_uring_meta_pi'
+	 */
+	__u8	big_sqe[0];
+};
+
+enum io_uring_sqe_meta_type_bits {
+	META_TYPE_PI_BIT,
+	/* not a real meta type; just to make sure that we don't overflow */
+	META_TYPE_LAST_BIT,
+};
+
+/* meta type flags */
+#define META_TYPE_PI	(1U << META_TYPE_PI_BIT)
+
+/* this goes to SQE128 */
+struct io_uring_meta_pi {
+	__u16		pi_flags;
+	__u16		app_tag;
+	__u32		len;
+	__u64		addr;
+	__u64		seed;
+	__u64		rsvd;
 };
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4514644fdf52..b3aeddeaba2f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3875,10 +3875,13 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
 	BUILD_BUG_SQE_ELEM(44, __u16,  addr_len);
+	BUILD_BUG_SQE_ELEM(44, __u16,  meta_type);
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
+	BUILD_BUG_SQE_ELEM(46, __u16,  __pad4[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
+	BUILD_BUG_SQE_ELEM_SIZE(64, 0, big_sqe);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
@@ -3902,6 +3905,12 @@ static int __init io_uring_init(void)
 	/* top 8bits are for internal use */
 	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
 
+	BUILD_BUG_ON(sizeof(struct io_uring_meta_pi) >
+		     sizeof(struct io_uring_sqe));
+
+	BUILD_BUG_ON(META_TYPE_LAST_BIT >
+		     8 * sizeof_field(struct io_uring_sqe, meta_type));
+
 	io_uring_optable_init();
 
 	/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7ce1cbc048fa..bcff3ae76268 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -257,11 +257,58 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
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
+static int io_prep_rw_meta(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			   struct io_rw *rw, int ddir, u16 meta_type)
+{
+	const struct io_uring_meta_pi *md = (struct io_uring_meta_pi *)sqe->big_sqe;
+	const struct io_issue_def *def;
+	struct io_async_rw *io;
+	int ret;
+
+	if (READ_ONCE(sqe->__pad4[0]))
+		return -EINVAL;
+	if (!(meta_type & META_TYPE_PI))
+		return -EINVAL;
+	if (!(req->ctx->flags & IORING_SETUP_SQE128))
+		return -EINVAL;
+	if (READ_ONCE(md->rsvd))
+		return -EINVAL;
+
+	def = &io_issue_defs[req->opcode];
+	if (def->vectored)
+		return -EOPNOTSUPP;
+
+	io = req->async_data;
+	io->meta.flags = READ_ONCE(md->pi_flags);
+	io->meta.app_tag = READ_ONCE(md->app_tag);
+	io->meta.seed = READ_ONCE(md->seed);
+	ret = import_ubuf(ddir, u64_to_user_ptr(READ_ONCE(md->addr)),
+			  READ_ONCE(md->len), &io->meta.iter);
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
@@ -279,11 +326,20 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+	if (meta_type)
+		ret = io_prep_rw_meta(req, sqe, rw, ddir, meta_type);
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -410,7 +466,10 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	if (rw->kiocb.ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -795,7 +854,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -824,6 +883,18 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
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
 
@@ -898,6 +969,8 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	if (kiocb->ki_flags & IOCB_HAS_METADATA)
+		io_meta_restore(io);
 
 	do {
 		/*
@@ -1102,6 +1175,8 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
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


