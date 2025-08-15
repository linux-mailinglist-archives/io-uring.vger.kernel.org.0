Return-Path: <io-uring+bounces-8981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 628A3B28341
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 17:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66DC81CC855C
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 15:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044853093A5;
	Fri, 15 Aug 2025 15:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cu48Ruas"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A336A3090D3;
	Fri, 15 Aug 2025 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272932; cv=fail; b=JTC6kWn0Gao0lz21479pSlqYKYOBb9sTdnlfaeToUtiw9+LkgJflbg1ew30X2VuDiBFQjKjcutEi35F83qaBT3shIbADySYdYhegv1aY0TNADFwsTOJEcfIoa0wsyMz2A2QypFTTCrB7B6q7pa01PKOICcy5CEJ8T+xkaNeEUHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272932; c=relaxed/simple;
	bh=uEMg92tRhWt/alyotDrlwj/NIZW6+Bg7EtLcBzODtmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tgUi6y9KXs87sP+sG+GJ/sPJt+JmRQl1I3dwt0oGj3RFBOyH09Z5nQmkQi+aY/BHg8YC0UZwgXSVPp3TkhooQ/05HdlABbE6+Wqwr4dm/d8g99EkVCDVnPfhylZbesy5QmL/+2jQCrQtfq6jUSkEAeXGs72UCmMWp7Ynwb0CbS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cu48Ruas; arc=fail smtp.client-ip=40.107.93.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tnX6amku1UldK7siYP61VAH4MTfvAiW76vim5nNZRhXymG6GAXEEJyVEgZWd+b6tEyhgSvGtWghqhWSwXYWR+0QedwzE8FahWl/j4AwSjN7DjWaDvGKY9DdN99onfsXCFMvvor/HaHuGNI91l8NA7umJq9CraBmkkilP2tXYy7kMdbMbZPgD5bEflX9+EpHSpQvzzjA5lubpDY44yQD0AM9hHUUv0FOVGmTRAYyDChyYrBgi9d+1aeVqHBlmqmD/Wenj/V3umA3U3N+jWjJsFoR6N8H3WLLiwK1iwAF/91mULv3f6MnPIgNZ/MzPqtnzqO5gajhDosAekW96J2VecA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fykS7Y9VK+taJLjTIJ4f2leQ8+/iqKwi7e+FT7OA0zU=;
 b=wv37B2Cg6WHIRaMU4QmOdkRrc2tmg5xUlOvCuAQsex0YmItZEc6GUT1eJfTwcQ/v5X2/MG+lEXdjAGdKvN++zXOI/Fh4FNA9aOarbC5J8JGvFLjiM7dBIQNXuq5JtL8Dj2TOR2GHbmYZA+wJATADkdjfH6YVsH3tvWycRwloktFh7TJWHO7u9zQvaH7K6zGWR300PhQxJipdjRS9qXqGiXCjXy7Q6UnIppQFqA6IXv5dv9/1dN2r1zXyi/UBA6hFGAbAGGfrbOiIX8TRD0XQKCbr6SQpVRxjjpZVMJanUhmuTgto6d/lhy+J6OFp/FADDtFF1glhVm/yLsBmuz0Wjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fykS7Y9VK+taJLjTIJ4f2leQ8+/iqKwi7e+FT7OA0zU=;
 b=cu48RuasiSHGBHTF6oV5HvKeC9fi95rcfCm6AUTg67AtbiV0XH+90vVhvr3pLCHKSw+ZMvCgU+HyMaeB5yYtQrzOvRETZWNn9kG5S1TG83S3e5qCLqO6/l8Ud1mJWeJJNpdp3CU3U3W5DwEexB+WN7+8jfxCRNph5y14gZ/g0rwIg1AVY1ZI3l8+SCnbPWEnt7HmtjxNzWZbE3tGmk7suEfzy/1ZJPSEPbkWv1l2wfg0cD/nUGgGCFs0UA4vLlF+80hO2ZaXX07RSuQBAM8gHJyu9O4EGMVIOUtVmvfR+geY+ux6DwX/7VKVvAce3yn+0Y0kCEW4UcxFzlro7syyAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19)
 by SA0PR12MB4463.namprd12.prod.outlook.com (2603:10b6:806:92::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 15:48:44 +0000
Received: from IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c]) by IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c%6]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 15:48:44 +0000
Date: Fri, 15 Aug 2025 15:48:37 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: almasrymina@google.com, asml.silence@gmail.com, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Saeed Mahameed <saeedm@nvidia.com>, 
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, cratiu@nvidia.com, 
	parav@nvidia.com, Christoph Hellwig <hch@infradead.org>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC net-next v3 0/7] devmem/io_uring: allow more flexibility
 for ZC DMA devices
Message-ID: <desvj3r3zdziohbm5y3demywumahicutmipcvcpdyjrexccbnu@tdlmdemnijws>
References: <20250815110401.2254214-2-dtatulea@nvidia.com>
 <aJ9SuemoS6n0GIBs@mini-arch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ9SuemoS6n0GIBs@mini-arch>
X-ClientProxiedBy: TL2P290CA0007.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::9)
 To IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB9031:EE_|SA0PR12MB4463:EE_
X-MS-Office365-Filtering-Correlation-Id: a0031331-9d51-43bb-139c-08dddc133707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z1BcrFZBOL4Y97ZJfqU7KzOFHAxG8g4x5MBnuFOkH052hKObgPuoAcjuVmpl?=
 =?us-ascii?Q?dTG2lxqvkws8yXAAykW/cMWWZrYyo+uiOUTC+6yPZ0xEZ+6t0V6SKui47qQx?=
 =?us-ascii?Q?rkoSQW4j8NJUWHbJaJdsHRJf7vuPrR0UywkdECCpFJu7wMR2QkcU+G2fFKN7?=
 =?us-ascii?Q?ems4sQ01Xu+ag0ozkbSmmpDWckehk+JSvAvE3V/px5ZHhNlsfiDkQQ7y0O49?=
 =?us-ascii?Q?pglmtSNtSJZQZGIxdJrlPVHMlc86VNmYUHSk14EB+eXH9Peu0wl/m4wISQZk?=
 =?us-ascii?Q?DBT0mtPniAZhLlivH0nAF8dZXPS9kVwdlre6WeCogN5ONQJnZWaPpHMHjIHw?=
 =?us-ascii?Q?8U+49N2cs8h5EPLBUzndjQmMCqnBocbpQLuxt2gKDMeb88vqpxWY0gp6pfFr?=
 =?us-ascii?Q?/sfedtz7n47zfBh965ndgyZVgqjJjjHfiSDXEzmscy2B3C56Xr6CSugBLFdG?=
 =?us-ascii?Q?+RrUCiQIVGDBtR5gk7Mtqv6y8YKv/BQ4svz/THGj8V4cTFQbqfq5M2JE921v?=
 =?us-ascii?Q?TuqbHiCHPNQrSlsDhwKOzaqJm7kLUmJ25K1t8bGxHRcGk2hbK1AF02ZXiLdB?=
 =?us-ascii?Q?mFeLyoBPXvyL9P4O+63S0A9CtXM3h6T3EJAM9Tgmlq7XUkeJ+j+OS6gkYpkl?=
 =?us-ascii?Q?PFWVxQ9i/sDOWEXDJcxoqAjuNB4iM96te0/nhXR+W/t0qBAuOWoibTLZONe4?=
 =?us-ascii?Q?GiMQV6QU+07kKUiw10+T7Q+kBETTm8LdvG2ILVhYa5bcZApCiQ+OwlIo4YBA?=
 =?us-ascii?Q?cu0PFhfPsxpABkMeRMBb35FyKsvn07aON5ruJVIvE/DSPJZGUiLNqI9PlwPZ?=
 =?us-ascii?Q?Kvy33XxA7JlQal5k+erjPc2nmvW1aXhPgQ6d1jtW5zLxjh5th3G9EjeHMmYK?=
 =?us-ascii?Q?YiZGYT5VPow6mZe1lO9Zhjm9X0wshowr2Kg8cIfzUy2P+c+ac+mjCIQykO+8?=
 =?us-ascii?Q?AiZ3kWeRYxY8fruOA2h38tz7iJJ910z2MlE7IyZCbErGYX8Pr1y3EWuPpCKo?=
 =?us-ascii?Q?ndjy48qntL4vZrsl1CsvPWx6Tale1H/i5dZrJqV+bJZsjp6hensqsSXT7DVi?=
 =?us-ascii?Q?/C4LYwqreYlb3pnDLTUgQpAfiekYv6ygmQ7C086yzo7N+Wzs/NSOeCLrNcsO?=
 =?us-ascii?Q?8IFAuoik+Kx4SyoWrrVLngBW2lAIqrdpH8scClMXgL5OqcGU4Eaydrkpj5ep?=
 =?us-ascii?Q?1eJ3ok9Z03q7bHuOs0b8EgXw6+C7dq6zUul/VdWXAl7U9m7rmxOsWbOeL5ut?=
 =?us-ascii?Q?Pv5LJxqfP1iN1vurDhMJ15n+lonqfTAzFVan/CZHn4v8g+C+C6HZy7gB0CbB?=
 =?us-ascii?Q?cLzfTG4k2+gcm1ZOpLxugvQgY47LO/yTo6GkUf8pVWjL4cwi1t44uC+hCsZ8?=
 =?us-ascii?Q?3uaYGWPFcWmEcBy1NDDSrH3O0bTWC1GLCD6QIuucWA1cd9nH1ofsmCcmaFBt?=
 =?us-ascii?Q?3LekCJNALc2EtvG6IZPejoiM9EIcoeZ4AWs7eW8po63NZrLHEDLTMeYGi8tv?=
 =?us-ascii?Q?8nzODDmNMPx6Yk0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB9031.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rHamDGQDBP3nwlIy6QVpuf7gm08MPwFRvUn4zdUpjiHD9UaLbnfCAgqItucN?=
 =?us-ascii?Q?7LGS8xHUEiOzHZQUijmNsnfeUsorKxnMId41/rjk9JPek5htY6JTFehJapUT?=
 =?us-ascii?Q?OmNXyQ6iFi9n+FruOAzjGc/jJksuJVDIVswrBF7sYhj4Iu1TrKFhyRONFkD8?=
 =?us-ascii?Q?8utVIJkRbztfPLa5i2R8dJEHPQiI2P7CUnu0snTmrfcxIyBCZgL58kxmTM2k?=
 =?us-ascii?Q?EyCVFp4pwvPosivJiBWfzLdOH5wbkoF0+mxHiPyNikQZpC1pyFJD14Dp7pgo?=
 =?us-ascii?Q?WPSgoWQam/eDGH5zkZjc6ePrXkgRx51WeZInlkdonGiJ2Og2lpqtv8tv6rBO?=
 =?us-ascii?Q?HGF9UhEF7Aqu2A4ktJdcrENbo0/otiqQKFheIxdiU9jdg6WZ2EisORzizm5z?=
 =?us-ascii?Q?y+jKGw3v0OGq7XWgYz4FFFxkwg/B8YG1j/zS0lQS7powHSyA2RlrjPaLtvj8?=
 =?us-ascii?Q?YOPH9A9XHhP7NmRkz2jYP+sGRMs3htXY1+np3jZ7F5c5d549uUBlHE8uZrBO?=
 =?us-ascii?Q?kMGI4Ut/9FclNYHRG2gCPR6aRAgi8qNvhLWWlQvci9JFrN7SLc0B1jkdI6m6?=
 =?us-ascii?Q?K/Mua8N7MVvLNnfAIVHFQpyrJE3c5KNmWulOHg24incN7QAzcmBPAgJ40Kr4?=
 =?us-ascii?Q?m7TxaKIO53rB8qeBz3VTSckzkjXcm1kt63kqIU7CMejxBwmuyhJHWK2rYL8J?=
 =?us-ascii?Q?Rr9aMa6cMDU14sbfM7zJwT5KFNFSWVzJsiVLS2QkpjZc3+FKYhste2LtEqv8?=
 =?us-ascii?Q?gIFF4XxeE0H11KOg5VnvwgKs0xGxcn4BAoIikQtrmGNje4YWCsQzTFa13wnx?=
 =?us-ascii?Q?eY7zV7ki3E9DPrrX4kurOIONvPExhmSDDdijFwqrsVhM248OJn9ky0Nl3zZH?=
 =?us-ascii?Q?6ra21B8cZ7bJdKL0FOvtzuxorpIEdT0Jz4k2hpgdAEcKqyUqj8jb/6KJaNmW?=
 =?us-ascii?Q?AJgbZrKa0xSzX0qgI2rIfmNXm0raebA8y8uUgijL4AJYNfM2KZ/BVXQq/+t8?=
 =?us-ascii?Q?DnWLnMwLnSWyHvRNjUO5JAqZSWKm2legy06fE+t4Tc5+o39lOU/B9c+Kiijk?=
 =?us-ascii?Q?OadypPzcVwuPCLTDNX9cHh9SOaJDIgF7sUJowZGJIC6s2G4VYWjRq4B4jxfb?=
 =?us-ascii?Q?N8sdGhgJdrpUweqWi3lKuOHT0JI02LSe78Dzui4G3/4NIArSWo9BlpXp29+s?=
 =?us-ascii?Q?qOfzsi1F5ZaLZmx8K5lBJ6UNAbMe1sJgRtlQKZO8H4/UJBZnfY7axgqGOwp/?=
 =?us-ascii?Q?rG++VF+UgCcYJhNsjgqY30lFdKRyVolroIVjkD5NcEJ5dmFg6A/mPgXRAwYV?=
 =?us-ascii?Q?bcSLeO2E/WCtGoPd5JIUaFQfogM1YsdWSUlQb54kwlrVc0X8G5Bf+FLy9Vnt?=
 =?us-ascii?Q?7bRxGSKohY8vQO4wA52lgMpl7DRL76FEBJwW6KWJk5SM+GBLFw2yCQ3VAGho?=
 =?us-ascii?Q?N2EhD/OKyRE5/wkAeFag9vfHHVveiBoumdskhEEM7jTPn/le1XE67qemuCly?=
 =?us-ascii?Q?Yn98Snp1CnqTl2Cn2+Qzu108nfSu3abFiHJmvn5mjRN3t4GlNsV+LzYsxGXL?=
 =?us-ascii?Q?I9NVLzR+cOtK8M1VfzU0U30DUIcCI/fNwI5l6imF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0031331-9d51-43bb-139c-08dddc133707
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB9031.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 15:48:44.5294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5GjPQvDvq+teys/R+AOsmwecew7h3xF4iZbLo35P0IXvZnnrQUgQB6uawu3RMHXk/Gf2gP3Tn9LRheIl8JqWcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4463

On Fri, Aug 15, 2025 at 08:31:05AM -0700, Stanislav Fomichev wrote:
> On 08/15, Dragos Tatulea wrote:
> > For TCP zerocopy rx (io_uring, devmem), there is an assumption that the
> > parent device can do DMA. However that is not always the case:
> > - Scalable Function netdevs [1] have the DMA device in the grandparent.
> > - For Multi-PF netdevs [2] queues can be associated to different DMA
> >   devices.
> > 
> > The series adds an API for getting the DMA device for a netdev queue.
> > Drivers that have special requirements can implement the newly added
> > queue management op. Otherwise the parent will still be used as before.
> > 
> > This series continues with switching to this API for io_uring zcrx and
> > devmem and adds a ndo_queue_dma_dev op for mlx5.
> > 
> > The last part of the series changes devmem rx bind to get the DMA device
> > per queue and blocks the case when multiple queues use different DMA
> > devices. The tx bind is left as is.
> > 
> > [1] Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
> > [2] Documentation/networking/multi-pf-netdev.rst
> > 
> > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> > 
> > ----
> > Changes sice v2 [3]:
> > - Downgraded to RFC status until consensus is reached.
> > - Implemented more generic approach as discussed during
> >   v2 review.
> > - Refactor devmem to get DMA device for multiple rx queues for
> >   multi PF netdev support.
> > - Renamed series with a more generic name.
> > 
> > Changes since v1 [2]:
> > - Dropped the Fixes tag.
> > - Added more documentation as requeseted.
> > - Renamed the patch title to better reflect its purpose.
> > 
> > Changes since RFC [1]:
> > - Upgraded from RFC status.
> > - Dropped driver specific bits for generic solution.
> > - Implemented single patch as a fix as requested in RFC.
> > - Handling of multi-PF netdevs will be handled in a subsequent patch
> >   series.
> > 
> > [1] RFC: https://lore.kernel.org/all/20250702172433.1738947-2-dtatulea@nvidia.com/
> > [2]  v1: https://lore.kernel.org/all/20250709124059.516095-2-dtatulea@nvidia.com/
> > [3]  v2: https://lore.kernel.org/all/20250711092634.2733340-2-dtatulea@nvidia.com/
> > ---
> > Dragos Tatulea (7):
> >   queue_api: add support for fetching per queue DMA dev
> 
> [..]
> 
> >   io_uring/zcrx: add support for custom DMA devices
> 
> Did something happen to 2/7? I don't see it in my mailbox and in the
> lore..
I see it in lore:
https://lore.kernel.org/all/20250815110401.2254214-4-dtatulea@nvidia.com

But it seems to have been sent to io-uring ml only and since you were
not CC'ed, I guess it never reached your inbox... I should have
explicitly CC'ed netdev instead of relying on get_maintainers.pl. Will
do it next time.

Thanks,
Dragos

