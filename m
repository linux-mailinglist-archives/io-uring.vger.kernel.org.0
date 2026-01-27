Return-Path: <io-uring+bounces-11960-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPaPNJhUeWknwgEAu9opvQ
	(envelope-from <io-uring+bounces-11960-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 01:13:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6111D9B9A6
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 01:13:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C6E65300AB35
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 00:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C392381AF;
	Wed, 28 Jan 2026 00:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="i4BPs8fp"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26BA288D2
	for <io-uring@vger.kernel.org>; Wed, 28 Jan 2026 00:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769559189; cv=fail; b=PuHIxJnbBXOdixb4JV3+qOcnm8gIjmr7Jvh8eU6QhjRR5wxapOAztvUndGk6E64J/pURE8EXQXiKpzQbcnYOfE7ollKJorEuYuAxOdcFIcVRZA1ajhp9A7tFn/DV6YCPuLijfCMBRlL9ke9ditRL8ktu4jsEJ4DL4ySNfCHBJAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769559189; c=relaxed/simple;
	bh=uRyptWhGQl2JTACxi/WvFdaVIo6jjhF235raWKX3l50=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I9Pu2lqBANykOUWzF6vkRJtt5RLNcfTOuHY81tRxiqHQpqhnKBExtx2s1lK06eYrdlnN9zywrHIWIUddt+cMX2uWxsotOhC1l6X+f1d/20yPWzynGA5UuK9RHzPkogjJ7Qsg4wcVhz7QvZwovEUc0Z4yErWbD0SmTWUewkv4uuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=i4BPs8fp; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022119.outbound.protection.outlook.com [52.101.53.119]) by mx-outbound17-125.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 28 Jan 2026 00:13:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r7UFeERsK5+3P3ddN592W3lCHRUrLkjEW84mqLQBZpcx0zotMu/wALan2ELGtsd/yeaN7PXZ0a44UcraYuYbAx7UJP6QZ0JUJy/I6Aw2Dc+1hxm5oIdY4vzx/AS6MZC+pSrPwn6sWVJvVo6o00MwfxG2i8nOSecjMwIaa97AiOGrBBFYYonpT3QKET6FvJqcwlzfgh8EQpzG8ibHPpceWvO2ZVzKr3zhy6OXjkUsgVaO+8mfwAHsZr1waLuA0CSE0u9g9r/sJicV5fKpwN6ny6OYO5/Dn4UBFKM/PkhxSgwgqaZd2x0RSNGcKeyPCMM+mdw43CdGkN8Pj2pbqXvxow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yE0LJ7Hva31bagQoabzjNnhT2wFkKhC3TEuvnHPgrso=;
 b=WtHRgjF2PRDy8Xr96VH2TYJM9S2AkbpYpVNWUBNiQhhM0JmQyEXD/g/Y52ptqm0gFMwNXtxjaMlpbvs329ptQksLyhQB9MdP1q7wGMpVmnfWOpcSS/1dn57MkIJVd0F40x7oUDd1K/0lOvbGkiL4ZSDXdutf0tYc06PDHGmlxgrvisLAjeYHg2Cvdts2xY4htk7KCRTasDRrG496uJ3bUxjHIEhwL0BEupj+xih/73z/ceKIXf1An/S5CToozXRlfns9dukLKcaFH9wr4cx/x3cznmjjSJSt5fYs8mWomRGIblJZVhDVfWudL6VX+vRE8Zan7qu0JAc/OqAqLWKS5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yE0LJ7Hva31bagQoabzjNnhT2wFkKhC3TEuvnHPgrso=;
 b=i4BPs8fp82LW9c7ElzrjTCfMDmLuhls0QYS8kvF+5FuKX6jOq784RkrhHx3ZdmdrmjPwHWONIBYZqvGXo3RCGzVog3Z040tiGr7OmrKN+Bz1EIElDbuHtOw0ZE5HjQpE6F122IzM9IggrHl5NhLaCcUz8KSXZJKUpenRVYsVXe4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by PH3PPFAC235501A.namprd19.prod.outlook.com (2603:10b6:518:1::c44) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Tue, 27 Jan
 2026 23:39:47 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704%6]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 23:39:47 +0000
Message-ID: <68b3ff9d-ebcf-45c9-a50a-b5a59d332f4c@ddn.com>
Date: Wed, 28 Jan 2026 00:39:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 18/25] fuse: support buffer copying for kernel
 addresses
To: Joanne Koong <joannelkoong@gmail.com>, axboe@kernel.dk, miklos@szeredi.hu
Cc: csander@purestorage.com, krisman@suse.de, io-uring@vger.kernel.org,
 asml.silence@gmail.com, xiaobing.li@samsung.com, safinaskar@gmail.com,
 linux-fsdevel@vger.kernel.org
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-19-joannelkoong@gmail.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20260116233044.1532965-19-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P250CA0008.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:102:57::13) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|PH3PPFAC235501A:EE_
X-MS-Office365-Filtering-Correlation-Id: 992620d1-90b1-47fb-ecf7-08de5dfd5b04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|19092799006|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?aGRvOGliV2NXWUNLY2h5cXRYZjVrcklaS0F3UFVwTUxvSUw0bFloZUpkZmMr?=
 =?utf-8?B?bExwY1RkYXJPc3hLNnphTkN6K2pFZ0dGMVFObUZuYTE3RGZsN1VqcitHZXZR?=
 =?utf-8?B?cXcybWMweENzMVBvaGpMWlZ0R1hiT2pmcjlmYVJwUDdtMXRjdXFHc3FVd1lK?=
 =?utf-8?B?ZmpyZlRtdU9EdDlUQlg5ODQxcFhpQjhYNW5ieEtHY3ZQcUxvMVRLaGhKMElz?=
 =?utf-8?B?RjcvNE5IcW9oNitZMU9DNDZBazRXdVpVL3VWbkdmV0QxZTE0MXI4SkEwMDUr?=
 =?utf-8?B?dFNzc2tWbVFEd3Q2OFBDdFZmbTNLejF4TFdsNWhOQlNnUjU1RkI5QUpuK2pD?=
 =?utf-8?B?RkZOeTVBSjBpYXV6TllwUHVicC8vUHNMbjVYS2FHVWtUT2MvTmk1SWgvMTI4?=
 =?utf-8?B?YUlIamxQbjBWWDlLTEFQeXl3V0NvRUs1YldqUkxrMFdrVkg2YnAxcU14NENW?=
 =?utf-8?B?RXZhTHdtVVkrdWh2S0JWV1hPVkRhQVI5SnAzYWU1aldha0o2RkdUVHR1bGZw?=
 =?utf-8?B?SHBERFpLTHF6elpSdFNMK1JjaWRlZG1EczFTSzNBd21mTXU1TUxXTEZkcFNT?=
 =?utf-8?B?VkdUdUVRY0QxSkV3dVBnSEQzb293a3NoRFhLVzI4N0JGelNXMkdCdlJKclNy?=
 =?utf-8?B?N3M2bkNvcHlIWXJGL3FOYUJMZDhnTGpkZm0yQWlIdDNkT09jbmd2WjI1cExX?=
 =?utf-8?B?dGZuajNseXRNVUkxWXdoYmhYSzRqUVd4ZzI3aDN0bUE3TUxreERnYmVsaG9k?=
 =?utf-8?B?c2xhZWpKd2pNeHlDZFNudVJoY0FKV3hDZEJpRWVjWll4WTFIcnBBeE9KSVV2?=
 =?utf-8?B?S1VJUkhlWkFYU3JieTRlOVpxaCtDbGxGc3pjRkVFb2tCMkhsYUtyclp4QU80?=
 =?utf-8?B?bmRjMWtpOXZlSVRNcGpZTVo4TUovamk3ZWJSc1hjU3NPamtXU3pXamI1Z0M5?=
 =?utf-8?B?dnl3U2lYOWcwNkY4VEZ3Y3lGaW9qOXhna0NjRHFJdE9UZ1FwbUtKWkxOVWti?=
 =?utf-8?B?cngyU2RSK21IZ0IyWm5rSzRjRURrS2FFamxLcVMrWGFVSGYxRjFsZ2lrTkk4?=
 =?utf-8?B?OHJocFZQdUZkYnltQVE2YndFY1ZDTWNMOUJNL2xZMXNDa1lkTm9taldVbWcv?=
 =?utf-8?B?SDFTVXJUSER1REYzS3BLZkwwTGpFK1NOQ1FuTVdVRFh6Y2tQUlVzWlN3VXRF?=
 =?utf-8?B?ZEYwSGh1bUIvNGpDRTAwcHJoemJYenZhVXhkMmd2M1FlZmlZQjBxbW5FK0ky?=
 =?utf-8?B?ZFUwNFpiMTc2QklDNitybHkwcVVWU3EyeXUrZURJMkw1ak5oRFdiUHNJc3RV?=
 =?utf-8?B?eVgyeEs3TmlxSXhmNWsrVy84ano3ODRHTDN4SmM1SlRyS2RhdzY5cnljcUF3?=
 =?utf-8?B?U2I4b2R2Q2RiQVZuazF1TjFRcm5NRmY5OWpVUVh0Q04xdEVwM3lWTGF3QTJa?=
 =?utf-8?B?bXAzSUhuT0thczYyUXppdE1tNmtKU2lDNzBoazhrbGI2WDlBdFI2bU9UOW1U?=
 =?utf-8?B?OVVEOHFPWUJqTmhmQklDUDQ5eGl6bnFYL0hhVWZrVjRGdXlEb1R1eVpEaEdq?=
 =?utf-8?B?R3dNT1duN2RSaEN0a2FISGxPZ3RmNC84YTR3ZXZyMlErNVVjTXFLT1BjbmJl?=
 =?utf-8?B?OTRGbHN1L2dJSE5BMys4ZmRUMzNzME1JYTZZcTg5N3A1N0JzV3NCRUdCRVRw?=
 =?utf-8?B?VmNlQndGeWpPaTVUaHBKbmZXRGpOTi9PblRndG5xRlY4UkIrTEdHaFU5WDR6?=
 =?utf-8?B?UkZBOUZxZDRrV1FpT2dnWmJJNWpaaVp5ZGk1TkdYRE12elZFRHN6cktjdXd4?=
 =?utf-8?B?aW85ZFlRem1qTHNueUV6ZTdEQUkzTzlzb3FJNVo3WkJnMW9jN2tXQW1NdUV3?=
 =?utf-8?B?VytSWUtGTEEvRzJYWHRJQWw2M0hYVko2RzZaTFJpWk9qQkxsb3F6Y083QnE4?=
 =?utf-8?B?K1lzVU1rOVNscUxCV3lXWHVHSTBFajhBZ0tQdkh3cWEvdXBrbGd5czdsWkds?=
 =?utf-8?B?cEtzRkgyYldERnR5bkVhVXBHaWdtbnhuYjloRC9TUXhqZlFpOE9IQ1pheHZY?=
 =?utf-8?B?bndqSVFXcDZRQUljbHhBQmhFWks3YjZkUUZmdEZ0VjBWUXVhN1NWSnVOdEVs?=
 =?utf-8?Q?nqy4=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(19092799006)(10070799003)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?M1g3eTNUb2JBaFI3c2NUWGZLRmttckE3cFYwYmExRGs3N3R6Y1gyL3A0SUlw?=
 =?utf-8?B?YlgvaUErcE8zNTl2M1pPM1cwYjRzNFc1UXdXKzZ2S2VQUm93cHE3T0dYd1VV?=
 =?utf-8?B?eHlRU3NwNWhiSWthVG9IY1NRc2FRdUFHVEExQlpmOUF2NnVtTXNhWlpHNVF2?=
 =?utf-8?B?aWxsTElFa2hRUFJuMEk1amR1enQxN2xoTGYyOWNsOTNBN3R0dXZpb1pQYUJK?=
 =?utf-8?B?dWNqZnlFdnYyUUEwcjMvdXIzaFZZUjVvQldlc1h6RDRXdzcwOFJNajBkY0Rs?=
 =?utf-8?B?Z1h4bWJLZVZuZmpaMDQvV1pxRUJRRHV3dk9nTzBJeEhsVEc5RSt1UVVkVUtk?=
 =?utf-8?B?aTVyRkZwVjZUaW5lYVdTdWoxeDB3N1d6ejlDRFRKTVFXNUZZdTZ0NUFiNC9n?=
 =?utf-8?B?QlBUdkVCdThrREg1bDlrMlJWWmFrVGFJeUNkZWNWd0dHL3lpTTdpY0tzM2Mx?=
 =?utf-8?B?SktiOGIyd3V6K0p2UnF0RGdtNFJ6T0xTZG9FeDRraUJCY29qMGdYTlA2SXhU?=
 =?utf-8?B?dmJEVzFjNzlIcFhEbG1Vb1I4MlEzUTNPVTVPd1dpUTk0WkcrQjRDODN0aVZ6?=
 =?utf-8?B?REJ1UmZSSEUzYWEwNnBsS2NwWEZ3UVZid016YzBrK1lHUnovanRRVXhZaERh?=
 =?utf-8?B?SWhMenBGTzN5UUtMOWg2WGdSMmRXbFhvL2l0UFViRjhJbzNiM3F6WjArTUI3?=
 =?utf-8?B?UXNqWkl3Tk5DdUpPZDh6QllCd1llbmpKeVpNOHJ2SXRPcGpEeXVwWjVkUDVK?=
 =?utf-8?B?VEp2TzhpdEtuNVVvUnZUZVNjSmVsS2szNUtySUo1TVVUWHpqMHZEb04vU0N5?=
 =?utf-8?B?RTJUeXZPOUx0azlBZ1JwTUt5TTUzM0lBZFBnRXg3eU5nZk9ScjltVk9ibCtk?=
 =?utf-8?B?a0paN3ZpTlFXSURvYlZwcW9IT3NSVk54cXNCa216bnVWN2xkSXRwWEloYWlC?=
 =?utf-8?B?dHlxSXdyVlVKRkIxTlpkQjNyV3dPTjZnSVpuOTNzOFRiVWpobG5HSVhoNVFn?=
 =?utf-8?B?T0xvZDdlbVRhWkpKYnhmVHdFUjNNZlMrdFBmQmNZTDBZS2g1Q0ZoYVkyMVVk?=
 =?utf-8?B?YlJRaGR5b2hydVBmZWk5MCtsZ2VsRFQ3Y01ocFI2U2JYRmw4dDVFTzZqaGdU?=
 =?utf-8?B?SjltMkRpQjZYOUg1WWVSV1lOYWlCMXZWSUVjRzlpejk0eHZpejNtR2NhaUQ4?=
 =?utf-8?B?bWVzRjJqNytMbW5aMkw4ZnlPZm0zZ2xsYWdDVFlmdmQ2d3VVNzFEVFN3UlJs?=
 =?utf-8?B?YkdCbTNOeTk3WjFoMFNIK0VqZHljU1FMVXA1Wm9UNUU4VzhXS0oxMW1BYnZl?=
 =?utf-8?B?akpldzZ4RVRLZ1ovUG1nVGRGZ243REZWR2xUeUxvMFFTM1ZpallCQmg5MVlH?=
 =?utf-8?B?cFgxUkJ5MWlrYlVrcm5ramw2S05CT1JuUUlKRnFuMUZnWmNPdFllR1pzcTdN?=
 =?utf-8?B?MjJIYi81NWduckR2UnhDblErek1UTUE1a2tEaWRtdm9yLy9hTEZzdEFZQmF0?=
 =?utf-8?B?d3g5cDZpTVczMnZPcnE4RE52YkYrNGxQYlcxanJvWmdnbGkrRUxXVDdQL2E0?=
 =?utf-8?B?UWJqbjA2WlNSRUJJWTJiSzlQSm9TcnBIYkZPLzljdnd3U1Vlb1c5UXZuU0xG?=
 =?utf-8?B?ZjJ3cUhLSTJQL0YxU1d6cEtJREtNTWlZMk5qZ1F3OG5WYUhyYUhNcWxRamRN?=
 =?utf-8?B?R2JRMmplV2poNGlKdkNyMzVlb3JpU3hWazZaZkFRWW5tNGlkZG1iZi9zekN1?=
 =?utf-8?B?K0xBQVowZXhuOVI0R0V2R21mRWM0WjZNbUJqb1MvU1cybWFPbktiWmQ0N3Na?=
 =?utf-8?B?L0xsNUNzMVplVDUzaDN5aVEzRGtKeWQvYmJ1VmdTVy9mVEtOd2xOeW1yV2ZM?=
 =?utf-8?B?bG9GaVBIU3I0dFY5TmxqYU5vYmVLTVIxblVpbG9oK2czTTlISXpqcjUrdnRO?=
 =?utf-8?B?VCtqWUdVMFkvbkdYZ25HQmdyajBNaUNYdUxXNU94Q1B3VHFhREdHTlV2QTMr?=
 =?utf-8?B?ay80Sk1RQXQzaGFHanpQYUpWNXBUSEdwT2FnMnRCcmV4b09XMnM1U09Ka3FK?=
 =?utf-8?B?VythS3FKVHl1Qkh5TTFwUVFlVnFoWnl1aWFzMzhGVkkwdFNBNXQwRkJQZEox?=
 =?utf-8?B?aWhQT2lmelN5QmI3Mkg4TEozc0tRNERQTCsxSU5YU051L1FtWm5GS01hODdN?=
 =?utf-8?B?aHllWFQrV3Z6UzNLVERMdVZOeFkvcHFkL0krNVNEK3JVZ0NEalQzMWV0UjdN?=
 =?utf-8?B?UWdwbGxPVDNUb2RVNmVkUzZtODd5UTM3Y2Q4SlBDd3g1bGpXNFNHbUdMN0t5?=
 =?utf-8?B?RnpCdHlIZ1BSN2hQL1N0dUFSUmhBZitpMkwxSWZOYksrNlRLQUNvMEVCNXEr?=
 =?utf-8?Q?39pOy2QQAiwvOeR/vSrFPZZ/40s1a6NWhRqAC+FLRNcXd?=
X-MS-Exchange-AntiSpam-MessageData-1: zH8gDWw432ZvtA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 ZWVPXh3HlsuVWn90jfWOVfqNcBfDTKwMCHOADEOtVDN3L4xUAuL8YEVYMl6hwIAl/nH0Yz3ZlFXhEKCaplStTwO6FeKD5yhYyfxiqctJDFE1T7FJTeK6xw5IaKFz23L069YwXEy4gtLSnHFFg2ck/HyJR27PHZNhKVcXP7fU6w7YnNdGrENXLYPgEBdps5o8P+D40Mrd1S3nblT+W+LIBwSaVeDxNL7Vyg9oTEsdsdK2Gqtig6zKUmZktGN1roFBqKckvy0g+qbarQ7/Db9SI+PNbMIhxYrlt/z1wKVATDsJiU6yNOyjKAr+YSXOkbkm3q57yOvqJx9ONVcPtsUo97Sr5cxjnW4jEYEWccB7PO76qZiMzi/VUCRJWGuwNragUEFlcHfYI+YF8wdDrn7ZXvbTsyaPnjxtJqaR5szXIAfsYmINvHsK5M3vWoGSKtpY4laL4K0FCR+kcgcXRo7vYeS7YfJ4oAe9vT+z+xUmeQp58drayXFSZOCP+D3gFuZqqnB60LlSxQ3AerWegqxagiY6uIB0OEXnN8WbBJ6R0CIDoLocuxVEFkazFM7Ta0gWDV/ktlLkL4kK9+0QSgJgfdDJO2QGxjcerhqCtKGUMhp2IbOSJ4pDssCDwoF7A9gUhYKGxUS9cTgHJR/96Q262g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 992620d1-90b1-47fb-ecf7-08de5dfd5b04
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 23:39:47.2270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NrjHmKCiyP5dY+hK90W4xkS8oAXx+ZqBrG94UZn6w2wmZP0F9w0oQmzx0HQa5ewjPkFWXogRIzL/zg8bSjgZvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFAC235501A
X-OriginatorOrg: ddn.com
X-BESS-ID: 1769559182-104477-27036-20493-1
X-BESS-VER: 2019.1_20260115.1705
X-BESS-Apparent-Source-IP: 52.101.53.119
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsYmxkZAVgZQ0MDIzMQ01cw0LT
	nZJMnS0CQx0SQpyTDFINUixTglOSlVqTYWAHNVT2pBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.270715 [from 
	cloudscan10-9.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[ddn.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[ddn.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,szeredi.hu];
	TAGGED_FROM(0.00)[bounces-11960-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bschubert@ddn.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[ddn.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6111D9B9A6
X-Rspamd-Action: no action



On 1/17/26 00:30, Joanne Koong wrote:
> This is a preparatory patch needed to support kernel-managed ring
> buffers in fuse-over-io-uring. For kernel-managed ring buffers, we get
> the vmapped address of the buffer which we can directly use.
> 
> Currently, buffer copying in fuse only supports extracting underlying
> pages from an iov iter and kmapping them. This commit allows buffer
> copying to work directly on a kaddr.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dev.c        | 23 +++++++++++++++++------
>  fs/fuse/fuse_dev_i.h |  7 ++++++-
>  2 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 6d59cbc877c6..ceb5d6a553c0 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -848,6 +848,9 @@ void fuse_copy_init(struct fuse_copy_state *cs, bool write,
>  /* Unmap and put previous page of userspace buffer */
>  void fuse_copy_finish(struct fuse_copy_state *cs)
>  {
> +	if (cs->is_kaddr)
> +		return;
> +
>  	if (cs->currbuf) {
>  		struct pipe_buffer *buf = cs->currbuf;
>  
> @@ -873,6 +876,9 @@ static int fuse_copy_fill(struct fuse_copy_state *cs)
>  	struct page *page;
>  	int err;
>  
> +	if (cs->is_kaddr)
> +		return 0;
> +
>  	err = unlock_request(cs->req);
>  	if (err)
>  		return err;
> @@ -931,15 +937,20 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
>  {
>  	unsigned ncpy = min(*size, cs->len);
>  	if (val) {
> -		void *pgaddr = kmap_local_page(cs->pg);
> -		void *buf = pgaddr + cs->offset;
> +		void *pgaddr, *buf;
> +		if (!cs->is_kaddr) {
> +			pgaddr = kmap_local_page(cs->pg);
> +			buf = pgaddr + cs->offset;
> +		} else {
> +			buf = cs->kaddr + cs->offset;
> +		}
>  
>  		if (cs->write)
>  			memcpy(buf, *val, ncpy);
>  		else
>  			memcpy(*val, buf, ncpy);
> -
> -		kunmap_local(pgaddr);
> +		if (!cs->is_kaddr)
> +			kunmap_local(pgaddr);
>  		*val += ncpy;
>  	}
>  	*size -= ncpy;
> @@ -1127,7 +1138,7 @@ static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
>  	}
>  
>  	while (count) {
> -		if (cs->write && cs->pipebufs && folio) {
> +		if (cs->write && cs->pipebufs && folio && !cs->is_kaddr) {
>  			/*
>  			 * Can't control lifetime of pipe buffers, so always
>  			 * copy user pages.
> @@ -1139,7 +1150,7 @@ static int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
>  			} else {
>  				return fuse_ref_folio(cs, folio, offset, count);
>  			}
> -		} else if (!cs->len) {
> +		} else if (!cs->len && !cs->is_kaddr) {
>  			if (cs->move_folios && folio &&
>  			    offset == 0 && count == size) {
>  				err = fuse_try_move_folio(cs, foliop);
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 134bf44aff0d..aa1d25421054 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -28,12 +28,17 @@ struct fuse_copy_state {
>  	struct pipe_buffer *currbuf;
>  	struct pipe_inode_info *pipe;
>  	unsigned long nr_segs;
> -	struct page *pg;
> +	union {
> +		struct page *pg;
> +		void *kaddr;
> +	};
>  	unsigned int len;
>  	unsigned int offset;
>  	bool write:1;
>  	bool move_folios:1;
>  	bool is_uring:1;
> +	/* if set, use kaddr; otherwise use pg */
> +	bool is_kaddr:1;
>  	struct {
>  		unsigned int copied_sz; /* copied size into the user buffer */
>  	} ring;


I'm confused here, how cs->len will get initialized. So far that was
done from fuse_copy_fill?


Thanks,
Bernd



