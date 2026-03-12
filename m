Return-Path: <io-uring+bounces-12654-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UEzzAfLgsmncQQAAu9opvQ
	(envelope-from <io-uring+bounces-12654-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:51:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 34136274E2A
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C2BB53023DBD
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 15:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B003B47C5;
	Thu, 12 Mar 2026 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="QOwG2WEt"
X-Original-To: io-uring@vger.kernel.org
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021102.outbound.protection.outlook.com [40.107.192.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1203EF654;
	Thu, 12 Mar 2026 15:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.192.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773330575; cv=fail; b=YBcQ81pCo1LFF9K1cODOVJrg/WfcEUXq4zKXlHnxuw2SAHTfPtBAEZSyR0gQ9GcJiUNEwKaLcOEmkGMxF0Wq5MKxFsl1IC7+VUmVBJhmBSXOakmZ5ms7BdJmisKt/nBQnshGZY9mWVvloBQs0Nnzzx3HUmA8doutIHu5wagLaCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773330575; c=relaxed/simple;
	bh=MdVz00LzKdY5lJhCS3MOxCmsjyk8ag4jF6jSMm0JyGU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uToKstk8QxJbkfKUsJsO6gPvFaQxM5mIHCk8czYqyJjOlBAoN9UxNTJs2tOlgI718V/rQs0Wrpf3xcnKrtrMYGKxgeOmEvzgCcKWM9vnkK2hx3ewd6jR0ryWDVgYd1BTzTZGElmNAhgQuD96eSaxgxF7xEdmU+1k4h78E9xO1n8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=QOwG2WEt; arc=fail smtp.client-ip=40.107.192.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bhi48NCjGTLHjCSLcJjjhyVCIlwH2yhBLY++GM7K4Gt+nM0TCziV5JCP0MZlgJrcCgpufDVTnbpgy4nmZUmNPnRAwQZRYXWW/8lTkzcWHv9GlnCkd633ti++3MU2THvGVBBmCOvMktO1o8MpoWRT/IK4JqvI7oIa00q13sVWpXZ0WoUZlk1kRj+BnCtr+of1ZJ2UV/2LnardH2ULsGQtlOgPmjO6a2Xs9OjrckXcMXFLi7MJr14CjJxr0S9voVM3/Y29hDHMBaVY0TTl5s3si+V1YM3BvZ2KSiP7dJq2IqIEDf7U9i/AViMq7jOjUSEycBgtghM4TTU6UKCFGWTO+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+f1OS1gXJn7QXukqE5ZKY8YOg8IHXLISgDrGg7moAU=;
 b=yKq0x4NdnjLpubIFr1q7w4HSz8QFflJEdPWJaijELdoaTylt6ou4+Wtcr5bRdpEQ2Yn797YxE0ox0Uwr1zlLY0zhM/3VHuYJtr422ux9eRdwGFE2u9PJi4IauTOrGkvu9OwRCdqLOhMjF+9b5dasI1r8h2n6VaBFbCSO0+EiJ3M+ce+/pQHdeF6SWiWCum7O/iT/LLLliGnwKtL+fr2wFHVT53kmfmNNfBgV6XKBt3KItTbe7ERYXv2j6hp7xgtHuXFYcxBF/TB7dHd7kUe6WKusxiRCKpYAtyoe2ujjgILQaFdNpot1F0IhXZko9xkKy8/9k8Xu6PMT8a+lDMh3Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+f1OS1gXJn7QXukqE5ZKY8YOg8IHXLISgDrGg7moAU=;
 b=QOwG2WEtH2lDIceIgFCkJgqLqfqdRUE1HV4yNavueIqrG3i4mQR8US7PtMHNHa1DyijRze1BRay9V3zKoqSXyOQkGiAHUMFf3bbt2KKb3szm7YrPETalck/Pk5tfaRsmS7vgAZcM9la34fUXVjwsTZF3k83MQ9ewI49vaubVcxsUOecwRKhHKfmrB8WO8hk+vJ6Exh5FXGGWdDwetpupTxmHp+lYqzcnF4sGYcZTYvwZQ7oKduPvYIpBXmljvu+8+xpB/Wg4BxmLX04vNE/RShTAzCC/QLeabhcWZEW69+pza5NKJIW5YdqSNYzVhoUxPJCUa3lFRE79DMiovqePew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT1PPF9FBEE6684.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b08::56e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.16; Thu, 12 Mar
 2026 15:49:27 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9700.015; Thu, 12 Mar 2026
 15:49:24 +0000
Message-ID: <1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com>
Date: Thu, 12 Mar 2026 11:49:23 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
 Peter Zijlstra <peterz@infradead.org>, Dmitry Ilvokhin <d@ilvokhin.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
 Aaron Conole <aconole@redhat.com>, Eelco Chaudron <echaudro@redhat.com>,
 Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org,
 bpf@vger.kernel.org, linux-sctp@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, dev@openvswitch.org,
 Oded Gabbay <ogabbay@kernel.org>, Koby Elbaz <koby.elbaz@intel.com>,
 dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rafael@kernel.org>,
 Viresh Kumar <viresh.kumar@linaro.org>,
 "Gautham R. Shenoy" <gautham.shenoy@amd.com>, Huang Rui <ray.huang@amd.com>,
 Mario Limonciello <mario.limonciello@amd.com>, Len Brown <lenb@kernel.org>,
 Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
 linux-pm@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Chanwoo Choi <cw00.choi@samsung.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, linaro-mm-sig@lists.linaro.org,
 Eddie James <eajames@linux.ibm.com>,
 Andrew Jeffery <andrew@codeconstruct.com.au>, Joel Stanley <joel@jms.id.au>,
 linux-fsi@lists.ozlabs.org, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>,
 Danilo Krummrich <dakr@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Philipp Stanner <phasta@kernel.org>, Harry Wentland
 <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>,
 amd-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>,
 Benjamin Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org,
 Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-i2c@vger.kernel.org,
 Mark Brown <broonie@kernel.org>,
 Michael Hennerich <michael.hennerich@analog.com>,
 =?UTF-8?Q?Nuno_S=C3=A1?= <nuno.sa@analog.com>, linux-spi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com>
 <20260312112354.3dd99e36@gandalf.local.home>
 <219d015d-076b-4c80-8f63-88569115fdad@efficios.com>
 <20260312114041.5193c729@gandalf.local.home>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260312114041.5193c729@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0018.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::22) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT1PPF9FBEE6684:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b2414cd-f9a0-4f3b-2712-08de804eef5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CCU/Y6dWVcv//xk15ypG7eITc5aQM5bWdOX1u0Bg7LwgrkyHe1wzrwTN5wXXfc5xJCRIakvlCYqdfwdCceaIQFvddxgxCzlQs/IBorNWI0UEoO+mq924zyCtOX4JBRa9rN9zpPbp0JJNTHvaa0PV9WUYu6shnbacYkirruurEEK5KveBdc8qAokvYzgv9O0kPSU4X7J8jC2TYPGjzHTVggJjJtd95SQPMUpF/8bKPRuJXBsks3p7pm8rNuLzkRmYYe7TFfQgh9bFzduN8qrPz6le68qUPo14DQU0vcQnMs7+4yOl0RApfwCBfOJuWhj+bHD+VWbOz83lUg/el537KTfDaV75oL7RowCGOziZZUdlPQ0xJ3hDGclxiISSslmDImqoqyLCKnWtOPnGSZZ0l0MiAZztX8uVJlx5pHuKEjWD38UG7InzMrY68f0dFRTCnw2RzIAPDNtYwiZKROkRI0Hxp6WJR8TlRKr++J3/9hzixnMjukIKvL8Zbktg0i8t4OmfhXCadZTLkQJ/GMS7S13YFu5nFRltQ+CjQzTXIQGu+TVLFMzAL/4WObVG8i/knmreglFb335L29gNuWMmaDQpb7vdXnytVPYuURluTd0taHORk0p76aBppL8BFumWY8JawPXZm//vYPDc14V5XI00ex6bVQMllVX8jN/WF142cQg6/4zy/SZPWX6OTLLE
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlVoOVVSRkVTdmhnT29ncDBnZDZ1a0REMDBxWUx2cXk5NlpLeVpyWWhxWWYv?=
 =?utf-8?B?UWZScCtxTVU0aU01dENzakdVMGNEaDNDaGRDcTFrc1dLeFI5WlB1RmZmeWFY?=
 =?utf-8?B?d25rYTRjajB5Qm1CblJEbkc3WjZlU0Y5bkRuUG1VUG1OTk12UVlmUmJ4YUxa?=
 =?utf-8?B?UGJUc0pxdVVteEdHbXlDT1ZJS1JJM1lyRE16NFdpRTMxejJvemhscXpDdDBw?=
 =?utf-8?B?cGxsOFhqVWJ2SFpYanBibHQ5cG9hNDZPZGdHc2VYTXVFUGdoZ3BibW5aSG92?=
 =?utf-8?B?Z1pXbHdJNklnd0JQU3hiYzcxT0JEWkk3NG0rdmQvclVmNndwVWErOU9ldmJ5?=
 =?utf-8?B?LzRYS2dsMk5jR3NoQi9aRnJzWGh0UUJqZC84UXk1L09JWng3bmIxZ0EvWU5L?=
 =?utf-8?B?b0laaENpWkxrbkhnazZMN1F1WXI1Q0FVdy9IeFI0ZXU5aG1wNUxLNnRyVVRU?=
 =?utf-8?B?R0Ura05JVkxwR1JnOFBHWUZBWTdLZjhlU1V6U3pubHFCc1gySE5ZK2wydkhR?=
 =?utf-8?B?NHhHSjhkVkJoZXc5N0l6WFh2WWtqcC80Q1IvVVF5OTFlQy81U1NSNzlWSWpk?=
 =?utf-8?B?dnNPb01QcmNjWHRYdTYyMXlpcFhhaHFUUHBQdkRpMVBSaGRGRnREUHZiclhP?=
 =?utf-8?B?Q2RNS293SVdEWmZDdkV1Qi8yQ2V2b3hleHRib1VOQ0xQcWNPTnNkWlVkZHVV?=
 =?utf-8?B?Y2plczlBZ2k5Uzl1Sm1wdnFzMzZ1RHI3a3NoaWdOMC9KMlYzeFhxcUExbzBa?=
 =?utf-8?B?WHdvZzRtMVo2RjBQMFB5UkFqTktVZERsQVlZWktEVFo2bmtkUk9zbGwxcm5P?=
 =?utf-8?B?R2JEZTNqRjV2VHpqT01EWFdzVE1weU9KR0JGLzl6N2pxa1I2WFdzR1NDMDVw?=
 =?utf-8?B?d3BMaEVxcyszREx4U0dyRHNWVlRTNUQ4VUZYVU16NWZ6WnVSMk5rS2NaMllP?=
 =?utf-8?B?K1owbWpid0RsZlVEZG4ybkZpbittdTVnOFhLMXpUei9iWnZNWm5PeWY3WXhn?=
 =?utf-8?B?TGwya21OYlNMWlpISDdiOXhWb2tHM1AxTmZQblYrdXJobmF0akZhaThtdXVr?=
 =?utf-8?B?R2dHVGowb0tybkdVeis1SW14bEp3c2h6Z0o4Y0dBcnpuV3cvK1gwY2pmTVBq?=
 =?utf-8?B?Zld6UHZGQStORyt1VHEzRDFURDJ0UnNneHhzelJreURtVWIvSXhsRWVhQkJr?=
 =?utf-8?B?MU9KL1RoWVpFS2VSSUxmZFFlaGF1SDh5Z1NBQ3lUQUd4aXRqWTgwd25ET1F4?=
 =?utf-8?B?eDI0b0h2bnpWMUJQUDI2ZEpvMDF2TWJVTStQNFcwQ2g0M3R3QTJ0WVJRTGx6?=
 =?utf-8?B?Q3JOZ0RrSnJZUjBGY1dpSG96VloyR21zczM2YklzYm9PN211dFVnNUx2YlNa?=
 =?utf-8?B?MmZiMXYyb1E5T3RrdmxEVGJHaThqZU5pY0JzQXRWZEZUM0JhR0N3aXBIK0VO?=
 =?utf-8?B?elhUb0JoQTVTRldxN3VXYndZazdJMGFHRFZuN0NjTDgxaGZBNDA3c3JOaGlD?=
 =?utf-8?B?Tk45NExwZk9rM2FtMXRsY09yZUtLcFNRQU5pN0lBMUpLNDJKNXRLMlE3RWIx?=
 =?utf-8?B?Q250QW5CQ2F4cE4vcHZCVXE1aUZFaUZlZll1OXVsZHF3NEp2Z1BMN2dRRGdM?=
 =?utf-8?B?L3lQemhHMVN3QkZaNHRaekNpaml6YVIvTjlTbXFvWGNKc3MvUTBuQTV3Ymp1?=
 =?utf-8?B?NlB2c3JEQmZNWGE0aDA2UXdXWU1JZFJwUlQvYkUvSVlQb1Y5anE5ZjNzR3Rj?=
 =?utf-8?B?Y0RJOUtJeWpiUTB4N2xUR3JYRE9ZVWRvbndGWmFhcEJpTGtZTEhQNVZmVWJH?=
 =?utf-8?B?NHhUcEtyTkhHNnBzWU9aVEpoYlkwSi85UnlnVitobk5EcFVtajBZNG9hRCtp?=
 =?utf-8?B?cnRxbzhxNGVvRmhpSTBaSjQ2bXI4RFJlcG13UU5aenpvYi9IMDRLSkpwejdB?=
 =?utf-8?B?SVN3alZkWmJyUFpjWDdnMis1N05rNGRuaWhGNkUxQmxTcXdrYjZJZTRnWXI2?=
 =?utf-8?B?UGVqUmkydUxRbG9UL296T2ZmNnFldXQ4aXZRMDluNEYxenFyL3JKNlhjZFB6?=
 =?utf-8?B?OUlMYUpGcHl4dnZFTVR1S25RSUExV0R4cWtsZEwvZ043KzZYRkJhWUs4RDVu?=
 =?utf-8?B?dlpmdU84bXRHSjdKNi9TT0Z6Zm5xdTlLb1ptdzE1Y1lYNkhiem9Celo0UDhR?=
 =?utf-8?B?ZXBqNDUxZ0pDVDBReTB4bWkrVnkrczJZNVMxRnhRaWpMR3BvazdPNG9BbzlT?=
 =?utf-8?B?SlZWcTBlY3h6THVCRnR0QmN5YzZGREtOLzFycURlMlNBQ2sydzgyV2lXbS8x?=
 =?utf-8?B?RmRLVWtQbjVDRHI5QlY5VCtpaUxvMG9NYmY4aWhMdjRTRmMvRE9PZTQ2TGpG?=
 =?utf-8?Q?uF1Lyn94eYFiXfV0=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2414cd-f9a0-4f3b-2712-08de804eef5d
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 15:49:24.6247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +5uLUtuitkHCTOMsAWxUvvwujOax/8mw+bzWboKw/HDzJRI5hQJwSWEeZOaUhAFcH+15CaSGPnUpnk/IrPZfDmb5LWggTp1PlNuqINXqnKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PPF9FBEE6684
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[efficios.com,none];
	R_DKIM_ALLOW(-0.20)[efficios.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[bitbyteword.org,infradead.org,ilvokhin.com,kernel.org,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,gmail.com,ovn.org,lists.sourceforge.net,openvswitch.org,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,HansenPartnership.com,oracle.com,fb.com,suse.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12654-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[efficios.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mathieu.desnoyers@efficios.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[72];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	DBL_BLOCKED_OPENRESOLVER(0.00)[efficios.com:dkim,efficios.com:mid,efficios.com:email,efficios.com:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 34136274E2A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 2026-03-12 11:40, Steven Rostedt wrote:
> On Thu, 12 Mar 2026 11:28:07 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>>> Note, Vineeth came up with the naming. I would have done "do" but when I
>>> saw "invoke" I thought it sounded better.
>>
>> It works as long as you don't have a tracing subsystem called
>> "invoke", then you get into identifier clash territory.
> 
> True. Perhaps we should do the double underscore trick.
> 
> Instead of:  trace_invoke_foo()
> 
> use:  trace_invoke__foo()
> 
> 
> Which will make it more visible to what the trace event is.
> 
> Hmm, we probably should have used: trace__foo() for all tracepoints, as
> there's still functions that are called trace_foo() that are not
> tracepoints :-p

One certain way to eliminate identifier clash would be to go for a
prefix to "trace_", e.g.

do_trace_foo()
call_trace_foo()
emit_trace_foo()
__trace_foo()
invoke_trace_foo()
dispatch_trace_foo()

Thanks,

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

