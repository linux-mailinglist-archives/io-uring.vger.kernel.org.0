Return-Path: <io-uring+bounces-8330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3BF9AD7FA3
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 02:29:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2810B1894DBA
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 00:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8BA1B4233;
	Fri, 13 Jun 2025 00:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IuvDMxEl"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49A01B414A;
	Fri, 13 Jun 2025 00:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749774548; cv=fail; b=pCWHQCc90z+2/omyOoG8k1wilrSTGZQmgcdt/9ilzQwIAuSaRVgol8Sosy1D8KAiMausBEIAzG80T5PMzsk3htqpZyEa9E9P5WKTXCgqolsEqT1P6iV9Hfagf2K8/1SmbAFyMsHbvyaJAqSehNoYt98OkDVbmlpG/HDk3qtDMMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749774548; c=relaxed/simple;
	bh=pk7ZTCynyujP6Td4+XXUum71uLi7Jz+Cn4EXe4Gje/E=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=B45bzu3RIePPhMuz0piq3F6muONWxCR10P6Jx1zobhdyc00dnPPhl3owGE6RgKHDJ3sdh18XHQw3N8lu2bPmvLXo3Yz5q0D4pD6JpYJbeuJZ80eM7SR6TIDhEe2LNbzcwGWjxf7cGhqv5AQ+vFiToSizr4cTvK5IZXwi/DY20IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IuvDMxEl; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749774546; x=1781310546;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=pk7ZTCynyujP6Td4+XXUum71uLi7Jz+Cn4EXe4Gje/E=;
  b=IuvDMxElDeSQs/lLUJvAcL3YAyyUe68VYOfpx98pPmp8pXATy6LZI+7e
   0c7b9posjkUTVox5czQoqooGo8TkrdkfnwFtbGzWBRZizvscQP8zQywXu
   HwcLH6KgBHHl1KfD9bVfMntozbu3GWLVIG7OheQkwCGDalSkcS3gB/qGT
   kSQxhD1/7JEVzFl/fPn/c0PF8vtbGZtwwxmxF2zukVCyVwLGbxrpBuFcz
   noV/wAw7FVH/fbrlLmqzXkhnZKhlYD27jGzQuYfBZm4zANEm/Gqum2M5n
   QRdfSQZ0LzZfW9NaFraEBikN/uJZRnDJoZn8FSPSVRuDnqG+ZrRJniMDt
   g==;
X-CSE-ConnectionGUID: KI8TxboER/SUYh29rb9WvA==
X-CSE-MsgGUID: 6zDdVjBWQAuy05F9EVQfwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="62257121"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="62257121"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 17:29:04 -0700
X-CSE-ConnectionGUID: ORxfYtQmRz+jnN+V5+hgFQ==
X-CSE-MsgGUID: 2V2R5v4/QpSetPNPuV+x7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="184916349"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 17:29:05 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 17:29:03 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 17:29:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.66)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 17:29:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OqTnchRjDHcHGMVhRd09IwYK1pYVnjDtjVVtdXuW+UTcM+WOBBEIdvRdNmxK6gBpfCKw7YaRt3KzQh1790fu8ePgR0YoIFhEX42l/3qdsudvUv4u/JB2WENbXDcYHCIEcMETGfcMevLxiGdd3WNlEDu0LJrs8cO/BUtgqNKmBrCw2kE7YiZd+e1LkYtqwaZot1PIJ+qcVOB1IRRRbId9e8/+yeQCT/dCeG1PmuAIf+6bbEfTktGBzW9psSPLxqilQTcQhQbsstutp1nySlFnjJTfIHAf1IlvsBYqWWGxlUC1CZbZWPykvHHEmT2LG64SltnhpxLiy4yLAK0+UvKAnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGmcikYuTo8s6mEvNRGv7sVDea0BBNVhDvtonXSj7Bs=;
 b=iri0AoOw3Q80dVURVbltBq/KBZoGifZjUZemlYW3HXXxPJEbKA+kWHIECuvlITnFHBu6Nb2PJ23TtRS4OnM4xGSsm52HEfv4F20UdxVlysxGRYqkr2yNM5hkDs1/hHQNm8hVp0FlTMgMPLbSHdmIzuG6DORkpn1kMqe1+Jbhkc4HrvhmuVmGgOjx8vsCIsQYgKh9U/dFAhR/bQZ0k5BmakARBux+m+1IrouW2qEV0YRTVcLQzJzdtcLLSd0xmMfLZscyxY264lC6IisRoHiTvwD6IY5/4+B8j9txQcY5wMTFoXxtfZWa5lLBuh9Lmme/mXQ2acrOT4g8qVPIKyCX+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CH3PR11MB7724.namprd11.prod.outlook.com (2603:10b6:610:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Fri, 13 Jun
 2025 00:28:59 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8792.034; Fri, 13 Jun 2025
 00:28:58 +0000
Date: Fri, 13 Jun 2025 08:28:50 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Jens Axboe <axboe@kernel.dk>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	<io-uring@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [io_uring/io]  8343cae362:
 stress-ng.io-uring.ops_per_sec 74.3% regression
Message-ID: <202506121643.6753f7b8-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::20) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CH3PR11MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: 14fa16f2-3a3c-446e-1f67-08ddaa1149b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?8gcBif+y1SeGdXr7yjm5aMgseQCs39RdzeDsv6wj4snqBZG4gtKtAY03E9?=
 =?iso-8859-1?Q?PXcn6VDqZBo+94eHVsrDB3aMiHglwPGeFdDmxwsopKO2J4AiRa2Uo8hM/3?=
 =?iso-8859-1?Q?1sEut9BAwykMNk+NXPJT1Ke3mHu3k+HvhdHWKP93gY5FpFFjCLyivOeiMp?=
 =?iso-8859-1?Q?1bYbxAJG9GvWSeKlocAJK2alodjhRn/4Aey5HwsysztazNUCbHZsSqsBke?=
 =?iso-8859-1?Q?amOlsJZHASjMt5ekMLQSOjUacVIcqmVqcSofCv7LPAM/GLkvCDfdL/tY5c?=
 =?iso-8859-1?Q?oADp8Nv+gJZWkrgVbQe6y/VVhmG0oXaf+68U2ZRI579pYLD5AJmmge0yK8?=
 =?iso-8859-1?Q?WOMhy/NILlN9TdMVcE3LYh6WRv2f2D5MdnSq/AZbL1soSVLN6DJDJMXAxQ?=
 =?iso-8859-1?Q?VeYWq6ZfrNDyXxpZrXYZ3dpFkNOE6Xvy1YniU/FOMta6vPVLYtAQCHT6Kp?=
 =?iso-8859-1?Q?GeAibgK04dFsW8ZHXll+OHFuXUABWrd55tLofhgj25ypdXd5Mu1N79uFEE?=
 =?iso-8859-1?Q?SylJPHtKEPi/Vzymtjb7dAOXTz/ZlriTnj+A5RDNQDIMUZsp0axOCNNryv?=
 =?iso-8859-1?Q?cbL3QJWZWnAdpuj1b3CKD2N1LdzI4pNsJCVMboRe84jiWKi7BArDkHPySt?=
 =?iso-8859-1?Q?zUKIIKPu33mXQtsSruO97uSvvXGX1C/0HO00M1obcZ0Q4q35NET7l+5GbZ?=
 =?iso-8859-1?Q?jI8Yquoka32FzKDGrCXwspW00Y8Xzt+lcT/A/A50AeG2tbvINLJTCpFLyB?=
 =?iso-8859-1?Q?YrhRmXcROH9JMj0r75WXpOmlU+GTUfPW/cKEe07GI673jGJt+tPRZFpKVX?=
 =?iso-8859-1?Q?z1HvobywaImzShJ0r/0k8hKjEXF8pLB51I/EA1BglEJsPMBQ/rkYATNdqo?=
 =?iso-8859-1?Q?0f4EJ0nm8S56W4fhzlN4rL7ZEbNlIZfPfRd5X00mukuw+FbPrKVz8zGZZv?=
 =?iso-8859-1?Q?Teg7Ama2zWQXWjByZlRm7FO27MNcdVysAyE9TKpC3wDJ6PrCSQl+MQHj+p?=
 =?iso-8859-1?Q?lkV3WIDXx3qbJkUXpW8fwPNiAdWPUvuZ3xpU0iydlQCKE+D7cW6Ruaqaq8?=
 =?iso-8859-1?Q?EHMNIjc4rqZZWVKyuUQ6sZLcaak/fCOo5zDBvghMQDlwUzYA3lNvgDdQlM?=
 =?iso-8859-1?Q?XqPlq8QPRPZ4TaLdo8vsolLKYBe2eozR8W6sKVhdOu9wnu3MMzSZ8GJxZZ?=
 =?iso-8859-1?Q?OWQ6rKSPvYDeRn/9Mtyss/TAnb44j+oGWw0DPeJfPA96pwDEAHYES7xpWd?=
 =?iso-8859-1?Q?RmInT603YfEegyKVayTEKgvUXREq4kcx/X1TZ6/OLVX603/jHbU+pbMN6+?=
 =?iso-8859-1?Q?2QN3SUJDus9eGp4vo79HLAFwC53AzNl1xtLSpLBJq2+Y+khSWeQ3TETKq1?=
 =?iso-8859-1?Q?eB40gCAOAfxl3bhacMzXfnlXzFaWodIPKmy4hoXh3kzFtKGZndgsSO0gfZ?=
 =?iso-8859-1?Q?/Czj1Zk4LLehXkUw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?VzNV+G9EAI8Im70yXlaFD2JaZKpefjT3FLKMS772iQKLfqvpm1yLwLfyMN?=
 =?iso-8859-1?Q?idea9HeXUVUzKwY25HNvskP8kjuiLktHH8OK2FtV8hK6nr0cYgc0XzimXm?=
 =?iso-8859-1?Q?WNxziFLZ2WGphbjdOiUKbTLOv85C6Wp286lFXpuSHQQRXnBsVor2AeNzRe?=
 =?iso-8859-1?Q?mjxO4FHC2Jv2vH8UspPCs/Btqf2M7wAN6hAi/Ns0RqYy7F4J2D0hYTLd+W?=
 =?iso-8859-1?Q?DEv0DHqjePD2TelpCW4f4J0gF0TsyEwBqGo+Pv4Buy4i8TDPmbh3RgrkHp?=
 =?iso-8859-1?Q?EDYfjYpzVIJk33v4IHPNsZ/RAIbiiOVEi5P5iSzoOM/CpdzFA5BJlOMLCo?=
 =?iso-8859-1?Q?1OQg3zRBSZPAaSqHDLF91IARZ2/WZCoHLZ/dErSosH1FG28GEPi6M7XwcA?=
 =?iso-8859-1?Q?imzRUS9IJRLnsX0PJoa7eOn4FNsxB9xCk0X78/q4IRG2dHKHHzYHv5eg05?=
 =?iso-8859-1?Q?GZYxynqcYeVx5Jtvby8ZP28zqY1f9yflCbsH8rouUCezwwkpKeXdXkkn4Q?=
 =?iso-8859-1?Q?duVx7ct0iNSVjc3dqGnqpzO5v2qrYTOKQfujj0e1sR6dVUzaRePXI3cq7a?=
 =?iso-8859-1?Q?/DjtIVZN9+VGTCurWyQpJR46btv0Xb0jNLa4UwXKWjIcWIGuJqnUEJ1SVo?=
 =?iso-8859-1?Q?MFXEXIcHOhCEILbuqgX5j3Yf1TA8GaPkeup/1FCRiXGiH8tOgFBH8T0CJS?=
 =?iso-8859-1?Q?2szOJg7lq5u4fVcGiV4Q9b1wwRKmoSNwvKL3/Gc6FA76LLZZPdYfdrShlI?=
 =?iso-8859-1?Q?E+bMajr/UpZd5kPMddD5v+BrP7rXbThhBfVv6hmHJAnt9GdFARO4engN51?=
 =?iso-8859-1?Q?cUkXJhl1SYh+6uYdjWjZSuQKyGWXRm9BSaz9JyzQFLS671jqLpZxNQiwNy?=
 =?iso-8859-1?Q?35TatoXxQ7Mq0uJOMJ7UGsAjmptAl5eA3mQtxiJoOQY3//9GP5sGXIGrn8?=
 =?iso-8859-1?Q?IHGRwK/G7RO5SqJs3tMFSmmomENf4hQHmrwckHEblYp2Fk48LWo3uEVl85?=
 =?iso-8859-1?Q?vrmveOpjelNc4UN1gEBIyIUZkD4XLD3oB+WbNPk3tiOjzEO5Bx3zfr3XmV?=
 =?iso-8859-1?Q?VqVhyGRLboTW6cLAwBbsEvwmkU97Xzys1MEkAOQLvT4yppG/kub5ucv1M7?=
 =?iso-8859-1?Q?eB4sTRCv9H7zd4G8bmUJCnN4ujky2X0/fpIZ0pmFkm8Jja6WOu1Qae1RkI?=
 =?iso-8859-1?Q?vreaNgqEBKrFttzzP+sa5TfIzIvLDDFftsiakOiqtQ621LtSRSpZUD5/xM?=
 =?iso-8859-1?Q?irGI25eQwHO6kCkqASokWpokI2fqE4zxbp7QwWPEKesd/hJ4BSrBOqw1oW?=
 =?iso-8859-1?Q?UrGxzf3yuWcNpJwgjqXQl7uQ44T07j+VEQrHx7AlgsfMAjZQ4mjZcPQALb?=
 =?iso-8859-1?Q?TNHze293bm3KqmbRp8+Kzrhdw1q6S1Jd/AhteQgXP0Af8YfasqYWnDeTpu?=
 =?iso-8859-1?Q?AylF2HA9WrN2HpMSYUiBcXnbfyk607H7KURA4HYGwBmpSWYmBLmkTWeoEh?=
 =?iso-8859-1?Q?wXTSwGQA8eYu/NzOlKyGtLLgznDOmOQsZ99729WEMAbULHcupGgkYij/Kj?=
 =?iso-8859-1?Q?bYH4Cfk4qB87YKgw1ep6YxcjydfCWQnCRtBN/NBxv271z1HTPkkSPhv9kd?=
 =?iso-8859-1?Q?V+taUY6jW6/pf3Gch9U6slyQVVwO51bRRjpFblmGLWTxwsk5K9aCF0Sg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 14fa16f2-3a3c-446e-1f67-08ddaa1149b2
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 00:28:58.8502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N4n8gkBMJ33G7fHz1zNYiYAhpyBOG48nNQkXAcHIgxKfw1tBbAVzCXDtaHatp1zXfh0NlQSQ+Dp3PEKJQJQzjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7724
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 74.3% regression of stress-ng.io-uring.ops_per_sec on:


commit: 8343cae362e147a5d4505c2da0e161a4d9e9fbde ("io_uring/io-wq: ignore non-busy worker going to sleep")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[still regression on linus/master      aef17cb3d3c43854002956f24c24ec8e1a0e3546]
[still regression on linux-next/master 19a60293b9925080d97f22f122aca3fc46dadaf9]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: io-uring
	cpufreq_governor: performance


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202506121643.6753f7b8-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250612/202506121643.6753f7b8-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/lkp-icl-2sp7/io-uring/stress-ng/60s

commit: 
  e37dfc0530 ("io_uring/io-wq: move hash helpers to the top")
  8343cae362 ("io_uring/io-wq: ignore non-busy worker going to sleep")

e37dfc0530815ead 8343cae362e147a5d4505c2da0e 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      2904 ±  2%     +13.6%       3301 ±  2%  uptime.idle
 1.565e+08 ± 21%    +466.2%  8.861e+08 ±  5%  cpuidle..time
   1619014 ± 48%   +8648.2%  1.416e+08        cpuidle..usage
     28283 ±  2%    +309.7%     115886        perf-c2c.HITM.local
    921.67 ±  4%     -61.9%     351.50 ± 14%  perf-c2c.HITM.remote
     29205 ±  2%    +298.0%     116237        perf-c2c.HITM.total
   3038723           +77.1%    5382792 ±  5%  numa-meminfo.node1.Active
   3038723           +77.1%    5382792 ±  5%  numa-meminfo.node1.Active(anon)
     10606 ± 13%     -19.8%       8508 ±  8%  numa-meminfo.node1.KernelStack
   2579580 ±  4%     +94.7%    5022058 ±  4%  numa-meminfo.node1.Shmem
  39352066           -74.0%   10238448        numa-numastat.node0.local_node
  39391967           -73.9%   10276795        numa-numastat.node0.numa_hit
  39948493           -69.8%   12046926        numa-numastat.node1.local_node
  39976832           -69.8%   12075359        numa-numastat.node1.numa_hit
      6.05 ± 18%    +173.2%      16.53 ±  7%  vmstat.cpu.id
      0.08 ± 60%  +14471.5%      12.18        vmstat.cpu.wa
      1.00 ± 10%   +1637.0%      17.38 ±  4%  vmstat.procs.b
    105.61           -29.2%      74.74        vmstat.procs.r
  17137613           -58.7%    7075893        vmstat.system.cs
    246744 ±  2%    +131.6%     571559        vmstat.system.in
 8.565e+08           -74.3%  2.201e+08        stress-ng.io-uring.ops
  14275441           -74.3%    3668857        stress-ng.io-uring.ops_per_sec
 1.743e+08           -66.6%   58140952        stress-ng.time.involuntary_context_switches
      6154           -33.0%       4126        stress-ng.time.percent_of_cpu_this_job_got
      3580           -34.2%       2355        stress-ng.time.system_time
    119.49            +5.7%     126.27 ±  2%  stress-ng.time.user_time
 9.179e+08           -73.0%  2.483e+08        stress-ng.time.voluntary_context_switches
   3455437 ±  3%     +71.1%    5910747 ±  3%  meminfo.Active
   3455437 ±  3%     +71.1%    5910747 ±  3%  meminfo.Active(anon)
   6194442           +39.5%    8643216 ±  2%  meminfo.Cached
   4517516 ±  2%     +54.3%    6968608 ±  3%  meminfo.Committed_AS
     20780 ±  4%     -13.2%      18046        meminfo.KernelStack
   8422878           +29.1%   10876171 ±  2%  meminfo.Memused
   2648487 ±  3%     +92.4%    5095657 ±  4%  meminfo.Shmem
   8497686           +28.6%   10928851        meminfo.max_used_kB
      3.14 ± 37%     +10.9       14.00 ±  8%  mpstat.cpu.all.idle%
      0.10 ± 36%     +12.4       12.53        mpstat.cpu.all.iowait%
      0.29 ±  4%      +1.1        1.37 ±  2%  mpstat.cpu.all.irq%
      0.02 ±  6%      +0.2        0.21        mpstat.cpu.all.soft%
     90.48           -26.3       64.17        mpstat.cpu.all.sys%
      5.97 ±  2%      +1.8        7.72        mpstat.cpu.all.usr%
      9.33 ± 30%     +96.4%      18.33 ±  6%  mpstat.max_utilization.seconds
    100.00           -14.0%      85.96        mpstat.max_utilization_pct
  39370167           -73.9%   10276832        numa-vmstat.node0.numa_hit
  39330266           -74.0%   10238485        numa-vmstat.node0.numa_local
    759416           +77.3%    1346128 ±  5%  numa-vmstat.node1.nr_active_anon
     10666 ± 13%     -20.2%       8515 ±  8%  numa-vmstat.node1.nr_kernel_stack
    644580 ±  4%     +94.8%    1255877 ±  4%  numa-vmstat.node1.nr_shmem
    759416           +77.3%    1346128 ±  5%  numa-vmstat.node1.nr_zone_active_anon
  39956864           -69.8%   12074832        numa-vmstat.node1.numa_hit
  39928526           -69.8%   12046399        numa-vmstat.node1.numa_local
    864376 ±  2%     +70.9%    1477619 ±  4%  proc-vmstat.nr_active_anon
   1548993           +39.5%    2160639 ±  2%  proc-vmstat.nr_file_pages
     20833 ±  4%     -13.3%      18053        proc-vmstat.nr_kernel_stack
    662567 ±  3%     +92.2%    1273751 ±  4%  proc-vmstat.nr_shmem
     25257            +5.4%      26612        proc-vmstat.nr_slab_reclaimable
     39934            -2.0%      39117        proc-vmstat.nr_slab_unreclaimable
    864376 ±  2%     +70.9%    1477619 ±  4%  proc-vmstat.nr_zone_active_anon
  79370391           -71.8%   22353303        proc-vmstat.numa_hit
  79302151           -71.9%   22286522        proc-vmstat.numa_local
  79421517           -71.7%   22442809        proc-vmstat.pgalloc_normal
  78319468           -73.9%   20462058        proc-vmstat.pgfree
    972592 ± 20%    +929.6%   10013851        proc-vmstat.unevictable_pgs_culled
      0.12 ±  4%    +122.5%       0.26 ±  4%  perf-stat.i.MPKI
 3.474e+10           -59.3%  1.414e+10        perf-stat.i.branch-instructions
      0.43 ±  3%      +0.7        1.12        perf-stat.i.branch-miss-rate%
     24.83 ±  6%     -21.2        3.63 ±  4%  perf-stat.i.cache-miss-rate%
  70477298 ±  2%    +792.2%  6.288e+08        perf-stat.i.cache-references
  17963329           -58.5%    7448154        perf-stat.i.context-switches
      1.16          +135.1%       2.73        perf-stat.i.cpi
 1.944e+11            -6.7%  1.815e+11        perf-stat.i.cpu-cycles
      1246 ± 19%  +1.7e+05%    2094266        perf-stat.i.cpu-migrations
     14301 ±  6%     +16.9%      16715 ±  5%  perf-stat.i.cycles-between-cache-misses
 1.693e+11           -58.8%  6.966e+10        perf-stat.i.instructions
      0.87           -55.7%       0.39        perf-stat.i.ipc
    280.67           -46.9%     149.09        perf-stat.i.metric.K/sec
     24.90 ±  6%     -22.4        2.48 ± 45%  perf-stat.overall.cache-miss-rate%
     11120 ±  5%     -27.1%       8107 ± 45%  perf-stat.overall.cycles-between-cache-misses
      0.87           -63.3%       0.32 ± 44%  perf-stat.overall.ipc
 3.418e+10           -66.1%  1.159e+10 ± 44%  perf-stat.ps.branch-instructions
  17668913           -65.4%    6110419 ± 44%  perf-stat.ps.context-switches
 1.913e+11           -22.2%  1.489e+11 ± 44%  perf-stat.ps.cpu-cycles
 1.665e+11           -65.7%  5.711e+10 ± 44%  perf-stat.ps.instructions
 1.029e+13           -65.5%  3.545e+12 ± 44%  perf-stat.total.instructions
   1787180           -41.7%    1041056        sched_debug.cfs_rq:/.avg_vruntime.avg
   2137145 ± 11%     -27.0%    1560362 ±  5%  sched_debug.cfs_rq:/.avg_vruntime.max
   1672842           -42.0%     969875        sched_debug.cfs_rq:/.avg_vruntime.min
     79981 ± 43%     +53.0%     122362 ±  8%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      1.06           -24.9%       0.80 ± 11%  sched_debug.cfs_rq:/.h_nr_queued.avg
      0.47 ±  5%     +62.1%       0.76 ± 10%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.96 ±  2%     -24.2%       0.73 ± 11%  sched_debug.cfs_rq:/.h_nr_runnable.avg
      0.50 ±  2%     +43.1%       0.71 ±  9%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
     14603 ±148%    +796.4%     130912 ± 37%  sched_debug.cfs_rq:/.left_deadline.avg
     93945 ±142%    +263.1%     341139 ± 16%  sched_debug.cfs_rq:/.left_deadline.stddev
     14603 ±148%    +796.4%     130900 ± 37%  sched_debug.cfs_rq:/.left_vruntime.avg
     93943 ±142%    +263.1%     341108 ± 16%  sched_debug.cfs_rq:/.left_vruntime.stddev
   1787181           -41.7%    1041056        sched_debug.cfs_rq:/.min_vruntime.avg
   2137145 ± 11%     -27.0%    1560362 ±  5%  sched_debug.cfs_rq:/.min_vruntime.max
   1672842           -42.0%     969875        sched_debug.cfs_rq:/.min_vruntime.min
     79982 ± 43%     +53.0%     122362 ±  8%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.63 ±  3%     -19.3%       0.51 ±  6%  sched_debug.cfs_rq:/.nr_queued.avg
      0.27 ± 21%     +58.4%       0.44 ±  3%  sched_debug.cfs_rq:/.nr_queued.stddev
     14605 ±148%    +796.3%     130900 ± 37%  sched_debug.cfs_rq:/.right_vruntime.avg
     93955 ±142%    +263.1%     341108 ± 16%  sched_debug.cfs_rq:/.right_vruntime.stddev
      1056           -30.4%     735.47        sched_debug.cfs_rq:/.runnable_avg.avg
    245.58 ±  4%     +30.9%     321.46 ±  9%  sched_debug.cfs_rq:/.runnable_avg.stddev
    720.85           -20.3%     574.43        sched_debug.cfs_rq:/.util_avg.avg
    451.35 ±  5%     -71.5%     128.54 ± 18%  sched_debug.cfs_rq:/.util_est.avg
      6.49 ±  9%     -52.5%       3.09 ± 17%  sched_debug.cpu.clock.stddev
      2287 ±  6%     -41.1%       1346 ±  6%  sched_debug.cpu.curr->pid.avg
      4865 ±  6%     -26.8%       3562        sched_debug.cpu.curr->pid.max
    564.58 ± 85%    -100.0%       0.00        sched_debug.cpu.curr->pid.min
      1.01 ±  3%     -24.6%       0.76 ±  9%  sched_debug.cpu.nr_running.avg
      0.50          -100.0%       0.00        sched_debug.cpu.nr_running.min
      0.49 ±  6%     +62.4%       0.80 ± 10%  sched_debug.cpu.nr_running.stddev
   8411444           -58.4%    3500082        sched_debug.cpu.nr_switches.avg
   8973253           -58.0%    3772244        sched_debug.cpu.nr_switches.max
   5603541 ± 11%     -59.2%    2283992 ± 10%  sched_debug.cpu.nr_switches.min
    588658 ± 16%     -49.1%     299454 ±  6%  sched_debug.cpu.nr_switches.stddev
      1.18 ± 94%     -96.6%       0.04 ±133%  perf-sched.sch_delay.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_mpol_noprof.shmem_alloc_folio
      0.00 ±223%   +4037.5%       0.11 ± 47%  perf-sched.sch_delay.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof.__filemap_get_folio
      0.00 ±100%   +3547.1%       0.10 ± 30%  perf-sched.sch_delay.avg.ms.__cond_resched.__filemap_get_folio.simple_write_begin.generic_perform_write.generic_file_write_iter
     27.00 ± 16%     -99.7%       0.09 ± 13%  perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.01 ± 19%     +86.8%       0.01 ± 27%  perf-sched.sch_delay.avg.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      0.01 ± 80%    +292.3%       0.03 ± 31%  perf-sched.sch_delay.avg.ms.__cond_resched.down_read.unmap_mapping_range.simple_setattr.notify_change
      0.00 ± 64%    +552.0%       0.03 ±  9%  perf-sched.sch_delay.avg.ms.__cond_resched.down_read.unmap_mapping_range.truncate_pagecache.simple_setattr
      0.00 ± 44%    +628.0%       0.03 ±  4%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write.do_truncate.do_open.path_openat
      0.00 ±223%    +742.9%       0.01 ± 54%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.madvise_lock.do_madvise.io_madvise
      0.01 ± 44%    +215.9%       0.02 ±  4%  perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_openat.do_filp_open.do_sys_openat2
      0.01 ±123%    +834.1%       0.06 ± 61%  perf-sched.sch_delay.avg.ms.__cond_resched.dput.path_put.vfs_statx.do_statx
      0.01 ± 47%    +178.7%       0.02 ± 12%  perf-sched.sch_delay.avg.ms.__cond_resched.dput.terminate_walk.path_openat.do_filp_open
      0.01 ±118%    +673.7%       0.05 ± 69%  perf-sched.sch_delay.avg.ms.__cond_resched.filemap_read.__io_read.io_read.__io_issue_sqe
      0.01 ± 31%    +450.0%       0.04 ± 25%  perf-sched.sch_delay.avg.ms.__cond_resched.generic_perform_write.generic_file_write_iter.io_write.__io_issue_sqe
      1.20 ±119%     -95.7%       0.05 ± 14%  perf-sched.sch_delay.avg.ms.__cond_resched.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
      0.01 ± 52%    +190.5%       0.03 ± 28%  perf-sched.sch_delay.avg.ms.__cond_resched.io_assign_current_work.io_worker_handle_work.io_wq_worker.ret_from_fork
      0.01 ±100%    +605.7%       0.04 ± 30%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.getname_flags.part.0
      0.00 ±112%   +2655.6%       0.08 ±  5%  perf-sched.sch_delay.avg.ms.__cond_resched.mutex_lock.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.02 ±129%     -95.5%       0.05 ± 44%  perf-sched.sch_delay.avg.ms.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_write_begin
      0.01 ±141%    +365.8%       0.03 ± 81%  perf-sched.sch_delay.avg.ms.__cond_resched.task_work_run.io_run_task_work.io_assign_current_work.io_worker_handle_work
      0.01          +366.7%       0.03 ± 50%  perf-sched.sch_delay.avg.ms.__cond_resched.task_work_run.io_run_task_work.io_wq_worker.ret_from_fork
     40.44 ±105%    +269.9%     149.60 ±  4%  perf-sched.sch_delay.avg.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      0.15 ±108%  +53293.0%      78.49 ± 72%  perf-sched.sch_delay.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.05 ±  4%     -21.0%       0.04 ±  4%  perf-sched.sch_delay.avg.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      7.24 ± 65%     -99.5%       0.04 ± 19%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.02 ± 63%   +1334.1%       0.33 ± 91%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown].[unknown]
      0.01 ± 21%  +1.6e+05%      14.48 ± 35%  perf-sched.sch_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     32.80 ±188%     -99.7%       0.09 ±178%  perf-sched.sch_delay.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_mpol_noprof.shmem_alloc_folio
      0.00 ±223%  +53712.5%       1.44 ± 44%  perf-sched.sch_delay.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof.__filemap_get_folio
      0.00 ±100%  +49247.1%       1.40 ± 35%  perf-sched.sch_delay.max.ms.__cond_resched.__filemap_get_folio.simple_write_begin.generic_perform_write.generic_file_write_iter
      1008           -99.7%       2.97 ± 17%  perf-sched.sch_delay.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.01 ± 47%    +195.2%       0.03 ± 22%  perf-sched.sch_delay.max.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      0.01 ± 76%   +9143.4%       0.82 ± 29%  perf-sched.sch_delay.max.ms.__cond_resched.down_read.unmap_mapping_range.simple_setattr.notify_change
      0.01 ± 49%  +16130.6%       1.95 ± 16%  perf-sched.sch_delay.max.ms.__cond_resched.down_read.unmap_mapping_range.truncate_pagecache.simple_setattr
      0.01 ± 49%  +22462.1%       2.18 ± 20%  perf-sched.sch_delay.max.ms.__cond_resched.down_write.do_truncate.do_open.path_openat
      0.00 ±223%   +1457.1%       0.02 ± 50%  perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.madvise_lock.do_madvise.io_madvise
      0.02 ± 33%  +12476.3%       2.03 ± 16%  perf-sched.sch_delay.max.ms.__cond_resched.dput.path_openat.do_filp_open.do_sys_openat2
      0.01 ±123%  +10129.3%       0.70 ± 40%  perf-sched.sch_delay.max.ms.__cond_resched.dput.path_put.vfs_statx.do_statx
      0.02 ± 90%   +5132.3%       1.16 ± 26%  perf-sched.sch_delay.max.ms.__cond_resched.dput.terminate_walk.path_openat.do_filp_open
      0.01 ±118%  +11405.3%       0.73 ± 72%  perf-sched.sch_delay.max.ms.__cond_resched.filemap_read.__io_read.io_read.__io_issue_sqe
      0.02 ± 50%  +1.6e+05%      29.32 ±196%  perf-sched.sch_delay.max.ms.__cond_resched.generic_perform_write.generic_file_write_iter.io_write.__io_issue_sqe
     32.67 ±185%     -98.4%       0.51 ± 17%  perf-sched.sch_delay.max.ms.__cond_resched.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
      0.02 ± 50%   +8362.9%       1.37 ± 35%  perf-sched.sch_delay.max.ms.__cond_resched.io_assign_current_work.io_worker_handle_work.io_wq_worker.ret_from_fork
      0.01 ± 90%  +23617.9%       1.54 ± 46%  perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.getname_flags.part.0
      0.03 ± 82%   +7512.2%       2.08 ± 24%  perf-sched.sch_delay.max.ms.__cond_resched.mnt_want_write.do_open.path_openat.do_filp_open
      0.00 ±136%  +64728.0%       2.70 ± 19%  perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.01 ±223%   +1664.3%       0.16 ±130%  perf-sched.sch_delay.max.ms.__cond_resched.mutex_lock.perf_event_ctx_lock_nested.constprop.0
      8.17 ± 81%     -96.0%       0.32 ± 60%  perf-sched.sch_delay.max.ms.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_write_begin
      0.01 ±141%   +4228.9%       0.27 ± 79%  perf-sched.sch_delay.max.ms.__cond_resched.task_work_run.io_run_task_work.io_assign_current_work.io_worker_handle_work
      0.01 ± 62%   +2404.7%       0.35 ± 68%  perf-sched.sch_delay.max.ms.__cond_resched.task_work_run.io_run_task_work.io_cqring_wait.__do_sys_io_uring_enter
      0.02 ± 27%   +4392.5%       0.79 ± 89%  perf-sched.sch_delay.max.ms.__cond_resched.task_work_run.io_run_task_work.io_wq_worker.ret_from_fork
      1.38 ± 93%  +1.1e+05%       1509 ± 33%  perf-sched.sch_delay.max.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
    617.37 ±  4%     -99.0%       5.93 ± 13%  perf-sched.sch_delay.max.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
    553.05 ±119%     -99.8%       0.91 ± 27%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
    482.04 ± 17%    +245.8%       1666 ± 10%  perf-sched.sch_delay.max.ms.schedule_timeout.io_wq_worker.ret_from_fork.ret_from_fork_asm
      0.01 ± 12%  +1.4e+07%       1259 ± 82%  perf-sched.sch_delay.max.ms.schedule_timeout.kcompactd.kthread.ret_from_fork
      0.18 ±193%  +1.1e+06%       1993 ± 22%  perf-sched.sch_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.15 ±  4%     +37.0%       0.21 ±  3%  perf-sched.total_wait_and_delay.average.ms
   6073366 ±  3%     +44.4%    8769521 ±  4%  perf-sched.total_wait_and_delay.count.ms
      0.10 ±  4%     +56.1%       0.16 ±  3%  perf-sched.total_wait_time.average.ms
      2.35 ± 94%     -97.8%       0.05 ±223%  perf-sched.wait_and_delay.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_mpol_noprof.shmem_alloc_folio
     61.72 ±  9%     -69.8%      18.65 ±  2%  perf-sched.wait_and_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      2.40 ±119%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.__cond_resched.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
      2.04 ±129%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_write_begin
    122.24 ±144%    +434.7%     653.59 ± 25%  perf-sched.wait_and_delay.avg.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    191.02 ± 60%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.do_task_dead.do_exit.io_wq_worker.ret_from_fork.ret_from_fork_asm
     14.30 ±145%   +1435.6%     219.62 ± 43%  perf-sched.wait_and_delay.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
     13.13 ± 63%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.02 ±165%   +2984.6%       0.63 ± 51%  perf-sched.wait_and_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown].[unknown]
     69.14 ±218%    +527.5%     433.90 ± 40%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
      0.10 ±  6%     +66.6%       0.17 ±  5%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.io_wq_worker.ret_from_fork.ret_from_fork_asm
     95.80 ± 54%     -74.5%      24.39 ± 15%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    944.93 ±  6%     -24.3%     714.89 ±  6%  perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    194.33 ± 89%     -99.7%       0.50 ±223%  perf-sched.wait_and_delay.count.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_mpol_noprof.shmem_alloc_folio
    111.83 ±  5%     +93.7%     216.67        perf-sched.wait_and_delay.count.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      2487 ± 89%    -100.0%       0.00        perf-sched.wait_and_delay.count.__cond_resched.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
    815.00 ± 88%    -100.0%       0.00        perf-sched.wait_and_delay.count.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_write_begin
      1.33 ±103%    +462.5%       7.50 ± 41%  perf-sched.wait_and_delay.count.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     26.83 ± 53%    -100.0%       0.00        perf-sched.wait_and_delay.count.do_task_dead.do_exit.io_wq_worker.ret_from_fork.ret_from_fork_asm
     23.83 ± 44%     +99.3%      47.50 ± 11%  perf-sched.wait_and_delay.count.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
   3025657 ±  3%     +33.1%    4026781 ±  4%  perf-sched.wait_and_delay.count.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.33 ±111%    +575.0%       9.00 ± 42%  perf-sched.wait_and_delay.count.irq_thread.kthread.ret_from_fork.ret_from_fork_asm
    464.50 ± 55%    -100.0%       0.00        perf-sched.wait_and_delay.count.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      2.17 ± 72%    +207.7%       6.67 ± 34%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      6.00 ± 28%    +152.8%      15.17 ± 12%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
     22.33 ± 40%     +70.9%      38.17 ± 11%  perf-sched.wait_and_delay.count.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
   3027666 ±  3%     +55.0%    4691741 ±  4%  perf-sched.wait_and_delay.count.schedule_timeout.io_wq_worker.ret_from_fork.ret_from_fork_asm
      1.83 ±149%    +418.2%       9.50 ± 21%  perf-sched.wait_and_delay.count.schedule_timeout.kcompactd.kthread.ret_from_fork
     65.33 ± 49%    +354.1%     296.67 ± 15%  perf-sched.wait_and_delay.count.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    167.50 ±  9%    +128.4%     382.50 ±  4%  perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     96.33 ± 18%    +156.1%     246.67 ±  9%  perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
     65.61 ±188%     -99.8%       0.15 ±223%  perf-sched.wait_and_delay.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_mpol_noprof.shmem_alloc_folio
      2017           -50.3%       1002        perf-sched.wait_and_delay.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
     65.35 ±185%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.__cond_resched.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
     16.34 ± 81%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_write_begin
    295.13 ±140%    +815.6%       2702 ± 34%  perf-sched.wait_and_delay.max.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      3209 ± 21%     +51.6%       4864 ±  7%  perf-sched.wait_and_delay.max.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      1364 ± 27%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.do_task_dead.do_exit.io_wq_worker.ret_from_fork.ret_from_fork_asm
    338.27 ±140%    +741.9%       2848 ± 24%  perf-sched.wait_and_delay.max.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1234 ±  4%     -99.0%      12.00 ± 13%  perf-sched.wait_and_delay.max.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
    771.53 ± 78%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      1407 ± 31%    +143.7%       3430 ±  8%  perf-sched.wait_and_delay.max.ms.schedule_timeout.io_wq_worker.ret_from_fork.ret_from_fork_asm
      1.18 ± 94%     -96.6%       0.04 ±133%  perf-sched.wait_time.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_mpol_noprof.shmem_alloc_folio
      0.00 ±223%   +6081.2%       0.16 ± 34%  perf-sched.wait_time.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof.__filemap_get_folio
      0.00 ±100%  +31470.6%       0.89 ±114%  perf-sched.wait_time.avg.ms.__cond_resched.__filemap_get_folio.simple_write_begin.generic_perform_write.generic_file_write_iter
     34.72 ± 11%     -46.5%      18.56        perf-sched.wait_time.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.01 ± 16%    +532.5%       0.04 ± 86%  perf-sched.wait_time.avg.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      0.01 ± 47%    +304.5%       0.05 ± 20%  perf-sched.wait_time.avg.ms.__cond_resched.down_read.unmap_mapping_range.simple_setattr.notify_change
      0.02 ± 53%    +238.7%       0.05 ± 10%  perf-sched.wait_time.avg.ms.__cond_resched.down_read.unmap_mapping_range.truncate_pagecache.simple_setattr
      0.01 ± 49%    +321.2%       0.06 ±  4%  perf-sched.wait_time.avg.ms.__cond_resched.down_write.do_truncate.do_open.path_openat
      0.00 ±223%   +1271.4%       0.02 ± 39%  perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.madvise_lock.do_madvise.io_madvise
      0.01 ± 26%    +239.2%       0.04 ±  3%  perf-sched.wait_time.avg.ms.__cond_resched.dput.path_openat.do_filp_open.do_sys_openat2
      0.01 ±123%   +1363.4%       0.10 ± 44%  perf-sched.wait_time.avg.ms.__cond_resched.dput.path_put.vfs_statx.do_statx
      0.01 ± 47%    +260.8%       0.04 ±  9%  perf-sched.wait_time.avg.ms.__cond_resched.dput.terminate_walk.path_openat.do_filp_open
      0.01 ±118%  +57350.0%       3.64 ±219%  perf-sched.wait_time.avg.ms.__cond_resched.filemap_read.__io_read.io_read.__io_issue_sqe
      0.02 ± 35%    +803.3%       0.14 ± 59%  perf-sched.wait_time.avg.ms.__cond_resched.generic_perform_write.generic_file_write_iter.io_write.__io_issue_sqe
      1.20 ±119%     -95.7%       0.05 ± 14%  perf-sched.wait_time.avg.ms.__cond_resched.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
      0.01 ± 35%   +1118.6%       0.14 ±148%  perf-sched.wait_time.avg.ms.__cond_resched.io_assign_current_work.io_worker_handle_work.io_wq_worker.ret_from_fork
      0.01 ±134%    +651.9%       0.07 ± 14%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.getname_flags.part.0
      0.02 ± 47%    +143.2%       0.05 ±  6%  perf-sched.wait_time.avg.ms.__cond_resched.mnt_want_write.do_open.path_openat.do_filp_open
      0.01 ± 88%   +1704.4%       0.14 ±  6%  perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00 ±223%   +2385.7%       0.06 ± 27%  perf-sched.wait_time.avg.ms.__cond_resched.mutex_lock.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64
      1.02 ±129%     -95.4%       0.05 ± 45%  perf-sched.wait_time.avg.ms.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_write_begin
    122.24 ±144%    +434.7%     653.57 ± 25%  perf-sched.wait_time.avg.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.01 ±141%    +602.6%       0.04 ± 59%  perf-sched.wait_time.avg.ms.__cond_resched.task_work_run.io_run_task_work.io_assign_current_work.io_worker_handle_work
      0.01 ± 16%    +171.9%       0.04 ± 26%  perf-sched.wait_time.avg.ms.__cond_resched.task_work_run.io_run_task_work.io_cqring_wait.__do_sys_io_uring_enter
      0.01          +469.4%       0.03 ± 45%  perf-sched.wait_time.avg.ms.__cond_resched.task_work_run.io_run_task_work.io_wq_worker.ret_from_fork
    191.02 ± 60%    -100.0%       0.00        perf-sched.wait_time.avg.ms.do_task_dead.do_exit.io_wq_worker.ret_from_fork.ret_from_fork_asm
     14.15 ±146%    +897.1%     141.14 ± 40%  perf-sched.wait_time.avg.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.06 ±  3%     +14.2%       0.07 ±  5%  perf-sched.wait_time.avg.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.89 ± 69%     -98.9%       0.07 ± 15%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.02 ± 61%   +1195.7%       0.30 ± 82%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_reschedule_ipi.[unknown].[unknown]
     74.12 ± 55%     -79.1%      15.47 ± 75%  perf-sched.wait_time.avg.ms.rcu_gp_kthread.kthread.ret_from_fork.ret_from_fork_asm
     68.20 ±221%    +405.4%     344.68 ± 49%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
      0.05 ±  6%    +124.0%       0.12 ±  4%  perf-sched.wait_time.avg.ms.schedule_timeout.io_wq_worker.ret_from_fork.ret_from_fork_asm
     76.92 ± 47%     -78.5%      16.55 ± 14%  perf-sched.wait_time.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
    944.92 ±  6%     -25.9%     700.41 ±  6%  perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     32.80 ±188%     -99.7%       0.09 ±178%  perf-sched.wait_time.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_mpol_noprof.shmem_alloc_folio
      0.00 ±223%  +62862.5%       1.68 ± 34%  perf-sched.wait_time.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.folio_alloc_noprof.__filemap_get_folio
      0.00 ±100%  +1.1e+06%      29.94 ±133%  perf-sched.wait_time.max.ms.__cond_resched.__filemap_get_folio.simple_write_begin.generic_perform_write.generic_file_write_iter
      0.01 ± 46%   +1890.8%       0.22 ±114%  perf-sched.wait_time.max.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      0.01 ± 45%   +5962.8%       0.87 ± 28%  perf-sched.wait_time.max.ms.__cond_resched.down_read.unmap_mapping_range.simple_setattr.notify_change
      0.03 ± 96%   +6620.0%       2.24 ± 24%  perf-sched.wait_time.max.ms.__cond_resched.down_read.unmap_mapping_range.truncate_pagecache.simple_setattr
      0.02 ± 52%  +10464.6%       2.24 ± 19%  perf-sched.wait_time.max.ms.__cond_resched.down_write.do_truncate.do_open.path_openat
      0.00 ±223%   +2071.4%       0.03 ± 45%  perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.madvise_lock.do_madvise.io_madvise
      0.02 ± 45%   +9861.1%       2.39 ± 18%  perf-sched.wait_time.max.ms.__cond_resched.dput.path_openat.do_filp_open.do_sys_openat2
      0.01 ±123%  +13497.6%       0.93 ± 18%  perf-sched.wait_time.max.ms.__cond_resched.dput.path_put.vfs_statx.do_statx
      0.03 ± 70%   +4647.0%       1.31 ± 17%  perf-sched.wait_time.max.ms.__cond_resched.dput.terminate_walk.path_openat.do_filp_open
      0.01 ±118%  +1.9e+06%     118.27 ±222%  perf-sched.wait_time.max.ms.__cond_resched.filemap_read.__io_read.io_read.__io_issue_sqe
      0.03 ± 29%    +1e+06%     288.42 ±112%  perf-sched.wait_time.max.ms.__cond_resched.generic_perform_write.generic_file_write_iter.io_write.__io_issue_sqe
     32.67 ±185%     -98.4%       0.51 ± 17%  perf-sched.wait_time.max.ms.__cond_resched.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
      0.02 ± 36%  +1.2e+05%      21.17 ±206%  perf-sched.wait_time.max.ms.__cond_resched.io_assign_current_work.io_worker_handle_work.io_wq_worker.ret_from_fork
      0.01 ±123%  +17091.1%       1.60 ± 45%  perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.getname_flags.part.0
      0.04 ± 44%   +5521.1%       2.31 ± 15%  perf-sched.wait_time.max.ms.__cond_resched.mnt_want_write.do_open.path_openat.do_filp_open
      0.01 ±105%  +26181.5%       2.85 ± 20%  perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.00 ±223%  +32464.3%       0.76 ± 50%  perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64
      0.01 ±223%   +1664.3%       0.16 ±130%  perf-sched.wait_time.max.ms.__cond_resched.mutex_lock.perf_event_ctx_lock_nested.constprop.0
      8.17 ± 81%     -96.0%       0.32 ± 60%  perf-sched.wait_time.max.ms.__cond_resched.shmem_inode_acct_blocks.shmem_alloc_and_add_folio.shmem_get_folio_gfp.shmem_write_begin
    295.13 ±140%    +815.6%       2702 ± 34%  perf-sched.wait_time.max.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.01 ±141%   +7252.6%       0.47 ± 71%  perf-sched.wait_time.max.ms.__cond_resched.task_work_run.io_run_task_work.io_assign_current_work.io_worker_handle_work
      0.02 ± 45%   +1967.4%       0.49 ± 57%  perf-sched.wait_time.max.ms.__cond_resched.task_work_run.io_run_task_work.io_cqring_wait.__do_sys_io_uring_enter
      0.02 ± 27%   +4912.3%       0.89 ± 80%  perf-sched.wait_time.max.ms.__cond_resched.task_work_run.io_run_task_work.io_wq_worker.ret_from_fork
      1364 ± 27%    -100.0%       0.00        perf-sched.wait_time.max.ms.do_task_dead.do_exit.io_wq_worker.ret_from_fork.ret_from_fork_asm
    337.33 ±140%    +396.4%       1674 ± 28%  perf-sched.wait_time.max.ms.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
    617.37 ±  4%     -98.9%       6.76 ± 17%  perf-sched.wait_time.max.ms.io_cqring_wait.__do_sys_io_uring_enter.do_syscall_64.entry_SYSCALL_64_after_hwframe
    271.31 ± 47%     -99.6%       1.04 ± 28%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
    490.33 ± 40%     -81.3%      91.66 ± 89%  perf-sched.wait_time.max.ms.rcu_gp_kthread.kthread.ret_from_fork.ret_from_fork_asm
      1055 ± 54%    +105.4%       2167 ± 19%  perf-sched.wait_time.max.ms.schedule_timeout.io_wq_worker.ret_from_fork.ret_from_fork_asm
    769.83 ± 20%     -47.4%     404.66 ± 16%  perf-sched.wait_time.max.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      4663           -16.1%       3911 ±  9%  perf-sched.wait_time.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


