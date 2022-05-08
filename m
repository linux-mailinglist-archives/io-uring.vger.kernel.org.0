Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B683651EEB7
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiEHPly (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiEHPlx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:41:53 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2096.outbound.protection.outlook.com [40.92.53.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626036300
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:38:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IlMRgXvqpcfRb8v8x6p0IlUCis426kOsnqdOnRBEDD/VKPHsLdv4fBxTXPzxSzvrfdZPFwb26GZh0dsB5Az4mtk73+fmjGZMBEcBXod8vM74GEWZwcgDJReXC+UNO0/T4vtu0bUBVz2e5E5f4s5RehG0ENx1Brl6zN/XbARXt1tIDeT+/RChNImKKqxhSXtMwbW3n95JQQk54dh4KaIjn4EYYuxs6TCx2l49AB9rHimwsaxP5d2YtWqZ4y8TQ2d03gaLZ3NVyaGej7BbUM3CsZATz23sv5ezi8LFS4dRHtGWFbg+HiQsFaVyoQREzb1nGxuAK6CvCfNodUz7mYCRZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WT245C0vvnBEu1WIcBRmsxn7sTaTPu5eMdcA1Qtj8aY=;
 b=NUDGiSzLpI25Z2hhNGcs84/8Y15w369KHhgZcr7jNvn8oX5t3dVJsHObKUf1SUlyFAHDrksZpToZep+f3LrHLNeQqLQae7qHpJbiDLgEBrvHhWhjXlyzqC1mHWwprzST13mXsAQom1C76yIs55uiGujcEnRpUbHC/Py8KrF1Yt7qPItXS8y33BqdM1HC3bet918dNaH46A1KD7TRnwL/P1RKgVAKdGyqHAIyiIeme2VXbuQjLSzUo9rThYFRLFw1y6d8zGvTKc9Rc8V8U08pLIZG+I+kgBPIBKq1qSbDuz8xZFag4tUdSdejzUOvH4OvBjWP+4a5+gIp+vCkRHtvZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT245C0vvnBEu1WIcBRmsxn7sTaTPu5eMdcA1Qtj8aY=;
 b=vC6NKSLO/wv6TMhCut0uglnRUsg31LRbQS/FRhDAJFGHG15crNiuXB/ocLAHsILfoKLKnoIB7KqwKUH3bHmxkWh1W5b8KGVYZqhOlCM9pZy9r2mpsN6BjdPjeaPuQti6ZzbbDGp52akA7bNgV9nRYF4RDRXTkp8GQlqd6ABOEi2ayy8I80OuKcys1KRDh3MgPeepV2CWE+mGmL6caqJ0F54XZjtHSJXltRxTYwQN63s6r3S+mdfn3ArepqI/jeuWFpcEjNDz2Rbq/zcstWENd+O1HvXSRjIAW9sTC6ld9ghcUJXQHmv0xTfcNTu6FEP0IZY16/L/3vboUEM5LbtF8g==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by PSAPR01MB3910.apcprd01.prod.exchangelabs.com
 (2603:1096:301:17::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Sun, 8 May
 2022 15:37:59 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:37:59 +0000
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/4] io_uring: let fast poll support multishot
Date:   Sun,  8 May 2022 23:37:46 +0800
Message-ID: <SG2PR01MB24116B26642ADE00F8AF9B71FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508153747.6184-1-haoxu.linux@gmail.com>
References: <20220508153747.6184-1-haoxu.linux@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [L03PSQ0RYcL2FFMNtf1GUnQzRtDrdpqf]
X-ClientProxiedBy: HK2PR0302CA0005.apcprd03.prod.outlook.com
 (2603:1096:202::15) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <20220508153747.6184-4-haoxu.linux@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50b5b125-3b9e-4ade-628c-08da3108baa7
X-MS-TrafficTypeDiagnostic: PSAPR01MB3910:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjuxEuJ4B+QYMh2hD+jXM9RP6l5WjI22bOeV6M47Y++g/+kFb/AmXdkzEaGZIp/cdOqKO8CzSKwseteGbawXlDAgCbIacea60RuDQUEAhnbREsW6VyTvZBoDjNaKvKKp3+ugIxPpcTIfBiKvDLH/BPE31GJQwVgJse5gVvRslsO2EwOjn1NA3t1/sM0+Vjtd7kpXwJPvcKiPFCHxVyqAvMJ0UTm6amP4bp0QCxGmO57emgLUBpy/e1G4QogVSvVs4bxlktPkPCEA3FnpJxT3qTNCPpLjI/E6uSzJTWvFA1jzrPWUYFjDR9jWlgjhNtKcDSjS6XTQc6+g3nGNMwnZQIv6TN4LCQb7aaoRo30g3ffJ8upwl01FM5BT4WsjMI2+hyCTnJW4UkMQPqUtkPVMu4EJLtI9FK2Nw93+ImXEmrbMPqXMq5Xmn7gQFFZhp9fSQXH8BpwnKUCVpX8lwyfCIdj2gcCsku8/EVR61uRMNoQpHybvEobeNp9Uchbo4zJz8upM0v6a+J77Z+yYUaXqg6IptPfsW7JOfkjxp5hlzLWe3Apw+kwkd9MxEdv+uCjFrTvinSs5t0ppu6/6b7Vfi1qDEfgfE8lKMw2nFWdex9VX9U9mUM6b/f/EJxlWzHdN
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HQY7GTUSvUpmbKNjVW6RpKjBjPhvPMKlRgfeLMFo+gFQyD+WsIfFjiisQFEk?=
 =?us-ascii?Q?BZJM4rpCr/PkJ73gtkjGTrSV3OL0VIQSCY6RuNj3wSAc/HoWh7IZ6ZL0e546?=
 =?us-ascii?Q?Bj1lJU8VtVuKdJG9s74ZXJNursO5h16JoII+H89bolNsrL9F79es3Xq6NCC2?=
 =?us-ascii?Q?LeqbP7A6oUvGXSAEhRn9DSrb4N0mSWBxByrgdEkT6i+UVyUEXQc1RJRnygcX?=
 =?us-ascii?Q?myBsFJrXo4M31wO0REGNzWtLXT3uR/4uYL+BTde99D+MM4JCjMnGtBhQYelr?=
 =?us-ascii?Q?3ryQOndMsrTqU7jnuF7DbkB40BXcchRVNC2dkn33XSmJZ/SS9wio8hgCHe+Q?=
 =?us-ascii?Q?seSWbmBWYhCFz2ZyXQY34lSBhw/NB5RrS7GIEfy0LWNQdLYCL3JXDtZ3Fzxw?=
 =?us-ascii?Q?Hg92IB9ynxSnAdPfL5JcamZrck5ZL/vWPZNi/ySva7HYPyICqLzTrVsi/i1a?=
 =?us-ascii?Q?ZP8TbAfTGyFjtz1IlmzhT/O4ELwhJNR1h0z3JMndMIZYQPOh/431a4yfNf16?=
 =?us-ascii?Q?0TZudTxGYBW4DDAaAhhMMR8W9TbzMP3yRl2Dh1OsXPrOBNz+OhlNGaIOBCnn?=
 =?us-ascii?Q?4SdswpAALY6eoi7vSHn9CQJIdNRp3F3txdhZMlpMSUViG8jYrp1Qaim1xpP3?=
 =?us-ascii?Q?h9wk58cNdnmubvFM+27PzXJbSvlXs+MK0uJ7ujSvoq6gLJ7FjXY7EFR62o55?=
 =?us-ascii?Q?K9OpBP+70BshSfxkVzgjr8CWNmFb+CCqVZlRAnLHqPka7N7D8hjhfBv0eKHS?=
 =?us-ascii?Q?sudLSmcuwjGLsZixo9ISuqUrB2kKzK/QYd+7t1cBUvGgjnJ2bCGBTdSeo26Q?=
 =?us-ascii?Q?Y4c/vKYUzX22Hma6c3l5+grfxcgVAoBYEi792nDiebsVTYnJbZwvdHbNdZGG?=
 =?us-ascii?Q?d30Sv6+Ymgw7JmgGmM4jSTU/JMfyf5yS5ttxzNwXuruYY6GWXQOSJDC1KUHt?=
 =?us-ascii?Q?lBozWeU1Eis3r9CL3Cqa8isdcL9Dob9gJwZaXn0Frxxog6lRzAS4lU4hMYAQ?=
 =?us-ascii?Q?bATf2+S4pYMQk0fcYnCPvbpQNFE55GVIMQPnEhydSDQr4FfrnBQmewyA3b0D?=
 =?us-ascii?Q?RipHQcCSNRZpnGl7V2VddhkcN4VlLq24SQplwURpb8tkPvxu0awfXyKWPlpx?=
 =?us-ascii?Q?29InsQ5b7b4AwFcNkBl7LGyY6p1gsBGLxzA6IIjHZKQzK/0DHHOP/GPCyd1a?=
 =?us-ascii?Q?Pk3I1lTu3xyQI9MQURr8yKSh/nLQ3j2jaF9B/duyeCy/CxYfNtLwthdU+VE+?=
 =?us-ascii?Q?9aL9gyBJveo29HgDoVyhm75PyKYkLVaVjaVri2gNkc5ggBboU4pInYto2dhC?=
 =?us-ascii?Q?m3He2ec6v0orZNCmzLMV7+sD1sKauWHa20nyt2x0Klmhtckrtu7512FsUttN?=
 =?us-ascii?Q?WwP442PbCbS5PCNz6bTrUOCukRhaCJnic8pqmwPPuIVxuMa1vrdNidlWGHng?=
 =?us-ascii?Q?jmG2HjlLzeu9Ebn8v9Lpp0vxbE/YK6iV+cnM3Cssy0DWlWCFk7QxIg=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b5b125-3b9e-4ade-628c-08da3108baa7
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:37:58.9877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR01MB3910
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,FORGED_GMAIL_RCVD,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

For operations like accept, multishot is a useful feature, since we can
reduce a number of accept sqe. Let's integrate it to fast poll, it may
be good for other operations in the future.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io_uring.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c2ee184ac693..e0d12af04cd1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5955,6 +5955,7 @@ static void io_poll_remove_entries(struct io_kiocb *req)
 	rcu_read_unlock();
 }
 
+static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags);
 /*
  * All poll tw should go through this. Checks for poll events, manages
  * references, does rewait, etc.
@@ -5963,10 +5964,10 @@ static void io_poll_remove_entries(struct io_kiocb *req)
  * either spurious wakeup or multishot CQE is served. 0 when it's done with
  * the request, then the mask is stored in req->cqe.res.
  */
-static int io_poll_check_events(struct io_kiocb *req, bool locked)
+static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	int v;
+	int v, ret;
 
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (unlikely(req->task->flags & PF_EXITING))
@@ -5990,23 +5991,37 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 			req->cqe.res = vfs_poll(req->file, &pt) & req->apoll_events;
 		}
 
-		/* multishot, just fill an CQE and proceed */
-		if (req->cqe.res && !(req->apoll_events & EPOLLONESHOT)) {
-			__poll_t mask = mangle_poll(req->cqe.res & req->apoll_events);
+		if ((unlikely(!req->cqe.res)))
+			continue;
+		if (req->apoll_events & EPOLLONESHOT)
+			return 0;
+
+		/* multishot, just fill a CQE and proceed */
+		if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
+			__poll_t mask = mangle_poll(req->cqe.res &
+						    req->apoll_events);
 			bool filled;
 
 			spin_lock(&ctx->completion_lock);
-			filled = io_fill_cqe_aux(ctx, req->cqe.user_data, mask,
-						 IORING_CQE_F_MORE);
+			filled = io_fill_cqe_aux(ctx, req->cqe.user_data,
+						 mask, IORING_CQE_F_MORE);
 			io_commit_cqring(ctx);
 			spin_unlock(&ctx->completion_lock);
-			if (unlikely(!filled))
-				return -ECANCELED;
-			io_cqring_ev_posted(ctx);
-		} else if (req->cqe.res) {
-			return 0;
+			if (filled) {
+				io_cqring_ev_posted(ctx);
+				continue;
+			}
+			return -ECANCELED;
 		}
 
+		io_tw_lock(req->ctx, locked);
+		if (unlikely(req->task->flags & PF_EXITING))
+			return -EFAULT;
+		ret = io_issue_sqe(req,
+				   IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+		if (ret)
+			return ret;
+
 		/*
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
@@ -6021,7 +6036,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req, *locked);
+	ret = io_poll_check_events(req, locked);
 	if (ret > 0)
 		return;
 
@@ -6046,7 +6061,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req, *locked);
+	ret = io_poll_check_events(req, locked);
 	if (ret > 0)
 		return;
 
@@ -6286,7 +6301,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = EPOLLONESHOT | POLLERR | POLLPRI;
+	__poll_t mask = POLLERR | POLLPRI;
 	int ret;
 
 	if (!def->pollin && !def->pollout)
@@ -6295,6 +6310,8 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		return IO_APOLL_ABORTED;
 	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
 		return IO_APOLL_ABORTED;
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
+		mask |= EPOLLONESHOT;
 
 	if (def->pollin) {
 		mask |= POLLIN | POLLRDNORM;
-- 
2.25.1

