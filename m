Return-Path: <io-uring+bounces-5061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AACE99DA0BF
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 03:55:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D69E168316
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 02:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC8F3EA71;
	Wed, 27 Nov 2024 02:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L7gWo6Gh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oqw3clMm"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A2D1BC20;
	Wed, 27 Nov 2024 02:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732676133; cv=fail; b=e7J9rNm6SO/Q730x5JKieCYAjX5v02myd/0UWYZBB59XQU7p+BoPLMAcPcJu1bUSYMAoQEBGqf8lHF+x2VSz/3YeK3UL0T6WjIztMf5suy06Q6ldufMwCeTrpFvfxU8iDJVmppq0iSPj2m07/gI2DfP+oujJcN8kHAdTzCATdEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732676133; c=relaxed/simple;
	bh=ZRIIGQtoSOmpd6Q49dX67R87jl0AD4wxNC7a1uM7vcU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=UKVKvFxSkTCm7wb53WfoAs7bFaDEH2Pf9GtL4U2JJKpTop/oZ3i/hlVnsVvgmG1PabxC4Cy0KF/2dVtDHvEuYE2jg6ygB/linYW0rIgfXvrTEwnBcW3RwT9UHUEYcE74LKXwjrNz7TnnsSfAPPnMLHiPEHomZ0lMGM3t9lVcwmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L7gWo6Gh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oqw3clMm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AR0fcJO006899;
	Wed, 27 Nov 2024 02:55:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Up1otqPEH7Kx4Hx0Ja
	qdcIMIn8Iokv11lObNnBTfe0Q=; b=L7gWo6Gh1LOtDAxBKqEx6GkCcPoJql2fHb
	eEWIJMZzCyha5VliqIZre7FEgrys0GVs2f3R8PrOz/9rSsXVJ+s9SJt+TmkkRWdt
	J6KX8Fr5XeEXldnorDQHpa3UL2MoJRtrXieb0jM1L+D7FZ7M+1hpJm87XL+pK9Sl
	BL/YBpg9o2QtV+xekBvDpBRQV6BMNhqhXMHZbzsEEUsCg6vQrJnmIAOlwqC5WkVh
	D53+4+yJjwp4ZrpRnXNhc6MFLgPiMMFHlwjYMFOc8dU94+u0K9CY2WAoZazKMyym
	q4CDgolxPOJuJf2B+6+09qsc/kn1c03tHOJ9gQqbKDUEuRH2fnqg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 433869xykc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Nov 2024 02:55:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AR0GDnO010108;
	Wed, 27 Nov 2024 02:55:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4335ga34wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Nov 2024 02:54:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NZmhTwu0nFpC9M6bxT9RwsSka0m0jy17fMULOxJ8+uCZZJOnBQ4BOcDnXItsF2vMbfwqIcwQ1gb5HPKt7FPvsPSWvKjzV9GsUTaOdsK81FYQQt+IgsjvCUSnJAggZJa8y4PyotWXDJsR6iUpfUhmcdKI+zNLv1OSrkBRsGxBaL+v4B7R/KvrLzklhb0WUC2pp/xAGqIamuiSG+olXY7BTB4gli11Lpc0rzng/PuIslAfZaP1/wVypcqRbuou7WhYurX6gTYrQ9HSKjCCFubRIxvnNbsFU56fXFd+SWxnSFDAkgihV5SRmDaHUEeaty8V0EYWkV50YxnzC6G5YWs9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Up1otqPEH7Kx4Hx0JaqdcIMIn8Iokv11lObNnBTfe0Q=;
 b=BX70EmdYmA2AEylGf0mwmYONZMttMrrqSceFPO1I/6UIAmwNBhHgrh7ImA9BAvvR40SG8FU+R5vSWwg3w2y/c7X6iVcouLsa2fFiDTakgfqGHsSI9CTn+S/8o2ZXyyEwNI4gnSdT/UK6MCsYA8g2x4H94YP/2tVylhiGqxu/qUm6BJFHK5o1GyBD6PK3AcIc13AvFH4c/TRAdtqn1RYmAyYjBxiq7J+6k8vKPkbM5DQ/xEP5n7F+7Xki3HbAo8rPNsff1PpE0Nj+oYYlfYNFVtX8D68q3S6KIo5rpb099ZGXBo8t2Kd5UozEVKcT8ishfq6kVSB+O7luOHRsxIcccA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Up1otqPEH7Kx4Hx0JaqdcIMIn8Iokv11lObNnBTfe0Q=;
 b=oqw3clMm0nahWJcQbhJ1a1z9qNSE2EBG2cccBE6GVdlp8fA0MkHG6zJKphsW92Yzb7hqWzIBo2LTKSTnZlPUGKzNcuGcTvpFKDIIPiJ9xicHpHYmlmvHR0Sb5avxn7c3PfGrpkTcXS4SjBYaaBZrJmQEGiuSzuikbHeKKwnum2s=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by PH0PR10MB5870.namprd10.prod.outlook.com (2603:10b6:510:143::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Wed, 27 Nov
 2024 02:54:56 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%4]) with mapi id 15.20.8182.018; Wed, 27 Nov 2024
 02:54:56 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nitesh Shetty
 <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org> (Bart Van Assche's
	message of "Mon, 25 Nov 2024 15:21:47 -0800")
Organization: Oracle Corporation
Message-ID: <yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
References: <20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
	<20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
	<CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
	<Zy5CSgNJtgUgBH3H@casper.infradead.org>
	<d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<2b5a365a-215a-48de-acb1-b846a4f24680@acm.org>
	<20241111093154.zbsp42gfiv2enb5a@ArmHalley.local>
	<a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
	<20241112135233.2iwgwe443rnuivyb@ubuntu>
	<yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
	<9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
Date: Tue, 26 Nov 2024 21:54:52 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0149.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::10) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|PH0PR10MB5870:EE_
X-MS-Office365-Filtering-Correlation-Id: b3cde5a3-7967-4985-3c05-08dd0e8ee039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W2Txskgo576espi+8rlUGkPmMLa+Mbz+aSDmuaxRLlSeL3ntEp3pcoU2Kc6y?=
 =?us-ascii?Q?Px+pQru4LbxcU7hC59R/Y4us0raIReb/B18G4FFalI2mqxK3sPP/x/EN3gsS?=
 =?us-ascii?Q?4EsHxtzy3KXxCMD/c62W75npCAttlXN571b6RLW+0WCByy3LD+VYyvN+J64r?=
 =?us-ascii?Q?jIXM27tOs3hEP2ZvDjbTJ2T2a/OYu5PczkfIEi/8g/7tc8/Rcehb/J1mzYKQ?=
 =?us-ascii?Q?S4xujCOvaVj/6y1FwPzsqQNsR4ZGqwykYQ4LFyjZEGLXQZurYNhGxUpddqh6?=
 =?us-ascii?Q?hEaPL4u/a7MYTAvS48sdcP3y2UPbRRBoIPHfQHMNEoS5JCloKLPdN+Uv4cXB?=
 =?us-ascii?Q?YL4bQnj0R886WpyTdCF5h146Rp9dWbqTbciZdt+ipUcuyojjs6fX1+DG1F39?=
 =?us-ascii?Q?7QqCvbuI8zqdEMJ02XLl9IJawSovKuIypXmSYTvyBcGJDDy7xpJr2/Txth74?=
 =?us-ascii?Q?AitemjUH/MmxRYrel7+PP9bCGAnRH8TnHyFg0jjTUCilnQTswqK6F5VnysV1?=
 =?us-ascii?Q?0JFvcKSutHkVIGwuHwpLy0n5wj572M9S4M6tcsop7/V93Fzjt5iKlgDSr2bs?=
 =?us-ascii?Q?dAb/MvwbR7JzS8RLMXcYZwgwbCxT4xKWkuiYO6nDEIowr4NEjgbKN0iD3YAp?=
 =?us-ascii?Q?A1YhRnDzZ9KBNPi5aKUfRN646D9qeH0//Q8+mmvbTnEyQJoTKGYyVDTCEMAJ?=
 =?us-ascii?Q?YcKUJhiKs72ASfes7Gv7zgx49Jhf0Aa0fHO8s1ox6oyDNfxwbQi0u2Uz8htk?=
 =?us-ascii?Q?3OZwGD0JeLtPy+Ccf/xjLkStChM+XsHo8mdnYBZwnC3K58XCnbRDRJxrGehC?=
 =?us-ascii?Q?/AmW69iBBUXXdv8/daXD4NIgmi7wLB3YwmJmwVgBcEc97OGCAJWhlZRaZr+r?=
 =?us-ascii?Q?dh66/8MPQCOdXO8CG5iSHCSDStATpRTG00z7nkMkOXiQRDDqnGgkaSSftiDb?=
 =?us-ascii?Q?es07c1AOe/vFeZSpKD8hl+BnTqsusfcy7EHg6ntiTfU09NNdOR9gjzMApN5p?=
 =?us-ascii?Q?dJx8IrbekaEuJnyw/pAyPzr8Um4iyvq9EkpUtgpVaT/rwv0aEIF1Fm6CfcTf?=
 =?us-ascii?Q?om2fnsr/XEdZmGPgXel5bnY+xpGbflDaPbdwoCiN9p34TXgGggGAKuyGdqi2?=
 =?us-ascii?Q?2xLY6scN3Jgs487vQQyiYrK+e8aubgDYF45Ik/5TCBko0BwFRZi8hyyWYm3R?=
 =?us-ascii?Q?WF79JmodLDz6aaYxBUYMM3Nqg1z6NULelpbsXpytqEs0qmGSaOKIxkEpmQl0?=
 =?us-ascii?Q?pFRCf6D5vpGwWmG/g+92WE5wSdUXOafGZ9NJad81KD3hgfmeAPdLkhyz75te?=
 =?us-ascii?Q?ifAz4/sbAU7HHvbdKZrHBABONP2dwojm3qAMbbCRXUxvEg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H5ffpwvzk02yjQr782nAieikz3cS4/mcvry3YRuSPDlZ4ilZtd3kS8X4qyVs?=
 =?us-ascii?Q?UwIS6B6L/ySa7hovWl0SIeeeB8e47LEW6imBDDy/0zROl0fDQgcQWgRA+MEY?=
 =?us-ascii?Q?Jp6ku/Lvhh8C6g5fHLE0cqhSNPBK9Hl2MDWtW2pM2XYXJZY/BMaHNOCV20Qv?=
 =?us-ascii?Q?yg7dIkuNZtZRQff8vH4jw4YaGalwdk1rrcvzQy1AMBPF2hzwTseP01rXL/R3?=
 =?us-ascii?Q?vAu+OUpZN1Nms3Ly21W0CL2oETj37JK1IigiNmufbpbU4ozOR5yQBW2dboWi?=
 =?us-ascii?Q?Sbj3bBlXYI1UpUimjR63Lfi2RuW7RSrx0q3KHvmFpCh9EGfOYWfo/pQI6uig?=
 =?us-ascii?Q?2P7wFcqhqcqDF1NGwXj8QIxTxrUzJyyTTkIhWKZ+6yt1xjCZ9csRMtqPOvvQ?=
 =?us-ascii?Q?UWmaBfmVIrt9l9bWUOPU5XdX3kPi39PS9c1QSi0ldDkRHqwLUS33vaCrYL30?=
 =?us-ascii?Q?9vDqp+OUblKfLrVBJidbesHnpiRg3tiSCqfR6wd8oJAleZXe7PMt7kIGf1Qo?=
 =?us-ascii?Q?m6eFVudBk8F+gyAR3K4KORWqJHuS9VOq3FkAJKgYqlY5s2kWpzmM/SbHfdEa?=
 =?us-ascii?Q?Le+yahuHmunT8GCAMyh7cbDQ/LSewrT+wV0Q9aHSIDSiaTNclEzyrD6GhUFZ?=
 =?us-ascii?Q?LnNtgYmoBstonZRKwFBkoZFB8i0BFMUE18+Nf0/OeTHl22d9QmnPNDb8sMbU?=
 =?us-ascii?Q?Geabf0pRoeFNN4mzVtWV1mjIs/MZ+JdsRLFQcrBI86/zgmqdGNBHRihypQ2k?=
 =?us-ascii?Q?OsODycQsjjsHvST8tr3fAjgNFV7k21iCzJlZkpKK5N/cyRSwGYixk3pbZEUi?=
 =?us-ascii?Q?YYlonsvPMzMG7M518nvjHQHmieHqy4+Jb4L9bAPGXFYSHIOwwS2u7+ph/heB?=
 =?us-ascii?Q?6JdcBOGxcyYS5+5ow9NLNw0+83t8y3sdeEdaYUpV9kS851Vj6MJ2/XLXSsGO?=
 =?us-ascii?Q?1aQfJRkXQ8fxY8tdcNRevd9Ioi41Wc3ZdvJQpkgct1kuKC6ukrfBdV7zQJJB?=
 =?us-ascii?Q?KjMEhiwNu8VdAvLJA2h0qonzXAqyNSfRwLcIFJox6186nusHw5vVRf6rWj2M?=
 =?us-ascii?Q?TR9TGGEjK9StbCDcN4PVhq104Vb3o1zmInF6T5wdkxV8OxEOBXqLCxxi2d2N?=
 =?us-ascii?Q?KOAkPz1pgD75tnyhsC2T681f/UGYcXtSTTm3raFK+LWj9vmQ2jk8e6Ejw28J?=
 =?us-ascii?Q?CYkgDS2yYZEJqyi0v2sBNocFGf0wiSrfdDstwGGMrJt8oUe/V3JNNDiAKhJ9?=
 =?us-ascii?Q?JBV06QBgbN86Hl4z2uK7YoexXx4ZI7wCOg6vEQZyUC0zMEPwmBTAUbCBNYAL?=
 =?us-ascii?Q?ITqmbU36N2jXfJ1q3ED7WcSc3VsZK46Muzu3gkMXXLTcKLwjqd6/75gwSb7Q?=
 =?us-ascii?Q?bGEiEl+NN1lk2/y/NWHbawjqGMx80BifNwSU/jXzRHuvstuiGIT6PXV/7QkK?=
 =?us-ascii?Q?LhUjvA1Do8/X/QGeP2nDrkJDQIQsMKekjoI1OvHafBmYAl3GodzYedt9qm41?=
 =?us-ascii?Q?MbRhyCEihqwmTdLrv7KCBLrtWCVS8sm5Tg55ZT09XC9coT2CUML3lJhUlNWr?=
 =?us-ascii?Q?PM4OP2B2VicxXWY5hpGHoDnRpa0TuwNJ3y1Wkc/kzO6RIlVAQgCcpCoEVsmc?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vazJUGsbDWrFarOGLtiFn5FE3lQQBGQJfFT6KzyrSw2ZJHIGOwUNDQDr78bx2ljO6t2QJgNU6OJRQ0mwEuRvEH3zLmTC/u0Veb12EN0SBAYtFBnjIjedhfMxD6h8mJPBCbs8iBqtYDW3mnv6Zxezr2f4n+3FaYEYgKHTJ+a9fJb+QGWeJcZRlFwjrYkUCER5T2Ygr8pTfW1C0RxyBr4hTXMbCvKsZ6D3rFwqks9ghM4NjXBoFgKhoA2cDm4+BLYG7YW9i32dJwYDz2nAwIVOYkaird1rKbvyKWqf1JyxWShwM1zK+L8L/H7W30Fafyo65peybhhwVDsSAlkGRFxFpuCe4n9w4xdYVIav0VNZB8/2bwiUTU5T1ffR+TUFxNGEcmVAfIbOkHoh3WqypaoJUIHJPpJf6a0aSe7TPrp48h4n3ttBERRFncdvUnRzC93a/NvdM4qtqG2aTipn4oh0e9an74vBZAurWSazHWNilcyT1ETtR8GkNsKNAcPJTJg7Gq4EvDbnOs/JAmdc9uOIdcFOo9kLaCqNAUplfL0M/MwVLr1tj4LzXKertB2O3Ig3eHHdO+nxADnldOK9w4spZ5erXDeNKUthMCq2Gde+hKc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cde5a3-7967-4985-3c05-08dd0e8ee039
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 02:54:56.8642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUbfyedkzHLI9wq4BQiemyra2TN8GD6JpLA8Pqken+xwDkE7uu5ylR1of7eb5mPqhDAK+32LS8/P2Fv3oSMibLgflE6PXQ4fxFgBB2uxbuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5870
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-11-26_16,2024-11-26_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=793
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411270024
X-Proofpoint-ORIG-GUID: MkiKOjwPfZ53bRR5qCqnyJxj9kVuAd9I
X-Proofpoint-GUID: MkiKOjwPfZ53bRR5qCqnyJxj9kVuAd9I


Bart,

> There are some strong arguments in this thread from May 2024 in favor of
> representing the entire copy operation as a single REQ_OP_ operation:
> https://lore.kernel.org/linux-block/20240520102033.9361-1-nj.shetty@samsung.com/

As has been discussed many times, a copy operation is semantically a
read operation followed by a write operation. And, based on my
experience implementing support for both types of copy offload in Linux,
what made things elegant was treating the operation as a read followed
by a write throughout the stack. Exactly like the token-based offload
specification describes.

> Token-based copy offloading (called ODX by Microsoft) could be
> implemented by maintaining a state machine in the SCSI sd driver

I suspect the SCSI maintainer would object strongly to the idea of
maintaining cross-device copy offload state and associated object
lifetime issues in the sd driver.

> I'm assuming that the IMMED bit will be set to zero in the WRITE USING
> TOKEN command. Otherwise one or more additional RECEIVE ROD TOKEN
> INFORMATION commands would be required to poll for the WRITE USING TOKEN
> completion status.

What would the benefit of making WRITE USING TOKEN be a background
operation? That seems like a completely unnecessary complication.

> I guess that the block layer maintainer wouldn't be happy if all block
> drivers would have to deal with three or four phases for copy
> offloading just because ODX is this complicated.

Last I looked, EXTENDED COPY consumed something like 70 pages in the
spec. Token-based copy is trivially simple and elegant by comparison.

-- 
Martin K. Petersen	Oracle Linux Engineering

