Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3A045E345
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 00:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347597AbhKYXXe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 18:23:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5298 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234127AbhKYXVd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 18:21:33 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1APEhTSG002301;
        Thu, 25 Nov 2021 15:18:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VYueHGRaJBLxKBHRmRqDo20FwyCUuasIe7a/SK/ve7s=;
 b=ELmlssHjHa2I4hIhwO8PVZ8gmSMOlgAfIYDIDfJwloS2sAFqFQE71qBh4AJZFM6XxN1m
 HYh0YcnpQXgTOb1BDmwrTtrz5V2yoypehVYGMqUlPhjobnuaBPbcUjzJrc2/NMnwOwij
 wrSM0obiCz8uM3pBXlIEFIwJdveOlUNoDgk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cjcgf255s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Nov 2021 15:18:20 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 25 Nov 2021 15:18:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgQTdTBa5D/BlbpxXEHMz9uI3G5YluBEHnjKtcSNf8MHULTtyngtIaZuQEbfw+ecQ/agzuze64S3Swt3Yi1diY+waoiYQcvt6VK6qMcwXifBNKI50WGq77ED6iCyNom8Kujz1j2GVAgUOz1Rp6HPIfxQf4C5pvOH6+wA39bLiFpbPMMgHU/8WDUoy0tO+LR7wydUcEj9ioaf29QnLddUiQokeE+II/g3GdcOgNDVFQFCR2zc5Lm0Ci+qwt3cquX+j8FH3HLxqHvv2+TChShzl7Ac8jsa2XS+AmoIGZSg73QbZ1AvHCwn5iTuh+ZC1vPvdEzoL0Ctk1THn4HStGjm0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYueHGRaJBLxKBHRmRqDo20FwyCUuasIe7a/SK/ve7s=;
 b=gD/N+Z+NGRkLbK6jF6KZCrSLpsUON1Khcn9n8FcUGz8eI7U9REXFWFE+/lamtu5tN+nvix7w54yrjZpysetTKg2KdGEvSqn2wk2QUfkRPdqkwxiGNv5CwdNUqxbw4+YRrbRY4uU5TkH5Zt4NA9hxyrO/x5zcId7JG9aSEtBcvZjvlgxh1TZIYmbHSTX86gc2OjM2KfVW+m7cOruH5uj6/pygf7vd7qE6pklwQVyK4YATsZ2oLqp8IfFvcsRs/kfttgTWJbsVc4MsGQmzhq1Xq50PH7QFAzEaU1wm/0RdIf40gV3Z6sWcASu9uA5AZvgS8kwq0tm0dqDAKAdCHgHxMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MWHPR15MB1520.namprd15.prod.outlook.com (2603:10b6:300:bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 25 Nov
 2021 23:18:18 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf%7]) with mapi id 15.20.4713.025; Thu, 25 Nov 2021
 23:18:18 +0000
Message-ID: <b822831d-5ec9-7d0c-5df5-44733064e9fc@fb.com>
Date:   Thu, 25 Nov 2021 15:18:15 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v1 1/3] fs: add parameter use_fpos to iterate_dir function
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
References: <20211123181010.1607630-1-shr@fb.com>
 <20211123181010.1607630-2-shr@fb.com>
 <CAJfpegsusDTYwRm5ig-EnvG0c5vqCRozuj34YcbTAD1kqi02Cg@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAJfpegsusDTYwRm5ig-EnvG0c5vqCRozuj34YcbTAD1kqi02Cg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0038.namprd16.prod.outlook.com
 (2603:10b6:907:1::15) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21c8::10ac] (2620:10d:c090:400::5:4a57) by MW2PR16CA0038.namprd16.prod.outlook.com (2603:10b6:907:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 23:18:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a43f9fee-a934-4c64-777c-08d9b069dd4a
X-MS-TrafficTypeDiagnostic: MWHPR15MB1520:
X-Microsoft-Antispam-PRVS: <MWHPR15MB15202EB7F6056CADC1338F6DD8629@MWHPR15MB1520.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RRLUfVl8NakztoLmhDRvJ6bqSMAlohRnFu4AMmcLUMSPq1I+gTdlRRoqyUAXqiCdcmDrh/hE0V7Tk+CCUeetKTJ4xSkITls93SbDus6cCQhWsHHrIlMRdJ0ZJcptwrWbiJlOatmqld+myAu0OWSr+zyA1vQmbLs9Q9toL7Y76citK4tAuCjWLvDkEX1m3SAhzLPkBA/uNr7oZY5zJntvtWs6X07aZ18Mixz1VykXnTVPDM6A2XZJm5Pd4PmP2Jc59sb/c8/XRSLibe6lUKfG8sa+DNpdICnX/BMg4CmKQ4m87flV9JC2ylrHxifPsZWC0wcQWulUcgC+OReTu6FmnJ6RORozg+X17JAwHJqSTzIVozfJZpZzar/njk/I+p5HSU+oS5pKye0jxq9985yayIS/0tZbOIxPwb6APZmY87hVa7mvl49wdhjiubDjcOcc3AYPlRYMnwso1SkiCAFvxrxeBorNOQw2MEeoz4wlEYJqpYZC7Xs47PeTQ30dR6lSo3VLNbENK/6eYqAJip0GL7mBoRYBF4DmIR8vZUx8El19l8JFavGLnjkgrupFD43n2BGwPGvXJt+tWtLkNyzWGVZ+F90TUWceIIXqKlluw+2sjh1MIPLml0O0OzqVTiUKNgX/37AN79LMrIl1UtQfquTwq3xSZwqbRltzblGEVO1nHshsN6AyzET0xDal6F4fi3xGGOO0Wap8vIYFFUxlTbv5VFVuNbZcMev0t1tHx6c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(38100700002)(66946007)(316002)(6486002)(4326008)(2906002)(53546011)(31696002)(508600001)(86362001)(186003)(6916009)(8936002)(66476007)(66556008)(2616005)(8676002)(4744005)(83380400001)(31686004)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1lqTHFjL3NhN2MwelNuMzNSSVhvdzJPMGVIRnZIRXBPQ0pUcC91VFQ1N1o0?=
 =?utf-8?B?cTNXL1hEZ1UzUDlqSnFXL3FHZWhuQWdYQ2tkR2ZjQmF0ZHhhemtsT2Ywc2px?=
 =?utf-8?B?eFUydzFMOHVmWmZKempnSzlRTC9mSzR3K0Noa1VlcG9ZREwvTSt4Ym4vQW1J?=
 =?utf-8?B?emxpZUN5UFpNL3c1NjI5SFM3MFVRVUpUYVduelppNG1aZlNEbzBPcTFnNXdU?=
 =?utf-8?B?RStEQ285cnlEMzJFRC9kOEFDOEZLTElkbitlL0wza2liM29tRERvVW16bk9U?=
 =?utf-8?B?S1Uwc0FaanBQNVhPSXlDNmt2RXZUeXg0WWVzSzJDMUZVbXJHZnQzU3JTdmlE?=
 =?utf-8?B?WUxMZC94QkhpY2hqRHl4UUlGL2ZRalJieU9tVlJpZ1k1Ly84OTBEKzJpT1lk?=
 =?utf-8?B?Y0xydmFrNXZ4a3ZmQTFlblBuK0pReC9Ha3VNNEpzTjNRTW9xY24rSGZxUUls?=
 =?utf-8?B?alZwRElZKzVqUVRKTXNMVENUT2lyZ281ZnBQbm5heWNzSnIrT2ZweEFhVWx2?=
 =?utf-8?B?cDRGV21SeXpEQ1NJREowNzMrZ1l2NTcrUlZZaXJ4bGdJRVoycXE0a1hkTmVk?=
 =?utf-8?B?eWtlNCt6RDdtVXI2RUJYYnZNMys1VjVXdXIrMGw1R2g2Z21DdVlmdTc2TUls?=
 =?utf-8?B?L0xPWmtCT2RLTWhRcUVqTEpqdk1nM1o5VFB0NmhWdnlMYnZIVlNvZ2UwaW9W?=
 =?utf-8?B?bDBqbll6L0Y5UnBGRkMvMjV4aUxGMzUrbjFBWW5YWlhVUnZzOTFvVWxhU2x1?=
 =?utf-8?B?akkzU0VUOHFRS1psM3pMR1pDUitCVTBnL0xjbE9hRTB2ODRvbWo1TWVtN0Rx?=
 =?utf-8?B?Wi85U2pXNWZDS3BNQzlXQlZ4ZW9QTEFZdEJGUXNLeURhdmQyWDF5cGJnQ0dW?=
 =?utf-8?B?UGFmM2ZnUEZxOWIzMTlrV2d2K0lMaTRwMDN3YXdjNVQ3R3lVZ1JRR21ZK2RB?=
 =?utf-8?B?MXMzN3ppbWxyV28wZVZQcnJLSEhabE45djVJMVJZc1MzVXdTSkdBU1UwZ3Zi?=
 =?utf-8?B?bjFRS0dUQTk2UXNXUkhkVng2L011WjVjcis4TVlyYU1WZTNxS2xWNE5JMEJm?=
 =?utf-8?B?TVlpR2VxSWpqc0dYcVk4UzFHWmtrMlhPVnc2RVpVTlBGVzI4WVdKUEVuWExQ?=
 =?utf-8?B?T2wycXA4eUxwSUUvYzhaVmpDZlp6bEdKbDdQY1BUQk5nV3BlSVFzUllUV3hx?=
 =?utf-8?B?WktuOGd0UGVINHM3OXJXUENISWlaRWttekRXRjQzS29mY0xUKzdlYk13YlQz?=
 =?utf-8?B?MEl2a1NKbzdLYWxTYnJqUjN3OE5hUHBZZmdLSlJNbGx2ZkJWc3ZEMkpZQmFK?=
 =?utf-8?B?SzA4RGQvY0QvZnlEK3F2TkU5SndFUjA3eG1iNUZreUlPSVE5N3FyUEJmQTJ3?=
 =?utf-8?B?dEowcHJ6RFplekZuSmUxQ2JLNnMwRTAyemVBS0g3VnQ2WnlRRjN1cG1ScjRD?=
 =?utf-8?B?V0N1YmR5ZGNkOXNQOHFpaG1tN3BObmkwazR4VEZYV3dQQkN2TVArdXc0RGlQ?=
 =?utf-8?B?K2tjS3djcm1xWllLVlAyd29EdEp4dDMwUFFTSG56Z1JVM2RoQ1ZaZi94eW5R?=
 =?utf-8?B?RC90aWloaHpSQWwwY1hGbzh6K1dHR0lvSDlNQS8rSkNobFMxcU5Fb1d6dWlz?=
 =?utf-8?B?Z2M5bVNmYnFSLzBQbUlOOWRScHhWQU8zclFrc2F2VVZsU1hkaU56TGNzYkVV?=
 =?utf-8?B?emF1VjhlMHVuQUVmc25ZSm1ULzVWZ1RGbnpmNTM3RTB1YTdYT3hVWGpzMFd4?=
 =?utf-8?B?TzkvblROdythNmZkNGhkR0kwamRGUjQrN1dGUXRYc0NqZGpZdGJUMElYL3Zi?=
 =?utf-8?B?TDNxL0lDWVZnbmxJL3o0RzBpaE0wUTJjRHRXMHlMUjlzN045YnlZdDBWMU9z?=
 =?utf-8?B?bDk5MFpyQit3WjBEVEhld29URFRMZjhaZDdsNDRzcUJFMFBoS2EyMWZUbzJB?=
 =?utf-8?B?RHJJd2tMajJGMlQzSzYxYk5uQXA3U2pmdk9na3NMN1BTN0tYSUVtdVZORlhX?=
 =?utf-8?B?N0k3bitjMTZrQnZHdzFRS2tjdHZPclFrU0hkemJ5VVdTeGtiQ1VPL0xDYVRY?=
 =?utf-8?B?OERLZWthaHVTblBXbW5HSXVHWGdJY2loZVBlWTdCZVNmVC9Nby9kMnZ5RXVY?=
 =?utf-8?Q?UQw7bWtMuS6amB7cRD1tKRiK/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a43f9fee-a934-4c64-777c-08d9b069dd4a
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 23:18:18.1181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxJAecWiKFLF5NE2FF01zYBEmNPJK0IdXfZPKVk2HDhvWE7WRNm2kgCtwHP87w6T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1520
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: e9e4slye2R2ecqJLWKFeLDvPFujzDAi4
X-Proofpoint-GUID: e9e4slye2R2ecqJLWKFeLDvPFujzDAi4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-25_07,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=823 adultscore=0 impostorscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111250132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/25/21 6:45 AM, Miklos Szeredi wrote:
> On Tue, 23 Nov 2021 at 19:10, Stefan Roesch <shr@fb.com> wrote:
>>
>> This adds the use_fpos parameter to the iterate_dir function.
>> If use_fpos is true it uses the file position in the file
>> structure (existing behavior). If use_fpos is false, it uses
>> the pos in the context structure.
> 
> Is there a reason not to introduce a iterate_dir_no_fpos() variant and
> call this from iterate_dir() with the necessary fpos update?
>

This would cause some code duplication. With the next version of the patch
I'll keep the current function of iterate_dir and introduce a new do_iterate_dir
function that has the use_fpos parameter. With that change the function
signature of iterate_dir does not change and iterate_dir will call do_iterate_dir.
 
> Thanks,
> Miklos
> 
