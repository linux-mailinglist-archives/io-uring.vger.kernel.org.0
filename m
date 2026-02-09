Return-Path: <io-uring+bounces-12104-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNcHOFXpiWmdDwAAu9opvQ
	(envelope-from <io-uring+bounces-12104-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 15:04:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 821B4110044
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 15:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3201E302E92A
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 14:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 779C737754A;
	Mon,  9 Feb 2026 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uN0ILIa6"
X-Original-To: io-uring@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010062.outbound.protection.outlook.com [52.101.61.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A98C1BC2A;
	Mon,  9 Feb 2026 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770645725; cv=fail; b=T6yQq1kXGXj3dxCGbf8ofcbKyU+fkg0WTszEIAD4/k0v8xPHjOM3dNSA6zVqLimINqlCL0RTPiSuoi2GjbUZuJ7eHQW+TpDipAWsC8K2xLUWnd7MCY1kJnhgQymMT0UfquXZnb8z1yViOOIWTPuhYo3Y60bYcOxzZ+sSHPxhljo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770645725; c=relaxed/simple;
	bh=5D0VdywClXUCs2OTMa+SdILdMHKu0XMkfWINE+XYMCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Esuhcw2Tq6+MbKhXcu6SDK8ZlVPT8A9BaUM7c3PZ5HTpbTQxFBYKDhdlqDqOx14qfBECzJjp/60DDih8A9NsgEN1xngaTqqYucWDneTEVMe4KlYgCBeVLAdbsUNXw5uwlLP4VAE5wc4/DRtTU1/qF/s2u8EbIXdNavdopZkdU4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uN0ILIa6; arc=fail smtp.client-ip=52.101.61.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SROdG6JjscUca2fk9y+wekzjs0Km9qtdjvrW+mO8/KhWhP1OcBDd+diG2mKxTYsfIumkiqYO3QFt+W9LGkv/cz/dDXwypWxynoTfzHeCNFuDdNaZPE6czX+kOxIzc0r1h444Dj+/Htlzr9NOG2xQZV8qIJqRbw4YvVcXVXDvISocwBJERICj8uqXuX72+5Q9O5B5gXn0YCT75Q8IKpBBTdXo+8cnrZPfu22VTcmSQ6oPADbRl4i4EcgIuI1zxG82EELgjX/WppNzlJvY3zJCxaokcfoHnAKnOJiKehomE0+GIwBW2Yg/Mzjvb2E9ETr+U1moI9DV5tEgse6hRQkyJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/0fd6JT+ESLW7nFGEUAhPQTBi+DjRs4LWxdjiukDTw=;
 b=JIETeQy0L0CnwJcSmLzc0MMyPA4zzN8tc5pv7i4w1yfXW3ikwMi96/rka1acNtCPScyXXMo9L/zPN8eOQPpyO2Np8oouqLwAFDr3HZE35sAV8RDEAvmUQgRnXy/6RVauQlsM1QQrmoSvVxX9Mz5sV5V+zfYBR1fHSEKrOXuUxI5/C2bcZxTv+In+wAAyp611LthhIfdL7pgvDgejK/mLikL4E8zYBuYdM6xRpOCXify0kYT6kqJ93amvv+7VJwlnjuCfLPvYwOvTlAIa4Sz0UBshSNfkGEUT1owzhWmwg4wQt14w/VA2GOLte2TuamwStGmlNIFnppL6z3a0UHj8fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/0fd6JT+ESLW7nFGEUAhPQTBi+DjRs4LWxdjiukDTw=;
 b=uN0ILIa6jKgrOGX0zCROgc+uAouwL352veRYkkJlNFtYUa2uzIHZWZ/+m+K8o5cF5hQWaVQfvef7uQ+FP0vrwKgYvtwcH9rdaW8ycRY4Nk3us5ZtW//xnlKepHqDSe2Pk1P4zT8E9uOeStcg+eAGmhxl9pTRVhR8dl911+954KDjrpfS44zfR1R9L1+oFg7UzAcYNMOYZHr9DbuQIcSKBFZxF7TIQF0FNe4qtQoom+3aY96rTux3XTOWxzka9dWTf/KEZs7QGgIMXEJxKkjGsZz8JUD2eP4hLdhy+7k/eN5gpUKIwVHHAjgNxqYFpqEhRAXQyQKGESUSNYy/eZFNmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY8PR12MB7537.namprd12.prod.outlook.com (2603:10b6:930:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 14:02:00 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 14:01:59 +0000
Date: Mon, 9 Feb 2026 10:01:58 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
	io-uring <io-uring@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"Gohad, Tushar" <tushar.gohad@intel.com>,
	Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
Message-ID: <20260209140158.GB3076640@nvidia.com>
References: <20260205235647.GA4177530@nvidia.com>
 <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
 <20260206152041.GA1874040@nvidia.com>
 <df7fe4d7-ca28-408e-bed3-bd1fa23e7588@gmail.com>
 <20260206183756.GB1874040@nvidia.com>
 <4736af5c-4bf8-4e9b-8f82-4b89a75d2cdb@gmail.com>
 <20260209130607.GF1874040@nvidia.com>
 <6246cc2b-0d6e-4062-ac24-74c7148dc47d@amd.com>
 <20260209132417.GA3076640@nvidia.com>
 <9020b3cb-42e1-4c14-a748-c9a392d6f0be@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9020b3cb-42e1-4c14-a748-c9a392d6f0be@amd.com>
X-ClientProxiedBy: BL1PR13CA0242.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY8PR12MB7537:EE_
X-MS-Office365-Filtering-Correlation-Id: a1278acd-0cc3-4266-baf6-08de67e3caf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ak5mb3U2VzFWd0FWSzNRV09kZXlhcWRrbDJWNE9kTTBCbGh5bmFncHN4UVNG?=
 =?utf-8?B?L0krQW1SQmJyaEJhRzlkOVpzQ29LdXBlc0IwRnY0Zm9MWGVNVUZZOGJML2VV?=
 =?utf-8?B?S0NmUERac3BmMXpLM2ZxeGczbEwwNVpYRzVoZlNoT0pjRy9VeXFRUXdlZ1FL?=
 =?utf-8?B?dHFVVEgwNGxrSWVKZXZRMWpHNmIxdUU2VTVvQ0x2em5hRkIvUEhGYmRoZk5P?=
 =?utf-8?B?WTBiMkdndk1VMnZKU1hNNDFCVmFOOTNUc0FObjd2U25KVU9LMmh6RUdVeWkx?=
 =?utf-8?B?RC9lTkU5S2x1ZFg3dTFmcnV4eEFQRklFVkw3eWNGRTgyUlFqeDFjQjBYdEJC?=
 =?utf-8?B?Z0VURzlYcER2K2NpaDNybzVpbHVsaDdra3FzZWpWalEwTVE3d1k5ZUdBMXFW?=
 =?utf-8?B?aDJWTlFCL1JxbU1KREp0MU9MTmxXc1VUZ3RNcU10T3R2NHVYL3VuV2lneUpR?=
 =?utf-8?B?VTI3eUh3Y3lYd0c4S2VqRGRtazJXMDlkT2ZJUEx5TlJlOUdldzBsZUhWTmZs?=
 =?utf-8?B?TWtSV3ZRUFliTi94UWdGU2hmYjE5VGhRdS9xeUZBdFhyRjY0Vjg2aVhFa3hl?=
 =?utf-8?B?U2s1OU1VQVNFWDRPaDgvMGFNUC9iZ2VXVzFleTdEbUQwZ3V3M0xZL2QvaTdY?=
 =?utf-8?B?Z3FTalo1VjhXS2hTemFpVURXaWE1dGJLMmYrNDRsazI5MTNHdE8vNVlEaUZq?=
 =?utf-8?B?dytaY1ZCcGNnM1pINjk3L2NUMGNETkZBU3Q1bDVMOTJ6MWZQM0QyMEVQcHZF?=
 =?utf-8?B?VEdSVXJaNVFQSWUrUTZnQ2N5bWpUU1h3eTZoZHZmSS9COFNOTjZGZ0N1Yk5p?=
 =?utf-8?B?dUowbEN6UmcvaWxERndaeE1ObUNWZGExU2ZEaVBKeDdkRStISmJWMGd4RzBE?=
 =?utf-8?B?NDN1NUR0emtFcXVmR0NjNDFkUzVIMjdBZ211TFBEKzRJeTBiMFBJVmN0bTZ0?=
 =?utf-8?B?VUozS3p6cHE3aE5RZkxDUitCUmpEcVJFM3FTNlBzQ0xzZzBVYlRvU01DV0ZK?=
 =?utf-8?B?NlJ1cHRHKzRZTXI1cVhrQzJMR2YwdDVyeDQwZExzdVpTL3o1M3NXa0FTRldk?=
 =?utf-8?B?d0k3NzdHUG1NZ09YUkkxNnJ6UGNTYlZKNEVNTEhJd3g1VGl1eWREcE8zSERu?=
 =?utf-8?B?TUVnaTVRRG1NUmNFd1h2aDNhd3FpWkFtUy9hY1RMdFRZaklJNllhMHprcklB?=
 =?utf-8?B?OGRNQm5FQXd5VDlkaDcyRDB4cUVWbWt3cHVqeTRFaDUzZlk5dEZkK1hNOG9i?=
 =?utf-8?B?dGFBNU5GcSthdThnREVHY2ExcU0wMDlYVTVEbzJWUTlPcW5YMU5xMkNjVFU3?=
 =?utf-8?B?MHU3WXpEYm0wM3luSElnNFYwdERXK05CcEovOXNBbmw3TnhxN05IT3JicDRD?=
 =?utf-8?B?ekR1OUZENGVhN1dVZVQwRHVGM2ltclVPOHVKSG8xd0ZocmJucEJvbW1qMkhq?=
 =?utf-8?B?Lys2aFpROGo2c2xibVlZT3JaYk9NYWpjY08yNzJ3WTE2WTNuS2ltSW9FeWNT?=
 =?utf-8?B?Nlh3VmcvM2FqUnIvRVRFRkZjUXR3UndDWVlrT3R5Z2FENjVNWXZrU1Z1SnVS?=
 =?utf-8?B?dGtzaFJILzVXL2FQVVFiMDF6aG45M0pHb1lPMUF2bzVRQWpybXBlSkl4Und5?=
 =?utf-8?B?eFFxc1hmQ3kxV0cwb1N3WGdmTVVyV0swNXVRWHRoTVUxRVoraGQxQXVacHBp?=
 =?utf-8?B?eldUaDlEb0xTNityek0xMVlwNUhzc3hkK09haExQK0hHV2kvM3dhZDJaMzJo?=
 =?utf-8?B?NXR2ZHNRc3NxaUZrYUdOTTBRT0puS2RPcW03RHdXS2tkbEphc1doaUNTUTJB?=
 =?utf-8?B?OHYzNDFrQTlneXAxVlE1NDlnMUJTRXlhc280S21qeUNEZ1M4ZzNiZURyaFM2?=
 =?utf-8?B?dFJ5bFVvR0gzQ0Y5R0hpRTQzczdZL3ZoWHh6TFhrbkpUKzRjTEh4RFRyWnZ3?=
 =?utf-8?B?UUFIc1BDQzh4ZDhFc1RPNDErK1hQUzY2OTRJZ25tODRyUmVya0JJbXZMK0hR?=
 =?utf-8?B?STd1djNPa2NiQzZtWVJWOWpNcFplZG9obzc0akpXRDlBRkZCYy9BRE00T2lE?=
 =?utf-8?B?d0hBaC9SS0loTGkwTHowSDBUZkM3aUo1L2NXQVFGZXg0dU5ucXNIaGJkOTg2?=
 =?utf-8?Q?Nqa8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejc3bXRBWkFBTmQySVNPc0NtZjhra0tMRUZidTFVTlZacmMxWnpFRmxxYkFQ?=
 =?utf-8?B?MkwyNURmSmkzWFdsaGVWbC80QWFiSlhRRnR6YncySE03bmYreUFrN0V3S0VV?=
 =?utf-8?B?enBBL01jWVlsU3pOVlBQZG03T3hnMkwza1FYQ0FkVWMxN3FwWXhuYVpTdnV3?=
 =?utf-8?B?ckpKeFRZSFVGVkU4T204Y1NMN2w2dzVnZTNXdlpBWk5Hd0tibUhqTGRSM0xa?=
 =?utf-8?B?YmtQdkFNTlJyZlhJNWhzQm0rMm95cDBFUkZCdGRGdFM3S0N0MlZpbmhybW4r?=
 =?utf-8?B?YkZGNElwSitNMXBWMkF2QTZpUEY5UHFHcldIbVQyaUl3TnhGWEd5NlVuOGQw?=
 =?utf-8?B?TFRWZUtBZHE4SlFLanZGK2NoUWxlSTg0N1ZVMnJ2UkVRVnVmbGlqTTcrV1pF?=
 =?utf-8?B?VVNESXp3TUx1cDE1QjQ2L3VjVDhjeTJnanNaNUJOa29UYnpmM0RGRU9OMEtN?=
 =?utf-8?B?MnU0SkVMVWg0VWRGbFZ1Y1N1UEoyVEg4WVlYR2hWRDBNMHVINmtManRnSjBt?=
 =?utf-8?B?UWRsUlk1U0V3Umh1THdnMU9ZVkF6OUlvemw1dURwWGNKVzVWN0NPb0YreHBt?=
 =?utf-8?B?SWRlZnZ1STZtejJmN0tlSi9CUUg5YnZaMURjQmJoNWJZYVAvTGZ0aitPSlpE?=
 =?utf-8?B?a0RwaFd2V0RIVmZMNXlEOGVNWm11cHJlL0VITjM3MlNZdENsOGxQd3haS1Zs?=
 =?utf-8?B?bWJ1elh2RHJVeFVROTlicWtOZEFYclIxMnRjVFRBRnJXQlpReDVNWlFyeTMz?=
 =?utf-8?B?WkNnN2dLTVJ3cFFoVzdZNVEyd3JydzFNSUx5Z3VOMnBLTktwRWVZL21wd3dQ?=
 =?utf-8?B?SDN0MXBzOVdRR3JzMjRFYUZDV1RHR3dsRncvcWVGeXdKbnlhUFpKUXRjblZR?=
 =?utf-8?B?YmtQaWpzWXQ0WHFnZndtUFlnL0ZBM1hVVlVwcDlRSFVDV2JyZjJVanZ6NmI4?=
 =?utf-8?B?R3UzU1B0UGdaY3c2SHZoOTh5YUpVMEo5WlE4ZWlXZFRIMS9NTW9jdnpBNmh2?=
 =?utf-8?B?L0Q4L09IcWVyN3djWVk3Rm02M3QrVXVJTjJqRXlLSGYwODVpTS9Ed1l0MVA2?=
 =?utf-8?B?L2RWMkNZellzVkNwdHIxejlBTUdKMktMMWhibWlLZUVHVUtzcUtZOVlObG13?=
 =?utf-8?B?dnRZRWxVV3FVendGb2g5TytLdWdCL0xlcTdyLzdwcVk2VDlxNHg1NVdHM0dw?=
 =?utf-8?B?czFUd3hkOWNBZjNMVzZqVlpvbGw2MCt4Y1NOOGxsWGNMYXhjeU0walRtY2NV?=
 =?utf-8?B?Z2FQNHcvQ0lTbmREREFCVUY1ZVdzOUVUV1FBbXRNNU9tU3RVeHhlN0xlL1J3?=
 =?utf-8?B?YzR6d0ppa1RydGpEOGgxNUdValRVdkkwYXE4cEJxbTFDb3lPRElVRDF2RXlm?=
 =?utf-8?B?MTlXelkzb2NCcDQxUDY4aXdwR3dKYjFNZmtkaGgyTlkzTFBDYW5CczUvZURO?=
 =?utf-8?B?aitIS0g3K3kxOVdUSXpsK3RQditBVHpuenpDSWxaMThvMGVyajRpa2lwaVZu?=
 =?utf-8?B?UnBtYlB0Tk8ranA5cFlZK3BIemtxZDVDU1JZZEh4SXk0M3Y3M3lKb3J2U0Fq?=
 =?utf-8?B?a0w4bzM1VGJqaXJiai9UWDZ5eTNacjNyYmM0TVJRVFRjM29HNVQrSDFoVmIz?=
 =?utf-8?B?QlVVQ3R1ZkF0Y204U0hjbGk0OUVKVzhLT0lyNTJsTnU2VS9jaE1TV1o0YlMx?=
 =?utf-8?B?dGk2VG9jZXZuL3FDQ3RGcFRrN1JoMEVKYnFBOEdpRmlWbGI4WmFxaXh2YlVu?=
 =?utf-8?B?YWFJU0JBb0x5aWoyK1lBSVkrV25IRU9QSm9OZU55UVV4SlpNQmhTSXZjMDZ4?=
 =?utf-8?B?R1BqRnpSTjVjUVhzSnpFNFR2Z09MNk56UllkRDBudUdyb2NYTE03c2dSL1Fw?=
 =?utf-8?B?c3lHdVRFNEtEUnFUV1owNkVJZkVzOHB0dzdWdUVXK281VVp5ZDJwNjUzR3BJ?=
 =?utf-8?B?QUg1NHE0Qnp3VFQwS3BZdW1TODh0NEQxR05CaEt1VWFaSytBUnpXSlFFRFRL?=
 =?utf-8?B?OVhucnVDTFhXM25lc1EzRnpGaUdkQXh5RFhHUmJGdjRxdGQ3ZzYyK0VMY3dq?=
 =?utf-8?B?SDY5VzlQNEI4MktENTNuT0RtVkVKNXlXeXN3MjcrYk9OT3RINnc4SkpiQ201?=
 =?utf-8?B?cUFlbUFINFlnaU1JSVQ0WHA0TjhYRW5lRk1ETEZmRFBtaUdURW05Mys2aHR1?=
 =?utf-8?B?Zm1sZnlKUURzWXg5RnR6Umhub0g4Vmk1QzBqUHFtcDVyLy9uLzVzRjRXTFV4?=
 =?utf-8?B?TVNOYTFkTU15QTZaZkhFQWJRVUhwUjJSRTErTmpxd3lkbW0xOGhZbGQ0RjNn?=
 =?utf-8?B?aitKWVhwYVRUSVk4bWVEWDc1TlFIYlU3THdiS3FEQmdYWGRiWnVhdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1278acd-0cc3-4266-baf6-08de67e3caf6
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 14:01:59.8062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: keIzf5aimOmzAOYX9IRiJrUK+KETSYMWhYOIbR5IBT/+g3eij/kd5TuLOe7JTytn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7537
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12104-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,lists.infradead.org,intel.com,lst.de,samsung.com,lists.linux-foundation.org];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,Nvidia.com:dkim]
X-Rspamd-Queue-Id: 821B4110044
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 02:55:26PM +0100, Christian König wrote:

> Yeah, that is basically what everybody currently does with out of tree code.

:\

> The problem is that this requires internal knowledge of the exported
> buffer and how the I/O path is using it.

Well here I am saying the buffer has a P2P struct page so that is all
you actually need to know. It just follows the existing proven path in
the IO stack.

> So to generalize this for upstreaming it would need something like a
> giant whitelist of exporter/importer combinations which are known to
> work together and not crash the kernel in surprising and hard to
> track down ways.

Well I think the mapping type proposal goes a long way toward dealing
wiht this problem. Let's shelve the discussion until after we discuss
that with patches.

> > Reworking the block stack to not rely on page is also a good path, but
> > probably alot harder. :\
> 
> Yeah, that would be really really nice to have and the latest
> patches for extending the struct file stuff actually looked quite
> promising.

Yeah, I thought the dma token through the IO stack looked very
interesting too. I hope it eventually succeeds!

Jason

