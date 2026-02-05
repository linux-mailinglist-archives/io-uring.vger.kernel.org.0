Return-Path: <io-uring+bounces-12069-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPC3FIskhWlV9AMAu9opvQ
	(envelope-from <io-uring+bounces-12069-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 00:15:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E243F84A2
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 00:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7E90C300E5F4
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 23:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86862C026C;
	Thu,  5 Feb 2026 23:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="XKL+cxqm"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3802024BBF0
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 23:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770333320; cv=fail; b=gmycW4HiGiIC9YnGn42lCYk0LRJVknBq49f87mSDLkL0vu5y4IkhxWrpwNSTDKXEv9KqNEUPCDxMXKik7Gzaw36ANh7a7rzFzZ7o8dsR/zusfrQ/yeqes/fTNVpg2obv2fza1HkNm/jWMTM8I8haqHt/aaIIqwo6/iJKBMx+UMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770333320; c=relaxed/simple;
	bh=m2eshFH981tYXBZoxZtdqKj5Lp7q2iMBZuKzTwwIcMw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jEqxkU/pW0UQPmr7M5557ypaWpjN0V+IZ5HglKlZN7zHUkxDEJfogRJjve06QmCo7pXAJPrPxRsgzdQHzWolikI92QgRcYeyG7razA5ygStyYH3EeX0eQ8gq3pelH8tOfCPULmYgToD/ZcTAYSDiyZs6SsHKa/ovl2iybPvG8fA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=XKL+cxqm; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021113.outbound.protection.outlook.com [52.101.62.113]) by mx-outbound41-121.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 05 Feb 2026 23:15:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nPj6NKKADOfWYILai877i8wyvo4fh4l0P7njV58kzV6q8MerD8AgPe0eSy0XK5nrMXd6QR4qREhSApKfZo556BSKQmjAmi0URE8vCqk8Wf4vMAR2SCiGpVOWbHjXBkb6rgoSqO8wo7GKIkj+24WlSEwNwjcWZ2kB92ShaDIUA4AoaUa6VOu3yD1EAwMwUiUBu10H6byhHHnmMgoVVZMcKx0yde/qxF2UfIWBmjFsNF0+ONs57Zp5fViqsCoX8YuQaKA5V/688dbjrzI6yyMT+OlJxOJhjorHfZPMjuN8MrBdyZDVqaJaZNfqEK/NpEEWlztgnbr2j7lZ7aBHDDEUtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qqi5MKcWiiMQN3kU/aC4N2/6Msf2+agJxT/xMmoTPg=;
 b=L2GyAkyY2pKBUtxMamXT/DPNrBYwFJGiY6IcFUaRPfq6V5/rcTerJj7HxHa3/nVDzXk4TFMVIZyIVDK2aXMULbX1mQS6GcxzSy8QgnJRDDS1ZXBZYUI675F6atMz+Lctb6icpKxzpNUvxXMjMibVowlf2uYzCuGEvNaI/soFVHVtGGY5fhLSo1HWXtPCNfr8z3Z7V1o+gchMfnM1/mCI/jy0q6KoxTraRNnUoTTDOztdhJPfcoJ/7yvuklpduOcZzjrvhafDEjCWM+bGA+3vtDrB8p+f2BOLqgj+yaPQRIfrbpsqe6W2lGEQduDSHlbOflRNoFVQM+kGm79qKkkJOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qqi5MKcWiiMQN3kU/aC4N2/6Msf2+agJxT/xMmoTPg=;
 b=XKL+cxqmL+0Hfoei4fuo4/JQzqm3N5C3uCCVI7bphM0c0QdAJznSJx7DbP5p+9kUGv/WZs2Oj6Mgo0BbKNQHH1IvSCkd8Ihhub6n5JBQf8MUlmbia0/iggZyL5Gjl/xZhlxYauToNF41VBBz4FNTCMj8+aSSAK7l616sK0gS4Qo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by CO6PR19MB5371.namprd19.prod.outlook.com (2603:10b6:303:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Thu, 5 Feb
 2026 20:42:51 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704%6]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 20:42:51 +0000
Message-ID: <00451717-2be7-45ac-8d15-a5cbd2d1b916@ddn.com>
Date: Thu, 5 Feb 2026 21:42:46 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/25] io_uring/kbuf: add recycling for kernel managed
 buffer rings
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bernd@bsbernd.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, csander@purestorage.com,
 krisman@suse.de, io-uring@vger.kernel.org, asml.silence@gmail.com,
 xiaobing.li@samsung.com, safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-8-joannelkoong@gmail.com>
 <4f96f8b5-7f51-449c-9717-8c8392a3d671@bsbernd.com>
 <CAJnrk1aQs99+xjTy01zTF2MpbaOe-TgkyazJ1pKgkHz+TNZ9AA@mail.gmail.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1aQs99+xjTy01zTF2MpbaOe-TgkyazJ1pKgkHz+TNZ9AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR3P250CA0014.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:102:57::19) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|CO6PR19MB5371:EE_
X-MS-Office365-Filtering-Correlation-Id: 953724ce-17c6-43c4-66c5-08de64f7211c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|10070799003|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RnR4cnRuem84Vk1YbythUUhBZ2EvQUFPeTA4Ym5za2t0NkRMVHBSdW1CSEFP?=
 =?utf-8?B?VFdrMTJuUEVUTGNyakx3WnA0YUU2VllDd3IvMHVqY1liTU9wQ2VCYkFvZms3?=
 =?utf-8?B?b1Q3WElURjJnMHIvS211S1hhMEdYNENPMVA4blNWdmRiaDZJaTUvZVhmU3pB?=
 =?utf-8?B?bld1Z0l5aDhyYnlXeEhWT01VSDVZQWRKWHFKM1FzVnVhVU1aM0RnUHBMQ2xl?=
 =?utf-8?B?T2JQUFBKRVk0UlNaSXZnMEhOVUFxYUxYMUFRZVRUdUFKOHZDc09lbTFvZFcy?=
 =?utf-8?B?VlhCcVVIK0kyRGtTVkl1NHZyQTR3THpzTmhlQzkzdTlTQUg3UHU5YWphWFJO?=
 =?utf-8?B?MHlaNFhSUnNjSzVhT2pkQmtmbmpqVFd4Sm1lcHp5dkwvb3U2UmxSRitQSUF3?=
 =?utf-8?B?N0QvelhXY0NlVTU1Uks3NWVDVzNacm9vRWxwUWgzSzVCRmhRQTZpZmlENk0w?=
 =?utf-8?B?Zmd1QlphTG5idXd3RW5qcW41VEptOGZ2MnZBTlFIUFIrUDNxd2lPWjM1V0xO?=
 =?utf-8?B?NFNJNDJSQVVMbUlML29SZVVMa3lOMjU4TU5UQkt3OEhQbmN0S0R1Tk9nQlc0?=
 =?utf-8?B?UDdLUlZpSytBRm42OGZsaEF2NDVQcVV1TXhmZ0VJaUhHZDdOL0xQaEhyZjIr?=
 =?utf-8?B?NmFEaHZpVk5XTGduem0yVFBhY2YveDBRVVVMbDZLa0RQYy92Sk4zQ2lha1BP?=
 =?utf-8?B?SGNKc3h5WGRyRmxNMTgreUF2VW5ZMEJKMm51OUwyV3B0V2p2Tk5tU1ZMZjdm?=
 =?utf-8?B?Ync0ZzM5T2xFenV3ZTlYL1Y4SXpkdG9Tb1U5d1ZoZVcrS0krQnhuY0xHaVRp?=
 =?utf-8?B?VXh4VnNqN2FUTnFHa3JTcjJPQitRWkhRTEhlNHk5UGJmaTBlQTNVdG1PWVU2?=
 =?utf-8?B?NGxQSmxsalhKa1QrNStmQnIvN1NENG52VTJBbWhwTkFxcEpDcU9vMnlOdDdZ?=
 =?utf-8?B?SEs0U0VwWW9FNWhBbDNWR2hOL2Q4Y2xRMzhNaURPbVpiNXB6bll6WjZZa2VB?=
 =?utf-8?B?d1R0dFdMOEo1M3FTUTZTWnlWUDNXV08zOWN6RXc2ZHlKZ2VqM1E5MzB4MXlT?=
 =?utf-8?B?Tjk5YkI2bWRZcWVQdmV0QWNKOHdqbGM0SUVQazBleC9abDAxK0hlK1RDaE9D?=
 =?utf-8?B?STMrcE5QaEgwTVZhUWJmSC9KSmY5ditDMzRXdTdDcm1udVViZWV4YzBocmJp?=
 =?utf-8?B?aEpHNHRhQWRVZ0VlZWhQd1lYYUhtemxNcWdBbTdpTnNGSUdIYjFaMFNOYXNa?=
 =?utf-8?B?NVZoL0xaMHJHdllCTGNxcHdYUHZsWm44WlkrdjBEWHppcmR4TjkyZTJIbnlV?=
 =?utf-8?B?VTZZZUE5NnRnY2lIRHU0ZEJYTGs1SGZLMlZFSXN4UWNhVFhEcHJOeERnemJS?=
 =?utf-8?B?WVBIdElXUldoajVEcXVvRlB3bVM3WjE1RGpBMmFkbi90bWlBdkkwbjVuUG55?=
 =?utf-8?B?REpaTDJoTm8xTmRDT2FoTHU2Z2tLc1JKbGNMZ0lOZDFHMkorVWZMRHMvK0to?=
 =?utf-8?B?aHIrbVQwOGxaWmZiZU13UWo4Y01lL094aUw5WFc4SmFnNnBjY2xYOFV4QnNs?=
 =?utf-8?B?MGsyVGRGbjNSNzB6dlRHYi9PSDMxdE5MR0M1NHlLSFMrMDlwQXF1bmw1S21n?=
 =?utf-8?B?V3hETjZGZXZncEVVeE5rZGJscGhSSUFueFV3c3pZNFVIa0R2ZTlNY0w1VC9o?=
 =?utf-8?B?OFk1VUVlOTFwSlpkeFJkajQ1T2F4R1kzeld4OUlVWGFPWkRrK0JOd2RwYWZD?=
 =?utf-8?B?akN2WTYvR2o4b1pFRnB6TmIrR0xOaDdQVGM3UC9KaXBTNDQ1MW9icE5VQVNJ?=
 =?utf-8?B?clVpc0FnVXhWZ0NRaURLZmhQcG5Ybit1YzdDQTU1N0Y4NHBKejBUdTBmL1VV?=
 =?utf-8?B?TmNhRlNwRGdJQmt4aDErQmJ3OG1hMTlERGZ6bTZTbithcHdwb1NEZ25yelg4?=
 =?utf-8?B?bzhreks0N0duczJzbEpsSUdRMW0vZTFtWS8wdkpxVG15U2lzTzFnWVN0Z05t?=
 =?utf-8?B?bEpwN2FUQkFBd2NrMnVvNDRhM0pJT1pwVllIa1NwOHFWQ0o2RDl2MHd4clFK?=
 =?utf-8?B?ZEVNazQrZDJiTmRFSUpoSThxWWlSdlhCbnlMRkFtMWZTazRhc3piaERveXM2?=
 =?utf-8?Q?vP4U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(10070799003)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFUrT3ZqRUlONEVDZklrV1ZGenNwbW1pZ0ZiRFRtU0ZZSnRHejdoTGlFaVI2?=
 =?utf-8?B?YlBrRk54d1FBb1ZwdDVPNzhoNEo3R00wamJicjNLam14cTgreUo1UEIvS2pj?=
 =?utf-8?B?bGpBVFlNU2RYM29jTEtmOXk5THRQNmVTWUNGRU4xQkFsSXA2ZFlRNWtKRnZa?=
 =?utf-8?B?cUoydjNZOGZIWGtHYll5ZVRNZVJ4clBNdlhSTThyWUZBUDdYOTk3SFhRNUhO?=
 =?utf-8?B?akp0WE9WYnk5MUVnV0NESHNKWEhmRVlHV1ZUQW9JR2E5a3NOUUdKbGN1UXFH?=
 =?utf-8?B?a3FsUWcrdzEyT1Faa3lRQkdaZHlycjhZbC8wYzRyV1FIVzFNaktzZjFPZnhR?=
 =?utf-8?B?Yit3Q0lteERWNmovVWxTcEN2ZFdqTW1vbWlsbDFrN09BcGMxKzVvd1BrM05t?=
 =?utf-8?B?WGRTbFFCK215bWU2SWVleDlHVTB6OXdXRzNNNit0UEZSSUJ2WE9KeWlGV28r?=
 =?utf-8?B?L3BxUEV5OFoxSWRHM1B4UXVqOE13SEd6b0FOUWsxdFg2YThrOWRKV0JLZ0VG?=
 =?utf-8?B?ZVY3WnlmYlR0RlJ5NGpzMTB4bXgxbnM4Zlh1NkoxUnVPVHpEWFU5azBseFZU?=
 =?utf-8?B?Q1lla0JDWG96SnBuSUFFZ08yeGJ1U3V6SlBmSzhJY1B0d1hEYktheVJwQ1E5?=
 =?utf-8?B?RUxZay9yU3pZM1E2TUtFTyt5cThNQ3B3R1YyOXVpREJrUUw3WWZKUDlwMzY5?=
 =?utf-8?B?WXJlNjhwMVMxdW54eTBDQk9jZE1OaS9kbG1mV2w1SXdDMnA4VU93eE5CUHNk?=
 =?utf-8?B?Q1BYNXBZQTJ2UlN2ZGJseG55N2YrTVVWQ1FtNWJHbGNIL2dIY2pneXV1cnJS?=
 =?utf-8?B?LzZLeWNFYmMvNTZzcUZIYldsMXQ2OWNkbVJER1pCQ1FWRmt1Rkh5VEFOdEx1?=
 =?utf-8?B?cjl5ckpLY2NHcC92dzl4eXVENThXWkpyWjVzeGEvZ0pURjdDbDltdlo2TkRG?=
 =?utf-8?B?NUlsMHJMTXJkem9xOU13K1J3WGRoYXF0ZmNSR1NJZE9nZHdRWmIraUlDVU9Q?=
 =?utf-8?B?aVh6dWtnbjN6Zm8xdWJwM3UvTUp5OHJsci9EZzdMdzJGOW1qdWNsbktqRE84?=
 =?utf-8?B?R2dmSEdoc2dMTXRVcnNFU0NJV2dzRjRxMzBrWjM2ckZhcXpIdlBNQXBTT2hE?=
 =?utf-8?B?WTdRVGlGbE9rTTJSVHdaRm5xeHV2VlFqVFBTT3JwbGk2clYyZnpFVWYyVC9Q?=
 =?utf-8?B?eUlsVTNSblh3NlBhdmtFcG9xLzB2OU9RaDMvZXd2RHp4RmtFaWFUWVdHZ2R1?=
 =?utf-8?B?dTU0OXRkaUgraVo2R3NYaDd0ekZDeWtZR3ByZ1MrMkJGNnJjWDBmYm1zbnpl?=
 =?utf-8?B?enhtK1J4UkZqN1VOeHVkQjU3R29FUmd5dW9NYkd1UVFVQndBRHp2cEdmK09F?=
 =?utf-8?B?Q3lGYzNtbHJCMWhWZGQzZFhsUUJZVm5ieWJiQ3FBaWZWbnA0cXBILzlBYWta?=
 =?utf-8?B?MGlPMlhWcElSb005Z0c2eUNwYTZXWjNIcDI0NkgxaGtPZzZIT0VmRmpuRll4?=
 =?utf-8?B?eWlXVG1xWVhuVWttNGQrb1ZHSFBnRGkzRW4zVUprZWVVZ1UyZUpLdlJicjlz?=
 =?utf-8?B?UDQ0SXZxazFlSjAzbG5KaDdaOVE1OWZQcHc2Y2JiSk1TSXRLL20xSWlxZm14?=
 =?utf-8?B?STRlb1RWUHI3aEJKN0p3M3dmM1NTR2tRZGNvVnV0eithcGdpZFV5MjZuSXd0?=
 =?utf-8?B?bEp4RTRzZ3R0UStWLzg3L3RCSVJiQm5TeGlEbTBTWUY4SFNlcE9tdk8zYm1E?=
 =?utf-8?B?Q2t3Rzk1MUJvQU5nNkl0b3lxeERabDlENm9EWFNhajQ2eUFub2xMQUlLVkF5?=
 =?utf-8?B?aEpYTkttV0poQWd0b1R1VjlSMTd6MjdWMVRtbEFLUyt6TDV1L1I3Ry9UL3ox?=
 =?utf-8?B?UjBlRmhCS0FXYjNnNFNJZVJoYThYajNLYTZHYW5Qb202K1RVY212Ykk0OFdy?=
 =?utf-8?B?Tjk2akxqK29KcFVTOERWYy91YjA0TytuSyttNktCb1ZuYUkzZDRZMFFOWVRt?=
 =?utf-8?B?Ukk1SEgwbzhlK0hEUU1nT05vQnFGcnlIbEUrS2J4ZGRhcmlSQmREMnoyMlky?=
 =?utf-8?B?Q1hyS3FnOHowNjZrOEUrNkFnN00xVkJXVHJxZnBkai9Bc205SWIwaEp1TENr?=
 =?utf-8?B?WnZrUllzVFp4YW1lZGxrY0cyUGFyZ01IL3REMkpXVnRIR0cwOERRdGZmSDNm?=
 =?utf-8?B?MTJSUHZudFVXeGkvaVk4dmMvVjVGZklxQnhqNVpxL2Jta1VuOC83akRqODZM?=
 =?utf-8?B?QzNnb0VXb3ZtcHFqQ2QzVVZxNk9nM3cwenRaQVNtcE80b0grR2tvYXlmcVFw?=
 =?utf-8?B?VEVnWkNrbUtYRkxHQ3B4TVVESzdBbnUzYlFDdlZXbk1JK0F4TEkzZEp3b3FY?=
 =?utf-8?Q?k7lSym9hMpVO/27gwYHX9qWOMwGOI9qdCM4jSxBaKdOO3?=
X-MS-Exchange-AntiSpam-MessageData-1: q8ycRP1tL8ObKA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kK1GosraD1BOIwW5rZcqHyDrPJjynNbkisV8ksXI1MixDa4w9LbwXrJnBaVSf5/PrtJawKg3OYbuw43BIBfh4q0nyIc9PviBzMiydJ5X5f6+HdNLDF0PZrg7kreeEUiWGN2B+uoXJTrJ9Gy8OluNcZqkSWImB+1Q5At2bjRBrorjEBuPvxkismHotx0lq47WYLspSjVzEYsEcFQilSl+OpwwLfqAics6KbKLnP8JQwgmUPZc7tbDkxaj/KU/HWnD99W0BfERZombb3ORWZNO1vXR0WBvNezA7Ay9+UWKP7d6jG8I/NImyAsje8b9+9Un0xF8I7uzn20i4vngq5pXe9wB3iuaAb1Kj2NJ4n0cZH/dMQeZj3is1LNC3e8z+IHYsbVFNyTqkBkDHxXfaIVl9bXoMPZCKZM6YwWOch/+Ow4M34xBWhohs+lmUMMFlNIrsXEHnoMjUI9O1WlHlOvcURkLrtQEBqqdNcNzksWJrHFwLOtFmWoJZbpDUPb67kkRBTsMIxhAgJFL9ZKAlmpuYEjpkShWL+G1KxTPHjiZEBqwBCYtuQLiMnKqfZlBaIRxdZvsNQEEGz6Z/H8yTz78BAe+49vIt2KksYILzAsPL0KpfPMfXyCltZnXQw4mWy/ColzMzc3RHlJJZS4mZiAHGw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 953724ce-17c6-43c4-66c5-08de64f7211c
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 20:42:51.1168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jcDGewXwQfFf2QKj0cI70GhVxjYNLpJUP4WwjNUYsIeZ+Wp0oBCxSIhnY36ZA17Lp7qkrYJ9DX9KxsjA6r/2rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR19MB5371
X-OriginatorOrg: ddn.com
X-BESS-ID: 1770333318-110617-7687-35589-1
X-BESS-VER: 2019.1_20260203.1731
X-BESS-Apparent-Source-IP: 52.101.62.113
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsYm5oZAVgZQMDHVItXI1NQoxd
	jCItHMJM3SwszYyCLNzNwgyTAtOSlVqTYWAFhFWvhBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.270927 [from 
	cloudscan23-197.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[ddn.com,reject];
	R_DKIM_ALLOW(-0.20)[ddn.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,bsbernd.com];
	TAGGED_FROM(0.00)[bounces-12069-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ddn.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bschubert@ddn.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 8E243F84A2
X-Rspamd-Action: no action



On 2/5/26 20:47, Joanne Koong wrote:
> On Tue, Feb 3, 2026 at 10:44 AM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>> On 1/17/26 00:30, Joanne Koong wrote:
>>> Add an interface for buffers to be recycled back into a kernel-managed
>>> buffer ring.
>>>
>>> This is a preparatory patch for fuse over io-uring.
>>>
>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>> ---
>>>  include/linux/io_uring/cmd.h | 11 +++++++++
>>>  io_uring/kbuf.c              | 44 ++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 55 insertions(+)
>>>
>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>> index 702b1903e6ee..a488e945f883 100644
>>> --- a/include/linux/io_uring/cmd.h
>>> +++ b/include/linux/io_uring/cmd.h
>>> @@ -88,6 +88,10 @@ int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
>>>                         unsigned issue_flags, struct io_buffer_list **bl);
>>>  int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
>>>                           unsigned issue_flags);
>>> +
>>> +int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
>>> +                        u64 addr, unsigned int len, unsigned int bid,
>>> +                        unsigned int issue_flags);
>>>  #else
>>>  static inline int
>>>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>>> @@ -143,6 +147,13 @@ static inline int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd,
>>>  {
>>>       return -EOPNOTSUPP;
>>>  }
>>> +static inline int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd,
>>> +                                      unsigned int buf_group, u64 addr,
>>> +                                      unsigned int len, unsigned int bid,
>>> +                                      unsigned int issue_flags)
>>> +{
>>> +     return -EOPNOTSUPP;
>>> +}
>>>  #endif
>>>
>>>  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req tw_req)
>>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>>> index 94ab23400721..a7d7d2c6b42c 100644
>>> --- a/io_uring/kbuf.c
>>> +++ b/io_uring/kbuf.c
>>> @@ -102,6 +102,50 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
>>>       req->kbuf = NULL;
>>>  }
>>>
>>> +int io_uring_kmbuf_recycle(struct io_uring_cmd *cmd, unsigned int buf_group,
>>> +                        u64 addr, unsigned int len, unsigned int bid,
>>> +                        unsigned int issue_flags)
>>> +{
>>> +     struct io_kiocb *req = cmd_to_io_kiocb(cmd);
>>> +     struct io_ring_ctx *ctx = req->ctx;
>>> +     struct io_uring_buf_ring *br;
>>> +     struct io_uring_buf *buf;
>>> +     struct io_buffer_list *bl;
>>> +     int ret = -EINVAL;
>>> +
>>> +     if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
>>> +             return ret;
>>> +
>>> +     io_ring_submit_lock(ctx, issue_flags);
>>> +
>>> +     bl = io_buffer_get_list(ctx, buf_group);
>>> +
>>> +     if (WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
>>> +         WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
>>> +             goto done;
>>
>> Misses "if bl"?
> 
> A buffer shouldn't be recycled back into the bufring if the bufring
> has already been unregistered. I'll add a WARN_ON to make this more
> clear. For the fuse case, this is ensured by the kmbuf ring pin which
> prevents unregistration.

It is a bit confusing, because all the other conditions first check if
"bl" isn't a null pointer, this one here is the only exception, I think.


Thanks,
Bernd

