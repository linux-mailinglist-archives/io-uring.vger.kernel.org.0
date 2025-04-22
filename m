Return-Path: <io-uring+bounces-7613-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4C4A96D59
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 15:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCCB4189C29E
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 13:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA14B1F1507;
	Tue, 22 Apr 2025 13:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sAdmzwJ1"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2041.outbound.protection.outlook.com [40.107.101.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD28220D509;
	Tue, 22 Apr 2025 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745329640; cv=fail; b=PCrlUKUgQkFU9Z8PL5PMTnWBDob8YOPF9lohd8X+ccdUsMav321vNqjkna87FQjC1UiSaPgFLsJthLAlswNLV8CLi/F93g9awfQwCXeZgfQsjd8k/U8SJBcPigWYVmpvN5GQKtCE1KlzoafxAoaz5Fh/i8tFa2wKMyOiS+ny7lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745329640; c=relaxed/simple;
	bh=ENJ1137VgiKDDfPSFDpallkUB/DN//K0yo0mTVQ7gZU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uxVB9Rh+NuGC/Zq1VKgV2swBRjy9LVncOr7710W7JcZF9yLD7NBJRiu3PfwsWmrEW/2IlZMyNbua8e2a1nM1/IgCi6hc/mttIlHXsphH2CK7OVy6BHTtpoSfqJe7lSB7SCtciCCdxkTFmnCBjpet01Oyue3L2PkKuSWue5vukEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sAdmzwJ1; arc=fail smtp.client-ip=40.107.101.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PAXr0nSJvEz3/M2n2w1YgM/jaSRDy03JsFc9bOGzGkEqBb27+Ok9qCRhMao5p87aWaLvFQNO4dD7kS3WDvwK2p83yaLwyGULq48qtJS76QzTmqHk1kCm4a1RGWDnHLxsw5dGB/uuG3Ez17lwofLQUtWX6GwS7cpojZNZyb+iT6X0heAfghSksGEFa0XK15pZgCs9CDNRFCO8prLxtq6KDQXcaGK6RILyuo23R+wEDTNBsHbX5BjruT6V/pEPaZsHdrn3NXSCqf1JVG7Oi6nDRSW3W7IMf5vgyJkXAlHgFUCm48IvSlPWaG4wtirOy1mm6JYOl85SwIgIW2iMWGhQVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDu69Myl3qMpp5/itlxoWzL+lrHx7TZ+z6WkANbTwKA=;
 b=XkffpSHVjCi8gEjsZguB24fx8nOb/fvO5eGnA1NyO75+C8o93qv2AwcbAMFyYE3Fw5x2wM5BQwxYoiDncqVH4AAyWjdi+qt9akrO4HOUFg4zRDQF1o7mIuqiYNUPyXrUh4j2TQEzHYKt9OD7Ea5Yj4ywHkiYVO2q7AXdH/zr6I4GgIOlbQ/5K+V9BkqYGm1psE45u7x/dOFoFspP6+qphiys5o4tvxTJxu4kP3KPfLkZLsh7DYfCRLNS6g4MAKtnXVFHvrwTHIwPLngEmPHT3AN7d+Wv+8Tuywkb+pLuhPQ+GTahaRrhoZ/bfLqQf1Z3MC1aJxVXbD91lSSnrTHUXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDu69Myl3qMpp5/itlxoWzL+lrHx7TZ+z6WkANbTwKA=;
 b=sAdmzwJ1DctSvRLM5Y7O05ThPr2nUUuP1m3PMD1Hd8MDFe0yrNz4iadi/Yid1pQk01yMkW6McPdAgjMdBVT+xOYZePt9kiYgjSIaYTsJ2vRqBlNRvX+Xg0shc5QhwQoRQyd55ogP0u+dCdPp1IJylc3V4UhSkPsrArRf1oizCrCW8SFOw4qaaUh5/j///VwOBtffPMa3k+xQEyZhysKhy9ZNm0/EttZS+X9NNvC+ELn3dQG5A4vfEeu7NZoQFmGhNCKJqwvcbEtfLBpGgLE8IFYVwAm/Qiv8V6acoZ60x3hw326Bu+1vLS/pifMFOoHZoyZlxzh813yRksG4VIuHXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com (2603:10b6:a03:453::9)
 by DM6PR12MB4451.namprd12.prod.outlook.com (2603:10b6:5:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 13:47:15 +0000
Received: from SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b]) by SJ1PR12MB6363.namprd12.prod.outlook.com
 ([fe80::bec3:4521:c231:d03b%3]) with mapi id 15.20.8655.031; Tue, 22 Apr 2025
 13:47:14 +0000
Message-ID: <8ff02553-ff2e-4936-a9c8-6a4cf17e5ac3@nvidia.com>
Date: Tue, 22 Apr 2025 16:47:08 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: ublk: kernel crash when killing SPDK application
To: Ming Lei <ming.lei@redhat.com>
Cc: Guy Eisenberg <geisenberg@nvidia.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "axboe@kernel.dk" <axboe@kernel.dk>, Yoav Cohen <yoav@nvidia.com>,
 Omri Levi <omril@nvidia.com>, Ofer Oshri <ofer@nvidia.com>,
 io-uring@vger.kernel.org
References: <IA1PR12MB645841796CB4C76F62F24522A9B22@IA1PR12MB6458.namprd12.prod.outlook.com>
 <Z_5XdWPQa7cq1nDJ@fedora> <d2179120-171b-47ba-b664-23242981ef19@nvidia.com>
 <aAecrLIivK5ioeOk@fedora>
Content-Language: en-US
From: Jared Holzman <jholzman@nvidia.com>
Organization: NVIDIA
In-Reply-To: <aAecrLIivK5ioeOk@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0004.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::13) To SJ1PR12MB6363.namprd12.prod.outlook.com
 (2603:10b6:a03:453::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6363:EE_|DM6PR12MB4451:EE_
X-MS-Office365-Filtering-Correlation-Id: ee562801-0d15-45d2-175e-08dd81a43041
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjZ6cThhc3hDSzZJY2RVK0Zqb2RpTGV2azdjNVJOK1BBVlE5MXhnUXVMUHNl?=
 =?utf-8?B?ZmRpUTBTMHhZUkJFMWxySlVYWUYxVVR2UEF6SGU1dk94UEFteGNQTGNsODJN?=
 =?utf-8?B?Q2IrSDVhbi9pTVVWeWNIL1NoN2ZDQmVxNGgrbEd3c3dlUVNxRWJYR09FNnR6?=
 =?utf-8?B?ZFFMMUtTQUF2dWFHWERDOTBNdXV5ZTNVcUQvQWQzaFJnYnRsN296anZQWER2?=
 =?utf-8?B?UGpXK2lSS2YyREtHcTdCMStLZ1N2WDlocWhMUFBLaUZTMWJNc05hK1JrS3JW?=
 =?utf-8?B?MjhFYVBwQU9qb3BUUHdwNjNlbW9hb0N1d1Bqb0ZabTJ1YjFPMU9XZFJLS3Jm?=
 =?utf-8?B?MEdPcTlEaFBxVnJqRWEzUkxLSVZsUy8xeXBzQkxIOVFjMHNtRDVDSkhqWDND?=
 =?utf-8?B?dlp1ZGNZSzVPZFU2M2R4eHBFNzhJeWVhVDFEdjhVKzRJZW1RdGhKTEpOcVha?=
 =?utf-8?B?RUE0a01TMEdtUk1rRXl4STlNMHJhV09oT0xncER2NSsxcEpveU04S25ML1BC?=
 =?utf-8?B?aHVmR2pHNDZXbkF6cTRqY0RZZ0dDMnlXZTNEUzBFMVNNN2dPcW9ibmhFZHBr?=
 =?utf-8?B?Z3JzQzJ0UytmQjVjaVlpc0pSbkFKQUFwQUxIS1VEK0xtR2Y2RnYwSk9hbU5w?=
 =?utf-8?B?YjdTMXNSdXRERkNSUFBRVFJXeHpZNkpmbVk5cEZlcWd1SnVLVVQ1bVZHWGUx?=
 =?utf-8?B?eEtLSGttM3B3NDBTRmtpckdVWXFuWkdLZjk3L3JNd3Q2N0pPSjlCVkpvektM?=
 =?utf-8?B?NkxyNnd6N1kzQmczczVhOVV4TGJibmJ2QUlGNUZjZmxHRk1PNUVBL2t5bFpy?=
 =?utf-8?B?eXB5cGNmbmlVUEZ4ZEwrSzQ4a1o5UDh3TE1YZFMweXlxSUk5aEtkQU9jSDlB?=
 =?utf-8?B?cC9UWFIvcTFhdiswczdTcjdjZGFaUjNkdWduYm0zMmxoMGE0Q1dML1dybDJn?=
 =?utf-8?B?NC9OYWZ6YWg5OTUzRlRxWUdiamF5WE5yT1ZiNHNmVmMxblJ6MC92UUNQbElW?=
 =?utf-8?B?MnpKaVVvNXB3cUZsQVkyMlh3V2VZVnFJU3k4Q2tPZ2JFelRwV3hkUVpORFow?=
 =?utf-8?B?ZTg2WktnbW9oQkJKR3Q2eXpMRGNDdGdYZWk4VmlMbnF5b2w3S09yMGw0aU9P?=
 =?utf-8?B?MytFSTJsdnFObnRvR2lHZnRpU1hOVjJ5VCtvS29FbDBUalpHSEc1UE02TFU4?=
 =?utf-8?B?RWN5eVFOazBaZHVBQy9GdVZDZWhVVWJ0cG01SmdMaEU4Wms1dkVUMUdOdUtH?=
 =?utf-8?B?blJRbDRuK29TcHhBQkw4SW1ja2VEUEI5Y2p6UzhRMFllZ1A0SkZHTkdzbkZi?=
 =?utf-8?B?NXpaOUpVSGtpZ2hFZ3o5QjhUMzlIeFhKdzNsVmJLVWc0T25QYlBVZTlvYnk1?=
 =?utf-8?B?YUE4ZXd4b0o0bzNHdHJtU3lkQklZUnBIcEdEZHNTZUZIOTY4dXB0Z0V0K1Zn?=
 =?utf-8?B?TXFQZlo1elROQWV0U3lsbnkvNVVhbndjbDF5elNLZGxzTS9mN2UvY2lGRTJX?=
 =?utf-8?B?Y0N0alJDRWpGK3Q1eE5HaUlZQVVvK0F2MEpyTXRXUTErTGw3dE8wdDJJalVq?=
 =?utf-8?B?SzI2b1NSRXc5RGVCbEg1b0tSVXJnQmx2QUw5SGVIUW1IMDNOOUYrZDZ1NjZO?=
 =?utf-8?B?SWNuQ0p5WlMxY085ck1MeklPVUtsV1NaOVV2cDRKdVNzODMwUjMyWGhjT1FJ?=
 =?utf-8?B?Y2ZDa3JOL1NtVWZwOHR0Tml5cEE0Szl3WGhReVBDVGtsdDNDMENnTmUxYWlj?=
 =?utf-8?B?ZWc0R0hkTEU1QmtMcGMzSDRPYXUrL2NnLy8yZi9JbzlITkdxRjNjUWRRVFJv?=
 =?utf-8?B?TnhieHNZeUNYQXdvUW9KZFpvUklyT3VqSndFakdnNDlLZHAzZFBNN0gxV0Ji?=
 =?utf-8?B?K3VNQmxUZDk1eWErWkpWeUs4MGpGemxncFlQMUJmc3JGbkszVzhTb29YTSsy?=
 =?utf-8?Q?uxrVEmGFVlA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6363.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3lEMDN5VnZyM0dmREdaWkQxUm04TnRia1FLeHpCYjhPdmh6UnhHZjhCQytI?=
 =?utf-8?B?UlltSWYrKyswZm1NU3hnb1BNdytmVk5pU2hsT0Q3M0dFQktKYng1c29pcldN?=
 =?utf-8?B?ek9QZkVhVFVCWDQrUWYrNndOd0pZZ3lBK05yODVVQXM2SkMyd1F0cEQ2UWtK?=
 =?utf-8?B?enFVM25aWjNETEVETllsR1dHcGQ1Uk5RQ2tyeDJ1cERlRFZsa0lqVm13YzZt?=
 =?utf-8?B?akRkRnY0dmxKY1k2MnNWOGlPOWJuZXF4Wlo3c1V3RnM4dUlKdldWZ29NM01o?=
 =?utf-8?B?ZlA4bWJBV1dUQWVtSDk1Qy9ya2Vmb2ErNTVNSTI4YzJvSnhwZHJtTkNYUklo?=
 =?utf-8?B?dGEzZjNEQXQ0TEVZTTB5YS9jRTg4TkJyOUIxSVd0R1haSTl6Mk1KOTFubXZS?=
 =?utf-8?B?SVd0eHdGR1RmaXJtbitlZE93TytiRDBzWDAwWWlRaWE2V0VnZG9sRFR0N0x2?=
 =?utf-8?B?eXJzazhFSkVyTnlXWnFGWkNRbjdvQlpGSWcrcWhteUhhUjByenZvdTd3bnd4?=
 =?utf-8?B?aytLUThObTYxZE9qdGhUckZqV2ZVWmNBenZZN1FRNDVPMThLNHNXdC9NZy9s?=
 =?utf-8?B?eFVkNW1tMkEwTSthZ3laclI2RllxbXVMVXhCdGRjMXRrQVdidXVGT0tGTWxn?=
 =?utf-8?B?dVU1bHFtZmE1T2h2QnU3eVJyQTBoK2JxRGRYTXphcTJzaklrNDdsUUYrWjVq?=
 =?utf-8?B?cS9NeVVlTGVsamZURGdMTFcwUG1lRGVNNmZWSGczV2RQdHhGZFYybURrOU9F?=
 =?utf-8?B?UTNGc0VybkNOQitaZ1ZqSDNtRk0vbjgxcG05QVJ0Sjg1US80VlRwelQrdnJ6?=
 =?utf-8?B?WVRpci80by9iUm9CRkxldmZranVYT1o4Z0NsWHB3N2cwN3ROWUxCSzQ2WFpY?=
 =?utf-8?B?UFhmOHA1V3pxRXBnV2ZaelN1cUp5ZURVazVBSHpQRHQ3TEN4dlRCa0JhQUg5?=
 =?utf-8?B?cE9xY25KUSt6OVErUTFxUjhEajBEeVNmZ0tmSG5tSXZXYVluKzhva3dBWVZQ?=
 =?utf-8?B?MnhjZXJUc0lLTXJNZE8zc0h0ZWZmRG5iNkZaUktXS2RTbjAzbVVYTmtUeXVV?=
 =?utf-8?B?a1Y2Y28xekdYcU9xbW9FSjJvUjdWd3lkTWFSd1gxd0hwK25ZdHZ3cFZuM2Rl?=
 =?utf-8?B?YXZCQUxLa2E0MmVGUUZTT1R1MGhZd2Q2T2QwdXdZTWk3enRDWW9vczZLUGZM?=
 =?utf-8?B?OXJvSmZ3NFBQQnVLMzBIRFhrVHhscGU2VDhZZ0FSTXFlcW1IZFB1ZUx5eEcv?=
 =?utf-8?B?aG5xSUxzZWMrZ0hFd2JFWE5zanA4UUt6b1IrMHUwUTZQdGVrcnhRaE1ad0dY?=
 =?utf-8?B?eVFieDlxQldxNExNOWtST2Q3aWhhUnh3MFlPdVJBdEdlaU9SM1pzcno3aHRm?=
 =?utf-8?B?azdVLzBETUpVcSt1MUZVTks1em4rVWpVdnRNVmhGUTVQN2R6SWR5ZjZCSmpB?=
 =?utf-8?B?b1NhMERiZmNvRDhYN2lDTmZoV3pPbE1OQWpmN2FsbWtXZVZjVEpwdW9oUE1I?=
 =?utf-8?B?TW1OOEhEVnRQSVZVaGZrVFRXUTU4S1BmSlRsQmZ2cVJBS282eDRua0Zac1Fx?=
 =?utf-8?B?K2M1TGI5WDJkL2dXd1pMTTVnYWJNOW80SzhrM2ZDRDFORnIvMEZXY29wajdH?=
 =?utf-8?B?ZWI2S2VNdkNRSDRjL1hSRExndVNtOEgwUUlRSndURDZqQ21YTkhVeGdUZzU5?=
 =?utf-8?B?Wklhd3A3MGtYOTJYU3p2eHhMVVRVbUpuV2gxeFNFbm1ZUW9RWXBkcFZVakw2?=
 =?utf-8?B?V2MwYUhwQks5REg3T0Jpay92OVZsRjJPaHkxNDhFMXBzcGI3RnR4bWNqRUxY?=
 =?utf-8?B?by9JdFZodVhERTdZZmx6bEFoNFgrbVJBMGFiaHpta2hGZWpsZWhBeTNhbStv?=
 =?utf-8?B?alZCQjRXL2hKbExyQXdGY3FobHYvaUp6VDBXbEszaTc5UGFxRW0zTEc0d1U2?=
 =?utf-8?B?ZFhFK2tzbzc1WTM1a1FqVVY4d2JJVEFHT200SC9UaGttK1R3SUM5cUo1VUc1?=
 =?utf-8?B?dWJ2UlI2cWl3VlRlR3ZHZTJ3MHV6bC9PamxTdkNqRTd2dWllUDdKRHlSdm1p?=
 =?utf-8?B?N1Y5NHFJWXYxRU5xRVFjS0U1YVU3a0FRa2RqM0FJVzlqRjArVnc5TnAxQkNz?=
 =?utf-8?Q?7NdxpW+Sy66AlfiOdZAulKVuU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee562801-0d15-45d2-175e-08dd81a43041
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6363.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 13:47:14.4820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4RQzlYviiRPUVMkwd5xj/5SaXEyz1uFXgcB+JES3G/EVL2Iq+PPvYP3VVr3ldfph4hOvfFe8E1yn8t3jgHT1Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4451

On 22/04/2025 16:42, Ming Lei wrote:
> On Tue, Apr 22, 2025 at 02:43:06PM +0300, Jared Holzman wrote:
>> On 15/04/2025 15:56, Ming Lei wrote:
>>> On Tue, Apr 15, 2025 at 10:58:37AM +0000, Guy Eisenberg wrote:
> 
> ...
> 
>>
>> Hi Ming,
>>
>> Unfortunately your patch did not solve the issue, it is still happening (6.14 Kernel)
>>
>> I believe the issue is that ublk_cancel_cmd() is calling io_uring_cmd_done() on a uring_cmd that is currently scheduled as a task work by io_uring_cmd_complete_in_task()
>>
>> I reproduced with the patch below and saw the warning I added shortly before the crash. The dmesg log is attached.
>>
>> I'm not sure how to solve the issue though. Unless we wait for the task work to complete in ublk_cancel cmd. I can't see any way to cancel the task work
>>
>> Would appreciate your assistance,
>>
>> Regards,
>>
>> Jared
>>
>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>> index ca9a67b5b537..d9f544206b36 100644
>> --- a/drivers/block/ublk_drv.c
>> +++ b/drivers/block/ublk_drv.c
>> @@ -72,6 +72,10 @@
>>  	(UBLK_PARAM_TYPE_BASIC | UBLK_PARAM_TYPE_DISCARD | \
>>  	 UBLK_PARAM_TYPE_DEVT | UBLK_PARAM_TYPE_ZONED)
>>  
>> +#ifndef IORING_URING_CMD_TW_SCHED
>> +        #define IORING_URING_CMD_TW_SCHED (1U << 31)
>> +#endif
>> +
>>  struct ublk_rq_data {
>>  	struct llist_node node;
>>  
>> @@ -1236,6 +1240,7 @@ static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd, unsigned issue_flags)
>>  	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
>>  	struct ublk_queue *ubq = pdu->ubq;
>>  
>> +	cmd->flags &= ~IORING_URING_CMD_TW_SCHED;
>>  	ublk_forward_io_cmds(ubq, issue_flags);
>>  }
>>  
>> @@ -1245,7 +1250,7 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
>>  
>>  	if (llist_add(&data->node, &ubq->io_cmds)) {
>>  		struct ublk_io *io = &ubq->ios[rq->tag];
>> -
>> +		io->cmd->flags |= IORING_URING_CMD_TW_SCHED;
>>  		io_uring_cmd_complete_in_task(io->cmd, ublk_rq_task_work_cb);
>>  	}
>>  }
>> @@ -1498,8 +1503,10 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
>>  		io->flags |= UBLK_IO_FLAG_CANCELED;
>>  	spin_unlock(&ubq->cancel_lock);
>>  
>> -	if (!done)
>> +	if (!done) {
>> +		WARN_ON_ONCE(io->cmd->flags & IORING_URING_CMD_TW_SCHED);
>>  		io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
>> +        }
>>  }
>>  
>>  /*
>> @@ -1925,6 +1932,7 @@ static inline int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
>>  static void ublk_ch_uring_cmd_cb(struct io_uring_cmd *cmd,
>>  		unsigned int issue_flags)
>>  {
>> +	cmd->flags &= ~IORING_URING_CMD_TW_SCHED;
>>  	ublk_ch_uring_cmd_local(cmd, issue_flags);
>>  }
>>  
>> @@ -1937,6 +1945,7 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>>  
>>  	/* well-implemented server won't run into unlocked */
>>  	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
>> +		cmd->flags |= IORING_URING_CMD_TW_SCHED;
>>  		io_uring_cmd_complete_in_task(cmd, ublk_ch_uring_cmd_cb);
>>  		return -EIOCBQUEUED;
>>  	}
>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>> index abd0c8bd950b..3ac2ef7bd99a 100644
>> --- a/include/linux/io_uring/cmd.h
>> +++ b/include/linux/io_uring/cmd.h
>> @@ -7,6 +7,7 @@
>>  
>>  /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
>>  #define IORING_URING_CMD_CANCELABLE	(1U << 30)
>> +#define IORING_URING_CMD_TW_SCHED	(1U << 31)
>>  
>>  struct io_uring_cmd {
>>  	struct file	*file;
>>
> 
> Nice debug patch!
> 
> Your patch and the dmesg log has shown the race between io_uring_cmd_complete_in_task()
> and io_uring_cmd_done() <- ublk_cancel_cmd().
> 
> In theory, io_uring should have the knowledge to cover it, but I guess it
> might be a bit hard.
> 
> I will try to cook a ublk fix tomorrow for you to test.
> 
> Thanks,
> Ming
> 

That would be great. Much appreciated!

Regards,
Jared

