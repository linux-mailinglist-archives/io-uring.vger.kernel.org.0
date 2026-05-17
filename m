Return-Path: <io-uring+bounces-13375-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yBL5CJLaCWpTswQAu9opvQ
	(envelope-from <io-uring+bounces-13375-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2026 17:11:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F21561EA2
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2026 17:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3EE17300146A
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2026 15:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F0427453;
	Sun, 17 May 2026 15:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="WPtvyBW4"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49239322C6D;
	Sun, 17 May 2026 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779030075; cv=fail; b=bU7rVhKe0UyX6/uMAL2lL4r2YGgfRLcL74KdbvzqXmqu7xdoWSNyp3CUNYH36GjtuP37jUWwShbJ753DYlweAIlcw++tJnyIGKXTYwUGFSHpSn7nQs5pvaPqIv0RrGJKD7P8DU7QnvGrYIHy9pfcePHK4D+97JTG4RZl7m2KUnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779030075; c=relaxed/simple;
	bh=be5Q/LCAx+ogomkNy3B9Mp4b7dL8cNGJq11bRtqIftc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JY4fT1w+MZ+qrb770QUZTkVkO0M3+2pKTEQMWX6y/QrH8od+dGGdIyhyX1HMR6U5w/C1ukszrdWeQ1Pifv/ied14t+cgRG4ColXcdUeMnz8zx468okIcfnD68MZKGYkOWpOmJG8uhm8N7beqnGTVhcxs1+6KOj6ntX/n/IspC/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=WPtvyBW4; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020123.outbound.protection.outlook.com [52.101.201.123]) by mx-outbound45-22.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 17 May 2026 15:00:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ShJ6AueJFUbvQH9nxv2vVrroGES1qJ1aPxKuR0W8oU8fE09F3H7LcY8nT/DDLLt5yw3v4ku93EpKeycRI5T4nv2RLHxmRoXKmDoCmBkkkwyeBNQbTey7s31yEGdRjclzGuFgud/eAo3sDmSlOi5viSGULew/A9g2JFOGNGsm5pRDoH877Y5yyD7hl42fD34pqVh5X8ZVBnzgZYioVAYSkrwE8RSPMZnQsNbLw0UcahZh5DyPUXVeYUC/JsF7IANj3cciYUpCKEh0cy9ozOkeGx1laHMlmbQleKLIXenFG6J3xKY5zl62ACh+L34wpFU9G7R1nlngmdYppIRAf8oQ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=be5Q/LCAx+ogomkNy3B9Mp4b7dL8cNGJq11bRtqIftc=;
 b=G4FnL9ZQeWtRuDwOhJeYl4MAMfA2ZPHeiQ8oAgefQZcyuDiINzVttFcBIlMqeC26G7vTSMUdTerDfcoYBCa4/tNNOXMdjjGEPEjD5U7zwfpIFsZrTLYL2n70/elYfnZBlkwQAG9q5gtUNFmmAb2rttAMy1Hfkxoh8kKcAVmxjyAo1BmqAca14hhQ67sz52rLb297m+QatGcq6+UqxASMwJi96B7ECuVFQBXtNlbcvjKLcG2CYvnipRTEny8544rEYS4cfFrorisWorzn2uTpeebaNdUpd5cvbJdnnxRmZ6x/iXkeuNRTpOLrfPrUUObnLsToms4A5kbI8DqUyKpFvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=be5Q/LCAx+ogomkNy3B9Mp4b7dL8cNGJq11bRtqIftc=;
 b=WPtvyBW4ItVGGWprWfPunRBp+CnO0AcUYQRpg3VoOGdyGru4L9NFlEwoXaywy9YNRHnuIWCK4Zq6n4ZAuzECU2tuKqSovLhFeLZUbr3gPimDIMEaU+PTS6lNHMWzocyRuYZ98eCxli08RLKO1u8hU056v2ZFb2pjrrtQrzHFwP0=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by SJ0PR19MB5638.namprd19.prod.outlook.com (2603:10b6:a03:42d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Sun, 17 May
 2026 15:00:41 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704%7]) with mapi id 15.21.0025.022; Sun, 17 May 2026
 15:00:41 +0000
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
Thread-Index: AQHc5f0ab+Kc+AhELUaTC1v0iClq0bYST98A
Date: Sun, 17 May 2026 15:00:41 +0000
Message-ID: <08d3f6e0-7745-4084-995a-95ddb77f7f11@ddn.com>
References: <20260517095846.fuse-iouring-uaf.dc5f5dbb71dc@berkoc.com>
 <2026051703-equinox-multitude-91e2@gregkh>
 <20260517-fuse-uaf-cover@berkoc.com> <20260517-fuse-uaf-patch2@berkoc.com>
In-Reply-To: <20260517-fuse-uaf-patch2@berkoc.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|SJ0PR19MB5638:EE_
x-ms-office365-filtering-correlation-id: a83a2f2c-7e5b-4a33-1bf2-08deb4251029
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|10070799003|7416014|376014|56012099003|18002099003|22082099003|38070700021|3023799003|4143699003|11063799003;
x-microsoft-antispam-message-info:
 Y42T8KCMjPcsqnWKnaTyXU8sW4S++VaM2sz5HlcqutGx1eV2L072mZD14CydB5EptEuhOOMbrM/6dlci18Gj5yCxuBvkARdQ+HEUKeehvUWu0cqVJND/LT7eIBOIZc95PapL9xhWc49VM3r92qsAPDLhGHuIu5OwDXKr9+vx+kTDCBJJqtlUqTm/NMt05M72nx7PjVXMzCrM7GqHkBHkLSc42ye1woyXG+f8MNA7av6lPJbd+4N1pRz4bpt148B/gJdT5aCpIf0Z5FtF5qUuUUnqNdrW3JHaoKG9Sy+Hyc9qKYXdjNZrxrpzdtjznc4TFbJPKHSNfLQu1ntyCvBw4bHEy9ui2h1gywwT1fjtGC1swBdG2iycbY+/ps/dnTtM/KWrqBd38U5Xftl331Nc+1cvB2k3QWnFnZNIhKj5mXVbkn/vYeAh8fSD9YVTONimc3F8K9IOErCiJ9MsSZ0glbWxDAQetOQJnBq0pIad9byCREPOJgBkBCNKrlys9kuzc7Dewz6O1m/QnpCR3Le1lXijBM9bTL1FTvEOwL08hbG+BTnOiPYeCwKY+8bTJi7gK56CQrNHU4cm5FqSIFCqR0npca1CCA9pGIip9Ck8yeLprPPL0Rs5yYRqrCWkt4yZtkiPh3aGC/+5dcQQG/l13pb15bMoH07x2PP0XQIkeLeY/tKSolS+FwdEAPtiiTsKMzz7vNrWty8c8K8i+v/WhWq2coA2Ldp5sVeCzwPR6pTuEitnIEkGSHZ4EJ/uly7O
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(10070799003)(7416014)(376014)(56012099003)(18002099003)(22082099003)(38070700021)(3023799003)(4143699003)(11063799003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WnhBVmV6bFg5UHFjYXJKNVFwSmhSQWE1QWkrc0huUnpIaXp3cnJrak83eTdI?=
 =?utf-8?B?dTRuMXg2UW5SUlduRzR6RkV3VkZSa1RLUDM3Y2dtbmhScXZ2MzFQZk1GeHdK?=
 =?utf-8?B?ZzZ5akRiOWZJM1dFOE9HUVlHZDQyQ1lMdHYrTXVQZUtxdWdDRVM3WWFYYlNF?=
 =?utf-8?B?OElTVkhEaW1BcFo0cWRrSlNpTW1BOWhrL3RCRjNlWHpLckxVVTZQN3hZT3Av?=
 =?utf-8?B?VThoaDNRVFVjL0xRT1RXeFZvOUFFUVdpZFhDZE1TNE4xeWtiK2hwTjUzeHJU?=
 =?utf-8?B?cUpQN1hqQksvdnc1ei94bUE2Y0FDWmZQbEZxOW8wWXpzYkVlSXllSCsyRGVn?=
 =?utf-8?B?dkQ4cEM3VXAwWFdON2tpWFBXRUVrZHFINFgvS2w3RTQ1bHJReERMNnU1OVh2?=
 =?utf-8?B?OTRrbEx5RGVoNHU1Z1AxODRpQTZNLzdnZmx2UWt2RXA4YlhHVUJUUzJPZ0Jr?=
 =?utf-8?B?UkE3Tno2RDlET054YVdMNCtvOVoyb25vdVZuc3A1aG1mcTNObFd4blBUN0Iy?=
 =?utf-8?B?UVo4blE0OFlLanA3TFk0a3RBT25sVDcyNWhwQ1BVa1k1c08vUVdHeTVlSUE3?=
 =?utf-8?B?Nkl5NWZPbStEUlVndEhPeERJQVQ4V3Q0b1J3akNNdGxwNG5jU1ZDOGI0Qnkz?=
 =?utf-8?B?ZXN4ZWZ0S1lkSFZzcnNVTlZzSGNSbGIwYTJ2blAybXdaMzMrSTBlOTlhMnRr?=
 =?utf-8?B?YW9YSlFpMnAvdGFsaTdQbm9ud2d6Wkw0OGQxMWR6eTNMSEJsTm9vcnJRNkJh?=
 =?utf-8?B?ZGxhK2E0aDRwa055amlqZURLb0IzWHhyTWczMHRjRXlpMGszeGJwMXJWeUdz?=
 =?utf-8?B?RE9FaUlyUnMxNVV1V3BpZ1lRRFBvZkl0U1ZRd1pvdEkwNjhzZVdEcFN4bk50?=
 =?utf-8?B?QnV6bW9NTzVUZDdpQlg1Z0Y3UzNtWU1JVUtqMkpMUHVqUlhRS0hpSW9OWTJ1?=
 =?utf-8?B?ZDhPVHNYdytjcVd0Vmg1YkV1U1plUW96WHBUS0JURTY4SDluTlMvbjBDSFgy?=
 =?utf-8?B?elhDVHpkRU9BN3pBRFhISXRJM0hvRVVEVXRXc0FFNms0Y0V4bzdqZ3d4SVp1?=
 =?utf-8?B?OGpJSC9yWDVQeWEvQXRwaEk0Ry9oZTFoREJtTzB4SUdoTnRGNVJGYm5Vbis2?=
 =?utf-8?B?QzRIOHovRzFWV1FidUlzekJ1YW5MVVZvTzVYVjBRU0F4Vys1cnRXYmZWQ0pv?=
 =?utf-8?B?Z3FCQ1pIMXpuT2xhYmtpaU54b1hUYzZGbFdvZnd0RUQ5WkZvQm0vSk1NUnk1?=
 =?utf-8?B?TEE4RHp4QkZ2d1ZRVFNRZTIyeWdDSzNtdTZpVHBBWmtNaVZqeldtYVNrZmh6?=
 =?utf-8?B?cEhaUFdpdFhHSXZESnlYWmU4WmNIQkR3Q0UyREVPSG5xb3puTlYzMU1Ba3BH?=
 =?utf-8?B?aUNXK0o3ZnpyNDRSdjhkaFR3RktSTTE0eUczZ1BKQU9mcE5IeHNoUitWL2dF?=
 =?utf-8?B?SW1zcEd1MFJiYUV1Q3JhbjhzaG1ycnZkT1BFemhsbkZlQVU2eHlvcGo5ZVNM?=
 =?utf-8?B?OXd4a2tGa1dyVHZIK3RySExncS9sdHgvY2Q1OGVBMWtnUCtScXZmRXU3Vzho?=
 =?utf-8?B?RTZnSWFLYnZUNXVHV3JwMmIwTzIzUE5YUlRhSVJVc3k2ZFdnM1JoS245TWJT?=
 =?utf-8?B?MWFvQVNBQmxUL3Q0TXlpemJTNVBVaVBRMEZaN215NmlCR2xVc2MrKzAyWHZm?=
 =?utf-8?B?Q1FrMkNZV0NtRmk2RUx0MmxKTnlMVG9WZFB2Vkx4QXk4V2hMRWg1akM0NklK?=
 =?utf-8?B?VFJzb0l5NTcvM0szdld0NEl6WDhGOVdHQU1yZWVEWURkODcwUXFGOFgydEUv?=
 =?utf-8?B?WVVyT1N2Nkl1cklnS09GN2JJTVNCRVk0bVdHNjNHUGloK0IwbU1EQjN4c0ht?=
 =?utf-8?B?Ylk0emFkbVQ0N2pNZHRxQmZESWJGZ3BEb3p0V0FyUUd1UkRnazI3R3lHbEZs?=
 =?utf-8?B?NTNJSlFXV1ZJbGlBaVFCcVYzK05VMU9XQlhYaWZmcDAyTmthejQyMkJPanlo?=
 =?utf-8?B?SWdzQjNHeDdaSTA3M1NFUnlMMTJTR2RlSDhzdXdLWmx0MW1tMkl2aS9EcURO?=
 =?utf-8?B?TGxxRy9jZzNwK1d5SE00MVpSSzN3Z1M2YjhuZHAvc1NRMlVqVmc3d2FKc1NN?=
 =?utf-8?B?bU13U2c2bk4zVG5IQmNEU1VXN1EwTnJkUzFKcS9jWWhBL3hCVU9EOUs1SFF5?=
 =?utf-8?B?eXdNRE9aaWU5N0dMaGV2Z1JhSHYyU1NSOVJwcUwwSnVrZklTckt1Mk1JUlU2?=
 =?utf-8?B?UkVFNHUvMTRUMWhwSnVGU3Y3aWdvSzFNWGh4RUxZcHp1aTl6TVI4ZkpqSDhG?=
 =?utf-8?B?SkZMZjhvZUg0ZUJPWFdQYjg3YTBuZjFJdnE0ZVpIdElGV2tvNWFWK09HNGVZ?=
 =?utf-8?Q?qJqDTq9/x0WHcgdvT7pZ1SvkCN0U7NeeuwRQa?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF2FA318096A214BAB32C1F0B638EE5F@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	TU+TvzqdoN9jM9CxBZRxwbqeWKGayNWHK947xgBtXn+d0BmeBKbODUf3Wsdqv8wzVoxqWAvDGdf1hCXYvh0fcLS9WxAHFa21C8TsQj7A9d3BDQnYkW0fr2FkI1mIk5wyrOd3tizHmRlV++JJoi0/4NfdkxHZyAcDRN5lT6Fp6v/e8lvvZNbBGcK2VMyWKfbsRAa84z/4GyBxS7/0KH50X//X+BDnRaoyDdboPmS/CPCVCjfy3fLH8NF652HnVMJfF03lp/7JPihmssTnIA1i4n+gs/fyHusJGzmGgh1fGDwO2bjvCZeHlPvbd7TWarvr73yUZQk9SZiQVp7YFoQtYA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EcgD6oPyeMmcN8DLc4JjYLP4O0cG+lo1FAPJOYlnsEEkjBoRuQvkdyXkJwiUig6kslnrOc3fQKVbAte8vzRj1TqC1Hp1I33xT10xgIsYIZ053xE91f78yio8vBG2a9GbOOkBpIoIPlXFZjSrESwQN3U58wFoqPRyFgEiiR6jylWGSrPs6c0ZxdHUYSQ5DulSTo//bcF/entbK6rIViHj7Ggg6aqf1AJL1iiTwplzW//++hnUlsqSTsFHKyoSena0bm406Gi3JGl6jMdWLIyR8bOa8hwID2/o4uMhb1bni8GTYbe6/1gONpHoKaWkKiEq6n1TmGX07pKZ1u1bhOjLwoCvbnf1cHSzjquES8oKutrXGGdsDDUocaxFUmMS+GpNe6OSweI7LfcReDv5fWyTdjl52+2me7/Po2BXNY368AKOFgLS46yOpd7rRFhHBRaXyPjCoBzQLbCUkbwZzTan9ihNklJK4fJvHK/7Rnm+BcIC+0UuqOkaIwkjsoktnypXiDCpPYI87grZpytlkvxMk6ys+1K4jIEGypdTQWFEIlOcMu/rHRGRUk7fYEhVJI3og1TESAs/pqaFCCDskNBE4f1H2HC4X1FmUBn4TfafDrC0mjZ9pUxCEUstcEpeyvJkcMTWONggYmpDCX6qvqXsIQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a83a2f2c-7e5b-4a33-1bf2-08deb4251029
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2026 15:00:41.1016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WqiWbJS9g7g0dxoc1+LMinAZ4fp6qFZheS8UWBDr6VD+UFa/ZODJ/1Sm+yy1CpUh7Mzs97rp1meUWTqUZryjdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR19MB5638
X-BESS-ID: 1779030044-111542-9246-8678-1
X-BESS-VER: 2019.1_20260511.1731
X-BESS-Apparent-Source-IP: 52.101.201.123
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsbGhkZAVgZQ0DgtNdkwMcnAMj
	XNJCnZJNHE0MQi0dDc0CjZLNnU0CxFqTYWAL0riPVBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.273289 [from 
	cloudscan15-166.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1
X-Rspamd-Queue-Id: B0F21561EA2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [7.44 / 15.00];
	SEM_URIBL_FRESH15(3.00)[berkoc.com:email];
	SUSPICIOUS_RECIPS(1.50)[];
	SUSPICIOUS_URL_IN_SUSPICIOUS_MESSAGE(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	MAILLIST(-0.15)[generic];
	BAD_REP_POLICIES(0.10)[];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13375-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	R_DKIM_ALLOW(0.00)[ddn.com:s=selector2];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	GREYLIST(0.00)[pass,body];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,vger.kernel.org,kernel.dk,lists.linux.dev];
	DKIM_TRACE(0.00)[ddn.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bschubert@ddn.com,io-uring@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[ddn.com,reject];
	RCPT_COUNT_SEVEN(0.00)[11];
	REDIRECTOR_URL(0.00)[aka.ms];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_SPAM(0.00)[0.778];
	R_SPF_ALLOW(0.00)[+ip6:2600:3c09:e001:a7::/64:c];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ddn.com:mid,ddn.com:dkim,berkoc.com:email]
X-Rspamd-Action: add header
X-Spam: Yes

T24gNS8xNy8yNiAxNDo1OSwgQmVya2FudCBLb2Mgd3JvdGU6DQo+IFtZb3UgZG9uJ3Qgb2Z0ZW4g
Z2V0IGVtYWlsIGZyb20gbWVAYmVya29jLmNvbS4gTGVhcm4gd2h5IHRoaXMgaXMgaW1wb3J0YW50
IGF0IGh0dHBzOi8vYWthLm1zL0xlYXJuQWJvdXRTZW5kZXJJZGVudGlmaWNhdGlvbiBdDQo+IA0K
PiBGcm9tOiBCZXJrYW50IEtvYyA8bWVAYmVya29jLmNvbT4NCj4gDQo+IGZ1c2VfZGV2X3JlbGVh
c2UoKSBvbiB0aGUgbGFzdCBmdXNlX2RldiBvZiBhIGNvbm5lY3Rpb24gY2FsbHMNCj4gZnVzZV9h
Ym9ydF9jb25uKGZjKSBhbmQgdGhlbiBpbW1lZGlhdGVseSBmdXNlX2Nvbm5fcHV0KGZjKS4gRm9y
IGlvLXVyaW5nDQo+IGJhY2tlZCBjb25uZWN0aW9ucyBmdXNlX2Fib3J0X2Nvbm4oKSByZWFjaGVz
IGZ1c2VfdXJpbmdfYWJvcnQoKSwgd2hpY2gNCj4gcnVucyBmdXNlX3VyaW5nX3RlYXJkb3duX2Fs
bF9xdWV1ZXMoKSBzeW5jaHJvbm91c2x5IG9uY2UgYW5kIHRoZW4NCj4gc2NoZWR1bGVzIHJpbmct
PmFzeW5jX3RlYXJkb3duX3dvcmsgdG8gcnVuIGFmdGVyDQo+IEZVU0VfVVJJTkdfVEVBUkRPV05f
SU5URVJWQUwgKEhaLzIwKS4gSWYgdGhlIHN5bmNocm9ub3VzIHBhc3MgbGVmdA0KPiBxdWV1ZV9y
ZWZzID4gMCB0aGUgd29yayBvd25zIGZ1cnRoZXIgYWNjZXNzZXMgdG8gcmluZy0+cXVldWVzWypd
LT4NCj4gZW50X2F2YWlsX3F1ZXVlIGFuZCBlbnRfaW5fdXNlcnNwYWNlIGVudHJpZXMuDQo+IA0K
PiBNZWFud2hpbGUgZnVzZV9jb25uX3B1dCgpIGNhbiBkcm9wIHRoZSBsYXN0IHJlZmVyZW5jZSBh
bmQgYXJtDQo+IGRlbGF5ZWRfcmVsZWFzZSgpIHZpYSBjYWxsX3JjdSgpLiBBZnRlciB0aGUgUkNV
IGdyYWNlIHBlcmlvZA0KPiBkZWxheWVkX3JlbGVhc2UoKSBjYWxscyBmdXNlX3VyaW5nX2Rlc3Ry
dWN0KCksIHdoaWNoIGtmcmVlKClzIHRoZSByaW5nDQo+IGVudHJpZXMgb24gZWFjaCBxdWV1ZS0+
ZW50X3JlbGVhc2VkIGxpc3QuIFRoZSBwcmV2aW91c2x5IHNjaGVkdWxlZA0KPiBhc3luY190ZWFy
ZG93bl93b3JrIHRoZW4gcnVucyBhbmQgd2Fsa3MgcGVyLXF1ZXVlIGxpc3RzIHRoYXQgY29udGFp
bg0KPiBmcmVlZCBlbnRyaWVzLCBwcm9kdWNpbmcgYSBzbGFiLXVzZS1hZnRlci1mcmVlIHJlcG9y
dGVkIGJ5IEtBU0FOIGF0DQo+IGZ1c2VfdXJpbmdfdGVhcmRvd25fYWxsX3F1ZXVlcysweGVlIHJl
YWRpbmcgZW50LT5saXN0Lm5leHQgZnJvbSBhDQo+IGZyZWVkIGttYWxsb2MtMTkyIHJlZ2lvbi4N
Cj4gDQo+IGZ1c2Vfd2FpdF9hYm9ydGVkKCkgYWxyZWFkeSBleGlzdHMgZm9yIHRoaXMgcHVycG9z
ZTogaXQgd2FpdHMgb24NCj4gZmMtPmJsb2NrZWRfd2FpdHEgZm9yIG51bV93YWl0aW5nIHRvIGRy
YWluIGFuZCB0aGVuIGNhbGxzDQo+IGZ1c2VfdXJpbmdfd2FpdF9zdG9wcGVkX3F1ZXVlcygpLCB3
aGljaCB3YWl0cyBmb3IgcmluZy0+cXVldWVfcmVmcyB0bw0KPiByZWFjaCB6ZXJvLiBDYWxsIGl0
IGJldHdlZW4gZnVzZV9hYm9ydF9jb25uKCkgYW5kIGZ1c2VfY29ubl9wdXQoKSBvbg0KPiB0aGUg
bGFzdC1kZXZpY2UgcGF0aCBzbyB0aGUgaW8tdXJpbmcgdGVhcmRvd24gd29yayBoYXMgZnVsbHkg
ZHJhaW5lZA0KPiBiZWZvcmUgdGhlIGNvbm5lY3Rpb24gY2FuIGJlIHRvcm4gZG93bi4NCj4gDQo+
IEZpeGVzOiBjMDkwYzhhYmFlNGIgKCJmdXNlOiBBZGQgaW8tdXJpbmcgc3FlIGNvbW1pdCBhbmQg
ZmV0Y2ggc3VwcG9ydCIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgNi4xNCsNCj4g
VGVzdGVkLWJ5OiBCZXJrYW50IEtvYyA8bWVAYmVya29jLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
QmVya2FudCBLb2MgPG1lQGJlcmtvYy5jb20+DQo+IC0tLQ0KPiAgZnMvZnVzZS9kZXYuYyB8IDEg
Kw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
ZnMvZnVzZS9kZXYuYyBiL2ZzL2Z1c2UvZGV2LmMNCj4gaW5kZXggNWRkYTcwODBmNGE5Li43ZDlj
MDY2NTRhOTggMTAwNjQ0DQo+IC0tLSBhL2ZzL2Z1c2UvZGV2LmMNCj4gKysrIGIvZnMvZnVzZS9k
ZXYuYw0KPiBAQCAtMjU2Niw2ICsyNTY2LDcgQEAgaW50IGZ1c2VfZGV2X3JlbGVhc2Uoc3RydWN0
IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpDQo+ICAgICAgICAgICAgICAgICBpZiAo
bGFzdCkgew0KPiAgICAgICAgICAgICAgICAgICAgICAgICBXQVJOX09OKGZjLT5pcS5mYXN5bmMg
IT0gTlVMTCk7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGZ1c2VfYWJvcnRfY29ubihmYyk7
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGZ1c2Vfd2FpdF9hYm9ydGVkKGZjKTsNCj4gICAg
ICAgICAgICAgICAgIH0NCj4gICAgICAgICAgICAgICAgIGZ1c2VfY29ubl9wdXQoZmMpOw0KPiAg
ICAgICAgIH0NCg0KSSBtaWdodCBiZSB3cm9uZywgYnV0IEkgZG9uJ3QgdGhpbmsgaXQgaXMgcG9z
c2libGUsIE1heWJlIFBhdmVsIG9yIEplbnMNCmNvdWxkIGhlbHAgKGFkZGVkIHRvIENDKS4gQmFz
aWNhbGx5IGFzIGxvbmcgYXMNCmZ1c2VfdXJpbmdfYXN5bmNfc3RvcF9xdWV1ZXMoKSBydW5zIHdl
IGRvIG5vdCBoYXZlIGNvbXBsZXRlZCBhbGwNCmlvLXVyaW5nIGNvbW1hbmRzIHZpYSBpb191cmlu
Z19jbWRfZG9uZSgpIGFuZCBhcyBsb25nIGFzIHdlIGRvIG5vdCBoYXZlDQpjb21wbGV0ZWQgdGhl
c2UgaW8tdXJpbmcgY29tbWFuZHMuDQoNClJlZmVyZW5jZXMgYXJlIHRha2VuIGhlcmUNCg0KaW9f
aXNzdWVfc3FlDQogIGlvX2Fzc2lnbl9maWxlDQogICAgIGlvX2ZpbGVfZ2V0X25vcm1hbA0KICAg
ICAgICBmZ2V0DQoNCg0KICBfX2lvX3VyaW5nX2NtZF9kb25lKCkNCiAgICByZXEtPmlvX3Rhc2tf
d29yay5mdW5jID0gaW9fcmVxX3Rhc2tfY29tcGxldGUNCiAgICBpb19yZXFfdGFza193b3JrX2Fk
ZChyZXEpICAgICAgICAgICAgIGlvX3VyaW5nL3VyaW5nX2NtZC5jOjE3OQ0KDQoNCg0KaW9fcmVx
X3Rhc2tfY29tcGxldGUNCiAgIGlvX3JlcV9jb21wbGV0ZV9kZWZlcg0KICAgICB3cV9saXN0X2Fk
ZF90YWlsDQoNCl9faW9fc3VibWl0X2ZsdXNoX2NvbXBsZXRpb25zDQogICBpb19mcmVlX2JhdGNo
X2xpc3QNCiAgICAgaW9fcHV0X2ZpbGUNCiAgICAgICBmcHV0DQoNCg0KSSBhbHNvIGxvb2sgaXQg
dXAgZm9yIGZpeGVkIGZpbGUgYW5kIGZvciBmaXhlZCBmaWxlIGl0IG5lZWRzDQppb19yaW5nX2N0
eF9mcmVlKCksIHdoaWNoIGlzIHRoZW4gb25seSBvbmUgYWZ0ZXIgY29tcGxldGluZyBhbGwNCnVy
aW5nX2NtZCBvYmplY3RzIChpb191cmluZ19jbWRfZG9uZSkuDQoNCg0KSSBkb24ndCBtaW5kIGFk
ZGluZyBmdXNlX3dhaXRfYWJvcnRlZCgpIGhlcmUsIGJ1dCBJTUhPIGl0IGlzIGEgbm8tb3AgYW5k
DQpubyBzZWN1cml0eSBpc3N1ZS4NCg0KDQpUaGFua3MNCkJlcm5kDQo=

