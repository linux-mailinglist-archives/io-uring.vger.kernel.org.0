Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B5351EEA9
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbiEHPlw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiEHPlv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:41:51 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2096.outbound.protection.outlook.com [40.92.53.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D0F6300
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:38:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZb/4xRXEYBMwMcTeH5FQYCPRQjDMHP6AJWdJyfoZZ/ZAcrVHRnfgBe/+5Osb8of7YyZMmplWGDGyd1UHLf4Eu7DlPvTK3Dho4UEsuWhHUfwcOwv+4QIy7gdRFgxzpbsCh8hUdodPFjp517Kl1mqZIl4fr278UYxaunpOauVOjvW+8xqdTplGqpSxz5K0SWvZkjqzgRyX8fEcm6yy6Itk+HBMzdCrzssKGlB7gH7d1zL3N8nN1Sr5HnSrnPKbQqfAg3vfZJFoK8lpvzoGWE8ZoZGkGMpoGD+M5l+hYqroH5/cb0ybxPykjrcScas4ZxFLImIdRSzXW7uGi7/eFlfqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTmfeQYmoKpOzmPx2QTFs47NY5SS0xt187uvNKmpg+c=;
 b=A2VTuk7LTulLwCv7kgRsTmHy3MetzDn3C3xl2C3Qroci9qeH8EWMSkJqebL2LlHdKiRIaOzquoT+4RmFOcCvCmB+84lxfN3ZF+fNS/ZRZexArNZNAOX2DZ3Bli6qF7JzMcWcYISPXPYZLOMPMwuOgDAg2fzC3FnB9+XYxEuEjU/+crnCaX4+5zpuCeW7Z1T2Yip6/JxS5vH2536NhCw4dbjc9Y5vYKxVlHHotGLM3QTGdFTH0+blRkTgtnu+MCFDRmW4hQ2ks3PQGTs/F1BZpdqRyTNKDDfWCv5QG8g+98bNMWMvJ+X1paoH7O1llu0kxOhUdiqgUdGGlrv+kQx8zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTmfeQYmoKpOzmPx2QTFs47NY5SS0xt187uvNKmpg+c=;
 b=DXx6ekHLlKAeeVJ0ubofw0x2WBlNAj5M48pR122VsPQiN2lgnZQy1mrK1XbxuCdGS0FUQtGNn0WM5ulW9QCmZXDKFrKNrbxvvEWt/xxWGuXxGbSSE7SrcSIXOxUgNR8qsUpjZ0bNCu8grT+K8I63NWzsvQM+2+2Ugd19aRbrC1ZuJE98dATNKgPfGpvif9ciIlmGcLPQxSr9ko5w9uXIPTjHjgn7H2K6RSgG3hW6M0rKWZ7lpvv6XhlHRhWJfqriobAXVLdP4xizYOKZCLKf0WxNtT1HTtlo0GoeSB4ukt3y7UnFzFQRaYoXQhat3TEfhYAOougui4hz3+KIrVRodg==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by PSAPR01MB3910.apcprd01.prod.exchangelabs.com
 (2603:1096:301:17::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Sun, 8 May
 2022 15:37:57 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:37:57 +0000
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
Date:   Sun,  8 May 2022 23:37:44 +0800
Message-ID: <SG2PR01MB2411F38C785EA60B6988A726FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508153747.6184-1-haoxu.linux@gmail.com>
References: <20220508153747.6184-1-haoxu.linux@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [AZ4XqeqnrgsP0B3+0QlRbKqTxffu9+Qe]
X-ClientProxiedBy: HK2PR0302CA0005.apcprd03.prod.outlook.com
 (2603:1096:202::15) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <20220508153747.6184-2-haoxu.linux@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5076f1e8-8458-43af-614f-08da3108b97d
X-MS-TrafficTypeDiagnostic: PSAPR01MB3910:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eByNJxgMKRW31TBZiD6ZObw3g/2Gbyq4OqRc1wzlJYuuDsYesxrvYDm0Q9NfIj5rUcawsD9mRpOfsRSmGmn6AvF3a2tmX21YoiYj/2h2v+l/BQVjmfXEG48CmW0XrZ94rt11bBW8JzsZMs9jKNLg0h3ZUzKc1VOr9k/3axks+6lb3lvpBRWtfr0XbUXxHErc3IA07V/neJkL4EBizpNI/dY1fCkJiQDz05GBnarDeNPtYQ6cFM46CVvONdL7pA8T9jCJTTSXtufEaTxF0WmWIl1iOJK12ZTC8hZQ3BtS+bx6Y8eozJKGY2ovmY+wK/nrDWMMLRvsFxeTd8adC885GV3vRtb6b9FP/MuqmJOE/weJSFHj6QHdIKeEZXu4HJfSf+y3Sdxjs4yALmd4vzeaXRBZq1/gaFnjefT2xFbl+1LffvrzKw9EkbKtJddsm1+WY3eHliEA+E4CI7LrdsM7wqq7Xpo5IRjqsI59YzFBcinmAXs4m/gQg4KWWjeIAnhWEUgrjJsjwWpg3Xjm4BP1ePH7JbuXuY2r54b8QG/U+uDzKXl7bXTE0NlZq/fBk2j+gNFBBLn2fcQ6GjPg7ta9deXIgOx0sWu0grWScnxDHuhT6U52SdT5gIElC2ORepcv
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tvfci9N1JMpW7R9RWLc+Es+CRzxs5muhoJ9vfa+IsXgMyKY+gQZFpRAIxZXU?=
 =?us-ascii?Q?L+KQmFY916sjrkgVsBQsgKuIg4SPtsCIdmLgGAbc1crAgcxc+rnCZYbfg9pN?=
 =?us-ascii?Q?Gtkg+O7INY2bdZE2W5ArJp4vAOOw3WESGCXrKe0DJQKdkEeIOvZX/0K1lIyn?=
 =?us-ascii?Q?h2M3bHrusUURlO1zsYOV9p1HYawxlDdFdXhEU6g/FI0YIjIFK6Eg5czA43Xu?=
 =?us-ascii?Q?vVZ0HK7lEKB+zDfiMiGkYIZqJ7sVKN46QTgE3+CH/F2UL5YVtSBO/cGN7SnR?=
 =?us-ascii?Q?Bin5LrFb1hQv9iLfKLyIBLHz+OJdr1ygZZmmqhAQp2OtkmVgZSUtHxYoqhpN?=
 =?us-ascii?Q?C1yRN5bhn5oRJBZE7qe+qw23DTYqI8PRZ6v3WA5a8R8NZyjXY2zam82HEC0N?=
 =?us-ascii?Q?0XILcQwxqjqVnH+Q4Tc0vRGLeKiroPBPyvFzz9vI+maj+7zOVv8qScT7E6VQ?=
 =?us-ascii?Q?HOMfKG8nDfwRjx+sSy+y8bE4Tr+FP2m+KXQn+pl0+0F+krw1S3zleBSvR+IE?=
 =?us-ascii?Q?pYxIsZ287sh0vW8S2OdrWSEIZ/q149nk9bhh5ojLpk8Sr5Q6sw3e6x+4xIvX?=
 =?us-ascii?Q?1RLakNaa+vbJmZQ9bXHVwFFnvI18zZrn+yZyEKFNyy+GO5b4RrOX4YImjeqQ?=
 =?us-ascii?Q?V0ySOJ24oC7jRxx4/EA+dMJk8CGq2nhq+pWeacbPK10wV1DgheD/HwBT0Ym0?=
 =?us-ascii?Q?7mcCvXS/v9MlI7lmIg7oWyR730LDaO/74nU+cPDCSqSQj1JG/KcFXb2IIETx?=
 =?us-ascii?Q?MCR/10ze4KfwKCqWYE3fh6X0Gg90ycpLeRAmCXwuStNTwW04+agFAGv2kCyz?=
 =?us-ascii?Q?AS/oEl+Rk32PaWQ0Ehso+cSYOaCKJ9q0qdap/rLigNt2cCNQOwxec/OH6YEz?=
 =?us-ascii?Q?+eeGB/AXRe3GjUSFSz4CQwgjTGni5rLJ98BWX1maTcX6ExwL4My8MAI8lPID?=
 =?us-ascii?Q?6HlbQOGt1VIdwtB+Jaipf+ucXktZslRuj2g4MU9GTFg7fnCJTk1aSzxX1uRi?=
 =?us-ascii?Q?AUYRoWyyxVnDRo8LABZgPXHRQ+wzgTWNGycOQmTg02o7uMPIvwweaY0WzhqF?=
 =?us-ascii?Q?/X34BvCuTnYtmmfPUm/KJGBuV64DfgSUFxldSbR97hO4I5jDAMAvUECNs0ak?=
 =?us-ascii?Q?lz3KUX7gfxWpNalB8/CiqQDW2ALxPrrLiTr3Vx4YjsY0xmTK04SFdnKT4bmZ?=
 =?us-ascii?Q?3B81XzCC/He0lkKRkrlyLrj/QAvFJLx8AcOc7K0JzLLEJiZhi5eRNa+/f9a4?=
 =?us-ascii?Q?MWWkK0VpRgxbpoPbfDq6/ISmdgn+CLYIaJU8R3L6d40QOR/HNdTvs01XBQ83?=
 =?us-ascii?Q?B1fhPq/y51RdxKFAXr3b/l1PYyvjP8Wvg6sZXilvg7qbAXYoZURmuylCnCiR?=
 =?us-ascii?Q?cd5X8uEIXH5D1XTId5nZoqjg3gbZ12H48JdMyriIbvZN/DcTy85UxiKPTn/U?=
 =?us-ascii?Q?5N6LInTI/nCL+5+9IBsmS6smqA/q1uu80idbhnr9WVkKYM/NwErFMQ=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5076f1e8-8458-43af-614f-08da3108b97d
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:37:56.9878
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

