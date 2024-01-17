Return-Path: <io-uring+bounces-413-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A02982FF72
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 05:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34E6828401C
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 04:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3238C522D;
	Wed, 17 Jan 2024 04:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GEKRy/ae"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05A7522E;
	Wed, 17 Jan 2024 04:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705464050; cv=fail; b=V51ZL+PUOY7A3pr0eab4SCJEtqW3aiW0FhGUNg736UpAU8nGMa94FYJ2HjDYnzq27Zl2b6ux5deeoZ7z07f1kgHnq196dGeO7dRDG6ZcBLA9gfYTDDqn18aVcKScq+dcuNkqaEdx71KVQde808JICsT9sG/+gZ1UM61WgQXu7Nw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705464050; c=relaxed/simple;
	bh=uf9ounxFnejp50cmrBgiQvJhHeRoB/sW8K/VvIsus5s=;
	h=ARC-Message-Signature:ARC-Authentication-Results:DKIM-Signature:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:
	 Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped; b=eF8lhm2juLB4ehc1Jjhy9W5qaYORUxuoSDdNP6hZqWcitxIdjdagnJH06YybCiYEBw1OWKIuA94kBW9RTndfPUDZtLFhgJs22aC0T25JZBYyorBWKoZsZlNs3ZHFQjnYa/+tKKhh4h/g6gISvNk3ZLZ4gk8Na3umXOzi9yGnWKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GEKRy/ae; arc=fail smtp.client-ip=40.107.94.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnlUY49pv2M6TK5rQGVbY29CnvWhv26PWQxakO+RoCSkmnMs0pKQ0cwbl1RdshTHz0auDhBt22vPwjp9cVIoLye0/eiDIzE7a+1lZ+Ok+qvrK3XlTujbIrUfMdJMssPJ7kQ/IySHYplHk7r5D6K8cvkey1De9i3mjfjN6x/uKf359aP4Lk222IOFl5DmnNrBq36r4XfZM3H87ziAAJQq55UwZFnkjJLsrkCfuR2/l0J3LwuAQP58laj+gbOJRDdpA2FUxORp/rEDBeQGawC6jabGCEj+SwkhrptQ1bvL2NGvu54dUdjJuWiVwQOA6tOLGSAwVrw5VyKf/vYV0V0Hnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uf9ounxFnejp50cmrBgiQvJhHeRoB/sW8K/VvIsus5s=;
 b=AvFm1rn6yJZisLdWIEr0u65vg46g38rpNKac8RRHeadSxElFXVlc6eWC6ziyNuwP/dzjAGuqvsGSKc/8iqF2HPm2JYJH1R91Dl+PptUtwm6fYMB6CLZbo3HePqaXb2rZ6VNm3w4PvVNE1KazGsEFZgpNsmNvifv+KxkOcAF8C0DqBE1NlsgOtCt1NfxVJL2Ettov3GNwM8mp6hgeb0+nc7SeOjDv52qnjGswDdem5Bx6OKAcN5qq8Z31RMbPf70meNiBbEbWe9N8hqZtJLNZfXcEO1Yl7lxj7i9z/6ObimFil9poHlsLfqKZXAU/+vC9ZfRxaSk47+ZE/sWxOnvXqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uf9ounxFnejp50cmrBgiQvJhHeRoB/sW8K/VvIsus5s=;
 b=GEKRy/aeJM0UvgaQgyLd7bgExgSDCen7kI0HkTY7tacQHWRPVALhJlet+Z9wbZ6DSf+P+GoSGX9c2ytGaiBZgBzWIJLARPX1XBwXaV3hxDMSPgPppDakuCQ4v9HPg33z4rkUh4CbRk7BpHSuGSQsINXgmArhu/Q8xX6UP8Y9Pj6daNKXoO10LmI07R8ZdHE1vzcMPm8X291hcEc0s+BmdcLHjUWAJBkWpziGFz8KsF17WF9zcEaGikgT0JeMscGEydUS1zYwPv2bwMhlTUdAbXRCKa4lr5kYsJ5heoBb3emFqWe7CSb6a11/59giMsTleMeo2HlGjgboN3jGeCUEEg==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by CYXPR12MB9427.namprd12.prod.outlook.com (2603:10b6:930:d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.21; Wed, 17 Jan
 2024 04:00:46 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::ffce:bbde:c1ca:39ed%4]) with mapi id 15.20.7181.018; Wed, 17 Jan 2024
 04:00:46 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Guangwu Zhang <guazhang@redhat.com>, Ming Lei <ming.lei@redhat.com>, Jeff
 Moyer <jmoyer@redhat.com>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: Hit 'nvme nvme0: request 0x100 genctr mismatch' when run fio
 testing
Thread-Topic: Hit 'nvme nvme0: request 0x100 genctr mismatch' when run fio
 testing
Thread-Index: AQHaSDWsyvHR+Ye7H0aJXwelikzpCrDdYxKA
Date: Wed, 17 Jan 2024 04:00:46 +0000
Message-ID: <a67b3356-c289-4cff-8273-672e857123a7@nvidia.com>
References:
 <CAGS2=YpgcBdW==T=jWXNWePYg2y0c-XsyMxvi5x5hU-cWGXuRw@mail.gmail.com>
In-Reply-To:
 <CAGS2=YpgcBdW==T=jWXNWePYg2y0c-XsyMxvi5x5hU-cWGXuRw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|CYXPR12MB9427:EE_
x-ms-office365-filtering-correlation-id: b8a2d17e-e770-4bf4-26dd-08dc1710e241
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ttBdK8jCBWKB2ZUJWbvrv0CmpE8gkYsQBVFEkYfH6/D483rE4MuD0cUcTAGqfCCqXWWtaHzRPE0QSvjQewV+mPVgbJ/RwbZf54lhLEPYSuI7atrbTJbowmyr1v4sBumysUM1PhVTpLGvhZxxi7sD2DOwZEXi3AomilDbmI1VfuBvzKN2FieZRJawmqbpfvNYeqOFCMZxfNj6NhRfGLghU4G5uyRJNU+TGFIdBb7cpnnY54cWsk8uutgGz7vMshB6tMJOUSfxJpNjQlOHnM9u6S9bRvdXClHXj+S+eUY+qQc85bDYoAzDU9QRXUx2BI3G6bDsBXXsEXQN7zn3Z4TH4PfDbdSL0Ftmj7bNKwq6L7mn7LwYOmF6qNNdGvaHH55r8r5o+PJvLHmPM87Hj5Lyjk0LquMT3oa6vOwU1L0Si5FpNjXddDDXBOkiSXR9jnPQBCm35RWaOCDEkC9bmwkEi+9+34kLwsHvnKRwnzSKT7pkse4+3YIc4cb3jtNmxRszc9od/BZDblLZKPMja8O3xOp5Nk1tzXQ6Bb77X8A+zUPwOfzQz36ttsYAgRJG8Rkbcz3MW7uICr+8x6gtzAM9vY1qFU2h93Qkpy9hFkMSzxPLlEnESUORiIyhzWKZfDkrdL+OlZ3WPo4oLQc2YosdLHrfUtWhdoAZ2767sCNeihnW7SHTIahIquQbwLRYasTs+B6YSUTynrufdh7sh9JnyQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(136003)(376002)(346002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(38100700002)(38070700009)(122000001)(31696002)(86362001)(36756003)(6486002)(478600001)(91956017)(66476007)(54906003)(66446008)(66946007)(110136005)(64756008)(66556008)(53546011)(6512007)(6506007)(316002)(8676002)(71200400001)(5660300002)(2906002)(76116006)(4744005)(8936002)(31686004)(4326008)(41300700001)(2616005)(83380400001)(26005)(128973003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c25pcitlemhxREN4SWdOV3NQQmQ3aHNleGc5aUx6akdmcXpEb1ZDZ0JIVTJN?=
 =?utf-8?B?NFU0cVROZHJHK25FVXRzUVVIOGZEZFlqVVkvd2l0aEJDOWtGN0R2c0x0SmxU?=
 =?utf-8?B?VzZxbmdLKzdDNmI3YW0xWDRaMHVxUStpVkdKNmlWWUE1WU1UR0pzWmdNMkRW?=
 =?utf-8?B?dlh5ajFaaUZrWW1vdDd5WnBaZGpYMDVObGc0VTVNMWkybTRRelptOU01S09Z?=
 =?utf-8?B?T2NpaG9zSmJYeEJHTkJ0NGFkeStVR21BTU15STRFOXNOaDJJMFd3Z00xZHZO?=
 =?utf-8?B?WVRtV0RGMHJlOWpXQ3pwRWVVZWI3YnNlU1BPYmZWblNqU0VkbE52T0MvT3VH?=
 =?utf-8?B?TXZURjljTU1aRHlZZ0RSdFRuS3g1clBNZUFHKzFiVU9uU2FBWXkrMTFONU5W?=
 =?utf-8?B?K2xFamtjK1ZRMFJWdk0ybFNzRTFDTXJISGp1eW1TVm9xMEVCeHZTUXdTNWpU?=
 =?utf-8?B?YStYQStZYmRqenJXVWZ2RFlob0c2eGJtQW5JaTd4Y1Fndmx1b0NFNDBOSS83?=
 =?utf-8?B?M25IVXRUU3cyU2F4enFiWGdkZ0dRd2Z2cktIOGxmaHdxVkxYZ204b2lOd3U3?=
 =?utf-8?B?ZnMvWmRwWUI5Wis4SXY5eUNNTnB5ZTZvSHAzNUtYWlVoRVZXSWkvblE3WEZq?=
 =?utf-8?B?UlJNOG80Nzk0TmFwOU80M1dNKzZQOFFnMUVkbHJrZzk5cnIvYnBoV1VCQU5r?=
 =?utf-8?B?bEc4UDcwbE95dU54UnA2Y200ZjRjTnhmd0xUTDFteG1HdnpuWnl1S3hXM0JV?=
 =?utf-8?B?Zks4bHJScGdlNU0ya1YzYWZ3RjFUQmlFUTJweW82UlRRMmtwYW1MNUdTcDhL?=
 =?utf-8?B?Ulh0aTJza2J6MWpGd0JKSHo5RTIvajJTWXFheGpiNTE1SzhvamJTZStsQVla?=
 =?utf-8?B?bzFvR0RmOWo5b2NscTZrd2UwekpSVEphTFdQRkE1RHFveS9DdUJOMGhEYXQw?=
 =?utf-8?B?TGdIUzhpL2FYTGRneXMvc0wvWTBVSWh2YWFkZTZ0Z2NkM01RSkEyd0xlRGpu?=
 =?utf-8?B?UEE0NnNJb3dJUkpvcUNYRlowZk1zWjNDOHJmOTFlSWtoUWxSSTNHRE9NdWgx?=
 =?utf-8?B?dkdUUXZydE1pR3FrYzV0SnhOQU41T2NOMEk2MzdJeWRFUGRCRUZibHdVeVpI?=
 =?utf-8?B?TDVPVUlQT2w2d0FvdmdnRzhneEZNSTk4SXJtQ2NBbkJ6TlgxTVR1SmdQenBy?=
 =?utf-8?B?Y2F2S3Fua2o1WXluZEdHYTdxN0JEUGtyNDJIeTEzZnpBWWhLUGMyZXlrU2VH?=
 =?utf-8?B?dHVqTWt5WVliM3Q1ekdRSkRQMFdydkFPT1NPUTRjK1lHVFBETFIwK0h5aW5w?=
 =?utf-8?B?VENWUFNjb2JocTl4dldyNmNqcHNqdnRPTzU3d1RjTzR4azNScUVXT1J1TUxQ?=
 =?utf-8?B?UTQ3dnhBMVBhMDY5ZmM5VHZWb0VKcS9ZUlVaYzVYbGgzWEljN01POGJJcUx4?=
 =?utf-8?B?M3Btck1ET3cxNXhjcU5mN05FTkdRQkxIVkZaMm5VRGFoc3RQY3VRVE9YUjdC?=
 =?utf-8?B?YkYwRDNNVDh6RjJwZWJWODZuamhicmxRbURCbmw1YkNFRnBOaFA5UzNXTkRU?=
 =?utf-8?B?bHU1bHhwNkdsTFJjRjl6ZHhQNEZIOCt2dHdCamY0bWZRN1l0MkxFWXZIU3hB?=
 =?utf-8?B?SmhFMGh4Z3JIQ0ZHc1gzOGUzVVhBMldkTVl6ajF1bHJ6eDFrUDFTLytCbnJj?=
 =?utf-8?B?WUVreXpPTXp5Q2E3QWt2ZGZnc0RlMGVGRUo4aGVzSTJVOUxLYm45U2FYTnV4?=
 =?utf-8?B?QXFoVWNWNWF3eE90OFYvRkFYcERhVnNQOU9BUXE0Y1JKSG42dFk3Tk80UG9s?=
 =?utf-8?B?LzFuamoxZEFDbWlNVXdINWxTR050Zy9oTGtNQ1RsWW5ybUpncHhjaXNCbjh4?=
 =?utf-8?B?K2c2UzhLdVczcWRHUFhXOCt5SlE4M0M0blFITThGYmwxN0lrZXUzSEo1QzlH?=
 =?utf-8?B?NHB3dTNlSkxjV3l1dTdyQWVTZFZCdE43TDRpcGpSczNRNVRtU3lRRzhiTW1o?=
 =?utf-8?B?WFVpbkg5YW8rZ1BockFhNVRjdWlaNkJ4K1BENXlISkNNTndLWVd0TzQyeUFY?=
 =?utf-8?B?eThCNFZrdVllbU9zUmhWakhUbDk4eDhnVE5GcDl1V05iSVpPdXg5MzF4dTU5?=
 =?utf-8?Q?PBgIaErD8kKMoorEUBP4+eKC8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05FDA5DAE1A7234DBBE606C6303ECB08@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a2d17e-e770-4bf4-26dd-08dc1710e241
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2024 04:00:46.2408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Go9EBNOqqAru/WAa9dsaBQdRXquMHqF9N+tL0lXYkLs61ScOk05f6oBI2F/3fgcu5dSs7A7YS8dg2kZ/l53d9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9427

T24gMS8xNS8yNCAyMDozNiwgR3Vhbmd3dSBaaGFuZyB3cm90ZToNCj4gSGksDQo+IEZvdW5kIGEg
ZXJyb3Igd2hpbGXCoCBydW4gZmlvIG52bWVfcGkgdGVzdGluZyzCoCBwbGVhc2UgaGF2ZSBhIGxv
b2suDQo+DQo+IHJlcHJvZHVjZXINCj4gLi9maW8vdC9udm1lcHRfcGkucHkgLS1kdXQgL2Rldi9u
ZzBuMQ0KPg0KPiBrZXJuZWwgaW5mbyA6DQo+ICAgICAgTWVyZ2UgYnJhbmNoICdmb3ItNi44L2Js
b2NrJyBpbnRvIGZvci1uZXh0DQo+ICAgICAgDQo+ICAgICAgKiBmb3ItNi44L2Jsb2NrOg0KPiAg
ICAgICAgbnVsbF9ibGs6IFJlbW92ZSB1c2FnZSBvZiB0aGUgZGVwcmVjYXRlZCBpZGFfc2ltcGxl
X3h4KCkgQVBJDQo+DQo+IGtlcm5lbCBwYXJhbWV0ZXINCj4gfHN5c2N0bC5rZXJuZWwuaW9fdXJp
bmdfZGlzYWJsZWQ9MHwNCj4NCg0KZG9lcyBpdCBtYWtlcyBzZW5zZSB0byB0cnkgYW5kIGJpc2Vj
dCB0aGlzIGlzc3VlID8gb3IgdGhpcyBpcyBub3QgYSByaWdodA0KY2FuZGlkYXRlID8NCg0KLWNr
DQoNCg0K

