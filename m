Return-Path: <io-uring+bounces-2970-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B67789638B2
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 05:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6649B285900
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 03:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7661B383AB;
	Thu, 29 Aug 2024 03:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IlAV2Srq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YWAry0yN"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FC54689;
	Thu, 29 Aug 2024 03:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724901438; cv=fail; b=P5wjEVaH4SbAeLeaHGdN25jvSuRynIVf2NmS38ZSqrZkR40SSQOCPxYp3TD8/J4N5wSAMayWLuZGyFYbmcMUrNySAZIN7DpQdU9cJMIAfI7vf8mFV4GyLaKwyctrDNJJYTQKUZkKiCkshrY9z1XDwHmZM5Eox0ToDnZp7gDNqfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724901438; c=relaxed/simple;
	bh=+x9cibudK398V3kngIvh9tgPvSIGTmiIAwE0npoXwvk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=i64h0efHPpGXB6nkrSeov8p88nQrmUvRJeboGqeUDJJ7xB9+cQDnWAbQza/AgAcBCTSWKjB9uaskHz6z9/hHwisH2NYmJCZ1qPM0wYonFrn8XzkRY2/PTo5ZuzmUl5HIvhZ8qil9elk4nLPkfPNDmZePYjSJDqTuP2qJiM29exI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IlAV2Srq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YWAry0yN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1fZBI028737;
	Thu, 29 Aug 2024 03:17:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=2003slHWiLCjrR
	QaKFQdzO8VL3nytMRvKpUJrfjP3QQ=; b=IlAV2SrqnE98ozzAXJqCdmN0+3ZdnI
	PycEbjLgT/EvgzS84+dNuZ16BZdxT2cC0p/NfTTEtfTPcbSXn2ogFE3Z9f/92REI
	dJ+630LJuUroUh8qnzGDpQ/qv1b8lrW+5XCP8QyyCc/A/uUtuljElA/L2sMl4KfE
	E4xW+WWVh9DiP7+PKezexxqv06OrB38cPvyuX+68Yrr1me3AnbxhtxHoeW1fJR7k
	iqMEnYeo7dtRnQKaINiKVNfxV361DAShluyigorrkGm7l7wjyL4tv3zyTuW55Zvg
	ueh+VOdp+otAqJ/0R3ioFlV4oYuTTUVF7K91wBczyi+gdmpxewNzoKbw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pwv35su-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 03:17:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47T1PYom010507;
	Thu, 29 Aug 2024 03:16:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894q5c44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Aug 2024 03:16:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ve329Mr2B4kV9++56KbMeN+e3g/RSxNYlYwLJ/8/PwwLnW53qJYG6vKdeFA68tF6ZOnF8dm3AjA3+XGGIQxZMLteXIDpCLPv2dt0BV0KSVAZ0ubR8RMuhZwzXq/qo3DPudqkNBz/k9MxpU1JkUmWpEGyKZqme3cyCq3HUVqxxcCEG8I8Mluc2zXvK2py0RXvm8NVLhQPpOH0jOhnWMYw4vjQtyXvMHBMyU5Bh21aPr/MHemxmFfKjN2hW+Zwqb2e2rxnDwcQmHWjHShE80bhNxTYQvRq3l/6LMbQvZYuoaR15HZlEPfyOZVG4LRijmlULqDq/UBj1bVLu5W8qZMAWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2003slHWiLCjrRQaKFQdzO8VL3nytMRvKpUJrfjP3QQ=;
 b=M+fopIfTiIIEbutdB8JDnHO0jcxHIjrtOzqvwUHHatFRI3qopIkPvrr/54aQ4ZRmkA7CoFDXv9Rp7a/UetRFt8YUeY28WeFMPucut0uZm0ObcK3zuZTTgvl/f/YuOA3XEzTvn6v2ub7bo/UApn2OZdygbdo/6nM/4wG1oYL8nwpWkMUtYLiCDC5NnxhRio/SuAr3X+BxQFsAIrR2LBXupIAbG2UoTu1HQHgWJfDcvxBQ7Whn7tiaTlRLGFd7DhBC7t/MZuCNSKVrcH0Qn1VZys/2jPhv/DOM5KYarJQKeNFS90cKE3SbH7+fc58iBndwPQiZ5jJ82fNJBhRHQAkKLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2003slHWiLCjrRQaKFQdzO8VL3nytMRvKpUJrfjP3QQ=;
 b=YWAry0yN1G/W9LsszEADo8kZVvIU60zqVt1HmM7qr0ANvyixNMpoaJBZHunSa0jp/2ijX3kF6V8UFgnHvL0yosAP2whfGI618mMR9m1v0ZjsiDfUxOs87d9cRUdT+IQI4Wmw23/nK3+yM1w0RZb+qdwfFxGDMqS4DKu71GM2LCU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6212.namprd10.prod.outlook.com (2603:10b6:208:38c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.11; Thu, 29 Aug
 2024 03:16:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%6]) with mapi id 15.20.7918.017; Thu, 29 Aug 2024
 03:16:57 +0000
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>,
        axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
        asml.silence@gmail.com, krisman@suse.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <fe85a641-c974-3fa7-43f1-eacbb7834210@samsung.com> (Kanchan
	Joshi's message of "Wed, 28 Aug 2024 19:12:22 +0530")
Organization: Oracle Corporation
Message-ID: <yq1plpsauu5.fsf@ca-mkp.ca.oracle.com>
References: <20240823103811.2421-1-anuj20.g@samsung.com>
	<CGME20240823104629epcas5p3fea0cb7e66b0446ddacf7648c08c3ba8@epcas5p3.samsung.com>
	<20240823103811.2421-8-anuj20.g@samsung.com>
	<20240824083553.GF8805@lst.de>
	<fe85a641-c974-3fa7-43f1-eacbb7834210@samsung.com>
Date: Wed, 28 Aug 2024 23:16:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0490.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c296f1e-dddb-420c-7125-08dcc7d90a11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hPRfvouEWUUfDHFeOZ2LjHIoDWivVYqJWzwBzsRBbe19RZVx/24007taYpVZ?=
 =?us-ascii?Q?n8R4mNED1dkU1gY3XiJcXSSqsIutW916PIOBYk+o3U5zH7Q1BodBYg5eiWRf?=
 =?us-ascii?Q?wiWlcvp98wSqiskNP2RvAabPzt/1hGsk02LTIqCrcYAoYDS68WzkbPY3ypT0?=
 =?us-ascii?Q?99Opc9Wza3WCBPIKntfa0p66ZUlfvPFHq4uUg1D7ftIp8XMhmg6wvgClVGlE?=
 =?us-ascii?Q?QB4p7Re7nvgQ+8tLc6UFNJBpUwn9nAWCzUvbi2wUUkw8xrVAwKCvQIIqKo+8?=
 =?us-ascii?Q?0LDKlWY/5vLJzrFqwzZ21J+qT21mLMkZTwKDmeG1W6Ayuc2k7ZzegVGH24BE?=
 =?us-ascii?Q?OntzEoX+9uDQVgqBN2UT3/q/05e5EnL4NoCmw9+ro/YDhcuGB+Ya1h+uWUXJ?=
 =?us-ascii?Q?m1N64ola5MegXgTdGRCOsms9nuwcSMOkBLb5Rfws0Hbwahrc2bQ1Sdkt0bh+?=
 =?us-ascii?Q?4CP/Ht3RRCLDkyIToYI4KnJKOcEOYFca4IeQRVK2sqtfGUgKbfnTD5OETMM0?=
 =?us-ascii?Q?wBTq4IWCTH7NYa+xlD8oQCWaFTi9SXP7rTLlXOuKJjxZk5BydKWQgGpny5bG?=
 =?us-ascii?Q?jYZlHRvYGxNsIj43LyinPAK+nc+vuYVnvRpmw+PfFNcuuD8/rFDvwRDoYvvP?=
 =?us-ascii?Q?Xx2wbneOmTlpfHZSatXHhwGe3q8Lu33ZXvri+/Nbk1M711gwf+pEznWHH+Wz?=
 =?us-ascii?Q?txjy1KNGycko/uY5M6ZwoGQzGTRO+I1vXVyECKsHm8kBIZCS1e4nAdC9BLUE?=
 =?us-ascii?Q?wOASQP3M9EcNTa1JnGRqDIxzQNahpJaG6FAFs3ty89OIvM6CtuqC54vkCpLU?=
 =?us-ascii?Q?/5qjoY3JGSYMshCpNxtZ4IPgiaiRzV5t+7znfZho8i6nBtGx52aTvjMtiayI?=
 =?us-ascii?Q?/iQHGGTolXMs4IPHqdG1cwOk5U9zhSqF2i1geyoZ+WIS4FMto+hgig7DJ7UF?=
 =?us-ascii?Q?retnimLddqXHayWBxdfbALpBIc3FIK+iqUR0fMFW59sHTzequxB4O3nZdBQ5?=
 =?us-ascii?Q?8ha1jLzTTlZ1oIXPvm9etrw1idgFMybLedUObwfZ6D2p6GvAN1o14LEJZVqo?=
 =?us-ascii?Q?Km0Ytbrs9qQBqt3LRA6UzjWgm63DjiLnV+C80XYgkwEEI2lddLcqiORjCtF9?=
 =?us-ascii?Q?qUQGnI6+ArEHDRiSWw7eon7JDSqeuO6HY5z6AViCfG5FhIy/d63oSBWRdfKg?=
 =?us-ascii?Q?PQd23Gzm/4w7xHLPmMMSIf0CaE/DlfpjEZSYRdzqi7oeNfm88lu4bsyjqrza?=
 =?us-ascii?Q?so8oJkEEPY8WeWLPlZkmbXxaY9lYNdPoLZNStTwsKmfIIT9OIr9AzkV1mnH7?=
 =?us-ascii?Q?pNB28UPTCjqAuMexBUIsO8aP8A6o0hSqAKylKnpyprz/qw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yaFDU9TgiJvCYCeITHsoJdz6fJEMSvamipEI+RLvSEGcUFDkBUsGNGm+2GSE?=
 =?us-ascii?Q?jaWHuCM58ZlU1ds3e+YgiH7/PLke5yqOQrp5JDRRcIx8dgbgx27J20SB7+za?=
 =?us-ascii?Q?MLJ7LDYd94MKbryfJ0PeQvEmAuObUdeisSIfOyxq4vBfVVpY9V3HsZsD64Lt?=
 =?us-ascii?Q?A0lcDj2mhdEeIMkhkpPPdGWdiiB5sxKFqwt6Q55Ea5Mexya/TEDaccrYZ5Fz?=
 =?us-ascii?Q?6IM1Xbp7jhvg/34lQTrww6O4I2/cPLHDa3MddG+1eO8ki8/64/7vrzY4AmfA?=
 =?us-ascii?Q?kfTqHUd3x9TvmESACLAfqGHmd8vOQekvcjZeenmWAJQBa3tPVqyKuj5anwb5?=
 =?us-ascii?Q?FI5bQe98Mp/kAkG0rOpa5iCqHUkfxs/+WMgqeryRwaJub3mui9ra1ykAnMTk?=
 =?us-ascii?Q?ABZbQC/adGRjz05JbxdgHXhlBAMA/wg8UDcEChsjQGqooOGZyr6rKMCaVmIb?=
 =?us-ascii?Q?IFp7TaR+KuQiuS+TrmHRFJ57iXMdAQ1ngQs+XN7XBzKoD4fWtXTyRz6nv76m?=
 =?us-ascii?Q?xYyLGYUS5pkNNUmvu1UqINv/TKDvdPnob+Yb/KPAeE0LVh+1nzeZPiZ+7Veu?=
 =?us-ascii?Q?hlB/16O3kTIcGPyyVFnORc96Lh2YKoM/nX4Ebyy8QU+sYp3hFgKUApxcEoRX?=
 =?us-ascii?Q?XlWmhrGzrBdacg8lPmMI6iDEGa1ZO0ZsCYUS4bJyRGNfFDOXsvp4LIZ1p6Sl?=
 =?us-ascii?Q?540Fd/X0BA/9bs0mQtZ2qroBiKWN+CX3ZY6OzLp1pXdl3BfrB4O0lpWb1GiE?=
 =?us-ascii?Q?C6ZM49Q9hh8/CalU0W26m89LqbW1jJvNJG/MoWAIYFpOIb9n0vwVUO+Yvxxt?=
 =?us-ascii?Q?9pVj8/8yqne6nisJ3RAfGI0GGyyiH1yOjLFaKarIt1LekfrnU2LskxhIKu4R?=
 =?us-ascii?Q?oVgY43x6vGSBFEORvwEIdmfUzZk5BhXJvUntbcMmnBBDnH3lcLBXtBHArOz/?=
 =?us-ascii?Q?D+xq5/t1DUoUeh0PbJqG6zNW7VYsKJcGizWGNjl9q0zpaN/YZ4CuO0hqiiG3?=
 =?us-ascii?Q?u/JRtdn53sdP1u/fhErHIkvYYLQYyc2k+MKm/GmtApKNesiPqSVQAwFEp/mY?=
 =?us-ascii?Q?zVRpW5k4MlJyLuwtYhhmC2TRGlF+Pz9PWBgpKAzVbHqFW2cF9BoEiXsbORHK?=
 =?us-ascii?Q?GHUtIt7jJhy1EAHJ6SivAZRnXrLR8OFtQqPMFfD/5CNxk20qBZKC7rGHkbld?=
 =?us-ascii?Q?e+V2h/PAtWg9F0atIYvjmcRoc8kjF5NxjqZ08JTDCmKd8x+ax7o8joVw5GK/?=
 =?us-ascii?Q?9Zytj4n9lZJn87ifsQ/WSN7dxc5hDUYYv9/ppgPM12fU8+wY12zLz/0eZdr4?=
 =?us-ascii?Q?7ri2TK7EQUeGTGdsplulhj/XW1bseVfFygCzcNVvq+8fh09DgnZqFR36mhlz?=
 =?us-ascii?Q?RMThGm74F3tOJH0IC2SmEdtCl/WTW9f38NNjsKwVhwRd+aR8wRb42i2+nwnL?=
 =?us-ascii?Q?VWUm1urO7lWwGAG0gGQyMl8PSH60Po5JPIXGJcUNXxRb6U7ojQ7SAtNT08er?=
 =?us-ascii?Q?HklQaMRiQBt3LBJW3r8v778dGiowYEWZYfDUC7pxPg+AEhAyJ7oKxuz7gGMT?=
 =?us-ascii?Q?sEvEqBiY3IzOicED7JZ675L7ShmM+N+cijMOSauLKvqisEJ255Zg2A09fKeQ?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JtlWvL0kDZm0IySclMOoAhqBlFyl0ItWZyH0IlOm1M1ZzwHbFRSn/ZYENxTlfjeYdW1ny7JeaURBDUJc19fwMvM0h1NnW7hGREIP0bUPIWsV8k8dBk3wmMcTTVDbkVfpLH9SYMXwiRr7T7HVQTfqZyVB0AvoygbiS80EPBozamrgB8MUikJm+tA1pcnjcUgmtt0Ft8nmqKM0TO6hMoSjinaSCc00XqOQGmm/Rasfrm9rdz/gu7LjjyKA9Qgv5MqwsPQuzNVGPPgEgoPBPFcj/em4dbpnBG8szvoIfj4KBskuAgjBty0tD4uqPCmNV3RrIURKB2lSwDyTXgXxME5LW4ud+5BLkmv/vDI9IzP1W8ZEzzjn903fcN36ayHm8U6V3m3I50SGU/59+Sfzb9Upr4SG3OqEObTsEWHYrmt50IHo07OaSd8hHT9L9wt2IbQeJfXlDNxXghTNYU+qBAPCMrujYkxiy4dHh42wcss0VZRktv92OCbI1TOXl9wGE+1dxl0T7BFhjyr47YlUs0ybXRhEUnVEYGurGVfF0RffwUuZzxw7DZN5PkGBeVt1f9ihgWvEfdA3hIdi86LlfKlGGa9K8el6ID8j8Ob75KPhd5Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c296f1e-dddb-420c-7125-08dcc7d90a11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 03:16:57.2761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vstfrAbTRQ1OusHsXoPSCijqh/DOiLlIuVOvg6G3nTZMzLcAobGQpwiNMzpfV3s/HxbWsA6YaM+CD+V4e9F7H530Zf1pSGLq/dILZERVmwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6212
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_02,2024-08-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=604 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408290022
X-Proofpoint-GUID: QDIdY1cb1KI2xsF3XSjabbzhDxngA7G4
X-Proofpoint-ORIG-GUID: QDIdY1cb1KI2xsF3XSjabbzhDxngA7G4


Kanchan,

> With Guard/Reftag/Apptag, we get 6 combinations. For NVMe, all can be
> valid. For SCSI, maximum 4 can be valid. And we factor the pi-type in
> while listing what all is valid. For example: 010 or 001 is not valid
> for SCSI and should not be shown by this.

I thought we had tentatively agreed to let the block layer integrity
flags only describe what the controller should do? And then let sd.c
decide what to do about RDPROTECT/WRPROTECT (since host-to-target is a
different protection envelope anyway). That is kind of how it works
already.

-- 
Martin K. Petersen	Oracle Linux Engineering

