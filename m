Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65760749890
	for <lists+io-uring@lfdr.de>; Thu,  6 Jul 2023 11:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjGFJcj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Jul 2023 05:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjGFJci (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Jul 2023 05:32:38 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2127.outbound.protection.outlook.com [40.107.117.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF961FDA;
        Thu,  6 Jul 2023 02:32:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rr3bC59/uypTMHIliFUewTeTNKvzrQP0LBwr4wvsOGLoVNBsO6IreBql1p0AxhmPSfdyYlMhpkPCYsnPXsxMp0UJuGLM1mEZNPbU8W71cBQSZzuwqGeXKYzc8hehmiXRadFfYcnSXp3b8qHtoVb2aSq6TB7dC2FgnJtYpuhBLRLAIpzyTR6kXhKsgOhkUc6Sjh5idqCn2to+Xcid2MkDYbvqNzNaGXlEH/GIpEMVbK4FxID+Ex+MrznZQr6O3pDC8cQa5JLMgsbi+5219XB9DcQLtkIeg+4zwXHyyBCvNQMnIFHhqJgX1DTwBJWBK0rJY6/uiSG4Fnlcu/+nJGuZxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LLhHgP7dic8Mf9IZY5OgYT4M8F/PbmvUha/wmhNOS0=;
 b=A7D1L7Zvtmu07zG3HPV9x/piZCxAr/rnCkoKFpsflr90yA3SdHJP2cchNR/M4MzZ4LYhYQWQ3JnZLQ2o09UR7Y5LxJkXFl1PPVCkPSsKlDxCliPsBDD2nC+pULlWKgOui+KSoNOH42snbCABdV71r57eyC9K9jDroP0wsmVqs6QX8hYVoStkpj50AsfirzMZkPjttFMkAn3w1kuu+YWzEmvlDMnNXhWvzG1ZZCrRW5TR1oLElHGfugEHeQhcaR2kaL7hfigPdWbFa80S3HU0MKxaZeSDAUzxPk6JxlTpaZq+zWWnlmlQD8m2CF+JXiEgnwejVELsQB/SGPx2sInLFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LLhHgP7dic8Mf9IZY5OgYT4M8F/PbmvUha/wmhNOS0=;
 b=EG8MM5QxkvU0wfxyYFAgwyF1DCSc/6pN5BnMRzBFokaqjPdwbR9gcyMyt5cXk11z0BxrjHL5pRTy7C5ZD2d5C2alU0CyGyaS4eSbUzMpCYhjM/TzYx0IqkIDqGd8kfmMl094dJMRpY4dpiBwBdjS4Ayz6deM9O99VhBYbqGXQrMXMyAHpT9zkW5UQL89oaJXflCrOekAu7DGvT8WGEbrawyAVo++rJlB5tFasBuAyL/HYx+3Kt6o6oHZvxceY/Qa7kwQwhvBc+/kQakiwlog5NF3fGcnpikPrMIWd0W6N72UEzadwsX6gBYHBV3e/WKgzrm96/VWmneXrPVRtrxXrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB6697.apcprd06.prod.outlook.com (2603:1096:400:451::6)
 by TYZPR06MB6380.apcprd06.prod.outlook.com (2603:1096:400:363::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Thu, 6 Jul
 2023 09:32:20 +0000
Received: from TYZPR06MB6697.apcprd06.prod.outlook.com
 ([fe80::8586:be41:eaad:7c03]) by TYZPR06MB6697.apcprd06.prod.outlook.com
 ([fe80::8586:be41:eaad:7c03%7]) with mapi id 15.20.6544.024; Thu, 6 Jul 2023
 09:32:20 +0000
From:   Lu Hongfei <luhongfei@vivo.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     opensource.kernel@vivo.com, luhongfei@vivo.com
Subject: [PATCH] io_uring: A new function has been defined to make get/put exist in pairs
Date:   Thu,  6 Jul 2023 17:32:08 +0800
Message-Id: <20230706093208.6072-1-luhongfei@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0241.apcprd06.prod.outlook.com
 (2603:1096:4:ac::25) To TYZPR06MB6697.apcprd06.prod.outlook.com
 (2603:1096:400:451::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB6697:EE_|TYZPR06MB6380:EE_
X-MS-Office365-Filtering-Correlation-Id: 24cbbbd8-3123-40df-e541-08db7e03e588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x+W4JNfDwLV+JNFIsj9Kt4TrbwNeBC/Dyt+2l/HJcVtRtSok7+hVUmsY4Y/Nh4GhBhpwYyt+XcocoXWtiqqv5v6I6qPgRc/AVsI4VXTVSW3oig29uldGUSn0hEaMLod26xgQdmrqJNtKKTObnX9poLpvBs2I5lvQ5npJ0rbNLPIg9keWtJbVKBwrOBceW6gGiv46kmJzsSNVQtvQBGWv7F+LqGjvxZy99geXifi1uipz/yToZFnSgxk1QBbx93d+4lmtGoKsrpDdnzWipiXcjTss6LSNxEJqgoUECdSCKibHoK3phavHjDFujFokB803CpbTfFTiPo8iImxWFPwQWkushZfQmeuUEQQJGTIcYK6NATzjlYCBWEG0P7URFdyeWxphbuvR5eQk6zk1W/qAHVToa65WB/qPfjkpfrYvtx5cgP8HqYMxMj4kH22H8W7x15JBeWyCoiHM63guljCoy/jzfX6PFz5AsPCd41u5KqBYGyrAsozfigmNUEtSqAkM2R2tXC+rpZA8pNs93qYpaYcIqCfTV7s/1loImSiDEPnUCaNN+MxUddgdDsc8aA/KdyiHOcV9tebm9OTqhniIXdJBsXWfoMqk7R20c1CoaROyBEu8Hm97k2ro4jCg5NnD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB6697.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199021)(6486002)(478600001)(52116002)(6666004)(110136005)(2616005)(6506007)(66946007)(1076003)(186003)(26005)(107886003)(41300700001)(6512007)(2906002)(66556008)(66476007)(4326008)(316002)(8936002)(5660300002)(8676002)(38350700002)(38100700002)(36756003)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C1D6Femj/CYf2uOVSiUVoGbD7N3kLlVMAMUL2GKIDU9knbUIque/SE1bMqL9?=
 =?us-ascii?Q?KMWMyOrlnFVQNlV3sy7q6etctBvC6cpMhj581l1j/yomvc6XRLCpaDDdld/r?=
 =?us-ascii?Q?t88vpu/tS/vDDjrkPetNruTNf9spynwXOninQypkkQifW86gL9pBmJWs9+LO?=
 =?us-ascii?Q?OhIOSHiaPMPNMCFlOkXJKu1WH20qfKvVjAOKuZZXIdVDEUtkdVj92lY5es/i?=
 =?us-ascii?Q?+7GZ1hlD/JXcKVyExA7T4fN4tYHAm+l67z266XimTaTQua5iU8AuJekHoOBC?=
 =?us-ascii?Q?NaeOQO4c6O0Kt6vf6Q6UiiQ1NxtgjV69EmVGEY/mpkuOij6GF3ckO4pUJhlJ?=
 =?us-ascii?Q?y9YiuetylRmx87zRBhnG67+MRk+L4T6puoK8M2g0H98yabtSSKDCMhJH6Qmf?=
 =?us-ascii?Q?vZc/9M0Byl7VDsoQhKP4y7WIxZpCLWJY1W68G0VoTlZi5B7vo0J1H5O0Z4gD?=
 =?us-ascii?Q?7DxppL+tXlZsXLASJoXF1gz1CxVgL/fkbm3dWOxK9r9u3hwhrc0cQfH4ysK2?=
 =?us-ascii?Q?1Ibm6b5d5XqNy8wgEhqVEWSsD+oeEnAiks23cLy5tdL4ZEM21zh6V74WiSe9?=
 =?us-ascii?Q?ll6DNWcDriBVF/rI3wzhZEyuFp642NPUvoQO9mgKxNC8nHLs+oK4OGSiZ3a7?=
 =?us-ascii?Q?7TSmKIPFwXJ+OsxyVCpL1yyVPZyeati3BOSxw1PlHS+LDLqcha7piFZHfPTk?=
 =?us-ascii?Q?aGmcDRG8Q8IztSRc4WHl88QEpawDYqduLqiCoeI5L+q53tHueol8KTSH3+PT?=
 =?us-ascii?Q?lv8adPX1MMB9UiA7fS+2zF8TYVblZuicOQmtFLt3ln5x4aj0RM6CUN/xMXuf?=
 =?us-ascii?Q?tgxUfKyz8Yf0J3+GZ95gMZ9f0A0sEscsRljdO0r/ccCmo7tEn0NH4Io4hMoJ?=
 =?us-ascii?Q?uV2HhJCTIP0oFfqywqnFki4q79PELRRRqKUrtyZw5wE2cACTqd2rYcP6IJSP?=
 =?us-ascii?Q?W519sQ9F1rSlFgXN4KhgTU0yswHeinu584mckc52+5UBPX0Ur1Th1et0jJWD?=
 =?us-ascii?Q?DjErjeh4wYXpcWgY1LH2ZSmGNpBh/fkIJ/XziyzHX+V7y71sJ+HwlbRG0miH?=
 =?us-ascii?Q?JKynYwSrNITopUSn7hkVtnUGP+U8LqNcCsV3CsiX5WUUWCaXfvkZrkFL+iHQ?=
 =?us-ascii?Q?j7NNi0qHSeNUoQXzj4C4R+D1/m0n6gQRYynQOOHdabGAvMrd7NXz+m56ka2u?=
 =?us-ascii?Q?+PosY8Ocvd/oouLQsBPfB2hToN0YP4OyGIyH1bM/Iv0KVH77it21/fM1THLp?=
 =?us-ascii?Q?SOl0hTA/MLU14UpKokzG7StuwqXJpkoLDQzq1eteKjptQykqXtPxeYXRG4Kk?=
 =?us-ascii?Q?14EHMgHRfv5DjbY4J6e2R4+WOoUWg8c9vMPwt79/T0cVDfVFXt1uJE3P63ho?=
 =?us-ascii?Q?uD9ffqQu4jXT9v4Om5876j4016EcwbsqLuhu9KpqC9v0e63GGRlH1QmcJWXd?=
 =?us-ascii?Q?pv0gWG0XWyzr3BP7Z15EKI355BH1KUnx1ED8COK7v1RCiA7KYfZlswxtitbG?=
 =?us-ascii?Q?zVZZcwqI621omrVaeicTqeE+FaIXW16rATFp1Kw8SzUrc6e3hAot5HZ4AHAS?=
 =?us-ascii?Q?OzdJqCrxPIFhwUu5rkznazzQVxhpbJf08UbOExud?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24cbbbd8-3123-40df-e541-08db7e03e588
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB6697.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 09:32:20.6029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0SBZ/OtSFNqxLJHfhwxXpMzphwnJkhsK6PXvJD8fUv38FRVKRoP1wngX79Dd7ToygwVK+iqXuZJqTV1QN3liA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6380
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A new function called io_put_task_refs has been defined for pairing
with io_get_task_refs.

In io_submit_sqes(), when req is not fully sent(i.e. left != 0), it is
necessary to call the io_put_task_refs() to recover the current process's
cached_refs and pair it with the io_get_task_refs(), which is easy to
understand and looks more regular.

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e8096d502a7c..43844bc2bc62 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2421,7 +2421,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		/* try again if it submitted nothing and can't allocate a req */
 		if (!ret && io_req_cache_empty(ctx))
 			ret = -EAGAIN;
-		current->io_uring->cached_refs += left;
+		io_put_task_refs(left);
 	}
 
 	io_submit_state_end(ctx);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d3606d30cf6f..bf01c56322c9 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -342,6 +342,11 @@ static inline void io_get_task_refs(int nr)
 		io_task_refs_refill(tctx);
 }
 
+static inline void io_put_task_refs(int nr)
+{
+	current->io_uring->cached_refs += nr;
+}
+
 static inline bool io_req_cache_empty(struct io_ring_ctx *ctx)
 {
 	return !ctx->submit_state.free_list.next;
-- 
2.39.0

