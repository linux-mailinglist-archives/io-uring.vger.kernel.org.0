Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C5336F70F
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 10:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhD3I0N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 04:26:13 -0400
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:15169
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229529AbhD3I0N (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 30 Apr 2021 04:26:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUc6Tbw0P/k2/wQX7I5emDhf7O74Adv5kVwakZIDzhB/0FJxEEbsY8OifxH8D7rkWfF/rGDhDKfEa+XzITpGEo7/Rs+3QXsXqgQilpfhn6wuPviQN9AMJeCbFQCuAGKUMPp8r2GggGQqa7NpyoJSMKYHT5gcNvdPH8pPr6Wg2nUnOrH5hhUBjp6I/jlvaZM5Uizk22KLTsNIJwNWDtYql2Xb74Dqm7SiC5c3S06SSP6g/dhHRNE9QjRIlISeGGbO5JRl3b7avWn0SqtwGba3GqwayeFJT3Bm6BIJ3T+KHagx08+ZuVtr3MN/paU8SHjzP0TPUm5A7XDoy9aJbcUKLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxB/2TaNf8MiuacnW3hymkmMranrOPUQk7KhSutBo9A=;
 b=aeqqv6A0oPWbDLQzzzXRp3f1hqK4fxWG6OfaAJ4m7fHdBjpCpdHpzN24eRftImfRbxwOl5Cm8/yjUPf0wP4FXLT5oMZtFl1hHQbQyZ98jFTrHns5VFQSAiCZv1M2Xu5KWp8jyQN7msi9DJ6HO/YILuK35VSUEr/ZCJyYvqs1mcc7VP6bmnufd7QPue60KtLKdQ97bFeAAoC/Uf+VwKeTQ8f4uPMOp8ZDAlkMG/SNcfNgFmMX1niR1O/j8qBeUxFL8tSM7EvISCg3gUcabS+Lk2aWnm9lMxb4d5z5b2mxVc4CgY+Kqyp2BEhCShacRc2g0B6keC7QEEEGsqxCVXenRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxB/2TaNf8MiuacnW3hymkmMranrOPUQk7KhSutBo9A=;
 b=Ey+GKguZnCCKrY8uFOBn4HsssRIiADdxFxrVVeJyznvtg7ifNwlLYrXvzeizAxNnWZYmqPJhS9CTfiCKTW5knMOKfRB4dMsbgWGB5hb0pbtKjUhcS3aAOslrOZs0jMeQySVVaT1Q3FuTWywJETzeNWCfsriX/k8jtOvTelOM488=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB4202.namprd11.prod.outlook.com (2603:10b6:5:1df::16)
 by DM6PR11MB4625.namprd11.prod.outlook.com (2603:10b6:5:2a8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.27; Fri, 30 Apr
 2021 08:25:23 +0000
Received: from DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::60c5:cd78:8edd:d274]) by DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::60c5:cd78:8edd:d274%5]) with mapi id 15.20.4065.034; Fri, 30 Apr 2021
 08:25:23 +0000
From:   qiang.zhang@windriver.com
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: Fix memory leak in io_sqe_buffers_register()
Date:   Fri, 30 Apr 2021 16:25:15 +0800
Message-Id: <20210430082515.13886-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HKAPR03CA0033.apcprd03.prod.outlook.com
 (2603:1096:203:c9::20) To DM6PR11MB4202.namprd11.prod.outlook.com
 (2603:10b6:5:1df::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-qzhang2-d1.wrs.com (60.247.85.82) by HKAPR03CA0033.apcprd03.prod.outlook.com (2603:1096:203:c9::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 08:25:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb22f640-0cc2-4e8a-ccd4-08d90bb17fcd
X-MS-TrafficTypeDiagnostic: DM6PR11MB4625:
X-Microsoft-Antispam-PRVS: <DM6PR11MB4625FF78E5D5CB2D2D446E20FF5E9@DM6PR11MB4625.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LWCHDncT7h+xRAk5Z/JOhQkiRxpr0iwSyCd4L/9PgRmHzQt6hGewPNQzWNIXPUEltAgkHVU3UQVrw7H95e9dFQwHAv1covoluD1WLMdoU2QP0fu2LyKx0tNWdfu7uK21OSphJI+tjhBv4wH8QjyxR5in9vfTr2qKfHclMcHww9qUkUwuwS/EBjvdGfZL8HW9jYLGWUJQ0p08uqPBGw8jtWsjF7qjbZ0tUwg3oa2rVeLmzq0BdUt49gf0At9C2OlM+Q8cKHfArTxCZIMV8oEuMHjn/oq1yToGpIDQ8aY910N7bhK5M6ZOFWu3bubkMc0LnuUrge6W1DIq8PId6KMGbXm03i3nrBJRJbWIgD1HdpJKQvgj9puXWua987C21ynPdjWJoxSwceTknNdFti1Fbbm8Lg+1TtAqh+JVlE7HzHhqqspdtZUDVi18UsvOJvveIKdx33iCWyV5iwL1SJKF8HBz+CCcp5V4Beet60JPIUJesL7CROnfl/NNdc1ZBrzxExMaBAQD+i5szDcWIeyu3vkpgQcAr6rdzXXhnBEocEsWilbNJryrCRWlkFEXf0JS/PU5XTG6nawGXSG7tEWxWmN8iAFSuHPeKM9bAeG3MuTc7IZFh6YTesM/mbEEU32I0fRik4eNThN30K7WCRt1Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4202.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39850400004)(66556008)(316002)(66476007)(66946007)(83380400001)(26005)(38100700002)(4326008)(6512007)(36756003)(9686003)(186003)(2906002)(6506007)(8936002)(956004)(8676002)(478600001)(6666004)(52116002)(1076003)(38350700002)(6486002)(2616005)(86362001)(16526019)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fUQVxxI7fROsNhc+Pt8Tu1x33H8VA3tBEutcdd4QswuC0WQ6tdI26d83rHDK?=
 =?us-ascii?Q?4YHOqn2eDXTN3ZJoR9C3P/4XelLtrK6ijLVJaoNFRmtsbyEqXn7ajvk+Uxfn?=
 =?us-ascii?Q?fZfoiJobo4DtJky8HKvaSHYtthMoE3Jtm1NeDjLVrxTOXshVmealeMDcjF5G?=
 =?us-ascii?Q?lDkv9p3eQ7uVHWq4dRa0rPHsrTYGxsiJFnU/ThgH94x5pn6XUFmd8TlaOpGJ?=
 =?us-ascii?Q?a2dytJVpEegPl9Jb9fm5Uffbg9AWIdcX4jZPfCfaI9RSHaNAvGkkZdyjlr2l?=
 =?us-ascii?Q?nm+qe0WNWOADj3v7B53YJ18wJBtyLkaeJWJRbt9qUQknDuq1UcihH6lWLXTO?=
 =?us-ascii?Q?YM5l+8jGxvXX8x3j+1z07EImmqu2zYwFohtiWGgi00bPhEtxdROcYvlVQ7jM?=
 =?us-ascii?Q?0wfeZnEVqaUoF9ywBRDSjuuAlf8cTw0kGH2M0kFM3BagTSQeWlGb9rJ3Gwov?=
 =?us-ascii?Q?59dsa9wv1jOk4iIpKl5olZdcd3njZC/gtoYHC+SiDOcS27lyOLZjMMc0SxYj?=
 =?us-ascii?Q?4AhTFXs5vTxwwk5D5l4IMRCh3ERug2M/gifad01eFXbiB6cB2ry8ucuBifD5?=
 =?us-ascii?Q?KjZq1V/RO+ly+JszBtoUM6N+HueotiV//RiFgaAgFMebLEAggCoeSdYN3DtT?=
 =?us-ascii?Q?3jv5dVBu0gvOX3gEiG8m9GfzeM6FrnzdZhv8jgHfNz3DWcKIhLmkTQ28fkEi?=
 =?us-ascii?Q?SHeLfetRClHQCAdM9g1m7n3PW5ybpPdmKtBEglWafjarGy+mUIjTwxC/KoaA?=
 =?us-ascii?Q?kAWfxpDZ/01A9/8HOFHnuh66DcK6EVQdAautwqYXX+L4zJ9ZCD/Bi7hIMrG2?=
 =?us-ascii?Q?tO4R/kRol7QrRo0wTrOXwk5Jz69ZdNpr1R+7Ds6K4oxBeNqHVk/0qPFbu76B?=
 =?us-ascii?Q?9xHCT3QVHk+gXeOSB/Zh5DNfCiWUG88Zq/1T0xmzR7ozj87AoaRGMgWEfvzZ?=
 =?us-ascii?Q?5kxm3T5Ec4mhZe/cGyrWmV+CXdnURl0/nBXhuGoswi76Q4E0PtB3WtZH+XhJ?=
 =?us-ascii?Q?kMdjxHYQQmY4wvxgeztjuG66v5beykixojKvN0IRwEqIrx8as/J/TWwd0f5a?=
 =?us-ascii?Q?hyV3h2c+V68rV1kJ/b/xz4FpFOYZ+lDJfwW9mZ8F5jaKfWetZUD4gqOf9wAd?=
 =?us-ascii?Q?wEZompk9aEbReIkL7xlBZvrrFTzBQ657rF/79licZ0Q8UJdMuCZvXU2tR/+v?=
 =?us-ascii?Q?qZaH5mksOu1Szva3cpDCswkIi6LxKklpv6f8G7pJbQhpks6gejpGt+keIBQa?=
 =?us-ascii?Q?MyjFZo5NwsLnEeJnb98y+oYtKL8rqNEle9b9pads9jS/bEQa2qxrTSrQ4rnV?=
 =?us-ascii?Q?yv/7WJ/umYGrKErkopZqDq54?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb22f640-0cc2-4e8a-ccd4-08d90bb17fcd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4202.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 08:25:23.2805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fb91v0Atg+Ud8/0datLKbhhqUVJTzSdIfv/x0ZcMjHeuMbSBnZDhrPzVaJ1ehjrRh19o7St3+n7K1dNx6LXTt36+Ayfq/KXwLHQEFQxs4CQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4625
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

unreferenced object 0xffff8881123bf0a0 (size 32):
comm "syz-executor557", pid 8384, jiffies 4294946143 (age 12.360s)
backtrace:
[<ffffffff81469b71>] kmalloc_node include/linux/slab.h:579 [inline]
[<ffffffff81469b71>] kvmalloc_node+0x61/0xf0 mm/util.c:587
[<ffffffff815f0b3f>] kvmalloc include/linux/mm.h:795 [inline]
[<ffffffff815f0b3f>] kvmalloc_array include/linux/mm.h:813 [inline]
[<ffffffff815f0b3f>] kvcalloc include/linux/mm.h:818 [inline]
[<ffffffff815f0b3f>] io_rsrc_data_alloc+0x4f/0xc0 fs/io_uring.c:7164
[<ffffffff815f26d8>] io_sqe_buffers_register+0x98/0x3d0 fs/io_uring.c:8383
[<ffffffff815f84a7>] __io_uring_register+0xf67/0x18c0 fs/io_uring.c:9986
[<ffffffff81609222>] __do_sys_io_uring_register fs/io_uring.c:10091 [inline]
[<ffffffff81609222>] __se_sys_io_uring_register fs/io_uring.c:10071 [inline]
[<ffffffff81609222>] __x64_sys_io_uring_register+0x112/0x230 fs/io_uring.c:10071
[<ffffffff842f616a>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
[<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Fix data->tags memory leak, through io_rsrc_data_free() to release
data memory space.

Reported-by: syzbot+0f32d05d8b6cd8d7ea3e@syzkaller.appspotmail.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a880edb90d0c..7a2e83bc005d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8140,7 +8140,7 @@ static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 	for (i = 0; i < ctx->nr_user_bufs; i++)
 		io_buffer_unmap(ctx, &ctx->user_bufs[i]);
 	kfree(ctx->user_bufs);
-	kfree(ctx->buf_data);
+	io_rsrc_data_free(ctx->buf_data);
 	ctx->user_bufs = NULL;
 	ctx->buf_data = NULL;
 	ctx->nr_user_bufs = 0;
@@ -8400,7 +8400,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -ENOMEM;
 	ret = io_buffers_map_alloc(ctx, nr_args);
 	if (ret) {
-		kfree(data);
+		io_rsrc_data_free(data);
 		return ret;
 	}
 
-- 
2.17.1

