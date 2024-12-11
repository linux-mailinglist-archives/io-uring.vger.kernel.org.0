Return-Path: <io-uring+bounces-5433-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E569EC919
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 10:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD9D51885E86
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 09:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F25D1C5497;
	Wed, 11 Dec 2024 09:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BS0+A72q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LCoUV5Kj"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1861C1AB1;
	Wed, 11 Dec 2024 09:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733909493; cv=fail; b=JiTORPsaAQbPlq/iC0ac4wGuJS1x89nYXmPNVqPPiHHgUPpMB8y6KC5zOdTceMsv+lNkrsF5H8sXaHy5MWyZdNewYziCG+r2PDOA/+SJhZvVVQF6jFVrGEuWrwLA+vwrNOb2zFL4knmSkK2ro82OtG9KYw6m5xjtK9UjFQm8N5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733909493; c=relaxed/simple;
	bh=M7KGjWBWu4HsikZVFGKHXT6wVjmqUHq6QNXKI4U5nm4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lUAbPinH6MrvdUOpw2qdBXxuNn6LHwLlxol9Fq82S/YaVBO5kmoq1kBtdB23MIfeY2UJZByLlzkoIteBxL7tW9GzOug17+sIKHGWgcyYpgcwx2yLt2mIAZLxOOh3OyGGCzMbDwLK0KpiFPR2Qj5warqoDM0yfV/htit3ZH5Ww4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BS0+A72q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LCoUV5Kj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BB8ROVZ000814;
	Wed, 11 Dec 2024 09:30:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=+S/OV7JNfd3LzK9dBTp3O7Rs4xtqEtwSc9DolMM4tws=; b=
	BS0+A72q0AA1y9EmBgHUiPF3WMxBN7SylA66hjENTwXyGA6QJRg9jcjc2WHpsW2e
	MbMItlLCotF9jtcPBWZXuIwx2fPmD1q5EgQ3+2IT4w7I67eRlzWwsKqtKw1q/Veo
	9ErKs9Fvw3pFdqCwtQ3Rq4b1kt1swM2a8SB7MqE1ts8vYPXYdXIHYU5tl5nBBXTW
	tVdzTAhBIuunov84eGmQP+22JrK8i+y9511kDjAeHNuBg9+6JP93H8/48yDflJFJ
	dP4qTBqGq4oixUPWYzv+827FnAwTjFy/II/CBnMxoyuJffYApVoxMCmutj0XqUL/
	RTc7+rVPyw4dJqqJURVwCg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43ccy087xj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Dec 2024 09:30:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BB7Y6GI035082;
	Wed, 11 Dec 2024 09:30:53 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctgy19v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Dec 2024 09:30:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HzceNNk7aVAZo79RHrxiQil/PFqBDEinNZV8ysfmFgRIJ1w07slkPkoqGxG1Jwxpfrytozhn4ieSDv1LNuxnnBmBMJtWDmv7ms8V0PlmeAUfsLvRnMlqVTjb74Xb8PyJGBQOqYL/vTLFLOcTNm1vuC8Ql3AtzpCjZRxV/1tVaPOaIOHyTpABm/XftjpgcAFCBPbuAen1I7DdD8xn97r2sbdTzyGXJkspGpwnD97PkaIqzMx/nQNWFVGAosFvxew+1sUYAd2lLIScvr6XvEJPI9rUWSPGLlmshwWsBDakl3w0H6MJ2mc5JUhlLbgdsdqcz/ZHDfrXhj7voR1PfdK48Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+S/OV7JNfd3LzK9dBTp3O7Rs4xtqEtwSc9DolMM4tws=;
 b=gwKuFNpLKKoX6n0XNHZ9WbrdHnCzTGXo6uATQZDGNaat8lm1H9mO+tp7gZFdNmaEp0kXagw1RtT5GEIYfz+JmjtyPflzktFbclbogNkcx0pstZdRlM1ViHvrovuJ8dzpLQeEtM13j/+Rvx16/Lesq3mQt2+TPd5RHRNmwQhqBTrLZ3FEONy0I7S71hWabXqcDJtZNR4PAtU/Wb1bRmjFacrN5Utct14InHl3nUw4UGGPej+Q47K5ymfMQnK+eTqZ35JXNjrJaBykxvGam2z6skzDjqtU90r+EOZiO6koxjyqZCrBFCMVEN1v2K92lXpSeUVIuDe0NU5M/NadLTYWLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+S/OV7JNfd3LzK9dBTp3O7Rs4xtqEtwSc9DolMM4tws=;
 b=LCoUV5Kjm2eo2vNiNfK2pamFRY66P9jougOOO6nh1QFLyDSgRpTPd1JXzNjbKGZ0BAtkSXphlpx0q5MoNnAFb9BKMq49v5oY66rTFjcL3BZ2U+80WVbUxkn3zHFVV4BOOG5iShPjVVwPCmQ3WT3UdrrPAi/Wl/cjQk2nIhtnSu0=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by CH3PR10MB7864.namprd10.prod.outlook.com (2603:10b6:610:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Wed, 11 Dec
 2024 09:30:48 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%6]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 09:30:47 +0000
Message-ID: <a8964dab-8075-4417-bcf3-87c67fe758c0@oracle.com>
Date: Wed, 11 Dec 2024 09:30:37 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv13 10/11] nvme: register fdp parameters with the block
 layer
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: sagi@grimberg.me, asml.silence@gmail.com, anuj20.g@samsung.com,
        joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241210194722.1905732-1-kbusch@meta.com>
 <20241210194722.1905732-11-kbusch@meta.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20241210194722.1905732-11-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0244.apcprd06.prod.outlook.com
 (2603:1096:4:ac::28) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|CH3PR10MB7864:EE_
X-MS-Office365-Filtering-Correlation-Id: 60e32ac6-0d46-4c7c-5ef0-08dd19c67e7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHZWL0liQnQ4c2M3ZXJySGRsaDd4eUxFMk1KVVZWL2UyVXdSZ2Q2dE54WE1y?=
 =?utf-8?B?elU3QkNOODZkOUxSdnFER0ZCajFhbFVKUzhmLzF2Ri9tL2VHRGIxNkU5dzJJ?=
 =?utf-8?B?elM2TkJGRnJoUTBmQkFwbXpNSDVMcTBzdS9UYS9VdDVJMkZXSjM1bE9nOVZ2?=
 =?utf-8?B?WStmT3RKMk5JYUxhczg4T3cwSU5xeHlsZVY2Z296RmFQOUIrRFh1d3NTWklv?=
 =?utf-8?B?SW1zRjMxaUtpS3NDYVZiSjQwbnBoTGpRQmlJOStvRjB5cnVORVEwRHhnNk1M?=
 =?utf-8?B?RWh4SE85WDYvZjJHSy92MFBmOVVGOHhLaDl0S1FReXRmNkQ5dGltV1dDaWti?=
 =?utf-8?B?NEF2NUJhUHAvcDBhcjFWalVHQ2ZDUkxUWnRHS1VheGc4cTFrc3BrWFBiaTBr?=
 =?utf-8?B?d0ljRzNJaHVncWgybC9uU3VxLy9XanE0QVBlVHlERVZYVCtwR0NRdHZMczFR?=
 =?utf-8?B?K3dxOUx3K3pFRGh0N3hvWjVJcFpncmxIR3RVbDNMMHVsOFk0dEE5c2E3ZW9I?=
 =?utf-8?B?R0M4alVKazhTREdiRFJyeUphRlZrL0dtdFYyMmd3TlMzSUdlNk1WZ1dNU1BY?=
 =?utf-8?B?VWRvOFZ4TXhJQnB1MnRmalNnUFpyQkdTc0tXYTQzYTgwcSs0YWFwRmxYei85?=
 =?utf-8?B?cXE3RzVSeDk5anJ2Q0lnc3BCL3NCeGdUVEgwMnh2Q0gwZ1c4ait1Q0h3N1dj?=
 =?utf-8?B?WUN4Q2FZd3B4RjN6VEJBNzJlczhyOEN6SXVGWm1zTVhudzdiNlRIdC9zNzdS?=
 =?utf-8?B?NCtrT2E3aFFwUzNrakRKdFhYNmdyemNBQXFGaUNHcHBkV3NKSlVtMlpTU2t4?=
 =?utf-8?B?WTkzdWhweUg3THBhalppTVlSMWcyZUp2eFVIOVRVZXlDVWh3Y0F3MGJjdEhv?=
 =?utf-8?B?S0tpSmJ0bFpvK29iU3ZlRVplcVFpd091d0lMaUt6VWNaWWE0L0dseWY5cVow?=
 =?utf-8?B?WTlYQktIcXdqODRoU090K1krMXc3NDlodTE1UkZpK29uTzZteWRlY3hRNkM4?=
 =?utf-8?B?R2ExNUIxcXVYQVFtVGpyekdEbDBZakc4cHdIQzhSb0JvU2VkYU1tL1ltUTVz?=
 =?utf-8?B?Q2lOQm5jT0NENzhPcmdtNWdRQUFFZnZSVTBUdmsyNTF6M2dXMTY4Kzh5dG0v?=
 =?utf-8?B?cFRYaVpwSjBYS0w5NjhvMnhKeUJkY1dYcVk2L0lsU0dBNnN4cm9Edm4wUmJP?=
 =?utf-8?B?dlhBNkY3NG9QcmNLZmZEOFBYMm85QUczd2lHbi9WNUprNzRxc2x6dDR3SHJE?=
 =?utf-8?B?aHA2SEpXMUlONFVueERNRDNSZWN6SHpzOXhvODY2cHlTNVE5NGlQMk5CYWEy?=
 =?utf-8?B?U0drUllOTFpOa09lTEJYZWNNNGU4WHNmZlVFazQwVTlsU01oYmJhQmNhTnJv?=
 =?utf-8?B?aEg0eFVDWVdBaXhrcWRJSXFTazczT2tGc2FSWHpIamxiSnBXa3dXSndzc2ds?=
 =?utf-8?B?blk3ZEZtTldxcUw4djhDZWJRamoxWXJvcW9mVG9MTlloUDk0OW1zclM5K091?=
 =?utf-8?B?MHpabTA3eFNvWmtqK3RJcWlud0xVVkw5SDlQUGZ0WkJsa3U0alBia3U2MU9j?=
 =?utf-8?B?dnBydHlWcEFkUVZSM0JKMkJGMTEzTExxL2RFOGNzS0FXVWoxT3Fna3lBUk9q?=
 =?utf-8?B?dlpZNnhjcUdac0pGWHp2S000YmNwNXRacGdCM3JtR3ZvcndUL3FQZFl5VENi?=
 =?utf-8?B?TjJwZnFGbVpqTWFUdnRNWFJTNVZmS1J1eFJvcEs1c3MvaHJveEUzSFg3dGQ3?=
 =?utf-8?B?N3NzamVCNy90bFFOSTdEOXA1SmxIQnFkNnFjUkRSb0dqbzBEYnNsVHU4VkJr?=
 =?utf-8?B?Tzdhby9qYzB4dTlyL1Qydz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEduZS94RUFEdGxpSUdtdHZmN3J2aUptWEZTbU1ERGFEMG00UGxxUEJobElT?=
 =?utf-8?B?L1o4Rm9YUE5JRmFJZ0tnUkFYbUw5aEFyUllVWk41YWVmZXNmOXlYWUtWOEZR?=
 =?utf-8?B?RDZnc2JLbWp4MUFRQ0dMcFphNTVSN3lYTnFHY0NFcEZUWjlFdzFNNktGTXll?=
 =?utf-8?B?OEE4YTNYMGNSbmlPTlJNaWFTMHJ5S3J4MkE5YjNyckpqR3l2Vm5wb1ZROXdO?=
 =?utf-8?B?Y1B5OWRyeEl2T1RzSVIyTGNkZGVyRDBiMXlVNUVhcHpMRkZJNFJNUzFrV0M0?=
 =?utf-8?B?ZGxmWUY2eS96MEJPTCtKbk0vK2pIT05KQytHZ2ZUNjJGMVFjSUxsaUVaRFFS?=
 =?utf-8?B?WEpVL0JGUzJ2Z3Z5ZGozM1RGMnhvVi9QSWppSXNIekcyVjc3TmJFOFJ0NXFv?=
 =?utf-8?B?emFhb0x3QlFKQU1SSHlnN0VEcEQvMFppRXViWE4rQ3FvZHFJcitGWjR4bEdx?=
 =?utf-8?B?amRScDVJZmN1ZkxZMUxwT21lQ0dxYUFibFRnL29kL3RhbmIzT0s0MXdTT0l2?=
 =?utf-8?B?emJUK3JPU2l2RFZ1aS9QalFKeXRsYTlwZmgrMXNpVG91NDErL0xITWxHQlV1?=
 =?utf-8?B?aVRKQjR2ZStxMzZBQ2dVLzM4b2QwdGZ1aWtPMUk4RC9wbnc0TTVaSVZEMmpB?=
 =?utf-8?B?VkFrbHFGbDZkSzN6YU5GSnhGUDBleGhCSzNxZHRjeDVUbXU5ODJIaTIwc3ND?=
 =?utf-8?B?VlR5SDZmRW9CYjJhd3g2dWw5ZEFyalNpTmFrSm1OVStMUzJYaEpjT3FzeWx4?=
 =?utf-8?B?ZTFxdy96YldHNGFDbWhoNkduMmhqVWQ0RjVRUkNBYy9rOWQ0RWJ3Q2hZUUh2?=
 =?utf-8?B?bURvZkZKQ0NudytKVDN4WVFITGRNWlVtS0xqaUMrS3lOTU44MDJjdzU4emZM?=
 =?utf-8?B?SzJ5Zkdqd1U3dldvY3hWMldYZXdYVnh6aXIvcUpVVXF5THNYUGlSQWZPREh6?=
 =?utf-8?B?MnFCS0xXYnhVWnVXWlpjeTRSTUdlVjJJZ3RUL3laSjJudFQ3U2lVMUtpYWMy?=
 =?utf-8?B?cmRlYll2c1dJWmdVN2FDRWR3ZC9QaVdNTm9mMkl5TkNuN2V5M2I5ZGh0ZERW?=
 =?utf-8?B?ZUtkci9jVjBZeXdINU1Rd0VuRnh2eWo0cmc0L0hCM3cvZWR1ODkxRzE4YWlB?=
 =?utf-8?B?TjhaT0tjMnFrZmxkMjJGSUlVZ1N2UGY5QVd3QWwrN0xSajlYRlRZdTlrcGUz?=
 =?utf-8?B?Y1VRWGpGM0VncjdXeGVDc254Wk1TdmcyRUdqTU9KMkI0RUhUQ0NRWk9LUTIx?=
 =?utf-8?B?QW1vc1FRS2Fzb1pzRklWN3U4K3NVMEpGWXQvbW5xN0lqVEEvTERPZUtoSTVQ?=
 =?utf-8?B?TnBaTWxzTVlyZmN0S0xGNEhKQkNMT0dIMjZheVJzUm1sUmM1allqVy8zaW5H?=
 =?utf-8?B?WmtlMFc5aDlFNW1NUWhaSXEvaXkvSVQ5NWtTNVZ0d2tMdkhTQU5zYnhnb0xq?=
 =?utf-8?B?UCs2V1ArU09FbTlmd0ZRNndZTHY3M2I3bkFuOGhxMDhqRU5EUHQ1WEF6RVRX?=
 =?utf-8?B?SldkMXp2MEJSUHp2K3NkendLbjBLSkpIamFudm8xNzVyYkJsM2xIYnZFWUZS?=
 =?utf-8?B?R01UYmVBWFpZZno4cXpHdXJjWVVNalQ1QSt6b1lFUWJiQjVOcStMRWZyazRm?=
 =?utf-8?B?S3FESnlZckxobG9wZVlZNUovTFdQRUxDMHdhSjNCWlppMkJ2Yk1NLzhtQTRy?=
 =?utf-8?B?Qjd2UE9ESlI0RitsVWFFaXFXdjhKQVJndDlZNmlPSHhPTkhJcEJRNHQ4bjM0?=
 =?utf-8?B?MXFRNkVYYU1sTXE3YXp2dnhSelFudFdWeXByZ1ZpNzlodldpcXBvdXF6T29m?=
 =?utf-8?B?M3krUnJ2aS9SNzhLbHkwUi9MUHc4SXE2ck9pNFM4dktseXdkeFJNWTlWeVJW?=
 =?utf-8?B?L29vS25PT2QzYnRjN3VSdU1ua0xLa0t1NUlnZ1piQWtSQXFidVN3ekpHUmlp?=
 =?utf-8?B?U1Zqc0h4a2J2ZFBBVmg0Yy9mdFNQdDFRckVib3VzRVFIcUJVaFVONlNiNWs2?=
 =?utf-8?B?Z3dMUlF3T2R5WmNMMTRoemlNaE9KaStZc3RHaUNTekxscHoxMFdwOHBldWN6?=
 =?utf-8?B?V3ZqTzNUN0NmaGJGYXE0RThGdVJWRWFhNkErdE5XZjlERWI2U0loZXBOclZs?=
 =?utf-8?B?NkhtejdLbEk3SHZtUkdHdnN5cVZCTkJUdkpqUnN1SUFtNzFVcGF3NmdsK3Mv?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U8VYEjRsldx3COkdNdtQahQLOJiaJbutrrdeY2/uj5j4X1mnoC0B/bvmFammO/vfrl5Xe5NR+bqehNDpKBDNshorsKUqeacJjaizrzb3n9ziBXjz6jq983cFiDheGqv26rh/8PdSeYgVGrN5JRB6gXt2qASbFG2VgXpo3t7LosB94tzXcGtft2uJKG/AWi1W9b4OgCm2CCXgxL6rpZciO3mdokIdpCCVZQTskVoNKgBm0Nw2/g0fMfi4r6dqn8+6kbKa4gULh50gmaPDRXYWDMLfB0ah2lM87QraQ0nsi77TLycjVK0/c79iqgTdFQKRL0FH6qkbqzZUC7IxoUbxfX3xh9fpJzwGVfqATNuLxmS70nlNqun0QRd3OjLIpdz/bcA9cc6E0mHgI4/28MoxNxmyiRW/G+WGV5sJlZ8nn6YtInjiTKkIJwbVo+GgTb3N0/06IMhoTtcHyJGLaiPT6apLz6FKConp77bZvUOpM0WoAvdb2mI9m56cCwm+pjbBKNo/FgWgNMscWTMPm/RUqbV8D1VoJVQIObQJB61fVT/nUmbVdhFaTu5jsOC9EUgPK3lB7iwmIid8h5x6WHD/bfUvX0tx7R79L6CsfijJITs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e32ac6-0d46-4c7c-5ef0-08dd19c67e7a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 09:30:47.5928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C60jI+3LUe+8n6rfMJH+D6AhnxNJvsMylWw8d2/fKS1cYozbB8QnpcuDnUnmTeorSYso06uIkZwjNKtIGeR/xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-11_09,2024-12-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412110071
X-Proofpoint-GUID: JJNmwGRGmdA0zr3zxijunUPwgM2NwEPz
X-Proofpoint-ORIG-GUID: JJNmwGRGmdA0zr3zxijunUPwgM2NwEPz

On 10/12/2024 19:47, Keith Busch wrote:
>   
> +static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
> +				      struct nvme_ns_info *info, u8 fdp_idx)
> +{
> +	struct nvme_fdp_config_log hdr, *h;
> +	struct nvme_fdp_config_desc *desc;
> +	size_t size = sizeof(hdr);
> +	int i, n, ret;
> +	void *log;
> +
> +	ret = nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
> +			       NVME_CSI_NVM, &hdr, size, 0, info->endgid);
> +	if (ret) {
> +		dev_warn(ctrl->device,
> +			 "FDP configs log header status:0x%x endgid:%x\n", ret,
> +			 info->endgid);

About endgid, I guess that there is a good reason but sometimes "0x" is 
prefixed for hex prints and sometimes not. Maybe no prefix is used when 
we know that the variable is to hold a value from a HW register / memory 
structure - I don't know.

further nitpicking: And ret holds a kernel error code - the driver seems 
inconsistent for printing this. Sometimes it's %d and sometimes 0x%x.


> +		return ret;
> +	}
> +
> +	size = le32_to_cpu(hdr.sze);
> +	h = kzalloc(size, GFP_KERNEL);
> +	if (!h) {
> +		dev_warn(ctrl->device,
> +			 "failed to allocate %lu bytes for FDP config log\n",
> +			 size);

do we normally print ENOMEM messages? I see that the bytes is printed, 
but I assume that this is a sane value (of little note).

> +		return -ENOMEM;
> +	}
> +
> +	ret = nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
> +			       NVME_CSI_NVM, h, size, 0, info->endgid);
> +	if (ret) {
> +		dev_warn(ctrl->device,
> +			 "FDP configs log status:0x%x endgid:%x\n", ret,
> +			 info->endgid);
> +		goto out;
> +	}
> +
> +	n = le16_to_cpu(h->numfdpc) + 1;
> +	if (fdp_idx > n) {
> +		dev_warn(ctrl->device, "FDP index:%d out of range:%d\n",
> +			 fdp_idx, n);
> +		/* Proceed without registering FDP streams */> +		ret = 0;

nit: maybe you want to be explicit, but logically ret is already 0

> +		goto out;
> +	}
> +
> +	log = h + 1;
> +	desc = log;
> +	for (i = 0; i < fdp_idx; i++) {
> +		log += le16_to_cpu(desc->dsze);
> +		desc = log;
> +	}
> +
> +	if (le32_to_cpu(desc->nrg) > 1) {
> +		dev_warn(ctrl->device, "FDP NRG > 1 not supported\n");
> +		ret = 0;

Same here

> +		goto out;
> +	}
> +
> +	info->runs = le64_to_cpu(desc->runs);
> +out:
> +	kfree(h);
> +	return ret;
> +}


