Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8594E52C765
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiERXUb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiERXUb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:20:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1713FA477;
        Wed, 18 May 2022 16:20:30 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24IN6CGe020560;
        Wed, 18 May 2022 16:20:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jSDaLL7PpMNCK6/3LG8vj7vIlytoC6N7QYHc/SSClJA=;
 b=HacxJ0R25SawGi5wH1mybqqUbjHjMkins204Wpt8iBp8jkw1bGvuM2r4uacSZhYEw48N
 3pFL5PeIthbgA+H8Mhu1QojbsHPx9ZcV39qkV08SP0qDzT8LMhb7UQMc2y5VPACR2CZp
 sV056o8zmlTGyCEvGoN6ECuDNWlbkXw6ru8= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g4myhr4q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 16:20:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O73YVtUySXb2ehyx+A3S3Wj0WTlV6sQkR8RHGetFofvvyoiEaEtkvlBwbd9krgrjWIm/lLroxSMoRCBhyd6n/1DHhmSf9y38Ce3qnX4+Dhuo6VE+pmgM7NR1qPlQ+TjfzZ0E5toxk2UA57o0tEupR+n1S6vCaGNVJK/9SIWRN7l99HS3lJ91Hkn7q8MEPx0HwqOSeOYGl42mshXyXOSEwox+l1BT5RH94mLmvG5l/oh+WAp1RdpfT3dnhnVop5o9GaQScH8SSfQiqZqj86hE9v+uv+1lYM9PQx0bXppfTK8TPmaPGTy7IvPtgG75KkIucM/od5Vc98iCnt/tZJe4kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSDaLL7PpMNCK6/3LG8vj7vIlytoC6N7QYHc/SSClJA=;
 b=jJfgFFhoVpPmRs6BuilQ59mqD65qvANNJKOLWp9A6Dhn8WekGIRNLpOocRj5JAiwJCD56xZ8um61S/xSLqmjeP7OrpbMhmxxtofm9SX0C78R58ZgnS5QQSQolDUcIyIhUTrEmb93Zt78hOxhNTSZjxBXOW5OzJFAEkE792pCKZ3b7o9aox8qC0AqYPa16MMj0dpmU3H7fwA1wdluy1JRKuKFnEByDeeeyA+YpeE16yW0dMkHJakPLFFLom/0O+3Ul8QDiZcj8kZQrvCACFQFM+v/q4lrvE6QPHl88WfwZtrR2QSXCwkkIZbfG6bEg1YOmSymC9enkqJ0pfpn1ImVgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com (2603:10b6:510:76::6)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 23:20:07 +0000
Received: from PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1]) by PH0SPR01MB0020.namprd15.prod.outlook.com
 ([fe80::ad90:787e:697e:3ed1%2]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 23:20:07 +0000
Message-ID: <6d052a01-64cf-749e-df2d-1919317a2e03@fb.com>
Date:   Wed, 18 May 2022 16:20:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [RFC PATCH v2 01/16] block: add check for async buffered writes
 to generic_write_checks
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220516164718.2419891-1-shr@fb.com>
 <20220516164718.2419891-2-shr@fb.com> <YoLhmrA0GXAT2Hm7@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YoLhmrA0GXAT2Hm7@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::30) To PH0SPR01MB0020.namprd15.prod.outlook.com
 (2603:10b6:510:76::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 183039c7-d1eb-4c40-2977-08da3924f241
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB2773A076CA0A935F1F2594BED8D19@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ov475/ErDehsN83mW4QkMJ5UjNE56BgWvIn7touVBjEOlBfUX0u2wt6YgoQnPlu9EzJ7gYlpNzd73oey1ru+16B2El3HyV5xSo0TBKBXhfXoQy2jRqH27vPDCSj0wOfUg/mf5q8GsHLeKAKnHWTkN178bIRLj2ti5x3g+mrOsllXCOuJUwvxIQi40xjeyFbfnUaf2wRF6VBcJJpiNYxSgwNIbcuIJVVQWyCmOxH8gVd7QyCj5hqwY+KQJqtNIQKKbpV0i4VvFR/TbrTJYAWvzPDHCrGhQXzZZgDfaVtyfkgyZzuL4diariinVA2OaN2nUEkRqQ1rgvUGE0FzLPjZwQrpLmctIsqZzaud75fv3tPxXhAA172wfwISxm7MeM6hIz1417+XsMaYJ01zpKkakgGQoZj12/NV+Pax9mM9eW5BUTfi1/zUYXi3DBMvubxvGIzVcWd8nPETiVRCrm6d8bo0m67hJiRYqp8U/86IOVHfrSWBBZnZGKKXoISiItGUJ3R1Z6W1HZ7yw7cOzl8mLUn3Q7wjwz69OH0uF2Tv+EWEuh2CJDKoMh0KYzWTv8oORpV78tANbtuTZOXWS315c/qqdaL9yx0kuKVm8+vH+rgKFw4x0/+qjLGK/aoTDoor6tq7BFfXvDyy0b1Q4zpJNDy7gUrTol7tBkMZ2xb3x1kEgAb9vkZzSqqnZMpPd8umxWd/0Ml64xaR6FAEwpreK8wsuqooFpH9+2tdv3fV3ROJPtx0t8p37o457g90Tcz1G9dY/CNlUbE/IWQTFwmPMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0SPR01MB0020.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(31696002)(86362001)(6506007)(186003)(2616005)(83380400001)(38100700002)(2906002)(8936002)(4744005)(6512007)(66556008)(8676002)(66946007)(4326008)(66476007)(5660300002)(31686004)(6486002)(6916009)(508600001)(316002)(36756003)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2NmL3Rrb2RyZ1ZiZDVLbWkwYWRBb1A1TzFMcmhSMy9kbUNpODIwTFpyeWIx?=
 =?utf-8?B?YWROd1JhdlplazlaRm5ua1R6ajVUNDhpSG5MRjNha3RHMTkvTHZqZExiRXlr?=
 =?utf-8?B?RVJPbHgrQWJXYjY4dVBEdlJYUnFTZkwyZXhXaDZpekltQ2ZzZmVNTlgwMXFt?=
 =?utf-8?B?bGhTWWhKeVJjdEpGTmRzZ2MxU1ZRZElveXpCRStQRmZhaFYyM29xUWpJWnpn?=
 =?utf-8?B?L1RDbFU2MTNaTjhBczVHYnEwcnIwVStJQUI3TTdVMzAwRDhTTXZscUtINFow?=
 =?utf-8?B?V2o4Y1RSZEtYcnBrcEtzQ1ZwMzVnTkwyd3dvYUJMSGtpclpKWmRkeC85d2xQ?=
 =?utf-8?B?c0EvdHMwNCtkMno1bWhnMXRGTHI5bkozbjFCUjFkNDI4ME5oQVNkMlEyV3dU?=
 =?utf-8?B?SHQ5akZiOHNXTitaRDlmVkJabVZmSzZJY1E1aWR1eVBSSVJxYUViT1VZQTFi?=
 =?utf-8?B?Q3l1am5DYUJEeFBTcVlQVk9SZG1hb0YzY1hEZ1hDY1B0TjgwdlRDbll2ZlJH?=
 =?utf-8?B?eThiNDUvQTcrcXFhWGljNDlqZEFZdFhlVWNzZEMzN2FGdHM4Wm1IZFBpV2s4?=
 =?utf-8?B?bml0R3k2WTNmVUQxL09pYWZUd2JZMEpsOXlwVWsrdjh6QTZpWVNBOXNObE9r?=
 =?utf-8?B?Nlo0YnI0TmVsb25wV25Fckt2Q2F4RWY3bGZzeHd2VU1OS3UwSDB6QkxGZ0o1?=
 =?utf-8?B?b2Q3Rjg4NGxodXNDa00xWlhod09rN08rdmZ3ZnNwMjZ2VSs3eTgvS0lJRW5k?=
 =?utf-8?B?VjQzNEJmN0FvNDZkUVdxdlNqeE4rTWNRdFNManhNU1grTzJwcHk5Tyt2TjB6?=
 =?utf-8?B?SFF0QzNEdnU0OWJldGN1QURLelc1VXFGbGRVaXFyOWIrOFR3bDJZcWh4aUdC?=
 =?utf-8?B?Vy95QXVjV2F2cmtSNlluWms5THhUaE56MXA3cjdIYlErcXVoT3pySC8vZ0FR?=
 =?utf-8?B?aVNpRVlHWTdMYktwSU1oZ0xNMUM2Umh6bkJ6V2FCakVhNHFvaE0zWGo5NTkw?=
 =?utf-8?B?TXdHNC90dTFEMStlMXlIdlBZWXFPNDA2eVd2ZURBMkpWaytDOVo3akZzbVFB?=
 =?utf-8?B?U0xVcUk2SnhLT0o0cVExSkZheGNOSmcxUUtFVi9lclo5aWZCNEtFWm4zOEs5?=
 =?utf-8?B?KzZqMFQ1YkRUTk5BY3NOVnBDaXZvUldybktzRm9nMFcwZ0pWR3hXQ000bGxm?=
 =?utf-8?B?OWJEaXhqcmNTMkNPbWQ5UHNpeXl5N29HNGdLckE1VWNYNEdhbS9meUNLWk1E?=
 =?utf-8?B?a0k5S2ovUXVmVWJmMFo0QnVoejViOTVhVWM1TGVraTFTbEEvT0xudFNlQit3?=
 =?utf-8?B?ejJIc1RLZ2tDTmVLRmE0QVZreVFENllsMmxwR3pNanZMRFFyTkJqTFpRNnBL?=
 =?utf-8?B?Y25laGkrc3RQUWk0M2JJR3VHTkJhT2tON1BUWHp0U2VVWXBlV1BwL3A3ZC9P?=
 =?utf-8?B?QksrZm9tM3RCYk15b0dqNGZqWWxLY1dpQXNTZmpZWjMrdm8xNGV1ZFNMVUla?=
 =?utf-8?B?SlFFSzlKRy9lZWlXajRkQ0ZnSEJtN2NwOTcxRE03UzNSd04vM3c4UmVrOWVF?=
 =?utf-8?B?VlYrU3IrT2pQWHVwczZYdDVxNVI2Q1EzWTl0Z1RWUTg4Q0NUaU4zSGprKzZm?=
 =?utf-8?B?a3pXaDNaOWUvODRNMlhwYXNjd1FtSktIV0RrNWdON3lBSUg3MWxvRWdNQnRv?=
 =?utf-8?B?M0Vnek9HMzdQQXBET3drb2prN0ozd0kyczFMSW5TN0QzUEF6b2w1Z016aCsv?=
 =?utf-8?B?S1crWjZXMElEUXl3ZDNqMHpSZDhTSlMwTC8zTzNHWW8wdUFudmJVYkgwSzRY?=
 =?utf-8?B?VnJ0WjVDcDMwTE5LOGVtOTcyWHFXam1yaXZ0VExEa1BXam9MQ0p6RTVqN0RM?=
 =?utf-8?B?MFlqZi9FTW5LV1V6UnY2bUZaaHhFWHgvZGEvb2dsQkdjVUhMQWMzaGdObGhC?=
 =?utf-8?B?N0JJZHNpcm5yVi9palFhb2pHc1ZKbFpocmRHK2VHZ0xGWWtoQkNxQ0RZZHEx?=
 =?utf-8?B?RVQ3djByYjJMWnNMSGpwZlUxZlJmenR3WFFvSDZXMzQ0K2xPL3ZKU3pDc1Ru?=
 =?utf-8?B?ek1ZTXRRZlV2czNqT0F5WjBBUEdYdUJteFNiMzY1TGxqWmoyMUIyVUcxVlJ5?=
 =?utf-8?B?M2FPdDRRbUZXQUxoTXo3dzhwNk5hbTFGOUtscFB0Nm83MDEvVGRleE9IbkRq?=
 =?utf-8?B?Z2RHejA4c3VZYzE1RXdPQ05IclZSZ3ArQ2phLzF3NS82Z1JuS3FpemhJOUxE?=
 =?utf-8?B?bVA3UTdKbi9vNGdRUVFtMCtBSjVCVGQ0OWxxdmNSUmtnenYwelpWTkVwTmYx?=
 =?utf-8?B?dU12S0wzNFErMkNLcXlnanlxQ0dBQ2NOcC9IMjFyYXQ2RkxJcUtJYngwZktO?=
 =?utf-8?Q?w7V5GUxifycP6o/A=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 183039c7-d1eb-4c40-2977-08da3924f241
X-MS-Exchange-CrossTenant-AuthSource: PH0SPR01MB0020.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 23:20:07.3559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffu+pOHVK/ONom0YwnES2/BWsCyn/xSOowkmi1FWVPs+na8vnZUxkiRyScQ3G2/J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-Proofpoint-ORIG-GUID: SrJ8uWlNhNy_jNl_kaHUjQEAvkn_LRvn
X-Proofpoint-GUID: SrJ8uWlNhNy_jNl_kaHUjQEAvkn_LRvn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/16/22 4:43 PM, Matthew Wilcox wrote:
> On Mon, May 16, 2022 at 09:47:03AM -0700, Stefan Roesch wrote:
>> -	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
>> +	if ((iocb->ki_flags & IOCB_NOWAIT) &&
>> +	    !((iocb->ki_flags & IOCB_DIRECT) || (file->f_mode & FMODE_BUF_WASYNC)))
> 
> Please reduce your window width to 80 columns.  It's exhausting trying to
> read all this with the odd wrapping.

I'll reformat it in the next version of the patch series.
