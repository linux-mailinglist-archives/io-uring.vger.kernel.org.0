Return-Path: <io-uring+bounces-10950-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A6CCA3485
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 11:47:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B774F3004514
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 10:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A103396FE;
	Thu,  4 Dec 2025 10:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="J7BBn3HA"
X-Original-To: io-uring@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011039.outbound.protection.outlook.com [40.93.194.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66A23370E3;
	Thu,  4 Dec 2025 10:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764845220; cv=fail; b=kQLB6nBG9sUzUPup39P+FtgKz4KrZvB8SStO1uSz0xAyIGLNa8kL//ttKJHyBWeEWTb/jfKCKEawJ6q/f7DcXljN5wPw+l5W03b/AB4LMQniaXOGUsjtJGQkJxemM3U4/heFSkKqArKh9p1wr5FMBWM3UJDUGgCawPdOx7rvUgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764845220; c=relaxed/simple;
	bh=JFETFwiqgQiaQ2ap6NRbtT8xIkMgtcspeREVyEgX6QY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kIMNLk5reW4Sn9Uo/Odbp9znoBlnLTQ1ckYvUhxa2FKjaa14Ju9Me+MkOAjfYtYFQz1lM1isAMBXGU29HjP9F2shLAJqnBBpIPo0x4gVZhWYrJb5T2AfF39v+b/tsowLCLzL/YvVlrApjDjyRokWMOXPHpCm2bvODG7yJiG1F3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=J7BBn3HA; arc=fail smtp.client-ip=40.93.194.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=om6dEyDamlcqJnipA2axlhP+MZRfLzRq2Wgp6CMUQlc4k3Bu3IxAOTp8vdc9cvbKekmu7rPGSW8qABG/Fgu0w1FcG/ntjEJYpIuDyhp5G3MHjccwsfJs63xxxDI81udNkvMNIHY2WH8QG7Dpu4AKRRCGqoAtJCzyLSul9WBmqfy5Ac2VXOpKQ8FJ27ku3IvP2x/5zGKZPQF2Fug0ogcikQgXAxnczEeEph3BVczmZPsr+P8bg2U8PQT2ICxvSn6iihjtX7HgN1i3x+QqSRI2/O9lDx9AkAKV6Cmg6ktWpnW2SZBungfUB7ffphQcfHzi9G59jCfezAyVux+cCG2hCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FgysnQO36Yco+21uIG2/m7sxQ+8Ebpz/MmGfCOUqjk4=;
 b=cREKYiD87IcAHfU2/SYX0XU9qrOmXCcticwee+NT0C5YJZXE3D68mjQvNYNgln45+S7/Sssc9KxsSv6PuWr5oqrhr/14vy+Bv1PI4mo7A3SrDw8S8942LcnwlyWHlZmzOhWl5B6/xCE6X+nh1s05WbvuW0VLBSoSan1xSY/D1RrMKD5I3Qx/zc5F4vWFRV4UAJ8k1402fnrHEP7rwyt4dHGMHcqjYd+OkAQ4A2st/NdSvD6qphAkC+G0MkVXE3dQqxkiughrx+YQhaN5nKn2X0Iz9jPDJy2Cii79KUkCubISOTu5hV8vA56RcACyIb2TDx8zAlbCbuBtJAb/zGg4ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgysnQO36Yco+21uIG2/m7sxQ+8Ebpz/MmGfCOUqjk4=;
 b=J7BBn3HA+5jGf9agy+bl0z27s5tmR3qCX8zkAP2AnBBcij7WhL92zVGyRiYqUfO6llLyGzdUOwyp5IuUtcaUYFCmRgHHM1StF8X66d8IQ8mAYSQ8/XbLJo+gtapJbCeHHht2jQKnoYV0HLerw5NNj8Nb79pTNgl1dxP4c4/ooCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH0PR12MB7932.namprd12.prod.outlook.com (2603:10b6:510:280::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Thu, 4 Dec
 2025 10:46:55 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9388.003; Thu, 4 Dec 2025
 10:46:53 +0000
Message-ID: <7b2017f4-02a3-482a-a173-bb16b895c0cb@amd.com>
Date: Thu, 4 Dec 2025 11:46:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 01/11] file: add callback for pre-mapping dmabuf
To: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org
Cc: Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <74d689540fa200fe37f1a930165357a92fe9e68c.1763725387.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN8PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:408:d4::26) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH0PR12MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: 66e8efdf-b9f6-4b55-a171-08de33226fa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTUrQVN2OGV2M0dyUjBKRklZSEJOcytlY2hzNmlLZXMxcXlKdDNEL3hyQ2hE?=
 =?utf-8?B?ZnhTU25oUER4NHlkL0l6bTFiS3pSeUM0RU1LRGRxRURxRDh2S20yZy9BUytX?=
 =?utf-8?B?Z0dvbEZ1N1hvaG9oc2ZHMlVQODl4YkhKVS9nUmdqMDRMQ1VFby9OMXhjTHc0?=
 =?utf-8?B?SGNrbzQ2WVVGdW03Rm9PZWljR3hSZVVYZHkyb1ZndDNtM2FFb0ErYm0rWTRy?=
 =?utf-8?B?YzZCbkxGM0F3YlRPUXRVZC9WR2tpTXo4Y1p0a1lKS1FwQUNqWEc0d3JabnVv?=
 =?utf-8?B?WTNZdkhtWmhNOHFjTS9Yd2JERSttTlBaUDNrTm1ZRmxSMitpWUNnWWV5MlhY?=
 =?utf-8?B?SERRbStxR3Buc0ZhQlhqZURsdG5PWFZJRytUTFovMzlvWnNXdzNCT1lIQ3o1?=
 =?utf-8?B?dEUrRUhodnJJMGN6bXd3Q2w3UWpxdzN4VFZkb21aVWtQT1lkcWlRZ3FrVXdS?=
 =?utf-8?B?RzB6ZmdibGZpenh6WUZva1RRbHBEd1dLbjB3SFlzaUN5ZWV3N2NQUVRjcGh3?=
 =?utf-8?B?b1J1VitqaytBdElzWmNRMzYrTGJWYUFsZDVnd1FlZ0Q2TkhCbjBXRzhMQU5Q?=
 =?utf-8?B?ak83TzVwbjF5alpETkZyaDdzanduc2FLTFZUdHNzbWU2QU1IanVEWVN5Tjc3?=
 =?utf-8?B?Vm52di9RMzdRd1JNN2VZQUZrdlJwdUs3RmJrRm5mdkJiMVRHWTUvWmRhSHZV?=
 =?utf-8?B?Uzl6Qkg3bk5tNU1jYTlTdjV6RWVZZmZxMEJiOXJzUmxHM04vRXRZNjdaYVVL?=
 =?utf-8?B?Z2xqNStBRWl1eENObkpURGxNZy8zbE9TdXowY2cyVWprWmcwRVFOYnFTRVBR?=
 =?utf-8?B?YnFsV29xUHh4TjBTM1k2YjdpdE1sZDJpaVJOekMyUEx4a1NMN3JvQlZ5aDN5?=
 =?utf-8?B?Y25UZWkyY1ZQcitaZWhqL1RTbVc0bGNGWnNEb2VKNjhJdWszcTZDQ3A2R2l4?=
 =?utf-8?B?MVArdGpiUStMQy9JN25nbDg3OHhUMFF0Y2dkSXRlWEsvVEVYQVpFSkVtSUdK?=
 =?utf-8?B?cXFIYStWL2FLeXI0OFUvaW5sTzQwWkFMaUszL3loVGpLS2lXeFlHOFF1TVpu?=
 =?utf-8?B?OHdndldmVVpWUEVNSkdyOU9qQ0NkQTRpNWJGaGErQVNrSDZpM1RzVHdBOHRY?=
 =?utf-8?B?VVJFT0RaM0JRYWZhazUrUXc2eXJSOHFCdmJyb1lud3dBMGxnMERURHhmLzY4?=
 =?utf-8?B?MWR0ek94RS9DUXhvNUx6TTFRTUhBN3BhSDR2SWNuaXViVGJQTVVzSE5ydnd2?=
 =?utf-8?B?VUpmSFJEeGxQd3Q5TFRuNnZQODlzRnYrMEpBT0lreTUrQURkWlowOVBVV09l?=
 =?utf-8?B?aU13d2ZhekNhQ2RtcFd2SEZ5OEpnN3ltWUJucVc4clExek02OGo1bjlocGVW?=
 =?utf-8?B?a091OE55MWF5YjB2U0MrTmhYaWUyTXhxQXNlckYveXBCWkFBYUxKeE9IT3Y3?=
 =?utf-8?B?cWNxc09YR01IaDFsenVyaVc3SFVFNW45SjZaYXZGeXRDRUMrSlFaV3RmYTZP?=
 =?utf-8?B?MFRlVnpOMi9QUlF3SmVJTm55czhuZ0Uwbm9IOEtXVlF6VCtLQ3kydVA1UXI0?=
 =?utf-8?B?RUtXNmExQXJ2TTg1S0hDbGsvK092NGh6b1BPbGdHcTRhYnFEZHZqelU3OVRU?=
 =?utf-8?B?eUJscHdzYzIyaTlqTmVvRUllbi8zNnA2WTVweG42c2xwNndDTmRPWG9PSFV2?=
 =?utf-8?B?dVZyb2JIS1lDWGwzT0F3bnJicHQzNXBmb1hwM09IRW9vc1BUaUtPVDBpcmtu?=
 =?utf-8?B?dHJiWmxIQ0tFVjBXQkdrbkt3QTBBRVNJL3BzdFlLMkhOVVBIUmZ0MW13V1k1?=
 =?utf-8?B?ZGJ6MW5teis5UitSWGd5aEVMWS8wakJ2QUtNb2FjOEw1VS95dDBuQm8zbzNO?=
 =?utf-8?B?V3FJb3RMRkphcUI4YnZvRnFTSm9iS1dveUt5VmdZbkYvWGRvUXNCUTZNc29J?=
 =?utf-8?Q?AjM45+wRRZvYTW9E649N6nKHkekHgWPs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RU03b1JDUEhtL3NrTFJ3SDl2RGRSZER1ZzF3eXZRWC9VSnNObTBHeXEyWEEv?=
 =?utf-8?B?SHRKNE9CSUFYTlpuNldUcGdnamIwRlBDa2RzU1l5bXA0Szh4MmxaNmd1eC81?=
 =?utf-8?B?Y0EwUE1BRitHbno4WXRlQXRWZithL1B0aGcxTVhlRDZaTzc1cStrcTc0YVRG?=
 =?utf-8?B?UHVZUHllYmdBdUxQUllZT2V6MmV2RXpCQ2s5MzdrMXVjY0tFY1ZRNmhqVW5z?=
 =?utf-8?B?R1ZHUnY4QnRJVFQwOEI4UGNQT3JIN0ZqcW9lUGlvT3BOVWRlVlpNMkRPZkNN?=
 =?utf-8?B?OXRwTDRqQytrY0VjT2tWZzZIL1hEbDB4UkxnRUZrZVNmUTIxTWxscWJuK091?=
 =?utf-8?B?NmE3b1VYT09wOXNVZ2lQdTdkdzlQOFVSWkZjWlN1bWRmRGxvMU5TYXFyczdI?=
 =?utf-8?B?QkJ3ZlVNNFlTK0RoNVhGQm55MFZvNzJqQmRrTmlFcDNZMGN2WVVpN1E2Z0pG?=
 =?utf-8?B?T09abTM1VUxvM1YzMnJpWDROUXYwd1VPNFdVQWRlbnoxK0VCUG1iMUJVYm9S?=
 =?utf-8?B?ZFpQaytoNXl5K3BkZ1Z2Y2JLU2Nnb2Fwcm0yQXJTaXNIZWRFdDdEWmVhT210?=
 =?utf-8?B?ZUxURE0xNDBVZVlPcmJiMkwrbUZKb2JTL3pYYkcvZks1TUZUZVplRkFjRFl5?=
 =?utf-8?B?MzlTNWh4a0ZRbzJRcy9GRjNuczFmN0pSemRnT2xWcUJoQ2NQR2dlV0pqM1gv?=
 =?utf-8?B?OGRJU21XK1JFV3JNVlJvUUxzT0htRCtUOXJmRnpCd2NCTk15UDNZY0YyUXpQ?=
 =?utf-8?B?VnNqWWZoNHFqV1Zrb3ZCMWVFd1EyZXlKQWdSSzF2RlJHVkI2RzNMR0JTS3ZC?=
 =?utf-8?B?dzIzS2V2VENBeDVzcUUvNHExY0xVQjZ1R3JhWUc3azF6eC9aQUl2KzI1ZkhO?=
 =?utf-8?B?SDZ5YTFNYm9FYVlaTjlQR0gxNUU2MCtXTklxQWQxNDRMOE9aSjJlNk9BSnMw?=
 =?utf-8?B?S211S3JpellBRUNKNHlaaWxTWkFWdVJ2NGpWYUhOUGZiYnZWU0JyUEcyTklw?=
 =?utf-8?B?SFl5VCtPODNtL3V2cFNvZHNtZEZFeVI2ajdzc1NYY0padExJZmUycndtUlhz?=
 =?utf-8?B?cW5KTFdqUGg2S3ZhbWY2ZWMvTEVIRE1XVWtUekR1RTRSY2RLdXdtbGxlVXdL?=
 =?utf-8?B?OCsyT0VKWG9lc3ZFOE0yUkFWQzMzZk9Wd0s0bXZJN3NxYTd1MzJNUENabmZn?=
 =?utf-8?B?M0x1QXFEaXl6TE5qY2pSeTFwcGJOTjVKM3UrY1FRVE00MGhEVVBTeXpjc3Rm?=
 =?utf-8?B?alk3WnhwdExlbkRobHpBRlB0SXdPR1p6N0RhWS9vZlFVSEtBbFBhR3dNcVN0?=
 =?utf-8?B?Y1BVMkRHS3dZYytWcENoT01rdlkvbmN3S1Zlc2F3UnJvcTczOCtIMmRXZjcr?=
 =?utf-8?B?K2w4bzFmN3AxTkxSZkw2bm84Wmc3bGpXZlFraVBjWEp2SDBDN211Qkkrckhi?=
 =?utf-8?B?UTd5ZEl6R1dGMy9OYjhJNFlhZ3J2TWJVeFJqcXVHZ1BMMFhmSEVPaVlYVyti?=
 =?utf-8?B?TUVpVVllME1rNnRtejBBRUxBMFkweEhEK3gzbUpVd1lVZlNWQzdIMTRETkNz?=
 =?utf-8?B?UXhUcjBxek0vSkVWYk5mNkNsZkQ2QXMrM1RSNEV1aS95clVmTG55VmxXUkox?=
 =?utf-8?B?Zk0rYWttWXAyU3lrY2hFK3BZL2FMYStLd2FZV1MzeHNCb2UrNk56YjR3QjND?=
 =?utf-8?B?VmM4RExYOVgzZXFWRXdwYlY5YWJGajQwbzhlNDBSRHdvRUgwd0did3dLMXBY?=
 =?utf-8?B?c21XdWN1TVJWV2N2dXhJeTNtRGdGV1cxc3FWTll6bnB6MlBQejlHZ3FNM1lB?=
 =?utf-8?B?NWtDeS9nT0xNKzhpcC9ZZVlIbDduNXVuQ0pIbEhwR1JkNVJrc3JkM2lFbklF?=
 =?utf-8?B?RVRvQnJXdWtRVklKUG5wcnJaaCswMVNWa2g4c1JTYTA2ejYrUDJFTzlrTFUx?=
 =?utf-8?B?RlRVU2VIdU5uaDhlTGdrSWlVWFBMWUV2M2FUMFVtTGZFVmlFQUxtUDBOZllD?=
 =?utf-8?B?WENIamhQY25MTjh3Y0RTUDk3cWRaNjdWNlE5NEw5ekJEOHJDZGkxaWRaSFg1?=
 =?utf-8?B?OExKaXJ5aHJJT2VlbE1uNm9YaFhHTXQrMlZvQ3I0WXFLaEZmMmxqcmhvVVp5?=
 =?utf-8?Q?D6184ZDb2R73urqsetk2rpdRR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e8efdf-b9f6-4b55-a171-08de33226fa8
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 10:46:52.9536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUdCoxtQ08XCl1aP9NCvYlKXkFrbfHH636gNyQ6ZfFiaNKihVioMB0OAY8hRqdJV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7932

On 11/23/25 23:51, Pavel Begunkov wrote:
> Add a file callback that maps a dmabuf for the given file and returns
> an opaque token of type struct dma_token representing the mapping.

I'm really scratching my head what you mean with that?

And why the heck would we need to pass a DMA-buf to a struct file?

Regards,
Christian.


> The
> implementation details are hidden from the caller, and the implementors
> are normally expected to extend the structure.
> 
> The callback callers will be able to pass the token with an IO request,
> which implemented in following patches as a new iterator type. The user
> should release the token once it's not needed by calling the provided
> release callback via appropriate helpers.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/dma_token.h | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/fs.h        |  4 ++++
>  2 files changed, 39 insertions(+)
>  create mode 100644 include/linux/dma_token.h
> 
> diff --git a/include/linux/dma_token.h b/include/linux/dma_token.h
> new file mode 100644
> index 000000000000..9194b34282c2
> --- /dev/null
> +++ b/include/linux/dma_token.h
> @@ -0,0 +1,35 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_DMA_TOKEN_H
> +#define _LINUX_DMA_TOKEN_H
> +
> +#include <linux/dma-buf.h>
> +
> +struct dma_token_params {
> +	struct dma_buf			*dmabuf;
> +	enum dma_data_direction		dir;
> +};
> +
> +struct dma_token {
> +	void (*release)(struct dma_token *);
> +};
> +
> +static inline void dma_token_release(struct dma_token *token)
> +{
> +	token->release(token);
> +}
> +
> +static inline struct dma_token *
> +dma_token_create(struct file *file, struct dma_token_params *params)
> +{
> +	struct dma_token *res;
> +
> +	if (!file->f_op->dma_map)
> +		return ERR_PTR(-EOPNOTSUPP);
> +	res = file->f_op->dma_map(file, params);
> +
> +	WARN_ON_ONCE(!IS_ERR(res) && !res->release);
> +
> +	return res;
> +}
> +
> +#endif
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c895146c1444..0ce9a53fabec 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2262,6 +2262,8 @@ struct dir_context {
>  struct iov_iter;
>  struct io_uring_cmd;
>  struct offset_ctx;
> +struct dma_token;
> +struct dma_token_params;
>  
>  typedef unsigned int __bitwise fop_flags_t;
>  
> @@ -2309,6 +2311,8 @@ struct file_operations {
>  	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
>  				unsigned int poll_flags);
>  	int (*mmap_prepare)(struct vm_area_desc *);
> +	struct dma_token *(*dma_map)(struct file *,
> +				     struct dma_token_params *);
>  } __randomize_layout;
>  
>  /* Supports async buffered reads */


