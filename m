Return-Path: <io-uring+bounces-10337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1883C2DD06
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 20:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA60E3AA3E5
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 19:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34754208961;
	Mon,  3 Nov 2025 19:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZaZe9yBm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HDtGljkL"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D3B347C3
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762197229; cv=fail; b=X82pYoG7bmvbS9jr/z+HI6mYHlN9HEteTZbB2oU6IICSwIoxkZkFxgb/imP4qmdJHJwZgbFkNqj7ul4KcF4983pKWy+ylsc+WwJwzKLE51t5Gz6c35TZ5SkU92id7TKrio0rmZQIYZ/SaEwkN0fL7xQjye1vYl2nCt0P95oLAzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762197229; c=relaxed/simple;
	bh=5/e2Nx0RaClUhdcXjpSIgbdh9m45S77qxd2Q/2ERER4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P0FWRD/NG4zmb4j/GEvPAx8iIHLdzsOhHwuEIAlLueoNqFlgvYvJVJ7rcBPKQ7kY6S5xqF3ct11tzMFDK43+W7eq5ERC7pob1z9O03KtwjZOyh5EMEm1JRKDuN8RoiX4Kc0d0/g/ylAqgCryT84V2lrVB/Go6XnrOS9t/u/EAXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZaZe9yBm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HDtGljkL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3JAA8h004164;
	Mon, 3 Nov 2025 19:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rV3J9OVtC7Tm+TIYiSp8vsyfAPUwNbGK6sTzb46IUPk=; b=
	ZaZe9yBmZkHTsZQlCCDxuFCi3TK/rP/A8laLmnpozlMLq6y8HwlF4aM6ooKQxVEX
	LE2XQrWM0uda7kFEBl6FUGQ8e8ob/Yyq0ew3PotRowieT35Yiwl+K1xlzEM+kcel
	gZaJZ7FEYX2XJnujqbx9caYPss8sfbxubchu4uu+bPHbtBPG+N/Zr1I7q6Swkgru
	4QwiAWHJAIlDH4q1knmLddo+I0S+SjJfPGesQrJY4rbt8jMtwOK60ADR8P55jGHa
	uqjju9O+YWyTAtyJTlSiWpEFQUhUE/Ex/iMaI35hxyaizRmycGXsJRoIgZKZNkYz
	PlkNPsyLz6bFPp513PVSJw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a72a680a2-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 19:13:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3Ihs08015645;
	Mon, 3 Nov 2025 19:04:20 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010065.outbound.protection.outlook.com [40.93.198.65])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n8asg1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 19:04:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A1RCAcUWuIS98m4mZwzk6bjBJvTaSzzZCYUJjP/w49Wd8CeDiuWZWHNnkEmxerFVe2TPVbbkAUYXa8dz1ulcOJOSwn/Wqrp0skXlzBHMciw694376fJ3LdsdaWqPAci+t44xDSR/ZlmbcuQoZcDrdU6Q1rJ1ujABgjQpIqQ3uGdsdEOZ2waZvwvu1btoE5TCm4fiNOkeREMyavQv88yMIVspcCSTmCt+9H2yvMnMEzQiOl9YvSn5bxodYsKjo0MrPpfULKoFy3H0rOcLK9uCJt3t89Sd1020FHG/ZdLP0WTn49lLNB+w0zcCLFlbxaUBOgSlB55yRh759/EXxHbK5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rV3J9OVtC7Tm+TIYiSp8vsyfAPUwNbGK6sTzb46IUPk=;
 b=P8N0k5/jLm1GaEDi+HFLti+cN4e4boiSALUqvkf8Vy5KR+yoG9tZitMCEIYJiOMYjj7bndpn58u2pDBTXiEfp+1YeJX1t4v5VDJUjcGtbUcAg/Al4b7b1oQ48qkflS2ro0EuY6T9bIlHaLMnUHso84zqi74ds6rpEpvh//41pmfaH1xJ7iRx4SY2wVdjkuj3oNplrPpm6BUszCsz9LEwcke7UT0Ul4RU5/bCYwa6x1Mt5pPXcfEHqTR09aRHjneKNceEAVhAB/a0Zk8AkHJseqgeP4ZYoQPHXtW7CsJsgTWmgr8hNMy1U2ODfiXu6Y5rhXWq2xxToszFPUtAFOnG5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rV3J9OVtC7Tm+TIYiSp8vsyfAPUwNbGK6sTzb46IUPk=;
 b=HDtGljkLWsNNnaw9mgKK67uuqRt60Z+ImHKRoVSJ7EyAWRaJiOB1y0Sopqgzxxf7ukRNpXyZJ3cCrPXI29G9xAgkiXgDBo95Vf5hsTi0iZqn+wrauIH8LUZcI2ar0gjL1+MdgTxUE3YgwOWFEknctKPHYMyA7zbUL1C+ld5pXkg=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by IA3PR10MB8321.namprd10.prod.outlook.com (2603:10b6:208:575::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 19:04:13 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%6]) with mapi id 15.20.9253.017; Mon, 3 Nov 2025
 19:04:13 +0000
Message-ID: <89be5d2f-abf0-4943-9799-7347b60ee2d7@oracle.com>
Date: Tue, 4 Nov 2025 00:34:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : Re: [PATCH] io_uring: fix typos and comment wording
To: Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc: "alok.a.tiwarilinux@gmail.com" <alok.a.tiwarilinux@gmail.com>
References: <20251103181924.476422-1-alok.a.tiwari@oracle.com>
 <a3a7f07a-50f5-4a07-9b14-4d9e41a82586@kernel.dk>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <a3a7f07a-50f5-4a07-9b14-4d9e41a82586@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0418.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::9) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|IA3PR10MB8321:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cff7e66-5325-41ca-e185-08de1b0bc706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azkxM0pDTTgyY3FIbFIySGh0akZXSGpIZXM0T3h0UW5pWkVBa2xyTnZFWVdE?=
 =?utf-8?B?dGdIS0FQQ2xDakhXQ0pVODFyV0NhQzFaWG4yd3d6ajdiUTFzUy9jQlRGaVNo?=
 =?utf-8?B?WEE2SWRtNTlMeHlaVzFQVnpNejFEenN1SjdoeEhDVDZEbkZHa29NQjRhWUcw?=
 =?utf-8?B?YzM1U05jeC9UbEQzNmdXbEczUTVwMzNPeDgvcFVjdWFqUWN5Z29BYnFlQXVL?=
 =?utf-8?B?dWRkcS9GUmZpSDlCUWQzeXpNZ1g5MFlqYTRUYVo1aXVOV3JXektIV3BkL2Fw?=
 =?utf-8?B?N1ZVbGIyZnNKN0xzclRkRDNrYjN5TnRhYUZ1Z0o0c2lEY0R4SGJaTXpBOWFv?=
 =?utf-8?B?TmJzbm9NSEhqRFdTaGtzdG1BNWZ5V2tzQkxDRmFWR0FKYkltZllIRDdYcmsw?=
 =?utf-8?B?aW1jTzJWZFdlVnRqYVNmWUF2MWNLdzZMaXVSMGRtL3JMdC9PcUE3SUYvL3hy?=
 =?utf-8?B?ZlFJM2lLdWZPYjcrRzBJa0JvVTVlaDNZTWxKWDVwbUw4ZVdqNmNJaWsyb1g3?=
 =?utf-8?B?TEt4bk00SG01NjdUaDNuQzM5QkRjS0hoZEl1Z2lMOUNETDltQnJuYkZRUXVh?=
 =?utf-8?B?UlkyVjB2Z1JlTG8yL2JHMWR0VVR3RUtVUDhlNy9jamRnSUowZFFodHgva3pG?=
 =?utf-8?B?OWhHWWlvNHFpTXBiYytYRkJKYU5FSENaZzF5cUgxbnNvdGhSTmlCaTA2UEta?=
 =?utf-8?B?Ymx1VFVUUkR4Q2pJTFFySnlSY1p4QWhCV3NJMXNWMWl1RG5WM25vZTJ1UW5O?=
 =?utf-8?B?enVNeTV1alVIRkVQTElzTFJFUUNwbHFDV05RVVdYeVMweDZqU1hUc1pYbktR?=
 =?utf-8?B?cWF2UUhqSW8raG5JMno1MnRqMlNhQlc1aWpwT3A4UTlHcnMrdlNPZkhXTWNR?=
 =?utf-8?B?d3AyVWtETzRZOWVXN3VxNHRxb1VaWmxmOWYyaUpaWTF2U1ZDVGpLTlFyd25O?=
 =?utf-8?B?L2ZRVWt2Y3c1UlNNOUdPVEtKYm04TktTOVMzSDNDdkdvNTdzVEozbXR1ZEI4?=
 =?utf-8?B?c0tQL1JuY2d5Y2JOUC9QelJsMTFScXJFcjUxTnRsOXNhekZJMlFsbFVXS3h4?=
 =?utf-8?B?ZGZZUFNkMG1QRDRIM2hTSEdaVzEvcVpMQjlXcm1UTWxIaWtvMlpmUVJycytN?=
 =?utf-8?B?MHJrT1l6RWx4d01NRngwVUhzT0trc0d5TlhBYTRTWWdGM3FYRG9GRnRPMFA1?=
 =?utf-8?B?RU1GeW9OaXpmQmcxbXA4TldOenhDTnhiS2pQMGYrRDF5YUJqaUgwcDVLUllC?=
 =?utf-8?B?SUVTU1FCT29pWjY0MkhaY3g3Qkl6ZFZzSUtXUHAvY1pDWkMyTFZxSzQxdHow?=
 =?utf-8?B?Y1owdThxYkkxMDdmSHo1ZWgyZnptWFFXVktpUU9LZU81Tk9mQ04xNjNXRVR0?=
 =?utf-8?B?YjRmSS9WK1BJdXByNkg2ODg0UjJhSHNNYUl0bnJyMW0xM0tSZHhocHZWdk02?=
 =?utf-8?B?b3dLNVVIdHhWQ2pjWU5vQm5DSnN4UHVHMEpPRmRHdFFYbUxHaGVpMFU2Rjhh?=
 =?utf-8?B?amI1MVhwRWl1bkNTWk1XVFJaL1Eyb0NtNWhsWmVkWDluNmNyNUlGbll3QUZq?=
 =?utf-8?B?RjgycVY1Y0lPMGNpdWt3VkpscEpUTk0rSEVzWmYwWHJncWZNb0krVjdWbUEw?=
 =?utf-8?B?ZXdsQ0tZRHg1Smp5M1RUMnBDODlTa2c0bHNLWnd3NC9RV21WaVdja2pxaWpW?=
 =?utf-8?B?VU5leU1rb2orS2VoMWtqOXgxcXRUTDFqL2F5RUlCOG9WZlNueURDUUxwdnFn?=
 =?utf-8?B?ZytnRll6dWd1R1NhZ2FkYnZUNjFFS250V1o0dS9QY2IyL0J1bmdKck9XTzVr?=
 =?utf-8?B?K09uTFZNTlFkWXVTVUlpSWEvdGhtcGR6NmVrQXRXeDRMbS9RUWtuZElhTDky?=
 =?utf-8?B?QnBFSEx6cVFrSG9ReXRXNDVrV3dreHNiOEVydW9UZExzU3dVY1BxanFtdlMw?=
 =?utf-8?Q?7AK4Wjo5y578ySgb+fuw+2QSCUpQjhse?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZS93NFRmSTBPaExtazh5YXd1K0ZXaGt6cktUYWw0SUYwWU1xV1grellzTVgr?=
 =?utf-8?B?STRHY0RvUmlGbDI2S1hwRGUwdlBvdnE4ZGxkNzR0QlEyRHBOeTlhMkJ0d29T?=
 =?utf-8?B?SXkrMit6R1ExWXZYQjE2YytsWmZOTEJUTThyZm84cEN6a28xVWVKTnU1cmxk?=
 =?utf-8?B?RjZweDJuK2hISWpKb3NrMkVwMVJvODl6OWNSdndWTUk0QU5hcmVpeFlCTUUv?=
 =?utf-8?B?SjcrbUR4RVlwd1haSEl5ZmZGU210NmVqTHhOU1g4bjVsMTJLamZvVVNxejhk?=
 =?utf-8?B?TndxT3pMbS9tNmRlRWpidVJpdjlEbnhLL1BiQ01mbm5lMVNvNUc1SFZYcmx6?=
 =?utf-8?B?U0QyOFNiUWZFVmNtVHVmQnMxeURSOHVUTDR4MW9JcnB6K3BoZE9SZXl5UlNO?=
 =?utf-8?B?RUhXUjV1Yk1MT0tTVTFqbHdIYUVEUm5hUERMcEJGREJGd2pVdWg4MzN5eXJs?=
 =?utf-8?B?VzlKa1M5eUdJNFZra0xOUkhkUnQ1QUdyQTBYV3UxTUtjdDFrVmkwKzBJRzQr?=
 =?utf-8?B?UmVpSEp5Q242WGYyRXBIOWZGNk4zdmhYcjl4dFlHdllDWFhGZmhQcitVdGw5?=
 =?utf-8?B?b0Y0WnVlaXRSdkdQRHZYRWZZTzQydnRiTHBlTWV4RzlvM1ZtY3paTmxHVWMr?=
 =?utf-8?B?cmFEWFF5ZzZjRHE1ODhKM2V1Nnh4dnZpWnByQStLdEJNVnh4cnNTQmpBMGdT?=
 =?utf-8?B?aUxaRDVGYVV5ODZkQWZEMjl3YXBNaFlFS0haUGM1cndqUU01ZFpHUnZjYWZC?=
 =?utf-8?B?VWc5MUxtMlNtRUpCWDdCOS9IL2habVVzdWFiTUh4dG0zbktScWptdG11Nndy?=
 =?utf-8?B?dEFQSXFGcXdpWml3L2hzVllDWnd2cXFvWnNrbXVEbU9Pd2NOL0NsSElwOXl4?=
 =?utf-8?B?Mkd6d0pXSmFnb29QMnd0SG9SMC81MmRWdGdLSnZsTlZyOTJaVEU2YUQxZEZn?=
 =?utf-8?B?bERsenZtbnZIanNqZVVTcVl4TDZma3FYQWhLaXFtSGZTMytDd1gvcndSNTli?=
 =?utf-8?B?TkNKelcyVFYydnR2citFRWJxdjNIbXZiRmlETDBxTFViZE5JQzB2eXByQTR5?=
 =?utf-8?B?RVA3MnBCY3hndDhSTWl4cTUrVmJhb0xGK1k1bWtuNkVLN0g4UU9OT2EvZHcy?=
 =?utf-8?B?OUtkSlZEbWV0K0sydklTem1oWU1Ea292dVNVVUhpaEtqTWJ5TU4zNUdVMGJR?=
 =?utf-8?B?bWtoSndpZUw2SDlHbGdTclFBWWdxNS9oZkNZTjQySTJnVE9FWG4zL1NZV0NZ?=
 =?utf-8?B?SS9pZ0dUM1o1MlR2UjZNa2U4aG1hdTZ0NFlUWW5ERUV5OUQxOUhyUVJLZlhn?=
 =?utf-8?B?SzBrQXlHNmN5SVh1UCt0aWkrNDRObVVEUjVkREpoUDBYMERwNEQ3TnZ5UGcr?=
 =?utf-8?B?eW9rTGtGY21iT3oyN1lmVVU1czAvQlNJTHVtcmJFQTJJVU1MbjkwMklaR21i?=
 =?utf-8?B?Y2tVUW5VNFVGLzlDSHhES1VUcU1jL3pobk05UzR0TTllRFJMMXkwb3dGVzU0?=
 =?utf-8?B?Si8yYVdkcDdCYnpLTlVIT1E3WUpLdlZKVEtyc2ZKQWtkb2xMMDJNemFpU0Rs?=
 =?utf-8?B?WC9SQW9MMkFaQzdYcmIxTTZEQXVuNllHclZCdGNlQkUzeTNDK3l4ODdldURM?=
 =?utf-8?B?cjdlWWU2a1l0NnRDMDlIWkplRnd5SGN6eTF1UkI4a20zemFaVFhDTUt4M1ZZ?=
 =?utf-8?B?QjhRQldYOUhxRWNZQzlSblN2YXF5QllhTmF6eXNQL293QXZDdnZyeVNMeEZt?=
 =?utf-8?B?WHFmK2VzR3htT3pGRW9hOHVIbTIvQmgzQVQxdGpVcFpZZ2VoSTh1TVVwZ0Uw?=
 =?utf-8?B?NFJkQXlzV1ZnbS91Skl5Mnp4L1U2cm52dGRnUnkyQW5sZFFkRTEzdjNsc1Zi?=
 =?utf-8?B?cTRlTWdCcXVxWlZvbzdvcS9Ib0RkdEJDS2wwV2x3SzgyV3lsa2o0elhOYWQw?=
 =?utf-8?B?bGYwVloxZFpwWEJrMUh5bXdYRzRqOUIxOHlabUg2S3RwaTFYN21pQjh6cUdL?=
 =?utf-8?B?SmdOV1RBQnM1OEtUUlhLU2RGUC9YbS9aOWt5cTNYTklpMHBtVyt0Q05lMndE?=
 =?utf-8?B?bGNZQy9GdXh5SUFFZFZLaHgraTViR3lSOFpvSUxid3V1RWtaTU1OWVhLOHhj?=
 =?utf-8?B?TVVOZlk2R2xEUEtUNU5rM00xd2QzY3JIUDVsQmVWRlZIN0hZRGlYMlptNXpk?=
 =?utf-8?B?WUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FMEIuq7b+VAfJgTIrQ2aeLbMlM0TwUzCkdqTQr7HxL/m4rKSrm8HP19gdJO/FFK9rK7AKNOAXryC0KaePhPqUIRBv1Ktmh72jRLA6kKpLonMEfViJu+UQfqoXIU6PPUNuI9H8zBMLDU3+l77/BKZq21od0kEFT5vuZNPgQlxsNG+m6C4G7JDqUDvURjybNbJ2OehHSNYxIt9ihDLj7o2f/sYuIYo3Luq2XUPDpD3ABHU/wXZ00uHKgCC20t0PVKOQciImYzKwB0xATR0IMbzj2DjROwkHkdoFxSl19sbrX2dlAUkcA3W2A44cV0H5sPw1EprKFpEqjlTJu2FJkGxHjshV/PM6WDBDgU7AH32vFP9em9HGGOsGXD9wV53H2qIIIiQ41xvFy9alryHShLO31IFFx43DDxYLibdukpRmA6WyesOXVVIYxatd3OtCGAUXiIkzVppKtH28VGtnjzV1KCA/+1eH0KLbEaTFpw+0Zl/ZueKuELvXWFwHRmNra6oT8YxsZ2yB3AtVkrJyOiWBeGt/4taQ8qkrSA53u/ITzpfPYZ6OfpTdGp5iz9e/MIW0u2GVQuF/Xe4dS2Kghhe7wZc5RGVKKAj0ahAeL9qJ4M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cff7e66-5325-41ca-e185-08de1b0bc706
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 19:04:13.2985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PcuOKEOSrM1BKjgs3f9HdY96ERFrWA2niOKp5p+ZnfTOB2+UawBhL8gIMmb7l/B3ecd/Es90jFYUzbVhhmde+LOuIvhsfHFIIVPxIj308yc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8321
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_04,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030171
X-Proofpoint-ORIG-GUID: taZMOmoPayyTKUL_dIrUhpxHnbnVw3d3
X-Proofpoint-GUID: taZMOmoPayyTKUL_dIrUhpxHnbnVw3d3
X-Authority-Analysis: v=2.4 cv=Sq6dKfO0 c=1 sm=1 tr=0 ts=6908fee9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uddo75JQK6evQ6O1LjgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDE3MiBTYWx0ZWRfX1VK2xj7B7DG8
 yD2QdRuVZJ9hQxw4g3SZaWuGWXDbuMUojTEbRshzWvnbljvECBRbNkmlUw4td2M6AkeBlgdogM9
 38ybo6EsSC/lH5zjC4TDK+VWINc9Gm1f85fsb6IGMEjVfA0YKv+yJJ3QjjUl0m5jK/EGH90keUt
 vTACNY8eCgFFuGWk/tllzcPoEBYfjMSeYMHzWFzGYsFaT+y7oGo0T/ERxENrv9+EBdjN49TW6ce
 P6dmXkkaWblq0wPQ18i3aZLn3yw7mmpkZlkLcIMXy6CvPAyQ/xoovW1PqeJ+1AX4ayPX77znZXW
 Opl8RSFwIp2XSKN/GxrE3GEElDvg20kxB5geZzf3JRzX4MDYraiZCkQKleeyTTO9p68uRSGqom5
 To+NKWNXfkGEtBNaRhA2gpyNsHocIQ==



On 11/4/2025 12:22 AM, Jens Axboe wrote:
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 296667ba712c..59062db89ad6 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -915,7 +915,7 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
>>   }
>>   
>>   /*
>> - * Must be called from inline task_work so we now a flush will happen later,
>> + * Must be called from inline task_work so we know a flush will happen later,
>>    * and obviously with ctx->uring_lock held (tw always has that).
>>    */
>>   void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
>> @@ -1246,7 +1246,7 @@ static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>>   	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
>>   
>>   	/*
>> -	 * We don't know how many reuqests is there in the link and whether
>> +	 * We don't know how many requests is there in the link and whether
>>   	 * they can even be queued lazily, fall back to non-lazy.
> Should probably fix the incorrect grammar there too, if we're making
> changes.

Thanks Jens, I'll correct the grammar as well.

Thanks,
Alok

