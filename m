Return-Path: <io-uring+bounces-663-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 92BDD85B6B3
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 10:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE8CEB22262
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168525F550;
	Tue, 20 Feb 2024 09:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qta0vNrC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DUbwkuOq"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6912D60ECB;
	Tue, 20 Feb 2024 09:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708419997; cv=fail; b=mm+XmDdLoaqdSaTSnIKu1eOPgpyNcBpurEAzbpyaTqTJK+3iRMfmAP7jhzWm/4lWUnar1kM2cwECIz6NGD7P/W0h6fRWAsn8YHnZ79gZ2CyRdlv8qGsfQPNFMsQQWMVSMVGrq+G8KePy5fUSdO96G9F7rjwfeRQzZ7YW/MAYoBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708419997; c=relaxed/simple;
	bh=Ez0rHHrqU9EgT68OPqfFHKkHxco2YTM8E5G1vns3OLY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=idJmStp+fsbMBin/RT7X5eNbKIU7mKsWDLJcu6vBSbwEhr/wjaUOcot8T4myemjKS/hoKBuuVJjI/Yv+gjTPCtewZESj+khlYVoEaYzxTyk72Kxln9WnnQxjiTED4E4QVrCfpdbuxUoPG1kzm4eP2ZllxpOz1f9TAP9tRCPrE88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Qta0vNrC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DUbwkuOq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41K8xTQO021584;
	Tue, 20 Feb 2024 09:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=pq005VVgaFTfvD9PzC60PVZSR3UkkssVYDsKlNyVAaE=;
 b=Qta0vNrCg6TajcMgHggY6ry4bZMaJuZK7VzQB3PnSeOukgi8fnoZMXxd7CulPi+Da03r
 gqofaTdMVEkCkLNYlAaYBLB4mrOlQhltl2S9TZYRank3Q5v2/nLZMC+VlwDeYNb5Mssk
 451v+KW4bPS6WXrbpCVZfUnTqtJIeCU/7sF4LtjDTSbC1HtRnGG1u5zsIgFefbB/ojSa
 lGvcAfYcfgJerNkofXEwupEDiRkbV/uKQ9N+A/vdj/WOzC1elOmZLH5CxGytXHO0UVtS
 KNOCkaK50a0ySm2WhrUu/AecUvIgYOwit1Mi9YWtdmpKrwT/nYhyp9z66sQPJ7SGiqDK 8Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wanbve0tc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 09:01:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41K7xvn3032491;
	Tue, 20 Feb 2024 09:01:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak86xrvm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 09:01:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=USlxDlAkSTu340vSd2F1/3DKwhjjcCD5Q930dHDJJC73Md9UPFZSvd5NmBlrPr3Kqg8qZYkhqisU1uv+D5xKF/VP+5jCHuIMHx+dEBLp4p6fLVINOV7fz6vlRePN8SO6QYu4moGIGjto8XX5lMEd3Txb16nY7XSxZMcutx26nfqlzh884ARYp8cgG3j2PfnYgGfEpMmjuFFNfhfE3yjD8812grp1afKZFgGy9QqgDKjT9YF8YTBK0cuL1rv5VWwX+8oi5xQxvxDoaHJB4kWgiQL9HXHmPAkS99Q8pJEtaDq/y6e+KdcJHV6PVis5ewXex2fk5o5u6HkHBew6Sx+W7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pq005VVgaFTfvD9PzC60PVZSR3UkkssVYDsKlNyVAaE=;
 b=dgiVmosaeys9UGKkooD5FrghxjvjENjoq+0wq6xkwyhDrJtPgUSyNZNSZ7iUUDtRNqJTpTBLjcqIPrAhVIjmR35pnZQIFuueYEX69qI2tafp9AiO90NBD9ZSQn26Mxh6MhWadAFsWSrHr5e9vvWuiUu6G9er7mWOfXX8x0i+wkt1a8kIDWG/9u1Bw7tUnvWmKWFuNRSVHyzjh+bI8y5/QXRjwZvXA5Gf2/gs8HhHH81Y1PMkLgarUSk8cqvtp1HIqc4ZASPjiQHVvsIc60E0meeKZSblkx0SqrlwNnW9kB917QQSvKpAt+yubsQFb51Z9saqiJAaDGh58JXpnzLxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pq005VVgaFTfvD9PzC60PVZSR3UkkssVYDsKlNyVAaE=;
 b=DUbwkuOqSz/6FO1TivfQq/05bT689fYuxT2cOMLuncPtaVZwhaGuR647PdpB23uATfHCHbnCAO2pZbHJQx05Fr5Pj160Azur8pj7sPMU2jwQzHPPuQ45/36jKhGIX3rgAU6WLn0bSyBaG6I9FgsED6kQb1y/ibz7TtU01fUovkY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA1PR10MB7312.namprd10.prod.outlook.com (2603:10b6:208:3fc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Tue, 20 Feb
 2024 09:01:19 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 09:01:19 +0000
Message-ID: <4e984b59-b50c-48dc-abbf-8045d924331b@oracle.com>
Date: Tue, 20 Feb 2024 09:01:14 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/11] scsi: scsi_debug: Atomic write support
Content-Language: en-US
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-10-john.g.garry@oracle.com>
 <ZdRQ8mPGRVidvjQI@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZdRQ8mPGRVidvjQI@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0041.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA1PR10MB7312:EE_
X-MS-Office365-Filtering-Correlation-Id: 07251d48-aff4-4bfb-277b-08dc31f280a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lwH8Ixl5WYhnuB71pjxgySaVd4HVagUPMLszckpdlQNYNaW2kI0UPWiveMoBSCMdKYTr3IbroNBmvsJnZgm2mhStbREEyiXC8z9dcSbxRerjHNdn4gACblvL+zsKeNMedSdzpY2Z7Vn9PZsBeJVf1cA5UatgWTJt4w7oy2DKgVbt/VgfZKwYSTHmr90x5Wch+iE4kQgnUTHbcM3pwIukMLOSiERgJBecA3UbYkygai4MD225Pz6XWZJcc+Fo8yVKXHsL9Vk9dQ7DAyJbjATOmsvgvoD/GUmaZ5fHejK3GyPHT1eUFPBNGcOjy/134tIO5MoKLFjrz08o53fWL3AxqIkyUugYyRazt4u9yWZUkMrm7VUYeed527HdN1qCMiZuCP0S2S7cUQqNMNraSzRZdCUWVV86Zzxk5LCr7NTgyjCWFY5pruXj4uTt4b8c8jsSW12hXaE/VKyjJSnpm9CFM9YWywh3kYeDkFRqnFq4CUyH72p0dTJfcKWm2Xyt//4suPVY6QRsMY1aLJOdgIcebcVSLOw6J7I8UqMPMunYpDw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?LzZWMFBPU3pEaFd2cHY2cFJuZldaUzJ1Vjl2QnovYW1YeFpoOHhGQ3ZyMEda?=
 =?utf-8?B?ZExFQndPc3BmOFRTd2loTWthQ1JkZ1Z6N3o5NXM0UzlVcEltT0NFNy9xSjFT?=
 =?utf-8?B?eG8rTDkzOFlIcFRMV0NiRXdRckxUOEpNdjFjZ2JMU1Z1YlRGVUhRWGhyTC9G?=
 =?utf-8?B?Y2NSVnN6UTFUUnZiemJObTNjNHQ1REhLd3daQjRJZERkV25lNkc2U3YwMUxp?=
 =?utf-8?B?clhaR2N1SmZuQU5CNnRnWVRReXRJYTRwQ0VFaW5UcHlkWDVYaGVmQWJQUEVl?=
 =?utf-8?B?KzlVbmN0Y3g0K2xRQkFRbXl1akJmSHpocVFkZTRRUlJOZ1VyNU50MTVLUnlP?=
 =?utf-8?B?RzhXcTZIM2NPbXZqQmxObkNMOFcyK2hGV05PUzBQM0orbGtVNHoxbG53OW95?=
 =?utf-8?B?RllpandNR1ViNGVMcndnQkc3VEZkN3RqVkZOSEJRSzhVa21lZ0F5VHhGQ1F3?=
 =?utf-8?B?OUdzbGNRMGprZ0I2Q2Y0ZHhsdUpaNWhVZFpNQXdzeXN6dmtwN0RCLzBCZTJN?=
 =?utf-8?B?cWt4ZHM1clUwWXRPTzhBMG1TcjhpbTFlbWdvWVk2V3cwb1NJdXhkZ3F5ck5Y?=
 =?utf-8?B?QzJCbWtDaEkxcm9zVy9QcXd0Ym1lL3dOZTNqM0Q2WWFoQkplTlUyWGkwdnE5?=
 =?utf-8?B?d2lzdDBWdnc3Q2dqOVlpVzVLQ3pJV29zbUUzdXRtenpMaXcyeDJ4QWcwTlFP?=
 =?utf-8?B?eXNyQUVmdmI2YUFaZ3dOVnY2dHQ4L1k3Z21lcGxGanU0T3VNbFhTQnFmb0hB?=
 =?utf-8?B?Q1hRd0RDTGcxM2ZyU1FyWDd2RGZ2dWVDRi80OGRIK0g4NmlhdVpPTlErZWdF?=
 =?utf-8?B?YlZkbzdBMHByak9aTi9iRm1sck9zdWQ5OE9tUTAyb0Jnd0FzaG81M2JaL0p6?=
 =?utf-8?B?ZFBGQTlkeE9tVUxxWTI2NUsxZUc3QXZxdEZyTUc4SktFeHNTY0JTRThiK09J?=
 =?utf-8?B?NE5jbmhkaTJRaVdpMXBNdjRlSlhNQjZyVTk4MnBzZFUwWlpZYUFlNUxJdjRx?=
 =?utf-8?B?K0U5bVBZK28yZDN4Ti8wY3pwcytKRGdLSlhmSXZHMlBRN1FDanV3cVlkWjhw?=
 =?utf-8?B?c2FNREYvZC83TURrdlF4VmpvR3ZTL1oreUlXc0d4T3hEN01ZR2dkL1FOQm5v?=
 =?utf-8?B?OFVSTjdUM1pkcjFYRDFXTkVZZGlINHJ1Y3RITit2ekd6Rk5GZDBxaVVnT1Ez?=
 =?utf-8?B?UUNDaHQvdDRiVXl5UE8yT09mTzFSL2VSdFVYNkdmL3pwUE9iTStQZVo1S0Fi?=
 =?utf-8?B?QXJzTHFRblAxRUpNRlNuQ3FEVUdKdjhvdno3QUtEOHNGV0RsMDMyZGJFcTZv?=
 =?utf-8?B?Zmx1dXZDYzB5S29zRUZVWU84eWxUYlhWZ3ZHNmFMRDBackdiQUs5QVd0REJw?=
 =?utf-8?B?TE9XQ2FFY0tEbTZDVXpWbGRqUENyVmdwcmkrU0k2NC8xTnZpTWc1d2t3SU5G?=
 =?utf-8?B?dlVFaXdvNFhrZHNoczJ2YkhMOTFGY3pZNzBlUlBzUTM4YXp1WWJMTGZRZUUw?=
 =?utf-8?B?eWw3M3RIYkV6QU9yTDB0Y005UXBNRS90VHJ3R1BwUEs1RnFqWnk3NXJuLzVB?=
 =?utf-8?B?VmxRTzMrT1J2d3V5RmFYNzM1NnNsUHFSRHhIZ2FTOXlkUW00YjhKYW5rTC9X?=
 =?utf-8?B?bERVcEhxWHBONTNmUm9UNmlzdVYvdnlxc1RJRXlxMW5iOW56eXZGZjlMQW9w?=
 =?utf-8?B?NjFOb0J6MGlmKy9NZmFmcUx3UktFalVORit2Q3loL01Ud0lQNXAvTWdKbUZx?=
 =?utf-8?B?czYvckhTWTB6V0hacXpwWDBRZXJvSzA0c2t3SVpNY01WVHJhM3BabkFwOE9a?=
 =?utf-8?B?QU54d0NJcWgyaUV5MFhXd0NoMzNkc0ZNaVZDU3dnYXQvRm5DRktzS3p5VEJK?=
 =?utf-8?B?dDRsR2padkU4NWNHRUNRQVBRd2huTDVpS05HYlQxRUZhd1JCc3VvR3RZTlJS?=
 =?utf-8?B?czlDSURRZTVKVW5jdHNsUi9tK25OeXlUcmF5RWhZQ3I2ZGdkRHFiMmlra3oz?=
 =?utf-8?B?dHV4YUFwbWNaNGErQ2tHM2dsRWtMMWo5RU9rMC85L29KQ0ZVNDhXUks3bFNi?=
 =?utf-8?B?SlQwMFBvaW9XNDdvK3B5dXBMSE1aUUNZcFhMdzNZYmtTT2lRbW96dkZGV1Vo?=
 =?utf-8?B?YXZTN1ptMk1PVDhKWXorQjRQd01pak85TkpRVmJLNFYrdURFcXZwRnZya0ti?=
 =?utf-8?B?ekE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	om0ftdRuWoNi9FRqI2n3kX1XJDxQAUBO+63O5gX9OALvLb/+oqPJV9zdijp+vUNiTnvbDN78CYMpYP54i7IfK4n2f02R6PMlLng+w3G1HN2lL/GO0iDcuJWPMVkWfV7ehRWdHgiw64OFfhcmM+oY1cuOSGuVz/ywFEmda2EK3Pe19dtw5ppOsVFLKWG5NpMC8+tOzMz/DU2x1L9qW+B2hzeV7amkT13ok3S2lSIW6xpIQY9DfjQldb9LYIlBxIf6lvWdQu4ZyArO+wqgmtqIRArUjgH3/tbKsxiAhntv9jZsLLJgzJ6l+TmxlIB7m7xIEXh5eSjiOoRPTVfjxy6a60hznVj3miiN+4z91clo55VW+pxYcAMojui8NN11O/baxRSqssckMaxzr8vkkngbb5D37/5zgtGsgumzi4Bt42X6McbzVdVXFQc3Bu10TWHyRegEjTO4pitqx46S/Hv/ssikdZPMySb6I+LzIoBNdb3ighfugIk6srbebBurLCpBzFVcUBXnqyOuZoraYhg7siSfR8mkHnZu40bz2geQkjVzfbXpPYCj8b5rooyjDiTpF/lVYDo/QZ6koxcyT06Kv75YxocxPH9VcVTFgU2j/7Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07251d48-aff4-4bfb-277b-08dc31f280a3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 09:01:19.1599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtpvMY9boec9nJXCnBD8evLeMVROTiH2WZ9LWWDORp1Qkf+4LKX5qkUvqMJO1q0WpAmcuwbOdHdIO/DZFhNtZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7312
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402200064
X-Proofpoint-GUID: CF3k8tgFHOOWXNY8KSVjmqPuBAO6EChe
X-Proofpoint-ORIG-GUID: CF3k8tgFHOOWXNY8KSVjmqPuBAO6EChe

On 20/02/2024 07:12, Ojaswin Mujoo wrote:
>> +MODULE_PARM_DESC(atomic_write, "enable ATOMIC WRITE support, support WRITE ATOMIC(16) (def=1)");
> Hi John,
> 
> The default value here seems to be 0 and not 1. Got me a bit confused
> while testing 🙂

I can fix that MODULE_PARM_DESC() text.

I don't think that many disks support atomic writes, so I was leaving 
this disabled by default.

Thanks,
John

