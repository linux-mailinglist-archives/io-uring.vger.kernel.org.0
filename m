Return-Path: <io-uring+bounces-9636-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 198B5B4836F
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 06:52:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9AA63BE49E
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 04:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE0622156F;
	Mon,  8 Sep 2025 04:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fzD7pHM/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FRxyB3OA"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9211D7995
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 04:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757307149; cv=fail; b=dKqofxFKwUlLKYveICLgYZkqHnzeFkPxUs97WVYpH2SgVDVPLwZ7KwyV0SrbGZeOc3r+t4PCN8Qa/gR7TOYOZ1sK3ay6Qga2RtK50dG2f78dluP7awR6ksYcyaxhBZBjJbHmKorlS5L0uKMnu/afazrYV82VMOMW4/RjzyqM1Qs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757307149; c=relaxed/simple;
	bh=kNnrP/jEKGWJ36HHMtON+enZpkDrunoaZZth8XuNeDk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=t4/UHiVIiNchtLVsSLVQf71ez8XLXYkD+BAosGyJPiDhqp9dyApLYf10Wq3omAuusAtwOiKsOyjP1Fu0fzfovojve5myKPWd4yiyqV/+z1laBTkuDrYnR7afjLJr6Xzd6x/yzSaH93Yumk9rGbzAxuqPQOqRuzDtZUnIxcStNhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fzD7pHM/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FRxyB3OA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5883njFE005744;
	Mon, 8 Sep 2025 04:52:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HeX++8MOJAau+dXbHT
	+uJCdrrtUazaYsr9l6Wma1S+s=; b=fzD7pHM/kxXerTNvVMUTu0Gf2LcF9dbZ7o
	ppAEo/rLLDs4HRq4YLM4XyQeDuZHdsxUJeNkpXJBqypmuY0fZ9tvBcrPsOtl+s/Q
	/aSXN747MA1w0wkYfSN4G3kqg0PuLxNhM0Ctxrd1L84sFJa32W333STtudfRLdsv
	YbyddRsKilGU8HfT523lma0Vmix+l9033d+TgVzh4vif/bKInpLMTi3cfX+vtoyx
	EQYfLklhLtQLrneDOFO2lgbt4GwJrsRYOK806NAa4JzTrqDWZ1kYlaceC5Tl+KYL
	TfzLAZpEC14YFuw8EVVFj88aQeu1p69xMuy7E4Y7dwwyZe6T891w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491qjx81v9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 04:52:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588427tM025922;
	Mon, 8 Sep 2025 04:52:25 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010045.outbound.protection.outlook.com [52.101.201.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd7nx0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 04:52:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oCpokh/75yhRuKniRn5x6zY2VY4mq2EYKgoz2yjDt86sp75skOF2uXgWU0iQymM5tI0QCl5kYyEmZlrsjlBm2giqPUrt13V9nUuZ0H6tEAsfdkmDmEb9hz+rDXpNknivvSkWLH7/WrnC3st7OI10/4beVdiHmFwXnYyWRWwBGMLsDdfXk4EoX/azMwaMzzF8gCks+KPCXrLFcnIeru/J2e+zxFkUB4qR+ocEgCmJppi4hrKuTX17tSPRuoeqUyuFPvC4nWznaSecRpQPFOpzrcGIQstAfPtMplsFjhSu2apSUKyOmRH2gt0q+6KJgKK0ulO95jcxHB9NGU2H4VHWjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HeX++8MOJAau+dXbHT+uJCdrrtUazaYsr9l6Wma1S+s=;
 b=y5h8tvD0mN8r0jtczh0B0Hf+o8NURgqdgllahBrptXgfEIb4jS2M859LxbpVERmOm4gZe22fhflIOT7CHBNsFxdolqdr79PSEA9MHO4nZFM+uu8Na8kiHlIvCVGZVUTuHKD+aB7qHkB4F4qfn2Q+pb1ZXxAwBDSM8/lD77V4OXdE8XSK2uW+xFsRpQkiU44JcD4YWA39l3qEMsHHspS6FqI/a6XfusTghz5OcTt/T3EvTU9+pewQ4bQ+9WwuCdqE6JujZ+hcgqOrE6raxqqJhivktzCwuHf6ZB4c4xShEV4JsgJM75g+iuFWnTun+E8pvKphuHLNu1DEDIKLDFSLpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeX++8MOJAau+dXbHT+uJCdrrtUazaYsr9l6Wma1S+s=;
 b=FRxyB3OAo2aqZ2gxKeWhnM1jbmQo8YvuMnBXv/J99UAHnWWtazuej7I6Tj+wL8bYv39bQLkJyCJpgrOdAjFET63VVXbHvzBvMW5jX4xS4vqTqBcED+3tXVjDFZpm06VbclykOeT+50//ngOcu4Sc4Jd4MB6imIeeK8lmM7tL2cQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CO1PR10MB4657.namprd10.prod.outlook.com (2603:10b6:303:96::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Mon, 8 Sep
 2025 04:52:23 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 04:52:22 +0000
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH v3 0/3] introduce io_uring querying
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <cover.1757286089.git.asml.silence@gmail.com> (Pavel Begunkov's
	message of "Mon, 8 Sep 2025 00:02:57 +0100")
Organization: Oracle
Message-ID: <yq1qzwh7dhr.fsf@ca-mkp.ca.oracle.com>
References: <cover.1757286089.git.asml.silence@gmail.com>
Date: Mon, 08 Sep 2025 00:52:20 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0052.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CO1PR10MB4657:EE_
X-MS-Office365-Filtering-Correlation-Id: b57881c6-447d-46c3-18df-08ddee937f7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8DERqWaeeEv/My/HwRKiyG2rUWuo1XXLH6OfU9bsj4XIkk5LknlZcH1uTFPq?=
 =?us-ascii?Q?GGUoyKs5YbT9hyexe9cE2R2JS03TUe358kSzX4Ck8TCaxGsknJY82hb2r3lh?=
 =?us-ascii?Q?ND9QAayyfSVw1PUJwzwGZQ+aL2BVyqhoPqQYSN6HeM4fISlo+VTKVKZMPTcg?=
 =?us-ascii?Q?NfBQDAtFZm38StsOeyNEi45NhtUGGYpiErI4/L1/XxPWq0GfDs2J33uQqLQs?=
 =?us-ascii?Q?zPsaPYo0aopkfDXIP67tHgUf6F2tfmiXOwGLARrMl7tJ24J1eflo+4ur3ojl?=
 =?us-ascii?Q?Zcg63VKsrQ4kD+1rNzJQJMs8jgFm/lC97LSR3JDxGNyBm3zumt5UAmYDcQph?=
 =?us-ascii?Q?aapO6Xtevgf5JvpTBejQoNgmaAfaoJk3a5jqRmoJqGIB4oJySTzaF9OeyUY/?=
 =?us-ascii?Q?moCduz3TSm0xm7DYC5q1B5IuvOYsi/r0oI2fK8wue1llZ6uDSbVwJBnIiAFu?=
 =?us-ascii?Q?maPp2MoOmrHqTYTRLkFNNL9THbe9qoaqNHgNyBhqTEoWxrtZOhsZw0xLdGAK?=
 =?us-ascii?Q?9hF2XN9T90tPh7esALh3ehlVYl+mz+Ae9hWzkkEaQ+IoNc+8pOryE9vLtwwb?=
 =?us-ascii?Q?YuX1TU3ufkDmEiRRg4AtKMcAvU9UFN4Mc6jhDr9JsulL/a4nPyG7mIoCvIUn?=
 =?us-ascii?Q?wrX3Or3o0FctfJrqVQyW4cmqKu29YDPdFuF7oFhjnC0nCaLcYI5W187NLuUu?=
 =?us-ascii?Q?AVwAI65I9mv4pyU9skqOuWwqaCAC3+MpEhZDUhtYjzxa49e9rfdiqiB8W9x0?=
 =?us-ascii?Q?3tEha4xT9lUQSJd1tWP7amhB/rU9aKy1UBY6y8NEXDVd6uXwQ9AjE30bqq6y?=
 =?us-ascii?Q?51B2pSVgbzoP/e9nTfepxrsHhTbL0s+9rYJU+Dv214fXp2N7H+iWn65orrkh?=
 =?us-ascii?Q?RIoFuM5P9VRttBjhFrf7j5T1DwnUKjvljeGnnu/omsYq9ZPKb+L+xP+0C1nq?=
 =?us-ascii?Q?FCsGL/9F8EH2F+FF2ruM6+VkZ7IxmdEq0qch29saatZhJNR5qY2hQuAnGo5/?=
 =?us-ascii?Q?vKZO2HljQ2WYLqV8fjq3vSOp/V/fK0iFdOmJSSWJBRYHHEPVI/xxM10Xn+u9?=
 =?us-ascii?Q?ksypdl0AhpUYQUj8/N9sluffSpLmBcG1G64coBLWhNJZBoDzVcfz37BgSRu+?=
 =?us-ascii?Q?3JMg+6v3wwY8DwQQoJo6jsXnotZGyW05zPBvCNUxnEef0r0S+0fl2swelUa6?=
 =?us-ascii?Q?nHWUcAMRCiHC4rCLbc2J2psOfEE9kQwyFVNWtlDb1jLOr8YjzLUlvuN2qErv?=
 =?us-ascii?Q?LOyzS6q7u2D3VP+TuxGP63GthYcPDtKYywtJt8kywoOT6D4vytvGj4Xb/IKB?=
 =?us-ascii?Q?oCy07JwNjk2QI2IPNrJeATRp1DwkERk+wIONePT004s4bfXR6+weiw4Pidmx?=
 =?us-ascii?Q?M2oVfQb0Cz2Vtn0SxsxZk10q9dj1TqhIQMAYTE+fEs62BATDO77upN3Y13kA?=
 =?us-ascii?Q?7S/uj9v0qas=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?no6qn7X/XMRv0x5Qej3wle+Q16TQ4PP/TGZ9hItWN4mUWpj43crwT0SxzSbI?=
 =?us-ascii?Q?8EAMBDm8GVYjaD9qFhovcJOExgfTUQSKuL2s59+x9iQwqiIE03DcUYIf5SDh?=
 =?us-ascii?Q?j8CKlmR9UF8M2CRMr4n5nH027eK2Hx7lrTvvoOUTitcY7qSIYUL6S9G4UlWP?=
 =?us-ascii?Q?Vw0J2O9Gu1LWKD4n4oOQgAtKu6WPl2/0AvRlVag/dX4aPhzQhaFxWddoT64l?=
 =?us-ascii?Q?ERjio1L4N79qJ2v5Gmu8Lil5PEuYaQzGDkkuqZDn5aiGxZcFfacREpr5tbLG?=
 =?us-ascii?Q?026Orj9pNyrpwtI2qPGebsGixWt8X3NqjT7i0i46WEK13ZSUSUTy4qiWiOi4?=
 =?us-ascii?Q?seB9R63Ad2UHdcgT+YiPhi6TN0IRuHYwx/Nmo2VQUiUE97vQF0exUpYdzZpp?=
 =?us-ascii?Q?Uzw5UB8LGszImxrM/ckYMIKzHz7jxTMDFWm+GRhoHzVQUn9M8ZwHI1fgK3Vy?=
 =?us-ascii?Q?A+/KK6Gglw25dzlrWibc8YeWTg1SEZ0qNmWBMrv5V5S2Oq5zTAhNuXB+FiRO?=
 =?us-ascii?Q?3mNawdy68h/+UGemdwIuQiz4e7uRXuxW7vdzOjHowbUARzU5QjMG7o7xS3JD?=
 =?us-ascii?Q?+WQqJ6y3RvsdaNfBSYZsS0dXgKxob2V9L52vQX+RR2EC4IloTrDseqqRpJzO?=
 =?us-ascii?Q?ZEMwN9OXpjNeNqS9W04bbqNjubAqWEOTIvaRq8m7E80/pF40kbOZaV2EjyYW?=
 =?us-ascii?Q?3kRJJEF0+XCXb5+eHOcls2/30u1CuwQtNkabASs9bx6dzxTNIFd3kWDyyR1f?=
 =?us-ascii?Q?LpYsxhnzCD2Wyy4yBgC5ZfiIYxF1/NuUV7/62sq8lnzuKfZ3+4l8fB87vb8x?=
 =?us-ascii?Q?uQKH9uUtsB4qi5JZ61n6/gbnTmH+1NaS3D7IE58M51e6+zg6TGBg+GqBjlIc?=
 =?us-ascii?Q?iicbRl2qkdZXFu37JXfjF5OOG4kEaTk3rQ2e+n8YEQzQM250xH4Mr/6zuog5?=
 =?us-ascii?Q?Eazv1/mwpXJWgWyfPK0GORGP8AJQl8Bd1kPut7GYCokM9TuswwwQwgw+/e0p?=
 =?us-ascii?Q?mqgMmHTG8wz45EyWnuCUXQkVwuUAAFVgPCeb/Xk8Bae6e9WVREVq6z5nWoh8?=
 =?us-ascii?Q?6OcHI8/FYPe2gC1Iio4ptPk/UfN2AmUSi/50ckNbOOgUqgtXnZd0sd5puICp?=
 =?us-ascii?Q?BI4iIMi4FtrQiha67SwpfATq+/7AtvgkkmP3SHbijTHQJK18FeX4uw/RWiMX?=
 =?us-ascii?Q?lJtVy77mIJtfD0d1qippOedvJ7p8ODslsBkqbDTpQ1LyBLxKILJl1/93rCkd?=
 =?us-ascii?Q?M5/HAos+IuMLFV44TjqQzixV+Sok5Dt8gQ9w2BcpCHspGpqXD2Ciw7PJm8JV?=
 =?us-ascii?Q?XAcT0sGNFzNrVMON+OBSf1lRp1/c3hv2EHWz218c77OqFXbR7SGV2R3zhOIL?=
 =?us-ascii?Q?TmMdFUtTDBqcHWxm+UXl48q7P+MFyR+TZI00lBK5U6/M91BJLxC/z7/0Crqh?=
 =?us-ascii?Q?0xOem210vF0lscDwCbT6c1C9G9LsqW//0x2VmbDHC3y1PETwpEMi2LnGdg2l?=
 =?us-ascii?Q?ysx/JPQ/13Dqz79xq1z4FSe014rs2uOfyzxmVZO5RdzCLTPwfOIrHXbwogey?=
 =?us-ascii?Q?4hHXDWkJ9rUt05mapEJaY5wpuhDNSbZ8MKQXJs6EMc3CadgHYJUCQyzyaD6W?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Cz+P4CgbZpsaZmN/K+G15ySfz11g9GMWBJtJvpT5zbam59wNczJTasLqwaheWN36joJKaxVyesPCKTBNUCA0t1o7YRfssz0/kHG04ZZWb9c3YeI3cVM7LEKf3Upf1h1M9bq/mn+q8wzEGMUXKmu1bD7eugRng0yzUTZoYx3SAQMKXq1F1FHVx35d6ejeMiW6wtV8PDpYPrBnvvf8d6bn5et9+yFwH02+kHxeukRD+k6IUfXBmKXu7NejAvowzQfoIs+c1EnbTD5z0GA3yqozIFGWXTtX+i5yDZp0IONOQxovbcJrRdqWsdZiAx8vhvYpmrOnfaRVj85zyWK8t5+BkW9mM7gY1s5MZI10tXePGhwiDDyhNZxhclRL/r+5KYpwnlUf6GelxwpHWF/C2mkmLf2QD92xbXcvNk2Dqts6JA2Q+EY93UwSHyBYvyeGw64xZkD4iKTPPdR0FwMflLc4lZ+YO5acJUh+JC/sCsNZgoi8DLAt/H01oYnkdgWhpr43J9XcrdxQygRJAkzmW4cY8UuZNCC4ju+W5uNvJiddr1j9Ye/KgZP83DMdcneDjmxtb6T8sMhqHcXtp9sr8hn3M64jV6J9knv1gKvqDrl6OwU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b57881c6-447d-46c3-18df-08ddee937f7c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 04:52:22.4276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsFm7aIW4UWIrwA2O0Ypk5Ccwosyvk0lZJf4TVIaj6AnlxRlQexfSAinrASQ7djRuJvJmV8JIsav4ohOep8x7zE42GjXTL1YOAto2XK4wfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4657
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_01,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=947
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080045
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDAzNSBTYWx0ZWRfX33RMOa43/GlL
 +TEAzOk29iVhVRpM1z/K/0SxchxUu/JPYrgJU1PuOhwbyUJ45S+faBo8DNmc+8YV4xWlV2pLP6/
 /ABzgDNMpZif/OAjMlQJeCu7wwkI9XgSYUPW342WacoCKYFD41WvKu674y8+Oh+1aqv4Qk43fun
 cnnUU+rsmlijv65jf/ZgW+Fb7d4P3YcJZ42P8OI8OCRGM9ePwxDQ3i+NWn6kf6BdSk2ZEajA9U6
 Z/S6Yi6OBcBFUFIKR0Yw6WYEAbB/f4tK3DmCYobh7iANUJkMck/npeIb+68SvXXEF86cSO0upNG
 CzIJ7G968M0qLbJwRwKDh/35166WGZmqAeP4e4P0dm9gl1uNKhQqG2OD1jFz+YsYi3WJNlTPwAA
 y5J+gnBgoz7YHQPLpqgZOIfrs0B/Cg==
X-Proofpoint-GUID: rUA2TG_8w_a2HUsMyiu-_dp4Yq_NqRNY
X-Proofpoint-ORIG-GUID: rUA2TG_8w_a2HUsMyiu-_dp4Yq_NqRNY
X-Authority-Analysis: v=2.4 cv=D4ZHKuRj c=1 sm=1 tr=0 ts=68be610a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=K03QI6gjulkjfWDWeCEA:9 cc=ntf
 awl=host:13602


Pavel,

> Introduce a versatile interface to query auxilary io_uring parameters.
> It will be used to close a couple of API gaps, but in this series can
> only tell what request and register opcodes, features and setup flags
> are available. It'll replace IORING_REGISTER_PROBE  but with a much
> more convenient interface. Patch 3 for API description.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen

