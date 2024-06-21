Return-Path: <io-uring+bounces-2318-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 359B19124A8
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 14:03:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB3AA1F2485B
	for <lists+io-uring@lfdr.de>; Fri, 21 Jun 2024 12:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86111173328;
	Fri, 21 Jun 2024 12:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mOp2PCXd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jNdfvYZf"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962B417278D;
	Fri, 21 Jun 2024 12:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718971402; cv=fail; b=Ly85wETGmr3f/Zr/QDMMidGlbAbqfBrHrs4931WKUfPExIGz0aLrXThs6z61xiBn5Cyf49j+psGnTG2t9+BW3Zga+HBwYWyZIzsqAsLaI8mxtN2+L5N/uhSAUdEYJ/byFmTwoWLZ/bGK4R/909jOY7kaoLeEXOYy/GUp7o3mFnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718971402; c=relaxed/simple;
	bh=WwGmgFVaDqMiiiMZXLuAmmM6FuW1x3/CFAa7EiL/FPA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AWvUtS83rd4I40yDNEZvXb51jWwyxBsVVQWPz/+3Sxg2o6Qj5icuDtxsViLbROSwB4yxUu0FehBqUBBwjlGTaOdyyxLJI7ZZbq4/jh58I5cUnvZ298kveJUBxFDv5t28oqXJap4VSqA0QKlXgTQ9NDetw/3W2PXxL2gHUpkiX+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mOp2PCXd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jNdfvYZf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45L7gCBk009008;
	Fri, 21 Jun 2024 12:02:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=Ux8fwLzk17dMizXWzsn9pr8RY8fEoNZuy7VOf8sQHkk=; b=
	mOp2PCXdOLHTj4i4gft2ddsC9uQuPbej4fwY4uGrNTldxQadQIp37wJ/zGjH8muo
	cZDEcLTW0Fjf8gw+AZfw+icnV2fn/d5arZXFhZ2K7Q8NicTaTzMddTqHMXsqk8CQ
	JI0t8YPcbCs9hQEPFTWPdBxPUv7hZq6SJeDT/npctHvU4DDGB2xbiVkdHN0oCZhw
	LfgRCMAMLsLIDdC5n8uL4ACPjq0Mh5moPcwVoYbDoT2JXS/1r5APWfIFwyFjkTiL
	cWLC/+DAns1lx4wganrRD7gzgAFetMY+n7uJQdSYrN7ziw8jLFEs2QyHfJh/Zpqx
	QqZCIeKqRxdbcy3t01Km0A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrkf9jhr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 12:02:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45LBYlPg019425;
	Fri, 21 Jun 2024 12:02:46 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrn3r98a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 12:02:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbTtqmMHa5VYNLEUxXaR2t8CLVPdeIzkT9IbCi5eB+xt0eBSGH9xhoXDdG+VHow8eWSn1tyYgqe3tTAwgNsS/EN1Xk7G6AdEeLwrKmfnPHuIdWrrrcglIosRpQTzYZn3RWVKfgsoSNEXGaU4TG7xQwzHZ25Hu7rXd313UO87akeYxjlmmybiPmHlVszpTax2uk4bNxDs8lNrjnuN8jr9i0oq/nQrKXTD0L1USZ5+E0dMi1Ce3iXNSt8s9nswmwmjO59tY5h2xrEQxjZk5DbVCykRLROyUX3qvjtMfbvZaKiqAHmIOqZ954qJtPeiuhaG0RzRjNne83+48vsge6rvVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ux8fwLzk17dMizXWzsn9pr8RY8fEoNZuy7VOf8sQHkk=;
 b=OTAp7v5wFbvRdEhZNZ4lG7p7lAbSzoqCLSwsYBfdoGjOzpfwPzcNwaVjCaXGeMWmcDErTxliEVIQ3rZy53qVYF125kxXepUXR6+VOqjyoobBL+Q3V1LYmBnzuRC0mB2T0o0vh8vZ9GNYL9e89LgEGP2MpXgGvxfd5vlvWcJIBmq22fSSf26XDnpYUsOpHaa7AGfRyQMUxLU1eR7Hz8XwfqX3UlhkQgtmLaA1W7TltM7qmf6Ug7K/xppfXgUpX60BGt9jggmJYuyq9RNu9EYMhG7h/moYZf3VOss/0XnXcsVclT02P41M+paJnXK4qhOF3jIOCffMgfsGdYSvPyiHKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ux8fwLzk17dMizXWzsn9pr8RY8fEoNZuy7VOf8sQHkk=;
 b=jNdfvYZfFQoBwK4eaI/ZBUZA7LGxGrFluh0KphLsf8Q4G1TVKS/iXKFptKD1xi1yrYIHGu0POvVFi9DjodWA9JFurW+GL3dalas07vc25DlyRmWm4TlvWxAy1h8hpjAd/9VNd9exzSKTOeryXQrkJnq7b//0Ov1qvgizE/EjXVk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY5PR10MB6096.namprd10.prod.outlook.com (2603:10b6:930:37::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.32; Fri, 21 Jun
 2024 12:02:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 12:02:41 +0000
Message-ID: <d3332752-52b1-4d24-88cf-3b5e7aa4b74a@oracle.com>
Date: Fri, 21 Jun 2024 13:02:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v9 07/10] block: Add fops atomic write support
To: Hannes Reinecke <hare@suse.de>, axboe@kernel.dk, kbusch@kernel.org,
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
        dm-devel@lists.linux.dev
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
 <20240620125359.2684798-8-john.g.garry@oracle.com>
 <680ce641-729b-4150-b875-531a98657682@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <680ce641-729b-4150-b875-531a98657682@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0095.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY5PR10MB6096:EE_
X-MS-Office365-Filtering-Correlation-Id: 912a2889-268d-4fcb-e18b-08dc91ea0d77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|1800799021|366013|376011|7416011|921017;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?bGZpQjgwd0NKMGRiZGR1OHZuOHVlRS85SG5xNkhlallUVVBJZTBoY0F0d29P?=
 =?utf-8?B?TTVRaVhjZUNyaDQ1bWN5bU9kRzMzQjc0QmRmOUlKa1pqSDNkamhIbDRTamJi?=
 =?utf-8?B?TVhJUm52cTZMUzNNMWRLaEhsbWw2c0hrMzhOY1A4RklIMk5pWVRrV25vTzNa?=
 =?utf-8?B?RHJoaGN3SUhBOEJWdjczUDYyOUc4KzBVZkVxeEVuMGpNak1IUW5FdW10N1Nl?=
 =?utf-8?B?eEVWZTJuRzJrV1k3ck5NM21uYjhXZzNxZjRKQTd6bUtjNENpb1NNTERQS2Ro?=
 =?utf-8?B?akpNZWFCWU54VTBnR0RBdUNCSm4rdnF6Z3Njak9nVE1GcHRqVmZFU2FVMCs4?=
 =?utf-8?B?QWRrMm00VUtvRG5pOXc1UnptSEFGZjlVaUtMZWg5anJlTlJJaVFzdFAwUDk4?=
 =?utf-8?B?YTJKWVFLUjBPL1FvdVNucVNGQUQvVjhLRDFSSTQ2OXMyc3Vpcm5Kdkh0ZTlB?=
 =?utf-8?B?WFJ5N0REZUFkZmdNemQ4ckoydDVJeUdrbnMyQkdwUkc0MGlneURvbzVSWFF2?=
 =?utf-8?B?MVFPTnlvc2pvZDF2a1JqM0RyOVVoR3JESG51dkNUeDdTd3dNbWtQVWR3Wkhw?=
 =?utf-8?B?TUVaeVh1czBmTnFraWtsNCtvblFmMXpHNXk2RnpoMStUMUZUN1NMOHR1Zk1u?=
 =?utf-8?B?OVlRU1JIemw2eEFNNDAwaDA3OW1WdHMxSzNUbXoxVy9yZGRCS1pHd2dtN2M0?=
 =?utf-8?B?SjVJK0k3SGNvUlJHQlVSdkJiMmRvVmZDMUMvb3cyK1VoeUhBSHRVWW55UlNk?=
 =?utf-8?B?bGpGY1NkRVZ0WFVlTW9FQ01QNCtSRk9POWJkL2hPKy9mSkl5VDcyVDNlN28r?=
 =?utf-8?B?bTVxL05Hd2xSZTFwQlVmdlZSVmxseisyR2FEdHF6bGhuaUNKOWJrL2t6Zmoy?=
 =?utf-8?B?MkNlbkY1VExleTlKYkN4V0IwR3hLQWdhYXUzSXgydjFYN01FcWdtTW1rZDdj?=
 =?utf-8?B?T2VaSXhkUEIrS0J3dlZiMVNNNGpVQ25UNTJrRkR6anJTM1E4YmROc0liSzhV?=
 =?utf-8?B?eU9jcjRHa3NnL0Y3UkwyckcyQVA0RnY5dUtYWW51NHFOSWxwTFc5TXBQVE1a?=
 =?utf-8?B?NHA3aE1zdHcrVVdoZnJndmFXa0YxdlVxSlV3dWJOcjdETlRXdDBScVZXaGFJ?=
 =?utf-8?B?blhEN1FHYklCaDI3SE9yaTJRNmtXMjZQSERwTEh4ZmRreDN5bGVMYUIrb09Z?=
 =?utf-8?B?MGxOZllMNUpYQmE0Z1N1OHpBMmlQcExFSXIwOXh2OXJzUEcyb3pkQmszVFVx?=
 =?utf-8?B?Um91eVVJM3orZ2NneW1sRklNYVJaR2NhYVpZUmNpMm9KUmVMQys5dlFQTjRo?=
 =?utf-8?B?OGlBR01nNzc2NzZ5UEd2T1hsL1d2QXdGdVdTSjZ0cjRZMHZJQ1V4MXlTNkdW?=
 =?utf-8?B?Q29iTE56cEpKaTB5VEFwSDNPc3MvelZJVTRwbHhHU1hER1EveUlqemdIM25N?=
 =?utf-8?B?VXkwRUdHbTZjbXhwZmtWdU5yVnJTN3gxYSszS1ZOeFl5dEhDTVZ6ZlJoQUdW?=
 =?utf-8?B?TVIrbS9OMUpzMEJleENaTnVrbFd5b0E1NFdFMGl3L24vbzljNERvOVdZdXlW?=
 =?utf-8?B?N216ekc1TjdQaXR1QXovWkphZ3dzNnJOUzdDeUN0Rm8xa0ZtdE5NOUJZVGs4?=
 =?utf-8?B?d2s2dlJCblRXS3BxZURsNkUrWjk4S09xSGo5ZFF0c1EyYWxoUHFCTEZpNFhq?=
 =?utf-8?B?c2tSUDRVOFplNHNsL2hHd2loVGhyY0pCWHlZWHVrWm4xdm1YbWVqbExHR1Iy?=
 =?utf-8?B?bGM2NWhXYXJsTTQ0RjVRZ05mVUJtL3dNNmgydUI4NjV3S0xFZlc0bUJDRWpk?=
 =?utf-8?Q?mg6ykTy32oiRuvT9XEPi/0WWn1p3kuu/RkrBk=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011)(7416011)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bXNTbnpvdWlURzJrNlJSWTVyZnhXOUJWQ3Rxb292eEsxalQrN0IxUG1SUC9W?=
 =?utf-8?B?WFJzYVQzMFRTSS9lSisyNXVxWWVmV2lSMWdYTkQvR0pNZUNnZW5vRGxNeFdw?=
 =?utf-8?B?ZXBsVzZxTTZGSXZxYkRzTHpCNmFnOW9FUHE1OXhNOSt2eWdwSDBxaDQ2YnFn?=
 =?utf-8?B?SS9kVER5bFZJV1BxYnd0UUZlaGRwbmo2ZFY4RXk0M3dpWFFwQlZPWTRhdjZY?=
 =?utf-8?B?U2VXYXFDUlZhRTdZY1UzZGZvRGMyekF5Q1VQVWlpUzc5WnZqZnBZQ21kUXVJ?=
 =?utf-8?B?UG9Rc2dreHo2aHZRdmU2enBSTzNXWGVVejZwMVEzenpTdjRYR1A0ZHBtYmFl?=
 =?utf-8?B?M2xrdWhJKy9GdCtIUmJwaFg1Q2p6MlhoS29halZlZ3p1Z1JtN3lqMHVkaXNO?=
 =?utf-8?B?alVOTWFRMjZoQmhlYmk2MVJPU3k5dUpqWnNBK2JrNnI2UldJMmlFdmtlWE9T?=
 =?utf-8?B?U2FVRW9OdmN3QUp3QklNbmpmejA3Q2tZdmc0Q3h5cUlzbW9vWkk1ckRsM01o?=
 =?utf-8?B?UThTb3NlS1pydXhmOFhaT1Z2akV4eG1pWmtaNWtzUUF4cWtweWZYQ3I5aG1l?=
 =?utf-8?B?MnYvSjU1R0YxbFJtYlM1QXhyUjJKcjBoTXh1RFlneGsrejJ2ZnRNcFpqRWJq?=
 =?utf-8?B?bFJNQU1kK1pBRk1BRHpmVjkwaVF1cHpBRU43Sy8wMlhmM2phemdsbmtWU1pp?=
 =?utf-8?B?M1RPbG5EOVRKdkdaTjJ3US9VcUNCN3J1M0dPNXk0VEFQRHBiQmx3TS82RzJL?=
 =?utf-8?B?c1hNMzU4c2l2K0pHUmxQUDJreEh2WlBpeVd2UDdranlXT2NpUWtrb1Frd2xY?=
 =?utf-8?B?dzdGSGgyaHlLelk1Vmc3VG1QRVdMMXA3SEIyMndSZlVWN2kxQ2p0WEpyQnZy?=
 =?utf-8?B?ejcrMkxmU2JhTU05RllMRGNFTFZocmdEd0s3a1JxOG1ONHlWR2thNkNoWTVr?=
 =?utf-8?B?T3FzaUdFUFBsYTc5T1drTXd1OGFFenJaMGdHK1E0MEVVODkvTEticE52d0VZ?=
 =?utf-8?B?S3lnTE5iRHVXMHlXaVVFNVc2Z2FOUjFKanlWcGd4Wnk5RDk3UEFGOW4xZU5N?=
 =?utf-8?B?empudVJuMHdMV041MTQ4TUg4US9XUktUM0lSOCtkajBvdGdXMVFEcm9oRW91?=
 =?utf-8?B?bHQ5OEtDdzJ3VUs2NWE3cHJXY0lUNXhXSFVNUGZxcU56ZUErS0x1U0d0UHpG?=
 =?utf-8?B?Sm9JdVJBZjcwZE4yTW1KcG1ZMkhyZzYvZUlmYmFIODZZeU9vRWJVcXFReWtE?=
 =?utf-8?B?aHFSNGZjcjZZOHQ1V0xVWEVnbklId3oxNlVZZ0tOSlBZOS9MbWFhOUIxVEdB?=
 =?utf-8?B?NzFWRDMzZnkwNnlZTlJ2RXdkcjRLUlZpUnNla1cydWpiVnlSNVZybDZnTnBq?=
 =?utf-8?B?SkVZcWZKTFdOUWZIc29xalg0WjFrWitqMUoyeUJBczdyTnIySzJVVWdiVlhs?=
 =?utf-8?B?UHF6alQ2RS94aTdlcURzZjFyMkVqM014WlNsZVg1b1hva1ZRNkt4eC95OG5h?=
 =?utf-8?B?dmtLQ293dmRJZitMckdpK1MzNWZrbUdUK29wRUxTeDVTQ1V4bUFZeVp0RWlo?=
 =?utf-8?B?TXVUMk0weWVScEwyTXB4bWx5M0dHRDhFSTczYVdzaldHSWN6OWpHRHBYTUJt?=
 =?utf-8?B?SmdNTmN6eFFuMzJUNllBdGVFbjk0UUcwK2J0anlGbm5TOUFYbjZSZVg3KzBV?=
 =?utf-8?B?eUlONURmVHpSMVlUcUxmVjFYUVl5anJCQmlkelFpc2crTG9NaGhaY1dwc3R0?=
 =?utf-8?B?eThkN0s2bWJrLzRBMmlHcS9SOVNLc1NXTDZrVVRPbjNLKzRxdFBGaHZXQ3p4?=
 =?utf-8?B?WHJkaTc5alBHRWFYaVI3RStaZnFlN3pDMlFQMlFJUGhNN1V1elR3SjY1Rzd6?=
 =?utf-8?B?cmlyMDhaWjlRTURKZmdOaDRJZ1FvOUovUXZIVEtEWDBDV0pxVTkrcXNHUUR5?=
 =?utf-8?B?UXNreXkyWndwQStXREYwdGN3TUQwdUswYXdvNXpKOStXUUpvY3FSMGJ0RXE4?=
 =?utf-8?B?QUVxaFY1ZEdxYU8yMzJVVGtiYjJlb2ZTdkkyUHhnVWVjN1NENjFXeW91ZFJG?=
 =?utf-8?B?bGN2SzJDQjBRV1p0aTVLVVorNy9NVnpTcjNkMmtFR1hwY2pQVXpkVUZtTVIx?=
 =?utf-8?B?ektTcWUvNDRQcjN5RUtNczBNNEJGMGw3Y1Z4cXI2WnlnZGRWNWV0Ri92SC9j?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	1N9C/jpsG7Bxn+kRXSG1ZCuHAQpqAejMIigXhjIBxIgtsaCTDVabbugPhcTDzoWZKjHjLWUnxEJSvoLWmRHasTyzjEv/aPSwJlr72HHZYE0Q4fZyEhDf+q5SG6icxUzMftwI6IWe7Gyx4oQXgxZhvRZzAQ3T8oe7FO8mteyPGx498Ri6mluzDqrlvapHyIwk5zRlzos40DyN8TMU1hGn+FyKJCpYmmNL87pyfJzZmU5h5xvFjo0NXHjDeBMXI5I79Iaumy7aaJMK7ckL/yt6Dfk28mDoIJa/Q5BrAQuaINVYdAW6NCzrztSZ+6k+okZm796/b8EiBi/cbzWiidM78kRTBM4pa6U2xoSg+c9F06ic2C4/C7Lwfmtn0ExAd/IiOeHupMaKGu02s7akmSowjseAe7oUCNTil42gms6Bo5nUvj7KQJ5YcQ4xtSVDe0KJJh8Qbz3P92XQBW0fApd3mVdxU13WNwvpxOMVL8wmMdRmIn7OezP3dv+SnNEL2oiKMRVKs5dMWK7q0vC/yFf1YIt9OGA0jCqf9KQFQnAM0TrG+xHL/Q9ncSfSc84ax5DLmf4kAyHGDK3bCWt5UPC0G30AhlWHnLW7qKOoqtefrNE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 912a2889-268d-4fcb-e18b-08dc91ea0d77
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:02:41.6389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4G7EIptZ5Frwhi6GAyzi6WL94ECI6TroKPiJsrw57CrO8ihTpQhUMbeV3vod06T5nhD4YjyScB3TYPY1oBR6VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6096
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_04,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406210089
X-Proofpoint-ORIG-GUID: i6nQhq4Ffh-macx2U4vrXJAHMO0y78bK
X-Proofpoint-GUID: i6nQhq4Ffh-macx2U4vrXJAHMO0y78bK

On 21/06/2024 07:13, Hannes Reinecke wrote:
> On 6/20/24 14:53, John Garry wrote:
>> Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.
>>
>> It must be ensured that the atomic write adheres to its rules, like
>> naturally aligned offset, so call blkdev_dio_invalid() ->
>> blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
>> blkdev_dio_invalid()] for this purpose. The BIO submission path currently
>> checks for atomic writes which are too large, so no need to check here.
>>
>> In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we 
>> cannot
>> produce a single BIO, so error in this case.
>>
>> Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic 
>> writes
>> and the associated file flag is for O_DIRECT.
>>
>> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   block/fops.c | 20 +++++++++++++++++---
>>   1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/fops.c b/block/fops.c
>> index 376265935714..be36c9fbd500 100644
>> --- a/block/fops.c
>> +++ b/block/fops.c
>> @@ -34,9 +34,12 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
>>       return opf;
>>   }
>> -static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
>> -                  struct iov_iter *iter)
>> +static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
>> +                struct iov_iter *iter, bool is_atomic)
>>   {
>> +    if (is_atomic && !generic_atomic_write_valid(iter, pos))
>> +        return true;
>> +
>>       return pos & (bdev_logical_block_size(bdev) - 1) ||
>>           !bdev_iter_is_aligned(bdev, iter);
>>   }
>> @@ -72,6 +75,8 @@ static ssize_t __blkdev_direct_IO_simple(struct 
>> kiocb *iocb,
>>       bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
>>       bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
>>       bio.bi_ioprio = iocb->ki_ioprio;
>> +    if (iocb->ki_flags & IOCB_ATOMIC)
>> +        bio.bi_opf |= REQ_ATOMIC;
>>       ret = bio_iov_iter_get_pages(&bio, iter);
>>       if (unlikely(ret))
>> @@ -343,6 +348,9 @@ static ssize_t __blkdev_direct_IO_async(struct 
>> kiocb *iocb,
>>           task_io_account_write(bio->bi_iter.bi_size);
>>       }
>> +    if (iocb->ki_flags & IOCB_ATOMIC)
>> +        bio->bi_opf |= REQ_ATOMIC;
>> +
>>       if (iocb->ki_flags & IOCB_NOWAIT)
>>           bio->bi_opf |= REQ_NOWAIT;
>> @@ -359,12 +367,13 @@ static ssize_t __blkdev_direct_IO_async(struct 
>> kiocb *iocb,
>>   static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter 
>> *iter)
>>   {
>>       struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
>> +    bool is_atomic = iocb->ki_flags & IOCB_ATOMIC;
>>       unsigned int nr_pages;
>>       if (!iov_iter_count(iter))
>>           return 0;
>> -    if (blkdev_dio_unaligned(bdev, iocb->ki_pos, iter))
>> +    if (blkdev_dio_invalid(bdev, iocb->ki_pos, iter, is_atomic))
> 
> Why not passing in iocb->ki_flags here?
> Or, indeed, the entire iocb?

We could (pass the iocb), but we only need to look up one thing - 
ki_pos. We already have is_atomic local. I am just trying to make things 
as efficient as possible. If you really think it's better (to pass 
iocb), then it can be changed.

Thanks,
John


