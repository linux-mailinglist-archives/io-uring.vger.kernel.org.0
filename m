Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499525AB8A1
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 20:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiIBS4E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 14:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiIBS4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 14:56:03 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60EBED029
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 11:56:00 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220902185555epoutp0137efdaad0766b4dd9c5f07eb6ca4dd07~RIAfgVSgR2935229352epoutp015
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 18:55:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220902185555epoutp0137efdaad0766b4dd9c5f07eb6ca4dd07~RIAfgVSgR2935229352epoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662144955;
        bh=4eLYZnr6xFbgq4GxcRAahDAAw7otRIbJYrXiu6bjolg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T74VFScqDbiBa9+/m8IuJIPLjTKV5Xqvvg2FI5elMlDM4gyKJq0s92NLMJWVFKBq3
         pcSFVR0+7pOlXo+Ygjcf5bAh0JDUJFsgOpLw4orViM8wVhmZsgCc9jEiT1ZitBvV9d
         2mvY/QZknX57p+GoyL+f6MNK37xfdcw+jEczou6c=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220902185555epcas5p2d39ee95cd1fcaa04403b566617f6460e~RIAfCzqap3127031270epcas5p2v;
        Fri,  2 Sep 2022 18:55:55 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MK6Z108YLz4x9Pp; Fri,  2 Sep
        2022 18:55:53 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A4.91.59633.8B152136; Sat,  3 Sep 2022 03:55:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220902185552epcas5p1a3bd8094fb643fb03adbfbc72ddbe10d~RIAcnaua00646106461epcas5p1r;
        Fri,  2 Sep 2022 18:55:52 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220902185552epsmtrp2debe40835de617a7d42661c2c1a19de9~RIAcmuU1z3263532635epsmtrp2o;
        Fri,  2 Sep 2022 18:55:52 +0000 (GMT)
X-AuditID: b6c32a49-dfdff7000000e8f1-ca-631251b830c9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.50.14392.8B152136; Sat,  3 Sep 2022 03:55:52 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220902185551epsmtip15d28ee76bdbbdbc6e42b1cb33a6e5164~RIAbY5F9z3257232572epsmtip1n;
        Fri,  2 Sep 2022 18:55:51 +0000 (GMT)
Date:   Sat, 3 Sep 2022 00:16:08 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v3 0/4] fixed-buffer for uring-cmd/passthrough
Message-ID: <20220902184608.GA6902@test-zns>
MIME-Version: 1.0
In-Reply-To: <2b4a935c-a6b1-6e42-ceca-35a8f09d8f46@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmlu6OQKFkg01tFhZzVm1jtFh9t5/N
        4uaBnUwWK1cfZbJ413qOxWLSoWuMFntvaVvMX/aU3YHDY+esu+wel8+Wemxa1cnmsXlJvcfu
        mw1sHn1bVjF6fN4kF8AelW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
        aqvk4hOg65aZA3SSkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQv
        XS8vtcTK0MDAyBSoMCE7o6l9P1vBArmKT/dEGhi3SHQxcnBICJhILD2f18XIxSEksJtR4tjJ
        BewQzidGiXsbLzFDON8YJTZsXg3kcIJ1/OlewAKR2MsosfjLajYI5xmjxNyjl8GqWARUJA7u
        us4IsoNNQFPiwuRSkLCIgIJEz++VbCA2s8AqRokpv6RBbGEBb4mmvgdgrbwCOhI77h+HsgUl
        Ts58wgIyhlPAVmLhr0qQsKiAssSBbceZQNZKCEzkkJjVsw3qOBeJ30c6mCBsYYlXx7ewQ9hS
        Ep/f7WWDsJMlLs08B1VTIvF4z0Eo216i9VQ/M8RtGRJbn05ghbD5JHp/P2GCBBevREebEES5
        osS9SU9ZIWxxiYczlkDZHhJH+mexwENx0rbLLBMY5WYheWcWkhUQtpVE54cmIJsDyJaWWP6P
        A8LUlFi/S38BI+sqRsnUguLc9NRi0wLDvNRyeAwn5+duYgQnUS3PHYx3H3zQO8TIxMF4iFGC
        g1lJhHfqYYFkId6UxMqq1KL8+KLSnNTiQ4ymwNiZyCwlmpwPTON5JfGGJpYGJmZmZiaWxmaG
        SuK8U7QZk4UE0hNLUrNTUwtSi2D6mDg4pRqYksvOzGtT76wKOz7PP1SwylafdfnjCWmPgi1/
        X9vwN4U75Gr6K+/LS/oibtpbSgTzHzSpM3LJMYgI+NV87/TN89PDVtfneLjFHDZxlI29PMWs
        5E+vzOUHBYqaxnu9TnvF7mVd7F2r//axmVMZ4yPHg49++HffcN7nKZ8c87La6qrDijTeGq0r
        SyQlZJg+sjRdOyT2OmCJMe8X9mzfR1orG8LaPT63Xjzrbrpo8t2l/16GbWpbelW2pjvddYmH
        S4vV5lWL/wQvnTnxekRj5awv3+8LP2UJfPjy//0KjR1eW5u1OT9Nsf5xKmph3pm3UWn7r6Xk
        zwyJNlY6u1tSwCj+32K926cTs9XzDJkel5gqsRRnJBpqMRcVJwIA1JxDQisEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSnO6OQKFkg9PPpC3mrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8WkQ9cYLfbe0raYv+wpuwOHx85Zd9k9Lp8t9di0qpPNY/OSeo/d
        NxvYPPq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStjSe9floJL0hU3Ls5mbGBsEOti5OSQEDCR
        +NO9gKWLkYtDSGA3o8T9j/eZIBLiEs3XfrBD2MISK/89Z4coesIosXtbCyNIgkVAReLgrutA
        NgcHm4CmxIXJpSBhEQEFiZ7fK9lAbGaBVYwSU35Jg9jCAt4STX0PmEFsXgEdiR33jzNDzPzE
        KHHp+ylWiISgxMmZT1ggms0k5m1+yAwyn1lAWmL5Pw4Qk1PAVmLhr0qQClEBZYkD244zTWAU
        nIWkeRaS5lkIzQsYmVcxSqYWFOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgRHhpbmDsbtqz7o
        HWJk4mA8xCjBwawkwjv1sECyEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NT
        C1KLYLJMHJxSDUysbf/r+KZE7VU23/MtXfNx9FZVXuHAL15vtteZK/3NeSWS9u7yvNTM0Pv8
        1yIevY4VbmLlauPSln/ptfbMi+JvBzaKTNz3z/JU8/WzjIXTjzhdN1R8YrZgdnNxf3jk0ZL/
        RwKnS+27dq2P81my7rXXPjJyG95dKRORv58/109kytzn976nPZ2cL1M442CjvMGzZTqLjEJ/
        iN250qeu4nKXZ+r8souVfxmrZ9YvdW/jm/zFjv/3zN+dJgc5jDNjI7i2rz4s3zn7eFy0Ztap
        Ki+th0qf3+j4qPU9M1tuX9QyYc/C21ffL3M22T15JW+Te+OcBdMPpk3m0D41RVwltNrsTARr
        nHOknfwmEdOy3Y5KLMUZiYZazEXFiQBSUX0O+wIAAA==
X-CMS-MailID: 20220902185552epcas5p1a3bd8094fb643fb03adbfbc72ddbe10d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----pcQIgMQ_HVXS4qWPbWHvSbnTt3jWAgM.sCJInyI3qCVu2Rgf=_445cb_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf
References: <CGME20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf@epcas5p1.samsung.com>
        <20220902151657.10766-1-joshi.k@samsung.com>
        <f1e8a7fa-a1f8-c60a-c365-b2164421f98d@kernel.dk>
        <2b4a935c-a6b1-6e42-ceca-35a8f09d8f46@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------pcQIgMQ_HVXS4qWPbWHvSbnTt3jWAgM.sCJInyI3qCVu2Rgf=_445cb_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Sep 02, 2022 at 10:32:16AM -0600, Jens Axboe wrote:
>On 9/2/22 10:06 AM, Jens Axboe wrote:
>> On 9/2/22 9:16 AM, Kanchan Joshi wrote:
>>> Hi,
>>>
>>> Currently uring-cmd lacks the ability to leverage the pre-registered
>>> buffers. This series adds the support in uring-cmd, and plumbs
>>> nvme passthrough to work with it.
>>>
>>> Using registered-buffers showed peak-perf hike from 1.85M to 2.17M IOPS
>>> in my setup.
>>>
>>> Without fixedbufs
>>> *****************
>>> # taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
>>> submitter=0, tid=5256, file=/dev/ng0n1, node=-1
>>> polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
>>> Engine=io_uring, sq_ring=128, cq_ring=128
>>> IOPS=1.85M, BW=904MiB/s, IOS/call=32/31
>>> IOPS=1.85M, BW=903MiB/s, IOS/call=32/32
>>> IOPS=1.85M, BW=902MiB/s, IOS/call=32/32
>>> ^CExiting on signal
>>> Maximum IOPS=1.85M
>>
>> With the poll support queued up, I ran this one as well. tldr is:
>>
>> bdev (non pt)	122M IOPS
>> irq driven	51-52M IOPS
>> polled		71M IOPS
>> polled+fixed	78M IOPS

except first one, rest three entries are for passthru? somehow I didn't
see that big of a gap. I will try to align my setup in coming days.

>> Looking at profiles, it looks like the bio is still being allocated
>> and freed and not dipping into the alloc cache, which is using a
>> substantial amount of CPU. I'll poke a bit and see what's going on...
>
>It's using the fs_bio_set, and that doesn't have the PERCPU alloc cache
>enabled. With the below, we then do:

Thanks for the find.

>polled+fixed	82M
>
>I suspect the remainder is due to the lack of batching on the request
>freeing side, at least some of it. Haven't really looked deeper yet.
>
>One issue I saw - try and use passthrough polling without having any
>poll queues defined and it'll stall just spinning on completions. You
>need to ensure that these are processed as well - look at how the
>non-passthrough io_uring poll path handles it.

Had tested this earlier, and it used to run fine. And it does not now.
I see that io are getting completed, irq-completion is arriving in nvme
and it is triggering task-work based completion (by calling
io_uring_cmd_complete_in_task). But task-work never got called and
therefore no completion happened.

io_uring_cmd_complete_in_task -> io_req_task_work_add -> __io_req_task_work_add

Seems task work did not get added. Something about newly added
IORING_SETUP_DEFER_TASKRUN changes the scenario.

static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
{
        struct io_uring_task *tctx = req->task->io_uring;
        struct io_ring_ctx *ctx = req->ctx;
        struct llist_node *node;

        if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
                io_req_local_work_add(req);
                return;
        }
	....

To confirm, I commented that in t/io_uring and it runs fine.
Please see if that changes anything for you? I will try to find the
actual fix tomorow.

diff --git a/t/io_uring.c b/t/io_uring.c
index d893b7b2..ac5f60e0 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -460,7 +460,6 @@ static int io_uring_setup(unsigned entries, struct io_uring_params *p)

        p->flags |= IORING_SETUP_COOP_TASKRUN;
        p->flags |= IORING_SETUP_SINGLE_ISSUER;
-       p->flags |= IORING_SETUP_DEFER_TASKRUN;
 retry:
        ret = syscall(__NR_io_uring_setup, entries, p);
        if (!ret)



------pcQIgMQ_HVXS4qWPbWHvSbnTt3jWAgM.sCJInyI3qCVu2Rgf=_445cb_
Content-Type: text/plain; charset="utf-8"


------pcQIgMQ_HVXS4qWPbWHvSbnTt3jWAgM.sCJInyI3qCVu2Rgf=_445cb_--
