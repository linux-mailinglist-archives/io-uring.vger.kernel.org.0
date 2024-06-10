Return-Path: <io-uring+bounces-2150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C00E9901FB3
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 12:47:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29A7FB26365
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 10:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8502882494;
	Mon, 10 Jun 2024 10:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HczBD6nu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RpIa3WlP"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D5F7E0E8;
	Mon, 10 Jun 2024 10:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016287; cv=fail; b=NrLDTB6nZodDC8aqz752X6MtwiMCt5I2pNwDGY5M0rJAubBH2wqCPpHYmx22VrM0DnJ4y8HU7joGCYHyF6sx+9Pjtaw9shN7xBoIwcKKHLMyCPcraxpprxW8iHvfV34fQCDHYYXnKai2fowB6ut7NAyUlZGPHaZN+y/8FTj53Xo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016287; c=relaxed/simple;
	bh=ncs+wF4cOU7J9wJvaw2fIEMsZ54T4tXBgS6yl9iSvOs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZWPnK2lhIlYehcY4ucnf6POrb5lYjht0YnqGgkkSOCKlst8FBHEAwQMoAdBIVb4EOgVtvnriTGb9tOUy7Y1yp17Dp61OgM2aPCpC61yewKJryhKvccnovA7cPxM8bQMc3uA077rGiCPN+ok4Y3kmEUjyLV6tMOvAUZ5B5NdR8Uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HczBD6nu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RpIa3WlP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BMUW025315;
	Mon, 10 Jun 2024 10:44:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=itKPfo0m3h5sNhivHrszfgjbCZt0T7xuLvyRk4Xw/Ig=; b=
	HczBD6nubj5keL49vJIqefc6bt0dZvLQ7VnVlk9kPyiFLF3Uj1NMZ40JiQFgzPu/
	p/mHiIjNrv7h2Xgkf1oyqUcnZWKOEy2qhWrdAqtng/MxqvPw/CufwIloWKdLcJh2
	x4uA3E5ACheFomx9smubGUSotC6dZfvfd+KyxFhurWDfwJJFYjhllmjM9PDhovEO
	q9wBdbzshV5uVtFbESPPjCkuLUBVa9oCf/ktpzG/K9ih24sGdzOZy0SsS/D7yRkY
	Wz4ZnceNS2Q/+Pz17HIEVvw8XM9X3g6c/UhC3oEPK7X/VGKz1yoYqegHFM3pYXim
	M2zTnJ+NZ372XigokC4nBw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1ma9wg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:44:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45A9uGuU036740;
	Mon, 10 Jun 2024 10:44:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdukche-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:44:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwDTEUZhg+Un8Ve/IC2H1AtjYLgEtF8pE0akC4+z35Q33eWNa3dK1ifoF/GA1PO31h31bmz9O57S096xmoG95cOPGAw8zO3/OmdI/RlcXgrLqEoCsOb82H4CczcaxbCqkTs8b6eu6oTduyufqaZkCg79bUlDu+066cu7Y/pIeMHXce8LtXK3LjJ9ddH+AuXvHzMJtAlxrfWaaRdWT0hT9AXGOJ993zpwcQ3Vhpre92iCPzI9n7Gw1Mo9eDfVGiIKIUYtrugPAE91e2xFYkKEEfOph3u4RjfwvMokIDua6es8wAwhGBA7IrfLe1qzoKaTqQ/nOxFb3ZN2ISiDjv+DZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itKPfo0m3h5sNhivHrszfgjbCZt0T7xuLvyRk4Xw/Ig=;
 b=FGT0GywegPaj5h3Er9MD7nsatQ074yf4jtqYIbC1Z13/gt/CD6E6RmTfnh6QUt8FaObAeBSzhLw1vkR4937ZLNraqz28b27ogss4bJ9jBmghw4lAmTC3eJWl+DZKD5xKAivMtilJDeFRXQfVlC0xqFrIHyxncnKdMAXtgPo1QK5/R0oKXvK/ZbkHCQ4n6zJYtbiH3SCAXkd1lo8P58pCbvj9VV1URaydOratwUdjYuOCNH3luaS7b84V+sJMPYS9gI2t6FkZz8qIIJQmf91WBvlW4jzM1Sz++ued9b8jVX5Y0gE0B2gh4g++GyW7JZpcJsSI3Lfr8A0mnrQLgEKbcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itKPfo0m3h5sNhivHrszfgjbCZt0T7xuLvyRk4Xw/Ig=;
 b=RpIa3WlPNTys31HhPz3ADrhcLMPQjTZ2r7DlpzKbFlZTx0ux+xEWUAbm4qVTwr9V5bsuXC2dCXWDXjKDJbEiB9r1Ir+NLyrolm9zOGbZQTXQOZa5YITYLY7kh2YADKYv7ulZ+n+3Q8nquCv7DPZfWrvkjLLT7MoZjMs4hXDlCKI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Mon, 10 Jun
 2024 10:43:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:43:59 +0000
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
Subject: [PATCH v8 06/10] block: Add atomic write support for statx
Date: Mon, 10 Jun 2024 10:43:25 +0000
Message-Id: <20240610104329.3555488-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610104329.3555488-1-john.g.garry@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0024.prod.exchangelabs.com (2603:10b6:208:71::37)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de4687d-f00b-4ac7-b449-08dc893a3c45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?affgBYRQyfq+0EVXJtEQuyelCtAY5qY3Y3/UaZ+yMsr2xiZBiJiV1FjrMlGe?=
 =?us-ascii?Q?4/iFf2vcX9IH/s59HWNpsAB0OejkNKjpKSJF9fJ5GJloz0af2Eu0chNoj7yT?=
 =?us-ascii?Q?ETjuRMHnRB24bq6xxU+s0D1iOmFnsOMKof4X+pLxhrslZeGklYlItnQwUE6g?=
 =?us-ascii?Q?aBbUqu9AHCaMUUkua2z+iUybmBVVYLgXFgdVQBs/rkmT6G+4J1T0gFE4ferq?=
 =?us-ascii?Q?gdplOdm7NGA4oulf4jMui/E5ierUlb+gTDaTRkmMO0xUEuqz+m9Sh78NBYoh?=
 =?us-ascii?Q?KN8fmqyI/LKZ/DggvIAizuPApyn4bkvMU61Of+2v6jqBH6YPvZ9ySTMR4lT+?=
 =?us-ascii?Q?HgGWdNpBR5rtcw8lsP4MqN/SzrP6eb/Kh3fEefBF3gFRT7swJhMS98eX9g2w?=
 =?us-ascii?Q?QrsiDTgZc2bQwZa1rj0Sp9xilsgjQMxfF0mTiJPpOKhQLejoNTuEYikM1qDe?=
 =?us-ascii?Q?Z/vrQoCyMxbwVE6ZYYNaNOOBVX2rdX+735GMDdKyMN7m0AP8qJPaPsKW8ck0?=
 =?us-ascii?Q?4PQ5iCq5SvEYDlsszHbREEY8RmILV1iasLvDl/VwtfgQ5R6qsgkVimacEvVl?=
 =?us-ascii?Q?tsqHVA0fRmFInoX8dHuRcPs9JUVbQi/FeJrbXxxVJEOOe3KmkYem/U6gUpuR?=
 =?us-ascii?Q?bIqkN/MkqZdo54bkl1w0+Ihgo8te/yOlHKbOBcYwQVZt7+nn1XNlbfuLFrOl?=
 =?us-ascii?Q?hVFjBuajRQAUp6Bbkv2lf+WusYfCiT4DDBZ+1x/nlhAdk9dqzI7V/zm4hCS1?=
 =?us-ascii?Q?I5Ep++luIrhYETFTZDQV3Z/nRZ6heWj3Rz0tfwBmFBt+G10v57XMUtbp35bP?=
 =?us-ascii?Q?eoFvv7lMr1DlDvLd1XOjYbPiF80GoarQu5BSLJ8jhU6e4tqxtWYna0K7HTvU?=
 =?us-ascii?Q?Kma+yxp1X+4MgAbdF/bqIjBNis+Mfma9g6R+iyI3usx0GbpM47EvxJQum/nm?=
 =?us-ascii?Q?xK6S9b3/BiP9AhTFSgBIJ/YVPOrkv2yrGbdcuW3LKFP3w61+4fYz8IVuJp7z?=
 =?us-ascii?Q?jSEx/mr2XOxWeNXzi8B+ZQyDgfUptvl3KL/QGERBZteI013DNCeS8sEAcU3g?=
 =?us-ascii?Q?W0nFGMxZBf3EUcdz6aYAzCNQYsiFkEXCZWYEBtpPrbJI/saWE9lmoWLkvCsy?=
 =?us-ascii?Q?ReHSEWs4dhdPOQjsLl26ggxiCNGBePaWdkCtFT5Lx00GPXhFv7+p/sdJ/mJV?=
 =?us-ascii?Q?j9uXtOFALYZsFtfmDxy9t0oTccb6Brs9xHtqBfSg4ejETnxkjmZQS+Pvu46v?=
 =?us-ascii?Q?T87h9/0OEDng/GdsB8DDva/aOU4xMOx7jH1Vzc2zDxhDnvKWpkusSWpRkbrr?=
 =?us-ascii?Q?1QhbZRXCTpLiHxrn4HpAWknoz0+4JmV/2FwzVh3O00WBycMAHBEIm+Rg91df?=
 =?us-ascii?Q?bRFmIHs=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?8vkcE24hvLaArBAjaK69HV/9EYJepIAiuyhtF7VUSWEooaH+LGfxLMJpW3DI?=
 =?us-ascii?Q?fIBMO0T/iDZIM0gG4XZcrwZoH2eP423NjQj34+eou7gTcHca0C01JCKoGRqY?=
 =?us-ascii?Q?h2GVuq3Kocy3+xpMMeHPwkUtL0b+gLjXBxBkemUfoLuFMrMN+kEoBedLail1?=
 =?us-ascii?Q?loerXtR5FpAWpE1uQ7orbVjxSFuqbfrSpymawn58WVWirbXFPRdarbeMKTMo?=
 =?us-ascii?Q?6PFyFUqiLMUT/xadRZ9+aSYsJ/4rHb3d3BjAvj2CBA0p9pkOuF6Aek/usONm?=
 =?us-ascii?Q?FMRCeVu0AEZFSpRe5248HwZxp5juJcpzsHje5Sv3+edgxdvZMZl9kq4DKC7i?=
 =?us-ascii?Q?UH57TZ2aTS9rVfarR3odRVM6YwJ/V2BUo0T6qJoscF11i2WRAUHClXNqRURH?=
 =?us-ascii?Q?fLmKuN0QB9peYrwFwWqjhi9wrBXHiGBpOWv7HdjsC1fgqwhUSyqkmh44An18?=
 =?us-ascii?Q?7plbetPGPSVLbJAMA3fM+fQt08wXngvnxaNxjrRdVRrNVZ7gmLGyooD2ipm5?=
 =?us-ascii?Q?fiX9Jvaey731NI0rnMhCzjiTWkLav04PtzD2hMzilG3D46uOt0/pQGkF5Ruk?=
 =?us-ascii?Q?INNDE+DKiVsNY9buMqmchQaXwDrx0MAAcrErPyxDsiImI/7xoDViHJHW1jwk?=
 =?us-ascii?Q?mxne6/uhlCPP0yXlGTdwGBOf992bjbbfIGPfW4sL9gEdu50Xo2U/AIk9k/Ab?=
 =?us-ascii?Q?mP8wEz3BVAhzqqKh5F1S4hCBbBcYVhWWRgslSlQZBgbRFIapijYRjV7x9QQ5?=
 =?us-ascii?Q?P4uKhqUz8/nxzazfUKsxGjgGG9GIiaXhYgYTLiXgfsdsKiGm4T77Iru4zgIa?=
 =?us-ascii?Q?JO4RmzuFAUdZohvaLkd3qTbp4OZ32BHL2nV1Wwp4Ty+y2ackoIIYJTqx0U3q?=
 =?us-ascii?Q?R0vl2WP2BKsDFJj/JquQgklL4UnxQg9a8vY4UU9eUObiWgLM4+7Vv2LRstdR?=
 =?us-ascii?Q?z4kfnMKPFxBbUl//pWXjhmJdH/8kIV/pFKtdG7gUxQJKpWsd9xW8jBpx1qoQ?=
 =?us-ascii?Q?yLNZqQ0UT/bvzz0Vz5y5Nn8nCpC3n7mzIlZwmQb/hJ1m33c9ZTnl/SV73XSy?=
 =?us-ascii?Q?7EPoWW+6L879FduLqdPzc0qHa613PnGWkGWBv7sbMHbeNxjhaba1J0m9BLH6?=
 =?us-ascii?Q?wVeiQyViINuNsjJmpfBboUug5Y0W9EoFrphylz6htIH59nojLbtucnWwrPNc?=
 =?us-ascii?Q?wlXJNkCdo1Pvwl5TcnWikP7iREeuPWfgalH+xEMHEDXsciIVpQnHejDQ+xx/?=
 =?us-ascii?Q?I+I4P7MlG2OHCV2I5IVV/jbz6PsQKCKc3KwGJiSXHZCYCukPdZYv18r4dID+?=
 =?us-ascii?Q?t0kedMQiTj0o0QwjYg7Dkpn8hobKpT+UJpIwnJgfYUA5KhkN+iwX7k/YZsPg?=
 =?us-ascii?Q?OegvVOoP4kmyuhkcktHZ+PW3AGD5uwBnz/qMOem7rqnkIX7vh72zywbAuist?=
 =?us-ascii?Q?wB9gtjg3XRKqCH07HnVH/mGWHvSWthd9Mac52CkLkgEYLF6dz0SW3XGT/WlE?=
 =?us-ascii?Q?yQoBGbg2RWfM0hhLyUbTuedBNT9v7nKtxmJVxtZ8/bjBI8lUPJnxBWct5tb8?=
 =?us-ascii?Q?I25wpu3Kwu4v/6/2fmhPMtSij/a5Zdnd8tHnoI7b8PLjMlqUHvvrWvWaemym?=
 =?us-ascii?Q?pQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CFxSewXCecsCtIZ4uxfNMtZJMuQIJJE9YlJeN3C1uooEtCkb66w0lN30TTm1HYH7fqPPDVkOYobSXD+iuRIXITRyrfvYPxPZ831RNjtezU3ZCXEJXyX3zKo+Ou1GBh3LwB2l+n1tr1kv8Sx8ffyGhNFgyFhXzTASsvfb10hNc29ZLnSRrobMEocqfrbRZ3EjHCIMnOpm8KaRmUqxNY2nq4dlIBgmL/2d53BNvpO4RV8W8JK9a2+gsjQi9nYzsqXDDePnqo279sOo7Zdz0yDhrJrR+Ov/OERZ6ZmpL7sHFdhx2m7DpI6FNNr6uvXfswlstNupjnBpjuKfLD7DwwSlxxyl9rqUPCmjSxUvqkAjrQxy2SgjFHMuAzRYDkv2/Q2TxIiQEoTGSpVRicG84tB9cSIDDIIPcvmCn9GQaPo6E66NeIC08roOKMGJ58WRDUCb6BwuIzDw2cnhgNzogTtneJDTNz0V8wee43FozK6RdMb3MrQKx1R7WeCAJvuYT02DlNMT7nkepqkW+3n8Aj7cwl2DN5WGKuYxL8KG8bw+J6BdTNdsNImrJ/P0cb9SOJuu2BmcSU2lp57G85iFp9l6vtzYjvoUO9dhBwTTJ50ryho=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de4687d-f00b-4ac7-b449-08dc893a3c45
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 10:43:59.3232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4RarPeDOYFEhjNqSgJBMrWI0gn2OrdubQEnFNOjbRRdC3jxjTxeuMvUVg2WtFwvKI+O/j3nmtrWvQvcaXJ89w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406100081
X-Proofpoint-ORIG-GUID: iYeyVErxFtTHqCiL1FNJXu6v5waaQxz2
X-Proofpoint-GUID: iYeyVErxFtTHqCiL1FNJXu6v5waaQxz2

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
index 930debeba3f0..d861715c0f4e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1590,7 +1590,8 @@ int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
 int sync_blockdev_nowait(struct block_device *bdev);
 void sync_bdevs(bool wait);
-void bdev_statx_dioalign(struct inode *inode, struct kstat *stat);
+void bdev_statx(struct inode *backing_inode, struct kstat *stat,
+		u32 request_mask);
 void printk_all_partitions(void);
 int __init early_lookup_bdev(const char *pathname, dev_t *dev);
 #else
@@ -1608,7 +1609,8 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
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


