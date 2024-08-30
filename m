Return-Path: <io-uring+bounces-2981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 634219662EC
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 15:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B093281AF4
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 13:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205311A4AC6;
	Fri, 30 Aug 2024 13:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="F4uvhFZU"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02471A7AC6;
	Fri, 30 Aug 2024 13:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725024563; cv=fail; b=NmvTKksfaCpT3ZlJPWYu9Jd2RY66q6K1KmU2orrM1yVNHktgCuq7N4yLS1/q32/djJ9MrKFZld2BanZLkDAfwya4Yn7pxDZfzZq8t78sdCK9nfPxep3GoJabTbRTwsX8htbFIj5xOhAt9Q5mEx0R8ObvXi0OQsYVQrJVINOQR8M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725024563; c=relaxed/simple;
	bh=VenQ5SN5MBTcNpyxditTAecZ2shv7UTiSV6faHKNdlw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oA/uYwALpa8tYAaMmgP+7OFWhEPTZGY0oEqVUaLibny25nUpk3brWrPmq4PN/6QFpawR1mzpzmPtlw2m4aP6es7nF+Kb3dgEGsKGEIBarjbYUqZPHXsk+nkg+9Z9B99Rj2nvBW0PR8B5E8/c7unSuc91TMOKN9kKfO1xBAi/MdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=F4uvhFZU; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171]) by mx-outbound44-16.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 30 Aug 2024 13:28:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kc7KVddYL/+L3U5O3HgO0WcSmjlEyCAfRu45WnjwJgTVbNAI8K+MTVa+e7fVjm02H1BOFbD9Y27QCGW/8cj822o6mhnhc2aonq20xk5JnPKALIyOHtGORvk3fvD1PcGP+GWuKjzefIg+kR55jOyTc0IiQgHvP+p/uJeLx0CUHU+ciNj8iW28lnLk6IX7D0EaHEubXZpA6Q3TtNGbGVGqCLCE9TkWwG3+XFOlc0P7wg89YAOCXkbPXz58CtpcNHEB7NAilUezfmKYntUofSRjc9CBsTWYwocuYGrSSfEXY6KqpUdGgrHeEwzYH3BL1BSwQaoJEt2UxJhBM3izFFL2SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VenQ5SN5MBTcNpyxditTAecZ2shv7UTiSV6faHKNdlw=;
 b=vrSPuGkqtq9PrIyP2yjaMYh4h65kepAPTSyWUw6zZ0N7ieXbMYYbp/Ia9H3ls8dSJmhrFLQkk3onr0k0lILCaHZaG4I5M3dGhWy8qgHCdnPZfXu8EpMxiAG8xEgIC9rPAsdPpaL8WpLBrBjap4p+EU1u/11FPl4aSwKtJAigVWK7QT3Qae7a6umMvlIndRciq5pPHIkGZRaE/xE920VdVgSbmqis3WIyK8P6Ssu9WNTKKYBkTURbRG6etDBfN9UaE7BMbi9KBTqj6Mnu+Tbz+maTnHoeNNdb1KFv1/wVNthkHX6Wi6/82p3iziKL0F6BcXNIfERtJujTUdBlIS1emw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VenQ5SN5MBTcNpyxditTAecZ2shv7UTiSV6faHKNdlw=;
 b=F4uvhFZUE/xAWj2oztOqs6ktwNGTB8Ug526p9rjPX/MN2yjgOW6AsOrdGqnPb1/WTqSK1pZydx8LAY+XQB1YxaPV2VqLHeQAXM07ORWnGDgFBgdT0HNjK939q5fhbPt4DcFFYzasI2H9BTEDISjp0XmjG1iHa8CxtVVZlIYJJJo=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by SJ2PR19MB8273.namprd19.prod.outlook.com (2603:10b6:a03:558::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 13:28:56 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%2]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 13:28:56 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Jens Axboe <axboe@kernel.dk>, Bernd Schubert <bernd.schubert@fastmail.fm>,
	Miklos Szeredi <miklos@szeredi.hu>
CC: Amir Goldstein <amir73il@gmail.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>,
	Josef Bacik <josef@toxicpanda.com>, Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Thread-Topic: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
Thread-Index:
 AQHasfIoshMbsaqF30mIAtaLNshpxrHCTJsAgAAjJYCAAFZxAIAAIfsAgADrYACAAGKcAIAACccAgAANowCAexUjAIAA9eCAgAAEpwA=
Date: Fri, 30 Aug 2024 13:28:56 +0000
Message-ID: <f5d10363-9ba0-4a1a-8aed-cad7adf59cd4@ddn.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <CAJfpegsq06UZSPCDB=0Q3OPoH+c3is4A_d2oFven3Ebou8XPOw@mail.gmail.com>
 <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
 <CAJfpeguMmTXJPzdnxe87hSBPO_Y8s33eCc_H5fEaznZYC-D8HA@mail.gmail.com>
 <3b74f850-c74c-49d0-be63-a806119cbfbd@ddn.com>
 <7d42edd3-3e3b-452b-b3bf-fb8179858e48@fastmail.fm>
 <093a3498-5558-4c65-84b0-2a046c1db72e@kernel.dk>
In-Reply-To: <093a3498-5558-4c65-84b0-2a046c1db72e@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|SJ2PR19MB8273:EE_
x-ms-office365-filtering-correlation-id: b60464c6-aef8-46f2-9419-08dcc8f7b2fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?S2pITitGNncrUUhpRW50Y0pudXdqWFF0QUt5N3RORWtPVzNnVkJPWHlXdm8y?=
 =?utf-8?B?bGVLRjFYd1ozNDJOR0doU3Rkcm4rSjArL2RCMi82UmZRQWdkU0R5V0xSMW5H?=
 =?utf-8?B?QVZFbmoxK0xWL1pXeDI1WDAyT2ZZQWZtbXFzL3grblVPM0dsdUFlWlM4d01u?=
 =?utf-8?B?bjlyWm1KOFVUUlBIaGNGNUFZQk5QS3JVRHYvWG8wQk5peElpZkxGZURjU0xV?=
 =?utf-8?B?K2F5RVl0ZllRa0NIVFhxblBBWTlRS0gzRU9qS0paSnpxQ29pVlR6ckxGSU5C?=
 =?utf-8?B?V3hlcUdCeHdXbERBYlZ6K3RKNmNoUTEyVEtFTWRDSW83dUQxU0tSQzBBeFJm?=
 =?utf-8?B?Q1VjK3JYVnhwSjgzUFgwZ1FLRTUrY1AxeG1MdGRWS3BOSUZvRS91UzVRRTZS?=
 =?utf-8?B?amJwM1ZkRjNZYnZUT3pMUnM4Q1h2TWRoV2c4R21ydUtEZ3RYNm4ycUpuSjg3?=
 =?utf-8?B?RU51RWltVTBOUWJoc0paZG8yY0JvSTA5TEhBRzU0eGg1NDVPa2xkU25ET2o2?=
 =?utf-8?B?L2kvVWY0c2c2ZlFmdG5ZYkJWYWJidlQ2UnVWVjI0bEhhZTJITDRyYXRIMVVK?=
 =?utf-8?B?VGJHam5WMjQ2SmNMRFRzbVBMbzh0WHFwZ2Z5dFVnNndldHoySkRCazhqVDll?=
 =?utf-8?B?YkUyMFhLK2tCUURNUk91TjRQQmJCUjExZUlOMTUzYjg5UWViY2hlL2JTai93?=
 =?utf-8?B?cTk0S3pObGQ1ak4wQmxxVHUvWjI5VjE1NHZUUmxUWWE4N2FBdDM5UzVwUElV?=
 =?utf-8?B?Y0xtc3lqZDdwQkNtRDJGU0RwK0N4NE92bGIzM0kyZ014ck40dDM4a2k2VzV5?=
 =?utf-8?B?UTl5MCtRR2RGZCtUNktDM2h5Njc3dHEzSVluWk5va3k5N09UM2FJWklzWiti?=
 =?utf-8?B?YzZkMElhWkJnOTJ2ekpQbm95eGRGTEZzeGxTUDdxVWhzUklzNVNtS3hyZFB3?=
 =?utf-8?B?dVdVYURlK1BVOFdjTzdHWWs0YjNMZlRkeDZYZFkrR1pyN01ocVZMYnNQcjZV?=
 =?utf-8?B?UFcrdFU2c0lod2RYS1VCZjlkL1luY3lwa1NhbHdySnNnanVvS1Q4dXcwSFBz?=
 =?utf-8?B?djI4cDRpVTk2QWlkK1l5UERIYzBFbGRVNW5qZzhxcFAwQVBMSXZRM0l1YUtU?=
 =?utf-8?B?RWZNNkVsYytNeDNqcEphZGRDdytvaU1sVVMvTVVWeDBXK25nQTJmSmFnM3lq?=
 =?utf-8?B?cmRtcTdYSW11S2JLUElaZitGbzB0NnAvNnNBNEgweHkxY25tM21PcmsxbHlY?=
 =?utf-8?B?ZnZnZG5FRkRjcUZyUnA5WFVWUzRuaDFXalBta1QyVE11RGcza1UyNVZyTVpY?=
 =?utf-8?B?V1dBbERMTlNPNWx6eHJxMHRCd0R3aHk3eTFnTUtqM2FQVFloMExCK05aMnlk?=
 =?utf-8?B?SGFFQkpQbjErQUZwd05hZWhTQW9kMlZPbE5RbVdneHlHeTM3SDZnd0JiSG9D?=
 =?utf-8?B?ck5RMVZueCs0T3JlT3BreExITkQ0MHFXdGxkejVBRVUwUjk2RFdtY3ptYW5I?=
 =?utf-8?B?MHBFQXRrREZmdWZ3Ym14T1YyaTRyMlZyM3pDcVZvSkp2UXp4YmRMc3VXTEJH?=
 =?utf-8?B?T08zNXhrZnpPM1d6WlQ4N2gwNW5Xd3QwNGM4OW9JRzFhWnlJUkhZNmtnczZi?=
 =?utf-8?B?REFuSWhTbmFiSGd2NmFXT29sZGJMQjEveTZUSXIxRWY2azFDZXl3dXlaOTk5?=
 =?utf-8?B?VUhQdytLUDJCUXFsdnJlNWNKR1BsTU5zQllka3EzbnJFdUtmS1dnM1BsZ3NP?=
 =?utf-8?B?NmZZV2tVNjg5ZTNNcVJRdkM5dkVQb0Rtek50L09BRHFsRFovWEVKTVZhMXhI?=
 =?utf-8?B?K0FVMzRPWEVxOTROS2VRZU05NEM4Q1hudW8yNUZ0YVYzSlhNaS9GYjE3VWNU?=
 =?utf-8?B?ZWF1T21PUU9GOGtHL3dnbHJ4TEgzYTZHcXZqVU1FUG1CaUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ODAwaXBqNElwWkQ4bFlzdk1WcDZaUWN4TDhoTWJ3UlBicWN1ZXoydVVndC8y?=
 =?utf-8?B?NndjUEttc2o4RUI1b3FxSHFaYXQvbGtiSDl4THVZc0JQNHBYZFN4eWRTaW42?=
 =?utf-8?B?RWVxNjNMNGV1WDErUzZ6YzVOeWN5b3lHOWRBM1M1OEhqVDJIQjR5bDdXSjZC?=
 =?utf-8?B?TkFGWjhvRCtsckxMVXVhaERMcURrQ1U1UnlkZEJqMzZoVE5NM09DNTIxaWxx?=
 =?utf-8?B?L1AyZXlBMVZBaFRZWDdZYUdjUjkwOURWYW5wVUtEaGMzL2Y3KzZTQXZsVzVj?=
 =?utf-8?B?MXBXandiMFpJaVBrcG5YMkpTTnFlY2VRWWRsb3Z4VkhOWlZsMVpJNTJOUkZE?=
 =?utf-8?B?K291QnVBVjNjQ1VBZXJjemZxNk5CSUhOUmtoWnVldm1tbHVkRm4vOEVzeE9R?=
 =?utf-8?B?RGRXSW5nSjVtOW84QUVmeVpJRE5yNkZIVlMzN3Izc2dGSWFjaGZvNGt5TGpw?=
 =?utf-8?B?bW1Mb0ZVU2piSDVPWEpmYTljREJZZC9JR2oxWjFmNHJiUWV2T1o4cXU1MUlW?=
 =?utf-8?B?LzkvalVFT0FzczNHVTkzWGFZaUN0dFJibVZ4bm13Y1lET1lOTmo1aGUvOGdt?=
 =?utf-8?B?V2U4NFlyNGNxamluSktKTkY0ZGtVNkZDNXhQaVNFckJHWEdhckcwSDNwZzBh?=
 =?utf-8?B?VlBlY1ZZMVVNRlVDd0t5bVBjTFFaQ1U0R290QysyR3kzMjJKTVFNemFCcjVE?=
 =?utf-8?B?QzVPUkQzRUd0cW1QSE0zTFRuOFFBRllNejNFdXl1MkZzODhOWGtuTjdvaVBp?=
 =?utf-8?B?emV4OHp1VnVPZTRxNmFtYlRZVjE2bFNXb2doVldIeng0SXVMMnhCYmdOQW9G?=
 =?utf-8?B?WFgvbkROZkdSbGM3bVJxS2xvREZBb01XZjVTY1piWWs1RWdrU3V4WTVTSHNG?=
 =?utf-8?B?R2xXc0dZVGdNWEsyR0JWajJ3ZmRYaW5leU1EM282VDhEY2tieFVQbUw3aElw?=
 =?utf-8?B?V3R1dkZ0ajJwd2hIeG9uSTNuQ2p3YnE1dGs2UlNKek1nZ1ZpOW8vRkdxZWpV?=
 =?utf-8?B?OXh2Q0RldWV0Uk1JNEVLbDhNSURmbjlMMmNyUFdlbFpyamE2TmkrVDB2bFZm?=
 =?utf-8?B?UGZtc0RyaEdLcXdUd0lmaHYwZ3VlMXVMampISlhSaGQ4TnB6dmJXQWExWGNp?=
 =?utf-8?B?alZ0WFJnZzVnQ0F5Um1Uc1l5RmRqMDhoSG04ckxUcTZ0QzR1T1pSM3dBY3Nk?=
 =?utf-8?B?V2hadkVQWjFPZnZnVldDdEpsb0NyVUVMUjk5bkYxeEtmSW53N244WjEwZDJ6?=
 =?utf-8?B?QWdLZEdNMStQVkV5Myt4c2p1Mmh0VHVwclNTUk1kcm05UFFrNXovTGlVbVFZ?=
 =?utf-8?B?enBwM3ZIeEtvanJNV0dsbi91K21LcTZ1alBTZ21uNmNOb0tabW9Mdm9SK3N6?=
 =?utf-8?B?Kzk3Q1k5S1JYRVBQT0k0Z1JiMUFzaUFBbjZUd0dJS3NVRGJFSHlFUUMyTWda?=
 =?utf-8?B?ZWFib2xhcG44MDVYL0hwb0VDbm5zRVVnNEtDWFplS2F4YVV2VEZNbVV3T3RV?=
 =?utf-8?B?cm9oUHNSd25JNWVIeEVCZ1JVVHNRQVJYVzVRN3NjZmVIV2pJb0RiMWs1ZVk5?=
 =?utf-8?B?cmk1L1lMbG5HbU9ySnNLem1KcnB1UlNnOWo4aHZTKzI4S3VrYmNMcFJGVnV6?=
 =?utf-8?B?VnRNaVc2azhnaFlyZXNkQlo1Z0JrMERNMGc3dUVrdzJhUTRJN1IzcmlNZlJv?=
 =?utf-8?B?UFBacnBjZ2FQMXZHbkZUTXI5VHgyNFc1SVgydWVxRWUzK2xYQ1NtUmsvaGxs?=
 =?utf-8?B?b2lpSHlURTR0UWswUlN5T3VHQmhhYlExTXVpV1RISnJzdFI0VkROVnZQL0Er?=
 =?utf-8?B?ZWRJTUwzSmlzS2xDV3BlcmJ6WEdNWEFvdG9PbWFBUllqSUw5alc1d3NQV1R5?=
 =?utf-8?B?OXdTVjU3eDlEZFZwck5pUklOc1ZvN0t4cmtZdDVzRDYxVGxPcXZFZVpLYzd4?=
 =?utf-8?B?SW9yVUJuVjA4L2RqYTR0SUtVRHFYYitUNWIyQlgvMzJ3UUJyVE5iS1ZwTXVX?=
 =?utf-8?B?T01ZVTJLTEdnb0pYOEtJcEVtUlo1bFZWMFozZm5aVlhlZk5TNmZxdUdTV1k1?=
 =?utf-8?B?T3dOcWRoMW14QkhMSDVIZTN3aXFYK0FzWUp1K1J1TzVhMnp1Szd6RCsvcXND?=
 =?utf-8?B?dmpldkRFWjdkb0hEb2FOckRTT09ic2t5KzdwWTF1ZEU3bzJsZG9BMWNlc1E2?=
 =?utf-8?Q?yh2evCbAqg/83hzBUrhbq1g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91197D0306AFA048AB13F2D124887B82@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OVPBQZxK3QnURQbj+kJ89xN8Mr3ZZ8khpXgFiHvplZSr93eMKN7DSrNs34uZTDdgUC4b6+dhuSbfgHSLVdqP/tXA41CqmLCYRWQfV61RVEw5vWBwU5HcGJnJr4wdv9/+IyXOahqVuL3bZMvtkdG6Zb2Jh6JzeUjKoprAIzRVyGyA3ymthNznypq/sDfz2o41mgXBdoC06vzGGcow5308qH01Gno+v6eRCQsbZLCOqhncpJWWvvbxTE4Bp1BoojbKNoLu+jRKZs9m471tnVHwGbwk6NuQeRf1QMDFW3Y6HqisVApbgqVRlqmyXzxO+fGnhb7qIHcWfEL9ZAgJxAYGApzQax5vuM271GXRdnV0fEX7TA1FlMFbAiOp//XhlKCtIbJwisJlNUWb/bem2AgqM2QOmXk/ZbsWEaNxedGhrv/lIxaDrG+L+hc4SVD5okB4SL+1fv69v3YHB569sfPqhpUtwKESB195es1vVURcD1eJpZCkOxexWtuAwmiZuOJ8qRyoACqqV2k0H+zp7BB7p9RdzGL/i5gckd9uWaFMiWUeMqG7jPqsjaFwTxfbcOzl61wjJRDUjBQxINCf/nAk6CU5LWD7QRGmzP0d8FA8EJrZWEeK+I/pUu7RgWkFgOj4p/iRYa4UxX9SIZ4OdFCf3Q==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b60464c6-aef8-46f2-9419-08dcc8f7b2fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 13:28:56.4741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qQsebk2FEv8JOgdJwpWY5ZlhrnvJKPu7DknXFyZDQ5vchdOH4fG02UznQr4aatJLBJ/SPMqQ20rAvWfJh7V7Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR19MB8273
X-BESS-ID: 1725024539-111280-12706-4808-1
X-BESS-VER: 2019.1_20240828.2353
X-BESS-Apparent-Source-IP: 104.47.55.171
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVqYWJgZAVgZQMM3IyNjc0NzQwC
	IpJcnYIC3F0jg1xdQ0KcXM1CDNODFZqTYWAPeo0ANBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.258696 [from 
	cloudscan21-123.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gOC8zMC8yNCAxNToxMiwgSmVucyBBeGJvZSB3cm90ZToNCj4gT24gOC8yOS8yNCA0OjMyIFBN
LCBCZXJuZCBTY2h1YmVydCB3cm90ZToNCj4+IFdhbnRlZCB0byBzZW5kIG91dCBhIG5ldyBzZXJp
ZXMgdG9kYXksIA0KPj4NCj4+IGh0dHBzOi8vZ2l0aHViLmNvbS9ic2Jlcm5kL2xpbnV4L3RyZWUv
ZnVzZS11cmluZy1mb3ItNi4xMC1yZmMzLXdpdGhvdXQtbW1hcA0KPj4NCj4+IGJ1dCB0aGVuIGp1
c3Qgbm90aWNlZCBhIHRlYXIgZG93biBpc3N1ZS4NCj4+DQo+PiAgMTUyNS45MDU1MDRdIEtBU0FO
OiBudWxsLXB0ci1kZXJlZiBpbiByYW5nZSBbMHgwMDAwMDAwMDAwMDAwMWEwLTB4MDAwMDAwMDAw
MDAwMDFhN10NCj4+IFsgMTUyNS45MTA0MzFdIENQVTogMTUgUElEOiAxODMgQ29tbToga3dvcmtl
ci8xNToxIFRhaW50ZWQ6IEcgICAgICAgICAgIE8gICAgICAgNi4xMC4wKyAjNDgNCj4+IFsgMTUy
NS45MTY0NDldIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKFEzNSArIElDSDksIDIw
MDkpLCBCSU9TIDEuMTYuMy1kZWJpYW4tMS4xNi4zLTIgMDQvMDEvMjAxNA0KPj4gWyAxNTI1Ljky
MjQ3MF0gV29ya3F1ZXVlOiBldmVudHMgaW9fZmFsbGJhY2tfcmVxX2Z1bmMNCj4+IFsgMTUyNS45
MjU4NDBdIFJJUDogMDAxMDpfX2xvY2tfYWNxdWlyZSsweDc0LzB4N2I4MA0KPj4gWyAxNTI1Ljky
OTAxMF0gQ29kZTogODkgYmMgMjQgODAgMDAgMDAgMDAgMGYgODUgMWMgNWYgMDAgMDAgODMgM2Qg
NmUgODAgYjAgMDIgMDAgMGYgODQgMWQgMTIgMDAgMDAgODMgM2QgNjUgYzcgNjcgMDIgMDAgNzQg
MjcgNDggODkgZjggNDggYzEgZTggMDMgPDQyPiA4MCAzYyAzMCAwMCA3NCAwZCBlOCA1MCA0NCA0
MiAwMCA0OCA4YiBiYyAyNCA4MCAwMCAwMCAwMCA0OCBjNw0KPj4gWyAxNTI1Ljk0MjIxMV0gUlNQ
OiAwMDE4OmZmZmY4ODgxMGIyYWY0OTAgRUZMQUdTOiAwMDAxMDAwMg0KPj4gWyAxNTI1Ljk0NTY3
Ml0gUkFYOiAwMDAwMDAwMDAwMDAwMDM0IFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAwMDAw
MDAwMDAwMDAwMDENCj4+IFsgMTUyNS45NTA0MjFdIFJEWDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6
IDAwMDAwMDAwMDAwMDAwMDAgUkRJOiAwMDAwMDAwMDAwMDAwMWEwDQo+PiBbIDE1MjUuOTU1MjAw
XSBSQlA6IDAwMDAwMDAwMDAwMDAwMDAgUjA4OiAwMDAwMDAwMDAwMDAwMDAxIFIwOTogMDAwMDAw
MDAwMDAwMDAwMA0KPj4gWyAxNTI1Ljk1OTk3OV0gUjEwOiBkZmZmZmMwMDAwMDAwMDAwIFIxMTog
ZmZmZmZiZmZmMDdiMWNiZSBSMTI6IDAwMDAwMDAwMDAwMDAwMDANCj4+IFsgMTUyNS45NjQyNTJd
IFIxMzogMDAwMDAwMDAwMDAwMDAwMSBSMTQ6IGRmZmZmYzAwMDAwMDAwMDAgUjE1OiAwMDAwMDAw
MDAwMDAwMDAxDQo+PiBbIDE1MjUuOTY4MjI1XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkg
R1M6ZmZmZjg4ODc1YjIwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQo+PiBbIDE1
MjUuOTczOTMyXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUw
MDMzDQo+PiBbIDE1MjUuOTc2Njk0XSBDUjI6IDAwMDA1NTU1YjZhMzgxZjAgQ1IzOiAwMDAwMDAw
MTJmNWYxMDAwIENSNDogMDAwMDAwMDAwMDAwMDZmMA0KPj4gWyAxNTI1Ljk4MDAzMF0gQ2FsbCBU
cmFjZToNCj4+IFsgMTUyNS45ODEzNzFdICA8VEFTSz4NCj4+IFsgMTUyNS45ODI1NjddICA/IF9f
ZGllX2JvZHkrMHg2Ni8weGIwDQo+PiBbIDE1MjUuOTg0Mzc2XSAgPyBkaWVfYWRkcisweGMxLzB4
MTAwDQo+PiBbIDE1MjUuOTg2MTExXSAgPyBleGNfZ2VuZXJhbF9wcm90ZWN0aW9uKzB4MWM2LzB4
MzMwDQo+PiBbIDE1MjUuOTg4NDAxXSAgPyBhc21fZXhjX2dlbmVyYWxfcHJvdGVjdGlvbisweDIy
LzB4MzANCj4+IFsgMTUyNS45OTA4NjRdICA/IF9fbG9ja19hY3F1aXJlKzB4NzQvMHg3YjgwDQo+
PiBbIDE1MjUuOTkyOTAxXSAgPyBtYXJrX2xvY2srMHg5Zi8weDM2MA0KPj4gWyAxNTI1Ljk5NDYz
NV0gID8gX19sb2NrX2FjcXVpcmUrMHgxNDIwLzB4N2I4MA0KPj4gWyAxNTI1Ljk5NjYyOV0gID8g
YXR0YWNoX2VudGl0eV9sb2FkX2F2ZysweDQ3ZC8weDU1MA0KPj4gWyAxNTI1Ljk5ODc2NV0gID8g
aGxvY2tfY29uZmxpY3QrMHg1YS8weDFmMA0KPj4gWyAxNTI2LjAwMDUxNV0gID8gX19iZnMrMHgy
ZGMvMHg1YTANCj4+IFsgMTUyNi4wMDE5OTNdICBsb2NrX2FjcXVpcmUrMHgxZmIvMHgzZDANCj4+
IFsgMTUyNi4wMDQ3MjddICA/IGd1cF9mYXN0X2ZhbGxiYWNrKzB4MTNmLzB4MWQ4MA0KPj4gWyAx
NTI2LjAwNjU4Nl0gID8gZ3VwX2Zhc3RfZmFsbGJhY2srMHgxM2YvMHgxZDgwDQo+PiBbIDE1MjYu
MDA4NDEyXSAgZ3VwX2Zhc3RfZmFsbGJhY2srMHgxNTgvMHgxZDgwDQo+PiBbIDE1MjYuMDEwMTcw
XSAgPyBndXBfZmFzdF9mYWxsYmFjaysweDEzZi8weDFkODANCj4+IFsgMTUyNi4wMTE5OTldICA/
IF9fbG9ja19hY3F1aXJlKzB4MmIwNy8weDdiODANCj4+IFsgMTUyNi4wMTM3OTNdICBfX2lvdl9p
dGVyX2dldF9wYWdlc19hbGxvYysweDM2ZS8weDk4MA0KPj4gWyAxNTI2LjAxNTg3Nl0gID8gZG9f
cmF3X3NwaW5fdW5sb2NrKzB4NWEvMHg4YTANCj4+IFsgMTUyNi4wMTc3MzRdICBpb3ZfaXRlcl9n
ZXRfcGFnZXMyKzB4NTYvMHg3MA0KPj4gWyAxNTI2LjAxOTQ5MV0gIGZ1c2VfY29weV9maWxsKzB4
NDhlLzB4OTgwIFtmdXNlXQ0KPj4gWyAxNTI2LjAyMTQwMF0gIGZ1c2VfY29weV9hcmdzKzB4MTc0
LzB4NmEwIFtmdXNlXQ0KPj4gWyAxNTI2LjAyMzE5OV0gIGZ1c2VfdXJpbmdfcHJlcGFyZV9zZW5k
KzB4MzE5LzB4NmMwIFtmdXNlXQ0KPj4gWyAxNTI2LjAyNTE3OF0gIGZ1c2VfdXJpbmdfc2VuZF9y
ZXFfaW5fdGFzaysweDQyLzB4MTAwIFtmdXNlXQ0KPj4gWyAxNTI2LjAyNzE2M10gIGlvX2ZhbGxi
YWNrX3JlcV9mdW5jKzB4YjQvMHgxNzANCj4+IFsgMTUyNi4wMjg3MzddICA/IHByb2Nlc3Nfc2No
ZWR1bGVkX3dvcmtzKzB4NzViLzB4MTE2MA0KPj4gWyAxNTI2LjAzMDQ0NV0gIHByb2Nlc3Nfc2No
ZWR1bGVkX3dvcmtzKzB4ODVjLzB4MTE2MA0KPj4gWyAxNTI2LjAzMjA3M10gIHdvcmtlcl90aHJl
YWQrMHg4YmEvMHhjZTANCj4+IFsgMTUyNi4wMzMzODhdICBrdGhyZWFkKzB4MjNlLzB4MmIwDQo+
PiBbIDE1MjYuMDM1NDA0XSAgPyBwcl9jb250X3dvcmtfZmx1c2grMHgyOTAvMHgyOTANCj4+IFsg
MTUyNi4wMzY5NThdICA/IGt0aHJlYWRfYmxrY2crMHhhMC8weGEwDQo+PiBbIDE1MjYuMDM4MzIx
XSAgcmV0X2Zyb21fZm9yaysweDMwLzB4NjANCj4+IFsgMTUyNi4wMzk2MDBdICA/IGt0aHJlYWRf
YmxrY2crMHhhMC8weGEwDQo+PiBbIDE1MjYuMDQwOTQyXSAgcmV0X2Zyb21fZm9ya19hc20rMHgx
MS8weDIwDQo+PiBbIDE1MjYuMDQyMzUzXSAgPC9UQVNLPg0KPj4NCj4+DQo+PiBXZSBwcm9iYWJs
eSBuZWVkIHRvIGNhbGwgaW92X2l0ZXJfZ2V0X3BhZ2VzMigpIGltbWVkaWF0ZWx5DQo+PiBvbiBz
dWJtaXR0aW5nIHRoZSBidWZmZXIgZnJvbSBmdXNlIHNlcnZlciBhbmQgbm90IG9ubHkgd2hlbiBu
ZWVkZWQuDQo+PiBJIGhhZCBwbGFubmVkIHRvIGRvIHRoYXQgYXMgb3B0aW1pemF0aW9uIGxhdGVy
IG9uLCBJIHRoaW5rDQo+PiBpdCBpcyBhbHNvIG5lZWRlZCB0byBhdm9pZCBpb191cmluZ19jbWRf
Y29tcGxldGVfaW5fdGFzaygpLg0KPiANCj4gSSB0aGluayB5b3UgZG8sIGJ1dCBpdCdzIG5vdCBy
ZWFsbHkgd2hhdCdzIHdyb25nIGhlcmUgLSBmYWxsYmFjayB3b3JrIGlzDQo+IGJlaW5nIGludm9r
ZWQgYXMgdGhlIHJpbmcgaXMgYmVpbmcgdG9ybiBkb3duLCBlaXRoZXIgZGlyZWN0bHkgb3IgYmVj
YXVzZQ0KPiB0aGUgdGFzayBpcyBleGl0aW5nLiBZb3VyIHRhc2tfd29yayBzaG91bGQgY2hlY2sg
aWYgdGhpcyBpcyB0aGUgY2FzZSwNCj4gYW5kIGp1c3QgZG8gLUVDQU5DRUxFRCBmb3IgdGhpcyBj
YXNlIHJhdGhlciB0aGFuIGF0dGVtcHQgdG8gZXhlY3V0ZSB0aGUNCj4gd29yay4gTW9zdCB0YXNr
X3dvcmsgZG9lc24ndCBkbyBtdWNoIG91dHNpZGUgb2YgcG9zdCBhIGNvbXBsZXRpb24sIGJ1dA0K
PiB5b3VycyBzZWVtcyBjb21wbGV4IGluIHRoYXQgYXR0ZW1wdHMgdG8gbWFwIHBhZ2VzIGFzIHdl
bGwsIGZvciBleGFtcGxlLg0KPiBJbiBhbnkgY2FzZSwgcmVnYXJkbGVzcyBvZiB3aGV0aGVyIHlv
dSBtb3ZlIHRoZSBndXAgdG8gdGhlIGFjdHVhbCBpc3N1ZQ0KPiBzaWRlIG9mIHRoaW5ncyAod2hp
Y2ggSSB0aGluayB5b3Ugc2hvdWxkKSwgdGhlbiB5b3UnZCB3YW50IHNvbWV0aGluZw0KPiBhbGE6
DQo+IA0KPiBpZiAocmVxLT50YXNrICE9IGN1cnJlbnQpDQo+IAlkb24ndCBpc3N1ZSwgLUVDQU5D
RUxFRA0KPiANCj4gaW4geW91ciB0YXNrX3dvcmsuDQoNClRoYW5rcyBhIGxvdCBmb3IgeW91ciBo
ZWxwIEplbnMhIEknbSBhIGJpdCBjb25mdXNlZCwgZG9lc24ndCB0aGlzIGJlbG9uZyANCmludG8g
X19pb191cmluZ19jbWRfZG9faW5fdGFzayB0aGVuPyBCZWNhdXNlIG15IHRhc2tfd29ya19jYiBm
dW5jdGlvbiANCihwYXNzZWQgdG8gaW9fdXJpbmdfY21kX2NvbXBsZXRlX2luX3Rhc2spIGRvZXNu
J3QgZXZlbiBoYXZlIHRoZSByZXF1ZXN0Lg0KDQpJJ20gZ29pbmcgdG8gdGVzdCB0aGlzIGluIGEg
Yml0DQoNCmRpZmYgLS1naXQgYS9pb191cmluZy91cmluZ19jbWQuYyBiL2lvX3VyaW5nL3VyaW5n
X2NtZC5jDQppbmRleCAyMWFjNWZiMmQ1ZjAuLmMwNmI5ZmNmZjQ4ZiAxMDA2NDQNCi0tLSBhL2lv
X3VyaW5nL3VyaW5nX2NtZC5jDQorKysgYi9pb191cmluZy91cmluZ19jbWQuYw0KQEAgLTEyMCw2
ICsxMjAsMTEgQEAgc3RhdGljIHZvaWQgaW9fdXJpbmdfY21kX3dvcmsoc3RydWN0IGlvX2tpb2Ni
ICpyZXEsIHN0cnVjdCBpb190d19zdGF0ZSAqdHMpDQogew0KICAgICAgICBzdHJ1Y3QgaW9fdXJp
bmdfY21kICppb3VjbWQgPSBpb19raW9jYl90b19jbWQocmVxLCBzdHJ1Y3QgaW9fdXJpbmdfY21k
KTsNCiANCisgICAgICAgaWYgKHJlcS0+dGFzayAhPSBjdXJyZW50KSB7DQorICAgICAgICAgICAg
ICAgLyogZG9uJ3QgaXNzdWUsIC1FQ0FOQ0VMRUQgKi8NCisgICAgICAgICAgICAgICByZXR1cm47
DQorICAgICAgIH0NCisNCiAgICAgICAgLyogdGFza193b3JrIGV4ZWN1dG9yIGNoZWNrcyB0aGUg
ZGVmZmVyZWQgbGlzdCBjb21wbGV0aW9uICovDQogICAgICAgIGlvdWNtZC0+dGFza193b3JrX2Ni
KGlvdWNtZCwgSU9fVVJJTkdfRl9DT01QTEVURV9ERUZFUik7DQogfQ0KDQoNCg0KPiANCj4+IFRo
ZSBwYXJ0IEkgZG9uJ3QgbGlrZSBoZXJlIGlzIHRoYXQgd2l0aCBtbWFwIHdlIGhhZCBhIGNvbXBs
ZXgNCj4+IGluaXRpYWxpemF0aW9uIC0gYnV0IHRoZW4gZWl0aGVyIGl0IHdvcmtlZCBvciBkaWQg
bm90LiBObyBleGNlcHRpb25zDQo+PiBhdCBJTyB0aW1lLiBBbmQgcnVuIHRpbWUgd2FzIGp1c3Qg
YSBjb3B5IGludG8gdGhlIGJ1ZmZlci4gDQo+PiBXaXRob3V0IG1tYXAgaW5pdGlhbGl6YXRpb24g
aXMgbXVjaCBzaW1wbGVyLCBidXQgbm93IGNvbXBsZXhpdHkgc2hpZnRzDQo+PiB0byBJTyB0aW1l
Lg0KPiANCj4gSSdsbCB0YWtlIGEgbG9vayBhdCB5b3VyIGNvZGUuIEJ1dCBJJ2Qgc2F5IGp1c3Qg
Zml4IHRoZSBtaXNzaW5nIGNoZWNrDQo+IGFib3ZlIGFuZCBzZW5kIG91dCB3aGF0IHlvdSBoYXZl
LCBpdCdzIG11Y2ggZWFzaWVyIHRvIGl0ZXJhdGUgb24gdGhlDQo+IGxpc3QgcmF0aGVyIHRoYW4g
cG9raW5nIGF0IHBhdGNoZXMgaW4gc29tZSBnaXQgYnJhbmNoIHNvbWV3aGVyZS4NCj4gDQoNCkkn
bSBhbG1vc3QgdGhyb3VnaCB1cGRhdGluZyBpdCwgd2lsbCBzZW5kIHNvbWV0aGluZyBvdXQgZGVm
aW5pdGVseSB0b2RheS4NCkkgd2lsbCBqdXN0IGtlZXAgdGhlIGxhc3QgcGF0Y2ggdGhhdCBwaW5z
IHVzZXIgYnVmZmVyIHBhZ2VzIG9uIHRvcCBvZiB0aGUgc2VyaWVzIA0KLSB3aWxsIGF2b2lkIGFs
bCB0aGUgcmViYXNpbmcuDQoNCg0KVGhhbmtzLA0KQmVybmQNCg==

