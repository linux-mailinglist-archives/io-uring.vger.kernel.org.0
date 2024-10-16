Return-Path: <io-uring+bounces-3716-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E0899FD4D
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:40:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62892282770
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 00:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3267510A19;
	Wed, 16 Oct 2024 00:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="rMfxQ2Dn"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BFF1097B;
	Wed, 16 Oct 2024 00:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729039248; cv=fail; b=Ty4CKkHjYUFchs3lJkd934GCAC8DSKJUhv006UZJj5PLz6LOBAI9QgCrXP76aeGuMtXRin5fR5K622rhwR/Ra0vTr/kvpjX3WKgKv9PBB+ICpABYCrt8xOxf4zIMNyGxZM7pkDhGhZkYUDYAxGel75WCGoQKymFW9xrZthMDbmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729039248; c=relaxed/simple;
	bh=Y0yjIqoS5MkvUwadZ0gRPkW6HE4y6kH7r9PqTuCEX78=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IpbDfMOXBjLAVa+U5YxhGllSKHfex+uzC6914iXbU6oD3K6qScI3OoXmmb4oBRqjYdet/sBVASdr5uC45HVH88RjeMMKC6qL5asMAwa4PBy4jV72THALWSjhO1/lGO2bVXXm90t0+jzeJDEUn1cINvIkWsLWIUi6RoWmsm7p0Dg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=rMfxQ2Dn; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2048.outbound.protection.outlook.com [104.47.55.48]) by mx-outbound19-158.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 16 Oct 2024 00:40:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dniZGV3V7ExLcsPBuzEu/izaNtpWrJIv6iQrtXTRTKLKB8Gw0FSKS4QFtEV8Q/e7R69APqmViDKSUwbMQwhu98TokLFKDo7kvwXQweVCjcFREmnz9ITYfYfKnzSNjFEkWT7SFo5UJcXPyl3LnoaB8O2qHX7tGVMD/DY6Fx2LgEiP6jpI6y9rAeGBW8SWhJp2vtLYcXRqh3ko8m3U1eCA/BK5fKwzAY7rxj9glb1//2NHtXdjOtEr5BDDDRW8c5+dFx2dWrX/37fcdJ+mbGAo06kkPMzGSK1I1SR4LZeojiU/pRz2KL6Uo9D/5TZfuIv6RjYW8pWZFdjLTjLng63ULA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NLVM3LvxGrvHga62PH0tR97gsneWEKNf2413xQotjU=;
 b=XcLDFOSAq3Bp42UHpEPbxR5HVlILUKjyk8//iQCDBTnEkgFl8PkWALKy6yztWKg2yj54iGHZFK0YwGcdFdMFdFiMoyqoSx1yfzZ8p2HCJgKI0i510ld1BoZaDv66qTxgzC13TPzacoNcMRB7CdgD0bPVFTgrzowDML2EAx8l8TEVjxcP+wU9OdOVAs/mIwdTaigJH4x1fqsDajdWg5WLZCC/Q7mbiRuxGX9u100pA+pvXzEe45+2xdnH1VF1F9CNhsVltn53vvEaQgZiKuyW9MF13yGBWYnWdLLHS8pvw5N1CrJ0JVvmRLW9xnfKKY5PvW/pJLYp1XhYXVIzDm5iGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NLVM3LvxGrvHga62PH0tR97gsneWEKNf2413xQotjU=;
 b=rMfxQ2DnkcIf7aYeHr8BEJ+jA/y5pwHVJGBvVdKVFx3KklyAH0952YWP3pfw6QWZyCJhS6b/RC3nqBL018z6dVVGBnz/D+5ga9TO4Bajwhr1P3BG/DloFFzl9xTfjkeYTE72KdwwkMmYdxCA98mmkoJiQ+e5TGv3yqwrwE/1qnE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by SA6PR19MB8803.namprd19.prod.outlook.com (2603:10b6:806:41c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:08:25 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%2]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:08:25 +0000
Message-ID: <8e00523b-a55f-4f25-a7ad-4d4c4e4286d2@ddn.com>
Date: Wed, 16 Oct 2024 02:08:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0046.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2cb::17) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|SA6PR19MB8803:EE_
X-MS-Office365-Filtering-Correlation-Id: 1790a961-ff93-4016-055a-08dced76a725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mm52Wk80L3JCSnIzbTBkM252TzQ0TUZubGJZdWx6VEo0U1BpdEJqK3RGWG9t?=
 =?utf-8?B?VkhDRkJkYnpteml2V0p4RmZjeUxPa3JvVGNwbTRJQTFIYUhFSU1KNFBmZk5x?=
 =?utf-8?B?NVJOdTFiN3FUV01HU1pvc25mc2kxZlZoK2NWNTN3aVBLamo2bUw5elRhc1Fp?=
 =?utf-8?B?QXdQaEI0TlBZbENJbEJYRVFmR29BY1g0NWk1TzRGeE8xNzVTYnhDajFQdmxB?=
 =?utf-8?B?M3ZRdjl4OWt5VlZRczY4Z2sxUDltRGJCTHAwVlk4UjBXUEkvajZNR1AwVDY5?=
 =?utf-8?B?SktyWFRGYTVlV0E1blduUWJENFgra05vbGlwcERHb3VFcUw2b0Izb2U2VHhE?=
 =?utf-8?B?S3N5S08zdGZSSVNNT1haUEFQeGE1YWdKRnBHOVJ1Slk0Y0RUOE1PSzVhSGY2?=
 =?utf-8?B?dnJjQjdNVTBBMURzWUtIcWw0UCtaaTYwV1RlSmdoV0R5cHhOSVF3N3E2VVAz?=
 =?utf-8?B?Mm8vRGxwTzY3YXFnSGJXZ3RueGhvb1B5NGZVWDBaZzQzSVNtU1NXTEdMa3hI?=
 =?utf-8?B?ZThRU2Q3ZFdGdW1mNjRGcXRLenBhcTRnMVpVS0k3U3JUSWRIVmNNNkFNSjRT?=
 =?utf-8?B?OFIwT2JDTGFCbGRpZWR4R3JQYzhBblFzUVRwdUUrcUFsanF4T3kxQnkrWHU1?=
 =?utf-8?B?aHJoYmxZbG42c1ZJM0NvMHdWbDh6YjFLVzN4UHdPejdkdlV1WEpCQXRyRGE1?=
 =?utf-8?B?a2VCeHgyb2pYdm5tK2xIaGZPL0pncEwzdzVFclRDM3pLd3dpelN3TENvWmRm?=
 =?utf-8?B?TlJ6OVVYbVo0cEVuaktybUo2V0FkekRWSmdLK0c2WktWWTdJNlVIVlQ5QnYv?=
 =?utf-8?B?VUg3ZU1aaUo2UjdJcy95M25mZ0N6K3htNGZqZjhrb1l2aVVKOUZTV0docnF1?=
 =?utf-8?B?cTZNL2dWQ3pxQjlNdUdpaFhWSkNpRUczTmsyRzNPODg2SDB6dmxuUDdTTFRO?=
 =?utf-8?B?dVErV2cwbEVWcWdaY2Q0VWozVGtObnJGZ3M4M1V1OTZXbVV0Z3VpK1U3Q0Q3?=
 =?utf-8?B?VjZLa2J5UW9BK1NHTTZ3SWxlZWI2SU5aK0tFUkpVWDNyaUM0U0I3aC9OTmVF?=
 =?utf-8?B?WXZQU3ZjdHg4Y3dzUEhVY2NGU1h6VTdkcEV3c3dOWlg2bldKWFFqbng4TjNL?=
 =?utf-8?B?RmpjQzhTci9peU05enVGOWRWQ1BJeUErYWRGeFZOT3FlclQraFFTeW0ydUcz?=
 =?utf-8?B?akh1SVBKMjNkUFo1aHdXbUJDQ3BYanR2NW5nSjJXY3NHS3oxZHRrR1dZRFZq?=
 =?utf-8?B?a0RRTVR1NEFxK2FBcnpDc3RkM0lLZTh5Z3Njbm53VzRUUklwRDZsQ0hPam54?=
 =?utf-8?B?bHlvZmZPcjZreHE0aC9XdnVvOEtqN3VCTnk0a2xqVy82YkZoOURPQ1Y5dS94?=
 =?utf-8?B?emNaV3B1dFVIOWg5NWl3bWo3ZEJxcnBSNE1xUlBLa3FwZDRSOEJPU2ZncTRS?=
 =?utf-8?B?RlNUdFhtWjR3NTdBT0hNVklpanBDaUYzQmQ4MkZzYjgvWVQ2WlM0Wkt2VU81?=
 =?utf-8?B?QThlSTU1aGZiVmpHVnFiaXR0YTR4M3h5ZG1iM3I3SG16MC81cXdtWm9ld0dE?=
 =?utf-8?B?MW15dFFCcXFuWEdiSVRxdlRiSlBNeWFSVXZWcDN4MnhLMVIvL0lRam1ZaERv?=
 =?utf-8?B?cVN0b2EzSnFobi9LQWFFSFpMSmFEUlhXSkFNQXo5eXdDL3A0UFBhdGxJNlNS?=
 =?utf-8?B?M0M4VXRTMGVtUlN2OGRPT1VLSzNvMjh1bDc1dFRVdTkzZEVGaEFDNm93PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGcyWVZLMVJNbkdtQ2F5bjM0MWdvNElMbk9rK3dVSytMeVZKekNHWmlLRlRP?=
 =?utf-8?B?d1huQWxQRVZZeHMyazF4Q0pRa0pWZWVTMHljTXdIM3dNTkJWUUgxNWtqOVI1?=
 =?utf-8?B?K1djdVMvcjRIejJPODhiektSVjM5L29JMnN4dHN3Y0pqSjNXZzF3UU1XK1RJ?=
 =?utf-8?B?aDlJVUhsQzN0YkNrMXhvSE1CVnZEangvRkFBb0drWWxtNXFjbGVLdVozSWt5?=
 =?utf-8?B?RTVkdk4rZHoyVVZVVWpuMTVpOHRjVkRLNnVHTmgzWlBwYXlLMlJHZ3ZuKzFK?=
 =?utf-8?B?Q3dwNVJ6QjdzNUllcEhTeDNyQnFWQmovQ2VzUUVnWlowaDFKN0tlZ2xLS296?=
 =?utf-8?B?K0dSY2RkT3g0ZlZpQjlLMkh4MGhZTVQwR0RpR0JTQ1BXOEg5NXJ2UkxMZy9H?=
 =?utf-8?B?UGRxck5vVTFaclFSb2RJM0JwQ09HT1pRKyszS3QrN1R2MkNwT1cyZlUvTlk2?=
 =?utf-8?B?bGt1UDlUYjhCaTlJMzcyL09EZHU5WlhqaDBFOEhKK0ZiY01TUG93TGIwTGx4?=
 =?utf-8?B?N0lxUU1TRzREbk5RdXdFeWVrMXcvZnd3dTB5WjB2aVZzWnFiL2R5aktXK0Zj?=
 =?utf-8?B?WWN4bTM0ZHB1KzFveXc5djAzYVRaY0l3Ump5S29UYVk4Y0o3UWZ3RDQvZ1cz?=
 =?utf-8?B?b2hva0VZTHlTVkV5bGI0aUlsK3dndWpMMEUzM21xeGJkYzh2SGlBTndlSTYw?=
 =?utf-8?B?cEdMTVJmb0Q4ZEVuY3VaTzM3YU5hTzdFR2c4dDYrNnFzS0trVHQyQVpadVd0?=
 =?utf-8?B?L0I5OUw0dm04RGphZmM3bmhJbmRHcTlLVUFzenlha2pVWVZrV2NUUU8xSDB3?=
 =?utf-8?B?UjRBVkt6Mk1IeDBSek1ldDFzU1ZoUkYyNnFORkxMTWxpQy84OFlYQjczaHU0?=
 =?utf-8?B?ZFJtRkdzKzN5THNnaE4rajVWbW82OXY0WUhrdS9sSm5Da0E3eDFqWS9HZG9t?=
 =?utf-8?B?Z1RzQXk4V3QxbmMxeU9rZHl4OTgvd0tpajJPWTc2cHlDUjNuRWJ2c2RBSENm?=
 =?utf-8?B?R21VTG0rR1BVMnVQVHE3QTJYM2ZlNnJaSE9EZTZ2R0RGdHZYKzhvd1hpbGhn?=
 =?utf-8?B?dDJZQklYU2xwQzVqSzRrY2ZUalltbmYzaWxOa0xOMUx4TXNCSTZZRTduS3lT?=
 =?utf-8?B?UmxqMWdGa0tHT3U4SGk1Vi9SMjhKbXB6bC9UTHlrR0dtT2NxaktSY2VTbUxj?=
 =?utf-8?B?VUpvWXJFZ3RIUC9JSTk5T29vTUg1dXFLM1FvZTU5QWFuSUxPUFZaYldhMjY1?=
 =?utf-8?B?Y0ZCQmVrbTcya08raHlvd3VyT3RFK1d1cC9sblA1Z0VOc3N5VHpINS9xTDAz?=
 =?utf-8?B?R3lFalBwaXAxTXVqY1k1RGdnUGJuczN6VjQwTFE1Wm5UNUM5R3kwWHVjblhk?=
 =?utf-8?B?ODMwc2JEZ1NQSGRNQlBUOEVoR2t4dGo1SXkvUXNESUFuQ21ydnppbUpEUDRV?=
 =?utf-8?B?NVdCZExGZDIwd1NRMGlPV25FRk9Ba2NrSWZCSGhPYUFiV3NFaDVyU0gvcHRN?=
 =?utf-8?B?czZNUVExTUNFOEVadUZCL01xNklXcnpaWmoycm9CenJjRG9IZ0dPYW91UUVZ?=
 =?utf-8?B?SnZTOG05emlRUVIwUlV1NG9oVStOTERjZ2VDYTV1aWlpUjNhMnRjS3pUU1Nr?=
 =?utf-8?B?U2NuM0k4ZnFzb2xnL2ltbTMzbnAyVk1ZbGg0MDZ4WjZmZzk5ZTQ1eUUwMDhs?=
 =?utf-8?B?TS82Sll6WDdHOFBsTjB2OVJieGV0UnByK2JsbFFVODlHSllFU3hpR1ZvbnhR?=
 =?utf-8?B?MHpEaG5PNDM1QkhCZjViTU00MDBDWDJqUVJuQ1Z3ZSt2UURKQzBva1p1YTZ0?=
 =?utf-8?B?TW1ycGxRZitOWjBtUXZXbXBpeFRyTWpqNXFhUlkzeFY1YjhVbVlwemZCNXlG?=
 =?utf-8?B?T0liM1NhSGFrM2ZmUWNKMDh3aDFRNElWNkljcnhGV21EVjdldk9yTVk4Y0Uv?=
 =?utf-8?B?YmdyazdlRFBOTExmNVNQZXVYKzh1em5xZ2Rvb2h5OW1ESzhxUktFb3RpOEZm?=
 =?utf-8?B?ZGxGRVAyanN4N0tFeFg2OUJscnh3eUZidTFBbVdQQllXbnluZ3drSTd4cFN5?=
 =?utf-8?B?S2xVbEwwclhsTUFoU1ArMHh3bTd6ZG52MTN1MjBlVUkvSHV2Y1BHQlNibVJS?=
 =?utf-8?B?bmpWeXYrSXpnMXJkRGVxZUFKdFRJa21ldXNmK01yOEFBdC9IWXlvNFcrWVcx?=
 =?utf-8?Q?by4OPCXnQtGbTcGWkJ6EVSt2sKDrOznLB5GSDigcyi3S?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	esoP6f4pBg0R8ypavml5r237Fkp7wN4QtsHHPTrf45npuEZRN52DUzUfXm0U95Wl+UpkvRlQJMM3NRaPHJ1JddIDG3yDDzCIDBrFqkGXYWNJmrCa4rmJvXfNi4d1NzQ42ugX/W4Dxf5vAMNWUuCQGPuWnfMZ6K99cz0qhlHCxRAfVODr9eUHSmQyFjijqFVbgiGWBJcNm/9kVZrK0NRHyWRz3uXXkTNxKMce7hE45+OH1/DhtOdf5otFvXu3gppPgLbED8BuKQxsmmph2xdw9Z+Lf5g6Anz0EPl2WkXDAe2QQRAdsiWH//KmLhriQjuydMvfetVzZ2vyVqhpuhRSTVtfGdSZFpbCEBpdsFolrNkl9km98ziOWCDYM5VlObw7wUWxChwgu/cZSCv3a8AWbVvUaYXQZEwbLr9x9xfpVAi3k8qKofjqF7LPKWLDr/gc8D8Wum1XRI6naIhV08UNd/pBaq3ZkvcWzEu3xaOfQBS69OKssLQRNVai2oQDn9WW2OSas5hF1X/VvS/xhIGs6HMsZJRYNR+rlb27VB5TOZkswN3jCsMukfGn74SCvpNCPccl1EM9FyRZMr9Q6ZAxJmjVoOlOUnZ9Ocwk7kuEIeN86sEyp+dNExOYMWyu9gSWxBzxxivz7qn1nMdtwif5LQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1790a961-ff93-4016-055a-08dced76a725
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:08:25.2104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6aQHXv5e/mFeZb1vvOnGspFT4B+niMPe30XIXhwUGu+KsdtXFYdmZPYlGI3mU6YZgoZrMCgs9Fm8nUJZopkluw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR19MB8803
X-OriginatorOrg: ddn.com
X-BESS-ID: 1729039245-105022-12729-63188-1
X-BESS-VER: 2019.1_20241015.1627
X-BESS-Apparent-Source-IP: 104.47.55.48
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYG5kBGBlDMINXYzDTJJCnR2D
	Al2dw8Oc0g1cLMwsAs0dwk2djCJFmpNhYAfjKznkAAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.259752 [from 
	cloudscan8-65.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Please note that this is a preview only to show the current status. 
V5 should follow soon to separate the headers into its own buffer. 
I actually hope that this v4 is the last RFC version.


Thanks,
Bernd

