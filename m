Return-Path: <io-uring+bounces-2291-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3186A9104BF
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 14:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C00A6285D45
	for <lists+io-uring@lfdr.de>; Thu, 20 Jun 2024 12:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE3B1AE08A;
	Thu, 20 Jun 2024 12:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n5Htz0P3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NMoPTl8D"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33731AD9E8;
	Thu, 20 Jun 2024 12:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888107; cv=fail; b=kaNKa2NI5MYr5yJ/Lu3laHDhr31OCHSEcjRhgdMbHkilAf+txizSiU1GXzSFyMS2kHgOVHLU/6gqKdv9y+PUKZwEGfMlhbM/+NR7WppmmAd4DAsCKHFRzioHCBS/F8qePhsMAxbQzulo71hd9z/elQoNvREZ63pZFkX9oFWbOMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888107; c=relaxed/simple;
	bh=XdNb9+NWtHcWOwBUHldwOEbxsQY4ezK5KAQlud9Tbvo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S2r02FUjic1OEea/+3E5Cm68C+KPpf+DSQo3ZMkwOwS6uyIUepErZ3AeBhT2je2r3BpsYtvIx4k4kClnJ97dBAjntC1qYC6pXOP6zZ+NDwa487ZrQRYUF9jZ252uf8gT9fW4EpJTzPohyEXQUHMD9Rqab328Li7k5ZPWH7S1YrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n5Htz0P3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NMoPTl8D; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45K5FMok004140;
	Thu, 20 Jun 2024 12:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=VAoiYrEgQ/W8Jzh+zBX7f+UGG9sXdcgI4ZPcNCD9etA=; b=
	n5Htz0P3gLjMPR1EXS4lqquDRUSMp3k+no91CQpppFAVf0I7xhMiKPg/B/mQbMpK
	EP98Rl5qCjkz3jey0WVP4IOXP4xADqLGQEtbDKWn3q+Xe4NPnHl/R8cr7qBTbqwe
	87/ZLdBbAHaoOPqap/60q1yY42Hw4myI+i1cxM1rhULuB7ifLrFwuAYJg56+X7al
	J7E8xz15hJ8TEfDZtya8xhnICJ5uzRzTq3MZ4igWGKGftpwdIdbl/oD+in5Nlys0
	u4pIXpj9fcajfa4gYiQ9OScm+dfKf1WkjSEtbL1CJ+bTg6zKO4DD6aI9eG2iLR7h
	cQQthKJKSUXm9huusBBbSQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9nb3mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45KCbFx1032811;
	Thu, 20 Jun 2024 12:54:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dae6hc-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 12:54:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJwzptt1rAK0dfz3KDQijqp+UxBOu9QdAz4TIW3HS7lfR4m81Ud8uRevOj34oOFjTgB+tIRnK7/LreQakiyB1KL+EEciVC7MODpzWQyx4YGX5AC9n6EFqel4vdanH5tO3+hg6z9DA6JfbJ+B1rNryjuegvkGXxyCBLGNoSqyBdxOpltn5iIPUH7xv6we/7HBWTqTExKtSbVTNQMhHzFgPIZ32keVpEwdtC7zDkJ8wWCAPysD8VQbAAVyvqmmZLSs/zvHAfRu0OwcSjJyKbujKpii6yjPigNO//YppaZlrodcE3RCdTHMYy1Tn+WOasPKUxVq0VRSK3bLeE8rsGnK2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VAoiYrEgQ/W8Jzh+zBX7f+UGG9sXdcgI4ZPcNCD9etA=;
 b=FSgChU8nVjtfTVkWGiNlA8OA/4Q1uRU//HFlvACv9PK6N4i8abdOGv8EMLj+54SnOiJbfOAhqBeQwmhXZXH6Bs1c6BW6QRtRShkUHqVKxc6RyujqdQXaWnQ3KsdeLduNKSm02F0hX41WX44iOkwmM+/FziClZsGTonCtcfllZSA+/UdxY36mwmzwmo4L4X7thKJcenl81YLKxFVf8VpxG3Dckh5ks7tPtnlXQniTGSWwuTvXa3thfT7UyCv/fGjhBNSUSs4POIKK006+2pn55eWIwRfq8XGWTAL1PrsIZLmum0g6Xy88zyHpfJiFNJUqxZ3oen5y13JU5PPGKBueiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAoiYrEgQ/W8Jzh+zBX7f+UGG9sXdcgI4ZPcNCD9etA=;
 b=NMoPTl8DBmrGqT/wOmi6Ri8LUWYyCS/LQJ1M3i8dKsWFC6StzWoqralG/65MHg5BdaFW9/eq1ZlHD3/YS6L8YyztANewx5GjFgHqI0yqA+/8AJGNpY5lFvlr+UE2Y1vEfbd828caEYXlhEwr65zLOySaSJ5vrBle3xoLaRppmOQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB7695.namprd10.prod.outlook.com (2603:10b6:510:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 12:54:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7698.020; Thu, 20 Jun 2024
 12:54:33 +0000
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
Subject: [Patch v9 06/10] block: Add atomic write support for statx
Date: Thu, 20 Jun 2024 12:53:55 +0000
Message-Id: <20240620125359.2684798-7-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240620125359.2684798-1-john.g.garry@oracle.com>
References: <20240620125359.2684798-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0029.namprd15.prod.outlook.com
 (2603:10b6:207:17::42) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: 34c998f6-9695-46fb-4f64-08dc912821cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230037|376011|7416011|1800799021|366013|921017;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?OgMMPEHeCtJ/wy+/J6D+pXLmU2Agafk66lKljmCi/i8VygBEIe6r292ZxbLV?=
 =?us-ascii?Q?EPT7y0rjuothZSCvB1o6OI4s6xYJ2XgqXq6Gvkqt055fhRZu9S4b5+4tNPcO?=
 =?us-ascii?Q?7FOHVKRSH6OvNOlR0FzFFUDPyDnm1g2hr/P91vCiCgni/aa4rxsKQo5gKg4k?=
 =?us-ascii?Q?k8+ZN6xZV7HtPhahf54/0hGuXnYzQAgIbuVs+n2XAX5Lz9cIiPdTDNHJILDZ?=
 =?us-ascii?Q?cBG7gRxafKp1gw/A9bSLUS9uCTUigFBUwKOEKY201ikH+99596tdSPgZKmzS?=
 =?us-ascii?Q?W77M7l2JhIe+dtJ2OM71ZsvQ9DGx4sgqO+9M+udk7qedMsL44qp/9u3+Cexl?=
 =?us-ascii?Q?6HXaSOBCIaAJLNg96A8Z64eGxvDrcPAkKkvaA547oYRBsFzUOD6DPwY44xnO?=
 =?us-ascii?Q?ExcRmN5VbukO7Z6ZXUt8AFx1g25R04mT8MwBxSZWENe748evQGj8pYHUXDhO?=
 =?us-ascii?Q?FbzzkPXNt9Gd2F+qn8S1VJWZCekLcvP5uEADJYCtRbk3R2mtSOlJ2sBvz4nI?=
 =?us-ascii?Q?j6VTXQUkv0VyGH3+U49L/2gxQQRlTg3cpEKFHVyCHrXLNuH0QPJVHNBgr+jh?=
 =?us-ascii?Q?yFeZrEjFeSBVT+tsQfTZQWMYfyWhuvFhwkSz+V9oiynVS1iBWf89gnspVQey?=
 =?us-ascii?Q?1mzAmV/ISoPiQo9aGKVW2hNtU7laWg0cvlC5+i8DE4rXRWG55aCBGyv3u4Bz?=
 =?us-ascii?Q?VH2/JixwNrm+2B/XhQ6BkIs/das0zB0cHuLpVEQmO+mzfjzVGuvQSD+8XwQI?=
 =?us-ascii?Q?0wyLu9xxNxWOR0aADNR/wxKh5I2Ncz/6wXHJkedXbIhGO6BKtw9frmCxU40c?=
 =?us-ascii?Q?/fMO+vb2j7AB+ensKREMESo9uVoJMuAFTN40sx/xyE79IMZdCRgINfZiHfJ9?=
 =?us-ascii?Q?JiclDzY+Gjy/x3tt2dEtphYwCfieE6DUE0Z5jmenB9IyfdEsMeUn9DHUnmeO?=
 =?us-ascii?Q?9dME55n9FB+RlkZmsG5Plr83ZU5zcKpgZmPquzr8eo+wU+uphQocdftjI1kY?=
 =?us-ascii?Q?KzSoUPYtLEyjmr2Chtz05GxxwjpQKNv000QdpAG+DJCxWbrulDqcCiKi7wl6?=
 =?us-ascii?Q?TyQpgLQIbiG6uRcwn1t1j+E+UkCbMmAXZLTvcHQMujpz44RngNouD8jqgqmM?=
 =?us-ascii?Q?z4grjXIwQBB7houPahTplQMIFqkcV/hchpZvNzbDV2hxnYg+wWhf07swXAo5?=
 =?us-ascii?Q?iP9Y2GJwLM78S3w74DgX7lvXUhmHgPueA1Eq1tkuOXF5VeZXG/LJyGO3D2RV?=
 =?us-ascii?Q?6T37s65bNsWBc+3HU29J5zNLI32Hw6plGvQw+/L/ibzqpnZCrjYiJwm07CAf?=
 =?us-ascii?Q?LpfYIuCuihvC1qE+cY8cCUQzCw/JoDolb1Hw050JLXT4pIsE7RhOO+TW0/39?=
 =?us-ascii?Q?Il5myjg=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(1800799021)(366013)(921017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?btFNfDaTmR2jgPEpFEBIG3nmknroVfbqWdiNo8XPYE48pBLzdOrX0rEv28Pl?=
 =?us-ascii?Q?wIz5163veGOemgHhRpIRpqzA1NBbU0vLWXO+jjPyeJKtORSAutXpST9k0YCg?=
 =?us-ascii?Q?rZePLWVEsBMgl7e5+6Es7/H8yZWMkEPUi/VRmX74P3jYEnioPNTi6wBJcCek?=
 =?us-ascii?Q?f7HfdMVn9/0lRDvmTYEvwF2bzt3tOWSoSpqC1Uqb9bM+7tL/cWEtQ998VNmX?=
 =?us-ascii?Q?9I1ia27h2SjAeGKzOEKmfNGlNFsnnzWICpO5lAqyMKUHmYADy4XYKKO1zGDq?=
 =?us-ascii?Q?hyim663W0WOhJ2AVR7vKBjxsPWRudyjOsVdLYjeYgX9Q0jZ5/AzFnOb9G1p3?=
 =?us-ascii?Q?ex28fedAxUnU9wVaeBcOSxEe+HA8TsO7n/GyjIg/Upa/tD7SzGN/laWKjcZq?=
 =?us-ascii?Q?9a/O41rmWwFQhP41btWH7HUn0V4yz39ETJNhPMahibOIyrUffa3D7ku6pKR3?=
 =?us-ascii?Q?1qrfMpz80w0ernsmVNNOevPPIs7x9v9hTQNLdZX24EbVuEBqyJUzINoHntZG?=
 =?us-ascii?Q?Pj1Z1jHcRQKgwux9W/CT/isbxJzB0yME1mUCfLvlRswHBvQSm5IRUfrsCGWx?=
 =?us-ascii?Q?P6JO3AnwkC5Obp4pdk6zKiv81af6HIEWSMUChC6Y23A2PBLO+IiuHCNkJxdh?=
 =?us-ascii?Q?AWgaX79u4uKpRt/tXQgkBqVOaQUpEPjj17r5OwD2dh/PrKWoCLlbA40xM6Xj?=
 =?us-ascii?Q?ewDDg7p5xk5ZRtMJ02ifBYuIo/AolQqVXlmXR1nR/vEbYB94EpFHVl4Vt42f?=
 =?us-ascii?Q?KqVuou/PxVNZxE1D7JTlXwN4K19M015duJsr+SVlvcM/ATSGNzMp4+kKiAo2?=
 =?us-ascii?Q?tQhiD49E3J2ayQ1WM/L5dT5e9CNH/RiesoAqvUWK/ghI4FR8AZ6bEVO45Xpt?=
 =?us-ascii?Q?/KT0rJ7iZnlHckYITPNCmVVoFvROSbyI5hlHMCbWIn3smQGumS05Io6e9SNR?=
 =?us-ascii?Q?aI/Cldg9ay+M0QyTqs32hKJF2LhBHshu6iQA5EH75pRqzas+M2/y2LRTDxmP?=
 =?us-ascii?Q?03v6H7MN99X1oeT56/wIYEI+pxfjxGlxLnNC9eKAUaSLwOQf6Z/wXLFvFI09?=
 =?us-ascii?Q?0sNX1oOU5Ytw4Ut7SFp/fHPWkNqAu0szecW/P+euEbANle14Ti2HQ/v/ckGs?=
 =?us-ascii?Q?ppAEL+9+ywKxLvLMB0iDNcbYnw7YphGBS8fFcaX7gFs/t31TnsQcqq1+J5Ei?=
 =?us-ascii?Q?oWy57t/tNPoOcBXkfsWXZt/zxhxsu01YqW42paydRuH4to9HgLF/1vgRjrJR?=
 =?us-ascii?Q?YfUhzrNpX/CAcNH0T1GwPuXr9XVCpcLtfG5gX+UI8w/1Wpipb1oNiQRDAaIB?=
 =?us-ascii?Q?dxHsfEeUIKeE0cO3BprKspfu+zAiAKWXt8XYp2q+dnAAf16YHF3LY2hu7V1s?=
 =?us-ascii?Q?0Vz8bb6/usnnY5sFkVNr40SLsXKIRnX8++0+U8mKp3jn2+6jlztIYZcGplJW?=
 =?us-ascii?Q?a/BsDd4kTbXTx2g4QOq6QNgAGpJPyHrJlM+XxJnHSsdxoH36y2/ixC7lqxcV?=
 =?us-ascii?Q?qj64AxCFZ8e6a2+cwo0M/3SnKgt5R5cZ6WKFvB5kLIwVnmH6RnMOpGN1IxDb?=
 =?us-ascii?Q?kxUQXDD8xRnzz6SvL50Nw250CzMHHFXcKkjFyEjtwdugZVeJ4lf7+OoQ1VY+?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	XZ2DSCNt1dPRRo/NadbZidE3yNTlPNCiKj+/lTP9dLM3LEYXjbxtRYN3nAuzYa/7zw6T93NerlZ/3z/JmYxZL8c7HqhMxFGv2yc0f+qB1QJe1seJF5HvzTE7+pvBwgiJh6NiUslJeFb1HZsPtphzAVs1aOnFsawXBtY2ujlv/YXyIhp1cXfWSP5Jq2EB4AU/ugvI5hcaJyt6UmVMrB+1HCLJFUvVGj+0+qwsv5NcWWP5tDuBeK+LzsQ/D/7czRbnTqoHtt04OGIQ+aOUop1hMuFF6cPGP+OOUl6S1XjzGHFfD/0bsIgTX4Eyr+FFTTiGEQkI1hKyH3uLVzlEU/orlB8xK1j+eCT3pv589QEiwq+cUPLd8wbkvYFfE1TjqdA6/cy4OezbvhbqqKYGK8ihDa9QBKsaqJvkgR2++0xze4+aOC9WazNIbWSuvbB6wCJIMmhuTVxPy6jAFDgkan9kaYFLVslGk3NBW84V/MOHrPfyDInYxxEKyJHm6/FSi77IkYE5Bb+8IulF2ut+qqwUAl6Vf/KtXITCLuJSFlKV6U9i8RQ/5hUw6QXS7uDTK3/JGb/5wh6J15co2WritQTNTYorAjajapgbEHBDf5g1OL4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34c998f6-9695-46fb-4f64-08dc912821cd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 12:54:33.2759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aNMs1bEDEjRhqrEr2tTDJXoaQ6q0838J/bxgQQLkL9hCTg2J7AjJi7pll6z97RSGzLWt6klazwDoF6HGeLCn9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7695
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406200092
X-Proofpoint-GUID: eUOhF0qUruTfs8oyDCSGQpmSDGNgmpm5
X-Proofpoint-ORIG-GUID: eUOhF0qUruTfs8oyDCSGQpmSDGNgmpm5

From: Prasad Singamsetty <prasad.singamsetty@oracle.com>

Extend statx system call to return additional info for atomic write support
support if the specified file is a block device.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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
index c0a5a061f8b9..5e024b2b1311 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1644,7 +1644,8 @@ int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
 int sync_blockdev_nowait(struct block_device *bdev);
 void sync_bdevs(bool wait);
-void bdev_statx_dioalign(struct inode *inode, struct kstat *stat);
+void bdev_statx(struct inode *backing_inode, struct kstat *stat,
+		u32 request_mask);
 void printk_all_partitions(void);
 int __init early_lookup_bdev(const char *pathname, dev_t *dev);
 #else
@@ -1662,7 +1663,8 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
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


