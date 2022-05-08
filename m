Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807F851EEA7
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbiEHPgK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbiEHPgG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:36:06 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2041.outbound.protection.outlook.com [40.92.107.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83DAE03F
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:32:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hao3ZDMxvd8EfcT4ky4ACnET0A9B19IkPYwBk4LZpjUi/eV/uAvsIptFNb7w6I7zvwPY8F7PI2PzqSoleyDyVdKkJQZsTbalaQVrrM+PhfIGyALBvS/wLNl2l+ouykZ+Jpdrg5/0l8ecNu7XHiVWfZhFxH0SQWQc8NFGaaaVPSGFpuqj6LWfNn76nJr8pGjQbvnzTym9u8LcSqLllZQvvWzFZl4mUGfiq7Vv60F9sw1wPxP+FjupwZDthjVRGJLFs3XqD1bpEIZELE7BxrTgP5zCoUuz8v9Fxb3xDwccBAd+SuosyTAoqaJfUDQkyPEg/EsQhX+wBD6A2AJZYAAMQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTmfeQYmoKpOzmPx2QTFs47NY5SS0xt187uvNKmpg+c=;
 b=jkROYGSFVf9yCnITAyVE19DoaDtL/gRQ07s/dztkf49C9fE4+f7dhiDqz7hwBF76o5h+nEcB3+onRYoTD6zv0gCS6PCupMV8BqC6YY9TyY093veaG+btz/UEahLPMaZLZT5VeSO7OCH5T/lCmIRlOQRFD9LlXN5cJ5yUzXx/hDCxSC8jAFpE5hVItynZ7ebXf418GPGTz0HL90gUPiQQEvpTdg1HMLmLVs3DQyf3qSUOiZOoObwNM+HAs7v1dLwjk9Fv7lhxMCGrEjQc1WaEGyHjZW5ym1HgkL2Wu/IjVRL5y4eomyq50QP1OKSRRoU7Zv/84hFQjv/RiNdAdRKD7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTmfeQYmoKpOzmPx2QTFs47NY5SS0xt187uvNKmpg+c=;
 b=Q+2YYv+KmKRe3kcJJ+SMF9/5LX03n+/yHW4BoEr1Uca6luH5C9QC2rKIZwZeFh7FZklNMbAE654cB/HciYvR79n3BMzA/HtHeIMbRJynIdORsK2YckwQcWXnh/qeSLDXHg6MHM99Tj4bth7EU6TK44pfbrA6X7TgyFU7A2KV2+eRElR7axNb5tK5Jpn9GFiRSIwTIB8IrDjcDVFNWI8J0TO93hLFeLb0Bc5jag9CljIL2M2M+9uZ/wiHDp9DqhceIoN9o0uu/B/sZLpDEqXD5eJoxYRijT7U3oOHxZPVuPgo8dnKkBsCxUpXB26GzCUkXlMP0OKF+cy3wW8OI2k6eQ==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by TY0PR0101MB4360.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:32:13 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:32:13 +0000
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
Date:   Sun,  8 May 2022 23:32:00 +0800
Message-ID: <SG2PR01MB2411E6DCC5D110860FECF22FFFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508153203.5544-1-haoxu.linux@gmail.com>
References: <20220508153203.5544-1-haoxu.linux@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [02CXRufXrB3I78rr5jNx02/qBsVlxYjT]
X-ClientProxiedBy: HK2PR04CA0051.apcprd04.prod.outlook.com
 (2603:1096:202:14::19) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <20220508153203.5544-2-haoxu.linux@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d4d9347-c5f7-4364-1f4b-08da3107ecd8
X-MS-TrafficTypeDiagnostic: TY0PR0101MB4360:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1/cnooKN//V2m1HHo0+Gz7CUsxPM+vJchg35jkUx7Tnl4qtSRgSmCzvNERYKzUJ6LbOG9q2SVWNpu0xXYN2e7tsjkW6g6ET/zanHw2GV+hSpVS8uK+fioJ9gMkbehMhqj8MqCONZe9RO/IR8DkNH/T8go9gNc7GNWkVWRkIXnA1T1JzU+uG3xb2Ct0YOUpdUOTJnFhIce4NCVFpBzkCAiFDKJuKKlvWSPOq5GYfdi/TfLfJQDOrhorpocVYcjigKRmiPlgA6d6HHGd0pY9SnqsU2ZiNAG41jv4cvmkIZFkseMMHlp/yWo6mfSqksuZqvhdMn3e1IRxA3yU8pDTlGr6hZ5kJrSsKJ3zKpeGxcdc9EsjjaxVxUhw/K7H66a4bArcpvrlomn/ZgnOIMTOZlUXR5rZiGMNDEvmmT768nVKjlF7jFVyPFp5aMizLdk10XyreBynMXrWRf/QgSFLYeeRQ0nSK4t6EEur+76ujFvEgdFnGVx1N0we0gQIGb6eJlgWeFs8DIJ/mc9v9FN3N/YLr3grv7En9Yl6mFJ/OR9e6VDG6wtCJqLsUvJJ5v8SoYJixqAzHwHn2xzmUfFd+d46uG1p8wFQ5uiIAYvpN9ukNSH3CWZPaydP9PzlBQxlLv
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7s8PtEL4oh10TOu4MeoZhxrafLEWowR1g7pAdYRKtmTEFAYbp/wNfWC0x0eJ?=
 =?us-ascii?Q?mS+1uOcroU5hIJ87BdENU301Xv9FpR/FavI2PxX9FcamuxR+6e2pcAwLDWW8?=
 =?us-ascii?Q?VQ4kaZu4EG04GdHIdVSqo6ijh5kBjWAqtMJVYBP1vrIS7VwGAF2m81ikXfOt?=
 =?us-ascii?Q?sxaM7R+goTgMfIU24Dvy5QLs4FtFxH90Zjqve9rKLEupCOFE+gFB6uugs+hY?=
 =?us-ascii?Q?fUX1RbFMneyrKkqApcMHLiE0NoxRZgAbjDjYYcivWq7fFNsFQSR12p13dgsj?=
 =?us-ascii?Q?+rgwPLzAj2VgOPYMO3CotB1V3nGHL+At6/Kur2EChYWftMyU8MRSPsTf1Cea?=
 =?us-ascii?Q?yXB+kNe/uHLuPuNStm3RDhX75j+stOM2hfDjmDE25NVU2971nuAqab8RcAyI?=
 =?us-ascii?Q?cEXPVlIc2T+Sf1UhiB2+WnKaGxwnr/O0mH+Mp6vdjMs+2MHurgsE6qFpj0UP?=
 =?us-ascii?Q?5rKzHDw2LqXp+ZIG82yBQkuWA7zdeTsIS3/BaGcOpVvWl1RkdwILmIm6UsMN?=
 =?us-ascii?Q?Pc8WAHlt1WROdwyDDqwnY1PyQ3xpmu7JZPcxPiEAHHp3N7uT614Qk98pNjnt?=
 =?us-ascii?Q?hilRD8OxFvcZGEOxcwDH0kRQ+lfw9Ytzs7y80iHiZViSakb9mrUWdd9pm6Bf?=
 =?us-ascii?Q?7+svdatzceYiCLk7cBzQO1ULYaKAvqBHu2BrLRp03zLh5F8VOIT1+2MLHPho?=
 =?us-ascii?Q?EhH64GWi0L0gEbfLGhxLuAq+lgPljnlZipvuHP1/Y8Dj3tlgNlvl1//nPCu5?=
 =?us-ascii?Q?F1LT9iQP0fGMDW8ubsxp4Y1R52tTDSkiR/gIbLzDD766TI1uwhv37RgVe7LL?=
 =?us-ascii?Q?KtQQcfYvqgcFyY8a4mROwPrqIlpVxcAj7yko3DLhzdwU40K+iOnjqmyjG7Ls?=
 =?us-ascii?Q?w4wIk4E8Y59OoKhx4ADNioXTl/tQIaPt15Ha7kp6ozofxyl793bUKFSrHjO4?=
 =?us-ascii?Q?c/pTNxYPfv3xiabk1xOwCYRuU1Vly6AN9j2aI+ckSHW9UlvWS1kf1pRQMTzS?=
 =?us-ascii?Q?E/ZfiIwHRXpSGG4UQLn6IO2KnL4EulOGLjFAyuCVrdw9s6qDc/Cyio0MAwTz?=
 =?us-ascii?Q?TVK3Qf4TyLcIp3offWCqx3rNJ5s3HBGevRqWV8jf/E8bQj3sdeGbJ7hNCfC5?=
 =?us-ascii?Q?+q756vxvPmF15/szbp10YAWG0vMVHgwReM/daeqGbMrZh0bhMmpFeydjA0cm?=
 =?us-ascii?Q?DsbmfoNxyOIubEGWayhAQuRdmv6D74Wofx/tfFha0EReAOH9AunNoupr7TR2?=
 =?us-ascii?Q?DkqU9GGXlz8oJN52MXHsXi8m2509Zdx1jdJtfqSLbIz6Wu+DGJPylLXlQyum?=
 =?us-ascii?Q?7h/Wgcm68CKskcMuccQY9XohLCSwsBJpW622BkBv1vn8LAcBdfekTgH8rXMO?=
 =?us-ascii?Q?WYW26blybvtUnsfy5RgD33lxkKPy2vJVjamLNQFpDn7a+Oz7dywnaFpMIWJS?=
 =?us-ascii?Q?gITtrDJQiIi3ZhxzT8hK3LCQ+HuByW2ByBC6yux9hDOjDXLbdro1FA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4d9347-c5f7-4364-1f4b-08da3107ecd8
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:32:13.7590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR0101MB4360
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,FORGED_GMAIL_RCVD,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
support multishot.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/uapi/linux/io_uring.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 06621a278cb6..7c3d70d12428 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -223,6 +223,11 @@ enum {
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 
+/*
+ * accept flags stored in sqe->ioprio
+ */
+#define IORING_ACCEPT_MULTISHOT	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.25.1

