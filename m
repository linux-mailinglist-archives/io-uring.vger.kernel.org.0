Return-Path: <io-uring+bounces-2155-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A2F901FCF
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 12:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F984281D56
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 10:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D189613FD96;
	Mon, 10 Jun 2024 10:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hTNc+YEW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gORaHUzQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4640139563;
	Mon, 10 Jun 2024 10:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016295; cv=fail; b=PHagimgTZnRRxRrjK3xxSjd1n9OyXvE1RLwKJiI8nEhHq4GBBN3VBPJuHpPEmLH+MxtJmXDLgC+MMMNa53nUKg9GcNmrODW4NNaeNBcqFvOtSlMWaNIptt5CFi7vAvHI01+BhCJVu3d4rvq5UIQZCb1rEKGxVCCSUz1SCeY6ywk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016295; c=relaxed/simple;
	bh=5/bFNX2HlMfsKCpFbHV8K1O9l2Ek5stP7KrzYC8R7Bw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mRf+QvGjp37/M3h0vl0wiV16VX7zbWzWrwsBLMPDPY5QtNLrFH+c4JvnWI1PIWfGyvCW1qduWdfP/QZwMlHCpCcDTDNfxPPqwdorl+4ODOQICnTMxaD8pvyE6JtVxrAs2fbIBV0KTI/qbrYME3SH46h5/nJXV58TvW4ZTSi81UM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hTNc+YEW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gORaHUzQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BSKj006761;
	Mon, 10 Jun 2024 10:44:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=TbanG9OOchDY9/z2mDu4fqQnev6OFwdKu+Z6IOGBWmw=; b=
	hTNc+YEWRRa5w+ibiHckZif9bzmWjXAw8QpH8zn/GDelgGgwqrF3l56Bk1O4ZYuM
	AkYsRZqSznoc4I3Sb/5u098zNTqgWfGGWonNcTXzxaV1RU/pMx+edCI0xh6AWFfp
	8LI7EN2ovFc2WiHOfd1Wf2uYgl/V3vesLT00YBXr6Zpky7bvzSgVf36UuyHW91nj
	7OVf4Q+xIkQXfPXQ81ULzcojzSI/xN53mKnACSqKt1ZcE9eeXeRLHUMZ+gtiqgS1
	bhC7uG1KdFpF09SrtwZY/m9HkV4CzPPhU8x1Zvb0uE7lovogNSrhLZbTfJox052S
	rH/FuzW8/v4JafNwVoCWNA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymhf1a8t2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:43:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45A9B996012520;
	Mon, 10 Jun 2024 10:43:59 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync9v4sck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:43:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaAyLgYSHuwYp5DkVuxDT9xBJjiChgdGTIkPUglvEMh90V9IUhJcYukzjmwfA1ZQu1OeGxzvQs8ZPBo4e54Yk5OqB5JP4JklIUvTz/kcI4fws8zeHAJs2Tdz2xhMZsyPWt4Y/GUtnFk5+8Xzd0ht8eJEerFfRlN/2QpUcOzWAhcY/LJTkMSj9MK5buez8j9XthiRJvnYkMG7MMaaftaFm8dcnXNhe67IOFfSkq8Q6CCvUkSXEMz+IGwDw09ITEGR3zMadikLXIS0h1+xWmUZIfYgATz7/ENnUbeL3nIcKCSjQEWTcmOQUrbIZDrI76E2m3pCeK0C3a4HACJ9LtJQIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbanG9OOchDY9/z2mDu4fqQnev6OFwdKu+Z6IOGBWmw=;
 b=ntqVOn09St3essbzi/Soxpn+Wc45TENCokWQU+r6Qn0Yc/Z29RWz6rClf0wD8h0TrB7l+X7Vr5hXJTDH2fvsU3wiwCeofSNMRvvIU68iuWtdSRMjkz/WAsJS0PYnyTRAV8lKgoa+eltOhuOthxSuscMddZAUHtH9l3vkPlPopOjmNOlOg7jM0Rkz2QmS3ykNnxlLfjutnKYsfnOTxjoMk6crfOvgGPYXIA5NT07/1QK3O2CxLSt4fT5Ak+bMIbsdzhsLonx9DYDICrz5uKh5v+7ilEZkMOVUUTKpsEtO7BxTv0rGXQSFk4R00McO10VhKj5lbt0pS1SzXbUh3/2IuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbanG9OOchDY9/z2mDu4fqQnev6OFwdKu+Z6IOGBWmw=;
 b=gORaHUzQU/DNUE+ieKs/4w57DNpK7/5ocK/M/NLWdixeTzwt5eIcbztLS8qTUnhfzOMPSFoElL+EEtS9TjZF+DVlon4L871y1O0/93H8S7MPKaQRzcN3QQSEK+parl1rZEo4LuUhQ+Unz/Ocv/0HAWLTcLf+eY6T5p6n/Zdq38o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Mon, 10 Jun
 2024 10:43:56 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:43:56 +0000
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
Subject: [PATCH v8 04/10] fs: Add initial atomic write support info to statx
Date: Mon, 10 Jun 2024 10:43:23 +0000
Message-Id: <20240610104329.3555488-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610104329.3555488-1-john.g.garry@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:208:c0::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 327340ad-2578-4670-26f1-08dc893a3a8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?udMSq2L4Spl8FLgcn48LMRU/mwpbC6G7I5EXjciq3Y7WTw42EhshikE+ecKt?=
 =?us-ascii?Q?E4hvPJ8CnVX9XYGbMHF0Ylal3t+bN+EUDz7DxswlUjrB7Ev6Z2CO+oe1Fqlj?=
 =?us-ascii?Q?SSI/gfW6xBSkyO7z49uYLzX7ZB2Rh1VkGw5u1ug8ovbu3Q6PW+UqkUa5Ie4/?=
 =?us-ascii?Q?0s+EOp+Tgrali10XvHptAZ1fzSK15pEzN9fx4tXKdgID7BluSxzijrbA2vg7?=
 =?us-ascii?Q?NQ4b2jTT3vSXPcaroBaygxvVqePFtujdlSbac+fg7j6o8BHURrQ6d+CvLQun?=
 =?us-ascii?Q?7mgUfGDnkL9b3t8McSV9EIzOG5ePptFm+jD7ICD/aZ0+AQkTi1DJTGuom7tZ?=
 =?us-ascii?Q?qH0BT0tfW1Vcq3AxGpMOgaqWrt62j2TuT9sYC7NM9oOTTBnYcrv9YIv/6Nic?=
 =?us-ascii?Q?i5I+lFS/2CDBMZ+A064YD0Dm34Z8yHRpukOCCyFgu9GdspaKeL8rQp6keCuu?=
 =?us-ascii?Q?usD8EDEZq02pnLYK5xmuvgexK6pTZ5KVGFOpVYL78l6OhT+/vqqr+4GtTonu?=
 =?us-ascii?Q?l4KlEjwymG4HDYKptL8mgKEpxr1lz7ZEJX5xe6nM7g+eywhsmwe5jFN8IXuJ?=
 =?us-ascii?Q?ryPBOcAqMQF/+MAD4SSjlurx1XgAc9aYWIsJDDAUhOYbFarIdpXjxUBkhQZI?=
 =?us-ascii?Q?BsdPKgjd6NViKJMEaxhJRUYjMqB2iP2wL5o0cxRdSXKbRzqcQJR8hBRNY+0/?=
 =?us-ascii?Q?pJAJldzoVI53Byjs+RlPg8gK1VV3GY1lpYTwCh4q9okiPjH+JEZ0W4IUJE4F?=
 =?us-ascii?Q?+Yz93ap0VT0W14/8pYh7Bg1jNOXloe/iBvjC0ULttGQVXH5rAyIBhZGBIRhd?=
 =?us-ascii?Q?g0YtkadtTOC313m6rq4+6iXH+M7LJSMB5xMj/rO1LSmTFoklsPhpEdwzRt+c?=
 =?us-ascii?Q?EPRsZeL5tJzxgygVv1gygICNGkxtxyGg/NIFfOBw7VaLDyx+uUSbADkHHrCr?=
 =?us-ascii?Q?VShPtThLwy1+A2RmF4L4jXmbEL7b0TzQ/D9rtnmiOJSw06cxCHDp4B3UjSMw?=
 =?us-ascii?Q?LDc/Kqy4tBO/zmyOxwrftJojvcXfV2cveqTLIY2gLfIS9KY3Rx+X5vJ1450W?=
 =?us-ascii?Q?WEwaxKuc+C6gKlZiUZkcYXrVss8xcKqR5CtTV4M5ej8EdhhSmAJYlougQbud?=
 =?us-ascii?Q?RidNQDWtSfqVxzTkHExsqQyQdg1N4XNGzpsQEMb7qVoOBBfzjPJbTwyFzvA+?=
 =?us-ascii?Q?bmBxQV1FQDmgPyD3ZzRWXmht62w+u3nQCH7nBH0NSRUOTZSW3D5tGyvTiIOA?=
 =?us-ascii?Q?LEAhF87FCO+M2VBxDmZQEmWKNmd3kO6/DwB0nkwOg0SC0GLz94fRc/lHdeVX?=
 =?us-ascii?Q?4O6pMyXMSJ8PYYjKlCDjeY1QHytKvD8ol8NRO4iiVJ4wENoGkXzZppX/3p9e?=
 =?us-ascii?Q?C7R5UUc=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?RL6yRYF6O+qBEyJi2Oox0sDfNeFga5mSK3mIa1IDtGhBNYlUHef/H7oRTWIM?=
 =?us-ascii?Q?GAjPKu0DUI3Dyhj0XeQgFNglekE3ydqfzZQGasC9A0lH9eH+6jUHafiB5Pe9?=
 =?us-ascii?Q?kGnqF8z0c9bK3o3WoqfEHyru+wkBcWXuMw42xlTXL3b/Lwrxv8JVVeZbaKmi?=
 =?us-ascii?Q?NjFQLDbHkqDouOErMd+a7kkRL/osmeG3IMuv3jyWFlwHOxO8CuRQfiVVmSAR?=
 =?us-ascii?Q?o3w6fbzCu9lKRXkLWODIdyZh80T7q1WQRTSLXVOR5w+a5FogQOI/TTh6Pcyi?=
 =?us-ascii?Q?IfMO3o+2PYEQneQdHJ3yxioynb69H/2kjyH6UCTUnJ6zo7wxAiiG2kNc+eeO?=
 =?us-ascii?Q?UAPfBI61nGrKv9NTJFuq6v1tmvjiWDIlIcbsNOtrhJGo3HXWcp9PApu3mMTi?=
 =?us-ascii?Q?85MKCbHsk0iYYwaOyiGfdVPwxt7oB4BvvTleCFFJE4fWKyM69l40T6WohyNu?=
 =?us-ascii?Q?/Iuf0bEJsTnnelbm3dMsm7WMS7S9NWSpW/gWPE98q2SCCVtReXdHy08+3nil?=
 =?us-ascii?Q?IoFLXoQkpkuiJh2o6yUlVkSfx8Yg9+oaSLE1TWd6Lc+HYN4J/DQd7akzi6KO?=
 =?us-ascii?Q?2IF2fWIyLXZoTnyTGSLdGZMWxmiARZH2mBT17dcL7ihAuvsgRpODRcaTGBHk?=
 =?us-ascii?Q?FPSkCjFtLUdYbRUc9IBYc3l9i3ftcoTpbgS7PdG7Ws6xDUN07Re5Ml2WRDRx?=
 =?us-ascii?Q?qD2ZNRJEizwvjAiBmKENf9j7QTAOlL14qlJ6I3qSgXjikuRGhjvZtIUxlX3N?=
 =?us-ascii?Q?RCvkWtUbqy9nY0dS8cf4nht9w1h48kd40WliFw2UmxTqJ4eCHFEcA7D/H/EQ?=
 =?us-ascii?Q?7uQ5NNZQmEgb+QUdTYEXv35M2bRASwFXLwSRYBuSZ+3sIeKW6uDkCFhm/UqI?=
 =?us-ascii?Q?Bz6d71YlDU1tMgvYn/vIvBXyhmuZBVZo7TfKS743g2UfyNI/IlBHmGZI+TQp?=
 =?us-ascii?Q?jNqCjokItpFi10obbrpqp+gzjWQz46T8Pj0Y3DoyFHjz5Lrq9k1RK/nodbLg?=
 =?us-ascii?Q?ba5vGyurgHtY+8jkj9ImAbMqOiwrXYL8BzM1YJMxs4CMPIUEjeGJbmuPBe3D?=
 =?us-ascii?Q?92F7L7m50ecs0gGoxWCa8raNNEUNc7fs1/HtWnck1eusZqy2xd2FrswBeMYk?=
 =?us-ascii?Q?jvMjlPcrC+tXHNV9jHYXR0Q0K8bHGn0GRrGi+REJwtU5tAeWhvhBJd4OEb0j?=
 =?us-ascii?Q?Af5pqPnnhBRY8aDFvkK99JgXke/b+w+uoKES6CqfXJSTeXgBzXYgwBHMfJaZ?=
 =?us-ascii?Q?p4PzSCtCEuWfDn66bOyZ10nZIy123yM6oGJYYEM6mcF5OJewwCiu3LymwVHZ?=
 =?us-ascii?Q?LPdNd1iSb0WgQNXnouUuAuZu0YaeOJUNqsSJqVuao0DX1KlFn0CF3rg0Pf0y?=
 =?us-ascii?Q?SKDcxRub8g7KMFx7GUF5qw7o6zorADea7wk2J27T3p/665q4f/Wv0aqJL39e?=
 =?us-ascii?Q?r2JYQc7rmowdptTTsHs3xuOJORzjkBAEJAjCagnHPsf+2yFLX5Jqik6XKf1Q?=
 =?us-ascii?Q?O85+oM+ugJTIFBNrWVY96T4vLwYUHdNbQ1SahUeiwa61Klao7k5Xme1za4JT?=
 =?us-ascii?Q?prU2tvcunVf/heU7qhcGC9NI2icUA35uudUFk/DiQ8B3tfpA/iazrXwQstZp?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	teLK+IZRo8KTFXeimExTqs5v5Qh+xK6VoESFpiZ22k0p+s4B9xnqsNyNT3xzMi5l/tjQ/ri42o/2BRJw0wqJEMQUVsv1TwmENxxaXYqaZY1vatvVdc2/vRm2C0DUU33dB0ZT83ErkZTRc7uY7t5pyQKmevZsXG/kuBDT1Awxixsi6oXMXgZAHC/jUgWzHbWuUso/CZsSDsGBmoXtXBF+MgSXbxL3aROuJmGRy7NWieH0RpZWvcJox+yDfHhT22VRLSgzLt260nIppYhEWXyU0zay2qeyRhAz5agEUu+gYT3evCU+4ghoTcOQMPZHEiPI96YPQRq5P3XZ2v4Nfx8NqXs1lRaOF5LBm01GXNraPGyz0Xrc9g93Uy/CbRVIh/pkbhQj8X9FiaS4m/hRU1ajUfVdJLDLjvkGz9eG3WRO9ySSkCqbFS7sz/gtkiE6CPQO4ENd937mJDPxJ6M7tpVr2u7o3+YvnarFye+1esliV61J0n2nxbS3VhgKm5o07mQ/gfe2QD2PThH0dYjMG++SN3GB6t1sZ/8Wn0pujHyEikNSWELLSOEBjbpuMh5i96Aem0OpW4B09fA44JckdJ9PcJ1HBKszFHLPRZmuaUNR5d0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 327340ad-2578-4670-26f1-08dc893a3a8d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 10:43:56.4028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPjDJFY6fKO/kVjvju266VHeqxxCTppwBNf80uBfh+znxx+ajV+BtNUpwJK+BWzHYIjb+EwSmEpxjmlGlupfzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100081
X-Proofpoint-ORIG-GUID: iPsZLLU9F9r-Pjjtoe1J9zvg5zuBshN_
X-Proofpoint-GUID: iPsZLLU9F9r-Pjjtoe1J9zvg5zuBshN_

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

Extend statx system call to return additional info for atomic write support
support for a file.

Helper function generic_fill_statx_atomic_writes() can be used by FSes to
fill in the relevant statx fields. For now atomic_write_segments_max will
always be 1, otherwise some rules would need to be imposed on iovec length
and alignment, which we don't want now.

Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
jpg: relocate bdev support to another patch
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


