Return-Path: <io-uring+bounces-10407-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A4CC3C973
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 17:54:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 622E5188B64B
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 16:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8414F284665;
	Thu,  6 Nov 2025 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="jtnpNeHY"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59AC33BBBB;
	Thu,  6 Nov 2025 16:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448039; cv=fail; b=HUG2a5IiChIZtjJp9D61OBm/yVcDywPfVjas56YQuKoz73GP4q1ySZ1mUa0iwIKj0CsfUqv4tXLjjzaAq0vbf7lsLMJFhXDxM3H7JOmYk4P239XrZ+1Og2VwE+1WO4SO5LnRzuRUc3+szmvOn30Mp9zBtAQu1iNAaoUM+OvCyAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448039; c=relaxed/simple;
	bh=5inxYOcKzI7QB374drlHi5WpvGvHtTeOY00pgKilJjE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KoYhknqITWFEzQ5OTIYSLqfPp6KJNzbgcDoe5xOK9Ous0xO6hNvUd5vKGMcUtX3pEf7BXU+liklTXit2DZHUi72+vVLVZOL/NGd/Ex6t1jr8bxa8h0z7s3WKF2nZwZMbZnh6GceORp7VHm7fTNpH3P/1rppXwxQnG583Az0ZkSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=jtnpNeHY; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11020082.outbound.protection.outlook.com [52.101.46.82]) by mx-outbound23-123.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 06 Nov 2025 16:53:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kB7CaH3RdUnA+ESBb9yHYxZNElMRA9SEqVZs+hj+282terX7GB8C487DD8/k+LLQ4vPN1Im7N3xW6wwuNnSQoNygXo/UsiQGDdyfCP2DceolVtVKzaVnnl3HMvklH9FlXR7FhUONl05pvZnxw3l+PKLUNFg78nKq7QqZXFP57F5znUIOpKaj8QPKeNsRKggdfNZvRqK9H8kdLlaW299TvbG83CUgh/WtHSI62o4shApSA1M7j8EzjKhUYJOdY13rNIluEehGNrzephaWfA75mnpAbu23BSH8RErkI2zQzoFWWmvdX764mIWQfn0D7pHi1l3t1RTBlezsUCR98QolHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5inxYOcKzI7QB374drlHi5WpvGvHtTeOY00pgKilJjE=;
 b=b1EJzzQ4I8CpHWbZTuxA5rKP6FlPsDvcHRl8JydSj03ELzEQ7Umg+2BwyVSRThU13dykJFz4n8bw7wBTgb1X1Hjg5Y4+cYgNDWtACMSeNCK1NlJGcO2PI3dXcuIrTjgMuc7kckmoxRDO1gJJPO6DAPM+1UMVfnuS4G6zuN231n3KV/eLxLYpFei4TulLlZitSPFiNJ/pDlQO2aHZ3xwiqv4o75umgGFbRAJX/Ja6v/yXQ5pJd8DNBWufd9WEmZGqqEg6Qc+UZbhceNkzixB4OpgEwtTDKXKYCyUJ9TbzIsmV0Qe/TNv00lYcaOYEJRHIHhfAPV7eSMyY+FOqQT1EvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5inxYOcKzI7QB374drlHi5WpvGvHtTeOY00pgKilJjE=;
 b=jtnpNeHYcFTMwmLPSP9Dbi2uPUnxwVLbcW+uWFT7GOA92k8qRn6QMserpKXBIbMSboJuChaKZymnUfvnNrg1yNIF45EQt/C5U8dUHf+HXt3qdVNGFWx55AZCqiszwsAvra79KBMXVDKz0np4PlYdO4hSQ94NNsQu/TtnSJSPJNo=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by DS0PR19MB6549.namprd19.prod.outlook.com (2603:10b6:8:c5::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.12; Thu, 6 Nov 2025 16:53:40 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 16:53:39 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Joanne Koong <joannelkoong@gmail.com>, "miklos@szeredi.hu"
	<miklos@szeredi.hu>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "xiaobing.li@samsung.com"
	<xiaobing.li@samsung.com>, "csander@purestorage.com"
	<csander@purestorage.com>, "kernel-team@meta.com" <kernel-team@meta.com>
Subject: Re: [PATCH v2 7/8] fuse: refactor setting up copy state for payload
 copying
Thread-Topic: [PATCH v2 7/8] fuse: refactor setting up copy state for payload
 copying
Thread-Index: AQHcR5E3d8sTYH1RZUSkmIt9I4T7QbTl7KqA
Date: Thu, 6 Nov 2025 16:53:39 +0000
Message-ID: <0e77afcc-b9a7-46f6-8aad-9731dc840008@ddn.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-8-joannelkoong@gmail.com>
In-Reply-To: <20251027222808.2332692-8-joannelkoong@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|DS0PR19MB6549:EE_
x-ms-office365-filtering-correlation-id: e11b3a75-f3d3-4b47-07d1-08de1d550949
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|19092799006|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?OFQwYnA0UVlvSnlyMDdHMGdJdVZ0OTNwdnZXVlZJanBCZ0JmcUp2SVVHdTc1?=
 =?utf-8?B?SEowWFZKdm1GTU02bFFRZW45M2M0Vjd2RkdUbjdJbU5SazBhdXhINWxzaWxz?=
 =?utf-8?B?dWhzUVBnYUUxMlgrZURKOUVjQlhFS1dqZEhzMWVMSHN0SVIxTlhXeWRVVXE5?=
 =?utf-8?B?cnY4SGdVRVA2N2VRclpQa1VIRnJNYVBPd2VGZ28zRUZWQ1RlcTR4RW4zZ25U?=
 =?utf-8?B?bVUvbUNxK2c1Q3AzTE1RbTVNQU1wM3lmVHF1azZHR2dPeGIwcVpmUFhiVFlR?=
 =?utf-8?B?eS8yWWQ3dlFWSWhSNVVsckp0RGpmc2taSnNyWDhKTXJIczEva1EwQ2hBc3NV?=
 =?utf-8?B?WThnQXBEL0t2U1ZtSkVmUmVjQmx2N3lGclN5bEZPWWZ0cmViYTU0bGdheWQ4?=
 =?utf-8?B?Y0hLTXJaV0NVOG1RMGJMMDM1eXpmTWxHZVBIY2pLbndOOTNqM2VUN3FSeTJL?=
 =?utf-8?B?WVJMVW1uTlk0REk4aGxSSEplclhEbTFabDQ5d3pWY0ZRZ3M0TTRrbHhZblBJ?=
 =?utf-8?B?UUhLL1NwbmtqZCtFbFFuQlppNWpocXJRU0pOdytmSVJudjdHN0piZ2lJa3dO?=
 =?utf-8?B?TGFLV091L0JTb0ozZTVmQkZvQ2FSc1NIMnRwWTZtRmw5UDlxRXJyKys2dmpJ?=
 =?utf-8?B?U3FNT1l6QU5lZXNhWUJEa280SGxQMG9JZWo4OFhxU05pMzVRQUt3RzVTdFBT?=
 =?utf-8?B?elczdC9jWEV4VnRFZ0tNVTQ1VDk5V0FCOUszbW9XdUZJcXdacHdRVXFkTnVo?=
 =?utf-8?B?aVZPUlhET0tpc2NCVTRJK1ZsVWgzV0pTdllYcE12NUlUVEtMK2srNUttS2Mw?=
 =?utf-8?B?VFlBb00rWXF1ckNQY1VzQnhhMzc2TE1aWW9pWEl5MGg5RExFMlpFL3FhcFpp?=
 =?utf-8?B?L2ZUNGcwN1ZleFpuMEw3QXlxWWJ3Q3BnREEzNkloYzNYNURLWnA0cGpXZE1h?=
 =?utf-8?B?Vmk0WlBsdDFHSHlHS3VqU25QV0lYbXYxejdxaWhjY0hhdUtyNUN5dG9MMnI1?=
 =?utf-8?B?R1I1WVJSMVZURFdZZGhWUFNVSzlva3hTWUFEL05zY1JNZHRHQkxSQzRhSEly?=
 =?utf-8?B?TkE5VmVOL1lIOXpIR21sKy9lRVo0b3JhbjdEM29Bb2FINXpsZ20rMlltMHE0?=
 =?utf-8?B?eU5XUVAxeDJDN29MZ0NkQlQvSnlhaTc0c04xQiswRko4SjA0eGdmaVJiTklu?=
 =?utf-8?B?V0RPZTN4dWd5eGFJbnFVT0YvKzlkUlVldW9iU2IrOGhFa3c5WWVrOFRkQWl5?=
 =?utf-8?B?Z0x1bGM2UC9adC9ZOS94L0E1eHgrRGlhV21YTGVHaWlvRFVWUGZCOXo1QzNP?=
 =?utf-8?B?Sk1DelV6V3ZxcVd1Ylh5WjdqcEtkTnJ0Vk9zb2daYlVrVldHUlZOalNKS2pp?=
 =?utf-8?B?dFIvbWx4WHBoWTllMHpJUFNFWWxzM3dvaXRHbGl3KzdDbVhmdWRUaE9yL0V3?=
 =?utf-8?B?WUFmc3NXNDhmNmhuSGNFQTFJa1NVeGFEdldpQzdWNXZIbW9LYkFLVUtNNWFu?=
 =?utf-8?B?aElKT0RTN3BEakh1NklKVExCWnVoQVB2YTlWRDN1YS9SWHJPaEliaHN2ZkdZ?=
 =?utf-8?B?WUpTTkZmaTRpV3JCOUQ4U3RIaFdMdWpWYWloa1NQZG02b21BdG14aGFmQXp4?=
 =?utf-8?B?bUM4Mk1VcmxQWnovL0oxa3ZJWXdoR04rbnhEazR3YnhZQU1YaWRPMFY4RFlq?=
 =?utf-8?B?Y0N2R1NuTTB4VmNNYW5oVVg3bkRKWkxqZ3BxV2U0NDllNThYdWYzMDJnNXcw?=
 =?utf-8?B?RnZKVTBrN3YzWlI1UUJtRUhiL1RYRmhVU1dYbDhVelpUWW5tSEgyTlpkazQr?=
 =?utf-8?B?TWpVTklJamc4NU91NG5iM01QRUFRV3BaVU5oWTZ4QjE0ZW1rMXFmMTRRTTNp?=
 =?utf-8?B?dkdObVBvSG83cE9KNVVMMURaakFVblZFYmlXOEp0RHZDNDREWjU0SmU4WUtG?=
 =?utf-8?B?V0RDOE1IbWxLZEFTbWhvaHd3NEdpYUR5WWcwRmtQbHFCSmwwNjhyd1RhdkFn?=
 =?utf-8?B?NlhPVzhjOEpvemFOSkdZZGJPWjVpRFdoSm5wLzQrY0t5WXJsQ0NwbktFdWtC?=
 =?utf-8?Q?QeXwnb?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(19092799006)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T1crUnh3Rk5FTHNhZURDRSsrRGRRUkdEaXRqWUtURzVNSzRYS0Rpa1BrTVEx?=
 =?utf-8?B?MTlINVU2endPamRhaEpLMHBPMENEWjZ0MTNFRlNFa2laRSs4ajBTYVowMWxL?=
 =?utf-8?B?aGR4MWZsMzdvbVIwOXY4c2V5SUNrWTBYc296OFRkdzBQTXJpdjNaNThCd1hh?=
 =?utf-8?B?NExNRUZZUFZBQ0RTWE95OW4xVjFkemg4dzIxSHY5eitwS1I2Y1pKdEdqOWlj?=
 =?utf-8?B?SzgzQ1VzU3MyRm1uSUJidUtORzFxQitJdnl5ZmNIRHEwbEJVMC9sTS9XcEpi?=
 =?utf-8?B?d2xPT1VnZHFhSFZ6bTIzcmN6WDlGN3hORjZlLzRvclkxbXFWQW5URUovcmls?=
 =?utf-8?B?UUF1UjVzaDZzSG9DQkEzZHdWSGh3MkNLbEtmSXRXOVlUTUVVMnVsaVlTUUNy?=
 =?utf-8?B?TWIrSDVDcDVpMlAxL1F3RjVxci9yeXA4d0QvOXBkRG9sMGxocFZnSlNwT00v?=
 =?utf-8?B?R2JWY0J2Mi9aRXlKaVB6UGtaUnBaWTM5bFVEcG8vUXRGZFhxRG1BMGtEbzE1?=
 =?utf-8?B?MURqSUpQVWFnY0ZRL1UxR3RPUGJWMWNpS0dVWmcyYy9Sd0dTWGtUR05VSmlx?=
 =?utf-8?B?K2Q1VVEwWU9mdHBTazJvS1NDb29CaGJpc3pOZ1B3L3FBSTJGdHhkSTVDclA2?=
 =?utf-8?B?WEpvSUVpLzRxUjQxcko1b0c2YmNoSHlnVzNnaGkxdGVkeUhnVW5qcE92czV0?=
 =?utf-8?B?NEVqMGI3RFE3RkN0ZEhReFdYVHV0Ty9QQ1VjaTJDeVAvN1VpTzNSUW11S1JY?=
 =?utf-8?B?Vm9NQWZzMmFNZjIyNjVaZVpXaCtFWUt1S3B1djVGVkxpajFnWGpaekVmYXhT?=
 =?utf-8?B?U0g1bXExSWdjSnU5WWMzamVUK2I3SkJWYUxXcHRjNFVOUWJ3M042a1JySmNa?=
 =?utf-8?B?WVNkaDFpanl4UWJnL3lhR1NXV1dOYmh0ZFVxWHZuajhDRlJmRzFMMXk5Y1hY?=
 =?utf-8?B?alpPUHJJdGNZeEJLbDJhQ3VSWEJqSkVvWlhMTndneWtrWWtJcDB6bHA0dVA4?=
 =?utf-8?B?YVJvUjNjZWVGa1hVeExNZ1BUUHU3eEFlOXQra24vN0E3N2REWHVBcXJBbUdL?=
 =?utf-8?B?bmVocm5EMTk4ajQ3UzFabHRWbzNKT01kT0JLNDV1Y0RNLzY4VmN0eFNHako4?=
 =?utf-8?B?OGwrYlZmSXRmbStVTEg0ZjJHbE5IdHhNMWhuVnM2enZtUU5mRE1ZbndQRE1S?=
 =?utf-8?B?NjR4WmwvbzVDTENFSUZad2U0MTc2VlVOb3oyK0xqWXRVMWw2TlhzbkVXZVQ1?=
 =?utf-8?B?UEJqL2gxK1NFcG9CSExSWnZLTmdDU05XSUsyRlFFcEtrdTF1SmRkZG5sYVNj?=
 =?utf-8?B?QmdCbHhiYzhMTWhocUR6WGVpdFduVkYzRjJzM2I4MjJvS0p0OHBJMHdRa0pH?=
 =?utf-8?B?Q21BNlRTOXA5REN6b1hLRHZDWHpIeDY1a0NEYXRyYjdZQVJLUm9VUGN0bW9E?=
 =?utf-8?B?UHdJNWNXOXBRSGtvSzZHVGJKT3hGeVZUcWpySzRGMmpIZjMxaXFmc0hGUjdK?=
 =?utf-8?B?VkdKdUVVQ0U3RGhRQnVBT3FVMkkwdkhhTE05TFFhTWU3QmhjQk8zNnJnZ1la?=
 =?utf-8?B?eHlTR1VTczdvMFlFNXJpb1JKMmJrR0NLc0g5ekhZejJab09JUFNZa3RNMDlH?=
 =?utf-8?B?SW9BMmpqVTZuWTJ1WU1RY3phdXNacUE3dWZ1dWZFMGdYY3JQRkJuSGRxSXJU?=
 =?utf-8?B?WFVRanRLKzBGYjhIZldvbnB2Y2FaWHNCSFYzalArSnhRZ0l1WWd5aUJFbSt5?=
 =?utf-8?B?eU5jSjZWMGtWQzZmNTJjQTh3SXByMTVtT2E2ZDNKM2RmSUxCU016Y2hqVnRI?=
 =?utf-8?B?elc1RkRKRXFkbHVnQ28yejVMTUk4SG9OWDYyOUROUnpwamFVdmRuT1NwMnpC?=
 =?utf-8?B?aWo5MEVRVk5RY0hpVm1rZlo4emFBS1VlTm5GM0Fwa1ZhazhVbkVvK3Izb3g5?=
 =?utf-8?B?ZU1BNHdMamtiSzZWeUg3QXU4dkNlakRTbWRhQmJqVThxSy94bjVlRDkyN2hn?=
 =?utf-8?B?aC8yWWJOeWhoWHg4cEUvQUlPVjVMZFQwbzczOFBXZHRYN3lHVVhGWVlKajBZ?=
 =?utf-8?B?UzNXTFI3dDR2N045d0Y0N3JLcEh2eGpyZXkzbzQxU2dPK3ZOREhlN29Db3dq?=
 =?utf-8?B?OFo5TFJZWmtPTWR2SlVPR2NVbEppYXlMeGdLa0c1UkthZXhPdE5EbXJnd2U1?=
 =?utf-8?Q?Ddiv3bhFL7Fh2DW/qE6OEco=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <933B1C039ED9F543B4F7E55C4B49A20C@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+qEV5/jSYqpilgLJJfv/ZaTUNRHBE0snHkMyNL+ffPq/DKAQ1BXyCGs58hjhk+6j7RgzsHYKOkUUKcm4RD9yZ6T/ijofxAiKP0yNuRkYxRNksCXodr431Xk49IVSpNVao6Gf5DuQpPxm2xPV7wGo9wH6JCtrs0W4Pnk7QprRJoytThgj2eedDNLMXkRLo3nn9vJtLFdjDAqQv10AQLs53B7ref6xDMe1uENQzOW6J/+ZIjzvUNPek2gYX0Fo2Cm3+a8ZFzGDgL8cKoe8DNrWBXpYqUEqKz6pcNPfoCGkQUqup2rgutSEbErsP4reQ5CCySnsXFhMFNn8D3nCgHQBv+RCbK1Es/jr6NsxP/oJwt35LxJHRHxbva592Ddk5y8JW0pP+ML/FlAbQo3Csetl6MPZAB+BHc02NSDq+ilnyKW3DLrm+LmJG4gCHxx82NCHhF6t8olWZdcAw7g89CuVlTfakCElpYMGK+uYr8+H3eixpHI73lSxx0cXRYpxcrGCpq6+WTPck9l0LpB1W2krZ6EZ2FbzUMxMoGBMPztzQqXQ6qownctE6lDT5q6ehl87hL66OWJiNRalXVINrv4N9/bRq8UBsMIcK2vHXyur42hgQBXgrlo7fLmZB5XYfZ/gzIKbT+ZmwvZrllctEapPpQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e11b3a75-f3d3-4b47-07d1-08de1d550949
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2025 16:53:39.7835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KuJFDMySX88Cf+9eBQ3qF75VzCaEN3MlXtvzzHpcJcdBPE0QjB0e4M55KmkDIoEm0PYeqqRd1Fw3C747Jnv+Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR19MB6549
X-BESS-ID: 1762448021-106011-7695-17112-1
X-BESS-VER: 2019.1_20251103.1605
X-BESS-Apparent-Source-IP: 52.101.46.82
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkamRiZAVgZQ0MjSxNjYOC05JT
	HNzMIsxTw5JdUoMTUl0cIkKSkFyFCqjQUAPviIbEEAAAA=
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268754 [from 
	cloudscan13-109.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTAvMjcvMjUgMjM6MjgsIEpvYW5uZSBLb29uZyB3cm90ZToNCj4gQWRkIGEgbmV3IGhlbHBl
ciBmdW5jdGlvbiBzZXR1cF9mdXNlX2NvcHlfc3RhdGUoKSB0byBjb250YWluIHRoZSBsb2dpYw0K
PiBmb3Igc2V0dGluZyB1cCB0aGUgY29weSBzdGF0ZSBmb3IgcGF5bG9hZCBjb3B5aW5nLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogSm9hbm5lIEtvb25nIDxqb2FubmVsa29vbmdAZ21haWwuY29tPg0K
PiAtLS0NCj4gIGZzL2Z1c2UvZGV2X3VyaW5nLmMgfCAzOSArKysrKysrKysrKysrKysrKysrKysr
KysrLS0tLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAx
NCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9mdXNlL2Rldl91cmluZy5jIGIv
ZnMvZnVzZS9kZXZfdXJpbmcuYw0KPiBpbmRleCBjODE0YjU3MTQ5NGYuLmM2YjIyYjE0YjM1NCAx
MDA2NDQNCj4gLS0tIGEvZnMvZnVzZS9kZXZfdXJpbmcuYw0KPiArKysgYi9mcy9mdXNlL2Rldl91
cmluZy5jDQo+IEBAIC02MzAsNiArNjMwLDI4IEBAIHN0YXRpYyBpbnQgY29weV9oZWFkZXJfZnJv
bV9yaW5nKHN0cnVjdCBmdXNlX3JpbmdfZW50ICplbnQsDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+
ICANCj4gK3N0YXRpYyBpbnQgc2V0dXBfZnVzZV9jb3B5X3N0YXRlKHN0cnVjdCBmdXNlX3Jpbmcg
KnJpbmcsIHN0cnVjdCBmdXNlX3JlcSAqcmVxLA0KPiArCQkJCSBzdHJ1Y3QgZnVzZV9yaW5nX2Vu
dCogZW50LCBpbnQgcncsDQo+ICsJCQkJIHN0cnVjdCBpb3ZfaXRlciAqaXRlciwNCj4gKwkJCQkg
c3RydWN0IGZ1c2VfY29weV9zdGF0ZSAqY3MpDQoNCk1heWJlICdzdHJ1Y3QgZnVzZV9jb3B5X3N0
YXRlICpjcycgYXMgZmlyc3QgYXJndW1lbnQ/IEp1c3QgYSBzdWdnZXN0aW9uIGFuZCB3b3VsZA0K
Z29vZCBpZiBpdCB3b3VsZG4ndCBlbmQgdXAgaW4gdGhlIG1pZGRsZSB3aGVuIHRoZXJlIGFyZSBt
b3JlIGFyZ3VtZW50cyBhZGRlZCBhdCBzb21lDQpwb2ludC4NCg0KPiArew0KPiArCWludCBlcnI7
DQo+ICsNCj4gKwllcnIgPSBpbXBvcnRfdWJ1ZihydywgZW50LT51c2VyX3BheWxvYWQsIHJpbmct
Pm1heF9wYXlsb2FkX3N6LA0KPiArCQkJICBpdGVyKTsNCj4gKwlpZiAoZXJyKSB7DQo+ICsJCXBy
X2luZm9fcmF0ZWxpbWl0ZWQoImZ1c2U6IEltcG9ydCBvZiB1c2VyIGJ1ZmZlciBmYWlsZWRcbiIp
Ow0KPiArCQlyZXR1cm4gZXJyOw0KPiArCX0NCj4gKw0KPiArCWZ1c2VfY29weV9pbml0KGNzLCBy
dyA9PSBJVEVSX0RFU1QsIGl0ZXIpOw0KPiArDQo+ICsJY3MtPmlzX3VyaW5nID0gdHJ1ZTsNCj4g
Kwljcy0+cmVxID0gcmVxOw0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gIHN0YXRp
YyBpbnQgZnVzZV91cmluZ19jb3B5X2Zyb21fcmluZyhzdHJ1Y3QgZnVzZV9yaW5nICpyaW5nLA0K
PiAgCQkJCSAgICAgc3RydWN0IGZ1c2VfcmVxICpyZXEsDQo+ICAJCQkJICAgICBzdHJ1Y3QgZnVz
ZV9yaW5nX2VudCAqZW50KQ0KPiBAQCAtNjQ1LDE1ICs2NjcsMTAgQEAgc3RhdGljIGludCBmdXNl
X3VyaW5nX2NvcHlfZnJvbV9yaW5nKHN0cnVjdCBmdXNlX3JpbmcgKnJpbmcsDQo+ICAJaWYgKGVy
cikNCj4gIAkJcmV0dXJuIGVycjsNCj4gIA0KPiAtCWVyciA9IGltcG9ydF91YnVmKElURVJfU09V
UkNFLCBlbnQtPnVzZXJfcGF5bG9hZCwgcmluZy0+bWF4X3BheWxvYWRfc3osDQo+IC0JCQkgICZp
dGVyKTsNCj4gKwllcnIgPSBzZXR1cF9mdXNlX2NvcHlfc3RhdGUocmluZywgcmVxLCBlbnQsIElU
RVJfU09VUkNFLCAmaXRlciwgJmNzKTsNCj4gIAlpZiAoZXJyKQ0KPiAgCQlyZXR1cm4gZXJyOw0K
PiAgDQo+IC0JZnVzZV9jb3B5X2luaXQoJmNzLCBmYWxzZSwgJml0ZXIpOw0KPiAtCWNzLmlzX3Vy
aW5nID0gdHJ1ZTsNCj4gLQljcy5yZXEgPSByZXE7DQo+IC0NCj4gIAlyZXR1cm4gZnVzZV9jb3B5
X291dF9hcmdzKCZjcywgYXJncywgcmluZ19pbl9vdXQucGF5bG9hZF9zeik7DQo+ICB9DQo+ICAN
Cj4gQEAgLTY3NCwxNSArNjkxLDkgQEAgc3RhdGljIGludCBmdXNlX3VyaW5nX2FyZ3NfdG9fcmlu
ZyhzdHJ1Y3QgZnVzZV9yaW5nICpyaW5nLCBzdHJ1Y3QgZnVzZV9yZXEgKnJlcSwNCj4gIAkJLmNv
bW1pdF9pZCA9IHJlcS0+aW4uaC51bmlxdWUsDQo+ICAJfTsNCj4gIA0KPiAtCWVyciA9IGltcG9y
dF91YnVmKElURVJfREVTVCwgZW50LT51c2VyX3BheWxvYWQsIHJpbmctPm1heF9wYXlsb2FkX3N6
LCAmaXRlcik7DQo+IC0JaWYgKGVycikgew0KPiAtCQlwcl9pbmZvX3JhdGVsaW1pdGVkKCJmdXNl
OiBJbXBvcnQgb2YgdXNlciBidWZmZXIgZmFpbGVkXG4iKTsNCj4gKwllcnIgPSBzZXR1cF9mdXNl
X2NvcHlfc3RhdGUocmluZywgcmVxLCBlbnQsIElURVJfREVTVCwgJml0ZXIsICZjcyk7DQo+ICsJ
aWYgKGVycikNCj4gIAkJcmV0dXJuIGVycjsNCj4gLQl9DQo+IC0NCj4gLQlmdXNlX2NvcHlfaW5p
dCgmY3MsIHRydWUsICZpdGVyKTsNCj4gLQljcy5pc191cmluZyA9IHRydWU7DQo+IC0JY3MucmVx
ID0gcmVxOw0KPiAgDQo+ICAJaWYgKG51bV9hcmdzID4gMCkgew0KPiAgCQkvKg0KDQoNClJldmll
d2VkLWJ5OiBCZXJuZCBTY2h1YmVydCA8YnNjaHViZXJ0QGRkbi5jb20+DQo=

