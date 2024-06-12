Return-Path: <io-uring+bounces-2187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E389055F4
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 16:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C0D6B23B2C
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 14:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2AC317FADE;
	Wed, 12 Jun 2024 14:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="sLfUixPq"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED7117E90D;
	Wed, 12 Jun 2024 14:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718204229; cv=fail; b=mWUKnmhAC2cZIXGTkm4/IDXsruOIOBZlK3dkWVusbSfBJXCpdqBnw+PegXGjUTYIzSD70mmwTkkILjyflDj9FakoKyrQFEQxAWRW4/FQ60jhSs91sbPy0hA7qAtFwRpEL9PQBJ8AzLtiCKM38S8vPVoOAYAy75H8NgJyAUlVazM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718204229; c=relaxed/simple;
	bh=q2KZoOWmYccNTK33EQEVZL3jhkztBjJCmZeTH3S5U0o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PECL2pkV5maUCfwjMwNvviKr5L4DMedhRxsG3AuxalmxVzJZWyK8UNuP0Sbr9sKXrksHQ1jfIzKkA4lwgckeDkVgZyt5n/PT69iTsI38RQo+PdgX1MgGy82kuzEKat9zoLly3sSiAfd/eeij42ogSPfw8eL3sdYBnBS1Vi7ieys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=sLfUixPq; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40]) by mx-outbound42-112.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 12 Jun 2024 14:56:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcqSw5AeWor+R1qgJienYx/mnh7r0nJBiSByVYhbr5Ji6mY9upItzA3qgbu4nLX/i8qg4Pbn7lNEF6ed9VQsS4yye3N1HiuIGLiyHqklSSx4ZHxAPI1QoLGC1NMqqkBBLULbPZle5gMDm5T93R0FLpTC3HiQUepttaXTQOt5NNesVTYmHMLtH5baZRCYBN0eb4ams2KJbm65xoqRnX+zQJWqfJivGrEp6nWIH0G643W4B4V+BIKfpOH27sO0LRDGOWhqG/WMMkbq99NUoir4A0HPfqsz6KLinSTWa6G0swcVV9yab1WEvFrx1NKySVDDvusktpp0VqfT7WRv7JLLlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2KZoOWmYccNTK33EQEVZL3jhkztBjJCmZeTH3S5U0o=;
 b=N4FuOhkX1K/y7KhfieMMvPVcEOjXHgQHH73y42sihNH6mjWlEaGzMCvSg0gJCvDmkDYQ12O/Ifh8EBH1cuAQKcVi4CBSeE0f1u1XL1i5HfFXmL2AB36si4M6Wj3I63PnfB4ljCfEf8lod0ykZVRU1rFDvTOHQk1zMzOEJ8Qi+BZt9gvnj4nGw4vHBbuvKY5OywCq3zo9+INUIH1lImWC3nO3w04uC6rFeJ1W1vLWkbm8Ri7yia3hnE8Eah1b9rxZmbb3qGbq50ObZNIl5vfbIFTA+u/aFExH0UD+PtCSRamtNKdAfI9fIlsw32EPLxOOXUOAsWGVbrAC798qZyU7og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2KZoOWmYccNTK33EQEVZL3jhkztBjJCmZeTH3S5U0o=;
 b=sLfUixPqy4HuN/1FvJybn0pw1VY+ckMPoZ5E15UMywFf1phQe59GbftXAM+UOqarqDLSYK6wC3e7GTmEMycmbRAr38IwvZT5+YgxMwpbY0k3rGC0BB3Us53h8ShuQzL2bP0LJcyRCLuG7HuwNqGRX0bechKfW4TrWg7M3gs7QgY=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by DM4PR19MB7286.namprd19.prod.outlook.com (2603:10b6:8:109::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Wed, 12 Jun
 2024 14:56:41 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%3]) with mapi id 15.20.7677.019; Wed, 12 Jun 2024
 14:56:40 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Bernd Schubert <bernd.schubert@fastmail.fm>, Amir Goldstein
	<amir73il@gmail.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Kent Overstreet
	<kent.overstreet@linux.dev>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Thread-Topic: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Thread-Index:
 AQHasfIoshMbsaqF30mIAtaLNshpxrHCTJsAgAAjJYCAAFZxAIAAIfsAgADrYACAAGKcAIAACccAgAANowA=
Date: Wed, 12 Jun 2024 14:56:40 +0000
Message-ID: <3b74f850-c74c-49d0-be63-a806119cbfbd@ddn.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <CAJfpegsq06UZSPCDB=0Q3OPoH+c3is4A_d2oFven3Ebou8XPOw@mail.gmail.com>
 <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
 <CAJfpeguMmTXJPzdnxe87hSBPO_Y8s33eCc_H5fEaznZYC-D8HA@mail.gmail.com>
In-Reply-To:
 <CAJfpeguMmTXJPzdnxe87hSBPO_Y8s33eCc_H5fEaznZYC-D8HA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|DM4PR19MB7286:EE_
x-ms-office365-filtering-correlation-id: 485160d1-3547-408c-e825-08dc8aefde03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230032|1800799016|376006|7416006|366008|38070700010;
x-microsoft-antispam-message-info:
 =?utf-8?B?dkR5bGl3dGRxU1YvMGpQaGxqSkpUbW5QN3Z5bEdrOVlCbk1UV0xibklTalZJ?=
 =?utf-8?B?aURBNGtZbWxuUVdkdVlqamFDam92cVEzbUNHRHZKK0ErdEhoZGxuR01VeWI3?=
 =?utf-8?B?bEJYVDBIdzJMUDY5d0pVUmFyUVpSUmZQTWRFUG5nSnZ3TklXL1RkR0tJZVVt?=
 =?utf-8?B?c0VaMlFxNXQvSm5zT3p2VWFBVUU0ZVdkN0dPVDd4R1h5VHVlNDJJcGd3K3N2?=
 =?utf-8?B?Qkp4cTZJaHlPa2ZaUHZXaE9zZE1lakpaNXJYTHNpdTFrMTE1TW1sS1l4VGJ3?=
 =?utf-8?B?dGJHMkVyU1h3OTJCL0FBaXBPWDBKNE5xVytHMWlLNkNncmxNeTJNU1lIWGRD?=
 =?utf-8?B?ejloVGFRSEx5VUtyUEhpVzBucitIM2l0TEVySEtnaFlFRkFlWkZzSnE1M1pt?=
 =?utf-8?B?dC9VSElZK01ZT1VqZkQ3cU55T0tJWVd3T1hSSFNjSnJZZjRpTGIwNVhqRHpp?=
 =?utf-8?B?RUdGTnIvOHdjbVpWZEhQajJwL1ZUcmNVeVE1d0JQTDBEd3Z2UkcwMkN4ckgr?=
 =?utf-8?B?UGRUcVVxL3AwWlg0OTJoMWkwa3k1VzJDYVhyRWZUNStRUTA5RVFlRGJPZUZB?=
 =?utf-8?B?VkxCTkJjckhLSEU5cEdpN2RlU2RXdWJLSzRoVnIyblhHdDV2RVdTSWhFSXdz?=
 =?utf-8?B?UjhWNVVvRU1HR1I1WWdtdnFBbUxBcWczVVJ0cjVJMUlhNmVzd04rT3ZuR2M1?=
 =?utf-8?B?ZklKZ05PNEQyK044RDRUOG5QbkpjUGpaU3JmelU0WlplQVRPd1k2N1c5ZGlk?=
 =?utf-8?B?T0dtQnI4bFNQZkxubkIrb3pBNzJHUmpzNmduUnRCSFBSKzZwRkFsNDBNYlRY?=
 =?utf-8?B?WWMydm5QQ3NsNy9XNnIvZmlzYnNkcVIwQkNkOUhWNW9ld0V5M1BzRGZnb1Fn?=
 =?utf-8?B?ZkVhelY4QjlqU1ovcnpMNkpBOFlOL1ZhRlBuNnpJMmdHSCtDd01HdnVtbXpz?=
 =?utf-8?B?YUpyYS9mTEIzMVBKbjBqWU9rZks1dnlETGZ6ejN0L0pmMzh0SGdCdmNXdzh4?=
 =?utf-8?B?d0RnL1JKMHdiL3VZVitVOFJZU3FsZGhndzNlQ3Z6NHg0M1cwZDVyOE1RUFRE?=
 =?utf-8?B?QmhDcUNRem5LVFAyeDcxS2FjbU03YVlLYXZaM1hCclhUNGhvVTFMbHhIdlZz?=
 =?utf-8?B?eSsxNW4yZlJ5NVY1R1pRek1aN3BiRU52a2ZLekRCaTNZd01mb2YyYUViSCtw?=
 =?utf-8?B?NWYxU1kxU1BKdnpjY0Z3Q2ZQYURPOTdkMmxoUnJsSHJTZ0hQcjRmR3JvY001?=
 =?utf-8?B?Y1QzQ0haRDBsRHFweGlkMWwxUHdtVXZERk50RnZtaWg5dVdpUGVOV3NJVTgy?=
 =?utf-8?B?bG9jdXhFcmpmcUR6SWgzejI1THhGMzNka3JSd2o5NCtZL2s5Sms1WGQ1UTJN?=
 =?utf-8?B?Z2phU2ttWUJyMVFtSWhNNG9UU3lRN3hIOERaTUxkUUxXd0M4ZnN3eU1Udzl6?=
 =?utf-8?B?OFhlUXZmeUdQalVmSEFmWm9nbkJ1UjZ2YXlqcnVXbUtBNVo5TS9RNDZ6REVE?=
 =?utf-8?B?OXJZUzU2Uy9BTDQ1ZGllRVVSYkhEeFVXTSs0RitDRlNrazZpMXExRDBmbkNO?=
 =?utf-8?B?ZUpVaXdXOXo2Y0RaRFpCLzhOL05uRVBxOXVzTkd2SEJEUHVtaWdWaG9idjZo?=
 =?utf-8?B?U2NRYkNsN0VpdVUrcFVUdmdSNEphV00xRnR2QTRXUlBwMFhBTEs2OFVrdUwy?=
 =?utf-8?B?Vm5SUjlhenNoQmoyeVJyV0xPTkZ1bmh5TjNpaVFUZ010cm13UjIrL21QbkVs?=
 =?utf-8?B?enRFbVZMN1JaN2IzRkhnWEI0WDVlWk5iT3VaQUFiS1ZJUEVuRDNqUjBxcHpX?=
 =?utf-8?Q?aRTJakEgO57Q83WSMs9o27pGCA6OurXOAmoF8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(1800799016)(376006)(7416006)(366008)(38070700010);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZGpCa2FHYk5xQy9iNDQ3em54dkpMdk01QVdJdUxzSlpsaE5hNm9kY2E2aElv?=
 =?utf-8?B?dXhqTGFuc1g0QkdpNEdsUG9OaTNIeVZZaGh4NmpyVTZ4eUtsVGZzL0FBVFVn?=
 =?utf-8?B?ZmRZNEowZzBEN0o1MHBXdlg1VnUzU2hsVzRuUHcyN1BqdDA0eXp6K0F6N0Zh?=
 =?utf-8?B?VU5tWk5wUk15UzV4NUxORGpwVTk4Z2xSQmZaN1p0cXJMUGY0TGVHbm9IOGQz?=
 =?utf-8?B?Zzg5UjRwSk95bGdkR3JYTHpjQ3ZWamFiNDRieHlWc0J4YS8zazVRNEVvb0Jy?=
 =?utf-8?B?d216NFBINFhENS8wbzIwaVlKVnBXM0V4Q2o3NjYwZENjNlRqdDV6bnZtN1pD?=
 =?utf-8?B?Wmc3YzNpMzRSNDE0MEcvZ1o3VisvZ3Q3NjcwTWdXcklnVXpkRnZ2N2wwVEZY?=
 =?utf-8?B?S1hPZUorT3FMODRNUmRGL3IxeEgxUkNpUWdSRXRKN0hlRStoN2EyMVZNT2t3?=
 =?utf-8?B?cGFNR2lsblphN2ZRUm5xZ1BOTld0QkNONCtMOCtwZ0FnbklkZ2dTQUtaWm9Z?=
 =?utf-8?B?TkQ3dy84SXFad1dXbkN5cTh4UHNkYTUwRXBsZTJNUGZrdmloRWJtNUk1UUtZ?=
 =?utf-8?B?aCtPV1hJby9sTk5sTnNaSEYyRk5PRGJDNTlMVStCS3A2MU1vdEt4WEFZS2FB?=
 =?utf-8?B?Ti9SV04xK0JQOGJ5S3l2b3FrSC93TFp1b1NHNGs4Z2xFMURJN0QzbGlzUWkz?=
 =?utf-8?B?MnFsd0xsMGovekZlWkp1OXovZXpGTW5tNm1laGNlK2NQLzhzQXhhVENUS0Nr?=
 =?utf-8?B?Tml1L1lPdlRBOGNTRldLVzRmUEZQS1ZueGNnT05tNVRCZHVGbndPT2lybFVa?=
 =?utf-8?B?TXFwWlgwd2tKTlBqY2dlV3lvNFY4V0l3dnovQzFkWFp0RGxpQ2VPY2xyRUZS?=
 =?utf-8?B?TjRlcllKT1BMK0FpRFJ3MjMrMm8rOUlxNGREOFozTlBzY0VSUTZJcG5jeEtL?=
 =?utf-8?B?bzFTazlWTFpFSFNqWmxMb1hyRFVuWWxuMkFOaThzVklaMU12ZkJQYjd5dkR2?=
 =?utf-8?B?RTh4ODdlTlQyT1drUTJxSmwrTEFGNjVpVk9vNzVvRHZLdk1Nb1RPeTJ2UzB0?=
 =?utf-8?B?clA3ZHFGSVJzRXEyN2xRL2lNSmN2cUNOaXk2cG9iTHZZZm9sS2VtY3hlVFZF?=
 =?utf-8?B?Uys2TXVTQTZWMnYrOTVNY1c4YmY4bWVtVm5aYjdFbEZQRSttaUlDcktFS3RC?=
 =?utf-8?B?Qi9TVy9OVVpiQ3BpWUZDdUhmYTBwaGlKMnBkc2I5RVVFYjNKRjYvVk8rOTBp?=
 =?utf-8?B?b3UzZUdCTW4xZjUyd0lBNldrbVJBVHZyRkR4YkdsMWFRUWNuTmxwc1NGSjF4?=
 =?utf-8?B?UjVZVEtBT2t2WmxvZ2dCYTA3YzFmcVdxSVBIVTdHclYxQzdmRlFxZkNWTU1T?=
 =?utf-8?B?dnp2VnZxdmFEMHNIcWF6aVRCRmd6WHdVbGVIdHVwK0JocXR5TmJXcXE5N1N0?=
 =?utf-8?B?MWtsZS8vZVN4c0h2c1BYbSs2d0hsb29QdkN3MnVDQUxrZUxoQmd1YW54dDhy?=
 =?utf-8?B?bzQxeE9Fa3ltcEZIYU9jcUkvQ3U2Z2xJaVN3UUdWeGMvQzdUMTBnWHdlNEhR?=
 =?utf-8?B?aFc0ZlU0RUdsSmdGNWVFR0hCaFFsSktwcTZHbHdkUzdJWHkyNVgrdHpYczk3?=
 =?utf-8?B?R0xPaEV5d0U5U1E4cnhoMkhpZTBSL1FRbFgxZzhyVHRlemQ3SVBFa29mV0dI?=
 =?utf-8?B?bE9TWldTZlVoUEZNZGhac05KbTY0ZTJQb25RTFFVNkQzejM3S3FpamRVQ3Mx?=
 =?utf-8?B?aXBTdk9PZHZnL2tiU2UwV2ZXbUorWDdEOC94ZGFQMjZJVkxDRUJ5RjN5cUp0?=
 =?utf-8?B?Y0NXTnhzRG9iSGg2MUdmdGR1dEc5VTB5ZUIvYXRUUDV5dlpZVEdCWnVMSXE4?=
 =?utf-8?B?RDd4UHJta2E2OEYvdVZSQkR3OUk1M2VqYm1GMG4xM0N3VWZvcDR2M1c1WnhO?=
 =?utf-8?B?WTlTajR1SVZ3M0JWWklmZXpZVVk1eU9EakViMkJCZUdsWlhHZlFiaHJkcUh4?=
 =?utf-8?B?QjNVYXk5eVFYdkVYK1lyRVY1WlM2Z0FyZ0dCVThzVkViS2dHUEYwZ0hNWkpr?=
 =?utf-8?B?K3FaazVXSnphaVNyZ2dZWVk4MWJkNTN5cU9HVk1LNFpaTmx2K0JGWDJzMmw3?=
 =?utf-8?Q?nLRk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38BFF5182DA08E4FB96377E21391F7AF@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VxOOlix0P0yUFUubhBO5oJyar//hulbCEgmUyRneSmuzc0CtZ2hk8ayz0Mr0MSVyVARrOUsa+WaP3PwVrmixNsZnPqlwUYsQXyp8c5jbF2oDtNkjYhv83y4Q0BWD6byLKPpIKY6GqGed4APiea9Lwagyr84XDIV9Ea1PVS2ScYTPmja+QKa0Sy+nkwvuaq/kT/MaAvsKDzDEKR5+kuiVg30thFlYl6MqTDGIAiq4ni8hmdwDzASa3vgzUG/cw3AYWSYUiBIWtD/XhpgdlGOs400JBKuJ2lef+tViYkdnO4zLKw6gcRkDeN5ikNkMKDSI79lE5JkCNiioZXuE1WG9AhIf8tULf+/HgUan+S+7aLjI1T5bHhVi5CKd1zjDDclAYcCK/txGcz1f/aIX2XPVAQuGqP5RrE1+/rCHDw2qU8HZSiu45lpeDnpwQxkljROwL8TGdOB753VGasFbjKKJPf6Lh97D88jS5BGiujQcdb7lGmIAMUxuabPhM0FACdxQWqchiFUFm8vQBK5f29jZNyjAdFjl09aq/VA2pNb6d8bO38GpLL941sOBbzQoZxeBQU7QSSev/9g64h2GtcNsbZSexpmpiaxn2/pZCYdHxKJ9t3iUZifq/qqGHghZgXUTLy/ZBJ304ZRNA+ofrAjXeA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485160d1-3547-408c-e825-08dc8aefde03
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2024 14:56:40.6324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KVlUbeJtbVtqsstlryLu5xXFXvqoSPvWvS/myvY9fGV2J3IJr5K12sguQQbiIcAQfub648jXzGbysRqmj91Hbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR19MB7286
X-BESS-ID: 1718204202-110864-12753-10427-1
X-BESS-VER: 2019.1_20240605.1602
X-BESS-Apparent-Source-IP: 104.47.57.40
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkZmliZAVgZQ0MTU1MLCyCzZ2N
	TQMsnA0CTN2CjZJNEkxcjEMNXC0sxAqTYWAICxrf5BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.256904 [from 
	cloudscan12-15.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gNi8xMi8yNCAxNjowNywgTWlrbG9zIFN6ZXJlZGkgd3JvdGU6DQo+IE9uIFdlZCwgMTIgSnVu
IDIwMjQgYXQgMTU6MzMsIEJlcm5kIFNjaHViZXJ0IDxic2NodWJlcnRAZGRuLmNvbT4gd3JvdGU6
DQo+IA0KPj4gSSBkaWRuJ3QgZG8gdGhhdCB5ZXQsIGFzIHdlIGFyZSBnb2luZyB0byB1c2UgdGhl
IHJpbmcgYnVmZmVyIGZvciByZXF1ZXN0cywNCj4+IGkuZS4gdGhlIHJpbmcgYnVmZmVyIGltbWVk
aWF0ZWx5IGdldHMgYWxsIHRoZSBkYXRhIGZyb20gbmV0d29yaywgdGhlcmUgaXMNCj4+IG5vIGNv
cHkuIEV2ZW4gaWYgdGhlIHJpbmcgYnVmZmVyIHdvdWxkIGdldCBkYXRhIGZyb20gbG9jYWwgZGlz
ayAtIHRoZXJlDQo+PiBpcyBubyBuZWVkIHRvIHVzZSBhIHNlcGFyYXRlIGFwcGxpY2F0aW9uIGJ1
ZmZlciBhbnltb3JlLiBBbmQgd2l0aCB0aGF0DQo+PiB0aGVyZSBpcyBqdXN0IG5vIGV4dHJhIGNv
cHkNCj4gDQo+IExldCdzIGp1c3QgdGFja2xlIHRoaXMgc2hhcmVkIHJlcXVlc3QgYnVmZmVyLCBh
cyBpdCBzZWVtcyB0byBiZSBhDQo+IGNlbnRyYWwgcGFydCBvZiB5b3VyIGRlc2lnbi4NCj4gDQo+
IFlvdSBzYXkgdGhlIHNoYXJlZCBidWZmZXIgaXMgdXNlZCB0byBpbW1lZGlhdGVseSBnZXQgdGhl
IGRhdGEgZnJvbSB0aGUNCj4gbmV0d29yayAob3IgdmFyaW91cyBvdGhlciBzb3VyY2VzKSwgd2hp
Y2ggaXMgY29tcGxldGVseSB2aWFibGUuDQo+IA0KPiBBbmQgdGhlbiB0aGUga2VybmVsIHdpbGwg
ZG8gdGhlIGNvcHkgZnJvbSB0aGUgc2hhcmVkIGJ1ZmZlci4gIFNpbmdsZSBjb3B5LCBmaW5lLg0K
PiANCj4gQnV0IGlmIHRoZSBidWZmZXIgd2Fzbid0IHNoYXJlZD8gIFdoYXQgd291bGQgYmUgdGhl
IGRpZmZlcmVuY2U/DQo+IFNpbmdsZSBjb3B5IGFsc28uDQo+IA0KPiBXaHkgaXMgdGhlIHNoYXJl
ZCBidWZmZXIgYmV0dGVyPyAgSSBtZWFuIGl0IG1heSBldmVuIGJlIHdvcnNlIGR1ZSB0bw0KPiBj
YWNoZSBhbGlhc2luZyBpc3N1ZXMgb24gY2VydGFpbiBhcmNoaXRlY3R1cmVzLiAgY29weV90b191
c2VyKCkgLw0KPiBjb3B5X2Zyb21fdXNlcigpIGFyZSBwcmV0dHkgZGFybiBlZmZpY2llbnQuDQoN
ClJpZ2h0IG5vdyB3ZSBoYXZlOg0KDQotIEFwcGxpY2F0aW9uIHRocmVhZCB3cml0ZXMgaW50byB0
aGUgYnVmZmVyLCB0aGVuIGNhbGxzIGlvX3VyaW5nX2NtZF9kb25lDQoNCkkgY2FuIHRyeSB0byBk
byB3aXRob3V0IG1tYXAgYW5kIHNldCBhIHBvaW50ZXIgdG8gdGhlIHVzZXIgYnVmZmVyIGluIHRo
ZSANCjgwQiBzZWN0aW9uIG9mIHRoZSBTUUUuIEknbSBub3Qgc3VyZSBpZiB0aGUgYXBwbGljYXRp
b24gaXMgYWxsb3dlZCB0byANCndyaXRlIGludG8gdGhhdCBidWZmZXIsIHBvc3NpYmx5L3Byb2Jh
Ymx5IHdlIHdpbGwgYmUgZm9yY2VkIHRvIHVzZSANCmlvX3VyaW5nX2NtZF9jb21wbGV0ZV9pbl90
YXNrKCkgaW4gYWxsIGNhc2VzICh3aXRob3V0IDE5LzE5IHdlIGhhdmUgdGhhdCANCmFueXdheSku
IE15IGdyZWF0ZXN0IGZlYXIgaGVyZSBpcyB0aGF0IHRoZSBleHRyYSB0YXNrIGhhcyBwZXJmb3Jt
YW5jZSANCmltcGxpY2F0aW9ucyBmb3Igc3luYyByZXF1ZXN0cy4NCg0KDQo+IA0KPiBXaHkgaXMg
aXQgYmV0dGVyIHRvIGhhdmUgdGhhdCBidWZmZXIgbWFuYWdlZCBieSBrZXJuZWw/ICBCZWluZyBs
b2NrZWQNCj4gaW4gbWVtb3J5IChiZWluZyB1bnN3YXBwYWJsZSkgaXMgcHJvYmFibHkgYSBkaXNh
ZHZhbnRhZ2UgYXMgd2VsbC4gIEFuZA0KPiBpZiBsb2NraW5nIGlzIHJlcXVpcmVkLCBpdCBjYW4g
YmUgZG9uZSBvbiB0aGUgdXNlciBidWZmZXIuDQoNCldlbGwsIGxldCBtZSB0cnkgdG8gZ2l2ZSB0
aGUgYnVmZmVyIGluIHRoZSA4MEIgc2VjdGlvbi4NCg0KPiANCj4gQW5kIHRoZXJlIGFyZSBhbGwg
dGhlIHNldHVwIGFuZCB0ZWFyZG93biBjb21wbGV4aXRpZXMuLi4NCg0KSWYgdGhlIGJ1ZmZlciBp
biB0aGUgODBCIHNlY3Rpb24gd29ya3Mgc2V0dXAgYmVjb21lcyBlYXNpZXIsIG1tYXAgYW5kIA0K
aW9jdGxzIGdvIGF3YXkuIFRlYXJkb3duLCB3ZWxsLCB3ZSBzdGlsbCBuZWVkIHRoZSB3b3JrYXJv
dW5kIGFzIHdlIG5lZWQgDQp0byBoYW5kbGUgaW9fdXJpbmdfY21kX2RvbmUsIGJ1dCBpZiB5b3Ug
Y291bGQgbGl2ZSB3aXRoIHRoYXQgZm9yIHRoZSANCmluc3RhbmNlLCBJIHdvdWxkIGFzayBKZW5z
IG9yIFBhdmVsIG9yIE1pbmcgZm9yIGhlbHAgaWYgd2UgY291bGQgc29sdmUgDQp0aGF0IGluIGlv
LXVyaW5nIGl0c2VsZi4NCklzIHRoZSByaW5nIHdvcmthcm91bmQgaW4gZnVzZV9kZXZfcmVsZWFz
ZSgpIGFjY2VwdGFibGUgZm9yIHlvdT8gT3IgZG8gDQp5b3UgaGF2ZSBhbnkgYW5vdGhlciBpZGVh
IGFib3V0IGl0Pw0KDQo+IA0KPiBOb3RlOiB0aGUgcmluZyBidWZmZXIgdXNlZCBieSBpb191cmlu
ZyBpcyBkaWZmZXJlbnQuICBJdCBsaXRlcmFsbHkNCj4gYWxsb3dzIGNvbW11bmljYXRpb24gd2l0
aG91dCBpbnZva2luZyBhbnkgc3lzdGVtIGNhbGxzIGluIGNlcnRhaW4NCj4gY2FzZXMuICBUaGF0
IHNoYXJlZCBidWZmZXIgZG9lc24ndCBhZGQgYW55dGhpbmcgbGlrZSB0aGF0LiAgQXQgbGVhc3Qg
SQ0KPiBkb24ndCBzZWUgd2hhdCBpdCBhY3R1YWxseSBhZGRzLg0KPiANCj4gSG1tPw0KDQpUaGUg
YXBwbGljYXRpb24gY2FuIHdyaXRlIGludG8gdGhlIGJ1ZmZlci4gV2Ugd29uJ3Qgc2hhcmVkIHF1
ZXVlIGJ1ZmZlcnMgDQppZiB3ZSBjb3VsZCBzb2x2ZSB0aGUgc2FtZSB3aXRoIGEgdXNlciBwb2lu
dGVyLg0KDQoNClRoYW5rcywNCkJlcm5kDQo=

