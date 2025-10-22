Return-Path: <io-uring+bounces-10143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 381F2BFE334
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 22:43:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4D50E354740
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 20:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E350B1DF24F;
	Wed, 22 Oct 2025 20:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="VHYxZufw"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C412FB617;
	Wed, 22 Oct 2025 20:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761165811; cv=fail; b=s0AsRUbUA+E7ArPHQfk+zwbMMdpLsaX10a5eDTnYP4ssPWxdfCZLa/jbny2WGOH8/c9a4j06+aOt3zZpuJIQDSQEjgV+EHamsTR4bl2ZkDTGYUivHUGu+0H12BJGkg44xOtE8DSZm2i3U5XxgPr9EtFVADXktN0JDFNdSkxJqEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761165811; c=relaxed/simple;
	bh=LL9l7jSj+ESZyfpupqeW7N1ulhKNkK3VlCwDBn0TQh8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OIDOVr2Hswe0EapoUHeYV+sQJYnj9agownoCC5gH1cTZsG99gefwrcim3KlZaxiBCUIWLStweAAdPRAQLZHTdUvZ4RsRWrbC+WItufNPvpKByc97JXQb7Py12JyfC7jRmZy2cYwJ/njSMxWVVcFXI8ASGD0s6txLWbQaRGBIvXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=VHYxZufw; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020101.outbound.protection.outlook.com [52.101.201.101]) by mx-outbound12-215.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 22 Oct 2025 20:43:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=otGUM6Gt61j9eyVt08F2i2jebOH0mc2pyRpTwVC02Fv9XrGfUekcGrl/EnqYHQ+8cP8gUCFKqdGCBxEOrFOv3gIXWDFpNyP6ld60gG4evdPNbHiBEs7MU2hhdZNhyaMiDeZ3r8GbdVLr2qpMeBnHzZw4gElf874INLHFzLVU5dFR/CJN11Fkchb34IBPzmU/b80w4xGvUI1yysfqcO3Pd1BCprCm6JBY5AplT/d2A1bEA2QaaAc2RXOjxmJ/gMX/dtXQG2UwJQRHNgp3XXDcKbhNIGJ+4SH04SXVI8n4g2KzR1LXmc6E4lODrPtTjbPwO1doR/MP5zOue8x7ss1fjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qlxx/FxPb/mg1fTlXbpkN52jHbXsX56iMWGr/4N+kBQ=;
 b=ctR+jGmisCPILSHMAybTfooPS+WrbDGDjL5+QWVPHeN8dEA3y+PcY7W5ctUunhfKDfRUV5twbhoRuoAmt28Y8NJZ6n0Ix9rcVOXFQRzSri8+GJQ024H60nid4fGx9Vir1OFpzkWMihnQq39vwC09P87OUdrZmt5ld5X+2Ly9gGwJs6ff2AxHPqqGo5ppyHAkbNCW0fWOyRtohKofWDimHNG9tn7IcjlIHh7kxQVm8TfwL2d9pTbW/5OsIdCs2okIS1MiQzrSS8mHNU3EqjlO9vHa29HeB3r0Yu6xXYregdmqqRxXiwbu1mrro38bDh70EP/EdkVKttbg0F0YBuH90g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qlxx/FxPb/mg1fTlXbpkN52jHbXsX56iMWGr/4N+kBQ=;
 b=VHYxZufwS6jQWC8uF4qkMGCyMYV7M4G4H+XkdbcidJzOcWv/EDqEj8IsytWt4OK3PYgSJUQCpPHZDwSZIfqt+JIo3AjhZY96SV+GRcAOY91spzAdKFY6hYPdKLd/p0dV4y5TcmkDl7opITo/ulooCGxZD0QkPJF+s7OxTZguICs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by CH2PR19MB3830.namprd19.prod.outlook.com (2603:10b6:610:99::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Wed, 22 Oct
 2025 20:43:18 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 20:43:17 +0000
Message-ID: <539ebaba-e105-4cf3-ade4-4184a4365710@ddn.com>
Date: Wed, 22 Oct 2025 22:43:14 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] fuse io_uring: support registered buffers
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu, axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, asml.silence@gmail.com,
 io-uring@vger.kernel.org, xiaobing.li@samsung.com
References: <20251022202021.3649586-1-joannelkoong@gmail.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20251022202021.3649586-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0070.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2cc::10) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|CH2PR19MB3830:EE_
X-MS-Office365-Filtering-Correlation-Id: e06a3c73-15ee-4f3c-9dc1-08de11aba12d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|19092799006;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZG1aZGJCaFN0a2NNcFhFS3JkTXhZYjVEaHRRdC9OU3NZTFNJeDF4dHFFWitT?=
 =?utf-8?B?cldtWjRpNWZ6OGJWcXdYRVNONkpMSGNveEJub1Y2YTg3S2lGQ0hwZUNOMXA2?=
 =?utf-8?B?QzFqVzBBYjREZHBBakVHSUM3ZmJNVnJ5SGI1U2MwekZ4b1JPRi9td3JheXFy?=
 =?utf-8?B?aVhyOVEzV1RIMTBjTnZ5UGk2Z09tUENxaUJCOEJ3b3BJcFNWZ1NtUFlGOExW?=
 =?utf-8?B?eEF4aWlqSnZXVXlGeFFHM3hjbm9hbWpRU3dVVEJnY2RRcnJBWUJsSG9CZzBm?=
 =?utf-8?B?ejhpTXhtcGFXZXlzRmJXMlpYM05GOC9qQkY5bWp2YTFHazlYVk03dkErcTQ1?=
 =?utf-8?B?NlBGWjlRVWQ5WlZiaHBvcytPZEloQSt3SmFvOGF4K2Mzb250WjN0Rm5uQlNV?=
 =?utf-8?B?MEI0NUl2QWxTOFBmbVpZZjZJQURaWER4SG9wNk5NS3dXbEJ5elB5U0pHdWRp?=
 =?utf-8?B?c0p3N1hEVy9ha25zWDFtVVBMWDlSUlQrcGo5SjdoM0VWdnVwbzd1SUIveG5F?=
 =?utf-8?B?Nkg1dWZJVXBLMDNDOU5JbGtTbkVyQ244aDA1OVRTRzdLRzFIbzN5bFFPU1Nl?=
 =?utf-8?B?R3g3cWlmSzhQZWhQV3BaY2JGaWs2SExOZEw0aHVXNHFHNmJrNCs3cWNQcFBx?=
 =?utf-8?B?alY1S1RhUnVNOVU4UjZqei9zN3gySUh0SkQxMC9PMnZndXJZQ0NzMHhlWWl2?=
 =?utf-8?B?QzRZRkw1Vnh2VkpkcFJyM1NzZVoxM1VUektreVgxamlOc2EzbC9NQVk0bnp6?=
 =?utf-8?B?a0N1a0NPQTU2c24vZG9oRTV4NFJrWHNsZXNtNUY1bjhFanlDbElGbnFZM1JM?=
 =?utf-8?B?OS9GV2ZnWlllbXl4R25aNVBzakM3dUZZMVFUU3JQSjB6SndIRy8raEI3K1Av?=
 =?utf-8?B?MHc0T0lPSmhCaWljeE95Rk9sdk9CU0RwY21YMmZEdDhESnRCbzIrUElqblN5?=
 =?utf-8?B?MnF4UzRaSjhNVXd2bS8rR2RFRFo0VzdFQXhHRncwSEExZXBVU29LSlRlbFMr?=
 =?utf-8?B?L0gwaTQvdjU1YkN3MjdYeHZIVTY4VGxpYkw4M2F3YjY2SHdHcWJxdjM0dzdE?=
 =?utf-8?B?ZUdUaTdzeGt6elgvL21tZEptWEwrVWsrMEltZnFJWXl3dXV6VU5rZStJQjF4?=
 =?utf-8?B?TGhhQlB2RmZSbG9JRTdvQjB0TisraHM1VHRDK2NCMExKQk1aWDRReVhzZ216?=
 =?utf-8?B?enEwUWltQ3A1U1FYOER6Y0c4bTJ6NERwQjQ0Mk1BSVJqZjhJa0JwUUY0dVdx?=
 =?utf-8?B?ZzJNaFNoUmFMcFlsSTcveUY3b0tnQ01WczkyV0xSdVRMeUNyYjArQ3ZLWU9G?=
 =?utf-8?B?NWhWM3RKeEQvbmU1bWl6SDR6dkxJdUp4YUlOZDkwZjlsbzJucXlRdXFqZ3p1?=
 =?utf-8?B?YUdTZ002ZTBCTXROWVQ4Tk8rY3p5eFQ4SDBvN2JGTlI0ZDVBTW12K1hJV3c4?=
 =?utf-8?B?N2FaSXozaUlmZHhIekUwQTFpeGFBRzhyaGJlRnhjR0x6czhaVzdTWE1QQjNv?=
 =?utf-8?B?Uk9PWXVOdkF1a3ZMVzZxTmoyZlhydlY4RGdTUDVRTGJPZ2JOQnM0alRueFZS?=
 =?utf-8?B?aTE3eUc4TnljUUgrM0ZlTzNSRUpITnhYZHg2Z00yZEl4UTRHYU9ZYTIyeHZx?=
 =?utf-8?B?Z1JDeU5mZ0hwZVgyRlgwdFdUMlIxdFpaaTJqRzd4dDFpRCtlYnhNemlYOHhr?=
 =?utf-8?B?VFRsTmViS1FQMElxMU84aTdIRklyV3lLU3Jmc0JTdlpidjczTFV2bzFDQnpl?=
 =?utf-8?B?MGFGbTJITUIrUHl4OXNFS3Z5RE9zUitsZ0ZuR1J6dWZhdHFGbDZVVExoaC8v?=
 =?utf-8?B?ZExUczZjUDMrS2R4bDRpZWVIb1dRVjdTS2wxdU5FclFvZEw4VnR0UHIweTE3?=
 =?utf-8?B?YmdzK2xYU21nNmJLbVNKaGlrck9OZUVJUSt1eUFTU2tWUWhtOUtCb0YxUFJj?=
 =?utf-8?Q?9jGBDPDtPF0vE165x/K1rroVLyYDqr1Q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(19092799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzhuSDZ3eUtqa3gwMGhRT0k4eGs0d3R2ZGc0Q3VUK01EVkNxME9vRml6VUZn?=
 =?utf-8?B?Y3pSQ2F0V0NRU3dCZUQvRVdoQllmUTBBUm9ybFN1RHRrbFlIcXBYSHRwaWkx?=
 =?utf-8?B?WFFqNGJ5Y0QxVUhiZ2ZVUm5MTnZjVkFPbWxRM1c1YXJ2WjU5WUpvQ3NKWGVM?=
 =?utf-8?B?L0dmcG10eTc3MWNURENPNWVRa3FFNTdwYlA4N2FMbHBrVHVVR1B1LzBXaG16?=
 =?utf-8?B?dWFrcVQ0NWdtdzRqL2lPcGN6ZnE0Z3VoUm56MjdVZmVTVU8xV1RSRmxyVWxQ?=
 =?utf-8?B?dEFva1JXK01BNFc1WGxtdDJ0M2hzcjRrVGdQWmRTWmh1amdVRzNMUFJaQTl4?=
 =?utf-8?B?Vkw0VWR2TXBZR0lQTHdCUU9jUzgyL2U4OFBEVkw5NDNIYWE3WG4wVnhFYkNw?=
 =?utf-8?B?ZzJHTTM5c2hoV1hPM1lLQ2FQMnVhQ1AzZi8zQmpyeXdDWElWSERhZnh1dkps?=
 =?utf-8?B?Rk5NQzcwNUZrMEkwaU1ueFhHVmRuN3B1UTQxejNTVDJDaWpZVWhmNnhmYWV1?=
 =?utf-8?B?cjdsZkZpWXN0WUNWcVVoUUhyVUtWWlVVd1hiZlVrZUlBc21EUGt0UXUxTlBW?=
 =?utf-8?B?VnZFaDFIMGt4SmlQMzc5MDI0WTVkbWtoTmc2NEkyL2htQUIxYVdWcTBMWGtx?=
 =?utf-8?B?eUROYjVhVkJndjNqZDZ0a25UNFUyQUh3bk53a0VBa0Z6TU11ZitDQUU2Zk9m?=
 =?utf-8?B?NjVSdXFOTFRhcEE3VUcwdTJHbWxnR3orOFE0NGt1R21yVGFROStnSVBZNmdn?=
 =?utf-8?B?eTVSQkN5NHljRWkrRGRlQ3Q2NE5DTTYvd3JTQUdYbXNQUnFlZU0xV0Y5K3hq?=
 =?utf-8?B?TlB6Z25XWVdJL3oxVFlZL0JYWCt1d3VObExMbDV4QVNnVi9TUzJHUjRBOEZw?=
 =?utf-8?B?Mnk1cHhYQitEYVMyMEFqUkppRjVSc2Rxc0Z5Z09ta3ZqTFArYWcrUGwxM00x?=
 =?utf-8?B?QmVXQUFaaGZzNlVXT3BleEhPdWpxTHk5VWdwVWp6M1VTVndLTnI5dVo3a3B2?=
 =?utf-8?B?cjZJeFd5d2dudkYvR3FIelI4YXpObDhpRDEwYWlDcm5vMEUzM1BucDJSVlZq?=
 =?utf-8?B?eWtVeTFzbzEvc011MzJQMmFQaHhoNEMrajVIOThxWTZXWW9WTm85eFV4Smxx?=
 =?utf-8?B?SmphNTVUa2p3bnZJVUxiWFdhdTh6SUxIaUVVUG1JQ3prMDYvbG9jN1p5aHl4?=
 =?utf-8?B?K3IxQzE2WUtvZ3ZnM1pTVWM1VGczdDVnYXFRTXRIK0JRcEVSQ0FaSEtPajd1?=
 =?utf-8?B?UzRlSmczc2ExRnJtcmdHMU1MUS9xYVFyUjdsRWFyQWtQSE9Zclpnbm5KRCtU?=
 =?utf-8?B?V2s4VWZWWXBVcWlEcnJLL0ZsRkFvR2lla0RhY3lVYkZOMTdJb3ZVWUFhNmNs?=
 =?utf-8?B?M1lUdHNKdmRZeG1JcWxldU4yZ3ZTVTRCWVpDdmx1YnFjajRRTmNMNTlqVGcz?=
 =?utf-8?B?UUI5TEg5ZHV4VkJDRTlkMWdCMURQN2hMMEFVVGRnSzZ2bXRkMjlDZXVvMCt2?=
 =?utf-8?B?c2JNYmFIY2ZNTm1ONnZIaENycVgrcnlMbW1RV1lOeVgzdWJ6TzJXME9zT0dZ?=
 =?utf-8?B?OHN3b0tXc0ZwS0RvMGszR1dOQUFIU2hzMUNiRVZuZHJTdGtQaHcvNVU4bTRx?=
 =?utf-8?B?MXFod2c4TDlHai9MekFibGFjNG1YSVljdTU2cGtXNTN6SEN0bmhVSkEwS2l4?=
 =?utf-8?B?eHBhRmtFVmd5eXRVbVNtOEJ0bEp3bnRNWnhFaCtVM0NLN21XTHJsTVRjVEtZ?=
 =?utf-8?B?R2VPR29wbEtYYnZ3MWYrbmJ5SFJtUk5YTkhLN0R2bUxBTU5RRmNqYUp5eHZ1?=
 =?utf-8?B?QVFCdmFrd0NIUjFYV05Sb0FPM0kzREJmeWFwOTRFVmQvZ1M3MEVZL3VYRHd2?=
 =?utf-8?B?bTJiSmlwWStSaWNkOGJLbmZuVlJKYktDM0w5K291TCthOWdKWEV3dFhFQmRx?=
 =?utf-8?B?SDlsbWNQeEZiQ2lZMGdlcUdPSmYweVFmRHM1NjNaL3B1T3cwWE5nYmd2eStE?=
 =?utf-8?B?cloxSHVpOVR4Rzg1RkVTN1FMS0lMWTBsVldlRERCRWZqL3ZjdVM1QTk5VVg2?=
 =?utf-8?B?MmJSOGZSZlhRdXM2UWRuTHhsNGN5MDZpMjcwanVFaitZbk9NMzdLUEdPZDRM?=
 =?utf-8?B?VklMRjU1ZkY3YWFOQU00VGFtSjArWWc5R0JBTTZvMWZKbGxKQzN1L0ZYTFdH?=
 =?utf-8?Q?YsBTMWozYVKskmTMC8dvWMkTR9fC0mSECN3AcGFxxRxJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Htf4tAMj4W3vQLWJZSGsrKhvCGEdwmL0xRsdiERrV4/cmiqoaMKsF5N32dUTCicZEtKW/coIaKMwAFt1DHijXj5dj9tF8G9wpk7ypC31FIPPGZe9QuhcoUo8j/278UYZEP3FzeGiog30Vid4MxTZpplqxKaVT2Thrc88G3J9QfkAYWmVJbl2yUm8JUJcSSHvDBRDHjC4FIKRzZPvB0oQkNzVQuPWIjFjjX279j3rTThFZcKiGY7YKjnau/VG/NH46ZkZ+deR+pBbMwaomWJjXrsa3ZWd+9M3U0EEHzslJyOLE94oPyxp1/knV4Ex9ug0bQQdYbu4kOPNSSlnakCbM/eZ+u9UMM+LqfT8cT7Cwc7qAG2z3cjPfUMvWAj5dybxsOurOiui/PL52uhxj4krnPQ702zod6O91YFX/EgowyX85hviN0aSVE1RBMIXXVrrjegp4+jGwEev4PGOxKaG30LspZ4/5EyLzlBvZzHUiipYCWY/8EVasbXgLVHBzOH1s/MdSNsBVZh+V+sw3bdJyLOD8G89GbJ4qHPof/x3FKvME/NVieZfPRTOda27XISz4RP3DFriJEzLc/iFboUBia7TGm8SYDl24OaP9U0+aSyeQm6O3jvmwXyDeokUiy74e/kDGa+A4Thp/EYCUm5Idw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e06a3c73-15ee-4f3c-9dc1-08de11aba12d
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 20:43:17.6590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KvgHtR1WcMtUmNELSCLwQPNk9j32+gTjQENtoBxKBwJceZ+r3BUi5EcTiTZx4bEe0r5VD1B/Hf1vYlSd1loCzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR19MB3830
X-BESS-ID: 1761165801-103287-26825-9494-1
X-BESS-VER: 2019.1_20251001.1803
X-BESS-Apparent-Source-IP: 52.101.201.101
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVpaGRkBGBlDMKDXJ1NTA0MwiKc
	XC3DgpzSI5LTXFzCDF3CLZ0MLE1FSpNhYA1YR46kAAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268400 [from 
	cloudscan14-14.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1



On 10/22/25 22:20, Joanne Koong wrote:
> This adds support for daemons who preregister buffers to minimize the overhead
> of pinning/unpinning user pages and translating virtual addresses. Registered
> buffers pay the cost once during registration then reuse the pre-pinned pages,
> which helps reduce the per-op overhead.
> 
> This is on top of commit 211ddde0823f in the iouring tree.

Interesting, on a first glance this looks like an alternative
implementation of page pinning

https://lore.kernel.org/all/20240901-b4-fuse-uring-rfcv3-without-mmap-v3-17-9207f7391444@ddn.com/

At DDN we are running with that patch (changed commit message) and another
one that avoids io_uring_cmd_complete_in_task() - with pinned pages
the IO submitting application can directly write into header and payload
(note that the latter also required pinned headers)

Going to look into your approach tomorrow.



Thanks,
Bernd

