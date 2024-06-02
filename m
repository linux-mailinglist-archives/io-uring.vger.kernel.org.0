Return-Path: <io-uring+bounces-2069-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 108F48D760B
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 16:13:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBF852826B1
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 14:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C88545C18;
	Sun,  2 Jun 2024 14:13:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9931643ABD;
	Sun,  2 Jun 2024 14:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717337599; cv=fail; b=U5iyvPSE9k1/pBQ8folDb1rt/Bzcw9JvzjAvmDXasyvqASFiWO3pKY4KTHCs9FIE7g951VB0CvIRbsXRmlx6y6pv5eWWC2KlL7bOe9joaLjKR+zhNJOimqzaaj54+fYgDdp+0flIj9MW46qyn0U5lgK4U9sIP6atP9pchTv97zs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717337599; c=relaxed/simple;
	bh=RDPaI8Mm7Evv+2NjYecQJR4Ld60KjlQoP1Xo4lB1pwU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bgLCdQaaikYcJzoUaVaj+UzSwaHn0cHe6SQsAm/nXLXexy1wiCzWz06fTAJtgm3sm9wQzNcX9AeTOYy6RQ27ySRrXJqJkZQPnZGmLj3KB7qNAaraKRmBQaXSX/x9NBwloT+S7BpEVz7NDNfrR7IC2xnD8hb9Afm+M9rNNo0RoFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4526qob6009827;
	Sun, 2 Jun 2024 14:09:45 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DR30iboYRsZtErRzVW2c2yoahgpOhtKzAqY36xbNcHbI=3D;_b?=
 =?UTF-8?Q?=3DOIi98lzxHa/STXHv8igv439WGRKzZur1bJMGAznx9defneYYFUC5tPDzdvuL?=
 =?UTF-8?Q?jJl1Yea3_WrUKRadeJ24svOoVNe4dTc3F5cILR/156uNVuhXJdZIffQJbsbhasF?=
 =?UTF-8?Q?4snDctfxXfYEpp_W0uLIB2clAH3dIbMvsJhxfCtX2ZpZgW+Id7OuIR75j1T7b58?=
 =?UTF-8?Q?zzGj//4qxGmczNbYdyiy_l+9r4GaRKhIKMZqR8XxdZmTzLw8lsfxSrFdyxs4Vfp?=
 =?UTF-8?Q?27Kyqc4rTx4kzwcT0c4Ol3tvcN_V/5wnu84EURG1FSAivSniV2cKr27ZnF0EOy4?=
 =?UTF-8?Q?FARAtP4zUeJ8CPa499cjVI+gfur013LQ_uw=3D=3D_?=
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfuwm1cut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 452CUmeO021076;
	Sun, 2 Jun 2024 14:09:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrt699g4-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUbNUMYvbxSlkLEbUx4lGputKCGE4/SGJDmg8k1GhRK+lGZ03Q8OW83Y1MB96KSHBjvvTef1IJ7G/+wD6UrOdLTuFRvGFa43TJbVZ8ocHTCphD1ZW2k/N9K3dn4mw8XyHmlJ5e1jcUIyTYICBKGRxAR2Wn4uR5vrzv6uPAoRZ3yBXrid8yBRnrt8NkOrVrL6NQ4t6hZl0U/8e9DlavG7M57LGo+pM1wwMadRDOJqVW6Er+gqRdiueRA7Xx1eQb8/qWn+fTCtUwertV6rP2H2aDcmI3SJjU5pStn9vxRBZjkHgUC9hmhW4pORH/jwWPYqgOPRedw/GVNxzmIbURlX/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R30iboYRsZtErRzVW2c2yoahgpOhtKzAqY36xbNcHbI=;
 b=EMe+yhQhETinmIYfUi8EoVnU84S+VpI++gVTYsxaykGTg1QtbsPtshunihOucwOYE+b6unMQfgrEjZKunIHzyxNiCevZKPpAkbyjUYBXhPUsqi7EnQlR5DvbKMa+mxk2CfggpPH5qhhfnfqpe13O9i/qnPPoET5xSycvgjEyldYmdNPsAl6FXwjAlj/hK6WHxYW1SskNRHgVCxRdTkqfdml8LegkcVcGPyzPM/xcNXHSew8//+C23bPQ+1BId1CxCSFz0lk2E4KtKJAivE4ZLd9TAhnGHCiCoecP0gVVTI/zu+nlAr2dOp9PYYWELkz1VpxaINb+zrioNm7nFBvZzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R30iboYRsZtErRzVW2c2yoahgpOhtKzAqY36xbNcHbI=;
 b=p33UpeqNIElEgM75JJfXuDZMiyv11Ghg4ulXSgOnAraDaqJ4kFjJt7l3C7iqa0FCGzZSBOuvDEu/h50XKbrQJUumX+SFNcluaYEsayBScW9iyZS78zE1oUyy0wqiqDef+fopN4/qPSaltg3jSDVQgpiC3l2msNx7m93erV7D5q4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Sun, 2 Jun
 2024 14:09:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Sun, 2 Jun 2024
 14:09:43 +0000
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
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v7 2/9] fs: Initial atomic write support
Date: Sun,  2 Jun 2024 14:09:05 +0000
Message-Id: <20240602140912.970947-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240602140912.970947-1-john.g.garry@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:208:23a::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e2fd56e-1c63-4be1-9087-08dc830da671
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|366007|7416005|1800799015|376005|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?vsLrnrTLEr405bk2L03Fg9Yxp5mpEvQgPQJKmnbocnfOBTPVBmbFO+un8RYc?=
 =?us-ascii?Q?S/G3zs2y4sGsPuEdvzDfRhjqdG30fdMQMqUUeSah5I3p8BYONVbDpQm65tRG?=
 =?us-ascii?Q?un9f4HB36ct0C9b/ayBm3bs9OCgZGKdmBSWlEpE2Lv8SKUk5ZH6jWgmK6XP8?=
 =?us-ascii?Q?diP1J6I+595lMKeJFjXpO2vqiayH0SCCaEWAopUHBwAFvq42nsvozLRscv8h?=
 =?us-ascii?Q?ezC5+J+u5+jlSZTMSfi8YTrkQqFR0LuRgLhsyrzwfFDHY0cjej+qpxyt0Qpz?=
 =?us-ascii?Q?fvA+KtkGAmgP+QjYFGT1INN4sfYq/qM4DfiTJs+MwnbdwWuw+zQAVvBUYlhs?=
 =?us-ascii?Q?+ClFca2nWINHepzELoFeEMaWmDUgyke3jcim1Lg0DpWZVmk8yhTQxETyCHXl?=
 =?us-ascii?Q?7SpjJBk0cJmoBy6sJyOEH3RyjhSp/PWzRfwqAky3GW0I1krgl9uiHzD9ic2i?=
 =?us-ascii?Q?iqpz0MdZVwypJi7U+R1Wi2+PdY5HkcMEe3ynPOo3PZS/N6jJmiPVUS4DSFHj?=
 =?us-ascii?Q?ayFAIl4PHi9eVbVvLtdnzlrm1k9X8JMcYCrMliTTy2O57IrY7OwKLktpKeDM?=
 =?us-ascii?Q?OU0Fu3nb5rM9eDgjw9A8gI9Vp8XP6ejl+yRonsW4Gwx8ENFjd8g2bLpU7UpD?=
 =?us-ascii?Q?9al2Exmh9ka9Jtv65TdHvet01hvfx7lBa0BkbxZ4n5eOEE4DFoyY64oV+oVw?=
 =?us-ascii?Q?3hIW+QeLIhtymUJ+aLyrhDciLfC2xJMt/WVIMMfK0bOrqg9Q4eEGplE8Ubjd?=
 =?us-ascii?Q?HCJu5Q+lEVSMBZcKOkhqU2G/15Rt0UpT880U6K4ZHu8XdaVMbEYQ4Kk7bD3X?=
 =?us-ascii?Q?L1mmmpN5c5J6DuQlkXqiOsEOC2x7toU9zLOfUNPF564DcnzMLOV+r/PuwIJd?=
 =?us-ascii?Q?94TKEf1YUWkagiy+R9s7xZ0Evg0xadLG3JM1Gru26FOFZ+gBIRkKmNaOsdXG?=
 =?us-ascii?Q?zdsoawVu+Jb6cMHzhXAZHbngvWsgPRszgx+5YHUH9vTTtIOomYzkSILtlqUU?=
 =?us-ascii?Q?tNSIgtPBs4Wl1ORfUX0Mo5c2oX1tmQAumwfyXJUSxiaBdi+BzGfJvITHfKGB?=
 =?us-ascii?Q?8JHz4iKHqC6jYpa4o3uGfPDC5+QY5Xhctq0ESSqvSI24igMFlN5msRc0ftBz?=
 =?us-ascii?Q?2OobW6QVIT5MIQNHz5ki+0M0unuQZ+0aB8cHQCRcsEzvdcdBFh5rGfvcOuGL?=
 =?us-ascii?Q?xaPmM/Onay+Vvex55IaGEpfiIJs7ghBkcs8c4RJYVWyr8YUrx6owDzREsqqR?=
 =?us-ascii?Q?8dXtwjyhjjIUdE8fkOGx2mQqhQiYd7n4cmOuoUw8qxOd7nKYi/A8kiqb6N3+?=
 =?us-ascii?Q?Jc/ID4ajJypbyC/ejR7iK/4k?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?fHnp2ZLPOn8FnGxbkDhQOsqIQeaTpJEe4orjmMEL9vm7YoVBVpgcgQ5ew/GE?=
 =?us-ascii?Q?63Ex35d9CRy3gEGULHXxB7r0gBbl/6MkQevOf//VsgpDJFn5IA8/e3Un97kA?=
 =?us-ascii?Q?xFqDH+lcmse9pwM53nf8Q3FypNFKn7OPpccW8tLtRuWFK4TC7i9nDN+1DtuP?=
 =?us-ascii?Q?Z5liAYctkeTCzOsrsqdWCsV8sCZdNecst1rCJnaWhj+VdP+XSv1So+/cX10G?=
 =?us-ascii?Q?7AD/mthoVahEqCf0v/pBVKY9NkQ/NQreewrdAwDKkUzNal2JP3eAeYJv0ENF?=
 =?us-ascii?Q?7TfsE0CFP3Gj8QAR8JNvK7U7IDPHh3NVEmjSNezlv9GBYdMO7Bw2lj/kdk/i?=
 =?us-ascii?Q?rMyCPwz5GY17iGEnkVmFQ+feW79R90x8p5DqLrOdyr7vH98SbOn/G4cfQGiu?=
 =?us-ascii?Q?FYw6G447E62Ny0x3auL1yDpqa8/wR2RGZO9ecQpcO2ZgAsjyEWkiBrYQ0O8y?=
 =?us-ascii?Q?5ElmXm7lgSMb3HTRrCVvaDnQh+L42XflDGSIuU3KLZL5d5b4stmXZqmQhyIp?=
 =?us-ascii?Q?e0dLO7EQejChI9deeNMqoQB+lrz6Zs7tZGiU6TlMP6lNW7qnRvvIK5r+Lkyf?=
 =?us-ascii?Q?AzJXRi850c7cCl5t0Ue22Bs73fJ+SfRG7zWjjpdEIlcG+cqpqgZ9xcDKhdAX?=
 =?us-ascii?Q?Er4BUdqynn+0SYSe956tobUF3ipfX18Tkxp7ZnCZYUmdYlvCv9FqnJd9lzba?=
 =?us-ascii?Q?suVLrHsZLTTPqBmjBzSUAI0upPju9uFSkvy3wrkpWh2Ldx12REueWiUrrzG2?=
 =?us-ascii?Q?MXQloPLiBkQd5SlH1qdpqj+qixLGEbwaiBxlHURFbvvwBaUjH1Sn3pp/IrEO?=
 =?us-ascii?Q?FuvLhSoijBV3ZnTH67p/6/yWaumT/OdmZ7VPZWHKdCWKzjgLKnSeAhhdMjMn?=
 =?us-ascii?Q?W2NJJtRbzuUXMUn7PXR6+nmpgZyxv0QzokR5wwvQYr961YFq8ZXuQcW55L4Z?=
 =?us-ascii?Q?kCNLF50hXEor6FGQreMp+uQ6i0nCYPqB2dJHN/CG1ZcaJW8S7w05OGT2AQw4?=
 =?us-ascii?Q?wQGvId63c03JsPGuo86wkYVNpwx1B5YLGdQcOfLLqKMvGqCMh+lzPlYuHzx8?=
 =?us-ascii?Q?+B3GzLCD4drI0KXIVklNVtFZkY96fNEL13mw06D8b9l+oZmWOEHGmiD0EvDn?=
 =?us-ascii?Q?M/w/OKMfFNks/jVuPSXJ8O2P59pFihNlZB9dr7wEkxnet8vPX6xK1TI4crbZ?=
 =?us-ascii?Q?OOotRmBGRZFRgR49Yh5PXLbdXw+aN6+VD5yahpnte2h1yor0w7tViAuU3+7O?=
 =?us-ascii?Q?QgYtkzGrMaVSOs4D5oqKyLsRjpbFh9qF9wsqtYl6GZZ8S8GgNFsKnmfcIWlu?=
 =?us-ascii?Q?20u8WSdYMQu4+W1uFXHaowuUFbb5/pGB00pZzFlLqmtyGwcZmrEZBOcyx15d?=
 =?us-ascii?Q?6n69qSWJG/iJ4aHtutwMpbcEJTzXsvyjBnXAaI1K9AYJRnjloCn+a2KgJatm?=
 =?us-ascii?Q?PdPIUA159RlbPGwv9eAjDk65a1APX2Mt1y0zZWpSfPtZZ7RoHAPlxwt1qRoz?=
 =?us-ascii?Q?20cOR0oqEA7mqskdwdQElgZunv1MHM4+ejF1Hoe2uGMKUz9OI4GGYMg6YFap?=
 =?us-ascii?Q?4WBAe88A9pvtjBCMUIv3j3FuS/pF6IGAFKXmib6TtHPZO9vZRon3DwqP8rhA?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Ji4/AUcC59rV68MfvLZivtoe82xy+edYaQZ0iMxC9fGPz/TYVcWup1Wotvfa046mgoxefAwJBYsj4SaPcOCuIJQMxXm4fnyJq2eoWmiA79yTroSf7KLOw+yL5qoJ6yym1YYVN3vQePeljyMy79Vi0uB/V+6Ezn+cjyz5PZ6Ae4PU0fjQGx7vhAlzp5hFpFom3Fo1o4hoCICoQ4DfHMxYTDoWCPge048wW8XomDDV87edT8HOoebAFgttvhUuqm2TBOQLV0yKTkZDRPUfCyTY4ULMxw4UvKSm86M47FPgR+xFevC5AzD+E/JlhmcwnFF3QlENkJfHjZaXmwOqPiqA//zndDycaatQJTItQrfA0dc/5aXeIs7o0xZ535USEi5GFHKFd0NGmrH8g1kZo1JLyUUe8mSLJD78G2ZWUawxMQL2NmT85bAB0xpM6A/k4UQ+XbchQawfRU1NC5G5BZvSTgyoWjzTtevhMtLDoWkjVdNxgZHRkD9r/GTgA6FGqjE2K+RwKgl06iNtOmYvK/PRM3VFh/Rlnz339sqJIunno6tqcfryvXi1mnoJT4dnqDRT7NoJFjnX6RLaxqLLCGlBZQ2qKVJb+GZLE69PBn/PSjg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e2fd56e-1c63-4be1-9087-08dc830da671
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2024 14:09:43.1576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhsLkrk9TBqj+4FO4ieBY6rodGYVjLfJ2klOZIAkeW5liMc/97u75DckG9wN7+c5IfF4hFDZJR+2MiqfeSOM7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406020122
X-Proofpoint-GUID: q52R6eD2BMSFONckzBmtssrxPfOrO1i-
X-Proofpoint-ORIG-GUID: q52R6eD2BMSFONckzBmtssrxPfOrO1i-

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
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/aio.c                |  8 ++++----
 fs/btrfs/ioctl.c        |  2 +-
 fs/read_write.c         |  2 +-
 include/linux/fs.h      | 33 +++++++++++++++++++++++++++++++--
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
index ef6339391351..819f065230fb 100644
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0283cf366c2a..6cb67882bcfd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -45,6 +45,7 @@
 #include <linux/slab.h>
 #include <linux/maple_tree.h>
 #include <linux/rw_hint.h>
+#include <linux/uio.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -125,8 +126,10 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define FMODE_EXEC		((__force fmode_t)(1 << 5))
 /* File writes are restricted (block device specific) */
 #define FMODE_WRITE_RESTRICTED	((__force fmode_t)(1 << 6))
+/* File supports atomic writes */
+#define FMODE_CAN_ATOMIC_WRITE	((__force fmode_t)(1 << 7))
 
-/* FMODE_* bits 7 to 8 */
+/* FMODE_* bit 8 */
 
 /* 32bit hashes as llseek() offset (for directories) */
 #define FMODE_32BITHASH         ((__force fmode_t)(1 << 9))
@@ -317,6 +320,7 @@ struct readahead_control;
 #define IOCB_SYNC		(__force int) RWF_SYNC
 #define IOCB_NOWAIT		(__force int) RWF_NOWAIT
 #define IOCB_APPEND		(__force int) RWF_APPEND
+#define IOCB_ATOMIC		(__force int) RWF_ATOMIC
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -351,6 +355,7 @@ struct readahead_control;
 	{ IOCB_SYNC,		"SYNC" }, \
 	{ IOCB_NOWAIT,		"NOWAIT" }, \
 	{ IOCB_APPEND,		"APPEND" }, \
+	{ IOCB_ATOMIC,		"ATOMIC"}, \
 	{ IOCB_EVENTFD,		"EVENTFD"}, \
 	{ IOCB_DIRECT,		"DIRECT" }, \
 	{ IOCB_WRITE,		"WRITE" }, \
@@ -3403,7 +3408,8 @@ static inline int iocb_flags(struct file *file)
 	return res;
 }
 
-static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
+static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
+				     int rw_type)
 {
 	int kiocb_flags = 0;
 
@@ -3422,6 +3428,12 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
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
@@ -3613,4 +3625,21 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 			   int advice);
 
+static inline
+bool generic_atomic_write_valid(loff_t pos, struct iov_iter *iter)
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


