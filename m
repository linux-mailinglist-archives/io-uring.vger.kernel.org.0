Return-Path: <io-uring+bounces-7499-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E5DBA90CC0
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 22:09:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 360EA5A0679
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 20:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95BF3224225;
	Wed, 16 Apr 2025 20:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W/J5Y70i";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Wv3OKClw"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AE51E1C29
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 20:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744834141; cv=fail; b=R1Fky4bUuJCo00eZKq5ORoky2sRCtu1HhCNybLTjkQuAu58+G210CUvr6M84YF4bAFpQSKLDWGeJ2QN9luR+pqG/UID1C7aeuJ144yfdRNj5IJ2bHIZX+1sTBYg3D3vyKhkKdTKczkirPVD6JbqjG9X+q5PbbZxeRyQcCIDQqnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744834141; c=relaxed/simple;
	bh=nEqtipyjeYd3kL3xjowCZKRMajE3NU9aPNIyNHP91DE=;
	h=To:Subject:From:Message-ID:Date:Content-Type:MIME-Version; b=oFXxdfsvu8FqCzS/nhKDmF9gvooMA6njOwqLXt8tCTmABJK3GAencalqDv2GbqhAdDc03084fVaXcC9Y+Z+OBn/3bg4C6sAuXxxdtkVHbWnIR1vKhJFiyu5BLEz6kdpzGu4W38RIYu/eMYGfBlwEE4m0grc2wU/JDM+Jgqk8hiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=W/J5Y70i; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Wv3OKClw; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53GIudDh019609
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 20:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:message-id:mime-version:subject:to; s=
	corp-2023-11-20; bh=M80TYFXo733OYewJiEqB1CNEYS0jMakG7HcHblU5a9k=; b=
	W/J5Y70i1Lf5lsEBolBPqr8JinrTQo66XZNXVy1XnVC7gFIWmNjwnfm4o8oLLMlz
	TG54/xN/SRanxyL+5sPp/eW4QLZxZIM90OHh30kJnI0hPusp70q9jlVz/sDL1ALc
	c1x5egyfkYjHa0ljF0gxH2MPlw6sdYkT8cNkIRJsTyIF/7fWG3R8GGrwFDSRmO5p
	mPF6UqEzCfFplbIp8SIcWieiWNNTK4GbVxQZAoNsTBGtiWZZJ0Nf4b43I6YPuAhs
	6RFccPcPXgcUKmOxHGJXwCgwot3I8iI7yxbEGBYL674eVteYRa6jqpVQmejvauaC
	uA3/PEaIiA9mo0M2+UCsZg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4617jud15h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 20:08:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53GJtCZr024673
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 20:08:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d52es28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 20:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eq785Cfr42bOZY0GJ+uFVS93sjDDti5svfBZ2AzK5LGd7xV8EJA5XCuAgFhELYjba1s1roG5KkUibBZm4CLsN1eXXfZqqBNKc32CtL5OtSgnq07m59xO2D3gM3hkTToSxXLYDY/dEZdqtosVxDXSInY6k4HeTsUiT8nExC8XMlOxL+smKqQ+tf0cq+lx2iFMBmton2MRdpC5jBWJfnQUlpXkY+UI93S2CncXwVMY8eNtw62qVDiTOV1C4bhCer3A+qpP5oIVNmSDp6C5mJf3gOkRXE3DPFG8EFdQb9f69gH5loVrDb8kEpK4WFa1RoC3LRkEvDrItbDc+AWCCW4Mew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M80TYFXo733OYewJiEqB1CNEYS0jMakG7HcHblU5a9k=;
 b=D4NJF4TOonpyk6J2zmrjuwy0+Igp7M87msGIUKg66VwJQ0u9xkpfD3xRuQ1I7j+PiSpcs86LrI7KlpdiEJ+QsGiqJfQ+mtmUgWD663cwOTdD2aZxrfprvqpznj+DIEnzXFcnvnEUpcNGzv95LabYPvI5IViAuL47FWvl/6qSc2qRQ0JbRtF30KCp2JHXSJnzt18xStwEw1VhwVo8EoMTH8jiW+kQ0CEQoxTH6FzRB5Tsw4LFPvZMNZsoWTtj0NSjL+b0C/rV3VkFYKc/vFTQfVPB0pj1Ml/B7ReEVwgnMo4zJ9nr6f77/fXrJJRNSVw6okmLtIoalK12q/NMR+q/0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M80TYFXo733OYewJiEqB1CNEYS0jMakG7HcHblU5a9k=;
 b=Wv3OKClwC98rnq3o+Uc7qXOtK8PbL4tW5jpTe4Edtm2aaSSRjZzK4VbPWyoIe2/gS/uI/m08w5LNPN5ugUBHVtpWf/eTEGuiiVngxqhSPaI6fJWubY2/F2wa+o5zN7iovi0SUU5tDhYDcGgHWu0nvtgDQgXgOKMfrUHw1YYfN8Q=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH4PR10MB8121.namprd10.prod.outlook.com (2603:10b6:610:247::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Wed, 16 Apr
 2025 20:08:55 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8632.030; Wed, 16 Apr 2025
 20:08:55 +0000
To: io-uring@vger.kernel.org
Subject: [PATCH] man: Fix syscall wrappers in example code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Message-ID: <yq1o6wveuun.fsf@ca-mkp.ca.oracle.com>
Date: Wed, 16 Apr 2025 16:08:53 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN9P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::25) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH4PR10MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 370fbae8-8598-406e-1771-08dd7d2283d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1tqhZ71icKlWAjK1pVdKwtPKvDNYjz2E3KPDW+nFJejjxnBPrLYBNtt6LG8d?=
 =?us-ascii?Q?1p0XFE/y5Wc82O8PWUK2lcip4ltHFZ/uJU7R9BXWzh0APhtOnaAhhDs3R7qE?=
 =?us-ascii?Q?VzkQNm8TG5JNfriidaOZiZmREFq2SX26r7veNr5cOk2fUIFBMNJcuIqI2ar/?=
 =?us-ascii?Q?iy4zPOfAgtA7lsWeh8B+a5by/+nrR64RjLPo6ptaKgRzTD7Q6VMEtDMHtezp?=
 =?us-ascii?Q?4/r5bltOBhdYrIBI0B3aHtqRTXFclj9SWcE3d5ZSYoTQDFfq3oQK2F0+Kp8o?=
 =?us-ascii?Q?L1i8SErC52DBP0xqERceLu8m55QH0kZ8zX4BH5Gx9nbGho8uNdslvIFaqnY/?=
 =?us-ascii?Q?GLLQykyMiO9jOu5XqMTLwmyt6InTvt90SFzNexHqPothEauJ7tpVSpO/miyf?=
 =?us-ascii?Q?TqzVQuE/Quf7VSup7WhDfUSl/fDA4CNCw6dZHr8rbBLYUoNA33Znho8ZQMSm?=
 =?us-ascii?Q?YpVhaLKUaxf75IkemTyIsGHOnjuxwHhHgLbed2fDtVpi353IH/GxfopXmDtB?=
 =?us-ascii?Q?Tl1SChZOcoe9WN4aBafhgkXsfWQM2F/ANKW8UZHApbgBSURz14AJocJQeRLa?=
 =?us-ascii?Q?sg3v5UfHWUiCYDId9FRThJP20v0UmSF7XD1fpCM29lf4A0eygnbR6SC4fNEz?=
 =?us-ascii?Q?bMpqZY4A1c4pbN51bP3Tv5//N78yXJaHHtYBrEQ/JSj8WWIb4HG61oap+Vj0?=
 =?us-ascii?Q?fNwtCIE8fVwfThq+0TQuPCMcQXB2czeVPOXdGsWc+NfCiyhwxkYompKnxxCD?=
 =?us-ascii?Q?FiT+M3FHfQsNc3RuC4YuEyLJHXPEFjKw1t5imbk5f1jqe/dYkMrLOGBCP0ZT?=
 =?us-ascii?Q?4Mr0LV90kwIlOKKRp1uD75MLx+/FCRizisN65xQUly9KS45n93k1kIEaKDfi?=
 =?us-ascii?Q?To7nf7Jy13rL4r1+V/qiQYbJl9j0c+2b2rKVVG1HMT5bG/2r/umj1N0r0nc8?=
 =?us-ascii?Q?y6ePkR33yfb2jAij0DZmkJ2Udz1D3xeRUvD/KP2KrW2HLNcNMRl3kQFbYAUR?=
 =?us-ascii?Q?laqlXr9BL0kqN8OBH3Bii0bmf9em2yvsRCkbneD0I4/U+SD50qtY+3Gn5fTO?=
 =?us-ascii?Q?NqlKHtFT2NzPEknLufoWLziqnlB/i018DETpjvNgvrAMNL68zQrSixOh78/k?=
 =?us-ascii?Q?RBrblGUkZ680nFFAyBGupc4LB+YleYzgQVWYEGZzipWZgf6RjO25WN6/Xvt1?=
 =?us-ascii?Q?YdRga854kMefrV27b0RY3Cc2BqZlbxJRfT832ve654KgojgpYAGOUUuKJvzu?=
 =?us-ascii?Q?ZVMsVtdhq9Yt/PDOyw6eVSAwk6TEoGqVvUxX4E3B197ZoTcTVfYDyN9GkLvP?=
 =?us-ascii?Q?lP9S87tJkDC9zggz7oiJISNNoAaaS6uVjQXNDTm3TrrdYgp53ThjZiVTdzoe?=
 =?us-ascii?Q?pEbJ7RQjaxZoS+cTCRLwosVbVunAjwvLSnEOLZw5Rk0xGJfZ6dyHFSmxuQUU?=
 =?us-ascii?Q?fq0zY8dWTO8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LjMh5psOaLX9f2r2mZ+Ia6aG6i2qJJGIFklPby4thEA+JHMOEgZe6Q+NXqPm?=
 =?us-ascii?Q?S4bz5LvBfgHZp+2x0sM3rQzuEotpBCLu+gOfnIY5fAVH9sCBFMDgHiBBTLUZ?=
 =?us-ascii?Q?c9ujhVGj0BrQXeog3ocDg5VtV57hNKYUYEFrhpSNBO5uhSsJpy1rhpOuZGcb?=
 =?us-ascii?Q?N4viqy+R0tiPeTegQy/4dg4BBA5OpjC18oN0xIB32stedt1E6c2qeKiyuVzG?=
 =?us-ascii?Q?AQWfKbsf6pGioch2BewQ1xNYwjuJUTaiULkbpzFEnQgVhkTd+kk7qlHUfs9v?=
 =?us-ascii?Q?/JsmnWzAxDipzZlFZimC4vY2k8LR3bGIIGawa5li++2H5Opg5yi+bUaNTKxX?=
 =?us-ascii?Q?b/sZW5nQ2Yo8Ek/IV61MjciIHL6iyct1cP/pRDgMYjSRX3f7ILgJ2ekPI3Tm?=
 =?us-ascii?Q?3njBii16WWgWaGIQQ4iM1rU778b6X/r0vt6PHY4QTE5MemrUkyVabLjXrIP9?=
 =?us-ascii?Q?chhwaEOSaPe2IaET28HyisXz5K+/WxSc+PKNpTA5VOafuGM8iuLV2bXCFDbM?=
 =?us-ascii?Q?KWpd94ppLBD5QaX5r+pKcl7dFqknjM/ToOCc3OxGQrVnT+YOxGEi3iQrwg+d?=
 =?us-ascii?Q?e4A8fC1XQjE+jyatT6pV+f70Pr93/sUVagq4zupnJdWUEIWCIcdInwl9rTVs?=
 =?us-ascii?Q?Glti1T5arZXku3NSwGM0YWnGxuEdLkyoX444bxWz5cTBt3z90amSfT0uGY4T?=
 =?us-ascii?Q?oBdOx4H08wbm9sKnVtO21IEGteDz3v4oTw0dgwmmjcIE4us/Aqh3RSwUhLay?=
 =?us-ascii?Q?8/Au3WDSQgaWYSiBy/Gr3TzlLxRtPbAPnPUhWcfKsTL6o6zitnBZMgAESJwi?=
 =?us-ascii?Q?Vo7Pehd8kBQe4VE2m4TRKKBQODSj4VZHHqNVOnFlJjHj/00ZK8YEb1qt1trM?=
 =?us-ascii?Q?YYcb+jTvGswBPP8ZQI3PQhz0OZiF/cl8w87DkDlW0dKS9zHiZQmlM90c1X6X?=
 =?us-ascii?Q?RZ7deAPVPDW91SwbBOxHUck4IRe5y6jneEYAyMfmLLXb8xR44UjJCJjhGSC+?=
 =?us-ascii?Q?6ifhgCJsmKT3yCnt66KpF/iv6o0DCPa4jmP7yrxlrzEPZPj1co8xtfdDz/Je?=
 =?us-ascii?Q?7///aOOqln72qeBncbtjiUSiUIJ4PX5EGtVlPnEu7RU6JPbtFgyKrDGzsp8a?=
 =?us-ascii?Q?6qph6wm3mhAjm8xkoi8Iil8E2vp+X9Ti1FPUqoAgL7q6yl4iyW2x6xNxonbr?=
 =?us-ascii?Q?8390OGEA28Hn/5K4pOxoBAnHOyLawXVzB74VDGGyBxqYFmlk8Yjia91kbKU0?=
 =?us-ascii?Q?HThUTlpkSrtp1NSang4aw2Uxhs7MLRm4IjEtdeDB7xl1At8WB0zs3PeOCRo9?=
 =?us-ascii?Q?KHJErQIAGdWp+Y/E/ORmzL7rxFTvG5PCbSj4Eew/isUQ1AUCGdxZEAoarJPR?=
 =?us-ascii?Q?lFV3oM38wOq5jt3fxMTTMZx/wcnhd4N0OJHwwcCJRlB0X4XPlSofMYhCVTv1?=
 =?us-ascii?Q?WIWoma03VDGKfOOy8GTMrjkulQax9p/zHspLNF1YzkrFrXVOE8JSdY/4CyNS?=
 =?us-ascii?Q?yLuvNn0O3q8VpAdurSz5H2JPPqbPwnV8HK8gUvjJSViBoaWY5bisG0NJP59k?=
 =?us-ascii?Q?F7rDAjPuSqD6dBWEV5ZcgqICQg1U1I6LAyzWtsRiJKdkRq7Fpm6BaP+qLBi8?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VgQBk5U6IvEt6mPbEMXMX1tFlk2nuOScmr/LDbTHEnAyyeFoW5IAy0RVxYoZyvkd1WWNoMgjBVGNA97bA+VN43BrcMziY4bPhB2Sy4j4iTm0lTF5SJBoZk9Lun06ZJzjj6iNtCChnzdg9NmbA6fjvKiA5zzC1f994XgkJUuzG5CLpk9H9i7I/wI3cjwLndy4LvUoj1h6RsYA8SMJXyJhvGQj9HHvVntypaC+q2EWdmjrYOetHHE1MqarfbUZh69GG4oIbbDK3HJrV9OC4XA4qs6rq/+j+tlHd6moxI63Ek9rNb/M66N4yyImD34Fwah7ee6wQAyHkxfEqdVOnK1pYFp+yTySlSBqWnCmES4NtjolO1++2AdGVptd2N8ATj5M+tog2wgeKmkQanzdVDdYudEtV4Szdzqm7u8AQeOx9QLX8M4CpmNzBtGSNqkSnrwK3X8zmiuNySxDVqlHRfwoNAyFLqnWf8Lo94r76shcXb544oVBGPZx2hViEZPuzz0WoZD0fzXccY6hFOqvWV2FpV0IgDoGeQ4GpOpBKMnp9NFvKb6/BIq5LT9BwZQj23q+/LUyOH74lHiI6TYOh4HLiaITY/0y0HHOzsilNfUt7bw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 370fbae8-8598-406e-1771-08dd7d2283d2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 20:08:55.1856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9bHHn2dYZ8GfTSDAiavqP5cDc69fyHSg9sN0KlgXWf42BLtNK5JHZlvxXcHr5FjFpXk70vqV/r9ixbmynYGlFo0X6xWMlgOvpQ6MgEFewd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8121
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_07,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504160165
X-Proofpoint-GUID: SxkeHjlDJT-YjFpXLus59_N7C5SPrNVK
X-Proofpoint-ORIG-GUID: SxkeHjlDJT-YjFpXLus59_N7C5SPrNVK


The example code in io_uring.7 provides two wrappers for the io_uring
syscalls. However, the example fails to take into account that glibc's
syscall(2) returns -1 and sets errno on failure. This means that any
errors returned by the provided wrapper functions will be reported as
-EPERM which could lead to incorrect error handling actions being
taken.

Adjust the two example wrappers to match arch/generic/syscall.h. This
makes them follow the documented io_uring calling convention which
reports a call error as a negative return value.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/man/io_uring.7 b/man/io_uring.7
index 49cdc25290e7..b6c092b60201 100644
--- a/man/io_uring.7
+++ b/man/io_uring.7
@@ -651,14 +651,18 @@ off_t offset;
 
 int io_uring_setup(unsigned entries, struct io_uring_params *p)
 {
-    return (int) syscall(__NR_io_uring_setup, entries, p);
+    int ret;
+    ret = syscall(__NR_io_uring_setup, entries, p);
+    return (ret < 0) ? -errno : ret;
 }
 
 int io_uring_enter(int ring_fd, unsigned int to_submit,
                    unsigned int min_complete, unsigned int flags)
 {
-    return (int) syscall(__NR_io_uring_enter, ring_fd, to_submit,
-    			 min_complete, flags, NULL, 0);
+    int ret;
+    ret = syscall(__NR_io_uring_enter, ring_fd, to_submit,
+                  min_complete, flags, NULL, 0);
+    return (ret < 0) ? -errno : ret;
 }
 
 int app_setup_uring(void) {

