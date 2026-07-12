Return-Path: <io-uring+bounces-13991-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 4TsCGF8IVGrIhAMAu9opvQ
	(envelope-from <io-uring+bounces-13991-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 23:34:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B05F7746075
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 23:34:22 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="F/cBCV56";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cQT0Z99L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13991-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13991-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B986300E3BA
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2026 21:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5B8376BC5;
	Sun, 12 Jul 2026 21:33:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49E1376481;
	Sun, 12 Jul 2026 21:33:43 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783892025; cv=fail; b=QDlvmiy1bNM6AHRESH7/x3G6ipHOIRpLlMAo9vXnXkTc0b9W1xxWIAvnsd8ls+WR3l3GOgcwrrAD6Imdd6AoI0heWHtV9s9zJELvwGd7f6k767vztwDy6OI4Zevf4xhoDweqNdI3LnyHdbht7NoFlHkr2O0hePCqysdjiC739v8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783892025; c=relaxed/simple;
	bh=MMDf4F1fWy6HzJQIfImAwOe9A3tguPAf2Nub8PX3MTM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=iUuJWUicERmuR0QDReSLWPpmZ0GQsOmI36ss4oISQ1fr+IiOvmRIsz0tRMG7VyV0hMVEvxmcdxoJStZq1E+iWpMsl+fwu4zbGWkVQn6UygxTaMxt89JZCage1ikqwdW81lAZia5jHP4SPiSastvTY87BjUAzSTyMmjcRt+tmVUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F/cBCV56; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cQT0Z99L; arc=fail smtp.client-ip=205.220.165.32
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CLNIFq4075683;
	Sun, 12 Jul 2026 21:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4qDnGu05RnBcCD9QY8
	PSCfM+HVRbibLJPl+uuNLGK/I=; b=F/cBCV56Nq5n3YqQFtyqYr+RSD6K9F/FuL
	NQBasq08V0C5o4ILG/vfWnW4CMQzo9SPrh2WPRLcYNumtPw1mUc57jnc9Xgr80Mn
	MmUuW+n/ZVsKFLd2pW2PTDxdTl2uck6wEQYnJBeYNIKgT+hsFgZ2AMTXRUcIr7an
	zApxQcFQoaFPAD57ULEFfXVlk2G9dkQtg1I2RJSFHzueLVUmZ8kWSlIxNNc3yTnP
	HV8S0tLDKhL52pzEfFHYueqVQH8zPQ8rDDbd3EGsigJLf49atwqJMJyU1sd3LeFz
	y3aPmbjcG02zr891VApVufavVzxNRGxsioiQZYWHeWD5JQkYi5YQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedh871-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 21:33:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66CLSA1x005035;
	Sun, 12 Jul 2026 21:33:19 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011026.outbound.protection.outlook.com [40.107.208.26])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9c00v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jul 2026 21:33:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7W6w2YY6qMz42brEJiVe2tWpSj+3Xz9J3doNXTI07bKYIf1ikPQ2aaAFyak92bOtynRIN3+Rcve1O8GlNFjzynWwh2O2AMEVjwszxIzo7IZOKKuxajxDV9+mr3WYTcjYFGbfo9v72AA0aD7L3zK+PLLTU51XEtDTuXBwml9zNpMbgB12w/DUny6e5JXMD15DyJdguGNcjeDCxTlnRw7aX2BDgK508CsMdLh5vtmTbGL8PIDk2Dw/LDOMaNAnshqfUgC+FjV+/oyTy/XvWkESKtyt8ImYfBHsaMgGZPlob/tTXqUTycNGDOStJ2E5pjs2JoPu3MGlHfB5Py0obilpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qDnGu05RnBcCD9QY8PSCfM+HVRbibLJPl+uuNLGK/I=;
 b=rC9tXw/zaJtj42XuFU9roudvl69wOH25URai9a2/UoGZeYU45Y5mm01zT5WpmxohequdTrsZ+9RpCRMVVyx1nSppMMhBfF0aHH+KZaleosO36/eAx+2grV8QHY3PBT+QqR+nR0Po+bFJ3ZwRyAkAU1VieB01ejyDOAwB4cJCfxt4H+ooz7ajzkygLaHICpsTEITWCbFdCn4aBH1gkx+2BNKEDuP9RxjgSrshbRF4GWaTX6bSkXM3qrTmUl6WeKlMrStQyUg6vcZ4WzABphDkgNrBYUGnuJYepPK9U0halpf8cukSNFsKdg4iCoJ4SNoYzsCTmSyBZsySrPrw4DK5BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qDnGu05RnBcCD9QY8PSCfM+HVRbibLJPl+uuNLGK/I=;
 b=cQT0Z99LwGQsKxsxiaTPf55OINBY0bA4NSGnnY6IgyNUBFhdHj6raEoASnQfUE0CkFj37akkLtLRe7E55WyJVqoxLGVJQp6u38OWTIbnBcagfSV45ucPRfN2GlwGQjXD7vZhItBPw/Bhyk2R9XXv/Fub2xwGR0bk+0Qo1yff1U0=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6202.namprd10.prod.outlook.com (2603:10b6:510:1f2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Sun, 12 Jul
 2026 21:33:16 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0181.014; Sun, 12 Jul 2026
 21:33:16 +0000
To: Jens Axboe <axboe@kernel.dk>
Cc: Yang Xiuwei <yangxiuwei@kylinos.cn>,
        "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        Rahul Chandelkar <rc@rexion.ai>,
        FUJITA
 Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, Bart Van Assche
 <bvanassche@acm.org>,
        Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH v2] scsi: bsg: read io_uring command fields once
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <55f36cc5-a013-4960-8787-fbdf4b4d0c20@kernel.dk> (Jens Axboe's
	message of "Thu, 25 Jun 2026 06:06:25 -0600")
Message-ID: <yq1ik6jdhdr.fsf@ca-mkp.ca.oracle.com>
References: <20260527191817.142769-1-rc@rexion.ai>
	<20260626020000.0000000-1-yangxiuwei@kylinos.cn>
	<55f36cc5-a013-4960-8787-fbdf4b4d0c20@kernel.dk>
Date: Sun, 12 Jul 2026 17:33:14 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0013.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::12) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6202:EE_
X-MS-Office365-Filtering-Correlation-Id: d1683c77-1a1e-4364-1a10-08dee05d2f4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|18002099003|22082099003|4143699003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	yAfaNkMi2xQmu7WBPmdhTmpxNViM5/LnLjnySJ1AwIykf4P9Ie7e+uVU/Us1erzLFTiVJgHJL2dMujeHcu5fxa9+rw9atwYhnHYxK1+OM8f7xu4AiUurkKm97OO09pKXQLU44Eo3x7zSw2MXLCQtnPRK75kusJIGTmwSkUDvnQhx9OwGMhoiKm9CCPi/DnrbKZiKk3jrH8hzzS/poShmJmOOvvClZFeoX8gAawN5fQE+6s66DAusz/pp3pwVli9m7S/sG11kqJ0VLDmGpS9Yx2iFIUMpIotbwaDs84zZspuRHHI1NM1tZfIU3RjLOH7vHBZl/tbpnQf9iDKTofzNtJZIoftI3Sn2hWdj+CSS10+Gz+ln/S0ky2UqH58sfnQKZcfTCYwBw2O+oy3ji/7s7ZlferuxOeAuWEO9wtLJc34TfPvmzpF3+8WFLGKrhRbcqL5cDCvX4C4K3ymYhzVWFNEkTxiHdA+F7+dLSnfwkavV9yVDAgvHejD9HXyNsCi0P99heo5uQ6ddsi3IjtDZzADZb9wzknwbgxw+ASZVkoX/fbbG+ijE6r8LHwFytYavvger/kt3ezbifjptPDDiyTPhyqlG5dkCuJfy2vF/joBflYi0iO4SPSetMj7OeNufSBSoz/pjacxhIqrvrI7h9p/aBoJlYCJby9HoNEQbGb0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(18002099003)(22082099003)(4143699003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F1vpqwGPsAsfRh53+nJdtE0S+EddwYoxHdeJVHL4Cohg9xAoLM6acknwX+Zs?=
 =?us-ascii?Q?xwXAUSmtSJ/EhY+iCgsm9wC5ZCmnqO6p96UWlGqrhHf21mYfedwtrw4islQw?=
 =?us-ascii?Q?BPFzBEEph35U2nR0IF4yrG0JA85FyHA9vznMW5EhkdE9O3M45zxpkmyiCHjh?=
 =?us-ascii?Q?t4kXyXt+WkW+KN4etYaxCQeHYS6hyc2y58D4vXOdTkHVc31i4/H7QhjTLl5M?=
 =?us-ascii?Q?Y33/XKJmfsEqgt/rQkcf5+A0ln/DpCag+AQVVtCZtnlTr8ob9Gj/gWF2eZdo?=
 =?us-ascii?Q?LmzikNnmi+nwuWtl8NLu/RrqnWRpOpOA/th5X4V153Pm4yy9YkjlE5HMSXHF?=
 =?us-ascii?Q?3RKIuzF4yB+IvA9B0EPVFURWSpw0zwHvbquCKbjn+Cpu0H2e8YgwuBESQpc+?=
 =?us-ascii?Q?vO2ORYRNprGkLm7xYBoP+ivEsMfOVtT/7O8o7Cjzp00tTFhcDRg02E21o51m?=
 =?us-ascii?Q?+EwrVdNdP6h/bZIb2Ot3S3qismJq9OzgpEVVUbrq/c5pa54BEZYpqzF9e5Lo?=
 =?us-ascii?Q?vZz9AsgeJL6R0kb1CDL/ll+FcCfnXbE+PJZJhJUpLIMIjzHy8wnppj89t3vw?=
 =?us-ascii?Q?f/fhnMLNEq05W43tPEzN/DdlQsNpFfDIS7fcKV2B4Elg55qerQLv1faYw+ZM?=
 =?us-ascii?Q?I9lSEgGD1V0QxDHR1UR8rVyv1IZWRE6qw1ZCvY6hJiuy7fie8FYDZ5SLd/d/?=
 =?us-ascii?Q?Hn6gagV/zVrQBMIi47mzKuUHDFieZENZdu+dNEwkbpulHP6scmREM+i074jL?=
 =?us-ascii?Q?I66Djx627m7iSg1Ebu8PMicOZ4oWWISm7aE9KGjhjG/GthHGxJiHSElLnwud?=
 =?us-ascii?Q?o0GCztCzYQdUQ1yBsSj3KMq4+hHPsq+OzlX1Lc1XKNQfz5bwm2nnhmrd+Twp?=
 =?us-ascii?Q?iEbCQZvGd1FaiKTKltAEIx7UyIIRgKIwp+oveOnnmQ8kL89yfBy/rHyGS7ns?=
 =?us-ascii?Q?3315bm2J9M2BvqgJ6VytD76WAJTBkA1tm90E57mJWFZX9yOY3mV74EIt83NE?=
 =?us-ascii?Q?Dp14HUHg7IiQGtdjRRvYIKPPvy5Af3QE11+b7DJqv/DCVEvKA/beI8xSLyWR?=
 =?us-ascii?Q?5bkNjymxbWO2EVWsfovbK8YiuR37ZlW2LovKVkZOGIr6ZVQnTgtTiUgyTyRD?=
 =?us-ascii?Q?InKGOD9F6O07SqWb/UHcznck+uvTXQsWIM8NodlPw97FJWt4Ws7b9X+lHZra?=
 =?us-ascii?Q?JNPAh9WSOQFv06rOy5qA4bCBwwV017cOGi62z+dhfCfztaHYlYuTYeXSHM/o?=
 =?us-ascii?Q?7N7gRvokBj6FT9eyz+RVzKXjCyKbqE5DCkngRjUPMvUvq85xq/Btbb4q6Kde?=
 =?us-ascii?Q?9dF5Y6PDtD6LB+Qcp2cO8yyRkB4+CxDwXZNFuBqj97XcNq9Ci12P64XAriDl?=
 =?us-ascii?Q?wxuLgII7pYNNSPINE8auphU4awDOEeiPQRuoI/mqFjQH1aMmoAIot3mOv6hv?=
 =?us-ascii?Q?c6vITdWhtFF/9jxvrGNbceQIqJ12kKNDu8KknfDCHknhq7TfhmIIdltt2CBG?=
 =?us-ascii?Q?tKZeLYuTTVkY9XI5Gq3qnurHtGXh3eLaINb602+p8WES+bS8apMjbL6PDuDe?=
 =?us-ascii?Q?mr8+4+QD/mkONFUE0dO4Qe9ztqV3NkmCIINd+9x4lpjHi1nO4mdA0Ia87M+N?=
 =?us-ascii?Q?Beix6b/+LFUMgsiNaNCaUA/GnhpakEqJ5FoIDdk4rgztVmFqWxwkNKN3QSw+?=
 =?us-ascii?Q?s5gFYQIbWZfhzQM1t8EvGyeECUEW5ZIUmsznWdDtnXUvNJH2z8lexi2fO1FI?=
 =?us-ascii?Q?I7V9ZgRgYeNNzYUPtiL4sHhPGtjW4Wk=3D?=
X-Exchange-RoutingPolicyChecked:
	qQt8anEod+pTfK9toCCPalfSet8/OBCrKBogNY+0DCpKKq5rDO9OWub2OFdYS0HHsjQaCK9yOTTLmHuVDvbyIST7TyKuWKn7apFpS1dSZN5WxnWhQo8T/Hgx9U2qgMRkwoLjH8tFcIDgGiAxZ6dP/wTlkBflhFCLWTCWOfXkeytEJL3ZonpgAv96SIKeADKshPMlyYJDLhOZHwmTLppkyTXSv2Y00SfG17Hyin9pmhELxreeIEbZ9e1ERVv4f6rylNG7rRJGzRaEscCylPc8Fxp3xsMYbOtrjqhFZo4UZfRZYpW801jcxSqmB45ynFAeUus7Bci4Vz70NCqJsqBqUg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1w7H/zZsvgubdPgnhDz8GaPqY49r5sN60+rxSmJrlzP6OtqOb15InNeAegp2tg5dz+XTlFlDVGm0EtbYLhZhwYJHjN0mAiW7PjXwSxTIAOnKEQh8VUyhZquKZNYMQ6vkcyCF2w8+mq0cU/vuLNokBjBoPofGye9gStxW1IdAOo74xa0IczJVQAnfbTfESRThUo7sK2JBgBWU4jjgUv3dBymJ9g4aC/YKEfMKNdzs+NKXvNnNX9tnRXv7DldkMio0rdgk1eWGuzbqc4eNAGxNu7fPSOYLKT/WbAzVzFR0YqfM3C+DSNqiSjL5Py7mnQz4tKka+bKl7C/rH2FBbXEZNFPq33qOQ+bHTJT7/ALJ0lW8XPKTLZgoMRbWXyZcFAbbIqR7Ht8phnUFGhoKUNZbPq0k7ZchWFAqbNHQIKaB1OSB04H2j6ir3IiM+BI+fRzjox3s7xLZIWxyFyP3DlOw3WqM7cCJWBIZW3tFKXBo2TDu0Hc/6phCH0Wu8A3K1DjWz4p1a8Y4xwHL8yOotZv+0yMDP9rW0/yCPCPIcQJywySV2qDJqrl1U1QgnNbKjcQ0aYg4yAaPbqg+wQQzDPnhUSw3MHoEIGkW0+UdBN9kUkQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1683c77-1a1e-4364-1a10-08dee05d2f4e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 21:33:16.4398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 88lpmppMOaV20yXxYwamwcBTdhN9oJOcsuqY/xXPq5q5cnFZISXanwnmjNjR5/jzbiFJ5GKpfWQFNifyef5vnpbcsecLGfGzml52eiy/oio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6202
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_07,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=863 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607120232
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a54081f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=fEeiZ9ox2kVnG-t419cA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDIzMyBTYWx0ZWRfX0dpVV1ayYTXo
 Mv8mdIvSHqiE8COJ2QFe34LRly2AbyDHpBOkQ1R02QztRpuE7AOQReJbVr3MFXI75dGDCfFSxYU
 dMKVOrBD2fVB81R0P5AhvQh+655aU1rHFhjLS9oiTT95KLW+lsTuqTK9JLMs+i9/3l80zs0c5bQ
 6ckl8fYaignHgnDzhFUvdCUGSE/O8H2JSjH/FIX1F7ClmmOYhPNGE3ijSEwCGtAkHnt1aLhJ1Lb
 hZT3krhZjrLk2t+JvJs4ULItHouJJyN+jxmd/5Yh1VBeKeiiQqEMAZNgog5u8r/RyGd1duKtCoY
 2uQ3oHUwnBGqFhOpgTUwa4OthKhSB61/yWl6EmrdsdBrf36+UZX+jKVMd+Mazt0wCJwATfN+Rvz
 dml4gekm9d6Rn444Nj1g9EKpPKgbsFpuFx6LejaknnQ2tdMMvelCEYITWEMSOSvbr4J/tSYwnql
 HuovzrwO69x5kzTX3jA==
X-Proofpoint-GUID: W5gunuYRvQ6jKZNZQYotn4XjgLZ_gHuq
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDIzMyBTYWx0ZWRfX7f8hSGJGtHmB
 WwXfJozbM2lZIik8tBqbO40W1mQH0T79B08UnYE/8PlTlGu1USWq9QBAou7j9vTJlT1ksYwcOZk
 /HLg0x4FDBPLYuP2h9Y7zl4d9XzUPlLjgGT21J+5uXlepvPJEiwV
X-Proofpoint-ORIG-GUID: W5gunuYRvQ6jKZNZQYotn4XjgLZ_gHuq
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-6.66 / 15.00];
	WHITELIST_DMARC(-7.00)[oracle.com:D:+];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[oracle.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[martin.petersen@oracle.com,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13991-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:yangxiuwei@kylinos.cn,m:James.Bottomley@HansenPartnership.com,m:martin.petersen@oracle.com,m:rc@rexion.ai,m:fujita.tomonori@lab.ntt.co.jp,m:linux-scsi@vger.kernel.org,m:linux-block@vger.kernel.org,m:io-uring@vger.kernel.org,m:bvanassche@acm.org,m:csander@purestorage.com,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[martin.petersen@oracle.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.onmicrosoft.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,oracle.com:from_mime,oracle.com:dkim,vger.kernel.org:from_smtp,ca-mkp.ca.oracle.com:mid];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B05F7746075


Jens,

> It'll fix the issue, but it also just applies READ_ONCE() everywhere.
> Which is fine, but most of them don't really matter. For example, yes
> you could race on the timeout if the application is being stupid or
> silly, but it doesn't matter one bit. Similarly with a bunch of others.
>
> I'll leave that up to the SCSI folks to decide how they want to do it.

I'd prefer to limit READ_ONCE() to the places where it is necessary.

-- 
Martin K. Petersen

