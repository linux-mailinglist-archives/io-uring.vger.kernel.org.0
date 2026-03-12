Return-Path: <io-uring+bounces-12657-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IGHbFhLlsmktQwAAu9opvQ
	(envelope-from <io-uring+bounces-12657-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 17:08:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0CF4275375
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 17:08:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0058E308452B
	for <lists+io-uring@lfdr.de>; Thu, 12 Mar 2026 15:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5FA23F20E0;
	Thu, 12 Mar 2026 15:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="GmE/XUVZ"
X-Original-To: io-uring@vger.kernel.org
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022092.outbound.protection.outlook.com [40.107.193.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5554D375AD1;
	Thu, 12 Mar 2026 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.193.92
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773331046; cv=fail; b=NQX8efcCXcSYrZMTbvnnZDR5V2r0jvMoRcB09MCiS0xHDOBV6lBFNvrhXn/ndJoNyJVsmvBJoSOzlCGSHgEO0wxMKWz2wjAovv4++IQM9qV+LX4xdP3/yl9KmyA4GjgXRYer9A3W1kGWGnrpJubxhjNgQ288rAG0memY2A70ow8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773331046; c=relaxed/simple;
	bh=w8RzDv7BzuKN8s8cgRCGntm9SMCvU25P1a5St6YP7Zg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GRJadYdlIHGcmr8IVXZjHHq6/zUpQDckKz6K3t3eWLBhsWxViV23SUj/tazhlHXSIFfQ7m9wzqsfGJWobZFh7cGwndUMJx8p2WRBj458o1smJ4O8vwcmGmPEXulajJnR7eHv8lNld1Tf4u3d9npAN7rqK71GFrh3M2vsx7CTxaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=GmE/XUVZ; arc=fail smtp.client-ip=40.107.193.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GaMGwmHHjQQePAHMs5ijOduQ0xwWGKm18m1T0G9TqJLmAe3eIZ9nCG3PJlwDRwapDVPY59DggmaWeudeqdTeYGGe//OUIEPzG8KsJ5bxKAJ2VYTMn0szTSKBjLb9Y9f32XEtetkR/V/9Gv1TWDDebKvOWoMLPVv37m/nFtsBJzvrgRb6R9conQLD0eWLJFJ+TDBEvQ3dw4qUnO2qrZOcRSQ2QIpGvou1NDnZ4gDsOiVwBlQuFtZ3/NPs9dyKXmRrn45R1yuHEOt7+OtIoQPsYZ4bXREXIEAsR2z8xcuMDxMKWC8ZU/XowNNJNAX44PIVvY16fcOElTndi5f5W/vAJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jkqc7rcxY/K0RJfKNVqeImmYE24S7ANYYImzjvUHDHA=;
 b=lmCrGOIs9dctDGSvbmogHMrjYBkph9F3ou9IIkMOWryXsQ5mP9ecZd0PVSS3UqgXxj0uzf8Ck5Zcqol7H1++fPMt+TgLtaTYYR9y8Jw4D0SY+yFoaMMjK1fUkUK6xoNHX6Y2e9MfNu+FkKN+vP7Dyf2FWhgSZ9cBs8HstPy+eYJCEo4tJfzy5b265BBa8JRmSsOok7W74CJsIqLVC8enXMH+IXHRPpD7opd5MexQGycNYUsbpxo43iWkXk3+PmRUQTjy6O3BmZ3dJJlx/FA3jJvpC0zKk+QBP0swZdQCH2FqiEIxuCeVknq57G/6OwdkS8xd9fbN0UUleLqqkjJIfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jkqc7rcxY/K0RJfKNVqeImmYE24S7ANYYImzjvUHDHA=;
 b=GmE/XUVZYMlesL2VBsYq4FkQA+mqDEd2OBpdNuuv2sBRtZNB5KPlEe+fzI91Ezkz71AypVVcjIeiS+UUvU9PAXlsyvvbl1gz+wuHi78HOEXeXXA1YZmtTvgLfzBlRLDr0+eXW/Vjr6PkRgZfnKczWLFsdwNspfFqxfCDbxUs2NX7m/ySPRYTOSqB6AsTszocoUE1d1MvHRjJfxZEfN3EBBEHx7kvQE6rlI/h00NCNK5ZS+urv49HLw+iMF2kEpj8iD4gD0O1au+pprOH2KeVFNYxHsezV+GXwlGQsx3PP4DZsLXure05RiBmn3buplyY2rQZ7zvow2XtMK6JPNPIzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=efficios.com;
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT2PR01MB6497.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Thu, 12 Mar
 2026 15:57:21 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9700.015; Thu, 12 Mar 2026
 15:57:18 +0000
Message-ID: <d32e2250-6fac-4e2e-a010-1c1d21e39ac5@efficios.com>
Date: Thu, 12 Mar 2026 11:57:17 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] tracepoint: Avoid double static_branch evaluation
 at guarded call sites
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
 Dmitry Ilvokhin <d@ilvokhin.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
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
 <20260312155429.GC1282955@noisy.programming.kicks-ass.net>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260312155429.GC1282955@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT4PR01CA0408.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::13) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT2PR01MB6497:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fd00cd6-b151-4a90-5e3c-08de80500992
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UUGLab4+BeT04517YTgHOP8N2GpWt3KxXbtxDj4683LL8N07RhseGgfxvZTZrBcnihjdyKQYlgL4EyeRgy0yT2+v83JfPt9yOjiBZJntt/R7OQuMty/Y0jANmULqnJRA7KMgBMlMY4GEeYewN4InwEprlYIm9kxECy0G6XalJM+EkWeNxwX/RAbtGigptmnMIjkqAIY3MqEpoPfkTkZrf8GM0QhCEnfZzshQ1gHwMSr7QaUkh1MVAQvZJULcfqgsja559UCY8Kej3VJiNZvN1y0K5LmYE8mOlN1IBAQ6j0wlxJqdkeFeuHqmxlDDlE+bmVagN3aebmYi36VXaKdEKDmEFVPyOvXAo2MvX46JNZyw9x1B5+QfyEBMhxX4rsr4py9K4IfSg2R6htc3p1LGyaul1PGgl15BD+tFLYxttXI4Mavn9+k7MTxvIpjghU3fqaBxo5jgH+VTO7HwjORBNwgGWTS7geH5psPjsG4YEyHi7bh1J5iebKD+LDuELaX9211ltBfWJ2jAG4o7jtMeJwQJwXxZVmhBPUcYXjBYIPsXu3Aa97RPsy7ZaLHuSpaniJT70+g/PToKprCCxBCCpTAA4FrWoGXnWYXsJ3eQBR0K7rEXE9k4jJuW5U0PsDn1ayvmqFclkMQqS0sMDllFAT0/MuhIPeQTLj0IAdRcaxtC+iK0bFg7Jui0mi8Z5a4M
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3NhVFYxR0FyYURMRmZacUt6YmFMallpenlJamhCeUNsemVIY3pKRFBEbWQ3?=
 =?utf-8?B?eTdWRE5Kc0o2N2JBb2JEdzVkWGxnT1BONGtseGpiRlRKNk5TeXFJc2pZczB3?=
 =?utf-8?B?bnpwRm5vR1NhRUlRcUdMd1dSMlJoTHZYOVlaa1UxaXorL3BtUnRHTG1GTmRO?=
 =?utf-8?B?Q0IzRTBsRXR3QVhPMWF4cFY0NFVZb285MGV4ZDlUcFU3c1JYZzl6UlZYc01Y?=
 =?utf-8?B?bHc2NjBVS3NLeFMvd0g3c0pYd3F3V0JrZ2l2dkVWTnMvNGRleEk1Y29YaTQ4?=
 =?utf-8?B?S0ZxZitsZlVtbEk4Si9rSU1wbGtTZ2xJdUJoUE0waTFxN0poN1J1Q2ZSSDBH?=
 =?utf-8?B?KzI3eUNlY1kzdHJGT1hDNGFza0RCT29FTFE1RVlEUElRMHZGN3BEK2txZDNT?=
 =?utf-8?B?a1RwNVYyWGl3WUREeHdSUEp1QlFtQ1gwaVJFY1p3dVhnOUJBQzZGQmhWK09X?=
 =?utf-8?B?OVg2ZFJoQlE1MjFDeERGa2dhZ3oyZU1RcEZiMzd2eHdsQ0VJUTR6MkRJUEdP?=
 =?utf-8?B?UjVCRWpDODVkTk11LzdzZ1BrTWkwOGtzSTNlUExudHBtTnhCODE2NnViUWtY?=
 =?utf-8?B?TGFYYkJmZFdqZlBTc3FFQjY5K0d6MXpjN3pZYTR4aFYrUDgyNkxIRGZQclRS?=
 =?utf-8?B?ZTR1MTVjajdDamppSVBIbjBLMHFLcDhnMkRGNlVyZ2hHRkZlV2pRK0xpOThY?=
 =?utf-8?B?clBwQ1VKQnBYTVY4aGE2aUoxcEF2MTJSalRTU0FuTGthSDZPWCtJQmsvM2gx?=
 =?utf-8?B?Q0piUWNzYVRwSFk5SnlYM0ttWWROMUZGV3UyUkhETCsybnRuWWdoVGpmSllV?=
 =?utf-8?B?R2dMc2M3WlRpYTVET09QdkRqekRnK2lLQm9ZNk9zcjRNeXBHWE15R1NLQ0hK?=
 =?utf-8?B?MDF3elFSRmFJazVaV0NFZUorcTlzMngvd0VMYXVxZm1rTm4zZFZaMTZoNlRu?=
 =?utf-8?B?dkMzNE96c3IveTd2cXZHODJVMjNuSGFaU0xqWThmdGtuOVlhOGRNdW0zT1Qy?=
 =?utf-8?B?dVg0aW1VUkxiUy93bFo2SGMrYS9tbldpNjdOOVJYSXY5NmhyNWQ1R3NacTZY?=
 =?utf-8?B?NmFnYjRnY2NKbThkUXd2MnR2MXN5MEhTbFFOZk1kWWhYd0UreFV0VWhxWXg0?=
 =?utf-8?B?WXA5ZHJBWFdCSEFMRUFpdldsTm4yRmxXQ2k0bWo1SXRaWjNxQUN0RWZ2ajNt?=
 =?utf-8?B?UjNkWDY1cUo3N1BQd1JMaFdUNGVGb1RWbisvNUNSMjAxUlZPdEEycWxMZTdt?=
 =?utf-8?B?MUwrMVNjeS9XbTJCN2JxWWEyaVVBdDBKSEhOcS9ZajhGTzBuL1ZyN1lHaDll?=
 =?utf-8?B?SUZ5YTdtVnB3dDBKNUFRUTdScHoyQVBDUDdZektuK0x1MDdZay9ycFlQNTVr?=
 =?utf-8?B?dStGbGdsNytiWjJZZFpxcXFOcGt6T041dWFZTWlGaGNOZ1F2OUJubmp3Sm8r?=
 =?utf-8?B?Mk9LUlRHaFBWdUpwQlJlMTFHejRhdmx4TVlFTzhkb2x1RkpPU1c3dG53VmNh?=
 =?utf-8?B?elJzWTY0Um0xcnRlaTFKQituMHJDdDJqNDNEamlablc5V0xjeDlIUjM2MlZY?=
 =?utf-8?B?K0dyb3dZK1hybFdxOE1aS3ZObW5IQUp5QnFYQS8xeWNNUVB2K09tNDhMOVlR?=
 =?utf-8?B?OWtJUE9wTXZyV29hclJYUEJQTDlUdy9MSHExR043cTlVRFZxMWxWNEhwcVlw?=
 =?utf-8?B?RVViaFNMZlBObi9WYkZGTzdaZEN3Q2dnZGxiSDEvaTdLQnVuM0Z4bHNhcFhN?=
 =?utf-8?B?Si9sODJqbUVzT3Rzd1ZMUUVOS0V4QU5vV2NUdXhVdE04QkRqcnJlM0I1YWUr?=
 =?utf-8?B?Tk1qZXZLQ1BhREJVSEVuR2szQWpBUUNIelhqYmxESGlJbFlSbkY1ZEkwbkJX?=
 =?utf-8?B?TDJGN3R2WU4wRUJVTk5tbkxNVFdQVEdCTFZXeEtNZUJNa0xYMHF3cGlXRGhX?=
 =?utf-8?B?bm1wSTZLZy9qWUNLMk41V1lwZk42MWtGMXZMWGQrLzVOTkVFQ1BRR2I5L1lC?=
 =?utf-8?B?VDQyUG4zbWd0YjJsdHAvSUNUZngzMlZ4RVZJN1dFaHFTYURRaWxwYlBsRVNt?=
 =?utf-8?B?TDdIb05QWHNQYWxMelhUTjRjU3JRS2gvUkY4VkRiWFZvY3hQZUhnNlpFL2NE?=
 =?utf-8?B?eTBQRXhYSjhKYlJqTVlNNXRqRnlmQ0ZCano2UC9mRDhHNEp4T0hRQ1ZlTjJ6?=
 =?utf-8?B?VXU3TXRkVGZtZUxNVzFDQk5EV3pqTWwreDVtZWRuZnM1M1Y3RlArWnFkSUV4?=
 =?utf-8?B?Q2hCRDhYa04vSDc3S1BabFFRL0JINVFLNVVXZklxQkMxKzRFeUtuVkZneHVI?=
 =?utf-8?B?YTZyY0JMcmRrcnVqSGp0TnE3eEUzcHpaUlFsNjh4WHNCZE9sckY0VzRKbndi?=
 =?utf-8?Q?PBD4F2pFUgupWCIk=3D?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd00cd6-b151-4a90-5e3c-08de80500992
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 15:57:18.1806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKjm5x9qhHbT4H0LLd/HDfhoHan/mNvC5X/CbgM07M26Mtw1QKPjBob+uwM1iJUuel03OtM+YXGXIdTxO32K37vGF7miN2DsM/wnfw+M8Jg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6497
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[efficios.com,none];
	R_DKIM_ALLOW(-0.20)[efficios.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[goodmis.org,bitbyteword.org,ilvokhin.com,kernel.org,redhat.com,kernel.dk,vger.kernel.org,davemloft.net,google.com,iogearbox.net,gmail.com,ovn.org,lists.sourceforge.net,openvswitch.org,intel.com,lists.freedesktop.org,linaro.org,amd.com,linux.intel.com,samsung.com,lists.linaro.org,linux.ibm.com,codeconstruct.com.au,jms.id.au,lists.ozlabs.org,ffwll.ch,sang-engineering.com,analog.com,hansenpartnership.com,oracle.com,fb.com,suse.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12657-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[efficios.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
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
X-Rspamd-Queue-Id: A0CF4275375
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 2026-03-12 11:54, Peter Zijlstra wrote:
> On Thu, Mar 12, 2026 at 11:49:23AM -0400, Mathieu Desnoyers wrote:
>> On 2026-03-12 11:40, Steven Rostedt wrote:
>>> On Thu, 12 Mar 2026 11:28:07 -0400
>>> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>>>
>>>>> Note, Vineeth came up with the naming. I would have done "do" but when I
>>>>> saw "invoke" I thought it sounded better.
>>>>
>>>> It works as long as you don't have a tracing subsystem called
>>>> "invoke", then you get into identifier clash territory.
>>>
>>> True. Perhaps we should do the double underscore trick.
>>>
>>> Instead of:  trace_invoke_foo()
>>>
>>> use:  trace_invoke__foo()
>>>
>>>
>>> Which will make it more visible to what the trace event is.
>>>
>>> Hmm, we probably should have used: trace__foo() for all tracepoints, as
>>> there's still functions that are called trace_foo() that are not
>>> tracepoints :-p
>>
>> One certain way to eliminate identifier clash would be to go for a
>> prefix to "trace_", e.g.
> 
> Oh, I know!, call them __do_trace_##foo().
> 
> /me runs like hell

So s/__do_trace_/do_trace_/g and call it a day ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

