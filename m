Return-Path: <io-uring+bounces-2294-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 836D29104CE
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87284282766
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 12:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091191AED30;
	Thu, 20 Jun 2024 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lYGfUdEm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="e6Tm2BF+"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1C71AE85B;
	Thu, 20 Jun 2024 12:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888110; cv=fail; b=fLEI6i3PaAhPm66q2NyYvp3bDfu8h3VMNlFy7nXU5khEUQW5Khs+MlgX800CJfNcwkLf6w3t9M+ytLv7TRoFM/pUH70YXMOUg89GZkLwegK+5d3tdxhQrzhRlEnhhHEruL5DPSsqckicUB3wVpKqJt+TSmkqhpuDclyiGfEuM+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888110; c=relaxed/simple;
	bh=TCmSWBzExXAZ5jcgtbZ16k8wVv/6IoqNpwGaVx3aORE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dzD6sQfRSKRbFFuEBpmh8A+jBrolUlRALhlBuuFHAZxBgF43Uhs0uOlw2Bis+aCduZikLMjiDxjtl5ld1ZYvsKeZc9+aeB4jnvTKDG6MFoJ4AHrnw+xNHDY4qo2PnOptKvKJF6xBM5q+TM/Vi0ugwwaWXVikmPP1M3GIDnhZI4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lYGfUdEm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=e6Tm2BF+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45K5FJuY018262;
	Thu, 20 Jun 2024 12:54:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=l5F98DnsUI3BtppbdgEqyNw7d8YW99aVlWMgn0D5V7I=; b=
	lYGfUdEm9ckc48Nd4cEl1Nn1ao+nk/YEWtYs2Qx8Cw3++Uv4wcptec/atXNYGjjy
	302aky7Br1bPzlhDhYesNOos4ngbu6UBGlgQDNjH+Zyy6rDKrkHOfG4U8AlOwE4b
	tPGgSS4yoQMQJz/NgkPjGyW35ZZtopilvPdhtZundhCuJoiTCSkEQPGM1cJRfw09
	oH8py8CK5DfhC2LDsAkEyZ2HdX9lydJuRoRUEXXHSzBgZb7IPwTLRgv1vmc31yBd
	Scw9E1VYqrnNCOEu/Tt/RYWVZwUk7JQaX7tP2y9s61gMvncIrxIe8vWzBbm91/HP
	abjvHQnN8kGsRC4f1X1vuQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yujc0b43n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KCUOi3034795;
	Thu, 20 Jun 2024 12:54:31 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dap437-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6rHq9sMuBlk6AKIAp5W2ERIEzTB9e+mq5E+Om3OqN+Y8MOVpkEYILH3tgl/yq0O8MDePJaHf07gFm9rtPtae+HXJ0O4ufA+yRhL9iXxDxnX/ix1BaCYpt53mYcCmAP+ArBm5JlDOxu4e2EF55JTaILQBYL7eAg56Rj6a9A2Iv105NvBqjXPb1py3zj177Qg+r/u4zgWNVVMzpG5Fd05ckb14KMmYnDx6vNGVTUFMndASHDQMkUkBJHOxmH+/lev6MyRuQgzJPLAKp7fuBBmKwX2wZf+BB8dEThGTpKkAtKYjMEoXZKgEqH8kqvY4Pfvme5yxHQe20YkSpNIFXZ6RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5F98DnsUI3BtppbdgEqyNw7d8YW99aVlWMgn0D5V7I=;
 b=YvSwrQoQ0Z9y/zI4fVJ8fsrtjQ5hgZ2Sku6BKKs914J+NCFbjoJSK3fTEB4G4J4o1CobAkaXBflOmQ9Q7l6jsnCSMukR2+PorVhr5uDAccBO542koJkwL60HnhSvY1uIDWepca0LkoM3K7N8RLYWuXeDxnYyKu6Glm8uqrQIZYlkTdx7jvqX+TvmsnG6S21Z1LiAmAINBDdkwy5cY73nsSLiyS+QpRtzNf3JHABB1aWYWmgjcRE9fJmykzNpPAZWi6mbVcZR2+T0EqDL64DwTc0R2xjk1IPbBRkLl9qU3H1JmWzuiDVlj3nzWrejmJyTSYh450p1/Bcg4k9wiQw2FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5F98DnsUI3BtppbdgEqyNw7d8YW99aVlWMgn0D5V7I=;
 b=e6Tm2BF+hgdvd2LMp2LL1yJkYyHUryrjROv6vSPwIqd9cbFZ1cC7W+tqcYoGFYw67za3AF5UuS7LXjLbhWh4Sjorhn+/vwIwn7hXBkV9YHy3xweXWQRaLsOl1ZvwCYDlSeXc+IRPxdwAnWRzZPNhth/wDLNNGaE4J11SO42nBbk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7695.namprd10.prod.outlook.com (2603:10b6:510:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 12:54:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 12:54:28 +0000
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
Subject: [Patch v9 03/10] fs: Initial atomic write support
Date: Thu, 20 Jun 2024 12:53:52 +0000
Message-Id: <20240620125359.2684798-4-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240620125359.2684798-1-john.g.garry@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0007.namprd14.prod.outlook.com
 (2603:10b6:208:23e::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: b5663466-c0a9-4966-7a11-08dc91281eec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|376011|7416011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?a0Igq+Bt0wcmLlGWgvFXV4Nit+JbA4JAHu5/CIDTOYIdd0hN938tAI8JdFaI?=
 =?us-ascii?Q?hMqMBNesDxWrZW6vUjBkwjd13xfNUqoU5rz1yA3gopFbc4t62hBpIwrrVF7e?=
 =?us-ascii?Q?OUwPZcTy5JlgOj0QbLgU/Ri1RF9AbKAmTysCju9ntMEJnsmxRZs7QGJpC9pb?=
 =?us-ascii?Q?ZNMvRFzw3CAqrNnXkIACpZGW/98xnFcvYv7wo2xKMZtfKLUZ6yfXubaLPC4+?=
 =?us-ascii?Q?d2zGmdo67SvxVDgZ6ulYYna3nVGEfoVPUNvIdB/czryyFfvTVbYeD7vJNILw?=
 =?us-ascii?Q?f1ps07j1MMktqIZLqHOvaUtcM8qRA2VqyLbTAMY/7wW3YQquKfV3l3k+7yUI?=
 =?us-ascii?Q?PZe3n1Z/cJ8qep3kW9iTACSB4zMzhNkXsLHpmrO+n9VsL+naEd4RpOfvcWWw?=
 =?us-ascii?Q?PiTaI1LDWCOSVSpdG005Pe0jnzT7nUue05c/KNdjPkJsFj6MoSftTElnzX7b?=
 =?us-ascii?Q?CwhugmC7VfEaK/TK4hEl8FryXVFdM4w1sMmSGQ9iruwpRrvDDIYWHpGDTACg?=
 =?us-ascii?Q?MkBEaNq4SzBzM+pFOtatxSiNcGsE89iIe6EbCwvgvMwcXU528+ZGF77sjzi3?=
 =?us-ascii?Q?LGJ6LipBEtfrsafGmVfUyOSJhpkCGyQyqKsRM6tKz4bfTY8c/I73eq6weEXO?=
 =?us-ascii?Q?vWElHfvCmPOSRQ04rzOf4gEOzEblqB1mBNAs18htDFSiNV6PoO24UXdyXnth?=
 =?us-ascii?Q?nM0sn6+85ZFly/1g2NC8Ct/+DTwpqIdCS4dZXwPV9UdLC4RolV8xCxDqCrYy?=
 =?us-ascii?Q?n36sCvmzwHl6SmRlF/4h1mkpO8J8C1kaEL55kYSrZJB6fjHyTsbZNHUfk0GL?=
 =?us-ascii?Q?VlUx8TPugFAYH7Ys0gMsQFF22R29pK2QCNbys+0K9EhTZzYbKUXnm4S5s9Ak?=
 =?us-ascii?Q?i+cEjKmg0TVYBF6frGuuRkMuF5qf3fsikTNDgS1VeW97pEHtPirCJp9du+0v?=
 =?us-ascii?Q?LUcfeT9Hl4GtJk2bX1xW6J1K40HZz4aPOFOHRCLi+UDfId2AFg6IafAQ/mpx?=
 =?us-ascii?Q?KcsTlMuusyln8tf2S/e+aFhtoy05NZfnly3bI3FCzFdcwDNQ57nMaLUrcKXG?=
 =?us-ascii?Q?1SQhkAAg4qDGPKVFUxYsdpyiYyekUOo0bDiwdniggWDj4DM4AppuUugDX6wF?=
 =?us-ascii?Q?PzTT2usgPtcTncMBBpIoXqd0gas6ho+PoaaWmDm/9BkwigauYnJClMglqO6n?=
 =?us-ascii?Q?PS+I4b1WDt87QVvCoM2nL40qEFri5+riqCNyLkvaaWxJM5CmuzQ4tCQF6EVT?=
 =?us-ascii?Q?8SNXZY4WFyfCoBleqV3fARK8p1Y5ANB6ZFBhcFVQxJzKVCEOdfL2fRO45GXT?=
 =?us-ascii?Q?DxAk33n5Gr669x0031tyaXM7fzPUcxF40S/qOhOmUT3ni7bPsOmKqb1qAQ5b?=
 =?us-ascii?Q?BOI8VL4=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?8O23aJcIUbOjtfX3PDhODEFgXOLw0DY/CIz+umeILukAmRTIIMZZcJvVDd+L?=
 =?us-ascii?Q?1RIDEB2HgCP92RmHk3TgNAz/UrxhvPbzFLmoXjw5XK1OQDq+wmqDUMjqwrUe?=
 =?us-ascii?Q?morpr2lJdimSWweA3hsBNlOXTvZvNzSRfKY9utE13XKbLaaZcvsZpwDdZuVD?=
 =?us-ascii?Q?XMxwUpboRo9hg0TV5RNDgtIrXnIhHdA5K0daTsL6Yn7OS+4rgjNgfoNEqwff?=
 =?us-ascii?Q?OUsy8/wLeY2fO4udiamX41N1mgqaQeFiAqvzJlGTYzF6EdGqvqHXPJbSUKA8?=
 =?us-ascii?Q?sWNEhj4hkIT6uVJ+aWYNa/lz+6rOgeDd09fMZBI36DdPgg3Zqt7WAYtH53mT?=
 =?us-ascii?Q?ctl6L8IKVCCnFSQ9588e9nzvdIaEpAyqMYcvTRH2tTuYUJDCDuhGLqxBEAM9?=
 =?us-ascii?Q?uqPVMkqcAA22w3sCmTIZdlIPn8YNBQinWySF8zCBPTAoO9tu9YhUwdVjrxiq?=
 =?us-ascii?Q?+3T4ZymbQ6BZekSqHG8Mxfh+PcMlB1YUdSqZNDshnoNsdbuNBJHehQGyhks5?=
 =?us-ascii?Q?FioD1+gNp+rO3APS3Dn47OSKsRhbfE+wBmL3ljufD4YUWcsMTWJn/NVOalO/?=
 =?us-ascii?Q?9GbUQkxWSGJXw3Fl4u99t8xKn5J6r2kMiiIjgSzxL845qmVuqA6T+B1R5StZ?=
 =?us-ascii?Q?PI632Z5kp2SqCt2OUvnlVglqIT/r1poLG64C9ZHlLD82DOb0gPYARuoVUcU7?=
 =?us-ascii?Q?axWYrXuYor+GGarGXa9RcMpZIY0M+JhGU5CGGnbotDFCoCsmZ0B/5cDHv7i8?=
 =?us-ascii?Q?mlZmW2GEJyOljN0RThtpaWFPl/7ZOemKo3DMS2cxd+24K5lwoF9fMYFwcDbB?=
 =?us-ascii?Q?yzwd8/SJVGPgxYd7nVTes8iNxTepm2FAmfcVgB0L4SC2ft2RrSbHAAlXjR68?=
 =?us-ascii?Q?JhtxH3DFxYwYHaQJDvjg28tD5Hy5fCaVzsm+Vgn/DGFcIn0Xj6Dxq3k6skeX?=
 =?us-ascii?Q?W+n5YPb56nux4NBBQhaMqdqAxYPv222QIk8sLz3yiEHlfNH3V3+l3ZlLfj0p?=
 =?us-ascii?Q?TjEq9mqh7XfK2ij0KfVLq6OMwqmORoSkCk1R7+UmYBRYrc+WWqd1bzS5IRXJ?=
 =?us-ascii?Q?AwMyPngChIZOIVrjFFTUukNYPpVt+knnUQrUVVzCq2A3q3LJl1NYys5GZ532?=
 =?us-ascii?Q?EGfm6D5s89xrxnnH+J2ikk2BTIjDms1BIx7SxS9m3J+TLMDOu11ZC32jbj7v?=
 =?us-ascii?Q?gcCENukSotEAZxt+E2DMpT46iO7CTOtQ7hR1HPIsUzN6q1ZxlZFv+SpHVAMt?=
 =?us-ascii?Q?x2kRRw7dd+YEX01CCsPq0ZknP+T8kYgF920kw1IX0/OmJVDMJHApK7YyQcYy?=
 =?us-ascii?Q?jyvMTiDlTvwhVlc0EwA0aYDZiemw1ga4jovbMqKwZlLg1weGVPZvRBq08+tE?=
 =?us-ascii?Q?hMypgkqf9Y2d8H/OY5F4A4ObJW5KOyk5EANwe6XQBR3l2kjpmMJamJ01lBqz?=
 =?us-ascii?Q?eCCBKltQ1i4q/eJP0epf1LJ2yOY8oTCvSE3cb636L7iLFioGpoJKgYFnMhkT?=
 =?us-ascii?Q?JnBNX7mJg8fRZVkFdRRyOYfZiVq542vDRgpOAgO0UCzJuKEGQvxwUvkfrVCw?=
 =?us-ascii?Q?3OmmUfnGaS9PdOlTSjYFiuthYJ7gpXrW4otihJowan8C59v1g65Pf3WQ6TAp?=
 =?us-ascii?Q?ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8iBFkcdLnzSC0VjYwebjMJYfB2B3wny3LV1EZv2EoeOpnonDONoxjKupRnruXKRLc07LC6tZP4tzI8QSGtx+L2bxcmfMY1WKeJaUq8r4eEnk0/wRlUrqsnnpOE/RwGcpz6YgrDsa1W8nxFDfMJTCY+clgrVUkFAFuy/iP0HmDrV6hHdrQHtb3n2hV/MQmbJufNj+tJ9CkwzC2qGSnP4O9vjbgDpjlji/aYaFUT52PScVKEhSxQ/VoLbcDz/a/rtc+B3oeM/UIYvFJUB3gbNlsokdYD7MfowrQ1qEgWxvQ2INvv9rGu1cHIR3Y22tBf+177AT/Zkp4iCHHVSZV64SGtKcdHBRjLPbjURWrmaaPb7H8D+ZvZPdMopi6yDaLVHdw1yhKVwGOzM5dpCzbD6TQoaAixL4/MrpMo4JJELC9El49890RXzmv6OvpCwXP2UZw4oDUrQMLMMr1A7v/O7tQvcaWfGkmDAddYR0/Tu10xZWg0vDGwf5G2stc41Jrrri57Uw3dTvaaw1UH3A/CxKmx41/5lqnJyLZLP3N4+sk7VKyBMamOkjxMAxqGSzaybha/S9JZGWYEFVbQ/jlYD+PNA+9heOgjEjeKN1IeUyAHU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5663466-c0a9-4966-7a11-08dc91281eec
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 12:54:28.4271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rqhryiMVExD9fAIIBHqsWWQaGxIC1VStoRfNCYYmyM5nQQOYzoGXCDii6vEtoSyb6r74cM3Mxx+ANvoKcnLgzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406200092
X-Proofpoint-ORIG-GUID: 7xa28vK4-_6mFWORWL-qsKzFqzDq2zbj
X-Proofpoint-GUID: 7xa28vK4-_6mFWORWL-qsKzFqzDq2zbj

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

An atomic write is a write issued with torn-write protection, meaning
that for a power failure or any other hardware failure, all or none of the
data from the write will be stored, but never a mix of old and new data.

Userspace may add flag RWF_ATOMIC to pwritev2() to indicate that the
write is to be issued with torn-write prevention, according to special
alignment and length rules.

For any syscall interface utilizing struct iocb, add IOCB_ATOMIC for
iocb->ki_flags field to indicate the same.

A call to statx will give the relevant atomic write info for a file:
- atomic_write_unit_min
- atomic_write_unit_max
- atomic_write_segments_max

Both min and max values must be a power-of-2.

Applications can avail of atomic write feature by ensuring that the total
length of a write is a power-of-2 in size and also sized between
atomic_write_unit_min and atomic_write_unit_max, inclusive. Applications
must ensure that the write is at a naturally-aligned offset in the file
wrt the total write length. The value in atomic_write_segments_max
indicates the upper limit for IOV_ITER iovcnt.

Add file mode flag FMODE_CAN_ATOMIC_WRITE, so files which do not have the
flag set will have RWF_ATOMIC rejected and not just ignored.

Add a type argument to kiocb_set_rw_flags() to allows reads which have
RWF_ATOMIC set to be rejected.

Helper function generic_atomic_write_valid() can be used by FSes to verify
compliant writes. There we check for iov_iter type is for ubuf, which
implies iovcnt==1 for pwritev2(), which is an initial restriction for
atomic_write_segments_max. Initially the only user will be bdev file
operations write handler. We will rely on the block BIO submission path to
ensure write sizes are compliant for the bdev, so we don't need to check
atomic writes sizes yet.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
jpg: merge into single patch and much rewrite
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/aio.c                |  8 ++++----
 fs/btrfs/ioctl.c        |  2 +-
 fs/read_write.c         | 18 +++++++++++++++++-
 include/linux/fs.h      | 17 +++++++++++++++--
 include/uapi/linux/fs.h |  5 ++++-
 io_uring/rw.c           |  9 ++++-----
 6 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 57c9f7c077e6..93ef59d358b3 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1516,7 +1516,7 @@ static void aio_complete_rw(struct kiocb *kiocb, long res)
 	iocb_put(iocb);
 }
 
-static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
+static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb, int rw_type)
 {
 	int ret;
 
@@ -1542,7 +1542,7 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
 	} else
 		req->ki_ioprio = get_current_ioprio();
 
-	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
+	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags, rw_type);
 	if (unlikely(ret))
 		return ret;
 
@@ -1594,7 +1594,7 @@ static int aio_read(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(req, iocb, READ);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
@@ -1621,7 +1621,7 @@ static int aio_write(struct kiocb *req, const struct iocb *iocb,
 	struct file *file;
 	int ret;
 
-	ret = aio_prep_rw(req, iocb);
+	ret = aio_prep_rw(req, iocb, WRITE);
 	if (ret)
 		return ret;
 	file = req->ki_filp;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index efd5d6e9589e..6ad524b894fc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4627,7 +4627,7 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
 		goto out_iov;
 
 	init_sync_kiocb(&kiocb, file);
-	ret = kiocb_set_rw_flags(&kiocb, 0);
+	ret = kiocb_set_rw_flags(&kiocb, 0, WRITE);
 	if (ret)
 		goto out_iov;
 	kiocb.ki_pos = pos;
diff --git a/fs/read_write.c b/fs/read_write.c
index ef6339391351..90e283b31ca1 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -730,7 +730,7 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 	ssize_t ret;
 
 	init_sync_kiocb(&kiocb, filp);
-	ret = kiocb_set_rw_flags(&kiocb, flags);
+	ret = kiocb_set_rw_flags(&kiocb, flags, type);
 	if (ret)
 		return ret;
 	kiocb.ki_pos = (ppos ? *ppos : 0);
@@ -1736,3 +1736,19 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
 
 	return 0;
 }
+
+bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos)
+{
+	size_t len = iov_iter_count(iter);
+
+	if (!iter_is_ubuf(iter))
+		return false;
+
+	if (!is_power_of_2(len))
+		return false;
+
+	if (!IS_ALIGNED(pos, len))
+		return false;
+
+	return true;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0283cf366c2a..e049414bef7d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -125,8 +125,10 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define FMODE_EXEC		((__force fmode_t)(1 << 5))
 /* File writes are restricted (block device specific) */
 #define FMODE_WRITE_RESTRICTED	((__force fmode_t)(1 << 6))
+/* File supports atomic writes */
+#define FMODE_CAN_ATOMIC_WRITE	((__force fmode_t)(1 << 7))
 
-/* FMODE_* bits 7 to 8 */
+/* FMODE_* bit 8 */
 
 /* 32bit hashes as llseek() offset (for directories) */
 #define FMODE_32BITHASH         ((__force fmode_t)(1 << 9))
@@ -317,6 +319,7 @@ struct readahead_control;
 #define IOCB_SYNC		(__force int) RWF_SYNC
 #define IOCB_NOWAIT		(__force int) RWF_NOWAIT
 #define IOCB_APPEND		(__force int) RWF_APPEND
+#define IOCB_ATOMIC		(__force int) RWF_ATOMIC
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -351,6 +354,7 @@ struct readahead_control;
 	{ IOCB_SYNC,		"SYNC" }, \
 	{ IOCB_NOWAIT,		"NOWAIT" }, \
 	{ IOCB_APPEND,		"APPEND" }, \
+	{ IOCB_ATOMIC,		"ATOMIC"}, \
 	{ IOCB_EVENTFD,		"EVENTFD"}, \
 	{ IOCB_DIRECT,		"DIRECT" }, \
 	{ IOCB_WRITE,		"WRITE" }, \
@@ -3403,7 +3407,8 @@ static inline int iocb_flags(struct file *file)
 	return res;
 }
 
-static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
+static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
+				     int rw_type)
 {
 	int kiocb_flags = 0;
 
@@ -3422,6 +3427,12 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
 			return -EOPNOTSUPP;
 		kiocb_flags |= IOCB_NOIO;
 	}
+	if (flags & RWF_ATOMIC) {
+		if (rw_type != WRITE)
+			return -EOPNOTSUPP;
+		if (!(ki->ki_filp->f_mode & FMODE_CAN_ATOMIC_WRITE))
+			return -EOPNOTSUPP;
+	}
 	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
 	if (flags & RWF_SYNC)
 		kiocb_flags |= IOCB_DSYNC;
@@ -3613,4 +3624,6 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 			   int advice);
 
+bool generic_atomic_write_valid(struct iov_iter *iter, loff_t pos);
+
 #endif /* _LINUX_FS_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 45e4e64fd664..191a7e88a8ab 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -329,9 +329,12 @@ typedef int __bitwise __kernel_rwf_t;
 /* per-IO negation of O_APPEND */
 #define RWF_NOAPPEND	((__force __kernel_rwf_t)0x00000020)
 
+/* Atomic Write */
+#define RWF_ATOMIC	((__force __kernel_rwf_t)0x00000040)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
-			 RWF_APPEND | RWF_NOAPPEND)
+			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC)
 
 /* Pagemap ioctl */
 #define PAGEMAP_SCAN	_IOWR('f', 16, struct pm_scan_arg)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1a2128459cb4..c004d21e2f12 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -772,7 +772,7 @@ static bool need_complete_io(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
-static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
+static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct kiocb *kiocb = &rw->kiocb;
@@ -787,7 +787,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		req->flags |= io_file_get_flags(file);
 
 	kiocb->ki_flags = file->f_iocb_flags;
-	ret = kiocb_set_rw_flags(kiocb, rw->flags);
+	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
 	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
@@ -832,8 +832,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret < 0))
 			return ret;
 	}
-
-	ret = io_rw_init_file(req, FMODE_READ);
+	ret = io_rw_init_file(req, FMODE_READ, READ);
 	if (unlikely(ret))
 		return ret;
 	req->cqe.res = iov_iter_count(&io->iter);
@@ -1013,7 +1012,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ssize_t ret, ret2;
 	loff_t *ppos;
 
-	ret = io_rw_init_file(req, FMODE_WRITE);
+	ret = io_rw_init_file(req, FMODE_WRITE, WRITE);
 	if (unlikely(ret))
 		return ret;
 	req->cqe.res = iov_iter_count(&io->iter);
-- 
2.31.1


