Return-Path: <io-uring+bounces-13107-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLz2CZ7y52mhCwIAu9opvQ
	(envelope-from <io-uring+bounces-13107-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 23:56:46 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9673C43FE96
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 23:56:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 88F753037C09
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 21:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918573242AB;
	Tue, 21 Apr 2026 21:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d1Rlaq/+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pBGZXGRB"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE86729CB24;
	Tue, 21 Apr 2026 21:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776808601; cv=fail; b=m30NpF28HyEhkG43eagK4uYIl94y3oWgdx+w2qY7fvWIYWnqsfPtLrLuhwTqM4b//NO7E2Et7u0+UTyyj2vR7/K0GjIVQycWbZht75Jqbx8KT8wfUcoBFz4//qRu5HBVZFwfIU3p8pRv9VvauVaNnSJzoY3U4akJCaXRZqx2Bec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776808601; c=relaxed/simple;
	bh=uorQ/E10Y5VpJzNTLSuD7VEv5E6kHFtVX3LhmMru9tU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VvXf1YJLie2T6cUTPUftiWF6T+tJoaVVxSR6ZhQOovF9BjWfe4NibVTkYrbbOGWXm8E1H7q0ro+ed7K8lof7ox2q1pYZiMMcd6xS4I7eXEvNJYtk5z30fyScaRZu1GxrLfoyLWWIEHulQFLKkQx+keVF97KHHr38U2xPLaEta9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d1Rlaq/+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pBGZXGRB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIaiWs2337284;
	Tue, 21 Apr 2026 21:56:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lHX84qQ5qg7pq09Z8K
	q98qPD2MKw+33QN90JHWl/N4k=; b=d1Rlaq/+E8A3B/p34uryvVWPeg2kW8XcaA
	JgWZjtEPq/B0bHhobathifnYKQUwV1D9NeqQKOZIKtftWn00BhEri0kSO952EXzL
	53I4jdBY4zX38zQzLrebEE61cHXIwlFAAVHKtIspz8hZzfJ5izaMkUtaycfLd6U1
	tz29c0PvEqXoI1QRYTQ50+doI/NbCTiiy2ENHnZVrBqE/0WhcFH7gZcV7XrT2Lep
	XHUuke1fHaKvHQifvFvMBTwmaQbrbJCRHJ2W4i+0hhEjmKE5+zAB1uKaEhV5UIs6
	BsimGJWO8VE8h6h3XGB0YzwXZrNGFvOVnakdoGnI8klBFYUeKCYg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpenmr9k4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 21:56:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63LLuTwl023584;
	Tue, 21 Apr 2026 21:56:36 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011034.outbound.protection.outlook.com [52.101.52.34])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dn19gnne5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 21:56:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfiVjeQR7TEj4W9Zsdu1rFiVjzzu+j/zxPjHuDhIzCGEraTT762xVsc+9a7cA1rhZX+rxR4t82yCKA7BXldRwoF4B7nrF4KkWt6ZkHmSerktNoJPL/fJwxiOVT2HwppfJfKDFMMqkWWlq3SgEXHxy+Ppaqsc/5z2ZohULCUWnBv/+3M7x1zRk7zIS75SSyqkb6iZgthH7l5ip68RhDXhe5a1tLLo1Ngc7eSH12NqYIhNXCJM1rx2bJPBbghslvT0oHQaS2EWekYAWL8iDb2xPclMbzxH3Citqy9SYAu/lgropVV9f3rBvbrRqG/jc9iur03FvPJ6/owEPvLPd9cBIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHX84qQ5qg7pq09Z8Kq98qPD2MKw+33QN90JHWl/N4k=;
 b=uO1IFHgMfBImRlJc7evLgn9qJYa+44EG8v9zP9cLjCLg3EaBWGXGx+/shxkhKaZ+KH/gWZAFWQZRN/rmdUZvaK/cGw5kBb3BeoP+JPrE39N6d8pWJtDSGQuBZnwUdsuPU410q85Of3fMWQIzjx7Dowcw115imNcNHIO1BdhkPlJ85qrlLxV168vZlToFRB9iqNA73VfrEax354L/rswl2PpP7pzYY7zGo2L+eyjHwZSpTcq3MgWZ1Ljqb4nO8Xp26zf8ECPJfpMXTfSa/+qJmZRDIiL0+pHU76bB/tVa1qysrfQb2S3Tp3e2aPp0IIMmPaNoPZEXRqR73Q1jRqpzHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHX84qQ5qg7pq09Z8Kq98qPD2MKw+33QN90JHWl/N4k=;
 b=pBGZXGRBpierNZ95ZkBogt/7mvvlf8GL5svZiHfi/UX1xUH1zxjbaO80vep9AzkF2L4t5oGF0LPjiNVvlWAykZr5MpIzSV0tTA3SQos97QWyFVcATeORhlkrlVcGuI6fFJxuWf7oin5xfZEhWWy235a+1hsD8AOV1DYskV0jx2Q=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Tue, 21 Apr
 2026 21:56:33 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 21:56:32 +0000
Date: Tue, 21 Apr 2026 17:56:30 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: RCU warning off ublk_buf_cleanup() -> mas_for_each()
Message-ID: <oxree5gq4nysdwjdk6rfnxd5sy3rwqswjwn6wea4q2ieo2xka2@np4gvh23qsm7>
References: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
 <qyob3dbqkicviyjs77q6mmxldtwm6qdpgwznzw6ulipztphlbl@nb4bzctzlsnw>
 <6c1eaf1c-5c1e-4ca3-a9b6-b0305fcce588@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c1eaf1c-5c1e-4ca3-a9b6-b0305fcce588@kernel.dk>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0498.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB4653:EE_
X-MS-Office365-Filtering-Correlation-Id: 2171be0a-6226-440a-4b29-08de9ff0d99a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	NPAZitYhftPEWYYVblDoYz+9ak+b0M+0wlo4uDm8L1wFYmPrlmdOWdsNgferOSuOC2kTgUT0d1kDb6zrb7PfdfwmyK4esACcosNJoXfC2D9gdQHhl/XujMiwJ78rzjTojran0xNttt1ASAa4nq7/HTXSLZP4Itqu0K91I+VwrxcYtMz48XVHbc/8a/rNot7gdVi5AulZ+GYxmA8CdmXSSK7kPR+R1NrsYaTDgBjVofsX1XLAn33oA23E4YWhZfBMrn0wVYW0mfSmj47RpzBKT/Y+bEaJ6dl2vyZmziovgB9vWArJCXjHbzy1WhyKO+XUD2u+XiwArD2nCGxTDMR4DtSoBxrLX7578xdVcJNAYcMeW2WW5PrASiw0dXrJnoXjmvCLVFGqtqDoiwS9SctH7weHMMEklsSXn3bGygsf0DIZ0dqFGjuNPaxCjf1jv8LYdwlw5KAalP3ZdgZiZ7ZMI84kzEIXaQnr5OmhCRynytVXi1GJsQ8k9hqAW7djqGjvO2MFUsYA3ttIA2anRuFczt5KTTO82atDIw88S0Luvn5wvDaUymJvFaeaosf2n6YoMck/3gh3+t0dtBmARf6d54HGrdSxGozdlxIu9cI9ywAoQcbF55VeGqfsqAosCuDsofupmrH0Wh8pRexorPPjRntPvSKIAB5PW/zhQJ75os/aMMmnGJQQG/hSE2NvtoaJoeOj2BURBN4pitNI/EyZYq8952FUCk+VrxpEhec8yKo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b14IQMy+52TOurHN8AOIl9g2bhfvkbPZyX5kxXczWjRv1+WEEhV7DcIAdbsL?=
 =?us-ascii?Q?U1tTJwZckwLg5yAw/+blka2d80FOT8/iryyxU+FHlX0qi0QtekWmQizcKfse?=
 =?us-ascii?Q?oR72O37PkL9tYQmkSelR2Nw4OD1AMvK14Yghcp7OuCAvjJA+DUEILsdRQWpt?=
 =?us-ascii?Q?/HBknGH12yf5nbdPBjnGoHRbRPDLN/7vMsgeFg0gYwYFmnEPYGRuCoGxjKm0?=
 =?us-ascii?Q?0ueSZHNJFV19oo4f2gKHL1jncr/ya3MZ3bV+XKVfH/H0HZvO90B7cwqsNVNs?=
 =?us-ascii?Q?0N59pHbb/ERBHZOyVw5v+XfG287g4N9+RvKuK5LcRz4ykjhoe7CGslReQqjT?=
 =?us-ascii?Q?/1/J5sX30wywkEb5ehkH3+9EcJjd1mI6AXke8E3oKIeCvhIITA8Wi5L34e7S?=
 =?us-ascii?Q?ye1pOdEdil/qi3T1BZxpuSGBVVw7x0uMHMRsjj4degZjk7nNszvC/vXpvJOj?=
 =?us-ascii?Q?kWdYKEJkxp+9Gla+4Tdv6W5/YBOSPLkUenWOHQcVsylVLeZzxAO7i5YqRsvZ?=
 =?us-ascii?Q?ZVCH4JXjdzcpX3hiw9oy0hHE6Rspm+sQaloumIJwUkg5HTT3nmj+YWlkCur3?=
 =?us-ascii?Q?iZ9Jm39QZVrT9N8n6utyFhUfpV2xxyaN5NJdwm1FAj3GfyPxdCgGm6QJ7G92?=
 =?us-ascii?Q?zNo7JYjAEYDhoM8mPBkU6nzzqhG63c2H1ji9JZLn8iwUaZ0rHp0meuboy9Lb?=
 =?us-ascii?Q?oplhGOTyo+1B7y+pEkOhoxm1PEuunmQnnJgP1z/S3N9XFodIbmUD3oQYUzSS?=
 =?us-ascii?Q?8rPcag+zl8ot+qQWuW3rQs1Gl6sQLbt3JPhxw7DElCVU0hRp4fmdeJr4z6Ck?=
 =?us-ascii?Q?RJoL6zHww5VZ/7HDW+0XyKsMkalxj0VAHouYBE5djXqzzqOaBL3AN2tMXmRL?=
 =?us-ascii?Q?88Y64UK100LtwOe0fFhcSxEV8kqUXeew+1uvEi5DSmoAoKZ/0h7OZExHZTYr?=
 =?us-ascii?Q?LC99egLvcm2jGAGO3itYySeeFtGTE4+5Yfhx5LAa3Axg4nFbYVAocrove1M2?=
 =?us-ascii?Q?RiwaHTr66ROUu6yKZm+L4Nt6PlYQ3VOTpsOFdRTnWfuvWImmOpCGRDQbwYYv?=
 =?us-ascii?Q?endZEjDLQteKEFaVT/PYh3fIbpFvQ9dSMSoruE3dIAcfjsRdvP0zbU9JWJtz?=
 =?us-ascii?Q?tz2/Q5KdRMoc5Xx2FTm0wC2T/4qIIFTNQZZZZzkU8x60QXPjFl1oAdOE9Sus?=
 =?us-ascii?Q?QMCOnt+T09xAzzppPsM3l7wECRREvYeIVB48Q/X5nYrsnUQf37zm5RyP3QbN?=
 =?us-ascii?Q?q6WdEGVuNAOKWMyDHn/ubSlhlFWE+/JlMt+UAp1J03nXEQmjxFMjukmyBb0J?=
 =?us-ascii?Q?b2j2wG9fyBQWtPxIRMfrMGQwM40mL3NbODPDdyrRnSPnthxlm8ODZj+vugJm?=
 =?us-ascii?Q?JVgwPsmO+JN344/Kr4H4LbjKpyPo20PJJeMXwSrLBNAp2HnCc5PeAwJ+Yq2x?=
 =?us-ascii?Q?DTS5krd0XI2j+HBHR3rUPfIBrUQ8GkpMyJHytyynyGZ4HBeaLsNcxqzdddbk?=
 =?us-ascii?Q?2lfJ4VsJ0QTr1xBq+NKJs8UdOI665JSIY5P/Khi0mj6YQOMD3FQNS2Pw40t+?=
 =?us-ascii?Q?8WGjrBpdwCIeAkTmsyDkHHav65wDD1ecFFMHeGx8Zi+4+OjwOs9hkChmtUp4?=
 =?us-ascii?Q?wGjzV9iTt5RNy03xoCXOJh/20qO5/9lvkJSCQ7SN2w/SXbkVIzw74Y/mt9Nx?=
 =?us-ascii?Q?LBS2vh3Pxx+BFohIBOVPVorSCJ8za8iqQwKaOey6LaZ6PryDnI9o/WVartGa?=
 =?us-ascii?Q?Z6ObJVhJfA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	qTYnz2fBpIi7IAacqPyQIej7HP3stJuX31sCOHSVadIBHhWdb5qr7eHZjDvZOrnw6GxZ+qUORwqcat+UnlAE9PqEeMdtQZcZJvVK5HtYdh9e+jN2sE8ka43KGXP7+qI1gPDpN+dD6Z6r7ptpj2PCSqjrbKgjGAI0jLinAzfVQT4XXa5lxi+4BTPf8+7dqnVkyMwgqqUX+hoGW5FrYvOMUwJSScko1jkjjoLEqZbhohi24tvZ8R6gb+jM1iebrLa3J5Qc7tnhSzc1GcKC1Tt74KaKJtiC3yyVvl+1APugCzK4VaKkQLV+tHAqysJ01EfCvoRMbmVoc12zs3vQxtZvBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xw/MYXPru6zJQ8bjo15xiDYmZIKj4QluGO4A1msaThRKqALdx7JcbSZdUMw7k9nzCvREI7VWeRP8KnnBNaptqs5qANweSy16gPY/WOW1DYWbHr2b2Rbgq6V5CGItJWZ2iM48yoXCDz40BOsGrVeHfxF4ZMABCv6miMQQEE4BlZv5vJlhwJptHQoTv866wVQehSdnNqCGAO69V8O8CLiJqzWZi4tvy1DxkYwiFK39kXn3hIETJlGVfNeU7F3PeafkHFUSFmw9myDZTdt3JhJDIAGJhnjgB+Ao3ukBpMp/GoXrdxgxs/Xg7WTYx1fasq5RokeQz0n251eSYAM+FYB74wbg2ccFOqXciKRYMjjk2i5sia+FYfhAx4Zn1xZgSRovV0mqBW1veCsOAOkYgyvIDQEOIr01iczCM2roiB/45yZz7A5mUUd4dP1ZOhL85vRKKeSpiwi5f4OM0bcoRmpRbAII0rSI+XSbdPR5TveFsTdM2xLPbbDCuaOGuHBp1HrAuFxkML4bpXKAABUm0FG+LWWeBKiQjWI9vSfnvd/AuZ5Hs5jEGOgV8sV6T945XQmfZS/iJukoEvWw/BjDtCe5fge9zcDbBrj4so3wtJduDcY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2171be0a-6226-440a-4b29-08de9ff0d99a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 21:56:32.6480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TT0tTlmDWZSwdiwfZD2mTPuzB/9pe42ZG6foSR8uLNnBIALPJ3p44Mk0C4lLe3Vl/Tb1uelD7SQ3+xHmyQk26Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604210218
X-Proofpoint-GUID: r8mkzxXf5BLfI2_CxSc0UDYHGEHfThC1
X-Authority-Analysis: v=2.4 cv=Z6/c2nRA c=1 sm=1 tr=0 ts=69e7f295 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=JylMO_TrOa4rjM0lsLsA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12292
X-Proofpoint-ORIG-GUID: r8mkzxXf5BLfI2_CxSc0UDYHGEHfThC1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDIxOCBTYWx0ZWRfX0ButrAhiap0D
 uhc8Zm/fK3kyQPYaW/ezBiGjPTqqPIsYv6wFoz2J46LRJFwwMEoLnTunClTeQSNveoBCjVwlQso
 nNNExy1jRiD+PGrfYuU9kgHIzdVAyE4CT1YQ6g0XYGFCZE6KIfQOJ5HcHQxtAuPZy8XHFjNbB8i
 Q+BQH/m//Pt6zjFH9dnHmUt4KRFZ63P13vnIDCe/AsHJc0TdsY8MqqRIJvrtnY5r4kOornCJ+u4
 4LQZRd0RvED9hZu+re0+jDs93js5RuafzzKwhqIeysY9JRJDBMtk3fM9lYcXEt5nAkSHHXXoDNl
 xY6yHGo0vhIV9EpxL+2E2Os4Or5fQ9XPooYA0w/3gV7z9eCCURJsHrk5rAvowZsFx4m81/a9oUA
 69ygDecECknQFufYxKBMP2PllhjwCMa0kQOCz+2Z7OlY08uVPFen+3PVGoWvrqtaTNrr/mkFPFA
 M70bcYYFGwDXgTvzrSkR7IZw0HV0t04lSL3JMqnk=
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[oracle.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13107-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.onmicrosoft.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:email,oracle.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Liam.Howlett@oracle.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 9673C43FE96
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

* Jens Axboe <axboe@kernel.dk> [260421 17:41]:
> On 4/21/26 2:28 PM, Liam R. Howlett wrote:
> > * Jens Axboe <axboe@kernel.dk> [260421 13:47]:
> >> Hi Ming,
> >>
> >> Ran into the below running tests on the current tree:
> >>
> >> =============================
> >> WARNING: suspicious RCU usage
> >> 7.0.0+ #16 Tainted: G                 N 
> >> -----------------------------
> >> lib/maple_tree.c:759 suspicious rcu_dereference_check() usage!
> >>
> >> other info that might help us debug this:
> >>
> >>
> >> rcu_scheduler_active = 2, debug_locks = 1
> >> 1 lock held by iou-wrk-55535/55536:
> >>  #0: ffff800085a451a0 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0xdc/0x2f8
> >>
> >> stack backtrace:
> >> CPU: 4 UID: 0 PID: 55536 Comm: iou-wrk-55535 Tainted: G                 N  7.0.0+ #16 PREEMPT 
> >> Tainted: [N]=TEST
> >> Hardware name: linux,dummy-virt (DT)
> >> Call trace:
> >>  show_stack+0x1c/0x30 (C)
> >>  dump_stack_lvl+0x68/0x90
> >>  dump_stack+0x18/0x20
> >>  lockdep_rcu_suspicious+0x170/0x200
> >>  mas_walk+0x3f0/0x6a0
> >>  mas_find+0x1b4/0x6b0
> >>  ublk_buf_cleanup+0xe0/0x240
> >>  ublk_cdev_rel+0x34/0x1b0
> >>  device_release+0xa4/0x350
> >>  kobject_put+0x138/0x250
> >>  put_device+0x18/0x30
> >>  ublk_put_device+0x18/0x28
> >>  ublk_ctrl_del_dev+0x120/0x2f8
> >>  ublk_ctrl_uring_cmd+0x598/0x29b8
> >>  io_uring_cmd+0x1e0/0x468
> >>  __io_issue_sqe+0xa4/0x748
> >>  io_issue_sqe+0x80/0xf68
> >>  io_wq_submit_work+0x26c/0xdc8
> >>  io_worker_handle_work+0x334/0xf20
> >>  io_wq_worker+0x278/0x9e8
> >>  ret_from_fork+0x10/0x20
> >> Buffer I/O error on dev ublkb0, logical block 0, async page read
> >> Buffer I/O error on dev ublkb0, logical block 0, async page read
> >>  ublkb0: unable to read partition table
> >> Buffer I/O error on dev ublkb0, logical block 0, async page read
> >> Buffer I/O error on dev ublkb0, logical block 0, async page read
> >> Buffer I/O error on dev ublkb0, logical block 512, async page read
> >> Buffer I/O error on dev ublkb0, logical block 512, async page read
> >> Buffer I/O error on dev ublkb0, logical block 0, async page read
> >> Buffer I/O error on dev ublkb0, logical block 512, async page read
> >>
> >> and I briefly looked at it, but then just gave up as a) the maple tree
> >> documentation is not that detailed,
> > 
> > Which documentation is lacking?  I will fix it.
> > 
> > I have user documentation in the Documentation directory while
> > technical details are in the code.
> 
> I went into the core-api/ and leafed through that, didn't have anything
> on mas_for_each() that pertained to locking. Was hoping I'd find a table
> of which parts of the API requires what in terms of locking or RCU.
> There arent a whole lot of in-kernel users of it yet, so looking at
> other places in the kernel wasn't very useful.

There's several users and the test code.  Too bad none of them helped.

> 
> Since this is a merge window regression, I really just passed it to Ming
> with you on the CC just in case, and didn't spend any more time on it.
> I'm not the one that's supposed to be finding issues like this...
> 

I appreciate the response as I'll try to cater the doc to what users
search for.

There are two APIs outlined in the documentation normal api with mtree_
and the advanced api with mas_.  The locking is outlined in each
section.

I guess a note stating to check your code with lockdep might be in order
in the documentation.

> >> and b) other in-tree users also just
> >> call mas_for_each() without either a lock held or RCU read side locked.
> > 
> > mas_for_each() must hold a lock of some type.
> 
> That's what I assumed. I missed that the rcu dereference check
> checks for an external lock too, which I guess you can register
> with the maple tree. Funky... I guess it's just for lockdep
> purposes, makes sense then.

The external lock is so that people can use the tree (which needs to
allocate) with sleeping locks and not just spinlocks.  Willy wants me to
kill it one day, though.

> 
> Presumably the current use case is fine, as it's serialized
> teardown. It just ends up triggering the rcu sanity checks.

On tear down, we should iterate through and free any resources then
destroy the tree.  If you erase each element one at a time you will
rebalance the tree - since it's a b-tree.

Thanks again for taking the time to tell me where/what you looked so I
can better answer the questions in the docs.  At least the LLM found it
for you.

Thanks,
Liam


