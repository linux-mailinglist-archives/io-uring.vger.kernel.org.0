Return-Path: <io-uring+bounces-665-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4923B85B800
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 10:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F405F286835
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 09:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803C763117;
	Tue, 20 Feb 2024 09:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dA3NL+KO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kq1q6rQk"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B57626B2;
	Tue, 20 Feb 2024 09:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708422216; cv=fail; b=MZVGgxh6+OMQKbRE/bSZ91bQNUi1ZHNqlTD0MtbQ9UVTbm21OaSt/NAlSmuT004hpYc+jWfbWxbuEkibxrfUlGGV+88Ny/w/iySmnM/8hifg73jtzwk4QACWpM/Q/w9a4M6MZRpkHGOK07z6LxEWQmn1CTsFTwhdaOwdNsAJv+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708422216; c=relaxed/simple;
	bh=lY7p5/tfEbPYHXnq4Ev4CPrP5KFhhrwaNLTsPbsfWnw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bfIzihAdrB/lvA5OeqMNynuAQfhD8XI/X+5Q8kN9yB4Z3+N6VGvUBetPREBWuaRlLdpDGo9HHdA78igBxKyI2yTfDYHXiXmwGYsSlheqle5Jy4basnEmhHuK+MtB1AGBA7LtuEuNnNDhnQA+mmiyw6Fd+CI+lygBLF2tJAEOx6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dA3NL+KO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kq1q6rQk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41K8wvl4031432;
	Tue, 20 Feb 2024 09:40:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=j5oWtjN/9um51w9D/Q6KHh894pi5FsLj4B61IHxevYo=;
 b=dA3NL+KOyKSvjwM0eCbOyxNxu6gBfm9+TPF7ihqSpYw14ITicbsIC5D7d16s2bqmYQI9
 c34QmH7lIGRSmcWH71et2JBWznOS61d6hjrvZpVDf4VLYv61DDewS0z6WiOe8WHMCmg0
 DRxGl6IULtQxD95ehxZI/3mumyyxWhHNNWCufyXy0QRe3MIYJ2HYI7L9W8vWtJVXh20S
 3nfMldlNoq3J/XDQ9FOI4k0908S7fZ3/3rbsG+VStVl10bFE1Z4BHHBqebF0GP80wew3
 8V5NO6ycLsAXC8YbMnIXnRm2GgKm3ys6q8ZbGu+neOwS4XinY7/JyoLL0Xkjqek86lG/ IA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wamdtx6c3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 09:40:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41K87TAr037866;
	Tue, 20 Feb 2024 09:40:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak86yqvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 09:40:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdFkTsKsDXZf4jK656tf9n9xK6Uqa3bvj2nb+RNe7oKVPF8ShbnaumJdzUY39E81InKAavO782pLr4QGChXIgf2+wogKYe2ZEyGc1LRJmR39wEbpGHIyf+i3Fo7JwpeNt9NNg/lPZjcGS2vVMEmtYajIiHvIIC/w0AnbpZLDTZpI+889vLZFRqzpWf8bIia1UkELRaGWDIcY6xt98zB3mliiYbjPG34gRyiLi5E0nJATSR+eo/CvC4AVxWvIPUa+WgpV4t4UXVjAOReqtOMQ0bBSW8sb3ayJOnrMagTnPe0QVhDFf3KMGDxhFet/KTxrRUKym6t/wbQuRjwgrvlIcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5oWtjN/9um51w9D/Q6KHh894pi5FsLj4B61IHxevYo=;
 b=RMkcRl1I7KY6nvXtWxWzkdpqdAvRfe6MQ/1J8uWtDX6zRQURMFwB6fn7tFdfA4QpLQ5EE/uOczYweUNeim2LUGDTuOiZ58991v7ORORvY/1dnf0auBGsFL3t1qauGo7IuQOG8F/hCsizWrdaw5zq+M6iT4DIyOL+18QfvourxIsTH0VYOH0ZFVJ8GXgzGklL9YLP4HI7b30fTJjqhGlxgSnASOJDdKFmSDJUxjhTdI0hPs1tcakRSyKo+9nuG/Q9bCIZ5UWheuu0DkUV82uHBjaG+l5QDsb7Zlzs3oJ21IMPYsOsSjaH9TuduRVyUzNeohOaKMLyxUeUDJeet2fRzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5oWtjN/9um51w9D/Q6KHh894pi5FsLj4B61IHxevYo=;
 b=kq1q6rQkvDAstm95gtxBroj3PMmi6XGSODpMHWr71UiSt0MLqcPV8UoeaPiCs3h6us5ZSVX6lmwYQ4rPx5VnodLazchwHixIl9AwRl1EC1DQeeu9ujZwsI3PU0bjEB8H1+rtOY7sTbzLor4D/Y0h4VnS6jzizzNzu8qMJ890wH8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB6349.namprd10.prod.outlook.com (2603:10b6:a03:477::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Tue, 20 Feb
 2024 09:40:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 09:40:23 +0000
Message-ID: <bbe9e4a6-c206-45b8-bf5a-8d19a00740c1@oracle.com>
Date: Tue, 20 Feb 2024 09:40:17 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/11] fs: Add initial atomic write support info to
 statx
Content-Language: en-US
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-5-john.g.garry@oracle.com>
 <ZdPWGwntYMvstbpc@dread.disaster.area>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZdPWGwntYMvstbpc@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0246.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: 6db946c6-8e95-4dbf-d6bb-08dc31f7f5de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8Qlj20ED+iwO+rUv1RdWB5C4K2ylakOfoEzUeibvmVL77TPNif8UJxsMo/btBTNMjHYE1XWeFdWqgasm7W1fdKYVcUVkh98JBYA5Z08ZSv3NTiKzzpXzlJwdg2aXpOGtPktjTLe++iFi2ATEbqn4UBpHNvk4cV8dy/11U7eDB5Z0ijwYB2EwCJT9U1S+UHfeW1bc7IekgOHX+acUNdSK0lxyp4d1bOnKPNgP1HpqMs5jM+7DMj5JnL6q/EjY1wXnfCeWx06+X2t3Wun8BRzpLFcmv5dQDd0jIBiTw7c4E+V9m3VQAPxuD/QUNbRYQCvxY0F0Q2tw1YsTvzQzCLLwRzxNnfu7Q8oED+RxP5Ofrp++as+3R1yB3cINOQLMj4T9QB8xFOt0qzd/E353/G2Z2JL9A7Nx8K2jBWiBEVSBZ6hLwtL90M3F9B6cqj3emUyO/NFvxVJZTpU4VQXozkK67ecPveTSFzcqsOQl3QjAzRWLILjlNgfDib5x69HFOE93yzuCkBWwCuP7fjgYSSYoPg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eUk0ZXZsZHFnNGNIeG9GWmtUeTFicFNpdlZsbDlYVW5UK3ExQ0M3a3FtUmFR?=
 =?utf-8?B?OWJ5T0tLaXVvSlJqbTByc2hHYW1VWUZiT1Q3cnZ6NnFOUG1JOGl2bXZqMEVR?=
 =?utf-8?B?OFVXRk5yWGF4T0JpdzBMWCtsQjMwTmlsTVdtaUlOWnVXZ25UTnJKa0ovM1RO?=
 =?utf-8?B?MlFobytVSXc4WEJMcjZUbFlXK21OYzJjRGMzZDhZUU94emtWWUF5UDlpY25k?=
 =?utf-8?B?QW40L2pxQk8rd0lwNEl4ZllKRW1tOWZDMHFxWWFDczZtcGk0bVBabVBaYmNn?=
 =?utf-8?B?N3oxZ0ZUU3VTVXNZUHlzMkVZRS9ITWpDbEFyZ3ZpMTRNcWc5Q2dDQXNhSXhI?=
 =?utf-8?B?NklhQTRQSEFwS1BSOGhwK2h1aVpWVVNaejJKNHozenl6NlR0OXJIQzg1L1dp?=
 =?utf-8?B?MnlEd1ZlelF5NGU4YW44WkJkRGtEcE5ETGRlWWM4elljVm51RXZKbWZaaDZO?=
 =?utf-8?B?U2ZoRXQvRXk4VndmbVJtL2tTYjNDcWZrVFVFMExqSTdId01jMXJFaE5SN3Fo?=
 =?utf-8?B?cWRYaHlWSnhxbkNVWEx6eE51Zy9jZW9ESVNidUNYMjJBdXhDSFFFZzN3dUQ5?=
 =?utf-8?B?ZzZpNm5leXpUR0RBMjQ4bXl0a3NjR3h3dThtdlk4c0NGN0g5OXlHa1U0QXBl?=
 =?utf-8?B?TTNBVTJtcWw2Ukx5RnpNTDNCdmt5WjhUKzI1V0xVZDNXMitzSStUV2VQZWJV?=
 =?utf-8?B?NHhOQUdNWnArS1BybW52aWR2NjN5S0FkbkJCM255SHJybE9hcGEySmNUT2lO?=
 =?utf-8?B?T0JuVFdyZFltaWZvb0xkYTN0VW9lcGhtTVRoZHh0dElZU3NsMGJNR3RSN01V?=
 =?utf-8?B?byt3ZUxYSEJ5V1Z6dTgxcWRtQ3N6VENVSU9EQ0pGaGt1aXcraDdvWkZYWDlJ?=
 =?utf-8?B?bkNNaWhRT29nek9VeUJBTnVRV0RKSWVMNzdJajcwb2k0dkRKZ2VjS3hPN213?=
 =?utf-8?B?ampZb1BKaE5mN1dQTStQMVhZUlhQYmJXUmRrUXU4YVQ2bTR2aXcrMktpT01S?=
 =?utf-8?B?ZFRMdG5TSmNlb3F4NTZOb3NGdkRPUUE4Qy9tdkNhNUpsM1M1MXAvWDNyRzRV?=
 =?utf-8?B?aEY4eFFiQmVVNmdTK1hrbUxzdXg0SnkwajVubzlEcFBpV3FIbVdxem1uQkpK?=
 =?utf-8?B?V04wbTB3Nm51SHFFQWtuMFpkU0pMOG5xYVRYaHEwR21QditkWVVnenp3R3Jh?=
 =?utf-8?B?S3M2azRMdWxMbVV0d3YzNjdpZkVJZ2RxSVZtaFFVTG9ST2d2cWJOQ1kwUzdj?=
 =?utf-8?B?NmU3NG04Zko0T2hlWmdNOVRHWFFIZE9BVEZFV1pabmNnM1A0YUdwNHBOWllK?=
 =?utf-8?B?TkNGdkJTelpUbDZOUzNxZXZLRVZkS3pWWXJSY212b1lnNnlSZmRrMzlyTmtC?=
 =?utf-8?B?MTRwRGgxNFhTOGx4OWVZaEhpUnJmaVFGdGZHQnoxd1h1dXk1ZlgyNEpEcDNs?=
 =?utf-8?B?dGRmcldqczUyL0RFdmJVR29lblY3dGQxU1BxTW16dzRlQ1pzTDgrbnFJR2tZ?=
 =?utf-8?B?S1FQL3hQS2JHWTY5MWxHUW0yaUI1V1d0Z2owclN3Zk45bTVDV2VIdHQwampl?=
 =?utf-8?B?Q3pIdU9mZUU0V1RuM29rZXRrT1hkczhSSzQ4MkpaMUt2N1pvSGFnRHRtcC8y?=
 =?utf-8?B?Uk12TkpKWFdhRTJ5YmVWc3pFbC8vcDBoWXlnajdsbmRSTWRDRkFiMjQ1SmU4?=
 =?utf-8?B?OFYvRFo0Mk5BV3IwakhxelI1ZURaaHpHYS9aVU1hY3lFNFowRmcrMTNKMTkx?=
 =?utf-8?B?Q1ZqVnNvU1BQeFM5TGlPUXFLT3lsSy8veWNINzNOTFQ1bWVJcE5OZEkvdWsw?=
 =?utf-8?B?SkFVZjlrMkRtS3FUWCt2eWt4R3Rib0xiYWdtTkxLUVh0dmhoS3BYMzErZ2ZX?=
 =?utf-8?B?bEFldk9hTjNtSXZJVmhWdlhlZzRSdFJXZENLc3h6UU5jbDJlRDdDMng1aVc0?=
 =?utf-8?B?b2V6MnN1R3M4cVhrblZ0RW1VN2E3cklUZWdDT1ZOWUxrcnFKQmlvS2d4K010?=
 =?utf-8?B?c0pqOVZDdWNGUUkvQ1E3Z1U1KzVKZ2RnOEM0R1VVWEtwcFpIVmtEbHJTeGFY?=
 =?utf-8?B?dXdERVlXL0xGQ1RxWHVUNnVyMVVibUFRMW9LaTR5VlpHQ3E3TEdVWUY3OWhC?=
 =?utf-8?B?NEVNeEdoSjVRd0pVaFBuUkg0UlJ0UE9QMnhSM0FOSmI2OVh5WFBmUzdEZ3RD?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	yoZDVX0psfKeDABPAv+RrGgZ38rf/wYHgYnCA0uMAT7JXkkEd3reNJERblo1d+GwFFK1EPdEchGJ6A0uEgIREnTXtqkff7eyFI7Ma/BUcRUoCuxEbV+vliZfQ+m737fuHZgskSI0uUXotwXshv6FrUVgelp48/ViNA2/tAkccE+rx3FwuiH6jleD3BqW2q3yk2u+J0ZRh2YvzkqnpnGR/qSXP36kn35dJ4+86Agco0jb4XN+dPaJXzJTKqwPuE7fD8XdSESE4Hqj1d5vtG4UY3lkTnOloB7t9F7HKKLmZpnxntU40JDnxk1rqMj5DMKHzJK/hdcRfnpCh685WJFWjp1q9s6xv7IduqBq+CvlS8xGszP47VGBPBwoL8WAUX38Q+62nEdfIEjcnv9rU2ytNiPk18ez1QyGVdVK1dtnWRgtocO+kNxIjFanXJHQW4TP8Ykj+3IiO+Pw5DZNlOSJfV0lZhvdkdHW4AM6mOLAwtY5vLcc6IEunIY8NPzrB0DpN7a+UvhfUww/V2j/oU8/viWDzHNhyk1ZmTloMdB+kC5RRIISnGIVzkL7Pk8RXpvzziQM7gFS6AvIPfgjqQ3I0v6IgcUtBQeA+5f/gLdO/m4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db946c6-8e95-4dbf-d6bb-08dc31f7f5de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 09:40:23.3510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XXywVdRun9BFeB4YJ0LLYiZAo2vMayKt5xkh0IocWQ6uz1ITp0DwQf2wuI5yQT8iTs+PAL93wl5O1u+B+d76WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6349
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402200068
X-Proofpoint-GUID: MP8VTbLtJw16V6jTv26tnEEDWRw7sPAJ
X-Proofpoint-ORIG-GUID: MP8VTbLtJw16V6jTv26tnEEDWRw7sPAJ

On 19/02/2024 22:28, Dave Chinner wrote:
>>   
>> +/**
>> + * generic_fill_statx_atomic_writes - Fill in the atomic writes statx attributes
>> + * @stat:	Where to fill in the attribute flags
>> + * @unit_min:	Minimum supported atomic write length
>> + * @unit_max:	Maximum supported atomic write length
>> + *
>> + * Fill in the STATX{_ATTR}_WRITE_ATOMIC flags in the kstat structure from
>> + * atomic write unit_min and unit_max values.
>> + */
>> +void generic_fill_statx_atomic_writes(struct kstat *stat,
>> +				      unsigned int unit_min,
>> +				      unsigned int unit_max)
>> +{
>> +	/* Confirm that the request type is known */
>> +	stat->result_mask |= STATX_WRITE_ATOMIC;
>> +
>> +	/* Confirm that the file attribute type is known */
>> +	stat->attributes_mask |= STATX_ATTR_WRITE_ATOMIC;
>> +
>> +	if (unit_min) {
>> +		stat->atomic_write_unit_min = unit_min;
>> +		stat->atomic_write_unit_max = unit_max;
>> +		/* Initially only allow 1x segment */
>> +		stat->atomic_write_segments_max = 1;
>> +
>> +		/* Confirm atomic writes are actually supported */
>> +		stat->attributes |= STATX_ATTR_WRITE_ATOMIC;
>> +	}
>> +}
>> +EXPORT_SYMBOL(generic_fill_statx_atomic_writes);
> What units are these in? Nothing in the patch or commit description
> tells us....

I can append the current comments to mention that the unit is bytes.

Thanks,
John

