Return-Path: <io-uring+bounces-724-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BED9866F5F
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 10:55:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7C7C1F27D15
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 09:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEE452F79;
	Mon, 26 Feb 2024 09:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jSL1VGkW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AGZseb0K"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD15524D1;
	Mon, 26 Feb 2024 09:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708939457; cv=fail; b=QkJoKKmg2bn0tFcYUovSjlEWnLs4Xle7weM/jvIpTXPiaWaGxcmIBNd+DRj8u1/xOccXjYGIFoBv6ID6pBV0czHPiEyK+/g9pA1ec/hPkhVoXuL9p26kWUEIzfTnGl4Wm1BSCB1bB8rlH7ppu4fX1FEEQxVva/vkOA2JkzReyBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708939457; c=relaxed/simple;
	bh=3TAhA+V3mxk5mN7V7Gf7cBGQ9e71XP3/UyApNvwcm3A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QNHlR8vqbp1sKKz+2OHKwFmDabUikJs/D54eL2VUEa+2PsgfoJyee75qYjuUi6sYAwj7rvBwJnQIZ8dEE1kMrJLGKuEzS4mpLC8f5albtFTb5L2grGNg8Vjj0oz9RYC3dZQX7/AtRzBiHxJgxq23Z/5aAmYcNbDQPXwfD24UzfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jSL1VGkW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AGZseb0K; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41PLstYr032672;
	Mon, 26 Feb 2024 09:23:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=nWqvslfO01Vu5DlZDSn9B2vMkXxTmaY/MQo3dGvzrqI=;
 b=jSL1VGkW1FM49z6l+zwsJ2hMg7xfFpv9j9ThGWL2scRBn56xkyR0mMiQzU0ObKxolMMa
 YpkYqXpDiw34FDvhLm+tHFRLroykDkCuCzzotagX0K/hE7I8DNh6vUZHt40h/bQ4ZMkA
 clSAzCdt+guB2LtUCFgEB7UdvkiK4oJn9q/GOpCnxJnBJ6PNNW5azzcBhEqdbKDsXlID
 Jq36OXMqbN7hWZgWfDepIu/nqaCrI/qY+YxCh24VDDD2K35G8+WnS8hT9ptrTLwyX2Ap
 7Bzv9Gi8e+nh3GWoLGC5e3lEGIuZQnHJ+wxaRyutio7WFfCua7AhYrxX1RiUaqEawgRW uA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf7ccc230-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 09:23:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q928uU012782;
	Mon, 26 Feb 2024 09:23:43 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w5936j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 09:23:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsOwU3TsQTnzGWid7P8FCIk9fGiiCDADHSeD7uGO++5gk7cwUYG7dD1NBi/J1/A6TiUl7oI0qcY6WnUrNmywMNSsjBX89nja62FdaqWdL+piBT7SgdSy6GZlk7ayfl/sRJsCIVktbIVcBF41jTtU0N7HfUim2vIBpY3tstx2Zxhgep6oIwY9gsnwq/vdSKk+5rEF2j67i+r08di2ag7wRbCME9ks6VQBvLogysiGoldKW5jGrH61AVafeNw3VJehRMtsVAiTEStcFGixBkgZdAgK23scJ+FOd/2F2SsWDtRKHnWQOKnTi+E4cDmNkS+zlPkL17yRD1Vdl+dU5tZ4jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWqvslfO01Vu5DlZDSn9B2vMkXxTmaY/MQo3dGvzrqI=;
 b=TnJCocKK4dMBPzodXrqea7gvfxmZ3xYOuzT3Jp1KuNuJs3Z7SEIiiw/dFvXkEoWeL7sBVzk2MPZBRgKVJCYjyEvZ3GcVKgDEEeQEzYhR7IOtA+YYoVnRSfaFp5631cMznsY6gdi6cdfkczolF8spKd02zRAEr7NlaeMrveyh+hdn7bJ6rnYRzkm/qR4cmzEpfgVIZ9WIk1KbKK14W1cy+lk5PwyAxOReBdEVOSOrdqNsAQzUVwh6lZdqA9xPCsDGHFRV+kSMw11d5JPbKfJXZN+jolZtQphwxOKBJynA7LAPPuCQ9Z1jSxfR4CtEbq+wFRqhu9w9jNeioFBBGihDDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWqvslfO01Vu5DlZDSn9B2vMkXxTmaY/MQo3dGvzrqI=;
 b=AGZseb0Kn64sY9cAimhu3m80kUrMEekIkiVgPTO8Nkcy3IDj+L4GOZYfRvKmg4gyGefSTE45K/fhMGfgPINiPDCQ8gvhtQtlQnLdv92DwkGkq1PWYn98sjTM0apa91OzGxWdWcdL3zuuG31qGiQx16aE+luX1H/TX2sq/bNkAps=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB4432.namprd10.prod.outlook.com (2603:10b6:a03:2df::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 09:23:40 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 09:23:40 +0000
Message-ID: <e59f3edc-d9b1-4084-9acb-ca19dc08ddb4@oracle.com>
Date: Mon, 26 Feb 2024 09:23:35 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/11] block: Add core atomic write support
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
        nilay@linux.ibm.com
References: <87le7821ad.fsf@doe.com>
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <87le7821ad.fsf@doe.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0462.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB4432:EE_
X-MS-Office365-Filtering-Correlation-Id: d70e5dc5-e437-4e98-3bd7-08dc36ac9e98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	FsadzK/rzFeMccFxbq1J8J5WZAbvT4nOffuMuUPcmFPQ6BYwxNfzPpJ7ENru3o9XrYNFvjDsN5FRCHTpk7c0La0RYsM7BfP3kM5zW2p4y9i2sCBfOoaZQUS1yzgB9SIZnLvctOPA5z3j+SL12YPAPa1T1HGCtY7aQZMKqC3bZigylx/UFBSb5WTYLIof6JOStkS4gFYaTPVEZEVL0wNOsjg09FYi2cmqc9T0Jgvw4siwi0smjoeTZF3YDgB+CSXT/h/esJq59ZR1bx5+98G+7UtMfYT4DtERXCPf9qb+JaKyJzM7J0byNt2muOk8lh+uDtbsQlXD2MsCk8prAleKnskVRe1losQVDyeTgJo5aVntUR+PkjoRScL50r1nWGc/CcrMM6HJ4dxbSqRuyy+70Tw3ZVBQ3wC04/3OspiWgKN0nxdnjTmpVN5yfX3hwrFYDBsK1y5V1VEVWP9gN/cgv0CkHpbu+X1geHZ+H9PFs5URcLE4pkfzZn8kx1UvpxxcRcWHbr+Kwr8ymiwXYWRqLd0QcCSKGA115B/P7RccRXT/C/rs8+vlK+527A9Pm+KjoUqrSgMk0AvtsM1shgzAce7Y2SUIH17Lgjjnb1oJIY1Vh0yrQXSEsG7yCCeXB4+Vbbmo/lG2v6isRZjINuN9HL5EAZm8yKDqsDYPwBlylxjfSAlThYMbkMoBkCPZxdRD8ID0HTnRVsTU4IZt/smsvg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RExiV1pPUjJ1a2VvWk5DVmw1UGEzT3l4L2dYUE4yYzkwZ1lsMEZhcGE4aDJ0?=
 =?utf-8?B?OSsrd3Q4NUlyT1FIMktGQS8vSkV2MUpkRHRza1JWUGJaY2NnMVdlN1YrdW9z?=
 =?utf-8?B?dk0ra2J0VE5rb3NRZ2RISWlyVk03K1dOSmtUUkRtN1hSYUlwalYzU1hTaWJJ?=
 =?utf-8?B?cVVmZ09ER2c3dEQ2ODRkT2hpUjdJK3pWZjAwelFaaE1oQmlMSDZNTi94RnJv?=
 =?utf-8?B?aGZhMS93c3lCTlBpWVVyVDlyaVk0d0FZMWFxaHVTdkFWeTZmTE9JeGxQYlNh?=
 =?utf-8?B?U1BPWFI0em9qamY2Y3BOdTVTdWxvaVUzeC9tUkdxSExqcUZ0Ujk1ZXErVnU5?=
 =?utf-8?B?UnJMUG9abm1xQVNwNU8wdUg0dUxhOHBHeW9LMnVEVzY2dmFqMkNTSm14SzlV?=
 =?utf-8?B?M3dDeGgzZnZZeWVaVjkvQmcranVRM253ZkpyQVN0QUJHdlByUVJEdUd5dUlM?=
 =?utf-8?B?SGV4NzNQWGYvSWd5S2ZKYnNpTmpWczVGUkY0Rk9sekRTcllONmtIL294d05B?=
 =?utf-8?B?cm1NYmZ6eldXL2RsdExxdnkzdXpiVTQ5ZHc5SmcwY285d3I3Uis0dVFuWk53?=
 =?utf-8?B?Y1QzMEZmVmh1UkdwUnVlRUlEbUIwNHBuTkg2bk9qU3VlRlVRYnVzNmVRemxT?=
 =?utf-8?B?ZDRxZ2dzVGNmNHdiaElzaUVBYVNNRW5vVkE5V2NVU0JQbWZZUWtueEZHN1d4?=
 =?utf-8?B?SlZvNXJLZktzc3RZeHdFVmFWQVJ5SzJGYnFPUU04ck1Hc3FiVStCZXEyWHBr?=
 =?utf-8?B?K1I1am5IQ0xCWkJrNU1nNFhNOStZaHYyZU1BNjhwUWtUQTBDMjAxV3V6SFlF?=
 =?utf-8?B?dW5DSmZuemZ3NTdGUFJrRlNPamVNTUl1dU10VHFKUG5hcGFVd0xHbjM0UlpJ?=
 =?utf-8?B?MWZKWnhhclM0bGhJQUEvNk5vc1hZT1I0aWkrMEF5NXlQMlpPN01jaE1nb3hh?=
 =?utf-8?B?MWpqUmpOem1RZ0s2Ylphc0t3ZG02SVBibWc2KzBzd2t4NmNSM0V2d2RpUU4x?=
 =?utf-8?B?OTdzZ0pGWlVYdXpSaWNST1dWYjBQeFB3QW1EMzRlbVg2OHNMWExUWmFoZzNu?=
 =?utf-8?B?K3FyWi9aQ2x4VlpvSG1WSzF6U1BJR3pxQm8rNk1IU04zSGROZTZhVXZQcFA4?=
 =?utf-8?B?ZU5uOXJEWThWVW5SNlQ2SW9Xc1d6UXRScE4zalVpTGlmK0tGVktOdllSM2Y2?=
 =?utf-8?B?TVFzUGFJVjMwUTR4UEpPa1g3WjN5OGJaanNoTjdZcmY3SjRIWkJob3V6WHRB?=
 =?utf-8?B?alBGYUVuaVNpMS83eEZWVUFMT1FwVXNnckRSdTVSVVEvZm5zakNVOEU2OGFW?=
 =?utf-8?B?cjhyTU14L1lOS0I5cWxoM0lpeVliU2ZxY3FaUlpvMlFoR1h4dmJtYkkzemll?=
 =?utf-8?B?dXBUdkp0bGM2SUhzOWxZdXI2Q0tBNXZzODY1ZU1OK2NTK2NncDBvNzRmaGpU?=
 =?utf-8?B?SUgxbTFVTmNNVU9tVllZaUF3WlB5SlFJSm5mRDVnYng2ZXBCOXJweVdoT2pU?=
 =?utf-8?B?azVKbHUyWnZLOHdwZkdZTlNLcG5YSnUxZXQ2VyttUWt0eHpWUk94RFd2cjFy?=
 =?utf-8?B?cEY5TEwxZkQySjFRemRyQy9YWCtDUmdlVjN4MEhSY21TdyszZkd4WFoyS2ZZ?=
 =?utf-8?B?WllrNXZ2N2pSamdTcFlReVdmMkY0U0dZVURHekdpN3ZWOXFhdVBwekorRnB1?=
 =?utf-8?B?aTBoYzdvUkZ2dW81V3FNWjh4RTRuSmM0emxFcmVJNVE1V0Rwbm1yU2xEa2Iz?=
 =?utf-8?B?QnRZS2s5TEZLcTJNSVh1UENMSVdUOTluNFMzNlpraS9QczdnL0NVcURHM1hz?=
 =?utf-8?B?cys5WlB3Y3NBbTBWT3NTdjVoNk13bjRZUnNVUmxhOTZaY1JPN1V2cm5yeU9l?=
 =?utf-8?B?T1E1clFKYzRwYlFFRUo5VCtSSllxVS80MXN3ZUQvVnBVL1FDMjdycWdzUnA4?=
 =?utf-8?B?b3h2ZzJtL1hiUEh3V3FEOEs2cmRFZTlFVW1VTldrOGZUWlo4bEhVM00xTWt3?=
 =?utf-8?B?MlRWa2o1VS9kUnM2eEh2czhKWDBhMHlkYVl4Sm85d3laSFlOK0g0RUhqZUN0?=
 =?utf-8?B?L3N1NWhBZXB0VWFtUEFCUGRxTUg0ZVVKVXVyR09uRXNJNkZLdldPZnljejRw?=
 =?utf-8?B?dHpYa2FRM0Y2RDJmakdjVVF4Q0xUeGhRdVlQM3ZWcUgwdFQwYkwzS2dqeG8v?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	icirHE/oIjOwpqWzU8KAq05gDnQ2PpPfdny4US9TLz+JwONnCxQX1PcoYs18FzoFqHC9BX9H8DJY6/MfJftQG6oHyyGr1BRryZfcXdh0LvwcClCkBlcSkY8R3wElPc2j9pcekbrwXuhr0na8mp4Q6KqLcyBDyoXMS71N05dOkk/Knlxq/Jr5fea5iUxOoOUobpqxq0tnUeQ75Wu6mjf9t/seDxFrCIxMB8/uA3sHNBcO7egqkkwNS3VIOzZFkLFZpUDWBs7rVIGeFQFbyr0D9FMmY/s5cjQxaikDoLLSveeCZNOaNRQ0mnz728R+3Zl8VWXURapNOxlhUrbOa4d7RPA5tZ/6/A0r3mPCS7EhcOC4CD3yPcd2Kssm81a5gtLso97b240lxUJhNC8V33/42D/1D9XEOFc2P0AFCxsq/jNkStnzeNcneYCh2RA0OnE7RmVwBehXirMbfAVM5f/FTkW+Vz2PtRoPjJaDO/60Y2O/FLkjxegOfqJLGOyotdmN0XJeEPSb/NbqQiOYj7mEVyicLC7iNDZ3Tnksw68jfxb71gf4nlgdlZOGvoXCgOEKf0K06U9SLo2kiqW1OFOYOitIzXfsYv8Pb9qdtGjaadQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d70e5dc5-e437-4e98-3bd7-08dc36ac9e98
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 09:23:40.4611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3W3QMrmRrrrTIHD3geXYkgjL/71+ix50ex2NI4iLpVA3USN1484kDrcjYCegi/k68GWYBLHVMFcjX1mVY7jww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4432
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_05,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260070
X-Proofpoint-ORIG-GUID: KrVCPBhsD6roPRhyl0HGizVUe6hGe51m
X-Proofpoint-GUID: KrVCPBhsD6roPRhyl0HGizVUe6hGe51m

On 25/02/2024 12:09, Ritesh Harjani (IBM) wrote:
> John Garry <john.g.garry@oracle.com> writes:
> 
>> Add atomic write support as follows:
>> - report request_queue atomic write support limits to sysfs and udpate Doc
>> - add helper functions to get request_queue atomic write limits
>> - support to safely merge atomic writes
>> - add a per-request atomic write flag
>> - deal with splitting atomic writes
>> - misc helper functions
>>
>> New sysfs files are added to report the following atomic write limits:
>> - atomic_write_boundary_bytes
>> - atomic_write_max_bytes
>> - atomic_write_unit_max_bytes
>> - atomic_write_unit_min_bytes
>>
>> atomic_write_unit_{min,max}_bytes report the min and max atomic write
>> support size, inclusive, and are primarily dictated by HW capability. Both
>> values must be a power-of-2. atomic_write_boundary_bytes, if non-zero,
>> indicates an LBA space boundary at which an atomic write straddles no
>> longer is atomically executed by the disk. atomic_write_max_bytes is the
>> maximum merged size for an atomic write. Often it will be the same value as
>> atomic_write_unit_max_bytes.
> 
> Instead of explaining sysfs outputs which are deriviatives of HW
> and request_queue limits (and also defined in Documentation), maybe we
> could explain how those sysfs values are derived instead -
> 
> struct queue_limits {
> <...>
> 	unsigned int		atomic_write_hw_max_sectors;
> 	unsigned int		atomic_write_max_sectors;
> 	unsigned int		atomic_write_hw_boundary_sectors;
> 	unsigned int		atomic_write_hw_unit_min_sectors;
> 	unsigned int		atomic_write_unit_min_sectors;
> 	unsigned int		atomic_write_hw_unit_max_sectors;
> 	unsigned int		atomic_write_unit_max_sectors;
> <...>
> 
> 1. atomic_write_unit_hw_max_sectors comes directly from hw and it need
> not be a power of 2.
> 
> 2. atomic_write_hw_unit_min_sectors and atomic_write_hw_unit_max_sectors
> is again defined/derived from hw limits, but it is rounded down so that
> it is always a power of 2.
> 
> 3. atomic_write_hw_boundary_sectors again comes from HW boundary limit.
> It could either be 0 (which means the device specify no boundary limit) or a
> multiple of unit_max. It need not be power of 2, however the current
> code assumes it to be a power of 2 (check callers of blk_queue_atomic_write_boundary_bytes())
> 
> 4. atomic_write_max_sectors, atomic_write_unit_min_sectors
> and atomic_write_unit_max_sectors are all derived out of above hw limits
> inside function blk_atomic_writes_update_limits() based on request_queue
> limits.
>      a. atomic_write_max_sectors is derived from atomic_write_hw_unit_max_sectors and
>         request_queue's max_hw_sectors limit. It also guarantees max
>         sectors that can be fit in a single bio.
>      b. atomic_write_unit_[min|max]_sectors are derived from atomic_write_hw_unit_[min|max]_sectors,
>         request_queue's max_hw_sectors & blk_queue_max_guaranteed_bio_sectors(). Both of these limits
>         are kept as a power of 2.
> 
> Now coming to sysfs outputs -
> 1. atomic_write_unit_max_bytes: Same as atomic_write_unix_max_sectors in bytes
> 2. atomic_write_unit_min_bytes: Same as atomic_write_unit_min_sectors in bytes
> 3. atomic_write_boundary_bytes: same as atomic_write_hw_boundary_sectors
> in bytes
> 4. atomic_write_max_bytes: Same as atomic_write_max_sectors in bytes
> 

ok, I can look to incorporate the advised formatting changes

>>
>> atomic_write_unit_max_bytes is capped at the maximum data size which we are
>> guaranteed to be able to fit in a BIO, as an atomic write must always be
>> submitted as a single BIO. This BIO max size is dictated by the number of
> 
> Here it says that the atomic write must always be submitted as a single
> bio. From where to where?

submitted to the block layer/core

> I think you meant from FS to block layer.

sure, or also block device file operations (in fops.c) to block core

> Because otherwise we still allow request/bio merging inside block layer
> based on the request queue limits we defined above. i.e. bio can be
> chained to form
>        rq->biotail->bi_next = next_rq->bio
> as long as the merged requests is within the queue_limits.
> 
> i.e. atomic write requests can be merged as long as -
>      - both rqs have REQ_ATOMIC set
>      - blk_rq_sectors(final_rq) <= q->limits.atomic_write_max_sectors
>      - final rq formed should not straddle limits->atomic_write_hw_boundary_sectors
> 
> However, splitting of an atomic write requests is not allowed. And if it
> happens, we fail the I/O req & return -EINVAL.

...

> 
> IMHO, the commit message can definitely use a re-write. I agree that you
> have put in a lot of information, but I think it can be more organized.#

ok, fine. I'll look at this. Thanks.

> 
>>
>> Contains significant contributions from:
>> Himanshu Madhani <himanshu.madhani@oracle.com>
> 
> Myabe it can use a better tag then.
> "Documentation/process/submitting-patches.rst"

ok

> 
>>
>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>> ---
>>   Documentation/ABI/stable/sysfs-block |  52 ++++++++++++++
>>   block/blk-merge.c                    |  91 ++++++++++++++++++++++-
>>   block/blk-settings.c                 | 103 +++++++++++++++++++++++++++
>>   block/blk-sysfs.c                    |  33 +++++++++
>>   block/blk.h                          |   3 +
>>   include/linux/blk_types.h            |   2 +
>>   include/linux/blkdev.h               |  60 ++++++++++++++++
>>   7 files changed, 343 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
>> index 1fe9a553c37b..4c775f4bdefe 100644
>> --- a/Documentation/ABI/stable/sysfs-block
>> +++ b/Documentation/ABI/stable/sysfs-block
>> @@ -21,6 +21,58 @@ Description:
>>   		device is offset from the internal allocation unit's
>>   		natural alignment.

...

>>   
> 
> /* A comment explaining this function and arguments could be helpful */

already addressed according to earlier review

> 
>> +static bool rq_straddles_atomic_write_boundary(struct request *rq,
>> +					unsigned int front,
>> +					unsigned int back)
> 
> A better naming perhaps be start_adjust, end_adjust?

ok

> 
>> +{
>> +	unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
>> +	unsigned int mask, imask;
>> +	loff_t start, end;
> 
> start_rq_pos, end_rq_pos maybe?

ok

> 
>> +
>> +	if (!boundary)
>> +		return false;
>> +
>> +	start = rq->__sector << SECTOR_SHIFT;
> 
> blk_rq_pos(rq) perhaps?

ok

> 
>> +	end = start + rq->__data_len;
> 
> blk_rq_bytes(rq) perhaps? It should be..

ok

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
> 
> The last condition looks wrong. Shouldn't it be end - 1?
> 
>> +
>> +	return false;
>> +}
> 
> Can we do something like this?
> 
> static bool rq_straddles_atomic_write_boundary(struct request *rq,
> 					       unsigned int start_adjust,
> 					       unsigned int end_adjust)
> {
> 	unsigned int boundary = queue_atomic_write_boundary_bytes(rq->q);
> 	unsigned long boundary_mask;
> 	unsigned long start_rq_pos, end_rq_pos;
> 
> 	if (!boundary)
> 		return false;
> 
> 	start_rq_pos = blk_rq_pos(rq) << SECTOR_SHIFT;
> 	end_rq_pos = start_rq_pos + blk_rq_bytes(rq);
> 
> 	start_rq_pos -= start_adjust;
> 	end_rq_pos += end_adjust;
> 
> 	boundary_mask = boundary - 1;
> 
> 	if ((start_rq_pos | boundary_mask) != (end_rq_pos | boundary_mask))
> 		return true;
> 
> 	return false;
> }
> 
> I was thinking this check should cover all cases? Thoughts?

that looks ok (apart from issue already detected later). It is quite 
similar to how I coded it in the NVMe driver, apart from the initial > 
boundary check.

>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index f288c94374b3..cd7cceb8565d 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -422,6 +422,7 @@ enum req_flag_bits {
>>   	__REQ_DRV,		/* for driver use */
>>   	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
>>
>> +	__REQ_ATOMIC,		/* for atomic write operations */
>>   	/*
>>   	 * Command specific flags, keep last:
>>   	 */
>> @@ -448,6 +449,7 @@ enum req_flag_bits {
>>   #define REQ_RAHEAD	(__force blk_opf_t)(1ULL << __REQ_RAHEAD)
>>   #define REQ_BACKGROUND	(__force blk_opf_t)(1ULL << __REQ_BACKGROUND)
>>   #define REQ_NOWAIT	(__force blk_opf_t)(1ULL << __REQ_NOWAIT)
>> +#define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
> 
> Let's add this in the same order as of __REQ_ATOMIC i.e. after
> REQ_FS_PRIVATE macro

ok, fine

 >> @@ -299,6 +299,14 @@ struct queue_limits {
 >>   	unsigned int		discard_alignment;
 >>   	unsigned int		zone_write_granularity;
 >>
 >> +	unsigned int		atomic_write_hw_max_sectors;
 >> +	unsigned int		atomic_write_max_sectors;
 >> +	unsigned int		atomic_write_hw_boundary_sectors;
 >> +	unsigned int		atomic_write_hw_unit_min_sectors;
 >> +	unsigned int		atomic_write_unit_min_sectors;
 >> +	unsigned int		atomic_write_hw_unit_max_sectors;
 >> +	unsigned int		atomic_write_unit_max_sectors;
 >> +
 > 1 liner comment for above members please?

ok


>> +static inline bool bdev_can_atomic_write(struct block_device *bdev)
>> +{
>> +	struct request_queue *bd_queue = bdev->bd_queue;
>> +	struct queue_limits *limits = &bd_queue->limits;
>> +
>> +	if (!limits->atomic_write_unit_min_sectors)
>> +		return false;
>> +
>> +	if (bdev_is_partition(bdev)) {
>> +		sector_t bd_start_sect = bdev->bd_start_sect;
>> +		unsigned int granularity = max(
> 
> atomic_align perhaps?

or just "align"

> 
>> +				limits->atomic_write_unit_min_sectors,
>> +				limits->atomic_write_hw_boundary_sectors);
>> +		if (do_div(bd_start_sect, granularity))
>> +			return false;
>> +	}
> 
> since atomic_align is a power of 2. Why not use IS_ALIGNED()?
> (bitwise operation instead of div)?

already changed as advised

Thanks,
John


