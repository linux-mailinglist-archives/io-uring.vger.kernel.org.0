Return-Path: <io-uring+bounces-10521-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E42B4C4F971
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 20:23:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DA2244F3B8C
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 19:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D42630101E;
	Tue, 11 Nov 2025 19:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WaMZYSEn"
X-Original-To: io-uring@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010021.outbound.protection.outlook.com [52.101.201.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F390F27F163;
	Tue, 11 Nov 2025 19:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762888785; cv=fail; b=cnq8UFqQ0n0llRPEZz9w6Bi4ZyFWstnwN1Ex784fvSCc7ctfmMMU3hF90G208LNmqWutnUHM0gJeQr32xhjp8cggF8/VAvTSr6YT74KUcTcxI0PEG4QKcy/9tUirMKUZIdODecXxFj6rGL6wUdpzhSxVwDDY6Fqk0w+T38xrnLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762888785; c=relaxed/simple;
	bh=NeN8HlhFGMPWM8l7kMRm2UVdKdEygSzWOPLc0EbZywI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lC1pYES21l9p+H4vUPSAUtsBscLmroKvtqpz1qQxFtJli/m760m/UEH3lZG95Qx619FoYQU9OZEkzh+pPejhV4jHoXpM6PtrlVx6LTdM7HlfEE3yc6RMMrFKUF6eiujzdll5QGw8bXyebN7r2wv/cekDEz2AC0hklIxK6ut7EME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WaMZYSEn; arc=fail smtp.client-ip=52.101.201.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TmiuiYK7KNk+0I3dSk7bJZOLNgL62l7u/GxPuU0bX7iNEZyVUStwb3N4+BqR8bPTz4zE+nd93jkPPj7cH6Xl0XDBh1mnFTzpI39hH5w4ox0d31O9WY4yI5Ccilkz8Rw7t4428hTg+wxdf7mmwj7RvErcqVZ95CmdRFcQUnEk0Gqa1sP9FYeXi2ME8s4NDZWbMoPW6+UTpj+y9cNyzHycemmXyIASZ/IA7kRB5YKPmJ6C1yspDyzf8oFGP+Af7LnuWw1vbuyDkQfovWyNeBL9HyZTQdTyCqZAqnwvF9LXvJ+3kpc1X5zBXfgbAKjPVZdkB+mZzSXS6NpKEhl3tJMpxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NeN8HlhFGMPWM8l7kMRm2UVdKdEygSzWOPLc0EbZywI=;
 b=ORiBYTlybZGXhwnenXjchm/mR6qaTPCWx7fIpyhIO64dLDe7Y8D6JaXEyFn6sQgsrMmFxvg1LfUuxm+/7+W4OZQrpy9ZMQT6eFpxge50yrZVLm8PLS/NOxTvJLDh/adwqCBQO7LNdPAQlhYHez+zLGIIdVYCzjgw9ZuFE1B7ckJKlLFvjpvtR4UHL0ay3xce3UqOK0TXiFV1hKyv/AIFePniYPm6R6NQyAu0CuYZfjxTG0HWzLfKd48ZAG5EExq7/xbXw49JJMbPoClvc5l30gF+A6CT7+OgK94VRM5U9oX2bQPNRCO/9LtZpgWywFcJJ0iEc1q7TbkBTKYrB1zcWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeN8HlhFGMPWM8l7kMRm2UVdKdEygSzWOPLc0EbZywI=;
 b=WaMZYSEnCm/O0yV72MEBvwkjl8Vw1pzuxfprHCFFU3DWw6IFPvnl6xTu+kPGotDqzvFCXCUv21DLAOJVMutoJpVq8RFrmR5QR4E/lN8ochItepIH+57JUjx1s/6dLGfg/fUxa4BzQ9iHTUuiVk34hpC9Ot9rHFK+BVMvBUrPf4V881cR7UuDGloJnozjfcUa0dtPrWoRH3TilZ8F52NYMSe8K+EOPQzuKadJC5BtfymK7tPs3nrPmd/I/haTl3zcMpJ2OALw3cPsygr2D1yXwBqMHER3tS5XM1l261Vc6oGcaS5jvVFOWdglv85QNgPmxXyr6kDX9viB0eeRbzii9A==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by IA0PR12MB8087.namprd12.prod.outlook.com (2603:10b6:208:401::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Tue, 11 Nov
 2025 19:19:40 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9298.015; Tue, 11 Nov 2025
 19:19:40 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Caleb Sander Mateos <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Chaitanya Kulkarni
	<chaitanyak@nvidia.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] io_uring/rsrc: don't use blk_rq_nr_phys_segments() as
 number of bvecs
Thread-Topic: [PATCH] io_uring/rsrc: don't use blk_rq_nr_phys_segments() as
 number of bvecs
Thread-Index: AQHcUz+8byMk0UItYE2H5mQKnSKmBLTt2cCA
Date: Tue, 11 Nov 2025 19:19:40 +0000
Message-ID: <0c9be071-2a2b-41cb-9388-cfb174c36347@nvidia.com>
References: <20251111191530.1268875-1-csander@purestorage.com>
In-Reply-To: <20251111191530.1268875-1-csander@purestorage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|IA0PR12MB8087:EE_
x-ms-office365-filtering-correlation-id: 18d2e474-b019-47a5-afaf-08de215742f4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?N0wyRncwTm4ybnZJRHVINGpsZnNYYjc2a2tBd3p3MGhXZVN1MU5NWTI4b0cy?=
 =?utf-8?B?Mm1lZlJqa2pwOU42NWdyVFc3cnJkcTQ1eldraTBzb29ObEFSSHJlNFdjMExE?=
 =?utf-8?B?MFBtV2xRSUZIZ0ZRNVZkVHBacFdrVzNEREhDWEN3SGs1VFpPSlFyamhFakR6?=
 =?utf-8?B?Qm03aHRqQUF6UXI1OGY5cmd5UGc3SmgzNk01ZTloSzdCUUhMVzJuU1RyN0lr?=
 =?utf-8?B?UStoMlFlM2c0YWVXRjhJU3ViWGFQQURUT05QSlBzbVRSYmlCVDd3N09DRVpC?=
 =?utf-8?B?M2IrT3cwQ0I5TUI2VE9YSjQvQW9xUHJBSXNBUy8rNFdjdmVPbGhwUFU5UEN0?=
 =?utf-8?B?aDAxbGdlcStxcy9abUUzbDh1RXUyZDNxeXpJN01uUUM2eEx3UnVCc0xGcEhT?=
 =?utf-8?B?dkY3UWNGb0w3dmNSaFRGWFJLRHcwSHlCM2NkWXA3NDNMQ3V3VEx3cS9HcmZ6?=
 =?utf-8?B?MjZaUGdzY21tdVI4cUZsakF5eS9HSkxnQnFLUHJLaXIybWRqbUhHQ2x0SnFC?=
 =?utf-8?B?L3BWVFRod1FScGpPcWtxbElpTFBIWUJ5SHZoL3JReWYycTVtR0FGZ1VxYjBv?=
 =?utf-8?B?NUtHN3poUE9oSElsWlVXcUtJYnlDUDkvRi80d0U1VEZKUjFxNkNHM2JZQWNa?=
 =?utf-8?B?MzlNdUlEd2thU2d0VTBiVDByNHY5WC92elhCSGVrRWtPcGZCSXVRNEFGMWtY?=
 =?utf-8?B?b1Vubk8waEZUOUJBaXdIOG4rTUlwdWdSd0RhQlpuNkE0WlQycTF0T0Jibm9J?=
 =?utf-8?B?OWJXT0hmbGtleC92V2ZUY2JzNHp0NGVwdGU0N29nRW1vSzFpeXFBY2d6ZG93?=
 =?utf-8?B?b01DbXV1NXJoSFFtcFF1Y1ZvbGsvV2YwTFJEMWFwSi9qdFFoSWZING0vNzFI?=
 =?utf-8?B?SmpIdm1mSENkRy9UbEVBeUt5ZEZMMGZVcUt4RkljRzRUVlFjRXRDSkdna0dC?=
 =?utf-8?B?aGk3LzRBVVgwMDdtMHp5OHY1c1FGd29jWnNSWkdZMTB3clNSREw1Y0RkbG5T?=
 =?utf-8?B?VHd0UnZ5NnhlUVZaSUVkUWswZDdQaVpkdlcvbExKZHBwT0RQb2YvdjhtRGZz?=
 =?utf-8?B?YTFYWk9YSC9MV1k4TEw0VGxXV0dLWUF4TEIrNTRhY2hYelpTM2s5andjcVJZ?=
 =?utf-8?B?bUU0YkQ4a2k0WW4wUVBRcVp3TGZrVGZhS2w2b2VqbmdreXBZMzJXOHlJRlpx?=
 =?utf-8?B?QmFOdEdBL0RnTEwzeUQwVFhjT0ZTREcvK1R4WDRTL0xGUWxmVExveHFnaHdY?=
 =?utf-8?B?QzVzQklnaXZtVG1xenl2OTJMeWUyOFEzUjRSM3BHcFNmRVNYL01MQWJDelhH?=
 =?utf-8?B?dkhnY1NYVm0zTjNOZ1lqaG8yQ0RrNTNpZWM2MUxqV1J2M1RIU2VacnJOWGtZ?=
 =?utf-8?B?UHFzTEt4S1p5UUdraWI0QWxoU2FnTzFLQjk3OHlzOWttQnE4ZkdaL2xYTk1B?=
 =?utf-8?B?QzA1TDhvM3B3R0pmdmhLTVlsV3BlRDl6cUdwVGx2MVd1bzNJSUJVZ1dTZlM0?=
 =?utf-8?B?dkwzOGdGeG1WT09PUkJ0R0JxVnFocjUwaDA0Y2tPRE82bTUzZlhBQlZjbU1x?=
 =?utf-8?B?MnNiQzNuclFsTmx4MksreDY1L3NFRnJVekR2ejlDYllkQjZsalhpeTdqMWRV?=
 =?utf-8?B?SmdZTE1ZSkliVkZNdThOQk1jNDJqU2VPZTl0ZnZJNCtPSFp1ZjdnSFVHMC8y?=
 =?utf-8?B?eGNZL0lLeHVTSDZiQURrc3pFU0NPeDZaaVhoOWN1WENWWjdYRWplUmxGWjA1?=
 =?utf-8?B?Q3pKb20wczRVN3FwOHhQOGVXQUFidytqa3BFOGtTQ051eHUvZG5FT0d4cllY?=
 =?utf-8?B?SC90WUlhaCt4RllNR053aXJDenN6dnJpdmwrNFYzclpqWWhSVTVtcHkyblZ2?=
 =?utf-8?B?ZDR6dDk4R015RktQS3dOZWt6TFllamplYlFGY2IwNTQzNTh2dlBSaXo5REtX?=
 =?utf-8?B?cTJwWHdiRW1VKzl5eVhnSDR1Ulo0ak5Vck15VG94aEVEK3kwcjkvV1pEd3B4?=
 =?utf-8?B?RERqckZmbVlZamdMWlUzK3JMRlJmUDkrMUVORzZtSEFCcmJ5QzJtZGEwMGNE?=
 =?utf-8?Q?wfsd/a?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?anM0OXBMMTEzYlR5b0w4VW9MWEc1cEtHMzdxMWp6ZGZsN2xEZG1RK0NnUE4x?=
 =?utf-8?B?VmpnZFo5azliakN4T1lyc3ZueXlOU3ZyN2NhTU9UM0Ria3gzS3o2Sy9lVWZx?=
 =?utf-8?B?SWdEa2NZdDB1YzdnZHV5Vk84MStrUXFPODlvLzRSaEdhZXlpM3F1ZUU5OVlL?=
 =?utf-8?B?L2dQRXViVThET05EZFA1enZ6SFA5MmtSMXhjVTNPT1NpV3dKOFBXNm5ZN0FJ?=
 =?utf-8?B?dC9nMTFBc0paVmJicGVvVXZnUm1majhReWVzYytocUFJNUJQSXNlTitsRlYz?=
 =?utf-8?B?dVptbkpBUE02dTkxaENCeDJGK1NYLzZac1ZBL3FrZFFjc3l0ZVcwUmYyK004?=
 =?utf-8?B?N0pCSHJpVTkyUSs4d3M1TnlDTjQ3OUtnK3hURWRaWURJM1B3cVlya2RMMDlN?=
 =?utf-8?B?bTdyU2V3akZtU0IrVWFBb0pjMGdvaHJvV2hKTkRtTHlhR09PWW5jV0hRbEdl?=
 =?utf-8?B?QjdjeUVSVHpLdDVLUGRqUWZZemZWZm9uUUJRclIvWjhuYk4xVGFHaEIzRGJj?=
 =?utf-8?B?Vm1Nc3YxNjMxVXJFbUdjZnJlc3cwUXNXM20vWDRCTVVBa0g2RzJqemRHRXlB?=
 =?utf-8?B?UFRVeHYvRmdYS0pnUXZXb1VCMFVUT3hHK053cHRaaTg2dG83SWRxbXdsNGN2?=
 =?utf-8?B?M2VMOU5DUjA2TTBsNjRIclVmQ1hpVlZOT2RlTkpGRFAxbVdOOTJ4Y1B0OXZw?=
 =?utf-8?B?NWZCRnd3MDBVcUZ0bThMMnZOM0U4Um10VEVtdnJsZFdmUkc4ZWExK1ZQM1hs?=
 =?utf-8?B?QXhiL1podDBwOVlmNEN2UDdaZ0xaRWljeUY0aHZObWRYNjN2cU9ISFZ5RzVR?=
 =?utf-8?B?bERwNHBlRjNVTVJodS95UVhYZnZXMVpiL05RT09EWUNPK0MzeUdtbVFSeGIr?=
 =?utf-8?B?U3A5bWo1OGQ2OGM0eUVFUmlESFRreFpDbWFzTXNLUlB0cFZ0OURQdzRVa0tG?=
 =?utf-8?B?L0Vsdkp0NEM4bkx4eXREV3N5VFJGUzIzeE9Wdzk2Mk93OFoxZFF4aEtWNlpP?=
 =?utf-8?B?Uk45Q2pqNzlMemoySUFHdmk0TnpPSkZ6S05YamZNTDBuL045aWdNdy8yWmQ2?=
 =?utf-8?B?eXJYRzhvbloraE9JQlA1akdmZ3hVSDdFYUV3Y3dLamt1c0hwUytFb1Z2UFdY?=
 =?utf-8?B?anByNEl4N0JkNG5wbG9pTDY0T09hQXF4aWNSeTQydmVxWUdSZXZhaWVaVDZ2?=
 =?utf-8?B?WE80NVJsNm5JV0RETXNhcnhlNnFpajFXQmNuZVNXdlZoYVZTY205Z3N3ZGhj?=
 =?utf-8?B?WmE3ZldYRG9nSTZKNUdQNzlCaThkRTZ5cmFBNmlWT1R5RmV0aDNRUTBMVkRy?=
 =?utf-8?B?L3B5cHgyaC90ZURSK09wWlVmZzVjTTIweFhKSStWdmZKaUUxZjFxVUlFRXIw?=
 =?utf-8?B?RW0xUjBCbTJjTXpkVlR2T3VrOWRidU9ZRUhZanlCbks0ZlpsVDFqWWt1Rkxz?=
 =?utf-8?B?S1FycEpxYVBEV1EwZjg0VVJJMlBQQ0NqT1BYdWhNSzkxekdtS1dIZDA2cGxX?=
 =?utf-8?B?cXQwQ2YrbzVLN0NKOEpXQ1JIR1FpU2FlZ1AxMVBnRjVDOHlWQ2ZzU2dhRGty?=
 =?utf-8?B?bWxDdkJUdWZRdlNwcEJrMFA0NWNNeXFzQWYzV0llSkxEU0d6bkQwY2o0eGRi?=
 =?utf-8?B?d1FWWUIyeXE0YkNwb0dQZ2FZVVZpWTNVcnN5ZlBoczhwNVJCMnZ4MTlUaEdP?=
 =?utf-8?B?bzY3TXJyKzhNZnRtZmcxMTRmS09UdmNYUVFDemYrV2pwTS9rMGp3ZTFIQXdv?=
 =?utf-8?B?NVV0dTUycCtkOEQxZ29lajhDVmxmdlZEblVRclBwSGlCTDlvdG81WTdUaG40?=
 =?utf-8?B?MFhLd3RnZzlRY2tjdGMyRDdUL092c0kvUmk3MjdqVFlSTkh6Nmo2TjRZMkh4?=
 =?utf-8?B?b2QzOFJxQXY1MU1MQzBLM2NVRFFWbnR4SDBEVllVQ1NWUTdPb0srTXcrQzdH?=
 =?utf-8?B?UWdIRHYrTFo3T0Z2SmQ4Mmd3QlZldWoxc0J0dFBsaStkM1pPV3YrS3Q2T1Ux?=
 =?utf-8?B?SnJzajBFSDNUZU1rUEcrQ3dPN0hRcG4wNU5jUnNmRHFIT1VZVGw4c0x0ejZn?=
 =?utf-8?B?VWVjRXp2aEM4UnUzQUFyd3R4eHQ1TllmOHZwQjA2aDU4NVpnZVVpb2FGRDhK?=
 =?utf-8?B?YUdXM0xRU01QUStnenZuRmpwMDVsQndTZDc4SnRva25ZQkZpeTJtLzcrOER2?=
 =?utf-8?Q?psF9gVPoqB5+Wt8hTjyPeCThd34pm/m1K0lp6TiI3Q2L?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C8716D81C42D6479EE03989C072BAAD@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d2e474-b019-47a5-afaf-08de215742f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 19:19:40.1971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GBImKEKabOcg3HCCGyZzpORY4PmHjaSphrfpSrrmwSdRZBVcrEMoElNRbDiysret2J3r1X4r136XQTFITV1E1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8087

T24gMTEvMTEvMjUgMTE6MTUsIENhbGViIFNhbmRlciBNYXRlb3Mgd3JvdGU6DQo+IGlvX2J1ZmZl
cl9yZWdpc3Rlcl9idmVjKCkgY3VycmVudGx5IHVzZXMgYmxrX3JxX25yX3BoeXNfc2VnbWVudHMo
KSBhcw0KPiB0aGUgbnVtYmVyIG9mIGJ2ZWNzIGluIHRoZSByZXF1ZXN0LiBIb3dldmVyLCBidmVj
cyBtYXkgYmUgc3BsaXQgaW50bw0KPiBtdWx0aXBsZSBzZWdtZW50cyBkZXBlbmRpbmcgb24gdGhl
IHF1ZXVlIGxpbWl0cy4gVGh1cywgdGhlIG51bWJlciBvZg0KPiBzZWdtZW50cyBtYXkgb3ZlcmVz
dGltYXRlIHRoZSBudW1iZXIgb2YgYnZlY3MuIEZvciB1YmxrIGRldmljZXMsIHRoZQ0KPiBvbmx5
IGN1cnJlbnQgdXNlcnMgb2YgaW9fYnVmZmVyX3JlZ2lzdGVyX2J2ZWMoKSwgdmlydF9ib3VuZGFy
eV9tYXNrLA0KPiBzZWdfYm91bmRhcnlfbWFzaywgbWF4X3NlZ21lbnRzLCBhbmQgbWF4X3NlZ21l
bnRfc2l6ZSBjYW4gYWxsIGJlIHNldA0KPiBhcmJpdHJhcmlseSBieSB0aGUgdWJsayBzZXJ2ZXIg
cHJvY2Vzcy4NCj4gU2V0IGltdS0+bnJfYnZlY3MgYmFzZWQgb24gdGhlIG51bWJlciBvZiBidmVj
cyB0aGUgcnFfZm9yX2VhY2hfYnZlYygpDQo+IGxvb3AgYWN0dWFsbHkgeWllbGRzLiBIb3dldmVy
LCBjb250aW51ZSB1c2luZyBibGtfcnFfbnJfcGh5c19zZWdtZW50cygpDQo+IGFzIGFuIHVwcGVy
IGJvdW5kIG9uIHRoZSBudW1iZXIgb2YgYnZlY3Mgd2hlbiBhbGxvY2F0aW5nIGltdSB0byBhdm9p
ZA0KPiBuZWVkaW5nIHRvIGl0ZXJhdGUgdGhlIGJ2ZWNzIGEgc2Vjb25kIHRpbWUuDQo+DQo+IFNp
Z25lZC1vZmYtYnk6IENhbGViIFNhbmRlciBNYXRlb3M8Y3NhbmRlckBwdXJlc3RvcmFnZS5jb20+
DQo+IEZpeGVzOiAyN2NiMjdiNmQ1ZWEgKCJpb191cmluZzogYWRkIHN1cHBvcnQgZm9yIGtlcm5l
bCByZWdpc3RlcmVkIGJ2ZWNzIikNCg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hh
aXRhbnlhIEt1bGthcm5pIDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K

