Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A355345D0
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 23:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiEYVfC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 17:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343873AbiEYVe5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 17:34:57 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B17A8889;
        Wed, 25 May 2022 14:34:57 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PGtb8C009759;
        Wed, 25 May 2022 14:34:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Puwei7XpOZ5MNxgch5yDDfrQelMCEk0uvLsGBugHhjI=;
 b=dk675n6lR6LTZj92mSHTX49rRyXHKKACcTG55wShl/2NMjYTz2uMTMcL2/LvGu5O/MHt
 979DH912CoItFRsWsw4IhGWA+p6EOU0C81Mo6XmE+ZmlyulvLWyrhfCmbCDavvjDk6PT
 gsMsYt3EmfH6oMnZrueGoowdaGoakI7oxic= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93tvs4jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 May 2022 14:34:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMAATvgbiPb9o1O1lnS2+UbrlS58dDNuEY+u/k3uX+6Je/RopyIFKahDBYHfUQSFOJ0TKui+0dJYe/IWAh1vDK90wk3XZjNq5f3vMDSgASLidgLAMq64egMKjIbKrukxj+4XfzCnxhvQP9QYMydPz1HoK6oUll2liuAEA09HjHFVTN2tS6fC7En80VXlvqbTLCndnO0G+A+XMWXsl/m1GPRTMOr6exMwL5aT+0gEX7m0uNT7IzU9v5KvvlX7UR+4YhpKOT9Lxsb65K9fpkzfCLSBinzu4HocbCrA1eAsoFFkT/uG7tBi/Sf8Gc7za8VOTnBXg8ay8umivke28skDiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Puwei7XpOZ5MNxgch5yDDfrQelMCEk0uvLsGBugHhjI=;
 b=h+cFZjUAPLauFaT8Fk8Z5I3f4SgGscgBa4jkAkBvWmzfjFkmAeEsuhHBsW2Oq/SsPEX4wSLkK1QmnP4qFh8uzsA2jtCyryzDQKOh/AHjYds7GrKVaikKm0btYtOB1YCD1hQiRxPlL9tesA8O6fkOJIJ3Nsm6vj6Y20kXydRfsa7CgtJrCyO3ZBUn0tHwPCvFA8oOGiCPGqp5o+3b7IqANv8iRMSHP+4AhSZWLD0Pbb06YHsLTWgsEDAr0E3iH8fvp1v1sWxjP4BOXe/x4xrPmxrD1rSbi+kJIRlNgm0nlMBoboX4A9satBjpktNKsmj2GMrkyYBRYHQe/H1ZhB57aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by MN2PR15MB3168.namprd15.prod.outlook.com (2603:10b6:208:a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Wed, 25 May
 2022 21:34:45 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.013; Wed, 25 May
 2022 21:34:45 +0000
Message-ID: <540aba0d-479f-08b0-e4c5-ea0fb311608e@fb.com>
Date:   Wed, 25 May 2022 14:34:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC PATCH v4 09/17] fs: Split off remove_needs_file_privs()
 __remove_file_privs()
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-10-shr@fb.com> <YonnC9JYZNWu8Mxr@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YonnC9JYZNWu8Mxr@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0022.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::35) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52fff08d-90bb-4aca-dd1e-08da3e9662ab
X-MS-TrafficTypeDiagnostic: MN2PR15MB3168:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB31682DE5EEE69974D22CE1DDD8D69@MN2PR15MB3168.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kKmZqrlOYGxA9J8P2STsM+T5YqL9M2q1i0ei9c8eAMDclgiTM3422ghNvuIyb9LJP49C8LyKAGtIzSvDfrys4w+xoGxVOoHq4f9znemYkyw8U5Gr66ugtiMT0lkkzzUoinXom9aqm7s1PZIWnJcJ0GmEdn6P+e4nmKVh4h+5FTHEZRdasqlV9IbGn76bYTz0wppVBvVATCf/Lnvd3KU/XYjE+YMaBQdnpIxv9FXp2e/ElirSbHu+lV4IVexTfDi2UGleMCEYk9peacOaPx+MIqTbOObcerjhOE5eOzsDkyqWY6HBMYyUcGCczZAiRFtj7FVhYZ7aQzRpwZm7r/XQ6A9k+oO15cLDqP2Mc4Bb4vrt/WybH281pqdEp9cA8/wgX0atXirUchbcxAA7fMKpPUtMAD8lFpOjxVIfFWRPVM+0q2NsldyED8BWpB4WAbly/mmyPKvOHS66+AfEMQOnqrD4w1QFRQQHUsId0bCQkc/bJ052lSkE5fZj8L4+VEUlzaeZaATZ0uOWkCT3KXMwlW5c6Y0K+ocNdmd6at+S9Sf7RAuTsI3ARCxXG2UiLwqv13tslqOJ5Up1JS7yAUM8N+vBY6IjxpWVQjrPj8Dd04rLQ0FUbTAWJbDRwpKV4BruPzkZL6y20RSUvzIxPUsvoiWLtqpcmPLxxaXuEflb9+fgOubuigCYrIhdv25qMo21nAh8xtUTrGFhMmnc8IQHedvmNTu/JI2G2ww29DowSdotDouskWUXI5q/GDY+8rso
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(186003)(6486002)(86362001)(66476007)(83380400001)(8676002)(8936002)(6512007)(6916009)(6506007)(53546011)(31686004)(316002)(38100700002)(31696002)(66556008)(5660300002)(4744005)(2906002)(36756003)(66946007)(4326008)(508600001)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0hWQkJNYStVMmt5T01zN2VGVms3T0kvVWFISEhoODNyUXJlaWlOWG5pUzVV?=
 =?utf-8?B?L2xDeE1QZzZxZi9aZngvZDRVZmhLRjg5SDRSUVBzUSt5NGNYakJLcjcrNXB3?=
 =?utf-8?B?cWVwTkM5ekIyeWJOQ0ZXVllyYUlEdjM1M3dGa3ZpYW1hOWtxY1EzVkhmU1l5?=
 =?utf-8?B?ME9YUTQ2TXMzNjdZMUNRbVZuMFcwWVNwQ0xsNUJtOER1dzlXVjk3ZzRsc2Ux?=
 =?utf-8?B?UittWTdDTk14aE5aTC9jNmYzVS92dE1sNVJkV3ZmTGlkbG1JZzdhRVVGN2Jn?=
 =?utf-8?B?MVBSd1B6SFZHdUxnTUQ0SktiajVONXlwK0xFRy9DRE5hWUZxRFpaeHVzU01R?=
 =?utf-8?B?Y3dveFJLbXVDcDFxbGdxckpqSjdsaFllTDdob1R1YkVETWU0cHd5RXJwMDhq?=
 =?utf-8?B?ajUxdHVtM1lQRFplNVpTZXNQd3JnSytMaTdiRFFmZjA2elc4YlNaZHErMWRB?=
 =?utf-8?B?SlR5MjBwWGZHY1I0N2JTbE1mRkZCQVM3VGhTdVBhNTg4OXNvQ1dSVlowZDJx?=
 =?utf-8?B?ZEN4UnNteENFQVQyZll6VUJ1SkJEK29RL3VwekM0Rm9VUUV3UkdOWExpUXBN?=
 =?utf-8?B?cExpSXlZYTg4czUweFBOSkQ2LzNBWnRvYkxBUUREeFlzeUYvcFQzbytKMWlO?=
 =?utf-8?B?cjJTdjE5TXZhajNwdmZQTXB0amQ2a2N3QWVKREdSdUdYT2NzK0FlTHJURmE0?=
 =?utf-8?B?VXZPREtpSjVvVmo2TkcxS1hzVGQ2RHZOdEphb0d4MEVUVm05MjQ2MlFHYlJX?=
 =?utf-8?B?OGZndHFOWFJPcC9SaXRMMjZ6V2Z5azNWWmNFOTNsNmJIK21DS1JaeThJeXBr?=
 =?utf-8?B?OC9TM2M5WGJwVmJCK1ViLzVoalZ1OWJPNndUbVhRYzRHN1VRSTFFek9sREM5?=
 =?utf-8?B?WlJPSmZiQlVtNEtYYS92TUFndHp3ZFgxUlQ5R0N4SDdOMWlFZHRtMTYwSTYz?=
 =?utf-8?B?NVJFQ04ybnk2QXJ5K1d0Vk9xMWV1QU5TdDNyeUtyTlBQeWkxVVdIK2gvQkJP?=
 =?utf-8?B?Tno0WkJKTzRQYW9PeElpeWgxenhWT3ZmV1VuSmMvbzE5UmZhSGhWb21Xa2JX?=
 =?utf-8?B?WTlTbkJGV2s4NjVJRlpsZ252SjN0eXhpMnc2eVZKUHN4SThBSmRQcmg5V1ZZ?=
 =?utf-8?B?ZGFMOTN2Y3BadlI0UHorR2tSdGxqbDJSMjdiMHEwcHI5a0IvL1BGUjZkdEdJ?=
 =?utf-8?B?UHV3NUhCVE5QQWVQVnhaR0lmV3dLdURRLzRVcUJnOEtEYVR6Vnp2Q1drS21v?=
 =?utf-8?B?RW44NmVURXY4QUNTQ3ViNXZhRHZRNExZSi8wSFhCS3dsVzNOQ2JnVnV6bGJm?=
 =?utf-8?B?WCs5UGNzMndjSTJDS2V0clAzZk9lMGpUUjdhV0JIK1FEYkVqQzM0c3NWampN?=
 =?utf-8?B?TExBcDBjZmlDNGpkUGxsUjVqaW93aVgvTFNkTGRBUUlSRXcvTlFpYUQyb3BQ?=
 =?utf-8?B?YURNRC9rWFRPMVkwcTFZM081MWtPOXdybGFsNmoyNXZlTjBFVTVYbERaMEtS?=
 =?utf-8?B?bFZHbXBpU0k4M3ZpNi9NMUVVdkR4ZmtVd0x3YXoxZjI2c1F1M1pKSHgxaHAy?=
 =?utf-8?B?dndWNmsvRlI5VndKQjZycTFkWnNyV3ZVOEFHRUxNejFSOTVvYkdKUlhLNEVQ?=
 =?utf-8?B?Q2VrSURrZXBTWGNKTHpGUUR3L0NXeHRpdzdXUkdRRUxVd0NGVUkxZnl3bVNB?=
 =?utf-8?B?Qmt0ZkNvUVpoNVpnMXlDL2FVa0xjd3h3dzUvSkQyeUc3L09UcUZMRDZaVVdk?=
 =?utf-8?B?b0t4N3plcFBXOUJzYmpRVHlPcXQ0MEZ5M2YvVElHZzNzdDVjMDc3YkxYRDhl?=
 =?utf-8?B?eVBYSW9yQk5mMkNicGd5ZWo4WHpkYnh6VkF2cVlzdkVGNU90QzJOdVZiNnMr?=
 =?utf-8?B?N2dNYi9GbllDdVFaSHlDVlJBRXhNVVBxdFA3WjRsZ2NNN2t0bkJ4NXkxTjdF?=
 =?utf-8?B?Y25WTjVOZzNGcmZCR1orWmRzTGlQT01NeGE4YzhFTkdjd2dKMWxIOVZiaGM0?=
 =?utf-8?B?eEhtYXMzbU1OVmxrckNLMlg1ZTYzcEl3LzF0ZWZmMXJwRThSZm05UW9sb3B3?=
 =?utf-8?B?czF5TVFLSkZSZXhqK3o3aVg4RFJndmhXbGhQdnRHbEVjdGtadW1wS2pxY2Zt?=
 =?utf-8?B?aVBYd1lHM2Uzd1ZqdTU5cXpvNjJ2TXdJbFBUamlzL3g1R0o0SmVjOWxWcGgx?=
 =?utf-8?B?L29JSm5JcnVxaGxRWEVQbVhTSGJzRkkzMm5tbHNMVU5zak9lMytmOXF2WUJO?=
 =?utf-8?B?cWFmNXJIQ3AyblcrVTFOMG1ZNmZ1V1lRL21TK1NCT1EraHFmSFZ1Rm5kL0gw?=
 =?utf-8?B?bC81KzhoSksyNVkzTEpFeDNISUw1NE9EWEYydTZyMGZIV3lxd05SL0g5SlJz?=
 =?utf-8?Q?0f7mMxqB/ul0L2dU=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52fff08d-90bb-4aca-dd1e-08da3e9662ab
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 21:34:44.9824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BrO4H18v7ZEs2ac91V/3dNlWMFU++kW7SAJ6Y9hQkMYPOduxJvGsWjJGi0+TWv4E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3168
X-Proofpoint-GUID: pXnw5Jxf14E1NYzW6ieNKxC0yr6FthN7
X-Proofpoint-ORIG-GUID: pXnw5Jxf14E1NYzW6ieNKxC0yr6FthN7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-25_06,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/22/22 12:32 AM, Christoph Hellwig wrote:
> So why don't we just define a __file_remove_privs that gets the iocb
> flags passed an an extra argument, and then make file_remove_privs pass
> 0 flags, and maybe also add a kiocb_remove_privs wrapper for callers
> that have the kiocb.  Same for the timestamp update, btw.  That seems
> less churn and less code overall.
 I introduced a __file_remove_privs() function with an additional parameter
that takes the iocb_flags.
