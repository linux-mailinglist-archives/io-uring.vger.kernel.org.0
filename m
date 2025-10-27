Return-Path: <io-uring+bounces-10235-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 85C31C0ECF4
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 16:09:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DF0D8503E31
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 15:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFA52EC096;
	Mon, 27 Oct 2025 14:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="eMPhXjFN"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFCF2ECE80;
	Mon, 27 Oct 2025 14:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577173; cv=fail; b=kcUWeWwJ6vaYoXZWFTfd5HNcrNYkCYEKhI24WrMm0CxDU8a608daldECPNWa9zBxHI30w7dFzbDYk+xMdP+TFilHDuTm0VARXjChqV081R9Z2qT0D5+N7voU0zWXrVP2ij2EwFxz/y8pinDGJ6bpVtZEyUn+DlCFiav0M9j3tiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577173; c=relaxed/simple;
	bh=faf1pcYuP/sIsGqlU0D97eFvkhjMWP44WLmvsYrQLrk=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TNFTKy3me95IEAEUlXQyrElnILSNgxSPKSxvICN1JeGK1gGV3XIPnbuXGxQNVCuq0PgPSY3O5yW+uniza3f9BJfHDB2+dRGHoizZ51q0j7blAmavosGx6OIP5QLeUP2HbXrNQ6IWUaHPt2KVvHEZ1M4q9Omo2t6Nx1KcNg5nXxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=eMPhXjFN; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020101.outbound.protection.outlook.com [52.101.193.101]) by mx-outbound12-236.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 27 Oct 2025 14:59:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oBJcluxJFWxA0xVmPvBzCenSElmNd+nXeLLPzJ5lVCE46B5KDCJcI2/uH3OH1iS3BmXUWOiGb9/EzgzwSggYetHRuv5Kwnb33GXL1RFLck2heh7tFtjeQADogVn7pl2ZwU6C8Sd/lYbxjrgOygPpYmI4OcXAeCgv7wtmAE5g0n7nyNX697d0XXJj3tp/PkmPRdqcnBIJQlgO7SNmMTLkb5g7vG+9z8e52uIxPOYKY7gKP8FzP2E7uyqUWwqv7UZT8vKPF+LwJ2+/7UxhswF4jrEIRTZKxqkAQ5+LP/vhVZVd4PlfiYyeEqyQvczWqQFi7aWUcKfFIc/HeqI8xn+c/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TCrbpSlCam1BCaOS8lo4nVTLCDnNWHsqDSl5r1ObVg=;
 b=I6xYZWd6ONtaOETkAQrIB6dReUQz3eanFotLbrlpDgJucPupoM0QrUF+3ROXNtltqKYfM5EolGdIawUlKUaha6A7fxBoF9Kt7/P8g+SQKjuFA+C+Ax1hukWUIs8GZ2vKPKnn6BJmI7Gm7BYzfMrykukcp8ZDMqrLZuYn8yLPaLOI3uARjsw8UyfXIGF9VcPQK5HNkK8CZ/+m8/yXhMx5+4ukR6wBGKd+Wkwu4MBiF7fKDEvx9+NAYjEBJnIyqFvEKsJoctl5BUGtwh+zfQ3P9lasmjhie/Oq+TPRnTkYwe8VSLZbyLYrBCKyLejL8rTMuyPtxOkTaTJAe7bEsFjdZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TCrbpSlCam1BCaOS8lo4nVTLCDnNWHsqDSl5r1ObVg=;
 b=eMPhXjFNt0utzUs0Guh+nKO8AeVzCFvlQKfkSQH/K09HHG4+CC0A6R+bOLtpxLEK8GKEzpTq9ijAHk8vm5+osR38t6YCjgUnaMXZRpoXL9nPyAw9CmkNyLADof8CSCBNNNIH9bIsLFZ91hEOH5Hb7u65FpKHndQMQ4qk137L6E4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by DM8PR19MB5302.namprd19.prod.outlook.com (2603:10b6:8:1::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.12; Mon, 27 Oct 2025 14:59:15 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.9253.018; Mon, 27 Oct 2025
 14:59:15 +0000
Message-ID: <b2f94e18-7a70-412f-a242-aace942b0b68@ddn.com>
Date: Mon, 27 Oct 2025 15:59:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [query] payload size check in fuse_uring_create_ring_ent
To: ALOK TIWARI <alok.a.tiwari@oracle.com>, miklos@szeredi.hu,
 linux-fsdevel@vger.kernel.org, asml.silence@gmail.com, luis@igalia.com,
 io-uring@vger.kernel.org
References: <04b7104c-95e3-4b0c-a8a2-f240a1994c68@oracle.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <04b7104c-95e3-4b0c-a8a2-f240a1994c68@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PAZP264CA0241.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:239::10) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|DM8PR19MB5302:EE_
X-MS-Office365-Filtering-Correlation-Id: 7542e0b4-7cc2-4bc7-88a4-08de15696533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|19092799006|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bEx6YXdseXQrWGRrZnVWWHZ6TFBoQ09hY0J3bEdFdlMzcUZFMWtyeUFIaW9G?=
 =?utf-8?B?REJvdTAvK0QwWDh0SmNocC92S1U1LzN1MUlkRnVXTXNRUUk2MnJwTytLS2VW?=
 =?utf-8?B?Q1MzS0kvc3NrUXgvM1VwSmw1dnN2Z2lQNCtjMjdjdFAzWlpWbU0rNTBGeTdC?=
 =?utf-8?B?YlhmbW1HcndiVGNYSVdvanpLTFcvTVU0eGhYNUtFcEVsUlVvYUxtQW5Xd3g2?=
 =?utf-8?B?MjBoeWp3SThibDhqZDRQODhkQU9nUUFCR25nWGhkTGh3aGRZSy8wUEZNL25R?=
 =?utf-8?B?SVdpTTd6K1U4V2NMTmdQUForY3V0YXUxQ1ZwNFBxYVptc3d4TEwxUjYyY1RY?=
 =?utf-8?B?dEZUZzdqcURhQVQ1VUlKa3ovajA3KzVEK3NYQXp2bUhmaGowSHMxZmJMTDhh?=
 =?utf-8?B?bVhENFZBT1ZZb0dIaHd5V1Y0YXFEWHVRMlQwMytrNWJ3WVVwZ2RueWVKQk5l?=
 =?utf-8?B?d0xHKytxclMrQ1g3cE1uQTBydUljMi91aXJtM3JMY3lxaGQrcGtnL25PcWNQ?=
 =?utf-8?B?dmtmT29Rc3daK20vZVA2ZXZBaEJwR3hyQU5NV3ZmQWp6TDkzWmJLU0QyR3hJ?=
 =?utf-8?B?RVJud3dvcmhmR2lubU1uSEhjVjc1ZkdySXl0a3p3SEwyZjc2NXZ5MHpQNXc1?=
 =?utf-8?B?N21PUjNFUmdVbUZ0RktvcFFMZ0Z6NmI5amVpRk41MzREeWxYUmZ6a0hKM2lh?=
 =?utf-8?B?TEJiRzM0K2R0U0ZjYWJCZHJJcmFSNmh5NE1SMkpjTFBwN2l2THc4K2pGQUtK?=
 =?utf-8?B?RXMrMUIzNHFXbTd1Z2hSNW1zS21RVWhlWEV0cHhmM21QaXdERmljRXB1aXBo?=
 =?utf-8?B?Sm1aK0d3c3gyeGNZVFJ3RndGOUplWWg1ZUVyRXVpS0NzQ09SSzZHY0lFWG9V?=
 =?utf-8?B?L1FkMjJKS2ZnQVJqcE9DRVIxYXBHR05PdW5TNnpJT2czVVZxSTczQlZsa25F?=
 =?utf-8?B?MkVyVGxocGMyNC9XUmR6WDBkS0o3WldSYS9GaVBYcEFtYUlnbWo0bWVyTSth?=
 =?utf-8?B?R2tUUU84WkRBY2I1a1RPU0diOEhkaVNMQkxJUGowQ3J4V05kUEZzc2pNT0Fq?=
 =?utf-8?B?Q2crYUtDYklGM1JaaXlkVXErMFJpcW1Yd2hYM042eExQelRJcUtmS3lFZzRy?=
 =?utf-8?B?cXVvaXVIZ29uc2F4NS9Ea3lDdjQ4Qk5sU2U4bmFYR1k5YkJ4QnVnM0M2Rm1L?=
 =?utf-8?B?VGR6cnR4ajU1ZlNBWWZwL1RiMDBlY3laY3ZYYkh2R2xyS3pnVlRrS2dNaDN2?=
 =?utf-8?B?UklobnFOaUFaTzZqR0lqaExLbUhJVjFxTHFEUE1qQ0dmYk5zTjJ6OFFYYlV3?=
 =?utf-8?B?MjdGazJ2Vmg4Y1FFQjNtbmQrWTViakpNZzJJb0FYODE2RTRMY1N2UGhoV1ZU?=
 =?utf-8?B?NXdrZXFVSmxIM1dHOEZZSTRXUmI3NlBWMDlzOURLMUtEVlV4TmJsZUtxTmd6?=
 =?utf-8?B?T3lhclZjZkR3T2FlZHNYZ1hPNjNmYXpyQVlLZW5wOEszWWNYOWJBdS8wWmUz?=
 =?utf-8?B?TXNjSUVBQldkUVlOMGlqTDBiaTkybmxqeWpnOXdlWVhHdXY1ZUlCVnQveEVM?=
 =?utf-8?B?cTlyU2hDUy9aQUxvQVB3c3htYzJqa2k0SVk3YmVVQmZDMU9odkhtWFJDN0lZ?=
 =?utf-8?B?d0c1Mng5cXBsUEQvSzRaZXRPRCtIVUtoWTRNYndqTjR4MVA5NkxpY1EraG1z?=
 =?utf-8?B?bzZlOFBSdTZQVTZhZXlsZEVFczhCWExIcTVrTktycGlnQlB4MlVpSWFwKzVO?=
 =?utf-8?B?dkRTb01vRlhkZmxDeGtxcXNqRFdRWTZidU9MRzFPTVkzbUJyTUQ1L0JPNmoz?=
 =?utf-8?B?a1dSOGQ1M0w1c3RpeERsN2s2bnA1bjM1S3pEZVlrZXFkZmRkWmxaWjB5NG9t?=
 =?utf-8?B?R0pydHBkMFVhc3lxVjk2VGJhdC9UdWF4NFlCdkJYQWpxR0xOaXkxUGhFODRn?=
 =?utf-8?Q?xuIN5cWKcjlyTXX9+5xORLpzUPbF81CT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(19092799006)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WE5RZ1g2alRRdkszY1dudU5naDZaODkrZ1drd2gxZ1NFV0lHTnJySDdmcG5Z?=
 =?utf-8?B?Ri8vTFJQaEZUVFVickVOWi9BL01FRjVJRzlUcjJQZUk2TGdoNDgrNG9NUVQ3?=
 =?utf-8?B?cTcvWXUvSzViS2Q3N2VMZzZnNGJjNmdVVEhYY1VtY0lRMTdGOXJHMlpPSmpp?=
 =?utf-8?B?R1lLN21XYjE0UFpxelhHd0dPTkVVbFhDUzQyUTVKdEVzU0plZFFwS0lTeXZK?=
 =?utf-8?B?ZEdDZkZxSGh4TTYvaTZ0ZkNWOVljM2ljU0tSZzR1QUVrZ2pRcFpEaS9IeVBW?=
 =?utf-8?B?UjU0SmN5QWRsckRpcE02cEJBdFh0M0JZVWJ1OGhXV3hRaGdWMnBTbGNMOCsr?=
 =?utf-8?B?YmVOWFYrUmdpYmcvb2ptZGdxcEN3OXZnYU4vajNDcFhVdDZHVEpBMUg0aldr?=
 =?utf-8?B?TlRGQ2tmUFpzUHlRWnN0ZklFUzZ2d2Q4VlVZTHVXeW4vellIVzI1WkVmRkNL?=
 =?utf-8?B?eGk2MFhycDNTNkszVkVWZ1RxcnVBUFV4OGpVSkd2SzNYZnJCa2UvaVJqWllC?=
 =?utf-8?B?YWR3MlROYmg4OVJ3MzU5Q1Eya2hwWmJSMGdaRUorZFpWUFFmZmd3QlN6QTlP?=
 =?utf-8?B?Qmw4K1VrSEcrZXpLbC9XWWFvRFBUaktGNVZIR3FFbERnQ3BEaWNxTEpRMWZn?=
 =?utf-8?B?Z2RIaUVJSENkenI3ZTNTUXFPb3JMc25yeFNsSTZWdUtDdEhlOTBWNHVnUzhG?=
 =?utf-8?B?di9TZUJwTzdQVW9vVll6QVUzWXpBWUJvVFhsSjREbU5Qdi96RE1ZRG1ZcEJN?=
 =?utf-8?B?Q0JYemlWc3BNVlFXLzVOdUR6TS9JZENyN2JWcWNHeUZVRit4V0wxNzlTenhX?=
 =?utf-8?B?Rlp4Sys0aXQyOEFJYjFSR29FZEZ2dS9wQUZhQmFCVjIzT2JUMnMreXVZN2Nj?=
 =?utf-8?B?SGtzeDJ5bXZRaTRkdEFCUWFEaDhsOE1hdUFmL3M3aklSYjA1bmtPbFVIR3Vu?=
 =?utf-8?B?WUpHanlDWUZtaE9BL0kwY3MrYWVMRHF0UFVMVzlrd2lGY25xa25YWU1JRmd2?=
 =?utf-8?B?NWhnbVpGb3dFNzBXTHlQaDliaGVPL0JYMzlFWHpxZDNmaW9MVEJQSE14b1Ja?=
 =?utf-8?B?N1JHYURXT2FWSjg1K2tZVFFZb2NETVpLTzNFTTB1d0g1Rk41RVhBUko1VENG?=
 =?utf-8?B?eTg0aWNLUjBoN0dNVHdyR1lBN0JuaWVzTnRrb2IzMFlPS0NPUnZVNEsvT3k3?=
 =?utf-8?B?dU50QVBxZ2VqdUlhdFBINVB1VTlPZFMwQXY5Rkx1ZzVWNEwzaG5HdnRvbnRv?=
 =?utf-8?B?WUR2K0F6VnIrbWlKZUdwajJBa1hZeWQxaUdXUGtJeXlZbVByOFhDRml3Vk5C?=
 =?utf-8?B?NDh2TlhPUUJxbG5uRlZYWUlUWGtDUU03RkdNaTJxd2d2ajhBZ3VLQWlUb3JT?=
 =?utf-8?B?eGw0R0FnbDZKWWZoS1JwUC9jcCtJRitEUUE4amN2VHNBdnlrbXUwUVo3dUtD?=
 =?utf-8?B?bkRRd1krN0xZYTVWeWRVWWx1SlFUZDlJNlRNdnMrbnFYNHo4U1NheVg2elBS?=
 =?utf-8?B?OUFtSzZUdFpqNGdGN01Va293blVMbzQrZ3FJRnQzaS9YejlGTUNGMVBqN084?=
 =?utf-8?B?RmpyYmZQbGRwcjFib3daTGppd3VDaWNVblFhVEJQMU9HWkNGQlZ0M3ZkTGY0?=
 =?utf-8?B?emYzZEhpaWVNYmxZRnpFbkhidW5EdXY5WWV1RTd4ZWpVWkpJTUlGajFSTHpM?=
 =?utf-8?B?ZVVVd2oreVZOZHBkbjNvb0djN1J2VXhoaEcxbUcwZTdQeGpTYUVDNzhET0RD?=
 =?utf-8?B?dHcrOVRlM2VtanlydzFQMm5vR0haYkg0TEdpaFNyYVlSQmdtTU8rRGRZY0VF?=
 =?utf-8?B?U3F5SXZ4bkljZG15Wmduams5cjZ3djcyZ1ZtM1dmcFd6UUh6Q2VjNlJrTGNx?=
 =?utf-8?B?OWhwUXlMSTVpdGhocjBlQnEvZ1ozTWIvdmRyU0F3aVRwRVRjcFVJWGd0SHAz?=
 =?utf-8?B?NDdTSkIxeDRUTGo3QXlCNnJmVExuTWdpSTFNbTYrdjN4RXFuQmNla3gxUTdS?=
 =?utf-8?B?MHRLSEZiYk5TM1JFRW50d3htamhFTGg4ekZMdElUVlJKcWczSFEyUEZLZ2tH?=
 =?utf-8?B?OXN3MTJhTHoreDBQcXhjdWZ4QmtvQXQwdk1YakNWOUEyZVRMYUJ2UDJ6aC9U?=
 =?utf-8?B?cTl4NndpY0R2Z0FVOCtVL1Fwa2xVUHRJU2RTblFrVmFoUmxrZ2RxbkpWdnl0?=
 =?utf-8?Q?tpYVrm33NZENr+27fJ2zHyMiGJjk57SAtUBnKqWDVf52?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2UIHOGihIGJcdx2SzMn744MXE8ViIezS6rQL/jETCdlxbohMxswdZqY6AN9a4ZQslw1f2bC9AkcH7B60gvvS9iWrK4p+hu6+tK5OAYGfRYTDxvnix1tMHV99zTYvIMYlF1eovtkcrO77YwWN2PrbvsrRM+QpQqYzoJ7CshoipyjV/MUy7THu6zx27XfJI/IyECafOudMJhYrYNlj+edtBRGLj1RrSIh3JQ6wL/XZz4CEy/Z+SNVx55yJCkFHbXIioyMk1cLhyNkxcsbep0ESzrVHnwLnpkmPkVfNhb38W6klomt2BQbgSYujLag/3byRHhckfxtV/EZXIWmrBZxDvPjG2Doo4LzzIMXxjAkJUeSvjF03BlTBG1jz+2F+6CnyxSiOSOFg9fwyB5LUd0qAoGsbT/P3nnpCOWCP71fke2rbZcaY0gDBYAr3wVBbmv+DXcALX7/nU1D+1Zny0BlHhGXzvTuP03/n2oiAic1GvO6D9199k5/ffUKTz2KMPlR7NeChWJdrK3grazlZ9VUuQoC5npEGkRRnZXy1NNeG+iyyGx70ctwch8Hu7mhXzJt6AwzwjmQ9B4VI1+GdGU0QeuMwpKPR4XMQ2s0m/3AXGSSLj/TGl8GBTcClzr8s8TjeLCr2VS/wFevlkhPiqlLl9Q==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7542e0b4-7cc2-4bc7-88a4-08de15696533
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 14:59:14.9549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SoTc3jwtJwvAfg3I5dTBD2kYpeVrZKuyIjA/uOeYgqhi8YHHhkEEXLmO8yByVBxv/D5IrLoTHxxaEQsKgg7s3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR19MB5302
X-BESS-ID: 1761577157-103308-7679-4151-1
X-BESS-VER: 2019.1_20251001.1803
X-BESS-Apparent-Source-IP: 52.101.193.101
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoamxoZAVgZQ0DDVzDjR2CAxzc
	TU2MLM3Dgl2dQyycAiNSk1MTHF0tRcqTYWAEZ2qMlBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268514 [from 
	cloudscan20-62.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1



On 10/27/25 15:49, ALOK TIWARI wrote:
> [You don't often get email from alok.a.tiwari@oracle.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> Hi,
> 
> I am wondering if this condition is intentional.
> It seems that ring->max_payload_sz represents the maximum allowed
> payload size, so rejecting payloads smaller than that looks unexpected.
> 
> Could you please confirm whether the current < check is correct or
> if this should be > instead?
> 
> 24fe962c86f5 ("fuse: {io-uring} Handle SQEs - register commands")
> 
> Thanks,
> Alok
> ---
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index f6b12aebb8bb..4106fc80c1e8 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -1051,7 +1051,7 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>          }
> 
>          payload_size = iov[1].iov_len;
> -       if (payload_size < ring->max_payload_sz) {
> +       if (payload_size > ring->max_payload_sz) {
>                  pr_info_ratelimited("Invalid req payload len %zu\n",
>                                      payload_size);
> 

See the calculation of of ring->max_payload_sz in fuse_uring_create(), i.e.
it determines the maximum payload an entry buffer could ever have.

We don't care if fuse-server made a mistake and uses 
payload_size > ring->max_payload_sz, just a waste of memory then. Though,
if payload_size < ring->max_payload_sz, it could not handle IO sizes given
by  fc->max_write, fc->max_pages or FUSE_MIN_READ_BUFFER.


Thanks,
Bernd

