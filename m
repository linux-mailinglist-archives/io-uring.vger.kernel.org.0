Return-Path: <io-uring+bounces-13385-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COEqN6DkCmo29AQAu9opvQ
	(envelope-from <io-uring+bounces-13385-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:06:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC0456A57C
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 12:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 445533006536
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 09:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 426813246F0;
	Mon, 18 May 2026 09:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="IYgFXEhB"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0422324B20;
	Mon, 18 May 2026 09:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779098131; cv=fail; b=gJbbgap14kSmAop2FzU/sMsFrjuDrKiSaaT9y9l4BmJH2jhr7wuM1vAe76gItH/TySQUxxgz4qC0Yp/hlD39hNzvzn7rtlqQaX2YlXaQKhPG1de8RzWHgcmBTY323p/T1+pqBA/ryTYzguNuPjlfkEnS4ecZM6mCIRhE59qGWAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779098131; c=relaxed/simple;
	bh=hMB7BBgRmafQs7mOHLKewrlHWwxawd+T6G4zt1aqW4w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qkm9hsJd9TSHcAeqWUMfIUJgU+VRkMvmLbXHQZSRSVeoRuEyB7nrKeAZHOF40ka1mF18I3pVn8nb2tsaw3dGfEHYQzPTvEWRl8zsIv8x76XyZz4I9fSF0MzO3KHgsdqxk9oOtKbCOPlvtOqW0Wuh0ZLXIBHWqONEVvgsPXPxJxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=IYgFXEhB; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11021099.outbound.protection.outlook.com [52.101.52.99]) by mx-outbound-ea9-161.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 18 May 2026 09:55:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WZL/bDF8PTptey2QGn0MoIPpU3SPZJnQX3muDt+InWwheQf81lwzl1p8gHvT+uH6P0hBzkBZtL1Hv5LCgO3kB8AgEKFP9PF8eYXlYEYnkZtlWzwi3tr6B66Ix8BvWcG7tKPWbeKtv4IsoPUzz7s25iNUk7tWU7Rq50rjiWDuWWUafO8d8Ik51rpsiEaw8X0WOj6dTQgGjNikEYPT2Yex1wMl4/07Rpc1rAbSa6x4TOfpNcRQn8yCee8yGKYnrJXHIIRDoOvjWkE6mIc6UmMbkD1aVpUKfy1G9xrA6xRXZa3F7h6G0w6hF0qYTEei8yeVXxyCBErqZNc6ncZA4fftkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMB7BBgRmafQs7mOHLKewrlHWwxawd+T6G4zt1aqW4w=;
 b=I5EFJ1IU7vAZ+L0kKbHOaMIccBCcvlwWK3hntu0wrr2s5ZTb/j+5HzSDuK7ta0o59NZ7Zv5OIIil0NgFmpsULriYAq/FN3L/lh5Pjh4CjQPhrzpC9/hlDV5LpWSTV2MPZyVQzk6OQO/sf11HavzDYKBcB6TTqz6vPovEaoO43wSjpRmrGKqbw9xttTKZeEip0A7t5Ch0j+J2eEQ/q3LezslKg2Gdz45b27HF/0RsugxA1US5OcdUiE/8ZKftS6TsIl7hhW6Bqr+AgLlKweAQjGF37qeaBo8SivMFIL+NjI8lGfN4mTPwY4OdYfTxb6MkRPJKk9YwHdFfb8mqTaaI2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMB7BBgRmafQs7mOHLKewrlHWwxawd+T6G4zt1aqW4w=;
 b=IYgFXEhB/jfQaxuqhTXc17eINuK/kGW1Zbkf+QK0l/XCYevt27ZMDMbZ+D+tet4JEqbmcCQjNcGx4uyyMUdZUrvQFlKtZLxCSAfy7xQaZ1Hm6xSv1EVguZ1jCfiOOWESPEcLJARZMQd8LvUGM/hk7Km8/3TqTZZtv6m/fe2DKkc=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by SABPR19MB997500.namprd19.prod.outlook.com (2603:10b6:806:4f0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 09:55:05 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704%7]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 09:55:05 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Berkant Koc <me@berkoc.com>, Greg KH <gregkh@linuxfoundation.org>, Miklos
 Szeredi <miklos@szeredi.hu>
CC: "security@kernel.org" <security@kernel.org>, Joanne Koong
	<joannelkoong@gmail.com>, "linux-fuse@vger.kernel.org"
	<linux-fuse@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov
	<asml.silence@gmail.com>, fuse-devel <fuse-devel@lists.linux.dev>
Subject: Re: [PATCH 2/2] fuse: wait for aborted connection before releasing
 last fuse_dev
Thread-Topic: [PATCH 2/2] fuse: wait for aborted connection before releasing
 last fuse_dev
Thread-Index: AQHc5f0ab+Kc+AhELUaTC1v0iClq0bYST98AgACrHICAAJHXAA==
Date: Mon, 18 May 2026 09:55:04 +0000
Message-ID: <fb437530-94f1-4f06-98d9-a252e4ff1315@ddn.com>
References: <20260517095846.fuse-iouring-uaf.dc5f5dbb71dc@berkoc.com>
 <2026051703-equinox-multitude-91e2@gregkh>
 <20260517-fuse-uaf-cover@berkoc.com> <20260517-fuse-uaf-patch2@berkoc.com>
 <08d3f6e0-7745-4084-995a-95ddb77f7f11@ddn.com>
 <177906678512.922207.11821272786828738648@berkoc.com>
In-Reply-To: <177906678512.922207.11821272786828738648@berkoc.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|SABPR19MB997500:EE_
x-ms-office365-filtering-correlation-id: b35a19c3-af7c-41e4-aa51-08deb4c3894a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|1800799024|366016|10070799003|7416014|376014|38070700021|22082099003|18002099003|56012099003|4143699003|11063799003;
x-microsoft-antispam-message-info:
 hnitEKEVsri+RYd7wjmZFW6MMDtS3+7qjuS8JxBynw/WEYTm5+oCvNZAUHmMkhEdhSvjQRsl9opt1dRN6bl5jlWLDXxVl+EjGF8FYRxeG9ksZYNKLZb1lEOat8ng2rV5DK6ufcxA88GIfnx0sNYNRYoSvvb1yqYh9OZjPvcJlRHAsdHvzrliopZ77hGgMPteEYLgcJd+gNq1V01FCxiENgaZPT5KO3G1T9Zf9DN6bY8Xsu9ZTCYN9FUd9RLILCX7ody0sH+tzomWLyeSVDB9LrrogrtTsbnC4ka2LhN++ZN2a9qqXs26tI0NA1+50Bd0A8MLhw1YP/UMZebXEDTUK3R4dvdBzF2ZsdkuxMPfCS+DllpOj7S+aaH1rn0B+gx6H2yZ6mh9neDQpHGtHto0BknrsM5RKGFN+JY1gCJTT6olpFWODW5fj/i458EwlPcIU7JaVTptHhC1R7SQw8u0c2+FmakpLwYOn4CQ/dx88HBPJem6sqz3cPNF/Mul4ftg1zZJSaD0/n/W73yV5gs/hGjryNWPN/UuT/h8CWxXxIMyM8qBctQQs8E8NkdoEttanJ9x4H31oxecIjM7SDcd2s3a0W0Z/ICrBbKU0zx05AqEHWEhSdAv6OX0lCrx9SzNvDqMnHR2pPjswPLyEKKchMZ0AL3eH6UGoQsCD9dhw44vm+KYclkyp57XRA9ZqQt2O5e4g4cUHkNmjUSFCpimWxtBaTV1xMzDr1G1v45IhtJIfDGbrPu+MYaCl+XbCW/e
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(366016)(10070799003)(7416014)(376014)(38070700021)(22082099003)(18002099003)(56012099003)(4143699003)(11063799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z1NxbTBJQklwWUQwQVlCNlZKVXhDU1FadTFhQ2JmbnczVXZZSXorVUR2VHhC?=
 =?utf-8?B?MWlBS3RYcUc5WE5hTTFjVXlTbnduTXE2L3hWOHNVTWhaS3UrN292ZFlmQ1pJ?=
 =?utf-8?B?SnZGZVJscytxbXlHZnZhTzkyand1MldUYzdVNFB3ZUlSRDdvaWU0eGNJQ3Y0?=
 =?utf-8?B?eXhDLzBTTFNsVGNRQUJxYkgzMlB1cmxCaUs3aUdnOWNCUWZKZ3hFTUJzMENw?=
 =?utf-8?B?TEdXOXpMT2QzbzFvN28wT1cyK2J6SFM5V1dhaENiaWwzMHl2Z2trYTJjQnFu?=
 =?utf-8?B?TDdaVVUvL0VQQ1RCZExwOC9pMkhNMG1lOTVoekxhOElzTTdCSTA2bmFkaEZx?=
 =?utf-8?B?OWQxYngzTE5qWk5wckZuNHo2T01wRFNYbVNaYSszMmNqcURuN1FZMkdIVlVK?=
 =?utf-8?B?WUt4UEpnVmdQMURCR0VNT2dCc2VPMDJnbTBRNjF6alJZeDhmL0xFaklZbHdW?=
 =?utf-8?B?ZXlqUklSN0ovdXcwMFJQVmRtWmlUMTF1ajRzVHVVeElOUXY1R2V3WFBhZ0wz?=
 =?utf-8?B?YXZsd1lYY3EyYjdkcWgwbXFVTTdoc29QZ1ZmZmdTakNzLzhWQlFONm1SbDQ0?=
 =?utf-8?B?ZllUMlQrVDZac3pXd1htcHkyS1BnNlp1T3ViZUdqN3hKVTlmc3lyMHpVZnhH?=
 =?utf-8?B?VGZvcHVaempyTEEvTHhjK3diSFdHS3NQQmFlaHdGdVNtK3FLVVVFb2dybjl4?=
 =?utf-8?B?bjM4UDJvWlJvZE1vZDg2dmQ4R1pWYmF0Ylh1b3NlTEtsdjFOOGg3SDVEYVhG?=
 =?utf-8?B?N0VUeC9LNUIwRHY3WnYxSVdNT1plWWtTSllNREJOQzhzRjBubWVNK2U2bk0v?=
 =?utf-8?B?N3NscUNnQ2F6THFGZG14Y2Zqa3YvTmNibTZWT3VEa1Y1R1Ivd3JnaDRpYzlK?=
 =?utf-8?B?V0pyeGNNK01OR3hTQ0V6MCsrbzNKRjhoK3hIS0xmUHl2bXZYUG1LckM2MU95?=
 =?utf-8?B?TVI4ZE5yWlV6VDVEVE4yTFBjaVhORXpyVGh3SEJNRTA3M2lKOVZmWXBiTGlT?=
 =?utf-8?B?Z0VwREhpeitrUC9EZ01IWlNycjJvUFk3MDFvNS9qalhnZGlqRHhPZDk3c0NH?=
 =?utf-8?B?QlBuTmtVVTVobklKdUtnVVRtWnVqUlVjMXY0T3JxeUFVOC82QjBlMVkxWFBD?=
 =?utf-8?B?WHVndWZHeW1XSFZJcjhoeUJnZGtBRFh5K2xOaWFUZVZOZ3Q3RlFkMXU5amZG?=
 =?utf-8?B?ellENFk5RWg1T1VTSVlwT3ZnMmpVMTErWFEyVGFNSW0rMTRXZmFaQlY0ckpN?=
 =?utf-8?B?M1pqZjg5ZEpHU01NaEJDNVpNd0dIV2xwY0JkalUyTlY2RG5vNmtqYkU2NXQ0?=
 =?utf-8?B?dmVTRmkzUXRob3dQQlFyZW12R3FTNmIxMXdvREdBdm9GaUNybVhHS2I2N0Jx?=
 =?utf-8?B?VllyNkdBaTVYeWwyL1dmeThRL3VjL0Vjd2FIckdPbFVQR0ZnSzM2WmpVT0RJ?=
 =?utf-8?B?aFRoQWFtRUwzaTFVd083NCtBRElyMTdxeXBCZVAwcGVtZUx2TnVRMHRKbm9y?=
 =?utf-8?B?Z1ZWYjJOS0xiYkVJNEVMMmVacmxlUmsxUHZFZk1FWWZQR1RKV2dOckpld2dw?=
 =?utf-8?B?ano2UFY2WUV0RlpHbFFMT2Rhend6cXg5alowODBqYStTKy9pcllaUy90ZWY1?=
 =?utf-8?B?bDFzZWk2WkQwelpBV0FsTEVkNVA2MjNXM3hyRmVvQTF2NWNBMzZWNk8xYnI1?=
 =?utf-8?B?R3ZSdFRJVnIrcVFhNjlUUDMzRTY1Uy82YUNYVXVtNHgxTVdWQUVWNW5ucm1T?=
 =?utf-8?B?c1JLd2hkNkRYOWxCNUkvb095Y2ZXWTY1ckMyWUlYeWdtYVd6UzAvYllxVEMw?=
 =?utf-8?B?RTJlVDdiLy9sMkxvZjhLT0s5VDc1eFNLVVpBOHpHZFFoVEpEdU10OEJlV3JB?=
 =?utf-8?B?VTdMRWpjMXV1VnBST3JYaDRScHVURFJTNXhIUWF6K083cnJyVmwxMXV5Ukh0?=
 =?utf-8?B?eitEaHIydEI1c29EZ3hNcm9ITHJQUG1kUEVmcllRYUd6SXFQKytrbjBvU1c0?=
 =?utf-8?B?YkZnd25OaWs0ekU4UmQvcStZNTkwWHJqRDRoMTRSWm5ac0xCNDZFc3hPSk90?=
 =?utf-8?B?VXZYQ29tNFQ0SkwzanQxSWYzUDlzOUFXeEdOTCtZVzhrdXN0d0JJcmRBOCtk?=
 =?utf-8?B?bXpPYzdlWkYxZ2NFTktrUjZjaUZhdXhEWlRVZEV6STdVVjVsYWh2cVhKbUwy?=
 =?utf-8?B?d29oazl5ZjhGVDVVTVhKeHQ2UlBpMlRFYUtITzE0aU42bkhVcHUzQmZYV3Ur?=
 =?utf-8?B?YXZ1VHRnU1JIZXNOc2JjOWY0cjYxMS9LMStWOFlBcWUwVElWUzFLbVFrV01B?=
 =?utf-8?B?VUlYU3pzRDFNaGx6ZFdQVUhyMjU1UFUyQVE5SWE3ZndPMDk3QkluZWN4NHpl?=
 =?utf-8?Q?7GJ+SVVeth6kHkNis+QVxz1ku9jrHiBxp26UE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DE756663F3F9B4580940E60E5D5B4A3@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	ZBsCv7GwnK+DgiU8y7j7jCCQnhyHNBAv98Nbm8oLMJnXxPbsANZ9NEbBqpziSxa2kWD95RksK2KbS+58ATEu3ehc9wR2lndiimfoVd0SwjIY03Zxc1UOe1PvHAVNkX4MKy3OvL9W0aalxaYHAGMFr5aRHgROH3XlKo9GW/lTH2vEyGDXymSv72Q7FNOc+eHiEYqpyUrZvsMm9sWtDzd+HXHEEzn34OGzcRb6BmgkqcLvG+RIswaEzCZO/5zvhs0YqURN7iNOqFxDl7KEz8oZVqrNDPj1/+goQALlusPIlUtF2Z+DGC4CsLkAg8SmYUBaR1rraFkdn0QyspbTD1lZmw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qLPIOmclS1PIqHqsjQjWbx5gd/4XdWgSBT+k/1v+C1EdqLzawim7hKsNbvPCWqapL1jGnn7mz9onc0r8OJFauYtipRnco197O8HinMrBjP9WZBRVkIbQqLruGqUCjDp7jtuXt0uT4eweYQWO5H50YhA8kqowlsDgQRdQryPSyvtXVdQdlLNLJNTNaY/MQUxuw7GiUjc4BWEKObxdcnTrY+jSBH+0TFQebt6nDV5GDerlCeTXwRqTBQWHrLjh8zP+n62NW3Xtu/lW1ZFdPckx+mRpGaWDPP/hOQF0XgkVHIjYZ9ILROts+vQbsHK/Pud98pqBHKYk1HrqikkBFOqRMUU5h0R/etDtkPEItMcxjk4tjBdGUbRj2AdfqPhMHZYYSpW7J/EfW4PN2F9xPtPmjt57j9K/a4EXCGyZiraoOrMMXN2bpzTkq/J4aDQjfqadXXYhb9UiguGGxuazhrtLEqIxmqXbj4J+ohX19mDPbPN8ILy1jVZzWd9oUYKCKB4G20KbB+wn+FfNHAEHRlb3fZugO6T7zeWX7+Kz3HGvNqXkBM/Ij/OUD4R2K071E/S9VD7mhnQeCjCYYuYzaxyoaAt0Znw19N4TO3Tv3FEblrSMDlOudnQtLzYsiCRtSgRcywnlFy+HK6WLx+U50WxPvA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b35a19c3-af7c-41e4-aa51-08deb4c3894a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2026 09:55:04.7668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y7u3isdHgxxlaaglitgcQJCqlBkfFCoyEO31zTp3enKQB+QGhERtHQp/guwyORKhuOwiKNf8Fko6gXe8Z/OifQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SABPR19MB997500
X-BESS-ID: 1779098106-102465-9383-6312-1
X-BESS-VER: 2019.3_20260511.1739
X-BESS-Apparent-Source-IP: 52.101.52.99
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkZGFkZAVgZQMNkk2TDFxMTE2D
	TFIDnFyNI41djSPMUwJdHQMtHCOM1YqTYWACYSTTNBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.273289 [from 
	cloudscan8-116.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1
X-Rspamd-Queue-Id: 5EC0456A57C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [6.44 / 15.00];
	SEM_URIBL_FRESH15(3.00)[berkoc.com:email];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	SUSPICIOUS_URL_IN_SUSPICIOUS_MESSAGE(1.00)[];
	MAILLIST(-0.15)[generic];
	BAD_REP_POLICIES(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,vger.kernel.org,kernel.dk,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-13385-lists,io-uring=lfdr.de];
	GREYLIST(0.00)[pass,body];
	RCVD_TLS_LAST(0.00)[];
	R_DKIM_ALLOW(0.00)[ddn.com:s=selector2];
	DMARC_POLICY_ALLOW(0.00)[ddn.com,reject];
	DKIM_TRACE(0.00)[ddn.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-0.391];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bschubert@ddn.com,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_SEVEN(0.00)[11];
	R_SPF_ALLOW(0.00)[+ip6:2600:3c04:e001:36c::/64:c];
	REDIRECTOR_URL(0.00)[aka.ms];
	DBL_BLOCKED_OPENRESOLVER(0.00)[aka.ms:url,ddn.com:mid,ddn.com:dkim,berkoc.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: add header
X-Spam: Yes

T24gNS8xOC8yNiAwMzoxMywgQmVya2FudCBLb2Mgd3JvdGU6DQo+IFtZb3UgZG9uJ3Qgb2Z0ZW4g
Z2V0IGVtYWlsIGZyb20gbWVAYmVya29jLmNvbS4gTGVhcm4gd2h5IHRoaXMgaXMgaW1wb3J0YW50
IGF0IGh0dHBzOi8vYWthLm1zL0xlYXJuQWJvdXRTZW5kZXJJZGVudGlmaWNhdGlvbiBdDQo+IA0K
PiBCZXJuZCwgdGhhbmtzIGZvciBwdXNoaW5nIGJhY2suIFN0ZXBwaW5nIHRocm91Z2ggdGhpcyBh
Z2FpbnN0IHRoZSB0cmFjZToNCj4gDQo+IGZ1c2VfY29ubl9kZXN0cm95KCkgaW4gZnMvZnVzZS9p
bm9kZS5jIGNhbGxzIGZ1c2Vfd2FpdF9hYm9ydGVkKCkNCj4gYmV0d2VlbiBmdXNlX2Fib3J0X2Nv
bm4oKSBhbmQgdGhlIGV2ZW50dWFsIGZ1c2VfY29ubl9wdXQoKSAoZnJvbQ0KPiBmdXNlX3NiX2Rl
c3Ryb3kpLiBmdXNlX2Rldl9yZWxlYXNlKCkgaW4gZnMvZnVzZS9kZXYuYyBkb2VzIG5vdCB3YWl0
DQo+IGJldHdlZW4gaXRzIGZ1c2VfYWJvcnRfY29ubigpIGFuZCBmdXNlX2Nvbm5fcHV0KCkuIFRo
YXQgYXN5bW1ldHJ5IGlzDQo+IHRoZSByYWNlLg0KPiANCj4gT24gdG9wb2xvZ2llcyB3aGVyZSB0
aGUgbGFzdCBmdWQgcmVsZWFzZSBJUyB0aGUgbGFzdCBjb25uIHJlZg0KPiAobm8gc3VwZXJibG9j
ayBtb3VudCwgbm8gb3RoZXIgZnVkIG9wZW4g4oCUIGV4YWN0bHkgdGhlIFBvQyBzZXR1cCksDQo+
IGZ1c2VfY29ubl9wdXQoKSBkcm9wcyB0aGUgY291bnQgdG8gemVybywgY2FsbF9yY3Ugc2NoZWR1
bGVzDQo+IGRlbGF5ZWRfcmVsZWFzZSwgYW5kIGZ1c2VfdXJpbmdfZGVzdHJ1Y3Qga2ZyZWVzIHJp
bmcvcXVldWUvZW50X3JlbGVhc2VkDQo+IHNsYWJzLiBhc3luY190ZWFyZG93bl93b3JrLCBzY2hl
ZHVsZWQgYnkgZnVzZV91cmluZ19hc3luY19zdG9wX3F1ZXVlcw0KPiB2aWEgdGhlIHRlYXJkb3du
LWludGVydmFsIGRlbGF5ZWRfd29yaywgdGhlbiBydW5zIG9uIGZyZWVkIG1lbW9yeS4NCj4gDQo+
IFRoZSBLQVNBTiB0cmFjZSBhdCB0b3AtZmluZGluZy9rYXNhbi10cmFjZS50eHQgc2hvd3MgZXhh
Y3RseSB0aGF0DQo+IGludGVybGVhdmluZzoNCj4gDQo+ICAgZnJlZSBzaXRlOiBmdXNlX3VyaW5n
X2Rlc3RydWN0IOKGkCBkZWxheWVkX3JlbGVhc2Ug4oaQIHJjdV9jb3JlDQo+ICAgdXNlIHNpdGU6
ICBmdXNlX3VyaW5nX3RlYXJkb3duX2FsbF9xdWV1ZXMg4oaQIGFzeW5jX3RlYXJkb3duX3dvcmsN
Cj4gICAgICAgICAgICAgICh3b3JrcXVldWUpLCByZWFkaW5nIGVudC0+bGlzdC5uZXh0IGZyb20N
Cj4gICAgICAgICAgICAgIGttYWxsb2MtMTkyIGZyZWVkIGJ5IGRlc3RydWN0DQo+IA0KPiBZb3Vy
IGluLWZsaWdodCBjbWQgcmVmIGludmFyaWFudCBob2xkcyBvbiBib3RoIGZpeGVkIGFuZCBub24t
Zml4ZWQNCj4gcGF0aHMgKG5vbi1maXhlZCB2aWEgcGVyLWNtZCBpb19wdXRfZmlsZSBpbiBpb19m
cmVlX2JhdGNoX2xpc3QsIGZpeGVkDQo+IHZpYSB0aGUgaW9fdXJpbmcgZmlsZSB0YWJsZSBzbG90
IHBpbm5pbmcgc3RydWN0IGZpbGUg4oaSIGZ1ZCDihpIgZnVzZV9jb25uKS4NCj4gQnV0IG5laXRo
ZXIgY292ZXJzIHRoZSBnYXAgYmV0d2VlbiBmdXNlX2Fib3J0X2Nvbm4gKHdoaWNoIHNjaGVkdWxl
cw0KPiB0aGUgYXN5bmMgd29yayBhbmQgcmV0dXJucyBpbW1lZGlhdGVseSkgYW5kIHRoZSBSQ1Ug
Y2FsbGJhY2suIFRoZQ0KPiBQb0MgdG9wb2xvZ3kgcmVtb3ZlcyBldmVyeSBvdGhlciByZWYtaG9s
ZGVyLCBzbyB0aGF0IGdhcCBiZWNvbWVzIHRoZQ0KPiBsYXN0IGNvbm4gcmVmLg0KPiANCj4gVGhl
IHBhdGNoIHJlc3RvcmVzIHN5bW1ldHJ5IHdpdGggZnVzZV9jb25uX2Rlc3Ryb3kgYnkgd2FpdGlu
ZyBvbg0KPiByaW5nLT5xdWV1ZV9yZWZzID09IDAgKHZpYSBmdXNlX3dhaXRfYWJvcnRlZCDihpIg
ZnVzZV91cmluZ193YWl0X3N0b3BwZWRfcXVldWVzKQ0KPiBiZWZvcmUgdGhlIHB1dC4gVGhhdCBn
dWFyYW50ZWVzIGFzeW5jX3RlYXJkb3duX3dvcmsgaGFzIGZpbmlzaGVkDQo+IGJlZm9yZSBSQ1Ug
aXMgYXJtZWQuDQo+IA0KPiBUaGUgcmFjZSBpcyByZXByb2R1Y2libGUgd2l0aCBtZGVsYXktd2lk
ZW5pbmc7IHdpdGhvdXQgd2lkZW5pbmcgSSBzZWUNCj4gMCB0cmlwcyBpbiA1MCBpdGVyLCBidXQg
dGhlIHdpbmRvdyBpcyBpbiB0aGUgY29kZSBwYXRocy4NCg0KSSB0aGluayBJIHNlZSB3aGF0IHRo
ZSBhY3R1YWwgaXNzdWUgaXMsIHdlIG5lZWQgYW4gZmMgKG9yIGluIGxpbnV4LW5leHQNCnN0cnVj
dCBmdXNlX2NoYW4pIHJlZmVyZW5jZSBhcyBsb25nIGFzIGZ1c2VfdXJpbmdfYXN5bmNfc3RvcF9x
dWV1ZXMoKQ0KcnVucy4gUGF0Y2ggZm9sbG93cy4NCg0KDQpUaGFua3MsDQpCZXJuZA0K

