Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87617434EC
	for <lists+io-uring@lfdr.de>; Fri, 30 Jun 2023 08:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbjF3GZa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Jun 2023 02:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjF3GZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Jun 2023 02:25:29 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2102.outbound.protection.outlook.com [40.107.255.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C382D4C;
        Thu, 29 Jun 2023 23:25:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVd8j/kdvQHcImWXV3Y/QTrkTNq050DLxi3XOnW6KR/iiVbumXumAQZr1GEmT7MtZ0syDMxNrOJuVj1tPgPYd17R6uAsBVIUBE+x1bZqYxM5zVU7N2kh0Fl0JtBKjjnifsYGzKZmSnhOLeKqlVpZMj6PYmou4QECLjSsNDeTgCw+HLSQ5sxwXufwj9xvAIcb1gkZNqPnYfZCGZpUTKdZEsaJYc8AGawp8lBBz3vJH5VtWKOIJm2ylZCNxNgd+hz9vuqBj6IpY9WhT3XRiCHFJz3cIqhbKoIGGS1ugmJSX9l8ZAR7gOAGv4PLOYu5Z/Hn/7FSgnwMAilCxj5mAgdPNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFk+gZh5JI0XZOW8QKconHAgOkrYKlh/z2qsiLFxqT8=;
 b=EwOSk9WdyBSS1mHgjjiMVqUztyBEM3+0cjtKxFF/bXo9NsoedyqsSbQy7MgXTdrnSXu/D5/cfrkFW8KQ9OpkgGfO4Mr73DuMJu3Uxt2ViYs1W6GfUzSeAazVAx6jYwXOSzYO9/oXTn/si5yJ77TJ7y/fxGEKLyCbC6IrvNgMqXFlMTnBlq273ekE6QcaAyadIVOqV75OeDPRifX+PBUFa2d42dxHhr6B7dZZfX5L6YiCa8vdxYZveNjBkdXWSEn8hHMnX2sJy4CrBiF1S6rBrITAXT5jAsWEsLNpfF7nmf+4+vJSd50vUAHT9DW+izAC5u+sLqLLvIfkVb3QsNCubw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFk+gZh5JI0XZOW8QKconHAgOkrYKlh/z2qsiLFxqT8=;
 b=Te7Z8vKo18/NvMcHzZIcVurRvwwK9Du6aGhAiFyfYPclTZTnWeNis8sVc/cKmvGJnaxtK94CjMeZ6TPeyofFgMpSVSlSdbIbWPNhpdFbgI2BEx4O08pTSOoYbdOTj3J3IPDi80aHN6LaOzojDCNmqzInIc6cMnqhM4bJZxLi+7F5MRKFD0RuqbgCW+1OVLCOGfZn8MiMQEYgkLiHb0oGtQRMJyYyIg55Nbkcm4KaCEX6wBscj051J19C48TIJOnJBWdO9BPC+ds4oyaYi1zO2h+1aD8l21syQXYqtFbGEeynVhP8X7ZxYEMKW6tZUnkhvRH/PqudoNkXBFFXi5evlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB6697.apcprd06.prod.outlook.com (2603:1096:400:451::6)
 by TYZPR06MB5808.apcprd06.prod.outlook.com (2603:1096:400:26a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 30 Jun
 2023 06:25:25 +0000
Received: from TYZPR06MB6697.apcprd06.prod.outlook.com
 ([fe80::f652:a96b:482:409e]) by TYZPR06MB6697.apcprd06.prod.outlook.com
 ([fe80::f652:a96b:482:409e%6]) with mapi id 15.20.6521.023; Fri, 30 Jun 2023
 06:25:25 +0000
From:   Lu Hongfei <luhongfei@vivo.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     opensource.kernel@vivo.com, luhongfei@vivo.com
Subject: [PATCH] io_uring: Add {} to maintain consistency in code format
Date:   Fri, 30 Jun 2023 14:25:12 +0800
Message-Id: <20230630062512.10724-1-luhongfei@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0218.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c5::17) To TYZPR06MB6697.apcprd06.prod.outlook.com
 (2603:1096:400:451::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB6697:EE_|TYZPR06MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c3ff9b8-5676-4985-241b-08db7932c9e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FcxeHw62mjq0a2nUMIJ/YzJHUV29Zv/C8RaICYyfgWigtMUQZc0Zz/UT9niJXPhc114V0iXn7KxbfuA09dG7nlaMFbL0DKdmp5aDeg6gy4dGyIW0yInLUNfKvroRpy7zOomyNjNtAtbkqHYn98NDGpULBDjyswZzdg2gQM8mqhkvTNnXLoY0SNTpHZCI8qNlLQGv08NHj/7/4k9Q3atOrnChYiJRZ3myYyPyU6N/0MClFBnGrO99sp1km9CCQP+CmqbZcctHJlBQYdwv7502RIwh7877lGGpFy3w3V+SCLvtlZcMsXBODiMlhF284EzOzaZCs9/bxTDo9If9SSAX8pFgVbsI/bDYOuXO3GDACdD+SdRJENFr6eRHHYxRXiQw34vDQionwl5GY7PBF/QERBX2k8QfSuMsYjG8XJEIvKf7VqCOiLpsb/lNUb9GKBgAkOf8SfbtcBB+kjeBN7KgTlYSTiX36QTTLqsUF7wzz9zRwJMKtwd1GidTsPrurO2OgS9o5ms2WKCIc4Xzytzah41ZR28UBuZq/D5K+K5sunMnKyo4fujGvxac4RKiHtFgCUuAFS0IjINelRFPcHYceZWywuCvSgZVVVWQorjnSI1qROieVqolElsT7FVP/Xhy9XopCplHy3DqRre9Ea5clw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB6697.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39850400004)(366004)(451199021)(5660300002)(66476007)(26005)(2906002)(4744005)(186003)(1076003)(38100700002)(107886003)(2616005)(38350700002)(6506007)(6512007)(8936002)(83380400001)(41300700001)(66946007)(66556008)(36756003)(6666004)(6486002)(478600001)(8676002)(86362001)(110136005)(4326008)(52116002)(316002)(125773002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f4K7pb1COe0eBLy4tVGJ+rfZ6rYYxIN8sNkxmB78N+gV+Hz0gpLzmpnzok+6?=
 =?us-ascii?Q?36Ofwmjb/vntl3mwQpFeVATqwGpgaMYSeVq9Kb+TRV3gyqmIB9K1m6oracJT?=
 =?us-ascii?Q?GHzkTiCw6St7BLEGsirIvJgXV/Wcc56IUB6aepixzQpuYzYDaLCuXVmKrbzV?=
 =?us-ascii?Q?tELcysWG2y0w6QaCQiF8Z/D8GBhsdY4V/O/CSTlkphVeDLnzTTyZxw2ZskKr?=
 =?us-ascii?Q?FjW5JlGaea9QLNE8pu3IZKDlodqT7/LJOvoUIiBXMvZyP/Jbp/o1ZxTVGBs0?=
 =?us-ascii?Q?c+lp5JWIYfYNe+KCqQhQfpcbPSgZ0e2CrvQdpsFc24xgienrEKsJFU5etyno?=
 =?us-ascii?Q?3NvU9304kSS4zanPlixAEBNgJ1LFMCYMM3/VABSel2v2G88gm9J1ahcvG5RL?=
 =?us-ascii?Q?Q5dCqdpsRY0sAqh65cwxPX+ceRvZrloJOVm1Pg3PvqaKTFWNAOm7jnif17NQ?=
 =?us-ascii?Q?WurtuENuON9WCTGkz9WAdzkAs3+Gdwexfw6rLa3cvwkAInyBIMFnp+mm2R6d?=
 =?us-ascii?Q?Q34K0Q758RsqbjtmOe/FPQDXLogagY4Ad//Z867dsbjOYX+P9RrodDajkNkl?=
 =?us-ascii?Q?OYP5I0PP7yQo0BHg8vx1jYrjJW2vyql7Bg4W6dNelbsiZaPbbCc7uMBpP2Ym?=
 =?us-ascii?Q?KAj8AWmcSf6kSsgVQD/nceZL9Y7BcciuOfO4KvOc5nHAVWYg4rvaSyYGNWaC?=
 =?us-ascii?Q?RESBsKa5G9JLjM44on9PwKhRPH/2Ib6VSufcAQDWJql0I58TFGTX1Toh32Pb?=
 =?us-ascii?Q?p4TgqhmJexD9XWrbYSdFOA+gF1zN8M4dOrIFXtxaR6zLuANOhvmvtMf3KPJO?=
 =?us-ascii?Q?q1YZlTcp6y1fto0G4wIoObp5dfazZxD482rUbdgLFd9gunAO9DKF+MuOS8hg?=
 =?us-ascii?Q?jEhsrZWARt1rUOaXjIZZrhH5WVPKqXa2f3W/sgZtSydk0Kpv1BrbZQQLtSeo?=
 =?us-ascii?Q?A41Tzc7gfGeTbeGmb1PinBfNNcExafb6gR5q0Bl0kG7fl7UaoBiqMf4ZciWd?=
 =?us-ascii?Q?UwxXZK/4vZIyQbI9T8YOi0fXbdjmnZvz6BvlaH9fDiXWYM0eTjyC7+cgUNKF?=
 =?us-ascii?Q?dEsLTVdAbvr7o6gG99InNi/ik0AsB5QSBORA68Fh/o6jW2AU2goXMstm3Idq?=
 =?us-ascii?Q?oWeGL2e7vDo7QbP3EvBODN9nh4HhVbsSR6u2MEO2f49G/+WoCrxr+yC3ii4n?=
 =?us-ascii?Q?5/MzMAx/KApL7YOUcjADV4u1t2Wcb01J+h0b1RiQNnJqLd3gjAxoMzIRyO29?=
 =?us-ascii?Q?maJqmr1DRW+WuEuNu4jdde0oWIBrKdAdhhl9FT19N3aY0XLHkxJaTVYgTn+k?=
 =?us-ascii?Q?RyhOEOpIpprtRXumBem6cpGZ133n+83QBJXiQeFjzMbyBtHb8x83Cgfm6HUC?=
 =?us-ascii?Q?JzoLT+WlI5UYGWZErVicfHlRMvrNli53TW6QX2KLoevVn8EFrmkU0/gzi1QC?=
 =?us-ascii?Q?B9d0BlRUj8jSu7AQmbLLpKmdFR4UhtCD2sACLivNPFtFwdeTJFAg/egNA4y6?=
 =?us-ascii?Q?0NNER4+kD7oeAExc8VaJiUQhItMRsLNzNaISWJ9fhwV8+dGU9ScF66hfxrkQ?=
 =?us-ascii?Q?FztF/JLNlukCUMSQ0Z10xJmibg3SrPuawB2gP8NB?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3ff9b8-5676-4985-241b-08db7932c9e8
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB6697.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 06:25:24.9243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Z3c3YoP69R4j+UobklA8gMw9cHJuMuaLmRnw7HRAA60J5Af0B3zfKl0ufY38USFUAFtg/kXR6MPZSvjI8c4Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In io_issue_sqe, the if (ret == IOU_OK) branch uses {}, so to maintain code
format consistency, it is better to add {} in the else branch.

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 io_uring/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e8096d502a7c..335ba8d49d74 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1877,8 +1877,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 			io_req_complete_defer(req);
 		else
 			io_req_complete_post(req, issue_flags);
-	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
+	} else if (ret != IOU_ISSUE_SKIP_COMPLETE) {
 		return ret;
+	}
 
 	/* If the op doesn't have a file, we're not polling for it */
 	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
-- 
2.39.0

