Return-Path: <io-uring+bounces-12976-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SDgkBrn71Wn4/gcAu9opvQ
	(envelope-from <io-uring+bounces-12976-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 08:54:49 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 991933B7C6B
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 08:54:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E08B1300F79E
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 06:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627E436655D;
	Wed,  8 Apr 2026 06:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qGRWuRy0"
X-Original-To: io-uring@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010019.outbound.protection.outlook.com [52.101.61.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25435358372;
	Wed,  8 Apr 2026 06:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775631268; cv=fail; b=HpNHT3iEDOkh4f6MLyEuOfr4gDpCzvb/RY0/RV/xqcpWdo3VpVmRyiUHq5tAjXs3XbPmi3FgBEnYanAuuuKetYmuD+vIJbMdEREn9X+YXFf+0aEJNDHQupPjZn2T+0i/nDhfwADzAZOApvJbqqhmB4L0YA9rq5AqvclnhEErfUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775631268; c=relaxed/simple;
	bh=Gmghc4hYwQN33TVwD8dPuTvQHI7RWq2Fzjl8UqY3cg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=do9TBQqccaMkh8vfK8XaGE/wgU9Pg5ltiDljD0+9tMbkDY6ptkilBdIqJ08ap4yTxYXredZJxKKVkO6+10yyvZxMv3fwJ0ftQvwKiRs8HY6+uyEHKEJjk1etGEc1OVM6/NcLWClZmSuNGviyuJyhwBfZscmON5hDj1SBQJjxF4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qGRWuRy0; arc=fail smtp.client-ip=52.101.61.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GsD+DraOfSA7FB3KYBKaLN0xsyvCquiLYG4YD4VbypL8xdONEM4KhOcvOVy1K4xJz9VQp7o9jnWlhDInJb5xgWyIoWmwf5vP/jZPDnPyZU1q225Z/FdaWmiFoGa62+JXwgl15brsq+b6Kz7XqUte/7NnGpIJmMuXYgWnoFltOa0bmosHlOtAVHmkAWfGiFEYMY9Yz6cpuxD15+peHvfkIww7oUUjQ5OkbdfboJHHuZ3lqj/Ox59GNoQqLWFId4aGrHPPTJOZkfpzuMHmBHlFCE/W7D4yqGoLKxsCdnu5nMlWB3/bH8fdqGxUet7MmokMMF6NSJcKt/dABeJcl9PDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oe2sD63im7pL3L8gWAYsykcbIOy3PCysyyAGNhvF5B0=;
 b=aIiFQz2mFEbg1PZ3DpVxHyjOtBX0VweSQrKXnvBi5Tu6J8RCoUmSGFNb1cFApBT4SHIWxcKvwUJcwAW8/IxpzTkCokU9yxVx/PCR7aMFjsu/lBgxE3lei5zDl3TrSRckPUoAI8k8TFXoFlDcHGcgO2uSqMjqwGbteP8S/8FojsI6sFi7Si+WF1H4zuNoqY7eLbI66TxJb5M4Caxc6Zg8haXeAsXz+prSN4//rZqKbq/krQCe6YwuztswyEmCVyydb9iKHRSW+pmwmzVnp1RPrC924lQ6qUi5H6CunMkzQQx/oYLDPrWJPZNmALvKEFFm9aWByL23YQVfmX9ItTdnLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oe2sD63im7pL3L8gWAYsykcbIOy3PCysyyAGNhvF5B0=;
 b=qGRWuRy0kfUCY9EGd6W616wp7T1a6krsV4SQlXzmd1td7RQWtINas92jjw+4fiZzoznOeZ473jjRcU/pXBMK1SdDJMYTgdPI0WrtLYR+95qTyvOOk+Ln35Fl/v7TI5mEGpXBqaXNha+ciddJTQCiLVG89ZfqDFm/dCo4NVc52edb9G+1/izZFcc44UrSZOognECbQqBA8exP5Ix8m5rEbY4P8qIdjpyZ2hauaeGJdWpzLcBtCGOVIy9AmxX0yrfbczae2N9iE8iT/micgN/98gtM2XfTHvWwy42GwL7BUzqqw4T/qQUHaDjcvOKNXlZEZLvtYqEY/M+y6mzwhnbbZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHXPR12MB999244.namprd12.prod.outlook.com
 (2603:10b6:610:2fc::17) by LV3PR12MB9412.namprd12.prod.outlook.com
 (2603:10b6:408:211::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 8 Apr
 2026 06:54:24 +0000
Received: from CHXPR12MB999244.namprd12.prod.outlook.com
 ([fe80::168f:599c:f74d:7688]) by CHXPR12MB999244.namprd12.prod.outlook.com
 ([fe80::168f:599c:f74d:7688%5]) with mapi id 15.20.9769.018; Wed, 8 Apr 2026
 06:54:24 +0000
From: KobaK <kobak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Koba Ko <kobak@nvidia.com>
Subject: [PATCH 2/3] io_uring/rsrc: use io_cache_free for node in io_buffer_register_bvec error path
Date: Wed,  8 Apr 2026 14:54:07 +0800
Message-ID: <20260408065408.2017967-3-kobak@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260408065408.2017967-1-kobak@nvidia.com>
References: <20260408065408.2017967-1-kobak@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY4PR01CA0027.jpnprd01.prod.outlook.com
 (2603:1096:405:2bf::11) To CHXPR12MB999244.namprd12.prod.outlook.com
 (2603:10b6:610:2fc::17)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHXPR12MB999244:EE_|LV3PR12MB9412:EE_
X-MS-Office365-Filtering-Correlation-Id: 715980f9-df29-4761-059c-08de953bab58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	jxw9zvwxFARx43QrZPHWxmigUX8fLpkeECJzlojYpBeo9hJ9OwXJSDhmMpzx3LMyi24FVWoWRdrZS+OaWxsDYkwopzbSe6Jzxn12ojuVw7SOfidl8+5TgMf+QsXBdIkwTjpTKtM+KC2xMowa7UUkghTZ7xZyUzqq3wdGx9xMAwwkPF9iH/7Jckxvb1R4FMm9nGGydU0UjPhA49CRkFLAXiugoRAfmp7Ip3Yf/pEhiswM8CkKhQ4hiugG1J1g0Lxynxq63jx5tndgo9mYqRRwamcFL9DbWOi9tx3gWLypr+EA6NroJz5y1OgBbuXCIFPM5jjs5lb/hN2BwHExKsqw7vb2bpJyaNt0qLS2QtHxH8Mjmdw68q9ja1ydyxHXUdBMfVWGdckye9MvDGszCB08fHgXA3Z1vl4kbduzSjxOHC9YWnq3dsofZWsfodXejX7PIZRzHF8umT8KwSdTstJvDo67ZrcIda6mEr+T7ZUSHQ88ah4KamZFtDyAq6DEfAwkM90T01FhV0Ovk1vmL/tsMMjH/s3/gOCK+XylvZazM3T0PgBDmLAUHAmzCI++tphR8saSOBfbC+6TeAWTI+xKKryvV6YCOkPyGbgXu98bQIXz8d7LfIw13efdBtiNUo6IZaEau0A/y6oPAZY80DALbTTPKDnHefnTmaz7k95n1LlXqLRoY2FSYgokxFjZy8qjXV3S/wToGJhon5S9osjzTWD6fRQRh23uDL8vMuwMQW8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHXPR12MB999244.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p3An5W3eXAp1yDRQWivRPasHilVSWXtrHB43IIqQIVNMP4ERB5lidMBoobPi?=
 =?us-ascii?Q?pUre9q6PFKUDVzf36ZZtv82CyvfnaxrHqXIVTvo67U2jndCAbRrerEACEHg2?=
 =?us-ascii?Q?wkRKJQjEqxR/RhiSjwp6WLRh7rv3HmhwOh6zQG0iSRnN0aBJx5XBtE0YdIdV?=
 =?us-ascii?Q?i3dfIluKgea6zqO/wGFuTXC5mBfPdbwIRXCueDKTHxpYBKsONdE2cWJa1FXT?=
 =?us-ascii?Q?aQO1X9xS4MlaHBthboxQe0dazn7+9R6iaveg7vC/NhTMlZhfrtOjKK2j8mYk?=
 =?us-ascii?Q?SyI8QUFH2nyiHoHaAPQNGbHU6VgkxgoXycTGsbnjf1CFZqwpNBilTRUMZvrh?=
 =?us-ascii?Q?R1BWHhPin7fqiQQlxrzai1GlgDHDAlcYfQ+XV3bGSBm7P38iZEhOyaKjxlzF?=
 =?us-ascii?Q?i3JX9W/XaZ3FpCYk052MonrqiCipk0Ghq/+E3O6g5agJHjsNlB6MsJvWNCaI?=
 =?us-ascii?Q?cXVHH5pxrcrcwZRlhu/UwqwOjUuiGfkV3B/2/++4/KA+3yOO2BeXECzE3Z+D?=
 =?us-ascii?Q?2H8N49Cn6l3trz6GM8NCSOjCyMGY+9PR1wXITRrMDSSU2+jZn77mmNXzA6Sw?=
 =?us-ascii?Q?n2wJp3RkaeTmsTtXubngqECCdO1rsn7tGMgQdFfAgNN4J8EsOF33vStQkv5X?=
 =?us-ascii?Q?+VpGgeHAndYJUwCp7tpgBuesOH37oFFWknXFhguaOW4F9LV+4sWM7iXNA26w?=
 =?us-ascii?Q?JDzfO4VC9b58Q1Gq+h3aQaDn3JrjJ4cOi59F4kp508VAS2RXlnJDNbRrW4AF?=
 =?us-ascii?Q?dUPHaRTf2dzrKmuYA+ooit/WS8D+PF8BL7ZXsZrOXl2ptHjGhvTU5N7UzYhH?=
 =?us-ascii?Q?YmEf9Y2HRwgJyzEncsgd6c9toAP/YWMJuTb8rfKlyMl7qfQNdIhehIASA6kx?=
 =?us-ascii?Q?7/wAFdHnAqK5iEWhX0l9/OWH2hgBvhnbbeLly8WY1dB8xwOPm5QftMa7L76W?=
 =?us-ascii?Q?nxMueTjkaQnbNfRRyAbjXyQKwMBSaMPyAPdxblhramJWn2PqJgTkvZZ+3gPY?=
 =?us-ascii?Q?VLTGmiVrbLnJ/3rnSU7yJA3JWmQWutZRpofO8sM9xHUT9WkPskUS+h2yPwMh?=
 =?us-ascii?Q?1c4nKh2uxF53guNFdKWsvOR4Q2P4t2ncdjmLsqqq0v1rhZ7bBkHkYPAXL9so?=
 =?us-ascii?Q?bXP8TpFBRLoC/r1FEKEX+iAPlzkOscFJSnC3W9/0EBVlotQRQQ2Y1nbwC2vD?=
 =?us-ascii?Q?hMw4uO4knw+TsKzzD6cHxXOIc5uy+bjAO0UhnmUT/5jxcApQHRu5nRNQI7dA?=
 =?us-ascii?Q?zOtLqBca3RhYgbXd3EwkL1O/EVxr31ceRnKGdE8KounGdsJy06MBTlwrEx35?=
 =?us-ascii?Q?hup0lbSb3Utmm860HYYvpz+T8iN4C+ndC404QvUeIBh07W7sd5uyshNYyqBP?=
 =?us-ascii?Q?T65MKQAiYNP5ECxrPP2lWkmNp3I01QCYnFHTm80zCldd8YkySAZbNkEdcx3U?=
 =?us-ascii?Q?EKA2UHHKMbjACtV8lnzqU+pUqBgnIOgiedliBOF0hXSjujlkulra1XOfAvdj?=
 =?us-ascii?Q?Nb2SZ9EF10QBPfy65qKXx6BSANGKPQc8uTLz36MMhAAT4SCJ+OYLbzvpaW6s?=
 =?us-ascii?Q?y+cT2k6efegQ5K5awCU+AWsxzdiwJMkYpHB+cTvXKQbbqiKb9fl8V6/YESJl?=
 =?us-ascii?Q?bN5vu/a3u+aVF7z4YYuQlS8q7PQSzkPqfqoUz87LuYw9EGwrfQXFnifLE7MF?=
 =?us-ascii?Q?KDRdwC1As+Egadxshj6DWTk6/aGA6S0yuQd37HQQydo1Dk78nASarnb4oPnN?=
 =?us-ascii?Q?8CjdpG/Thg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715980f9-df29-4761-059c-08de953bab58
X-MS-Exchange-CrossTenant-AuthSource: CHXPR12MB999244.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 06:54:24.4003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSUcYnohyG5JAs+hlAMwaLK5j1/pTVqQKOCPb1TBJQxbnfFgh/Z7kegp9HVF+bCNhH3PaplXYQ8RKeSvcO98ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9412
X-Spamd-Result: default: False [2.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	TAGGED_FROM(0.00)[bounces-12976-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kobak@nvidia.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:email,nvidia.com:mid]
X-Rspamd-Queue-Id: 991933B7C6B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Koba Ko <kobak@nvidia.com>

io_buffer_register_bvec() allocates the rsrc node via
io_rsrc_node_alloc() which pulls from ctx->node_cache. On imu allocation
failure, the node is freed with raw kfree() instead of
io_cache_free(&ctx->node_cache, node), bypassing the cache return path
and wasting a reuse opportunity. Every other error path in this file
correctly uses io_cache_free for nodes.

Fixes: 27cb27b6d5ea4 ("io_uring: add support for kernel registered bvecs")
Signed-off-by: Koba Ko <kobak@nvidia.com>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 1b96ab5e98c99..6f46cf9cd13d7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -961,7 +961,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	 */
 	imu = io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
 	if (!imu) {
-		kfree(node);
+		io_cache_free(&ctx->node_cache, node);
 		ret = -ENOMEM;
 		goto unlock;
 	}
-- 
2.43.0


