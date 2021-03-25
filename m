Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78B3349792
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 18:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCYRH0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 13:07:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51979 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhCYRHH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 13:07:07 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210325170705epoutp0336a42a907d89ec7f6b1a594a63f11aa0~vpNTQyecS2110621106epoutp030
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 17:07:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210325170705epoutp0336a42a907d89ec7f6b1a594a63f11aa0~vpNTQyecS2110621106epoutp030
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616692025;
        bh=VkNmnNVaNeR68Wxd/K1D4WnVi5XzjHjJ9ySJs/XWKpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haUAroUQwJ5jbh0NqYv6t8Ve6yNwoIBZoWNzED382oKvoPMPpjrEAnqZW/1nyVGgp
         HZAoOQb5B6Y4J2UdoxKcU8nN5RdarzNUJKw7BLByHzZWvSUK8YSyvvZZtydaa+6x2O
         zWKxSXJ3UPZxOK7vYGzRkrwZvqSMuDOOOt4Vx9ag=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210325170704epcas5p31fb9771f14aa0d15eec11a679e4156a3~vpNS5dsy92091420914epcas5p3P;
        Thu, 25 Mar 2021 17:07:04 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.07.39068.833CC506; Fri, 26 Mar 2021 02:07:04 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20210325170704epcas5p3aafad4845b9ea1a545d643121a0ee1e5~vpNSPiA3d2091420914epcas5p3O;
        Thu, 25 Mar 2021 17:07:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210325170704epsmtrp20d9edc0423f0ec743dbf397d31eb1015~vpNSOumQP0494804948epsmtrp2R;
        Thu, 25 Mar 2021 17:07:04 +0000 (GMT)
X-AuditID: b6c32a4a-60fff7000000989c-19-605cc338e3be
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.D2.33967.733CC506; Fri, 26 Mar 2021 02:07:03 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210325170702epsmtip27a8800a7e126822fa51c186a0e791745~vpNQitBKu2594425944epsmtip2i;
        Thu, 25 Mar 2021 17:07:02 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        chaitanya.kulkarni@wdc.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        nj.shetty@samsung.com, selvakuma.s1@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [RFC PATCH v4 1/2] io_uring: add helpers for io_uring_cmd
 completion in submitter-task.
Date:   Thu, 25 Mar 2021 22:35:39 +0530
Message-Id: <20210325170540.59619-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210325170540.59619-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsWy7bCmhq7F4ZgEg3c/tC2aJvxltlh9t5/N
        Ytbt1ywWK1cfZbJ413qOxeLxnc/sFkf/v2WzmHToGqPF/GVP2S22/Z7PbHFlyiJmi9c/TrI5
        8HhcPlvqsWlVJ5vH5iX1HrtvNrB59G1ZxejxeZOcR/uBbqYA9igum5TUnMyy1CJ9uwSujE8b
        1zIWNIpVTLhu08D4TqiLkZNDQsBEYseDnUwgtpDAbkaJiZ+4IOxPjBIvH6V0MXIB2d8YJZ4e
        b2GFafi45yYrRGIvo8TtLbehnM+MEs+ufGbvYuTgYBPQlLgwuRSkQUQgQGLXwc9gG5gFjjJK
        PFpZDWILCyRJXHjQxQ5iswioStw40ATWyitgIdH7IRRil7zEzEvfwUo4BSwlbv5rALuBV0BQ
        4uTMJywQI+UlmrfOZgY5QUJgLofE+6uvGSGaXSTez/oPZQtLvDq+hR3ClpL4/G4vG4RdLPHr
        zlGo5g5GiesNM1kgEvYSF/f8ZQI5iBnol/W79CGW8Un0/n4CFpYQ4JXoaIMGoqLEvUlPoeEj
        LvFwxhJWiBIPiXO/IyGh08MoMf3/a+YJjPKzkLwwC8kLsxCWLWBkXsUomVpQnJueWmxaYJSX
        Wq5XnJhbXJqXrpecn7uJEZyStLx2MD588EHvECMTB+MhRgkOZiUR3iTfmAQh3pTEyqrUovz4
        otKc1OJDjNIcLErivDsMHsQLCaQnlqRmp6YWpBbBZJk4OKUamDpXMe/ZuV5ZTOxTVPfd40vS
        Qhi+C3LccdVi4GtNUkhpL2L/bLaVLzPnirBB8VsLRY7q/y9vlqzIn5n9rpMziVf4e/uZjjlH
        bzcG/9j+PaYhb1Lq/neLpTScj1fy+KQyJ13sv37jrWGd4ykZs07jNSeUbXtSb9W/rV8a3pTx
        Rd9aZp2Q38ys554Ki5XkYs8Ha+iJWh/m3e7MdaDA8Pk5qdPMm5esW7TZf7m9SbWupZ/xrNva
        Buc+X677eGm9BHvcXd0N839sq9/xu9hknePRA2crv4ode3/LIWXORm515wdcu17fij+bx//x
        s4Sc22OejS6hzkGPZ1xjmSOTcqYkxu7VwwrR27fu5U6PLb+YpMRSnJFoqMVcVJwIAL4IuIK4
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvK754ZgEg90zrS2aJvxltlh9t5/N
        Ytbt1ywWK1cfZbJ413qOxeLxnc/sFkf/v2WzmHToGqPF/GVP2S22/Z7PbHFlyiJmi9c/TrI5
        8HhcPlvqsWlVJ5vH5iX1HrtvNrB59G1ZxejxeZOcR/uBbqYA9igum5TUnMyy1CJ9uwSujE8b
        1zIWNIpVTLhu08D4TqiLkZNDQsBE4uOem6xdjFwcQgK7GSVubFvPDpEQl2i+9gPKFpZY+e85
        mC0k8JFR4u55ky5GDg42AU2JC5NLQcIiAiESXfO2MYHMYRY4yyix/HE7I0hCWCBBomH1JrBe
        FgFViRsHmthBenkFLCR6P4RCjJeXmHnpO1gJp4ClxM1/DawQqywk7uy9yAxi8woISpyc+YQF
        xGYGqm/eOpt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBMeE
        luYOxu2rPugdYmTiYDzEKMHBrCTCm+QbkyDEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXgh
        gfTEktTs1NSC1CKYLBMHp1QDk90h5y7ZxEmHVi4pYTw5eeJ6BonTq9WF+La43P68JTbMOpD9
        jWDisUOCZivPrb/yP61xfVvtxdwL9VdfBV8+tV9HLujy18XfeFeLcFTEb4qNsPxz4OotT/bd
        i9sNZVQ+yDM0e39bpH/j+lP7Z3eNX2/wTJScee2N8ap2zwDhUo0FZ7ouFK832PVXJSt4gxaL
        47Ka8wpBSz4+vxr7UbM9826RftWfBzkcjsXdmx+8DniVPTF00kVV7XdPPc7zdDEb+fSGTmVb
        UvjO/aiG64X+mjkr+n2OHLNZYfXxENOFCVxbXMrlMoPW16j/fSlb0bL0nc3v12K/tm2Kq3gj
        laV9nfXSd+nO43tmqcq1T9KYcVyJpTgj0VCLuag4EQCbFdD3+AIAAA==
X-CMS-MailID: 20210325170704epcas5p3aafad4845b9ea1a545d643121a0ee1e5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20210325170704epcas5p3aafad4845b9ea1a545d643121a0ee1e5
References: <20210325170540.59619-1-joshi.k@samsung.com>
        <CGME20210325170704epcas5p3aafad4845b9ea1a545d643121a0ee1e5@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Completion of io_uring_cmd ioctl may involve referencing certain
ioctl-specefic fields, requiring original submitter-context.
Introduce two APIs for that purpose:
a. io_uring_cmd_complete_in_task
b. io_uring_cbh_to_io_uring_cmd

The APIs facilitate reusing task-work infra, while driver gets to
implement ioctl-specific handling in a callback.

Signed-off-by: Kanchan Joshi  <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c            | 23 +++++++++++++++++++++++
 include/linux/io_uring.h | 12 ++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b6e1b6b51c5f..a8629c460bdd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2079,6 +2079,29 @@ static void io_req_task_submit(struct callback_head *cb)
 	__io_req_task_submit(req);
 }
 
+struct io_uring_cmd *io_uring_cbh_to_io_uring_cmd(struct callback_head *cb)
+{
+	return &container_of(cb, struct io_kiocb, task_work)->uring_cmd;
+}
+EXPORT_SYMBOL_GPL(io_uring_cbh_to_io_uring_cmd);
+
+int io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct callback_head *))
+{
+	int ret;
+	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+
+	req->task_work.func = driver_cb;
+	ret = io_req_task_work_add(req);
+	if (unlikely(ret)) {
+		req->result = -ECANCELED;
+		percpu_ref_get(&req->ctx->refs);
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
+
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
 	req->result = ret;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 9956c0f5f9d0..526bc58dea25 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -19,6 +19,9 @@ struct io_uring_cmd {
 
 #if defined(CONFIG_IO_URING)
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret);
+int io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct callback_head *));
+struct io_uring_cmd *io_uring_cbh_to_io_uring_cmd(struct callback_head *cbh);
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_task_cancel(void);
 void __io_uring_files_cancel(struct files_struct *files);
@@ -43,6 +46,15 @@ static inline void io_uring_free(struct task_struct *tsk)
 static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
 {
 }
+int io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
+			void (*driver_cb)(struct callback_head *))
+{
+	return -1;
+}
+struct io_uring_cmd *io_uring_cbh_to_io_uring_cmd(struct callback_head *)
+{
+	return NULL;
+}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
-- 
2.25.1

