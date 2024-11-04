Return-Path: <io-uring+bounces-4446-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D37A9BC13B
	for <lists+io-uring@lfdr.de>; Tue,  5 Nov 2024 00:03:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09D8228293A
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 23:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7FCE166F29;
	Mon,  4 Nov 2024 23:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="CAyEJtrs"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391BF16087B;
	Mon,  4 Nov 2024 23:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730761384; cv=fail; b=OFZCTsU0leHJ3NmX634sKQZfuBGmxcnrQ7WPNlvcKG4vBeR+abvb1bGMHq9Am9oipUDWRjn4fJwGSkJVn1mIpBeTtzzotS9uGFzScCW6LtPpzBMVsVAlCsCqXEWxqvF+NWfT4oWIxJebWbBq5Iuy+1ETVTH0SN9S/tnRVed81ZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730761384; c=relaxed/simple;
	bh=db33vnnRTiHFZFCsNBAC+tRMYwUlB5pYhbcI5/EpovE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RUYA87oxMSs3O1tZchocy3whyyXqqaBI7C3fIYanFoPWcs75GNbugEHaOB3HHbS2NQhUCv5p3Nx6utXGhEFOAhMYsdNzUkqkNTRwNpl+s9JNdCckSf/k7MRJiWVMA4VSb9nM+qxbF8edoewNe66cS+KDoUJ5EexZ/U480t9zYW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=CAyEJtrs; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177]) by mx-outbound12-135.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 04 Nov 2024 23:02:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rpSncC6zhFr/qQJ1WxxDzY38O4XmAfm5PdCFp1wZZJaSLNQmUYaTbJh9F6KM7UR1rhCA3qKUr4Nolj42x6g8S+S5f5GqeiFtfLffDXqOVgmsl36BlvQ8u2/1KjXfx8uuEFxu2HaIKBLrPf/i+bZtdbTRdAXZHU2/QOocrfcv3LtIA60J9JXM4HtHzeeCNTWscvRS2Gr7/+Ua9EYMM0cNguIArfff8JM0Rl0JDb1AqbWyccu5jCEv/3hWEW58U1ElKt5AvMGOvv3JYa3xYsvjCCP/kvNzy98Rmyyc1+lhj2gcDHDx7PfPbxmJT3NBzS5CmS2A4Wke5skkiuyoF4cbGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=db33vnnRTiHFZFCsNBAC+tRMYwUlB5pYhbcI5/EpovE=;
 b=uqO+A6k3dlE8hBP78HOautzhDi3ZMuEGy7GEU9U98hszPC1FdXgFVi9iq2EZ9s8IDg8TNNtcGqhWEhfsXUOM85hXWutnmukRtbGCaVxY7m74idcWstGpI5iO0icuG8qdE1XZ1M+4DOluUIsqpe9BnMYUogZVRlhfvCS5APyh/t/CMIXIf83CFGKVZIIOj2gk6soGC1TtQ4zg3uJKnYdjmzzAiQC+J+t2A+tZSZl3gJWWIep1pUTgl8C1xRIENttV9nzHzx8w93GsYmps172QKEzFXORFg+g4xA62tPeKZiorby9YlQL2eoEDXydzyEucoZO76fhvy8+xd+tQwPQpZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=db33vnnRTiHFZFCsNBAC+tRMYwUlB5pYhbcI5/EpovE=;
 b=CAyEJtrs1cr0tQU0RFauppizmCQ+uYIXHvp0gN/F/bAg57ztvryJvem5zysZCeNdXEty/iba5DxyAfb4zA/K/ptVGRuWhy+tDVjJR8ZFjNak7pWQtyqRlfEZwBLdAWbAQzUsDVIm7mgXRBhdjbTcv40pCwmuOL3inNiF9iGr0m8=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by DS0PR19MB7375.namprd19.prod.outlook.com (2603:10b6:8:147::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 23:02:49 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%3]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 23:02:49 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: David Wei <dw@davidwei.uk>, Miklos Szeredi <miklos@szeredi.hu>
CC: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Joanne Koong
	<joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>, Ming Lei
	<tom.leiming@gmail.com>, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
Thread-Topic: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
Thread-Index: AQHbH18bZ6vhAumyV0ipwPS2rhvbdrKTX5KAgBOHoYCAAPVjAA==
Date: Mon, 4 Nov 2024 23:02:48 +0000
Message-ID: <0fc59c7e-33f6-4933-b4ab-4ed92ce681b8@ddn.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <070c7377-24df-4ce1-8e80-6a948b59e388@davidwei.uk>
 <7c1cb193-cd0a-4b7f-b4ca-4cc4407e4875@ddn.com>
In-Reply-To: <7c1cb193-cd0a-4b7f-b4ca-4cc4407e4875@ddn.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|DS0PR19MB7375:EE_
x-ms-office365-filtering-correlation-id: 5b17bedc-16d8-4905-580c-08dcfd24cd9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dDB5MGJaeEQrT0ZFT1lUZjdTakg4WGVZVmRjN3YrSGVHWjB3RUJQUXJ4Q1Yy?=
 =?utf-8?B?M3NEWVZMTC9oSzN5NmJ0RmVlT1B5QkZTSStJZ09MTGxBMUJyMVRDN2kvcG13?=
 =?utf-8?B?Wk5lRGtPSk9EQ21pZ2ZyNjdLd1RDQjA3dTlxUTZDNFFuYmFwdzQ2c1Y2dXFS?=
 =?utf-8?B?UFlDSHNycWVKWFdPNlBPWHo0QUlsRDZ0OW5GcnNhUnZWY0drc3VDSURjaElq?=
 =?utf-8?B?a1NpdUUxM0JjK1NTM2ZXNGxkTDJWZVBoZzl1YjVQT3J0aDVNcHpXWUkrc2Na?=
 =?utf-8?B?OGRYaDI1cExXdXR1Mjg4RFNIWFFUZ0FiZGkxaG5IOGMwYmVuVW56N2FmZ1hz?=
 =?utf-8?B?MlNuY1dlK2RtWHhwVmYzM2FIRGx6K2ZEY3JkRHQxcHdJSVRsazIrRWZMenBL?=
 =?utf-8?B?OStSa1BYa2lySDNwUDY2WjFmRWM5QWxoTjVTSmU5QVg5ZksrY2hmWnlJb3JI?=
 =?utf-8?B?MW5vQmVNQ05sbm42K1RsV2lDSEw0K0d5N0VFQmoyK1hQd3E5d0tySnFGbkxZ?=
 =?utf-8?B?VVRlTUFnQlJPeEd2R0N4KytlZlI2NUo4Zi8vdEE5TFFuWnhmcTkvMEF3TGJa?=
 =?utf-8?B?YURQb0pKM1Z6NGt3b1JFZ2VrK25PeHJpMW1RazlOVFdFWjNPc3kzb3pXdFhC?=
 =?utf-8?B?RGV0Vk5sNnhzMC9DdHBueHNXMzY3bW4yZjdXRjNLY284RWtLTDFkcnFyU1Ew?=
 =?utf-8?B?WWhSQ3VoZUdXV3ovbU00aDFvVTJXelpWb1B5dDY4VFFSZFV6ZjFWMUFta1V2?=
 =?utf-8?B?alhnZjZRSy9YUGgzVk1yRnN1Q2JCOGdOa3ZsWU8wSFdkVzNTMWI0WmZiU2lo?=
 =?utf-8?B?WEtRSXVJQmZxY3pXR1BvVW1FVnNKaVpOL0JmaFNuekVETlJwT1VJZHZ3WjZH?=
 =?utf-8?B?U2dGalJDbWRrYlBSV2hDUGJVMWhBakd2WEsxTWNaOURUVUFjQTNnZTNtZ2Rt?=
 =?utf-8?B?UURreHFEb05COFZickJZZ0FGOGtDZlc4STNzQitvbUpwWUgvN1JpZjMzSkF0?=
 =?utf-8?B?cnB6akVpUURTVWZFcGN4akdZTXY2MzVXRmtTWlNBT2hMdWpXNUp0RTRJTlRu?=
 =?utf-8?B?dU1Nb3pPMU8wUnNGa25nSVJvL0p1WnFzY1ZnWWpBZlRIOG00eGtTYjM5cjkz?=
 =?utf-8?B?VFFEWndWYkRrNDZ2bG1sUUtRMlZabmpPTzZGdDE2ZWsvTSs1T1dJdmxHSXVU?=
 =?utf-8?B?T0hYOXpoaTJXZkd3ZkhhZWtmVmxCcWlwQUdJRWptM0Vrd0xvQlNxb0hoQ3V2?=
 =?utf-8?B?dWhRZWwzVzJSQllDOEU1dCtlT3B0QVRtWWw3Rm42WDRKU2VOVWtZeXMxY1Fw?=
 =?utf-8?B?U3g2bzZnMjVrSWxiZFRmV1BmTW80NnA4TFFpeWhvelpsWU42Ri85SCs1amJJ?=
 =?utf-8?B?S3BkcmNvQ3RkblhFSi81TTd1amN0R3dLemdZaytmb1FKS2lPVVpWL2JlUWZN?=
 =?utf-8?B?MDZVMkRXOUsvTWc1dndtQmRYOXJrdVAyQmhrT09wdGdzTklWbVJXK2VwbXV4?=
 =?utf-8?B?cGM1WEkrS1ZKS3NhZG1XSDVRM0JDYWcrQzIyb3NNblhiNFJDOUJqR2RsZGVl?=
 =?utf-8?B?dVJUNExkMnRXRUdZVjV5RVFrMHMrOVpmNWxIYzhYejArRzVwMHByeGU1cC9Z?=
 =?utf-8?B?cTVZUWdYSUJhRWZMNjFqWFhLdkZIMTQvbzU4OXViSGJDMjNPS1ovOVBZd2g0?=
 =?utf-8?B?TEpJZUtUS3JDeEdkZGR3RWxEcWFQYUovQ0F0UlRMeDRaeVRZVnk2anJLSm9B?=
 =?utf-8?B?Q1VheExSRUZuYnZ0b0FvZlJlbXZDQU5wWlNHUFQvRDFYRmFPSTRsVWVRcmdi?=
 =?utf-8?B?QWxrcm13YUNkNFFSRmNPZz09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N2Z0TGNnS3FHZVZYYmZlcDVhVjJlWS9BbWljRzZSMHVzcXBjZGxmM0kycXJm?=
 =?utf-8?B?LzBFZllRNXFTVDhxUS9Td0Npa0Z6SVB1WS9kbzZCdzdxeWlrSDNlNVNuaUlI?=
 =?utf-8?B?MUQvZ28xT3k1dlZPTk4rZk1hQnorM1hnb0VCaFMyWjQ5b3VEME1zOXMwNTlF?=
 =?utf-8?B?MzlWV0hET1BPRVFHTlhLWnJJSnJTeUlSZHBUa2lCdEVML1Ryb2J6bGRtYzRr?=
 =?utf-8?B?aG1FamlKaTlQRDU4ZWJSMGpvSGZWNXptM2R1OVJ2bFd1RVFNYzVhY0s3M3BY?=
 =?utf-8?B?YmRVaGJZN1FtYjFISmF1MjR3UDJwa2NJN25aazRJWnFTcldjS0hUM2svWGNk?=
 =?utf-8?B?WVdia0tWRHZGN2wzS0lPaWdmdFVEM2F4Ni85QTBPbzBsaHhmQkZJRm4xU3Zr?=
 =?utf-8?B?QkJVak8rczdXMlVselp5bVZ5cmFHc1lydzJtWGxTSFd5L293NmJmR01SdVJq?=
 =?utf-8?B?STZ1akltNTFBR3NZY1VwQVNBOC9NM3ZmYUNRQlhnUXV6Q1R6MTIyblk1dzVL?=
 =?utf-8?B?ck16TEhHYUJwZjluNzZYT1lYT1RzQ0htLzdGVzVPRTI2QmRjTGFmbnk4aVVK?=
 =?utf-8?B?ZE1WZ0k2VGVqVzllNnA5Y3hoNWxQNk43WkV3WC9VYStORFI2UlZYTFFnYzA1?=
 =?utf-8?B?RmkwcVhPcVdPL3RKUjY5dThRMGlYcWVEV2NyTCthT0lHTzZjNUtoRmswdnlT?=
 =?utf-8?B?MEorbm5NVnE0Qmt2OHRUZWdUdkFCOGFFZXFYWFNtN2dCWWY2UHdyb3ZjWUsy?=
 =?utf-8?B?TS9MN3NmWlFkUlp4OGgySXlJUjhsNFZzTVlYVWhYaS8yUEhaZ0RYM0JjOXo0?=
 =?utf-8?B?OE04clpLL3RqWmxCMG1aSTRndVluTzlaNU9UUlZ6cmNsVTJUclhVeDZzaC9s?=
 =?utf-8?B?YkpuS2ZzNkJzN3oyazh5SHlCazJPZzFUMzR2OFRIbkpFaW5tcWdYcEZFbEJU?=
 =?utf-8?B?MHAxYmU3RkNwYU04VnArM2x0Z0s5T3ZWVjhMN0J4bFAwa0xrM3ZGaVd2Zlpl?=
 =?utf-8?B?dVV6RittcWpXM1lTa0FCb0pmTytFOXBRWU84Qy9OVytSKzJMSUYwOWJmWFdK?=
 =?utf-8?B?QW1hQjlTak1MeS9iS2ZkeStzNm9ublNTcTVpZU9iakNkY2duc1RJNlMzakZN?=
 =?utf-8?B?b3MrUzAvaXIyTllhWXRtRjQ4MnA5VE9jRVNSdWVVYmtmOWI5ZlNjTEVxRXRa?=
 =?utf-8?B?M3NCQ0Joc09lZWR4dmVXZy9BVjBxS2JTM3Rkbi9RbUdXUExPTGFyRk1jVW5N?=
 =?utf-8?B?VVZQUzAvTkdaNmo4RVZTa3VDV1RtUGNnbThybFp1NVVmWXJ4WWF1THM4V0xt?=
 =?utf-8?B?R2VrN2VBSjJOUmtpdXdYaFVTOHBQdE9LbkNJbWQwVmRyUVZSU0JNUWYvRG9U?=
 =?utf-8?B?RzJic0M2Sy9zZVZNTWswWDFMaVE5MjNMU1ErWGRYdUhyV1ZCbld6Z20rRGRv?=
 =?utf-8?B?emNjN0YzYkhYMTgrWGxNZ3ZqVnY0RmxVQjJ4R0trd2NxbHQxQXZBNTROSk92?=
 =?utf-8?B?MHhuMWdDNkZXN1dLOFRNNnJlSHFMbzB2UmdXVFYwVHpaYzJmUkZZcm92QlZk?=
 =?utf-8?B?L1JTdnRpQ014TTBsbDZNajVwMzNJR3pYajZUejlhM2JncVp6aXBKZ2FpQUpP?=
 =?utf-8?B?eFAwS25pRldXT25mSGZMRERFdDFLTXErOG5ha3pCK252NVJic1FmNVpYWFNv?=
 =?utf-8?B?aTRGZmRSaGRVY00zd0VHZWdmNWhQd256QUFBcHZMQjdaNndkcG9KZEFGMzZQ?=
 =?utf-8?B?RkpsT093K3ZsdVBCYVAvSTltQk9XTktGQU1HYVpUdzRzNE5VQXc1Q3NTcFUw?=
 =?utf-8?B?Yk9ncUpYOFN0YytTeW0zbHlnVXpPZVFWZEJzWUFOTzY0WDhCay9yMDAvQkRn?=
 =?utf-8?B?UGVQY2toL3g4UzlnU2NGeWQ5OU1xKzdWU2owVDRkZm9hMjRBdlMweU5rL0JE?=
 =?utf-8?B?Nmgwd3pZYXJuTHVaVCs1Ulp5WndtTXpJT3JsREh3Y1hEYittZW1wMkU0Zm43?=
 =?utf-8?B?ejd6ZTNxenVOcHE3N29OMmwzVy9TWjUvR2ZXc1R1L25XUStsWFNmQ2JVQzFG?=
 =?utf-8?B?ZlpIaGJpd1hJTDk2MU1BelRNL2dYdUNuUzlRUG1zZkRiVmhJdWxoenBMRmZD?=
 =?utf-8?B?STZkTWRtcmZ6TUgvN0pETlJSMnlnbE9tYXNjQ05wQ2h4OUFPNlltSWQ0b1pB?=
 =?utf-8?Q?JrFKE+T0j6eKy2sLgG3IqB4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <74DB36748E27F646BBBCF52768A570F8@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wwiRDqI5A2NNa7hpOS8aQFaxYH4ypgu+nf78aJmRVH4dy1Lv/mGqpkQtk87630L5l47UqjMFdZpeHyBDtYy4Ow13fQRkWma5rJaXfN5XtOVe6qV2ydGZ0ENHC5i395a3Awp8zL58OMbORTVmWrKWxKSKyVI1QbOf0KgD8Lgk00yHyd+Eq7O92uhUVrdt1Nz+FlUkhvQxELjGb8EJA138VSFf4BEENFxH073EFVv47VMzh2Z4VGtfuIpI1vYYoft2Q7Yju9m6Xk1u4TQsFI906jpvuTgSHjW8faSJSr4lyOMjPEsb0mM6XcxpV0Sw1yXTAzSbE2jWIiAlY+usJSQeoACMoHnnBizo6KMGi4y9KO+5AkIprWShkgVQe3fe+7kc1/PEJqgwI1ltdfS/iUxJbz5xpxYumQXOjONI9ppB3JXK7/fY3YX3e/JUQ4Rqffvf5rqiZL/35o62HpHxa+KQuiXBTVar6+AkdOweOKqbKV0ITFWp/mo7Zy8az1lpEJxmTdzX/DU3/7fu/4H1/4b4uOtOUsQVD/a1O0zwylD1WspSMPMlGPAAj/ih881HLMAes3rnidj/EI0vY8vOwV3GuAq8CSzAtOtFjexpDkwcilT18WYBJL+g/GLDV2v5dDuNhyKZ+O+scv3o0UEyfyQkfw==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b17bedc-16d8-4905-580c-08dcfd24cd9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 23:02:48.9390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eOmP0y5mpZ8bx1z9sJC6Gy0N+fu3nX4gU4ZK2ft5tcislQ9mU4Z82UZBvM3SOrNfq+OeMrA359316Vcq/S0BbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR19MB7375
X-BESS-ID: 1730761372-103207-19344-32156-1
X-BESS-VER: 2019.1_20241018.1852
X-BESS-Apparent-Source-IP: 104.47.58.177
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkbGFhZAVgZQMCUxxcTIKCnZyC
	DF0MA8OdHE1MjAPNXQwsDAMtk40TxRqTYWACQAQGFBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.260206 [from 
	cloudscan20-75.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTEvNC8yNCAwOToyNCwgQmVybmQgU2NodWJlcnQgd3JvdGU6DQo+IEhpIERhdmlkLA0KPiAN
Cj4gT24gMTAvMjMvMjQgMDA6MTAsIERhdmlkIFdlaSB3cm90ZToNCj4+IFtZb3UgZG9uJ3Qgb2Z0
ZW4gZ2V0IGVtYWlsIGZyb20gZHdAZGF2aWR3ZWkudWsuIExlYXJuIHdoeSB0aGlzIGlzIGltcG9y
dGFudCBhdCBodHRwczovL2FrYS5tcy9MZWFybkFib3V0U2VuZGVySWRlbnRpZmljYXRpb24gXQ0K
Pj4NCj4+IE9uIDIwMjQtMTAtMTUgMTc6MDUsIEJlcm5kIFNjaHViZXJ0IHdyb3RlOg0KPj4+IFJG
Q3YxIGFuZCBSRkN2MiBoYXZlIGJlZW4gdGVzdGVkIHdpdGggbXVsdGlwbGUgeGZzdGVzdCBydW5z
IGluIGEgVk0NCj4+PiAoMzIgY29yZXMpIHdpdGggYSBrZXJuZWwgdGhhdCBoYXMgc2V2ZXJhbCBk
ZWJ1ZyBvcHRpb25zDQo+Pj4gZW5hYmxlZCAobGlrZSBLQVNBTiBhbmQgTVNBTikuIFJGQ3YzIGlz
IG5vdCB0aGF0IHdlbGwgdGVzdGVkIHlldC4NCj4+PiBPX0RJUkVDVCBpcyBjdXJyZW50bHkgbm90
IHdvcmtpbmcgd2VsbCB3aXRoIC9kZXYvZnVzZSBhbmQNCj4+PiBhbHNvIHRoZXNlIHBhdGNoZXMs
IGEgcGF0Y2ggaGFzIGJlZW4gc3VibWl0dGVkIHRvIGZpeCB0aGF0IChhbHRob3VnaA0KPj4+IHRo
ZSBhcHByb2FjaCBpcyByZWZ1c2VkKQ0KPj4+IGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3Rz
L2xpbnV4LWZzZGV2ZWwvbXNnMjgwMDI4Lmh0bWwNCj4+DQo+PiBIaSBCZXJuZCwgSSBhcHBsaWVk
IHRoaXMgcGF0Y2ggYW5kIHRoZSBhc3NvY2lhdGVkIGxpYmZ1c2UgcGF0Y2ggYXQ6DQo+Pg0KPj4g
aHR0cHM6Ly9naXRodWIuY29tL2JzYmVybmQvbGliZnVzZS90cmVlL2FsaWduZWQtd3JpdGVzDQo+
Pg0KPj4gSSBoYXZlIGEgc2ltcGxlIFB5dGhvbiBGVVNFIGNsaWVudCB0aGF0IGlzIHN0aWxsIHJl
dHVybmluZyBFSU5WQUwgZm9yDQo+PiB3cml0ZSgpOg0KPj4NCj4+IHdpdGggb3BlbihzeXMuYXJn
dlsxXSwgJ3IrYicpIGFzIGY6DQo+PiAgICAgbW1hcHBlZF9maWxlID0gbW1hcC5tbWFwKGYuZmls
ZW5vKCksIDApDQo+PiAgICAgc2htID0gc2hhcmVkX21lbW9yeS5TaGFyZWRNZW1vcnkoY3JlYXRl
PVRydWUsIHNpemU9bW1hcHBlZF9maWxlLnNpemUoKSkNCj4+ICAgICBzaG0uYnVmWzptbWFwcGVk
X2ZpbGUuc2l6ZSgpXSA9IG1tYXBwZWRfZmlsZVs6XQ0KPj4gICAgIGZkID0gb3Mub3BlbigiL2hv
bWUvdm11c2VyL3NjcmF0Y2gvZGVzdC9vdXQiLCBPX1JEV1J8T19DUkVBVHxPX0RJUkVDVCkNCj4+
ICAgICB3aXRoIG9wZW4oZmQsICd3K2InKSBhcyBmMjoNCj4+ICAgICAgICAgZjIud3JpdGUoYnl0
ZXMoc2htLmJ1ZikpDQo+PiAgICAgbW1hcHBlZF9maWxlLmNsb3NlKCkNCj4+ICAgICBzaG0udW5s
aW5rKCkNCj4+ICAgICBzaG0uY2xvc2UoKQ0KPj4NCj4+IEknbGwga2VlcCBsb29raW5nIGF0IHRo
aXMgYnV0IGxldHRpbmcgeW91IGtub3cgaW4gY2FzZSBpdCdzIHNvbWV0aGluZw0KPj4gb2J2aW91
cyBhZ2Fpbi4NCj4gDQo+IHRoZSAnYWxpZ25lZC13cml0ZXMnIGxpYmZ1c2UgYnJhbmNoIHdvdWxk
IG5lZWQgYW5vdGhlciBrZXJuZWwgcGF0Y2guIFBsZWFzZQ0KPiBob2xkIG9uIGEgbGl0dGxlIGJp
dCwgSSBob3BlIHRvIHNlbmQgb3V0IGEgbmV3IHZlcnNpb24gbGF0ZXIgdG9kYXkgb3INCj4gdG9t
b3Jyb3cgdGhhdCBzZXBhcmF0ZXMgaGVhZGVycyBmcm9tIHBheWxvYWQgLSBhbGlnbm1lbnQgaXMg
Z3VhcmFudGVlZC4gDQo+IA0KDQpJZiB5b3UgYXJlIHZlcnkgYnJhdmUsIHlvdSBjb3VsZCB0cnkg
b3V0IHRoaXMgKHNvcnJ5LCBzdGlsbCBvbiA2LjEwKQ0KDQoNCmh0dHBzOi8vZ2l0aHViLmNvbS9i
c2Jlcm5kL2xpbnV4L3RyZWUvZnVzZS11cmluZy1mb3ItNi4xMC1yZmM1DQpodHRwczovL2dpdGh1
Yi5jb20vYnNiZXJuZC9saWJmdXNlL3RyZWUvdXJpbmcNCg0KDQpSaWdodCBub3cgI2Z1c2UtdXJp
bmctZm9yLTYuMTAtcmZjNSBpcyByYXRoZXIgc2ltaWxhciB0bw0KZnVzZS11cmluZy1mb3ItNi4x
MC1yZmM0LCB3aXRoIHR3byBhZGRpdGlvbmFsIHBhdGNoZXMgdG8NCnNlcGFyYXRlIGhlYWRlcnMg
ZnJvbSBwYXlsb2FkLiBUaGUgaGVhZCBjb21taXQsIHdoaWNoDQp1cGRhdGVzIGZ1c2UtaW8tdXJp
bmcgaXMgZ29pbmcgdG8gYmUgcmViYXNlZCBpbnRvIHRoZQ0Kb3RoZXIgY29tbWl0cyB0b21vcnJv
dy4NCg0KQWxzbywgSSBqdXN0IG5vdGljZWQgYSB0ZWFyIGRvd24gaXNzdWUsIHdoZW4gdGhlIGRh
ZW1vbg0KaXMga2lsbGVkIHdoaWxlIElPIGlzIGdvaW5nIG9uIC0gYnVzeSBpbm9kZXMgb24gc2Ig
c2h1dGRvd24uDQpTb21lIGZ1c2UgcmVxdWVzdHMgYXJlIHByb2JhYmx5IG5vdCBjb3JyZWN0bHkg
cmVsZWFzZWQsIEkNCmd1ZXNzIHRoYXQgaXMgYWxzbyBhbHJlYWR5IHByZXNlbnQgb24gcmZjdjQu
IFdpbGwgbG9vayBpbnRvDQppdCBpbiB0aGUgbW9ybmluZy4NCg0KDQpUaGFua3MsDQpCZXJuZA0K

