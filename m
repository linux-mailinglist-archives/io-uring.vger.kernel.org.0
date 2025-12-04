Return-Path: <io-uring+bounces-10956-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8406FCA365D
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 12:13:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56764302C4FA
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 11:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 470933328FF;
	Thu,  4 Dec 2025 11:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BpHFRyOP"
X-Original-To: io-uring@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010018.outbound.protection.outlook.com [52.101.46.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2932DF12E;
	Thu,  4 Dec 2025 11:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764846612; cv=fail; b=iMHTv4/ExyTmLgM1S1COsf0tJna5lw5ZbEcIFprmK6Vmy8QG2r2bAdMINlW5e3ao6vMJ14J/pe5AkEtU3sWAgR3i1OBqLRPXoOo32d8kUxxTmtmLM5Jp4Je5PPPOVWYM2Skl2DwWfTkMBd4GISC+rYrW8gA2la9bkol962OpVQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764846612; c=relaxed/simple;
	bh=ursBkKSMv4OY+Et6RbcrT2Aaiv+HMWMx56U1AEvjrtg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xhz/nC6rjPNBMPfZs1Ea/L8bO9Q5u/6432umWhB8fvW74ff3GiLHSWNLZKe1bGheiK/NNV8FAN15sUDllvKCDeT8CDTrbIlniZgVtIIWjRkffxAhHXwbplhCMz+E8r2txv+tjd3VLAL9iNXGnoR5yx7P1061wJZYGAONPxd1zZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BpHFRyOP; arc=fail smtp.client-ip=52.101.46.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FR+GIhxa5ozctTjcAv3xTKncAaYBIhED4pon567JHcxhfeJenXL1nixDTT7xXS2/i3xzDtBHl5WTU4hCHe+2DQVZ7/pk4ThY49m3eRxYDchHhPyZAcHoWaNY1zRkZQdLl4ez40E+TVkFTFJWvIwzZ6QCZDuqZVtf1PLbns5Sgg0g3Zf+IRcYeS8RlS8kBAFVbw4mI1h0T4An8QtVTirL+id1FWk+6oQARPdSpVCyZ9K9EJfmwE9CVnJe9EHXDtPZiei7XYpxBspN7x2s5vHcRNI1a34nYPIxtmz2ADhdtZyOb9JPZh+k8PRDmKXQKXlypLNKJtDUD0KKbs1qvPNzbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ceuNVAu/Tg41gEM4WQ8KWwZPWZ9Si9CkR3aupRy4lAs=;
 b=Q7jIyBw2FRPcoLP3X0cQDYYU1cUCZQz9qa3qdQq6iSoAn9CS5n1gtOafuvHYhIVFJ6MbaV9dAPgTeUFnFcr9AjOOVrsdJyxhnh2+gQEuPtBWzxammrsvizYzKl6jCVrjGCJETBWuKVgZioq3MT4LA8cNpFky3YJuyT6S97+SGR3P5mYQbExtSpfQbXNvHWinXlU0v/8+gfwSx3t8t1vJF9JEVZ9IVvGEoA9gubvDowZqn9cWuMFkc+wZlKA9lUJxNoAJa83mpKvsmzFPXSMaOKM5wLENk/KdbprrOvHmrM+R3YEIq3/YYbLLrx2o1ckeq1DPuHZqJ07GQwMxAk8FAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceuNVAu/Tg41gEM4WQ8KWwZPWZ9Si9CkR3aupRy4lAs=;
 b=BpHFRyOP4GO/pRbM4jvM4PHa9/R447yvRkj1VTaJM+BxzCL1zMxjeJ+yQt8V+L+YN93O6yZFx8ARy+qBxtmuZ+hZ2pzgZ9KvJQG300XmH8zOzyIJXFic7TUMQ38xCQyOXwCBjsycFZfVSGDA2n1on8G1cLR9v46aYTD4Sd8TYeA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CY5PR12MB6226.namprd12.prod.outlook.com (2603:10b6:930:22::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Thu, 4 Dec
 2025 11:10:04 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9388.003; Thu, 4 Dec 2025
 11:10:03 +0000
Message-ID: <0571ca61-7b17-4167-83eb-4269bd0459fe@amd.com>
Date: Thu, 4 Dec 2025 12:09:46 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 01/11] file: add callback for pre-mapping dmabuf
To: Christoph Hellwig <hch@lst.de>
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
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20251204110709.GA22971@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:408:fb::19) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CY5PR12MB6226:EE_
X-MS-Office365-Filtering-Correlation-Id: 2839be07-7d55-4d72-e787-08de3325ac40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bE5rSENPcnMxUUhUZnIwblp0OER4SmhxK2s3YlNGVGZLaEVqOTJXRDNBRWM5?=
 =?utf-8?B?Y0xrOHV5OHlsZythZ1FoMnRhQit6bUhac1pCZGQrcEVGOURVVGZhWTFCSW9O?=
 =?utf-8?B?ZmxVczJtNWl2N1hob25kcm9xMWh2L3JBWWdwMU5iMFJ4V1p4dFh2c05SQmhN?=
 =?utf-8?B?Q1hkVUZQTUN1dThBdkRSRGgwNTRpdlhDU09DS1JCVDJLeE9QNFJtaVJXQUVI?=
 =?utf-8?B?NHl3SGRBaW5QVjc1NlJxbURqWVVIYkQ2eFQrVm4rMTNBK2VkeEdvMjVQWXJw?=
 =?utf-8?B?NzQ5K2ZWbythR1JiUStGMzVmNVNhelpYZmtiU1YvZkgwclREMlVOeVNyK1Rl?=
 =?utf-8?B?dGplQm9rL3B6L3Y1WElTRVZHUnNEK3hwbzltRFBTMkgwMXRFRkI0dGpONE5G?=
 =?utf-8?B?KzR1Rm1uS1h0T1Zrb2FsOXNISjZwOER6aEltdjNnMG5kZmRrWnVpOUtFNnFK?=
 =?utf-8?B?SlNqWEh0bjlncllVTGNYU0JsOHdycUZMZkROVWl2MVhwRzgwbWJKK1pGMFhF?=
 =?utf-8?B?L0JNRFZ0U1ZpbXR5R1dJQ2ZTOFk5VGFlcWZJYUNzeStKelFaVlkwbkxrR2U1?=
 =?utf-8?B?TjVieWNwU1JhaEoyK3EzaVFrNGJoYU93ZkZUY2pnanR5aWVOZ01YdlJZK1lW?=
 =?utf-8?B?UVplbVJZU1hZNEdPVFE1NWk2RFpKQ0M4bFhRakhyVFNka1dKZm9wVS9oWWVK?=
 =?utf-8?B?UFhFcytyOGVYNUF6TVNTTk9wUnMwbUJpeWN6eUpFZk1FYVhBQmlYYllZNE9j?=
 =?utf-8?B?aDJoTTlPMDhqVVZ2M0RjTlNkQ2wrMFZQN2ZpdUNmbVlSSnYycThHV0lMS29H?=
 =?utf-8?B?enh2MTZrR3JvaHBCbk1PT0UrbHdTM2FvRjVEV1VnNnFBeVBCQXZHUFh3Ympn?=
 =?utf-8?B?a3FtRk5pZE00a05Fcmd2QWpzS0JmNFB1VkI4QnBzYyttVlQ2dUdJc0o5cGFC?=
 =?utf-8?B?YzdCKzlZejNQekMxM0hvcTZIek1CZ1dqa3hZYVRpcW1FWStaT2tMRDRJd1Rx?=
 =?utf-8?B?VGJyd2VDMEV4Y0xmdWJUejZsaEJkWE41a0xHZ1pVblVLZGh0MzNYMzdzUEZz?=
 =?utf-8?B?TDlOdW9YVkk1OElLUkVUMzhaSEoxZlNwdlpIMCtqcHpUb0NMaGVjWnFSVmxT?=
 =?utf-8?B?M0lzY2J2bEZOVUJsWEwwMGZ6S2tWdnBzVWNBNEg0RDdnMXJaeVJPSjRZSUJQ?=
 =?utf-8?B?cmpVNU1FR2xlaTlGcnlzMVQxT0dxbStGdDI3TmFiVWhlMGQ4WnM5N1JwSktz?=
 =?utf-8?B?MTAzbFg0MmRBNWYxeGVGckVJVXJNTHo4KzZ2ZHdlTUw2OUJtMVBqdzlCYk1q?=
 =?utf-8?B?cnJOMVgwNHpHbzRoRmJ4bUFuZXBCVnZsdjcrei9FOGthQ2U4RkJaelFxS2E5?=
 =?utf-8?B?TnFacXZ0dDVwWEo0THc5T0lqUHdxd0pIclM1SnFIOU9Rb2FVT1YvR0tXdGd5?=
 =?utf-8?B?dlVUSmF0ZkhyZzZ5eDFpM2RJWEFaTVBXK3d2R204ZW0yYTlEV3UrTDdwOWRi?=
 =?utf-8?B?dUp2SnJGdDBNcUo5djN6TGI0RzN4WjNSU2xOV1lyNmZwNVNuMHRLRmhNWjEz?=
 =?utf-8?B?R29yajZ3Kzd3b3dRUE15VUcrOHdQVExLQS9ITzFCV0JtWmpMMmxwL2p3NFY2?=
 =?utf-8?B?d2s2Z1RKclJWM1AyUHR5cytJenNaeENQOG1JTEk0NVV1ZmR6WThjY3BYbXBI?=
 =?utf-8?B?WUFXbEJZZGZTcEt1SjloQnpJM2xCZlVKUy96SzBxQ1RoajRreGxJZUd3L2hC?=
 =?utf-8?B?V3FtdTFsclJ0bW5HNkZCRkZncjVzTkVlUlNjQzhZN3Rnc1R4VVpUWUcxNDc2?=
 =?utf-8?B?NzVkVTRNbXZGTXRYbWhWL3FRMy9tRkVKcjdpd0ZLL0Vwdk5GUEwyZ3lvaFZw?=
 =?utf-8?B?ZzBxbWZDR1AvWDhCYWRMM0ViYjBYTUVVSXMyMVRNUC9lYU5hNXduV1VQRmVJ?=
 =?utf-8?Q?mWJaDmQ+kuQRRkXI8h+aqVZTwfzqNX1h?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c25nLzlFazZDekJYZUNNcjRkY0VUdmJpZmtOS0V3U2JLUmp0UmZOWndtazI1?=
 =?utf-8?B?QlJOWnZWSDBaSUVzRlZnZlB5SVJlMzNvUmhmRkpWaHArc1dWSWlpMW5YaldK?=
 =?utf-8?B?dzhzQVptSVVHS1hUUG4rNU80ZDdEdkxWSkp3ZnViTWFoMmIzRVBOSmNoY3o2?=
 =?utf-8?B?ZHh6SnZGYjBScitIS1BaaEJSbFBGeFdkajlGVlVWU29oLzJoNEgxYWVsNGZE?=
 =?utf-8?B?SEEvV0J3N3BHOVFkTXJqUzNKQW5RQlp3R1Y1WkJPMFJiTG1hNlFjeEtlSDAv?=
 =?utf-8?B?Mkx3MEdoL21WcU0ydFFWOHNHTHAwSHB1L3FKbGJnclR6Vys3bDBVZlVpS0NC?=
 =?utf-8?B?Z2NFT3hrWmlEclU1VzV1M0NLNElrZ1JIK1RkenZycHhhWGppaEJlMUVXUTVS?=
 =?utf-8?B?WGsyRkFUZ2FSamVVekRSd1pydmJZc0xHYjM1WmFGWVpjZ0w0MlZtcVhSVmFY?=
 =?utf-8?B?cytTTWZhTTk2UWQvQ0hjMjYwNHE3bTg2SjRaSlk5cDZxUEh2bVplcjdQOENT?=
 =?utf-8?B?d1NHekdKbEpIczJZaHFTWGsvTG9jOElTSFVRVE5Tc2p4TWlrbXJCYlUwb0tD?=
 =?utf-8?B?NE1jOWJZdGlaUVhmZk5vOG44Q0lUSUVwa2ZtRnAxa1NyYlFOUGdQeGNXVW5w?=
 =?utf-8?B?M2hVWUF5QUQzeERZV3dCNGFlVkhhaUhQR3ViNlBzRnUxZWx2ZUpaMnZnbVlt?=
 =?utf-8?B?ZmtjTU1UTGN4YWE3TVNZbEVCaFlsZitOSjVBZTVVd3NndElCOUlkM0c2K3cv?=
 =?utf-8?B?RGpJd1ZVWHgwcmxTZktCU1BXOXczNlBVb3RMY1BZb3FIeWRac3dwOGJDY3Fz?=
 =?utf-8?B?Rm5BZzY0dXM3VzM5dEN2TjU5Q0tRNGluZ2I1TEFoM09GR3hOWDdjb2Y4dU9F?=
 =?utf-8?B?d0JnOGhNbGN2ZXFZcXdHcUtwQmwxUGFnYmlxY2ZaQjJieVNVYUFFR3VHRC82?=
 =?utf-8?B?NENHV0N1UDlkWGQ2a1JuZmlFdnl2Q1ArSjhKcmJlaTRhV2Q5UGRQczE0UjFS?=
 =?utf-8?B?d1pkREZKY3EvRmFLZy80MXZXdkFzMUJLMkd6aVVYT0tRcUYyM2FkYWNSSzRl?=
 =?utf-8?B?MGQ1SDlibE5Ja05pV0dyTzlUbFQ0ZG1xTUdUU2ZEdm1NNUFwK01lOWVqMGIy?=
 =?utf-8?B?UjFqRW1EK2JFY3hPeGhScjNuNkQ3VzJFNUtOdEp6ZEdtV2JhMkoveExZTGZ2?=
 =?utf-8?B?TGMxeVFrM2xUM2NraEFJalRiSW96My94OVc5ckxOalk0NkZkVkxUSFMwRThR?=
 =?utf-8?B?c1lZSC9jN3l4OFVpK3VXT3VYZTNqWTBKVk1vYlQybGJ1ajE3UW9kV3hmMDNK?=
 =?utf-8?B?MStJVDN3dnZ0MWlrVHg5aVZVZ2RSbXFQVWFHSkVZSi9qS2cvY0xUOUhWaTI5?=
 =?utf-8?B?cG5oc0hKb29QM2lBdUthSnNmbWdaTEdKT1dtVC9nbHNLUmxIUUE5b0FVOENm?=
 =?utf-8?B?UG81eEl2Q3dPWDA3aE1rWEZSUXU5U29tZ1NoSnVrZXh2SDEraXo1MnQyS2Qz?=
 =?utf-8?B?SEJzR1BHTitZQy9aaEdUK2pkQWgxUXBJaWRDUzg1dExzNnVFSVZhL3M2RDZ6?=
 =?utf-8?B?NlJRQjd2N1c0dzR4b1ZvK2pzVWhrU1FYN2JBeXJuVG9BRW5XMWx3eDBvNlIv?=
 =?utf-8?B?RENFaVU0UUo2a3BjSTV3NURBNnh2eEZoY2k1d3ZEQnFUc0tBTkI2SlpxcTY0?=
 =?utf-8?B?aEoram5pUk9MRDlIUCtubTgxbm5nS21UMkpmWmJCT0cvK1AyY0ZPZ2taMmxi?=
 =?utf-8?B?WHZxYUVCK1dqcTA1Q3QydGpiangrV0VZY3RZSjBuZHN6MHEvamlsUGdWSktG?=
 =?utf-8?B?eGFNQXArUVc3ajZJT2toNzRCMloyS1Y1cWtWMmFadWxwbVNkaVJiV0hSaU9u?=
 =?utf-8?B?WXFTamhySFFuUFBVaDNQais4Z2N6ekNobldKbXRXNjcwMXNFZzJQWGcxOEY0?=
 =?utf-8?B?cU5acHNVaWJrUTdNcGtrWHZJVExrcFVCOENQOEo4WVVFeUZPTEwxQzI0VzFR?=
 =?utf-8?B?WFg0YXplM0l6ZEdGcXN6aUNPNFI2eXYvcEhCSjNCcEJPWmxZN25WZ0RXMFlr?=
 =?utf-8?B?STZub1lxR0VkVncwbCtmTXl1dnV3UVhpRzlGV1ZFL3dNbWlKdVRhM2tReFla?=
 =?utf-8?Q?vZlvYnTSK0kSatFlMD82q4N9P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2839be07-7d55-4d72-e787-08de3325ac40
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 11:10:03.8550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74f4S3OiidleoxUx80Yu6DrSVGV3ZsQHqBFxnMzTMb2/eWWsbIgwQF4NlRizLa2y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6226

On 12/4/25 12:07, Christoph Hellwig wrote:
> On Thu, Dec 04, 2025 at 11:46:45AM +0100, Christian König wrote:
>> On 11/23/25 23:51, Pavel Begunkov wrote:
>>> Add a file callback that maps a dmabuf for the given file and returns
>>> an opaque token of type struct dma_token representing the mapping.
>>
>> I'm really scratching my head what you mean with that?
>>
>> And why the heck would we need to pass a DMA-buf to a struct file?
> 
> I find the naming pretty confusing a well.  But what this does is to
> tell the file system/driver that it should expect a future
> read_iter/write_iter operation that takes data from / puts data into
> the dmabuf passed to this operation.

That explanation makes much more sense.

The remaining question is why does the underlying file system / driver needs to know that it will get addresses from a DMA-buf?

Regards,
Christian.

