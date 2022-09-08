Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4FD5B1107
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 02:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiIHA1K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 20:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIHA1J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 20:27:09 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDCAC5790;
        Wed,  7 Sep 2022 17:27:08 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287IEk3a014661;
        Wed, 7 Sep 2022 17:27:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Sf6vvWcLJKTpTHzn3+QeB+n8c0YCwqnuUgLk0666zIE=;
 b=X9Lbbr3Lv9ImKZTQX9mUmTovwofHUl7EAZFssRyT0/1YASc7s67HmKNI61lvwJohbkYe
 cWSTBh6r2+PLstrLbHjcstfqJYtCcfsBuzMH9NpwSjDMoz6Nf6m29hNX9MuvEcvZEguD
 iav6+eSc0aV1NlCu8DGQ/z/e4Ln8BhT/cbk= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jf0dej7jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Sep 2022 17:27:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLVe53GU0aGuHneS3Mpe6xjnYXLcruYHT7SNNbqNUKbouaeOSsGmCsfVFVswZDblWF4D9y12oUHIgCombwwXAMXrXW69yWNMAxiX307TX9b6K/wpTe2jFW1b+GHs3H30SielEJA45JcbvmQLM+9trJAaBzAY3pyJI7NBlVIOW2AT80cz1mqLkbsy9Zb2WB7KBY4/lzIhxDKhEw67AUuyEQhD8QHOx9v0Rn1EB3Vln+En4Ni3PMM4f8P2r/jZK5mINfSzToeuwgSpWXXi9V3OH8N8pjx+JZKxrKxzj/HCzY/8kBa/EV3/WAp6JoHh2LG5v10vM1NQnLQDQK3EhZTDXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hiKBJAyGf7A00D2Ls8O+6GPv56K2ZYJhJTqiD+DHyu8=;
 b=Lc4R+LvmsbKPfsjv7a3bSg+nQCUaQXfQXepc3fyPbVj3Q/MdRpFy99jTKJqS3Mts3ohw8z7y2Yp6PoO2GaKHyLPcWBN2UMI7/drYeyeV6E6KZxCBFPI/1sUMrdnq4w9KF802c//MXRrTQdNQkLdEqFnwdOYtyONdcK1DHQFq+LoKxsj0BhnjKWzpp/qxp/hSWD9PGRiFoEFPBhPtIatkkYNOWRsACUvBYqvRKoeCYEf3i68Hpj/mZ3S+WWgqgM8Qs9tMnqVWlacoaFv0Mg26zFpOqOfHWw5CTC7AbO08YSuhA2C7e/RKVn/B5jGDonRsvMwMWd/xHYajzOXNomJs+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 BYAPR15MB3333.namprd15.prod.outlook.com (2603:10b6:a03:10c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 00:27:00 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 00:27:00 +0000
Message-ID: <0dce1ed0-576c-fc99-025d-db4caac1615c@fb.com>
Date:   Wed, 7 Sep 2022 17:26:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v1 09/10] btrfs: make balance_dirty_pages nowait
 compatible
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, kernel test robot <lkp@intel.com>,
        kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     kbuild-all@lists.01.org, josef@toxicpanda.com
References: <20220901225849.42898-10-shr@fb.com>
 <202209022236.e41DKuIt-lkp@intel.com>
 <4ad5f8f7-9484-455a-77cd-d1c8a0dbcc3c@kernel.dk>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <4ad5f8f7-9484-455a-77cd-d1c8a0dbcc3c@kernel.dk>
Content-Type: text/plain; charset=UTF-8
X-ClientProxiedBy: BYAPR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::21) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|BYAPR15MB3333:EE_
X-MS-Office365-Filtering-Correlation-Id: ad0e7b52-5920-4d5d-e508-08da9130d894
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g+Kxj8JIHEhsnREqgyhntkPoLnft+pAVtyM2LjhPaJLDdL1VVi/tvZ27qAzMW3o91gtJMoKMS0Ts5ucw1glMJqH3EhqXyfGQw+VVlgNA1eOMGaNE+8A4ixARe4UFRF1SfsZ3UhFRJCFHSdBKT7u28mYhm0orOyfFuFrN1x9hS6X7Bm2SrxdqWGtMTYd66n+YYnn5zbmOWTs6Dlh+itcY6aQ7p2gUlfHzFy8mA4c4fEyWw5ToPd2eYnbNtJ2+8ZWVNKoOKW7YecZ1DK7Awg1WPI8cjwlCtNNSSqyJJbvnrJW6h9X+y8U3Kp2FKl4sV934ctOnMnOJiC2+7+CYAoNIEKkxfzvSftexqAwWj64p4OelQlS3ezuQVcFeY6kdnvd4fgd49jYiswqt2e5zXtu4rff8kMuBNUN0tTonzulQ0BqmvzYmptWhG8sUXKMxri67s58D3RYDvE6Vd+qcbzECI4yiwBM1zQtShAehxNBoAH4vevNsfBhR+Pr4plxw7v2+uTtThmgd1MgAVsm+XX/d3SX6yNdIKTVb41uzwF4Q/YzWOVtgE4xa5C+eoHWNhoM2jVQScM0Tv+G9VIFZZrR+18bwWQds7gmxmje/JvMc9OX/LOMd3IsJJB/phnoaEEdwc5/Ukxn6o76iRhCi414sgh60O+g/hxPZe7TmVbzm7j4gjL/K3WRkd866JoOzYyZtMVscDR7rLAZh+Niwio/DcYy++GzubdQb7cqgQIeIRKhOPwBYCb1bRQn+6IqARzL3nQL6pn+O95PfFcoa0G3s5j36aglmosY1ZDe2Nfn1XXRnEWkTQA7d//SA8LHTU7VxS+LOMDAmPVl9EvYLQZmLXPsIKp4JMjk0wCVVFsJldlLgN/7LKdNFTe6fP+SC0IvD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(53546011)(66556008)(86362001)(6506007)(2906002)(66946007)(6512007)(478600001)(31686004)(36756003)(966005)(38100700002)(66476007)(31696002)(4326008)(6666004)(6486002)(8676002)(110136005)(5660300002)(41300700001)(2616005)(186003)(316002)(83380400001)(8936002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTNhbktuUStHREtQMWFHaWNkVzU1Q25pRXJ5ejVkelZtRnFHdzN4Z1lSRnd2?=
 =?utf-8?B?ZUdMd3NvaTM4SndLTS9EVC9Wa2RMazZWcytnQVAvNndpRGpEU2pJWnFhL3R6?=
 =?utf-8?B?MmVYNktiL0VWc3RZRkcrYmE3cnUxVkIrTk5ua28xUUpxYVJoTytsUC94OE5U?=
 =?utf-8?B?WVRqaERlSjFLZkdaYUdDRmFZYmJaWHN3YUdtMG1iN3hHbFJ5YW5OYzdiSkMx?=
 =?utf-8?B?OHV6NmhJSVNpQnNsTHRXcnNRTFowc3R1MDU2SXZ3QUROaWlhMGlBWXo1Zlha?=
 =?utf-8?B?ZWF2aFBsWmNwVTVLSUQ2SlNzdGZVdkdWdDhrbkZQZnpxMFZxNmwreE1seDdB?=
 =?utf-8?B?YitaWFdPMWgrc1FHektxR2l3K2laeGNHTXJkQUdXN1dDQUVlMVFxN2p2TFVX?=
 =?utf-8?B?TGJvbnFUSGZtT0JzdnNSZkxwVjdzQXczMmNqLytnMC8vRXdURllOcUdrR3My?=
 =?utf-8?B?RFVheHFza3VQSzZlZ0hsQ2paR3BOT0lHc1kxaS9qeGR3clFkSmpTb2hDcHdG?=
 =?utf-8?B?U3NILzBxcW1lVTN3K210b2ZsTkZpYkZVL0Q3OVJWVEgxMFN5REF1M1JER2VZ?=
 =?utf-8?B?RkhaR01RczJhSlJsNnFyV0FWN0JMK0k0U2FsT01ZZlpXcUsreXl3SFpTdWs2?=
 =?utf-8?B?R09IN3licURQNVhDaGtJenNhTUlZcG5KN0ZubjZUeVBXbDM3WWFhZURNbm9l?=
 =?utf-8?B?VDltK3c5bmdiaTBncEtkbjQ0S3dFZHlicTB5d2JJb0Y2TFJJYWZxMWhZNUxt?=
 =?utf-8?B?ekpBTWxJKzZaT0I4UHFKTmV6Q0xuUmxtSmJja3orOXhsdC9lQ0t5T0srSHFZ?=
 =?utf-8?B?VXFsUjk5NXIreFFnL2Q0d2VOSksrd2Vjc1VQdzNrU3IydjNWY1dGR2pkdjdH?=
 =?utf-8?B?THlzMTB2a2ZsY09oK0c2T0tJWmMzSWxaSWNsMEJPeXRJNDVVNEF3c1drdVdG?=
 =?utf-8?B?NWdTYWo1SVQ3UTJDZWh2S05sbW5kNUlpa3ZTWnk1UGlUMGlvcEJlWXNEcDZQ?=
 =?utf-8?B?NnYzdDN1TXhOQkZyQzg0U2RCbThUS1NXVHhnNVNyQktLZlB1SnNWRGVLYlgr?=
 =?utf-8?B?MFBnZGc4TDFqRVJSRTR4TWJFVkdZYjNudVlnNitpenV4Y25mQ3FjMXUwOUZl?=
 =?utf-8?B?SXZkU0NtVWVKN1lqRkMyMFNwUmJGMkozclN1OWZpN0dBb3FFU3BTQ2ZNV3ds?=
 =?utf-8?B?SFpIT2pkQ0N2YmF1a3hFT0hiYm1LT0VtQnlmTy93VnR5TmZ2N09zZiszOHBo?=
 =?utf-8?B?d2IzdlFsTzdhdENXYmFtUXFPOWpINVVtM2RjTitZZ2RNZlh1UVFvQ2lFSy81?=
 =?utf-8?B?aUlnSkcwR2w1RjkwblpLelNxS3p1MjJIbysrS0RMdjc3MlptK1hHUnk0VUw0?=
 =?utf-8?B?NHZ6cDJ0TlE1bVJCUlBoZDNWblExdW5KZURoVXJJVld0OUJxQmErL3ZvaVht?=
 =?utf-8?B?WEdZa2pRWUVITThRdWJtOVVySktKU0pXUkNEUitCZ2MyZllmNE5sbXFzUXNH?=
 =?utf-8?B?VktwRjdzd2hzalp5eGxnenljMUpUdHA0TmloZVN3cWptYjRlN1dUUnBHalF1?=
 =?utf-8?B?WFdmeGFpRXBLeThhbzVHajdscFZtemxMenVBU2JZVS91N0lCa0ZxblNtTFAy?=
 =?utf-8?B?NGlGQTJrbExVeElEZHdMS3N2NHhBd1UxbDltNUV2Q3Z2Y0EwTkE2aFBFeEZX?=
 =?utf-8?B?RHlBMG5MRy90dVluTnVwcXNaNU5aOGcwNGxNczl1dzF4Skg5TDI2OE02eWc2?=
 =?utf-8?B?cVF0d2FkWEpMbXdvN0V4ZGJaMWFWajNnTkZBQjhVWS9WQ2QzclV1VzlTS1BW?=
 =?utf-8?B?QUE2SU5YdDNjeFBJcVFpbW1mRXptV3dNcEhQblhHcEt4elNST1NKZS9Obi9m?=
 =?utf-8?B?d3pMVloxNFNqbzVLazFEMzZPblhPRjBpOGZmSWtwdUZrWlF3VlA3c3YrR05S?=
 =?utf-8?B?c2pXdmMwbHBhbTJrRTVPK2FiSnVnSFRlMkVEbitROVdpZFF4eE8wLzFteTk5?=
 =?utf-8?B?MEczc1o4QWFuQTRzZStVbUZGOVk4MEVuZWdRcm5ENjZBanpkSm1ZU2s3YnZQ?=
 =?utf-8?B?aENsY1Y1OU96dUxJN1NzUWJMUzVnNUcxbEVCclRuODdxMU94bmVUTDRpakJ1?=
 =?utf-8?Q?pgFliNQXumKEARijBboQo0Snp?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0e7b52-5920-4d5d-e508-08da9130d894
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 00:27:00.6471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H4trgGTo/LxRWtXcXwCnffyZxxFNLD3tsr1CAxs4pxUDIe+cUqTmcfgWG0zwmFmF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3333
X-Proofpoint-GUID: 32wPCAYeTT8RE982LB95hsLpCX0VuBpE
X-Proofpoint-ORIG-GUID: 32wPCAYeTT8RE982LB95hsLpCX0VuBpE
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 9/2/22 7:43 AM, Jens Axboe wrote:
> On 9/2/22 8:34 AM, kernel test robot wrote:
>> Hi Stefan,
>>
>> Thank you for the patch! Yet something to improve:
>>
>> [auto build test ERROR on b90cb1053190353cc30f0fef0ef1f378ccc063c5]
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/Stefan-Roesch/io-uring-btrfs-support-async-buffered-writes/20220902-070208
>> base:   b90cb1053190353cc30f0fef0ef1f378ccc063c5
>> config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220902/202209022236.e41DKuIt-lkp@intel.com/config  )
>> compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
>> reproduce (this is a W=1 build):
>>         # https://github.com/intel-lab-lkp/linux/commit/b24b542d1de60f99e6bfeb7971168c9a9bc8b7e4
>>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>>         git fetch --no-tags linux-review Stefan-Roesch/io-uring-btrfs-support-async-buffered-writes/20220902-070208
>>         git checkout b24b542d1de60f99e6bfeb7971168c9a9bc8b7e4
>>         # save the config file
>>         mkdir build_dir && cp config build_dir/.config
>>         make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash
>>
>> If you fix the issue, kindly add following tag where applicable
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All errors (new ones prefixed by >>, old ones prefixed by <<):
>>
>>>> ERROR: modpost: "balance_dirty_pages_ratelimited_flags" [fs/btrfs/btrfs.ko] undefined!
> 
> Stefan, we need an EXPORT_SYMBOL_GPL() on
> balance_dirty_pages_ratelimited_flags() since it can now be used in a
> modular fashion.
> 

In the new version the function is exported.
