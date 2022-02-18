Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02BA4BC148
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 21:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiBRUk0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Feb 2022 15:40:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiBRUkZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Feb 2022 15:40:25 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6170C53B47;
        Fri, 18 Feb 2022 12:40:08 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21IJtW9r030298;
        Fri, 18 Feb 2022 12:40:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XoatQy062xHdwmf+ghPVI+F2wlAR/NwpxHUQAZn5NHc=;
 b=X/dGv5o6FIwvQtzRhgkQdcENeoV7x4x6rncLztawCFEgvbQ6IIx5gEFfmykZJYYVCX0S
 6meVcgZwIOW3DriNIBS7uVU3Xj2fEIr0XiJOB/Kq6mcAkTxsV7aXyhARGYDKbjbDuRoJ
 7mUitg/6yp1vWGq645N2DC5iKyiVFnDooaY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ea9dm3vue-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Feb 2022 12:40:02 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 12:40:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UrpcV/DtqfgnyO5P8Yq4DP3AnsggH76uWBEsyf4PCVnm78Xp4fYnAn2EH21tv0gypPTSREO8h83yrKwCEZcg22J/mmT7oNgJrZjKVQM4OXl0qTSo17ztYVC/89bCXoSm4aEkRtzfCZAy6QYsWD9ajl+jpb9vRZXCHFJzR5Hlm55teiMhW+OZk0dNJs/lehfE63I/y/Bp2/y++LGPH2vWnH8V8cU2QiCSaGNfWAklqz0Vl8A54v/tjZRgKUDZLFnTh7dPqQ6BwsVh2M8pnNEjFmjz3ZhJGZsY9kBMPewjFBt4dpmBUkKsAd9k/HT5NxYN0rb74LrjXODN6ukYxY0Njw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XoatQy062xHdwmf+ghPVI+F2wlAR/NwpxHUQAZn5NHc=;
 b=WuP/e2E2e/l+2PTLK6DRG6TxH5v8/UxlGbNS+OTqhnjtYWrYBrpZhjxZYdIS6ornoS+WF2bKOFF/qDhCfRfqLHrDb5ArScjOQ0iQtRf3GJtd4EtzKk9lIwn3QfmdQq5uZ7151GI4sKB+vFJpoi5f+rLovwMO1B5vyKQTMXADXc4BjoMsddF5zvJSASJPqoldmjJk/lXbkn3hl1gN1NIAEMO+zgKdK730s9hdgyYhbDNWe9x2b2sRnQQ2HyIOO9Bl+niWssE/1t1hFSOscWa1RDEiSP27SHORs5essUehFrRwdnwr6fWdK1fr7BmWSKz1mbWPffCYt6haJYqzRE01nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by BYAPR15MB2837.namprd15.prod.outlook.com (2603:10b6:a03:f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 20:39:59 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::f06e:4aba:69a7:6b91%6]) with mapi id 15.20.4995.015; Fri, 18 Feb 2022
 20:39:59 +0000
Message-ID: <d16b4ec3-ba94-b14a-669b-4b9c910c9ded@fb.com>
Date:   Fri, 18 Feb 2022 12:39:57 -0800
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
 <32fa0039-e7fe-1ab7-75c6-dc20c4e4cd71@fb.com>
 <YhAC92ZwAsOQpZaF@casper.infradead.org>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <YhAC92ZwAsOQpZaF@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1401CA0022.namprd14.prod.outlook.com
 (2603:10b6:301:4b::32) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53f38a8d-b4bd-4ae7-519b-08d9f31ed4ca
X-MS-TrafficTypeDiagnostic: BYAPR15MB2837:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB28372427FA43434294FDDC02D8379@BYAPR15MB2837.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8FpwdrL0crF6EHLTGt96bnHuHHZ4fIRCAIkp61Fx6fvnMs+i1CM7PIsiRGFWEPkdnW+fYSzdfsyOSC/kAChqnHocxIg3Ld5C8fg2dSKaRfhS3MqVmh9MiHh3EJrWSaGdlBfs0kb3BUR7FZE+drNelfmjSdIDupSmBuvUwr1+8wVLxfnY1OjUEbxRsOri03fs2n+F/5xvAMRVaAjIjNO/nH83P00/g0krykWYGFcx0gbdHVt6dA7W1+kn6/3VO3U8NYNmT7nW0yiLyh/wYYEMr7Z1Jcyj49d0yNn1NAaKXCTDIuNaXbI4IY8ObCS/za8LIZYiTaoA9RZmr65MBmxtYulF4aOKYk5avJPEcwJgRniOMaumAkB7/ZhyPCHdBIdsgsJHwWxsCYCzjeqbXhKugmHDwFnTQt5WMHA8I8dPgfBzyAryP79Dx7AAJ8qdrWrRhxX1lJRHonZZd484QL6EtZyyN0WugUenCE+8lN8d/s2QVQv4c3igjvbFJtrrxlvhzQtbC8ccgF3/NjuuB6PGezb7LQTT6iDoAaniYbUDLvzGSPE/FkjIn2LB/M0/qnCen+M6+ZR2MIrFkhnHyN3fwa6J/H71Pjs9lsmGymGQV+wU/0TJnwcMN+v20As8sZrVuHiIJW5gPEtTAG0a/hLK3p9rsHVE9I4lH3ZEKCS4tKSmRE0r6vEEHAUf2FcaxH4RVcMFdRXX7DG9zBevZ2ui9QmA7Vvp81XK9iM0p/V0qNqFGszT09uXcCApSyXAOUbn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(38100700002)(31686004)(31696002)(186003)(66476007)(8936002)(5660300002)(6506007)(316002)(66556008)(8676002)(4326008)(2616005)(86362001)(2906002)(508600001)(6486002)(6916009)(66946007)(53546011)(6512007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkJaUjVEak5EVThyUWpVVXc2OGErb3o4MW5UcndPR0tWVlR6OTVKN09sams3?=
 =?utf-8?B?dHBvRmxXWHR5MklDWEhlZkNtQWZQbTBpckp2NFZVdkk1QmpZYnVqL2sybFM0?=
 =?utf-8?B?aDNEc3MyWHl5UkxwMDM1ODV2c09za2tCWWtCb0hpdXMwcnVvYmtHT1hFTUg0?=
 =?utf-8?B?alJpdzFqK0NHQmlEd25EK2YxOXZ6aGYzL1ErYkd2NHV0OHltelpYUVVzQVVF?=
 =?utf-8?B?eWRuUWc5WTZ0dXFZU2l5MVdmZnFjZHhGZUhjQW9hbHh6Q2J1UjNvcS90UzQ4?=
 =?utf-8?B?TGZIaFFXeGxJdlBkOG9nQ0lhdjhCMTFqc2dEQ2pkVTFid2RLUDVsb0E1THNx?=
 =?utf-8?B?WFJzU09SOEd5ZW1LVDNuYWVqNW5Tck9lcjZ6cFZNNVdrRURMMGptU29YMFZY?=
 =?utf-8?B?VFdncW9YdWVnOWRDYVhYQzRocUdseFQycWVFY2xRbWU4dWlERFE4eTlBRzlE?=
 =?utf-8?B?NmxybW5BT2RGeDkrbWhjYmJMSWNHLy9yQ0Mya01BWklTYzZSQ0s1Z2hnVUJv?=
 =?utf-8?B?Z1ZKMzNVNGhyejRDYVdlbk84TTFuQ3pFOVJqTk14VVJLS3dwd1RxZVZDK0tr?=
 =?utf-8?B?NXcvRHlsNG43aWRXSjFmYWVSaExJTFFDbzlpWnh1T2RJNVpOaU9hWEdmVlNt?=
 =?utf-8?B?bGE0blZXYUxOTEJKMzFjemkvQld3NW1GQ0M2cWVteDUzbFNNTEgwTXpHRzA5?=
 =?utf-8?B?VjhXQTEzY1BYL0RxdktoOC9iUkt0azlmSjNGVkRRNUswNXRETk44TTBPTHpS?=
 =?utf-8?B?L2RNdGZ3WE0wOFZQRWxHeVV5OU1tTFZNZ21uQTVLWEZYWVRCdVE5U2Rxbk5Y?=
 =?utf-8?B?YlJTT05PdW9ic0dnL01iM2IyWlFOS2x0M2RkeHdTSXlVUWpUenlZS3RTNW51?=
 =?utf-8?B?Y2JwT1JlenlmUEplb2VmTGN0V25RZHlUUE9lUjI0UFVGSzloS0xtQjFjYVJn?=
 =?utf-8?B?RTQ3NVpIMEVzNnZJWFZuanBuaXRnUTNrNGpHQ3lVTHVwbC8wdmM0YmRaS1JT?=
 =?utf-8?B?QmRuUzFwelcwbWwzci9qY3NHdjRGKzZ5cC8wRStMTndGTGsyNnp5Ky81WjJQ?=
 =?utf-8?B?TFNBOTlwNGM0QnNsZGhMbVl4aG1TN1BlWVlIeG1GK1pFQnQyZ2FwOVNiSGxk?=
 =?utf-8?B?dXFxYU0rUUp4SzJuYmQ4NEg2RTkvWkwyRTEzVzNFTDlsUEZJYkJCV0l0VHRN?=
 =?utf-8?B?SU83WkJLZ3JudDM1SVJlQkdYTnZ4SHEwQWRycFNuSVl5c3Y1WlhOeElzdHBB?=
 =?utf-8?B?TEkzcWtvVTd4TGk5UFczdTVRS3ZCZk5Cd3lIRGlvYWQ5ZXAvMytOZXN4OERQ?=
 =?utf-8?B?MldVejhLSmFPeEVuOEdaNlhiUEYvMkFwVTJOdm4vRDd3WWZka3BVU2NtRVlW?=
 =?utf-8?B?RTFyYnROV0Z3S0ZzS0ZTQ2RvQmEya3o5d1NLR3J6RUFxNDF1VnIxNUMyYU1K?=
 =?utf-8?B?S2xsVG9sazVlZnZGUlhpWFB2YU9GWTJuZ1h0VHBBYVFSZk1CcVVEV0tQdjI1?=
 =?utf-8?B?bUNLUFB4Mkl5RCtHSzE5dHZoRUdHT1BkQ0hCb2ZiL2ZEK2Q0TnNZNnZnbTFT?=
 =?utf-8?B?MUpHVFBmcERiNFdTQ0FpRU5CNURiSTU1MDZxdnUrTDlBbEUyZnhPNzM2T1BY?=
 =?utf-8?B?UEZieTJ2MHA2MjNVOVVDQ0hndVFuLzA5QlhuV0pjUkpZcEZvUWpvZ1R6cTBj?=
 =?utf-8?B?bDNRandBbmtsVzRGdXU4cHNwZ1pnSjY3STNmem5RZDRtMFRyRnVUWnRyU2VD?=
 =?utf-8?B?dDd5UlVRcDJWUDdTMDVFZFpzaFZ2eHVicHJkMTNJVU45bzd1cU5nZFN0c2dB?=
 =?utf-8?B?RTc2NEt5ZFg4alU4N1I3N2wvbXNMaUdmZDJCSW9hditlZ2doTTQwbHVVUmt4?=
 =?utf-8?B?SWFlWlJwbUhBWCtvYVV5dmJTZVhmMCtCWjZVU0VMZkpNbllDMDcweFdIM0FD?=
 =?utf-8?B?aDEyUHFES2UzL24yYkNRQTl5S0xtRWkwTnJXdDQ2dEx2ak93bGpGUkRjUWUy?=
 =?utf-8?B?c0ZmaHd6eWsvUXpuSmVXMzBUaXJBNldRTjMySVpVeDFWQjljQzJzSzhWWkdm?=
 =?utf-8?B?SGRKREN1UHF6VnplbmVWc0lyd0wwUWw3bzNwOFRONXVLSzFjb1lpcmRkK3Mv?=
 =?utf-8?B?NG1KZmlhOHdDT1VQbHdpdkwrR3RDWXJIREc3VWErV0ZrdFM3UXUzcGRWS3ZH?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f38a8d-b4bd-4ae7-519b-08d9f31ed4ca
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 20:39:59.5170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwLjeexCuoT2PWDTgefjHSc1PLAeOLNEFv0upq6rxDD7eofZ0tIya5EPKpTsVMPo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2837
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: jGwjbD9rbwjwvEcbja-sUjIQQnpJMzTZ
X-Proofpoint-ORIG-GUID: jGwjbD9rbwjwvEcbja-sUjIQQnpJMzTZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_09,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 mlxlogscore=584 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202180126
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



On 2/18/22 12:35 PM, Matthew Wilcox wrote:
> On Fri, Feb 18, 2022 at 12:25:41PM -0800, Stefan Roesch wrote:
>>
>>
>> On 2/18/22 12:22 PM, Matthew Wilcox wrote:
>>> On Fri, Feb 18, 2022 at 12:14:50PM -0800, Stefan Roesch wrote:
>>>>
>>>>
>>>> On 2/18/22 12:13 PM, Matthew Wilcox wrote:
>>>>> On Fri, Feb 18, 2022 at 12:08:27PM -0800, Stefan Roesch wrote:
>>>>>>
>>>>>>
>>>>>> On 2/18/22 11:59 AM, Matthew Wilcox wrote:
>>>>>>> On Fri, Feb 18, 2022 at 11:57:27AM -0800, Stefan Roesch wrote:
>>>>>>>> This adds a flags parameter to the __begin_write_begin_int() function.
>>>>>>>> This allows to pass flags down the stack.
>>>>>>>
>>>>>>> Still no.
>>>>>>
>>>>>> Currently block_begin_write_cache is expecting an aop_flag. Are you asking to
>>>>>
>>>>> There is no function by that name in Linus' tree.
>>>>>
>>>>>> first have a patch that replaces the existing aop_flag parameter with the gfp_t?
>>>>>> and then modify this patch to directly use gfp flags?
>>>>
>>>> s/block_begin_write_cache/block_write_begin/
>>>
>>> I don't think there's any need to change the arguments to
>>> block_write_begin().  That's widely used and I don't think changing
>>> all the users is worth it.  You don't seem to call it anywhere in this
>>> patch set.
>>>
>>> But having block_write_begin() translate the aop flags into gfp
>>> and fgp flags, yes.  It can call pagecache_get_page() instead of
>>> grab_cache_page_write_begin().  And then you don't need to change
>>> grab_cache_page_write_begin() at all.
>>
>> That would still require adding a new aop flag (AOP_FLAG_NOWAIT).
>> You are ok with that?
> 
> No new AOP_FLAG.  block_write_begin() does not get called with
> AOP_FLAG_NOWAIT in this series.  You'd want to pass gfp flags to
> __block_write_begin_int instead of aop flags.

v2 of the patch series is using  AOP_FLAG_NOWAIT in block_write_begin().
Without introducing a new aop flag, how would I know in block_write_begin()
that the request is a nowait async buffered write?


