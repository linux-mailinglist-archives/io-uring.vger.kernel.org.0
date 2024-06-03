Return-Path: <io-uring+bounces-2075-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 048418D8166
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 13:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 273471C21F29
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 11:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E5F84D05;
	Mon,  3 Jun 2024 11:39:44 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B6B24A08;
	Mon,  3 Jun 2024 11:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717414784; cv=fail; b=q4wBYxHvu8cEveNHmLQQY+99En/yo3a4aDB68vGvK+LeHr92mB+UIH4C9cZs0haDXs2+NyBY9HYWpqU7i7AZUlA30GIrgfKDXv9D9oQQXfM7TX0MS6aOHJe0WMtTBqK+BpBTkOBfC+oKM1J+kGD5ztbVYDe9hRoRp1hWE21vNBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717414784; c=relaxed/simple;
	bh=qkI/jlHcT21KbZk6DDftpWJfKPh+pvWGEl1yfCwgZ+c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nS7MyLmQkBimJoAE8B9qMb54otM//LSmFF+J3ijLhRjPSkamkWeiarc4+VOg6e3ReJKyRES6YY9fUOv6W2w+0WPv4em0SJIsxFVTv9n64KICcZLBx2aqi3JcvLym00PJgLb34/CgzKwXF9luQhPuLpPY5iYxLCX8FG9B0gvW1iM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 45320nJE029424;
	Mon, 3 Jun 2024 11:39:08 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DEkoTMD07HCxSTEhz/ktl8baaYJ1XX/Rw+8RNhONUcEU=3D;_b?=
 =?UTF-8?Q?=3DXma4I2iqmCZVAWODDhP0PRNgRQPWKvZ9BOV0TA+uagYwC1qMHZciMb2NoMOv?=
 =?UTF-8?Q?vF9oij4Q_kg+C/V3/PG/rdF2ns5UYub8MLBDydVveUPaNAM6+d9VwbUvIrGQOKS?=
 =?UTF-8?Q?qQmiKJQnUe8MES_TzTPGNoj0ag22P23XchKkIB7X3ArCDt37apVWD+nxTyI9v6H?=
 =?UTF-8?Q?NrVqJ3EwJMrnhEvQMiKx_5F7B6wfKePZbJevhMBBz2egvFjIFQkeufE6XVvz9HY?=
 =?UTF-8?Q?Nc0IbTNctJemr1XIWWjSQvoCaH_gj8cZVJbQqSUwTqYVVVTFBMID92e7YpnLtLi?=
 =?UTF-8?Q?PcANezDHSrfUVQPekqeQJu/oirrnf7PJ_2Q=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv6u2mj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 11:39:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 453AocGc030912;
	Mon, 3 Jun 2024 11:39:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrmc1p9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 11:39:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVqdm0lFJQMGIq/5L82ltaJYW/KKvAeIW8As659cDcItz3CpqdihzRVnjratZ1k0pt4FupKWpRtdnYGRhNJra/XebKzloIx6HU1AhBJUtIqowylMLHJ5OIdRqeezCw2Z/g09BuQD0MSM8SczF643AeqQraOTcEJruvQ1k2uOigGmH05zjS/WveMPURQVnjGWmKy6QiyfvokEFQgptSiMJw/xsrSbKLVRonrKaamiP7PYEGFtz4DeUY2mwtJxNX7x590E/1Oygslc1iCeEqhgpEenTjQGnoFkk6yFn3IFMYx2NOCqECc7+ydLAsjL/YFU84JCvMEkDACjndREerD04g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EkoTMD07HCxSTEhz/ktl8baaYJ1XX/Rw+8RNhONUcEU=;
 b=e2BxCoDSjk/abiqVELZ4I/MO4J2CLUPdHiSRekYw4YOK0WD2s+9S9+o4hOsRNnza7GSbbCq5gRnSmOKseY9wtNrUxyqBh7iMnqwuI1muvACU5oKRW4Uo/doUWG0GAyG7VO6F3DVK+5ON7qYVk+YK1VCtZju5p97p2rhCaWJyaIS0Y9B95FxP2y8AxICFaDhQGKeJ1Q1yShoP6JFmdkXS4QkM+EPgqRkVlHofniyB1EVdjoOf77HhNztmi6BWoEoIKiTUDewKQxCK5Vdg8Iri8eT+DLTBtr8V31OzxY6hrYpPyHyf7j7t/kWWoaL2LwjulFD7Y3Z7fkyTyl1F0+3ZOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkoTMD07HCxSTEhz/ktl8baaYJ1XX/Rw+8RNhONUcEU=;
 b=OU47BqMy/XESL0yk3e2wFRpG2NVVKbTnybNmoWjcfuOePLpHUjA21bWTfUsOvqg2A7hHEjO/3PUbVXtSS9HSD0ShADS8fra9AqLClecxdghXFM0uej/c2OGr4R4Rjwfk+Bl19fRwwj69dDPwkM1zGtTNIxt9MA29R6PC+mvF1Ao=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7642.namprd10.prod.outlook.com (2603:10b6:208:481::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Mon, 3 Jun
 2024 11:39:04 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Mon, 3 Jun 2024
 11:39:04 +0000
Message-ID: <a84ad9de-a274-4bdf-837a-03c38a32288a@oracle.com>
Date: Mon, 3 Jun 2024 12:38:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] block: Add core atomic write support
To: Hannes Reinecke <hare@suse.de>, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
 <20240602140912.970947-5-john.g.garry@oracle.com>
 <749f9615-2fd2-49a3-9c9e-c725cb027ad3@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <749f9615-2fd2-49a3-9c9e-c725cb027ad3@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0032.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7642:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e3e9974-8871-459a-2582-08dc83c1c518
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|1800799015|7416005|376005|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?SEoycTBjUTE5QUZnUXhZdXBRZGNkbFNhWUJQOTVuSTZkWWRoRXRNbGhpT0F6?=
 =?utf-8?B?cGpIZE9uNmN2dTJTWUVjRTFqaGpzc0hZRVVLWFBwaWZvbkV2STVhUy9Ecm5Y?=
 =?utf-8?B?bUtway9VY2Q0cnozQjVENTNZVExFUEorOFRPd0Q2ZTR5Z29xbGhCOGtMdlBv?=
 =?utf-8?B?WENuZ2kvckU2bkx6SXZDMUptOXhEaG54TXNoejJuNXZwcXdJUU9wMm5mVTdD?=
 =?utf-8?B?YkNFZW1qK1A2N2U5U3dNUmtXSEpXT2dMSWRzWFg0Y09KV3IzeUxNbnR4WWg2?=
 =?utf-8?B?aVFFMGRiSlpWaTk2VHdxS2paVFJxYXRySXFVSEdvU2IrbVRiOW95eXdZaUxK?=
 =?utf-8?B?RHpaKzBNdEJwKzE4cVpaeEJkaEZqbnVHcU1YK3NzNGVhS2lvbWZsRExReE9G?=
 =?utf-8?B?Z0MzTlZuaHd6Q0t4ZGVXUURvcnliVDhkME5lOWFBTTdKRVhrQktqdnhLckU0?=
 =?utf-8?B?QXBnVGZpWjBFK0VaMFljZkJCdGtYVXEzd0NpczNHK1RISGEvdU5janBSWENJ?=
 =?utf-8?B?eHNtWGNYWTFwWTJ0TjcrQ2VCMUNxbU5MZDFVaFJqZm5DeGg4VXNHMkord3dQ?=
 =?utf-8?B?T21wTkJNZ21LRFg1YWppeGRzbG03UTFXNXRtQXNjN0dUaUNLWkJYSEprYlBk?=
 =?utf-8?B?MFlYT3RuSW4xaERKYzJsZTBwM0tWQzIxcnpOTkhJUURVbUhFRmFJMDBDa0li?=
 =?utf-8?B?RzkvODgwUVNOSkxRVnkxUVRLZmZ2OW9xUTlHQnhUNlhNRnVGVzVVaTFlNitr?=
 =?utf-8?B?MlZVc3lBNmZkaGJlMCsxOTFaY2lXV2FnbkJqRStWR1M0K280bmxwNk5zV1Zt?=
 =?utf-8?B?dFhIL0MxUVpiYUJ5RXFHZkNUbXJzeklqWFJpN2tKb01DMVBYMUJ0N0xJQTY0?=
 =?utf-8?B?RGE4VDQwdEsyYXlCOXVWTmdSMUVIZFV1d09VZGVIZDM4VFdOMkN0QStEeGlH?=
 =?utf-8?B?QjZGZFpobldGYkhNbHhsblN0TjNrSUZ2dUZNRDVrYjhpUFZHaVFJanMzNUxH?=
 =?utf-8?B?Mi9aRWM1K3d3OG5zdlBDUU96R0xmRC80R055UStsUmxVYThXNlhUOUhDdGMx?=
 =?utf-8?B?NFBxN0NNQjdDbDI5Q2I4R1hNays3OTkvc21xeGFCeWIrTEI3UjFTbWxrYUVH?=
 =?utf-8?B?cjVwT25wVktYNjE4K0p2dFZpY1BkZEVYdVpYWVMxTHdORzZZem80L1hMNUlu?=
 =?utf-8?B?V0wvK0luUnVQOVBVblRjTEZqS1NDdTdHOVQ3NGFZRmlLWUJlMjdhNEQ2aURh?=
 =?utf-8?B?VDZPZno4V2tFREJJL2hxT2pDV3dXMUw5eTdXQTF2aDh0eXB5ZXJtd0JKOStk?=
 =?utf-8?B?WFpUcXM3ZmJxWDNWSEdTVWc4OFpSY3F3VS9HMnFmNkNZSlI4dGFXS3ZvWWdP?=
 =?utf-8?B?NUVHRXhNSFZ4OWdjSzUzUmxaR3NjVi9oY2hUMGw1OWhlKzlTeExLSzltV3hR?=
 =?utf-8?B?SVB6NWwrSnA5bnRoZVdhYnlKZGY5NmJaSXlwSERWMUVrOE5Ka0tjZ1prbzkr?=
 =?utf-8?B?UktzTEhhbGdBYWRIcmxCOHJGYVNDdEtVaExaY0lQRWdDRzNmT2ZSWGliR0Fo?=
 =?utf-8?B?OU9xMnFQYWJRaU5tWWpvMVNxdnI4VlVWTktIMnNyTFlXbC8wZC9oZ1pVU0VZ?=
 =?utf-8?B?YnltTFhwZ29mM3V0WGc4YXEvZjRQUWZQOU5Ydk1VYVZYa2VVUlJ4VnBjSW9k?=
 =?utf-8?B?M3ZqNG1HamZDY05Td3dUV25ubW1kaEMvaTh5akhuSk5BVkdLY01wZTZyd2Ew?=
 =?utf-8?Q?dnc1KQvQPLKi2C+oRNwPyeheUFAwUuJYnN6icl5?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?d0puUWNDTUJYYnByUTl4VG1ZdTVtL2Q3N05VTnpKcUgyN1c3MGM0eXBRbVBl?=
 =?utf-8?B?NGltcTlBeDdVRmFWSWJESytPaG9sMkZsQnlJTDMrS1JSUVFrK0VqaUU4RXdI?=
 =?utf-8?B?czJSM2lib3E4OVU5UVVkV0l5SGxWUGo1VHlRdTFkWlpVbzBzTmNRL1F4T2hq?=
 =?utf-8?B?MXVEbXlCWUIwNXJJZWRVVDFxSWhtQ1FKTnplb3JhaFA4WVRkdHNXVzFYa0x2?=
 =?utf-8?B?R3lGVm9CNFRBclhqZ0hIQ0xQdjQ5SjlLTGVCa2FOVVVhTk1CUVdkdStUWEx1?=
 =?utf-8?B?cFF2SkVhZTVxNHBVbnJqajd3RlM0ZU1pT3VQYTIwbUFWYVRqL0I4amI1TUFt?=
 =?utf-8?B?MHlQaTNKRU8yRFBlSmMyS0FIK3ZPdFRPdkhZVWFrRWI4SHF2dmZkcFZNUWwz?=
 =?utf-8?B?Q1pndTVPMHpINGZQempJVGkxb3l0M0VvNVpDcllkbTBEU2xMQkVUclg1b3Z1?=
 =?utf-8?B?YTBvUk1JUUYxeHhIVlB2dEEwWk4rckxrbEhwYk5nL0ZYN3M1YTVZUEhlT1ZQ?=
 =?utf-8?B?VzRXV3ZJYzlBNFhmdEIySXNsanQwYXhEOGhoVEpkWFVYWTBPS21sRmtwb052?=
 =?utf-8?B?dHkrcUZTRVhZM1RpTXE3ZVg0dGhDcVVCc1laaWVVbXNGNnE4VEVFTXZoaExp?=
 =?utf-8?B?QUgvOWZzKzhEeTU4a1VPbnRNME04a3lsT2g1bkxQNFBFRDk3bzFhS0hSSTZP?=
 =?utf-8?B?cXdkVlY4TjlpbnNIblhSNkhmREc2WDNjZ09zSzZIMzBNRlEwaE1GbjlvT1ZK?=
 =?utf-8?B?dzltSTVNRi9qYlBqdmFpeUR5SGdEVXYvOWwxZG95S1RFSXpEQzhpY1VPSUdQ?=
 =?utf-8?B?WUpxWG5iTUhTTG5RQ0orcVkrKytrdHhhZU9NS1dvMC80SXczNG1JbUpKUUNU?=
 =?utf-8?B?Q0FhWDlSVE1oUGtIdEIyVkx5Z0ovZ21oWWxKb0FlSys5OHhCcEluNXBYSTFG?=
 =?utf-8?B?b0ZQOHRkK0llQ3V3Y1JQcmozYVRnZDNzZkdKL2QxWEgvOEVmendHRUhkRzJ3?=
 =?utf-8?B?MG95Mnp5SDNJNDhmZ2ZvYXZMelo5dlNsSHN1ektMSFA3M0ZUUGh5VSt5eld1?=
 =?utf-8?B?M3VBL0pETHlWQVRaQnFPbS96b3dDeVR0QXl6aFhJa3Q1SFp3bmtFL2VuVFpD?=
 =?utf-8?B?OFBiVkdyQktYWnE5bVdBUnBaVEp6dzdjWUkvMzJiclRzc2RwcEhBVDlwTTF4?=
 =?utf-8?B?c1FUTDluK2doR3dlRytldmNTWHFLK3kvK2hHaFdpRVdEblhweHBFSVJ3VUM3?=
 =?utf-8?B?cHB3Q2dHUjlmQ0FOWUFRaUZ2d3FwZDNpRnZVQVpLbUprOVRkdG9LOTJmdmhK?=
 =?utf-8?B?ajdudFR3NGZNQVRSREdqNDIwbU9RMzlKS1F2cVdWUUtRcTRocWVWU0lwemtR?=
 =?utf-8?B?Q3Z6WGFiZ1BqMWdQazgxSG5HTDdFdFN4TmdpY0NldXdnWEFBKzZZc1I0TTha?=
 =?utf-8?B?NTJFWE1SVWpZK0pFTUppL3l2bGp2US9JSVF3R1V6cUpFb2tNLzdSSlFHTmtS?=
 =?utf-8?B?NVJCOHlJa2FPQkplcFl3L1JWcDFPdWltQzBHYUFHOFlmVmEzbk0rR28vSFY2?=
 =?utf-8?B?M1p1TVlpTW9hc1FScldhQlNyZmFzdFdpOWU0ZXRmS21Wc25aRVphYWhaSFZM?=
 =?utf-8?B?VUgvKzd3aWJaN0VyR2M4Q01RVlNnSi9IVXdQbVE3bTVtMEdOZ1FvNjBIdDM1?=
 =?utf-8?B?cDlaR2x1dFBWdzhEWWNTb1NPVlZyOS84ME9ndnp4ZUovRE5YUjBSSmxtVDBX?=
 =?utf-8?B?cFNhaDRzVm83Qngwc1NlWVg0Rll1djlBeDVSQ2Z1ejFJY2p1YjB2NWxJRzh1?=
 =?utf-8?B?cUphWEZTQzJmNXgwZkZjVCs0SXpCQ3B6Wi9ETTBwc2VGQkk3NFcwdkZva0Zj?=
 =?utf-8?B?ZlpaNFVHOHp3ejJrci9wTW1ZMWZuNDRmQzNtakZoMTZhOXg0UHlSYXV5UlNK?=
 =?utf-8?B?U0svOVpMRjJTRXRFUWh0WmUvN25GN2FZQlkwamdxdlc2d0pDSGhOOUd6dVZz?=
 =?utf-8?B?UHdWMmtpTnFuNlIzREZIZnA0RDRjbk1LY3psWktEVGVRZER0SVMvMXhUK0JJ?=
 =?utf-8?B?VFRIUWtaV0dHelNJdkVmTERkenhNYUpHQXY1b1l2dzMyTU9zUWVEM2RCQ3FP?=
 =?utf-8?Q?2TSAgQjdlFhtQQ7JQIxUBVHDm?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	4s+Vg6Lz7BmOk6pEfUzIDdkQ3GQlSL3d8spJMnISFbIeXvn1OhMnwt9oOnhQoqwDU/JGsH5p8FpgByjASlXyAEy1w9k2AUbxFai4YrmL59UKmQ+vfLshvk7eC44nLQ5AunnDjtT0s+GkmOWMpOzwKZVR+HRWHWZq/YhJRmZ8DhhesutjrinYsQhdUwM1RQx8X8uF+xGrQlESsDxcPVgg9iQvuzn797HhZWBPIHfFFL5reMqPGyQBe90mcbUqRgDFmWlzdfjnUef1qsMcbhstwoWsFDcvOK2saYIeaom+8D4SBKIi0r6VHOUWlSF6ZtpPXM06BFSBhWH1zv8TMnmKLB9eGUkOD6fhhHcYvthgUf40ZJCOWM26kxfITDRaVYLHt1OAFGNwRS4h/n7zQHOgboubox+9VTkWIj9Q8Es8IHlMYe1bWklFFe3PAYXKSr0W2g6TQaFiEVD09BNtihE3083LRBfl0CHecF/SpPvYDO0FP3hzV8Po7Dec5ZBcx8qqlzUuGkkYCpLUdyACh1OTXBn7w5QP6rsxT83a/oRfBkWwiA/bbj1ru/Sx06AWOyxDJLf2KsGJ1kUsNV744mX6a9VYdgjPw1xG4snvlPXAXXc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3e9974-8871-459a-2582-08dc83c1c518
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 11:39:04.1191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBFW7QjPhJ1yu4myIomSnUhxbRrRU/+b9sGPDxnaCL+K1us2PmzYF+FPEwJlYDRgHMJAxWDvZy/qL2LJObGNjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7642
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406030097
X-Proofpoint-ORIG-GUID: nLCYjf7xPy-9am-JRuGFDhLmW8vA8vP4
X-Proofpoint-GUID: nLCYjf7xPy-9am-JRuGFDhLmW8vA8vP4

On 03/06/2024 10:26, Hannes Reinecke wrote:
>>
>> +static bool rq_straddles_atomic_write_boundary(struct request *rq,
>> +                    unsigned int front_adjust,
>> +                    unsigned int back_adjust)
>> +{
>> +    unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
>> +    u64 mask, start_rq_pos, end_rq_pos;
>> +
>> +    if (!boundary)
>> +        return false;
>> +
>> +    start_rq_pos = blk_rq_pos(rq) << SECTOR_SHIFT;
>> +    end_rq_pos = start_rq_pos + blk_rq_bytes(rq) - 1;
>> +
>> +    start_rq_pos -= front_adjust;
>> +    end_rq_pos += back_adjust;
>> +
>> +    mask = ~(boundary - 1);
>> +
>> +    /* Top bits are different, so crossed a boundary */
>> +    if ((start_rq_pos & mask) != (end_rq_pos & mask))
>> +        return true;
>> +
>> +    return false;
>> +}
> 
> But isn't that precisely what 'chunk_sectors' is doing?
> IE ensuring that requests never cross that boundary?
> 

> Q1: Shouldn't we rather use/modify/adapt chunk_sectors for this thing?

So you are saying that we can re-use blk_chunk_sectors_left() to 
determine whether merging a bio/req would cross the boundary, right?

It seems ok in principle - we would just need to ensure that it is 
watertight.

> Q2: If we don't, shouldn't we align the atomic write boundary to the 
> chunk_sectors setting to ensure both match up?

Yeah, right. But we can only handle what HW tells.

The atomic write boundary is only relevant to NVMe. NVMe NOIOB - which 
we use to set chunk_sectors - is an IO optimization hint, AFAIK. However 
the atomic write boundary is a hard limit. So if NOIOB is not aligned 
with the atomic write boundary - which seems unlikely - then the atomic 
write boundary takes priority.

Thanks,
John

