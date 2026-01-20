Return-Path: <io-uring+bounces-11848-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wOHGBdTMb2mgMQAAu9opvQ
	(envelope-from <io-uring+bounces-11848-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 19:43:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AF67449B10
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 19:43:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 62C918265B4
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC3F42885A;
	Tue, 20 Jan 2026 17:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rn3LyqyH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V+JBrAsk"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A3342B720;
	Tue, 20 Jan 2026 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768930894; cv=fail; b=J7ENyFJW9GdDpKj94n9IfoYg9VOzcdrProgEFe+1IOeGOvCMn5fjp0OHvAivB1lAEQU4ejU8xm33QZdYOEWW8R1gP7kahRvzvqFuCnTInf7Gz9/J/f6lEOxXNropcXvp5kK3b5wl7WKs4f8Vdw1w/ek/jnF90s+WzGOQozVXdKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768930894; c=relaxed/simple;
	bh=uy+yWFIhJMV1Wsit88fk4qb3XnknXN+csjrgMh2cQPw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XFcU0fR1r6s5PrfZSej0cWjslUdYdJivv05HbKDmUea4omlZgYXRND5rDkDMpe2cZ8QM6KdrNqqcMvwz5FVR1D/hCLheLcB5DO3Z2GiCdSnD1iXTmn2YRLmZsh/sfEFW72jWF2Xdytg0EDaVzoFIr6w1ihtKcq1CATKRdlOxBVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rn3LyqyH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V+JBrAsk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K7vBBl3032110;
	Tue, 20 Jan 2026 17:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QcczzG9hzOvBIjeeMUVcB8NeMM6yGg9WFlKoycL1Zyo=; b=
	Rn3LyqyHQuDimLQR7w2sCiBEOWs5VYE8ec606BE4ro7kKS1NAJvPJkQuE4Ud8HPU
	pdZOtARPGLdeC5SIdvkRm2lbZ4QvQn+tGaGxafhUkblBMnwXil+mz2XMPj9aUZLN
	3zbbITAfQEcW6gAv9n8wd/kS8pHzsPt1JQIc+CexPbKdWTRgwZss5RnW6j4FCiLL
	WOvULf/B9riuNlKhR1eHFXPEcHOqnS8DOK0vSx9nZIw15grmg+8SsdPJ8GVyppQ3
	+13BF5QBfvUMUDObQRFvaqu4urYPYfGNL1yZhx3+gkTr80zF1OkK1MN/h7BT+ohL
	yIVQ5yoaTPJ+/Nr1RdT1xQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypv0cg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 17:41:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KGDgE2019003;
	Tue, 20 Jan 2026 17:41:18 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012011.outbound.protection.outlook.com [52.101.43.11])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrqtge8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 17:41:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yHvkLLoUGHgq+963y7yU1lAN3gb7yCV0Bdqo+GfWhk4Yoo4H4S9a40Rz0tjy34EDzoyMG8BWGq8lLHiFvcCgCZXk1Jh8LnXhSsIF2fUX2FXbjYtxFtc02NE0VlJhqSfARLDC3+sb9LR1RZDjwTs8yanVJbE2tb9VUUyvhxcbPYM3+Iye5y8i9aBB2qWhdtaBkpG+0tEfTXvki0VGX/okgZflSy6UQAKNgvEF+zodfM5aFfgMvuwvV5qcBiqnTi2B4u/0u2WSMfQ2UlpWw8/Qpe61Jc3pfxxsqsaBuhX7aKhSCXf6FPjsepn0bpOaKraaTh9+XBPmSV57FXrysFUThg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcczzG9hzOvBIjeeMUVcB8NeMM6yGg9WFlKoycL1Zyo=;
 b=xLUM6DuZYPFeHsavot6q0ddqAvFpfFsYyNfmAdqGhc+MH3ykKTnUggu8nQxEtuacCDStiQw5Ut94uAOhy6d95rirtQroInmBl8psWLKTBDS722fKeTndIL6decEzB5HSG+9nAbLSdoaIn53XNlpQOYbXFu1+zLl96Y/7ivuANHT5EHmCc9n6itGspiR/Xbl4C/Fip0oWdEVM5H4lTpWvLcd1QL5rmPxI5Gy02zpmAY08f/4wVUOWOj4wWzTLHHKb8RzSCXH3S/wp6OntQOqLJR+f1EXjVCqj3smjq/vEXNwZknOlwVn+OiTd3n6SEm0MC098xR4dmiuRRCxfqhh4Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcczzG9hzOvBIjeeMUVcB8NeMM6yGg9WFlKoycL1Zyo=;
 b=V+JBrAsk9oNjqwT46iayqQJeczTWSZShpAU1I1qKG4mIR/LmWTIWBoAq9Q3iNQCkjXeR/hsgamqIKIn59qodD2GGGtQ1xNVyXr+gGrVwg2Q1qmLSNsp746fQpsFVXe3kXEJZiivmQUb6oxfsCpse3ERE0Hb03D/M76LFS+22OR0=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by SA6PR10MB8038.namprd10.prod.outlook.com (2603:10b6:806:43c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Tue, 20 Jan
 2026 17:41:12 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%6]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 17:41:12 +0000
Message-ID: <5f33df40-9d18-4d0d-ba7d-60acef9e1d60@oracle.com>
Date: Tue, 20 Jan 2026 23:11:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring/kbuf: fix signedness in this_len calculation
To: Jens Axboe <axboe@kernel.dk>, Qingyue Zhang <chunzhennn@qq.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suoxing Zhang <aftern00n@qq.com>, cve@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <tencent_4DBB3674C0419BEC2C0C525949DA410CA307@qq.com>
 <b53d5207-0dbc-4e1e-93e7-e51cb6c85383@oracle.com>
 <8c20196c-f208-464b-91cd-c87c22f83693@kernel.dk>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <8c20196c-f208-464b-91cd-c87c22f83693@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0331.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::31) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|SA6PR10MB8038:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ce8ea27-2b74-46e8-f35d-08de584b1a2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MnNuV05VY3A1cFVIZktYaTIycHBYazlKNEliaUhhQ1c2Rnhud1BVdXFmMHJI?=
 =?utf-8?B?UWFPcVhUSXk0NHhmOUIvY1NGblhQUEZTc2EvNGpZd0RZakZZL1NLMFVqWVc0?=
 =?utf-8?B?RVQvcjRHeCtpdzdvTXpwSzRHNjNEMHhSNWN0MkYrVXg3dlBZYlNtdFI3bVFn?=
 =?utf-8?B?aXExOEZqcTc0dEdFY0lKNjFwU0lCRHlTQ3ZJcDU1TWk5bDdEamc3Zk5vYzJt?=
 =?utf-8?B?UEtERHZrTkMzKzI4dmg1UlhPczVEMURUTXJMRThTTk9rUzBJMVVSdG44bEd2?=
 =?utf-8?B?UUlrb0JQY1piUW5VWHlSekdJbGJZRWJXd1d2enBVRHEwN09uT0lnMnllK25O?=
 =?utf-8?B?b1JWbSsvRHBXR3V1b0llQWxEOUpxK1BhdzhTNTV6RFEyQ0czT0xsWGhKbmw5?=
 =?utf-8?B?K204bENJWTRHSTFIS2JLS21BS0pzSDZZL2ZLczBITW5GUUxkdEo5OUxKM1dD?=
 =?utf-8?B?Ni9kWFpmWEFMZDljeXlnZEVZSW4wblRwUUxEdFBUNVlMcGI5d0NoRDRHbnNO?=
 =?utf-8?B?TDJScGFWdmZDSGVCeXFUbVdhbWxUbEdXbW8xcldRWUozRnZ1TlVqUXRxRFZt?=
 =?utf-8?B?YTM1cERQQTFBZVNRNnBMTWVCMVRSNVdjVUxOcGFhTGNUNjdqanNtR3JsUkEy?=
 =?utf-8?B?YVhyNmxyT1FFRkU1TWEyaEFEYm1SNkdwN2s0clE2N1NPM3UzOTA4c0hWNWZ3?=
 =?utf-8?B?aTRzU04zczl5dVRZRERpeE1RK2VhcEwrSnBzZll1dDNlbXBsT3BXTTJVVkVq?=
 =?utf-8?B?T1Q5VHg0R2doWjdOMGNKaXMvd2NDRVlMMjBqblRkbEFxemQ1bU5XWm1CY0Qw?=
 =?utf-8?B?cHI4UFNrVFMxWVpVNnNCRUxpYThRQnZVVWtudHVqMjVVNUUyVG5ETE56dkkr?=
 =?utf-8?B?Qmc0bVI5Y3MzRmUwb0VRY05pVHhIcFdnaG9YWFpnaVhtdTVWcUUxN3dMb214?=
 =?utf-8?B?Z3dOTGNaU0E4R0MwdXFvSVlac2R2dk1jZ2tHUWlaS1pjT0RkdW9EY2hCczBy?=
 =?utf-8?B?cHpPbnlrWGxaVDNzcUJNMjlFem1SNEZBc3JHNmtGMlJDTCsxT08xcU1MbURr?=
 =?utf-8?B?MWRKekNCMytjRjZJak5iVVkvTFNDTG5wOVVuNUJFdlIvSUpMQTF5VmlicWph?=
 =?utf-8?B?V05lVE11QmpEbTdZdWJ3M3AwYnpseURGQSt5enNGN1ZLK08wQkp6RXgwNFB5?=
 =?utf-8?B?dERsQlZtSDliOHRvS1o1VWo3RWRqSFhjemgreTZTTkhFWWV0VnRxdXJFeWpC?=
 =?utf-8?B?K2J1aVV1b2FjbWpodnBhRHM1M0g1N0tnbzRZUVFxK2phYnlpTVZ3ZDlXSXpk?=
 =?utf-8?B?bTAydXp3QTZWd2RiZHdaOGl1eTV4dzJMdzhBRTBzVHowNHR2eDA2L2g4SGFy?=
 =?utf-8?B?Znk2Sjd2M0N2K1NPd2N1WEp3Z25BNFdjZStBOW9zZTg2ZUNSQTQxd1g1VzJT?=
 =?utf-8?B?cG9td1g4WG1wQjBDdDJUZERpdkRNQzlFVnBrUXhLTUpUUkN0elJ3OGptSjJL?=
 =?utf-8?B?YnVJZSsvckg0N3JGelc5blN3dTVlNnhORDdZUkM0WS9JTnBRYXpIUG9QWU8y?=
 =?utf-8?B?K21zU1psZGpCdUNmNTBVK3FrWXdsbzRVYStVK3UwZCtmWUdsMXZVMDFSd0hG?=
 =?utf-8?B?ek1IaVVTbldSY2thY0ExblBMNGozTklMMGlOY0U3VGMybFhoRUh6V1d3aTc3?=
 =?utf-8?B?R3JOaHpKcWMvSFRleDZpUHZHaXpjdzNlaHk4dFNadWt4YW56OEpGUjNvUzZW?=
 =?utf-8?B?VURUdFhzNlVmc01mWGM0WXFoSXI4b20wakVlTWN5YXY0dVRjS3NYWWpQOVZl?=
 =?utf-8?B?UzAvZGhnT09lMnordG1HL0dOdmdFMEVvbWhQb1d4T09KcDdMRjhxSXpPL0pD?=
 =?utf-8?B?L1pDZ0RvME91eG8vKzRnT3VaTnowRUJ3TVYyNmFlMjVINXg3aVYzQTJialk4?=
 =?utf-8?B?aTFFWlQ4S2dsOU5CejNiTzBmRFlNUHF2NUwwN3lIblF1ZVJKWlRGYXBLUDY3?=
 =?utf-8?B?VnpROWIvUVRBOW91VDFDWTErdVB0cjdPMzF0MnZOc1RKSkM1U0M3QkZvQy81?=
 =?utf-8?B?L1ZQWjZBaGp1ekxhZktTek5vRnh6VnltbFc3UytDbzRQdlNQcnBNbkhNMFZH?=
 =?utf-8?Q?GYK0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2Z4cWkxUm8rL3dRMzA1RTE3U3Q5M0RGckp3Nmt5dFllVGpkQjlYV0xjVXZL?=
 =?utf-8?B?c1d6dC93d0pLWEdkS1kyMDhNZ2Y4TTNmSGdNVnNOQ1YyR0xWc2p1d0ZjOFpm?=
 =?utf-8?B?eEhPQzFJMU5oQnc3aThXVWxvYWwxVGMxR3JFQ203ODlubGRzZlZXYTBsUUdX?=
 =?utf-8?B?MGZIMTFleGZueUkzU3d6ZStPNTFTSHFVN3piVmI2M3pjT0tzN3ZRbU95WVBp?=
 =?utf-8?B?OVNERkNFU0IyUTBHSjN1NW54bjA4aDhiWmJ4QWUvQzVsSTc3ekNGY2pnb0xQ?=
 =?utf-8?B?cEhSMVJmcFNKU3FHQVZCbTIreUdMZitlYWFSWi93UFZHckR5N0lLQXBKbU1Z?=
 =?utf-8?B?Ri95RE9vN1NOUjFRK002U0RIWTV0TTF3cHpFNVJXd0J1QU1rQUNwc1dTRXZE?=
 =?utf-8?B?S21JNWxSZnkvWHBEZGxnTDN1VW1zN1VwQTJ1em8vck9JZHFMVElTZ1psLytF?=
 =?utf-8?B?a2JVNUFIcUxsdDJzbkRYZzAxb2RvM01YYWowMG9QcFo3ajFwRDBFekZBcWJw?=
 =?utf-8?B?cUw3MnlqcWx2OTU1N0Y2MDlOWW1xL0RPRm13SEM0K24wSFNvT3BqenlhWmQr?=
 =?utf-8?B?T1F5SHdHSGxwOEw1M3R6cmVSM2xZaTRFNVZKcVQ1bThZWjJiOEVzR05mS1VR?=
 =?utf-8?B?ZzBUQWpNZ0ZTNHNkNzZsMHdKV1o4eDR3YmdScmloeUtwUHFmMjYxQ2J4dk44?=
 =?utf-8?B?RGtCMFpxMHVBVUZjQUh1R3FRQ05OaFNFSzBtVGF3VDdFb3B2WVFSNUtjUmRz?=
 =?utf-8?B?NlF4MDk4VUR0TG5icUl6NHprV0puREdzbU9jOS9pRlN1MUQwS2hwd2NKeDR5?=
 =?utf-8?B?c3BBT0lod1U0WUtSQVdneXpuN2p0OUEyWnFnaUVpSWJUMjNaRUlMcEx2Smxx?=
 =?utf-8?B?Mjh2OHdsTWRIU1paR2Z0QS9iMThFVGtWY2R4TlB6eCtEVWFIYmdKUDduQUw0?=
 =?utf-8?B?SWh0c1E5Rk9ibk44ZFlQTUh1S2N3U3BnckFNd05XQVkxR3BMaXljQ0tFZUVP?=
 =?utf-8?B?ZTZKSjBBaWhxQWpoaHA4cmRJZHlxRUF5SjFoa0pQYzV2cEtaQXBjUThDVkhX?=
 =?utf-8?B?NTFWblRTQS9nRHdFTkQ0TVBoNVhNZGN5blFIZkk4bnFSZDdaV1JoZmo1RkhY?=
 =?utf-8?B?eFd2cDFnQ0JOb2piVUM0NWYwUWJxRXU5aERNZ1JkZUY2ZkVtYjNWWGlZMTdq?=
 =?utf-8?B?YzlvdjhHMjk1cHZnZWdZamFPeE9QbFZsTS8xa1ZCWDEyNEJVTGcxajVtUTVz?=
 =?utf-8?B?MUl2V1pLVEpDVFIzY2xRdlpxbWNNdXhtelFDTmh1U2lqZm5Ra29Vc2tUaHNK?=
 =?utf-8?B?NHk0cjhLUnhKdkp5bHZ6RU0vcUpXUlNlRStxL29PcFg1VHg0Mnc2b2c0OTRv?=
 =?utf-8?B?Nm5PeG4vR0JNUkRFdFFtamMvY1BQQW5GdkJ6UGZ5UXFGakRraGVuSkd0bGl6?=
 =?utf-8?B?Yko5TGwwam9nR3MwWG93NnZtRmxkTFNqZmNtT01HSC9yQ2MvbXFTODRJdzJu?=
 =?utf-8?B?dHZZT3BkcDM4LzlwQ1R5R0xIWHFvRkpROUF2eFVsMXpmb25SK2hmQ1cxYlov?=
 =?utf-8?B?TkRVR3d6TVp1ZUZJVUFHM1owbzY2Y0xKb0htSFh1d1ZweXA1d2IxS3RiUHFh?=
 =?utf-8?B?TzdPalBHazBVMUdrNDFNQitvNWR3em9GSHR3Y3RCb3NtZHkzQ0R2cUx0UmZr?=
 =?utf-8?B?R1RHK0F1VFF6QUZWekRyc2taSktlSWdoZ1NFUUVabzFSNHZqMi9ZZTJiVkhT?=
 =?utf-8?B?MnIvdkNiS1pVUVhHZEZVSHdLa09qbERqUnRCQUMrUVJlbGM1eGx2VVpwRnZJ?=
 =?utf-8?B?dFFZSzA1U3JLRkdIOFhXb1ZOS1A5YmVkYXMyN1NNeW12cXA5SHlhSXdRWVdZ?=
 =?utf-8?B?VlBwR1M4OVVlb0xVOUpueU1WaERSa3ZEeDB5Q1dsVUFtdVdUWWs5S3h5c3BS?=
 =?utf-8?B?VUx2VEJUWHBVV1JCSTN5VTc1Tmdud1I4ZHFKOWlINEkrWVdaMTdzWkUranIr?=
 =?utf-8?B?dk83bk1oMTAyb1FNQmxXeFlMQ0d5bmhXNWY4d0tWNmNOajltZGRnQlBwQzd2?=
 =?utf-8?B?MlQ0eVphalNycUtPRldjOWU3NndGWHRBS3hCUTNFSm1iZmNmSDNjYmp0T21D?=
 =?utf-8?B?WDYwazM4WTVySGdWY3h3NDdhNnFVUGZYa1JGMjQ5TmlIV3FuaFhiWkdwUS91?=
 =?utf-8?B?WlNjQVFyOUxyNUlsTjBIb09kM1FBZ0N1TW1lK2w5TUxvZUIvOW5KRzB5eWY3?=
 =?utf-8?B?R2J3ZTFVcUJUV3l0bksvLzgzaExTMkxkK0k4K1hlREg5eGhjZ3FxNTVETCt4?=
 =?utf-8?B?T001STQybmx6ZDMzbm1zWUxXMVZtUmNqRGZlMW9wZjg1VE9vcHZDSG83Ri9Z?=
 =?utf-8?Q?HY4/wT48zjVSOgnnrWKVVvTmJhCSRNo8ZeMbh?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RwU+6AqtDBikLaMIpu8WYe0ewKYDhWCX5cVu/kHqlbHYIoK88o3bWOvDLsCq1l0eVNk3bglnS9RT4OycixmUZJMMqCu3eNx5J6CBM6NJ+vcQhYgi2FcSpCdJiYDwNvegLUbepsccfF0Vqqtv5uaHAiGhtlbuk/5XBhHxv1M9X+Z4ue0+qCPpJINnsZuIISxSX/zy/bKaTIFBYrHaqao5g52SC5TJPJMHHHMmxFnVv+uvlJyfD5vf4JXKanirkni91I94zsQvPswD+8MTMyhSPrui4ZbRBrShcB2YAcphTZKISTwY09ogu87ifk2nEoE8+DA3pMAyxvzwGnagyHnYCLomoMJeoZoYWBPOJKxFbfA2t0CK5E+pgmpAiJjkVhudXbEBeJrC56nTsHXf/JVi3htNOI0tkzTtIGS0vWxoHdeBi3LEYUndBCUaQr/67e/lt4wqvbzWsv8dJBg1pIKno5rw+3huI3oe7qLs+IhO93ORF7M7H0gMMvFX1B/6MpCkdY5xlR4s4nBdBYTbeQ7KUDD5wXW8TIQ9xK01ZATz+AqJZQtv5bf+kCMKhHkSFUlmLwQ3SUen/xMX7mVLcgIx+jkLZPA6VhZq0J1u1uMz1ns=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce8ea27-2b74-46e8-f35d-08de584b1a2d
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 17:41:12.0186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqPZ1E5sRPCn5S95CXqEZEkBNHU3dYTimNyfdlOkGk3Ke2aV8pQgXHJDq9/vPNhPI0rM62nzzsVoj2oGrl5UQzqnY7dJGJzd9P86ws4C5gG+f9Uz8plD8I1I0JbDrpz0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8038
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601200146
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDE0NyBTYWx0ZWRfX+6e+JnTiWSAm
 DHmsio7HKh/n8wJl6xtwp2Rh0UirEADJOyQvIBT8p+hVkwUv4Yi8I5HBW1/rEr0HDlwYO17d7U8
 j/MK1xIrevsmtmKwYpHw8WKQjxR3G/qWn3X0R+GznSlClk7L3VWabEj2UJZcRDSb49QQusIBUQ+
 xPYu9sBMsyMIDLXLVunWYG/kecmMK5hB/K93tev9vUCSvavEC9VS0vuZpXjIPrxAqL/9kMSkjNY
 E1HRNiA23XkdLyXuAynsfrx00JjKgON1zDzj51VVPB+lHBTWwDF8lAxmBzbrZMhz0+VGm4hppvb
 WxX9OGZU9b4pokPuNZ8Tx3ABXqvlQWq14TLmNTwKNE85NiSKD/NhZ1AdbjaPsYaiuOdh75CdL3a
 S9eOk0c/i2JJWhkqa/G3+wRsQtMUX6m5tp01xM7laHXJ8XH5z2CRnDik7PQ9GhqquVHorgGlfXF
 7eNOkF4j2fqvgl8RabJuG2IEUk4NCz+8GsPKv9so=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=696fbe40 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=nx_HXbBHU9MjGaHMeMAA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: -6DLSezKoBmrl0Q-0Dfw44dphzFkU7vv
X-Proofpoint-GUID: -6DLSezKoBmrl0Q-0Dfw44dphzFkU7vv
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,qq.com,kernel.org,linuxfoundation.org];
	FREEMAIL_TO(0.00)[kernel.dk,qq.com];
	TAGGED_FROM(0.00)[bounces-11848-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[oracle.com,reject];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.onmicrosoft.com:dkim,oracle.com:mid,oracle.com:dkim,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harshit.m.mogalapalli@oracle.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: AF67449B10
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Jens,


>> I see the Fixes tag documented is "Fixes: ae98dbf43d75
>> ("io_uring/kbuf: add support for incremental buffer consumption")"
>>
>> I think a more accurate Fixes tag is "Fixes: cf9536e550dd
>> ("io_uring/kbuf: enable bundles for incrementally consumed buffers")"
>> , Reason: Commit cf9536e550dd243a1681fdbf804221527da20a80 is the first
>> to move incremental-buffer accounting into the new helper
>> io_kbuf_inc_commit(), introducing this_len = min_t(int, len,
>> buf->len);. The signed int here is exactly what
>> c64eff368ac676e8540344d27a3de47e0ad90d21 corrects.
> 
> I took a look, and indeed, it is mis-tagged. The correct fixes tag
> should've been for cf9536e550dd.
> 

Thanks a lot for taking a look, will send a patch to vulns.git to get 
the CVE information corrected.

Regards,
Harshit


