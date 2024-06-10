Return-Path: <io-uring+bounces-2157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53DDD901FE2
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 12:51:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B032A281594
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 10:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E50FC01;
	Mon, 10 Jun 2024 10:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k7O73Ud5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ya3EEuRy"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E5C74050;
	Mon, 10 Jun 2024 10:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016350; cv=fail; b=E/ehiFgCAH08o9cQ5ELjF+0OQVF1SFtmpiPqc4AqzXwrJ+p9MIzxfNlsnACwneIaVv15CXCv9qnLNJ1PsU4Kg6kVox2VhYv3kgf4sMqqLzogC5WnIURkJVC1/rsZyBH7tNDzF9MmdOyeow7fOia5IOgdUJTx1GLRxsT62k+BTMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016350; c=relaxed/simple;
	bh=oAIBUPpDmv4JGETOqU/J3N8jaTg97+qKD8BZM4pEZdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iqksWifKzLEvSL2yk+Voo6mKVYf9R31J14B/obABx5GYQN9t7azH/g8YntYhF+y5d7ZS6gzE4Qw/fnQmZKb56es9GYwaUq2+QyKaHMVpDqueQli/C8D4cvGgvYqsp9Q9XfwX5+jw0HQpvbpNtHgSVgvT2fOtMt9mBV0YErLnjMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k7O73Ud5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ya3EEuRy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4Bqiq025709;
	Mon, 10 Jun 2024 10:44:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=uHVeKuD2AEcCqZ/LjV+OOc1QBnsCnYX2OlH3aXiQ9Bc=; b=
	k7O73Ud5D5UymaRohv7hH33qchVmM6XMbJwRMW6Yp3Si1VaRpOEY47GkLuPkar6N
	Ku/btK31DN8kvCh0833FcwSvxvfIb4dhjYY8BDl2bMZrb9qtoplXUuVV24Ql9vzF
	2jq9zcSJpDyExLihNY0VoU1r9CtrFQ/gcRiNA2PfcX8pjY8XKVyFqCriMltOgZl4
	fwJg0cEEnNcuplWcNpyFGg4ReuLgAIx8YBHnoPL2BUGm9JYAv1TDTlxNz5HBE52R
	O3k3TXf4OWaIGv1WqThyDIv8ctTxI0ADyk1y2yhci2EQ3M0gLkSVFEsqghdT0mDY
	n1mm0I3FV+DpqJkrfTF9RQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1gaagk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:44:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45A9uGuT036740;
	Mon, 10 Jun 2024 10:44:01 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdukche-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:44:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/NtkekJVgygCkHqp4AWHbhg6w5dulguFIgxuxhDTheNkkiXqbgk1sD6QBBcH7eMcyAiLweQUd7Hor22P5b2B3AP5ggxIYQ/T22qMFR2i4zzzAYjrmCO8nOVNZByMUfyKjT//aJJk8qNEPd3yAN0/Pd2LtaeJ9KLDtZJVN6DVEi1wgPIozMpc8y3KH6ezhfKy2QBiZiJhEmkDXzT2aNBb1dmehbBvpcjkDk7MieYLwgZ6b5adiDvgXjbat0TRK1Bct81GuA8xVdHyya7fzuuJpMStZKmSiqx3MShbGVe96m3o/3zMJfh5WUUky2Y42ccOnRa9nRYg0Zu5bwR2a4q8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHVeKuD2AEcCqZ/LjV+OOc1QBnsCnYX2OlH3aXiQ9Bc=;
 b=YldVa0ymUWbbeKxGOlEZJ44eKlW3hoYIuA/U/CQ1bBE/jwsZKUrCn5scpMst4DCLrzH/uJuzbUocIXx2Gu5kq0NH3B2n/ddqQEoahwwwfpY0RrTSu65Yffc3WwY5gxEGlB+6fEpbznhOnmYO2FV8nzEfsHvyF+pmaLf/pOf2vDEhrSag/MjrpPa6C6kIEkGViHd3eeIfNLN1SrFPntgmmI4qczf2B2m1/hrozre1TgNkjTd6x8m0FSG7NpPhjve79edj4gCBDbqxiwvvfyQyAOScWe8psPI6lnAS2vMlyizg2OHtzPMqP+0Bsv21WaPB78z+Y+x6w0+SFLcrqnklGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHVeKuD2AEcCqZ/LjV+OOc1QBnsCnYX2OlH3aXiQ9Bc=;
 b=ya3EEuRyK43c0v1NocjcOPGjb3Ppsr9iihjwKjL/CLNe5r7XZLSRJrDQhRNyy/5nP/7xcSwJG3qypcPY94A/t1NbGJ411IWcVJupAEk/8FvmSHdABlEK1yru9hCYLAiiDFIuaFdUFRqmUsVxyVAjgvXKUz+ZTjrBGLy/LW5DD6I=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Mon, 10 Jun
 2024 10:43:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:43:58 +0000
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
        John Garry <john.g.garry@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v8 05/10] block: Add core atomic write support
Date: Mon, 10 Jun 2024 10:43:24 +0000
Message-Id: <20240610104329.3555488-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610104329.3555488-1-john.g.garry@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0260.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: bd5ef50e-30ad-4032-b292-08dc893a3b7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?TZvYyjQSHEgxC51mVeIgYTJ/YAeXuoPjNbK6Q4X6hZfC9fufQIJS+w3afkRT?=
 =?us-ascii?Q?CdClxAVBVwTLNVj0Fg0tpWuIGzIexUVyTsovXr75dC0/1XedpzZEGpEmFsvN?=
 =?us-ascii?Q?SWnSnRt1HT5p/r9r3uNyofsyS7X4jVXZxFaS+gfGQBZtVsg7iXy8GtcGYgio?=
 =?us-ascii?Q?OcGHxV7SLh3JopJH2ri/kTFqNEWL8HfAoKL0YzThJPdT5LfXrQFrgAB0pN/V?=
 =?us-ascii?Q?3pF6OvevBNG/SrlKbiM6YdSY2n3U1Ul/+f2wfTauibo53VilvQcWqFq1NNbV?=
 =?us-ascii?Q?2Yu2PC1dY843OLhVjhzo87JHfdrHtNo4wzqlZqY9YiPf4q3SuIYSQj6gt0zy?=
 =?us-ascii?Q?kS8Puh7QIEOzqqmD6zkZI/E8OCv4C/lNobifAE75x2IqlkTg1c66K3qbfLQu?=
 =?us-ascii?Q?trHeV5h4JU5XP8xtJjmOGGemTbwPcFHMNljs6jBEy2RfuMQBy8LxAHxPaROi?=
 =?us-ascii?Q?rjLjZJTq1daOLtj+9sfk5I3JLnv3kybzyZT2xVntDa48yyBh7hICE6WCOtCI?=
 =?us-ascii?Q?cfGgFev7cfKBf8COZahJW8lRuMOCv1CJk1XOh9fX4qh4ddi99DKcfnbUXpw5?=
 =?us-ascii?Q?r8tepUfTh+nvDFJwEASYifmnLMKfozRuBTPCeQF5Cx9uDQw5ahaurhJO75NZ?=
 =?us-ascii?Q?3rrpapU5CT6kX+NDplD7GNfFiT3coocFBL4bewa65NOnVApzcu30wguv3ZuG?=
 =?us-ascii?Q?ww3SmvjH/PMhfHsqB3GxkymmnPgOlJckN3s0p77XGdlf/5xcH05GxEo4dPtO?=
 =?us-ascii?Q?gXUJNj+dbTL/k6gg8sbMYW2yZpneqrtYcw5Hu/0Cmyt7up3UD+mWPPUPLRZr?=
 =?us-ascii?Q?Ir2tvUjN2VNb5QPPDUwJ/Hz3IkKEF4uzot5MkvuMzL4wR76qTRYwsiyacI8U?=
 =?us-ascii?Q?q1x/pI9GNu2wXkCGMf27IYD0Nf31k9iAzdNBPNWy+ObcxgOdsuekJnIrFxw6?=
 =?us-ascii?Q?05dGeF6RgbUsUcN+toK05cIa6tjF46UIyfQPj9onjyG0YN5DbNRigB1BF/6O?=
 =?us-ascii?Q?kZPvSYWjrO10N00OXVIgHVgKCeUvzeBc/LKxmUFwy/TJpf23/0+LODd9oCM5?=
 =?us-ascii?Q?eJsLCRgsWiIj+4DI26qChWQ87e4um2MWj+l/OmaZwr7ZDZgMeKEbXVxu+2GJ?=
 =?us-ascii?Q?o7uF0ie2IQL/IqMYNRMMmr+V4C6Ev79L2f5rzgMaVs1wQ40YsnVfTqDootww?=
 =?us-ascii?Q?4q9K+IC+vMdWQ6NoriAHVNvaSzH7AESA6WmXwMVAWKflZVdgx8gy4k/WkWO7?=
 =?us-ascii?Q?ZFEDxou3NQZDNAydg+nkRzbc8tyQri8dXxGFY7KOc13DfRjW1mJOWhYKmOAd?=
 =?us-ascii?Q?Shps4KZXo9jT9zx6cO57INYiYy6V9NZ4NQO1xlBgjKwAZ0XW72HFiPIhdcAe?=
 =?us-ascii?Q?hn7+7mk=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YJSry7v0xGVqisuwbI48iSbswyMs77XSdr+B9ysLEjImSOKxHYYdrx6+2XCK?=
 =?us-ascii?Q?JoXEHmKGWnqgnIhYejuVSU8GT3wrUfMZEa86LzrYbSo+59Wjufjo3P3DkHxh?=
 =?us-ascii?Q?x93qeAGwlZaYyFiUHMtH/G1s2rJO+ZAuXXMtjwDZpuMr2xey/hVuDT6+T5ds?=
 =?us-ascii?Q?Brfmj/M6itKlzGXmIK1wJhaGxqi7JcUMaEYDnttyz3zJqDBCNGf+p/sUYSJY?=
 =?us-ascii?Q?cg4LW7muim2e8OqXDEUJtvUgI9nrcFHVgpwD+ocnhQ2j7CMXPFZiouOPqo62?=
 =?us-ascii?Q?G212u4Mjeai/pxLUtdQGD8Mu6zYk1n94YY79u60MdwOjn7WMQvrHmorRIZfo?=
 =?us-ascii?Q?mFarZxIC/Yl0ar8aeM9REnQeSYxjwoq7BUx0WXQ62fSRt1RBJGS8sQosMoki?=
 =?us-ascii?Q?Su3eMENV2Xpu1ncYxAX8akAYxNglb2J+vE3pXz2PYIorKUa57nj+ti1LKQvZ?=
 =?us-ascii?Q?C3iFw0IyCID+9M5w+amqRpTGg0Uf8Rt3zERbjr1Fq40E9M+6tneV12VGxEFG?=
 =?us-ascii?Q?bpLNGqhpfpw13nIqrkWf0i4FERN78zoyJE03iWGH0H65jlXItRlJ23Su2Auk?=
 =?us-ascii?Q?CHJK/hCu3Foro0uqzczgT9zl3KMHNZfKcATDHtBOz2+lhor9DE8lqFiNlGNf?=
 =?us-ascii?Q?lZxGfJbq3bhaJHbc51ZW8ta7eBowDMDYt/tZht//uOk+oeH4rs610NR+ZZJi?=
 =?us-ascii?Q?No35cVcPO5qRI04uvG+5+L01PX91DqrohTMofiNkY4QrV3gLbos0o+27/6c9?=
 =?us-ascii?Q?g2K0yMHpH3nivFvtFcbL7LzUF34xpZiFRHSc7JBWL9BdoVu3szwVm+ao36pf?=
 =?us-ascii?Q?uYw6S1lq/0yNBHObRL1TpkGChOyUBFvjYdKpYLmfOJhaRqidLZmb5rIaI6I+?=
 =?us-ascii?Q?Rz6UfqlCIhQNt8Y7icTAVEB3lgJ1aVjEuU3XgwQuLHnGlrygtl/Z9JTxybyk?=
 =?us-ascii?Q?NNu2vNV4uRaNr+/CJ1tEskDYIebIu4Hdz/7F1I+OZ9mW8ylh5YNJ7xgyqa5g?=
 =?us-ascii?Q?KgnRZFwYM99jwZHsy2jpDQUnmkCeA/6veeKr4nlWZANswe+kbA2pfsIWvMPO?=
 =?us-ascii?Q?oxaiQ7IeorZRw/tD+YLtfb0zwaaZgHBSmWBT+ZvnMofVZ9TZ95w9SWUcsmiP?=
 =?us-ascii?Q?TzgFq7R9HADiRaYn/Nw0Yl43qDznv/8Nm8oDqDds5bpmvffFbsgeEEs4etYf?=
 =?us-ascii?Q?6TTiWBNV+BB8WoCnvin4C+xCKiL4vokzsfKSg+6x6hberYcwevyCkhdiVLA9?=
 =?us-ascii?Q?ackGn4COkI/Lou5/UTMNquIBaLg9e68SKP7uEZKPnlheDKBawxoQ0dR5iAL9?=
 =?us-ascii?Q?JXxGdCPvS4llKd4ZenRskv6GdWH+mnTJee9t3RY5xKkwYBYC1rqtMofBLnla?=
 =?us-ascii?Q?6tnmpzqVu9hqb0Qxo5CzSsrG5tIxjg237/g5gTTozv34AyOW+g24lfb7vGuq?=
 =?us-ascii?Q?qji+H0q7shTti995y4AebsxdHWYtdvMJrkiGI/fgCMRMrlPxhqOd/kON+UJV?=
 =?us-ascii?Q?IID2RZDSedfqUHopKl02io47EWouM9NlaOJYvSO6OJM8LdaGURzzvlzYu//O?=
 =?us-ascii?Q?oeQpmvLVV1RRD/bo6jkhnpdgbC6QEa5PX1FX1HqY4R4nzD88SH8D4u6n4Oe1?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	YgeACnVvN0bf280Haw4oLWtrJUMGmwarO0WxRqbe0i0BGZREoBcbhDUnov8gRyUrwy0sVVoXdazFCam/oBR8N80qxKj+N90/pDGDheEG5hT/fsOdOMZ5muVUl6hRSfMCYTtON5XckOxUY/tvJBwIq/xI9mKnVQxif+dWhoIwix8CV0/bJAjTpuG+xYKTpqPXiXvx3wbmd2EngsN8icPDEdSgSCtt1b9+Jfn4G8dATucRQsN6+wKW2aZb4XYbrMzHzFwy7BqMvPu7zh/2WvoOzGdVMzQRlnTzK94NtskRa27oi7C9/dtdF5DfD4mXgZlNG3d6Wcgac77j81a9tXb65wDfvkDovSx7NJKWSofiAXoxmTENDp6MkumKnv7b/WS5hkBDCeARwRhSNITKXVZ1URuLHp/q5VV4rn6LQKTRKVTsZOLcADAEbH7B48NapRfj+zAGiURbX/DhbuwP+Grv21aeSF0hBZJWZSlpa4tUqHKnJywRB/wiqOktpFdgkYFOtlPfiCqIVmyJtu5X6fcCoo92zyja1Vg2XXP8d6PEZ7k4alDw5aOo36gUrmbmD+pG+niBBUkLT4No6Jz+k2aEjoQyxnpv3eerKOXF0Vxc+I0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd5ef50e-30ad-4032-b292-08dc893a3b7d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 10:43:58.0600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P342nQXQ8gY425pPQDfGV0B6cl6l5fX7e+CbGWlEnuv1uCGrlvBn9GN3ShsMNA75RFkiEEGLYWjZsgCZ5ZevcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406100081
X-Proofpoint-ORIG-GUID: JFo0uzMO69HIN5WjqhJRck976ags3LPo
X-Proofpoint-GUID: JFo0uzMO69HIN5WjqhJRck976ags3LPo

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
 Documentation/ABI/stable/sysfs-block | 53 ++++++++++++++++++++
 block/blk-core.c                     | 19 +++++++
 block/blk-merge.c                    | 50 +++++++++++++++++--
 block/blk-settings.c                 | 75 ++++++++++++++++++++++++++++
 block/blk-sysfs.c                    | 33 ++++++++++++
 block/blk.h                          |  3 ++
 include/linux/blk_types.h            |  8 ++-
 include/linux/blkdev.h               | 55 ++++++++++++++++++++
 8 files changed, 291 insertions(+), 5 deletions(-)

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
index 68969e27c831..b158d31940d1 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -154,8 +154,16 @@ static struct bio *bio_split_write_zeroes(struct bio *bio,
 	return bio_split(bio, lim->max_write_zeroes_sectors, GFP_NOIO, bs);
 }
 
-static inline unsigned int blk_boundary_sectors(const struct queue_limits *lim)
+static inline unsigned int blk_boundary_sectors(const struct queue_limits *lim,
+						bool is_atomic)
 {
+	/*
+	 * If chunk_sectors and atomic_write_boundary_sectors are both set,
+	 * then they must be equal.
+	 */
+	if (is_atomic)
+		return lim->atomic_write_boundary_sectors;
+
 	return lim->chunk_sectors;
 }
 
@@ -172,8 +180,18 @@ static inline unsigned get_max_io_size(struct bio *bio,
 {
 	unsigned pbs = lim->physical_block_size >> SECTOR_SHIFT;
 	unsigned lbs = lim->logical_block_size >> SECTOR_SHIFT;
-	unsigned boundary_sectors = blk_boundary_sectors(lim);
-	unsigned max_sectors = lim->max_sectors, start, end;
+	bool is_atomic = bio->bi_opf & REQ_ATOMIC;
+	unsigned boundary_sectors = blk_boundary_sectors(lim, is_atomic);
+	unsigned max_sectors, start, end;
+
+	/*
+	 * We ignore lim->max_sectors for atomic writes because it may less
+	 * than the actual bio size, which we cannot tolerate.
+	 */
+	if (is_atomic)
+		max_sectors = lim->atomic_write_max_sectors;
+	else
+		max_sectors = lim->max_sectors;
 
 	if (boundary_sectors) {
 		max_sectors = min(max_sectors,
@@ -311,6 +329,11 @@ struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
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
@@ -596,11 +619,12 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 	struct request_queue *q = rq->q;
 	struct queue_limits *lim = &q->limits;
 	unsigned int max_sectors, boundary_sectors;
+	bool is_atomic = rq->cmd_flags & REQ_ATOMIC;
 
 	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
-	boundary_sectors = blk_boundary_sectors(lim);
+	boundary_sectors = blk_boundary_sectors(lim, is_atomic);
 	max_sectors = blk_queue_get_max_sectors(rq);
 
 	if (!boundary_sectors ||
@@ -806,6 +830,18 @@ static enum elv_merge blk_try_req_merge(struct request *req,
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
@@ -829,6 +865,9 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req->ioprio != next->ioprio)
 		return NULL;
 
+	if (!blk_atomic_write_mergeable_rqs(req, next))
+		return NULL;
+
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
@@ -960,6 +999,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (rq->ioprio != bio_prio(bio))
 		return false;
 
+	if (blk_atomic_write_mergeable_rq_bio(rq, bio) == false)
+		return false;
+
 	return true;
 }
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 996f247fc98e..140e13616462 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -97,6 +97,79 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
 	return 0;
 }
 
+/*
+ * Returns max guaranteed bytes which we can fit in a bio.
+ *
+ * We request that an atomic_write is ITER_UBUF iov_iter (so a single vector),
+ * so we assume that we can fit in at least PAGE_SIZE in a segment, apart from
+ * the first and last segments.
+ */
+static
+unsigned int blk_queue_max_guaranteed_bio(struct queue_limits *lim)
+{
+	unsigned int max_segments = min(BIO_MAX_VECS, lim->max_segments);
+	unsigned int length;
+
+	length = min(max_segments, 2) * lim->logical_block_size;
+	if (max_segments > 2)
+		length += (max_segments - 2) * PAGE_SIZE;
+
+	return length;
+}
+
+static void blk_atomic_writes_update_limits(struct queue_limits *lim)
+{
+	unsigned int unit_limit = min(lim->max_hw_sectors << SECTOR_SHIFT,
+					blk_queue_max_guaranteed_bio(lim));
+
+	unit_limit = rounddown_pow_of_two(unit_limit);
+
+	lim->atomic_write_max_sectors =
+		min(lim->atomic_write_hw_max >> SECTOR_SHIFT,
+			lim->max_hw_sectors);
+	lim->atomic_write_unit_min =
+		min(lim->atomic_write_hw_unit_min, unit_limit);
+	lim->atomic_write_unit_max =
+		min(lim->atomic_write_hw_unit_max, unit_limit);
+	lim->atomic_write_boundary_sectors =
+		lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
+}
+
+static void blk_validate_atomic_write_limits(struct queue_limits *lim)
+{
+	unsigned int boundary_sectors_hw;
+
+	if (!lim->atomic_write_hw_max)
+		goto unsupported;
+
+	boundary_sectors_hw = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
+
+	if (boundary_sectors_hw) {
+		/* It doesn't make sense to allow different non-zero values */
+		if (lim->chunk_sectors &&
+		    lim->chunk_sectors != boundary_sectors_hw)
+			goto unsupported;
+
+		/* The boundary size just needs to be a multiple of unit_max
+		 * (and not necessarily a power-of-2), so this following check
+		 * could be relaxed in future.
+		 * Furthermore, if needed, unit_max could be reduced so that
+		 * it is compliant with a !power-of-2 boundary.
+		 */
+		if (!is_power_of_2(lim->atomic_write_hw_boundary))
+			goto unsupported;
+	}
+
+	blk_atomic_writes_update_limits(lim);
+	return;
+
+unsupported:
+	lim->atomic_write_max_sectors = 0;
+	lim->atomic_write_boundary_sectors = 0;
+	lim->atomic_write_unit_min = 0;
+	lim->atomic_write_unit_max = 0;
+}
+
 /*
  * Check that the limits in lim are valid, initialize defaults for unset
  * values, and cap values based on others where needed.
@@ -230,6 +303,8 @@ static int blk_validate_limits(struct queue_limits *lim)
 		lim->misaligned = 0;
 	}
 
+	blk_validate_atomic_write_limits(lim);
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
index ddff90766f9f..930debeba3f0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -310,6 +310,16 @@ struct queue_limits {
 	unsigned int		discard_alignment;
 	unsigned int		zone_write_granularity;
 
+	/* atomic write limits */
+	unsigned int		atomic_write_hw_max;
+	unsigned int		atomic_write_max_sectors;
+	unsigned int		atomic_write_hw_boundary;
+	unsigned int		atomic_write_boundary_sectors;
+	unsigned int		atomic_write_hw_unit_min;
+	unsigned int		atomic_write_unit_min;
+	unsigned int		atomic_write_hw_unit_max;
+	unsigned int		atomic_write_unit_max;
+
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
@@ -1355,6 +1365,30 @@ static inline int queue_dma_alignment(const struct request_queue *q)
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
+	return q->limits.atomic_write_boundary_sectors << SECTOR_SHIFT;
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
@@ -1596,6 +1630,27 @@ struct io_comp_batch {
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


