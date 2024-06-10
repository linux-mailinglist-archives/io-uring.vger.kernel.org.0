Return-Path: <io-uring+bounces-2156-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E69D901FDA
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 12:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD7131F2109F
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 10:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BF7143727;
	Mon, 10 Jun 2024 10:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J4oxjBcP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nHo/EqA3"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365C213DDAE;
	Mon, 10 Jun 2024 10:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016297; cv=fail; b=cOmsPXMi9q4vMbhcmDkR/F/Hgqx1bjT6sJrzLEKMR0eCHUcvOQOZOunh9D0kjpZaYPnXulL48rpIx3Nnv9o9saMBbn79SZtzxCnjxDjHeZYBCqRWba5IbVZsQxaV0z7WaBElk20L8l0nfSttXwtC3Y3KcB4Jsq93Zw65GBfK5Rk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016297; c=relaxed/simple;
	bh=fpBs8Q05QP9h8997Tapg+W+QlIARQJ0aVgGpHmiprEA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LmDmeSRR0EmdrrCK+2iK2DBd5doD1eMOaJ5cZnPkJO9jadll9RENCg6VGkbbWOaLN7/GMLYMmrXNvqggPZxBcIlCGm2NQqAQ/6qvxR9FgTr5d043PITQnObv0ZRGlbCNrBayn6VRDdUF4xpkaVe1ofcxPYBBuu/QpMGHsg6y7AM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J4oxjBcP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nHo/EqA3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BSKo006761;
	Mon, 10 Jun 2024 10:44:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=tZ9etgNWFzxoGl6vttrRSkXH0odkInGHkvSdo8PtLNI=; b=
	J4oxjBcPfwPtbC2espJQIa+WZM3q6TI/vIC1K/wkSW9i9m/KbbAtJqSjYMyD6RcE
	tMiUartwJRBHcOu/TJZZpXKABs0HK8SAwLoIGknt6LG5zPzJtbrJT6Pf6TVNW+bL
	uXlS+G977TK5C2Nn1nqD+S6oN+AHvVO4SlAa5W+dkARSeeorgtjgRHVX4DzVv6ai
	vHj20NLobM11dwRUiLzAL6SJLPLK5iWH2czIxEePxWfzo1eMr+cH2bAE40cIeLSg
	Ohf1wJTaMVPhTUKrvI68gLeT+RnVGgr7gs6ZQCLKsW1urdIgGFe7zhnDNK3vRGHH
	PbNCD98eH1hR13GXHT82Pg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhf1a8tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:44:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45A92EWJ012416;
	Mon, 10 Jun 2024 10:44:11 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync9v4sgn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:44:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rx+doPyj3k/MX0yUsgKPbAu16zdZrXqWvnAyDbA8zLkxVKdYshEornCKu00OWsZSOcOeAf0413PsW04c52tTM+x6yhqaXQ1VDOaVVUA9fwHhZoCafE5OVZhTRuZh4RfEQH8uxujmvGqYqBwyluensDANvHPmhChBSV8MBFEY9wyixOWc3aOeQgeOdamV3LcyDh1mCz8u/8FKui/clvMDCJeoNX4gvCEHmY3SgBWIvkmpp8uxxQtzMI1g6rgxpwhzjgoh1eXioGQDruxsz8CFVzuC+2IALtBM2+Ehr7cUbfT9zTJGWmhvqKx1FF7dG5abi2IKi8+jQtBRjRDro0vjdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZ9etgNWFzxoGl6vttrRSkXH0odkInGHkvSdo8PtLNI=;
 b=VixMAchr6lyOmNiYWzRl/WpdgFUlHxqVXfdhT8sCGP14gWkOkvMcXv2Yfmpa+wgIX3RO/8OMF16XZfHIKq4pim82hXWbabvL/ldcTdOyGcbEh5GjXPgIkiiHVXZJZTHvwCyPS7hmd858/Bz8aKj9hRC/lzu+uCuxBff4t3IPYvUyXKsGvoisDBBAjUec7cFxPhE/o//Gkz2eEZebbqWvCJ5T37HRb6uI5REYu0hOxSzdPn3Yn1hi+q3ZJD3jev3TkMjmjzPj5xN9giZvgB2zkBd8eneMGqAlRnP3UMdJR7TWqzHmtNAsMsdaao9gadKzXQJs/IU4N5YLxE3aj6WR0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZ9etgNWFzxoGl6vttrRSkXH0odkInGHkvSdo8PtLNI=;
 b=nHo/EqA32LhlwMyF7m6iQGBzpf85K4Wnzg3eaGr0mjDIPRiCbTgrD6rYe/Mf1F9L4Hc2c+7q/BbNx6+Pe8T+PjSYCEN0s3VNGV+hIeSs6sZzpgWZTZ6DNDv6Kn35yW5OmoD2zQPUyRiw6s838Xvv+4VRfZUW3nTzxSmYo3SqzKE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Mon, 10 Jun
 2024 10:44:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:44:03 +0000
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
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v8 08/10] scsi: sd: Atomic write support
Date: Mon, 10 Jun 2024 10:43:27 +0000
Message-Id: <20240610104329.3555488-9-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610104329.3555488-1-john.g.garry@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0257.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: c3113d48-65c7-4776-6f0c-08dc893a3e6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?T18ynjVKtInzXnzUIzsjg0D8y/4JtjKa2K/L+jJMWXI3CAarrB0STeJl4CHf?=
 =?us-ascii?Q?AxkH47lI/XwORaHA1kHPjxRDBX6bAgjK5MkE8hdFL5adOgQl1zIwzl4aSZWC?=
 =?us-ascii?Q?NIgUo54fsEA1nRB2KQ5hs27Muh1zpm6hWENh9Wqnod+8JOg3LWzjb5n2aoO5?=
 =?us-ascii?Q?ieL9I5RWc44frcfnEHsDL9EPC5j88hkQfQjBSu17F27orofZojSfia9qL0UA?=
 =?us-ascii?Q?XuMbCa3R3q267zxPL0KK6G/uPFq14tarV/Btw1hKgWCf3Nj2Le9Ezgr3r1q2?=
 =?us-ascii?Q?++wzrRzg+nrN6RSFkSJXvgyo7pqhHfLvlUkXOx0zeSmgpEwgqPa0VOwuwhjo?=
 =?us-ascii?Q?0BcY27H1oVDAKvPlZq04uw3zcUItEQZIjGxvCeF9GOYpln58E9uypEFTawqY?=
 =?us-ascii?Q?tHK6BsmWJt8QWaDCuvM+z4a1UmLua6wlYMtK8X6SB6p9jBfdQPf276ujWv+D?=
 =?us-ascii?Q?5Qf2jQ8vCIeWGmaIg8SEj/88CnUd66kiwgAWq0DiUR2XVGIZRf4d8vVoBo/X?=
 =?us-ascii?Q?Jik0MnxvaxbLaPXAUVAfBAgIrO+E9lmA0g5+//SB8Yt8VUfLxnR3WJrfB0D7?=
 =?us-ascii?Q?rwkyooPE+pXLbqhPOcJxoSs2bdBSG4cDesCimKuycKQuBQrJ2nar6unrfC6P?=
 =?us-ascii?Q?Q7EEVsbDLOEzRBmZfpQQtkLFqFMqajiTzBwVsyUeDfurWi7glqpMx+l6bLgM?=
 =?us-ascii?Q?7EOhm7mRGc8R8HDms46rjAlncsF3bVqpR9fu4AoPLe8aKAHrPRCZKGOZuvfP?=
 =?us-ascii?Q?nyrqehju4ZqsPgOC5NCYPLMCq5Zi0GIeMfQ1iMHAM4B1QaBmYsNzPv/YCs8E?=
 =?us-ascii?Q?gm+OMr+OPWeAMmxqu4DoS4/jKsykhI4h3kdXEIKQfW6gyBKsc/CVHPcScnfk?=
 =?us-ascii?Q?WsAadQUmw/qdd4D24MrCBt0Wrv0otxwiZF48X95BOabkEKdx9tZNV5VPuS8T?=
 =?us-ascii?Q?vj4+tX2nkI2RVcbowuR0+xmWNgec49fcsyitbSFshyQIfYAC7LLny+CQrWQ1?=
 =?us-ascii?Q?G/rGI0O28AH27K6PjvTFGcWknfnC2/9uDpA3xsjNxt0VXc4iZdkSNct37L/V?=
 =?us-ascii?Q?qtXRj3AxGuO/FePTXa2aOCxaZPDvtS4ETICWAtF0/rOBCRzMLhh+MVPziazv?=
 =?us-ascii?Q?SVxcYSWjJxCThXEYZ7bOEbcHHA80aR5FUu8FtD+6Tpg+YCN6WAAnH+4//hvO?=
 =?us-ascii?Q?JN0zYMC/tFy9XQbMeuOqyP1nw87J30tyePD/aDw3p7xdXyjmouZ4nPz4W8bS?=
 =?us-ascii?Q?QkouxILirWMTz0M146DUMI8X9YR52QgZzbzzBz6myyHqWB6LezRabPCnzWbV?=
 =?us-ascii?Q?RIQ7hxFmNa9TBk9AJEwEC+yyproKGxg7oZ1jTWlOVsIxl4PrbLPZkoYHybot?=
 =?us-ascii?Q?57zT4Jk=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?QHxWxJFhY0QLoMDWXNiLbXLqyXpuNt6xHAXRJA8SjteoLI00nVloJYHo/DYm?=
 =?us-ascii?Q?+Gz6NjM0LuiFTcf1Qj9MbUFDSpcxaOerIo/VIhr/Fb2ZBodXllIZDJffYX5y?=
 =?us-ascii?Q?JsVRXMW/iBtvG5HI6wQu6YA/2DguDPE2l/9qykKxiMI6BsrQjoH3+QYrvpTk?=
 =?us-ascii?Q?XNpuHwqW8XUQr3edeZhut7CZb5VlLkvcPVNgqOh2iLm5tG1WKtPRLDJ4RL2F?=
 =?us-ascii?Q?HeD7jNn6SQoytBFWUuiRv1E9/DdH16Vm4sw+lQKqw90cYij5B3ajLTzwn6nM?=
 =?us-ascii?Q?eHtaJyITNdQ5NYgNNBCRDGdp+IkXvCEGPMPg+CntPsGZMIuYNRi6fts0satW?=
 =?us-ascii?Q?xFpCB8w3H7pwBewcwOhMguElASWc187Cc5E8Dhsm4wPbfwiSuHJmOkajEmL6?=
 =?us-ascii?Q?ASnLkOlAXmhNlahIddwibhy9K+y2meKa3Mumsb2wQ6AEpzEnSwQQfisUYyck?=
 =?us-ascii?Q?eDsPot5jm40SyDYv+g4FcR3HebfbxuhzDu95YvmT2EbuOmnfdXAEnX/ewG5r?=
 =?us-ascii?Q?rSr497SNF40+bJbsohzEJ9LND+qqKrbeUPQn91jFF3ZnHonzSfzDhfVxWab9?=
 =?us-ascii?Q?+g7dUMk3V6ClnUol+gu+jJmP/Jh0fxxYf+jHtaP2AL1pWNhnuoqV8COJzrmz?=
 =?us-ascii?Q?+jfuTjPD/7sPrV5WgPfvzYOxreez2stt7lx1gfIFUX9jX8R+t6HaDcg5Po5S?=
 =?us-ascii?Q?MdQ8J6mDxfQIJaTUF83YG+HaL2yYhzI/oZAx0LbWtGMieHlGduUqeD6zXyS0?=
 =?us-ascii?Q?U+Co93lyaEzfeAIdzjPFD0/6aQoAgBbnzvTxMrkVT0kP2A0JmmMknBzeX6Pm?=
 =?us-ascii?Q?tcBZTTzUneRvgeZq+sYNin1Re5rLqFOUgriLH1U62Ju4dDD3yh3ANyQu8jAb?=
 =?us-ascii?Q?Y5uFMe3vMw6cfX8vEdCczFBpoL+FULELmGOipO6RTm3CECT7uhxWp002Fux5?=
 =?us-ascii?Q?JP3IYr8HjYBslkPYCd7klhztcqJSBtPhei2quyS7njm8AvmbevSfJtbMQr12?=
 =?us-ascii?Q?XD4VHlkem6LqB1r50CF+LUf6zyhixiNtTnvMGZCZEarcBF6DZgj5ezz5TbNH?=
 =?us-ascii?Q?lGVxingYztoBYcszyaJHf1HTp+CSFTCcLF+Y1dSGobjf43Cdf57LqdCiClZz?=
 =?us-ascii?Q?fK88kKwmhrXwZxxvO8VntUnIEcsIC8l22Uxrwile06pW35cj3lkW6TajXPIe?=
 =?us-ascii?Q?pS7BmPkKqKQXVhfvza6wWgOg5YVG50dp6ckG6MP0rbNHRJRttUmVN4KO0WMm?=
 =?us-ascii?Q?zZx/EOLuw095E2dnq4TLg+i2oJ2yXP2Y8qsBxwec7cdSDMej27KEs10zohgO?=
 =?us-ascii?Q?tcZafOaDEbMQSpocodDflpBhEghMpLquh0mapmgdFiLtV/o2ORVou9zxwiMK?=
 =?us-ascii?Q?zCu8SaighviKcwYWozlcD1a9pL122vO1t7seffPKXVXdy21DpowmYR2Ulzdr?=
 =?us-ascii?Q?R6dUyhqqqqzL7ffD9YR/uf/T1otY/ZreSYYDoAKadg5Ae/1qKSl3oWI4Q4g8?=
 =?us-ascii?Q?xI0m80aqSUQ0am6uIuPAGKHZTctLsYhiAXEFySUwYqFAW/TWLIiZVBSYBv8G?=
 =?us-ascii?Q?d2l+jVJVNkJaCGC2EMnhWXz2hWTybKd80Fl1J5qWLKsx9/U1Dn3piMXRrP/e?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	DqO7M0rHyZy8AOdc11lyCek+fg0T6QQBzM6hWMZTkRPKMNciLZE7Qz4we7I82s+qejdjKKp/bwJHuyODl4I455Nszm1QDnqblfFVBbRb491iMMtEcBrfJpZ4XPALfUCdCWSGYBybdYUJMySYBPmhK56FslgCR2GweYP/+i3dJQDFjvqEQN05eqMrhjKfWFrwH+oHna271AKjsSKxUNXlESKBsp6yXggPJWfxGI0AchPD7dfjWqSzOV/WSfzoyxbGJp8vg/MfiwYC1a4Xxe87F0w5EtbilSFBWyWtXRXOnarFG9uP0DWzecQlTQ2TEqiwRXH6O9JI/JgBGo/f4E5IhH+w8nYiC1zcdSZIjgap3FarovCFAhPUYhoMYRS/pu99XEzysz1cZ/WJ2iWc2wptgTPx0H5OvSbnhNKGYbacpVcB+J3xxhbussK3RDJYSLJkOZoMqYttGZRL5RK6mpqWxgIZ322uo0qyhzChHBhlnULQ+1lRT8z44DMDtp2p0Vx+fZ9hU1wA1NTGCPVoR1avjMtNBsKlkKhcEXo/mZeHu6HASxkDU6huV9ze1HhGpVVAKYfSQPl5Jx5I4bwwNJ7Aeb8RYEvE+4/COqYaKDukvm8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3113d48-65c7-4776-6f0c-08dc893a3e6a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 10:44:02.9644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p5FqkffnvJoXcX1ApUlAv8e6PUomKW+RI27xqM0i86yZmb5x+TTFZbHKHkHRqDRqeVTdDhbqnQGC5DS0Tfubkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100081
X-Proofpoint-ORIG-GUID: rAFomhhpeKREl9-oWeGfVwDAPOzRsmfr
X-Proofpoint-GUID: rAFomhhpeKREl9-oWeGfVwDAPOzRsmfr

Support is divided into two main areas:
- reading VPD pages and setting sdev request_queue limits
- support WRITE ATOMIC (16) command and tracing

The relevant block limits VPD page need to be read to allow the block layer
request_queue atomic write limits to be set. These VPD page limits are
described in sbc4r22 section 6.6.4 - Block limits VPD page.

There are five limits of interest:
- MAXIMUM ATOMIC TRANSFER LENGTH
- ATOMIC ALIGNMENT
- ATOMIC TRANSFER LENGTH GRANULARITY
- MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY
- MAXIMUM ATOMIC BOUNDARY SIZE

MAXIMUM ATOMIC TRANSFER LENGTH is the maximum length for a WRITE ATOMIC
(16) command. It will not be greater than the device MAXIMUM TRANSFER
LENGTH.

ATOMIC ALIGNMENT and ATOMIC TRANSFER LENGTH GRANULARITY are the minimum
alignment and length values for an atomic write in terms of logical blocks.

Unlike NVMe, SCSI does not specify an LBA space boundary, but does specify
a per-IO boundary granularity. The maximum boundary size is specified in
MAXIMUM ATOMIC BOUNDARY SIZE. When used, this boundary value is set in the
WRITE ATOMIC (16) ATOMIC BOUNDARY field - layout for the WRITE_ATOMIC_16
command can be found in sbc4r22 section 5.48. This boundary value is the
granularity size at which the device may atomically write the data. A value
of zero in WRITE ATOMIC (16) ATOMIC BOUNDARY field means that all data must
be atomically written together.

MAXIMUM ATOMIC TRANSFER LENGTH WITH BOUNDARY is the maximum atomic write
length if a non-zero boundary value is set.

For atomic write support, the WRITE ATOMIC (16) boundary is not of much
interest, as the block layer expects each request submitted to be executed
atomically. However, the SCSI spec does leave itself open to a quirky
scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero, yet MAXIMUM ATOMIC
TRANSFER LENGTH WITH BOUNDARY and MAXIMUM ATOMIC BOUNDARY SIZE are both
non-zero. This case will be supported.

To set the block layer request_queue atomic write capabilities, sanitize
the VPD page limits and set limits as follows:
- atomic_write_unit_min is derived from granularity and alignment values.
  If no granularity value is not set, use physical block size
- atomic_write_unit_max is derived from MAXIMUM ATOMIC TRANSFER LENGTH. In
  the scenario where MAXIMUM ATOMIC TRANSFER LENGTH is zero and boundary
  limits are non-zero, use MAXIMUM ATOMIC BOUNDARY SIZE for
  atomic_write_unit_max. New flag scsi_disk.use_atomic_write_boundary is
  set for this scenario.
- atomic_write_boundary_bytes is set to zero always

SCSI also supports a WRITE ATOMIC (32) command, which is for type 2
protection enabled. This is not going to be supported now, so check for
T10_PI_TYPE2_PROTECTION when setting any request_queue limits.

To handle an atomic write request, add support for WRITE ATOMIC (16)
command in handler sd_setup_atomic_cmnd(). Flag use_atomic_write_boundary
is checked here for encoding ATOMIC BOUNDARY field.

Trace info is also added for WRITE_ATOMIC_16 command.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_trace.c   | 22 +++++++++
 drivers/scsi/sd.c           | 93 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h           |  8 ++++
 include/scsi/scsi_proto.h   |  1 +
 include/trace/events/scsi.h |  1 +
 5 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 41a950075913..3e47c4472a80 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -325,6 +325,26 @@ scsi_trace_zbc_out(struct trace_seq *p, unsigned char *cdb, int len)
 	return ret;
 }
 
+static const char *
+scsi_trace_atomic_write16_out(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	unsigned int boundary_size;
+	unsigned int nr_blocks;
+	sector_t lba;
+
+	lba = get_unaligned_be64(&cdb[2]);
+	boundary_size = get_unaligned_be16(&cdb[10]);
+	nr_blocks = get_unaligned_be16(&cdb[12]);
+
+	trace_seq_printf(p, "lba=%llu txlen=%u boundary_size=%u",
+			  lba, nr_blocks, boundary_size);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+
 static const char *
 scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
 {
@@ -385,6 +405,8 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
 		return scsi_trace_zbc_in(p, cdb, len);
 	case ZBC_OUT:
 		return scsi_trace_zbc_out(p, cdb, len);
+	case WRITE_ATOMIC_16:
+		return scsi_trace_atomic_write16_out(p, cdb, len);
 	default:
 		return scsi_trace_misc(p, cdb, len);
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d957e29b17a9..a79da08d3cce 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -933,6 +933,64 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	return scsi_alloc_sgtables(cmd);
 }
 
+static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
+{
+	unsigned int logical_block_size = sdkp->device->sector_size,
+		physical_block_size_sectors, max_atomic, unit_min, unit_max;
+
+	if ((!sdkp->max_atomic && !sdkp->max_atomic_with_boundary) ||
+	    sdkp->protection_type == T10_PI_TYPE2_PROTECTION)
+		return;
+
+	physical_block_size_sectors = sdkp->physical_block_size /
+					sdkp->device->sector_size;
+
+	unit_min = rounddown_pow_of_two(sdkp->atomic_granularity ?
+					sdkp->atomic_granularity :
+					physical_block_size_sectors);
+
+	/*
+	 * Only use atomic boundary when we have the odd scenario of
+	 * sdkp->max_atomic == 0, which the spec does permit.
+	 */
+	if (sdkp->max_atomic) {
+		max_atomic = sdkp->max_atomic;
+		unit_max = rounddown_pow_of_two(sdkp->max_atomic);
+		sdkp->use_atomic_write_boundary = 0;
+	} else {
+		max_atomic = sdkp->max_atomic_with_boundary;
+		unit_max = rounddown_pow_of_two(sdkp->max_atomic_boundary);
+		sdkp->use_atomic_write_boundary = 1;
+	}
+
+	/*
+	 * Ensure compliance with granularity and alignment. For now, keep it
+	 * simple and just don't support atomic writes for values mismatched
+	 * with max_{boundary}atomic, physical block size, and
+	 * atomic_granularity itself.
+	 *
+	 * We're really being distrustful by checking unit_max also...
+	 */
+	if (sdkp->atomic_granularity > 1) {
+		if (unit_min > 1 && unit_min % sdkp->atomic_granularity)
+			return;
+		if (unit_max > 1 && unit_max % sdkp->atomic_granularity)
+			return;
+	}
+
+	if (sdkp->atomic_alignment > 1) {
+		if (unit_min > 1 && unit_min % sdkp->atomic_alignment)
+			return;
+		if (unit_max > 1 && unit_max % sdkp->atomic_alignment)
+			return;
+	}
+
+	lim->atomic_write_hw_max = max_atomic * logical_block_size;
+	lim->atomic_write_hw_boundary = 0;
+	lim->atomic_write_hw_unit_min = unit_min * logical_block_size;
+	lim->atomic_write_hw_unit_max = unit_max * logical_block_size;
+}
+
 static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 		bool unmap)
 {
@@ -1231,6 +1289,26 @@ static int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd)
 	return (hint - IOPRIO_HINT_DEV_DURATION_LIMIT_1) + 1;
 }
 
+static blk_status_t sd_setup_atomic_cmnd(struct scsi_cmnd *cmd,
+					sector_t lba, unsigned int nr_blocks,
+					bool boundary, unsigned char flags)
+{
+	cmd->cmd_len  = 16;
+	cmd->cmnd[0]  = WRITE_ATOMIC_16;
+	cmd->cmnd[1]  = flags;
+	put_unaligned_be64(lba, &cmd->cmnd[2]);
+	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
+	if (boundary)
+		put_unaligned_be16(nr_blocks, &cmd->cmnd[10]);
+	else
+		put_unaligned_be16(0, &cmd->cmnd[10]);
+	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
+	cmd->cmnd[14] = 0;
+	cmd->cmnd[15] = 0;
+
+	return BLK_STS_OK;
+}
+
 static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
@@ -1296,6 +1374,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
 		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
+	} else if (rq->cmd_flags & REQ_ATOMIC && write) {
+		ret = sd_setup_atomic_cmnd(cmd, lba, nr_blocks,
+				sdkp->use_atomic_write_boundary,
+				protect | fua);
 	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
@@ -3256,7 +3338,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp,
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&vpd->data[36]);
 
 		if (!sdkp->lbpme)
-			goto out;
+			goto config_atomic;
 
 		lba_count = get_unaligned_be32(&vpd->data[20]);
 		desc_count = get_unaligned_be32(&vpd->data[24]);
@@ -3271,6 +3353,15 @@ static void sd_read_block_limits(struct scsi_disk *sdkp,
 				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
 
 		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
+
+config_atomic:
+		sdkp->max_atomic = get_unaligned_be32(&vpd->data[44]);
+		sdkp->atomic_alignment = get_unaligned_be32(&vpd->data[48]);
+		sdkp->atomic_granularity = get_unaligned_be32(&vpd->data[52]);
+		sdkp->max_atomic_with_boundary = get_unaligned_be32(&vpd->data[56]);
+		sdkp->max_atomic_boundary = get_unaligned_be32(&vpd->data[60]);
+
+		sd_config_atomic(sdkp, lim);
 	}
 
  out:
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index b4170b17bad4..c7ee1e9c2ba4 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -115,6 +115,13 @@ struct scsi_disk {
 	u32		max_unmap_blocks;
 	u32		unmap_granularity;
 	u32		unmap_alignment;
+
+	u32		max_atomic;
+	u32		atomic_alignment;
+	u32		atomic_granularity;
+	u32		max_atomic_with_boundary;
+	u32		max_atomic_boundary;
+
 	u32		index;
 	unsigned int	physical_block_size;
 	unsigned int	max_medium_access_timeouts;
@@ -148,6 +155,7 @@ struct scsi_disk {
 	unsigned	security : 1;
 	unsigned	ignore_medium_access_errors : 1;
 	unsigned	rscs : 1; /* reduced stream control support */
+	unsigned	use_atomic_write_boundary : 1;
 };
 #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
 
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 843106e1109f..70e1262b2e20 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -120,6 +120,7 @@
 #define WRITE_SAME_16	      0x93
 #define ZBC_OUT		      0x94
 #define ZBC_IN		      0x95
+#define WRITE_ATOMIC_16	0x9c
 #define SERVICE_ACTION_BIDIRECTIONAL 0x9d
 #define SERVICE_ACTION_IN_16  0x9e
 #define SERVICE_ACTION_OUT_16 0x9f
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 8e2d9b1b0e77..05f1945ed204 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -102,6 +102,7 @@
 		scsi_opcode_name(WRITE_32),			\
 		scsi_opcode_name(WRITE_SAME_32),		\
 		scsi_opcode_name(ATA_16),			\
+		scsi_opcode_name(WRITE_ATOMIC_16),		\
 		scsi_opcode_name(ATA_12))
 
 #define scsi_hostbyte_name(result)	{ result, #result }
-- 
2.31.1


