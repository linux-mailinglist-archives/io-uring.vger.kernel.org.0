Return-Path: <io-uring+bounces-1808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1948BE883
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 18:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A20DB28760
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 16:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23E916ABEA;
	Tue,  7 May 2024 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kmnx3mxZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oKuF2oAS"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB7516132A;
	Tue,  7 May 2024 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715098018; cv=fail; b=O8YSlsHNQTy3Ogg/3KtJ1Or7Txcpyvlznd7F+Ip3x+5AmABv1vsU/Cfueky2bLwa/VTSkoLLeTTftcg2lcYqafPr1O8SEN2VUebIFEaPs14MPrPPTJ3Ngu9nD73SfGOC3c18Uxih2lVKj9L8QNv9HPC6ObCtQojByGsH9zxDdDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715098018; c=relaxed/simple;
	bh=j0kprFYcCbaYHKV490KznbMuc5qvEt9Bt0iTqPf0Ce8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F+GDRheFCsRNfbFR1PbrhMfxo+Zr/+uKPiXU043AE1rsnCr4OUA82EpEq31PX8C+g/5EOjb5NG5D7HuX842UisSBlv5+o0CYkfUL/Hc7awyQB0jO1WvIHoXkm5gaVIPKYL/da00AbI+fItTyYXAJfyoILgMkA4u7qq2E8HPTRyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Kmnx3mxZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oKuF2oAS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447943Vm011039;
	Tue, 7 May 2024 16:06:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2023-11-20;
 bh=zZ3FlYdd0E7GlwA0iC3kXqtZvianq7Rm2lp7oAQY+Tw=;
 b=Kmnx3mxZNxcTgqGu51HxSEo1g9o+7DIceMl7q/vSR4grRptXlSm4/wAv9NvkT1FrEu/i
 tounSYaY6tQ7u88SZVS8Pq4IPadl2GmT3mCXt6vEaleU0lssahsGws1tN6zEalmnPEt7
 1I9PVIcWWr7BnhkOvjKmig6mObA5vNtnXuF0rmPcEZ3RquAwOBWMkRyyJE2x4u1KmkD6
 O2qrKeIzuwrvvC6gXP/6s/hv418ZaHD5sFjn0XiURUBN0aSGbBkTd4p3bPc9Zzei8RrM
 OfBMjcS6ZbZ3wfo+wO7SNmR3kKb43dGsp206wAN+p/fK4F4vDYHkYzEp+bf6urIZODCa rw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwd2dwd0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 16:06:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 447F0XvN039595;
	Tue, 7 May 2024 16:06:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf77rrx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 16:06:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nhufkm069VnGyjGJa0ZOnUk5JNTkEmlZ+8l+sXdCh14XPEh26XtrV1mslpf1wHE2D7vaq7gewumuhbXROz92VFNX+EZqUOBX9rer7kUmFxtEcszegdDKO611piNJuRrWF4VicVXNOb3K6kGsytA18gGy4W1TmLshAc9xf0kncF5kExA9GJ+POMvFlAJDB+0XoE0RNd/piuOr9amzRGKg8/0gquIss5ibXKX3k+kLc3dD+0CUNfgVICwU6KwaHXUFUFHMqKWgWk/wgk+GUeKsQSUntdUpN6wNYlEb52kC0mfMiMyQPkzX7qznLsHGRYWHworJGcb5ZhmyUgyyvbYa5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zZ3FlYdd0E7GlwA0iC3kXqtZvianq7Rm2lp7oAQY+Tw=;
 b=JsyMHsyiz6YWZVD3XXnSGuDxJrtHzmbDRn5NIoAPQuUsVuXrDRaF4q/TSJvqrUWMhvDRBab2zXvEUvYJLtyOJQTtkZkKi5Kub4l1k4VhgpXewmqqMRM/ZrThg3s9NSmTfiEvjfcODpLjsaVTUNefaOevluGLkflerqpgrz04vPohWzRt42eDAKcHlASWZ9q4q+hi8ILVfZJSenY3kY6cT4PnbaZtpPDKFF6D2BygoqEUrH0dRwCpgvmvDu3NfS6HVL80a6Ue/nbJpWGdhNI/j7vhhh6NU+APTS2HYE7ln99FysZbU51AJTUPUp3qTJBFFTL5eTRzQl1Ns2XYrD6sjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZ3FlYdd0E7GlwA0iC3kXqtZvianq7Rm2lp7oAQY+Tw=;
 b=oKuF2oASw8n24nprh4tdu6uuAgSa15GYyNa6S0X9LRDJjx7YlXGjyrRgWKsFNICPRBsPr54M7HQIOz10mUl8u+orm3UtI26Su1LADGamxaKbMAKU1s3vBsypjCl+BPVHiat4q7IqcJQ/7qZJyLawpIH4Esx4SCHpY9IvgWfuP7M=
Received: from DS0PR10MB7933.namprd10.prod.outlook.com (2603:10b6:8:1b8::15)
 by PH0PR10MB7007.namprd10.prod.outlook.com (2603:10b6:510:282::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 16:06:08 +0000
Received: from DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490]) by DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490%7]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 16:06:08 +0000
Date: Tue, 7 May 2024 12:06:05 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "debug@rivosinc.com" <debug@rivosinc.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH] mm: Remove mm argument from mm_get_unmapped_area()
Message-ID: <6luuf6tsdsrydtgzqpdggpsyyw7z4vcsv3q7gcvo5yufnrms5u@7we4w2mkhbcm>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"keescook@chromium.org" <keescook@chromium.org>, "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, 
	"luto@kernel.org" <luto@kernel.org>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "debug@rivosinc.com" <debug@rivosinc.com>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"bp@alien8.de" <bp@alien8.de>, "Williams, Dan J" <dan.j.williams@intel.com>, 
	"broonie@kernel.org" <broonie@kernel.org>
References: <20240506160747.1321726-1-rick.p.edgecombe@intel.com>
 <tj2cc7k2fyeh2qi6hqkftxe2vk46rtjxaue222jkw3zcnxad4d@uark4ccqtx3t>
 <8811ab073c9d1f0c1dfdb04ae193e091839b4682.camel@intel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8811ab073c9d1f0c1dfdb04ae193e091839b4682.camel@intel.com>
User-Agent: NeoMutt/20231103
X-ClientProxiedBy: YT4PR01CA0240.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::14) To DS0PR10MB7933.namprd10.prod.outlook.com
 (2603:10b6:8:1b8::15)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7933:EE_|PH0PR10MB7007:EE_
X-MS-Office365-Filtering-Correlation-Id: 36f30636-045a-497c-1e6c-08dc6eaf9b06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?iso-8859-1?Q?poLDJHo1GBCA9FNNf6fwBELUms6eJWjrxslC7f3c24XHPVO2nuTodsmq5E?=
 =?iso-8859-1?Q?E0v1l4UfuNofV4CfbAjdXSMY9Uiym1lRl3Tl+4dAiKfrWyXQzC7l+B4Ct7?=
 =?iso-8859-1?Q?uM6GpM1/P6L7AYvtX4dRIupPAYxskDImTH11hDK5a0U4PbGDE6PdRsdxZH?=
 =?iso-8859-1?Q?N+XxaxMupg72/q7gSWJnBXF+eobtGNMWKjDD1wTdMMXkYkm+fZ7malwOCt?=
 =?iso-8859-1?Q?Qpgrbwy+mta9WbuUyLU5Eb6+LRNkhOCmignSR0vJdMBIaGK3nLhRWTkXU9?=
 =?iso-8859-1?Q?A5IvU5OpRtgOhoxMJEb+L+DeXwFlkNKzwM53dmlaZAT7AAHS5P9h4qDJro?=
 =?iso-8859-1?Q?GDPb9QKiSK+mDiUXgkv/1qfLKBwou5die+xx1jGG2gx5WrFqNT7N6aqErn?=
 =?iso-8859-1?Q?JXQHSt2AnI/mjLKFgD1nGfen0HhkRl+6I87PjxdY2bUh7Gh93JuclY5APS?=
 =?iso-8859-1?Q?hy/GL+hZLmXB1x6Jmz5nYHh0xrAXYaj6ZYAJX4D5i58wehbfewgg7SlXC6?=
 =?iso-8859-1?Q?W/NLgRoGxzd9WnevTyk5k7QUPdfKAOQHtfkKTvnELEjAuJpTdFbkaHq7tq?=
 =?iso-8859-1?Q?0yh/6hLRtBXhFu8P8XmZDAwUA9kI4horVPTDRIO2Grst7NOZH1Rp6qb5+j?=
 =?iso-8859-1?Q?vMGdQ45dItdT8Q5iZkdmVZO/WGDwdh32TUzLv5cGpsvPGSwEzSIwwQEbnH?=
 =?iso-8859-1?Q?F/7QTeb23GvN9wpCxMnWbc4WNxwSXtbwXHBqydWzxNJGTXRVY8k6pzaMaO?=
 =?iso-8859-1?Q?abHNogj8XneNX8alY3tvWRi6tA7GHg0YQO3am8qDFcTcQQZOAPCfNmVvdU?=
 =?iso-8859-1?Q?MD50uqCoTNqYD95KTCbOCXzZZiO5uXmvyfH6fDSuui4WIebzv299HsXPB2?=
 =?iso-8859-1?Q?/Z0GD5UIEdSzfWDpYxkbGcZ38RfV8zobQWyYa44T0ROIi0NE3mBykiLzoc?=
 =?iso-8859-1?Q?6bQMN/6J9eFqgMY1MEdLiQ9LoMKwKSO4Zi6kShyTEIzy8+p5F4OnwCk4md?=
 =?iso-8859-1?Q?R/S+Iogf2T23gVsZwxrTxo9AzmbuoHCqiP/KAA5UheGQjwbYcJtyBrVTJt?=
 =?iso-8859-1?Q?6WGftLUY/9iSKN4K7yyi8D61yPKLA3fdY65JFqcrOs2zq8OARW4EMrtn4N?=
 =?iso-8859-1?Q?AYsb6Rwj2EZtpCin6Evl9+qSTwplVYV+0r0l0n1sb0domAN9d8CvmpmCus?=
 =?iso-8859-1?Q?odqWAm+lfwezvRA/a9VVq9Ce0oSVSwxtwgb+XUxiw94nQZB/RjeEIg1Rjd?=
 =?iso-8859-1?Q?ZfzP6bberkJGBlJufQ2aveEWUb6bQ7JULtlKV2G/mggAS1ZguThq0kTOF4?=
 =?iso-8859-1?Q?7RZkhDkyGyQuhQ3dmNOHk0eJBg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7933.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?iso-8859-1?Q?PgWQoAPUa8SnVWvxJbrP3PNfc4c7BN3VE5ySJFsL4/Y8dYKnc+pwm5+Ff2?=
 =?iso-8859-1?Q?mvItF7JCwFtvdh9D7CTvufjn3xZZDq0Qi1LB4cGMLOp9Lwuhj8jBcfzjnV?=
 =?iso-8859-1?Q?qlCZ2kDW883cp3e9cTogqS5XD0TJBZtZUh32Euk++o1nOGCrkI13C46fMa?=
 =?iso-8859-1?Q?d9hXOuziKdOLZPTqs7R7RMO3p6gKU+Sliu8by7DQO5nbTlOWyiTuK3OYj4?=
 =?iso-8859-1?Q?1Sne6rB/pbOd+CoCxZmB8lArnUDN/cJ2f2Dq4/A5x9eTB0cvbd3U1WXC0J?=
 =?iso-8859-1?Q?xhfmJKWVZEhuutOvDxbA9b3O9TUodu+C2BLV9evh6K/LtkWrNxD8UVeXut?=
 =?iso-8859-1?Q?do/nCv1ANiIZStRY+x70ZE2aDsIvmw4hrHtTcgJ67DG6RR5VD7+A1U1+oU?=
 =?iso-8859-1?Q?v7IApYuDvUsh3nuuKeUOqMytQDwZSVOClP6Vk5Mm86/B9KDq37cGaz7Ara?=
 =?iso-8859-1?Q?oQwCfEAMIAskLDLkr/kpq34zQP1lv2GuLipEtq1Kj5JoNIVZAgcWWM4al9?=
 =?iso-8859-1?Q?8R6dTzCLax70cW79A/b2XWQ7gzCE6pGOacbk7ZdGOE8GcO9VWzkRDEfdqB?=
 =?iso-8859-1?Q?NWT2zRhjDcrmk3wM+682ZySe9m74qYa4L1aMHxkf/B/0Q1uX18TnVdrYSe?=
 =?iso-8859-1?Q?z2T4Xg9TgmPSO2I6SXIs2BOv4I8uXr21rIkZmQDrr7ALdQrpnrO2lH6aPV?=
 =?iso-8859-1?Q?KwB3HQviSHOLPvVkKmsBVqy3ZeJ7Gup8mc8moQKQw4nNPPnhn8qKWrJ5Zd?=
 =?iso-8859-1?Q?ALYbheJZTqcL25YYAZFEfhtHqhGUFZDNW7kyezE9jOj5JAlQt5Aj5NB7CI?=
 =?iso-8859-1?Q?ud2nO2GlZwsYKFY+PGK9DlGdi2POTWBZOPSlP8f7ikZLY/DW8qJGDIzSgr?=
 =?iso-8859-1?Q?x2hV8OphUW9QrfbugcYbLUaaQPsIN0yCzrbRE+BtxNJOIVvowbCCMPmLHj?=
 =?iso-8859-1?Q?IWMJr0A0jo2UTSyiUOB5aHPDfyKK2+B3DwiM/1RfUm7IYwxPje0KvSUtXs?=
 =?iso-8859-1?Q?wPRHvd/Rkdr5qUpNuNZ7+YhBNXXvm1wCJmvtG1bCNlC3YDQ12vWf8/nnh+?=
 =?iso-8859-1?Q?xxDATCMWTnmr88VqMhSpnTJk727RjxbnTZwmJqdrs9xR78ZWJkBORjAHd7?=
 =?iso-8859-1?Q?Deor6jyKPKheNhp6bWtWghm4TEBmNMBTWEASQksZrbt7hYZ6Bhxf9aPZFD?=
 =?iso-8859-1?Q?fHabtowYDPe4NucNKEIijVz9e3QM8i6m31jVcCZ83p+vb2FjDxvWxXh8s6?=
 =?iso-8859-1?Q?0+SOAVUldYGRGJAXBxIVEhI7QOmCm4Pof8KHFkfyT+jGr2fU1QUNRgCEKD?=
 =?iso-8859-1?Q?xJataU/fZNLS7IucSaz2M9SXzTyjHE2y2KmH5Hu4RZVkFXKxi7YyK8pFeV?=
 =?iso-8859-1?Q?F5lm/4q7ctpgmJm7yiWUwn82/WKDK6ghUPBCIxXouZ8Ss6gsbHr64lsaIG?=
 =?iso-8859-1?Q?x4hzgtP6bzslewfNdxDYkaZgSnSi8jtInw4xvdjl2Zq1fBFCq3dA7v2WOn?=
 =?iso-8859-1?Q?erdHzbu+qrfrjzCWZE31ALRTn1fslD5t8iB9QZwJeWfpwkmujkprIBIUlh?=
 =?iso-8859-1?Q?MUKh0/gvHPxHJCCqZ6CCqZHYROzXjqedznlsd0Low3mYEHkvdrtcQEozAF?=
 =?iso-8859-1?Q?YHPYB0lc4ysMsbU/uPjxrJunuUKOBYAlVfAH/V9ZPOF0nZTryHEOPYwg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ciAE2b1RrYt21IVjIgN6ARnOe73ZNv/Qr9RVN6JTeNXoXfZdhAeat8uwBxS3d9nrF5ndFVlXFfVCz8FolDS962+7c+cAJbVHYtgYZmgDcdABMi42p545KYfLK2L3b/AQUVjrfr3ZT8V7iVpiY7tqhBCD0iZYPn9gVDNwqp5bTnSC/I1z8yEss7OYrssZVgUdb9sk1mmMUbVoxbRbaujjMPmu6Ok9IWxvWoAuIGbJT8IxCkQsk/RaHqA7UlDIU5Zj4HpUMxdxlhH7zif5Gb9GjoJtICfjhM0ms4NnLGxiTRr//5IuRuSfs4hf5f9/sM3PPU9j9htjtL1huPg2mH0QYRQviVgVkyF/DIXXfOJFPfThWm3c3ULzB4NvJ26l/OdlkCPCKS3d7grIakbyYKW+urcx/k3b/2uuTgMhMBM4Hg6Q1gb1uleCe94d93oo9idOslECO2TKNIufXEXqeqtot0wKqgTlgQ4ELOe5wu15M+Eo2mf3mePyGbGRqsYgsTI6sKwpgAbysUz4IsbKadSP6cf7sNqPLDksImx7w1Tz/s6p5usCKM8aGzJUjdvDBodFNcoCOvd3QCm5r3l9CpGJsT7cagEipmYHsYs3nwEX6MM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f30636-045a-497c-1e6c-08dc6eaf9b06
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7933.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 16:06:08.1111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CnXJ7x8cMMoc6GFVKLy/QvqqFxud+x1Af/471R0A3pNB0vjRa7wpLCa3XL5o7ML8/td/qIZ2qYnl69Y4J3PllQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7007
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_09,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070111
X-Proofpoint-GUID: n59kw3vf6GcarDRHJAmCfClyFBwRPs11
X-Proofpoint-ORIG-GUID: n59kw3vf6GcarDRHJAmCfClyFBwRPs11

* Edgecombe, Rick P <rick.p.edgecombe@intel.com> [240507 09:51]:
> On Mon, 2024-05-06 at 12:32 -0400, Liam R. Howlett wrote:
> >=20
> > I like this patch.
>=20
> Thanks for taking a look.
>=20
> >=20
> > I think the context of current->mm is implied. IOW, could we call it
> > get_unmapped_area() instead?=A0 There are other functions today that us=
e
> > current->mm that don't start with current_<whatever>.=A0 I probably sho=
uld
> > have responded to Dan's suggestion with my comment.
>=20
> Yes, get_unmapped_area() is already taken. What else to call it... It is =
kind of
> the process "default" get_unmapped_area(). But with Christoph's proposal =
it
> would basically be arch_get_unmapped_area().

unmapped_area(), but that's also taken..

arch_get_unmapped_area() are all quite close.  If you look into it, many
of the arch versions were taken from the sparc 32 version.  Subsequent
changes were made and they are no longer exactly the same, but I believe
functionally equivalent - rather tricky to test though.

I wanted to unite these to simplify the mm code a while back, but have
not gotten back to it.  One aspect that some archs have is "cache
coloring" which does affect the VMAs.

The other difference is VDSO, which I may be looking into soon.  Someone
once called me a glutton for punishment and there may be some truth in
that...

Cheers,
Liam


