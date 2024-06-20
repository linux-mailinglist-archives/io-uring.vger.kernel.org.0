Return-Path: <io-uring+bounces-2290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E169104B4
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17F3E2855B3
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 12:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321CF1AD4A0;
	Thu, 20 Jun 2024 12:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gHmgrgif";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qByZpuXw"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B1D1AD401;
	Thu, 20 Jun 2024 12:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888104; cv=fail; b=d6LIFwj+OwgDdhE3YBf10ptTemt1aiVKTNvZmHMHnVAj5RxXSMvjODK1/zFRyO8lRzRc8RaFPg7mA0UbNvI8nc2/tvZXjh+hwtHqo3+6Lzqk/QKl9/iDcnTTQqGjGfXfePPD2cXxqhQx2DM9vzJO5hpzEhz9MlZO2SbAhvGD3Tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888104; c=relaxed/simple;
	bh=4sAdZ7JGrNueCiAtuiL3imnkmCYjJN/4P3Ks8wSpm6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ds7cWLP87nzjUSN6Gd5G96vkSuOKKJ0ZkXVurK/5fN67WnlHOitId5XIbEHOvJQHMBLR4UO0WZgOY6cxeF8yLVuXf0oeCcdI/Tj0O7hanwlO/3HRizomxx03Cm9uCp4alCtkUdvrQbWuXDxDiQWS+qiOZvrTOPdmmIhS+4lDvqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gHmgrgif; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qByZpuXw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45K5FPNB005039;
	Thu, 20 Jun 2024 12:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=PSQ2jv+p47f4uHMaH38L57CFpLn4SsXZ/p0FSibYjk8=; b=
	gHmgrgifzeqpnhc7fPxU/RUTHztQbMQqFy5PMGBq96+r+o+oC/GcaXWzWdkd4ZD8
	3TsdZBaVJBERyS356XsnfKzyCei2MCAKne8A/jcMeMC9J9oQ23DbQ2OPFYAZIY6l
	coeFF24dR4k9lWJs1mMNsEkrweLS/UNKuPMcMCFjelbK+jvYm+yk7iRnplJUPZD0
	ZCKSA+Q4JDu8J0QOCMkan2Ypi7973BbgYEDe0eUvFRHEwgRU33kw6VvCnCvpKiZm
	AjPYHro/vugLVph4q4UrAtB5itqRKAfARiseYJ7hGRBSgrcBsHwfFTK35vsCBx84
	81xIjq9T3aOJSxTLvdabPg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9ju2v4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KCbFwx032811;
	Thu, 20 Jun 2024 12:54:33 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dae6hc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dr0sX5fFwZd0/DtUtfaDlxG7BXNZVaZXTbnecrkJy/OzRCbGo3uI9RyNszUplsjbSjigCJVFOks13GNMT/Av0cFSrQdd/+KM29DLYx383i7X60XNSHoNkl7xZQ2mvNCJghyNidXLJX0PuD7eptWENaUfSwFb62wvSlZDDMTGM/k8p94kZBiPbnhqGzk37EFzxR6t2l3xOjgtjv2JYL1w66DTi51lYw4y2wN1m3rQPfZNjvgX7X0zjho2U/ug/TzN8efWsEb8YuOc4qYi2CNdIkEq+bmdwaVG5TJjnKPTxDtEp+RYC2WGNSrTHJ8vl91ok7YGejSrc0M7bWNTLcmlhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSQ2jv+p47f4uHMaH38L57CFpLn4SsXZ/p0FSibYjk8=;
 b=kR+4pGhPBi3SHYExdfyi67cTRsxPmLWxjzC/xDCn4KJMmQdFzTRPEGlZczX3lt9HJ+BaoFKagw7ruFitbtOf+L/HFlt5IwhJsaLg6eUrqatfslkNo9NwYPc2wIkkAclxz2x9eAOC9wMbwexPN12uf6daGc/i2GG+HwJsYeLD9O/w1Se/OLSr4DP43oOSysl3S+CCVfbxvNCbDAr86X+UWKmGRsPfenvGwYpIjbSpmLTGi6hlyepjJgWORZYmX67j1LV2XSg23xZpO31N9nNi20eKGNOiOu5cq0hmcoS0ma/kriaZZ6p73WYQvslpJgGDKJPdu6Vwv4miDG7jAEDfKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSQ2jv+p47f4uHMaH38L57CFpLn4SsXZ/p0FSibYjk8=;
 b=qByZpuXwJn09huoPpvo9ETrNZ7ZEU893FgWWasORizIymt6RRSlGd+qy+RR4ZhfydpRNOOkv1jzNiXAH+wGw0te5qAZp9o8GIStg7qLeSef7/sYSMGca8TuA1pX5YL1sYYIOFhVRo9nAv7uyzQTOum8obQyfk47toSQoYaSr1ck=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7695.namprd10.prod.outlook.com (2603:10b6:510:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 12:54:30 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 12:54:30 +0000
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
        Prasad Singamsetty <prasad.singamsetty@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [Patch v9 04/10] fs: Add initial atomic write support info to statx
Date: Thu, 20 Jun 2024 12:53:53 +0000
Message-Id: <20240620125359.2684798-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240620125359.2684798-1-john.g.garry@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0106.namprd02.prod.outlook.com
 (2603:10b6:208:51::47) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: ce2f1395-0937-4e19-506b-08dc9128203e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|376011|7416011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?vLCIV/eBL8q+N6JtCh/mY5WZ7R8Wk32f7t0SbiLzb/sZzae50PlpEHHIltqs?=
 =?us-ascii?Q?ufWEptfX1euiPVW1gdvvx/xBx25XsPFek9+HxrGeSDuoVhfSEc0uUcsAUmHW?=
 =?us-ascii?Q?9KDeRL3evscVUM6s1vbrrqXui9hbx99y9qOFZNVlrlM+8CHWWkqCDQ5Aze0e?=
 =?us-ascii?Q?wNY1tN4dqmRTBFE8AvtnBJmTw4DbLm0ZIoISe3txR90m4V2/vI0BCb+FxERJ?=
 =?us-ascii?Q?S9jelm4uCE+3CqRLkGYwite4iH8QewMGGYjDpLr5O+lMoJChGTniT7M0Oyn6?=
 =?us-ascii?Q?ftep/Mrdp8d4WOkND3l9l26XC/jG1F3nZTSz3dEM0TYnZvxsICsc/RO4e8Qd?=
 =?us-ascii?Q?Io1dKd4uIDyAfq6AuGNkDew/N7DCUuxQ5gKOJUc/d1z92x9p7DX0NbmCY/gt?=
 =?us-ascii?Q?Pd7yNrqmT6aFsS+fEDxTgJRpGzjzygsBkc+fNqEKETh21shZIrMdXImAwZnK?=
 =?us-ascii?Q?MmlUEIsvlXmUFdAvrJvHAaEnd0fNbcH+n1WhzBge76qY/LR0rPcCYjnQjuaF?=
 =?us-ascii?Q?cB2iBvj3lYg0n0eMmEct91A/N1bBH4M/r9x6r5l27zFPtSndnvMfEyIJqf0W?=
 =?us-ascii?Q?ldtd6wTZVuZP9C+0AyRlx4O/BJ4dJ+eSvMrSfvdNDeWdwJw8XU1nAejEoAFG?=
 =?us-ascii?Q?BU1orDjBg3eWTpIULOgqNURqmDdQcDpB3eyRN8mA9Up+hKD5XCx5yn0WeL5C?=
 =?us-ascii?Q?Q6yOzKdVOJKG3cDLMbte96ldXThhCVSyceDa1hD9VeZffuLRhGUUNjsqFmOw?=
 =?us-ascii?Q?HxuBPCHMWbedBsrnHrOBYJCwo9hA0ekbdoGifE2NS5/23nbYdvhyllmtccDd?=
 =?us-ascii?Q?h3rXUzrRbMN0IPeXdC6ze+16uB36BGqpQzqE1356GV57w5bx6UzhlJASoeRJ?=
 =?us-ascii?Q?Fwo/B/A8l7xfGh/G4LAGO/e9PeEC4jT41BC8GE0x3e/3nl5i5eoAVRt1Rn3G?=
 =?us-ascii?Q?31cwi8jQlKxDqeuBvFrJc8JdhHN1+JSajZuNXyK7zdMA7dtHJWMUklHktUK6?=
 =?us-ascii?Q?/Vaayq/0F2Hl292+1QQCg7xA9nu3M6cMT5VYySD6fWaK0e/Qr+oHAoRFjkqz?=
 =?us-ascii?Q?/tMhcY+LWjwSQc8d9e/wK5fQ4CMoeeXgTPmMOiMBgQox80muFElppOgDfNHY?=
 =?us-ascii?Q?wL+4oHYaPk1lFXUcK9mo78IzE9poRkGOeEHZei7Zuh2bZlpPq4eY4FDl0ST/?=
 =?us-ascii?Q?+ReurR8nv/bNBlkn+mKGPMBuhNjVVixg4WeSsDdjKWA3imU1tcVYvWYb7SVt?=
 =?us-ascii?Q?JiIni8TFARsjpUPjo6iUiN5vXq8dUQxTEGWAFW4tZC4CbPBBI7iZ9M/lUjZl?=
 =?us-ascii?Q?DocIKuQHuKK48UC+or3uKIpcXdLcDn0YE/mQN0dR3Nv+Z05CnAPAJgJQMqhv?=
 =?us-ascii?Q?6cIHmrc=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?5k2tUch9JgXgnKiQW52QgR6gI1F3SV6vMRKkhIO2Yat+vjo+5ZfYBU2499p9?=
 =?us-ascii?Q?PUKzmUNKFj0axYHkGhlLJWkU9cEOtf+9F1lzaCStOH8oo+ICyzOsxl6a3/R9?=
 =?us-ascii?Q?BjHxppdLXuy6zRUQZm5nCjBzDJqKloAkmOIHMALi6Cy7s1hh7e8/ByC8xn+y?=
 =?us-ascii?Q?6ua/kNOwoy/dA1kEhOMKwekU9zbTaiPE4RVhtw9QJ0JzgtjN+jeyd0muTXny?=
 =?us-ascii?Q?E51dRDOTOBjO6EU5xT26ZR5G+DlD6boALUJFhJSbqyG7klyDMAK6MyP/K+Ys?=
 =?us-ascii?Q?6ieojVIaHEAdIxkx9VdCccokfsOBg6kVeBgLhNQR8C6SWLL2mEYUfEK5hmLB?=
 =?us-ascii?Q?LTf5id7KX9llSczLBMPYttmKG31/Iy6s4bmQWTuXTiP8TGRuzhyzSOa6D/W6?=
 =?us-ascii?Q?7MchFMFHpucn8LHI61a0RI6TcCOLtx1W71APH8eb5QJaxPFG3h6Wc/AdUZ4+?=
 =?us-ascii?Q?CgimtL7oOadnnmnRfzeLohYYVI0Y5S5yQneQUvEYHJ3oenmZ2uTFkzXuFchs?=
 =?us-ascii?Q?vt0zuVniNRrY6rzRbVIjbK3ls7uYAYikzedSYR0RFly6zA2xcQhE8ceUeIdB?=
 =?us-ascii?Q?XuFRIJQq/t0h7yupF+u5sPFS4+TmEEzhjHKTpmA0VTTnt5HyoOvH5gQaUEFh?=
 =?us-ascii?Q?Wo8X8pi/nlfwz+WYO4zaHbk3e8AZKWmaubBGwGUXnZf5X/25ucScNWzeKIe8?=
 =?us-ascii?Q?Y4Dsz4FOVbb9kCXq+uE/lVmGh5iBvgR0ADxcnEdyjYYGeaGrma0J13CJj4mu?=
 =?us-ascii?Q?t+8o9eVmgxqTIzqOd8rn9x4jUGwBa15IuPCohxQIgCvHzac+qUpN6VXBJhwh?=
 =?us-ascii?Q?vAzSxvgpThX/m3tvBC9o19ygLTsmO7gE5TOqyZjkDJRlE3hZMkI/fkjt8//+?=
 =?us-ascii?Q?1W2zVI1qFnEy0913NepNN99NJZvTzc6+xCoaPc4dvPtD1cpoFkuEe1JfMSLM?=
 =?us-ascii?Q?kvCNA/LtFFVHms0qNPVCOVwOBuWEJpB3mJ+LPDQkj76ERN0tUQAWijY80Wul?=
 =?us-ascii?Q?izqTHlglNcqzoJlAuIWU7I4gVAq9jyTkK6TrmCYLumxXFUMVILlWonPTdii0?=
 =?us-ascii?Q?UWy3UVzjK92Q+P36tUBgHT6lCQcvCyGkhLcLesabDzoyaX5Wg0wckBt25jXR?=
 =?us-ascii?Q?yeS2vYVuOyCFj+7apoDbHocw6g3/lkz2yE7fEgEXnVoTh4m9/HsFPZbTmrWf?=
 =?us-ascii?Q?c1Yd28tRFYXwi4EXsxEGqjELn9lFvw3464aM9SFKExHfijhpreIH85HuysoR?=
 =?us-ascii?Q?LzDwuNzGCjHQTWjQpdgHCmyIpSy2ticgr+8KlHMQAjzxQR4LSxI78HJR4DWY?=
 =?us-ascii?Q?JWowHkOvEa4PM8aYaZWxC/fLzUVROIjjd1rDdr29s+dEZFiySnvX4K8ldRUt?=
 =?us-ascii?Q?g6ML4G+Ciz+X8tukFFenLlXXt02BMv8SFW9TMAjx2D+VbN4vHQcw27PhMNtD?=
 =?us-ascii?Q?jEiZkK7bcLs0QrBLgrk1c0n0B7hzXoIK7DnXrd7hxVrZWFRrixFgpB5oUQj9?=
 =?us-ascii?Q?GjA8t3YMoYedN+qhyHfl359iPPlFyQtSTfC4Rdr3XKSazxrJPDtZXlxDgfVu?=
 =?us-ascii?Q?WqcaDSsPr6x5eihdxTngfZ5PZZdcvWpY1W0G2/jUCC47YQwcaWD7UP1ddvuw?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MEApo3mIkd+y1k4EOP8E/zRzhlNucV/dzAJydasydfc3VD68aZj8AO0Hzpy6cfLPL+/O5TJbJNoKW2WG35aWMkuE5zfJya70GVxXCOPPOUru8IGpJdeYZqf/UPd0SoKgtnirFzN9/c+3+9IzYZ/Z01GR8Ru+PaMEfXAPYlrkwk7KQwcMcgdaOZ6IZp1M4dXKUrQG2e3whcp1Aw1sJa5HxYJChYTjSL2VjemFj1BML5CbAwNHCb5GUJrCoIAFW+LcG/sGRqIz6rAZD+hcqgbZQl6SJ0G7IA/66sLk6sqHHAp/PNTC1V3wbeaazeKZZWs6cCRrYLeiCjntQvk0y4+hhxif0Odjot9lXOovdjKehw3iv1iCPfdUBBdiO0mMcdy2dZMBUIFYwdJuV/uP70L8EA7FE0N6nmNkluTwdDgrYo+h+Btx14AjyymmoBk2paMOrjrVmyxCDLErF+68XsUGNaQ6XWj1fOVF29kriVXaFjAQPJuV3HFolD4RyNwi9ySYr0A+ia/oTykHy+qHtPKI4nrnJLCVsJnr37k0sI2VSiEeo9qwcQwyDauWtk5/OCj2MpPILtVLXXNNvBEpBolC+VyRPPReS3UMilcyBGKVyFc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce2f1395-0937-4e19-506b-08dc9128203e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 12:54:30.6645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LzeI7Sk+e7MJrURFN68LVZ35HadzNaguXcJezkYZlS6/aQgDcH0KIfyTMwtKXIqsQe1N+Zf+56OMnRWjmM+45A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406200092
X-Proofpoint-ORIG-GUID: 94apZO_kQAhPOfpufH0JUnVJPsAd7Zcv
X-Proofpoint-GUID: 94apZO_kQAhPOfpufH0JUnVJPsAd7Zcv

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

Extend statx system call to return additional info for atomic write support
support for a file.

Helper function generic_fill_statx_atomic_writes() can be used by FSes to
fill in the relevant statx fields. For now atomic_write_segments_max will
always be 1, otherwise some rules would need to be imposed on iovec length
and alignment, which we don't want now.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
jpg: relocate bdev support to another patch
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/stat.c                 | 34 ++++++++++++++++++++++++++++++++++
 include/linux/fs.h        |  3 +++
 include/linux/stat.h      |  3 +++
 include/uapi/linux/stat.h | 12 ++++++++++--
 4 files changed, 50 insertions(+), 2 deletions(-)

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
index e049414bef7d..db26b4a70c62 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3235,6 +3235,9 @@ extern const struct inode_operations page_symlink_inode_operations;
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
index 67626d535316..887a25286441 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -126,9 +126,15 @@ struct statx {
 	__u64	stx_mnt_id;
 	__u32	stx_dio_mem_align;	/* Memory buffer alignment for direct I/O */
 	__u32	stx_dio_offset_align;	/* File offset alignment for direct I/O */
-	__u64	stx_subvol;	/* Subvolume identifier */
 	/* 0xa0 */
-	__u64	__spare3[11];	/* Spare space for future expansion */
+	__u64	stx_subvol;	/* Subvolume identifier */
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


