Return-Path: <io-uring+bounces-5866-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C88A11803
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 04:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BF7D1889B8A
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 03:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D646B22DFA0;
	Wed, 15 Jan 2025 03:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XPZA13GN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kk4rfbbs"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC07E22DFB9;
	Wed, 15 Jan 2025 03:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736912728; cv=fail; b=Z2tJIoADj7qvru7rmycTF47102twCspA6yWCcbG0+xHvIrQtfm8au/bEAqavTrHUJWXuNORu3eWvkW9qp/j1j/qOwkUfXkDArFLafr2fv5msK+yiSUHLYDCZ6c2WgSXr1O2KorGHyULLtaHRCzIZaz2CyXm6HhosSmXiW/Lkp4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736912728; c=relaxed/simple;
	bh=RoHr9xyWlpFYFlHCmmnFuXUKxKBw9RgyfSo4kwfh+QQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d+eHTXnRcXxVhsjQ4tp3JNbOgAA76NVzhG+dP9N44W2psTux4Jp6aJcSR/PXmVNMzZe5HcGq+L65dK0NIgy3z3GK7li7ttPJlfoUvLgbVzL1xpm1GpS/UTH3tkVqH+E/VQEI/1xmLGbXGRuZavoPwFbToFjCD1HfQCqBHWpEW+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XPZA13GN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kk4rfbbs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EN2vXC014231;
	Wed, 15 Jan 2025 03:45:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=Ye2ZiUEoFagS41PBKF
	H4jaO0Ot2usSp7ce00dioCPAg=; b=XPZA13GNt1pbEY1PKTC/mRddeyV3JtHqib
	pc8xdr1JCLC/8+4vBhVra4SDrlgHOCnYUWEEDYXLLIhi4u5Qy7cB3wIXr4A5gJ16
	Upe85k+gXHLcxY92yBegfUPOIU5zvIe1XBAaILI44yW/VtbwD0wR8/HMg7ZAsI+B
	PDU4FKzxv7UKMma0v6nKu6FzN+vQ4HxYtf4NSyo+GeRheRaSVlQ1C/Yf1Qcmxyd5
	8dzm5SHyY1vObOPF/AVdPkFAj2G6Sdt0KeXZslwcfSqdRQ5sPicwGFzzVxWuq5Jf
	0alwDlwwIXAOrFCtLDEzM4k37K8jmnNiSzxmEf8hxVu8+BHY3uzA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443h6sxykb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 03:45:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50F3V06l040295;
	Wed, 15 Jan 2025 03:45:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f38x0tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 03:45:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VFrv8QhJbUVA3xhP+aLSOQA+SXXPi7XXiU3+VCIfgUbWhnB/x/kgqI+HCHes/7InyocodVB51EzfyulyWE0rftdqWb0O0DS0bieWVI2B15sAjNc8O9QfJDW+EkvkYHhMC3HOdtn/E52h+m/CdXJpuQQ7pwL0uqAz6i2M+8VdnXYT+xSjCq1JfSmRBOAIb3lJ9NK8ogyVOutDLQHwLG7t8Qz7nNAILFwOke54n+M7KV8wHW4IAgwa7WjRsLI25pjo4LaY7z/7FSzVe3Qkn+ta3nGEMvWiKftg2nOtppGI1XHw4aZz++UTUnJX8IIA5A/YOaMGiPCWeU0atj0ni1VNaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ye2ZiUEoFagS41PBKFH4jaO0Ot2usSp7ce00dioCPAg=;
 b=LohfIpZfiZAv3eIwye7D+cWDF7zloh3na0YHYJCrOLoBW03899KC3NWL/bMi8vFwndYyppc5cPxt/wrqS3IQ350rAA7IZn/kzFXemGqbbar5rSm0HbdlCsXIQKDpsAMHzGwTNt9F9AdQRnSaL5GRPMj1VkQQxV/NjbkZ/Kz1GJ4RwLytQjRjdr0NPd0i3p1RN/f9UfvYTL9nukHx/uu1aa5UMX0uG3mJS7OIxpBfLOqFiEqadXiA0fypkWvq9XNvDbCzCsePMyQmautHaToTGhrE6ZcvOoEcbGWFoRFGR8QusgUNqJd27Xzyif3KVgaBrXleQic1oqv0QY1Nis0yww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ye2ZiUEoFagS41PBKFH4jaO0Ot2usSp7ce00dioCPAg=;
 b=kk4rfbbsIygt/FNo2hlSK4c2MQeqRVU+XwzL5mP0vRYdaW8h+mGqRY1Lx1mPbQR9tlGd3Se55GwEbUYf+F3r9xpEOKoQBlfdCChV7yMUW51+UGbB+XNj4uWHHhTAwZfbTKjQfUwO1xGj+ZwMowPU79+aGYWLlARCYAvEyL0e2Yo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH8PR10MB6576.namprd10.prod.outlook.com (2603:10b6:510:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 03:44:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%6]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 03:44:57 +0000
Date: Tue, 14 Jan 2025 22:44:53 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
        damon@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/madvise: remove redundant mmap_lock operations
 from process_madvise()
Message-ID: <vwyuhra3bjcnwxsmenngsingp5gi2xqrazej5eescnuyz332q5@jc5u34qg4umc>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, damon@lists.linux.dev, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250111004618.1566-1-sj@kernel.org>
 <awmc5u2j2jmn3xir2tmmxivxpastptevay5kgspgtembiw4et7@5ryv5dnjzdcv>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awmc5u2j2jmn3xir2tmmxivxpastptevay5kgspgtembiw4et7@5ryv5dnjzdcv>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YT4PR01CA0095.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH8PR10MB6576:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b8d81dd-96f9-422f-d8bb-08dd3516faf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tBFW8Yv+8ZjHQEImEWIlRjfMMyXj1J9JoMdkg+sRvjN339kFjMpKGu7NlXBC?=
 =?us-ascii?Q?Ly4Ep+uyHhfk1HfwAJooFdhL4m03SqIrf7NbdqLFemYWJ1uRbqBessNzp8kk?=
 =?us-ascii?Q?wMuX/1THh0pC0l400C4wyTQLQl8IG4dhkvZPgnlw4UHGk69WDWO1tGep98zo?=
 =?us-ascii?Q?pNuGz6UIPU8bgwuRrkCXAApkgD5refxWPXEQu2ghO6UydPKchfAuEruRNSLP?=
 =?us-ascii?Q?E98fNtMNj+Tis5nUDbhzztZspXVWPyognvvJnIPs3cd1YE1Ijf9fLjYFB1es?=
 =?us-ascii?Q?xZL0s7FBUAEMAZMXZtL+ypuaqkxBd/mziSRfXsLkbAH0LtwbcTCD1kPi2Dzw?=
 =?us-ascii?Q?XXKHxUUGeA3VAArsHkWAxPrY0m11cPzjGdVyF2+1Eyb8+yEUb83gUCkIBPzt?=
 =?us-ascii?Q?ZhL2TR0Excw84ahM49cwdHAGl0UV5Q2AOC0dhW+c1mH32g8rYH3aLrLMt3cn?=
 =?us-ascii?Q?0VBjE5U+PFXga67neBJlhheV64EqNkQH1bT10k82O/H0hHV1K/6ZqUsTJXzt?=
 =?us-ascii?Q?RXNnOUDewd/Y995yhr8SJeEO/X0G7yPDsdzEEOZWC+CoG+wDlP54RB1fjfhu?=
 =?us-ascii?Q?AbqWxFZGu7dYhF+2Q8jpNjLqMNeBMYwvp62OBtXYdcCe5jMSUn2BSzPPBJ82?=
 =?us-ascii?Q?S97uk1icFBfZG2FcLiOGHyINmsErJJSMG9qNqMybzRv/A+zmGjrrQXfDAJ5C?=
 =?us-ascii?Q?1R2u/UIaoyr9o3h4AyuJX5O/sAnWJ2c6bUf8LiPchJWMkjY6hh5b8Dvt+g11?=
 =?us-ascii?Q?WuCZ6hYjzK38D9dxZlMjgCcWsZeZ7rxTusXyVgvjZ235b/zJQqXeh/ewnP8R?=
 =?us-ascii?Q?IzUEQEUdD9bTCw3eBe9pQMYtbsTGPz4/QguflPyKnGCrMO6BFuxICZLEeg3N?=
 =?us-ascii?Q?RM0kd9WBTaTGkB28Dd4AK2RUu8KAZZ/CrVY3BAnwLIv7SzVGE7siIgZ7FUBm?=
 =?us-ascii?Q?MGnUH7PRo6HoCNJ8LlcbV2gP6uMXL419BH9VCeSv4C/cwozphcHpT8Leob4H?=
 =?us-ascii?Q?zAyxpkWtd7xhBzGehOopJ1izX9i9h2hwSOvl6Hsph94XpZm5xq9bQ0rGFfbj?=
 =?us-ascii?Q?IAItqZHThx/jyjTK/UUfqkL+OM26mK0+Mu8D3eH1+PWfmYETfgsds0l7HzOo?=
 =?us-ascii?Q?ym1IuuvxFjLT443l2uHkfNmEnMe/80p+0Iq3/BNZWQYwGbigiXPHGdNQYndT?=
 =?us-ascii?Q?Ma3NS8c2bX9kAvsMoc0xl7IAKZa5Ws2P3rFtYsma6aniMRPSG/aburyRT1qf?=
 =?us-ascii?Q?EJet/+KhrNUSVyGr3b7kI2Mk8kpwkEgmZdiTwFlN5E39NPvEh3/yf/iMDX8i?=
 =?us-ascii?Q?t72YFvlrbTCCqVNZiYa+I5tADXRSRqrOZcG1bl31Q1w3xQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0UjUii6bt6npqHpcenZ/KbcUVKNp6R0d7DejQfBy4argA0kqzv8fOTVVgW3o?=
 =?us-ascii?Q?VPrmhK1uLRBzj/yJrXhFmuM5fS7p83RiI15gCvurC7VYKAzPxDlf+dss0c15?=
 =?us-ascii?Q?LPctdXlbvQQtzwg/qVrvRibA1BUAU5gEvtAd0HjUABu/0io8qpknMvEl+GsL?=
 =?us-ascii?Q?+55CC8mlghUO1wg6vevSxg452qORs3k8GnxlVGdqN5zRVokh5L0ImUSbvvWd?=
 =?us-ascii?Q?jIufWvZki904SdBkxZskSZnFg1wB0hweIcTE1Ad7JZ4/zjvuLw1+Bb278Q6o?=
 =?us-ascii?Q?DgfDUjZfE7ktGpfncPt7Xk1WYU5ol1Ly4CuOvlDgxV232GlzEnA/4ZG4lAd/?=
 =?us-ascii?Q?F7TYR1OPW4Y6muxvQr5/LdXp0EHJjxl2nr+cS1d4KBed3Z4tmvpfMUZ0oYaC?=
 =?us-ascii?Q?QqyBQoRM2bPxFxkaUjl7WuTVY4KsbZ7LKNrjGJYspf3++At533cx6fNbtnUO?=
 =?us-ascii?Q?IBQJIqVN77PfJZDTT67+LYASmDkJlZ/X0zMORzwcZWStw+uURTFSM5e88xy9?=
 =?us-ascii?Q?XFykl7BsAGJY/DLXJQ1OHTqtg15gMi0gofmYbPCYwLbsmpjhydeNdawnWHge?=
 =?us-ascii?Q?M/YU2PnYswk1xuaC1x+hX1IHIAeHuvc+eHlwQV0/adGO9zCNgafrnuT7ewuA?=
 =?us-ascii?Q?D8LibRQpvUjp4w1q8c4HfzKzUslMq6ZRhrWXeGBoypr1QB/TSFOhnY2Yyr6l?=
 =?us-ascii?Q?M+gOkTHWL7L1W95UxWqg4XYNFAuP02w1vS0qc6dqVM9ViNukD3s2FcuIc7LG?=
 =?us-ascii?Q?FjurI3g4/m6+gDVtBfev9wIzoZ/jcfv2BmJHSmcPr5wKCYSkkMG98T5wPufS?=
 =?us-ascii?Q?muBku97qufuf1Igk692YXUwIEUaRRytlrHUSA3jYUrStmRKQoO+z1G83VVSa?=
 =?us-ascii?Q?4wsGTXOhWRIvugaB/D/hmqpsH/RGrywM7ekohIAz5TX6KGue1+DxZIGkMurg?=
 =?us-ascii?Q?bQRfbEThqf3JcNY5BHqbfPRbz0v+Y7OeTZDOmBQQX96EZFjxZt7tSwr2GzAE?=
 =?us-ascii?Q?YbQHRX907scSxeWCoAbOBDBMccRcI4QnthEBteWB1YFNudMZnfoZDVcIVHdB?=
 =?us-ascii?Q?RP++JnLWpq1qJFJxEHwKIXa6wCxahZ0SwdeHrqniQ7AKcESyqNVpPQXPiEdp?=
 =?us-ascii?Q?Anh/QAJThJ7jPSenycIMDfOfweq/NN2iKohdljRhzGZmp+SbmK7QKTM2fKsh?=
 =?us-ascii?Q?ok8bTY1vuPoCorrhRlZTm0RYrCWbDusdJoakJ2kii0XwJmqJ4elHezI32Y5s?=
 =?us-ascii?Q?YB/bg0CyexB1tkr7+kSI7jbZj0P8S5pjICcLlvB2AqQbTiBOi2kVxtiYu0F7?=
 =?us-ascii?Q?k0KgjvZftTatNmsFtjzn10sR1A2HxXgxA3lLCRsDQYuZzHFETMPj8Sv8Fwmn?=
 =?us-ascii?Q?bHbZu/3t4580cwKrJihIjLoq53cB6jeoNdn2KPQZbGhkmfSkiGgNxxJs9WME?=
 =?us-ascii?Q?Od0A/XUvxGMLETkjJ8g3lJe4zN7+oT56jvupnGfd5pjEEsn1asy/JHZlXQCP?=
 =?us-ascii?Q?G7/4/KRYdBxEmhngzZuAyz8acrF/WJbxA08JXM+R1m9voWPqa/jUG6Y9IPff?=
 =?us-ascii?Q?tL1ekxzAUU56EqeHqL/uKzftsRoU94GkCKD6frAc?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4AkMMyehIvS4lLxIlpPfsFRQJIJMG/9cs5b7A8YLbLZiXfhxSxkyv/Hl/SOZWHpk4GrEkRABu29FltV3zvoSXo8YHRn/uThbvg6gU2+tEoCNxTDgRM1UoB44K+4fTTcNZtebh/h4VeL8/L0i5IwwfwJHMbQJ90tF9J8jzlzYOzVw0ZxqQGUJGSylafUdh5zsW+FP6HnX6dvWZotIGb/i6YXiQLIYLY5kV5zEKcPyT7U5AoL5vJQ4236mTeu5+3/y7IrJmdIkqknf4OCpmJBuDwlEO2njKsd0ZMHnBjqBBVgiiQZO/Y0uGbld2F9SmttgQqDcgj6Mtqmu3SJ96yNuKqz69C4BWQz4GPkaGqkSY3UNZ1X3IHzSjiPqzp15hhX/e4vdOjL5JnuF4O0mh20JlHw3d+ppXk1R2Xg8QT07o8uO1o+EAYqf7OkwGJ30Kl5mh/JKPQFDXcXD6feBiSDE8j17tBiOcdqHKfmph/FkJNohsPRHTNvmHE2T8PnsezJ8OEUWKk0HI7g7zsWj5l/Rlivk4WlgIrOVjzrHYauyu1N9Nc8+tJvP6RLFa+6blR847EXnvFDz1AvddJZYovLSZuK8CXhqcv/lZOdCWz/pHf0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8d81dd-96f9-422f-d8bb-08dd3516faf8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 03:44:57.4062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMXYCznJV4+fgReLJjTfHgM0Li5sWguFZl1sB8GD7MGP538Lv+QWEyAfeRhIRaDT39Se0xyMR5i0cjgdeLHevQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6576
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_01,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501150024
X-Proofpoint-GUID: AVipsgVXc-Tzi-blIdYxlMWd5q87ypIK
X-Proofpoint-ORIG-GUID: AVipsgVXc-Tzi-blIdYxlMWd5q87ypIK

* Shakeel Butt <shakeel.butt@linux.dev> [250114 13:14]:
> Ccing relevant folks.

Thanks Shakeel.

> 
> On Fri, Jan 10, 2025 at 04:46:18PM -0800, SeongJae Park wrote:
> > process_madvise() calls do_madvise() for each address range.  Then, each
> > do_madvise() invocation holds and releases same mmap_lock.  Optimize the
> > redundant lock operations by doing the locking in process_madvise(), and
> > inform do_madvise() that the lock is already held and therefore can be
> > skipped.
> > 
> > Evaluation
> > ==========
> > 
> > I measured the time to apply MADV_DONTNEED advice to 256 MiB memory
> > using multiple madvise() calls, 4 KiB per each call.  I also do the same
> > with process_madvise(), but with varying iovec size from 1 to 1024.
> > The source code for the measurement is available at GitHub[1].
> > 
> > The measurement results are as below.  'sz_batches' column shows the
> > iovec size of process_madvise() calls.  '0' is for madvise() calls case.
> > 'before' and 'after' columns are the measured time to apply
> > MADV_DONTNEED to the 256 MiB memory buffer in nanoseconds, on kernels
> > that built without and with this patch, respectively.  So lower value
> > means better efficiency.  'after/before' column is the ratio of 'after'
> > to 'before'.
> > 
> >     sz_batches  before     after      after/before
> >     0           124062365  96670188   0.779206393494111
> >     1           136341258  113915688  0.835518827323714
> >     2           105314942  78898211   0.749164453796119
> >     4           82012858   59778998   0.728897875989153
> >     8           82562651   51003069   0.617749895167489
> >     16          71474930   47575960   0.665631431888076
> >     32          71391211   42902076   0.600943385033768
> >     64          68225932   41337835   0.605896230190011
> >     128         71053578   42467240   0.597679120395598
> >     256         85094126   41630463   0.489228398679364
> >     512         68531628   44049763   0.6427654542221
> >     1024        79338892   43370866   0.546653285755491
> > 
> > The measurement shows this patch reduces the process_madvise() latency,
> > proportional to the batching size, from about 25% with the batch size 2
> > to about 55% with the batch size 1,024.  The trend is somewhat we can
> > expect.
> > 
> > Interestingly, this patch has also optimize madvise() and single batch
> > size process_madvise(), though.  I ran this test multiple times, but the
> > results are consistent.  I'm still investigating if there are something
> > I'm missing.  But I believe the investigation may not necessarily be a
> > blocker of this RFC, so just posting this.  I will add updates of the
> > madvise() and single batch size process_madvise() investigation later.
> > 
> > [1] https://github.com/sjp38/eval_proc_madvise
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  include/linux/mm.h |  3 ++-
> >  io_uring/advise.c  |  2 +-
> >  mm/damon/vaddr.c   |  2 +-
> >  mm/madvise.c       | 54 +++++++++++++++++++++++++++++++++++-----------
> >  4 files changed, 45 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 612b513ebfbd..e3ca5967ebd4 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3459,7 +3459,8 @@ int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  		    unsigned long end, struct list_head *uf, bool unlock);
> >  extern int do_munmap(struct mm_struct *, unsigned long, size_t,
> >  		     struct list_head *uf);
> > -extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior);
> > +extern int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in,
> > +		int behavior, bool lock_held);

We are dropping externs when it is not needed as things are changed.

Also, please don't use a flags for this.  It will have a single user of
true, probably ever.

It might be better to break do_madvise up into more parts:
1. is_madvise_valid(), which does the checking.
2. madivse_do_behavior()

The locking type is already extracted to madivse_need_mmap_write().

What do you think?


> >  
> >  #ifdef CONFIG_MMU
> >  extern int __mm_populate(unsigned long addr, unsigned long len,
> > diff --git a/io_uring/advise.c b/io_uring/advise.c
> > index cb7b881665e5..010b55d5a26e 100644
> > --- a/io_uring/advise.c
> > +++ b/io_uring/advise.c
> > @@ -56,7 +56,7 @@ int io_madvise(struct io_kiocb *req, unsigned int issue_flags)
> >  
> >  	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
> >  
> > -	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice);
> > +	ret = do_madvise(current->mm, ma->addr, ma->len, ma->advice, false);
> >  	io_req_set_res(req, ret, 0);
> >  	return IOU_OK;
> >  #else
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index a6174f725bd7..30b5a251d73e 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -646,7 +646,7 @@ static unsigned long damos_madvise(struct damon_target *target,
> >  	if (!mm)
> >  		return 0;
> >  
> > -	applied = do_madvise(mm, start, len, behavior) ? 0 : len;
> > +	applied = do_madvise(mm, start, len, behavior, false) ? 0 : len;
> >  	mmput(mm);
> >  
> >  	return applied;
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 49f3a75046f6..c107376db9d5 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -1637,7 +1637,8 @@ int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
> >   *  -EAGAIN - a kernel resource was temporarily unavailable.
> >   *  -EPERM  - memory is sealed.
> >   */
> > -int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int behavior)
> > +int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in,
> > +		int behavior, bool lock_held)
> >  {
> >  	unsigned long end;
> >  	int error;
> > @@ -1668,12 +1669,14 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
> >  		return madvise_inject_error(behavior, start, start + len_in);
> >  #endif
> >  
> > -	write = madvise_need_mmap_write(behavior);
> > -	if (write) {
> > -		if (mmap_write_lock_killable(mm))
> > -			return -EINTR;
> > -	} else {
> > -		mmap_read_lock(mm);
> > +	if (!lock_held) {
> > +		write = madvise_need_mmap_write(behavior);
> > +		if (write) {
> > +			if (mmap_write_lock_killable(mm))
> > +				return -EINTR;
> > +		} else {
> > +			mmap_read_lock(mm);
> > +		}
> >  	}
> >  
> >  	start = untagged_addr_remote(mm, start);
> > @@ -1692,17 +1695,19 @@ int do_madvise(struct mm_struct *mm, unsigned long start, size_t len_in, int beh
> >  	}
> >  	blk_finish_plug(&plug);
> >  
> > -	if (write)
> > -		mmap_write_unlock(mm);
> > -	else
> > -		mmap_read_unlock(mm);
> > +	if (!lock_held) {
> > +		if (write)
> > +			mmap_write_unlock(mm);
> > +		else
> > +			mmap_read_unlock(mm);
> > +	}
> >  
> >  	return error;
> >  }
> >  
> >  SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
> >  {
> > -	return do_madvise(current->mm, start, len_in, behavior);
> > +	return do_madvise(current->mm, start, len_in, behavior, false);
> >  }
> >  
> >  /* Perform an madvise operation over a vector of addresses and lengths. */
> > @@ -1711,12 +1716,28 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
> >  {
> >  	ssize_t ret = 0;
> >  	size_t total_len;
> > +	bool hold_lock = true;
> > +	int write;
> >  
> >  	total_len = iov_iter_count(iter);
> >  
> > +#ifdef CONFIG_MEMORY_FAILURE
> > +	if (behavior == MADV_HWPOISON || behavior == MADV_SOFT_OFFLINE)
> > +		hold_lock = false;
> > +#endif
> > +	if (hold_lock) {
> > +		write = madvise_need_mmap_write(behavior);
> > +		if (write) {
> > +			if (mmap_write_lock_killable(mm))
> > +				return -EINTR;
> > +		} else {
> > +			mmap_read_lock(mm);
> > +		}
> > +	}
> > +
> >  	while (iov_iter_count(iter)) {
> >  		ret = do_madvise(mm, (unsigned long)iter_iov_addr(iter),
> > -				 iter_iov_len(iter), behavior);
> > +				 iter_iov_len(iter), behavior, hold_lock);
> >  		/*
> >  		 * An madvise operation is attempting to restart the syscall,
> >  		 * but we cannot proceed as it would not be correct to repeat
> > @@ -1739,6 +1760,13 @@ static ssize_t vector_madvise(struct mm_struct *mm, struct iov_iter *iter,
> >  		iov_iter_advance(iter, iter_iov_len(iter));
> >  	}
> >  
> > +	if (hold_lock) {
> > +		if (write)
> > +			mmap_write_unlock(mm);
> > +		else
> > +			mmap_read_unlock(mm);
> > +	}
> > +
> >  	ret = (total_len - iov_iter_count(iter)) ? : ret;
> >  
> >  	return ret;
> > -- 
> > 2.39.5
> 

