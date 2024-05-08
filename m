Return-Path: <io-uring+bounces-1821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2EA88BF7DF
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 09:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A3142833C0
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 07:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D113AC10;
	Wed,  8 May 2024 07:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LZgDq/y/"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E74F1755A;
	Wed,  8 May 2024 07:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715155179; cv=fail; b=FysHw4cdKHgFBVNzDSyp5aqFMxTeyC3mLLB398Gt8QKNnHFuJ0sbIjt1xv+fTpxTLDLA+pAXSOJ4zjc7ctSTXqxsMlR4JNEGcGNiSnDUJk0pc9Aht6m3FEprer/zuKCYMyePpstQplia53UFNIaoUxocHi4ErmiIgjnkmSNlHOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715155179; c=relaxed/simple;
	bh=AXdgSRF2K+o2216NHlc7e8dUMrJEgQlsycS+xV6w/64=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ErU7lwUKQPxGFAtViKoZw7sH4qGs3wCOvqT5bJzBvIfkIIXkOuQH6saqSSmwQV8M3shH8UaGz+8QllrcWQEI5Ng8X3jixO0zWaeTCNhVzg8jKKTCf0dvG9SBI8mYV8DxO1eWH+R1pxcks0iCqUXvEuip+SQJaVqnLYJxBZ5B/yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LZgDq/y/; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZfJFgcZJ2h6chrV4TdVOUs3VkAN4jGCmN3J9eI6bdE+pb3E+v5AsS5sNzLcJkomiPVwPypnbt7LYEn3Ix9qrYoMjdvjPUH6VS8R9aoGN9GuKTohq112YIxysaQdbPK3HCzWgh7ahsMnqzmIIxiZI4v7yKz3hSzcFze+Qlu1kq30Sv1X+33rHuyDiqvP6moir+pMUa0KcotHKksoomqeHTXKXkajHvBcdoqy2eYrrTZ9bY52KFpGvXJpVIYTeuen+k8DNQT8OaqAUbxJXxOsvY9zAN1EHSODcH9BqyrQgKbnLzlKRyF10XXTh2jojguCLxeoeJBuoKqk+2fi8vl7hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COg2CIfxRuDWjHNCwTSk7LYGNIvP+L37qxDtElZrmwQ=;
 b=Cbw+d4uRGtocfaqfUUJppwqiLSwbDwvnK+P7L5lA6NuVLvP0O40HOa9cX8O8VtoHZLP8JltR/3nRLgf4h29FRIDddsNh8rF5gxvFqtQDiv9864i9fpt4GVc9qjzeyUmP2TBnJcWMAKHIBVoMNBBqPha1lM96UwAb+dfACFc0JH1HgTX2ir4C6PagGK0B+DlCJ2TeE9gwmjXZryP5lCrV/hsT3s1PBOW8RTUVArLcB87ULuF6YpZ+eUMoSWatl0ft/oFHAgFwluVLQc8UpkiZ5ZofaNtzZxHWEhLUfjspmJ6fpxxvxO4eQ7kvkdxnLz/eo4GkzMWT3ukjGI7/OQ4D0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COg2CIfxRuDWjHNCwTSk7LYGNIvP+L37qxDtElZrmwQ=;
 b=LZgDq/y/cXOyY+RBTD8Bl+xOZhKJlQE5s8yQjSF/TZ3bqdAHqlZ6c0LBfeXF+6R2rRfae+l+dhBHwkXN/6amG2Y2WCz0osl3VTzpwSgYR0sEA/yuJK2s3+qtrcvt1oQcFt5xYe2DN1UOKfP8bCOo33cnVCq90sjZotlVdIfA/ho=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA1PR12MB7246.namprd12.prod.outlook.com (2603:10b6:806:2bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Wed, 8 May
 2024 07:59:35 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%2]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 07:59:35 +0000
Message-ID: <e1a2d134-83a4-4833-939b-a53fe31553a4@amd.com>
Date: Wed, 8 May 2024 09:59:26 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better about
 file lifetimes
To: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel.daenzer@mailbox.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 keescook@chromium.org, axboe@kernel.dk, dri-devel@lists.freedesktop.org,
 io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name,
 linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 minhquangbui99@gmail.com, sumit.semwal@linaro.org,
 syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
 <ZjoKX4nmrRdevyxm@phenom.ffwll.local>
 <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com>
 <d68417df-1493-421a-8558-879abe36d6fa@gmail.com>
 <36169520-56e4-4a01-a467-051a94c7f810@mailbox.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <36169520-56e4-4a01-a467-051a94c7f810@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::18) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA1PR12MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a89be3-7906-4ab7-e658-08dc6f34cd03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDlGQTlra0tGRFFGcStQOUk1SS9odDFuOTR5aU1GWkdUNjhkajRLa2o3V0V1?=
 =?utf-8?B?VWxaK2JXckdiaGQzaXNtTEUxKzh3YXVRc2c0THNOcDVnY0pIdHZVNklXa3FN?=
 =?utf-8?B?SU9ocWFBaWo5eDBEK2VQU0t3RGc3YmY0ZmowTnFBZmhLZC9ydmFvQWZZanVH?=
 =?utf-8?B?bkRZb2dYcVhTdUFvMzBGV0t3K1I0VHpYL1lUUGFQVU9tSTJJbUJFYnd1d2x6?=
 =?utf-8?B?Z1hqQmlzR3gyckZmVnEvU1k1anlRa2ZYV3NwbGFGdElSTGV2UXlqOW80YWkw?=
 =?utf-8?B?b0EyRnArMytaNTJVMWpsV0FpMk1WL1cyTHlnWWlLdVFQelVLYkY1RWZJcXhL?=
 =?utf-8?B?MVNXdkRoRWtzc2JGQlJmeHhuYk5uQzZWRWZnSHRGd2JGRkpVWDh4cVhTVTFO?=
 =?utf-8?B?OEhNSm5mL2t2RmNFN1Z1eVBKeC91UnV2N05Ra2RFOThSUC9xN1RhWUkrSlNr?=
 =?utf-8?B?UmkxbnM4SzludU5HUkRSRTFOL3ppZUt5aWhUUWZEK3BEV25YU2dnY0QwVlpD?=
 =?utf-8?B?NVU2WE5jaVMvWkdETTlqMjlCZEJwNnZyeXArRzYzNzNXRjZ1MFBKVHdKUldq?=
 =?utf-8?B?YXcreGFBU3NjWEszOUlJUGFQLzUrWUVnNjF2d3RyWTZ6Ny9ocUEvSUpDc1dV?=
 =?utf-8?B?bDF0a0xFZkd4SS9VQU9iU1crc0VMb2ZMQ0tpMkFzcDM1bEN6ZFB3cDJBaTlT?=
 =?utf-8?B?aDJBaDBIR1BNVnRGYUFWWmw2RkRNZ3ozakNvSUtUSGdMUzhkYlZUQWRqVk1j?=
 =?utf-8?B?K2tzT05uZmNnU0kyVy9ZaHFYci9WN25oOGwrQUhOSGVuZEFrS1BzaFRqcXpQ?=
 =?utf-8?B?YXVxbXNrdGJkaHh6ZVY1aFBnZzRKaGlHRVU4QTdHTGEwc2YvQmpmSXFDbDlW?=
 =?utf-8?B?c21Uck9TL1BOdU82NlBSWnFlNUU0SWloQVFDVjdNbVRERUY5Ui9EbU5kVmh2?=
 =?utf-8?B?TC96Um9ndzdKMGU4VEIvdWJyNVVBdVNIQUpZaERZdEVXaVNqVDJTTjVCYXVV?=
 =?utf-8?B?YnNXK1F5dGdpQW5qWjFSaFpncjZ5RUc2a1R3akVUTDVxd1Z1ekhJTWl6Lyt6?=
 =?utf-8?B?bi9sOGN2enVKQW0vWGVwc21BdnJkN0dzQ3c0MlFnZFRFMVQ4QnY5a2lmZ2tP?=
 =?utf-8?B?eDZneTg0MlNvTEJxbWsrazIwKzJyck9wVlp4czBtSFJldytydVdsTytTenJ2?=
 =?utf-8?B?enNZSE5ieUUrMzhXeWpFSitiSTduK29JM0lVV3VZMjdGTW9HWXVZWWRlYWl3?=
 =?utf-8?B?VVFhK0JSSkxJUWVqc3YyRzFJUnpnaHM4c1hsdUxTQUNzcUtYMHVZZzI2M3dC?=
 =?utf-8?B?SlA5YThkWG5GTm9LVndEVElkZEw3M2hYdTFJWkVuWW1sNFk4UWV1QnorMUtU?=
 =?utf-8?B?ajRuRHlQWW11VkExd3k4cWVGTmh1SHZPMS96Wmw1YWJ5ekpEVUx4bjNYUy94?=
 =?utf-8?B?VDRXbGl0NWEzbDd0eXhDZ0hudDRFL2FzZmQ2MEdqZXR4aGIrM1M2c05OQ1BH?=
 =?utf-8?B?cHk4TUcyeE42WUNyRys4RERoWC9oaEMrdkt0QmdqRkgyUERRV1RPUEJ0a0ps?=
 =?utf-8?B?SHBFc1NicWNsK1ZhQXpYcU8yb2JoVHJLZVVtK2puT2hXWFgvRUM0blduVnl6?=
 =?utf-8?B?eWJTc3RwSEtLcE00VjZ0V3NvMmxNWFVQRGtIUFVzRDQ1TFE0VC9nb1hmbDBx?=
 =?utf-8?B?bkJWcDZCb2JwK0tqN1hWcGo1eUJaS2tOdzBONURPcGdrWjkwRUlQLzZvY1Qv?=
 =?utf-8?Q?dcBb6MJCI78iFv8D0lF/Ma1+G9Qrf+SZP8PAWj9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWpKS21QOUExMXZ4RmtDcW9QZkx4MHRMRmlKTmNGRU5hRWdRSkJjVEpoRVBF?=
 =?utf-8?B?Q25PWDFwR256ZmZrK3h4ZjV5R2cwbE5lS0xHSnBlNDI0L1FGbGxXeHYxR05T?=
 =?utf-8?B?TGY4SFBsQmJYVXBNR1lIZFgvQzRZQmpIUzJucXdhWjkyRi8ydVQ3TE1CSDVE?=
 =?utf-8?B?Mk1yNE1MRlBXRmtSN0NNVVNlMmpzc052OWk1ZDhhVnlIYjBDNHQybE5mZkg5?=
 =?utf-8?B?anY2ZE9qT2pRR0JhWFc5Z2x0QUpYc2NvdkhQUDJ3dHlNcDdqZzNpV3JGM09u?=
 =?utf-8?B?ZkUxWkZQLzNybWRRN0hWb05jYW1Rd2hYVU1VRDhxSS95dnBweUxMWFRjTmM1?=
 =?utf-8?B?UDZ5WlRGNVlUSkRWa2FTSzRGZGdlbjhKZVQ5dTRWdU03Z01yK25hQzc3VXVu?=
 =?utf-8?B?dVJCcklScjVZUHpwMEFaVVhTVjBmdlVGVlVaTDJUbVpwb1VnL2VaVlg2N3cv?=
 =?utf-8?B?Y3UyTWFZbDhlUzhUSS90VURNSHNBZmlHVVpZMVlYS3JHWVROc0tLNHBOSWor?=
 =?utf-8?B?aCtKYnFZVjB0c2FOSXd5dkE1akh0NHZzRVovMkVWc2dqQmNDODRYbnB2REJJ?=
 =?utf-8?B?ZUtmMTFKdVk1QjVQK1Bsdk1YMVlCdEtaMXNnamNMWW5LR3R3cDFOTmsxcWZN?=
 =?utf-8?B?SUs1VWhiU0ZCS255T01WTDUyMUU5OVVBR1RqcTFXbEw3YzBhdjlZK1lpUDJZ?=
 =?utf-8?B?eFFlY0EvOEtXT1RJT0QvTFdweGxnVXVYQWwxQ21PN2Zhb2J0a1oyZnlXL0NG?=
 =?utf-8?B?RXdKdXFsSkRvQWhQZWt0ckpZbVFJYWRnTk1rb1FnUUtRZWhncy8vMEFxN1Rq?=
 =?utf-8?B?YlRQVWIrZzRENUpjS3l5aWwxQlAyaE1HNkE2VUk3bVEyY2IybDFWYXF6aC84?=
 =?utf-8?B?K1pHQkw2TUlnWThjVThLRTgvdnpadXdvUlA2cmxEb241R0JWZjlTR2FKSHhs?=
 =?utf-8?B?bHFidTM3SUljQXprTnlSZ0I4SmhaUmYzcDgwMDVobkZqd0JGVHpRN1dWRTND?=
 =?utf-8?B?UUxtcFFtRUVGQ3RyMUtPZnVJaUdyR2ZGT0czTTJMeFIrMHRWMjlYajBwcUgr?=
 =?utf-8?B?SjlNQUlMOC90aER2YldYeFo2M0U0ZFQra1hnekE3aVYrZjU4ZjRaUFJaZVF5?=
 =?utf-8?B?UkRKT21XbWd5dllXNkdaZXVVMjhOTm1pTnJ4R1hnd1k4KzFrTGIrUi9INUc2?=
 =?utf-8?B?dk0xVG82YTNhKzdseHFCU3FLWWVCZGZOWmEwSEJmbTl1L0FFVUhacTFqMllL?=
 =?utf-8?B?elFNeTFSVjlORWRwcXBOYW40QTQzYTQ0M1ZuNW5NOHNKRGxhUjlGanpJR1Bj?=
 =?utf-8?B?MUdOeHlLWXdvbXdjZlNjRjkvVUh0SmRHbGxMdUZWT2pQeVhGTncwSXhWcGVH?=
 =?utf-8?B?aytqanBFY200UWdMcmR3dFY3aUdWb0w2Nk0rUXlNcGhqUExXSG5KVlJPSmdM?=
 =?utf-8?B?ZzFSK3RPRlB6M0JpQjBzK1pHQ2k4aS9mSWZETEFjL2Q5UFhWM05lSmlwcHhx?=
 =?utf-8?B?dkJ2Uk9hNjNmKzdHYk8vcGRoNFVtUnBMZXc3NSsraVZONWRpRE1aWkxCcnYy?=
 =?utf-8?B?OVdtN296U1Q3VWdJdjQxY0FHN3ZkbnQ1Z1J1YTdxamQ0dndpT2d2UDM5Wk5N?=
 =?utf-8?B?eEpCc2I0YThhV3dCNzFLdGg0SzZwSnJPWi8vZ1lrc1piMVdQM1FuWElEV0pS?=
 =?utf-8?B?WStTb2RLZ3pGV3F0VDRTRTRQOWhmNGFxRlNOdlhYU2tsc01OYkJoNkRNR3V3?=
 =?utf-8?B?TUhzaWM1dUdVUW53WG96eVRhbFBzWktxd1REYnJHYlpVenMrLzJLT3pvNEh3?=
 =?utf-8?B?ZVlpRk01bnprT2ZkdE5sMzhVb2kzMSt2S0VXK24zcmV4VWFoNjhxSUtLcTQ5?=
 =?utf-8?B?cjhiV2ZYYzhDcjJ2QVBYY1BLRDY4RUpxN1dQOFpLZW0xTklhaTlNRFRXMnkz?=
 =?utf-8?B?YlFEMFAvVS9WNzZnVVFHTUsyQXVENlVpbkhKMzFoT3haVk1jOSsvbnBaUlhE?=
 =?utf-8?B?RUN2NitjMCtZVkFKTjJORndFakNkZDRyTEc1UXhnVkYyMUpHcDNNUnoyMkxs?=
 =?utf-8?B?cWpJQlY4VE53cW4vZUR3WUVPd2VYQVlxYTlkZGdwbmZaY3lQYWxOTkFjNllZ?=
 =?utf-8?Q?tTIfINL8Vh0FFiHTeED4YpY/9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a89be3-7906-4ab7-e658-08dc6f34cd03
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 07:59:34.9351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2gA26jfFrKEbRnELoY7OU3eW49vSLlb3fas4WRrOLNK8kdDeTbXPAzZyuaDLH8t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7246

Am 08.05.24 um 09:51 schrieb Michel Dänzer:
> On 2024-05-07 19:45, Christian König wrote:
>> Am 07.05.24 um 18:46 schrieb Linus Torvalds:
>>> Just what are the requirements for the GPU stack? Is one of the file
>>> descriptors "trusted", IOW, you know what kind it is?
>>>
>>> Because dammit, it's *so* easy to do. You could just add a core DRM
>>> ioctl for it. Literally just
>>>
>>>           struct fd f1 = fdget(fd1);
>>>           struct fd f2 = fdget(fd2);
>>>           int same;
>>>
>>>           same = f1.file && f1.file == f2.file;
>>>           fdput(fd1);
>>>           fdput(fd2);
>>>           return same;
>>>
>>> where the only question is if you also woudl want to deal with O_PATH
>>> fd's, in which case the "fdget()" would be "fdget_raw()".
>>>
>>> Honestly, adding some DRM ioctl for this sounds hacky, but it sounds
>>> less hacky than relying on EPOLL or KCMP.
>>>
>>> I'd be perfectly ok with adding a generic "FISAME" VFS level ioctl
>>> too, if this is possibly a more common thing. and not just DRM wants
>>> it.
>>>
>>> Would something like that work for you?
>> Well the generic approach yes, the DRM specific one maybe. IIRC we need to be able to compare both DRM as well as DMA-buf file descriptors.
>>
>> The basic problem userspace tries to solve is that drivers might get the same fd through two different code paths.
>>
>> For example application using OpenGL/Vulkan for rendering and VA-API for video decoding/encoding at the same time.
>>
>> Both APIs get a fd which identifies the device to use. It can be the same, but it doesn't have to.
>>
>> If it's the same device driver connection (or in kernel speak underlying struct file) then you can optimize away importing and exporting of buffers for example.
> It's not just about optimization. Mesa needs to know this for correct tracking of GEM handles. If it guesses incorrectly, there can be misbehaviour.

Oh, yeah good point as well.

I think we can say in general that if two userspace driver libraries 
would mess with the state of an fd at the same time without knowing of 
each other bad things would happen.

Regards,
Christian.

