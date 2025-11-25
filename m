Return-Path: <io-uring+bounces-10790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AAC24C8561B
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 15:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 713AF4E87AC
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 14:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC9B325701;
	Tue, 25 Nov 2025 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jEE/H3ZN"
X-Original-To: io-uring@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012038.outbound.protection.outlook.com [40.107.200.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1507251791;
	Tue, 25 Nov 2025 14:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080482; cv=fail; b=Kgvde663ylxaUSwE7J7f1SDE0qlYrreTCXlbNDhtnsDEwZgo/650iNlDrYXjXoglSONxaDHelXcWh6KfcQOI598M6qjh8hp5ciyOOv2Gvn7h0b9bmTKLi9WPHFrKgPhSvJpQrr+jJ2acjCKlTQUTLX8zamB0fZGH8eYBTBWTZcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080482; c=relaxed/simple;
	bh=NDuJaKhJVP7UOzc0GugxETW1GR7hhWtDfYp4A2/xIn0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GSnvBGdb6sPBjj4UwdrabNt1i6RwPpHZof9w36684pdRncHBSRNiNhfZAo/FJejuBQF6/NvJu6onR3D9+pDxT+nMvUzmTSbMcGRADduCF8aP+I+wxcofj/yPpMTiPe4+ij9ypr6j3Q9AF52LA28ydWATDntL6ElDFod7Tuo556M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jEE/H3ZN; arc=fail smtp.client-ip=40.107.200.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8IWdS7D1z393SIIUawlLp61Jep2pDHkpSxBgcN4fKpYqd8/f7YF8bpeFyLQjAowSnpQ/wqcA3Amty9INK/6cqZvVJlWX+m1kP4X651MOR6qaINLEtx8zR0I8s42R2M2xg7aZyR/6DLA4PFgid+CnT/AlapKzNQrrWWR32mXXR3P2uLWv9TsGSO/Y0Lg+tNnGEpXtXbg397WMU1cztZhrltDzi2uOyuLn3LuYgVEje8d404ZO0OdNI81u0pdwkhfIRxTXbLYKtTSW8/f1Z2riQDkyXxSKlFVFikb7H5O1R8QmHiYZZsTHZNmvihHfSp9iJpDh9J6CHKi4y+eA3z5cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=36P11SchtSlHOV7zYur3o47CDU2LEDK+lg7mc0Eornk=;
 b=oxvb8z0uZUXTQsT08Ly0dbG+lky6RIbuy6YhZmBWpKDMFOTLFyucqYcpbbUGZ+TdPH+klSVcTauiUXu++QIFPdP8TeMOngu8w/Tp1xXMcuiAkUMVGbsuJKtYyybpfGR+9DQUqX0VgzPJdWqwsSBmYmHj81JknEpgnaTHNqFoB4k2Kw67C4wIRV/vInTiHYB3KmudH268t/aZe1hnDTWJhxg45uDc1RcGCzOkK3PqD8qnRD7nFjgjrf9kIMdzTgz466Vh0mq28KDp2lS2V9foVdXWW53fR6K7E5m9Ja4Wt4M2I7BU4ZLs/+jIKEZpGUJGj5zl0euH9fRt0E7ZjMGQQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36P11SchtSlHOV7zYur3o47CDU2LEDK+lg7mc0Eornk=;
 b=jEE/H3ZNeyIc/P3Pd9T7YQAf98ZVG29f/d8f8LTSaIdfFNE2HlWjzWYCNtoRzrUxR7ExmtTyC02dPFgZIAz9vCUw7GhnMWSoBTiQ2nHavgnabtG4vz3nGHi9khfN2nio9GiNtoAD52Hh65QyihoTMUT/xN3kpPGF12DN4T5Mwec=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CY5PR12MB6033.namprd12.prod.outlook.com (2603:10b6:930:2f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Tue, 25 Nov
 2025 14:21:16 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9366.009; Tue, 25 Nov 2025
 14:21:15 +0000
Message-ID: <0d0d2a6a-a90c-409c-8d60-b17bad32af94@amd.com>
Date: Tue, 25 Nov 2025 15:21:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 00/11] Add dmabuf read/write via io_uring
To: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org
Cc: Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <fd10fe48-f278-4ed0-b96b-c4f5a91b7f95@amd.com>
 <905ff009-0e02-4a5b-aa8d-236bfc1a404e@gmail.com>
 <53be1078-4d67-470f-b1af-1d9ac985fbe2@amd.com>
 <a80a1e7d-e387-448f-8095-0aa22a07af17@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <a80a1e7d-e387-448f-8095-0aa22a07af17@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::7) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CY5PR12MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a7ac453-0888-4eab-5fea-08de2c2de4d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M2g0eWMvTy9EbnJudTljaVk0QlA5S0FwdGY5WSsrRFpnQjBLUVRUMzR1Rm0y?=
 =?utf-8?B?MEw1R0daZjR3bXBmTmdHRmRBMFpScjI5cVNRWW9rb2pZbTU4OE94dVFobDUz?=
 =?utf-8?B?bGpxMjVac0xUK2NVQTljd1M0b1ZNUVkrWTdjdXZwY2c4MjlCTDBjZHQ0c1ll?=
 =?utf-8?B?dW9DWnY4Wmx4U0lKSGZIRlhKRjRjcG1GSFB4N1F2ZlJwcnZVSXMrNllXUTBj?=
 =?utf-8?B?TFRreG1jelpEalhvTnFFNERoaStjeXFGL0QxTmxjTzVya2tkaUgySWwvS05N?=
 =?utf-8?B?TVZsRy9IWXJpT29SeDNXc1cyQkZkbVBqTCtvbVNpNGEwRllPNVFGdE1UQmI1?=
 =?utf-8?B?L21keGxBZThpcVhYN2lsNXA0bjh5QlhSMFl0SkR6cWFEUFgrTFRZMGphdEY5?=
 =?utf-8?B?Z1RGV0JKMCtpSWU3TGxPeGpEWTlBWHNjeW5VK2dQTXA5R2NnYW5zOEkxZXo1?=
 =?utf-8?B?ME5OaEoybi91anlUaUJCc0JhWnFVM3Q0QkFsRVVHcEZ0SGV4dFg0Y0V3UXE2?=
 =?utf-8?B?OFVEVlVERldrczl5YUdCRGFiTm1PNHZXcjJiNnBEL1BxQWlsc2RtaDFNdUtk?=
 =?utf-8?B?SHd6NEZXTHZVR0hCbjE0Vm9yVjk4KzhBdG03R2tveHR0aXR2S2xZTXpUbmZD?=
 =?utf-8?B?eDMzekEwV1NmbVZJeWluWDA4eDNTN005TlNCc0JoNVRZbmhzSmdFeWxtWWpv?=
 =?utf-8?B?R0xqY2ZpbTg0ZnBVZTN3MGVYR3ZzK0JXZDA5Ylg5b21abDdyU0hkS0RlQUhW?=
 =?utf-8?B?eDJPZnVBeHViRVJYRFZabU5yU0lrK0dxeEQ1dGR0dlpWVk95TnUxOGQyMkov?=
 =?utf-8?B?dkt2QXZsM3FSbS9BZ204R29VU3pNUnFSaVB1Wlg4T3lTTkJCUkVWSEs3eDVy?=
 =?utf-8?B?SGh2TUtycUplcGVabzc5MHhFTk9KdWYydGkxRGd4UVVMWXQ1MmtFaGxRUmRy?=
 =?utf-8?B?RFZ3R0VhR3grMWtLU0wrcmhsU2xQTVBHMDEzTlN3R09ZdFUyaTJZb3dxM1cy?=
 =?utf-8?B?Z0pZNC9qcUsvcmVNVW9vV0VwQ1ptanFhWVJuNDhYdXQxb0NzRWRHam91blJY?=
 =?utf-8?B?TjhTd2ZRYUIyeXhVVTJMdVNmbFAwc3hFSCtsVHE1YW1QaWN1ZzUwcFFIcTJ0?=
 =?utf-8?B?blVDM0VjVmdpRUVCQjNHbVZiZnZnTTJnVzJ6NFZ5OCtrREhRa1RXaEQ3Y3Ny?=
 =?utf-8?B?TVJvckpkQm96S1pwdExhMkdlWGZmcStpVUkwQWNHeHl4d2VYMGZBRnlKb0Fp?=
 =?utf-8?B?ckF1SHhvZHhta2ZYdHJuT0JQZUd5WXJaa0hKQ2JsM3AzWHdmdndOdWFxK2FE?=
 =?utf-8?B?RWR6WEFuY3p1a0l0WklITnB0bFdDbVc1K0YrN1NyV3Z1ZXIvd0RCZmFvbUVU?=
 =?utf-8?B?NEIrS0ErWG1NMEhnaDRPc2MzbXFKcXozSjVubTlHMTBGOGR1MHc0YkZkN1g2?=
 =?utf-8?B?SVlyWkNzVkFyTnVBdUErcVQzNXNOY3REUE12SHE0Sy81YldPeFBscFVGQUsz?=
 =?utf-8?B?aC9hcitzYkI0SWowSkRkMnpnZGZXck1lM3h1VnJyWU9nYWNjVFYvUndaSlp4?=
 =?utf-8?B?c1lZOWt2S3VZeGVmU1Jnam51UFdiazcrWGJLUnE5aWdEQUxHMEtsMXorWENX?=
 =?utf-8?B?ZlZZbHdMNTZpL3VVWnZsbUNPMG9qRUFkL3VKQ0c3bStGanViRUtQY1hSbnZR?=
 =?utf-8?B?Wk1JYnB0NWlST2pDSVpta2hSN2JtRjY2WlY2RG92VU9xVEdoSkZtMzhFd2ZX?=
 =?utf-8?B?RDVFUGxjbnZmRnJSa1hHUis2Ny9MNFVTNWIxL1N4RHZ3TnRxYjR0NVptM1dB?=
 =?utf-8?B?T2dLMVpmWTJvUUh4UHBCcklrY1M2MWZVVXRsU1FnRkkydnJpa1hqWmNUSHNi?=
 =?utf-8?B?ZVFGUFlGa2lKZ1ZzaTA3RHJES2RvNUNSZmVOTjFhUlE4ZmFxSkRrUHpnYklX?=
 =?utf-8?B?ZG9OTEpvS2pwdVl6L3QvTEh2bFk5TGxIUnhKTVc5WFo4MmFDWjJFeGV5cG5M?=
 =?utf-8?B?OEh3YVg1N1BnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlI3Nng3YXFQNk5iY1lIOVhETGxIR2pNandvU2ZNTFA4R08zem9kOE9PREcy?=
 =?utf-8?B?b1ZMeWZhdWpNbStwVE9OYkxMcDVlc0gxdnFOQjFvNjNiTVp5alhqZmV4emR6?=
 =?utf-8?B?Tyt5YVZycmYxcFVwcFh3UUJ0SjUwOHdMTFlFTURWWWxxTmRUL0F3M1FnUmN6?=
 =?utf-8?B?UWorRFNveUsybXU2RkJRdkJXelkwbldDbTc5NUp1OXJJKzdLTExIdU1GYmV4?=
 =?utf-8?B?OWJsRG5pRHJndGg1N2hQRUlkdXpEc0JaZHdhRmdOSjgyVHdFd3lJbU5OVytr?=
 =?utf-8?B?RU5nQlE4OTIvcTk5dHgxWXhrV1V5elRJYm12aDNKRmI0VlcrcmZPeWJLL2FZ?=
 =?utf-8?B?ZXBPYy9JQ1Y1UFVxYjc3OWJpWTh4ZnN2NlZyaXBVOTRNVHBpTC9HL3JOMkY0?=
 =?utf-8?B?VURXNVVyUjB2Qjg2RTd1eHpKaDIzSlZCN2sxR21jVVZ5Y0NtcFloeXo1L1l6?=
 =?utf-8?B?VlFYaC96OHRQYUhLS0ZjV0Y5a0RPbFRoZ2lwSGlzTkFzc2pxejY4T1A0UmRu?=
 =?utf-8?B?ZHdDaVJUUUp1eE56K1BCeUNMb3Mrb0JkVGZJS081UFdxSlgrY2dkZW8xOHp5?=
 =?utf-8?B?VHhoS0lHRDd2UGtqeWZvelZOSldTNldWME9qK0xpTWx2YVd4OVUvbW9JeVVj?=
 =?utf-8?B?MXhVZkZPeDh3d0l0Q3Y3cVhsdFluWENxd1J5UXhqbjlDNkpQMTFkcm1mR0lq?=
 =?utf-8?B?b2lxdjJkWkJzeHp4TENyYTZIcG9Pemg0UkE5SjFXRklOdFhuUVgxVEpmZ2Ev?=
 =?utf-8?B?YVZQeDlzRUFTSmFpRDZYOFJPZ00yT1VOUnh4NXl2Y3dLc0IvZXNOL1FHZXNG?=
 =?utf-8?B?YVhsNTRXSDA3OCtISG50S0g1d2JLSXU0OEVIVUFLVEVQeHJsT2dCQmxxYVhG?=
 =?utf-8?B?bDdlSE1DL1JDYUJIdHk2T0JUdGhZbHBPbnBBbm1YdXFHYzUySkhNYmQ5Ukds?=
 =?utf-8?B?UDFDU1B1VlZ6cUY4b2VKcytWTlYrcC92SFdqM1Y2dzlwWjBKZitNZ1lBRzg5?=
 =?utf-8?B?NnVkNEFSYTBBdFFxOTRtMjRpTzY2bjVWaWVYNUVRMmxUMkNQQWI3MVFqK0FJ?=
 =?utf-8?B?Y2RvRng1WjZQYjRIUWdOK3ZYQzUxZjFuY1JGYXN0L0lETldwNG9WV2d6QS8x?=
 =?utf-8?B?RkxmdnF0NE5ZUWlLaVZnMEZweWRQbFE2TUM5dTgrY2JlN3k5c1FudlJveUJp?=
 =?utf-8?B?MmtmVVpGSFBoN0pjWVM4QmN1R09mb2Q1aWxpWnFaTkNIYm5YckNUMXN3ZWJE?=
 =?utf-8?B?RFRhZ3dBOUJrZHVHS243TWlROHhOdktjRkZWMmMyRUVFelZ3bGZzZU9oTG5n?=
 =?utf-8?B?N2NCWlZOVDFvbVhacWF5aU5mOFBmcTYyT2ZqWndBYnAxeTlDNkJWb2Z5Z2VQ?=
 =?utf-8?B?alppemFsSmMzU3RSQkNwdVMyMVJzVWxEYUd0M2tjbm1lM0hiTTZjQy8zdW5K?=
 =?utf-8?B?K0NRVVFkTDY1aFVqSk5LOW9MR0ZaSE9VZ0JaYkJqUHd6VzZXVzBKSXhCVTVt?=
 =?utf-8?B?alBweGc4dXFMbGNHTHpiMXE5YlZpWjZ6SExOdFh0VS9yTFUwKzBJL25OVllq?=
 =?utf-8?B?bkR0cUtsak1oSVhaMUUxZkJVQUh5ZElma1Fmc2FFMDAzRFJ2QXloVXhiVHcz?=
 =?utf-8?B?TlkwVDhLdldHWDhkNm9iV2xHSFJuWEJVeGh0bGRLMzhXbjB2U2xUU0NGcnN4?=
 =?utf-8?B?cVkxNFNFOTVJeWR5TXhYQUtmYmp0aUFaRW5aTlFBK2tDd2NtWUR1MWl2eks3?=
 =?utf-8?B?TUo0SzdTTDZtcjFra1IwTzZQRUVTeGJLMTZzbWZSdWgrTit4bXBoTGNhbFlD?=
 =?utf-8?B?WjFRZnRqUG1jLzY1elFGZjM5M1Z2ZUthUWdQOFlDbS9PZ29aLzRyWERxOC8y?=
 =?utf-8?B?eFBsUjJsbHJqZmpJSUwxUkk4UFZGelk2eGdGdXArUDA0bVVuUkp3THhkbk1I?=
 =?utf-8?B?K2ZwK2p6SHN2QXkwcTVYcWdZL0tpcGs4WXVDNmFJb3NDUzYzY3dVTkR5MXlt?=
 =?utf-8?B?a0IvU29vekoxblh0VEc0cGpqdTI3enBNQS9BZVhXYlN4ZTNvL1NhTXRlZnA4?=
 =?utf-8?B?dEdJbHYrS0VBT1czMXFsTmZkTTY5czJLRzRsUVk5SkhCa3o0bitmVEE5NTFr?=
 =?utf-8?Q?40hHZbeq6tDx9bzVZ8ve9H1Gc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a7ac453-0888-4eab-5fea-08de2c2de4d5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 14:21:15.8810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ilSXVNQYVonfkvo8lDQ7Sh2BytcQTUXmuRbB251iTaNLHXVIVzwJtuz+0pZyO/l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6033

On 11/25/25 14:52, Pavel Begunkov wrote:
> On 11/24/25 14:17, Christian König wrote:
>> On 11/24/25 12:30, Pavel Begunkov wrote:
>>> On 11/24/25 10:33, Christian König wrote:
>>>> On 11/23/25 23:51, Pavel Begunkov wrote:
>>>>> Picking up the work on supporting dmabuf in the read/write path.
>>>>
>>>> IIRC that work was completely stopped because it violated core dma_fence and DMA-buf rules and after some private discussion was considered not doable in general.
>>>>
>>>> Or am I mixing something up here?
>>>
>>> The time gap is purely due to me being busy. I wasn't CC'ed to those private
>>> discussions you mentioned, but the v1 feedback was to use dynamic attachments
>>> and avoid passing dma address arrays directly.
>>>
>>> https://lore.kernel.org/all/cover.1751035820.git.asml.silence@gmail.com/
>>>
>>> I'm lost on what part is not doable. Can you elaborate on the core
>>> dma-fence dma-buf rules?
>>
>> I most likely mixed that up, in other words that was a different discussion.
>>
>> When you use dma_fences to indicate async completion of events you need to be super duper careful that you only do this for in flight events, have the fence creation in the right order etc...
> 
> I'm curious, what can happen if there is new IO using a
> move_notify()ed mapping, but let's say it's guaranteed to complete
> strictly before dma_buf_unmap_attachment() and the fence is signaled?
> Is there some loss of data or corruption that can happen?

The problem is that you can't guarantee that because you run into deadlocks.

As soon as a dma_fence() is created and published by calling add_fence it can be memory management loops back and depends on that fence.

So you actually can't issue any new IO which might block the unmap operation.

> 
> sg_table = map_attach()         |
> move_notify()                   |
>   -> add_fence(fence)           |
>                                 | issue_IO(sg_table)
>                                 | // IO completed
> unmap_attachment(sg_table)      |
> signal_fence(fence)             |
> 
>> For example once the fence is created you can't make any memory allocations any more, that's why we have this dance of reserving fence slots, creating the fence and then adding it.
> 
> Looks I have some terminology gap here. By "memory allocations" you
> don't mean kmalloc, right? I assume it's about new users of the
> mapping.

kmalloc() as well as get_free_page() is exactly what is meant here.

You can't make any memory allocation any more after creating/publishing a dma_fence.

The usually flow is the following:

1. Lock dma_resv object
2. Prepare I/O operation, make all memory allocations etc...
3. Allocate dma_fence object
4. Push I/O operation to the HW, making sure that you don't allocate memory any more.
5. Call dma_resv_add_fence(with fence allocate in #3).
6. Unlock dma_resv object

If you stride from that you most likely end up in a deadlock sooner or later.

Regards,
Christian.

>>>> Since I don't see any dma_fence implementation at all that might actually be the case.
>>>
>>> See Patch 5, struct blk_mq_dma_fence. It's used in the move_notify
>>> callback and is signaled when all inflight IO using the current
>>> mapping are complete. All new IO requests will try to recreate the
>>> mapping, and hence potentially wait with dma_resv_wait_timeout().
>>
>> Without looking at the code that approach sounds more or less correct to me.
>>
>>>> On the other hand we have direct I/O from DMA-buf working for quite a while, just not upstream and without io_uring support.
>>>
>>> Have any reference?
>>
>> There is a WIP feature in AMDs GPU driver package for ROCm.
>>
>> But that can't be used as general purpose DMA-buf approach, because it makes use of internal knowledge about how the GPU driver is using the backing store.
> 
> Got it
> 
>> BTW when you use DMA addresses from DMA-buf always keep in mind that this memory can be written by others at the same time, e.g. you can't do things like compute a CRC first, then write to backing store and finally compare CRC.
> 
> Right. The direct IO path also works with user pages, so the
> constraints are similar in this regard.
> 


