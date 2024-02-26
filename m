Return-Path: <io-uring+bounces-743-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58458867EB9
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 18:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D63641F2771E
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 17:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B17612D761;
	Mon, 26 Feb 2024 17:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UZtnyt0Z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w7clI7gB"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8800C605A1;
	Mon, 26 Feb 2024 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969048; cv=fail; b=tQ8sonoA4b+WhnpwncgyO8xJ112MVXSEOphYn7/nt+R7UOAPkqQk47O965kKRE812mc22sHyvMRd5HoqqUXes2boyyqI586AEALW4WLgiblKLIqpTsfpdDZp5UUGT+BFszU++/DSZSrBm1Q+ek7NLx55odQEVkAw5oHhXrOODEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969048; c=relaxed/simple;
	bh=J7SZLmJmdKN0tMpMfOS+5xdLKuDvGLQyXizCexx4Js4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aNhuM7sldnEO0mslo47LQs87xSyZP30bVL+D0uIfVri4iH/dBjjHjm4FaxIEWvvmROxlYKv3IIgRbmSn6JDQ4r+IkrZg+Qu3tEN4PDCzCWrwuLiX6eUEtdZQIbm9MEDiZ9FM+bRtkPDv1GStmNF4kk2xQQ1dmuqMG2DnNOM/vNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UZtnyt0Z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w7clI7gB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QGnG8Q018456;
	Mon, 26 Feb 2024 17:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=esWc5rIYrO2nyco4iv76jP73u1y8V7yGOLl+U5JSHKE=;
 b=UZtnyt0ZsNlB6FLjObVcyfkgDjm2i3vedXRlmfXlbkViDSkv3MuMXAQ4Tslv3EZ/EviO
 WCONM40yJIKRtnuWWkEdexqcOrMjoF7OdK3Y7s3vAc6Kb8NOIpAbVSTFw8PBF0y8RLss
 lcfKm/zJhB+tZUdR9WU03lXHallZarTMCyAh20EPmNVTQ6Z9iSVJk7hiT8NidbjpCBp1
 MRTczp4luepJh5STzS7Dm55MVgB+PyMrNZO7ZGg9ZXG7LlmuYcxeFHW7UfNV/oHf+4Wr
 KLXfUVCchih+b9358MV3PDXEeHa3/v5OFwmePpvT256PrlrCNDTSat1RBgp58ZZJazW/ Ew== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8bb52eh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41QHKcHQ009796;
	Mon, 26 Feb 2024 17:36:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w5w9vd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSceUVbjtvPuudEu5wMVC11+A3kk9VMi7FT8PsHTnC0+uUnjzjOFLUrJO6r/x+UGV4h3bBGq8LiK/0OO/pjWAWciUtCIRvTxMBVhJGETT7ypmxYMBz+6ZhXBxyLq/yfnV9TL1dLPXKKiLSinFarWVGLLEVVlxgbBMPc9uLBJOoDIP9NmNXBf7e1Z0fqAmSi6TdOABmftC2SmfBBBWCOMxCqiox57M9RosDoKm+7uMC+r6ulxFdjFqTUiI866r5RLiMi9z5rYwNwe4cGGDmuP5lXE/prD/QBP5c0dKBYU/H8L37xjC9aLsZM4BrTtsb7Lc4ultiFfyzoaXv7TX7IabQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esWc5rIYrO2nyco4iv76jP73u1y8V7yGOLl+U5JSHKE=;
 b=lbEnh1prXDjYxBtZz+C+42M9qRIyaVMn77SQfYXtVAESatU21AvUhpDWyneamUpbz3FGtAhyEkmFI9sMk7uo+OIbIN3smCSYKnOVeqFsOEqbEXjB+ItLaGeGcVIMelkiOR+afXvDu/lCfj3bwmLeIQ/mD9sT9os79hdSuhBmiWlxCfSVNe4LRDS7kpXdigZDY65qCpRbHvhLL3PntCEI3uAAK+ZUbTT9/LmOkiAvW8aWUZW5IbFQ3ah5b0lIejCqUS2EAu1xkB+8aBBMpHsLpZ+DK1ShQCT6I45SJCk1XbrKcErl145/XZj25Ub7WejpRK8jEX+GSu/0W4wUpCymMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esWc5rIYrO2nyco4iv76jP73u1y8V7yGOLl+U5JSHKE=;
 b=w7clI7gBxL9DPvl1NscA2lV47vmPKaJQccUgL+oxsi1yS4VjAG6HkEhV+auBdlWHI7I5dYZKtuexY8w2Q+2yLIxyqQem6ts8i1iwuLJ+uZP6bmdIr9qfH7iU9H6PxBu5MYXTaH/K6h9BhOVBRLA6vKbt5DOEFMFcAzS3XpZemi4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6298.namprd10.prod.outlook.com (2603:10b6:303:1e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 17:36:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:36:40 +0000
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
Subject: [PATCH v5 01/10] block: Pass blk_queue_get_max_sectors() a request pointer
Date: Mon, 26 Feb 2024 17:36:03 +0000
Message-Id: <20240226173612.1478858-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240226173612.1478858-1-john.g.garry@oracle.com>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0027.namprd17.prod.outlook.com
 (2603:10b6:510:323::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: c0eef075-3715-4590-ab69-08dc36f17d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	CozwIOgmiEzMJIMi01eZLh0n2ZOABrsgKihXgDJ5KcFXsa8hWeXgQlgHvg6PhxALCj/i0H1OpjhKJFPVG7o+uXy7Y5/wXhQ4UArisQCXhFCku1DbdHfmLrmxatGp/Ns9VzP4lqzPJ3YG7NEwxKwsqZSoPUYYHgMNkpe308Dvpr0fT1f9wYvaOmtrZfJOl6Tl7DZ9fOgGmb/ANJww5hYMKIk8Yw/rOoKbvvxJIBysdsA707eetCoSndmzKt9JxVHsFOQZz15tR0bkNb6mCnkDPY5hbEkou8/CtduwQ84RZa4j7mV4gNoen4y0CcP4hc0Orn/ZewsbT0GJCCUi4mI4eiapnpmpQMZy+DvIcxuj5sTi1WjzmJOxImWhbLiMFJTvjJyLyEJbsD4nLGKJDrlyUM86/bD9/9mv5zPG6QR1hxatBxV0yTlr2p74Pq7TTFuwrM94HTfdYJm/CRbvclpLXbRKd8qAKYaULWD9oQ3oPk6jnPS+1BsgOuJ1OjYMk5VOPyTGgw34pUVwTWyumnKSrbHI+dL5eneTTcNB5/M/uZ8dzGyr0LadPy33yUxKnuK1uch37IANde0Tz3lB/RErRymN7EYgqORC52NW9Hh69D6eF7IvyJ0w1Z0If1nHIE+woowNXMRA5MsjrzPeKcAWsGWRR9AT5xBuwNrj8WTIhTzRNBSTB9MXJcVuPAErLA8FdKqtduNhAjKAMLT+puGVyQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?t25WHCaYTM775YFfzdRSUwpvC+UUbjpI67aEF5SOZCqOGJMjoAvNQmP9pp3r?=
 =?us-ascii?Q?YwTHCn30By9L5DDfE6rAbiFQMrc7kwqY6bcUbHlscHO4H03yjRhu09kN/32O?=
 =?us-ascii?Q?BA5epO5QKnPc4s3Gg+ZVxZ5iyx5KXUwJeIt2PP9MzjR5QwzA/o2IMCtfEncd?=
 =?us-ascii?Q?kHjH8fBE3mg3bdcyybs5qNEmJVVsqaN89SN1KbqOWgLOkQvqqTKgqfCwsHIv?=
 =?us-ascii?Q?jpbMoXfyY4z8pTRjRbHfWRM5LIDgp6Uo1EQF23uQGlLkQibpBQkBIcRYK5AW?=
 =?us-ascii?Q?hp4wCrubfdxyYYnVjF5BryooGG6+qZ0JS4q2VSBlKWzjO33iGjlWi5I/2R3v?=
 =?us-ascii?Q?ihNoFWlBwDIyYHZEIWrigUXPVilig3P9Mbqe80ls1jSueOAesIO9utnJoCpO?=
 =?us-ascii?Q?hWrcJief8fSC4tIHme4th6pxdxSuPaAz5qeqDDZV46t2jc9AURWJehTFl8t6?=
 =?us-ascii?Q?R3BRa8aMEJLaVQumw6kT7+z+jCKJ7kPTVilS1QpCNdMH9VmV2TwdD486KOEc?=
 =?us-ascii?Q?lwez5tF+McJT8VlFlOK4RRxIn2vCBnbsif0iC3cFgSS9ap66OYYwATGmcX4x?=
 =?us-ascii?Q?C5yCe43qXcUI6F/n2ZSHXIe2Yv/Y7cZG3kfBUPsE6a+XHnohqhtL9W5tKaoo?=
 =?us-ascii?Q?jNC4VK16WfeCzvr2S6P25f8K61yowO+tDwyC2GLtP1QngvFN8VO/KCHJupsE?=
 =?us-ascii?Q?lMuVziIIaZkMCx91ehzKF8IKOAjWCOzLSdnuDVe0cq9AWKM8weFCVAgKEOKI?=
 =?us-ascii?Q?r1VwkZ6vL1X0l9GOdlKW+KApcOl+uaBAFoaxyp51HmTotGkzlZSV3z1aBGeb?=
 =?us-ascii?Q?/blyKMYguElkICpu+0djpvRjQ1g0i0xuNIMRe05ZclSIEl1uQk3eQ1CGxwOU?=
 =?us-ascii?Q?TXZSirZlmeIWho3SKKMw2N2LqfQHbUurrJ6QFoV6HPfC8BwLyiO05o4J/fNj?=
 =?us-ascii?Q?qZRBnMqylAhpFUUcK5xcUq3rdgXxhkxpX7uMgxLZ22w6iLzBptBM4uknqTDo?=
 =?us-ascii?Q?xI/+i3oRT0BmgXiBBisF3Kj0JdmLVZyulTAPTMvthdY/FvRue0tGRJnxFYkY?=
 =?us-ascii?Q?bj7OGGr/FNIwaZ8HzI7moFR7pKQRa4YaLwYNgZ7b3wLG0FcqGzLEj+iyIt5b?=
 =?us-ascii?Q?nJstzXUsHpif7FNrpikzV8JCWG8Es/B0uJuICjLXLFtrRjerF/9C9+GQg97p?=
 =?us-ascii?Q?dJyWB+2WNs2tmlymKkk39Y8tkWgr93rHwmsoApnbyJGIwBE2c299IY3/zrML?=
 =?us-ascii?Q?uSzHG58OfENpBClpnhUv2txkmoz3NOrWHNmsbjQmfyRNKMLGipSrgVWQxT8I?=
 =?us-ascii?Q?vuEOx2DcVR6tFjbvcTO7Fb9fsN3kouBDLXteXitDNIVZjDJNtXptLO0RVALb?=
 =?us-ascii?Q?jt6w2WXzed28Vio+X9mu13mdc7fb/mRJszmRx9hF8LDYWWdQD8eYsq1OvzL+?=
 =?us-ascii?Q?iNUQ0VX1M/UTaGGFO47Y0JsEfL56gm0SoOyo5XEHdV2VEsRpWce7gY9DFI1J?=
 =?us-ascii?Q?y7HOSKZjohN+D2w/D7iiJX3uEMlVOt33VG3eJrZO9MkH9sXOzhLQRsyF9Dt5?=
 =?us-ascii?Q?bFkqoKuMwRBLNPfn068m7m1AS7H08VbjIuP0N0sIccKyr4va1MDMHcweTXD8?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3ze0TLp1rAWocLum4RTHbpdKxskPqaSWrHfDqFeRHibV0PWOrEhnQae1x9U+f83FUXmFlpi2xTO+cy3KE5q6qOUpgd7iHMq8AzElKXt6JrmrsbMtCpMcXdj6CXDII8oj0i25m2jII3m3N76q80DXTCzC/4SmLEpMws9RKy6zlcxAOAa955Blk1p0+lwF02o5vByp3/Dwi5HrWqxWTRk1YPTpleK4b8muCPa8FIJdbe/sxTuk5GOyygHqi0Shnprq8OOx+XT5usCtqZZprTGwYqS1eA9ph1rYxEk9T2pykqDOA8c4PSZ6HoHFYNc/HbsqhmjWIyQJttysL1IB0EbrqPCkw3uPcAFZVWwSd4p5U48IY69m7nM5k4xgv1sYnev5nhzVfiJSDFd/Dd9xCukiPQaiWAZ+4jnqKHZ03gpoPu1/mrtH2IV6LooGi5C1yG2LfU0aWPjutC0YSTr3QA7pyirZZENJar402fd6YWk3K5iWCZqTPWeATbKDUAHUKxZoIjcp3+dfI03/IKPXhg4t1v/YEQomOqadc6VKxdmiQdYwP2XqO+6yVNO+qLnd6XNVaNoElPMZpjvUUDXZbpfooJVctrpWwY/wGx4Mm/ranb4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0eef075-3715-4590-ab69-08dc36f17d78
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:36:40.0902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xat9IJIv7kIiPIzDo4YrZkWJLO5Pa2twUylrQPn5WvWDsfdBfrxEdKsB2zi/ufBxB9QG8WcSRyJvwE8JNtIccw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260134
X-Proofpoint-GUID: jO0-6-8HR80ZRamaB4qJbp5W8yiw8rC1
X-Proofpoint-ORIG-GUID: jO0-6-8HR80ZRamaB4qJbp5W8yiw8rC1

Currently blk_queue_get_max_sectors() is passed a enum req_op. In future
the value returned from blk_queue_get_max_sectors() may depend on certain
request flags, so pass a request pointer.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-merge.c | 3 ++-
 block/blk-mq.c    | 2 +-
 block/blk.h       | 6 ++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2d470cf2173e..74e9e775f13d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -592,7 +592,8 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
-	max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	max_sectors = blk_queue_get_max_sectors(rq);
+
 	if (!q->limits.chunk_sectors ||
 	    req_op(rq) == REQ_OP_DISCARD ||
 	    req_op(rq) == REQ_OP_SECURE_ERASE)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2dc01551e27c..0855f75bcad7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3046,7 +3046,7 @@ void blk_mq_submit_bio(struct bio *bio)
 blk_status_t blk_insert_cloned_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
-	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	unsigned int max_sectors = blk_queue_get_max_sectors(rq);
 	unsigned int max_segments = blk_rq_get_max_segments(rq);
 	blk_status_t ret;
 
diff --git a/block/blk.h b/block/blk.h
index 1ef920f72e0f..050696131329 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -166,9 +166,11 @@ static inline unsigned int blk_rq_get_max_segments(struct request *rq)
 	return queue_max_segments(rq->q);
 }
 
-static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
-						     enum req_op op)
+static inline unsigned int blk_queue_get_max_sectors(struct request *rq)
 {
+	struct request_queue *q = rq->q;
+	enum req_op op = req_op(rq);
+
 	if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
 		return min(q->limits.max_discard_sectors,
 			   UINT_MAX >> SECTOR_SHIFT);
-- 
2.31.1


