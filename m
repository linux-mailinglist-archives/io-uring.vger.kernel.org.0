Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AB559BEBB
	for <lists+io-uring@lfdr.de>; Mon, 22 Aug 2022 13:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiHVLnk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Aug 2022 07:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiHVLni (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 07:43:38 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4979CE07
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 04:43:31 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220822114327epoutp013a6df254191c3fc3e68678df36b008e5~NqAwHSv070778507785epoutp016
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 11:43:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220822114327epoutp013a6df254191c3fc3e68678df36b008e5~NqAwHSv070778507785epoutp016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661168607;
        bh=mHKVy64fvQwEHttDwVFpew5lOtV9Pkp4/InewqY+Zcg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=itDUjCIa1v9zYjiIwBCJOzLzu5a4kL5w0mMTKV/iwijOXiHf2Iy3exvf0BYt4ml7r
         pWIMTSMANBNHpmKoAxVrs43sWaF1234Duk/KMNUO8nXDRdp6vjENg/2m5G1BatTr56
         uT5DaEEuxSjsDpIJHomhvb+XYKX/6OTCDTirpQCY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220822114326epcas5p4ddc3c41ea0067ffb772f3ee7dff54b5c~NqAvMHphA3098530985epcas5p4G;
        Mon, 22 Aug 2022 11:43:26 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MB9V42Cw0z4x9Pp; Mon, 22 Aug
        2022 11:43:24 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.67.18001.CDB63036; Mon, 22 Aug 2022 20:43:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220822114323epcas5p13ce13ff2e9cd58d26994ad9d49937443~NqAtETRUz1976919769epcas5p1R;
        Mon, 22 Aug 2022 11:43:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220822114323epsmtrp260703c0cfe8ed9e831498e6ac4f6973c~NqAtDedWC2395923959epsmtrp2L;
        Mon, 22 Aug 2022 11:43:23 +0000 (GMT)
X-AuditID: b6c32a4a-2c3ff70000004651-33-63036bdc26d6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2E.45.18644.BDB63036; Mon, 22 Aug 2022 20:43:23 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220822114322epsmtip1acbf72566f7156d21a19c87232dbfd66~NqAraPOe01007410074epsmtip1S;
        Mon, 22 Aug 2022 11:43:21 +0000 (GMT)
Date:   Mon, 22 Aug 2022 17:03:41 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next 2/4] io_uring: introduce fixed buffer support
 for io_uring_cmd
Message-ID: <20220822113341.GA31599@test-zns>
MIME-Version: 1.0
In-Reply-To: <3294f1e9-1946-2fbf-d5cd-fcdff9288f72@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmhu6dbOZkg45VfBZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi0mHrjFa7L2lbTF/2VN2i0OTm5kcuDx2zrrL7nH5bKnH
        plWdbB6bl9R77L7ZwObxft9VNo++LasYPT5vkgvgiMq2yUhNTEktUkjNS85PycxLt1XyDo53
        jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
        q5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnXGy7wtTwX7lijmd15gaGDfJdjFyckgI
        mEjsOXCLpYuRi0NIYDejxKummcwQzidGiUddF5ggnM+MEjeOvmWDaXlz7hxUYhejRFvHU0YI
        5xmjxMEfS1hBqlgEVCVO914GGszBwSagKXFhcilIWERAW+L19UPsIDazwF1GiS1/tEBsYYFY
        ifezWplAynkFdCU+bFEDCfMKCEqcnPmEBcTmFLCVePCxG8wWFVCWOLDtONgNEgJrOSSOXZjJ
        AnGci8TzeVuhDhWWeHV8CzuELSXx+d1eqHiyxKWZIA+A2CUSj/cchLLtJVpP9TND3JYh8ffr
        DkYIm0+i9/cTsNskBHglOtqEIMoVJe5NesoKYYtLPJyxBMr2ADq/ARo+Hxgltq9vZ5nAKDcL
        yT+zkKyAsK0kOj80sc4CWsEsIC2x/B8HhKkpsX6X/gJG1lWMkqkFxbnpqcWmBUZ5qeXwOE7O
        z93ECE6zWl47GB8++KB3iJGJg/EQowQHs5IIb/VFhmQh3pTEyqrUovz4otKc1OJDjKbA2JnI
        LCWanA9M9Hkl8YYmlgYmZmZmJpbGZoZK4rxTtBmThQTSE0tSs1NTC1KLYPqYODilGpiC/csY
        ore2ndDJ+Rmiza6pF/+8c/rBV88WfiqznnQnymRi9QSP4p+1q+IuXFRmZNueZG22xrn/kvqL
        Fl0b70nXd+g216n9uX28+NrP4Gd/rRRWrz74Z3e7htGhxuzkJYpfXsScj78x+YvPAc7OWb+6
        4nK1OFcdPLX1Z/cdNo21z25Hq1xcpvHwbMC6WXrzZCpEcsLOf6xUyBC3j3t75VetWAjT1j+h
        b95dEc7Zqt+8/tWBw29akxdsaLrW5X9XQkjkMutxjbsXp35q/PY5fod5SnuBGrNdhbijeO33
        Lcd6N584Me/D5aDipXZVMVO7Uy9sExa6fCPoTfHJF+EzlKu3ljR0pF7sclLZ+3fxA305JZbi
        jERDLeai4kQAt+YiQzwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSnO7tbOZkg/bTRhZNE/4yW8xZtY3R
        YvXdfjaLmwd2MlmsXH2UyeJd6zkWi0mHrjFa7L2lbTF/2VN2i0OTm5kcuDx2zrrL7nH5bKnH
        plWdbB6bl9R77L7ZwObxft9VNo++LasYPT5vkgvgiOKySUnNySxLLdK3S+DKeDxjBmPBR4WK
        eXs/sDYw/pPqYuTkkBAwkXhz7hxTFyMXh5DADkaJF70TWCES4hLN136wQ9jCEiv/PWeHKHrC
        KLFz2k82kASLgKrE6d7LLF2MHBxsApoSFyaXgoRFBLQlXl8/BFbPLHCXUeLmw/tMIAlhgViJ
        97NamUDqeQV0JT5sUYOY+YFR4svO38wgNbwCghInZz5hAbGZBcwk5m1+yAxSzywgLbH8HwdI
        mFPAVuLBx26wElEBZYkD244zTWAUnIWkexaS7lkI3QsYmVcxSqYWFOem5xYbFhjlpZbrFSfm
        Fpfmpesl5+duYgRHjpbWDsY9qz7oHWJk4mA8xCjBwawkwlt9kSFZiDclsbIqtSg/vqg0J7X4
        EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqY07SXs8bETz/zeJuh/cZ8QW8TC3peP
        5nMvfLLkbf00iUVfblisrF+W+czi84uLG0W29GQfFY95MsfniX+l9fPIFZNXyl1KdKtd4rfr
        bXCG+gW9z3c9jXdxvBJe7bk8LYxbes8jZ99TP94wxHtcvn9qv6flfMfX237f89F8MNtCdNfs
        7uiykLXJrXM353L8j7WSdN3i3nN/527+yzbP9hx8sU/+2ovK61ZvynmzZ/ox1d47mvxq5dKt
        S1pk03ZeLmuu0F4nr/oubqm0QNv76aefzpK+XBV7beOF2oOrdr07eFRX5IFFUz1H246s/++c
        F19habCYMNHGxEdN/5BXYNKXk8pCVxadmakuoKW759FHUyWW4oxEQy3mouJEAIEzWcoLAwAA
X-CMS-MailID: 20220822114323epcas5p13ce13ff2e9cd58d26994ad9d49937443
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_9979a_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220819104038epcas5p265c9385cfd9189d20ebfffeaa4d5efae
References: <20220819103021.240340-1-joshi.k@samsung.com>
        <CGME20220819104038epcas5p265c9385cfd9189d20ebfffeaa4d5efae@epcas5p2.samsung.com>
        <20220819103021.240340-3-joshi.k@samsung.com>
        <3294f1e9-1946-2fbf-d5cd-fcdff9288f72@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_9979a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, Aug 22, 2022 at 11:58:24AM +0100, Pavel Begunkov wrote:
>On 8/19/22 11:30, Kanchan Joshi wrote:
>>From: Anuj Gupta <anuj20.g@samsung.com>
>>
>>Add IORING_OP_URING_CMD_FIXED opcode that enables sending io_uring
>>command with previously registered buffers. User-space passes the buffer
>>index in sqe->buf_index, same as done in read/write variants that uses
>>fixed buffers.
>>
>>Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>>Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>---
>>  include/linux/io_uring.h      |  5 ++++-
>>  include/uapi/linux/io_uring.h |  1 +
>>  io_uring/opdef.c              | 10 ++++++++++
>>  io_uring/rw.c                 |  3 ++-
>>  io_uring/uring_cmd.c          | 18 +++++++++++++++++-
>>  5 files changed, 34 insertions(+), 3 deletions(-)
>>
>>diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>>index 60aba10468fc..40961d7c3827 100644
>>--- a/include/linux/io_uring.h
>>+++ b/include/linux/io_uring.h
>>@@ -5,6 +5,8 @@
>>  #include <linux/sched.h>
>>  #include <linux/xarray.h>
>>+#include<uapi/linux/io_uring.h>
>>+
>>  enum io_uring_cmd_flags {
>>  	IO_URING_F_COMPLETE_DEFER	= 1,
>>  	IO_URING_F_UNLOCKED		= 2,
>>@@ -15,6 +17,7 @@ enum io_uring_cmd_flags {
>>  	IO_URING_F_SQE128		= 4,
>>  	IO_URING_F_CQE32		= 8,
>>  	IO_URING_F_IOPOLL		= 16,
>>+	IO_URING_F_FIXEDBUFS		= 32,
>>  };
>>  struct io_uring_cmd {
>>@@ -33,7 +36,7 @@ struct io_uring_cmd {
>>  #if defined(CONFIG_IO_URING)
>>  int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>>-		struct iov_iter *iter, void *ioucmd)
>>+		struct iov_iter *iter, void *ioucmd);
>
>Please try to compile the first patch separately

Indeed, this should have been part of that patch. Thanks.

>>  void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
>>  void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
>>  			void (*task_work_cb)(struct io_uring_cmd *));
>>diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>index 1463cfecb56b..80ea35d1ed5c 100644
>>--- a/include/uapi/linux/io_uring.h
>>+++ b/include/uapi/linux/io_uring.h
>>@@ -203,6 +203,7 @@ enum io_uring_op {
>>  	IORING_OP_SOCKET,
>>  	IORING_OP_URING_CMD,
>>  	IORING_OP_SENDZC_NOTIF,
>>+	IORING_OP_URING_CMD_FIXED,
>
>I don't think it should be another opcode, is there any
>control flags we can fit it in?

using sqe->rw_flags could be another way.
But I think that may create bit of disharmony in user-space.
Current choice (IORING_OP_URING_CMD_FIXED) is along the same lines as
IORING_OP_READ/WRITE_FIXED. User-space uses new opcode, and sends the
buffer by filling sqe->buf_index. 
So must we take a different way?

>>  	/* this goes last, obviously */
>>  	IORING_OP_LAST,
>>diff --git a/io_uring/opdef.c b/io_uring/opdef.c
>>index 9a0df19306fe..7d5731b84c92 100644
>>--- a/io_uring/opdef.c
>>+++ b/io_uring/opdef.c
>>@@ -472,6 +472,16 @@ const struct io_op_def io_op_defs[] = {
>>  		.issue			= io_uring_cmd,
>>  		.prep_async		= io_uring_cmd_prep_async,
>>  	},
>>+	[IORING_OP_URING_CMD_FIXED] = {
>>+		.needs_file		= 1,
>>+		.plug			= 1,
>>+		.name			= "URING_CMD_FIXED",
>>+		.iopoll			= 1,
>>+		.async_size		= uring_cmd_pdu_size(1),
>>+		.prep			= io_uring_cmd_prep,
>>+		.issue			= io_uring_cmd,
>>+		.prep_async		= io_uring_cmd_prep_async,
>>+	},
>>  	[IORING_OP_SENDZC_NOTIF] = {
>>  		.name			= "SENDZC_NOTIF",
>>  		.needs_file		= 1,
>>diff --git a/io_uring/rw.c b/io_uring/rw.c
>>index 1a4fb8a44b9a..3c7b94bffa62 100644
>>--- a/io_uring/rw.c
>>+++ b/io_uring/rw.c
>>@@ -1005,7 +1005,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>>  		if (READ_ONCE(req->iopoll_completed))
>>  			break;
>>-		if (req->opcode == IORING_OP_URING_CMD) {
>>+		if (req->opcode == IORING_OP_URING_CMD ||
>>+				req->opcode == IORING_OP_URING_CMD_FIXED) {
>
>I don't see the changed chunk upstream

Right, it is on top of iopoll support (plus one more series mentioned in
covered letter). Here is the link - 
https://lore.kernel.org/linux-block/20220807183607.352351-1-joshi.k@samsung.com/
It would be great if you could review that.

------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_9979a_
Content-Type: text/plain; charset="utf-8"


------_GKj2UxOoZMooFpgW.UaNJF5RnPKrhbpXXK.PgNceyCDa.V5=_9979a_--
