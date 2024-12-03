Return-Path: <io-uring+bounces-5189-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E7E9E20FF
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 16:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13811B26618
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFF21B395E;
	Tue,  3 Dec 2024 13:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="la68cZw1"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607E02AD02;
	Tue,  3 Dec 2024 13:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233767; cv=fail; b=JgnMXAE3SaSymIqByuCrQgZOg9ffSdj8tuVCqF66peSbJi1DH+yJQv5IpYs/HLabVL66wN8K0P02MgA1ZiJ4OJ/iyA9u268EiTBPzH2dLTn7rSEiB+qLnbWvKvB3Psk5vO4TwixgWymlMeLXsg4iHxy2klvYh4VRkRpiDvrQKe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233767; c=relaxed/simple;
	bh=6s6LeMxc1PryUHhLbOvGDVvPAV6BN6T9r0bHl4XJF1Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YqX+DRPeDiWcL3J97nuGOmHShBQeSNTKqx9ID6sgck7CfoduaJsbr+sMwp9mqxyspVZcxNtq2Lu7ScZ7+EPRzQJBKB8SH7ZOeV6+0tQ2CQhn9aFSel8nYulicwmYQu5inu2eqZpDKaualTQWZr+UvI0oxmMfhWCGtebIZrNoZMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=la68cZw1; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43]) by mx-outbound19-148.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 03 Dec 2024 13:49:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GbyF32izvtM90hINCY+0ieSvhOhhpFqmtZUPlm80sVWTU14afWtq+edvMvwjd6MaLSwdMWtz92WoMHXS5JA+qDGxD8SeCM+rTg6fixCu/cO/0r/90ETKp03HtqGzCw+ay2z5mJxN18YE4Jbq7tWswqmgi2zgG7JQiBVMzOGWlpqr6ByrtQg3Y5Uf0X3wnc1PnOJxJJIoRaCYP+dn1XOIIX/EdjTBDdMR56h0PZ8Cf62XO4ipVt2uexQk6QvpHFE3bGdAuKL7ftvrIZ/l1aUbAKz1DyhKe4IAZz1pButKWJSx7CmM74Bzfv8rmqt/KFhWbXFElQqUfrySZ+wUK4h3ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2AkRUWKIg5rXdd3IebLCBqg9Twsdd5V1qwQz9Y1Y0k=;
 b=zEDAj3K+3vonJnJIllFov5YWXMu13UYcrJLlqyx6sFz3qAR9rlHmaahF/8ORhUUfrBQCi1OYcllpd++lUQxoXFPwaosNcWhfmLzQZYGGWd9Az2gZgEoPk7rKsvvFCdcQnhlxxdME1dmaEidEZhnjth+K4N25ySgUSAVuGGH1AY3f3UWHL1RFJtnMLCwEtN7Yd9Oymlo+ZrAhA7fsFGTTEfegIrZQUC2LAJQZSHwomHaNs8BJLlixcZa4Xs3hlLwvqDVJRyedwICqkrdEsgC2/HvgWXm7OY42t5WcXYThw0GDbuWMluiOnOjZigszr2xAXBcN1jobBmsWMSt8S+l2xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2AkRUWKIg5rXdd3IebLCBqg9Twsdd5V1qwQz9Y1Y0k=;
 b=la68cZw1YjQnHgNZTqU8AVfdbXeOb/+XSaJLYYCchaUbF7e64onXpQh9OvE/0UXSWIvGr3VdHtEbrYlmtcpkSqK5oQ6XqPA//5OlstTs/bJk1WiIrd84Pf3j9hHQCa2HZZfnaasC5w+f/8R1XvSL49VR2T7tP1MdOtWDlzmcIcw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by LV2PR19MB5815.namprd19.prod.outlook.com (2603:10b6:408:174::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 13:49:12 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%3]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 13:49:12 +0000
Message-ID: <07e4b270-f6f5-471a-b2b7-4fb5027fdb20@ddn.com>
Date: Tue, 3 Dec 2024 14:49:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 06/16] fuse: {uring} Handle SQEs - register
 commands
To: Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-6-934b3a69baca@ddn.com>
 <42d5cd02-a1b9-4cd9-ae92-99bdcac65305@gmail.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <42d5cd02-a1b9-4cd9-ae92-99bdcac65305@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0008.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2d3::14) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|LV2PR19MB5815:EE_
X-MS-Office365-Filtering-Correlation-Id: ad073249-2f10-44e9-cfc1-08dd13a14487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a1Fqbm13MCt0bXBhVC9xVTBWak11SHNycXVWODdtVEZGdWpCdXdaa0psMFN4?=
 =?utf-8?B?d0NaZXplWDhvS1dwZGxYeFRyTTRHZythZmxlRUFTaGRicnlucXFaTmtpU204?=
 =?utf-8?B?bTZuc3dxcTh4V3VFampHRmtJeUhlc1NVWU9IMjlRSDdqcWxaMkNqRmgrUE44?=
 =?utf-8?B?Zk16TzdJVnJQdkszZC91eStxU0NkTkg4UzhFL3I2QzF0dWE1dWUvRFJyT1Bh?=
 =?utf-8?B?RUFjWlBibnA3Mndra1p1a0tORDdsLzI0TlpTb21IcTRhbWwwWU5xRDJqT2Z4?=
 =?utf-8?B?WlVDVmdPUTVjbzZEWm4xSHBXM05qTW1kenRMeC82YjZUTVlJdk5GdWxaeXVh?=
 =?utf-8?B?U21FeG1UZWpZb0VxWlJRekdKRm91ancxYXVSc0VWUWluZG1McU52ZFhSSWYv?=
 =?utf-8?B?Wk94M0ZNR1lMMkw0OHpUYUNlbWlLdGtWK1MxOGsvNlR6a0ljaDVQVTY0VHp5?=
 =?utf-8?B?bWY4NDFkWFNISy8vZ254L01lWWNvUXQwdDBOelNLb0t0a3dGV0VXL1VVMG9a?=
 =?utf-8?B?KzZLYk9rWEFLaDREaERaTG1DNkZZbTF4YzVkN3kyRUhqVXgvMUFvaFNUQ1dI?=
 =?utf-8?B?TFp6aUFCUGZ6M3U3RzZKT1MvQUNvTjVvOEVqbU9Sd2pQTG9tbTRjUlR1bVNX?=
 =?utf-8?B?c0lsME5oRUo0R1JENThXemJPaklkL1VadnhsbWtYSzMzYkRURklxSW55cm5z?=
 =?utf-8?B?T2pqLzhEeFV1OEJyZ01mZ0dkenM2WmJtdUV5eEt3SDFCSU1RK25iaVpxTGM2?=
 =?utf-8?B?NERXT09IL1J3VnVFSyt2bU11RXVuWUtibWptWThJdHZSMmg0T1cvMFdQd3JM?=
 =?utf-8?B?VG5kbnAxNzZkN0U0VzV4Rzh2ZU5ycjc3b2hBUDkxUW4xRnBkeTE5LzhVaWg2?=
 =?utf-8?B?OVM4OHgram1JWlBEOHhjYmg5TVNVQ0VIbWsvZ2pjNFU1NkxzaHc0RndkU1hI?=
 =?utf-8?B?NCtORUFpTHhVd2tDS01aM1J6c0dpcm52RFpqWUJWQXBhSWd6YXhHU0lKSWpB?=
 =?utf-8?B?Q3FjYnpsT2RrMUtVazZrQ2N6ZzJTdDdiSVFLY0c2cDB4OW5haWx6QWVqMjRw?=
 =?utf-8?B?ODcxR1hHNXJYU2t1NWd4cGZmS2RsN2d0eC9mSHZSTG5JazMwMGgvcVQvRUZp?=
 =?utf-8?B?MTdGanBkME95ZG8xMU9aN1JuZU53WStwSXo3dnlHdjczcmpoQWFqZ1lTS3FN?=
 =?utf-8?B?eFBXS1h0enBJeVhTcDdGTEtndGtELzFWQVpINzB6VmpTV09oSGErb2JDL0pX?=
 =?utf-8?B?UVRUVUpVVEdBMkVla0NBT3ZaM3VNejN3MER3SVlyU3ZFQ0pDS1Bmdm9paDdi?=
 =?utf-8?B?ZFBjWUM4RHp5QnJoS09xMUwvck1vVVNzR0t6c1VMb0ZZZy80bEIwOGNoUk1Q?=
 =?utf-8?B?MVJGbTdNUVJGR0N4ZXZkYThKWm5TMHV3MWJsSndCT2xpS0lLY2pEWmlQdVRK?=
 =?utf-8?B?YlBzdVFVRVRRWkxEcy9pUmdHQjJvdmRVVXlVYVhjWEZKY0QrY3NadkdHS0Fz?=
 =?utf-8?B?NFZPWlNrNzBnWkF1TnJGaGppaEdTM0N1K2VDU3gxS3VkM3ZNbWxFdmNxaExT?=
 =?utf-8?B?R2ZyMW9FMmRTeExpeDEyWXZVbFVMTjhYTW1kbEhWc3M0QkYwdDgvYlBWaHZx?=
 =?utf-8?B?TDR5Wkk3K1kzUXQ3Y2FXNGpPQW9wa0ptelFESVlZNWZvMExJSHovUzl0WjNB?=
 =?utf-8?B?Zmk3elRGa1JSUlE0ZXB4bjFOa01NSFpobFphaDMrWWlGZmp6T2FabWJudGxj?=
 =?utf-8?B?QTR4Z3NSUkswOGlFNzRKb3hRTnoyenNuaTUwNHIyNlo1Qm9rZXBySEgvTnJN?=
 =?utf-8?B?UnFFVlZWaWJyZWY0RjRlQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3JZNVlmUGNvUkZza1lTQVlyNy8zTlZuVVByRVljVjFyTFpHdTBpU0NmV3lG?=
 =?utf-8?B?US8zV1I1bWFYVDV4RkNhcjI1eGd4NzVzbEd5WFFQOHNpOUZIRnJTOEVWMUVT?=
 =?utf-8?B?bDZaaURueDVYcEJ6cG1RT2xpd05hN2V3Mlg3bjZ6RzBYUWpSblVQS3NvckF4?=
 =?utf-8?B?R3R2Tm1xeE55TEJYZTZnMzhnQ2lQWXhvZDEvd3A5clBLTWRWTFlFMnNZQmsz?=
 =?utf-8?B?Z3oyWFE4NFhsZmZBcWtoeEo4Znc2RUtqd2NNd0pnK3NjNm1PdUc2bFE2dm9T?=
 =?utf-8?B?THRVeGVLTjlmcjdFZlFwV2pIRmN6emJSRnh0Z2s3cXptZDJZdXZON0JPUkE0?=
 =?utf-8?B?SGM0YXVROXAxSGpaZDc4MDdjeitaUkZ5NU4xNTE1WFYzSVB0S0lxNkxkT0Zr?=
 =?utf-8?B?ZllZMVVOVFM4K056eDdodHdFRnVGZ1MweGdVNUt1TnE2UnhiU3BHaENXRG9j?=
 =?utf-8?B?Q1hLeGRPanV0K3N1WkJTazZXNjhqNmIxM3dYd09WT1JiVWdkRXg1Z1JWUTVF?=
 =?utf-8?B?clBSc29iQTBGbUlYcEVZbTlqNXNYMVVXVmVBZU16WGNSVlMzRWhubUpwM2tO?=
 =?utf-8?B?WjBMbll0QmlINWJhU2ZNVE1Ka0YvckRlTU9RaGhPQ29OaTlIdDJnbE1wZVVO?=
 =?utf-8?B?ZUsvU2llZ3MrSmkzdTBTaitORDA1ZWZvcHF2dWVHNU41ZzFRNHBFRnJ3ZlR5?=
 =?utf-8?B?MGMrdnIxNnJISjd4MHBidzlSMzA2NkZCK21kR25CWitPaS9xZEtXR3cwUjZo?=
 =?utf-8?B?SWZ0amFYNHFmQ0pNUmVDQ2s2NWtMT2VDWk9TSUtXMTA5V2RsM1JUUFFGdW5l?=
 =?utf-8?B?aFlybW9zcWR5Z0x5bUhwamdES1lIcFdiRVMvS09KV0Zla2R5RDZvVVVKMTlk?=
 =?utf-8?B?c1dHR05oTFZKWkRxS1haelF1WE9RajYzS2E2UWx2Q0E5R2lDYmJMdk5WdUhY?=
 =?utf-8?B?VERUQzVPV3QwVnh5Rjd1SzlWbGJML2VKendsTWdwWWlpbGxQQmdUdDA5MHFy?=
 =?utf-8?B?dHhXbjBNZkVuM3BRd2ZRTEQzNGU5dTYrSFFpSlpmd3VzZUpiTkdkUUNtNStv?=
 =?utf-8?B?eVJteU4yQ251eFlIRlVxS25FWVdYbDB1Rlk2YS9qeGFMZHI2clBpSnVLT0pK?=
 =?utf-8?B?UjB2dkRnUnJSY29vMXQrYW9TRFVhUmlFdG5JazlOUzZCTGJZbHl6Q0JKcHk2?=
 =?utf-8?B?ZVIrTzhxb3Z1cU1nN0ovMXpqd1JUZzUzNk5mVGM2TzNGY3VLSFQzckw2R2RC?=
 =?utf-8?B?OEVUem9tRHp6cERTMG1PWUFvdDcyREdUanZnOHVYTW1SeDFyNFluMkl0OWN5?=
 =?utf-8?B?V2lPUWUyYzZPakljNGI4WWRycXEwOG1Yc3ZlREZwTkJXUEZCVVl4WlNnZmJN?=
 =?utf-8?B?Z1B1K3BWTXh5eTVodnhFVFFvdk8veld0bndERjZya0JGSmZZM0NORDVMTDk2?=
 =?utf-8?B?QmlMdnZqY2g0djQwVmhzcjExTWtpdnFBQVBmSXNlTDYxeXk2NTkra0c5ZUZD?=
 =?utf-8?B?K1FCMmRhSFhIWCt3ZS8xN0NjbjBxekU5d2Z5WUQ2aUk4TXlXbFVFVWszK0x3?=
 =?utf-8?B?dXpDQ3FtNTJrTDg4MUV6V201VWFLNnJmYldTSis0ZEovWWVyUVlHeFp0QUV5?=
 =?utf-8?B?eDNJNmdSaXIxZVBpb3FjRC81bUJPMHIrWWpYVURiUzc5b3pNQ0RveDNEWlM0?=
 =?utf-8?B?UGZzVHY5OXZ2NHJrWjYzd3gvc0FsQU9OZWIwRkZwZXRFT0xBVW1JTmRJUzN3?=
 =?utf-8?B?M0M1Vmo2ZVh5THBrUGVDUmg5c3BCSGJHRnZlUHh4dkx1QThQVDdveUtQVThZ?=
 =?utf-8?B?dUFQYTU2MllGSDlWbXZIMnBycy9GLy9sY1FBcmQ4enZuYVQyaXJZZ1dURmhR?=
 =?utf-8?B?citKTFZJUHYyTStxdEkwVTVubEExbFFhdUo0ZDZPaWxXSTI2bi9kUUVYeEtN?=
 =?utf-8?B?c3hXYUY1SUJDRmVLc3lhbVhwWVlGdUw2UmF3RVZacU5xRUZIVnYxQXMzRjJ2?=
 =?utf-8?B?T1A3dzZiVEd6Q0RCdHorQ0U3RkJmOGpWeG81dFJsSlZNamNLai9GOHJ3aEk2?=
 =?utf-8?B?L09yMXEzYUVhOW9mMStaRklucTJCVXpHUksxQTRoOURlWWltanhNZmM3KzFP?=
 =?utf-8?B?U3B1bFRucTE3M2lvQlZVVklTWnFRSTUzam1sU1NOd3pOTk1vdEVGNmFGeWxt?=
 =?utf-8?Q?0nkIMsLzxMG4OHb6BTlqWAo4Ib53Dr9GRzDe5l6o2Zzx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pm33gVPSwMbUVu9VU0k6UxGbUT8PwPVP4hOkl3VPZHPgt74W/XGnyOvtFKrNZHR8oU9f+oz1Cxo/Y4xyEhYOdy0cEeT6AMrTTT1n4k2uuw1TwzMQzDxPjNd1mncgtS4lp+Nbo0lyWDkDZk+LR6TyUPlCR0YYthdKBvO9iQI8SWaJ1SyvoD90lYRMbebMRP4BOPtgq8JyTItYHyG69Y+OpsoGgVtjpzkmaXjJQ841sAFd2ZJKsbg1f3m0rLES4YTT36lWfUTluJlZfSfcmXNXpF5RCm8qmpqZYmIZLc3hSCTUafzTXmwvJaeWoMMAcyDsbtSED5tdObpgTYYwC96FvYjCU82t8TRe9PZnEuztQ7eDFnuhsWfhx8Qc4CaoGNdUeIWJ0jcAPcpeS5BPYXceiPYBorVkJ/C4JQkjIyaqJF+jhQT6xweDDOMv6ar7qvUagzuMFclVmXuS4pwUkr73Y3zFWfu0asH+Tm6B0lzUppsAcFuOeJJ3qpDyx6FEkVd83FEA7v27m/EQm4oNR+k756pQV/+5jxDGr7bx5Qyy8yaEh8O7Wzs/ob8nT8rxQFCrfjiL3SuzJFSLf1qjuozXkYVsZ+mK/g3+9vbAttVybHlQiH6W3D/5qRf/Bucm3yiXm9AnxVzSWflQ5ukHbvlcVQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad073249-2f10-44e9-cfc1-08dd13a14487
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 13:49:11.9393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FBptjKN5+rIY+oUZng78Ln8MRja6zHGpBmKo1Uq14ttaR/3eUIiPRdAPmAGf4YrB7QNPNoE5WQGrT+EU1E4ygw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR19MB5815
X-BESS-ID: 1733233757-105012-13348-6689-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.66.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVqYWliZAVgZQ0CjR1CI5Nck4zc
	LcMtXMyNDUMDXF2DDROMnEIDnVODlFqTYWAFvlw3hBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260857 [from 
	cloudscan17-65.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1



On 12/3/24 14:24, Pavel Begunkov wrote:
> On 11/27/24 13:40, Bernd Schubert wrote:
>> This adds basic support for ring SQEs (with opcode=IORING_OP_URING_CMD).
>> For now only FUSE_URING_REQ_FETCH is handled to register queue entries.
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> ---
>>   fs/fuse/Kconfig           |  12 ++
>>   fs/fuse/Makefile          |   1 +
>>   fs/fuse/dev.c             |   4 +
>>   fs/fuse/dev_uring.c       | 318 ++++++++++++++++++++++++++++++++++++
>> ++++++++++
>>   fs/fuse/dev_uring_i.h     | 115 +++++++++++++++++
>>   fs/fuse/fuse_i.h          |   5 +
>>   fs/fuse/inode.c           |  10 ++
>>   include/uapi/linux/fuse.h |  67 ++++++++++
>>   8 files changed, 532 insertions(+)
>>
> 
>  diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> new file mode 100644
>> index
>> 0000000000000000000000000000000000000000..af9c5f116ba1dcf6c01d0359d1a06491c92c32f9
>> --- /dev/null
>> +++ b/fs/fuse/dev_uring.c
> ...
>> +
>> +/*
>> + * fuse_uring_req_fetch command handling
>> + */
>> +static void _fuse_uring_fetch(struct fuse_ring_ent *ring_ent,
>> +                  struct io_uring_cmd *cmd,
>> +                  unsigned int issue_flags)
>> +{
>> +    struct fuse_ring_queue *queue = ring_ent->queue;
>> +
>> +    spin_lock(&queue->lock);
>> +    fuse_uring_ent_avail(ring_ent, queue);
>> +    ring_ent->cmd = cmd;
>> +    spin_unlock(&queue->lock);
>> +}
>> +
>> +/*
>> + * sqe->addr is a ptr to an iovec array, iov[0] has the headers, iov[1]
>> + * the payload
>> + */
>> +static int fuse_uring_get_iovec_from_sqe(const struct io_uring_sqe *sqe,
>> +                     struct iovec iov[FUSE_URING_IOV_SEGS])
>> +{
>> +    struct iovec __user *uiov = u64_to_user_ptr(READ_ONCE(sqe->addr));
>> +    struct iov_iter iter;
>> +    ssize_t ret;
>> +
>> +    if (sqe->len != FUSE_URING_IOV_SEGS)
>> +        return -EINVAL;
>> +
>> +    /*
>> +     * Direction for buffer access will actually be READ and WRITE,
>> +     * using write for the import should include READ access as well.
>> +     */
>> +    ret = import_iovec(WRITE, uiov, FUSE_URING_IOV_SEGS,
>> +               FUSE_URING_IOV_SEGS, &iov, &iter);
> 
> You're throwing away the iterator, I'd be a bit cautious about it.
> FUSE_URING_IOV_SEGS is 2, so it should avoid ITER_UBUF, but Jens
> can say if it's abuse of the API or not.
> 
> Fwiw, it's not the first place I know of that just want to get
> an iovec avoiding playing games with different iterator modes.


Shall I create new exported function like import_iovec_from_user()
that duplicates all the parts from __import_iovec()? I could also
let __import_iovec() use that new function, although there will be
less inlining with -02.

> 
> 
>> +    if (ret < 0)
>> +        return ret;
>> +
>> +    return 0;
>> +}
>> +
>> +static int fuse_uring_fetch(struct io_uring_cmd *cmd, unsigned int
>> issue_flags,
>> +                struct fuse_conn *fc)
>> +{
>> +    const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd-
>> >sqe);
> 
> You need to check that the ring is setup with SQE128.
> 
> (!(issue_flags & IO_URING_F_SQE128))
>     // fail
> 
>> +    struct fuse_ring *ring = fc->ring;
>> +    struct fuse_ring_queue *queue;
>> +    struct fuse_ring_ent *ring_ent;
>> +    int err;
>> +    struct iovec iov[FUSE_URING_IOV_SEGS];
>> +
>> +    err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
>> +    if (err) {
>> +        pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
>> +                    err);
>> +        return err;
>> +    }
>> +
>> +    err = -ENOMEM;
>> +    if (!ring) {
>> +        ring = fuse_uring_create(fc);
>> +        if (!ring)
>> +            return err;
>> +    }
>> +
>> +    queue = ring->queues[cmd_req->qid];
>> +    if (!queue) {
>> +        queue = fuse_uring_create_queue(ring, cmd_req->qid);
>> +        if (!queue)
>> +            return err;
>> +    }
>> +
>> +    /*
>> +     * The created queue above does not need to be destructed in
>> +     * case of entry errors below, will be done at ring destruction
>> time.
>> +     */
>> +
>> +    ring_ent = kzalloc(sizeof(*ring_ent), GFP_KERNEL_ACCOUNT);
>> +    if (ring_ent == NULL)
>> +        return err;
>> +
>> +    INIT_LIST_HEAD(&ring_ent->list);
>> +
>> +    ring_ent->queue = queue;
>> +    ring_ent->cmd = cmd;
> 
> nit: seems it's also set immediately after in
> _fuse_uring_fetch().
> 
>> +
>> +    err = -EINVAL;
>> +    if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
>> +        pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
>> +        goto err;
>> +    }
>> +
> ...
>> +/*
>> + * Entry function from io_uring to handle the given passthrough command
>> + * (op cocde IORING_OP_URING_CMD)
>> + */
>> +int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>> +{
>> +    struct fuse_dev *fud;
>> +    struct fuse_conn *fc;
>> +    u32 cmd_op = cmd->cmd_op;
>> +    int err;
>> +
>> +    /* Disabled for now, especially as teardown is not implemented
>> yet */
>> +    pr_info_ratelimited("fuse-io-uring is not enabled yet\n");
>> +    return -EOPNOTSUPP;
> 
> Do compilers give warnings about such things? Unreachable code, maybe.
> I don't care much, but if they do to avoid breaking CONFIG_WERROR you
> might want to do sth about it. E.g. I'd usually mark the function
> __maybe_unused and not set it into fops until a later patch.


I don't get any warning, but I can also do what you suggest.


Thanks,
Bernd

