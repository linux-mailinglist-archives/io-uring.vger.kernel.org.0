Return-Path: <io-uring+bounces-720-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98FE5866E94
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 10:34:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB1BA1C2433E
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 09:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FA662A10;
	Mon, 26 Feb 2024 08:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HFzQ+vo0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hd5hXcXp"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928AF62A0A;
	Mon, 26 Feb 2024 08:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708937525; cv=fail; b=gxigLSjfpVePCmZwuyGMwyaqDVd5cBTDZ0U6yKxyWwVSAZnuXaAOZ3wbdtlXT9idmX8kfmy/KKQ+qpA0HFkT79CaLiKYIG4mJFaeyeWX38kdQqRiddo4x9R3+Fv0j/ibD1uaX3XC2SPGnNRA0UuhjRCQgpaiYgfoPRfiGU2T3Dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708937525; c=relaxed/simple;
	bh=+8iRRppeQdRmrzAEkND7t1Plpj2D7WB+kxyPcSuSUY0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tt3nt3IeM3rg4IvR8KEvz+gmbVXYtL7lpZ4TfRYdHz7MG+WCc/CsblpcN6GKvOOxeVQ6NfiObRlc75dgV0ztWfc4aAKvLDWoWAW0UVWUoKXE2RnLNBu3hQ2UDjS8ckgrv7ksab+MKp2DRN5Qkkf6SxolSIHU4cAYpJfOQBn/of0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HFzQ+vo0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hd5hXcXp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41PJkxMN009672;
	Mon, 26 Feb 2024 08:51:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=EELkXRXz2jrDzALObEJ8DnMDzP7IS0xEK0dxxaEWeH8=;
 b=HFzQ+vo0UqTLF/7mLy28+6lxEKAS2HEosB5MRL7hJq3eouGKWj6VICRCacXVanvTjQDO
 uMFAhmu2SVWk9ZcVL3r9tdVISzoS7U4ZDbB0rlbB8iiagVyxqy8GIx8JQEsqzCqWJVTd
 6Ttb1xIbkMuTbdvahDSLBkCIAdYCC3YqjqLwR1HUJHafOY0CInWrh865Z0BCkcxds2xR
 3P08e3h3w6AvnJRc35X/WHBTCsbQ6Y+O8GVzjw3Lh62Nii9W1LT5N9noltBcyEM9SdMO
 enc6A3rcRieJbWeT/Zo8Tedt9jgMcJbWQDG2J4sInanifeFeN5X50tksAhr2K0fVNZfK sA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf722byrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 08:51:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q8FdK1012671;
	Mon, 26 Feb 2024 08:51:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w580fh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 08:51:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcCyiHfhvXiV+670qGFxvA3MWRhai40w+OBC5uMDJURqglbpF/3gZ4D5K9xfUwMn//0mp2tPfSo0GGUlVEUh32ORgfTU0xlKVdQqZ3Jx4T/1e8DQ9ktaYIu7Cm3ZDLs6oBVY/Shw4/pYJf77DOlhVTeGO4tYui0ToYf4u9sWVqPBc81E2D3ox7TRdGITcHEWqUyVA0mJletZm1N5r2y1YgK7rlOwUKTTesStyz/6phc+xYkbo/Qyq5nlewaFW7ZLM3gOthanH3hVon5iqqHmsF/qWot3at0Mrnbeovl0zudvdfGnXxm6/hSJBsWO1osDdAZELk4+TSCSQvhVEyJqxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EELkXRXz2jrDzALObEJ8DnMDzP7IS0xEK0dxxaEWeH8=;
 b=IhmQ54jAaYunTsqxv2XuzC7E6bUytA180c4tIVWzP+yZ1WO6yNWYUPu2ufnGhk46xq/NuEqDcMoaHsAsqRd0DI2zFgKH8VkrgFcM76Yg3nEQIr0+Fm8MdF0su2RnHvrBg2/8liidtUUZVK4DSvwyQEMWJ1CYfmkEeeiN42eMAMhjSOerFtSD5v4NWeljOtXzc8pLf/N9imano0HtwxAXFk0FSdCBsEjWGWuBtYpzjYlGZOkkz61nZwAgOTj6ur+3wtKVfcxgwkHBB4psnYJN7FTrKmDeufXAnhlYM0g17Uv9LyJt6AUJbOSHcP3F++de6BKbEY1iOvcWBa9NXOTCNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EELkXRXz2jrDzALObEJ8DnMDzP7IS0xEK0dxxaEWeH8=;
 b=hd5hXcXpx4PbJzCmLW9m4A7nU7jcephYRXoINz3/MmfdRIGDDq96mH013S2mDUIwwAV/4Hie/zEhTnF8YWSGnvNjqoT9Cb/2iw6JlGT6SKa7Gy0oqYXQeBdHO3sfNhgoflN+ztzjw8lB5usTIvhXTM9APAV4dIXm80u+qPUWmu4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA0PR10MB6428.namprd10.prod.outlook.com (2603:10b6:806:2c0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 08:51:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 08:51:23 +0000
Message-ID: <416e3bea-9a1f-46ac-8bd9-4455358e1d9e@oracle.com>
Date: Mon, 26 Feb 2024 08:51:18 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/11] fs: Initial atomic write support
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
References: <87v86d20ek.fsf@doe.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <87v86d20ek.fsf@doe.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0062.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::26) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA0PR10MB6428:EE_
X-MS-Office365-Filtering-Correlation-Id: 833418cc-ce51-4f09-e61c-08dc36a81c0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	h0DfQQMDd1NlWspif+UhfxeV8wUa9DVj5xwiJnrkAbQzeg/CBfkxBjFS3mUzJtTz5mM0oXJl7ohR/ya6bx6qw8HMS56pIquJkTMUWLDrv7tfFJy8x+Ct7Bhp+Zq8ahC9082BMwO9NVcsAaarDhb1BwDiSzypT/1kjOXDzRvZyuJxtuQ++JBCzJbyPKj0zP1JP7khtaD377LbCW3gDndQtg7jNiWw2e4FCw8WRYqYguTroaWHftDPS1mShMqBufxwtQ7WEq5KEpU9NQWvLee6J3Lbb0HtTmS6KQgp1qWO7oc97yCQjDtnTaa95CrdmHf+Z7aK4WmXZm8+BG/3uhkxKbpCKsEAXQMwnAVAp6ha9SIVrpcDTIv+5eDZZPPb15rqV/wzcJgVrhlpXRs5NE0Hm8463hkW/u6oSfFWHP2r0mfSppLSDSOSuxhQ4PNDAwaHZxQOkJfpcgsubRBHU91kYj/zrLQkgBTWtxiOVqCPDpYWX87OLWBm4bAfoyWg3z1Rd1T2a0b7WzLH1eyfNtvCefAg3RwL8q1dkrZXIMXY4KbXxFEo9IyBhXY1B44pFtDlZAw91f/YdGE0gzqvZWlxHbftuA+4Wh1RAgtbkdCj2v1rW1aWW989LG6lty+i8FYRWBKi7/3Ut2D+IB7z8V7SST+LUDcx3Qf+Ki5UtJp4N14Iw6BmVGkdHNOfDifKLxWVmuI+oJ1+u8gimSZq6G6D3g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aUFxdXRGVmpncW1zeTNUOS9FVVFPa3YvVE9PM1VoR3hVcjZpS2QyNnREYVBI?=
 =?utf-8?B?WEtUQlZnUzh1blZQYnhlUjliOE8xQkE4cUJ3MWFNQlpISWlnbStrNlQ3cXlS?=
 =?utf-8?B?OFVSYkNCTVRIcG02UlkybFpQOVNwWkxBSFhvR1pSdmtpdVAvdHFuT2FzVGF2?=
 =?utf-8?B?U0F0WUUwdDNpMlJwMnRKT0N0cHNwUnYrNUJrK2Q3MU1hUjQ3eHhKWmhHTEhq?=
 =?utf-8?B?Y0x0am1JSjZwMTZ5R1hFTjZKWm5VbjlwWndnK2xYUTlLQnRTaFM5djNDYjNH?=
 =?utf-8?B?SFRmRE9NMi9EdldIOGNQYkdwbEFzYjR3WG5Ibm5SdGkwUWxySmxtaEVNTUsy?=
 =?utf-8?B?M2dEWUJBNzBnOUpqVklOTTMzc2szempGeVFmUk04VzZhZExVVHUybm1HR3FH?=
 =?utf-8?B?RFJqYkIzdjlPUEZ0QkdmeFJrN3ZoUWVPWGJkRFFiR0tSVlUyZVpTTGloYjR3?=
 =?utf-8?B?bDhvcUt2VGx3S2NQNGZQY21oc01JbHozYmltQVh3VDFJYVpRblh3ZGZ6enBH?=
 =?utf-8?B?TVoxbmpHcWtWZHppVWdXQjZMdFJ4T3RTREFZcmFwS0ViZzc2YnZFN0dkU2NN?=
 =?utf-8?B?cjg2SFgwbTRyLy9aaDlzQTB0UWoxeGhuck9MQzdneTdrMm5vSUhsMG5uN2JD?=
 =?utf-8?B?TGFoTTk3ZjNoWUhOUm9jd3JMRzc1RWtsMmdQaUZlcnFubXNnWERsQzJkT3ZG?=
 =?utf-8?B?ZEdZUWkwMDZSL2JSK0gvUXdyN1QvWkdXZEVaVm5sU21YTUl4WHBpcEhsNnZT?=
 =?utf-8?B?OG1oZ2tDK1hvcWFYV2JEbnZnWUJyekg5elphYW5qNVYxVG5OaDVYejBCaUM4?=
 =?utf-8?B?Nm5POTlkVzErZXcyRWRxUHVGVXJkRnh0bXkwQXJhY20yNlg2elowNHFydEdF?=
 =?utf-8?B?NnAxR3ZmeHZrL25xLzBOZEFVMFFsU1hQWFhua0V0czB3VUZaL29Fam00VktL?=
 =?utf-8?B?Zm9OMjNTeW1JUHBzV3p5ZjhOQ2E3Ym9wQTlHQ1FvTzR0M25OSmFaWUVOM3Vy?=
 =?utf-8?B?NXhxa0cvenVRZXc1aWF2a3hnWmlTeUJORkV2blhJMXpmUXJma2d6bmVQaXZs?=
 =?utf-8?B?SzZUVGZscjFYMWpMZjdQdStGZG5LdTRnQ2orb0IvZDVBNmMwZHJHaWRWakNl?=
 =?utf-8?B?L2FPdlFMem1oZDAxbGMrWitxV2FlUFhuLzRTL1psZVpFR0JEc3owR25sZjd0?=
 =?utf-8?B?UVNzQ3UwcXpVYWNqVXl3djQ1Sk5nY2NGU0prbzZ0QVh6Q0Rab2hiSjQxNk5w?=
 =?utf-8?B?UDZ2aSt0UllZVC9wTEsvTi9zYkdKSVNOTDBxOUFDN2VKQkx5QVBQczkxR0Vo?=
 =?utf-8?B?ajcwQzU0WjBrNklCU3ZydHQ5NklaMnZqSnJ0S0JCZ2hlU3VWZjY4Q0M0Vmxm?=
 =?utf-8?B?WmpoRlJaMnk4TnY1OVhlL0lwa3g5TFkzYkFuVnFnVGtPNEkyaVFaODgrTktD?=
 =?utf-8?B?SndBQWdDbzBhM1RMdVcvbmVxYXRtbWtiLzE4WmltU0RPOTh5RnlwUkdpcXdW?=
 =?utf-8?B?aVNxYVpRUmFTNkdoZlpVM21uUFFta2lCZHRqcWFDZXhqMlE4OHhjNHEzcnVh?=
 =?utf-8?B?RlhSRWNBODF0R3JkVzBac2JCWGxWOW5BU1YxcUZxUUVDbEJ5aW9oeS8yNm9T?=
 =?utf-8?B?QWpUNFhENjlHZXhCKytrYU1RS0pNVGlKSDBadTdnaE92UzlUL0NOaGZTNU44?=
 =?utf-8?B?dUpxN0kxOWgyVnR1cEJIdGptL1drWEZJRWhHbkFuZGxSR0tSMHNONThZV0ZF?=
 =?utf-8?B?ZEs0dTE1elcxU1dIWlJHZllrK0xOUkRjR1RuczVScEZGSzRnckxNUkJUL0FR?=
 =?utf-8?B?RGtiLytlMjFWYTJ1cStMK0hsN2pTZ2xhRGwvMTJ2ckVNcFJ0RVpWaytBbTF0?=
 =?utf-8?B?TENUNFJJbzZVRjQ3MTVNTStCdXduOVdLeUhiZFBDajlZeXo4bXhFbEFSdCth?=
 =?utf-8?B?bldaOGFlR2ZoditGVTdjUk9NeGR3RTlwN2FydzBBNGRqQkpuM2NMZmc0S3E2?=
 =?utf-8?B?MENiUmtMcHI2emRyK1ZqUUJxZnZleUVybW9jbnB6QjJnOXd5VWl5VmhycEE3?=
 =?utf-8?B?K1lFR2J3RXBlTHZmNkJsUUVmbFpsYTRXd1E1cWZVbENFVGIvbUhWdDg0bUNK?=
 =?utf-8?B?VUR6dHNuY0FsRVlOaDR5WFFnTERQcExHYmxqVjhFenE5cFdVa1c5Z3kzdito?=
 =?utf-8?B?ZUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	A+R0DzQVQS8LcUiaPS9TPPbGq3obgTNwpdVcpDxX/7HTBDUsA/aNYWKGQ5fNggWyEADElq+vSFuuhDgJbiKQcLmWsSOveMZniLUo8AvuCQtMqv5qLmFrXb0/if9gb5Fsp+uJQ6nBAcM2SFYklnyaQR9bDG6FQffzSQpBvrGvGB5Om/xt4XxiBLbAqCfI8XqnWc+SxrOoFOJA21vIAQyr33SVUIyrpMDwBGjBfpRO5wD2uNx4YBqQZsxlLxMCIwlf7FWjs2SLsfNB19KZ1LBpmG4q2sjxD1cQf44XGQWroJHa7oM104qGnQFOm5ju0e2mGJaxDYhN1//2l+NFp14SUGpTZrY7W1CaiZb7QLy8Jx0+hW2q0Ly7NbJdqWpwW7codvwqUqsjnyKx6vzpApPSTbSK/eYUEt8Y0Fxwe0fxUWAzgyMYq8u7R6J+/PWYB37HHV2VpYv6P4Fd69+qbUyu+CrBaulx07pKBXum7Y/S7p2Pm9Irjq7Ls1DehJXHoun1I/wR4UTi6jHFCZIknjCOwdNmoe1HIXXMVHwzPrc9i9RFOXwFSI88R98svsC/eke7EsF1FHowM7cQ/8QqjbZfEUSP/5ye1MIF5mbqJPyf0AM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 833418cc-ce51-4f09-e61c-08dc36a81c0e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 08:51:23.5182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRKbtgkDQ3HcwGybhAPD2GMdA+9rM99OqxBzOt7ulZRh7hGXIcSFof6kXSGghngKEX+fN4RM2HmcxqMPwdurhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR10MB6428
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_05,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260066
X-Proofpoint-ORIG-GUID: RdHCMKJv4UIQFbkWqKxZvFsprCBEQPZh
X-Proofpoint-GUID: RdHCMKJv4UIQFbkWqKxZvFsprCBEQPZh

...

>>
>> Helper function atomic_write_valid() can be used by FSes to verify
>> compliant writes.
>>
>> Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
>> #jpg: merge into single patch and much rewrite
> 
> ^^^ this might be a miss I guess.

I'm not sure what you mean. Here I am just briefly commenting on much 
changes which I made.

> 
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   fs/aio.c                |  8 ++++----
>>   fs/btrfs/ioctl.c        |  2 +-
>>   fs/read_write.c         |  2 +-
>>   include/linux/fs.h      | 36 +++++++++++++++++++++++++++++++++++-
>>   include/uapi/linux/fs.h |  5 ++++-
>>   io_uring/rw.c           |  4 ++--
>>   6 files changed, 47 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index bb2ff48991f3..21bcbc076fd0 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -1502,7 +1502,7 @@ static void aio_complete_rw(struct kiocb *kiocb, long res)
>>   	iocb_put(iocb);
>>   }
>>   
>> -static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
>> +static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb, int type)
> 
> maybe rw_type?

ok

> 
>>   {
>>   	int ret;
>>   
>> @@ -1528,7 +1528,7 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
>>   	} else

...

>> +
>>   /* 32bit hashes as llseek() offset (for directories) */
>>   #define FMODE_32BITHASH         ((__force fmode_t)0x200)
>>   /* 64bit hashes as llseek() offset (for directories) */
>> @@ -328,6 +333,7 @@ enum rw_hint {
>>   #define IOCB_SYNC		(__force int) RWF_SYNC
>>   #define IOCB_NOWAIT		(__force int) RWF_NOWAIT
>>   #define IOCB_APPEND		(__force int) RWF_APPEND
>> +#define IOCB_ATOMIC		(__force int) RWF_ATOMIC
>>   
> 
> You might also want to add this definition in here too
> 
> #define TRACE_IOCB_STRINGS \
> <...>
> <...>
> { IOCB_ATOMIC, "ATOMIC" }

ok

I suppose that new flag RWF_NOAPPEND in linux-next also should have this

>>   
>> +static inline bool atomic_write_valid(loff_t pos, struct iov_iter *iter,
>> +			   unsigned int unit_min, unsigned int unit_max)
>> +{
>> +	size_t len = iov_iter_count(iter);
>> +
>> +	if (!iter_is_ubuf(iter))
>> +		return false;
> 
> There is no mention about this limitation in the commit message of this
> patch. Maybe it will be good to capture why this limitation to only
> support ubuf and/or any plans to lift this restriction in future
> in the commit message?

ok, I can mention this in the commit message.

> 
> 
>> +
>> +	if (len == unit_min || len == unit_max) {
>> +		/* ok if exactly min or max */
>> +	} else if (len < unit_min || len > unit_max) {
>> +		return false;
>> +	} else if (!is_power_of_2(len)) {
>> +		return false;
>> +	}
> 
> Checking for len == unit_min || len == unit_max is redundant when
> unit_min and unit_max are already power of 2.

Sure, but it was an optimization, considering that typically we will be 
issuing unit_max in anticipated FS scenario.

Anyway, I will be changing this according to an earlier comment.

Thanks,
John


