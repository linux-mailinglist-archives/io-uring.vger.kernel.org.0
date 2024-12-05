Return-Path: <io-uring+bounces-5252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38F8B9E5F57
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 21:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B815A1884C76
	for <lists+io-uring@lfdr.de>; Thu,  5 Dec 2024 20:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7355028C;
	Thu,  5 Dec 2024 20:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gPIlYUO2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SgPft5Yw"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83108193;
	Thu,  5 Dec 2024 20:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733429867; cv=fail; b=OqW7NI39grPzQEazRpGqOuI1rqQX7B0pGsBeIU9gNTYUtWB+r9o4ffLZFoc/9/114YGrws5zh16f2s1mI2dNSLVvt4XJ9+0GhTGcpJR6CNJYQBlkIWuNpZWkjTNPaQ9ENZRC9d1EcyeflZ90fbOAY2ouiqKJFF4optkPLjZnk/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733429867; c=relaxed/simple;
	bh=lPSP+G2YonBh5ettQntD8yvIkQXEeJuBNUMtn82sY6w=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=AKZjlKenIAIysP6eAwiLE59VLp/gOieA+wXgnEiP8HtCTt0AkIGOLmnnnkpU5vnHAZF/fd4ZbT7kxk1h+SMPdY9RfMaXbc0R6ochRHRg1HXkfDoMZVkSzpZX15rLI64a1+XfinIf/BTFb3Z6YpUBW2fqvvmG130KfLKG2IiqUmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gPIlYUO2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SgPft5Yw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5JBplf009915;
	Thu, 5 Dec 2024 20:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=wkCRUgprtQ24Io3E+f
	5lQFS+45MK4IckbPQXJXPoxBY=; b=gPIlYUO2lkBnyGF9wkGKtp5auUUwbGaU3f
	dGsuzptBT90xGQOWhuw9kS8b60bcZSxXTbde7JXrbX+9liJzcwZ1mHd0Npfjtrig
	unUPSby61aAok6M9BQ5pWR8O0s6M2wZtQeNnQRXAcixNOnRNsOj26xoU95GwaStI
	zVG6qpW8OkG9z+rS+//roMxwK9vnzvzS6v8ksX2xDxe3gN0/UdiW3k3tP3HcP8X2
	3OlchVhpEp0zzOpbm1dKJHtDLZc9tDlgDW7h+332wYRlkc6pTZedvO7dGV+Tl20J
	KlkEL8yb+d30hqEh5XucPp/Dt8Kqy0eq55dGtDBeUDTo2BsL9RAA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437tasbw2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 20:17:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B5K1c0k011669;
	Thu, 5 Dec 2024 20:17:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437s5bd6qw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 20:17:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n6ycWrF1BZv2jEQLTLR1HLQ5GFD02xZLBP/0oABDCQ532QxbJvFoMCy8fw8Ln8f4uk1EwgLSw+xYTsdlYr1+KFlUmgRkeNfLf+Gw/xX4LISMqtnxxvOD/xkGVd8q8QY2wTnBnvEwr8ItTTn1hCnrMdVnrLmaluBvHL/Z811XQ9K5mZGD6ZDBHJynRQQgix7U5SfrHlXCk6ZuPI7UGA7L5QNu2+03iLoKJhSc9m9JQ7maE8E2ULIHpsimqfBNenFG5XKcLL6zxlAGTSTMS+YUNVl751R7Fiz/XmsVN4RA6ASjuMFhGwjrE3MH3VNCzJbpAmNSTMDn/k/0hZQThe3zDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkCRUgprtQ24Io3E+f5lQFS+45MK4IckbPQXJXPoxBY=;
 b=JmBLhTkSsvLeX9Q9K6X/GldH8ros9SDnt0N/zCmqmNzlzjGlhWZdltFr6qs7vha0VAxGMfkdFSpXGqqR3ULQmCsTowqQLGMC+KctRdnot2aptnW1CR5CCxpVIe6GNaOXa6KO/KSbaP9w5P5jCYVoogplyZBGSgkM06kwpiQmPlCLxgfZVjQQ+Z6wLppHPGT+cPo8shsZZ1TVknQNDGNBu2ITqMS3RSb05qMLx6wlc/Ys8IQtu4GllxvylemwULBumXXswQWa+yn5qAD1ybHG6qCnTffn0jeyp9VC8bcEXPMyMqSEEAO7zjgwKGD/Rr1fTITzjv1zBRtdfNCgla6Ayw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkCRUgprtQ24Io3E+f5lQFS+45MK4IckbPQXJXPoxBY=;
 b=SgPft5YwMoQgzZ4OLfLz1I+ldTsjcSegymfgew4Tcpy35RbY5f3A3FyzSz837auW/hFOFCqMb+GqJtsZdM+to8MKEBifTNzfydVNH2f5KNubsiReQh230FYEoqY4XP4Qtio7MOAXRNpy6+3yBuzVey4Tr28YlD2w7o5py4/HyO8=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5576.namprd10.prod.outlook.com (2603:10b6:806:207::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Thu, 5 Dec
 2024 20:17:20 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8230.010; Thu, 5 Dec 2024
 20:17:20 +0000
To: Keith Busch <kbusch@kernel.org>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
        martin.petersen@oracle.com, asml.silence@gmail.com,
        anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
        viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
        linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v11 06/10] io_uring: introduce attributes for read/write
 and PI support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <Z1HrQ8lz7vYlRUtX@kbusch-mbp.dhcp.thefacebook.com> (Keith Busch's
	message of "Thu, 5 Dec 2024 10:04:51 -0800")
Organization: Oracle Corporation
Message-ID: <yq1frn1oq6j.fsf@ca-mkp.ca.oracle.com>
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113109epcas5p46022c85174da65853c85a8848b32f164@epcas5p4.samsung.com>
	<20241128112240.8867-7-anuj20.g@samsung.com>
	<Z1HrQ8lz7vYlRUtX@kbusch-mbp.dhcp.thefacebook.com>
Date: Thu, 05 Dec 2024 15:17:17 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:a03:180::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5576:EE_
X-MS-Office365-Filtering-Correlation-Id: e32fe92e-155a-4f70-bbbc-08dd1569d23b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VQrQa8PDjaKHcCXv46b4rfSVfYJKIvdF9zKJtbpg7H11ibdmChjPVgAccEMb?=
 =?us-ascii?Q?8CGJvTKcESOf6XiAB1fEY53g/h30QC2i+ZsiVLtWb6OkdE2kCIojE65pGMGq?=
 =?us-ascii?Q?M5OLlXZ9mLtNyp/OdaZQQau5TZJieVTFJb9PYXyE+vfl4MpQbOc/6WmtTCmu?=
 =?us-ascii?Q?s1j5XPW85YcwsWK4Y5C1ypRFmN1466J4SaDLTn8jCNmR2nlLYE7wD53nZBNn?=
 =?us-ascii?Q?BABqKLAzStiGop5vbWG71m1A+3lRvI8jEeAHwTF+1KSVlAw9uHjQqlW9xVtJ?=
 =?us-ascii?Q?RpITrWG8VDcdezIU+QE9vu/oEMIU3J7xlEYlb8WuKya8oGgRrYxIztogqXEd?=
 =?us-ascii?Q?PO0vmm/CHv95i7aE5x7aMVq201D25psaX/FC6VieOKAWrsL7JXntsbiPF+6y?=
 =?us-ascii?Q?qk1c5nPNEeacKxO/DdhsvJD+S7dv2POIz36dv20l/BOYuiLfsJGkCNz9S8sj?=
 =?us-ascii?Q?KgogBZHCsm5x5HJ4KpwtJfuAng0zrpb7UA6zskXKTLeFSZSivi1M+5dMkuV4?=
 =?us-ascii?Q?luDVPQ/21nGENmhUzfzWwIbFABSIQiY1uHLzq0roAAE4ab76jBeutH0zrFZo?=
 =?us-ascii?Q?7ptMNmgH62B6oLAjMu4icTdFy9ntCI/IiTqe6aZd5uGgSxCaCy5wB5G7r4Eb?=
 =?us-ascii?Q?O1Vjr9X2jLu5kNvuEfAyBj1dCGis2+OinDrbmCywRDIg7VG36pUTqZ68rfFI?=
 =?us-ascii?Q?qKPGAxB1+f6QmujVHgby8UPRRhMj5/NTzvDnNSkEFPHNugye1xisl33E21do?=
 =?us-ascii?Q?bGz7+3+PVjdK8stYnfheyewgkCsa+g0SNwpaUkbXGqBWgKCzVdH0miCl87ZA?=
 =?us-ascii?Q?aduPj8uWeHenoFj1W+xtHKaWnqMOGGs2qHK7P1W5f5zwKxfTuDr6rq9VfT5Q?=
 =?us-ascii?Q?NopBQCekKMY0HbyEMLLBW4cy43KURvfzThmGiAwGd2Xe+vN8VwiNPx+sBsGg?=
 =?us-ascii?Q?/9tI6Cqw3kG8N1Bx1o4Edmynh7hYUoZlgzLr5oGPhwQc3/qc2Mejx5yxeStM?=
 =?us-ascii?Q?BXq9hDii7WlTZbx17lAClmWNAZ8Vfm+j9U312lLg0EleobY+BCD7gfgPQ/aT?=
 =?us-ascii?Q?7Ho6X7/pwOrEBk09sg8QqhDnHDCCvxIOGfCJebFa65ZcMES9SrH4pgzOg8fl?=
 =?us-ascii?Q?mQ1EAlXuCgggT/Q/va9vpWwVfqQYeXFVyklcX+xSdX8Jy5jTU86lLIOgpxQD?=
 =?us-ascii?Q?I6RUwai+LYYpoJPZtfj5uEHElgajwwAOfvxWEBvCBLVCX8i1GuiGp1HazJVX?=
 =?us-ascii?Q?npszDeJa5JQ+AEmciWB+fXE1cViAbcmbs2Wx7Ko/eBtq9gM101ZcUhwzsUHe?=
 =?us-ascii?Q?p0RJVOjY/dxBtc6uICepvyzGcQ+WHN9A3/rLvoRZWY5Gew=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kVT5Sbq5hu1XqvRZggd0zh6smu9YUGI5Y2rNlB4blpz42Q2m2a+bygph3HYg?=
 =?us-ascii?Q?5J0E4LtkM7skKqgGwPaUnCrG6hobMT7q05osKxp7zUA72bYe+Xkw4Q3h8SAm?=
 =?us-ascii?Q?3D+iXsmooKvKpsuJwQMTgjf0oncD7YUkUX0ZsJnAxPcQsmdPMgMvSZ1jLAWO?=
 =?us-ascii?Q?+bxmWf8BkcTBlvUyLqCyLJfY5AddiBhx7gZK+C4LGGKKXlz7ZESwb0xiKS9t?=
 =?us-ascii?Q?r9UlfQ83dESDJSoIoEZulEbkYB9QszIa4VGjIcJTgz1mNCj6ARJvdSjfvBvO?=
 =?us-ascii?Q?AJLn+7oYG/ipx94GISp7wfTwutVmjiCyhDvMxid81bS0W53ujKosBPraJ4PW?=
 =?us-ascii?Q?/kyOPWSA+NnVLcnocEHiZCRoDuNTTzYbWrS+KShGg96PzSPJtw8t96+JPsYP?=
 =?us-ascii?Q?OXDUFmG1kzmTUeLjK+Vs/sn43YuDIBmZPlbkV0JgysKhLmzhF7qQIGMqFApU?=
 =?us-ascii?Q?N1HCeVSWTnRj4oqMUxnq1UYu58r/oRUtvEmsEsoEcbfGa8HUDJmEmke+CC9z?=
 =?us-ascii?Q?EYOkc1NjZMDdGy7fw2qSeQLHS2di+TLnodhn8h5m8bJ8ViTo33R0sAmrQB5+?=
 =?us-ascii?Q?sxglk53v8wNpPXVzehi/fweRVTy1fR/r8e0SJm3Y9jaV1bPmxqJ/nycOT9n4?=
 =?us-ascii?Q?b3gcjuF/Q9q77E6X7rSWIPUMt1itVrEUNXsuZghV8bEm2bg1jzWYTGcjhWgm?=
 =?us-ascii?Q?YgrwSRqMTxBKggHgvBseSOeSQtDEf5RFUEyBuKIkzoYqW8YLeaVEuTVYnPgo?=
 =?us-ascii?Q?KOWF5WDXlmYIHALUvW47JeI1IQXgkQLfdnpp+IVRRs9YUjm+8RfQ9Y9p0btn?=
 =?us-ascii?Q?H4P+l9n/H4CXSEHHr+VHT57CilB1Cfh1srfArI0AX0mp7PSBPd35ARq2MO4U?=
 =?us-ascii?Q?vHvCbxuyUaX6mGHZ/Wj9gQsPehKj8nzyVokzwD8SCoUlUP1VIFIBCSSOfkFQ?=
 =?us-ascii?Q?Bwiw/4DKgVQoV3erE/vIobmdFXWl4/3TTdoeTJBY+3G6CBMQkvrZN2YASWPh?=
 =?us-ascii?Q?WavwYrF3Wc46X9cYB+j3+zgj71fghOwuXRq9RLw/S2oY51gAEax5XGH5akfb?=
 =?us-ascii?Q?NmR9nR5bcoLBCtDtu+83msCUJAZ3HAkzbkJD9JMNRBbDXZxhgm8ZJqxykgrL?=
 =?us-ascii?Q?0M5bW4RABWuoRPKMZmM0UQPw+AX7yH3HuVAOgK/NUvX+DZduLmTuE7AEon76?=
 =?us-ascii?Q?eyIAlIdzpF57bJuqRpj6VE2kbYbanFRTkj1YsbNNF3qbVD9m6/EnF5DMocLv?=
 =?us-ascii?Q?+O8vAVH/UTq0mZV6Ax0AQxFd+sXYk/H65x/opRpRVa9h9gIuapeoPYjP976E?=
 =?us-ascii?Q?ATvLBrah0h7B5FdudbSbPKEAFPQHtMc0H8X0nEYGL8xRpvraHxJDh5vUEGqB?=
 =?us-ascii?Q?h+CFWHhhLrI30RjDTyG1M3ID0JPWx6uuh9iJ/QmjJtRLFKjj89wbTxvfG3Iw?=
 =?us-ascii?Q?Tcra5niyV5eOnqXJqYW3eY6zwovkiiotlK0TlzxefspWo6ZVJQARDzh3BkCQ?=
 =?us-ascii?Q?qGbW/gX+ya54aET3nSjf+WH/wS30YGvlv9lYamzP8snHPx3gvqGccgnEuU+3?=
 =?us-ascii?Q?s3crfzasB9U0fZE6It64GcjmLXvF3evRQCAFLjS6VK9FDMjmF0f5YuHB557T?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mi0M8af0YXzsH0fGSARObl/ayqVgYou0yULXMum7ysjyNctgBE9Mnsm+WyTazbE8J1RXD+ZDO+bJlqzeOMnECf352R46ovXuOeJjJX9EHY286OzQTbuSkWmVzq+7N0mMc7Km4VzzJj5OzyX55VFOfFSCYjWDus6OapRaRVT1ojcOMdroAqbd6BVvAO7zikeXO11Qn6XlDOvwcHAib0wbOFcSM0QfGLy/xcEyVo40bx1Ze+eQgp4nir9gTNyJGPUULgXHdmfdFitvEdZHka37M71EKXWRjEVJHh50uMNLkYyKpR+fbmMgyQVDXtf+JEotBg6rdf7lpBEnAHHG6UsXplZMpnVEkcwGcgNS8VGd3yngGYnQ/WBzj7V7fGe3EgyWEV1sW70P87vuc2M8SaoyNJ5bk+H6YNnfGKi8KCD8XV0s4voHInqDiuZz0AQd4zRSrsmt4p5x6MT/gvL+0zBl6yD1srP7sLUxvU4wxcwZ21uxNaTFTHSljDkdElfCZCKqWjsS/o+MBkUGRR6j5qwBUXqOUj6bs3YQcT7uMJg0ZWblVwSgDlMzu1Q8nY+abgmaFprIIRohzqnaqqjaFL9+2rFsiA5GkKgiD3Y5e5Z9K0A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32fe92e-155a-4f70-bbbc-08dd1569d23b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 20:17:20.2501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J5yZaseM23KAbNU91tjm0zBke/bgmBAA0Fv3P+0MyK55ungtc+QnYqsBWIV0qj8FNQ9o8SDQUjRYVluH2OXhRYlxWWPGUY1a3KrUmNGZrqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5576
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-05_15,2024-12-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412050151
X-Proofpoint-GUID: 2ogEgpBmma5-jtL0-SSJYqSHceJS48V_
X-Proofpoint-ORIG-GUID: 2ogEgpBmma5-jtL0-SSJYqSHceJS48V_


Keith,

>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index aac9a4f8fa9a..38f0d6b10eaf 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -98,6 +98,10 @@ struct io_uring_sqe {
>>  			__u64	addr3;
>>  			__u64	__pad2[1];
>>  		};
>> +		struct {
>> +			__u64	attr_ptr; /* pointer to attribute information */
>> +			__u64	attr_type_mask; /* bit mask of attributes */
>> +		};
>
> I can't say I'm a fan of how this turned out. I'm merging up the write
> hint stuff, and these new fields occupy where that 16-bit value was
> initially going. Okay, so I guess I need to just add a new attribute
> flag? That might work if I am only appending exactly one extra attribute
> per SQE, but what if I need both PI and Write Hint? Do the attributes
> need to appear in a strict order?

We'll definitely need to be able to include multiple attributes.

Not sure how the attr_type_mask was intended to work. I guess parsing
attributes based on bit position in the mask would be one option.

The SCSI approach would be for each attribute to have a 4-byte header
with a type and a length so multiple attributes can be described by a
single buffer.

FWIW, I wasn't initially a big fan of having the attrs stored outside of
the sqe but it actually made things a lot cleaner for my use case.

-- 
Martin K. Petersen	Oracle Linux Engineering

