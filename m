Return-Path: <io-uring+bounces-2154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F25C3901FCC
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 12:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 175941C212E9
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 10:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC9A13E3EB;
	Mon, 10 Jun 2024 10:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mUNPKu+P";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JditkVOh"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9000D139D15;
	Mon, 10 Jun 2024 10:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016295; cv=fail; b=DFrl9w7Q6U61qHdjK7+yC1puzIPxfhnZhd2Ut4ncGQe6xp7oZTEVENkXZHXVk/ch1gU81uIrqmK9nPg4x7z4mZW8CPx52pe7h9nQNk9AxYhMdO7LIBm8GdPVPqH1yl9EvsrlxmmIUaKpU9sfUa3McFPRwv6ZJ2bhdsN3FvrAud4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016295; c=relaxed/simple;
	bh=ai6/2WKplFK84CqxX4DkGF2xmv65PJnrZBzS+UzOIvA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PzVZxfmA5Fcdx3PKzIRAOGjQSeYL2GPo68b1FPmLA/S5RIbkBO9uOlZqTIyYlXxZ6gk5qCmR2pi+y3PYVT66imExhpB2AvxWCAW4a+zdDlbaFHWZFPZ9H/h9USeOtlssjMo+Q3Wiqh75Gvd827W5on8+MRZACFkKRxmZgrxerJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mUNPKu+P; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JditkVOh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BRx2024983;
	Mon, 10 Jun 2024 10:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=taJdAFElvtfquWhoXAxM8upTqJSXW9dQcY/NpA3sNPo=; b=
	mUNPKu+PfU5DA6qdm09qhstK+nnosBp+5i+0wqQcuI5ynaP1J1EYcO9nqjRFQVco
	u876T663o7Y+ZTNdsrx+araX5ZC60sAss2g4lNIX/cZfDVPaSPuh8hPGo79mQdat
	ZArwvU5SgA+D/EvzLQPGcbihB8tyMEFwL4yJH/3+386oMO7Ml2OGPrO1qrCCUHLD
	TzlqLrXJ2TEv42F6Omk6CkOzxOUYCymXhDM/IJpotA8ZtVI3uIj8Co4dnC5kjZGE
	T7VUpbkKhLZ4m1g+mTpV+pqPBbDs9hSLCp0wlgifSiDcYV/cRlvY4rmrkFTGAopm
	mmEfbh6ww5T07VKu7ScQLA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7dj8hr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:44:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45AA1plQ020108;
	Mon, 10 Jun 2024 10:44:03 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ync8vk8yp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:44:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3piYBFWc/0Www04v1Z9m3b9wmDXRoLBp9yMgmqiiSXC4BzvtiVEv0Dmv/IdKkBdvnoDq+q+W/UcUPxAqOPGjlPAyLTrJ38W20rAVnjpgqE40x/Cr1tWUWBymhr7iGHdp0xO/6RySerF3+DMen5Fte14INuQmFsaYAbbH7fjOO4GioQNCys9mYQleykj/4W0LJbl+blfUKBzX40DrS9QNxjSdKamrAVY6+1doh+CRXYlu/ZIEk8ux0gilVQeM0YNMOy/tIarrhtNyYwX4PyyX9OHpjGVgMRtJX0mGreuWSfh/tPLXZp6H+GhHBIbBHM75bILAkpKsRmvIL6mlja9cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=taJdAFElvtfquWhoXAxM8upTqJSXW9dQcY/NpA3sNPo=;
 b=nnefrY9+Dh8CxT8yx1KpHRa/gCA3vq3l6VQHg9m/J/cVOGs1fSktr0aTrPYzxr4nsnEqQAhUA16iWD/BxPZBca4pmB3n6xbY6DWjC/Z1Af9uBSnMjM3OgknS++jbPfOcPgqxY+G/Mk65yGDKm7Cad8QgKFByNILPNolpU/mexLFUG2pa+i9hXyWmV8SBZZAmX5xabLx+lLT6ep8Q8mNv1IjsathrZXo5kHeuMp+IJZxA0GFa9xeBulJPaRVJDYqu5SEGBy8NZjQUnvA/wuqX01fDQPPv/qpYbGe/uDL9K1CDLYrs6iF3Kq+jd25GOM+UW58PdQUBAy1/94crDhDUUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taJdAFElvtfquWhoXAxM8upTqJSXW9dQcY/NpA3sNPo=;
 b=JditkVOhjgRjN+3FyRf1H8mc4++FA+jKMXRpPlCjkBmsEpQ8oyuqZNKJ32K3vb8YpcnDt2zI57GgIPRoR8CKXPyCWcMuA0TD+VDc1HUQMI+ysvI0AhHipNa7etUtP6DCrs9HqvXddkOABsU1+JGxCH9SbZ4x0k5GqJWgZRB0CoA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Mon, 10 Jun
 2024 10:44:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:44:01 +0000
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
Subject: [PATCH v8 07/10] block: Add fops atomic write support
Date: Mon, 10 Jun 2024 10:43:26 +0000
Message-Id: <20240610104329.3555488-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610104329.3555488-1-john.g.garry@oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0244.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d4a17a0-b4fb-4d79-c65f-08dc893a3d53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?xCI9jKNli9U17CDMflwlV39GlYL3JD9a0WWfs4+VHCGDBYl97g0Cjf/i9ioa?=
 =?us-ascii?Q?DsFcOwacaFk7KNGeouOkp/6DLnWgEb6KEOod6+efoo0CiROZBIXEBloiOP8W?=
 =?us-ascii?Q?Z/7M6E2k0VMPZkVPu/v5ElgwhFKe+pOjKAMBIDL09yKXRIG3j8xz8Ld1m2Sv?=
 =?us-ascii?Q?8NmRBhUzxYMCiU+fa5ejPLSKo5/iXYLZwq8bcxRX6CPPWS9PyFj6BVjIRdBf?=
 =?us-ascii?Q?SFSE+Hnti+DW8r3+dfoaLeyOfWA0+/9VD7eO/ZNJ/UrxBN35BORK7dx7yl0l?=
 =?us-ascii?Q?9KfNEbFt6tUIBmsjVZFIvBS9JuDKLON92ZCFyARHfRkJYx9ZBVPKLA+EzxcY?=
 =?us-ascii?Q?qQAG/apBHHpPSu6S3m1FgqNYeHan4AmZ93K5RXMD+MXN+Iy+nHvz7yGK+a59?=
 =?us-ascii?Q?ymcawj/LnO46rK2AhxVCzHYyn7O7AQT7EGMKnrs2WumD3tjVF2qVEvrVqjQz?=
 =?us-ascii?Q?8mkHiESwaYfIUaSBzCOsCqafRk0dyENJXi0Spcr0MZMhpaliC1Oy+9awpNY5?=
 =?us-ascii?Q?r6/wKMuGW014poFCTj2Ehm9heB4fOjZKqJsTnd5tF41cFxJX4+5E6FDjSWfV?=
 =?us-ascii?Q?84n3bXdFEF4+NGzCD9hs9VCceXLolBYJHllCkkjPCimFZTo/5JRIDbKl4Jdl?=
 =?us-ascii?Q?8VT3Rn/MA2OEDEfBROdh6HRsKFNAPpglBXPHedx9gE4H9Wb94n5wayJ/3/zl?=
 =?us-ascii?Q?Guni+KZSkXdjRMb3xHF96pd5uaPC2oUsrorJW4aTn/03LGDBoQexxkrylLxD?=
 =?us-ascii?Q?n+EHNVQsUFd/HBDLQIV1hxoSMGAsX56fHb1gET6ztBQImQF2P1/xM2uuxyo5?=
 =?us-ascii?Q?JX29bR+u9GsbJMDpBWycs8pbkah5Ut2F6iUrFPZDZmxLNFzMQnNkVZv8h38j?=
 =?us-ascii?Q?AYeT0ElXqrqdUWT7B7mN7xLvvjIcvCCJEajgeYmiRNC+G1dm0TYOokLwYtxF?=
 =?us-ascii?Q?SxAy8PpB8j31UgZGFtit18+T8aIG5yR6XMereXO2I08x4pVmkNrbPX4jslQN?=
 =?us-ascii?Q?Wb6cQAzcHZCaQV8W6mdCPz1J1ENicnsBfz5jalU4cL+7NZQ1WbrEUSTBgsTU?=
 =?us-ascii?Q?EpATBe7pSti21tkxU0LkiS6f+vvSPPwirnpE5YOyshih/LxqzJWIM6pNiSDe?=
 =?us-ascii?Q?1tkje9YZ1x1sx1a5SlFhh5MDk/0MvTqWRHfWs+gk56pUGbItpjTGv4uzgPEx?=
 =?us-ascii?Q?pNNaDeNTd/0RasZn2GTuxv0DDmlN4atzbKRVGeqmmPhNDOIt4fiS952cF+29?=
 =?us-ascii?Q?paxpIKcOmij0EkXS0Um5BfrY7I5KMvMFG3xpskvwiE3uOW3R/KjT0RU9mW7h?=
 =?us-ascii?Q?xYzZZ8JllQmpbh4TuwJRsfegdCkzbXlvDMCzLKT+U1HhuUeApUr+39Dr6WpK?=
 =?us-ascii?Q?hW5N2HA=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?tSDJrwjxJIK198lrQWsivXhpsy7/ap2DJCjQ/R0rbR55x0k2sdhyFVuEFKyQ?=
 =?us-ascii?Q?v04KJZ2rMGA/w0oT1OdfDWNXbMJRzTVtP63PIgO4Xktvrr+J9hNhTOE3cO7+?=
 =?us-ascii?Q?cUXsZ5ZU/Soc4vB10ek/7eiW0Irk8Q9fbaTzM6RV1dw6fcUztP8FvoPD3igy?=
 =?us-ascii?Q?7UJmX4rgY1DM9r9OshwFZVBHubPXmdfEL5aPi7m1Q8FPn31FTU2s1rHqLK2u?=
 =?us-ascii?Q?biZUqjTCma2Fzt606/eBqg2QTrIpMbou1raTO8Qima7Tnt2xUJ7VY/+FZMwd?=
 =?us-ascii?Q?zXqnrT8YedN8Z/TpFro7RwuL60teLshwUV79GaD3iufEPgGtM52d4tsODb7S?=
 =?us-ascii?Q?3vbj/TYnil3HJafEKAdTnExQ0g3MQp57AVzo9eFvdFM7tWf6K09W3raqbcj1?=
 =?us-ascii?Q?wc9hmLZEPUHPDqXEFtHBwShWmYsa7sNA2uqtvPKjKohbEKsVQ2Ho+CqA87IF?=
 =?us-ascii?Q?YTIkk6awg1zJHumehUZ/+PMCounwwb/mPAwrZ3myuq1xFGxZ+OE2NIpP79sZ?=
 =?us-ascii?Q?cKMj3wPYPqPkZa6ZwQ+zSGHf/PSkznyEIthNJsjYrNCexHhUWu9iz0bsEPoX?=
 =?us-ascii?Q?SWTeTtg+Et2ajFxKLamnnIA8Ytq+wo/Iu8Z706eLjslgR2F8ngGbG7QrqHXe?=
 =?us-ascii?Q?JkxqrqMJJG3CEwc1CQNpARKwlNx4E2olo4b0efAcibrM4tujaaIlD+5mMVDW?=
 =?us-ascii?Q?/LY2CWuPQHehR0hl5Moh0rjIk7JKdjJ4uLS6utfVBKZ5aEbehytiLyyJh5hI?=
 =?us-ascii?Q?Xgu9Z+HqSmQT7s/etsOEiV7bbrPsiZPPad4V9kb8pVemc6TkAOYWhHUU7MSo?=
 =?us-ascii?Q?xWPdgmj3SBnacok3jJDugGMZS6wLNobs9s0/OBVxgjrpuSVcAeZxxEOcSwhC?=
 =?us-ascii?Q?nQFqjtM7zsmMU2eb3kcQ+62rtol46ZQa/05glwpfs7TLI1dFPHRacop29sWj?=
 =?us-ascii?Q?fkzdF+7vgJB2k9Wq81cPIBCOkCA2WvO1NnChPwd0mFKrIoJawJ+HZ/JV/1si?=
 =?us-ascii?Q?tvEcwVWMlcM1vcOHEqPFgy1rY+P8VtDTd0JaHJUZqfMFR+AiicIY+8i7anw7?=
 =?us-ascii?Q?qJeVBk+HdQXwN3K8lODzTez0vZiicE16qsYcWmzR8BjiWHrbOogNjQh1k9Uf?=
 =?us-ascii?Q?FaYZ69Vc3LGyHnKEHKL6MDuhenql6k87sFR4cW4OIc4bRYqeGDhKfuvkkQLt?=
 =?us-ascii?Q?8HrqbA2x23pJhNpigNuffQvjtrgFD6ODqn9cIvpHbs8kzzBO0czc/7bn/eJo?=
 =?us-ascii?Q?DhUnrlEI5Reo3yJdjLBC+ddgpmi3Y3m03ipFZXRAaZdRWVw54i3l3XUf2Qzf?=
 =?us-ascii?Q?2GjMl88TFVau3nZUIAQqcTLiUFJwpLnrYbn6Zo5PSufoJPxKdz0n6UynwRSD?=
 =?us-ascii?Q?fA3e7DUGexYDbUnf/j6nR7a3uxVhWJCkBowBxrR3zsn+aKIzrGUSX4Uat0XQ?=
 =?us-ascii?Q?W9WC2PG6k2WSSXuMlLFaXqJgPQL0TLDCekN78hZqxoNG9EMb0cy+t68+3aeL?=
 =?us-ascii?Q?kRXmtuv6HgeiSVJAXerqSBBn+2W4OJxmtwH0QueArG/Sq73orQyNaBJXd9an?=
 =?us-ascii?Q?qSqkQTVB1hyTpHeApWh0KMWD6FpKFmm16ErJhRbhLXNjxYon5pUrTgTAR4Ly?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Txntz8pvY0R6flYTSzvQ2rbNvh24hGus+0KST6DUhNYpvxH9khH9vdnzkgogMoZgheAdtLp6PI2MF9ptCcrb6+IW/0jVYrzrwscigTx6pBmbz6DUcAT3UWJY9tDfwTmhPp6jyFHg5fdN6KuA1hbrhHihMO7lxt01r7z4z3AiSLXO8+A7eXHp4Lq6f7JkHgSny3ANXagYWYCBzyImNzlQKfGLfA3XMsf0RzmG7d3mP+FzMzcD89xX+BCQAvND2OSgEvizPl/F615E9rp+igREx0A9CSf+Uj1m7p/MwTv1gO1GhcgN2rgNXH8MbPbFT4Ww9T2/Bqx77cwz3ucMlYKp/lAfL8NBh2ZQDOVGVXR7QeLIp/BTlCqTBOleHhnV917iI12DCbHWN3EQDfy6dzLeJZCBbrXkUHiWkMk0Kzt68W5N4Mn5hORisiBVtQeFpj5HaUhHVEODWIOpp+Y0Kn+QM97218CTh0raETAQQvgrPBfKdiGzfMi2FrYlyOCg8US5dRGucud+0kry4kD5de3h6UZmjJAiGBiF5M7aM2ERMsiCTUO7Qgx7DkMYAcWr0WGc0hBgiiw1aM78J0HYky7Dp9K4y0Xyvlov0g7rWaJcXhA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d4a17a0-b4fb-4d79-c65f-08dc893a3d53
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 10:44:01.0844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mffuc21RzOF/Nh1ZWw8Xk+IIsw+cwxO6lwuww+oRnI06KW81IvIlQi0cqGU+PPovwOR5sB6fzrIb0E1A6pfaFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406100081
X-Proofpoint-GUID: s2pGwygE7nT4orZVtJQCZ2E4fi9B_y7m
X-Proofpoint-ORIG-GUID: s2pGwygE7nT4orZVtJQCZ2E4fi9B_y7m

Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.

It must be ensured that the atomic write adheres to its rules, like
naturally aligned offset, so call blkdev_dio_invalid() ->
blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
blkdev_dio_invalid()] for this purpose. The BIO submission path currently
checks for atomic writes which are too large, so no need to check here.

In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we cannot
produce a single BIO, so error in this case.

Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic writes
and the associated file flag is for O_DIRECT.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/fops.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 376265935714..be36c9fbd500 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -34,9 +34,12 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
 	return opf;
 }
 
-static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
-			      struct iov_iter *iter)
+static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
+				struct iov_iter *iter, bool is_atomic)
 {
+	if (is_atomic && !generic_atomic_write_valid(iter, pos))
+		return true;
+
 	return pos & (bdev_logical_block_size(bdev) - 1) ||
 		!bdev_iter_is_aligned(bdev, iter);
 }
@@ -72,6 +75,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio.bi_write_hint = file_inode(iocb->ki_filp)->i_write_hint;
 	bio.bi_ioprio = iocb->ki_ioprio;
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		bio.bi_opf |= REQ_ATOMIC;
 
 	ret = bio_iov_iter_get_pages(&bio, iter);
 	if (unlikely(ret))
@@ -343,6 +348,9 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		bio->bi_opf |= REQ_ATOMIC;
+
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		bio->bi_opf |= REQ_NOWAIT;
 
@@ -359,12 +367,13 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+	bool is_atomic = iocb->ki_flags & IOCB_ATOMIC;
 	unsigned int nr_pages;
 
 	if (!iov_iter_count(iter))
 		return 0;
 
-	if (blkdev_dio_unaligned(bdev, iocb->ki_pos, iter))
+	if (blkdev_dio_invalid(bdev, iocb->ki_pos, iter, is_atomic))
 		return -EINVAL;
 
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
@@ -373,6 +382,8 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			return __blkdev_direct_IO_simple(iocb, iter, bdev,
 							nr_pages);
 		return __blkdev_direct_IO_async(iocb, iter, bdev, nr_pages);
+	} else if (is_atomic) {
+		return -EINVAL;
 	}
 	return __blkdev_direct_IO(iocb, iter, bdev, bio_max_segs(nr_pages));
 }
@@ -612,6 +623,9 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	if (!bdev)
 		return -ENXIO;
 
+	if (bdev_can_atomic_write(bdev) && filp->f_flags & O_DIRECT)
+		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
 	ret = bdev_open(bdev, mode, filp->private_data, NULL, filp);
 	if (ret)
 		blkdev_put_no_open(bdev);
-- 
2.31.1


