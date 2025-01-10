Return-Path: <io-uring+bounces-5810-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB0AA0995A
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 19:30:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94C723AAE6F
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 18:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404A5213E9C;
	Fri, 10 Jan 2025 18:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QIYAEDR4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DtgGhm1Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8F420ADC9;
	Fri, 10 Jan 2025 18:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736533803; cv=fail; b=VfiATIRutSUsgHcodiExSMjBIZ03TImvlgEaeCBVKUQWEz400melMVvJbjip3cGGsQyDHpdwT9LmAm79/a/28ExtDhacs4D7H2wUsmoGPJHJhmaMdMugIhOUsaxCqm24RbXX1MJ+JD+X+E2AsYn3yzxEi5gWufdkFigyQ6UNMXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736533803; c=relaxed/simple;
	bh=W5hyHwmEO3fp4xRIFeIKpRW4z0L+JH9xhPtAr28uHls=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=niBJQTIWfaROYz8ufzN0Tcgb34TYFIXMWsbVVwjR+MATRumB9h/eGessvuUTo7HMHHJaAZojStejZqCSZqAANsgwXZokJacau2XTl3I9xI9sZUVWbKUWDaCZuDUUDGYXxWxCkWNn1VMobPl4BXx3BC0V+yMOySrFs5rM7ZZUT8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QIYAEDR4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DtgGhm1Z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50AENVpw011181;
	Fri, 10 Jan 2025 18:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=W7mtJ3WCcffux8eqMD/ETD2swTMDIpFx4tMiUR+oRt0=; b=
	QIYAEDR4m7xulzGoWGMBZHAq//9iln73Lyrgg5cWT1PnanJccaeFx3dHV19chYTt
	KZ+kZXf2G3Nd5kHses2yyNWfZMDTun0plKqh93cj21FixKBNF3FVN3Dk4S8z5U3p
	wutfd+eBvcj0aAnft9C6RW2T25BtLoDQd1UtgzFoAypcFhZzBmtYjbrr2f31xkBo
	uRHELcc4ymfIW32P9NX7KSRdsQ+BJ+vcjmOOXmxBVJDlwDgrxZLbDMssn2qDxPQx
	Nq9jhTAIIu493S0f4Kq6sD3xWCc5r8smKgYXr1ImFg1iP+6l+8UNqpJfDBH+rzWD
	AmT/fbDAIGdn0i4iuVLTXQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442gy5tfaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 18:28:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AI03Ra010741;
	Fri, 10 Jan 2025 18:28:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecmagc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 18:28:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uqS01L7ITl19F1Rdy06zyJECe8yNOk+e9h0rNFukUXxFJDtKDLkFvoodL+YkuANaltHVCqbfFb1R6/VKxVUEO6FBqVetuoBuuGVaWqEP2QyJ5t6u/S9m99mVbNPULN1MIL0a4Y0qmWqeVvpq24y/Ad7i+o+wt/fDIoCDIcj1s8vWXjV+mQ1J2ZsLHWbRijzLvJIa/FvxCafVZM3gfwtlNtkqT6NkChyp8Bd4iMhEJ03DWzxtvpIKV+kIMZW7Vn9tZCh95MHoubVYDD6RpKW+NOHYGQkZKor0p6EVLy8d6KzoJQ76+mWtvIklZZHpmvaybuBCO2JAXvOZTKu9EsY2Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7mtJ3WCcffux8eqMD/ETD2swTMDIpFx4tMiUR+oRt0=;
 b=JFtHSOXPFImBK1oyOTQqG8S3UZHfDN5PO3ur9o7yaq90JKi+JxZLCW27Pw53aSTXE1+4PXt1dKO+DHUCtpVWbNVUuqIb6tRThuPlKxbdbLfljEy8+wtX5rolArWcCwFoNAexnO4RcPFcc/TSma+42nt8yLak+Owf7Xbo4cserWZ9wO0nymva5HC1A89jM4vbuGPWA17DCT5B/Mn9RawtI1ruc5SZK0HO4lRGLTQEyaDWYebw2+Rwm74p3g6w7sU2VximsN2FPH9sBhADWYOP3H0oNQic3B66CF6pFLoBH2oeofs1wI66CJFNIaDwv5gDLY06Xj3dYp8zPIpr208jiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7mtJ3WCcffux8eqMD/ETD2swTMDIpFx4tMiUR+oRt0=;
 b=DtgGhm1ZEwE0FIgKigdoEgK7pGcSmJ/XNfQFP/eWgpuhoxf9ihGj3F2Cz02gb94M9pjiamJ5uyLVGeIpUaVvF6Zmo9HFY5Y6odez8lrzE3q8m6dG/CXIBYNiY/Gg4LSlQzW51+3WniYR68gwkaCVY5OiMa8jx21kSJ7HuIZV33Y=
Received: from BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15)
 by SA3PR10MB7070.namprd10.prod.outlook.com (2603:10b6:806:311::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Fri, 10 Jan
 2025 18:28:20 +0000
Received: from BY5PR10MB4290.namprd10.prod.outlook.com
 ([fe80::8c24:37e7:b737:8ba5]) by BY5PR10MB4290.namprd10.prod.outlook.com
 ([fe80::8c24:37e7:b737:8ba5%4]) with mapi id 15.20.8335.012; Fri, 10 Jan 2025
 18:28:20 +0000
Message-ID: <01938969-7e33-4f0b-9795-902ef820e2b9@oracle.com>
Date: Fri, 10 Jan 2025 13:28:14 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] treewide: const qualify ctl_tables where applicable
To: Joel Granados <joel.granados@kernel.org>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Kees Cook <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-xe@lists.freedesktop.org, linux-hyperv@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev,
        codalist@coda.cs.cmu.edu, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
        fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
        io-uring@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        Song Liu <song@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Corey Minyard <cminyard@mvista.com>
References: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>
Content-Language: en-US
From: Anna Schumaker <anna.schumaker@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250110-jag-ctl_table_const-v2-1-0000e1663144@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::24) To BY5PR10MB4290.namprd10.prod.outlook.com
 (2603:10b6:a03:203::15)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:EE_|SA3PR10MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cf3f591-697e-4fec-7b51-08dd31a48ed6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|10070799003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R3FnS01kbzJzK1VNaXlVbkh0Q3JrWlEvQkYvUEhMUVpRVVFLOTV6OWRRWVBt?=
 =?utf-8?B?UG4ySzNCYjZhbDF3Y3lJeDBHc1BxOUl6cU9CY3FMc0kvcURsNEFZa2NoUUdU?=
 =?utf-8?B?c2E3SDZPc0xSOVFWRlVlMGxqL1k4VTREZzNHc2dpK1hlSjZHNEZLVFNvYzVN?=
 =?utf-8?B?QW84NmpTT3ZkMFRWYkR3QzgwY1pLTGJiSlpwSVNlNTBvTC90dFkrY0Y0YnE1?=
 =?utf-8?B?aENWdFh0L09JUUNtaHVTdkZVRVhUNExHWU1nT2xMc1R1RjJMK3lNTHpnMDNw?=
 =?utf-8?B?a3M1TUVOcU9teUxRdUZaYVMyTDRJMGZMWVpYWkFTcUtjTkpGd3dLRGs4VTU2?=
 =?utf-8?B?YU1EVlBQQk41MXJDSW5RdGQybFh6OC9zQW9TSVFHemRheVVFZHcvUVFrV25Z?=
 =?utf-8?B?ZDA5MFV1dzU0ZkxmVEtWZjdlK2I0WHhDK1d0TUNmTFp6bGxiN1kydlhjR285?=
 =?utf-8?B?MXVZU3pjOVpLYndNR2hwUnZZTXFQRUlpVXpXcTlmSUJ1aFg5ZitqT0RyYzU4?=
 =?utf-8?B?aHNJL1dvZ1JjalZVQmx5QzFZa1ZuVFpJVFVvRll1cTJuTkh4UDFHbm1FVVNK?=
 =?utf-8?B?aGNZS2xMMHZLc05uKzc4NXhDUk84dEJvRWdUazZPREVleVhCblZhSVZNdXNm?=
 =?utf-8?B?ZURPSmc4MDBwWkNPaS96Q1dQTDFvYkxXelliY3VCQlpFaUtqYUdxVDQ3TlVo?=
 =?utf-8?B?RzkzRnJHQ0RKaDdjWkxzYUVsd2NDVXBKdjEwS1BMbEdCcExOdkJxdXR6YlhT?=
 =?utf-8?B?ZFhjOTZITGt3c043Y1RZL1JkaXcwYnFsSnB6TFBEZVd3QzI4emhVZ2dZOW1i?=
 =?utf-8?B?TWZWOFBXMk5aUmZjWkpzVHFXdDd5eHBTQm5XRVZCVXFJaS9PanVwWDdCYlU3?=
 =?utf-8?B?WUNEZ2ZKRjlRVWFaUFRkazc2WEUyY1JJVmVsRk1uVzZ0Wm9Ea0Y1cEhIcTZF?=
 =?utf-8?B?OEFsNGZ1L252U1ZRZ2gxck5TdXI3Q3dPSHh4VEJGSW42OGlPWUt3R2dyL0dh?=
 =?utf-8?B?Rlp2WThFOTB5NnNFUmJjYXN0VVREWDU3RDhWVk9qZk5ianNQd2xLWFJMb0FH?=
 =?utf-8?B?L3BaejVSVWdjN3JnSnRQUEx3b2t5K3AvREVsM2gyOU1WenpRZUhhT1RNb3Rl?=
 =?utf-8?B?Uk9zb1lhT0ZKbzVYaDZONVdaRm5GK1VLcVEwNHZTUkxxbHR3MFgvWmRtR0Fn?=
 =?utf-8?B?b0tYZllZV1lkMEVFb1pyMGc1dEQwTWJWZWlObXowM3RwVzI2d0pIcXhGYWxx?=
 =?utf-8?B?U2FOSDZqUHhUeUFkZUpXZWxXMzV4Q2Y1ZCtlUkkyeUF4WmFDS3RjeGk1OS81?=
 =?utf-8?B?ZkR6OTlTQmk3Y2M0dW5PRjZKZS96bk9lbFo2blFyV1A3ckV1ZFhDU0p1aFNG?=
 =?utf-8?B?TDlJUHI5THNBM2Q2TjhpK2NvdVlBQkRXWlJqZWhlRHE5b2tiOGNZT0wxbzNa?=
 =?utf-8?B?Vm5DMjVFazQ0TUp1NUZCSXhHcnE5YzZOajhEUHRLTzY0cExTYXA3czNUZ21U?=
 =?utf-8?B?SlorVWVxODFzeEZWNzFpTkVic3RCamx3NUkyWStqSngxWjg4VVI0TDlDWlFa?=
 =?utf-8?B?OWpiWXl0bUNsdjFqOEs3cnkyM1E3V3JBUVNPMGd5aDBGajUzS2RmZWlhbWdi?=
 =?utf-8?B?a1dnR0dnWnRHWmJQS2x5K21sNmZyeUk0dkdPWjhQRVUrbU1yZnZwQ3Q5VWJ2?=
 =?utf-8?B?OUxxelF4dDVrbVhFVWo0NXQ5MkxNUzhMY2Uwb0RGN29wSG5wSW9KblRCcWpU?=
 =?utf-8?B?Z2pvV3lyZllIdkZmbWNOREFJa2IxYlNlcVc1T0hjNVRXM1Bjbk84K0VkSXdt?=
 =?utf-8?B?YkJ6NkhrWWh6RTJiYkh0bTF5NzQwU2xZMEhaOXlBQm83NEs1L0J2c2JZcDBT?=
 =?utf-8?B?MmpqNVF1ZmF2M3BjNkZCVXJrVmYzcEwrSjJQWjV5QXJmOFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(10070799003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDhsK1BDOVFnekh4UXVGRUNSVjM5UjJmcVFDaXQyNXpYRkNhWmJXY2NWcjVJ?=
 =?utf-8?B?a3lpNTVmeXZpNyt4TTNJU1l1N2c0RHE5dUEyUUlhSVJXdXhpSEk0RjhFeHZY?=
 =?utf-8?B?N0dEcWp5SWhrVm9xTkNWUVFuV0JMNUtYUU56V3VYWWNCWDcrMVBpbXNlWHl6?=
 =?utf-8?B?aWhHem5XNG9WNlRnN0VEb0hrMWlxMHNNNGRBdEJyREFOdkN2QWk2WlNDOC9j?=
 =?utf-8?B?UHpGMCtiakFmb0J2TnhxZXUxQjNQVDgrUmhvM1RDQUZ6YjlWYnVOeDJhTHZY?=
 =?utf-8?B?VHIyTDg5UFR1VktKbXB6NC96Z05ac0ZZaGxXRFRwcXZ4ak9KRDVIaG5JRWdh?=
 =?utf-8?B?Zlk4cmIxSld6V1RtMzlEeGRTVjNMVWozcThJY01QWWNSUFZVSjV2M3VJaWxx?=
 =?utf-8?B?L3hIQjE0VWJPaW4wNzB2cldOVndndFZDVHNkb2cvaFRucHpiekJNVDM5L1ho?=
 =?utf-8?B?Qk84RFFPSDdTVCtZRkJsUlZSeTZVQUNWK1VxVlNSbWszSndjTXJES2dnc2ps?=
 =?utf-8?B?SjhRdHpjdjNsRkFmUEJ6UGE0M01UV3JtQjV2R3haVCtRaFgrcml5SUJZM1JT?=
 =?utf-8?B?Y00vYlRvMm93ZVYydFA1VjVzNFhVZXE2Z3EycStWZjdZVDg1bDFjZnpYRGxF?=
 =?utf-8?B?VWgrMkFvU1dVWXFDWlNvN01lNHArTGQwbUZ6NkJDQzY0c21wR1pLK00va1Vv?=
 =?utf-8?B?SGlxcUdIMlZyMEJrNjNCbFp3dGRQWmFNTzNzaHprckNTNTd0ZHNYOXlXTTN2?=
 =?utf-8?B?Tzk4UGVTYVA3NUpqbHRsblJGUXh5a0VvRXJuWmxjdmw0NzRqMWl4WlVIN01w?=
 =?utf-8?B?N2ZxTWhRS0RLYlFaczROcGoxMldIREZFcDNYaTJzK3RybmRBYjZPVWlSUGJK?=
 =?utf-8?B?Nkc3YzRnYkVEd3dDOWZxa2N6MG5NS1loTDZlWmxiWmQxUVZkVVE2Y2k4TlRy?=
 =?utf-8?B?RFZVSlBxQS9iQzh5cFlialVzTzB4VG13Um02dURjeDlSRGpEeUE1ZmFKL29R?=
 =?utf-8?B?Z0JwbS80Qm1NbEhNQ3BMMlFDU2pITWNyaVVxTnBrSFhzeU9ESzdBdGZEckhK?=
 =?utf-8?B?am1VdmFrVjhlaUo4SXg5NjBpQTVGRmhWajRqMUJRM2lZUDF4RVdYMXlmUHlM?=
 =?utf-8?B?bWl1S242WnhIU3RJdlJtZHZSb2xUQzVHTDVNMmxOMGlmdlhRL25ubUtWT2Rn?=
 =?utf-8?B?Wmo1Mmg3c25QWFpmYjI4WW5SdWpzKzVhMmUvNGR6STJCLzFVb2ZqVTlDUDRX?=
 =?utf-8?B?ZU4yb0hKQkgrYnBzUlVkZFVkVmVPQlVoRjVwb2lMMEU4NVRhUFNBLzZhbjZ3?=
 =?utf-8?B?WllyODZYNUFYVXMyNlF4NmRqaWMycm84NnM4ZVJIb3VEQk1pOVJoVWJYcnJj?=
 =?utf-8?B?T244YUFkdlhaYVhRRlBONXY1MVdwMEhneitad0VRR0t6RGl3cTdYczFjTXRC?=
 =?utf-8?B?Z211SnBTWlRhWlJmcmUwRFV3MWNiWXpCbGxMcmJHOHpDdlk3ckRYd3duVGU3?=
 =?utf-8?B?SHpKdUxQUzd4cm5GbGtuMGN6ZHRKSWRiR0tldWl6a2paVkI3dXVSalhLODR2?=
 =?utf-8?B?eGhDSW1zejFhRE9venJsdWtmZ1R6LzF6VkI1dHZoKzhSL25JT3pCaTFOZ2U5?=
 =?utf-8?B?aDgxL05xbW1zODZ2eExJd2x6T3NpL2ZVMEhWN3lXdVFudnpkQ0NXVjh3cjNx?=
 =?utf-8?B?TStHNjlOY3VDaDBDY0ZNTldMTkhJNkFFMzMyN0RTSmZTSnhxbitnd29DS2Nz?=
 =?utf-8?B?MGM2R3JBUHZNTkdBUUtuaTU1eXQ3M00wNmVoMUY5NDI0WWhPR2laS3RDODA2?=
 =?utf-8?B?SWJnRnpTK0FtWUREcWc5Z01PYktwSXVjalRLM0pvYlJaNHYzall3TjFFTW54?=
 =?utf-8?B?Z2R6WUlVelBiVVdVZ3BCS3FWOE5tTkpaUG9rTk1XbTY3Rjc1K0tuMjZhT01u?=
 =?utf-8?B?QWJSYnAyU0lYb1V6Nzg5KzFKK3R1Zmh4Q0pDNVdTdkdTenJ2SFI0WmllVkR2?=
 =?utf-8?B?RHA1akhQa3huZEdlZDB0SDMyNFNWcExmUzdOeWx4M1hXbVlwM1BBQ0xnc1Ny?=
 =?utf-8?B?eEFSVGJmc3kwNXlKNHE4dHJETEZEQjM4bXNGck1CaHN3eHZZb0FjTkwyNFpy?=
 =?utf-8?B?Q0Q0T212NThOZEdxTHQ2WDYrbHQrSHR3SklyV0dZQXorNzFJYVUwdUNqcy8y?=
 =?utf-8?B?MGlmeFd4RDN0cE5qenNjMU9UbmJoNmdNYzhoS3pCWDN4azNLNEdxdS9iUHpE?=
 =?utf-8?B?aU8yZ2g0TGdHNXdHV2JTVUhvZ3dRPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oj7aGN9hcKrPmyEOyr4mR5ddzuJD+2k7kTovztLlPEOioxtOYwiQC+X1Mv0OkMpDAqdNuMpYbELmmEC5npdVBXU8UKMW02gUTWiFkiROZWa9sN86cEfNVwcq4y8D9Gt5vxtJFLx7iNklJBrx4LlHKZ1N4uLmPTl6Ams5/WU8eR9Rrl0QcOsHZFQ4aRQBC7/bRMgaiUYXRLZfXzkG+g9pAL9D0eGeGibbR0cQFhSTvRIoSOKCGylSzqUGP09MwWc70kWa3/UqM/KMLbaVzXD3+P6oqp+NSwOwZkPgCU5ZP8FVp2pgCX5TYCLXmAHSxHuS4cT9wdhzGbjyDQPwyhwlMIuBN/j+WyMA70McO9X38uRMi9PvWSxw0WH6JLaUrGZtrOt8h4F3F9s/ui2vQ8DUh4GaDNkh/yOfWJFNNGXIYvYnaWTmbzQY4u9vLHdJKEV0emLHJkD/NYTfRqe8Os9KI8tiGNkRG7XhbGQzTeVdqerUnHCPOsooU8ZRZ7aC6WkLP9mkK9IJfZqMrn9GiMLLIzM6M3NR1jSYXAXW8zTvPiWVAnnLpaHvXYumSaVjdFIu3V7OZgkzUX95WLHEQKjZpvWp052xvBGSMKgJ46hcwtQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf3f591-697e-4fec-7b51-08dd31a48ed6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 18:28:20.0827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 09dwvkNRrREDFT6C4M8228Qnb5kz8FlskU1Fnh6ttLSD6iS52NqarewETBNNxZ+n1Nm6ZQKQ/ojUOTs9T/AWIAwyjKQ6ywsox4g4wSALHv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7070
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_08,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501100143
X-Proofpoint-GUID: MmnmhWMkijCiFmhVT1K6ZlJGdFi68d7i
X-Proofpoint-ORIG-GUID: MmnmhWMkijCiFmhVT1K6ZlJGdFi68d7i



On 1/10/25 9:16 AM, Joel Granados wrote:
> Add the const qualifier to all the ctl_tables in the tree except for
> watchdog_hardlockup_sysctl, memory_allocation_profiling_sysctls,
> loadpin_sysctl_table and the ones calling register_net_sysctl (./net,
> drivers/inifiniband dirs). These are special cases as they use a
> registration function with a non-const qualified ctl_table argument or
> modify the arrays before passing them on to the registration function.
> 
> Constifying ctl_table structs will prevent the modification of
> proc_handler function pointers as the arrays would reside in .rodata.
> This is made possible after commit 78eb4ea25cd5 ("sysctl: treewide:
> constify the ctl_table argument of proc_handlers") constified all the
> proc_handlers.
> 
> Created this by running an spatch followed by a sed command:
> Spatch:
>     virtual patch
> 
>     @
>     depends on !(file in "net")
>     disable optional_qualifier
>     @
>     identifier table_name != {watchdog_hardlockup_sysctl,iwcm_ctl_table,ucma_ctl_table,memory_allocation_profiling_sysctls,loadpin_sysctl_table};
>     @@
> 
>     + const
>     struct ctl_table table_name [] = { ... };
> 
> sed:
>     sed --in-place \
>       -e "s/struct ctl_table .table = &uts_kern/const struct ctl_table *table = \&uts_kern/" \
>       kernel/utsname_sysctl.c
> 
> Reviewed-by: Song Liu <song@kernel.org>
> Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org> # for kernel/trace/
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com> # SCSI
> Reviewed-by: Darrick J. Wong <djwong@kernel.org> # xfs
> Acked-by: Jani Nikula <jani.nikula@intel.com>
> Acked-by: Corey Minyard <cminyard@mvista.com>
> Signed-off-by: Joel Granados <joel.granados@kernel.org>
> ---
> This treewide commit builds upon the work Thomas began a few releases
> ago [1], where he laid the groundwork for constifying ctl_tables. We
> implement constification throughout the tree, with the exception of the
> ctl_tables in the "net" directory. Those are special in that they treat
> the ctl_table as non-const but we can take them at a later point.
> 
> Upstreaming:
> ===========
> It is late in the release cycle, but I'm hopeful that we can get this
> in for the upcoming merge window and this is why:
> 1. We don't use linux-next: As with previous treewide changes similar to
>    this one [1], we avoid using linux-next in order to avoid unwanted
>    merge conflicts
> 2. This is a non-functional change: which lowers the probability of
>    unforeseen errors or regressions.
> 3. It will have at least 2 weeks to be tested/reviewed: The PULL should
>    be sent at the end of the merge window, giving it at least 2 weeks.
>    And if there are more release candidates after rc6, there will be
>    more time.
> 
> Testing:
> ========
> 1. Currently being tested in 0-day
> 2. sysctl self-tests/kunit-tests
> 
> Reduced To/Cc:
> ==============
> b4 originally gave me 200 ppl that this should go out to (which seems a
> bit overkill from my point of view). So I left the mailing lists and
> reduced the To: the ppl previously involved in the effort and sysctl
> maintainers. Please tell me if I missed someone important to the
> constification effort.
> 
> Comments are greatly appreciated.
> 
> Changes in v2:
> - watchdog_hardlockup_sysctl, memory_allocation_profiling_sysctls,
>   loadpin_sysctl_table, iwcm_ctl_table and ucma_ctl_table where removed
>   from patchset as they change the sysctl array before registration.
> - Added reviewed-by tags
> - Link to v1: https://lore.kernel.org/r/20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org
> Best
> 
> [1] https://lore.kernel.org/20240724210014.mc6nima6cekgiukx@joelS2.panther.com
> 
> --
> ---
> 
> ---
>  arch/arm/kernel/isa.c                         | 2 +-
>  arch/arm64/kernel/fpsimd.c                    | 4 ++--
>  arch/arm64/kernel/process.c                   | 2 +-
>  arch/powerpc/kernel/idle.c                    | 2 +-
>  arch/powerpc/platforms/pseries/mobility.c     | 2 +-
>  arch/riscv/kernel/process.c                   | 2 +-
>  arch/riscv/kernel/vector.c                    | 2 +-
>  arch/s390/appldata/appldata_base.c            | 2 +-
>  arch/s390/kernel/debug.c                      | 2 +-
>  arch/s390/kernel/hiperdispatch.c              | 2 +-
>  arch/s390/kernel/topology.c                   | 2 +-
>  arch/s390/mm/cmm.c                            | 2 +-
>  arch/s390/mm/pgalloc.c                        | 2 +-
>  arch/x86/entry/vdso/vdso32-setup.c            | 2 +-
>  arch/x86/kernel/cpu/bus_lock.c                | 2 +-
>  arch/x86/kernel/itmt.c                        | 2 +-
>  crypto/fips.c                                 | 2 +-
>  drivers/base/firmware_loader/fallback_table.c | 2 +-
>  drivers/cdrom/cdrom.c                         | 2 +-
>  drivers/char/hpet.c                           | 2 +-
>  drivers/char/ipmi/ipmi_poweroff.c             | 2 +-
>  drivers/char/random.c                         | 2 +-
>  drivers/gpu/drm/i915/i915_perf.c              | 2 +-
>  drivers/gpu/drm/xe/xe_observation.c           | 2 +-
>  drivers/hv/hv_common.c                        | 2 +-
>  drivers/macintosh/mac_hid.c                   | 2 +-
>  drivers/md/md.c                               | 2 +-
>  drivers/misc/sgi-xp/xpc_main.c                | 4 ++--
>  drivers/perf/arm_pmuv3.c                      | 2 +-
>  drivers/perf/riscv_pmu_sbi.c                  | 2 +-
>  drivers/scsi/scsi_sysctl.c                    | 2 +-
>  drivers/scsi/sg.c                             | 2 +-
>  drivers/tty/tty_io.c                          | 2 +-
>  drivers/xen/balloon.c                         | 2 +-
>  fs/aio.c                                      | 2 +-
>  fs/cachefiles/error_inject.c                  | 2 +-
>  fs/coda/sysctl.c                              | 2 +-
>  fs/coredump.c                                 | 2 +-
>  fs/dcache.c                                   | 2 +-
>  fs/devpts/inode.c                             | 2 +-
>  fs/eventpoll.c                                | 2 +-
>  fs/exec.c                                     | 2 +-
>  fs/file_table.c                               | 2 +-
>  fs/fuse/sysctl.c                              | 2 +-
>  fs/inode.c                                    | 2 +-
>  fs/lockd/svc.c                                | 2 +-
>  fs/locks.c                                    | 2 +-
>  fs/namei.c                                    | 2 +-
>  fs/namespace.c                                | 2 +-
>  fs/nfs/nfs4sysctl.c                           | 2 +-
>  fs/nfs/sysctl.c                               | 2 +-
>  fs/notify/dnotify/dnotify.c                   | 2 +-
>  fs/notify/fanotify/fanotify_user.c            | 2 +-
>  fs/notify/inotify/inotify_user.c              | 2 +-
>  fs/ocfs2/stackglue.c                          | 2 +-
>  fs/pipe.c                                     | 2 +-
>  fs/quota/dquot.c                              | 2 +-
>  fs/sysctls.c                                  | 2 +-
>  fs/userfaultfd.c                              | 2 +-
>  fs/verity/init.c                              | 2 +-
>  fs/xfs/xfs_sysctl.c                           | 2 +-
>  init/do_mounts_initrd.c                       | 2 +-
>  io_uring/io_uring.c                           | 2 +-
>  ipc/ipc_sysctl.c                              | 2 +-
>  ipc/mq_sysctl.c                               | 2 +-
>  kernel/acct.c                                 | 2 +-
>  kernel/bpf/syscall.c                          | 2 +-
>  kernel/delayacct.c                            | 2 +-
>  kernel/exit.c                                 | 2 +-
>  kernel/hung_task.c                            | 2 +-
>  kernel/kexec_core.c                           | 2 +-
>  kernel/kprobes.c                              | 2 +-
>  kernel/latencytop.c                           | 2 +-
>  kernel/locking/lockdep.c                      | 2 +-
>  kernel/panic.c                                | 2 +-
>  kernel/pid_namespace.c                        | 2 +-
>  kernel/pid_sysctl.h                           | 2 +-
>  kernel/printk/sysctl.c                        | 2 +-
>  kernel/reboot.c                               | 2 +-
>  kernel/sched/autogroup.c                      | 2 +-
>  kernel/sched/core.c                           | 2 +-
>  kernel/sched/deadline.c                       | 2 +-
>  kernel/sched/fair.c                           | 2 +-
>  kernel/sched/rt.c                             | 2 +-
>  kernel/sched/topology.c                       | 2 +-
>  kernel/seccomp.c                              | 2 +-
>  kernel/signal.c                               | 2 +-
>  kernel/stackleak.c                            | 2 +-
>  kernel/sysctl-test.c                          | 6 +++---
>  kernel/sysctl.c                               | 4 ++--
>  kernel/time/timer.c                           | 2 +-
>  kernel/trace/ftrace.c                         | 2 +-
>  kernel/trace/trace_events_user.c              | 2 +-
>  kernel/umh.c                                  | 2 +-
>  kernel/utsname_sysctl.c                       | 4 ++--
>  kernel/watchdog.c                             | 2 +-
>  lib/test_sysctl.c                             | 6 +++---
>  mm/compaction.c                               | 2 +-
>  mm/hugetlb.c                                  | 2 +-
>  mm/hugetlb_vmemmap.c                          | 2 +-
>  mm/memory-failure.c                           | 2 +-
>  mm/oom_kill.c                                 | 2 +-
>  mm/page-writeback.c                           | 2 +-
>  mm/page_alloc.c                               | 2 +-
>  security/apparmor/lsm.c                       | 2 +-
>  security/keys/sysctl.c                        | 2 +-
>  security/yama/yama_lsm.c                      | 2 +-
>  107 files changed, 115 insertions(+), 115 deletions(-)
> 
> diff --git a/arch/arm/kernel/isa.c b/arch/arm/kernel/isa.c
> index 905b1b191546..db8be609fab2 100644
> --- a/arch/arm/kernel/isa.c
> +++ b/arch/arm/kernel/isa.c
> @@ -16,7 +16,7 @@
>  
>  static unsigned int isa_membase, isa_portbase, isa_portshift;
>  
> -static struct ctl_table ctl_isa_vars[] = {
> +static const struct ctl_table ctl_isa_vars[] = {
>  	{
>  		.procname	= "membase",
>  		.data		= &isa_membase, 
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 8c4c1a2186cc..2b601d88762d 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -562,7 +562,7 @@ static int vec_proc_do_default_vl(const struct ctl_table *table, int write,
>  	return 0;
>  }
>  
> -static struct ctl_table sve_default_vl_table[] = {
> +static const struct ctl_table sve_default_vl_table[] = {
>  	{
>  		.procname	= "sve_default_vector_length",
>  		.mode		= 0644,
> @@ -585,7 +585,7 @@ static int __init sve_sysctl_init(void) { return 0; }
>  #endif /* ! (CONFIG_ARM64_SVE && CONFIG_SYSCTL) */
>  
>  #if defined(CONFIG_ARM64_SME) && defined(CONFIG_SYSCTL)
> -static struct ctl_table sme_default_vl_table[] = {
> +static const struct ctl_table sme_default_vl_table[] = {
>  	{
>  		.procname	= "sme_default_vector_length",
>  		.mode		= 0644,
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 2968a33bb3bc..42faebb7b712 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -859,7 +859,7 @@ long get_tagged_addr_ctrl(struct task_struct *task)
>   * disable it for tasks that already opted in to the relaxed ABI.
>   */
>  
> -static struct ctl_table tagged_addr_sysctl_table[] = {
> +static const struct ctl_table tagged_addr_sysctl_table[] = {
>  	{
>  		.procname	= "tagged_addr_disabled",
>  		.mode		= 0644,
> diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
> index 30b56c67fa61..e527cd3ef128 100644
> --- a/arch/powerpc/kernel/idle.c
> +++ b/arch/powerpc/kernel/idle.c
> @@ -97,7 +97,7 @@ void power4_idle(void)
>  /*
>   * Register the sysctl to set/clear powersave_nap.
>   */
> -static struct ctl_table powersave_nap_ctl_table[] = {
> +static const struct ctl_table powersave_nap_ctl_table[] = {
>  	{
>  		.procname	= "powersave-nap",
>  		.data		= &powersave_nap,
> diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
> index 1798f0f14d58..62bd8e2d5d4c 100644
> --- a/arch/powerpc/platforms/pseries/mobility.c
> +++ b/arch/powerpc/platforms/pseries/mobility.c
> @@ -53,7 +53,7 @@ struct update_props_workarea {
>  static unsigned int nmi_wd_lpm_factor = 200;
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table nmi_wd_lpm_factor_ctl_table[] = {
> +static const struct ctl_table nmi_wd_lpm_factor_ctl_table[] = {
>  	{
>  		.procname	= "nmi_wd_lpm_factor",
>  		.data		= &nmi_wd_lpm_factor,
> diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
> index 58b6482c2bf6..7891294abf49 100644
> --- a/arch/riscv/kernel/process.c
> +++ b/arch/riscv/kernel/process.c
> @@ -364,7 +364,7 @@ static bool try_to_set_pmm(unsigned long value)
>   * disable it for tasks that already opted in to the relaxed ABI.
>   */
>  
> -static struct ctl_table tagged_addr_sysctl_table[] = {
> +static const struct ctl_table tagged_addr_sysctl_table[] = {
>  	{
>  		.procname	= "tagged_addr_disabled",
>  		.mode		= 0644,
> diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
> index 821818886fab..d022b028ac3f 100644
> --- a/arch/riscv/kernel/vector.c
> +++ b/arch/riscv/kernel/vector.c
> @@ -287,7 +287,7 @@ long riscv_v_vstate_ctrl_set_current(unsigned long arg)
>  
>  #ifdef CONFIG_SYSCTL
>  
> -static struct ctl_table riscv_v_default_vstate_table[] = {
> +static const struct ctl_table riscv_v_default_vstate_table[] = {
>  	{
>  		.procname	= "riscv_v_default_allow",
>  		.data		= &riscv_v_implicit_uacc,
> diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
> index 91a30e017d65..dd7ba7587dd5 100644
> --- a/arch/s390/appldata/appldata_base.c
> +++ b/arch/s390/appldata/appldata_base.c
> @@ -52,7 +52,7 @@ static int appldata_interval_handler(const struct ctl_table *ctl, int write,
>  				     void *buffer, size_t *lenp, loff_t *ppos);
>  
>  static struct ctl_table_header *appldata_sysctl_header;
> -static struct ctl_table appldata_table[] = {
> +static const struct ctl_table appldata_table[] = {
>  	{
>  		.procname	= "timer",
>  		.mode		= S_IRUGO | S_IWUSR,
> diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
> index de19fd8a6a95..2c245c2bce4f 100644
> --- a/arch/s390/kernel/debug.c
> +++ b/arch/s390/kernel/debug.c
> @@ -972,7 +972,7 @@ static int s390dbf_procactive(const struct ctl_table *table, int write,
>  		return 0;
>  }
>  
> -static struct ctl_table s390dbf_table[] = {
> +static const struct ctl_table s390dbf_table[] = {
>  	{
>  		.procname	= "debug_stoppable",
>  		.data		= &debug_stoppable,
> diff --git a/arch/s390/kernel/hiperdispatch.c b/arch/s390/kernel/hiperdispatch.c
> index 2a99a216ab62..7857a7e8e56c 100644
> --- a/arch/s390/kernel/hiperdispatch.c
> +++ b/arch/s390/kernel/hiperdispatch.c
> @@ -292,7 +292,7 @@ static int hiperdispatch_ctl_handler(const struct ctl_table *ctl, int write,
>  	return 0;
>  }
>  
> -static struct ctl_table hiperdispatch_ctl_table[] = {
> +static const struct ctl_table hiperdispatch_ctl_table[] = {
>  	{
>  		.procname	= "hiperdispatch",
>  		.mode		= 0644,
> diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
> index 4f9c301a705b..5067293ef69d 100644
> --- a/arch/s390/kernel/topology.c
> +++ b/arch/s390/kernel/topology.c
> @@ -662,7 +662,7 @@ static int polarization_ctl_handler(const struct ctl_table *ctl, int write,
>  	return set_polarization(polarization);
>  }
>  
> -static struct ctl_table topology_ctl_table[] = {
> +static const struct ctl_table topology_ctl_table[] = {
>  	{
>  		.procname	= "topology",
>  		.mode		= 0644,
> diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
> index d01724a715d0..939e3bec2db7 100644
> --- a/arch/s390/mm/cmm.c
> +++ b/arch/s390/mm/cmm.c
> @@ -332,7 +332,7 @@ static int cmm_timeout_handler(const struct ctl_table *ctl, int write,
>  	return 0;
>  }
>  
> -static struct ctl_table cmm_table[] = {
> +static const struct ctl_table cmm_table[] = {
>  	{
>  		.procname	= "cmm_pages",
>  		.mode		= 0644,
> diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
> index 58696a0c4e4a..18d3176e44fb 100644
> --- a/arch/s390/mm/pgalloc.c
> +++ b/arch/s390/mm/pgalloc.c
> @@ -21,7 +21,7 @@
>  int page_table_allocate_pgste = 0;
>  EXPORT_SYMBOL(page_table_allocate_pgste);
>  
> -static struct ctl_table page_table_sysctl[] = {
> +static const struct ctl_table page_table_sysctl[] = {
>  	{
>  		.procname	= "allocate_pgste",
>  		.data		= &page_table_allocate_pgste,
> diff --git a/arch/x86/entry/vdso/vdso32-setup.c b/arch/x86/entry/vdso/vdso32-setup.c
> index 76e4e74f35b5..f6d2d8aba643 100644
> --- a/arch/x86/entry/vdso/vdso32-setup.c
> +++ b/arch/x86/entry/vdso/vdso32-setup.c
> @@ -57,7 +57,7 @@ __setup_param("vdso=", vdso_setup, vdso32_setup, 0);
>  /* Register vsyscall32 into the ABI table */
>  #include <linux/sysctl.h>
>  
> -static struct ctl_table abi_table2[] = {
> +static const struct ctl_table abi_table2[] = {
>  	{
>  		.procname	= "vsyscall32",
>  		.data		= &vdso32_enabled,
> diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
> index 704e9241b964..6cba85c79d42 100644
> --- a/arch/x86/kernel/cpu/bus_lock.c
> +++ b/arch/x86/kernel/cpu/bus_lock.c
> @@ -49,7 +49,7 @@ static unsigned int sysctl_sld_mitigate = 1;
>  static DEFINE_SEMAPHORE(buslock_sem, 1);
>  
>  #ifdef CONFIG_PROC_SYSCTL
> -static struct ctl_table sld_sysctls[] = {
> +static const struct ctl_table sld_sysctls[] = {
>  	{
>  		.procname       = "split_lock_mitigate",
>  		.data           = &sysctl_sld_mitigate,
> diff --git a/arch/x86/kernel/itmt.c b/arch/x86/kernel/itmt.c
> index 51b805c727fc..083d8c4deb2b 100644
> --- a/arch/x86/kernel/itmt.c
> +++ b/arch/x86/kernel/itmt.c
> @@ -64,7 +64,7 @@ static int sched_itmt_update_handler(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> -static struct ctl_table itmt_kern_table[] = {
> +static const struct ctl_table itmt_kern_table[] = {
>  	{
>  		.procname	= "sched_itmt_enabled",
>  		.data		= &sysctl_sched_itmt_enabled,
> diff --git a/crypto/fips.c b/crypto/fips.c
> index 8a784018ebfc..ec6574596e59 100644
> --- a/crypto/fips.c
> +++ b/crypto/fips.c
> @@ -41,7 +41,7 @@ __setup("fips=", fips_enable);
>  static char fips_name[] = FIPS_MODULE_NAME;
>  static char fips_version[] = FIPS_MODULE_VERSION;
>  
> -static struct ctl_table crypto_sysctl_table[] = {
> +static const struct ctl_table crypto_sysctl_table[] = {
>  	{
>  		.procname	= "fips_enabled",
>  		.data		= &fips_enabled,
> diff --git a/drivers/base/firmware_loader/fallback_table.c b/drivers/base/firmware_loader/fallback_table.c
> index ddb70e29eb42..c8afc501a8a4 100644
> --- a/drivers/base/firmware_loader/fallback_table.c
> +++ b/drivers/base/firmware_loader/fallback_table.c
> @@ -25,7 +25,7 @@ struct firmware_fallback_config fw_fallback_config = {
>  EXPORT_SYMBOL_NS_GPL(fw_fallback_config, "FIRMWARE_LOADER_PRIVATE");
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table firmware_config_table[] = {
> +static const struct ctl_table firmware_config_table[] = {
>  	{
>  		.procname	= "force_sysfs_fallback",
>  		.data		= &fw_fallback_config.force_sysfs_fallback,
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 51745ed1bbab..b163e043c687 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -3612,7 +3612,7 @@ static int cdrom_sysctl_handler(const struct ctl_table *ctl, int write,
>  }
>  
>  /* Place files in /proc/sys/dev/cdrom */
> -static struct ctl_table cdrom_table[] = {
> +static const struct ctl_table cdrom_table[] = {
>  	{
>  		.procname	= "info",
>  		.data		= &cdrom_sysctl_settings.info, 
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 48fe96ab4649..e110857824fc 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -724,7 +724,7 @@ static int hpet_is_known(struct hpet_data *hdp)
>  	return 0;
>  }
>  
> -static struct ctl_table hpet_table[] = {
> +static const struct ctl_table hpet_table[] = {
>  	{
>  	 .procname = "max-user-freq",
>  	 .data = &hpet_max_freq,
> diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
> index 941d2dcc8c9d..de84f59468a9 100644
> --- a/drivers/char/ipmi/ipmi_poweroff.c
> +++ b/drivers/char/ipmi/ipmi_poweroff.c
> @@ -650,7 +650,7 @@ static struct ipmi_smi_watcher smi_watcher = {
>  #ifdef CONFIG_PROC_FS
>  #include <linux/sysctl.h>
>  
> -static struct ctl_table ipmi_table[] = {
> +static const struct ctl_table ipmi_table[] = {
>  	{ .procname	= "poweroff_powercycle",
>  	  .data		= &poweroff_powercycle,
>  	  .maxlen	= sizeof(poweroff_powercycle),
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 23ee76bbb4aa..2581186fa61b 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1665,7 +1665,7 @@ static int proc_do_rointvec(const struct ctl_table *table, int write, void *buf,
>  	return write ? 0 : proc_dointvec(table, 0, buf, lenp, ppos);
>  }
>  
> -static struct ctl_table random_table[] = {
> +static const struct ctl_table random_table[] = {
>  	{
>  		.procname	= "poolsize",
>  		.data		= &sysctl_poolsize,
> diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
> index 2406cda75b7b..5384d1bb4923 100644
> --- a/drivers/gpu/drm/i915/i915_perf.c
> +++ b/drivers/gpu/drm/i915/i915_perf.c
> @@ -4802,7 +4802,7 @@ int i915_perf_remove_config_ioctl(struct drm_device *dev, void *data,
>  	return ret;
>  }
>  
> -static struct ctl_table oa_table[] = {
> +static const struct ctl_table oa_table[] = {
>  	{
>  	 .procname = "perf_stream_paranoid",
>  	 .data = &i915_perf_stream_paranoid,
> diff --git a/drivers/gpu/drm/xe/xe_observation.c b/drivers/gpu/drm/xe/xe_observation.c
> index 8ec1b84cbb9e..57cf01efc07f 100644
> --- a/drivers/gpu/drm/xe/xe_observation.c
> +++ b/drivers/gpu/drm/xe/xe_observation.c
> @@ -56,7 +56,7 @@ int xe_observation_ioctl(struct drm_device *dev, void *data, struct drm_file *fi
>  	}
>  }
>  
> -static struct ctl_table observation_ctl_table[] = {
> +static const struct ctl_table observation_ctl_table[] = {
>  	{
>  	 .procname = "observation_paranoid",
>  	 .data = &xe_observation_paranoid,
> diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
> index 7a35c82976e0..9453f0c26f2a 100644
> --- a/drivers/hv/hv_common.c
> +++ b/drivers/hv/hv_common.c
> @@ -141,7 +141,7 @@ static int sysctl_record_panic_msg = 1;
>   * sysctl option to allow the user to control whether kmsg data should be
>   * reported to Hyper-V on panic.
>   */
> -static struct ctl_table hv_ctl_table[] = {
> +static const struct ctl_table hv_ctl_table[] = {
>  	{
>  		.procname	= "hyperv_record_panic_msg",
>  		.data		= &sysctl_record_panic_msg,
> diff --git a/drivers/macintosh/mac_hid.c b/drivers/macintosh/mac_hid.c
> index b461b1bed25b..369d72f59b3c 100644
> --- a/drivers/macintosh/mac_hid.c
> +++ b/drivers/macintosh/mac_hid.c
> @@ -215,7 +215,7 @@ static int mac_hid_toggle_emumouse(const struct ctl_table *table, int write,
>  }
>  
>  /* file(s) in /proc/sys/dev/mac_hid */
> -static struct ctl_table mac_hid_files[] = {
> +static const struct ctl_table mac_hid_files[] = {
>  	{
>  		.procname	= "mouse_button_emulation",
>  		.data		= &mouse_emulate_buttons,
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aebe12b0ee27..0e06f9027d81 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -294,7 +294,7 @@ void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
>  
>  static struct ctl_table_header *raid_table_header;
>  
> -static struct ctl_table raid_table[] = {
> +static const struct ctl_table raid_table[] = {
>  	{
>  		.procname	= "speed_limit_min",
>  		.data		= &sysctl_speed_limit_min,
> diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
> index 61b66e318488..7a3c34306de9 100644
> --- a/drivers/misc/sgi-xp/xpc_main.c
> +++ b/drivers/misc/sgi-xp/xpc_main.c
> @@ -93,7 +93,7 @@ int xpc_disengage_timelimit = XPC_DISENGAGE_DEFAULT_TIMELIMIT;
>  static int xpc_disengage_min_timelimit;	/* = 0 */
>  static int xpc_disengage_max_timelimit = 120;
>  
> -static struct ctl_table xpc_sys_xpc_hb[] = {
> +static const struct ctl_table xpc_sys_xpc_hb[] = {
>  	{
>  	 .procname = "hb_interval",
>  	 .data = &xpc_hb_interval,
> @@ -111,7 +111,7 @@ static struct ctl_table xpc_sys_xpc_hb[] = {
>  	 .extra1 = &xpc_hb_check_min_interval,
>  	 .extra2 = &xpc_hb_check_max_interval},
>  };
> -static struct ctl_table xpc_sys_xpc[] = {
> +static const struct ctl_table xpc_sys_xpc[] = {
>  	{
>  	 .procname = "disengage_timelimit",
>  	 .data = &xpc_disengage_timelimit,
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index b5cc11abc962..0e360feb3432 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -1279,7 +1279,7 @@ static int armv8pmu_proc_user_access_handler(const struct ctl_table *table, int
>  	return 0;
>  }
>  
> -static struct ctl_table armv8_pmu_sysctl_table[] = {
> +static const struct ctl_table armv8_pmu_sysctl_table[] = {
>  	{
>  		.procname       = "perf_user_access",
>  		.data		= &sysctl_perf_user_access,
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 1aa303f76cc7..ea96c0a88f73 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -1315,7 +1315,7 @@ static int riscv_pmu_proc_user_access_handler(const struct ctl_table *table,
>  	return 0;
>  }
>  
> -static struct ctl_table sbi_pmu_sysctl_table[] = {
> +static const struct ctl_table sbi_pmu_sysctl_table[] = {
>  	{
>  		.procname       = "perf_user_access",
>  		.data		= &sysctl_perf_user_access,
> diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
> index 093774d77534..be4aef0f4f99 100644
> --- a/drivers/scsi/scsi_sysctl.c
> +++ b/drivers/scsi/scsi_sysctl.c
> @@ -12,7 +12,7 @@
>  #include "scsi_priv.h"
>  
>  
> -static struct ctl_table scsi_table[] = {
> +static const struct ctl_table scsi_table[] = {
>  	{ .procname	= "logging_level",
>  	  .data		= &scsi_logging_level,
>  	  .maxlen	= sizeof(scsi_logging_level),
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 94127868bedf..effb7e768165 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1639,7 +1639,7 @@ MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
>  #ifdef CONFIG_SYSCTL
>  #include <linux/sysctl.h>
>  
> -static struct ctl_table sg_sysctls[] = {
> +static const struct ctl_table sg_sysctls[] = {
>  	{
>  		.procname	= "sg-big-buff",
>  		.data		= &sg_big_buff,
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index dcb1769c3625..0e84677712b4 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -3618,7 +3618,7 @@ void console_sysfs_notify(void)
>  		sysfs_notify(&consdev->kobj, NULL, "active");
>  }
>  
> -static struct ctl_table tty_table[] = {
> +static const struct ctl_table tty_table[] = {
>  	{
>  		.procname	= "legacy_tiocsti",
>  		.data		= &tty_legacy_tiocsti,
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index 528395133b4f..163f7f1d70f1 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -84,7 +84,7 @@ module_param(balloon_boot_timeout, uint, 0444);
>  #ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
>  static int xen_hotplug_unpopulated;
>  
> -static struct ctl_table balloon_table[] = {
> +static const struct ctl_table balloon_table[] = {
>  	{
>  		.procname	= "hotplug_unpopulated",
>  		.data		= &xen_hotplug_unpopulated,
> diff --git a/fs/aio.c b/fs/aio.c
> index 50671640b588..7b976b564cfc 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -224,7 +224,7 @@ static unsigned long aio_nr;		/* current system wide number of aio requests */
>  static unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio requests */
>  /*----end sysctl variables---*/
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table aio_sysctls[] = {
> +static const struct ctl_table aio_sysctls[] = {
>  	{
>  		.procname	= "aio-nr",
>  		.data		= &aio_nr,
> diff --git a/fs/cachefiles/error_inject.c b/fs/cachefiles/error_inject.c
> index 1715d5ca2b2d..e341ade47dd8 100644
> --- a/fs/cachefiles/error_inject.c
> +++ b/fs/cachefiles/error_inject.c
> @@ -11,7 +11,7 @@
>  unsigned int cachefiles_error_injection_state;
>  
>  static struct ctl_table_header *cachefiles_sysctl;
> -static struct ctl_table cachefiles_sysctls[] = {
> +static const struct ctl_table cachefiles_sysctls[] = {
>  	{
>  		.procname	= "error_injection",
>  		.data		= &cachefiles_error_injection_state,
> diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
> index 9f2d5743e2c8..0df46f09b6cc 100644
> --- a/fs/coda/sysctl.c
> +++ b/fs/coda/sysctl.c
> @@ -14,7 +14,7 @@
>  
>  static struct ctl_table_header *fs_table_header;
>  
> -static struct ctl_table coda_table[] = {
> +static const struct ctl_table coda_table[] = {
>  	{
>  		.procname	= "timeout",
>  		.data		= &coda_timeout,
> diff --git a/fs/coredump.c b/fs/coredump.c
> index d48edb37bc35..591700e1b2ce 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -995,7 +995,7 @@ static int proc_dostring_coredump(const struct ctl_table *table, int write,
>  static const unsigned int core_file_note_size_min = CORE_FILE_NOTE_SIZE_DEFAULT;
>  static const unsigned int core_file_note_size_max = CORE_FILE_NOTE_SIZE_MAX;
>  
> -static struct ctl_table coredump_sysctls[] = {
> +static const struct ctl_table coredump_sysctls[] = {
>  	{
>  		.procname	= "core_uses_pid",
>  		.data		= &core_uses_pid,
> diff --git a/fs/dcache.c b/fs/dcache.c
> index b4d5e9e1e43d..370302d4e488 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -192,7 +192,7 @@ static int proc_nr_dentry(const struct ctl_table *table, int write, void *buffer
>  	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
>  }
>  
> -static struct ctl_table fs_dcache_sysctls[] = {
> +static const struct ctl_table fs_dcache_sysctls[] = {
>  	{
>  		.procname	= "dentry-state",
>  		.data		= &dentry_stat,
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index b20e565b9c5e..1096ff8562fa 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -45,7 +45,7 @@ static int pty_limit_min;
>  static int pty_limit_max = INT_MAX;
>  static atomic_t pty_count = ATOMIC_INIT(0);
>  
> -static struct ctl_table pty_table[] = {
> +static const struct ctl_table pty_table[] = {
>  	{
>  		.procname	= "max",
>  		.maxlen		= sizeof(int),
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index f9898e60dd8b..7c0980db77b3 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -318,7 +318,7 @@ static void unlist_file(struct epitems_head *head)
>  static long long_zero;
>  static long long_max = LONG_MAX;
>  
> -static struct ctl_table epoll_table[] = {
> +static const struct ctl_table epoll_table[] = {
>  	{
>  		.procname	= "max_user_watches",
>  		.data		= &max_user_watches,
> diff --git a/fs/exec.c b/fs/exec.c
> index 98cb7ba9983c..96229a6a4dff 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -2142,7 +2142,7 @@ static int proc_dointvec_minmax_coredump(const struct ctl_table *table, int writ
>  	return error;
>  }
>  
> -static struct ctl_table fs_exec_sysctls[] = {
> +static const struct ctl_table fs_exec_sysctls[] = {
>  	{
>  		.procname	= "suid_dumpable",
>  		.data		= &suid_dumpable,
> diff --git a/fs/file_table.c b/fs/file_table.c
> index 976736be47cb..70ed0b3a5a0e 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -106,7 +106,7 @@ static int proc_nr_files(const struct ctl_table *table, int write, void *buffer,
>  	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
>  }
>  
> -static struct ctl_table fs_stat_sysctls[] = {
> +static const struct ctl_table fs_stat_sysctls[] = {
>  	{
>  		.procname	= "file-nr",
>  		.data		= &files_stat,
> diff --git a/fs/fuse/sysctl.c b/fs/fuse/sysctl.c
> index b272bb333005..63fb1e5bee30 100644
> --- a/fs/fuse/sysctl.c
> +++ b/fs/fuse/sysctl.c
> @@ -13,7 +13,7 @@ static struct ctl_table_header *fuse_table_header;
>  /* Bound by fuse_init_out max_pages, which is a u16 */
>  static unsigned int sysctl_fuse_max_pages_limit = 65535;
>  
> -static struct ctl_table fuse_sysctl_table[] = {
> +static const struct ctl_table fuse_sysctl_table[] = {
>  	{
>  		.procname	= "max_pages_limit",
>  		.data		= &fuse_max_pages_limit,
> diff --git a/fs/inode.c b/fs/inode.c
> index 6b4c77268fc0..5587aabdaa5e 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -184,7 +184,7 @@ static int proc_nr_inodes(const struct ctl_table *table, int write, void *buffer
>  	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
>  }
>  
> -static struct ctl_table inodes_sysctls[] = {
> +static const struct ctl_table inodes_sysctls[] = {
>  	{
>  		.procname	= "inode-nr",
>  		.data		= &inodes_stat,
> diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
> index 4ec22c2f2ea3..d6cac1c89c2a 100644
> --- a/fs/lockd/svc.c
> +++ b/fs/lockd/svc.c
> @@ -419,7 +419,7 @@ EXPORT_SYMBOL_GPL(lockd_down);
>   * Sysctl parameters (same as module parameters, different interface).
>   */
>  
> -static struct ctl_table nlm_sysctls[] = {
> +static const struct ctl_table nlm_sysctls[] = {
>  	{
>  		.procname	= "nlm_grace_period",
>  		.data		= &nlm_grace_period,
> diff --git a/fs/locks.c b/fs/locks.c
> index 25afc8d9c9d1..1619cddfa7a4 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -97,7 +97,7 @@ static int leases_enable = 1;
>  static int lease_break_time = 45;
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table locks_sysctls[] = {
> +static const struct ctl_table locks_sysctls[] = {
>  	{
>  		.procname	= "leases-enable",
>  		.data		= &leases_enable,
> diff --git a/fs/namei.c b/fs/namei.c
> index 9d30c7aa9aa6..6a18b2ea21b7 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1099,7 +1099,7 @@ static int sysctl_protected_fifos __read_mostly;
>  static int sysctl_protected_regular __read_mostly;
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table namei_sysctls[] = {
> +static const struct ctl_table namei_sysctls[] = {
>  	{
>  		.procname	= "protected_symlinks",
>  		.data		= &sysctl_protected_symlinks,
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 23e81c2a1e3f..3819c322244e 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -5927,7 +5927,7 @@ const struct proc_ns_operations mntns_operations = {
>  };
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table fs_namespace_sysctls[] = {
> +static const struct ctl_table fs_namespace_sysctls[] = {
>  	{
>  		.procname	= "mount-max",
>  		.data		= &sysctl_mount_max,
> diff --git a/fs/nfs/nfs4sysctl.c b/fs/nfs/nfs4sysctl.c
> index 886a7c4c60b3..d1a92d8f8ba4 100644
> --- a/fs/nfs/nfs4sysctl.c
> +++ b/fs/nfs/nfs4sysctl.c
> @@ -17,7 +17,7 @@ static const int nfs_set_port_min;
>  static const int nfs_set_port_max = 65535;
>  static struct ctl_table_header *nfs4_callback_sysctl_table;
>  
> -static struct ctl_table nfs4_cb_sysctls[] = {
> +static const struct ctl_table nfs4_cb_sysctls[] = {
>  	{
>  		.procname = "nfs_callback_tcpport",
>  		.data = &nfs_callback_set_tcpport,
> diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
> index e645be1a3381..f579df0e8d67 100644
> --- a/fs/nfs/sysctl.c
> +++ b/fs/nfs/sysctl.c
> @@ -14,7 +14,7 @@
>  
>  static struct ctl_table_header *nfs_callback_sysctl_table;
>  
> -static struct ctl_table nfs_cb_sysctls[] = {
> +static const struct ctl_table nfs_cb_sysctls[] = {
>  	{
>  		.procname	= "nfs_mountpoint_timeout",
>  		.data		= &nfs_mountpoint_expiry_timeout,

For the nfs bits:
Acked-by: Anna Schumaker <anna.schumaker@oracle.com>

> diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
> index 6004dfdfdf0f..c4cdaf5fa7ed 100644
> --- a/fs/notify/dnotify/dnotify.c
> +++ b/fs/notify/dnotify/dnotify.c
> @@ -20,7 +20,7 @@
>  
>  static int dir_notify_enable __read_mostly = 1;
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table dnotify_sysctls[] = {
> +static const struct ctl_table dnotify_sysctls[] = {
>  	{
>  		.procname	= "dir-notify-enable",
>  		.data		= &dir_notify_enable,
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 2d85c71717d6..004cfdae1316 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -58,7 +58,7 @@ static int fanotify_max_queued_events __read_mostly;
>  static long ft_zero = 0;
>  static long ft_int_max = INT_MAX;
>  
> -static struct ctl_table fanotify_table[] = {
> +static const struct ctl_table fanotify_table[] = {
>  	{
>  		.procname	= "max_user_groups",
>  		.data	= &init_user_ns.ucount_max[UCOUNT_FANOTIFY_GROUPS],
> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
> index e0c48956608a..b372fb2c56bd 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -58,7 +58,7 @@ struct kmem_cache *inotify_inode_mark_cachep __ro_after_init;
>  static long it_zero = 0;
>  static long it_int_max = INT_MAX;
>  
> -static struct ctl_table inotify_table[] = {
> +static const struct ctl_table inotify_table[] = {
>  	{
>  		.procname	= "max_user_instances",
>  		.data		= &init_user_ns.ucount_max[UCOUNT_INOTIFY_INSTANCES],
> diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
> index 20aa37b67cfb..ddd761cf44c8 100644
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -650,7 +650,7 @@ static int ocfs2_sysfs_init(void)
>   * and easier to preserve the name.
>   */
>  
> -static struct ctl_table ocfs2_nm_table[] = {
> +static const struct ctl_table ocfs2_nm_table[] = {
>  	{
>  		.procname	= "hb_ctl_path",
>  		.data		= ocfs2_hb_ctl_path,
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 12b22c2723b7..638fb318e7be 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -1477,7 +1477,7 @@ static int proc_dopipe_max_size(const struct ctl_table *table, int write,
>  				 do_proc_dopipe_max_size_conv, NULL);
>  }
>  
> -static struct ctl_table fs_pipe_sysctls[] = {
> +static const struct ctl_table fs_pipe_sysctls[] = {
>  	{
>  		.procname	= "pipe-max-size",
>  		.data		= &pipe_max_size,
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index f9578918cfb2..825c5c2e0962 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2926,7 +2926,7 @@ static int do_proc_dqstats(const struct ctl_table *table, int write,
>  	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
>  }
>  
> -static struct ctl_table fs_dqstats_table[] = {
> +static const struct ctl_table fs_dqstats_table[] = {
>  	{
>  		.procname	= "lookups",
>  		.data		= &dqstats.stat[DQST_LOOKUPS],
> diff --git a/fs/sysctls.c b/fs/sysctls.c
> index 8dbde9a802fa..ad429dffeb4b 100644
> --- a/fs/sysctls.c
> +++ b/fs/sysctls.c
> @@ -7,7 +7,7 @@
>  #include <linux/init.h>
>  #include <linux/sysctl.h>
>  
> -static struct ctl_table fs_shared_sysctls[] = {
> +static const struct ctl_table fs_shared_sysctls[] = {
>  	{
>  		.procname	= "overflowuid",
>  		.data		= &fs_overflowuid,
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 7c0bd0b55f88..97c4d71115d8 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -36,7 +36,7 @@
>  static int sysctl_unprivileged_userfaultfd __read_mostly;
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table vm_userfaultfd_table[] = {
> +static const struct ctl_table vm_userfaultfd_table[] = {
>  	{
>  		.procname	= "unprivileged_userfaultfd",
>  		.data		= &sysctl_unprivileged_userfaultfd,
> diff --git a/fs/verity/init.c b/fs/verity/init.c
> index f440f0e61e3e..6e8d33b50240 100644
> --- a/fs/verity/init.c
> +++ b/fs/verity/init.c
> @@ -10,7 +10,7 @@
>  #include <linux/ratelimit.h>
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table fsverity_sysctl_table[] = {
> +static const struct ctl_table fsverity_sysctl_table[] = {
>  #ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
>  	{
>  		.procname       = "require_signatures",
> diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
> index c84df23b494d..751dc74a3067 100644
> --- a/fs/xfs/xfs_sysctl.c
> +++ b/fs/xfs/xfs_sysctl.c
> @@ -66,7 +66,7 @@ xfs_deprecated_dointvec_minmax(
>  	return proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
>  }
>  
> -static struct ctl_table xfs_table[] = {
> +static const struct ctl_table xfs_table[] = {
>  	{
>  		.procname	= "irix_sgid_inherit",
>  		.data		= &xfs_params.sgid_inherit.val,
> diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
> index 22c7f41ff642..903b4d573d3d 100644
> --- a/init/do_mounts_initrd.c
> +++ b/init/do_mounts_initrd.c
> @@ -21,7 +21,7 @@ phys_addr_t phys_initrd_start __initdata;
>  unsigned long phys_initrd_size __initdata;
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table kern_do_mounts_initrd_table[] = {
> +static const struct ctl_table kern_do_mounts_initrd_table[] = {
>  	{
>  		.procname       = "real-root-dev",
>  		.data           = &real_root_dev,
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index d3403c8216db..72ad31225fb3 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -156,7 +156,7 @@ static int __read_mostly sysctl_io_uring_disabled;
>  static int __read_mostly sysctl_io_uring_group = -1;
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table kernel_io_uring_disabled_table[] = {
> +static const struct ctl_table kernel_io_uring_disabled_table[] = {
>  	{
>  		.procname	= "io_uring_disabled",
>  		.data		= &sysctl_io_uring_disabled,
> diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
> index 54318e0b4557..15b17e86e198 100644
> --- a/ipc/ipc_sysctl.c
> +++ b/ipc/ipc_sysctl.c
> @@ -73,7 +73,7 @@ int ipc_mni = IPCMNI;
>  int ipc_mni_shift = IPCMNI_SHIFT;
>  int ipc_min_cycle = RADIX_TREE_MAP_SIZE;
>  
> -static struct ctl_table ipc_sysctls[] = {
> +static const struct ctl_table ipc_sysctls[] = {
>  	{
>  		.procname	= "shmmax",
>  		.data		= &init_ipc_ns.shm_ctlmax,
> diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
> index b70dc2ff22d8..0dd12e1c9f53 100644
> --- a/ipc/mq_sysctl.c
> +++ b/ipc/mq_sysctl.c
> @@ -20,7 +20,7 @@ static int msg_max_limit_max = HARD_MSGMAX;
>  static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
>  static int msg_maxsize_limit_max = HARD_MSGSIZEMAX;
>  
> -static struct ctl_table mq_sysctls[] = {
> +static const struct ctl_table mq_sysctls[] = {
>  	{
>  		.procname	= "queues_max",
>  		.data		= &init_ipc_ns.mq_queues_max,
> diff --git a/kernel/acct.c b/kernel/acct.c
> index 179848ad33e9..31222e8cd534 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -76,7 +76,7 @@ static int acct_parm[3] = {4, 2, 30};
>  #define ACCT_TIMEOUT	(acct_parm[2])	/* foo second timeout between checks */
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table kern_acct_table[] = {
> +static const struct ctl_table kern_acct_table[] = {
>  	{
>  		.procname       = "acct",
>  		.data           = &acct_parm,
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 5684e8ce132d..fbcf07f98d8b 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -6124,7 +6124,7 @@ static int bpf_unpriv_handler(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> -static struct ctl_table bpf_syscall_table[] = {
> +static const struct ctl_table bpf_syscall_table[] = {
>  	{
>  		.procname	= "unprivileged_bpf_disabled",
>  		.data		= &sysctl_unprivileged_bpf_disabled,
> diff --git a/kernel/delayacct.c b/kernel/delayacct.c
> index dead51de8eb5..75659ac036cd 100644
> --- a/kernel/delayacct.c
> +++ b/kernel/delayacct.c
> @@ -64,7 +64,7 @@ static int sysctl_delayacct(const struct ctl_table *table, int write, void *buff
>  	return err;
>  }
>  
> -static struct ctl_table kern_delayacct_table[] = {
> +static const struct ctl_table kern_delayacct_table[] = {
>  	{
>  		.procname       = "task_delayacct",
>  		.data           = NULL,
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 1dcddfe537ee..3485e5fc499e 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -85,7 +85,7 @@
>  static unsigned int oops_limit = 10000;
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table kern_exit_table[] = {
> +static const struct ctl_table kern_exit_table[] = {
>  	{
>  		.procname       = "oops_limit",
>  		.data           = &oops_limit,
> diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> index c18717189f32..62a5d8927ce9 100644
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -272,7 +272,7 @@ static int proc_dohung_task_timeout_secs(const struct ctl_table *table, int writ
>   * and hung_task_check_interval_secs
>   */
>  static const unsigned long hung_task_timeout_max = (LONG_MAX / HZ);
> -static struct ctl_table hung_task_sysctls[] = {
> +static const struct ctl_table hung_task_sysctls[] = {
>  #ifdef CONFIG_SMP
>  	{
>  		.procname	= "hung_task_all_cpu_backtrace",
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index c0caa14880c3..71b0809e06d6 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -925,7 +925,7 @@ static int kexec_limit_handler(const struct ctl_table *table, int write,
>  	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
>  }
>  
> -static struct ctl_table kexec_core_sysctls[] = {
> +static const struct ctl_table kexec_core_sysctls[] = {
>  	{
>  		.procname	= "kexec_load_disabled",
>  		.data		= &kexec_load_disabled,
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index b027a4030976..9a15fb343be8 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -954,7 +954,7 @@ static int proc_kprobes_optimization_handler(const struct ctl_table *table,
>  	return ret;
>  }
>  
> -static struct ctl_table kprobe_sysctls[] = {
> +static const struct ctl_table kprobe_sysctls[] = {
>  	{
>  		.procname	= "kprobes-optimization",
>  		.data		= &sysctl_kprobes_optimization,
> diff --git a/kernel/latencytop.c b/kernel/latencytop.c
> index 7a75eab9c179..39a5fcdff9f9 100644
> --- a/kernel/latencytop.c
> +++ b/kernel/latencytop.c
> @@ -77,7 +77,7 @@ static int sysctl_latencytop(const struct ctl_table *table, int write, void *buf
>  	return err;
>  }
>  
> -static struct ctl_table latencytop_sysctl[] = {
> +static const struct ctl_table latencytop_sysctl[] = {
>  	{
>  		.procname   = "latencytop",
>  		.data       = &latencytop_enabled,
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index 2d8ec0351ef9..926b796ba71a 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -79,7 +79,7 @@ module_param(lock_stat, int, 0644);
>  #endif
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table kern_lockdep_table[] = {
> +static const struct ctl_table kern_lockdep_table[] = {
>  #ifdef CONFIG_PROVE_LOCKING
>  	{
>  		.procname       = "prove_locking",
> diff --git a/kernel/panic.c b/kernel/panic.c
> index fbc59b3b64d0..d8635d5cecb2 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -84,7 +84,7 @@ ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
>  EXPORT_SYMBOL(panic_notifier_list);
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table kern_panic_table[] = {
> +static const struct ctl_table kern_panic_table[] = {
>  #ifdef CONFIG_SMP
>  	{
>  		.procname       = "oops_all_cpu_backtrace",
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index d70ab49d5b4a..0f23285be4f9 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -282,7 +282,7 @@ static int pid_ns_ctl_handler(const struct ctl_table *table, int write,
>  }
>  
>  extern int pid_max;
> -static struct ctl_table pid_ns_ctl_table[] = {
> +static const struct ctl_table pid_ns_ctl_table[] = {
>  	{
>  		.procname = "ns_last_pid",
>  		.maxlen = sizeof(int),
> diff --git a/kernel/pid_sysctl.h b/kernel/pid_sysctl.h
> index 18ecaef6be41..5d8f981de7c5 100644
> --- a/kernel/pid_sysctl.h
> +++ b/kernel/pid_sysctl.h
> @@ -31,7 +31,7 @@ static int pid_mfd_noexec_dointvec_minmax(const struct ctl_table *table,
>  	return err;
>  }
>  
> -static struct ctl_table pid_ns_ctl_table_vm[] = {
> +static const struct ctl_table pid_ns_ctl_table_vm[] = {
>  	{
>  		.procname	= "memfd_noexec",
>  		.data		= &init_pid_ns.memfd_noexec_scope,
> diff --git a/kernel/printk/sysctl.c b/kernel/printk/sysctl.c
> index f5072dc85f7a..da77f3f5c1fe 100644
> --- a/kernel/printk/sysctl.c
> +++ b/kernel/printk/sysctl.c
> @@ -20,7 +20,7 @@ static int proc_dointvec_minmax_sysadmin(const struct ctl_table *table, int writ
>  	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
>  }
>  
> -static struct ctl_table printk_sysctls[] = {
> +static const struct ctl_table printk_sysctls[] = {
>  	{
>  		.procname	= "printk",
>  		.data		= &console_loglevel,
> diff --git a/kernel/reboot.c b/kernel/reboot.c
> index a701000bab34..b5a8569e5d81 100644
> --- a/kernel/reboot.c
> +++ b/kernel/reboot.c
> @@ -1287,7 +1287,7 @@ static struct attribute *reboot_attrs[] = {
>  };
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table kern_reboot_table[] = {
> +static const struct ctl_table kern_reboot_table[] = {
>  	{
>  		.procname       = "poweroff_cmd",
>  		.data           = &poweroff_cmd,
> diff --git a/kernel/sched/autogroup.c b/kernel/sched/autogroup.c
> index db68a964e34e..83d46b9b8ec8 100644
> --- a/kernel/sched/autogroup.c
> +++ b/kernel/sched/autogroup.c
> @@ -9,7 +9,7 @@ static struct autogroup autogroup_default;
>  static atomic_t autogroup_seq_nr;
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table sched_autogroup_sysctls[] = {
> +static const struct ctl_table sched_autogroup_sysctls[] = {
>  	{
>  		.procname       = "sched_autogroup_enabled",
>  		.data           = &sysctl_sched_autogroup_enabled,
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 3e5a6bf587f9..00fea6f32ae5 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4646,7 +4646,7 @@ static int sysctl_schedstats(const struct ctl_table *table, int write, void *buf
>  #endif /* CONFIG_SCHEDSTATS */
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table sched_core_sysctls[] = {
> +static const struct ctl_table sched_core_sysctls[] = {
>  #ifdef CONFIG_SCHEDSTATS
>  	{
>  		.procname       = "sched_schedstats",
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index d94f2ed6d1f4..dab4887d6406 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -26,7 +26,7 @@
>  static unsigned int sysctl_sched_dl_period_max = 1 << 22; /* ~4 seconds */
>  static unsigned int sysctl_sched_dl_period_min = 100;     /* 100 us */
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table sched_dl_sysctls[] = {
> +static const struct ctl_table sched_dl_sysctls[] = {
>  	{
>  		.procname       = "sched_deadline_period_max_us",
>  		.data           = &sysctl_sched_dl_period_max,
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 3e9ca38512de..1692dbb67d7a 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -130,7 +130,7 @@ static unsigned int sysctl_numa_balancing_promote_rate_limit = 65536;
>  #endif
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table sched_fair_sysctls[] = {
> +static const struct ctl_table sched_fair_sysctls[] = {
>  #ifdef CONFIG_CFS_BANDWIDTH
>  	{
>  		.procname       = "sched_cfs_bandwidth_slice_us",
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index bd66a46b06ac..4b8e33c615b1 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -26,7 +26,7 @@ static int sched_rt_handler(const struct ctl_table *table, int write, void *buff
>  		size_t *lenp, loff_t *ppos);
>  static int sched_rr_handler(const struct ctl_table *table, int write, void *buffer,
>  		size_t *lenp, loff_t *ppos);
> -static struct ctl_table sched_rt_sysctls[] = {
> +static const struct ctl_table sched_rt_sysctls[] = {
>  	{
>  		.procname       = "sched_rt_period_us",
>  		.data           = &sysctl_sched_rt_period,
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 9748a4c8d668..20d59b0bc928 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -312,7 +312,7 @@ static int sched_energy_aware_handler(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> -static struct ctl_table sched_energy_aware_sysctls[] = {
> +static const struct ctl_table sched_energy_aware_sysctls[] = {
>  	{
>  		.procname       = "sched_energy_aware",
>  		.data           = &sysctl_sched_energy_aware,
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 385d48293a5f..f59381c4a2ff 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -2450,7 +2450,7 @@ static int seccomp_actions_logged_handler(const struct ctl_table *ro_table, int
>  	return ret;
>  }
>  
> -static struct ctl_table seccomp_sysctl_table[] = {
> +static const struct ctl_table seccomp_sysctl_table[] = {
>  	{
>  		.procname	= "actions_avail",
>  		.data		= (void *) &seccomp_actions_avail,
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 989b1cc9116a..77f32c2d6ccb 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -4931,7 +4931,7 @@ static inline void siginfo_buildtime_checks(void)
>  }
>  
>  #if defined(CONFIG_SYSCTL)
> -static struct ctl_table signal_debug_table[] = {
> +static const struct ctl_table signal_debug_table[] = {
>  #ifdef CONFIG_SYSCTL_EXCEPTION_TRACE
>  	{
>  		.procname	= "exception-trace",
> diff --git a/kernel/stackleak.c b/kernel/stackleak.c
> index 39fd620a7db6..c1bfc14cd36e 100644
> --- a/kernel/stackleak.c
> +++ b/kernel/stackleak.c
> @@ -44,7 +44,7 @@ static int stack_erasing_sysctl(const struct ctl_table *table, int write,
>  					state ? "enabled" : "disabled");
>  	return ret;
>  }
> -static struct ctl_table stackleak_sysctls[] = {
> +static const struct ctl_table stackleak_sysctls[] = {
>  	{
>  		.procname	= "stack_erasing",
>  		.data		= NULL,
> diff --git a/kernel/sysctl-test.c b/kernel/sysctl-test.c
> index 3ac98bb7fb82..eb2842bd0557 100644
> --- a/kernel/sysctl-test.c
> +++ b/kernel/sysctl-test.c
> @@ -374,7 +374,7 @@ static void sysctl_test_register_sysctl_sz_invalid_extra_value(
>  		struct kunit *test)
>  {
>  	unsigned char data = 0;
> -	struct ctl_table table_foo[] = {
> +	const struct ctl_table table_foo[] = {
>  		{
>  			.procname	= "foo",
>  			.data		= &data,
> @@ -386,7 +386,7 @@ static void sysctl_test_register_sysctl_sz_invalid_extra_value(
>  		},
>  	};
>  
> -	struct ctl_table table_bar[] = {
> +	const struct ctl_table table_bar[] = {
>  		{
>  			.procname	= "bar",
>  			.data		= &data,
> @@ -398,7 +398,7 @@ static void sysctl_test_register_sysctl_sz_invalid_extra_value(
>  		},
>  	};
>  
> -	struct ctl_table table_qux[] = {
> +	const struct ctl_table table_qux[] = {
>  		{
>  			.procname	= "qux",
>  			.data		= &data,
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 5c9202cb8f59..3a0132cb0d5d 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1609,7 +1609,7 @@ int proc_do_static_key(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> -static struct ctl_table kern_table[] = {
> +static const struct ctl_table kern_table[] = {
>  	{
>  		.procname	= "panic",
>  		.data		= &panic_timeout,
> @@ -2030,7 +2030,7 @@ static struct ctl_table kern_table[] = {
>  #endif
>  };
>  
> -static struct ctl_table vm_table[] = {
> +static const struct ctl_table vm_table[] = {
>  	{
>  		.procname	= "overcommit_memory",
>  		.data		= &sysctl_overcommit_memory,
> diff --git a/kernel/time/timer.c b/kernel/time/timer.c
> index a5860bf6d16f..79a1f83d2944 100644
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -301,7 +301,7 @@ static int timer_migration_handler(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> -static struct ctl_table timer_sysctl[] = {
> +static const struct ctl_table timer_sysctl[] = {
>  	{
>  		.procname	= "timer_migration",
>  		.data		= &sysctl_timer_migration,
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 2e113f8b13a2..489cbab3d64c 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -8786,7 +8786,7 @@ ftrace_enable_sysctl(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> -static struct ctl_table ftrace_sysctls[] = {
> +static const struct ctl_table ftrace_sysctls[] = {
>  	{
>  		.procname       = "ftrace_enabled",
>  		.data           = &ftrace_enabled,
> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> index 17bcad8f79de..97325fbd6283 100644
> --- a/kernel/trace/trace_events_user.c
> +++ b/kernel/trace/trace_events_user.c
> @@ -2899,7 +2899,7 @@ static int set_max_user_events_sysctl(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> -static struct ctl_table user_event_sysctls[] = {
> +static const struct ctl_table user_event_sysctls[] = {
>  	{
>  		.procname	= "user_events_max",
>  		.data		= &max_user_events,
> diff --git a/kernel/umh.c b/kernel/umh.c
> index be9234270777..b4da45a3a7cf 100644
> --- a/kernel/umh.c
> +++ b/kernel/umh.c
> @@ -544,7 +544,7 @@ static int proc_cap_handler(const struct ctl_table *table, int write,
>  	return 0;
>  }
>  
> -static struct ctl_table usermodehelper_table[] = {
> +static const struct ctl_table usermodehelper_table[] = {
>  	{
>  		.procname	= "bset",
>  		.data		= &usermodehelper_bset,
> diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
> index 7282f61a8650..bfbaaecb1dd4 100644
> --- a/kernel/utsname_sysctl.c
> +++ b/kernel/utsname_sysctl.c
> @@ -75,7 +75,7 @@ static DEFINE_CTL_TABLE_POLL(hostname_poll);
>  static DEFINE_CTL_TABLE_POLL(domainname_poll);
>  
>  // Note: update 'enum uts_proc' to match any changes to this table
> -static struct ctl_table uts_kern_table[] = {
> +static const struct ctl_table uts_kern_table[] = {
>  	{
>  		.procname	= "arch",
>  		.data		= init_uts_ns.name.machine,
> @@ -129,7 +129,7 @@ static struct ctl_table uts_kern_table[] = {
>   */
>  void uts_proc_notify(enum uts_proc proc)
>  {
> -	struct ctl_table *table = &uts_kern_table[proc];
> +	const struct ctl_table *table = &uts_kern_table[proc];
>  
>  	proc_sys_poll_notify(table->poll);
>  }
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 41e0f7e9fa35..613e73ef367c 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -1094,7 +1094,7 @@ static int proc_watchdog_cpumask(const struct ctl_table *table, int write,
>  
>  static const int sixty = 60;
>  
> -static struct ctl_table watchdog_sysctls[] = {
> +static const struct ctl_table watchdog_sysctls[] = {
>  	{
>  		.procname       = "watchdog",
>  		.data		= &watchdog_user_enabled,
> diff --git a/lib/test_sysctl.c b/lib/test_sysctl.c
> index b6696fa1d426..4249e0cc8aaf 100644
> --- a/lib/test_sysctl.c
> +++ b/lib/test_sysctl.c
> @@ -71,7 +71,7 @@ static struct test_sysctl_data test_data = {
>  };
>  
>  /* These are all under /proc/sys/debug/test_sysctl/ */
> -static struct ctl_table test_table[] = {
> +static const struct ctl_table test_table[] = {
>  	{
>  		.procname	= "int_0001",
>  		.data		= &test_data.int_0001,
> @@ -177,7 +177,7 @@ static int test_sysctl_setup_node_tests(void)
>  }
>  
>  /* Used to test that unregister actually removes the directory */
> -static struct ctl_table test_table_unregister[] = {
> +static const struct ctl_table test_table_unregister[] = {
>  	{
>  		.procname	= "unregister_error",
>  		.data		= &test_data.int_0001,
> @@ -220,7 +220,7 @@ static int test_sysctl_run_register_mount_point(void)
>  	return 0;
>  }
>  
> -static struct ctl_table test_table_empty[] = { };
> +static const struct ctl_table test_table_empty[] = { };
>  
>  static int test_sysctl_run_register_empty(void)
>  {
> diff --git a/mm/compaction.c b/mm/compaction.c
> index a2b16b08cbbf..62e8ee230e1c 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -3297,7 +3297,7 @@ static int proc_dointvec_minmax_warn_RT_change(const struct ctl_table *table,
>  	return ret;
>  }
>  
> -static struct ctl_table vm_compaction[] = {
> +static const struct ctl_table vm_compaction[] = {
>  	{
>  		.procname	= "compact_memory",
>  		.data		= &sysctl_compact_memory,
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c498874a7170..3857b9d72c84 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4845,7 +4845,7 @@ static int hugetlb_overcommit_handler(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> -static struct ctl_table hugetlb_table[] = {
> +static const struct ctl_table hugetlb_table[] = {
>  	{
>  		.procname	= "nr_hugepages",
>  		.data		= NULL,
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 57b7f591eee8..7735972add01 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -693,7 +693,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
>  	free_vmemmap_page_list(&vmemmap_pages);
>  }
>  
> -static struct ctl_table hugetlb_vmemmap_sysctls[] = {
> +static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
>  	{
>  		.procname	= "hugetlb_optimize_vmemmap",
>  		.data		= &vmemmap_optimize_enabled,
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a7b8ccd29b6f..995a15eb67e2 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -124,7 +124,7 @@ const struct attribute_group memory_failure_attr_group = {
>  	.attrs = memory_failure_attr,
>  };
>  
> -static struct ctl_table memory_failure_table[] = {
> +static const struct ctl_table memory_failure_table[] = {
>  	{
>  		.procname	= "memory_failure_early_kill",
>  		.data		= &sysctl_memory_failure_early_kill,
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 1c485beb0b93..c8280a39119c 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -699,7 +699,7 @@ static void queue_oom_reaper(struct task_struct *tsk)
>  }
>  
>  #ifdef CONFIG_SYSCTL
> -static struct ctl_table vm_oom_kill_table[] = {
> +static const struct ctl_table vm_oom_kill_table[] = {
>  	{
>  		.procname	= "panic_on_oom",
>  		.data		= &sysctl_panic_on_oom,
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index d213ead95675..fb523107701f 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2313,7 +2313,7 @@ static int page_writeback_cpu_online(unsigned int cpu)
>  /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
>  static const unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
>  
> -static struct ctl_table vm_page_writeback_sysctls[] = {
> +static const struct ctl_table vm_page_writeback_sysctls[] = {
>  	{
>  		.procname   = "dirty_background_ratio",
>  		.data       = &dirty_background_ratio,
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cae7b93864c2..6224a2ab5e86 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6172,7 +6172,7 @@ static int percpu_pagelist_high_fraction_sysctl_handler(const struct ctl_table *
>  	return ret;
>  }
>  
> -static struct ctl_table page_alloc_sysctl_table[] = {
> +static const struct ctl_table page_alloc_sysctl_table[] = {
>  	{
>  		.procname	= "min_free_kbytes",
>  		.data		= &min_free_kbytes,
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index 1edc12862a7d..9b6c2f157f83 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -2038,7 +2038,7 @@ static int apparmor_dointvec(const struct ctl_table *table, int write,
>  	return proc_dointvec(table, write, buffer, lenp, ppos);
>  }
>  
> -static struct ctl_table apparmor_sysctl_table[] = {
> +static const struct ctl_table apparmor_sysctl_table[] = {
>  #ifdef CONFIG_USER_NS
>  	{
>  		.procname       = "unprivileged_userns_apparmor_policy",
> diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
> index 91f000eef3ad..cde08c478f32 100644
> --- a/security/keys/sysctl.c
> +++ b/security/keys/sysctl.c
> @@ -9,7 +9,7 @@
>  #include <linux/sysctl.h>
>  #include "internal.h"
>  
> -static struct ctl_table key_sysctls[] = {
> +static const struct ctl_table key_sysctls[] = {
>  	{
>  		.procname = "maxkeys",
>  		.data = &key_quota_maxkeys,
> diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
> index e1a5e13ea269..54bd5f535ac1 100644
> --- a/security/yama/yama_lsm.c
> +++ b/security/yama/yama_lsm.c
> @@ -454,7 +454,7 @@ static int yama_dointvec_minmax(const struct ctl_table *table, int write,
>  
>  static int max_scope = YAMA_SCOPE_NO_ATTACH;
>  
> -static struct ctl_table yama_sysctl_table[] = {
> +static const struct ctl_table yama_sysctl_table[] = {
>  	{
>  		.procname       = "ptrace_scope",
>  		.data           = &ptrace_scope,
> 
> ---
> base-commit: 9d89551994a430b50c4fffcb1e617a057fa76e20
> change-id: 20250109-jag-ctl_table_const-38f6b2ccbba7
> 
> Best regards,


