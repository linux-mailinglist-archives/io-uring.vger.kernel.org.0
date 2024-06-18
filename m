Return-Path: <io-uring+bounces-2247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60AF290C652
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 12:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FF65281740
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 10:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807771741E4;
	Tue, 18 Jun 2024 07:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GI6WUxeQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="z7+37N/C"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E64E13B798;
	Tue, 18 Jun 2024 07:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718696836; cv=fail; b=VWZgAeTqwrnNkOGkTJvnwPrYKNNHaJ8apBdfG0ea/zDzLrY8ksK7yx/2z/7oBvnEdKJEFKDeRvFpayEVKT+KOBAoyPiIHAVbMTyn9Pvw0XGXOBpHKl1l9QYxndWDMZvLGdV2yW6J6ATThcSceiB+d27F6Wi9sFFQjsnl/fLreak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718696836; c=relaxed/simple;
	bh=T/WKeJDs93YMJy9TeEQTEAXv2Q+y+VFQJCXojBkgsgQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OynOVWKR6R7/3nqtsk/1iU/pi6tD9HaZlabbhxyy3vcj+NtcucdsuISpyiFUeE02wfAwEBqYLEVW5K0z855WAYcX43A5A3VcuYoZaGFf1tr22T+2aL/znNfAiZfPs3ODtpkTUiKDDC20wPvYwiMhf8JMYiUwG8X+WOz2Z8L5py4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GI6WUxeQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=z7+37N/C; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HMXVXx023597;
	Tue, 18 Jun 2024 07:46:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=SJWrcSH2ZRF4o9dNn2rmHiCaLg9Ssc3RWtgs951gQxk=; b=
	GI6WUxeQGQ4WY+UCF472tHeWA6+EpFmMKpxpKNoOEJK085VIAEmTNF2ZInVUgK/q
	o5XDMJy5TAV7RDc5bxwKw8HESHpLGe9s7ZrXFEsvbAau4lLzI1upE1UeAVpHxsAq
	AkMF5AlODkGCM+R9+BTS+Qlfzk5UbiHjh/LDJKfBimoo3xe5/ide8N0gE9rSDei3
	5XEGRiI0RHqDfnywSW6ii0l9PV4k8VD2LRJ6b6R6RRYwlnXpG1+N3Nl1Ku6uza/J
	SzI60Z5lITzSamY7sQ/08YZOwv9kq42ChCB7pYZyChANJNhb5d4I8zl3JPtNjYAW
	pN/uGihrn2bYcndvvQkZ2g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys1cc4av8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 07:46:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45I70266030096;
	Tue, 18 Jun 2024 07:46:41 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2047.outbound.protection.outlook.com [104.47.51.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1d7ngdw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 07:46:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQz7RkPi307kKPuwGkz/8xqdREJdTWmi54cuTnxadvGIT5FzCqzidmA7r8exigao9b867sN9CzKApniHzGAtqXFt4m5Dkl3MzNHEexMWoYEUIPmneIezsidNvRp/Eo1hplAmJRDvutGXzts1S/v9t5c/S16mqwcsToQ6416+rTFgo63QXAM4jA7la5vH0k/yyJuNJcmJre+l2Hq+75yGIcudysYPimUxQS5lutSN6cU9KXFWcsoMubqSzimRbWO7gNIauAHFhWP6EUSJgMlD+Tus0bT4tcgMO0+NtndQhbsEzgFL1KFI1fEycENGIrXRHlSqDkTvbv/Log8TiJuAOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJWrcSH2ZRF4o9dNn2rmHiCaLg9Ssc3RWtgs951gQxk=;
 b=MZvDcZ/j9sZJycu9llEnpKo47SUZvRPbOT+srh0sIor32QbHXLJU6HgDucUQtZlYLBv21oK2W28kwjO6shivcRGGTx6lz732fvKuk7bvWO50aMK0hy19CzHwG1j26f2WG8CwgnQzcXcWYlxyJpq/WX6ZqPHAY051gN/HrTQoyjPMYYTUF+pcqSLXf9LsUPeS6JQp0g8dUAF2dPiJVlR5H6xTTAEPWdtnXCljzhcUzdXsmsrqa3WztSs+T/fCXkYfY42wRHBJRpsReyrgXhqXQduwH2H7GSpWWe8thPgj9A4EeiX6SGGYiR7ryQ+GWTxHVvqF3gRQ6ClTB6BkGXgPlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJWrcSH2ZRF4o9dNn2rmHiCaLg9Ssc3RWtgs951gQxk=;
 b=z7+37N/CGnLCE9wxazlfUb16y4fOf9Tp1HnZ4s0gnxVODWFfTmkndFyQQEJlyCqUw2L2QlqhvK7FFNikymF/fskIALB6spVVEXr9urnZxleZCYdD1U54PlvaL8ihXubEthpNg3QSUMQcnTpqem7a9fIymEIsAWTjIeWrDBJhqbc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB4828.namprd10.prod.outlook.com (2603:10b6:610:c8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Tue, 18 Jun
 2024 07:46:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 07:46:39 +0000
Message-ID: <91e9bbe3-75cf-4874-9d64-0785f7ea21d9@oracle.com>
Date: Tue, 18 Jun 2024 08:46:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 05/10] block: Add core atomic write support
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
        djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
 <20240610104329.3555488-6-john.g.garry@oracle.com>
 <ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com>
 <20240618065112.GB29009@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240618065112.GB29009@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0104.eurprd04.prod.outlook.com
 (2603:10a6:208:be::45) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB4828:EE_
X-MS-Office365-Filtering-Correlation-Id: e2d03cab-631a-4c71-d58f-08dc8f6ac958
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|7416011|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?R094TFB2bktyZks2WkFWRlNlVzd4QmlGM0hiTEVRWVo5WU95bysrV0FWWDEz?=
 =?utf-8?B?d0d6ZGkyZzdOZC9OYXVhNUliK3lSUGpNQ2tYR25obnpKd2NKS3dXcVUvekc0?=
 =?utf-8?B?aWNNR2J6Ty84WGVDL0UxTHFyeHJkWjBnL3JyUHBaMENOVHY1b2ZzSmVPc21J?=
 =?utf-8?B?MGlTVG82Mm9jckcyc05CTE5NTE5aV080cUNIZjA3NDlObmEycVZ3N1REK3dJ?=
 =?utf-8?B?ajBieFJBTGRNTjRmdW5FYU8vUHNaMVB1NWdXUjNiaWlFZDg3NTVqNE93Rlpi?=
 =?utf-8?B?RWhCbUtOMnhGL2pHUTlYbkhYWTVtbnU4SDlZeHhGUjYzbHlacE1la1ZFT2tC?=
 =?utf-8?B?eG1XZ1hrNS8xaGVMbXFRd2trb0V2aUdZWVk4K2lKVzRRbXZzKzZZdnNQbEZ1?=
 =?utf-8?B?VmV0S3dZVk1CR0dVdDBsQU8rWDV5K0R5dzI3dmpaSHN6RzNSazgwbUFXa2k2?=
 =?utf-8?B?anMraWNUWjJrUUM4Tkx6cjhJalllNkd1QjFuaXFQNU5DNnkrVVVadWtwemVU?=
 =?utf-8?B?KzgxUGZ3YUl3WStCTmJEUC90VmtONHdvRi9ZM1ZLT2swMlVFRzhWZU1oYTkx?=
 =?utf-8?B?NjFHc2NMVTJUN20wVVJIeEF5aUVFS0dmb3l2eTVjbUN0TjhBTUpQU3BrK3Ru?=
 =?utf-8?B?M0ZGY1hvOC9KdTF6cmFaL0drVzdpTkdUd3hCclRWOUg2YmpQMnRRTXFoenRt?=
 =?utf-8?B?WlRjL1BnbEcrYnoyK0R1VVFTK0dTSnZSTkFrenBUZ1M4RVAzSWNqdFl5Z2pK?=
 =?utf-8?B?cVFZU2VHdi96aEJnazRVdXBpNVVaQ1o3bzdJWld1SWRTNXArNmNFQjhIN3pk?=
 =?utf-8?B?MmkxRU1wOFIxcWk5TFh0b0FLeWdMN2VxQWZQdEJjd0ZMNGtDQ2kyQUJZUWlx?=
 =?utf-8?B?UWdjSXdsZ0pqdnRKbC8zQkorSUszUXVGVmw3NGFrWVpZT3djeVIwK1ZwMWFD?=
 =?utf-8?B?aE95aGZGU2xsbTl1blhvcGJhZlNObHljdEFvZ2YxTUhXTGZTVCt6VmpqOW5E?=
 =?utf-8?B?SnJRRVVOMDdsakVwYmJPaDZ1OU1FSko0ektOSllzK0EyaC8zMlZWSjBRanNl?=
 =?utf-8?B?NnBycGxjTkVJV0ZRTFlXR2htZUhjcEZORFVnRXoyTDVZeHpNVlFQWDFGeFZv?=
 =?utf-8?B?RTVBbktNblZBWVFKNVpjVGp1K3dybVpMbWtLeFZpVjZWRTNLUlVrUWlkTWJE?=
 =?utf-8?B?eUdBZWN2cklBa0VDelhENldNSDgzOGwwRDBqajBSelIwa0hXUGRCU1p0SVpZ?=
 =?utf-8?B?clphVGpVeUNvQmRNZjliRVRENW1PNENER0FLNGRGclF6OGJOZWZHK3J1ZnNV?=
 =?utf-8?B?UmU0cjhNcE9lUkIvRXNwT2dMVjZETGpqL3gwYUdGdmVuQzB5dlZsL1BxQU83?=
 =?utf-8?B?UEZwNVNaV1JjNWZOUXhKV2lTYVpDamw2aHNudVVML3hlSFlKYmZtZ0x5TU5n?=
 =?utf-8?B?VXdxTFpHakNQNXBYTnMrL0VPenhtNWZQRGpRaWZwYXZxQ0RrN0ZubXk2WnV4?=
 =?utf-8?B?aU5veEw2Snkxa2Q0aU5SWHFRUWQ5MjV4K21MUUR4M0ZyaGo0eGZOZ0F6WjNz?=
 =?utf-8?B?Zk5FVDV0RTk5Z0FROGt2V2tqVnljeFFxOFNlWS9aNFpsQWVHeVRZdmp6RzJO?=
 =?utf-8?B?TWd1V2QrYXB1YjhwSUFzVVo2RWQrSXpnc3lqN2h3VFM4V3hYam1zcVEvRk0v?=
 =?utf-8?B?N1prcEtBK0kyWENMcm5UcFR4RXhHU2ZCSUlQT0VLOE9HRk1GbzVzUUx4VkUw?=
 =?utf-8?Q?Sz0tpIDnlxNgnCAgZI=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(7416011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cng4QWdHMEdTZm9NTGFsSmhMQ2crNVBGV2pPSUpGSytEZTJReDdLTW11dldH?=
 =?utf-8?B?SEU3S2lZREtVSW8weEJyY1d5NVA3eHdrY0xZT3d0VEU0TGRoTklLSHU0UWhi?=
 =?utf-8?B?d1d6NzN5Y1FUcUxFc1BjcmFaMW9zbGtjQXMwRTNQVDAwUVNwOUg2VUNXeUwy?=
 =?utf-8?B?NXBvQjFML2xSRDE3WXJWOFNuSkxrdE9RTGlVbTNJV25HdHdwS3FpSUxZZHlF?=
 =?utf-8?B?VnF4Y2FQVmZMSy9SeGZhL0VXcTFjOHgzRkJLbW9uWEVqb2NldnJaelM0dGhQ?=
 =?utf-8?B?eTQ0Rm1FOC9uLy9kZkozbFo2NlRGU0crTENKM1h4cXFPOXBBcjAzNS9UdGxn?=
 =?utf-8?B?ZWZ4ZzE1WlhXa2tFNFZISlJVNXVhc1ltUE9henVkY3FKRVpTR3NFbE1sZlc3?=
 =?utf-8?B?WU54UkU2ZEN6cDRDbnFBUXlobUtndFpsNTk0TEVCbHVXWEJNenVPMklrSEI1?=
 =?utf-8?B?QlA0cmVwTDBMR3A5MFhIRnRjZG4wV0xxK0p0SzkwRmd2UkozNmxudFdxZTBu?=
 =?utf-8?B?UFN4Z3llbldNYnV5T1dZUVIxMGVOMlpyRDBTVVdBSHhxejBzLy9VSU53d0dh?=
 =?utf-8?B?dFdJQkdxcDE4V0ZrVm9tb2FaT2NuWU1Xa04rVEtUWGQwWVFJV2x2bWlDMFdV?=
 =?utf-8?B?bncrY1ZKQjh6cVhXdkdJVW9Xa1pDb3ByenkweGRzTk9qclZJSGtrVHRXdUp6?=
 =?utf-8?B?ZlFQL1ZLQU05ckhiWHM5Mllrd0VCRHRnTUFlMFBlS0lyZG00M0Fham9RNmh3?=
 =?utf-8?B?K2RWOHFmd0FiTDRDNmc5OWVEMklqbEZvQ0paRXA3bFZRa1grZzZmVjVLdVNG?=
 =?utf-8?B?ekJHZ0dEQWdJamhUNmNRU2xyNExmQ0RFd3BUSHgrenlSUGdPRDdpZTBFc0hL?=
 =?utf-8?B?VWY0ZDBZVVB5WmxvZndqZldDN0VJWFNxS1J3eUdDd1Z3dEJTRW1YTlVkZ0N0?=
 =?utf-8?B?OVJ6TGJPMlliWlkzVHpNZytSd01MSGtNTUNUTWdkQXhIeXNiRGM4Y1FRSjg5?=
 =?utf-8?B?NXZYaW9ZN3hpQ1VQSGZhRWw3bHZRZEFyeXdvNStCNEFxRW9EZENuZm9vVFkx?=
 =?utf-8?B?ZmJQMkQzbm9XVnYzNFhUUGVvNHFvRkx0aXpzNXQzL3hpK2ZZZWhaNzZuNmJP?=
 =?utf-8?B?UGVIUUlaeVArQ0hXVDlLdHJrVDBaRnB0UkVienQwd3N3UHVEY1hTOHp6WjVO?=
 =?utf-8?B?Qm1DZndzdUtiVUdNTStCUWpvWTA3REFkOS9XLy9xdkc1cGRaK2xFOU85dmpN?=
 =?utf-8?B?TTlld1d1TkgzK2ZUL0l5Z3VIZkxIZVF5Ny80aHlsbkhaL2V5aDI0VUxZQjY5?=
 =?utf-8?B?UWxuR1lURmt1YmdsWnkvSEV4NlF6RFp4MGQ4MUFNWXFTUWxBOW91ekNuSm9i?=
 =?utf-8?B?U2R1RzdtNXNTNHk4MkVkMjBoM2ZIWFhLZHFVVWtSb2hNUEdZZ3Y5Mkh1L3RQ?=
 =?utf-8?B?b0RTVkJRamQwTktUUTZNOEVOc2VNOWtFUUFSS0t6TkdneTBBU1RMVkg0YVR3?=
 =?utf-8?B?S3lDbFY0Y0JLU1ZHMlhrdjBqb1FCNm5IVG52QUUxcVdmd1hMVUpWRXVvQUlS?=
 =?utf-8?B?RDZzK1hFeWdiRlViRkVHU0YrZFBNOWhobmNEV0dlWnpJSDNLdm5sSk1jZDRD?=
 =?utf-8?B?SXRSamZid3hBVjB2T3BMVWN1ZDhkNSt5ak54SDh4NWs1S1NLVWpwMGpzWGZz?=
 =?utf-8?B?VjlJSDgyWEhuS2RZY1QyRm9NWkRLREhob1RHeHNoRE1TOURQT04wZCsveCtr?=
 =?utf-8?B?dStvUENkdmpEUVJsdm8vTVhPb3ZVWnlSTTZ6MHBBRFVSTG5kQnlUL2RXekJu?=
 =?utf-8?B?cHRrbG1ScmRsN0ZZaXc0azJLVUFLR1FZSUJqZkNpMHNJV1hWU2N0eFAvZ3N6?=
 =?utf-8?B?NFZNQ2RJZnRhdndOUFhkOXkzNlNnajIwL0gxYUJucFZUY0lyOGprdE5qZEJF?=
 =?utf-8?B?b2ErQzk3L3lSSTV6V1JFdEQxQVNsM1pKYUE0NXh5S09OaGg5SmhZV3Zzak14?=
 =?utf-8?B?Z3R4VERQNmZrQWhnMllIa0R0dm5qN0tSMWE5YXluRnYrWlJML2lWWStad0hy?=
 =?utf-8?B?U0ZXT1FSY2p0S1Q1MzB2Vjd4REs5TklZS1BoYVZ6YzRhclcxZVRkb1RYc0RK?=
 =?utf-8?Q?AM0isZP7Vv89+pxwTmxQ7Izt4?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	C2D84DQblZok/K5+EBroN5o6QsbcDU0cXF/d/AV/O4U27RgFaJknnQsPJkxyrOdJ5nQ/Si/nMl8k2Yi2D2+k2sgkXVDKr1OIXuHDATOX0/6zK7BaDg5I1roifxbglhMBH4sVe95f8QQ+z6LgnmQM+6VcSMYEy0mqpB6GVbo3HMiZ1S4P1+o/xBXeZGjPd5bsbiOHsrTHfkITUMN0qNA+IinkisSIQiGAgg9iFkXLxVQp/D+ekGH9GejktyGFtU1m+wBsF89BLqj2cPvJmcG5Ysod7WIBxxVGY8Mc0mMMwpEXddKm0OSd+gb/5EvhSEwxLIbEBD1R6AtGEiNyXTKazafcrP7vwguCzw9tAmdMO2T7k4PGMR3PyBM4ae6NNQLFKzWNDefVCF+i174ijkCYaj+31nln1Ok3nnxJKeN1T/hAhPv77I8GH92tGEmLpVLTL8O2JG5FRg9tg3v18J1enIayVai+tLJByea3axDi5ecL6Pdh/S2NjPKE1WErvtsofY1fUz4CuesY/CfjcsYrpRxtoUlsa7jHzyp5FFq3+G6UnsrYdBnGHZcSOD2WY8KkU4AqiJTXh/DX4hgrLDc51U7ev5w2Yv+BDaxpRz5sc0s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d03cab-631a-4c71-d58f-08dc8f6ac958
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 07:46:38.9482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6CGjnN2TaVBGtmnBcIYsD/MiRkUjmgmX0fnv7GaUU2B4oaIVAL13wRl9lUN+/weY44erFVQJn3d7YkASiCQow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4828
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406180056
X-Proofpoint-ORIG-GUID: RNrxo-0EepZNQj53KQH4Pbg1AJVUoisz
X-Proofpoint-GUID: RNrxo-0EepZNQj53KQH4Pbg1AJVUoisz

On 18/06/2024 07:51, Christoph Hellwig wrote:
> On Mon, Jun 17, 2024 at 12:56:01PM -0600, Keith Busch wrote:
>> I'm not sure I follow why these two need to be the same. I can see
>> checking for 'chunk_sectors % boundary_sectors_hw == 0', but am I
>> missing something else?

For simplicity, initially I was just asking for them to be the same.

If we relax to chunk_sectors % boundary_sectors_hw == 0, then for normal 
writing we could use a larger chunk size (than atomic boundary_sectors_hw).

I just don't know if this stuff exists which will have a larger 
chunk_size than atomic boundary_sectors_hw and whether it is worth 
trying to support them.

>>
>> The reason I ask, zone block devices redefine the "chunk_sectors" to
>> mean the zone size, and I'm pretty sure the typical zone size is much
>> larger than the any common atomic write size.
> 
> Yeah.  Then again atomic writes in the traditional sense don't really
> make sense for zoned devices anyway as the zoned devices never overwrite
> and require all data up to the write pointer to be valid.  In theory
> they could be interpreted so that you don't get a partical write failure
> if you stick to the atomic write boundaries, but that is mostly
> pointless.
> 

About NVMe, the spec says that NABSN and NOIOB may not be related to one 
another (command set spec 1.0d 5.8.2.1), but I am wondering if people 
really build HW which would have different NABSN/NABSPF and NOIOB. I 
don't know.

Thanks,
John

