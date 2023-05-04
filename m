Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450336F655D
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 08:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjEDG70 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 02:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjEDG7Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 02:59:25 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2112.outbound.protection.outlook.com [40.107.255.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF851728;
        Wed,  3 May 2023 23:59:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8jd4TjVAouon5C4KZi04x/+qbPD1rsr9yF7TpXtzkiINB7kPUJao1cZ6m4287uFhYjqdY2oOxfKXbYo3mQctJhFk2b4cpwr2ElA7zvm1MqBqXekl7mCPTgI7BnUVYMXMTD6Exw/ZATN+nQInWbR3f+WWnBHc2o/Bq5BpJ+66OybwhA7vYtaZe7RN5hWF0rRXM2c9jCVySpPwRHkxB3Ck/aFOynfP+2TniDguxLzuyke3dXKYUJtl40UDWx/6O8rL2uBP5K8qj2+nfNBqGpZo/wyUTYbMkIDxL9N6cU8KKcEuXi5M2TObrO3bXdTO6Vn+FKquY2yf2rD8SvqsXb9lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jT2pb6BZBNDLdiCP7VPQDkL1ejjRdt2RZtjtZHrE84=;
 b=AMEbW8hHHFu6aqd2V4fWMBc5m0eUltOqBWgF4H+aABf6JImhAuEHXZRJq6Lw4gTCoMsnCRscQUyZPeWp1zKAaDvKsVYfuJgaQtxuSWeKnWV8Ej2OxJyynojo/IMV86vG6tCg58ZEtLQS4PnLsCDz3whRaG8GFeUyAJI9XuAEHrwnV7M9HnZB/w8vhS7v/L6cpyuED3MT1EkSBQa2HSo2hmy7o4LP1fPmeAuUNgZbbNDgVqWbfcJ0XC8KGVsVerNe23d45SRGzNO63T8vjJ0rqmjNwvFzQU1Ajkk8Gfih0zo3J+CG6fECv+R0RqSIBMl2UzbUaYe+hPJrejwrQBA1Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jT2pb6BZBNDLdiCP7VPQDkL1ejjRdt2RZtjtZHrE84=;
 b=Rh4YJrhaioS5jrKfhJmmGevuyT4ikECP6sFgMSPalz4Y05+tbbgYTi5Zuhwx77Z+aocryPneV9yXsaLBB/YQL3u7lTFWW9SvU6N3MDmiT2TEfoCyhFgDdJSQnhv6zcW2PoNO9f/GuxGfUUjTFYE0QKjk2+3QibI8sizl51obLoUah6B+KfC5grtDYsO7W5THBJ8M3URHIzt4qDCTS+jhA8uvW6gTrWQ0FNm3Eh1FcApgzWNtxLi53dwkCccFRUq+tUgfTLStLc7eqawjPcFOShSEPR0/UVpQmckuloXUGXhw2VjiOzGITvTwc1P7InvLKY3dXMBK+kqQPvHv8zrn8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB2169.apcprd06.prod.outlook.com (2603:1096:4:7::21) by
 SI2PR06MB5265.apcprd06.prod.outlook.com (2603:1096:4:1e4::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.21; Thu, 4 May 2023 06:59:18 +0000
Received: from SG2PR06MB2169.apcprd06.prod.outlook.com
 ([fe80::51d5:9a57:618e:bb10]) by SG2PR06MB2169.apcprd06.prod.outlook.com
 ([fe80::51d5:9a57:618e:bb10%3]) with mapi id 15.20.6363.021; Thu, 4 May 2023
 06:59:18 +0000
From:   luhongfei <luhongfei@vivo.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org (open list:IO_URING),
        linux-kernel@vger.kernel.org (open list)
Cc:     opensource.kernel@vivo.com, luhongfei <luhongfei@vivo.com>
Subject: [PATCH] Subject: io_uring: Remove the check of data->free_work and data->do_work in io_wq_create
Date:   Thu,  4 May 2023 14:59:06 +0800
Message-Id: <20230504065906.46574-1-luhongfei@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0002.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::17) To SG2PR06MB2169.apcprd06.prod.outlook.com
 (2603:1096:4:7::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB2169:EE_|SI2PR06MB5265:EE_
X-MS-Office365-Filtering-Correlation-Id: 97485ad1-1581-4beb-b9c0-08db4c6d14ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMcAFAY4qPHOFaeGJKqEGKFq7MZ7ljfZLP2K5J8AMsyXVpZJ1/THTW0DJ+QgjT8e1X0pKJH8OXi4TkwLzzLTws7AbKo3CbuQAZc1K16Q0cAO5Yw6s4eDbzw/1c9vwNyyRuSaRLCCYniC6aH7x5HtfN8LsZRg+d/eNds0DYYFCqE68wmvrvjUNaMy7QUu3x1Y3tZfiRaRQyGkJ9pznuPAUnix8uJPGCBUixjet1AGGF0Q9KzdhbV7qLTP7rn6BLxw1cQbolD35imRwp1TJviOo4SenCzj5pd2n4N5VwGYAqmPv9aAB1TvQJZEpi/3OS4z3qvH31r7MO0LsTzpC0XQsoSJ0bCjikuO3y4ND2qMJAjicaIGODNnsVt8hSdim1ysSpDihVi8u2a7PDgyFznD7sv1R47drNAcyCubJrEBWFCAi5OnLFagrclrWiUiCFFAGGcrpvajupCnB/3Fiu+OcMHv9LrdwF/vUECsAG7h8iudezWpbg0CytHYdt7rEP6fLzLv3c3/qs1Ryv5FPssiA+HMUxBhXOJvBHBk8Lz0ymc0Zw1/Idmqy6U3C+1sb5EU8Hk5vxZ/spyWtr/zOnSyuTKrGuFq+JloQ9MLp2ycCKfVKdy8kLWgRwZZKdLZu8AN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB2169.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(478600001)(110136005)(186003)(6506007)(2616005)(1076003)(26005)(6512007)(6666004)(6486002)(52116002)(4326008)(41300700001)(66556008)(66476007)(66946007)(316002)(107886003)(83380400001)(5660300002)(8676002)(8936002)(2906002)(38350700002)(38100700002)(4744005)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T85hCCyskGKASS3/lMoM95TAWEYKSw0LD/UGL84IAcaMPxDr7EhG18L02kpb?=
 =?us-ascii?Q?88hu1F6QCIBJM+GIn3/GkqDF4dRXsz9IAbtzUapmpnWEMA7npxMBwf7u4eFE?=
 =?us-ascii?Q?H1LTC4/COavAqYKI3cqXYqWr+zn/N9byjYm4/pP2CsInwGoA75QBVYIWS0ES?=
 =?us-ascii?Q?pyYS0sAZig+V+z2trGTRkQ8d9x06ilctWbJcI7lb8h8FulZm/rhOWndI/kcp?=
 =?us-ascii?Q?m2rhjm9ClAQndMdqwtZWyvEyEOCbA3d7eto9BT8y+CaEmtowz5yjkhmTTn2N?=
 =?us-ascii?Q?xKtSH8bCxkOXHuRznwS9U/pqO80XleAF5WKgBfOgZcDuYluF6Ag+nMfm+khc?=
 =?us-ascii?Q?72b0y+Ans3Tv5Rz8AJZx3wP+s/g96UIva4PIsgwUBOACEB7RRYQh6Ne2bR8q?=
 =?us-ascii?Q?oNb5O72SmQLHJCIt8AENpjmO+DJNNeGEbt35evqBXvPMBm8X9ORgQjRAOEq5?=
 =?us-ascii?Q?m1YyoEjieHsHM90f1fKJ3+JhxtBZVbv4wNJg1x45P1bL6htMUw9TL8Vnp4YN?=
 =?us-ascii?Q?l/qu21PvnS1LW13e400GxBrxymWLUL0J3prA5hCfqLxlhtFpCbRtKX1Xc5iO?=
 =?us-ascii?Q?lcTUiNgQl5j1JKZs385UAabDFjzU74GzZTawfzk9qeqkEeH2EqnaYDBzfkWa?=
 =?us-ascii?Q?8/E9PN21yLmbxQ/tKvcDW09gqMBjI55q7m8hnnVTLRjm1Tn9oy5Hia7W1oId?=
 =?us-ascii?Q?iJHN7uLgH2JEWYsW3HaHjsQ00gha9GBz9P7Ohv8N6kGpk6OkWjquDY34c1JG?=
 =?us-ascii?Q?mMBWoWTSODPndGsX8dfvSUWLXwooXs4MjMAaNSst32+oZdCKlUrlcCdc2rAt?=
 =?us-ascii?Q?hM/HOoQTjKGZmHyPlPqDtkd2xqCVJ7/pJwYKDDfk6tkyti4iDBWE2VPfUDZ9?=
 =?us-ascii?Q?y/hexLRT+Re2r3/LEkPP7GD5Cc/e2qpKijPKCEtDaDH+gutuIiKEhvZjGTwh?=
 =?us-ascii?Q?IaiGvEDJeAKhIr9v3Tl2aagCNQDEaeQ9Is3au0/vy3CdGnWdV2rVhsgpVUQb?=
 =?us-ascii?Q?5a+nWyn2GeNWDLrLTzO+59Wrbhi4b7HA+PJI0nVy5Bn8Op4rcOUVSEMrWmSd?=
 =?us-ascii?Q?F8oj9/EIDQVrQtJqUnLA6sUytwTsk7qbY7EGrP0SZ5jMQ6fuhGkMXNASMMFK?=
 =?us-ascii?Q?fEVN0uB7+sbIb7XSwyZzGasjMukH9uhX9Heyvxd48k4luUwM+oQkDSTxzLrr?=
 =?us-ascii?Q?2FPW+h0LCzAUk5Is2GAQmE3OIN5Ga5awsxeJQmjKN5A6a0cQ6XvD8xJa89CA?=
 =?us-ascii?Q?ivIDG7sxDa1iUJttItEFAa9kb33VCORNaSt3qURFl8yDgrxGpljiOQnuO5XW?=
 =?us-ascii?Q?x4oCQRv7CMjDVPBVk6kdpd8l61YeVBZf1CgyhQBlPZjZYJLw+ONFVoDhFtt8?=
 =?us-ascii?Q?YhH75Brcn08AbS9fGRcvgrewDqVMswiXzbZp/RvFej75AjKZtg2NsK1fcJhX?=
 =?us-ascii?Q?rrT+cWYMUjNHck1nDQ+o8BAINmT3tYi6UflCWp1m8estjIBdX+n1qEokijLJ?=
 =?us-ascii?Q?/Hmc4ZxkBfW1Pyi01omBqqI9BLcQXK+ZUo9u1hLXsbVL/GZ1S/nGrRBGBDni?=
 =?us-ascii?Q?K50Oj7vRHraPQxNy9XZV4aN3WpC+yCM6Lsq7p1AQ?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97485ad1-1581-4beb-b9c0-08db4c6d14ab
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB2169.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 06:59:18.6936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P6N/q7rpUo3jjLqCn5RX6nCjoUhmi+6GArMo5Oj8f8yJdUuomOrNXh3bn9zbTIksZXft5tU6gnoMF4rA4Lt3Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB5265
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove the check of data->free_work and data->do_work in io_wq_create
io_wq_create is only called in io_init_wq_offload, which has already
initialized free_work and do_work to io_wq_free_work and io_wq_submit_work
respectively, so there is no need to detect whether free_work and
do_work are null pointers in io_wq_create.

Signed-off-by: luhongfei <luhongfei@vivo.com>
---
 io_uring/io-wq.c | 2 --
 1 file changed, 2 deletions(-)
 mode change 100644 => 100755 io_uring/io-wq.c

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index f81c0a7136a5..b978a058ea51
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1143,8 +1143,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	int ret, node, i;
 	struct io_wq *wq;
 
-	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
-		return ERR_PTR(-EINVAL);
 	if (WARN_ON_ONCE(!bounded))
 		return ERR_PTR(-EINVAL);
 
-- 
2.39.0

