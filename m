Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB3347B8AC
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhLUC4i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:56:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14506 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbhLUC4i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:56:38 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211221025633epoutp0440f669e414342b1c9affbd3cac864205~CpbDz5iVf1360213602epoutp04d
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:56:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211221025633epoutp0440f669e414342b1c9affbd3cac864205~CpbDz5iVf1360213602epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055393;
        bh=lAWdIOcCOWl+B/sZ0GjEPv75N75abkg3WHQImh94oDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcmMdendvk+OPWcxJU4TY/Z8Up02JqTrN+ZVq3ZaJ+7LycgtvAgK3nHPZwafgcsFc
         vuVnYA2YPiB0f4mjbMRKCf+bBpnuU2ncvdcw7oOUoHm9MvhcyQQVHhAAFwT9c9Jcd+
         N8WsQLMZm33GbNdAtZHRbR1QzxuYxg0WcFnSXj7Y=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20211221025632epcas5p3be3ee7d1f6023455a2bb2327e605d623~CpbC4Mj4x2522725227epcas5p3c;
        Tue, 21 Dec 2021 02:56:32 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4JJ1Lh2n7Rz4x9QJ; Tue, 21 Dec
        2021 02:56:28 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.36.06423.C5241C16; Tue, 21 Dec 2021 11:56:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20211220142237epcas5p48729a52293e4f7627e6ec53ca67b9c58~CfIylo9yo0647006470epcas5p4y;
        Mon, 20 Dec 2021 14:22:37 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211220142237epsmtrp11641c51565e8b602ca6d4d5425fdeb0b~CfIyk2bis2445924459epsmtrp1d;
        Mon, 20 Dec 2021 14:22:37 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-49-61c1425cfa8e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        06.85.29871.DA190C16; Mon, 20 Dec 2021 23:22:37 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142235epsmtip101615df6543ec254f06c2f8a82760ba6~CfIwdsWZV0040100401epsmtip1h;
        Mon, 20 Dec 2021 14:22:35 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 05/13] io_uring: add flag and helper for fixed-buffer
 uring-cmd
Date:   Mon, 20 Dec 2021 19:47:26 +0530
Message-Id: <20211220141734.12206-6-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmhm6M08FEg7n7RCyaJvxltlh9t5/N
        YuXqo0wW71rPsVh0nr7AZHH+7WEmi0mHrjFa7L2lbTF/2VN2izU3n7I4cHnsnHWX3aN5wR0W
        j8tnSz02repk89i8pN5j980GNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnbGiaw9zwXbxiv23zjE3MK4V7mLk5JAQ
        MJG4v/o3axcjF4eQwG5GifudT9ggnE+MEs1vDkBlvjFKPHncB+RwgLXc+u0CEd/LKNH76As7
        hPOZUeL6/y1MIEVsApoSFyaXgqwQEYiWuPD8GhuIzSzQwSixs9sWxBYW8JfourKUEcRmEVCV
        eHT0KyNIK6+AhUT/vHKI6+QlZl76zg5icwpYShyevQxsDK+AoMTJmU9YIEbKSzRvnc0McoKE
        wEQOiWnP1jBDNLtI9H0/zwZhC0u8Or6FHcKWknjZ3wZlF0v8unMUqhnotusNM1kgEvYSF/f8
        BfuFGeiX9bv0IcKyElNPrWOCWMwn0fv7CRNEnFdixzwYW1Hi3qSnrBC2uMTDGUugbA+JBQ9+
        M0PCqodRYsuON8wTGBVmIXloFpKHZiGsXsDIvIpRMrWgODc9tdi0wDAvtRweycn5uZsYwYlW
        y3MH490HH/QOMTJxMB5ilOBgVhLh3TJ7f6IQb0piZVVqUX58UWlOavEhRlNggE9klhJNzgem
        +rySeEMTSwMTMzMzE0tjM0Mlcd7T6RsShQTSE0tSs1NTC1KLYPqYODilGpgcm45fZWf13s/0
        z7xgT8NB9lt8jlOiKnelnnvBW7J93ic1/eJpPwVfzbe0+5NoVHbDorbolTlvzI3Dy/vE/h/d
        2i9m8ejtWY1Aj6Ai1qVbFm1YW/tQmqngurDdyRd5y7+/9j3X+DD043qr6liFi9JZknVbfvmZ
        T9ltIil2UWzZ1F1RBcK5V74J7eCx+mm4q4j7xvYZQd9eKQVMZWjnrPG9tT7swKNta7nD36Qa
        lh6VUXv2daMUp47wmQWnP3NGSTfcXv+jM/XzYxWOOwIP7YWMnXyWR6YZPPn0p6JIbX/OIaXO
        PS4Bh1IaGPwfCjf4rV8aeS+k0a8pxjPl/JelrRMtk25PLv6rvsfsZHOaoo4SS3FGoqEWc1Fx
        IgAiKoNJPQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnO7aiQcSDa4sU7domvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoErY0XXHuaC7eIV
        +2+dY25gXCvcxcjBISFgInHrt0sXIyeHkMBuRol7+7JAbAkBcYnmaz/YIWxhiZX/ngPZXEA1
        Hxklrmy4wgTSyyagKXFhcilIjYhArMSHX8eYQGqYBSYxSmzofwDWLCzgK3Fm3kowm0VAVeLR
        0a+MIL28AhYS/fPKIebLS8y89B2shFPAUuLw7GVsEPdYSJz48IUFxOYVEJQ4OfMJmM0MVN+8
        dTbzBEaBWUhSs5CkFjAyrWKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECI4DLc0djNtX
        fdA7xMjEwXiIUYKDWUmEd8vs/YlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnN
        Tk0tSC2CyTJxcEo1MC1uLLJ8ZfEh5GxFkkScfTCn3cG/ifXRXnmHE94Vae/SU0hw4SxYecDN
        LOihzReFnWI6P48rnn7SbcjAITbp6Yt6LxfV6o02tup557Mzaj4taZF9Uz2nxKXyzkbVlNxj
        geweCWYXJZRjy4SOt/CXmJQYlRvdPVu7f1L5RP3ojLwtM2/84+TvufQz/PlBQYVN0Xt8Ba70
        28zjsHZ+3RA0Rer5NM6cyYzS0bqtqgcTfE5k+fBL/RT/FS3FoVa91sJrSn6eSantz87Ni+bx
        Hiu5WnRohiZbAN/M5ZV35002jT3+d8J2v2uVGl5yM11r8z0D0kwLpNcUqFuY2n3ddP1zzNQt
        efJaGupS3ScO1iuxFGckGmoxFxUnAgAMk3+G8gIAAA==
X-CMS-MailID: 20211220142237epcas5p48729a52293e4f7627e6ec53ca67b9c58
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142237epcas5p48729a52293e4f7627e6ec53ca67b9c58
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142237epcas5p48729a52293e4f7627e6ec53ca67b9c58@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add URING_CMD_FIXEDBUFS flag to use fixedbufs enabled passthrough.
Refactor the existing code and factor out helper that can be used for
passthrough with fixed-buffer. This is a prep patch.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c            | 20 ++++++++++++++------
 include/linux/io_uring.h | 10 ++++++++++
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1061b4cde4be..cc6735913c4b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3125,12 +3125,10 @@ static void kiocb_done(struct io_kiocb *req, ssize_t ret,
 		}
 	}
 }
-
-static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter,
-			     struct io_mapped_ubuf *imu)
+static int __io_import_fixed(u64 buf_addr, size_t len, int rw,
+			struct iov_iter *iter, struct io_mapped_ubuf *imu)
 {
-	size_t len = req->rw.len;
-	u64 buf_end, buf_addr = req->rw.addr;
+	u64 buf_end;
 	size_t offset;
 
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
@@ -3199,8 +3197,18 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 		imu = READ_ONCE(ctx->user_bufs[index]);
 		req->imu = imu;
 	}
-	return __io_import_fixed(req, rw, iter, imu);
+	return __io_import_fixed(req->rw.addr, req->rw.len, rw, iter, imu);
+}
+
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,
+		int rw, struct iov_iter *iter, void *ioucmd)
+{
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+	struct io_mapped_ubuf *imu = req->imu;
+
+	return __io_import_fixed(ubuf, len, rw, iter, imu);
 }
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
 static void io_ring_submit_unlock(struct io_ring_ctx *ctx, bool needs_lock)
 {
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 5ab824ced147..07732bc850af 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,6 +5,9 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 
+enum {
+	URING_CMD_FIXEDBUFS = (1 << 1),
+};
 /*
  * Note that the first member here must be a struct file, as the
  * io_uring command layout depends on that.
@@ -20,6 +23,8 @@ struct io_uring_cmd {
 };
 
 #if defined(CONFIG_IO_URING)
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,
+		int rw, struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 			void (*driver_cb)(struct io_uring_cmd *));
@@ -50,6 +55,11 @@ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 			void (*driver_cb)(struct io_uring_cmd *))
 {
 }
+int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,
+		int rw, struct iov_iter *iter, void *ioucmd)
+{
+	return -1;
+}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
-- 
2.25.1

