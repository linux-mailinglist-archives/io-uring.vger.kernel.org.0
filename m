Return-Path: <io-uring+bounces-627-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C521685A412
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A54F280D41
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9619C364D6;
	Mon, 19 Feb 2024 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UmJL6SPZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t1czU8EJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B53E33CC4;
	Mon, 19 Feb 2024 13:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708347750; cv=fail; b=cTAcR3f84Aj9vhYh7crh6o9FS8RTbr818pOJwHRMae97CX8+iQAc0m4/AVGko++wmNI8iw/hthWDePwnWru3/LrBvXqy/X0+xjakfyQD+wWUNxXjqzj9XDDN615kAKKbg7/CF61y2u3hgugB5cCn7IKCEURB1phPJ8mmlGIOv/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708347750; c=relaxed/simple;
	bh=huc53aKniPfUsQBehD92bbIF8N5He/xLzF0Q5ngFEhg=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=AZDvmoTZ6KJvmDkW/smgUiMXNzWqVytXdU7YikAunIAnuZvDl+nIUS8MugpYrO4K6O23qqTt1IJL5Uf1aZNOpTwJYM+b3InSztie9PwXC9rY8QE6McLf26yVtN7ZusEVk+f0j8cUsroo1pSEp1hkliPcnxUmuaFUQLE7O94aEO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UmJL6SPZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t1czU8EJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8OEx5010905;
	Mon, 19 Feb 2024 13:01:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=IRvzjUPMlrBO5rMzDtv7JlCUNJfjDt6NyhaXCI/dTGc=;
 b=UmJL6SPZ5hGVBAD9QKEe0VnlGmkb3ffW8zo1OTTDw19G4foCQ6k479336ZcU5xqwA1lG
 MB+tYtZE/e7eLX2ZerblJFxzcCpGcnQZ65ZcVqEOqiqOykWlG9zJLc1n4x6czLj7yiiO
 1cPedNAqmaBBnAKBC62YWVOH+Bw3IRytKTwOODHIZ8hDtHYNEw8me4g5KAFRd52m2oG7
 vv8Ke4K9PfevG+k6iTQS7QyFHsZSptohRvMQ1b9YFEhB3QWZrwDOr9ReYm/zbykWJE68
 poHYhc3G3vdIz5+HuBqet+5dPIrRcJsgOWmbpZSN+9DsabaAKwITtQSZNLHiqZ8mn+9e VA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wak7ec4gj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCP9Jl039937;
	Mon, 19 Feb 2024 13:01:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak85w551-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giEPz9I6zPSQI2EEY14B2/oUMAp1WH5Oe7Bi/X0OUoS4jrXeVm7GNYxIK/vFRdoFAFpNTxYTub41UhdBQSIs7XCAyteS2TUKTwHxXcEiX9fCJXihY1mBwqfMl2DshTB2IjZjz2CvSduKAUxnep9srv9QsPIGKiMVPblTW73Su182xQJUsK2cvhjPfi7IsHhb3/Dg1lwQwjZpaDqU/93damaUKtvHTmnmD/GvAktcr60j8pHNrLejrQpUCSoQL5ES9TwUdfKoTaz6Af7B6Pf2+k1X3e9I1OXgITvMzwGTBcIzzfweNicKMBa2u3W97aEUe33eBovS22gI/JGXGWSDzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRvzjUPMlrBO5rMzDtv7JlCUNJfjDt6NyhaXCI/dTGc=;
 b=BiumFUB4OzQC8r6s1eMMNpqXf+CEN4BtqTmfr0DkunDysu5nDrfjFts6+g6+XYhMUKwwjCVNVxY0UgTTTN8P7Fj7qpRuSEvzdFRJBP1GEzhyReyd1Y+uigMVkxV8H8VRUAZ0Ivx+TdWdeFi0F8z00kdFHbYLPoJriruTKbh63lYNK6RG9WO/p3XLUvr8laeHAl9Avf709awTVpIPN1kzXtwOd7z/goQbRZw0NhVW6QJTzngZErexrVx+bZHE2zxbrOTB0yS470QQT5OI52C5rJC+Fl/t0mqs9CsbK3R7Qu9MauFZub1yxO+u0yqM/rWaSYomB0G+h0fgvI4E8cks1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRvzjUPMlrBO5rMzDtv7JlCUNJfjDt6NyhaXCI/dTGc=;
 b=t1czU8EJ79eG3Lu9Ic3ONbut2Yh+7W+uemv+zUVowtu+H7+U43n55dzrEyN0doWl4mDm00X1IE6IpG6fYWlHuRvP22iO5jdWKZH4WhXythbRn/VusRGvhzGZ5aA/HtERL1xf2IEY9M6SV5nwoMFMb0f6yXCHS7FKjKtcNRcAD0Y=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:32 +0000
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
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 00/11] block atomic writes
Date: Mon, 19 Feb 2024 13:00:58 +0000
Message-Id: <20240219130109.341523-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 96321440-c910-46c8-5754-08dc314ae4f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	F3VJ67kd/aVgTifhTemgY4/aMzD/1mROuSMEjrKJy2d+GwI7Fvc1ehRV8J1TZhKVKBr0aYvVaa1YFSXMxo/ONLInQM/bi+uKg0Zfaq0RnrlUKYS/wzT45ttV/ZLqyrfNOnVG3On/nNLrsTrqAXMCHhpHpEpW6F4xkClzyX/6xKVrCNB7zXtuC55JV1x4VAaa6g+vhVdUAZBWOhbrVMjbdApGl4wYMnVu2JeZz5VnEv9hDefWvkkCoI9QF81bv6FO4GHc/89WmZNZ7Fu8P5pSQitReOu8H6bvrRe+oCMCrwm5YHfIv1em6/643PzRIibLe24SBUpKGDvcGKRb+/0U+3xGt7kjAZglOMn8BhmdGkWbEmmYk3y6VhGtnDkptJ/n9+mS4ZECg6FLXtU9QPntq1UfQCzzO4GdV58DpvnOvAxS7uuPf5lWW8s6VDSMeL6uwMmoMhChNKIiQeEeXLdYiYDwXX8eqvQApqvSrSuFpZ0qDz89qWeVGlmes0/2G3tTbPESeNix/27DJh8aBc6ehLXiZYannzcpgrAjWYxO5CH1ofbCMVzkZk0jV9qbyjOaAhnET0DRsojNLj0oHJB56/TT0aefNRHtkaV+bBjRU34=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZS9SMGdDUzJpVC93SzBiVzhaS1RiVis1UmdNbDl3ZmVmTFJ4dkhYb1FwNkh6?=
 =?utf-8?B?R0RsdkFNMVRpanVaSWZuSmtWdmpxSzhGMU5uNFZVVGJnc2x2cU9sMFMwakxE?=
 =?utf-8?B?Sk0rdDgvNDNzZ2MrbTNsVXQ1YVpvb0RqamtrWklOSUtPaVNVanIzNi8rVW5E?=
 =?utf-8?B?dHRQeHlsQTBGZUFqakFHYklFN0Z4dkV2a2hIckpBSEpnSHlSWDVGVlRCMWts?=
 =?utf-8?B?ckJaVnNuQzFBSldNNTBjT2tPeE5nbEl3bVJEMVExREk0TVdhRnVMUDRKQTF3?=
 =?utf-8?B?VWo3Rys0MVVhRWxoWVE3VncxVUV3TW10Qzl1SjFvV24vNnM2Y2dRT1FJdXJJ?=
 =?utf-8?B?Y2o2SUdvL1NnYTdBRXBCSHJsL2t0ZzFiNjJZVTNsZFgzWE5hL3krSXl6aS9Y?=
 =?utf-8?B?OEFQNkV2NHBEZGI0U1A2WDJRSjBDZUVheG8vOXg2Y2ZjaEIvdE51RDdpM2RC?=
 =?utf-8?B?WStrYmlMamJmcFRNTldsa1VOdkdIcVNBN2hYdGMzZW5OdzhpVC8xODRWN2hl?=
 =?utf-8?B?VHpZM2FSdFhSRWZCUUxDaitId2dYMkEvaG9SZDV0ZTNYY2hyTVY4Qml0YzI5?=
 =?utf-8?B?dFFoN3lXWnVsQTR4MnA1SFJPdXY0QWR6a0dXaG91enN6OXNnaTJ1SFFCNGlJ?=
 =?utf-8?B?S3NrRmNVdjgxUm9aa3Q4S1lCTnZreGptTTlMNUhrU2FwSHpSZ3pRTHhjdXor?=
 =?utf-8?B?cythY1RIM2RiQkE4U2R4YTRHL0w0TGU1WFRkQ1pQRHhFWlFmQkVXQWFzM2ZO?=
 =?utf-8?B?NjRqWGVBR203NkNBWVdwaTRLNXdnMUowcmNpZzY5MWViQy9FeWY0L3J6NHNV?=
 =?utf-8?B?RzdPZzkvcC9TUWk5SkRPVDJDZ3h6M2o0ZDQ5YWNUMEZPei9YQXRqM3IzeHZv?=
 =?utf-8?B?STBJTDZXZmxzbXlRNXpZWmVCeE5pdE94RnJSSllKMzdkaVk1ODhQYTFxeE9p?=
 =?utf-8?B?Q01jcDRHcnJsaDRiMUIreUtHa05xaTh3VkZsczNrdDROalJIYmUvVk5QR1RC?=
 =?utf-8?B?SGZ0a0h1UzgzZjU5citqOWxtZFZmMUowR1N1eEg4K0ZONlFMV3NKMjVVUHBM?=
 =?utf-8?B?bDNES2tXdC9pUkpQWTZDVGhIY2F3bGZqN2Y4L3lsakNSTVNkOTc1dkx6di9a?=
 =?utf-8?B?Yko1TkgyUnhXcFV4UHZqMEFPNVc2ajJHZFVPbENhbDVmdXhUdDlvSWZWQzhK?=
 =?utf-8?B?cTlsNGVyQjVUUTJkTndoa1habnpsSERObHJJR1Y3TWdzWnlvR0ZydkpYQlI1?=
 =?utf-8?B?YmR4WE9PVUk3SFpuNkl5ZnlNMWxndi9DRGVncEVzdUVNME1Ga2hEbnk2bkJH?=
 =?utf-8?B?aWRmVElWaFNxdGFwaDhmS3IrR2tTbkwxa1laNE5JRklZNmNqc0hiaTJxeXY2?=
 =?utf-8?B?ZDBnWGpocFlJVFkxZHNodFA3Y1BoMWxwa1BlVUJXUWgwb0x0YVhwWVJVVVFX?=
 =?utf-8?B?VmdsZUJNNm15emhTYWpxMTRBdGZrNkQwY283Z0U4MnJmME0rYk44dXRCclNr?=
 =?utf-8?B?TVhhVUJneStMZGJ6NWFFY1hhT2FOeXJOUDBkMitZMVNxeDFDRFBRdFU3cDZV?=
 =?utf-8?B?cFUrNDJtL0xEWGR1UzdRNVRBYnN0ZHQ2enNCVzlvVDdhQmEwMXpWUi82K1Ba?=
 =?utf-8?B?aTJXbnV4QnJ2Z3lqdkFZSzY5cjdXbE45Q2RmNE96azQ1TzZPZGFWakprdzZM?=
 =?utf-8?B?T25rSS9MR1A1UE9BT0t0eTVIZmRkczlTRElGSVY2ZUVJZ2MxbVQ0ZTU0TTU5?=
 =?utf-8?B?WTI0cDJrL25ZU2RuUWI3amtLMGNBQ2plKzUzN3d3bm1kcGE1QUZpVDVYaitD?=
 =?utf-8?B?RkxMSDhVUUVXbHFmZ0lDSDNVWDh0Z2ZEWjlaazJkUmN4MCtSN01xT0xqVU5Y?=
 =?utf-8?B?Q29UTFVSWTFsYlFnQ0xaYXYzUFNQaFoxWHlvTzU2OW1WZ3U1NHllVlZxdFRV?=
 =?utf-8?B?NlRrTUJySG5DU1RZY2ZQQUZITXJZamJRSVpXV05FOGpEN0gxamRDVkI0T3lK?=
 =?utf-8?B?eHVzQW1LZklXVC8zWG5TMXUvTkhnOGFobWZaVGJIK0ZFNENuV2FxQmpEUG54?=
 =?utf-8?B?WDhEWkNwRDVjMHJmcTBTdzZxMjlJYlRYL0szYVc2YUk4UENtVmVtZVpxc0RJ?=
 =?utf-8?B?QkpBcWY0QTBQZnRtN2NmOVlJTmlVT2JCayt4Zm5tQ3JIZCs1TDZHL2VLQkdo?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8cZhCBJfAzRXuC0gF0AfMgKq+I9/cdteBYkcmkPX0JGw21fX6wDqrYwgxx+HEX03O3iRRZnqcfrGCGJQAQDbI7byu5NVmvfkgtgyH3KyJdXdQL1LNNXYvDbChHE1+mvCh3M5t0R7fRC+/LAeikdMl+hWV7Cw0Z17bCbeb61YrMzxi3VwjHRqOe8iVkzL+xgwsVM0VSZKqACgs/ojNd0YNW4p0OekjHOXisWoOWTi39h48fIbg6m4XIR63G8irFGbcw7IBmeu60jySvCMwobWviCppt4YNgSoRjeJm+c6fH0aIVymWiaSaQn5M3PG2DtSPksPTnzauAkn/tapOy+p1nQBAX5ELrzi9jIfpQ5BQ19WdHanfcXgSLn5/Q9HYVd28EkwuhMhdHf1Gq/4uBQ4NHbDNW92dgCT3uNoM21bG7T+yCQDM5lQXAYDYsD0Ys9Ls6X8eo8mVbVkTFO5oxJCR0SdW1+fhsyInqIggWXx4m7no+5YFtnv1AHOxbyBRVLbTRof3/RTcmsWkoE/Zuu1k3sisI2CT9//pC6nmQpg4uZ57kb6xqIDo8stGQI/1uGH06ORZL2z6wMgiPxJQqeWY3ljI8DhvS4DEWBouDVrGlI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96321440-c910-46c8-5754-08dc314ae4f6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:31.9601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzvaSsXdR/VeHN0v668C3dWW8OJY32DJCgT9kF8FN5dZmr/gfzlAA6IFS1kmkX53/g5X3lQtKD4PpJPnN+sdZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402190096
X-Proofpoint-GUID: rb5Oltzt5KuDoS_l27iMUcXzw6PX5ysH
X-Proofpoint-ORIG-GUID: rb5Oltzt5KuDoS_l27iMUcXzw6PX5ysH

This series introduces a proposal to implementing atomic writes in the
kernel for torn-write protection.

This series takes the approach of adding a new "atomic" flag to each of
pwritev2() and iocb->ki_flags - RWF_ATOMIC and IOCB_ATOMIC, respectively.
When set, these indicate that we want the write issued "atomically".

Only direct IO is supported and for block devices here. For this, atomic
write HW is required, like SCSI ATOMIC WRITE (16).

XFS FS support will require rework according to discussion at:
https://lore.kernel.org/linux-fsdevel/20240124142645.9334-1-john.g.garry@oracle.com/T/#m916df899e9d0fb688cdbd415826ae2423306c2e0

The current plan there is to use forcealign feature from the start. This
will take a bit of time to get done.

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

SCSI sd.c and scsi_debug and NVMe kernel support is added.

This series is based on v6.8-rc5.

Patches can be found at:
https://github.com/johnpgarry/linux/commits/atomic-writes-v6.8-v4

Changes since v3:
- Condense and reorder patches, and also write proper commit messages
- Add patch block fops.c patch to change blkdev_dio_unaligned() callsite
- Re-use block limits in nvme_valid_atomic_write()
- Disallow RWF_ATOMIC for reads
- Add HCH RB tag for blk_queue_get_max_sectors() patch and modify commit
  message for new position

Changes since v2:
- Support atomic_write_segments_max
- Limit atomic write paramaters to max_hw_sectors_kb
- Don't increase fmode_t
- Change value for RWF_ATOMIC
- Various tidying (including advised by Jan)


Alan Adamson (2):
  nvme: Atomic write support
  nvme: Ensure atomic writes will be executed atomically

John Garry (6):
  block: Pass blk_queue_get_max_sectors() a request pointer
  block: Call blkdev_dio_unaligned() from blkdev_direct_IO()
  block: Add core atomic write support
  block: Add fops atomic write support
  scsi: sd: Atomic write support
  scsi: scsi_debug: Atomic write support

Prasad Singamsetty (3):
  fs: Initial atomic write support
  fs: Add initial atomic write support info to statx
  block: Add atomic write support for statx

 Documentation/ABI/stable/sysfs-block |  52 +++
 block/bdev.c                         |  37 +-
 block/blk-merge.c                    |  94 ++++-
 block/blk-mq.c                       |   2 +-
 block/blk-settings.c                 | 103 +++++
 block/blk-sysfs.c                    |  33 ++
 block/blk.h                          |   9 +-
 block/fops.c                         |  43 +-
 drivers/nvme/host/core.c             |  73 ++++
 drivers/scsi/scsi_debug.c            | 589 +++++++++++++++++++++------
 drivers/scsi/scsi_trace.c            |  22 +
 drivers/scsi/sd.c                    |  93 ++++-
 drivers/scsi/sd.h                    |   8 +
 fs/aio.c                             |   8 +-
 fs/btrfs/ioctl.c                     |   2 +-
 fs/read_write.c                      |   2 +-
 fs/stat.c                            |  47 ++-
 include/linux/blk_types.h            |   2 +
 include/linux/blkdev.h               |  65 ++-
 include/linux/fs.h                   |  39 +-
 include/linux/stat.h                 |   3 +
 include/scsi/scsi_proto.h            |   1 +
 include/trace/events/scsi.h          |   1 +
 include/uapi/linux/fs.h              |   5 +-
 include/uapi/linux/stat.h            |   9 +-
 io_uring/rw.c                        |   4 +-
 26 files changed, 1166 insertions(+), 180 deletions(-)

-- 
2.31.1


