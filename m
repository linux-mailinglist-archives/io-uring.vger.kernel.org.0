Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57935B25D0
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 20:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiIHSdv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 14:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiIHSdt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 14:33:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32C7F22CD;
        Thu,  8 Sep 2022 11:33:47 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 288IJ8KL019918;
        Thu, 8 Sep 2022 11:33:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=l/nHA+VmiWviEqsaL2iKhKxR27g/BcydhTNJ68Z7bpo=;
 b=PbDgTJ/KSEnyGfXH+fOPxKGGTAIPkN5YlB/aZ6KeIew5xQ5mnxi8EyDnMLmTQZRiqoBz
 o4gKc2DvxWf4IAqoTMTJMKjzOU4weBEozRirQTRZpcaRbWN3g1SP3X/qi90IrjCmyVw/
 9amh7wQQmPcjDPBXxqCpS4GuVA1BMhhgQ7g= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jevdaj0p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 11:33:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiIwnQfBN2QzA+m0deCac2i4TRIb3czuFZ6sxFGN0P/rtzwO9ftORPoTT7ecQVIpliarMEVs8kzkrIb2Af0QZh3dZOAldgEEfFDQDspGdmgvaTMR3tdqXzh3Sz65T7gqKHTr4pBgCR4xitiF2tiyr5/okRoQbNYLwuIdCPG+cwv8W/RUVKcKcf672CuMxGS+ls8/0jvW7keMG7+jxtAbBJFea5/wEi13T9bKySanzcrLtNrxfBsOofd6BsFs4aWt3EJvWsFmHc3U3cuNAr/wnmNXiCMYovG1ty8guBdXUeEhe4/G0CGRQhMUzQzInGNh9qHLsYMfGpVETMCbqrmDGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nUvvn96bD/roa0JaKPRr6MfhRt1TJH6+qVHDal3KM3o=;
 b=IAtoASuuWhAWsQrHvcDmrs6uiBc4g2eh6fQJ+odmnkmsy5BOQNKfdmsaXiBiE0BwACRubGOUQkvofIx9S+cKdnvHgURsUbVIJT3GgytWsRggR5BipidStsoqVjI/HBuF0OgSc0hSFZYoo2weMd4hZGvgsRtVVfUiEx9XrZbHol8dU/s2oPAU1VFyIlkqujuX8oUdXtLdT/ipMGG7KPNaGbpWJ6aH88k69PC7R+TUiV24KeBljb78f2HclF8lvp54RqExVhSDE72hHIt3jDUqnARdEbvnj+l2yk8D6BK7k8a05o3MkMTZZQmmFrTYPgv8x2qudGlMdBGtJivhhE38uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) by
 SN6PR1501MB1984.namprd15.prod.outlook.com (2603:10b6:805:f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 18:33:37 +0000
Received: from DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae]) by DM6PR15MB2316.namprd15.prod.outlook.com
 ([fe80::c052:c6b9:41f8:e5ae%3]) with mapi id 15.20.5612.014; Thu, 8 Sep 2022
 18:33:37 +0000
Message-ID: <53c625e9-5dc0-5fc6-c30c-7483bcc468a7@fb.com>
Date:   Thu, 8 Sep 2022 11:33:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v2 07/12] btrfs: make prepare_pages nowait compatible
Content-Language: en-US
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
References: <20220908002616.3189675-1-shr@fb.com>
 <20220908002616.3189675-8-shr@fb.com>
 <CAL3q7H77thY5_1zMiwVZ8oBk3b4KwFUsff=DojUSgJdAMP-2DQ@mail.gmail.com>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <CAL3q7H77thY5_1zMiwVZ8oBk3b4KwFUsff=DojUSgJdAMP-2DQ@mail.gmail.com>
X-ClientProxiedBy: BYAPR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:a03:100::36) To DM6PR15MB2316.namprd15.prod.outlook.com
 (2603:10b6:5:8d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:EE_|SN6PR1501MB1984:EE_
X-MS-Office365-Filtering-Correlation-Id: 7546d956-9b60-4fd9-66d3-08da91c8a49a
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JW8Kr9Ds4iSXTAXnnEybmdLPOM6FMawVpzGNpnkri1Br/OdenViE8l0zVcRMAtqYmTvaVB9VGg5uX2R3lWex3pkBq58PIrujGz6Jw8kBDXOVWnLBI6mImywIY+WqShF2GS1vHzU+zFAW+/KQ0Yk527I+I3ghJBFZd3TbifRYA7TR1gSQWGkWOap/oz55egnXBBCGRjmH0Lfo0g+lPlLY3XCxtaW4JxhQSOZ3v5FlqA1nd7bxCn47pcjzicCsJIZVJ1ojIFunj4zM6dSf04t7m72985LHonRhBzuBHomDNClxzzXAu+d/zJceR4HrE791us9bAId/sKykT+STdnPVaTnjccebAawkCY4Bj9PYysg+rr4d1wd6lZyl9Gxa8hPf/ipvpBdCDVs0N0hDHatCkdbw7wHZHXzrj2wE9h5icgbrHp5E9Qt57nQgjIxv3OyrZilZejtisrluUu/aN717mbIODTRdlP5FWl2ToJvAkoCNwnyAAZ3OCZiIjtGzWqtZclNfPk1b+wamYZtt1M5f4ewVHOFY/ENeQ4gu4jGHCmL4kxWdkfz/yq5zZMQ6PhJ+gUAIHP8iybriIZYjXSQKVYub1P81PdZ9MGQkvgqHLS5XhOeClEAnEYifyo+Z1EN94msOMwfFAggrSE/xr0B0lDqA1CtrLzk31rl9jUNJ911jiSjtZxY/zL5S1LDNrfYUTkmz+bOJ/+sGooWLKf8kQ6BAWpwCArtUxmZrrT4P1oFFc1WrX+hQRRzqirmdU2WQVG02ThozrpdsprtoncGpFpLBvVVm5ez39OZSknjseD4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2316.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(38100700002)(86362001)(6666004)(478600001)(4326008)(66556008)(66946007)(8676002)(66476007)(8936002)(5660300002)(41300700001)(31696002)(6916009)(316002)(186003)(83380400001)(53546011)(6512007)(2906002)(2616005)(6506007)(31686004)(6486002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFpOcG5IelNzK1Q2MGdzUmRkNFgxa1hxaWZacmkxQlAvdVFKLzF5L0xNMkhm?=
 =?utf-8?B?cjdKT2ttV0Q1eTd2QWJNakRod3d3Y2pjaWdyNjlXa1pJcWRSaE5zOGNVdld6?=
 =?utf-8?B?UWgrWW5mcDhIM0tKZjU0SlR0TlIrZnJlMlpFeStFM05ON2JnV0F3dHI1dVo5?=
 =?utf-8?B?em9jTVc2b2FIaFF3YlA3THFRRWd5MEJpc1B0dmQxU3YzOTBTUWZrZFRHeTNv?=
 =?utf-8?B?SENPVHJiNG5mRm84c2JlVDZ4TXhkZHMzRTNMRExNQ2ZLckt1TWNNQkloREx2?=
 =?utf-8?B?SkFWVjVwZExocU1jOEVFOUlGQ2NTWlBZVXlaWTZUZG5wYjZKMUNrZXc4UklF?=
 =?utf-8?B?cWM3K3ZEaUZnSVRDM3Q1akpWTWdBMElTZmJsajJCZWEydE81TWZqS0tqL3Nw?=
 =?utf-8?B?dnc3OHpESjMvQjluUzZwM2dCQ3hscWx6b0g0bXA2eWhFZzE0emdnMmxVTElZ?=
 =?utf-8?B?WFRHRWdmd01lTnVPOVNvaHNaMWVYT1YwZ1ZyQWV2dCs3TUt0WTJLYWlaZS90?=
 =?utf-8?B?OGFHMmN3WXRoUVVhTDJrTFM5OFZ4MjNzZTJkcUMyV0o2ZE00UCs3Sm5ybUNh?=
 =?utf-8?B?TzNpdXhpNzZqUVhCMmFIMm02WnNZR1VaNGphMUw3WmVPYjhNaC9BMGhEWExF?=
 =?utf-8?B?UURyVWdvbUF1YzJhaExPOTVKTlZmNjNvMElJVHkzNDFmQkdYZVhGak9PVFRF?=
 =?utf-8?B?aHVhNHpKU2RWWS9la244dWVqd2gxV3BtNmFBQXFOS0hrZUN6ZnB3RjFoSUls?=
 =?utf-8?B?YXZiUmV0bEZWblBRVmNrUFRFOEd5QVRTRnVoK3FCU2NyUzFadGZhRWo2RWVh?=
 =?utf-8?B?aXBublNZRzRSTktRYXAyK1BDY2lHaEFQWkhjUEZiSHZxRDUvWFBpYUV0S1J4?=
 =?utf-8?B?NVliay9rQTRCSnp4SUJnRzI3bWs2Rkt4TWw2RHBEWGx3cFRiV1FlU3pPQkZt?=
 =?utf-8?B?SjdjbUdqZ1ZwTk80cjFQUXJKSnBOSW96Q2Fqb2xWbTdETlZCaUd4TmJhV0F1?=
 =?utf-8?B?cWJrbzNsZ1RmQjZJRUozZi9lT2E1UGFjZUF3MWJSTjd5UmtwMWVNRDVuOGpo?=
 =?utf-8?B?SllaM0diaVdmNXdodDkrUlJwK0F2aEhNMzdPUmtNbFovd0V4NlBSczBNT0xk?=
 =?utf-8?B?SWlyRVFxS0NoSTNSL25oeG4ydnJrRlBMdmlCaVkvbEE4VytGZjQ2dVRycDhC?=
 =?utf-8?B?YVN5SEVxclBHVnM3M3dpOFFlMnJOa2c0TEQ0WVN1dXp3bDBDS2FabnRnRWVR?=
 =?utf-8?B?bUxiRGhqa3FhcTVOZVFZdk9LTFUwMHFidmRXUDNwZ2NvMlhhVURpMCtpeVIx?=
 =?utf-8?B?OE9UaEJqVUVOeEpGendpdWF1ZEJ0ZmVibWp5NVFIL1NYalhxMFFVTUM0MlZ1?=
 =?utf-8?B?UXQ4QzZCM0l0cFFTci9KTllzdW5VclRRcHdPNGxUdkRFSmJyUStmTUdWQTdS?=
 =?utf-8?B?NjNLSGR3cmVKNHlNdFdLSE9ISWxPbmpYQ0I0bnpwVkVnaE9rZklBUnpKQ3po?=
 =?utf-8?B?SHRwS05zQmIyVk1WQkgxWEtGVnc1elV4UENHZHJheDhFekpRVk4vUk95QmVr?=
 =?utf-8?B?TVJUQ0JDa2JqTUJmcmZ5TnhEcXkwaGhvcGtJWjNlWmtrTURMeHB3QnpUckE4?=
 =?utf-8?B?bkdSNFppeHp3WTFsVFdxODV4Q05hblZ3eFd2UXd3Um8zNDRMa3pXTDh2ZWQr?=
 =?utf-8?B?ZU4rUW1YTDBkSjZBbVBwMUdzT3JleVcxWEY2TVFPZkRjMXYvc01EZUk5ejlS?=
 =?utf-8?B?NVdvUjhNU3UvNTZwYWtXMDFPS05ocVNUSnkwWk1uMnoxczBzTDAxN0VCNU1Q?=
 =?utf-8?B?Y2RoRlF6ZFd3SXlVbUcvUElISXdWZzBnZnl4M3FEMlVLZDNzT1VtRDhuemJh?=
 =?utf-8?B?U3NZUzRYY2l6TWN5QkRINFcvRm4xNjI4NlRRQmJub3ZFL1ZHc05oeVNoVERs?=
 =?utf-8?B?TC9IZGlhQ0RjbWZ2UVFQMzRkenJkaFpDVVFSRTJnSjFWRTBadGZpRHc1NFZa?=
 =?utf-8?B?NXJ0Z3JoQWpGYkJDL1hJR24xbTEwemRIYmFvYk1WRk00ZGdHUGxTRTU3bEVT?=
 =?utf-8?B?OUgrN0tBNUgzNkpCazFXSE1McHRMUDlFMDQxWk1BNDRZM3FWY2laZ0tNWlZ3?=
 =?utf-8?Q?dVXjZiZ0+ZkQNaUpV8AvccLw1?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7546d956-9b60-4fd9-66d3-08da91c8a49a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2316.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:33:36.8821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/lMFDRYv8UBEjnY7NqPYbrgcv7lFI5Ds+LOtyqpXgKWAdXo6v3AfDjoH9/fs7j9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB1984
X-Proofpoint-GUID: H2Cm_e5tMqf5RcqrWbZwSPXgmKk0bDFW
X-Proofpoint-ORIG-GUID: H2Cm_e5tMqf5RcqrWbZwSPXgmKk0bDFW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_10,2022-09-08_01,2022-06-22_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 9/8/22 3:17 AM, Filipe Manana wrote:
> >=20
> On Thu, Sep 8, 2022 at 1:26 AM Stefan Roesch <shr@fb.com> wrote:
>>
>> Add nowait parameter to the prepare_pages function. In case nowait is
>> specified for an async buffered write request, do a nowait allocation or
>> return -EAGAIN.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> ---
>>  fs/btrfs/file.c | 43 ++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 36 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index cf19d381ead6..a154a3cec44b 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -1339,26 +1339,55 @@ static int prepare_uptodate_page(struct inode *i=
node,
>>         return 0;
>>  }
>>
>> +static int get_prepare_fgp_flags(bool nowait)
>> +{
>> +       int fgp_flags;
>> +
>> +       fgp_flags =3D FGP_LOCK|FGP_ACCESSED|FGP_CREAT;
>=20
> Please follow the existing code style and add a space before and after
> each bitwise or operator.
> Not only does it conform to the btrfs style, it's also easier to read.
>=20
> The assignment could also be done when declaring the variable, since
> it's short and simple.
>=20
> Thanks.

I added the space and moved the assignment to the definition.
>=20
>> +       if (nowait)
>> +               fgp_flags |=3D FGP_NOWAIT;
>> +
>> +       return fgp_flags;
>> +}
>> +
>> +static gfp_t get_prepare_gfp_flags(struct inode *inode, bool nowait)
>> +{
>> +       gfp_t gfp;
>> +
>> +       gfp =3D btrfs_alloc_write_mask(inode->i_mapping);
>> +       if (nowait) {
>> +               gfp &=3D ~__GFP_DIRECT_RECLAIM;
>> +               gfp |=3D GFP_NOWAIT;
>> +       }
>> +
>> +       return gfp;
>> +}
>> +
>>  /*
>>   * this just gets pages into the page cache and locks them down.
>>   */
>>  static noinline int prepare_pages(struct inode *inode, struct page **pa=
ges,
>>                                   size_t num_pages, loff_t pos,
>> -                                 size_t write_bytes, bool force_uptodat=
e)
>> +                                 size_t write_bytes, bool force_uptodat=
e,
>> +                                 bool nowait)
>>  {
>>         int i;
>>         unsigned long index =3D pos >> PAGE_SHIFT;
>> -       gfp_t mask =3D btrfs_alloc_write_mask(inode->i_mapping);
>> +       gfp_t mask =3D get_prepare_gfp_flags(inode, nowait);
>> +       int fgp_flags =3D get_prepare_fgp_flags(nowait);
>>         int err =3D 0;
>>         int faili;
>>
>>         for (i =3D 0; i < num_pages; i++) {
>>  again:
>> -               pages[i] =3D find_or_create_page(inode->i_mapping, index=
 + i,
>> -                                              mask | __GFP_WRITE);
>> +               pages[i] =3D pagecache_get_page(inode->i_mapping, index =
+ i,
>> +                                       fgp_flags, mask | __GFP_WRITE);
>>                 if (!pages[i]) {
>>                         faili =3D i - 1;
>> -                       err =3D -ENOMEM;
>> +                       if (nowait)
>> +                               err =3D -EAGAIN;
>> +                       else
>> +                               err =3D -ENOMEM;
>>                         goto fail;
>>                 }
>>
>> @@ -1376,7 +1405,7 @@ static noinline int prepare_pages(struct inode *in=
ode, struct page **pages,
>>                                                     pos + write_bytes, f=
alse);
>>                 if (err) {
>>                         put_page(pages[i]);
>> -                       if (err =3D=3D -EAGAIN) {
>> +                       if (!nowait && err =3D=3D -EAGAIN) {
>>                                 err =3D 0;
>>                                 goto again;
>>                         }
>> @@ -1716,7 +1745,7 @@ static noinline ssize_t btrfs_buffered_write(struc=
t kiocb *iocb,
>>                  */
>>                 ret =3D prepare_pages(inode, pages, num_pages,
>>                                     pos, write_bytes,
>> -                                   force_page_uptodate);
>> +                                   force_page_uptodate, false);
>>                 if (ret) {
>>                         btrfs_delalloc_release_extents(BTRFS_I(inode),
>>                                                        reserve_bytes);
>> --
>> 2.30.2
>>
