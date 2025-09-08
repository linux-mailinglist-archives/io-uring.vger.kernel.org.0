Return-Path: <io-uring+bounces-9657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C82AAB49AC0
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 22:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32A0D188EEF6
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 20:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303902D8365;
	Mon,  8 Sep 2025 20:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NHhHmtFZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAB62D7DE9;
	Mon,  8 Sep 2025 20:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757362270; cv=fail; b=Tre57/DEVHTu2N7GkWlY46BZ3crH5HmesBuW/JE11KNHk6SdXPJwPv5jlEix+p/4ckXzQX9eSiO7PNzUUlJYjWj3/NoeOdxsCqweQOi+aS5nSph+rvuMSNsuIM3UU+ix6OskFISPzNApd8VA1huLx6NhT0B4fiZYuIjcXtU9GR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757362270; c=relaxed/simple;
	bh=iaq2i3MoYsErlJKfvaEUXZiR2BfdfrndM6PnOrtbcjE=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=egoLkAzUs5tIa7/IIAUvRAS6DAnn4sZXYu1KKKCdWE7GjrLneYunLm1aWgPhRc18Ewke+5Jk0dCmJwvAeOepAdqHZ6IBxFUwGkC362NLTQxwm2mr9C+1/ASCYoi8jhdp5f9QyYhtMK14ZW8+npiIPluFdxQBrXDG6u+Pz1hdErs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NHhHmtFZ; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757362269; x=1788898269;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=iaq2i3MoYsErlJKfvaEUXZiR2BfdfrndM6PnOrtbcjE=;
  b=NHhHmtFZUGrSSyDWr1RktUWUS/LOYxBvZ5ZGgaEdjSuI1MeyAE/39zNm
   wXokgRu8poyefmbBJQDbeJViqD8qsVTXIweXVaRiSgsSE5WTXE3XcX9eD
   WH9E2onmODuUCtmCSh6U7VNR0H1Qt2u+F7OLuX5iKSdGaLzDZlCn9rRK8
   reP/CkKyhE0iGmTTtqmznsEGG62T6ma3rpqOo+yNQqQxrztmCldW+c22e
   7VTAuRgCD4Hcqrzl0b0ZdgmasdvpYf12CsnApblLr4bgAtv3zXX+YPAys
   z8Ab5+qXSdmWfEy4oVguhZ0hWHag6KyJ2+mlLlC9T3+ux1e5/5rGfiz4+
   Q==;
X-CSE-ConnectionGUID: XVwvyhGtSkGRsLpNQZr8oQ==
X-CSE-MsgGUID: EjXarNhDTOyDWM7znTKA7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59583893"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59583893"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 13:11:08 -0700
X-CSE-ConnectionGUID: 8Cn1lABGTYSmGFxykDf4gg==
X-CSE-MsgGUID: RAumEZlKSyaICprsmyopZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,249,1751266800"; 
   d="scan'208";a="172146817"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 13:11:08 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 8 Sep 2025 13:11:07 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 8 Sep 2025 13:11:07 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.40)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 8 Sep 2025 13:11:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NV4JsTTK5L6Nd5qhEcjM1Ncxaw0JoYM9P4jA8laK18MOw0uDMNe76Vf840RBU20I3H1m1haHz/UosqWt0v6YzCT37BqtWhVE27y1GFa4CuoWnm4SW/XDS5H1NzT9NF8UhJST5p5Ix9kWz0M8wVI9EUPGc8tp24CAzUe5KPPIjt1C7RvMHuz8kWso5sZT4I0e8WC+uw2kA/BHYoAlP2MOkM71icb+DuvTteS0lSGGHMDwrROPPqkml6OPjtTYTpILL0j7YXZKAocjCv5Yxqyw8ZBVH47k8yvm5G3uJh4nfrKPcDNTOG95xxIdte6mV3q5/KfkdWrA+U5HCD/OIAW81g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=guZE03T+pem0HKh0keWyPqsThox95SRtoRWE5I+nmPs=;
 b=av6rzgmdg5hYqL9OOnxRiZ5pBEtlCmqxtUjwKPeLspvONRtzbYigYT2MIfQmkoKoYFyMyzY/pDMBafeHKwR96hyO1jEd84Ji1RyHGxne8NsRQhSG2USYsL83Rzvlcjd8Y43IOGOyRzrGnnvMM+YQGKrrf60ZslmOY0C613kTTDsLazulaZzjdk0ge/pfZRmP6UJvBWzvAceH6uPqy4kRirSN/HYq73Tojg/RJBo8cImopsDdQqkkH7fg2zGnDXGAIHyeROD/0lxDdX8LQ/ZuQVL6okji8HHcBKl1bGXZAfFf0YYuAVJwKUFHgYRLklTRJAicc2gdA68YmUHXtpayJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA3PR11MB8118.namprd11.prod.outlook.com (2603:10b6:806:2f1::13)
 by DS0PR11MB7359.namprd11.prod.outlook.com (2603:10b6:8:134::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:11:04 +0000
Received: from SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec]) by SA3PR11MB8118.namprd11.prod.outlook.com
 ([fe80::c4e2:f07:bdaa:21ec%4]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 20:11:04 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 8 Sep 2025 13:11:00 -0700
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
CC: Jens Axboe <axboe@kernel.dk>, Caleb Sander Mateos
	<csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>,
	<workflows@vger.kernel.org>
Message-ID: <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
In-Reply-To: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
 <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0262.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::27) To SA3PR11MB8118.namprd11.prod.outlook.com
 (2603:10b6:806:2f1::13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB8118:EE_|DS0PR11MB7359:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cbe5f91-20c5-4b61-df2d-08ddef13d678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bXY2QUh3WVBrZDVYUWpZNFE5L3V2QndTTnpzeUZKZmN4S0ZLYnJ0WHJDUTNR?=
 =?utf-8?B?SjlDU0l2dmJ3VmNoWFlpdjFLQnBjbGFoRzU4R0c4TWNmRUdFZjQrTkF0Zm4w?=
 =?utf-8?B?VEdYY1FoaG80RS9yNmk2Nlk1V013MnU1NldEWXNuR3d6enlDOFFobDFrYkdl?=
 =?utf-8?B?N3E3dkFIVVZDdzYyRzVKajVwL3V4SUhabHRRTldxVmR1T2xrVXB5ZWdkclF5?=
 =?utf-8?B?REFlZEVOQ0lhaEFwSEFjYS9mQVlKUXMwYlNZQWowenBzQjdFMlphT0FtQXBV?=
 =?utf-8?B?RjNpYWNVZ0Vta0VoWnE5V0lnY0xhT1BhZUE0MTlkdTc1RXZCTDRlMDM0YU9j?=
 =?utf-8?B?OTFmWjkvck9BVk0wZ1Vzd04wdU5zSjg0elZmUFp3SFlqUjRjR0dVTXNhcUR3?=
 =?utf-8?B?UWltMnpaeHBuLzdOanExVCtaT2pwd1pHTjI5aTBCOHlhdFh4MGZnd3RJLzZ0?=
 =?utf-8?B?YjgzcjFHaEM4ZXQwd1Jpb2lZbjk2OTI1YjZaUnBLL0hiVjl5Q01EeFEvYUpE?=
 =?utf-8?B?dEtTWWVPb2VVWTlYOUVFWHN4K2dhNGZheVhjRWN2UXVPaHdycDFpdk0yU2Zx?=
 =?utf-8?B?aXViYWJkcW0yQXNHMyszT2xDM3dEWnZMbVhONHh0c1VXdHZ1ZHpwUm04R0la?=
 =?utf-8?B?NnZGL1A2TkZ2M2VJMU9RK0R6VEl3V1V3eUxoNWl0eEJvak85d1JkQnVqamRJ?=
 =?utf-8?B?SjZCeGUrNHlXN1Y3Vm5RcUwxbG9Gc2V0OHJnZThKd3ZKNHJqWS9uQkpaWU5J?=
 =?utf-8?B?cDBpbElBZjNYQlg4R2Z4ZG0zT1VHL1laNnpFUXJkei9ILzFJdHg3MzI4aWgz?=
 =?utf-8?B?L05LU0RldDdNaEhld2wyaFArRHRUeTl1RHBxeDFUbHFXbDV1L2dqaEV0UWpJ?=
 =?utf-8?B?cDRKVkQrUFplVEtEbXdFVXJtSy9KK3N4YXNodGVNQ1ZlMXUyUndodml1WGl6?=
 =?utf-8?B?UWdmbktDbTVDYW4xcjVIS0x4bE94MkNqakVCeGhrRTZQTUtPNEJKVlMzbThy?=
 =?utf-8?B?TG9JUnJHY2lyRjVkL1Z5K2FsNmFQZXl5K0g3WG5VWjZ0YkkyU242WENRMEgy?=
 =?utf-8?B?V0NsdFRwUFpnVmFQZElBcDdDMUxmWUx5ZWtHT1VMb2JPRmsvcXlhYnJxSFNv?=
 =?utf-8?B?N05pTXZpVkVoT2lNZisvSnZwTVBGbFZaQjhkOEJjeDdKTFpCRkE1dmd0S01J?=
 =?utf-8?B?ZElFemRQb0hsdnZrOFVoWCtlTUdweE1kSkJJSDU5WWpYb3M0TUN0d050UnpK?=
 =?utf-8?B?ZkplUjVzS1VZZ2VrdGk3U1pEWjZZNVcwUkR6a1BJTmQxcWZGUmsyN2J5S1NH?=
 =?utf-8?B?dHh5am8yd3dNQ3Z6VHA1MXJJenJ5bWRVTTlGelRMWlo0bUZDTWpPZ0x3V1RS?=
 =?utf-8?B?bEZsTlJ5aWdmTG9rQi9TeFpkbjdSWlFmWlpweEtpNVMvODVmMHY1d3FFRXlo?=
 =?utf-8?B?RzYxQTNOVkl2WDZVeUNHS0lQRlBqbG94MGZvNENHWUtSK01UTytncmJqVWk1?=
 =?utf-8?B?aHNXR1lUeHVrMTZWdmRDRVdINmF1aE5kcWFpMWJyNDZCRXFWZXJWWk4zYkRX?=
 =?utf-8?B?SVJMY2RvelpobEdmWUd1MFhYTWp4TlV2clU2K3h2NXJzeDBoMkRSVGk2aWdB?=
 =?utf-8?B?U3VpY21DTjhSVmtJaXBWVTkzU0RMekZidXZxQ28yeU03UjA4VXc3R3BVUVk3?=
 =?utf-8?B?RU0yWEtUT3UrWFFWSkFhZHVMWnQxeFZtOFE5cEU4bkRndnRpOGJRNThITjht?=
 =?utf-8?B?OC9BZ3dxZnk2bG5GNVVCMmJsM2h6U3V0cndGMnBJd1hnTDRDaVhNMjhZdVhn?=
 =?utf-8?B?OFN6QU5EejRnbktsTTVjV3Npc1M4UnZXQkw4clVjd2pOeWh5ajN5RS9haTg5?=
 =?utf-8?B?QWZoMk1hUTNONE1uUittYzZnOHNLaWRRTllqd1lRYk96dVdEVEVNOW96bU9E?=
 =?utf-8?Q?CXw7bTR9Xds=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB8118.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTVsKy8rMDVXRGNpMElhVHZ2YnhVTlZ2OXoxZW1VbFR0K0R3NG9ET3cydjlO?=
 =?utf-8?B?dWk5U0lmenRndXN6MlI5WnQyTlFuN01wU1lDQ1NlOWxBbnN2THRVRnYwR1Mx?=
 =?utf-8?B?VTY3MnNRQ0RaTlEzd2pnS3o3UnpCRnErUHhHNVU2MHFhSEFnMnBCcVUzUUM0?=
 =?utf-8?B?ejk1SENrUHRKRHlycUNweVFNWCtsdnBkbTBsRFJ1RGVtN0l2OXh4MGFMQzVn?=
 =?utf-8?B?a0FpQ0kzMWhSWGV4MmlCcWlaeUh5MENZcWhUOENObFRHMzMvanVadjVCWXpL?=
 =?utf-8?B?QXFQWnR3MHZBdE5NTk9pRUZFWHRBRXp1QXd3bisxd0hpeEpaOG9MWXl6ZEpz?=
 =?utf-8?B?ME9JSktjWEtxTXlPQVgybGswc3J5UVM1MHJmcTVkZDUxT3hXOTN0MXpHYXZs?=
 =?utf-8?B?bU9vMWwvTVRxV0pxdlZ0RnJ0Rlp5L0huQU5CdmZIMU1tYnFnNktwakdzOExM?=
 =?utf-8?B?MzZDMldDa25YRGpveWZ4RWdpRXdXWFpPNFNZRVNEMFZ2TmxCTTZVYWh5ck9M?=
 =?utf-8?B?UXh4S2ZlVndmTUxxYTU4OWFOTUE4WWpXY2NFSjZ5VjlmZzlPU0trV21qaGpL?=
 =?utf-8?B?bko5Y0lyd3FmRWNRWkpZVUN2eGVOakVObWYvczFRaUE0SEJTcC9nbnlsaWhB?=
 =?utf-8?B?ZmYyTkJwbCtYVmlYbXpMYzlTeW9KT1l4SERyZUl3Q0xoTzRocXdHTElqNVRu?=
 =?utf-8?B?empmcTFiM2dJdkQ0bUNnbGpQT3crbU9LUHRTS0NUNW1Vazg4MEx1MlFYa1c5?=
 =?utf-8?B?YjBYMFFmUDV6Z3dkOThlbUhIcXRMRTdOZXhGaEhFb00ybjVDTGw2SEIxWWpS?=
 =?utf-8?B?OFJ4Q0tPM2RveXBzOE9VVzVQVDVCZVBWZDM3VW82YW01TGJRZW9weW03RmZ1?=
 =?utf-8?B?K1lxNjRZWWwvTEdkYmY3LzVmSDJZMHI3R2gvUmthNjlmQU1BUjVKN0lGcmV2?=
 =?utf-8?B?aDZkVER3aWZxeVA3TStOVUpWa0dCcjMvYTQyaFBKb0hRdlBtVFgycGJJeExu?=
 =?utf-8?B?QmtJYTBVL1BZVFBueGdmRDViWk9rR3VjYndvVzhGcWlCUVcvNkl4ZmlnOVdJ?=
 =?utf-8?B?VFh3dWR3WVQ1d0JWOGEzbHFnd0ZxZlJwRFA3MWpHUmk2eldyMkZkR054TXdo?=
 =?utf-8?B?VkdSNWFoQUdXWmk5dk90T0RrNTRpTm1EMzl3NzRoa3pxdTNTNUI2ZVlyTmtp?=
 =?utf-8?B?clQyQXJXU0ZVZ0lsUHc4Ry9nMWFpa3dRK2RLeFNYbTdwMmJicUkzT2ZBTzNw?=
 =?utf-8?B?RXUzRlZIdVVHOURoa1MzT3dkTkJQQTkrV1Yvb0JBMXRtb2JxamQ3UnJxN3kv?=
 =?utf-8?B?Qk5oME9nb1U5dGJkOU5UbVQ0SXN4Mk14Qmt6YWhCVFRHTkhxN0tTdW9CcDBy?=
 =?utf-8?B?TmRaay9ybzBscU1jcGpQYTl1bW5MRzdvbTlLUVdQMWh3NmFOU09ERFNTS1c0?=
 =?utf-8?B?TjJEcHFnVzhwSktMS1FCUkhaK0ZRa1VRaG15MmQyL0dwN1FKakFqTTgzVlF5?=
 =?utf-8?B?YUJEQWJoK1o1MVZVRWJGblhRN01obTdxTENwTWNkQnlRSEtNTHRZZGduYkgw?=
 =?utf-8?B?Y2xDZnlWcUwwcDhFRTVSZkVxNEJ1VFJ3dGNkK3lFRWFoUU1laUVET3lNNVE1?=
 =?utf-8?B?b2x5cTVDcjc3YmxKSjBnTFNDL2xWb2ZaQUh1d0liWnByRERqakZwTmQ0M2Iw?=
 =?utf-8?B?UDNCdjB0L1F4dm9uV0JPQVl3cFkyNmxYTDMvWjA2L3FYcXJqY1ZZVHBoRTdF?=
 =?utf-8?B?NHhQZGpNV0hoN1NHOXViU3pNbktSSldXUmpvNVJqb3lFWEYzUG1CY0p1b1Vx?=
 =?utf-8?B?VXM5Z0JXVTJGWTlUT09UZHBLOEowODVPenVGVTNhKzZHOGFhUXRCNXUyWlhl?=
 =?utf-8?B?MUhlenpVZHltUHdTUTBhSkhvL09YQklEUXRFcmxzanZBdGlpRE5ETmxGWHJZ?=
 =?utf-8?B?YmtROStLQS9KeUlPSWsvek1yeEVqR1ZYa0p5VGpjL0lLYzRlSUxrOUFkQTFo?=
 =?utf-8?B?OUpxS2ZrS3lHSFl5Z2E2TlhnZENJZ0Fqbm5GcUIxcFBUeGtXQUFXQWxFaGRQ?=
 =?utf-8?B?M2l6SmNOZVZ0QUk2bEt2eXIvTmxzRmtlc1ZHay90S0FPL3VvM3ZvcXRRamRG?=
 =?utf-8?B?SlExcEE3eG1iZzNqeG9GdXJIQnFrMGU0N3BaRDI5T3NaRHNTUzE3NVRMVEFr?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbe5f91-20c5-4b61-df2d-08ddef13d678
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB8118.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:11:04.0257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqtTu97M9jQBSSx8xXFmymbRNSqmbVM6bFhn/wKf1BUNvnJ/vohGPVYHYBQRfPvZOakHfEXY+PEURLjcfWzODry9LcixVZkePjyHyc2SD/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7359
X-OriginatorOrg: intel.com

Konstantin Ryabitsev wrote:
> (Changing the subject and aiming this at workflows.)
> 
> On Fri, Sep 05, 2025 at 11:06:01AM -0700, Linus Torvalds wrote:
> > On Fri, 5 Sept 2025 at 10:45, Konstantin Ryabitsev
> > <konstantin@linuxfoundation.org> wrote:
> > >
> > > Do you just want this to become a no-op, or will it be better if it's used
> > > only with the patch.msgid.link domain namespace to clearly indicate that it's
> > > just a provenance link?
> > 
> > So I wish it at least had some way to discourage the normal mindless
> > use - and in a perfect world that there was some more useful model for
> > adding links automatically.
> > 
> > For example, I feel like for the cover letter of a multi-commit
> > series, the link to the patch series submission is potentially more
> > useful - and likely much less annoying - because it would go into the
> > merge message, not individual commits.
> 
> We do support this usage using `b4 shazam -M` -- it's the functional
> equivalent of applying a pull request and will use the cover letter contents
> as the initial source of the merge commit message. I do encourage people to
> use this more than just a linear `git am` for series, for a number of reasons:

For me, as a subsystem downstream person the 'mindless' patch.msgid.link
saves me time when I need to report a regression, or validate which
version of a patch was pulled from a list when curating a long-running
topic in a staging tree. I do make sure to put actual discussion
references outside the patch.msgid.link namespace and hope that others
continue to use this helpful breadcrumb.

