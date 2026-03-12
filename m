Return-Path: <io-uring+bounces-12650-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMEeFOjcsmmtQQAAu9opvQ
	(envelope-from <io-uring+bounces-12650-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:34:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B87AE274929
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 16:33:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8348E3108F73
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 15:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DC93BED1D;
	Thu, 12 Mar 2026 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="cVZDLM0X"
X-Original-To: io-uring@vger.kernel.org
Received: from YT5PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11021093.outbound.protection.outlook.com [40.107.192.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70D2295DAC;
	Thu, 12 Mar 2026 15:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.192.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773329299; cv=fail; b=Wo/oJ+NBuHrT0gJb6OzGJrl4+YgbxuCZ4cZ20t4zpt2P56QbiNWn9Up6WCoCJa7Vp+RL389ii7oOTkIm8PhJDcmgmQRpAcFryRC4nDVAWSCQEDASsQUxwaPg2EjHB2vG10eF8jsSY28UBQ2/0DgaSm4u2cSBK//bp8C31ynIKRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773329299; c=relaxed/simple;
	bh=+Zc3vlzTMGe/L0aRQyIt1xsmomUi2khrLSIaKbfzc9g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pw5GRp/y3ZEgk290Rft3nqvysIz2Mg+q1GqrN7l/uMUnpZjW00DyUt+EiB6vUDEBvOeWpWgWnVScVnLP8pOCASIdheef+p37bb8GliOUHQ3BW3IUZrFYr2PAULSCkhKKyAdGMPYsb72evM0TmRe6yeIw7OSDL+LFW5ijdR/Mtwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=cVZDLM0X; arc=fail smtp.client-ip=40.107.192.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0eciYYZ1kC0YfmXxxbPuK9a5QrMy99m1hQ+GjO4VOehOOrsXOOwpUMuKZQxcIpBnLlGX1NXlsqnPu5KtvnhtiyVSxzpxLmBkMGGk44jYn4EDX8VWQzfbpmO783RXMr4dPAdT6TdJa/bzTFBh/tipHYUQOFHhcB1gOnsnlRbUSTbILH1OdF0DEdtsbMmPjiXgAoC4GXzl0vGnWEvEAbSe0YyRGOQnRKAWfSKu+i9SNq72/0Du1BG71Mynasyivg95DyCTCGOU7+kZXIa2k80drL3vw66g76S8JCK//DDZZ6rDNafDfWUaqIR2ePFy2btHDLR68ZWsY5kLsNIZvlodQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fyE9YKYZ2l7vSlZuph4G4Ipsw+rzPxtapYIq78oDrc=;
 b=eA+H4/g8juOWon7u/sn+tsFUH3esrOfoPQqMy1Mk0evGCjajwL4rKX/GcJf1DKC6R9s0dfQ+oHyKN1nqIzOyg92OBR+Hx4YISioUnm9IWceEoDYDm45wvEc0xRi3K8t6okJIXrF8OSOT0yFv1UEmIA8VWX2fsvSRm0wqkSAN/z4VQAxIXt2lxjacEl49EWgSliZ1YTLCImbrtjBM6G1ENp6BGvXXOagImaFc9pj9iT7HRs2MIzq0oM4UrDPdhqC+4uGCFHN3VhOVWaV+K8yKyIYEOQHJao1B9NR4QpD1j3Rw3XxiWi6qkpOsRddWgYs82I41bUDjp5/aikPqKWYA7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6fyE9YKYZ2l7vSlZuph4G4Ipsw+rzPxtapYIq78oDrc=;
 b=cVZDLM0XR+3P+jR1RDu1i9z6bQS/bNlid0do4qzc95e6SNtxZt/dTPGd0X1oetueIE8Ce1ReIdtLFTSP2Tn9Fs2JDIQE/K2+WwyUgg0mtvisJ0O76hIdJoyJDVDtqbda7ULOIPA2QQPZHZOTk2onlOgUXhnDV7KcwmehM+L+KvIdz1YBN28qd2IBd4vciaCOnFx/a8W8kf60YXU7ByxQYUAOzJfRXucXcigSvrKkge1bBKGKhvm0DuU7GBtTih1AoReUJ/RHISxwQaQsExht1rZFqR4pC/zf8vPCE9GDGcWHTHgK+xd3TVYW8nrz4yYYyJFPRtRsaQGyISraTBQ4kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT3PR01MB5489.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:61::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Thu, 12 Mar
 2026 15:28:11 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9700.015; Thu, 12 Mar 2026
 15:28:08 +0000
Message-ID: <219d015d-076b-4c80-8f63-88569115fdad@efficios.com>
Date: Thu, 12 Mar 2026 11:28:07 -0400
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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260312112354.3dd99e36@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0140.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::18) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT3PR01MB5489:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b9384eb-8eb4-47ba-72f3-08de804bf6b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GtuKgrsXoof730hErIgwDxBLempp0wA+gObvtdwqEile/Aic/NbFR5omzszxT4zGfrLA3PaW9Whthk1ElCHGV/iS+n9yBV6Lx58P0+FokffyCekrZ3CZjz+K/Xmzyo7NNwCFBfQFPiXsBRVIu5Mv0+tKEUX7YzfHv/e8HxOFZSRqgirlH1JV2INxha5RcXN2xabQezTwvzIADMbApwoqyiV8b+v9e6AEf9OrgGZW9MY32Bgh8CSN1JsjJg5AUho3CLSb25k5pvJx7dUt+qG6CZ+h8XIMNVsSUZEYJTLwRZ8wdgE2IGGxJ5xTCkJ9XhSu1QnNVzDC92bTyrGYhNCfbPselr3/7iKuvo0EJRTrggbNb6RnmrWBUMU8Icotw8FnRBEncexhc+iz/JhVHXV72HeBOJ8I5UiHAO5yntEnl9axI8KEe0S/mpww+7OJsdJA5N+w1ahfWv2RuVLH9nTCtiSjrNNMbvAogT/S75M6MT3q+UStOEreJsPvdH1fXMrC3QNd3p7UOQkWyas0xHV+vUUetD32mHKev0s0BTW/dUjgND99XRs3Mixscfs7XgJq2wZ6KjZ+80zgMslNQV97C6gixRwW8+gz3uZAHDzNHnQBQWVZGejy//P3+RmVK6RlaHrlAuI8MPs843z+uYCT0QiV0toaLDybfJ6AsWKI1111GenABegdTBoe9uDLDwhI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHpXMnhsVVB4MmFmQ0NBdU9KUVFFMGlBL1gzUFJlbjhmY2xZWThyNk5qVFZz?=
 =?utf-8?B?K3dBOTlCcDNnTmM5MW5NcXZ2VGpTUFJsQ1lHR0w4ZFZKUXVLUHRGSWJyYk9V?=
 =?utf-8?B?RExadkhva0xXa0k4eE1TM2FKenJFbFVTNUZMZFY3anl6cG5MbE0ybkJ0eUdz?=
 =?utf-8?B?cDBCeEZyNnhGOVhwc21wS0hXWnR5NjFHMDVYOEtnS0lWaXJSajRJY3VKMVJR?=
 =?utf-8?B?ZnlwL2RvRjc4K3ducWVmbVhNZyswTlI5enZjeDVWak8vdUNWMldQeHU4M0tM?=
 =?utf-8?B?aEJxNWtza21hNlN3SDFrWUZ3aGFnR2MvZGh1MGVlTGhIRnY5L1ZEZmo2MVNq?=
 =?utf-8?B?THlsODVNbHFsNlg0VDE1MnBiRVBobzRyeTJ1UnZFdVl5MFJsSXFZMlA2eXRx?=
 =?utf-8?B?ZjVsTE5SQStXNW5nK1RyMFVNY3JZdTNxcURKOGN3dnEwVjZUNUx0dkh6QzhD?=
 =?utf-8?B?cStqandtZlI2Vy83ZjdVN2NUL1BKMGFxb0hNQTdwUUIrUjY1Wm9tU2x2MDNJ?=
 =?utf-8?B?REpwRW9zMmYwa0txNHJ6bTRwT0xMZHFhSXo3Vkh4V2xYcXNvRHBiL2RuN2FN?=
 =?utf-8?B?bzF6bzlyQUN1NHdwZC9YT05keTAyMzAzQ3Q2TnFqWjBWYWZxdHJ0NE8vOUpn?=
 =?utf-8?B?TTBCQng1SUhQdDBHN2R0VWE4Y2JtYnNhc1B3VEVsMjdqdVZmR3MwQXBrdW5s?=
 =?utf-8?B?cHFiS2FHSnQ0VlhFbUdzVk9SUXlXNHgzNWQ4ejl4QVBNSjU3OEdGRHhjQXdW?=
 =?utf-8?B?cWVOL2JGZGZ6Z284OU01V2JUamc4alozREpYQXpqZEtJREF3NDZOVWk5N1lW?=
 =?utf-8?B?Y2FSbzJXamF5dmd4Z25udVJVK2U5Q0k2T05LUkZMeDBtWHBCeDJhVHlWUUdB?=
 =?utf-8?B?V2ljOExwaWNLcDgxS0ZQN04zQmFHa0RXMlhnVkpKVkhlRE5ZT09hMmhqYzln?=
 =?utf-8?B?V3pFMzhSYmhkYWk4eE5lN1JVN1NsRnV1ZnBzNWQ3RUE3TTRrOGVHUk1FWk50?=
 =?utf-8?B?blhtOFkzZWNnaDV1T3hZWDlEMHJaS2cvRUZIbUVvZXNOSk1aVFFKL2JrRTlB?=
 =?utf-8?B?cTFMbVkrYkk2RGJ4UlZSbEV3WStWRTMvRUx6TWZvVGRhVWRwNEE3R1JuM3Nz?=
 =?utf-8?B?WUhqVCtVbTdxc3BGcjg5dmozbVNTTENwOC9mbC9QM1I4OEJaN0JlMkJvL0Fx?=
 =?utf-8?B?S1NubFNqVVVDcUdYc1BNeDRuODBrcWc1S2dpM3FPdWpKT0lIOU82WVBKejVE?=
 =?utf-8?B?eUR0T2hINVZmQlBMMUFFYWppYisvTlJTQUVaQ1J0M0tydDdmT1hIbDc3TzdJ?=
 =?utf-8?B?dzZ4UmxlRGdsbnhvUU5UQXRIdXhZVENHc0ttd0FtWnNjSStPbkZSbWVXc2oy?=
 =?utf-8?B?UWM5cDI5RWpWR0txM3NJV0FEZzR5YTdQK21qL21wZ1BjMi9KUUIwOW0xZHZR?=
 =?utf-8?B?OHU5dkRObjNGOWdkY1RKYTdMWDhoMFlMSHJweFc2aGdJbWc2elVFby9UUG5s?=
 =?utf-8?B?cjlvOVNXMmdSRGw5SHRNVTJ6YVRXbHAwOHV6cWtWSjNNaFQ3a2k1ZW11NkZk?=
 =?utf-8?B?Zkh5RHhNVGJDajUvVVpVUlR2N2JTaE0zeFpZVmZpOGM5T0Ryem1pUHRDU0Jq?=
 =?utf-8?B?bDU0VU85VGFRRHluV3RtalI4V2RTc0ZwTlVBdWlmTFRyVWdwZjJpMW5ta1F5?=
 =?utf-8?B?TnVoNTdHRUYrSnhCZ1BRRTZMZGFhbWpLMkxpSEd1dnpMR01Ick43Z3l6MnBk?=
 =?utf-8?B?T2VkYjBSZ0twMGV5WUtoUzRCQkYxcTV4WXNzaDRyRVFaNXRxN21vV2RXQy9h?=
 =?utf-8?B?YTkxcU1UdFdvRGdpTTA0Smt0K0MrcUJTNWhEWE9ZYnhlbGNhRWRLQ2Z4MmJU?=
 =?utf-8?B?dmI3cUJ1aVR5VlI1Q0NFczlhK25LSUVNQ2JMUGJrQVJqd3JzRE0va2w5UTlp?=
 =?utf-8?B?QjRzc1RaUUdDOTdBSDlkdTg3elNlbHc2ZWttRUNrMkhzSVBhM3JRLzJuNWMy?=
 =?utf-8?B?R0NvQjJyWk5zMU9FMldlam1wWUgxTTBCbEZsU2NTQ0RGTHkvVHZZTkpjWFY2?=
 =?utf-8?B?bGtIUXdEalUrWkNUNkdBbFl3dkUxTENzZ25tcTdtbUVZZDY3NldCSlcwM09M?=
 =?utf-8?B?RFR1UU9XUWJYSEVYY21OVmNSYlp0OVk4THhMV2JCN1hGY0tvUjRNSHVGSzB2?=
 =?utf-8?B?eEo3ZVBtR2FySHF5WlZpYnh5clpKclFaRWZkNzhGdjVNT3Q0SXJJa05TWUtH?=
 =?utf-8?B?R3ZsNi9mY0xaaU9VOHJaSVRiczMxRVdOMk5KZUZ3dVBvUnVXajJEcFFRb2o4?=
 =?utf-8?B?dW5qVmp2eS9hbks1cDNsOWJ4VUcyakZLY3JTMXpxYTdBdGFPL2VpTVZMbDlM?=
 =?utf-8?Q?N0G7qJDZl//9Kdyg=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9384eb-8eb4-47ba-72f3-08de804bf6b1
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 15:28:08.4972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 14Kd8DpPOuqEmLjuDA0H5TJOkhjXC4hS9l6M+tdR+vXFCEeA6d1VCWETWURnsr1PD7ccuNEzeEXkQLKbs4KodiVH6RYs7/8xaMtz4E+klgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5489
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[efficios.com,none];
	R_DKIM_ALLOW(-0.20)[efficios.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[bitbyteword.org,infradead.org,ilvokhin.com,kernel.org,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,gmail.com,ovn.org,lists.sourceforge.net,openvswitch.org,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,HansenPartnership.com,oracle.com,fb.com,suse.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12650-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[efficios.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mathieu.desnoyers@efficios.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[72];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring,renesas];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,efficios.com:dkim,efficios.com:mid,efficios.com:email,efficios.com:url]
X-Rspamd-Queue-Id: B87AE274929
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 2026-03-12 11:23, Steven Rostedt wrote:
> On Thu, 12 Mar 2026 11:12:41 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>>>     if (trace_foo_enabled() && cond)
>>>         trace_invoke_foo(args);   /* calls __do_trace_foo() directly */
>>
>> FYI, we have a similar concept in LTTng-UST for userspace
>> instrumentation already:
>>
>> if (lttng_ust_tracepoint_enabled(provider, name))
>>           lttng_ust_do_tracepoint(provider, name, ...);
>>
>> Perhaps it can provide some ideas about API naming.
> 
> I find the word "invoke" sounding more official than "do" ;-)
> 
> Note, Vineeth came up with the naming. I would have done "do" but when I
> saw "invoke" I thought it sounded better.

It works as long as you don't have a tracing subsystem called
"invoke", then you get into identifier clash territory.

Thanks,

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

