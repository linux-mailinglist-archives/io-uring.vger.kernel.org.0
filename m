Return-Path: <io-uring+bounces-8426-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E5CADED8A
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 15:14:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75ABA3B0F1E
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 13:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4447E13957E;
	Wed, 18 Jun 2025 13:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="SsljEiDz"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A984C9D;
	Wed, 18 Jun 2025 13:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750252457; cv=fail; b=SDp1x19yYjxHKUUvwET736DqwP2LaulFvyokfndZqhNzVlwnTo7wzSSzTyb2MDQjy86diHPlIv4/I/uZ1pmpfeL/lwP8BTGtZ2V8hC2BDZxVbCGhjplidfJfHqB5Ax2DX7jQHcNKaRRZbLVws4EPeIp3rZpaeYL2bHZOYyoydAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750252457; c=relaxed/simple;
	bh=uQiEDQEje8GIKu8bD/VrhvWmjgV6MIVDciEG7DbeCII=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bAiHNK4a1f8AFdy5jT77kYa8oranzr38iJuCZ95XFcFf73oN8QN31yDGWtNWo8h3qZ8Tlyo631Lc1wP7dMBIi8FttP0DoQ17xVvMOrKRL9IQo7yI63YuwjwhIl+LBMUTsfcRtLXH7EDVNUk+xVV2KpovWmP0nx9Lcr0DtoQANm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=SsljEiDz; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2137.outbound.protection.outlook.com [40.107.93.137]) by mx-outbound46-223.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 18 Jun 2025 13:13:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LauZAfZUbJr16bDs2K+ClKKmqhDhSug1/vOV2JV8wASFrbmBs4+lyfX1LScPSwR+5gOM1lqc5fdnAhnmGbJAtkOe+Rdc0xOv1KKEs9rogKj0bxWME+Zb6XfgWkm9MfTI0w4ekjwaCmZ+S51aGBx8AjIpFwsIgsnAkmN9OYl+vkEIqz2DBmESh3+tta4hQJ62rMVewcGl2lqM20ra30OEwC+K1iXQLI5Y3u5ODwV1uxQhUsPl7M0BtGajJ8jG0TVxyN76OXH6aa3gtFdC2ibqTZJm0/BrhX994mn0P5PupXBYYhKY23IYk0qA6CCSTWpnmYmXYPps0pktim512FGtaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UY0pZJbcEHbTET473J9zEo+Y1vPhWJ/F/ulSW07QdYw=;
 b=yEtCbhq/eI+48Xsd03gJvdonuL+N1y9lsnymD5+YKOsKiMan/0wMiySlV3porN/WBDVblq60D8vwZ3NUr7pBL91voArAjMoMewnrjvNOe9xF2266524IIsCnwMG0EcSiZuSD/tqObOoot9hWfLTL+6YC9Kgenm4AT8JVKQuC6rXIqka2yMXMjfDGhe3LvE+8BLE6YPnBmdGwuRy/OsUnr7T+SOZqKcwg5ikpUXnthTuKuUEh6FJ01UlLOLKznqP+v9jvAh0YAmpEYVumF1TEHS19b2kVYm6UQRQK78lKlOME+HStTPiulhc7RB56hQ2cLPwOanGc/DdfRYLxdYWqYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UY0pZJbcEHbTET473J9zEo+Y1vPhWJ/F/ulSW07QdYw=;
 b=SsljEiDzfDIjlRL/E8l8u0ZEiH9O0dpqLT+jQP/fPCJjZZcoZAzXKkbHhoGqgVhoHIqhhW+kbJPyLICBxcShsJganDPWP0BsEMwygPazrFlE2VsAZi85wWQVFN8i76sos9/WYtNVAmjIxo1uxUMAUkYPJ5Q1t0jhnoSVHpWyHSY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by SA1PR19MB6670.namprd19.prod.outlook.com (2603:10b6:806:259::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.18; Wed, 18 Jun
 2025 13:13:47 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.8857.016; Wed, 18 Jun 2025
 13:13:47 +0000
Message-ID: <dc5ef402-9727-4168-bdf4-b90217914841@ddn.com>
Date: Wed, 18 Jun 2025 15:13:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring.
To: "xiaobing.li" <xiaobing.li@samsung.com>
Cc: amir73il@gmail.com, asml.silence@gmail.com, axboe@kernel.dk,
 io-uring@vger.kernel.org, joannelkoong@gmail.com, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, tom.leiming@gmail.com,
 kun.dou@samsung.com, peiwei.li@samsung.com, xue01.he@samsung.com,
 cliang01.li@samsung.com, joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <CGME20250618105918epcas5p472b61890ece3e8044e7172785f469cc0@epcas5p4.samsung.com>
 <20250618105435.148458-1-xiaobing.li@samsung.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20250618105435.148458-1-xiaobing.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0413.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:39b::25) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|SA1PR19MB6670:EE_
X-MS-Office365-Filtering-Correlation-Id: 70e5dbdb-25cb-4591-5311-08ddae69f586
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dkFmOEIyeTRDOENaNitab3Q4TEE4cWdvZUZxcVZRWjE3Y1B0U2NoZVNwdGY5?=
 =?utf-8?B?eng2WUlYTmlhL2tTOThPcUtLWTJERENjcjhjVWNJbHJvaHlsakFxMExkQlFE?=
 =?utf-8?B?MVQwWFhYLysxbnFCeU5VN3FKR3ExOFdOYk1SQjlyNlpwcXlHTzlRYTdURzdC?=
 =?utf-8?B?QnZFVXNOWUJFTThLQTlmOTJNNkNhM1BuN1hpc1dQK01GNiswUXZPcVVQcDJ1?=
 =?utf-8?B?UHEvMFREamNjZTYrcTFuRHd5SzhhMytBaTNiU3hmM20zN2JTQ0l4UTk4Uk5K?=
 =?utf-8?B?L2pJTW95QTRWL21pbXVWV1Nzb0JrZWdhdm1zdm1ERUFLWldlSlZRZ2RpWVRR?=
 =?utf-8?B?cUxnUURPbVZkRmFOQy8wUmFjS3JyNXRkL2lrQkVJcFlEMnN6WWw0NDBXZGVC?=
 =?utf-8?B?aUFCTVV3UStKR1dveDAyMGUyTUhHNmdCamdLQmZZeFZYa3BnV0RieWNxK1Fy?=
 =?utf-8?B?cEdFdjVYSUVDdktqSDVibXhuUmlzdWJFM2t0U0libCtZcE5GcGxMNU53OGpJ?=
 =?utf-8?B?QjBUenRLTlJzSllGa2RLdnd1enorRmV5SEVjNzg2NnBZbkFVTk9NRkNsMDd1?=
 =?utf-8?B?OUh0d29iT1BTZXVrM1N5OEptZXlWdGthNFhwTmRoVHBRNm8xa29uVWV0UGxV?=
 =?utf-8?B?OTBodWkvdjl4UVRIUHZlM0xYWklxRUxCRHZLR2pvNnFEWWhhYUUrdUZlT1dk?=
 =?utf-8?B?bEtPbW5LdVhpK255QWtWSDhGeVVuWElNUWpXTS84WFJxWEt6NHA4UHExT2FL?=
 =?utf-8?B?b2FNOUNpODJPRmFpNkcyNHN3MEcyR2MwZWhJbW5nZnVTZ0dOZnZrZ0JDRk1Y?=
 =?utf-8?B?VzFITG1WNk53MysrTWFPSzVoTFJXTGp2bStSQlc2ZGxqLy9VcUZsVGwvK250?=
 =?utf-8?B?VnRjb3JuZXc0LzJMeXFqRHNJU3M5RHlBNitQVjJQMXZsZHY5eXdPWUNZbzMr?=
 =?utf-8?B?Q0JodnVPZXlmS3ZhSDhNaHVuZjdtSDZ3VUZUZzNqZHQzSXhNMHdRQU9xWDRI?=
 =?utf-8?B?SlJUNnVBc2hVcmFzdVBod1hkMnFwcnk2TnB1WTBHdENQclZabFRhL3M1QmtS?=
 =?utf-8?B?aVZoaXlpVnhRaHlIMzBsMFM4YXhZRVFacmVpemttS3pvZHZDNUpWaDd4US9H?=
 =?utf-8?B?YjRld3lYRHpHNjROUXJxTzhDaEoyWW9nVmltSjM4ZTQrNzV1STc4bUhUa2pY?=
 =?utf-8?B?cG5hOWFXSlhkbDJlNThjSm9waU4vWEorTlJWcFdvSVhsbzdYQklqcktFSG8v?=
 =?utf-8?B?MUlJUG5oM0NqdXBNSmI0MUkrZ21oeEMxOXAwNVBkQjQvWkx1cXIxWHNwMHcr?=
 =?utf-8?B?L0lGSmhOejduR2FGUTM1MS9ZcHl6WGVEQldVNVByMjR3WEF4bFViRVBidXFR?=
 =?utf-8?B?MGtPeEx6V1ZOdFRHaXBJM2RlSTNLSmpBazczTGVIZk5jL0ltS2pVWkRBOFBG?=
 =?utf-8?B?eEsxS3V1Um5nSFV4SHhtczdXZXJCdGI3RG5kY1I5TS9GMnZuNDBiVUlrV21U?=
 =?utf-8?B?dEI2b0M1OWVRa0RFcEhsR3Nwb1JkRHMyWStjZkpCR0tjdUhGNE5CdXBTK25s?=
 =?utf-8?B?a3dzWVZwWVJLYjNLSEorTjc2dkYwWml5NTNBbk9TSHdwR1BSdlhLRWVLWXNK?=
 =?utf-8?B?VVh4a2svTlNldXQ3L0M3bUVlbnpuTmRCbVhiRVBrK1B3MFBhQXlRZ2puaTdp?=
 =?utf-8?B?QnZENDduTzQvWWtlZUx4RXMwY01RZjdsS0J0NWRSMzU0RFF3NjRjTTgyU01W?=
 =?utf-8?B?dmw1L0VaYTlpZm1VMTY1bTgva0hzQURSdzNQcFc2THJsWC91SnlIcmFOdDNH?=
 =?utf-8?B?UHc4QTZTTllLN3I1eGFicFVBaHBKZEd1ZFRKRlVYTXhmVjV4VGtUMzBBUVAr?=
 =?utf-8?B?N0YweW9CdEpmUkE0dC9iQVY4S09YMU56dTl2OWd1RzBpV2lMUUxEcHJMcFBW?=
 =?utf-8?Q?r+FYAUGNNQw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0NIUjYwWFBEUG5BWW0zMDYySjVvOHo2ajE3Z004Z0N6bXptUlFNTEUrelVJ?=
 =?utf-8?B?ZUF0VDk5MWM5MVlkb1RzdVpuTnJXNmE0MVU5UVFVR0dxbi9HMncrNGdtUnYr?=
 =?utf-8?B?dkR2Q3dJVS91OEVMKzU0Vi9ZTVRqV3diS2RTQVdzSUs5bFFzcXRhOExFL0ZS?=
 =?utf-8?B?eWt2QVZLd3p3NXNiY0pHRWpzVW5sdjVPS1hlcFhWLzAvZDc2UFNDL3NCSVpE?=
 =?utf-8?B?Sjc0ZEY5SkRUWnlTN1lPYXErc1VsOXQ4YlFScVJwa3hqQlpXbWoyd1RYUGNs?=
 =?utf-8?B?UW9TQitScE4xK1B2Y3R2cjRqaDlBZWt6S2VIakttdktMM1pabm9qV2F5RTIy?=
 =?utf-8?B?RGdKbllxaWdTN2puTWNLd2E4eEREMWJva1ZDZnVOalZIN2tXdW8yWUhiSndm?=
 =?utf-8?B?cUplVmUrdmdXelJVMCszUThaRHZjZnZSQUZJZjhTazMrbHdsQ2xrMVo3cEh6?=
 =?utf-8?B?Q0VvQVNjVHVLTU9lZGFsVmZWZk4vdG9VaE1iYnRiTVc3WmN0LzZsRVJPb05S?=
 =?utf-8?B?WjlUMzEyTkRUOGV0OUsyOEpabk90ZzkyRDIwMmZrU0JyaHdveDRFdjB0emtv?=
 =?utf-8?B?SUF3MEJ1ZDR5SSsvL2VhbnhTRysxTUEwTWpKVXhFVk9QaGdVTm1IYjVzTUQr?=
 =?utf-8?B?ZTRyblpQZitOY0NQQ2pRUVNnbUJ0Q1krOE16dHgyTm5DWlREdmxJT2tTMEFz?=
 =?utf-8?B?Zlk0TVV6SmZ6amlDM0I3SnAwdGRPcFg1V2Y0UjRJZVgwd2tVSHcvSk85cXND?=
 =?utf-8?B?cUh6bVk0RXN3NjBKMXFhSFF4Z2lHSnFZMzNESXVyUmZBZVRiZmdZM2M2WTFJ?=
 =?utf-8?B?eWF4NWR1UUxreVZYa1k5dURXTGtLZ2dwSlh3akJwbUt4V3NKZlg2akI2NzFH?=
 =?utf-8?B?VUpaSlFCczFhSGRNNnRObU13ZVhiSzVoTERxMGlJSlJZa3hjN2ROeGtUYnJ3?=
 =?utf-8?B?NGsxbll4TjZreDB1TWFTZzREZkFkZmxmdldaamdjVmJYdU1YYWRuOGpFSmw2?=
 =?utf-8?B?akF5VEQyOTBvV1ZtVUpLcmIrVjNKUTlLZ0VNWmhLUFVHLzQvNlpiWmlsUWhu?=
 =?utf-8?B?VldwSU9wUDB5d0xQN21YSWpkV09UUEJsbW41K1ZOK08ra09kNlpPUWRvdEYw?=
 =?utf-8?B?WGtITGVqS3lzcDBMTlVyUTVpM1ZQZithb244M0lVLy9wYUgyUGlwL00zeGc3?=
 =?utf-8?B?RGZSa2Y3dk45ZWZsSkZSd0JrU2lEc1lhMC9YRytjQ2lmdmFEL0xDRUE3YjNn?=
 =?utf-8?B?M2hVcEVCT0s5U3JGMUNRQ1BISWVLTFJjbThFUzlwZjJxa1FZQUlyNllPbC9p?=
 =?utf-8?B?bkRYU3NHR0xneHZ1bmZZRUpSazlWR1puMUU5VVN2SVBhajQyTHhlNnVFVmpP?=
 =?utf-8?B?Q01CUWovR21TTjdEcVpOK2tObEg3UlVXZ3JkU3V4UmFQVkZYcW1ubDVwRCtl?=
 =?utf-8?B?SVpDSVlWaXFRcDhCdm5nM2xBVWhSU0dKWGk3L2pDR3puRUt6WlJ3VHMzMHNU?=
 =?utf-8?B?TnNqYlJQYkJRMmxwbkd3MVllcDZLaU4xYjRNaUpvR0U2TDIwRWN0Smh2dUNQ?=
 =?utf-8?B?bS9jTmxQVjUvaVhkZ3E4TXlZVTlIWWZFSnM5UTFsZlNMbW11K2VEODJGRzI2?=
 =?utf-8?B?VUFIV1d4bEE1YUd1MVNtTXZSNys4TjZreXVzcVZWaEdWQmsrZVdzT0FSNXNJ?=
 =?utf-8?B?Ujk1aHk0NHJRenYvZVhkNXR4RFNwV2UydmNjbXJlZlRnenVsOFRsSUhac25P?=
 =?utf-8?B?RE5aMHBJUVNwWHpNNDhrWGhjWGRaS2ZFTVVYbktXMEJCSkNtUmlmSTVvc3Zx?=
 =?utf-8?B?WkZlcml4Uk5idExJSzd3U0MzUEVLQUZVNW90RmdwcS9YbWgrbTJRd3hOeU5v?=
 =?utf-8?B?WStlSDg1bHJPdUFsdnEyeTEwTGFXQ2lFcUVRd05EWEdDRytudWRLMXVnNkJK?=
 =?utf-8?B?aWV4NnB0a3pzVEhlWUl2aEVpUGlpWVp4bmZrYzVsZEJaT2xEdHZmTDAwRnFP?=
 =?utf-8?B?b2lxQ09JNmlCZHFHMmJXODhTSjM0YlA2eGlyMUdraWo3aWJ6a2YyajZOYWJM?=
 =?utf-8?B?QjhXREJab2c5b3FwS25WVkROVG9FR1RHWnFCcm9aM0NibGRqa2p5bWNzeHB6?=
 =?utf-8?B?eFljRDZSQStodDZoRVN6VHM4QTJDT2lmNmdPME9RWW1uRzdSZWtiNmlSTDN4?=
 =?utf-8?Q?n2jm4hgxxoiVlIZszbLMmTD4baZuveVQvJ8pRBzGZr3F?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lOoBS+tHAWkabDksw6WRw4Bpiol1m8SSv7jfHCZjHMiZHnerY+X6t4V+h5hJr7EDyKEcEpzsrnnLj7YCAvY4vzjwGXHi4PLoxkr4iglEKMwoqTfuF3mDIvuxJ314KEdRVCZdHQxWKPqGXwJYCX8P70oA8tOfahPwgtoixo5zQ1HycYVY6pEa6SZ62dnGYXdYI5Nh/ptxIzXY3MaK0/Oqaz/us/1ybhweTgg+3OVbi7UGqrhEaXUyN6lilqq9i0ASKDI3ZfVojABGht/MDKMhg/5CKhOExES2BKPJvBINP2uvp4YDCLSf0oGL5sn/hNXS4MI1YfPuFRj7ON7SDTjv0s65+JAVmdZlc6ogb33I12Zr1sZIblbcBVvb/+grfwMI7y6QYqG4mYuCifdL1VGDarcMf/PKdKsIipKScMHQVtLYGNN7xdXZvrwnQpa6PGiW7V6d2UjIj8z6F4yhWQ1HlduJrPBA0/HTAoeAMAbBWqGtjYI+RPFWifEFZxpaPvesSb9GdqhUP61vSfFeMvcxahS+QArpi1HCa7vzX/GzlsVAU0ZGoGCEkvstR6CxHeef851W2wNFSp+HkHP2dE1FcmTKweUWmDNnxee3wE93adsyeCV+8oodHW27fO1rHRm9dcZdGxJ72viRPS5NbqXFaQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70e5dbdb-25cb-4591-5311-08ddae69f586
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 13:13:47.3449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2unsR1/qRu7szE3xYhtmu7O9WUGeI3kUdYbthFTwysubgJ1vqM6jp5raNj/K3RoMOhkMQfF4muoTh1UK9enkuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR19MB6670
X-BESS-ID: 1750252430-111999-7687-17036-1
X-BESS-VER: 2019.1_20250611.1405
X-BESS-Apparent-Source-IP: 40.107.93.137
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoam5mZAVgZQ0Mgg0TTF1NDAMD
	XR3NQi2dDc0CTJ0NAoNck4MTU5ycBSqTYWAKtO7JNBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.265424 [from 
	cloudscan21-112.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

On 6/18/25 12:54, xiaobing.li wrote:
> [You don't often get email from xiaobing.li@samsung.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On Tue, Jan 07, 2025 at 01:25:05AM +0100, Bernd Schubert wrote:
>> The corresponding libfuse patches are on my uring branch, but needs
>> cleanup for submission - that will be done once the kernel design
>> will not change anymore
>> https://github.com/bsbernd/libfuse/tree/uring
>>
>> Testing with that libfuse branch is possible by running something
>> like:
>>
>> example/passthrough_hp -o allow_other --debug-fuse --nopassthrough \
>> --uring  --uring-q-depth=128 /scratch/source /scratch/dest
>>
>> With the --debug-fuse option one should see CQE in the request type,
>> if requests are received via io-uring:
>>
>> cqe unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 16, pid: 7060
>>     unique: 4, result=104
>>
>> Without the --uring option "cqe" is replaced by the default "dev"
>>
>> dev unique: 4, opcode: GETATTR (3), nodeid: 1, insize: 56, pid: 7117
>>    unique: 4, success, outsize: 120
>>
>> Future work
>> - different payload sizes per ring
>> - zero copy
> 
> Hi Bernd,
> 
> Do you have any plans to add zero copy solution? We are interested in
> FUSE's zero copy solution and conducting research in code.
> If you have no plans in this regard for the time being, we intend to
>  submit our solution.

Hi Xiobing,

Keith (add to CC) did some work for that in ublk and also planned to
work on that for fuse (or a colleague). Maybe Keith could
give an update.


Thanks,
Bernd


