Return-Path: <io-uring+bounces-5450-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC579ED6B0
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 20:42:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03DA6165CCA
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 19:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A4E1C303E;
	Wed, 11 Dec 2024 19:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KCZ8fvBV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="TqGyTAFW"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D97259491;
	Wed, 11 Dec 2024 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733946140; cv=fail; b=MS2AUVBtO0Zp8Vi/d59/716LZu50zgsB8dEHmoErJRC2j6wH6n7YcZCPUL9kRt+mxoycnoNKueDLWVoT9N2WjcHI6z3f53vMOKks6MgaTLZ18ftKi4LWiOJd50UD6BdlqRQH35CzMQthsJVX2tOJv0kCAH0hJuA3wul4/ZtHUF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733946140; c=relaxed/simple;
	bh=Vm9r6LDSiarP3xiqZR1WOUAgjC70m2Sf9fZq7s2CaUE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Z7+HL5XZRhqw37/jFQSgOTps+8PTDSwNikSvBc10j7VsLM5ao7uBphAX2znz+rjhD0VKXVLNFBbHV0rTMSudpsILvGcgehtj2+qW3o3PqbYwYxrGt+nbVxH0eze6WyzpVHKO0t8icXI2EK+LjRs4oZAWaaoGwCiHJ8r2oS0Ql5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KCZ8fvBV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=TqGyTAFW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BBEMvs1022051;
	Wed, 11 Dec 2024 19:41:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=7eRxp+oQ7A04zTuohB
	840T+jmznNNpd3WrFKOHloDKQ=; b=KCZ8fvBVQbVvJrQFwWeBB0LpsLcXKXTYLg
	pc4GiDu3pbWavOsZhV2LSMDoQF+7EIS5XqRvZWl9OT50Iybgof7o9mCPbuICc4xj
	hW0w9kOB6CPlVG7/nbzhac0UuVP11JtvUkuIf1i8tTY09QTieW1YxdFdDHpA1yMN
	y6WRSwlflA2Irf2cz3aQ84NzePqufW/iXZ2JauC9a1w2NuFqMlQNggPe/Fj8HEoE
	iZFuTIcZPLjRTKfbl36VXOVxakaHlsZ6M4++ElhBeGx86xtpQAABqRa/GglL0M/Z
	c7i1anN5XE9icNXi53rs3uSU3LHO4HroNgtX4W8dEcrkKLCXtOdg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43dx5s6n2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Dec 2024 19:41:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BBJMxWE019357;
	Wed, 11 Dec 2024 19:41:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cctad4ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Dec 2024 19:41:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KOeB+KqUaxObXgIF5pN2iM7HW/DRlqXruIIlVEHcQ/M+NHO62bxA2vzpmrG+Z/jOJRkjTMxv8IgdzOSTyMI4fX02luIPhuq4fjXeWZ/8DttfCqn60/yQl0BD8gtqlcBIMatfbrLVICmtczcD0KPcMSRTeOpNqNaZiR7sv9R33iqS5gODJM80zQ42xg9cFVY5qwd1eiOdAY1LqCZRs5f3+++vesOYi82L2dEpMKi/IepxD/7B9yiDy8t7M9BilUrr7/SDhmOCTTXG4mblBcVagytW30u9sGFTpOXwkOh3EIA0Suj33rRArVCOGUpa9JRa7gOvuO3By2mE7LrU+C65Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eRxp+oQ7A04zTuohB840T+jmznNNpd3WrFKOHloDKQ=;
 b=l/8GRgy9Qhpq3aO48jepqJKl7whFcE0rr044suGhAOwkfy3rAibi3hQR35G63Mii2nqHZHAaS4hQnEevpf7RSD280ExcSC9/PplnZBv7ZE9SCqkKV0B4X3JCw5uXf6fjY34l7GVZABnM0zM2/1yN0xvWm2Scrc15v/Y5KqrJaRUdbYttjWOileATDG75NMV0nPs3CT6EED0Wzsn1RvrxCj+MsflZpdivi6zDYtmY2woEWaRZPdBMGQF5xXihcY5ve7Z+OyX7MsYOuaHibVvQPanC2cZkIN7n2ecAE6X5wLwfFwT+x5f1jK7w36SkS1D7zR/u8P7SHe3jmrmchUoSNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eRxp+oQ7A04zTuohB840T+jmznNNpd3WrFKOHloDKQ=;
 b=TqGyTAFWVbcV/1PVdIjHwwURXHJgWdR7teLm0569iD012IOvD5az12c6kdX268H+PKjP4/3zWJycVUDPCqWRgjKDOmSlYdMrOkwo7S+4i/dEr5t5fEz58dG25jB2xNSP5ZNuUEgrPv8WN01T+n4GZcK2QTZ1J/9g37gnR3BOBYs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4516.namprd10.prod.outlook.com (2603:10b6:303:6e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Wed, 11 Dec
 2024 19:41:46 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 19:41:46 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nitesh Shetty
 <nj.shetty@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Javier
 Gonzalez <javier.gonz@samsung.com>,
        Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
        Keith Busch <kbusch@meta.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20241210071253.GA19956@lst.de> (Christoph Hellwig's message of
	"Tue, 10 Dec 2024 08:12:53 +0100")
Organization: Oracle Corporation
Message-ID: <yq14j3agg9f.fsf@ca-mkp.ca.oracle.com>
References: <a7ebd158-692c-494c-8cc0-a82f9adf4db0@acm.org>
	<20241112135233.2iwgwe443rnuivyb@ubuntu>
	<yq1ed38roc9.fsf@ca-mkp.ca.oracle.com>
	<9d61a62f-6d95-4588-bcd8-de4433a9c1bb@acm.org>
	<yq1plmhv3ah.fsf@ca-mkp.ca.oracle.com>
	<8ef1ec5b-4b39-46db-a4ed-abf88cbba2cd@acm.org>
	<yq1jzcov5am.fsf@ca-mkp.ca.oracle.com>
	<CGME20241205081138epcas5p2a47090e70c3cf19e562f63cd9fc495d1@epcas5p2.samsung.com>
	<20241205080342.7gccjmyqydt2hb7z@ubuntu>
	<yq1a5d9op6p.fsf@ca-mkp.ca.oracle.com> <20241210071253.GA19956@lst.de>
Date: Wed, 11 Dec 2024 14:41:44 -0500
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0028.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::38) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4516:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e415f02-076c-40d5-8ea7-08dd1a1bd8b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l6tEAK6B/lYvlJEtQ8eLkM4OG5/RnXd0SlI1P2YrfE8mW1pFQGWUTiiT3H/D?=
 =?us-ascii?Q?zUMwTUcenV7vp1KAkJQICFPIOGkQWy/puKfxvUpblNLrWgABnBEm2rbl2fg5?=
 =?us-ascii?Q?jvY8r829cNENRC5+D1ZcJMBDM2Oa+BLiQDR9cwH2QyPt1PfdI9BGNUg/dhVQ?=
 =?us-ascii?Q?ISCICepMqeuJ6ILOsR+fT5p3ghybO5epTTY/OeSAoK7vYPf+AkKaSRybI7uC?=
 =?us-ascii?Q?Fcw+wmXPlhNbiIU4RalsV0mF6rfz0dYFe9LzKern6eY6/t+5/PjXTCcgKSc2?=
 =?us-ascii?Q?PqxMPInqHTp6F63r3hdl2OMjoZRR4t2Dit9dFjmeK+bbaFdplBUtGEOJ+DAs?=
 =?us-ascii?Q?9AvJFZMJSATiTgu3VNfBSgZA7bT16bw40wIBFyukHZ6NTXLgAszDbu3ifZtK?=
 =?us-ascii?Q?XmZRZRfwIJNZ0n1KqRDm7mDfSnewYRu38yLIUGSWC3M1kY4YwRm/ZAlCEWOY?=
 =?us-ascii?Q?Ii70vzwyYEqWrU9zi9yfU6c6EZm5E2FgnmKCQDtniTZQee4wRRvK7s2pAS8N?=
 =?us-ascii?Q?kMTDNRI9A072puiIHworeVhAI56KDHy6sfIpM2EKtwHF7OlJmMEoNAooa0f4?=
 =?us-ascii?Q?5FiPd0FvdgCmlWjwGlor63MiAkMu74sWhP5qXyHzdFStgmBPYnmiqRBh7k8X?=
 =?us-ascii?Q?wkdE1jBGgzIi5Yif206FYmfYknjDMRoIRh0Tt0yniMhcOzd6O7j0kUxW5PkW?=
 =?us-ascii?Q?WdQJT40kM5ncIclEffQvkO3oJF0HIkdyjLmoXHCcN2nYF5eMwHf9oDZcqLPX?=
 =?us-ascii?Q?VSCLy6GW2Kr8moXP/jh+Q7KD2zSNwDCPOAthq+Ewci+xUTrvuh1v/x6XrdCj?=
 =?us-ascii?Q?KBCEF3hDWJeXkh6Qr+odrCe3Jb5i6lo48ZxS4MQVh4A1vsBMvOgSCWRgtD9j?=
 =?us-ascii?Q?eJVoLEty4jTdZJsriTY5XJYZxNe2W3OTkln31QbHPDaVbbX6+65HBePVgtEJ?=
 =?us-ascii?Q?+nh/ghdRRPAy/pVE2c48hREcjeRVJXOKWSZXYTzMv7Sh76tp5o4pOeGj3hpw?=
 =?us-ascii?Q?7epX/jUqHBm5VDXHSHN/uzLflLgDn1sXf1y8CM5tmA0QCCsEmjkGKTvTkYj3?=
 =?us-ascii?Q?88PeCK+XCNQMFfV+HbQ0GghcMlkEBoE72MwNKlDgDKM1GFFgmeaCaXUYVGE2?=
 =?us-ascii?Q?z322IqfcYwWN7mYU24ObTYB6h/JYxBKin8PkFwcvcrvO5gTeC61xb/vu9FCo?=
 =?us-ascii?Q?heQBhZyBveg9YcfRhMXLywbmCA434re1mFRnNdUHBnvqdWK3Kt7XMV3Mha2Y?=
 =?us-ascii?Q?aPuLMpV4prDPmmSowxxlhNFniN0ZPyZPTAzCSLXI2TcU0yiSxIdY9y7qvIbF?=
 =?us-ascii?Q?DDuCVqlDFiJBakojHBGf1jabAakApODCLtgdjHGlpUIrzQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A8d4A2aX8setjkx+mCuIvdPtwvxAlH5gvDy2M+6JJmoNeEbiAhXRpxARJ+aW?=
 =?us-ascii?Q?gfV532uOyMvH4vj5R44ZFS3HotV6G1K62/SF6/AM3fE59HYuG8EpJKplC5t1?=
 =?us-ascii?Q?L7Xc21MmVpmVai77XpOqviGxJinpUJtR7JSDuMClzhueKEszc/rinVxCwmeZ?=
 =?us-ascii?Q?NLMteq6OVQrzT4QIln0Wx3JQ86viZZJUiK3QQc02CauE35Ad3QWcqA0s74q4?=
 =?us-ascii?Q?YuhDOtiOUYRLQhr38lZkkTsw4FETM29h3LJFkuApvW2ujfZGShm0ATI4a6Gz?=
 =?us-ascii?Q?ptHu35bNtB57aT83L5BQ7iJmgHNP21hRnLowe/NI4+QUZfQu9DQol4FSWJQ4?=
 =?us-ascii?Q?FlcvYALe9429RQXVytoL+1d1foQoiTXZ6NZLCSpIKClf/R44k3/lgCaj3RAr?=
 =?us-ascii?Q?msSeVCQHVqqUix3rnzb8CD+C4i/xoyd1wjqT+qb/eWhyk4t0MKziYvEh7kVf?=
 =?us-ascii?Q?aBDVavW5wWPhNl4YijBBoxrU2/rmyGyIGY3YpiVT4B1tzwOT9osffsAu7ev3?=
 =?us-ascii?Q?tvb/UG6tKeuH8pZF8D2tmqX9wJjUaX4AP8EqJASxPZRMDvU+CE/YxUTcHo14?=
 =?us-ascii?Q?9pJAqaxQWprwa+3a23YcOcKnD3+W0P2zf0bYgC80omG8LO2W9unPx9x7eEgn?=
 =?us-ascii?Q?lZqfLMvMAmOB7e2cK6a5msyyjZ/QvHeXNGimVR11co9L+CIr7qayxAU/WtKx?=
 =?us-ascii?Q?MzNSR3DAA7FQGRg4yoqb81F6JlT+XP2O9ICSbCpZPvAivlr4I37MpbmE5Gol?=
 =?us-ascii?Q?jvYI0exZXxwU0fA603HjdICNuEIShlGATFldF51pX87aOX4ygFwcv/JgeLl2?=
 =?us-ascii?Q?zuN157pwhx4aRIW7gYU4lnzxCzP44Fy680QLZDARmvD5wbOCQ8I0Crh/2AIa?=
 =?us-ascii?Q?tvu6oPx6/l7W2ezQnT3UgX/YmmaWAxU0nOD7N3RvTx4z+6bIi3Urje0r50+w?=
 =?us-ascii?Q?2fZy3wsfvbrNmmcmhu5iSJm9yWat1iM4l4G8ul1oCP+o/TeEduko7swvHkhO?=
 =?us-ascii?Q?83YLFnb30LajaiF3MSsoXneiGalsTTVMEXKppc+atxojcqRJGNkcuc9c6Sff?=
 =?us-ascii?Q?PH0uJY69GW4sN8uvwodaxt8HSabqgtzHzBgsrYTHLfoxMxOspFC5bgM85O8a?=
 =?us-ascii?Q?eq6Fw+6XKrUpZgSKlxG17x/MXPvvOsekIUKwoNFhmR7A5Jn5I3Hr+KBokvKN?=
 =?us-ascii?Q?rgfUoRNoiUMRleJwOIvug57DEys+rEtU+DbAm4vxkg6AI49GMcZMP6lwvbvg?=
 =?us-ascii?Q?qnWd7Lgxqtuz60l1eHp9Dqr58T4ZpqP/y2t7nw7ZNEJvOMlm8iIceHHLMzZp?=
 =?us-ascii?Q?7FAapYoLsQ3MkWcWXmawnOh2fbppTRm0ZYmo6nsiWsvzfN+7T098jMz0Q2+x?=
 =?us-ascii?Q?PTmlt3b7PXjfB3YQE07m4UK7hmw1P5FWySayug0l7zIxAweyXe3AVDSmS1pQ?=
 =?us-ascii?Q?I6AGqOwujIjL9+PJmYQVc8jmxH3jBctanWr5hUwGRleWHrHnkJm0Kr68E3r2?=
 =?us-ascii?Q?C5kGTNgutFqB/3sakljUJA9eWVAQqjkZ/wtLnUYICkjZe7b9lDVPzM1LxEa7?=
 =?us-ascii?Q?xBug85s2fNnmQzSyPKXqlZKuqxkuXILJdrPL6wTSO7v05Tcw53dIOj0bu3O8?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ruPasJdURZC3z2PiMimuZWe4DjA6FHTL+Bly760PDwrKCkdKdbaTDxXoepkPHL73sBdPl5/e0RTOdxDU612d/jHw1FndS5CYY55wL4D94J9ugCZHdaJv7SiLxx4bpjapvqIxKQ2xszsiXjPgPtXv7qTW8OC37s4TU3n1f2TLdj5V3VCoBynYaGSmdQDNN/hMHFH2+HKailmYayvxvxzH9lquyYJCc6A7c+HqbRjNSGwRCd7TZVZIyiBh5m39LAAE7BOzwjL4ClaFkza9qEWOHlEvELOQsmNEP9MIEO7mCKm3y8LNU+zGRVUKGbjrqgcGPj17AZ+ZWkNwzPzEl6TJWSZcfZYdVMR1+3mv42bvupr57oj3Fdy8RaR8AE0HTUx8fQaXp16Vl8/IvY1gZZIIGASEdxr+aCfkKvinGL6i5xsDnkB8Lvy92cnu6ASFR5yipRpEc5TzBOrNsm2kya+gbfnE2bCp2jw/6Voxn9otoDYUc1Y8QPSRl0mR2cZFjZ1jx0AEjG6ETwqLPCq5tJti9nxquTSrY2iedcNnI2l89fG4jcsBkxoT6vP9FGqHeVME+rWTURNiwcux+Hpha+dhy8N9xBnbZurDiuPbraQyKaE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e415f02-076c-40d5-8ea7-08dd1a1bd8b6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 19:41:46.0688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 332ABC5bYIjkD6phbJbQR7/5aijUEp+//OlxIzveFJaR5qk83iDGIl1Cmmlp2K6Fscm6FPkNJmqyvkQlSpXfjFJ+ypJyAF11rhuvIazv5t8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4516
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-11_11,2024-12-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=764 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412110139
X-Proofpoint-ORIG-GUID: uQYWrYZyvjVsqpuoQ40YXDvnV4eRaWNp
X-Proofpoint-GUID: uQYWrYZyvjVsqpuoQ40YXDvnV4eRaWNp


Christoph,

> Generally agreeing with all you said, but do we actually have any
> serious use case for cross-LU copies?  They just seem incredibly
> complex any not all that useful.

It's still widely used to populate a new LUN from a golden image.

-- 
Martin K. Petersen	Oracle Linux Engineering

