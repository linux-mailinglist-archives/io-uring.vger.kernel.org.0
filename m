Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E0C5396D5
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 21:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346970AbiEaTSn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 15:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243775AbiEaTSm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 15:18:42 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BF8532CE;
        Tue, 31 May 2022 12:18:40 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VFiPHZ020093;
        Tue, 31 May 2022 12:18:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=MB2oX/k8VT0PCI36MRQQYLW8z0Kw8hOI5R2x+w3R/Pw=;
 b=MZnvK8ikYWP7gRI9Ts47kYdG1HZ61UKZJUBSpptsB43PfeqiD9ebJm4dCDXzh6MGGjAP
 eO7I5vbBLRp3qN1vGLxHAPtENArs2pQI2GTFxkv/muE2SaxPm3do9RR/kjbVsPZjyrFe
 kdT48YxIkvbiC3M9x9zrXLFlUDj6PkuaB/4= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gbfsj01b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 12:18:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmoAu1X4G5yPT0ZGWi2D+q43IvUW43c2Eo03UddDEqvUfSUqqc7t816T5prrpKWuyfWApfAsyeXHrv0ramO82GkjJiRxPD9ovxxzzSOs2SShl0OTrSoUzF0VIFy826VTLMKhtKdlixHXBRf/Z55gXnZqBx8T3uPlVQ0iNB3mX2a9mjbsPoj+eIOGbFQsh24Z2m3W8d5LHGW0ydniOtj1kFbQNFp0sEVMMBPIJWxTVFAcQ8Z/G6xvJySTs0+GVb3uVVzBo7RKX24QWtBOhyNEZxlH6LSEbp+Imu4tG48cPrIroLnAyQry5tn7073pLO5Doxhq+9LWF3OoclAESiwmpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MB2oX/k8VT0PCI36MRQQYLW8z0Kw8hOI5R2x+w3R/Pw=;
 b=LuwZ0+ori3uAyYYtJtSWk396iJ7I0Gigr2C49/7OT/l4KNO6oCjt3lUv3XCIRnnhEH8EJLmxp3R6goGBRJATAOBuzXTOrvBxZIHy5K7xjg0yV94zkDFaxVuyVDc6GTmNeu3ssm/4X7mPTcGSRDUsOGCbUKzpQQyI1/LEPoSQVgGt7tLWQCFNTGPZIrvvP/dPvig1n6Q5vBWTKcSjWoRM4hE2XNqRc3UHIHDzhX97LSDDVStUynu8kSyX9rTCFelqURxbGB62TkcFyDCPwcZ+CEkCFk6halZbi2owTm9HF3VGil+emmsBvCIkz+DpuWntBTwxgTUxa2CP655baYm6nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MWHPR15MB1791.namprd15.prod.outlook.com (2603:10b6:301:4e::20)
 by BY3PR15MB4964.namprd15.prod.outlook.com (2603:10b6:a03:3c7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 31 May
 2022 19:18:32 +0000
Received: from MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8]) by MWHPR15MB1791.namprd15.prod.outlook.com
 ([fe80::e17e:e90d:7675:24b8%11]) with mapi id 15.20.5293.019; Tue, 31 May
 2022 19:18:32 +0000
Message-ID: <e16c21b7-09e6-e4b1-6477-d1ddd9b311c3@fb.com>
Date:   Tue, 31 May 2022 12:18:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v6 16/16] xfs: Enable async buffered write support
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-17-shr@fb.com> <YpW+RKOGGkywMheu@infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YpW+RKOGGkywMheu@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0008.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::21) To MWHPR15MB1791.namprd15.prod.outlook.com
 (2603:10b6:301:4e::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71bd6a6e-0a2a-4d22-3e5f-08da433a59df
X-MS-TrafficTypeDiagnostic: BY3PR15MB4964:EE_
X-Microsoft-Antispam-PRVS: <BY3PR15MB4964AA4A4D91EBBA437814CED8DC9@BY3PR15MB4964.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ILSWe4d4yL9t+5hNegYoe5OXaULC/psjiuOHmmr033nG1LMDx+fLZ/xeTwqIZcvT5CEPsW4xjY0FOs549Q0VBNVrRKG6tqYZwU1eJ+hQ9cyyvZuJ0O83SsciksOl1zZk6VHbLd+RTSfQgyHW5e3dYfipv2FKtm057kI76pFgjQyQ+FBmiPNSpk4tYz6PHyjMt/ni1uhZf9axKWenN+/kcK+JwH4uo9cnQeAAjPNt9b4gfuCoVWTF5/57gnOsXm3J0QWTNW0/TOJeP8sYGmWPBdCM77yutzhx7iowa7RHodOuLef/57lqUL8m8+BmmFX0Req0bHrcHS7ONW4v9xhxPx2CrYfVc/U6DB3+R00TsSe4GdhLAtAXUqSrDIyE6LFB9wdsmee+d9RY0hUoiCDtuEvEnkcOAIpAJWS+zfF4yKlt0D7HTeNzcsh4P8ghrj4eCcWsefIBF4zqs1Nrvxkv+wZQ1YDorI112SrYD++SYuzBqymcEK2JVpy64LF+YyGgbUl8Pm9vXQ+3Sq0KMrg6QExQ47Vm4SkgZWA0IMsP4JLaAjBfWpuzMBo/v/glcfJq8SKuBOO9kVSgtD1iBLCuMIlYtW+hN85QHhxHawju2GLi/sW+gvoZm+zEZWvqiBu3oRhw+RgwtXshRiNeBm1UBrnw+I9MZHHM/wDzYjVx4vvHosP66XrU5clo1H1EiZx97D7wanDpIbh+l4V2PeJmix9MhpcT1Ytm5CoZ4hof6QQkvAi8EcfX3G7i/MLma4l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR15MB1791.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6512007)(53546011)(4326008)(66476007)(2906002)(36756003)(558084003)(6486002)(8676002)(31696002)(31686004)(5660300002)(86362001)(66946007)(66556008)(6916009)(316002)(38100700002)(186003)(8936002)(508600001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1E4QVk5T3QzTGtUcXBYRlM5K0FxMkNoMGZNS3hna2crb1QzVlhUaDZlTFkx?=
 =?utf-8?B?MFRjUlUyYnRQSTVZVHZpN3NBQkdFNWtkUzJCR0ZqMzJ6YXBsTkQ0YmxiZy9E?=
 =?utf-8?B?SkVWRjZhVHRhemZjcTRPVE0vK2FsRmR2WnhQcE1UeGxsc3VER3dnSmtEVzJ3?=
 =?utf-8?B?emkyWGd1ZVk4WEVFRjd5aEw5N3VUZmFheU1jU3pxUzlweXlHUURYTjRPQWxL?=
 =?utf-8?B?QXRaTmMvWnJBbkdkYzlTQkxjMEJJMUJ3VENMNk85OUV3bDBKVzdFckdlWTNs?=
 =?utf-8?B?RFZxelMwMGdPWTNMSXN2RG5GUVJkWTJwdDlrV0JlakZaQU1GSDRaZFFuMjlw?=
 =?utf-8?B?b2s3RUJscU5VemJYeGpJdWFWR296ZmlRUm1zSE5CSEVMbnphODJjQ0RYby8w?=
 =?utf-8?B?RkxDeVdEUTZ2bjFsVTZ5N0FWdktCbUtIZEk2YXZDendrcVhjNlFnUVpRYUZ1?=
 =?utf-8?B?TCsvY0pGQjB0ZkxMVDJZb0k4TlJDUTd4eUczdDA0V1NoUWxYWVZIcmUza2Iz?=
 =?utf-8?B?M21LTHB6OVhXUGo3azc4Kzdsa1Q4cnMvUU1pcnhNYTllSEhXazYrRWlLajdq?=
 =?utf-8?B?NUR4QU9oc3lQUVl6eUJTaGJkc3NJN1hHZkdybkhqOFk3Y3lXWU90SjIxVmd4?=
 =?utf-8?B?SDYwZTJnMVFaNk9oem91QWtOZlZEbi91c01LUC9SeUpValBteVFITFd4SDBE?=
 =?utf-8?B?eUtyeWRBbVdCZXh6NWFva0tUT215UFFMOTVmNlAvZnYrSDQ2VDlqOGxHM0JW?=
 =?utf-8?B?SUNSSWpzU3V4UTBpZnJHbFhVNzJnV1pscHFTZXoxY2M2b0loYnhsbDZsL21S?=
 =?utf-8?B?M3hnWDlhMEpkQkd3QXJ6Sm5sdW1JQURiT0N2VUZkRFBnSHZJZmE4dDluckRo?=
 =?utf-8?B?aXpOVkUxbFUwcUNoL1hqY0J4TUpwY0s2d0cxK29TaklVQzVWZGdXKy9YQSs0?=
 =?utf-8?B?S0lNMFhpNXJtT1orU1V5eU13K0doVFZHcTFnbG1VODU2TmhOUENITjlNd1VY?=
 =?utf-8?B?RS9tYlBacXBnV09vYzM2STBLQVgzU0VFNW54REpuQUp2eFdFU3JOMVRhV1dm?=
 =?utf-8?B?eWNBczFtVVNLbHpGRjBOaFl3djhLNWdyMmtha3lMU2oyNWdrNlFGN3F0dlZD?=
 =?utf-8?B?WVNmcVRuUWs3OUl3TEdhLzM0ZHZVTXlYYjVRcU5IWWlrd2duWFcyN29ZclE2?=
 =?utf-8?B?eE9zdFRrNUordVZ1WVM0OTRhOFQ1WVo3aS9ZUVdnb0Y0amtrZnhrcWhLZjc1?=
 =?utf-8?B?MkpUOUt3SVE5NkFObSsxbGx2OHBaSkVQVmw2ajI0ajBGem5VOHFoSHVtS3ow?=
 =?utf-8?B?TDBzTk94QXVpTVB4Znd1L21FVGpuSVRqNkFyRG1Za2llN0tTRmZ6VzdaVlJU?=
 =?utf-8?B?QWtxNkhZejJjcXVQUlphQ0lja0YyQkc2ZWZTVHZTS3BrNDM2NnlSZGYyN1Fa?=
 =?utf-8?B?MXFTdGNVVnVXOG5LLzUxandLMlZrbUJhWktwOEQ0VWZadzAxNG5VMFN3OFow?=
 =?utf-8?B?aGlXalJ5ZHRreWJYV3Q1YmNPUk9SUERYZjM0emJ0T05vbW9qV0NsREQ2QlRp?=
 =?utf-8?B?YkNMaVdDNVdycjNxTGRjVm5janAxbnpqUWcxVUJ1TFlldkZjOCtvbkdKQWpV?=
 =?utf-8?B?WU5LdVgyNGlKams2SGJua29abEx1ejQ1TU9xdXdRNStiTGxyWjlhbWVZNjZY?=
 =?utf-8?B?bi8vQk1XTnVvRDRvZ3RtY2xjbHJxbG81L3hXY0kwUU41bmZXVlVUdk1DbGgy?=
 =?utf-8?B?bnBwbnY0cWFHWEIzQUp0NWZSNmRqNlBoaWVFSHJjZllnWUpXR2FTSzRjWFRO?=
 =?utf-8?B?UGVTalk3ZElDd3VUalZEVW5NaGUyQVdQSnErTWZFclUzZXlnMnpaLzNBQ0xn?=
 =?utf-8?B?K3pxYXo4MW1EY0JqZ1VrMTcwOXBHRmZmZEYxU0lBUkYyQTFYU2Y1Y0lCOFdt?=
 =?utf-8?B?b1FQbWtWcjBBczZYcEZHR1J5aUZvWmVQSDEyR2hmNkRRMDdOd3NSVW5tVytU?=
 =?utf-8?B?VDBmWlhZdndPc2tWMUxMeHhRRlFjM2N0ZGNlZVVnZUFSQytWSTNqYS92WDJJ?=
 =?utf-8?B?VDJqRnE1RnJoTHB0UXZaY3BMUFg1Y1lOUVlOVVUrcUlGOE56MVhMQVhRcWFo?=
 =?utf-8?B?bjFOZlM1d0N5bnJLbEExU0hRcjhuUjRpZ1BUWFo1VzRJVkt4Q1VjS1U0MG5q?=
 =?utf-8?B?aTN1ZEtQdUQ1NnNudEQ1NlQ4aWpwanNLT1pSSWNqY2llRWpOZEdtQmoxcUtr?=
 =?utf-8?B?eFBsQXhBVVJ0TXkwL1cwd2NPUjlJNTkzSlQxeWpEWjU5TEdwU1lkdUFmUi91?=
 =?utf-8?B?NFh3SjBFMFJpcVNHcHI0NTd0NkpBWEZ4Ry91d2toN3NDVXpMbEFYQ29yazVK?=
 =?utf-8?Q?4iR9kkaL7h13Qs44=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71bd6a6e-0a2a-4d22-3e5f-08da433a59df
X-MS-Exchange-CrossTenant-AuthSource: MWHPR15MB1791.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 19:18:32.3344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f3isKZX5pkFGgnVoCJ8qlJrsfIia4gAV2kOJK6wLrJJ6xzjiZ7CpBwjIgBlQLZQ4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4964
X-Proofpoint-GUID: Epsuc8-WniBT4lZSfirsFbGQA-yxbhZ3
X-Proofpoint-ORIG-GUID: Epsuc8-WniBT4lZSfirsFbGQA-yxbhZ3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_07,2022-05-30_03,2022-02-23_01
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 5/31/22 12:05 AM, Christoph Hellwig wrote:
> On Thu, May 26, 2022 at 10:38:40AM -0700, Stefan Roesch wrote:
>> This turns on the async buffered write support for XFS.
> 
> I think this belongs into the previous patch, but otherwise this looks
> obviously fine.

Merged it with the previous patch.
