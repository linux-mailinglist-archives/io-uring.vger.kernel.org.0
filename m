Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E9A524C5D
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 14:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353529AbiELMFe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 08:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243140AbiELMFc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 08:05:32 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2096.outbound.protection.outlook.com [40.107.255.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3595F245C7B;
        Thu, 12 May 2022 05:05:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJy0fMdgDTI8/d7NBweopSrKZ/yD8y9De5QYT+cHq3k5u6Bo3DuudvMSYoSo3TfITazwE+ABFeU7OZXz0sUeDRrJ0AyvsGg16TuvKx6HJKSF21sIYyMJLjU1c2Y1i5KgsdjnNn6YzBmOnAyWYUY7BIWfxeVN/NBkmldvKZX8eZPM8nf0D6pHkW9tT9MJcpVNv3K8yfK9qXxcdjyYdhvYpcRNUNjg/I0UwQfusBVgEiGBRFLyu8eebEW0/F01ldKCu0cGxEaY1/hRJwYAvu1a2funL3cCG2FqaTw4lh7aDBTvKt8gAXSDctffe6STHfiwHVoM3F02i5AiQ8EXItayOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBZa/nlhWR2bx+wC6ySsVi6vOIYyM8jFjPptoLkq+iU=;
 b=eMLWRx2fPzx1AdZhKFzDX2bA0EwCathQBzNgTBusy8gkdRrKWA75ORCLbmPof8aFb0h72GRhzPE1cWWMPepGDeIdmHxSZoHqacZJsiZ5UT3Dlw9DoSqp+KH8BczYou6K1pNJ4/g8D/WlHKMN4zXV3qdAW6YqkzgCNjGQ0Pejblnbm+o3sMmWtimzYkuOf8+C2D2zTo2bR2txCQhJcKvyr6RxrFvd61TGNLVsUOiwrwex+7MUzr/Nmr7cNYs04mZrzRvU/ZsOtowHczcLyqBxHWvnZt6WledXUG5eENTPEAF9Xi3ER/h+AjYJUNLFb3RjDQYZ094Ef3ZdH+DIpxZpTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBZa/nlhWR2bx+wC6ySsVi6vOIYyM8jFjPptoLkq+iU=;
 b=i/PxsHHNpzB/sC7H3Xg9I7Zv4s53cm/aNDJvLsU4kCH+0q25xiLYhaCYUSoFKue8mUgikDPHmUwfE4R7HxpHPF0Szhl54MPMbaH6XYKarp3pibWXwKOa9r8aXFY9QyUKdalpQ9khjCbU901b82I+kIZZTOP2k8Pc7waAK5PpaI0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 HK2PR06MB3426.apcprd06.prod.outlook.com (2603:1096:202:38::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.21; Thu, 12 May 2022 12:05:24 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Thu, 12 May 2022
 12:05:24 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] io_uring: Fix incorrect variable type in io_fixed_fd_install
Date:   Thu, 12 May 2022 20:05:11 +0800
Message-Id: <20220512120511.4306-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0302CA0021.apcprd03.prod.outlook.com
 (2603:1096:202::31) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bff757c1-13b6-401a-1e73-08da340fb1d3
X-MS-TrafficTypeDiagnostic: HK2PR06MB3426:EE_
X-Microsoft-Antispam-PRVS: <HK2PR06MB3426E264333F11B5A155C8B1ABCB9@HK2PR06MB3426.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8jxFFRt5zuxZDpRulgfSSK1dYta6Yt0FaP0jSkrroerjac2sq2mmqQ2HkKMhuE0w6h3Ol6yFpz26uNipCVOX6svnSE7A+Cyq/yKPhFtKa+Gp7BhVcgN0OCvrJFF+eDJEIxXLoWdd62X1JD17RUjOjizw3lwLSO8oi1GE0ZYwMRAOTyaVahX6I9FipBgzp3DVcf9/aeYxoXZpAd45WBbPwF3w3VN0PKncYfwof2jYnEorTnyY9pFR3Ppo9DBmCX8oeXEBEy75rKVveTo5JEOxHoifbZvSZU0uRtz5zIGo3uI6pKSaLcG8pivoFFRiYEA6M+LrsFiXvroiGMCNcvH9eivCRRYCWZ7FBosZux/GJn4+431AZWlVsj1XS4SkGTdT/c5ipcNqUxBaFKO3VAqizSaTo3bEfSp6PeLj2j58Egmo69LwFP6wiZgg/0FmYOysfEKCVI6+Q0XF9RDDEEHzIh24Z8A3NDWWvOfsFYlKXXMjddOWWLIZHVCKu1aKwiL1lV/jSWiw5JNgc8C24EqQ70wlf8fE34nsUfPuU8vyFeqhYUNrF0t9h/demdb5Xu980D4enMtEe745xkwdkyx+4pqQ0jFUfhnHlf+WT273VsZV5qbi93NgC4HJDzckToqKf3G5LMKSG1Ba0oAjUbVUjUTxDLtQBSsXN1QjSK4H6sGO9gMwjYq+LZurgZmC2kda
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(1076003)(38350700002)(36756003)(2616005)(316002)(8936002)(6506007)(38100700002)(66556008)(66476007)(110136005)(66946007)(52116002)(8676002)(4326008)(107886003)(83380400001)(2906002)(508600001)(6486002)(5660300002)(6512007)(26005)(186003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qq2Cx0LPgb4RvRNT9D6P7Vj3dnr8umWywypGmuwOO2s7T6uky/ZnZ9NQPZJb?=
 =?us-ascii?Q?8pMgXrw6A4QOe0zJZGE9ZV3tlVCZm5Ib8dKBK04GwSliV2h/sae+KtPWG84V?=
 =?us-ascii?Q?A64h3l5s+dhbSasjnXPncqiLZ9UPo5e9cL9CzwLEB2F6t22+vGmLnZYTsJqu?=
 =?us-ascii?Q?5O4dG//J/N8og1xxEOkmfSVs5untdp2uOxCsSsDazQLpYUj0KM6zXN216v2f?=
 =?us-ascii?Q?HnNPHxVT1/TlCxSxauj8kdGqNBwsdNRl0h0SH4Grhn4l2khHUa2JqWOpFSgW?=
 =?us-ascii?Q?pn2LyXR6WD6cWb6qx70XRaC3CrsX0m2u8DzW1oKBoZkZVACZd8YR6Hrk8iAg?=
 =?us-ascii?Q?cT4bidIMeFBgf7kPcN59HDcki8ruf8n4uBIUVR06+yJXdOpmOXZ9lDJjI/t2?=
 =?us-ascii?Q?P3EZLsz30qM87IF4IGKhQ8yMrpZ2B/vNJvTb+mM8HZPAj0S7pOdUDfAXA+zr?=
 =?us-ascii?Q?zARWJufd/Lo5tQNYrO9+ERefhavKi/5JSoYqhewqELyP+7N8mUMUsagLLkYx?=
 =?us-ascii?Q?E5VEo6tfhgveaAD10pytseHyAVX9/+prJZ3Fw9J/T2brrKvmoidjTzzMBQqq?=
 =?us-ascii?Q?TA4vsHoKIkMgZ3j6Y1nmNsqJqScE6ZKatkh39DpQM+IHKWme83oCsAFLqbx6?=
 =?us-ascii?Q?CqxOinPy83qI4HaK2JqDU/gP5JzAMVNXqToVkkTRv8lvwEk4LkITAapaAiT7?=
 =?us-ascii?Q?Otg61OTnxNA1zZ7kBv9DaNy5JbFf0RhYP5wBKZHik9reahedD0/Nd2mQNtgo?=
 =?us-ascii?Q?+Z3N8EpMlybegu+BEhPb8yyJicjsUu3NLXoHA2Jq9emzBbyiTF4JBsavoe6d?=
 =?us-ascii?Q?35nALcksMOw519uqTZbU2k8ACSnWiySe7K3A3Dsdda3g29LKi7XTO5YWSZyN?=
 =?us-ascii?Q?3Y+dAldeyFAmEwAZenDMHzsD9mBwlM0chM1a0dw3wvCIi5dgxYbQhL0jaKrm?=
 =?us-ascii?Q?4XJDjg5NITfQ5YiTv+BwNZKhNlib7cuAVkGKm1aJ42at57F3XkGsFXAPzHLG?=
 =?us-ascii?Q?qYv+YnwGOW4Fj7Wz0Ln4Mhs06Sjud7RCaa9F84345t/e8etKg9X+EZIU1FOo?=
 =?us-ascii?Q?17WAJQsBZeJhxZuX3vAhW2HSUxip/9rRWB+cADCn8Kb2DiG9JHbkqY1m4Mh7?=
 =?us-ascii?Q?g9ErKHB2N3BF0dLx2w+5HK0QoOrfnrHYhdGGN5KDtLMedbzjHBsJyKs8lFwq?=
 =?us-ascii?Q?qrCIZmwgTC6rgFiN1zv7hqSM3/gC1KhfPFwVNDq9bgo6NF9QrudFbB5wv3/b?=
 =?us-ascii?Q?e2n2olK+G3PDOwXW4IFtFeRAwdXA7xtAqePq9wUXqE1tlqjFgF7Ev5qDnA8V?=
 =?us-ascii?Q?sReoghs59hrtgeBRCARC2S1vUx+V9OuUu3ePieBErCzoPMPDh6MoNwsoGXrT?=
 =?us-ascii?Q?EI+O0OGsc+gpxQ7C4zPrqOVXaIydFQ5ei9/x3brx9o/giY6k6SF7ac+0sDc5?=
 =?us-ascii?Q?5X+HJL3v+rGv1A0TCpy9+G6Dt/P6zjpD9kgdJftVrCoZck4haDJ/YKkM2YSq?=
 =?us-ascii?Q?6g41Mb8NSUKdnV37P0yBc+bSl+tu+IPYBJDTAriuFsXmJFoYkXmbQ8ZhJvVS?=
 =?us-ascii?Q?kHHxpOy5X1wpd2TvHYocvAt4I/I/vTaWP7DFWm4Lj4ErcmdQDaANU5n24SyE?=
 =?us-ascii?Q?dtpbw39Vqm/Hmrk9Q3/JRc+BoQLNYo+73t3C2le+r5z8UKsAxwr2GVxt02i7?=
 =?us-ascii?Q?xbo1/ab6l4/K7yKUqzmdjDWNQie1szmqaWoyEjK5OlxKj1reVtoJKI3Hnoe+?=
 =?us-ascii?Q?/2Bu7cKZcA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bff757c1-13b6-401a-1e73-08da340fb1d3
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 12:05:24.1090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W32HJUgSBsQGuNcpobgL/7Xwn6Ai4PiLeDaUvluIYKBYdTrNqmkflZtQbzrv4xdH8S6Ajq9FngXO8M2PxOUjvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR06MB3426
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fix following coccicheck warning:
fs/io_uring.c:5352:15-24: WARNING: Unsigned expression compared with zero: file_slot < 0

'file_slot' is an unsigned variable and it can't be less than 0.
Use 'ret' instead to check the error code from io_file_bitmap_get().

And using bool to declare 'alloc_slot' makes the code better.  

Fixes: 08cf52bc6eb4 ("io_uring: allow allocated fixed files for openat/openat2")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 fs/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e8f5106434ad..92d0321bdefe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5342,17 +5342,19 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 static int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 			       struct file *file, unsigned int file_slot)
 {
-	int alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
+	bool alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	if (alloc_slot) {
 		io_ring_submit_lock(ctx, issue_flags);
-		file_slot = io_file_bitmap_get(ctx);
-		if (unlikely(file_slot < 0)) {
+		ret = io_file_bitmap_get(ctx);
+		if (unlikely(ret < 0)) {
 			io_ring_submit_unlock(ctx, issue_flags);
-			return file_slot;
+			return ret;
 		}
+
+		file_slot = ret;
 	}
 
 	ret = io_install_fixed_file(req, file, issue_flags, file_slot);
-- 
2.35.1

