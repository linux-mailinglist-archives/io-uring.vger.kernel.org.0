Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF396E22AF
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 13:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjDNLxl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 07:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjDNLxi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 07:53:38 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3098049F4
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 04:53:35 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230414115332epoutp01b5854b5dc740445a731381d8b85808a1~VyvpFvH7Q0703307033epoutp01D
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 11:53:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230414115332epoutp01b5854b5dc740445a731381d8b85808a1~VyvpFvH7Q0703307033epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1681473212;
        bh=W8GflBRI3jJVgiNaZcEaIxFxwCNLhjdJ8/H9I6DqsjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oTL0rc9B2dRUT+0w/7pxtifXIJleSwOIwsll4u6FWV7ac+nqlDLZw703yhyQu/7SM
         pHhrXsklsTxfuiMvZr+0i/i+iNEcWYLSU+zKwNYqSQ2LfKi4T/cvvVLA+AIV7S8YnO
         zQd6wGDHP6hABgrEq9Cyxb07wN1J3weXt656EUG8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230414115331epcas5p23aa0ebe39ff55b34b87a7fea990262bf~Vyvo3x1RB1004110041epcas5p24;
        Fri, 14 Apr 2023 11:53:31 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4PyZbG0kX6z4x9Pv; Fri, 14 Apr
        2023 11:53:30 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3D.82.09987.4BE39346; Fri, 14 Apr 2023 20:53:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230414115323epcas5p3a4b1d20d2d3381f44a8a904c90508ef4~VyvhOBGQW0739407394epcas5p3A;
        Fri, 14 Apr 2023 11:53:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230414115323epsmtrp1705e7aa450d340d878a03ceb411ef040~VyvhNdilb0968509685epsmtrp1X;
        Fri, 14 Apr 2023 11:53:23 +0000 (GMT)
X-AuditID: b6c32a4b-a67fd70000002703-e3-64393eb44516
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A1.AD.08609.3BE39346; Fri, 14 Apr 2023 20:53:23 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230414115322epsmtip2dc917b1e16f219cde748476fe0767558~VyvgZGRmD0846408464epsmtip28;
        Fri, 14 Apr 2023 11:53:22 +0000 (GMT)
Date:   Fri, 14 Apr 2023 17:22:38 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: complete request via task work in case of
 DEFER_TASKRUN
Message-ID: <20230414115238.GB5049@green5>
MIME-Version: 1.0
In-Reply-To: <20230414075313.373263-1-ming.lei@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7bCmuu4WO8sUgw+vBCxW3+1ns3jXeo7F
        4tDkZiYHZo/LZ0s93u+7yubxeZNcAHNUtk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
        pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJ
        gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGr9MLWAqeC1ZcPnGKuYFxFn8XIyeHhICJxLvNDUxd
        jFwcQgK7GSX+9p+Hcj4xSizbOZ0VwvnMKLFmZxcbTEvTw1/sEIldjBJPer6xQThPGCV+7vgH
        VsUioCrR8us/UBUHB5uApsSFyaUgYREBJYm7d1ezg9jMAlYS1xvnMIPYwgIREosWzmQEsXkF
        tCTOrJ8LZQtKnJz5hAXE5gSqv/LoNth4UQFliQPbjoOdKiFwil3i45arjBDXuUi0L17OCmEL
        S7w6voUdwpaSeNnfBmUnS1yaeY4Jwi6ReLznIJRtL9F6qp8Z4rgMiQtzVjJB2HwSvb+fMIH8
        IiHAK9HRJgRRrihxb9JTqFXiEg9nLIGyPST2tXdAA6iXUeL1mUvsExjlZiH5ZxaSFbOgYdH5
        oYl1FtAKZgFpieX/OCBMTYn1u/QXMLKuYpRMLSjOTU8tNi0wzksth0dycn7uJkZw0tPy3sH4
        6MEHvUOMTByMhxglOJiVRHirLC1ThHhTEiurUovy44tKc1KLDzGaAqNnIrOUaHI+MO3mlcQb
        mlgamJiZmZlYGpsZKonzqtueTBYSSE8sSc1OTS1ILYLpY+LglGpgSs59WfnuSd2rW8fXeP1n
        PSP+i6ck8YbkVJ5vGzm/WWz5HC+/vEViWf3FkG2R6VNi65etUwqOtjMrKnS8+dz0gIVv1t3N
        m6sm509qYJVIZ31zexWbtkyvblS03dtniv2rtIvjj185M/HwtnOCoq8nvZ76cgP7D1v3RckC
        3Conn8RIJEr6m8sx1x83mWzcFsffvXzx6qWcU9o+BR6t+KlZFNm5OCRY25bjgMTru20BB74+
        OhZ/2P3tZN8937jY1n3if3nifF7y/wkJfE+XiFknOr1wSMtLPHL42vTDEotaUp91bauT1ZLf
        9U7vxS8rB5PDL8RM3p6Oe7N7W6l041H1PLFdM6/My+WM2Ku/U+IKqxJLcUaioRZzUXEiABLw
        TxIDBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWy7bCSvO5mO8sUg4tPlC1W3+1ns3jXeo7F
        4tDkZiYHZo/LZ0s93u+7yubxeZNcAHMUl01Kak5mWWqRvl0CV0bHP8+CmfwV6w/oNjA+4+li
        5OSQEDCRaHr4i72LkYtDSGAHo8TW9tMsEAlxieZrP9ghbGGJlf+eQxU9YpT4cngCWIJFQFWi
        5dd/IJuDg01AU+LC5FKQsIiAksTdu6vBSpgFrCSuN85hBrGFBSIkFi2cyQhi8wpoSZxZP5cR
        YmYvo8Szy+tZIBKCEidnPmGBaDaTmLf5ITPIfGYBaYnl/zhAwpxAM688us0GYosKKEsc2Hac
        aQKj4Cwk3bOQdM9C6F7AyLyKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4gLW0djDu
        WfVB7xAjEwfjIUYJDmYlEd4qS8sUId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5ak
        ZqemFqQWwWSZODilGpjsbwU26u8rUD/JKvP4zu5J08T9c/SZHz898f1OC+O7VWWrdjKFSWQl
        227Mueb57ap01pLY/UdubOEy1dmypf6gdLP0gQUasz++4f0la8/js+leZM3k79n/vK6/WZFn
        Jf7X3bznAcupA7kZH7Vcp8653XR5p6FgUfCPA+2PIn7v9mO6afCy59LN2W6bGKbFJOQUqHmd
        9pX9Yvo6Q9Nv94zl2bs6jfpKz/ZkVc/kO3F3t/6NasH+E47OQbsVFj9Y3M/y4ojSo8tmYmd7
        b5a8PuS9YGPaPK25V/V995zRcrmoG7Pe8D3H/P0n8qOuT7oS+17lnZKtM8/RA6n87+YXOP5s
        4rQ7KLs/aNcVuUyue3fZlViKMxINtZiLihMBEeBbNs8CAAA=
X-CMS-MailID: 20230414115323epcas5p3a4b1d20d2d3381f44a8a904c90508ef4
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----PdhGkLDwNmEstpipWwkisvJIpjwP47YWkcBE-d9KzOb1cur7=_19c21_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230414075422epcas5p3ae5de53e643a448f19df82a7a1d5cd1c
References: <CGME20230414075422epcas5p3ae5de53e643a448f19df82a7a1d5cd1c@epcas5p3.samsung.com>
        <20230414075313.373263-1-ming.lei@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------PdhGkLDwNmEstpipWwkisvJIpjwP47YWkcBE-d9KzOb1cur7=_19c21_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Apr 14, 2023 at 03:53:13PM +0800, Ming Lei wrote:
>So far io_req_complete_post() only covers DEFER_TASKRUN by completing
>request via task work when the request is completed from IOWQ.
>
>However, uring command could be completed from any context, and if io
>uring is setup with DEFER_TASKRUN, the command is required to be
>completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
>can't be wakeup, and may hang forever.
>
>The issue can be observed on removing ublk device, but turns out it is
>one generic issue for uring command & DEFER_TASKRUN, so solve it in
>io_uring core code.

Thanks for sharing, this has been fine for nvme-passthrough side though.
We usually test with DEFER_TASKRUN option, as both fio and t/io_uring
set the option.

>Link: https://lore.kernel.org/linux-block/b3fc9991-4c53-9218-a8cc-5b4dd3952108@kernel.dk/
>Reported-by: Jens Axboe <axboe@kernel.dk>
>Cc: Kanchan Joshi <joshi.k@samsung.com>
>Signed-off-by: Ming Lei <ming.lei@redhat.com>
>---
> io_uring/io_uring.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>index 9083a8466ebf..9f6f92ed60b2 100644
>--- a/io_uring/io_uring.c
>+++ b/io_uring/io_uring.c
>@@ -1012,7 +1012,7 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>
> void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
> {
>-	if (req->ctx->task_complete && (issue_flags & IO_URING_F_IOWQ)) {
>+	if (req->ctx->task_complete && req->ctx->submitter_task != current) {
> 		req->io_task_work.func = io_req_task_complete;
> 		io_req_task_work_add(req);

In nvme-side, we always complete in task context, so this seems bit hard
to produce.
But this patch ensures that task-work is setup if it is needed, and
caller/driver did not get to set that explicitly. So looks fine to me.
FWIW, I do not see regression in nvme tests.

------PdhGkLDwNmEstpipWwkisvJIpjwP47YWkcBE-d9KzOb1cur7=_19c21_
Content-Type: text/plain; charset="utf-8"


------PdhGkLDwNmEstpipWwkisvJIpjwP47YWkcBE-d9KzOb1cur7=_19c21_--
