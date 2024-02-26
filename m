Return-Path: <io-uring+bounces-722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A322866EEF
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 10:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAB501F2724C
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 09:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F119922EFB;
	Mon, 26 Feb 2024 09:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WF80fbkI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KghH6C3y"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3A27BAE0;
	Mon, 26 Feb 2024 09:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708938479; cv=fail; b=gqYxUOEeLbaU90hK2VEonOdLNibtc4LqcEI3jRDwZjNJi88ahtlYGhc4LHZcWkgQfOAFIqdDjidghonp/hOIXh5KY1HuuNSZgI++CdIfCrcKfZW64a43Qm5zmfQ8IPlT6Pwfr0aQssre/728VLcenvrJlPhYRxS0Bmt+d/wnOD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708938479; c=relaxed/simple;
	bh=wPfwLipZszBEcw2tAltBXl2pQPoL3is5Dbmt9JBx5DI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eX0CVPh8w5xvDLIbNY6qfYQKleqMqcpq3/fqgf6JzUGK9QzUQexIZXXG0fhfj3sYKtArkWb2z8D9F/Kcexv2pVGKKXllqUC0nIJW0qTuzud+5kmGVgAr7+A9acBbHokZExpvW/yh+Y3B90zD827KkZnNH8ykfl/s3x1YA7OnGwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WF80fbkI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KghH6C3y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41PKcJaa027917;
	Mon, 26 Feb 2024 09:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=HzXNsvMaujUDZTUlDiNaRt5FmKtnLzTQ27MNHsBmg/A=;
 b=WF80fbkIFvDIvDgrouETv1MPzB9V6OsQAJd3fXSiH7KxPQg14Pr5tNX/Wosaqi/lQpm1
 gdWES1CRqKKU0Ph4na+8UkUXKawG1ua/IznCkrV8uOk77rPg34mCyaHSzOaaz8HPIPxb
 JD757MdALdOdgishXpOPghlFH5TV6ZeU1PHuAVvGaREA7XevU+bmWpxXd4xJ0eqPoZrB
 Ph6WWE6ArzwBJML1aLfBFIfTfisGRgfesIz1pP0IFfC2LRV8FRb8n0vRdKyEwXIgdxdT
 5ft2k/DmDec77LALu1qMZh9yDulS4jKkUUEsUgmcTI0BSTjvXetbQi2z+s6enFEVe2b4 KA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf7ccc0dr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 09:07:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q7bOnp040677;
	Mon, 26 Feb 2024 09:07:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w5c511-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 09:07:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHYy+HPQb2m1ErtuxntQvtDshShqArEq9bPlfjZgis4joI53Mq6uDvsf4Mxz6Ob+j/vrdd0E+2yp5etcFBuopzfwFys1FD6sNpd1bOVTlswY8XZU4GaQnwZsYcNzDVOHE7RjVfzau0nH6/oxt0NO9jlu5gi2K3qp2JUWHLDI1E+lh/1D1BhUEl0nCh/ZLU2MwfjuTXZcM/5PIGDwFBVnB8odRX3tMjxAraVCRctG3lOfyZn6exDLm8HNjfmyWcY2xI3MFRMEbCggdeGWjeXt068KKEBzanic0wD5PcE0uuwhKwkfLFdYstAuN76gFHUh9QYqCAEJSqzNTvtwgPqIKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzXNsvMaujUDZTUlDiNaRt5FmKtnLzTQ27MNHsBmg/A=;
 b=lPGAR0F6tzozPhSLYrbTanZDvy27UytkjNS3tqVP2cXxhNlZ/PfPMKevfMm4uBz1EFzyc/wlLPxPNC3oXjgEsmbS7ZgJjXad6zwR0kzUqoyi5IAOn8d7J2jpdTwHYE14Z4nWaWCMAzjmJnUuKRAX3UbwG6Z845XeRlrUn7TAUpXDvyuzNOETtlwSJiTbuesj1NZ5plV5dG+cvsDpMPu0sQMNqKDNderTm9elUJcNUvy724I03zA9HKpjJOwq/xmz2w55o1ORR1iU6PEIcu2bxUXyqvDdKxK6aCqBIpPtkj8jQWxyYGrQd9GmHHjmMtRZqB+ggBM173ASOzBlHQo9EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzXNsvMaujUDZTUlDiNaRt5FmKtnLzTQ27MNHsBmg/A=;
 b=KghH6C3yJ/wRxqCzm9UqH2XtfYqTCGInunvGudUDGRGHgACD/aoS64FQgtVS72zjZwyGOEcR1CJ4CnX6WC01/tng7OULvo0cI8/MdGhYsAEQRWq8xstAvn0p9N1s9etsqrRx+ZnkKO5WGxvVqWUyt+923X5FQu/YRXvrke11XWk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB7078.namprd10.prod.outlook.com (2603:10b6:510:288::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 09:07:27 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 09:07:27 +0000
Message-ID: <b8beae0d-5439-4ab2-a4a4-7ba8f3cd190f@oracle.com>
Date: Mon, 26 Feb 2024 09:07:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/11] fs: Add initial atomic write support info to
 statx
Content-Language: en-US
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, axboe@kernel.dk,
        kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <87o7c51yzk.fsf@doe.com>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <87o7c51yzk.fsf@doe.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0652.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: 6441e694-46b6-489b-cc7f-08dc36aa5a6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	NVvVDgrQeVCj1L1RSO7N2y4miXMLgj+v5UZyfpPfsqm13FyTL5zIAGBk4lFgVycLfGT2Yd9SsoswvQuBf+pC2LGqPCqCfVrlrjCfQYsgIeQtWiSv2Vhgjj5hm4/Dnw+f1ggh6f8SZF6PX++hEw3AtWm0ukygwd0OrJbE9DMLufAFVCvaEYm9URL37Nvwtu6EOmZT9eUuhRB5CC2AYGxm7Ju1VRPnuu+o6yhNs3lSFVlnAoq9v6itZ1AuQ9J0IDS320ETorY17XSoaFV8O1zOfZ1t65kCVSZPnq7jYP05iKxHmc7aVtSEYOk6t6dxXIMRYM7hATXJ5J04/18ThdgUQHa/V18f0LQZkXAzS2Nlc0G4ZFxoz0ka2lywiL83df18+Cb1WojgI1Dh1uJ3AbjHliye2yf1xKx4GGk8s3h+9c1qB/fiazPm/o1/Yk3ZrwKNdPn2qUdb9HREnPwDiZMfWP2kpZSMYGoHTH6dMoHuY6toRomT52ZOKFg1avcPdlDgIUC2GcqgFqONRv3vkdVNHeS/NtruBzSD/6CC80NvJ4CVf3gu2rtnCJZQL7IXr9+b5nS1HT+17XzHsWNuaQOwbrIg1qtR4mRo41tFzIhMkyCWC9WTaCCH3/WVU7a3xmYHAJZP4PWc4DYqTAb5ekwfXDoAyNIb+4KploI30+fL0xkSEBW7K9dDNaxfkAlYNpuyw4neXxYvLREn5bf1yrjfCg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?M29JT2oxbnUxZ25pOGNJNGFHMTBXdW0rQzJJYitRMml6Nzc0cFVQNFpuRTAr?=
 =?utf-8?B?bmpPZElCOTJyRzY5bExMVkIxMzBDYmE5eGJPL2VJSndmWlIveTJjRFpFTE8v?=
 =?utf-8?B?L2hGNFl1eGc4V1pzNk5ZQ0ozV1c4TTNOMUp0ZU9McVpTWXVadE52d29LUWtS?=
 =?utf-8?B?QjRwaEVSd05LVGdhRVlJRVozcmY5eU8xMEY4TXpQenI0alNUWXFick5KOXhP?=
 =?utf-8?B?VmtPMkVndngxdG01YWk3WmFWRElQZ2lEKzhWSEY5NlBKMUtaUWoxRDRVY2F3?=
 =?utf-8?B?ckxmNFFVN3FWZktvbkJGOXpxRmFmaXJoMng5MGtndGlYT3pyTzNoTklvV2RM?=
 =?utf-8?B?MjNYSFVFMTRqNG1NWXBEVmhwU3dsYXZjY0ROYXlKbHprMU4xeHlhRVF4Z0RF?=
 =?utf-8?B?SzFyd3VFeXlHeVdKVjZCOU1LQU5oV1JiU3pkOTlTRi9zWFVOUVFxRUkyZXQw?=
 =?utf-8?B?RXdaN29Rd3YvMVhxQUoxQ1BZVHF0VGowTUJ1cUs1YUE2aXFVNnI2M3FTdkxP?=
 =?utf-8?B?dXVhV1F0VFovV2VuNmdiWk1GS0dUQ1JxV2libU5Dem1Jc1ZoeUN0K2dKWm0v?=
 =?utf-8?B?RFc1VVZHMGRiSzZjcXU3QzAxWk8vbUdjQUJhWUZVREZHWUVwWktMK3NRek9v?=
 =?utf-8?B?dzNHVVBBRFFmSVZIakZ5RHAycnRqNlRnWVdjRXVUU1htSVB5S1ZnNzlEeHJK?=
 =?utf-8?B?MVNqVHVWR0lyZ3A0OUNaWkZ2WENIYVB6akt2ODV2RmhZVDI4dTRHd2R0UzZQ?=
 =?utf-8?B?MkxtdS9SbnVlWnJxTmY2THhTZmw3dk9rcFo5TGRBTG9pWkNnci92Zi9XMVV6?=
 =?utf-8?B?SlVSYXZGT2V3UDRhS2lvcXovNytCN0FMN1FlQUx2dzlvNDFtUHdFMVc4RjJU?=
 =?utf-8?B?QkNMRGovQWJDMEV0RllyV1lxYmZEVi80RWhWTW8vd092WDFnRGNIQm5ERHUr?=
 =?utf-8?B?cXZVbE5qdm5GQTVBekNKbGxXT3VRNUFvSnRMeW5LeDNYQmN0YjVYZHVNZFhj?=
 =?utf-8?B?Q05IdUovaW15YlJGWng4ZHMwakpseHVwUi8ydE1wbEl1eGs3b2w2WmJPV280?=
 =?utf-8?B?Q1Rici8vRUN1ZnkzN21HT0RuRVpFVGYyQmZQZC8yUEpyaDZKWGFLQ3BBMm9G?=
 =?utf-8?B?eHVXV2Z4RW05cTFJTU0xK2FjUzl5VDRYVEp1MUl5cE9QNlROOVNBVS9ydGdJ?=
 =?utf-8?B?UG5RR3ZJZmF0dXpZOFJzeEExazJqUjBPVGNWYXJneHFUSmxqeVErTFZTZS9O?=
 =?utf-8?B?RWxhcC83dGlpbTNwQ0xjNUZYbFdCNXZmSmNsanh1bTdsQ0ltN1MzczBrcnZt?=
 =?utf-8?B?cEQ0MmxXM0JJU2F0YU1vS1RpUUx5N2RJaDVld1ArMTZPaFJLTVFlbVQxenhk?=
 =?utf-8?B?QlJ4by8xYW5ucE5qRWY2b0szSTBUMmc2cjBaeXFnUCt4S1AwbFVQSkprRzlB?=
 =?utf-8?B?ZmlVMXhEbHFtUGtCQ2RYVldKVFF5RXlxWHRIMEZRTlJSWjdaWm9OZXpCNU1Q?=
 =?utf-8?B?QStnaFJsUW41NkdORjhTdE9NWUtFTGRMZzRPUmZYZ0VyVWVFYnRLK293SEwz?=
 =?utf-8?B?Q0x3N3VlSkQvTmxKM2krT3h3T2F2UWpIcTg4Y2pYU1g2Z1BRWlpIdjlBT0ow?=
 =?utf-8?B?TVN5Ti94amZJYnk2aDBFWUZLZGMzZHM5VmJCRUREaVh5b3Q3Umt6NGpEZS8r?=
 =?utf-8?B?L0ZuZ1BSRitRbEVZYmgwME1WNDRzZVlCL0VuQWdIQzY2Z2pjQ2gxS2dncEE5?=
 =?utf-8?B?RitvN3YzamZ4YXY3eTdoVlhyMnAvZkRkaStOK0R1N0ZTRTQvSWNSUGtoUXFq?=
 =?utf-8?B?UU5DZXdsWGEwUG1Va1ZjckdRYXZ1WmkzNTE3UDZPMnBEQThtL0JGeGhvUHV4?=
 =?utf-8?B?QXJuQk9yZUdSUzlSaHFMUkRpNHFLZkYrOHIxSHM4QzBCRDJaeWV1SHg4R0c2?=
 =?utf-8?B?YjZwbUVtV25JNC9zbkdIMGVZdWtvQnROQ29DR0VmNjVyZ3VxeDlhUk1jSWxr?=
 =?utf-8?B?YU1pclNXOUNpOXQ2TVh5Sm90M0F2bG1WMG4zR3VNSUQ0YjFJQlRUWGUvQ0hD?=
 =?utf-8?B?aEdFa2RocWgyV2l2eFJIYXoybDJNREx6M3daTnZmUVBteVgyRk5Eem5KZDRw?=
 =?utf-8?B?ZDc4clJTL2I3R0F5dWM4cVVYLzZzNVc1SG9VTnBMeGlVRml2TkhPZlZKUlRk?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	9Ij7oFXf0nJdqXuHVg5704FSDByuNM+GxHm+yub141Tln5kFF+MbVk2Zalv+mmht3QXcgrGj+Po7w8FAMz7qUJsc+RQWWysycgyPxTdLTFM6cNPYejnUsZarSOOHf5uoqwQaaUrTIPM3qu0cQ2KWngJPM6I5Y4vLXfZ1stozm29I40vCNrfPMHfMosjCJ1OTciVPT6mTavHV3PiiTkAxhjnHGX+x/KuoIZniu+uYc+F1biF/XqKpABK4/RH/aygJ3Fp+j7mStkqVciHGvAfTpRC9kek+QTEC4omU5hbKo6X+oTGY5sbfQiiXmsGnDxTPnjLt7A5N65W8DiOMOgL1t8GZkE8v7Myo87oAfKLjEEnUkdG3lEuF6XbOA0HhHhsNCikPAxfNt0djEFmrfGgLcDcugWC1jC/ph+4UeX3rpOnmN53cBi6afQjxoBUGYQ9+yLSehqlnrYSpRtVSCgfPFeJFGfLJa9nWW3Tb/U8toVXEJaRrSvhDvQTxd4VNLCFj3IY0j0LZS+hPxxr74yNQessMIpWKj6OLTjPsKFPbTtJxZRIZXsHwLN0O09Uv0n5DAW8LVuORLgbv6ETFUztO7OhJ0mwXLmieh1TGWyAmM1o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6441e694-46b6-489b-cc7f-08dc36aa5a6f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 09:07:27.1256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojHaD7CBRL2KBdl9HOdFXJNJoFxFqfdC4ut9c9Zr7MYCF3rRzhl3vYh7pXD7/MMlDgs5lM3wsFvhxDZy6W5Y0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_05,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260068
X-Proofpoint-ORIG-GUID: P9-2AA-3oJ7o9PNgujmb-XNU6kpMWhIM
X-Proofpoint-GUID: P9-2AA-3oJ7o9PNgujmb-XNU6kpMWhIM

On 24/02/2024 18:46, Ritesh Harjani (IBM) wrote:
> John Garry <john.g.garry@oracle.com> writes:
> 
>> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
>>
>> Extend statx system call to return additional info for atomic write support
>> support for a file.
>>
>> Helper function generic_fill_statx_atomic_writes() can be used by FSes to
>> fill in the relevant statx fields.
>>
>> Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
>> #jpg: relocate bdev support to another patch
> 
> ^^^ miss maybe?
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   fs/stat.c                 | 34 ++++++++++++++++++++++++++++++++++
>>   include/linux/fs.h        |  3 +++
>>   include/linux/stat.h      |  3 +++
>>   include/uapi/linux/stat.h |  9 ++++++++-
>>   4 files changed, 48 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/stat.c b/fs/stat.c
>> index 77cdc69eb422..522787a4ab6a 100644
>> --- a/fs/stat.c
>> +++ b/fs/stat.c
>> @@ -89,6 +89,37 @@ void generic_fill_statx_attr(struct inode *inode, struct kstat *stat)
>>   }
>>   EXPORT_SYMBOL(generic_fill_statx_attr);
>>   
>> +/**
>> + * generic_fill_statx_atomic_writes - Fill in the atomic writes statx attributes
>> + * @stat:	Where to fill in the attribute flags
>> + * @unit_min:	Minimum supported atomic write length
> + * @unit_min:	Minimum supported atomic write length in bytes
> 
> 
>> + * @unit_max:	Maximum supported atomic write length
> + * @unit_max:	Maximum supported atomic write length in bytes
> 
> mentioning unit of the length might be useful here.

Yeah, I have already improved this as suggested.

> 
>> + *
>> + * Fill in the STATX{_ATTR}_WRITE_ATOMIC flags in the kstat structure from
>> + * atomic write unit_min and unit_max values.
>> + */
>> +void generic_fill_statx_atomic_writes(struct kstat *stat,
>> +				      unsigned int unit_min,
> 
> This (unit_min) can still go above in the same line.

ok

> 
>> +				      unsigned int unit_max)
>> +{
>> +	/* Confirm that the request type is known */
>> +	stat->result_mask |= STATX_WRITE_ATOMIC;
>> +
>> +	/* Confirm that the file attribute type is known */
>> +	stat->attributes_mask |= STATX_ATTR_WRITE_ATOMIC;
>> +
>> +	if (unit_min) {
>> +		stat->atomic_write_unit_min = unit_min;
>> +		stat->atomic_write_unit_max = unit_max;
>> +		/* Initially only allow 1x segment */
>> +		stat->atomic_write_segments_max = 1;
> 
> Please log info about this in commit message about where this limit came
> from?

ok

> Is it since we only support ubuf (which IIUC, only supports 1
> segment)? Later when we will add support for iovec, this limit can be
> lifted?

It's not that we only support ubuf, but rather we only support one 
segment and that gives a ubuf type iter.

This is all related to how can can guarantee a unit_max advertised to 
userspace can always be written atomically.

This is further mentioned in the block layer patch.

> 
>> +
>> +		/* Confirm atomic writes are actually supported */
>> +		stat->attributes |= STATX_ATTR_WRITE_ATOMIC;
>> +	}
>> +}
>> +EXPORT_SYMBOL(generic_fill_statx_atomic_writes);
>> +
>>   /**
>>    * vfs_getattr_nosec - getattr without security checks
>>    * @path: file to get attributes from
>> @@ -658,6 +689,9 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
>>   	tmp.stx_mnt_id = stat->mnt_id;
>>   	tmp.stx_dio_mem_align = stat->dio_mem_align;
>>   	tmp.stx_dio_offset_align = stat->dio_offset_align;
>> +	tmp.stx_atomic_write_unit_min = stat->atomic_write_unit_min;
>> +	tmp.stx_atomic_write_unit_max = stat->atomic_write_unit_max;
>> +	tmp.stx_atomic_write_segments_max = stat->atomic_write_segments_max;
>>   
>>   	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
>>   }
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 7271640fd600..531140a7e27a 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -3167,6 +3167,9 @@ extern const struct inode_operations page_symlink_inode_operations;
>>   extern void kfree_link(void *);
>>   void generic_fillattr(struct mnt_idmap *, u32, struct inode *, struct kstat *);
>>   void generic_fill_statx_attr(struct inode *inode, struct kstat *stat);
>> +void generic_fill_statx_atomic_writes(struct kstat *stat,
>> +				      unsigned int unit_min,
>> +				      unsigned int unit_max);
> 
> We can make 80 col. width even with unit_min in the same first line as of *stat.

ok, I can check this.

> 
> 
>>   extern int vfs_getattr_nosec(const struct path *, struct kstat *, u32, unsigned int);
>>   extern int vfs_getattr(const struct path *, struct kstat *, u32, unsigned int);
>>   void __inode_add_bytes(struct inode *inode, loff_t bytes);
>> diff --git a/include/linux/stat.h b/include/linux/stat.h
>> index 52150570d37a..2c5e2b8c6559 100644
>> --- a/include/linux/stat.h
>> +++ b/include/linux/stat.h
>> @@ -53,6 +53,9 @@ struct kstat {
>>   	u32		dio_mem_align;
>>   	u32		dio_offset_align;
>>   	u64		change_cookie;
>> +	u32		atomic_write_unit_min;
>> +	u32		atomic_write_unit_max;
>> +	u32		atomic_write_segments_max;
>>   };
>>   
>>   /* These definitions are internal to the kernel for now. Mainly used by nfsd. */
>> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
>> index 2f2ee82d5517..c0e8e10d1de6 100644
>> --- a/include/uapi/linux/stat.h
>> +++ b/include/uapi/linux/stat.h
>> @@ -127,7 +127,12 @@ struct statx {
>>   	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
>>   	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
>>   	/* 0xa0 */
>> -	__u64	__spare3[12];	/* Spare space for future expansion */
>> +	__u32	stx_atomic_write_unit_min;
>> +	__u32	stx_atomic_write_unit_max;
>> +	__u32   stx_atomic_write_segments_max;
> 
> Let's add one liner for each of these fields similar to how it was done
> for others?
> 
> /* Minimum supported atomic write length in bytes */
> /* Maximum supported atomic write length in bytes */
> /* Maximum no. of segments (iovecs?) supported for atomic write */

ok

> 
> 
>> +	__u32   __spare1;
>> +	/* 0xb0 */
>> +	__u64	__spare3[10];	/* Spare space for future expansion */
>>   	/* 0x100 */
>>   };
>>   
>> @@ -155,6 +160,7 @@ struct statx {
>>   #define STATX_MNT_ID		0x00001000U	/* Got stx_mnt_id */
>>   #define STATX_DIOALIGN		0x00002000U	/* Want/got direct I/O alignment info */
>>   #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
>> +#define STATX_WRITE_ATOMIC	0x00008000U	/* Want/got atomic_write_* fields */
>>   
>>   #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
>>   
>> @@ -190,6 +196,7 @@ struct statx {
>>   #define STATX_ATTR_MOUNT_ROOT		0x00002000 /* Root of a mount */
>>   #define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
>>   #define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
>> +#define STATX_ATTR_WRITE_ATOMIC		0x00400000 /* File supports atomic write operations */
>>   
>>   
>>   #endif /* _UAPI_LINUX_STAT_H */
>> -- 
>> 2.31.1

Thanks,
John


