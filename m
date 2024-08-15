Return-Path: <io-uring+bounces-2776-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66922953810
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 18:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E73B31F2172A
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 16:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 225AC2A1C9;
	Thu, 15 Aug 2024 16:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m0HI4IZA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QKmdOKmr"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A19B4C69;
	Thu, 15 Aug 2024 16:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723738528; cv=fail; b=EDnbSgwrHaDHQL06pmS+Gqb2ch1D0ZhoqcvjmXtaqFe79WAXqQBV7ZDksZy5OlPLRAtqwFSfuALGjOESAqG39j0rN2At/fWBwpNPFQnN21XkVVFO/e3uVoHc9DOZc8Yxy3MVDTzCcU/2cHGzihp00hPw+RiLQ/GmlPX0VNqDS/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723738528; c=relaxed/simple;
	bh=IKs66jPrpVGJ+eVztJHTKV+ra44dd6eBzSIkJXh3XPk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=GGsBtQX9csr0AjLH/aLihW5Ot1c0M7mfKVgPfyl88YQFH38QUU1zfvKgungTasBDsh7LFMqO6kEva1NeCoAQ27QjveWr38f6r39kcCv7Cfda3R425cb2UPLz7B9MR+KhyxCIuozr7APbIaCDtVu/bcrsUEKkCCB6sRgGmB3a320=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m0HI4IZA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QKmdOKmr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47FEtYaL020629;
	Thu, 15 Aug 2024 16:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=vJB0x7O8PN8j3j
	G0QV2F+C6Tr6BpJbtyGOxY6iSNjJQ=; b=m0HI4IZAdwD20GHCQU//+X9d35D7Wr
	wG9cSSaKzn4lej74qfG5E0lzE1MCuHI1T4ADBNPgPqWQFLv4rdLpPEqWDQu/LV01
	4Arf2dkdXbaAXoTMUwuiwKWuTi6kPLqeuBaCHOnvP64coVGKakxCpcbXGhIzpwl/
	pnR25tBnp5GO2xwcDJmk/C5gV1/NgW65mHvfHY8fJK9U2Yuq9+btBFOSetU9aKwh
	ocSno6Xh6w+AoIha5R3SZUtflMb5TqwZySmAMTOmFrpBjm/9ScodH3seR4b+d+ur
	Ra11V+9xPtKg5xarv5HO9yhFZrzAwlb0u4Kkc1GhBlSCocGWdt5ctE1A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wxt12umm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Aug 2024 16:15:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47FGAJg8003460;
	Thu, 15 Aug 2024 16:15:16 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnb7e30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Aug 2024 16:15:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wZ8jqtbLbvnIJXeeEHbfNdvM3w+Svldo6R4U+pFZbbXZR+PXRiF0GgvT/cy8pqG7GNY3sI7HzFeZ4+Y9g+ha9q0n8Lkti605RgZ342DMrhngRueX0o0uRX7CVE1aAzO1FnYuzMMmXE0ogkUKETOJtHhq24X9fH84BWf9QgXVkAFHb9XvYfZj9Ve08g1Z1HYI0lwmMsrvmnUIViDdMc5E4IzSmlpzItNiLxn83ozMbA6xaGggAoLk++K22imFD9sPPBC6tzlXpq3+wSi+wXa31dUNtlZi/T9aqppY4itp9sLmfOq6JK4751tD6p4B6qTwchagLThhbcq6jRB/OzU3gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJB0x7O8PN8j3jG0QV2F+C6Tr6BpJbtyGOxY6iSNjJQ=;
 b=NjDjQ9oFexclpnFULzMDyjk9n+pTwTNj2YpTFAkd3Za5XJcGjaVm/cfs78wxqnGJLuylG57RyZuMqU2ayEqdA7uzJU7YWgyejf03V9br5B0SMOjgjMtTJ8bmnqkuQHrIJ9x18jb/l8HVN3Z0b7ba7BFtcabs4qodeAPxSCBFhh3IBbMQSU5cWQHmGF0xFC+afj1WgOsKLmZUo0L4zw85+fjryqeo+CUqKr264DVwu3Ka+5IkpAPyKucBnhJ8Ynmp7Y1pd3OIO1BaKn/Xc4v6oX4Qqt1pc9HaXz94xNRLOxnw6+mCi5kUQ43CG3yIL2fm04bQ+Pm0Nd3F1eT0kJHang==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJB0x7O8PN8j3jG0QV2F+C6Tr6BpJbtyGOxY6iSNjJQ=;
 b=QKmdOKmraPWZE0NNaOA/I2ODYpnQg5GINzW58FbLEK2WyhWEm9/9U4VzyhdFLuBA3EkNNgfAZh9RxylhZu+G6AAlI1NEl2kDvbFE5U5spZTwmmZ4uhxp3OEOZ2IHAJbQE0tNMqolPoLpXjN1nhVgCPv1tgmrZXnxSJe2R7RifLE=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by DM4PR10MB7428.namprd10.prod.outlook.com (2603:10b6:8:190::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.10; Thu, 15 Aug
 2024 16:15:14 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7878:f42b:395e:aa6a]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7878:f42b:395e:aa6a%7]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 16:15:14 +0000
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Conrad Meyer
 <conradmeyer@meta.com>, linux-block@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC 0/5] implement asynchronous BLKDISCARD via io_uring
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <cover.1723601133.git.asml.silence@gmail.com> (Pavel Begunkov's
	message of "Wed, 14 Aug 2024 11:45:49 +0100")
Organization: Oracle Corporation
Message-ID: <yq1frr5sre6.fsf@ca-mkp.ca.oracle.com>
References: <cover.1723601133.git.asml.silence@gmail.com>
Date: Thu, 15 Aug 2024 12:15:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0709.namprd03.prod.outlook.com
 (2603:10b6:408:ef::24) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|DM4PR10MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dfcd643-253c-4623-2ea9-08dcbd4571fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xXzfpQ1MzH3rK7/WZPg0/xpqUsdd55x6rDfbQEEv7i081Yt4F/YeHN0Rl0Va?=
 =?us-ascii?Q?12mnqeH+Ywe3Hd/fGWX7afGz3b4malYAJIfZL6agfmJrIU8zs7PgPrJycaa7?=
 =?us-ascii?Q?1MNwXOFHnH6JydSfsiMxxeJ7wE9TnmK2snqz9bnnVHv+BiPUM86AGFY9mb3G?=
 =?us-ascii?Q?XkfeQ5Wi5tFbSB0FrdGKmowVdMoohnuvg0tykJFwx81+UZ99K7cH41bLp9Y7?=
 =?us-ascii?Q?M1+V4u3k1/wxMxwxiFmaikMd12B599cBCviGq2ohPEz4Ppvbn/s+7CtD24YI?=
 =?us-ascii?Q?hsIL0kWGkt0S57mhr9PZAc7X4oFdEACVXYVCzDAn6c5XIiERF+mxEQ5JKB+X?=
 =?us-ascii?Q?9k0+Tr0bC6wk/kKCUa1lZlw9tY6PUkxtjqYWit95DIVvaDxZqs15xLwGmJdE?=
 =?us-ascii?Q?M+Ucy0mxAD9rSYBu3m0P8j9mIp20xMio1Qqw77nEx/qN+b7322xNnYmIG8bc?=
 =?us-ascii?Q?gnSpd7QIu7qEusEYpelF4PH2GEnJbjEF3GyxvqhGSD8gZ3BCqFjLR2Nvo9+P?=
 =?us-ascii?Q?xWkeonjojhvmbXYYkdMP/4mfC+1pZHPIMRrKFkVAJR4KHpoAI2rWQxwMAcgv?=
 =?us-ascii?Q?5VA93eeOuouLzhb5afz5zsrCPMaWHORPQmImbGzmi7Pr8Ls9W1/aSfmhoY9F?=
 =?us-ascii?Q?KN5KLSOHcSIxH6F7zawztwMSaOW5yjIRbKjKOicfs2J579cG0IOnzigKF7MH?=
 =?us-ascii?Q?gD8WPIgw3cfkG7xR7w9V9jz/BWtDWuPLRQqJwd2lDgXU7oXXPA9gFO+cGVI5?=
 =?us-ascii?Q?Z2TfVjDUH711USs8B6c46+CAcbtwC41UySLrodL90cKk3alM8zx33cmHiEkc?=
 =?us-ascii?Q?da9lxxbIuquDB/pUBgOxHTFfA8wPcQvlVuEoTM88P3+ZSrOcdVPXtiiPil3v?=
 =?us-ascii?Q?GQhCh1MlgLuNZ4oXzUyC1CwHvC8255CjBnqtO+G7SCY6HIXUek5o7j5POfvO?=
 =?us-ascii?Q?eS4qljtRk/C8bYoxfTDuAu1LcJfLMs/P/r/skaPcjvx/T0+70hK+ki7RZIXd?=
 =?us-ascii?Q?yhuoElL/Mcw07wyo/WuXy4TiDp6CnNZdHDRgfWHjE5jaSKTDmncUicl9/eeg?=
 =?us-ascii?Q?jg07UASWbp3JdhZuUo3mb7uS/4vMXbkmw46eYTfinafeZgHL+dcq5KjS7BIp?=
 =?us-ascii?Q?WJiUmju21msJCJ8P0PxgaP1EKY6FuT1YoXNrFGs8pt/vhIJRYLMgjpn3GBE2?=
 =?us-ascii?Q?jZWXR2q/sNlksQIszVdLhRRW/y22JdpzNiBMJzfBBABoVxIVNeGcQWOkebcc?=
 =?us-ascii?Q?8j3GdBCF1/KDV+0I9xzmPaohJCzpBuDy1QaGCydSChxrb7zgnBm4oP6uFy9Y?=
 =?us-ascii?Q?mfKRwjg19HqHlo5+omOHBj+kBuB5BK+HbjgZHvsB8Oj6ag=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FIcJW5pjgoyQhoMfpMhST42Emw4FrBs42vxbV95ednGwVFID3HYi/pTkUNyd?=
 =?us-ascii?Q?EKKadffS+MBJZuK1pII5a6fwe1aBbXR9ixHhobsB+XmNQvmpQTmc9513oL6I?=
 =?us-ascii?Q?b+m9uhJyhLTwnuIkvJ60ICAISrQCEserzipNtEvly3Qcq21SGb8Ofyiv3a+o?=
 =?us-ascii?Q?wb8wWgSuZFE5QEC2GVZeYq9kCEWQTh8IGRGQlPnDEAgpe7pZfro3S+t/e94F?=
 =?us-ascii?Q?b28RdQm0JnOGjxBrN8+zNcxfp5/aGcKCmVjut3RI+PZeqQdk/e/6aScdsvvP?=
 =?us-ascii?Q?bt2GuDxgBehWqKmrQ68U4NYa8rYUR0/QchFOVnZMyNFOdFZSED/r082/TqMT?=
 =?us-ascii?Q?pdWd1H2qkh/saQ7MSfUqWZmKKmoNkfX6eBUo1T6ukp8VgB4al+Mi/T8PqXV/?=
 =?us-ascii?Q?RKZU4fO7891nLfmTNjItTQCpq/sS5pOCYIJnWzFLvWBhy7dAo3lrGvAS6+J0?=
 =?us-ascii?Q?ozpsQCE3fbdBAEz57W+MM0QHmhdPPfYkh34w0cmcV8uQMzjfiKoQG23F1GE+?=
 =?us-ascii?Q?L8EzRhW9eK3QMHgisfKX1HmGApbop0LY5JpNPX3ayNOR/cIAAIZ6FKSwO7II?=
 =?us-ascii?Q?ZCapBq9ZqYYNQFRUg1/Q4EmYcV6fYmfu8c8lpJNQLwj8baqoKmItgRtmP+ro?=
 =?us-ascii?Q?0kAXsDKqPD/gm+4UwEjF291GU+zEqALZOqH02FbmrTbAAC1zItkkCHbdPX4L?=
 =?us-ascii?Q?iQp9upHVxLQ7TWOdTvtEm3b1Dglyms1ciuzHrGAKLtX3x5lBvHPHej2a2L6x?=
 =?us-ascii?Q?N3izDU46B8nnN9iT/y4yCeTnKWqXXCp7ivDKtf6NcWuhBRu/i+V5jRkbWKfV?=
 =?us-ascii?Q?U7AHcbwIdUtG1k7ilar+f/6i8hw5DGKsqZm+FDGCmN/4hhJvmHG69USS1v5y?=
 =?us-ascii?Q?TDxH6GarOgVZ1HUCT382Cd6DfviKEkhkee7Lzoty9FPWHuQP4yaFr+jNfos5?=
 =?us-ascii?Q?hNMQ0OoRRk4xdrkhZfuTXOkrnLEpVWL/q/Cx7dezI21neUUWqEURUCVuE6Dy?=
 =?us-ascii?Q?a8L/fi+4blTVlAr5u2TrccSSdSSTFw9QXofUG+Qp1q+6Hw/+P1L3zQzu4YMq?=
 =?us-ascii?Q?/4NzT78Z0hlKDE6VsYk4vkPQ/lnbr46gRb639SUhGZS4Ib452eVXRVCWOwO+?=
 =?us-ascii?Q?k7Z1QkY2lRV1zb5qAWyuDQC2K4RyqlaH2ptjOUco9y7AcrqF/cZoDeOcx/Vp?=
 =?us-ascii?Q?JCTiEwu+UfnIzvXECRDfU1Kc3X7IoiXf8KL+4F9RvqEvSzMEUbFs1WZ1ysDo?=
 =?us-ascii?Q?ELTKInd1q5BLlrF/DnOITIS8tAlU6WQLWfzmYUn5TncmgnsvYBzKw0AoBTEv?=
 =?us-ascii?Q?sf55fJ7/1/2barRS9fUYECqxUooFpIhp3PxVf9JTxX8fhLXnbKmFCbb1345f?=
 =?us-ascii?Q?3K4uRGlP7l7kIQ2rmCWmtGynDLABL3+urXjuGyEIks5UDLs08SsI9ySi0eCv?=
 =?us-ascii?Q?h/NJJPa7KAkEoKsR0MMqHh5G+oo2yyLjq+EyKmYYrglWFsMph+Ky5eysYS0V?=
 =?us-ascii?Q?0Ttd2nFvan7DbkXki6Mm/R9TLzlxnAho/RGkf4ekYV303e9LsrjkgkHuN7nS?=
 =?us-ascii?Q?bSRmFvH3AxtT/r+cOJ7uJuJhKGIrM4buLR8B6XbTqN94Bhr67ei2FL3f/N3Q?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4MvlYdnKOX3kmvqvyrMHN8R7LRUXDIldf+Rd9F3abftdjnsRYi4feCf20e9dA8uyQPCZQfAAiLKDL74NQMnIo2+BHD+NUKS4xparAxTs7NES8b1PiispMuFdRcfv2lGD+xAbzZL6FpreK+y1WkaimmeQ4EPvOtv7BBLbhfH4vFVBLXUf+bNHmsXOVK1LkrdqCrC4ClMb4tnUeYSZnBdbcLUBsSyTKQg10rPscKwC7e1GQEQDHEeAUfuT6mWtO7vzCAwO2bNHubzxslOF94k+sazZRA4mpvisuvF74GJfV3FrDdKliFfn64L/SOo6axkA6DcPCwzBztB8NKtCqILi9yTy+ym1W3qevStONklPQRmip3wa0kytFstFOiqG+DzWvNSOzXUG+urRv3/KnGzFCehDKwOxqvTIfY5GWm6Nv7YgqRucqSGnWYvwnPLbmo22Xb6YxbtrUBn5MOMsbNuoIihH36MAs0AYY/FtHZqGUaXJG4oD6KZuGmTQzbngE7Ivgy/+QhWKZjpU6+fkdjM1jMSOxT+WhzpXTVXHD2RiE8mrm5f8bm8rdul7uoVBMoxOmdcA5XSt9dQ1OLuVNYKXwTp0KumUrTOVPtKrDcU/Mb0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dfcd643-253c-4623-2ea9-08dcbd4571fb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 16:15:14.3209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2ogepgHtwOJcDvsvPt8hOe6WG9ElqBxuu/8wutI4t2IBMtt7dJEiSotWCyb96YAqdf8xmYwGtn2nEz2O0ItsqJ92jrI8goPW+oCXm1G4Zk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7428
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-15_08,2024-08-15_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=482 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408150118
X-Proofpoint-GUID: XUHPPszmQ2RE5sta7UoFNgp5aVybXj_R
X-Proofpoint-ORIG-GUID: XUHPPszmQ2RE5sta7UoFNgp5aVybXj_R


Hi Pavel!

> I'm also going to add BLKDISCARDZEROES and BLKSECDISCARD, which should
> reuse structures and helpers from Patch 5.

Adding these is going to be very useful.

Just a nit: Please use either ZEROOUT (or WRITE_ZEROES) and SECURE_ERASE
terminology for the additional operations when you add them.

DISCARDZEROES is obsolete and secure discard has been replaced by secure
erase. We are stuck with the legacy ioctl names but we should avoid
perpetuating unfortunate naming choices from the past.

-- 
Martin K. Petersen	Oracle Linux Engineering

