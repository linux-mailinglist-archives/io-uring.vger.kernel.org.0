Return-Path: <io-uring+bounces-1519-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E6E8A290F
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 10:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90B071F20641
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 08:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C9D502AA;
	Fri, 12 Apr 2024 08:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xr2RAHRm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kh3qUrJS"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9461B977;
	Fri, 12 Apr 2024 08:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909810; cv=fail; b=nz6AQLhWYYbkMQBcIoibHwaa/0zU7qpgUaHOynxV+T63m0/6K9ur51QORE7fDHnMxBZzswt4LfJ0+TKJ+8e07+nYT/+BdrPmsjNGXjgFA+dONceEcT3VaC/SyUtnsaZvYNgHfYX4GJX6mg+UElMYSXIKmQri3mF8i+lquah5d3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909810; c=relaxed/simple;
	bh=Rc5Quu1vq9L+RAlhaA4uEGuh62+Hc7Nt5bjeAoHXvP4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NlpsnL1ZUHcAZqMx1xf+wWvc39A/YsyEAhXer4MLbZPH82P0vgjkGGhokqO8EUNRPmDVPwiUZ5/RBUtnkR3v2d5XTf/ErfheqwvU5hfsa1x7RqU7JH2fcF7bJyeB5EPD3PWE2bZm7lPAY+aQMayVa8DCo773PmGMXog5nk1J9tM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xr2RAHRm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kh3qUrJS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43C6nc0C007034;
	Fri, 12 Apr 2024 08:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=HEemCtoiLR+50PffjGMIhpGEkBqGYo98UQP8FHUxmUQ=;
 b=Xr2RAHRmzr5V6MKamblP72ujyFwYncTVXQDIPatPlXkUYzV/ngcJPvfjZ3CT52gwpwOU
 uojhtGU4EWoPi+yEnkQtRJa3vDe6Al4JVcJkSJSsYAnO/v/7ZAu3yqUFDHF/RdZ5MZ48
 LVbJguNmjGm1pA5ELMtTzjJgR4xiZf90AQRN8sbyWRaMKOUzIj1By+wf2OI9DKfFPodw
 e1Cndp60EUYGbD0ZEcLiSdHN3Gg6jcSc+jEiFkAf1vRu0YRkasmrH/eRq+FNUYNm2B7R
 5qyqBluaImE3alm0GcAboqrn0kA3KkMt5Eo6ivLaqKQvK9Hb3uiOYBheKStHQur0EbHD Kg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xax0uuaf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 08:16:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43C7IAqw007848;
	Fri, 12 Apr 2024 08:16:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xavuanpay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 08:16:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gzxw/cJfCN38qDhbvvHyCd5+jjspD/wEuVW4y2MhLDqyHV8HrOPW7pbxsP53ql42ewyBIyxyjp/RK019mg0WFKGed/1m1L7ymzCLZOOpAIyVV6bpJ3HEXP92LMUj/xOFL6fOVOtDme7Oxmw0DnN2AHdW6sTEknt8OUslXZk1iY+Y3ASRJuJcM3yTdsPjGqEDXsuUrm3s83IBEpgJy3w9AxidteMQjGC67EHXkGmnmzdjraVBw0YmKUumx3LrZ20O20efnz9dDcqY5Do5SHB2xB7ise31LcX5Y+K/OiAhuDR1ripu4ZHc0T71kajVKQJHRJG2sXAC8JLIYj+9Mm+cpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEemCtoiLR+50PffjGMIhpGEkBqGYo98UQP8FHUxmUQ=;
 b=V/M8A3EWDzHR/pl4BsVoUHgoU2/QxKRtt5pvPqJm1nU8yLLUCprFB8HtKh90j9jkUvn4goHJzyGZtE1nSfI2z3wcaAuZtocazs4ayf/U9UEDEg99swxgPLsT3BhF5Yh1vmtqE9r6NJm0Mv64aAn0NsIxn4wx3ZwiaDEVg4jCM3GGmdvw7mWJedOyGPGzKCbCdwUXQ+lRHLhTeV8Sqni8HxEhHkHPm/2/h0yIq54A1sq2/X2o5GaQ35yehxuw2a3lOZr/UK2+iErRxf5oulRfaGYddUtVpQ8jvYV6EkjmIvSbNNlh181Bl7DjyUgf5ggdG+Qv/vU4BmzTNWNpyfBz2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEemCtoiLR+50PffjGMIhpGEkBqGYo98UQP8FHUxmUQ=;
 b=kh3qUrJSoE7wrT2YWgUtr3rghyK8SJgRCGvfV90sj4wLH6L5dP88CP7MV74WT9ip0m9rEF9OUylFVKO73EUOfyOOl55zq9IoJFGLtHPX7aS/4wax3+qa2DUA3hulSs2hXTlZcjVu+KdSBCjY5I44i7qrruWy/PsAcS+WdvfxCKE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB7555.namprd10.prod.outlook.com (2603:10b6:806:378::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.55; Fri, 12 Apr
 2024 08:16:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Fri, 12 Apr 2024
 08:16:03 +0000
Message-ID: <6d8e98bb-24d1-49be-8965-b6afa97dfdaa@oracle.com>
Date: Fri, 12 Apr 2024 09:15:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] block atomic writes
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
        Pankaj Raghav
 <p.raghav@samsung.com>,
        Daniel Gomez <da.gomez@samsung.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier.gonz@samsung.com>,
        axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
 <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
 <f3c1d321-0dfc-466f-9f6a-fe2f0513d944@oracle.com>
 <ZhQud1NbO4aMt0MH@bombadil.infradead.org>
 <b0789a97-7dcf-48aa-9980-8525942dabfa@oracle.com>
 <Zhg0_Pvlh9zy4zzG@bombadil.infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Zhg0_Pvlh9zy4zzG@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0012.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: 07f1ecfb-0229-4294-0cbf-08dc5ac8cb7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	dG7KhSz3u7wczz9YsYa1tNlfFgNqpBaa14sBXBM7DkXHS8+k3E7A5xEEBArq4imm4bL3tXoRZRrl7azGySVarP5quUfcENV6jhTV3eDGidw6/QA8O/k1QoGxJcti3nOvnI1okm46k+VF4UAaGgr/dd/fwbIbhZCYg4HifEYEfzG9TL44OZe3MZO5wG3QzjMT+ex6ii0Qu//qNuxfXOWBF4IMh5ml1gtvajIIqqgYLFLV0VDHIDxohjSrKhbk+phdAHFTwNXKzOngM+E5bhoxqxmNaACDmX6exOShag06Sl9oomYzVzpuQnltPyNRJ9Dnf6xk/RsunQf25nFWYJxQyJxi4aDHEmsK7GvD1IbtMy19Heq1hK7HlTTjwka8GWfhj/XHOCfeSlo8W98+fu0NbwWjxvU4y1tfl95UMDkBID/AjsU3kpZYuvKbL+2AuSF1Cc9ZgMEWHoC9kbFXZKxd/E034fL6RqIylLMDqhmRoHFLoz6z8+sqsk7o9je572khqVeqJr1sr9c+K1eYcHmJgXZ9sPmnyDB0ztSNR96yqVTwzdKCIYcz3E5vwF8kRX+i5viLfjuqmiLWCCItYt9eFYm1FGax28HFl2kpvPHomfIZ0ia8a6gFGH9akkTd81tnLF0m0dfFWHOHfa9FEZ5A/i2PrqiH+f/KsWAlwvthm8k=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RDdPai9SNFNYbzVhenBoenY3NFIybEkxZzIvb3RicWtlcFJ4WE02aFFPNy9G?=
 =?utf-8?B?YjZRSWRDY2FIOWFjWUsvU0dlNk5lcjFRTVBKT0o3VWNVc281WVd2bk4ycVVt?=
 =?utf-8?B?MHlHU0hsY3VQNldmTW96L3RGRnJhREFXaFdRYklGaXpuRzRxdlFTTjF5TUlW?=
 =?utf-8?B?TCsrNkpsOUlXaHBpSzJaN3crSksyRzV3VGQxR3dSYWdRSW5EelFXSkFQdDh3?=
 =?utf-8?B?R0tSV3BhZTRzbmMreXlWNVpYdnJqQ3NDd3FWM3lXcndteDd0Y0ZscHFYMmZU?=
 =?utf-8?B?aHVscFJ0ZTIvMzROUzRZUzFnOWV6bHFwbGVIdDB1UHY5eGlGcEFzWGVhQ2dQ?=
 =?utf-8?B?RmVMNlBpQnU5MDJDWllERHlsdzlVM3FNdGRzeHVHakR6TTdGSG5raVpFZXJZ?=
 =?utf-8?B?YVlxbmFnT24veEJZYTdSdk9rVlJkcnZhaXdmMUlseTZSNjhZd1FHUVZkcXF1?=
 =?utf-8?B?SnIzVVBHVU9DNXZKbG5DZzFZdVVjKzREMEVsekw4SG1ybEtlbnVIKzN6UHE4?=
 =?utf-8?B?OGVMOEx0QkxNV01NRCtybWJCNmJxeXFOYWtTRm5nODdBbWRXSW00MkdnWmtz?=
 =?utf-8?B?QmFnMVoxUVU2OGtPWnoxSUNvMjFibFNFMWYvdEVDTFlaUmhSa2ZlaTg2ZjVh?=
 =?utf-8?B?Z1RvWCtXTFp4YTJvaWFRcXB4RFFlWTIyQ2lXYjVOeWlDQ285eDZHU1NkTW9U?=
 =?utf-8?B?aFRjUTRQN2pDbC9UdVdNS2VMVDdBQ3VTRFYvYnVGbTVxOFAxTCtmZ0dCTzkx?=
 =?utf-8?B?SEdKdkl3d3RCaGJyTVhHTmlTYWlLK203SHJGVnp6Z3dtTU5oaSt2QWJaSWls?=
 =?utf-8?B?OUo1eDhuYlY3akRleU5uMkRUbzl1WFdxam9kSmQxY1phS0lGUDAxeGpIZGdF?=
 =?utf-8?B?UVUvcFNlQjFNTmV0QlgvNG9iTEg3VHNHQndCM2NyMW9mMXRqT2xMTjExeGZ3?=
 =?utf-8?B?UFF4OEJUU2MvWEgvMFNENUVqLzhXbWJ1QnZ1SjJhWG4reStnUW1BUFErS0xk?=
 =?utf-8?B?YUVjSGZNUDFsQlp6T1BxanVXVnlQaEhLbXI0RHFMWXdrWUJ4TnhRTWtkSjBN?=
 =?utf-8?B?N0ZlWjJDQzNFei9hQnQxbEFVcHljL3orOTdLZWpoYTdjTlpzaTZJSWhtVWV0?=
 =?utf-8?B?VUhmVVVOVmhhaEJ0NnEwOWs2R3R2R3FYZ1FCODQ1cU1jRzM3OG9lOTFtd1VX?=
 =?utf-8?B?RWovaFlHMDRlTm1oY2k3ZmdzZ0RpeHNSOGVYTElncTFqNlZoaTlDbjU3YVFQ?=
 =?utf-8?B?UlhkUFFSakdlSnNHUnoxZmFvM05HWGZaMm4yVThOWmtSTW1WZFJEeGRWMUZK?=
 =?utf-8?B?eVdqcUgxdXpqdjUwRkcrdVhRZlozcERPMjRyOHMrVFNab3YvUjFna3N0R1Zk?=
 =?utf-8?B?R2lnKzNWa0xCZi9QeXk0NVMwUlliWXpJSU1wbDBCUHVlOWNaa2p0ZlJ6YmNs?=
 =?utf-8?B?Sm1QcTRnUmlXRXdPcHU1QVoyQVVuWkJnYklQUzIxa05MVVRjTWlRMnB4QXNq?=
 =?utf-8?B?QWgxcGMwMDlCeVBwOW9SbWFrc3hjU2N4NzZSYzFUeVVZTjQrZXliTmtRTkR3?=
 =?utf-8?B?dFFVOXRTaThjTGpCN0RheGRTTFJYWEVuVm9MQ2lMeDRZN0ZucXRFK0NCQURI?=
 =?utf-8?B?bUNlcEVPRjFScFh2Y3YzdjNwYk9KRXFaak5ab1huZkFzYUZRaWVZVFpkQlhR?=
 =?utf-8?B?eWZBY1RpNjRLSmNWWFJPSkpRUHhMV3hpQXpzSGt2eDNXTFFsUS9HS2NQbCs1?=
 =?utf-8?B?YkovU2ZNZWd5L1dtTGhSWmR1aStsZENtNUdlbDQrVkFWUS9IV01VaXU2OGF0?=
 =?utf-8?B?Q2Z5MFpUSWJlT2p3SzczWEdwYWFnYkpRczhkb1hyUHBUT3UyZFY3UGdDRVNZ?=
 =?utf-8?B?YW9IVlovOC95U2ViV0lWQlJ5RDJJbFRMWVViS0dPcG92c0VhM0RMM2dIU0tS?=
 =?utf-8?B?MFMwTUNGVDAwWDF4U1pETjA5OEI5c2drQzhVZ3lJeGp5UDR1dVJ0OUhveE81?=
 =?utf-8?B?SXdodFVHY1ZjczJNSDFERFB3RU80Zi9obWd4eFdlSjMwMEJZQzFhNnBpNWNk?=
 =?utf-8?B?YXhobzgrMVVldlczN0l5bkZMdnNrSS9nMncvRUlIa3RtSDhoT2Ficms4dXZp?=
 =?utf-8?Q?oQ1PLceR8ehtkPbWNuhiR9JmM?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3WlG+l/We/t0HMVMeQYO+SrQaeymf2DI1ej6+6jlirtxMwmjjorA81SaHyePWFlcs0P/OWavkv63tLzBJRt0ZemgDnKsKiLHAQXIhG89toHij65LnEJ75gFhkHqWNk3dctvYn4+S2w5F5Fl6pl1//OMqnoCdxDts+EPy/k2gmhpsoNIpGq5tJRcLw7S8iKtlY0ilPeJl6+g64dIAZIH4EDIvibwC6cXGmBW+vF6Z6P966uS7InNq9r7WSLPHifx3MybGy7kaXs/gik/XK+ct+Ir1qXpkAIhZEGyA2DeneCtdqoC5LizUeHg2EFjlwDITNZsPNwTbK0uU9b/3QSycXgBnt3AMfML5BZIP8megwxLG1zJU3sGGwa8OVcA0lBA2m2ZbubY3jYboTXtD05Ycbj9iMLo0T29pBVUHvokD7iPk0P68+sp4Qrg4WI2mG0AZEb1SAI3UL80hcWBuTZro1jfdI8ilZeifPqB+pFv0VXhGsZ/NMAEloPvcblLzz/kmy5tVhq4sL8qVJdfRr6IdH1OquP6LQqPJWl1NDl6DkBzJk4i2BuJGpq3JuPys+hiQsJ/1x1meFrF0vWQa2E3Mt/bpwYaOdaxuGzNgDjbbaUs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07f1ecfb-0229-4294-0cbf-08dc5ac8cb7e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2024 08:16:03.6181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6S1h54wcT5aHYDJFiAM5zO7kGDGipcw94Mgzha205G9GGS4YN8vlm8bpLuG5Kiv7TZm66nAQ1B+wPiI78f1iUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-12_04,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404120058
X-Proofpoint-GUID: NNPnLAGDX3RvV8GaIRSRFyv6dB95B2E1
X-Proofpoint-ORIG-GUID: NNPnLAGDX3RvV8GaIRSRFyv6dB95B2E1

On 11/04/2024 20:07, Luis Chamberlain wrote:
>> So if you
>> have a 4K PBS and 512B LBS, then WRITE_ATOMIC_16 would be required to write
>> 16KB atomically.
> Ugh. Why does SCSI requires a special command for this?

The actual question from others is why does NVMe not have a dedicated 
command for this, like:
https://lore.kernel.org/linux-nvme/20240129062035.GB19796@lst.de/

It's a data integrity feature, and we want to know if it works properly.

> 
> Now we know what would be needed to bump the physical block size, it is
> certainly a different feature, however I think it would be good to
> evaluate that world too. For NVMe we don't have such special write
> requirements.
> 
> I put together this kludge with the last patches series of LBS + the
> bdev cache aops stuff (which as I said before needs an alternative
> solution) and just the scsi atomics topology + physical block size
> change to easily experiment to see what would break:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=20240408-lbs-scsi-kludge
> 
> Using a larger sector size works but it does not use the special scsi
> atomic write.

If you are using scsi_debug driver, then you can just pass the desired 
physblk_exp and sector_size args - they both default to 512B. Then you 
don't need bother with sd.c atomic stuff, which I think is what you want.

> 
>>>> To me, O_ATOMIC would be required for buffered atomic writes IO, as we want
>>>> a fixed-sized IO, so that would mean no mixing of atomic and non-atomic IO.
>>> Would using the same min and max order for the inode work instead?
>> Maybe, I would need to check further.
> I'd be happy to help review too.

Yeah, I'm starting to think that min and max inode would make life 
easier, as we don't need to deal with the scenario of an atomic write to 
a folio > atomic write size.

Thanks,
John


