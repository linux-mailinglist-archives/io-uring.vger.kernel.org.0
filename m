Return-Path: <io-uring+bounces-1220-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FA6E88C3A4
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 14:39:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 452B02E4E60
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 13:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF8C762F5;
	Tue, 26 Mar 2024 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YxHgbipc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DeonNiJG"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335FF73518;
	Tue, 26 Mar 2024 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460378; cv=fail; b=SgYS8wgQ3dRWhxwx9l7cBScKTtx4XJdQb0OYJDB3Hus1iubDoV3TQIAm9QhfvxL6r6hp8EHVJFKv5vo1Orsjmm89TJoSt1MQMuY9k8PhGEx+ZcD72nAcit3R7phRFeoYs2Fn5O1jmnf5rqVdfz8LzxaBt6eKUcidjjZLGKmP6EQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460378; c=relaxed/simple;
	bh=6PiPR0VqLMXYTI74uleFDDaO33HQzPm5FcI7zP3svZI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Z+A4ZFiF8yuP8s6Zs4dU8wKNlerUn2hKJZxGXtKT/RjaQuDHqXuc+ie+UDm+Rx8qSENhc92PxeOUhsJPDqGL5aqPoBR7QDoqXbOlEZB2wx8bnIzG5DvTnJfAwheqCGSAeNfI6fWWpdGhNqI1IxNUciXyv0CQ8A+vU5KN/+4iCag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YxHgbipc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DeonNiJG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QBnSMo009002;
	Tue, 26 Mar 2024 13:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=oMrZEbEWPtJaixdkqj6DMvJZqDBXzMl/QyEzuB/fb/E=;
 b=YxHgbipce2swCS95B/2sJlo+2Xl+Afn2x2tU1nPUy8XABkxTbYAJjcIqBfS/I4HYoBv2
 MqcS/lWiHApW1/uPkJ849k7KMH65U8wwAZQbrZMk1SU9xKKW2+yYKZFYzSw8vM7Osb0g
 QoTdNO84l62HeOLFOJkIwPyg/J6/ouN2UV5yq4XAgN8fjXn1fX8oVKvPilV9mSzKQag1
 xzgBKGnFd7nK0Smg2+WheUi5jVuWcQlnuM+ehhfN4vxL03ZhogNdOx+rx94N2cUtTMOh
 ssn6Tzzw29P5BcqqnE+9tVe93UbpfHT8fwrb7e9tXFMi41mh+AHvDJ1yhxWwyMJ4kecF pg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1q4dw1nf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:07 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QCMTxC017642;
	Tue, 26 Mar 2024 13:39:06 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh77wcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 13:39:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeT4DXjDPVvW02Ot9Lm1IWu4MmW+rdyBtFBxwRlRdKxnBlD3f1CAwVfAdHeqInbVB9rq7t05T+lkrDGaBqf7V8aE+B/b73sWA0tAXUCWsV/tQLuu7h3Hvnknd2AD6DBsc+HzhKVpWsVsgAlumaFnRICAl/4TJXb1ckiskjuVw+KTCrB8LSa0ebbUoJMTUsMFM+5MTix+hDdqVIg1AjFvFrmTDshsCXLFv4BUUa2XnuUBhMZaCJNUxSPIxs/2tZAhGRtRRENCCQafYLQYICmeEV29YQ+pYCstJJbbXBksX1EHLqsE/2Ff1hrDMNVlngfDTDnDhHrI5taAklqFfahkfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oMrZEbEWPtJaixdkqj6DMvJZqDBXzMl/QyEzuB/fb/E=;
 b=leibvHSIXXSNhmjgF7WVlqJh5D4FTQj50gGjG/xQwyfbSREPMq8DrHT+f7I0FEFflU0/fzkVr9seT6/MI1OECCiVtzzHpnBgf4cnfLqAhO7kZPAPHp2sal6ru4GGy9YUUOPCTvlxo5ojYdiy32+dqSmo3grmPsRDBLHQ039PsOWj2IcuWDZvqchqEi/o3vSA2TvpFoT6CnwfkN6jhwKIhNXBNl4coYTGdtenebNDNtPrWX8zCcyTbAlJBFuYOSmzErueWVVoDGp1eUMaaTzSBKJZHOPVHBEm0Q+nFDc8zOyTA6e+DivHrF3cI3sFIzc8NsLWa7/I8j0mfkTc8YV5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMrZEbEWPtJaixdkqj6DMvJZqDBXzMl/QyEzuB/fb/E=;
 b=DeonNiJGbcM/F3zzfhB+P51MGzR5z8RcCX0Dk7B2/VXtFQI/Qhy4Iy2e2Bce6wqwisAumiqVNA84N8Rfl8JEWOXquFUsebOOGHz4P1UxBTvcz4tC5cwLIhv4XhxC/cXTJpH+BxZsxJf9cyKADACBh0wxNMmrbdxRzJEbUtv55WY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB6666.namprd10.prod.outlook.com (2603:10b6:806:298::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 13:39:03 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 13:39:02 +0000
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
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v6 00/10] block atomic writes
Date: Tue, 26 Mar 2024 13:38:03 +0000
Message-Id: <20240326133813.3224593-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO0P123CA0004.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN7PR10MB6666:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	D/z9GpHkLEtLf5vDDw1v8hTpW7dVykT6bM6956zmcEJS9K8IzfLyCmZjuaMVkIrx+iEAs7v1/bcwlJrJaZo4aiLbt4Co6nxqxnXWlO2KpJu80bYRlXTAXFPczi6O1sm+4Ck5N2CPlSs9zDCNRVipdlB6hCP2hDBuoqrWdVpWPH1912R4ECYT42p4zu1CYj7DWiypRXm1JKkhzhmkCctV3k9uwUvv+dJiiJphb/5YmuDM+4vYFnJeZQzgT7iOlvYINOFSGZaPng2pMnok3r8hnPJaXhPOxa0RbQxdwLJemRTnmlk9poM/VIs2wB5+5CeoO8l0pYkurcgoaU55TVhAv+8HjmvkQgF82VQjtLqXFayD7iq3OJZVo6rFixl4GQzoOOdirpqNZRxeR11fiZl/TMmKUnLvYBNF8aRnfJZ9EG0mWjdcfha2vEhL94mHosbJaFfPov1/YClT8GUYUkWuTxBZVhrLPFCXIwUYMnZJlmcVL78NbXFGYOszsCVnMRu/C10iagLVRdvcq3qthZXFMViVE54xkMgJ9cstH9ul8iCpGPO+cjG75RHPJy+Kmv9uWtvgEDZEdiYdHCvJJfy7ve3a0kgZ6Qc37FsopV8IqruNk4iEf/gL9GsGkW0MG3AEY1L/bQ21kOUSxrfP+wfDczhCNSttCSWR+a97/1UV8NI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eFAxdlphRWJqWUtjUEpqUmlJWXVaOFlLSzRGVjZsSFVjaFMvYlluQkRnS2Zs?=
 =?utf-8?B?dmVLRlEvM3Yzc2hrYlVlemxBeXh5U3c4dGM5WGNKZE9xT2RNcWNkVzkrcWJZ?=
 =?utf-8?B?VERUb0IzMVlzQ1l0RDVtTlhEVnVuTEdnZ21BY0pPMENoL0xWdjUrTy81TjlD?=
 =?utf-8?B?anU0dkNmQ1J3VUVYUVU1ckU0ZkNOYXdMcHYwMEFzdk8zZ1hyQlA1NEoyMlpT?=
 =?utf-8?B?cndpK2tIZkEyL203OTF0Yk1uK2ZyNDQ5anc4ZFFvd1VUcjc2UjU0Qk41Q0xS?=
 =?utf-8?B?UmViekc2TmR5eVVTclo1S01xaTdHRVhIMUtKK1B5ZHVHWFlhQ2lldE5VR3Nm?=
 =?utf-8?B?dmRUWlkwdDBRRmFRY1NLY3pYdzRZekg2aVJDUjNZSjFadmxLWEFCSWx5NHQz?=
 =?utf-8?B?VDQ4c2FvWlBoMHliUDkzaytQVE5DWVhJdFlKeUdoKzJXMHVidkZTdmhJbjhi?=
 =?utf-8?B?N0YwV2RnRXpqd2xWay9nZy94OFhRZFZxcTNjOVRXNlFpQ1MvUWFVcGkvYlVZ?=
 =?utf-8?B?WTJjWjlvbWVpaW8yMVQ0ekpEdW5PUFM3MU1hQVZWU0pFQWVTTTZxWkVyN2hz?=
 =?utf-8?B?WWpZc2o2YTJxVmI1WUthUFJUMXp5UE85anJDeDBON04vUlk2VDhackFKaUdl?=
 =?utf-8?B?UXdENFBoQmQ4bUQ3SVpkMUcrY0ZpR1JoYkhMdE45WmV5bEEwdHFZQXNXMEcw?=
 =?utf-8?B?NEdTa0J1ajdKR3FWRHorb1k2TlpEcHFBMnZFMkE1d3FjaHdKMFhNSFFENXdN?=
 =?utf-8?B?Z2w5b3Y5V1E3NDJ5NUNWME1GY2JKS3Q2Yk5aUTJ1Qk5jMlh4SjA1SzJzb0xC?=
 =?utf-8?B?ZVVLSkJ3OXR3WVZnN0FzZ0hDc0MxVHFiakUvNTFPb0dHdENTeXBlTXFUYWdp?=
 =?utf-8?B?cHBxRFZpOURuK1pqdjBBVnFuS1BQd1RraE5CTzRBeXdrclMrL3JCcVE5RXJ2?=
 =?utf-8?B?bi8rVldCSW5IY0puc2FERWRlWkNpWHg0NG9OVXB5QUFrTmQ3Uk5YV2Y5aFdK?=
 =?utf-8?B?WC96M256elZqd1VIZWpJcVQvYVhrT25NK0QrUytWWWdTaUVZYXpDcmkrcTBB?=
 =?utf-8?B?TnRkNThMbHhCMmx6SzloQ0lzVjl6S2FyZmt4WjJ3WitPUnNrT0dScEU0R3N3?=
 =?utf-8?B?OTNWMmRMVDFzRzRXUVV4cW81TVEyckJWSVlNUDJ6L0VBNjQ5eTVPZmFsOVly?=
 =?utf-8?B?OHJIZjBkcEFKYVBCaHJ1dTRlZDFzTDlBZG1XRFcyRUw0YkRoL3ZsTzdhOFVX?=
 =?utf-8?B?TEhscjBSak9QQm4yK1JSNXlBOUt3d1ErMGN5cU9zUDF5cURObXNhdHZiZk51?=
 =?utf-8?B?VnV0bXNQazE1WGdYZGUrTUI4VC92RVZvSzhlZjVNM3VTTWtFMEZ6eURhaEZV?=
 =?utf-8?B?aDE3dGVIcjdPS1o4M2Q1ZXR3bzJmdi9CNHlBLzNOZ2FrN1pUNGFQMFo5aTV6?=
 =?utf-8?B?bGVEdnFNUVF3VG5keEQrWjdGdFBITUYxNnBhNGRNTy8wa0Zkb2FQQzZyV3B5?=
 =?utf-8?B?dzduSlhlc0MrWlpCczFMdDFFaWd2eE40KzlITWlGRWR3Q2hLbkR2cFgxejkw?=
 =?utf-8?B?ZkhpSHVXVmpYL3Z5alpPMU1vY25mNWorLzJVWGZoSTlwZmFycXdFdzNTOGpC?=
 =?utf-8?B?NmxmRFJLWk1WeXZxOFBXbGdBdUd4SEh6V2ZCelZDZFJrV1J3NE5CYVA1NS9I?=
 =?utf-8?B?aXE1QmdOWlYrS1oxWHRWSElwd2R0azA1UWI4UU5Rc3o1dDJvVG5YR1J6MzFs?=
 =?utf-8?B?U0FTcENsdVBRUGE3Y1RReHdYY1VuNkgybzIyaTRtcjBqTmo2YzNRc2V6MXVB?=
 =?utf-8?B?aTNiaGdJNERsWUZFSm9BMFA5a29SWHBROHRlemdxb1lxT25KWStVbWpWQUZa?=
 =?utf-8?B?ZHBpNmVyQ01qYVNVaGZkNm02c3FDQW1ndGpQWmFTMmZVZUs2OEVCbkhOODd6?=
 =?utf-8?B?UThjZ2YyVU1lcGVjbUpJdTFQT3NwWkNJOFNQRGpCamV2VGViMFFnRi9IOUlE?=
 =?utf-8?B?T0RXNWNQVlR1KzJESkJ6WEtSYnZXZ3pZOEluOHdNTHdXUnV3N0l1SlVZendl?=
 =?utf-8?B?UXN0YitsWTBDczlLcFBMdFdGdkJqV09XeXRwS25ITG9XVHhCZkt3Z0VVWWhj?=
 =?utf-8?B?OWd6YzNkMTZjbUdobW10SitNTDQwbFFaZmNySkhxT3h6K3NidjN0TjdDR3gx?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NRVb5PBBOeaQzjUahgH28D4/CwnTTSF7bvqGS+XHQcmqTHqhRQewvkEdE6j+E+j8dEXRm4QGrtRwUs6GXVsRw5ufJI98h9TmjcdDhCFoW+gKxQFzVo/E207v5ye133KMtW9s7I1+D1gsgOF1mMK+N93tAD1LXabm3JJz1Asjpi+HJLCTt97eLfPUCWzWXG629stwgNR1dwS0QiOieGRWmoljIyxnudbEEak3f5BS2M/yfGiVbHbQlU6y91t6Ik5I96Hinq2wCnRtvb7YJJwIeeg1nlmUkVDA3EeMXrhOVTcJo0Cvv4GmsW1I07nozMmoJj2ZmvxiP+s0pE+Z9HYg8/CczH7Oudl0JjrbtbUjUjPVpg0Mj1AJoCic+CwP5ANesMl1Anb82zCXOicNC1f3Ihf4dodDVt3kLMivO0XTub8+CJSKnRN8vrTFu7+DXU+frulCgABumykRWRfVKtOWhMz5UHr+AVBz988L5Nab8ZKDorsx/gw+PjwzRqNKN0mOi8EAssNJSlmSgUruiSW0VQDtv1/UpV9qkjOf8QmdRYCd3uucMLjmWe4hwqibElQ8Ymez9XZPiM0m7+caO/ghBF1FrAgbRhDLy/gVprpQWMc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49462b9f-5aa6-4749-4d6d-08dc4d9a194e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:39:02.5467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2WVaEe9xMVG7YQsAy8DCeDwLnFcjwmqsXZdA9EJkDEpZkDXglMppEwZ1DiW0G/s8sI3/CKlSuxT5RcamOBc+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6666
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260095
X-Proofpoint-ORIG-GUID: dW11E0SfL-5jY_l9oHrwGF-XEoneWVL5
X-Proofpoint-GUID: dW11E0SfL-5jY_l9oHrwGF-XEoneWVL5

This series introduces a proposal to implementing atomic writes in the
kernel for torn-write protection.

This series takes the approach of adding a new "atomic" flag to each of
pwritev2() and iocb->ki_flags - RWF_ATOMIC and IOCB_ATOMIC, respectively.
When set, these indicate that we want the write issued "atomically".

Only direct IO is supported and for block devices here. For this, atomic
write HW is required, like SCSI ATOMIC WRITE (16).

XFS FS support has previously been posted at:
https://lore.kernel.org/linux-xfs/20240304130428.13026-1-john.g.garry@oracle.com/

I am working on a new version of that series, which I hope to post soon.

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

There has been some discussion on supporting buffered IO and whether the
API is suitable, like:
https://lore.kernel.org/linux-nvme/ZeembVG-ygFal6Eb@casper.infradead.org/

Specifically the concern is that supporting a range of sizes of atomic IO
in the pagecache is complex to support. For this, my idea is that FSes can
fix atomic_write_unit_min and atomic_write_unit_max at the same size, the
extent alignment size, which should be easier to support. We may need to
implement O_ATOMIC to avoid mixing atomic and non-atomic IOs for this. I
have no proposed solution for atomic write buffered IO for bdev file
operations, but I know of no requirement for this.

SCSI sd.c and scsi_debug and NVMe kernel support is added.

This series is based on v6.9-rc1

Patches can be found at:
https://github.com/johnpgarry/linux/commits/atomic-writes-v6.9-v6

Changes since v5:
- Rebase and update NVMe support for new request_queue limits API
  - Keith, please check since I still have your RB tag
- Change request_queue limits to byte-based sizes to suit new queue limits
  API
- Pass rw_type to io_uring io_rw_init_file() (Jens)
- Add BLK_STS_INVAL
- Don't check size in generic_atomic_write_valid()

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
 block/blk-core.c                     |  19 +
 block/blk-merge.c                    |  98 ++++-
 block/blk-mq.c                       |   2 +-
 block/blk-settings.c                 | 109 +++++
 block/blk-sysfs.c                    |  33 ++
 block/blk.h                          |   9 +-
 block/fops.c                         |  47 ++-
 drivers/nvme/host/core.c             |  49 +++
 drivers/scsi/scsi_debug.c            | 588 +++++++++++++++++++++------
 drivers/scsi/scsi_trace.c            |  22 +
 drivers/scsi/sd.c                    |  93 ++++-
 drivers/scsi/sd.h                    |   8 +
 fs/aio.c                             |   8 +-
 fs/btrfs/ioctl.c                     |   2 +-
 fs/read_write.c                      |   2 +-
 fs/stat.c                            |  50 ++-
 include/linux/blk_types.h            |   8 +-
 include/linux/blkdev.h               |  67 ++-
 include/linux/fs.h                   |  36 +-
 include/linux/stat.h                 |   3 +
 include/scsi/scsi_proto.h            |   1 +
 include/trace/events/scsi.h          |   1 +
 include/uapi/linux/fs.h              |   5 +-
 include/uapi/linux/stat.h            |   9 +-
 io_uring/rw.c                        |   8 +-
 27 files changed, 1173 insertions(+), 192 deletions(-)

-- 
2.31.1


