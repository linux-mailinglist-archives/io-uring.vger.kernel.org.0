Return-Path: <io-uring+bounces-12102-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +LISFefgiWkKDQAAu9opvQ
	(envelope-from <io-uring+bounces-12102-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 14:28:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C58CC10FAFD
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 14:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC3AE30086E7
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 13:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56CBB3783DC;
	Mon,  9 Feb 2026 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eYTXM94t"
X-Original-To: io-uring@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013040.outbound.protection.outlook.com [40.93.196.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160673783D7;
	Mon,  9 Feb 2026 13:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770643462; cv=fail; b=QTqUzAf6qPjs+4zW9vPuvVWPUF6p7xWy8wUQEQgfyaBLCbL4xbY2mLKTMXBJNrtZIt18kkfD24SnY3VE/8BZOkL2+amwz9BDAwe9pvTLbgl035jh9VnXUfDws2TbeCJ9dmxJoBhpOp/qNtGVIeEwsjbylOSCYt2coLpaxapYfX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770643462; c=relaxed/simple;
	bh=oxyZKJoYDiUTFrj8U/02gChkJyNiRR9Hcuf3qVrB+G4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ewNCOHRrMT+KD18euCNpLGLdGmyRG/3E8pVr+rfT9u0uLqNQXEa2XTlySrN+bX2TltEDe2WPkCEABY6SroKdKt3CUvyLLKQpkDVVlO6QF4pgz2Dglu0wBD7PBo0krt+xTe1+xXRXK7Beyketm3opx4LCD0kUiYR/IbPytWkUQC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eYTXM94t; arc=fail smtp.client-ip=40.93.196.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XwgzGEm4uYCDc5Gy5b3JgZcIuvqej1YhlCY/2moqUoJCCr9Ec+KDGLaeVAIt4PGgVkgcNPfKEzTGv6LmzjIbj3L6spJ7oGSlv+mvzPGcREoT3G1alUI8iC8Rx0X+OsS1UFWcswOR3T3wE4/xMvEzCBc2cZpE/WJuwgim0cyxG4Tb5DTLdMgqk0KaVWBp/563kPwFX6nEG060j9YZSimYjgFecNxePVeB54eSV8PLQimIrf0maCWgezb6XLFxnXCf9x5tFHOoZ7I7YZXwoopt7JoHqM5ok5M8Xf8nwdvPWHFd6C4odD075q8fo6lLT6JqNibElBByHU0dc+9uZ6SMOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MmqfdSASHNfJcpymSG/Yx3B22/1MqWz64sbYT76X6go=;
 b=gd632r+sWlcnLnxXea/FmAFJUYJVfyeuUJUN1U4bjm31YZV3uuXCuPx8ClpKCeg/vX5nIJGaUcFT8GcvUxxFu8MIVaoHnbdC5H9JsyPmtygstT0m0LYSknEvKU3w+UZzwB8gkg2nOm4JwhH79OB7LWJfCxHQsRYTVkh4PS6JyNsOINEqH34lBf9eJj/wlOw3x9q8w4ffgnAWfpLQs+vNlH4R529VZ55Y+gxwDhA5smN+SAqxhFbXroiRxikAfofaLqeVgOuGTd2RiZJVwp2X+K53SOrOKazXJ1eqz7HH+OuZeXWN8RXdQ3hWS+XK7k0pns4aFNimYjFQNlZ/lzNcMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmqfdSASHNfJcpymSG/Yx3B22/1MqWz64sbYT76X6go=;
 b=eYTXM94tincW15KFWdxccw09313O6/6icd2IIfTeyhOPDHgFj2xNOv0sSGuHdJKMybgHv4dohxXuIEPAEncVT2FsHsGU48ooGzg4kTlY1Gg5rnkCyRAekj4knHWnORXW/0QJl7VV17Tl1SN0faZnZKulqeFEVD7zvot4emDFMSAoN2R5CR1CgGXlUHuRCmX6oCr2WHpSo1KKGJCumh3/qbklC3hOcH68Bl1sv4yXPqnuP/I1QdHXyC8UNUgeIWiHqNCMtIIXzoRbOxV/laLRCYOjDOY/UV7oVrQfHIlALdIDSVoinNTb7auqrH63mnNzArvSHwQBI8eo8KW3HqVTnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 13:24:18 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 13:24:18 +0000
Date: Mon, 9 Feb 2026 09:24:17 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
	io-uring <io-uring@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"Gohad, Tushar" <tushar.gohad@intel.com>,
	Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
Message-ID: <20260209132417.GA3076640@nvidia.com>
References: <20260205174135.GA444713@nvidia.com>
 <dbcc2912-e1df-491d-b1e0-7812279297de@gmail.com>
 <20260205235647.GA4177530@nvidia.com>
 <3281a845-a1b8-468c-a528-b9f6003cddea@gmail.com>
 <20260206152041.GA1874040@nvidia.com>
 <df7fe4d7-ca28-408e-bed3-bd1fa23e7588@gmail.com>
 <20260206183756.GB1874040@nvidia.com>
 <4736af5c-4bf8-4e9b-8f82-4b89a75d2cdb@gmail.com>
 <20260209130607.GF1874040@nvidia.com>
 <6246cc2b-0d6e-4062-ac24-74c7148dc47d@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6246cc2b-0d6e-4062-ac24-74c7148dc47d@amd.com>
X-ClientProxiedBy: BL1PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA0PR12MB4400:EE_
X-MS-Office365-Filtering-Correlation-Id: 2041bdea-43df-4bd9-ece2-08de67de86ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cE8wa3kycUN0dEh2NzNhMkVVc2cvNDM3UDhCR2l5ZFBmSUFZNXQ4STZQTzla?=
 =?utf-8?B?Vm90QUFOdUZNUGNsQjhvNHpmamR4WG9OZFVtQzNzSmRrOEpiN1F1MnkxcTM0?=
 =?utf-8?B?TFF4SVFBSFd1S0lZMnRNWEUwaXhSV09MMjMrTXRoOXd3MDZOK3Z0MFdzU21v?=
 =?utf-8?B?cmJxd09GWU5LSGJ5NWhxalIzSHhvb1hjdUJCK0pGd3psY0toL2NJb2V3L2pv?=
 =?utf-8?B?bC9QV1pxcGduaEFMb0EwVVdINHc1Q3ZzWDhpKzNMWXhJN0ttNHBZUHVvNGtT?=
 =?utf-8?B?NVZ6S0ZlSzlLZERCKzBqZWprQkVLSjF4SndkdEE1V1U3MnlxbVlFR2QwcUxK?=
 =?utf-8?B?US9qMUlTRWhwY0t2Y3YyK1hpbVFzWVF2MDNNMnpvblQxdDBBWDhmRzkyT2JI?=
 =?utf-8?B?V3JYSFk0clpvdFhoMi9Walk2U0llQkFxNGRDWHNmMW1ibWpVNG9CRUF2ZDZ3?=
 =?utf-8?B?UEJxUWZCVlg4YjV0OWxNQytiV09Ydm1lRTVuVVlmVjZVL0h6cDMxT2JKb2Vh?=
 =?utf-8?B?WWVlcjFhWElJeEtGZXc2ejVRWVdZbEFnVnRNOVpZN0pWc09CQUErZDc1dXcz?=
 =?utf-8?B?YnkrNUIzbnNWTzJLbHFEK2Nta2liWFhFR25ic1g5bmdmNWhJb1R0cjRtSzBS?=
 =?utf-8?B?OXI1T012S1gvYks4ZDdlM0RWVCtJcDJicGNLK1FWOXBLS3pZK25GWFNsemZh?=
 =?utf-8?B?citlTnA1VUM4RWtBRHRlQmdaU1lxdDJNdVZ6dTJYa1Y3a0lLTUZoeVR1UkVD?=
 =?utf-8?B?dDB2SGhsRG5ONXpxa1VFdys1bnBnWUZUcGk4SWVWRnVUa1YzVW9iSDNEaHhM?=
 =?utf-8?B?SnVhdVlyNkRWWXVVV20zUytPT2NoZUhncEZlUzZySEVKeUxtN2pKUEJ2ODBP?=
 =?utf-8?B?dWltSVdKQnBPMEJPbXFDT1MxR3hITXNWQzVoRTIxYURVNW5WMGkwdDZEbG8r?=
 =?utf-8?B?Ky9YSjRpVUczc2VOalF0YjZMSVlrdzgyZ2ZSaG9JaVdhWVk0cDlDOFVmbThI?=
 =?utf-8?B?a1grVW44M1cwUUFKUkR6bVNESEZYL011UHVZTlR1WlRtTE5BYVJ4a010cnJ6?=
 =?utf-8?B?SDhTNHo2Y3NIQkdqaEVkNHVnRnRGL1N4S0p3Wno4TUlpc3lVUjBaQTMxS0ZF?=
 =?utf-8?B?dmFhcTlIeE9lQkxIWit6WnM5Q1dCOFptUXZlTUwrbXdWM1ZOazUybTZFcFEx?=
 =?utf-8?B?WkFSVjdERFJRaTdsSmpHL2lzZERDUnhUaVBDQUpKZ3k0M0JJaHNDOXM5NmhF?=
 =?utf-8?B?WVR2YzhNM2V2YUppdWYyd2tIWWhPbU9GeEZ1MTkvZFZJZGozVnVmeEZ1SXR2?=
 =?utf-8?B?aFp0ZzR5c3BQWUZJM1hIeC9pYUttYU96TUI0Y2FndnZTeGtYdkFjRWQ0U1dT?=
 =?utf-8?B?eXA4RytNVW9EaVRkUDNzb2E5bFppMUlBeDN4T3NLRVFRTjFLbFFtVzRNRGVL?=
 =?utf-8?B?ZkRiWWFheEZmWjU2WDk3VE5PaUVVeXhGRktvUktXWHhDVUxhaklyQTIvOFBi?=
 =?utf-8?B?WFpudDROODNkVllwV1pGQzlwai85bEZvV0I1c2ZZQ05UL1U5L0VEYUR6bEpK?=
 =?utf-8?B?M3ZnM0ltY0ZXVmVGQjVCNEFMckNQOE44NjZWc3pNdmdFZXVtRUJkMXA2TXBV?=
 =?utf-8?B?UlNka2IyaTQ2MUQvMTBSeEQrRWIwL0wxM2lDdnFScjRaQkdKSGFaUGp2eExF?=
 =?utf-8?B?aHBzbG5IblJsSmtZK2FDVU5hQUZlbk8yN2U0SzlUWFl5cDM2UUUvZ0lIR2xu?=
 =?utf-8?B?NlN5ZzllenM4VG16NGtYUmJmdW5uTHZIaVlsbm1mMHE4a1V0MzBEdEIrOTJa?=
 =?utf-8?B?VUMySk92dnMzZmVyMSthQkpUZnlGVUkwYlJnbStYa2FWRDN0YXB6aUs2QXRu?=
 =?utf-8?B?UkdaLzh3ZFNWQjI3Q2pJREVpcFVzKzkvRlU3UjNtVkRmN1Z2NHI4aW1lNkFL?=
 =?utf-8?B?M0h0Wkd5R3hhbFlwT3F1dnBYU2FZdElPTlFyZ2FQL2s5SmdDakJjWENTSVV1?=
 =?utf-8?B?TitzbHp5bmVrc2dkU2JUYTJUa3pjdVhURE5uRnFRUkFlKzRHcnp2VnJYbm5s?=
 =?utf-8?B?dEloejY1cTN1UXlYWWFVYTNMZU1CeVNvTDlBQlBrbURwNzRxZE4zRUNsR3Fj?=
 =?utf-8?Q?36uA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjIrUkg4d2xKVm9NdngyVnAxaHVnTloxZnZPMmw2cDdQcXVDNGRHVVQvR0RY?=
 =?utf-8?B?TU1ncU82U3pZS0lqZmFZSkllRm43YldDb3BWZFVhbGhPN3IwdVRubFpvZUd2?=
 =?utf-8?B?M3g2eGcxVVhzK3laeU1yZFhBTDAxSHkxSzd5WC9WeS8vRXFuTHEyTldCWUJy?=
 =?utf-8?B?S0FiUFdNRjJsck4xRVluc1ZkL3ZqcGtyeHFJbWRnb0dKcWZDRnRjRlpWdVMx?=
 =?utf-8?B?amxNWGkxMHhrRDlTVkJWek01Wkl6cndwTjNhQnY1Y0FjQ201SXZSR3YxR0k4?=
 =?utf-8?B?d1p2MnVKZjNZc1VxbXRzNXczMFEydjl0UUNvYStiSEU4NktFMi9CYkE0bFk2?=
 =?utf-8?B?TFcvOTJHU0FHM2daaHQ4S2FWM2IwZlZxWFFMbUc4Z1NtSlhFZWE1YitORXVr?=
 =?utf-8?B?YXhub1NYblVyZG1nbkFrdTZmd2xDQjJZRFVDWnlyZnVzSGx5eDQreGZOMGxa?=
 =?utf-8?B?TnpmekpZeGRFOEVrMDl3ZkdqWlQyMG52N08rSS8vY3JMVWNDd241ckdMZEdj?=
 =?utf-8?B?bDRBYk5YdHJaaC9nd3pyb3lLSFpZTGhjWk04bGUrczJXekZnM1VvcnQwcStW?=
 =?utf-8?B?QmFGMHdreFZIQlBHMy9OMGk2Y241TFVXdEZYdVhoYzhiVk9ZdHhmMDR2NVZl?=
 =?utf-8?B?c3RHT0xYenRKKzBvS3RXTFRiMGhuOSticEVEclhJdzVyK3poSnc5eUdSaUJK?=
 =?utf-8?B?YU5SRjR2czZGMUF1TXdOYlp6dTlTNHFXb3pQWU8zUEhYV1NnOFAzYlFOSFM3?=
 =?utf-8?B?N01vOTRUOXh3MXp0ZHNaNWhJUStFSFl2OWFGc25vY2RiQ3MvcHpWeWNna0hD?=
 =?utf-8?B?RkgyMkxjcWJBUFlZM0xOZ0xrbGN6cUdGdzVMeFUvUEIwKzJHb0hiWlZHRG1V?=
 =?utf-8?B?OHp2RWRHVzdDRjdpNSt3TnhtNVpESGVHdHIzbzdab1hCMWxCWVVkTG9uWGZV?=
 =?utf-8?B?UEJ5OUZENWRLUm1JejNaK2w3Q2ZCV00xaUZRaUFaK3I4dWhMTStyeWJhOC9a?=
 =?utf-8?B?d0dYVDlZTE1Ic0k2WUdtWW84K2lMRFlYLzQvM05pcGIzOGlRMVZONmlxcWg4?=
 =?utf-8?B?TE4zM1p4TkZoZnRZQWJsU1FVWXFTemJ5ajgxclJscmoxQ1RQYmNzdG1GcEND?=
 =?utf-8?B?d2RPVkd4TlNGaytjSlkyeENFK3NpTkYzMDhHc2hWdzduMzE4dVdOQnI5Y2Fq?=
 =?utf-8?B?amlXcysyRmtIVnVwUnFqUWpmUE5HUnBYd3Uyd0d1ajN6R0FBTGNjTkNtQjZo?=
 =?utf-8?B?bXhCWEpvTzVYMzBaeE45dkY0L2JUYk5xMWxFcGlmU3RIWnVMT1lMVVdhQjBu?=
 =?utf-8?B?MXVaRlZMTE1Kc1F6Nm1nM2cyd0RjT2xoeFBGRXF5bVBTeFQ1TGdhY3hEOU9i?=
 =?utf-8?B?Y2NmdFR0b1dyRW5FZlVRaTBmRXllSTJjTE1Gb3BZMTh3NG8wWnFNUXBuQ2ln?=
 =?utf-8?B?RHRpTkdWeUR6NDZqUTdYL2JpMzlXa1VkYTBldCtVVVRhSUR1MXFYSlRqRzhT?=
 =?utf-8?B?TnJXODJQdlcxWVFxdWhpWGlJNWoxNTNYRHJtUFd5RzFDU2ZMeHU5UVRsdVh6?=
 =?utf-8?B?QkF3aTFNMkNxd05yK084YnJjVkZDZTMzcE5DT1pJUzVKc2VINEtZcUlKWGlw?=
 =?utf-8?B?VGhYTk51c0gzVjBrL2ZuWFBDRC9ZYUxJZEF4Sjg4WXRIQ0hKemc2b2VKdTlI?=
 =?utf-8?B?VjRoeFo4aDRtRThtcXlkZHp0WElMYVZhNkJLTDhQa3VXWGdWR1U1dUIyelZv?=
 =?utf-8?B?RTVGL09IS3FzZi92ajRVaGFXNUV5WlI1Zmp0N1poazZCdVdmQWR3UGVIdUl3?=
 =?utf-8?B?Z3QrOGtURXE2cjFnTE9FSXNHdDYyTXpLU09BZGhkNmRLeEpOVDlQdC9VaUli?=
 =?utf-8?B?azdSdzNoWlZ2NGRLckZkRzBJZ0NScThjT1RsUGhDMm11WWIwQ0FEd2oyOWFC?=
 =?utf-8?B?bFI0RG9YdXFoOXhrdHRCUU10Z3BDckh3aGVyd1d2NTNKZFhjbnJzWUNCSlZT?=
 =?utf-8?B?MGxUNjNFc0V2a2x1Ujlxck13cWlWd2hVVHlPTHNwY25nQlB6YzJTSHo3ako5?=
 =?utf-8?B?TTF5THpOTnpNUGlQSnVnMjExNUlrdjUvRUlaSGl0bG1wcWp3L3JzaVBnZWNP?=
 =?utf-8?B?NFRTRURleExocEF6QkZyQklNSEpsRGJ3SldDekVYWEQzdVVFR3pPNkwyN3B0?=
 =?utf-8?B?L1l5b3BFSE0vc2dEVTJzZERYMVVSd1N4cXcwWndaTnpqQUY0b0tBVFo5RGEy?=
 =?utf-8?B?Mk5VenRHOExwM2l0MUcwbG5LWUpROE5QcnR2eitudndTUml6NDJrZ09jWnk5?=
 =?utf-8?B?eHFmcDBIWStBSDMwcG9iYXRKaThzWTd1SCtNa1hoWndFQ0h2M3g4dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2041bdea-43df-4bd9-ece2-08de67de86ff
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 13:24:18.1131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 13FqHBhMaR8MfAkTwoCMYkN9/eFTVfaX9Euch7dfJ5Ao1pVuvcFxzMLBDBAdOSDD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4400
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12102-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,lists.infradead.org,intel.com,lst.de,samsung.com,lists.linux-foundation.org];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,Nvidia.com:dkim,nvidia.com:mid]
X-Rspamd-Queue-Id: C58CC10FAFD
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 02:09:24PM +0100, Christian König wrote:

> We have exercised and discussed this in absolutely detail and it is
> not going to fly anywhere.

Yes, I understand you concerns with struct page from past abuses.
 
> The struct page based approach in fundamentally incompatible with
> driver managed exporters.

The *general* struct page system is incompatible - but that is not
what I'm suggesting. I'm suggesting io_uring, and only io_uring could
use this with it fully implementing all the lifecycle rules that are
needed.  Including move_notify and fences so that the driver managed
exporter has no issue.

Reworking the block stack to not rely on page is also a good path, but
probably alot harder. :\

Jason

