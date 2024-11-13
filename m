Return-Path: <io-uring+bounces-4663-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8C699C7D08
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 21:37:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6901CB24C20
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 20:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9A0206051;
	Wed, 13 Nov 2024 20:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="exf6jg0L"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B390A2040B1;
	Wed, 13 Nov 2024 20:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731530192; cv=fail; b=njcu3gXN96aGbjgi5CgX2IgJ/ypPxjG0A/FLsA8yNDmtF2im2JGy2jX7Cfs+5sjQJ3UU4nQh+ap+55MnLX3liNGT20t16xe/ltd4awowJ6814cRDVXA7Y0ws7iIvHCgaWQpXxpfJov/HRcioUBJgCIMmFHTCjVclypWlwHBcBng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731530192; c=relaxed/simple;
	bh=/AyKmsSkDkMIwlolcDSBdsSrOog3ZDPNnua5R/5eRT4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VsOApP2kckTVpF3lfA4FtAcqFSZZTzYzkA3AYHwdQEJ+XQG7eja9S6Doo6PtCpxxq++W2g2O3AcqdB8eQ0rslA+iMNxUL4wQzAvPZu1SjG0gm4jj9mPowuMzH3IWDJtTd1Btv4+bJqfrHsLhNU4+IS0Pe39nPBkFfjgCQnQkD9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=exf6jg0L; arc=fail smtp.client-ip=40.107.243.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=msMwxwG+BD324URa3pWJ65+YhhCqZx3ZDs7r3o/tnRbkoKIDz07LNShsMHm7fmw1qsOWk4rY/Vc5UdqXDI0wB7K4vIjbrPm7gjafVbcshF6NQoZ1We0jkOs26Id3pOFTQE7cvc6iwe/s2s0YWHz7dLSqy0/ip/1m5hXp7uQEODeWIdqHLykWqsnga/LD5Y1G9XMWv1UG/nZN5o6w8zTBAVE8YUKWwf36EHrcQDoy/g0tUqT8LzH+IcgcmolpIMarkznTMb1mr41SPJJ+OGafhGRxBUWZg1XuK/8ybaMYf+Q9de/e0ggmwymRBAAhGvpNeDKuT2N5vK9UXaxuiym/4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/AyKmsSkDkMIwlolcDSBdsSrOog3ZDPNnua5R/5eRT4=;
 b=r7UMPYjPO0trXFV4/6zinfhaogsZJqJQPBOykYNPguPGGcCtoH6204JN1d83pl9t3p9of6h9/4NGoHVYNqKl265dXd1Ts3z5vUDqAZF55xmyPibXf3YD7GmYMgpVWN4IpkF/GTMgf8MmvI9yriMB/FGgSF7VDUh5anD4r/YFfTGBXKSDTSWRwpYJHmO4wrU7haQ3dcFdZQADUXegwRgL1gi7TCoKWkdXWcaIL/pI0VImFn+HuS5UwEPkj5ttjUaZZGyk8GgKizlw6C1ULUr+4AHcNqZe7KMtuK8fIqQeRgojWNPRnIO10AUTcLraSRL1MyTctz51/pvCPNc5XEKkhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AyKmsSkDkMIwlolcDSBdsSrOog3ZDPNnua5R/5eRT4=;
 b=exf6jg0LnZ0pQl1wlesy5BZZa3cIMLJIcqmWBCiJyzpD3rfOJg8kvemjYjZSpdRbBnGRgWjvwGb7N7mn/qqwRQx6iv9nsYSNqKUzp1SWbRAHRG3w8UPo0/CVbBE9eWDEjBbTPX4m3bdxIkGCRfreLDdOVhjqq+CZZgLHcByDgtVcebxHtRdy7EgjkYQd6ys40jXVROWVhyOjIKVcYjk8pTzMHcLV2AtmY+ruzRYiivS2hTcmmAtr1U3k+g2I0zDIb58o+fHkPnxOm5am5SD981TzsRFe5BN7OrJkWjWz4CH/QWzOjVI71WbLfidY9ywOiOqIqjxh4pKaQru6GPjokQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CY5PR12MB6453.namprd12.prod.outlook.com (2603:10b6:930:37::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 20:36:27 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.8137.021; Wed, 13 Nov 2024
 20:36:27 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Pavel
 Begunkov <asml.silence@gmail.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>
Subject: Re: don't reorder requests passed to ->queue_rqs
Thread-Topic: don't reorder requests passed to ->queue_rqs
Thread-Index: AQHbNd+6y4TJCQSoD0abWWMVSd1fR7K1q6wA
Date: Wed, 13 Nov 2024 20:36:27 +0000
Message-ID: <eb2faaba-c261-48de-8316-c8e34fdb516c@nvidia.com>
References: <20241113152050.157179-1-hch@lst.de>
In-Reply-To: <20241113152050.157179-1-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CY5PR12MB6453:EE_
x-ms-office365-filtering-correlation-id: 024b1500-bf12-4d68-c5c1-08dd0422d91a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?YUFueDhVVStZUHl4OWZ2QVE5cjZKQ3Evcm82YWNHdjBkbkhVR0FYV1lZUU9o?=
 =?utf-8?B?NktScG5JUUNXYWFQTWQyNjk4dFdvc01nREVJOU5sNW9VSFBRbzJLZEN2a3U0?=
 =?utf-8?B?SHA0OGlOQ1RZUmFiTmlCOEtIYnlUUGg1Z2dSeTM4OGZmOGVTdi94YVoyVHFL?=
 =?utf-8?B?ekZsT0F5QkE5ekVHQkloZFJqb1BHbzV5OThEMFM1bE1Jb29MaENtNlZTK1Fo?=
 =?utf-8?B?UE1ObUJab0FVTnNkam92VXFadCsvVWJFWEgvY25tRE9EbnZvNCtuNE50N201?=
 =?utf-8?B?TGpRd2JxYThDSk1TUVBPODlqcU54ZFc2VHQ1MFhGN1JodEpFaE5CMXoxRWw2?=
 =?utf-8?B?Nnd2V09IQXNPclIvdWdKeDFyeEk4U1hWTUluWkhZbTdQL09COU8xcGgvWGl1?=
 =?utf-8?B?cXNOdW1UNGI4bytXbFBwSzB1djNPcDdNcDFnU2V4aHVlVE5CN0FyQVI3VEta?=
 =?utf-8?B?bnNuOTI5Uy9CaVhpRzFYWXdUeFJuVHZNc2I4K2xRQi9FMkpaRUVGc1VmY3Fu?=
 =?utf-8?B?R3lrQ2lNY044VlRORG5ReHg2eHk3VWNjanp2Ly9GSmhlQVhUQkQ3bkRCaUIz?=
 =?utf-8?B?TWxOT3NpT3FvRDVTenkrREgwWWhicGVSTWwwVVJ6NFJMMG1Lc3NMbkJJTUlH?=
 =?utf-8?B?NXU4STM0anJJVjlBbDdZayttZk1MVDFjcTZqSXlCWldpMmxOWkVDMW1TRVNF?=
 =?utf-8?B?VVNtTUZPVnM1NW92ei9aYTlNU3FmY0h2ZzFRQ2pXbEZJVEtBSk9lb00wN1Np?=
 =?utf-8?B?aEhkdFlCaWRMN0dRR0dvd0RIVE5RbmhqV1NqMmRBVFFLRkQ1bjhqN3BVZVAr?=
 =?utf-8?B?amFiTzhtcjRFQzFkQUVLc2JiNzJ6MWlQdlRNaDRubFVWU09tcnBBR1lnNXo2?=
 =?utf-8?B?c2oxVnl6WGpCVWZkNEcxNStNR2xvbE14TWJvMmozQytRRU43WkhJYlZ0VWFt?=
 =?utf-8?B?aVVYcHBkdUdTRlhVMTNJeC9uNnVhbm9pYVg0YThkRUNxTVJIWUxZeHRneVpR?=
 =?utf-8?B?QWp2b1pwbEJNc0tOUnlna2o2ZDNFM2JBQ3dsMytyQ0pJY01aSGJiVGMraUNI?=
 =?utf-8?B?eXcwZ0wvZW9CYjlWbHcxd044a0lvYkZ2anpFUzlYZzZkWCtiaTY4a2NDdVBl?=
 =?utf-8?B?M05iN0hJeUFXSndsVFJnNWJodDA3NHBiQms5U3FIbDE1UExIVmFseTh3aXZ0?=
 =?utf-8?B?ajlreUtIdGFqQVZrWGIvaENZUTBwL05ya05aSHBWSU1hcWd1b0VYVkVRMG04?=
 =?utf-8?B?UU1ySERrZXR1K29iL0JtSVhyUXg3MVUraDBjMU5iSTVDOWRUOHpJT1NFMkxD?=
 =?utf-8?B?OEE0Y0xnUVRnL1diOHlFc2RoSVZ3VkEzd2pjeS9RR2NtYmlock5iWXRVZklG?=
 =?utf-8?B?Y24zYms4a3lZN1FGSWN2Vk1xMzRURHVSTk0xMWpwME56K1BuOTZrOVBKQ1VK?=
 =?utf-8?B?L0tBaUNOQVpVT0VCdVk2ZVkvWG5qK3V4djJ6VFk1eGlXcnNWWmdpd1RKY3VD?=
 =?utf-8?B?TGdHTGxka2dhSlV1RnphWER1Z1VaR3pESUdjTy9STFd1M1ZqQjJlRW5OdGJ5?=
 =?utf-8?B?Mk1NcWNRYnRtMzdRSUprRC9MUmNjK2dIamNSSmR1NnRnWnlnSDlBRngxOGJM?=
 =?utf-8?B?aDl5eGxPOEYxcDlGelNHSFo3UEZ0RkxOcFhiSE1SVVVacHhFVTdyZENUNndX?=
 =?utf-8?B?bGVHRjQ3d1lRblVQeUtGNjdyQUMwcVc0Rzh6L3gyUFJQRnc2SmtLOEI4SEZJ?=
 =?utf-8?B?VDJYTmJWN1ptUjgwczA5b2gwdTZ5dFROb3JwL0d2YUl6MEZ6UkJ4aGtOR0hr?=
 =?utf-8?Q?wYGH671S8vZI/fVCwdC+WWbBsC2MctjjcXKdU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MDYrVWJQSEttSktXMmN2TjNoUmFrZzZZajNNMU14L3k5K3dZb1kyNVMrT0tj?=
 =?utf-8?B?ZDdtSERYaW8veDROTmxtMUl6WjdCUm01bndaTExxbEtIbVg3Y2lnbkFxWkp3?=
 =?utf-8?B?N1ZUQnkwc1lERGZzQjdhK05MeEF3V05CaEpIMnhLcmdPOG5xZlZUNlkvSUhL?=
 =?utf-8?B?L1lWLzRzSmFvMUNTM0U3ZlNMTTVSYlNldTU0QmU0ZDZqaGppallKeWZjTmlU?=
 =?utf-8?B?cFh2TisvNWZHSHFDNzNLdTBxdWs3RWU0bWRqSHkyQ0s0cThaemVvV3B6Yk1z?=
 =?utf-8?B?M1ROZnNmaHBEc1ZTMkJzYnpJN1ZTTjBYVU5LNThYLytSY0MzdHRTZFhEVDkr?=
 =?utf-8?B?K2NiQ0VrdjJSdGJuY0VMSmh2NFpnNitwSXkxM2VTeE5MSTR5OFd6WkJFMzBF?=
 =?utf-8?B?RHlzZXhCbnV6R1IwNHd3RXpqRGUyR1JVQ3JCY1J6N3pUdmROZS9JaFJ0cWoz?=
 =?utf-8?B?STJZb2g4WUFvUVdlMmNGbDd1OG4xZ2xRUlZvS3V1dHlPT3ZNcU4wa2FidXc5?=
 =?utf-8?B?Z2V3elJmekFTa28xbWZtbGhSYjdHZWlsVVZ3OVdZMUJhTUd3Tk1HNG1vbkdo?=
 =?utf-8?B?anRGQmVsWWhnWGZ3QUJza29YbnBMUUgvc2NhYmtYOGdhODFTSmhwb1R1ZXpq?=
 =?utf-8?B?aXVmc255WFJ5a3RQenVua0VHdHdQaHBXUGtQQ25mUlA3ZmpZcmVCeGVndGVN?=
 =?utf-8?B?WUlxU1A5T0E2MloxUGlJSzhCUTB2UnpRV2pVcG41VzhTSnhYS3NrTCtZdE1o?=
 =?utf-8?B?TVhmWGcwbzMrT3ZMbFh0NjQ4cWpmQzNnczF2Q3pDd29QU3g0Q0Qydzk4MkVX?=
 =?utf-8?B?aGNUb2F5eTgzMHJhME5WRHRlRHRERmF4TWFQMXpFbHZxeU9FQnRzS0h3Myt6?=
 =?utf-8?B?eVBRTS9xTVE0QjRPQ1Z2Ry9VOHhhRHJ4cE1hUG9sVHlVUFgzdkV1MTd5Uk1i?=
 =?utf-8?B?MmJUY1UrSlpIeEJoVFhka0wvSEMzY0pLL1ZjeXdRUW9KejVydk1hOFNlMTN4?=
 =?utf-8?B?eEpGMzNTTGcwN05NRFh2R3A0WUJzYVNwL21DL2IzSkc4T1RERTY3dUU2amlk?=
 =?utf-8?B?UkdpOGdrdVZWQUpSSzJGam1KaVNSeTRxUXd5QW5KeUFRbzcxeis1UGZ3RWox?=
 =?utf-8?B?RVdmaHJtOXdlZXgzMDdEbUhKK0NKQ0x6ZzI5QW5CeHNGNDRPd2s1ZUR1bk9R?=
 =?utf-8?B?OWpwd0ZWL2lVc0sraVRTcU1lOUZINGdMMFdGbVVWaCtXNXIzVWVWam11VlFX?=
 =?utf-8?B?ZTI5YXBRdFFjY21wc0VlOVNNandXUE5tb2ZXdjJPRVVTOGw2L0x0d1N1OHJa?=
 =?utf-8?B?S1BRUzAyVXUxdnIzREhxMVVwSDlpS0hyUzVlY05BeGREZ2h4QjFaZC9wUmlC?=
 =?utf-8?B?SUlPMmd4OFVFS3N2dmwvZWpZVGdxeStSK2ErRGZTVGozVjRKYjVReWtrYkpk?=
 =?utf-8?B?NkRqYUNWWDhMQVU1NTd0M0l5Q3ZGODdmM25qakh6amxSZTkrd0h4dlh0RHpE?=
 =?utf-8?B?aWRQM1c0QjJ5TmVkZnhWbytQelFtSS8vajZXVEQxaFFLanpDck1uSFNub3Jw?=
 =?utf-8?B?c1ltT0xkNFBKOGY1QTd3YjFYVEVrS2NFaVArQmF1dTdCMWZneHZCYW9jZkNE?=
 =?utf-8?B?MTdaYit5K1RTMEMxSlJWa2lWVy9tTThyYTcvYUM4YjRQdDU1TU1yNXpvaW12?=
 =?utf-8?B?dXQ1YXQ0dkVFL3RlMnY2MzRVYS9KWTRPVTZRNUlZcXlJSDRKSGJ6QWMrTWc5?=
 =?utf-8?B?RCtSWWQ5ZjFxN1h5QXpkTk8xZWdzUWRMSEtrTUQvdTBaZU03ang4U2VHd2Fi?=
 =?utf-8?B?NnpOS2dKL0Y3bmhZbU5NRmd3QlhLck54MVRuK3F5dXNKcHNzV3dZYXRwRGtY?=
 =?utf-8?B?SEwzczI4QjdRK0k2QTMrdXVYc3BqZjJ1WE90MThnQThNdFVhZmU4LzNSMnIr?=
 =?utf-8?B?MWIrdVNFbnpKWnpNaExwdjc0ZWhLaFdPeXpUN0hxNk1iUlR1c3JjbTNJVVQ0?=
 =?utf-8?B?RnYrZy9VMi9GdjNjRGExbDhxcVUxOFhSczRCekx0bmdCeU9oUlRNRWludloz?=
 =?utf-8?B?REg3bzRJUEpyRUI4Qm5YNUI5dnZNYTdjbHhqUXFuU2dvdW1lMHVJWTZpS3hI?=
 =?utf-8?B?MEZMb2QwUm14OFY4QjZ3RjFoQlNESDFEaTVjZy9YdXl5Y1BDS0s3NGt4cTc1?=
 =?utf-8?Q?TOdZqZCqEborAfEuXTjVsoSg3+/mt2T7VOd5yUczkmlJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BC96829429512040883A2E76B16C0BA2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 024b1500-bf12-4d68-c5c1-08dd0422d91a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 20:36:27.3740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nTIniftAFfYzd69U8Xz1iDXOg834T2HAmSQTPPosElZq2rX5HF3gFPiZq8WkSOcz0vwGOfzSG6slAOzdQTlxAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6453

T24gMTEvMTMvMjQgMDc6MjAsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBIaSBKZW5zLA0K
Pg0KPiBjdXJyZW50bHkgYmxrLW1xIHJlb3JkZXJzIHJlcXVlc3RzIHdoZW4gYWRkaW5nIHRoZW0g
dG8gdGhlIHBsdWcgYmVjYXVzZQ0KPiB0aGUgcmVxdWVzdCBsaXN0IGNhbid0IGRvIGVmZmljaWVu
dCB0YWlsIGFwcGVuZHMuICBXaGVuIHRoZSBwbHVnIGlzDQo+IGRpcmVjdGx5IGlzc3VlZCB1c2lu
ZyAtPnF1ZXVlX3JxcyB0aGF0IG1lYW5zIHJlb3JkZXJlZCByZXF1ZXN0cyBhcmUNCj4gcGFzc2Vk
IHRvIHRoZSBkcml2ZXIsIHdoaWNoIGNhbiBsZWFkIHRvIHZlcnkgYmFkIEkvTyBwYXR0ZXJucyB3
aGVuDQo+IG5vdCBjb3JyZWN0ZWQsIGVzcGVjaWFsbHkgb24gcm90YXRpb25hbCBkZXZpY2VzIChl
LmcuIE5WTWUgSEREKSBvcg0KPiB3aGVuIHVzaW5nIHpvbmUgYXBwZW5kLg0KPg0KPiBUaGlzIHNl
cmllcyBmaXJzdCBhZGRzIHR3byBlYXNpbHkgYmFja3BvcnRhYmxlIHdvcmthcm91bmRzIHRvIHJl
dmVyc2UNCj4gdGhlIHJlb3JkaW5nIGluIHRoZSB2aXJ0aW9fYmxrIGFuZCBudm1lLXBjaSAtPnF1
ZXVlX3JxIGltcGxlbWVudGF0aW9ucw0KPiBzaW1pbGFyIHRvIHdoYXQgdGhlIG5vbi1xdWV1ZV9y
cXMgcGF0aCBkb2VzLCBhbmQgdGhlbiBhZGRzIGEgcnFfbGlzdA0KPiB0eXBlIHRoYXQgYWxsb3dz
IGZvciBlZmZpY2llbnQgdGFpbCBpbnNlcnRpb25zIGFuZCB1c2VzIHRoYXQgdG8gZml4DQo+IHRo
ZSByZW9yZGVyaW5nIGZvciByZWFsIGFuZCB0aGVuIGRvZXMgdGhlIHNhbWUgZm9yIEkvTyBjb21w
bGV0aW9ucyBhcw0KPiB3ZWxsLg0KDQpMb29rcyBnb29kIHRvIG1lLiBJIHJhbiB0aGUgcXVpY2sg
cGVyZm9ybWFuY2UgbnVtYmVycyBbMV0uDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2Fy
bmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KZmlvIHJhbmRyZWFkIGlvdXJpbmcgd29ya2xv
YWQgOi0NCg0KSU9QUyA6LQ0KLS0tLS0tLQ0KbnZtZS1vcmlnOsKgwqDCoMKgwqDCoMKgwqDCoMKg
IEF2ZXJhZ2UgSU9QUzogNzIsNjkwDQpudm1lLW5ldy1uby1yZW9yZGVyOiBBdmVyYWdlIElPUFM6
IDcyLDU4MA0KDQpCVyA6LQ0KLS0tLS0tLQ0KbnZtZS1vcmlnOsKgwqDCoMKgwqDCoMKgwqDCoMKg
IEF2ZXJhZ2UgQlc6IDI4My45IE1pQi9zDQpudm1lLW5ldy1uby1yZW9yZGVyOiBBdmVyYWdlIEJX
OiAyODMuNCBNaUIvcw0KDQpJT1BTL0JXIDotDQoNCm52bWUtb3JpZy0xMC5maW86wqAgcmVhZDog
SU9QUz03Mi45aywgQlc9Mjg1TWlCL3MgDQooMjk5TUIvcykoMTYuN0dpQi82MDAwNG1zZWMpDQpu
dm1lLW9yaWctMS5maW86wqAgcmVhZDogSU9QUz03Mi43aywgQlc9Mjg0TWlCL3MgKDI5OE1CL3Mp
KDE2LjZHaUIvNjAwMDRtc2VjKQ0KbnZtZS1vcmlnLTIuZmlvOsKgIHJlYWQ6IElPUFM9NzMuMGss
IEJXPTI4NU1pQi9zICgyOTlNQi9zKSgxNi43R2lCLzYwMDA0bXNlYykNCm52bWUtb3JpZy0zLmZp
bzrCoCByZWFkOiBJT1BTPTczLjNrLCBCVz0yODZNaUIvcyAoMzAwTUIvcykoMTYuOEdpQi82MDAw
M21zZWMpDQpudm1lLW9yaWctNC5maW86wqAgcmVhZDogSU9QUz03Mi41aywgQlc9MjgzTWlCL3Mg
KDI5N01CL3MpKDE2LjZHaUIvNjAwMDNtc2VjKQ0KbnZtZS1vcmlnLTUuZmlvOsKgIHJlYWQ6IElP
UFM9NzIuNGssIEJXPTI4M01pQi9zICgyOTdNQi9zKSgxNi42R2lCLzYwMDA0bXNlYykNCm52bWUt
b3JpZy02LmZpbzrCoCByZWFkOiBJT1BTPTcyLjlrLCBCVz0yODVNaUIvcyAoMjk5TUIvcykoMTYu
N0dpQi82MDAwM21zZWMpDQpudm1lLW9yaWctNy5maW86wqAgcmVhZDogSU9QUz03Mi4zaywgQlc9
MjgyTWlCL3MgKDI5Nk1CL3MpKDE2LjVHaUIvNjAwMDRtc2VjKQ0KbnZtZS1vcmlnLTguZmlvOsKg
IHJlYWQ6IElPUFM9NzIuNGssIEJXPTI4M01pQi9zICgyOTZNQi9zKSgxNi42R2lCLzYwMDAzbXNl
YykNCm52bWUtb3JpZy05LmZpbzrCoCByZWFkOiBJT1BTPTcyLjVrLCBCVz0yODNNaUIvcyAoMjk3
TUIvcykoMTYuNkdpQi82MDAwNG1zZWMpDQpudm1lIChudm1lLTYuMTMpICMNCm52bWUgKG52bWUt
Ni4xMykgIyBncmVwIEJXIG52bWUtbmV3LW5vLXJlb3JkZXItKmZpbw0KbnZtZS1uZXctbm8tcmVv
cmRlci0xMC5maW86wqAgcmVhZDogSU9QUz03Mi41aywgQlc9MjgzTWlCL3MgDQooMjk3TUIvcyko
MTYuNkdpQi82MDAwNG1zZWMpDQpudm1lLW5ldy1uby1yZW9yZGVyLTEuZmlvOsKgIHJlYWQ6IElP
UFM9NzIuNWssIEJXPTI4M01pQi9zIA0KKDI5N01CL3MpKDE2LjZHaUIvNjAwMDRtc2VjKQ0KbnZt
ZS1uZXctbm8tcmVvcmRlci0yLmZpbzrCoCByZWFkOiBJT1BTPTcyLjVrLCBCVz0yODNNaUIvcyAN
CigyOTdNQi9zKSgxNi42R2lCLzYwMDAzbXNlYykNCm52bWUtbmV3LW5vLXJlb3JkZXItMy5maW86
wqAgcmVhZDogSU9QUz03MS43aywgQlc9MjgwTWlCL3MgDQooMjk0TUIvcykoMTYuNEdpQi82MDAw
NW1zZWMpDQpudm1lLW5ldy1uby1yZW9yZGVyLTQuZmlvOsKgIHJlYWQ6IElPUFM9NzIuNWssIEJX
PTI4M01pQi9zIA0KKDI5N01CL3MpKDE2LjZHaUIvNjAwMDRtc2VjKQ0KbnZtZS1uZXctbm8tcmVv
cmRlci01LmZpbzrCoCByZWFkOiBJT1BTPTcyLjZrLCBCVz0yODRNaUIvcyANCigyOThNQi9zKSgx
Ni42R2lCLzYwMDAzbXNlYykNCm52bWUtbmV3LW5vLXJlb3JkZXItNi5maW86wqAgcmVhZDogSU9Q
Uz03My4zaywgQlc9Mjg2TWlCL3MgDQooMzAwTUIvcykoMTYuOEdpQi82MDAwM21zZWMpDQpudm1l
LW5ldy1uby1yZW9yZGVyLTcuZmlvOsKgIHJlYWQ6IElPUFM9NzIuOGssIEJXPTI4NE1pQi9zIA0K
KDI5OE1CL3MpKDE2LjdHaUIvNjAwMDNtc2VjKQ0KbnZtZS1uZXctbm8tcmVvcmRlci04LmZpbzrC
oCByZWFkOiBJT1BTPTczLjJrLCBCVz0yODZNaUIvcyANCigzMDBNQi9zKSgxNi43R2lCLzYwMDA0
bXNlYykNCm52bWUtbmV3LW5vLXJlb3JkZXItOS5maW86wqAgcmVhZDogSU9QUz03Mi4yaywgQlc9
MjgyTWlCL3MgDQooMjk2TUIvcykoMTYuNUdpQi82MDAwNW1zZWMpDQoNCg0K

