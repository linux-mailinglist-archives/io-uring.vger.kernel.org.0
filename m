Return-Path: <io-uring+bounces-12727-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIj0MCZ7uWmxHAIAu9opvQ
	(envelope-from <io-uring+bounces-12727-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 17:02:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 874722AD837
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 17:02:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5A1033020870
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 16:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CAF2F6586;
	Tue, 17 Mar 2026 16:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="EDzgPeHQ"
X-Original-To: io-uring@vger.kernel.org
Received: from YT3PR01CU008.outbound.protection.outlook.com (mail-canadacentralazon11020103.outbound.protection.outlook.com [52.101.189.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5E42D593E;
	Tue, 17 Mar 2026 16:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.189.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773763344; cv=fail; b=jLUxBb4SfNQ4Err75c0YvsgnOheXqXTP70x9X6Lgg11+9aaMOjBDmcckJQ6o7uYJWpfIdrsHIpKc/RD33cJ8mA+eX1ljSSpQmXuHPUWWSKD1DbLEzktjnHagM2wtgIi7K89lpTP52LsDdTHTqfmRoqjK/mutcDjEyPz1S4AVEiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773763344; c=relaxed/simple;
	bh=7hFJ3TArkBRSEeFB5ouWfdZX4niwJblXSmuo1pu00+k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aFy9HfXXuY7o8mEa5b5Ckt12EFrKfDukYB+JMtTP6xKVenlmXvI/sUNNhDbNw6BAbKXn2dXPOvoD6+exxMFjjL6WPXmWCuVU/JHcZ7+Z/WZLGPE054W3GGpRsKG6vGi20uzb+hednd7OdpxiXfJq1OoNcRSzeIVTb0aaT28wh20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=EDzgPeHQ; arc=fail smtp.client-ip=52.101.189.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OsmPmzYzWF5tAoPD8xKrAbGM76mwOKmkS8QlL9057w0l8RrSwNBaMJcRi0xvk0sgUgre42+pWJ+WCMUpllB3QM6Rm16kTvfdIkC+sMtzrPym/L9KGta9u6kJIJxP02u/vyeirp5frC03LlQC5+W8YwqVtOHWiBsXtH8k1BgH+sUNrVK0tktX0UZIKcPaI6kxh2FxSOlsKpmHz/b268Ec+kCTOCm9YGpwQBHOE2SKmXCXbVUNOPlpnHu5wAFaGO8Yo8HHNIgF8cU8ZOYz2aHWcngYqjlbwaICGNXuGQfhH2MJdcje9rCF5OrH0OcrzEml1VMvDKH0yvUUPb+GOE+19g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6nYAt2rANnvmH+6XhOsldNbRJtyrelEu+XebSnaROw=;
 b=efLJwnMN10JvzzKhBLUPRU59mQYKlgXA7MIm/Rm/n4xi0F7ZE847Te8vNjT4EumMXHGXetexYyqnAhJShVvpqTZLg+4HJcLsWpq9DIX2GOMx+CtnvQxCowcpulR4CHRmPD1PkmdN966nM69W9/k+UQXSrBwVH1RFwiqj6PqK2aXDorFs4ZMKoyBV78ewxdQWrEGK7ZIG3s+Bk7ywo82Jd4G8gZnPe4Quj++2DAKY/9t8zfWBpMC72MjKCJK3kH+FBMcz+qEAEePEGEieCBNU77rqDzvBg61VkzFxAGh86fTsW1qQnmLJGva9R6cgXgQQkypmeKQXeQ3DOi/7y2fZBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6nYAt2rANnvmH+6XhOsldNbRJtyrelEu+XebSnaROw=;
 b=EDzgPeHQmITtrivFWWbAfEOJAb8bvb0tFsb4dvxtTukN3fgV2hyq7KO0xuFslEj6nJvdAFcRrC5HRCExRGfS3gd3uxytd3QdcmZ6ND9+qeWUNDno69pH/GdXT/+u8FVTf1UL2PKSHoUgIV8fS34iGZstGKQk2qZ2DSQ4ODOlSpW+lwY+gzb1U9ii0oVUK5jNAGLzY1/UNmCe9WiLKfX8ccmA/6R26ER2N1tT9Wc6zc3SZ7u1X33aGhA2xa/0UtbQiMrdWBtmY+KlWs9ZA2EUnn9bg+Zv5qULpKsRZkr4USl4Wu7dFIWn24GEYoi/3hysVXbZeZfNaS9XC1i+jGEPpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YQBPR0101MB9550.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:81::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 16:02:10 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9700.024; Tue, 17 Mar 2026
 16:02:08 +0000
Message-ID: <6ca9f884-9566-4a82-9995-4c802a0bf8a0@efficios.com>
Date: Tue, 17 Mar 2026 12:02:07 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
To: Steven Rostedt <rostedt@goodmis.org>,
 Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260312150523.2054552-1-vineeth@bitbyteword.org>
 <1e3c2830-765e-4271-89f7-0b6784b37597@efficios.com>
 <20260312112354.3dd99e36@gandalf.local.home>
 <219d015d-076b-4c80-8f63-88569115fdad@efficios.com>
 <20260312114041.5193c729@gandalf.local.home>
 <1becdbce-2c01-468a-bbab-42b5dea9fdf8@efficios.com>
 <CAO7JXPjnnruhM5oC6xMgnYaQ9efzYFqMCFiJLNM3HCQ+ZeCiJw@mail.gmail.com>
 <CAEf4BzbnfyhCqp0ne=2gRnVxp-mdGmuZwDeFRyhRYH+eDcz2-w@mail.gmail.com>
 <20260312130255.6476e560@gandalf.local.home>
 <CAO7JXPgHYZ9zF1HFahb2447X85YRZCQQBHB6ihOwKSDtiZi8kQ@mail.gmail.com>
 <20260317120049.6a60fa88@gandalf.local.home>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260317120049.6a60fa88@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR01CA0118.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::18) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YQBPR0101MB9550:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dba82a3-a93c-40fe-7618-08de843e8aec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Fd5seIWNdep06J+o9YfnYnmnktzaRbFheZK66W9xWXPpGVap5d/32LfvZeGLFo3r5gSbfU9SyKc7F99MexxjsGdQqteKYWwwc+mc7iKTENgDR4Xwj+6wDD6zPDLe9uQQw27hMzVXzKN4W8WqzqmGtts75eS01+2ezzssG2s+awhHl/Ngp8Vg+v/6A/E/Y3mydRzXyIJKLy9VueHjF3ubo7C9zynRx4Tc2cdsM8VFuc2Q6X2/obI///c1ScNm67+Jtamj6jl2hZxhvx8Y4Zas/Z6JVj0z/ZMKnR9pPQPmnfIV9gd4wPosZQqlnsGrC85npVaZzlvk+eJcWwnaSGZ8cSin7K4ZwB5XM9j2YNYG9XDEGYfAg9bst9jMY3rV6Yq3bx3K9jn5THGwvdOYM8EcSrr3qREL3CYI3bW6MHX09Q7/ruC4pZTMJiokPNC+FKyl9R4n7GStwE69wQGYolYatWCNmQLlgSbhbhG+4xoDD5QaOx36a4cALof0+2NZzVmewHFeaQN39PyWMUgqwK04UGY7/Zyy8WoX0qS5rChOlc2EJjizWPE7gcrttc+S6EruYMdkQM91+Tjt2AewpAlPAQqoB4SqzWCim0ZTM6HWsrQJ9cvVLBe9Al+qd+3SmmpknyFMtXCJM+3LgI1lchMOVvyCyWExvZUi3VKrHkVTcjQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHpGVzAzekUrNlBKTHBuNTdPanJROXNPVlpSYmszbzVrbFZuK2FzTHFhYVBI?=
 =?utf-8?B?TkxCN0ZJbGgrMGhnS2d5MUI5MXhlQWUvK0VXR3R3NnV0c05jMVZyRDUyemUv?=
 =?utf-8?B?Ym05Wk5Rc1pUZ3M5aE92M0s2NUJBZmVQQ1drUXlTc0hVMlBENzFOTUpyMnVr?=
 =?utf-8?B?Z1lqakJEWGkyMFVoZkNqMzliYUdGUzBJaUJEVVZKclRud0F4dVFaZU03dW5p?=
 =?utf-8?B?UmY5QnN3ajNmdkdsdWNzZjlHc0JSbVBiOHNUb3dZMTc5RndnRTRXZ3diZ1M0?=
 =?utf-8?B?THplVEhQSUdENWFnbExmbFNRek5PeExHTVBrL0xjK1lwRVkyVzBmU3o0L1Fm?=
 =?utf-8?B?ejByRUtqTDRWVXFSajEyYUxUSDEvMnZOcDhJN2NmRzZkczAzZmZad0JKcUY2?=
 =?utf-8?B?cCtJdWFLanFJVDZzQklrR080Y1MwN2hlMWFyM2t5b0Y5WGpJYjBIRHRMR0cw?=
 =?utf-8?B?dUY5YnE5SVM1enB1bFRreG9NS2VDV2Q5WThpdmNRRjdMYjVlZXBORjk5M3dY?=
 =?utf-8?B?Wm9sR2tFRTFnaDVacHZXV0tMdkY1amxwUjJqUVQrWUg2Um9uWW41QlU3ekxv?=
 =?utf-8?B?ZlJnU0Jya1Z1ZFdoOFY0aDc0ZDhKOThyNHNocUMvMk9pVzdjMmJjR3RKRHJB?=
 =?utf-8?B?OHIxalpUNG5MZUcrY0cybG1obkJBVDBuWlUrdUMvTUthcjRjVzltZG5kY0Nr?=
 =?utf-8?B?eTlDV3Rha3dYeTNicStjZHNCeUszTXBwSE1TOVpsTkxXYlloRWNMdFF1eGFZ?=
 =?utf-8?B?NmtrY2IvNkRyT3J4a3BpV25xNW1mTkplRmJqVm1mQ3dvUkhqckxLSzFQNTZM?=
 =?utf-8?B?eWk4SHUzNjA0S3o3SW1BZFVRckFIa1J1QTZaLzFFOXJrLzFHdkM1R3duVUx5?=
 =?utf-8?B?dHFKTVhZVlFQaWdFdW8yWVUzdWl1SmhsYm53azJpR3VPQjNJZnFLSXllRFh4?=
 =?utf-8?B?UG9ZaWpmSmZYWHhYVnZsNWtoamtqVVZvdHlUeFhkbVM2Nlk2ZGhUby9PUHV0?=
 =?utf-8?B?aEU5NWNjdU5NUDBNZmFOSjZqOHB4cGkwZEM0bE15N29yQWdYdkNLb3I2MVVO?=
 =?utf-8?B?YlFSbTczSTZvWnBBbWp2WVpDR0FXb3dIMERGaTRoOEpkOUNqYUxwVVNoY1kr?=
 =?utf-8?B?SGxhUUUzZWN3b0pxaGpudU5hRDg5TGpzb3hzdk5FT1RGTGY4Y0hDdGZUVGt3?=
 =?utf-8?B?NVdtckZhbm5SUmpIT2Rrb29HN3lZMGxyYWVyL052V2U4RHIrZ1g4THZDNEpk?=
 =?utf-8?B?NVZNbGFaMkdtUHptQnVWUHlNZFVmREx5eTlpWWxTRzVmTmdRWDA2ajRKV2Yy?=
 =?utf-8?B?c1lUNkRhTnJsTE1VMkZpSEZnYkU5blZsZHdvZWlyL0N2eGdzN3NRZjF6TW1N?=
 =?utf-8?B?SXpPRnphY0xwbjRnd2xTUlFDck9CNUFLcGZVYlpxNS80dTFycHg2WXJBUTk5?=
 =?utf-8?B?SWlXdnBLbFJiYUF4U0Z2SGsyM1JpYnEzMFlvN2tjd09lMmplVjVGUjhYMnln?=
 =?utf-8?B?T0RiSndnekJsWHpVWSs0NVBQQndGYXEwcFpNQlJUcUJibitjVzBPaGVDNmd2?=
 =?utf-8?B?MXRVUmlGQ25qMU12aXpacUhhblRHTXg2ZSs1SmFtNkFkTmUvcEx1MnR4TnhC?=
 =?utf-8?B?Z0JkcnI5V1NCTzQ1T0lyVkJGZzc0ejhhaVJNT2VmN3Y5akVZbktML3RKR3NE?=
 =?utf-8?B?blpRcHBQUFh6VzNoaGxYU3VMK2Eyd0llVy9VV09ObDNpcERmWVNLbUxudTNq?=
 =?utf-8?B?bU9hSE5SOEVCRllIeUJwTFE3NDJGd3l1NVllYUJIQWtveGg0RXBodUNiRmNl?=
 =?utf-8?B?MCtPOWJFL3NtNGFSV0NCaU91Ukpta09XMVFMS1hVY2drbUNzS0xQcnV1RmNL?=
 =?utf-8?B?M0RWK3h3Y2NyaTBaaHlSTlZCUlI3Mnl1akV0T25YV2tueGovSUswZklBVDJQ?=
 =?utf-8?B?T2J1a3RkL2VkNlo4VlpYQ0hGWndVaVkxMWc0K09ycWdhSWloZ1h0RVUvYXBq?=
 =?utf-8?B?elFrOVZPWVFITkNlcDZWQTZJaXNONDJsWWFKUVM1cC9odkozY1NqWDgzRjVP?=
 =?utf-8?B?QkJkRjErWVBtUVNCS25pcEw5Zm1xR0FZeHQ1ME1xZ3JkNlV3Zmg2a2RVdG13?=
 =?utf-8?B?Y3VIVGR6NG9VYkVCUnhWUmtBanhPM2dlbEJSZXVQMFBMUkJrS0ZtaXhmOEtk?=
 =?utf-8?B?NTNTVHdzTVZYQUt1eVlEWUt4MDZXQStMajVkVDcrckh1aWVIckRNVDFWSmRB?=
 =?utf-8?B?WHh3VU9kTFZUVVRVSGNFM29pM25LN2gwUnFlV21Xb21EcmdEN1NEOWorR1FM?=
 =?utf-8?B?UVR3ZEhMMlJDN0ZwNDFndzVBMUxiamxvWnFiQVJ4SkVEYmkrU3FSQlZjMUd3?=
 =?utf-8?Q?f+SS0krKrjtNC5d21yMJIHuPw0vgrfrBGDQvE?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dba82a3-a93c-40fe-7618-08de843e8aec
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 16:02:08.7751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQ32woqbOF/dZJhETZ35VyvJMtpMETAczjg4AC4vMSvhwEA6qvbQKwPA0gYSeK2ZUbZXtQJKMs7+5cn/u3ysVxj+gMfLfV6JKwPraZywVQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB9550
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[efficios.com,none];
	R_DKIM_ALLOW(-0.20)[efficios.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,infradead.org,ilvokhin.com,kernel.org,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,ovn.org,lists.sourceforge.net,openvswitch.org,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,hansenpartnership.com,oracle.com,fb.com,suse.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12727-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[efficios.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mathieu.desnoyers@efficios.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[73];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,bitbyteword.org:email,efficios.com:dkim,efficios.com:mid,efficios.com:url]
X-Rspamd-Queue-Id: 874722AD837
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 2026-03-17 12:00, Steven Rostedt wrote:
> On Fri, 13 Mar 2026 10:02:32 -0400
> Vineeth Remanan Pillai <vineeth@bitbyteword.org> wrote:
> 
>>>
>>> Perhaps: call_trace_foo() ?
>>>   
>> call_trace_foo has one collision with the tracepoint
>> sched_update_nr_running and a function
>> call_trace_sched_update_nr_running. I had considered this and later
>> moved to trace_invoke_foo() because of the collision. But I can rename
>> call_trace_sched_update_nr_running to something else if call_trace_foo
>> is the general consensus.
> 
> OK, then lets go with: trace_call__foo()
> 
> The double underscore should prevent any name collisions.
> 
> Does anyone have an objections?
I'm OK with it.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

