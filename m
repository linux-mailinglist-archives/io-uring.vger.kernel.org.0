Return-Path: <io-uring+bounces-1226-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA66E88C3D5
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 14:42:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A2F61C38B55
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 13:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E821768FD;
	Tue, 26 Mar 2024 13:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cCsvJ/ZI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MhcfYEhz"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6E712837D;
	Tue, 26 Mar 2024 13:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460421; cv=fail; b=oM9UJa/BmJTMfcw07hKfBFA2lixUuHcKHSmRo0Rd8eScBhSAl5kgXnSNzJj7JnfP4gEQyjEQdO6TNmfIDcNl9MICHtX4Ff88Px4jzAZnh7dkIaYHpjvWgegXw4MST9s5tDTvmVp2ZxponPCDE7VAe90uoAynil4wQGiw+y9uXOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460421; c=relaxed/simple;
	bh=8ZgCq7OWNblIWSnn7+qFs10Ve/X0QIaRdJdlbbM3VZs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZKHhFY5K58YkJc9uaA+W8aNiu4FpkzX5Ji8X+5WPjQYcPHffw1PBuW2a2vebjlYC8j+c4byQq9Upf03XVgOf7E5s0SP7u0hgCtvH5aDyqmsxYt75SonO9c5tCCHGLoYrFO0Vu+lNyHU0TZc1NbfUvRAxns4ff9887sejPqAC2a8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cCsvJ/ZI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MhcfYEhz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QBnaq4028623;
	Tue, 26 Mar 2024 13:39:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=cYoqx1lscjP84Oi7ok7COOGxxZzLn2MAabwh00gLa9A=;
 b=cCsvJ/ZI5PzvzXrjXYIatTPI+bRKLjoGdZL+7wW4jINgc48SB9X8sWHltpR8yT/HNRCE
 a66tMENXmBIhLDi1YQOQOjC5kHKhiAiRNTWUCM5mGZwkOyzmT1lwV1qBhfSpSLkPPVz9
 Vn63cyuuliazeNWjd04jWflLHskKHSCHyzuUYj8aav4rkPVkOHfibaibHPDn15Ix8fwP
 pFZWwMR99/vWooHe8lP4OKK8pXEo8v4SVrjtQdxaMTFor3yMSWnJgLkVWN8j13zouyQY
 zKlRJzFD6QO9YfYhm/2PXsNDIivEoGc2bbTsuLnyNz6QGFjn6xompk2WarFYN+qYu4hs EA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x28ct4as7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QCMSQ2017583;
	Tue, 26 Mar 2024 13:39:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh77x7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRkMLJuPp76v81o0dwke3wS/BTrsui8p1BN1sFTPuQ+w7Z3dsD5QqlheSlf+kXLXVItjYJXWCaws34RYXSekNRy2o5UqMixh5Imveth71unOuUXncAlbHxUC1nBdCyof4PoLKgqr6BSJ4+VGKQOczsl7BLE33LFnh289An/LaYdkNfXNIbRKs0EZ3HbChaooh+bYNUY1LPTMBxLsKVmy20GQgkZ6nN4hEbXg22+g6g20/p9yIg8Zt+ksACFMSPmgJAOlUIMbrYft7AExb8c3UcfeWHsi+0+Z08Kf/QZqaD5t7BuEg3mwDNF8prSIUSp+pR1AapCDwv0vkVLeuSbl3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYoqx1lscjP84Oi7ok7COOGxxZzLn2MAabwh00gLa9A=;
 b=RQS6G6JLXLoi+nHsq6whwXQhLySvvFXEsvpSdyUJiUco6iWp+r8eH2z3zXBsQXo1Lk6rhUYhNDJR2plqDanWu7JBRDYTChUtPZ/brbEML3nf6l8qfxgVtHizMMiEMu1Lynf7MvB9t/MP6qw19GgR4jY12Hl/eZLQrOLcx7xylwCrqoD2zv5yGGa5Cp8e7ZfuNutOBRN+rkggtmHWlp9+naB1ndNIpQuRkaHCHAkUpTngqxQSlS1E75fiopcuWAr2Vsg/OcpMVFzZIhK76r5nWUPNUdFT7QDJpI0NGVo1zdSecvmYj6Pv+XvLF8PEppG0npm7YCGduhg12BF++qpepg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYoqx1lscjP84Oi7ok7COOGxxZzLn2MAabwh00gLa9A=;
 b=MhcfYEhzCyaZRdkrZy4gZHA+iv4ivHVHxTqcpGpfihpFZDRJ85hF4sDP+/6SUNTFCTBLUC3fWesvGKdBN8k0euPl6oFBpmVn1dELq7ojSpdFNLxBQH0cuGZtFZ1donPcE1tihiUFiIf32EeHEiwnJ8WJ8/H+9qm4GMND1xIqnDY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4749.namprd10.prod.outlook.com (2603:10b6:a03:2da::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 13:39:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:39:39 +0000
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
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        Alan Adamson <alan.adamson@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 10/10] nvme: Atomic write support
Date: Tue, 26 Mar 2024 13:38:13 +0000
Message-Id: <20240326133813.3224593-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240326133813.3224593-1-john.g.garry@oracle.com>
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0127.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4749:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	18QHh9FxFLWWetY2LN47rI15nhYanVXbdHU2h8byXBo9SAJUxPLhLftvMklD/j61B5ah4plWpoIbHqMoHJE+ocVTUo9I5pUhMmhnNmeO32TqySdp/Eo6NxyeN6QGzExklCh43jnt+jqIEaMKxO0BKPXxwze7+/7lJV5ZPyLWjqMdJ0uQnlLqo/oWyYjw7ZEM3a+OspgLzu4Lvaw5DCvuHHdkcQ4UD40A7R4qjR7AeeywCYjFIgxtVpJoiU40oq6i+8xp3B33PD7CrWSYJRRfl7S9yIHhgZ4B1J3YfDSM46buRiTbhTTEBqODClnYtja6HeneHrHsQvz2OJPC20K1clRVb/TH6l8RrcEptXfmIB0LAcFkh+n1hU23hR5pTjpR3oqIq2Zlwvqn8PCbhJil8l+2e+/I9LWJ7bEdrRV1bCD4H57zwv+aR73TV+Sz4QtnBcPmfh/ZtXN8SSssePQqoSGGILrV5bPZvi9y6ixi51MXuXAB+kTzp91yHebaCmjJxXzsxirH1CPMm1I1W2gEKDfdwtAdrQWN0N10EcLOW9upZHxRE+ZvGMw0xYGQaweYxfcQUXD4gztImaJZG9uf2pKerfWN0FKGM2KxOcZMI49BSPmmoZCMUvR1s4xbfMndyZ0XAkc0cXtqqiiz2aEUp/6aRGYEguBayCgIWX/wg0Z8sDqWDni87OvGS4WIoREg5HXBi3Lh9XHg5xqQkCSeGw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SHd0Wm9hdElyaFdHQnJFaGVzN2pKWStRTU5nK2NwRTEzclRnblZuVStYdUxE?=
 =?utf-8?B?MktwMWRmMno5cDNpa0tWZExyRHVDOTNLeTJ2b0VRMW9PdzhvU3crVVdFU0kv?=
 =?utf-8?B?V0JLdGVORnVIcVdrQmlWRDZTSEh1eEtDTzBmeE9NQ0NOcEJibzlvYUZzQVN3?=
 =?utf-8?B?Q0M4WHFKQytMUFRNdE9BQmg4dlVJNkdUQitYcmFrelI3cFkyVHAwWk9TUEMv?=
 =?utf-8?B?eTVxNHVhaXZqZi9wVmVYRWJpa284OTNWQVJHYmFQTFFEVEZRQUlJQzBmU20x?=
 =?utf-8?B?SlVRRElhSHdFVmZ4L0ZDMlhBczhCaE9MVkF5bGtJRE5TRGxuV204Zk10TnU1?=
 =?utf-8?B?cmZBaVBwNmdveTVtY3lsR0ZDQTJla0JXa2p4bVdJSEtXREYzR3FCMUVqdU9P?=
 =?utf-8?B?eDZCRThmajZKUTQyM0F2NWkwR3hMOXkwTjlCNG0xTzZXUmhxaVQxTUlQVzU5?=
 =?utf-8?B?VVUxTTh6RUJXWUhBNHRqd3dYejk3b00vNzlhbXp3UWJhaGwxSm1VbUJJc0xu?=
 =?utf-8?B?NmNhZ1pvNm5qMlE4aHhZaTl0cE4wOWdlanRNZTJjZzdFMUxPVTJ6MWFtWVJT?=
 =?utf-8?B?aHZPbHBXWkVMSUZ1MFkyMms4Y0dRbmRNMWRrTkxoeVVGZ2k4Yi9uNVV1QS9Q?=
 =?utf-8?B?UW9EcVJ1RitnRkVtRlRab0VNTG1LRWtQMThuNW83eU5WaW9wYlVrWG9FYmI4?=
 =?utf-8?B?c1lJci9pakRIY0RQUi9tRFRaRnlmTVRSdVp5S2N5RlVybWxabEdHVmxmRmVP?=
 =?utf-8?B?MEY1U09mYVdRWHhiVk9jbXJWbklCWm5KdlcraHMzSk1aNGZnYkZJNUlRczls?=
 =?utf-8?B?VHovd3lnVnlMc21OOE5MZFZjTnBMK0pzaC9hVzRRRnFNVTI1RktnVjA3RjRz?=
 =?utf-8?B?RWM4NmpBa08wYkRob1AxSENzaUw0KzNmb0lldS82N2FXWU92MHNmL2JBRnRY?=
 =?utf-8?B?SHd4YVAzaGpKT2ZFbzhuSXdYUW8ra2I0SnI1STRnYW51OFZRU2xjbzUwdGRi?=
 =?utf-8?B?SHpldmVIeCt2L3RFa3E5M0tFdkFRUXAyZU9wNmJ4Zi9pOHNhUFhIQUVFZTE0?=
 =?utf-8?B?RE1Ib21DYkY3dm1TUTU2US9WRStDaU5rOENjdVQzYlpjc21SczFrMHAxdmZi?=
 =?utf-8?B?a09wVWkyM0tCM1NtZG9FK1NsWDAxeTYzTlVUUFFnbWYyZkhqYnRLVzRHMUdK?=
 =?utf-8?B?MkNrS05FQ0h4cnp2ZWNJYVlrMUx6NXE0bW9EK2piOG5PWUhqUG16V1FrQ0tO?=
 =?utf-8?B?a01KYmYyL2NIUjk2WmtQZ3lkWHRiS2t5emc4b3grR1Z6OTFDSkMvTkM3TE1h?=
 =?utf-8?B?NmdpNG9xZC9uQjhNYnVGZFdNS1lWNzg3V3BkWmNPSG50TEhJZ0ZxOEgyV0tB?=
 =?utf-8?B?U3lsKzZrSis2KzcxbmNYSXAzbUdzOVdkYlJTaGlTdnhNQ3RlSWRHUVRQMVRq?=
 =?utf-8?B?NDFhanRoZWl6dUdiZ0ZkbkRvTmE1VkVQb2pDTWdodTd5UUY2TzVtSTdtK3lo?=
 =?utf-8?B?TGVnZlcyUHhpZDR4OVRFRTBldklHWUNYb2VGb2FLT3VkTnlXdFArd3ZneU5Y?=
 =?utf-8?B?OE1PS3o1ajNwL0t6Q1B4N0FkR09BaGxhSU9rWlNTcHpBZnJTUG9Pcm1pTDE0?=
 =?utf-8?B?bnhlQ2l4TStXSGxsd3gvbmZvUi9jelhPd2VWNVErSVZCemRSYTd4QXVteXl4?=
 =?utf-8?B?a1IyUkZ3SElNWlFWd003QktPWEZNa09kRjhhMWcvQzljZGxQVEVESkZ0bWdq?=
 =?utf-8?B?alVIV0hkNlVVQ0VYMlY3VGh2c0JwSktENXdRV2FPNDdjRndBdVpyb0V6eHdZ?=
 =?utf-8?B?S1BSTnRsUDBIRk1QL01wN2JOYWwreTFhTy91bkt1ZURVYWZadzdrMGRING5U?=
 =?utf-8?B?d1NkaTdzRlpSbnE2STBHSld4VXdMU2E5Sk4xQ21EOExkVkpVVHFsYWltSjg0?=
 =?utf-8?B?TmZWck1Ca050aVJYNi9xTWlHSFF2c29SLzhuSDZyRHI2ZmVaV21ldXBmWXVY?=
 =?utf-8?B?YUR5bHQ1UTVEWnZwUXp1RHJ6T015K2ZCZ0xiQ3JDQTN6TGdWcDQxQ2NVSnpa?=
 =?utf-8?B?dUpGWWxEZDh5dnRPaDd1MlQ0bmpPWWszVW42WGVJbi83Y21YYmozUm14MU5x?=
 =?utf-8?B?WkUxbzJzV3hTZWpZOWVPTHI1Y1VpUXgvM3plcnhRQXF1QWEzZVNsV21XL2x6?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	9k3OiIHe8o/35wJkFAwEOE7ewFS/V24E/74BOY+aRdozcSSsG8fhRMhxaHLAMPjXT9iLA2uiGK8umCxEy5jqS7RrVjJw6eRJYB3MvdKe+grbiHudi14ViwCqJAqKHon6Lkxo2usVHf1pSXgGWiYvyJFzXgE8Y84/08rB7bMC8/3VCYgJ6twAFn2NMCEOx0dFEa0J9bOe1h1mlR4TJjIHzv9v55jL4zDZNEzZCC3ztH5aNaFfeRcNNtiAcTvZys6eDjQRnx3A/aVRJm1PF62g5nHkLJIXdsKuo3zsx4cuxlDahsUcjwLuWtA9QJx4bfUsKK3o/EwW01Mjt3kKhBNqzXb0D35uAuEO6uXrg2sy4CU+TodCH+qDfiWVAGYv+h0YHX2n4pdPfvqew82r1sUM4vwzSocZsS3ydLwqIr/zACv9flMIoMRbZTUErwQNxs1Tfn3e8BRSpFNSMRVs4sUIKAqfmVba47eGCqywmQBp/JHmgAFFhiIgH/VRcaCt+XSiuuvuEHxjSMUAeJy/ftL9feNOu9zCfFWgkP6eYufcfJwkZol3NbZRCA/bWe0IxgsWwAfZ8/Y4/OGWKo/MFwX/eBn+YdoM+m7Xg6YWHY0kric=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8030e97-e752-4cff-3aa3-08dc4d9a2f30
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:39:39.2597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tyN0d/A74pLbYrmm/0WIZMXu/4/cG2rzt8veRrKWJvqxCrNGjj4nvAHU0I/0w/ArGdyOyHe/ZuwrcdaefJAC0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4749
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260095
X-Proofpoint-GUID: zXu65VB0agSt0MgYp9sgV2J9-kwlc_cD
X-Proofpoint-ORIG-GUID: zXu65VB0agSt0MgYp9sgV2J9-kwlc_cD

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
 drivers/nvme/host/core.c | 49 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 943d72bdd794..7d3247be5cb9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -943,6 +943,30 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
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
@@ -957,6 +981,12 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 
 	if (req->cmd_flags & REQ_RAHEAD)
 		dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
+	/*
+	 * Ensure that nothing has been sent which cannot be executed
+	 * atomically.
+	 */
+	if (req->cmd_flags & REQ_ATOMIC && !nvme_valid_atomic_write(req))
+		return BLK_STS_INVAL;
 
 	cmnd->rw.opcode = op;
 	cmnd->rw.flags = 0;
@@ -1937,6 +1967,23 @@ static void nvme_configure_metadata(struct nvme_ctrl *ctrl,
 	}
 }
 
+
+static void nvme_update_atomic_write_disk_info(struct nvme_ns *ns,
+			struct nvme_id_ns *id, struct queue_limits *lim,
+			u32 bs, u32 atomic_bs)
+{
+	unsigned int boundary = 0;
+
+	if (id->nsfeat & NVME_NS_FEAT_ATOMICS && id->nawupf) {
+		if (le16_to_cpu(id->nabspf))
+			boundary = (le16_to_cpu(id->nabspf) + 1) * bs;
+	}
+	lim->atomic_write_hw_max = atomic_bs;
+	lim->atomic_write_hw_boundary = boundary;
+	lim->atomic_write_hw_unit_min = bs;
+	lim->atomic_write_hw_unit_max = rounddown_pow_of_two(atomic_bs);
+}
+
 static u32 nvme_max_drv_segments(struct nvme_ctrl *ctrl)
 {
 	return ctrl->max_hw_sectors / (NVME_CTRL_PAGE_SIZE >> SECTOR_SHIFT) + 1;
@@ -1983,6 +2030,8 @@ static bool nvme_update_disk_info(struct nvme_ns *ns, struct nvme_id_ns *id,
 			atomic_bs = (1 + le16_to_cpu(id->nawupf)) * bs;
 		else
 			atomic_bs = (1 + ns->ctrl->subsys->awupf) * bs;
+
+		nvme_update_atomic_write_disk_info(ns, id, lim, bs, atomic_bs);
 	}
 
 	if (id->nsfeat & NVME_NS_FEAT_IO_OPT) {
-- 
2.31.1


