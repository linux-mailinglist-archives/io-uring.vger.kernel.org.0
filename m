Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC41645222
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 03:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiLGCkZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 21:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLGCkY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 21:40:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2953A3F06A;
        Tue,  6 Dec 2022 18:40:23 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B72XY8t001109;
        Wed, 7 Dec 2022 02:40:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=O8FXTmAIovbkLqs5AOdqBqcROOJJ2nNdgLaAUTQTo0s=;
 b=C7IO/26Up+kO9ZBC4D3sKhH0BKa7/Vb+z4rfAorISSZ4CQvmyNXF+sYtaxS7M6AC4XSO
 CpxOlr6mJZV7iMT3hqEtxOtv7Is/drQW4dgXmfzKDyq+YCCX4K3Fi+ryj4lMbbN0nxG9
 rzBLOg+ZEK1E+K2WkBmRiACo30DNxssVhRkbWLVjzGhxi+PUZsNlgIQ4QIM+0xfbof7P
 gyNg/ffm986KXyxb6R3ZDwY/PfBsGw24HUjNfcuGR8hwiKhXTuS1AnegKNWh7P3Htv1c
 AVloLwRr1ZNqsZkF0oQdcYxiDEHWLkA/07pZMjw+1pzBI6f+D+tTUy/iCTgw+kuyiKdh LA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ya49j2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Dec 2022 02:40:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6NeusZ030541;
        Wed, 7 Dec 2022 02:40:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa683qff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Dec 2022 02:40:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I927ZFryIjod0Vurf/FWPcmcd1jhFln4likMJ3beQkZLT5kNWIUh4iZKlA9/6jw952rONB1yphFLBhFGPUb9Ln4wAQJLxjE+QsT6Io/xDNjlVriwjr68ZPl3SD3f/UDx90zHFiigD1iuAfjFDzDZ4Ai7TdHDlF6LI/meA5smO5t1JKnMp/+FNHryHZtyipbvfhT1U2uMdtMybHXQEXO1pa7UKHbNvaLPHdVUJqNd2PtDZ/zsInwfTztkiWsCN6gFgLicIHktet4rjZmkAwrKrf1yaPBRw9MU4lhquWcnpnnbulsiWw0GdVFg0oghGNpBD6eG6di5uFr62Q43mcH6kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8FXTmAIovbkLqs5AOdqBqcROOJJ2nNdgLaAUTQTo0s=;
 b=hEOa2IOmbrWV1g8+59IbU9jXR8prGMMhlYzZBqvzgj6QLKDnpXXwvD1SHpiToD7r2dJE3yriuWNIMcq5Bplaz7jtwGGzNTo4HZIFXB1pdngPkr2DyV49HXqOkP6W1UoqDhuGESE5QTuzunczH3Gi8PHcA+FBh1zZsJdS7AkwGdZKV6OBH2oD3i/02TLXxdbrVr/UbNcfdTyGcoKroNiMA4Q7hl9THmEt5IyJeKNtteFISsq7qKRG2WFlXvb1gn6CtsnE8xrQYgmWp+DPISRc28U9nUKRdqzhWOpRh6E+ruWkqw5ZrIiKVqk3KuDfh+bq8JPZMzX510xQwPlyp0x2Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8FXTmAIovbkLqs5AOdqBqcROOJJ2nNdgLaAUTQTo0s=;
 b=s+98VKyJlXYTT8IQlZ149Ys87rQXMb4ejNPDonHzk7IsAV58LVaD1sr/sbdacH+Id/Ym+J+N2CHX2QPrkYBNc2wTa8p1d66PifX5j/RVtPvcothsqJel6y/q89lxlG+NOxh738P+QuAeqZ6fOON+pjZhs159L1+THOIZCJVzrnk=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CO1PR10MB4707.namprd10.prod.outlook.com (2603:10b6:303:92::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 02:40:16 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::1717:5a07:63ca:fdab]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::1717:5a07:63ca:fdab%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 02:40:16 +0000
Message-ID: <7fd0bddb-a9c4-e8cc-66c6-0cc9c3956c91@oracle.com>
Date:   Wed, 7 Dec 2022 08:10:05 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH] io_uring: Fix a null-ptr-deref in io_tctx_exit_cb()
To:     Jens Axboe <axboe@kernel.dk>
Cc:     harshit.m.mogalapalli@gmail.com, george.kennedy@oracle.com,
        darren.kenny@oracle.com, syzkaller <syzkaller@googlegroups.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        vegard.nossum@oracle.com
References: <20221206093833.3812138-1-harshit.m.mogalapalli@oracle.com>
 <5a643da7-1c28-b680-391e-ea8392210327@kernel.dk>
Content-Language: en-US
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <5a643da7-1c28-b680-391e-ea8392210327@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0085.jpnprd01.prod.outlook.com
 (2603:1096:405:3::25) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CO1PR10MB4707:EE_
X-MS-Office365-Filtering-Correlation-Id: eca862a1-5419-4860-cb19-08dad7fc5eba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tecv301jq9o1wn3tymeMhpp1cMOlaxOehmB5TH06yHBw6aNvwS41IhSDNT+8lIObm5PrIrdNtVlTpKyYB6uXgpzLcZcsWGES5YUTt7OR/nB3fR3yx2SYQuVgHi+00g43JrF4QfAEvecAgqsDnyo+h+UZ1vZRTwDfTFFOjPFHatcukohJP4C9C0eoC1PX9msbCgL/YGnq5QTOTatuvPwpbt9nZaAGsOHm6UJRr81dCL32kU8gkWE9KI81OWBCfCtYqa2/FRKPjQdN3ja7eK4ztWraD5VowLxOjP/vUXm8k1cN7lDb/8i5wLLmr84m43/VPZ95E5USq/UJHf+SLsTiAHgQ34r9Z/3+ctf0NcstmY+fPYuDkzsM/G1f4yfRSaLjnsQ2/zZyOxc2vJbeB7JTz6XipzH9ezh+YPL0W4pbatW1t9cNfHYRQxB1gTYuIGEqNjxPUPO8LaXfuFApOVZIaGSmaARndAzGNjnZxgLbiipmOCzAjI0ip7fWPWfmwrmkjAxQFM0jPVWUNJOGsXRvAAqOd14kqOcK1uFZqvhWzXaoWRawfaB9OARFzvX7cEGn5TAyO5Skfafcevm/wDkgvMQuQs3Mt+/1pAip1/Rr1A6EFaB4ViROFKWHG4/M3Yy+J3VJreerx2MrdhcIkwf0IWuSHwPHjtb16Vzt5UEqv6x6fGCjRNSCAbPZtxH7Werhozk6/aZubeLg3tMIQjNXgmHy2AVI111MiJsMMKDv68Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(66899015)(36756003)(5660300002)(8936002)(31696002)(86362001)(4326008)(41300700001)(2906002)(83380400001)(66476007)(54906003)(316002)(6486002)(31686004)(2616005)(66556008)(66946007)(6916009)(38100700002)(8676002)(107886003)(478600001)(186003)(6506007)(6512007)(6666004)(53546011)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEJWcWdGRWNBMFdIVGZaMm81cEFESnV6NUFCL2QwbzNoc2wvNWlnTjM4L3JD?=
 =?utf-8?B?NXJlK0U4VEZKZGVMcEx5SFhLaTk2ai82OVRsWkR3TERJK0hZYlZWdUZpcFZo?=
 =?utf-8?B?OXRJMHpxMGxUTjZNMjY1RTgzRm1POGY1MWdDTE13bUtMK1RzYXl6RFNxSEJC?=
 =?utf-8?B?L1gvZVVWdE9hWEpVZmdtOFREM1IrQ2Q3Tk5aVXA4Z2xydEhCcWJiaklVUk9a?=
 =?utf-8?B?Qi9zQjdDaGtwTDZ4c1ZsdzgrcVRCMld2UkNNNmp3b0lkcDB4WVlhZGZFaWMx?=
 =?utf-8?B?VGFrcmpIeWovZVhoSHdJWXVzakRDZm1DRkdoazRGYmpQM2FZbXNJRTNuV3Uw?=
 =?utf-8?B?UlBDRE1iNHZGSjVYVnkxL0xFMEhYcVBqTGRNTDVSeC9CeXY5ckpFYWJIQll0?=
 =?utf-8?B?cDBTRnZVUmN2T2tHQzlzUGJ1SzlCYjcrZTI0Wjc5TDVSZm8wTGxCM1AxcTNn?=
 =?utf-8?B?N3pCRlJiSWxwRFRLdmxaWVVzOXhqRUdCZ20va0QwVnU2NnpQUmh0MmdBQlNa?=
 =?utf-8?B?d1cxamVzVXQ1VW1RRVFmbTlqcjdxYTlxNGwwVE9HRTZTNWpzL2xQV2diRUxo?=
 =?utf-8?B?dkhMbXBpeWVGYjJsYkNZUUl0TnlJYWxwSkdhVElXLzZ1dmVLMkpQSkZnZGVX?=
 =?utf-8?B?R1VudXZuTGxYQ1NsYmFsci8yUEFnYkhzU1Yrb2VBTUd1T01TM095eVlHdUFS?=
 =?utf-8?B?TmxOVVZWODBPZ1hFeUN0cU44R2p3Myt1TjU2MGNqRXBpeDJSaXJQelNsWmZD?=
 =?utf-8?B?N2ppUjBoQXBkTVlDTWV4bDdPVUhUTkpRcVh3R3R4c1VyTVNGS0VYeWV1UzRQ?=
 =?utf-8?B?YUZOVVBCTUxCSE92NFpuTm9DRFZMQ2NKMTlsaHliSmJDNmc5QzQyYVFCK0lU?=
 =?utf-8?B?Y296R0VycCtiU2tXL3R2OXM4MU5FR2pFYWVRSGZvM3FUaHFDRi9DbTEyTzRx?=
 =?utf-8?B?c0VPeGxLTURPdnlnTlV0YTlEcTQ4cnpEMzJmUTlsYnhsZXJ3dTF1QVViWUs4?=
 =?utf-8?B?VlBTYXdTaStjY2VaQWVlSXVjT3ZUdjJuUzZEbWsydGxTUytUZkFDVWpwODda?=
 =?utf-8?B?T2dPZlJ3Mys2cjQyRk0zRHpXVW0waGo2bjV3RU9KaCtFUTFSbkhKS3dZdFBv?=
 =?utf-8?B?eEdPaDkzODZVNStRUUQyendxM0RvUFZDSVRkMVJqT01ZcGtkU092eDlqMkwz?=
 =?utf-8?B?YkFjbERtS2cyTEZNVERBYkRncWNrMjJnc1JIOXBITWlVdW5jRG1zc1pSU095?=
 =?utf-8?B?a2l6Ymo1dHFjUDZpaXNYZU0zSFFVOFI2S3B0ek9ucVZlWHB6dDE3c3pUTndu?=
 =?utf-8?B?OTNMTzNRWUk0UnJod1FIN1JBWTA1MGpKWFpUSXBGeDUvMkViSy9mTVhMMmc3?=
 =?utf-8?B?Q09wdHNuM2l6a1M1ZUNnUU1MQ0ZKb1hwL2pLZ3ZWSVNwa09nMWZxMUVTdU5K?=
 =?utf-8?B?cDkyQ21UYk5aa3VwZjVZRHpSeTdLMzBsbFhQajREakNaaFJIQzkzS1pLK3Fj?=
 =?utf-8?B?ejBtZzJ4VnhWc1Rxc2Z3UEd2dXl5bTluejRzM0RkMFhUOGdIM2xWQVE2cjBS?=
 =?utf-8?B?MHQzYUxLYnhZMHJvV0ZmVEd3UU9FR3BvUmF6c0w5QTdTYmlUWlIvYm9HZC8z?=
 =?utf-8?B?OENOeU1OZm1qL3dHMGI0NlJac2lMUXhIL0ZybEV6bFE1T21yK1JOUzVDRnI0?=
 =?utf-8?B?elRjdmpUcjZzUG5BVTBQOGZ4Wi9ZQnp6bmNsRVV2am5oeHdremhYQjQzSUhB?=
 =?utf-8?B?aGg5QWo1MzZmcFg4ZDFUT0UyeFVzUWFRdmtwSWlTTE95cnEvZWFKbS9xcGFC?=
 =?utf-8?B?WHh0YTVDUTJsZXZZOUFGOUk1alU0Qm1jVHkzTkJHTTd0bjZ0Z0pNTk1PUkZY?=
 =?utf-8?B?UThPNW56TkV3ck5ubzh5L1pSc25yQnFRbUpaVDVRRGNmOVVxWkZoR2l3KzNU?=
 =?utf-8?B?d0xLOVd5T2xFR1VCR2VOQ3BCLzBKY0RGTE1zdkpzRXR3Z01wMDdyZmYxdWF0?=
 =?utf-8?B?cFFiSkplZHNSK0JDSm1wSzR6cU9QOTBHNDd1S0paNTRuUVdySEZQWTk0VXRR?=
 =?utf-8?B?U21Nb2poR29JM0cvUDVST3M3eFdIWVNvbWVtYUpEYnpmbDdsOGFLN2o0cjBX?=
 =?utf-8?B?SXVrWWFPQ3hJb2IxUmpmcVl6QkFTUWZXOXJaUFh6VHE5R1lNUzQ0a3ppZjZV?=
 =?utf-8?Q?Sn9kLVqE6qAd6aeLF9al7tE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vy50Ul9VJvsNyyxbC9MqeB8KgE9WvHAaJq2X6dyZvMgZtu6DzpANG5BBLGMw+kgTaMXjlVMy5glz+5SUh24C6mMgRuhCrKsruMtr88Ia2niH/kNDQl+yVwicTh9h4m8goUEqar3gQ7UVI3RBlpnCfbzms3iPu7VsbLEKd7KJw2SX4BRWNG7GmbU1rZqUVLW2d9c/uuyu4ukHcQoux0aUXt/GVvagjTLPtbG7FuCE9BqjLIwecGA9aDNhCmjF4WbSYuQ0WYo3V1nQ1lNps7/HPvxpqJXEGMZInVaGA2gAbfYFRO/a/PjveiMmaaxgofTfK62euoG3Xj7x7t0wziISBvmpCZqPqHYqKydQ9MhE4c0WA62NbpaOFTEcyxJvNsiN/ByaQzeJKflX/ohLJwBl+ACElVzG5Bpz7zUBZvt6cVAw/qNbIYSs4eVln3k59jzHBASylctqNMYTG+AnVyvBjco+IT2/JY1XpDH0blxLUJn+L/JXvfTvtnKAkHgt7C8iq0LO9+Ui1d/jSRZoXCWDxvC8R4HqNx2WzkYk27PpOD9/QeU9p2AJ9+ymKGqseq7dQkePcfjYsW1ho3mgIFtBasMTLVzmST1nswj2olrvV4qDTMkKSB96iYg2uT7nUpGbsNB9QQEnPIwnXznb5suilL5ynzcGR/tuu1SEtPFkUHi6rUoH7ZuRRGrXaWuCpVeijOBKkhVjenFd3YmTjzAO4xSoJLMoZIdvQ32YvmK8P+dGwEJZqgCGQwS+iTbjRP+8tBnRsiH+Y+qZReA491XpXL9OFQQBoh27PyoEkqPXrt8+LVUJi/gG+MUBWTn2IWrcSKgY/02Zb+t4H9iiIVfBFYvjnimJ6NocrmGw3OBWP0A4zyyIx99PQHsmjOss3m6qY502SPlYXr+JKytFds7nnOsj7xF04FXk4iOzMc6u0zU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eca862a1-5419-4860-cb19-08dad7fc5eba
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 02:40:16.7208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VQ7bXxSo9RPVcGUR5aeUy8hHMreOr44KYhk4ncZE+ov3a/n93mw3bV8LI8Cy5UxAsUJ3JzhbvwY3NKj4plpTv07Oc1BJWU7uG+bkWSuwe4298yorhvd4KMXRlaSMMvy9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212070016
X-Proofpoint-GUID: -HjzunAMbngqUkAh-7IQSKWFeId7xbJj
X-Proofpoint-ORIG-GUID: -HjzunAMbngqUkAh-7IQSKWFeId7xbJj
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 07/12/22 2:45 am, Jens Axboe wrote:
> On 12/6/22 2:38?AM, Harshit Mogalapalli wrote:
>> Syzkaller reports a NULL deref bug as follows:
>>
>>   BUG: KASAN: null-ptr-deref in io_tctx_exit_cb+0x53/0xd3
>>   Read of size 4 at addr 0000000000000138 by task file1/1955
>>
>>   CPU: 1 PID: 1955 Comm: file1 Not tainted 6.1.0-rc7-00103-gef4d3ea40565 #75
>>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
>>   Call Trace:
>>    <TASK>
>>    dump_stack_lvl+0xcd/0x134
>>    ? io_tctx_exit_cb+0x53/0xd3
>>    kasan_report+0xbb/0x1f0
>>    ? io_tctx_exit_cb+0x53/0xd3
>>    kasan_check_range+0x140/0x190
>>    io_tctx_exit_cb+0x53/0xd3
>>    task_work_run+0x164/0x250
>>    ? task_work_cancel+0x30/0x30
>>    get_signal+0x1c3/0x2440
>>    ? lock_downgrade+0x6e0/0x6e0
>>    ? lock_downgrade+0x6e0/0x6e0
>>    ? exit_signals+0x8b0/0x8b0
>>    ? do_raw_read_unlock+0x3b/0x70
>>    ? do_raw_spin_unlock+0x50/0x230
>>    arch_do_signal_or_restart+0x82/0x2470
>>    ? kmem_cache_free+0x260/0x4b0
>>    ? putname+0xfe/0x140
>>    ? get_sigframe_size+0x10/0x10
>>    ? do_execveat_common.isra.0+0x226/0x710
>>    ? lockdep_hardirqs_on+0x79/0x100
>>    ? putname+0xfe/0x140
>>    ? do_execveat_common.isra.0+0x238/0x710
>>    exit_to_user_mode_prepare+0x15f/0x250
>>    syscall_exit_to_user_mode+0x19/0x50
>>    do_syscall_64+0x42/0xb0
>>    entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>   RIP: 0023:0x0
>>   Code: Unable to access opcode bytes at 0xffffffffffffffd6.
>>   RSP: 002b:00000000fffb7790 EFLAGS: 00000200 ORIG_RAX: 000000000000000b
>>   RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>>   RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>>   RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>>   R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>>   R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>>    </TASK>
>>   Kernel panic - not syncing: panic_on_warn set ...
>>
>> Add a NULL check on tctx to prevent this.
> 
> I agree with Vegard that I don't think this is fixing the core of
> the issue. I think what is happening here is that we don't run the
> task_work in io_uring_cancel_generic() unconditionally, if we don't
> need to in the loop above. But we do need to ensure we run it before
> we clear current->io_uring.
> 
> Do you have a reproducer? If so, can you try the below? I _think_
> this is all we need. We can't be hitting the delayed fput path as
> the task isn't exiting, and we're dealing with current here.
> 
> 
Thanks Jens and Vegard for the suggestions and analysis.

Yes, the below patch silences the reproducer.

> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 36cb63e4174f..4791d94c88f5 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3125,6 +3125,15 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>   
>   	io_uring_clean_tctx(tctx);
>   	if (cancel_all) {
> +		/*
> +		 * If we didn't run task_work in the loop above, ensure we
> +		 * do so here. If an fput() queued up exit task_work for the
> +		 * ring descriptor before we started the exec that led to this
> +		 * cancelation, then we need to have that run before we proceed
> +		 * with tearing down current->io_uring.
> +		 */
> +		io_run_task_work();
> +
>   		/*
>   		 * We shouldn't run task_works after cancel, so just leave
>   		 * ->in_idle set for normal exit.
> 

Thanks,
Harshit
