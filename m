Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCC153E7F2
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 19:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiFFQgZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 12:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiFFQgS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 12:36:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0082853B72;
        Mon,  6 Jun 2022 09:36:14 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 2560t9G0011878;
        Mon, 6 Jun 2022 09:36:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=op7U0Pa8ub1+iDrHkD37CoRwhOyI1gfNJNzLAtVSAG4=;
 b=A4DI6xEpTgYsiI1ll3rGcW1nhUOhDRv2LO4bDZ7S4YwEVPP6lUP8eg0A373f7MXWnUO2
 2C8Xz9tGIJ50yGHt9uXOYtfe2KiVImqVgjn+QkbKIyg2BgPESpgD5bMQFl4dqv7lCYGX
 EF7O8oEXoEfHuTp4ycYUE7ehV4H7uZx4p6o= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by m0089730.ppops.net (PPS) with ESMTPS id 3gg2w79htx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 09:36:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7d2kgTpo65gagXQ11hpoAmM+ZfTMuJoSJfjFgJk/JlKNsscReGeMJQylQ89W02SvIAcRkVUF9wjtdv/POedker9xQ9sYfVC5tb3NDfEcRNt59eORMx6PBySVVN7xYwzFCca1+ozwuEt96ux97r5ILT0wy0ExtGOZoc0xUG6h0DD8y4UswYm+tKKsD7jZVwOwvYRQ/DdbLreNHLlINtbXLcxm9ZbXaFTdGibR7uwPVaQroZGt6HF0dU7+0/06ffgTU7JKxK6lvs/wgfZjvthEzSLxiNOwlIXJVBgdUzexTRYTILWSnz4F4FgfoH2H23fZEzUAqbDhsO5sGYZf831zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=op7U0Pa8ub1+iDrHkD37CoRwhOyI1gfNJNzLAtVSAG4=;
 b=Ie6SpotXy2bRJsFOwvrHB9cDzXke1kdgxRs97AuQwNS1BfirP2yEBZOkv6t4fugZCkIG5nbgV4nZ89FwrTLAFw6222n0JuMjnR44/ZzhkljViJCdoJ1U1DI11jLfx43BQ+CzuEGuTxFQikXq2DwYRcNxY11mumZTtRuDBwuJ9v/6teaYZmfvCoSKwpq2GGGOOUdlJnrvOzYH+aD5rjHMSWOcCPoJ0dGm1RqdjhM02idQAsWDsNZ1rPxYOl81T76L9anIufK27DKkYiurvSw4e2VQcxS0mJMLJ8SQQzmkdFuC8xIZm5CyZ3KdukASE/HslY/+ZfRaD05a4Ee/wMJm1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by CH2PR15MB3638.namprd15.prod.outlook.com (2603:10b6:610:8::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 16:35:59 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 16:35:59 +0000
Message-ID: <15e0fc78-af52-9ee3-6053-fb2c65b6e2b2@fb.com>
Date:   Mon, 6 Jun 2022 09:35:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v7 10/15] fs: Add async write file modification handling.
Content-Language: en-US
To:     Jan Kara <jack@suse.cz>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org, axboe@kernel.dk,
        Christoph Hellwig <hch@lst.de>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-11-shr@fb.com>
 <20220602090605.ulwxr4edbrsgdxtl@quack3.lan>
 <06c41c2d-4265-3dad-ad97-755ade33a8fa@fb.com>
 <20220603101202.sabns7qs4cv4z2yp@quack3.lan>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220603101202.sabns7qs4cv4z2yp@quack3.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0066.namprd17.prod.outlook.com
 (2603:10b6:a03:167::43) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f72a8edd-a031-45f5-85ff-08da47daa2e3
X-MS-TrafficTypeDiagnostic: CH2PR15MB3638:EE_
X-Microsoft-Antispam-PRVS: <CH2PR15MB3638B1BBEAC62EB5E387363ED8A29@CH2PR15MB3638.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 50y1DIXOADzd1vINIFHnFFCKlnzU4t76BvmZauAhkKahSnw8r1Zf2bJyeIF19ELNafcX9RTU64c/j4vvLLrJJ4d4bAfqTZcmRumDSSUukrocgxofiQcsnemyh7ZHbfYAgywXhMEXB0Q30MBl5nJm0bdnGiRDYCO9nTwMN3FA97QXNT38BoEAH/KUNbDNSNElqawNluwDgVdqw8wZb8i4Rlt2LpqblStwDtDCIdxDSArV527/XsItS6KK6PCfDCgnT3nrLkTqYkIETWzZj7vt/LALrDXngtfY9Se+n48n/x2LsLz00yTpStD/xO60eC7rT0Svo4t3ZTrzc+KlR7QD5QjwYqx0Ng/faeDDsKpNI8+J5TQEdH6A/tBHjyn14yh6Rrajw2HlZBDN9kSgQuVI9IoX0J9ZGBMhAk9T9Hk1dKdAte9Q/3tduGWx81GSqvCym4b/kPzEM4wOu+ivpHcwBofC8S5M5vy7iL8NQdWdPloU3amxW1za38l8GmEcKAkyjsjHbFDPW5+GldH6plWzhbncS3VS6gmCMAeJvcpdkGl7PKal1tS2M+fhGFTpbHS6ed1f1AZp4Q0a/vmwd+NLCRjJdopFery7ciYOOSipZX4M+6xrH0ncP1mHKjrwuUtFDFaU14MsG0/3r9n+QYmPUdgkaSju6VEpdGXifNLTpNS8pWXMxuYUxtBwRJWr9NMYCcbEE/nhsdC8lDqFp9V4JkEdZSaCLP//tIpgw/TNOZ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(83380400001)(53546011)(186003)(8936002)(6666004)(6916009)(6512007)(36756003)(2616005)(508600001)(2906002)(31696002)(6486002)(38100700002)(86362001)(6506007)(5660300002)(31686004)(4326008)(8676002)(66946007)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UG5NS3g2Z1ZGdEF0Y3EwZ3VyenBLcFRHSWVkMnRsbjNPZTE1bWY1U0xlR1hN?=
 =?utf-8?B?QVZ4MVVLWjBwTkhqbm9uSStxbERxQWFzWEZlMHFsNkVSeDByVXFiL2MrOUhy?=
 =?utf-8?B?RjRtayswdGhERlk4Z3Y3bUdXRTQxWmJlQUpINDVuZUJNYld5RFloMXVzTm9I?=
 =?utf-8?B?UXVBVUxROG1jenBEbjU1Nkp6MU11aTJiVENWNjZud0FLRjFBLy9Nb2tMM1dl?=
 =?utf-8?B?dmFKRTJWSndwSzEzM3N2MXlhRE1XUUpLbithTHdyQm83ZkhvbHV1eHlaSjYz?=
 =?utf-8?B?RXdBaHBYaGhIdlNGaGRUWXlHdTZPbkdDODZKUVJWZ1R1QXJSNEdoNlkvb2ZX?=
 =?utf-8?B?blBESUdoMjFKdWZGT3ZBamh4eVRwaHErTmJtTmxuYmZTTjF1WGxRaGJQY0ZC?=
 =?utf-8?B?dStxZy9yMjFqYXRNVG1CQ2xFY3VkVGhnUld4NVZBcWVwa0EvVXhNTkVYREdB?=
 =?utf-8?B?citGTktnY0w3SXY0bmJXRHNWeEh3bmFTbThCVzN5OThNYnJ3TDJDRTU5WnZI?=
 =?utf-8?B?Mld5T2pqZk1VTDdTZ3lIRnBnelpnRkxaS3p3T29LSDNzSGJPQkxGUW54MjlX?=
 =?utf-8?B?S1FzL3c5aG42WHc2TnNjNExkZ1ROWlpDeUkvRWRvdm1BMVRHVmVETW5LWFFi?=
 =?utf-8?B?STdoZFo3OW00MHhHTzMvOGEzT3NERCs1alQ1QytjVFh1cElucE8wUVlQSG5X?=
 =?utf-8?B?UC8ySCtjU1YzWDB3YzJsa0FWa0NDLzM2cFh0Rnl0ckVRYjZHMVFWWVhTaUVZ?=
 =?utf-8?B?SW40emh3UHVzaFo4ZmxkeDdxMG9KZUpQSTU1LzMwQk50V0tRR1BlZ24xMnJ2?=
 =?utf-8?B?dkQwZVFkU1NURlI5UlgxLzJTdjhzTDR4ZDUwWHBwUWRuQzF2T2VrVGZyTDRD?=
 =?utf-8?B?b25PbGM2eFNIbGFCUXlEQzIvc2tDcHJYalRLeDJkdExRaEFLNmlIc2E3aWJX?=
 =?utf-8?B?UlFRYzlydEdIbFpXY0FLeFBMdG1IY0loUWxiOFV5ZXUvc2RoSW5vOGdvMXM2?=
 =?utf-8?B?M1k1ZzJlcHptUmJXRmx4LzVEMlpoUEFBTWc2cXA3c2dkQVB6SUsxRFp6aE52?=
 =?utf-8?B?YnBQbWdnZjdkYm9SUmpSN3pjaEVHT25TS1N0SGFVNEJ1Zkd1U2J6cE9SaGlj?=
 =?utf-8?B?a1JyYmtYSzBXczgzM3ZEc1RqcVN1S2JDK1F3bVUrZmNnVTUrS2VaL3ZVNFdp?=
 =?utf-8?B?NURqd1lQVnlNUWlpRnRkMFE4VjQ3ZVArSURDRGxTTFE1R3UyQlhISHQzZjk3?=
 =?utf-8?B?ZDBRTzNnSC9FYlQ3WEtKRW9FU3AyZXB6R3VPbS9aUXA3eElFZm00Tm1GWVZl?=
 =?utf-8?B?NzNRUHVuVzNrVDlLbWZ4MWFvRDE5eVR5ZUFtcnRmRFhVTUswb0JWVWZuRnRX?=
 =?utf-8?B?VDFPWE4vQVdPV2FoYVFHVXpIU1d2VmN3UjVQL3Z2N2x3T29sSTZzSU1xM2JW?=
 =?utf-8?B?VU5Mb2RMZXlLeDNBN3hiVmg3MmcyRzVZa1RDNk5XTFJhTVIvSkZzdjdDYTVh?=
 =?utf-8?B?TGxMcDBHd3B6a0NjRy91SlVYNFlnamtUZzIrYm5Ic2Q0bUU0RVdFbUZFNVN6?=
 =?utf-8?B?aFpwMXJ2SlZ6NjdvMCtnaVhpTkREciswaGtOejRFNHVIRHFCcGNRdmE0anhq?=
 =?utf-8?B?cHhWVm5ZM3Q3Y3pZcGd3VFBzdWo0MTZQZkhzdStjQUtzbVQwRzJYdG0yRG9i?=
 =?utf-8?B?eUpFSzJjSTRoOG8xZ1BWcmNKajdPYWV1cTh6R1ZlYVRUOFdJY0FBeFFqazcw?=
 =?utf-8?B?aVhVSnRXcko1VHlVUm0rKzdkckE1eDA5SFNWL3g4M1IrUlJWODlLaElXNTNr?=
 =?utf-8?B?S0pPdlk5RzAzdW1tWXF3amtLbDg0aHFtTm1hRzFuRDgyWm15QUllQ2txcERR?=
 =?utf-8?B?RENEZGM2NEYvd1h3aXBod0dCNVp2RDNLVlJCa3BtMHkrWmExcmZvajFreVgz?=
 =?utf-8?B?V1BqWEVrc2xDdmd2NzdTNVl5YWJDOEhNVTZiKytXeUwyRXNaczZkYXpTQWFC?=
 =?utf-8?B?MUxlRE00YnFJUitmQ2ZkQkJVOHBpM2NRSU5aVGlwVUYvaUxsMGNUM1ZXaXpq?=
 =?utf-8?B?cC9TQS9hZGk2cEN6ZkdWZnFQRU1DenhNN2xqMGJXWXE4dWtDNDY1TldZYUcv?=
 =?utf-8?B?VWpXQnNDQUhyVnhmZ1BLMFNpbXpJV29jL3VxMjNVbHpaYUg3RC95a0pHNmwr?=
 =?utf-8?B?aUJpYzUrN0lLV2xOemgwaGF1T1pvMHFzNndOTSt4Vm1MVjVLaC92dDc3eUgx?=
 =?utf-8?B?eC9yaktwbG52N2xMdzRSSTQwYXlXUS9aSHRZWDBWN2swZDZOclhxUXNMUk9z?=
 =?utf-8?B?QmhNUjVLa2FrYkRZdjZxVmF1aWZLMzlhemtHTnBldCtPMTVsdllLM0VyWGlv?=
 =?utf-8?Q?D9bX95H9uAP7jVdQ=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72a8edd-a031-45f5-85ff-08da47daa2e3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 16:35:58.9952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c3RGvSNZjtox9K62khaw7qxPSQh+8dBty34y2FyXDpdu/SuZHE+WbrlZGfdvFLe/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3638
X-Proofpoint-GUID: 59cOEgrNxvYYtMr3J_XtQIVz_vjW1jfH
X-Proofpoint-ORIG-GUID: 59cOEgrNxvYYtMr3J_XtQIVz_vjW1jfH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_04,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 6/3/22 3:12 AM, Jan Kara wrote:
> On Thu 02-06-22 14:00:38, Stefan Roesch wrote:
>>
>>
>> On 6/2/22 2:06 AM, Jan Kara wrote:
>>> On Wed 01-06-22 14:01:36, Stefan Roesch wrote:
>>>> This adds a file_modified_async() function to return -EAGAIN if the
>>>> request either requires to remove privileges or needs to update the file
>>>> modification time. This is required for async buffered writes, so the
>>>> request gets handled in the io worker of io-uring.
>>>>
>>>> Signed-off-by: Stefan Roesch <shr@fb.com>
>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>
>>> I've found one small bug here:
>>>
>>>> diff --git a/fs/inode.c b/fs/inode.c
>>>> index c44573a32c6a..4503bed063e7 100644
>>>> --- a/fs/inode.c
>>>> +++ b/fs/inode.c
>>> ...
>>>> -int file_modified(struct file *file)
>>>> +static int file_modified_flags(struct file *file, int flags)
>>>>  {
>>>>  	int ret;
>>>>  	struct inode *inode = file_inode(file);
>>>
>>> We need to use 'flags' for __file_remove_privs_flags() call in this patch.
>>>
>>
>> I assume that you meant that the function should not be called _file_remove_privs(),
>> but instead file_remove_privs_flags(). Is that correct?
> 
> No, I meant that patch 8 adds call __file_remove_privs(..., 0) to
> file_modified() and this patch then forgets to update that call to
> __file_remove_privs(..., flags) so that information propagates properly.
> 

Thanks for the explanation, I made the change.
> 								Honza
> 
