Return-Path: <io-uring+bounces-2109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D05118FCA4F
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 13:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AC2A1F225BB
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 11:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04DD3192B7C;
	Wed,  5 Jun 2024 11:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YG6rWqVX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UdAmZGTK"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06B3192B65;
	Wed,  5 Jun 2024 11:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717586552; cv=fail; b=c4mVlzc9MC96lGKLE9W3jo6AMjTb/AT8ld1/QqUeI+OwVFpaM1Mn8TD89/Ih0Zw+X1/8WhuU21feD7txFNSlKDsIDZEjYgK+Y1MDi1HF0S5x1mjiZ6ss1x0rpjRV0b+JtUcXwM5YV9cQa06GBx4j7A/6FW/o8uHY7RERtyNfyOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717586552; c=relaxed/simple;
	bh=gK/pN8M3LfAh/VkSvkUx1R52SSdNg8XL0WJ6TfJ2sfQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=krusgvbBlKucgSuSydQNHA/9aBUmqsYIiKiISY4JHiO0aCiyUND0YyLpmnykjJ01W5Au1iVDdoa32QXo4R2njyf8qjsVelsBf/BumgYRIw3c5x9KhwXD3xqm/5OK492SP5c5wa54EhlXs6ILvtAMcoiowWEu9bEyt7GwMHrLxSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YG6rWqVX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UdAmZGTK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4551EXth006312;
	Wed, 5 Jun 2024 11:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=corp-2023-11-20;
 bh=PDXf8ncFJdAXfN0ECFMrCqnKLMGm+CjDuOxcMGmtx70=;
 b=YG6rWqVXHipyUP9LHsS614y1J+/iFncqJ10Wf7CHnOxK7osqpSotm+K71VI05iA7nCSz
 W70fot8euELenUkMCtJAfr/eqYB1cEnB42rHm1rjp5o56+zx5aSoj1Rf2qfPFENA5mY+
 EkVI+iQ/rO7VTB29vWubnGTcn505aWDJMG+Ex+9eFULN2K1WEY59ThYXg4O8XIpdYMLj
 mWLDKucT5NdwFCV9qzrcVAXcmPSIdtetxQdRQhHgQsUjI6C3ygbjFJc6maXfp9c2cMjb
 xs9SGnsKX79QWYaCyLcY8uiEwbiBONHYY/4dsNiz4w8XQm2bzP51T1Dbi9IuWtSO0HOO Bw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbrh900w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 11:22:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 455Ak7Ma020722;
	Wed, 5 Jun 2024 11:22:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrj3b4tb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 11:22:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENnpoDuGQnBYx/NS2BhlZaW09eWspNtYPUnkbucXZa1c0e8AdHTu0GXFC0/e9dsjC+SrCpQ2XRzVr4+cdnic+G5cDGd3/kkipUPJtMgvElOPeo/onveajs09owhLGK0TIu3EPub4ZOsb/EMgP0rgV0hcf54CPRGHzh/V0G29xIqV3unhBlW1oQAgA/sj1fKqH6xYhZmOovk+RkfFKCxwpCKukkTmKH9+QyQ7O0s6njN1rNypQlxhSkgsPz68b7eDD6FM+uCurI4ZenTqpVDNy18EKDwGJkSQlA6LUhRacL2T8o9F5vzKm634/cO2tFp4v8y6yev+/Bc/0NHc9b2RiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDXf8ncFJdAXfN0ECFMrCqnKLMGm+CjDuOxcMGmtx70=;
 b=BcNucfDnQFv6LksFd25+RJjJggvz35fYn0sXtAF/90plPOGgfwDGI55l39nMf4kxLLmYYAq4Z/SrDyB+j/pgB6/kG2f0UPSeyC6JDEONksahgpUE5eaMWKI0iGZzAuZZv08O46hNtD7DCn0rayS3GY9f8HUMvQ9sLoGAtEkSsUt7WZL2AKaVqrZNPf52KwVmsLUwe5Ipj0KdLI72o9PhVYvJa3PCv67/34xyd48iA0CF8Y+lEvlnaoIKNnCMKrCqlPNC0dt7iAemXF7QMmNkL31k37FjadQuFHQ3OxeKhzRyGtofnpSAxd5RtwH2nT9dpLidC1eWuF6RRoCvEkDEXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDXf8ncFJdAXfN0ECFMrCqnKLMGm+CjDuOxcMGmtx70=;
 b=UdAmZGTKzvY3p9fG4pXAN/D/RnFIInqSDKiqmr48Rv9zz1lnDka8/y1g3z/r1A+RmP8qgXOsYx0JvIYyUPk3uKknHA6ICVy82y1xMxofaHvbja02PEWZiTE6NapEqZfJYom2jtgtZ1Y8o3Lvm6UFk0AJnVjOjNxH/e5lq0HrbZA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CO1PR10MB4404.namprd10.prod.outlook.com (2603:10b6:303:90::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Wed, 5 Jun
 2024 11:21:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.032; Wed, 5 Jun 2024
 11:21:58 +0000
Message-ID: <09907144-45ca-4a48-8831-2f98518cbca4@oracle.com>
Date: Wed, 5 Jun 2024 12:21:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] block: Add core atomic write support
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
 <20240602140912.970947-5-john.g.garry@oracle.com>
 <749f9615-2fd2-49a3-9c9e-c725cb027ad3@suse.de>
 <a84ad9de-a274-4bdf-837a-03c38a32288a@oracle.com>
 <ee20a47d-3131-41c2-a2fc-39017f535527@suse.de>
 <76850f4f-0bd0-48ae-92f4-e3af38039938@oracle.com>
 <20240605083245.GC20984@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240605083245.GC20984@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0016.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CO1PR10MB4404:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ed06f4a-532f-4c7b-ff8f-08dc8551b6ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?S3I0UzVVazF1ODEzdURTQjlPVlFzQlprNzZFRDdGTlM1NG80UHJURlZWSUhw?=
 =?utf-8?B?Y2xWamNvVXo4TGlEN0lmWWQvWS9vTkhFaHA4VTlCYVJsWU05TWhIajhxWjI4?=
 =?utf-8?B?QWxyUFBGTlZiVklwc25xS3NQRWZ0a2FPWnpXc09PbFdnelBud2ZOeFdiRi9C?=
 =?utf-8?B?RDl1allyUGd3L21xSm1YYytBdU91T1h0Nm1rVzJvdE9QNmxGQmU0dXN3b2Zz?=
 =?utf-8?B?NlZhc1poRTd3MUNTUGFGQ1BVcjVqTUI3QzNIZy8vdFZKMmVkbWV1VFl6d2tU?=
 =?utf-8?B?bUJ3RHZIQjFZY1NoM3RHMmQxLzdRT1hRNG1xSnNvZnhVTnFBM29Dcmg3RFFJ?=
 =?utf-8?B?cmZacStxSHlrTkxMeTFLcWZudDVaQVUwaGZqOVJJYm9sS0t3VUdaaDlvcStt?=
 =?utf-8?B?bU5pWWtPNDF2M3AwUzFmK2FJdk1tSFpERHpKVzUwcUt6OHFqUUxwUHRJN2t4?=
 =?utf-8?B?N2xoR2w3djNDM0ZtY3Q2cmY4elVzY2U1dzdxaGRxM3h3Q3RINzBMZUJOem83?=
 =?utf-8?B?SHFrVjA1TnFWQzNHQzhYQzZlaXhTUkozUmhMNGp5MTVtY0VEQXJwZ2tnYWlH?=
 =?utf-8?B?cXVtZ2IrMXRIR0taMDd1TXhBWjlBVFMzU0g4Vlp2SzkzTEg0WG1jemlCQjRr?=
 =?utf-8?B?RkNVZzJzckkrTzV5OE9xb2dUaStvZGJzM0svbkJOT05rMUI5R0c2cEpxUFJT?=
 =?utf-8?B?bFpIRjh2M253RS9YL0tLaDRMbUJqWFE4N3RrM0hZWGpzUGgyWllrdWxlcGRh?=
 =?utf-8?B?bTBSajV4eHAxMXExdVdlR0diVFhTVUFBOUY2cVRVWnByU2Z1QmlIcXJhZVZN?=
 =?utf-8?B?K1lGWDArOVNMRCtRUWVmL2NZVXpHaW5kZkJtMjgwdGFvUmlUSmprTTZoa3VD?=
 =?utf-8?B?M0E2WUg3UGt4dWJuKzBaU1lVaFpQSGhkVUZzSU5NYWh6ZERjK29scmduWFRa?=
 =?utf-8?B?SlpCTXF1QTh1eEg2MFBTUVFIa3pqKzl3SDJDUEdsNnhBbjBtQ29pMnRRTTFv?=
 =?utf-8?B?TU1QMWdrZHhYby9sYmtZNy96OUNkb28yQjF1SXpNVWlHVUVuZUNPZVRVd1Bn?=
 =?utf-8?B?SzNkSE5hM2NxUGN2VEhVTkcvajM4RXpGSVlXeHp0UTFHODhoT0pJYmxpWjJ2?=
 =?utf-8?B?T0NCTzhSTDVwN0RxUllraGNDaXZoa1B6Mm05eFZDNC9nWVkvRTIyZXJFOHNa?=
 =?utf-8?B?TnFPSXNKRk9BdDNXaVpYbm1UQVBic1JEOS8vemptQnRwdUtJZ3lieHVXUkNI?=
 =?utf-8?B?eE9PRW9OVHRUMEtqOUxPS1grdDlOaEkzNW95OVo1MnhtdytSTHBOWDU2Umxl?=
 =?utf-8?B?eXNFNUh3WXlzQ3FCYnQrMmQ5azRLT1pwREZHTmVHZFM4MlNpMDE3NkNZYW1U?=
 =?utf-8?B?TXNlRkMxZ1FmeDhjd1NhUEtvZUQzRzR2WmQ2WkwvWXpGYjdYR2hCdlJoeEF3?=
 =?utf-8?B?MU0waTZreUVJRDZvcUdUclZ0NFpHNmh4b0xTNEd2WWFIWlV6TThuNSs0cE5N?=
 =?utf-8?B?WWtmV3ZrNFpSYjN4VGR2eTZRY3FKQmh6VFFFc1FxNXhYVjNobHVySXVkYVNB?=
 =?utf-8?B?VVluM1ZKMnFsaDU3dlc0S0J5aTFaN0k4cDhkVy9lbUh0UVhRU1JhYUNPdXd5?=
 =?utf-8?B?MEVmenVWNVA4amg0VDVsL3ArUHpsZE1pZXpHNyszY2kwQnNXRTl6QWh6eTNM?=
 =?utf-8?B?d0RPb25BUVZxcUg3NFRjTHFJaCtKTDhJdnJGQzgrSUtVT3VETFNacmhBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cm9IZUFmZExOLzc4SjkwS2l0UFdhV0IxZzNYMURMS2F4RUMzSURvUU0xMjY5?=
 =?utf-8?B?c05qZ2RmRkh3YU8wRnp5dzYxWXZIcS9hU3lXLzg1aEFRb3I3S2c2WVE1Y2Rs?=
 =?utf-8?B?K2FDZDU4TDFsNytIWFdkWFg4Zm9iWHQ0K2wwWGMrQUUzK1M0Mm1ka3orVEZz?=
 =?utf-8?B?REdlbmlMTndDb0VGN3NRU21NOFZjRlR0TGRBaGNBRG5aREo3UVdzZW5qK2Rt?=
 =?utf-8?B?a0U5aUM1cC9qRFB3SjVpNUE2enlXTFg4ZlVlNWtDRHZ6R2h4SERJZlBYaGZM?=
 =?utf-8?B?NGlKMFJHTHptSyszZHhseFh5b1RUbnphUUo4aGg2OXRSS01XdzhOSW4wUjBY?=
 =?utf-8?B?M3c1OHlJUkVlQnloc3BITnVMS05ZTGtISVZKdllkdUd1UTM3N1NZVEYrbkcy?=
 =?utf-8?B?MWo1S1dLK0wyRXg3aXF3Z2tFMzFhc1NoejRaMEVxMDdMdlZ6MVJyRnJXaUtV?=
 =?utf-8?B?eFFGa1FKMnRRaHZ4ejVEejFsblQwcGJHSjZnVW01THpMK2xtV3Y4VDk2QVQ4?=
 =?utf-8?B?dXR4WVVoVzFLNXhsYTZ1S0pnNkhtcndjSlNwcS9KSmJNNW1TV1lyNUEwSjdG?=
 =?utf-8?B?MTFhSVZ4TlQ4MTh2WmwwWHFacG1RcC8yQTJBdHpocFROYTFlSEN3bXoreWJm?=
 =?utf-8?B?NEU3WlMwZloxTzQxYklKci9xdmE0aXhVeW1OZjY3OCtBNGM4MVM0Q0VRM2F5?=
 =?utf-8?B?MGMyS2N0NlBJZUM3ZDA3aElpS0s4cGkvWHVXcmREU1VSNW14bWxZeUxPZUYy?=
 =?utf-8?B?ejFOZ1VqV1JWRlFoL3prZmFiOFJLc1hubGJSSjNtZ09KTmVXQ1F2WEZzeU51?=
 =?utf-8?B?KzFqVmxWMnhDRnZYTmRuV20wUXdiWHkzbFBrSUlVdFB1QWNLNFBXVFZ6encx?=
 =?utf-8?B?WGRNNlA5WksxUFVjakpmalhBbEVVOTVTb05KL0tVSVVDZXRWeW1JSHdaZTE2?=
 =?utf-8?B?SXovamNodVZPZHF2cWQ1SDh1a28rS3FkRmJ4bk50Uk44OVVSTWl2OFB6dDVq?=
 =?utf-8?B?Nm50YTU5a0pUVUJ5dThTZVdjNzRnd2NXMUFQRFlIUU45TXkxYTZ5UUgyS1U5?=
 =?utf-8?B?VU41TE9vbm5OckN2c05zMHVjNDZBRzRHc0xIWU5aaGNVWWxUMitKM3hBbXlB?=
 =?utf-8?B?NHNKMG1IY2E4RzdmM2tPU3dGRUpDbnVwamx5ZER3bTJJbVRKOHBPV1hXcFpn?=
 =?utf-8?B?d1NNa2VMME9ZeENqUUcyaERhMURSUjl1bi9RSGFqMmpsa0puWUVzajFOdXhh?=
 =?utf-8?B?eTg4VVRVSFlLcjRvampaNEszT1NlVC94MnRnQmY2OVd0ZHBjc0Y0N2ZvMHdJ?=
 =?utf-8?B?Qjk1eWwzT2V3aU0zdU16V2JHQldOVSswb3NzNllIQmx0S2F2bmh6Y2VkaEVD?=
 =?utf-8?B?Nkp0SHp4ZlYvUW96c0twbGFUa2Vyei94dXdiVkVlcTNuVmJLMHRkYk5KQ1ZO?=
 =?utf-8?B?aUJYcjduS0Y0VUJwWStRZllndXUrL1VSNUUyRXQ0UUpBTmd1Z3NMeXY0cFYw?=
 =?utf-8?B?RXdGTGtXczhleWRxZDBheElISUFGVDJMdHpYM0kvOFhkRWRwRzNTVmNUeTBW?=
 =?utf-8?B?THc4SURGV3BPcHJpVldPdzJ6V1FLL3JJKzEvbEtlOFJJOXRCdmJSRUlLODBy?=
 =?utf-8?B?ZlVCdmdoQTZaMDh6ZnNKZ3dsbWwyL09lY0MwNzcyclVMbStCUzJoVFl0T3FM?=
 =?utf-8?B?NWNOQktTRzR6dUt4bVZXci9jbjVTRmJvaGJaRExoOHFFTVdxSXg3TzEycEda?=
 =?utf-8?B?ZVB3ZjlZalllK2I3VWJSMTY2U1pFVlBkVVQyQzEyZmFrZmhpQjBScHJJUmJS?=
 =?utf-8?B?a21LZ3Y3eVZNUUZCYWFNL2Nvd09kVzFSK2w0RWh3YmcwOTNqR3RSS05xbi9B?=
 =?utf-8?B?NEtqemdSTGhFcmNLMUtvT0NGeHRGekxZejBlT2Vya0YybEl0alNOczdJZmFN?=
 =?utf-8?B?OGRQdHpNbVI0amROSHZSSGorYjREZDZVVWNGZDZkNWtnYWhhQ28rRWFiNHgr?=
 =?utf-8?B?N3IzbG4xZ0tmSW5hNXc4Q21rL1V5Y1g1RmxWeklKVXZ6eStHejB2ZS9ES0pU?=
 =?utf-8?B?UnFpSFVBYlV5Q3B4SklJZWthY05VRWNKOTh1NTRoQjVnR0ZtU09HYWlpTGND?=
 =?utf-8?Q?yo+x+9jgWmzp0Lx3L3Xmqjthz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	AzQao3usCjRAdapfgCvp9bthY2h5Tvb7vHkhL/E14xgIC30KlSKHin0RwT+LyZ1eVTD5dUEHJxZTgvHqaLHpq35RzmusyFBOLuxgKXU4Ef8/ih1F6d28x5iTuNXHY4wgqPfuuA1BV88j+0C/fcgwsW3Gj/yJpmUXLXZ8CCqDddmRIDgSuJLvzxbz+oodgYpPsCwUqLl6EDTSBliHe22E78dekhpBZQDlBGmgPya++raiH00cOdnrtxUzEFHHWNY5KgJAbCujQVhSyQru9ZH6YsQLI3z4a1AVQ2DEDmkO8S+eJDk1ecTVHHVm9k0z/iHPAQZ2heyCUO/RTuNVUpgbb3Us05i/xQGMWGEPcc/JieWIazTsae7ccnl/9UZnvUoqoezz7tn6OBGgA7fWAr+ZJ1wjhWBpQojBEhkwPrwyoQ0fNFUmtAx9s86H19e2sog33EIAgwBTCnuDyK0XyfKV1VkipOeyItc4UD8hyeEVMBC3d+f0TU6cu8ibJmRACCb5cmyQkGDVtx74AyXMKQoI1djKK8yXm9CazYeyQikw396iRyk/Z/6Q4bBmiZrtX2LE4h+PltA+LpXoLb+N0eqYMlpAIqloKw8zi5+dCAFyH+E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed06f4a-532f-4c7b-ff8f-08dc8551b6ae
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 11:21:58.5682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmOSwPRTp/mzaVa84Kijb9BKdxzlNCpK87eQz/KL3ZihGT51u/vhN/8c770p1AXhdCv156HQbyKrtghFEEHd0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4404
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050086
X-Proofpoint-GUID: Z5RwQW7sIBPOCP4hysl-UI3vqqx-846S
X-Proofpoint-ORIG-GUID: Z5RwQW7sIBPOCP4hysl-UI3vqqx-846S

On 05/06/2024 09:32, Christoph Hellwig wrote:
> On Mon, Jun 03, 2024 at 02:29:26PM +0100, John Garry wrote:
>> I think that some of the logic could be re-used.
>> rq_straddles_atomic_write_boundary() is checked in merging of reqs/bios (to
>> see if the resultant req straddles a boundary).
>>
>> So instead of saying: "will the resultant req straddle a boundary",
>> re-using path like blk_rq_get_max_sectors() -> blk_chunk_sectors_left(), we
>> check "is there space within the boundary limit to add this req/bio". We
>> need to take care of front and back merges, though.
> 
> Yes, we've used the trick to pass in the relevant limit in explicitly
> to reuse infrastructure in other places, e.g. max_hw_sectors vs
> max_zone_append_sectors for adding to a bio while respecting hardware
> limits.
> 

I assume that you are talking about something like 
queue_limits_max_zone_append_sectors().

Anyway, below is the prep patch I was considering for this re-use. It's 
just renaming any infrastructure for "chunk_sectors" to generic 
"boundary_sectors".

------>8-------

The purpose of the chunk_sectors limit is to ensure that a mergeable 
request fits within the boundary of the chunck_sector value.

Such a feature will be useful for other request_queue boundary limits, 
so generalize the chunk_sectors merge code.

This idea was proposed by Hannes Reinecke.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8957e08e020c..6574c8b64ecc 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -168,11 +168,12 @@ static inline unsigned get_max_io_size(struct bio 
*bio,
  	unsigned pbs = lim->physical_block_size >> SECTOR_SHIFT;
  	unsigned lbs = lim->logical_block_size >> SECTOR_SHIFT;
  	unsigned max_sectors = lim->max_sectors, start, end;
+	unsigned int boundary_sectors = lim->chunk_sectors;

-	if (lim->chunk_sectors) {
+	if (boundary_sectors) {
  		max_sectors = min(max_sectors,
-			blk_chunk_sectors_left(bio->bi_iter.bi_sector,
-					       lim->chunk_sectors));
+			blk_boundary_sectors_left(bio->bi_iter.bi_sector,
+					      boundary_sectors));
  	}

  	start = bio->bi_iter.bi_sector & (pbs - 1);
@@ -588,19 +589,19 @@ static inline unsigned int 
blk_rq_get_max_sectors(struct request *rq,
  						  sector_t offset)
  {
  	struct request_queue *q = rq->q;
-	unsigned int max_sectors;
+	unsigned int max_sectors, boundary_sectors = q->limits.chunk_sectors;

  	if (blk_rq_is_passthrough(rq))
  		return q->limits.max_hw_sectors;

  	max_sectors = blk_queue_get_max_sectors(rq);

-	if (!q->limits.chunk_sectors ||
+	if (!boundary_sectors ||
  	    req_op(rq) == REQ_OP_DISCARD ||
  	    req_op(rq) == REQ_OP_SECURE_ERASE)
  		return max_sectors;
  	return min(max_sectors,
-		   blk_chunk_sectors_left(offset, q->limits.chunk_sectors));
+		   blk_boundary_sectors_left(offset, boundary_sectors));
  }

  static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 13037d6a6f62..b648253c2300 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1188,7 +1188,7 @@ static sector_t __max_io_len(struct dm_target *ti, 
sector_t sector,
  		return len;
  	return min_t(sector_t, len,
  		min(max_sectors ? : queue_max_sectors(ti->table->md->queue),
-		    blk_chunk_sectors_left(target_offset, max_granularity)));
+		    blk_boundary_sectors_left(target_offset, max_granularity)));
  }

  static inline sector_t max_io_len(struct dm_target *ti, sector_t sector)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ac8e0cb2353a..7657698b47f4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -866,14 +866,14 @@ static inline bool bio_straddles_zones(struct bio 
*bio)
  }

  /*
- * Return how much of the chunk is left to be used for I/O at a given 
offset.
+ * Return how much within the boundary is left to be used for I/O at a 
given offset.
   */
-static inline unsigned int blk_chunk_sectors_left(sector_t offset,
-		unsigned int chunk_sectors)
+static inline unsigned int blk_boundary_sectors_left(sector_t offset,
+		unsigned int boundary_sectors)
  {
-	if (unlikely(!is_power_of_2(chunk_sectors)))
-		return chunk_sectors - sector_div(offset, chunk_sectors);
-	return chunk_sectors - (offset & (chunk_sectors - 1));
+	if (unlikely(!is_power_of_2(boundary_sectors)))
+		return boundary_sectors - sector_div(offset, boundary_sectors);
+	return boundary_sectors - (offset & (boundary_sectors - 1));
  }

  /**
-- 
2.31.1






