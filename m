Return-Path: <io-uring+bounces-8967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43EACB27A79
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 09:58:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82BF37ACF92
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 07:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF65829AAEA;
	Fri, 15 Aug 2025 07:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="XBzoh2G3"
X-Original-To: io-uring@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013055.outbound.protection.outlook.com [52.101.127.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CE729AAF5;
	Fri, 15 Aug 2025 07:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.127.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755244706; cv=fail; b=tlaZFfxMc12xkUXxlSRKqFlcu0ZwASnhYqpdnxZLGs2nxtbtPNZl7vCkTwZKBtNB765z2xf4XPDoNGtwbWSeMe/3HcU0FI0POY+8fLpRkYoNlN89NiCqLw+J7FbsDnzoh6v3qcOmoOqWjTFlLXC75GVpurxn/wsFU2Pn+VO8tRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755244706; c=relaxed/simple;
	bh=YJD5up83XCz2jpye1LwP+URbY/MKFGL9PY3kv5KjeNk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=bgB9fGJjMxnsXbY2aRq5WqAJvdMVc/r40eXYZud7mscjsvqAdQnyJzb9ryORfLqNPTtWp6ew2rxuDvML+IJOhxgZITtetrbq/OMXnwERFo49+/zmlCnD0JPYn8TtHZAOJpNS+6fpwO/6t8Qbxhuqx1VKLuQVxKV7lL8zdYJITcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=XBzoh2G3; arc=fail smtp.client-ip=52.101.127.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TsvD08mwkCHCgb/jiykpd1/a7+LGfKnM9Ip4lss8B96kGCDKzAK3IsrpVye9cpIy2YQNJCjfHxGt04xALoEZDB6K16j6XNmGe5HyWL2MoOjDWBk5s82gkPOuiRcMbnwRGtDC9KooXUoH6/pzkRV40nQgFXS9YtXKDIYol+3JC+aps9G7mhdK62YInNrzZjioMqvGDLuwYu6oJzZ7+aoiMRnvYPnRxiWvAhf2NCbzBHLSu/jJthcJQ4EgGd5fZy45eoOPuTJBHlxO0Mor8Imxbwnu304ytLPkpjGQ4K2TdqM7IaNMs5BpdVEbpnnmAQiL5r7yzSy/cJDQGD5+WLzfWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QUhy+rGzztwrWsK/PV/FLn3yZaqpz4h2ypM7fJKt2/U=;
 b=qI1784rvZA18cD7Hid6Zo4g3k5TPWrAJSAdi4Xn1WARd8C6DN0JVGTuwYbA1DzOkF6wABkwezqVFGsw6x7cVyMYA0yD2qxv3c3+PYt4CD6KcfelYrs/GX/wmZj0eropLtXu53sfpvFkseauiTLkjHQSa1Zjlvg9buzY6iIlpHpaoOHDGS66MwnW/5je7Bw7FX3FpAWLRgT0/BK+YbGqxRGmUBP9lBQawPC3mS456YzoGRfkT3Co1ocAS4kiRzATktPy7YTmTa5GbLqVDtISqsjlqry8ksDnpQoxddcWyuhkCCH6wIVK4TI296oc1qGTt2izJODaE4Mj/oOaRpaDpJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QUhy+rGzztwrWsK/PV/FLn3yZaqpz4h2ypM7fJKt2/U=;
 b=XBzoh2G3eQeJZzVAibCO1hPb3q61SpMhhnHjxVR9KOM6VRwvr2LaHDDaTLLHWgNYaTuJA+SEeJrm5EXyVh3zPEXoAs+zu6irsTk2i0VwwEKQVH4vuAcGyc2i0Sq6phcfypXTCXmuv9k9YMpeg1GbwPDXGDdusyC/Rx6NDqigX0mHdsVsYKf9n8gJMbCeBHQARZ58of594f1zVFivf4orvvCqe6MtIWmjltjqM6EEAImJH40PugL9xHeUDHUNtCv3rUHAuIwN9gle68UMcC4jMZQf5RF4bbpp47+UenfvJFsJEOsxzENq/0iP+393CLqe8RkzsUkT/mThYutNhUjKQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by JH0PR06MB6966.apcprd06.prod.outlook.com (2603:1096:990:68::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 07:58:20 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 07:58:20 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] io_uring: Remove unnecessary conditional statement
Date: Fri, 15 Aug 2025 15:58:05 +0800
Message-Id: <20250815075805.580465-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0044.jpnprd01.prod.outlook.com
 (2603:1096:403:a::14) To KL1PR06MB6020.apcprd06.prod.outlook.com
 (2603:1096:820:d8::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|JH0PR06MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: 628b4bb7-ffc2-4302-a5a6-08dddbd18037
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VC1TJDagyRmcKopqBBrEB2L9m1uHj439Syo7+sLv6X8tZ5+iCimazw60Qx6O?=
 =?us-ascii?Q?05Bwg5gAeP1rtUyiWLw3EeLO4W7C76xejtQDryiCopVC/3e0TxuJT95S1ZN9?=
 =?us-ascii?Q?jMDsmFWwNooh7eVNpA+/TW0okWk5+lfy8tfSP8+IjV4H5MrQqBIGNPDE0mLe?=
 =?us-ascii?Q?SZovW9+MBpSjeWIpFKfNBuLcQl7sFheDJcQg+l5C8kZwDH1tYGJYk8CIYhrG?=
 =?us-ascii?Q?XYzLItdiFPMHSGap6mLsZ7t81yRUGrsloEk08c9HHtJQGEkaOACLbemmgtTy?=
 =?us-ascii?Q?QqiPHfspgRfEpwoK+Fym2JS5qWnUrK0xWp6CAQ4JzXtnieG8LGZJQBL9nqLp?=
 =?us-ascii?Q?MFPhbLdyvwDJlSgg5+8dWA1barsAD2aJY0c+QICE2n1RTtUM7pvJL4HpTuFW?=
 =?us-ascii?Q?lqb5VuN82R23ok5MtBBx8Xrka9KqyPOeYBxHXAN5F+NiAUH9+qWW4+YAqW/l?=
 =?us-ascii?Q?5dK3BrCU8RIZC8lj2ohN68P4PgQuvWRZDNsIyqw11ZLXrVP/wcMSd91T7y0I?=
 =?us-ascii?Q?m8+MgMPWA2tCVoviANFekGjqwOyn1WMHINGUGlio8CcgipOVZ6AtZTF8l2c7?=
 =?us-ascii?Q?+H//ORez6PMhGMC9+6ZTQ0OKl021fIk2WyRX2CuN9Nn/OV3Jf+iDKdHWPcAQ?=
 =?us-ascii?Q?87voyPkGV7L5DsZnOBv47LCu/OPNDjrW015/AAuKjAOa3SbKl6wH429Fnzon?=
 =?us-ascii?Q?qClh58jaKLpqT+PlxEQSIAcBLHcwP1Zmy/1tUMnICAxFpG5JQLT10F1/B22e?=
 =?us-ascii?Q?ySSb5HRatmIuCTETjIG/RNzhovXBO8JUQAgsiG1bNYlt8rgI4D4WKaP00YHd?=
 =?us-ascii?Q?akKBzw9f6F3SCfzU+CIZMsJKgNFCG/0XPooxxAhVpLbW2oo21pZCYVxmG59q?=
 =?us-ascii?Q?G8Ur09fk51MKSdjzMN6YEBGhDC1YZ/O/7Vydr2lKG059i61O2duWPELFkPmL?=
 =?us-ascii?Q?+jLjgmi5Imq5RgRK8g42+DxzPEqrVM8fTNe6WdgC5dC4OC7mP2zMxVTqNs9u?=
 =?us-ascii?Q?V7+k5Hu2e3kj8c3oO+kDK/yk9jRAwkgn/f+Ojy1ZGCzeRMyGk4Pj952IDBfN?=
 =?us-ascii?Q?xZ+OjHwH9vrWICy+I1s21tpdbP76Rw71oPJr/QPe1jdUmiEj7mI1HZQ+YEnX?=
 =?us-ascii?Q?xAMOx5OV+ksJYGKEIZH1PZwx0SZsZcS2n/MVr31SgKPBGjcfobhxXeBnNaJo?=
 =?us-ascii?Q?njnu0O5D30UAfNFNM1h2ZwJ6/2UVnaApJR4yKPpITJp63s/f5BiprWw5FnvP?=
 =?us-ascii?Q?DEHlSOkR9cTRAvicDUWXSh/gmCuLVQYGhaFR1Gz7YbtC7AHI0N1QdcI3tAzq?=
 =?us-ascii?Q?lETcDRXmAeIwYsH/f3m2mXtHZx0WVcNJDtemz/ZITEdCnifpm4HcsjXtX82I?=
 =?us-ascii?Q?PkX9+m0asoFFKX0/MRFEqA4ullRFsB5+PXOxPoQ1ghr7M+8JhteHBPFvqmVI?=
 =?us-ascii?Q?lpPNwwypHAOM3FmJZLzTDlRoQx9rFHPshn5+oQFYtbodgU1hw9VzJSLYTLW4?=
 =?us-ascii?Q?66QUPqcd+19IgYs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Dh3ZgW91KoezGtZg+X0dh3oLlwFYzGOUkAkltu4gAb3/Hn+G75/mREAToPhT?=
 =?us-ascii?Q?p3YKXZ7pjmHTJjRvUgzDQ2i7FJOagSCloT+P4hD/nvMTTleJ4nEgtujnPDEV?=
 =?us-ascii?Q?KRQISHE8/v0rwmAq01Y/gp8Bj34g5qemCG2Q3we9QX5szim0J2fidpJbGA2r?=
 =?us-ascii?Q?EmQCHGt+MVUIRJygzOY5MWTyUo4CSOb87VzUCN+BF391lZ+oywhEY5OzPVPU?=
 =?us-ascii?Q?QL1XxmAjlIuKCsxpIZfItwMQh343p/kBrse3U9UF6Qo8A+8jEoam1Ly/PgdH?=
 =?us-ascii?Q?QiPEVtF8rJLaT5jJ+wWQzUCW8ktOC0fguQvrxXnJGkmnzBFbz1yMIr8KJk9x?=
 =?us-ascii?Q?Fk409EpWy9PravwKbQ0PRkQfbbsadEtXXN7ux+MgBsRVVlayJIFCDcnrTGc7?=
 =?us-ascii?Q?moigMqyAJ45WB8l51ggSeA5Gppiyz/EcOO/9g/G+96OQdXlZV+BtBBaiVZud?=
 =?us-ascii?Q?/Skvl1oPvjrBreBkfTLjTR6u2VOCrwmNclHezW5oRTevfjCRGFkH015LW4q/?=
 =?us-ascii?Q?CJ412w5+Zu42N9PS31emClpq6OqZzW73ODwc6bHxhMBkPJ9Bgr6tdmUb2e8L?=
 =?us-ascii?Q?UU5Q1F7nxyCAOZv2YfkMp+W/7CaqEmjE6oqfC/v8u+/xBLdcBjyZP32FwvDq?=
 =?us-ascii?Q?lXgkSMoJhs/r/U7+e/b43DiOM2HRIE8VPDE/z6iC6nQMMCBXSF9Y+wzuFl0Z?=
 =?us-ascii?Q?6ACs9v9BVNUPs21VUi3wpEYz/foBpARq2VkuCxonn7A4EC7uhaN18plYKfm9?=
 =?us-ascii?Q?PN7oGQIr4lf/Si4iY9cdNFB1PckMJ0hOzpQekUVMqBhoBmSJVVH+iwV2BIQC?=
 =?us-ascii?Q?WrivWbMLpuneVMhVlSH1IrfW1rhHNEygJNRAplJBz7HOzcrLSRC/gL39kbhJ?=
 =?us-ascii?Q?u1a8mzyzZqFEvpEK+U+vLt+9jk7dIQvrbeDZHVsABwb0reHX9X4ZxwtNTwI9?=
 =?us-ascii?Q?S1nEg0gYTuNNUHgURbkNIX5xzr6oyUX8RgqwrehUmoe/em8AUvyvUQqhsHOz?=
 =?us-ascii?Q?iCrfQzbwqfO4e+/Ab47YwK9xiSi+UyaulOkSiY3uyRfiJdUP91ff2Io2nhL8?=
 =?us-ascii?Q?7q7cgpouF197s1kiEL1b6Pg5SAzbPGsz6CtY2xU89OqDrT3lTeVqC8uoiJfs?=
 =?us-ascii?Q?UHPc/oP4FDe1j6KeXBcdh+18GO2K4NSlVIh6MuFS6kmae7HKs1A8yLQBpbmi?=
 =?us-ascii?Q?pjM+IQ6r/Q3jtszZSjhB7vfzYOxJH0ZFJmB4PKyzIaMs8kfGOFwZsUlzVwH1?=
 =?us-ascii?Q?D2fAkX5bKV6bjYy1gvWab4WdFYDEDFv3ZKOPGivo72QnbrC9oXrIP/RzfhlJ?=
 =?us-ascii?Q?aWrFnqhwTQXSFga7aLgtow80Z48ERycj16yZodQyF1f0wMHcA2LvXdu+WKUd?=
 =?us-ascii?Q?UVB0c4LbvzcbB33ICPFGvvX8RlFmtSNJQz52Dz9e+FFCQtEEdKBsfAUtpYLQ?=
 =?us-ascii?Q?MRmjhbt8EntyUvCR9nfr4aZi1msP6d6lQzqq/3q6F2vi1MINHYgnhOnWBOTL?=
 =?us-ascii?Q?zLQqQj5CxjogHG97r3L/AEz8nY+3bUCn6dnHWfxGXwLMqz8yiWaMPggA0SYc?=
 =?us-ascii?Q?s70kKDvfpWMtyMyfbS35XWIn9UsWPTgJ8CxKd426?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 628b4bb7-ffc2-4302-a5a6-08dddbd18037
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 07:58:20.4454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fddzvsDfeDGwRYh8bBYbAJVkFO1M+Nsg+EJK4MIo1k0HJ2Qjxka7pXRhyIwTPxckOGeoQwWKKfGouanAgOS8ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR06MB6966

In the kfree() function, the passed argument is checked. Therefore,
the conditional statement in io_free_batch_list() can be removed.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 io_uring/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ef69dd58734..7a9106066653 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1469,8 +1469,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 			if ((req->flags & REQ_F_POLLED) && req->apoll) {
 				struct async_poll *apoll = req->apoll;
 
-				if (apoll->double_poll)
-					kfree(apoll->double_poll);
+				kfree(apoll->double_poll);
 				io_cache_free(&ctx->apoll_cache, apoll);
 				req->flags &= ~REQ_F_POLLED;
 			}
-- 
2.34.1


