Return-Path: <io-uring+bounces-5180-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F939E1BEE
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 13:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFAF1167648
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 12:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1720B1E630D;
	Tue,  3 Dec 2024 12:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="gigL8tKg"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0491D88C7;
	Tue,  3 Dec 2024 12:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733228157; cv=fail; b=GIGd5vFEPPmc01GjZ9rZGrrbfPd+mfDlEK6jLlBTRICpJBLXTjlVPufQswdDVvXJqOKSrtaDSrsTh6ruYms1A4LuyvImnfsZUlsvAo6BCi47DuGNKg2tbIpuH8vUF+0hvzf7iITMWAoGV5GnvHOR4Z5u+ckYVl/qBmLzbaeozkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733228157; c=relaxed/simple;
	bh=oMgjLVoSOrH3KVUx6V5bnbDG7721USakOa49gyI6R+w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M5liW3SwDuuNmobtHHc2kbi4Ne+hYJnLmHr0MBsBciPQFG8Htae7Pu6iW8NZr+nfDgcMWetGprJKo7H9xpJiFvDBhdpp9snM1jD9SHWNWNLnHbMwlouemIizsvmdEITtF7XS3Ru/uwP9Xa3BGX+vbVHQclHndX61UCGZBp7aEz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=gigL8tKg; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40]) by mx-outbound8-249.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 03 Dec 2024 12:15:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gJi4FbPIsClOYBAbnBJzYMSqJzYHFNviIs5br3sM7y3LgSi481Wf8Z+/MmKmAEnihzyW2qgIi3IcIBgxqGu1oshOAIKy6nP08dV/OrKeNi1ul2/ccHLSwRWuY/Yit8MgTHkXOryYLzHGyDwAREgdhSJ/UrElqV4UkY5xlR78xQ9NwPeZdOemJ7P6qwYCI9bU5P6J7eEI8d7/G7LbJhLsLJQWPtPJsfEREkEmtoxHaUQE0mEfDarD1iyzLNWffko6l6EOyij/ZyXONfA6MpBgAKbbzbpyCBexDgBVwxxsrNeCAhKtSCwMr/P2dRO5yzkRdtBSXvJnPVkXM5r70d2zSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FEODyhunxETCFzeTY/Je0V6EFNUClJliwviJgpdcx0o=;
 b=QiNgQwS42i5bTTq7wZonki8nL6jMOYVd/+cEvZ3rWMZ0feVbiE6WDoe9azL2rgj4ltrRIDN3RAN0taVvQp3EPSXE0uC+z/OfUrTNnqR1YKI2SPSpT3Y0FrYwxlMwxL5QOV8hEZkA78UwHwRPGYhWUNtdm80IMGV75sO7cd9Dj9tYQ/ewZqN6ki1QiKYyISnCgEsjUV7CNgBk2JE04IpBIL/PF3Sv1XGOzIkHd4owaQeah6raafENcr0FV5hz321ApWBekZbebST9185nLxBQMbhG/NhcYQQe9sXwlCid/Ji3Ip1xQhEwFZDFngZO+SXi59iysrkoJUysqFEiWrkWqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEODyhunxETCFzeTY/Je0V6EFNUClJliwviJgpdcx0o=;
 b=gigL8tKgYpVEORCdr/AjmX9L3uBuODXSBlhcZCicNRT0GxPgaNUy9SczsMgEPhdkBxd5NMrqefxCAi9AXS8f+TF8THHBBsolFDcf+WC9Y4hHqUEC1oA+SMHmKB1FJWKucWvqbWPL7JbJLZHqPhbHJTeq+aNzkyDvo2hPymUouvE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by PH8PR19MB7808.namprd19.prod.outlook.com (2603:10b6:510:23b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 12:15:36 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%3]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 12:15:36 +0000
Message-ID: <c3fa5d97-aebb-42b8-969c-427766324257@ddn.com>
Date: Tue, 3 Dec 2024 13:15:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 13/16] io_uring/cmd: let cmds to know about dying
 task
To: Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-13-934b3a69baca@ddn.com>
 <2d156fde-117d-45c1-9216-eafbd437cfae@gmail.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <2d156fde-117d-45c1-9216-eafbd437cfae@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P191CA0016.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::21) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|PH8PR19MB7808:EE_
X-MS-Office365-Filtering-Correlation-Id: 3989c1df-dc82-47ba-314f-08dd1394313a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YS9od0FsSVpHck5YK1kzUmd2QW9vOHMvRkVvZUFrY1dndS9McE9YMmRLMldx?=
 =?utf-8?B?SkZkc3QwVnF2MlR6bXkzdzNVK1IyNnBjU0k2bmhiU241ZXVpejQzYm9YcjB2?=
 =?utf-8?B?bjVEL0R6R0hGNlZDNUxMR3dvM2hBNTlqTmdvTTBpT3JTSEd1MXdXeDR3TVY0?=
 =?utf-8?B?L2lsSTlrT0lLell4cURadzI3R2xYWHRxaWJqZWQ2RnA1MTdIV2c3T2VNdnlN?=
 =?utf-8?B?MWZ6bkZBMVJCWnNadFF6TUsvVmFhN1RiT0J3bXFscFdKWXBKUXgxUTMybnlD?=
 =?utf-8?B?ZS9seXlycS9JSm5TUjdtbWt6UzBobWFhc3o5KzZmeXdQUitOdzV3d0h1U2tV?=
 =?utf-8?B?UkZJalhRSEcwR3pwS1Zyak02bHFnZzJSZmZBYTJ0dGRUOENVSE1MYzhTbnIr?=
 =?utf-8?B?L2o0QjJTM2d1NG9RQ2J1YWV6MGdDb2JjU0xrdmJGeXdXUTkwZkVHaTJnb3Ni?=
 =?utf-8?B?L0s1WExJbEM2YlRjUmZLaEhKaW55N0lkdkMxU3NGcktlckpIdTUwQjhwcWhT?=
 =?utf-8?B?TUc5WlBxcTBvdVY4V21BZHpOeitaazRha3c2akRGV29TbnZkS3JFT0dqakQ0?=
 =?utf-8?B?S3gvNUhSOHBmcVlCbS9lT3BPTlZ4d3dacXZsdXZwWGg5Q1hzRWI1T0p6aXpL?=
 =?utf-8?B?cTc2Uzd2TDJ0azk0amUzQXZ2dUNiSkU5WmRUeDUzV0k3YnQ0eFFyRDZWNTQv?=
 =?utf-8?B?YzBWTTVraTJPTGgrMmhPbjVnS3hHNkFPYzd2aXFLTWY0VjlHeGVJMGlyL0ZF?=
 =?utf-8?B?SzFMOU5FWHVuMmVoQXlveUxZZG56d1BPVXpMTnFrYzdzT2hSSDdVdFlub2xw?=
 =?utf-8?B?dTBqUW1YZFJkQ3FUTDB2TTF4UW9aN01KeGhPNjhWZlJ3TUdWbTBsTUkxdEU1?=
 =?utf-8?B?VVFYZWcyZ0NEVnN5NTZtZ2NuSHM0ZWgwdkdCZlNIclVRQmJSUS9FOFZrTnZp?=
 =?utf-8?B?U0tseWhxenJXV25lZnByT1NUN0NDQ2Nkd1h0cHROdnk0NnQwVFVaWUhSS1RB?=
 =?utf-8?B?d0Z6UXhyTjVvOWtKZzRhbHc2N3RyNTNHRVlGZWNsOWQyRTk3T2NwVStmNCt3?=
 =?utf-8?B?SVl0SE9uemFxTkIwS3RVRjFiclNEOUJaTFliR1FPNVZoMUFGTmRuSWdOUEZw?=
 =?utf-8?B?a1VacmEycGZpMkM4SFg2OVREcUtSK1JPT2YzaTQ1MmVNdlN0ODZWZFl3d0lk?=
 =?utf-8?B?ZTdmWXFuZmRJY3pyV3ZZcHNteTlSSC9xNGtJVlFpVUk4TDh0V0Z6OEw4TWdZ?=
 =?utf-8?B?TlEvWnQ0a1lGbzQreUZuV0RVdmk3WUNiSWk1N1pnZXh5d2k5c0hXWW9XRlJm?=
 =?utf-8?B?eXI5ZnR1WGR5SnlPU1dCNStFTVFhRWhITEg4RmJKUjc5VjZyRC9LR2xyY2hW?=
 =?utf-8?B?NC9vSnJjb1l4OXhyRHVPeVE0SFlNZWlVa3Rtc0I0Y2ZHVUc4ck5mWHdLU0JW?=
 =?utf-8?B?dGxFaGJlTjFDNFFMQkdWTUVPSVRvZVFmT2lGZWRnQzF0Umlkb1BvOElINVZB?=
 =?utf-8?B?YmVwOHQ1K2NyaEVhK0lPL04xOXhpb0h5Wm5XbEFtYmtycjZuS0dKaHJMSmJC?=
 =?utf-8?B?ZnU0ZnB3bkJVcDExMWRvQmdrRWdEM2ovVUlvV0h0VnEveTFuVlN4NU5tRWdP?=
 =?utf-8?B?Y05JV3JFcVdxS3F0Ri9NaHBNV0ZOVk9RZS8wQUNtMHZWb2lUNmhUdWl5a1R5?=
 =?utf-8?B?MFQwdTA2TWVJREFobTF5ZmVJbi9kL3d2RWh0VmxlSHp3NXo1WWQxWG9NZGxv?=
 =?utf-8?B?ZGRoNDJFdjNVTTM0U05tVEJhSUN6b2ppRm5rbHZFTU15SjJLc0NoY3BOT3Nq?=
 =?utf-8?B?UjVZVE9xY0luV2t0WHUxdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWV0S2NPUHZrSVpNemZzRnJCY0ZZYU0raGJjRlVMc21RaloyTWt0ZytSR3FB?=
 =?utf-8?B?YTJyR3VTMFlhT3IvVUdYNXNwcmtRcnhzZjA3a2MxWXYyNzVURVc4QmcvaXZJ?=
 =?utf-8?B?b2xhU0piczA4SklqdzhvOGN4cTA5VERkL21tdkd2dHlpMm5xTk1IWkxqZFkz?=
 =?utf-8?B?cVkwcFl2b3NtTmR6SW53b0dhdnBsMm0yUmVEU2RFaEhVNjV5VjBHT2ttSWZm?=
 =?utf-8?B?VDRjNlMxSnlCTy8yWW16b0FGTmd5cU5pTEZ1MVYreGYyVk9ibjY3enVlZXdt?=
 =?utf-8?B?UE5INzhBNWxmUVRTS2VqdU5QVXBkZGFQamlHNGZvbVVmaHFSQnd5WklxYkF1?=
 =?utf-8?B?WHppMUxYR0lod2RxNXlXa0pCUWRvSURPMVNmR1kwZ245alp0TGxvNk4rLzl3?=
 =?utf-8?B?THlsV2NrV3JPaWRnRzVEYkRvZkN6YThpanMwSkdNOVBTMEZ4ZTJJTjdlM2xV?=
 =?utf-8?B?cHM5NFRwMTkxbjRHUTFBcnZBa1lCb1JRUlpyQ0VMN3BxTkFBVGZqMCtlYzVX?=
 =?utf-8?B?TVZsQm1VTHdRRDBLcHBEcVVnSm16bkpQc2pBRHhhWjFJeE0rVytpdm9WUW9O?=
 =?utf-8?B?bVo4SnQ1RjhpVG1sbTdLaDJiMVV5ajFWenJwNUpHdlpobnhJWHMwa2o2WGo2?=
 =?utf-8?B?eTNhdisrSEdNcWxNbFRBaVRLU1JwMkpKbVFDbXcxdEhIcTdmZEp4NzlIbWJO?=
 =?utf-8?B?OUlkSGlXOFpQN29vR2ZBZlJ5d1ZzWHUvbEY4V3NPLzRqZmVNVkw0bjh4MEtL?=
 =?utf-8?B?eVp3NWRTcUN0S3Z4SVVuR3piUERvWUVwMEM5ZUYwWThNeUlQUkl4Z3lhUVEw?=
 =?utf-8?B?OVV5ZU1tNmFwNU55bG1UQ0JkRkNjODNHa1JudVcxZmFDaElUdHNFNFQrR0w0?=
 =?utf-8?B?bGdqRHI0N1dzK2lXRWVJQm8yaWhBb040Sm9Sa1gxOGRCekdqKzhXQVR4S3Qz?=
 =?utf-8?B?SVZkL3hMaHdpcG15bGJQdSt4NEdjWmxwVmNNZTIrNUl4OWZpVWpadzd6d052?=
 =?utf-8?B?bDV2L0tOempmN2pPQVRUK0pmeGh4UDhoeWZiOTF2MHJjSldvejNkT1dDOG1K?=
 =?utf-8?B?cUVjSkRyWUdnclBzRERjQmoxb2VWeE53TmJ0UUIwUWRMSlV6eGozQXJHYU9S?=
 =?utf-8?B?dGtranlMWGF1SlV3Mm55Y08xWkJSWnUwU3BCWnVGSVF2aXlOOWdadlVGVUN0?=
 =?utf-8?B?R2dkdDJoQko5SFFCVmRsdjdSR3dzb0NoVCtJRFFlQjdIZVY3OTdoeFRiRCs0?=
 =?utf-8?B?TUM1aElWWXgzYzdGVllnVFJUc1ZZN05QRzNCRmRkUXpOTFBqck0vQVE2YVNB?=
 =?utf-8?B?d3VHQzlTQ2tNNElxY0JiTWVmMXYxaTFPTGFGdTZqdW91T3ZRdzBVeFBIcE9o?=
 =?utf-8?B?azJRQUlBZzB5WUNGcG9nUzFHdFY0aDd1ZzZwaEk5UUF2dGJXSVhRQXJ6aE9N?=
 =?utf-8?B?VXlTZkpJRkVRQ2JoQndIbzJNR0RCWlpuUFFyTGg0M2phZXZ0MFk5YmpXL3VC?=
 =?utf-8?B?M09IWUFMRVdPdjdIbDlJWStaOTRUajlHSmRvUmFXMVJYSkdkbUFFdkNTeXk5?=
 =?utf-8?B?aWZtajd5cTlqaUg1aE12b3JNNW5aQ1JnT3E2N1ArdS8rdk10WDM4MXliYjg3?=
 =?utf-8?B?WDZMcExGVnkveUNUZWFIdVhuQ3Q0QUVXemlEYVdjTytqRS9XQzJ0a2JaUmg3?=
 =?utf-8?B?amlCU2VzMCtScDNHZVg4MEprTWxiL3dQTUplTE95WjRlZTEycmZTMnZLaTh5?=
 =?utf-8?B?NGNLVnlrWmhWMFZJN0hIVXdkRVNPanhDMTVDa2hIQzhCdGdYalc1TzdMTER3?=
 =?utf-8?B?OXN2NXhQYUZJQm91TUc2SUxaQUVnVVNrSmZFeCtYVXRvdU42aDhQVW1MMkJs?=
 =?utf-8?B?d3JtRU9Db3lBS1k2ZTNBWFo5Um9LYTQyenNvWXlEcUVCZ2duQy9CWjlScGdl?=
 =?utf-8?B?eFBEQ0gyZ2hZbTZHc3A4OE1VZGlnRS9WN3Q3eURIZ2luc2RydHhuMUg0UU9J?=
 =?utf-8?B?WFFmbXJRRDRtaVF6emdxb3ZrY0lBdnR1UTlUZ1o0Z3hGVUU3dG9LWmI4b1JR?=
 =?utf-8?B?djBTK1NXYlJnTUlUb2U5eE5pcW0wejFHYWJJMGg5Q2xsUDhDbGoyZTNleXlB?=
 =?utf-8?B?REhSTWlEZCt0M25tVkNUaXNoZitKRkFpcitHaGplSWw2WHdnNXI2VUgyWEJT?=
 =?utf-8?Q?ZPgiVLyZwVHxdHzfoBXcmJbQ/BICMVIFbexrfpJG5UMZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FJLBDbYfwCSVEj98pFVXnMnSct886dD24zrrUzppqlnu6I4iMReO+8zSduHbQo1VNxhZZ5dM1bUhkXjrqTOQTythB1TmbdGyY8/cav9qGsIXKg7rFAfBtf3bjH15lbUt3hDjOVZhu9+D2YpMRTZEW8jiiAecxrmiwHWWjCs6W8odghmh4XbmOZgyfBzM1waiIMcyX63z/ZjhKskaX65h6j0dOuAzv1cuhmm1az727gXoKA8suzo5gG/iLhH06KtPWY5KmhLCBjK6PlzGFjxMY7dEaRicRNq1PoRyYkFkubYMp7+d1fJWIj3P+GQvioNpUgchjZpkXLXlXslvjjCEqZAlVBGm0Sr7Xy5sqLbPmuwu/FwYzm1u7iIpetwCdzParHNEQxtGLgv4iRhZOO2H9AXxIbnFiqJplECzPJh3ucNXQl0gEHfuy49sDAUWumzZshJO9Yky+mKJx8/i98PZBCDJzzzwIQ2I2jUiRPoOCwLjYQj1jR9OjqE8kp774ncY4p5C74XqpSmauZW50tSzIXJ+omWWFAhxDZz8Uj+Np96YZnls4rQOKZjKqMdgcgyLpUU25OBC/yaQOcJNN0Wfftz7h/edWiiiUDO+1DU9P0UZoEYm3/PCprvHCVKabFhQXT2NghEYaGVJhpIoOTHYsw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3989c1df-dc82-47ba-314f-08dd1394313a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 12:15:36.0944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CwIVivht24fXWHnOfdUk34WTMs1hdFDvF5wjlupphwUPB1Cc1cYNa1EsYgvvMmsFx+0d2nCUx/4R0du6rTeqVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB7808
X-BESS-ID: 1733228140-102297-13403-1457-1
X-BESS-VER: 2019.1_20241126.2220
X-BESS-Apparent-Source-IP: 104.47.55.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVuaWJkBGBlDMzCDJwNzcwjTVJN
	E4ydQg2Sg12dzcPC3VyCjRJM3M0lipNhYA2GblL0AAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260856 [from 
	cloudscan10-113.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1



On 12/3/24 13:15, Pavel Begunkov wrote:
> On 11/27/24 13:40, Bernd Schubert wrote:
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> When the taks that submitted a request is dying, a task work for that
>> request might get run by a kernel thread or even worse by a half
>> dismantled task. We can't just cancel the task work without running the
>> callback as the cmd might need to do some clean up, so pass a flag
>> instead. If set, it's not safe to access any task resources and the
>> callback is expected to cancel the cmd ASAP.
> 
> It was merged through btrfs tree, so when you rebase patches onto
> something branching off v6.13-rc1 it should already be there.

Yeah thanks, just had rebased the branch to 6.13 and had already
noticed and dropped this patch.


Thanks,
Bernd




