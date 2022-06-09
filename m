Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D90B545464
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 20:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbiFISt6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jun 2022 14:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245220AbiFISt5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jun 2022 14:49:57 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E712A27B;
        Thu,  9 Jun 2022 11:49:53 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 259FPL5F027279;
        Thu, 9 Jun 2022 11:49:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=M3GH3dAIJlZApSd9oFG8r/HIxks0U4YRW1z8WKNllHA=;
 b=b/tG8RuUh66UjTNF9QHyXrGFPIfC1oceLyslv9sK2wMc1/YSvokZe8fQ3VhE+9eLbbUD
 QJVE9kyCfA3TfbycNYFpg7TecmHVxV20CBQI6o0O0StMqqzfQBF8Rw/dXzMUZ9fN6qne
 qd15liwQiW6TWly/d1lwrovr9h84aPACQ94= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gkajgcav5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 11:49:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCy69ohQauJdw2OpkJFD+FREAF1tju7iLICLsFmetBltLAlraV3jHZK4w4Kc8YkaP1GyesDVyqHgVp1ZfAJoJad4Vtgo31Dq/OjVhiPhxOSH0ziM6b2eYrvo+4ASlkx+nbFPN8Uxadzehmnvp/ejQxsD2TMWTXpnhCvjCVe3ciVo8gUN9LuoszD6B3orP4wIuj9Koynrn4x04iIwYCiXWbktgWeYobEApQThvOrGmhTPprnbZOotkkiQ2VbYDhTzLRpSaSrh0Og5oDMcUee39iXBv4TLsIy1JXUfxy7LLB863rVU+5sqIXcU6iNyyF9eG8pk338M6rrgFiEJTM2Wsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3GH3dAIJlZApSd9oFG8r/HIxks0U4YRW1z8WKNllHA=;
 b=W4g2Y1sapro0hgwJthJAQ3juA2gTXkGZXdXfG9qKTxu4cuxB/RJ3UJ7dcBWyGxjWS/IwBxBaXLx7Gw9l5f2+zS5XEgioTV31IQsuIZAOJ54dJvownERbTCOsEZqZHrE/UwlHPV4Ec7ouT65Wu2wVDqOD8iNdIIaTaVbK1rbveZ5r9rU6T84OL2EvPTtoB12J5mblMITjF6kzbGs2CZ/7i4igcpGuKX3WD94PyxQQsZodlBhqC/SihuOBvTpH6k4Tr6jk27DhaCyabfwsEY+AGw3EFE9wKaNwSijNrsP8Rn3ezTRDv7A68U07U1ZHKeVbX7eAgMXwHfuR4EbQFo9KFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BN8PR15MB2739.namprd15.prod.outlook.com (2603:10b6:408:ce::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Thu, 9 Jun
 2022 18:49:37 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 18:49:36 +0000
Message-ID: <d46b77d5-29d6-d3c0-43dc-72d5d41e111b@fb.com>
Date:   Thu, 9 Jun 2022 11:49:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH v8 06/14] iomap: Return -EAGAIN from iomap_write_iter()
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
References: <20220608171741.3875418-1-shr@fb.com>
 <20220608171741.3875418-7-shr@fb.com> <YqDyT7uSd0vv15aL@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YqDyT7uSd0vv15aL@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::29) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c76bc116-6df7-45ab-cf31-08da4a48cd30
X-MS-TrafficTypeDiagnostic: BN8PR15MB2739:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB27396804ADCA447C2D62385ED8A79@BN8PR15MB2739.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B6Gv9+Rpz2tlc0UX+KYWy7V8MBlNAr7KXfAtPViEPcfJr8pwo5cANhws9m1MKz06KrVHf7EI/i3ckPNB4og07Ky+S8nTt8OLIq7YUWdEiWovUsStg5ziAa7/MSNdnrCCvKjsmKyBMEXykBwFIyBe4obM5Y2zvZjpUml5QjeI8hvZxTiCsIzkW0hrRR542bB6Gp1/Up9zJuyVNotd0TDRxk/+k9Wy6cYot5m7PPys4jkR1PGdxKVMplVyQO21irUVPwaeNdAyf5MzfFd3Rj9o79wzKFYxaaNXLIIVFR39typNaCI61q/bCUI3yYc0w9rbFNBGSilN2R6losfvwtk/fYjpnwMtThwewz3vifN5934FqHq2+i1G0LFPdov6ygdgnKFu5FgCaNp97Wti+dVV38huJlZCmHztHJKUe7dtSIP2SHmrmBWQro5INviKUkRBCooxnJvy2zwuYXY42H6/+OW1vOi6cJ8OCTOBLohGVKtapzo6F7rJZx+LD9AUv0MVqZbkk92bIoApdfPp3n6dD3Z/XyxBNiBc0frsqArTMjbuS0/OPbHvO+DzQBer0PRh3XUoc8J5p7Hap0Ar7HHTpRl5XGNJJ/gr5swGKGtDSvYwyAHcoVt+mH91g9BdukWZYl2qIIw1YDjyBYyDSt17y/AOLSCvHD6KqqdKdYpLxpyF0inOdK2GUWLmT23SBHO3Bg9z3k5hiJHBtCWdUlefjBYjtV/wxHjc+X+IFVbZaVc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(66476007)(66556008)(66946007)(5660300002)(4326008)(8676002)(31696002)(6506007)(83380400001)(38100700002)(86362001)(186003)(31686004)(8936002)(2906002)(6486002)(6512007)(508600001)(53546011)(36756003)(6916009)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVlsSDdENmJ5VkpZakFwMUlXaVpRSTlRbTBrcEY1aGgxdWZmSWo1TXVuekxK?=
 =?utf-8?B?RGZwRWR1a0ZiU1l0RHo4NXBzWVpkeGJIS3F5TFZvaGRCVWE5ZWVXZittb1Zu?=
 =?utf-8?B?azVibVg1SkpTWG5JWFNFU2E4V2xFa0hNenNnbFhQY3lvOVhmUVFodC84UWY1?=
 =?utf-8?B?cVJVSjNLckRuSFY3Y21ZeVpTNzFCQk54aDJxOUtEMEg1eDFkL1FXWFBYdTB3?=
 =?utf-8?B?bFZYTE93dkJwR090VFl4aUZpMi9aL0orcWsvMCt6T1BUOFJCMUgrOEl4OUwv?=
 =?utf-8?B?NWkwQldtQXJVeGUxaDZuWDlMVHVEQjJlMTQ3cE9vWTZuUk5QNTZENzFmN3E0?=
 =?utf-8?B?bm5WYjRaRWtDRitlTU1URTdZNUZ3R2tYKytBMnpTUnAyVVJDejdKTnRMbSt0?=
 =?utf-8?B?NVV1QVcwTXMwNGZWeW85QzJPOVZ0elFqZWVoRDhRaDBIL09BWnZ0T2FQT2sx?=
 =?utf-8?B?MG5VRURVcHU5V3liS1BoVjhyS0s1NSticzJzQ090a0RldW1hYndXYklmZElH?=
 =?utf-8?B?M21NNDZ4RE5VYnNnLzNDelprMG43bDVRdUFTWEtxWHM1WVFwcS9xcFFWbVFG?=
 =?utf-8?B?STNTZndjVzJUWTM3M0JBKzFLRHZ3VitiME9zRUxrVlNuK1dOdW40K3Bkbk4x?=
 =?utf-8?B?NWE2TUVsa3hBYTNsb0J1UDE5cnVJdnpIZklGaVpMdWlhRWk2anFFUXNESnBI?=
 =?utf-8?B?bTlZT1UwcjlqZy9wTjdocVQ0U0RUSis1akllRjZkTWRpaEpSdmdFSVY0YmhF?=
 =?utf-8?B?bGhpSG1ua1I0Tkt6QWw3TzhvQkFqZ1dRK0sxaFBoT044NWpKVkJzNk1OeWV1?=
 =?utf-8?B?WEtiQ2ZwdWFoOGRGdjErYVdPVmxYbGlZVFpyb01yVDRCRjdRdDhKc1BHTjMx?=
 =?utf-8?B?VlpGWTYwMWkxaVRMTUg2aytFeWFEUzc3ZkFaaWRnZWN1UDlpUWxqbndERzl6?=
 =?utf-8?B?b3lVYlZFRzQrY2dGWGFlZmg2czAyWHZPekw4L2wyd3VSdzg4QVVIUmtGeG5l?=
 =?utf-8?B?ZkdJbWVid3VOOTBQVjV6aUNPb3lzbUJVd2dBajdoUzgxMVhxV1dDZWQ0YkN0?=
 =?utf-8?B?MlRnbGpQNGN6Q2Y0b01SL3NDdXh5cExnTWV4aXNTVEdLcWYzOW1qMjZsdmtq?=
 =?utf-8?B?UFFXT1prcno3Q1BiSkora0V1SUFnYktZbHBDdDB6ZmJJcndDUFY4T3AwTHBZ?=
 =?utf-8?B?djBpem90UVo1Q0dqclB3SlhPS2NRRGppYjhTaEFES0x3TXMwM1ZSK0k4VGZD?=
 =?utf-8?B?bEJBOFpXOU9BcGFPM1RDWDQ1MzF2YkI1aU9MYzZCNzlYTE1qZ0plMnZxaG4z?=
 =?utf-8?B?aHVoZllOY0kzYjVuQU9UYlZVMENTaTBkeXAxVlAwbFU0bG5JRWpjb0xJcmpH?=
 =?utf-8?B?UmJkbytXTEZsSjVXb1RjQnUxTTkybXJEeVc4L2lzTThUYlRSNFJUeFJ5MjB4?=
 =?utf-8?B?NFh5Y2ZVVG9qRWZzZHBwNW9Ob3dVeG5VdDJLT1RZL3ZQSXIyRkhUZC8rY0Y4?=
 =?utf-8?B?YTY4NzJUVkdyRXBmNUpiSmU4TGJ2NnJDSXhBYlQ4ZVFCby9Xb2Y1ODZaVkNK?=
 =?utf-8?B?UEFwRUNGN0k5N2JlMnFHWjhxVFh3TWhwaGpKRjcvWlNFN0w5aUw2eVozWm15?=
 =?utf-8?B?NkpvVVV6dWRmSTkwd3RIN0ZFRWpxdStBbUFzVW1ZVWRQZFE2dlpLV0NuU1BD?=
 =?utf-8?B?QlBnVXdDS2lIRFROUEwzMmhoT3BGWnA1Lys3WWJxZkdUYVJvbjZ2dldxa2hu?=
 =?utf-8?B?aGVzSW5sYU50NEpZbFJCVkhmcmRMRnp5ODkrbCtaTlRnTFAzL3d4bjY5UUNy?=
 =?utf-8?B?WjVGaFdoRFBjM0thbTBLeFVIVnY4V1Z6Zy9DdXZ5OHBQUHZrS0ZGQXU5Vncz?=
 =?utf-8?B?Mit2TGhPTlV6WW1peis1dG5iUmk1c29sQm5CbUhHN2RuTGVWMkQyd28xM0ND?=
 =?utf-8?B?TXlwMFV2M01JMWFUUFgzTXQ0S2xZamlXRE5YSjdjY0RrQXdYc3Z1cTZieXgr?=
 =?utf-8?B?Qy91ZndCWm14UytzYllUd2FDQVNPZFBSOFNJRTEzaFF5aGI1R1lDSXBXcFVR?=
 =?utf-8?B?TVc2MkEybnR3NTR0Vzc4dU1XOEhDNFlyNTRmNEUrSTJFZERhWE9aekRpTWVm?=
 =?utf-8?B?TlBCTHFkSWFjbVZzcGZYTDhUMHl2QkV5dXFDNGhwckh5Y2JPTlEwYmw0VkUx?=
 =?utf-8?B?VHV5anh2WjhXZ00wdEx0ZGZmc29rSS9wNXg0dWhxU1BNM2RXeFlGVUNhWVpl?=
 =?utf-8?B?TTR3TjdwMnhVWlQ1WWJwRjQwTUxGVWtTbXp6Yk9pUE1IbTRzOEE3cE5jSnNY?=
 =?utf-8?B?OEVIR1VtNWw2VFNSSjBjYzZFdGlab0MvNVI2QytwY1Fvcld0SjF4VFBRMEJl?=
 =?utf-8?Q?55fY+aSCtmuBSOg0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c76bc116-6df7-45ab-cf31-08da4a48cd30
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 18:49:36.8537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zp+aR5ExG6DXq6n9lAaO61pmbHO5Blkoql03AxuOsZMdH9OBK2s/Qnb9GBwyV2cZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2739
X-Proofpoint-GUID: VkrIkNWYdlzfGi0LrZR8VCxgmqJ1t29I
X-Proofpoint-ORIG-GUID: VkrIkNWYdlzfGi0LrZR8VCxgmqJ1t29I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-09_14,2022-06-09_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 6/8/22 12:02 PM, Matthew Wilcox wrote:
> On Wed, Jun 08, 2022 at 10:17:33AM -0700, Stefan Roesch wrote:
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index b06a5c24a4db..f701dcb7c26a 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -829,7 +829,13 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>>  		length -= status;
>>  	} while (iov_iter_count(i) && length);
>>  
>> -	return written ? written : status;
>> +	if (status == -EAGAIN) {
>> +		iov_iter_revert(i, written);
>> +		return -EAGAIN;
>> +	}
>> +	if (written)
>> +		return written;
>> +	return status;
>>  }
> 
> I still don't understand how this can possibly work.  Walk me through it.
> 
> Let's imagine we have a file laid out such that extent 1 is bytes
> 0-4095 of the file and extent 2 is extent 4096-16385 of the file.
> We do a write of 5000 bytes starting at offset 4000 of the file.
> 
> iomap_iter() tells us about the first extent and we write the first
> 96 bytes of our data to the first extent, returning 96.  iomap_iter()
> tells us about the second extent, and we write the next 4000 bytes to
> the second extent.  Then we get a page fault and get to the -EAGAIN case.
> We rewind the iter 4000 bytes.
> 

We have two data structures, the iomap_iter and iov_iter. After the first
96 bytes, the iov_iter offset get updated in iomap_write_iter() and then the
iomap_iter pos gets updated in iomap_iter()->iomap_iter_advance().

We then get the second extend from iomap_iter(). In iomap_write_iter() the
first page is obtained and written successfully, then the second page is
faulted. At this point the iov offset of the iov_iter has advanced. To reset
it to the state when the function iomap_write_iter() was entered, the iov_iter
is reset to iov_offset - written bytes.

iomap_write_iter() is exited and returns -EAGAIN. As iomap_write_iter() returns
an error, the iomap_iter pos is not updated in iomap_iter(). Only the number
of bytes written in the write of the first extent from iomap_file_buffered_write()
is returned from iomap_file_buffered_write().

In xfs_file_buffered_write we updated the iocb->ki_pos with the number of
bytes written. In io-uring, the io_write() call receives the short write result.
It copies the iov_iter struct into the work context for the io worker.
The io_worker uses that information to complete the rest of the write.

The above reset is required to keep the pos in iomap_iter and the offset in
iov_iter in sync.



Side Note:

I had an earlier version of the patch that was changing the signature of the
function iomap_write_iter(). It was returning a return code and changing the
processed value of the iomap_iter (which then also changes the pos value of 
the iomap_iter). This version (version 7 of the patch) does not require to
reset the offset of the iov_iter. It can update the pos in iomap_iter even
when -EAGAIN is returned.



> How do we not end up writing garbage when the kworker does the retry?
> I'd understand if we rewound the iter all the way to the start.  Or if
> we didn't rewind the iter at all and were able to pick up partway through
> the write.  But rewinding to the start of the extent feels like it can't
> possibly work.
