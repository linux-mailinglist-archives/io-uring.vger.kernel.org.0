Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17725700461
	for <lists+io-uring@lfdr.de>; Fri, 12 May 2023 11:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240355AbjELJ5t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 May 2023 05:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240437AbjELJ5q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 May 2023 05:57:46 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2118.outbound.protection.outlook.com [40.107.117.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE4C11B5C;
        Fri, 12 May 2023 02:57:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Da1Lko5EPEB15r52Fe50epFmUAXEskN659nQHGUzoY35pSDj1V1gUY8Ol+A0NjbPWX4qm+o9Owt1NFkCz6Dh4dAB8CoSvXJu2x8J/ND360eiNSXa6BPiQtOyWgsTM14UWxnjZntTiYoewraBkuTTOKQSmMpOyrO2S06hSd537AddGuzegPtfzgjbJsd5LKyFsyi432RV/DVvbL+TtwC1dx7XEB56JyRr1877DmEuAWAfie8WhFbi+CUUWEtE/6VCfqzMJ3Q/HVpbkMgKicrYcfK2uMXJ1jp+66EdMN0BvfDJUcRfbQ3S5G8LIdpjJsih5SR+jrL4fyFelD+oPtNIlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjqaZWQNqUI3NK7oT6OELl4xZ+DxbY03YqI8Y1xfZmE=;
 b=bUzaVETKnuRxVb/SNy1SEi5S9EtxGY6BTEdo01HWYKNOkRU17915qTyoLDlYpMNeN4LnoiRI6zZipcQofAMINDasa/HCWl1jeHxJzgijyeMktQGKtYbc2ggim0/IG8rGjz4i5BAbPS5bwjkctD/9EHHi6rNifSwZP6tqMnPL0s/3xb4S8ikwEe4L5QWoWS7mN5oqt6Dib+ky1b2CmFImZgk7BtcaP5B/ZtrTz/EMnMbh9FXjb9rgfZi/eLYx8t95znI6+BxyFDMQM6Lpdzq+2bcfVFdN7v8cxTgL2TQNDlGAshTXy64GcOVAxVwwraG3IYU/Sa5EFo4d36QiCjC//Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjqaZWQNqUI3NK7oT6OELl4xZ+DxbY03YqI8Y1xfZmE=;
 b=SFmhXp2rYo+XETOUyRqbMPaV+9yMDPhWEtzQa0CJSAzDMBdW89Lhp/oM2wjp6emSLX3aAfjORSUCq1IquDlGZQl9db6eLfiucSD6Du6nFkmPvQ1brrIXp3QaScK6kmMTc64SednrJka/faXEA3LG85uZbZ4BTaxjMVJERvyE9jfJFCTbGPNjMJ8kkOS8q5K5mQ1bXL84P5YFILkdSdjhfuvgBlPCbCTsN8Z+TdwiykICKBiBDaeWDJ+T70NmFJ7of6wSFqKmwaIJa6fcuo9wOeYQaSqlLiDiu2ftIs1JhkuBk0T3Kqr1t2Ee+qyhtOaR48ODhcXCCsuOlwr+tnWDnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB2169.apcprd06.prod.outlook.com (2603:1096:4:7::21) by
 TY0PR06MB5401.apcprd06.prod.outlook.com (2603:1096:400:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Fri, 12 May
 2023 09:57:06 +0000
Received: from SG2PR06MB2169.apcprd06.prod.outlook.com
 ([fe80::51d5:9a57:618e:bb10]) by SG2PR06MB2169.apcprd06.prod.outlook.com
 ([fe80::51d5:9a57:618e:bb10%3]) with mapi id 15.20.6387.021; Fri, 12 May 2023
 09:57:06 +0000
From:   luhongfei <luhongfei@vivo.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org (open list:IO_URING),
        linux-kernel@vger.kernel.org (open list)
Cc:     opensource.kernel@vivo.com, luhongfei <luhongfei@vivo.com>
Subject: [PATCH] Subject: io_uring: Fix bug in io_fallback_req_func that can cause deadlock
Date:   Fri, 12 May 2023 17:56:55 +0800
Message-Id: <20230512095655.8968-1-luhongfei@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0113.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::10) To SG2PR06MB2169.apcprd06.prod.outlook.com
 (2603:1096:4:7::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB2169:EE_|TY0PR06MB5401:EE_
X-MS-Office365-Filtering-Correlation-Id: b135958a-020b-46f0-411f-08db52cf3e55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EmgyCZ8UhFiX8/TGo4KWBuPh9TeSkOb9l7g0ubOML9S9NVVCcINhb1OL3DiH/Q+JN2do8qRcFLPszHbgxfSwe48Pco1lEomcZcxaDAuTBqJ3gOWyrk2hhZLliypNY3TK909ELMDLDSDrzHqfZ4aFKC82gG8/etRYXUllkH7Hs/foD5YVK2Y4DM8XSa7ZTAEvwrAR0jU/xxV2GHiq6IH0gv5RgHSrfkiQeq3/LaAT0B4uKrbdWLQly74OY569C1V+1IFSSMpGQ+ao/jyK2qcd4PPlJiSBP/Ee9kM2K5+fmh8s8RERSy6u5fXvusBB0w3P3PGn4B94Zbzwoyc5r+kmQ/f8+AuyQQgGsApgKiEs73CyNhpuL5g/Wv2nCMl/+y1HzI06JBI+KO45npn/GDqk2cOwcZunAb2L+eNK6W6fIBMGrlV6Am0l4T9jbNGvQIFwFb9s1XiZzJ+4zi0ASd+ZOGxZYy0EkSjqnzGnQ40qCJCapOMdJyGDhmOmse1Bqs6chzMANIFs4C3qJ4/aQ0cXXhBUPnt+O2dIF3ZiJMk58PYge1mb2+9nT5TW4WEyJB2APv0q+hZoSBb6vM2oQhctHLZjU3R2k3bC0wFTxqIdp8rogPAW9CIFIrG6IlVMG6FU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB2169.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199021)(52116002)(66946007)(4326008)(66476007)(66556008)(6486002)(478600001)(316002)(110136005)(86362001)(36756003)(83380400001)(107886003)(26005)(2616005)(186003)(6512007)(1076003)(6506007)(8936002)(8676002)(5660300002)(2906002)(4744005)(41300700001)(6666004)(38350700002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ai3Nh0EXto8523NGiSs8cqfo/r1cTwH4wfkWqhLZjIKI0NeaHvQoOL57y/rn?=
 =?us-ascii?Q?CqDU3lp5Ve698X43G1bFZmJVNWHgVqXZt0MuHT55YJd7ULVLzqBf7oxxxblz?=
 =?us-ascii?Q?fN63unycYqk7lr+Oqvxxwm7lErQoig31+vuy7diPiPM2QmJYhZpXWlpQ1GQz?=
 =?us-ascii?Q?8tEK3R3fw8ArSfeYKvR9KLyuSx2C2xowHBXp09VQA/UHXAZB4Kari15oL7kQ?=
 =?us-ascii?Q?FD1xzomULS80u0hGFzHWmBECmmOJRfmBJ48sCr+vx/W7rBiqd608DCYFtQAB?=
 =?us-ascii?Q?TmvHuRjIaRgUvIc9kNllcv2uND2UyMjIzuYFwaeZSlCgd++a4g59aPiU69d9?=
 =?us-ascii?Q?q47eqJdUmNRznq7RWb5R9ztnrNcJZZIo13pZ39p60qek5/LchSzbaxlqPYCJ?=
 =?us-ascii?Q?4PfbC3w/Vzn5/BNgqlfyIRi48cPOnqgCv8EmSJP/IpHBa4N4ZtjhTeGEQxro?=
 =?us-ascii?Q?pvmuVZQ+qtR5XpGCO4aJfio7qMl42VVaidCLEa7XfVWn+cFsC58oZ0cypY4H?=
 =?us-ascii?Q?3IU+1wXgm46mytfbkc55OMVUuATZDtahBlJHmRx1lVuyDgOgWkNHd+FLLs7Y?=
 =?us-ascii?Q?Wdtqlaxs8bpRPbJN5EuvmKRRgbLvnNyKgSzaTS3vQ+NZFyI4Rr563z6KvGjp?=
 =?us-ascii?Q?M/lPyyDEKYYEWsU1+BBXANQB0jHWQTyIVuGR3b0dJB9GKXm/gtzNMx0pJBIg?=
 =?us-ascii?Q?IMnjU+/9c9rbjZtxGPk/O+udZpeUyGrRnnaIouLR16pzE9FrEKjALNh0wrxo?=
 =?us-ascii?Q?mtNEmVmtZF0oye9AONuqOhyrQs82PTKB+CIL+IeCNQo69WPO2+VdwGUGsUEh?=
 =?us-ascii?Q?EtoAuOBttBPq1DWwMbtKirzCTkzlrzRvKGcLVmd1Ole6771dKKHSj2L10o4T?=
 =?us-ascii?Q?iNVKj4sewGSGgRvlwj3O8/1xksvVs1FIAkq2Vzkkc6g/TW8gReJumX2MSQIY?=
 =?us-ascii?Q?aUaHLWPTdgXuCsZsHaw4F/7QMd9d8BRCcKY/uff29GhsC56D2gYq77YDerMy?=
 =?us-ascii?Q?SS+3hj3BHOSihztSJfnx5jDniRj6cV8BEx46Kz4h8vZGAMQWJh0hmgts2H3U?=
 =?us-ascii?Q?NNNY5KZaGt9+BEIM94W8WIgAKIR1OMr0Djnabir4BnHarTT+vnHF22JY3qN6?=
 =?us-ascii?Q?YgliKi/IWVcJ0blhRokoTHqHilYaaIz/0/215Fi7dLkiBvuMsQyRwCo7VZLc?=
 =?us-ascii?Q?r7fz0+MECB8VHhV/lPS5midcxN/HVoSlBvFqN8kW5OzO63DUHIHsiJnKS7Rm?=
 =?us-ascii?Q?jzrWHlRcjy1Me4QUeqPxLX6Ih/jPqxp9JvFbcc5suJFaaU8YnmSK/TPCPPyg?=
 =?us-ascii?Q?Lxixzf+5oh1pOytB1FVPyjKKAsGv9Im5+ne6lwsw0LVJNfukVvIUDcYOCMAp?=
 =?us-ascii?Q?tQXp6n9UWHGpNGfdX4yY1DnPYfGFZuNdUFYcjKGMvRl78mXl+LB+3+mUHyAh?=
 =?us-ascii?Q?plSfyhfwvLadFsUeAvxpLinubBODZvTdu76Tuz9hb4UgdlvH0VveXqU6q7BX?=
 =?us-ascii?Q?r0x9TPE+Cl2GjP4FcQqZyw6iatwtpEZ7Eq5chOVzewhvBxjbxn3bJ/e0A8EY?=
 =?us-ascii?Q?nTNSK9idDmaWVWr4E1GA8I4//sqAJ3hN8YVDOmAg?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b135958a-020b-46f0-411f-08db52cf3e55
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB2169.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 09:57:06.3108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2yFhpaDRpNE9ANuk+r7LJAsj+d9sweWsUhtrADbxI8yJV2NpyolobHV45aeBRCFrI67fQt5y46D8mimnIq0Rmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5401
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There was a bug in io_fallback_req_func that can cause deadlocks
because uring_lock was not released when return.
This patch releases the uring_lock before return.

Signed-off-by: luhongfei <luhongfei@vivo.com>
---
 io_uring/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 io_uring/io_uring.c

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bca7a79efda..1af793c7b3da
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -252,8 +252,10 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
 		req->io_task_work.func(req, &ts);
-	if (WARN_ON_ONCE(!ts.locked))
+	if (WARN_ON_ONCE(!ts.locked)) {
+		mutex_unlock(&ctx->uring_lock);
 		return;
+	}
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 }
-- 
2.39.0

