Return-Path: <io-uring+bounces-10093-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 63373BF9016
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 00:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4517D4E2E9D
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 22:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A4127465C;
	Tue, 21 Oct 2025 22:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ajhuHZGw"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DEA2690D1;
	Tue, 21 Oct 2025 22:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761084508; cv=fail; b=WGzzFzNdrqvWsHxTgYxVkxvtZdGsS9heG1PPreSkZvWIDyaYBeNx7zd1vXn4qu1NnwlMCHoP//nPwVC6ycIj/Bpt5t7FOgEC3VaxuDKNb00h/h/nH3o/9LJVYD2JvYdn/pwxDgE7EHgEQeEcgQWr+M/jBPrJJvOp7Yz++i/HCYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761084508; c=relaxed/simple;
	bh=42ytA+4io/2JvTzaVZyVFAUPvHXsP7ZMrDeoee3Pg+4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lxEUl2CGS/zUa1C+cQAqeuQQuSGRj8Qs4iMB7QadiU0q6EBBg8lXCDwmSUoUGoHrU78yit8ylMxvMy78lvVyPb6NL/gC8LDJCi1m9pNtYH4inac5MAo9ahm0digf4HaLPbvg5s6ityx3cnrz518AeKN8yG2MIHzSv4iJUSw2AtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ajhuHZGw; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020136.outbound.protection.outlook.com [52.101.61.136]) by mx-outbound20-4.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 21 Oct 2025 22:08:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MTqf81h3TcLu3uWixjUAeSxi6XKAiTjc2dsOwjufupkGtBfZ1liykpnSdFSmprlMCTvMeTe4FLiFULWsUHF2sQdvT4XptFgFSu8aBUInfxbo6syGflIN5R8GHCqDnC31ykUrZ1Vk+vkoH4JsDmQ6vDqeDsPyJfSKaex48jkj4D3Ev8PdwA2kYAzVLIawEO7w+hFewAS3s0kjkaeM17Vt1JoE8zT8xp5QYmcb2eFw3hSO7/ZbcVgDmXI0tQY573MC5q75oqzagkmSgN8Z3E2jnk+PbGCkLVWviqx/cEY6vDCK2kWjgk0lLOOd//IQcCx9zrhWhZDnIGDeuwVicP9/Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBoV6/vYcPY2rCpgDW9i+mZgSnngmqEOLfRWs0Hkqp4=;
 b=sCumDcdqxwM3y4PRs5wHpzwi+N2qul9rjVuwvDr5BmkzjC1PzP5cOt/F3+D9S/GRy+Nwe10+q2ZdrMF7+/vimilKYnYzuk/e3SkGPS6DbKKhLJBE/cC0By5MUA/MYsLGgwwCmI97JxcWtxt2URVUQn1Pgm78y3ZWRLsAPy0SB/NwRnqHon/xNJnt3YuyGEsnFOlFNt1fjyiX6K0ldxYJgX3ypzHPRt3x0wD18lCOyx3Ls3k/QtgZASgZXi8if4NTQwd01WLxmogiC+9DosSJBTe4mRSXK8NvmV5rEXZb3ATZUCSH2B6hIiV4NeCRStUeY34a6AwY+pQItrsa9xvSoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBoV6/vYcPY2rCpgDW9i+mZgSnngmqEOLfRWs0Hkqp4=;
 b=ajhuHZGwBBwznMa4qeAl41DQtBHh+fCNzKsnL6gXsjQz6vb/oyhhuZEeafcw4cSgZk2G1+dkCjBgVfncHj9LS8aWaN+GpsAyvtixvuyBX7qaSHoa2o6PzZkluPcXMwuSf/1Z2S576rCnLltuVh82E3RohmCIcD41+6V7ecBDltk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by CH4PR19MB8611.namprd19.prod.outlook.com (2603:10b6:610:22d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 22:08:16 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 22:08:16 +0000
Message-ID: <2460d0d7-486f-4520-b691-eb189912fade@ddn.com>
Date: Wed, 22 Oct 2025 00:08:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] fuse: check if system-wide io_uring is enabled
To: Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>, Luis Henriques <luis@igalia.com>
References: <20251021-io-uring-fix-check-systemwide-io-uring-enable-v1-1-01d4b4a8ef4f@ddn.com>
 <fa59bbce-cde5-4780-a18c-1883c3f9ebf9@kernel.dk>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <fa59bbce-cde5-4780-a18c-1883c3f9ebf9@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P191CA0001.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::6) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|CH4PR19MB8611:EE_
X-MS-Office365-Filtering-Correlation-Id: ec097585-7e32-4cb0-cea8-08de10ee55d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|19092799006|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eC9ONHVBSFlZQ1dWV05VWG10OXd5R3lhK1dMYytCZ1gwN25tS1pTL01MQmNq?=
 =?utf-8?B?dEZQdDF2N3lYYnE5dStZVDZUd0UrSFVsd1VwYTEwQ2t5M1ZhSm5hdUZQakVL?=
 =?utf-8?B?dFdVYWZOY3dnTDNLWFVYMU12Wk8rV0dvdDRuZlNtNy83c0tJWTVLSVBMNGtV?=
 =?utf-8?B?V21PTHNlOEsrWkRwT1RWZXI2bjBJSXZ3MEV4TlE1Ri9WaWtJSjkxVGdxblpl?=
 =?utf-8?B?dzFzQVZDa1NySTdrL0tFL2ZFVUZla00wWklLWjR1REV2Tmkxd2NjUHJBWkdj?=
 =?utf-8?B?MUlrSDZTNDNJbDJrVWN3WWw0OGIra1RFSzlhaEZFM2hWOXQyeDFmWkdHWTNB?=
 =?utf-8?B?bHlpV2hkVXMraHNUWGg5dW1KT2NqZHRIYnN3NEZZd2pyZ0pSbzZUOGkyYzIx?=
 =?utf-8?B?M2I1RU15L2EyYWxDNEdhdWJYT2g2NWJZODg5RTd0R0lWckFSYTZEWGtpNDFP?=
 =?utf-8?B?NS9OWndha1kzTVIrY1FacVpYSG11d21DSzVlQ1VERlErVEt3K3VDNXlEQmlK?=
 =?utf-8?B?azZrbWhYVzZmT1dvT1VkQjUzclorZ1N1N0pZNHFsTVJWYmgrcTZ5cnVRUVA0?=
 =?utf-8?B?bktNQnJTWkJneDBZbWEzNEVXcmFHVnRnRjJkNEU5TFVzc1pQUjkwZlNuM2FW?=
 =?utf-8?B?Unc3OUxRbXN4U2dGeXpXbXNCMUltTEZjZmZFeWptajM5VStDSnNmV2tHRVpa?=
 =?utf-8?B?Y2FhZWhwNDE4SEh1bzFWMDR1WDYxdkYwSk1OczcvL0JkbVc2UndaMk1HRSsv?=
 =?utf-8?B?eWV3eVNUenYrMTU0RTBHV2t3MzgwUW1MVWlBeEdTYUFjWjJZN1VOZERjQ3dn?=
 =?utf-8?B?eHJ3NmpGTXlUS3FqK0NIRk9FQk4yY1dCVmpLV0VMelFZbW1RTUl0K3cxY3NT?=
 =?utf-8?B?UzRqZFVCZzhUak5sVXllUlE1aGEyMWl1bnMybVFnTUd0d0VnMnNkbm5wYTJK?=
 =?utf-8?B?YWFFU21FeGw1SkE2WFFrRWdNMFNabHRvbWMxNTJiUG56MER1bE5tWWdmeDBU?=
 =?utf-8?B?Skx3QVFJcVJ1ZlhiN2ozY016SzlteUJWS0Vnb21JMXZnUTc5ejYzTkJ1VWha?=
 =?utf-8?B?TURBN1J4endidWdCZWhhV0tEQmszMld6dDdmblc5WVlPMnZnbjdyOVoxbFpR?=
 =?utf-8?B?WnJkMXU4Wi9IRHR5NWRvTUR6Y01rdDZVZ0ZhNTQrM1VjSHd6NEhoVkcrQitw?=
 =?utf-8?B?bnBObVpWR1ZQNWNtNGFqelNSNlltWmhUV3lZakdzbXZEVWt4S2VWN2FrWjEy?=
 =?utf-8?B?WXV4OU5XdlpiNksveTNPbjY5d3g4eFh6V1hTcW51V0F4a2RSTHc3blF0R2NN?=
 =?utf-8?B?VjVzdVdFdVl5MGJJOUFSVFRpbTRlNFdMVXU5dkdqU0NTbTdWVm9uN2hMT1JC?=
 =?utf-8?B?aDhjK3BIRzBDTDlha1R3aFVUa3RoU2RtTEFmQ2VKWUU3ZU1HSFBrQXBjMlV3?=
 =?utf-8?B?VW1oS1VUckhZRTBBejI0Y1JSZENVRUUxOS8xRlBoK1RFRVFQa05wdGIyc1BP?=
 =?utf-8?B?NHFqVHg2T1NlY0E3MmxQMndBNklwblV1OFpXQTVYOXVxMzJNbzFKdjIrOGlK?=
 =?utf-8?B?Y3hzVmw5a0ZlYVBvNWhWdGl0Rll6SENDUTlSdzBlSHIza1FCd1Y5TmhySXBm?=
 =?utf-8?B?d2IyZ0xlWUtndGJzWWRJdnkrN2o0N2lYWWdOSVpEUm1JMnJTSm9jSXBXdmx0?=
 =?utf-8?B?R0N6Rk1BVkxVSFd2NWNJM1pBUUZCeW5kTGNaUlQ3eStiVFIvUzhoYTdSandh?=
 =?utf-8?B?VjhRdnpCb0NEUDhWaENDWmRGY0xzaFFtbElzNk1mbFBITUFMMXdNQkVGWXlj?=
 =?utf-8?B?ZmtZV3VyY0F1citRMjZLVThUNlZNK25yczFlTzR6UHlmRllpaStuRWlDZFBO?=
 =?utf-8?B?VFZ1dUI3d0ltb3dzbURzVmRtSk5mVVFXdGFaS3h4OE1PWnNnQWFPbDB2Um52?=
 =?utf-8?B?a1RvRUIwa2lPRE00bWpQZjl3M2tHd2lRRVhPL3krQ2JKRE1KV0dJdWRURnU4?=
 =?utf-8?B?Wmp4ZUdWOUFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWsvaThqL1RralVnYkdkU3hobUgxb21QYUZsdERHUThnVFZ6UFNEL3lsLzJ6?=
 =?utf-8?B?Mi81Mzl3ci9ieS80ZDRwUFpSLzBLNndTTElFakxoVmo3bXNUTUpZeCtpbnYr?=
 =?utf-8?B?Z0RBbnl6LysvUFFrZUYrcElvenF6TEdFaFNwRmRUdXpSZjl4QXpBTmJCTWdh?=
 =?utf-8?B?QlpQSlF2a3dydThteDUxclgzQjhXVE40YzdnRlJHMmdWOGF2Z2dNYng0SGIw?=
 =?utf-8?B?ejd6NEFjQVRsS3pTR1BpTTBLTGNHeHZ1eFpXcnVtSWdhVFBLN2dZSDR4Y0di?=
 =?utf-8?B?a3NZckN0RlYvTWtTMVhsRHA5ekRjT0MxcXpoVXkvNytyNTkrZTlTVituM1Bs?=
 =?utf-8?B?Y0pSb2ZRVy9raE1DUFZzbTlxNDBPV2ZuakVmdEZRdEdqNXB6SmM2L01WSWtB?=
 =?utf-8?B?VHNRWE93SGMzRkwzUlRSYTNmN243VllkNjdCZnZzQlBHc2lZYTBHdExyRGxp?=
 =?utf-8?B?anlJb3h3eGVyZW9TdGEyL1psc0FSQVJWdFM4bUUvU29kcmxhSHhLeW92bGhi?=
 =?utf-8?B?Rk4xWHYzNzg2d1pDZUZHQkMrTHo5VC9kaEJ2NEpQQTZGZ0VObmZVUHRnVkV5?=
 =?utf-8?B?K3E5eXhCZXIwZy9JNFNRb2F5c3Fna1NMaS8zQzljZVVscVNXK0FSTUxhdTBv?=
 =?utf-8?B?Z3lNd0VwRlBPRDRDUXNGQUIwWlRhenVQZngwaGRUY1pCLzJvUHFNdkd6c1Yz?=
 =?utf-8?B?ZDA1OE91Qy80UXh6Z1luNW5NY09zd2FEcXJWZWRrNVFBbVFDQk9rRWtZNTFR?=
 =?utf-8?B?ZFI4VlNyT0hDMmovVnpscjBsYkVPNUxOazcyakVFM1V3MnBMald0YUJEME5o?=
 =?utf-8?B?N2xhM1A0ajhtRlhmL21ncEVseGw0L1Vkamt3ZmdIaW9STjREbDdJVVhXSWo1?=
 =?utf-8?B?Z3ZlcTQxMjdPRWtkLzBBQ1l5N2RyMlRjZUNycnIxVjJ0bTNlMjRSQ1pRRzRv?=
 =?utf-8?B?U0JVbk8yR3BTTk54WHlTVkhlaG9kWlZ6MW90Q2Z3ZDdhc0sxNno4NUhnL3E5?=
 =?utf-8?B?bGp3TkpGSzYxWUJ6WWRWaGdqdTJSeXFLY1NRTnE1U1hFWU5IMmxiVjJkYlRp?=
 =?utf-8?B?ZFFOejhobk0wUDNJZVdKNjZrNUViRUVYU0RWM2V4MDRNaVpnOWp4UUpSZ0w0?=
 =?utf-8?B?N2NtZVVLWHMxQmJBbnRnNndJQUVIRGtnUlo3OHJuc1RmU0t0VENuZTQ1Zjhk?=
 =?utf-8?B?VFUrQU1la1ZFM0NsQm1WUkFCU1VNUW1Zd2R3ZXV5VlpTVWhPQkVRbWVpanNa?=
 =?utf-8?B?Ryt3Zk9EdXJEQVA1T25mbDNCVmxiSi9jQWhVUlJwZkJLTW5ueXFzbUJFZGN4?=
 =?utf-8?B?K0NqK2wxbUtBbmRLQ3o4YlJ3ME9ORVVxMHUzQmg0ZXBoNkJtUzcyVzhKbENL?=
 =?utf-8?B?cENSMkgyOE93QmRrRTBxdi9CRnUwckY3L1ovMDVaT1ZTR3lTbEZTcXZtTzJ5?=
 =?utf-8?B?S09nZmlsRW9LUmV6REdaSTBhV1RoM3N3VlFnbEhGZVdRanppbVZaWXdFSmFo?=
 =?utf-8?B?dkp6cTVOd2tvckZuU083dnhyNzdhekpKOWw2WEtSNWNuRUd3TkVRR1lFckFQ?=
 =?utf-8?B?SzFndGdBbzJ5Z3d3dmhZQkZqZ0hmVE9CTHJHTzYrcDY4OUpsUXZKbmNOV0Ru?=
 =?utf-8?B?akh5bnB3QVZIa3NjYzBNL0lnQzMzN3Y5enpsNXJDbkFraUFDdXpzRGVzYjNC?=
 =?utf-8?B?ZFYyZ2J2RENaSlk0NjNBZWNtRnFCcGZ1RjFBNi9VSzFQNVdTNXRaZ0RtU2xK?=
 =?utf-8?B?UjVtUHRseUFDeXEzOElPRUgrU0Y4S0ZDb3ZHbWcybnVhamhmc05XZ2tZa1lM?=
 =?utf-8?B?ZFRRMXFYMm5pUHU0TmxWdURHMGpoK1ltZFZqSExaMUZsREhneVNZUDdiVE0r?=
 =?utf-8?B?MlZmYWFrcXIrY1drZEhrczdUNXZDUUk5ZElxRjlWTHpqU21Xelh3cHNlZWIv?=
 =?utf-8?B?QWRWVG4zYUoySWx2RnlqTGpoOW9SZVhJaU9la3hML2JRd3ZWVE9ZNjExSVhn?=
 =?utf-8?B?UkZRSW16enp3bm4wM0xkQWhteWR3bjlMd29SYWhPK0R2RXdiUVpLUkxsa2FZ?=
 =?utf-8?B?YVpkbDMvTlpTcDBrOVNSQWUwVHBpbGhiQjRlYS9DSDBTempITnBRWUNwdi9K?=
 =?utf-8?B?ZEJwSGVadURXejgwWXJMNFpZeE1leEtLYVYwQUlpTHl5Rmg2L3RUczZsdG9h?=
 =?utf-8?Q?xtl7R8SSt1NHjrH/A7wdO7mVn3q5D+EtxHLCaXNqLopr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	93T16W/mKnc6eIFXqBnc7SAuE8OkjxXFo+r0esFUcZG9NIdTfx7oPzVx3aq3i6+ZIOSJTDzjL1nznuXJcUcJly6Ag5SaYvvct0JieV2MbT13aYAZcwEDXdjSqY0hri6qCHm7gwXDcXpVHuXAoLIUjfqU2uBzkWuPnJPlvjteGgi0uGoPZ9+ZP/rxtVjDZDExkWAwNGzmrVIt6kQf5/auycHaxUggnmyqS4R5OjXfrhO7WsUpZ6SwN7WTQ6E32nD3XtpwhTpiGQNJpGRuvDoc+Pb0+EhlItGxN3R7ARjf4tX7O3GrWb7V3nngnZ3FdjWHku9qL4SF86c07+a+OVCkXCUVkjPs7SlGtvAtSUOkvJvaGiMbTETnapY/WcVMv8JPiiPq3f0M6JBS7MvUyJiHCXKQONfSaD5/5NvXIcw+sG5JhXgr0F11ryxsot3sqq2fIlIBIwansUGSCakDvwDJhcoKLHQtbZa6ZqWYB+7yGgqJRiSxLd4RTi3BiDRc2KExD6DnrGNglLRm4ZhzB3KwTSFyGg0NianHuahU9Qy5do+xgeA2Ir/ZnsK/jiKOTgWFgQZwCqaEkc+HtoC1t1yIdvTlhuGw0CAjJlp6BPFeuewmPI9l8B1QASpWCjHbugNoVAHZBv5XBX3LoZ+kDCJjwQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec097585-7e32-4cb0-cea8-08de10ee55d4
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 22:08:16.4005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbYMjxNapsUgI9DOgFbCvr1hN6YoFNwM/l/rhYB0hMODZzwcAi5UfBCWoidg/9XptrenMOG10/QuOVBJxFUOmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR19MB8611
X-BESS-ID: 1761084499-105124-8600-4238-1
X-BESS-VER: 2019.1_20251001.1803
X-BESS-Apparent-Source-IP: 52.101.61.136
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkaGliZAVgZQMCnNMCXJ0NzIwt
	DQLMXE2CzRwjg5OSXN3MDQJDE1xcRSqTYWAMQ2zkBBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268378 [from 
	cloudscan19-96.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1



On 10/21/25 23:56, Jens Axboe wrote:
> On 10/21/25 2:31 PM, Bernd Schubert wrote:
>> Add check_system_io_uring() to determine if system-wide io_uring is
>> available for a FUSE mount. This is useful because FUSE io_uring
>> can only be enabled if the system allows it. Main issue with
>> fuse-io-uring is that the mount point hangs until queues are
>> initialized. If system wide io-uring is disabled queues cannot
>> be initialized and the mount will hang till forcefully umounted.
>> Libfuse solves that by setting up the ring before replying
>> to FUSE_INIT, but we also have to consider other implementations
>> and might get easily missed in development.
>>
>> When mount specifies user_id and group_id (e.g., via unprivileged
>> fusermount with s-bit) not equal 0, the permission check must use
>> the daemon's credentials, not the mount task's (root) credentials.
>> Otherwise io_uring_allowed() incorrectly allows io_uring due to
>> root's CAP_SYS_ADMIN capability.
> 
> Rather than need various heuristics, it'd be a lot better if asking for
> fuse-io_uring would just not "hang" at mount time and be able to recover
> better?

We can consider this as well. Issue is that fuse has a limit on
background requests that is protected with a lock. And there is lock order
to handle. Initially I didn't have this hanging mount, until I handled
this background request limit in fuse-io-uring with the lock order. 
I.e. when one switches from /dev/fuse read/write to io-uring lock order
changes.
A way to avoid that issue is to split the background request limit equally
between queues. Although I wouldn't like to do that before fallback
to other queues is possible - which brings its own discussion points

https://lore.kernel.org/r/20251003-reduced-nr-ring-queues_3-v2-0-742ff1a8fc58@ddn.com

> 
> There are also other considerations that may mean that part of init will
> fail, doesn't seem like the best idea to me to attempt to catch all of
> this rather than just be able to gracefully handle errors at
> initialization time.

It is still doesn't seem to be right to me that fuse advertizes io-uring
in FUSE_INIT to the daemon, when system wide io-uring is disabled.


Thanks,
Bernd


