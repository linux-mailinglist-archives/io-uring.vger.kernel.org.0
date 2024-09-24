Return-Path: <io-uring+bounces-3282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93CA398423E
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 11:33:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 155A41F2436E
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 09:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EE71527BB;
	Tue, 24 Sep 2024 09:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="H9E+cpIP"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C0B173328
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 09:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727170384; cv=none; b=kerRrJjcRU/VGgPLbm7T4GLmY2vtrbfnyhH28ivQ4oaTSHRtxl2aAQ6Y7Pdupmpq8YhT9hQze4aFoJ07olW8j+mOCbKLhAq1mVhqoQM69FdHSJhofliv/k48c6ZioHh9kGMs/w2YCcEMDEux5CVwoi9OSWqgwdKr7mt3yksa/m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727170384; c=relaxed/simple;
	bh=mEY66RxZyDq8Tj5kT39SWNSMxftqHhiu1vgo5iIN0mo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Qnz+mQRb4o9WUhD2Xa/JV6VKiuMxa6iXJPkNBbaKbLf0Zkst+ESv93JkDzVjc0aDfAfQMmZCN6uuA5P5q+zUg3EfVCWNN23AD8LX6Y+NaKKxU5PefyuAuifx/vTSfI4QXzwwFwifXvWKjNACIqhSm+Ev+gPJY0AZYmERvGVbdeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=H9E+cpIP; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240924093300epoutp01e9aeea38d914a4d2aadb925136f5551a~4JE9eqAzj0603906039epoutp01G
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 09:33:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240924093300epoutp01e9aeea38d914a4d2aadb925136f5551a~4JE9eqAzj0603906039epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727170380;
	bh=U2H0t14SAOPlJyn9QoRH0S84QfYWYSUVOv9lDg2m5rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9E+cpIPbQ/5arv9+MRa+gijQJEmNScCn5DXpqPfqYggKi0jXUL/FDQIlfcg9JQ11
	 8kvyySsbHvoGy7QBr9W+oeA8s1s0tRExqgxIDHvbopbheGflDOZWQ4KyvMVCbfmr/p
	 RA0hzeWDRU/tooPuailLP9usBK/DVNlq95f0iGn0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240924093259epcas5p42270f3f7922d65bb88d1c2caff5a8721~4JE8kw3ok0363303633epcas5p4C;
	Tue, 24 Sep 2024 09:32:59 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XCZQy1SB2z4x9Pw; Tue, 24 Sep
	2024 09:32:58 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BC.BD.09640.A4782F66; Tue, 24 Sep 2024 18:32:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53~4JE6-a3AG3133531335epcas5p1K;
	Tue, 24 Sep 2024 09:32:57 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240924093257epsmtrp25a8438904a3179c98ac1273c14620fce~4JE6_f39R1270612706epsmtrp2O;
	Tue, 24 Sep 2024 09:32:57 +0000 (GMT)
X-AuditID: b6c32a49-aabb8700000025a8-1a-66f2874abaaa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	FF.F8.19367.94782F66; Tue, 24 Sep 2024 18:32:57 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240924093254epsmtip2d1cc1abe826c5f31ab82532c3a59ee68~4JE3ytVc80282102821epsmtip2d;
	Tue, 24 Sep 2024 09:32:54 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
	martin.petersen@oracle.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
	jack@suse.cz, jaegeuk@kernel.org, bcrl@kvack.org, dhowells@redhat.com,
	bvanassche@acm.org, asml.silence@gmail.com
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, linux-aio@kvack.org,
	gost.dev@samsung.com, vishak.g@samsung.com, javier.gonz@samsung.com, Kanchan
	Joshi <joshi.k@samsung.com>, Nitesh Shetty <nj.shetty@samsung.com>
Subject: [PATCH v6 3/3] io_uring: enable per-io hinting capability
Date: Tue, 24 Sep 2024 14:54:57 +0530
Message-Id: <20240924092457.7846-4-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240924092457.7846-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxTVxjGd+697S0M9IIoZywT7KYDDLQFWg4LMBVdriCEwJZsxAQ7uC2E
	0na9LQxDAsJAZMo2ZDhKjWRBicUIFEQQmAwkyLKBE5yAwBgfm5FRFOLIQGEtF53//d7nvM95
	z3NOjgB3XeV7CFLVekanlquEfEeiudvnXb/Ik4sK8V9WPjKZmwGqHf+Kj4rXmgg0170IUPnj
	f3FkzVsl0EhnK4Yu1/ZgyFrQT6DKc/kYmqkz4mh6bIlEPevzfFTa9RtAZeV5AHWM7kXtHX0E
	unBplkQ1vWsYal69gKOrcwsEGnjey0MDRhO5z50eHIqiW43jJD0w0UDQg78YaIv5FJ+2LJaS
	dGN1Dt02ksunn8yOEvTCD/f4dEmTGdA/V90i6SXLTtoyM4/FbklIC01h5MmMzotRJ2mSU9XK
	MGFUfGJEolQmlvhJQlCw0EstT2fChAePxPp9kKqy5Rd6ZchVBpsUK2dZoSg8VKcx6BmvFA2r
	DxMy2mSVNkjrz8rTWYNa6a9m9O9JxOIAqa3xWFrKXP59Qlsv+txU/4yXC/7cUwwcBJAKgu19
	y1gxcBS4Um0AFp8YJLhiEcD8lZPgZfHT4iz2wtI23UpyC60A9hf+jnPFEoCXTe28YiAQ8Ckf
	eOeswa67UYUY/GKyHLe7caoag/cnt9p5G3UADk7XE3YmqN2wz1S6wc5UMGzonMC5aZ6w4u4y
	aWcHCkHz0L3NHhfYVzFDcHt6wvxrlRuHgNRZBzic2wM480F47vsCPsfb4KPeJpJjD7hk7djU
	0+Dk1CTBcTZsaSzhcfw+zH02vBEGt4WpuyHiZm2BZ1ZnMLsMKWdYVOjKde+CE6Wzm053+Md3
	1TyuhYbFz2Pssiv1JYB1w4qvgafxlQDGVwIY/59VBXAzeIPRsulKhpVqJWom8+W7JmnSLWDj
	F/gebgHjk4/9uwAmAF0ACnChm3PpyBOFq3OyPOs4o9Mk6gwqhu0CUtsNf4N7bE/S2L6RWp8o
	CQoRB8lksqCQQJlE6O48V3A+2ZVSyvVMGsNoGd0LHyZw8MjFnKVTsjW3qPEcp3/aF+r0cdsD
	jrsfnbpN/fjtiX1hquiPYvZf3BVhaCnKfutBZ8iiOfr6CHbl0cPT66hq5c7NX481hjuO7gg9
	4BKR27e1bM9tb2/VpbKAT+J9g7p8MrO0irFA/YK5VVGaOeLy9yx1ZG/CmeBPrRTRvjJ0Jbso
	7AFmtqxGpxy6EScbWzOdz0u7nhEqfDt6wTtjd1ag6GMFKeUf+uzpTGFDzocVSiIyOS7dVH2x
	Zn8liOhdvwruyruvRc4TCUcT6akdg5Uep0s8TbJ4turUqJNYNKB+R9ThpK573RcoeDufKvVv
	WtmKFV8yZuBhbX/4Tc1yTflrh4vIqVtCgk2RS3xxHSv/DzlakT2OBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWy7bCSvK5n+6c0g/NtKhZzVm1jtFh9t5/N
	ouvfFhaL14c/MVpM+/CT2eJd028Wi5sHdjJZrFx9lMniXes5FovZ05uZLJ6sn8Vs8fjOZ3aL
	o//fsllMOnSN0WLKtCZGi723tC327D3JYjF/2VN2i+XH/zFZbPs9n9li3ev3LBbn/x5ntTg/
	aw67g7jH5SveHjtn3WX3OH9vI4vH5bOlHptWdbJ5bPo0id1j85J6j903G9g8Pj69xeLxft9V
	No++LasYPc4sOMLu8XmTnMemJ2+ZAviiuGxSUnMyy1KL9O0SuDJeN19nKdigXzFnwx/WBsZn
	al2MnBwSAiYSux/vZAexhQS2M0pM+h4LEReXaL72gx3CFpZY+e85VM1HRomut3xdjBwcbAKa
	Ehcml3YxcnGICMxgkji14iAbiMMssIFJomXJHrAGYQEnicuPN7CA2CwCqhIn50wCs3kFzCU2
	HrjHDLFAXmLmpe9g9ZwCFhKrrlxlAVkgBFTzd3IARLmgxMmZT8BamYHKm7fOZp7AKDALSWoW
	ktQCRqZVjKKpBcW56bnJBYZ6xYm5xaV56XrJ+bmbGMHRqxW0g3HZ+r96hxiZOBgPMUpwMCuJ
	8E66+TFNiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9yTmeKkEB6YklqdmpqQWoRTJaJg1OqgcnA
	TfDMd1W3peechD/NTKpYY2V5p0SoslVF950LX/69uEfXUli1oxO/n9Kd8EOuPW3Rcu3IgGMs
	+Qdrl2VcvcIwy6I75OP9Vt1/fJ/2fb8wp/fnDWbWOjE1/ekmG2V4pm5dIeEQs/XMa1Edexu/
	t3PexSkuiTBW+5iUEOy0RK9/EqPVsex93/te3/nQl7l5b+/ceQVlUSk+a9sU+I7U5PKdUWV5
	VTwr7+3rP2ZJkfEVHYl9ppudvoo/DH4tFff66a/zE5e8Ou18caafSHrmVza7qpln1mbMYxXI
	0Ir6Pd+gabmb5/TqyoA4iSlzVlhnN+3PWuc351RljVLFw8qrE8wzmx876CWf+zzVlneLrhJL
	cUaioRZzUXEiAK85oIRNAwAA
X-CMS-MailID: 20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53
References: <20240924092457.7846-1-joshi.k@samsung.com>
	<CGME20240924093257epcas5p174955ae79ae2d08a886eeb45a6976d53@epcas5p1.samsung.com>

With F_SET_RW_HINT fcntl, user can set a hint on the file inode, and
all the subsequent writes on the file pass that hint value down.
This can be limiting for large files (and for block device) as all the
writes can be tagged with only one lifetime hint value.
Concurrent writes (with different hint values) are hard to manage.
Per-IO hinting solves that problem.

Allow userspace to pass the write hint type and its value in the SQE.
Two new fields are carved in the leftover space of SQE:
	__u8 hint_type;
	__u64 hint_val;

Adding the hint_type helps in keeping the interface extensible for future
use.
At this point only one type TYPE_WRITE_LIFETIME_HINT is supported. With
this type, user can pass the lifetime hint values that are currently
supported by F_SET_RW_HINT fcntl.

The write handlers (io_prep_rw, io_write) process the hint type/value
and hint value is passed to lower-layer using kiocb. This is good for
supporting direct IO, but not when kiocb is not available (e.g.,
buffered IO).

In general, per-io hints take the precedence on per-inode hints.
Three cases to consider:

Case 1: When hint_type is 0 (explicitly, or implicitly as SQE fields are
initialized to 0), this means user did not send any hint. The per-inode
hint values are set in the kiocb (as before).

Case 2: When hint_type is TYPE_WRITE_LIFETIME_HINT, the hint_value is
set into the kiocb after sanity checking.

Case 3: When hint_type is anything else, this is flagged as an error
and write is failed.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 fs/fcntl.c                    | 22 ----------------------
 include/linux/rw_hint.h       | 24 ++++++++++++++++++++++++
 include/uapi/linux/io_uring.h | 10 ++++++++++
 io_uring/rw.c                 | 21 ++++++++++++++++++++-
 4 files changed, 54 insertions(+), 23 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 081e5e3d89ea..2eb78035a350 100644
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
index 1fe79e750470..e21a74dd0c49 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,11 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			/* To send per-io hint type/value with write command */
+			__u64	hint_val;
+			__u8	hint_type;
+		};
 		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
@@ -107,6 +112,11 @@ struct io_uring_sqe {
 	};
 };
 
+enum hint_type {
+	/* this type covers the values supported by F_SET_RW_HINT fcntl */
+	TYPE_WRITE_LIFETIME_HINT = 1,
+};
+
 /*
  * If sqe->file_index is set to this for opcodes that instantiate a new
  * direct descriptor (like openat/openat2/accept), then io_uring will allocate
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 510123d3d837..f78ad0ddeef5 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -269,6 +269,20 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		rw->kiocb.ki_ioprio = get_current_ioprio();
 	}
 	rw->kiocb.dio_complete = NULL;
+	if (ddir == ITER_SOURCE) {
+		u8 htype = READ_ONCE(sqe->hint_type);
+
+		rw->kiocb.ki_write_hint = WRITE_LIFE_INVALID;
+		if (htype) {
+			u64 hval = READ_ONCE(sqe->hint_val);
+
+			if (htype != TYPE_WRITE_LIFETIME_HINT ||
+			    !rw_hint_valid(hval))
+				return -EINVAL;
+
+			rw->kiocb.ki_write_hint = hval;
+		}
+	}
 
 	rw->addr = READ_ONCE(sqe->addr);
 	rw->len = READ_ONCE(sqe->len);
@@ -1023,7 +1037,12 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
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


