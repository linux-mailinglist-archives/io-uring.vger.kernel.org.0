Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3008147B8A5
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 03:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhLUC4S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 21:56:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:42521 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbhLUC4R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Dec 2021 21:56:17 -0500
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211221025615epoutp0219e9e227b7836173e380c81816cd3611~Cpaywjwoq2441624416epoutp02j
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 02:56:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211221025615epoutp0219e9e227b7836173e380c81816cd3611~Cpaywjwoq2441624416epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1640055375;
        bh=lxZ3y46Zzqi42oELo2sbv5mkNnzILaZBKfOldBs6qM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVh0DdxsB36sAHAGqqsrnaFBm5GSqJ+/CYtwSFtv+NobcQrIk045yynrnQZMpYz/x
         qeLajGKNnDRV5rn/VqI9Cn2Nc7kvH9javOq6xgSwuLC/3bLn6Oy0Cf/HGOYZEiMd1x
         wTJeWJ/BELBUCRi8r8nVvDWm/MITakiqsKXe/IPw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20211221025614epcas5p1efa0134e18e9b2f8bf039c2d82ab4931~CpayPW6G61825618256epcas5p1V;
        Tue, 21 Dec 2021 02:56:14 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4JJ1LL6Lm7z4x9Q9; Tue, 21 Dec
        2021 02:56:10 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.D1.46822.84241C16; Tue, 21 Dec 2021 11:56:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20211220142228epcas5p2978d92d38f2015148d5f72913d6dbc3e~CfIqTXAx22775527755epcas5p2B;
        Mon, 20 Dec 2021 14:22:28 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211220142228epsmtrp1bc48eb49aa183de9078ecce0162bab08~CfIqSnczN2445924459epsmtrp1U;
        Mon, 20 Dec 2021 14:22:28 +0000 (GMT)
X-AuditID: b6c32a4a-dfbff7000000b6e6-57-61c142489b41
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        24.65.08738.4A190C16; Mon, 20 Dec 2021 23:22:28 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211220142227epsmtip1fb486648edb179508517924532dd8f9c~CfIolz2kX0637406374epsmtip1q;
        Mon, 20 Dec 2021 14:22:26 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, javier@javigon.com,
        anuj20.g@samsung.com, joshiiitr@gmail.com, pankydev8@gmail.com
Subject: [RFC 01/13] io_uring: add infra for uring_cmd completion in
 submitter-task
Date:   Mon, 20 Dec 2021 19:47:22 +0530
Message-Id: <20211220141734.12206-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220141734.12206-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmhq6H08FEg68bOCyaJvxltlh9t5/N
        YuXqo0wW71rPsVh0nr7AZHH+7WEmi0mHrjFa7L2lbTF/2VN2izU3n7I4cHnsnHWX3aN5wR0W
        j8tnSz02repk89i8pN5j980GNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnbH7pVrBBZGKP7/XszYwbhPsYuTkkBAw
        kTj3sZO9i5GLQ0hgN6PE6h8nGCGcT4wSOy/chcp8ZpSY0DCLHaZlxa6FTBCJXYwSV/Z8YIOr
        ujlpM1A/BwebgKbEhcmlIA0iAtESF55fYwOxmQU6gMZ224LYwgKhEr+nvQeLswioSrS9vsYK
        YvMKWEhcO30Hapm8xMxL38FsTgFLicOzl7FB1AhKnJz5hAViprxE89bZzCA3SAj0ckgsWPWL
        EaLZReLL8xWsELawxKvjW6CGSkm87G+Dsoslft05CtUMdNz1hpksEAl7iYt7/jKBPMMM9Mz6
        XfoQYVmJqafWMUEs5pPo/f2ECSLOK7FjHoytKHFv0lOoveISD2csYQUZIyHgIXH2iAUkrHoY
        JRpuLWabwKgwC8k/s5D8Mwth8wJG5lWMkqkFxbnpqcWmBUZ5qeXwSE7Oz93ECE60Wl47GB8+
        +KB3iJGJg/EQowQHs5II75bZ+xOFeFMSK6tSi/Lji0pzUosPMZoCA3wis5Rocj4w1eeVxBua
        WBqYmJmZmVgamxkqifOeTt+QKCSQnliSmp2aWpBaBNPHxMEp1cAkuOy8wORzkxcWbjfe2mNU
        I7s679CWL9suOfW5Jib0dYfVOC48p8MaqGxfZOfKyvdKbYtn8JmvUVv6Mj4dvKL01MbnhcZM
        BZsN21fo88j9n2gQvnTrhiXq1iYt63rqfkTxvOJkFU23Dv5Z3nR7Y3lhCzdbYue8/09iJKQe
        cDhP6/vhyekTYxjLtuSCidKcv2vuTmyZdMf+7TyuT1tPN3CnHV4lbTfXJ6NZ9sTcqgPrfTbx
        MfmZbPMqPz3RY+m+k09Ely/s/MFsbLjr9NwNX9yz0yeVZj/an5cj3MZufK5w7UWJnTpckWc8
        evp/T0lPWXTp6IE0NebMiXnr19bld9Vut3nxav2SDkbvpbq8Vw8osRRnJBpqMRcVJwIAL7/F
        pz0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSnO6SiQcSDbZ91LNomvCX2WL13X42
        i5WrjzJZvGs9x2LRefoCk8X5t4eZLCYdusZosfeWtsX8ZU/ZLdbcfMriwOWxc9Zddo/mBXdY
        PC6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoErY/dLtYILIhV/
        fq9nbWDcJtjFyMkhIWAisWLXQiYQW0hgB6PE/1sVEHFxieZrP9ghbGGJlf+es0PUfGSUODYt
        t4uRg4NNQFPiwuRSkLCIQKzEh1/HgMZwcTALTGKU2ND/AKxeWCBYYvvub2wgNouAqkTb62us
        IDavgIXEtdN3oObLS8y89B3M5hSwlDg8exkbxC4LiRMfvrBA1AtKnJz5BMxmBqpv3jqbeQKj
        wCwkqVlIUgsYmVYxSqYWFOem5xYbFhjlpZbrFSfmFpfmpesl5+duYgTHgZbWDsY9qz7oHWJk
        4mA8xCjBwawkwrtl9v5EId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQW
        wWSZODilGpjqmHVfnwrz3N5w58rRJWFTqo1tmMTNnteU3f9+oTvMd+3aZVcX5TFe/KO/Pm2n
        w+eQknN3/V47zXn15PTtDSUn1h+Wia5k8y7US7/pu3KZuXBG+qPZ5xha2Ps0Z8fvttVYK3dh
        wpzSbK3feipn5+u39lydv/vht83C++XfxL7jaf/yvdUov6bt7d01eZ/SE/7Md3CYEOqzw9Jc
        3irqgdtWOQe5vw/vWbeop9TVONffr3oU5yzKpMR0iO+P2U3z95OjecKkdm57JMb36v1MR7GP
        PmlnS6YHaQQFMbeJ3ZHN1JU/vPZ+vl/L7UdMx3lm16kJ/z3Iv0W5qdLp6A2+vy7b8798Cdxj
        Y+fcWqzftUWJpTgj0VCLuag4EQBVSk2G8gIAAA==
X-CMS-MailID: 20211220142228epcas5p2978d92d38f2015148d5f72913d6dbc3e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211220142228epcas5p2978d92d38f2015148d5f72913d6dbc3e
References: <20211220141734.12206-1-joshi.k@samsung.com>
        <CGME20211220142228epcas5p2978d92d38f2015148d5f72913d6dbc3e@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Completion of a uring_cmd ioctl may involve referencing certain
ioctl-specific fields, requiring original submitter context.
Export an API that driver can use for this purpose.
The API facilitates reusing task-work infra of io_uring, while driver
gets to implement cmd-specific handling in a callback.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c            | 16 ++++++++++++++++
 include/linux/io_uring.h |  8 ++++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e96ed3d0385e..246f1085404d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2450,6 +2450,22 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
 		io_req_complete_failed(req, -EFAULT);
 }
 
+static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
+{
+	req->uring_cmd.driver_cb(&req->uring_cmd);
+}
+
+void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *))
+{
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+
+	req->uring_cmd.driver_cb = driver_cb;
+	req->io_task_work.func = io_uring_cmd_work;
+	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
+
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
 	req->result = ret;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 64e788b39a86..f4b4990a3b62 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -14,11 +14,15 @@ struct io_uring_cmd {
 	__u16		op;
 	__u16		unused;
 	__u32		len;
+	/* used if driver requires update in task context*/
+	void (*driver_cb)(struct io_uring_cmd *cmd);
 	__u64		pdu[5];	/* 40 bytes available inline for free use */
 };
 
 #if defined(CONFIG_IO_URING)
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret);
+void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *));
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
@@ -42,6 +46,10 @@ static inline void io_uring_free(struct task_struct *tsk)
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
 {
 }
+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct io_uring_cmd *))
+{
+}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
-- 
2.25.1

