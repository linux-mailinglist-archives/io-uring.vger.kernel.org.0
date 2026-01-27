Return-Path: <io-uring+bounces-11962-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDbONkFceWmvwgEAu9opvQ
	(envelope-from <io-uring+bounces-11962-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 01:45:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D2EF9BB8A
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 01:45:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB3F9300DDE3
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 00:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D042A1CF;
	Wed, 28 Jan 2026 00:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Sf+AtN9Q"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165A11E511
	for <io-uring@vger.kernel.org>; Wed, 28 Jan 2026 00:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769561150; cv=fail; b=jiJ3cJusLBPJwqvZbfp7MupKTMMX4b18pEdT4SKJ2hMcRZGxIFf6yCJWTnZad55aXZOKkjnVR235ij0wwd68ns20oynoY7f0kcjfB2Ikay7NGP8gVNgfsgkR/fQf2x3g94rZA7cvHjFeYbJkr5Bljndg1W3D4b6tqu9gpO9lBI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769561150; c=relaxed/simple;
	bh=YgA4rOlJgzUYDJ3WKwYVY3jrfC8b5Ioa/XThDGpLue0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i//K6mqSiTJ5qRY2Z7tzphanBxe3hTMs3ERbjdxdFXlcETc3ir6mSbQC5eyTpNvrRe+Pvwen7dPv+/cTw/nItkkkF+Om/qAh7iLM+bps8L+P7/RyP7wP93UwEm2N4vqtg6KsnGrMGbpdQ7tjcCg7OBqDxUijwaahBKitXnoFxAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Sf+AtN9Q; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020096.outbound.protection.outlook.com [52.101.201.96]) by mx-outbound21-208.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 28 Jan 2026 00:45:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dNvquhUFG+S2erTLnDt76oVGJrpwgJN3eVcvJdBXtXoPKwvMtJ+oW9RilQkPO/fFExRkTffb1+8aDMyAWKILPszQ9zq4Z2ZHQyID0FQhiOHWcRlewk5Yg7gQx+SEkb4A8iVQ8Giw9oobWQU72gfDHKkLthVkR+xaTN91qebRA3q6Y7GS/5Xx+OOL3TZZDAfPnIxutoFqQ0xDqBThYzMCNsedRiO6VGtWgoyyXFhKJJcFW4elqK6EIrcwug3VZUG/eRpYoJ2AwHIVxLNF1fBK7O//QOUO8bvTzGG1u3SJGQhXPr+EnNuVni9bACkmWqPr0EYjdnLTxEC5z2GbF3XaNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YgA4rOlJgzUYDJ3WKwYVY3jrfC8b5Ioa/XThDGpLue0=;
 b=pM5j1ZSBtWQZj0nB7GN3jfddGR5s5zxkK+0VwPyl3Oz8zJYou48G+oXbJ2jedWljkMV6wybVm/jFA8wvybCsMureviVpcNuORzV1QbiQhKVGc1M2R28uXQoyBYYs+OW6g2SQpFrr4R7T7+5SkigSpcKJ3YojgVni3WwrulrB3ON00u4LwllR89hIYpdFRF6cJQF/zhXn+7FD8rJh+RDQAu0JEEkgUBKIdHwWuzOzDwpokcSNTtnLasIEyjy+/3Piw02ER1s2ZHicy0XDpm1/5syU5WAO85J4FDdFY2Wk4zUI/bN165hFd+AdYHa9Uvf/AGujVKaboQMQppJnTSJsOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YgA4rOlJgzUYDJ3WKwYVY3jrfC8b5Ioa/XThDGpLue0=;
 b=Sf+AtN9Qxmeim4Q/PYakyTp3c6/Rxieb19n1SikN8HydFr59ZzfK2x/egpkTbarV53VyZBEDNQUCFcm4VZB2BV8PhNqS3Yn1pyDh71uV1VPEBDQPPLzd5Fe4PZI2uoWrPZtivXeNOGoXziAXWixI4UmBxvZtb+TA7+ENl7xot+I=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by SJ4PPF551E93D4F.namprd19.prod.outlook.com (2603:10b6:a0f:fc02::a23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Tue, 27 Jan
 2026 23:11:50 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704%6]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 23:11:50 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Joanne Koong <joannelkoong@gmail.com>, "axboe@kernel.dk"
	<axboe@kernel.dk>, "miklos@szeredi.hu" <miklos@szeredi.hu>
CC: "csander@purestorage.com" <csander@purestorage.com>, "krisman@suse.de"
	<krisman@suse.de>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>, "xiaobing.li@samsung.com"
	<xiaobing.li@samsung.com>, "safinaskar@gmail.com" <safinaskar@gmail.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v4 15/25] fuse: refactor io-uring header copying from ring
Thread-Topic: [PATCH v4 15/25] fuse: refactor io-uring header copying from
 ring
Thread-Index: AQHch0BBxv93z/BRKk20NwEjSkUMibVmtiCA
Date: Tue, 27 Jan 2026 23:11:49 +0000
Message-ID: <9748df86-2c2b-456e-9632-86b09bb47c79@ddn.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-16-joannelkoong@gmail.com>
In-Reply-To: <20260116233044.1532965-16-joannelkoong@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|SJ4PPF551E93D4F:EE_
x-ms-office365-filtering-correlation-id: 9791338b-9f6e-42c5-d98e-08de5df97396
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|19092799006|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YU51QWNuRmlCUnFWWW9TOEppLytYdXExZ3Q2M2FTdjBNYVN2cm5XQmN4bFRT?=
 =?utf-8?B?RUR5eUdTakN3NVBtakJRNDR2OTRLV1ZYK3hrUkRmdWtJaGlMblc2ZFdnZmZ0?=
 =?utf-8?B?azN6VEl5NGtDQnUrZVkrcFFPVHhLSEZiS2Z3LzlYYlRFYlp2Nlg5MEptSzZu?=
 =?utf-8?B?YytabnlZSXE5SHoxTzd0RDVhQXgvTTdod3FUdEFLN2JBYUt6WUR0ZDRVVnBL?=
 =?utf-8?B?UWZaOXVSa1Y2QXNrLzJJMElkV2FwMWFpNDk3WXltUm5FMWNZR3Z0aUR4cnpZ?=
 =?utf-8?B?b2NpL0dSWVB0SlJDMUVsa1RienFUd2hwZlBUK2V1RXZPQUlZdnBLVUZyS1M0?=
 =?utf-8?B?MzNOM3BvS0tkK0FxemRieDhVUTNaQmoxa3ZxNHkrbHBhT2RtbkR6eXV5QjY3?=
 =?utf-8?B?YjlnQjd5RHB5dkxEVDU0YlQ0OWRKWXNtYWt3Y3hCOVc3V0l5V3pvZGt0cGRB?=
 =?utf-8?B?SlhCbFZ5Wm03U0x2QzJJZUpJaU5rdnBKN2hKRXFXSDNYZUZkU0dPK3gzcWYr?=
 =?utf-8?B?Z3pNU2trQ2h4VWllQllkMmNmN2w0QVU1ZTFVbmdxSy9xbUM4N3RoMWhseC80?=
 =?utf-8?B?cTIyNk0zSmZScHFBcmF0eTlZWEpWc1NIelNiRGdNWDl2RFozZnlNS1JPSGl4?=
 =?utf-8?B?dTBtbGh4SXpaQUxWTDMvMXFuaEtMdURHSmRJOVk5bVNzU1B3c0ZxYzNISU5p?=
 =?utf-8?B?aHlvcmptaERUZmpOUEtQWnRTZzhRZUFmS3lralppQldmM1hmMHlFUVFNOHdC?=
 =?utf-8?B?ZXpoNHo3clFmOWROa1hSSUcrd0ZRcU9GbTNzbnBtTEV3ZkxKaVpGNlFSWXpm?=
 =?utf-8?B?d0JoNGpwRHQzUmJDYlA3alljRUFVUmwvVEdwaUQxaHZER0thQU5BRlRCbXdm?=
 =?utf-8?B?cUZWLzcxaGMzTi83ZTV2MGVURDZHMDlKUDZabjRzSmtUaUFiazJYeW5SUEtJ?=
 =?utf-8?B?YktLTkcxQzAySWJzSWhDWlgrak9JOHVRNC9WSEN6YjJlWDU1TzZScXVtTGZl?=
 =?utf-8?B?d1RMTVhzdzdDeGszcE13Tmw2VVdPK3UvSVJnaEdTc2w1VHExVmg3L252b2NL?=
 =?utf-8?B?YUhyMm9zQURZSG52WVdoOUpxOW5pOW1KOXBneHVEbHFSYm1OTTN5Ti9TNUVC?=
 =?utf-8?B?SWNYc0k1Vyt0cldoaFpiMW1NOS9EbVk2QStNNGZBTTc3czF0WlBEeFJ3SGNx?=
 =?utf-8?B?ZmZ0Z2syM0NwbEt0WjVXNElMdlVMS3Q4L1g1RWg3MWV2dHp1OTVkbjZIcFMy?=
 =?utf-8?B?dkRhUTZPWElpR0dFR2RJYWRvVFNmTkFqQ3BBNGtXNzlXZzFaN1cvT3JRWXhr?=
 =?utf-8?B?ZnVPQnc1ekt4QUZSRWZpeWhocTVFRGRWMlBQcU1jYUtyUFZVZVdBSUdid0JS?=
 =?utf-8?B?cFlJcjgyeGx6WXMzNkZzYnhSTGhKbUJmamg1WDlVbjI5dUFUVW9SaEdsYUpq?=
 =?utf-8?B?MDNiS2RtVWxrWFZ5UEs5a2VRcVdNdjJCeFJOZnRnSnV3UGhCM01nWFJWbm9R?=
 =?utf-8?B?cWpRaTFtbW9ucC9WblJkY1dJbVJnUzNqVzdlM1lGUDh5QU9zNEs1N094eEsw?=
 =?utf-8?B?UitySXlPOTlsWU9ZaDJSZkd0c0dPR3ZNS25mbnJRV0hCZWdqRUdtUFRLTFBw?=
 =?utf-8?B?YS9qODBwNDNGVTRSSm51a2RoVDdJQmpjNWVuUUI2QXdTdWhGcWFiRkU1MXF3?=
 =?utf-8?B?VmFvWXUrUVd4eEtLMnF0MGdvZkM0S3hwYWo2RkFFL2VVL2ZyOGFPWVo3c1RB?=
 =?utf-8?B?ZE1hNWlpUytxZlNoOC9VcUZQSHZoK0lZMlNJTkt1U2NIZzE0bmIwSFUrMDFv?=
 =?utf-8?B?eGZJUHROd3JHOERpbm8rQTBBaTlhMGprY09Wa1lQVFBqK2ZvNFkwZ2tUSVFv?=
 =?utf-8?B?MDR5VFdQSHZZbEF1dXowL2dsRm90Vkx3K0hwenFYbVhTSGlXckRQS2h4YUtN?=
 =?utf-8?B?cFhpK0FxQ3crbG9LUTdsREZwNmJqSG5mWVg3NDltMXhCZzBoRGdEZ0xmRHlP?=
 =?utf-8?B?WXFielNFRms2RTNLV2tRV0tiallqWTZmUnlkd2ZNQ1FaaXNmT3hYVEpsWXdt?=
 =?utf-8?B?aWhtOEV3QUkzWVEyd3pKbmlLYVBSRkVLMThTdFRKYk5SYkpLSldySHdxSTFm?=
 =?utf-8?B?TFI4OFFmeWZTUGhpTTNrY2tISzRkS005OUZ1bWprcUM0NEpiaG5CUHFuRnp2?=
 =?utf-8?Q?omI/800eDSC7wONPLglrzEc=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(19092799006)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VEUvNTQ1KzV2bmNJSE9sN2tlSW5MNVRpY2N4eUZ0UlQ1WTI1Uk53aStKc29X?=
 =?utf-8?B?UnhvOEZZaTZvMXJ6TUdjL3RaUTJ4N0wwS3RSOUdDdEhQN3c5aTlGd3N2TjVG?=
 =?utf-8?B?bWZKVG1wZ2pqV3lreXkyRGNRZHRIUTQ5YXZialBaMk95UUJDcm40RUhMdk5P?=
 =?utf-8?B?REVtV2VmeURqVDVZWTVDdjZtL3lFTk9NMUNxUkRVNy9kbnlhR2NZQjk2SzU4?=
 =?utf-8?B?UXgrRkhJTUJGNzRNMUVWT1IrcFZIUi9jQnYyblRLMnA0SXNTNEMzQmZ2TUhO?=
 =?utf-8?B?SXN6OUx6cTBsRUtJd0g0eGdocWxOdkFjeWU5d3liVkFTOXg5UVNaR016a3hp?=
 =?utf-8?B?dll6YXpQUVppWWIrb1VpRDFQWXE0UnEvZ3VPaVN4VGwwaXJYNDhJNlMvQ0VS?=
 =?utf-8?B?dUYwWnozRVJZdzZoais5RG93dFBYNVoyMnJRN3dReEw4aDVjblh6MEJPcU90?=
 =?utf-8?B?VkE5S09Dc0VIMEt1ZmFLSFFldXpRQklYRDNYdC9jSStwOEdSWnU4TGJmZFBD?=
 =?utf-8?B?R0VUcDZrM1dFMmRzVkFPbHRaTWo3dExPOXN3bDVUdzNRM1lyYnZJYUFyamhu?=
 =?utf-8?B?VkhpTi93Zm1ITytNMjU5SzhRVlFFTURxSlZMWFRSZ0c2RU85S293eTdxTkJk?=
 =?utf-8?B?dURkdUJVVVQySmdzTThqV0tCb0U2RXV3ZDVBZ3RnV2IzdzQ1eFp1ZmRTZG9k?=
 =?utf-8?B?YUtPcjNDR3NQeldyT21kTGF3dkphVzFtcW5ZeGYzKzlFZUJxRUczSm9nclBQ?=
 =?utf-8?B?VEhMeEU3L3p5S2w3ZjhBOEx2dElRNkpWbkM1cmxYLzV2RUhKTS91K3Q0eVg0?=
 =?utf-8?B?RmJ1dVN2MUdmZzMyRndQcHJNVEp4bDVsOFdOZ2VFWmFualhVME84NlJpSGpG?=
 =?utf-8?B?QlBPTHdXUmhjZzhLQk1BckRsNGNwL2xhWmo1TVozUkdLcVFUOWgxTHFUWW8z?=
 =?utf-8?B?S2JNODdnUVoxQUhUbmxRTDQ3SXRzUnprYmxmSnM5L3R5S2RTSUZSbk0rNUFR?=
 =?utf-8?B?NEEvNmNEL3ZhaUJVQnBtaVB5T051MmhsN3ZsNldqSERtNHlyMXZQWWdCeU5n?=
 =?utf-8?B?a0REc3NRMkw3ZG02c2Nic0ZDWTNJWVhXTHljaXU3a29meGM1U2JydVlWWnkv?=
 =?utf-8?B?MEFKbWt1M3VJV052SE01dFdkUkxXSXFPNkRlbUs5T0ZxU0VKOHhSbWhNRUNR?=
 =?utf-8?B?MkZ5bXZUZGQ0WnVxcTVvMUtKQnlnRExuUUx3aG9mdSttZ25Dd25NRmlna09V?=
 =?utf-8?B?eXJLajBFWkdCRWhGSWVSVXlBWG9WRGd2djNLYmhhdjJwU2U5VEM1dEJFWGtT?=
 =?utf-8?B?eGpKTnJoSy9wNHpGL2tEWWxMcFhDL1MyeTNLVlFxS0srQ09FTFpaVnRyS1F2?=
 =?utf-8?B?dW0yMk9LY1ljalFFSlRMazV6MFB6UWdGQVYycUIvVUZremlxaFRvQTN2UFRK?=
 =?utf-8?B?TmpsbGtjQWNCSW5pdXcwMG1BUlgwYWthNjIwQUJhenJFOG51R0FSbUE2bGxH?=
 =?utf-8?B?UWR2eS9ncy9jTlFyRlpmS1dLcGVwZ0ZDMTdTTllGZUZUelE4dlhhNXkwNERC?=
 =?utf-8?B?cU5vd1hzNXZIU2ZKOEpZSkJmamM4VkZWMG1WL283ZTBzdVFHMXVrUHM0SGh1?=
 =?utf-8?B?T1ZDSmVycGhzdVlDUVY1dk1SYWNVa3pCbWxOTTJ5SGRySmhTaVZweEtmWUtx?=
 =?utf-8?B?Q1A4SEUrbzZ0Sm0wN3hCZjV0bklOTmo3WWl4WTJRNGltSHZuZ0ZhQjBhMkFs?=
 =?utf-8?B?alZNUkhvMU11Q29UcEYrRmJTVDNBcHB4V2FoSUlwN2lUaGh2YUxQN1lYTWtU?=
 =?utf-8?B?VFNHVzRkdDhTUDdkUDZaTXRhVXZ4djUxM0JwRVBwTlRkenlsL3FSakM5Q0lG?=
 =?utf-8?B?ZmdsYjl5MEJTMm1jOVdxWmFNUVdCM01PYUFacjR3aVYwQUxGMzFJTlQ1K3h3?=
 =?utf-8?B?dmcrbUVENWptZXNDUkZac09hOXM5YTFlTGM3YmNEbmxqYWQvcVZ3bE10Mzhz?=
 =?utf-8?B?cityUnVaUzFJeEYxdTdIbmtmdWVEMjBOOTFjZEVZaG9ubXdhWXAzWWlZZkow?=
 =?utf-8?B?d3dvZUhwVkplaU10SFB1eVFCVDdLdHhHdmRrQy9iSWFMbllKMURaTWR4dE4x?=
 =?utf-8?B?QUN4NXBVaUVKa082NVJOUklIMEtrWm1pYjRtRGlvWlp4akJNMVpURzZXTWt2?=
 =?utf-8?B?eHJyT1crWEpOeFBESWxabFZ6Z0wrV0R6VW1PL1ZzQWE0aGZXZnkyencycXE3?=
 =?utf-8?B?WlNIUzJwV3FGVFg4akhMTmVQRktJeXA4YzFzQkR2L0hITXpNVysvaHBNV0Jk?=
 =?utf-8?B?NUtYc3h6djE1OCs0WnRsYlhQSUVpSmFnMisyOU5KZThZL2lka2tJQWQ3Wk85?=
 =?utf-8?Q?AGov2mhzNl4Opbd33Z9q4tGWbTERMgHAxpfgD?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B652ACBA53C7F04BACEFB9F96ABA9240@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 K6P6aG0zJgM5OPFEkG8rz5ZcgTAgCvFcwB12b18nxwdtoO4PSJs2rfeBIhHM33P1iZe0c+9eYmkvGljf7ptzwgcooaKsJEl4hBNx9EwqIKAIyEdaBsyE65Hn377NG3GGycAuhjlm3OZc5Dh3Gw0yX0MFhsSrfvmUtbN6RoTH6dgKsW75ZdH0LpfQZUYAZF80QF4xM6RxTdY1mC5ZMRcZoleYpccUKomn2APcjs3bhuWrp6npbx4l6dZNeVIkPSzHiv/atbLVrTOWnZfs9kmwFS/PbTWhl1A1kqYFc/68cCuy7MagwrMrDWa/scNakl9DPghup/WwKpH++rCGFjWtMWvCZQ9FIPsWE4zpC/tZuYaMExN8N2Z+KR4wAKOcRXtVO0nVoD8mWvuMgXAJ48Rjcd6gNo6cMSw2fnmSuaka5LuXauCdLIGfgsI8tMIxLWStlTCKIRTjjj+r33+Kts/IdPrHCuFXJ+TlQvjdYR1uEHq2JDmWSTfxQPlXqayizMIB8IlNsfkUau4sUwkw2rBv+3I+JjooqKHO5qbnEBxjK9RPx03ZLGlipO9MObVlodFmdktZcS2+yhTXtvpfwftfrGzLmm96iLsD5kuq5xPZ7woIZ2xWWNiC/DHW+o0gcmAUqPjtrjvFp9JBhB3U0YFuXg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9791338b-9f6e-42c5-d98e-08de5df97396
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 23:11:49.9654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: olEiJYgITD6Iy2fwCCTKjDMYd+NLQXLxUcPkSoU1dBEf9KC7Sb5i3YU5D0HKrbJOP5bST1DwzeOQbBKGwognHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ4PPF551E93D4F
X-OriginatorOrg: ddn.com
X-BESS-ID: 1769561147-105584-7690-22798-1
X-BESS-VER: 2019.1_20260115.1705
X-BESS-Apparent-Source-IP: 52.101.201.96
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkYGpiZAVgZQMC3FMs0o2SzRwN
	IsMdXYNC3NIMU0JTU1ydg0OcXMPMVSqTYWAOrQKINBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.270715 [from 
	cloudscan10-187.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO
X-BESS-BRTS-Status:1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.44 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[ddn.com,reject];
	R_DKIM_ALLOW(-0.20)[ddn.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11962-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk,szeredi.hu];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[ddn.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bschubert@ddn.com,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ddn.com:email,ddn.com:dkim,ddn.com:mid]
X-Rspamd-Queue-Id: 3D2EF9BB8A
X-Rspamd-Action: no action

T24gMS8xNy8yNiAwMDozMCwgSm9hbm5lIEtvb25nIHdyb3RlOg0KPiBNb3ZlIGhlYWRlciBjb3B5
aW5nIGZyb20gcmluZyBsb2dpYyBpbnRvIGEgbmV3IGNvcHlfaGVhZGVyX2Zyb21fcmluZygpDQo+
IGZ1bmN0aW9uLiBUaGlzIGNvbnNvbGlkYXRlcyBlcnJvciBoYW5kbGluZy4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IEpvYW5uZSBLb29uZyA8am9hbm5lbGtvb25nQGdtYWlsLmNvbT4NCj4gLS0tDQo+
ICBmcy9mdXNlL2Rldl91cmluZy5jIHwgMjQgKysrKysrKysrKysrKysrKysrLS0tLS0tDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9mcy9mdXNlL2Rldl91cmluZy5jIGIvZnMvZnVzZS9kZXZfdXJpbmcuYw0KPiBp
bmRleCA3OTYyYTk4NzYwMzEuLmU4ZWU1MWJmYTVmYyAxMDA2NDQNCj4gLS0tIGEvZnMvZnVzZS9k
ZXZfdXJpbmcuYw0KPiArKysgYi9mcy9mdXNlL2Rldl91cmluZy5jDQo+IEBAIC01ODcsNiArNTg3
LDE4IEBAIHN0YXRpYyBfX2Fsd2F5c19pbmxpbmUgaW50IGNvcHlfaGVhZGVyX3RvX3Jpbmcodm9p
ZCBfX3VzZXIgKnJpbmcsDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBfX2Fs
d2F5c19pbmxpbmUgaW50IGNvcHlfaGVhZGVyX2Zyb21fcmluZyh2b2lkICpoZWFkZXIsDQo+ICsJ
CQkJCQkgY29uc3Qgdm9pZCBfX3VzZXIgKnJpbmcsDQo+ICsJCQkJCQkgc2l6ZV90IGhlYWRlcl9z
aXplKQ0KPiArew0KPiArCWlmIChjb3B5X2Zyb21fdXNlcihoZWFkZXIsIHJpbmcsIGhlYWRlcl9z
aXplKSkgew0KPiArCQlwcl9pbmZvX3JhdGVsaW1pdGVkKCJDb3B5aW5nIGhlYWRlciBmcm9tIHJp
bmcgZmFpbGVkLlxuIik7DQo+ICsJCXJldHVybiAtRUZBVUxUOw0KPiArCX0NCj4gKw0KPiArCXJl
dHVybiAwOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgaW50IGZ1c2VfdXJpbmdfY29weV9mcm9tX3Jp
bmcoc3RydWN0IGZ1c2VfcmluZyAqcmluZywNCj4gIAkJCQkgICAgIHN0cnVjdCBmdXNlX3JlcSAq
cmVxLA0KPiAgCQkJCSAgICAgc3RydWN0IGZ1c2VfcmluZ19lbnQgKmVudCkNCj4gQEAgLTU5Nywx
MCArNjA5LDEwIEBAIHN0YXRpYyBpbnQgZnVzZV91cmluZ19jb3B5X2Zyb21fcmluZyhzdHJ1Y3Qg
ZnVzZV9yaW5nICpyaW5nLA0KPiAgCWludCBlcnI7DQo+ICAJc3RydWN0IGZ1c2VfdXJpbmdfZW50
X2luX291dCByaW5nX2luX291dDsNCj4gIA0KPiAtCWVyciA9IGNvcHlfZnJvbV91c2VyKCZyaW5n
X2luX291dCwgJmVudC0+aGVhZGVycy0+cmluZ19lbnRfaW5fb3V0LA0KPiAtCQkJICAgICBzaXpl
b2YocmluZ19pbl9vdXQpKTsNCj4gKwllcnIgPSBjb3B5X2hlYWRlcl9mcm9tX3JpbmcoJnJpbmdf
aW5fb3V0LCAmZW50LT5oZWFkZXJzLT5yaW5nX2VudF9pbl9vdXQsDQo+ICsJCQkJICAgIHNpemVv
ZihyaW5nX2luX291dCkpOw0KPiAgCWlmIChlcnIpDQo+IC0JCXJldHVybiAtRUZBVUxUOw0KPiAr
CQlyZXR1cm4gZXJyOw0KPiAgDQo+ICAJZXJyID0gaW1wb3J0X3VidWYoSVRFUl9TT1VSQ0UsIGVu
dC0+cGF5bG9hZCwgcmluZy0+bWF4X3BheWxvYWRfc3osDQo+ICAJCQkgICZpdGVyKTsNCj4gQEAg
LTc5NCwxMCArODA2LDEwIEBAIHN0YXRpYyB2b2lkIGZ1c2VfdXJpbmdfY29tbWl0KHN0cnVjdCBm
dXNlX3JpbmdfZW50ICplbnQsIHN0cnVjdCBmdXNlX3JlcSAqcmVxLA0KPiAgCXN0cnVjdCBmdXNl
X2Nvbm4gKmZjID0gcmluZy0+ZmM7DQo+ICAJc3NpemVfdCBlcnIgPSAwOw0KPiAgDQo+IC0JZXJy
ID0gY29weV9mcm9tX3VzZXIoJnJlcS0+b3V0LmgsICZlbnQtPmhlYWRlcnMtPmluX291dCwNCj4g
LQkJCSAgICAgc2l6ZW9mKHJlcS0+b3V0LmgpKTsNCj4gKwllcnIgPSBjb3B5X2hlYWRlcl9mcm9t
X3JpbmcoJnJlcS0+b3V0LmgsICZlbnQtPmhlYWRlcnMtPmluX291dCwNCj4gKwkJCQkgICAgc2l6
ZW9mKHJlcS0+b3V0LmgpKTsNCj4gIAlpZiAoZXJyKSB7DQo+IC0JCXJlcS0+b3V0LmguZXJyb3Ig
PSAtRUZBVUxUOw0KPiArCQlyZXEtPm91dC5oLmVycm9yID0gZXJyOw0KPiAgCQlnb3RvIG91dDsN
Cj4gIAl9DQo+ICANCg0KUmV2aWV3ZWQtYnk6IEJlcm5kIFNjaHViZXJ0IDxic2NodWJlcnRAZGRu
LmNvbT4NCg==

