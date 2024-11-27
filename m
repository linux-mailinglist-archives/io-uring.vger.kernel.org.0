Return-Path: <io-uring+bounces-5062-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 268319DA536
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 10:56:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FD86B21DAB
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 09:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F10E194141;
	Wed, 27 Nov 2024 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="D8Cqm9a/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D10C6A8D2
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 09:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732701367; cv=none; b=rusloCGxdf9njE3JJI3+vy41KlHBZACyetzoRAEpBpYe1PNe6c7UjJ++LeM6hBwFn+0TJqlsApfzGPymykx5fg2vCqhWfzq84QHXSGV/ljUQgBnGNS2yEfo1qDXFVBN9xuv3tKl4f3pNm/thL6p5RT0KsxNOgr+7Py8eRjTuLG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732701367; c=relaxed/simple;
	bh=o1aTpgq+Kwgof7NEZghTHVseLUnno05u+LFGhp6paGY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=uQK/BbLa5yW35zIcRumCO+AFGooMZIn1LeV7HzYqc6dqEtu0h2WPN8q9PRUJ2Cczz+LSorQnG/Vw2BuBQIPSTPkuRhOgzTr+ptEmPmtNs4wIGIjBfdDhRc+jRcQMpqy4K1HLGo6viGPBUfQOe5I6FlHVDS2vp2Od6+O3tEa2Y+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=D8Cqm9a/; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241127095602epoutp04106703ad63cda6b442ce0c62ee4f9b8e~LyrWA-d0D2272322723epoutp04a
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 09:56:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241127095602epoutp04106703ad63cda6b442ce0c62ee4f9b8e~LyrWA-d0D2272322723epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732701362;
	bh=tcZjopI8nRXI1BfE2ti01zn+hHScLrloRClWVO3P6/Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=D8Cqm9a/PuPiQ4PNGXKx87US1yg6DOb8vPfVY60htQiNE8xZ0eliNdU1hs7exGAHl
	 JKUOPvXiynP2XDOPfTLx2T6eKoaa053r6FYIScZp/6z/+CXjaUi+0ziYY1Om4MkDVJ
	 hM88tR3y8cg5mjrBo6UsWScFmXKxQlFKDXdpp7e0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241127095601epcas5p3ccb628fbc6370e944e496159c91a9938~LyrVNIlgu2583125831epcas5p3P;
	Wed, 27 Nov 2024 09:56:01 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Xyvvz3zqsz4x9Ps; Wed, 27 Nov
	2024 09:55:59 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	85.9F.19710.FACE6476; Wed, 27 Nov 2024 18:55:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241127095442epcas5p4b40afe66e1de6ec8a8c51c15a09c4ac1~LyqLKYZC83053130531epcas5p4q;
	Wed, 27 Nov 2024 09:54:42 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241127095442epsmtrp2c7efc407039027319e74116e66cb2b4d~LyqLJc91q0601006010epsmtrp2D;
	Wed, 27 Nov 2024 09:54:42 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-6c-6746ecafda98
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	69.E8.33707.16CE6476; Wed, 27 Nov 2024 18:54:42 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241127095433epsmtip11cdcf18ec779b197ac01f35c37f488f9~LyqC9f0Pn1161011610epsmtip1E;
	Wed, 27 Nov 2024 09:54:32 +0000 (GMT)
Date: Wed, 27 Nov 2024 15:16:44 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v10 06/10] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241127094644.GC22537@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a9d500a4-2609-4dd6-a687-713ae1472a88@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJsWRmVeSWpSXmKPExsWy7bCmpu76N27pBisWyVp8/PqbxWLOqm2M
	Fqvv9rNZvD78idHi5oGdTBYrVx9lsnjXeo7FYvb0ZiaLo//fsllMOnSN0WLvLW2LPXtPsljM
	X/aU3aL7+g42i+XH/zFZnP97nNXi/Kw57A6CHjtn3WX3uHy21GPTqk42j81L6j1232xg8/j4
	9BaLR9+WVYweZxYcYff4vEnOY9OTt0wBXFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlA7ygplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1Jy
	CkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjN63n1jLLhvW/H/4wrmBsZuoy5GTg4JAROJT1v3
	MXUxcnEICexmlPixqJsRwvnEKPH0+FQWOKe57TMTTMu6CSegEjsZJfrf7YDqf8Yo8X/demaQ
	KhYBVYnuJ+dYQGw2AXWJI89bGUFsEQFtidfXD7GDNDAL9DJLbP7RAzZWWCBWYtm3p2BFvAK6
	Eqe/T2CBsAUlTs58AmZzCthKrJ6wA6xeVEBZ4sC241AnPeCQuPAzGMJ2kdi++SojhC0s8er4
	FnYIW0ri87u9bBB2usSPy0+hegskmo/tg6q3l2g91Q/2ALNAhsScHw1QNbISU0+tY4KI80n0
	/n4CFeeV2DEPxlaSaF85B8qWkNh7DqbXQ+LE8j3Q4DrKJPHvxxmWCYzys5D8NgvJPghbR2LB
	7k9ssxg5gGxpieX/OCBMTYn1u/QXMLKuYpRMLSjOTU9NNi0wzEsth0d5cn7uJkZwetdy2cF4
	Y/4/vUOMTByMhxglOJiVRHj5xJ3ThXhTEiurUovy44tKc1KLDzGaAiNrIrOUaHI+MMPklcQb
	mlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXAdP1wgmBvjmHd+8odyod/
	HL5q1Zu7/qPV+mPtU4+pTK/+rpM/zTt6f4KPhWXnE51rUk7HI/x1GtctU5BcUfzsGIN3kFjt
	wlVSqtpMl4UOTHF9clnGhDN5sdy09ZEalq8KNI9Vxf1JKauKFCsPnrwy+XlPeoi4L6Mpf2DP
	ZImKmzuW8PUedBOdNT3Mo2z1lTUK94Wbsz588764fdljN9mwK6qMmW831cy1dXqwsHB7gtvd
	pa7TdlvMl22b8Xx6WfpbzRemz7MuhYk68i7aP8HHsbuRh/9/7/RvqdfWHfmzyGX1a/fD5ium
	LVEV8lpRviox+ZYo74bYzSoyh3pDfmqLBST4uFi31rhvr/bViT6vxFKckWioxVxUnAgAfwRQ
	gHgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSnG7SG7d0gy+zmSw+fv3NYjFn1TZG
	i9V3+9ksXh/+xGhx88BOJouVq48yWbxrPcdiMXt6M5PF0f9v2SwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArigum5TUnMyy1CJ9uwSujNlrOlgK5ltXvFs7j7WB
	8Yl+FyMnh4SAicS6CSdYuhi5OIQEtjNKXHy2nh0iISFx6uUyRghbWGLlv+fsEEVPGCXuXr8D
	VsQioCrR/eQcC4jNJqAuceR5K1iDiIC2xOvrh8AamAX6mSX2frvPBJIQFoiVWPbtKVgRr4Cu
	xOnvE8CahQSOMkl0P9aFiAtKnJz5BCzOLKAlcePfS6BeDiBbWmL5Pw6QMKeArcTqCTvARooK
	KEsc2HacaQKj4Cwk3bOQdM9C6F7AyLyKUTS1oDg3PTe5wFCvODG3uDQvXS85P3cTIzgatYJ2
	MC5b/1fvECMTB+MhRgkOZiURXj5x53Qh3pTEyqrUovz4otKc1OJDjNIcLErivMo5nSlCAumJ
	JanZqakFqUUwWSYOTqkGJifXu1+fZ0RODfz0W2vVpiN+qh+sSyo3Ckz6tYL/7lRbZbVgrZAn
	T0JsNOMyud5O/n3KPPRQx/5zV9WqX98Js9bJYk6oWnXZZMI0z4+p7cfCl27bGnN3EcdTZa6m
	RW9PxX9k515zOPaY9DJ/u+CM8Os2N9sEj/021lLcrspkFCqzIGe5gtVP1zfbUi+FN84tdK5Y
	Mak4LO6mRKPh2gT79sZ/qyab28x95Pn6PdOCA4J+Rk2M84MeR/JdjH4We0vI70DtZAX+M21X
	7padv6XW2OerdzrYeWbftNqW+NXffO+7/30etfDMuuWVD04wGNe5pdX+vLa8LUpj1ez1oZ55
	0gG6OnNV9FN6zrAx+LR1KbEUZyQaajEXFScCAPKtico1AwAA
X-CMS-MailID: 20241127095442epcas5p4b40afe66e1de6ec8a8c51c15a09c4ac1
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_391f6_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071502epcas5p46c373574219a958b565f20732797893f
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
	<20241125070633.8042-7-anuj20.g@samsung.com>
	<2cbbe4eb-6969-499e-87b5-02d19f53258f@gmail.com>
	<20241126135423.GB22537@green245>
	<a9d500a4-2609-4dd6-a687-713ae1472a88@gmail.com>

------K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_391f6_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Tue, Nov 26, 2024 at 03:45:09PM +0000, Pavel Begunkov wrote:
> On 11/26/24 13:54, Anuj Gupta wrote:
> > On Tue, Nov 26, 2024 at 01:01:03PM +0000, Pavel Begunkov wrote:
> > > On 11/25/24 07:06, Anuj Gupta wrote:
> 
> Hmm, I have doubts it's going to work well because the union
> members have different sizes. Adding a new type could grow
> struct io_uring_attr, which is already bad for uapi. And it
> can't be stacked:
> 

How about something like this [1]. I have removed the io_uring_attr
structure, and with the mask scheme the user would pass attributes in
order of their types. Do you still see some cracks?

[1]

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index aac9a4f8fa9a..38f0d6b10eaf 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,10 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			__u64	attr_ptr; /* pointer to attribute information */
+			__u64	attr_type_mask; /* bit mask of attributes */
+		};
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
@@ -107,6 +111,18 @@ struct io_uring_sqe {
 	};
 };
 
+/* sqe->attr_type_mask flags */
+#define IORING_RW_ATTR_FLAG_PI	(1U << 0)
+/* PI attribute information */
+struct io_uring_attr_pi {
+		__u16	flags;
+		__u16	app_tag;
+		__u32	len;
+		__u64	addr;
+		__u64	seed;
+		__u64	rsvd;
+};
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c3a7d0197636..02291ea679fb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3889,6 +3889,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(46, __u16,  __pad3[0]);
 	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
 	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
+	BUILD_BUG_SQE_ELEM(48, __u64, attr_ptr);
+	BUILD_BUG_SQE_ELEM(56, __u64, attr_type_mask);
 	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0bcb83e4ce3c..8d2ec89fd76b 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -257,11 +257,53 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 	return 0;
 }
 
+static inline void io_meta_save_state(struct io_async_rw *io)
+{
+	io->meta_state.seed = io->meta.seed;
+	iov_iter_save_state(&io->meta.iter, &io->meta_state.iter_meta);
+}
+
+static inline void io_meta_restore(struct io_async_rw *io, struct kiocb *kiocb)
+{
+	if (kiocb->ki_flags & IOCB_HAS_METADATA) {
+		io->meta.seed = io->meta_state.seed;
+		iov_iter_restore(&io->meta.iter, &io->meta_state.iter_meta);
+	}
+}
+
+static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
+			 u64 attr_ptr, u64 attr_type_mask)
+{
+	struct io_uring_attr_pi pi_attr;
+	struct io_async_rw *io;
+	int ret;
+
+	if (copy_from_user(&pi_attr, u64_to_user_ptr(attr_ptr),
+	    sizeof(pi_attr)))
+		return -EFAULT;
+
+	if (pi_attr.rsvd)
+		return -EINVAL;
+
+	io = req->async_data;
+	io->meta.flags = pi_attr.flags;
+	io->meta.app_tag = pi_attr.app_tag;
+	io->meta.seed = READ_ONCE(pi_attr.seed);
+	ret = import_ubuf(ddir, u64_to_user_ptr(pi_attr.addr),
+			  pi_attr.len, &io->meta.iter);
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
+	u64 attr_type_mask;
 	int ret;
 
 	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
@@ -279,11 +321,28 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+	attr_type_mask = READ_ONCE(sqe->attr_type_mask);
+	if (attr_type_mask) {
+		u64 attr_ptr;
+
+		/* only PI attribute is supported currently */
+		if (attr_type_mask != IORING_RW_ATTR_FLAG_PI)
+			return -EINVAL;
+
+		attr_ptr = READ_ONCE(sqe->attr_ptr);
+		ret = io_prep_rw_pi(req, rw, ddir, attr_ptr, attr_type_mask);
+	}
+	return ret;
 }
 
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -409,7 +468,9 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
+	io_meta_restore(io, &rw->kiocb);
 	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
@@ -744,6 +805,10 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	if (kiocb->ki_flags & (IOCB_DIRECT | IOCB_HIPRI))
 		return false;
 
+	/* never retry for meta io */
+	if (kiocb->ki_flags & IOCB_HAS_METADATA)
+		return false;
+
 	/*
 	 * just use poll if we can, and don't attempt if the fs doesn't
 	 * support callback based unlocks
@@ -794,7 +859,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	if (!(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(file);
 
-	kiocb->ki_flags = file->f_iocb_flags;
+	kiocb->ki_flags |= file->f_iocb_flags;
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
@@ -828,6 +893,18 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
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
 
@@ -902,6 +979,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * manually if we need to.
 	 */
 	iov_iter_restore(&io->iter, &io->iter_state);
+	io_meta_restore(io, kiocb);
 
 	do {
 		/*
@@ -1125,6 +1203,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 ret_eagain:
 		iov_iter_restore(&io->iter, &io->iter_state);
+		io_meta_restore(io, kiocb);
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

------K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_391f6_
Content-Type: text/plain; charset="utf-8"


------K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_391f6_--

