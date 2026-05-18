Return-Path: <io-uring+bounces-13394-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oJNCGzsGC2rt/QQAu9opvQ
	(envelope-from <io-uring+bounces-13394-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:29:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D83D556CA99
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 14:29:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CE2BF3036736
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE33E4048A0;
	Mon, 18 May 2026 12:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4YYm0Vt1"
X-Original-To: io-uring@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012069.outbound.protection.outlook.com [40.107.200.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B93F404891;
	Mon, 18 May 2026 12:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779106991; cv=fail; b=AIRGycP8yqx6AbOzQeV8T2Gr7jJNV9+/Ua4JOhkJgDZtAv54L9Z9HCeyV1JUulG8nzREAg1RDQ3ni/qSRS4NUM4KFiYFWjW8eeF+Ode+RFSxnbCEPIcRC1IUKN+e/xZ6VeD4BzckbuK3f5ovWTmh2bhTrCNaq7WlRJdKxLuYc9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779106991; c=relaxed/simple;
	bh=Pf76L/llWnTdBEPP9ABNfQ7nGEgNNhqBP/6GZarGC18=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KTSPR8zAncmL6Pf8vs08J/KcGTeY30ot3q/daToxHcqDT2oeZBFR323H/JZU8KelDnZDtvtKekIDTqTvbIX8piilz4i0gbbVhxlMsBu5GUAK7QZr/SlrYkPTOiT2jXWZ2dnFQWQMXVjG/s6mN9KXHhc2mzhcAM9h5XtdgyHnAxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4YYm0Vt1; arc=fail smtp.client-ip=40.107.200.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPEHvn87lT7w6/eE6EMyu9WUN2tG71aIEsKJs7IC5DOBjiAnSSACPwEk0n2wU6J8qnvNYPo3a3qDqyAbuLBMWwWz3rAa0ZFQloFSv6quJa8QSpjpafKA9kd0qxjJzI7AUY9JlSTLlOkCvIrPAhe6TQNzbZbfGZRBfnAn1YS3u749m8K4Qf8saAztu7V+Bswj11tbtj3vtOFWE5/L0EpHWfwBAOFJEh1JMmOJd4/mS5bO24YBq++fIAdawPGOaBZjkBTQFBIObuJCH8MbS0mB6TDIp2GkQperYmFVUyJgrc2anjVVjtGQQ5Hm8wBuwbtaKo01LHCQlWlz7a+vlpb5mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LP/t9B09zoVMiHpQnSHUHFVZc7IbgwlnP18Rg5g5whY=;
 b=Y5jSzcNn7TbL5oBJ3BptBU/45eLLcAHF8VTsETr6DJbSVrYCn9dtHAp8OmGE9DIiL38CkGa7sTJRxG291UebnQtOovhXJ4vJJfZNVUk8tKMlnmR8YhEznkQ5TQqlybodQN5CmjFtERNyUwk5puXK6GfTUZY7cqKpdmP17LBQqBRBg4Grn+qBcG+DL/vqxNyQD5g5B4HbJmLxvRiHV2JzPvRtIcfahVZF5lnca2GWPhDKQHGwRT2UNOFX+YNmcTvEzyFuF9FGD4T/Pkw37gkY4f9v8toE10adAINayDhWBiozns6MWCrxlgrjyrsaHYRxAb//ZQYw4I8BCP7bN5D4Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LP/t9B09zoVMiHpQnSHUHFVZc7IbgwlnP18Rg5g5whY=;
 b=4YYm0Vt13P8XrqmE0tv1R1S24EB5qluBn5KfzTtIHqnVHXibBJhLv0+bVdH7jDCmCp3nFe1REyKEfjTD8Wp7aHtCla3fSgRFAMuQvIGkLUYg/b+WE/1ap7PVMo8ubj/4l9lMoPpaNNFmVYL/wxMBfSZxGVGO0flcfW6OIPRiCfo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA5PPFEC2853BA9.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.16; Mon, 18 May
 2026 12:23:06 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 12:23:05 +0000
Message-ID: <df697a76-c700-4908-ac08-a47ad07e0796@amd.com>
Date: Mon, 18 May 2026 14:22:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] block: introduce dma map backed bio type
To: Pavel Begunkov <asml.silence@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Nitesh Shetty <nj.shetty@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
 <646ecd6fde8d9e146cb051efb514deb27ce3883e.1777475843.git.asml.silence@gmail.com>
 <20260513081929.GD5477@lst.de>
 <24833f76-2289-4859-86d1-9215b11a1258@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <24833f76-2289-4859-86d1-9215b11a1258@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0162.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::9) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA5PPFEC2853BA9:EE_
X-MS-Office365-Filtering-Correlation-Id: 45f1adb1-4b12-40b2-2af5-08deb4d83699
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|22082099003|18002099003|56012099003|11063799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	c5aJkkXEkZVsBeRewdvK/rsYZ2SSoyyiUq0q5OnByEaKqL+/6STlRDM4HGjW/KkvQuHXpyd1EUOryAeZN+R7zwKErRAir/7zz60rjAQrEMcjsQa3otykv/yQk1epfrlr4RGbGVdtBMoudv0DVKs61q6ZKYomWc42AKZG+dgGTXOuQ6S3He0U2HUArAIcMwGDgedUvK/tx4qaOVRy1t3lZ2gItHUZq04FvUeFscC3d0td6OECU4elEpJmKa8YBN5k8lTIdtYe8oHW31ap0FEOmdGSj0yrTxhpfQakj8i/FtTDT/VPDo+WJetkYswaJzrPd8l5CGkf2NgKS98dt2/wZlNoL3kmDMVJU9AkmVFYwYeE8l+dMPgfGx7ct4JVo+xGVppAJKM3SfMvxljUuYHmpGh8vM3mKbTrwVgCVJrhH0087zxCz303m2TRP5XRnm5iXXaNhxlLo3SX7ZHCqIpPvBBQUxn0HYTPNELyxqw6dYV99M5NQTafjXs64gS7rmx40cLVMmIbpn3Poo+q05jQGCYcFVn9zrL2T7+WiacdcNKMfBRL8TMu7LdEA0W2LKpdKr/xxvmMoaQew0alvOt/YbD2RxKNhlglcOporo6R5OlskZyBpN/FzZQ8++D+vEWpBEy3bzSJDCfQy3UBaOywHU5ly/21jM8l4Jor9DrQ3SO2c9rw9tDocgZ05DCPlNxg
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003)(11063799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTlMMFpXUTNyUVBoblRpSlpnL3U4NXNyOU4xRlpnVDRVeEIyZkJGWC9pdEhB?=
 =?utf-8?B?VDZEWUsyd1BiNlE3NE0wK1N5NmJENFk5QktrUDJuVUlBR2dJd1J3eEtaa2lm?=
 =?utf-8?B?aGxLNFUzTGRyR2tqRXhETWUvUzBsMjNLYWFhaFRJK1dkZkNGdENjSEQxMG94?=
 =?utf-8?B?UldVNWM4SnZta3Zjb0hqNXlMclJWKzUxbHk5bnlOdDBiSzEzQW9uS2VPKzhw?=
 =?utf-8?B?MkQzMTFFY0MrdUc3VDBXU1NYUkN3MUZpVVZSQ0gwVFh2UmUyV3BRdGNTUDFH?=
 =?utf-8?B?dDEwd095c1VHMVN4c0k1bm1BczBURkE3VFhSajdYMWh5dXBFVG1JKzhLZWpr?=
 =?utf-8?B?VHE5STZMVjA4Z21yaGJDMUJtbVhjL25DcHphWmIzRlpJVUYxQVNGQ3MvZGlP?=
 =?utf-8?B?bkVRNWdKdXRkUEdRN09ZZlRNemxGUm00eldiLzJoVCtraksvR1p2bjhMMWZE?=
 =?utf-8?B?SW9nUzJzdzQvb3FvTlpqZ3VDbE9EeitpalJlNmJtMXhkY0UwOWpCVWNOOS81?=
 =?utf-8?B?Y1IvbDRzQnVkZk5XQ1dJNUNWYnJ4Um5FSm1oOS9RSmV6WExNM3l6eHdVUVFG?=
 =?utf-8?B?ZGVucjB4TUJzcm5TdFVURE5KaXdMeFI0eVAyLzhHbkZpZHZHdk90N2EyS0p1?=
 =?utf-8?B?UmEzeGlHUzNzZ3dsOXRFRjNDa25tUUtMeFFjR1laSWxpdFVWbjNoaTNXcWpI?=
 =?utf-8?B?SjM4NjdHZVpoL0k5b2plbnd2dllQOEJIRWhoRE94TlpGcW02MXdSQlE2QVQ0?=
 =?utf-8?B?SnQ4NVJGc0lvcDNIR2FmQ0h5aGpWRFpnZHpwSklscGZoUVZBUGUrQ3VFQnRh?=
 =?utf-8?B?NjhsQnZ3TkhVOGIwVHdKUXFxRU0xT2RZdG9ncUszM0JyMEUwemJDYTl6aHRB?=
 =?utf-8?B?RE85MTRFV1EvQmt5U1NuM0o2RGQvS0c2WXVsNVN2VlBFcWJYQjl5aUdYbk0v?=
 =?utf-8?B?SE5HUlhSN2xMd2M0ZDhzaFc0bFhleDNxNmVHdlBISXM5OGE2RENrbzNNRStN?=
 =?utf-8?B?VWJDNVd2MVZGVEhwTS9VRmcxWklBV0NEYXFjSlVqbHd0eW9sUTZxNUlKczYv?=
 =?utf-8?B?TnAyNnF0VlErYTd2eWJhMWtJOW9hLzFMdjlFSXY3ZUlnNnpTSlc2bEtNUkJG?=
 =?utf-8?B?V2xtMkh0MXhoY05naXlTVFU0aEI5dUhSaEFLbDZSOU55SUNVZXFlZE5OdUZP?=
 =?utf-8?B?c1dxOUt6S0FXelkrbURRTDZ5dDRjdlQ1b1RSSE8yUmtEaUpuTTNJcmw1Mmx0?=
 =?utf-8?B?TXRDYUpJbVEvZnpqMWxlWEtjdVRoVWplTmdKclFTR1haUDJCUld3S1hJTkQ2?=
 =?utf-8?B?M1lsK01VOWQrbitIS0lOVEVPNDQyMlI0VEs4eWJEVyszMlEvYnpqNk4vVXVx?=
 =?utf-8?B?ZkRpV3E3SUVrczJZM2h0WTRxSlVQcmswdk1VL2FSRUx0eVFuOE96VkdDMGRs?=
 =?utf-8?B?c0ZubkxWTmYvK0VpZ3dhZEwvWlQxVUxYdEZvUGtWaEI3MW01ZmNWcy8yUzB2?=
 =?utf-8?B?VW5wc3QzbUpqNzN0N3J6WVRoYS91MGVzTDRaNW9yWDdWUm0xeDljYVFvdkJq?=
 =?utf-8?B?N01tNEdCeVZ4MnJDUkNFcXJKKzJPZDJqekhjVml0MWVEZSs0enl3dW9iVXQz?=
 =?utf-8?B?aUkraGhYVUpJNk1BNVQwUHdrRWNFYUsxVFpJVll4QWxjYytMLzBtK2lIMjVs?=
 =?utf-8?B?NFlhTU53YnlVcjRZYzVEbnlxajFnSTkxTjIvZlp4WEtLeFVieElVRHlpWGp3?=
 =?utf-8?B?OUsrZ0VaaGNQamdGalRsN3VhbXUyMmliSnRlRFFxV1JMN3IvOXBIOXZLeVR0?=
 =?utf-8?B?V3hyMnJUS3JKNEtLV3ZXbnZHR2U2aSt5RUlGL1JvNTdkeHBuWUdabmQxc3R0?=
 =?utf-8?B?YmdUSkxXVlJLMXBxS0NjS0QzYTJxNjdmMXNqMEVRUUdZRzE4QWg3YndZSXFo?=
 =?utf-8?B?RGpJOEJlWVptN1AvWGJ2SG5mS2Jrdk9pMlY2Y3lBZ1VORzdpWS9Xa3hXSjdj?=
 =?utf-8?B?Qjc4R1AvTVE3SHlLL3dDUmRFTm50UDhrVlhuS1IvZkJsOGVVU3VKMWp3V0dh?=
 =?utf-8?B?WStOc0JRanVoQ09NVFJaVFhUZ25wOHJsRTg3eTJ0dVgwOXRaZFh1cHQ1RWpP?=
 =?utf-8?B?SmRWZDdrb1RtK1NNQjYvUW5Ma291SWtQb0pBZjZRWno5eHdwMFMxRTZUNjBj?=
 =?utf-8?B?TVhFV0lzV092NHlsaEZCbDd5Vk5vSmE1Q2Y2TDkwbVAyMWROVlYyc3gwMlFh?=
 =?utf-8?B?alVxMldlZVJMQTRURmpxcW5La0tYd3RCd3R2b1BSU3I1MCtPdVpmR2txalJF?=
 =?utf-8?Q?5rqQZeVVhidv5FY1mz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f1adb1-4b12-40b2-2af5-08deb4d83699
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 12:23:05.7014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WsjQ8f2zBS5HENcJg3BQedENvqiLG177GgFQXBVXSaaV5GGqPIZx8quYSXn+mwO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFEC2853BA9
X-Rspamd-Queue-Id: D83D556CA99
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13394-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,lst.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[christian.koenig@amd.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 5/18/26 12:29, Pavel Begunkov wrote:
> On 5/13/26 09:19, Christoph Hellwig wrote:
>>> +    if (!bio_flagged(bio_src, BIO_DMABUF_MAP)) {
>>> +        bio->bi_io_vec = bio_src->bi_io_vec;
>>> +    } else {
>>> +        bio->dmabuf_map = bio_src->dmabuf_map;
>>> +        bio_set_flag(bio, BIO_DMABUF_MAP);
>>> +    }
>>
>> This is backwards, please avoid pointless negations:
> 
> I can flip it, but compilers tend to prefer the true branch. E.g. this
> 
> if (cond) A; else B;
> C;
> 
> can get compiled into:
> 
> jmpcc cond B
> A: ...
> C:
> return;
> B: ...
> jmp C;

When that is really a performance critical path then you can use the likely() and unlikely() macros to give the compiler the hint which one to prefer.

What could be useful is to have the true path for the more common and the false path for the less common case for documentation purposes, but in that case I would expected some code comments as well.

Regards,
Christian.

>  
> 
>>
>>     if (bio_flagged(bio_src, BIO_DMABUF_MAP)) {
>>         bio->dmabuf_map = bio_src->dmabuf_map;
>>         bio_set_flag(bio, BIO_DMABUF_MAP);
>>     } else {
>>         bio->bi_io_vec = bio_src->bi_io_vec;
>>     }
>>
>>> +    if (bio_flagged(bio, BIO_DMABUF_MAP)) {
>>> +        nsegs = 1;
>>> +
>>> +        if ((bio->bi_iter.bi_bvec_done & lim->dma_alignment) ||
>>> +            (bio->bi_iter.bi_size & len_align_mask))
>>> +            return -EINVAL;
>>> +        if (bio->bi_iter.bi_size > max_bytes) {
>>> +            bytes = max_bytes;
>>> +            goto split;
>>> +        }
>>
>> Please add a comment explaining why nsegs is always 1 here.
> 
> 
> 
>>
>>> @@ -424,7 +424,8 @@ static inline struct bio *__bio_split_to_limits(struct bio *bio,
>>>       switch (bio_op(bio)) {
>>>       case REQ_OP_READ:
>>>       case REQ_OP_WRITE:
>>> -        if (bio_may_need_split(bio, lim))
>>> +        if (bio_may_need_split(bio, lim) ||
>>> +            bio_flagged(bio, BIO_DMABUF_MAP))
>>>               return bio_split_rw(bio, lim, nr_segs);
>>
>> The BIO_DMABUF_MAP check should go into bio_may_need_split.
> 
> Ok
>>> +static inline void bio_advance_iter_dmabuf_map(struct bvec_iter *iter,
>>> +                           unsigned int bytes)
>>> +{
>>> +    iter->bi_bvec_done += bytes;
>>> +    iter->bi_size -= bytes;
>>> +}
>>> +
>>>   static inline void bio_advance_iter(const struct bio *bio,
>>>                       struct bvec_iter *iter, unsigned int bytes)
>>>   {
>>>       iter->bi_sector += bytes >> 9;
>>>   -    if (bio_no_advance_iter(bio))
>>> +    if (bio_no_advance_iter(bio)) {
>>>           iter->bi_size -= bytes;
>>> -    else
>>> +    } else if (bio_flagged(bio, BIO_DMABUF_MAP)) {
>>> +        bio_advance_iter_dmabuf_map(iter, bytes);
>>
>> This is a bit of a mess.  You're using bi_bvec_done for something that
>> is not bvec_done, which makes the naming very confusing.  That is even
>> more confusing than the existing usage, which isn't great.  Also we
>> add yet another conditional to heavily inlined code.  I'd suggest
>> the following:
>>
>>   - add a prep patch to rename bi_bvec_done to bi_offset, as even for
>>     the existing usage it is the offset into the current bio_vec as
>>     much as it is the count of byes done, as those must be the same
>>     and it is used both ways
>>   - add a prep patch to also increase bi_offset for bio_no_advance_iter.
>>     It is not actually use there, but incrementing it is harmless and
>>     this will avoid a new special case
>>   - please also documet this new usage in the commet in struct bvec_iter.
>>   - then just add the dma buf mapping to the bio_no_advance_iter condition
> 
> I'll take a look
> 
>>   - figure out what to do about dm_bio_rewind_iter, which pokes into these
>>     things that really should be block layer internal
> 
> Need to check what that is, but doesn't implement the interface and
> is not supposed to ever see the dmabuf iterator.
> 
>>>   }
>>> @@ -391,7 +403,7 @@ static inline void bio_wouldblock_error(struct bio *bio)
>>>    */
>>>   static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
>>>   {
>>> -    if (iov_iter_is_bvec(iter))
>>> +    if (iov_iter_is_bvec(iter) || iov_iter_is_dmabuf_map(iter))
>>>           return 0;
>>>       return iov_iter_npages(iter, max_segs);
>>>   }
>>
>> Please update the comment for this helper.
>>
>>> @@ -322,6 +327,7 @@ enum {
>>>       BIO_REMAPPED,
>>>       BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
>>>       BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
>>> +    BIO_DMABUF_MAP, /* Using premmaped dma buffers */
>>
>> Shouldn't this be a REQ_ flag as we should never mix and match bios with
>> and without this flag in a single request?
> 
> Do you mean adding both and propagating it from bio to req? submit_bio()
> takes a bio, so we still need to set it there before it reaches blk-mq.
> And there might be bio-based drivers using it in the future.
> 


