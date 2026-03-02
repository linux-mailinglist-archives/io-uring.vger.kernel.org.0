Return-Path: <io-uring+bounces-12510-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGfKHSyupWleEQAAu9opvQ
	(envelope-from <io-uring+bounces-12510-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 16:35:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F5261DBF0F
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 16:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C11603039F51
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 15:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C38541162B;
	Mon,  2 Mar 2026 15:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aUc+HkfC"
X-Original-To: io-uring@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012036.outbound.protection.outlook.com [40.93.195.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2712D411636;
	Mon,  2 Mar 2026 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772465552; cv=fail; b=UmmQZvgAW7wJkJE0D8crZ/miA/o3rlQbVf7f/S6zv7iuXKUbnb6GGeaOaGB+6YP9K67KU68OEmIJZQhKfVyv28k5wZJBDqVGIQzncv9BUtzqNfncPz7AjiulIWWzBb7lkIWk1aMbK6elv4Ti0h020I/zk9aq/uLKlo5/DHNh3dE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772465552; c=relaxed/simple;
	bh=34YwOIwNXsnHClQVeqwEjwx08hHBVdG0O0kN/NDTj1c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IqF6ofVVekUcuvRrete249nrvXthGFP47N2oyeqW7NnlKL12a2NGPFdfc5bqpmiW/X7ADgXa1HbqeGCBVcDBRopLu3ZHtiWdJabegRWk7xs1L6fPqHvEFLofFVylI0inQ3W8GfjJ1JDw+TqjtUYCd1Sz+k+XZJoR8JLVg8JMGBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aUc+HkfC; arc=fail smtp.client-ip=40.93.195.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T92ldqNW9fJBvRZ+3KvFKYfLs2kfkmy1EglWHAV33YfJcxIl12gamWojajF7tvB2rfW4Kf+aBtgexJ57NUmW4f7xYb/D27QrJTEjPz8DZ7QnCzrIFQ4aZmLhDQKi8M3C89I6N6cdACkY73JPJA2K3Mv70nTLPw839ybqe/u9hfnY3Ukr0OPd1NPblrAZgbVt/Q2HUbZ851cbdIkIDgB39s/36LpYHZdv65MwneH4casIXx2SgE0erurfZCbf1ubzPCZOs64hPDGJSuMTTzD6kpwIzyV+51OnshwkPOLJJAi5L69nxtwT6A4MXivGW7C+4gxPNbnO4HnVSAnveZrDIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oXfny+DhSMzl429SKBqlLLSlPmYjzZOoSXLGT17JD04=;
 b=Ow1Ct2+msX1aSPpyH+mPTjlj0O2mC5R/77SmD8AA/sdvv+3WXLK/f7yhzhzU5HFV2mQOAxSEc46mvpqzk5M01YUBR2Zu1RUZv56rRY6oXEC3W0ruk7ml05Y0sw8mX3zJM5CddRMfaAPWbjES4+ZRROU3I2/mvXIkxzfeeu3XhtVpCz51l2nPuu/cgOWo6KrcmOaGbmaJm5N6Fq8/fBPa5WNEQ5fDuIOlRGMj6tC0DlAZEPPzqs1Snn3O0v0mgA+Kyiu0MkGRqcJAfJLKg5IERUnAzBJ/WMySgfc5Nm15SKKJbqNMdXHaYKh/agY5vpbXLPWZvSiiWyKpC/ADtZrnJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXfny+DhSMzl429SKBqlLLSlPmYjzZOoSXLGT17JD04=;
 b=aUc+HkfC8k59xH75ymDL5v0QVAlIuKvVFZksVw+FFKA5QhrcFf4eZUBNq5p3bwIHIayFHcxum9aCZ/XDMVO5uoyuYydaJZjUc/PVvI3hffl4NRJQYXRpONmgubHKxjpGhIxq0FSnnZknY4st6PO8RLcokMmikGjrnLUaNQOV9Ynmzygoa7QLjf39RGNdSE2SdPARmpOWJ1pBhUIQLbmUB7BHzc7j2t/jTopmCcI/oPgXgNWggHchwAOsDcSFLu7DZSc6GdDHn8Tacyr4gMfoBW7CQLn1alXeICiEyK2zRgno9U40pcT7KXozntecBGun4rp7KOBBckR3LzlobdpCJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by IA1PR12MB6529.namprd12.prod.outlook.com (2603:10b6:208:3a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 15:32:22 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 15:32:22 +0000
Message-ID: <d34aff53-171d-4deb-9f94-0a09ca0b3b93@nvidia.com>
Date: Mon, 2 Mar 2026 16:32:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/3] selftests: drv-net: iou-zcrx: wait for
 memory provider cleanup
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, dw@davidwei.uk, jdamato@fastly.com,
 asml.silence@gmail.com, io-uring@vger.kernel.org, shuah@kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260227171305.2848240-1-kuba@kernel.org>
 <20260227171305.2848240-2-kuba@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260227171305.2848240-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0280.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::16) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|IA1PR12MB6529:EE_
X-MS-Office365-Filtering-Correlation-Id: ae9017f2-5c37-4f6e-e88d-08de7870e51c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	0qs1acb/75H4dumHJ0ejEJjw3PhS7YONYn7lYr6VSrzRIg2eAm6N7HGcl5qidgPNs/fAFYDW1Fzutj3RiUI7pNp3Y7BHEORx6wJdnWyakyzOOzSikuk9zIWwzYRcu+hwMcHVVPq2lGp8ZNFdAyJdUIJFUUkVZbRkNUTjjZhQEcR41IDfXaiiAwlyi/VmXI9FYbJr1lSNlNNU/EOt6GH/0IWq6UrJHUQ+xqdMvam8CRiNxrOfMHxMDxES3tHuSt5XpFMFY9b2REz+m4GkXW1MoOAgvrRYuapebasRf1GFZi7bjB/xwC69WNV8frrpoee/0Q63xmMK6GwiJQ4LuhH5WDF67EI1pnYSJhDS0gKvMqCFeU+//B320n3EHdoeVfZXUYRrAnX/yjwnipx0JUnjlrapSvbYDAvYpXsNVyCmjh4ZSwfuHOeR19TJx8k5Kx6ILaB3z7V/z9BrKTSgUaRhDIh1G5rO7UPej+fV5G1bNyIud9QjyhzwOm6WrmlVBlxbP+umHJrMtfolQDwpJisRRzXrQytWyk6zy3sUxM7Gy+7ZgXz694apoIcnLTnj5YfUuoSfUUZNbMFoDYVj/5eTixmtR32VkjxmlJWzrpV94ETY5Dd52suuFZXF2/vV5c3Rn8p8nBzaPC2rYj4jx4HwJr6lSX3Mir/HCMqBSOpX9slhAfEf7C8AM3S8LfbNuavXWqHisSXUleM2ZKezNGMoYywJ5nkJJoBf3OPoGWq2Xxk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDNBVFRjOXhzc2VXdkU1bDVKUEJCazZ6N3MyTHdVWllEbUVTWGtpQ2w2eHVw?=
 =?utf-8?B?QXFOTlBlZ2JqYVFzcmovUXZ0SW9qRzNKOTFpZGlMVDQ1RlJPdUJiUXlUdnhy?=
 =?utf-8?B?emJRSkRYODhneWVZek9KWTFEdmFxSVc2OFloSHZkVmdLOElkS3dTY2NsNmUw?=
 =?utf-8?B?cng3cWRrQk5YeSswU1RNdWFzK3VENXF3VmJtRlk1K2xqQXN6eTgyQXY0N2VW?=
 =?utf-8?B?cmlhdE5hRWZyVi9nU1l6a1NmVmtBM3ZpNmxZdlhxdWpqYlF5UnBDNzcxUG5x?=
 =?utf-8?B?VGVsejNyblNuTzFJenVjZXBOeEpNQS9jZC95VjBkQXlCQzNEb29pT2p1dDJJ?=
 =?utf-8?B?MVNkWVAxTFh2WXZ5aUxkdVlrcTVrRGtrUVhnOW5TV2FpNHJKSmNVTzd5cmEv?=
 =?utf-8?B?UWtZZ2ZRZTZsZy9zWVprRTk3WjRka3dkaXByUXFUTmkyMWptZlFOcXFhZVhC?=
 =?utf-8?B?RExsb3ZMQzYvY1hQRmRTVlFSdUJUdmNlOFIxUVYvSkZIUFFBUkRnS2djMnNF?=
 =?utf-8?B?WnNmU2NtdUhtTWZCYzRWVU5oMlgzTVlCOHlJUTIzTElyYVRmNUpqcDc1YjRx?=
 =?utf-8?B?SXIvaDNmU0RrNjJYN3lFZlY1blhWVGcyZVVid2FEU1lvS1VsUjVvMjNUVHpY?=
 =?utf-8?B?K0dDRjArVVkxNHNFenA1Rzhyc1pKaVFjeUNYWFphNmphdVFWYWZxcGsvNzhQ?=
 =?utf-8?B?c1lpMk9PZmlXQkw4MWU2OFhkZ0NxZWRJY1JLR2F3b1dQOHBFdWY5NDhHa05p?=
 =?utf-8?B?eUtsbmpaTkdIZmNGcGFhZlRYU3dBMGVZYkE2TG1KcEd6M3RpODR0YlNDQjJ0?=
 =?utf-8?B?bEFuZmV3NUJFakJ2RXNJTTdxbGgrTXdyVkZwenNLNHNCRFZodm00T09WMU1q?=
 =?utf-8?B?WTFqdE9qMFZGempkN1NydEdKV05namVkRzBtemswd0VPS0xaNjVnUGFSRFN0?=
 =?utf-8?B?YlRSRVB3cTdRb0JuR0UvU1lOODEyUFgvTTY4SitYV2ZrOVB0RGhNSUcvbHcv?=
 =?utf-8?B?WklNdFFMVjFCMGJpdUx5NHh3Y0FDQTNqUVlzbzd5N3ZOczdaUC9TQ1NWemha?=
 =?utf-8?B?QnRKUUZKOUNNZHBncEpJMDlHMWRSZ1B2aFZVWFVNL3hxQkZvUm03cm1nY0U5?=
 =?utf-8?B?eUxkYW8xWlpaTm5MamtjS0k1elVVNmJBcnk3TkQ3ZnVra2RaeGhZRU1jTzJs?=
 =?utf-8?B?ZlB1bjQvazhnN0tkZUZmaTFzakFhSnFpK2sxQzluRkl0VVI3enFaSDY2OTBH?=
 =?utf-8?B?LzYzN28zM0FWcXF0bGJSSkhzUzA4dzdVQmNMZFcvcVIyMlFSRTRtbzJGTXNm?=
 =?utf-8?B?WGlpc1puUmwyeUtyd1pLRHBoR3B4eGgxYUNyN3E5VWlmN2NMc284d3ZTYXZN?=
 =?utf-8?B?OXdCQ2pjd0pSL2Y5RFBEZ1RDM0ptRFJldUVRRVhlK0FmcGxkbHZ0aEpLeTNR?=
 =?utf-8?B?YkJmTVNtRHRsMnUzRFZzVzIveW5rd1I1UGJrUk5RWnE3OFkxenU0MVU1NHB0?=
 =?utf-8?B?RzdmeXlzV2FwMTdRNGZDWU5QRmdSSDR5bUFCdk9ObjhzUlMvamgraG1ML21C?=
 =?utf-8?B?bk5lbFpJWEUzK1ZWWDlGeTQ1eEExK3RrcmF3cDZ1TmdybWhKTUtqWnlKZVl0?=
 =?utf-8?B?U3B4SEYvajFxZ09UZkJla3F4TjNKRDhCUUJna1FsWGl1Z1M2b3RsZG5SNWRj?=
 =?utf-8?B?S3I2azRodm92aVltVzBMVmxtemhyaWszL0JhYS9BMUtZbXA3SXkxMkU4OHU4?=
 =?utf-8?B?cHNsL1RnWTI1Z2dtTHVEU091OTl5dmJ3RmJmL0JKNC9JeDJBUjREUHBIR1cv?=
 =?utf-8?B?VUhzUm1xWHhPVDE4SGg2dURacGV3anRjR25qVlhxVkcweGg4cVhlS0JUMk1T?=
 =?utf-8?B?QUFrbkpBZms5Zk0rbzNJdHlPNlRVU00rblVlTkwwRldJN0YvZ2Z5QmhSRmZy?=
 =?utf-8?B?L3ZYcHpBRERMYzAzVzN6RGU5RlJTRWhLaFdkZmJXZlVqYmxOODNyMEF2TzFX?=
 =?utf-8?B?aGVZTms0NkVZUnkrZ2Rxek9CcjhMMytHNS8zZVQ5ZTNMb1F3OGpzSlNOM3lI?=
 =?utf-8?B?STVacTIwR0VPN1VHYVFjTjNOMzA1aW9zKzFaZkhKaklZeER3NnhTeUtzVGxs?=
 =?utf-8?B?M0JJTkhOVXhWL0gwelMzcCt1SmlVNFZwdWFJU2diQTZsdmR1d25FOWhjSitU?=
 =?utf-8?B?S0JyZEVISTlYbTVWa2dhcWNlZk1ucW1GTzgwc1dmT2trQllrcWZCNnA1bDcz?=
 =?utf-8?B?NUJVaWNPTU9QYit0eDQzeUxhYWxCUlF5WVlRVU1VYWlyMXpwdWRVa25DMXp1?=
 =?utf-8?B?NG44elVFSXBwaERnZDFiVk8vV2RzaW84UzB5dmZ6cHpoU3Y4emlpZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae9017f2-5c37-4f6e-e88d-08de7870e51c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:32:21.5275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pg2jNRP85vxprvfv4VxxuXfTqB/TyETmjNbQorZCMQUl5lgifAYs+b9QLr9Lwf2ySolIoX2E8lh8qOHmGz216Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6529
X-Rspamd-Queue-Id: 0F5261DBF0F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12510-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,davidwei.uk,fastly.com,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dtatulea@nvidia.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,davidwei.uk:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,fastly.com:email,nvidia.com:mid,nvidia.com:email]
X-Rspamd-Action: no action



On 27.02.26 18:13, Jakub Kicinski wrote:
> io_uring defers zcrx context teardown to the iou_exit workqueue.
> 
>   # ps aux | grep iou
>   ...    07:58   0:00 [kworker/u19:0-iou_exit]
>   ... 07:58   0:00 [kworker/u18:2-iou_exit]
> 
> When the test's receiver process exits, bkg() returns but the memory
> provider may still be attached to the rx queue. The subsequent defer()
> that restores tcp-data-split then fails:
> 
>   # Exception while handling defer / cleanup (callback 3 of 3)!
>   # Defer Exception| net.ynl.pyynl.lib.ynl.NlError:
>       Netlink error: can't disable tcp-data-split while device has
>                      memory provider enabled: Invalid argument
>   not ok 1 iou-zcrx.test_zcrx.single
> 
> Add a helper that polls netdev queue-get until no rx queue reports
> the io-uring memory provider attribute. Register it as a defer()
> just before tcp-data-split is restored as a "barrier".
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: shuah@kernel.org
> CC: dw@davidwei.uk
> CC: jdamato@fastly.com
> CC: linux-kselftest@vger.kernel.org
> ---

Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks,
Dragos

