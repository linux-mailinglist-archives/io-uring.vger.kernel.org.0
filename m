Return-Path: <io-uring+bounces-2108-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7022E8FC95D
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 12:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BE40284450
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 10:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE49418FC92;
	Wed,  5 Jun 2024 10:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bFnv2nFD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wSUkoCBK"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC60C1946D3;
	Wed,  5 Jun 2024 10:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717584586; cv=fail; b=d/VdlxUWDrjob2Ql+ASxy4w8UeI+vbzVDcgSegLuXfREx0eVGGr+vHp/oPtSnUQimZkLH11VgH0ka5Con8PT0L5cqybRU4vQ/9RTtlVUF1R9i+GgTlMlKdKWrpr6qQ674fJD50SB7AHkRUwqNASiyIHSmLD89DP1q81685sI64s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717584586; c=relaxed/simple;
	bh=VNlED6SNnw8xAEllI7AHRNRs7/yLkCEfCWJ0iVPStP0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WRxSDVM/n0V/mw6RIHMJB4evRXh3A7zRsanyOKDGoSzE4dKqGcb3zE4zlC7Zhv0VAyI8qManvsesf57jk2xxr4YTDTeFR2Ymp3EZGrYVYjXqLW7o/DgZTq3w1qlDZODiLNBoRj1o2tcS0ZOzZCJvSGsfpoII3OdfC9YJdpialkg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bFnv2nFD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wSUkoCBK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4551EGAV029133;
	Wed, 5 Jun 2024 10:49:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=corp-2023-11-20;
 bh=d7Qup2vXDbxgyS3t2Y8Ih+XYr5yisTPXpNQ8j49sbww=;
 b=bFnv2nFDRQxI+UmVXNoRF0t6aM2cYLUysyH5cvbSPj/c6AKu5HFMxg4QXZRvlADp3q/y
 vndXQ6YFuwCYOERMhJYyI0mcX1oXk9ip10Apz0YMmGB5AKG5Ie+rw4CsDzESrpcas968
 f5r6dx3zATmbjjvJIHs04CX4l0pOgDZUshvkqDcy0V7VlikQ79THNNg9tK6x4SZ1UizL
 sqa7hGxtQfUaxI03jdJ1hbN+ycNT98Yh3u4CYln5YRC1MHzJYMyZ1sD3RuHzTphKoigm
 RbRzRFA1w6WIk9S9BvVLgxbZCsUbluvvdtatkKUhE/HHFT9EWMEapUNy8XOYgrHfQA8z /g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbusryux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 10:49:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 455AHf6N020607;
	Wed, 5 Jun 2024 10:49:14 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrj39xau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 10:49:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHI7wjkJzqx7/vmWRM4PatR8pi9Y0/EPF1fvDv0e1lCRo+tqQtr2dfQuS0TNJ30hAy8p+1C4osbn16JUvDQ2Vq0qn66EKw6cFCgj9rjHfx5T6rilp8ddz+7Tle8D6F8HEi3JdIV3tZY5YT+lUJoqh38vuTOm+xh/R8uCkjJ3CHE8cxfc48MeaWNman4649537k05i3gsR6BrvujANphQE+Y7WDdU+PK0+AiIg1X+oVjvfPOM239Doy6olbzn4k7uR5AlX0u/2r5u63WLHwLVAlFrQbitot9Z1aWG1S3xswh9WJXmYmSHrE3zdgh1zR0I0781yE63gvrRn3DCvuKslQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7Qup2vXDbxgyS3t2Y8Ih+XYr5yisTPXpNQ8j49sbww=;
 b=ZugyebbGd92ghMnZcwKqbekK9bb9Iw53ba0CADebEJona9shn8iX+bMmhq0EZxEZPuqd0MjpiKm5rj45UH/d4sf7vqGGi6jYU1LNcm/meAWMqT6y9IezrkCRoY2iDmAuEsqOp/nsjXQqJtK/SjEIMpAX8xXl3j6EjHxn2/aVwU0Ic1Pus96I392VNYFDABTfldR0F8jCeAzUBwVw+4RIFbpKRDLKghXjbZbwkELjY9ewZzMpznUBRUzGX+bW8FIZz0GpCHOK+n4HF3wP3eqcISTTEzc2eXj2I3UVQreOiIDMQ5158KFs/Q+bW1af6i7dG22HkaH6njMWLjGoRvYOQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7Qup2vXDbxgyS3t2Y8Ih+XYr5yisTPXpNQ8j49sbww=;
 b=wSUkoCBKXwUXAfiZiFhwRJf1Box0qgV5rtPuQLUywCm+2rawsvWoo0ViZ3Q9xibKY0Y1k86OO20bLtSQ81QCDpS07E7JJDRBKJrR8jvmLFyuCMMlIr0l3FNwOXacQkhrXrEtPhWLiG5AvfAZIoqs7xkc6B3v+3WMNJOecHk06do=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO6PR10MB5588.namprd10.prod.outlook.com (2603:10b6:303:147::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Wed, 5 Jun
 2024 10:48:20 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.032; Wed, 5 Jun 2024
 10:48:20 +0000
Message-ID: <fbb835ff-f1ae-4b59-8cb3-22a11449d781@oracle.com>
Date: Wed, 5 Jun 2024 11:48:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/9] fs: Initial atomic write support
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
 <20240602140912.970947-3-john.g.garry@oracle.com>
 <20240605083015.GA20984@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240605083015.GA20984@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::30) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO6PR10MB5588:EE_
X-MS-Office365-Filtering-Correlation-Id: 22412cc6-7f53-42a0-7db9-08dc854d03c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?ZzlwWitUZVRhNlRjVXg0L2w1RGNSNDFjTTBnbnZVb3VZc0NSSWNYcmlMajNo?=
 =?utf-8?B?NXJmbDJOK3BWenBHM1BpQjdZZWlrOW95UXFXcDBiMys2OTRjNGpsMEsxUU5P?=
 =?utf-8?B?ZDNtdWw2NnBTa2l5dzMxWEN3N3N5ajhWdTd6ZGhxTTBHRUc4Y2h3K2lDanFp?=
 =?utf-8?B?SVNHWHFscTJQbGlHdVBkNU9nTnc5bkJHTzZkQWk4N0JtYjVQTzcvejNIOVpv?=
 =?utf-8?B?UUY0aVNKMDI0QmtYT2E1MTY0YXpHcXA0eFZ2UFN3WlVzU0dxMHpaWTNJYmQy?=
 =?utf-8?B?bnlxSVlDM3B6NjFlVXNaTnE0L3l2bi9vZXRjdWpndDFuY3FYaWJVdDA2S05R?=
 =?utf-8?B?ZnpoZGdRbjF1WUZiLzFPRWlhNzdYSVdYS0x6TERXUFpjRjVqWUYrakFpVmd3?=
 =?utf-8?B?SlYrck42MmthUVVhZGNjY0pkcFpBTWRUMnV3NytVYWdZKzNaR3JHdlUzWDJT?=
 =?utf-8?B?eVhjU1ljalNPZXRsY3I5S3hJZWZjSGwzOENveC91YkllbkZXTjVVNjBlWmhR?=
 =?utf-8?B?SUpoQVVKMkNqYis5bXpQSUVKa2UrUW1DM0ZTSEs0YmM1eEV1MEhLeTEzM2VO?=
 =?utf-8?B?N1B1azlRZ3NReU5wdlM0c2tPL1RySUszUG1ieUNPeXVQU0J2ZnRlRUdObXph?=
 =?utf-8?B?WFVacCtjcTJKZTFnNUVWdytLTGpKUDcvN28rU2kyVWQ0L0pYdHBaUHFNa0NZ?=
 =?utf-8?B?bWRWVklSL3lmT1VtTEdvMi9KWmVRcW5BeVpXNTFOU1ZBanVRYkx5OStsNldW?=
 =?utf-8?B?UzhvNWplbVl4V1NVRFdiekM3RTVMbXo0VWFIdWNzeHpyNjlod2o1WVE1bzJx?=
 =?utf-8?B?aWNmWG5LV3F6VWpYdFZSb050emRUSVJhT1M1ajRSMERYVk8xSUp2N3lnTDQ5?=
 =?utf-8?B?elFDSHowUUNlKzdlcHFDMXVWa2gwZWxNMlJjWkppL0lCZ2JnTnNtZDFmR0ht?=
 =?utf-8?B?TlRSSVdtRFJROU1KK3JGVU9UV2FtZlk3U084a2xRbFQ5Vm9PVGRMRjFreTB5?=
 =?utf-8?B?bVFxczFNd1FVcWIreXhYNUROL0gvVTFrb2NCT0RIeXpZcGduc3h6alhFYk4w?=
 =?utf-8?B?UVlrd1JVYjd1QmF3UDgxUnFheEZCa2MyNStqQ1k1bG5NZ0tuRnU5cUswV1Z3?=
 =?utf-8?B?a2k4ejE5ZmJRL09Ib3d2SDcvQ3lKN29JbTRKNENBR0RLMVUwNDNGaUVEaklD?=
 =?utf-8?B?NWkrZEFMa1NpdmtYL0F3U1ZMZlR0SGVIWkZQSVY2eFQrZ3JaRFc3MDc2MC9w?=
 =?utf-8?B?bEJOZVVZVjd5OTJRQ3RFUEVmdk50TTliYkQxV2JRMG16RFVjaUdKYS9rbXVI?=
 =?utf-8?B?RnhvU0lnOGFuaXpvcjdBQWdLMnRkRjhOVmJhTmRWNXJBbk4zLzBtMWNmbmdv?=
 =?utf-8?B?Qk43bm5WOE51T2YyU1htOWpMSkh5djV0b3ZwakJaKyt6c2Y4dmU3M3J3NTZ0?=
 =?utf-8?B?ZVNCeGFpNUJPM0x0MkxzZjJnR0VLQ1Q5TGlSb3VYUWl3d1FYQUZaMDlxaWhK?=
 =?utf-8?B?UXhiMk1lNVZPeXdRU240L01KMDhzUGFVVDhtNWRTaFkrbHVrL2liTzZhSVI3?=
 =?utf-8?B?OUI3bEY4azJxdklwcHZlTzJKR3QvZVAxNnBPL3NRamhBbDJ4Z21UU2RVSkRH?=
 =?utf-8?B?TGI3V01Lb2h4TVNlaTBnWllTRVh5ZUNNOVhSeC9DYjF3OVB3cStncm1vUzdy?=
 =?utf-8?B?bk5Gdmc5b2V6dlo5QmhmanZqOU9sZjZLMjRxRjd3UGJObkV5Zk50L3VRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?T0JvcHNSRmdGTTVEd1k3eDNPanlYOERmL29LR3ZEN256c0Q2K0JUY2RySUFI?=
 =?utf-8?B?MUNWUVdCc1prVlBGSzZqR2p3S01IaVhxRjVicVpIdW9JRVhqN1F3VW5Yb0ZB?=
 =?utf-8?B?UjNUQmVodDRJOWJLRERVNnpnWFMyNzZQQW4ya0FvSzlaWnA3VEpIaWZMc3VC?=
 =?utf-8?B?V3BLdW45YWpmZEdxMytpcjFRZFVyZFpMNjVOR3JLa0J0L0JZT3k2VjBvVHZ2?=
 =?utf-8?B?VWNSU09xK1A4eWZKZjhxYzdSZVMvR0VxeWFBeDF3WGkybTBFZGJmRUJVRFpl?=
 =?utf-8?B?RndTOVhSNlNuWFJWZmpLdklHSnFESEFnQ1hXamt0ZXBsUG1IQXMySVk2VFRE?=
 =?utf-8?B?NllxZXlid2tiL3RSdUk2Z2lzL2Z2ZUFsYW9UUnd0U3hEQmFBcS9aMDBLdHlO?=
 =?utf-8?B?a0lyRk1uSStTeXFEcXNja1BRRGx2OWtjYnVNcmZCZzFYNlRoMzk4V0lRRFhY?=
 =?utf-8?B?M0hORkNHUS9Iek1TTmlnZFJiVmtGeVc2VU9PSExndHRqT0x5VENFaE9MWkdN?=
 =?utf-8?B?djc2TUxuZFlpOUMwNGx3Q3FxdGhTNmdEN3MwT2dsZFJFZm45bThLbVpNSHFI?=
 =?utf-8?B?UEdIUCtseE9DNmp6MzErc2V4K3M3dDJaeEl1OVlUaUR2c2NURkgrcTZqeFN6?=
 =?utf-8?B?ZGlKMktxdGFTUEdmVjBUNEJRSGdpa3BDTEZMTWdzRGxES1BMLzVKTHVBWGY0?=
 =?utf-8?B?QmJOUWwyRTBIdkJ0OGRIRW9MOWM4RWJvL3NTNmpiZUg1Unlsc1pEZXJOU0Zq?=
 =?utf-8?B?Um9JOElWZW55eDFRaDlTbkZQWWhQRWp0ZUdRL1c5SGNTQXRXTlJQRHlQWjkv?=
 =?utf-8?B?WU1rcVQ0a1FYZWUrTVM0M0tnNWJibUI5ZDdRVVk1c2pQbzJmV2J2WEcvUGJ2?=
 =?utf-8?B?TmJPSGQwU1BaQWRRWVFjN0JPelpLZWszUUhHbSs5ZnJBUXNkVVNkVWRKQVUz?=
 =?utf-8?B?K2h6VzZkNkduektCSSsvdzlqQ2hZOFlTUXorVXVraTUyczBocnMwbWtPYmFq?=
 =?utf-8?B?aExjYTlETll6bnVJWms1RGZ4V2QxWXZId1gvQnRiaElIUEQ4MFFBN3NyUzJB?=
 =?utf-8?B?bEx4UnZHZ2V2aUQ3OFJoUm1WUGdheTU0OEdkOFFWV2RBZDYvalZSZkdYSmFC?=
 =?utf-8?B?U1ZVYW1WS2pJYTdvcTFPY1JzNEZPRUtWNzMzekx0L21ROHVYVzFCclN5bGs3?=
 =?utf-8?B?Rk5pRUU3VFJuRVJUV0c1cHQyR1RhNGlZQ1ZxbFQ5YW5xOGJPcXFndXI3d3lQ?=
 =?utf-8?B?QUtxM1JwVkZqczdzSHRCMnorTlM5WS9TSWlNQU4vTHdhL2hYa2N1K2pzTWEy?=
 =?utf-8?B?ZXJRSHFSSU9udk1hMlRQNnVRY3hMVi82Y2RCQ1Q2bjVFUWpwZHpMVVJZNGhE?=
 =?utf-8?B?YkNuVE11UC9IcGpXa20xR0IyS21XRi85c3pNQ282MFRjNXIzbWNIQ01jVUFm?=
 =?utf-8?B?TlFTQWhPZXY4UGJ3Umo2ajBJcTZEWmtUejJDU2paZXBMZFBDVlk4YjcrWmpE?=
 =?utf-8?B?ZFk5TDRHQUVmL0V6cC93WkgvMWhBdEdWeEVRTEVjRUQrb0FvWWl5L05sQWF0?=
 =?utf-8?B?TE1Sblp1WDZOR2E2RFI0THhqbDdoNjN5OUF0RnJLbnlqOUUwR3grRGlqeUs4?=
 =?utf-8?B?eDZDK0doeDNtYmdwNUdDWStKL1FUa2JjWU95ek5YcjNZT2V3MVhsVmdHcmhP?=
 =?utf-8?B?Ty9mRVN4K1UyL1E5QUM0MlYyaXN3cGxmZGN2MVZUTHZoK1hTc2wyVXNzeEhF?=
 =?utf-8?B?b3dzMGV3eTJuZDRZVWlOS0tUdEI4eXBDSjhaUlI1bG5paVNPSDMzYkpCQWti?=
 =?utf-8?B?UXczWmtFNGJMNTFXbm1yZTZZandBaWJmcEEyZTZjY2EwMXc4WXhTd3VVdXpL?=
 =?utf-8?B?NVM0TlZIQ3BDM2RMeEtibVo4K0xtSm0yR1dyRU9pVFhWcTJyQlRINFRBWk5l?=
 =?utf-8?B?NTZRSWJseG4wazNRTnM5YW91UVdaOExpOUZCbjdTVmNBa2xxSzhHd3E1Y080?=
 =?utf-8?B?VmRSTHBseVBJNUpjTVRMYlZsZkRIVzhFQmY2OGhkTklRNy9aM3JUaEJZTERE?=
 =?utf-8?B?TTJud0RlUjJ6MG8vWXQvRkwreHRDWnhmSTBobDZod2IwRzQ2ektuRTFzVU0w?=
 =?utf-8?Q?fixwQNZOo5xCLrv2mtSGAhDqi?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+FMWL/KL2W5g42Km6qq07o+CmYLVNUCfEN2sdwhFi0NWc3NOkotx8iWvVQX4FXQRjGXd4zYVNiB8uC2SFcRyCGs5bfh7YfgWcjjy+c0zmkg8jOk/lp7QFuRhanP5lz/bP/hmtSvZ8XNNwNA94SA6amkWBdKpSzZ/+pzy1E10A2mPpsahOiMEzOSqdaR83N0hdqn86rJN9IffNoD0cyIJReYKrWmjHT72J1BSUF+JTjbUeZnHau6u2iGJCQBJnoSap8k+z0IE1swNzkxTllhxeruuEPpj4umyKbRFPMOJ1iXO4CaU1ytsIWXVDCTPFjoiL9MD4x0C4IAbBMzV0X5jRr9g7vN/mbtxQJmV+e+DcOnJg8/I4ScxZzzwP9N/aWgUAqN2wHWj5jYJ+Ico9knGp6tucQrXaeCayAs4rBXam9iwdWoOFmEUC7rZ0eWbJpKXO5WPwORHWKzusNjp/Mefeu3/S/qFMduDSA7RQ71f/RN9EPU6irv7MoKbZKeBlZavTYjfFe5L+OocLnsHv3VdR/0URiWh5ECpvqhFIv2B+wkHlyFtxt0dlNwUCM3/96D8TthYs6F/I4u1tUeBA9Pm8VBDakr9X9px8aYBZrC7+Cw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22412cc6-7f53-42a0-7db9-08dc854d03c1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 10:48:20.4166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: njwe3Ncwk8Kez2PB19ivXii9k7qfm3AM9jrdO7C97vlyLj2lA49VK2NQjeqems0aPkEVkwNHUBIA9z++3hz+tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5588
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_01,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050082
X-Proofpoint-ORIG-GUID: -UKoY5DDp2HUTpdadm4Gp6fzutDOvd6D
X-Proofpoint-GUID: -UKoY5DDp2HUTpdadm4Gp6fzutDOvd6D

On 05/06/2024 09:30, Christoph Hellwig wrote:
> Highlevel question:  in a lot of the discussions we've used the
> term "untorn writes" instead, which feels better than atomic to
> me as atomic is a highly overloaded term.  Should we switch the
> naming to that?

I have no strong attachment to that name (atomic).

For both SCSI and NVMe, it's an "atomic" feature and I was basing the 
naming on that.

We could have RWF_NOTEARS or RWF_UNTEARABLE_WRITE or RWF_UNTEARABLE or 
RWF_UNTORN or similar. Any preference?

> 
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 0283cf366c2a..6cb67882bcfd 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -45,6 +45,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/maple_tree.h>
>>   #include <linux/rw_hint.h>
>> +#include <linux/uio.h>
> 
> fs.h is included almost everywhere, so if we can avoid pulling in
> even more dependencies that would be great.
> 
> It seems like it is pulled in just for this helper:

right

> 
>> +static inline
>> +bool generic_atomic_write_valid(loff_t pos, struct iov_iter *iter)
>> +{
>> +	size_t len = iov_iter_count(iter);
>> +
>> +	if (!iter_is_ubuf(iter))
>> +		return false;
>> +
>> +	if (!is_power_of_2(len))
>> +		return false;
>> +
>> +	if (!IS_ALIGNED(pos, len))
>> +		return false;
>> +
>> +	return true;
>> +}
> 
> should that just go to uio.h instead, or move out of line?

ok, I am not sure about moving to uio.h, but I'll try to do something 
about this issue

> 
> Also the return type formatting is wrong, the two normal styles are
> either:
> 
> static inline bool generic_atomic_write_valid(loff_t pos,
> 		struct iov_iter *iter)
> 
> or:
> 
> static inline bool
> generic_atomic_write_valid(loff_t pos, struct iov_iter *iter)
> 
> (and while I'm at nitpicking, passing the pos before the iter
> feels weird)

generally pos is first and then len (which iter provides) when a 
function accepts position and length, but then iter is the "larger" arg, 
and normally they go first. Anyway I don't mind changing that as you 
suggest.

> 
> Last but not least: if READ/WRITE is passed to kiocb_set_rw_flags,
> it should probably set IOCB_WRITE as well?  That might be a worthwile
> prep patch on it's own.

For io_uring/rw.c, we have io_write() -> io_rw_init_file(..., WRITE), 
and then later we set IOCB_WRITE, so would be neat to use there. But 
then do_iter_readv_writev() does not set IOCB_WRITE - I can't imagine 
that setting IOCB_WRITE would do any harm there. I see a similar change 
in 
https://lore.kernel.org/linux-fsdevel/167391048988.2311931.1567396746365286847.stgit@warthog.procyon.org.uk/

AFAICS, setting IOCB_WRITE is quite inconsistent. From browsing through 
fsdevel on lore, there was some history in trying to use IOCB_WRITE 
always instead of iov_iter direction. Any idea what happened to that?

I'm just getting the feeling that setting IOCB_WRITE in 
kiocb_set_rw_flags() is a small part - and maybe counter productive - of 
a larger job of fixing IOCB_WRITE usage.

Thanks,
John

