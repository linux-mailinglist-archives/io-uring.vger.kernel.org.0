Return-Path: <io-uring+bounces-11439-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C70DCFEC6B
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 17:06:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E137A30006FD
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 16:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54956338911;
	Wed,  7 Jan 2026 15:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5i4WeyxQ"
X-Original-To: io-uring@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011033.outbound.protection.outlook.com [52.101.52.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616DE321F5F;
	Wed,  7 Jan 2026 15:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801378; cv=fail; b=NDR3OMMMES+qLwki68qG7Phe2xwwz8l7Pdbd+xRnDAu0Jcf65KP0Zm0MdA/cadVBn96VibVKTiDs/A8lnzbb4K1VxhmorDJE5QnSuauMUT0C4WmT/JeUnGqrl6EPXBixNhhVReTKDN7KCskFghvzzdoM2diKpkaucDz66/vK0uQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801378; c=relaxed/simple;
	bh=k7bATTiZkWOgFS/WEht9i/80RAe2MM/pLT2iT3E3z7Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VNWzbIS2KuU5u6pUtkzuBbVwysuEulNktkawPi3pkWQQipsGjPKC/PtTrvss613YtsAxcb/1d+A37k5rrr55D8oLqHMZmscrJ4Lt+CdEVhNXN8stcxIF2Qi2qO66g0W1BJ6uJYbP//5EQYAhIuXRKP16pPD+hUTpDjCSdoKRQsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5i4WeyxQ; arc=fail smtp.client-ip=52.101.52.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQQ501cBUratPYNc0BMOoDnbPobXSAyWpkGrYsJsLPD9QzxFjDjTfGtb3AZnluaU8bIa4JSIo+RxCQHx63xKFiPrN5riiK55hu7H+mtxhWnAOP9Ez+wl9WHm0eFXi2szOj0fp+Kahg/JPzVBdliU+qQMpkd0ehC3yxZtiCeaP4Pl7KXW/QIFrZ9CGBUX6xh85ICuvyy4fMvpydAQTHz95rN0wCZuz5LeM/sGtfsHCVnR2i50r/GTQlf7z1aueGDvQH5Z6pBz+EUkclR6Mudc+oKkKLo83zQHXOUL2j7zT3pmY965WJhRDjv702el4MeZAc/GV//ZhH+5r2GvAGq6yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yI812y4koyhAdOEl6YrNnBtpM+Ex0VABxMKXej+OcJw=;
 b=ehlwo/gH9q9IZ5n8TtARUtm71gqMPyaN8O0dgyq2tBQ0brnpk0qalpbtc1/7XxdAUKkIUEed1QyvvdZzWzoR1gpRqn9DJgXX1Zob8le1UTtaVUXTxVkX586XK0yVdSg5J5204JlFscjzmygQ9N5/uwY4Pgs+lx0+T9XrWLGeUb04nV7DXcyGpQrbccbnTnsbUgoQaskzywuQPCOH++T+pqzKVh1vrQ4z+MK2FuL+JTs7g7dyFkL5d1eDLfxLCov7CI7DxBjddICCzDD3XY5trb5wVQ/zdNs63yuKIhip/NbGLJBMElvIlVFv/EBUgg0yNYdfBhUHljufX/h7O7GorQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yI812y4koyhAdOEl6YrNnBtpM+Ex0VABxMKXej+OcJw=;
 b=5i4WeyxQOq24Ya+TDzVpCOlHDdpd7Q95nkAAz5P6a5hS/Sw5otUtIOOBiWOTxwzg4uWsxLrTq3AhzCGCoULCXvLIoVhTalVpXXIEGUqqTXpKaZOlbYBeePZC7pH8x93u4bEEax2mtDte62vJqF5RVqxzknBnm20HTMxJOn6eUxQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MW4PR12MB6974.namprd12.prod.outlook.com (2603:10b6:303:207::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 15:56:12 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 15:56:12 +0000
Message-ID: <754b4cc9-20ab-4d87-85bf-eb56be058856@amd.com>
Date: Wed, 7 Jan 2026 16:56:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 01/11] file: add callback for pre-mapping dmabuf
To: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, Vishal Verma <vishal1.verma@intel.com>,
 tushar.gohad@intel.com, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com>
 <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com>
 <20251204110709.GA22971@lst.de>
 <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com>
 <20251204131025.GA26860@lst.de> <aVnFnzRYWC_Y5zHg@fedora>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <aVnFnzRYWC_Y5zHg@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT4PR01CA0267.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::22) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MW4PR12MB6974:EE_
X-MS-Office365-Filtering-Correlation-Id: 3607b8f6-42fc-4b54-e20b-08de4e0547dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TE9BSG9xMFJzTGpJVmJnajNubUlEeGFKNDEvUExwakhjMXpERStCQjk5cDVj?=
 =?utf-8?B?aFgrUnNSeitXdDNDb253cE5OZjlOblVhWnFyZGtycXdmeDBiRzRYaWxFYlVZ?=
 =?utf-8?B?eUtIdElSVlJ0V2t3NEpUSlhrTlVDSW13UktndHl6QzliYjd2RkZrMmdqOTRI?=
 =?utf-8?B?T2MzeHhPdDFySnErRUszdFY0bkgwc2lxdnk5aEgyOVl4YjhvbzF0dzlpRFhH?=
 =?utf-8?B?aXdzc05yUU85RmI0WG9ocEh2bm5LU05ROXFOWG1mUUpDaWJTVm1qdWVpMGRL?=
 =?utf-8?B?ZTByWEQ4YjhhNUFzUlZnT3huZjUrMk14bWh6aTF0UVBrV3c5VWZubUFBNmJW?=
 =?utf-8?B?Qk1vZlZ5UGRVc2ZGekk1bDRGT1VTUUp6WjViUGNTYWtQazBad0VRL0Z3aE5S?=
 =?utf-8?B?S3Jmb1FIN05ZQ1JBdXRxYWU1MGFjT1dON3I3Y3JXOGZXWlFqTXlHeSs4bTRL?=
 =?utf-8?B?enduazdJd3Ird2RkR0QvdHYySTBWeGFvRzVHN1JxSjZoaXJlWmhTSXlZeXRX?=
 =?utf-8?B?ZDI3N21yTDhvV2R3VDJZT08vaDIxMjR4M1kwSE9UaWNtd3c1dk1obGRPbUlR?=
 =?utf-8?B?NUpFK29Rd2hoYThDN3dIUVEzZVgrVFNZbW41aVFETklWTnVnMmFoZXc0RmNS?=
 =?utf-8?B?NmxNOUppNFJqc3BXcVNqRnNxNHBLRE1oT2VIQXFvZDZRLzB6akJMd2FEVXlB?=
 =?utf-8?B?VnpoT2tTOS9xK0FzYktITlQ0akUxK2ptUXNKeXJhT1Y0K0Y2WUkyMllsQk1q?=
 =?utf-8?B?ZFBKOVFFdjE4czc1OGhFcVJtQTZwdXF1U3BnMm5PSDhTWWRDaXZDMFNvSVU1?=
 =?utf-8?B?Q3JKSzg1bzNDQ05JTC82VFloSzY3Qm9Eb1BDNzkwU3l3S1pNZTlaSzdObUpI?=
 =?utf-8?B?RWR0NzlzWlFsRmptVzJubU5EWmxuaytRREVGTWFNd1pkV25wTHhTcDQrb1hq?=
 =?utf-8?B?anhxTjRabXEyWEsrN2ZiS2FqNkVVU0NMQmg0MFl0VEdrOGx0Y2JxakZ5OU5L?=
 =?utf-8?B?WFE1SXppYld0YkxhNDBmOXo5SWk2R2F6UG0zWWIxYjRsVlNrUDU0S2pPT1Rq?=
 =?utf-8?B?UlorWWhXRldhMkRrVFpFRVMwMzNQcmxJQkpycEdCMUR5MGhvNzBlKy9sNS9E?=
 =?utf-8?B?TkRXb0E3a3JCZmdwb3liMHVzUEFEMmtvUVlYMDBNcDFoak1KaWN0bDRIVEJw?=
 =?utf-8?B?NXBnMDNQNTVIdENOTVhvQjBLRWJDQ3ZOVWVwV3FNNjFiMUNhNEhDRkpDanlO?=
 =?utf-8?B?TGlicnlwRVdtQVJrbm5oVm9CV2lxUXNrWjhLSVpnQmZZQmI0NER6Y29abDVu?=
 =?utf-8?B?Nkh6eXZKaGZJaU5QOXk2Mjd1TDArZjNPWkZmejZ2MUYzbEc4aGN1eG1mV1NL?=
 =?utf-8?B?UENFYUZyeU5pSlJIRVM4V1VWNmQ1NWc4VC9jVUZJVXR4SitBbDhoRUIwV0Q5?=
 =?utf-8?B?aGlNWlJEMGZlUnRraVI3YnRLYTRnL3krbjlKOTZxbGVkd09KblllbVpueC9w?=
 =?utf-8?B?Z1dMWHU5TFdpaVlsQUVaNGhTY3RKajBxeFAraVhoSjJZRzVxTGJoSmtGcDly?=
 =?utf-8?B?d083RFJLaFY4aGZHUlVZV3JLU041K2IrQTBFSG41RDRwblZST0ZmTEtSbGN2?=
 =?utf-8?B?aDJ1TzAyRUtjY0doVXdPUlBqMG5YU3VlNklyUDh6WkR5ckJ5bVdKOEQ2aytD?=
 =?utf-8?B?cXRIKy9OWlZuN0ZrTFdpVnhiZGtGUVJ4c0JiYjFKTXY1OW9DMW1hYndPcWhq?=
 =?utf-8?B?d1JodlBOclU4QkZXTnFBR0xKVnVNUlJXQWljdXBPQU41ZUpQSmtCTXJmWUV6?=
 =?utf-8?B?SWxkbnRzU0VmczZBOUtrOTRhUlAyNDBsYTRYLzV3MFZLT3NKNE9CSHkySG9Q?=
 =?utf-8?B?TER5WEQzRE02TDdqVk8xZkxkeFFjZXhkRWVNUzJYUlBZTGdZRm9oZHlQY2tR?=
 =?utf-8?Q?/GNdQ41tynkPL7X0Ki0dD1n30kqYa2Hm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ry9UM1FDZWVHK3lMdzM0RnJRUzV4aC9yaE1Mekp0N1dZY2hXZ1QycGE5a2VV?=
 =?utf-8?B?VGxiUzVldy9oTERDVzN4QkFGcVNqWCs4aGZPaS9TdFZjR2RWSFRpNTNKRUlD?=
 =?utf-8?B?TnUxU2oxK0dDaWVRY1BYcGlxTmVLaE5XWE8wemhaelBabnhuWjkrM3dvNUky?=
 =?utf-8?B?M2swUm01VzV2S1lpL2xqL05wdnppR3F1WXgwUGhZeVYyQUFwT3pHek5JTTU4?=
 =?utf-8?B?SUhGM1NVOUtPVXA4dWFyZUhnS0J6NUh0cGNoWEFURE05MFZwL0UzQmZVZ1RK?=
 =?utf-8?B?Z0FGY2FzRTl2ajMyaHNQSkIzZHdnc2hkWlc4dmZ4WHQ0NGZBdnVIL000N0lR?=
 =?utf-8?B?TngrdEVUa2RnUzVqNzVVcElKNC9CaGRMNUJhOGFOVFk0dXJ3YVF0VXRFSmZs?=
 =?utf-8?B?RmJnaUVYck5SbnRGb1QzTHVIeURuVk1XQUx6OHlRS3g2OUNrSkE1Wlo2WFJO?=
 =?utf-8?B?SnA4b2laUVEwdUwyTjhpeEJQaFloUDNJbTh5bjIrVVJmOG9GaEVzUjNCa1Fs?=
 =?utf-8?B?NXZ1VHAvbys2QmdLVUQvWGNDRHpOZGUreHpmV09CK2xzWTU5dDF2ZUdWQnpF?=
 =?utf-8?B?NHBXSkpxMWpEeFJ4VFFiYlVwd1JjRHNaNzRWRmVNbGQ1OU5WcTlzQkl6OS9R?=
 =?utf-8?B?dXhwYnhBdnllQUhURzhCaEh5ZkhYSnhlRllYR05YWkdQWWJmajVuNm9rWERh?=
 =?utf-8?B?T3dibW0rS3BucFlROWt1YXIvakV2YzVxaFVHZ25GaXBGd1Z5dkF5ZGVZdXBR?=
 =?utf-8?B?KzVxbHJhRmp5RXhaTVB2ZmlsRGNWUDNXOFpyT3VpaXhFY2p4K04wYkg1blRN?=
 =?utf-8?B?eEw3cFhVUmthOFZRYzFPditjU0tRV1hZeFE0Z3k2NmxPa1R6MUpHNkNBYjZv?=
 =?utf-8?B?K0IxRW9WcXd0RjhTYmlDZmp5YlRwN1EzNDhCdVoxVXJGcG9Id3dmNGs5bU9l?=
 =?utf-8?B?ZUNnODNqejhIQWNTbFRxcjRuc2lHMHBHODcyMXRuNytmV0hmVUVUNzN3NFY0?=
 =?utf-8?B?aHljODVKdWJQTjhZTWxoakRvQWxVU3R4dUUyRDBLSlk0ek9iSHlkUXRMWk02?=
 =?utf-8?B?R0lScVV0VHRNRFBYbFZ5MHhvTCtTVVl3Y3dhaWxUU2ttb3ZXbnlvN0V3VThm?=
 =?utf-8?B?MHRjL2RGSWNwTlNkTTRKckkrMm1WUnZ0UnhWWkowNnl4aGRRNlpsb3FtMUVt?=
 =?utf-8?B?dWJzb08rV1ZRa1IvTnRHYVM4cGJZMk5JRUY5T3Q0aVQ0UnVuSjh1ZlZvTHgw?=
 =?utf-8?B?WUpLbHdkWG1PZVJuVUt3MmZBK005UzhVWnlKMWxjRDkrUERDOEIwSURqZnEw?=
 =?utf-8?B?TkNUMnFYV3I3WnhsdGFBNGlRZlpERm0rL0t4ajJvdXk0dklkckZ5Z3VzL3Vh?=
 =?utf-8?B?YVR0ZmdhZndydldYWElWQmNiZmFIM2lJQkdKbVEwWUhmWklyNkNIOUZrMFY4?=
 =?utf-8?B?ZTJSTUgzaFJDNDRnc2w1dzVITzdsY3NaU1AzOEtZdnJJZ3gwTS8vTVBNWWdw?=
 =?utf-8?B?V2xBV2ZLYnFvbDFSWTc5dDl6Wmc4TS9FNE9lMDg0N2lyR1ZZZ21xTDVkWVYr?=
 =?utf-8?B?RXZoOU5JV2h6ZW5NMVM1aDh0bHdseXNabGt0OTVjNkEwcEVsdGc1ZkJJRklJ?=
 =?utf-8?B?NnVyOHIrUzYrVWlEV1dSNlZERnZmM3ZPOUcycXhvSjZNRUlKUHVWWW8xbmRJ?=
 =?utf-8?B?RERONzBqR2l0ZGdFMnE4aHNRd0FZVjR0V1Q3Snp5amkzSWZucno1VDFiT3BN?=
 =?utf-8?B?WG1RYWV2MGZTNndKZ1I2ekUyTlJ2ZTRwbVN4VUl3VUNzU05mVmNJYzFtbVZN?=
 =?utf-8?B?UDFHRWw0Z1BXWmxDL1d6V2s0dHlpWVVlZDIzZEROTHFnUlF5bFcvS1JBdnZk?=
 =?utf-8?B?SDhkbUd6ZWQrOW9ET1JEeTR1Z21RalIzK09FSEhGbUxKakF5SW53dHJLczFs?=
 =?utf-8?B?dGRieWxDYVFSNzdxZDRoNU9xSzZoUUlDSVp2Rnd2aCtmR2RKQ2dMbkNWc29U?=
 =?utf-8?B?cFh0VE5sZHg5WGRFdXV4RFkwaHhhdGxkU21ndUhkbFE1UURMUHFtK3dwbEhO?=
 =?utf-8?B?bUE3YzJUOUJVUVhWZVFrYmMwQ1RFUG5WakluSkN5Uk1oNkMxdXhqVmxPVnhP?=
 =?utf-8?B?ZXdEWDMxaUZGYVBZUi8zSCtxb3JxT3cwNE5SaGhXYjRTdnJsdGNyWGdmVisw?=
 =?utf-8?B?c3o5cUVjaXZKcEhkL1Z1KzRISHgycWY2MSs1ZzZYYlRkWmVJRUl6R2JEendv?=
 =?utf-8?B?UG5YckJtR2pETkdiRTZ3NmNUT2h4VjhQN20zV2drdE1YYllYNjJ5azlOekIz?=
 =?utf-8?B?cDFsU2NKejF4cGJ2T3M2a0I5RXppeERLQ0RpbkRIdHFrcUxmZm1ZQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3607b8f6-42fc-4b54-e20b-08de4e0547dc
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 15:56:12.2204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+3AU2iFjnI4pkM/6aA7Z0g3Hlz4I/oxBvNkz1HH3nooV8dPz1Rqb1Q1+7v2VRXY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6974

On 1/4/26 02:42, Ming Lei wrote:
> On Thu, Dec 04, 2025 at 02:10:25PM +0100, Christoph Hellwig wrote:
>> On Thu, Dec 04, 2025 at 12:09:46PM +0100, Christian König wrote:
>>>> I find the naming pretty confusing a well.  But what this does is to
>>>> tell the file system/driver that it should expect a future
>>>> read_iter/write_iter operation that takes data from / puts data into
>>>> the dmabuf passed to this operation.
>>>
>>> That explanation makes much more sense.
>>>
>>> The remaining question is why does the underlying file system / driver
>>> needs to know that it will get addresses from a DMA-buf?
>>
>> This eventually ends up calling dma_buf_dynamic_attach and provides
>> a way to find the dma_buf_attachment later in the I/O path.
> 
> Maybe it can be named as ->dma_buf_attach()?  For wiring dma-buf and the
> importer side(nvme).

Yeah that would make it much more cleaner.

Also some higher level documentation would certainly help.

> But I am wondering why not make it as one subsystem interface, such as nvme
> ioctl, then the whole implementation can be simplified a lot. It is reasonable
> because subsystem is exactly the side for consuming/importing the dma-buf.

Yeah that it might be better if it's more nvme specific came to me as well.

Regards,
Christian.

>  
> 
> Thanks, 
> Ming
> 


