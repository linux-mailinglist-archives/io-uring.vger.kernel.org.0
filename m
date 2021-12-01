Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20CE4646F8
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 07:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhLAGFG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 01:05:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13608 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346822AbhLAGE5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 01:04:57 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B10XL0T018539;
        Tue, 30 Nov 2021 22:01:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HPhvC6r5Y259JN74ut+Ym60AvO34iu2ZMDchDiTNA3U=;
 b=EYa63LBFtS7S33JYQrhXMJ+sNG1hoTAiIbJy+MCFKvWqlLgFg7wRevvJ0PG1KRjXvRmW
 wIq/uNjxdFd8bogBaMJ5+zoctejEqlbAupKIQQuu05jj5NMSgp0zc21epJWWxVoJvpLr
 uckirujdX9Mt6+ZktY6yiz0cFfOiXcLzy2o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cnd5urv9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Nov 2021 22:01:35 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 22:01:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgMIud3XvLIxsmUlJSEJUgGb+LDzBc3xfEFO0DBqz0/k1ew33J2wo38TAu45JdHr22Ca+B8dZX1BS/fADxAeqFwsVMfGS5ghYlTnHtOEE/TSLgvKl1KeOzZus3XYai3pugfvzn1sw+3o9+4XgJ2uZtq7EzKr8NMQSJBw1Oky4tsrJnvc5nTw7awKAOVRsgoeFL+aISYah0A+T33Qiw54DxMR+m+oKgdotFPhwl8yFojuyQX/9T4PTvXQLHvConrsPKwpZER7/4p0xiLwO3zqbyeNAOSjvMxPCJkyhZTo9YFXTsnsr5O9Zp65nBcGrlDubYEQ6A8nXDyzbLc02jWu6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPhvC6r5Y259JN74ut+Ym60AvO34iu2ZMDchDiTNA3U=;
 b=FI1SV+DNq50RFnp1RoGtxVAUBoLVKzUigwIlU7JhBdJD1huVZmHL/tmpBnjuyPbEUdPabBUeMxFHfmM4HmQ3smTU2gS+/wK+U7kOo7Vr2tkJTLLkIOy7un2k85QDSH3RsmIQAM8bDYy1FQ/AfHasf01ejbw5YIfKSkfmLHsR4NvIar5BOIhCSaqqIsfuwLwLSwLmXFOovdJFR/k1U3I2kDfxdDBxFKd8Uwlcm1JyewqdCZgzldpiObqTtVWi3EBCiyJgMsP9ni5Lk5kpos3irrNmynJV7FA/7HGwhCKA/BsNmn1MhycmL9Mj7P39dIB8yucIm5Y2BDMwK1hYYeZEIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: claycon.org; dkim=none (message not signed)
 header.d=none;claycon.org; dmarc=none action=none header.from=fb.com;
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MW4PR15MB4562.namprd15.prod.outlook.com (2603:10b6:303:107::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 1 Dec
 2021 06:01:33 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f8de:1089:be1d:7bf%8]) with mapi id 15.20.4713.025; Wed, 1 Dec 2021
 06:01:33 +0000
Message-ID: <58fbf170-a1ae-a841-f41f-17c2d6df5503@fb.com>
Date:   Tue, 30 Nov 2021 22:01:30 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v2 0/3] io_uring: add getdents64 support
Content-Language: en-US
To:     Clay Harris <bugs@claycon.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
References: <20211124231700.1158521-1-shr@fb.com>
 <20211125044246.ve2433klyjua3a6d@ps29521.dreamhostps.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20211125044246.ve2433klyjua3a6d@ps29521.dreamhostps.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:303:8c::10) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21c8::14c4] (2620:10d:c090:400::5:8065) by MW4PR03CA0125.namprd03.prod.outlook.com (2603:10b6:303:8c::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Wed, 1 Dec 2021 06:01:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30580faa-8191-45d2-cb09-08d9b490069c
X-MS-TrafficTypeDiagnostic: MW4PR15MB4562:
X-Microsoft-Antispam-PRVS: <MW4PR15MB4562117EBDDB81F0C479A68FD8689@MW4PR15MB4562.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jzDtVW2yW6KbVZOpqpOrqtyDANeAU+74uKW3aL/ggSrZpZJI5tsURH9sr61ILgjR9OGfrWlVsSjQWt9QWFg55M6Da4L/TMgs8rytQouX2H/eZtprXaXegohmwwufEWz1JlFewJ2aI2devlb/YemiwyBWdohOrSvK9HVJl6eiDYaM+70XkcxcWFkRjYhw/R69Y8cZ5XhfW+jBIwyB4y9BDlTAy6IBLH9lymf1H2FyVmKaUkTsW5uHL0xeaiEoU44TuneTBT8C6i6sg8rDz9vCAFVlh2GG6uo8n1drB8gewsfQxsytLOlAYtwWC9YmrK6d0REfTuTI42tnLUAdGJJXbm7xIg+hl9JtHG0b6phJL0cJ4SjW/F6FZydPmWX5rknttk2GH9nObxQjZRmg76TxKLKdC+8uo1yY3WDwmzI176qxnkhaiYEF65jKKjaP3Ot18mcyVjEO0nXr0vXVkYm1RFpSlp57ctOsABGXwbWGlNSicanlzYj3dksz0B3IieNKJ83iZ+ukgJ85r7HMbpZ/QzkvtaqhfcQxc9q2tK8YxejpcPp4jISj2FprV093i7pnnCFLs9zXfnz/y2eQ7CN3/W4JKSAsng9Fq9FxE+H5evQ9W2auN+vbNLM5vwLK6RQcDM/6wiMjtMkbk8VjFDZz8MMwhizI4yh87JC71HgHjy3Xnp5SVmVoWW/KXDAUcm07I9I1Tr24e4RL5i+QMPhLpMB7whNRqG3IPpP8FG/aHqo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(86362001)(83380400001)(5660300002)(31686004)(36756003)(316002)(8936002)(2906002)(186003)(66476007)(508600001)(6916009)(6486002)(8676002)(53546011)(38100700002)(4326008)(31696002)(2616005)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHYzUGF2QkNjb0c1MTZiaGlCb2ZnWjIxR3IzUUNHNExVWnA3ejl2bzFlWTFv?=
 =?utf-8?B?VGFvb2JUTjEzRkhQTE1yMWVqalpMS0VxT055WndZSjJTWnJ2dklsd1k3YUpU?=
 =?utf-8?B?YWlxcEpxaFlOU21YM0FtREhwT3QrUUdwTW9Yd3NGQXdJUHZCMFN2TkZBWkhI?=
 =?utf-8?B?K2JObFJKdHR1L3BkUE16VG43UEI0OHlQbXk0YStXWStkUGh2SkQ3dFNVM1Iz?=
 =?utf-8?B?QmxSeEZibU5BM2s0MlJuQ0V0aHhFNzVKbGtqVkVMT0xHLzZFRGtlaHUrSnRX?=
 =?utf-8?B?VGcydUp4Z1FIYnVsVzNQUDdYZUxHSTB6OU4rYndaMk1nalQvSjBtM0FXcW02?=
 =?utf-8?B?ZWF4Q0ZoY2JIcFJYejEzMHB3eURWc0c4UFc5S3FnbGZJRmdFWkNNZTFab3lk?=
 =?utf-8?B?bnhPREh4NjR1R2RpdUdpVVorZ2E0QzJqUWFIVEp2bVIxOWNXKy9YamxCMWxY?=
 =?utf-8?B?YVZtSzFCWGQxdkVEaWxQcWVJOHp5cjFsNXFFQkxDa1VQdXVWZ3VVQ1FaZnFl?=
 =?utf-8?B?QkkycnFiK2J2TDJRQVEvLzlScmJSZFkwcVV5UlkxK050ZVpsRnhUVkFlUG4v?=
 =?utf-8?B?bVJvY0hiZUdUU1N5b3l4a3NPNHJSdmlSdHhDWGJpM3dkMExGL29tNTdOMHNj?=
 =?utf-8?B?ZFZ1K1IxYUR3S0VjSmtGWDlaRDhJbENkdUppQVI2cFRjaUFhODhGWWZqRUVw?=
 =?utf-8?B?SmlISTZIM2pXL2syMlRPOEE3YURKNS81anN1bGd0NTNOSUlnSUJ1M1J2Yi9u?=
 =?utf-8?B?NjB1RzBWTzZEZUtVanBvYWFmTlZKNXF4TFM5RVFvbEJ3T3B0a2Q2WW9EZVZl?=
 =?utf-8?B?RlQrcjQ5RVhFdFJrMUJtM05MSlIvZ0E3SDU1NzhGVmFGcjhXakpZSFRlZjhq?=
 =?utf-8?B?K2h2d3VRemJuemVleTZqdUhPbFJRUXJEU2VndkJTQTRQWWFDTlEvd0pRblhm?=
 =?utf-8?B?bUpLa08wVkdqZHBGZmN5THE2MzhIYkdvdXdhdmMzTDRzTjNJQmRjaTdYZzlv?=
 =?utf-8?B?Z3pTSWZqUHl2azdmdExsYUdNWHpzemUrdlovMkRzSGRWSzcrUW5NS3dBK2Nz?=
 =?utf-8?B?dzVnU2ZQL0drQVh0TmN4dHJsS1VnV1dlZmpWWU1yZy9TYUtFb0FIWUJuR2VM?=
 =?utf-8?B?emdRMm4vazUxcFF2blh0QlNlYTZ0bVJYclFnTG1IODY3ZkZpRkFIazRFdXIy?=
 =?utf-8?B?TGJIeDhHeTVJU0orUlhpMEpxZmxTRWxNVlVwMVhyOW9BUEpvdmtmZUFOK0ds?=
 =?utf-8?B?UU1oSENGNGJVcEwrd0VMQTZBZ0U4THBaOEwxd0VOR0ZDeTYrTFhPcnFrYW9G?=
 =?utf-8?B?N2hiS3lQQTlkbUZnNWRiV0ZZMWJPcVR5dUNZLzBUNW4zaWhuczZ5blBIQ0Nr?=
 =?utf-8?B?TXlDUXVBQmIxQlJzWUFCWjJ1YWpVZTdzSDNiYzJGaDZaMWNpSFR3bnQ5VzJZ?=
 =?utf-8?B?S0l2MVJhZ2hvMXQ3V1lHcG9uYnhuNlpzNXRkYTNIUmRxZ3E3dkFLUTN6ZG1E?=
 =?utf-8?B?Z0J5M0o3akMxS2FvdjNNemZ5QkVRT3ZtWHAvY1hMWnhKbkd4WXdyUjhLTG4y?=
 =?utf-8?B?K1EveHpvdDN5QThMN1FWSHVtSy9CRnFYUXRwWGp4ODN1TFVZekliY2VZM0F6?=
 =?utf-8?B?SHhPbWt1Q1BwUzdPVXlBbzZpTjdtSWVzQzY1VlNwSHRCSS95L05CUWg5WmV5?=
 =?utf-8?B?R1VrcEZsUEVSbThIcEQyUFdUNS8yNEh4K0hSMjhuUlZOaGtpUUpyalU0aWt0?=
 =?utf-8?B?L0IwU0lkNlM1SkJldnpBWnFWR28zNmNvdFRCK1dTaWpHaDNicklMN1QrWXZx?=
 =?utf-8?B?eE5OMUpZemFQMFZKVXRKTzVaeDB4ODJxcEhqTXhJNW1wcDJtTmlDbkQ2MWtx?=
 =?utf-8?B?SWVxTitETzJTMTVsSXpaMHV5L3VDNEZUZUdydHd2QUh4bmtvSitqQ3ZyUDU1?=
 =?utf-8?B?dnBkOVlBaXdQYnlzcGtrWWJJamc1Z1c0UEkzeWZrMCtBUjRsYm1YeVZvakRK?=
 =?utf-8?B?MW9LQlA5Z0JvMWgvNW8rdVp4dkdSdy9TSldYaCtRUFRwK2pJa1dSVlNRdEVG?=
 =?utf-8?B?TVdVZ1ZVSCtBeVZNOHdTZENFMGhjZzVDbXZ2bUJYM0N3dWxiQm9kOWpMaG5k?=
 =?utf-8?Q?7zNSYaRKpHpwrEEjJPpIJlHPW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30580faa-8191-45d2-cb09-08d9b490069c
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 06:01:33.0099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6iO0kiJmsoS41QZ2N2bQO1GH5AJvZd/ShlF1XU4H2hm8XuF4diAIOTeWQ5wkwXc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4562
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: c1d-Ktrl8HJnQKN5gHR-_AwCX24oGQku
X-Proofpoint-ORIG-GUID: c1d-Ktrl8HJnQKN5gHR-_AwCX24oGQku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=884 spamscore=0 impostorscore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 priorityscore=1501 clxscore=1011
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112010034
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 11/24/21 8:42 PM, Clay Harris wrote:
> 
> I seem to recall making a few comments the last time a getdents64
> for io_uring was proposed; in particular I wanted to bring up one
> here.  This applies only to altering the internal interface, which
> io_uring would use, although wiring up a new syscall would be a nice
> addition.
> 
> The current interface has 2 issues:
> 
> 1)
> getdents64 requires at least two calls to read a directory.
> One or more to get the dents and a final call to see the EOF.
> With small directories, this means literally 50% of the calls
> are wasted.
> 
> 2)
> The fpos cannot be changed atomically with a read, so it is not
> possible to to safely perform concurrent reads on the same fd.
> 
> But, the kernel knows (most, if not all of the time) that it is at
> EOF at the time it returns the last buffer.  So, it would be very
> useful to get an EOF indicator back with the final buffer.  This
> could just a flag, or for instance make an fpos parameter which is
> both input and output, returning the (post read) fpos or zero at
> EOF.
> 
> Futhermore, for input, one could supply:
> 	0:	Start from directory beginning
> 	-1:	Read from current position
> 	other:	(output from previous call) Read from here
> 

While I can understand the wish to optimize the getdents call, this
has its own set of challenges:

- The getdents API is following the logic of other read API's. None
  of these API's has the logic you described above. This would be
  inconsistent.
- The eof needs to be stored in another field. The dirent structure
  does not have space in the field, so a new data structure needs to be defined.
- However the goal is to provide a familiar interface to the user.
- If the user wants to reduce the number of calls he can still provide
  a bigger user buffer.

> On Wed, Nov 24 2021 at 15:16:57 -0800, Stefan Roesch quoth thus:
> 
>> This series adds support for getdents64 in liburing. The intent is to
>> provide a more complete I/O interface for io_uring.
>>
>> Patch 1: fs: add parameter use_fpos to iterate_dir()
>>   This adds a new parameter to the function iterate_dir() so the
>>   caller can specify if the position is the file position or the
>>   position stored in the buffer context.
>>
>> Patch 2: fs: split off vfs_getdents function from getdents64 system call
>>   This splits of the iterate_dir part of the syscall in its own
>>   dedicated function. This allows to call the function directly from
>>   liburing.
>>
>> Patch 3: io_uring: add support for getdents64
>>   Adds the functions to io_uring to support getdents64.
>>
>> There is also a patch series for the changes to liburing. This includes
>> a new test. The patch series is called "liburing: add getdents support."
>>
>> The following tests have been performed:
>> - new liburing getdents test program has been run
>> - xfstests have been run
>> - both tests have been repeated with the kernel memory leak checker
>>   and no leaks have been reported.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>> V2: Updated the iterate_dir calls in fs/ksmbd, fs/ecryptfs and arch/alpha with
>>     the additional parameter.
>>
>> Stefan Roesch (3):
>>   fs: add parameter use_fpos to iterate_dir function
>>   fs: split off vfs_getdents function of getdents64 syscall
>>   io_uring: add support for getdents64
>>
>>  arch/alpha/kernel/osf_sys.c   |  2 +-
>>  fs/ecryptfs/file.c            |  2 +-
>>  fs/exportfs/expfs.c           |  2 +-
>>  fs/internal.h                 |  8 +++++
>>  fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++
>>  fs/ksmbd/smb2pdu.c            |  2 +-
>>  fs/ksmbd/vfs.c                |  4 +--
>>  fs/nfsd/nfs4recover.c         |  2 +-
>>  fs/nfsd/vfs.c                 |  2 +-
>>  fs/overlayfs/readdir.c        |  6 ++--
>>  fs/readdir.c                  | 64 ++++++++++++++++++++++++++---------
>>  include/linux/fs.h            |  2 +-
>>  include/uapi/linux/io_uring.h |  1 +
>>  13 files changed, 121 insertions(+), 28 deletions(-)
>>
>>
>> base-commit: f0afafc21027c39544a2c1d889b0cff75b346932
>> -- 
>> 2.30.2
