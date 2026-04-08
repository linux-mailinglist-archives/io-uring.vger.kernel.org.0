Return-Path: <io-uring+bounces-12977-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKxnES781Wn4/gcAu9opvQ
	(envelope-from <io-uring+bounces-12977-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 08:56:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C093B7CB4
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 08:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 784173059FFC
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 06:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 502C9366064;
	Wed,  8 Apr 2026 06:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oX6YTCsC"
X-Original-To: io-uring@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013031.outbound.protection.outlook.com [40.93.196.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054CE366062;
	Wed,  8 Apr 2026 06:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775631275; cv=fail; b=cTLHF80m+k7QCzXpvrLJ3c5J3+6W36P6LBsgFp1VhQawF0ODtbQLtwqXefdgto++goYRBtttArqUFnXVT7GqD8ay4dHEnlGZL1RtGvSaYVQoc+tiH1LbSD34rYH/GxsqLEx6TaLqbswnHrfH9RPuKcwa8XI/qqW4teoKAEztMKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775631275; c=relaxed/simple;
	bh=UsxKP573jh2Vy+Tg2uSBSBszQtOVKvmmVqtYavvyp1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=udAMOCFdzl82ixLYxxCj+A+Mqt9wRYkWBjq5XX6WfaoSR3Nr71iBQbNPWofPbDbmoA6dzwdXQH8IXm4G1QNaSJ09Dj24IOEXseEOzZDvgZPfQKdalpCRxBG8Lme5Qw1O8jtjKboUHs/w9jscwbEPZv30Nn5guHRArXg+ebltHVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oX6YTCsC; arc=fail smtp.client-ip=40.93.196.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ggWRQZMnl9Ih8ZCV6V+Gpztbt9CpaSeZSKWIRzQxUQdll6UTO+uNNQS1ay7b3oGRGrVrHTYRzZk+03RTq2uHnTC/exc333T5asU9dl3EBXTHFcmf3J0UMUSTxyLEsNQxRTKMv73Xd7HtIsJo5tk+xcQPIS9fOpIafp57AEyH55owLlnxCQ+JyF9qcXkyqrZX+JVHdkU4mCzJ0OmUtPK2R9XGZgdbBrx5P7D+052pyay/uixEuK+uAy9XMUmjIuSDOMgyiVT5zzHB+B/go5wh2xR65wycV7LK2MDOdwndccgKFQW1z6EkfPnCp+ZnU6MaqhycI8Jhbh9rtRjGCQ2skQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4cfIpFDPbsM47dnFIlGRurpF0kuARXygaGIVwAwQsK0=;
 b=KKufNZMNifr9pezTfDyhndtcY8nh8DPCn0/wI+yYhPj+uruQftTbQAL5uFRp74UOXedV15sGlIIfaVpBi89oHbxoATAUJcDdWKj02ZRYcFBbc9g99eB2JJIxKLpYDWg0fz6IvncYewx1uCpAMMBOIPr2Igd5RIogLnIaLTvbEhn4G37O2AqXlUZwh6gFieoJz/XhmMZ411J5CR55znGMlgdOF8zhYhsUfmLocBaF9r679wNW5QYf7JEc2SBuMUrRjgzYahCtpE/Q9WlhvM7JI6eGwse3ZpnCF10Pekl9P/Usbcp8r4Mn8JCzcGcVvwtzvdQA6xbLM5whh0x1gbXFPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cfIpFDPbsM47dnFIlGRurpF0kuARXygaGIVwAwQsK0=;
 b=oX6YTCsCICr1mbsstUSqG4NquSj4XlIHTy9r3Ru+qFIFPjzdy5ppBhNCU3rFQsNm/VfIuraz1Fv9TR1ytAwFIAoE9OzI3ROx0xPwSqPyrvaRXjA2EWe8QmPMLfTB0WWYTxFpXNNBWGcvjht6HRbA0GgmaHwvRWQ2KJjEQEmKsdkU+QXhGyKnww2VXc4LYxQolWENhxX/yuBnv6ioyAKUTiX+cz3FW2oogzgik9UrbDy+vDReyEbOj/LGahvgdR5/3F81dSRuJScoLsGMTMfNp2QFBc9Z3FEUVD3w5ad2v55/yElg7Yt+W3tC3zS6eMRZ4UjpYTtjqF1fUgf1HC2cng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHXPR12MB999244.namprd12.prod.outlook.com
 (2603:10b6:610:2fc::17) by LV3PR12MB9412.namprd12.prod.outlook.com
 (2603:10b6:408:211::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 8 Apr
 2026 06:54:29 +0000
Received: from CHXPR12MB999244.namprd12.prod.outlook.com
 ([fe80::168f:599c:f74d:7688]) by CHXPR12MB999244.namprd12.prod.outlook.com
 ([fe80::168f:599c:f74d:7688%5]) with mapi id 15.20.9769.018; Wed, 8 Apr 2026
 06:54:29 +0000
From: KobaK <kobak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Koba Ko <kobak@nvidia.com>
Subject: [PATCH 3/3] io_uring/zcrx: fix resource leak and double-free hazard in io_import_umem
Date: Wed,  8 Apr 2026 14:54:08 +0800
Message-ID: <20260408065408.2017967-4-kobak@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260408065408.2017967-1-kobak@nvidia.com>
References: <20260408065408.2017967-1-kobak@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY4PR01CA0023.jpnprd01.prod.outlook.com
 (2603:1096:405:2bf::16) To CHXPR12MB999244.namprd12.prod.outlook.com
 (2603:10b6:610:2fc::17)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHXPR12MB999244:EE_|LV3PR12MB9412:EE_
X-MS-Office365-Filtering-Correlation-Id: c6b508f6-7bd6-4cd1-54fc-08de953bae23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	2eQ1cHlXS8E065luHIUpr7i0Pz3oVl6ZWvfk/T/jYJjxbF6AoCnasXd95y2TQnPhlEn9IhybB47WhMB3qJSXCLBhgkTc6VVbf4OB37jF0uTt0MZntFFyfGHS7LsFb0M2u51BCTYrDW3q1mrXwRxuUy8DxZ3JtxuYVbBaVAZHyxLIs5RLrlGjds9jVa/s9F4BT4tnmDykmiwFIKgPa51J5HaT+wAYXGeecY7pEa8c86cBr3QzmFM8w7clNt32z+nMLQyp0n+kouNfIzcy3s9q8xrZ1DMHEJmYjcm8ZQpV2y5LPjc50NIWBO2wsClX2NL8XjesWev+nTPZwvwywsYQ5zn9w7RJkjooVF4Q+WitDN/39HamvXQ8T4UTnIZTndOI+w3V3Dm2LJeuR5fBTV47Tqldmi0w/YVaspQT9O4COMjkepSJET91lvGbrSx5NaR80wTvFbGpL395Q3Sw7hUfFkmBKSkIcZEjmdtcJmwYdMky2UBL28fh04oNxhKS3jKmeXdMiNxvypKy8oOOP9uqdSKC0A39WW3Iv5m+14TvGSiAtTBNZCiT+SZpWWxug43etUBwj5WFCLisxhSL0uj9rh09U/ZrLSZ5Ae/X+h8DzhwCTw6Vyc4fSgwK+7O9ovsAXhRPOzf7ioTPu0nXWD/8qfmSch3XlRudBlCwu6TMMVWx7CyBF9ONmHuUBRRupFQuOLOmxCOcqUePX8BtVmAn0f7XVJfsKzQdlXgFaoQftZ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHXPR12MB999244.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Sxiuaj+TakAc5R1xHr1qkrzM763Evt1Q6qv/I725evSKPiVMKSfJrEWOgFHR?=
 =?us-ascii?Q?E0Z71Z8aTmoOz3I2j6850M+kRK1D0JPQEEkSwkcoq4oMoxX+RrDtJN8mPULP?=
 =?us-ascii?Q?naI+0zgzumXV7qtsw1qV+T3gENN8wT5LttWEUV/WBuvdqKM6cCoxvssUioWd?=
 =?us-ascii?Q?8lCKtxZ/aECbFCYyGKtbk8e5ydWAIPLlYu1dBOEhyy0hGiIv/CahRMX6fGlz?=
 =?us-ascii?Q?iKCa3V2oiJGHifcCC8p9dAC8AIrwbdt4nUeu8YemdqVINRVcq529HvDwEVTv?=
 =?us-ascii?Q?rcyVw3W9x8RMj3Jg59GDPmjLT0Aya1F1bssRnX4p0Tyn/Q5CN375zgrUahSk?=
 =?us-ascii?Q?7N/JpyxZp1GNiGgBwX5iqrTxw7/iTOqZoSkt8ILC8Z1Wn+vXTucKCFHpGd+Z?=
 =?us-ascii?Q?WM2lt//vXTCtidN/U5znSc1ZhhvmjZJ7rbEDBB2TErG+OUo9KIJ1zn34iex5?=
 =?us-ascii?Q?WTjUd4Ubj9SCZ5KDVHs84hhuywKB1/ZiSHdt9yjUfdpr6YYGAcK5dmjzaw+P?=
 =?us-ascii?Q?EPIpX/zb4/QlkPF9elHhTeja6EHEEfP5LJSDxKWIws/LcZOazhsl+5JPFBwO?=
 =?us-ascii?Q?HRoy5a1VscOU9ZqFHKQq4QOuUymElwDJggZ9NaArLngIAJ3E8ttPrODChPaR?=
 =?us-ascii?Q?Cl1iZ0rcuLz7MD5lTKwxYDPZNRR2+zMj08jsX440Mph0d/uYdSneEX42FZTQ?=
 =?us-ascii?Q?Yzu8Y+uprwwXOOYz0KSPF4RBPvnXHseDAWhdY1v3Vu0eO9V9xNkShhucYucM?=
 =?us-ascii?Q?X7CyQhhr0vHdwGUPvHeu3PzZnvHRPBDBgL+L1V/cA5JEqh5MvXE4mIN7eyhD?=
 =?us-ascii?Q?s/EUA1gpKXp6jDVMQNWA9kbjWTh/MDmxcNJIRiJFV1UJcg67YLhmsPriocPk?=
 =?us-ascii?Q?dMRELI/dp7NbhamGwJ+w0sU62x4mtYYSZGG6hAppTuDceRNnNAEtpB+Hc05X?=
 =?us-ascii?Q?Whiu4fEMuf5O5a+wFymqJcyfTyBUbeeavFZNmDJKBkI/Xz/sgQpCEiytIn77?=
 =?us-ascii?Q?AuUVgP/eEl4mWs4FSEROSXp7imWuZILpk81Htodk1tpiZyrzXjN3YE4M5Ri8?=
 =?us-ascii?Q?N7OICpmJM0hDjHMuBsEnCl8YqKN1A+lu+/oRtdg8c+fniuxJsPfkFAOqpG/9?=
 =?us-ascii?Q?Zd5ApBY+KcGNIzxbHxL1fEU3qNnLZIJS4sDS3LNgw5okEBaBVFTyYIc1D+yA?=
 =?us-ascii?Q?y5/ydvyPySE3ZF6p03DQ4uXsrw0SQ5nocvYXa189xTPr199+C7C2CrCxCJsY?=
 =?us-ascii?Q?YRchQ1ZXDyS/I8fNYCLelC+9xD6XQQBY+AaCIVdVmajPNIxHPNHSDPKVyn8k?=
 =?us-ascii?Q?EzwwQKlEyblr51h84yyUfYNtXSUdmCCAL6eVDU5cF/0e5DYykPjranmcrO3M?=
 =?us-ascii?Q?cqWgqGM3bIvP9SKU78SbOKGek/4KGRSUx+eoJbCEXDdzRkFeuf40gO7DM5Nl?=
 =?us-ascii?Q?wZ5wMQrJAPH8rlo52lE8DOAFlEA0KGKbrlkqBrccyHtQgouA7vdCF8AfZwM3?=
 =?us-ascii?Q?8dCrw1oIoSfcAbL9jejfBzbdKw9+vzDeh2rNHBslWWl7AlhAcWzo6Pl/KoWP?=
 =?us-ascii?Q?TRp5H5XvF2kgQPRdGK56VZPpUoma3JD8Dki9Pt6q7Vq+aFtMJwMUjDsJNyKd?=
 =?us-ascii?Q?GwsXA6cev8d/hbzyuDjSXdEuE6fDhC1CQFjTmLtk1LiVl6IRWs/bAT3f5NCJ?=
 =?us-ascii?Q?CBksTtM4eJ9ZBn9h1CFaE2LM2IuT3LPPZ5PhxH/183vlWnNuDXHw3UORIrY+?=
 =?us-ascii?Q?yIiB7OUdmw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b508f6-7bd6-4cd1-54fc-08de953bae23
X-MS-Exchange-CrossTenant-AuthSource: CHXPR12MB999244.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 06:54:29.0898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Lnl1tZWuaf5+vneId0EXpkaf8L1BZ9bKMCs25eMTEQV330assy4iurL10goqj8WZkDADCi+3DuJfigdJq3VEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9412
X-Spamd-Result: default: False [2.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	TAGGED_FROM(0.00)[bounces-12977-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kobak@nvidia.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:email,nvidia.com:mid]
X-Rspamd-Queue-Id: D2C093B7CB4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Koba Ko <kobak@nvidia.com>

io_import_umem() has two problems:

1. When io_account_mem() fails, the function returns an error but leaves
   live pinned pages and sg_table in the mem struct without cleaning them
   up. The caller happens to handle this today via io_zcrx_free_area() ->
   io_release_area_mem(), but the contract is fragile.

2. io_release_area_mem() doesn't NULL out mem->pages after kvfree(),
   making it unsafe to call twice. Since io_zcrx_free_area() always
   calls it during teardown, any earlier cleanup call would cause a
   double-free.

Fix both: populate mem fields before io_account_mem() so
io_release_area_mem() can do a proper cleanup on failure, and add
mem->pages = NULL in io_release_area_mem() to make it idempotent.

Fixes: 262ab205180d2 ("io_uring/zcrx: account area memory")
Signed-off-by: Koba Ko <kobak@nvidia.com>
---
 io_uring/zcrx.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 62d693287457f..c9ed1139c7bcd 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -188,6 +188,8 @@ static unsigned long io_count_account_pages(struct page **pages, unsigned nr_pag
 	return res;
 }
 
+static void io_release_area_mem(struct io_zcrx_mem *mem);
+
 static int io_import_umem(struct io_zcrx_ifq *ifq,
 			  struct io_zcrx_mem *mem,
 			  struct io_uring_zcrx_area_reg *area_reg)
@@ -213,16 +215,20 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 		return ret;
 	}
 
-	mem->account_pages = io_count_account_pages(pages, nr_pages);
-	ret = io_account_mem(ifq->user, ifq->mm_account, mem->account_pages);
-	if (ret < 0)
-		mem->account_pages = 0;
-
 	mem->sgt = &mem->page_sg_table;
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
-	return ret;
+
+	mem->account_pages = io_count_account_pages(pages, nr_pages);
+	ret = io_account_mem(ifq->user, ifq->mm_account, mem->account_pages);
+	if (ret < 0) {
+		mem->account_pages = 0;
+		io_release_area_mem(mem);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void io_release_area_mem(struct io_zcrx_mem *mem)
@@ -236,6 +242,7 @@ static void io_release_area_mem(struct io_zcrx_mem *mem)
 		sg_free_table(mem->sgt);
 		mem->sgt = NULL;
 		kvfree(mem->pages);
+		mem->pages = NULL;
 	}
 }
 
-- 
2.43.0


