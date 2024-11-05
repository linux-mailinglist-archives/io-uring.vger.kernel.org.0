Return-Path: <io-uring+bounces-4465-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83EDE9BD960
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 00:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77F341C2260B
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 23:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69845216200;
	Tue,  5 Nov 2024 23:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ONN2+2My"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE41A1D3193;
	Tue,  5 Nov 2024 23:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730847748; cv=fail; b=H0w7pW/dxwtBfE8QFN54qqw5zZ3oc/vlLKCAiaXUxOdlwELB7x1nw8l51VSEBHI9fQp7HSVMrPizxjA4QskewMrY68CNoyATi5HTplXonxSFbj6KVst9r2iMBwyAB7YgAdi9yNvZyU860SpQKl9vYDTFgl33n5FKXZHwKkhcTtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730847748; c=relaxed/simple;
	bh=aYMes/aaYGOqbBglgk8dHKN6jZegbR5Ipct2fBm3hGs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LAlmXqOD2Gmg8NZX2MeMI93sD8pI0JTqwVMpQOmWZU+R/144UervMGa5WrdBfIwtVnztUFX2J7zcQMFWXKt5IxjT2w0WPPo51Lqa0Mymi2wJ1JDSL4ksHen2xewiq9EiLZmudoaWcTdnDeVigZZvkUguTnADjxDbMoPmxjxRcK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ONN2+2My; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43]) by mx-outbound44-80.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 05 Nov 2024 23:02:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oRGowHutKKkM+HJzKjKTkqHI+Y7qm3qpyYSlGrqFOSpZ9qq4lODwgUr+EOVdJS74PSHmRKfvmp0v16D1tN7m5RM+SpOV57G5K2Exxf22hXq0QDcCLsfKrIgeFEKOfK/YTqFZdZ/cY57hBpMgMthgKpc0idLMsfXWDEu7b722DL71jkiM9tEj1PN7wYgpfPbLhWDn5YcyTHiV5Ejp6TMKM2flqxpy+Wm41xxRHlfS+TN99WEboNyqogPKpOjIZQqpIYMoGIpSNwSeKG1Z2uw3l9ZUbiUWsOzyv6fqLsJ5OKgYYXF9Fe+GdsxgQFAM5Wn/DWdtszrmcooEXEbATe4EYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIJmlOlw85CN1OlneWqlM5/+Ytk4Uc6U99UK1zOdf3k=;
 b=RClKxYk1PaWTNmtpoCfeNfOLaBZkr56wys9Vq7zOkNxdhNrEseUadygfim9R5meHvYfu9iGgxkuF7fL85itik9z3h7hqOT21mcYBOMMasQnqTJsNpJmRU/Gb0CKMQyhslNUMdr3FAIXhoFb9kAeqjdOxzSEvECet2+x9z2GZxQf7W9qJyrrcHEyPccjxsdnCXw9POUlc25hag974tP1FI6wNQMp7Iqu7tdtTh6il9YPX3lxB5LjSrDPV8ipRy0h3/fqeG76KfvvMyHSKkWB3cYPrabe+EnufwAaPP8Z75qyzNyz1X5w3RlGwXmgfWoAZ2sUzzE+1awfopLjfNh+3Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIJmlOlw85CN1OlneWqlM5/+Ytk4Uc6U99UK1zOdf3k=;
 b=ONN2+2MyuHKyj14RWM//vusoeHL583vZaDmUuZ2AjeWRkuoOqYtfDUbpJSxsNBFikUrWR4rlGoOG3QollQOo8G1fIo2/1S79XAW+WjXzAfi0Jd8kTCwm2AGcwOjGrrTTTThFJ+gV87G9LA6W1efIuwlEHwfmyL3OdJwM4DGwPq8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by PH7PR19MB7463.namprd19.prod.outlook.com (2603:10b6:510:27a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 23:02:10 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 23:02:10 +0000
Message-ID: <9db7b714-55f4-4017-9d30-cdb4aeac2886@ddn.com>
Date: Wed, 6 Nov 2024 00:02:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 12/15] io_uring/cmd: let cmds to know about dying
 task
To: Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com>
 <b4e388fe-4986-4ce7-b696-31f2d725cf1c@gmail.com>
 <473a3eb3-5472-4f1c-8709-f30ef3bee310@ddn.com>
 <f8e7a026-da8a-4ce4-9b76-24c7eef4a80a@gmail.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <f8e7a026-da8a-4ce4-9b76-24c7eef4a80a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0274.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:373::19) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|PH7PR19MB7463:EE_
X-MS-Office365-Filtering-Correlation-Id: e9476777-98df-46c5-c44e-08dcfdede0ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXMrY2dNNFQrTlZoQzF3S3JGSjQ5S3lIVVJ1bjJHaWhRNHlaZ2R5QUdDeHdY?=
 =?utf-8?B?QUlzT0xCOU1XNHRoeVFTNTZ3ZEh3NFY4UE5CaGtWbWdNcTE0d04rR1pYa01M?=
 =?utf-8?B?K3lsckRMZzV5Y1hJQVpZWDNHK29jdkRBaWJVd3pHUU12NFJ6dTlwVnZSQTVm?=
 =?utf-8?B?WlBQZDVZU3pxdlh0amhHM0NvZmtqNVhMQi96ejBPMzg0b3d1cGRmcGZXTCtT?=
 =?utf-8?B?L2dWUjFINTZ1Z0xXSTRPSVEyeUoxUXZGUzNVNzNnc0JjcERUWHVjWVF0aXFP?=
 =?utf-8?B?QTBBamdNSW16QjBhSEtRd3FCb0Y1cmNpUVdGcG5TZzdBUWpTNU1UKzRIaFVH?=
 =?utf-8?B?ci9UVCtGb2F2aExZbEJwTDZaaEZCczdYMWkyS0NieWVRdDg4aWVGSytnSGpF?=
 =?utf-8?B?OWlyUkpNZ1RUdmU0MUtHREJCdnUvRDI2Sm13anY1Y3RsNjB4ZzAxM0pwV2NN?=
 =?utf-8?B?bkhZU3JhZ3dnL3Zqek8wTUxrK2VlQkU1WlZkalcvYjNzcnc4azJoWFh4cC9R?=
 =?utf-8?B?WDcxMEJtQ1hzc1FPdk1YVCsxc25qUGdwSUpRVzR1NEptSWhqSjNVZGNvS2FY?=
 =?utf-8?B?dXRpeEVpZXhMaS9qWWM3MG9LM3JCR1NjY2VuWXhKa2trRlZLdVhzQXZhUm51?=
 =?utf-8?B?YS8reHo4S1NvcHdHVHkva29JQVgxbWhNNHFGUnpiUkhqaGRrWXI4Y2FvU2NW?=
 =?utf-8?B?RnBvcWp3WHBGRmNKbGwyczYrL2QvLzA3MXJOT2FRZEJOdy95YmlYdGltM2ZG?=
 =?utf-8?B?cTdGM2xDY004KzhLNXJROWpMQThMRmtCdy95eElVZGVqeGQ5RnNTd2RHUFVM?=
 =?utf-8?B?RUFJVGMxbjUrc242ZFlxZGFlSEZzQVIzQ2R4OFpZYjNuTk95L0E2aEZJMk1s?=
 =?utf-8?B?S0JrbnNpMldyK245cCtVNkZIZlZZcjg3SHpNcEdibjhyNE9jWkg2SmMvZEs0?=
 =?utf-8?B?L1kwWGlpZXk5OXBBRlpyQy9nYVp6U3F4RDRHWlEzSllSZzFHeTNmTnlOdGdB?=
 =?utf-8?B?Y0NjbHJDSy9GL0VmeWRwZllNcC9qeHZrdnJhcVQ1cW5QaWZuS21hQUttZnRo?=
 =?utf-8?B?Yi9XRHA5MW8wU1czdjNDWmtzcExwZmxqTGxYaXJpMXFBcGZXb0tTVkhqSGVq?=
 =?utf-8?B?Y0ljMkFacC9PWlFDaWxYQU56TTBqb2xwTkltWFZyMHFyUzdVbzI1ZXFYMngw?=
 =?utf-8?B?OXNuTXJWM1VQOWlUbkNGbENDUkZueFlsbFE4U0NPNU1JOXFWQ0YwczFBMVZ6?=
 =?utf-8?B?ay9IUFg0MytERU80T1RmWjc0MHFhYUR4Zy8wbGdvTXhBbmwwQlBzWmt4Nk9w?=
 =?utf-8?B?VVpvSEdYNzY4SE5kb0k3aDI4Yi96ZnhJZ1d2c0FyaVBGaVFWM1c2OGFWYUkw?=
 =?utf-8?B?enBVU25xeXkzQk1lMEVBejdXZ1RFbldYSjZoVTRrZDFUZ2xVdS9LNEc4Lytq?=
 =?utf-8?B?NElJSmYwaUZ5Q1Q4NCswbmRxVzg0LzVFL051WDlTcFJKK3VERFgrMXJuUkZs?=
 =?utf-8?B?TExFUEhsUTNtcGcwbXlMM2dWQmxBRWZibGhrbjBXbWZMTVRuN3AyT0UyRnYv?=
 =?utf-8?B?YURkcDBVSkp2T0pudXE5SWVHV0hSU0pCTWdyWVREbHlEU2pjNnNlN01INmZU?=
 =?utf-8?B?ZXk3WVdEVlM2QS9ZN1U4bldON0s2TlIzMWFWaWtDUEtQUE5iblFsNGFUejdT?=
 =?utf-8?B?U3FQaXZFb3NUTTV3K3RLa1RHRUpkczNwTGxHNFE2NXFwNmora2JTSEo2N0ha?=
 =?utf-8?Q?4T8Die0xHQnNWY7k98=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGJXSm1paENNd0J2SWZRYnhxUVE2U2wyT2cxTU9id2dlV01VQUMwellaMkRW?=
 =?utf-8?B?TlI1NGUxMC9sWldMNEtXY2IySDU4WEFjdE5vdWJpN2dhTDJrYnFSZnB6QnRE?=
 =?utf-8?B?VzVsWGg4M0lUZmhhTXROQjdlM0tIank1Tkd6Qk1SaE5zT0JJeThuUk45cWRS?=
 =?utf-8?B?b0xXSWRLSkREYk1sTHc3ZXMvdzlLM2Z6eFdYbzJYZzBOUEM0MW5lRExCVUhX?=
 =?utf-8?B?TTV5a2hRaHNqUGlJeXdta1JvWHFNcUcwRCtMcGViMi84ZlVFNHlxZExkZ2tQ?=
 =?utf-8?B?TnVueWdVZG8vSVhDTzNGL1crVm1YeTVmM1gzRVRkRWNwdFVTR2RyeEZUVmlj?=
 =?utf-8?B?Rk1EQ24xakZWUFR4akhRajYwa3RwMEx1M294RHZYQkVPa2tDQzdBbjVEYW9r?=
 =?utf-8?B?MUlBWEZyTGtwWDA3OFpreEFFcFhxZkZkb1MvNWlSVXNURnlLaGhYNjZNbWhi?=
 =?utf-8?B?bzljRHNtU3l6VlIyR1llelJEak5CeWcyNThiemE2R0pZTFhrOVlvTnBYOWNQ?=
 =?utf-8?B?Nm1WTlo5ZkhOcHZmMmRTQUZqY3BXcytXenROZ3NBRldhaEs0S0VkT3lVL3VI?=
 =?utf-8?B?TEtGNkRCbUhQVzdqdkNkcjgveit3cGFDQWdEbE5uVktZVnExTE5ROWtsdEdy?=
 =?utf-8?B?Q2pmOVpLcitPa0RJenl3LzUwVVVQc2I5NGtRcFNaR0l1SlF4NDMvM01LRlR5?=
 =?utf-8?B?RmNFNDA0SUVtYlVESjVmcGVNWEtJck4zVGcySDY4Z1NlZHNmcG5qWGs3dTJ3?=
 =?utf-8?B?K0pjUHQzUzdxMTN0VFdBL3JxT1ZxQjJRZzlEZVNCaGM0NTdqTUk2dUw1N09w?=
 =?utf-8?B?OXdHOXRPRFBXc2VRQjBiOXltZzRZaDBJZi8zU3Y2Q1BMMEtmVm01QS83TEdL?=
 =?utf-8?B?c0QwOU1mY1hMbGRycVJwcE1OdkhjV3dxOW5OSFUzU0FERkdiOEE3RmJQK3p2?=
 =?utf-8?B?cU1CaVRwL29tdUxUSFZWWSt3UlB3N2tzSXhZa2xodjNzZGQ0YStScEFYcDB3?=
 =?utf-8?B?MDdBbXc4NmVENGt5Z0k1RjVPdG93WXpxUE1qSnZEZWFnNGpDQzEzVWEyRE9D?=
 =?utf-8?B?TGpoakcwbTAzd0FkeDdNWERPdWRVb3JwSlV1ckpacTNlSk96Q001RSsxVGxO?=
 =?utf-8?B?S2FmdWhCUldReStsTU11eFg0V2FHSjhLS0t4eHhRQTh1MlUrcHE4eXpwU0RM?=
 =?utf-8?B?OWY0N2RWbkZMMDZwc2dXYUQ2RHR5ZHB4M3cvdzFJa2g1MVowSWt4MUhtQlha?=
 =?utf-8?B?d2hubWdEVHVTa0QrRUtMZy85RExobFhYRW9tMTd3VDRtZmhtWDdDMDF6eGlX?=
 =?utf-8?B?aTdwd2w2WDY2OFQ3NG1YMmNRU0N6TmtaYlVxbkhLWDU3M2tDNUVlOXgxMGFV?=
 =?utf-8?B?bkMya29vbHN4YXRGRVVGQ0NzR0x6SU92UWpJci9UV2hHeWU0eGxTMDVVbStF?=
 =?utf-8?B?cUNXRkZKL2VwNVNVTUJnMUluQlNQQ1pRa2tEVnlQVG4zMENUc0RxNVZWSEUw?=
 =?utf-8?B?Z0xPeEhuZklpMUhSRk9mQWNOMFViT3pSMFkxUFpCVmFjY1h5dUNJVEdwTVlN?=
 =?utf-8?B?RFczbEVlbHRHRTRKQkhWQkx4NUtjeVVVeU05cjFjT2N0Yk8xUnNyZ1liamtu?=
 =?utf-8?B?R3NpYUcrSUJLZTkvY0NtVFZPSHo4QnJYVkwzQkh2L2VKcUtnUm9JdnBicWdI?=
 =?utf-8?B?QVp4Mk9RTklSZDJQMHBEbHRWV0JTN3ZsQ0VaN2xoR3I0WDhuZTlwMEZ1eGYx?=
 =?utf-8?B?MFRtY3ZUckJzUytVUlMzcmF1dFNkVmlmSkJqcEJMUm5POGc0WjlFSWFmVXB1?=
 =?utf-8?B?dDFHK1FYd25kZ2hIbytTSFdJcFVLazlrYzcxRnE3WUc5dDFpSE0wbVJjOHJT?=
 =?utf-8?B?K3dHNE9JWVUrK0hMSkJFQWpDdDl3VU8xSGhTaWtHOVdsdHErYnZWT2hvdjJ0?=
 =?utf-8?B?Y2RpTU11VE9iU2t4d2dwNmtmWHlzOWxqbnRyMUtoNlVDbnpsQXVLL21XZ3dr?=
 =?utf-8?B?VkpGRzZydi9VMkZaVGpySzBNWUpMU29GLzU2QzlCVEpmVDVJUHhNcXd0ZkMx?=
 =?utf-8?B?U1VkR0FEYy9BUEJUU1hPbERXcTVLemU0R1hTK1YxTUNQOEw0emtNYlczVGs3?=
 =?utf-8?B?R0dOZ3NXbHFqbG5EZXluNFJuQ0pnNGtqT3NKcjR5Y0xmRWl2ZFNlMU9IQ2Zj?=
 =?utf-8?Q?t5IErmQVi7oaVox2F/ZrWUjHjDDp7qzABDW7W+SvotmK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9085iY5zKXxoRRerJaKFMfvBsXWlUXig32+dTQ8azDQkhSwKBQXJIIztpCuhnA5x1QtzrkV0DR/JVjtq0n4ULlqpm0wUexVT+2LQAsBv3ehBbMkKsXBfRm/LFzTVEPP5JsvnAHg+1QA2awg6ySbuwC/5S9yeZs3/zfaKCU+EicDX+IiNjibyXuDajK6Hj1FhQER6TiQkBz16n7YH7wKYYQVgjYl/0vbsisdMJ7Me//oPCXFIBZqO0bN4NDnbyxMlGnEd6HcLCq2CTkZTwJcHXb7aI3XCAJW8fIy3a3XwyHtL0xqL9tbsWFSRfXOt+jCFoepiXWi+rVuEy53Vyf0LwC6zIE1Q8xH0WRoY2Caih6w8Ai/IhdcKahyMNca5U1gskGk646ByU9U23j/vXfIMTbVb7wffpMBq0cB/rYBfOXbSR6SSkNn6dIwVALl/jHDB5ln+FVBYHsXRhEPZy6ymekSW/RRQpC8wv5+1w3c/K4YFfntD2vHlh9QyVEHfalm92SIGUqzMhsUPzDaubUSghUuAN2odZCbh2iNBCxyEokrKVLnQfFII20A1ZV4x1UMrWM032ES+XCf/p7mijxF2EN0Npo3Udqxe4BEAf1YRfySXRJ3EFHlZS+JAk0SEQigwcDnj7IpK62MMv+FEXSZmBg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9476777-98df-46c5-c44e-08dcfdede0ba
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 23:02:10.1696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bHZq4SpcT/oh17ipMR7BEkKcChlNlGCx77SQQrQppV0nkP5CBt7E+lGlNt0KvOUO9aKb/YTFMjRwtO9qpcNvlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB7463
X-BESS-ID: 1730847734-111344-12680-78273-1
X-BESS-VER: 2019.1_20241018.1852
X-BESS-Apparent-Source-IP: 104.47.51.43
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoamRuZAVgZQMCkx1czE0ijRKN
	ksKckiJTklzcIwDShtbpmYZmGZYq5UGwsAkTzyTEEAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260230 [from 
	cloudscan20-172.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1



On 11/5/24 02:08, Pavel Begunkov wrote:
> On 11/4/24 22:15, Bernd Schubert wrote:
>> On 11/4/24 01:28, Pavel Begunkov wrote:
> ...
>>> In general if you need to change something, either stick your
>>> name, so that I know it might be a derivative, or reflect it in
>>> the commit message, e.g.
>>>
>>> Signed-off-by: initial author
>>> [Person 2: changed this and that]
>>> Signed-off-by: person 2
>>
>> Oh sorry, for sure. I totally forgot to update the commit message.
>>
>> Somehow the initial version didn't trigger. I need to double check to
> 
> "Didn't trigger" like in "kernel was still crashing"?

My initial problem was a crash in iov_iter_get_pages2() on process
kill. And when I tested your initial patch IO_URING_F_TASK_DEAD didn't
get set. Jens then asked to test with the version that I have in my
branch and that worked fine. Although in the mean time I wonder if
I made test mistake (like just fuse.ko reload instead of reboot with
new kernel). Just fixed a couple of issues in my branch (basically
ready for the next version send), will test the initial patch
again as first thing in the morning.


> 
> FWIW, the original version is how it's handled in several places
> across io_uring, and the difference is a gap for !DEFER_TASKRUN
> when a task_work is queued somewhere in between when a task is
> started going through exit() but haven't got PF_EXITING set yet.
> IOW, should be harder to hit.
> 

Does that mean that the test for PF_EXITING is racy and we cannot
entirely rely on it?


Thanks,
Bernd


