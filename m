Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310F1508BF9
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 17:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380144AbiDTPYr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 11:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378070AbiDTPYq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 11:24:46 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBE445784
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 08:21:57 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220420152152epoutp03b3cdf7c895a09a2cf0f413943ee65302~npADkroeP3008130081epoutp03F
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:21:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220420152152epoutp03b3cdf7c895a09a2cf0f413943ee65302~npADkroeP3008130081epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650468112;
        bh=sQ1J1Ugutw+fdgCklRpq/vI6MADqFSiO+JUohDsJzTc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZnxvfL+uRThTd2IJdIQogkAj9PwerZkW1KHzZbK1ZtNKhE9fldV2HJX/FWHrJYiY/
         6CU5Zr/HZb2SWTc6cDACd6I87P3WgdvxLZqo7RorK6MtMAwfcp7k3eXkI+uPzypTf5
         JDnpMY+btCe2c/oMOs9ni9an2umOwYc8r7A73EiY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220420152151epcas5p4c3004dcfebe109727df79d7e74fde83c~npACyOcSS3076630766epcas5p4n;
        Wed, 20 Apr 2022 15:21:51 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Kk4CJ5rBPz4x9Pv; Wed, 20 Apr
        2022 15:21:48 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F1.E0.06423.C0520626; Thu, 21 Apr 2022 00:21:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220420152003epcas5p3991e6941773690bcb425fd9d817105c3~no_evF0xq1326913269epcas5p35;
        Wed, 20 Apr 2022 15:20:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220420152003epsmtrp13e80c5d5d749d272e83083ba7cd19263~no_et3O0o1673516735epsmtrp1Y;
        Wed, 20 Apr 2022 15:20:03 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-58-6260250ca477
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.25.03370.3A420626; Thu, 21 Apr 2022 00:20:03 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220420152001epsmtip1e481d27dba09a79c9ce2c44a0ee29165~no_ccOVZ53222932229epsmtip1y;
        Wed, 20 Apr 2022 15:20:01 +0000 (GMT)
Date:   Wed, 20 Apr 2022 20:44:54 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
Message-ID: <20220420151454.GA30119@test-zns>
MIME-Version: 1.0
In-Reply-To: <586ec702-fcaa-f12c-1752-bf262242a751@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1RTZRjHe+/dxoUDeZ1yfF0EY0YIBmzJ8KJDM9CuyUkq7SD/jAu7bhzG
        tnY3wzwHFjSPYCLayR/IgXHgKAM0fngGASVCHA6QAoGYCVSnDYMEsWWoO1LbLlT/fZ7v87zv
        8+t9MZQ/zhNgWRoDrddQahHPj2PriYiM8g9LzxAvlL9GnOsJJQpKn6NEeZ0NEPWTp3iEtb4X
        IebNtzhE0eAwQgzN9SDEme5xQHz94yai8pLDh6gx9/GIH0odgGi46+AQzu8quG+sIqdvTwPy
        q7JJH7LQMsEhR28ayea6Ih7ZUpNPdtw18Uhb9QyXLLlWB0hnc3CKX1q2TEVTClovpDWZWkWW
        Rpkg2vu+PFEujRNLoiTxxBaRUEPl0AmipOSUqN1ZancPIuFhSm10SykUw4hitsv0WqOBFqq0
        jCFBROsUal2sLpqhchijRhmtoQ1bJWLx61J3YHq2yjUyjei6akFuX9EdxARu64qBLwbxWPj3
        IxO3GPhhfLwDQGtLJcIafwA4W9LAYw0ngGN1vdyVI8X3/0I9zMfbAXQU57NB0wCWjz1zOzCM
        g4fBs/cOepCHR8Dhz42e8LW4EH7msnrvRPF5FF6pbkU8jjV4Emw6Oc7zcAAeBa/PPUJYXg37
        L9g5HvbFE6DlTqGXA/ENsMvW560U4hMYdNoaEba4JFh9+VMOy2vgbN81H5YFcObUsWXOhObW
        UR9PcRA3wBpLOCvvgCOdzxGPjOIqaL8YxMovwy8GrnpvR/EX4UmXfTlTAGyrWOFQOHXGsTye
        dfCX8zXLTMJFewXKjmeRA4cKH6ClIKTsf62V/ZeuzJtiKyxaKOCy8kvw8hLGYgT8sj3GArh1
        YD2tY3KUNCPVSTT0R/+uO1Ob0wy8DzxyTxuY/HkhuhsgGOgGEENFawMOXJBn8AMU1JGPab1W
        rjeqaaYbSN2LOo0KAjO17h+iMcglsfHi2Li4uNj4zXES0bqAQWUjxceVlIHOpmkdrV85h2C+
        AhOiGU0bQUHf01XzW5Irr+Q5j4O8hxtHC9Jqf19csh0abNQtCfKSWxU19eafQMGmnYNPX1BX
        nSgTgmeqhuNP2nwUu9pr/R882X++s+r6K7qBD189GHY2F5+x7n34OPXAkH37bwX3S01HohJ3
        WGbvdVUl/omamtptLYJvjm5bXfxtb3bnocgbA0dJbol6/dzCsav7yM0d5eccaE/4mxWyW2Mg
        6K3+hMPpQXkhjzdOITfx4KT5mW0XQ8NP7+n5hAzkx9fLgm358uFUp+sDi1BaTY4uzpx4J1Vq
        zSjtR+0Tl3KdN96LcM3v/7Vtn3J6p3Dw+6bdsrer7Ysuxmzy00+VxKjeDfEXcRgVJYlE9Qz1
        D1RFyUhpBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSnO5ilYQkgx0P9C2mH1a0aJrwl9li
        zqptjBar7/azWaxcfZTJ4l3rORaLztMXmCzOvz3MZDHp0DVGi723tC3mL3vKbrGk9TibxY0J
        Txkt1tx8ymLx+cw8Vgd+j2dXnzF67Jx1l92jecEdFo/LZ0s9Nq3qZPPYvKTeY/fNBjaPbYtf
        snr0bVnF6PF5k1wAVxSXTUpqTmZZapG+XQJXxtLVrxgLPi1lrDje9oCxgXFhXhcjJ4eEgIlE
        1/NvzF2MXBxCAjsYJU5ee8kCkRCXaL72gx3CFpZY+e85O0TRE0aJiRfuAzkcHCwCqhLTbkeC
        mGwCmhIXJpeClIsIKEj0/F7JBlLOLPCFWWLdukVsIAlhAReJjb3XwGxeAV2J/W8/MkHMXMoi
        0dH7GCohKHFy5hOwI5gFzCTmbX7IDLKAWUBaYvk/DpAwp4CtxILrzWAlogLKEge2HWeawCg4
        C0n3LCTdsxC6FzAyr2KUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI4/La0djHtWfdA7
        xMjEwXiIUYKDWUmEN3RmfJIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1ML
        UotgskwcnFINTEyPV1XMfZN095zaXXbz1vO7GC/orUjovlB0LH7TAYVOj438fR/WZu79//xb
        ZMaRmcGmXn/Dvz/IEnRr7Lp48PNUQ5dn8iz3NthcCRD5Ynff6/55n8/NzYVyMx/tOHJabP/6
        X3tebrm76UBor1HWrp4Ldv2bX28Kt9tod0O2st/3+64yuwfMX97xntu1NfBFE8sxXXu+pTZz
        7OMDjOs8vpfOOfRK/vV3y31/D/yuLrvOMF92Rq/d5GvhZ8SmZN1raZcwfSK7qNL1b53o9Qmf
        zyRdyU9+VNGZOl2I548Kq6zTNd1vr2xmHeczWdvi23QrUtXvWyq7mNTNjuy3mdqtW39uiFza
        E/VBYdvJg1Kf5euVWIozEg21mIuKEwFN3rbCLgMAAA==
X-CMS-MailID: 20220420152003epcas5p3991e6941773690bcb425fd9d817105c3
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----5nHToPFLmTBKzCIBWgrt0WwVzu6vV2V-rCSPouAMmawWObuH=_93923_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220420152003epcas5p3991e6941773690bcb425fd9d817105c3
References: <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
        <20220324063218.GC12660@lst.de> <20220325133921.GA13818@test-zns>
        <20220330130219.GB1938@lst.de>
        <CA+1E3r+Z9UyiNjmb-DzOpNrcbCO_nNFYUD5L5xJJCisx_D=wPQ@mail.gmail.com>
        <a44e38d6-54b4-0d17-c274-b7d46f60a0cf@kernel.dk>
        <CA+1E3r+CSC6jaDBXpxQUDnk8G=RuQaa=DPJ=tt9O9qydH5B9SQ@mail.gmail.com>
        <f3923d64-4f84-143b-cce2-fcf8366da0e6@kernel.dk>
        <CA+1E3rJHgEan2yiVS882XouHgKNP4Rn6G2LrXyFu-0kgyu27=Q@mail.gmail.com>
        <586ec702-fcaa-f12c-1752-bf262242a751@kernel.dk>
        <CGME20220420152003epcas5p3991e6941773690bcb425fd9d817105c3@epcas5p3.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------5nHToPFLmTBKzCIBWgrt0WwVzu6vV2V-rCSPouAMmawWObuH=_93923_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Tue, Apr 19, 2022 at 12:19:01PM -0600, Jens Axboe wrote:
>On 4/19/22 11:31 AM, Kanchan Joshi wrote:
>> Hi Jens,
>> Few thoughts below toward the next version -
>>
>> On Fri, Apr 1, 2022 at 8:14 AM Jens Axboe <axboe@kernel.dk> wrote:
>> [snip]
>>>>>> Sure, will post the code with bigger-cqe first.
>>>>>
>>>>> I can add the support, should be pretty trivial. And do the liburing
>>>>> side as well, so we have a sane base.
>>>>
>>>>  I will post the big-cqe based work today. It works with fio.
>>>>  It does not deal with liburing (which seems tricky), but hopefully it
>>>> can help us move forward anyway .
>>>
>>> Let's compare then, since I just did the support too :-)
>>
>> Major difference is generic support (rather than uring-cmd only) and
>> not touching the regular completion path. So plan is to use your patch
>> for the next version with some bits added (e.g. overflow-handling and
>> avoiding extra CQE tail increment). Hope that sounds fine.
>
>I'll sanitize my branch today or tomorrow, it has overflow and proper cq
>ring management now, just hasn't been posted yet. So it should be
>complete.

Ok, thanks.
Here is revised patch that works for me (perhaps you don't need, but worth
if it saves any cycle). Would require one change in previous (big-sqe)
patch:

 enum io_uring_cmd_flags {
        IO_URING_F_COMPLETE_DEFER       = 1,
        IO_URING_F_UNLOCKED             = 2,
+       IO_URING_F_SQE128               = 4,

Subject: [PATCH 2/7] io_uring: add support for 32-byte CQEs

Normal CQEs are 16-bytes in length, which is fine for all the commands
we support. However, in preparation for supporting passthrough IO,
provide an option for setting up a ring with 32-byte CQEs and add a
helper for completing them.

Rather than always use the slower locked path, wire up use of the
deferred completion path that normal CQEs can take. This reuses the
hash list node for the storage we need to hold the two 64-bit values
that must be passed back.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                   | 206 ++++++++++++++++++++++++++++----
 include/trace/events/io_uring.h |  18 ++-
 include/uapi/linux/io_uring.h   |  12 ++
 3 files changed, 212 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5e2b7485f380..6c1a69ae74a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -206,6 +206,7 @@ enum io_uring_cmd_flags {
        IO_URING_F_COMPLETE_DEFER       = 1,
        IO_URING_F_UNLOCKED             = 2,
        IO_URING_F_SQE128               = 4,
+       IO_URING_F_CQE32                = 8,
        /* int's last bit, sign checks are usually faster than a bit test */
        IO_URING_F_NONBLOCK             = INT_MIN,
 };
@@ -221,8 +222,8 @@ struct io_mapped_ubuf {
 struct io_ring_ctx;

 struct io_overflow_cqe {
-       struct io_uring_cqe cqe;
        struct list_head list;
+       struct io_uring_cqe cqe; /* this must be kept at end */
 };

 struct io_fixed_file {
@@ -954,7 +955,13 @@ struct io_kiocb {
        atomic_t                        poll_refs;
        struct io_task_work             io_task_work;
        /* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
-       struct hlist_node               hash_node;
+       union {
+               struct hlist_node       hash_node;
+               struct {
+                       u64             extra1;
+                       u64             extra2;
+               };
+       };
        /* internal polling, see IORING_FEAT_FAST_POLL */
        struct async_poll               *apoll;
        /* opcode allocated if it needs to store data for async defer */
@@ -1902,6 +1909,40 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
        return __io_get_cqe(ctx);
 }

+static noinline struct io_uring_cqe *__io_get_cqe32(struct io_ring_ctx *ctx)
+{
+       struct io_rings *rings = ctx->rings;
+       unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
+       unsigned int free, queued, len;
+
+       /* userspace may cheat modifying the tail, be safe and do min */
+       queued = min(__io_cqring_events(ctx), ctx->cq_entries);
+       free = ctx->cq_entries - queued;
+       /* we need a contiguous range, limit based on the current array offset */
+       len = min(free, ctx->cq_entries - off);
+       if (!len)
+               return NULL;
+
+       ctx->cached_cq_tail++;
+       /* double increment for 32 CQEs */
+       ctx->cqe_cached = &rings->cqes[off << 1];
+       ctx->cqe_sentinel = ctx->cqe_cached + (len << 1);
+       return ctx->cqe_cached;
+}
+
+static inline struct io_uring_cqe *io_get_cqe32(struct io_ring_ctx *ctx)
+{
+       struct io_uring_cqe *cqe32;
+       if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
+               ctx->cached_cq_tail++;
+               cqe32 = ctx->cqe_cached;
+       } else
+               cqe32 = __io_get_cqe32(ctx);
+       /* double increment for 32b CQE*/
+       ctx->cqe_cached += 2;
+       return cqe32;
+}
+
 static void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
        struct io_ev_fd *ev_fd;
@@ -1977,15 +2018,21 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
        posted = false;
        spin_lock(&ctx->completion_lock);
        while (!list_empty(&ctx->cq_overflow_list)) {
-               struct io_uring_cqe *cqe = io_get_cqe(ctx);
+               struct io_uring_cqe *cqe;
                struct io_overflow_cqe *ocqe;
+               /* copy more for big-cqe */
+               int cqeshift = ctx->flags & IORING_SETUP_CQE32 ? 1 : 0;

+               if (cqeshift)
+                       cqe = io_get_cqe32(ctx);
+               else
+                       cqe = io_get_cqe(ctx);
                if (!cqe && !force)
                        break;
                ocqe = list_first_entry(&ctx->cq_overflow_list,
                                        struct io_overflow_cqe, list);
                if (cqe)
-                       memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
+                       memcpy(cqe, &ocqe->cqe, sizeof(*cqe) << cqeshift);
                else
                        io_account_cq_overflow(ctx);

@@ -2074,11 +2121,18 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 }

 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-                                    s32 res, u32 cflags)
+                                    s32 res, u32 cflags, u64 extra1,
+                                    u64 extra2)
 {
        struct io_overflow_cqe *ocqe;
+       int size = sizeof(*ocqe);
+       bool cqe32 = ctx->flags & IORING_SETUP_CQE32;

-       ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
+       /* allocate more for 32b CQE */
+       if (cqe32)
+               size += sizeof(struct io_uring_cqe);
+
+       ocqe = kmalloc(size, GFP_ATOMIC | __GFP_ACCOUNT);
        if (!ocqe) {
                /*
                 * If we're in ring overflow flush mode, or in task cancel mode,
@@ -2097,6 +2151,10 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
        ocqe->cqe.user_data = user_data;
        ocqe->cqe.res = res;
        ocqe->cqe.flags = cflags;
+       if (cqe32) {
+               ocqe->cqe.b[0].extra1 = extra1;
+               ocqe->cqe.b[0].extra2 = extra2;
+       }
        list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
        return true;
 }
@@ -2118,7 +2176,35 @@ static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
                WRITE_ONCE(cqe->flags, cflags);
                return true;
        }
-       return io_cqring_event_overflow(ctx, user_data, res, cflags);
+       return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+}
+
+static inline bool __io_fill_cqe32_req_filled(struct io_ring_ctx *ctx,
+                                           struct io_kiocb *req)
+{
+       struct io_uring_cqe *cqe;
+       u64 extra1 = req->extra1;
+       u64 extra2 = req->extra2;
+
+       trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
+                               req->cqe.res, req->cqe.flags, extra1,
+                               extra2);
+
+       /*
+        * If we can't get a cq entry, userspace overflowed the
+        * submission (by quite a lot). Increment the overflow count in
+        * the ring.
+        */
+       cqe = io_get_cqe32(ctx);
+       if (likely(cqe)) {
+               memcpy(cqe, &req->cqe, sizeof(*cqe));
+               cqe->b[0].extra1 = extra1;
+               cqe->b[0].extra2 = extra2;
+               return true;
+       }
+       return io_cqring_event_overflow(ctx, req->cqe.user_data,
+                                       req->cqe.res, req->cqe.flags, extra1,
+                                       extra2);
 }

 static inline bool __io_fill_cqe_req_filled(struct io_ring_ctx *ctx,
@@ -2127,7 +2213,7 @@ static inline bool __io_fill_cqe_req_filled(struct io_ring_ctx *ctx,
        struct io_uring_cqe *cqe;

        trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
-                               req->cqe.res, req->cqe.flags);
+                               req->cqe.res, req->cqe.flags, 0, 0);

        /*
         * If we can't get a cq entry, userspace overflowed the
@@ -2140,12 +2226,13 @@ static inline bool __io_fill_cqe_req_filled(struct io_ring_ctx *ctx,
                return true;
        }
        return io_cqring_event_overflow(ctx, req->cqe.user_data,
-                                       req->cqe.res, req->cqe.flags);
+                                       req->cqe.res, req->cqe.flags, 0, 0);
 }

 static inline bool __io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
 {
-       trace_io_uring_complete(req->ctx, req, req->cqe.user_data, res, cflags);
+       trace_io_uring_complete(req->ctx, req, req->cqe.user_data, res, cflags,
+                       0, 0);
        return __io_fill_cqe(req->ctx, req->cqe.user_data, res, cflags);
 }

@@ -2159,22 +2246,52 @@ static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
                                     s32 res, u32 cflags)
 {
        ctx->cq_extra++;
-       trace_io_uring_complete(ctx, NULL, user_data, res, cflags);
+       trace_io_uring_complete(ctx, NULL, user_data, res, cflags, 0, 0);
        return __io_fill_cqe(ctx, user_data, res, cflags);
 }

-static void __io_req_complete_post(struct io_kiocb *req, s32 res,
-                                  u32 cflags)
+static void __io_fill_cqe32_req(struct io_kiocb *req, s32 res, u32 cflags,
+                               u64 extra1, u64 extra2)
 {
        struct io_ring_ctx *ctx = req->ctx;
+       struct io_uring_cqe *cqe;
+
+       if (WARN_ON_ONCE(!(ctx->flags & IORING_SETUP_CQE32)))
+               return;
+       if (req->flags & REQ_F_CQE_SKIP)
+               return;
+
+       trace_io_uring_complete(ctx, req, req->cqe.user_data, res, cflags,
+                       extra1, extra2);

-       if (!(req->flags & REQ_F_CQE_SKIP))
-               __io_fill_cqe_req(req, res, cflags);
+       /*
+        * If we can't get a cq entry, userspace overflowed the
+        * submission (by quite a lot). Increment the overflow count in
+        * the ring.
+        */
+       cqe = io_get_cqe32(ctx);
+       if (likely(cqe)) {
+               WRITE_ONCE(cqe->user_data, req->cqe.user_data);
+               WRITE_ONCE(cqe->res, res);
+               WRITE_ONCE(cqe->flags, cflags);
+               WRITE_ONCE(cqe->b[0].extra1, extra1);
+               WRITE_ONCE(cqe->b[0].extra2, extra2);
+               return;
+       }
+
+       io_cqring_event_overflow(ctx, req->cqe.user_data, res, cflags, extra1,
+                       extra2);
+}
+
+static void __io_req_complete_put(struct io_kiocb *req)
+{
        /*
         * If we're the last reference to this request, add to our locked
         * free_list cache.
         */
        if (req_ref_put_and_test(req)) {
+               struct io_ring_ctx *ctx = req->ctx;
+
                if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
                        if (req->flags & IO_DISARM_MASK)
                                io_disarm_next(req);
@@ -2197,6 +2314,33 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
        }
 }

+static void __io_req_complete_post(struct io_kiocb *req, s32 res,
+                                  u32 cflags)
+{
+       if (!(req->flags & REQ_F_CQE_SKIP))
+               __io_fill_cqe_req(req, res, cflags);
+       __io_req_complete_put(req);
+}
+
+static void io_req_complete_post32(struct io_kiocb *req, s32 res,
+                                  u32 cflags, u64 extra1, u64 extra2)
+{
+       struct io_ring_ctx *ctx = req->ctx;
+       bool posted = false;
+
+       spin_lock(&ctx->completion_lock);
+
+       if (!(req->flags & REQ_F_CQE_SKIP)) {
+               __io_fill_cqe32_req(req, res, cflags, extra1, extra2);
+               io_commit_cqring(ctx);
+               posted = true;
+       }
+       __io_req_complete_put(req);
+       spin_unlock(&ctx->completion_lock);
+       if (posted)
+               io_cqring_ev_posted(ctx);
+}
+
 static void io_req_complete_post(struct io_kiocb *req, s32 res,
                                 u32 cflags)
 {
@@ -2226,6 +2370,19 @@ static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
                io_req_complete_post(req, res, cflags);
 }

+static inline void __io_req_complete32(struct io_kiocb *req,
+                                      unsigned issue_flags, s32 res,
+                                      u32 cflags, u64 extra1, u64 extra2)
+{
+       if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
+               io_req_complete_state(req, res, cflags);
+               req->extra1 = extra1;
+               req->extra2 = extra2;
+       } else {
+               io_req_complete_post32(req, res, cflags, extra1, extra2);
+       }
+}
+
 static inline void io_req_complete(struct io_kiocb *req, s32 res)
 {
        __io_req_complete(req, 0, res, 0);
@@ -2779,8 +2936,12 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
                        struct io_kiocb *req = container_of(node, struct io_kiocb,
                                                    comp_list);

-                       if (!(req->flags & REQ_F_CQE_SKIP))
+                       if (req->flags & REQ_F_CQE_SKIP)
+                               continue;
+                       if (!(ctx->flags & IORING_SETUP_CQE32))
                                __io_fill_cqe_req_filled(ctx, req);
+                       else
+                               __io_fill_cqe32_req_filled(ctx, req);
                }

                io_commit_cqring(ctx);
@@ -9632,8 +9793,8 @@ static void *io_mem_alloc(size_t size)
        return (void *) __get_free_pages(gfp, get_order(size));
 }

-static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
-                               size_t *sq_offset)
+static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned sq_entries,
+                               unsigned cq_entries, size_t *sq_offset)
 {
        struct io_rings *rings;
        size_t off, sq_array_size;
@@ -9641,6 +9802,11 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
        off = struct_size(rings, cqes, cq_entries);
        if (off == SIZE_MAX)
                return SIZE_MAX;
+       if (ctx->flags & IORING_SETUP_CQE32) {
+               if ((off << 1) < off)
+                       return SIZE_MAX;
+               off <<= 1;
+       }

 #ifdef CONFIG_SMP
        off = ALIGN(off, SMP_CACHE_BYTES);
@@ -11297,7 +11463,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
        ctx->sq_entries = p->sq_entries;
        ctx->cq_entries = p->cq_entries;

-       size = rings_size(p->sq_entries, p->cq_entries, &sq_array_offset);
+       size = rings_size(ctx, p->sq_entries, p->cq_entries, &sq_array_offset);
        if (size == SIZE_MAX)
                return -EOVERFLOW;

@@ -11540,7 +11706,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
                        IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
                        IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
                        IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
-                       IORING_SETUP_SQE128))
+                       IORING_SETUP_SQE128 | IORING_SETUP_CQE32))
                return -EINVAL;

        return  io_uring_create(entries, &p, params);
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 8477414d6d06..2eb4f4e47de4 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -318,13 +318,16 @@ TRACE_EVENT(io_uring_fail_link,
  * @user_data:         user data associated with the request
  * @res:               result of the request
  * @cflags:            completion flags
+ * @extra1:            extra 64-bit data for CQE32
+ * @extra2:            extra 64-bit data for CQE32
  *
  */
 TRACE_EVENT(io_uring_complete,

-       TP_PROTO(void *ctx, void *req, u64 user_data, int res, unsigned cflags),
+       TP_PROTO(void *ctx, void *req, u64 user_data, int res, unsigned cflags,
+                u64 extra1, u64 extra2),

-       TP_ARGS(ctx, req, user_data, res, cflags),
+       TP_ARGS(ctx, req, user_data, res, cflags, extra1, extra2),

        TP_STRUCT__entry (
                __field(  void *,       ctx             )
@@ -332,6 +335,8 @@ TRACE_EVENT(io_uring_complete,
                __field(  u64,          user_data       )
                __field(  int,          res             )
                __field(  unsigned,     cflags          )
+               __field(  u64,          extra1          )
+               __field(  u64,          extra2          )
        ),

        TP_fast_assign(
@@ -340,12 +345,17 @@ TRACE_EVENT(io_uring_complete,
                __entry->user_data      = user_data;
                __entry->res            = res;
                __entry->cflags         = cflags;
+               __entry->extra1         = extra1;
+               __entry->extra2         = extra2;
        ),

-       TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags 0x%x",
+       TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags 0x%x "
+                 "extra1 %llu extra2 %llu ",
                __entry->ctx, __entry->req,
                __entry->user_data,
-               __entry->res, __entry->cflags)
+               __entry->res, __entry->cflags,
+               (unsigned long long) __entry->extra1,
+               (unsigned long long) __entry->extra2)
 );

 /**
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 88a5c67d6666..1fe0ad3668d1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -111,6 +111,7 @@ enum {
 #define IORING_SETUP_R_DISABLED        (1U << 6)       /* start with ring disabled */
 #define IORING_SETUP_SUBMIT_ALL        (1U << 7)       /* continue submit on error */
 #define IORING_SETUP_SQE128    (1U << 8)       /* SQEs are 128b */
+#define IORING_SETUP_CQE32     (1U << 9)       /* CQEs are 32b */

 enum {
        IORING_OP_NOP,
@@ -200,6 +201,11 @@ enum {
 #define IORING_POLL_UPDATE_EVENTS      (1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA   (1U << 2)

+struct io_uring_cqe_extra {
+       __u64   extra1;
+       __u64   extra2;
+};
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
@@ -207,6 +213,12 @@ struct io_uring_cqe {
        __u64   user_data;      /* sqe->data submission passed back */
        __s32   res;            /* result code for this event */
        __u32   flags;
+
+       /*
+        * If the ring is initialized with IORING_SETUP_CQE32, then this field
+        * contains 16-bytes of padding, doubling the size of the CQE.
+        */
+       struct io_uring_cqe_extra       b[0];
 };



>> We have things working on top of your current branch
>> "io_uring-big-sqe". Since SQE now has 8 bytes of free space (post
>> xattr merge) and CQE infra is different (post cqe-caching in ctx) -
>> things needed to be done a bit differently. But all this is now tested
>> better with liburing support/util (plan is to post that too).
>
>Just still grab the 16 bytes, we don't care about addr3 for passthrough.
>Should be no changes required there.
I was thinking of uring-cmd in general, but then also it does not seem
to collide with xattr. Got your point.
Measure was removing 8b "result" field from passthru-cmd, since 32b CQE
makes that part useless, and we are adding new opcode in nvme
anyway. Maybe we should still reduce passthu-cmd to 64b (rather than 72),
not very sure.

------5nHToPFLmTBKzCIBWgrt0WwVzu6vV2V-rCSPouAMmawWObuH=_93923_
Content-Type: text/plain; charset="utf-8"


------5nHToPFLmTBKzCIBWgrt0WwVzu6vV2V-rCSPouAMmawWObuH=_93923_--
