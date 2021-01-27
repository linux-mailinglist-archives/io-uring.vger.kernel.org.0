Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC5A305FB0
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 16:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhA0PFv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 10:05:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49401 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbhA0PCm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 10:02:42 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210127150158epoutp048d87e7d1ee739ef3bef92f69ea360c2e~eHuyg0zCp2026120261epoutp04s
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 15:01:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210127150158epoutp048d87e7d1ee739ef3bef92f69ea360c2e~eHuyg0zCp2026120261epoutp04s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611759718;
        bh=0gfCy33qDEILaikTsVpNdHgQG//hPVXr1zKS9lJ2+lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mH3qrHltsUXxctt9TuMsM42UN+wXnA+9h/qL/yHikvzkhnL8V1kcqPIVDuj5dyP6A
         eBZWhJ9k+Zi337tyFFCAaUzoZImI8AdOWvPCjJfD0/csvbTNM7y5TWM0dOZFCep+hV
         bbyTrDaa++//c9unV1fThbvSRMamih5MLNBAPfig=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210127150157epcas5p10c74d59d5147c8ae69cd52d0ca1af048~eHux-ULYP1681116811epcas5p1h;
        Wed, 27 Jan 2021 15:01:57 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.33.15682.56081106; Thu, 28 Jan 2021 00:01:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210127150156epcas5p26cdf368e4ff6bffb132fa1c7f9430653~eHuxC96l12309923099epcas5p2V;
        Wed, 27 Jan 2021 15:01:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210127150156epsmtrp2b3e6a2ea496e87079ef8aae2d23b59fb~eHuxCMdYZ0982109821epsmtrp29;
        Wed, 27 Jan 2021 15:01:56 +0000 (GMT)
X-AuditID: b6c32a49-8bfff70000013d42-f3-60118065e8c6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A7.25.13470.46081106; Thu, 28 Jan 2021 00:01:56 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210127150154epsmtip236c48b897466958e02c98eba663efa3d~eHuu2rr2J1918419184epsmtip25;
        Wed, 27 Jan 2021 15:01:54 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me
Cc:     linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [RFC PATCH 4/4] io_uring: add async passthrough ioctl support
Date:   Wed, 27 Jan 2021 20:30:29 +0530
Message-Id: <20210127150029.13766-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127150029.13766-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsWy7bCmpm5qg2CCwaU2dYvf06ewWjRN+Mts
        sfpuP5vFytVHmSzetZ5jsXh85zO7xdH/b9ksJh26xmixZ+9JFovLu+awWcxf9pTdYtvv+cwW
        V6YsYrZY9/o9i8XrHyfZHPg9zt/byOJx+Wypx6ZVnWwem5fUe+y+2cDm0bdlFaPH501yAexR
        XDYpqTmZZalF+nYJXBlfZs9jKtisXrFw0T3mBsZD8l2MnBwSAiYSjb0n2LsYuTiEBHYzSkz7
        18wK4XxilPi3diczhPONUeLugutsMC2/n26HSuxllOjo64JyPjNKdF1Zw9TFyMHBJqApcWFy
        KUiDiICLxIXfB8B2MAtMZJL49qKXCSQhLOAmcX/ucrCpLAKqEofWX2YHsXkFLCROrG9hgtgm
        LzHz0newOKeApcSVbZtYIWoEJU7OfMICYjMD1TRvnQ12hITAFg6Jq4f+skM0u0ic/fwaapCw
        xKvjW6DiUhKf3+2FeqdY4tedo1DNHYwS1xtmskAk7CUu7vkL9g0z0Dfrd+lDLOOT6P39BCws
        IcAr0dEmBFGtKHFv0lNWCFtc4uGMJVC2h0TPu7XQAO4Bhum+nSwTGOVnIflhFpIfZiFsW8DI
        vIpRMrWgODc9tdi0wDAvtVyvODG3uDQvXS85P3cTIzh5aXnuYLz74IPeIUYmDsZDjBIczEoi
        vHYKgglCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeXcYPIgXEkhPLEnNTk0tSC2CyTJxcEo1MM3Y
        Pm250c5jq7SkPXIYWBdz9M5ilcjmkuTaYF7L/qOKV3+HXuycvPdznrVZ9Xly3Vr1bE4Z939l
        wcIrKy+cMX5Qtyay/PQu78VVix0c8kUXbti19lp8jKmhzgEVw/6UN6EpD95EntI3lW06W9Ej
        Wnl42tk9ls2S8hN5K5xMF4rXLnj9tahaJYmVN/XjvLnrf86sVk9W1tKMmcTu17dql3GdChs7
        d+WtTa+zHxw8esjsjJi+U3CN3CEdPa/M9HfhdXpyk+1UDFTkyxKt1s96eGl/6L//zLvOR7S9
        eDr9eFTrlHi5qnuWRpqzp83f+HFPsgjv27+3lYs2Gdz7YjGP9cfiOmvZyvkXF+f7rWpXVWIp
        zkg01GIuKk4EAJ8ENC3NAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWy7bCSvG5Kg2CCwfrPyha/p09htWia8JfZ
        YvXdfjaLlauPMlm8az3HYvH4zmd2i6P/37JZTDp0jdFiz96TLBaXd81hs5i/7Cm7xbbf85kt
        rkxZxGyx7vV7FovXP06yOfB7nL+3kcXj8tlSj02rOtk8Ni+p99h9s4HNo2/LKkaPz5vkAtij
        uGxSUnMyy1KL9O0SuDK+zJ7HVLBZvWLhonvMDYyH5LsYOTkkBEwkfj/dztzFyMUhJLCbUeJw
        zyVmiIS4RPO1H+wQtrDEyn/P2SGKPjJKTD12namLkYODTUBT4sLkUhBTRMBLYttSQ5ByZoHZ
        TBKNvyJBbGEBN4n7c5ezgdgsAqoSh9ZfBhvJK2AhcWJ9CxPEeHmJmZe+g8U5BSwlrmzbxApi
        CwHVvJ/wkA2iXlDi5MwnLBDz5SWat85mnsAoMAtJahaS1AJGplWMkqkFxbnpucWGBYZ5qeV6
        xYm5xaV56XrJ+bmbGMExo6W5g3H7qg96hxiZOBgPMUpwMCuJ8NopCCYI8aYkVlalFuXHF5Xm
        pBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwHSCxffG2z1Jf54rb+GZ7DaHY62/
        sc/+n7y1815ZPzA7KjbBzUg8evLcehYZpdy52in3rSuPNF5bydN5imvDqb1Cb52eJFeFWTtV
        elw44iCx9gxn/pZXHmleDbK9N6f3X/vgwOb4fEvZyucdl00yROMKWe35Xjq8WcixTCfry1wJ
        gSnbmU7VeT+8cbIn5aFoxsVN6Z0tbzd/vyq+KGf3b5mfCyq2T46L2310dlTJc9c1yZzO8oK7
        fjkbVgbf2PvrmU/QpSe2HGcij69hmVZr0j5rt9esBU+vu95/01AUpaS77aZRU/391ugTO3m8
        5rE2vN75lENqblHHkdQNt3ekczQ+e8nr3nsg5dq1lgXOpj+UWIozEg21mIuKEwGBbgBiCAMA
        AA==
X-CMS-MailID: 20210127150156epcas5p26cdf368e4ff6bffb132fa1c7f9430653
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210127150156epcas5p26cdf368e4ff6bffb132fa1c7f9430653
References: <20210127150029.13766-1-joshi.k@samsung.com>
        <CGME20210127150156epcas5p26cdf368e4ff6bffb132fa1c7f9430653@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Introduce IORING_OP_IOCTL_PT for async ioctl. It skips entering into
block-layer and reaches to underlying block-driver managing the
block-device. This is done by calling newly introduced "async_ioctl"
block-device operation.
The requested operation may be completed synchronously, and in that case
CQE is updated on the fly. For asynchronous update, lower-layer calls
the completion-callback supplied by io-uring.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c                 | 77 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  7 +++-
 2 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 985a9e3f976d..c15852dfb727 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -468,6 +468,19 @@ struct io_rw {
 	u64				len;
 };
 
+/*
+ * passthru ioctl skips block-layer and reaches to block device driver via
+ * async_ioctl() block-dev operation.
+ */
+struct io_pt_ioctl {
+	struct file			*file;
+	/* arg and cmd like regular ioctl */
+	u64				arg;
+	u32				cmd;
+	/* defined by block layer */
+	struct pt_ioctl_ctx		ioctx;
+};
+
 struct io_connect {
 	struct file			*file;
 	struct sockaddr __user		*addr;
@@ -699,6 +712,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_pt_ioctl	ptioctl;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -824,6 +838,10 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_IOCTL_PT] = {
+		.needs_file		= 1,
+		.work_flags		= IO_WQ_WORK_MM,
+	},
 	[IORING_OP_READ_FIXED] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
@@ -3704,6 +3722,60 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	return ret;
 }
 
+static int io_pt_ioctl_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	unsigned int cmd = READ_ONCE(sqe->ioctl_cmd);
+	unsigned long arg = READ_ONCE(sqe->ioctl_arg);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct block_device *bdev = I_BDEV(req->file->f_mapping->host);
+	struct gendisk *disk = NULL;
+
+	disk = bdev->bd_disk;
+	if (!disk || !disk->fops || !disk->fops->async_ioctl)
+		return -EOPNOTSUPP;
+	/* for sqpoll, use sqo_task */
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		req->ptioctl.ioctx.task = ctx->sqo_task;
+	else
+		req->ptioctl.ioctx.task = current;
+
+	req->ptioctl.arg = arg;
+	req->ptioctl.cmd = cmd;
+	return 0;
+}
+
+void pt_complete(struct pt_ioctl_ctx *ptioc, long ret)
+{
+	struct io_kiocb *req = container_of(ptioc, struct io_kiocb, ptioctl.ioctx);
+
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_req_complete(req, ret);
+}
+
+static int io_pt_ioctl(struct io_kiocb *req, bool force_nonblock)
+{
+	long ret = 0;
+	struct block_device *bdev = I_BDEV(req->file->f_mapping->host);
+	fmode_t mode = req->file->f_mode;
+	struct gendisk *disk = NULL;
+
+	disk = bdev->bd_disk;
+	/* set up callback for async */
+	req->ptioctl.ioctx.pt_complete = pt_complete;
+
+	ret = disk->fops->async_ioctl(bdev, mode, req->ptioctl.cmd,
+				req->ptioctl.arg, &req->ptioctl.ioctx);
+	if (ret == -EIOCBQUEUED) /*async completion */
+		return 0;
+	if (ret < 0)
+		req_set_fail_links(req);
+
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int io_renameat_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -6078,6 +6150,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_IOCTL_PT:
+		return io_pt_ioctl_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6337,6 +6411,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, force_nonblock);
 		break;
+	case IORING_OP_IOCTL_PT:
+		ret = io_pt_ioctl(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d31a2a1e8ef9..60671e2b00ba 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -22,12 +22,16 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		__u64	ioctl_arg;
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
 		__u64	splice_off_in;
 	};
-	__u32	len;		/* buffer size or number of iovecs */
+	union {
+		__u32	len;	/* buffer size or number of iovecs */
+		__u32	ioctl_cmd;
+	};
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
@@ -137,6 +141,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_IOCTL_PT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

