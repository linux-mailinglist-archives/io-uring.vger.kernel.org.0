Return-Path: <io-uring+bounces-725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5117866FA5
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 11:01:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FBBD289098
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 10:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AEA41E516;
	Mon, 26 Feb 2024 09:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oYLwh52t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zi+/LFED"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19001EEE7;
	Mon, 26 Feb 2024 09:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940242; cv=fail; b=gnbnJqK5fYDnXdEljCq5veAPhzEaDLNrzM1aQ2agDhqgbD/LzP4Gz/kResNwLyU6tpFglKS4+/7bIBlmMqww3ZiMhRus9XeOecjdsV9egEAtG6ZfJNbsTUaTi55rQWsc7Fio297HQKrpNhMUBpj9VsO2ixBPKjHtelfM3h+bTvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940242; c=relaxed/simple;
	bh=GtKo/bWsWB6KfXfQRB872elJmJDr3mVYBB48ntnxjE8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RRw7vbGICdCTXka6eAP3fEV2ddSbOKlBX8ASq+mxi+9szS/J4vEUkD7lczDUmr9I0Y+bXD9g5yNPfvWzneg44hRD4RQS4ypqaYJS9/PMQhHAY09bTgxBEv67+KoVBhiwYr4eV3jUJJPeS8+EslgQBD3L1CmTd/rvpxULFhsxKUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oYLwh52t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zi+/LFED; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41PLPouD023296;
	Mon, 26 Feb 2024 09:36:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=3TRYWIfNGS6y4XOJ1V919ZQwqQr5DaAFS93+LgKgjeI=;
 b=oYLwh52tmAD/LhTVtVidsI068CwYreGGjBLOJhUEvXWxNtwzPBfb9Wbj5M1UjWSOQM5L
 x654+jiLXUpHrsyYr9EiQiC8BGx6me6pwpTU8fkkzCo0H3n8Zs2eSUr9a6pj8Y2IOHqN
 3vHiMUIlsG2kWqYU27cLpSxFpZYdkaImaK8g09t9HZaSSX9VVskHD0R+6y5OX11M2w+s
 n37z33vWNAsgGvqxA+PRo5ZDunmxmO7h9Sl9Yl11Bu7l23QViQC95h9TLnJxExLsaxwg
 fmQuau/Yt1+hTYNwBk+fR3qoEnY88QqfUYTWNC00FHCzRS4/WqyFN1chQg7OkMFToOoe tw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf7ccc3hu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 09:36:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q898ED013413;
	Mon, 26 Feb 2024 09:36:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wgbdh4xy3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 09:36:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amVp4qAkT1MJHeri/jlDR6n8kcKSVmFPW10axgE7FhW182MV1R1ePJ+OVGtgeqoifP3JkYFcNdujgQwsAAlCjaFHrm1ulgJO1lVVAJMRddFz/swNRd37j9Jz4psNVt1zvY4B+sshab/sLEiNjVCNVA/KRJNs2kI/g3QrS3w4pb6hM7P2bqq6Sv8nTVuT7bnfLkb1D7Ndr09UyAlvTedbDGJ1D/mwcw0saKYqNNTc/urFegPUqbgINmveFEWh4BGWwAcyQg+nFVUahggfVxoN4/hgQvJhKrX8wnNMCQbg9D1jRoJ3VDt0E5Cwt1TR7pf2ytkR8vm8ljkVCCCRuL8lig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TRYWIfNGS6y4XOJ1V919ZQwqQr5DaAFS93+LgKgjeI=;
 b=GphS3jidmaeexMiPX+jhlKqLgA4GvlFT9sDUgXk6MAjqkUNBLYjeWwVTMv2LLNPBu4ZWLLoUoXK+OH/0J6eEY+d39bcHWSr9ezBpTX9GAsriPLoAXR5JVAXJdV2PkU+vGwiRNfQyAdQGeW2z7f03D6hLS7b9+xuaZE/WEMyAfbWlMbRNJnZxxa+O/JGqPOtx8ma09wPEsd9D7ZoP5nnuSaFhm0UcaDgDw3q03Hmamv9TBHIZ6ZHpl/WnLdzFpmTN6kmiN9Oy+EmwZJtjh/S8GNYIuRiKN6uG2xqU35wJ7O68tbl8e+7Bz8HzCo0qioRxnnhyiPCsD5Tbp0XIo+6Hbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TRYWIfNGS6y4XOJ1V919ZQwqQr5DaAFS93+LgKgjeI=;
 b=zi+/LFEDlmNV4/HIuuD+a+90HRR4U1UuV3IREziAx7IRD6wQ8wS+WKgqmV8CGpancoJDlj18lb7FM53rH+IAwwVy1iduoULhX5Z4K8X0JS7gPQKlrT2UjNYYjXHfQwkZvNqyHijvCrucG4v2VIZletQE+XyfAvPQRx8HbriIy30=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BY5PR10MB4369.namprd10.prod.outlook.com (2603:10b6:a03:204::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Mon, 26 Feb
 2024 09:36:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 09:36:43 +0000
Message-ID: <85d2aef9-b966-4c90-8602-ba5961efc23a@oracle.com>
Date: Mon, 26 Feb 2024 09:36:37 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/11] block: Add atomic write support for statx
Content-Language: en-US
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, axboe@kernel.dk,
        kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, djwong@kernel.org, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <87frxg1v8p.fsf@doe.com>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <87frxg1v8p.fsf@doe.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BY5PR10MB4369:EE_
X-MS-Office365-Filtering-Correlation-Id: f434f809-47a3-40ad-d153-08dc36ae716a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	GA7HQAmzZ5EMOTK9vPU21wGWgRojJx5frvtE4KbSetBGAuqpvFFUYSz7x/3D9zeMNpBMfB1Wbqa6GxKC2lS3suYyPeUgmAVrD/IIBCsD2GGvCVSKnrVoBhNGysC3arYxI8NxS5OSYCG15h1xUFfeAqE8OU6bSvmaOJn5Fjyfh3fiW6ydHKdDM9PkV1hfecPXBIuFRWRrgWXIE2lOM5R6bEexqVwjkyZkRzEQCs02eVNDP2WJSXJo7fuQA6zC9X/3ux7WIPeRoPWxQCeY6f8sIhnU52jhsOXyppDButbBHm84evfZKzODEfTEX1Xqa+jv+QaDeDTWU+MS6s70pFPXrpNkFQdYOYbdWugfIvO6Bk8fpj5ZAhe9WmWhtEsC9DX7EPuG/LqVTNxTHVkDkYIUIFMeD8gMFUakSTPFBKcSjVbQredYEBqQxtXhC7F+zKSN8v5eKGaXvffIMYqCnXi41GSh0RBQ6vuRYg5UPxP1qbUUU8ERjYOyvRZ0LpeHZFLS1dGmgaphxHfGisNfKDu9PiECGyloJ0nsPSTt+ipJrhREM7bHvAYWMIcXK1ZHsVPjtomni2BlZDzwiue/UKtoRDb3OCqMWlDfAEHERpILQ2SMyzRvbsu11wMCUoyiOVpCiX18Bg4DtC01E8E/oqQgISzPy71huULIqvK2fdXZNMz/SMTLWJ1OcS2GdUJVnk2M5hwLDDwSjKz++inZuSmvHg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?STJzbXVqWm5DTXBUWElGYWhkMW9ESlZSKzRtY2RhWi9VYkFES0dzTlMxd201?=
 =?utf-8?B?ekdYN29RanVBeWplM3FLbENTS05CVDlaSVNsRDVUNFFSallnZTZ1UHJ3NndR?=
 =?utf-8?B?Y3hPVWEyNmZGalBvZFdJM0tyV2pKUjVzbGgzSjVmZERSeHpDVFd1YlVSbDNN?=
 =?utf-8?B?V3lURjgrdVJNNitaS3hHWEc3M2ZQSCtTZDVXZ2hNVW9hWjl0aWp6WG51ZXVO?=
 =?utf-8?B?NkNjb3NVaVlrR2lHREpQR3l6Y3ZJNERaenJHZVdvMXJSR3haRVFxYm54VG4r?=
 =?utf-8?B?TGpDWVgydUpUbFVTZElybERxY0h6dlVWcytyN2pLMnRoNHlrY0RZUVNNUk56?=
 =?utf-8?B?Y1lhWFFSRzdOWFNLTGFLbFFkVU9aRHZRWUpUVmpZQjJkeUFBdmlDOG9DZ0NK?=
 =?utf-8?B?TERoNXV4YVZMODRtb2JtdWNob3VrcWthalIvdDRjT2lJM2dwd2E4QWRsd1lM?=
 =?utf-8?B?bEJHWCtJLzRlZWVLenliM1JRZjgzaDBLRjVycElaczI5WHJoRXEwKytDdGNq?=
 =?utf-8?B?ZWtoeWttYmpuL05mS3F3S2FxbmVmZy9zbjFRQnZkYS9Sa0RNaU02Z0JTQkw2?=
 =?utf-8?B?RkZreVRiN2I2bkswbE85ZjBXUk9xM0FTSDBHK2FKUEN2dll3c1pqMmo4b3N6?=
 =?utf-8?B?b3ZYbkxoTzJLblRpT3NyRnNaa1pLZ1Zxei9qaFNpWTI1Rllnd3NHN2lSS21z?=
 =?utf-8?B?RVUrbkhnWTFUc2FUSnZjbEpTbW9JeitJdWxIKzhVaVFGY2hXKzBqWnMvZk5z?=
 =?utf-8?B?aW1CQ05oSkk4djN5U0Q4Y1MxWGtZcEU4bUlNaEQwZklmcW1TOEd6UVByQWJ3?=
 =?utf-8?B?ZytueE1TUUxzdit2dnR6S04yN1ErdWU5cVdNU05kVmtZcGFNTlRxY0E3blpN?=
 =?utf-8?B?M082eHhBQ29RSzVlemdUU09TcVptU0drTXBpYWtFeWk1ZUd2Q2NxNU9Mbkpj?=
 =?utf-8?B?a2JPMkdwdDMweXdueVJLdDJpS1BwYitLb1EvSmovekhHWWFDUXJUNHhEZ0x0?=
 =?utf-8?B?b1E3ZmlleGZHSDlwZFJyTDc2b0phbnJ6TGp4TVJ6SWRLOEVybVNUcDVReURl?=
 =?utf-8?B?dUttMGRpUkVHM2RleE5EMVFuMk45NmN1YWFHanhmU2tYYVdOZWVIYXZmWUtZ?=
 =?utf-8?B?WHRRYkpua0ZOLzl2MTU0WmdoOW9RbVpkRXBtSjNYQnFNak9MUUhLaG53bWxz?=
 =?utf-8?B?dE12YnhCR05WUnJyUnV3M1ZsZ0Z4U2s0TDF1UG93Qk5mWGI4Y0VidWhoU016?=
 =?utf-8?B?R0xQbmFjbTVKZHRDNXpsajR2bitzMUhYSlJVdGt1UmlCR1Y1SEg1bS8rRnlE?=
 =?utf-8?B?akxlQlNGWUZNNXFoMzRsbUFlTUNoTmJ6cmVtN1JwZ0NGUkJDQzVFRVRndUli?=
 =?utf-8?B?OVIxcHZIWDVjMU5TS2sraE9rUHA2U3FZaGFPY1MzWU5iTEloYlFvWFl5c09R?=
 =?utf-8?B?R2dEckVlRElvUzIwc1pXajM2c0ZBNFVndjAybS92SzRNY3VFOWh5ejZHdmJm?=
 =?utf-8?B?YzIzM09yWWV6Nk50YjVKV2tQN2FwWUhyb2FQY29oVEpYUm9aWnJMRzgwSDhN?=
 =?utf-8?B?b01PNE1ERG9IZ0Z5T3ErSCtFb1puUDBNNlVhK3BCUTRYWHJQRFIvaWtCWWVh?=
 =?utf-8?B?M2lmRUFTSVhSc1ZKZVFsQmJXc2RKeVRURmVVZnNkeUJOa3UxVGZaa3ZqK3VU?=
 =?utf-8?B?a3ZweWdESyt0c2VqNUhDOUFMelhORzJpSnNma0MwZXpMYjJqZGduWXYvSm1x?=
 =?utf-8?B?Q1Q2QnBUZFVWbk5zR2hYWFhPc0xiaWxKbWMzQ3pjYTN4SEFFU3BlazZRdU5k?=
 =?utf-8?B?TGZOREttdit2V3o5T1paR2JvQjVtV1A0SHdtdWZXZUpNZ3lhaDVkOVpzVWMx?=
 =?utf-8?B?UjR2YnNqZ3FRUG9IeGRXUEdFdVZZdnJUdElaU01OR1NGYll5cTV0OE4xbnE3?=
 =?utf-8?B?SzNra3krMGRtSHc5VVNWRGl1L2NhNGVaMHFqcENpaVAwcFhkc3hGejIyZkZ6?=
 =?utf-8?B?Z3pVSVR1SkxtbTF1RW5XUzZSakI0emVLa2t2Mk1YTVF4SG8zUkExeExwR09G?=
 =?utf-8?B?TGNkcmhLU2xOWncyclR3TTR3Mk5hRkVoWUdta29yb1NQN1UvK2tPa0FPUlA2?=
 =?utf-8?B?TnZFcXdqSjQ2WnlIYWRFcjczU1ZueURCTHRITTJCU0JqM3R0STd1V1pLRGx5?=
 =?utf-8?B?eVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cRjW46JyVq1nyfTPRgiqIGu290f/ZudVZwdAkzRHnPuhyktyXc8EHCc0i609B7Rj3WVydEm6EAXRA1vmq4GPPmGZ8U6b10u4NiDqezoUFV8fEkTOHWN1tlrqv8qJW9FVjSMyHxU1I26tUzEXjKW6DlO+ZiKyURmsj9L2bcR7950t4+Om88dhrw5wfsMK23erpAytRCMiMatufsQeC5WZlMQgEYjo9bIogTWZGqz6diGm6gCDBIuCtHNy28BesUpWcP09UWK7JjoURm/qLEo3tW1PePMCMVYb8YV/7FRsN0EcV0dewdnwYJWBV0jjJh8NFOyIZVqIbkMghylj4swI8biuZN6Qts/iVqjLlp2Y/w0n7WWJ8QAP+slvYdIUtW5LZMGQEFCo0HGinDlKebUuB3Ka0KNLZ1ub2bGNiFkC6jYwemK7NngN2BcH4KvTdKNhtyg56T6LIZaT2CQYSkCovq0lhdNoCoMJ7/SVT9L7/cF3Yt7fELYIJDW8BBP+JHGuIndmQ+9QZqSNFW29wpp3lL0JKVQI0wv5s/dEy4pQkZn+fNoIRPW3xRdB4G0Tt1zG5CEfgGMtfj///8tFQNRPxTqtOkuDlhWVLg+3YbWM+KE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f434f809-47a3-40ad-d153-08dc36ae716a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 09:36:43.6623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mXb88wENguKtA0A1TSSjMezPTqPWZ+sZHUx1afRcUWiNacraFacI7z+pxSKoFKvdUgY2m2t7/ytlWVH753jLwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4369
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_07,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402260072
X-Proofpoint-ORIG-GUID: h_N4ZjsXTDfNWxYmC7LWkOSPhdJfF_Jw
X-Proofpoint-GUID: h_N4ZjsXTDfNWxYmC7LWkOSPhdJfF_Jw

On 25/02/2024 14:20, Ritesh Harjani (IBM) wrote:
> John Garry <john.g.garry@oracle.com> writes:
> 
>> From: Prasad Singamsetty <prasad.singamsetty@oracle.com>
>>
>> Extend statx system call to return additional info for atomic write support
>> support if the specified file is a block device.
>>
>> Signed-off-by: Prasad Singamsetty <prasad.singamsetty@oracle.com>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   block/bdev.c           | 37 +++++++++++++++++++++++++++----------
>>   fs/stat.c              | 13 ++++++-------
>>   include/linux/blkdev.h |  5 +++--
>>   3 files changed, 36 insertions(+), 19 deletions(-)
>>
>> diff --git a/block/bdev.c b/block/bdev.c
>> index e9f1b12bd75c..0dada9902bd4 100644
>> --- a/block/bdev.c
>> +++ b/block/bdev.c
>> @@ -1116,24 +1116,41 @@ void sync_bdevs(bool wait)
>>   	iput(old_inode);
>>   }
>>   
>> +#define BDEV_STATX_SUPPORTED_MASK (STATX_DIOALIGN | STATX_WRITE_ATOMIC)
>> +
>>   /*
>> - * Handle STATX_DIOALIGN for block devices.
>> - *
>> - * Note that the inode passed to this is the inode of a block device node file,
>> - * not the block device's internal inode.  Therefore it is *not* valid to use
>> - * I_BDEV() here; the block device has to be looked up by i_rdev instead.
>> + * Handle STATX_{DIOALIGN, WRITE_ATOMIC} for block devices.
>>    */
>> -void bdev_statx_dioalign(struct inode *inode, struct kstat *stat)
>> +void bdev_statx(struct dentry *dentry, struct kstat *stat, u32 request_mask)
> 
> why change this to dentry? Why not keep it as inode itself?

I suppose that I could do that.

Thanks,
John

