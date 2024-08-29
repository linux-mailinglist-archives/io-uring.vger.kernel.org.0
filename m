Return-Path: <io-uring+bounces-2967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76B4E963890
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 05:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24656283E95
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 03:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B7447A62;
	Thu, 29 Aug 2024 03:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N6c+FMgp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tzopy38s"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472B2208D7;
	Thu, 29 Aug 2024 03:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724900729; cv=fail; b=KxPdMk4TEYGyqPYush19dCtqcXucfBgAf9P9sCLJs7dqFOHZCW+fZAgIfSsHRsl9sx98eydQpBg7KrZwoXGGZIJraeahtECc103bP7ReYpsfrsHZzgmeEowO4v0rFggm5CxxkjLAiqe5Yj/smctSvdVYZkYjBwlA/pz+7XFQsO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724900729; c=relaxed/simple;
	bh=XQgl7mXiU829N86opdckRa7l8pPv/rdymnWuyK5yJ34=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kJv2J1s3XqWs2sTj4jmx2h8DxTyfT72VN79hufynyLbTi0fuHsojAcx2qB0nS2IfGIR1rEA2UsXDN9OSqb/Y8i84NcLqQ1NweWCDQ0klQ33OInfZDgJVdDIiJ08dIubfNOLpwBw4BXfHXv2LZBl7KUYRV8HCDiWQeRNCcYDSeFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N6c+FMgp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tzopy38s; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1fiGD013793;
	Thu, 29 Aug 2024 03:05:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=8/6x+1lqWJ50Gg
	jv17vIDdzr0FN0AHl9wiTQaoYD4Tw=; b=N6c+FMgp6d15AfjIXdBMB7x8DAYteo
	wma4d1uy681+B72n+mlzNQX/5+xzO5iM3hETOVi3l03Rhd49kImLr+SffkHphW+x
	Lha1Hgi/9emADEPvQM2yoUYK2VKit+ZImTj/nWBVcgwzXnpM/m/U2EmWMPZKF2kG
	MY/v2fRIGS7or07vvCvb4C0KoyFEvW27093yuGGUnQ3VttfvR6YMzRQNIwODcm8P
	HDAJ2WG/oYkIwJT7b5JOasuZyn0j6tY9NAljcwrHo1fbjhPnWxnpeXLbMCMlD26Q
	Khgqf1X3wUS9aW8X6z4xx8R9yElTceyyVw2MqYFLYrnWQ1WjapjNnKtg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pus35cb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 03:05:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1g4Ig034791;
	Thu, 29 Aug 2024 03:05:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4189svbvfq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 03:05:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lxd43vB1zigXJsQqOshg8urJuTzChdl+MD/PeaeUFprUKR6eIAndObCcF+TR8Xl4AgRnsm9eh5wezBF6xe99E4dE/jptRftyefFZUB5BrUMGVLUwJVojuU5pynUgtnbCiMkR95qNggZukpPGr8UPrUlMlSssw2BqovPrL1AF2GGy/ALNp4x51xHSorASob+ZdXiWZ63Hj8g1uQkqvwFVLYW6Pr+oxiuw82NpMtfPef2wToVuvCqjlPHIh46nOam6ek3VZBIwL4MnjDeiBmq2w4jTehK3TiYQq6pPolq9k7DLc3bHnQTbGsbjoq4SjJhXGmbImMPdJwL9+pt/hYGpmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/6x+1lqWJ50Ggjv17vIDdzr0FN0AHl9wiTQaoYD4Tw=;
 b=xF35SHHZMbhrS6OxC7R9o0ucOkiVqyvubjmwEqj9QFhu5yR6gNRsO7pHoq1z53e8Be8HKdtt86s2AUZG3WqthmAyUaDlCwyVliyLb5+A3TpriI2Jrcm+716onYllCYugoOr/X4OR54VOlaNjxGGkN2EieiKPx4Eb6TZgTtHcNt1LPzwXtpGONJx1JI/dbT3ix7MGD18OOMiy1gAtajyXtJHYQVtK1HkjbOFjo4boGflHVazwtP4NwzrqLN60quSBab6C/6CN8INIqaM+lVUWVmuviThkqZUT065cpp7PWMll2i0ObWlzGOKSOy6uShPCbYM2QlY3x1cwE4weP/zPIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/6x+1lqWJ50Ggjv17vIDdzr0FN0AHl9wiTQaoYD4Tw=;
 b=tzopy38smgzV2GZH+b9h3zbkT7dYyzyfzY0giCbHEt1Skpoqw53EGfMRdtEQACIhCukbNOddMz95qsFb2pY1pwv4SmfFJ7igwzXacQWfg5LB8H0cr8sqcHmg8WneKk8+8rZznVdI+RZLqIKT7Ip+2rLh0VsbLOWCOO51/CWltBU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB5824.namprd10.prod.outlook.com (2603:10b6:806:236::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.11; Thu, 29 Aug
 2024 03:05:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 03:05:07 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com,
        asml.silence@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, linux-scsi@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 05/10] block: define meta io descriptor
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240823103811.2421-6-anuj20.g@samsung.com> (Anuj Gupta's
	message of "Fri, 23 Aug 2024 16:08:05 +0530")
Organization: Oracle Corporation
Message-ID: <yq17cc0c9p5.fsf@ca-mkp.ca.oracle.com>
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104624epcas5p40c1b0f3516100f69cbd31d45867cd289@epcas5p4.samsung.com>
	<20240823103811.2421-6-anuj20.g@samsung.com>
Date: Wed, 28 Aug 2024 23:05:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:a03:40::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB5824:EE_
X-MS-Office365-Filtering-Correlation-Id: 30f1987f-bd1b-44b5-f0a3-08dcc7d7630f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PAI+3xvZ759SmBDJOBjKkzerN+eDlX3wDJFVaOB7QOVVJV8LemEF8YkKbol4?=
 =?us-ascii?Q?XVYJu5kyR604c/vxJyxRkkkR7P1ijhS9g+A6tZ5wM5XaIbGiMGd9aT5LWKDp?=
 =?us-ascii?Q?FljpNB6W3XQhW2NEeggQOsO2rH3HCoXsHfFuENS/k0JqCSQ54usFS6fMDNCf?=
 =?us-ascii?Q?DmpOUaBTCpzOGx2DEwzUaedFGy2UBKWyr37obv+kZYKjhqgmuiaCoO4DzKym?=
 =?us-ascii?Q?gKLbqLou71T0+k7qK5SVJWvafOZWMnbKaUyT+P/ppf/XH2mS8rMHGesyeqQf?=
 =?us-ascii?Q?qWcBsD8QwaklE7CmNy/fEBV4MocvxBu9lEZkZTkdyU2MQ9wbL9CBwr+Spxdn?=
 =?us-ascii?Q?wxgxel7Vhkj0jyI9BaBVrVwMpvaeWq3FO2w43HvmgrBNL1NPbQ+xOs77QWcK?=
 =?us-ascii?Q?xYEEzhbSxTz4wwQuPDOnROKQ0F8uI8uCoJ/jLhmO8YFTC5f/Plf9oTry/sDA?=
 =?us-ascii?Q?OArSNsUmqHKGoegSMdGXWCumwWIEqHorn82YP2/2/18Uo22Lc7UGh4JHgwSe?=
 =?us-ascii?Q?lw3dD+cNyfQwnKQk7A4JQ2dW7/yy+l0ZH+C2tcMiM6NggYCwHQNVFz8bQ49e?=
 =?us-ascii?Q?qpa98ltJmYPn4ozMPKUKvNMdARmHy8VV1Sgm2/K++IpE8myp6lT7/q1oo3/G?=
 =?us-ascii?Q?gUR7noWEEC3dqrL4qCwShbapNjiHW9YlrwCgidA4CwjxcWOP+49aI4H7cGgm?=
 =?us-ascii?Q?NNKVQfmJ17Nft9sAyqpsU3fQjSMMbOCDsQX0qqrdYZmx5ufKmcBInevmeq/i?=
 =?us-ascii?Q?7ZIRNHiKjjf5aVHnM2kanVOWc9AUvdM4Aa6wHTpoj8E/e7JknTlXSBaBp4kD?=
 =?us-ascii?Q?p2PxjgQ0ZsBcpMlEwe0o7ZQD97glHlKzja0s+W4wgyRRjnymAq4HJjULubFS?=
 =?us-ascii?Q?c/FHXRCK/+76NKVJXoB6uZGA+Cx3mT6jWmEZfzaDB9QB7rPwBhiGCZon/rye?=
 =?us-ascii?Q?gh2L7+9cKvQe+4jlN9LABfPj0MA4lS/e5b10y2HXpsq10t2xxI7+diNl7sF2?=
 =?us-ascii?Q?/VomV3d+Nx9ztR8M5ojFM9LCMj/GSOOqJe5Jzint7VRb57oKbdSsD1UN84pA?=
 =?us-ascii?Q?5oRoz+jcb+tgDSaOY9ERCBvCLLPvUZ3IF0mNaPVhmEqf6er8GMTYCFeINdNs?=
 =?us-ascii?Q?ycgOCgCLGDdsK5SYqDp4G6OR3xBKO8D/fctw9YyFfFgzE1EVlE5U6oDBlYDT?=
 =?us-ascii?Q?dI40mc5q61vQRBWRTvS1leptMAPt/jzOAoO9+9dBiER/8S39GBOB24buNIu1?=
 =?us-ascii?Q?8DbXMjfAxBn/hm3MI2GwT5iyqlkQ2U/HORrDvnr/nZh756O2hCKx0xgrACl/?=
 =?us-ascii?Q?5Bkaa8hGXoV7b8iCE7ih0VFECZ1UI+Tud4O8YM6NBX2kXw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9IqeW5Sj8Duq+3+IU11LhxYnkInBnxNbquEH5mtBHIHSPwoOdNKZTsv/3CMw?=
 =?us-ascii?Q?a88C93IrxgjukJ4cDuBG2FsBnKjrAijAjv2FwDr62E2TH8wgI0eAfA/4yCvx?=
 =?us-ascii?Q?vnboLrIvSXe47BgpOXBz52JXd2dmHJ7o69OQ3bJFtCcvoR0NUgbiI+2z4Ca2?=
 =?us-ascii?Q?INmn/TBxSuIZnoFAjZmGMYi7UIpThgRG2szD4wmKd4swgX4IzpqSxzVnjQZO?=
 =?us-ascii?Q?TsFaXhhmVOvgps8N4zUpIlR9+cDm4DxTOat/d6RT4k5ikfMKywClp7xVZkIb?=
 =?us-ascii?Q?34x3JkkJv01U8QKuE2hQ6GKzm0fTxXU7GgE2yssACxxehpBdCqkKBEa3FJZE?=
 =?us-ascii?Q?8aCBw8VLA0qUdJXdFxa5bdfI9K0XeuVfnLn1sr4E0HxGJ/UGmTjgnQ95c4DK?=
 =?us-ascii?Q?Oxy0fBgd/a+1UhyMOjfOfs2Q15paBdAwQH6HHnXE2oF8VrcxQitW13zsRyJA?=
 =?us-ascii?Q?3vnxFLsBqtU6o3zlkcofsd+pWW1yin9wNzOOJELVO14GxyO1cpbBN3CU+umr?=
 =?us-ascii?Q?fbEiqn3DtBBGgp2RXxrPqxAEj/SesS67IZ9PNzfVsxBgZmTEdP1WYQdpbmrl?=
 =?us-ascii?Q?PJG1pVbSjueW2By/PoQMHrX0jbnYOW4wTfXQexVCNbc2zOW/pGem473QuXV2?=
 =?us-ascii?Q?srd/pfgm6r6dXWqkttZHNdOO9tV/opoPFXsnkS/A0bAPj2VYidwjV3Ot7wXU?=
 =?us-ascii?Q?JNhB7RD3hJOeK6NsvD1RAVOuvPNfeRLIDZfZLgsrlkEdBqxeCdbuxC9gIUra?=
 =?us-ascii?Q?RR/7ZZZ6fs/oMI+6ls68lPM8j5Qv6AShgPAGJQqujQJ39lJM2k0HwtPkEG0x?=
 =?us-ascii?Q?apZI7shyOs1xSwr0jXQgqbsYx/3wWc4xFQ542Gj4Fh40+iD8UPLXVq8ZFje/?=
 =?us-ascii?Q?Ugj5YqU8RV8rLfY3yp/DLJscRSJWhzqPbqlkSUDtFX7Xkq8xx9v0ysSpcmac?=
 =?us-ascii?Q?rRqTSmA7zFv+7p87WBMJg5g576J3F5cjEty6UiISN22MJnikPJ8jpH9mxGSk?=
 =?us-ascii?Q?/xons8D85nox7JpnCxamBRVhz18FROmy2RIQIMmH8+i8BxMP4zmIvnSUJJkt?=
 =?us-ascii?Q?pTrkHK5awlnLnw/ET0HdK7g1hphHACAtepTlc7NTfL7xanXhFSsSzoOAb0cO?=
 =?us-ascii?Q?HbLkXhBa5tZcovpMKftBBZX4oXo53Ffhz46p0PPNLUeqCRt6cnhZQLdOD6Ru?=
 =?us-ascii?Q?Uo9O1DSULX1Y69sSJwQf2XASw2yb7tGfDqeyIjShrntbcLIHm3y10w3i8eRg?=
 =?us-ascii?Q?f38cwVwmhIGEgDHTDPSqIwJgWYSFTwgtodaY2OZxY6yt6g3pj0aYsTCd8r91?=
 =?us-ascii?Q?pCWNjU38qv5MjqZv/5UDm13Wqn/QjUdynl8m8TS6k2CyM6HEwPnfmQVbQLhB?=
 =?us-ascii?Q?0GI80NzBIKylS2WN+CaATLJCzKAqRVqYXhs89O1yZHp3+foucJOlPX2cC/ml?=
 =?us-ascii?Q?7YcmHyCIrBh1HDrJ3g5jL1m4t6307v7Awn/iHVHZXWCtf9I8YGUb+TBdIndQ?=
 =?us-ascii?Q?KI6MONMiwRqY9b9P1Kvq/8gNg4gLNJpmpC/5s8lkNHSjT7rVod16aqmHBAsM?=
 =?us-ascii?Q?hcZ0oQaQJJ9Mo3/M2GG5DtFVoHmI73VMa9P1h1re0+J1dJ6qfT+7zAS3nbl6?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ztQhmb/Byj06Ur5QWXgEOlfmia3dVzN3R7KOJILS0N7jASQEPo3LObitto1MlswOm1gkz53SL85cF9TidCDAXKDZUgtH9EiBn6qH9FcY6gJ2fF2hOS6/n44B3SoufiQ8cHIoPGackubFIZ6bk2hVQCLEnBZSSAaUnVX4GyPeczDM7GqwNhkJXScGMVmWOU0MJrHkm1+0D7anKGLJObrXiySp1Vxt1ckfO45vrcUkyDtxZ5pdpe/RGWw/TLK/yc4YehkAgQRD9xLaY/otc8b0GqeXphHRJ3Y8D7boYZaV/RRnOqvVmth9xJQ2mNmjAfKO5ncraHni7dkXDIp4dT+5sg1gtfr8rAxk7y8MZmi2rx33bTpuextVP3XKdUe/KEQsoM0L8oHP2UFQ7+zM+KBX4mU/Mlw6lCx3/ZspASgXfS+f6nGlNTKQGjGIYFqnRWwozZmtYJNFJmXDTcBxMtqUP/RUefemTzECUrVp5WC/6GO+Zfo98f61/5fPXGuO/CIrJ1sqHnpHQNA+kkXseI4StQIOR4v8PEi4L2BLThtUbUjRMG6P9bHKNfqBrzH8iPg7QCRNoG8431CUfWbByNW7py5pc+wolZtausEnIKMKoZE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f1987f-bd1b-44b5-f0a3-08dcc7d7630f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 03:05:07.4539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FlagVfdAzHA55iANcPxu3ccqeBiVFyUpcZtASM5yhGl89T6vkZlo6uKjqlRCPMwrZOjyumAXa8OOEq7ztv5t14rdvmjjqvY4XDypTtuLvmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=546 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290022
X-Proofpoint-GUID: JS6NnBLKacIO4L8P4zE5_giPNvjtrYZs
X-Proofpoint-ORIG-GUID: JS6NnBLKacIO4L8P4zE5_giPNvjtrYZs


Anuj,

> +struct uio_meta {
> +	meta_flags_t	flags;
> +	u16		app_tag;
> +	struct		iov_iter iter;
> +};

What about the ref tag seed? Or does the proposed API assume that the
first block of the I/O always has a ref tag of 0?

-- 
Martin K. Petersen	Oracle Linux Engineering

