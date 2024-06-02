Return-Path: <io-uring+bounces-2063-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C8B8D75E3
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 16:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D91D282494
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 14:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD3240867;
	Sun,  2 Jun 2024 14:10:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6243FB2C;
	Sun,  2 Jun 2024 14:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717337418; cv=fail; b=ZkEUds2feC7cLnEPbkHKhF116jiOAPtb9glWqrDHJeFHw4EZPmroMNc8S379TTS6mJEILjFHBrttVRZkhVCYt4AbFrfuowz0J6PhNv9iv0gyqkRQi4jkE6kkDRPaXx4jtrXXSgWdL2xZoSSEoQnpMZ8LEToq3jKwdjQNcTiRFXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717337418; c=relaxed/simple;
	bh=CFBO+VT18ojxHlDEWoFWs3ElF1fAtRAorBJQkub2TFQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=d94pJj0zOWZQ9gscVg87FMJvZD2EffmX5VVnKOCMeiIqb+ztEJCWLvv/YRUxtM6b8FU0Btrh6ckY5JYQ22T7iFKYP+LpX2ZUQqsr+0/sRy9uRcytGUzqZiSi8OOu+NTYIRsOPZ600Zg7HrEkkkVeSjuP7ckbIr7wkfpIEhCbbMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4526jwCm031309;
	Sun, 2 Jun 2024 14:09:45 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:message-?=
 =?UTF-8?Q?id:mime-version:subject:to;_s=3Dcorp-2023-11-20;_bh=3DKpcVfxMo6?=
 =?UTF-8?Q?yonKCrC6qgtcSvs3vNfWS2EuCIjkp2PNwo=3D;_b=3DUUuxOyOTXm9zJ3eNsP9I?=
 =?UTF-8?Q?CZRMUJM5r1xa94TNl0blSsIUa7x+V7b3AEkAji6uo+R8dSh7_GXog3sZpEVsNbH?=
 =?UTF-8?Q?6pctE84B9oR7bxF3oF5nWxS00KpWfW6G/XphK7TA4qXcvandNQbmDK_89dBrh10?=
 =?UTF-8?Q?w+BBQs6Bune24xIrImEmWU7pS1+kEjxKpjQvQTIs6t2SuItGGJGHXjhGdFJu_6x?=
 =?UTF-8?Q?k05e2ZkJJzCtL1ZAnTRRKHqo8qeXhV2Ky+B7s5KaAcQFh6tkJf09C6L193SuEZs?=
 =?UTF-8?Q?2CL_py3Ea3fmQ6S4x0K7X70fJaFW/6p908AqvJp4dJmGImIrpzU6BvH+d9OBsH0?=
 =?UTF-8?Q?+HufoXh4f_kg=3D=3D_?=
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv589ck7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 452CUmeM021076;
	Sun, 2 Jun 2024 14:09:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrt699g4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e32oLYwnH1DpXniARh4WdvPf8u6zcyzYxuBcPZhxBiM3dTYCSin6yHTcQph/dtSenFC0DQwyssywujwvVkB9uOHpkWZjksz0uG20RJsIseXWY1q+U1scTg12Wk9mG+EpQn6rbnqlsulQdORB6PNVw3/iN3K/6OEneLidYbopGGjV5v62qydmm1RodcirHiKeP1+Wpu+Ff6Gmho2qjciiAuBNdaC/pq9NSeJE+rlH/nni/g9qJuGTf4ucdhVJS0ySgH/t8x5r2TNryfNy0bctqT5Ru8vczG/w7Pj/xk1Kvi5ZFGP6In/izuCp4l+5qbnr/9aXevGN+ETGWuzp7YwiNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpcVfxMo6yonKCrC6qgtcSvs3vNfWS2EuCIjkp2PNwo=;
 b=Qa71veBu3/c8y+wk7UP6SwEv/GzK1UyR8C7Fw+dXidrtyq4BT4mjTMWRn964u4zOxaOGcYQFHEGAcCjVHrEJw+SNwNpopmsMiOqIUt5nsW4pHpFFfq1cSWbvFM6B6SWIhsFbRjhwHeLYkKnrA8K0w6FmvXFbtZSw6xEgI8SJk/p6O1IGupSnA6zeI3rWhPIiWTmm+gjRoE+cr0X+b1QbyHm0OyTyfDdgtQ5gg2a6xerLreNcvHYmNhEbH6lw8hJWUZSN4EzTj5NYxYHZs0OnB0ndMc3z8fNbV6xpLVqkj7nN5PRwIGQWP4cC70IO32CGj5ZcQe4eFO+kIK+cMbUpTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpcVfxMo6yonKCrC6qgtcSvs3vNfWS2EuCIjkp2PNwo=;
 b=ucxVO5fKN4h+Z9bpfPFIQEO+28Qg4GN2LNeDhlSEuSZU1JrnbR8Ee0fyb8mVz3UNdGp68ND6ubJo8GOMWTl9fGSWNIlVC+lFvSonx1iX31X2+sgHiMF4toVKQtxZtIMoeavw75Ksx/zKuf1DX2UoViom3FHy8HjgjK5ifCt0Dhw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Sun, 2 Jun
 2024 14:09:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Sun, 2 Jun 2024
 14:09:40 +0000
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
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 0/9] block atomic writes
Date: Sun,  2 Jun 2024 14:09:03 +0000
Message-Id: <20240602140912.970947-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0013.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 67dbca53-e7d9-422b-cbef-08dc830da4a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|366007|7416005|1800799015|376005|921011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?RktLckhKYjlaZnFCSWRZN3dBaGRUN0phTGZuY2I2cnlaWVloMlYyYzJUcXZZ?=
 =?utf-8?B?SjZ3UzNxdlFyMm9QbFdCUURNaHl3cnFpRjJ3ejRVODl5bE5URHlnTloyNmVD?=
 =?utf-8?B?YXl4Y1BtZUFKdC9vd2YzLzI4c1VPMmxnNm1TUlhWSlZzcmtaVzkvKzJsVjl1?=
 =?utf-8?B?WnlJajVIZldUcFhqeXA4MnBlckhjS3hWOHBkcVh0VGVKekVSTUtaQVJOVnJR?=
 =?utf-8?B?MXFIaGNTanl4WHVjOVRrQWZMK3pMMS9ncmdZYU9NWG9RaWg3Rm40TXpGUERh?=
 =?utf-8?B?bUdkL2VLUW1TZk9rekVpMndLdFNxd1dPamRUcVZ3M3ljN1ZZZ3FML3VxUGQw?=
 =?utf-8?B?Q0MvSVYvb2piZGkrUHh1R1dBQjR4dE9JOHdOcW1TVkNqRk5hdFBuYlNqN3hn?=
 =?utf-8?B?dGh0ZUJDN2RXU0k0R0dETXJHVlFXNHlwZEw2M3ZXbDJLNWxGekMyak51M2VW?=
 =?utf-8?B?MEh2WDdBT25MdXM5M0VQQjB4MGYyYnR1NGErbTEySnRXdUo4eVBoV1RPUGo1?=
 =?utf-8?B?UG5hUENCVkl1a3FoWWFudHFtYW81SmlIam1ENXVtdGM4dmgrZU1TaFRnZmE5?=
 =?utf-8?B?TlVKWVMrODFpTEE0MUkzM2hXd0thaUZ0cWhDMkJMRlZEQWl5cHAvdkQ5bGQv?=
 =?utf-8?B?a3NJK1I1TU1yV21Yb0dBWjFBbDRmaFRueUVXYVRqd1h3UXJFZnBub3lEK1BP?=
 =?utf-8?B?WDdFZXFMS2FSZTJtaDlhdWlJMm4xSXRtVWxXUDZpMWVBQjFMNG4zUHNjalVq?=
 =?utf-8?B?cTFvSmZIbUp6aDBQamlrS3RmQ3pESDY3MG9mQ0xLSXEvTkF6d2MrRzMyeWdM?=
 =?utf-8?B?NU8wSWFnTytLdytkOXRDaEdGa0kxYXRQenNLREdCY3RWR0VNQ0d4clVkK29B?=
 =?utf-8?B?TEFMK200SGt4TlFoSEVCS2lkS3gzMldGbVVtcC9qek8yUE1zOUNaenQyUWpr?=
 =?utf-8?B?cXNMdUI3c3l5ZVR0V0E0SUY5Z3hUbk5TT2ZnOWNMYy9Zc2l3cGRsK045VFg3?=
 =?utf-8?B?eHVYRnE5RlRaZVE5Y3R1R1M0Q0VsV1Y0Yi9xSkpDMU1LTkVBVnBuamZZUUw1?=
 =?utf-8?B?U0kwVk5IdHB3bmZvQXppYWw3M3F3UFZIMEJuYkhYYVRqZzIzUWYrQithQ3Ja?=
 =?utf-8?B?Vjk3MkNxdWpmdWlBL3dGeStwWDBTb2d6Q09Zc2dNd3ljYjJxeGt4NlhJdE5J?=
 =?utf-8?B?cFZJUXV0ZkluZVE4V0dQSGxEMFJGQWNCeHU5NDZraWc2d2RsQVBrWGFMMXo0?=
 =?utf-8?B?dEk0NElhR09uTmcrT2d6cElpZ2RZT2RXcDJVOFlBMWViUVFDaFlZZ04xSXNX?=
 =?utf-8?B?TU16MTk5V0V2MzlVMmpQeSt5R3ZmYUZybGNsL0VkMXlrcDVaM2g5bW1LOGdS?=
 =?utf-8?B?elJkZ2lOU3BnMG1haDNwVjZEcXE4ZVAxRjRFRjA5b0pKKzl6OUh1ZHJ2cmlO?=
 =?utf-8?B?eWdTZDVuSW9vK3pzU3ZDQnFnc0tuT0tVMEpiRU9qYkxWMHMxRDNib0EzaENC?=
 =?utf-8?B?YzNwWTRoSjkvakdhdFVyc3VCRGNLckYzbzZrMkU3SVNaUG41M3RuM3JLWlZZ?=
 =?utf-8?B?WFNqTis3VE43ZW1uaWsxUFJsRWJHYU95SVdVS2UyWm5XeFEzTDc2TVNDbHBB?=
 =?utf-8?B?VFVKYzNEUDVzUWZKdVAxTi8xa3I4UzRmTlZUNzFvRzh3dzVBaktXSFRab0xs?=
 =?utf-8?B?dG5LYnNEdDZNYzNvZE1DU2JEUGJCYjdOSUlyWkwrczA4dW9QS3pqMzR3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WUFqWFBsajMzR3BtYVN2YnYxbE1RQituckZWNUJoWkd5TXZWOTBrQjdIaTBk?=
 =?utf-8?B?dElEUUk4VjdaSDZUc1RLVUpmVmp6ZHExa1o2SXZ1Z2dLS3JPVjhnaHoxb0hM?=
 =?utf-8?B?V0ZyNnhpK0VudGt3MTVBUUIrRzNaUmdrRStza0xvV0JlNU1SZHU0WHZvUnZW?=
 =?utf-8?B?N0ZjUHFXV0h1V0YyaDZPV2s0ZGpOYlRONjdjM3hCWDNzb1dtRklJa3UwT2tZ?=
 =?utf-8?B?RWZOSDRPREx3TzByVzVaVXNTYUozMnR6N2dNSElqQVp3UXBLdjBxaFI1MW1x?=
 =?utf-8?B?RXVoQ1lqczhxVytJb0sxNnFJTzdzZVFtdEZkTVp1T2QwYjhTa2pWb1FwTEp2?=
 =?utf-8?B?K3JlNmRrbjh1bWUyaVExVW54SXVlUWRTMnF4emlmaXVUTHlrNmVuaXpnVVJG?=
 =?utf-8?B?M3htZUEvTzFXRUZaRUo3MW5rOXdKYmtwOEpaRHlFNkw3QjNoR3AwZW9iT1pt?=
 =?utf-8?B?MStBK3hEQ0ltc3VUNjhreTBwNkM4UDBRZmxkOGxxKzFhc2VGN0lsc29JY25S?=
 =?utf-8?B?K01tTDcrc0p1MCtLWU1zVGlycTNtTm5EclBma3hteStJc0pVTStnSUpXWVhD?=
 =?utf-8?B?aGhESnhCdFN5S1hLdWNEL3pDSzdpcko4dDRGL0hUODNMRWxlcnM2SXIwVEZo?=
 =?utf-8?B?eC9IcDdTWUdiTDlTRzZGYkFHMDVlcXhQN1BadGRYZWlHVGh3MjdlanltVVhC?=
 =?utf-8?B?aXl4L1lBS3o5cVYvZTZKUDRYNWRNY0JEbDJISlhjYzBTMm55eG1IWmt1amsw?=
 =?utf-8?B?a24wQzV1SnpXZXlobDl6blZqMHN4L0s1Y3BBYkcrQXA2NTI2YmRrSFEvdmRM?=
 =?utf-8?B?b1lNTnA2ZHNZaVdPUmpKd2FIN3d0aVZrKzlDU1lEa1VFVWQrc1crK1B5ME1B?=
 =?utf-8?B?T2VDaVg4VXRlZ2ZzKytjeGxXMzFhNnprclUwb1llbHhVNGZvcUFPZ3orSW1Z?=
 =?utf-8?B?MmR4YUJKZzdhRjYxV0lPRlN4ZkZnbHoyQ1pWK016c05UMGc1RzdGMVZrVUE0?=
 =?utf-8?B?R09iUE55Q1NEYnpKOFV4bXhWcEx2aXJxbnRPMTFQQ0xkOFJRRHVLalNnaVhP?=
 =?utf-8?B?WllJSE5jZzlxc1NRYWhzQi90YmVsMGMzSU8zaFhtYkRReGxESW1XSUt3Mjd1?=
 =?utf-8?B?ZWhJL29UY2RGVHhDQjNnWEdabUdDeHQ1V09sanpEK0xuemhCcVlwV3VsTHVW?=
 =?utf-8?B?VzNZVmlxNkJpV21FeGlSSk5IQ2VMRjloRktsR090MHRVWWFkR2U2U0t3Y2N6?=
 =?utf-8?B?N1AyL0o3blAyMkVmQ3huUXE3Nzh4S1A5R1RBSHNVQTQ5TWFiWENiWEc0c3Zx?=
 =?utf-8?B?NmY4U2RidG5wS2k1cDl1V0ZVTDA4bUQ2SlYwYVRpa1dGeUVzc1p6aVZUVDJz?=
 =?utf-8?B?VnZYL2UzeW5PdXVkRXRyeUg4UEsydFJLc3RWTHRQWlFuWUNjYzAyMU1kNnZY?=
 =?utf-8?B?eTh5cjc5MlhCT25SdDhFdjFoVCtJaEMvZk5HWTA5NC9WTGpPSFJrYlB0amNp?=
 =?utf-8?B?Nk5MN01ZblU1NVJaSEJyeGRFTHkwVEJnRnM2N0lGUDgyZUQvUVNNY2Y0RW1q?=
 =?utf-8?B?QTUyMXpDT0M3SitWbDlPek1QL3RHMktKY1pFY01GeUdtQkhocURkMG5lVlha?=
 =?utf-8?B?cHFQTWp1dG0rK0JJWGVPMGxJT1ArellHclAvMlJBMmRGUnY2eTJ0MFJUYnlI?=
 =?utf-8?B?MGZRbi9Ha3pWU2xNc3BLMU5nN2prYXR1WXdrakt6c1lvQzRvYjN1WndVZ2Y2?=
 =?utf-8?B?MzRxcmJoQUlYVm9IdGVYYStFZ3NMb2pRaE90K3JCTEhPNDc1emZ2Rll6alVm?=
 =?utf-8?B?UklNYzB5UW10UkI0RDMrd3VSNEVBWjU3S3pHeFlLNUFtaGdSSmpNYllFUDNo?=
 =?utf-8?B?T1FoaDBqNkJRdnJGQmx0SU1IazZtY1d2NllOQ1MyMm9TSUhSOG9vSElzNzVC?=
 =?utf-8?B?Rmd6TmFQUDhMSE03QVRPdTg4OTB5ZnRONHJQZlR0dGpPNk9DeUQ1Y2RCRFh5?=
 =?utf-8?B?emVBMk51TlF6TEl6UlEraGRBKzkxU2dDaVJwbmdlVlNIbGlmTU1IcmNQWEVt?=
 =?utf-8?B?U3pzU1kwaVRlSmNjSnZSdEZ6TklkcC9va0Y5L1VkZFlDbS9yOHBzSHN2aWlZ?=
 =?utf-8?B?c2Y2NHlwVWQvbDlZbThqcFRRVlVRNVMwWmI2ZklNWTNPemF2NkFsUHMzL3Qw?=
 =?utf-8?B?L2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	RZC5WT+bnD33T8xpn5K+U2hyTyKzVQHyTTcr1umAjCpXPD/qc3AM8n0CSUtGUabt7AYRGXgJNyaR8Ix8g2VVZhl/cUa3/OmuCJz/lGeNcr+R2Bn+hAO2+wfZE2gXDt2eeCOud39NMJg6HiPSnAWWY/vqhMsrMhmuhmBljQ3SbCXS0z5E17Yw1acRnl7C+CA84jwSeOKUqMVbXBGT3O3hdJCQKgKyvtCPnxRpF1ohxche4KkIvOsR5bcUKV0cIh6NnpHyu+zwIjca/BQQgHTw9nAtdREwboFBfX4/b/WKcRlMVsCp+lmKAGZTMMe8+1jflL5UXqqyPJ5qzUdUTY/STukWS3viwTBQ/hF+O6+5o+YPKuPD9kLS1a1qhlpPoB+oG8za6arLqqhXSxe5cVgrQDsYB9RW/3C42btS/rcSsvhSuLjx7WfDbUKuIXbxxrjXVuZisocHy13UBLN2VvSokYTL20S8pgUqeJ2sQVgHw5WEieMCLDMDPFxxkIe4tIZ9vnsWzAtyF8x33lSgvida/RJGZv88FQWz7WE+iIU38zTKg0M7QtiE95569tFpWUo+IBIWBrHYhivXDQsklfqtU98Dap/sj/zbw2yKS8k0fnE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67dbca53-e7d9-422b-cbef-08dc830da4a4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2024 14:09:40.0900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSv8OiuG5lvvUq1ccBX2beOS3Rl5LsrO0BxMaa7CHPAHvIPn4g6QFkRr7uLEX/nCmjiXnyiCZs3stP5cQhz/Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406020122
X-Proofpoint-ORIG-GUID: oQUAhif7htos7MtWbkdrGYjITqJEulL0
X-Proofpoint-GUID: oQUAhif7htos7MtWbkdrGYjITqJEulL0

This series introduces a proposal to implementing atomic writes in the
kernel for torn-write protection.

This series takes the approach of adding a new "atomic" flag to each of
pwritev2() and iocb->ki_flags - RWF_ATOMIC and IOCB_ATOMIC, respectively.
When set, these indicate that we want the write issued "atomically".

Only direct IO is supported and for block devices here. For this, atomic
write HW is required, like SCSI ATOMIC WRITE (16).

XFS FS support has previously been posted at:
https://lore.kernel.org/linux-xfs/20240429174746.2132161-1-john.g.garry@oracle.com/

I am working on a new version of that series, which I hope to post soon.

Updated man pages have been posted at:
https://lore.kernel.org/lkml/20240124112731.28579-1-john.g.garry@oracle.com/T/#m520dca97a9748de352b5a723d3155a4bb1e46456

The goal here is to provide an interface that allows applications use
application-specific block sizes larger than logical block size
reported by the storage device or larger than filesystem block size as
reported by stat().

With this new interface, application blocks will never be torn or
fractured when written. For a power fail, for each individual application
block, all or none of the data to be written. A racing atomic write and
read will mean that the read sees all the old data or all the new data,
but never a mix of old and new.

Three new fields are added to struct statx - atomic_write_unit_min,
atomic_write_unit_max, and atomic_write_segments_max. For each atomic
individual write, the total length of a write must be a between
atomic_write_unit_min and atomic_write_unit_max, inclusive, and a
power-of-2. The write must also be at a natural offset in the file
wrt the write length. For pwritev2, iovcnt is limited by
atomic_write_segments_max.

There has been some discussion on untorn buffered writes support at:
https://lore.kernel.org/linux-fsdevel/20240601093325.GC247052@mit.edu/T/#t

That conversation continues.

SCSI sd.c and scsi_debug and NVMe kernel support is added.

This series is based on Jens' block-6.10 + [0] + [1]
[0] https://lore.kernel.org/linux-fsdevel/20240529081725.3769290-1-john.g.garry@oracle.com/
[1] https://lore.kernel.org/linux-scsi/20240531122356.GA24343@lst.de/T/#m34e797fa96df5ad7d1781fca38e14b6132d0aabe

Patches can be found at:
https://github.com/johnpgarry/linux/commits/atomic-writes-v6.10-v7

Changes since v6:
- Rebase
- Fix bdev_can_atomic_write() sector calculation
- Update block sysfs comment on atomic write boundary (Randy)
- Add Luis' RB tag for patch #1 (thanks)

Changes since v5:
- Rebase and update NVMe support for new request_queue limits API
  - Keith, please check since I still have your RB tag
- Change request_queue limits to byte-based sizes to suit new queue limits
  API
- Pass rw_type to io_uring io_rw_init_file() (Jens)
- Add BLK_STS_INVAL
- Don't check size in generic_atomic_write_valid()

Alan Adamson (1):
  nvme: Atomic write support

John Garry (6):
  block: Pass blk_queue_get_max_sectors() a request pointer
  fs: Add initial atomic write support info to statx
  block: Add core atomic write support
  block: Add fops atomic write support
  scsi: sd: Atomic write support
  scsi: scsi_debug: Atomic write support

Prasad Singamsetty (2):
  fs: Initial atomic write support
  block: Add atomic write support for statx

 Documentation/ABI/stable/sysfs-block |  53 +++
 block/bdev.c                         |  36 +-
 block/blk-core.c                     |  19 +
 block/blk-merge.c                    |  98 ++++-
 block/blk-mq.c                       |   2 +-
 block/blk-settings.c                 |  52 +++
 block/blk-sysfs.c                    |  33 ++
 block/blk.h                          |   9 +-
 block/fops.c                         |  20 +-
 drivers/nvme/host/core.c             |  49 +++
 drivers/scsi/scsi_debug.c            | 588 +++++++++++++++++++++------
 drivers/scsi/scsi_trace.c            |  22 +
 drivers/scsi/sd.c                    |  93 ++++-
 drivers/scsi/sd.h                    |   8 +
 fs/aio.c                             |   8 +-
 fs/btrfs/ioctl.c                     |   2 +-
 fs/read_write.c                      |   2 +-
 fs/stat.c                            |  50 ++-
 include/linux/blk_types.h            |   8 +-
 include/linux/blkdev.h               |  60 ++-
 include/linux/fs.h                   |  36 +-
 include/linux/stat.h                 |   3 +
 include/scsi/scsi_proto.h            |   1 +
 include/trace/events/scsi.h          |   1 +
 include/uapi/linux/fs.h              |   5 +-
 include/uapi/linux/stat.h            |  10 +-
 io_uring/rw.c                        |   9 +-
 27 files changed, 1099 insertions(+), 178 deletions(-)

-- 
2.31.1


