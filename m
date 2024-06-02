Return-Path: <io-uring+bounces-2068-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A94ED8D7606
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 16:13:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19F89B2299A
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 14:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CABD3FE2A;
	Sun,  2 Jun 2024 14:13:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DC83FB83;
	Sun,  2 Jun 2024 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717337595; cv=fail; b=bx+XlsmD9k0QW42Ul4M85o6Kt1JZWGSYPE7vl8gumLVMyZcN9FH+LGsa3HVNneuWWCAaUtnWEaAKEzRgUvDT9sShzW8JIAd0etWHaoeuwuoahXEkwZkr60Hxhm38dGKTibvkS93hgMUHZPTnQBc6P120IDgn1L8NjwU3b13s08E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717337595; c=relaxed/simple;
	bh=pq9xftascDsyN4kFirLkMyvIYrxZf2Z/Ihozd1v+J8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dqGmSPy/IKNKRdOtt42l/pMIuJfgFSsVHl+qix8VTWQtS4MvEX2ITkG5gmHLiHILmPHOP4Tx6734tSgC59HMyB9D8KY/qA0UPFkrI/9+yDLPATeOoFEGnn36XQ+Z7d3RV8HjRVTZtpGA+SDPOJSBe1/+z1GMIDY+J+AvzkR8foE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4525UKXq020741;
	Sun, 2 Jun 2024 14:09:52 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DTsryy5QZsKmTfyx3TR+aS+FRRVdU7p5NS+M/p8NIQPo=3D;_b?=
 =?UTF-8?Q?=3DXAbUlBrjcpvP/kl81TN50EZXYgQ8qAuQvw4tTC25sCYWE2TGAhwq5UxElqdA?=
 =?UTF-8?Q?7ndY7BoJ_cKjCzepAGzmXCo/eSeXXAfpj1i0YUAcSZQyUCVcIlX4328uMeKvdEX?=
 =?UTF-8?Q?xnLXl0MDyDOczB_8QveaPCyjoCek9qgDADMptWj39a+cs0TyZ89djK5hrR07x1C?=
 =?UTF-8?Q?/z+iFf30KiiRK0ZJOArC_P0mNifm65jOMqQIzGxzmi06jh/5DTh+da3C8AJNRx3?=
 =?UTF-8?Q?3OcC8UPHXL085jqn+NNZ/VBJAm_DdkgIl/rj0JSbhhNJwJ2jnRrxk5n4bgZcvy1?=
 =?UTF-8?Q?B3x97Wef0kGqzPf60iWfxyGLgx958Fdw_Ag=3D=3D_?=
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfuwm1cuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 452CDYtX037809;
	Sun, 2 Jun 2024 14:09:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrja1h81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/0yTVmdayT6MAV5JFdne9zgdyz5cugqunk+lpHYOPqbaNb4TuMR27A1Rq6/+tRKKs8/z6Dh+2RqjvzE9szhHy8qt627aJkTZnjjrKsiecl2oI8s/ZnQuqHzMNcSdLV3EqUqGSZMG2OgVU+3tQD+adzz/imbEEk+lFW7tkv8w+rQDEZkgsVGOreASxJvsMAeIio4TSlrndUpjpoDCuu+tJMwxzMn2RbCsWKC6ACm9X8u1Lt+A+cMd4VMLfRYNQPeASAjp3+YbIzRnmtxO/84MWsw8ms5Ey/GaVjH+0HTam2JgMEjukVHLMDch5OkXRkJp7PWNxaonh5BBCFuOG9voQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tsryy5QZsKmTfyx3TR+aS+FRRVdU7p5NS+M/p8NIQPo=;
 b=ldHyC74Ydvm09SpmTYQUk51eIcpbIp9LEf/2gwDz+NelCafbEOvHgNRitT/ed9YBca6Ufuv9qRAOzs/cB7OAQ6+IavS59uL0yEz2QxhPJBtPLDAcOgIaefyqykW2U3sPNv5ghzi8bbVUvbdLAV3YQpLuE7SQ9BiWst17CrYriDTwklxdaosuK+oFFsdkHyeBfEkgGLVxDhrYiAU0NxYkHGSNvOwoJ8DKyrsGiAVyWhXHkzMNYSqkzFKHJVIkw4JTzPVM9E0xwCVYRY8GbCrKVhgRArDVxn0arHdp3FlLEGO30UAQddNPkrqgMh1gHZysDti7E+0l0/MthAoY4RbV7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tsryy5QZsKmTfyx3TR+aS+FRRVdU7p5NS+M/p8NIQPo=;
 b=ZEa2JbhOjVn/Z8vi1wkDq0i5YyAgMFeKa83soMQmfySmyzv+Qqexy2/0PO7pSxsMY+rmDq7IMOEEJTz6opMhCeTn5ObojXPFEuOJ8DXrOBExs/I4Wzt+9oswpxvXqX2JEyoNY8zDcl1S+mkEUhoqMQFD8UuT9KJ9pNSTx1s2pqQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Sun, 2 Jun
 2024 14:09:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Sun, 2 Jun 2024
 14:09:47 +0000
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
        Prasad Singamsetty <prasad.singamsetty@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 5/9] block: Add atomic write support for statx
Date: Sun,  2 Jun 2024 14:09:08 +0000
Message-Id: <20240602140912.970947-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240602140912.970947-1-john.g.garry@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:208:23a::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 52f33fa8-f0e7-4655-3278-08dc830da92b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|366007|7416005|1800799015|376005|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?jRiv0cAiPi9SRlAWsZlMc2kHfpDVPXuza4C3LzIxpsdqlU02swXbZgu1JT1Z?=
 =?us-ascii?Q?wNkr3Yby9b+olKh7YEYnVDF3Re4u8py7FoyNSQO7RuCIgjx1k9MEISS61Uej?=
 =?us-ascii?Q?iFx2TidfnMltvNPsUkg5Q+6kYUulI48kQixPBPd45rRqgxDtqjtAaTtVOwNt?=
 =?us-ascii?Q?DXvofM6ESzpNdSiDnUZfT0BGKuuwLoGx1M/mDcZfvTaR525xLgxVeOwrf4sL?=
 =?us-ascii?Q?Qi9rNwsWl8jhy+ig45n/zpnrc8DDuI3tzUaE7Y5p3PbCQXZidc6S8MTBg8xr?=
 =?us-ascii?Q?vfUEdWF7CJDfDcwi1URo/PsNuf/brt+0thNCvFxjN/mjY9U1fD9kgo3ibvzy?=
 =?us-ascii?Q?W4FMG/mrUiLOzza6+AMGgVzttdcrCFRmMebb+F0SbDJ3hampYQNn+rDUJ75O?=
 =?us-ascii?Q?FMM0HWKXCGR+ldgxHzDBinRtNgd7uYKTSxPm6h8K6Jrk/7dcfZRvMSPSkpPl?=
 =?us-ascii?Q?kTFfB14nHTSpxlHzLn6pnL54xHaC9bEyr4GcVXeyUVgV6aLl8j2NYIjvzsps?=
 =?us-ascii?Q?PWhwIg47CQbxAQALhoK803e8jXH80CC7AS5SwVb5pPW6SCv/gVejZmy4chNq?=
 =?us-ascii?Q?I3+xlTr3j/6HX99FKcCaCa6liP6adAZAhBSJE/6hRNXywttvXd/8cI6nv4jm?=
 =?us-ascii?Q?lGnz22ZhjcZKXS0Zh0cP3ishzsyBI2+eP9iWd6+JGbIvLC4bprGVbYMb+K/u?=
 =?us-ascii?Q?LACJxZg5Ik0MrpKHblbw0EpgTzAefydVhPYtnKuW931nJjZ02J7Ha5O8mnLz?=
 =?us-ascii?Q?QnnrMXt37s++zgbuTyWtDx8npCmVMu0A8HWaf3pdfV4omaus0m/GolJcKwic?=
 =?us-ascii?Q?a38XHrudritTHrQRLaEntuSir9bMy7VEjM28hc4EAF6lxJkhCp7M7QHY/0ol?=
 =?us-ascii?Q?6NkSW8JKwf+kLjd1Km/G827uEGuZe4eAlJ1ajHhNAoVJvurMT+3oxGn4pa9R?=
 =?us-ascii?Q?5e8LWQb+m4Y7+Bz+ojPhhhFtu1IlMC/AX3/QZg/cArokPMAQZbLiNwOOPVE9?=
 =?us-ascii?Q?/0gz7tSvbBreOiS379rd9Zo7imrXcSTNlfwPzEsl5AoCgm+tbJGUn8b/V6k7?=
 =?us-ascii?Q?uxZRcRf2lYzedIr7BLmBRQvLlgyoBrhaiFPR8hVqXusBW1YiE83RIEUMzAhM?=
 =?us-ascii?Q?KMcJ9XtB4bt+q6gJIyepW6IfBD8Rz/wXSnEoXgrslDRezjexK+8ChH2PUEoC?=
 =?us-ascii?Q?w2gB9aoSNPHRbd4s9KJzdn9qRJDVO2SDUWntvagfdccWSKvwIGuJczzjTGN5?=
 =?us-ascii?Q?3otcJ6b3kQ5ERtT25V0o7wMZDWQB/qBGCiDb8W3YBwKC6/Ya1e2EO0kEnGtg?=
 =?us-ascii?Q?nZnxjWWMGarPJTbaX3xuLCuf?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?K36IDcbdFVZJKGYUol+bwEXXEqoReOrZFC3uJDtgvGrG8209a6J2LUnWH2/3?=
 =?us-ascii?Q?An9DLGNgRQQ80sGp87tyKAyIMCLjy8UZg5UZTOCxZJHaqyr7c4NteKj1T7lf?=
 =?us-ascii?Q?sU0Jo9PBc+Xq9nV7Uupn0pyDIr9vyC2u4y2ofdD9DEmKl4PWKyRgv2n31ufE?=
 =?us-ascii?Q?ra668yqAbRZQA4+6KB68bk0fS9c6Dfp5otQu5Z0jRvJJw6gjLOMNBO+X+mcP?=
 =?us-ascii?Q?dHpa64suaAYSoAvJEKe/AgCOmMw9l6CA9B1BEUorRdiz+lhKweUm4D+pNuaB?=
 =?us-ascii?Q?YXP7r/mOs30tQLTvf/X/iho6IOFhPqee/UxXx/TRcO10ewUCSt5YqlaSoQjW?=
 =?us-ascii?Q?C7LiOlx8ydCpn5utTLTeqvk5m03Sy6nhsrHgvCTsVg2ljAXZ//qL5HOqLJAF?=
 =?us-ascii?Q?gbaWWAineDnFy6oubL7nx9gBNUpD2yciGxT9Fi6WGUmIe7ycD1+5TowQ37xI?=
 =?us-ascii?Q?ed7F6iRZd09rKwaub/tD5VNg7qcFBzPHkJ9t6Xe+9cOIwXR00IkUdFI/5aQm?=
 =?us-ascii?Q?gDCHOuZ/WGBDpLOP8V7FtHs+rpmqXBO4kp5udZyooihKhhWeCcOG2hDVgVK8?=
 =?us-ascii?Q?gkj9pN3oSWbn5WJDTpiZJfRMV/gnjZcU7UZ4s1o5B1GvqQatxhcSEB456EfR?=
 =?us-ascii?Q?a0P4Jy4cNhMJr7xEXxou3Se3Xo1JMpmNh0DnnsUSYDonqqGmbttEsEXTv69V?=
 =?us-ascii?Q?7xR/d962Aluo/8DWB+G1vS8mSBB9YMtQZ0oveu/tZD2hxMQiGSfia3CvsLLf?=
 =?us-ascii?Q?FnNsr3ZIiCNOnCPbsLPelC13t+Efpai+xf9bXcDxp31w755MOnEbF4g8+tbO?=
 =?us-ascii?Q?NAODkNrve/hGpKCsjLdb+43AFwIB9l6hPt5+noUH2LELnEXOW53JQth9BgXc?=
 =?us-ascii?Q?+aiLrGn7EhdDGB/n77eqfTUGYmniH9W7HDSnmHNc1yfIV2LMYwg8bT5PFNB6?=
 =?us-ascii?Q?PXRweuQ7KEwJl1yXJBw8Ox2QNVX7aZJEa1Z3Y0suvRACRFSEWl8WKBio29Cn?=
 =?us-ascii?Q?v3DP0QwJZM/20mSe5oryjjt+ae9ZFGwmLS9CGlpfxAKU1hSj/Wxi92qkkWQr?=
 =?us-ascii?Q?cSnV7fzWPWjFrdy9Ag1uOAYdvTgncYpMfpRKqtvkmHNZytqhfn+6i9B7t4Nh?=
 =?us-ascii?Q?NFQQT0iMjc3zmMU1WJ7YqdI2Ou7BgiWi6PPLWhcljVFWpGwIBajNCotu9n8F?=
 =?us-ascii?Q?ljK+/1P51DXZgaMnfmh6oD2LeQiitw2Ccj2SY/Dy/oePjDHfPxbHYYQiTz88?=
 =?us-ascii?Q?UdwbewHpd7KyM4uVjQIZtDJM6TO7xar78T2EEXgzVnMEoEVZW5AtSnEipPjy?=
 =?us-ascii?Q?QN8CYirOJLuGX/4OElzY+fBfD05lxrMPeigjxbPCqh6gkVK5N884JnsTCFeo?=
 =?us-ascii?Q?mSFe5kkUgClm3NuENsBIA0JFWD8sC4vrtUsiOoUOd4RZ5Da3muFJEnfudkW6?=
 =?us-ascii?Q?Uj7PSSwJTAH1GU/BdKHoS8BFVs9KSgYjqVYZ+KXvdD75r2e7f8n06+bAmY1U?=
 =?us-ascii?Q?uv6h91Bgxo02MlECIpACANnf/MTNfpNwx36WOsAfceqxqBbqPwM7Lhqw05L7?=
 =?us-ascii?Q?jjMPqacm3vrJmPVSd7KI7R6O+o+FQqZqaNXz4CuB9vXZHmOYcO5acw6NbJY+?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	92uMZ5OgkCabSJ77/MVWOaHAxM/2RYwYKyhxh5v3kDhRZ9nGV5DTApKVFoozqf3NIZ2+ToHNvFEfbFJHd/3tPrq4hztOKF8NnzIEXQYsqkE+DdRQFu2uni0RbG75lugoR1nN9PRfB+fpN2ThilsHBSDMoU2hVIwFJObH4Vv6MTEMV7TtA+01k2xmemgjn9eRq2+O/6spf2QDgsbWG67yz7zbvFK4keRrTrOiSr1d/HBB4qWKmri9KVuGI8VKu+xSbFlN5O/BsbAjY2+Js7+HzW0CA4TVc7whKNi6Vy++85gFSTJy3aOb5WFF+bIcxj0hjCCcMtrj+VoLPlpG6mZVeDUSTe2SZcWbWsxnGYZZgdRlP+LdojHnDc7ua9A9MVy50fvW6wQ8vtSc+r6Ekq8HpxNbnUBdSOnTiDRDNyaRPiVIVeWEwJiJkj/F7LhCHINhQ4D7a9G38xJYuxnskibDzibmXKHPONW4eGgTdL6K14ijr8t66ChGKSsujCG0/iXXkSiWwRJRg0w2hOJnMHzbkikYJ/Dod+DP2ycWkZNROqUnVsCD6Hs2laqXDhJdA5almppS1rxfPU+oQYOEIy9ubxbhyTWN0tjHAKCOaOvjEN4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52f33fa8-f0e7-4655-3278-08dc830da92b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2024 14:09:47.6948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6r9ixp+JxHSG6K1tNc7AysGSvfkSxTw7/x4rAFioYvGIVrDtjIHReDDn5iFZzTt7yUTI5K1a6uO7Ff83ByjNhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406020122
X-Proofpoint-GUID: P3eHHu5zW_p_s4KuQNCiToVKYMlew-ME
X-Proofpoint-ORIG-GUID: P3eHHu5zW_p_s4KuQNCiToVKYMlew-ME

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

Extend statx system call to return additional info for atomic write support
support if the specified file is a block device.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/bdev.c           | 36 ++++++++++++++++++++++++++----------
 fs/stat.c              | 16 +++++++++-------
 include/linux/blkdev.h |  6 ++++--
 3 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 353677ac49b3..3976a652fcc7 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1260,23 +1260,39 @@ void sync_bdevs(bool wait)
 }
 
 /*
- * Handle STATX_DIOALIGN for block devices.
- *
- * Note that the inode passed to this is the inode of a block device node file,
- * not the block device's internal inode.  Therefore it is *not* valid to use
- * I_BDEV() here; the block device has to be looked up by i_rdev instead.
+ * Handle STATX_{DIOALIGN, WRITE_ATOMIC} for block devices.
  */
-void bdev_statx_dioalign(struct inode *inode, struct kstat *stat)
+void bdev_statx(struct inode *backing_inode, struct kstat *stat,
+		u32 request_mask)
 {
 	struct block_device *bdev;
 
-	bdev = blkdev_get_no_open(inode->i_rdev);
+	if (!(request_mask & (STATX_DIOALIGN | STATX_WRITE_ATOMIC)))
+		return;
+
+	/*
+	 * Note that backing_inode is the inode of a block device node file,
+	 * not the block device's internal inode.  Therefore it is *not* valid
+	 * to use I_BDEV() here; the block device has to be looked up by i_rdev
+	 * instead.
+	 */
+	bdev = blkdev_get_no_open(backing_inode->i_rdev);
 	if (!bdev)
 		return;
 
-	stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
-	stat->dio_offset_align = bdev_logical_block_size(bdev);
-	stat->result_mask |= STATX_DIOALIGN;
+	if (request_mask & STATX_DIOALIGN) {
+		stat->dio_mem_align = bdev_dma_alignment(bdev) + 1;
+		stat->dio_offset_align = bdev_logical_block_size(bdev);
+		stat->result_mask |= STATX_DIOALIGN;
+	}
+
+	if (request_mask & STATX_WRITE_ATOMIC && bdev_can_atomic_write(bdev)) {
+		struct request_queue *bd_queue = bdev->bd_queue;
+
+		generic_fill_statx_atomic_writes(stat,
+			queue_atomic_write_unit_min_bytes(bd_queue),
+			queue_atomic_write_unit_max_bytes(bd_queue));
+	}
 
 	blkdev_put_no_open(bdev);
 }
diff --git a/fs/stat.c b/fs/stat.c
index 72d0e6357b91..bd0698dfd7b3 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -265,6 +265,7 @@ static int vfs_statx(int dfd, struct filename *filename, int flags,
 {
 	struct path path;
 	unsigned int lookup_flags = getname_statx_lookup_flags(flags);
+	struct inode *backing_inode;
 	int error;
 
 	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT | AT_EMPTY_PATH |
@@ -290,13 +291,14 @@ static int vfs_statx(int dfd, struct filename *filename, int flags,
 		stat->attributes |= STATX_ATTR_MOUNT_ROOT;
 	stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
 
-	/* Handle STATX_DIOALIGN for block devices. */
-	if (request_mask & STATX_DIOALIGN) {
-		struct inode *inode = d_backing_inode(path.dentry);
-
-		if (S_ISBLK(inode->i_mode))
-			bdev_statx_dioalign(inode, stat);
-	}
+	/*
+	 * If this is a block device inode, override the filesystem
+	 * attributes with the block device specific parameters that need to be
+	 * obtained from the bdev backing inode.
+	 */
+	backing_inode = d_backing_inode(path.dentry);
+	if (S_ISBLK(backing_inode->i_mode))
+		bdev_statx(backing_inode, stat, request_mask);
 
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 565acbd3adcb..af85bb122158 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1588,7 +1588,8 @@ int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
 int sync_blockdev_nowait(struct block_device *bdev);
 void sync_bdevs(bool wait);
-void bdev_statx_dioalign(struct inode *inode, struct kstat *stat);
+void bdev_statx(struct inode *backing_inode, struct kstat *stat,
+		u32 request_mask);
 void printk_all_partitions(void);
 int __init early_lookup_bdev(const char *pathname, dev_t *dev);
 #else
@@ -1606,7 +1607,8 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
 static inline void sync_bdevs(bool wait)
 {
 }
-static inline void bdev_statx_dioalign(struct inode *inode, struct kstat *stat)
+static inline void bdev_statx(struct inode *backing_inode, struct kstat *stat,
+				u32 request_mask)
 {
 }
 static inline void printk_all_partitions(void)
-- 
2.31.1


