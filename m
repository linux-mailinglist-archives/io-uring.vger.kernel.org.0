Return-Path: <io-uring+bounces-748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45ABE867EEB
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 18:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAF40288FB4
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 17:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEFFA12D75F;
	Mon, 26 Feb 2024 17:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gV0tYsMa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ungnzaV1"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1251131E26;
	Mon, 26 Feb 2024 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969058; cv=fail; b=L5z7iqp5povEeLohPfkd4TDQynTzTrrWnMpkqgdoywpOfrp5pBO113obSySV267LrRh6BsSt0zBVL9sf1LZdj1fEoos6TMQ3NIDeK9E3lY4x2L7bI+CmnxNCv1AxudAlY8TVwmvs7vAYNMnLBmGdTvf0p/h/r8pFYSIGDvEcjaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969058; c=relaxed/simple;
	bh=ijYEFYFApduEOHjdwpDxBvdQjRcJGstA2L+L8N7ocp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FkpBMWV8G4E4ukaI2sKpS8RatxuYnlxqqCkHRKwR06ScZs4erPGkZcl9RbkFRLZhEJsEtRzVtNIPkPdtjfHv3P4WV3bIOmkRqFi8mkRSafHM8BhvLJReWRVDPR8hLyD9KOd6+iam8qbowLSopAA9nO0/2A4R/C59TdeAQWuu0ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gV0tYsMa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ungnzaV1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QGnGWX018463;
	Mon, 26 Feb 2024 17:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=EHCLtQsZ7lriVd7Tl7UNkBLv7DKwpFv8w0Tmh96SCxw=;
 b=gV0tYsMagE5fARjBTKvaEBip8roafJUtLHv0lZQcXq9TxJ18YxuEX+BR6STW5WTchF9i
 IOOJjeXMq3+gxH7Ixye7i5UBiIEo0YzHGnahhWFGD1PNozn30YwQjY8bJClfG3JTge3R
 EgYWwV1F1KQW6HzH2/ngcy72vzYxBvD8+59B56Trbp0m1cRJ9ajlYCTmI6m6hjgz4T0q
 N1ntVtNZP44uzaS85sslJ0pyfULUa0ASAgCRAPHvEp/+Vk+Tay+/PdbzG+MOitvy8pJv
 GP9P3aLp3bLdakp9fVJDHNpppGu2hKFyKv2OGpbFfjmLefNLTL1Q+gHELKYDxOMxD1D0 1w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8bb52fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:37:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41QH1qEt022365;
	Mon, 26 Feb 2024 17:37:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w61tvn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:37:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTFY/3a2PNwPCmPr3KPf6a3usWAg3oxGYn4Ob5JwIjwK/YeuoNEwQRD555ZVTRkIAlD9PelkJRfag3A+avEzim/5P9WGntLwpF6Z1YE8YqadTRhs1NcJnEo289ayo4d27zqZHwTFFReLSbuQRVPe75o52H6NjE4IjcYRTxK2zkjhY6FCPDn2N+aRCwhaqsvfZdAOgMiup3jicY7vUVp5WLis0syfYqCkNayU4/4lpUfSZIvZR6NWCmbiB01OKYMiii58G4hPPZaKDeYFQxyPs9QUAaywo6LCegbreME4LJ8BmikLfu2mCDoqjEuV5jDlbyfA+IWyOP4feSFgsm1Hxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHCLtQsZ7lriVd7Tl7UNkBLv7DKwpFv8w0Tmh96SCxw=;
 b=S4wGI4O6sv7ajAjPcNq/y7I4TnhRh9g05drunsRZHzR1BzqJForeoBiwebr3xD5gV8bGsqk/mpbfYuXCgjlcX7lV848wVJQD3V3sWKZ9L6Qz1wsUPDqs5AHMgxI46aYD7lBMww7huEYnkSNpiUxgGwEqCsXctaRAxP1KWX804g3JkT/Ymg5xe+4PGGWAuN+6wlX3VWeC34eInwbCBRrtg7OhC2IztSCs6VHppdUn9JFdPHpKwul6QII9gHObG46tX4fV4MTvmyc5cdG+edSKM3141MyBPuvdEGnxQ+P5LIKjTHQBBVYrQAtGOEUpnk584G8uoxWhzGn2kQhxEgn4Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHCLtQsZ7lriVd7Tl7UNkBLv7DKwpFv8w0Tmh96SCxw=;
 b=ungnzaV1s+W/iP236Rx0T4blqqO3rqy6UWy60CjM9Lf0rTAV0T8ame+HGzkB1LvliofI9fuw5ZQP//1Wy7hrwQ5Tf0391La7pBKZdxLGvrU1M6OQ+9Q1LtDvJFRQweiR1jwoL76VsT5qchvHT0XM+GAlOlCpNPEp2/gBt8jc3Ic=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6298.namprd10.prod.outlook.com (2603:10b6:303:1e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 17:37:00 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:37:00 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Alan Adamson <alan.adamson@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 10/10] nvme: Atomic write support
Date: Mon, 26 Feb 2024 17:36:12 +0000
Message-Id: <20240226173612.1478858-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240226173612.1478858-1-john.g.garry@oracle.com>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR02CA0052.namprd02.prod.outlook.com
 (2603:10b6:510:2da::32) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: 64dfa4e6-d4c4-4123-771b-08dc36f18934
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	U+C1oxC6qsTO10OEmudOx5aeM4wmWWEKRV0ZkeV/0GM61ZoDD9NpkVrxzCgDydPndFwwjvejhGQYPI99miDKi7C4H2Du54Dgq9tYwkSxHO5jgxCzjrmIKt/VbHjWUpZXEKd0q+DFgm1Zq3xgDQOpMIdpyyXD8JpN15y17GbWhdTHdEdhDyzAX8IRhLBulEl+wUu6Ym2BY4Qw2iBJ3JKH34KpzyCGMaDaSRvmcDqVzLJ+9R99yxLz5r4ZxqkiSk0w3bixHEi10oNuKSGBElbv+QOyYNmRi7L/RfVq44wmAnqKdrqDWQhAxOs/XfZ6emRdreLy96Y2B5QRGZM/VY+K0vF2kOG1+laKYJxSnW6gyZEGHKcyqPKyd5omHnff6FxJY9XzDx85fC8H/jqz44GKdGY/J6Z1cIN+VWSCa0V2YRZaS+QeefpxbtKoASUnshhbv2UwMPoXSONVYwkmOcEm/+z4rIZfMvZrg4PL8y/Yxp577wqbMACgNlQ8kwIfeqKNuBCEhq5p+QSzaRn4GRjBfWoopgjXj3wSEWflssX8f5wEiDalisp8GR3eBm9VsNj0oqU1liHlt5sJ6MrZUTYci9spf5PBAqTZeJZqdBiurwSxGxKRCYm6rvh1yZpaA+fo17dwZ0zV9Y8b6Cfrch9OcQnTvkxBZ95jb/BW7VsiPGNII7N6f2nLvThJ1Mks371cuI/K1EKMUe4N8H5W/Jqy0g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZkxKQ3FSQlR3U0p4aDZ6MExPWk8wZy9MWjJKVmcrazM2VTdlbkhlUE1XeU1o?=
 =?utf-8?B?akNLQ2dkdVYzaTVCOGVsdEpnU203L0N6V3NJK2hnS21RTG1hOS90YjB3MTc1?=
 =?utf-8?B?b0J2MWtYbWFraVhqZE10YmYxQTh5aUc2Nzd0MmdsUkRZRWwxL0tkTjNEeEtu?=
 =?utf-8?B?bFBRWVZlNU8xUE5rSWswcEh4TzBPK1ltU2dIcFM1dFhlQ3ZVTFFlQVZ3NU5j?=
 =?utf-8?B?ai94SjR2cEN6T1ErVlpZSENCTzU4L25WSGFIZ2loOEx4MG9CN0gxeTNGS3p0?=
 =?utf-8?B?SFVTbDNIUjVYY3poeFdpa2hPTS8wald0cHBuK0tZM3VzT1dRVkFyZFVPVkVm?=
 =?utf-8?B?K2dLUHE1MmV6ZzBTZE5oNDFnbHdUZmZCSXF1MjlEQXkraEpvQTVReEZXOTA3?=
 =?utf-8?B?UXorVHVvUGNQVVI2TzVLUjFaOEtQRitzSWJlbmw4eS9FV3l6L0dkUDdkZzN5?=
 =?utf-8?B?OWVpd05jdDN5ZXpETm9zeHlpZUVkOHZpZ0daZW42dXhwMHZpN1VXRjdLNElK?=
 =?utf-8?B?ZDdNWG9pQmgva21oY0dYQWJyejVkT1d3UW5qWnF0bVBXcUQwY2N3SVA5UnhU?=
 =?utf-8?B?SjU2YXlNSTFNYTFSd25kNTZDLzloZGNFdkJ1a3hVSm96bzlveEdBQkJVN3gz?=
 =?utf-8?B?NVVOSkU4OVEvbGI2M0d5anFoMUxDQ2hGUVVDQTRIS2gvRVdWS3RyVkxwLzU0?=
 =?utf-8?B?dGFxVUpKbGp0N1RMUjVrTFc1ci9hbDRJK3ZpdzVxT2tGd0svc2VOM0dSbHJY?=
 =?utf-8?B?SmNWK1dXTldNMlRNOFU3NWRwRUdwWFp5V1I2MzAzOVZRVWJKM1NZNkFaVTJP?=
 =?utf-8?B?aUlGWHl2SjlXTkxYRzJlbzlrNU1GMndkL3BvVnlyOFU3aHBEakYvajgxeStV?=
 =?utf-8?B?K0xaYWtJWUNUTnRRZmlaZkJrRjBKb0d5YWw1NkxUSDlFNmhDeG9VRGtFTEVt?=
 =?utf-8?B?RG5TZEl5VHYvNVV4d21ZOGw4c0xPZGxiRkdscmpCenZ6YXUzTlRDdnV6bjk1?=
 =?utf-8?B?VUxReG5DU3ZQRmhUYytwUU5QQ1Jxc0dpekR3NDd2QkY5K1hUR1FpVGtSei9G?=
 =?utf-8?B?UFM0cm5YNVUxSDlscjVSeVkrc3RjaTBsUStQajA2OXNQVTZYS1JieHJGM0gr?=
 =?utf-8?B?ZTV2eUhhMzk3K0ZEVzI4NmJMNCs0TWE3M1VRcmV4bFZpeHBYclJySjE1dith?=
 =?utf-8?B?ZHA3VGE4U0themVLSzBEOVlReEVvUDZsUm5pYmZCR3NDdEpXMXREY091c09i?=
 =?utf-8?B?RFhWVEtObFBmYXAweGFaTDZHM01sVXhSZlZVZ2l1N254WEtVandvaFB0UUY3?=
 =?utf-8?B?bEZsbmFFZm5VZDNhR0wzMDVkcjBQb1FKUmZoeGlVVXhmcG5FNWszZXFVWkEx?=
 =?utf-8?B?NGU3czVWcjc3ZmlLYnJ4M2I2WEVLTEZBaUZLalVmeVpCbkhnOW80N0RHMW5U?=
 =?utf-8?B?TkhMN1lQdkI1bFBVeTBlY1ZqM1RNRGp0RTExNEpQSkF3K3BJdmlmNUdOL2FP?=
 =?utf-8?B?YnFFRjkzTGRGQmw0MWFIYUppSzNXR1FpVDlNejUwSmp1S1VxNzJkYndXc2k0?=
 =?utf-8?B?UmFzVmZOQUZtTGtYdFBPRzBxZDRZd1Y5RW5HbG9GbGM1T3ZqcENBK0F2bGh3?=
 =?utf-8?B?ajlmRXA0TEVPa09SV1VEamZDL3hmVkN0SVNsNWxwZmNMOHdBcEQ0b2Q5dVFY?=
 =?utf-8?B?M0lDK3gzUEtnU01LQzZWQ2NjSTBBWC9WeE44Wi85NDVZSkxCZG9ad1FYQ1FE?=
 =?utf-8?B?Z1hQRWlBSi85YjhRdkhjako4dGdSQmRUc05xa1kvSnphczUvOVNzVG1YbUtI?=
 =?utf-8?B?M0t0ckpvd2NiSXIxc3F2YmxUNzIyOEErM1YxaThqayttRTdXMjc2d0lacnZS?=
 =?utf-8?B?UXpKbWZ0SldIUXNvc1VUanZaS2NaU3luYnNobnFBaXJIemJuVXlDbWxvSHZN?=
 =?utf-8?B?OEhjcXZBTmMvc3R3NG02NkRXMGhZNWZab0h0VzNhSm5xdmRGZE4wTEhMZXph?=
 =?utf-8?B?aG96OVZiOGxnTS85bHNYYjBZQnVVMUVGSTc2TFVVc2xwNGZ2Wm5UT29YSWRw?=
 =?utf-8?B?WVRjTUtDSERsY1VCeFh6MERDcVMwV2VJQzg2V3M2aURMdURzaUVmNVFtR0V3?=
 =?utf-8?B?VjR0RHN3OFZ4RXMrdUNGNldUc3JKYWpSSWNtYjB2L0NBZlFyVXhzVGR5RDI1?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	VUNxDd8TA27jIoGRA6WYBynaHKQwkKZIqIm/rR2v1665wXYWpjOKEABDSe3FUsNgjSJvCrmn8D2eupJkWMPrMoVUI8nMYdXehcUIeA4zhNxGB/ebhR6HKXCjy7npySi5lG14CKJXLL7amIUqEhJQleS9hL54Q3sPiUbAQTIqA9tn+nIPoykSqWy0REmSzwqD4/yxk2D7w5wjXEzD1oqRGQ+RGW8E6axeY678YIag/DdPsiF2A9lq4wk7sun2blcJb2BOwyETT8f/P+bTxYvp6/zM9sA1VaRCLRWMOoZ3EYrt9l1ot2IKudSIZc8IgEi/h+e5+34u094pRf7CTIb7J5zrzR0b8/7TlhT31f451pBGgi0OgSFUFdTQnWqeFTDD9rEEkM6S/81vye7A1OvdInCUd4SJ98ELnlyhzt3zbBBl8LjXAh7DYbXZok+n5h0b6TNhY9WC+p4cAj5vgBj+7ezVRsoxhd1jhY1ygYas08j+1p8+t56bdLlkAoQbCNhnQBEtgSp3CfZl0GFhoZ5y7LTYJQPuz9QtT/EVpl1kU7gI9GJf002Hl5W+fg/aKJZ3pAEjwIzc9ZKLd/i4Lz3lcBmZ4sJIVJ0/ARV+O5XKcaA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64dfa4e6-d4c4-4123-771b-08dc36f18934
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:36:59.9391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QCTdnSx+3hZkgvowXs3mZYjocoI0Z/UBbY2lAR2IUxSL6zQi7ccH+A1OzxPbSTeSohNPW3T0Q6Up0YvrxPe0vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260134
X-Proofpoint-GUID: RMdLPRbwlIK7S7P_wP3F92xbAzR6EV8B
X-Proofpoint-ORIG-GUID: RMdLPRbwlIK7S7P_wP3F92xbAzR6EV8B

From: Alan Adamson <alan.adamson@oracle.com>

Add support to set block layer request_queue atomic write limits. The
limits will be derived from either the namespace or controller atomic
parameters.

NVMe atomic-related parameters are grouped into "normal" and "power-fail"
(or PF) class of parameter. For atomic write support, only PF parameters
are of interest. The "normal" parameters are concerned with racing reads
and writes (which also applies to PF). See NVM Command Set Specification
Revision 1.0d section 2.1.4 for reference.

Whether to use per namespace or controller atomic parameters is decided by
NSFEAT bit 1 - see Figure 97: Identify – Identify Namespace Data
Structure, NVM Command Set.

NVMe namespaces may define an atomic boundary, whereby no atomic guarantees
are provided for a write which straddles this per-lba space boundary. The
block layer merging policy is such that no merges may occur in which the
resultant request would straddle such a boundary.

Unlike SCSI, NVMe specifies no granularity or alignment rules, apart from
atomic boundary rule. In addition, again unlike SCSI, there is no
dedicated atomic write command - a write which adheres to the atomic size
limit and boundary is implicitly atomic.

If NSFEAT bit 1 is set, the following parameters are of interest:
- NAWUPF (Namespace Atomic Write Unit Power Fail)
- NABSPF (Namespace Atomic Boundary Size Power Fail)
- NABO (Namespace Atomic Boundary Offset)

and we set request_queue limits as follows:
- atomic_write_unit_max = rounddown_pow_of_two(NAWUPF)
- atomic_write_max_bytes = NAWUPF
- atomic_write_boundary = NABSPF

If in the unlikely scenario that NABO is non-zero, then atomic writes will
not be supported at all as dealing with this adds extra complexity. This
policy may change in future.

In all cases, atomic_write_unit_min is set to the logical block size.

If NSFEAT bit 1 is unset, the following parameter is of interest:
- AWUPF (Atomic Write Unit Power Fail)

and we set request_queue limits as follows:
- atomic_write_unit_max = rounddown_pow_of_two(AWUPF)
- atomic_write_max_bytes = AWUPF
- atomic_write_boundary = 0

The block layer requires that the atomic_write_boundary value is a
power-of-2. However, it is really only required that atomic_write_boundary
be a multiple of atomic_write_unit_max. As such, if NABSPF were not a
power-of-2, atomic_write_unit_max could be reduced such that it was
divisible into NABSPF. However, this complexity will not be yet supported.

A new function, nvme_valid_atomic_write(), is also called from submission
path to verify that a request has been submitted to the driver will
actually be executed atomically. As mentioned, there is no dedicated NVMe
atomic write command (which may error for a command which exceeds the
controller atomic write limits).

Note on NABSPF:
There seems to be some vagueness in the spec as to whether NABSPF applies
for NSFEAT bit 1 being unset. Figure 97 does not explicitly mention NABSPF
and how it is affected by bit 1. However Figure 4 does tell to check Figure
97 for info about per-namespace parameters, which NABSPF is, so it is
implied. However currently nvme_update_disk_info() does check namespace
parameter NABO regardless of this bit.

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
jpg: total rewrite
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c | 72 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0a96362912ce..13e0266b65b3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -934,6 +934,30 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
 	return BLK_STS_OK;
 }
 
+static bool nvme_valid_atomic_write(struct request *req)
+{
+	struct request_queue *q = req->q;
+	u32 boundary_bytes = queue_atomic_write_boundary_bytes(q);
+
+	if (blk_rq_bytes(req) > queue_atomic_write_unit_max_bytes(q))
+		return false;
+
+	if (boundary_bytes) {
+		u64 mask = boundary_bytes - 1, imask = ~mask;
+		u64 start = blk_rq_pos(req) << SECTOR_SHIFT;
+		u64 end = start + blk_rq_bytes(req) - 1;
+
+		/* If greater then must be crossing a boundary */
+		if (blk_rq_bytes(req) > boundary_bytes)
+			return false;
+
+		if ((start & imask) != (end & imask))
+			return false;
+	}
+
+	return true;
+}
+
 static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 		struct request *req, struct nvme_command *cmnd,
 		enum nvme_opcode op)
@@ -948,6 +972,12 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 
 	if (req->cmd_flags & REQ_RAHEAD)
 		dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
+	/*
+	 * Ensure that nothing has been sent which cannot be executed
+	 * atomically.
+	 */
+	if (req->cmd_flags & REQ_ATOMIC && !nvme_valid_atomic_write(req))
+		return BLK_STS_IOERR;
 
 	cmnd->rw.opcode = op;
 	cmnd->rw.flags = 0;
@@ -1960,6 +1990,45 @@ static void nvme_set_queue_limits(struct nvme_ctrl *ctrl,
 	blk_queue_write_cache(q, vwc, vwc);
 }
 
+static void nvme_update_atomic_write_disk_info(struct nvme_ctrl *ctrl,
+		 struct gendisk *disk, struct nvme_id_ns *id, u32 bs,
+		 u32 atomic_bs)
+{
+	unsigned int unit_min = 0, unit_max = 0, boundary = 0, max_bytes = 0;
+	struct request_queue *q = disk->queue;
+
+	if (id->nsfeat & NVME_NS_FEAT_ATOMICS && id->nawupf) {
+		if (le16_to_cpu(id->nabspf))
+			boundary = (le16_to_cpu(id->nabspf) + 1) * bs;
+
+		/*
+		 * The boundary size just needs to be a multiple of unit_max
+		 * (and not necessarily a power-of-2), so this could be relaxed
+		 * in the block layer in future.
+		 * Furthermore, if needed, unit_max could be reduced so that the
+		 * boundary size was compliant.
+		 */
+		if (!boundary || is_power_of_2(boundary)) {
+			max_bytes = atomic_bs;
+			unit_min = bs;
+			unit_max = rounddown_pow_of_two(atomic_bs);
+		} else {
+			dev_notice(ctrl->device, "Unsupported atomic write boundary (%d)\n",
+				boundary);
+			boundary = 0;
+		}
+	} else if (ctrl->subsys->awupf) {
+		max_bytes = atomic_bs;
+		unit_min = bs;
+		unit_max = rounddown_pow_of_two(atomic_bs);
+	}
+
+	blk_queue_atomic_write_max_bytes(q, max_bytes);
+	blk_queue_atomic_write_unit_min_sectors(q, unit_min >> SECTOR_SHIFT);
+	blk_queue_atomic_write_unit_max_sectors(q, unit_max >> SECTOR_SHIFT);
+	blk_queue_atomic_write_boundary_bytes(q, boundary);
+}
+
 static void nvme_update_disk_info(struct nvme_ctrl *ctrl, struct gendisk *disk,
 		struct nvme_ns_head *head, struct nvme_id_ns *id)
 {
@@ -1990,6 +2059,9 @@ static void nvme_update_disk_info(struct nvme_ctrl *ctrl, struct gendisk *disk,
 			atomic_bs = (1 + le16_to_cpu(id->nawupf)) * bs;
 		else
 			atomic_bs = (1 + ctrl->subsys->awupf) * bs;
+
+		nvme_update_atomic_write_disk_info(ctrl, disk, id, bs,
+						atomic_bs);
 	}
 
 	if (id->nsfeat & NVME_NS_FEAT_IO_OPT) {
-- 
2.31.1


