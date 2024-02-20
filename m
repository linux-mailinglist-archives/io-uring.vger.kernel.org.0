Return-Path: <io-uring+bounces-661-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3053585B657
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:59:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A96561F220C5
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 08:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E085F875;
	Tue, 20 Feb 2024 08:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="et/T+yoF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yUY12BVi"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABD95F47B;
	Tue, 20 Feb 2024 08:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708419369; cv=fail; b=QemxyO1jW6UvM/QjDI/IJccb6jxus9rlihqfkP5v59JTFEI5z89gh4RO/8gw66gg/jufbzkBgn5qEZBAmI5QuTY5jSMpJ1i5UE+pDYO5CdsIK2o/E15xSp3zVOxIPboMUP3H1j6dHsMz6MiLRukYBvvpHu295I74Hul8djJzIjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708419369; c=relaxed/simple;
	bh=GMqcqutwkBofZ3LdhCYaV46DVQYjW846nYUiTusUt0Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eAtSzyfOLvZJE3489lyZpV+kpEcVgTxLN8wn0PSQkTBPSCXsaWkcW0AqGo8aPNUHttbOA2T0phU+4yHkYlXIDM1gL/dgHV8ZYUzu6Df6UkA0BwIL4Bs0sGNgFoHtMnuUZ/vtTTlVsDGZjXL1r5xpxTE16seXeoIcg3UogwZhutE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=et/T+yoF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yUY12BVi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41K7d2oF028689;
	Tue, 20 Feb 2024 08:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=ssv7AK/VjZaJET0Y3OVuZIjQ3HggTjv9haU9UvjGDFQ=;
 b=et/T+yoFcdCd8WH2GmbDxpV8iPrkaNydw7x6X6uCTftCpdUBsHzaIRCKXdbYMKbZXObk
 tDWWy0etNyxf/7LV4Xb3AfTF4vyZ8msqzTwKtwy1ouyTM7BTEEODXuTaAGMQ+tA25xrs
 453zq1fVDKzsLV9Yofau7QgJYa60/uNLb9aPUFXJnESc/dxhNbi7GESjxSbvlkCFVahD
 THNARoF88p3FImEi0qc27GJRxNqpqmB7VLqhRSedV5M7Mu6t+kBp+E5g3csqfp7G7QYR
 e4hdmWpKMDAImG45qG4jXhCItQxC/79WfdzuKKUSN8fXJcImHJujLiN9f5WlUH8wcz5C gA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wamucx3hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 08:50:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41K7vdhG039694;
	Tue, 20 Feb 2024 08:50:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak86xksu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 08:50:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ohAujQXrK6Y2nnL3J1DV2iOp9bL/6N0AMpUe+uwo+MnwEKxElYrb+SO5hT3SsKBdtwJl6GIfHbDPj4AD/i8ntG20G30S5muUMlR/IZv7bbpqd4BMPa+oeDYFwcVTShG0TegJEFDjAz5N2UJQ/xjhzBvsZkpVvk+NSkuI1hUq5rLVIlKkXo8IhF9qHswazycIV81PqcJZCWZSBcAJ7l1RniqYElOSSmrjWHF81EFiAL/RVGAtPiNspQXUA1BsOXT/gt8+2Gp8YaOtZuaFKDgnXV7PBPkHeBQAaRucxkwgAoXgDfv+rnlk1b/QkZFfkQZWRPU1UYdxJkdaGv8DwcOUVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssv7AK/VjZaJET0Y3OVuZIjQ3HggTjv9haU9UvjGDFQ=;
 b=H/RO/Z5YxRr+CDMPEyQQZ4Sb+2zquoAkKs0ikNCfDRetucPfALRbXn/iGNUgss33NnOJnfc5v32Sl9LgVLmJY3xX1lTdUfRkEfHSQgHPPPp7yk9OlJ88hz44sRZ50eb4jEbagMeJknE1MOoT+kXz4VOb671U2oy6j7RVTp8woWLlDy90ya+rPYfcdeC2v+V42ap3/QJ0dIaTGPnlT7BcjyZ4FNDsGtnjD/AXRfsOcK+lK65me7lTfNlLqaEhOffOaf4S2EEiI+zhB7jORSylX6yvA8NwECBDH6dfeDp2cpSUQ7pus4qCQhhskJ3Be+ENcLpv6XlQdYtVG6Rl5P/GCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssv7AK/VjZaJET0Y3OVuZIjQ3HggTjv9haU9UvjGDFQ=;
 b=yUY12BViXfc10EQ6nUOIiNnMOO8nzto/HtV35FXTqH0APnvqSsnL1ba6ytIMzfcHB0aC8Jw14WPRbTnwrnpupfEK6hWTn+0Xg/P+DrJTU+5HgyxwViQNfC+sED9NHvT0PCra8CDZPP8eupuF9KW/1/WUgC4ZMCRK4QTh9xlbZfg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7501.namprd10.prod.outlook.com (2603:10b6:610:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Tue, 20 Feb
 2024 08:50:45 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 08:50:45 +0000
Message-ID: <9ba55a23-40d2-4a27-be15-550c247018d8@oracle.com>
Date: Tue, 20 Feb 2024 08:50:40 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/11] nvme: Atomic write support
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Alan Adamson <alan.adamson@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-11-john.g.garry@oracle.com>
 <20240220083119.GD13785@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240220083119.GD13785@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0155.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7501:EE_
X-MS-Office365-Filtering-Correlation-Id: bf1fc209-b050-4bec-b83e-08dc31f10710
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ubZqQpnS9BoWRzTYbfcrK2R/BOA29g2La5UAWRckFvvihYrZx7ThH8LAaT2b77CgqlaULRKz92ZpYNLNwkogjhQy5TfcOs8+3nFw7W7Nmjs16SGqzzCNbrC8K5np4jlgOg7/x8nVk/x/hpJdsHvouqloYfjUb+Wzz74sKB+0UqhzyyVrsv80Hq1JfeAYwhUqHw1ND8YJqlZLQnPijP+GyHhc5S7ZKM1yBwCcXGSe/+OUYJ5cJ/jrLWEXe0mAsSKGIvGE0fg95DzMSZQwq3jwSNWXdIBt+K9Q6M6oKLZ7L7SmHFktd5bvY+PFs8Zoo93WZFQcMC+Tu80pNaS/7DKOWFNX6e2/1ZYEJi1GdnyhhbV9pX8pomLISzPyeru0wySVP8yMu63FZ8eROf3oPBfXS8JyICoOii8GAUaILvf63EuLBMYKdZ/mWqiZliqvOpztdnIpjZad/rlAKvP9a1F0K8B81jDdSwCrYRJdA8NHjYcH7hgDtKCG4u9yxTsDgteWNxOG9evUP5nAVlkTmHNNkCTLtllL4xUC3x3cC+F4cTM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TjR1cWovUXF2a0dVdXB5NkF2Wlh2UFhKdElNVk1iQkw1TWdGVUdCZTFLQ2ts?=
 =?utf-8?B?b000UzBJRmtzZ2t1cXBxS3kwY29oNjNMRXEzRWdBcFJkWWNsY0s0T2RoOWVL?=
 =?utf-8?B?NjhMRU1rRXBtZE80elpIWVhWNkFmcEdGRlIybnZWNXU2bzZ6cnA5dDBWQUNN?=
 =?utf-8?B?UEpKUnNMV0FZSWU3aWpGZGgxUTBwc0wwenY4R0tnR1N3enFNTHRpb01xWlc2?=
 =?utf-8?B?QnVqVlJYVVIvS01xUnlKM1dvTzdjZjNSNTV0NTN1bDZrZjgvVTFMam5jVUJU?=
 =?utf-8?B?dEc0SFJmNGlkT0ZrWXQ3VzVjbUhZNmNzQ0lYZUhySXowQWRQY0xhUVRaUEpJ?=
 =?utf-8?B?bTVhUGVLWVNpK0hOSXhmRDF3SW0yYlBqNWN5Y2JHNEU2M1FNM3JDbWU2bGJZ?=
 =?utf-8?B?MUlNdmNWMmtoem9nUW9zV2JvaEVCSlhwSmFmcWVTSkRXYkRDT3JXVGhIenZq?=
 =?utf-8?B?Sy95eWRnbEhMV2NUbGxjbmRjMHlVUC92TW9mMzdEejArcitjclljUDFIcHBM?=
 =?utf-8?B?Tzlmc29lWUhJOUkrT1ZhTW9LRnI2SDIrLzdwa0dPSGJxejNhcC9iTlBBdjJP?=
 =?utf-8?B?cE9iRXRmejdpR05rTW9NOStUTFNlc3JQdGVyV1pQTFZjdkwyNUFnSE5NZDFL?=
 =?utf-8?B?SzVsZWlpVGI4QUJFeUxZZWloeHhYWlVkZjZML1Y5TE0vREF3L3FJU2dURzVC?=
 =?utf-8?B?YU9jQnpNN21PdVhmcUdYemJtUmNoOWpDZkltWlFMZEdORVhnTHpHbnVtZmF0?=
 =?utf-8?B?RDdNbU5ubUFvVlpmSUFLeDY1b1lCK1BEcTloS0d0OWRDRWV2YWYzM2ZmWVVX?=
 =?utf-8?B?Nk5adUNxaW0vWlZPUXlwNVloRlpvaThOVFI1WDZTUm4yenUxekZhWlRhL1BH?=
 =?utf-8?B?VEhuV2kzcTZXcGxjN0lHWjlsclhyN3VybWlXb0EzS2tOR2lRcE5SYm1MZHpw?=
 =?utf-8?B?NVFvK2pMRHRQYk9HVlVRM2F2TlIzWlZzUW4zL1pUS29oWTA2a3o5aThZNEI1?=
 =?utf-8?B?UDNKMXdQSGtUM1RKZTZkUld6SU9qaGJ0SGdkS2YwVHgrRHJGNkhHdGt4LzFZ?=
 =?utf-8?B?ZVNNbkJHR3N5cU1MOFY5ZVB2L0UvN2x4UHFNYXpiVHU3elFHeDRxY040SmYv?=
 =?utf-8?B?WnVhWkZsejNOeTYwQUNaai93cVNKN0JjTUZsdGNpTXZWNFRGMXkyVVg2cG5P?=
 =?utf-8?B?L3JIbk5qME1EQWFrdVFyanJZY0tZaFBsNFNtdWZXZTl3SFIxQVZPb0J4ak55?=
 =?utf-8?B?NVAwQkNRa1Z1YzRYY2NoM0hHTFhHdmk2NjU1cFZXazF1TnRRcEdoZGFPakt4?=
 =?utf-8?B?QVNTWHRBRFVOTU5vTFNIeDBFOVVHdytVMm52cUJtVURnblg2eWh5WGJPeTJ0?=
 =?utf-8?B?Z0Nhc2g4MTAzZWxwajNta2tiUWh2d0x5OXdicHZKSTJ5MDBGM2R4R0dSUFd4?=
 =?utf-8?B?T0J2eFBqRTRxTmU3Z29mRThoanBwci9LVlpDamxvd1N3VnlxVzlKem1McUFv?=
 =?utf-8?B?T1dkd0lXdVlFKzdsZXRvYjVvVXh0NllGZWlOdmo3THJQZE56YmVMVHNHK1FI?=
 =?utf-8?B?NHlhbEpFZnFHUlUvb3Uxakx3RmtBUFBEMGMweUpoWG9PQS9TeEtHUDRSUHZN?=
 =?utf-8?B?bHFjbVhWWHEwNTBwMUh3M2FiWUNKb1pnQ2oyS0lRTzU1SnZLZEY4RFQxemNN?=
 =?utf-8?B?SFdpWTl2RTdZT2hiaHZUeGlKMVBmaWt5NndyY0lwZGRzTkJYYUh3VTVEV0Iy?=
 =?utf-8?B?TUhwdGM3TFlMTzRCd1lQZFNvMk9XSll4Nm1mRU1ROExLN2M0bDBla2RnN3Fx?=
 =?utf-8?B?TE1TN2o3eXpCWjFJeWNYY2NtSHg2cFFrQ1hTR0VMT2toYVcvZ3VQZVNCdDN2?=
 =?utf-8?B?blZwemo4ekxUc29sNlkyVGZjckd2VVd2SGhRWnlTVjJjRWtlY0h3VEtJRjlR?=
 =?utf-8?B?a1VoVGpGcTI3TTY0QWJoWHN5SitnMGkyUGpYMEN0VElWamJSM1FlMDdwc0NK?=
 =?utf-8?B?Z0lBQXVXeittd3plWVMwQTRSMENPNFA5S01GODRBRUF4TlBYSmdFbFV5ODI3?=
 =?utf-8?B?OWcxbWpKdFJFV0M1Y1ZFVCtvQkp0YlY5ZzByaEgwa3E2QlNGYWJYeWJyYkpX?=
 =?utf-8?B?TXVMQndJeVFEMFpsQWI2NStpaFZCbnJWWmhpdkhvSEJlTTJqRjdDK0g2YU9O?=
 =?utf-8?B?Umc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7i1ijt2EoRr6wRsPXvzsvspCjSZVea91f78qX7NB28CURmDYSAP/8KiEZiyYsqsFm0+3S2jsEPOnz3wpSVi2b9CjeMOJNNzlFDG+W0O/foPfvG158tlBVAOXCFH9hhN2JWFzVT2z3sGeABUEpanfxffxroVLnvLnJJ2ZQ9MssfVVUm//IroJD6xUtaULI6+LW56xIqCdPeOxR6b1kJ0TefdC+MzRPJ6DV2/qCLdFr1J98gl9rgBBcKJm/O1Omar9Nj9oagbwrjFyyKpdEuCRN8E/SYDKiKwuhsqo3Il2NO+5IwIROTYg+Aveydx6bE58tjK/Wr53+nyuCQP3MnKQ6TQ5aVdiB6ygRL9dOauJUeOZOd/kQq+CCLSXq523CZc8nmWH6jGmSOTYvRE5FrzsPtULPekEQXxI2mIOjfBsiX21PbbHBTkVcXLrHgqSWtW0bkmeQjVyaGAx1jN42NsG3xTeBbTV+o6Kpp0e/S3vKZ2NyDQV8pDn85lSItAEKJ0jAX49XPDlMy08DQuLOd3+XZh+HZtFDq03JmBPpIBv+bHT0rFxPzRs15Uv1KWUvEp5JPey2NTo1Owm6shm4P4Byp9tsuKis0mCgbp0ewRgOGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf1fc209-b050-4bec-b83e-08dc31f10710
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 08:50:45.7000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPnDAhhwDxl6Lyz5JGF7RlNbMpC6TnU+9iG2vgAEE9BrtUoBJ7JIbYeZ9ds0C2jPRGAWImA+7GB13ZdaH2aGfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7501
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402200062
X-Proofpoint-GUID: uk6O3tPBHoNNYWXf7sVyJ8G8a14LMv0K
X-Proofpoint-ORIG-GUID: uk6O3tPBHoNNYWXf7sVyJ8G8a14LMv0K

On 20/02/2024 08:31, Christoph Hellwig wrote:
> Thanks for writing a good commit message!
> 
>> NVMe namespaces may define an atomic boundary, whereby no atomic guarantees
>> are provided for a write which straddles this per-lba space boundary. The
>> block layer merging policy is such that no merges may occur in which the
>> resultant request would straddle such a boundary.
>>
>> Unlike SCSI, NVMe specifies no granularity or alignment rules.
> 
> Well, the boundary really is sort of a granularity and alignment,
> isn't it?

NVMe does indeed have the boundary rule, but it is not really the same 
as SCSI granularity and alignment.

Anyway, I can word that statement to be clearer.

Thanks,
John

