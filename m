Return-Path: <io-uring+bounces-6949-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35498A4EC6D
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 19:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 951C23AF7F6
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 18:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537F528153B;
	Tue,  4 Mar 2025 18:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KTYqapSC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wm7co6zr"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA62280CE2;
	Tue,  4 Mar 2025 18:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741111848; cv=fail; b=ZRsccdTGlQD3ZXHCfV2iQ5vhg+VJgtFJMTVEGcn4boo5/SnuBLR+tYqA0mQbISW/hcks2GIexzTfQ0FXnqVsHFis9vIAV7kvC3WYfUZ0eC/euGlhcUE9ps/T0JXpkwEsDmEllLNMLTCe4lVS62Ednet6F5z5Gplw7h+G6RTDLeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741111848; c=relaxed/simple;
	bh=GlgpYYxrmBsQW5E0CFR0MfxD2LlMgl+nlj0lir7Z580=;
	h=Message-ID:Date:Subject:To:References:Cc:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VaXsrCsD4SezPLhhBBak3Dm2J9yOLNvRiRvqZp3Uf403kYzsmTJoP/0p4SkKyI64gG81izisD9ktuqtmdXhwZID2YOu7DDpu/tFc04Rz+qUpR0qQk1fkAO5AcVsNN5CeJV2cyD0ftEbavC/R2K3PyQ3GgyEIP+EbiEogwFsy9F4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KTYqapSC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wm7co6zr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 524HMigA011936;
	Tue, 4 Mar 2025 18:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=OBuxWr+oPKI+T+XVGNAlKJzZZYwGkhzwX6EMIfofIno=; b=
	KTYqapSC28uOV5VzxS2Q3t6lTZJ1zR25Z8p4aG7vc4HsdjSahaIiKIkN9R1o2PS2
	GcQYvfreDaTTdLUeH2KEc14Xg24g+S5kWYlpHG/wCuIcIKn/NqNkGWbIrxkeBFtd
	x/odsvTAHYIjX87LeU7/ZktPp7D15REmHkkznAmPd5cOjXaKEEDq6+AiYp1ICz8X
	+mmWnslCifkmm6e4GZtrj0RGOEHoYBVv26RZgAkVPqZ+T7hrG9NwO8IX0jwlQOF5
	8OTDLnKb7ds4PCFWvUja+3yvPuTdgRThtdCQ4s2CtRdg25fztsCTL8ingAro6EAy
	NrkNybdwS8blVBdSXy0HuQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453ub75tks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 18:10:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 524GudZk039830;
	Tue, 4 Mar 2025 18:10:42 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2046.outbound.protection.outlook.com [104.47.57.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rpa0vbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 18:10:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZfcCBpqaNaUgnaL3dns+o9XMvMM1U1PQPHI9fErPe2zlqwOatAALh5mwFucwwtbXf9LSL1UzcBu1HtDbzVNKP7LYW9s1dUqmVn4vtbvp7PcavTeOysFZiJEZWRaULqwZ5VodA0qs9kB1494enk/R4OkRXmoLVOxjvR/ipGaNtrLjVNGC9CLMk23cf/4+YKXVZ4rGc5AnzBA12CW8ZV3TCeHXSVIULLqwd2d63jWBRX8asweINLun2JW2OmQTFEo4hNY1pKBQtb7FWYwcnZeVctE/zt3rTpOCzhCN8tnEkyQMDeuSXShOqzmzLbPtdfNomJwtFwXx9Xx1YFctdrHnHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBuxWr+oPKI+T+XVGNAlKJzZZYwGkhzwX6EMIfofIno=;
 b=f3QiS5tUVwjN17rb0PQ8PsqB/7MeLH9aEWv9a4DkfYYxBQ/bBCd3q97a/yl/axRGKkKVmDvUIqxkqVJ9VmWn4ieu7CII4qUsjTjP1yPm07lxXgwiEQEXYMkgP94jNXFqNgwdAV9h/++h/fMPN6yjy0UYdWebL1Uv/Bp0xVOS0utP+gJ1xhDVlFApYCXaz41ilfrPRJ3iLmS2VXX9bV8TW8oABjvqdPAUzTXZ8tRzO+3Hx1hy12SFVn/ulHu1wqttX5w5SqaJnri1q2SSDv7KIYVm7mx7O7nutR/agGnFMp14TJqSSc0aGCWIyhVGXGaVks7JPF6PrJ1IKd/RGQgLiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBuxWr+oPKI+T+XVGNAlKJzZZYwGkhzwX6EMIfofIno=;
 b=wm7co6zr4x6j5rH5IJIGOr8KGrIaQwyEQxKxGt9AI+3lipD3f2h1SpwjLQ1B3xnXD0HfSFSBFkfOIrk4duZF8L49YFuvlTzW/TpMkYJrcsPJmgf0CvIyOENZJP6WZht0+jwkUQ7cj/DLeIDDH//yeE9VaYYpjc8kS+symGViBRE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7386.namprd10.prod.outlook.com (2603:10b6:208:42e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 18:10:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8489.028; Tue, 4 Mar 2025
 18:10:40 +0000
Message-ID: <2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com>
Date: Tue, 4 Mar 2025 18:10:38 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/rw: handle -EAGAIN retry at IO completion
 time
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250109181940.552635-1-axboe@kernel.dk>
 <20250109181940.552635-3-axboe@kernel.dk>
Content-Language: en-US
Cc: linux-scsi@vger.kernel.org
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250109181940.552635-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0111.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7386:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aee99ee-a507-4702-de0a-08dd5b47df35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NitWN3h5dTFFSDZjb0QvYlFrNS9OZWJjbjZIOUNIM2NmendaZm0wcEFVL1Bt?=
 =?utf-8?B?QnZockI2VTZyeXBWNUNvN0E1WUNZdHN4MFRqcUc4UXFWNCtLdEdXSHM1cDBn?=
 =?utf-8?B?SHRTL0c5eG9zdzF3ZW5Fd2pnQUd0dTBXeWp2S1NuaWptYlYvaC8rYUxKQTM0?=
 =?utf-8?B?bEtlbXRodUN3aDIwZDhlNDBnV3I4UzBlWG9VcUMwa3pIMlR6VWNwUFVOZkdm?=
 =?utf-8?B?QXlpTjYwdDN3Z0FmV0xXL0Vtd1dtdTRrdmJwS09vUVllUWFLdXFmaXFjbzAv?=
 =?utf-8?B?ZkN0Nm1QKytzWU9XMWJHN3RKVWpYd2QrbHRqRVZucm9TV085Sk1Ib0I1SHBv?=
 =?utf-8?B?VFQ3cThuaS9CMlkzVTFVbFh5VktvSUhtUGZmcHZqL1QzSDZYK3BDRkdYQVd3?=
 =?utf-8?B?YnpLS1RJVDlYbUozbTl4bkt5T0cyQnhWNTdXOGdBak5jYk5ha2lMYWwwTHVW?=
 =?utf-8?B?VnBPRldsSXJIU1RIY1JVaWdiTVhvdmNEck8wTUNOcThhMEFKUStoQUhEeUly?=
 =?utf-8?B?ZHMrN1lDRnBoSnowb0dQLzNiRmVKK001N3AvL2IwaEF3OEk5bG9WVGpoYlJE?=
 =?utf-8?B?bERJSG5hT3M2VDhmK3JlTVQwMU5KMEtyVFJadVFFNXkvUGpKZ1kzUlZ3eGMz?=
 =?utf-8?B?eE13SE13aG5Nd1ljQ3pvMGNRMjlYbGhSNHF3bHJBYkNVc012QUNLZTlJOTh1?=
 =?utf-8?B?UWQwZXpvR2ZMb21pdXJxaHlHZ0dsQWVwYS9WNGFIcWZDbmF3NWd3TTZVb0J6?=
 =?utf-8?B?bnErcWQzdUZTcTA2RGZWeTFSS2xZNURzRVlDLzU0SjJYVFA5VFQzQUpBU0M0?=
 =?utf-8?B?VFQwMThZdlAvQjJtZ283Vi9mWVErUkNkWDdiY3pzK0ozSkFOY2VZa1dwRVRl?=
 =?utf-8?B?RkVUeCs2SkRSQ0hZVitiWU1OTlZsZU1reDNVaW4wK3ZpcDZ1dnVXeVB0QjFS?=
 =?utf-8?B?SCthUmhoZk9jcEFDbVFZQlZmOURzOXo1dTlKZEo0RVhnQ2ovZjhOc01jbWFO?=
 =?utf-8?B?Q3VkNjRHVTMrbGJ6bjdYOXhDQzlrZzRocGpvbUJsZzh6M1hVd01BdTBMcThR?=
 =?utf-8?B?Q0lrdTJYK3pBQWVOSG5LcTFtUFY0L09rcW5Yb3BKc3p4VG9STk1RNStHb3ZI?=
 =?utf-8?B?YkRDeFNYcytCNW1KZTlZOUJ6TlB3bUN2NUxZendHZjNpQk5GVlVLUXRPL2RW?=
 =?utf-8?B?L1UyQ3RRaVdOUnhrbkFZT21sSVR1a1h5cXZadHNpT0lFZVJKSUpzMWJ2Q0E5?=
 =?utf-8?B?dklDM3lweDlrU1Q5S0pmM2dkalh1NWZ4b21pNG5TWVd6b3A3cUd3c245b2F6?=
 =?utf-8?B?VnZ0bVViaGQwdXJtamhvOGozQTZmTmdTZktKd3ViYWkwWWl5S2NUTmFFYWpM?=
 =?utf-8?B?MEppNW90TjYrUkpwZW9jRUwwQmNneXdGZU9HUlVVdWVUSGxYU0JZU3NiUU9Z?=
 =?utf-8?B?RjlDeXFvVlVWa3I5UFE4OWNUdjdGa09HLzhRR1UxTzNJUktzTTY1WEJPVzNo?=
 =?utf-8?B?c3pNNFZpblZtUkJsV3ltZlpycThoSkNSUFdma2E4Z0J3NkhZSHBhb05pbGIw?=
 =?utf-8?B?TjVxNXdZVnBKUVZPU0huRjNEblRHaWR4MTE4bzcvN3VVcmx5NlN4dUt0SGFX?=
 =?utf-8?B?cit1T2VzakEzOUM1RFlCSldib20yT3ZWMGFoKzkrZmgwUmVscE1IUUM5UHBW?=
 =?utf-8?B?Y2pndVZrNGRYUnFVYnVsRytXd3RjQXlYQU9RZTl3bjhtR1VrbG12UWRZSWtQ?=
 =?utf-8?B?K0tQQ1J2NDhkN1ZCNENheThESWdCNi8zWVRFT0NPR3g1dXl6T2p5bHp4Y2Iz?=
 =?utf-8?B?OWRzQmZQb0hNSm4xTU96c3FUNXNldloyRzBKaDFNUXBGY1dnRi8rQVZUMmpj?=
 =?utf-8?Q?Q2ji6Rsszezau?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ulg0N1AwQWpyMUxTMmxtR3ZPakxyb0pCeHdqL2hzOVk0NElnMlRwdHVWNzJ6?=
 =?utf-8?B?Ykpwdm0xbkQwWitYTGU3aTZQRzJ6NEd0UHhxK3QxMnQ4eENIT2ZBNlRvVDVI?=
 =?utf-8?B?UERYdUdRUndGUjlXcXhaMmZ6T0phdWZ5SjZjSmIwdmdFWTJHSy9XUXczd2gz?=
 =?utf-8?B?OFZHV1BPZWpyNkRBOXFDenlaVDVlTGM3K2cyUXZ0TVFENE5VMmd0aHliK1B4?=
 =?utf-8?B?emhuYUNtS0h5VnFLTVBMQm9MdGgxM0d4SW9MR0dkaFptaHdGYit6RHdYYjRu?=
 =?utf-8?B?R0F0RDA4MDRMT09xRTNSaWowMXZJTWlHZW5rdHVqUzhsU3VTNGdOMG1wQ0Vt?=
 =?utf-8?B?bU1BNW9LZXpObW1kbHZaVVByb1JOUU9yT1FBc1h5WFhGRnk5RHpDaEVNTEJk?=
 =?utf-8?B?WEFTRkI2M3lWeTJPZm5kYXcwaXdPeXo5czhjOUpBZlBrTE5CaFh3czhxUnZB?=
 =?utf-8?B?bWwrdjQvSGFUZy8xN0k3VjU2cTg5T3UrRkZ2WkdaVW44RWxIVHpVeW9EZE9Z?=
 =?utf-8?B?SU1TanFobXJGQ3FCVEJCcFBVZ3hPaHNtcXBGd0w0bWV4SGREdUh0bzlRcktl?=
 =?utf-8?B?TGJ1NFAvYTFOZkpvSWlrMkFXdEV4WWlaRTg0RnBLUDhMZmFrRVRpcW9HUXdH?=
 =?utf-8?B?dDRBN3VWNjhSZEZLWUtZbWgxOFBXM2JReTBoblVvNWsxYXkydTRVRkZwdXcx?=
 =?utf-8?B?QVI1NDU2bXI0RnduWTFjU1ZiaCtudFRaeGswQ1RoV3JzRlV2RGQ1UnI4WFFs?=
 =?utf-8?B?Y2VkOFZGSjZIc1dtMk41cTNpN0o4cGJ6eHVxQ21xOUJKaUtLUG9IdTB6cExO?=
 =?utf-8?B?cDFZOTZmWmhPK0p4Mm5oNmYrY0xNZ1pJdyszMXFXRzJQNGxqd3l6Y2NudUt3?=
 =?utf-8?B?djNsNEs3TEJ2SnlSeGdSZ0FZT3dqVWN0NWp2OTFqVFZKamt1dnhIdjNkeWxQ?=
 =?utf-8?B?TWNtc1RJc0Z6Vjlnd0JYNjN0Tm1WZWRhTktjZUd2QVZLcEwzQUVoRjdZVEZM?=
 =?utf-8?B?c05pUENYY3IveFFQQTNENDB1UjB6MnJKZzlkNVQ4ZHFlcDh6VERMbnJpMlFk?=
 =?utf-8?B?S0hpRmlmcXdMbERURDRteUk2ZEtud2Q0Vys3ajFTYmxIRnZNRDdzRlU1Ylhj?=
 =?utf-8?B?akVnMVNKTjB3MDVsQ3VKRXNEUzQ0bnpIQ3hMa3JkZ3FOdE5DZDhvVGJiQytM?=
 =?utf-8?B?cllHbE8ycEd1MXdkS1BpMUdvWG9TN2NTVGhRM2QxVXdzSEFrc24zOUVBeUN4?=
 =?utf-8?B?MXVhZVdQKzMrSnZ4d0RFTjZEWERTY3M4MDRzUnRzTXpCNnJETVhOYmVrclM2?=
 =?utf-8?B?Q1BlTDZZa1JnT3l3UDlhL01Ud3JBTmhUV0VnMDhIQWVUclV4Mi9wTDgvZDZY?=
 =?utf-8?B?SGtYS3diSWxuRCs4TUxKTUhzSTNEZDgrSmxlQlVCcVdLZ1Q2dmF3eVBXQTZX?=
 =?utf-8?B?NmRvVDU3VU5pU2pLWjNWMnpWSXpzM0wzZjQ5cWFUNUEzTkluRVkvRWZKaEJT?=
 =?utf-8?B?eG5udkcwRVZkd084TFNEdmdjMVFlbTh4L0theGFlL1gzSU1LTlIrb1NObHk5?=
 =?utf-8?B?NDlPSy8rT2NHSVVxdTV1VnFnb1l5NE93N3dEakhjc2NIYkR6WjZPTDBnaTdI?=
 =?utf-8?B?cG50eDZBSFFJOWtab016dUt5bkpicWUrQkRIRm1sdGVLSis5MHByVHdSM2hD?=
 =?utf-8?B?ZTA1SkNkZlVTVTRDeVNsZG5CUE5rbDhYL0czWEN4OXdZZC92NU9vRjZqNkpC?=
 =?utf-8?B?QXBSTE9rc0FVU3lLbWV0S0l6ZytTdU81TzN0TC9KTG5ZblRJd2Y1RTlxdllT?=
 =?utf-8?B?RVAxK09ZN2EydFRyakhzYUptZjRaQkFmcDd2MHpaU1BSWENqSzdPTEJ6ZktO?=
 =?utf-8?B?NkZVaHN6aHdnbVFWeDdXWmdUWFpZNHM5NVRrUmlDSVJFUmZ2b3Vtbk5QcjZU?=
 =?utf-8?B?WHZCbi9ZQk1mL2JvNVVObloxaXN2ZEFEdytFQ3cxMlRHSHEwTGtIQ2FUYXJY?=
 =?utf-8?B?OE0zOHh2eEcySmtlc293ZVNFV0pyVlFZRjJDNzRuUTJKK3UvWHRza2xuUUZh?=
 =?utf-8?B?cGtuS3orYjhSVndPR0R6Z1c2UzYxQlp1UXh6L21FdCt2cXc0T3dVN2NGNmc5?=
 =?utf-8?Q?rvS9Fp3mYk68s39e38q87jAAz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MAxpWC6TgC8s7oACir2jYALxlM/H2eVu9kY1Q4NcDWawRwRjcwtVzMVoHzBLNoG/r9Eci6XQgAxlaM0LFOP0Y/Pm7brOT2i2hVDwgsYJ1jQPvHcOonREIyRbViYK0sJEVYE9I7z8jhvitPHYk2fOf/rUDJ+nmNpFLmJ/Sqz1KXsjFRXbuCnF8a87mfB+YOt+TFCVuzcMZQKVT4V3zL8grWJZDTfYzXm0RFw98b3kcZZs2WApJfHN8UZTZYyW7qfYi8rV4FIqWzsiFxjLZU4BbTMXptv9UOn0FWyt5xJhth+h91Qr19S71azhzZGOue/eu4Mfs+xxmjYqqXAFyf6CUPXXdcnEm29SvfFQG+3MlaHS0qeDg0lxtp20OkxCGhU84f+aEf1J2OhfWoqou59Izg7To5bus1mi2DJqP6fX4sATHa9BuQ21qw7997JRo1wrkE/NdyV+2Xd9ZwlNoM7tcrDUMMyCbc9k0vPo+EzCAtFUtxjJOdGmv1Sl7bkkeACvkDBYibvjLRnziRZrw3RXuiFjo6l8WFArmgOi6RcsmF4SSx3eEnrv7VW+QyEwZ3GawOyBxqSpKZn2FxyO0nCpNAS8YdJAY3lJEBPRGQTMglw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aee99ee-a507-4702-de0a-08dd5b47df35
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 18:10:40.4655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TEq2aa1N3s9jgj2VH+n+PZHMimOoylTMgPQ/RqAQ8PaUXdbHG9I2s4WgItVViX3Ql0aBhNTBTyNF1cK4nBpFNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_07,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040145
X-Proofpoint-GUID: -4vJCwMjKL_DHcGCW3FVFBTrbWOZgpxT
X-Proofpoint-ORIG-GUID: -4vJCwMjKL_DHcGCW3FVFBTrbWOZgpxT

On 09/01/2025 18:15, Jens Axboe wrote:
> Rather than try and have io_read/io_write turn REQ_F_REISSUE into
> -EAGAIN, catch the REQ_F_REISSUE when the request is otherwise
> considered as done. This is saner as we know this isn't happening
> during an actual submission, and it removes the need to randomly
> check REQ_F_REISSUE after read/write submission.
> 
> If REQ_F_REISSUE is set, __io_submit_flush_completions() will skip over
> this request in terms of posting a CQE, and the regular request
> cleaning will ensure that it gets reissued via io-wq.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

JFYI, this patch causes or exposes an issue in scsi_debug where we get a 
use-after-free:

Starting 10 processes
[    9.445254] 
==================================================================
[    9.446156] BUG: KASAN: slab-use-after-free in bio_poll+0x26b/0x420
[    9.447188] Read of size 4 at addr ff1100014c9b46b4 by task fio/442
[    9.447933]
[    9.448121] CPU: 8 UID: 0 PID: 442 Comm: fio Not tainted 
6.13.0-rc4-00052-gfdf8fc8dce75 #3390
[    9.449161] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    9.450573] Call Trace:
[    9.450876]  <TASK>
[    9.451186]  dump_stack_lvl+0x53/0x70
[    9.451644]  print_report+0xce/0x660
[    9.452077]  ? sdebug_blk_mq_poll+0x92/0x100
[    9.452639]  ? bio_poll+0x26b/0x420
[    9.453077]  kasan_report+0xc6/0x100
[    9.453537]  ? bio_poll+0x26b/0x420
[    9.453955]  bio_poll+0x26b/0x420
[    9.454374]  ? task_mm_cid_work+0x33e/0x750
[    9.454879]  iocb_bio_iopoll+0x47/0x60
[    9.455355]  io_do_iopoll+0x450/0x10a0
[    9.455814]  ? _raw_spin_lock_irq+0x81/0xe0
[    9.456359]  ? __pfx_io_do_iopoll+0x10/0x10
[    9.456866]  ? mutex_lock+0x8c/0xe0
[    9.457317]  ? __pfx_mutex_lock+0x10/0x10
[    9.457799]  ? __pfx_mutex_unlock+0x10/0x10
[    9.458316]  __do_sys_io_uring_enter+0x7b7/0x12e0
[    9.458866]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
[    9.459515]  ? __pfx___rseq_handle_notify_resume+0x10/0x10
[    9.460202]  ? handle_mm_fault+0x16f/0x400
[    9.460696]  do_syscall_64+0xa6/0x1a0
[    9.461149]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[    9.461787] RIP: 0033:0x560572d148f8
[    9.462234] Code: 1c 01 00 00 48 8b 04 24 83 78 38 00 0f 85 0e 01 00 
00 41 8b 3f 41 ba 01 00 00 00 45 31 c0 45 31 c9 b8 aa 01 00 00 89 ea 0f 
05 <89> c6 85 c0 0f 89 ec 00 00 00 89 44 24 0c e8 55 87 fa ff 8b 74 24
[    9.464489] RSP: 002b:00007ffc5330a600 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[    9.465400] RAX: ffffffffffffffda RBX: 00007f39cd9d9ac0 RCX: 
0000560572d148f8
[    9.466254] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
0000000000000006
[    9.467114] RBP: 0000000000000001 R08: 0000000000000000 R09: 
0000000000000000
[    9.467962] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000000
[    9.468803] R13: 00007ffc5330a798 R14: 0000000000000001 R15: 
0000560577589630
[    9.469672]  </TASK>
[    9.469950]
[    9.470168] Allocated by task 441:
[    9.470577]  kasan_save_stack+0x33/0x60
[    9.471033]  kasan_save_track+0x14/0x30
[    9.471554]  __kasan_slab_alloc+0x6e/0x70
[    9.472036]  kmem_cache_alloc_noprof+0xe9/0x300
[    9.472599]  mempool_alloc_noprof+0x11a/0x2e0
[    9.473161]  bio_alloc_bioset+0x1ab/0x780
[    9.473634]  blkdev_direct_IO+0x456/0x2130
[    9.474130]  blkdev_write_iter+0x54f/0xb90
[    9.474647]  io_write+0x3b3/0xfe0
[    9.475053]  io_issue_sqe+0x131/0x13e0
[    9.475516]  io_submit_sqes+0x6f6/0x21e0
[    9.475995]  __do_sys_io_uring_enter+0xa1e/0x12e0
[    9.476602]  do_syscall_64+0xa6/0x1a0
[    9.477043]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[    9.477659]
[    9.477848] Freed by task 441:
[    9.478261]  kasan_save_stack+0x33/0x60
[    9.478715]  kasan_save_track+0x14/0x30
[    9.479197]  kasan_save_free_info+0x3b/0x60
[    9.479692]  __kasan_slab_free+0x37/0x50
[    9.480191]  slab_free_after_rcu_debug+0xb1/0x280
[    9.480755]  rcu_core+0x610/0x1a80
[    9.481215]  handle_softirqs+0x1b5/0x5c0
[    9.481696]  irq_exit_rcu+0xaf/0xe0
[    9.482119]  sysvec_apic_timer_interrupt+0x6c/0x80
[    9.482729]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[    9.483389]
[    9.483581] Last potentially related work creation:
[    9.484174]  kasan_save_stack+0x33/0x60
[    9.484661]  __kasan_record_aux_stack+0x8e/0xa0
[    9.485228]  kmem_cache_free+0x21c/0x370
[    9.485713]  blk_update_request+0x22c/0x1070
[    9.486280]  scsi_end_request+0x6b/0x5d0
[    9.486762]  scsi_io_completion+0xa4/0xda0
[    9.487285]  sdebug_blk_mq_poll_iter+0x189/0x2c0
[    9.487851]  bt_tags_iter+0x15f/0x290
[    9.488310]  __blk_mq_all_tag_iter+0x31d/0x960
[    9.488869]  blk_mq_tagset_busy_iter+0xeb/0x140
[    9.489448]  sdebug_blk_mq_poll+0x92/0x100
[    9.489949]  blk_hctx_poll+0x160/0x330
[    9.490446]  bio_poll+0x182/0x420
[    9.490853]  iocb_bio_iopoll+0x47/0x60
[    9.491343]  io_do_iopoll+0x450/0x10a0
[    9.491798]  __do_sys_io_uring_enter+0x7b7/0x12e0
[    9.492398]  do_syscall_64+0xa6/0x1a0
[    9.492852]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[    9.493484]
[    9.493676] The buggy address belongs to the object at ff1100014c9b4640
[    9.493676]  which belongs to the cache bio-248 of size 248
[    9.495118] The buggy address is located 116 bytes inside of
[    9.495118]  freed 248-byte region [ff1100014c9b4640, ff1100014c9b4738)
[    9.496597]
[    9.496784] The buggy address belongs to the physical page:
[    9.497465] page: refcount:1 mapcount:0 mapping:0000000000000000 
index:0x0 pfn:0x14c9b4
[    9.498464] head: order:2 mapcount:0 entire_mapcount:0 
nr_pages_mapped:0 pincount:0
[    9.499421] flags: 0x200000000000040(head|node=0|zone=2)
[    9.500053] page_type: f5(slab)
[    9.500451] raw: 0200000000000040 ff110001052f8dc0 dead000000000122 
0000000000000000
[    9.501386] raw: 0000000000000000 0000000080330033 00000001f5000000 
0000000000000000
[    9.502333] head: 0200000000000040 ff110001052f8dc0 dead000000000122 
0000000000000000
[    9.503261] head: 0000000000000000 0000000080330033 00000001f5000000 
0000000000000000
[    9.504213] head: 0200000000000002 ffd4000005326d01 ffffffffffffffff 
0000000000000000
[    9.505142] head: 0000000000000004 0000000000000000 00000000ffffffff 
0000000000000000
[    9.506082] page dumped because: kasan: bad access detected
[    9.506752]
[    9.506939] Memory state around the buggy address:
[    9.507560]  ff1100014c9b4580: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 fc
[    9.508454]  ff1100014c9b4600: fc fc fc fc fc fc fc fc fa fb fb fb fb 
fb fb fb
[    9.509365] >ff1100014c9b4680: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[    9.510260]                                      ^
[    9.510842]  ff1100014c9b4700: fb fb fb fb fb fb fb fc fc fc fc fc fc 
fc fc fc
[    9.511755]  ff1100014c9b4780: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00
[    9.512654] 
==================================================================
[    9.513616] Disabling lock debugging due to kernel taint
QEMU: Terminated

Now scsi_debug does something pretty unorthodox in the mq_poll callback 
in that it calls blk_mq_tagset_busy_iter() ... -> scsi_done().

However, for qemu with nvme I get this:

fio-3.34
Starting 10 processes
[   30.887296] 
==================================================================
[   30.907820] BUG: KASAN: slab-use-after-free in bio_poll+0x26b/0x420
[   30.924793] Read of size 4 at addr ff1100015f775ab4 by task fio/458
[   30.949904]
[   30.952784] CPU: 11 UID: 0 PID: 458 Comm: fio Not tainted 
6.13.0-rc4-00053-gc9c268957b58 #3391
[   31.036344] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   31.090860] Call Trace:
[   31.153928]  <TASK>
[   31.180060]  dump_stack_lvl+0x53/0x70
[   31.209414]  print_report+0xce/0x660
[   31.220341]  ? bio_poll+0x26b/0x420
[   31.236876]  kasan_report+0xc6/0x100
[   31.253395]  ? bio_poll+0x26b/0x420
[   31.283105]  bio_poll+0x26b/0x420
[   31.304388]  iocb_bio_iopoll+0x47/0x60
[   31.327575]  io_do_iopoll+0x450/0x10a0
[   31.357706]  ? __pfx_io_do_iopoll+0x10/0x10
[   31.381389]  ? io_submit_sqes+0x6f6/0x21e0
[   31.397833]  ? mutex_lock+0x8c/0xe0
[   31.436789]  ? __pfx_mutex_lock+0x10/0x10
[   31.469967]  __do_sys_io_uring_enter+0x7b7/0x12e0
[   31.506017]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
[   31.556819]  ? __pfx___rseq_handle_notify_resume+0x10/0x10
[   31.599749]  ? handle_mm_fault+0x16f/0x400
[   31.637617]  ? up_read+0x1a/0xb0
[   31.658649]  do_syscall_64+0xa6/0x1a0
[   31.715961]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   31.738610] RIP: 0033:0x558b29f538f8
[   31.758298] Code: 1c 01 00 00 48 8b 04 24 83 78 38 00 0f 85 0e 01 00 
00 41 8b 3f 41 ba 01 00 00 00 45 31 c0 45 31 c9 b8 aa 01 00 00 89 ea 0f 
05 <89> c6 85 c0 0f 89 ec 00 00 00 89 44 24 0c e8 55 87 fa ff 8b 74 24
[   31.868980] RSP: 002b:00007ffd37d51490 EFLAGS: 00000246 ORIG_RAX: 
00000000000001aa
[   31.946356] RAX: ffffffffffffffda RBX: 00007f120ebfeb40 RCX: 
0000558b29f538f8
[   32.044833] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
0000000000000006
[   32.086849] RBP: 0000000000000001 R08: 0000000000000000 R09: 
0000000000000000
[   32.117522] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000000000
[   32.155554] R13: 00007ffd37d51628 R14: 0000000000000001 R15: 
0000558b3c3216b0
[   32.174488]  </TASK>
[   32.183180]
[   32.193202] Allocated by task 458:
[   32.205642]  kasan_save_stack+0x33/0x60
[   32.215908]  kasan_save_track+0x14/0x30
[   32.231828]  __kasan_slab_alloc+0x6e/0x70
[   32.244998]  kmem_cache_alloc_noprof+0xe9/0x300
[   32.263654]  mempool_alloc_noprof+0x11a/0x2e0
[   32.274050]  bio_alloc_bioset+0x1ab/0x780
[   32.286829]  blkdev_direct_IO+0x456/0x2130
[   32.293655]  blkdev_write_iter+0x54f/0xb90
[   32.299844]  io_write+0x3b3/0xfe0
[   32.309428]  io_issue_sqe+0x131/0x13e0
[   32.315319]  io_submit_sqes+0x6f6/0x21e0
[   32.320913]  __do_sys_io_uring_enter+0xa1e/0x12e0
[   32.328091]  do_syscall_64+0xa6/0x1a0
[   32.336915]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   32.350460]
[   32.355097] Freed by task 455:
[   32.360331]  kasan_save_stack+0x33/0x60
[   32.369595]  kasan_save_track+0x14/0x30
[   32.377397]  kasan_save_free_info+0x3b/0x60
[   32.386598]  __kasan_slab_free+0x37/0x50
[   32.398562]  slab_free_after_rcu_debug+0xb1/0x280
[   32.417108]  rcu_core+0x610/0x1a80
[   32.424947]  handle_softirqs+0x1b5/0x5c0
[   32.434754]  irq_exit_rcu+0xaf/0xe0
[   32.438144]  sysvec_apic_timer_interrupt+0x6c/0x80
[   32.443842]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[   32.448109]
[   32.449772] Last potentially related work creation:
[   32.454800]  kasan_save_stack+0x33/0x60
[   32.458743]  __kasan_record_aux_stack+0x8e/0xa0
[   32.463802]  kmem_cache_free+0x21c/0x370
[   32.468130]  blk_mq_end_request_batch+0x26b/0x13f0
[   32.473935]  io_do_iopoll+0xa78/0x10a0
[   32.477800]  __do_sys_io_uring_enter+0x7b7/0x12e0
[   32.482678]  do_syscall_64+0xa6/0x1a0
[   32.487671]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   32.492551]
[   32.494058] The buggy address belongs to the object at ff1100015f775a40
[   32.494058]  which belongs to the cache bio-248 of size 248
[   32.504485] The buggy address is located 116 bytes inside of
[   32.504485]  freed 248-byte region [ff1100015f775a40, ff1100015f775b38)
[   32.518309]
[   32.520370] The buggy address belongs to the physical page:
[   32.526444] page: refcount:1 mapcount:0 mapping:0000000000000000 
index:0x0 pfn:0x15f774
[   32.535554] head: order:2 mapcount:0 entire_mapcount:0 
nr_pages_mapped:0 pincount:0
[   32.542517] flags: 0x200000000000040(head|node=0|zone=2)
[   32.547971] page_type: f5(slab)
[   32.551287] raw: 0200000000000040 ff1100010376af80 dead000000000122 
0000000000000000
[   32.559290] raw: 0000000000000000 0000000000330033 00000001f5000000 
0000000000000000
[   32.566773] head: 0200000000000040 ff1100010376af80 dead000000000122 
0000000000000000
[   32.574046] head: 0000000000000000 0000000000330033 00000001f5000000 
0000000000000000
[   32.581715] head: 0200000000000002 ffd40000057ddd01 ffffffffffffffff 
0000000000000000
[   32.589588] head: 0000000000000004 0000000000000000 00000000ffffffff 
0000000000000000
[   32.596963] page dumped because: kasan: bad access detected
[   32.603473]
[   32.604871] Memory state around the buggy address:
[   32.609617]  ff1100015f775980: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 fc
[   32.617652]  ff1100015f775a00: fc fc fc fc fc fc fc fc fa fb fb fb fb 
fb fb fb
[   32.625385] >ff1100015f775a80: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[   32.634014]                                      ^
[   32.637444]  ff1100015f775b00: fb fb fb fb fb fb fb fc fc fc fc fc fc 
fc fc fc
[   32.644158]  ff1100015f775b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00
[   32.651115] 
==================================================================
[   32.659002] Disabling lock debugging due to kernel taint
QEMU: Terminated [W(10)][0.1%][w=150MiB/s][w=38.4k IOPS][eta 01h:24m:16s]
root@jgarry-ubuntu-bm5-instance-20230215-1843:/home/ubuntu/linux#

Here's my git bisect log:

git bisect start
# good: [1cbfb828e05171ca2dd77b5988d068e6872480fe] Merge tag
'for-6.14/block-20250118' of git://git.kernel.dk/linux
git bisect good 1cbfb828e05171ca2dd77b5988d068e6872480fe
# bad: [a312e1706ce6c124f04ec85ddece240f3bb2a696] Merge tag
'for-6.14/io_uring-20250119' of git://git.kernel.dk/linux
git bisect bad a312e1706ce6c124f04ec85ddece240f3bb2a696
# good: [3d8b5a22d40435b4a7e58f06ae2cd3506b222898] block: add support
to pass user meta buffer
git bisect good 3d8b5a22d40435b4a7e58f06ae2cd3506b222898
# good: [ce9464081d5168ee0f279d6932ba82260a5b97c4] io_uring/msg_ring:
Drop custom destructor
git bisect good ce9464081d5168ee0f279d6932ba82260a5b97c4
# bad: [d803d123948feffbd992213e144df224097f82b0] io_uring/rw: handle
-EAGAIN retry at IO completion time
git bisect bad d803d123948feffbd992213e144df224097f82b0
# good: [c5f71916146033f9aba108075ff7087022075fd6] io_uring/rw: always
clear ->bytes_done on io_async_rw setup
git bisect good c5f71916146033f9aba108075ff7087022075fd6
# good: [2a51c327d4a4a2eb62d67f4ea13a17efd0f25c5c] io_uring/rsrc:
simplify the bvec iter count calculation
git bisect good 2a51c327d4a4a2eb62d67f4ea13a17efd0f25c5c
# good: [9ac273ae3dc296905b4d61e4c8e7a25592f6d183] io_uring/rw: use
io_rw_recycle() from cleanup path
git bisect good 9ac273ae3dc296905b4d61e4c8e7a25592f6d183
# first bad commit: [d803d123948feffbd992213e144df224097f82b0]
io_uring/rw: handle -EAGAIN retry at IO completion time
john@localhost:~/mnt_sda4/john/kernel-dev2>

Thanks,
John

> ---
>   io_uring/io_uring.c | 15 +++++++--
>   io_uring/rw.c       | 80 ++++++++++++++-------------------------------
>   2 files changed, 38 insertions(+), 57 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index db198bd435b5..92ba2fdcd087 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -115,7 +115,7 @@
>   				REQ_F_ASYNC_DATA)
>   
>   #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
> -				 IO_REQ_CLEAN_FLAGS)
> +				 REQ_F_REISSUE | IO_REQ_CLEAN_FLAGS)
>   
>   #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
>   
> @@ -1403,6 +1403,12 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
>   						    comp_list);
>   
>   		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
> +			if (req->flags & REQ_F_REISSUE) {
> +				node = req->comp_list.next;
> +				req->flags &= ~REQ_F_REISSUE;
> +				io_queue_iowq(req);
> +				continue;
> +			}
>   			if (req->flags & REQ_F_REFCOUNT) {
>   				node = req->comp_list.next;
>   				if (!req_ref_put_and_test(req))
> @@ -1442,7 +1448,12 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   		struct io_kiocb *req = container_of(node, struct io_kiocb,
>   					    comp_list);
>   
> -		if (!(req->flags & REQ_F_CQE_SKIP) &&
> +		/*
> +		 * Requests marked with REQUEUE should not post a CQE, they
> +		 * will go through the io-wq retry machinery and post one
> +		 * later.
> +		 */
> +		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
>   		    unlikely(!io_fill_cqe_req(ctx, req))) {
>   			if (ctx->lockless_cq) {
>   				spin_lock(&ctx->completion_lock);
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index afc669048c5d..c52c0515f0a2 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -202,7 +202,7 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
>   	 * mean that the underlying data can be gone at any time. But that
>   	 * should be fixed seperately, and then this check could be killed.
>   	 */
> -	if (!(req->flags & REQ_F_REFCOUNT)) {
> +	if (!(req->flags & (REQ_F_REISSUE | REQ_F_REFCOUNT))) {
>   		req->flags &= ~REQ_F_NEED_CLEANUP;
>   		io_rw_recycle(req, issue_flags);
>   	}
> @@ -455,19 +455,12 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
>   	return NULL;
>   }
>   
> -#ifdef CONFIG_BLOCK
> -static void io_resubmit_prep(struct io_kiocb *req)
> -{
> -	struct io_async_rw *io = req->async_data;
> -	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> -
> -	io_meta_restore(io, &rw->kiocb);
> -	iov_iter_restore(&io->iter, &io->iter_state);
> -}
> -
>   static bool io_rw_should_reissue(struct io_kiocb *req)
>   {
> +#ifdef CONFIG_BLOCK
> +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
>   	umode_t mode = file_inode(req->file)->i_mode;
> +	struct io_async_rw *io = req->async_data;
>   	struct io_ring_ctx *ctx = req->ctx;
>   
>   	if (!S_ISBLK(mode) && !S_ISREG(mode))
> @@ -488,17 +481,14 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
>   	 */
>   	if (!same_thread_group(req->tctx->task, current) || !in_task())
>   		return false;
> +
> +	io_meta_restore(io, &rw->kiocb);
> +	iov_iter_restore(&io->iter, &io->iter_state);
>   	return true;
> -}
>   #else
> -static void io_resubmit_prep(struct io_kiocb *req)
> -{
> -}
> -static bool io_rw_should_reissue(struct io_kiocb *req)
> -{
>   	return false;
> -}
>   #endif
> +}
>   
>   static void io_req_end_write(struct io_kiocb *req)
>   {
> @@ -525,22 +515,16 @@ static void io_req_io_end(struct io_kiocb *req)
>   	}
>   }
>   
> -static bool __io_complete_rw_common(struct io_kiocb *req, long res)
> +static void __io_complete_rw_common(struct io_kiocb *req, long res)
>   {
> -	if (unlikely(res != req->cqe.res)) {
> -		if (res == -EAGAIN && io_rw_should_reissue(req)) {
> -			/*
> -			 * Reissue will start accounting again, finish the
> -			 * current cycle.
> -			 */
> -			io_req_io_end(req);
> -			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
> -			return true;
> -		}
> +	if (res == req->cqe.res)
> +		return;
> +	if (res == -EAGAIN && io_rw_should_reissue(req)) {
> +		req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
> +	} else {
>   		req_set_fail(req);
>   		req->cqe.res = res;
>   	}
> -	return false;
>   }
>   
>   static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
> @@ -583,8 +567,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
>   	struct io_kiocb *req = cmd_to_io_kiocb(rw);
>   
>   	if (!kiocb->dio_complete || !(kiocb->ki_flags & IOCB_DIO_CALLER_COMP)) {
> -		if (__io_complete_rw_common(req, res))
> -			return;
> +		__io_complete_rw_common(req, res);
>   		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
>   	}
>   	req->io_task_work.func = io_req_rw_complete;
> @@ -646,26 +629,19 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
>   	if (ret >= 0 && req->flags & REQ_F_CUR_POS)
>   		req->file->f_pos = rw->kiocb.ki_pos;
>   	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
> -		if (!__io_complete_rw_common(req, ret)) {
> -			/*
> -			 * Safe to call io_end from here as we're inline
> -			 * from the submission path.
> -			 */
> -			io_req_io_end(req);
> -			io_req_set_res(req, final_ret,
> -				       io_put_kbuf(req, ret, issue_flags));
> -			io_req_rw_cleanup(req, issue_flags);
> -			return IOU_OK;
> -		}
> +		__io_complete_rw_common(req, ret);
> +		/*
> +		 * Safe to call io_end from here as we're inline
> +		 * from the submission path.
> +		 */
> +		io_req_io_end(req);
> +		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, issue_flags));
> +		io_req_rw_cleanup(req, issue_flags);
> +		return IOU_OK;
>   	} else {
>   		io_rw_done(&rw->kiocb, ret);
>   	}
>   
> -	if (req->flags & REQ_F_REISSUE) {
> -		req->flags &= ~REQ_F_REISSUE;
> -		io_resubmit_prep(req);
> -		return -EAGAIN;
> -	}
>   	return IOU_ISSUE_SKIP_COMPLETE;
>   }
>   
> @@ -944,8 +920,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>   	if (ret == -EOPNOTSUPP && force_nonblock)
>   		ret = -EAGAIN;
>   
> -	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
> -		req->flags &= ~REQ_F_REISSUE;
> +	if (ret == -EAGAIN) {
>   		/* If we can poll, just do that. */
>   		if (io_file_can_poll(req))
>   			return -EAGAIN;
> @@ -1154,11 +1129,6 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   	else
>   		ret2 = -EINVAL;
>   
> -	if (req->flags & REQ_F_REISSUE) {
> -		req->flags &= ~REQ_F_REISSUE;
> -		ret2 = -EAGAIN;
> -	}
> -
>   	/*
>   	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
>   	 * retry them without IOCB_NOWAIT.


