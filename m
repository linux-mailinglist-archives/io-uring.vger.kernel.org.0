Return-Path: <io-uring+bounces-10650-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FEE5C629E4
	for <lists+io-uring@lfdr.de>; Mon, 17 Nov 2025 07:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 98E6B34346D
	for <lists+io-uring@lfdr.de>; Mon, 17 Nov 2025 06:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 542D226463A;
	Mon, 17 Nov 2025 06:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SMy5vPqi"
X-Original-To: io-uring@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010014.outbound.protection.outlook.com [52.101.46.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE6E314D32;
	Mon, 17 Nov 2025 06:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763362770; cv=fail; b=o+jM2mVDn+MScN9kwI5bdyFdnydyEx20L5udxo394cULxq83hX24ErcetOIebbEJUCEs1RRmQHGZ5Eds+5ILDeD/xRamKwwfrtyv4WGnFlxMb8lP6GPh7Luwji1KrBYsSPpjY0LrLNPLdUXH3F3zIw/+BokFNPDpNoZK51z95Ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763362770; c=relaxed/simple;
	bh=NnL0VYs9pcNFbZK0xIXxXxLIQa/g08U8jV9M6xnOWNI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=THh6KswtbPrlxB+k3GqeflpMQALP6amqiwn6LOE/IDsXqTWeoS5aeCd8DZwYgeX9p/ScarubX15RlqkBKMPbQrgINcCs44Z86tu4tdInFa/qSw0LfqQeXa07HkQd74gcKBDzcCdq7xx9NXsJs9aJI8mHreg9GO7C/ecjAMJULVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SMy5vPqi; arc=fail smtp.client-ip=52.101.46.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pbykD9kDpWOyI7Sfp+PsDeXIXhCFqrjyhsrG5LhjcuymSOgHcq4qMDFMqWDURX3KCv1AwJWA7Gen/sGiy9fFXjwkpO+OUiqdwP7LXADpYkPLBWkrOSCNFBsEzPJX5aEqqZEURfQkV1DeYCjkcqHNYpVHVRMYkOxu64prW0D8mN8HOc9qxIAZRFMPHrwE7sZ+qI7n52/5SYxLrdy/MgbEE6PHCBNkgSYXySaNv7CbkhEOOrvPZWVvqCf0abN4otMkefhCRv2vLHhBXvjexJTxKKK2QNE5Vv8wwA9CK/8zewwGBmImnd+HpE2NxYKVqka3ylD/CulGx+URksaRs4Mm3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnL0VYs9pcNFbZK0xIXxXxLIQa/g08U8jV9M6xnOWNI=;
 b=KsrBXYYNdKX53ek97pwEcUhZ15BJgb/iO+XZHV1gHDwizHAMLf82nKx3KuDk2DEs1VFo/rMXYCLCyW3Swt3aEAmpnf8T+OVtcqoBj47ZXnQVjRAFHN0yrCRXARtrZT7/9fO8Z8i1IxM7U3MxLG8aTvBziaX7IrvTScS/XTaak+IQx9I475mZUUgqbIZquM1yzIGpgSKXMCwdvScfJ8xphAeU6g0cV9MYVKq6uH9T0rEp0NUU+sfLAHh1H4CKEdMr6H7rXm7rGN+3En5Bv7epj/PBd7EHigMqs6eCEp7pWA6daSdLzlfeIyozF+XxPk8BrZfxb5CnZdqCz6TNY2a2uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnL0VYs9pcNFbZK0xIXxXxLIQa/g08U8jV9M6xnOWNI=;
 b=SMy5vPqiam1xlbYI/Vqt+4WrOS08qu8lLI2CrxPNBYvcHu4XZolcHFaemTvBGPZ5gUL5HWedEEAKOo/r4UInWAyICCnqOg5lmCrQAxYit0Izg8gLFl8Y0KWyqlwl+zA6qDy/WK+4sIjH+gBrv9cjxlNoFmG+kFSLsQNwFMiellafBcuhQN0ZFq6V2FesdElfKxERCBhSpjaLRjuIGgzW70JQGR5aI4JcGNn2Ibn3tWKFTtePp2K+YXjA1mQOF6qyfNSzEcb4h6CEeTJneeezWL3ixVIMVlWoCA+8m32TgURN15RLA7DPg2/TcRaxooICZxS//Oli9iKjTn11CGLU8g==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DM4PR12MB8476.namprd12.prod.outlook.com (2603:10b6:8:17e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 06:59:25 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 06:59:25 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan
 Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg
	<martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>, Stefan Roesch
	<shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"gfs2@lists.linux.dev" <gfs2@lists.linux.dev>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>, "linux-unionfs@vger.kernel.org"
	<linux-unionfs@vger.kernel.org>, "linux-mtd@lists.infradead.org"
	<linux-mtd@lists.infradead.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 05/14] fs: remove inode_update_time
Thread-Topic: [PATCH 05/14] fs: remove inode_update_time
Thread-Index: AQHcVTBiwUSB3E2AHEWv38LZRJBLirT2dQqA
Date: Mon, 17 Nov 2025 06:59:25 +0000
Message-ID: <813f36d3-2431-4266-bb2e-faa3fc2a8fd7@nvidia.com>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-6-hch@lst.de>
In-Reply-To: <20251114062642.1524837-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DM4PR12MB8476:EE_
x-ms-office365-filtering-correlation-id: 8fbedf17-37b6-4d3c-5a18-08de25a6d85e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q3pzTGNFYkhCMkpDbzRMV2JJNzBwVk9oUlViaGxMUmE4aW43M0RjbGtmcCsr?=
 =?utf-8?B?aWhQUnRCak5DempWc2tqMEJMVW9hS3kvWUxzRmNDbUlUUjlSaFRldGszN1Ns?=
 =?utf-8?B?ZjZtVHh0Q3dSNTFHcHNpYlRWaUNGNThmVzV1Qmt3b1BUMkRDZGRNNXhxT1Fp?=
 =?utf-8?B?R1RNMmxwNDBES3IxN1JoNVFpSUpNZmNoTkRIUXRUY1J5Z3ZjdG5qcVVNNjkz?=
 =?utf-8?B?alhjK3ZzVWRLazdjaWZHVERkNHZSZG9STzAzWE9nME1BWHJ4ckhkdzJPVGts?=
 =?utf-8?B?ZDZZR0NXZnhsN3ZHanhxU3VqNldyYnMyczJ0WWtVNzFpMHYrRmVhWFdSUDVT?=
 =?utf-8?B?ampaMzkrVVNxSUJkMktzY2ZFM0xCMTBLT2V1dFNNalNkdmk3R0F4R2NmSXpz?=
 =?utf-8?B?L3ljb1VZeGZSSnFkQWxSMklyZHdudkJEeVBWcWFCNFBNVGtvR2lXYUVGR2ZJ?=
 =?utf-8?B?NHlOcUpUb05OTU02WkdxaFRtS1NEQTBmendWY283Vk15eEYrTzd1MEs5ZXRD?=
 =?utf-8?B?YWZMMTdualEwWkJ4R1Ftd0xOMVVkcW5FY0VMOTVYQjdYaVJoWERlZDJaZGVF?=
 =?utf-8?B?eVhKQTczRWtyUUJZaStRa2tOaHd2OEE2Wm85UWpaRnZkZWt2ekplKzJLN2h5?=
 =?utf-8?B?QWtJZ3daTU43ZEFCbGhpclRnR3hCeXUyTjNINTFjeGh4cUZ4TGMrb1JJQTZB?=
 =?utf-8?B?UDduM0hFaTNpWEZqY0F5T0JjQ0xXYzVCaHNKa2l1ZVlaRFUxd1F3MGRaaEZy?=
 =?utf-8?B?YnUvZC9ndzhUUzU1Y2FuamtZWWc1VGJZN0JEVEtiQlpOTGhvVEhhRTFWd3M2?=
 =?utf-8?B?Z3NTbFh4clhiRmxNN0piSElyK0NvSTdFUVE3WnV3bUpxM2gySXlDcnZHbU9n?=
 =?utf-8?B?bkJHVGZjUHZ2YW9LZ3VqR3ZwUjYyQ0d5d0JLdjdmYmlseUxCQ2dTVzdJbG9z?=
 =?utf-8?B?eGpFZjlhK0NqUEtvTG5WZjFnOWtVOE1tckxUc3g3dlRqRFlGSUdnR2JEb3NC?=
 =?utf-8?B?aDdGSk1ZYUxHTlp3ME5WUjUzVCsyQUlOVjJtajMySVhMS3BZSFZEMmhMM05u?=
 =?utf-8?B?U2s1OU04SnM3aGsxT3ZsaUhFNkFmQkRmZnZmRzVvRG8ycFJSL0FiSmpLam1T?=
 =?utf-8?B?L3crZS9SWHJtUXE3K2RJd3pSUGgrQldLUE5yM09YYWNMV1lISm40VG5FYnRO?=
 =?utf-8?B?L1J3RUpZMW00d0V2bHl4YXA3NW85eVNyMUg3dThJbDVqOU4wZ1RxRHRNZFlv?=
 =?utf-8?B?TW5oTFpHNUZCVlo0OURQMnVoZnRUUDF3Y0xmTGZNNWwzaDBtTkJsWTFnQTZm?=
 =?utf-8?B?K1ZqUjV1aWJCS3lvTDN2R25sR3lzdkhVWTJWaFhhSENBbTJObjVSL092c0dL?=
 =?utf-8?B?V0Q5azFmb3NRSnJXT3c0TXhmeGgwYWUzWE9rNVNaOHFuc2YzbmZGcHl2ZTZF?=
 =?utf-8?B?YmYzWWdZUVRNOGYwTmFxUTlaejRMRTE2VXZSL0pXdVUzdG9zWWQvOE5kK0Fo?=
 =?utf-8?B?dk9sdG5OOEZSSG5ZWjMxT0F4WHNVUEYrdS9BZ3RxTWhaTTF5R0R1QTRDNWkv?=
 =?utf-8?B?MWpSaU9CRDdjd2RFSVhZNllSSFZYbUFxc3VFczBib2JOa01NSW9FOUlJZ1RT?=
 =?utf-8?B?OG1ReE9sWFVqYzVBc3NMTmJvN0hQYUJwY2x4cStTTnQ5TVBKWTBzT25YUHds?=
 =?utf-8?B?ZHpEaFNsdVd6VDdxbVkxNUJlUkpYUFJuQlNoTlE1eXhPMTRKNmxpWlUvM3hC?=
 =?utf-8?B?MzFWSlhxdVJaNThjTUR1RHE0QVFTRytHcThzUXVOTHA2YWxmTmZlalFWL3Fx?=
 =?utf-8?B?aTk4dEJ6SC9DK2k4Kyt2OThSNDgxNFZvVU1TeXZBb2xxaitTS0IyaFFaeFRV?=
 =?utf-8?B?U1loQ2UwK3BzVWVHem9CYVI2UDE4c1ZUeXBPSVF5T2FXKy8wMHZmRFBaZGNi?=
 =?utf-8?B?ZDlTWkNRSlNOL2VoT0o2RmhzdG82Sm1RU0NNbVY3dTJxRDNLbnZtdkw1UDl3?=
 =?utf-8?B?QzlyRm1uancxL1Z6dWI5Y1pVRWd6N3hXQTlKWUw0elVQYU5HWk9NUGZCTzU3?=
 =?utf-8?Q?g1FrFD?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TmxWQjdPWC8xaVBFNlBqZjRUb1I2TnJDS2Rwa29tVXdrRmNmdVY0OU1qN0t2?=
 =?utf-8?B?MFFyTWlqYUw2Y0NqSVg0REoxRmFZM1hUVjFGeFJ5dXYrN2R2VnJCWDQxSW0x?=
 =?utf-8?B?K3FLang2c2YvRXJyQ21jd3F6RlF5MU5FUnQwTzJ5WWZxbG1NNUhJcmlDUXJG?=
 =?utf-8?B?bjhrOFpqZkdkcUZLMnAxS2w0YmpqY0JxeGJ1ZWtWMEtWVktXcUJkMm42Mk9o?=
 =?utf-8?B?RnBRNHZMY3l5ZEY3em5Oc1o0eU9OKzY5UVczZUMzREFXeXUxbTZUYllPMU5l?=
 =?utf-8?B?Uk5nVktXQzVvM3JmQ3ZOTFhxSG5Lc2xWM0xWeE9UUk80NzVSckRreUJXTEs1?=
 =?utf-8?B?ems5RFFmNHdDdjNac2liOUMrM3YxcXdTMHU3ODFwZUg5bjl3czhVekpUUHl3?=
 =?utf-8?B?UzFGOTdZZnVJNzcwWXptTGVxeWJ2c3FZSW4wd2l5SURBcGpoRGNobWo1d3kw?=
 =?utf-8?B?bWlqMDRVeXAzYmIvY2h5QXhwMEc4SDRGekN6VnlEaUk2cWxUK0c3eUdMQXZT?=
 =?utf-8?B?eWxUcS9KTGJYZ0sxSGZYTDdhaTVyQWRUdEJwWHJINUNMMXNERU1HY1V4UkxB?=
 =?utf-8?B?MkttSi9JYXhCaysvOEZZZ085S1BiN2JyZnZTdDhtVmlFZGduM3VmSXhJK3BZ?=
 =?utf-8?B?MGVUQUg0cldPdjdkcmdpcDlOR3Vxb0V1WHJqVXgrS282OEFtNU1vTE4vbDBo?=
 =?utf-8?B?dzFNeklVWUgvbERzNWo5bGJoUEZMWUc1ZVhKSktTbmpERmx4WXV6N29OQjly?=
 =?utf-8?B?VWw4VTAybjBYUDlnMnc5VjJRZ0YwZTltZG93NVllQzVFY3JuZ0FmNmo1bi9W?=
 =?utf-8?B?eVArd0J6ZU9sVm1nQ0pXWlNrV1ZJeStvQVVzZGdlMFBBbUdtWkhzMTBvZnBa?=
 =?utf-8?B?TjMxWGVubFhhMFpyaS95eWtkd3UwdGtFN1lMaHFFMnFBMlNybHZrYXRXM3NX?=
 =?utf-8?B?eU9FcHNQQnhJc25Ec1ErWXVxRGxkWWJjMUk0aGdFYit3VTF0dkdnVWVTUUd6?=
 =?utf-8?B?UFd3SU1GVjJnS28vYnVyTmlHb29JeUlRSlhLOUpuY0V6VHZJU0dVc2RiM3BV?=
 =?utf-8?B?MmlxY3hCUEppWjVJd1ArRkRRaDhhRTJvUWdGL2NGSFJORmJkQ0FjQ2tpV2My?=
 =?utf-8?B?OXZnWW1EbTgxMWJleDMzVFo4emI2VzlMcUVMZnpTNjFOWnk0YW1jbm94ZXdC?=
 =?utf-8?B?RGlRTW5tbWtyZnVRTXJzWVFLSVFkTFZxaUpUSDBCWEx4Q0hodjNTYlVWeExF?=
 =?utf-8?B?WFNOMStDWTdWLzREZXBMZVoxc0g2eS9NRXgydEluUVY3SGxxWHh5T2ExY3g5?=
 =?utf-8?B?SmhhODRLWWoyLzJqemNOcW85N3VTd2dNNE5XMmR2OTk3cnJrTG8wdDJTTmZl?=
 =?utf-8?B?dGxqVWxza0d5bFEveWpYenBiVGRDSGZYbGlmRFZtWnkrYkpqcmsxeSt2aVlW?=
 =?utf-8?B?bk9jT1Z3bnE0WUdNNm9YWS91V2xyYUxXcW9UYWxWdGE3VmZIcnpMOGo3Um1n?=
 =?utf-8?B?d2JOUkhKdmM3aHlzaE5wdVJvellkZkxBM2h5V1NwV3FSc0EyRTVOUDc1TEtn?=
 =?utf-8?B?VHBXLytGYTdISEo3RlUyODFJRHJ4dlBVcG5mcGFJQTkrZStyVVVxUjF0WEx5?=
 =?utf-8?B?bE01Y3ptSjFFWjVzRU4yMW1hd2xnaUloUWJuUGh2M0JjazZDdnVITkx0dFBT?=
 =?utf-8?B?bE1RR1Fqb1FXNTE5dnd4M0tiU2Y5RlRXbnRVYVpWdmdQUlVBd2NGQTVjUC9p?=
 =?utf-8?B?VTdIY0JIMmJKSlR5VVNqbmY5NmNKMmpWOUhpUGZoSWFZM2xFdCsyc1RyNWov?=
 =?utf-8?B?N1M5VE5tZGhQYUt5NExGajdpR0hTemIrTGRHeEcyd1I1RFZOYzVTWkFFaGVy?=
 =?utf-8?B?VHRVUGdDMFBXWEc1d2dLUUdXbHQ1UUEybG9UVUQwNzgySVJlcDZpVEhKR2lL?=
 =?utf-8?B?U3NzN0ZOV21MRlhHWnZ6QmpCWVNuTjBQdzZjb3BWWndyc2pXSTVjNGIvdGdM?=
 =?utf-8?B?QyswUnJlbmlXaUU1L2dPeFlIZHFVb2JOUXNUTmY4TVR4QnpCZk1kVncwT3hY?=
 =?utf-8?B?R2o2NWcwMWE3eXhNQ1dSa2x6cDdWU05XbVlYMEV3czdpc1JzYlhYQlBHMktQ?=
 =?utf-8?B?VzlqcFVCVWs5eEhsZ0l6SmJsVUduMDJvZ2UrZzYyRkkwaGRKeWVFTkExWkE4?=
 =?utf-8?Q?SyrC8bT7ROQ2tDy6l3Iynfwe6jcZ+LuOtRHJfZ9U1hgb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A85C1C2F4438D44A95DE0DB85603A75F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fbedf17-37b6-4d3c-5a18-08de25a6d85e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 06:59:25.7893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fUFYBxpHnuSMM3dDtSnWP/GPdGhX8ZMUoZI5qiXkzbjF3Xtq+OPnSbxqxP3YcP980Ox3YMoX+OqK/O/FUwqCoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8476

T24gMTEvMTMvMjUgMjI6MjYsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBUaGUgb25seSBl
eHRlcm5hbCB1c2VyIGlzIGdvbmUgbm93LCBvcGVuIGNvZGUgaXQgaW4gdGhlIHR3byBWRlMNCj4g
Y2FsbGVycy4NCj4NCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3Qu
ZGU+DQo+IC0tLQ0KPiAgIGZzL2lub2RlLmMgICAgICAgICB8IDIzICsrKysrKysrLS0tLS0tLS0t
LS0tLS0tDQo+ICAgaW5jbHVkZS9saW51eC9mcy5oIHwgIDEgLQ0KPiAgIDIgZmlsZXMgY2hhbmdl
ZCwgOCBpbnNlcnRpb25zKCspLCAxNiBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL2Zz
L2lub2RlLmMgYi9mcy9pbm9kZS5jDQo+IGluZGV4IDI0ZGFiNjM4NDRkYi4uZDNlZGNjNWJhZWM5
IDEwMDY0NA0KPiAtLS0gYS9mcy9pbm9kZS5jDQo+ICsrKyBiL2ZzL2lub2RlLmMNCj4gQEAgLTIx
MDcsMTkgKzIxMDcsNiBAQCBpbnQgZ2VuZXJpY191cGRhdGVfdGltZShzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBpbnQgZmxhZ3MpDQo+ICAgfQ0KPiAgIEVYUE9SVF9TWU1CT0woZ2VuZXJpY191cGRhdGVf
dGltZSk7DQo+ICAgDQo+IC0vKg0KPiAtICogVGhpcyBkb2VzIHRoZSBhY3R1YWwgd29yayBvZiB1
cGRhdGluZyBhbiBpbm9kZXMgdGltZSBvciB2ZXJzaW9uLiAgTXVzdCBoYXZlDQo+IC0gKiBoYWQg
Y2FsbGVkIG1udF93YW50X3dyaXRlKCkgYmVmb3JlIGNhbGxpbmcgdGhpcy4NCj4gLSAqLw0KPiAt
aW50IGlub2RlX3VwZGF0ZV90aW1lKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGludCBmbGFncykNCj4g
LXsNCj4gLQlpZiAoaW5vZGUtPmlfb3AtPnVwZGF0ZV90aW1lKQ0KPiAtCQlyZXR1cm4gaW5vZGUt
Pmlfb3AtPnVwZGF0ZV90aW1lKGlub2RlLCBmbGFncyk7DQo+IC0JZ2VuZXJpY191cGRhdGVfdGlt
ZShpbm9kZSwgZmxhZ3MpOw0KPiAtCXJldHVybiAwOw0KPiAtfQ0KPiAtRVhQT1JUX1NZTUJPTChp
bm9kZV91cGRhdGVfdGltZSk7DQo+IC0NCj4gICAvKioNCj4gICAgKglhdGltZV9uZWVkc191cGRh
dGUJLQl1cGRhdGUgdGhlIGFjY2VzcyB0aW1lDQo+ICAgICoJQHBhdGg6IHRoZSAmc3RydWN0IHBh
dGggdG8gdXBkYXRlDQo+IEBAIC0yMTg3LDcgKzIxNzQsMTAgQEAgdm9pZCB0b3VjaF9hdGltZShj
b25zdCBzdHJ1Y3QgcGF0aCAqcGF0aCkNCj4gICAJICogV2UgbWF5IGFsc28gZmFpbCBvbiBmaWxl
c3lzdGVtcyB0aGF0IGhhdmUgdGhlIGFiaWxpdHkgdG8gbWFrZSBwYXJ0cw0KPiAgIAkgKiBvZiB0
aGUgZnMgcmVhZCBvbmx5LCBlLmcuIHN1YnZvbHVtZXMgaW4gQnRyZnMuDQo+ICAgCSAqLw0KPiAt
CWlub2RlX3VwZGF0ZV90aW1lKGlub2RlLCBTX0FUSU1FKTsNCj4gKwlpZiAoaW5vZGUtPmlfb3At
PnVwZGF0ZV90aW1lKQ0KPiArCQlpbm9kZS0+aV9vcC0+dXBkYXRlX3RpbWUoaW5vZGUsIFNfQVRJ
TUUpOw0KPiArCWVsc2UNCj4gKwkJZ2VuZXJpY191cGRhdGVfdGltZShpbm9kZSwgU19BVElNRSk7
DQo+ICAgCW1udF9wdXRfd3JpdGVfYWNjZXNzKG1udCk7DQo+ICAgc2tpcF91cGRhdGU6DQo+ICAg
CXNiX2VuZF93cml0ZShpbm9kZS0+aV9zYik7DQo+IEBAIC0yMzQyLDcgKzIzMzIsMTAgQEAgc3Rh
dGljIGludCBmaWxlX3VwZGF0ZV90aW1lX2ZsYWdzKHN0cnVjdCBmaWxlICpmaWxlLCB1bnNpZ25l
ZCBpbnQgZmxhZ3MpDQo+ICAgDQo+ICAgCWlmIChtbnRfZ2V0X3dyaXRlX2FjY2Vzc19maWxlKGZp
bGUpKQ0KPiAgIAkJcmV0dXJuIDA7DQo+IC0JcmV0ID0gaW5vZGVfdXBkYXRlX3RpbWUoaW5vZGUs
IHN5bmNfbW9kZSk7DQo+ICsJaWYgKGlub2RlLT5pX29wLT51cGRhdGVfdGltZSkNCj4gKwkJcmV0
ID0gaW5vZGUtPmlfb3AtPnVwZGF0ZV90aW1lKGlub2RlLCBzeW5jX21vZGUpOw0KPiArCWVsc2UN
Cj4gKwkJZ2VuZXJpY191cGRhdGVfdGltZShpbm9kZSwgc3luY19tb2RlKTsNCj4gICAJbW50X3B1
dF93cml0ZV9hY2Nlc3NfZmlsZShmaWxlKTsNCj4gICAJcmV0dXJuIHJldDsNCj4gICB9DQoNCmRv
IHlvdSBuZWVkIHRvIGNhdGNoIHRoZSB2YWx1ZSBmcm9tIGdlbmVyaWNfdXBkYXRlX3RpbWUoKSB0
byBtYXRjaA0KaWYgY2FzZSA/IGFsdGhvdWdoIG9yaWdpbmFsIGNvZGUgd2FzIHJldHVybmluZyAw
IGZvciBnZW5lcmljX3VwZGF0ZV90aW1lKCkNCmNhc2UgOg0KDQoJaWYgKGlub2RlLT5pX29wLT51
cGRhdGVfdGltZSkNCiAgICAJCXJldCA9IGlub2RlLT5pX29wLT51cGRhdGVfdGltZShpbm9kZSwg
c3luY19tb2RlKTsNCiAgICAJZWxzZQ0KICAgLQkJZ2VuZXJpY191cGRhdGVfdGltZShpbm9kZSwg
c3luY19tb2RlKTsNCiAgICsJCXJldCA9IGdlbmVyaWNfdXBkYXRlX3RpbWUoaW5vZGUsIHN5bmNf
bW9kZSk7DQogICAgCW1udF9wdXRfd3JpdGVfYWNjZXNzX2ZpbGUoZmlsZSk7DQogICAgCXJldHVy
biByZXQ7DQoNCg0KaWYgbm90IGlnbm9yZSB0aGlzIGNvbW1lbnQsIGxvb2tzIGdvb2QuDQoNClJl
dmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0K
DQo=

