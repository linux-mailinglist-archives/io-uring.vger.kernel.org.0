Return-Path: <io-uring+bounces-871-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E1187696B
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 18:16:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 990071C2095C
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 17:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23172577D;
	Fri,  8 Mar 2024 17:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ENLps3ky";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fYnE7C0U"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAA5288D7;
	Fri,  8 Mar 2024 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709918185; cv=fail; b=fKSY4RpnirXf7+8ynm5cEoYdc2rgT7/WaT9DFddn/86EAtUAdeSA1tW69dgDk/wr3fe0zc6HZkXeHjpt30S5v13w16G9mjcovU5XZ2Vb+9WQsxVUeRxkDNlk9sHf3UIcyUJQwZpQ14WSOND/wdKg+hlH3HlrZjxSxny26sgURgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709918185; c=relaxed/simple;
	bh=QB6eTbK9MVba8F0xD1j3w6pT/tRXTUISSkN9q8Mdw+4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iBY7hrgXcAHQlPNzJRA6PNmZf7d3v+E1IUdiDJrWMBvSverNhjqj3daC5sHalA8GfvdKjYJ+hN4yp/wNiUfJTMdMPFy2Bxbv/ktnF/bB2vycL+nMXIY9aX81ijJrUr2f3+P4KhTx7sBblUQR24mwZDN9ReRHagim2U+BFzwBeXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ENLps3ky; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fYnE7C0U; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 428DTMcM027341;
	Fri, 8 Mar 2024 17:15:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=HIgV9iWgeoInW7F2pyCgSecaDBCSy26jHyglAovYB8Y=;
 b=ENLps3kyaBXBwgW3m7Jq22R7gwIub95OavIHqCk7Z/oz83kbNFAPWdivLxWOSYU2i/Ga
 lFsezkRxrmuxUN77pqZ40ZR3soarIHkTDI6L6/8xeFV4eq6Uuqujv0i2aOqn6vULETth
 zc+nY0aVJZXxSQPKMhmhiGpDdANoBluIRJKkf0WSLALdeGfJV3Urx1NsYFXbD+ykZ3Cf
 ceMKUr1ElgubFl216RqyyMfSp/FREUOCpgZW4NTSoeg29NnMqgaicVxJy0muODTIuOYg
 cQVBqWgoYuaGZIEPm2v/gnPftknQWaErCROkHqcRRHcStPNnkoFlWPaBUWG5FVeqwyAF 5A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wktq2ehrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 17:15:30 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 428GWXr5015959;
	Fri, 8 Mar 2024 17:15:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wktjd48s1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 17:15:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSL2UETgahPvThwtY/OFpaDjJDzgX69vNgf5bVNvFx5Z6wyPOfuwGu2USRj9vFAsdOs0FjXwGe4k3rv58R4rbqz7mI48r4IaUy2gUNvdeWalG21l8jBR+Wyw9wgVfEWdhB4zesHFALvVa0t2M4a9NTta/sdvywu1dNngGG1Ulz2tkhycFF93lSTkZA2Qa7CRDQqt7LvjugY8DEW3Z31Lr5XCdrnU4D9cAeBtAt1zdKR9JVQe5e1gISTl/10T0a1GAxUmxk/wBorLSrzOcLHYzd6MmJlkx9HBMkh3XGTtkA4fIxb6mtUOA+T26qjSgFE4o8GTt8Wi6on200QOQYin0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIgV9iWgeoInW7F2pyCgSecaDBCSy26jHyglAovYB8Y=;
 b=S22pQQX3pN5c7XVaajr+KW7cmDxOBQJYdpZsGETh81dFuLPjuoMfG7vhndnyxjoH1s9sH6Euq5At0BmpPbPthNTgW98K+MjTwoWTzB/l7VvzrsJnxSCry1R5pto/+3ZTOufWvQjn9iuyaRQKW4L/1kOUzoPCAmDrinf7iYvUhGvC2Vyf3t6Ar8W79VRM26kmTfw0BjGzxdP+KWYHACaKyzXRb1B5DByujivH95AAYgv0a/GDyvX7IQE0+BH+TFaXVxOXBGjNRoqtTsh+Rkn5HJOeWC0zIImQZePGAElC0fNFc0Tn+VRSPV/+FyFQsv2cTZ3KY91p1ZMxbbJubQFQ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIgV9iWgeoInW7F2pyCgSecaDBCSy26jHyglAovYB8Y=;
 b=fYnE7C0USv6yiHkaqxaTtJrs52ugEea0YDjcL/9+9pVkSTsakFcnbhUcjvSdmsW9yzZ7bJ9H/k0Y0NBsHx4RnK7EZU2pMwMzkAE4A4JVprctosHwY0PhQBy+QO3bgPLltZ/pDPon4ur5h9CdPUdA9QDu2mMJmkC9x8Ep3a0Rz6s=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW6PR10MB7591.namprd10.prod.outlook.com (2603:10b6:303:249::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Fri, 8 Mar
 2024 17:15:27 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.019; Fri, 8 Mar 2024
 17:15:27 +0000
Message-ID: <8fde7b95-fed0-4cfd-a47e-455cccf1a190@oracle.com>
Date: Fri, 8 Mar 2024 17:15:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/10] fs: Initial atomic write support
To: Jens Axboe <axboe@kernel.dk>, kbusch@kernel.org, hch@lst.de,
        sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
        djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
        dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
 <20240226173612.1478858-4-john.g.garry@oracle.com>
 <1f68ab8c-e8c2-4669-a59a-65a645e568a3@kernel.dk>
 <67aa0476-e449-414c-8953-a5d3d0fe6857@oracle.com>
 <eef12540-84b6-4591-a797-6cfea7b28d48@kernel.dk>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <eef12540-84b6-4591-a797-6cfea7b28d48@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0533.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW6PR10MB7591:EE_
X-MS-Office365-Filtering-Correlation-Id: 65341a53-f80a-4ad5-bbe4-08dc3f935925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	oM1gRv958dpe8d/KESdO301vpg0sMzMDyTVBAAL1OsEKB6i48SVlRJhAZpy24IAnnroGmG95FNEvgG2LsOonvbKd0czo1nIuRGjAB73bYfwI1jCEJbv8w483t4eWeVFac/NUhkoNVkNMXHU0xBQH/505u9/73BkMiiXT/qFUE4O3nyUAqU7Jemz3a+iwogfWRQGkbYfexnCTnWUc9E3T+qSIPnScHTuK42PlDLkKNHMbbxjDFLb9jsSCYhZciEjsKLbehPiAJgvNa0l2oPjaj70awKWYnC7s7HPCEPMF+tkgW2HfGVQBAX7XBJqrFVNPfbjELoDXCOBXEiqkc+P3JWIJICRfUIL8Nmk8oFOAilkOcu+nQr4MvGT7vjoX4MSNWG8n1UJt02TiqF+YWr3juNp/1P+1zvZ7Zi9GDlo3MEtCGPMRSpT7BGoCB2cJTr7XiH1gbWjFMQwGm/gW9tBJa9wRvWBrtVydrxsSNJkWy0xLyiZjuGqiJyLaQl+n21/+q0MyrtmdOQHrgNDQVE47AkQPYcVbVNjtHmtBzRzAIZ/rfwhX2bhDXROiWxFxbJo6JcAB+6IPief7hC9Q+veCmlKi6iThq42DzRW5gowalIzvvb2gFqbv+Byl09Q/BKUpZC2948JZrQWyacCJTDvpWW9T6M3rIA1xHVgd5hFvuwtBdowjtU6kABeCrTXxSmGol/aiqvGSl52jBCF30GsPuQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TFVQVjB6L0t0a2sxYnIzTEIrYnBEYm5UV3dlMjU3Y2FPR1NBQjV3Q2tKWWtn?=
 =?utf-8?B?SGN5alRnck5JYVI1TllMa0loZjJ2ZTl0OThKMGExeHZmLzZPcFgrNkZCblkv?=
 =?utf-8?B?d2VrL1A3UDFPVVJZUk55VEJQa3VRZXFBVCthRXZsZ2pCczE3Y2lmbXJjRWd1?=
 =?utf-8?B?Y2E4S3YzdHNDdDVuQTJxVXlQaDZUeU1sZzlDWmE1ZlNTeW5BQXB3TUptWGp2?=
 =?utf-8?B?dG9kbVhGbnVXSkRCUmtHVGtTVFVIYlQyRXVFTzBxTzBzSi8rWXZ3aHNOZHhJ?=
 =?utf-8?B?RmhOalg3OVIxRWFPcytCbTNPQzBpSFliMWJsMFl2Ky9Hait2MS83RlRsOG1E?=
 =?utf-8?B?SkFlT1IyMElxaFZwRG01eVpneHdJS0t4SDhUNmdiaTgycVZUR3EyWXkrSEk1?=
 =?utf-8?B?ZmVtMWdvTW9uaklrbnhZUktPbkFaWTRPaVlSVzM5bFJoK1VWSkFmc3h1S0Ft?=
 =?utf-8?B?MDFGT1l6Y04reTZzQi9YZGthL1JQT0pvVy8yV0NFMlE2b1ZreFIyekdtNG11?=
 =?utf-8?B?YlJXMlJjSEtaSTZieHZJaXRHOXF4RDlLaTlWNjZMVTRvZzNtK1MvNU5qQU9j?=
 =?utf-8?B?SkRGKy9wNHRoWGh4L21ENHduNFJoTmh4TGFXdE1rZzI2VzFycGx6VkovQ1NU?=
 =?utf-8?B?N3lsWE9yVGVFdzZNNW80TDY5WUFBZy9wRnluMDJSb1VmdUszZmFlaFBEalNz?=
 =?utf-8?B?UXB1N0llVTlGOU1TQ3hhWFFXMzZaaDg0M2VyRWZVQlRlNXBJVjNYckZCRkh0?=
 =?utf-8?B?YktYclJnVlUwTlE0SDEzYm5CZDVmTW53M09LdkQzeDQ5SmlXcFB4T1YyZWYw?=
 =?utf-8?B?dU1laTcxQkNvRUFvQ1JzZ2dDNFdObmNUYi9IQ2FNa3dpa3owNGM0OHFqeXRJ?=
 =?utf-8?B?aDl1Mkt3RkIrRlhBZGs1OXN1T1NCVWJKT3hucnNPUEFJeEhVU1dIZGNlOUQy?=
 =?utf-8?B?b1V1MkpFTDlWaVRQTHdwV0FtdndnY1pvZGkyNnEycVpZbE1KMHl4Ym9ZRDd0?=
 =?utf-8?B?dGhhbERjdmJkYm1tQXFkVFpDNGpzMW9vM0JJa25KNWtaUUNhOGtxcndrYXUv?=
 =?utf-8?B?RFZXVGU5QmZIUHBIQkJhYXlRWDh0b1NncXAxc1BjWWw3MFJwOUpVMmtzRERL?=
 =?utf-8?B?ektHTXMza0FKL2xiQTJwaGxPMDRGODVjaS9EZzM5cUdiU0VyZ2dJelN2dHNl?=
 =?utf-8?B?MzRUR0xQd3l2Z3c3NEYzSVc5YWVjTVJDSTZERHJPWGQrcG11dVZIS2RrREFW?=
 =?utf-8?B?NGRzNHc3YWxaQVlJenloRTJTUzN4SzdZbnZUb09YR0Y4VThuVXpsdlhidWpu?=
 =?utf-8?B?T0xzL0dJNndhYnhCZXp1NEtoS3pOT3hCeER3Z0ttWDFSYmhHbnh0NHlRc2k3?=
 =?utf-8?B?MXJlZGJJQzJjRjRwSkd3RGF5QzFkcFNROGVLUGNJb0t2SnExS0dKTkhSQ1hW?=
 =?utf-8?B?cnZXYzY3YmJxSFRydVlxVGZOMWxyanUyRWEvMXJOejJoSWRGVFRMZ21odnFT?=
 =?utf-8?B?aFA1clc4ZGxRd0FlODhBV0RJSVZaMjhzNlNtamZNT0pQd0N2MW00c1Z2eVRO?=
 =?utf-8?B?ZWIrNm5LOXYxNkYrMldkQnNGdk9KeUh6WDNsTkdyUHBOd1VYMExWUmxJRXVu?=
 =?utf-8?B?QlYyblhmaW1LNkU1YUlCRjVNa0IwbTlhTjJCN0J5RG1OTnoxR2FrbmdDbmZN?=
 =?utf-8?B?Nk5pSWVpbWE0bDVVNWN3TjZxOGRBeDlUYWlrR3lueTEvc0EwT3JiVkxGVHYv?=
 =?utf-8?B?Y29LN2JUd3hYayt1M3RYMHpjRVZlMDZEKzJrWkNLeU5OTzg2VWNYTm1OR0xo?=
 =?utf-8?B?MFIwUmU5SXF0VnFHYzBYbXRJamJncXBwbnVyb2VsNDNNWHE0Z0g3YWgwNW1O?=
 =?utf-8?B?YnhCdmdxWnJJT01RTVcvUnNVTUhpbW5VRTZUYnZOdjd2QnpYaHRQOUswcmhp?=
 =?utf-8?B?U0NFQ0tBSVBGdTBwZytJcWhtTmsybkxrWjN0b2sxWGxLcG44Tm4rcHFURnd0?=
 =?utf-8?B?cy9LYXNSUTJpZnZ4ZUQ2Z2lzclFZMWx5R2JaLzIyeVlLRTNXelozRXFDaDlY?=
 =?utf-8?B?Uy80eklpWThNejhYNXFWbzc2SnNzVGswUGUyTW41cXVwN0NLZit5TG1xbDdO?=
 =?utf-8?B?VW5BTVZ5cDl0ekR6RHFlY1ltWjA0bitocjZDRFFYamRYUFpnMktXbVBhdjdr?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	oGJLbrcxkChio5G+5+QAgwTpCz3e9Br5c7IhILB8lRmxSfBeky3/YIqrbkDQqiOIpTSSlPN3IVgxBVT54j7etGaaTCk+aKayV9pOCr0V5YnaFbSb4dcIIpqPVKltGjMHV0EdM5NC5Yuumhc0toddoy8ZSjcmOgoMRjdvAUInk8Fn0SDJZDojtKii3HpXZvEZJfEDDybCCLRt1WFw4sZc6/Z5Gfetp+PoSGlNYm2JC1E3FMaTXyR8F8U9YW3uT2LP+3yw5ACeIQ8y3FByJzSnwKMzT4p3N38NwtMuyjAw5tCSaPdeJTXaYla0A92H6/LChimXjl8fxGnpMdyLxxeBO1PO2QfDdXl24u6mNXUTDO5Kue3lSCVXAxPSlwHt0uuW1Dk8V3S2XED+5DiuO9JyjbIOTHbpOJd5Z+KKqXp4pLt6BW0tub7teMoX7zVxx+UqPJQ5akfQsZyWWyuWYqW8XUCUMuF/EP452fv/3ISU00+/3cIImJqV5KIs28ULOiLnOV7VVfUYqpAAtY8U+p1b2wdGCS1kZ6VL1BwJZHEpmIJDwShyAqdltdXETsYPNUbSu2cYHCS6ZheGzongvhiRVp91w7M38StLfuC8LlqkIx0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65341a53-f80a-4ad5-bbe4-08dc3f935925
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 17:15:27.0085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExPPbV42Vsx8g8bKCB+DCJb/TthDuKJLcDjsECrdURmv8kX+w7jbVvGGREoPiMQVWnIqrD06FZC9LomWbbF6uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7591
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-08_08,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403080137
X-Proofpoint-GUID: qAkaUOvEcGE5W-AVY4TFaEcS1HFT8DcR
X-Proofpoint-ORIG-GUID: qAkaUOvEcGE5W-AVY4TFaEcS1HFT8DcR

On 08/03/2024 17:05, Jens Axboe wrote:
>> And the callers can hardcode rw_type?
> Yep, basically making the change identical to the aio one. Not sure why
> you did it differently in those two spots.

In the aio code, rw_type was readily available. For io_uring it was not, 
and I chose to derive from something locally available. But that's a bit 
awkward and is not good for performance, so I'll follow your suggestion.

Thanks,
John


