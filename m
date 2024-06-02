Return-Path: <io-uring+bounces-2064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82B508D75EC
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 16:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36A9C282805
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 14:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134E75101A;
	Sun,  2 Jun 2024 14:10:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1564F218;
	Sun,  2 Jun 2024 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717337423; cv=fail; b=qepBTZ1rmKCb2Q5s/qRiZiDj0RyRvoT9hvwwNCd8hAc+aOgAYMOiLEK6SwtfjYoVUCo/TguQs4vrZhW/nx9DmXUDlKPhS2R8pHLYFu/otS6gSapgy0ytL3fOHGG8qBf179op+A5GbdB8ifND4OqVBz8eLkqoB4E/Zo0FOaHw32U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717337423; c=relaxed/simple;
	bh=QHxe9s8GCPGWZazSCJRxE5rMNrX90duQt8OED3FGRxI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LE/442IrAPUERVVHkznadLgmsLjtSsBL5889alVkZCPFuwBGqC6bp6eCFF6Dhjlw2NNe6TqQL+HEKPl20R7FJlIyp8EfjBwFseyxhl5y5YpDgWK2uRC7FZfPLTP0GsWp4SheHZY1HHb9M5Oe8+EXqGnEkTqyrFdLn2o8DBjnH5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4526uFoT029377;
	Sun, 2 Jun 2024 14:09:51 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3Dd9Qfa23ePkgtLUCVNK+iNN0Qf5oqi5S/3wN0Hci0F78=3D;_b?=
 =?UTF-8?Q?=3DHXa8ihV6WNwZsMjk5sWiOhuWNOoJP6wcNIkXjYkHRNQZcGmrxDf45Qs04sRc?=
 =?UTF-8?Q?vxhXLH5J_LCHam/nr4Bq/uJb8Rg4UPwe7tOFEhMh9NMzPd8fYqTqvMOn2f+NNHn?=
 =?UTF-8?Q?va2bpvDJMrjZL0_NKnWPEDouJ99TFJ4s5Ms4O/+YQrxs5FEfQKZDOMPoG27zuGB?=
 =?UTF-8?Q?uTXpihqkCKL6h2FJSgnv_ad9KkRyad7Dmwo8+MawGf8r3maYUtxP5CfmjBQZ48w?=
 =?UTF-8?Q?gbYVkO13lPoCsdEfSwf2TpJsfl_uwkFGj1cZ1y53n8I3ye2u1eD3qVeSJZYFJls?=
 =?UTF-8?Q?SBu0akSKvPEn16x61AEEDe/tgWKdc2H4_/w=3D=3D_?=
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv3nscp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:50 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 452CPX3K003837;
	Sun, 2 Jun 2024 14:09:49 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrquhb43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fd2Tgg60qhXwm9vYoct131UL+96nEU6jaDApnnHVb+kzj8um9CPnf2V01GO8JDrxazvDFxT5qbzfhTin+BY7I6ih2/ZLiBPPJNI3d8744ah6ofgDTIk+j8ysYHr9lNjrzzgrZV7VfsDpWF1tgc16zSNWjl82oKV3MXKSu9O8DCzdIBHpIAXgXG80P94pEVktOi8DjKBF0VGRDsBQF5j3NcEhJTLuOtL4eljlsHFY8vdAZCaGk8CV4lSgza2T5CPTcLvQbiB01WDn3P+RkPapQhY7M8X8tTmmsPrT8CxQ6Eanpqt88e0MKMY4Ykcz2rAwUW2gMeSAyF5mTvv+qj5hrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9Qfa23ePkgtLUCVNK+iNN0Qf5oqi5S/3wN0Hci0F78=;
 b=nJH1izv2bUZgImI2rBPjKbufHVvQI6An9mnyKvBIlqLO9xiGTg/3C1hwUsWSrvga7+YTVLLdUI6r3h+4/oYedmpqx3mhf7R3vnx5X6czHFBddkCuBLImEcM36NZ7SLmhxkqr0VaeXNB7Sw6Wu2cVBhlDO6hKlEBsB8gzMgpTEY3Erv0BJ2syxFHwZDE53rBo3yOtRHI18oS4AKjgOCZimmvPqLvQ/0aNpwx7WI05gIGv8KG8RUuuJXFSNr6pBa6fPQ9zrWckzfxJnJ3QI9Q498j4vbP2v2vl+r70VbP7elOc40KVeZziDdWCTzUvibA1mvxm94mtRqTqqrmLoVsMLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9Qfa23ePkgtLUCVNK+iNN0Qf5oqi5S/3wN0Hci0F78=;
 b=AuVr1/sUu8BkrgVFh9wcIUiTIC34Y7ub8LBqaenGsXmSpTHkbvBXe3nSyfCSqeeeYKcEaKF5PoBBa+Nq9yF8MS5yQMCkDPezdXMJKScj9YrOLO3znMfe/eZtvJOJsxlBZYnjmGijTQHLWcP4Ik4g4t3V9w71ouHyxFGfbpsuimY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Sun, 2 Jun
 2024 14:09:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Sun, 2 Jun 2024
 14:09:46 +0000
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
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v7 4/9] block: Add core atomic write support
Date: Sun,  2 Jun 2024 14:09:07 +0000
Message-Id: <20240602140912.970947-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240602140912.970947-1-john.g.garry@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:23a::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 71133b53-c448-44a9-2d89-08dc830da843
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|366007|7416005|1800799015|376005|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?MtfExUXDBPAclnMIYsBe3PjgA+HaiXrQIbtiawFazg7nmE4OvHokBLcp+hwT?=
 =?us-ascii?Q?0SWZkrYoDWUnmWOYR2wXjuFfNMj8tULtWFKOM9fwH0QGfP2n2/WoT/Rt5gIk?=
 =?us-ascii?Q?te0SKzifwfJmlOA5MZKXv9Wdi7CG/7017o33aWGSOp4Dar6KW8Tah2XIQnXR?=
 =?us-ascii?Q?jtzZgWIjs7Zv4S81hkislJ6RZCogwBuYXhdfMRDBLdwltxmp8gB8zeh+fF+G?=
 =?us-ascii?Q?LyJ4CTOEdpVVmYlfKG8HjcniCyVALKxKNII9F+eBhmtFLve+d7mQ+At+JpiV?=
 =?us-ascii?Q?SmE8w9+m9xfpR/HaBsWYen1gpDkrBgxUQ++AhMAerZfHV5uKSNCUqsWDiMoU?=
 =?us-ascii?Q?XjalDvjQR8mPa99elWCkp11hvbi0VW4/iFuG+wQvC0fiNU5ii/8SLeA5XPv5?=
 =?us-ascii?Q?LxYFGThGOiibMpjPA6Ph9rAsb7oqfozzcVYXRNVjLEubGcWlqc776u2ZrfCd?=
 =?us-ascii?Q?i3Hg/E1tnAsHdD/Oe3xdzd4vzrl4WftpkzeLNQ6ibUruk8bQOfeMpjHeI2Z5?=
 =?us-ascii?Q?m2N7ogcVtvVpr/6gQvu02u7m0yuo+XFSkeSwSeGxCPQWRo5Rr7gpKgk011Gn?=
 =?us-ascii?Q?TfCtZnoWsKgVQZOcgt1cG4sMU3IYCYCIHYd0f+BuzKO7t4zA0X8ybRklN1bq?=
 =?us-ascii?Q?s2p1qDXe/gomTl+5xs0I2vVM2EK7Dk5g5JG6zq/w3l9lOq/72MLj3DTiGvDT?=
 =?us-ascii?Q?Pg7rU3XNdG0sB65Id2Bn4QcS7ec/ZJUwVbNSgG9dAAE/J1yXZ2pH6BI3bik0?=
 =?us-ascii?Q?/vMOoU2b6LAPJqdE6kw8jfT6PQnzv693OM+3JlHErXp6cUnzrhH/uhhyXqT1?=
 =?us-ascii?Q?aDw8M/ww2Z1xL6RgBghFUf9LSepA9yPsOcvTmgAeSlSxlSjDdoLaWAaU9Lp/?=
 =?us-ascii?Q?s7wRedeOPd6uGm5jPgDIipNFK8sK4mpXRt9c314dOeulTdkBjxqzMkJ5Ivpk?=
 =?us-ascii?Q?k/jtrAtJE2qB8eY872+oDKXJ9d4+P1M1XAZbG2t3YZ+YUiP9COLYIUhPCE+6?=
 =?us-ascii?Q?3NKqqBDoBj7evPpU9sdN0R/VIPmkPKgv42hOm916ENqPR2E7ZHY/OucHkBCW?=
 =?us-ascii?Q?2g4YbY8xsg1TO1dW41WqQYtiFoqjHOmnaiI/Wouz34SfIJhRDp+ISqtXT9zB?=
 =?us-ascii?Q?e6w+kmu3HXRlr/HOqaeC8xtwHhBnQwFBocL+mzVsPocXF9XyrPQqZ+eV8iWy?=
 =?us-ascii?Q?/rAth2QY/G3Gdx9/Ns+yuLakLTaSMw4p5QzC/B+MAAWQSY00bvN68tEKyUCJ?=
 =?us-ascii?Q?fAW5HaATxdG1rpAv/fHdEER36VXbvQj0aaddXGBngSi51ZqUvXTB//5e68XW?=
 =?us-ascii?Q?cIMwlLBvp3Q+0hVXqa2PBSWl?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?sk03nJaHkTvqIqG01aznJL8Ul/K9m89dgC8ZYlb2iE4jzxn0bAuE1SB0KVnE?=
 =?us-ascii?Q?NuIJC6+5OPbX8iaObkWFKVfhaWoAI93IRrsECDe5Yr6Al+pC730NIteD9pP2?=
 =?us-ascii?Q?M7ictKQJ8Yu4SBC1JIqIvbNC9IHLttEcHQqMQrIZ+/0e3LUJl9cKCdqdjX5d?=
 =?us-ascii?Q?YUMl0G7VO9vigigVxGc21VJ9x3aOIQ/hS40uZ8yDQtn1bv40tIYAS1a2J3ZD?=
 =?us-ascii?Q?eVwuj8eU92A1Zs/GnXcgsNVycJi5/8HqqfEAM8depNhzyeqJaovDOrgrILIY?=
 =?us-ascii?Q?dCS7dsKrozS1sich9FE0ze+lmFAC/NybSgdR78SdohGC/Zpv8+mbaSxUR2pB?=
 =?us-ascii?Q?OAGo/ftfUmRRecQROslOskJl5ukSmqnIQOZrUgrOAe6OptWiUFuFh25XcU9l?=
 =?us-ascii?Q?33UzwjHJQlXNIkLI9+Z+IETdR68kUH/QBQ0a0OoOQMlTrKItsNTRk03Omdgy?=
 =?us-ascii?Q?1AwkCRBXPtyqM3S7NJHY+Vn0ASSdPQD5rCAntcqwxL4H1nz8c6jq4UKa8e60?=
 =?us-ascii?Q?dr23y3yAjHx+vGvIXY6aSsSbDJxq+DOqqXIk4FAg0sOPnMZonz+q+eTgSq5z?=
 =?us-ascii?Q?lbvchwnKcqwLeoUYer/ds+NWK0HQ5pAqJ8IrIOYoUbdBKrvVWeLRU/VX9U4G?=
 =?us-ascii?Q?Eur9koL8xrzGg3GJPw/AO+JZ+NSgSdeUdIRCpzubUwu+1oSiPJv2F10GPr2i?=
 =?us-ascii?Q?vbWydqYdvplxTMOlKPUqdHhr0uIPTMy2a+FjkpfcnjPKKbXr0slIUEYMqtOc?=
 =?us-ascii?Q?IUO2BICvi4bo+qVxE9jQHdp43jTQ94oe5Ce/whHPwMsGf9IlXOMLJzjOKb84?=
 =?us-ascii?Q?jhiXdoP5vYB3QGxaesI8PZIWnyfJ6pWH1Ri6jahEvz/SAlx845cLr5we8oer?=
 =?us-ascii?Q?SYR7g4dvVjJHq3caEvKdDV57h1UjSY/ksEIJ+abiQakoSbv1PbQU9AtkTFjw?=
 =?us-ascii?Q?elldtypQ+Kop83RMvAk/h5IqTZMdrOX9VeJ+WBVrrOw6YdlZOBH7QZ1iEENN?=
 =?us-ascii?Q?xHciTwQy7vMObIyU026fu3O+Ecc1+XPt+0Ve9rbnCRiNCHNfxvq6Vqatfarx?=
 =?us-ascii?Q?hwAmd3GYKCwmdv4rJ+sI03mWG+fs79J9TR0difxzLyKy0oO8LgTIN8wPTxRz?=
 =?us-ascii?Q?KCp6q8KBeXUhAqvg0THydEZEa04fOz4Nqas2HD8ITfvz0B2NCy6k8f7BAjKA?=
 =?us-ascii?Q?9HoO4B0P8/w23mQMck5rElUCibCCQqzPALWs5KJS004fEPRu2XalMXjMLWDG?=
 =?us-ascii?Q?+PJS6JRdbh9sFbIxCFCCd8k8Q9IQrWffmdC/hdJ818WL1G72MBIbs0gRC7A2?=
 =?us-ascii?Q?kwOPfiLnD0Zhvp/pOKS7dz4dWl5CA8TMZNmOv9Wxd4mY3FSOXGlF07yeLf4z?=
 =?us-ascii?Q?YucwbVUTSfsaG/MIgm+LLbzmk4yh1NSDldEQo+vl8JBylZrpIPsZLsIhqllk?=
 =?us-ascii?Q?+3C9F8SiXvG4A/BBVbqPnB+DH1WGc+4TfK7hmzJsOwxMpr7MvIm3n6oQt0wc?=
 =?us-ascii?Q?UxisgCsxvRbOOrtJW0dHrgEdIVgjDh9UJKRg8hXd5YufMcX5WbD1FMXy4jUn?=
 =?us-ascii?Q?CvX/t6nqBb2IRIDG1eWLzmgPPEwbY7hQ4qkBVUlyKp0WAs6NeiDoCsj5/tn9?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	uCKODXjylMeMSgFTG0huSC6bDMQjROvPFrXpqvG5osVcBpM5QUbd1pfpS6fokRFLGbcWn51mUjDG72LEsSV6PZI/qPgGGW+yQE1HK6i8xvm1YnKDxnQQxrkeSZrJ04cH/8DdRAXpghWsDj9ZD9GLClk6U4+1cY8zRhgfLAm07ydII0S7h73/y+PwKDZM7CxBmVr1BJGlujtSVu5qQ+aJxkDwM+V4u52s1w5aH/JqvUv6p3SSkbGlGzN5aVGe3u07CzCoEGIAnSGlHmF0I/1U2OU5Vdvm5n8eKR04/K5jHZttgkAX2GzmbLoLYpgwY87946JoeZPtNI/xrHGqqpzPTLqY6ebFQb7U9DdF1zlO+Ae2/hDFdFYOz1pmFMKfpG7vMWQOMQ620Wie7Jxt3maUrs6Qe7aEa+wfVuOsNCTRqfZqmN6GoDtYE6BslPY3L5/pJjHXVMMEtRfAQLzYZKWCSUzwwCAnXiE5JwFkqtRcbNNrXDmROeiIttHW7wOt7R0Nhvrc8jbtTLU1q9rxEfuTfL6OKyRGb+mq+FkINaNyGD8tSCd5v0qu3mW/CIEPuUSDr1dc5fyrb/6OP8hfxdwjXGm9zHIjK+cWeRbrCtqHJak=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71133b53-c448-44a9-2d89-08dc830da843
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2024 14:09:46.2001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QR9cnwDW7NcJZqLhY4jXTQb9v/TZrRv8z12XD9CPHBgJO4bQtl3CW+tr4mU/3iy8Ig443j4LCBYQ7pu8saJchA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406020122
X-Proofpoint-ORIG-GUID: 8FcAO6973ZA1DzTJ73-orK-OzL5vx4um
X-Proofpoint-GUID: 8FcAO6973ZA1DzTJ73-orK-OzL5vx4um

Add atomic write support, as follows:
- add helper functions to get request_queue atomic write limits
- report request_queue atomic write support limits to sysfs and update Doc
- support to safely merge atomic writes
- deal with splitting atomic writes
- misc helper functions
- add a per-request atomic write flag

New request_queue limits are added, as follows:
- atomic_write_hw_max is set by the block driver and is the maximum length
  of an atomic write which the device may support. It is not
  necessarily a power-of-2.
- atomic_write_max_sectors is derived from atomic_write_hw_max_sectors and
  max_hw_sectors. It is always a power-of-2. Atomic writes may be merged,
  and atomic_write_max_sectors would be the limit on a merged atomic write
  request size. This value is not capped at max_sectors, as the value in
  max_sectors can be controlled from userspace, and it would only cause
  trouble if userspace could limit atomic_write_unit_max_bytes and the
  other atomic write limits.
- atomic_write_hw_unit_{min,max} are set by the block driver and are the
  min/max length of an atomic write unit which the device may support. They
  both must be a power-of-2. Typically atomic_write_hw_unit_max will hold
  the same value as atomic_write_hw_max.
- atomic_write_unit_{min,max} are derived from
  atomic_write_hw_unit_{min,max}, max_hw_sectors, and block core limits.
  Both min and max values must be a power-of-2.
- atomic_write_hw_boundary is set by the block driver. If non-zero, it
  indicates an LBA space boundary at which an atomic write straddles no
  longer is atomically executed by the disk. The value must be a
  power-of-2. Note that it would be acceptable to enforce a rule that
  atomic_write_hw_boundary_sectors is a multiple of
  atomic_write_hw_unit_max, but the resultant code would be more
  complicated.

All atomic writes limits are by default set 0 to indicate no atomic write
support. Even though it is assumed by Linux that a logical block can always
be atomically written, we ignore this as it is not of particular interest.
Stacked devices are just not supported either for now.

An atomic write must always be submitted to the block driver as part of a
single request. As such, only a single BIO must be submitted to the block
layer for an atomic write. When a single atomic write BIO is submitted, it
cannot be split. As such, atomic_write_unit_{max, min}_bytes are limited
by the maximum guaranteed BIO size which will not be required to be split.
This max size is calculated by request_queue max segments and the number
of bvecs a BIO can fit, BIO_MAX_VECS. Currently we rely on userspace
issuing a write with iovcnt=1 for pwritev2() - as such, we can rely on each
segment containing PAGE_SIZE of data, apart from the first+last, which each
can fit logical block size of data. The first+last will be LBS
length/aligned as we rely on direct IO alignment rules also.

New sysfs files are added to report the following atomic write limits:
- atomic_write_unit_max_bytes - same as atomic_write_unit_max_sectors in
				bytes
- atomic_write_unit_min_bytes - same as atomic_write_unit_min_sectors in
				bytes
- atomic_write_boundary_bytes - same as atomic_write_hw_boundary_sectors in
				bytes
- atomic_write_max_bytes      - same as atomic_write_max_sectors in bytes

Atomic writes may only be merged with other atomic writes and only under
the following conditions:
- total resultant request length <= atomic_write_max_bytes
- the merged write does not straddle a boundary

Helper function bdev_can_atomic_write() is added to indicate whether
atomic writes may be issued to a bdev. If a bdev is a partition, the
partition start must be aligned with both atomic_write_unit_min_sectors
and atomic_write_hw_boundary_sectors.

FSes will rely on the block layer to validate that an atomic write BIO
submitted will be of valid size, so add blk_validate_atomic_write_op_size()
for this purpose. Userspace expects an atomic write which is of invalid
size to be rejected with -EINVAL, so add BLK_STS_INVAL for this. Also use
BLK_STS_INVAL for when a BIO needs to be split, as this should mean an
invalid size BIO.

Flag REQ_ATOMIC is used for indicating an atomic write.

Co-developed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 Documentation/ABI/stable/sysfs-block | 53 ++++++++++++++++
 block/blk-core.c                     | 19 ++++++
 block/blk-merge.c                    | 95 +++++++++++++++++++++++++++-
 block/blk-settings.c                 | 52 +++++++++++++++
 block/blk-sysfs.c                    | 33 ++++++++++
 block/blk.h                          |  3 +
 include/linux/blk_types.h            |  8 ++-
 include/linux/blkdev.h               | 54 ++++++++++++++++
 8 files changed, 315 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 831f19a32e08..cea8856f798d 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -21,6 +21,59 @@ Description:
 		device is offset from the internal allocation unit's
 		natural alignment.
 
+What:		/sys/block/<disk>/atomic_write_max_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] This parameter specifies the maximum atomic write
+		size reported by the device. This parameter is relevant
+		for merging of writes, where a merged atomic write
+		operation must not exceed this number of bytes.
+		This parameter may be greater than the value in
+		atomic_write_unit_max_bytes as
+		atomic_write_unit_max_bytes will be rounded down to a
+		power-of-two and atomic_write_unit_max_bytes may also be
+		limited by some other queue limits, such as max_segments.
+		This parameter - along with atomic_write_unit_min_bytes
+		and atomic_write_unit_max_bytes - will not be larger than
+		max_hw_sectors_kb, but may be larger than max_sectors_kb.
+
+
+What:		/sys/block/<disk>/atomic_write_unit_min_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] This parameter specifies the smallest block which can
+		be written atomically with an atomic write operation. All
+		atomic write operations must begin at a
+		atomic_write_unit_min boundary and must be multiples of
+		atomic_write_unit_min. This value must be a power-of-two.
+
+
+What:		/sys/block/<disk>/atomic_write_unit_max_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] This parameter defines the largest block which can be
+		written atomically with an atomic write operation. This
+		value must be a multiple of atomic_write_unit_min and must
+		be a power-of-two. This value will not be larger than
+		atomic_write_max_bytes.
+
+
+What:		/sys/block/<disk>/atomic_write_boundary_bytes
+Date:		February 2024
+Contact:	Himanshu Madhani <himanshu.madhani@oracle.com>
+Description:
+		[RO] A device may need to internally split an atomic write I/O
+		which straddles a given logical block address boundary. This
+		parameter specifies the size in bytes of the atomic boundary if
+		one is reported by the device. This value must be a
+		power-of-two and at least the size as in
+		atomic_write_unit_max_bytes.
+		Any attempt to merge atomic write I/Os must not result in a
+		merged I/O which crosses this boundary (if any).
+
 
 What:		/sys/block/<disk>/diskseq
 Date:		February 2021
diff --git a/block/blk-core.c b/block/blk-core.c
index 82c3ae22d76d..d9f58fe71758 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -174,6 +174,8 @@ static const struct {
 	/* Command duration limit device-side timeout */
 	[BLK_STS_DURATION_LIMIT]	= { -ETIME, "duration limit exceeded" },
 
+	[BLK_STS_INVAL]		= { -EINVAL,	"invalid" },
+
 	/* everything else not covered above: */
 	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
 };
@@ -739,6 +741,18 @@ void submit_bio_noacct_nocheck(struct bio *bio)
 		__submit_bio_noacct(bio);
 }
 
+static blk_status_t blk_validate_atomic_write_op_size(struct request_queue *q,
+						 struct bio *bio)
+{
+	if (bio->bi_iter.bi_size > queue_atomic_write_unit_max_bytes(q))
+		return BLK_STS_INVAL;
+
+	if (bio->bi_iter.bi_size % queue_atomic_write_unit_min_bytes(q))
+		return BLK_STS_INVAL;
+
+	return BLK_STS_OK;
+}
+
 /**
  * submit_bio_noacct - re-submit a bio to the block device layer for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -797,6 +811,11 @@ void submit_bio_noacct(struct bio *bio)
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
+		if (bio->bi_opf & REQ_ATOMIC) {
+			status = blk_validate_atomic_write_op_size(q, bio);
+			if (status != BLK_STS_OK)
+				goto end_io;
+		}
 		break;
 	case REQ_OP_FLUSH:
 		/*
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8957e08e020c..ad07759ca147 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -18,6 +18,46 @@
 #include "blk-rq-qos.h"
 #include "blk-throttle.h"
 
+/*
+ * rq_straddles_atomic_write_boundary - check for boundary violation
+ * @rq: request to check
+ * @front: data size to be appended to front
+ * @back: data size to be appended to back
+ *
+ * Determine whether merging a request or bio into another request will result
+ * in a merged request which straddles an atomic write boundary.
+ *
+ * The value @front_adjust is the data which would be appended to the front of
+ * @rq, while the value @back_adjust is the data which would be appended to the
+ * back of @rq. Callers will typically only have either @front_adjust or
+ * @back_adjust as non-zero.
+ *
+ */
+static bool rq_straddles_atomic_write_boundary(struct request *rq,
+					unsigned int front_adjust,
+					unsigned int back_adjust)
+{
+	unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
+	u64 mask, start_rq_pos, end_rq_pos;
+
+	if (!boundary)
+		return false;
+
+	start_rq_pos = blk_rq_pos(rq) << SECTOR_SHIFT;
+	end_rq_pos = start_rq_pos + blk_rq_bytes(rq) - 1;
+
+	start_rq_pos -= front_adjust;
+	end_rq_pos += back_adjust;
+
+	mask = ~(boundary - 1);
+
+	/* Top bits are different, so crossed a boundary */
+	if ((start_rq_pos & mask) != (end_rq_pos & mask))
+		return true;
+
+	return false;
+}
+
 static inline void bio_get_first_bvec(struct bio *bio, struct bio_vec *bv)
 {
 	*bv = mp_bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
@@ -167,7 +207,16 @@ static inline unsigned get_max_io_size(struct bio *bio,
 {
 	unsigned pbs = lim->physical_block_size >> SECTOR_SHIFT;
 	unsigned lbs = lim->logical_block_size >> SECTOR_SHIFT;
-	unsigned max_sectors = lim->max_sectors, start, end;
+	unsigned max_sectors, start, end;
+
+	/*
+	 * We ignore lim->max_sectors for atomic writes simply because
+	 * it may less than the bio size, which we cannot tolerate.
+	 */
+	if (bio->bi_opf & REQ_ATOMIC)
+		max_sectors = lim->atomic_write_max_sectors;
+	else
+		max_sectors = lim->max_sectors;
 
 	if (lim->chunk_sectors) {
 		max_sectors = min(max_sectors,
@@ -305,6 +354,11 @@ struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
 	*segs = nsegs;
 	return NULL;
 split:
+	if (bio->bi_opf & REQ_ATOMIC) {
+		bio->bi_status = BLK_STS_INVAL;
+		bio_endio(bio);
+		return ERR_PTR(-EINVAL);
+	}
 	/*
 	 * We can't sanely support splitting for a REQ_NOWAIT bio. End it
 	 * with EAGAIN if splitting is required and return an error pointer.
@@ -646,6 +700,13 @@ int ll_back_merge_fn(struct request *req, struct bio *bio, unsigned int nr_segs)
 		return 0;
 	}
 
+	if (req->cmd_flags & REQ_ATOMIC) {
+		if (rq_straddles_atomic_write_boundary(req,
+				0, bio->bi_iter.bi_size)) {
+			return 0;
+		}
+	}
+
 	return ll_new_hw_segment(req, bio, nr_segs);
 }
 
@@ -665,6 +726,13 @@ static int ll_front_merge_fn(struct request *req, struct bio *bio,
 		return 0;
 	}
 
+	if (req->cmd_flags & REQ_ATOMIC) {
+		if (rq_straddles_atomic_write_boundary(req,
+				bio->bi_iter.bi_size, 0)) {
+			return 0;
+		}
+	}
+
 	return ll_new_hw_segment(req, bio, nr_segs);
 }
 
@@ -701,6 +769,13 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	    blk_rq_get_max_sectors(req, blk_rq_pos(req)))
 		return 0;
 
+	if (req->cmd_flags & REQ_ATOMIC) {
+		if (rq_straddles_atomic_write_boundary(req,
+				0, blk_rq_bytes(next))) {
+			return 0;
+		}
+	}
+
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
 	if (total_phys_segments > blk_rq_get_max_segments(req))
 		return 0;
@@ -798,6 +873,18 @@ static enum elv_merge blk_try_req_merge(struct request *req,
 	return ELEVATOR_NO_MERGE;
 }
 
+static bool blk_atomic_write_mergeable_rq_bio(struct request *rq,
+					      struct bio *bio)
+{
+	return (rq->cmd_flags & REQ_ATOMIC) == (bio->bi_opf & REQ_ATOMIC);
+}
+
+static bool blk_atomic_write_mergeable_rqs(struct request *rq,
+					   struct request *next)
+{
+	return (rq->cmd_flags & REQ_ATOMIC) == (next->cmd_flags & REQ_ATOMIC);
+}
+
 /*
  * For non-mq, this has to be called with the request spinlock acquired.
  * For mq with scheduling, the appropriate queue wide lock should be held.
@@ -821,6 +908,9 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req->ioprio != next->ioprio)
 		return NULL;
 
+	if (!blk_atomic_write_mergeable_rqs(req, next))
+		return NULL;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
@@ -952,6 +1042,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (rq->ioprio != bio_prio(bio))
 		return false;
 
+	if (blk_atomic_write_mergeable_rq_bio(rq, bio) == false)
+		return false;
+
 	return true;
 }
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 996f247fc98e..25d3ca2e2f0d 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -97,6 +97,41 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
 	return 0;
 }
 
+/*
+ * Returns max guaranteed bytes which we can fit in a bio.
+ *
+ * We always assume that we can fit in at least PAGE_SIZE in a segment, apart
+ * from first and last segments.
+ */
+static
+unsigned int blk_queue_max_guaranteed_bio(struct queue_limits *limits)
+{
+	unsigned int max_segments = min(BIO_MAX_VECS, limits->max_segments);
+	unsigned int length;
+
+	length = min(max_segments, 2) * limits->logical_block_size;
+	if (max_segments > 2)
+		length += (max_segments - 2) * PAGE_SIZE;
+
+	return length;
+}
+
+static void blk_atomic_writes_update_limits(struct queue_limits *limits)
+{
+	unsigned int unit_limit = min(limits->max_hw_sectors << SECTOR_SHIFT,
+					blk_queue_max_guaranteed_bio(limits));
+
+	unit_limit = rounddown_pow_of_two(unit_limit);
+
+	limits->atomic_write_max_sectors =
+		min(limits->atomic_write_hw_max >> SECTOR_SHIFT,
+			limits->max_hw_sectors);
+	limits->atomic_write_unit_min =
+		min(limits->atomic_write_hw_unit_min, unit_limit);
+	limits->atomic_write_unit_max =
+		min(limits->atomic_write_hw_unit_max, unit_limit);
+}
+
 /*
  * Check that the limits in lim are valid, initialize defaults for unset
  * values, and cap values based on others where needed.
@@ -230,6 +265,23 @@ static int blk_validate_limits(struct queue_limits *lim)
 		lim->misaligned = 0;
 	}
 
+	/*
+	 * The atomic write boundary size just needs to be a multiple of
+	 * unit_max (and not necessarily a power-of-2), so this following check
+	 * could be relaxed in future.
+	 * Furthermore, if needed, unit_max could be reduced so that the
+	 * boundary size was compliant (with a !power-of-2 boundary).
+	 */
+	if (lim->atomic_write_hw_boundary &&
+	    !is_power_of_2(lim->atomic_write_hw_boundary)) {
+
+		lim->atomic_write_hw_max = 0;
+		lim->atomic_write_hw_boundary = 0;
+		lim->atomic_write_hw_unit_min = 0;
+		lim->atomic_write_hw_unit_max = 0;
+	}
+	blk_atomic_writes_update_limits(lim);
+
 	return blk_validate_zoned_limits(lim);
 }
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index f0f9314ab65c..42fbbaa52ccf 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -118,6 +118,30 @@ static ssize_t queue_max_discard_segments_show(struct request_queue *q,
 	return queue_var_show(queue_max_discard_segments(q), page);
 }
 
+static ssize_t queue_atomic_write_max_bytes_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_max_bytes(q), page);
+}
+
+static ssize_t queue_atomic_write_boundary_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_boundary_bytes(q), page);
+}
+
+static ssize_t queue_atomic_write_unit_min_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_unit_min_bytes(q), page);
+}
+
+static ssize_t queue_atomic_write_unit_max_show(struct request_queue *q,
+						char *page)
+{
+	return queue_var_show(queue_atomic_write_unit_max_bytes(q), page);
+}
+
 static ssize_t queue_max_integrity_segments_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(q->limits.max_integrity_segments, page);
@@ -495,6 +519,11 @@ QUEUE_RO_ENTRY(queue_discard_max_hw, "discard_max_hw_bytes");
 QUEUE_RW_ENTRY(queue_discard_max, "discard_max_bytes");
 QUEUE_RO_ENTRY(queue_discard_zeroes_data, "discard_zeroes_data");
 
+QUEUE_RO_ENTRY(queue_atomic_write_max_bytes, "atomic_write_max_bytes");
+QUEUE_RO_ENTRY(queue_atomic_write_boundary, "atomic_write_boundary_bytes");
+QUEUE_RO_ENTRY(queue_atomic_write_unit_max, "atomic_write_unit_max_bytes");
+QUEUE_RO_ENTRY(queue_atomic_write_unit_min, "atomic_write_unit_min_bytes");
+
 QUEUE_RO_ENTRY(queue_write_same_max, "write_same_max_bytes");
 QUEUE_RO_ENTRY(queue_write_zeroes_max, "write_zeroes_max_bytes");
 QUEUE_RO_ENTRY(queue_zone_append_max, "zone_append_max_bytes");
@@ -618,6 +647,10 @@ static struct attribute *queue_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_max_hw_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_atomic_write_max_bytes_entry.attr,
+	&queue_atomic_write_boundary_entry.attr,
+	&queue_atomic_write_unit_min_entry.attr,
+	&queue_atomic_write_unit_max_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_zone_append_max_entry.attr,
diff --git a/block/blk.h b/block/blk.h
index 75c1683fc320..b2fa42657f62 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -193,6 +193,9 @@ static inline unsigned int blk_queue_get_max_sectors(struct request *rq)
 	if (unlikely(op == REQ_OP_WRITE_ZEROES))
 		return q->limits.max_write_zeroes_sectors;
 
+	if (rq->cmd_flags & REQ_ATOMIC)
+		return q->limits.atomic_write_max_sectors;
+
 	return q->limits.max_sectors;
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 781c4500491b..632edd71f8c6 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -162,6 +162,11 @@ typedef u16 blk_short_t;
  */
 #define BLK_STS_DURATION_LIMIT	((__force blk_status_t)17)
 
+/*
+ * Invalid size or alignment.
+ */
+#define BLK_STS_INVAL	((__force blk_status_t)19)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
@@ -370,7 +375,7 @@ enum req_flag_bits {
 	__REQ_SWAP,		/* swap I/O */
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
-
+	__REQ_ATOMIC,		/* for atomic write operations */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -402,6 +407,7 @@ enum req_flag_bits {
 #define REQ_SWAP	(__force blk_opf_t)(1ULL << __REQ_SWAP)
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
+#define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ac8e0cb2353a..565acbd3adcb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -310,6 +310,15 @@ struct queue_limits {
 	unsigned int		discard_alignment;
 	unsigned int		zone_write_granularity;
 
+	/* atomic write limits */
+	unsigned int		atomic_write_hw_max;
+	unsigned int		atomic_write_max_sectors;
+	unsigned int		atomic_write_hw_boundary;
+	unsigned int		atomic_write_hw_unit_min;
+	unsigned int		atomic_write_unit_min;
+	unsigned int		atomic_write_hw_unit_max;
+	unsigned int		atomic_write_unit_max;
+
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
@@ -1354,6 +1363,30 @@ static inline int queue_dma_alignment(const struct request_queue *q)
 	return q ? q->limits.dma_alignment : 511;
 }
 
+static inline unsigned int
+queue_atomic_write_unit_max_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_unit_max;
+}
+
+static inline unsigned int
+queue_atomic_write_unit_min_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_unit_min;
+}
+
+static inline unsigned int
+queue_atomic_write_boundary_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_hw_boundary;
+}
+
+static inline unsigned int
+queue_atomic_write_max_bytes(const struct request_queue *q)
+{
+	return q->limits.atomic_write_max_sectors << SECTOR_SHIFT;
+}
+
 static inline unsigned int bdev_dma_alignment(struct block_device *bdev)
 {
 	return queue_dma_alignment(bdev_get_queue(bdev));
@@ -1595,6 +1628,27 @@ struct io_comp_batch {
 	void (*complete)(struct io_comp_batch *);
 };
 
+static inline bool bdev_can_atomic_write(struct block_device *bdev)
+{
+	struct request_queue *bd_queue = bdev->bd_queue;
+	struct queue_limits *limits = &bd_queue->limits;
+
+	if (!limits->atomic_write_unit_min)
+		return false;
+
+	if (bdev_is_partition(bdev)) {
+		sector_t bd_start_sect = bdev->bd_start_sect;
+		unsigned int alignment =
+			max(limits->atomic_write_unit_min,
+			    limits->atomic_write_hw_boundary);
+
+		if (!IS_ALIGNED(bd_start_sect, alignment >> SECTOR_SHIFT))
+			return false;
+	}
+
+	return true;
+}
+
 #define DEFINE_IO_COMP_BATCH(name)	struct io_comp_batch name = { }
 
 #endif /* _LINUX_BLKDEV_H */
-- 
2.31.1


