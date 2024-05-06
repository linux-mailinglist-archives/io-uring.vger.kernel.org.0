Return-Path: <io-uring+bounces-1781-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2698BD23D
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 18:15:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD0C91C2191B
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE77D156231;
	Mon,  6 May 2024 16:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fdHtJo46"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25193155A55;
	Mon,  6 May 2024 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012120; cv=fail; b=nJcGwRaNkkgoh4AlW5i2CaQH2l/uXc50QzI7BOlb2ESOPUz+l2NTd0ePzVZuBGhfmijvxSIprLfrF3A204SUFLSe/7Is/k2LBHR+UqYc9mTYvHMVsEw940+5muMwCwbgh0DZxuPlvPUOFqwhOPSLLjQ+0RE99qJJuFV7sbQFWxY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012120; c=relaxed/simple;
	bh=3JeB8zAMbq+DAz6SvJ2NM+OYeEqIMU37x8+TARkL4zc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sR5LYdmZH/4mSWSSwDUeUAunuhf9Wtj+uotrPf3XxGP3pvBQ+y7HjvyJ8y1VmjDgNLNltyqg51kFdH+UYc3jDdgEWyhYOanfmRU+/nD2YORABlWgOZN6sKdCHaYcM33W9k4XVrAMuseo0YgcbpopqaYuWGHNdADs96fr41gJ1KY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fdHtJo46; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FLzUyR/D1ci5jW6AP1HVxKESe+S/GtBgE9RCT40wcpZwvpboE2niSOTw7TPcIMT7GMh4D9OplowVW7is+FHKwiepEQvwBGBKgN5aHRg88TsKbAINRBod/Q1dB9dgDcdmsfNAB4o/Q/zxoQgS+l8q9SVSkwblxrHPl4qbvSSi4T70AU5PPFmkQNndFrsXuhLQfjnwVX7f6rCx3LvT+w8dZdDct4xNa/tMbBoHP7NZLq7J6Pk1U7c6h47/wqLF6d/3n7aJEXzccfFUBmZpDP7b6BopBfl3z6CnatpOsehI+qX0K2VWMbDeyix/MSn5jM+mpXV1a6rO+nvK3dM3dSj1gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uPVCIsIKlaPDUPk3tbzPoGIbdTj1+HQArdbPvEOfKgk=;
 b=mJQr5KWtWH9a/KoygRaxHjyVVIf8W6W5LMpeYqdfWid0y9Sia5nqJepWdCJCTsVgX+NgpuioVraDHO58PaHe0i0WGEopmpYynaBtysB/Ci4RbiyQjBZhqbwp78Q7AA01oTSbNMRo22wzpO14Lnks6YgWXMwQgAcmLxCI0+pp07q/NR2m4sHBnUWmsXeIKz+EYjMYEdklBIEFY8gr+1ufGJXeRYuLlQ4gZi5pOGLzGKGH5jj+CShpKq4sFiMNBBzOxal5CCvzaLD+1RcdY+Fs3e95WolYS4lvly/cjMkh0EFdv0t91vpt80yZ9PE8UwoU1jrU1CRPqL8TcBHGpbRY2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPVCIsIKlaPDUPk3tbzPoGIbdTj1+HQArdbPvEOfKgk=;
 b=fdHtJo46xfuVZrNXTBnYL6bfBE56uO4JQKNQ0ybLfwulwbEWhGV9wec5aizSvTRcgOdXGusF+kDL4fyhIkY6Rh8Blpf/sxN00rNKDIvmeZyrh6pgci2guUSuGS2mPNICx5wb72tTi9ibGNwN2EQRNMaTFTrsS9oCvnrumf2xx2o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DS7PR12MB8232.namprd12.prod.outlook.com (2603:10b6:8:e3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Mon, 6 May
 2024 16:15:14 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%2]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 16:15:14 +0000
Message-ID: <10359d2c-7496-4470-8aaa-11154c73a7bd@amd.com>
Date: Mon, 6 May 2024 18:15:06 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>, keescook@chromium.org,
 axboe@kernel.dk, dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
 jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, minhquangbui99@gmail.com,
 sumit.semwal@linaro.org,
 syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
 <CAHk-=whrSSNYVzTHNFDNGag_xcKuv=RaQUX8+n29kkic39DRuQ@mail.gmail.com>
 <20240505194603.GH2118490@ZenIV>
 <CAHk-=wipanX2KYbWvO5=5Zv9O3r8kA-tqBid0g3mLTCt_wt8OA@mail.gmail.com>
 <20240505203052.GJ2118490@ZenIV>
 <CAHk-=whFg8-WyMbVUGW5c0baurGzqmRtzFLoU-gxtRXq2nVZ+w@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CAHk-=whFg8-WyMbVUGW5c0baurGzqmRtzFLoU-gxtRXq2nVZ+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0197.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::7) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DS7PR12MB8232:EE_
X-MS-Office365-Filtering-Correlation-Id: e879e8a9-9e46-4d35-4956-08dc6de7b630
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dGxsOThkMGl1TW5KT2dsTUx2VWh3WFVOQ1lnN2FHWThQMmxOUGQ2UlVnY1B4?=
 =?utf-8?B?T3FIYkdxOVVNTU5VZ1FWYTZESkQ2dGFybkYwREE0ZnFDWUFVVWFBZ1FpU1lu?=
 =?utf-8?B?ZHJvYzFncXI5UkZJeDlTOFlmMWh3bG8xNWQvSSt1ZWNadWZkVHVuZG01Z3FC?=
 =?utf-8?B?Skwra1hva3BvNjlMTmEvL05LVHgrZnR0VHlsc2VyZkNobklEczFvb2RoNGZV?=
 =?utf-8?B?ak8xOFJGdDMvdUpnRmRYYmJlTTluV2NmM2UvZktCOU9LR0E5MHFYUzluZDBN?=
 =?utf-8?B?emNxM3cvbDJGcXBMVDJWWGcxV3JDbytLeUxOdmd4cFdGb21lZVhNaFBrTXV4?=
 =?utf-8?B?c1B1c0I4OW1VbkU4WTVjd1N1OHdUWEc3ckU5VFJYRE9KLzk1TFpmYUtsYkUw?=
 =?utf-8?B?cnBnS1BMSGtpTlFXbDQ4TXVscmlLQW1vWDRxRWFKcjBwaHRybVhOdmJzR2tx?=
 =?utf-8?B?cmNCVVNsTTdoS2hwakp5NnlLT2hpeUlYbkRUK2IySGJybzRzVzNoM2NydGNU?=
 =?utf-8?B?aC9rSHdGSU82QmFJekVWdjFIWXdka2M0eDE3WjU3RWRoSHJpWXNlNXFJZWMw?=
 =?utf-8?B?U2pWUkpRbURGd0xEenFHSzdpVzR6YkVWK2pPVEgyUm14RUpOZ1dSbkN3YytV?=
 =?utf-8?B?cGxIT0xXNVNtd3EyTGhoM1lOT2RzWFZUakQ1czBWSWFlUTJ3TTNGa0ZpRWxX?=
 =?utf-8?B?YnFVYzlQTzJEaG5YMXZNcW1JMy9xTVdmZ2hXWU5ZWUdzOVRLWlppbDFhNHVT?=
 =?utf-8?B?QTdDaWtIU0RHTFN2UmlhcHM3Wk1tZUdYczFlWE9PeENlcUhXMGlCY0VWYzhQ?=
 =?utf-8?B?ekx3V2ZxKzhRVmJtVFBlNmJlQW5hdGpVR3g2ZENmNkhMME0xTS9WQXpHa0JQ?=
 =?utf-8?B?Kyt3c01NTWN0WlVnT0piNnV0OWx6bk02TG5FZHZid0VsS3d3Y1h1UVAzQVNa?=
 =?utf-8?B?bU43NFBGbEt5V2tFOXFTTEpqcTE1a1RZVFZtYW96SFZjd3ZmaW41b0ZSeDZX?=
 =?utf-8?B?T3FhSTdjRnZxRkJyMmpOMGFYR0ZjaDlndTEvbVpYREZaNUhRdXk2bG52Ympx?=
 =?utf-8?B?bmhldDBoNEpVZllVT0tXT3FkWTEzTGtoVDFLVG1GNEpnK2REVDViR2lmeUdI?=
 =?utf-8?B?am9GbmJqZEY3RXpXUDdiUGRVY0Jta0k3QUswVjdQV1VYWFdleFlnUHY4R25I?=
 =?utf-8?B?bDlIZzRYOUI0cmxkdFlFdmRwaXdqYWdETkY5WnQwNjFMdEhsdE8vYWNVUkNL?=
 =?utf-8?B?YTVBek1IOGZXblJYSmNtQmVQRmplRWlYM3I2bzIxN29ubEJrSmc3TTd3aCtH?=
 =?utf-8?B?ZjFzTGlIajdPd3dYVkxxWE5va0Y1aVdHY0dBNVhaZ3o0Z3NHV2FYbXJzS0o4?=
 =?utf-8?B?blhSTEptZ2lXK3BGN1Zsd0EreHFzWDU0THBkK3Q4Q1E2RUIzeExYaFhHMzl5?=
 =?utf-8?B?VHZtNW5uTlJENnhxWkZNSmxUendrc1N1b2ZTckExR2ZmbnE5NDRNcnk5ZmJG?=
 =?utf-8?B?Qjh3TnhmaXZGNE9UR0c4Ri9EeVhtOGM3KzJXWkF0YnhBNkNtd1hGV2U3YUNv?=
 =?utf-8?B?ZVNWNnkrczBpakxSRjFQNVZ0WUU4T29IYWVqNHh1dlZ1cE82RDNvWGV2QWsv?=
 =?utf-8?B?d2Z5aVQ5MzM1SGdRdFJGUkxhaEt5VFAzL1VRNDZTSWZsOUtvbTJTVW5IZWpO?=
 =?utf-8?B?a1BFWGV5ZEgybSs1MlplZ2RCZGN6N3JrcjJoK1JzMTFUSnFDc1VuNXRnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M09SZ2RFWVN1UFNNNTl2aG1qWGZHTXVuNlBhSm8vdm1ZcklNckdhUTFrNGtu?=
 =?utf-8?B?bldOdERzVzFOWUlmQUJRQXE3aVpNSmFhcmtMYXZiU24rYVRtR0ZRU3hmRmhr?=
 =?utf-8?B?c1N0QXlsQ1NYaHlMWDZJbC9MWlBJb0Z0TkRnNjVUcXBJbFRjNGowbzRpbC9J?=
 =?utf-8?B?RXhEem05NWJ2SHM5dXJzeGovZjh6K3dFOWpySGVNUy81SGFsZWdsV1drUlEv?=
 =?utf-8?B?Y2hLcG1ZaysyN2tBSDJScEl3bEJKZHhEQ2c2VWpteEJIM0k0NmJmSktCMVk0?=
 =?utf-8?B?bnBRRFZKNlgrVXpvNFYyZVpnLytNdDh1VGVOMjNWaU9kVHlBQ3FIaERHalR3?=
 =?utf-8?B?aUxkVjIvQVhwN2Q3QzZjek1WSTBOSTVKRm1aOUNvTHgwOXNoaDZnbUFsNHlU?=
 =?utf-8?B?Q2lDakxCdzZEMEc1MWJSM295NThFc1ZoalBsVHFRdmpEa2VUVVBvKzI0Y0JZ?=
 =?utf-8?B?TGd1dDdvZERZWWMrdjVOakltY3hTK0k4TElTcFFsd2crcmpTeC9pOG05T0tW?=
 =?utf-8?B?WU5idmYraW5rd0U0cG9OcSsvV0FMUTIydjBOdHUxVHB1aVVxZERuOWdPeVhD?=
 =?utf-8?B?czJ0RThoMEZja1BkRXlXaCtPRkZKcmlwcmVVWjlaMHIvTFlIVzFYYnV4YWND?=
 =?utf-8?B?VGZzbmJtejcwSy82bml3Y3FhYVEyQ0tJNXZXM0kySktNRTZSdFYyTmo4VmJx?=
 =?utf-8?B?QUxPcUZJaVdmaFgyRkswVDM2SkNHS3B5S2RNUU0rZTB4Z21lbll3dEwxTGJx?=
 =?utf-8?B?YUgxc1dHY1g4K2JyeEwvNDFSb3RZeHZzV0RIZFNYTTR1bk12NTB5TVdEcTBG?=
 =?utf-8?B?ajRrN2JXQ0lmaVpneWpReEw2YmU3aEloMzlRanR5M2VMWU9MZkhkNXZkcDVp?=
 =?utf-8?B?MWM0YTZucTJTM2NCLzRveG5ZMGlYb1hWaFROdVh3dVArb2lzR2FQVHNnYUpJ?=
 =?utf-8?B?VlpHa09sOEU4WndMTUx1RUVMOFU0S1VBYkNwZkJwNytLbFdqRGtaTXFTZmNt?=
 =?utf-8?B?ZXBFZ0tmQVZZSWhSRUZmUGROeDZQUWlTNHZ0VW5mbnlyYUJGMUV6OUs0bklk?=
 =?utf-8?B?cTNEdjFrTnByYi9rRmVxbUdTL2wyZDZ6Rjg1M0hqUkNnbGZaWkRaVXByaTJQ?=
 =?utf-8?B?dEo3VFpLTFVRRTVUeTlVdy9kWlg3a0V1a09YQy9vRms5eEZldmhTdzhId2JC?=
 =?utf-8?B?RTR5L29wdStXSTEwOERBQzdMWnFMdldDSHI4SlFqY0UzWWt2QlRsMGZHSDdo?=
 =?utf-8?B?enVSblJNY1Y0cUlRd25oR2Y2MVdzODB2bEdOM0JjUHRBMFNIUjdnKzdQTk9z?=
 =?utf-8?B?QTd3ZU1kUGxmejJuTE1zOTdSL2lJR3ZrVkQ2YVlPSHB4c0tGbWF4NVNmc05J?=
 =?utf-8?B?YXVIQ3hJUzhBaWpVS29haytRYVovWm0rVDAzMjAwbUN1ZS8zUVEyYjl1TGNY?=
 =?utf-8?B?Z2V1SDVxRTR5SWdDWTRFc1hzQmluUE53bTNvSlFGS1R2R0xRTmRNQk9oSzNl?=
 =?utf-8?B?ek9wMmVLWmpBb2pQdnRUUXJBVWNFTHlUdStLS1pmT0xtR3FUOUhtVmplUThv?=
 =?utf-8?B?Z1ExZU9RZDUrWHRjWCtBWlE4YVJPVFlzSnVjeSttdkVHOVhBekVPdXJyM3B2?=
 =?utf-8?B?SW1kMmNiT0dWVkFuNC8wMW5ZMzd1cENHbVFkZ1U2N2FVcEZZTVVWRVFxZWY1?=
 =?utf-8?B?bi9MQ2NoVGNDZHY3R3F2K2VaWmJVUHVRZWVQbUIrdEFNUXhxVHhEM3ByRjFw?=
 =?utf-8?B?QVp3SzZWQk04OGFzWXk1UkZUNFdOci8wcEZiQXlCUU1wZ0c4aFB1ZVF0bXVy?=
 =?utf-8?B?dnYzRUNMVmQ5bU9BUUFCMWxueXAwWTFOREwrOEZyL0dkS2oySVlORy9reVhj?=
 =?utf-8?B?MENTTUtOR3NjOEsrdCtaWWR3bmJvb2FEN2x6MWJ6aVRBclZLLzBFNkhqT0cx?=
 =?utf-8?B?TW1zYjBneUd2Nmh2Rk5tL3ZMdzZpTStaSWRsZUJwdllOazlGSHVNbmVNNkpy?=
 =?utf-8?B?MEFVaEN1bUxJMEIxVldsY1QxbXR6UW1KbDYxT280SUtuRThJeGZsNm9QVHht?=
 =?utf-8?B?SnVxRFBxSTRoN3RsNDM1OUJ4R1BVOGdXSzNsRjlITzdELzhsVTIyMG1XOGxj?=
 =?utf-8?Q?rT4Y=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e879e8a9-9e46-4d35-4956-08dc6de7b630
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 16:15:14.3235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vSeiFJPT1vqcChuaSaJOiXA+pYP5hb89X+kjTNZUveDGj9xgfsLgAwo/mng8TbHo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8232

Am 05.05.24 um 22:53 schrieb Linus Torvalds:
> On Sun, 5 May 2024 at 13:30, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> 0.      special-cased ->f_count rule for ->poll() is a wart and it's
>> better to get rid of it.
>>
>> 1.      fs/eventpoll.c is a steaming pile of shit and I'd be glad to see
>> git rm taken to it.  Short of that, by all means, let's grab reference
>> in there around the call of vfs_poll() (see (0)).
> Agreed on 0/1.
>
>> 2.      having ->poll() instances grab extra references to file passed
>> to them is not something that should be encouraged; there's a plenty
>> of potential problems, and "caller has it pinned, so we are fine with
>> grabbing extra refs" is nowhere near enough to eliminate those.
> So it's not clear why you hate it so much, since those extra
> references are totally normal in all the other VFS paths.

Sorry to maybe jumping into the middle of the discussion, but for 
DMA-buf the behavior Al doesn't want is actually desired.

And I totally understand why Al is against it for file system based 
files, but for this case it's completely intentional.

Removing the callback on close is what we used to do a long time ago, 
but that turned out into a locking nightmare because it meant that we 
need to be able to wait for driver specific locks from whatever non 
interrupt context fput() is called from.

Regards,
Christian.

>
> I mean, they are perhaps not the *common* case, but we have a lot of
> random get_file() calls sprinkled around in various places when you
> end up passing a file descriptor off to some asynchronous operation
> thing.
>
> Yeah, I think most of them tend to be special operations (eg the tty
> TIOCCONS ioctl to redirect the console), but it's not like vfs_ioctl()
> is *that* different from vfs_poll. Different operation, not somehow
> "one is more special than the other".
>
> cachefiles and backing-file does it for regular IO, and drop it at IO
> completion - not that different from what dma-buf does. It's in
> ->read_iter() rather than ->poll(), but again: different operations,
> but not "one of them is somehow fundamentally different".
>
>> 3.      dma-buf uses of get_file() are probably safe (epoll shite aside),
>> but they do look fishy.  That has nothing to do with epoll.
> Now, what dma-buf basically seems to do is to avoid ref-counting its
> own fundamental data structure, and replaces that by refcounting the
> 'struct file' that *points* to it instead.
>
> And it is a bit odd, but it actually makes some amount of sense,
> because then what it passes around is that file pointer (and it allows
> passing it around from user space *as* that file).
>
> And honestly, if you look at why it then needs to add its refcount to
> it all, it actually makes sense.  dma-bufs have this notion of
> "fences" that are basically completion points for the asynchronous
> DMA. Doing a "poll()" operation will add a note to the fence to get
> that wakeup when it's done.
>
> And yes, logically it takes a ref to the "struct dma_buf", but because
> of how the lifetime of the dma_buf is associated with the lifetime of
> the 'struct file', that then turns into taking a ref on the file.
>
> Unusual? Yes. But not illogical. Not obviously broken. Tying the
> lifetime of the dma_buf to the lifetime of a file that is passed along
> makes _sense_ for that use.
>
> I'm sure dma-bufs could add another level of refcounting on the
> 'struct dma_buf' itself, and not make it be 1:1 with the file, but
> it's not clear to me what the advantage would really be, or why it
> would be wrong to re-use a refcount that is already there.
>
>                   Linus


