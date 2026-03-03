Return-Path: <io-uring+bounces-12542-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IEa+JrqepmlqRwAAu9opvQ
	(envelope-from <io-uring+bounces-12542-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 09:41:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4506D1EAE76
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 09:41:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47F703038AE4
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2026 08:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0F4387572;
	Tue,  3 Mar 2026 08:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rS+WiODX"
X-Original-To: io-uring@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012045.outbound.protection.outlook.com [40.107.200.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B7838756E;
	Tue,  3 Mar 2026 08:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772527276; cv=fail; b=TYayhNCUbROIY73krTGCAGI7lUpYMIUUXfuYzV1H3aU+QPQlvqWLGlRgLdAOOIK8ckmeQiYvvHdmmpNQogWro4jxtwWneAObkN9YlLrA/VGRVx+nR9NNyB0XByUgPCrIwJvnLurZKfd+XExy5XtQC2+paqVfkKOyK4+48BFLJJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772527276; c=relaxed/simple;
	bh=rQId6PFY5tSxnNiKDJl4KfKIr64EgraBaTGQtwLWTuU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GcTJFuFvuEkyDdA+jDBO/IgMelxBj2s2BrYXNUsS9KZ83QHIDIUMpyUqsEp9/Mc9rXht0I4aalqoXoEnIbzcPNcdqZH9v4PkzYYN5eOUl/Slp9mibVMtDXwYMxNI0AkQpGKjpUUikcNP3rMWCA37F4X/+SxNt9N5F/vM1sLN58c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rS+WiODX; arc=fail smtp.client-ip=40.107.200.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S9Pn0qfYa9RnkNG6CPlhiuWdqKH5ldXSU6lC/aXUi4ehrAasZQzt6EnFFAGgLm5oIfzRT5YCMk4dEIu/drWEEmmhe0+kn/1B1tbzvxA+9ZXsyvgHzHAooVCacncBzwdAN4JJ3ik6tFql4AOyQzfUUaW3D9aV+4zmnuUp/q7ilqlyjQl5d5A1UEkysp/eLwcGsvkTIzeXTI4qrD6grPI45bSWE0P4ToYkkn+pK7zwZavxioNsnF+dxy8VsQpdNSX6JJBPZlUj0MZ5d+3RCdr6x6YRwUJkwi8qTA5khNmFmGj1xPcrJ0/rMRRo8RGHLCDSlmUtJbxA1MCT1ngFx0DKrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Em3PdSmXk7xG4ymQqCOtMDA/IKC/R39fnew73YBu1hw=;
 b=PpjknO8CixiizLPnGLEd+iV2EHkuYKBEbtxGjaguRswSvrj26Qj+o1V94iOi+9+zd0NkoaEXTtwz/V24I7ZbGwmBHhEPOmWrT8mB06Xb3UIHhDCyCYkFYMLVJ+tHC3etZmT6A+2T2DLCD1entPYVspulOONMP+MAGZ28RakCzWftAIkKh/2BlhVG8EIjTpTSUTTrjhKBqZLgDp0+z+OVXfAig7hdOMy7O18BJDQJRLB49YaG5n0lhZLGZlOPFVP3dQEvyPtNdY4O+fFUqfS1vkKKtiFafWx4EW+10BBQ70g0MhGINnmzl8qfNt70cjZMZYytnSYWmztXRs0OeTnqoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Em3PdSmXk7xG4ymQqCOtMDA/IKC/R39fnew73YBu1hw=;
 b=rS+WiODXG+OEvHd8cZ2NxJNEjvsmdlniNZNr7zaDZAAOfS3qlubc2B2KEvWFLIIYiwFHZxusqRARRetK56I1y+YgqMuZsWvIrVfayISgiNIxNB1we0+bUlrXDVB4KPudpYM6ymcqS8JwK/CYuLvdtbYe71xPVbY7IhJntjFnBFDcis67saUFBHKjO3UPVSH6mrvvHs4MlVzNduYjJADBPfTOzzttxLEqhw2QZGUKI5MOXIvsoxhLv+oY2vJ/vS0SfkYdZ9z8sgNG2akr8V61SLQfjbdT5coTaMdAR5BZnhdMAFsM6L+jP5ivN50GyuOqvaD/WY2ZyvvJbeeWObbonQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by SA1PR12MB7125.namprd12.prod.outlook.com (2603:10b6:806:29f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Tue, 3 Mar
 2026 08:41:11 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.20.9632.017; Tue, 3 Mar 2026
 08:41:08 +0000
Message-ID: <25b847e3-b562-4309-92cd-e63f68b625ed@nvidia.com>
Date: Tue, 3 Mar 2026 09:41:03 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/3] selftests: drv-net: iou-zcrx: allocate
 hugepages for large chunks test
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org, dw@davidwei.uk,
 jdamato@fastly.com, asml.silence@gmail.com, io-uring@vger.kernel.org,
 shuah@kernel.org, linux-kselftest@vger.kernel.org
References: <20260227171305.2848240-1-kuba@kernel.org>
 <20260227171305.2848240-4-kuba@kernel.org>
 <f827a42a-be8d-46ea-a6f8-edf0f1ee1a26@nvidia.com>
 <20260302182222.245a34d0@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260302182222.245a34d0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0138.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::17) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|SA1PR12MB7125:EE_
X-MS-Office365-Filtering-Correlation-Id: 331a980c-9842-4ad0-f4bf-08de79009d64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	RTodVSKGbnQEtqtiBtGbkBkPZB5zS7lp5muxkqsutZ5muQHpUA766xpGmdy9i7KWoVwlWtuwhXY8/fFdwm1Bdox+ZXHgdQaicAdocERaT3exmpkA0M4YE5O6lMBY7WB5eJxMYkFPde35M7YCCEQhzmU5xHa+vc1EM6UKXpB214TsakGx6jG4+FZGJmubgWaZHvHd9gtENTb4YuZiKn9I4RSej929kTvtGzAC6NddW97AzYV+9n9wAOI+pEqyxJJOncrfGBkeZwtlEyQuRkky/YX++MPx00t6wcIwKH9L3Pn/TczrVb0SLcyknxSDCO9Bddu/vuWkMYmxTS/VsWhJm7DMU/MkhIxhDesvjxQZo1qOgkLVwfgkDdRORFHq31dmnGK0iAhLeJc4plkFNnQdYahXH9gH33KS+Yz7bnHBue3p08g4edFMv6HiufRzGEE3AJkVN10IElwtjDLvSsDWFO9tO3RtmsExRppaQKhbZopvje2rBEyGC4ETDzIxH32rdjqojn/oR1uRym4Fum91c4Fp1cEoUby/h0s2UCd7TKE6hoq0xD7DHTn+VtW+3HocisdJ4rTmEa0JRjgRHG38e5zW+7PgFao7zJQwRDb9VsAhiQ1wPeRAj4PwZ1233O9XXXiIEcJH61jM83mggLILxsEI210FiJrt+2+OxuNpkjYXVM+zjMv3sFbw80Ke2KbEzOyHA3nNr/0PdwXQ+pAlYgPtEb3RXp9iY4CHVbGgzkk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0JvRGtYaHNYeW1WdElnRWNIQVgyV3dCbDBLaEdsQmliL3RCUzM4VDBJQ0lN?=
 =?utf-8?B?OUVEbHVNWWRscVdrc3VLRjh4a3BEdnlqS1J4d2FOMm9tbmk5NDJHM0dyUmg3?=
 =?utf-8?B?WHBYd0hGUDc1N3N6QUV0bEhoSitqQWg0RDZCaHovcjE0MHl1N0xLc3NFcC9t?=
 =?utf-8?B?RXpUWVFwNkNKTU5hMkt2eElLUnBBSlVMVzNVMXl0cFlmRFVWZksyRWtKMUkv?=
 =?utf-8?B?Y1dlWS9ManNTdk9lNVNtaFhqWjRWSEtlSGJ0VTJuekpxM2piU2JNLzZGdGFN?=
 =?utf-8?B?d2dwSjNiTTVkWS8wVkpQb2JCWlFqYUh0ZWtGeHhFSXBhU1Nicm42Tms5WkZ3?=
 =?utf-8?B?OHNUQkNCS2hNOStscllKdmY0TGw5OGpVQkxoTkxLYzJwa3ltOVdCRmwxUFh6?=
 =?utf-8?B?YmZqa0w2R1c4cTR4cXJ6YnNlMXlBTHJ4Vkk2YmJINjVhY3hjUE5NeDlCRWI3?=
 =?utf-8?B?dW1PWHdpNGhuNzRwOVhpa3B3NG9oMWxwYU1hcTMyZXNEU2xnUWRlRXlySDZp?=
 =?utf-8?B?VWlMQzU4cGxQUzdlaWZTNWFRZmorU0VRa3hQcGNCQmJlK1VVcE1BWlMzanFX?=
 =?utf-8?B?YUxNVmRtSEdHYjNsTjhicjJXNWloeWR6MXZOR2pRZlFhaXFZbUhJU2E3Y3Bz?=
 =?utf-8?B?T1pMWU4xMlN4cGd1M2M2VFl6WHY1M1VKeHJTMjJKVmdNSmxnNzJnbTVHdlU4?=
 =?utf-8?B?R2QrVWlwTmlyU1BZcFNaNnNPWDQ5Y25RSDhVZEp6aERhcE5KZ0pMRUxZem00?=
 =?utf-8?B?V0tzQXIzaitUaWtLd1F2YlFjL3JuN3JDcTlRbWdyYmxpcXpMdjVhaHVpUEhP?=
 =?utf-8?B?eTVvY1JRdFhLYkp0cE91M0ZMdWFtVk9hVUlKMDVDU0RDcDZnV0NwZldxWjJh?=
 =?utf-8?B?cENabUNEZFBuOVA5b2dTUTljQjQyOU5HcEtyb3lOZkYxcjZXQlNIWGtnMlJs?=
 =?utf-8?B?S2IzQjl6eW02UVhaYmFTWEJNM3JabWZ0MlU1ak9tQzNPREZNMDRnZU00MXJ5?=
 =?utf-8?B?MDY2THc2T0VpdjNvV0xEM05uTWZVRGM5QURsemJWRWtENU00b2MvdkdnWmdV?=
 =?utf-8?B?SG1IRWhRL2d1S2NtdVRab2lYL1pBbWp4YUI5aHBYV2hsQzZQOHZ2YWh5MDR0?=
 =?utf-8?B?bElzMzU1dlNGWXFyTkdqdlhkVDJmZjU1T1FQdll4R2VaUmtHbVBuTnA5NXVa?=
 =?utf-8?B?V2s2eU4rT1JxVklVa3F5U1RGZmRDQUc5UlRRaWNOcFJJc2tUTzgxMFpUUWdm?=
 =?utf-8?B?aitwa29hYk1VUkZDRjZjd0JQZU12SEpJS1FmdkdBNWROcEFEUjRqNHFUdDF5?=
 =?utf-8?B?c2NzeXlXYXc4Z09qR2IvWGRVUmhXR3FrcVJwREx1ZUFSUUtROUUxK2lMZEt4?=
 =?utf-8?B?Q3pHdEFBYXRucGJGZW9uMG94NTlRTnY1cXQvcVFrQ1NSdU93SmVsSzdzS0pw?=
 =?utf-8?B?eHFOcy9mTGd4ME50SytOb080U09Qb0xHU3oyT0IzbUhPL0tSVkh6WHFjTjJj?=
 =?utf-8?B?ODQ5c0EwR1l3NW8rbE9jSEh4WEd4ZThJcDFDem1iVkRvdDh4cE1XVk9Kcllv?=
 =?utf-8?B?bHBUTlNReXJEd3M5TGswMkNNNlpsZGM1SlRRU0hOZVFUK3ZnbkZVajhSWjNX?=
 =?utf-8?B?RVdFc1B0Wml1anVNZVozWXN6WEluREFkV3BoU0JobFRSMHQ3dS85Y04wbmt0?=
 =?utf-8?B?SE1UVXBQS3NlT2hodWQ4c2lLM1JuZTVmRlJVeDZDRkthay9YU01ITUV1UlNN?=
 =?utf-8?B?T0VGb2x0ZEVRNTJPdm96RFUzTlRBdlorRGxiMGJBeG03ZkxOQ0dCdnlvb0Y0?=
 =?utf-8?B?VCthQ3BTYm9PSnlZdFJlWWlpSmF1WCtoQURhTHhIZEpwd1M4R3I5R3ppcGVJ?=
 =?utf-8?B?UTI0WFk1aWliWmplQUpCSjFlQ1lyck1VTEsvSU0zOWY2ZWI3YTBCWjZUY0JW?=
 =?utf-8?B?dCtrcE4ybHdNUmJvRHR6TkMwbTMwK2tSYzFhcVEyUVJTWThaS0ZOWUNGb0Zv?=
 =?utf-8?B?d1NKV0JhdHlSNHowa2p4QlFVeWNhMHRCWGsrZGxMTFZFSDJBbHhseHVEYWdp?=
 =?utf-8?B?YXo3QXJMYkhPMk9qMFpZQzJYTFFNb0RvejczWldBcGFXOUV2YkRqZkpUaDJr?=
 =?utf-8?B?OUdWZEFkYUZjU2hxVzVaV3FzOTU5UFdTbTBmQUpSQ0IxSnRISzFIbGNaOGRP?=
 =?utf-8?B?QjZyMSs4anQ5L3JCanBVRmo1OUs0VlF2d0xTVWdaQlZXcWlvTnBnUURRM1VK?=
 =?utf-8?B?Y0lxcmxzbEkzVk5wSlRtaXFXTUgraGQwaSsvWm94ZExCQmhtQkZxRTdOWXJt?=
 =?utf-8?B?c0oyck1UZFl0MGpmZWx5a29FZnZrcjBuNVJNeHUyUUtjNUdmWnBmUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 331a980c-9842-4ad0-f4bf-08de79009d64
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 08:41:08.4950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvaYkToaLUZgnwgZn8PpCCgdbhyMVlEP92UEsVpEb4t4AlHc6cCUhQprJXAynWU/a4ZyG60uIU8jDnRPgiy3UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7125
X-Rspamd-Queue-Id: 4506D1EAE76
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12542-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[davemloft.net,vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,davidwei.uk,fastly.com,gmail.com];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[cfg.target:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action



On 03.03.26 03:22, Jakub Kicinski wrote:
> On Mon, 2 Mar 2026 16:16:38 +0100 Dragos Tatulea wrote:
>>> +    hp_file = "/proc/sys/vm/nr_hugepages"
>>> +    with open(hp_file, 'r+', encoding='utf-8') as f:
>>> +        nr_hugepages = int(f.read().strip())
>>> +        if nr_hugepages < 64:
>>> +            f.seek(0)
>>> +            f.write("64")
>>> +            defer(lambda: open(hp_file, 'w', encoding='utf-8').write(str(nr_hugepages)))
>>> +
>>>      single(cfg)
>>>      rx_cmd = f"{cfg.bin_local} -s -p {cfg.port} -i {cfg.ifname} -q {cfg.target} -x 2"
>>>      tx_cmd = f"{cfg.bin_remote} -c -h {cfg.addr_v['6']} -p {cfg.port} -l 12840"
>>>  
>>>      probe = cmd(rx_cmd + " -d", fail=False)
>>>      if probe.ret == SKIP_CODE:
>>> -        raise KsftSkipEx(probe.stdout)
>>> +        raise KsftSkipEx(probe.stdout.strip())
>>>    
>> While working on a similar fix I found that the probe here also requires a barrier.
> 
> Hm, I'm not hitting this issue. Maybe because I'm testing in QEMU?
> If you can still repro after this series could you send a follow up?
Will do.

Thanks,
Dragos

