Return-Path: <io-uring+bounces-1503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A95568A0AF9
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 10:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 208221F21007
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 08:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D2FA13FD79;
	Thu, 11 Apr 2024 08:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PgIKjItf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yjRYCBk3"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131312EAE5;
	Thu, 11 Apr 2024 08:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712823343; cv=fail; b=VJ1fkSJWVIUazDT4+5Djh6cO70ecPqw+SRqQ4O/RV3tmcXR99dG/J1b7n7k6l2XmyyrsJy7I9w08XjXAQgXDAc+R5VzJSLq/5cq/mAsSvvZnWPdquFus+uEBITuBKO7P1PmiYV+UkwnE+NXo/GZ/j4Jp0GSfhaYl6Y0LuumJCMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712823343; c=relaxed/simple;
	bh=belBAIsp0NdtoiWUA2HV6URjZ4Vw42c6I/iM/AjGphA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=omn7jLLBIhagmdVQ0WGIT/eET4bewMb2WS4BY9hlNHKLAhD329Yfyuy+a4YpSD8yWbFTfW2nt1HzbI98HGKUZ2QNJinPI/TQpVeB+6Jei0b1hr6sIE07vdEqOZHyeGenHLk3NqewqiKPh06AtQ5NahO0TxsTqNdzuM9Yr5RFdso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PgIKjItf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yjRYCBk3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43B7jESX004283;
	Thu, 11 Apr 2024 08:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=kvs2U4n5wCCEmmuF1BI9OBh5eqACnZJt3yUkSGWbHZg=;
 b=PgIKjItf7n143FOaDU8qIGX44r1cU+RNq9xrjvuUEQpx8TjZcmVrssrud7w7ThoIU9fd
 SVgT7IrBypMaZvEuQSNY2FVVdZJHnMBPhDQ3WbPI6GzNIwfbeCbB7x3RT8T3zq7BANka
 7h3mWwUKpOSgiFrtGlNIHFNP2m0tiZW064jnf+hF/J1VU8xVZYOz+Bknk6wNtENo6AJu
 gE3SJKEQHnFoRLAzM1cV5q3oH1Qd2uCXmjOGBaXWHqnum6BFQhBiGOuB76C9r0rjwHhv
 8VOWWfB7WKPDM3ubq0CVGQTfnlf12T6AGvIyNN2EovRjAigB7TlR+vK22xfVzrbbVAzg ww== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xax9b8y8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 08:15:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43B5FdYr003010;
	Thu, 11 Apr 2024 08:15:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavufgs5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 08:15:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZEQ5/pQn0D51JMmRJfp6+fVYPvT9DbFwcNzUwlw6YT3bWogkSWIvG8p6k7SDU+P9eHZdoZTewLw7SsPgyPv7hTbUkmBbB9H6Dma1cPwTg3e1FmAxW71sZ9ap7RYkIWkPy8iuACRh9BrfnJ/mWSSp2QY1XNwOeNI/wN1KZnAEUeqI4cuDrIf9K+U53afAIBrAj11u7Qi3elhNnoBGNKLOxMEO2p/k88yOASaRr55DJtjGY1tI97K1/F2f3A2LLiuV6RDJGv80d8MRLooOG0m8BVWRW9CkCdVID24PLGvYJCKthL4eIek0Wr2oIfuzO041QWeiY7zltXGph1JDAxTAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvs2U4n5wCCEmmuF1BI9OBh5eqACnZJt3yUkSGWbHZg=;
 b=PQr42j6xIjQLP26n31tW5eJpP+p+DgBgayU7treHZplX1r/diC4hEq11xuVxgLPZ4AagVhV/laGSGibBPF46LERcLUSHFQ1GD0JPZe9SmIr+2LQCl7eKT3uVIQp4u6UZubtCx3W9x/e7miIoD7U7IeeHBQqxdpptJLzD0cqCqzjNhxd4zFK7yZovEqx2DDo9BpJsT++B1qcN8Vzxem23YXjIMRHvsJF3fL+IKgCjWPuu57XZz6LlyoLFdoE1DDyIqLNd1kTLUnevWOvrJE6q5mcIT/j+rwPGoWgH7YMyaOWwcuT2PlegKnSLwwouxDKmFBlnI6nWO1xqx2/QXduqbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvs2U4n5wCCEmmuF1BI9OBh5eqACnZJt3yUkSGWbHZg=;
 b=yjRYCBk3ydFLJ1ij7omuBx4PBidrHx/DGCPWT4qAtILlFxLcNj7secnjzeXpecsD0KBMFaUHWtlxOZniM3IdiFLfMAmjPsfEW3GcpwMvMfACBj+ELah2GGquee8XH1bLarMBETqTYUsNWl1MbCJETzj7qfHECvFzCM2bYZsDuh0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB5756.namprd10.prod.outlook.com (2603:10b6:510:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 11 Apr
 2024 08:15:09 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Thu, 11 Apr 2024
 08:15:09 +0000
Message-ID: <b7f35443-3b8f-4c42-9583-9944b50ef3fc@oracle.com>
Date: Thu, 11 Apr 2024 09:15:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/10] block: Add core atomic write support
To: Luis Chamberlain <mcgrof@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <20240326133813.3224593-6-john.g.garry@oracle.com>
 <0a9fb564-7129-4153-97d6-76e9b3a1b6c1@infradead.org>
 <Zhch-6XSPYxM4ku3@bombadil.infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Zhch-6XSPYxM4ku3@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0029.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB5756:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c1a0cf0-be65-41e7-c70c-08dc59ff8101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	f1ZLRuESO+MgaitVXGkZCj+Dn2Esz2VrmiO4jYwPQzfJR+WlcHDXOYuAEPVUBXVAka246RB97mUvRLeeSYTjar/vv2xAB1jGHcz1aXkeATH6pKtCcIx4tXUTX8EuRw8D0N/fzDbU76CiMy/gl23jCAaJZmGcPHWqIWxzGFjgN9CwRdPd948nHRCGdER4wxlSRbNeJKiaa/vOMfvhKJgccGqAeBhy+l+2IWuHGHnPmn0nr3xG0SjOumbLBwcoDZXp/DDppMmmbMJdQD8Us+9A1vW/xKd/ZqyNqzo3SPhOqeCW2/f6K58H2hCzN7RW5Ej8cYLFIldDkGqxrE35tJFySdhU4ZyLKrsFgeqPA6gkm0pm9k9pD09BIpvvf0rAViG4zyF1C/db9UfhNsrGcSrKk2JKYWaPUb1+Pi+tWiScktGEvmAnDA+SXmdmBZyLCMZV3kQV9QdXHfvvpq9z7jCq7NMuTM4/4RO/es3WO1lRDNju01UAdHd33N+D0ZUWNPtiK6CBi3SdQKj3flUEn37gP1IkONPfKcEj6Nu1CoeqBXspJt+KyBX/iicvlfpHT2ed9V2oPci+VMPINsSGHHWLe4UO0X3Tk7B6Pbhkwb/kY1C6KOij1gsqek3d5rnx4xso4WNRBOdWkuHCujC5owGtgnTNfYemg3THIC7CKfEy2mI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aEl6UGV1TTF3TGJQbG1hSGc0aWI4WDVSdTNEaEttdEJyZkRVRy9ZZGZYMFgz?=
 =?utf-8?B?eVdVT1ZjYkNLS2RPN0tpUnB5SUlVNE90L3RFbGRBTXBMWllKeW1tVnpQcCto?=
 =?utf-8?B?UjhMWEFkWEJEVkZxT1laNDBEbi9uaTN3Yzk5V3lXY0NUU2lxOEQ3Tm1Nd2dG?=
 =?utf-8?B?NlR2VkdXb0ExOFlrazRtZ0lnUVlFNEh4RGJjZTUvcG44MjZ5anQ5VHNTeVY0?=
 =?utf-8?B?aXAzbHkxTlRwSTQ2ZGZpbUlvc09UdkhsM1l6WVdwNzZDOW5aTHdmdkl4MmJP?=
 =?utf-8?B?WjR3MTNvcFBsTW9mZkZIenhYaE1WcnBhQmFJZFdBT1JRYkt6aVN6TFIzYlVO?=
 =?utf-8?B?cld5dUJuSG0xR0U0VE4zRGFYRDRneEtjTzZycXp1WHFpc2tnZzBZSmx5VURR?=
 =?utf-8?B?ODY4L3F4bFM2Wk93R3JlemdvSEcvMnJkYW10TDZOWXhoZ21xYmt5UUN1WTZp?=
 =?utf-8?B?bkRJZVNRTFlLSUN6MGRtVFkzanFmSVY0VW5EY2k5dnFvdXI0MUF3RkNSSFpI?=
 =?utf-8?B?U09ONUZmeUpGT0NXY0VKa2RGVEdZNWVFdEd3OUpINXRPdTFIakJ1cm9hN3Zj?=
 =?utf-8?B?WVc1SENibDRuUEM5MFd0djk0QzV1THBKMm0yTTNrME9mOWIvSlU0MFp3ZGUr?=
 =?utf-8?B?cVF2d3owT2tEcGViNVg4ZUlsVzIyV3VnM2tXWkFCS3lzakExeXk1a1lwaUxl?=
 =?utf-8?B?bmswSnVibllJR0tvUTlhOGdKTUUyU0RiU3JqMlZ0bkJ0d0FFblhzWkRJVnUv?=
 =?utf-8?B?bVlLQmJzcFJYQVFPOGd4OVU0TWlCVzRtOGNhbC8zVnBmbGhZOTZXa0g0MTd4?=
 =?utf-8?B?b3ZrZVNjMmR1OVNSbU5OaVVGcG4rdW5OR2dDZ3phc0ZldWh3aWpFbEJDbUd0?=
 =?utf-8?B?YWFmamViOXg5RkJBMFpxTUNxc1hWZkhsVEQyZ1lRMWVJVVk5WGNYYzl4Rnhu?=
 =?utf-8?B?VlFkU3dHKzFCQnIrQngzZFB6L0FuemsrbTR4VXNhTkR1SUxtMjBEMXU3VUZi?=
 =?utf-8?B?N3VqL3pHdlA0djJXeGdnVmJjY1ZCczJ1QUxpMXN5WlhVL2ZrTmppTE16dGtP?=
 =?utf-8?B?MGhzb1d6bVo0WTVZdVMrWW9SVXJwMlhxOVlwK3J6ZjRGRlNORHlpdmV0dzdG?=
 =?utf-8?B?V21xTzVHNWFFWStYblhOeGhzNk9Yd1FDQ2dTVmtSeHIyU2pXMDVrUEI1NytZ?=
 =?utf-8?B?VFpBNnpWc0ZNQ1NnVlg4cWxIdnJIY3JKSzh0Y3BsZzIxTXVnSXRwaFdGZFEr?=
 =?utf-8?B?bWlzQXBjb3MxSVJrRDV1M1VlbHp2dVNpTjVybE8wdk4wYVNYVWdadDgrUnhL?=
 =?utf-8?B?bDM2MDJYRU8wY2QzOFJZbkVaVVJiUUhrVTFZbGVQTEJiLzhnaGZaWlJCOFpm?=
 =?utf-8?B?dHI0L0Jwem1OS1ErMlE5M21zRnRYSVFVWmNKNEZTSkxQNnhXdFlnWVRrYzMy?=
 =?utf-8?B?WEFlQ3dDZ2poaUpvWXc2VlYxR284eHdKd0pXM0ljZ29HazhDeEoyZ0JJaFhq?=
 =?utf-8?B?ZFNxb0xVcDdEdEZHd0I4Tjl6TEVNTkUwU3dZU2t1Q0huUzZkL2VvYmxaN3dt?=
 =?utf-8?B?Q1p2MDlaOWMycENWOWpiMkxWMDEvQTAzTTZxb0xLR0VuanhiVTZ3ZkdXMk0w?=
 =?utf-8?B?alNMeXpCcytlTHBXWkEweU1OTU14OWQvOG11Y1l1ZTJkMGUyQ1I4L2pKekVq?=
 =?utf-8?B?NU5CK2FPMWY2ay9LbGtMc3JFWkpJRkVvMFQxblV2alZiOFNVc0ZWMmczSVdz?=
 =?utf-8?B?alo2MXhMRXlxa0hid0JSKzBOWlJnVnpXVXRvYk1kWllLYXpLVDVNdmFCUUpw?=
 =?utf-8?B?aVdNald5Z05tZFhHcHpGLzc5R3pTcnpINGw4YnhpaEd2RFI5Tm0wV0tpcERC?=
 =?utf-8?B?NE1iTENGeHJHcnQ1M29kaGdNT1dtbXl6bEhyMUFxY25lME95Um1RMGNHaDJo?=
 =?utf-8?B?VmJTK2l6UnhjaDlYSFVUYkF1ZVpIVkRESW96NGhkMURQQlJubGdCVWR0WGxG?=
 =?utf-8?B?WTlFMGhrczZIdmNZN3dZWXVsMUkyR2pNVzdVQ1UyM2pDS2wyMXNYZEQ5MUlI?=
 =?utf-8?B?ZjZwTzZuOGR6a3FzYUlzZnJJdm82eGlrd1VjWGFaajRDcWZ1ZHNhOUR1TzlK?=
 =?utf-8?Q?ZNjJqC/teqjo4xoJMI2ZpT295?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	a1C/HGbYTaA3SfWPNgJ42gAkN9vTbilSsx7HNeBNgzcTTS9K0/fWsD7ual2c62RbFijY4Ee5mvgodAFYMCVVzEgeXAKSrEZnY57XWysmPylQOP9NoeJ86SeEAqVhYl36HX5beXxuG+Ak8/VwfpEKmT/MflYm96hV1IDvK/WXq/pE3jgY36YvIMcXoComrcuLmbAnvsh08TCapFFeJuBfNM4ajmIJGHC7o8slMwarQ8cRwTWPLYVetCWJ3RT4iziX9n1bXkY/dP+v2hjzhHPYIQD1aP0t0gEBQJWuitK5ndH9uU8LZ7lK1jJMRCvsp1Hls8O+dqpogs8S5j3wzhmkpY8CzKosadY5wesoXXqK8nYypJ2aaXBfL9eFOOLvUUOZRVNL+Um006nP2RHhJ9vu+dFG/LTNpp968cJSnKfbjJErWXnjHdBO6JIUTMAWsKehrqXpfkI7XnQsmRkvh2AzELuIJa4hIAaI3gJfakVv5taOWOuIRGNlA8/b0ki/1zqNIMgVic6hZSzIB6p5rLnZqftVY3/++dXt2TRwz3tlv9E2dP/S3MLlqvcxzPLO67ZjBPMEQRT/IAzYdBHKvx86aW/+J2MVm5PQwMWK9wAbJFQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1a0cf0-be65-41e7-c70c-08dc59ff8101
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 08:15:09.7682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jK7vFKkWtJoCE6tHNq3WcKK/LR63lXE1ixZqJIJeFGBSwigiSuFhOGDphKRNisigmbqj9BCtMt32jvHTpg5BgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_02,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404110058
X-Proofpoint-GUID: YHbePlUUmZM5jIyISx7dFsbS9woj9atJ
X-Proofpoint-ORIG-GUID: YHbePlUUmZM5jIyISx7dFsbS9woj9atJ

On 11/04/2024 00:34, Luis Chamberlain wrote:
>> On 3/26/24 06:38, John Garry wrote:
>>> diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
>>> index 1fe9a553c37b..4c775f4bdefe 100644
>>> --- a/Documentation/ABI/stable/sysfs-block
>>> +++ b/Documentation/ABI/stable/sysfs-block
>>> +What:		/sys/block/<disk>/atomic_write_boundary_bytes
>>> +Date:		February 2024
>>> +Contact:	Himanshu Madhani<himanshu.madhani@oracle.com>
>>> +Description:
>>> +		[RO] A device may need to internally split I/Os which
>>> +		straddle a given logical block address boundary. In that
>>> +		case a single atomic write operation will be processed as
>>> +		one of more sub-operations which each complete atomically.
>> 		    or
> If*or*  was meant, wouldn't it be better just to say one or more
> operations may be processed as one atomically in this situation?

"Or" was meant (thanks Randy).

I think that we just need to say that the write operation will not 
complete atomically if it straddles the boundary. Whether the separate 
parts of the write operation which straddle the boundary complete 
atomically is undefined and irrelevant.

Thanks,
John

