Return-Path: <io-uring+bounces-2070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1512F8D7612
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 16:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27A991C217B6
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 14:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A426B4EB2B;
	Sun,  2 Jun 2024 14:13:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF404AEF7;
	Sun,  2 Jun 2024 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717337601; cv=fail; b=lheeeUrKQ3mqztwCyPJvuGXMln5/lNvTB88dAmFjQ0uTQ7bysngzAxbijhaPRS56FdQwof1ix+KmxMNk/oqSmbCuTniicG1iOXJ37hGhI3aD8ANBWQj2tc2xNZGJ5n9njFJ0pO0x11I/kQ1A8DD7cjUjloQYpJldb9BSvkJL7FQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717337601; c=relaxed/simple;
	bh=cs1lAGOXS/s+ADTn4gc+U4ZLgh0qsu65lnSFfvqb0gY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d5YZ1IecsWTsm42hXA3QNLorFxOxrwNR/0eUgpLAfvKx23PVnQQkPWZ9OeBUg8nvwLMS34MsEgw+cg/sOBBRLxJfB3P/lzu9U0ObUbW2KbLTBuXQO0vuq8QAmk4ME2DUkfrcB3fz5x9ylRB4zXv/lPoiO4pb1/wywgVuqBw1vKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4525vkdJ010962;
	Sun, 2 Jun 2024 14:09:47 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3D3x3fBTARvcwImSuH/7giSev2Encuy8FIb/yqy3w5BkE=3D;_b?=
 =?UTF-8?Q?=3DNQYx0td/9M039UTeDr0SbaR/la+RE1EQYygzSVcpHc9/FVbVjCCstN3uHk0h?=
 =?UTF-8?Q?3eqR4uqK_J+aFxnXBbEQDzsSggfL3qcCytnNCxPNMmhIz2J3IQCVseFW3NjISRU?=
 =?UTF-8?Q?plSRrjfRMduiGU_juVVDHM5Eoxrz19VlRw3BJtiEZZ1cmxmTym3TGgYu1LH5D0I?=
 =?UTF-8?Q?kJHRGegSso32oDHnPnAq_jhLQKbtBftJ+Ra8jGi9650DrndNiq1VAt32v5J0cxQ?=
 =?UTF-8?Q?2BR0EeTPtj4jVHvDJA2Id4OcBh_hhvt4MwL9d8jHyzQ20lZ3mn7ZSIcnmQG5Tq+?=
 =?UTF-8?Q?4p0KA9qw+JJ+xBLDdJiLSjDY1wUTwJ37_Gw=3D=3D_?=
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfuyu1cm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 452CPQWS003692;
	Sun, 2 Jun 2024 14:09:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrquhb3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbUxhCDNJqH721R5YWLeBn1OQdbZrlea3L24f2OgMfOh0FC9Yr0fV0FXHmEQkpEZdREraE2dcOqAbhCOwEB6H8PfKfUnrQoHL1T28ylfK36nx9/BC6a+PN9qQ6aNJnZRUA1TkE9ch1X1mQmOu9gEPE/iWjgJeyRt7HCSVPv42TEq6JczJPkeoNwCbnp04Q64hManlvGg/dd5GtUZRlFpSBbqfXtacSb2DPg3Ykef0s9RMz/mxdsEHtVim7BBK0BGzZLkAj3/r3nzKQfVXhIvMoNrDfzB3xVxEB+xaphtJhzLA/+9YYCZyzIiutuZ8aVGRlgfl6gSbnv3DdOCv0IYnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3x3fBTARvcwImSuH/7giSev2Encuy8FIb/yqy3w5BkE=;
 b=CgI0jvoAJm1CsVespd0LndsEtf8/DiAsCMuHIpR/5Af32x4CWn9T1l3sNkwyfQvvKUyVW79zkJtB67JuG+o5BV5P3x61iG3aox5eeAOvCxp24tfeG7LjCIV18TmSSj/VknVwe+bKZhqqAt3qIYegDkB8El4IW+ffIgWfb1rPPenhHTj0jlP7EiAXbfDvrSS0o25yhVMKbbfL1n/TCKahAB5JmdHDlIGW+MFKXZHvAmOmdnibV8FE+LvcOKBTzxcY17uvxAl2F2xlmpQZGA9DgCa+0vLad7T9N/hD4zabXNq7hXG7g/zU6N4bZflsTVrYBB6piqI1jYBcd+TrXpgY2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3x3fBTARvcwImSuH/7giSev2Encuy8FIb/yqy3w5BkE=;
 b=Zh8nr3VMRrvjmLZvd60daLcwt5jv9WyTTKJ73efvNZliqRbBDRhRqaMRSLYHBdB9s2i7sbusO2Spu6Sqc5GkkjBFFWtFhDEGdWwwlhmRqXPuClNf9sbyal9ID/5qLdu00UgGrqp1WoGz0+nkAncTfwM55a7sS/6z0XnhPWt4l6U=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Sun, 2 Jun
 2024 14:09:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Sun, 2 Jun 2024
 14:09:44 +0000
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
        John Garry <john.g.garry@oracle.com>,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
Subject: [PATCH v7 3/9] fs: Add initial atomic write support info to statx
Date: Sun,  2 Jun 2024 14:09:06 +0000
Message-Id: <20240602140912.970947-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240602140912.970947-1-john.g.garry@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0175.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::30) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 112d470e-2a08-42dd-e430-08dc830da776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|366007|7416005|1800799015|376005|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?xDnLcn7oxwKXo0YBQO4Zcvz3CMbr3+1pzXgxwhko34WS8ojcpOZ2sdXDF9l7?=
 =?us-ascii?Q?8IgidXoeeVuPQd87ZAiiFTpxw1mNg0lzduhyWhm584XGQnwOcWXlCMLqrP4q?=
 =?us-ascii?Q?P6AlKMmeFRNFfTnF8HTCDH/FGqWZ3w5BwT4ILhA7q6usefreYGKfsdRKfMrg?=
 =?us-ascii?Q?WteTY291+6KVPKRb9Etu3U8MFD6sWclb43e4Qst4CaRKssBBD+32vHZzh3X8?=
 =?us-ascii?Q?ozgalwKPM9s/k5V+i2Ru5/cz/oxgdVfFMINrp4FafKKl3ZK+gnulbh7qt2fu?=
 =?us-ascii?Q?1B5d0MVfMe2GPVNa/zSSSqHOJ7A7zB5c2DJo04kvSKLA7UWP0GPThDY30PE9?=
 =?us-ascii?Q?8ogtUpc4vpd6Z0yjQu07NjdENUab3rfAXUYw287dCnPY2LXy9RI/6TjAKHFp?=
 =?us-ascii?Q?vlz2nG8Zl+OolvYhxvA9laRcHSYJLHJkddoZXjoRWusWJGsLDBlMyqrI+GTW?=
 =?us-ascii?Q?lBefjlYQGiOepFB+B/Pxr2dQDzsO/XZH7NqMKzU1ivcv8HyD2g5pv5AC6DwL?=
 =?us-ascii?Q?rnYPw6OnSBfLevL063DBJJx2eJ8bFuHK1XQwLOMycNBILxEfQW+TFiIz64AQ?=
 =?us-ascii?Q?O0BpkhYG7KF3H+xAp3tjsE8OTLY11/T+xyiBMvg20Mvyg0d8Dss2drvZTzfj?=
 =?us-ascii?Q?bpv9YaPeD1So9/eTULaK8EegFwRUgwTMmn0++qcxBvyhx3ODJvURAccD50Ge?=
 =?us-ascii?Q?VHMQFQNGyzSMHnqfUbw+E/1bw7HmfbQz5OKXsIdWpw0AG8afm91JeE7K1Ay3?=
 =?us-ascii?Q?L11hZmUhWYndn3xnFUoq1dg2xPgkqQGlSiDv4b9InLbZDu8bePnSrNky00Px?=
 =?us-ascii?Q?AzazwJDXz4rS/T0v3m9o8yBVUC9VKkEOStS0IXpqEFtVXFK8j0AERYbaIA05?=
 =?us-ascii?Q?4Euj/aPvUQt/IgBIaL1ehZdP/FW1HKI+qPGqiveh7wFALSNMySF9bRm4etPa?=
 =?us-ascii?Q?vXkw+1XY8vACzymryuccB/D53N27NSqeEEt2gUh5acncVEk1di8cAigs+EjF?=
 =?us-ascii?Q?7iGLaq8YZ3s0Pk+ebRVJRMKYu2W/rw3Kwy/iXvY+FV/HlSlHXn53DwPvA93a?=
 =?us-ascii?Q?sK+eNRNfyMrC6aUEKCjbXw4yCldmWmHcgAnVs1I4awpgpvq0XZ1W81h2NZC3?=
 =?us-ascii?Q?MCqhztIOSQS+V5aw3EHZyGaI01u0+hGajx32l8TS7Kzmx8wmj58qdvlg/bqa?=
 =?us-ascii?Q?DSxzU2v8JiEVHGxDE+Sqz6hcGnNlfKZC1PwdEGfyMBztMgMMfAFbqzPMiHTk?=
 =?us-ascii?Q?4bdsJALU87+AT6YscqUP8iK6YqOwDFDrMxn5Iiv0ZcEEsQjdD/b9x0RkD5Bl?=
 =?us-ascii?Q?YwMct7iicqOiCMsZ6adqasW4?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?UqaUQYcgXHA6CRwodNiZUqANwYzKbzHffFjK/zJiQz3hQv5214fSniWwYzn1?=
 =?us-ascii?Q?GCelmeYINtcS8gfbMnu49AMa70KTTR1i07FKXkSVH4ZCv+n86p+i84bXSq8a?=
 =?us-ascii?Q?yw+4jFfUU6gTQdRFwLaCWne8CNBmJSHr3Q6dzD2vwB8OaEFjqARgFP8m5DoX?=
 =?us-ascii?Q?SGFrViFhO+Z2tiQeD+Kt832ADysMd+2YTZIn9zHc8owYaJFM61Ta+4ovrjKP?=
 =?us-ascii?Q?iQc7iAHcBqLYvmTzR+D13lZEblFFtBVpWOpJ6xgbcb7vqPLm0/JwvUrMnw8K?=
 =?us-ascii?Q?+7uDON9Y7qvT7vCmOcJk44M6uBPfctlZU31xUR6OxVaQ2LL6AUa8434x2FyU?=
 =?us-ascii?Q?SwOa+60jPLsu7dEhazDx1lrWK29a42WgM+eYprdTDPw/cEx/KsZozUn9mzCy?=
 =?us-ascii?Q?VO582Wc80ByndIlfN3/0k+XKv+jyNUe2cMi5FhPf8vhEfiBeHIzxinUy7nVc?=
 =?us-ascii?Q?zt0lA/ZMCZ9ADBcqJWRPe6FT2743MrBgjEHr9CDT1pQ16kKwJNW9swyfKBv0?=
 =?us-ascii?Q?UbQur1ohc/7y4x9o6fOgi0+4q3gSg3yyWNMxMZpF3yaRO+Zj6pb6dvlfrXSU?=
 =?us-ascii?Q?QLnTNZ8vfUbqLHnzPKSYl39tsAk32rXDBs3fKhdwJi+8mIsg6LG9iRgCIzpP?=
 =?us-ascii?Q?zstD71NWP4cUVv1peWxJhVVsi2j7HeSpdsL83FyMikkklYxOtxECUi3cNQKJ?=
 =?us-ascii?Q?dGZaWJIBoEjYazWRnn8UNbnkpy3tanv9V7d0EeAroyjL8MOk4IdKMtZM0eDR?=
 =?us-ascii?Q?7C4FiR5VRQBWTw8xt06iCAp6AFyX7NE5RFr6u7zz8YG5o6fUnbo8/eiBNO2+?=
 =?us-ascii?Q?+cr/0tEE70sZZYMk7y/SY1N3sJu62CkDmRiMr2LY/br7zOUCMWc8RSMFeaoI?=
 =?us-ascii?Q?3Pmiv+v16DNbvDNrgxoBbjnYxYCXhNoMdjPowrQGLF3Wsd+WBrV4t1XXgVkI?=
 =?us-ascii?Q?HM8AYa+Asyyju+kB2mzX2A1wQU5KkUiN905ArVMOPInX5a/64/sAxmutaZXr?=
 =?us-ascii?Q?BacoJfBNXkcJTD6nfESo9/1cQeMpMzlnYuHV9/WBm833HWhG2NL7c5/1+P9l?=
 =?us-ascii?Q?9vG5s7ccu+pe90mR3mWn7vMPeme3ZvaIRRm8Bfl1wocWb13XdRvVd+3xlwj/?=
 =?us-ascii?Q?jHA0Kvbiojs6magHhae7Xv2sTOTDAxt1ZLbWAyKBGoaL8Rnm/wqX7dKAdcli?=
 =?us-ascii?Q?TAu4tIl/rvThlIEju1qF45DQ+UUkFfquec9dqt3FNRYKok4d7DLM/vN8fE+8?=
 =?us-ascii?Q?tSpEf2yDlDDR5gMvCMESOywbZMyDrh3VmIX0P2K9FlK1+hhI6u71bKgyObNN?=
 =?us-ascii?Q?6weowk8bEGbOeO+3N/EjqcYea8xA/tDIFIp1xxfWOaTL+9A9Yr1GdcBd9Ju7?=
 =?us-ascii?Q?aEri8YrHJWvu9TI786iTTM/H0Zzd1e94Wk3d1i97ELGAM0f86mIemN7FoRk0?=
 =?us-ascii?Q?v0l5JMTgti1uPdNv7O3/x26eFKM4GoY+R7gZG5pBiG4zMrtwklW0p6m6XlNR?=
 =?us-ascii?Q?3CLll502OHsX9q5SPJzwLcwCAmTNsMBIE9pj0RxvWVPAt+vTN/t0Al7vwetk?=
 =?us-ascii?Q?xQdtI9yFaKe9tLECWDG8mCJRoVqR0ytp+4G0qBN53Rkshn/fRDcf8cwb1UxG?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	HK05NMy49V/+A7j11XXjvEapzkflJD6X3vDrroRkrBemgDDCxhu7q0zBWm5U5en9GFHpA30cGowM8gtHLso5xkSOOgTR16cp3K7rzQnSfCTpqjVXxmW423FmDqjsChMYXzro+HyatYE3i/5AxmIpBjyevIAxc2+ktnGJKZaDHI4Tm1Q31Ck4UvKwOndlcO4/81APS4QA7SZYPd3KQUlE01JgB3qaoFkwXoYIBkv96SJH+D1XP2gdNTdhDpbj/18yRbs4Z4slbRvAFW3moIP5KrnFw73SZQQ6DcX+zSLLrb+DqrWKj/xnszQJhITXVba82Kh2OA3OV5+7a2+RHUZ4UNsbeAFCDQDHQd/W5Q6IjRPELJ1pQ95HYy/oPRSapzaA+6UhVwbW//Dnwb50QJnvTNlAE14fbZ9lL+ylMY3MLHb1geMn9sH0MyOUKPaY2VMnXdA0vRoaYuZ0ACsp/oFRWeifFbQZtXmg7BLayYMTnsIIbPccagIYmAgDylG7ydQ6zD+D5oPK1lbjHFSDQr9HMwGP1votOWB7PpX962OoQStndOnKU3a1wgCxfo0hI0n78+rN8AgaGy2NkvNbuiRUZuT3Fo3rT57hrkoDTuhv1Fg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 112d470e-2a08-42dd-e430-08dc830da776
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2024 14:09:44.8468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5npuEjeX90N4l11n4F2DgtSMBlwps3Gdc75qGzRhtsO/yKucZDXVCRyXHNLX8V7Mt1RU5U2mMcazsyVFlLHqNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406020122
X-Proofpoint-GUID: ftsO0iz26BdwfI48PCYMUCV_Y1KjigEX
X-Proofpoint-ORIG-GUID: ftsO0iz26BdwfI48PCYMUCV_Y1KjigEX

Extend statx system call to return additional info for atomic write support
support for a file.

Helper function generic_fill_statx_atomic_writes() can be used by FSes to
fill in the relevant statx fields. For now atomic_write_segments_max will
always be 1, otherwise some rules would need to be imposed on iovec length
and alignment, which we don't want now.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
jpg: relocate bdev support to another patch
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/stat.c                 | 34 ++++++++++++++++++++++++++++++++++
 include/linux/fs.h        |  3 +++
 include/linux/stat.h      |  3 +++
 include/uapi/linux/stat.h | 10 +++++++++-
 4 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index 70bd3e888cfa..72d0e6357b91 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -89,6 +89,37 @@ void generic_fill_statx_attr(struct inode *inode, struct kstat *stat)
 }
 EXPORT_SYMBOL(generic_fill_statx_attr);
 
+/**
+ * generic_fill_statx_atomic_writes - Fill in atomic writes statx attributes
+ * @stat:	Where to fill in the attribute flags
+ * @unit_min:	Minimum supported atomic write length in bytes
+ * @unit_max:	Maximum supported atomic write length in bytes
+ *
+ * Fill in the STATX{_ATTR}_WRITE_ATOMIC flags in the kstat structure from
+ * atomic write unit_min and unit_max values.
+ */
+void generic_fill_statx_atomic_writes(struct kstat *stat,
+				      unsigned int unit_min,
+				      unsigned int unit_max)
+{
+	/* Confirm that the request type is known */
+	stat->result_mask |= STATX_WRITE_ATOMIC;
+
+	/* Confirm that the file attribute type is known */
+	stat->attributes_mask |= STATX_ATTR_WRITE_ATOMIC;
+
+	if (unit_min) {
+		stat->atomic_write_unit_min = unit_min;
+		stat->atomic_write_unit_max = unit_max;
+		/* Initially only allow 1x segment */
+		stat->atomic_write_segments_max = 1;
+
+		/* Confirm atomic writes are actually supported */
+		stat->attributes |= STATX_ATTR_WRITE_ATOMIC;
+	}
+}
+EXPORT_SYMBOL_GPL(generic_fill_statx_atomic_writes);
+
 /**
  * vfs_getattr_nosec - getattr without security checks
  * @path: file to get attributes from
@@ -659,6 +690,9 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
 	tmp.stx_dio_mem_align = stat->dio_mem_align;
 	tmp.stx_dio_offset_align = stat->dio_offset_align;
 	tmp.stx_subvol = stat->subvol;
+	tmp.stx_atomic_write_unit_min = stat->atomic_write_unit_min;
+	tmp.stx_atomic_write_unit_max = stat->atomic_write_unit_max;
+	tmp.stx_atomic_write_segments_max = stat->atomic_write_segments_max;
 
 	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6cb67882bcfd..069cbab62700 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3236,6 +3236,9 @@ extern const struct inode_operations page_symlink_inode_operations;
 extern void kfree_link(void *);
 void generic_fillattr(struct mnt_idmap *, u32, struct inode *, struct kstat *);
 void generic_fill_statx_attr(struct inode *inode, struct kstat *stat);
+void generic_fill_statx_atomic_writes(struct kstat *stat,
+				      unsigned int unit_min,
+				      unsigned int unit_max);
 extern int vfs_getattr_nosec(const struct path *, struct kstat *, u32, unsigned int);
 extern int vfs_getattr(const struct path *, struct kstat *, u32, unsigned int);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
diff --git a/include/linux/stat.h b/include/linux/stat.h
index bf92441dbad2..3d900c86981c 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -54,6 +54,9 @@ struct kstat {
 	u32		dio_offset_align;
 	u64		change_cookie;
 	u64		subvol;
+	u32		atomic_write_unit_min;
+	u32		atomic_write_unit_max;
+	u32		atomic_write_segments_max;
 };
 
 /* These definitions are internal to the kernel for now. Mainly used by nfsd. */
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 95770941ee2c..887a25286441 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -128,7 +128,13 @@ struct statx {
 	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
 	/* 0xa0 */
 	__u64	stx_subvol;	/* Subvolume identifier */
-	__u64	__spare3[11];	/* Spare space for future expansion */
+	__u32	stx_atomic_write_unit_min;	/* Min atomic write unit in bytes */
+	__u32	stx_atomic_write_unit_max;	/* Max atomic write unit in bytes */
+	/* 0xb0 */
+	__u32   stx_atomic_write_segments_max;	/* Max atomic write segment count */
+	__u32   __spare1[1];
+	/* 0xb8 */
+	__u64	__spare3[9];	/* Spare space for future expansion */
 	/* 0x100 */
 };
 
@@ -157,6 +163,7 @@ struct statx {
 #define STATX_DIOALIGN		0x00002000U	/* Want/got direct I/O alignment info */
 #define STATX_MNT_ID_UNIQUE	0x00004000U	/* Want/got extended stx_mount_id */
 #define STATX_SUBVOL		0x00008000U	/* Want/got stx_subvol */
+#define STATX_WRITE_ATOMIC	0x00010000U	/* Want/got atomic_write_* fields */
 
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
@@ -192,6 +199,7 @@ struct statx {
 #define STATX_ATTR_MOUNT_ROOT		0x00002000 /* Root of a mount */
 #define STATX_ATTR_VERITY		0x00100000 /* [I] Verity protected file */
 #define STATX_ATTR_DAX			0x00200000 /* File is currently in DAX state */
+#define STATX_ATTR_WRITE_ATOMIC		0x00400000 /* File supports atomic write operations */
 
 
 #endif /* _UAPI_LINUX_STAT_H */
-- 
2.31.1


