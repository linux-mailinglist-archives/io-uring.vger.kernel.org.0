Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6630F4BC126
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 21:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239445AbiBRU0N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 15:26:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiBRU0M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 15:26:12 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94053114FC2;
        Fri, 18 Feb 2022 12:25:55 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IGRroU004408;
        Fri, 18 Feb 2022 12:25:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=h2lf6ZeqjmFvpsfWgjumgsglZlNL1bJJ7cxGmoaBA0U=;
 b=mDBXYkZEehmS549kpVxiDI8IaY7Pamt2b5vb7M/TboLHTgdWbPkgH9WvKNyrWzyez137
 9NvuY6DJuAkdwrecKsNJ9YXT4vcRV069MPyGqYhdB9ANWOeIWGhP7IxbHQNDpxAP5W83
 Qlpge/mxgQcKe+KeJTYETUxpnyezlTkH/DY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea2j0ngpy-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Feb 2022 12:25:51 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 12:25:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHQhh/McFl55x5fLnYk6VJWzRVS3dsYUje3gySqAsKbxtMWlKNSY6akQIWUmJD5mgR8/QWEMFE4ywSi9izgzXDLPDJh76YYQBc7HHVEF/Q1fUuLQVcNA4KDQ5MW6kYVcXiiN0x6nYjVh8lyufnFc0KPAKRpK4Fbt9Bn7TYi+dvdqAo4rOE/K6x+CuxwV+hT3XQil8prAN0Z36yfqBnPFlx9f8dhXp75VJgw8g/uqoZF+OEElU1bNvi4hH2scXZ6a5XfNe3CUiGXUWsteWJXjLyn6g5iEK1j/fDZ77NMnA+CQs5PSWL1TsvblPG+w5swSW/IgauJdS6e+ZlZvtQX1ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2lf6ZeqjmFvpsfWgjumgsglZlNL1bJJ7cxGmoaBA0U=;
 b=MOOoF3vJPYXC4hp+TArxvMk+H3wo8pyiwW3WYSLkSXf/gZH5fIlWYO8pbYuHh34VL97WgsuxvLQWrXHLEHpOutcI1Wzvl/8CXkuhzx+RiSOybaA8WVxDdGrn6ww6JG5QEXDMEKL2dLobKDndWbXf2HK7+CIbBTtiFHNsUFotmtxSI4WvZv8S+4ghmiJJ7cKy2MPaLZVpOL4M3VSxu37KWBHI6S+BpzScLk8bA6oFNq9dhjnZTA/1sXvwOph7qtV4cQXP82KqS2AWAUD+QS3YluD78suJHZkQR7KRS5Mff7zj1STHReYTgBcIqrqFNrHURD/fw7PNnidxhaiqzVitFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BY5PR15MB3619.namprd15.prod.outlook.com (2603:10b6:a03:1f9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 18 Feb
 2022 20:25:44 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91%6]) with mapi id 15.20.4995.015; Fri, 18 Feb 2022
 20:25:44 +0000
Message-ID: <32fa0039-e7fe-1ab7-75c6-dc20c4e4cd71@fb.com>
Date:   Fri, 18 Feb 2022 12:25:41 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 01/13] fs: Add flags parameter to
 __block_write_begin_int
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <kernel-team@fb.com>
References: <20220218195739.585044-1-shr@fb.com>
 <20220218195739.585044-2-shr@fb.com> <Yg/6qDCDuCLGkYux@casper.infradead.org>
 <d6a89358-c43c-9576-91bd-d90db4d2aa42@fb.com>
 <Yg/9zKvlwkVJqj+p@casper.infradead.org>
 <5ac7e88d-76a9-9d8e-e3e5-58a89f48b0d5@fb.com>
 <YhAABYQDsqSiU5pD@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YhAABYQDsqSiU5pD@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:303:16d::16) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04478f3d-4937-4b9e-1ad2-08d9f31cd700
X-MS-TrafficTypeDiagnostic: BY5PR15MB3619:EE_
X-Microsoft-Antispam-PRVS: <BY5PR15MB36190F055084E5C82A4CAD55D8379@BY5PR15MB3619.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cq7yQAjTKGte+JFHob2AR6UlhZ6Uqd6wxdljXwY562z1v6fHHvMjmeT1qDpOCIufPS+PNtxXrstfZdTGtGJk23A8iPhV0vJmfsWTaRxUiAOT2RBOMrkao6zYuHIKJzth+ko9BZEtpYX7Zvf7ZN0WyR9Rq1Dh+qGrYyxgTWX9WjzzdmjbStJQsuV63KpWkjO5X1AuA2dlLUF7KPSWVTS9lrK8QNmwVL3GvUX7PTwRrR3eIjCwK95TmoQN4ug8q4/3Mg3ma9/MAfB5MH4uFYydtw+LdqfpWRgvsVBULgqTjELK0P/D3aYO4i5AGT+SnXxiE1LYx2VMq9imJEu32vIBXCwi0LheSaOqS3Wu0SvlPBf/fQxD/YeuPm1uFuZx8nG5kZ4Hwraq5PLXvXXku2Nss+JHIXT6U0WObt7Xn0bs4WW7NcoAVjgjNqgUr+sEcC7SvF6Iw8JBuqH51mYK3msOeXIKz0SXHcT4jCAcadu++LAFBNpP5qtMQEeFTEskXeMmcAiHDJutzSF1ak8iW5NJEAEuQzWUnLV3Q/xwj50wGbmoIKO3bwDBuhGZQTf7/cpy312y6EEbM3X2wmiKcpqpqrDRH2lz87JjkrYcDeiQI6Qqa2Se+KpO0nK2uRNnUMHrVEYLpD0okrn76upecotuIlnvLy+kUz2DEnuFGFudwf4wvCgMqQEFp+wMH1J6LtwTnR4hbuLUg51WB/E6fEmVRV3BzdW2wNVjosoGFlai0PGIb8Ot89zoe9eK6xbdze66
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(5660300002)(83380400001)(31686004)(6512007)(36756003)(53546011)(6506007)(2616005)(508600001)(6666004)(6486002)(31696002)(86362001)(38100700002)(316002)(4326008)(66476007)(6916009)(2906002)(8936002)(8676002)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWo2VTA5QS9RRkxjNHZuV2laTGFGd1k3Yi9LUFFYUWFpRE5TTkdleWlUaTFs?=
 =?utf-8?B?WTU5N2RBOVE4WTcwbGptM2MvTkNVeXdOb21rTmJxMlkvaXdjVFd6TXY3cWFh?=
 =?utf-8?B?YU1udFg1b3RKV1ZRWHJuNjRHWDlpMVN3VTJEKzFtN3FPUHVIc0o5Z2xkQWlV?=
 =?utf-8?B?cWx4QmxVK3lvTlR3cCtHUElpZzVjVU1NV0JIMCtSNTk2cUdBRnVrMGFaM0ZE?=
 =?utf-8?B?UnIwQ3JzdjFGWU9HT2hjSzVBUjc0ckgrN3E0Q0xKNEU1bGNqQjY4MEk2Rjgy?=
 =?utf-8?B?UUUrR0trYURYazYzSnVnLzNHQjhLcHBUSmtYNlFMQTRoY2N1Uzh6ZXcvVXUw?=
 =?utf-8?B?elc3aDhJOGk2eTdXTzdmT1orRHpRNnpsdklYaWl5WDVCamoyQmx2L09JWFoz?=
 =?utf-8?B?WHJUNHE4TXVGa0FCVXZwOGF2SE1GRHVQVXg0cERMVlVReFlrNGJFVTBCTWJs?=
 =?utf-8?B?MTJrb1lRY0ZkOHJpV1FkaytRbkFwSVZMTVB2TlBXSXpET2ZHSEdhRys5YVJL?=
 =?utf-8?B?dytHY08vd002a3ZJWDJXckhoVHgvRHN5bmEzWFphK0NObVNTV2tFRWduNGhR?=
 =?utf-8?B?SnVXUm4rc2oyMmFENW1meW8rWThjck8reFRQT2Q1SE04bUliWTRCUUZDaFBG?=
 =?utf-8?B?SFVQbXNabHk2U0VlVklkVm5ZcElEV2hYbnhieWp5aWxCa042M3VlY2ErUDFp?=
 =?utf-8?B?SW9NYVhUdUJTUVdLeVByRkp0cldNMkthYmZSaHRXQUJZMnFOWld5aEo2dm1Q?=
 =?utf-8?B?dVJOOTBCWFFwZ0NKa0R0dUFDVHJZWU9ZbnpUdmE1NWx0bzRaVUxtM3JlLys1?=
 =?utf-8?B?MzY2T0d4Q0RBWHhzQVlSUEpXTUNxTk5ZZmFucFowbUtDZm81Lzg4aXVudEdR?=
 =?utf-8?B?cm9UQnBzMW1OSXQreHdGWXJLYUF0b1RrYzdKUG4xZWtteXo3b010WW1rNVdG?=
 =?utf-8?B?am9xNDRZSVR6U2w4eXVqakJXM0Vib0xQQ0FmOGRRVk1tb01xeEhnM1hKTVJV?=
 =?utf-8?B?QzgxbGxVZmNzZWdmdUZRMTZTbWcxVkNFVENnSmdYTTNlTzNRa3I1bjI0NTg4?=
 =?utf-8?B?dWlHemROZUpxVDVwdEpEL2NHUjFCZmE0STFCQzBxKzlac09uajNxU1lseWJr?=
 =?utf-8?B?b2pNd1NmNWtrL0NUNkVFVnRPelN5Q1doTkVMTCtYSjlvbmRXSzJWMHlYa3Y0?=
 =?utf-8?B?b21IbWtwRWxlakFKWlpEb3FmSm5TTjlUejBOVVBKWHNRZFhCWWxIZGJkSllq?=
 =?utf-8?B?cVY4R3pBalA3Q21BeC91TVJrRVdkd0dwYnJPWnR4bzAvVDZ1akMwQTlDbGp0?=
 =?utf-8?B?czBkdVRndVFMSHhiOTBHQkVXQ1FMSWltandneXhQUzh1WFBtQTMzSW5PdVMy?=
 =?utf-8?B?OVkxa1ovMUhVa0liTEg2ZUNLZXRkOGRZWU5EdytNSUJVMGdrYkUwYm02R0dR?=
 =?utf-8?B?Zk5tOTA1V3htbGlvNjlQdkRkZDlmVW43ZXdSKzNKV3pyUVdkRzNUN3pWNG9u?=
 =?utf-8?B?eVpJTWdhS0lobjRhMVF5TDB1TGZETVFISlJaSFFGZ0NZNnVjeTFieTk1d0pU?=
 =?utf-8?B?RDhqWWFlMUlydWdOUVR6Z2ZWak40UWFWZFVXQ0RKL1ZMWjM5OHlwNW1makpL?=
 =?utf-8?B?MStYTWpGTkVnN2RjOEsxcnR6emVCdlI0bVlkeStoZnNXSG16eVpJMC9tTE9Q?=
 =?utf-8?B?bmVDWVZ3dFhDaSt1ODV6UWk1c3ZJcGREMkM3QVZYSUsxRzlJc3JDN1RJWmJ3?=
 =?utf-8?B?azU5WVBHWUk0c0VlSW0vRmxDMkZZSnEzR29SVHJxK2ZPQ1FZeCt3N3VlTU4w?=
 =?utf-8?B?ZitqUmFXd0MzSlNrcEVRdStaYy9ZdjhYWHc3MVliTDl0eVppdW16OVZUdEtG?=
 =?utf-8?B?TUZtQjU0VFdrZ1UrVFBZdUF4NVVHeEV0NlRqODM5VFlGRHdSZUluRlNwaUNG?=
 =?utf-8?B?cllPTktmWWFOMVN3VHMzZnoxeWp6VmlrWnAvbG9QVzc0NjZxNzJoS3VqVmRT?=
 =?utf-8?B?NjV6VE8zM2lwYUZ0a3hCSTdLS25yQ3pDWWp1WUczd2RlWTNma1M4RHJPRGRj?=
 =?utf-8?B?KzY0NFMxNWdMbzRrcTZMLzZVTXdvM09UOWZXbEo4WWRIMGcva2dBQzR4dUhz?=
 =?utf-8?B?cytVbUJOZFFPMjFsR05wTG9lb3pNd1I1dTFVbFVnSjF0L1psalc0dU1uV1FD?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 04478f3d-4937-4b9e-1ad2-08d9f31cd700
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 20:25:44.2471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9zgd98jWqaOo+kuULtH+mQfuvhh1BEKL8r+BZj2qm+7YhgZEIs7rpxnhK4WWlWk3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3619
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: nSYtmbRqlL1bXZj5s05z-1w-pMFSC9MT
X-Proofpoint-GUID: nSYtmbRqlL1bXZj5s05z-1w-pMFSC9MT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=543 suspectscore=0
 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180125
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/18/22 12:22 PM, Matthew Wilcox wrote:
> On Fri, Feb 18, 2022 at 12:14:50PM -0800, Stefan Roesch wrote:
>>
>>
>> On 2/18/22 12:13 PM, Matthew Wilcox wrote:
>>> On Fri, Feb 18, 2022 at 12:08:27PM -0800, Stefan Roesch wrote:
>>>>
>>>>
>>>> On 2/18/22 11:59 AM, Matthew Wilcox wrote:
>>>>> On Fri, Feb 18, 2022 at 11:57:27AM -0800, Stefan Roesch wrote:
>>>>>> This adds a flags parameter to the __begin_write_begin_int() function.
>>>>>> This allows to pass flags down the stack.
>>>>>
>>>>> Still no.
>>>>
>>>> Currently block_begin_write_cache is expecting an aop_flag. Are you asking to
>>>
>>> There is no function by that name in Linus' tree.
>>>
>>>> first have a patch that replaces the existing aop_flag parameter with the gfp_t?
>>>> and then modify this patch to directly use gfp flags?
>>
>> s/block_begin_write_cache/block_write_begin/
> 
> I don't think there's any need to change the arguments to
> block_write_begin().  That's widely used and I don't think changing
> all the users is worth it.  You don't seem to call it anywhere in this
> patch set.
> 
> But having block_write_begin() translate the aop flags into gfp
> and fgp flags, yes.  It can call pagecache_get_page() instead of
> grab_cache_page_write_begin().  And then you don't need to change
> grab_cache_page_write_begin() at all.

That would still require adding a new aop flag (AOP_FLAG_NOWAIT).
You are ok with that?
