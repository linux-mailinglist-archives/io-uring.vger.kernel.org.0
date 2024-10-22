Return-Path: <io-uring+bounces-3896-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8055E9A9E0C
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 11:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4DDAB22DD3
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 09:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90791547F5;
	Tue, 22 Oct 2024 09:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="EelYp1ic"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73F91547E9;
	Tue, 22 Oct 2024 09:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729588379; cv=fail; b=Vm78bVPDAJr7AqkLidveAbV5GvykJB/3YNJkRzKilN/K+5qv33AS7K4bC97G9fRZb7yWXn9QuA9KqgJhTMrT5TPx+gd32FPA2g1YCSddg5/IVui70qn2QGcdN6WicUMBfgGObuZqAgZtc3rRsOlBy4cSBYnA40nEBPr0VKdpTzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729588379; c=relaxed/simple;
	bh=0zNtXDZY5IvQD2pSEp+DGjCB/yeO1WTqDDhSsZV5zUg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=IP5bvhcWJdtv4iQZ9CIqQKe73tno3s7RPEuEX4vh8kRkvLGzMmKK3pd+TLsoS67GElWJEROnkjPUYkvkdfsD9iP7RN47VK13LMcn75rrAi+laUMkkZwcSHi8z4X2F5T9RMrdoQ0FkL+7LqjD2HraWznY5jFaNZ/EKJ0YUxHoEEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=EelYp1ic; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M7gXW7018262;
	Tue, 22 Oct 2024 02:12:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2021-q4; bh=2E6JYhUNhn1uUoytZ5Owu4X+aqr9kUmyCpcjJBGZP3g=; b=
	EelYp1icfcKvwIaAdJb972+/DS+bLdMWfTE4DVQEUZ/TJxx/GOqtVwXkLB0cpviM
	oy59RLb28WVtR53n52pXmD63GCQVUZC1hGHDQZBeWU6G22eNj5MpBt3gmVlrbbkt
	BeYyBlgM+O7L+uJr/4mEXTnhhAxg/2H/dLMRRM4DwV0LTna21oZOyR3XwA7BKGkv
	k85fYL4bqOMaeh26K+SQ7igCUru+qh452+0/QM7tQZmOf90icwXkZXKxYivOOYsq
	fyFI/7QRz7l2uU+wh/ZHjTdSPv1BxljNwF/s1jLIH+RbzoyJk6KUGdqOzSGzGEr6
	tqgqC0451fTn3Pgccc+CWg==
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42e7kt8hck-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 02:12:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLVeq6XqY612JOcnxkiV06Mgs7jckJjlRl2EI+o8/4Avql+M0TgmhEsRPE00k76NDz+WS0DgIdJGNVMCIk9V+kH5BInAokp9GaW58dssvQbZsrXiYg1zlZ18lZcIN0xzH+2qi+wOrOW3Ud/RoAELY73JURT2yDrPzVuaY/dhNAzOGLWwL5ZDi3E4BU4rb+EWMnbBwMOl/2gsmm/BXlU0t0F6DLDSBZegQ31GSn9VYO8Hl2m/939jpthLOjgdBOMeuAO1XrLcN9pOFMw1KWhBmBciRspiMUhSgzczHCV0PiG7CkKHKeX7h4K6YuRQ7iJ5EYSt7rPSDLN6B2ynsUsv8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3iYA+1iVnkqVwlHJYZMMdwebpvAn+znW1k8yNLxEU0=;
 b=BgYF561KT01nLgID6CWecJYNcMHub3I6azcbTxnYyxwoQfVZPx+dwTry9fMHJz/55ihC2zq3H7z9XPjySCEsvcrwTmFKIeum+tHeG8gyk8eTs3NGz5ug4WRcmg64r+22eOvWwKAbf6Hh5rgXrDhbfUvnVCPOFImQmkMNbuRBowK4ZCGQ9xYR3GDk9ItxbiZBgnk0qppl9m3ku06kfm0bxRFUQ104QU8ybIZHcUO9uULbWw/ExabrBBgXBWFg0Vz7b8FhIw2Dc5ge3w1yjrZ+JzBmeS/bZCEohhq+zHHyH4IAZUTH4O4AwlBMVPiTr7zpR3wRF7Kf9dj234gzlVM9GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com (2603:10b6:a03:4c0::15)
 by SA1PR15MB4657.namprd15.prod.outlook.com (2603:10b6:806:19c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Tue, 22 Oct
 2024 09:12:52 +0000
Received: from SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8]) by SJ2PR15MB5669.namprd15.prod.outlook.com
 ([fe80::bff4:aff5:7657:9fe8%6]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 09:12:52 +0000
From: Mark Harmstone <maharmstone@meta.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Thread-Topic: [PATCH 5/5] btrfs: add io_uring command for encoded reads
Thread-Index: AQHbHl0hRgvHSvFL8kWBhZGVLitDMLKRQ4mAgAA2jYCAABXRAIAA+IKA
Date: Tue, 22 Oct 2024 09:12:52 +0000
Message-ID: <ece90bd9-d85e-4601-be71-b34dbe84f65a@meta.com>
References: <20241014171838.304953-1-maharmstone@fb.com>
 <20241014171838.304953-6-maharmstone@fb.com>
 <20241021135005.GC17835@twin.jikos.cz>
 <f4f64bfe-c92b-4656-adec-d073b6286451@meta.com>
 <20241021182324.GA24631@suse.cz>
In-Reply-To: <20241021182324.GA24631@suse.cz>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR15MB5669:EE_|SA1PR15MB4657:EE_
x-ms-office365-filtering-correlation-id: ac8948a6-716b-482e-d77e-08dcf279b536
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SldEL2hvek9wVW9uTFVJTW04MWdheURXalBEdTQ3Sm5pS3RPWE4yV0tOV05a?=
 =?utf-8?B?bHIxU0w0SWVPSEoxbWRYOERTeDA4NkQ0aDBUOVo1SThnbnhJd1NlN1FYbkpR?=
 =?utf-8?B?dG9lN1EvbEZIV0FXUDd4eVBZWVFhaUhNYWdXVmhzTkFGZWc2Z3g0S2MrZXlv?=
 =?utf-8?B?bWc5ampRSndTbXZaUG5aRnd0ZE1XTFc3K2k3emRiTU9IU1B5M2o1NHpaemhF?=
 =?utf-8?B?aU1VN3RhZzhnaGdUZWNnVDd4TzJJdzlMTkVtUklNWVR4bk11bkhtUUluM1BC?=
 =?utf-8?B?NHBYSGp5eWFxSHpwY3l1K1ZNQjBzRTF6VGxHYlpUWDFUVDN3OURPQ3pCMWVM?=
 =?utf-8?B?ZlN0SlRlR0VwSjBlWmkwNllhbU9EL21YYmI5VHJkdHhaVm1JSllMZjRvZytZ?=
 =?utf-8?B?VHdUcm1OWHFIaUVnUUZqV3I2Wlkxd1pJcDZhVlcyZTl4bytiVHRVb2NNYVZw?=
 =?utf-8?B?UGpyUmd1M0QwV2xmT3d0U3BmcllKV1UzSEU1VGUzcUd4c1dabEJlbEJyeVJj?=
 =?utf-8?B?d1hzTUhkaHpjazRPOVlWdXR6ZnB5Z2pPTFkxUk9MWmJWd3pHb1VKczA2UEJW?=
 =?utf-8?B?MVVBREhOMjVGQi83dTExV0ltcXRFZ3daaGJKNE41WUhTUEFrREhpcjZhQVdE?=
 =?utf-8?B?THQ2enJacno0ZnBMUWI2MFNRc09kekhEUEpEMUhHeXdWaS84emFka2VScWgx?=
 =?utf-8?B?YkEvcHN5aWlHUUxETitkTEJUdk1LNGFNd2ZDOFU5a043ZjIxRU1yeU9nWldq?=
 =?utf-8?B?QjBoaTdpZ2NFMVdwRGhRTVhkRFA1UGhiaERwN2JnRHluSXNmdmZFcmJ3aWNO?=
 =?utf-8?B?VjRuZTdVQ2FGZDhhV3NSc21tUWVSOFM0VkFMMUkvcEZnVTRINkRqdjRMTHhE?=
 =?utf-8?B?MDJMVUpGRng4T3JtSmVmUjVNWUNrcGovTTErZWlOVDNCNlZxZFJseG0rWWJ4?=
 =?utf-8?B?dExCT2lIdmtQTStpSFU2dCtLbHlENEkrc21kTmozSy90YnNFdkJUeXJlelpT?=
 =?utf-8?B?bjZtNThqYitiMHBWMkkwTmkycEpyZ2ZNNmQ0SjNsb3hNN0p2dGpTZkhLcEtw?=
 =?utf-8?B?ZE1WZ3JFOGlPN1hLMDMvb2txVUhFWTY2RGRWQ01iUkZuZHJSUWFmSElKbTRP?=
 =?utf-8?B?b3J0SGRDVXlNR0gwS1lKYnI2SzErQjVlSzVwQlQzUC9OK3MycFVFd0xTclZp?=
 =?utf-8?B?bC9aeXdLaFNFMmVFYWUwZWhRWEhrSndsQlZzanBkYTh3OEVJQXIzL0k2MkJO?=
 =?utf-8?B?UkdsSjZDSGZSdDBGdnRPUVdua1B1dldXSDJRSEtPV3FWRExPNUd2STNzc3F1?=
 =?utf-8?B?NjhZMmxEZ2RRdEs5T3huREJNb1d6QWVuOCt4Y1VBVFNYemV4WUltZDNhZGVp?=
 =?utf-8?B?OWJ5SUlQK1lkRnBkS043ZC9iaitaRGtKbUVycktlZWhJQ0VzZWhrUFpESE1R?=
 =?utf-8?B?L3g2b3ZjYVIyZld5emtnZEE2TzJMTDJ1Y2IzaE4zNTVESnB3RVNQYzBwZUcw?=
 =?utf-8?B?NHdkR3N5dHhOYW84N3M3Vi9YZmF6UEp5Nk9RbnNXSFFWRVhmRVFyMnVuL0pp?=
 =?utf-8?B?SWFGL3ljK09Jck5uc3NzcE1EQ2NyZlB1UVdQNTliWWIzRmJ5dm5Wa0FjTEZv?=
 =?utf-8?B?NGswWFY2bmdOSkhmOWxrbWR6VjQwWk9UUi9MdFJRdEQyR0JQa2N6dWUwakdo?=
 =?utf-8?B?YlphdjJaU2w5MS9NS0Fma1FlaVg4YTJSTFRFNnNPSjFFNWd1RmYyR1ZZWkxF?=
 =?utf-8?B?bk55b2NMN000LzhhaitObFg1bG9VaWpIOUh6K3FGUTFQNk1uQVVzTzE3d2hQ?=
 =?utf-8?Q?5pNAg2+9NJEYrauM5LbIZuNYVYt9gGfHy8cdo=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR15MB5669.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NThwcUR1VFFaM211OFN6Rys0bXZkcmpMVE4rd05TUFdSeTR6VjBGS1ZYNldQ?=
 =?utf-8?B?WTNHWGpKdUZsOFRRaCtOUlJpbVN0d3BuRm96bDlQaEFyVHE0OWlLWmNnL3Bt?=
 =?utf-8?B?NTJkaHpWYlpiRFhSWnplN3Q1MytmSDdVYzhBZDZxYjhKdHZtcXErajJyVVVQ?=
 =?utf-8?B?Y3pBc28xc0tIak9WVHpHa25Ed2wrNU9wTUpRaE9tdHJQZVZrUklmYUlQTW1k?=
 =?utf-8?B?c3NDMVBoYmhkUlhDbVhQcy9GMG1RdmsyYVNsaWo4cEVoZkNzQWJJVkg0Q1lO?=
 =?utf-8?B?dXBZdW9UMjU5bVlNWUVVTVpzdGVkaTgrSEhDZ3VMbmlSL2RneVVKeEQrUHBV?=
 =?utf-8?B?U0VQdnh0L3JKZjNqTC9JVE1aR2o5VHhKK2EvTWRoSU1Ya2JxV0h1eDRnNkVS?=
 =?utf-8?B?VUp0cENZTEhocUhQV3FoVGpwaDI0U1QxSDRrS0dZMkRsUlNnQ2NhNzNYYVF4?=
 =?utf-8?B?MnJQMEl6ZkdkVk1ubDRvYTA5cUw4MlVoYUQ0L0hscE5MVW8vcGROZ3d5eHBM?=
 =?utf-8?B?QmVRVEVaa2xDWDRUMG5ncmp2b1dvZ3V3R3lqVlJleWJycjQwYWZHaTBvclo0?=
 =?utf-8?B?K2UvaThDZSt3cG5CL2htc1VFMkMwSWxoekJ4TFMxaTRLNzlLNitjTnpvcjg3?=
 =?utf-8?B?MFBWSDAvOUV4SjlXOXMxenRJTERYY2VGa2VEWUVuT1VJRllxOHljQWlBWTBl?=
 =?utf-8?B?aUJ0N2V5cXpCenJvT3JORUFvZmNIVnltZlRwMnlzN0hvRkZLaTZLWjBreW1U?=
 =?utf-8?B?U0FLU2tkbXNkeXdRelU4NFY0R3duaFFvUktBTzV1c1RYTS9TU2kyUUxRNXdh?=
 =?utf-8?B?QjRjK0ZzdmoxRVBoQ202Y0s4WDNqdC8rQnd5NUI0aHVXRjNBZmlJaWxCNUdX?=
 =?utf-8?B?QUQxc3Y5K0haYUxrK0pSaDBmcjlDUHB4TDZNY1Q3UG92QWZGSDVzMkRHdlV2?=
 =?utf-8?B?V0EzRlBaOEg1eTR6a1c0QTAzL3FKYUZISG12ZlQ3bk84c0VWaXNOaCtPZ2o0?=
 =?utf-8?B?WUY3cDRENXZzUWlwQUJDZTBlNmdBQ3NtaHNRMW5KSXB6YkJkckRBbzNTVEdV?=
 =?utf-8?B?NllLM3lIc1ZQKzBiZFkrcmVCMlRld0NJcHJzdlo3SGNad3VydnpJRVMzdXZJ?=
 =?utf-8?B?QXp3cE0yZG5wdVJLMjJqV0JDSUthY05VN2VxbTBlSFpTYzgra0FNYWM2eUkr?=
 =?utf-8?B?RmlKWVNNSitlZlZJWmpEK1E1TldUSDllbGMvb2xUSTdseVBmTkxoZmR6bXdE?=
 =?utf-8?B?VW1LSm1ENEorajhzVzBQREIxRnJzdDBZb0Evdjc3SUo0allzcWtDTHJtUW84?=
 =?utf-8?B?TEhKaDc4Z1hId3FCZC84UlFMMEQwUk5aMFE3YWkxVmluRHFYb045a3hRNHZj?=
 =?utf-8?B?ZXQ0Q0FFSzhFbHh5ckYxc1hXQUVmZy9HZ2NBeTh5TjRsVlg0Tkh2Zm5hZEdz?=
 =?utf-8?B?QVZVMEthVXdCZk0xTE9kRnREUEVOWHd2S0svbmhaMWZSQ29nekFsZFlTZHoy?=
 =?utf-8?B?NU5USFFvWW1JeG1SQ2UzdHRZN2lqVzgrc2lBeXAvSlNSY2swbmhKa2tBYTlO?=
 =?utf-8?B?Ymp0VW1YcXVIRlpLbEd6YVI5UHI3N1QvbzROOGVQSjlSQUZwemRYMlN6TlRR?=
 =?utf-8?B?U1JZYk4vVGlFemc1NkJMYm5QV3J1czhzVEgxMytucFNuZ01RVDQ5ZGhFT0l0?=
 =?utf-8?B?ZFZnVFpIV2h6RWZLd081TjFXL0FPblREb2hJYlhBbmdQV2pJZVlKbElRZ3lI?=
 =?utf-8?B?aFBiMndBWHFqV2hUeGgrZFhyYldUc2M3emFlMERRUk1nVUpZdC9HU2JtN0hl?=
 =?utf-8?B?QlhWTmZ4ZkZkc3NVVURBcisxV3pUenhlSnYwNEtEcWJBaG5PM3MwYmJUTUFG?=
 =?utf-8?B?T2svaERwZGdLTHNBalpaR09YZmpFZElNY3psWnJPL0ZqbjFrUUQ2TC9BRm05?=
 =?utf-8?B?cDF3c2J3MklKOHBlTzNIWVdvRTRXaHJHcmlqOEFrbDFJWnh3aUU5OVZDTGcz?=
 =?utf-8?B?RTFWWkRRSmJwU0dVU2pCaXVkZDk1NDhWMWhlL3NPV1BUbmlwRHBGaVlLbmIx?=
 =?utf-8?B?UmlFOW9NY0xoK01Vckl1TkFUTFRWVFVhcXd4WlR6bEMzZW4yWjR4R29lbGFa?=
 =?utf-8?B?c3drYnp1MEg4ZzBzL1J3UkExM1Y4dTNqTWpiaTFLd2s4bm95b3hicUdsQ3Y4?=
 =?utf-8?Q?oUJ8qM8kqKW+3xPd88zb92E=3D?=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR15MB5669.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8948a6-716b-482e-d77e-08dcf279b536
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2024 09:12:52.4603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q+eE8AHKqJylDCRYKc+A1VmmoH/Ok1uJEG4dtVO6dUZ0MaEEpMqg/kHzcaXR2Rc69gMGxNdeQTg2JR4AKlci+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4657
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-ID: <13EA63085972D044A4CDAAB9AB6A19F4@namprd15.prod.outlook.com>
X-Proofpoint-ORIG-GUID: c5nxAlS_XZ_4l9nWq3Au85D21fYSfyUs
X-Proofpoint-GUID: c5nxAlS_XZ_4l9nWq3Au85D21fYSfyUs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

On 21/10/24 19:23, David Sterba wrote:
> >=20
> On Mon, Oct 21, 2024 at 05:05:20PM +0000, Mark Harmstone wrote:
>>>> +static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd,
>>>> +				    unsigned int issue_flags)
>>>> +{
>>>> +	size_t copy_end_kernel =3D offsetofend(struct btrfs_ioctl_encoded_io=
_args,
>>>> +					     flags);
>>>> +	size_t copy_end;
>>>> +	struct btrfs_ioctl_encoded_io_args args =3D {0};
>>>                                                   =3D { 0 }
>>>> +	int ret;
>>>> +	u64 disk_bytenr, disk_io_size;
>>>> +	struct file *file =3D cmd->file;
>>>> +	struct btrfs_inode *inode =3D BTRFS_I(file->f_inode);
>>>> +	struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>>>> +	struct extent_io_tree *io_tree =3D &inode->io_tree;
>>>> +	struct iovec iovstack[UIO_FASTIOV];
>>>> +	struct iovec *iov =3D iovstack;
>>>> +	struct iov_iter iter;
>>>> +	loff_t pos;
>>>> +	struct kiocb kiocb;
>>>> +	struct extent_state *cached_state =3D NULL;
>>>> +	u64 start, lockend;
>>>
>>> The stack consumption looks quite high.
>>
>> 696 bytes, compared to 672 in btrfs_ioctl_encoded_read.
>> btrfs_ioctl_encoded write is pretty big too. Probably the easiest thing
>> here would be to allocate btrfs_uring_priv early and pass that around, I
>> think.
>>
>> Do you have a recommendation for what the maximum stack size of a
>> function should be?
>=20
> It depends from where the function is called. For ioctl callbacks, like
> btrfs_ioctl_encoded_read it's the first function using kernel stack
> leaving enough for any deep IO stacks (DM/NFS/iSCSI/...). If something
> similar applies to the io_uring callbacks then it's probably fine.

Thanks. Yes, the two should functions should be broadly equivalent.

> Using a separate off-stack structure works but it's a penalty as it
> needs the allcation. The io_uring is meant for high performance so if
> the on-stack allocation is safe then keep it like that.

Okay, I'll leave this bit as it is, then. I can revisit it if we start=20
getting a spike of stack overflow crashes mentioning=20
btrfs_uring_encoded_read.

>=20
> I've checked on a release config the stack consumption and the encoded
> ioctl functions are not the worst:
>=20
> tree-log.c:btrfs_sync_log                       728 static
> scrub.c:scrub_verify_one_metadata               552 dynamic,bounded
> inode.c:print_data_reloc_error                  544 dynamic,bounded
> uuid-tree.c:btrfs_uuid_scan_kthread             520 static
> tree-checker.c:check_root_item                  504 static
> file-item.c:btrfs_csum_one_bio                  496 static
> inode.c:btrfs_start_delalloc_roots              488 static
> scrub.c:scrub_raid56_parity_stripe              464 dynamic,bounded
> disk-io.c:write_dev_supers                      464 static
> ioctl.c:btrfs_ioctl_encoded_write               456 dynamic,bounded
> ioctl.c:btrfs_ioctl_encoded_read                456 dynamic,bounded


