Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70886464716
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 07:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346891AbhLAGUb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 01:20:31 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346866AbhLAGUa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 01:20:30 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B10XHj2003547;
        Tue, 30 Nov 2021 22:16:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=O7Yd+3Fz9rhA0P96Yk5UqUcTU35dSKZuvUBpd1uj+k0=;
 b=Pg9TDTTrKUk7W153ZNkn1nE/de9NIBn+uv734MNO7YRfxBw1ICuEJKB8VqoTUKzPszm3
 LqBoIDfBd/FKKu3daFqtT8a54xyLT5IalHi2X5RDFH1vnUh803R1wNl1U2gV4+HLe/gY
 K8TUqSoebk/xNox3DGV5P0QZCSXtv6dMl50= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cnvbttk76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Nov 2021 22:16:57 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 22:16:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIvCE/0nz+0D4sTORQn0MMM0d3GhiquwP8FdupLqThP1jEY6ZB1PZwXTEWB5oUSXxoDiXhk82qVtxHkzXthjpu3aDFGtqEuCfYSmZGz+Zr0JUhqE4zcmGn1GR186A3Bx8K1nd2mliOBSwwGEM+9IeCEQq309a7TIsKeWOCgXzzA3ieZg5vcrZrFHsgJyn31b39R9o4mN5Qr7+dgw2lWR08YzBDzRWFuW2N+baAQOPH6B85pbQiz/1S9lQgUF1g+TNosjTuEU/0WVtat9fa/SbzRntJX1/w7DLRM4GfUWLwNgiHuIWWGKbVDdKqbqh+dV3npBoSu2jdqLGlmPBmouaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7Yd+3Fz9rhA0P96Yk5UqUcTU35dSKZuvUBpd1uj+k0=;
 b=Xxre35If8NetUIxZolqErnneM+gNCvcM9fE4r5c+Zj6kg+6G4UcxGkEf9au1rLP4oBae29JZYDNWD/BuvHhHNmiW1LdETPUnRJvDXifVLV4tnPfyVNfg6X/GSRfzQis5gGQVoSdgad2CzCse/0NTLUdeGuvZ+rBpPBRDVVfGoRRVq9EdEu8dvBBnuDMqJKtFcPFSdmtkJgMa4783Wq5cqMFfUb2f79nOONkbMlamk1hoJ+/2nwOJsVJ0wP3W1u9LkAATGfh2U/2paAar+HercU8BRMgnlj6NNrP0hQiedVGadSW+Ak9bzGAs9z33woajY2tD7kNUVvd0GTQxadAeFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MWHPR15MB1759.namprd15.prod.outlook.com (2603:10b6:301:4f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Wed, 1 Dec
 2021 06:16:55 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf%8]) with mapi id 15.20.4713.025; Wed, 1 Dec 2021
 06:16:55 +0000
Message-ID: <f9203814-6082-4035-e778-65cecfe9d015@fb.com>
Date:   Tue, 30 Nov 2021 22:16:52 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v1 0/5] io_uring: add xattr support
Content-Language: en-US
To:     Andreas Dilger <adilger@dilger.ca>, Clay Harris <bugs@claycon.org>
CC:     <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20211129221257.2536146-1-shr@fb.com>
 <20211130010836.jqp5nuemrse43aca@ps29521.dreamhostps.com>
 <6A6C8E58-BCFD-46E8-9AF7-B6635D959CB6@dilger.ca>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <6A6C8E58-BCFD-46E8-9AF7-B6635D959CB6@dilger.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR2001CA0019.namprd20.prod.outlook.com
 (2603:10b6:301:15::29) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21c8::14c4] (2620:10d:c090:400::5:8065) by MWHPR2001CA0019.namprd20.prod.outlook.com (2603:10b6:301:15::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Wed, 1 Dec 2021 06:16:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6aebdacf-54c6-4ad2-06aa-08d9b4922c55
X-MS-TrafficTypeDiagnostic: MWHPR15MB1759:
X-Microsoft-Antispam-PRVS: <MWHPR15MB1759844D981A6AEA6EB362FED8689@MWHPR15MB1759.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z1jvfHYnqNZrWF/XDY1vLNljUfMQjuwnA/zsC+CcgTnYV5k34gj7R3NrFHkvvS1TJLmZfNgQ/4ktg5xxwphEyrEIcRPPOilpM1pZsapaIK0ElbiV12mwyb+sjF2zT7qW5xUFKuInjKvLBsTzT3KgRe/Xc6WXaeP7QYNzDbzu8nQuGTVVGUUJ2Cky/HPS4YbgTMMcOCfn1FdV07ZIf0Iow9rRBRA67bz2dkytmXBnAnoSKE+kL55SxWrvVuicL9kkAv+Dnq8dTNdojRkH5ZFVRc11g0CMLmK43m+7ytcD2byj4cFKvN067wqysb+OQLvz2Vp1a2530TbZtkYBax+IzSpHQ1e+D+jwbuQSHAIKYPeHQTJZToRtz2ci26T/BF3gfLsCOZfnyql5bZ1GUsQ0QFm/ZGUUJ0njpPe+2xqAS/TU4O8wBIkfcsWPdJNZx8nz1bsPzZxw2yYug2yGA6oNcFzE9RsTc3pc3BAj6xrfY9VG1v3+sPNlCUIPS44BglkhoynzsfsNhhMQXRl+RUTPFHZXdzsEj8otbvwyCsjya9VptaxPf+0bUjC/a87WG/zYH+9o0rVh455ufdqikvVEJGr9dHJPyskBcPWa8JJCV49Ufrr5AYw63nuynst5oR4vX2nUV7uHFbJlvJYuebb/KqsKkt/NTv6v/A+yT3BhFztsjWK2Wzaijg263kmDhTgpLsg819by1B3Nu8xLftlxmwYOOpnA23hBUhg8N3E+nqupXn53FWo5+q38ZrJIUWkjk4ZyK0639OQpM5tSFgKUv+tcRtd6Sgp91cmNozBuKmI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(4326008)(316002)(83380400001)(2906002)(31696002)(86362001)(8676002)(2616005)(36756003)(186003)(66556008)(66946007)(66476007)(38100700002)(110136005)(508600001)(6486002)(31686004)(5660300002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHRtZjBpSVgrZllzZ29TMHRtelBaL0lJZFNNQ1F3SS9NVTcrZnI5UjVEYVRI?=
 =?utf-8?B?WkczRjM1ZVozRkdVd0k0SnhISVdLZ2NBdjZOYmdWL2VWSGVRTSs2MFlDcm5H?=
 =?utf-8?B?U0hvbUhXazBRWDIyWm1mZGVveHNDSjQzZTRSZFB3SWhEK0lvWmgyMURIM0xQ?=
 =?utf-8?B?ejliakpYaFE3N09Mai9hOXNnZkJYd2t1RDlVeGJpOG14Vkl2dnU3ZTl6aWhs?=
 =?utf-8?B?eGhwUDB4VFRzR0FldndaTk96ZDBjSW1tNVRLanRYMnB2YXNva2lLMGtnUzdo?=
 =?utf-8?B?U0hBdFFKV2pBNzNkcFQwTWRRYXlrNE5NZFl2NXR5Z21LNFJTQlZYWmtRanZr?=
 =?utf-8?B?M1dzWDJKOHhGZHViLzhDVXFMdXFjWXlSMURIVUppcXBDN1JQVTdSaVpaZVBW?=
 =?utf-8?B?RWh5U3ZXTGR5bzByWHdwM0RJNUp1VSthYmg2MlJBT3VJdzc2UExxalE2ZEpm?=
 =?utf-8?B?elJIKzI5eVJMU2ozOHk4enFjYTdUaksxcmVYRVlqTHBzVEFWUkF0Qk1vaHFB?=
 =?utf-8?B?bENXTFBvY29wdTN2TlNIVVBBRnQ0czNzaTQ2dU0xSXZ0R1FnczdNY28zUnVC?=
 =?utf-8?B?cHQzUjFrMFhXQVp4YTdhWFc3V1E4amg2blh2NVQrSFA2a21iZGZaRFJCT0F0?=
 =?utf-8?B?OWJHN0pYNUo5cmxXNUEreUNmaCtMck9BT3FtZituVXl0c01BWEdzSGRZV1ls?=
 =?utf-8?B?bUl0NHorV04yeDFjQVR3T2tKb2g4Rno1M2FhVFZTSUhSS01oR2o2a1pldkVv?=
 =?utf-8?B?RGhXU1FNQU4xRkMrdm5WcDhJbG1jbmEyYVNvY2hTWFlxakpXYzJRZisxNzFX?=
 =?utf-8?B?YnpzcVY5MDlhOXpVN0VWZHF3UG05am00bFpZMERBWGVrcmYyc2ZzVlprenNX?=
 =?utf-8?B?NE1LU001dTUxQVVRQk9TcTVUSmdIVjZrdi94dzlOR2VCSlVTamtFMkdnYUtW?=
 =?utf-8?B?MnljZzJCV1VITDFrQy9MQ0NHNTNFenUxajZvQzF5MW5kL3owaG01SUg1a2xW?=
 =?utf-8?B?cGV1OTZjeHVhZnAxb2xDck9GT0s5ZlQxbmtMVnpzNUt4RE1WUG5kd0FiK2RU?=
 =?utf-8?B?SDQ0U2tYeEd5OUdLd3JrSmhsQVRNbWxXbWZHOGY2dTZ0RDZDM2xrNE9aMFBC?=
 =?utf-8?B?VzhWdDNrWkt6UThHc3JRK2lYbXNaR2VxMDF5aEI2a1dsSkVTTVZQTXNmVkht?=
 =?utf-8?B?RVhON2lVSlVSYmF3UzF4OUw4TWdDT0lXa0xlVHVzd1F3eXpIRjZSSCtUQmVo?=
 =?utf-8?B?R29MWWtpcHRVZ2xKZmtoc2VFdy9pKzFmVFJUMVcxTDNaQkJ6ZGg4N1MrUjE2?=
 =?utf-8?B?VHFCc0dpS1JVWmNzQ3dCMFNlVnppRzdHM1dwcDVQK09mOWc3V2VhN0NyM1lT?=
 =?utf-8?B?Z1lpWGlhNHhaeVh6dEVxY0VmdU1pWGVBMW5MM2hsMUxZQkpSSjFXNmV4cXBy?=
 =?utf-8?B?cXBGR0I1VExTOURNdlFFZng1d0VteGN2Tng3SmRmZnZCb2VVWjBHWG8remMw?=
 =?utf-8?B?dC8zWDFMMTZhaXhTWFVub3NuZTEvSzAxWTQ1UG5sRlBVRldRUVZlVlgwSTJF?=
 =?utf-8?B?Ly9iWjhJamFUN29qdkJBT29aR1grQS9aaUplang3bFNyN0JJUDU4YWNndHBj?=
 =?utf-8?B?Slo3dGlCWEk3MzBBS1hzNlg4aXQ5UVlEOXFsT0lTUS9tUjJJamVXYlJWRkpI?=
 =?utf-8?B?VlQ4cTY3QnVZSUU5akVpQVJ0K1hWR1FCTHcrNFUrUXhrMVJyZmVFL3BYcDg4?=
 =?utf-8?B?a2Jxdnduay9YVHlGeVp2WTJHaFo3QlMwazNZUDRLMkZ1S21XKzRCRmpvYWZ5?=
 =?utf-8?B?b3Y4WVlPSTdjYWJ1T0k5a01QVWJVRDFJY2NldE9jOUI2SnpSS1l6d2NESXAv?=
 =?utf-8?B?c010TkJRdzd2ell2V054UkVxdVhJcnZnTm8wbHpOV25xKy9rOTFMWWZpSlhH?=
 =?utf-8?B?MndaWVI0aWZtbExKdi8zVnRWcXZORTRKR0VhVkZPL2dFWFkvUjNoWU82Rml4?=
 =?utf-8?B?bVFWc1NnWStuQ0w4Um42aUNOOGViQTBhL3JQS3dHeDR2SDVsM3hkVVl5N0hq?=
 =?utf-8?B?L2tWRGxSaUlVcVY3ejdvY25HWUJ3RksyZ0YzellLQXQ4dG5qMlgyYmZRUWJk?=
 =?utf-8?Q?/9W4Oa/l9fhlZvGy01u1kULsH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aebdacf-54c6-4ad2-06aa-08d9b4922c55
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 06:16:55.3024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tA6ObvVX4E5FpJiRfySp2Em6/j1RrY4UFcaxufhKINHW59G2VsNBAyFvH39O5xgw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1759
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: lIePySmfiNSjs3kFmbu1sOvDgaTHNiRQ
X-Proofpoint-GUID: lIePySmfiNSjs3kFmbu1sOvDgaTHNiRQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011 phishscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010036
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/29/21 7:16 PM, Andreas Dilger wrote:
> 
>> On Nov 29, 2021, at 6:08 PM, Clay Harris <bugs@claycon.org> wrote:
>>
>> On Mon, Nov 29 2021 at 14:12:52 -0800, Stefan Roesch quoth thus:
>>
>>> This adds the xattr support to io_uring. The intent is to have a more
>>> complete support for file operations in io_uring.
>>>
>>> This change adds support for the following functions to io_uring:
>>> - fgetxattr
>>> - fsetxattr
>>> - getxattr
>>> - setxattr
>>
>> You may wish to consider the following.
>>
>> Patching for these functions makes for an excellent opportunity
>> to provide a better interface.  Rather than implement fXetattr
>> at all, you could enable io_uring to use functions like:
>>
>> int Xetxattr(int dfd, const char *path, const char *name,
>> 	[const] void *value, size_t size, int flags);
> 
> This would naturally be named "...xattrat()"?
> 
>> Not only does this simplify the io_uring interface down to two
>> functions, but modernizes and fixes a deficit in usability.
>> In terms of io_uring, this is just changing internal interfaces.
> 
> Even better would be the ability to get/set an array of xattrs in
> one call, to avoid repeated path lookups in the common case of
> handling multiple xattrs on a single file.
> 

You are proposing a new API. However that API has its challenges:
- How do you implement error handling? What if only some requests fail.
- It will make the code considerably more complicated (for user-space
  as well as kernel)

Instead the user can do the following:
- io_uring already has support for the following:
  - io_uring already has the ability to prepare several SQE's at once
  - These SQE's can be submitted in one operation
  - The SQE's can also be linked and waited for as a unit.
  - Allows to map each individual CQE to its request.

>> Although unnecessary for io_uring, it would be nice to at least
>> consider what parts of this code could be leveraged for future
>> Xetxattr2 syscalls.
> 
>>
>>> Patch 1: fs: make user_path_at_empty() take a struct filename
>>>  The user_path_at_empty filename parameter has been changed
>>>  from a const char user pointer to a filename struct. io_uring
>>>  operates on filenames.
>>>  In addition also the functions that call user_path_at_empty
>>>  in namei.c and stat.c have been modified for this change.
>>>
>>> Patch 2: fs: split off setxattr_setup function from setxattr
>>>  Split off the setup part of the setxattr function
>>>
>>> Patch 3: fs: split off the vfs_getxattr from getxattr
>>>  Split of the vfs_getxattr part from getxattr. This will
>>>  allow to invoke it from io_uring.
>>>
>>> Patch 4: io_uring: add fsetxattr and setxattr support
>>>  This adds new functions to support the fsetxattr and setxattr
>>>  functions.
>>>
>>> Patch 5: io_uring: add fgetxattr and getxattr support
>>>  This adds new functions to support the fgetxattr and getxattr
>>>  functions.
>>>
>>>
>>> There are two additional patches:
>>>  liburing: Add support for xattr api's.
>>>            This also includes the tests for the new code.
>>>  xfstests: Add support for io_uring xattr support.
>>>
>>>
>>> Stefan Roesch (5):
>>>  fs: make user_path_at_empty() take a struct filename
>>>  fs: split off setxattr_setup function from setxattr
>>>  fs: split off the vfs_getxattr from getxattr
>>>  io_uring: add fsetxattr and setxattr support
>>>  io_uring: add fgetxattr and getxattr support
>>>
>>> fs/internal.h                 |  23 +++
>>> fs/io_uring.c                 | 325 ++++++++++++++++++++++++++++++++++
>>> fs/namei.c                    |   5 +-
>>> fs/stat.c                     |   7 +-
>>> fs/xattr.c                    | 114 +++++++-----
>>> include/linux/namei.h         |   4 +-
>>> include/uapi/linux/io_uring.h |   8 +-
>>> 7 files changed, 439 insertions(+), 47 deletions(-)
>>>
>>>
>>> Signed-off-by: Stefan Roesch <shr@fb.com>
>>> base-commit: c2626d30f312afc341158e07bf088f5a23b4eeeb
>>> --
>>> 2.30.2
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
