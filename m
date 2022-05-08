Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BF151EEA1
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbiEHPgM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbiEHPgJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:36:09 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2048.outbound.protection.outlook.com [40.92.107.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CEC10FF4
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:32:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xw3gOM8sdmDgP6KqvU1sYLTZKxngyaxrv52I1RLS+8CseGU1vfvXLroMsHLWYQuPvEI3Wa7uDkQv5EtbxhEMXPaso3dkv4kjJ+oKVomi7kB02yCHoElMSOTJKTVP+zEb5ZTy5k30XBeYk3qP3FFqMn0WGHX1cLcI9b/ID2eirh4o1lcKtoaXh5jWzSNbKE0Eu6duoqk3FnCVsAAsklKfBKiABFIliGHEdJsQ1fs91jp2FFld5Q+zNTk5CiyfrXRHcaQHr5ApL0MpGe5JDivtW7cmDxMC9qbLJOqg1Xm7SRlCYX4UgqW2SAjm7Jw0XV999AYc7zp0USgeTevVASoL6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WT245C0vvnBEu1WIcBRmsxn7sTaTPu5eMdcA1Qtj8aY=;
 b=OI4lLqwhy9bMiv1xrmA18QaFNCLf3e5RVFaVt/8dTPAMxlNpWV04J7b62Xd3T7XiDNqnYz2QCy6+7jVbwFaac9CdzTtC47luqkcKG8CwczB5Fe1Df95NR1L1f3f3CJXfMagfmMy2DSMPjdl+oW3SdwfrHA9JtVPEQzoYlYtkdDn8qP8NY4jpMU7os5m/4G1mBrzYFF3n+KT7TpRpXlLL4q7rlVAOl+znXAl0mmuXTSRK9uqJoXUw8Ix8iB5l2qK4txdPhvs+QlMIWb+dvRsAOEtAJBUZ+w9+P4mYbBMPCDvK/ZK8lo/aJaVYrCwsGB+SeRtg1NX404TaB4cxzoO1pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT245C0vvnBEu1WIcBRmsxn7sTaTPu5eMdcA1Qtj8aY=;
 b=iKCYr0DL89YjP8DWhj17t5+vJv1P2vuaScrCOVus/NeBdLZv94W9T7m1ZKqSNzq44GXFOoPIHsJrKwRcdh9tNz1kNdHkTK1LAJrR9Zbsiw3B660gGDsGrueanSnBf5BK7BVIhDW7MaqKCZ2KAcBL1d+gtO8n0lmCBDCankbPgSd0f9/fHMpzym8zd6ic0aX5U513sQrXgSnBzjwH/FHI6B8gN9ZELhCR7Jft4/Dms+MEnvJ+an1YJzHY+flGiK/BWPiig4K8KOqiD3VVTYr1R9w8wbfEF1nBWmUtu6odom7kZZ1E0jnYWCsg1SLdldaHYrs0HWEI7DhJKaECQ2h5rQ==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by TY2PR0101MB3104.apcprd01.prod.exchangelabs.com
 (2603:1096:404:e8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Sun, 8 May
 2022 15:32:16 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:32:15 +0000
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 3/4] io_uring: let fast poll support multishot
Date:   Sun,  8 May 2022 23:32:02 +0800
Message-ID: <SG2PR01MB24118EC72D64732E308F6061FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508153203.5544-1-haoxu.linux@gmail.com>
References: <20220508153203.5544-1-haoxu.linux@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [vUoMWEeXeio6M0CL3vE9+tQVyYtlsMa5]
X-ClientProxiedBy: HK2PR04CA0051.apcprd04.prod.outlook.com
 (2603:1096:202:14::19) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <20220508153203.5544-4-haoxu.linux@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e3cfc58-5062-4c43-fb71-08da3107eddb
X-MS-TrafficTypeDiagnostic: TY2PR0101MB3104:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +y27V1vB45RgDEavZinUcZEXTkp7xOK9uhfe5wiYVCvzg2k/HOZuxF4DoBZ5Hhpgo+rewFTIH1H4+3I49IWg8YpnWmAGYxXrlDxA1tZnV/f22ubIpuRApmj0M/HC6H9IsZ7UAxaMcNUo86I0sNTGwa68uRx0NWp1/u/Y2AlDRnPlFPsg6r1eiSOYm7IDUItx/uq5o85G7i8MdPnEOXgCEvJtClqvI/LHgJaev06mTkCgq4+nV3a382C3MfMHGrJl5NbNVoAy9mBqiqctqZLZgJSW0Be51X6UZ6Mc7GeFzKIhx2OXqWIdvXweakBVpcDksiJHcpm9+xPyX9ut3NDJDHXYqGyLPeulglUxIcEYTJ2yzixlYeAV33hfsak5GhxiYGX6Vw3SVmnvZNWyoqT7tE0DmwvBQT+jGlUCMIdwJwvTYK9NA6icZLw9dgMWOAx7wZwsn032GG3fpaObPi3VxGHsjwo+ILPGanL6W4yskisDJU2wMCMzDQ2GMZTaFnuqVOpWD9rkcIDuMjG8Vk02vNNCVGUIz0UbmP1LiEdCKxPrQpXzTJKtYS/Ft58uXROvzYNl85vlLuJUWaa0Ix0QCbBxxXVHppgIDUO1j6495XaqAT9BwfTHn4YV0GaEpHai
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rx6Zxu3SSH8U0UqVll2xWx1hyUs0Jd3xDCm7cGGwCCfvYyMBtNnKAs94gr/7?=
 =?us-ascii?Q?n0j8MZ3HAf5D3mNQnbUagVpqfEIrka1QoO5kEcd3rd4uAHvEsWQ4Suk2I1HB?=
 =?us-ascii?Q?0d3mTpsYQ6UzIDb8nzWShGSVhkHBd8pTtl8pT6L7DFaatwkzbMgf0lUTRAiz?=
 =?us-ascii?Q?L0Q059uExc8OvHuzjK8OVsqYP5C0oy/T1V9y09AiJv/aKpqSVz5Ped90ASUi?=
 =?us-ascii?Q?TRjO9aDDi278zIlJolo7qXN8chYZzSCgxf9j8eHGIjnzVhAiOfJQy4V8H2Dm?=
 =?us-ascii?Q?Hqz6ZXLWrY+L3GoG9gXWnxOZFaUcNET6k8BzhRXQEJ2hALQWlNRvROtLZka4?=
 =?us-ascii?Q?8VUVSp0x7BCsOJ4KukXxIBE0k/7QkbJ5JWWdnluYdwUn60sYR3/eIYS81L7v?=
 =?us-ascii?Q?TjOmB+3AY8fwp8hTKH+nLZH3wUEeotcHxwb2jhWzfScd8zDQyX9vFdPbdzQp?=
 =?us-ascii?Q?Jfy7lnrOBVem3mEofpENDvfygrto7HVxsJdFypIyQxNYnRLypoaiOgT7KV0O?=
 =?us-ascii?Q?0DQxvYPdftUeZHfNpZD2MAq44voJB0f7GpwVsFLzVC8wC6pWOYdNiHpT0HUb?=
 =?us-ascii?Q?tW829LS7teTdTw/6d4Kh6xdnF0Ih8zuiTUFVCUt1E1Kj7ppt/E1xrF7X+fll?=
 =?us-ascii?Q?QoCk195v40MZ3j/Ydmpau025M8WwABjOSugsZC95D1vpI7CLxF9/5fu/azsG?=
 =?us-ascii?Q?g0mE7DzpNqXp5jXoLhm5aVVSECa19JLHM7roYz9rRus768y77UWBT9iHJIhv?=
 =?us-ascii?Q?+y9x/81UsdOpd4nMFkJg0M1FxAvgv/BEWAGMsfceI0h6CjqS1+v3OHt1LuhE?=
 =?us-ascii?Q?v4515VPKyv5EdXcVUgXOgVRo3A/sRxPAMDIIOFpnh2KnyMT3N5TBOhJ6go0e?=
 =?us-ascii?Q?PbYHoPIc2Xa5p8pYNrAQ0RtwSJNNpA9sjkjuZGjaFxmz7Lk3XwjV5jWvw81q?=
 =?us-ascii?Q?IUUydxJsn615RtxP+0Pg7iP6aEZ9pdqLwUH4O5JOAjDHf7oIuCg4x6MiYqDk?=
 =?us-ascii?Q?l5l2Aab6TQVdsNhNRiMp8tPE/feHcMmJXUIxIgZXO1kbZgrKUaGU1lZLrq0y?=
 =?us-ascii?Q?2UYEHgOIC1lC9SnxXRjWG02pCNQzDMat2M7vKQo42J3y7cwX7/nRFpHHwqjQ?=
 =?us-ascii?Q?NBdI1LbjlWZ67Fj1WvkjqJGXheT5YgPs0fSq4rc7au64bv9eW5KPeqbHKu96?=
 =?us-ascii?Q?ehwkKqQC2tJtZViw2aCzDPC71kKi/7CGQq1DHnX/ki3kFHI1i6u3YIp1r/he?=
 =?us-ascii?Q?p54QWOSZ7s+UeN07rpjVlony5gLED2XsCUAXGtX0G2LwMYiXEOkO/OpAWsxi?=
 =?us-ascii?Q?ubzZbYurwZ7FFVorjATrVb0TI0oryITGtaV+4KW7UEdEMEigEHQCzj4Jyodp?=
 =?us-ascii?Q?RxYouEklcfQMrUazKTus6hyKfgEgYTeiVDRDavFL6PIQdQMnkVyuvzp6ukVq?=
 =?us-ascii?Q?O92u871qW6j5LPnihwmY9tDDxL7re75ci4AYH8pWKpdNgLccRprqtQ=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e3cfc58-5062-4c43-fb71-08da3107eddb
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:32:15.3526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR0101MB3104
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

