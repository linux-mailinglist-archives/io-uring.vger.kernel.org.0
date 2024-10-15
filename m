Return-Path: <io-uring+bounces-3689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 662F899E18A
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 10:49:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2595A280E63
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 08:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F8C1C3F0A;
	Tue, 15 Oct 2024 08:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Nec38+JR"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AEA1B0137;
	Tue, 15 Oct 2024 08:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728982136; cv=fail; b=BRV2EA71E1HMySetBpP4k+tnp+Peesb2G68Nlh9FhnlbEtKr0zxfjbZdYqkgp/H74weDTM9RyU4fFTFG6liVnW3hhewXtNmv7JUZRPjCkTsmHKCxiWNCa5Ky6R2o2XYaHRggojBJRCAzlIalvjfNiP4wukyZA+DkIBOqs4g7sk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728982136; c=relaxed/simple;
	bh=jeAOKVYQ+nw0GxjsUjO/U6SyAnnJTDfv7KDGdgu4c4I=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=njfkMNEx9Lmuryf6vNMA7X1QAmX1iM0nu+vrAVFnSHJQQpONMMmhaS15XS9fnLkkFlxK76yVZr7x57ggn6JMiY7XAwqaZr5DqFL9K6TlNAOgaAyj/bCGtS236mC5qMXCMwp8pHy05I2865uC845fpMZUVAfmEgTgXi8hNPKY8Uk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Nec38+JR; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 49F6Q7qA012380;
	Tue, 15 Oct 2024 01:48:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=
	content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=jeAOKVYQ+nw0GxjsUjO/U6SyAnnJTDfv7KDGdgu4c4I=; b=
	Nec38+JRy0SU0I1b0wMMpFCX5GycTs94t20twwxBaMcZdPiyNopCdt9AZsVbHCFg
	FJ4vHZ3Gtqw0mC1tnOULclH50BeFKnJfnJXt7G0q0rmGsGLGP0rsETAErswL1SBo
	x7DhFZ4NZ4k0uK646LlLx4XRpCGcVcY8+/+tFezDiXrUE36O3iagww/J4BCcDwY8
	PtdF835voU0jt3QiUXQG8JbSWA44hh900LqQHBoh/QXWULBT96p8Kwhnpk0OV7ao
	dEsGN0o5Nn3zR5EIrD7TMesUsVCYcTnJ1N9yOmM+DW0a9ngr88lhy6x78DxXzlE1
	oOozjzggeo7uj/DMaEBs6A==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by m0001303.ppops.net (PPS) with ESMTPS id 428mf3sq8d-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 01:48:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DA1lYbswoz119ZB27Dbr5W2doVm3RCRnpqh4NYunS/rESJBdJLeWYE8+JbbG2PgcYdkoieNiyzreVkwgEAMSxR3qWl6EyMdyhj93/K1rCwBPl/VVss4dtk2e7dI3/VnAYwOImY4wR8EZgRTyC2rPlIr4zcQA9AKZTXHj1kSC6o8xXT4GWnq9JBoHOi/uF+Gt8xU1BwWZT294ocu9vcekG3KNHoBj/uDK0wleJSBfiytenLFMkPU+/85eqs99beh3mKJu5bbe0kMbopBVIvabg4s8bMgiikrL4pUxB59Dy5PVmjU8wciQ4GGzKU8OZ5euXE5unbmURMPCMxcp+sjCsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWcDT1+j4nuDbC07cas9h/2moZxpkT3wEK6t6cOddcc=;
 b=Mn8vw7ktUI57DczdvXdzfzFCIbmGSh81BHK4wJggjfZid/CmjcFVLaSa8fAuIqqQBTYGEJaY7pZQBptH/+29mdfcSp7bRhzu+RQtzmqeS3qGSbljw+RbWA4MdEHcAItqR34kGDGIhoNepA3E50G/8RMqvAee1rfwdXQMTeuqH9IjQg6jcQHoCq26WFdG3cMzW3rJIBXTlaCZ+R5pggX2yrnCtRrqpor5Ktlx8zDbVMucXv/hoxAegIxzywiR/DyrQtDzZ/FCCZRz895qUxI2dVgRZBGk10K/BZAmZPCrFnyUUtqlFNCa3zC1UmI9lsvsymMxZBiz3tykmUkqKj2xvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from PH0PR15MB5659.namprd15.prod.outlook.com (2603:10b6:510:282::21)
 by MW4PR15MB4555.namprd15.prod.outlook.com (2603:10b6:303:108::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Tue, 15 Oct
 2024 08:48:50 +0000
Received: from PH0PR15MB5659.namprd15.prod.outlook.com
 ([fe80::dffe:b107:49d:a49d]) by PH0PR15MB5659.namprd15.prod.outlook.com
 ([fe80::dffe:b107:49d:a49d%3]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 08:48:50 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: Jens Axboe <axboe@kernel.dk>, Mark Harmstone <maharmstone@meta.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 4/5] btrfs: add nowait parameter to btrfs_encoded_read
Thread-Topic: [PATCH 4/5] btrfs: add nowait parameter to btrfs_encoded_read
Thread-Index: AQHbHl0ghxVewIc4gkKG3XY10FRzkbKGz5SAgACxzQA=
Date: Tue, 15 Oct 2024 08:48:50 +0000
Message-ID: <5239b556-ee4e-44e0-972b-a2c6d06df338@meta.com>
References: <20241014171838.304953-1-maharmstone@fb.com>
 <20241014171838.304953-5-maharmstone@fb.com>
 <1299ba1d-e422-4ec7-af2a-aedca08df705@kernel.dk>
In-Reply-To: <1299ba1d-e422-4ec7-af2a-aedca08df705@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR15MB5659:EE_|MW4PR15MB4555:EE_
x-ms-office365-filtering-correlation-id: 90d8a629-9ab7-47c3-0812-08dcecf630e4
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MDl4dWtXak4yUTNnVEdqVTdXUlJ2M1pFN05nV2taem8zQnFwQU9HT1ErMDJY?=
 =?utf-8?B?U1FFY2tOeWJEckd6ZGxFK2kyZWVvSlgvVUMxM1VYT3VVKy9jbDV4WXNnRWFF?=
 =?utf-8?B?aUF1My84VVF4cWl2MEtpT0wwT2VLSnN6UjZsYlBtd04yVzhFc1JNMmpVQ0Y4?=
 =?utf-8?B?QVB3Y1lDUjRRb2NKMTgyRE1vbHpNK3lFY3V6cENnSHhUUG5aYUdGZ1JZRWtH?=
 =?utf-8?B?VnRtQzkya2VVSnlPcVZnYzViZktaY0JHTzUrZjlBOFcvNWh0bzdVYmx2N2ZH?=
 =?utf-8?B?ZE9pc0ZVMEM3bURieGdDT2o4b3k3UEdnSGIzZWxRT1REZTV1UG4vTWFJTFZE?=
 =?utf-8?B?N0hNY2xmbFY2ZlV6b0lsc2pod1FIenI1aW9KZTFmL2U2emJod3ZaK2VSZGRr?=
 =?utf-8?B?bjZ5NEdUeW1KdGU4VHdoclJKbXc0cGtrQlFldUNNUjB6OTJoTkJ5Ry9BRUNF?=
 =?utf-8?B?ZXJscVlRbUtOR3prNXhMSVg4UmxxbXRJR3hPZVlZRWVZTk4zVnFFcnVQMkV1?=
 =?utf-8?B?SWFGemFRb0NHTmRmZ1BHWkNVQ2crSjdvbEhmNE1yRlNnbytrZnRLYnFzaGFF?=
 =?utf-8?B?bGpOU0p4NHZQSkFadm5aL3JUTFhCZ01hUHQxeVpVc1BURWc4WDVGM1dnN3RF?=
 =?utf-8?B?YjRtSzdUQkZDZTh0dVcwakVTN0YrWlZOMzFIajNqR2VlL3pYUWxTTXFDNWZS?=
 =?utf-8?B?WHdvcElHYUJMQjllQjd3NlRhR2tDeEF3bWoxdzErY1FEODA3aWZDNnErMUw4?=
 =?utf-8?B?L2dCcmthL3dRNXk1bGxTbngrbTNiNEpMeWc2YXljVE5YYjNOM2U3d3l4SjJp?=
 =?utf-8?B?bG9YNStGUG1wTTlpZFB5cGJlN2kvZWhCYTZuYkNiNVJFREoxSVZ0TVNCMEFV?=
 =?utf-8?B?UmJxTmVMamlzYWM3VDdUazRrSFhGUFpObmFaOGs2bVFESldabENBQXZYdTZU?=
 =?utf-8?B?dFFOSmlVdm5Yc1g1cWZmeEVPcmJ0enpoYjZ2SEQ3VDFDQTlBelRzR3FGUHR5?=
 =?utf-8?B?TThMSHpsMXhxZURqY0d1SlNLOU0zWnpqdkdkU0lHbjBvOXNZVnFEbGtJTjBE?=
 =?utf-8?B?L2E2UUJRWEphOStrNGwvenRBRHlNSlIxaFVkK3BHTGsvYjU1Y0Y5WTlKV0JE?=
 =?utf-8?B?Y2ZTUUI0Zk1kM29NdmF5Z3R6Z1BaWVQzMld3ZVpkZVlNT0I4SHJ4bmo0QU43?=
 =?utf-8?B?dkNRY0pkTnNRNkJqeVErTnZCSU1rUExvT0s1ODNCcEdNZGQ5Q2x6c1Z1NUYz?=
 =?utf-8?B?ejhKUitDRW0zQVpOa0psVEpvNEFxY003eGgxZTBQZjJPY0hkUGJtanRwa3kr?=
 =?utf-8?B?K2REcFAySXdLWjRsdWgxYUdPNDBSUmp1RzVpZ2MrMUlscnpCNnVKVlphSm4w?=
 =?utf-8?B?cGZTam1uZzdiS0RUVCtaWTA2TmdPZlo5elpFSFZUU2NtWW1zZVk3N2ZiRVZx?=
 =?utf-8?B?MnZROWVsQlhKVXQ0VXhVUm9SWE9keHVxOVp1dUg2T2J1ejFWZi84Tk4vcGFC?=
 =?utf-8?B?V3BqMGxZL2pUNkI2aGdoSUVpRnFxczUvdEFxbHUzRUFiTHR6R3hvUlVHSStl?=
 =?utf-8?B?WHhTMDNZVzhVb05aYWFUVlJTTkZFYW9IazBmVnJ6eFRsNndwWEpOVTZpSlFR?=
 =?utf-8?B?M2RlZ0lzT1pxQkd0TUVheHlCQUUwT25helMySnNMZnZqUnF4VUVqbWFTeXFX?=
 =?utf-8?B?am9GV2NWVExsMjhkcmVDcHVJU0JMS28zd3haa1ExN3VteFhPSnNIeDRLT1Jn?=
 =?utf-8?B?YWo1ckY0SHJQU1hXdjJJeGpXcnZPZHE4U2pBZ28rRmlpMHJWN2Y2TEZKMEhT?=
 =?utf-8?B?c0JwS3hkSWx2NjkzVGpnUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5659.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eWlGV2I0dDRNUURvM3FoL05rby9jM1JXWWFmNytqZEJ1Smg5anR1WmhqU3k4?=
 =?utf-8?B?QUtJUkczd2l4cGFDSHdPeGpaZTFtNEJMcXE0WnBMOGsrTjhpVmNvbmZUV01F?=
 =?utf-8?B?UjRCY0hJTlhNSjhFYnlCWDVoTTF6UVFvMzZlZTV1cStCaGkvS0FGQmpCOTZ4?=
 =?utf-8?B?VnZUY3NzV3pXemZQVnRyRkNqQm03aHJJRC9JaWVXbWNRUmRKRFpUeTE0NTBj?=
 =?utf-8?B?MTJUamE3WTB1T1NGVzh1N1JyaXhhNEtMN2Z0QmlGK1BGVkVobXRldW01Tngz?=
 =?utf-8?B?N1ptQmJnYjBnT2h3MlViK2RuQVRRbWgzTWlWOHNrcmZHOEc1ckp0RFNIMWtk?=
 =?utf-8?B?N0tLWmJ3L1dFZXVGdVF2V2ZyT3pvNm95ZXJYdUlKNDlVRTlGYUFHVU1nNUVy?=
 =?utf-8?B?QVNoYiswNXM5WUM4Qm9jVFViSTh0UVZ5WFV2L0hLOXl4cHdnbUVHQWI4aG1M?=
 =?utf-8?B?TjFmUFJtRWtGdFlwQitHQnpqWjZ2S3JyRTFoS0VyU2VDWDNqRTFycFV0bUFP?=
 =?utf-8?B?OEh2aUpya3N4RDdxR29tN2pjZHAvKzlYQ2xxNURtVk53NHdLQy91cUFjYzU1?=
 =?utf-8?B?K2JDMFhWWmxNK045WENXSXJKU1pRWjNmN0ZNanhaL1BRMmtSOEwwM0NmNnA2?=
 =?utf-8?B?MFduNmsveHhaTExCcSswSUNsME1TUWU5OWFxeUdTeFgvczB1UEIrb0tZNnBp?=
 =?utf-8?B?c24wUE5OOEZCNHNVN21ZZ2tNYTg0bmxnT09VcHgwMk51Uy9VTmdvUnpzeWta?=
 =?utf-8?B?ZTNXV21NN1dvZS9sRUFEVGlzM1IxUVpMSG9sZVBWTWUxeGVGaU5Wak1XSk16?=
 =?utf-8?B?QkhON1I0QUNtT1FwdzFCWlU1cDZCZGVIZU0wRnlhL0czSHRJaGFPeG1JSGR5?=
 =?utf-8?B?b082WkY4VXBjc2pDSjRvZ0ZJZm0rbXkrdWdubWoxRjZUa2htRzl3UnRvN3d3?=
 =?utf-8?B?TFdkczBBalZHNGV4OFNqQnJBOWpEbVpzT3BpQXhvZ1VveW15MWpqTjRtZURG?=
 =?utf-8?B?bW9FVko0a2ZEbExIMHAwYmtRcXhEM0V0OXBGcjVVK3UyOFNXTUhqTDg5OXYr?=
 =?utf-8?B?c244ZmZVdkgza2RIaExNbzRVOStlMi90WWR4TWZWSkZxU1hqbDhERklIbXhT?=
 =?utf-8?B?cEFlWDlZYkNkOWp1c2NCdE9WcEVIcy9XSWx5THE1M3lrbHJLWTZQSGlvSUxz?=
 =?utf-8?B?eUk2NGU5aGVaeVdWdGF2OFU3cU9ubXNiUldCMnhlK2RLcmJwV0R4Wm16dGJ1?=
 =?utf-8?B?SHg1L2NweEJMbHBtY2pMWHNJK3V0bjlLYTg4SDJHTzZmZ3laRVA2aUJyVVBK?=
 =?utf-8?B?Yk9nV2owRWMxOEcwZjBuMjhybXZSL3EzR0RLWEFNUGtNSzBYMiszNEtDcy9x?=
 =?utf-8?B?T3pzSFg3M1gyd0lzVUk3YlplVTZzd2VMcHRFNklFeXU5bmk2ek5pc0tPV2hI?=
 =?utf-8?B?ZFFORk5UeXRtN29YU1VtZGZMelJPNmY0aVdmR1NMRGd4eDNJbHJKSVZHTzU2?=
 =?utf-8?B?ZHBNMWpxM3cwNzV0ZTZuUXpMSU5WdlhwTXNPbmt6YWdPZFdmMC8zYTZNa0M5?=
 =?utf-8?B?SWNKTjJQRElDNkxOb3hTeWhKRHdRbFlIeCsyUkc3Nk14alZEdGlqQmpzNTBB?=
 =?utf-8?B?MDdzNllsKzE2L1c4WXZXcXNjV0J4SlNUMWZvQ0FabFUyL0k4REE5VGpwNHhM?=
 =?utf-8?B?OXZxUCtZRWlZZk5GeWlaQTFobkJXQ0NPN3pFeWxsU1UwUHBwR0E0VWp4YWdt?=
 =?utf-8?B?NW1hQU1hZ3BxTGpzUEtCeEZPT0x2ZVBrQXl3UTRXUHFNQVlmMG9iR0JZdFZ4?=
 =?utf-8?B?ZmZCU3FXbkltZ2k2WGRFWGNQTE9vTE45NDBMRlk4V3VBcGkzK0xBZXprb1JC?=
 =?utf-8?B?WHFQNndmaG82Nml4MnlGTzg4WkJhTVFrNlM0VUczMmM0ajlDb2ROSXdWWU5Z?=
 =?utf-8?B?RHl2aVQ4Q2dpanJYcVhOdCtLUFVpSUVWa1dDYisyZk1ZdGthUWRaVitqeS9D?=
 =?utf-8?B?L1NnMS9lN0t4dlQ4UzlOOEJpVzZiUDI2akhZWXVpVDZWV3Q5cW9WNEtUYVl1?=
 =?utf-8?B?eVJKK0ZlZm5NL3JhckIyU0p4Zk12OUtGOUxOM0JZZytpQ2RUaXZjUnhFcVhy?=
 =?utf-8?Q?moxU=3D?=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5659.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d8a629-9ab7-47c3-0812-08dcecf630e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2024 08:48:50.6030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /CvogGYNJQ6lir/AhlfNu1PRuo6oAlzSvqjx/FNLBw8A+SK86vdLK3dOJqnEJb+hoLTKVDzs/AtjyHsG+RkIrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4555
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-ID: <BFE9CBDE1D791B479EC2884E3755F148@namprd15.prod.outlook.com>
X-Proofpoint-ORIG-GUID: c16ZVYOrD_jmHuI2HJ18By1eJhIySxj9
X-Proofpoint-GUID: c16ZVYOrD_jmHuI2HJ18By1eJhIySxj9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

On 14/10/24 23:12, Jens Axboe wrote:
> >=20
> On 10/14/24 11:18 AM, Mark Harmstone wrote:
>> Adds a nowait parameter to btrfs_encoded_read, which if it is true
>> causes the function to return -EAGAIN rather than sleeping.
>=20
> Can't we just rely on kiocb->ki_flags & IOCB_NOWAIT for this?
> Doesn't really change the patch much, but you do avoid that extra
> parameter.

Thanks Jens. Yes, that makes sense.

Mark

