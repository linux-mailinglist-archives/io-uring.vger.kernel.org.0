Return-Path: <io-uring+bounces-2136-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61C128FFC07
	for <lists+io-uring@lfdr.de>; Fri,  7 Jun 2024 08:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD43D1F22930
	for <lists+io-uring@lfdr.de>; Fri,  7 Jun 2024 06:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23DFD152182;
	Fri,  7 Jun 2024 06:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CKCh7bW0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lIThsu1G"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648788831;
	Fri,  7 Jun 2024 06:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741023; cv=fail; b=DGNRfT1liBvREZUEJ/CwtTFMIZ988NEw6pg1RFwGbyoElUqytR0bXYqg4nhZt/AI0R+fMu1ejtNVySHVOi1udfbJqNoyMKZjFLZRfBzepZKJafp5bQFiFu9R5zq0241x+qBVPTD50JBg4U6BJNQ+KxghKRfUpwsaLw3rAi7tbvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741023; c=relaxed/simple;
	bh=R93/ODxznZd5/NC/8Xg4lsgQF4xdfwX2kNoH7cRUfpk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uZfLyhBFuDzJrohxNFpDptDq+5k06Qh1yVWFifgIu961b8dFhCtQKJdIHl/TeOSJ/Nge2GjJK9opAPhUevbI39AP6WmKgE42cRxor6rHEIfnNkjUWDjg/nS+qm10LWGeAptzM0L/a/tlue8CvpoV/eRtbOC8bcGu+h2TYBKMuWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CKCh7bW0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lIThsu1G; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 45739Qhx008884;
	Fri, 7 Jun 2024 06:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=corp-2023-11-20;
 bh=QtjVUKx7Yo00i6DWhJNFhrT0Oz7yaFLHiyglUoQ+hxk=;
 b=CKCh7bW0ijvvuP3yY7ovbV9/wvW04wOokhKDHjY9xMHEBe2WAyFcU8j7txRWh1++spje
 DpPCclljeylhYP+ODRnXeHlzSCFlS4YBqeLeiXn0mtc+R6pgIRb55J4H4U9BInEJqGnE
 UYUiTXDE//7uCmNpfL2GnI1w3eLCe3C+TAFpSbZC1g+7oTU2K7qk6Rj9vjJlG+pj/7SR
 YV1V31dls2EVTuzQTuKQgsU4Pd20TCeQ9NfumAuNCbktEUI391o1a5fJ7v65gw5yuX2I
 Rm37s1Dsq3djDTdOB0msoXeq5H5aGJsE5Ieu8hEzxyOSLRqe/Fg+AHp6JPunC5fDtHS8 OA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ykrtb08mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Jun 2024 06:16:24 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45761XDT025197;
	Fri, 7 Jun 2024 06:16:23 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrtck1w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Jun 2024 06:16:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiWb+CLXwoQNkVDRSJqBrSoYD+2a/xM2JXkyBmnKtTq4iJSD4TbtCgs/+43maqxon9QAbfeQRO03fcma+sAlI4uavoHV8T70pG9GwXS4vYMug1D0z6qcl+mt3aNskoHVOKwI+opZAn6SRZcApyLUpb6KR8RG0CjxJ1unjikIo4P4FKXzfycfmwdmSJVOOKrKO2G2U9d4UiXRVgoYgh92Xn0DX9vPfQ+3ZNdqKNqp5Dhv17ULxu18o1vYTNd/asR93q7nObGORwrcJtRzwemQsp59orMB+KTpMWaW4CQHzVtf6DDYhr7iPq1Xug4cK0YRhZfV1rGw/rki0qxiC1EQNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QtjVUKx7Yo00i6DWhJNFhrT0Oz7yaFLHiyglUoQ+hxk=;
 b=XYtigkxhgdn29DOAcAc4wTjw6PJZWUfA2bCi5LvrSuyQJNei3aMiz3indPLJpo9Rp1212bXNrQ1BHFY1y0SkULwnkO/XIC97MiHOp3Mm1lnmtqSfRKNDxGYHuUTn0mvINkfu7aJsd6ZHb08LOKOqWaY/OKaxdZexp5tnT+dzU9gobF4Zq8Lcb0F2hrrhMq+mHS9Ypu2putgPeHjUFIUUVV7ycXq7MoYVsFGK0ybBbzco/VDt8zU1p0A1E82TQSjxhHHEhP9N7u019V+JEhT+qvd4vUHt/C0kZkTUBXySWpd8ImEzXq7ncKgJiOLkYPzK4Wi7ArMkDClXuTTXo3Yrmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtjVUKx7Yo00i6DWhJNFhrT0Oz7yaFLHiyglUoQ+hxk=;
 b=lIThsu1Grn6VnGUOoYFlWPL7ph5/5yyWxoYAE1UMYayJY4JNqgjKsTaamq6M/Y/ENq4Bl5KEStMM5QtyXd2VcrPdcFL5SgtmyQq5se70ZJlhgT8X3K2/oJSXtaFmJFCgLg2VWiWYBJMoPJ62MomijnZi/7nNO43OLUAOal0FnGk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB6842.namprd10.prod.outlook.com (2603:10b6:208:436::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Fri, 7 Jun
 2024 06:16:21 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.033; Fri, 7 Jun 2024
 06:16:20 +0000
Message-ID: <96cb2069-a8e2-4723-802c-3ad4ba3e3d42@oracle.com>
Date: Fri, 7 Jun 2024 07:16:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/9] block atomic writes
To: axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, dchinner@redhat.com
References: <20240602140912.970947-1-john.g.garry@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240602140912.970947-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0236.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB6842:EE_
X-MS-Office365-Filtering-Correlation-Id: d152ad63-f5f7-4e20-6dad-08dc86b95954
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?SE1OYXczSmpqRHpKUEVrZ2FOK0MwT1pxQTdyUXE4ekNreHRRelp5VzVSa1V5?=
 =?utf-8?B?Zkg3WUkybHp5eDdlWkRpK0dHamRSci8yWUEvS0xqOEZ2L2dGYStMejJ6ckJH?=
 =?utf-8?B?TlBwZ3plM1JWeEU0VEY2dDdlWjJyYytQWFlxQlFYNzF6VTdtNFdkOHlNdlV1?=
 =?utf-8?B?M0hhM1l4eFFyMVY4dVZ5ejRaYUhMWDN3RUxGOWpXQWRneXk0bDZldm5sWDV3?=
 =?utf-8?B?THlrSVZ1aTBVNXFPRjVRb1hMQ3Zvc3hucmpiZVpVOHBkS1Z1TzVJVzJGWWZt?=
 =?utf-8?B?alJBQkhpMDNqWlp6TEttSTkzN1c3NlpXbXcrR095ZFNKc0gwcklsQitXR2dj?=
 =?utf-8?B?QlVtZ21ueWh2b1Riak45bzhHSkd1eEV5Q1Vqb1NEOW85cjRON1dPdTBwUWsv?=
 =?utf-8?B?eDNoMzgxelFhbmxJOXZSeFpsNjNucmcxSnBwTXlGNVdBYXJKQ0M0dDdLSWJW?=
 =?utf-8?B?a2lRdWFOWm82R1FnY3ZBOXhtV24wajhxdGo2a0MrRml0c3phNnRFd3Q5VDZT?=
 =?utf-8?B?cWdjWnBZYklNY1V5bytDUW8zbFdxcjRjRTF6bkdzZHFCdzU2bXk3OUZIKyts?=
 =?utf-8?B?eFBIVmJwREpQalJWTFpJWEZWQTM3YUNhc2hJK2kvb01wQ2xuUFJIdGZxQStG?=
 =?utf-8?B?dnA3cWlUVjBYOFUxWXpocC9kbnZ1VEdlWlFta3NEVE9qSkhEUExUSnN4MGxJ?=
 =?utf-8?B?QmJtRzVrY2IzMi9ydEpQUFp3OEtwOEgrSEJ0eDVpVjlDbDUveDVDYnNPcG4r?=
 =?utf-8?B?V2xoWnlVWHlvUGhMdCtJcG9aeFdQUnJJSnRxR3RlajdteFJKSVdzdTN0NUtJ?=
 =?utf-8?B?ajZ6TkhmbjV0VmVWckhSOGFtQk5sM0N6SVFKWlUxeGxNcGtZRHRNRjBsakhG?=
 =?utf-8?B?bk1hNXpWS2JidTBycGZGS3gyTExSb0hnUDRKOTRTTkZtcVZYV0hVUis1V3V3?=
 =?utf-8?B?R0o3R29LS2toMHpVdkJSRTJGbHRaaEs2MVJVT2FnM1RibVRLUFI3cUh5bEVO?=
 =?utf-8?B?Q2VKV2kvS3kydFppeVBpeXN5QTdzRWowYWkzaGlydzZQTzBGVmdRMHN3S2xR?=
 =?utf-8?B?OURNbSswby83U0hIS2wvTVpSU2xQVXNMenU5Q1NKK3pXQ2JLc2Njd1hYbFNv?=
 =?utf-8?B?Nk9ma3JOWnQ0bXdWTnhSTk9oYXRFN0NHTUtmSU9pQ1VadSt6THExS2lTS3Jo?=
 =?utf-8?B?TzdDQUNGcFh2VnUvWHdMMlN5UnNMTkQrZ1JQRGpxWEdvbnRSbzlPZWsyL2JG?=
 =?utf-8?B?MHNta3ZiSENWdU1FdXBjbUtCUDNkMzhWaW43VmlkQXhOVWtRTGVRb2t6VEpX?=
 =?utf-8?B?NXpoVTlVVjNaOWJ1YnEvWHVmSFlyZlVqM1JnT2YvVnNZOHVreDNGWnpYcUxt?=
 =?utf-8?B?aUhHSmdXSlQwN0I4cllMOFNZeTl1YUh0cVg4SDNWbjNjMzQ5N3lndWdzMmZL?=
 =?utf-8?B?NHoxaWVDK2QrU1hKUThFcitLaWVSaTBzQnl2ZkVHWVFMNVVsWFArTUdka1kx?=
 =?utf-8?B?OG8zZ2tSMVk0VW5kOExxM0ovcE9ZQlBvSHZmV2dBMjZsY3J2YVdmVTcvUHo1?=
 =?utf-8?B?K2w5Z1hYTXJpNWJWZ0RmZHNvRkpSWkVMbG1sVGZYUllkMURZaGNVQmxFUUFS?=
 =?utf-8?B?T09TSE1OVWp6UnlpaWQyNFg0YVRBKy9PT0RmK0hndEVtZWhYWnVhRk43OG5x?=
 =?utf-8?B?MzdaYlhxeW9XKzdnd2MrT2wxQTVMbml5SC9vZTdMVFBrV1B5MjJKbGN3eVc2?=
 =?utf-8?Q?saLxuch6jTHRWXpLG+ubE3zA17fRnZECkdAdi7a?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?d0FjMDR1dmlVdFRwWFNUVXc4RVZTbHlvdUttUWluTkZHUmNFZForZ3FmNHVR?=
 =?utf-8?B?aXJuN0c5bG42b1hoaGFOSXlmSjRqb2RZMzg1YkZEQzNYQnFqTHlMcThQblh5?=
 =?utf-8?B?aUNxaFFydGtDMVlZUlBwTmduWkFOTlhCZm1jS2FYM1NjazJrR3FKRHUrU1RZ?=
 =?utf-8?B?RElNTWFTWjlIanRnbTlaeDV4RXA5S1Vsbi9RUFBpYWt1YnBIL1htcG1rcDdq?=
 =?utf-8?B?QlgycjZWWnUyTDV4SnlIK3JTYmdOZ1hEdzAwZHNObDVYWERtdi82ekdURXA1?=
 =?utf-8?B?QXJ4L2NMS0t2TmNTSE1vYlcwd3FZVjhzUXAxVkxTb1ZndDNCeHlieHBsOS9X?=
 =?utf-8?B?R0dieGVxaDZBZ1VHNDMxc1B3REZhWll3dXQwa0ZMbXRweHNKMVArQnBVeGVt?=
 =?utf-8?B?cU1DdFdZUEMvc1RhZHlSM0N1bU9qckJBWEZYTXg4RGlkMklqR3FBRFo2bi9w?=
 =?utf-8?B?RDdpOSs3YldaRUZnMkk5Y1IxbVdHVHo5bklmQW9mZjZYUUtlZ2tMZTZZVEdq?=
 =?utf-8?B?NVZRUVZmQWh4QkFnN28xSjBqVndUd2gxRmVyVlhGUk9yMm1zUkZpTURyN29y?=
 =?utf-8?B?V1FDTm42Wk95ajFtaEtmNEVicEVnUVEwZGhwekl1SE5HaENkcXJhWTFBUTJK?=
 =?utf-8?B?YXBqLy9aYWxzcVdCdCtRZitkc3RjeFBHZDNwV211blhqRGppdVFOVTZGSk1U?=
 =?utf-8?B?RkhqaUJJZTUvZ2wvYm1oRzZUN0N5bUFza1pTOE9DN0wveDJDWlp6M0tTRDZ6?=
 =?utf-8?B?Nzh6Q2lid2plK1lxMFpHSzhyZFlDSGhhdU01Y3pqSXdPaCtsVDFoSUlTbnVx?=
 =?utf-8?B?UXVvV1hqK3Uwa2FkMndPTEZUbXpTaEhFR01ickJWNnZVYmswSFcycHZucTR1?=
 =?utf-8?B?ZUw3NDlVeUt2UU5CTTRiZVZoblIzODVseXZzN1p5YkdJemNqQ3UvNkNRQnpn?=
 =?utf-8?B?UE0ySzRNWG1ZQUN2RVlwL1BrWTJNY28zTlRyd2RXYmdkcisvbTFYaSs0ZXhq?=
 =?utf-8?B?M1ppRitRMzc1YkhrNTFXcXY5cTlQWlo3OXhkTUNhNXdHRnExSitydXZwdkcz?=
 =?utf-8?B?UHVtaGlNQlB4RHNKNmx0NTFxK1pONmRwdWk2U1NOejU0LzBjakdLTm1zTWZt?=
 =?utf-8?B?emhGQlk1eHIraFkzaWJIT0c0QmtaMStXZ1d0MG5NUHlBdWhreUVaaStFTFMv?=
 =?utf-8?B?ci9LRTdyYjlqN0xGc2ZvbFl0K1IvWkRHM3JOZ2VvRlUwZDFRS0UrU3RJUldw?=
 =?utf-8?B?VjBGVE4zTHRCUFdrQkplWDd2OXF6L2tnbXZ6RkFLRkl6SmtucVd1QXVqelVj?=
 =?utf-8?B?d1dYcldaVWl0elRXRHZocE01QUsxNXZ5SjE1dmRqLzFuRnVNaGNveXRFK28v?=
 =?utf-8?B?NlQrVCtSZnJubkJ1aHhHdXpBVzBxR01Db1N2VWlxVGNSN0YxeVBrY0JxUlB6?=
 =?utf-8?B?ODAxblZJKzBvR0gvOTdTUGZxSHlZL0dVVk5WbzVNWm1kWVRZNmpUekNNNE5y?=
 =?utf-8?B?ZFVZNVRrUnVJTUVpOVc1OENXTTJzTFB2azdhMkJPaGhmUkFyY2pkUmtlVHpN?=
 =?utf-8?B?cFlsUU9qTHVLVGFRZTFVWC9nUmVtMUVxQ2Z2bkN4cFBGQjY1Y0JxdFl1VTF2?=
 =?utf-8?B?NjQwenRya0VoKzRSbkM1OUZRbU1TeE9OR0dZdDJ2blhIS2pGMElhb2s2bzF3?=
 =?utf-8?B?RTFzT2R4cEdTL2V6L1V3a2NZR2Z3OUU0bmRFSEhlUHY0VnVPZ1RUTGl2VEZn?=
 =?utf-8?B?YjNoRTg2aU5GK0VMakFoL2JWNE1aR0FIR3ZrZjZ1bnBlU3NqbGN0SWsrdnVD?=
 =?utf-8?B?M1ZDNXBsNE51MFB3bzRGT0Q0d1ZBK3hjblZ4dVhBeWNyajczRVNuRjgxbmVp?=
 =?utf-8?B?MEI1bU14MmV3aTN2c1QwdDVIaEZOenlqMklFNmxJMEpKWWRmK1lFekNhWXpN?=
 =?utf-8?B?TWo1YlJZZ2hmbnl5MzhrcHA1MnRVdE9CK1pUcXBIS3NkaVB4aGhCV2NHSit2?=
 =?utf-8?B?VnB0NHljK0pCdWZIeWF5a1VkZk1Yb1FqNkFsU0paVlZ3OWVjWEN6OTN3SGxU?=
 =?utf-8?B?SDRKcjhqbzlqQlUyL245VUs0OFNwODZISEZoTFRJVHQyOVdHWTVJVVIzN0tV?=
 =?utf-8?Q?scIxaNKvu3p8ZTbjdTYubvqmo?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	31WDwMam5KAdTKOY2gSynkuoH4i1roUjO/0nzVPRhdSV504tbt4rNaBb9YYPOFwk0acS8Qo1sBeti+M6aL7YC9wLHbURD5aYpJYt3PBa1LrOi/VvqivqVZGsJC6B+4yXsU4/yP5Tahs2pDqH5IxLbSOZgRaMTOEzhMOfaOmXLQYgTspG6zF0FyW6Mhqq/bhLiBt/UfAOYLj2FyLMDd3XEXxuukDjBzcYpB6TxwWWYBzKuLHg4VfjUQggKowq6ksSHBs/jZeTW3rd+4G4QwDlSSQaCl2vgz+O6dbUj4+ocJ40LHagPMWdzUcAZrRxXnG2RSMifGYCdoAEZCauz/6TLzu7LJXDAbm143E6VB1Kqi9n5Vpb1rom6MX+wrv04plvtUhZ4QqyJ3leB1EvvyluTYUkUxIt+TRGW8EtvYLhmlcWcthc3XMQFvnArPwOl1iReaS5knNGTvQTWvdkj5FbmMl66BMYrhIcBW7lvpi6wcAVuWqXSxqNwJ6Uva+nyQJEsFfC5CReIhoNk2tBXpXOo2TiSQ+Ioq3jFIZPe938of8eWVsbs5E/LcL9ftzRBTY/CryAksfXbftEfIp5Yk0ewCliaQzmkbpJVPaH0KX1/go=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d152ad63-f5f7-4e20-6dad-08dc86b95954
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 06:16:20.7650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zs1V1D1vfP1lTW1FDQIoazBJNPYpTRC+NYQgOGzgkan1/yfK5Jbppi3dKVLxR01MF8YAUWiW2bPOTvdIqCVbCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6842
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-06_20,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406070043
X-Proofpoint-ORIG-GUID: D6caUgNRUn-_gCcpoJBe4fIf8upRyGdQ
X-Proofpoint-GUID: D6caUgNRUn-_gCcpoJBe4fIf8upRyGdQ

On 02/06/2024 15:09, John Garry wrote:
> This series introduces a proposal to implementing atomic writes in the
> kernel for torn-write protection.
> 
> This series takes the approach of adding a new "atomic" flag to each of
> pwritev2() and iocb->ki_flags - RWF_ATOMIC and IOCB_ATOMIC, respectively.
> When set, these indicate that we want the write issued "atomically".

Hi vfs maintainers, Jens,

Can you please let me know if you have any issues with this series? 
Specifically the first few patches.

This work has been on the lists for a year now, and most seem happy / 
content with it.

I really would like this to be this merged in this cycle.

Note that I plan to post a new series version soon, addressing comments 
from Hannes and Christoph, but they are not major changes.

Thanks,
John


