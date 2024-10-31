Return-Path: <io-uring+bounces-4261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D719B79F1
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 12:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC1191C21020
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 11:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5FD019B3E2;
	Thu, 31 Oct 2024 11:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="bMDPwvbX"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8885919ADA3;
	Thu, 31 Oct 2024 11:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730375083; cv=fail; b=a8XZrtg3zLKmR7xB8LkStM8foJlac9icSjO1JUKoWSRhOo+1DX0ln42piPE8/NhVkX4+2pCdJ1QzRi3dSMxAYEbNjJjLLwRQqlxEY/BcG7Q4bEwGUXCcKH7Swb9Hc9xKqYQkRe9wuxwvQfqcJ62ilR2kaDbUOoTpgD/N3woaTok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730375083; c=relaxed/simple;
	bh=zDJ4hGGVPm46CQOl0wizfUwqBcdBeKZ8llsL9sPk1YE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dHhXEGnomOf0d6NXLuDmBPVI+bCYNaOcus8oAzO/eEYfU9LZExuj0WNYlNQ4M0KbaxzQWU7ZP9w4MTun82tj7jgSkQsWuN78Wl+ZodK7wVvj0SAHWaJSSAPGW64lEB+24ez3ZJikBVqGZYWYP+BrN1BhOKa7iMhVl4rWdQUFULo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=bMDPwvbX; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 49V8fRe7008196;
	Thu, 31 Oct 2024 04:44:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=zDJ4hGGVPm46CQOl0wizfUwqBcdBeKZ8llsL9sPk1YE=; b=
	bMDPwvbXmG+dgiL1Uo35nCFpZ22pk4cr7Ore9vDFLr3CAlAAqG75rSuPMY9+C/x0
	zor1Yb9WPHui8w/VXJH9jTXZYyd4gmFnwbaw2nQdzY8YQ+JETIiTn74oy8MnX0+g
	5X6CDZYY5MBlvBSQQRvz228Ch8GQn9xcmcO7Nta00lOaP44KRUtCD43YxNh0mT84
	I8IWSnsKKjy5F0dTZQCbgkLKWqEg545l0dLZS7NGThj/jahdcWnIY43f39jSS3jQ
	VR52jnex6OMNScJgec+N9NGDTZavLP2j6meRWCEberG2Ekg8yYB6464khBFox6VX
	580cHqsMaBYVCvceqYnbTw==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2045.outbound.protection.outlook.com [104.47.58.45])
	by m0001303.ppops.net (PPS) with ESMTPS id 42m6j10vv9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 04:44:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cv6c9zN5LX18sBlHfYve/++DACTyIEEXm2tf+VsFm7X2oPJ+u98Psgj+oxAe3uTrGQTczuBVheiD2c/DGeIJ/+EM8XSLG4pnfccxKfsClL1H7e9r5yAQFU1OI5OdnV/+BZaI3KRKmpdqAQwVaFtxlwNhyP8LafsxAdt/iVAc3Yn1aqePPwjtdUpeSIsibh4urhX6cBrDjVVQ8WVTwoljYlJaZFH62K6AzmBOFBLxtPTkpnlFJo8YgjgUFpla88U1QL86e96KbYOJkbHAm328LX6Bra+pFJHatIbIH2xB4LIkLBnZBy5uzuF8V+nrRzxQm7o2j7my6fVgz173y5a0Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDJ4hGGVPm46CQOl0wizfUwqBcdBeKZ8llsL9sPk1YE=;
 b=Ezg5Ld8KCh06FGT4ciXeYp41Ymr3hZhZcJ70RoQBzb5r7XIZnnC1KEw+Df6xPVJFPURKHyPQqceaJRHAVUg3DUeBSZMY9HMMKyk4YM28S3svWLxqhiCWGgZoeIvfeSJWZKybtRFw0NViaykbc2uCRZH8ow5hpZF2Bw5XESOLKyhD3FCdN8Lu8MUSfqHhksgv/RAgGsfFUIxxzgravTpnPYWTNm5DvmGrhlX85bQedCQ7SJXeDZXBayr+torF6nf6N49hj//ZS3c4oAv5Drih7X/DhME+4v//QNuEJ+lobJDutybhu1/Huz2SMH5QOaDmLQHSAhR/0skyYAEnQOdYJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by DS0PR15MB6257.namprd15.prod.outlook.com (2603:10b6:8:166::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Thu, 31 Oct
 2024 11:44:36 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%6]) with mapi id 15.20.8093.024; Thu, 31 Oct 2024
 11:44:35 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: Anand Jain <anand.jain@oracle.com>, Mark Harmstone <maharmstone@meta.com>
CC: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/5] btrfs: remove pointless addition in
 btrfs_encoded_read
Thread-Topic: [PATCH 1/5] btrfs: remove pointless addition in
 btrfs_encoded_read
Thread-Index: AQHbJJHC+bSFiVDmEkeKVxaQcXoiZbKekgCAgAI5XwA=
Date: Thu, 31 Oct 2024 11:44:35 +0000
Message-ID: <8781620a-051f-48f6-8b7e-335679c7831b@meta.com>
References: <20241022145024.1046883-1-maharmstone@fb.com>
 <20241022145024.1046883-2-maharmstone@fb.com>
 <a3e107b6-9878-4b06-9b9a-2abf3bbf9a43@oracle.com>
In-Reply-To: <a3e107b6-9878-4b06-9b9a-2abf3bbf9a43@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|DS0PR15MB6257:EE_
x-ms-office365-filtering-correlation-id: a0b47ae1-f7a5-4d57-a5b1-08dcf9a164dc
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Q1EzZ3ZZdVZVWjVIVVh2NmRpNTN5ai96VEZoRmhxWmJIRjhBWmNQbURLSC9u?=
 =?utf-8?B?aWljL3JNVE9GZDZyK1gwSWhRZ0g4TUc5UFUxVE4xd2FJUVArcDZYNjFrRHJH?=
 =?utf-8?B?RjNxd3BHc2poUGw3cENWeUJuV2pXYjRvUm81dHR0WVQwV0JtM0lhdWpEa2JS?=
 =?utf-8?B?akkvR3c2UFZJbWFkeWdyS1k0dk9nVGt6SnkxcVpwTktSZ3ljTmdUYmNwcyt6?=
 =?utf-8?B?ckUvT3RoMGlURWtBQ3RiV1hFY0VydVVsZ1VISjIwQUZVN2J3RERUcmdCVWxz?=
 =?utf-8?B?YllxSVAxQ256NXVrVU80R3VBaWIwRWg3VHRFSUtjODEraTFJOWdDSU0wTVRw?=
 =?utf-8?B?ZnF2QVBuUXg0T0ZlK3YzZWlSVmNZWFZBaWVaZEZVcVNaZGZ0Q2hsb2VtMWhw?=
 =?utf-8?B?bko1VTVtZzY5SXU4VDJIR2xmS09vY2RNTXpjUk5NU2dRK3kxTmtNekYxMmw1?=
 =?utf-8?B?bE85SDhublg5T0hGVGhYOUs5eVU0RWNPVXV1M0lZRnU3eENXNkRCN25SQVly?=
 =?utf-8?B?YXhvR05CS1ZiVU9xYUtsWFBLUWNxa3k3OVFIKzRycWR5RVdWZldXS2ZOczl6?=
 =?utf-8?B?ckJtWENqRDU4cFM2aFlzaTc5NVhxMkhkY1dnMzMvbVBPeTNHNjJrcnFlSzBn?=
 =?utf-8?B?WXcrU3lvZTBKTHBiWGdLSldZYmgvWStDUnpOKzlkRTdqN1JGb0VhTjkxbXNL?=
 =?utf-8?B?Y3VwM0xPcnQ4MmhKYmJoU0hLMVAyYWdhbk52VHl0SU5WeXZoMEJwVlRqcjZC?=
 =?utf-8?B?UldYNTVVbnlRRUtobzdPZlFQaEtjWjJTcDd6UEJSY3pEdTVwdEFWbjVqenAw?=
 =?utf-8?B?UU9JUStzbG5oSEJHUHhYZi9LRW0yMTVHYmtiVGdFRmxJRnN6bmxTL2xkVEVT?=
 =?utf-8?B?K2FzcVJ0SVduK0YxYWl1aS84cDlLRytYOEpRMmQyUnpPclFBMkNaajlHYVQ1?=
 =?utf-8?B?WkxxWmtOVG1pRTlFaVJONTBZOUNCN1h2WC8rZVIvcWF0Z0JDOUU3NGhTcGE3?=
 =?utf-8?B?VTJRMWtwcUg1OVpTK21MTWFqamRMRmVjdmx6MDNwTmtUT1BYaUFiaGVQd3lw?=
 =?utf-8?B?WlRHcmZzTTFLbmVWZFVFUHVreWdPZHVKV3FYV3JRamo0azJiRmsxb3AwcXMw?=
 =?utf-8?B?RkRDNDJkWVo0K1VJL01xcHA4WkxTcVRESXgrMlpINFlJTW1yRWxMc3BMWkZB?=
 =?utf-8?B?NTRDNnQxbFJTbklCWllyeFBGNVJBNHlMbW5yYlkvdEVRajQ5MXlZMzE2WnFJ?=
 =?utf-8?B?eTZIZ2ZUK1hHdVJUaktOeHJRUFRnUlljSE54YkVhMGhMakRoZkx4OFRKL1ZV?=
 =?utf-8?B?MVZIQ2t4SXBhN0dmcjhqNmVqWllLS3d4cStmc0NQdHVsVVJOMldDV1dBOTJr?=
 =?utf-8?B?TTdsM2wxU0sxMUNxRE1qSzFKbW1ZZUpJU01wdTZXamQvZ3NrNHZ5K085Znlj?=
 =?utf-8?B?b3NCaG15SUxWN2dRV3U2ME9YbTI0eFN5YkZXR0hBaDQxcjExaWJybjJMdXFM?=
 =?utf-8?B?ZCtiNEtKaFJmWGh5a2w5dDViMXNRajl1c0ZYZFA3N2V1YmtxVmhMTVVLaFNq?=
 =?utf-8?B?WjFGT3lwZ1dLbDhxRnIrTXpSOGd4MkJqK0dYamZjUWI1OW12T085TEcxeEEx?=
 =?utf-8?B?SHhma3dIc21IK3M2S0xkcCt6VHJ1WlNHN1d3K3A4VE5JZmJDS3RvTVlROHhn?=
 =?utf-8?B?MXlZcTFZVUt1d2M2YndDQjdXNi80dzRpWSsxU3gwSHhrY1YrSU9rTm40OEEy?=
 =?utf-8?B?b29sR1FoUDRUdC9LakJ5d0xZMUxEM0phSkNWcEdWak53RW9ZcU5jdFpYSFZx?=
 =?utf-8?Q?4rVnHBJ7qh2mRU7BTQXFbky7zYyYjes1j7ZEo=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V2dnZW1yNTYrZWU4djA2dUI0ZnhmakU4cXNvYWkxbkpzaWJmOWJhcXgwNkNy?=
 =?utf-8?B?NktDRytZakJQL0ttMUd0LzVPTGtsK2tGS2dodG1pcDZ4V1lxMUNSQzl4QnRU?=
 =?utf-8?B?eERod3lMdkJvSW1MVldQV1ZZS1VjV2ZXek02VTdHbUtBMnVORU9QS25CbE9a?=
 =?utf-8?B?cG9oT2ZOcVpITFpBU0IvNGdBd2ZUTEZXdkw3U1JjZzZJcVRoTlk3SDhWb2xS?=
 =?utf-8?B?WTNWeFVoRkVRb251WmhwQWtXL1BFWGxjb2xGTEMzUUdBRlZ0Z3pCSlNEZSt5?=
 =?utf-8?B?VVd5WlR2dUUyY3pwN1FldFNrdVB5VU1DZWh4WitQWmFyN244R1p4QWZETTB6?=
 =?utf-8?B?bnRNOExSeHhkNnFpK0I5ay9YSmhHWGIwR09Bakt1Sk1tT2RDRGIvNlJPVkZw?=
 =?utf-8?B?SFA2dmF6Z2w0ZFB5SVp1ZUVXQlh4dkFxcGtmc3dRUFJTNU15SFFLR05Icytm?=
 =?utf-8?B?OEgraDNFYjBKVVpKcGlvM3RDZVZ4SCtMUzNvbGN4SlM5R1dzQkVpTXdYQjNG?=
 =?utf-8?B?aUkzRHpWZStzSnBjQTNIWlpHRVNlUHNra2xXdjROeVRTMkJ6TFV1bkl1UENy?=
 =?utf-8?B?eE9VVlFIK3A0TFJqUEdleDBMYTBDU1BsVHpxK3QxNDZScVBiOEF2VUM1dVdh?=
 =?utf-8?B?VkMrelJwRXh1cEZEN0lTN25WTWdGeEFRMENNS2gza2lzSmFNdzRtUUd5alA5?=
 =?utf-8?B?QzBxOG83NXdEWmNwMWZHTUNMaTcvUjNEUGZMR0ZpbkJ0aU9tMS9ISWIrR1Rz?=
 =?utf-8?B?eVVwZlZKRVdyeTgwazFXY0d0cUdzb0w0WjdCYlhWY0FzUS9tMUJXU0JpZmM5?=
 =?utf-8?B?ZC9oVDBEaFZwZlZ5d1Y5eVhPMlVwOVo2eHQwMTd5L2lVS0l4Y0F4QVVWWXJT?=
 =?utf-8?B?eC94QnhRdk8xZ084RXFZZTFSUW4xM1kwbFpBbU9XaXlCWHRVemo5OXN5RWZp?=
 =?utf-8?B?QWZwcGZiOU0vSUd5OVY3ZjB0RCtlQWtmSDdIdnJzb0x0QnFTNGFvK0dITnl1?=
 =?utf-8?B?YUF5OW5acStSVms3QTNLdnJzQ1lwdWNnS0NUcU5nbzgwZnZlOGlRMlV4SGZV?=
 =?utf-8?B?b2ZSODBUdDFVcUJXYWpZamZoMHFEWjFKWjIyRVZobXNSRGtaQUZXYUxLc3lR?=
 =?utf-8?B?VlkwZTRaMHBtbHJWcmhkeWczL0ZkbTc4b2c2WUllWjJabW4zS1M0VEZHQmp3?=
 =?utf-8?B?aldNajg1alpkRUJhdVJCOFBNQmVGUlF2V2RlU1BycmdFcXFVQm0rNmhqbzBV?=
 =?utf-8?B?K1dBRm5rK0xLekhWaDhCY2FHQk8vZGFFOVU0YUVwZkxqOU1HeVFRU0dQT1Jk?=
 =?utf-8?B?Z2lYVXBESEJZaGUwTU9qOTFybUNvclBiTktRb1BST2xwM1dBMEtiZXNDY3ly?=
 =?utf-8?B?ZlNkUTJTODU1TWdWOHljd1pHZ3NjRWVjYVVTSU5ScVRFeS9URTY3aHFaTnZX?=
 =?utf-8?B?S2VsMmtXeGJiU2VJVCtmZHA2cFFOZUZHcTFsck1BNWUrblJDVThOZElRQkVO?=
 =?utf-8?B?U21wRXZaQTZQSW5rMFZxdkg1TWNtdk56a0ZzdEI2a3F0aTlUTGNuckdNQmFU?=
 =?utf-8?B?U2tYZWp3S0tRZnZKbWpKUkxFNjFaMGdOeDg3aS9DQXczT0ZnRlhiY3FreWFR?=
 =?utf-8?B?YTZUN3Z1VjFXbUc0WnVEN1dwNDIxTCtxWHdFMXdNTDhBeXJqY3dNZEVQVFZz?=
 =?utf-8?B?WVRFcmx3L3p5dTB6cWFucXQ2TEVrbWZsY0tBWW1HalV4ekdjSm5SV0J6OFJ4?=
 =?utf-8?B?MXBqbFdSNzVsV0JzckREejZmMzhpeU5vWVB4dEdzUkNnMkFSRlozR0pRSWVi?=
 =?utf-8?B?bnlpMlN4L1o4SUUva3JBSnFQQ1Z1T2pybXNtcEtycHNEamJxTmgrQVVWbXRU?=
 =?utf-8?B?c2xaakpNNnNPNE9NcHFDeFk4RlBndnRxZmdFcTJJWFFldk1UdTB1QXc0VnlM?=
 =?utf-8?B?ZlIzZFpoME1sZnBEMVhzYUZBTkRua3N1NE1uYUtCdUJJQVIvMXc4VjJJa2J3?=
 =?utf-8?B?Q2FmdVRDUTA2QkFGc3UzcTBqZXZwZ0lBYXdsbXJLei80bUJDUXZoMjdnTEN6?=
 =?utf-8?B?STZGTmV5NzhHK3JibTdDMG84dzN0Y04yb2JRb0hYYVM3Z2NxcWtsTVVEd2t2?=
 =?utf-8?B?YWpLa1pDMHBKWnh2ZVQ4ek9VZEs0L1lkbDFQaWVnUCtzMFBTV0JwUStHSUF3?=
 =?utf-8?Q?WfkPqJR0bBh6vm8SEOH/gKU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D89C08AE194666449189D9AFD4F3E75F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b47ae1-f7a5-4d57-a5b1-08dcf9a164dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2024 11:44:35.6960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nloWxtAxO9J/KdjpX+gDmQjCMestxRSTy8AGpwFRQf/S4HckGL+ETvQXFoWylV9WlUaOo+7Krv8BvMWuHMOzjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB6257
X-Proofpoint-ORIG-GUID: Pc62Fq_ylT15n0SRGekRgt0ZJ-dR341U
X-Proofpoint-GUID: Pc62Fq_ylT15n0SRGekRgt0ZJ-dR341U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

T24gMzAvMTAvMjQgMDE6NDYsIEFuYW5kIEphaW4gd3JvdGU6DQo+IE9uIDIyLzEwLzI0IDIyOjUw
LCBNYXJrIEhhcm1zdG9uZSB3cm90ZToNCj4+IGlvY2ItPmtpX3BvcyBpc24ndCB1c2VkIGFmdGVy
IHRoaXMgZnVuY3Rpb24sIHNvIHRoZXJlJ3Mgbm8gcG9pbnQgaW4NCj4+IGNoYW5naW5nIGl0cyB2
YWx1ZS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBNYXJrIEhhcm1zdG9uZSA8bWFoYXJtc3RvbmVA
ZmIuY29tPg0KPj4gLS0tDQo+PiDCoCBmcy9idHJmcy9pbm9kZS5jIHwgNSArLS0tLQ0KPj4gwqAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA0IGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRp
ZmYgLS1naXQgYS9mcy9idHJmcy9pbm9kZS5jIGIvZnMvYnRyZnMvaW5vZGUuYw0KPj4gaW5kZXgg
N2M1ZWYyYzVjN2U4Li45NDA5OGE0Yzc4MmQgMTAwNjQ0DQo+PiAtLS0gYS9mcy9idHJmcy9pbm9k
ZS5jDQo+PiArKysgYi9mcy9idHJmcy9pbm9kZS5jDQo+PiBAQCAtOTI1Miw3ICs5MjUyLDcgQEAg
c3NpemVfdCBidHJmc19lbmNvZGVkX3JlYWQoc3RydWN0IGtpb2NiICppb2NiLCANCj4+IHN0cnVj
dCBpb3ZfaXRlciAqaXRlciwNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBidHJmc19lbmNv
ZGVkX3JlYWRfaW5saW5lKGlvY2IsIGl0ZXIsIHN0YXJ0LCBsb2NrZW5kLA0KPj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJmNhY2hlZF9zdGF0ZSwg
ZXh0ZW50X3N0YXJ0LA0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgY291bnQsIGVuY29kZWQsICZ1bmxvY2tlZCk7DQo+PiAtwqDCoMKgwqDCoMKg
wqAgZ290byBvdXQ7DQo+PiArwqDCoMKgwqDCoMKgwqAgZ290byBvdXRfZW07DQo+IA0KPiANCj4g
UHJvY2VlZCB0byBvdXRfdW5sb2NrX2V4dGVudDsgZnJlZV9leHRlbnRfbWFwKCkgaGFzIGFscmVh
ZHkgYmVlbiBjYWxsZWQNCj4gdHdvIGxpbmVzIGFib3ZlLCBhbmQgJWVtIGlzIG5vdyBOVUxMLg0K
PiANCj4gVGhhbmtzLCBBbmFuZA0KPiANCg0KVGhhbmtzIEFuYW5kLCBJJ2xsIHNlbmQgYSBwYXRj
aCBmb3IgdGhpcy4NCg0KTWFyaw0KDQo=

