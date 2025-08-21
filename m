Return-Path: <io-uring+bounces-9231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26DF6B307D1
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 23:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C754A1D052BA
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 21:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F5B22C0279;
	Thu, 21 Aug 2025 20:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RashZiWu"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2045.outbound.protection.outlook.com [40.107.102.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB6926D4DA;
	Thu, 21 Aug 2025 20:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755809414; cv=fail; b=FSZ2gppS7Lvg2uCh8FaUAiSff10+5TjngWJyj8duB+UL9TFpIJ2hbck5emnYiASo4JHCNq3zkdyCcZWgsLkN+zITBVwhmaZ+zOpmKVduw+WB7eUu2FI7+1bzoUcVwqzznFHrb+SS5qyyWFNNIHYtJMiPA1KKVgPxmFp+5AbMa9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755809414; c=relaxed/simple;
	bh=ANoxIh5po9vKyS6gOuQ3mp5a4aumlqxvVtFKldQU7r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ondjy8vNcWOqUQJvZ0SHs3nB4pyzszrqkKutMiCvzgMKyvYf+/jVzKoBSZytYu4Qza4QrI6Q+vtklad5sa3vj0mONnUnO7N9Daix+Z+3avzJgYlIaMaLQswoCDTpwVj4fAMxGk86OlrwX3DATUfuiYj6fd16q9abd6NXK3HnklU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RashZiWu; arc=fail smtp.client-ip=40.107.102.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jv29gyhlOqIKKyjdfIcLQNUfbs9KIV1UFSQyNWGXSIBWpZldM1H4/wDaRF4ae/Ed1TwLToDCXNfUQ9VQs/penAl5HrRctja9rWBtof3UkQaosmPKp5mqDEKkuDGs5+FL/aC9nHUyS7Nloun5SCu5dE6M7CabyTksBKM8xA3iSuxl8t2lF+peTS1mdhpX2DzUhiQYwn+rHXw2s0KOpNRWXp3HrvRJslyik5REDhmbWx+9hZ6aVe5S67wlGvrjlQM2m5w2GvPvv9sb+Uj2JFMHnPQCvMOTmHzzy6v35utj8SjsNzwAp8lb92mQX04b01StywQy/Oc8Kg09OB2ig2dkwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaWqCGDDt5NRP8J/pjy+dv/ZQBY9IHdb/gV+gM5l51w=;
 b=cnfM1TOtZUeug6Onyt7JadcSZzBY3jjAXM2wKUYg2BV7EOjz+odooel56nQz1CYsGfJpykRAqRwvyegHZKe7R5QL5vuxPlMZdcGJ9udSOB+NJVlbN0hgUY4swVaiXiJaG9rlnCqAkvFiGvP4CJUfmjVhR5n09wE+pdZMijtCUe3kxjsEQ06T0PLLGyFT0xIxJjjjx5lR6/CA0tXIZsecg4AAkI6WY7ac+DHj6l4HHbfbwHJeHTOBVvK+ST536tillvdNAAVVtU6jVfYHJ37SPP6ml2mb33ATTlLtTlZLasGiB6fvn++8HdUOben87Rr3bKQ4Yyu7P8sI5BgoA/rDpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaWqCGDDt5NRP8J/pjy+dv/ZQBY9IHdb/gV+gM5l51w=;
 b=RashZiWuQQTrTNdUeRetwwr1v94biX+dudHhS6rcKorCUg6E59+6tRyp/a0tROPo/hd9l9wSSLVfBKZOYgX48jfwPGcdXIJ+P4gnbJj6AQ7cEvfO5d/4O9PWfIeIaeC1J+cvV1ks/NiNkX2lMvA9CaYEnKdOlnuBxYynAqyoIouBAoI9IknRVnVVpvEu0QLzdy7ZKbh8q8nKwkKw4trNfZhIqaF90LrU+li9+HXVHyELbgk+dbNcqBrUva//VPga6RA1/CaXX0dB5si4EBh7GDBJ601ZS0/MD5VLXSQLMzx9GrHm9EZN6Kh7SG9IxXNmgIdoUD03frUbk+RD1rivhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM3PR12MB9435.namprd12.prod.outlook.com (2603:10b6:0:40::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Thu, 21 Aug 2025 20:50:09 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 20:50:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH RFC 12/35] mm: limit folio/compound page sizes in
 problematic kernel configs
Date: Thu, 21 Aug 2025 16:50:03 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <48255144-572E-4BB9-BBA0-D446DCBA8D75@nvidia.com>
In-Reply-To: <835b776a-4e15-4821-a601-1470807373a1@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-13-david@redhat.com>
 <FFF22E91-6CA5-4C8F-92DE-89C22DB3EAD7@nvidia.com>
 <835b776a-4e15-4821-a601-1470807373a1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0555.namprd03.prod.outlook.com
 (2603:10b6:408:138::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM3PR12MB9435:EE_
X-MS-Office365-Filtering-Correlation-Id: 798f03e6-9387-4c08-378b-08dde0f45099
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?blpVVnViT2VFRTJHY2UzdEVidGRGdmdHeGVCY1hUN0cxSHVSalB1Yjl1UDQz?=
 =?utf-8?B?NS9Ea2lYZFNwanVmUnJVUnRLQWgxUWNtL3doRnB4ek9iRFFHS3dyVmt0aFdY?=
 =?utf-8?B?eHdaZjZvQ1lPTDhMWDRiUFBEa2xVUW1QVXpXVjhQdFp4QUlmRG5VZzh3S0Uy?=
 =?utf-8?B?STF6YjFKSVpvRW5Va1RQMS9lNmtlVTZsTHdSM1hURmtyTE5UMTdnSDZ5Wnpy?=
 =?utf-8?B?blJaZld1ckJDYlg4SDdFNzRveEE4UVFFdjE3MDBXMkcrWE1JMW9wSHNPMFFa?=
 =?utf-8?B?WmM5TXRQNk1YK2xDdjZnTjhJczdGbnVqakprMXlrUGhWOTBPU3pqR3pJSElP?=
 =?utf-8?B?UmJiY0lZOWZnRlZNWnV4TGE1dzdnaFlSc2liK1hUQVpnMjBmcHVMeWVKb2hj?=
 =?utf-8?B?STNUd1ZzNHo4Ujg2NzBYZ1RtNU5ya1NvcFZtUTArOEJSVDE3eFlTa3JCUWJ4?=
 =?utf-8?B?OUZKRmdGQ0lnTWVmWnZiV29GbnV5MWJWcE9XTUN4L0RJYXpkblRrL3hOKzBr?=
 =?utf-8?B?Ny91N1NCUHFsYUtibnJRYlRCaVQ3a3JWNnJ0NzRmTkNwRk15eU5kcFVpMVZI?=
 =?utf-8?B?dGlOYTIxMjdWYnZPZ0RPa3VYd3h1cklUL1YvTjRaTkxSTG1oRnZVSk5WY1ZI?=
 =?utf-8?B?aVZKOGlWaXJZdGdNbVdPY3Y1bHlaRjR1Tmp2K1lXY1J5VUhwZFc3VWxDN091?=
 =?utf-8?B?d2hhRXNhRG5qNW9mckhuK2xUUUp1VXhwdnF2VEp4b05SVitjYlVQNjhYOWt6?=
 =?utf-8?B?Rml1Q25yMEpJUitORzYxRlhzWHpaNXRtNklxTmlybkd4Uyt6WVpHNnZ2Q2R3?=
 =?utf-8?B?dlFtbjJKcU03U3drbGhodUlEQzJ2V2tNRzhVZUpZOWpzQzNrSm5obG5aY3ZT?=
 =?utf-8?B?dWlVMjhCNmNDanFSVGZXYmNjajlqcXJScS9LVVhiQlllVjFUL3B0T09qdTFM?=
 =?utf-8?B?SEJLMlBxODMyc0FSR3pxMXZVOFF0dm1oNzJ1WEJCV3dBSzhZTHducUVVZWxi?=
 =?utf-8?B?TUtEVTRDNU4vSHREMm9KOGVvdjRiWEJMSXUxME96WURNRk5iVWhOTGkwN0RS?=
 =?utf-8?B?b0o5U1p6UitOKzdCb2hzL09lOENkWEN2OW5KaEF6T1N3Q2pHajJZK205MGQv?=
 =?utf-8?B?b0RvT1hRVi9TZU9HUTRmcVhHdkZjaTVLTHpEN1JiS0NWQytiOVdUM1F5MnQ2?=
 =?utf-8?B?ZGZUbUphNHNvQzBMZi9EUU9CTC84MTNWOW5tL1FZSWpRbDFlNVc1cjJFdTk5?=
 =?utf-8?B?dGJMS2FmV3BDSzVFZkZ4SEdrZmhYVGJXUWF1YUdHYWRzd3k2T1NkMEwvQ3FL?=
 =?utf-8?B?YnQ4ek5Ob1NZdENMQ0U0N3ZibWgrWDRRZzVwRE5YNElBTmwzQmFwSHkxRkpy?=
 =?utf-8?B?NWRPdW9IZ0FXN1ZLeDlYYmdPa2QxcWhBKzh5N1RQZ281aVBPSUZtb3hadVVv?=
 =?utf-8?B?VXFXSy9IbmROWUlwdngrUGxRTGhueEZHMWdyY0phTjBIbzFWNjNHcGZ0Rk5z?=
 =?utf-8?B?Yk5ETkk1bU45VzMwWXdnVm9HbG5ncHFOa0hZaUh0TDcyTnUrQklTUWFSb0o5?=
 =?utf-8?B?VzNEbmgrL1BkdnVBOHZheTJtdS9pcHNJQlI3YVI5V21XSGNvcElsek9kWVNx?=
 =?utf-8?B?eHRHcURlVXUyUmNVcFFCaUlrRHN1dllqblROL2FFK2lZTVRlUmxmUTEvNk5y?=
 =?utf-8?B?TkVvdU1wSGlraFM4emJtalVGWmZZNkRiaFZxQTVJTTkxc2p0WGN5VElWbUxG?=
 =?utf-8?B?MzJPb3A1TEdGb2F1bWJyMXRwVnhSMkhBclRsZ1JZYkdGZUplTkxvdWcyRG41?=
 =?utf-8?B?TmdFNmRDQUMzcEF6dVJvWWEvSjc2Q09YSERDS2loZXN0OXFlTU5PczVLZ1Yv?=
 =?utf-8?B?Z0g4WHF1Y2JCUHpsTHFpc24yOWxNc1VMcVE4Y0NoMTllQWpqdThSUXpraEMv?=
 =?utf-8?Q?4apbzu0c0LM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1IrUlBQd3ZJN3doVzh1WHFsdHE0TXI1aXBITGJ6QlFpNWljNUx3Nk9FRng0?=
 =?utf-8?B?aStjSjh3V2RFNVBDK1JCclBPR3JFZUNYNlVYSjZaOVVZZVZQOFNCTmpQb1Y1?=
 =?utf-8?B?b3E3VVltRmV3emV5TTdaTzZDK0MxNHN0b0ppZXRGNkRBNkZEaXBKNW5JZGNv?=
 =?utf-8?B?VUVoclJlNFVMNGFDQ0c5ZXN5bkZLL2ZNaldyZ2UxWjViaVA2VlNtbjJRT2hU?=
 =?utf-8?B?ejNZaExVNTI4MTRTSkp5THlHS3VSRjF1dmhwbjdhMUZsOVJZVVkvS0JGcUQw?=
 =?utf-8?B?NlhDZkttQTd5L283RXdodVVIQjlNMnFPcWJnTnFvUXBnbXJ4ekRmMVpQL0lh?=
 =?utf-8?B?ZEZWcURYa1o4NUxndU56bW12VGl3aWtrdS9ENmdmTk41dTcwRDlSUC8xUWRJ?=
 =?utf-8?B?dmR1bktQSkNvaDhEMWlPQ3NiMXFhS0tiUmJvL3h5V01na1kreS8ydWNKTUpn?=
 =?utf-8?B?MDZZeGJkRXlOc1hYcVhCVjVYVzFIQm1HQUIyMmtNTVZaN3M5MlJqRFg3bXlL?=
 =?utf-8?B?c1poVk9ObENVMTVmM28wZjlFMmxyZXE2R25zNllPeWpHdFMveXp4TTd5ZEoz?=
 =?utf-8?B?eEpla0JMbHczcm1SdTJtbmJPMUhZbW8vT2xTUTZ5YmpxeXhqNnppRVNpZGhz?=
 =?utf-8?B?YjIzWHIwcjhFZUdXbnZIZVBKNHFtYURZVW9JeW45RERMYlRiQ3lYNXYxTCsx?=
 =?utf-8?B?b3lXT1BQWS9sV1BTMmhBS0FOUXcrd3Z1ZVF0YWJVenBkd25kbEFsbXhPc3VZ?=
 =?utf-8?B?OUM5V21PdGllZERPNWExSkRhd3drZ29rbE1MTHlUTGVZVXBuNmxyUitCWkpR?=
 =?utf-8?B?MmVGeUZSUm1WUm5YVUUxZDNnRlNkYVBLQm9LbE1VaEdIb0VRbXZoLzZ2dGl1?=
 =?utf-8?B?UnlqQzlkLzVXc3MzRnE1SzRUaERWMnFqNEd3Y2VaWWF3WmN1ajh2Q1UyZ1R1?=
 =?utf-8?B?UlIySUtabXJkS1JjeU8yd2VlbHF3YmZ3ejJpTHZlN2NmcWtFTXNPa0Z5Q0lJ?=
 =?utf-8?B?TEZpeHlsYXd2djRWZHRRUmJGaHVrZUZTcG52dUJ1SzU4RkpsYXF4UGdxa1Bu?=
 =?utf-8?B?RitNZUo5L0FZV1J6ZUhTdnRlbDluV2dsVzVFL0s4Zm9ZZXM2cHpOS0JuWkpZ?=
 =?utf-8?B?M0ZwWlRmeVI0UTdIYWk0cy85dTl5NXlycGY3L1JvUnBLZkhpZ1Q1MkNWZkpz?=
 =?utf-8?B?WFVRYytIUHU1aC91U2p4bEd2bE1hWi80NXVnclVYLyszVEJDOWtacnA0cm5S?=
 =?utf-8?B?cys3NjEvWUZWQUZFY1k4Ty9vTkNmZFpXb2c3a2J6RDVKb2lvVjY5OU9uRnll?=
 =?utf-8?B?TCtPVGhENythQVVPY3hLUXlsdk5YaXY3N2F0Y0gxVmFpSTh2b291QjZQMDhL?=
 =?utf-8?B?VWZzNklpamI3ODJ6bkFRcnpXMURua000T3IvNE4wRWFZaERvWnV0a21wTWRH?=
 =?utf-8?B?bksweWJhaGNZbzFYbmc4bHNGZ0Exd0JJTTBOOWFJSTg2WUtRWVY1LzdLTE5R?=
 =?utf-8?B?Y3dqL3E3QnVWdkpaaEpJVHVNMUluVG52VGdPaTJ2N0RXYVpKTHJDZmk1WUc5?=
 =?utf-8?B?eTZOZnpyajZNSTRiQ0R1dW9hSm04Mm1rNHNNSTl4TmdyNFJLZjQ3amRKWmZt?=
 =?utf-8?B?SkRDNWhFdjNRekVHMkNXTkRIRVZXSTlNdFJ1VWw4eDREWDllRlpGWEh6eFRn?=
 =?utf-8?B?MzBmb1VIenpueE1QTmViMS9zV0pETzJoVG03VlZsQkpUR2wrMkZSb2hGanpB?=
 =?utf-8?B?SGQ1bGtNM3cvVEpsNGpNNmNLajdWTnRKWnkvU1UrQVlta1V0WmlWZ0t1Zm5H?=
 =?utf-8?B?aEtBZ09VVUxPWjZIMDhTaHhHSmZxaWdpUFkxejhQY3pYNzJPOHl1MTAya1lV?=
 =?utf-8?B?TkxDRGlTRlZGbzJ6d0tvREo4S3h4TDl2L1l6Nm45cmp1OFdwdjkzbzE0YUJn?=
 =?utf-8?B?SDRFb1ZWeFY5NmhGSjJYZXlaTDBqSVZxeHlaSFh6SXFra2RwZGJOQUJZeXJP?=
 =?utf-8?B?VWwwWHU3UGRMWDRZNk9PS2k3NTJ1V0Z4aGJWb3RuWEg0Ylp3eDcyVzcxYis4?=
 =?utf-8?B?bjQ5ejB5YVdDcEdIc1huWW80VDJrUmFvVmwxdVUvUGwwTE5XQmoxQU5UU2ts?=
 =?utf-8?Q?OBaHOVWx/XOkY1ARdNpqCjSge?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798f03e6-9387-4c08-378b-08dde0f45099
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 20:50:08.6453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jhJuMMb4pbThoj+r21f25Vc8mAIEZlC0BqgQnnYV4xGZX3QP6F4rd7r06mjsOxf8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9435

On 21 Aug 2025, at 16:49, David Hildenbrand wrote:

> On 21.08.25 22:46, Zi Yan wrote:
>> On 21 Aug 2025, at 16:06, David Hildenbrand wrote:
>>
>>> Let's limit the maximum folio size in problematic kernel config where
>>> the memmap is allocated per memory section (SPARSEMEM without
>>> SPARSEMEM_VMEMMAP) to a single memory section.
>>>
>>> Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
>>> but not SPARSEMEM_VMEMMAP: sh.
>>>
>>> Fortunately, the biggest hugetlb size sh supports is 64 MiB
>>> (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
>>> (SECTION_SIZE_BITS == 26), so their use case is not degraded.
>>>
>>> As folios and memory sections are naturally aligned to their order-2 size
>>> in memory, consequently a single folio can no longer span multiple memory
>>> sections on these problematic kernel configs.
>>>
>>> nth_page() is no longer required when operating within a single compound
>>> page / folio.
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>   include/linux/mm.h | 22 ++++++++++++++++++----
>>>   1 file changed, 18 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 77737cbf2216a..48a985e17ef4e 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
>>>   	return folio_large_nr_pages(folio);
>>>   }
>>>
>>> -/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
>>> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
>>> -#define MAX_FOLIO_ORDER		PUD_ORDER
>>> -#else
>>> +#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
>>> +/*
>>> + * We don't expect any folios that exceed buddy sizes (and consequently
>>> + * memory sections).
>>> + */
>>>   #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
>>> +#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>>> +/*
>>> + * Only pages within a single memory section are guaranteed to be
>>> + * contiguous. By limiting folios to a single memory section, all folio
>>> + * pages are guaranteed to be contiguous.
>>> + */
>>> +#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
>>> +#else
>>> +/*
>>> + * There is no real limit on the folio size. We limit them to the maximum we
>>> + * currently expect.
>>
>> The comment about hugetlbfs is helpful here, since the other folios are still
>> limited by buddy allocator’s MAX_ORDER.
>
> Yeah, but the old comment was wrong (there is DAX).
>
> I can add here "currently expect (e.g., hugetlfs, dax)."

Sounds good.

Best Regards,
Yan, Zi

