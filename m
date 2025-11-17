Return-Path: <io-uring+bounces-10648-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11E90C62892
	for <lists+io-uring@lfdr.de>; Mon, 17 Nov 2025 07:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFB4C3AE0B0
	for <lists+io-uring@lfdr.de>; Mon, 17 Nov 2025 06:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3BF315789;
	Mon, 17 Nov 2025 06:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gViF98y0"
X-Original-To: io-uring@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010045.outbound.protection.outlook.com [52.101.46.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E303D2DF68;
	Mon, 17 Nov 2025 06:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763361492; cv=fail; b=CZUqYjuV2Nzdwu1yz8EX/+9SNFg6BqyuDhrPnpgATLktGihlD/4GHLTVmd3kQ2lzlKiDRiodP56/57ymJ6f/Xv2mNZBp41e4AEUNT4JhR1Ni8sPVjqTy/IwO0UOi/BBrKfpD3fBVQYCjyssiR9skj2cyEvO6h8+6rNCvHfqAzY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763361492; c=relaxed/simple;
	bh=efvLHnG+46j/gUxsZGo1wBr3ZJ7SrLN7F0I6JlKs2d0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CCitwru4oboB4qJgWR9BTC2ExdjlodZNIHsaO7SNm7QdWQYUAW51XnMe/EDuOejBoLvPHra0ndMloIgA9OkwOMGeA55tAOyxuKu7rdj2k+Nr2wK7LMgW7CisILW3xiOixRac9z1ezOQBo1S1p6KdfF97fdOFGiQ4B/M3Up91UA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gViF98y0; arc=fail smtp.client-ip=52.101.46.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BpvwnRUYNsKL4llqvZ03usFb1jX5v0uMowyP/vxNi/jujlugLHc5L/j/CzqBzj46Mw4Vpl8KYqdfACaO6VtKFW7j8qGgDzNpnSNX0OPafgWgFlBA1vvNvUJ4L6BBz3vlmOYKDx7n+CsWvtPmpoKlS7sENhU4ePMG/MR0Fw7omsjUYNwg50TxKVPzPlYMmw/SnwoLHNOHIxv+6FXCc3iq1qfZwQvpqRsHPUgFoyabGHcngbtxxsMFQLOo2Q/w8kiVgA6REKSvjZzFX570Bb8scsVKQxpjOgDS3MWQ3rcrX8k7RSXJSK83uJkYMLrNuZlznl/4VRTIjxCuhdrzGTecJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=efvLHnG+46j/gUxsZGo1wBr3ZJ7SrLN7F0I6JlKs2d0=;
 b=ylUHyZE1he+cJuUAb7QJKW6yaSMv6Psq5aMvNYA3Lw1pREcN9ZwMC0+n+S7g+iqpSNa7gNvEDlVsj5MPhhSBx4gaa/5kiGpI5/oEjNnATHAogRkaWshO36O4NJnanKHex5yw0hYvfWe8/pBaFf1bwRnwSu/qDaczrcp7a/Te8SPKqgtU05ga/SPAiGoYG9iz8nCScBPVUpAuBC36de646An9HmNS4kKX7YdJj931Fz1YgLoIh+DxxAiPS13HGg9VDtIH4IQuZTHu/NtrSnel1rKN/NOHITUOuIFGqI9YI2hI6evHHNmsilIx1gPQC2D0nMYrDHjZwtXK0CrXRu1Syw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=efvLHnG+46j/gUxsZGo1wBr3ZJ7SrLN7F0I6JlKs2d0=;
 b=gViF98y0td5i5VlNe8p4ymIKUjftFCkDEi6CfqXDmcvSct/y8qZxTEHHpXuuXDpYEpjPOkSQhiIsIj+qnoKiFrKNbGDaLMMjfKHJmGsCGLwp5M5u97n99iu2+eRStvXM1QnUl0XdbuTjM67Yk/J8HtJHSMy8zblsXLtsEnjxTwt6yxY/Ez4J3EBzxGyNARjiA2MpsbwdiljABYbG+qVoDfOn+IRqpZjsJpyOVm378kaJN/QNZiXHeub9/1EgYsLM/SYJd9uo8Y30ZGZaAJamO/PprGdBbjDXZ3xRp2cCobOd6APuI8cl1dlsP+qhhrItNxzA8FSqhxhEMuV6qrBiVA==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by DS0PR12MB7632.namprd12.prod.outlook.com (2603:10b6:8:11f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 06:38:08 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 06:38:08 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Jan
 Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg
	<martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>, Stefan Roesch
	<shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"gfs2@lists.linux.dev" <gfs2@lists.linux.dev>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>, "linux-unionfs@vger.kernel.org"
	<linux-unionfs@vger.kernel.org>, "linux-mtd@lists.infradead.org"
	<linux-mtd@lists.infradead.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 02/14] fs: lift the FMODE_NOCMTIME check into
 file_update_time_flags
Thread-Topic: [PATCH 02/14] fs: lift the FMODE_NOCMTIME check into
 file_update_time_flags
Thread-Index: AQHcVS/c/PihpY1ORE+5nf52AfWYvbT2bxeA
Date: Mon, 17 Nov 2025 06:38:08 +0000
Message-ID: <8162efe7-5f39-4041-a931-21d637a59393@nvidia.com>
References: <20251114062642.1524837-1-hch@lst.de>
 <20251114062642.1524837-3-hch@lst.de>
In-Reply-To: <20251114062642.1524837-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|DS0PR12MB7632:EE_
x-ms-office365-filtering-correlation-id: 0cadd6a9-530e-43d7-2525-08de25a3dee1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?OGIxWDBlMDhKdDh2Vi9DTHlkSnBYUXlFSEk5Rko0a09NUmdmYWJkYnhWdk1C?=
 =?utf-8?B?RjlETnFaaHRMa3lVUzVvb2RJSG1UR3E3VDZNM0Ruclp4SXRnUkc1ZU9sdkNy?=
 =?utf-8?B?c2JLNktrNXpLVytjbXE0UnBuNVYzR1JaS25HdFZicWZidEk4OC9admQvbXRL?=
 =?utf-8?B?MVFpVjQwZHRpb3RuVTlBNi9pUGR0VUZ4N0t6bndPYldTeEVLdy92STFDN05X?=
 =?utf-8?B?UFc0S0JvaGs2ZDdJQnlNUG8zZlpOZGRNR29PYWxINUo2b0diTFV1MndIV0ZP?=
 =?utf-8?B?RG91YzRuZXpJZ2xmQ0FOVHI5U0xISkpRS3M4OHVTa3BkNk1xdmlpVDFxNDlE?=
 =?utf-8?B?SlhCeFdYUVo3OGR4SGFoWFFDaHlJNWhNNmlNTEx1U21McEtCNmtWVzZkQWFu?=
 =?utf-8?B?TzIrSHJydzk1U1JmMmVOLzI4ekdiT0IweGFzT05uZjZicnRKaHloRE5rZ2ZG?=
 =?utf-8?B?U2JxZWhrSklPV1VyWmZVUnhwaE5PSXJpUG93OFhMeHZHRXp6Ym1UQWpaaUxt?=
 =?utf-8?B?V2dFSUNDZ2s2MFVLV0lLUmcybGVpQkFGV2JYM0xnRU5iT2RPK2lTbHBuZmhy?=
 =?utf-8?B?dUpIemdBUzJqZW5palA5VVByRDN4Uko2WCt6NXNTN2lZb09yeHF1RUhQbGhx?=
 =?utf-8?B?RlNIcnVjQjkzeWV3bEljY1k1Sm1XOVBlOUxEc2JPVEdUd3phK0c4R0wyRC9V?=
 =?utf-8?B?d2Z2ZndHOVB5eC9OWmptUlhUbEVVWXhyTnhMRTFBem1mU3VNNG9qYUg5WnZC?=
 =?utf-8?B?SmMvQ1kzeGVNSk4wUFJmcUFZN2kyL05teFdmdHdDR1BPcXNyZG9MRGN2cHMw?=
 =?utf-8?B?ZFRxY2lsZTJZVUMwdEYwTE9yUFloeUp3UTNoTS9hbFFmQUdIODZBZ29DY0dL?=
 =?utf-8?B?dHNpUUpVMVcyVnJ3c0hpYU40citqdFZXRURuU2lTV3J5cEdib2N5a1FMWVZO?=
 =?utf-8?B?R01nU1YxRUJzZXhJYllXdDY0M09idVZhRkVFVFFKQWNGRisvT3Q1eDhLdEkz?=
 =?utf-8?B?ZGVlY0FUeVNpS0I0dmpRTG1iWXBndE5adGRXRjJOT2ErTGVmOUtRNVVTd3hV?=
 =?utf-8?B?b3I5dDlxVjdmNzRTckJ3WGUvMVdYMDROL0RISjR5QndlMTVObnQ4SXNLa0dy?=
 =?utf-8?B?NDJFOVdCRi8zd2h6eDdEWUFOUUtyN0ZkbGh1TnBVL3pUVURnZTZEbDY5L2hv?=
 =?utf-8?B?OTNTTW5xOHBrUXRLU0NVb1FNdHVyUmtSNUg4Sk1velVpOEFmMzRBRTBXbDJK?=
 =?utf-8?B?Slk5ZkUyaWZEQ3NrL3hVZEZQUlNtWVZOb0p4UklWL2dLV2Z5cy9Vcy9kYzZz?=
 =?utf-8?B?ejErS2plczh0RlBMR3hvVG5aZ0lzY0VTdnVES0lZa3Vha2pURHk5RlUrNGRm?=
 =?utf-8?B?Nno0Qnhud3V5K01xQVB5Rzd3NWZzcUZyb1c5SWtINkhqMnBrWVgwa1doSjJs?=
 =?utf-8?B?Q1NVd2FzVHNZWHFWS3RVdVR5cmJabjdWcXJsMVBweVg3VlNDQUlQaW0wR09w?=
 =?utf-8?B?bGd4UGwxeGRpWWhQOUg0MVJDeXpwMDM3VHBLbit6QTZIR2phSXd5K1lSSzl1?=
 =?utf-8?B?QTZJYUlseS9zZ1cxT2dOK253QU92Q3FHSm1rbi91c2VSMTZrUmFFZVl6cjAv?=
 =?utf-8?B?Vjg5ZFVVbHFGUGZBTDBNYXByS1BTM1pPeisvK3Biay8rVE85NWNnQWtLYWZw?=
 =?utf-8?B?LzhtS1BERXJyMFErVWVndE55ZEtWVnZvQW1WSUJsb0FpU1hTVWNOWlFFa2tV?=
 =?utf-8?B?T1NLMmRKZGhqSGtBdFVnQjZBYkd6bk5KWU05RVJuZzFYbGw4YzV6UW5XdkpL?=
 =?utf-8?B?UTdzejREbk1YQnkzemQyUHkvSGtLM01UUHpibUd0ZURzcktpd1hKYjZVNEE3?=
 =?utf-8?B?VGM4OURMMkhpSERkV01rSlpkT2Z3c2tLMHhqUzdCeGg5MklXNHlRaFhOY2dV?=
 =?utf-8?B?QlBrY2hJL3FJTDlWQytYak5rTE85MUFzZ1d1OW5OQk1tbG9sUmdrTTFwY21F?=
 =?utf-8?B?NXkySkI2RFo1UjN2YU5Ea0VDclFwTjZpK0lvZEJzM1E0OXNsZmZyLzhrWkMx?=
 =?utf-8?Q?qSagJI?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MnZXVGNzVE9mUXdUQzNNWlBDRUJ2aTB4MEl5VzZtbVQ4ci9IY05NVVU0bVdT?=
 =?utf-8?B?OWpETC9VUkR1Z1RlalJvcWhpNXAyb2tWc2N3Q1JDUTl0ZXB2Vi9ua1RUZHc4?=
 =?utf-8?B?MDl0alp3ckhBTGR2TSs1d01QTldnNnZmVWxpdUFaWGpFdTRwUTlFcnhSNWRn?=
 =?utf-8?B?WmNGN2RXQ0JnQWJsdzVnWFRGOWF1NlV6MXVVS0hjMURCSEJINi9BejN4dmtn?=
 =?utf-8?B?cE51U1I3UTBQcDg4VmZQeVRPN1FYdDR5OHRGQUd5dTIzTmhVajdMc1hBR1RO?=
 =?utf-8?B?Z1hmOEdybUI4NVk3V1V5bFJlYkxBeTBwaEVIRnl4L2J6QnhKdFFZV0ZoWHZL?=
 =?utf-8?B?WUZ2YStpV1oyckdxUjNVaHhiMmpjK25JV1pRSTVKaCt3a0FLRmJ1Rjlwb2lw?=
 =?utf-8?B?U3BDNE5TblJjaXVHUENlUzdkU0lqTWx4ZENNcnpFYVgwQlRHRmJudlUyVWUv?=
 =?utf-8?B?WHB6dWNFTlQxQWt0RU0ra1d6N0dBdVY1U2k0cE9CQk9pTk1pSkxHZnl6WGUv?=
 =?utf-8?B?VXZ3M0c4b1pCcjMrNzllSHl1dXQ5UllGNERSVERtTzIyTlBGcnFrdWgrK0pG?=
 =?utf-8?B?SEI1K0haNjI4MFpuSHczY3dObzR0OXJWWmRtUmxEeVZDMnRrQU1rdllhY3JO?=
 =?utf-8?B?Z3ZhUTlLTGNJNElaTnVyS1JNRmo4R2M4dk4yZlJzclhhSjdORjZvd2FQWUFy?=
 =?utf-8?B?LzN6L04vV2xaRDZxK1lUSW5nalJhZEpDTGtnU3FnQ04zbURiTE1uQ1ArTkZl?=
 =?utf-8?B?dFhIaU5LZkxyRjlET2VNWmkxL1l2c3FObERCNGtpdEt5NlZ0NjVjUGcwSlVS?=
 =?utf-8?B?U0NiRys1SU9Vb0NQYlRFd2dmb0FoSjEvZ01YWHUwcWVyTis4dk1JRTlWNWlz?=
 =?utf-8?B?aUxZQ1haZ1Zod0k4VWIxYWpYd2ZqVUI4ZGVCMXVPVVdrcVlvQWRJMU5qK0l2?=
 =?utf-8?B?YVBYU0FMRmlsS0xZVk9iYTNubjFQSkFiVW1lMldTMnJUQkgrNGZQcm04SHNI?=
 =?utf-8?B?anBtb1k4SzJ1b1ZjWU5rYzd2MTQ1R1JNaHBkRDRMbFJ2TGZvMmlEYndRRTQ0?=
 =?utf-8?B?dHoyNjhmOC9kSFJERHRSVUZWSEJpWGZOT1RtdVBtcW5CZTJUblU5ZFhhUFVD?=
 =?utf-8?B?N2RHV0N1U3lRSnd2R1EzTk5zZG1OYlUzcEtiQUpOdEZDTGNVUGQveFFtb1dn?=
 =?utf-8?B?ZEcrSTRiakdLc3BReUN2dGl3dS94TWZQMWQvamlyWGdVYXJVVzFsQUplaEVL?=
 =?utf-8?B?TXYvT3RSSGY0dHNQcVdRQk1TVERZYTdnR01OQTR2TDRuaWFUOU1ocW9rbmg5?=
 =?utf-8?B?dmwyZDBWeCtscFN4bWJ3RnVnZzk5bjArT2V1YnhKcjg2Z21rY1ZsY2t1VnMr?=
 =?utf-8?B?bDJYalNmNzVXY3owNHYzdEtmbm03cUhXckFHMjYzVFZrZjNiRW80ZVpvNHln?=
 =?utf-8?B?NmVOUWcyVjZoanFneU9DMlRaZFRRRlRzRVY1MklhMXdUTEVNeTlNM1pCQ3Ra?=
 =?utf-8?B?Yy8vTXFFUlpUaGZBUmFQUjU4MzQwVGViL1pMaEwvRnFCd04yeDJqdXM4OFRw?=
 =?utf-8?B?L3lGcm5YVlpFaUxPbG5VVkdRNHA4UUF6emp3OHBVaUhIMzFjN0FwRmM0ZWc0?=
 =?utf-8?B?QUxCc2hwV0ZZS3gyNG5kWEY2ekhUWFkyNTZNdG5Yd3NnUU9QVWQ1ck1WYnlM?=
 =?utf-8?B?RjE1MVpjejIwYTJ0WlhpWlpxRFRBRTlWS0N1MTBDTHJXTk9aVGd6L1kvWHds?=
 =?utf-8?B?R0VsUWdlZTZKQnMraDhkRUFrOHNRYmc5QXRiSU8wUkJ0eWdiMDJWQnRReDhj?=
 =?utf-8?B?OHZpZXdkSk5PcmhjMm5GYUg5K3NCNzg2M2l4UUNpZCtYZFM4N2lKck1OUXM5?=
 =?utf-8?B?ZGJ6eHNiOEs0Z2d6QnVDVDYrUE4yNEt2OEJxVUtYMXFpOFJET3pRaWY1SFNm?=
 =?utf-8?B?cXZXYXI3YklrUmNTazdNKzNlNjdlT2w5bXN2cUhlbDV5Q3N4T2k2a3RrbURn?=
 =?utf-8?B?WlNOU1NxZ1F3ajlmZkpySFEwMlg0RXZYaXpDSEZ6QUgwMGMxcUxMY0w0ekgv?=
 =?utf-8?B?bnJSczk1a3lzUXo0UElaNU9zWDJZQW5OTFhsNGY4cnZtN21BMmdqKzRpaC9M?=
 =?utf-8?B?UGNSN1Y3bkxaQVRHbGdsQy83UzdSZmI0K3pjakY1UjUvZEU0c001dE9TRFFn?=
 =?utf-8?Q?K8d0ZOc8YGBNWMsDXFMakdXLj6vLP95rpctq+oGo72VW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF1ACF2D30439247AB4A7B682AA0AE83@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cadd6a9-530e-43d7-2525-08de25a3dee1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2025 06:38:08.2184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: svNeUvCB9iABopPMa5DHp7qtfTQr6g/+nGb5fSHcir6udb0HodxhWlxViR9lblrXOrtgo19SKE8dLxV6++qgLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7632

T24gMTEvMTMvMjUgMjI6MjYsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBGTU9ERV9OT0NN
VElNRSB1c2VkIHRvIGJlIGp1c3QgYSBoYWNrIGZvciB0aGUgbGVnYWN5IFhGUyBoYW5kbGUtYmFz
ZWQNCj4gImludmlzaWJsZSBJL08iLCBidXQgY29tbWl0IGU1ZTliMjRhYjhmYSAoIm5mc2Q6IGZy
ZWV6ZSBjL210aW1lIHVwZGF0ZXMNCj4gd2l0aCBvdXRzdGFuZGluZyBXUklURV9BVFRSUyBkZWxl
Z2F0aW9uIikgc3RhcnRlZCB1c2luZyBpdCBmcm9tDQo+IGdlbmVyaWMgY2FsbGVycy4NCj4NCj4g
SSdtIG5vdCBzdXJlIG90aGVyIGZpbGUgc3lzdGVtcyBhcmUgYWN0dWFsbHkgcmVhZCBmb3IgdGhp
cyBpbiBnZW5lcmFsLA0KPiBzbyB0aGUgYWJvdmUgY29tbWl0IHNob3VsZCBnZXQgYSBjbG9zZXIg
bG9vaywgYnV0IGZvciBpdCB0byBtYWtlIGFueQ0KPiBzZW5zZSwgZmlsZV91cGRhdGVfdGltZSBu
ZWVkcyB0byByZXNwZWN0IHRoZSBmbGFnLg0KPg0KPiBMaWZ0IHRoZSBjaGVjayBmcm9tIGZpbGVf
bW9kaWZpZWRfZmxhZ3MgdG8gZmlsZV91cGRhdGVfdGltZSBzbyB0aGF0DQo+IHVzZXJzIG9mIGZp
bGVfdXBkYXRlX3RpbWUgaW5oZXJpdCB0aGUgYmVoYXZpb3IgYW5kIHNvIHRoYXQgYWxsIHRoZQ0K
PiBjaGVja3MgYXJlIGRvbmUgaW4gb25lIHBsYWNlLg0KPg0KPiBGaXhlczogZTVlOWIyNGFiOGZh
ICgibmZzZDogZnJlZXplIGMvbXRpbWUgdXBkYXRlcyB3aXRoIG91dHN0YW5kaW5nIFdSSVRFX0FU
VFJTIGRlbGVnYXRpb24iKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZzxoY2hA
bHN0LmRlPg0KDQpMb29rcyBnb29kLg0KDQpSZXZpZXdlZC1ieTogQ2hhaXRhbnlhIEt1bGthcm5p
IDxrY2hAbnZpZGlhLmNvbT4NCg0KLWNrDQoNCg0K

