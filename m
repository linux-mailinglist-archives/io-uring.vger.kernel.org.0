Return-Path: <io-uring+bounces-2151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB054901FB8
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 12:47:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E56028174B
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 10:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317E38287A;
	Mon, 10 Jun 2024 10:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kW1yM6A6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p00unFTU"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07B978C7F;
	Mon, 10 Jun 2024 10:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016288; cv=fail; b=J1baw8DzXDweFxh1MFD7x4rADFJGpp+UzEEuOTo5jHbuiv1HDeE5Ge1r+7hoJJsqA1AB+HklrpGX+lGlpaRsldMYxaJyh8SwoY5+WjzBFImuLgaukUWeocv6UTVz2QhKETifOrv2yn3Jm5IBX0HbH2EN/L1og35StLJntXl45Q0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016288; c=relaxed/simple;
	bh=2REKH1/1aH+bUNgzT8a7bGP4wBuTGd/jyvCeOusuGPI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pm6x9uk9UZD5gm0KJTHzGQPTuY0BCMBw/Sxfq/sFs3LqZfxg10HVI1h6593Qiu6+fHYtJup7OFxzvjHUZkJWjilGGYaAkjKmb6TW75tWO+oAek6Yg4+Y/CTpBLcE9OSgLd3QVJ83oQ6JoVuCIc1dwL+B6IdSiXoZ0ZD87oqoIM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kW1yM6A6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p00unFTU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BPF2025193;
	Mon, 10 Jun 2024 10:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=Se0yQckEFgV6c0qz2c9mlgxv8OJqOdTuW+nbG+OxEhw=; b=
	kW1yM6A60bYOQjtf3HssMB5HtCT4Jdp7a71zF0TwUCo9nmzrUa3OTTqhRi7e0IKi
	MR4E3QmwEk4G25xuaNL/gzHJRqAP5eHTygTGOMp4fiWoTnntlmFGl2X6cxHerLZW
	HFtazfgK1woWnh60/MIpdrjm/heXZufMIP2oZsPDdPJvmov5z0d1ufZhtJUurVsK
	bTZo2hGaPmsjKDOrUkD55be3Q183MCSPi5w1sReAykvqkTX3aqMApMBq8jxbWb3I
	+Mf++68a6NtlJm0BMJhAo3X3OseSjeZIKXr5QJNVS2lTWoUD89kmI7Qf14AjwFXN
	eKbMZGO4c2VTnuP9sHuTGw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1gaag4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:43:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45AA37Ox020460;
	Mon, 10 Jun 2024 10:43:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncasued1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:43:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+Ox//Ab72Zcgw8IPcaDu8+PDh7bJeRgyPtt/rbyguahygeLi4OxzgcIEjL+W9AvhxDxe9sUH5hDAyBCOBiB2cWefBmZ2fCG8kpFTPYBPTRQCZMXJYjNm5aV4XZXM7uWV0Uc6Rf8eK3Cd+jjcn+C59FrRmN/CY+MlnM6bx8z6wUzX0Kpw20FUFLVEeIZ9GcAoCOkw5wTvkz4hUc3H2mlHnAwbFFZBWI+BRFailnrK9m+igLXEPC2hdlU2d0Q9Q7G6BBPbAyW78qN6Bnop3mCpKvqLHGHuWsuvoB+YR2HuB8J1e1DwC9UqH0h7+jdzjDYGpfQA9ewLfD03dOm37SaNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Se0yQckEFgV6c0qz2c9mlgxv8OJqOdTuW+nbG+OxEhw=;
 b=VygWhANcsblwvR9jSggENppq2WLccd02S9f5aZ++W2IGPpM/Ac9iHmDJg2evTbsHVJunP9YFsdPw6J0nTmjRK/XZEvrvctoNjr2BaQ/v49BeASFgoIeulUV2aA9HDKBqg2olkawzd4aDiTzdgayzgsGHsSyfGKhnnDOjMCQgZDOLyfbJA/tajBGT8OZj1UvbCCkq+Cm960W/EjYHQeQT7jLT0hm40d1WBgidKTdHD1e0Lb0A1lsN2aT/nkqCTfXrvuVs4ODwcAg5Vn0jAGpC3abd//W/SEbXgkMt3Fdgrep84onD68TCqYfzEwUX29b2/ox/5zF7853ZNVOxWrGJ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Se0yQckEFgV6c0qz2c9mlgxv8OJqOdTuW+nbG+OxEhw=;
 b=p00unFTU0ewOlA1VWnxiC4X1bciIWvq/wWOcmyXAvKaHfRlizsgZMJLI3zAa37rnXYfHssvUQAAog6B8EUnDWJzbFeylKUmmMgfcJAssQPa3REUCoOrTw2Mq1ioGc8Al0fEmL+OBu81Wrlv5OaugFChZVa69p27lsAaPaLdhjyE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Mon, 10 Jun
 2024 10:43:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:43:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v8 02/10] block: Generalize chunk_sectors support as boundary support
Date: Mon, 10 Jun 2024 10:43:21 +0000
Message-Id: <20240610104329.3555488-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610104329.3555488-1-john.g.garry@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:208:32b::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 04073c2e-b906-4729-a7c3-08dc893a37e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?RjEouuTsp6Q6BVZusy3spFSNHSZvLQjy2b5258Mvy/4xVneBu7QAWn5glM4A?=
 =?us-ascii?Q?jBeqzO5SdLECmEasrfraXummgbkGLmid47EDfc51NGwENHZPuBfGl0f1npGW?=
 =?us-ascii?Q?jSxSc/IaEB7y5+PJm4ts501i+ArbBRLYdsoimsSZRePW++EeNprVbkEhsJdr?=
 =?us-ascii?Q?TWM0lzrbtu2JUFJAOSQ0I6Nq1kH+GUC4EZ3RY4tWLQ3IbIGkReaoxDSSCKbp?=
 =?us-ascii?Q?3c1K8sWfn0Z54TGECyTz7pUGwFNv11MLjqzFZyp40dkneiNFKc+nwMxyGSiH?=
 =?us-ascii?Q?iHj8LIwKTwR6m8GieOcQS2yZEy/gY5Zyb1YVXReM/viiQaht+YmjESLYZIjQ?=
 =?us-ascii?Q?zQeAzgZdu1AbfPhFovKK3wgYokuRzlEY+fmbcQGeKn50S86cLds0uTQO4lJx?=
 =?us-ascii?Q?s435VV4J4kmVer72x4ny3iEx8AXmPlxilUtC97sgPOo4rNIbAmYmDsmCx1vr?=
 =?us-ascii?Q?lL+LWsAB/X0ypV0IgiHrpzH9APosMHsHt9VRC+Mp5OE0GcDtMzZCe4Avt440?=
 =?us-ascii?Q?GXvu+8rrl9evBSnITvtH008VdRKWcLOBJqlm89cY0jl6G+zT7nmmoz4AGb/v?=
 =?us-ascii?Q?x2MZU6kGRN2c6aMQCFPL8PvmR2IDu1k0QmBOFBIHZh611IUlvNWzqQQjbTX5?=
 =?us-ascii?Q?46O1g5s7Ehunu0e3D0az249nW+N81vVErSaJoARETZMmzcgxt8yFPsN3PbJS?=
 =?us-ascii?Q?Ieak6WH6K8fB5dRlR7+llpQ1aQiy+PCXot13ICU87xHhXiQ2Sc/SrOrGBJXu?=
 =?us-ascii?Q?E1kwGpZXeqmfRq9/3vONKhv2G/jFBxiyTZ3Qeazd+/+QrmrP/AV/siaR/x7J?=
 =?us-ascii?Q?3Mdelzou9AzrNmqSa1DksrmMoPLthkc7LcNyLEJjvkc7h6+K+yJQw+nT/65a?=
 =?us-ascii?Q?1UOHA2sAOXAXziIScVQyxqXkFHrCExWnTMxCvbeU0eFBzx2l2FZZz7OEMRap?=
 =?us-ascii?Q?g/PB7u158t5DcgUk8pWM5ZYhFiRYisu9Aq/YBrYQ26V2x/9OMyEMsk7eKU3s?=
 =?us-ascii?Q?+Hyr3Mt/LhDGtmCf/Qe2gwG6bwkf8a6SgbLRwfjvyFG9rzY3GfSMHyezUq6A?=
 =?us-ascii?Q?eDbhFrskzwxoDtbC6Tpegroc394HPuU5Vl3CZBX0ShUZ8qLR90aREam0xeGE?=
 =?us-ascii?Q?W+utfzY8jjjLku2f2AOdTC3z5KCylmcWVwfQalJh5LWfz0c3GSINF5rkksCZ?=
 =?us-ascii?Q?N56SserUxPnP/oy+x6VeObezNVVdt1Cz72b/rjyU8XYtYnwplpwdmdSzZPgO?=
 =?us-ascii?Q?JwnrbZgIiSw/dPCyOdYAwz21WoQBgUc9wfyBbw1C84TqwEeRP4rrmV88Eq2d?=
 =?us-ascii?Q?pAjFwjt5YQ7ph4z4304lzb1zPe0BxsK+7uyfJt91H8NKK7T6tsyOdOnUCwT7?=
 =?us-ascii?Q?RUWggAI=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?7l+1CBgcHJ9vJa741CYlh6mMblzCdnzncYxYZQ3iOVjElva/EEl96hLH4wyS?=
 =?us-ascii?Q?zVzzDgE4E9GtTyZe6XHvYywNhY5RlCDezhbEa+VePDoO/P9s5Eqx9Tkgl6GY?=
 =?us-ascii?Q?54CiDg7z+STDlaZsB6ep13dAipLCqgE3z1MWOHKofpxE3vFTr6kfx2AGZ2dZ?=
 =?us-ascii?Q?+qK/fpyGo/Pfn9N9vEKgTtIK9iPPj4tpCdgawhg1sg9qGuAWmi5YLy78KXrk?=
 =?us-ascii?Q?/4DxP1HAFPrS4te8c7YP/sz/RorS7ugZNM1pUlUqYFdBW6pDrp6n3tnDaROQ?=
 =?us-ascii?Q?IeQB9LhHAMxuD5fwiqqjkL1l5kVqktP/UJCq8i1P3FxrQLAS4NQ0lznLPJyP?=
 =?us-ascii?Q?ebZpmO7EAle80lqlhNDpq7AqLtjVhH18pxyw+fSTF7Xpb8VzgGJgr+MdJblC?=
 =?us-ascii?Q?9+Fiw0hxesQqQCDVCEBCXxnQWF+VKWgKO0oBv2TMv7HyxnpKb0fn0zE4kPdF?=
 =?us-ascii?Q?uBJVDI0qHqjKut3p5MAelm2RsVLDnIP4IEHKshF+LHzDOsM9P78oaLUm6w2o?=
 =?us-ascii?Q?Nb3XXTIqWdXlF1YjoWVfHTvUs68m+A+Gcsbbbj9seiA1jNgRvH7BZY76w4ik?=
 =?us-ascii?Q?avqbWTrRxchrniUw8sno7XRQ1gz80oIB5VILx7wNmvHJaxGaT0tB83rbViAr?=
 =?us-ascii?Q?13k0X+krWNbthnEPB4Oee18pxxURU9t4KhdGrhON6lP1HFW70dj/gLwbmbpE?=
 =?us-ascii?Q?UyxRo5bwRJwE1mPDQwYOIZAbpgkjaihP1aZvAHNHD2gej5pJL+rpnKp02Box?=
 =?us-ascii?Q?3MnAnasVlSO3esOYDX4TKuOuiIFMVZD6j4aKE7U4pD0xXPa1G+ZosyI/MAY+?=
 =?us-ascii?Q?8N/ecam38HPYbDwHbvUJP8IycUP8YhdUtAIC5dS7nX3DiIQN2xt4ig4GwhQ7?=
 =?us-ascii?Q?CvJEj21ujYHA9kE8sRSbNnrViDf9ipHnFt3/BpRpTSsoIyUZ8cz1C90qcUsk?=
 =?us-ascii?Q?msLnm9N2zUJe7W/SHE4GYG3LXxU1I1+lAK+7Bqzo1+6Bky43DGBXzhfXIUmX?=
 =?us-ascii?Q?OFlvlbKYRe7ImRe/UJ8kT7LAzYhQ2JMnsVWAToRd/LTbu2FN6era4ZcPD0XT?=
 =?us-ascii?Q?dDBxwSHaCE/70nBjyAs0iiqGajw2KHAHFd16G50G2CLMBw0w/oYvP1PONNRc?=
 =?us-ascii?Q?1aRJa/ksGn5nbDqHv/BOq8284k57joydet0kEw/tvTczuunQIGGVb1mBDii5?=
 =?us-ascii?Q?HeIW6OZ0LL8stmAgCyniqg/p47bnYM2Ysxq9bdVFMFwfN2LXTZQOl+T6e5lh?=
 =?us-ascii?Q?vrdYiduy3M9Kug6SiiTaiNAtvGilFLTvfRM8IjiRq5QX1syVtpJBDd7OoG5m?=
 =?us-ascii?Q?4Ne8FnizGiyuQCwp9wTWo1cvcPlpYNLHBOmJli1X/JEnJLAFrByVucsniIzF?=
 =?us-ascii?Q?cR/DXsanEYT4hpCLZ/EcWlSGr5o9kvoe3Nj8wr4kxmWVS4ylq9TbE37RM5eO?=
 =?us-ascii?Q?WiAf/LJlC+2Eqk4yUFKI6wwqZsLM+B8cQm1E3E8EVf57/1VbF926i0pdsBzC?=
 =?us-ascii?Q?sKJZ2SYA+geR6f+HjBSdGBu13sO2RcMkfmaxAw55Fh1tGs7hkmxOSRX+16p2?=
 =?us-ascii?Q?bDRIlxJhOXBJwbKo+lx8uFCZNDJalR5NIw7l+a+QvRDbq9vfuCh633GuK7GZ?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	HvGP5XZ5G/fNaSmWb2PBPkDgq/H7ELydxHL4O499H0l4Cv2ItmDBZobfBSR6LuXyBbvp8PKrXfOSLRH4PpElu5Nlls6k21HnsIlzEkinDL8Xd3TC58oABa+6DUGB7RLDUf7yQWjo4L35RsoDCjpSzJNvVFhOY/KEnrvuDo8nFCWol5FG40CVU5nx/Bi0ql52hJxfumeKAn3hZGUewRFSyxwgMB8u/EcvVWMivq8h/cfK7+QfCj68PJ7bdjexTxU+daG0I1RYUkf9oa30UwRn3Mv9fr7l+LeABpuxyTtG1xWL6gAPLNhRyEVz08TlfjsiJTpaCdAGTkfSbefynD2bFlX3fv1Z8tODOx/HyQCWNDydEtEqqpNwijEnsUnSAnal28PnVAMGnoURAX/qNmtHdKxkmkKcUeHx/JsExTdCGAUT6HHNkxPwFz1sa6ffnR7D1DO4yJAKZQ2U+nbXGjp3GcIFFOnCCZ5Ssb/msllW0Zl9CYBILpE1wrtcn4jl6VPMgZkIR3qAWiaz5VZ62wEWn9U7rBoD5h6WTfo4fLDp9MplEreuoZrGNzZhjqdnFEI0QyotqFj6A7QKNjA39upIv7oKiADjp4sAO8S/aOj1PlA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04073c2e-b906-4729-a7c3-08dc893a37e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 10:43:51.9969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Siuw/y8FIFlD1NJmZZFs66++Q62kDMJu2GFncg2BE6NtKh69bfuVq4fDHwJ8kV3XhZJytIdI3GiijgcOL4Xdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100081
X-Proofpoint-ORIG-GUID: 1t_bsR_n6Mlcw1PlpQzuYtZZMV80vz5K
X-Proofpoint-GUID: 1t_bsR_n6Mlcw1PlpQzuYtZZMV80vz5K

The purpose of the chunk_sectors limit is to ensure that a mergeble request
fits within the boundary of the chunck_sector value.

Such a feature will be useful for other request_queue boundary limits, so
generalize the chunk_sectors merge code.

This idea was proposed by Hannes Reinecke.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-merge.c      | 20 ++++++++++++++------
 drivers/md/dm.c        |  2 +-
 include/linux/blkdev.h | 13 +++++++------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8957e08e020c..68969e27c831 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -154,6 +154,11 @@ static struct bio *bio_split_write_zeroes(struct bio *bio,
 	return bio_split(bio, lim->max_write_zeroes_sectors, GFP_NOIO, bs);
 }
 
+static inline unsigned int blk_boundary_sectors(const struct queue_limits *lim)
+{
+	return lim->chunk_sectors;
+}
+
 /*
  * Return the maximum number of sectors from the start of a bio that may be
  * submitted as a single request to a block device. If enough sectors remain,
@@ -167,12 +172,13 @@ static inline unsigned get_max_io_size(struct bio *bio,
 {
 	unsigned pbs = lim->physical_block_size >> SECTOR_SHIFT;
 	unsigned lbs = lim->logical_block_size >> SECTOR_SHIFT;
+	unsigned boundary_sectors = blk_boundary_sectors(lim);
 	unsigned max_sectors = lim->max_sectors, start, end;
 
-	if (lim->chunk_sectors) {
+	if (boundary_sectors) {
 		max_sectors = min(max_sectors,
-			blk_chunk_sectors_left(bio->bi_iter.bi_sector,
-					       lim->chunk_sectors));
+			blk_boundary_sectors_left(bio->bi_iter.bi_sector,
+					      boundary_sectors));
 	}
 
 	start = bio->bi_iter.bi_sector & (pbs - 1);
@@ -588,19 +594,21 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 						  sector_t offset)
 {
 	struct request_queue *q = rq->q;
-	unsigned int max_sectors;
+	struct queue_limits *lim = &q->limits;
+	unsigned int max_sectors, boundary_sectors;
 
 	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
+	boundary_sectors = blk_boundary_sectors(lim);
 	max_sectors = blk_queue_get_max_sectors(rq);
 
-	if (!q->limits.chunk_sectors ||
+	if (!boundary_sectors ||
 	    req_op(rq) == REQ_OP_DISCARD ||
 	    req_op(rq) == REQ_OP_SECURE_ERASE)
 		return max_sectors;
 	return min(max_sectors,
-		   blk_chunk_sectors_left(offset, q->limits.chunk_sectors));
+		   blk_boundary_sectors_left(offset, boundary_sectors));
 }
 
 static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 13037d6a6f62..b648253c2300 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1188,7 +1188,7 @@ static sector_t __max_io_len(struct dm_target *ti, sector_t sector,
 		return len;
 	return min_t(sector_t, len,
 		min(max_sectors ? : queue_max_sectors(ti->table->md->queue),
-		    blk_chunk_sectors_left(target_offset, max_granularity)));
+		    blk_boundary_sectors_left(target_offset, max_granularity)));
 }
 
 static inline sector_t max_io_len(struct dm_target *ti, sector_t sector)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ac8e0cb2353a..ddff90766f9f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -866,14 +866,15 @@ static inline bool bio_straddles_zones(struct bio *bio)
 }
 
 /*
- * Return how much of the chunk is left to be used for I/O at a given offset.
+ * Return how much within the boundary is left to be used for I/O at a given
+ * offset.
  */
-static inline unsigned int blk_chunk_sectors_left(sector_t offset,
-		unsigned int chunk_sectors)
+static inline unsigned int blk_boundary_sectors_left(sector_t offset,
+		unsigned int boundary_sectors)
 {
-	if (unlikely(!is_power_of_2(chunk_sectors)))
-		return chunk_sectors - sector_div(offset, chunk_sectors);
-	return chunk_sectors - (offset & (chunk_sectors - 1));
+	if (unlikely(!is_power_of_2(boundary_sectors)))
+		return boundary_sectors - sector_div(offset, boundary_sectors);
+	return boundary_sectors - (offset & (boundary_sectors - 1));
 }
 
 /**
-- 
2.31.1


