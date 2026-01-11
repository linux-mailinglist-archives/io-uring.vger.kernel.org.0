Return-Path: <io-uring+bounces-11577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 82CFCD0F64B
	for <lists+io-uring@lfdr.de>; Sun, 11 Jan 2026 17:04:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A5CC9300647C
	for <lists+io-uring@lfdr.de>; Sun, 11 Jan 2026 16:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E26333CEAA;
	Sun, 11 Jan 2026 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="MR33ue/n"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D6122AE65;
	Sun, 11 Jan 2026 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768147453; cv=fail; b=GhKzFjn3rP+vboFqxWKUIWhK+pvpenyw5ZtEd4yPuF0iOm2eUeT2BFdAG5+qU8qnoJ1/TXzfwZrnSmwbIjc7r2wE+wpvJtkU+khdPlzQ8/yKCenF4HCVsw5y+flXusAvVtvieCaoc3f3rI8gQsMaPJsdSd+nCuSZsRuKALODQ3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768147453; c=relaxed/simple;
	bh=M/fJuaQGLVfEJIG/33+RMXXT8nvd7/5MRnqcjIAhdGs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JMbmSC/pnxZY0Au+eWYHnuoPXk+xJCBRHABdoJLm5EdFlajoO//eOVdfB2WHmWmyoKNS39oOmOWzGB6h8Gq+LWO+gYh3/hMX9Tzt6gg/MjHUY2rZ7QJLoa7zmGOfFmlGL+NeYcvS3SFAa8l85+gfu/dxvUCNzJ38p9TXD2PnIxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=MR33ue/n; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022096.outbound.protection.outlook.com [40.107.209.96]) by mx-outbound46-170.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Sun, 11 Jan 2026 16:04:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RqG5ZXJ0XkjLwqq73tIb27mZ33Zf5GBmQisfb7Ohjdl1hkZUBcxDj1bu6OBgrNKLe0QEJ/mozddBB9tGkjQtbigtsbCfOLK6EECUgjlkn2Cw8Tjbd8N1d7i+tjVZnmT976IjUbC3AXvYFjCpnPQuqP9vCgN3ydqkbkzivXB1kGgLEVIMw8IrgM2EdXOEoLJtcs0hz9FS1Gjm/IfGfS/ivrJzMxm4WNMurI3olyjNUTfvJ7XRphngLliA6tRX5Q+ptS2y2pecQzBvScoR32QMBvgnNeMt7InM3de+rub8fpKj0ITNLl5v8LOlMhfvT/VxX+1MAhXm7tGvcsTzYtnL4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/fJuaQGLVfEJIG/33+RMXXT8nvd7/5MRnqcjIAhdGs=;
 b=I0WYhk4VuMAiBvzIIlbAd8YxyHQpOgGq2cjUWZinJRd61DEOO7eCuFLinVu7WxsP80kWLxS8nFd90cHkK5t1I0R1ADV1p4UoOnJ+NTzQukTwJVKj2lRDSElWbgiLx4rtxPCW5gF7EYds/xTkGfB0PVO+0712KoGci9vQ8YWwtetRTz+UY3x2983EgaLnU5Lt/bPVEi2QdrC27RbLyPqq6HCOjzXHvIcgNk8uCEqR3grPl0XtG8ekS+n0OHTC+FwLCGFmGVNNyF671h22MAKimrVnBeHY3PE/DDZ4CTYJ1DFDkrizdxdns+mJ0Zi9XGa3peDpzjoSmcD1E5Ccwx8lHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/fJuaQGLVfEJIG/33+RMXXT8nvd7/5MRnqcjIAhdGs=;
 b=MR33ue/nXg+l6mIi8ePf6x2IUVcAAGzUBvZmfp5gwu+r1TWOev2QU4eckl6sy6ErF9h2j7SkrkkNHKpF6ApQTA3e9Mqb4WtpJEtH0BNR2e3wFMAlENuGJJOESSeHp0bKtru8+BdTJLrs85MH0cJgXCEEJfPpAgev9mbDmrpgn38=
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by IA0PR19MB7629.namprd19.prod.outlook.com (2603:10b6:208:3df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Sun, 11 Jan
 2026 16:03:57 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704%6]) with mapi id 15.20.9499.005; Sun, 11 Jan 2026
 16:03:57 +0000
From: Bernd Schubert <bschubert@ddn.com>
To: Joanne Koong <joannelkoong@gmail.com>, "miklos@szeredi.hu"
	<miklos@szeredi.hu>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "asml.silence@gmail.com" <asml.silence@gmail.com>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"csander@purestorage.com" <csander@purestorage.com>,
	"xiaobing.li@samsung.com" <xiaobing.li@samsung.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 14/25] fuse: refactor io-uring header copying to ring
Thread-Topic: [PATCH v3 14/25] fuse: refactor io-uring header copying to ring
Thread-Index: AQHcc6Q8Iu61PuOer0+HH+UUkG4w6LVNQH4A
Date: Sun, 11 Jan 2026 16:03:57 +0000
Message-ID: <a27b24fe-659e-4aa1-830c-7096a3c293b8@ddn.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-15-joannelkoong@gmail.com>
In-Reply-To: <20251223003522.3055912-15-joannelkoong@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR19MB3864:EE_|IA0PR19MB7629:EE_
x-ms-office365-filtering-correlation-id: b808b1ec-f6c2-4f26-21e0-08de512b06cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|19092799006|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YmhxUHc2bmc3RlhFSGc2Rk9HMlFSNEJ1cUQ2Q2FyaEZTeVY4elN0SGNaTXhm?=
 =?utf-8?B?SytqVjNqdWc4enRKNkExb3hGTzIzb0ZGTmY1TVF3c25kM0N1Vkw0UTZSNWl2?=
 =?utf-8?B?MzcxQnN2TGIrSENFK01hVTFNWGRyUElibkNhUE05N3VsTm5yME5NMVc2M1JQ?=
 =?utf-8?B?Y3hKUEx3TitJYXdUMkIyVTYyMTFRUGVlWDNwTnNuV0ZhdjJvZlFHTzF3ZE4x?=
 =?utf-8?B?QXRyVnhxbTZjOURQdk9QUjVrMDVxaXNxa28zNFhxR0ZrMUgzM1J2NlBJaXVR?=
 =?utf-8?B?RUFaQXpZek1Lc083cnRvSmdQNTZSSVRLZyttazhyTEdWMkVlQzdUNE5uL0NH?=
 =?utf-8?B?NFdETVdtMjB2ekRNemtRYmVMQkVPOG1lbGl0VUQ0S2drWjMvVDNHOUpLdjRB?=
 =?utf-8?B?TGZGQ204djRGOFJNQ01WaFp0eXNoZTdsTmI4MTdFZUNBeDdOV1FhOVhIQXZi?=
 =?utf-8?B?NkpnZCtEbHBlQnh4eEN2TXRkUkh1eERUY2N4T0oyV0FJQy94Mnd3NDFaSExI?=
 =?utf-8?B?alFUSGRFRDI5d1BWemlqUkNiREoyMWhWM1dieE40aXVhTmpsQ1B0VWxZbG5I?=
 =?utf-8?B?Vm9jWHNVVDRzY3FMLzRha3J4amZDWUU4a0Y1bERNNGJRemh5bVhzclJrd3V1?=
 =?utf-8?B?VEFITHhNNU1ZYzJMdEFFaURvRG9wemdRVGJTV0hCR2ZmRVZkeTcwaEF4aWVQ?=
 =?utf-8?B?dUhUWWMyeGEzbVpaTWlSQkRxUW5TUElEUzdpaHIrVVhMY3d6OU9VOTRXOWJX?=
 =?utf-8?B?VWlyTkUvNGlubFFaYXZSL2FkWXNacm9JY2dCZmoxYWxjeE42elpsemhsN1Z2?=
 =?utf-8?B?N1pNL2N3Y09yWDk5cUlGVzl4K1F1YzhKRk1qUnBOamRCUFFIanhIMzZXdnVU?=
 =?utf-8?B?SzU3djIremsxSkZQK0FJNlpiN0lWYUt1NytEUVFHRXkyempJRlVVU015OHJZ?=
 =?utf-8?B?c1J2Z0c1cWJXRXo2VVJwN0lPWDZ2MjNPbm9vRmFaZlQ3TlFoeFVVK3dwRi9t?=
 =?utf-8?B?eEhFR1UybVNnVGV0YVBjV3dValB1empOZE4wNlZ4aElVbE5MVTI1cG9RVTJx?=
 =?utf-8?B?TUk1eEJaVFNoUm1oVDZCZ0NJdkJvWFVLdytiTEpiVFB4ZktzMjBxTHhVUGd4?=
 =?utf-8?B?L0Z0b3o3ejkyQWZ2YmV3L1dIV1Fpc0ZYS1hXYW51S2phUnV6c0N3TzZqZGc2?=
 =?utf-8?B?NUloUlBhZkxHOFltdlBnRXFOTmVyY3RJZk1iL0JUc0kwQkEwekZZSzMvNWl6?=
 =?utf-8?B?THIwZkJDOFJqUlNna0FVQWZjOVcya2lrUU1zR3ZrK2d4R3BLdjh6ak1aWDBv?=
 =?utf-8?B?cXVxUEJrN0kzYWYxT2lta0k0ajEvdjM3YWtsUUYzKzJuMnFsQUpMR3RzeWxs?=
 =?utf-8?B?dTU3Zlg4RUVEWE9wRHdyREd2WDNiWmVkYXdiT29ZejlOSDJ3elZrTXZ1Y1ov?=
 =?utf-8?B?dzF1eElhNHlXVzNkV0JqZlNGbFI2N2wrV3IvSldac3Q5TTAwZnBIOFlIOVVx?=
 =?utf-8?B?aGFlcWE3TXhTTEIxT2daN3lFQm1hZnFUMHY1cFdtV1pXd1VwZi80NW4xTmhO?=
 =?utf-8?B?aDVBTThYTDJYMllNK2llZ0RxaGcxNzlEUmMvTVFRZXJ0b05Bd3MxZEJ2VGla?=
 =?utf-8?B?RkVSQzhxYXlCcXRwK2dhbGZxRllIMUV2dzhUOEZHclN0SmZyZ3BFUXQ1VVdG?=
 =?utf-8?B?eWdBdThKS0xLbXJRLzQ0anRVTGpxeUNERDRMbHl4a2k0em9hdXNWaWRDZWJ0?=
 =?utf-8?B?UEZsaHN3cWtldHlQWFR5UU1qUWNOZnM1WjBqaGlBblNnNXUxaWFoYVRVV2wx?=
 =?utf-8?B?SERNdVlRTnVqN2NmanBDczNTdkN2Q0trMG1WanJMajdtYmw2ZitPaVVyR0Vy?=
 =?utf-8?B?c05MOWtoMWZTQVArdmh1V3RTa1BQaWNMNFJFeUZXbGY1Vm5KVzFHdER6NmtM?=
 =?utf-8?B?QkVkSzcrenBJR25RQncyNFRBUDN1bUJJQjY2NDU4RGNFelV5VUdtdjlwZ2pN?=
 =?utf-8?B?anZ6YzZmWUZ4YTVQWEhwbHErUm5LSEZWUG9RclR2WFlNNTdBQVR2RSs2ZE5Q?=
 =?utf-8?Q?DQAVEl?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(19092799006)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cUlMMWxZeEsvWjhtNDBYeGJmaUN4cjFCOFh6YjRmVHpvN2h1dXR4TS9uWkVh?=
 =?utf-8?B?RW8vY0xwWXFHRVFJMkZTMFZKajhvQmxVd3ArL1dtbjVrbmx4SzYvUmxCQ0tq?=
 =?utf-8?B?RFJlS1hCNVUyczV1a1dkK1h5OGhoc1RscWp5WHRXdjR4UDVyK0xKYUtSRFdF?=
 =?utf-8?B?a0s4Y1lTQTJtdVlBenlBU3liZmRocHBlTk8vVFo2c3hDK1FXc1Nrb1p0M1dH?=
 =?utf-8?B?K2lyYzg1NlhIZzMzRHpFc0RRMzAyTVFrTWJaS1JjVS9OL1lKd2crK1RpeHQv?=
 =?utf-8?B?N0c4TkYxNDY0ZVpreEhtTy83NE82ekNJYWdEYTdqSGE0Y1NlS3k4N3A4dGNY?=
 =?utf-8?B?cEJ4VkNweVVNMkNTSTB5MkN1cGE4eFdPY1VCOTFjY00wbE1zeEZNYlpmRU5T?=
 =?utf-8?B?YmhlWjZjVUQyOEJLZWNua0gxSlBVUmxKdEIzS0xXa3dBN0JkWEFxS1Q0WHZx?=
 =?utf-8?B?SGdFT2MxMElSeU94MWR4aVI5N21PZVNLQVdObTlsYkJBQ2dUYVkrMys0cEZG?=
 =?utf-8?B?ZFJGbC9qZlUyK09lVCtibm1tYzU1dU5JWUtNUEVrcUsxb1hOY1N3eklDS0ta?=
 =?utf-8?B?M3pGQU4xekRFdS8zL2t6UW5GT1BmajVtV25TQkhkeWtxd01ia0NWelNRazZk?=
 =?utf-8?B?aDBmZGJTNVliUDlPRUtEZXBUY3JOSkxhOG1tTHM0RW9JeWNwaUkxOEl4ZWtC?=
 =?utf-8?B?eGU5TkdVdnVubWJXTlY4b0VMWVZOVHloTUQ5dDhlNWNVa0NiWEJ6alVBNjdX?=
 =?utf-8?B?M3ZGMkhLQnNiTThiVk9CVlE0dUtoOFNPZkI3L21HQTZoVU0yMlBEZmRmNG51?=
 =?utf-8?B?RFBPNm5oVktqcDQyRGtiNGFUQWZhV2JIb25obEg3czR0UFdXdVN6RE1VOUxR?=
 =?utf-8?B?aHVwSVlRYlFQOXRYekhDdUh2YVRhTWsybnluSlozTEtZT1hUVXd4MzZjSUJw?=
 =?utf-8?B?NGNmTU5VaWVFV3NqMHF5S2pkNE9aQUFRdFZORXh0c1J3NG5PbzlHT05OTjk0?=
 =?utf-8?B?WWNlOFh6aXFUZGc5M2FkUkE4WlV5QVVkU2VzWEZraVROYmhvM1BiWnFIYkJY?=
 =?utf-8?B?SDdwQ0pzdHE4TzlPblJEUSt0MWltSktsVEhZSHBXVitFUnFCdWptNXJtb3o5?=
 =?utf-8?B?QUx0ekVmb25hRW4zTFNLbUJLYWFkTUd6cEMwZEMwbTVXRWM5YmNKQWdRNkU1?=
 =?utf-8?B?ODBlbmtxVld2NG9ERDlpZ2hVQVZWRU9aWmtZaEVPK0Y3ZWZZTFU5NGVpVGpk?=
 =?utf-8?B?STJpdzFQK3BMQ3FkcG5JbUx3U1JOYjNUWW5UZzFnRG0wcTlxYjY2VzExeDZI?=
 =?utf-8?B?ZlBCWkxyR3FMVDZtRklEaFJMVzBsbU4vdHlFWHFqYlpGV2NFczRDRTBZejlL?=
 =?utf-8?B?WjJMSnFzK01IbGlycXFwZTExa1BVNHkzZ2lBU0lubEhVbDRKT1hzRk5MYktB?=
 =?utf-8?B?cTJtYW9sZW9iZ0l5RnArK29GY3VTMHlSRUROYWF0NE5lTGkwWjhVRHlKN21j?=
 =?utf-8?B?U2ZSanBUVDJ5dm9GSktDYW1MQjZNaldCMGphU1pkbktlb2NmZGlvbWJwZ3Bz?=
 =?utf-8?B?ZkFjaXdhQnNGaVFscWpTaXBnakFLYVZ4MHdtUVMvS0hKbzZJZmJlQmFFUjlB?=
 =?utf-8?B?V2U5TUwrSk05VWxQd2x5OFZVdW1lUGVIVnZSbDFHeVFYalFrdkV1KzBjZmFi?=
 =?utf-8?B?dzZGZGhhZW40bEdHOXR0R3pUQ05sdUZPYkRnNlVhY1VyWmUrL2ZIcFNaWHdl?=
 =?utf-8?B?em5ZTVFyVzYyb1FvcGZUdEpkdWRQbGNCZGliZWI2WUk1dmp5Ti9RVTBUa3V0?=
 =?utf-8?B?NmRWTmViRllUSkl1UC9JYURMVEdNN2syNFNpeU4xMUNaWTVrS2ZSY1pvOEtP?=
 =?utf-8?B?dUlHNnZxVmRBRWIyeGEyUmVQVlBEL3VjTWp0MThvOHA0cG1OWFFkUlNJaE5h?=
 =?utf-8?B?ZXZGUU5SYWRkRnIrOU1aYnY1N0RPUmovRGlLRWJlcFUzYytPVW81ZFdqaEpv?=
 =?utf-8?B?NkVZSnMvTjVsOXQvSDAyZ003NlN6aGJCTnIvSDNSdFhsNFdQVldRSnROUlM4?=
 =?utf-8?B?UzB2ZjVvdUF4Nlc1aWFKWlRobjM5ZUtadmRWcDBXc0QvM3kvRDRRVWpPOWtI?=
 =?utf-8?B?aXcyTzJ4TVdXaERuVFpURjNPMlNiMkk2OUFHRTFza3BLS0p0aEltcDZLL3RK?=
 =?utf-8?B?UGpzWDl0bGRIR0UwTng2dDYyZklQbTdFRlI0ZURYMEFIMFRNL1hZOHVTd2xi?=
 =?utf-8?B?R1ZhUHdzTHY0OGp4OW1PRWdPWjFuVUc4V0gvUWhRL2tyeUFpVDd2ZXZ6MWo1?=
 =?utf-8?B?UWk1V0hSbHM0T1FFYmNoajRLclRNaXF2elQ1YWd0dDBZY3BrVmV0SUZJM3Nv?=
 =?utf-8?Q?kYpV8yNFWBL9kS4MnpzgH3jfwDfGd9i99TNTA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3277FE743AFC014F821D2CDEE23B27F0@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kMhWzdnLtTIC5wojXUnslFXc1UwgJrBaxxBWgHvvAMxLsLGQAN8pV8IJTvORUMHrUwYmutr+yEQXkOoBfa23MXp4aVsSonYP92Qi6uEbK5W44RY0J9hDtrt2RTFG9uRtz6xzvYLq6UaiaLENdln0/vfyCZ7GvyRhsusdRKy6g0jgDIuecV277LAQ3Y8EBjihvo8NIZHXj8DKgQvmHiGwknLAikkwf4jXMr96WpZ4C9G/YdaMr9iXPCuCvli8dd3icnuKslLO/xU0uABNeS1o1BiwC2AloQ1hpegcwjr8/SsLs5GYvXX2H4UjFgHqzcgo+tbtIrJFFUyAw3zCuYBfRUTyYqRekSP0b7rqUmbWU/LGas3DXYW9XxTkWo0rbrmJZZbPtbqbCE4ZYB5SKFFu1CeB+1jTNg4uoKH3MuPw0p7f/z7hy0nT0wvOZUX3Pb26B0s5t8DwVYUaybTdU9WBQBCdUOZbmHtFnIkqfnDmvDqo5OQJbmtV8661CeW2tM5XiNUFkZ/Kkhbn6v6oM1gMHAQ8Ls/Z2J/XAfN6oe0Tbj/DaUsH/2fgCrdP3quO5h3jksXryVaLdN5S88j+kf0vton0TAw3rFe7Hxixbl+QX7Ez2d8+ohn/JgsPm09bGeTAtqQob+vwtHdCeHEibNESsg==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b808b1ec-f6c2-4f26-21e0-08de512b06cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2026 16:03:57.2514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ScGTwnRCcSs7m2H01h+zqQIVS5mB1kf1YEEqhwLGsVElYxIjsskh7v5oh1ITr+JAdlaPoEjJH1pTNjgocjHpLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR19MB7629
X-BESS-ID: 1768147439-111946-7665-8882-1
X-BESS-VER: 2019.1_20251217.1707
X-BESS-Apparent-Source-IP: 40.107.209.96
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsaGpuZAVgZQ0CLV3MjSxNDUyM
	QiNcnYyDgtxcwiMcXA0sA41dDEINVAqTYWAMlQsaJBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.270324 [from 
	cloudscan17-180.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

T24gMTIvMjMvMjUgMDE6MzUsIEpvYW5uZSBLb29uZyB3cm90ZToNCj4gTW92ZSBoZWFkZXIgY29w
eWluZyB0byByaW5nIGxvZ2ljIGludG8gYSBuZXcgY29weV9oZWFkZXJfdG9fcmluZygpDQo+IGZ1
bmN0aW9uLiBUaGlzIGNvbnNvbGlkYXRlcyBlcnJvciBoYW5kbGluZy4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IEpvYW5uZSBLb29uZyA8am9hbm5lbGtvb25nQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBm
cy9mdXNlL2Rldl91cmluZy5jIHwgMzkgKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvZnVzZS9kZXZfdXJpbmcuYyBiL2ZzL2Z1c2UvZGV2
X3VyaW5nLmMNCj4gaW5kZXggMWVmZWU0MzkxYWY1Li43OTYyYTk4NzYwMzEgMTAwNjQ0DQo+IC0t
LSBhL2ZzL2Z1c2UvZGV2X3VyaW5nLmMNCj4gKysrIGIvZnMvZnVzZS9kZXZfdXJpbmcuYw0KPiBA
QCAtNTc1LDYgKzU3NSwxOCBAQCBzdGF0aWMgaW50IGZ1c2VfdXJpbmdfb3V0X2hlYWRlcl9oYXNf
ZXJyKHN0cnVjdCBmdXNlX291dF9oZWFkZXIgKm9oLA0KPiAgCXJldHVybiBlcnI7DQo+ICB9DQo+
ICANCj4gK3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgaW50IGNvcHlfaGVhZGVyX3RvX3Jpbmcodm9p
ZCBfX3VzZXIgKnJpbmcsDQo+ICsJCQkJCSAgICAgICBjb25zdCB2b2lkICpoZWFkZXIsDQo+ICsJ
CQkJCSAgICAgICBzaXplX3QgaGVhZGVyX3NpemUpDQoNCk1pbm9yIG5pdDogVGhlIG9ubHkgcGFy
dCBJIGRvbid0IGxpa2UgdG9vIG11Y2ggaXMgdGhlIF9fYWx3YXlzX2lubGluZS4gSQ0KaGFkIGF0
IGxlYXN0IHR3byB0aW1lcyBhIGRlYnVnIGlzc3VlIHdoZXJlIEkgZGlkbid0IGdldCBtdWNoIG91
dCBvZiB0aGUNCnRyYWNlIGFuZCB0aGVuIHVzZWQgZm9yIGZ1c2Uua28NCg0KK2NjZmxhZ3MteSAr
PSAtZyAtTzFcDQorICAgICAgICAgICAgIC1mbm8taW5saW5lLWZ1bmN0aW9ucyBcDQorICAgICAg
ICAgICAgIC1mbm8tb21pdC1mcmFtZS1wb2ludGVyIFwNCisgICAgICAgICAgICAgLWZuby1vcHRp
bWl6ZS1zaWJsaW5nLWNhbGxzIFwNCisgICAgICAgICAgICAgLWZuby1zdHJpY3QtYWxpYXNpbmcg
XA0KKyAgICAgICAgICAgICAtZm5vLWRlbGV0ZS1udWxsLXBvaW50ZXItY2hlY2tzIFwNCisgICAg
ICAgICAgICAgLWZuby1jb21tb24gXA0KDQpBZnRlciB0aGF0IHRoZSB0cmFjZSBiZWNhbWUgdmVy
eSBjbGVhciB3aXRoaW4gNW1pbiwgYmVmb3JlIHRoYXQgSQ0KY291bGRuJ3QgZGVjb2RlIHRoZSB0
cmFjZS4NCg0KPiArew0KPiArCWlmIChjb3B5X3RvX3VzZXIocmluZywgaGVhZGVyLCBoZWFkZXJf
c2l6ZSkpIHsNCj4gKwkJcHJfaW5mb19yYXRlbGltaXRlZCgiQ29weWluZyBoZWFkZXIgdG8gcmlu
ZyBmYWlsZWQuXG4iKTsNCj4gKwkJcmV0dXJuIC1FRkFVTFQ7DQo+ICsJfQ0KPiArDQo+ICsJcmV0
dXJuIDA7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBpbnQgZnVzZV91cmluZ19jb3B5X2Zyb21fcmlu
ZyhzdHJ1Y3QgZnVzZV9yaW5nICpyaW5nLA0KPiAgCQkJCSAgICAgc3RydWN0IGZ1c2VfcmVxICpy
ZXEsDQo+ICAJCQkJICAgICBzdHJ1Y3QgZnVzZV9yaW5nX2VudCAqZW50KQ0KPiBAQCAtNjM3LDEz
ICs2NDksMTEgQEAgc3RhdGljIGludCBmdXNlX3VyaW5nX2FyZ3NfdG9fcmluZyhzdHJ1Y3QgZnVz
ZV9yaW5nICpyaW5nLCBzdHJ1Y3QgZnVzZV9yZXEgKnJlcSwNCj4gIAkJICogU29tZSBvcCBjb2Rl
IGhhdmUgdGhhdCBhcyB6ZXJvIHNpemUuDQo+ICAJCSAqLw0KPiAgCQlpZiAoYXJncy0+aW5fYXJn
c1swXS5zaXplID4gMCkgew0KPiAtCQkJZXJyID0gY29weV90b191c2VyKCZlbnQtPmhlYWRlcnMt
Pm9wX2luLCBpbl9hcmdzLT52YWx1ZSwNCj4gLQkJCQkJICAgaW5fYXJncy0+c2l6ZSk7DQo+IC0J
CQlpZiAoZXJyKSB7DQo+IC0JCQkJcHJfaW5mb19yYXRlbGltaXRlZCgNCj4gLQkJCQkJIkNvcHlp
bmcgdGhlIGhlYWRlciBmYWlsZWQuXG4iKTsNCj4gLQkJCQlyZXR1cm4gLUVGQVVMVDsNCj4gLQkJ
CX0NCj4gKwkJCWVyciA9IGNvcHlfaGVhZGVyX3RvX3JpbmcoJmVudC0+aGVhZGVycy0+b3BfaW4s
DQo+ICsJCQkJCQkgIGluX2FyZ3MtPnZhbHVlLA0KPiArCQkJCQkJICBpbl9hcmdzLT5zaXplKTsN
Cj4gKwkJCWlmIChlcnIpDQo+ICsJCQkJcmV0dXJuIGVycjsNCj4gIAkJfQ0KPiAgCQlpbl9hcmdz
Kys7DQo+ICAJCW51bV9hcmdzLS07DQo+IEBAIC02NTksOSArNjY5LDggQEAgc3RhdGljIGludCBm
dXNlX3VyaW5nX2FyZ3NfdG9fcmluZyhzdHJ1Y3QgZnVzZV9yaW5nICpyaW5nLCBzdHJ1Y3QgZnVz
ZV9yZXEgKnJlcSwNCj4gIAl9DQo+ICANCj4gIAllbnRfaW5fb3V0LnBheWxvYWRfc3ogPSBjcy5y
aW5nLmNvcGllZF9zejsNCj4gLQllcnIgPSBjb3B5X3RvX3VzZXIoJmVudC0+aGVhZGVycy0+cmlu
Z19lbnRfaW5fb3V0LCAmZW50X2luX291dCwNCj4gLQkJCSAgIHNpemVvZihlbnRfaW5fb3V0KSk7
DQo+IC0JcmV0dXJuIGVyciA/IC1FRkFVTFQgOiAwOw0KPiArCXJldHVybiBjb3B5X2hlYWRlcl90
b19yaW5nKCZlbnQtPmhlYWRlcnMtPnJpbmdfZW50X2luX291dCwgJmVudF9pbl9vdXQsDQo+ICsJ
CQkJICAgc2l6ZW9mKGVudF9pbl9vdXQpKTsNCj4gIH0NCj4gIA0KPiAgc3RhdGljIGludCBmdXNl
X3VyaW5nX2NvcHlfdG9fcmluZyhzdHJ1Y3QgZnVzZV9yaW5nX2VudCAqZW50LA0KPiBAQCAtNjkw
LDE0ICs2OTksOCBAQCBzdGF0aWMgaW50IGZ1c2VfdXJpbmdfY29weV90b19yaW5nKHN0cnVjdCBm
dXNlX3JpbmdfZW50ICplbnQsDQo+ICAJfQ0KPiAgDQo+ICAJLyogY29weSBmdXNlX2luX2hlYWRl
ciAqLw0KPiAtCWVyciA9IGNvcHlfdG9fdXNlcigmZW50LT5oZWFkZXJzLT5pbl9vdXQsICZyZXEt
PmluLmgsDQo+IC0JCQkgICBzaXplb2YocmVxLT5pbi5oKSk7DQo+IC0JaWYgKGVycikgew0KPiAt
CQllcnIgPSAtRUZBVUxUOw0KPiAtCQlyZXR1cm4gZXJyOw0KPiAtCX0NCj4gLQ0KPiAtCXJldHVy
biAwOw0KPiArCXJldHVybiBjb3B5X2hlYWRlcl90b19yaW5nKCZlbnQtPmhlYWRlcnMtPmluX291
dCwgJnJlcS0+aW4uaCwNCj4gKwkJCQkgICBzaXplb2YocmVxLT5pbi5oKSk7DQo+ICB9DQo+ICAN
Cj4gIHN0YXRpYyBpbnQgZnVzZV91cmluZ19wcmVwYXJlX3NlbmQoc3RydWN0IGZ1c2VfcmluZ19l
bnQgKmVudCwNCg0KDQpSZXZpZXdlZC1ieTogQmVybmQgU2NodWJlcnQgPGJzY2h1YmVydEBkZG4u
Y29tPg0KDQo=

