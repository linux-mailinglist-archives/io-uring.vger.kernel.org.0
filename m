Return-Path: <io-uring+bounces-5346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 883E79E9CBC
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 18:14:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C02A1282AD4
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5568314A60F;
	Mon,  9 Dec 2024 17:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b="DCEBLtii"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2076.outbound.protection.outlook.com [40.107.95.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B47076410;
	Mon,  9 Dec 2024 17:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733764463; cv=fail; b=sn2FQekzfeTkRLw0M7/kjFW4NbvF3jIUw4bUd+3ForiT+o4a73TJOBG26ugMT1JB4uOxpPviga42mp6j+RieIP+1EdqAs0hGy36u7Z7Y+rz05pUKhrxo5NR1NDSx7meJRfF9WFukU80fZJkXDot95kaNY6kjeUWudAsGRg7W18U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733764463; c=relaxed/simple;
	bh=hQrE0oj3RWwX4NH5zjIwqM0hb/5zSGZUduto/AdkYkQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U6mSOUQpGIIbpp1oPxcMNOiT7lapUGDxA7NmNgZcD39ER3qvsimVsJ9ZzW+6I0F6xBOgooMcpBJ31d+l2caJrAtdoAtC3vvG/p5tgiXTR09Ak0LOUii281MURJkGXIrLXHyJs0ipjlYmUB5CO9M/2DyaMPjGrGw3X4MQueE9zbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com; spf=pass smtp.mailfrom=micron.com; dkim=pass (2048-bit key) header.d=micron.com header.i=@micron.com header.b=DCEBLtii; arc=fail smtp.client-ip=40.107.95.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=micron.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=micron.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rOdaKcLlJ/xu2L2qPFQKwB4cF6N62oRAdoRcSzSa3l2e+kCR6dMNpaBKIrkxBcsQfwUFoESNCgsZWCXkkmAjF0O6702CmVveVnNX0wd0HFG9eknO0K3xo6YaIKzeCUqzNxxAFWzXhO/oDFkXzf46LzoTkAqJL39caK+mJWDRoR788iMRcKYBCd/J3KOB5GkeNoA/tGID4umQtprSOBNLyZj6CvgQpUO4tIrnSj+nLuznxqYTGShS51A3Ofqs+mOGXD/qMrXAsuIEZoOzGYMTHZGiOWYTjrq4mbEUmAt+MFhRaWmTMc3e6C8N1SpB9H1Domyn/BYeEwl0UX+fqVha8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a32sYbbs9RYPnQ+lIVHJYT3wUwAX7vSg/VShC8KuQCo=;
 b=rLNifrs9InZS0OJ+p4jIjjRvYJuGqnt3Kq38qnkCp9ZpFqM7ja2SJWwcuU33TNDvuEmmMdRDaebFg782mR0qNsSdrb5z6LTBM0njHI+jIHLSj1uwF9mAX9jxCEVuIdD1qwrzGfhG6ZdRQp9FWLIwbj5dkND8Bm6j07+cEtIfoqto+RAPeL0IkYUAvP9y9xdscs0lMopCHKzxzn0dI47awTFfL7tkR4rr0flyYZWf/Aq0EYddKGePjzDlwHXRRZCTrmbiH6kjSK05WykkwX3lTm+vE53NL67tZU/Zm2YlziD0srslmgAJWvZwMwqtqR+JSIU07jrQ8DNifpE07L2jPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a32sYbbs9RYPnQ+lIVHJYT3wUwAX7vSg/VShC8KuQCo=;
 b=DCEBLtiiXkJz100/EcT85Q9ku0rRQZsevN0ho/IgDzYEZpzxu80KDqlDz4NX7v3BxrLDtswfkfdbRSkwqBVL9S1mE2znoe234Z+0jvBtoNDbnLakU3A7f2TAXthDRbQR9OAb9qk9V12Qwaxrhrax1AfLUDJrRkAw1u0BD0VjPbPFho8sUiOaXT3wyTdoWXBC2IK/uzlKeM7S5FkhVUfHcWDnCOX651lYcZa7uTF6uErZH9QaurvyrH5Tfbzo4gqVvlZyzAlMW0tLBRHHAZJesHw5K1xzkcJ5rYn/gWQ6UqqTQGsahbalSosC/hq7UVAkqGr9BeIG7dL0FpmCKK/llA==
Received: from DS0PR08MB8541.namprd08.prod.outlook.com (2603:10b6:8:116::17)
 by BY1PR08MB9875.namprd08.prod.outlook.com (2603:10b6:a03:5b9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 17:14:16 +0000
Received: from DS0PR08MB8541.namprd08.prod.outlook.com
 ([fe80::fb1c:d78b:e57:bc81]) by DS0PR08MB8541.namprd08.prod.outlook.com
 ([fe80::fb1c:d78b:e57:bc81%2]) with mapi id 15.20.8230.010; Mon, 9 Dec 2024
 17:14:16 +0000
From: Pierre Labat <plabat@micron.com>
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>, Keith Busch
	<kbusch@kernel.org>
Subject: RE: [EXT] Re: [PATCHv11 00/10] block write streams with nvme fdp
Thread-Topic: [EXT] Re: [PATCHv11 00/10] block write streams with nvme fdp
Thread-Index: AQHbSjkfn7E40X+xN02QKPCe64Si9rLeJePw
Date: Mon, 9 Dec 2024 17:14:16 +0000
Message-ID:
 <DS0PR08MB85414C2FDCFE1F98424C0366AB3C2@DS0PR08MB8541.namprd08.prod.outlook.com>
References: <20241206015308.3342386-1-kbusch@meta.com>
 <20241209125132.GA14316@lst.de>
In-Reply-To: <20241209125132.GA14316@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_ActionId=9a346177-5bc6-4c1f-9577-39ef9eb49a2d;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_ContentBits=0;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_Enabled=true;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_Method=Standard;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_Name=Confidential;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_SetDate=2024-12-09T17:09:54Z;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=micron.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR08MB8541:EE_|BY1PR08MB9875:EE_
x-ms-office365-filtering-correlation-id: 59219082-8b12-4ac3-a9eb-08dd1874e94f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007|38070700018;
x-microsoft-antispam-message-info:
 =?utf-7?B?RlYzOXB1djNnUUE5Ky1SV25BeWRrTGh3eWZsRmR6b1E3aXBZVTdkYystTy9o?=
 =?utf-7?B?ZHE0bUNkUTFvNU1SWXRORnVvSFg0TXdydERNNTFIdW1OMDBvbFYwWmpMakcy?=
 =?utf-7?B?RlNyQzd4eEZvS1BFOGo4em00STZ4cDAwZUszYm1GaGhoRmswa3UveExya1Rn?=
 =?utf-7?B?U1BrQSstbTFLYUdrOE5LMmZmWE84UE5qZkt6Q0tQN2VpTWZwMHNoQy9nVWpl?=
 =?utf-7?B?ZXBTdXJSS2dhdWtFd04vQzhqTHBlN2xkQVpOYml1anFmN0hjN0pac2xEMGhq?=
 =?utf-7?B?WDJtV0NHSmVzcVBySTFiNHVBKy0xbGlFR2h4MnF4TUJWNDZSa3ZXM2ZFUVJD?=
 =?utf-7?B?TWN5MlY0bTRIYldJZ0dRYVhlS1NIdDFFbDhFc1pNandEY0JEUHFRdnpqTFNN?=
 =?utf-7?B?aFNVbHN5TystMjV4Ky1EMjgxT0RIT010MEgzcE9rS1FLSTFCMGtrWUI2Q01B?=
 =?utf-7?B?TVFKamR5aFU4cHkrLXB6Rm1SKy13RmliTm9JcGpqTEZxdEQxa0FNeU5xdnM4?=
 =?utf-7?B?TDdKWGEzSWNGMFVTbUpaaWE5bW9zWU9vM2hSYXFDZng1ZWdCU25Pei9mMVNh?=
 =?utf-7?B?S2dTNnBDWnd3TXRISzJpeEN0b0U4eWx5SEJWZVVjYW54MTIwbXJ4dDY5amZU?=
 =?utf-7?B?elU1bkM0YW1SaG1lMVVSUG91Y3Y4VjV0a0lRdHNCR1U3NFRpTlZYLzVLZHND?=
 =?utf-7?B?d2F2RWlIZ0ZCUFVtLzR0SGtRMEtkaklIaERIT1ZDdHRWWGhqM1F4VXp2RXRS?=
 =?utf-7?B?MTE3Q2JMa0R6Ky05Q1JkU3EySlJKKy1Ob2NFcW1IcS8vcWw2Q0tYVWcwd2E=?=
 =?utf-7?B?NkorLXk4dktOSTgxOElHekczbjNiblVZSVBLa0Eyc2VHVzYvc09YMVhQQ1Z6?=
 =?utf-7?B?NElVUy9nb2g3Vno2a015ZUZ4OXFHQjcrLWp1eURwWW1wVXBJQlRqc0JXV25Q?=
 =?utf-7?B?azZmVnpLSlZWcXB1NDhWc3VUbElBNlRueGpvejA0azlwWUFhNnhwTlFDcmV6?=
 =?utf-7?B?d2pPeEdZNDU2Ky1QZHM3V1Q5TXJCbFk3Yzh1eC9vUUZ5NnQ5akRNYms4ZlE4?=
 =?utf-7?B?NmFSQUFhVEhCRTZJTEQ4N2lkNEdrQmJJZlZJbVJIRzNoaldUWnlhWHplZWRG?=
 =?utf-7?B?SXdhR1BVSGF1L2dqVnlycktPNGxhdGVGWEpaUHpRUlRqNUZrWEhVWFpmU3Nh?=
 =?utf-7?B?UmtyYm5tYmZZKy1pZlh4bnBYakkyQTZ2NEtqeTU0c2VKbnNFZEd6c00zUWVQ?=
 =?utf-7?B?NHdZRURDelNqQlJoRHRqT1IvNU5TalQ4ZzVTd1YrLVFjKy1IQi8xVi9RTWp1?=
 =?utf-7?B?dWZYSTB1S3A3Z1ZmTmZ0V2x0cTFsNlc2NVgyMk8xdkwySXlqdnlsZ2hTdG9Y?=
 =?utf-7?B?MzNVTGNGMU9BNXlKRUlncTBSUHdUR1NTQVZBVUlRSUJaeWN3bUJVMHBaWVE0?=
 =?utf-7?B?ZFJITno5UHMwMVNadnA2WGJTcUJIaklGZUNKMVdUSjU4NUVQUmdmakp0TzV3?=
 =?utf-7?B?eTkybTBXYWlHZ1pzVGpMTWhST1I2NGJrcGlLL2pKMGFvbDFSTTZUZ2ViVmly?=
 =?utf-7?B?R0t4Tm1rdENyeDgvVE9XQTBGZVlHeTA4eU1HcGR4Nlh4cnZqd0ZJV3JCVWJJ?=
 =?utf-7?B?Y1cwKy1aYnJ3eVUyR05udXhNeVZ5bXVmNjEyUVkvNU9lVzBSMTd0Z3o5UmFk?=
 =?utf-7?B?aEd0czJtWVhPOXZ1N3U2eGtPblJGcnRNTFhqRjJBaVJIM0picDV1aWlueHVD?=
 =?utf-7?B?SDJ3bHBULzdNa1puMEVoaURTSloyaGxBNmF0VjkxZ05wQlRFZUhpRkU2anll?=
 =?utf-7?B?Ky0va29rbjB6MEhMYVdwTDZkVUVFa2dLZ21pM0dnUFNaVzR6T2h4OGl5WHgv?=
 =?utf-7?B?blJyLysteHAxbUt5VHVSTkJMYkMrLXpscWk0WFVTaEhrdGdSaG5HdnpWdjE=?=
 =?utf-7?B?SistbEllSU1vVzZoZytBRDBBUFEt?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR08MB8541.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?UVd5WE5OMUNySGEyMW9nL1IxMDlxd1hsTEoyNXNiVXAxZGw3OHRoRUJaY2I=?=
 =?utf-7?B?Ky1YRUNRNzRCVC9MRHBTMENhMURXeGdYWVhKRDR4WGpaMDBUNEpPQVFvKy03?=
 =?utf-7?B?VHhTTm44VU5yOFVKazdISkdvUXZsSFNwNjg4aSstU3JMbTdNYWNXUncrLU80?=
 =?utf-7?B?U1B1dk8wcnM4SzBudm5HNUg1VksyTEFNb2J2Ky1sZWxobU8ybGxHVGdhb3ox?=
 =?utf-7?B?c2MzMkcvUzFZdDZUNlYzNjhxZjZyNFF6MEpxZlplbHB6WFJsWkhZejZKVUxT?=
 =?utf-7?B?VlpKQnBZcVNzRE5ndjVCN2kzMC8zR1orLXdGdHpxT3ZnSGVoQ3p6OW4vUjdD?=
 =?utf-7?B?R2FVWkdXQkFldHNuNkFicU1aamdiOFRwQlBvZ0hZdlZkV0FzVmdxekRlTFNO?=
 =?utf-7?B?TlBJZ0pRNjA4am02d2d2akhrNHBiNUgxdExIMnpzSklpcUpNWFE3L3dlRExz?=
 =?utf-7?B?N1dvKy1zQ1VsOTdySE9EQ0w4eE1yM1dIcGV6MHJFb3FrcDZJZSstNkRpWjhO?=
 =?utf-7?B?OTBhN0dNNy91MFNlWlFWZEVqMjRMZFNEQXJtYmdFblpwV3ZZc0lEbE9TVzJS?=
 =?utf-7?B?dWFuOG40V0gxMGlza0JrdVAyVUxqSXYwYkVqRCstYXJpOXBHZXd5SnZJZGZB?=
 =?utf-7?B?YXlVbTdDVzMrLWNhYWl1Uk5HdWlMQjVSRTZRbG5OcU9KTVR5RW9YRUNVMjds?=
 =?utf-7?B?UjMyTDQySlc4ZTZtYWdyS0tHeXMvN0xiT0pFeVc0MEd3VTNvOGRVTHBiWC9k?=
 =?utf-7?B?Tk5QUE5yWUFvdW9IN0JtUDNJQm9MU2o2TS9PZkVRdSsteTJ4Z1hMREc1WWdW?=
 =?utf-7?B?Q3Rpc25FbmVCQjlxMC92WFdUckRyKy1hbWVmKy1weFF2Sm5TaHhTQU5aa0RR?=
 =?utf-7?B?cXBRcmFoL2JHb1RZL3kzdmlJY2NjVDRrSE43eVB2L3U5UEwycURUNUs1c3pw?=
 =?utf-7?B?c0tDSzJnTjYySjlVcGFaMTJBc3NqcktjMVl4cystSTRMMmF1YVJGaVhvU1Vj?=
 =?utf-7?B?YU53THJQWmZrTGVBWm4wMkthUWlGTUNSaE5PQkRmWGh6Sk1NTEw4a09KR2h0?=
 =?utf-7?B?ZzhEUGhPaTJlT0NMSS9OUDc0U2xFS1d2Sk84V1JHREpIbldwMmdZZFp2S2l4?=
 =?utf-7?B?ckR6MTlhdDYwdVF2Ky1EOUJGN1ZER1VDeDZqL2pOM2lvL1N6OVRXKy1LY1Iy?=
 =?utf-7?B?ZVV4L0l0QlJ5WDNhOUQ0V3RDKy0yVVpBUWxWR29tSlkzdHloZTdxQ3dPWGxz?=
 =?utf-7?B?MUMxZXA2ZVVXMUdMSDdjWmw0QlpPU0xJN2c2YXZxR1ZsWHhneXM0ZWtsMWJC?=
 =?utf-7?B?dmNSTlZja2UyWlBjNlZGVkJoa3djOUF0Q3h3NTRRZnBBSlFFclVES0NpYVo1?=
 =?utf-7?B?blIxS1Fld2xUaUNYVmducEM0RUhOakRmdElPUmdERmY4cXRyRmVmbFBjZkZG?=
 =?utf-7?B?M3hvTVkyT2N2cVgzWFRjZU1BYkdHWW1xbXU5VzNNMzVXeVVVdFRCQ08vS0JD?=
 =?utf-7?B?eFVzQXNHYTFjVWdFU0daRWk1bkE1bWxtQzloeXRsejZ6YzAxUUJ1OXVaNk5M?=
 =?utf-7?B?eWV6SVZOa2gvZWVybnl3RHNCemNXVERJWUlYazZaeS9DZTVFcHQwR2krLTNq?=
 =?utf-7?B?Zmh0SlZQZmZrSVo3RVlSVVpjZ3pYOERnZTBGMHNiS1libWtzdGk2VW5VdkVQ?=
 =?utf-7?B?bGpweWJ2RDM0cGYxZVpNcTVGeGVxa2R5eFBOdWJLbU0rLWptVXVhdzF0LzVj?=
 =?utf-7?B?ZGllVGJyQ0dMZlcwQzlFaS9HOXhtdWxWOWVKYlNuNlQ4V2dlVzh1Y3BBYVov?=
 =?utf-7?B?eXdQbjV2eUM0ZFVuRGo3cistWDIvRmNjVmczUXZ0M1dZTCstb0xGLzRuU0pa?=
 =?utf-7?B?RDNuNkFvU1FXY293USstaXZxaENpTFJwN2JMUDN5TmUyd0xYVjJ5cko3VEQ3?=
 =?utf-7?B?eEpRTnNrMTJhenc4UTBzc0RtRll2Y0s3UTNoKy1MMHp6QlVxNERJVWVhQWFW?=
 =?utf-7?B?bzJaL3hVZVdlTlFLWk1vbXMwZnJYQ1VzSXR6RWhUYk5XOHVHbFE1djMybHlH?=
 =?utf-7?B?Y0hDUE95RFBaWkNGc2N1aTUwL2VuS0ljVUpFU1dDdG9QQkFnSWtNUzVBazdV?=
 =?utf-7?B?R2Q4bFRaMG5sdTN0dURLRU0rLUdsSllLT2lyZEkrQUQwLQ==?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR08MB8541.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59219082-8b12-4ac3-a9eb-08dd1874e94f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2024 17:14:16.5551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3u43863lCyZL/Kf9xdOvyn8OBZwrrXOyD/hgutvRRe5FGSVfO1GhONCO7Z2umaNiP5uVw+cDFBSuPzYI4/deNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR08MB9875

Micron Confidential

Hi,

I was under the impression that passing write hints via fcntl() on any lega=
cy filesystem stays. The hint is attached to the inode, and the fs simply p=
icks it up from there when sending it down with write related to that inode=
.
Aka per file write hint.
I am right?

Pierre


Micron Confidential
+AD4- -----Original Message-----
+AD4- From: Christoph Hellwig +ADw-hch+AEA-lst.de+AD4-
+AD4- Sent: Monday, December 9, 2024 4:52 AM
+AD4- To: Keith Busch +ADw-kbusch+AEA-meta.com+AD4-
+AD4- Cc: axboe+AEA-kernel.dk+ADs- hch+AEA-lst.de+ADs- linux-block+AEA-vger=
.kernel.org+ADs- linux-
+AD4- nvme+AEA-lists.infradead.org+ADs- linux-fsdevel+AEA-vger.kernel.org+A=
Ds- io-
+AD4- uring+AEA-vger.kernel.org+ADs- sagi+AEA-grimberg.me+ADs- asml.silence=
+AEA-gmail.com+ADs- Keith
+AD4- Busch +ADw-kbusch+AEA-kernel.org+AD4-
+AD4- Subject: +AFs-EXT+AF0- Re: +AFs-PATCHv11 00/10+AF0- block write strea=
ms with nvme fdp
+AD4-
+AD4- CAUTION: EXTERNAL EMAIL. Do not click links or open attachments unles=
s you
+AD4- recognize the sender and were expecting this message.
+AD4-
+AD4-
+AD4- Note: I skipped back to this because v12 only had the log vs v11.
+AD4-
+AD4- On Thu, Dec 05, 2024 at 05:52:58PM -0800, Keith Busch wrote:
+AD4- +AD4-
+AD4- +AD4-  Not mixing write hints usage with write streams. This effectiv=
ely
+AD4- +AD4- abandons any attempts to use the existing fcntl API for use wit=
h
+AD4- +AD4- filesystems in this series.
+AD4-
+AD4- That's not true as far as I can tell given that this is basically the=
 architecture
+AD4- from my previous posting.  The block code still maps the rw hints int=
o write
+AD4- streams, and file systems can do exactly the same.
+AD4- You just need to talk to the fs maintainers and convince them it's a =
good thing
+AD4- for their particular file system.  Especially for simple file systems=
 that task
+AD4- should not be too hard, even if they might want to set a stream or tw=
o aside
+AD4- for fs usage.  Similarly a file system can implement the stream based=
 API.
+AD4-


