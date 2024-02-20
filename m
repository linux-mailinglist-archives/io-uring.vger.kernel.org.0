Return-Path: <io-uring+bounces-660-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A6A185B543
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:32:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21CE42877DF
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 08:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2CF05CDFE;
	Tue, 20 Feb 2024 08:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZKBlnOZ4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NP+ZaOPE"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88DB5C5FD;
	Tue, 20 Feb 2024 08:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708417902; cv=fail; b=TFoo8/WrerS5WYBr131nRGhRiyWS256G7BNcWPc7HQRFa8vD5V0X+cgnxdXc6euO9+pzDlSpB7cmrCTWFWjqhRaQK5LKWwXHIbe7ulXKriNMP6iXPxLMSzE2qJCm6KrJvFGSExuviQGL9NrvxvWnom4EfYj66n42mEjVEDHzYG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708417902; c=relaxed/simple;
	bh=GzKpaQoC92VaPmqDdTJxgoh7r8IH4YFTqld0cv+qi6U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PFUzGan4Nx2FTILJtbBBZk0f4JXU4gEHRcemdCM3uaQ3oUKWnxONeSG2Aa/5ao1vVnogyB72+Uadsy7QucUJfSanJxMpiecFLyJQfhSYAFbD31N7wkEZVPQC0lkx0siSQNWZoakBGEJ22oHP2WKeerjx1+tATQwvJz7wMRFNYPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZKBlnOZ4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NP+ZaOPE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41K7ddxn023898;
	Tue, 20 Feb 2024 08:31:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=nDKwKFmo6yQ7npsYcQEeMghRzJ6DhGxC6nnTLiqfXRM=;
 b=ZKBlnOZ4KTewGxD+wjsLvoS0UPn3YkfausnomA2KXrIUwGqMxrvLJCc+Codb/HcIb0j8
 Anrr0ZxPNTe/DnKxAamQXCHNK48L/+Xr/GV2/UieWFW4PiIDxPMIWNuXhGYdpGv/gt7T
 PgcTAMKk3IJoEb1WWRTzktdcjb1zuk8jFnWNUZ2WcJTgSiwrB7LFmdR/gZz6ZLzqd/sp
 m7jir8WOIHIFFJYP3mrqztShuVEklpaLv5WrzGchF67k5zNzwuVzyBKWq5GuBXvmfh/7
 aOJAqYdYp6mu2vyzOWe+upKQq+vlt1K+/fAx8ZH9v51zzaVx0MPvPAgFJ1tPkS5ZW1cL Ag== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wakk3x4e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 08:31:17 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41K7ljqC032725;
	Tue, 20 Feb 2024 08:31:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak86wrrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 08:31:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hb/9USuvb+ky5nqIIG5Jnv+VE5DxN1SKuKgzEHzIupOcqbqgta6xdwnWBIGeKmRXjlziGIUaj8g3RCoSHLgj9lFcYsfNkiSso2eG80KHOuVt0GDbKlXmOYCxoUioM6A3dRoF46CURp9Nk7IHvkMpj1KIXyr5yHA6VQjAGat+EO06a9rRRNsu6HNgutEgdytBHi2xG11kc+9UqZdqcI6ETrTLH40RzUSC1gEoGOL8vhjWrSwEJMSJ/UsObY69j9GTYN0L2K374y5n9+7fWa1h5DyJv4b8yGwRdpDwnziaEb7BieaRJwgTf1uRziF7NgXDNcrtg9vaH79GiBMQEk6OXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nDKwKFmo6yQ7npsYcQEeMghRzJ6DhGxC6nnTLiqfXRM=;
 b=fv4AChkwUhNI/5jLzMxInUUkA/otFC8p70bWfVS6sGYyztiSyYwsQVjlx+LVR3YYUbc8O2fM2ZrqEHaeDJYdfeh0nmKF+d4kKTx0qGoeFgNd7sYb9CYjt5AO5yoZdXyR+aWAWkXj8KflJl462/4ksTpL7nL7u2PLYXKgKkY2i7veXg8DST1SIYdff9JnbvzGQgpJEW9dNHGLjk3EvA09rbtXeIiISRkOC2UIQexOLSCgvaLzOndJuftL/gP5SNm1LHyi4URfBZxDpD7FPQ//lgB2xrGSZIMBOQEDVe5L/ZPnkvEvGNsabZUCh0dXnSfiNMQgsJyqKQdIKKWjhZWlZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDKwKFmo6yQ7npsYcQEeMghRzJ6DhGxC6nnTLiqfXRM=;
 b=NP+ZaOPEsfsFW8hYcSyCG4GRFCMho/nrn+axj7RgbxgH1adVdwA5AIg1e86ZGxgdDoJlvYIv11E3Ik2T/rPeWEz71c9Ei/STB+MXa+JoreY3Mz/XtyLc5y2c2w1YX7yjvDVY0+ANRak7G3cbkltsfAiJvrLkGQyTwX43TZAeVi0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV8PR10MB7726.namprd10.prod.outlook.com (2603:10b6:408:1e8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Tue, 20 Feb
 2024 08:31:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 08:31:12 +0000
Message-ID: <d31a99ae-448b-4c0a-9ba6-fc82e24ad25c@oracle.com>
Date: Tue, 20 Feb 2024 08:31:08 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/11] block: Call blkdev_dio_unaligned() from
 blkdev_direct_IO()
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-3-john.g.garry@oracle.com>
 <ZdOklTSG9tHuYtGi@kbusch-mbp>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZdOklTSG9tHuYtGi@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0178.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV8PR10MB7726:EE_
X-MS-Office365-Filtering-Correlation-Id: 33eb8deb-a7c6-4c35-f461-08dc31ee4c06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	MqP0eVTuEfj9HRd9EbImhaY3fkxqfjIKTILuni2mNWrf4acDKg2xTOf/zTCK/sQhXdt1WlsdX29/maTcv5dRRfUpI9Bsq6K7xEgZ699CvnuGAwJkUNbRPoWpubOnB0AR9Od/ix0HquX9vP2j58WgiwbgZNV7VBxeNUH0pfO7snhgdwsUZmE5IOfZiV4D8jw3bIxtnXgweZMZQj9TPdvU++Kvg7T3LLb+S6eLDAj4VcC7u/oSriKU1ZmuJsFqIRWVjBZzHc5BAA+DUdPC6qQ9YvDyxA18m1bHbia2uezUA7ToUEp4modY5su672nJweJ9mVbDYVqtgfD5eAUgUMtt+Z/jQga77ajQAD0gV9ZnXxtffGPVB2CapIcqjqD+12C/NEkq/8v6igs9Alj68RIdxYDaHGiKJzXesGdugJ5EwyIrCcHPkAdZezHUKytPoDXqO+eeqAssKP8caIcowqCWpUaBS5Rtnisnn6LkpRDJzBtjvyY9HpBVd9QHEEqRXU2jXLjzIZ9/76TpIO9TFobN4g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WTdmc0k0T0NiczlQT0lxbmlQbjd0UVlGdjZRUHBFV2Q4N2o5MTN3bG81ZnRy?=
 =?utf-8?B?emtqSDF6UG5WY25DRDlmZFFCTmRTUXJqdkpMcCt2Vm1WVi9HdkdQTXZyT2tp?=
 =?utf-8?B?MjhBUXJUeXBSVmF6cnUzNkk3dHZ2MnBRQ3RKMGFoU01OcGNYdjd5RTgvR0xk?=
 =?utf-8?B?YkZYRFRMbksyZ1l1a2xHVmZkWFVDQXFYNjEwaTlKTS9WelpkQkl6cC95Vnkw?=
 =?utf-8?B?WGdJNVJ2Rk45TUhzNENPQTB1cFFjZktSV2l5UVM5cnR2bk16Q3REa1hsa3Qw?=
 =?utf-8?B?dm5pNytBN1grbnN1VmZqakxkZWhlUGJJVUpHN1FZVndHeHBWR0pPOHRtMnI5?=
 =?utf-8?B?dzNKY2QvUStIdlJVekRIVVk2UUVMNmhWQ3hVcldrZ0Nva2dyRkQ3b212eXIw?=
 =?utf-8?B?cGU2dG83YTd5TC8zZ29LTkMyZm9QeVN4ZnVjYkRIVXVraGg5ZlpRY3Iya1FR?=
 =?utf-8?B?MVZGL0RXUm1EbUw2ZUpMWGFOV2huN0dtOWVIL0ZoV0pJd3pDSWZHNmlSL1dH?=
 =?utf-8?B?QjVJQTM1TkR2RXdkUXRQY3ZweXhQc1lPeXFGckNkcEFXODdKOUVkVmkyTnYy?=
 =?utf-8?B?eG5YNlZiZHB6ZlQ1QVlQRmF0ZEl3VkNwRWpkTHNyMFJhQ2ZCdTMyR05GZWtx?=
 =?utf-8?B?WHlGMFR2eVhoYzYyQlRGRlp4Y0JWWExhRVIwdTdVMnk0Q21LYld3NXNvVzI4?=
 =?utf-8?B?UVh5aE1HdlZtZDRqTHZWQnJjOTZ5UUNUeE1td2h0T3E1NERxeFJ4K0ZwVnZ3?=
 =?utf-8?B?dGIzUHdDclNOOXdHMzd2TDVOQnFORFlEUFYyRUliV0RGbDhhTkF1c2Q2RWo5?=
 =?utf-8?B?OTN1TUJXTXpvTjIyeFJIU0x6eWx5V1EraEVBQUNaalZBUUp3UklieU0wTzRs?=
 =?utf-8?B?aEpPeTE1ekVsdG4zci9vV3loTFBOc2hSSlI4VG1MNk1DeDVuRUNvcVBhYlds?=
 =?utf-8?B?TkZZZmNMaGZPSms4R1JVWHhLNlFwT0JvbFJkdTd6UFpKRzJ3QXBqN1EweWQr?=
 =?utf-8?B?WExrQlhmWlZYSFg0cjB1aEQxTUcySW9QejJpSmNoUjY4UTIvVnc1WGlvT1A4?=
 =?utf-8?B?aFc4SUFlTGViOGxka3lKOTNFSU9YR2hTbmYvQ1F0Zm1zQmNwVmMyUHJnMGNh?=
 =?utf-8?B?a0M0TWlTcHJpRytDYzdycTJ4cnJKNkw1STYyWUJINElUY0g4aWw0a0NNWXdB?=
 =?utf-8?B?dXQrMmNuVXdwaXRGNlBmNmF1Vzd6aG9nVnVzd29QNWYvR0lZVktyZDZ3VDVK?=
 =?utf-8?B?SXlacUlIalVIMkJXRGVEWFZ3RlI2QTMrSFZwTzVEdDNpQUJZaEpWRHc1NlVk?=
 =?utf-8?B?YksxWjdLQm0rYmdKRVdOYnlwblI2cjV5OThzNVBseS9JMkZmT2MzUWk4SFpE?=
 =?utf-8?B?TzJrQlZqUlNMSzlwWjJ4TDJZUGxQejFZMWxORlpSY3pRaUV5c0p0WjA2VytW?=
 =?utf-8?B?R2FGVmZqeEFsckFXR25VUjAveE1FQi9Dd0dWSXVBQWhScGRmb0xiYXJqQVZH?=
 =?utf-8?B?UlozOG8xNFBmZkhNVU5KQmF0TDJGeXFicFJzMVluYmxzUGlhWDUyRk81TXRh?=
 =?utf-8?B?S2d6RkhzNG1SQjVLdjNNbXNmQ2FQSXZJMjAraEc3M002QUZnTlI2aE8vc1JU?=
 =?utf-8?B?ZCtkOFp6aXkrYWhLZzhReHpDSGhtVjg2NkxhNXZ5N1lETEFDbmNyZGl3aWZF?=
 =?utf-8?B?b1VqRHVpdkM1alh6eDFLd1RxTXhIUDhMTUhZL3NhbkRjUjBHYUZkSUovWUpu?=
 =?utf-8?B?cHpxMUZseEVCZHpkaE5mOUFXWE42N2ltN0Z5WnF0QktQU1hRaFV6RDkya3Fj?=
 =?utf-8?B?UnRmWk02MXd0NmthTGc0Zmxpc1FpZ0RRK2RPMmtJQzg1OTBQWEVGaWJ6S1Vh?=
 =?utf-8?B?L284QXU5b3p2eHJnMHBFb09KYkhlYW1WbmM1dHU0KzBaMnJEdk5rbjB5WlpK?=
 =?utf-8?B?UU9hSklqeGZELzRRREI0Ny9tZzhJOUlOaElKMFJjb1psSVcyakNGaTYvaEcw?=
 =?utf-8?B?MUdvU3VJWmdoMU5yODNQYWFVY0ZyVVVackNacEYzdmZleUdnZWpvK1RJYkxl?=
 =?utf-8?B?a3JZd05pWlBTa0FrUitjcm5FVXFvSS9nYWFIVGpDZFZBVFA5ZjdVQlA5R2FW?=
 =?utf-8?B?cTZ3aXZkMkVWMDJSUjJtWmdXam5WWWUybmEzZUY5cWdyY3pRMDZKekJIMmcz?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	WzBCWlwrrAcqVQlmNxYbMc43howIJGMze1fwg6HHIMqG3DrNLdYorrW03+i27X6qYdxnzcH0I+Fp35vZdDhs9+di4/PuDujlCwIBHaGaafcZ61tFIlv8xJlrdb6jvzNs4QADZGAVjWMMZNay3GiAjxnza4tRr1yrRI5aQLj2/O6CxwvknLyBgRTt0iEae4/8eTzL+0A0TzhVzXTG3E4bMl9JTm+cp+FzQi2ZjyaeLmPwSq2ZPOHVcK6o8pO8B55BI6Lr+QJArtUdkSmtLeTJm8pPkKXpUO/rAzqDp++cyN8YiJWDhxDDvmS7WOfE5bVyQTPOkbE6K7AbKMcwT6BFt2hU5cVgGZZojCbNISpn2DuQu3Ay67NZaM8BTkxVdce1qGbVtCgiYeDBMpkTJGeKf4GPH0ExU7LNJ8YcjxhusQpMiza5YmH7cazxfoUH7iMeOjuLHVwuJuGoJjpuu5K4Mt68oxuZWI0/40fg/GgPXCA5ljC+I8Ta8NCBvayCGENnjWFVWT3eyID/U6FE2Wo0T9X6R8C6RMo4+MxLsWGxj64rEJTnmWRsu/CzUkTtXXcjUrijzcPSaftNtKJdujN88gjs5VwQQT5YSTt/DXQyce0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33eb8deb-a7c6-4c35-f461-08dc31ee4c06
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 08:31:12.9036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zLDakLeWIuxZ8wFlWVx2shX/G083FPFMvz2XPt4FH0dFA33Ft7AIptbt4HDqRENpxgumg6hpG5YtefMPVE8wSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=889
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402200060
X-Proofpoint-ORIG-GUID: YVXq-oZyAjtrTAZdv9u5FBUgKzxiH7tV
X-Proofpoint-GUID: YVXq-oZyAjtrTAZdv9u5FBUgKzxiH7tV

On 19/02/2024 18:57, Keith Busch wrote:
> On Mon, Feb 19, 2024 at 01:01:00PM +0000, John Garry wrote:
>> @@ -53,9 +53,6 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
>>   	struct bio bio;
>>   	ssize_t ret;
>>   
>> -	if (blkdev_dio_unaligned(bdev, pos, iter))
>> -		return -EINVAL;
>> -
>>   	if (nr_pages <= DIO_INLINE_BIO_VECS)
>>   		vecs = inline_vecs;
>>   	else {
>> @@ -171,9 +168,6 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
>>   	loff_t pos = iocb->ki_pos;
>>   	int ret = 0;
>>   
>> -	if (blkdev_dio_unaligned(bdev, pos, iter))
>> -		return -EINVAL;
>> -
>>   	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
>>   		opf |= REQ_ALLOC_CACHE;
>>   	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
>> @@ -310,9 +304,6 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>>   	loff_t pos = iocb->ki_pos;
>>   	int ret = 0;
>>   
>> -	if (blkdev_dio_unaligned(bdev, pos, iter))
>> -		return -EINVAL;
>> -
>>   	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
>>   		opf |= REQ_ALLOC_CACHE;
>>   	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
>> @@ -365,11 +356,16 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>>   
>>   static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>>   {
>> +	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
>> +	loff_t pos = iocb->ki_pos;
>>   	unsigned int nr_pages;
> 
> All three of the changed functions also want 'bdev' and 'pos', so maybe
> pass on the savings to them? Unless you think the extended argument list
> would harm readibilty, or perhaps the compiler optimizes the 2nd access
> out anyway. Either way, this looks good to me.

Yeah, I was thinking about changing the arg lists. Specifically adding 
bdev, as that lookup takes many loads, so maybe I will make that change.

> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>

cheers


