Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D1C706563
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 12:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjEQKhI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 06:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjEQKhH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 06:37:07 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4143AA1
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 03:37:04 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230517103700epoutp0304e351cf8d2eb134db9f4c9148806477~f5-PTI9DO0515105151epoutp03N
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 10:37:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230517103700epoutp0304e351cf8d2eb134db9f4c9148806477~f5-PTI9DO0515105151epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684319820;
        bh=EMMsT4WvkgqIKI0pmzWb/0/zW50yz6q81OjErKncAjw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k6zElb8dvoXux5zzLuFmNelJoeXo5qToI1wdnL0V2ppFKjkr+Rp3qpYcfXdU1U6Sp
         /mSortXMVkm2cjyFIgtxE8OdAXUQ3RCAXvBqHEsvcAjW5maDWZKqcFXv7eY1NaFvoC
         ZuL+xaEefK11ZJ6iDg4Z2QEBi/yoH90jphf2/UNI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230517103659epcas5p2c9c27720008b171356498475eab77328~f5-O5WTfR0808408084epcas5p2j;
        Wed, 17 May 2023 10:36:59 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4QLqKk2Jmgz4x9Pp; Wed, 17 May
        2023 10:36:58 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        90.22.54880.A4EA4646; Wed, 17 May 2023 19:36:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230517103657epcas5p34671066feb44ca15179e3e3fd25aeba4~f5-NML9JS2644026440epcas5p3B;
        Wed, 17 May 2023 10:36:57 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230517103657epsmtrp2f4cddec5d09ff77dcc4346072e1cf3d6~f5-NLhKbL3074730747epsmtrp2y;
        Wed, 17 May 2023 10:36:57 +0000 (GMT)
X-AuditID: b6c32a49-b21fa7000001d660-f4-6464ae4ae4e4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.7D.28392.94EA4646; Wed, 17 May 2023 19:36:57 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230517103656epsmtip1504e7582bd8dfbe16a6b64c7247a8b48~f5-L_l-Am2953429534epsmtip1E;
        Wed, 17 May 2023 10:36:56 +0000 (GMT)
Date:   Wed, 17 May 2023 16:03:56 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me
Subject: Re: [PATCH for-next 1/2] io_uring/cmd: add cmd lazy tw wake helper
Message-ID: <20230517103346.GA15743@green245>
MIME-Version: 1.0
In-Reply-To: <65514f94-ac70-08df-a866-fe73f95037fd@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKJsWRmVeSWpSXmKPExsWy7bCmhq7XupQUg45Wbos5q7YxWqy+289m
        sXL1USaLd63nWCwmHbrGaLH3lrbF/GVP2S3WvX7P4sDhsXPWXXaP8/c2snhcPlvqsWlVJ5vH
        5iX1HrtvNrB5fN4kF8AelW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
        aqvk4hOg65aZA3SSkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQv
        XS8vtcTK0MDAyBSoMCE7o73vAnNBg2FFa8dT5gbGJu0uRk4OCQETiUtdW1i7GLk4hAR2M0qs
        vXGMHcL5xCjxet4JZgjnM6PE7pkPGWFaXj/YxQpiCwnsYpSYvdcUougZo8SMnWfYQBIsAqoS
        L77PYepi5OBgE9CUuDC5FCQsIqAt8fr6IXYQm1lgPqPE6cfcILawgLfEo8svmEFsXgFdifvX
        F7BB2IISJ2c+YQGxOQVsJXb82QJmiwooSxzYdpwJZK+EwFIOiVMNL1kgjnORWPdiLtShwhKv
        jm9hh7ClJD6/28sGYSdLXJp5jgnCLpF4vOcglG0v0XqqnxniuAyJO3O3M0LYfBK9v5+A/SIh
        wCvR0SYEUa4ocW/SU1YIW1zi4YwlrBAlHhK7VvJBgmQ7k8TLmVsYJzDKzULyziwkGyBsK4nO
        D02sELa8RPPW2cyzgEYxC0hLLP/HAWFqSqzfpb+AkW0Vo2RqQXFuemqxaYFhXmo5PLqT83M3
        MYLTq5bnDsa7Dz7oHWJk4mA8xCjBwawkwhvYl5wixJuSWFmVWpQfX1Sak1p8iNEUGFMTmaVE
        k/OBCT6vJN7QxNLAxMzMzMTS2MxQSZxX3fZkspBAemJJanZqakFqEUwfEwenVAMTh+kZpja9
        FdM95LLvvfBeHnSx7v7JYzFZAooztXrdDlXOlGDcv2zvoWvZF6WF1vxdJLaEe+rEzOMKvL6r
        F1idZYg3Wv1DKHSGQnxwiZ2rEkP6p/aghta553euNJ0TtVC0lXtCbXNYkVjwx2cx+/t2eC/M
        f6TC+Vr/8Yaoj4ckdxY/UV9nz/2+NUHsw5m5EhXZaw9oZWvuXawjLP6++oFHkk/d9AfeEY9F
        pi3NMZ6w2/iXCNvClLPrXF4f1wt8bHpx+bGr35fmX5Q/cVZJJvG6OmfIr59Fh8uitz2xvVP+
        UGDygYhly6bE7272PnVk36mSE43aBzbq91TM0FmvNFHDcsOXefc3Xrh9j01Qevfjz0osxRmJ
        hlrMRcWJAIsP5tc4BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTtdzXUqKQesiTYs5q7YxWqy+289m
        sXL1USaLd63nWCwmHbrGaLH3lrbF/GVP2S3WvX7P4sDhsXPWXXaP8/c2snhcPlvqsWlVJ5vH
        5iX1HrtvNrB5fN4kF8AexWWTkpqTWZZapG+XwJXRvOMha8FEvYrd07ezNjBu0Ohi5OSQEDCR
        eP1gF2sXIxeHkMAORonLB96wQSTEJZqv/WCHsIUlVv57zg5R9IRR4u7cCUwgCRYBVYkX3+cA
        2RwcbAKaEhcml4KERQS0JV5fPwRWzywwn1Hi5ZfbrCAJYQFviUeXXzCD2LwCuhL3ry9ggxi6
        nUli0qtd7BAJQYmTM5+wgNjMAmYS8zY/ZAZZwCwgLbH8HwdEWF6ieetssDmcArYSO/5sASsX
        FVCWOLDtONMERqFZSCbNQjJpFsKkWUgmLWBkWcUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpec
        n7uJERxNWlo7GPes+qB3iJGJg/EQowQHs5IIb2BfcooQb0piZVVqUX58UWlOavEhRmkOFiVx
        3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTP2FnjwN5d6113hnhC4rmiJ6LjeK+X1M4aHYGy3x
        Mo8/6DP6f4xTdmN7Nm91NK/fpyMRU4J/3XxaIpyx1aNh4b9483xzOxnuuZ46ko2r3n/S8nt3
        8fnDfTqrajvPzKmt97PsiK9YLLKpa47VgYVyt++++Z2ls+Nr4OnTzHa3Kyf7ymzdYLn2/i+9
        K0smbn+z54TI9xU7ttxaPV/byNDf6O8j1egNmxVyzifErz7OdPDwQf+FeRwcaz8oL9iXpvB3
        7u+wlvZHruGMz6dWfTJf8aYk36rguujtE6Xq+112S7PkO7nnzm4Q++5SL/5uA0PbnTs78rjO
        cqptnvPnTxkLt/35xT83RDv/mhZ5lTGSQVyJpTgj0VCLuag4EQBS+TngFQMAAA==
X-CMS-MailID: 20230517103657epcas5p34671066feb44ca15179e3e3fd25aeba4
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_9bb1a_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230515125841epcas5p3e3cba6545755e95739e1561222b00b4a
References: <cover.1684154817.git.asml.silence@gmail.com>
        <CGME20230515125841epcas5p3e3cba6545755e95739e1561222b00b4a@epcas5p3.samsung.com>
        <5b9f6716006df7e817f18bd555aee2f8f9c8b0c3.1684154817.git.asml.silence@gmail.com>
        <20230516100000.GA26860@green245>
        <65514f94-ac70-08df-a866-fe73f95037fd@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_9bb1a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On Tue, May 16, 2023 at 07:52:23PM +0100, Pavel Begunkov wrote:
>On 5/16/23 11:00, Kanchan Joshi wrote:
>>On Mon, May 15, 2023 at 01:54:42PM +0100, Pavel Begunkov wrote:
>>>We want to use IOU_F_TWQ_LAZY_WAKE in commands. First, introduce a new
>>>cmd tw helper accepting TWQ flags, and then add
>>>io_uring_cmd_do_in_task_laz() that will pass IOU_F_TWQ_LAZY_WAKE and
>>>imply the "lazy" semantics, i.e. it posts no more than 1 CQE and
>>>delaying execution of this tw should not prevent forward progress.
>>>
>>>Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>---
>>>include/linux/io_uring.h | 18 ++++++++++++++++--
>>>io_uring/uring_cmd.c     | 16 ++++++++++++----
>>>2 files changed, 28 insertions(+), 6 deletions(-)
>>>
>>>diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>>>index 7fe31b2cd02f..bb9c666bd584 100644
>>>--- a/include/linux/io_uring.h
>>>+++ b/include/linux/io_uring.h
>>>@@ -46,13 +46,23 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>>>                  struct iov_iter *iter, void *ioucmd);
>>>void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
>>>            unsigned issue_flags);
>>>-void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>>>-            void (*task_work_cb)(struct io_uring_cmd *, unsigned));
>>>struct sock *io_uring_get_socket(struct file *file);
>>>void __io_uring_cancel(bool cancel_all);
>>>void __io_uring_free(struct task_struct *tsk);
>>>void io_uring_unreg_ringfd(void);
>>>const char *io_uring_get_opcode(u8 opcode);
>>>+void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>>>+                void (*task_work_cb)(struct io_uring_cmd *, unsigned),
>>>+                unsigned flags);
>>>+/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */
>>
>>Should this also translate to some warn_on anywhere?
>
>Would love to but don't see how. We can only check it doesn't
>produce more than 1 CQE, but that would need
>
>nr_cqes_before = cqes_ready();
>tw_item->run();
>WARN_ON(cqes_ready() >= nr_cqes_before + 1);
>
>but that's just too ugly
>
>
>>>+void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>>>+            void (*task_work_cb)(struct io_uring_cmd *, unsigned));
>>>+
>>>+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>>>+            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>>>+{
>>>+    __io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
>>>+}
>>>
>>>static inline void io_uring_files_cancel(void)
>>>{
>>>@@ -85,6 +95,10 @@ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>>>            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>>>{
>>>}
>>>+static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>>>+            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>>>+{
>>>+}
>>>static inline struct sock *io_uring_get_socket(struct file *file)
>>>{
>>>    return NULL;
>>>diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>index 5e32db48696d..476c7877ce58 100644
>>>--- a/io_uring/uring_cmd.c
>>>+++ b/io_uring/uring_cmd.c
>>>@@ -20,16 +20,24 @@ static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>>>    ioucmd->task_work_cb(ioucmd, issue_flags);
>>>}
>>>
>>>-void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>>>-            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>>>+void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>>>+            void (*task_work_cb)(struct io_uring_cmd *, unsigned),
>>>+            unsigned flags)
>>>{
>>>    struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>>>
>>>    ioucmd->task_work_cb = task_work_cb;
>>>    req->io_task_work.func = io_uring_cmd_work;
>>>-    io_req_task_work_add(req);
>>>+    __io_req_task_work_add(req, flags);
>>>+}
>>>+EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);
>
>--- a/include/linux/io_uring.h
>+++ b/include/linux/io_uring.h
>
>+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>+{
>+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
>+}
>
>That should fail for nvme unless exported.

But it does not. Give it a try.

>>Any reason to export this? No one is using this at the moment.
>>>+void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>>>+            void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>>>+{
>>>+    __io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
>>>}
>>>-EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
>>>+EXPORT_SYMBOL_GPL(io_uring_cmd_do_in_task_lazy);
>>
>>Seems you did not want callers to pass the the new flag (LAZY_WAKE) and
>>therefore this helper.
>
>Yep, I wouldn't mind exposing just *LAZY_WAKE but don't want
>to let it use whatever flags there might be in the future.
>
>Initially I wanted to just make io_uring_cmd_complete_in_task and
>io_uring_cmd_do_in_task_lazy static inline, but that would need
>some code shuffling to make it clean.
>
>>And if you did not want callers to know about this flag (internal
>>details of io_uring), it would be better to have two exported helpers
>>io_uring_cmd_do_in_task_lazy() and io_uring_cmd_complete_in_task().
>>Both will use the internal helper __io_uring_cmd_do_in_task with
>>different flag.
>
>That's how it should be in this patch

Nah, in this patch __io_uring_cmd_do_in_task is exported helper. And
io_uring_cmd_complete_in_task has been changed too (explicit export to
header based one). Seems like bit more shuffling than what is necessary.

------6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_9bb1a_
Content-Type: text/plain; charset="utf-8"


------6TPaBgSVJHTP5aYW_KCyJfD-AyyqAIDIArT8HI0pnVcs47o3=_9bb1a_--
