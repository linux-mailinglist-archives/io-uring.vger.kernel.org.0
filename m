Return-Path: <io-uring+bounces-2077-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9323B8D83F1
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 15:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B673D1C21B29
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 13:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8422212D762;
	Mon,  3 Jun 2024 13:30:08 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C2012D74E;
	Mon,  3 Jun 2024 13:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717421408; cv=fail; b=tVmIe8+NiI/jf1mIpmpNKNOM851lZ6/e8ZL5x/LDgqvJvcjYzspypVVM14w2C/cKI9XGLhk9mgxc8h5PFdUolIQPUKsktQIQszP2U87pn0/naFfQXrXUButg1vmtIXGcJwZ45uQOaqwTgtyw8LHBl5lPtSeJXHFVqTKh7OZq+DI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717421408; c=relaxed/simple;
	bh=5XWsAYnpRps/JNt7kVYvWS+VmKimfPh2uoJaaehqkTE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lWcOmMe29HYfig0hfxz25WL4biLp84fnlUW/Xb9gu7/H4XWr77OAsRK2WnkwM3CbDKkkFGwuWNScV9eE+iqegshi6fX87SwcLNMqTAK8QFm4NI03FRpJnMuy8S5T6ohGVWCZTjm+dWiOPpRZVZXmOCPzWZZRU9oVZGaPBUu6KuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453CB3J1030592;
	Mon, 3 Jun 2024 13:29:37 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DOVOgaXtqv5/O57xmUFJh268waKorQsDTKMX74QnPo6k=3D;_b?=
 =?UTF-8?Q?=3DGWMGAi4Ua+FfmiUgrpyz7SAlRNPev7nxTy3E7RlH+ojQKwOVOcWhmR+jr+Ln?=
 =?UTF-8?Q?1w4b7lLV_ELp7MKXHBozTMYeUpUXR5c3Zew62liCWMK07lW006Gnze788tsPFqF?=
 =?UTF-8?Q?+O9nOnw5XiqPwC_YcoWA4oPUZVsaZEh3ODh/iJooVc9sEQ5vhL+zrhpbUekUVLF?=
 =?UTF-8?Q?Bv7DPOq6mCBkrNG3gXzR_tOFp0SU5PNCn+G1oj14PyXhBLxQu4FyPtDYi58J2gA?=
 =?UTF-8?Q?SAAznY4DeWWUFhYE5iENlKO3qw_AeIVcWycCMOfRiqpqmnJEtINItSimN5jGm4E?=
 =?UTF-8?Q?bTp3NKQm0eeKGIP78QIQoDGwtcHtJQL7_lw=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv6u2u9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 13:29:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 453Ca6LK005525;
	Mon, 3 Jun 2024 13:29:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrmc5jxu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Jun 2024 13:29:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih1vgMbBDfwstQvelUrADgqbKfYYJcP4lfn3lPMxBV8g57uTlhiw9JRmfp5Wfe4KhiH67mY585K4tFF08ztrJ3f+5lvLy/gjmoYEXgY+WLxi6MLX3FSVlKnf7pW8DDKix/603ibel8QwQEH4bu8XwoN2MOro/w+6Qkg43Wc+bydpGr7sB4/uBmHjM5DWxkzuJHRBuZOkhgS9svjLMZjVD4pEsMt+/TedUz91UpgJxWePUbrINupUzfaC8MorKBwxjvxaizRcjyB+vaT2Qakuls/GRt4V2LkIjzxGhMlZu5ntC/D4JvUG9WxTFmPpFb53ii4jrupt1aZ33YRiZFBJGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVOgaXtqv5/O57xmUFJh268waKorQsDTKMX74QnPo6k=;
 b=CyTwfUiD66JnBRrn1mekhdq/1Jl2j5RK1BMQZn1KjnQjIFwiAjYuzsqeYp7Y+zPq1PaPp5IDaKr4C2o6IwlBjVvUyw4ty7EvweC5ZmlphHKp49jJlos2eNm909E0yhAMy7wz50XZ47drsT1fE+6sBAQQl5ila/+fkaJnMQpmO4K+wFRp6wjHbAgjRFxWenC/9PKXU4B04he6s8qS0b7t/p6u3zUlJL/YxarchVOVN8pXUfRlqayV8EZ9ptIU+VdZWaOikGCo1WphIq9H9De8L1Ty7l9/iJNtSAUiU65JWavYQOjRd1ogkO70B3UNESJKIGMHqghSuYZuJalfa7Ja4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVOgaXtqv5/O57xmUFJh268waKorQsDTKMX74QnPo6k=;
 b=cVmLG4lXJSWWsjMy+ePle/lF90/XUT4CguKq3ErB1DnbfmdIZTkEYqqhvS/JE2ley8i9kwiLXUdorSkV5BxTORmPyIv/qsawq2xpD105lkVBrwUODRu5laftp4k+/g1vLCxkT1QvnKLhbTjWQY0LRa6gSzmnsWys4hxL5wHSK3o=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY5PR10MB6240.namprd10.prod.outlook.com (2603:10b6:930:40::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Mon, 3 Jun
 2024 13:29:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Mon, 3 Jun 2024
 13:29:33 +0000
Message-ID: <76850f4f-0bd0-48ae-92f4-e3af38039938@oracle.com>
Date: Mon, 3 Jun 2024 14:29:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] block: Add core atomic write support
To: Hannes Reinecke <hare@suse.de>, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ee20a47d-3131-41c2-a2fc-39017f535527@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0030.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY5PR10MB6240:EE_
X-MS-Office365-Filtering-Correlation-Id: c66b790b-9d0e-43c1-69ae-08dc83d1346e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|1800799015|7416005|376005|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?TU5YdHJiQWZhOU5BbkZybTJMc0J0Q0ZiUmVGWDBhZ1VzYlZFUTVJOWZHWEE2?=
 =?utf-8?B?Ty9EL3NrVTM4Q0ZuU2xkV0VjUDduVVhoaTByV2pqMVVIOXdGdlcxeFNTVFlL?=
 =?utf-8?B?SkREaEpBZmpMdVQ1dWZxbzZlaEdTM2daZGxhQ2QraDlSWnQzYjNSN2tVSzlU?=
 =?utf-8?B?d291TWFvUW10ZDV4QXp1cnFSSnBFTUpyUFJMSkkwV2JPQVZiRG01OG1zaVFT?=
 =?utf-8?B?MWZkNExSczVBbVZ5VkpIWEhhSXhVWXI4WDYvL2RwRHpIZ2h6aUVsbVkzR2Vq?=
 =?utf-8?B?alYvYS9GQ3lJV1RBNmRsMmJQWW1CemcxWUI0dVh3M0RHTEI5QXF6Wm5hSWV0?=
 =?utf-8?B?UURRWkpqZk1McjRvckJ3ZFNvWC82NVlpRGFYSFRMYVZpTzRPbDB3U3A5SVlL?=
 =?utf-8?B?bHBHRlQzSGlCblZLa1dOUXFlbHZVbmlNbXJSQlU5a2gxZ1YwQnRqeGZiU1VW?=
 =?utf-8?B?b0RxT3lzZU5NRVFwQTMvaFlYOUJmanJ5dlppTThCRVU1cXNnRlduajIrbEJR?=
 =?utf-8?B?Wk9Fako2VmNuNzJHZkFrOWxJeDdkQ2J2QjZkWEdjSnJab3VzMnlPVEMyOCtq?=
 =?utf-8?B?Wm9veGVzRHRpZ3lRVGQ4aG1ua3QzWEtRQllMRHVGd3dlN2xoWVJTVkRvd0Y1?=
 =?utf-8?B?aFl1ZzRhV3hiUzdxdTNPVERiQ3lzYy96cjNPWU5SdVZDUzh3WG1MU0Y3Mmk0?=
 =?utf-8?B?TmdRYTgxNzRjd202TjVSdUhqb1RJZ0FLS2lQN3lLSEpCL0VTaVYwbitMcERL?=
 =?utf-8?B?dDRIdzEvWi9GRTEyK2lYMnVsS3Y5THhYVW9DVmo4bzJFaWVJSFBqT0lBTEZN?=
 =?utf-8?B?clpkWk80ciswSmR4ZE1JZXNpWXBQT0JnWHVQbzN0ZGJwblpFbXY4dHZTcXh4?=
 =?utf-8?B?Q1piWTZ4d2pZL2lNbHpCaW9wR1dtOHJrRmFFaFVydURMdnJtSTFCaUtENUZG?=
 =?utf-8?B?dzRYQXd2aXJ3cEdrUThVWEVseWo5NnBDMDR3RGFBS3NoM3JHOVpPSWtETW9Q?=
 =?utf-8?B?YU1XWHhJWHFVZWhLbmhYSnhxbUhSUlBmclFSNVZIank4YXlBL2JSOC9DcHFu?=
 =?utf-8?B?aXhTTCt0K0RaY1NpYit0aE10UmxZQmVDTThLYThLSDRjSjREWmNPU1Q4T21X?=
 =?utf-8?B?M3dEcHdiT216SEFLc21pQ0czZ2o2czVwMHNRSVdjMExiRFJRK2hyUFV1aGRw?=
 =?utf-8?B?bXRPbGdsMXMxZjFkdWpFU3dtTXM3dm56UTc1SkZISEhpcEU1ejJhRnVxbXNT?=
 =?utf-8?B?aDdoUDhuUXJ6QkFLYTUybDJEektsM1RqMU1ldlNONE1McTIvMytkem1VRWtJ?=
 =?utf-8?B?ZmhiV2lWQmg0clNNZTJZNTZxN3U4OXhBTlg0WkZpT3prdG9CcHg3MGcyNUd2?=
 =?utf-8?B?b3dmSmtjaDlNN1VzU0xualk2eGlvaGk2SkxLTDZTLzRFQ2ZRUnlvY1QzbS93?=
 =?utf-8?B?L3ZRN003dHhCR2E3M2lnSjgxRzdpbll5MXlVMFFZU3ZWMXV5a2ZKQm5lU0ho?=
 =?utf-8?B?Z3E4U3VwVnRzcnRQM1kyb0YwK2x0SjZPMVZoS25kNEZmNGJzeGRQNUY2aUlK?=
 =?utf-8?B?SFNmYnJIZFFDQUhKSjFnTHpFSUFmclRTOW5sSnlMY2l3eTlHYjlKbzlFWmJR?=
 =?utf-8?B?WHhEbDZVN1U1TW0zVlR0d0dDbDU2T3dNejdUc0RadWlYTXV6RmlGWGpLZHIx?=
 =?utf-8?B?bm0xNlNRM0pMeSs1ck5xS0ZNUklTQ0RZejZ0eWF2YWJDclZjUVVsUk1CUVhF?=
 =?utf-8?Q?Jt9etf6ontXiYMhQqbJvQEeqBfXRpW7NWeR6bL5?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OGtLVkFFNnZmNFJiQ2RJcTA3MVF6ZzRVMXh4REhBaFBTamthbVI2aC94UjBz?=
 =?utf-8?B?c1lNSzNhSXdVdVRTb0ExMFBoUzdsSmVqQzloUFlCblF3TkxqUjhBWmgzV0xq?=
 =?utf-8?B?aHgyZVViSUZiVFRjczB1RVVPdGJyWnczYUk0Q0tydXdNL01wZnlsa3NoUHpy?=
 =?utf-8?B?STFoWGtzZ1pMTDc3WGFwbmN5VS9vT0cxRW1MYzg5YWRpUk9YZ2duOVN1dFBv?=
 =?utf-8?B?b2hxcVVNdGNiUnlXZkp2OC9DcHJRVG5waVM3ZmRWZ2piZWVmOThoTTNidzZ1?=
 =?utf-8?B?Y3ZzMzJKZ2F0OG4wS1hNNmlpZnJ6VngyNDhEbDQzUUFEUXBENDZZUXdMSlk3?=
 =?utf-8?B?YlZOLzRJcXFZQ2RHVEJGb3pmQ0NKaS9qUngvdWhMaHpUTUp1dVh3ek0reWtV?=
 =?utf-8?B?dHlqcWFUY0FqTHpScTRxTHp0amdHVlBndjRmbk5VU3Zrclh5M0RadElJVWlG?=
 =?utf-8?B?U3liNzVPVUNvVlVWZ2t1QUk2SERXcW44YjhIL0ZWZzFTd3BJS0hUSHNPQU9l?=
 =?utf-8?B?eENpeksvODFDdVAwSU03aUhSRGJHSWx2bnhkRXB4Q3hCOTdLbUxmRjdHa0Yz?=
 =?utf-8?B?ZC9YdzE1VS9VMU41QkFlcndiZnM3WTZ1UUF1QXE5MXhoUndVNkszK3BWSmlG?=
 =?utf-8?B?dEhUamthZm5pWjNmTk90KzRpTkVaeDgvQkpTRDBYK3JadWl4KzQvNWR3THpi?=
 =?utf-8?B?S1k1bHNmZUJJZ29pUlRLMWRLY2ZoMWxmUmdCWmVsUUJNeHVGSnE4dlZKYlhK?=
 =?utf-8?B?cFE2Tm0zKzZyQ0E0TUlQWlJrYUlrWm1EbzdZeEFTc1VNaW5QT29MenJ2YkZV?=
 =?utf-8?B?OHRZY1JYVDhXRThtTW14dnNKWTZ3Y3A1MDk2b05MN3NQdTZORW1JMUs3eENG?=
 =?utf-8?B?ajdpdDVQUjIrNHVXQXhNaEZ1TGNVWW5RUkZZdnhKZklvek16Rm1UNTFXYUEz?=
 =?utf-8?B?OEZwTGtrZUw0SnorSGpuV0x5czBFTkFEQ0dWOUd3d3dXMzZyS0RhdDBycFhX?=
 =?utf-8?B?Yy9RL2l4WHR2RjlYbmI1U0NmU0xKTEd5M1N2NWNKSGxFVjlSSlhsVWVHdHg0?=
 =?utf-8?B?NjJ1ajk1QTJRbVBueFNKOUlNRlIwZnFCMzVGOU12R0tidlV2OHpmcTFrckJF?=
 =?utf-8?B?cDNkZmlTY2Nmcit1TEZvbWZoSFFyb2M4UVozYjYwZUNYU2tHV1F6cFhXZXg0?=
 =?utf-8?B?MDBNU1NJZnJadDZYZit5Y3AyelNzTkZhbHdlYlgwR3NGd3R1NXhGcXg0UUNv?=
 =?utf-8?B?dnlRVXc3ZUg1ZFI1am1zMjIzTTgwNXJ2aDRhVWcva294NTR1YmJmZ0wxenFL?=
 =?utf-8?B?cVNaR0txcG5mcGUxNFNKWXUvYmgvbE9vNmtGRG45RzM1NGt4aktnZ2pzQVA5?=
 =?utf-8?B?eEVwM2swRWlPWWZ0YVUzdEE0TldqaFAxalJzOG9SQ0g2UHhtSGRsSktKNGxR?=
 =?utf-8?B?UGpJbWhNSU5TM0Zoc1hRNk5FZGlhbG1HUGoralQxNnpkeDhVUWJ1K1F5ZWl1?=
 =?utf-8?B?OVZMV2dTZmd2M1Y5Z3NKMUUrdzRER0Q1VzR6UTA5UkdSdFpTenkxWXZPZ2dp?=
 =?utf-8?B?bWZqOEdlRTRFbk5YdHlhOXRlRklyNVV1cjNDK2VVRW83TEZrQ1NrY3YvZHN1?=
 =?utf-8?B?TVNlVFZJWHhaN0pxckpTZXRoNWVVRTF3QzBzcERkdTlwKzVpdCtJek1HK1ZO?=
 =?utf-8?B?K250eGtldEZ3RmlieDVIYTVNc2MwV2ZLaFZVcUNVSkhVb2hNM3hKSEtDK0Jh?=
 =?utf-8?B?WXl5d0FtK1MrUlhaRjYyOSt4WktEanNmdWl1eS9CbHRKNmtWZEtoNC9VYk96?=
 =?utf-8?B?VzdneUtkQXk1ZjM5NGp5bkhwQU12d01mbWZLRGN2U1BTMm1BUXBEOERvSlY3?=
 =?utf-8?B?elErelFpcjNKNTZjaTQyYTVqMElvT3IydGVyM0NnWDdnbWJSdzJFTHkwcUN4?=
 =?utf-8?B?dFB6YkxDdWFNSWJsaXNFbHlXd2o2aE13SVRUWlhrckNGTVVWVkVmSXlodVdL?=
 =?utf-8?B?ZU5aQ0c1eVUyU1AySFRNWDRtYWdZMjZWaGlnZ0pYbmFIQm15Z2x4bElOaCtJ?=
 =?utf-8?B?alJoN3oyZ0E3NU8vQkJlcFhIMUZoVVozenViVlFwcThjQytBM1kzYkJBTTNC?=
 =?utf-8?B?blI5cVpIQnlRamhvcTdjRE1HUG1KUW9ueHI2a1ZQUEZpVXY5YUNnK1BjODNr?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+JpzITqgbbLAEGjtlDWxRbMdp6fSgv7cszoDxuHbLemrb9FEF/iBeiMa4Ag5yGVkruaIW/V8Aa3qHyX5QhUw86l/UY1OJHm2JOpjpKIv3tzF7pA0aJFit1rK1/t7f8Vlt6yr43N3g6O78WAmxtTSRav2y3NpMCeAQOd8IESXdAIrOppHAtw+RtB2BmKVCVnO48XqACwuIzb4CjGyBWI25zOiVP5co9qUpvsaC5mL6brZi1iW8t/XOdTpb2R5GuuLuZenmxde7Wmu0RIjpu412G/W4TRWB+80VZ9dFGxCS6SoUHkhJmPnfAm+fOKv7tpGt8yMLQHRpq4XeqdzC5jj7nl+EllPFf5VOj1bZi1yozdQ3AqcU1YydOoQUZyWzR3v8lHQFOVm7SvFgjY1MLxbLjjhYvnsZWU/SXO4QL5sbWq5BPX0QxHmjDwlV0wa7x7rdo8/2aQnJz0sCux28bk1CPxWKZKSZ7QxpXjhJaTeFfkeVvgeRuqiHu+/moB9Gfyg9sn+4ANZKSvDkqM2Wv9Dj5Xh6LKQmTBfnXGlMsBDqyttJATZ0GTQogVpassWdn+iT7ApAbfX//BJDllyZL05aPRD30sKVAPoWahn8Q/2yDI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c66b790b-9d0e-43c1-69ae-08dc83d1346e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 13:29:33.3603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P8NK8DhodPDeyrFEGyLI8za3ZKj3BmC/k8TDL7ycSCiXI6vLYpLRJ8WNno9JmXdYWAjZBwqPW6krdZXV781rPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6240
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_09,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406030112
X-Proofpoint-ORIG-GUID: jrH0jAzD18TuEbHKIGv3IKbJefk2KXm1
X-Proofpoint-GUID: jrH0jAzD18TuEbHKIGv3IKbJefk2KXm1

On 03/06/2024 13:31, Hannes Reinecke wrote:
>>
>> It seems ok in principle - we would just need to ensure that it is 
>> watertight.
>>
> 
> We currently use chunk_sectors for quite some different things, most 
> notably zones boundaries, NIOIB, raid stripes etc.
> So I don't have an issue adding another use-case for it.
> 
>>> Q2: If we don't, shouldn't we align the atomic write boundary to the 
>>> chunk_sectors setting to ensure both match up?
>>
>> Yeah, right. But we can only handle what HW tells.
>>
>> The atomic write boundary is only relevant to NVMe. NVMe NOIOB - which 
>> we use to set chunk_sectors - is an IO optimization hint, AFAIK. 
>> However the atomic write boundary is a hard limit. So if NOIOB is not 
>> aligned with the atomic write boundary - which seems unlikely - then 
>> the atomic write boundary takes priority.
>>
> Which is what I said; we need to check. And I would treat a NOIOB value 
> not aligned to the atomic write boundary as an error.

Yeah, maybe we can reject that in blk_validate_limits(), by error'ing or 
disabling atomic writes there.

> 
> But the real issue here is that the atomic write boundary only matters
> for requests, and not for the entire queue.
> So using chunk_sectors is out of question as this would affect all 
> requests, and my comment was actually wrong.
> I'll retract it.

I think that some of the logic could be re-used. 
rq_straddles_atomic_write_boundary() is checked in merging of reqs/bios 
(to see if the resultant req straddles a boundary).

So instead of saying: "will the resultant req straddle a boundary", 
re-using path like blk_rq_get_max_sectors() -> blk_chunk_sectors_left(), 
we check "is there space within the boundary limit to add this req/bio". 
We need to take care of front and back merges, though.

Thanks,
John



