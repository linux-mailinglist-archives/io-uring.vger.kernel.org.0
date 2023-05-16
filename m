Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355FD7049F9
	for <lists+io-uring@lfdr.de>; Tue, 16 May 2023 12:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjEPKDh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 May 2023 06:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjEPKDg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 May 2023 06:03:36 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8307C1986
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 03:03:19 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230516100316epoutp0307a8db0d58661bd0cbdb73a363377d3d~fl4g4zNBE0766307663epoutp03n
        for <io-uring@vger.kernel.org>; Tue, 16 May 2023 10:03:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230516100316epoutp0307a8db0d58661bd0cbdb73a363377d3d~fl4g4zNBE0766307663epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684231397;
        bh=OKhd9yhd0Kzyd/2edlBmu79oNc0LJJaxjWsUcWASZWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fDGu8NqRoW3JEaP9XBCtEWzO+us4zwPo4gl+CtcLjDnFPVuR7k8jJ3imxuKbniDKS
         LCBw1oCgY+++kLqvzsJLglrI5AII3FjrgWq3EInkOt0trvFS+jwmZmIoDceTXN+Dqn
         ruWKmF6Zc2UxV0wxLRU+TDo31LLlH88OhaHg7Zc8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230516100315epcas5p40cffefaf5d5210380d7553ddffb6a46f~fl4f9gLQ10916609166epcas5p4-;
        Tue, 16 May 2023 10:03:15 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4QLBdG5RX2z4x9Pt; Tue, 16 May
        2023 10:03:14 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.18.57769.1E453646; Tue, 16 May 2023 19:03:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230516100312epcas5p15a8ff75ad757f14f327efb816e92adb4~fl4cpkpYZ1510915109epcas5p1x;
        Tue, 16 May 2023 10:03:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230516100312epsmtrp2d9382f57c861cf88d3af9ce6e402a2aa~fl4co2wwt0326403264epsmtrp2Y;
        Tue, 16 May 2023 10:03:12 +0000 (GMT)
X-AuditID: b6c32a4a-f3bfd7000001e1a9-a1-646354e15cd5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.80.27706.0E453646; Tue, 16 May 2023 19:03:12 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230516100311epsmtip28c9dca6cafca342d700265ce9b52b519~fl4bYJKao3194931949epsmtip2d;
        Tue, 16 May 2023 10:03:10 +0000 (GMT)
Date:   Tue, 16 May 2023 15:30:11 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me
Subject: Re: [PATCH for-next 1/2] io_uring/cmd: add cmd lazy tw wake helper
Message-ID: <20230516100000.GA26860@green245>
MIME-Version: 1.0
In-Reply-To: <5b9f6716006df7e817f18bd555aee2f8f9c8b0c3.1684154817.git.asml.silence@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmlu7DkOQUg9PfNC3mrNrGaLH6bj+b
        xcrVR5ks3rWeY7GYdOgao8XeW9oW85c9ZbdY9/o9iwOHx85Zd9k9zt/byOJx+Wypx6ZVnWwe
        m5fUe+y+2cDm8XmTXAB7VLZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
        qq2Si0+ArltmDtBJSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCkwK94sTc4tK8
        dL281BIrQwMDI1OgwoTsjAtHHzIWPFGqeLL5JWMDY6NcFyMnh4SAicSB2zdYQGwhgd2MEo8a
        /LoYuYDsT4wSLVvWMkE43xglpt6fwQrT8bZlKRtEYi+jxKIHE6HanzFKnH5VCWKzCKhKXJn3
        AqiIg4NNQFPiwuRSkLCIgLbE6+uH2EFsZoH5QOWPuUFsYQFviUeXXzCD2LwCuhL792xihLAF
        JU7OfAI2nlMgVuLatx9gvaICyhIHth0HO05CYCqHxO4129ggjnORWDh7BTuELSzx6vgWKFtK
        4vO7vVA1yRKXZp5jgrBLJB7vOQhl20u0nupnhjguQ2LbjT2MEDafRO/vJ0wgv0gI8Ep0tAlB
        lCtK3Jv0FBom4hIPZyxhhSjxkNi1kg8SPA8YJVov3GGfwCg3C8k7s5BsgLCtJDo/NLHOAmpn
        FpCWWP6PA8LUlFi/S38BI+sqRsnUguLc9NRi0wKjvNRyeAwn5+duYgQnUS2vHYwPH3zQO8TI
        xMF4iFGCg1lJhLd9ZnyKEG9KYmVValF+fFFpTmrxIUZTYOxMZJYSTc4HpvG8knhDE0sDEzMz
        MxNLYzNDJXFedduTyUIC6YklqdmpqQWpRTB9TBycUg1MsRe62z/8qwpX17JPlfQ5psrW8HFG
        7gIugxjT85tNQydvnld0S908yHitvph2xuQfq2LWbhNyOHTZ7+SCMBNbkdu1hjt37bh13bhF
        73yPtZ212vKvMfVJjwSU1h02WdwpL1ObIKPwMLlsTaH8ZzPLU4ps3zslcqyUkzj2JIR55Kt5
        h5tuS9ljdyUt0Dq9NP7UBXb+9u+LzDlzr5w+pukS1PrQKEFoi++Snyk9LHGlxoHxKtlNvpcd
        v2m462ZdVgm5vfjn8nWNR4/Fvo3ybM1dKrn61sLeE6XnrTZsstu3fWaG/U7l9WcmruIJmKPf
        cXDutHiXJPcPutZTXuZ01letdbgezbvm3Mn0mWc+XVJiKc5INNRiLipOBAC8r5w3KwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSvO6DkOQUg5OfxCzmrNrGaLH6bj+b
        xcrVR5ks3rWeY7GYdOgao8XeW9oW85c9ZbdY9/o9iwOHx85Zd9k9zt/byOJx+Wypx6ZVnWwe
        m5fUe+y+2cDm8XmTXAB7FJdNSmpOZllqkb5dAlfGxRuLWAqmKVRM6HnA3sB4VrqLkZNDQsBE
        4m3LUrYuRi4OIYHdjBLXWjcyQyTEJZqv/WCHsIUlVv57zg5R9IRRYsb9f4wgCRYBVYkr814A
        dXNwsAloSlyYXAoSFhHQlnh9/RBYPbPAfEaJl19us4IkhAW8JR5dfgG2gFdAV2L/nk1gc4QE
        HjBKnPkgDREXlDg58wkLiM0sYCYxb/NDZpD5zALSEsv/cYCEOQViJa59g7hNVEBZ4sC240wT
        GAVnIemehaR7FkL3AkbmVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwbGhpbmDcfuq
        D3qHGJk4GA8xSnAwK4nwts+MTxHiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2
        ampBahFMlomDU6qBKalu7q1tvFKHn384IHPaKud4nUvE+3OmPTIBD7d2X838FjBz+cZlc2ob
        Vv++FOrb/su0Ian0rfBh5qaNTf+3CXY9X8U992zmv4D79mZ6+dZMIbkRb9quffL//uJByelX
        hWETt1XeMBNe6nEsr3zR84cqzFnMW6OC7/v9eJSZuXmF8ILkHf90pPhTZV4/Wy/rr2a1qq76
        568LH5k+J0dkXDBbcWjznP9Tf/xq2vn8+ZbUj4ZTagMyUrzeV4ZvrKjk/F/uqrds380pptsW
        /TC3e3bugMLpKy5zty+6H/SnxzuNQ5lLlH/dJtWu43PONRSycMUlvKy7FKmzIPxbAZdylPZH
        oS8fj5v8Y9pr/bRTvUGJpTgj0VCLuag4EQAb3Iu7/AIAAA==
X-CMS-MailID: 20230516100312epcas5p15a8ff75ad757f14f327efb816e92adb4
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----w2jaHPLYrpKrCfQkcJ8LedpAWTKxgBVMFdZj2Hgt3-WHfK.r=_96701_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230515125841epcas5p3e3cba6545755e95739e1561222b00b4a
References: <cover.1684154817.git.asml.silence@gmail.com>
        <CGME20230515125841epcas5p3e3cba6545755e95739e1561222b00b4a@epcas5p3.samsung.com>
        <5b9f6716006df7e817f18bd555aee2f8f9c8b0c3.1684154817.git.asml.silence@gmail.com>
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

------w2jaHPLYrpKrCfQkcJ8LedpAWTKxgBVMFdZj2Hgt3-WHfK.r=_96701_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, May 15, 2023 at 01:54:42PM +0100, Pavel Begunkov wrote:
>We want to use IOU_F_TWQ_LAZY_WAKE in commands. First, introduce a new
>cmd tw helper accepting TWQ flags, and then add
>io_uring_cmd_do_in_task_laz() that will pass IOU_F_TWQ_LAZY_WAKE and
>imply the "lazy" semantics, i.e. it posts no more than 1 CQE and
>delaying execution of this tw should not prevent forward progress.
>
>Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>---
> include/linux/io_uring.h | 18 ++++++++++++++++--
> io_uring/uring_cmd.c     | 16 ++++++++++++----
> 2 files changed, 28 insertions(+), 6 deletions(-)
>
>diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>index 7fe31b2cd02f..bb9c666bd584 100644
>--- a/include/linux/io_uring.h
>+++ b/include/linux/io_uring.h
>@@ -46,13 +46,23 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> 			      struct iov_iter *iter, void *ioucmd);
> void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2,
> 			unsigned issue_flags);
>-void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>-			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
> struct sock *io_uring_get_socket(struct file *file);
> void __io_uring_cancel(bool cancel_all);
> void __io_uring_free(struct task_struct *tsk);
> void io_uring_unreg_ringfd(void);
> const char *io_uring_get_opcode(u8 opcode);
>+void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>+			    void (*task_work_cb)(struct io_uring_cmd *, unsigned),
>+			    unsigned flags);
>+/* users should follow semantics of IOU_F_TWQ_LAZY_WAKE */

Should this also translate to some warn_on anywhere?
>+void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>+			void (*task_work_cb)(struct io_uring_cmd *, unsigned));
>+
>+static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>+{
>+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
>+}
>
> static inline void io_uring_files_cancel(void)
> {
>@@ -85,6 +95,10 @@ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
> 			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
> {
> }
>+static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>+{
>+}
> static inline struct sock *io_uring_get_socket(struct file *file)
> {
> 	return NULL;
>diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>index 5e32db48696d..476c7877ce58 100644
>--- a/io_uring/uring_cmd.c
>+++ b/io_uring/uring_cmd.c
>@@ -20,16 +20,24 @@ static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
> 	ioucmd->task_work_cb(ioucmd, issue_flags);
> }
>
>-void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>-			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>+void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>+			void (*task_work_cb)(struct io_uring_cmd *, unsigned),
>+			unsigned flags)
> {
> 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>
> 	ioucmd->task_work_cb = task_work_cb;
> 	req->io_task_work.func = io_uring_cmd_work;
>-	io_req_task_work_add(req);
>+	__io_req_task_work_add(req, flags);
>+}
>+EXPORT_SYMBOL_GPL(__io_uring_cmd_do_in_task);

Any reason to export this? No one is using this at the moment.
>+void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
>+			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
>+{
>+	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, IOU_F_TWQ_LAZY_WAKE);
> }
>-EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
>+EXPORT_SYMBOL_GPL(io_uring_cmd_do_in_task_lazy);

Seems you did not want callers to pass the the new flag (LAZY_WAKE) and
therefore this helper.
And if you did not want callers to know about this flag (internal
details of io_uring), it would be better to have two exported helpers
io_uring_cmd_do_in_task_lazy() and io_uring_cmd_complete_in_task().
Both will use the internal helper __io_uring_cmd_do_in_task with
different flag.

------w2jaHPLYrpKrCfQkcJ8LedpAWTKxgBVMFdZj2Hgt3-WHfK.r=_96701_
Content-Type: text/plain; charset="utf-8"


------w2jaHPLYrpKrCfQkcJ8LedpAWTKxgBVMFdZj2Hgt3-WHfK.r=_96701_--
