Return-Path: <io-uring+bounces-667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C285785B877
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 11:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BEFD1F2664B
	for <lists+io-uring@lfdr.de>; Tue, 20 Feb 2024 10:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7081E60881;
	Tue, 20 Feb 2024 10:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VzUM+AdL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zXR52od8"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF9A605A5;
	Tue, 20 Feb 2024 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708423337; cv=fail; b=BW4mkRbRwh0gb1/woW6CEgoD4B6ex09oDYHdW9pqErBoy2ieqMe4lzr8sNqRdW9W2zHKToPYviXlpmmE9fFYb0TsH1laVcZFP8biIplOuuz9UYc+kv+N+u1wqpcG9pUBufxTVSefoCArocOHNCDnSlqjKZokOZ3v1y7EK8Wn9MQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708423337; c=relaxed/simple;
	bh=yW9qkYciPVMmB5RyQrZi+pY7RUknx4CpRi6rI8sK0mE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nByaYw8nIX8/vlsKPX0pt0G6HrDAJd+fhyAOq62GCHRTFW0YUJAnC74GEdEKbjpl9jSO8cyH+eKMqqeTQ0CKg3tqisS67gVHufLVNL2FPelDk7bmRdllpxBxd6thjSliEtuh6KV9rRP8t0MI2f3e2RpcA3EQ0e+JuqGjtUe8vA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VzUM+AdL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zXR52od8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41K8wwkT014820;
	Tue, 20 Feb 2024 10:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=LSC6zyt48AdfAALHwmJw3TbYCQwRLt4zwvOwu1/wxBY=;
 b=VzUM+AdL1GQ+kZaAu2Qnyu9ZFrljhMTNLIWc3NnQa7Gn/V6Y0ez4x/Zc485salYgTueI
 bOjKVLYzCccoRlfx8T6wmygKSPsNwoZUMpAs64FGOvFIMaTOcpFyIVb5EaSooC/FQYAx
 SdbJWgcy72B+phKPvK443rixG6+TZYaW4NKZP2wBy82vBS+L/yXT67gp7supNs4tc9rt
 8mV60i1EI5yah38DLLdAufceicCBxiGx7z2b4pQOBsVq1Z7BiUGr+LAl37ylJCahflq+
 tpDpVkwHvbiAxLmOgYuHnj+Diaus8JsC5uyS9utluo2U4xi4X9+aZvtODKWPD+NqqzbC 0Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wak7ee849-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 10:01:46 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41K9Wpgd032725;
	Tue, 20 Feb 2024 10:01:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak8717bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Feb 2024 10:01:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KttJDZvNYAPsEwF5YoY5XsbmUnRceTnX5HKm/RPnKi4WmyOe6gMcrtRuu3zXM7GgLOV1v7lu0OWRtJmtn7GHyoQ7JTsRW5uwPbq3/pZAfdb7qr1HZdTngTTw6Ejqz3Sn9uPrY3IKCz6DZoGsXD1FsIR76ub4Xgtt/7wjehWAnYN+AVhmJpCnr1qhEs6PDblJqwo7bd6UpPp9hQg7f307HQKypGJ67an8L4rWBr8w82phWKKjCVc6e5WDCi7FV9BghH0XGXKvZjZQLf6dsJiiEPBkqb72A4bw2Vxsw3xeCSWWCxD61/+K/NK07KAmkhzU8O7qSCLfUT8IIh6NbQf+Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSC6zyt48AdfAALHwmJw3TbYCQwRLt4zwvOwu1/wxBY=;
 b=k1+DjdbvkuVV12oGEne6N+C8ycMIJEgNM/aeBXaY0N7BBNMFJQSLR3ZFwx8y7/x2aPS4WOWjTIoZYUlwjKTxso16phvZDhR8EBA2cTGvT7xltm2atKXj7NNN4e7M6GylVT4FUeYyDZ/pzNsCmBs+Q6QO1tzKS7Zs+nRm4nDNQjlWXgWLoRq9ZZ210x3KkMAAPpKZxpeqC7aIqTj8G/c56FKAM77Z5GwjoK+eGRXkXgtPL6tX+w+dJYgakGoxE1IEVFAtO6CEoyFOk5tYtAfe4b14ngZlxQ6asPcuF6pgWrh57Krv8EXOXnmB/IwxYH5DK7tbTJ+dKi7ENiLRvuI5IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSC6zyt48AdfAALHwmJw3TbYCQwRLt4zwvOwu1/wxBY=;
 b=zXR52od8W3U0XYMbMkXy8Bd4ap7yxUugZIg999+H87t+z+r4a5vWR/u0HuLt5D7lrDgRtXIXnj8319Bol5ZFQyxZw2tnzDl0paftgF2r9JDneKyGaRWeGZWMCGad4jFu5H4o7k0Z6QQ4yHAeEO1IWD2zNSR8pGrKrXXpIDCW2RY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB6604.namprd10.prod.outlook.com (2603:10b6:510:208::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.39; Tue, 20 Feb
 2024 10:01:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 10:01:43 +0000
Message-ID: <f5ccbfac-e369-4371-bb7f-68bb40c47239@oracle.com>
Date: Tue, 20 Feb 2024 10:01:38 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/11] block: Add core atomic write support
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
        nilay@linux.ibm.com, ritesh.list@gmail.com
References: <20240219130109.341523-1-john.g.garry@oracle.com>
 <20240219130109.341523-6-john.g.garry@oracle.com>
 <ZdPdHzNAVb5hqlkY@dread.disaster.area>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZdPdHzNAVb5hqlkY@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::24) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ef4816b-7777-4d2f-cc8e-08dc31faf0ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hChLBcG1RW0qWPyCkMC0lMdT4JzsnS0yF92kC6OH0DnRyePwhIa7TyWv3Dcba7yKdDDCjx/zrcUReusIPDZbKkxN/lCn7vmATaKJIXhIOh2vFCcO6cP9FZ0xM7e58qkw6PB1x/FfovyjYvQyNKUkoq7Ge8V0x7nWJ2ZRlO8gBmlJexScvoJyCtog+taZbiXxXZsfHP9bvvhwxb1aqg39Yrq4QJD7qnZb2MGjiTJKQ7ptXPiTHtfW4SYGdfJJpRfveaR7fwPzmx8YlNI4WQuOrYSGVk73alSemG9pc7+4jq3scueh5mQ4FZOl++oOyfxGtNiForWZhZah8TCbuvOjcVgBF9UhsJ6KxNLvQjglZ8EqF9lqpJVQYsPcV4N0l6jqZvju312OxpsQXtfS2m2mDRacoJVLRrpLJ4pU9oZW4dVdLlFziHNeMujQl/FGxIH9wRa308v/l8R5TMukhHGBogZxM+35dYe5tFmSlNBUcAdd9y2Wc+SpRC83tKiLyTpZAkpKwjzBCWibRk65elhWyAh2qdX+dP/XjrnRXlbwx7A=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dFZjWldWT0U3UmhXQ0xRWHZWdEw2NXI0aS9pSWpvM0ZuUW1NOWhqd2E2MTV6?=
 =?utf-8?B?bkZyckpoVitkeW9KdkJlTWZyUUxhTm5aendWMEUzYUk2K1NWRW5BeExqMVc4?=
 =?utf-8?B?dzV3SXZrRjVoV1JKRjkwQ2lMZGxISXNVL0Z0cncwQ0R3aUw2OVRGclFxTGtL?=
 =?utf-8?B?SXA0NUtWdjI1SGdXcEk0Znp6V3ZYZitxL3g4U1d3eHRud205enRGVmxwYXdY?=
 =?utf-8?B?bzJGZ2Z6OTJMU0pWN1ZjUHNYNE9wRm1FQmhoL0hYYzNWek8vWk9JYU9LdjZN?=
 =?utf-8?B?WHJxN3M0QzlMMExpWkJJMEFDS1dYcHgzVW9JTVVncW1ibDJwUHR3TUpsUHA4?=
 =?utf-8?B?TnZPdjdqaU43aVM4b0Z2bU9CWGdBUVl6OWRtVUVBbnZNZGFYOUJuNVJLTjhk?=
 =?utf-8?B?SW0xdktWdTBKbmxwVXpCbnhMQ2N5eW04K2tFY1Vkam5YM0JGdnZacFlYYS90?=
 =?utf-8?B?MHhGbFYvWmhOeTM5cWR1N1JqN1JtUFA4cUJ6cnhZV1dTZEV2cHgxNTF5YnBM?=
 =?utf-8?B?RWF0aTBrVVBtN21vSGNDc05aZzdDbFVUTVNFT0pmTzRzZnk2RldlTWZIbHR3?=
 =?utf-8?B?RWk2NVA0YUU0Z3NoT3NPZXlyS3p5YUhoaVlMbUhJRjNuZ0VMMlN6b3ZEcTZo?=
 =?utf-8?B?UUkxTDRIK0pjczAxOUdxL2tQZVdhWUN3cnVKWlJmUk5aei9kckdkVllVWUE2?=
 =?utf-8?B?Mmg0Z1NQZzc3SjBzM3BxR1hYdkxqdW04M2lGd3UyMkgwS0JKNGl4em1tUmFV?=
 =?utf-8?B?eHNWUFlrLy9BUmczeEJiN2tONHlOSkxpb2w1TGxlMDUvc1BmK1Ewdjh2bjNQ?=
 =?utf-8?B?cGV4bmpmNnlTeUZpSUdreFYwVzhhaHo3VGFuQTFIZ0NhcmtlYzhsR3g1OGcv?=
 =?utf-8?B?VFdCSTZSY1Y3WUJqbmhhYk0vSkYyUGFiR3E4VHRXY2tYQTQwc25CMklQSUph?=
 =?utf-8?B?Y0ZyczRyVWhPYTczc0hkTFViSWFhd2cvc2ltRjViNmNiUW5KRTFPV2FOdjBy?=
 =?utf-8?B?V3BndUZneTdySE95TmpuSkxaTlg4YlErZFI2c1hsaDZwVDVYbDVod2JwcDZ6?=
 =?utf-8?B?UGo3SkI3SlJQdDAxT3c1RHc0RnVHdTZqQlc0eC9TK1RXS0NOYWNtNVNueUJ5?=
 =?utf-8?B?N1pDbTZZbFNKUUQwVUlYeHhmU1I5WFZZc3RBSjZsMUZrR2dSYWQwZ01SY05Q?=
 =?utf-8?B?OHhtLzQwbHcwT2JpS29tMlFJc0FwTSt2WVMwclBrUTU1YVFTYUI4NEx0TXAw?=
 =?utf-8?B?dDBrMWFJT1RvbkRxMzZiNFZ6emw1Y2MrZE1iVG50dlhDcE1CbUxYcVMwU2tL?=
 =?utf-8?B?aW8xTjl2TnEvRG5jOFlMb2VsbjNyNG5uclFKY1ZhQTN1VXN0cTFrazl0alQ5?=
 =?utf-8?B?T2NGazNNYklpcDhtQ2xxa2ZZRXJRNlJwZGVheURqaDgrTHZwSnZNaHBERW1s?=
 =?utf-8?B?WnF4NnFBWGY0QzFZaWNxdERzajJvbTNMRzZBL0l3eWNlQTZDYUR3RmxvMlBy?=
 =?utf-8?B?NXVPaU5kK3NZR0U3c05JRGtMcHd0YmZhOVMzd3lZTmUzaVRFQTFQakJxeTVk?=
 =?utf-8?B?YzFCdy8wVTFwWXBiZlFnazcvL0VsMjZxbmJZVU1YMzU1cit3RVJ0cm05bUNm?=
 =?utf-8?B?L2syeUJCb053Z1haNTNoV3FxRkVtUGJkM1RuQ2JEcHJ0YW5HWVVYNEROK0Nm?=
 =?utf-8?B?QlNzRTI1Zy9vdlhtQTkrdXhWZUt1LzZEU1c2R3N0cUJhcEt6NWFVUTNNQ25K?=
 =?utf-8?B?RGNJUVNxNitzN2lrcUM5Njg5UnZ4UzJhY2p6alRPTlNjTklZb2FEc3JOVi9k?=
 =?utf-8?B?NERLdU9FZjhIdStWZjR6akJtRXpKM3BQOFRZd2Z6RXRKajlmWjAzdUloandF?=
 =?utf-8?B?RXp2ZXFxa3lSUHlkUGlrT1RTbHZ3cHlNdFRkSUxCSHp2Y2RQaEhHRTBHVStM?=
 =?utf-8?B?dVhMSWN4cHVEOXhYVTduTk9VUjFrTTlzR3RPYkM5SjJQYlVnakx5b1dVcEx1?=
 =?utf-8?B?eml6L0VzVndzck5vL3hNb3VMN29RSXFFdjhjbUpSY2diOU9XVS9CQUZxT0dX?=
 =?utf-8?B?cEd4OEhmV1UwVWp2dDVjZmp4b25FWXJHTXVkRForNHJmakhVS0MzSXlkSGV2?=
 =?utf-8?B?NHhPT0ZSbUVmdVNrZnNQRkhtN3JLOFNSWTdGaFpCOVFBdiswWG8wNlJXNVJh?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KSJiw5lH6qcsA56V+JiP1wF9XuimSqNr9TV1ZZYq11G7ZGQ5KESrqETYZc5/tb1PH0LO4PB9ynJwlaN8vwKbgSY7CP1Cw9sPFAcWDXVEGx3Pj+q67KXf1VRd4Mp79rGBVJ2WpgIoac5rWQglnVY1wccXt+NM7jZwBfqh96zEJiiJ/fMndiO3j+J5ydugMAe52TyL/ugu5om65WUuTZ7Ti8S6c9YLdB6AX/LrkxJ8LUrfjheKAvtsicNPjibOVDBZkLVqvKr6UUWKeTIJxies0nmzE03qGapLQrBuxkgBReqCxt0f1RH8EvmN7WWFRogL4cd+I8x1WdEjNcuiLt1LOcpD0ZLROFBkVCU8KA1ceBSdDfsAs9BWF8XfzJZxIguGsY11//zHNZ3eU39uriMqctesDDGQg+EKkinoV1p4hGNZ13JFXzSNcOorA8gFfNe9byDJ4wxeIya90+fD0hFbQwnz+cQdyNDBjVNsFNN++lvD+Fswx1FkbQI63oRTck0bpLvAXccwXU84W7pWwaedr8RCQGYMcQvgjU+d4w4mu4Yq/OJTzSZEUCZ1N2BwvEdgCPIUCU0+63JHrjyaB7e4689mnojoZFwz4aNotklKIU0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef4816b-7777-4d2f-cc8e-08dc31faf0ec
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 10:01:43.5281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wCAMQp8W+mkKd7YXWk4dra1xQq1kk1yODkwqNlYoRsAPyEWiVPVtfngi3kaUB9u6HfqBkMf4zdtUh9i5FfXKEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6604
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402200071
X-Proofpoint-GUID: i4jXTXRa0bSBSapiMmSdNQ3vlJcwHtBx
X-Proofpoint-ORIG-GUID: i4jXTXRa0bSBSapiMmSdNQ3vlJcwHtBx

On 19/02/2024 22:58, Dave Chinner wrote:
> On Mon, Feb 19, 2024 at 01:01:03PM +0000, John Garry wrote:
>> Add atomic write support as follows:
>> diff --git a/block/blk-merge.c b/block/blk-merge.c
>> index 74e9e775f13d..12a75a252ca2 100644
>> --- a/block/blk-merge.c
>> +++ b/block/blk-merge.c
>> @@ -18,6 +18,42 @@
>>   #include "blk-rq-qos.h"
>>   #include "blk-throttle.h"
>>   
>> +static bool rq_straddles_atomic_write_boundary(struct request *rq,
>> +					unsigned int front,
>> +					unsigned int back)
>> +{
>> +	unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
>> +	unsigned int mask, imask;
>> +	loff_t start, end;
>> +
>> +	if (!boundary)
>> +		return false;
>> +
>> +	start = rq->__sector << SECTOR_SHIFT;
>> +	end = start + rq->__data_len;
>> +
>> +	start -= front;
>> +	end += back;
>> +
>> +	/* We're longer than the boundary, so must be crossing it */
>> +	if (end - start > boundary)
>> +		return true;
>> +
>> +	mask = boundary - 1;
>> +
>> +	/* start/end are boundary-aligned, so cannot be crossing */
>> +	if (!(start & mask) || !(end & mask))
>> +		return false;
>> +
>> +	imask = ~mask;
>> +
>> +	/* Top bits are different, so crossed a boundary */
>> +	if ((start & imask) != (end & imask))
>> +		return true;
>> +
>> +	return false;
>> +}
> I have no way of verifying this function is doing what it is
> supposed to because it's function is undocumented. I have no idea
> what the front/back variables are supposed to represent, and so no
> clue if they are being applied properly.

I'll add proper function header documentation.

> 
> That said, it's also applying unsigned 32 bit mask variables to
> signed 64 bit quantities and trying to do things like "high bit changed"
> checks on the 64 bit variable. This just smells like a future
> source of "large offsets don't work like we expected!" bugs.

I'll change variables to be unsigned and also all the same size.

> 
>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>> index 06ea91e51b8b..176f26374abc 100644
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -59,6 +59,13 @@ void blk_set_default_limits(struct queue_limits *lim)
>>   	lim->zoned = false;
>>   	lim->zone_write_granularity = 0;
>>   	lim->dma_alignment = 511;
>> +	lim->atomic_write_hw_max_sectors = 0;
>> +	lim->atomic_write_max_sectors = 0;
>> +	lim->atomic_write_hw_boundary_sectors = 0;
>> +	lim->atomic_write_hw_unit_min_sectors = 0;
>> +	lim->atomic_write_unit_min_sectors = 0;
>> +	lim->atomic_write_hw_unit_max_sectors = 0;
>> +	lim->atomic_write_unit_max_sectors = 0;
>>   }
> Seems to me this function would do better to just
> 
> 	memset(lim, 0, sizeof(*lim));
> 
> and then set all the non-zero fields.

Christoph responded about limits here and in 
blk_queue_atomic_write_max_bytes(), so please let me know if still some 
concerns.

Thanks,
John


