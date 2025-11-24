Return-Path: <io-uring+bounces-10772-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 815ECC80F48
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 15:17:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D29E13456BC
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD1F308F32;
	Mon, 24 Nov 2025 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OJPBTyBt"
X-Original-To: io-uring@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012035.outbound.protection.outlook.com [40.93.195.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384312AD0C;
	Mon, 24 Nov 2025 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763993861; cv=fail; b=j3admHHQNY5IMXOvrffaB6a6UMJzJcNJCDFKVdO8IHD9VJhhbnl62APp3vRTfnHi5L4VPGMTH8dYEJ9/wwKtrmN3EI/y/jwlIcjr3krYcxqiQCSLJmiHyd9fnudx3NAs63CQrHy4z8Jdr21MXmluiXnVV6iZtVVyRsq0bPjJnao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763993861; c=relaxed/simple;
	bh=kaPlqdDlFk1JRnpNVujPWCCJbs3u7DECUV1dCLSFqEA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tY5wa1ZvMG02jW+QhOWOtUQl1uMgmxUFuCura7onakAwfFlwAdZRy200yi8ENSExgwhE4tsDbxb81jUgB9SiXWED+dUAP411ddRCUehUV83TaaMQAaRtgYwQWsP5rJjfR3ys8XwDnB4m2vUIwfiGPT4+bcqRiVK2t0xs7r+RBw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OJPBTyBt; arc=fail smtp.client-ip=40.93.195.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XBHM2lezS3n2h/kfEFFH7kj3PFYo5Oey1Dvt1QYBzYES/0QZKlZJ4OgNpyiR+sEHhAvDZe2isWoqm3/YFgyMD6OmLMS1xQgY1EIYMPzHpP1SEVcEOruF4MObUPnOV7JBx+FrwTo5b3qVY6619UHH8IMkNKc3x91zlNuPmhqxllvROiadoWzkSY8PrJiN0tWjgFrqpLmVQ5CPLRBXRTytvLKnKWl1SmoXkHMBUL52zwQRbmIFHTT26f3peYhURUJ2us1r1wl5ghye/Tb4Dwxbrqq0Ggqgop4zhjutpY3pcJHC3b2UoUVelzV1+cHjG5ul+XnKVePUNnJSlbU6LUkFxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFI7bQD1+Z7Hg3Gu4hxnTPqT4wRZj0L/Sx83Bc1Dcq4=;
 b=BMRzgXrEwU09saXq9OISJ4pgcEU2Z/xDPuozJuAMmLWMdOox46Tekw+M5EQEsTB45GsR5T7WA7C63tMiDvvd3BwHwdDmkU/r5CRGS20ysBZmNh5u018Kzb9mP0KWSX6eV7cQqkdJfxN6GiIRWx/CsK7dFLrCfjJgja5ZK/srPFZmNlBA+fYMM7zM3P32ufPUl24RHxFcJqfnkNvXUN2D6HVvqbrvVIjvAwKzqW9EYVHm56LY4OJq7UWYGvH3PtlRy+cZGfOeVL6RwJva4nGTRPwjuIEk7h2u4/Q0kfp66sMgvKRYHBxqC2xk6mkf/6D+oBg/I/48hRRHDmUonXusZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFI7bQD1+Z7Hg3Gu4hxnTPqT4wRZj0L/Sx83Bc1Dcq4=;
 b=OJPBTyBtkiviMIb1W6xDGBLpRoBr/6QrhAmKNyNHL86m4FShSlBA7UHPbST6Hmi27d6gn/f7egMPX8Nf7WcgH8DDBCketc/3SQHPCIe1/kocSAAXuhWcSNbgKaIBifchbSugEYfF54kWB8+fCWNc2hlk38MtbhCGEvYsn6MTP40=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH3PR12MB8281.namprd12.prod.outlook.com (2603:10b6:610:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 14:17:36 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 14:17:36 +0000
Message-ID: <53be1078-4d67-470f-b1af-1d9ac985fbe2@amd.com>
Date: Mon, 24 Nov 2025 15:17:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 00/11] Add dmabuf read/write via io_uring
To: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org
Cc: Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <fd10fe48-f278-4ed0-b96b-c4f5a91b7f95@amd.com>
 <905ff009-0e02-4a5b-aa8d-236bfc1a404e@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <905ff009-0e02-4a5b-aa8d-236bfc1a404e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN0PR04CA0141.namprd04.prod.outlook.com
 (2603:10b6:408:ed::26) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH3PR12MB8281:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bd5b9ae-b6c2-4d73-54df-08de2b6437c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3hkdzcyYllldEU2RHNwU0RhcUkrZnRCRzJETStqdTUvTGthMG5aclpwTjBY?=
 =?utf-8?B?a0xoaFFLYlhBdkVRYkdQUWJtdnhLQ1B2OEdIMGcyaU8wR096eURNNG5hRWth?=
 =?utf-8?B?REY1N2tuWXJpL1RyZmhSY3RvQm9ZNjR2bjBYL3VmWE9xeEtJK0h5ekFRSmN5?=
 =?utf-8?B?V1NYdmtWcGVYNXRFM0ljcWhkNlpwYnpGYk5TRTc5dHFHUG43YUkzSG5sYTkz?=
 =?utf-8?B?ckNsZUtxS0pLbUtZMkhpeTNTa2JOSkxsUkxYa3p1Nmk1UlAvSmp6OVo2aE1x?=
 =?utf-8?B?Tm5iNVZlRmV2NmRrSCt4enZWSEFQZ2lkOHJ5ZS9PMllrQmFGWjFySjc4RytY?=
 =?utf-8?B?VklreEE1WnFZYnNqQUlSU1hOeVB3aDBuS2tVUUFNR0RxblhoUjJUTGpGUkxU?=
 =?utf-8?B?aTkyU2gxNldDR05IZWp3eUZuWnVPcmt3dmk5eEtOcU5lMnYvZkpwMFFFbW1n?=
 =?utf-8?B?N21UR01GNGhmMzR6UmtUNEc5b0Q4dUQ5UXhkUUwrT1lXQmlIQy90MVZvUm14?=
 =?utf-8?B?bEZFMWNJOGk4QmUwVFFlaE91TzBUOUhzVGVWNm85aTFjYzNWdFlPSGQ4emZB?=
 =?utf-8?B?Qmg4ckZEM05PcGxqcGFEK0c4QzU4MWFxMDEvL3RwQUZIbGZFbjA0WVFsNHo1?=
 =?utf-8?B?REdIWGwzNnI0SlV6bmcwQzB5S3ZXRjY1ZGx3WkNNdVpMNW1OQVR5VXYwcXRE?=
 =?utf-8?B?S3k3MEkxV1BkWE5NU0ZoVTNycEVsbXdaZXRIMnpQdmxtVzI0RmRkWWpyaGti?=
 =?utf-8?B?NEg3ak0vMmMrcjhQSTZSTmx0TWFpekxIcVJKRVR1UmRWcU9XQjVvdC9FTWVw?=
 =?utf-8?B?SEhVVkQ3dDZVaGlmTTBCakNCWUoyaUZDZTNjeDF2dXRFdVhHMzQ3UTdLZHpC?=
 =?utf-8?B?TlpoaDFWQUdpb0V0dXA0ajJicTE1dE92RlZxVWN3dTJGMHNsODkvM041bmNS?=
 =?utf-8?B?K1Y1QytoaEM0RDhLdmw5bnc3a293SzJRWnNuNlB6bE9Udk9JYkpBK3N0OFZ0?=
 =?utf-8?B?R0dWNzloWjlPWk8yNkMzN2FNNDVnY3A1OWZ4UTVTaDVHc04wMnplaGYveUxj?=
 =?utf-8?B?Z3ZtOVNRVXluNkl0a1ArOUNmMU9WeVB5T1E2RXNORGFQVFgvdk9rd0g2bjVX?=
 =?utf-8?B?QUJZMWhnY1VIb3IxRHE0QnlRUEc3WktHcXF4ZUxsZFNuZmZ3cmVCU3cyT05z?=
 =?utf-8?B?R1dOK1prdUtBUTdKV29BdWExV0RVbU5kV1p0Q0xhVzlxSXVIU2ZZUHJxMk5Z?=
 =?utf-8?B?Tng0NGtJd0xkVnlrZndxbjIwbkR2ODNWbjJGbGhzMlNGSmZpNkNXZzVZM29h?=
 =?utf-8?B?dW1JVFFWTWFkN3RRVUJzZUQybWFRQmo2QU13dnhvdDhIU1c0ZHcvWGt5Vnk2?=
 =?utf-8?B?L0ZnQy9YbjVtaUhqVnBOWGRKVGw0dkRQTmcvWFhmYzRnUGJvcGlSSVBZQ0s4?=
 =?utf-8?B?SjhWcmtDNnc0NmNNQ1ltVXJ1bWhSbVhNT0hwL09aYXRyWGhtTFBQazdIa2du?=
 =?utf-8?B?UUZVdkxGMStOWHh6M3ZmaVpYVXFJVFM2SFlmWkY4ekVYdHhpemtOQ3Avb2N1?=
 =?utf-8?B?T0RJS0hSOGc4UTMyNlJaL0RyYlNXNTdkL0VvMXU0VkhqbnVhSytLdERnbXZv?=
 =?utf-8?B?aENQSDVSUmxuK3pVM1JmblI1Vmozc3R1T2s4UWNoSURRS1AxQ3hoMGkzWXE2?=
 =?utf-8?B?Z2taV2lvMW1nVHNGb0YwUUFlV2w3dHh1OFNUVDVwMkM4OGN5QzZFNWxDZmdB?=
 =?utf-8?B?TXhVWnU3aTNZTndQUFMwaHE5azByZ1dyN2pSWHNOSWRqWjVYY0gwdnZoWlBp?=
 =?utf-8?B?cGJQckFkSlN2RWpvMEtnd0JSOWFwRDBjdHBXNkE2d09jbC9NQ0FCQTgrRjl5?=
 =?utf-8?B?NUEzTkRwS0hZS28zUDVBd2l4ZWxBTnFjYXZ1Q3FDdnBtL2NOVzBMWG0vVkZ2?=
 =?utf-8?B?MjVYZ1lrRTJtbWhlMm4yb204NmRoejM5RDJzTWtZUFFvbGJKVnFBNW5nQWtV?=
 =?utf-8?B?RDZXelFNQm93PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YjZyL25YV2k0U0IyOWlveUp0RTN6MnhTdUNHMzNDV1ZnZEVOWjNuaEM2eXNO?=
 =?utf-8?B?Qnk5b25INHd5Vm12QVBMUWR3U201WjZCUm01WUNtb3czOVpLZnJyMUlqa0NP?=
 =?utf-8?B?Wi8ycG1HUVhxVXUrNTcwODVzSXFxMStrOGlLRGRNOFBBN3N2L2dWMGhnZ1lW?=
 =?utf-8?B?K1ROd3laTFFvZWFBVEUvWDAyaTQvL3A0UGtrT0dUWmhRZW42cU9hc01LdS8r?=
 =?utf-8?B?Ly80RGdOVS9qYW4xaHVZSVJHVjFwSjJJd0NZM2hVSHFuOGJidy91WWNNdk9O?=
 =?utf-8?B?WmVQNDhZOVpRaTNqUy95aFl4YjNleXJGZWlZUEZMYTBjSUJZUWFCV2Ivdi91?=
 =?utf-8?B?Q2xmWnFxL2x0TkZHOEV6MUFqejNuUXdBeGlIVzZtOEdCTjZCcktsR3haZzJJ?=
 =?utf-8?B?N01BTkRFeGFydmJFTHppdUNBb0RTYW9EM3JWcEFCYk9jQ25pbFg4VXFqMUlH?=
 =?utf-8?B?SEJ5QWVtOHpielJ6NlM4WG55ZndGT0VkczM2ak90VktkdDNFck80cFA2YURk?=
 =?utf-8?B?WHoxWm1zM2pJYmNKcmVwekdvUUhYMFBwNmlZSGZQbSszeUpnUFdzdTk3V24z?=
 =?utf-8?B?NFV2VC9xMkk4QzZoejlrSy9KNEsrdXk5WWhIOHU4dnVUeGlHOS9EQjdybXNC?=
 =?utf-8?B?R3B1bU41OFJvVXZFUkx1VEVFaTkzZzdSUHU2Tk9QOS96VHNFSjJhbmpCSXNJ?=
 =?utf-8?B?dFlwQjQwVWJGbitIcVJ4TFFaUldES3RNdlQ5TVlpLytvZi9PR3FVQXFsSU9M?=
 =?utf-8?B?S2diN0xOSEdubU1qcTlLOWNJQzFBQ1RPbllkVkFLc0ZxN3VxTmh4SnByTFp3?=
 =?utf-8?B?OEVPb1ZjUDZSalp4em9MWVZWRmdycG9ZcUFFRHAyZjRmZkJKR3lQaTcxenNQ?=
 =?utf-8?B?bGc0NUQ3RVJtQ2pzQXhTN0pqWG84a0hBaHJDMVlkUmtIMWdNUVpvdE1nV1NG?=
 =?utf-8?B?R2RiK0p5U2xXdmQ5aTA2eDlLNDRrWW9pSys5WEZ2dTB2eUtnL1BnYnhmZG9I?=
 =?utf-8?B?ZXZvMExWT1BpbTF4Mk4yRkpPN0JPcXd2bHk2Nk5kbk9pMWh5SGRXRHRxSjFr?=
 =?utf-8?B?ejJOWi8yWU1qM2d1aFhzZ05vbkFpSXhtMXhDdDZnUTNvQkRkazgrRWlQa3JZ?=
 =?utf-8?B?c2xldUlXeXp5eEtZOGJGVmthTzNIcXZRZmU0YmRwUkZtZ1Z1YkdpY1QxRTQ2?=
 =?utf-8?B?citVOTEwbTduL2dtM3ZGOGtCa1psaUhWd2JBRm5DbEtaU09oSFpwUGFyNU5O?=
 =?utf-8?B?NFlUcXpBYmkySnE5NDk1WmFhL1VDWXIxMmtpU1pWQW0xSklMYk5uU0NyYW5h?=
 =?utf-8?B?WURtK2NlL3BySFpKQ1NPUWEwdnlpbnZXcnlrZW9WUjhOSnlxcVVZd1VKNWRl?=
 =?utf-8?B?elp2TnoyUDd0Rzg3TmJ4RTkzT1ptbWppU2x1R2ltZ3llRUhtVTlYRTV0ZFYw?=
 =?utf-8?B?SU9qSlBUMW0xODZUYnBKWFEwWUNWZFFLZ2dUM0lTWG8ySUNLUGZLRnRhcjhD?=
 =?utf-8?B?c3huUmFTVWxJUjFMSFZ5S2JhdmJ2ODJtU1Ewd3k1cTNUM25OYnFFRzE2bnJW?=
 =?utf-8?B?RjFJd056N2s4Y0ZrdW5jQXQrUFk2MVR1dk14Q0h2WVZOaXp4NXh6bGN4VHpS?=
 =?utf-8?B?bExybEszQlNkdTdHOWI2aWNxNlh4c2V6SHB5b0RVenozTEhCb1pFRkpVUDRi?=
 =?utf-8?B?NEhaYUZJSThsTW5BSEFCMjcydWlsWGd6QnEyUkk2MEZkQXFGWXdVcFVNWml4?=
 =?utf-8?B?YVB0S2NGUWFCUjVzemV2aUxJazhnUjBqWURWUXdNQkFCNnhnQTEyVFJqZUIz?=
 =?utf-8?B?QU9pSzRzZGFYY0pXQWM2UDNFdlgxb3hkOENwTkhsejF6N1JIMkFGZk5CcVlW?=
 =?utf-8?B?USsxd3daRm9UUUFqSW9MRTM3UGRoR0VTdkllSS8rNGVBRkRkSDJsNVdidjc0?=
 =?utf-8?B?QWFNb0tqM21ZZWlMMlNRQVMvdHhaS2RaVFBWUzJJKzR5a1RqclVidzJJYU1x?=
 =?utf-8?B?dGpTamYzVzBBYkJTekdEcVhUTFAxTnhsamxnZVJDTTRLL0orR3NwU0dTUDJk?=
 =?utf-8?B?eE1JSVFUL2doL2lzV3JrZUV3bGFSVDR3dnBGQ2czN0dXdzJLWnhCQVNncUFx?=
 =?utf-8?Q?y5R8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd5b9ae-b6c2-4d73-54df-08de2b6437c0
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 14:17:36.7266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6d5vR5Af4nwoLDvrVipXSuZ3+iXI/Edq9n3TNd1JJNJlYTPnq1h3rDYnCvWo0h4N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8281

On 11/24/25 12:30, Pavel Begunkov wrote:
> On 11/24/25 10:33, Christian König wrote:
>> On 11/23/25 23:51, Pavel Begunkov wrote:
>>> Picking up the work on supporting dmabuf in the read/write path.
>>
>> IIRC that work was completely stopped because it violated core dma_fence and DMA-buf rules and after some private discussion was considered not doable in general.
>>
>> Or am I mixing something up here?
> 
> The time gap is purely due to me being busy. I wasn't CC'ed to those private
> discussions you mentioned, but the v1 feedback was to use dynamic attachments
> and avoid passing dma address arrays directly.
> 
> https://lore.kernel.org/all/cover.1751035820.git.asml.silence@gmail.com/
> 
> I'm lost on what part is not doable. Can you elaborate on the core
> dma-fence dma-buf rules?

I most likely mixed that up, in other words that was a different discussion.

When you use dma_fences to indicate async completion of events you need to be super duper careful that you only do this for in flight events, have the fence creation in the right order etc...

For example once the fence is created you can't make any memory allocations any more, that's why we have this dance of reserving fence slots, creating the fence and then adding it.

>> Since I don't see any dma_fence implementation at all that might actually be the case.
> 
> See Patch 5, struct blk_mq_dma_fence. It's used in the move_notify
> callback and is signaled when all inflight IO using the current
> mapping are complete. All new IO requests will try to recreate the
> mapping, and hence potentially wait with dma_resv_wait_timeout().

Without looking at the code that approach sounds more or less correct to me.

>> On the other hand we have direct I/O from DMA-buf working for quite a while, just not upstream and without io_uring support.
> 
> Have any reference?

There is a WIP feature in AMDs GPU driver package for ROCm.

But that can't be used as general purpose DMA-buf approach, because it makes use of internal knowledge about how the GPU driver is using the backing store.

BTW when you use DMA addresses from DMA-buf always keep in mind that this memory can be written by others at the same time, e.g. you can't do things like compute a CRC first, then write to backing store and finally compare CRC.

Regards,
Christian.

