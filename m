Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC1A51EEA2
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbiEHPly (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiEHPlw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:41:52 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2096.outbound.protection.outlook.com [40.92.53.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6070965FB
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:38:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMeDEtXdaEfl2a75NngSGgADfR0/6w4mSo1dmnFhn/qjvHgUKWM5Z/sMAlsKKkVYzrzfxhNBMF+uETLqAP6Fl4h5xsHnbs9b1o+hY+DWWQGFFS1CkMFHnNhAtzYPUoEL123yuCo4AvxpysWaP9q7CTS5ppiOmTsTG0f76tEjcPdOny5fi1TkwMBcKb77HHh3Yl9V4G+oWQ3Qi7gluX4cQnNBs85GtzygFVS4mwo6HPiUOxfc9ueiodjFdBPYgsD9OLlb/Y9dbzn5/nY6yrYGWjPRO3pSagwhLZ2rYFI9ke9km26+8DtkXnuK3CzQU/0qbgc2LSKhU/3kK7G05jtj3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APVbNQhOP9OKApoqtEFZDpdTbO1Y7stkIQa0UP0d2dw=;
 b=Q30teRL1G8VFGktBtNjc42T032UQdfWteFnaWR4kMdgQFQRibmgfqKS0aaTD4qAztzN46shtkh+W+d52xddXGdiG8fvFojUU8jHDWdAMJs5jDaEeqzG/1kId5vHWSrDhtJuXDFSuJ+GCcR87Chydasl5vEUFpnmWxN6oYQyHgXgBvROI247aEeBPYOvs/6Zec9ng972W1sFAsmLdBzBO5IBH6pRRYszSijT5BQGgJe2+yqshaeQ9S1YnMu+acS2j9RMuNDlZa23xdfd68/SpjyPlOv88ZcwqtP0be8jrY7dfv/uKiY8gcGTFwkUJHKik1aVtNf201kDp5k+Gj/KuEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APVbNQhOP9OKApoqtEFZDpdTbO1Y7stkIQa0UP0d2dw=;
 b=iBTOD6q5eUWM2ZBEQzwxF10TWng30mdU3Jq3pLrXjoQlpn/bEbWHHacVcPY45A/c85Uaz2TxHlrjZri8L68EK9CXofpLMzZZiFpa5/8sJt08P/8YE7Oe/lEwD6vr90NCc/kqP2gil1v+jmv/1z/pCyWYSc7bXZPyCf1ntbxy2NCsZyrBsGTKzaVQnm+VwFmWSylWStaynBsHbhyviaTRr+CjEkMGRlzEOVrZgxBxsXOIG/BJIHi314b3LfT9IVweNrZy0DKHr/twl75U1jY+W1blCD7ip+yBQHaheNzbYEsi+rUKT7rcv/RF4u7YR8WH84V6soh+n+htb0AKW1f/Rg==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by PSAPR01MB3910.apcprd01.prod.exchangelabs.com
 (2603:1096:301:17::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Sun, 8 May
 2022 15:37:58 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:37:58 +0000
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/4] io_uring: add REQ_F_APOLL_MULTISHOT for requests
Date:   Sun,  8 May 2022 23:37:45 +0800
Message-ID: <SG2PR01MB24116FD8CF87D774F9EB3697FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508153747.6184-1-haoxu.linux@gmail.com>
References: <20220508153747.6184-1-haoxu.linux@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [bESaaOnqeFHlOOQP56vM/hqG32NoTUH0]
X-ClientProxiedBy: HK2PR0302CA0005.apcprd03.prod.outlook.com
 (2603:1096:202::15) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <20220508153747.6184-3-haoxu.linux@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4753e678-52c0-4b2e-f55c-08da3108ba15
X-MS-TrafficTypeDiagnostic: PSAPR01MB3910:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qc/hvl8cc/JdJG7mrmX+Ue9L0U5lWIsNq5Q6umOEXR5xrtz2sTWhdsJpCHUGv77Iar1vO0MFwMVB5OfeTS/+9vrwb2G5gv3li2gUUZoKT+KB7congQhAQ8J9c0EZk+iq0zY74d3Ez6O9ATCmH6rx6sWvhHEZXfB+4203rnaqEZQy/XoapUYQyKMe5jNWPbNQElg7xKAfcY3bV71G/ylbI/IHuSbulSjenUqgsVRU/C8AmvZMqIOU6zCmlK8mkuYvgKW4BG9uEfZ8d7jeIMgTZav2vzDkPboCiT9R6pxLOeluTcpLHTnRNQxQPTZWjNk+lNaZscsV6ig9ssICnpMiXnZnDF9Q17eAjzrlsXbadsMgUU2XTzc9FZerJ8L4kclzUWh7gnoBZ+R3vuRnrPaz1SLxsGYsIFXlLbPrGg9CW/tA23i+bQvBfGWWwyppkEN+4GgeXf9vYGqXOj1CYYcd8cF8QJHvjquv9dC1YOxiRcwYN7bhNIVdwwMBbw/Dkhc5UFCiUSWf1+MgTyt4M+Lgck8BPrwXeHFmSCtaJoegVTGBQkT0e5b0uu+WEgFFK2GGjYyWUur9E2qdCM1SwXhSxNwtHi3Ma3XP7XkGDq1dv/oTOEVEjtaD6vBraTzO3Hrq
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YW0lroxmVJh8TUqszG58z74FWn9V/ezdc6qnhQzOqxDGZOJBUtP9FjsYqXJO?=
 =?us-ascii?Q?7bRVT4IAGSxItVW4f7+pZnkAOtu/uw4YRN2puzvP5/GOVXCqEP0LaDEwzpMr?=
 =?us-ascii?Q?DOvOlv4buAkvuRZwCFDMPfkYht5KteE5BaSZ+BUslfgYTBjgxyL62gHSQvPh?=
 =?us-ascii?Q?DPzwQKsEy2ZJrlPkgIbA+Kvu/LrKhrmW0pzoJqx9E1ivps064whFcFSmm1wU?=
 =?us-ascii?Q?ISQXEihZ5w7RZl9Ucky/ZNcXLzYDolH4oCGhK7vdZQVXEDBrpm04OqQvq0W5?=
 =?us-ascii?Q?BjHpN1JKzHzNcFZ2yyzCIAO/8DeMaT/WwHxmBX/pjrfchBNFz7GAhMkgGxvt?=
 =?us-ascii?Q?TguZZGuG0dSuiiLitBEJd0H/BVGKDpDPsxg5zRemHllpGOvr3w2zSSYkY/xA?=
 =?us-ascii?Q?6woX0e7PfqyeMPaziCo6XXnbVgKhNAL5277CLgiemauAspJQfsz4ZyyJTsDq?=
 =?us-ascii?Q?pC203ehiRXjqwaIN/2V9uG68VG56tODjM66JX0uW+5Fv6DNdokBr9KSIyMhE?=
 =?us-ascii?Q?Ev/hVWI9buZB2FZf3vkjZYpV4/3T3jDEYzn33Qw3XPYaug4KNZzhRSzjvRib?=
 =?us-ascii?Q?fnlZoHbT5dj7vBJdYvPnm7oq59f91Z3dG5bsG0vkbFl/rOSqWNzDULIhzr2F?=
 =?us-ascii?Q?rqo2QFZfry3vUObld1VyZuFDtLvQJRnHuec92qtlSfMzl0iRr/yUPLyA3F9e?=
 =?us-ascii?Q?z/Wj6h8CYC1oOYqglSOZqxeZ4a66WQjCf6IrzIJMuz2QgpYjLijRLMAWYBxE?=
 =?us-ascii?Q?zbMuMmJkwKYAqzKibb08ISdpNeM1TsfoIehLx4i1rr58wrEzp500I7P4SbBa?=
 =?us-ascii?Q?g+W0od5v/1xME3GZvuH5vFPnn6CxJfKlNzXxvhJYNSXLe+vRTWlvA4gv4toL?=
 =?us-ascii?Q?xcGs/od9G2DauadpXEthGbaTcsDfr5+49l20zDFllwjU2qq635ghP2dyjPWB?=
 =?us-ascii?Q?TYuhZex+nL9izLJ5DGHqA2gtlFgfOy3r+hx0z9g0GfOU6rF3aaPWWdLz6Pm7?=
 =?us-ascii?Q?1LxObN6nY1arYQR0Y1MqT6Zi6XvqLT7NJqDnvBawR0OCx8jVf6uVU8pJZA/+?=
 =?us-ascii?Q?lZxJ3aFhn72H42fSQIliPw8eaXj6rL6CpIowv/mVpB+DVWnoEtOvKT6MJQyM?=
 =?us-ascii?Q?JcqNeWmfNEyMX7u5ipT0afV3D/EzCKi+FJfNkM6hMbuRzsWfDDMcKIuJa+LX?=
 =?us-ascii?Q?zbG5prs1SguO/T3r0KyY6ATGlVLFy/IBpnW+yDcLTQbyBtDB0MdLGdrqLLq6?=
 =?us-ascii?Q?dEphihWo6wP0SRRIHu6rbmfwf2WfKLWPEw+sLyOz0Gsx2+J8juWGn9/VW8ib?=
 =?us-ascii?Q?SgPgigCp5PElZib6AuKyIiW4QxXIQfwXnTHw1J4fubkOa5M3booGpm3m4pot?=
 =?us-ascii?Q?l5tJ5f/vhL6hvVuc8bI0XXF9ERgprQbbTvUlIG45MuWiBG2JB8shA90Xbm8D?=
 =?us-ascii?Q?HhO7cA7b489q/Laon0vRBRqbZ3WEOcHHSd8j9yqg6+oAG2u+1ZrYNA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4753e678-52c0-4b2e-f55c-08da3108ba15
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:37:58.0034
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

Add a flag to indicate multishot mode for fast poll. currently only
accept use it, but there may be more operations leveraging it in the
future. Also add a mask IO_APOLL_MULTI_POLLED which stands for
REQ_F_APOLL_MULTI | REQ_F_POLLED, to make the code short and cleaner.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b6d491c9a25f..c2ee184ac693 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -116,6 +116,8 @@
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 IO_REQ_CLEAN_FLAGS)
 
+#define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
+
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
 struct io_uring {
@@ -810,6 +812,7 @@ enum {
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_PARTIAL_IO_BIT,
+	REQ_F_APOLL_MULTISHOT_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -874,6 +877,8 @@ enum {
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
 	/* request has already done partial IO */
 	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
+	/* fast poll multishot mode */
+	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
 };
 
 struct async_poll {
-- 
2.25.1

