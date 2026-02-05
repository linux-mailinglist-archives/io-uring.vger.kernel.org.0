Return-Path: <io-uring+bounces-12066-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MH1uJcwQhWms7wMAu9opvQ
	(envelope-from <io-uring+bounces-12066-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 22:51:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A73F7E7E
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 22:51:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60B3D300C013
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 21:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2EF11FC7C5;
	Thu,  5 Feb 2026 21:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="qd9AjgFl"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C3F30DEB8;
	Thu,  5 Feb 2026 21:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770328130; cv=fail; b=kJbzF6SZGRpkrfWRUFTModNOTePbgMNykiJFJxAkZAX1PzuPmS+D2Pcd0rA7o1rvGv4MWqExrqi4kNdcfTXEs1rW9g2WMcMs/0PB7y6ZRR6/vhJ36qzoPPZhloNgWia1mbr3c3558ZNSqKdlQYx+hBuDI2l/haq2VfTFg0L/LyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770328130; c=relaxed/simple;
	bh=RrOnyCKxuRioxl0WKXLO551oruu1Y/ObVrr4TQhwG5Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=arsfpfxEmq2Alx+Pwpnj0frjsVxTOWLm5EitZ4bixHnjiDo/46zU74nheuWPSzOpIu/kyAgaxq+1HMVYjpCRqYEn8KRqvsZ7GcKUm2/+L6+wSqu0aNDGfND4K9jdSlSF20O0/mGJcADomanvYypN3iWneo6X5SEHeEt7fLpJMk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=qd9AjgFl; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020100.outbound.protection.outlook.com [52.101.201.100]) by mx-outbound12-169.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 05 Feb 2026 21:48:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tR7qNKXOSH8FyBjs5RMCO/U4hUsLSDHSQqgQ+6/ddMXdyxbZ36IRZpY8u1K/BH9GJGnmubqBVnjCl3L9vD6WWr6sXvqTP1aTxNtRnpp4s93wcDuMJNyYOvplI5liunPiuwHQXwkvnW4oqKuq/fIIGJ9G/rnxLTFMsX/440/pTOW/KVeewmEMtyUk1dlc3+NyFThppM7h4TorDHJte+dSeWbx4jVyFWv19p4zBIRwGfrb4tnh9CDcgHJV5OExKL5+ims4CG65BMwhYEbM5lZfnc9nOTeDYjgMZLTBkWbovGLmsF/C2dwZVPpi5h/AbNDX1Ztw5PLliZ0uuSfMel+OvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IlB4PJRNYZaPsS6rIrvx20ibgVKXEbkgbAP/yLJ5Dkk=;
 b=G5pw6cIg/aUcyK3n4XdzztfONNKPzRRSIuNV9S796zcBkGkIE7EGEAVjFKc79n6v2VN4wOfyS7Ui6GW06OdVlUaXvIBL70nLcIN24OjmpiDkQ3KRLw/5PlZ+QHtJBylCPkGOi1L52Wubgo2/gcUroLRHktUo5p3eV8r6X9Zj33G13FKMeF4TWYDqpHw1xqwVkZf55NPiHZ3eCsC93T81MmHUyXZPmvi1tADdxiBfOy8BjOhx7PPbQlC4WNN1E4Y8IxFBW7LGvK+74KUgRe8PXO2gigEWe5G59i+idqzp7XmOAF1+XLYLscGVHrJdVOHcwMfCE1kWUqSymtfIWdbP4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlB4PJRNYZaPsS6rIrvx20ibgVKXEbkgbAP/yLJ5Dkk=;
 b=qd9AjgFlze56VOKbavvPTBBXYc479behoExgmKdQPL5lgR2q2ZvJBtOp2QYHE0PpU/l67zL+gLdvbmO6uiIqLm/8YtBUWiojJlBb4azBB1OFyJc1LsbzxDRWIsDoa23+bA8KNuavtjqxK6EhsvGmCFF4lauuwT6II9qBTQdChiM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by DM4PR19MB5954.namprd19.prod.outlook.com (2603:10b6:8:6a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Thu, 5 Feb
 2026 21:48:34 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704%6]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 21:48:34 +0000
Message-ID: <4e9d0896-e887-47bc-bc82-cb7fe17ec64e@ddn.com>
Date: Thu, 5 Feb 2026 22:48:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/25] fuse: add io-uring kernel-managed buffer ring
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Bernd Schubert <bernd@bsbernd.com>, miklos@szeredi.hu, axboe@kernel.dk,
 asml.silence@gmail.com, io-uring@vger.kernel.org, csander@purestorage.com,
 xiaobing.li@samsung.com, linux-fsdevel@vger.kernel.org
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-20-joannelkoong@gmail.com>
 <4e406b1f-723b-4dc7-8e50-1a5ef6ea11b3@bsbernd.com>
 <CAJnrk1YDa6=ygmaNhtoDudGdLKmWsP52+_aYNz3E_VNzQUVsDg@mail.gmail.com>
 <ffe1a340-4759-441b-b04d-2ae7732bbd35@ddn.com>
 <CAJnrk1bt8X2E6estPz-xUmUBeQ93rKOpY078kVQCMmjtiVA5eA@mail.gmail.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1bt8X2E6estPz-xUmUBeQ93rKOpY078kVQCMmjtiVA5eA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0390.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:399::7) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|DM4PR19MB5954:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ea7cff2-1292-4939-93b0-08de65004f90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|1800799024|10070799003|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?djB4WTBITlZQYTBLaTdhWjFnQVRRSjF1MWh2RUtURUg2eTk5Rk5FMHNJUkxy?=
 =?utf-8?B?Q29rWlVWZHRmd3F5UThEejIvbnBYQUZ1cVpFQzVoN2dkR2RwZGRoL0x2OTRV?=
 =?utf-8?B?cGpLcFhac1laMkF0dzBYSXRNZXdlOUkza2N1OWdXNWF3L1IzQkNHcy9Yc1hB?=
 =?utf-8?B?dXhoak9XZFJuSnlIemN5Y0V3a3B3N3hHbW90dWwrRkNFTTJXallxWjhqelhL?=
 =?utf-8?B?enN1ZW1LUmJOSUdWaFMvSlJldUFsTGNZQ3lNK2Fya2lBaFc3bW55YjNFelJw?=
 =?utf-8?B?UEdjb2N4b29YMU1MUUJNV3ZkREtIV21BNlA1ckVRb0Q3S2dwNjVLejdBYVBO?=
 =?utf-8?B?YWJUQk1NdnFKSFNJM3JxM2xzcm80QnQ0Si92Mk8yNmRuWkQxallnN29SeE5r?=
 =?utf-8?B?a0NjdE1VL2R2U3F6V2VZM2drdTQ2UmxrcjVORy9RdXV4RUZ0MUF4OENOays2?=
 =?utf-8?B?dlpkYUw2YnB0a2ZVU3JjUXRMTmlpY2N4YXE4WHZwZjFzeWNzNEUrWUEvY2Zj?=
 =?utf-8?B?ZGlPNEJ0QnFxeGhOLzBQb1piQ2x0TWlvMHZFU3NUSUtQOGZmczkwejFoWFY5?=
 =?utf-8?B?bzlhUEEySHh2WmljWHpkWUQwNlBQcndDMDlEdGhpMUFuZU5BSXMxdFNRaWVs?=
 =?utf-8?B?YzhTdHhvdUpFNWNRUVM4MFV5ak9xWHRxY1ZsdXhkRWRRRjVlWGNhOTZLcis1?=
 =?utf-8?B?bDlOeHc2bElpZlQ1QlBBQU0wT0ltZXZGVVVoYzk2aG94TE85UnlDRy93WnNs?=
 =?utf-8?B?OGtGa2ZQVHRxNnozaWQrQThJRnF3bWM4dXA4M012Y0swcVViRTNtcDdXSm12?=
 =?utf-8?B?WFRPNjhXWklLajBHYTB3MUloOGFCcGVqcEtENVZZT3RCUjFsREVtTlFOcVJP?=
 =?utf-8?B?NTJlMmUvMENOMkRxWklFL0NyU1pGbUZIbnNER21pa0RhdWo0ZGtkN1VOSm1G?=
 =?utf-8?B?Ni9MdWFmSzVXY0xVNm9ZUDFpcE1UNVNtNjFVVEJwTlZlMUtvTUJzNUZqV3Mr?=
 =?utf-8?B?T1ZIdXdlM01TRHc2NnF1cDRlZzB5N09KUGxEK3l1Z2xDVUpORHh3U05TN09P?=
 =?utf-8?B?dm5kTWtYZ3ZudGlMdTF6OUV5c0w2RzBKRzJ6Y2xpM3FpamFHb05yWTNmVFhI?=
 =?utf-8?B?T0xkL3lrL1YwNUZrVFJucHdBRDBCS2lhM2xISHNhdHhqSld0eFltcklPR29m?=
 =?utf-8?B?U0ZmTEZMcSt0alpyQkJPN2lzRmxkaDJURnVoTVk1M0JqTEdIMUw1ZnZHK1F2?=
 =?utf-8?B?NGZ6ejdqbTFWUVYxQlQzVGpERDlxMDR3SjdlaFJyMUVrTnU3dHZocyt1aXJn?=
 =?utf-8?B?ditFOC9FMi9OVmZKK2xzYUZWOS82bVozeDR6NGwxM01uK2NETU0xNUdBbFNF?=
 =?utf-8?B?TTFUQTBSTFhlaDFEanJSNjV3UWRlZGsrc2kxL2phSER5VmpCaGJPOU5Xcity?=
 =?utf-8?B?cHBjRjZlczE2T0phV042K1B3eDlBNXZKeENFWGJITytmWmt4MC9GMFlONDRv?=
 =?utf-8?B?M2U5UW01TWFCZmZDWDZDQVlxeWtWUWNhSnZIa3dDbENvZGtidjdzblUvUi9y?=
 =?utf-8?B?eC80WWZEQ1M3RHo5QmNnZWpzS21VZHhDQmlLRzhlTjhWVjFhWGZJZyswWUFE?=
 =?utf-8?B?bkFkcE9YU25namZIK0pDdFI2eEk1YndJckY3NzZyQlVQZTFjSm95TDl0U0Vu?=
 =?utf-8?B?QlJpOElBRXpjSGNnS2xEVFQ1NFpTVUNkc21idnRMOFVDR0xDU1FwSXRzTWI4?=
 =?utf-8?B?b2IyT1F3ektOYUkzWHlIU1poN3BYQmdlckhMTWx0K0Y3SmNyNVYxUWM4R0lk?=
 =?utf-8?B?NWFPRGo3WU1TaW80eHhlci9lRnlMMUUwS2hXNDRPSzl3cnc4WkgvUkFTR2VL?=
 =?utf-8?B?Q2UwYjZCL0NHMHBoSGtxVW1SQWF6RmRpamUzUktaRG56K05sZjB2Z09VWGJB?=
 =?utf-8?B?dEVTSUpTS294TmRGQ2FnN0dwZ0dHYU5MUHpXdE9IV3hCb2hTU3g5NHV6akJx?=
 =?utf-8?B?NDJXem9BbkNMall6SFBsY2NpTGI1WlE2L3RFTlVmV05FMGU0QVkzc3pYUWM0?=
 =?utf-8?B?M0ZVT1ByMlRnVU1HYURyb0lna0tudC8xL1E1cWZnNkV2RXFBVXR1OEdLSUNv?=
 =?utf-8?Q?8S70=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(10070799003)(376014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVU2NE51eWxuYjdiZXhJUTd3VHF1VGhpd2U3QXRXUEx3NjhreDRObXBSekw3?=
 =?utf-8?B?WVozMGpwNHgrRURETURtYWIwU3ZDd0hEL3J6aEd0TE04NnBtejE2S1MzZWk2?=
 =?utf-8?B?WWxQRnkvSk1zbVBkRVNPTVBGdnVnVDFCcXM3R01XaWY0aXQwVkI2dTZCRDVX?=
 =?utf-8?B?eXRSVnpJOWQ5OTdTNVV1dHcxdXYxSXNRd1RDb2k2R2s2MTB2U0JpZTMrb2xt?=
 =?utf-8?B?YkF6UW1oMmt2M2tXQzBwY2RnK0QvNTVMQ1BXUUpCQzVJeTBrUG9PM0lUdmZQ?=
 =?utf-8?B?dzg4T3I1S0xxUHdzcFBpcFE5bWJzbWJ6QTdhTUJhSkdqNTVMZ2VQTGhYZFg3?=
 =?utf-8?B?Y3RTZXVJLzk3T0tiWHFKQmtyb0E0V0lFenNjSDJIU0dRY0VLL2l3dVVJVy9t?=
 =?utf-8?B?ZE12ck1NZ08ybDQxYU1rTVVmYXYwaGVId0Z3TVBiM3BxSUJIWnd5Ym1CVzZV?=
 =?utf-8?B?bEM2K2tJRjk4QTNNYkNEU2lVVjRNcFVsVGQ0TDAvd1FLV3o0a3h1N2dVWTJ3?=
 =?utf-8?B?VlVsUHpwMXNxYmgySEpDSGVCdnoxT09JekQ4aEVCOG8vK2N0TGpPK0FiN1JJ?=
 =?utf-8?B?RlZsNUZxTGdENFQrRWV0NjczQkg0QlhRTmJNWGVkSHluVUhIK0UwMmlJMHoy?=
 =?utf-8?B?elNBTzVvVVBBTzhnZTVKU3BlMG8reWYrTU1lc1EyQUdDWXlaTzNmRTA2TnRV?=
 =?utf-8?B?OWFIajJhSHhJekpzWkFXUHNoZkRJcWs3K3ZONDlkQkt3bmlFdE1yY1BXcGZm?=
 =?utf-8?B?cEwwdEIza010OTBDdmRwMC9nbC9RTUNOb05pT0lxbTdESEhqNzZoakM4TFl3?=
 =?utf-8?B?V1RzREtualVmazJKOVQ3a0N5UmQ0YWczaFdiN0RFQk5TZEJxTzR6M0R4RUZw?=
 =?utf-8?B?R3JHaDdiRktCVTFML2tYNDEyZ3phRUVkcWFTdXNNaUdQREwxd1FtNFh0cjNQ?=
 =?utf-8?B?TDhUa2VuYzc0SmZJL1F5THNGWlc2d2JuT05hQkFJN09UeEsrdnNMVHRZdktN?=
 =?utf-8?B?S3dwNUJtcnc1RzdnL1pzYWZyQXo5MFFqNjBLeENmSS9HVVFBWU52ZFBLMUR0?=
 =?utf-8?B?QUNiR1pYLzE2V1oxTlhHSFFKYmpPTjBZNTB5NW05eGswdHhQNjdKVitGOXBM?=
 =?utf-8?B?ZE5vbWRqTWtKMXI2b1VOT2gyaHBCMElkQkNVZDUyRldYRWhtZWJ6d3NrVW8r?=
 =?utf-8?B?OWw4Y2xSa3ljRjgyeUJiUHYzTytGMS9IY281R3RsZTNlTlUvQVRuM2wvTFc0?=
 =?utf-8?B?dHBkV3NzcWRSa29sUlNpVVY4U0R2bjQrMXJBZjV6MVlVclpiM0EvNGFKdVUw?=
 =?utf-8?B?LzZ5U1FZSXI1ZXE1VllZTXd6Tjlkcnp0UVFVbUNOQ1BRalJFK1JuVTJVN0JO?=
 =?utf-8?B?S05XWHVmU1JiNkoxdDNxZlhwQzRLRlBtVHBVR2lVVHBRRDkzbnBaVlhTVFBm?=
 =?utf-8?B?TlkrRGRIKzROQ1NhZk5FN3NjUTVzWHI2dGJ6U0lXekJZMHRsTlJZYWx5RGNX?=
 =?utf-8?B?NkJyT2hWaExvaUgzWVNINTRJUHB2Vit1NlZsNzlCdUdKQXBqY2pkZ05VTEJD?=
 =?utf-8?B?ZHF2dVFnRUFKNTB0ODlFYjZrdkprOVFzYzI3ZjdsWmNjNTlTNWRVYTAvMWh2?=
 =?utf-8?B?bUdnSWgzN3d1VFU2ZGplZ2FUeW9qeEcwVnoyU3d0bm1vY3RrRytXcDYwRVdD?=
 =?utf-8?B?aHM1TXQ0K2ExU2xkQVFyMXZ4eEMxcDRhditMNGlnalNoMTFZNnhWcE5uTDY1?=
 =?utf-8?B?cUEza0hYaE1sODB2dmR5UVp5Mlhhc0tKVnkwT2FBcDZDbVpNQTNNQjJ2R2VV?=
 =?utf-8?B?MXVKT0FIWUV5Vmtvc1FJL1BrUWtvbytmMFJ5Ty9IUzNuUk5neFAwejdwTy9Z?=
 =?utf-8?B?Q0R3ejhRSThaYXpuN2VRSTE2ZWx6ZjlaYVZpZmQ0dVJFNmtUUUc5dVRmN2J1?=
 =?utf-8?B?RU03RnZKWnY4d29CTUdxdGdULzQ4WHB1Y2VkZG1uNkhZY3FFZkxBOUZFVldz?=
 =?utf-8?B?cUVBbXgwY254TVozaC9wc2pVVU45Sk9QcjkwS2g5ek1LRHRFR2h5N2RERmdu?=
 =?utf-8?B?cTJ2ZUtQTzN1dS9saTM5QVVoc29UTWJLVkVSKzlDTDUzbmRWS1pqd3pWdVdM?=
 =?utf-8?B?TWtHZS92alMzZFNLTk1tZTJSUGsvaTV1cThuLy9Sa0hYa1ZsMXNNRzZldFJG?=
 =?utf-8?B?STVjNEw3S0FEUVNNbUoyZEY4UnRDU29SZDI3VU4wSUd2T01MZ3hCeWxnUEQx?=
 =?utf-8?B?RkQ4dzEyb3hnRFZDaUt4YjN4YWJva09VZDQrNk9NdkVJd3RmNmhlMUluYVZt?=
 =?utf-8?B?VEl3TU1NVlRROGdqcXJrUTdOL0ZXaHp2UjJKT3Z5M0QvRWJhNGRiU3cxQVVz?=
 =?utf-8?Q?P5qr7BGuNQrP/vXWg6EXY+I7WRjsY95/hxECMmz/TuzRX?=
X-MS-Exchange-AntiSpam-MessageData-1: lrk3/p+vBoXk8w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bfLb1ZaZs/WcLYfRFKePABaB3Fh1Z9uT5Ycseq3o2hRb1S6F+kQ57NA0Of1j1zdVI4iPZkP6awiiFT0oMf17uHdkwnZITqAdb89hPtPqgAk4d9u37c/JqgQo7t4C8y/qRhAyUB4GPe5n9PLpYCtck1eOeLuAlKQh1eAh/9D+6FddPHvzBFO4/RxWvdkZu/WbeQksPeJ4kRxiEVytqKCM2dQV5q6zBDsqCzV6sh7n4QJvAly+bGe7duoYjGEfmlFumvbzNgfgsFPmwTq06nKi89o62A81b1tf01Su0xCmw+zOc5iasbAFTf/dVPgaVVbOpJURz3zb5Cmi5vM72pn6+9aypE6TLWErrXeUsBpexNpmcB4IEFfuVAxZhDlkJIk2lPygSSaY1Y4t5zPiDxGDhbwZhH4HDPnHmnuEKJdDn/pDPVIyxWQIUhjHA58ZJ7rMyfvKGAqumN9XPtp93sEC3zELCIi0ntmOhJhjRC4FgOB20pUAuU65cj73TBII8CyPi2+e8GfZXBXNe+ZbpW0kmO1jYmeJ2R/BX0IRD++nW2jsVq64EO2mHhN/A+aohBf+WuOvfK9uOqhuLKuHHkEtCW1IroGg4S1Tm9HgZiwXGBnzJCpB2Qvk/PRcKgpEOOqkVyGnCW8ge1QTAXgXj+2rzA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea7cff2-1292-4939-93b0-08de65004f90
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 21:48:34.4148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNr/FL+AbT7x9mBeBVcgRvrcrwbifdWHzysvp1LdjVeS7DQrEk9Dc3llAP//LG6z4GC4q0zqaeqmqPJoGxyV0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR19MB5954
X-BESS-ID: 1770328118-103241-26950-8554-1
X-BESS-VER: 2019.1_20260203.1731
X-BESS-Apparent-Source-IP: 52.101.201.100
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVqbmhkZAVgZQ0CzRyCwtzTLR3N
	gizcIkNS3Rwswy1TLF1MDU3NzUNNlQqTYWANSkwJFBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.270926 [from 
	cloudscan10-100.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[ddn.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ddn.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-12066-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[bsbernd.com,szeredi.hu,kernel.dk,gmail.com,vger.kernel.org,purestorage.com,samsung.com];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bschubert@ddn.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[ddn.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[bsbernd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ddn.com:email,ddn.com:dkim,ddn.com:mid]
X-Rspamd-Queue-Id: 05A73F7E7E
X-Rspamd-Action: no action



On 2/5/26 22:29, Joanne Koong wrote:
> On Thu, Feb 5, 2026 at 12:49 PM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>>
>>
>> On 2/5/26 21:24, Joanne Koong wrote:
>>> On Tue, Feb 3, 2026 at 3:58 PM Bernd Schubert <bernd@bsbernd.com> wrote:
>>>>
>>>>
>>>>
>>>> On 12/23/25 01:35, Joanne Koong wrote:
>>>>> Add io-uring kernel-managed buffer ring capability for fuse daemons
>>>>> communicating through the io-uring interface.
>>>>>
>>>>> This has two benefits:
>>>>> a) eliminates the overhead of pinning/unpinning user pages and
>>>>> translating virtual addresses for every server-kernel interaction
>>>>>
>>>>> b) reduces the amount of memory needed for the buffers per queue and
>>>>> allows buffers to be reused across entries. Incremental buffer
>>>>> consumption, when added, will allow a buffer to be used across multiple
>>>>> requests.
>>>>>
>>>>> Buffer ring usage is set on a per-queue basis. In order to use this, the
>>>>> daemon needs to have preregistered a kernel-managed buffer ring and a
>>>>> fixed buffer at index 0 that will hold all the headers, and set the
>>>>> "use_bufring" field during registration. The kernel-managed buffer ring
>>>>> will be pinned for the lifetime of the connection.
>>>>>
>>>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>>>> ---
>>>>>  fs/fuse/dev_uring.c       | 423 ++++++++++++++++++++++++++++++++------
>>>>>  fs/fuse/dev_uring_i.h     |  30 ++-
>>>>>  include/uapi/linux/fuse.h |  15 +-
>>>>>  3 files changed, 399 insertions(+), 69 deletions(-)
>>>>>
>>>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>>>>> @@ -824,21 +1040,29 @@ static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
>>>>>  }
>>>>>
>>>>>  /* Fetch the next fuse request if available */
>>>>> -static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
>>>>> +static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent,
>>>>> +                                               unsigned int issue_flags)
>>>>>       __must_hold(&queue->lock)
>>>>>  {
>>>>>       struct fuse_req *req;
>>>>>       struct fuse_ring_queue *queue = ent->queue;
>>>>>       struct list_head *req_queue = &queue->fuse_req_queue;
>>>>> +     int err;
>>>>>
>>>>>       lockdep_assert_held(&queue->lock);
>>>>>
>>>>>       /* get and assign the next entry while it is still holding the lock */
>>>>>       req = list_first_entry_or_null(req_queue, struct fuse_req, list);
>>>>> -     if (req)
>>>>> -             fuse_uring_add_req_to_ring_ent(ent, req);
>>>>> +     if (req) {
>>>>> +             err = fuse_uring_next_req_update_buffer(ent, req, issue_flags);
>>>>> +             if (!err) {
>>>>> +                     fuse_uring_add_req_to_ring_ent(ent, req);
>>>>> +                     return req;
>>>>> +             }
>>>>
>>>> Hmm, who/what is going to handle the request if this fails? Let's say we
>>>> have just one ring entry per queue and now it fails here - this ring
>>>> entry will go into FRRS_AVAILABLE and nothing will pull from the queue
>>>> anymore. I guess it _should_ not happen, some protection would be good.
>>>> In order to handle it, at least one other ent needs to be in flight.
>>>
>>> If the queue only has one ring ent and this fails, the request gets
>>> reassigned to the ent whenever ->send_req() is next triggered. I don't
>>> think this is a new edge case introduced by kmbufs; in the existing
>>> code, fuse_uring_commit_fetch() -> fuse_uring_get_next_fuse_req() ->
>>> fuse_uring_send_next_to_ring() -> fuse_uring_prepare_send() could fail
>>> if any of the copying fails, in which case we end up in the same
>>> position of the ent getting assigned the next request whenever
>>> ->send_req() is next triggered.
>>
>> I don't manage to check right now (need to solve another imbalance with
>> reduced rings right now), but every failed copy is *supposed* to end up
> 
> Thanks for your work on the reduced rings, I'm looking forward to
> seeing your patchset.
> 
>> in a request failure. Why should it block, if the copy failed?
>> It would be a bug if it does not right now and should be solved.
>>
>> Regarding your copy, I don't think waiting for for the next ->send_req()
>> is an option, it might be never.
>> One solution might be a single entry in any of the queues or in a
>> separate queue that doesn't have buf-rings - i.e. it can go slowly, but
>> it must not block. Some wake-up task retry might also work, but would be
>> timeout based.
> 
> Ah, so your concern is about the request taking too long to complete,
> not about the ent not being available again to send requests. In the
> existing code, yes if the next request can't be sent after a commit
> then that next request is immediately terminated. For the kmbuf case,
> the fuse_uring_next_req_update_buffer() call only fails if all the
> buffers are currently being used. The request will be picked up when
> the next buffer becomes available / is recycled back, which happens
> when the request(s) sent out to the server completes and is committed,
> if a ->send_req() hasn't already been triggered by then.


In the simple one ring entry example there wouldn't be another in-fly
request - the request would basically hang forever, if some reasons the
ring buffer is not available. It *shouldn't* happen, but what if for
example the same buffer would be used for zery-copy another subsystem
now consumes them? No idea if that could happen - with these buffers
there an additional complexity, which I don't understand from fuse point
of view. Let's just assume there would be some kind of ring buffer bug
and requests would now hang - how would we debug this if it just hangs
without any log or failure message?


Thanks,
Bernd

