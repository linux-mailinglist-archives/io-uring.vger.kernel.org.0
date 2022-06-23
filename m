Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF3C55885D
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 21:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiFWTJa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 15:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiFWTJT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 15:09:19 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783ED120852
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 11:14:29 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NHuphV013407
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 11:14:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=YK7eG3j7NHy9n91qx9y5OPEq/Sc1sG64s/rjfArr8jQ=;
 b=JzMhRhJtiMvYgqi594MJOXivAVIlgaGWjaSMWepCRKvxuhi0qnGD4+22CMtAmQzUzOWo
 d83y/Gsf78FgdP0iA2of+K9UdZ80CFRqWxTotw62n/G7W7uv+Mw+cwat/oeX8cO8E1aC
 IWVjDAji9ai9uhfQq80hQ+DNX6URS8epmvQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gvqxxtbmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 11:14:16 -0700
Received: from twshared5640.09.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 23 Jun 2022 11:14:15 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 9CEDF10C5DC6A; Thu, 23 Jun 2022 10:52:00 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>, <willy@infradead.org>
Subject: [RESEND PATCH v9 12/14] io_uring: Add tracepoint for short writes
Date:   Thu, 23 Jun 2022 10:51:55 -0700
Message-ID: <20220623175157.1715274-13-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220623175157.1715274-1-shr@fb.com>
References: <20220623175157.1715274-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: A5bX9RBl4DCth_T0y7Jl3smTqWjl3lvs
X-Proofpoint-GUID: A5bX9RBl4DCth_T0y7Jl3smTqWjl3lvs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_07,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the io_uring_short_write tracepoint to io_uring. A short write
is issued if not all pages that are required for a write are in the page
cache and the async buffered writes have to return EAGAIN.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c                   |  3 +++
 include/trace/events/io_uring.h | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 22a0bb8c5fe5..510c09192832 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4597,6 +4597,9 @@ static int io_write(struct io_kiocb *req, unsigned =
int issue_flags)
 		if (ret2 !=3D req->cqe.res && ret2 >=3D 0 && need_complete_io(req)) {
 			struct io_async_rw *rw;
=20
+			trace_io_uring_short_write(req->ctx, kiocb->ki_pos - ret2,
+						req->cqe.res, ret2);
+
 			/* This is a partial write. The file pos has already been
 			 * updated, setup the async struct to complete the request
 			 * in the worker. Also update bytes_done to account for
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_ur=
ing.h
index 66fcc5a1a5b1..25df513660cc 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -600,6 +600,31 @@ TRACE_EVENT(io_uring_cqe_overflow,
 		  __entry->cflags, __entry->ocqe)
 );
=20
+TRACE_EVENT(io_uring_short_write,
+
+	TP_PROTO(void *ctx, u64 fpos, u64 wanted, u64 got),
+
+	TP_ARGS(ctx, fpos, wanted, got),
+
+	TP_STRUCT__entry(
+		__field(void *,	ctx)
+		__field(u64,	fpos)
+		__field(u64,	wanted)
+		__field(u64,	got)
+	),
+
+	TP_fast_assign(
+		__entry->ctx	=3D ctx;
+		__entry->fpos	=3D fpos;
+		__entry->wanted	=3D wanted;
+		__entry->got	=3D got;
+	),
+
+	TP_printk("ring %p, fpos %lld, wanted %lld, got %lld",
+			  __entry->ctx, __entry->fpos,
+			  __entry->wanted, __entry->got)
+);
+
 #endif /* _TRACE_IO_URING_H */
=20
 /* This part must be outside protection */
--=20
2.30.2

