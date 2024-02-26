Return-Path: <io-uring+bounces-721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F4D866ED9
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 10:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66308B28FB4
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 09:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20FC86E5E7;
	Mon, 26 Feb 2024 08:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MV1eMR6K";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kTgwfPKa"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C816BFA6;
	Mon, 26 Feb 2024 08:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708937976; cv=fail; b=b1ilQEBj4mkZRR28LR3LYxou9UR168TYDT9Lz2JDdjQInNANaPPBmFLnWp1SiL7hHckbObAecIt/a1AZ489yVRN58dvRpkI+B0ExbX13sy1uUNDlq1fIlw2NxBLWSIJrBWaQ9zm0v/cd4qIjetys4/M7HNpYTy5q8ElFWAelyiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708937976; c=relaxed/simple;
	bh=wQ5PDQP+QnfKtUhsich2XoPT8a++59H/XFKyMZPkpME=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tvFm1CLJokSWv4es4I0y7nsAm5Hg5Ab8gzi+gAEYdvAxyflSA4ENqfZlOAK7FjVy9+YNC8Jgb9pSgm4Z7oOT+6rkQUwRjJ+tP9TF0KwJaZmUMVaCxGo1Ak9gn7McdmFoHaeWzFuk2oWsew3yk9/IuSUv4/y8FZNf+6CBuVYqhTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MV1eMR6K; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kTgwfPKa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41PLb3fh007563;
	Mon, 26 Feb 2024 08:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=iaPbXuJ1sukeRECe9Xf+qU3u+wMqeP1/g8yDFYIc+6I=;
 b=MV1eMR6KjFSFUDtwwgok+LEMym/LOvgTdNH7ATUwMmHQ0xLLJFxyKL01DVIKVR815MnY
 f0AYzx7H/BsB7D91qBFHqVfOGBDWYmHZ5UVVBfqQOmYCXZRK4Aq/DRfA+IBQ/RmCbLCf
 1Pkx5WtHqt6aWgN3hJ613qbfcQpnGw33PQEG7HBW7Efret/4h7bvdlNU+MLKPfASOYOc
 HI3z3gBCr79jRhQs+HQ+IjAJheEmKS4Q//kOxb9YzEukUrtFQjAt7rBlleRSZz0R7urZ
 lnz4crMspFBPYPiDWmthCeV9hchYz02LqezrapXeRwF2SVMpPLAiTaMLVlxo64ljxEl7 eQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf7ccbyx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 08:58:55 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q7QaL4039280;
	Mon, 26 Feb 2024 08:58:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w58gb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 08:58:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvbdHT/C5lhyHBvX1Flru65ySj93ATC2Q04j4fuktjdCMZgRV55xhM6tvBringEcvIJnSopTWQx4tut2KjE/BJxaAecLvyRFhJ+5JME4rQPV2dqdmDQAzvjFYYXTcDITJITbPNWOiCL7Lkp/URoeGbidh4j2b0RdXVc7Wzz5unhf9d4T5GMAhIaSYa2dobbcPQZdzqELhp9Z4YrRksK9uFoTyBZPmUN4QoNvd3psGMbnvbB6UM1gWydKtweQThe1JHTbyZfswjDz5V+EFuoA73VBz1xQvplEJjUNtrQdlEjYFwve6CWNT0HeJ8eVd2ObB15NcPsKarS9T7YlcFlFlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaPbXuJ1sukeRECe9Xf+qU3u+wMqeP1/g8yDFYIc+6I=;
 b=QHy7WKKYeANTomH4Q4Jx61JtDo9J7qWTL9pgzS8Mh40NDBdTs9nqhUa23TZgr1frl94XTBHd/Vv+o0kxBbSRJxRJLgzh6hA0BdeGyKhT8wPF6JxVcWnfgCwI1b2z/RhMI53QCJ6aKoO7A3B3I3vfblXfciCrfKsviRS3dm/CzhubgQUGGH6tsBNiU3YfKR4EpLYxTcMldp2AJTAREWCMH0/3VyYHYp9Vq2oUPpqPcp48RNDs6Ebsdaq1QOwVh+Lx9vSHfltpfbwMZOkLStaK18J042aAW1w+SQv5lgiPNs04fvBpnNuX7qTt2fsJQcZ71EMFbjf6CmmVWAvOug9X4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaPbXuJ1sukeRECe9Xf+qU3u+wMqeP1/g8yDFYIc+6I=;
 b=kTgwfPKa/siMHoLt8QRR/0UMkKMHf/HIhHKEp7YkT90Rf4hx7kdQe8OHix8m0CIOcfT9ApEImJGgYmhLzaPpSytCKxEjtIpaCHcsb7jJhhBo/Qj/SdtUbUcUV5+WvHBIzyMrTPOYc/iBK0Gi9tw/3+z9Wd+Mc0QzItj4n+lwzt0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB7078.namprd10.prod.outlook.com (2603:10b6:510:288::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Mon, 26 Feb
 2024 08:58:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 08:58:52 +0000
Message-ID: <07537871-ab4e-4629-86ff-5559aa88ad17@oracle.com>
Date: Mon, 26 Feb 2024 08:58:46 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/11] fs: Initial atomic write support
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
References: <87r0h12080.fsf@doe.com>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <87r0h12080.fsf@doe.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0018.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f8d20f9-ff5a-44d2-e3d9-08dc36a9276f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xca4fpN4c+Nvz86n39hseKos44N3m5s9Ze65sFomDb8prMeTDgJqs/oSUNmgMxIvXi9/hGeVil5t9dF70WDC2+mP7vcIpojN2imAnR/Gd5mMcbDAOXMOQkIEQNZUu7zc6bDzUt3yYysHmk8epWqchl7Vy9zC+c9UNMQDSj+5t1Lux+qgAQEidPxSvTpAHsLyS26MX2z42VEWOFax+ANS7d87/ZYUaMskgz6ENf92kXI2KytPyGkA7TnnU1hHbYtyQoXs3oo6NiPORxmPUx+5YTMrkIcWAU1nxp+bnjN7jwObpDrg8yMPzQdw5MOFuwkJ1DsxAkDZ80WodsxNb1x/GaKK3QMU6uGgHVzWsBeGhsd599tgC/agZApGozWxvUIpyO/J1UQAvgYejscyIvuX7dWNF125G8VZ5+E53gsnb0yQMlI1xFOM3muK/h/iKnX9Ihj2LBclfy8ZJuut6kolrlwp37nFdvCF1yiJFAw4Iwoga33v5f3DG15yG/J4SuUtyaRTtbOSHFg3V9X/2HHNd6xX4s6ld/qUiQSW46CljHApJl5maeiVeRmOClQhKRsO8P9sVMMqYkZYKTjlappsXeXCvqWj2Dazdx4uHW+GGfHwqxgZG1KEiF2nyY+Y37AXJ9RritoYWfhP3zFpE6il+36gaTo+BzVdXAhgp3vrvhDfvQgL8QW4Fy4lPTEanjMcqjbBFMLNmsMY/QmdoqMGig==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?b0pGMmlGSnJtZnZlMlRORnRHaEdwMENsNTg4d3VJQmhDU0N0QVNyYVVjdVQ1?=
 =?utf-8?B?ZjRhMHRlRGFqZlhqbHd5VFpMRUZ3V0RVSkF6REJoU0h2YWl6eTBEUUVZZyts?=
 =?utf-8?B?YWE1c1I3VDgyTHlpWkVJdTJPNlUvYzlCcmJEd2ozc21CZUpXMkI3UWozSUtM?=
 =?utf-8?B?STlaeWthcXdzc0FQSUlUVDdWYWlKdHozMXNOaGFZSklyWTRpZFRFbkZjN1Rt?=
 =?utf-8?B?dE9Qc0prQis3N2Fjd0NKYUxqbGh3WXIrVjdaY0MrelFHZUFKNEIrTFpYM05R?=
 =?utf-8?B?cDRudEo5WnJzSzZFVDJNbjMvSkFZZkdLRmt4K0dnalI2SHFVZ3BRQ0tNYllt?=
 =?utf-8?B?bnJQdVVSencyYjI4OFpReml5c2prOWRHTjYwcUhDaktBbHFpOXJNSTVUWG15?=
 =?utf-8?B?UHdUVUtBazFNanBGTlpuNUpSbjlOWnZucnNlRnEyc2FSY1poNlhxOEFrakZ6?=
 =?utf-8?B?WUJsVFNVbk9qM1BCSk0rL21JaS9kTnVzd3JHdmd0OVhYL3RnN0todXNMTm82?=
 =?utf-8?B?ZDdQU2MwSFZFbDBCc1VOQVNmbkMyVzZOS2x6ZjA5U3lsSkliUzVhVnpncTNW?=
 =?utf-8?B?VVdNK20xTU5rMThMaUFlQlB2dUVCc1Z4UC9SYnV0aEQvb21QSDRIbkRRY05L?=
 =?utf-8?B?WERCOGZhNlM2N3pDR1pzWUlPQ2ErbG9UZ1pQVEZ3VW9pVk91d0FzMGN2dUlk?=
 =?utf-8?B?TENhUlA2TUN5VTg0L1RRY2RBYUJScTRtMFBlL29GSTFZZ21mRmZTTCtid01Y?=
 =?utf-8?B?WXNXQjVtYm91RW0ya0RscnI2Tnl6TEE3SnhscllyRnllcXY2Zzc0T1NPcUtV?=
 =?utf-8?B?aHNJOHo5SUJWZkt5ajJHSW50MmxncWJJM285a3RPT29ka0tmZ3U1UXlPSXZa?=
 =?utf-8?B?dWwyWG1qUUZvTDBTMURSZ0RVS1N6NGFiVmF2SEdPY2dRSVVTMUw2bU1mSzRh?=
 =?utf-8?B?SUkranRPaUc2VEY3WHFBRUIzTGxYSEE4VEU1Z2tYWVFxYWM3L1Q0cDVZWEhK?=
 =?utf-8?B?RTVoZG83RWRwbkxYZ2ZnMkhqSlB2OFAxMkRyWUovZkc4QzlpRjF2T3kyUE5Z?=
 =?utf-8?B?dGFRaGs4VjhNM1RxSWFkalJQSC9oZ2hhN3JyMHZyM2NBVUlKektFYnkzSUlR?=
 =?utf-8?B?YXkxUzRhTERvYnBqSVdTWTE5blQvSVQwNXlOd3dqckRtaW10akRmZ1hEK29k?=
 =?utf-8?B?STd1N3RyTDJHOXBLNVc1M3l5bFBsNlJVUWpQcjNRMjN6RmdmdThnVTFCaEZO?=
 =?utf-8?B?ZzBFWmdBY1I0QWdFeHo0U1FUYVRsTGpvV1pKdHVMTVhnL3Nyd1hIVEdpQkxy?=
 =?utf-8?B?RkxJTVVUWHVreWtFVHJua0dCam0zZUNBK2VRZ1hmbU56a3NjMnBJY2VJdFdj?=
 =?utf-8?B?a044SjQ2a0lEd2YvYVFHaEF3bFVyZlVaQWFtbldpV3BWRy9qbkdBTVc1dlV6?=
 =?utf-8?B?TUpRa3A2NG45bGNaZXIwY2kyNlo2RFhFVW1qOEN3S1Z3U01pMkdiMUppaFlo?=
 =?utf-8?B?T0xaMW44VWVFZjdoNWRHQUZ0d2FKaXdnejlRNU1YcXh6dThDMlJ2b3lJdmZP?=
 =?utf-8?B?VnhpSUtQNDZ2b0FGVEhYU0FJa1hnN01uZC9Od1A0VERLNUxIS1NUNGZ0Y3l6?=
 =?utf-8?B?QnF1Q0V2RWd5YjNJUTRzUkpLTUJlYVZnb1BLV3JxOEkwUVNmLzFocGhnYUI0?=
 =?utf-8?B?YjlRMU50UUhWSDk1UVo0TElRdlJuSDVncFM3eDY4Y1RvK0pvdUsvTnJaNDVC?=
 =?utf-8?B?aHJwRFVBQWhhRVRGYjNzVFU0S1hVRG9rcFlqT1gzM1FoOXVQVEtKS0FXNDRQ?=
 =?utf-8?B?WkZhZ21jR1MzWWxGRW5Lb0N3VjFFZnN3bmFITWwyMDJrd3I4SEdnYzhmTWhj?=
 =?utf-8?B?NklUZmJDQlAzYlhiN2RkclhRS0cyeTBUTFVBUytzVU1YbVJsQW1yRWlRMjd4?=
 =?utf-8?B?OHpJOWNvdURMeWdkUlkwUWx5Vy9rTVJhUFZleS9BNEYzY0pSL3BzbWZVQWxU?=
 =?utf-8?B?clppaDN4WGFsTjJ3ekdQM3g5RG9hM2U0MkNXTStGS0puelBHU1hMS1M5YWYw?=
 =?utf-8?B?Z2JkVGdpT0xiekIyQjM5cmIxbS9IazV0Z0NrWEcrcWdlaFNHYTVYU2FNdmpl?=
 =?utf-8?B?dUhROUNQOUc2NW53OUxDbUd1c2Rxbk1Hb2VYS2x2Y3BkUHo3aUk3K0xqTWxK?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	m51+TKnoggPGOSHh3rHG2dEl28nzz28m8sE/LA0EqYx8za93HoXN+R9r/ikFW9GrtTiyvnwU4JS608ONsjC0V+68YcbV6BsEfsNFbknLj/IQkitpAg+P+g30UDIrWUaoW2XwcZZfzS+rCWrQ18vH67fzwInL1A049mcBFob+gTVQQvHsAWfVz1FU5wUriTb0rRXf/Mr39iWJmDqfdRC8aW8jWiz3lUUeaqEv2uxbHhG8YL672p74mQz/kDLYwRZFqgFyyFnIwvXAW1T8pQMhG/CXSFB6IO6PJqYpUbVO/SPSjBgkQgYZyCSaFeUlOR0dVRgKG2JLCrcybToOSGa/wZQK9uOvEpHIJ1djSfqRZqHn215eprumJXwhpBmVTAFzp68YOdd6Y5NeCXO5bE/63ZGpmBhDU+FqvOmu0nSp4kmVFBcIfLAp5E765bK0a5Q11T0l0tqBodVeD9XZ++TJieg256+bUVRgM2FgOOyDKlgC90wHnqMSuogS7IwWosbSdMGbaF4yYErBoCg7QFbcmZRpvuUmcCaGAEnvnsLM6RDHxGVYXLKL95BJI6g/fe3h5Q1EzH7hX8toTxfVBzZA5rmCH33fsW/ibK8GymLTfVo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f8d20f9-ff5a-44d2-e3d9-08dc36a9276f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 08:58:52.0658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5wF4lhcM74XmwVD8SKTD2Lidy2SBJbQ8H7HqXB12noKZJGwMMeCoDuIlpKdtbr3U+81M0LTKjjG8if3ejxNmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_05,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260067
X-Proofpoint-ORIG-GUID: h0BpJ89pH_zjH-a39CgugOsdyAF65IUB
X-Proofpoint-GUID: h0BpJ89pH_zjH-a39CgugOsdyAF65IUB

On 24/02/2024 18:20, Ritesh Harjani (IBM) wrote:
>>> Helper function atomic_write_valid() can be used by FSes to verify
>>> compliant writes.
> Minor nit.
> maybe generic_atomic_write_valid()?

Having "generic" in the name implies that there are other ways in which 
we can check if an atomic write is valid, but really this function 
should be good to use in scenarios so far considered.

Thanks,
John

