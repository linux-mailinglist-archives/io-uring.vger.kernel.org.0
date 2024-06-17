Return-Path: <io-uring+bounces-2240-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1348890B99C
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 20:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BA67B2B95F
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 18:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AED61990A9;
	Mon, 17 Jun 2024 18:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YP1UsHGH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r99EoAwH"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37465198E93;
	Mon, 17 Jun 2024 18:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718647537; cv=fail; b=NlP4odKCPVhZ7O6RWyk3iaQz4Vw8v3toAA08Em8EVCN1jNh+qxAizlcSaDDrIBIs3cpAZtY94RCh2Y5MIPqiOa+kgYbybqUL83rGM5E8ATpVQOCJC5ULwqBzYTmvmHPsP+KvwxjJa/gtLKR1bDmCxA15vmcgH42tQNHdb/ujRIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718647537; c=relaxed/simple;
	bh=UzYuO3GCA0rEEaFnAlCtrKnmxMBearYMRfOnBN5Ht4A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LiPXW/546WFSjL6hBwmVVYOOqr9ZEjTvbS0zc/s/P0r4iKLHxUjMjZ2SQf7G5sdst9rkPoagy4j/U+7mcut6c66M0zlT5JbtMVPzDfJK3sqifEeFvNFzmgl/wC/v4PaZH/e4epiRgLgl9qMwLdHPaHi7BUry986RNkQ6xCaPfco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YP1UsHGH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r99EoAwH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45HEBOto023399;
	Mon, 17 Jun 2024 18:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=maVmcVAJd/X9EHHKMy3mSjdUgbQWCEPiT5Ys/lJNjfk=; b=
	YP1UsHGHe54UrJrnFo60aqol+Q34lWwZxD4zF5c4OISX2oufgsIdShKzBGc3BQGI
	5RYf+7O6lOP+szdluiekZBore+sBuJYon9IkcfrhA6SHTgEh++m0hcYQ1wnBdgaq
	lvqpmeekEtHA0s9H6C5RrkvDZrNYNMo9sYnQII2XLHMMi0VZA9h2gDV8XiNH0W7F
	9RO8pUSYoBBx8XcC6lmSCjaxNKky4NbHoCcl+JpOxsyCk4slRrxnZ4YlMjnnCDMt
	JQJmI7hGGaSK+X3krTiHEEvRUv/CXcfmGcWwni5ABQjT5D4KgqHwJEhdC5hFfF2k
	3T40CPqPL8elbZT2sfK2BQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys1r1uax3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 18:04:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45HHCWMX034524;
	Mon, 17 Jun 2024 18:04:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dda85s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Jun 2024 18:04:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqVD4ub0pTvPB1UjJJotfxYZJCccz+iQZfcBLHmmNXcZjjQI4wrGkZhPbctJ6yNSoedoQPsD8QZeMZOy6BrnRPK6fteOS6Vzs/9NzkGaU/oK8H+xvKkVKX5yY3xS0vKrTM2p8kYp/cfWebBTX5YffMJTnyJTKj5sYu+62aVxtNVZajB6psAArE5sG7y5WTUtsTmV3/CD341Jqw8/1rKoyxqP6oD5SWqMFNJcArnG87MV+CUTZ4qIBEL0isX9y0H9Td+sPYuTKI2bCv83teROaiQtlb4Lv8LGem+um/steSQP2h62yTD03gji0omUFezt9kyLBTCwKgvirpdxAgJmiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maVmcVAJd/X9EHHKMy3mSjdUgbQWCEPiT5Ys/lJNjfk=;
 b=C1NJWJM2Wtwq5iyQ5cz1DloUHnB/9ypouovDUzY+3ZKbzFJb74IAkv8+K0ovnLURd6PhfcikBESeaQ7qOgr6NJKSXaauYZuFNJx94kIE2nCOeBKD//zUFZAWLOB3+4dp4/yUWKc9HxNnloiatt6I21lj7OflmSCflkWPzm9S7ZC4HulLyCa0CAAcU7042nTfdux+TbBknAk4QfuqD981k5KFPIzJ1nFrnTT4+5W0u0THF7edpF3RBeCmAALVYQTyPdY3DX856Iylaxs2sz9w7b9NuUPTGVp3l8sJ+4OUGWHa+QPI3lS9zCTXkWXcJdj6LujnGWQyt+meIX+rliDFwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maVmcVAJd/X9EHHKMy3mSjdUgbQWCEPiT5Ys/lJNjfk=;
 b=r99EoAwHXZYJ+BxnEtYznQQCXzBYeqJKua2lAXpwGE0VQK4tXNoZktRov0NQ+KC9wpeX9D6SskkA4PWvlDto8IL15q19LQhUVZQ4EktbJJMvWt97PESWdhCFbS0UI4jxVanbgoUkOUVKAxY6+G/viNuzG5E2SWiMz3WctYTgLSY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4567.namprd10.prod.outlook.com (2603:10b6:510:33::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 18:04:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 18:04:31 +0000
Message-ID: <2ddb92d2-97e8-4eb3-9c76-8c5438bb2a44@oracle.com>
Date: Mon, 17 Jun 2024 19:04:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/10] nvme: Atomic write support
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        Alan Adamson <alan.adamson@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
 <CGME20240610162108epcas5p27ec7c4797da691f5874208bfcfa7c3e3@epcas5p2.samsung.com>
 <20240610104329.3555488-11-john.g.garry@oracle.com>
 <faaa5c15-a80d-339a-d9dd-2dd05fb26621@samsung.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <faaa5c15-a80d-339a-d9dd-2dd05fb26621@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0188.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4567:EE_
X-MS-Office365-Filtering-Correlation-Id: 429700a7-1910-4672-ff00-08dc8ef7efc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|7416011|376011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?M0hQWXNHUlhGUWJtR0hpamxXa1dPZTBNQ2p3V2p4VUUrQTU2NjkvVVFtNllM?=
 =?utf-8?B?Q3EzT1VISlRLOVVOV0FnZ0k4bFd6M1dCWkRTYjdjQ3BiOHBIYmZJazh1ZnJz?=
 =?utf-8?B?VG1WeXpkcE9FczRjT010OFFpMEJGcTlBRHNSZTV4MGQxT0VpNDlYUmFTMGFk?=
 =?utf-8?B?ZUtQc1RQU0cxSjFSZjR1OGhFTXFIWUlyZ3VVUkFZTXVlRG9KZFltTVVoWUJI?=
 =?utf-8?B?bHFBWjJlRGova2p5TnFaQllvVXlpQm1nMFYya05aV0xyV0l2bXFVRFJmNGlm?=
 =?utf-8?B?a3lIbUc4Y3owd1liQWRNYlVYa3R6akJCNUYxQWprT1BvbVZicmhoWlptZmd5?=
 =?utf-8?B?UytxNEJPNEtFV3l5dWEvMW9QQjM2Uzd1ZGZTQVJGRE9KQ0tKQVo0T2VNQnBU?=
 =?utf-8?B?Wk5Tc0QxVWE0MUxYN0l5bCtzYU1zUUIxL0o2VkxldTJGdXhzRGx2dGE4RVlw?=
 =?utf-8?B?N1JJek1ZYkxrc29wTUZ1SUgrT2I2U1JpQi9HNmlnQ2poVVFkeC85RVBZdmE5?=
 =?utf-8?B?WTZJUXJnN3p3VWpJQytpY3NqTGlYejJqWHcyUnorY2hIa25SSnduUGNRSCtG?=
 =?utf-8?B?amh6T2E0OVYyb2Jha0NUK3JHT3Z1WkNOS3lxTnE0cHpKeDZ1WEo0QmM2MmQy?=
 =?utf-8?B?NVFzdXBNYXhUckRHZmQyQXVGVDZIbW44T2V1SThKeXdEWFZnYU5vVEZad2hH?=
 =?utf-8?B?VFF6a0IweVh5OGo2aGJmek5SZjJpa1psWElZVVpwVFdxRGJSQlRrMWl1eTBX?=
 =?utf-8?B?a2lRMzNqRzBBRi9VVVpQSkdWZVV4bGlCNFJkVWZLQmUveEVKZFZ6cVRVY0Vp?=
 =?utf-8?B?VEtCb2h4VlZxdW5LQ1RvcXZUcFJDbHE3YWQ3WE9YN21ma3dPZDk4c0I2U25F?=
 =?utf-8?B?MmlTN1UwOFgzNFlnRi9qWDNxbzJrd3FJSDJicmxpT2hMK0tJejcva3prb3pp?=
 =?utf-8?B?bFBUUVF5MEVXWUpSandpLzhjdWFHa29TaGpzeTd2MitObVdReDhQTHliMzV6?=
 =?utf-8?B?WmRzcUVORVd3SSs4RjFpb1oxRlI5Lytka3NIMmxYRXJ2dll2dlR2Wm1sT3Rz?=
 =?utf-8?B?amhlZHpkTnFrVGdHRlNZck1adHBvbVNNRnlDNjB6N2E4NVVwWVVMdTIvQTAw?=
 =?utf-8?B?MmFFMVVLekpXSUdmUHZNUGhZbzIrNU8wYWZGQUtieFdIUEUwNlhHd3FJd0FI?=
 =?utf-8?B?c1l2VmFsYXRtQVZnTVBaVEM5bkpZZXI4TDZmSmhEQ2pTQjBQN2tHLzIxSmZT?=
 =?utf-8?B?eDZwbER1QmFuNTNuc0NhK040UVNuUG42YVp6VnNSdk0vSG5mWDlmLzRtVUw2?=
 =?utf-8?B?b0YyY3NzV3Zpd2xTaVBuY242QmFjR29GT0dwdUxyMjNvVDBMN2hTS3FVemdJ?=
 =?utf-8?B?K01FVklTYm5SQ2RYeFlZMUZPRkg1WExBV0hvNXlaOE5qazJRVmtiREkzWmZ3?=
 =?utf-8?B?cGgyTFBVRVV2NEdXbmI3U3ZuelIwSEM0RkFEQzhRdDJNT0VPVkVUNEk3UzNH?=
 =?utf-8?B?bGNpT2hCcjF6TVdSK0I2ek4rMmJDNkdaT0dhcCs5L2xBUjFLL2x5ZmV0anBs?=
 =?utf-8?B?TXIyRER2SFdOV1hHZW5XM1BqSE9kLzQ5dTJOcUt1QlZXc2Y2bys2TnQzVHM0?=
 =?utf-8?B?dHkyS1dkb0MxdTFDdWYza1ZkTkZTQXV2Qys2NFMxdHRNbnVEVUtEd3g1VHc0?=
 =?utf-8?B?TmI4UDJXV2x5TXBFRmtFdk14bG0wZ0hXQmloRDBRQnh3ZXFPTmFycnA4b01Z?=
 =?utf-8?B?RXZwc1hTZFJzM2VtV0M4NHZFWW81WEdzTzFoNElEWWovU0Q5cCt0eUd2R0Jh?=
 =?utf-8?Q?TkExz55a/4JSmR6Fxa/ZlVukRRVezphQ1CR9Y=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(376011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZnAvSUxFOXllUWdYaUh4bDVzd2p4a0RVUnppelJmZElHY09pVHVzblZ6Zk9j?=
 =?utf-8?B?TU9jTzRBQStFTjBwOXN1MWtkMDlZTmxLeEpVQU5SbUxBRlA0bHpYQm5FcEJn?=
 =?utf-8?B?cGdwVnpRODQ3cmRiRWRqNXpoV1RrTXBPOGlVV1ljdnZJejZPd2lZMHo0OHhN?=
 =?utf-8?B?MytHVVZRbEJFdlVFY2RkS3Z6Y2RtUUJIeUR2R1NOaXBlOUtXZVVGT21sdTZv?=
 =?utf-8?B?SUVRaTNtQXl1RGFEcHlOS0hTbEkvWmVRQWFOY3pxUTYrUHQwcUdoWlVZYnRv?=
 =?utf-8?B?RVVGQmRrZTdOYTdDM3hUSTBxNEtZUy9jT2t0dUlvbTh2eHJEMzQ1Y0tVWW1n?=
 =?utf-8?B?M2NnbGdEUUVIVkZzU3R3S0pVblNFbGpZbE5FTWVTNEFkWFlEMEFmeENpb2JH?=
 =?utf-8?B?elIwS0c0WmhpNU5oY3YwTy9FaU8wcTZOTVpleTF0NmlHdGJyTlRLOFBLTmFQ?=
 =?utf-8?B?L3dlZURMam5Xb3Iwa3EzaEdqbStYZVBqWkhvSVJpc3ozeUVxZmxEWFlVM2dy?=
 =?utf-8?B?eFp5T094eUxIUHFFR1A3bEs4TkpYSHBEamJIcWRjT2ltQmNEMkVXSG04dm5s?=
 =?utf-8?B?UWNhOSs1ZE9zM1FISlpyK3VzazlpYzk3M0dzYjc2ZFlEdEdPTjhXQXZXbUp3?=
 =?utf-8?B?UU4rMU01eXFNa2Z2dXRKbkxoZHEwVXdGRCtJSG5qb0RRTjB6Nml3aWIzbVRa?=
 =?utf-8?B?SG5ZcDJzUGErbEd0ajQ0cjhMK2VzVjRDS3I0d1YyRVVza1l1bzZOQXpzckNa?=
 =?utf-8?B?RnczSzg5OU5jMWFuR1luM25yM3pqaGdRcFo3WHRDYnpxWGg2QXpYemdRZ0NY?=
 =?utf-8?B?OU9uZVdyTU5WVng4MkdHdzgyYzhQdGllb0hyWTJKQTVDRmVLR3pNWlNVMDdI?=
 =?utf-8?B?d1hUY0Vna0FVUE5wcHAxOHIyQ016Rlk2UDZnK1doMmlQMWkvenhmc2hsOHB1?=
 =?utf-8?B?TE03cDFadFpTMUlGWE5mVCtCT3lPdHVJMTRTOWdMbnh4VDJDZVdpWVFzcEY2?=
 =?utf-8?B?TGRmc0RlK0ZjOEZvb05IaUMrMXJ5TVVmU0NxZThjR1J0SmtocGphN1ZrN1U2?=
 =?utf-8?B?eDdUdGNrdzN5bysyV3pRSXowZlZkeE9UT0xqeHJBaFlGWXJTY1R5dGlGUWVE?=
 =?utf-8?B?TzdYQTByV3FaWFVJZWR2TmtwWDl5RGtXbkRncjNOV0Q4M01oRC8xUGlwak12?=
 =?utf-8?B?dXdveWRtSjBoZW83OUJpVUNXNytPaTI0WFIwZ1dBemJUYit0bUR3TkptVmVP?=
 =?utf-8?B?ZEFaR21YNmovc3BhNWk2MGtHU2ZGRUhvTU43TzN4ZkZ1YU5INDRhcG4zRmxy?=
 =?utf-8?B?QXkxSzZtWk00dmNrbTM5U2VzaG5MT1FKaTdLZDgrRWI0NUgwSmYrNUxOT1BJ?=
 =?utf-8?B?MHZuRjN2Y2FLQmczRWN6dC8zZURpZ1JZUk93dzRGYVhLeWpMc3Q5eHllOXFn?=
 =?utf-8?B?VTlneWlHdmhLMWYvS0NsK3lHdGNUcERZVkl3VTJJMTNwenlpTm5xNHR5Ky8v?=
 =?utf-8?B?djBoWnd2MFdkb1ZlbFVoOHpkYldZS3pENWcyTE00ejlQQ2g3Vlk3eWlvdUlV?=
 =?utf-8?B?c0xEMkdTU2Q0Y05DUUV1N0ZHV3FGbmh6eURXWmRCNU9qRmc0NnJzdjV5T25i?=
 =?utf-8?B?eUVwVjBCNVRBeWdYRmFJdHpvVkVteGN2eGtvYkZwVDJMTkpYZEo1S1ZTdkxB?=
 =?utf-8?B?aVFPQmsrbjV2Tmtqc1JHcy8xZXFyMDd0V0srVHlUU1ZVbGp3Qk9MdDlGb1hU?=
 =?utf-8?B?cUo0Wjh1VDJVajRzYlNZOEpHeHZZbmhGTzAwMExNdDhzM1pRdVRUZTVVT0l6?=
 =?utf-8?B?MXpCOFpSS2RNcDh3RDlYS1dpc1o1aWd3K3BwcThzYjIrWkVhMEhaZTNVU3h2?=
 =?utf-8?B?NVg4ZWowNk81c0Frc1ZQblBLMnlzcEJ3TnBqR0pZc2xHcDVLNmoxYVNSaEtK?=
 =?utf-8?B?aHhEV0NPVVdCM1hQZkM3MTZYWHgxZHlJWUF0V2NGakxRbkEvMFZHREc3UGlP?=
 =?utf-8?B?T2VEQXVTMXhKZmVlSkJsU1gxWlJ5Y3phWHJHMzZZWFNHZE0zRU5UYzQ5L1Yy?=
 =?utf-8?B?Wkl3TmRPSjJXcWZEVmVjS25uaEpPVm1wOVVMRXJoVmF1N0lhekxhL2cyamdH?=
 =?utf-8?Q?952Q1QeGw1KONmXmeJYm4clFK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	fVd/IL9arGnFbzcwz9rhqbvuuWPQCFj2di3sDOqlPY0WUu2keDAcMYWxAaOGoLXz/ko8C18K4Y/XlL5GAVdiU+CspW1lItzNTkxc5mPJ00JZSHgwo2L8zg4YRQ521Avq7dToptF5rh/x9HVivyPDkQcGfx0jmKnf42lKwjZTMt9lEqul74dpPb7bHIl32JSaTp1i0D3M6svw3GuzNs0fLXwspb3QnVoNymeGVNoMaY9UbA5tqDYgj/lXyWjtGYSsiFLyBmrujT96b+rj/7suFybWFvqRbGYEyLgb6of/hzDpgNXIstJGkyA6rbSLpLV57XDaLkZrt6zKas7CAJx9Y/eu9W7Dh4thieD8gzFER+ez4Wn2uoZMpR0xbpMj9fJFr/1pkRpj/Ep1d+MPM3KpvQYoW71S7qsxfTEQD7Q6Ox7pbl4zfaFw2AaRQ7l/y2ibZ/LWsBO23F5MPJq6TbOumhBI+bCJF8xmp/Ex5KJxSyXiuc/Hn7tGwOu6pPk0Txcnc4XYcyEXCUa3wKe+lZQKlud0E/DeAJD8BdveDCfIM9fX2zdEor2Vki4FF7EFgVj9xYUkHZrqpiQk6/zGn5UmDS5k+mvV/ttmQNjFwiJ6qPc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429700a7-1910-4672-ff00-08dc8ef7efc0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2024 18:04:31.4318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HhXGvffDtLLthaikdQIqTIYaEwka2qzWFyUqptPBzRdfXISUYUXZS+NdWMxOYvVA31wGlRkIVodUlCPMQu0HIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-17_14,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406170140
X-Proofpoint-ORIG-GUID: lt8G-5CgJ-0ne0X4wy-1m63YZHyZki4l
X-Proofpoint-GUID: lt8G-5CgJ-0ne0X4wy-1m63YZHyZki4l

On 17/06/2024 18:24, Kanchan Joshi wrote:
> On 6/10/2024 4:13 PM, John Garry wrote:
>> +static bool nvme_valid_atomic_write(struct request *req)
>> +{
>> +	struct request_queue *q = req->q;
>> +	u32 boundary_bytes = queue_atomic_write_boundary_bytes(q);
>> +
>> +	if (blk_rq_bytes(req) > queue_atomic_write_unit_max_bytes(q))
>> +		return false;
>> +
>> +	if (boundary_bytes) {
>> +		u64 mask = boundary_bytes - 1, imask = ~mask;
>> +		u64 start = blk_rq_pos(req) << SECTOR_SHIFT;
>> +		u64 end = start + blk_rq_bytes(req) - 1;
>> +
>> +		/* If greater then must be crossing a boundary */
>> +		if (blk_rq_bytes(req) > boundary_bytes)
>> +			return false;
> 
> Nit: I'd cache blk_rq_bytes(req), since that is repeating and this
> function is called for each atomic IO.

blk_rq_bytes() is just a wrapper for rq->__data_len. I suppose that we 
could cache that value to stop re-reading that memory, but I would 
hope/expect that memory to be in the CPU cache anyway.

> 
>> +
>> +		if ((start & imask) != (end & imask))
>> +			return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>    static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
>>    		struct request *req, struct nvme_command *cmnd,
>>    		enum nvme_opcode op)
>> @@ -941,6 +965,12 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
>>    
>>    	if (req->cmd_flags & REQ_RAHEAD)
>>    		dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
>> +	/*
>> +	 * Ensure that nothing has been sent which cannot be executed
>> +	 * atomically.
>> +	 */
>> +	if (req->cmd_flags & REQ_ATOMIC && !nvme_valid_atomic_write(req))
>> +		return BLK_STS_INVAL;
>>    
> 
> Is this validity check specific to NVMe or should this be moved up to
> block layer as it also knows the limits?

Only NVMe supports an LBA space boundary, so that part is specific to NVMe.

Regardless, the block layer already should ensure that the atomic write 
length and boundary is respected. nvme_valid_atomic_write() is just an 
insurance policy against the block layer or some other component not 
doing its job.

For SCSI, the device would error - for example - if the atomic write 
length was larger than the device supported. NVMe silently just does not 
execute the write atomically in that scenario, which we must avoid.

Thanks,
John


