Return-Path: <io-uring+bounces-8634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1558EAFF210
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 21:54:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03740540590
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 19:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A802417D4;
	Wed,  9 Jul 2025 19:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xf53eLiu"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F0323E334;
	Wed,  9 Jul 2025 19:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752090870; cv=fail; b=K++0YAYqoxy32qvkuPX5XoHSwoNUmW5YTNd9L/C776a/lQ4MECGeZvMa4FiscMqG8yeCbcBrfBJrQ9LiMaiHyyiMU8Kw+3bC5Umjs8k+9WeZ+vnBgUkV/LrvVFgGx8P+TRR8waS5xgReb6KzuPwPvow/GCYI2a/EvPGzmGZKjOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752090870; c=relaxed/simple;
	bh=SIp4AS/Oxl1mFbMFcGkSgMILFQxgk1BoqVVRcgPT0oM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bbSfoClg9uRE0tXJYS+EvtGSgTMTIAeMnHVLgJJg8+sp+t8UyfsdahnKpX+oBu7Z9KsBZVeb5KriZPHi7kP5FvgiOgDIJ1P/MedgCXbI/JElpCqfqsDl5k9dUe/AD/NmV4kwt587Xg9iyBtVTnVH8avLqgiHO5A0YfG78VEki7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xf53eLiu; arc=fail smtp.client-ip=40.107.244.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a9JQbISRVW0h2+NGbNL8dB0HgV2+oKj/3vZUngLvdHtc8znAfWi72Yf3iNT7Cyx15YQiEP1951ykScQy0xSMcEONMsJxU/RYgHrg097K9dUp3T9N0GYGoECdUsZN5cWPWG3baaxYKJGxPm5tGJwx5iDh28Sk7u3ZbWjmrjbCYWycd8i1Q01alLZq5p29ZmJRGSrBttNzjddgNkQ5C2wlmgePGkDAIijfvPjCqGFX+itv9HFiK/cjku4cAiQOJdc7eZ10DYdhTYPGnqqJlUm3JFymcrO2berjDa5NukMJ9GZpBHrV2CGuJNn/ZF+/F/M4Qri6/WjE7cHrSMKYOCZD0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0oDzGjE+9VEeoHv0t7AYYwez0xEiknWnn4TRXFeRgbA=;
 b=YEgRcldB6UsVxvYVLFCYtSuCGSSKJ7qX+s9sWcUbImr0PPxd8IjZdy4AHoyR8usjr03kIfJmhNSURMw93JRkC4nagyZN0MtPg0o2oIUi8qbBW90Tjyb/qrXsE9/wYstUXchRtjPJl9INFGGMM3LIrNerE1hdemWnn8WdeKXST9dkkZk7j6GOaAKk5k/chNPM6IT5O64NnRvhnSuWenDXE22dzUDu6Dqe74HaY1RjHcDtmuMIveV4thXKKKKmgoF/NY+NUD96dUEJTb4p5ql6UIOfgfmwvqVxZ/nIWh+cal2JCxyHb2PERKpB859zAXxjx7zRH0notMMnoqZzSnxbTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oDzGjE+9VEeoHv0t7AYYwez0xEiknWnn4TRXFeRgbA=;
 b=Xf53eLiuETpnNQp61HS6y0KjToI/qObNoeuAUBcWnvy/cOFO7Fqi5s9XDij/IDqXDeenh/EjWn/dtanZmryflwdpsTFwqDubfnhKyMg2AzrHm170xoXE8Gv/s47v5EnAwW69RKs2Hs8DFZN7AOwEPJmT6qzSAgmRfkczljDIguyDJEggtP1G/kyijXhZrHp+6zFg9j6FuUUh9UYNVUBa+sKcvzKqpNg1Xco1V3ZfbBfJNm4zgsXO/uVjq1eJdSeQ57SSjFwvIm2n/8yHeHhaJeEWgJLn1svS+fPmVrb/ux7HZoM8zVh4BLuoOjjC1vQ3r6AjpxuC7H90S3zkd9L8OA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19)
 by CH2PR12MB4182.namprd12.prod.outlook.com (2603:10b6:610:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 19:54:25 +0000
Received: from IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c]) by IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c%6]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 19:54:24 +0000
Date: Wed, 9 Jul 2025 19:53:54 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Mina Almasry <almasrymina@google.com>
Cc: asml.silence@gmail.com, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Willem de Bruijn <willemb@google.com>, Kaiyuan Zhang <kaiyuanz@google.com>, cratiu@nvidia.com, 
	parav@nvidia.com, Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH net] net: Allow non parent devices to be used for ZC DMA
Message-ID: <bm4uszrqfszm5sgigrtmo2piowoaxzsprwxuezfze4lgbt22ki@rn2w2sncivv3>
References: <20250709124059.516095-2-dtatulea@nvidia.com>
 <CAHS8izNHXvtXF+Xftocvi+1E2hZ0v9FiTWBxaY7NWhemhPy-hQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHS8izNHXvtXF+Xftocvi+1E2hZ0v9FiTWBxaY7NWhemhPy-hQ@mail.gmail.com>
X-ClientProxiedBy: TLZP290CA0014.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::13) To IA1PR12MB9031.namprd12.prod.outlook.com
 (2603:10b6:208:3f9::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB9031:EE_|CH2PR12MB4182:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d9c0984-7742-4419-e9da-08ddbf226799
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnhWVzhNNm5heHJXUy9KV2tEMFlZV0E2dUZUZ3MzdjRON2w4KzNwbnBNc0RQ?=
 =?utf-8?B?N1ZtUGE2cWhmRlEySWhqM0orMGpaTkpDVVNMOEszTXMvK1NsTDc3NmhhUHI5?=
 =?utf-8?B?eS9BU0RxVlpIZndMWXhLNlZPZ0F4My9DRTloeHdpY3ZXcjNrYm0yMlJ1NWFr?=
 =?utf-8?B?Qmkrd05ISm9kbUxNZ3dFSStEZ3hmb1ZndUVmZ1EwTU9FbnVZUHFzVlNaVmZQ?=
 =?utf-8?B?UWo5MGdQS1BsckNzQnNNeVgzWmZtSFZ5RVJqWS9pclhHRlZENHA3dHFLT09r?=
 =?utf-8?B?dlJvd3hMRHRBakgrbDRvR0p1RWNaOVNHS0lRMGwxUEEvOWh3bFcyUitKWXZm?=
 =?utf-8?B?Y3Y4blluZE5QT0JWeUhNQitCM2xFaER2OEJDbk9yMjloN3RDZVo5aWkxOHQ2?=
 =?utf-8?B?S1RTNlFWZjBvR3lnSmZhNWVPbnVFNXMxMzVHNngzNWtjdWFIUXpLRXgwVXls?=
 =?utf-8?B?NVpHdzYwVjVNRk1Nb0lhSEw2K3c2bVIwbVVWcE11ZU1WWU5NR3JwNzBhcmFj?=
 =?utf-8?B?UXdrV0FMcjY5aSsySFBPU2p5VnZCbnV5Z2NWaHlLaHBtVUdvS0hFSkxYMXY4?=
 =?utf-8?B?dHVKaWlVK1lzL0s5OHZlSDY3dHR4dFl1S0lBNU5QREZsOC9NNElIYVByNW55?=
 =?utf-8?B?REEyTTFFVWY2enE0MmFneTUyM29JTThrR2IzY01wNnBnV2NhUHl0L2d5Qzh4?=
 =?utf-8?B?ZTlYaHYvNjVEcGtPVTRiNjhGUk5LTEN1N21DRVdQOXN0a01vZE1HeStPTXc4?=
 =?utf-8?B?QkE0bjMyQUYxRld0Nlg1WXdYN1FkZ0IrcjQzZ2tWc0srODl0Um4zSU5HRk1T?=
 =?utf-8?B?MkpkQWtNdVdSUnByczlCcjgwZVlRZUsrNk1XbFhjR0pvMkF4dVJDcUpZdUtM?=
 =?utf-8?B?S1M5dXVteUVMRFhYNnpOdFl6SGhBWGZDRVFNNjV3dUFtaGlUejEvdW82b0xN?=
 =?utf-8?B?aUd0SWhldnFvZ3JYU2VQUWhBakhDZ2duMVJJWlJxaWo0ektiTnV3aTVBWHRo?=
 =?utf-8?B?dm1QUHFBUExUUTY1RGNmMEpXajFZcDN0eFI2ZWVLd1lmaXpGR0RYVW8wdXY1?=
 =?utf-8?B?anRVcGNjVE9INFI3SnFzVVd6L1VzZFlSb2k1ek5yYmdWZDRPbTlyT1VWWEh6?=
 =?utf-8?B?OWhEeis2V0xrTS9WQjdOWGhOcFRoWC9RLzYrU3plVXlWMkJxYThvaE5BdERl?=
 =?utf-8?B?Y3pDWVhPMGtmZDA2S2J2eGtFd29ZYmdQK08vR2IzVzBlYVFEbWNkUktVcG9i?=
 =?utf-8?B?YXdOSHc2QVMxL2w2VHVWamZsV1JsUERNK21ZN2FTUUNkbmh4Tm5IemwxUFZv?=
 =?utf-8?B?TEhLWnBLc2RXRW9iQnVhRktna0F1amxHU3U4ZHBsSXRzcHNEcWVtU01xcm4x?=
 =?utf-8?B?VFNwNmJhdWxwcDBvZ1ZDQmwrK1Nab01VaE1hNXVUZkR4MW9GVHJLaHQ1MVF2?=
 =?utf-8?B?Wlh6SmZrUWlpSWZDemMrWXA5R2xBYzVoZFJBVzErTkNVY0VYSEJIMCtKb1kv?=
 =?utf-8?B?NHVxaktDbzBQNnVJWFc2WlR6WW9OL2Rnd2IycXN4ZnNxNTBBaHZtV2hIbktS?=
 =?utf-8?B?NXBtU0phSjRLZDcvcU04bkUwN1hGVXlua1lnTEpXWHpkc0VPdzErU01JZzUx?=
 =?utf-8?B?VzlSS0FyNlNQbSszazlacGx6R0pJcTNTWjl2UTFiSERNZU14bXQ5TCtjTDdC?=
 =?utf-8?B?aU5CL09vcUhwQlY3L3VUVWx4WGl4OUpya0RrVDFJdEV2cWsxYkUrMWxRSG9y?=
 =?utf-8?B?eFl6MXNoclpHeEVpdGdVdGhkell5TGQ2aERCeDIrQUg4c3FTMi9iOXduSnhu?=
 =?utf-8?B?OU1JZmwzcndqL3hnRWNycksySXgxVHlCaU9JQ1pYYzYrZENGeWtQWTBqL3lt?=
 =?utf-8?B?TkhBUndMRkU5TzFJaHpKUEJWcmUxR09ieURTOExpS1FUN2tkajFDL1JPdnFm?=
 =?utf-8?Q?oLwZB6sIs/A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB9031.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEpkMThpa244MUp4ZXNFdFZHMzZONlI4b0hQTkQvVE4vMXhPYVdDcy8rRTIv?=
 =?utf-8?B?dmI3M3B3ZjErQ29TMllkaUFUTHBoUEM0RXJIOXdRZzRRV3lvcU1xQWJ1bGZv?=
 =?utf-8?B?cURBekMzRUxpdVBQU0l3aEdocm1OVjM3bXl0UnRKTDdHeVo1NXpzcHl0UlJz?=
 =?utf-8?B?dHVzR1AySGJJYXJGT3dJLy9MNlIvMUlMN21WZkVZL2FyU1FHbENwUE9WaDlt?=
 =?utf-8?B?emczRTU1UStPRk5ZSVlaN3JCRGk0S01FaTcwVk45dmRIekJFTDRFaUJoZjE0?=
 =?utf-8?B?MzZtMjRxYTU0aEpMeFVhQmRpREcyY3FHcEs5OVhCdDUxVFIrZjFZaE9XTWVr?=
 =?utf-8?B?SHZESyt3ZkZLaisvbmROYmZUMDd6Rm1Yc0ZUM2dSVnNoTlRuQ0RWeXM4Ukg5?=
 =?utf-8?B?WkZFYjlrSmVoRGUzNGZYU0ZxbHoxVWtrckVON1E5WDRHeWwvYjBYUnY5cWZl?=
 =?utf-8?B?MjZ4WS9OTjNBWHJOSC8xanlISjVFMnFSa0xvWk5iVUpXWVpENHVGR0FyQmZM?=
 =?utf-8?B?L05zV1hCZHowZ3IzMHd1Uk4yMUswYVl5Z25HR2JMZG56dXVyUGRIVEc0K1k3?=
 =?utf-8?B?TGpmSWNpaktUU3dabURmUFI3OFVNMW1vaDl2MnFJbi9yaEpZeXBCdmhvd3NM?=
 =?utf-8?B?RUxwSkJwUnpKZ3lqQmtIeU1rZnliSUNLRkVoa2hMNHJKZjRDZHRQWjN6YzFF?=
 =?utf-8?B?b1Zpc2VhQ1E0TVovWHdRMWlURjJoQUVWOHBuRTJIeTR5c0JFSkpNbFhuOU1j?=
 =?utf-8?B?TDlGL3l5THFneVNFZVJDMGpTcmg0SS9DQkZIZFU5dEJkZ3hVR000Nm5xWXFY?=
 =?utf-8?B?WVRkaDJSKzBSSHM4dmZ6ZjNVT2NIbFdCa2hHVkUyU3BPbmNHVTBZYWNkNGZE?=
 =?utf-8?B?Zmw1dmtadlJrWjUzeVYxZndzQmtiaEdTdUtlb05RM1JoTytQQXZrTHUveDVI?=
 =?utf-8?B?ZFVsdlFreWZ3elRwWVdVb0xSQTF1a3ZSZURjTUNEWEs5RW1BeHpOdFlXYk5x?=
 =?utf-8?B?WWYrWnJpQitnNllHU1hzd3Z3OFk2aUNOb2k4SWVaS3QxeDk5N1YvcTNWakJU?=
 =?utf-8?B?Kzc0ckUxZ3NaNm03Q1BzZGpDbUlrU3hHS0JmNjlWVHRBR2tpNEhxSG1NRElE?=
 =?utf-8?B?YndzdTg5OEdONFF2M0pxdU5TMUVKK2NySTBaeWlEWkVRQXc0SnVGVkNvZkV6?=
 =?utf-8?B?VFpIb0hYQnJNWURZTHl5cHhlWTBnUEtRNFB5cExVTGg1VWZJQjdELzh5bmlr?=
 =?utf-8?B?c0tDS01JRU9TMFo2MlhSb1ZLUFNNdnVXdDlBTi8ySGZRakhyUVhzdGRzM1NB?=
 =?utf-8?B?czNFUndxb3gyTHkrS0RzK21pNmorNitRak1XUks3S1BuN2VPK1VtdFNFU2tM?=
 =?utf-8?B?WkJldUVCTm9HODJoK201QXV0cGlmYkprT1JaNHR5b01aSkJqbmJyNEkvYjFk?=
 =?utf-8?B?ekxXMHBiR1U5cFV4eS96Qm5rN0ZNOHcxREVYOHZhQkFxaC9YOFRqcVR2ZU9O?=
 =?utf-8?B?cENMejVhem9lcUNML09mZGFHR2J3Kzl2ZFg3WG8yb21CTGxHcUZyWWxvSWUv?=
 =?utf-8?B?VXBFOXBvaENaZFRsSHBPbThJSWs5VW9LODh6cm1iT3VEdlQ0TUY2ajVnQTQ5?=
 =?utf-8?B?NktCbU8xSC9OazRua0ZTVGRwbllVcFBMOVhrUzBkdWlMN0dGNUJuNUVSTkV4?=
 =?utf-8?B?cmpxVzhxZHByNEMwcWFQYTlOZllVaHltT0VXWXQ0QkdXN2U2Z3ZUNW9JdHV3?=
 =?utf-8?B?MCtnYmNlMGMrZlQvSmE1RDRjdmFYQ3ZWWjBub1FKcE5MM0NLcngweVNjWDdj?=
 =?utf-8?B?VlVKNEZNd1R0elJIOXpwMytWb1BrQkp1aEdhVGhBWWRWQ2NVM29JQ1FDS0o1?=
 =?utf-8?B?MXM5bDZyRzNjNTRicHByY3lBODkxRi9sUy9lV1pZNmhMZVlkVENycWF4WTI2?=
 =?utf-8?B?a2M1T2xKaElSVTVZTXl1NVhWMXVpRzdpN0xvc3E1eCtDYkdQdU5ORWJYd3VM?=
 =?utf-8?B?WFZYbW9kZnJ6N29sdVVmZmEwQjhNSUhvQTl0Q3pPYVU4VDBSYnF3QUJ1YmNT?=
 =?utf-8?B?MGtyeXA0cHFGbDJRNVZ0N1B4OHNpVjNCZ3VxUkhQN0FnR2h2MCtnZjdhbjlK?=
 =?utf-8?Q?RbIQIcnK4exbm5mlVUlEBYvwa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d9c0984-7742-4419-e9da-08ddbf226799
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB9031.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 19:54:24.7277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JOs1QywlkdYCUoURFeeaW4rsI3E0X+5aHrcOLMoeI1nusqtWrsWKRXTMemrXbA8brT23pKy54ibjKkJY/eXVeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4182

On Wed, Jul 09, 2025 at 12:29:22PM -0700, Mina Almasry wrote:
> On Wed, Jul 9, 2025 at 5:46 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
> >
> > For zerocopy (io_uring, devmem), there is an assumption that the
> > parent device can do DMA. However that is not always the case:
> > ScalableFunction devices have the DMA device in the grandparent.
> >
> > This patch adds a helper for getting the DMA device for a netdev from
> > its parent or grandparent if necessary. The NULL case is handled in the
> > callers.
> >
> > devmem and io_uring are updated accordingly to use this helper instead
> > of directly using the parent.
> >
> > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> > Fixes: 170aafe35cb9 ("netdev: support binding dma-buf to netdevice")
> 
> nit: This doesn't seem like a fix? The current code supports all
> devices that are not SF well enough, right? And in the case of SF
> devices, I expect net_devmem_bind_dmabuf() to fail gracefully as the
> dma mapping of a device that doesn't support it, I think, would fail
> gracefully. So to me this seems like an improvement rather than a bug
> fix.
>
dma_buf_map_attachment_unlocked() will return a sg_table with 0 nents.
That is graceful. However this will result in page_pools that will
always be returning errors further down the line which is very confusing
regarding the motives that caused it.

I am also fine to not make it a fix btw. Especially since the mlx5
devmem code was just accepted.

> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > ---
> > Changes in v1:
> > - Upgraded from RFC status.
> > - Dropped driver specific bits for generic solution.
> > - Implemented single patch as a fix as requested in RFC.
> > - Handling of multi-PF netdevs will be handled in a subsequent patch
> >   series.
> >
> > RFC: https://lore.kernel.org/all/20250702172433.1738947-2-dtatulea@nvidia.com/
> > ---
> >  include/linux/netdevice.h | 14 ++++++++++++++
> >  io_uring/zcrx.c           |  2 +-
> >  net/core/devmem.c         | 10 +++++++++-
> >  3 files changed, 24 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 5847c20994d3..1cbde7193c4d 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -5560,4 +5560,18 @@ extern struct net_device *blackhole_netdev;
> >                 atomic_long_add((VAL), &(DEV)->stats.__##FIELD)
> >  #define DEV_STATS_READ(DEV, FIELD) atomic_long_read(&(DEV)->stats.__##FIELD)
> >
> > +static inline struct device *netdev_get_dma_dev(const struct net_device *dev)
> > +{
> > +       struct device *dma_dev = dev->dev.parent;
> > +
> > +       if (!dma_dev)
> > +               return NULL;
> > +
> > +       /* Some devices (e.g. SFs) have the dma device as a grandparent. */
> > +       if (!dma_dev->dma_mask)
> 
> I was able to confirm that !dev->dma_mask means "this device doesn't
> support dma". Multiple existing places in the code seem to use this
> check.
>
Ack. That was my understanding as well.

> > +               dma_dev = dma_dev->parent;
> > +
> > +       return (dma_dev && dma_dev->dma_mask) ? dma_dev : NULL;
> 
> This may be a noob question, but are we sure that !dma_dev->dma_mask
> && dma_dev->parent->dma_mask != NULL means that the parent is the
> dma-device that we should use? I understand SF devices work that way
> but it's not immediately obvious to me that this is generically true.
>
This is what I gathered from Parav's answer.

> For example pavel came up with the case where for veth,
> netdev->dev.parent == NULL , I wonder if there are weird devices in
> the wild where netdev->dev.parent->dma_mask == NULL but that doesn't
> necessarily mean that the grandparent is the dma-device that we should
> use.
>
Yep.

> I guess to keep my long question short: what makes you think this is
> generically safe to do? Or is it not, but we think most devices behave
> this way and we're going to handle more edge cases in follow up
> patches?
>
It is just what we know so far about SFs. See end of mail.

> > +}
> > +
> >  #endif /* _LINUX_NETDEVICE_H */
> > diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> > index 797247a34cb7..93462e5b2207 100644
> > --- a/io_uring/zcrx.c
> > +++ b/io_uring/zcrx.c
> > @@ -584,7 +584,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
> >                 goto err;
> >         }
> >
> > -       ifq->dev = ifq->netdev->dev.parent;
> > +       ifq->dev = netdev_get_dma_dev(ifq->netdev);
> 
> nit: this hunk will not apply when backporting this to trees that only
> have the Fixes commit... which makes it more weird that this is
> considered a fix for that, but I'm fine either way.
>
Ouch, indeed. Should have thought of that.

Big picture view:
Maybe after all it is more generic to have queue ops that
can provide this info. For zcrx it is trivial (see below hunk).

For devmem I was thinking of calling netdev_queue_get_dma_dev()
for every bound queue (before the mapping) and return an error
only when we find different . It will make netdev_nl_bind_rx_doit()
a bit icky, but the idea is not complicated. What do you think?

---
diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index 6e835972abd1..04c69f39558d 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -127,6 +127,9 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  * @ndo_queue_stop:    Stop the RX queue at the specified index. The stopped
  *                     queue's memory is written at the specified address.
  *
+ * @ndo_queue_get_dma_dev: When set, the driver can provide the DMA device to
+ *                        be used for the given queue.
+ *
  * Note that @ndo_queue_mem_alloc and @ndo_queue_mem_free may be called while
  * the interface is closed. @ndo_queue_start and @ndo_queue_stop will only
  * be called for an interface which is open.
@@ -144,6 +147,8 @@ struct netdev_queue_mgmt_ops {
        int                     (*ndo_queue_stop)(struct net_device *dev,
                                                  void *per_queue_mem,
                                                  int idx);
+       struct device *         (*ndo_queue_get_dma_dev)(const struct net_device *dev,
+                                                        int idx);
 };
 
 /**
@@ -321,4 +326,15 @@ static inline void netif_subqueue_sent(const struct net_device *dev,
                                         get_desc, start_thrs);         \
        })
 
+static inline struct device *netdev_queue_get_dma_dev(const struct net_device *dev,
+                                                     int idx)
+{
+       const struct netdev_queue_mgmt_ops *qops = dev->queue_mgmt_ops;
+
+       if (qops && qops->ndo_queue_get_dma_dev)
+               return qops->ndo_queue_get_dma_dev(dev, idx);
+
+       return netdev_get_dma_dev(dev);
+}
+
 #endif
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 93462e5b2207..478693a6d325 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -12,6 +12,7 @@
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
 #include <net/netlink.h>
+#include <net/netdev_queues.h>
 #include <net/netdev_rx_queue.h>
 #include <net/tcp.h>
 #include <net/rps.h>
@@ -584,7 +585,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
                goto err;
        }
 
-       ifq->dev = netdev_get_dma_dev(ifq->netdev);
+       ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, reg.if_rxq);
        if (!ifq->dev) {
                ret = -EOPNOTSUPP;
                goto err;
---

Thanks,
Dragos

