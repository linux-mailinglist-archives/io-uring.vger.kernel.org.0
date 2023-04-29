Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44F66F23F1
	for <lists+io-uring@lfdr.de>; Sat, 29 Apr 2023 11:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjD2Jm4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Apr 2023 05:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjD2Jmw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Apr 2023 05:42:52 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C281BEC
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 02:42:50 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230429094248epoutp01d6342258b0b755237185e0d9185af60d~aXoyWAPLs2540625406epoutp015
        for <io-uring@vger.kernel.org>; Sat, 29 Apr 2023 09:42:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230429094248epoutp01d6342258b0b755237185e0d9185af60d~aXoyWAPLs2540625406epoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682761368;
        bh=4c/Krci4Z4CXyKaTGDw8RdWSrdEiCYIykDkltCWySjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duwFNA/qyM9HNzlo4LfgsgAoIsRuRtjRvVcbsZq4HNpqKehl/66uyWHbSvMiflbq5
         cCVp6hhO/Eec4vMdjrSPwUvkbw8MLt3wRScl/VXTiBFArFmcZh+ALaBejbi22L8joe
         yXZS+F4uCAaj8SmlnMYHtaDXe/jdc0zTgRvVOs9o=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230429094247epcas5p1dd95493cde0ef020ba1761d668b90591~aXoxUTG3c2857728577epcas5p1i;
        Sat, 29 Apr 2023 09:42:47 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Q7kzT75Tlz4x9Pp; Sat, 29 Apr
        2023 09:42:45 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3B.50.55646.596EC446; Sat, 29 Apr 2023 18:42:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094245epcas5p2843abc5cd54ffe301d36459543bcd228~aXovdMmAn2071420714epcas5p26;
        Sat, 29 Apr 2023 09:42:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230429094245epsmtrp1bd351d6ec504f4a91026fa26bbb47fd8~aXovcaQtH0376803768epsmtrp1r;
        Sat, 29 Apr 2023 09:42:45 +0000 (GMT)
X-AuditID: b6c32a4b-913ff7000001d95e-e4-644ce69529c2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.38.27706.596EC446; Sat, 29 Apr 2023 18:42:45 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230429094243epsmtip25ece63685e3de64d93e5fa79dc9c9281~aXotNyDAy0191201912epsmtip2J;
        Sat, 29 Apr 2023 09:42:43 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        anuj1072538@gmail.com, xiaoguang.wang@linux.alibaba.com,
        Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH 04/12] io_uring, fs: plumb support to
 register/unregister raw-queue
Date:   Sat, 29 Apr 2023 15:09:17 +0530
Message-Id: <20230429093925.133327-5-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230429093925.133327-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmpu7UZz4pBqt7zS0+fv3NYtE04S+z
        xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF3lvaFvOXPWW3WPf6PYvFpr8nmRx4
        PHbOusvucf7eRhaPy2dLPTat6mTz2PnQ0mPzknqP3Tcb2Dz6tqxi9Pi8SS6AMyrbJiM1MSW1
        SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoXiWFssScUqBQQGJx
        sZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsbHBftYC/5q
        V7x58I6xgbFLpYuRk0NCwETiRdNN5i5GLg4hgd2MEvu3nWOFcD4xSjzYtZYRwvnGKLHuzyUm
        mJaOHatZIBJ7GSXeP2tiA0kICXxmlHh+I6qLkYODTUBT4sLkUpCwiICLRNPaqWwg9cwgg5p2
        z2UBSQgLREp0/GxnBrFZBFQlZh9pAovzClhKbFj7gB1imbzEzEvfwWxOASuJ7zN2M0PUCEqc
        nPkErJ4ZqKZ562ywHyQElnJI3D5wmxWi2UViUedMFghbWOLV8S1QQ6UkXva3QdnJEpdmnoP6
        rETi8Z6DULa9ROupfmaQZ5iBnlm/Sx9iF59E7+8nTCBhCQFeiY42IYhqRYl7k55CbRWXeDhj
        CZTtIfH1zV92SFj1Mkr8+vOdcQKj/CwkL8xC8sIshG0LGJlXMUqmFhTnpqcWmxYY56WWwyM2
        OT93EyM42Wp572B89OCD3iFGJg7GQ4wSHMxKIry8le4pQrwpiZVVqUX58UWlOanFhxhNgWE8
        kVlKNDkfmO7zSuINTSwNTMzMzEwsjc0MlcR51W1PJgsJpCeWpGanphakFsH0MXFwSjUwbRMz
        2xshc1rmWeKvTbc7FOY2GXdJ1GwwfTBfTLPXdn4iy0S7HRuuL/13aJfW9L6b7j7VO57PZ9w2
        fbuu95GXustelcyraREXipPqmufQvT7SfhmPaNXV4imRuw74pl6v8Sn4VcZ16U/ctXwtkUqV
        x6G7Fmn/dT7zYYLhawmbv5oJi8ytNHUPbDu7dlKB8LV7i1euf35uJ0u6/8NMw/cL3R6rcwVW
        rCxQaWNX4NaV2ORzhJ1b1iHlkkpn2sbHMtKXVOSzTJiutLQVLpmtbf2wKqj8pvX7hK7kOsWI
        3vmbTp6cs+rExGO6cyqD+C5/co44VnDmteq3T9umN4dKVn0N2nCPfcW7qFXv3h6VYVq0Woml
        OCPRUIu5qDgRACfhNU8/BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWy7bCSvO7UZz4pBg/3SVp8/PqbxaJpwl9m
        i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaLvbe0LeYve8puse71exaLTX9PMjnw
        eOycdZfd4/y9jSwel8+Wemxa1cnmsfOhpcfmJfUeu282sHn0bVnF6PF5k1wAZxSXTUpqTmZZ
        apG+XQJXxscF+1gL/mpXvHnwjrGBsUuli5GTQ0LARKJjx2qWLkYuDiGB3YwSZ7dsZINIiEs0
        X/vBDmELS6z895wdougjo8TWU88Zuxg5ONgENCUuTC4FqRER8JJofzuLDaSGWeAfo8T7r5eZ
        QBLCAuESfzdfBhvKIqAqMftIEwuIzStgKbFh7QOoBfISMy99B7M5Bawkvs/YzQwyXwiopnFB
        PES5oMTJmU/AWpmBypu3zmaewCgwC0lqFpLUAkamVYySqQXFuem5xYYFhnmp5XrFibnFpXnp
        esn5uZsYwXGipbmDcfuqD3qHGJk4GA8xSnAwK4nw8la6pwjxpiRWVqUW5ccXleakFh9ilOZg
        URLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAZBa2cG7+oQRW7qDoaC3ekg8nTrNn8P7laYx9
        uIV94VvrB4KylzPruFl0961b/G7J4q6r9+6ds2OaG+V1cbpD55G1c289+CJjUm0Wlb9cK3Ld
        +7n/Ga402zvemcW7bkWeypMC0TU9TPZL5x05yMTMLGt2KNeqynrbxM8R4VJHdZZ/usi2ze/9
        drX2zCONd7kyS3pNSp/qV7d9YBfj7wnUynshzD0hrt72lNSbr68WmO2V2yF43IL1Y0SBk7Nv
        kNLU1f6Bt0qmKZfoMnHKeO/d+uJ1Ul3UHj+zY6oMCpvu/3GvOSDBpnpybth1ibMvywM/hpha
        BszedOmAZYa3s6nB/cOl0fxs3o8vxyxWzBBXYinOSDTUYi4qTgQADox1lAIDAAA=
X-CMS-MailID: 20230429094245epcas5p2843abc5cd54ffe301d36459543bcd228
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230429094245epcas5p2843abc5cd54ffe301d36459543bcd228
References: <20230429093925.133327-1-joshi.k@samsung.com>
        <CGME20230429094245epcas5p2843abc5cd54ffe301d36459543bcd228@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Extend io_uring's registration interface with

- IORING_REGISTER_QUEUE: to ask for a queue. It goes down via
fops->register_queue and returns identifier of the queue. This qid is
stored in ring's ctx.

- IORING_UNREGISTER_QUEUE: to return the previously registered queue.

At max one queue is allowed to be attached with the io_uring's ring.
The file for which queue is requested is expected to be in
registered file-set.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/file.c                      | 14 ++++++++
 include/linux/fs.h             |  2 ++
 include/linux/io_uring_types.h |  3 ++
 include/uapi/linux/io_uring.h  |  4 +++
 io_uring/io_uring.c            | 60 ++++++++++++++++++++++++++++++++++
 5 files changed, 83 insertions(+)

diff --git a/fs/file.c b/fs/file.c
index 7893ea161d77..7dada9cd0911 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1318,3 +1318,17 @@ int iterate_fd(struct files_struct *files, unsigned n,
 	return res;
 }
 EXPORT_SYMBOL(iterate_fd);
+
+int file_register_queue(struct file *file)
+{
+	if (file->f_op->register_queue)
+		return file->f_op->register_queue(file);
+	return -EINVAL;
+}
+
+int file_unregister_queue(struct file *file, int qid)
+{
+	if (file->f_op->unregister_queue)
+		return file->f_op->unregister_queue(file, qid);
+	return -EINVAL;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 79acccc5e7d4..0a82aac6868b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3190,5 +3190,7 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 		       int advice);
 extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 			   int advice);
+int file_register_queue(struct file *file);
+int file_unregister_queue(struct file *file, int qid);
 
 #endif /* _LINUX_FS_H */
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1b2a20a42413..8d4e721493d6 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -364,6 +364,9 @@ struct io_ring_ctx {
 	unsigned			sq_thread_idle;
 	/* protected by ->completion_lock */
 	unsigned			evfd_last_cq_tail;
+	/* for io_uring attached device queue */
+	int				dev_qid;
+	int				dev_fd;
 };
 
 struct io_tw_state {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0716cb17e436..a9d59bfd26f7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -523,6 +523,10 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* register a device-queue with the ring */
+	IORING_REGISTER_QUEUE			= 26,
+	IORING_UNREGISTER_QUEUE			= 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bca7a79efda..5a9b7adf438e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -337,6 +337,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+	/* -EINVAL implies nothing is registered with this ring */
+	ctx->dev_qid = -EINVAL;
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -2822,6 +2824,51 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
+static int io_register_queue(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_fixed_file *file_slot;
+	struct file *file;
+	__s32 __user *fds = arg;
+	int fd, qid;
+
+	if (ctx->dev_qid != -EINVAL)
+		return -EINVAL;
+	if (copy_from_user(&fd, fds, sizeof(*fds)))
+		return -EFAULT;
+	file_slot = io_fixed_file_slot(&ctx->file_table,
+			array_index_nospec(fd, ctx->nr_user_files));
+	if (!file_slot->file_ptr)
+		return -EBADF;
+	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+	qid = file_register_queue(file);
+	if (qid < 0)
+		return qid;
+	ctx->dev_fd = fd;
+	ctx->dev_qid = qid;
+	return 0;
+}
+
+static int io_unregister_queue(struct io_ring_ctx *ctx)
+{
+	struct io_fixed_file *file_slot;
+	struct file *file;
+	int ret;
+
+	if (ctx->dev_qid == -EINVAL)
+		return 0;
+	file_slot = io_fixed_file_slot(&ctx->file_table,
+			array_index_nospec(ctx->dev_fd, ctx->nr_user_files));
+	if (!file_slot)
+		return -EBADF;
+	if (!file_slot->file_ptr)
+		return -EBADF;
+	file = (struct file *)(file_slot->file_ptr & FFS_MASK);
+	ret = file_unregister_queue(file, ctx->dev_qid);
+	if (!ret)
+		ctx->dev_qid = -EINVAL;
+	return ret;
+}
+
 static void io_rsrc_node_cache_free(struct io_cache_entry *entry)
 {
 	kfree(container_of(entry, struct io_rsrc_node, cache));
@@ -2835,6 +2882,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		return;
 
 	mutex_lock(&ctx->uring_lock);
+	io_unregister_queue(ctx);
 	if (ctx->buf_data)
 		__io_sqe_buffers_unregister(ctx);
 	if (ctx->file_data)
@@ -4418,6 +4466,18 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_file_alloc_range(ctx, arg);
 		break;
+	case IORING_REGISTER_QUEUE:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_queue(ctx, arg);
+		break;
+	case IORING_UNREGISTER_QUEUE:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_unregister_queue(ctx);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.25.1

