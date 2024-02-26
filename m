Return-Path: <io-uring+bounces-746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A91B6867EC4
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 18:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F4F2282DAF
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 17:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7449512FB34;
	Mon, 26 Feb 2024 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eDimvrDf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ttbFCPV3"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2B412B166;
	Mon, 26 Feb 2024 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969050; cv=fail; b=CEznpcYLQEetwRlIdcsx6vmoWJntJBONUKYA30MEQ02QFJcOM0pyVgKRuNA3X0jG5/zlK2orrSikyH0xhoq9GO1gm62OwGdHRF6dPrDiXTtSGNiwCnJq7dvBKuMxt8lgNYA7UwclfrxLFCsan0vc3K8B3JV1ThOpkdN4VlG7+ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969050; c=relaxed/simple;
	bh=+B7klVtQs76XEFPWvDGXPs+3BRm5c0slkGTqJiv4Cog=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=a6/DVX4Y4CGTMONNs9Zga4omtynleOvGR0gYDVKBjOSTslttnnZqZFZrU78J5Eqtt0zVTb/So3TEeRPOMMk7G0Af8BrDqKrJlBVJFymIu1foYQQjXzEmmV+pEagKrWeYhfFviXPaUvk0razAqCIc7yXAxoBhZ/gu5v2BPZuEG/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eDimvrDf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ttbFCPV3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QGnP77021405;
	Mon, 26 Feb 2024 17:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=kkNKvf2lIqPryqHQLeOPI6Qkmz5yLAZeDmymjv3B1EA=;
 b=eDimvrDfNAR91ThqAj7b5xhtEJnVUeur7EDfgCjorIPOIYzyVCvQzlipoAqh4iKIAhrj
 JzQ3MV2nMa5MlfgCuyuFZCEauNOCsKywmG06wqlsDSzI4wyyeF7RRFMvCaf7vpTXucgt
 1Aj8PnUKuwEans3pU2hPcj6Ln30Sxb3zIsU9p131D368OJuyKn5X5LaZOnIMJWT1+W8W
 ExlhT+XxGEbdZeCjaY0QwfRWtv+thWpgsx1645SOUZsfEf+WOTfwyaARo5feF/+XBQe9
 ePu5tYV1s3i8gj1DxDPagy8TRHLJcsdOejXAy9Gu2Djyld4gERm8yn0OBK83oVE/D2o7 YQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf722d652-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41QHKcHP009796;
	Mon, 26 Feb 2024 17:36:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w5w9vd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhzxNxW/9jhx6H79K6XeZlcQiDMzi0N66oQW/r+fT9QlZ2uCvX+2L++zr6yigqme9gS6UAKvuGfIfBolJUa6yK3ApBctdluKbJLQMq5S7sOA2Y1otZdCodThDw6gOk2OrWfUq7TVzI8Q2sp/b6SsZJR0jJfS5smnhhYwotlgk6XOp8CSOSM+6PLJDpHsnKFiiLicmrLSQOulcgVUiKRTcJypU6WcTxjeMW5d5i9iIbJUj3ilkDAsfQusGx6oIwP8z1YemXtwN3jPmgr8ebY9wFk/M7i6CUFrPVX6kyPekv4Y+CaybRZsWE8pfiByFWoAoBUxo8XxsqdTuegzodSGDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkNKvf2lIqPryqHQLeOPI6Qkmz5yLAZeDmymjv3B1EA=;
 b=UN3y+9BEiIF0KlEBrV/AkXN++CSQ+nsd5WoieXuX/+sb1W9wXoWx00oQ/yEn87wGcq2EqgEvgSoXJbQ17xHgmlNB3S3HIhjepl1sWudJ4qucjZS02Az2YIT+1rtEuwmGkJh/n8Zq7JNRvroyFWn00JiGy+pREk8wEi1tPS7Y1msEZgev6MOAvfso5JbJfpY/pHlWEncQMgkXqFTMYOzOaAEI5u7PBh7T3Exh/itSY1QF8DIyR9AULhgcUWGgV9ty83Zxgh3Mlyr62zULrRG5bq5I09t9VtcjlGKXfJtArd4XDxO2obs1JPQBx4TIcM8mzE5DOtZx/VuW7BJCo/YYsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkNKvf2lIqPryqHQLeOPI6Qkmz5yLAZeDmymjv3B1EA=;
 b=ttbFCPV3YOYimhsT0/AEaWTaU7IxCOV9daucTSrlDqRmJ12Ie6Rcq/qo22fMGNSTtc/ex102/XzqWd0Q5hhDjijZYi7QgO44/P7BNQTLa7F7r4OzhZGJHvvGWFW2auHXagQgpndBH5d8eb4uBT4GwnFOMw5jOLEnYYpJ2dXR3xw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6298.namprd10.prod.outlook.com (2603:10b6:303:1e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 17:36:38 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:36:37 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 00/10] block atomic writes
Date: Mon, 26 Feb 2024 17:36:02 +0000
Message-Id: <20240226173612.1478858-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH0PR07CA0092.namprd07.prod.outlook.com
 (2603:10b6:510:4::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: f7830b4f-f83f-40f8-9629-08dc36f17c15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	7z8DSP44k5aaGEeOeGtYPhzQaHZnIR8REefshrN7OCjO9UEPNXVI4UH6k8pzyQCWFGbL5ImXVObChzszzI7yWrM3Y4Wbk8tq2rWZPflHt09yToXCTb0TVRZQNhp5/qda/m8lVVAHmopG3RBe7wIDBWSMl3VBzzXe1nuhLB1rdaEZQUro1LS1XTm/kCswiFZdE0bVlsQmTgcx27/hl+oSANUujTpozlb56DYlqEYz7jmpPSeMI7ljIpbqomzGUt7sKWsOFJ3FRYwvJ+Ry9J/vDIZuYXibuf2u/UHJuUZ6v1SRWydLanefkvMgZqwODXTFn8pLodMMt9FagXCfi4HTxxxYzeub9YPEVbyRW07Z5ZxcGSWxN7IqbGhiUKc0sgdG0MeorNu/XrLlq3NZ8Kh6gW0CkHASSbysmyLga9JI6gqDQQa3dkvi5ZRrnATKuZyOno0aUNnz+Yw0e0cGhp9mZ/3fDApZt/f7ajheky4afpVmhze6cRkTYJ+0tpwqinoh/4fkWJ5SAT1TDGTiYAzNSsSynmcrhKonFywww0Bb59jntaUlbfJraIQedgog41VRmy5g0xG2f0fB5bZW7LFCJriQJuLxhYfT5AIGsJpmoiId1tXxUU2YBNpmirAMtNDjVswLnwjFzbAvTXPYwd3170QlbnZO/ZTUBmUGwPTu9wQlwL8jjGDvB02PR/d32y6Z
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aWhmQm81RStlMDRQTE00Wm41K1hxbFBnUlBQTmlCUS9vcnNSb21YTG9mQkNh?=
 =?utf-8?B?SlhCdUwvMWtGb2pxaUJ0VGkwaTMweXNuY3hvTjNIZGZxOXQwelg1OWxLazVz?=
 =?utf-8?B?NUY0cXpNTlJneWk5NHptdDYzNUJ3M0RvZzV2S2crZytHUlZoOGhobHkvZFYw?=
 =?utf-8?B?aks4ZlRJVWg3bE52TGZHNXpPK0RBdjB5VWUydlNMR1dBbG1jU3czT0FvL25Z?=
 =?utf-8?B?NnlheDdFUGlKYmVGOWl3dEpvVGJvMUh3Zjg3RGhmYkhzbU8wZndnUWlEcDRw?=
 =?utf-8?B?ZllvUVhuSFllU1Y5ZldJTU5uMis5U1VYNFgybDBLWWVJa0YxT2RCVVhWalUv?=
 =?utf-8?B?Ty9BWi8rMU5panI4eVJHT3NmcExCejZBRjJKdHNuTDVDTXJUSFhSaVpsbFlv?=
 =?utf-8?B?MVlMVEZsR2ZlbmxsTm5KUVpvOE9oOWZLSlZvaWRuMFo5YWRFRWhpcDN6VE9Q?=
 =?utf-8?B?bnd2SlZ3YSs4MHpaZlZjT3NTY01TRDFtRG1ZL25leUFHRys5dDRnbkRiVVp6?=
 =?utf-8?B?Q0VZcmNNUzgzUHZJVWJjQUFISnBBTVFhZ3d6UW52OHZuNStnbkEyREJHQW5Q?=
 =?utf-8?B?TEV2RUxwOW0xNWppL1pZeGV1dXlybEZRTEx0b3BIZUhvNUFTcFU3VUVpNTdH?=
 =?utf-8?B?cTdsRE83QlR0bmxkZXhwZ3V6ZVNLRDJxTWNVamVpTEpyNnNERHBmYWFLVUFU?=
 =?utf-8?B?YTZCOEluQzVVRnpOR01FQ0xWQzVEdWZLeUhISHpQczdid1h1ZFpBZ01vRkFB?=
 =?utf-8?B?OStEOUkyTXgrbEQ4TjFwRmtwVEUwNjdLZERsNnIyejJUVEN6Q2FEMzdkWW4y?=
 =?utf-8?B?bWlFYlN2SkZSbG1kbG4vVlQyVDVYVzM1Z0tEbGdnajQ3OHhEMUYyUlV0Vldn?=
 =?utf-8?B?M0NEZTVkOC9raldxS1JrV1I5TGkxR2luMDlEL2J0eldnbFhRbDdmTHZkcWtE?=
 =?utf-8?B?VXVsWHhIcUFRK3F6amhGUFlRQ0hJbUppZmhYVDVRcDlKbS8wZzBJUXlDRUFN?=
 =?utf-8?B?dlJFZU9sZUtjNmc0NFVoby9TMGV3UE9HZEdnM0dMcUtiLy8yRWM2b2ZJOW5n?=
 =?utf-8?B?VUtMenlqUFI1azhWZk5sTStXUlhSVE9ObkhJWk92V1ZVcHVPcDN4bjNtdG81?=
 =?utf-8?B?MEhRdmZSb2FETEk2dk1FaGUwOVZXTXRMK2tVNWM2SllwUzErZHdPYXJHbE4y?=
 =?utf-8?B?bDVxNU41blZBTEpSTWluUERmS1kyNWNyYjJhbTBUYWZWNzYwMk9KVHQxUity?=
 =?utf-8?B?bURRVXpjbFJ1eUZ3M1RPa00xTkpCMUZpeE16WVVUSVVJV2J3d1I4S0JOSUxF?=
 =?utf-8?B?OWVOaFhpMWNtUmMwcnZQdGNveHc0eEErTkVBcUZSR2kya3h2SFJOUnkwNmps?=
 =?utf-8?B?cUhpbXo3T1dveW1RVS9nMU95V29IYnQramNrWEpJekhaYkVMWWRidHFNR3Jj?=
 =?utf-8?B?Nk1wWnh6bWtFS29aNVIxTnJHZERuRUZxcU1raEppcXpqdGVHcDVaMEd2dm51?=
 =?utf-8?B?NXNjU0x4R0Vjb0d3OVZ4MFcyRXJZZ3dCN1lnaTR3OWlMV3laeFhPYXVaQVpM?=
 =?utf-8?B?d3pKWHY3Z3hkYUdJQm9ybkNMMHcwa0NUL3I0MWdyeng1SE5WR3VnTGhRM3VY?=
 =?utf-8?B?bittU3NoaGVoUEN0N1ZvaUV6UE9tVUZwNEorbGpJUWtIQWdYQ0cvdmgyeExI?=
 =?utf-8?B?bTRGeEFWMVpnbzRCRHVYWWozY2NDeHpmaGVkQlhONjd0ZGVCMzlHYjduQ1Jt?=
 =?utf-8?B?NUZHTHZLTEFnalBkQXhmOFd2UWJsYTRTekxIT1ZVaXZuYzhkWWEzOWdvSmow?=
 =?utf-8?B?aUduak9ROVRZY1YwUFgwU1A2bzByU01iNFlSMzFMUmF6Smt6eHhWMU9YTXQz?=
 =?utf-8?B?azgwSXFJRUVydXEwQ2NOZVFRd2NGRUI0L05zVFpUWG1zQ3B2K2JUYnowZ1dr?=
 =?utf-8?B?RlgzWG9yVEJ3d0I4QWNrLzQ1MDF4cmgxd3NPRlNGSkVaU2FZaU85REdyREFv?=
 =?utf-8?B?Syt3eG9oQ0xkRlYyQ3NLbWIvdXpySWh1MyttclJXUDlJazZhTFd6MWVYSWM0?=
 =?utf-8?B?MWV2ZXB3cnpDMVBrNFV6NU85NFROcytCcE92UGtIZ3JxQzJXUUJlSVdLRTdk?=
 =?utf-8?B?Y0xuQWRhKzlVdzdRZFYzNGpXQjdaQ2FHN0tNcjNHcmNZUmhSb3pxbXRrK1pX?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BYAL6hklu+1d9SAsh+ebj+KZZ8K3XhzpmtUjfyhPqaPi4dAwI0oi9Fg5Bs+aUlHwo3YUdNn4jiCnilXL0WYH3M8zG2GcJaWVm3JCaStuiN8TPrSoOxewPqLfOYSv7hYuhGBXNcUSS2I1SVwdb5K4gbpAbmiogQ0e//SUai8iMHtuQbyFXnWOwph3RO+Dq1ucgDZEWlQE/2G6HH4nXGij2N5DXGBC6jhBAfzFKWve7tOnKpRnkyD9e6Bqou6dXBUira60OkrxgXv5bnev2Pm5zFmwsYwSCIpG3Q9Q1Kpms79k7AUChOcCDmQCo3+9BpFSiI8r2CbTaBMVFRrgiHic9RsxAiOd/WSkt9zwcqAUcgnOhiIPIcbM25NaZ19YVVh5kTGygAyZUVH/LsMcu2mOhpVpUpJhCL0cno+OsqXswFPPuYZ6OCs3L06GIfH3ahRRxXIj6IL8ZTXLVutfm5AkfyV2ra0XPD9krCJ9s0TkNsAUbz+0TKBuvkgoeA4VATlRezsCDn4yFG3q6xFeP/nr3MVG2z9EmDJamtRV5wVSWxm3hMBdiKzNIxqtpg/TCGkXN72DxfTzzJvpCT/8B8TrseAq4jJ942Pxyqc6YCGeNHE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7830b4f-f83f-40f8-9629-08dc36f17c15
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:36:37.7775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMajvrBXHolyTWOJQ8D2nZmUMsqdxL4UCOfnhiw/7LbcIim3O3+BPcnELF0dGZ9xEuwE5fcG70TGuNRp1owYZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260134
X-Proofpoint-ORIG-GUID: PQBpV1qmD_buD2PjXnak76lf3N-22d-P
X-Proofpoint-GUID: PQBpV1qmD_buD2PjXnak76lf3N-22d-P

This series introduces a proposal to implementing atomic writes in the
kernel for torn-write protection.

This series takes the approach of adding a new "atomic" flag to each of
pwritev2() and iocb->ki_flags - RWF_ATOMIC and IOCB_ATOMIC, respectively.
When set, these indicate that we want the write issued "atomically".

Only direct IO is supported and for block devices here. For this, atomic
write HW is required, like SCSI ATOMIC WRITE (16).

XFS FS support will require rework according to discussion at:
https://lore.kernel.org/linux-fsdevel/20240124142645.9334-1-john.g.garry@oracle.com/T/#m916df899e9d0fb688cdbd415826ae2423306c2e0

The current plan there is to use forcealign feature from the start. This
will take a bit more time to get done.

Updated man pages have been posted at:
https://lore.kernel.org/lkml/20240124112731.28579-1-john.g.garry@oracle.com/T/#m520dca97a9748de352b5a723d3155a4bb1e46456

The goal here is to provide an interface that allows applications use
application-specific block sizes larger than logical block size
reported by the storage device or larger than filesystem block size as
reported by stat().

With this new interface, application blocks will never be torn or
fractured when written. For a power fail, for each individual application
block, all or none of the data to be written. A racing atomic write and
read will mean that the read sees all the old data or all the new data,
but never a mix of old and new.

Three new fields are added to struct statx - atomic_write_unit_min,
atomic_write_unit_max, and atomic_write_segments_max. For each atomic
individual write, the total length of a write must be a between
atomic_write_unit_min and atomic_write_unit_max, inclusive, and a
power-of-2. The write must also be at a natural offset in the file
wrt the write length. For pwritev2, iovcnt is limited by
atomic_write_segments_max.

SCSI sd.c and scsi_debug and NVMe kernel support is added.

This series is based on v6.8-rc6

Patches can be found at:
https://github.com/johnpgarry/linux/commits/atomic-writes-v6.8-v5

Changes since v4:
- Finally combine both NVMe patches
- Pass inode to bdev_statx() (Ritesh)
- Add IOCB_ATOMIC to TRACE_IOCB_STRINGS (Ritesh)
- Make rq_straddles_atomic_write_boundary() size+sign safe (Dave) and
  simplify (Ritesh)
- Improve generic_fill_statx_atomic_writes() doc (Dave, Ritesh) and use
  GPL export (Christoph)
- Drop BDEV_STATX_SUPPORTED_MASK and improve bdev_statx() comments
  (Christoph)
- Tweak atomic_write_valid() flow and use IS_ALIGNED (Dave) and
  also rename to generic_atomic_write_valid() (Ritesh)
- Fix module param in scsi_debug (Ojaswin)
- Tweak blkdev_direct_IO() patch to pass bdev (Keith mentioned idea)
- Some smaller code style changes, like variable renames (Ritesh)
- Restructure first block layer patch commit message (Ritesh)
- Add more RB tags (thanks)


Alan Adamson (1):
  nvme: Atomic write support

John Garry (6):
  block: Pass blk_queue_get_max_sectors() a request pointer
  block: Call blkdev_dio_unaligned() from blkdev_direct_IO()
  block: Add core atomic write support
  block: Add fops atomic write support
  scsi: sd: Atomic write support
  scsi: scsi_debug: Atomic write support

Prasad Singamsetty (3):
  fs: Initial atomic write support
  fs: Add initial atomic write support info to statx
  block: Add atomic write support for statx

 Documentation/ABI/stable/sysfs-block |  52 +++
 block/bdev.c                         |  36 +-
 block/blk-merge.c                    |  98 ++++-
 block/blk-mq.c                       |   2 +-
 block/blk-settings.c                 | 101 +++++
 block/blk-sysfs.c                    |  33 ++
 block/blk.h                          |   9 +-
 block/fops.c                         |  57 ++-
 drivers/nvme/host/core.c             |  72 ++++
 drivers/scsi/scsi_debug.c            | 588 +++++++++++++++++++++------
 drivers/scsi/scsi_trace.c            |  22 +
 drivers/scsi/sd.c                    |  93 ++++-
 drivers/scsi/sd.h                    |   8 +
 fs/aio.c                             |   8 +-
 fs/btrfs/ioctl.c                     |   2 +-
 fs/read_write.c                      |   2 +-
 fs/stat.c                            |  50 ++-
 include/linux/blk_types.h            |   3 +-
 include/linux/blkdev.h               |  67 ++-
 include/linux/fs.h                   |  40 +-
 include/linux/stat.h                 |   3 +
 include/scsi/scsi_proto.h            |   1 +
 include/trace/events/scsi.h          |   1 +
 include/uapi/linux/fs.h              |   5 +-
 include/uapi/linux/stat.h            |   9 +-
 io_uring/rw.c                        |   4 +-
 26 files changed, 1177 insertions(+), 189 deletions(-)

-- 
2.31.1


