Return-Path: <io-uring+bounces-12509-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4InsJpmqpWmpDgAAu9opvQ
	(envelope-from <io-uring+bounces-12509-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 16:19:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 166E81DBAFB
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 16:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 84C3D3009B04
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 15:16:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28DD04014A3;
	Mon,  2 Mar 2026 15:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hAQ8J1pY"
X-Original-To: io-uring@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010071.outbound.protection.outlook.com [52.101.193.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF244314A65;
	Mon,  2 Mar 2026 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772464611; cv=fail; b=gzsEMxRMf/6mOI2oNfXdh0GPy6XIgLmgDzBFlrnLfQc1uzHcFzcJxlwERedZ3J4UCGpGkfvRBMstBTj7L1YF84JBiFOgSR/vGQ28iun4YSgh6rK32ijGmjxSfOg+sPaun0Tc+DLd/gUIhpeCsiskB4FgWfbgRfhxtB1v3MVjZ0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772464611; c=relaxed/simple;
	bh=mXdzl2yv9k+JJxYIy7osLBkw+KBgt1gL0NMjGTorz00=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BoNdbE+0GdCz8QE3txsoY+pksPPiXQgZ9B8UDAspmRfKmNOvhHujNY5c5bP/Glg0HMBjMDT4ySOyDzbbkdTx+XuCK6maYAeDE6H7oNIMm3qhH5hyFmjI7sS8HMbjRSOLYyFwiafcu6Z2LXOhZp1sv9pCCGLLHzlGsNNCj1MDm4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hAQ8J1pY; arc=fail smtp.client-ip=52.101.193.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ldDBKW8auVrJ3XHO0OwlVbIYiWNe4fainZMR5GqLgyTiR4vm5OjXENTKkpPyCjNtjQqfoHRSSqVjf2Z2pTFUpgNuD01+UclhlZDK3KQIex0TUVoWiLHdcVZP9cBbwp4WwXTK/f1tpk5vkqSqY6/ZwLNyGg0RpzIyhd/BNImu11zfHILnsuTy1hRWLj/cAVtx04gO+J4M+ilhAdUvSZ9QDCp+MhPJzX+/f7ukeOlqrSs7Tq97ZZ/Q4ol/pxNldWF7w8m/AJGMgNZDqux76KHtM0tIy467dpDm6kC36it0vjT0QNA+TTAp4C8mlInmKN7OZishzf2dhFTzO3eRhv+YOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLyn4UcxC/Lu9PeVbZ/FcDyMD21wfM2LfDqwXD/O6iE=;
 b=oGdClRhefT9vOerSSwJfOo3ZBRvieIBfVJdNT9tZ4NB/YCOrAH9ILDnyM+DO0xL750s7GKYQYOOf04qDswWp2Yel29ASEJMwXJsRHg6iciwn1XyCKmEi8rKbWgWe4da3ytaEdW0dpw7jsAaqDFqF9nk1+VtuhJL/A/1yz+wfxzVkFS/GsjxmKcnbzukRCfJy0JHxcXwDQfPdYptoliqhhmWOHkzmEknghURq+Bm1EJQMegBp6daQ7RfShy4kXRWkE/tClAo+T7ousvG7thP+BeijihWo9itcQ00EJYbWh99uBk+3DLywC5m05RHd0R/klutNSno6tUhZhSMWRRsFNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLyn4UcxC/Lu9PeVbZ/FcDyMD21wfM2LfDqwXD/O6iE=;
 b=hAQ8J1pYb8jiiWxPMPF9jPb1dhGy7DnrllPuO7sPl8vCYb4OBAf/yr2UUhYwQx63qaHRBLsh2NmIzYFUOXIwzup5fWe4xbWIhXUV6gG0wHht0UCbtUIrz9jR2p4aT+Lc+twtWDEax+Htt+Maf9GJEm/IGzs3B+6yb26fSJ49iRtMySmPTWGu4RrQVPFADj4+0l9kf7SXi0ZeDUACk1PdWREcWlGgsph/5ACJ5H/hhGbd/mA0mCSy3bcg+oE2MYp8WcdjyHXOwnwwx0oTwx/+YPqXZegkESCOXP52xRJRuQagfH91uxBu6WSlEgik5NH+xfIxU5+rC6p4iZELXbeuLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by PH7PR12MB9104.namprd12.prod.outlook.com (2603:10b6:510:2f3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 15:16:43 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.20.9632.017; Mon, 2 Mar 2026
 15:16:43 +0000
Message-ID: <f827a42a-be8d-46ea-a6f8-edf0f1ee1a26@nvidia.com>
Date: Mon, 2 Mar 2026 16:16:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/3] selftests: drv-net: iou-zcrx: allocate
 hugepages for large chunks test
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, dw@davidwei.uk, jdamato@fastly.com,
 asml.silence@gmail.com, io-uring@vger.kernel.org, shuah@kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260227171305.2848240-1-kuba@kernel.org>
 <20260227171305.2848240-4-kuba@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260227171305.2848240-4-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0388.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f7::17) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|PH7PR12MB9104:EE_
X-MS-Office365-Filtering-Correlation-Id: 05746e33-a1a4-4f93-bfca-08de786eb628
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	yCCB8L24TYM2snGAMANiholcWuryxorQ/WopdpfOAnOwqK9S35UL5w7MtCFPMWXQggABvn+dWyRp/pn/bURBxvYVnD7ofvDlkq9yp0vtHVyW8pi9tyLfQZC2/Gpv+pzIXs/vO4UIy6fg70YlPBaFN6WtNw1FxhNkH1PRZhqeC0LGKJvawYMIhHv6UJW/Tf8QhaHnv0VDF5H3uWe+8D2thk8x108fJlkWhn7Q4f7kGyOYwxZclZgl4n56K7ErEVKMCPrX44UQihoPQeGEDflw8EFzdonW3e1ok522YtOfKm+CttlywcPSbGWxi/PaIdz6h+4v+QtIthOm/7Rf+lxZ2O6uZZoBo+3YYqBDK6KNR2jI+98quIFPPU6eX0BuOX4FDYzfWOo4Grmd0ky02WHiytrOoLa55ePu8lchSkOh9o3XjLU+g7j6EIK74uPy4mEmTI5dju5kpEpRt+bnsqWlcsHQ18nGSFdDOdiHXTkkuLrNFlI15XkA2vyOzZfYejtdw7CcGdp5wnXUSa1+1vrmkFqoYb4Wo9QHgVZ2Xp++JcrH4KVaejnVtSA41fSTuFGTlWKNP1BWBFWhRxbrrx2TlHBDQUKmC45T9E9M/U0WP1IVouVN/tm+ZCDk6WKzt2f1/8vDIMDo4ehrPyHG1upgcNQGU1ArYKKQMyJ1CGImBmDlSDDyWx2Rprq2Kt7U4XMm1KvaSkukAiCfMKIfFYzfYdY2aTwdsCCJrvevsiImWic=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bzQ3WU4rTW1MSWdWNlI4ejBnZGlTYmJiR2twOVdqOC92VHpVZ2ZBWVRHQlRM?=
 =?utf-8?B?ZEdNYjVXeVRsRlhXL2l0blMxdGxJOHFUalJLSWRIMHpnZ0VOeTltWkFFa1Fv?=
 =?utf-8?B?aXRCTkpXS2lxMEJzdWZUUEw4MG9hTGUrcjVHSFB2VDk1YnVxdHhhVGpCVno3?=
 =?utf-8?B?dzAyMGdEeTlKVU9pV09xcnc5aTV1cG9qMU9nWEpQbEl5NGIwNUNCa3UvZURK?=
 =?utf-8?B?cXJDWTBxbko1dk5WbEFKc0ZTdElJZXFnaEVnMUdCSk51VzdKcmUwUk5ZVlZV?=
 =?utf-8?B?dkxJTVhBUDhHZFl5c2p4dUVmSXRMZ3k3SU1Pa0M2eTFTRzd2QTIxc0wwL3pM?=
 =?utf-8?B?SUdTUEdSdTZ6S3Nrd2ZKOUZCajVsRXcyWXVUeVdGV1g5YnIzOWt3V2REbDdk?=
 =?utf-8?B?cGVGRHBWUWJCRUxZazJrWlE0KzJ3ZThCeVQwNzdQekFoWjBMVEQwWFg2TXFL?=
 =?utf-8?B?Y3BTZlhKMFZpWk9XOFNEaW9kMk9TMUNvRHBNUGJwNk5GSzhDbTdOeDBLUTB2?=
 =?utf-8?B?SG9Nb0RJL1A2WlNMK3luSm5QckMzOEZySUN1bTNRQVo2Ky9Qb1hha1JFTE5w?=
 =?utf-8?B?MWFuOURpZ01TV3RJNFdmK1R6Slp4K2UwZVdPYk8wTHBlYnNPMlVZSlBrRXRt?=
 =?utf-8?B?V2czR1NtMEtQYzhPY3ZPN3FQdHA4Z2VtWGN2c0hjVDZrRXVyVzlBaWVjSkd1?=
 =?utf-8?B?eTJXbVg5Y01pbis4d1JIeERYQjVWTlZiQ2xJZ2swZXdQaFU4T1VCTDUzS2Y1?=
 =?utf-8?B?dVl2TDdtcVpjUG1DRVVNM0hqaThiZGtUekhJSVdWRlJOWm14ZHJPRTZSV1FP?=
 =?utf-8?B?Q3IwN1pyQSsvOExhQjZBNVJRWTBmN0J0S0FaUHVyUjV2V3I0dUM0K3Qva1pY?=
 =?utf-8?B?aHVIWEhlSE9HL3BBdHluWGdLL3BrbHVRMmZKTzFmNmpvTk91aFFvT1VRZDlV?=
 =?utf-8?B?cGJxZzZMdTc0d2pKeXA0enZ4eDlxSjJSa0RVcG1nNlVsUHlvUzluWW1tMWth?=
 =?utf-8?B?YnZ6TnZENE5wMXo4ZnNoZ1dOUzVPbncwWk1iMVQrK3JkL1czL1hrb1o4K3lO?=
 =?utf-8?B?enhFQ1MzNWk1Z3NBTXQ2WFVLa2JLYnFUWXJpamJNLzlCUTZ1SnNHTFhndkt5?=
 =?utf-8?B?QVNUZ3RNcHdpQVdzVzJWUU5BdUY0a0RSV2hLanZZbVA1b1RkOWhqSWZzb3R4?=
 =?utf-8?B?SDF0TE1EbmNsUE5HZE5LbEVUQjJQRjBsZFYvdTBmWCsrS3F3SDNVazFQRXVr?=
 =?utf-8?B?UjhBZVJRZjhZMXJrYmpjV3daUEw4dmdOc3NWRmppS2IrakU4MUw1d3g1SFBn?=
 =?utf-8?B?TVpzQ3pKUStadDJVVXhwYW5WamwrK0ZBaEFPL3J2UlBTNEtCaXo3SFBEWGdm?=
 =?utf-8?B?c3RLYmxPV3laODQrTG91eG51Z1h1YTU0SUQvcTc0Mmlra29DMk15a055WE5R?=
 =?utf-8?B?czI4bmg2bEdyTlFBQ21WUDFIZi9NdFgvOTFScXUzWCs0RUtFZnUwUEZDYllw?=
 =?utf-8?B?RDNscFR0bGlkU1NTODdMYVFWRWpieXFPVVpQL2gybHhDZ3JVUjk1VUZqTHVB?=
 =?utf-8?B?ZHlINFk2dHlLUkMrWEJNT0xDdVJHU0liMjRRRHdYaitJKzJOZmRLQVZsbnhz?=
 =?utf-8?B?SDY5bytmN3JyOWQybXg0YzlZUzZxWmkzNXBQYlFEYS82bEsyUTFCWlQxSmFP?=
 =?utf-8?B?akVPYURNb2pIR1FpV1hxc3hQY0luR3h6ZUdaT3l4c0ZSeEdCVTFhRWxSOE1n?=
 =?utf-8?B?YUZ3aUhJZ0xXSUoyTmM5L250YkNhNjU3aGgzVi9UV3Z0dExRNGJUN2xzaUVi?=
 =?utf-8?B?NGFBMWs4eVJHZGNHcExzQTd5aGFQNVNha2EzUmtGTTBHdndNcFcwRWN6WE9t?=
 =?utf-8?B?VitIb0M0ZjY0c1VzSytnT0dIdTkxbE5iSWs0WW9CeENpdnBvMCtZcmtTTHpM?=
 =?utf-8?B?eE9HZGVIRzMvaXp6bnRaTFBGOTZkc3VKeU5aeUpuMURPb0VRUnY3MGV1akxT?=
 =?utf-8?B?R3BKdGd3aE5SMyttTkFaVGo3L2VJOWd0R1NxWXhUUmhQbG9vU29qemdPcU5q?=
 =?utf-8?B?VmhCbktvUFU2YkZWWFBxZ3lLNE1IdW1Zblk2UEdtcWFjVFU5aTJxcmg1MDFz?=
 =?utf-8?B?dVA3YkVDRk9LaFo4bytmVW54VDJFclFwRk5vMnQ3bmJOaHh5SnpvOFRJTFMy?=
 =?utf-8?B?Z3c4K1NTbjI3UkdXZVVJc3RlbW0zMjZRamFBZ2tDNk8vcVl4Q004QS84Tm9o?=
 =?utf-8?B?dzdMMFhRS3NER0hRa2RScnJwOURMQmhwckZWU2FneDhUSWJmRndza09EYmpw?=
 =?utf-8?B?bDlJdis3QlVkcDFnT0FWbGJXWGEwM2hCUWRzOGFLQy9ZY0pIK0NKZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05746e33-a1a4-4f93-bfca-08de786eb628
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:16:43.5896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0BQvoh47wvgI8YSx6wp650JIxlK5V14EhVwmDysYT8bSqCVdpDrBm/jaYEI+Z0uqGe4Qt39pZoQSd6uCNFB5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9104
X-Rspamd-Queue-Id: 166E81DBAFB
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
	TAGGED_FROM(0.00)[bounces-12509-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[davidwei.uk:email,cfg.target:url]
X-Rspamd-Action: no action



On 27.02.26 18:13, Jakub Kicinski wrote:
> The large chunks test needs 2MB hugepages for its mmap allocation,
> but the test system may not have any pre-allocated. Ensure at least
> 64 hugepages are available before running the test, and restore the
> original value on cleanup.
> 
> While at it strip the stdout, it has a trailing new line.
> 
> Before:
>   ok 5 iou-zcrx.test_zcrx_large_chunks # SKIP Can't allocate huge pages
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: shuah@kernel.org
> CC: dw@davidwei.uk
> CC: jdamato@fastly.com
> CC: linux-kselftest@vger.kernel.org
> ---
>  tools/testing/selftests/drivers/net/hw/iou-zcrx.py | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
> index 1649c23e05e2..66dd496ec5cf 100755
> --- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
> +++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
> @@ -135,13 +135,21 @@ SKIP_CODE = 42
>  
>      cfg.require_ipver('6')
>  
> +    hp_file = "/proc/sys/vm/nr_hugepages"
> +    with open(hp_file, 'r+', encoding='utf-8') as f:
> +        nr_hugepages = int(f.read().strip())
> +        if nr_hugepages < 64:
> +            f.seek(0)
> +            f.write("64")
> +            defer(lambda: open(hp_file, 'w', encoding='utf-8').write(str(nr_hugepages)))
> +
>      single(cfg)
>      rx_cmd = f"{cfg.bin_local} -s -p {cfg.port} -i {cfg.ifname} -q {cfg.target} -x 2"
>      tx_cmd = f"{cfg.bin_remote} -c -h {cfg.addr_v['6']} -p {cfg.port} -l 12840"
>  
>      probe = cmd(rx_cmd + " -d", fail=False)
>      if probe.ret == SKIP_CODE:
> -        raise KsftSkipEx(probe.stdout)
> +        raise KsftSkipEx(probe.stdout.strip())
>  
While working on a similar fix I found that the probe here also requires a barrier.

Thanks,
Dragos

