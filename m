Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B729251EEB4
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiEHPgL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234930AbiEHPgG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:36:06 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2041.outbound.protection.outlook.com [40.92.107.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FD910FFA
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:32:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4RB/jBTwyvOtcF9dxWXNiLzkHWeXkv077uoSf/I9eris02jXtt9FI2Y0BvJS343/7Qb6JlNnjFCHgYtnxmAo+BAygIDaUMPKFfRIxFHm0w2P3SZn64ZQpJUzCJHZ1LlFtkZXTYFjdTR8L3uemr+7zkIY0+5Wv38YEtKv9dkYSIbX1f5Mxra5Fi5U9BCHj2TfQAkQsoRaXCCia18v9nTAFn/zxPlnBg0tv4ttjbf6k8YjW88pcBo1loj61ii7lHJOZPaWzDwRIjIO9kYkMwPeMSAxDtYLA3s4Yhpi/8FYJ0Qa5HmGgbVZclcurPm7w2MMQNWH/lnDq8DXzc4Q4Kz3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APVbNQhOP9OKApoqtEFZDpdTbO1Y7stkIQa0UP0d2dw=;
 b=bWHO/h0Y4/kwjt1mGDEzZde8ejBBNsO3552NUjErWenGbt8B9PCoScHU/NnsZsFIj3+yQMhx2fb6jtb953aHfLDUYTwpJpNUroP6H81K60nEuAnuj75JCdO6rwiRgP2IHBAeHdHvJrzw7OiflXaQDZpdKo7zlJMkB7j/t6VoqrSUEAnT2u0GE6R8SIaKqOPzGinud1N0lTjW+mZG1vwLYM63w1KFwYnAvOBaAqeTTlyKfXEJmTS0vT0jDbTtZ1W3OmKSjt3jc6akNqbM1hSEdooMltrPAFUUbDbsBUVcoBnW4EXsNOIqvNFtTUyHbGASxesVXggToZNXdmlt446E8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APVbNQhOP9OKApoqtEFZDpdTbO1Y7stkIQa0UP0d2dw=;
 b=SfjmEgFggItjWcJNS1QGRcmas7qAXt8dvTgVdFLPkIWnOF1Li7gWaUUhMBNmuMNHKkB1CEK2GKGJjR2myPjzvQ+lpbgtqitjwrkwi35D7gp878YjhKPq0/zYqwMlkESjDmRqHqTSfnK90oJ53OM1xJb6PbuhwHwPK2D4+WJwyILgVCvJeSA5Widlm+PB7mndTZohcyg1b00uPTa4QtJ77ayA4RynSDJ7OX3DCJ2kWMyRktFOW/12DhiuSxPU6tbZoirVLdX7cknHqCROfuAC1uoEy/mGtR0t1jTMkpqJF7b76+TWVWWwXXcySkiLR00MsiUd12rB9HCkDpzNjZ40hw==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by TY0PR0101MB4360.apcprd01.prod.exchangelabs.com
 (2603:1096:400:1b7::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:32:14 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:32:14 +0000
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/4] io_uring: add REQ_F_APOLL_MULTISHOT for requests
Date:   Sun,  8 May 2022 23:32:01 +0800
Message-ID: <SG2PR01MB24116AD710C92CEB3EC2417CFFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508153203.5544-1-haoxu.linux@gmail.com>
References: <20220508153203.5544-1-haoxu.linux@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [UjDnvXiOYEULkgHCclheIragpMKPKgUe]
X-ClientProxiedBy: HK2PR04CA0051.apcprd04.prod.outlook.com
 (2603:1096:202:14::19) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <20220508153203.5544-3-haoxu.linux@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 709e3f95-1ef7-4297-b35c-08da3107ed70
X-MS-TrafficTypeDiagnostic: TY0PR0101MB4360:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UeT0d3z3D/VJAD8ILTcPA4kKWTB3duN5Ebtd3tuZWoMLgjqkRbXoMSIIEIZ2qOPgbGnUE7WsRlaZ1xPho7p5srWG1lbEDxsHU7xiyzj/L9I9M+9W+d0FLxBkT1okBMzv9G8pgqm3UfCXfC7uqE1kSR9W1olV08sHWhwIs0WENg7yo1rVAXujGXmEesZ4yeEGQZfDua6YTQ35obAAna1yqA7Lmtn776KsQYSJCMqoRiBKSVWvrUPPJVps7DXDbw48KMtiktaD9PK07pPqXlFeM+06tG42zOnN3j3YWOnkcVK9CH58of+l6IbmZQ292WH0fBtfOoexJFtva59nV8FI7H81lAWHfqfy1kEVjUdIkgx2bcItxqyTcO5ah5Pq9SbD4DbjK9KC5Z7vmxNRDAoOCBjPNfRcHOE1hQkl6ZiBM7nY49P+DC5wSPFcJ+7fnrV2uIzZD9pwMCMMmYqEAdrw5lI+nZV429jbV5AHRaXU8FjVfceuXmOplxzMJV3fMWbED3z9JM4IHiblY+MV6x8vtcXDb1vYtOr8Uetj2cHmqmcUhY0iB8mO+QKtvhwoybaIdv2DQJnScp5XgoYp0qq2TwaWewfQemT8DTsr5GvDTVk5Qbzjkx9SvD13HpZT8Hnh
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9ZTsd8Wl4h7+S4kuwgMonUCC9vVEd5L1+ryoEn9+rY3u0QePulee6lVTDapX?=
 =?us-ascii?Q?8xKY3xodUXLd2tV97DUsB+LnZeg9jwinHdXjhInUBS2+w1v+xSTToO/5tGk3?=
 =?us-ascii?Q?e6TUApsVfaBlHiYb/pLi5TiFN2Wa1+fqsxBux5DRqaQIspqqcgdQywjN5bBL?=
 =?us-ascii?Q?Kdn/Oak0zW2qQRsDBm7SRqqT+xwmCxQX5m/BJauFnE2r6fX9am480qf3zWMk?=
 =?us-ascii?Q?zPgYdQye4bIOOIqTp9sRgxFmajgRrLQW6XIRrXb3v1BJ2fbwdhunhM1l2iXZ?=
 =?us-ascii?Q?rQsUybpYgMltfl0t2AK8h+wMRz+HikfWF3riqQcTBeFLkz9fmBV5JW1P7ffZ?=
 =?us-ascii?Q?udTtCPWL5RRXnEoHZBfMJfZ1xCmDcZGxfNHXBQnYrquZkKEEQiUPNc7gL3OJ?=
 =?us-ascii?Q?fiyY9NsVqIBkxuMxnc/jBc2O7Nxrkn69EpmiRN/STxlh8JJM6weGpOA9RF8C?=
 =?us-ascii?Q?IqypJ7nnuxyEYv/Oq2PLYuL8JSsKvYhCVhViKA4w56Qn3zYISqyw5MvHEg7R?=
 =?us-ascii?Q?dpHFIOmrjF8K3SDmg/ZCNA3uwxulwMIb5qba10NCuwc1dJAZxIv1kMK5+sfm?=
 =?us-ascii?Q?jFrHpq7E/1B8ia2ryDh1NponIGKIefzM3VUusTLwoq45AASw702TqAjw7ipg?=
 =?us-ascii?Q?4AN4acDo5wnLGkPqs/o4VKm8idvBzXKq4hN1n9zIYeSu8T4Jgy3UOSEVlMII?=
 =?us-ascii?Q?RVZl34j99dB8sNVgOlEOXU4/+MfvLbZB4SDmDDgFrtnxxndgFjNVett3SKOp?=
 =?us-ascii?Q?BPM8nROUFHCRxClZokupKzkozHnRI1rNr1+FwA24qr7ZqOES5gB0AyFvD0hN?=
 =?us-ascii?Q?oxtv1DLV8vmYV7VmQpQI/eAcf2hYKyKhwwjwJzTzBi/sJUaLWx/B6lQOUzf0?=
 =?us-ascii?Q?PIs6urI8xSZx6so+NFoGQcP4XFXlPpMdBYrUP0p3XZJn04DwoOFcgHvaOO4+?=
 =?us-ascii?Q?KPjjOdl5ZV5qpg1KAHIf5QGlNZwFVQKHhWfXQcKswB0XDP1e1BrCIYUu39Fz?=
 =?us-ascii?Q?WLeL5F3QNYMEC2k+/zMBBjnPsv1xwNt2K09j7fRD6VFBzCyLJSPPslMlYCAC?=
 =?us-ascii?Q?JZu5+p8Tj66DkHVnbeNWaRMLFtpVk48XaKqBKI5P6TOiotC9bLqnlWng1Fm+?=
 =?us-ascii?Q?CwayefECBxScjGUKhIpFDQPgVtHHwrSY00jlYVFsTYZ1W8XHp7KHA3LMoeVV?=
 =?us-ascii?Q?oFjC3/DzlcfOeePv05EAtqnvpfjXaCLgp/T/mfOoXKQ+buZwQyYM9dKs0LmX?=
 =?us-ascii?Q?Ycj3A18npzwEAaXoQ1Kl4bq8OShE9sowb5KRw8Vh4WjNJcrk67ga8MNWepGb?=
 =?us-ascii?Q?SZEFNjSqo1YCchwNOtbGosgm0rpiXTFuPHdpSvqxIrkMfBwsImROEvCTZENN?=
 =?us-ascii?Q?8IAdSg0/yYYZjKSQEO0Lgl1jPJMPhbASEEfJFwJmxSbio+QWGPJsJcjAx40O?=
 =?us-ascii?Q?GcOPdoYx6/TivHsGi8QGj4z+udUwp6jubgArBMqWB3UFkCTMUIeWgA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 709e3f95-1ef7-4297-b35c-08da3107ed70
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:32:14.6339
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

