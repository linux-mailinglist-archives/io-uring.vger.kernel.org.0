Return-Path: <io-uring+bounces-12974-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QKWmLaT71Wn4/gcAu9opvQ
	(envelope-from <io-uring+bounces-12974-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 08:54:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 640563B7C62
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 08:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 39AF63011BC7
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 06:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F195364937;
	Wed,  8 Apr 2026 06:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b7gLY5qN"
X-Original-To: io-uring@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012071.outbound.protection.outlook.com [52.101.48.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A6334DB6C;
	Wed,  8 Apr 2026 06:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775631259; cv=fail; b=Rqr3DzY0E8R3oKCrA2r0jXEWNOwjIuZGT2Yg615SpJkzb8s90J4OTemqFyHFQkjYz6rnSYeiNDfOMvc7e+QQiUM8ANcgYE5d7OPtmodJZc5SwNALtlWE/PmosDLkgYFA5czNTXHueB5TB3MbthJJTK2yF8ab4F8iivVnRch7lGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775631259; c=relaxed/simple;
	bh=6oZIOI9bMciInyHNZVTjdbY1yZjMmoQfuTWT4HN7CSw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YXaIBvu0HD0R1EE1BIkaR5PUm56qpMEdcW+9psC4nEA8liYM4X5Y8dc+y7WwC6WWu1eQD3adSsZmYFTmVR+gqPBxrLmU+Ys+rJC4C8SdPFEp1oCubh3VHZQtc69od0wPcGs2wA52C15twvBj+QQyJOaQeu6UBYQSfJ5fybG2FCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b7gLY5qN; arc=fail smtp.client-ip=52.101.48.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+KpvGaNOmRNqEs1UxvTgqsxufzqT2OCwqSVwGgTxUcWPOOqmcM5wZrGOdVd70z5r49tSKU6PXMdjlVWam16wW7HyyCmgIv5xKef3Uh33xQj/VZWh5f2j2gz+YnAhy6TnOuZRM9rrFJVDQgtSSLZBNhAiV5PbWy73QwjXB6taBqkIwDWXK3Gptz+9cxkZI0rEUPDR9q5kDkTWEdlxcnwb13Sg75UOiUOeXkvSk1ZWecQ4EQo0v+I/o6zsMZR1h9NHWS8sNQ9PHoMqqzqzRWidWuwRsaOKls4l3w/BSCd1OKryBWmbGNTQ+hF5tcbWjgKwaQwtBim+Ec1bYaIy64orQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzJK/sNiEjtJETriijhZsR3lDWKwC6wf/F8l86QiOWE=;
 b=nxczGq0Yt01Xht6lPMDAXIOLNrL8fsctZOIr59a/FIP42MOB/eFukvUm6yLY42l7HqtlyShV3d/UZFksaJiXCq9PpxfkH5Sv9P4O/2uneGr9NgSCThYbob0GZjtahPdRwTzUVdzKSyFIWsQAC/VCIvoRidSOMgIYf+7BZFAX9QjQ0/71Ne8JqHY03lrna4N6U+0zZrHDP2+MhPyMiKXxyHwQXcWo2D3KgKXmKUVCKBYPksCh4/B7vjgzaPwS5tFJFIsLgHrWJeaw6ymLGYwYwMkbuywl6Wzb7U8PMuZauxuGk/n29yXNc6Aw2GyZQ1YBMsCTez4174s1719syn1Kew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzJK/sNiEjtJETriijhZsR3lDWKwC6wf/F8l86QiOWE=;
 b=b7gLY5qN3JrEB4Amf1RfULSy8hzj2xNwlVQJwuqkU02xYDv6bnmYULrQqtN4kJJrgj3+0XewbHuWtvaSgM2Q+BYtAFRvHswCzCmM1oZ/ZS3y2isLoJ7DGYkwnOClJgWJXbtNC6ZxTGrBfPyItnl4+8YRijPOShw8PJeWtEu65ZES7yvfIVYuBha2pZSID08Wp/kPXAo9dpmESPnwDkxa+j5/kCPAfkOxMtICnKMA8YlqmVdio6L3UeyNbpylZdkD3GuyyiLIss4wkbT9akbXPbNT4OXXH4LuAXeh7eUlBv3JhJgxl2mNjcdPIOm3kcgxvMOYmcD3X5vESENQlEbSZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHXPR12MB999244.namprd12.prod.outlook.com
 (2603:10b6:610:2fc::17) by LV3PR12MB9412.namprd12.prod.outlook.com
 (2603:10b6:408:211::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 8 Apr
 2026 06:54:15 +0000
Received: from CHXPR12MB999244.namprd12.prod.outlook.com
 ([fe80::168f:599c:f74d:7688]) by CHXPR12MB999244.namprd12.prod.outlook.com
 ([fe80::168f:599c:f74d:7688%5]) with mapi id 15.20.9769.018; Wed, 8 Apr 2026
 06:54:15 +0000
From: KobaK <kobak@nvidia.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Koba Ko <kobak@nvidia.com>
Subject: [PATCH 0/3] io_uring: fix resource leak issues
Date: Wed,  8 Apr 2026 14:54:05 +0800
Message-ID: <20260408065408.2017967-1-kobak@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TY4PR01CA0022.jpnprd01.prod.outlook.com
 (2603:1096:405:2bf::8) To CHXPR12MB999244.namprd12.prod.outlook.com
 (2603:10b6:610:2fc::17)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHXPR12MB999244:EE_|LV3PR12MB9412:EE_
X-MS-Office365-Filtering-Correlation-Id: f370ccd5-079c-4734-4fe1-08de953ba5a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	wrXcnbIxqdPzFf8FPTsEImqPn5o0SetVl1py2i73/NusVtaMriEybtCF0Q5rEHcQGuP7mj29xT/qfbR+0aQ4Er6LOvd7aQr0Kv3eUNOZWV13/Rlo3q0QZ8rbegtBI4n6SJ0GJUxycRaHKu3m8ygxR2cYoI3MBcjSjdy5+C3deBNXFeWx7fdMNLCuAV7wbipnCRG6xTCFhXyCj9ee2no1Q1zxRGreoih7c5JasRtDztUtr7vHvi+mBexlwiFmshmVNzqMqO7urgiZKbqZlsFU1CiTiRdNkDyz23fB+4CsQk1aPboC4jM+ayR2gFkAW7BfG0ifcYDx2kmcZRkLubJSUuTOZ8tkR+LUFgAIOSu9/nVt6JdUgTdTcMvaOLrlbz/wQIILBCPHg2bQyKeJysrnSu4L8ot7GBp0nDXS04yOuDkiT1et1yRvijghluaRG7uR3v2CRq8Cr+ukyV6Cn98T3CvnCKFatMazJQZl8AU+Ah+dqcsLKZMIMpe6x3LzKsHcT4c9VADjzH/UgEHihmCsRH+897dylBDglpUdsRzzWljsmfO/Am/6gcdWvMAUwNNbx3rLcQrcDm8sx7cwYaOGAX84aoThzvEE6sceVdJL82oPY1iKNu4SW4ZqYSPIaj0bwbHkDeIU1rtVtRpAmEjOuoVFC5HvbPXt/6/UVFi/rd3FOpJUxrPyxMO/4xwr13Eo+7Sq0ooUqHxasMSbbYnzk5GLxCr10qd6lELA0OD73Tc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHXPR12MB999244.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWl4WlduM2E5VkRpODRHbS9Ud0JZaTBENUhEQUVHdkVZK2JCa29VZ0VxRS9G?=
 =?utf-8?B?NlJZdkFicjAxb3FOSFV3NmhtaXdzMXZqVVA2S0ZVczVEQ2pnVGZHTnVZbkV0?=
 =?utf-8?B?emJtYkRiZDJPZkNySVJ0UUdIYjlaQzk0RmlldnNublBVNUtvaDNnLzc1VzAw?=
 =?utf-8?B?ZEx4L1FqbjUvT2FMWHZXT0FZeTBRZTFNSkJIMjd3aERYTEkxVDRuVnIvcUpL?=
 =?utf-8?B?a21mcDFqcDE2cGlZTzVLdy9OTEJCam9QbEcwVjBLdWJhaUdjZW1LbUZyYXpO?=
 =?utf-8?B?OUlGditkc0tPUXE0alZIejh5U1Z3blJaT3lVVFk1UERaR3luWEFucXVTTUR1?=
 =?utf-8?B?aHI3YlN0RWN4dThtVzFNNHBaNys2SEpsNUFtT3hYRStzR1NNbnFkMzhJZjNs?=
 =?utf-8?B?L0ZneVVVTWJMckxuS1M1SzJ1RVdjMTBsa2hTaUdvSHVneXhOckxMbTNVbFc3?=
 =?utf-8?B?RHMzQjV6elV0UUU0Q3FwaHFBbklRaGhieHRtVmxYc3BqeU9vMTRscGNSK0hL?=
 =?utf-8?B?ckt6ZVBGNWNORHZ6VDk3M00wclBIL2JUcmRSRTNYa1ZCV1NmTmhvbUVpVjly?=
 =?utf-8?B?WkdBck9Ca1FnU3ExVUtzemZ3QXl3emIwaVhPWVlkQUxUUko2RmNkdUc2ekV5?=
 =?utf-8?B?ZjdZNVUyVHZzY0Q1LzBtSVkzcWtaVHdHMWVuR0NoOFAySXZmaThIWnAydUJZ?=
 =?utf-8?B?a054b0VaQ3J2RGppQzBTNzM4dEtzNkkybFBNRDNKYVdLS2NuL3JIeWJyVDhh?=
 =?utf-8?B?Q1pKK05uSXJVR1psLzFud3FoeVRuaWRTODhMb2g5MkR1cmxxSTQ2eXZLQklv?=
 =?utf-8?B?VTZtUmhsRjRrbGhaQVN3WlBJWnhLbVl3L093WXZmK3dYR0taak9adVVaMjQ3?=
 =?utf-8?B?VCsxTzEyV2xlQ05VSXljYkxiYlp0M0k4dTJQYUNlMHkwMXkzZDhZU3hFVk9K?=
 =?utf-8?B?a0lrbjlPOUF0UXFrbFZDeHBzQnROUTU0TGQwQjRrRjRtSEVNRzBDbWkrUEsw?=
 =?utf-8?B?RUxZM2NCSm1kamlFanAvQXlaSC9KZjg5MktYWHc2WmFUaVRYTnVQYmpCbVMz?=
 =?utf-8?B?WUpQN2hGODB6cFk1eXJISFZKQUZmdnNKRjJxcFE0U3NGMW0rV0p2TjBjeHhL?=
 =?utf-8?B?bWNoRUlVbW9EZDBuWDhJNmhiMTdTR1NKbnZzK0VCNkZWV1luU3l5VXJobkFh?=
 =?utf-8?B?ZlhNNWVDNXhDSlU0dkxucWIzMFB6Ukh3RDFZTG92MnVEN3NTREozMmpUd2JS?=
 =?utf-8?B?RjhaWC8yOXN2MG81MmpQNzVPb1o2VmVnV21RMHoxT29Cd29YdlJ5Vi8vSnY1?=
 =?utf-8?B?OWlyZGYwbGhtY3QwTXlIdVM5c3hBWEdUMllHSXlYYUliWHVQbUZLZXlpSjR2?=
 =?utf-8?B?SGNJNzJ1YVUxeTBqbC9qdUhDNElub1RSZUNmTzBjd3plL3BqajVCTWRIb1Va?=
 =?utf-8?B?aHJ3V1kvVTNRQlhaN1BqK2x3WjBqYjNmQkhMeWNXRXk3MmNxNmJrbnd4bGI2?=
 =?utf-8?B?N3RNQXNIMFIybkNRUFZ2aXJZTlIyVnAvcGpLZ3luSlhYNks1dlkySWNSYUM3?=
 =?utf-8?B?L29PcmdRNVZUNnNMdUdsSzRLbnY0MG5XQkt2OVBpb0dOK001bkFkQmpYRHo0?=
 =?utf-8?B?UVowcUZSMVJEQWNPQjhlZU1yeUhmeVNqcldXR0JSbGwxWTJwU1I0NTBza1hZ?=
 =?utf-8?B?MHY2YTVFTXJlb2N3d2JrSWNDem1YeUE3d1ZxdTVVUThVa1hSZ2ZZQnFLNHlD?=
 =?utf-8?B?NVQ4b1VGNDkwU28xWDdhNWxkcmcxMVE0d3VLR3JzQ3dUQXA5UzVXUUFuME91?=
 =?utf-8?B?ZDhMQzZNaTFpRFgvM3U3RGdVemwvWlp6Y1NaMVpqRVdvenJOMk96WEZHSHNz?=
 =?utf-8?B?bEp2bkNQUVloc1M2bGFkSjZZc3g1Ykk1dkNwNDhYT3YySVpDUlkrZHh1WHNX?=
 =?utf-8?B?RkViVEFYUEg4UCs4Z1RLckltdTc4TUVBa1lNV2ZFSnB3SkR2UG43U2tYdnNs?=
 =?utf-8?B?NWg4bzhzMnJpNEw3Mk1HNng4QlJEOGJUdHU2SkZwZmFWNjJwWUFqbzRqd2Fh?=
 =?utf-8?B?WlNvRlBSQVdWUVFDbkl3MTVTUVgzbFFwc3gxMkRxK0hFb3ZjRUYvN3dqRjg5?=
 =?utf-8?B?TFJscjhZOHpqbzlNdkJkQ09sSzdOU0JjT1d5V3NLdm9LcTd2SjJwQjBPYkpr?=
 =?utf-8?B?VzVHQjJrZmtxNUQyQWdDTndudFZvZW4rQWNOYnpDT2tqMldUdk5IWis2Y1Fs?=
 =?utf-8?B?eUhRNmVEbWtXNFdSWWQ0UVlaTzRkMlNoc3ZTMFM2cW16RHhuNlVOcjdkeE1B?=
 =?utf-8?B?a1kvK3pnSXBhc1QybDFJZUNOOXRBWURnVzRxL1VkNHQ0bnppMEo2QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f370ccd5-079c-4734-4fe1-08de953ba5a0
X-MS-Exchange-CrossTenant-AuthSource: CHXPR12MB999244.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 06:54:14.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5tjDiwmMqmM6oEdNRVx8vrNRavXQ39gp+pV9NpWWPr2X6xg0WCOO8OE/qMgH303T1aW5lNuL82Z1e3Zzn2TP4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9412
X-Spamd-Result: default: False [2.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12974-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kobak@nvidia.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:email,nvidia.com:mid]
X-Rspamd-Queue-Id: 640563B7C62
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Koba Ko <kobak@nvidia.com>

Three resource leak fixes found by code audit:

1. memmap: pinned pages and pages array leak on WARN_ON path in
   io_region_pin_pages() — mr->pages is never assigned so the caller's
   cleanup is a no-op.

2. rsrc: kfree() used instead of io_cache_free() in
   io_buffer_register_bvec() error path — bypasses cache return.

3. zcrx: io_import_umem() leaves live pinned pages in a partially
   initialized struct on io_account_mem() failure, and
   io_release_area_mem() is not idempotent (missing pages = NULL),
   creating a double-free hazard.

Koba Ko (3):
  io_uring: fix pinned pages and pages array leak in
    io_region_pin_pages()
  io_uring/rsrc: use io_cache_free for node in io_buffer_register_bvec
    error path
  io_uring/zcrx: fix resource leak and double-free hazard in
    io_import_umem

 io_uring/memmap.c |  5 ++++-
 io_uring/rsrc.c   |  2 +-
 io_uring/zcrx.c   | 19 +++++++++++++------
 3 files changed, 18 insertions(+), 8 deletions(-)

-- 
2.43.0


