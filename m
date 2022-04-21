Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2E750A85F
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 20:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391540AbiDUSwE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 14:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391539AbiDUSwD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 14:52:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628924C401
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 11:49:13 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23LGmTPR008741;
        Thu, 21 Apr 2022 11:49:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QXsnQUEgQcWOzhfNJmZ0y140pQG1uSS0TT3eX0PcJeU=;
 b=nvbMrphro2k35jVd0T3n4Vu73zPfP/8FUdy270X4zKjoP3n4n3Ymhni7xDA1q4RGLAsH
 Ztkid0pACKcdxAjmp2QWbgeqs58vcnsentwoiuQLggn9hCOtrrANzzT1vz7WkgsRGH8V
 hHwyyJS5zQhuXtXKy4xhTWzDipOKaHtfwF0= 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fj9p24kpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 11:49:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNu0AYB8z11Mgn89wB9yz+nZ/UQv18R+SSeYTSdIyg1BJD/xkPq07BXaB1w0ii+n2UqoUx+qsKqJ1PkbDugATYTXLt4ie1nqfEo157iOK74EChNpYLpFCs199pCNQTv/AxyWSaL86TFzpfFd8YaKlnZbA49EPk3KTo0oLQkN6t5AUrij6IVhreUtehSjJS1GjiFNt4GAaQ2XOANtfuHGRbARh0znGcSY9UtQfxiXydBNzwSSugPe1h1KFgJvF4nInAx5I4CiFlw2Fq99Xbflpmt3jTp1LvyAV9igM4Wpd5xX0LePkY/Co2CzZuMs0VRtxVShJS9luqFWLsRSQZbUlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXsnQUEgQcWOzhfNJmZ0y140pQG1uSS0TT3eX0PcJeU=;
 b=j3oZwv/Rred07S/dytJt6Ry5Nk/r6oigYRkl+kHP3mdWW7QjIJdzFNQ2cLrdLVWdiBTpH5lGu9CqQWuF4LOZILEsMt6Piw8I/VBmTPbMCkRhRU2DYrj8slxys0afPMs7BD9AgsVn61kShG0BJ046UkVNW/k/7NrNKxDTRcGrhKTHjXjnADs339ll2CX2cZ3cYW7feW/RS2U+EcDZ77D0STGAYQR7FcVjzKjot+j9insKkNgx6WzayDBB1a2buY4WPEswjToSaTCnwSYxCfq+O9c5sne+UlwaYq8OkaPVhSsDFFA6NbFE1E2ATqB3A1iYd3WLWEfFZTSuNGCBCmQlXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MW3PR15MB3929.namprd15.prod.outlook.com (2603:10b6:303:4a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 21 Apr
 2022 18:49:09 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::714e:bcb9:8f7:edd2%9]) with mapi id 15.20.5186.014; Thu, 21 Apr 2022
 18:49:09 +0000
Message-ID: <2fa5238c-6617-5053-7661-f2c1a6d70356@fb.com>
Date:   Thu, 21 Apr 2022 11:49:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v2 00/12] add large CQE support for io-uring
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        io-uring@vger.kernel.org
References: <20220420191451.2904439-1-shr@fb.com>
 <165049508483.559887.15785156729960849643.b4-ty@kernel.dk>
 <5676b135-b159-02c3-21f8-9bf25bd4e2c9@gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <5676b135-b159-02c3-21f8-9bf25bd4e2c9@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-ClientProxiedBy: BY5PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::36) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65c050de-f17b-4f4f-fba7-08da23c79ea7
X-MS-TrafficTypeDiagnostic: MW3PR15MB3929:EE_
X-Microsoft-Antispam-PRVS: <MW3PR15MB39290F7F3AF0EA4D9BF7F917D8F49@MW3PR15MB3929.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uaT+vDUDgC6g+izwOcVrztknz+59ZvXzcU/Z49ZBifWcNq6e7KrCAgNAu2m4UR6+B/F2OD2+4D87zxGk408kC746B4PSWDmaTQ8KHdxJ2TZsTLjvVl3mRYt0Fn0L9695swzju6jP/P0/x1aM1fp5CxhZB4WM4lsD/mw/2eeH+syBH7unRScjdbCzP2Sf0pPrWKiaAli3j6H7TVH4rlIYsnMNSDsFkcb+OSxbwBidWIEOdnlLKvBTo8ZHLLP4jitYEDPx5gEE01Ag+P49sfrtXU0zEIdVmitYuPbp8cIDh1xqfr9vNrYXfk/Z0zerr/BQb91x7W4EPZnzidKRYvGFlY3iqD0ccVJi/BxqOLu/bKoZkl7vU29J3es2lSb+8fleNzD8fCHYheat2owSsXuESv956Phi6pntA69NGTIjFeBM+BHYFKZu9GnGOG3TS2fu2zIeg5mKpzKpk/hFtZOewHbAXqENrvJNcv8EoCYM+EKRqNBLpzhQFcBv3qyAIVq8ecblA5xoiVPfa4sl2U/tACS/rn5C3TJRxROob99OhsObaLovH+y9rHgNQWizTbmbqVZqBnN2nkBehPcEBWquFgZp/4JyusREPnd9NPC2wX0WcnzeukpXAsOJw9DgNOqVzD11VWsAGCcw2islfizTXINzYUBH0grR/pA4c5znm1rZWCihYv78yFw6W2jZ9b0SR3/dEcHVHlQq7r50JfxaW+O6nZyYiPdUJGrBjRDvrTGo6yHn9J8NcjyjQCVljo6Uvhu8L0k43FZhA6wjYOFfjwc5XKi+IdQfs0Qr6zjwt5tI0IA7M7cbQ88qgpRrBoRN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(66476007)(66556008)(8676002)(110136005)(66946007)(2616005)(31686004)(6512007)(36756003)(83380400001)(6506007)(53546011)(38100700002)(86362001)(31696002)(2906002)(6666004)(8936002)(316002)(5660300002)(508600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qy9IZ3lEOFN0MVp1RUNreUIxRzJvTzhsQ1JOS3BQdGtHREJldXljb2NtUVZE?=
 =?utf-8?B?d2dRV2hmcmw4Q0hiZGhMVTQxTndtWWR4UXNqZkRXd0ViNjNsdndaSnRxZ3FR?=
 =?utf-8?B?KzlCT1VUamF3WDhUeEMvclF5bWgvTFdETWNsSG1NckE5b2hSZHZ0eFRUcFdG?=
 =?utf-8?B?WnE4Z2VXUG96cFN4RUZmZ2JoOFFGVjNPVXJtU2J1bFBnQjVNeVcxblVUM2Ey?=
 =?utf-8?B?dkkxLy9JeGRIU3RrMHcyRXE0QjlRbW9pbDFPVGZwQkpFOVJqcWVyUDlja29x?=
 =?utf-8?B?cEQ2WFN3akJOM2dTVml1YTBKcktzRGoxNXF1TTMxSVVIK3FuZ1pwK3dXTFRX?=
 =?utf-8?B?YXVaNDVweVdkREFEUlFFT0Vyd05sV0xwVW9FeGZHQnp6ZzQyTWtYV2pFN3RP?=
 =?utf-8?B?ZEdzUVh2bHhSdXRmbzduWm5pSGYwZXdBRjdBRlZpYkVBaitrcVZpZCtYYk80?=
 =?utf-8?B?cVpESnVFT0UyaDdTT2NZN1JPK1RlWmxoZnVMNDdWaU9pTkh3UW1ld28vSGpz?=
 =?utf-8?B?MlNTZTlIajFKbE9EUGM3QTVpL0JFMXNrVVh6TjBDajlNRHhJNmFWREFPc2NK?=
 =?utf-8?B?Sm0vZldUOUg4eTh1VWluNHJqcDhhSDNBOEkzdVBPeXlCbGtOU3RRelVvbkhZ?=
 =?utf-8?B?M2duRUtmcnlxRjBFdEVmM2dHRDVEQnhSWC9XU1JBWmtBLzZTRy9nbVpNQ1BH?=
 =?utf-8?B?NVVET1F1cDZYVGk3WHR1MjUzWHVnZE1TZThzRkdtdjJBaExKcCtSSnJVcEh3?=
 =?utf-8?B?cFNoTDhnRlVVRUswR1dscWZxcm53Y09SRTVhMkdBRHFIQitSY2p6TEFhYmM1?=
 =?utf-8?B?ZFYvS3NmNVJYcVgyRExWaXZnYys1UTdYWnJJQ0J5ekFkT3MwcmtzaThBUDRP?=
 =?utf-8?B?Z3lmTklLRmZNVmk3TEhnS0Q5T3ZwUStobmtYS0xSUFNxWGlUTVdUaGRyUE1T?=
 =?utf-8?B?bDlERW5wbitlbE5sNUNhWlM1SzBjNFQ2cXgzYWxiNXRnOG9PWENJN1dWRkRP?=
 =?utf-8?B?NjVPNDhrNFNBUHJFNmljUit6WXV2K0RjTEFhV0ZkMUwvVmlKYmx0RkVXMS9I?=
 =?utf-8?B?L0hpcjh4Q0pBMktydTI2bjJJTzJkL1p3WWM5aVl6SzZmOEhvZG9lY0FuUUZQ?=
 =?utf-8?B?V1pmQ0NNUUFiNm91UTNITFFQTkpLQmQyU2ZxMzdRQlNRMFVEOGplQXU2amMv?=
 =?utf-8?B?RStEQkc0UjdCVlI3dk84MVZjRU16clFvKzdoUXhlR29MbjZ6cnk3V0lyemFs?=
 =?utf-8?B?bm9UQmpra1JaQTd5ZzdZVVk4c3ZvUFhsOHBtaVJXcmYyU29zdGtpSXZkSkRz?=
 =?utf-8?B?YUgydHI4TjgxVmluVTNWWWVONlVkSENKaHpKY3VKdWdqdktLaUk0MHRaYnBI?=
 =?utf-8?B?QXd0b2YyS1EzZ2V2OUMyWU92WHJXMXJQTFl1bXZiWng1UXpRWDRVOEdRNmxz?=
 =?utf-8?B?M2EwZXFtS0taVldmUHRQRHYxWXNJZUNmbzJpbG5Wd2U2MTU2ejZ6SmpFa0k3?=
 =?utf-8?B?eEd1NmpLcmZ4VzM2clhYQTFKbGhCV2d6b0d3OEJQcHJkbHZYN2h6RGYwTisy?=
 =?utf-8?B?d3dpa3lTaFQ4SE15aGpNc2xiRlRBcHAzVEFZMjc1SVFVdGxuM3F0YWozeWFo?=
 =?utf-8?B?OXRhV2tRQVMyNTg1WHdQS0lOUm40aXBRUU5HaGRmZ3hoWldlVXQ5RHU2N3ND?=
 =?utf-8?B?TFMvV2JYS3d1R1Bua2prSkp2a3VnSkQ3cVhYdytYTURJNmVnM29kMHM3Tkgr?=
 =?utf-8?B?VG1uOUFwZDVBTEpkcW92cnRLZkFabnR4bDc1RWNxajQ5bkxtMlhWcWFRNDI0?=
 =?utf-8?B?aEU4SzRRWWY5UUVQQXl5OExTbW5yMlpiNVBVQThmOUN3dTNmSjN3Qi9Fc0F2?=
 =?utf-8?B?cm4zZ080N0tBN3Q5YmpXNVJhQm4xcFRnK0xWWmhKM1ZFczlRUUlTQngyTVYx?=
 =?utf-8?B?dmJxUDVaT3R1UWY1THJVbk5BMUVDMGdCcmZmTHZXMENhKzB5bDhENlRqL21x?=
 =?utf-8?B?NUN5MnVrVi9nb3B1QXdQd2JHSVlBU2o5eDF5MmU4SVJmaEhlV3RHOFpnTmxF?=
 =?utf-8?B?dmJsTm5lK1Jzb3lnNW1RY2pLZ1VGdHRKYlhqTVpoRDM4RVh3emR2Z2xnYy9h?=
 =?utf-8?B?c3hkRnV6M1dGa3ByNjlkWDlUb1RnR1h5SDNzd0VIaURXK0pvZGdabnJveUJw?=
 =?utf-8?B?WXY3ajI1SUFjRnNvYUVIVnAxdGd6YzZ5cnhIZjE4OW95eXhIOGlocHM2U2Np?=
 =?utf-8?B?U25QNkdPQVhqR05aN05RNXVRVW5wOFhhSXRybDdWbGpvaWs4TVlKTExRYTZI?=
 =?utf-8?B?amxPLzZyM1RiWDVoWm5SVVZZc1MvM01tbnBaa0YybWE0MGR2MW1oeWwxVTBQ?=
 =?utf-8?Q?jdIaoVNnKF2V/Bfg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c050de-f17b-4f4f-fba7-08da23c79ea7
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 18:49:09.5494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SC91pjcDmqIcqbQI0iEea/SjUKHsd6Sc2ZcqOyoUPtT6JcFM90SVeUBiLyubBMpd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3929
X-Proofpoint-ORIG-GUID: CO6MToqZU7jTuQnMw5sid9mKMIBRODZL
X-Proofpoint-GUID: CO6MToqZU7jTuQnMw5sid9mKMIBRODZL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-21_04,2022-04-21_01,2022-02-23_01
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 4/21/22 11:42 AM, Pavel Begunkov wrote:
> On 4/20/22 23:51, Jens Axboe wrote:
>> On Wed, 20 Apr 2022 12:14:39 -0700, Stefan Roesch wrote:
>>> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
>>> To support the longer CQE's the allocation part is changed and when the CQE is
>>> accessed.
>>>
>>> The allocation of the large CQE's is twice as big, so the allocation size is
>>> doubled. The ring size calculation needs to take this into account.
> 
> I'm missing something here, do we have a user for it apart
> from no-op requests?
> 

Pavel, what started this work is the patch series "io_uring passthru over nvme" from samsung.
(https://lore.kernel.org/io-uring/20220308152105.309618-1-joshi.k@samsung.com/)

They will use the large SQE and CQE support.

> 
>> Applied, thanks!
>>
>> [01/12] io_uring: support CQE32 in io_uring_cqe
>>          commit: be428af6b204c2b366dd8b838bea87d1d4d9f2bd
>> [02/12] io_uring: wire up inline completion path for CQE32
>>          commit: 8fc4fbc38db6538056498c88f606f958fbb24bfd
>> [03/12] io_uring: change ring size calculation for CQE32
>>          commit: d09d3b8f2986899ff8f535c91d95c137b03595ec
>> [04/12] io_uring: add CQE32 setup processing
>>          commit: a81124f0283879a7c5e77c0def9c725e84e79cb1
>> [05/12] io_uring: add CQE32 completion processing
>>          commit: c7050dfe60c484f9084e57c2b1c88b8ab1f8a06d
>> [06/12] io_uring: modify io_get_cqe for CQE32
>>          commit: f23855c3511dffa54069c9a0ed513b79bec39938
>> [07/12] io_uring: flush completions for CQE32
>>          commit: 8a5be11b11449a412ef89c46a05e9bbeeab6652d
>> [08/12] io_uring: overflow processing for CQE32
>>          commit: 2f1bbef557e9b174361ecd2f7c59b683bbca4464
>> [09/12] io_uring: add tracing for additional CQE32 fields
>>          commit: b4df41b44f8f358f86533148aa0e56b27bca47d6
>> [10/12] io_uring: support CQE32 in /proc info
>>          commit: 9d1b8d722dc06b9ab96db6e2bb967187c6185727
>> [11/12] io_uring: enable CQE32
>>          commit: cae6c1bdf9704dee2d3c7803c36ef73ada19e238
>> [12/12] io_uring: support CQE32 for nop operation
>>          commit: 460527265a0a6aa5107a7e4e4640f8d4b2088455
>>
>> Best regards,
> 
