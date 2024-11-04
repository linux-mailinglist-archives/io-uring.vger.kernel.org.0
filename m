Return-Path: <io-uring+bounces-4396-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F2EB9BAE00
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 09:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E55A28129E
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 08:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81FC5189F48;
	Mon,  4 Nov 2024 08:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="WNgWR5uf"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514A21AAE0B
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 08:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730708697; cv=fail; b=Xr3KWVT/Mc2lXv2DA4WNGmX0sAY5jcyre90j2adc1zl7We4a/k/DzZs5VE7HDmIaur5GLK812NKC/aQCyr/D7ZD1GLt+IdoboOD8QIaYwvLq+/3HQqM/WjIAwekOPWLcXzta7tq0uBnVs3EqJWCSF3EwA6xYIA47TuXrB/N3u0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730708697; c=relaxed/simple;
	bh=8z4R9yuJoAsCJm89BjXAw+LxgxcUcfDxGtOilFV0EJo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZGwDOY2H1Vjng81rantpAGMJXSnJGEoH9ToX2AcVuiegvBx7Eb7AgN0Jig+oX/m0IybHVE8kb5hcqCl2Vnd0mpc/OvYBzJZm7Epcm432zeGsNVtu0MNhqo9cYZgfaqcN7MId1J406x1NOnK80m7DyPfDQ6FbCfFzpYQ5P5cZBVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=WNgWR5uf; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45]) by mx-outbound47-134.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 04 Nov 2024 08:24:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IIkdesc/GTylBaEYrbqNjnuRekA1fYrXaETCCu6hkOCwkWN9y+//QkLATOI3J4k60TDZm+jhYqFtPiBd3J+m57aZk30lPSiLdfaE79DSnUy7QW6TnHnjPhNM6iRwGd9lSJFyixX7kRI/Hqd+89SCo63xoyhGvTmFRRw0txSv9IAp3yqLgWp5z5AHakABUaq4ELQg49+rsEh5TLDauJe+SIn/CyjP0rFZ2l4D+mfwR5330ZzJaRTci6Bj4EU2qZczll5QMwHjaMzelcgEMF/uyxP+VbodRspZ2RogPM1Cw+2WJw1NCkNP2yicC/D/kK3Wggf7jgK4GQ5sDFZoTVjLkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DwXGvRYwqZ2hTvLFFimJgW8PXbQkMazA1xdE+IW7fs=;
 b=nJIwjm4DIF4QZQOQDO3lxZa6WBOpoIuPb9rBWxZBntq6f8VmJbCFfZjgNzq+H1oBI8m38NUMgnBWkcE8PCKoYapZiu12QjoPsZwKgVCfPGAxIEsamz/eQpkbhFjM86nz3rkS4yBhRSYErUmkJt28Xgx/QnBD6di9u7To7b36JBLVJHXrPUo9EySyktUt25bLaNXRNbR/ZkeTK9YyfTOhvOiS33eI0qSCOfAEDE6fuYI4K6qF2LtQiOaoyjAvSB1mD4OAwv+VzAfrBf8USYQpuFzVa05YZKNwVIkSr9vmiHfMQukNwd925AsVG+RmTfIdzTC8TAXP964+wlKB4UNsbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DwXGvRYwqZ2hTvLFFimJgW8PXbQkMazA1xdE+IW7fs=;
 b=WNgWR5uflVly+4nG7F/LmrZkQPAAFSI6RlIxYeI+VJx9h2Fqf/eEtUZQI6L9VkwXiAVubxFa3eH5abNp3B8cr9F1GPkUheaqG+qWdeVmxg6RuuZGXCPOLXJOxHjddtN7QifpSSVuM3g3BmRdOue8Ekg9lFGJ25COAT7aMKyiBYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by CH3PR19MB7929.namprd19.prod.outlook.com (2603:10b6:610:15a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 08:24:36 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%3]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 08:24:36 +0000
Message-ID: <7c1cb193-cd0a-4b7f-b4ca-4cc4407e4875@ddn.com>
Date: Mon, 4 Nov 2024 09:24:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
To: David Wei <dw@davidwei.uk>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <070c7377-24df-4ce1-8e80-6a948b59e388@davidwei.uk>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <070c7377-24df-4ce1-8e80-6a948b59e388@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0058.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:34a::10) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|CH3PR19MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: 07dd0a06-360f-4c2b-95a2-08dcfcaa1e11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHd4SVpQUWZaSERaczZNOVJzSHJYNzladDJpbTJCYVlQZUNmMjhjSGQ4OWFV?=
 =?utf-8?B?OE5wNTZZc2VtNDk3Q1N1M1ZxNi85RVVOcS9EcEZsTWdIOHlJRXlMeVI5aTkx?=
 =?utf-8?B?czVYMkhSRWFCS3RZN3ZuUkJXUlVWQXZKRUFmdEhhZVlvRVZsK2JrTndoTHd6?=
 =?utf-8?B?Y3VlN3h3ZUdUeURuVWwrWVRWTHp1T2V6V1lPdElld1lQbWxpcU50UDJlclBU?=
 =?utf-8?B?WTdaQ0hianRtQUwwZmJCajB6cG80MWd1ckdmNVNma3MwQWFwcy9GTEZKNWNi?=
 =?utf-8?B?VFVaV1NwdURRRjJucXhXbm1UWW1OVlZocVNJWDl6R1JaaGJYZGgxbE5McFpD?=
 =?utf-8?B?Y1dycktUa0xaa093eEtQUWFhWjFxQ1JMTUduQ2poYWdueTM0VzBKM3ZwK21L?=
 =?utf-8?B?bURURkVLQlVkSTkydlptUW5NS3N4aGt0Q2NuQWliVVA1QlRyOW1TM245aW0r?=
 =?utf-8?B?aTNZYjJzcE82NTRxajlHQ09yMUFSZXdZeHFhVkhtcW0wZjR6eHlpQjVhK0du?=
 =?utf-8?B?K3NuNkUzWEtTSUtvWmlaRis5YkJXd2tiUkV2YVdWbkduVzZLdUY1ZE1ucG5u?=
 =?utf-8?B?OUtRQVBQL0FyNXZGd1ZYYk1XVnM3OTlYaXBOajJhMGZuNmFCdkxmdTVwSmlR?=
 =?utf-8?B?UFZ5NW9YNXh3T3NyQlFDc2lRZHpmRWVtcnB4Mkg1anhHSEhEb3NyM3Q5S054?=
 =?utf-8?B?c29CTUZvM3M5NVJub0pqMFE0Qm9ySUNqSkRWN3JyMGlCSzhSQUhwNU5acmlV?=
 =?utf-8?B?VVJMaUhzRlZtNTl0NGt6eExXSER5UlBJYTE0KzJtZ29pUnlheEVRdkwzaDdx?=
 =?utf-8?B?VTRnaXcwL2Flajc5NjQxM3JWL0NibjlCdjBvTEFEanhLbzNTK0MxeHA3ODJp?=
 =?utf-8?B?OE4zeUdPM24vQ3UwYk5laHBNZXNIZlNLbUpOTUg4OGJGWU5lYWxmNmdEekxN?=
 =?utf-8?B?QzJrV040bGxrYmhDMFZkbndpWWhJL1cwc2xsSEM2cW5Oa1B0aHhlYzVVd1Jw?=
 =?utf-8?B?UDM2TmcvM3hXNjVxVzZ5RE0vQ1VFcVNIamFudklRNHlETTNUekloU0lBV3dp?=
 =?utf-8?B?b2tSRWRkdFc4UVF2MHlINlF0SFBEMkV6OTl5Y2M2WUowUWgvNVd5RFIvTVRp?=
 =?utf-8?B?Q05aTytvZVRSU0ZFNksrelhjZzl0RUZaL3FSYXJNM3dtQXdReEtEZjgyaC9a?=
 =?utf-8?B?bDdTMXdmcmJMM1JsQU80U05oM3RucjE1eEZtdmdyOGZ6ZG1CamlJR1RMZUxw?=
 =?utf-8?B?RE5EREMyUHQ0TnpxenpSRThLaUFLQ29aVWllaFNHWWpwTGFQbHh3RVhZdDQx?=
 =?utf-8?B?NHdHZHdZYmxOWFFtdlE0dHFjVHhxZ0RwZEsvcG51V05CMXJrSkNQYy9xdUcw?=
 =?utf-8?B?ck9DYVpKTlNhdVBBckhKbU1MNXhIelJhdmdrNE1FdUw4V215ZG1PSWlTWnpF?=
 =?utf-8?B?Sm5FVFo1TVJBYm9IeDdXVUM0NEY5TkxacElEZDU3Qk1SWDZMbzFleWVqYm1i?=
 =?utf-8?B?Zk53T0RLd213dWVYSlZCSUtBRzdsOGRMblZMYS9qWUo4SDVEZDRUMkxNaGky?=
 =?utf-8?B?MzJCZW5PWmZsck96MUREOWxmOG1UNXdYbDhCZlp1Y2tHd3g3dUhzcXkrcmNY?=
 =?utf-8?B?dE0rdFN1bEdlUmF1ZGorOVJrSVFKbkFJNjVRTmVwUDQwbWZMQ09JbUY5SjJo?=
 =?utf-8?Q?2gw0kVnzutviCHXdSuGm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(10070799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkdncERra25MYkVENXJxcFZZcUdFMnMzMlN1WFNpVkJOZFhMUWlZc2FpMzk1?=
 =?utf-8?B?QSt2MzlGZjFjdDBKNld3eVZ6dG1UVm5KcHErVEUxRVo1NDVMQTNBOTVTOHd6?=
 =?utf-8?B?dmpYVXIyem4yaUdnSEpadlNSdWZ0SWRUaHFGUmZjUlZqdzFQWDZodmlQWDZk?=
 =?utf-8?B?KzFwUVFvUEtUR0oraXNPNm5pT2M2S2dSaWFUWGdDcWVJcHk3Y2tzTWFRdnFY?=
 =?utf-8?B?QW1mVC9WUTBoZnRhWHE1ei9FYWcveHZaa2xoOW9mYnRsVktEU3o2UXJqbWEr?=
 =?utf-8?B?dTF5NGZGbEUzR29zcHRGMXllUW9BbjRyc2FGZTg2dGlyQWpobGVHZzJ1ZmhO?=
 =?utf-8?B?NWRLbXgzZ3QybDBuZ2xBQzZNb2xNTGpZQUhpc3Bra00yZ3pFYnlneVZxWXQy?=
 =?utf-8?B?aEdnMVZNVTQ2MXBvKzZsYjVXamMxeHNBU3hGdFRYaUF5SDRRalh0NkJmWkdU?=
 =?utf-8?B?cEExTVRDNkVyclptQkQ3a2VrRGdDVGpYZy93NXRoMFYxVTVmWWNyTzQ3US9j?=
 =?utf-8?B?S3h1WHYrZFMzdGV2QXdGbzlGMFE0Y1hLSWdvMnQxMnpab1ZlOWREOUFnc2Rj?=
 =?utf-8?B?NUpUZTNRUUxhQWZhSVdvSlQ3NENKVktLdlFjTXJER0hldmNUQzJGRElWcXFI?=
 =?utf-8?B?UmJpNnVWSmZycnhlbjQ0WmFtZk5CQXpndGpCTEJpS2c3M09YWHQzUVd6NFho?=
 =?utf-8?B?TTVzOTI3NEZQZmlubFZoTGJFR3pxVC9jNE1FNkNkNVM2NzJKU2h5ZkVYOEdj?=
 =?utf-8?B?V0JsTnFFd0NCOERkeWxaeEdiU1NJQXNzSmN3ZDlIaGhvbzU1ZDhIVFd2eDRV?=
 =?utf-8?B?V1hYUlVqRVBrOWhsbE5kVEJMTWNkakp3bUd5RC9SZ0cyMjJqZThqUUlXRldJ?=
 =?utf-8?B?WG4wTC9Hd0g1TnlQR0R6Z1VVTVQwS0JvMEZDQm5udWYvTEs0ZGMrVEo0aXk1?=
 =?utf-8?B?emVkYUpEaXRBdVZySkdidVJhRlNDeFJDcHk5eFFtNDFzVG4rWThBaUJCQVZ6?=
 =?utf-8?B?V2dEY1BpVkVpU3BXWHZnLzVUNnJQMUlYUDV2S3c1VjA3NWExMUh0aG83THNR?=
 =?utf-8?B?Tk1kYUc1cFllTEtpQkx6akp5TVl0Z2QxajhWdDhFYmVRVXIvcktIR0tKWlND?=
 =?utf-8?B?ZEVjaUdzQXpYMzAwL0lYRkxXTUcxamJHUTdaY3JyZUUzM0FIR3k4NnNHcUk2?=
 =?utf-8?B?dHB6RnpTSkNDRHVUS1dSOEYwdnNJQmJOcnNjVzhTWjVHdGhramxpK1JYczF1?=
 =?utf-8?B?NnRRWE0wWUlDajYyVUxHRERHb29sRXJremZuT3hRQno3SlN0YzczajI2RkFn?=
 =?utf-8?B?RkwxNmlBc0RKNWZtZE9BQ2RPNWpNc0lvSHNwd0J2TWNucUpwZXN0OE8zYUtv?=
 =?utf-8?B?K0tMdnhGN1VGNXRad0ZuUEJVcDNUaDk5U2I3NzZta2FIdWVJQTJRaG9tby96?=
 =?utf-8?B?clBxUTJid3FqUEVmanFYYmJQaEJ4bkRiYmhtSVBXUWNvQXFvYURrWkkzckk2?=
 =?utf-8?B?UDhKZlR5RlcraGI4OW5nM2pmbjVZUEF0T1JSdEYvS0duN2c3M0pZa3NNOFl2?=
 =?utf-8?B?a1p5OSswUkdHc2I1bnI4Mkdhems2aE5rZFZQZlJTRVF2RlMwMUhGeWdKYmlH?=
 =?utf-8?B?WFhLNTdXZUJXajJ6aDAxWk9qUDZUbHpYUWNNUjhzd21EeXFsT3dLTFBOd3Ex?=
 =?utf-8?B?N2VkNVE3MmRsbHVIRFYvazZBbGhKYmxBSWE5dzlORkVnU24rYVhLR2xmUUhs?=
 =?utf-8?B?UUE1SG83bnN6RjBGNHR2Y3dHQjNkU0dFWlVSUGN2RnBNVHdtUGUvYjR4RWlK?=
 =?utf-8?B?SmtoODd3NWlaTXlSR2RXSkNwMUQ0UkRWOHdYS0E4RlJGOVk3R1BPQ2JXMktk?=
 =?utf-8?B?eFFrYW1NeEkxK3dyLzRNVXljUXVuWUlFWXk4Y1hPWmZ5N1JnbHJob2xZcjM2?=
 =?utf-8?B?SitudlNUMTBrYzRhR2gxelpvZGRJcEJhTFl5UW1pN01LU0hjbFhsZUhvbTA0?=
 =?utf-8?B?S2VFN3FLN1U3NUJRQ2lZV3VXSVNQQ2ZJZ1dpcDIycnJrWkRUN0xsNVVvYUxh?=
 =?utf-8?B?NnptcU9UdU81a2E5dGFVRldxMmxITWpmU2RwNkYxOGt3MWtpZWRKWXpEM2pi?=
 =?utf-8?B?RmZpNUhTVlZOdVROMGRZeEFKUm5CWkYzcVl1WTZMY2xUZDFzbitZelUxbVBT?=
 =?utf-8?Q?Z1SjhHYfY80o63n95iE8KqhsbRGxIRvBxBwglmoyGFNs?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P7rR+Kmq0PGbC6wTTLP6aqBJzTATcicpLoWqbZnbD250FH5sHs4d21dWc/IkEPoKhTQAUrdnM2kGRbxlcYyOLnQvrhIhbh+KaulaghA60yszyiUgcUyRIEgxfPfzQc/r/KEtqxTvP6ZU4qd3GFlBLpaH0i29BXZUtBcMILHuqvEMz4eivzfx5Hs5g6nFO4ToZHWVyuZ2aDih4JTC3yNYzWajRUeP2XY7h/Fvm9FeiWaJPGVpqESTBufw8kL3DYm622MuInTjgFIj9ZkLuQRqEAYyJXlUYi0+W78iTFUg1b83XjoyNI43jRD9vq0/KyK030D5LVhzef0/w19atCdW4ioR0MFP5XTQgMnA0EUu4EwiWgfZu7aoICovpqiwqRFGvHm1E6dkytVuSJWdp1Ppr6QZ360lHKgG1SJ90TehKl81JeUSpNcaZuUzexW2vKGbXxGCYgQ2iKs0xVb5wyane60VhxnPT33sXX66zeoyGy6I6K40KixqgtyiWgIWsjpD6y2lgl0R4PVr0n/hcL7mePs45Ij2DiOQQpSiXIrVfPt3z34qJapax8fEo0uJvOZmIYslxFoqlEQNXt8X/F26LDO8djFmHe1eAU2HjXJrQ2/dI/hYZxchQSBuOp9uN47fcUVqdA+GA1pY0rKe7hnBJQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07dd0a06-360f-4c2b-95a2-08dcfcaa1e11
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 08:24:36.1326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mU86wq2bJIkl1WFf0+D4WxVxwKcF9W9n9Hoj7GCR7LQRXs1fZIAI1K1dCnE3okH9DsyHrpcFikALhjAejtKig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR19MB7929
X-BESS-ID: 1730708680-112166-9784-59914-1
X-BESS-VER: 2019.1_20241018.1852
X-BESS-Apparent-Source-IP: 104.47.70.45
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoZmRkZAVgZQMDHVwtTQIMXMwD
	wRKJpsZppslppibmaUapRkYZ6caKxUGwsAi6cVpUEAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260190 [from 
	cloudscan19-108.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

Hi David,

On 10/23/24 00:10, David Wei wrote:
> [You don't often get email from dw@davidwei.uk. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On 2024-10-15 17:05, Bernd Schubert wrote:
>> RFCv1 and RFCv2 have been tested with multiple xfstest runs in a VM
>> (32 cores) with a kernel that has several debug options
>> enabled (like KASAN and MSAN). RFCv3 is not that well tested yet.
>> O_DIRECT is currently not working well with /dev/fuse and
>> also these patches, a patch has been submitted to fix that (although
>> the approach is refused)
>> https://www.spinics.net/lists/linux-fsdevel/msg280028.html
> 
> Hi Bernd, I applied this patch and the associated libfuse patch at:
> 
> https://github.com/bsbernd/libfuse/tree/aligned-writes
> 
> I have a simple Python FUSE client that is still returning EINVAL for
> write():
> 
> with open(sys.argv[1], 'r+b') as f:
>     mmapped_file = mmap.mmap(f.fileno(), 0)
>     shm = shared_memory.SharedMemory(create=True, size=mmapped_file.size())
>     shm.buf[:mmapped_file.size()] = mmapped_file[:]
>     fd = os.open("/home/vmuser/scratch/dest/out", O_RDWR|O_CREAT|O_DIRECT)
>     with open(fd, 'w+b') as f2:
>         f2.write(bytes(shm.buf))
>     mmapped_file.close()
>     shm.unlink()
>     shm.close()
> 
> I'll keep looking at this but letting you know in case it's something
> obvious again.

the 'aligned-writes' libfuse branch would need another kernel patch. Please
hold on a little bit, I hope to send out a new version later today or
tomorrow that separates headers from payload - alignment is guaranteed. 


Thanks,
Bernd

