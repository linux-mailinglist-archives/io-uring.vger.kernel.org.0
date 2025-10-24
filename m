Return-Path: <io-uring+bounces-10202-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A998C07AA3
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 20:14:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BED01C43979
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 18:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75828347BBA;
	Fri, 24 Oct 2025 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="DOD1XOCz"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4107347BB4;
	Fri, 24 Oct 2025 18:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761329576; cv=fail; b=A4YRZwC/cPMPQmezSacZH7Mj+2INxpFC6dDIYXu4Lt4mXk+JdSIWzB3XpdySWxfEVIhmbhUgTaL84yx5LCzwRieDuLEyegEUqvrghY7qTBcVx6uxrE2SL11DeIbLwwhw6e6UP0nP+1wahp0swKX1VLbutcoQUJrSifPM/lniBCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761329576; c=relaxed/simple;
	bh=bu/rujPExO4pd+WwtDHHeui1sz49JKIRVG1vEtlVcKM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kFD8Z/DwNMa5hNQTQOJ+lpldp8NyC0XDCCbYfFDLhuL0jZwv3Uh+J2zZIAYyblRjy0rCKDLGvBGTXcuwtutxvgIjX2HMlXW9RAju6DzuZZEqeQXC/bxdbFT/U4PG9vKUuwaYBt1DaGM914ayhEab8gfuzix+Hb+iBkfyOoySyCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=DOD1XOCz; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021098.outbound.protection.outlook.com [40.93.194.98]) by mx-outbound22-225.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 24 Oct 2025 18:12:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sURtltfTvhreFRjuAlZ2zdW498tY49Mi91ukFQQHBm72c2cEE03uEQ2g+uGl3bRIpKScZZ6wPu0PQ8fzAG0JVkONajHxzs1V4K4ObaQ5QdugdsL5CSt2x636A+SaOfBZL5y7ZMJ0Kvu1hhet+fEE/3aUFVvjTulCeOzgpk7DYu11KZMd3rfK86JjXj7YbDVErW3WyC6O5oyhFBSe/zeiCI3SJmDSoeQeM8SrtE01RrCcI6CmCvbIr/v7rlcNbd3ySOtdezMKJeBniio+InCE4Bx5bZqFiAI97mq6QjqTs3w/Cc9ZSXU4jlvm2JqmLDso+WeQJQ7x82XNbektJgGEJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hqd0s8snE9QEydgGYhE/7JxK4ljCIpvlKlJ8bL9Z4l8=;
 b=QfrYIe4L+xLLI2AzWj19vKhY1AeLbHD/aiCjaDD/38YDDErQNN5lFYjxUYy79sDmA5NP9Xm4tvYx0HaWbTDo0Nz7SI2Jgy9AAnbYEtfqCHWlp7DKukDniovjvD/PgV9P2HhlK2KtsamuImYXmxwB0EsmYSkvQ6lNMjWQVtssH5qC54QtevEenPlWeqL3Zwuwzt/eQjl5LxodPhM79LJW9WQZzc9GDtVvKno99hDlg8eO8KqaYGIgJRQyZIVKBUA9zBaqZgWWsgvQd+DoVVJhBZssYW3lRQKEJFZQJYed+jbDvxy4e3fRpBKZ2HzbB3RSucReON9TwLP1Hj7bzRnadw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hqd0s8snE9QEydgGYhE/7JxK4ljCIpvlKlJ8bL9Z4l8=;
 b=DOD1XOCzJHuDOfMraY0ZSOdR53VE9Y/aCrNRQEJ1rt7GxjfdtSi+9QznTSUAocKgxcGDJD//8EY3aC4iPQFjs/PeUHod0iQ+Hh/ikR3D4hhI6/S7GijsRY4T/f/U4bIyGkwkRRpTcpv2LlQ+ZWmrS727dgzoFr2MR8zrKRTWCZ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by DM6PR19MB4010.namprd19.prod.outlook.com (2603:10b6:5:24e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 18:12:45 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::abe1:8b29:6aaa:8f03%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 18:12:45 +0000
Message-ID: <a2aaea17-0719-425e-8999-16a8367c57e7@ddn.com>
Date: Fri, 24 Oct 2025 20:12:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] fuse io_uring: support registered buffers
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
 asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com
References: <20251022202021.3649586-1-joannelkoong@gmail.com>
 <539ebaba-e105-4cf3-ade4-4184a4365710@ddn.com>
 <CAJnrk1Y2cKgc3snAK8jJpVn5EJpLPE87nqxjcE-eKBWK0TvUgg@mail.gmail.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1Y2cKgc3snAK8jJpVn5EJpLPE87nqxjcE-eKBWK0TvUgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR0P264CA0158.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::26) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|DM6PR19MB4010:EE_
X-MS-Office365-Filtering-Correlation-Id: 8704f034-1ef4-4702-a559-08de1328ee53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVJVU0Rwd2NNWmhsdnp5ajRGN2xrODVNLzFWZFlIS0tyZVdjSVFaMTVSUmdl?=
 =?utf-8?B?RUhJNFNIbGhnaXdnWDE4clRHR1RxNXR5U3duMXp6MXg3a1hRR0g5VlI4RVFk?=
 =?utf-8?B?Z0pvcWRqcUljUGhpbFNHaFNoVjUvVVJ6WXZQTmk4V1NQZndBSHZ0bEJvWTZX?=
 =?utf-8?B?d0VxdWVZRHdrY1V0K1NpWjhQQWxEaGhNT0NyZC9JY05TZ01TTzczbk1xM1I2?=
 =?utf-8?B?TXZVYllHcFRkUDR6c1YwZkkwaXlraHMzYlFhNjBVYWt6YkFwVmhWT1prUkw3?=
 =?utf-8?B?OW9DN1lYTW9CQUNwbTJEVmhiZjVqc01rc3BXWEpPR09IazE3amxGblJDQkxh?=
 =?utf-8?B?WmluSjdMb0I3Y3VFblFSM1dPYUdtNkh6dG14QjhQTTJ4eXJYRnhKOXBMVTRp?=
 =?utf-8?B?SlRuTmQwVEZoNXVnczZTMnJJcGFDckJINU5BNjY4Rm1sbGpCTi9RZmpQOVFE?=
 =?utf-8?B?YnBaV2dKQytGVU1qRUYzMFBJanlNYXF5WmxJTnE2Yk95ZW5vV1Y3OWh0Nlhj?=
 =?utf-8?B?eG5nbTZHNXpYc3M1a1VaNVk4cnhZWXh2ZlpQKytoanl4ckdrQVFHWmtKeWdj?=
 =?utf-8?B?VG9MQmh1MDBOTzdJQ3c1dy9GZnJkV29rMjRzK1JCRnFGYmx5UkI3bDBoSGky?=
 =?utf-8?B?YjcwSUt6NG5sRGZpdXlodnZIeEh4M0hxc09tdW5sZFl4Z1BqYTRHd2xOZENN?=
 =?utf-8?B?RUdMRFlBV2k0endPWnFtblBUendoRUF0TkdZTXdBQmhURVZSdXBJSFlCYnJJ?=
 =?utf-8?B?Z2pOOUVsQ29Db3FZNU9xRTk3V0ZsbTlrTkh5a2ZuazRtREhMbUFTOGt5dXpY?=
 =?utf-8?B?enVzMC9VUkZmM2JRM3FRcW15a0o3TUU4TUw2NnlKa0hKRDMxMVNGclFzUjF6?=
 =?utf-8?B?Zk52LzNVNzNYd2ZwWXhuSm5tcFdMcldRaFNlUitmeURXOEZ1cld2QUxkZThQ?=
 =?utf-8?B?bVRXYTZwUUh2NEVYZkdDVVNjNDdIa0IzdG11OU9KVXVmeFFEeDdraHkvc2x0?=
 =?utf-8?B?bUwzRE5tczNxQ1daR1ZHZEgwTW5YM0IyYWlVOUl6T29vcG1rSkdML1RpQXZh?=
 =?utf-8?B?aXRrT2QrUTY1QkxlTmNLSDA4dVFOZFBRbkVVWWtuaTl0Nnk2QjFQa2cvaW8z?=
 =?utf-8?B?czlMcFU2NDdFR29selJXZnlvMDIzMm40Z29IZ0VPMUx1YlNHNzJxcWVFYkdt?=
 =?utf-8?B?U1dyVWR0Y2NsRG03TXcwcmNuRk9pN2FYT2IvYVFVTUZjeC8wQWFwbnVLV3VT?=
 =?utf-8?B?amcrM2tSSVJtZks1TGdjTlZ5UGJhd2g3M1MreHJZL2tIWDUvWjRWSjhHTnMr?=
 =?utf-8?B?bldYMERINlVWV0xHZVIvcko4Ujg2TWsxaXFZL1d5eWtQVVNVaEFMMXZKSnRL?=
 =?utf-8?B?UnFrTEowdGdzSEt4bUs5K2x1VVdtZjgxS1NFbHYwbVN0SzlIdXZWclFjUW1t?=
 =?utf-8?B?cTl4QXltbk03VWxLZE1UU2ViRHNTMHY4K2dTaThuMjVienorcnhhODhBN203?=
 =?utf-8?B?a1MrMVlDK2FTMnhxZjAyZGxzMmZRWndjcVQxVzQyU2dvemIvVnFORW5xR1Ir?=
 =?utf-8?B?M0RZKzlsUUVnYnVmZi9ibFN2YjgxQ3pGK1lHcExyQ0ZSZno5b09WUzhINjJ4?=
 =?utf-8?B?TWtaYTc3ZlNieHBzUWV1V1FRSTd4TVNIYm8ycm9qemM2ampHaW85dFZRV0hI?=
 =?utf-8?B?MFRvRjNnbkkrTTdzR2NxT080T2lQNjN5VXJSKzA0Tm13OVBhUDFlL0Z5UjRk?=
 =?utf-8?B?MFVNRExqWnNhbVJyOGx0TWpSRVlLdGRMZi9ZbCt6NDMyTG9YRGRCK3RKbUwx?=
 =?utf-8?B?RXhFM2podytlNmtXTVRNYVRaRDNaaE9mcHVnU0dqTWRacjcydmtFUGZmdjVC?=
 =?utf-8?B?aU1zVEF4TXJ3UVExeVJOeWhKMWZRcUJZamkxVEdDSGgrRHErbVJibDEzTjMx?=
 =?utf-8?Q?qoIPwxc8X0YN7ViVIeXFfy0nVcGFE2rN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUNNZ3UyUk1UTXFjL2p5RXJqL1JzdmZscnI2SkZob1plR1JiTk9za1dsQVVS?=
 =?utf-8?B?TDdmeHJIREZNcUM1ZDd6dnREejl0cFZNQTJxY3AwcFp6ZzlJMXZRUGVPVC9y?=
 =?utf-8?B?dVM5NHdYUUVwTk1EOEsvS2hORytKY01iRUpEbU55bVBjUUN2OWhJM2FlN1Jp?=
 =?utf-8?B?ZDk5YXZ2THdaMmJWNFE1OHMzQWxmM1hoOG1TTWhiQzB6RlpEM0hUK29FdlQ1?=
 =?utf-8?B?Szh1SGFydVBwc2NWd2lYbWdGTnlXUUs2dkE1UnVuLytlRXJUdTR3ZEJZM1Y0?=
 =?utf-8?B?aVhMTUt6amk0Vm9KLzZ6NTdTbDFraUxXSE05WDN0QzQ5UnlxUlpvNUpUcTcx?=
 =?utf-8?B?YVZiTG96T1lwSnMwYlhJeTNyTUxralZITnhaTGRRSi9NSURYY3pFVGNvYUJz?=
 =?utf-8?B?eW91eE84N08ycFV6MzJPTTR6VG5ySTRvQk8rdWNrcHZ4cVdVMitiRTdUakRo?=
 =?utf-8?B?UmN3Tko3R0d3Q2YydC9LZHJpazRLMUQ1R3IyaitSdmNmdDF6QkM0UHBWSEJ6?=
 =?utf-8?B?V2w1Z0NWbTg3VmxoTlUxL3RZYU9DdlBWTUdEeU1hVzUyMENtbmhSNDlWcFA1?=
 =?utf-8?B?blNwNis0OXVGTFhLWHBPNjEzWm1tOXJzQlV2a1d6enZpRWxWcUV2OTBhOFpQ?=
 =?utf-8?B?czJGYU1GZkxqeUhpdDVSaFE5UG1YVWc5NlI4MWxUTnpoM1h3NGJYaThnSDIx?=
 =?utf-8?B?eFdxcEJpcHNKaGRmUldrMXpDQzBmSkRrUUk1QzZVdTFXekFIVVM3c09nd0Ev?=
 =?utf-8?B?N21QTEdicGNlblRtMXJpT1J5aGpLanlSWnZlWnN2OHo0QlU2b0FNeHYxckRO?=
 =?utf-8?B?cWQzKy9LdU9VMG1rTHZUUC90UUlWRHlzUGllQlpWVU1DdlRrekllU0xNL3Vy?=
 =?utf-8?B?SmZMaGFCMTVaWDFLNWp6RjR3ZmdyNU1uSGpiUWZFRy84R3lRT3p3bU9OVlla?=
 =?utf-8?B?Tyt3N1dqTEQ4aERrQWI3VDM1ZFB5TlhPcy9EZk12aHFEdjhBTVFDSlk3NUVR?=
 =?utf-8?B?QWZZajkwT1dKMzRVcllsWGpFRG9xK3RoSENmRXk5T2VYSWpWRzVGcElqdEV2?=
 =?utf-8?B?d3RiSk9mbURRakdMNDlwdGZGSVlhT29EWkROTmJOeGVHOTZqRzRCenViclpW?=
 =?utf-8?B?Z0dBZEk3S09RTy9vMm1RdDZmbmdLNS9wQW5wamxvMnBIYTBZai9Wdm5pcE5j?=
 =?utf-8?B?blpWN1pURGpoZmt2MDFtTWpyaVFMM0VybW5HTS9Rb1VrQUpIb254QllRdUdG?=
 =?utf-8?B?aVVaZFZaakFxWVlNMHM3bnZOSHIxYVVzV3dIRWQzK215UlRQeWNLTk9VTzRy?=
 =?utf-8?B?MGx3MDlIU0xTOGZuMTMvUHVhckRjSlBRdXpCS0I1SStzWnRWelgvaGNaN25U?=
 =?utf-8?B?cE1TMGRreUJEeUluenV5R1hmQmthblhybUZLSWxWK0NGSWp3TGszT1Q0STZ3?=
 =?utf-8?B?Mlo3VGx4d2FvK0phR1RIbWsvK3hZN1YvK3Bxc1BIK2pXVkl4QzV0NzFSNHFG?=
 =?utf-8?B?dDlYNjROVkw3UFVIdGVSbHh0YTJDeWdsakVwQXRkZWREMDRUUTNIcjhGa1dN?=
 =?utf-8?B?UC8rSmlFanpZbXFuaGN3UFNVV1BZMmswU0srTVFmbnhTMzJ2WWdvMy9jSnB4?=
 =?utf-8?B?dytkdjBHTUxtZUpMWUtlUDVKZ0ZSTEVza000aEZkcmh1UWlKQ0Z1TUhpNVRo?=
 =?utf-8?B?TThtZjh1WStHSm9iSitMTVphNjJORmdqRnRzSENKaFM3UlVNYWhDcU5zYVNh?=
 =?utf-8?B?UWpHckdsUVMvN21YSnQ4QTJxVDVPUmNTT21keDB3SWorU2hBY3RIeW1XMVd4?=
 =?utf-8?B?YTdTRTNMdlpUZ1ljTXR2cHdPb0RUY1plK3VzZXJBOXJOeFhBb1paazB4a0hY?=
 =?utf-8?B?a3Y0ejBIcHBSMThlakE4YnBHcnRqNUhjZWV6MkIya3hYY2JxY1BKYlFmNGpu?=
 =?utf-8?B?OWlUVHdpa25xeExJZTN5dXBzaHV3RzVBTnY3YlFZcVBsQW1XMXFwNmhHaGJj?=
 =?utf-8?B?WkVsWVB5ajRydzJJWm5KcUN5YWFWNGtJb0xMUlUzUUMxRWlBck9uYS9hdFBG?=
 =?utf-8?B?R24rbG40MkRxNHVxTG1JMmdVOVp6R1NrZXNNaXBNVHFrcmNNK0xjYWQxVzRp?=
 =?utf-8?B?d3F2T2ZSaDFDeEswa01kZHlVcDM1ZU9hQ0tHSlEzM2JSSVVFS053bllsTmtF?=
 =?utf-8?Q?obwg0nl6B4BPw8BPP8T/bVwW0wW1yK1X4NeABKmjXJsc?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dK9ZTOoRBfLJsBGer9wP28l+KMiBV6xgBBTxUnFhp1dR4ABD2Sn1Eox0TBeqKYjStr/v4beToHH93VviosRPT8zRVC/Qoo+aRQlsqbNjGZXrpZuw2eqiVDe/X9uHk0ziuOZ/fFjFmUIrrArHnMUA5fyRmOdJl2rNZdBpqKjUur2Cn/JA4ZmLdGPK/ll7LAY7QetmZsYkNu/6/3xbwATobMMn/5hY93WMu2wtwEQE5giM3Vy508sB6+Hf3ikEut7AOE2iGX3AYglxLGHuthmd4N/dLeirqIP6JRpHe2s1Pgc6qVlG7aJEdxxwTdvpzhjh5gT+ziTs09WVQh3EuqkMQaOhZPWaSoySosH3ChchOgZOcdzI1HYhXEIaazxkLozadjBqnPRBWWActTuVjEAvhYIZHOcyvrnwE88YfF13nNKrTteLWJxQluQJPF1oIEwe/qDl1I7oxmrq9ip795X2PN4zso+5xmPXtt4aN3cpS08Ge6eKfxT9krpsRPK8hfQgUXFmuQtR+gPMcPED1QLwFRL6+qNNt1vqOHDiIvVcmAIROSXBd65CCLYrlRNxZ0ToGO+392a0m/ITQju8MiyNOD5WNIL7M3gR0X7LSXnbVJS29Kyg1x0qwY6tN4UsUhT0RjCDISNXkIw9eKyU1NlqFQ==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8704f034-1ef4-4702-a559-08de1328ee53
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 18:12:45.4505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDhJLJZLjvDynghGsThkT9LwNsUWrEzD5N19upiDGzgTJ7DXwYAHYc0VFspxSH7GQNW/X/NM01Ckjq8ow2xb7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB4010
X-BESS-ID: 1761329567-105857-7703-22458-1
X-BESS-VER: 2019.1_20251001.1803
X-BESS-Apparent-Source-IP: 40.93.194.98
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVoaWBsZAVgZQ0Mgy1dLQOCnJMD
	HNNNkwzcDEzNzCItnA0MjS0NzcyDRNqTYWANz0LA9BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.268445 [from 
	cloudscan23-239.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1



On 10/24/25 00:27, Joanne Koong wrote:
> On Wed, Oct 22, 2025 at 1:43 PM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> On 10/22/25 22:20, Joanne Koong wrote:
>>> This adds support for daemons who preregister buffers to minimize the overhead
>>> of pinning/unpinning user pages and translating virtual addresses. Registered
>>> buffers pay the cost once during registration then reuse the pre-pinned pages,
>>> which helps reduce the per-op overhead.
>>>
>>> This is on top of commit 211ddde0823f in the iouring tree.
>>
>> Interesting, on a first glance this looks like an alternative
>> implementation of page pinning
>>
>> https://lore.kernel.org/all/20240901-b4-fuse-uring-rfcv3-without-mmap-v3-17-9207f7391444@ddn.com/
>>
>> At DDN we are running with that patch (changed commit message) and another
>> one that avoids io_uring_cmd_complete_in_task() - with pinned pages
>> the IO submitting application can directly write into header and payload
>> (note that the latter also required pinned headers)
>>
>> Going to look into your approach tomorrow.
> 
> Thanks for taking a look when you get the chance. The libfuse changes
> are in this branch
> https://github.com/joannekoong/libfuse/tree/registered_buffers btw.

Sorry, still didn't manage another task for tomorrow. Btw, the reason
hadn't sent my patches is that I hadn't handled memory accounting yet.
And then got busy with other tasks for much too long...

I see in io_sqe_buffers_register() how that is done, although I'm 
confused why it first calls io_pin_pages() and only then accounts. I.e.
it can temporarily go above the limit - I wonder what happens if the 
user opens another application that time that just needs a little locked
memory...

In general I think your solution more complex than mine - I think I'm
going to update my patches (there are conflicts due to folio conversion)
and then we can compare.


Thanks,
Bernd

