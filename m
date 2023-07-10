Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D6074D111
	for <lists+io-uring@lfdr.de>; Mon, 10 Jul 2023 11:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjGJJKT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Jul 2023 05:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjGJJKQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Jul 2023 05:10:16 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2120.outbound.protection.outlook.com [40.107.117.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5F7F3;
        Mon, 10 Jul 2023 02:10:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzJgHbGGQG2qnfFDodtIy03x9j/f93gIyxlYz1nib5CSdpfeMGg5vijRjpSIPHECHDquH/YaoeYm6Nny+viXKg0qnJf2VjWQkkv5zrtG0ZX550ODicp/9oMQXf82qrnlNdJ/QSZfXMdFwNRWXbLEA5giN6x4JNc13gu6JYpdSoCMw8kHMzrl5gJH08Wo2+BFVENLw3b9Po1GwR0UPYvH7EIfGDoYgCofvxzvIxHAw2rLx4BsvWKx7UUh6ODDQTRP2XNycOefynEw2T/4S2JQjTiTzp4Aq/L3kr8wJrhEExPc4+Rp75dNkhilvsSV/rrxp6V6tKJ92a4rLNCx2njtng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0m2BTOBV3Zj8Kx0onQWj8jznKLJiLMKpXvCwYoLmsI=;
 b=W+t20zRl1TXyx0gb47aJGnLDEa+tT4xCHCYLVji4xA3sLIEvPSRp1bUtGWRUf2ZTWM2zDmmSarcmSDDyU6kBA0gF5RYOTL6vXt9jaF7GZ2/kk9hdTjbrFnZfPsVuqNVesEMysxUt33WWYY3k4XsOnLZAS01VIxhsPvuG5W+xnn4GEaeykS3lYMPOGA/ZmSPLjTkWvgbVGlEH+lHVCQZbTsCeJD0o8XDhgwQ/fS3m2QV7VzdHFyNwyYo2SEHua4giYwiklnQMoDcfNe1sVpbMvinTAWoKtqcYOaYxjZIC3pZjxsPHqrSWvaU1Qmq5CZ6Ep2q12wdwG15hhsQVkkLdGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0m2BTOBV3Zj8Kx0onQWj8jznKLJiLMKpXvCwYoLmsI=;
 b=cQtbR06dLwXSertER8lPsTec6u6P4Z/6WMpyFJ7p6MguInbe1+qt6vp0IzMhsxKpo+U6XcXuuJqr7NnUa8X7VfDobvYhEeonXgO114EM87tAYa2pF1uWr6CvcRBWLNV/zYTallNSIm0FFKcXoxXz3Purtz/nCnQcqx6S6BZSEg8O6+Bu4ntdOrWylywzA1f45HUYkiqvuWvPLoBStlSg7qWvanv0IZs/X6LpKXcp/IGCon8LUw86h12WNs08gTAtgG/o8QV2KUGU7/WYri8lCaL/ZKDLA+wMEaJoUhjIeguhAMgXJ59SK2tnb00Kz+LlYSytdMHorJdk/o8BKhkNJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB6697.apcprd06.prod.outlook.com (2603:1096:400:451::6)
 by TY0PR06MB5579.apcprd06.prod.outlook.com (2603:1096:400:32f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Mon, 10 Jul
 2023 09:10:10 +0000
Received: from TYZPR06MB6697.apcprd06.prod.outlook.com
 ([fe80::8586:be41:eaad:7c03]) by TYZPR06MB6697.apcprd06.prod.outlook.com
 ([fe80::8586:be41:eaad:7c03%7]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 09:10:10 +0000
From:   Lu Hongfei <luhongfei@vivo.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     opensource.kernel@vivo.com, luhongfei@vivo.com
Subject: [PATCH] io_uring: Redefined the meaning of io_alloc_async_data's return value
Date:   Mon, 10 Jul 2023 17:09:56 +0800
Message-Id: <20230710090957.10463-1-luhongfei@vivo.com>
X-Mailer: git-send-email 2.39.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR01CA0011.jpnprd01.prod.outlook.com
 (2603:1096:404:a::23) To TYZPR06MB6697.apcprd06.prod.outlook.com
 (2603:1096:400:451::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB6697:EE_|TY0PR06MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a070c65-fb3b-455b-dc43-08db8125766c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t2fKYI2tWsHA7LwBd/+RjQlXrDCGmLMuTaIlOA1CZeumY7H4t3WnRawm6YVYewYd3G0Yb3aTSTZF8lL75FUIzGEs6OTozZHRyuV8jm1xsFgetaIrxTv3a2ARKFtOArip68P3w0xitcswsMk5z7aQuC4bb4IYqD1airH7uSfwPlnP/ODu1L14geCLz3csMg84myuInqGB3mVq6zt2dDtYVqeBeKUaUnnstJoYXBKMBIxIGbRX1eb11lpzE9KT45dDjzbP0GlElmbIcJXs2OyYmSd/cO8pgns7obCJE9U1vFZ10sPAj8CnqULIAWkIbTQ1tDewgKmgmFU4NL2vrkZA1M7LKhM9jBKkkL5JmlfdUXI34+uFtMlNl+XXhHCi0iXSRPbEwtGiEa8pdqqhzFfZd/mUrqCQ26Yc4AgHCW5cdQVYO7mw89wRGO2oI8Y61L58zvs5Q/z1fufXKOcxQ+C28HYHW/Lfu866WqSDBA+FLTHIVHb9XBzQoh5yDgvC2/6zfEKFqCKvle149zlJJeIk4wrk1S7rn3GChcbNclSdqhm790d8ffdDFaftanl9H3wriDMttmzihFaN95usO2BbjmMpbYo26fIdYToZp3PQwu6DfVPM++DG73+wLt/QplYR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB6697.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199021)(52116002)(4326008)(478600001)(6666004)(110136005)(83380400001)(2616005)(86362001)(36756003)(2906002)(26005)(6512007)(6506007)(1076003)(186003)(107886003)(6486002)(38350700002)(38100700002)(66946007)(66556008)(66476007)(316002)(41300700001)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3PZsJrtOmd8X5miX7Bz/3c7Gs+SsQpjopPydl5YKoCVd70qUalAx2nYoSr8u?=
 =?us-ascii?Q?Usw2F+RjoMAoUZTPmJl/BFv+kZJYjlnQJrzax+tbpznDmRb4qCUAdHb1I54y?=
 =?us-ascii?Q?I0BaZOvej1X5GtXst31MVbyi3GNGKoYG643KfnnKksYOACcR1Vo+2vFXyzAk?=
 =?us-ascii?Q?6RueVfj6JmirEc3a8m/Ct57QFPbmQEJ5cb1cwR9Bofq5L8fJoHtXlfZFH4CA?=
 =?us-ascii?Q?VZZhETxeKGct1yuvDqAYeC05z9FBZgZ/8vZLii+Jip75XyiKlMvaOml7dCqs?=
 =?us-ascii?Q?EO6NkCLpzrYYeMBmMKKxwkQP9GshowDuyVckz19xg8cMS9qcvhVGQmf2tgH2?=
 =?us-ascii?Q?cYydmxOCYy1PFQoBbn/gzsuYE97DIvdDpubq4lkzfE7zoiUctICYebOlkoW7?=
 =?us-ascii?Q?b+GE8hIXta3JpKiMM8ViKSxfh+PvkjDgnxEl87bAD3HjkUB2iot3ucxA+wck?=
 =?us-ascii?Q?cUq5ISF2OdBTZjS9FFJKexUd9BhcszLBE0mRHFzo0iaZ7rT9lI/ng+1RAQdh?=
 =?us-ascii?Q?YHRFspN5onv0VhoME+1dArOffZVD4frZWO+mSFQSzdVPiOAl7t3Bk8UPrSVS?=
 =?us-ascii?Q?7lidO6H7a3z4j/b8UlS914KxIm1TjcBaRfNVctQY9Rqx/755cySgtAPgfasO?=
 =?us-ascii?Q?/QBm2oKe0PfzBASjRl1P3ZxcOwskjuSfUZxDVcrxGzrIZkSei1iep1ZNSOoS?=
 =?us-ascii?Q?WwHo1cODUw7o4oQLMS5yLwX0UWJVdcdhkc7LCgpHLH9Ftsi6jaSX0oYsmxfv?=
 =?us-ascii?Q?Ime2K7u+iyN4BIMcftaGZB6UiZiwdOiIKeYrQkLZgphRcB8ooJyuwWk6DNBS?=
 =?us-ascii?Q?CZ2jA2ulxCsQsexL6lWKEriocyXuCJr7IVe+gp01N5RTn85dt2WWBSI+rsQl?=
 =?us-ascii?Q?SEdWHrqy0A+/7GbayGAVRPHcI/ukGWDx/z0bjuJss+Ux+o0YHALSTxPU7S4f?=
 =?us-ascii?Q?yY4OZ+pnMLFWLLRGd5+v9pn336I/HHebb6prLllU4snMYMivMWo/USYVcskj?=
 =?us-ascii?Q?yCsbbaHb2q3rZakvLZwV2CMnyzFbQXMUak5hhxl4iIGyMc4KNJlcxd8eFBis?=
 =?us-ascii?Q?MiBCdtwDGoPEz6WGNFbQ/cg7PKExUlzDcTzSHAkYWQSfj0vHG4+W6V5Tm8EK?=
 =?us-ascii?Q?X/kSMqSjLkmJNKvbdzPkWd1VGaq8OLX0D1ollG0jdyBq7dikMH4nBYOOtrJl?=
 =?us-ascii?Q?mjKDXEKgJXluDn5eHllGooEludRVgvqjr27IBxGDXYBPtMuiS5E3yYarlqcp?=
 =?us-ascii?Q?sl/x4jc7nscIpmM7erSrQEweq8PVmC5ioBcIFe9jYed+smojBDUS9jv9Ls0N?=
 =?us-ascii?Q?1eJaWefM4EEwvi0hIIqXJ1ovWstU+rV/eoSZfrku1bz7llbOsOtaaXPhucRE?=
 =?us-ascii?Q?NQm6Iaz6JgDZ0JNDnKXoN9kW3sR2VH8qABxMfNIY47GXjtd2lT684MjwDAEa?=
 =?us-ascii?Q?P17BeXrICngysciIpB5U7tZxjKbTViTz07TUUknF9qLRrpA0FAFl1fi0+yj9?=
 =?us-ascii?Q?GgOmsh8J2G1QitK4poHp+QYm23TG3NINrdxVJHI0a0O+5d0Aaw3OnKwGO/WC?=
 =?us-ascii?Q?a6+4IU/V6nAt0JoFF8laIa0s27dRS0B3Fwf5ErFu?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a070c65-fb3b-455b-dc43-08db8125766c
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB6697.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 09:10:10.5844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnzFOUebMhgpPyWw1lHchQQJ4ZnkGmWbSjBKIu45HBwDo9ImX/LNcmRXnpYI1rQHoLnW6oTKhZwMYgAZlBfpSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5579
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Usually, successful memory allocation returns true and failure returns false,
which is more in line with the intuitive perception of most people. So it
is necessary to redefine the meaning of io_alloc_async_data's return value.

This could enhance the readability of the code and reduce the possibility
of confusion.

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 io_uring/io_uring.c  | 13 +++++++++----
 io_uring/net.c       |  4 ++--
 io_uring/rw.c        |  2 +-
 io_uring/timeout.c   |  2 +-
 io_uring/uring_cmd.c |  2 +-
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e8096d502a7c..19f14b7b417d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1753,14 +1753,19 @@ unsigned int io_file_get_flags(struct file *file)
 	return res;
 }
 
+/*
+ * Alloc async data to the req.
+ *
+ * Returns 'true' if the allocation is successful, 'false' otherwise.
+ */
 bool io_alloc_async_data(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(!io_cold_defs[req->opcode].async_size);
 	req->async_data = kmalloc(io_cold_defs[req->opcode].async_size, GFP_KERNEL);
-	if (req->async_data) {
-		req->flags |= REQ_F_ASYNC_DATA;
+	if (!req->async_data)
 		return false;
-	}
+
+	req->flags |= REQ_F_ASYNC_DATA;
 	return true;
 }
 
@@ -1777,7 +1782,7 @@ int io_req_prep_async(struct io_kiocb *req)
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
 	if (!def->manual_alloc) {
-		if (io_alloc_async_data(req))
+		if (!io_alloc_async_data(req))
 			return -EAGAIN;
 	}
 	return cdef->prep_async(req);
diff --git a/io_uring/net.c b/io_uring/net.c
index eb1f51ddcb23..49e659d3a874 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -152,7 +152,7 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
 		}
 	}
 
-	if (!io_alloc_async_data(req)) {
+	if (io_alloc_async_data(req)) {
 		hdr = req->async_data;
 		hdr->free_iov = NULL;
 		return hdr;
@@ -1494,7 +1494,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (req_has_async_data(req))
 			return -EAGAIN;
-		if (io_alloc_async_data(req)) {
+		if (!io_alloc_async_data(req)) {
 			ret = -ENOMEM;
 			goto out;
 		}
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1bce2208b65c..90d4be57a811 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -523,7 +523,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 	if (!req_has_async_data(req)) {
 		struct io_async_rw *iorw;
 
-		if (io_alloc_async_data(req)) {
+		if (!io_alloc_async_data(req)) {
 			kfree(iovec);
 			return -ENOMEM;
 		}
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index fb0547b35dcd..35a756d22781 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -534,7 +534,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
 
 	if (WARN_ON_ONCE(req_has_async_data(req)))
 		return -EFAULT;
-	if (io_alloc_async_data(req))
+	if (!io_alloc_async_data(req))
 		return -ENOMEM;
 
 	data = req->async_data;
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 476c7877ce58..716a28495bf3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -139,7 +139,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
 	if (ret == -EAGAIN) {
 		if (!req_has_async_data(req)) {
-			if (io_alloc_async_data(req))
+			if (!io_alloc_async_data(req))
 				return -ENOMEM;
 			io_uring_cmd_prep_async(req);
 		}
-- 
2.39.0

