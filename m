Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCDE26E7628
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 11:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbjDSJWy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 05:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjDSJWx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 05:22:53 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2112.outbound.protection.outlook.com [40.107.215.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A57C18D;
        Wed, 19 Apr 2023 02:22:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9Pradu3+X/Aa53uM1eaPqiaUjQlhmAKvMtHuh48pZCXN1HwOP70ytKzWBnCXLOYprS9lIFlox6wN5NE4s9c10LnKDnZVqandzn0aTux+h8yo+f7GCrA5OF9cFXnGf9Ygwf8m0ZMYphM+PZtQQIKbCzsAEP+ZvM9GDAOW9XGtg/U8fA1sUjMd15qtAfBlckOqRJsakmqP9W9egUqmO5P2GWdIYTqdKoBIaSt5gLLNZlc3wrlKarSO21/V6LgXrqn9gCu2ixQKm+Wch//8evQ2KHQH+pQQStRKw67tpAhlHQnLCAWhDGBui1O1atxGcptxsalMiIuTdvfREEqmpvR0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vdjv4EWl42FmRA9yJfE28Bn5L6yVk//9C529Wmcjdq4=;
 b=fzZ71MLgUjjNXpk1MwWsPHVbT3HJHZj7fP0cGo74tzsN9h4a0jlRM88zUcF86rkiJy2V70N6HPn0mSuB7bAc4cz74j9kgEX+x0ijiKt3kopBLAWBNPiywWEi46DiOkNJjXw7I+LlrPyxsfnKs6rtYWy1QVcCYQkQosvm1gEQZR9yBuRDgXxL/ItnVDVp1iNtDiZpDJAfNCwF1uqpLcr0wA6IOlos8ufJv/DmiZuaocXxSGuBb+Nl1zpzDxRizpbGWwhBSFPA1AfZ2zzTBNoiZ5KISiwxPrujN6/jlWkM2Ia9mx6Gl/bK3Xf53FZlG5Z3mFqpGuia+UgCChYX6Bg7aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vdjv4EWl42FmRA9yJfE28Bn5L6yVk//9C529Wmcjdq4=;
 b=Y9mgT5OOgHa75QS7E0jDrHi9hk8K4hoik4hjeKoDc0c7A9IAup69foOQA3mVEck7MpPPJB4IBYwOiH2i6OorbbMF8uAevj4+7UkZ79hxI88SoDW3l5uoEguMf8AhJNlrES4kkWFxpCsPdzJGB00qK1mlGNAKx6IoFkfOvLP3KFWcsicsrzfAQpJ0ok3/2VJN/KUUxP6IYRmz8W8IdLktGoFtYLZv+8+8DgYg3F4QL58AjbDkS3WoYrWimUdzkNqvo5sFluSv8Boil8wWtzNNvqh1R+y524ywUGioBH6ptxSqrCwYRgp7BdE7zz6oRGU/tiBh/+MaCKpJmvF7nM3EyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB2169.apcprd06.prod.outlook.com (2603:1096:4:7::21) by
 KL1PR0601MB4257.apcprd06.prod.outlook.com (2603:1096:820:78::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 09:22:44 +0000
Received: from SG2PR06MB2169.apcprd06.prod.outlook.com
 ([fe80::51d5:9a57:618e:bb10]) by SG2PR06MB2169.apcprd06.prod.outlook.com
 ([fe80::51d5:9a57:618e:bb10%3]) with mapi id 15.20.6298.045; Wed, 19 Apr 2023
 09:22:44 +0000
From:   luhongfei <luhongfei@vivo.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org (open list:IO_URING),
        linux-kernel@vger.kernel.org (open list)
Cc:     opensource.kernel@vivo.com, luhongfei <luhongfei@vivo.com>
Subject: [PATCH] io_uring: Optimization of buffered random write
Date:   Wed, 19 Apr 2023 17:22:33 +0800
Message-Id: <20230419092233.56338-1-luhongfei@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0232.apcprd06.prod.outlook.com
 (2603:1096:4:ac::16) To SG2PR06MB2169.apcprd06.prod.outlook.com
 (2603:1096:4:7::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB2169:EE_|KL1PR0601MB4257:EE_
X-MS-Office365-Filtering-Correlation-Id: 0de00e67-dd38-43ec-0f69-08db40b7a130
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FcsT/mtxTkcF2XcY3AgihEwGCR0rOWzYTfB2e9l48vzq6I1A90DDp+i69wYxUV05w3akyTprBLdje2ggjT5S0idj4+lJvUQt3qrv7yZDC13V3+sVH6EgGRoxp2nmUNlc+aeBHiM3tTKJMQYjP6QvcM7/s55wIOAeIFl16sJuK0GwgR6oStAPOzDgXXI8GINOJGeZht8izoO/hJseWBI8cmCT1ipESDqEqbr39Wqlee/GSIfIk7FQptLlwip+42MNYNcfDRkEPhmO6kWYbw7t6RLSgdrM2hfLVui0F1XAyhFqgaZAjaHWyxiYo3AJUd7sBGDvGaFUXHC943rqag6QtIG8O4fs6bfJlk+sXLHoMPyybyv1HUq8/covUBynOhL5kD0CCn4ELHs6mhJmQOgabw39qbj7au37cGR90RwbD2Jk3ISX54KXKq+OOXKNc4eau1FNNgNm9uwo7GBTwGmjG6bP3UoR/z793OyIrox4fHxWDT23knNEen1RmMViw4oitIh6Xy+BX6qoLzdFC0dHdfnDArWnVyJ0WMh2bBtPbKumNSsMRTd+xDQsAYP7PS2Mi/79I06r/h6fAQUxpkMTI/8M3CfhKc7uP8Jh7koKoEwHQYebcVy2kTpQIJSLgSQs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB2169.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199021)(316002)(66946007)(4326008)(66476007)(66556008)(478600001)(41300700001)(110136005)(8676002)(8936002)(5660300002)(38350700002)(38100700002)(186003)(83380400001)(2616005)(6486002)(52116002)(6666004)(1076003)(107886003)(6512007)(6506007)(26005)(86362001)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CETpt4tKpaSr4vPDrlSHfVsCjnsUGMhsfQD/x4MZ6dsatx4DsekgzMFwaSBY?=
 =?us-ascii?Q?H+9OirYlhbBXMu6WMVr6PZSzPr9FI19eWdaEJ/Xf7p0uIxDuARLTgHAYlaGV?=
 =?us-ascii?Q?w56VjkTrF8zP6c7rCJvOTgjqoKvWjGpeXm4O4rAr7IYbXEFPWzd7M9h0EydZ?=
 =?us-ascii?Q?ZjzS0eyqegKofSyMShP9zqwr5qBxQgTsP7xrgnGT85u+LX9dtXfwPne5k8So?=
 =?us-ascii?Q?qUcPNXwa7OckyoFaa1JlfkLzgeiBdXGTrxvdINuM4ebzborhuC5L2/QPVcFY?=
 =?us-ascii?Q?eHjDeoIUp2zZ5d03hehYJgL5d0Tu0j2XsS9+bEFrR621BxrOU/s19Hjcymg3?=
 =?us-ascii?Q?GDG9W0yT0NTWAOy+r4DbTpK2WNnI5PPPPW2LAORPN8J+JJGzhePlS0e3hHET?=
 =?us-ascii?Q?9zzT9BJhCTzdV8Ppr0ZPjmZF5GeKK5n7JPs8lz7mPWHE/9JkfhiE8UaxVLqu?=
 =?us-ascii?Q?DhS9vKOzJSvygudXB1wjkLlKvLfJj3IIur0BlzGAl6JzZ+z//2b34HdLWJVb?=
 =?us-ascii?Q?GXuha4vWrs/C/rwAeeBE8/vNgRrTJQMO9ehF7p8kOSSEnOrZ9pUMVQRNCev/?=
 =?us-ascii?Q?0bFL+OBxlG+vbS0MYEeYWC7XtPVelR0jFJYaQgFIPXJeYcQ/fhMQvRjfoHLi?=
 =?us-ascii?Q?o6f4I9QdiNT8Tj+oTKJjxK71/Hf8MMA50EkpPOfVSTaROD9YgSPZvuRls9Nw?=
 =?us-ascii?Q?qO77mgJG5tPH1CCkz21c340cXUElbk/oUO5k8w1WL0hrE4BgfuxEt6s3CDX3?=
 =?us-ascii?Q?pXvLaIOmdRF7MOAt9e12+MGEBnaQ50+KjXVBYNtwiM6qqy5VHrQileiGRXsB?=
 =?us-ascii?Q?Z+5Mb+zP9+yWRJH16LrUW/JP2NlBsI608+pV5o7nrAfnSVdPTor9fGXWtvFg?=
 =?us-ascii?Q?g99en9PZ0mKqKdWL2hBXQDTMMO23tTYiKLpSwTMGnr1Z2+LevEWCpR7i9afz?=
 =?us-ascii?Q?0PSmUJ6VU55YP8U7a55zR2lDN+TejWArzJv55ZpFenoU3Nmp7zbuiyu/s6l9?=
 =?us-ascii?Q?XSD+wEmuvlXrD6loYTTbspaA0P+Lz9SN3/5e5o+nrWdbJGlRMVsyVs4G0ZpX?=
 =?us-ascii?Q?sSOgL0LpjHEoRKecKvxZBLdNLS8X2nSsCShh2KyIn3O33LrSl+RsdP/N2ckV?=
 =?us-ascii?Q?Cw5Qm+jjNrJacNyuB6xZkCjRqHN7Fsp6uKKat9J/Y6ZwK8KwiUFdMxZda6t2?=
 =?us-ascii?Q?qtM1kMj/pK7ydimBfDO5dehALqDNORudpTalJkRCoWZPsB8uMWHMJMNqWnJ9?=
 =?us-ascii?Q?W8YJvldyNYou9/eQgV2MrDXe6yHznN7VbG4EZ8bvwpeOOoPYKhmBqak6hqCH?=
 =?us-ascii?Q?S7wfMgSORSx0l0Uan/bHOk3H3mffitxUsMfCQlyfawgs13WLk2HZB39Vx121?=
 =?us-ascii?Q?nl+qCw4B9CoBQviz8gd4vAAYzBAigrAYakoUJ+PgcK3Mpl6ZfVTODn2+u0rf?=
 =?us-ascii?Q?W3gHeHY1o8/oK3CG9x3aWl5mxBosKsgg8kBcUCMybfBoqhhm7lNAUFkANQB8?=
 =?us-ascii?Q?1KNc2VYBJM4w5nxOvs7KC8q/Q0+LxFnUDHPP3+Ew6lkQ3zB2+vi8o9pNk8hv?=
 =?us-ascii?Q?nyeqWaaClSIhRxyBFhSOIujN7iopXT2/DxUgIrEp?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0de00e67-dd38-43ec-0f69-08db40b7a130
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB2169.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 09:22:43.9881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vhzTWrEbPSeGdA8cSl5zFwr5tVOCCPeWnaMEOL++TMiywL22H4r+C4MZyysbi7WhakVn6nYqEUfq2+cHwJVVYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4257
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The buffered random write performance of io_uring is poor
due to the following reason:
By default, when performing buffered random writes, io_sq_thread
will call io_issue_sqe writes req, but due to the setting of
IO_URING_F_NONBLOCK, req is executed asynchronously in iou-wrk,
where io_wq_submit_work calls io_issue_sqe completes the write req,
with issue_flag as IO_URING_F_UNLOCKED | IO_URING_F_IOWQ,
which will reduce performance.
This patch will determine whether this req is a buffered random write,
and if so, io_sq_thread directly calls io_issue_sqe(req, 0)
completes req instead of completing it asynchronously in iou wrk.

Performance results:
  For fio the following results have been obtained with a queue depth of
  8 and 4k block size:

             random writes:
             without patch          with patch      libaio      psync
iops:           287k                   560k          248K        324K
bw:            1123MB/s               2188MB/s       970MB/s    1267MB/s
clat:         52760ns                69918ns       28405ns      2109ns

Signed-off-by: luhongfei <luhongfei@vivo.com>
---
 io_uring/io_uring.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 io_uring/io_uring.c

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4a865f0e85d0..64bb91beb4d6
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2075,8 +2075,23 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
 	int ret;
+	bool is_write;
 
-	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+	switch (req->opcode) {
+	case IORING_OP_WRITEV:
+	case IORING_OP_WRITE_FIXED:
+	case IORING_OP_WRITE:
+		is_write = true;
+		break;
+	default:
+		is_write = false;
+		break;
+	}
+
+	if (!is_write || (req->rw.kiocb.ki_flags & IOCB_DIRECT))
+		ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+	else
+		ret = io_issue_sqe(req, 0);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-- 
2.39.0

