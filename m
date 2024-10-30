Return-Path: <io-uring+bounces-4179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D299B5988
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 02:47:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4992284E43
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 01:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82A3619923C;
	Wed, 30 Oct 2024 01:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="frd/Vwls";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wjtCZFcH"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207EE3398E;
	Wed, 30 Oct 2024 01:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730252815; cv=fail; b=eyn15kLnOchqSO7rvZSHuM/7qLf2m9qNaQJ/jkaOiwLrmpWPDxxpUwFYjmWwzZWHbhZXySGTiJ0nDTWUl/MPSP+BWcdCQSYtLA9Ls7oT0RJHGNQWB5e+KsuqAXKlC+b8iGruOyUepFSJbCjDrfqvDZd2SkG7ENob7uEsAFlZTK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730252815; c=relaxed/simple;
	bh=U6KI/cz7s38pPtLtxR5kUgDQDuVDQPrDdWwY8pzWNRY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hLlKKnJ6d7fcZP45l049WfleYScmk7DSR0KQo4rsJJAjAzuEsjYe5pmuAvUWrq5o11n90UocZ/XJdWKYkbgEqhqLcirs2/EA2wXXlXBoKhS3VXzIJBQztgWyb6f53fnltuajKA8/YMqHoYbxU/PFZMfesSmfxFT2qJrritZRL4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=frd/Vwls; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wjtCZFcH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1feKR021364;
	Wed, 30 Oct 2024 01:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=J9A4lfb35gZoVIZXFaeg4PLrqsfdokVMP7RPbs2qizs=; b=
	frd/VwlsbUTQ9noPEJE06C4vfSl39W28nFEkEwuFo5XxzGLL3sifGwqgRKkn8XAI
	jCcEBK/RGYS4S+lCKBz2zMf4yWkaGONcP4z4ixB/sp7UKCbErVxcHE3XtNIzjfQY
	vxo+MRyqJCx05n2SZoZCVgFmIE/IBE+8wsgLni4dLfxQnWgQlRyuuGojn40muXPs
	Bwx4dC3+PKgP+xOiVQPq20uwJ0mE11y0ixcnBXxK5Ta/8bPymI5VcbEtngId2TuQ
	VsgsQlRz/kF237802bQZn21WI043nXhPCwn6P0YUophJZZGKiYkLofeoMnVNWarx
	oGLLC0c9XNuAciJqO2wQmg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdqeuvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 01:46:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49TNSiq9040464;
	Wed, 30 Oct 2024 01:46:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42hnapy2qk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 01:46:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KCvIXJWKWqD4VZ32E6J/M7qzu9QNa7Pds8IaOhuHfmgrCaAAY5ma55d4Mb8r4CBwruJQCrOYNqOMSrIbaUJs6Anoy3y/or2JWzCcTi6nMrsqG5oDqrThZpKDeBefuD36OTfEG0JMo89v35WZh0QQh6qOR8BT/78o9WuSRHIpoy/G5ovjb1lLPN1QtGgiZsb75j0a+42WGxaX9Yd6mC1KF1U0mbjArnvb9ttdPTmSdV/RncAVtVRNyWveXwQ2LUNi50zVbZR2IfVfKC8gq+xVuYY0aqwGxho57K9V/XPepXomOYveIUUwBICSbTwEhlOvcEbehAYdg8tTtJeJr9lH/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9A4lfb35gZoVIZXFaeg4PLrqsfdokVMP7RPbs2qizs=;
 b=zDVM3AgL+J3GuAkPWb9Ty+Sq2cyAV/R5/Rb/Sf/PzQgoD47hC/egPFGD3+1z4h/A1EYciGckdAnymGkav6b2Rgsv8z0l6nJFEWbLh2s49YqiEIlFMzA7HdpjEnHQXEpoz7M7WMwPVt0dZlXK933I0ze+CviUm9RIK3inDk5kjXczV5DLSwQ1iT6fPlgbJp/3M8ovZUlQQ6kE69dxoUypU8WAi/sByrIC4zb3+Xq6X9d2qYkbJ39O9HQQU3d70XJX9s/sERjW8qGcFcequJ1fS3wqSPFth5GrkAZnSNg5vDOzsdjUq7hJc3V34rgnKcOQCpDptxYH4kQa5UL1ChQZfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9A4lfb35gZoVIZXFaeg4PLrqsfdokVMP7RPbs2qizs=;
 b=wjtCZFcHCzvv/5FmwvAptBdRav6/3rkDWWa4S7NLarariUGjXGtN9IbCc3mwfw6t5/9/dW4PXyj181vpefGgHSYcAu/VuHOm/RtU+T1Nmr2U26WTD4SaPJcbP0VlFtTDKXZwCq7QUPF64sw9Bve5jGVKaVEHUqPnMLpWN4qTOVk=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CH2PR10MB4216.namprd10.prod.outlook.com (2603:10b6:610:7d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Wed, 30 Oct
 2024 01:46:47 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::fea:df00:2d94:cb65]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::fea:df00:2d94:cb65%5]) with mapi id 15.20.8114.015; Wed, 30 Oct 2024
 01:46:46 +0000
Message-ID: <a3e107b6-9878-4b06-9b9a-2abf3bbf9a43@oracle.com>
Date: Wed, 30 Oct 2024 09:46:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] btrfs: remove pointless addition in
 btrfs_encoded_read
To: Mark Harmstone <maharmstone@fb.com>
Cc: io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20241022145024.1046883-1-maharmstone@fb.com>
 <20241022145024.1046883-2-maharmstone@fb.com>
Content-Language: en-US
From: Anand Jain <anand.jain@oracle.com>
In-Reply-To: <20241022145024.1046883-2-maharmstone@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|CH2PR10MB4216:EE_
X-MS-Office365-Filtering-Correlation-Id: 89edffec-6978-48bc-c7e1-08dcf884b6bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QnV6RVpra3ZRTVZ0VFZBdFV6WERGSTdvanB4bmkzV3EvblVNZFBIZy95c0hR?=
 =?utf-8?B?aVBEbXpUZ05GT1J2S2NnZElpbW5ENmFrb25MSVN1TERHTU9QQm50aFdRQ2VC?=
 =?utf-8?B?VE5SM1dib25PMCtXSEhBNGJoRmJxcTZVWnNEWXZTSG1DZlNyTVZUN0dZZnhT?=
 =?utf-8?B?NnFrQS9RYnl2NU9jaktXVWZjYS9CTVlUWDhwaCtXcGZhd0w4NTBhdlFTYzBu?=
 =?utf-8?B?czBXb1cwcldjbGRCL2d0MURhakdHeUg1RUU0T3pDa3VONWtSdGpzNm1pWm9p?=
 =?utf-8?B?Nmxwak9wcitTWElueFFTd3d0OWpsZ2ZGa3pJRHZoQ2dCNGtsUE9hNEF0WWtm?=
 =?utf-8?B?Wmk3aHh2ajVpbDd1a20zQ2N4eFVZdlZQT3NvTUR6VTRtcUZMaXgxK1MrZGY0?=
 =?utf-8?B?dHVXUHpJNjVTOTBpV1NRT3dFN1JHN1lWZytrQklGZ2Rsb1RJNlV6UmFUWUIw?=
 =?utf-8?B?S2dDN3VzK04xM1JQSU5PNGZ2RUF5UE8zUW5mekJLZU9HczZLeERoWUhaZkhT?=
 =?utf-8?B?dXBrUGpJY1UvNXJhb3JJSFJFb0NLeUF6WFlNMkEyTFdCYStLTUxmYk43YWRH?=
 =?utf-8?B?bWs2QnBBTzQzWDh0TThiS1Y5akRQUStROHNWa2xuaWxpUmJhYm93Tm5wWFRK?=
 =?utf-8?B?cjNxMURjUUNqRWZCb3ZMWG1mU2VXTDFiZW5UVDFlTlRYVTJHUVgrNHYrR1FZ?=
 =?utf-8?B?RlJWNmZRRkZFU09yNTk5alZrazBrKzFWaU9kMFJMSTI4WE5LUHl6K3dBQTZH?=
 =?utf-8?B?dkREOTdRTmdERkMxOHFLUVZxWWdnM2Z6Y2lla3RDZDd4OE0xQzIzZW51MWNa?=
 =?utf-8?B?NDk3TnJxaDFPTTlEV3lXT3pqVWRZQkRDOTZWZVFQdmxGQ2pPV0kyU0RwVGdM?=
 =?utf-8?B?alUvRnFZM1ZlejgrOU40L0RPdWJQR3V4N1JLb2dza0kxNy9GQVB1TlY3RjlH?=
 =?utf-8?B?SnEyc0s4aUNSZkdNWnN5TTNtYkFIUU5xTnhDK3pEbGZMSWl3Z2d5VlhDUkFw?=
 =?utf-8?B?K2JrNW9zeGQvMTRVbHZ4UWtYSFZFSCt3dWlHeXNlUnoxSDZUV2NQNFR6anhN?=
 =?utf-8?B?algzSG5QcCs4TERoOUlySHFnU21rVVFycmFLdE5aZjc3dkZqd2wrWjNSWGpu?=
 =?utf-8?B?TVBpdHByeWpJcDFNNUh3K2pSNjFpYzB1WG15cnZ1eEorTng3dHNWTlFsSHVX?=
 =?utf-8?B?bnFFZG5ldHVnUEY1bDIycVhsUnMvaTdDSTJCNTcyem9oRzM4L2h0QUc0TXlJ?=
 =?utf-8?B?KzlkUmFmNGlicFNxMDc3TENXa3dSTEJqTG1RWUswUVhoNnBxWVRwTlVwZEkr?=
 =?utf-8?B?K2w2aFJFK1puS2F6UzlRT1c1T2VoNUFmR0pJWEI4TW1zRVhRbmNMTFVzVVdz?=
 =?utf-8?B?SFloaUJHUDNoclNyWXp6Y21rL1RvUEJBSzlBUmNXRnB6TStXRkRVdCttZ1Z2?=
 =?utf-8?B?OEhYa1JQU0doT3N5cUNtNEFDWXh3SE91RUFBdkhqQ1crRWcrL291K2s0dTBQ?=
 =?utf-8?B?SFV6RjJJQ21NNnFIbWxmRk11ZzFISW9nYU5xaXFtcUZ4WkovZ1JjU1daUlhl?=
 =?utf-8?B?eiszRFdYK0J2S2UwNHRWNVRxc1l2bUsvVE83RXZEMDR3enNCMEd6QkNWYVBx?=
 =?utf-8?B?SDFFc0dTQmE4U3cwWkp3eDNaWnBvWnVBK1AzTW93Z3dUWS80M0xTejhDblky?=
 =?utf-8?B?ZnByNHFCRTQ2T0ZMemF1SDluQWY5Qm9mTWlFb2dlKzNqeG9ibk1yQlNYN0RM?=
 =?utf-8?Q?ZE2upxJGdfZ2yuznP2IryollT49fYUih4CGU+yU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0Y0NEJFOHovaDNad0haYm1tOUpmeDRSY3FkVFE5a3hZRXdUbGVOUmdmSlZS?=
 =?utf-8?B?STdQYWg2NUFPWWtKczVzWUxOd2FCaDlSYmdGZHZGN0UrbWZjQ2I1WGV3alBq?=
 =?utf-8?B?TDVCOXdQQ3czMW5mVFp6K2tnTWZ6U21PSUF3dkl6QVp3THRUem15clZHYyti?=
 =?utf-8?B?ZkZxQ2hncVdyNndoeXg2MU80NG4wOW1EeEwrcExRN0pXKytsam9uZ3RPZGtm?=
 =?utf-8?B?bGJqR2lQZ2JsbG9HTXlHb1E4T0xtWGxGcjJHR3hkKzdCYys1N0kwdXNNSnll?=
 =?utf-8?B?MURtT1dIdEhPVFN5N0FIcWNBNkx1VjNCbVlBNG9sVFdiVDh5VjhwdEM5MnBn?=
 =?utf-8?B?WWdWQXlrNUQ2SmxZWG4xRTZBamtaUGxodVVjU2dmTUV4S1VmSzRHeHNxQVFy?=
 =?utf-8?B?c2lFTWUyeCtrb2tCMndjZTVNTnJIemxTQjFFckFFVFYzajR5aXIreVpvZHVs?=
 =?utf-8?B?NGxtamtSKytBelRjTDJmMkM3bTBVWFJaV3dCTWxBeFFibmo4Zjk5MmZJZXRx?=
 =?utf-8?B?bEd4Um9udmVnalJPakMyTkhrTUxVWE1yTmxKa2RBYllIeXlQaXlodlk4TVl5?=
 =?utf-8?B?MlBNMUVkRkIyVGJpNzZKQVQzK0pGeEZoeG9iR3dKUUFQVmpMWERiTmRlaVpl?=
 =?utf-8?B?dHAxRWZvbzU1eEpkNHZUbmQxczdCeS95Tlg3U1UzU3lzR3NEb01NYS83Uit4?=
 =?utf-8?B?UFFteS9zakVHdHZsTUV6SWtZOTFJanhYT2kvRklmdjJYMFdTWTg1bjh4NGZz?=
 =?utf-8?B?YVZZTlp5eVVSK2hKc3pFd1ExdE9VUTJDd2JxalFOd1Q2bHpQdkMxZkIvYkFM?=
 =?utf-8?B?N2NHMUszc3gwdVhMbFkyNlBUNmxSLzJEYzhLLzFwMzV0YVlhQ1ZGS0loNUFX?=
 =?utf-8?B?eFFhTWZiK2VQUEtsRHE4MnlLVTNSSE1JMm1ESlVsMzdJeDkvTDZYczRMY2My?=
 =?utf-8?B?Q1ZPRDBCM3VYclNtdmZhRzZrckl2c3FtOXNsajRiamUybUhIWlVMTnhMdEw1?=
 =?utf-8?B?ZHNsaDFHai9TY0lDay9mK2krL2p6QTRYT3RtZHowL0lFRnRGVG5RQ2d6VGxk?=
 =?utf-8?B?T2l4SzU5ajNHblNlSE9OK3JGbHdISlVvTW43WVk0U3puUkxid3YvVVNNNGpo?=
 =?utf-8?B?d2hhQXEwVnllSUhuQVdUZXdTY2VRUW0wRngwbzJHRjB1T2xMZUViREliTzB1?=
 =?utf-8?B?aTBGSWNoRUxReFIxRVdSTUo5Y29FQkRJT2cwUmVhYjg0QmZVWlM3VHM1VE5I?=
 =?utf-8?B?TzFyMXJWUVRQTTFTYURuUEg0dTdybGtoMnZ2bjFMcXFsNFFKWHp6bll3RFBV?=
 =?utf-8?B?djJ4cHE2Q3lBY1JvbkkxRzhBU0RjWExHTlFHV3hwbzhsajZMejJsYW84eXNG?=
 =?utf-8?B?MlZSMzJhbWJYYkFDZ2dXR2N5OUwwcVNRSTVZaW9HMTBmTWJWZWx5aGZhMmVp?=
 =?utf-8?B?dmVxVkJkR0NTRlQvWE1YcmwwZ3lwbytnUVN2R0RhVFRhU1FYQVhMWFpHNC9V?=
 =?utf-8?B?SFIwMGt1OHcxWi84V2pPelpRV3IyUDlNSDVBTkY1SGIrZnBzOHg3QUVXV2JZ?=
 =?utf-8?B?dXp4NmhZU09xUjB0bCtYK25xUkFwa1ZsUGpvcTVyQU9lZFZwM1pRMENZTUEr?=
 =?utf-8?B?aU12T3VTRzE3OHlQczRxUGJhQytNS2RxeXFLREZXVjQ2ZnN1K1VmTTFXQ2xa?=
 =?utf-8?B?K1BpMFZBLzJFVGFPM1YvTjZpNnVXYkpwcnVXN0ZEbXBHN0xOVSswYWdJTDAx?=
 =?utf-8?B?eHNoSmJXNG9tUm5OT2toWjhxN3FvNjBUOXdtK3lvL3VIOXI5aUFkQ0lmdmpO?=
 =?utf-8?B?RnV3MjEyWjgvWDVHTDIvbGdWdnowdlNvVnRuRGgrS1M4NENmbEhQWU1jODVB?=
 =?utf-8?B?dVVVOEtkR0VXd2NxSkNRTkt3VXdVR25aT0lRcExWRWowMkVRWUlTdllDNXJl?=
 =?utf-8?B?Ui9YenFkS040T2RvTnI5R0RrbXpCZVA0QnUzT1FOMDl2bFBYaWhLT1I2T0lq?=
 =?utf-8?B?L0hRVzBrZkR4VVZLMHFyTVV2M1EvdnkxSG5tek1HdEs5YzBtMVlEQ0h0RUlW?=
 =?utf-8?B?dS9WdWhQUWdEWWtkSUNPUXlFcTFjUFBaaVlnV2RrM3NnWVVaeGZTdkpKUzBT?=
 =?utf-8?Q?Opilk/8Mn2aa4Qq0NEzMsXpO9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xcEU9Ln41dpsB84VN3dtwq86CNMznzfwXx1519OkqU8Isd6UZZEg/hR9T48hcQcTQJqG//9FIxj4CVOAkaszWo/OW0XAdhE9gjJLbqSHyZ+1OZdGULpoQJwvrJnCqq+yJdL7OjD3fbPusZ2qucK9O1a3KquFaCOqBgOlAoVDyO7lPIJoImfWsbOeyoMrolWGvpDyEpmGhQ+cgEMtWxeSodEIaLLf99oK7q8Ktg56cJA5BFepakuv5xpdj9WcSS5jTkqCXilfjbwtmnOb1GBWN7h2LEd82GRQ0ty41sUDIgWYiwYrHspLbUbClrlpQvOoQLhOvaSodnTfJ++ZZvEjx6l7pmox1PGivEDLw9quLlM85Qmmtiu/V7bbJ2LXEvVqcfm45IFvkzBYvRg7iq/0g7nIolAUI7VkGO19ePhe8/4Dr72oYVDw+C6GYkVufe3J+xOYyFS2Vsn5UbHNVXZukz6G4g7bObyypmpjU9Lx3mRw7UYtudkBifvldBN0CwVttUKBQj4TdXyr1gPUQ4BHdsn0T4AIIP0htYEhUDmbbTcqc424AH5H7AUCbcud/bJH5QJMZgXQE+LhqsQPan9VyCpktNz9yOh99CnQSlW6Hvg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89edffec-6978-48bc-c7e1-08dcf884b6bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 01:46:46.8540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FMd3GtzQrQiJdjwnqIEWfG863aeClW+fJ5rZBrSRpcBRe8sbVAWYEdhwxYBTpBCSgvE69PMDazRunM14KZ40yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_20,2024-10-29_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300012
X-Proofpoint-GUID: Ej4T4-U_hRqjKKlbsUYkM1tCiTRAshci
X-Proofpoint-ORIG-GUID: Ej4T4-U_hRqjKKlbsUYkM1tCiTRAshci

On 22/10/24 22:50, Mark Harmstone wrote:
> iocb->ki_pos isn't used after this function, so there's no point in
> changing its value.
> 
> Signed-off-by: Mark Harmstone <maharmstone@fb.com>
> ---
>   fs/btrfs/inode.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 7c5ef2c5c7e8..94098a4c782d 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9252,7 +9252,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
>   		ret = btrfs_encoded_read_inline(iocb, iter, start, lockend,
>   						&cached_state, extent_start,
>   						count, encoded, &unlocked);
> -		goto out;
> +		goto out_em;


Proceed to out_unlock_extent; free_extent_map() has already been called
two lines above, and %em is now NULL.

Thanks, Anand

>   	}
>   
>   	/*
> @@ -9318,9 +9318,6 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
>   						 &unlocked);
>   	}
>   
> -out:
> -	if (ret >= 0)
> -		iocb->ki_pos += encoded->len;
>   out_em:
>   	free_extent_map(em);
>   out_unlock_extent:


