Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE353ECA7F
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 20:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhHOSCp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 14:02:45 -0400
Received: from mail-co1nam11on2056.outbound.protection.outlook.com ([40.107.220.56]:49857
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229456AbhHOSCo (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 15 Aug 2021 14:02:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhOSWE1vCe4BEWt/85U0OscbLLwQia0cQs8H3VA/eU742lGLRiVu+qbEb+9n4jiOMqZTGS/0W74e26UN5djzwymfl21mit4SsynzI24UPTCURGKGVRaml8mo5qn+omBw8XdSrSJndGbPmUUyoudV6BafPaqpuXD7M2P/1LaN2Oj0JLPTgHZwPyw7kJHoY1sp8BVB8v76ejyNv5QyMPZwNqgAVerPMmEtrE9RQHuJZ94MXCSruc9teY3HstGaMwsMI5PcV9nLwpDCGKYq0yDwAQWDt9akXoN+bxlSho+0i0w8GXfdaLdrkK5frjQjvz7TCR55TR8+9L05CBXOseOM9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMNU92ZsQCLBRJFqPg38QyfzALON2gRsRwalgayi3ec=;
 b=EeiSPoOFu9ZpNX2P8hR+Gag6VGcCE8AaAVuDKDBVbtbCzEHurOrMati7OS180/wCO1C8UgxUPmNG6HcCZgvvOOc+jm+P159pwcc5OsQlrGnOO6EHiEbSOYFJAu4Q+70QeHa03vbM3smxz5yx9e+StsvI1fuk7mRDpCmlbV0WcqI0g0GBaBHdJonFyEtYPBYE63QlOQqwGZKjCM0PvXTT0xZ/Pn+Bfzh0pHY/oA4JcexbFF0Qe3bUi7aHBt5glCQ4SCpMhyu6hemE7xGRLwJMcFrT2x3P3QVReH1HFVyBytynQWf9WZyNMZFZpcTYaCHXXdPSw2KDHaFU8d4TIlG1UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LMNU92ZsQCLBRJFqPg38QyfzALON2gRsRwalgayi3ec=;
 b=DpO94KBSETddPOXPLajwgu9PWCSjXW2fSShGbEqtchBxkezXvLdlMg7AqjNR2h07czAcf5zcZjxfQi80zlDhPxXbPhWXtwwab1HnNdrAvQnSWgObSe2c/YO+y7t4uAr6J8lwdYHmpcRetQSv7qOzRRx+AIIlgzVCXI8TePDR5aE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by BL0PR12MB4946.namprd12.prod.outlook.com (2603:10b6:208:1c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Sun, 15 Aug
 2021 18:02:07 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::dce2:96e5:aba2:66fe]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::dce2:96e5:aba2:66fe%6]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 18:02:07 +0000
Subject: Re: IIO, dmabuf, io_uring
To:     Paul Cercueil <paul@crapouillou.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-iio@vger.kernel.org, io-uring@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Alexandru Ardelean <ardeleanalex@gmail.com>
References: <2H0SXQ.2KIK2PBVRFWH2@crapouillou.net>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <b0a336c0-ae2f-e77f-3c5f-51fdb3fc51fe@amd.com>
Date:   Sun, 15 Aug 2021 20:02:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <2H0SXQ.2KIK2PBVRFWH2@crapouillou.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: PR0P264CA0196.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::16) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:c441:ec36:14e0:c923] (2a02:908:1252:fb60:c441:ec36:14e0:c923) by PR0P264CA0196.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sun, 15 Aug 2021 18:02:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ceaa517-4bd3-4245-bde3-08d96016cbc5
X-MS-TrafficTypeDiagnostic: BL0PR12MB4946:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4946C6FC61A9139AC4E691A683FC9@BL0PR12MB4946.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GkU1EWhRFxXQt9nFiHwpR6gVHV1uPY5gMPOhhf9BuVGTQRNJs0LRxjD2Zz6UT0g9c65fbJzXuTL+ScitS1lJx2qbhgNrVgywqoayk0LpzzeYwKVH+Ji/laZjNBgCoL4/p4TcG5csRlL5fLfmGGP0wrNZAyrqDjQa6+ADiTbQHurySdxKVbuNWUoudh5aa/GlDYUI1q9QL+iOa8HllUzkVpHREb5I68D7/je0S1EU2t7PiUqSdno4LiXsWG457Vts/J0wFGjFMhqxe27jxHjRYTcZde4ihwWtnsoyExrHwLCxaYK/619mwPf7moHg1AXw03AmmMngENDyykarp3VfRFfauYfJ3/tKIcEk2ha9jKi4bihphrosLfSO3Luggj/uX9XPEKqodxZOQmqOJSJ0o3TzZ6j9tRgAtuuAYtixUrJDks7Hqln15AUvjNG/quHFJxZ7+ODSPWutRMk25zmsimZQmpwGOfdpct1ZEJcsYcV4DeKS5zRHg3J552SUvkZRAJma+DYHW8PO3VcVUvGziyk9hNkSMo+S03Am3AJl1Ftkd5Nns1nIdJCOrQR5T/Judjx3OCEJaBd2i0VdcGfS93nnXFN9pMYGjCi01nM2/QlDX25UGK+s/VafAdcoNbQHFfVS05Yi6HBwA+798Dnx/S2uXEuY5qfJhzW0M9yebNqgV4y56BGu4OI5YnPp1/FCW6iKyA5TKuxMOPuxcZoEXawezhsqSx3Cvcu/SlWgwUJRpZwzr9dPLK0PdyYyN7uBAlzGNc9PiVBCm26Fwf1uboLsd1CK41ZZtIK7KM/Xcx9vXrKoFmCgJKIy958cR+gT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(8676002)(110136005)(31686004)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(5660300002)(7416002)(38100700002)(316002)(31696002)(2906002)(83380400001)(2616005)(36756003)(6666004)(186003)(6486002)(478600001)(86362001)(45080400002)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEYyZWh2WUtHWmxlTVJHQXFJWTk4SmxRL0NQZzFmUHdZWUsxTm96aGNKSXM0?=
 =?utf-8?B?ZW9tbUlpMVBKdEc0cVJyaFNBbG8wUVhOdGhWL1VocmIrSG1VYlVPVUhhSkJj?=
 =?utf-8?B?YlhtdW1hQy9pUldEV0o1NkFZOVNPZTBMUFhOY25MeVFLVVJyMzBHcUdaaWVS?=
 =?utf-8?B?ZkNQclJNL2oxdTFzNS9JN29QOTFNNXRoNmYzcHlmNnE2eldQU2ZmZGt1RTU5?=
 =?utf-8?B?WWZwTkc1MVdCVmRWVUsvU3JmbWhqOHd0NFp4L0J2cUlBN3FiQUJ0QWFuUjZy?=
 =?utf-8?B?RUVQbHZyaDhSY1phcFFnV0o1b3hIczNpRGh6QlRrRUpXR25RV2dBa0NLcE1j?=
 =?utf-8?B?K2tJWHVlcFM1T3A1S1Fvc3VUeVVaRDh5dlJjWXRMYzN3YUYwWW4rSzV3M0hs?=
 =?utf-8?B?cjcwSmxZdUxFKzNsbzdrSU1LbUZqTGwvd3dpM0ROVCs4dE5HS1hsVmtVQkxx?=
 =?utf-8?B?R1g3QlQ2dTlFZmtJVGZMQkxIV1IzMzE2RjAzQTM1Zy9rbDAxYXJJYTlXeTQz?=
 =?utf-8?B?U1JMdHhSdGdvRXN2TGFPRFRCSExkZUxNbDZNb1J4czFtSW9YQW94N1VIWmVR?=
 =?utf-8?B?WFVEYklnc0ZFdTQrWjhoeStiMEI2VnR5M1MyTDlwNWowUjAzdGFiVTBrU0lX?=
 =?utf-8?B?R1duT0ducjJ5TTJJa2dTMld2NDM3VWtQck5GTWkxNXFFMVVRd0VHdUpzSUdo?=
 =?utf-8?B?cDZYZ2h4MjBhLzlwdVhXS2hoaXdmMDFOUkZvUUUvODRCVjFDN2tlYXJnWE5F?=
 =?utf-8?B?b1g4d2pBYmgyVnJFQitUMnZBUUVxMysrdVFIVHVBakpQUjlsOVo2Y080dmhn?=
 =?utf-8?B?T1BXMk05SUZhRnIrbDFTaEtCVWxaV3Irc05ldFZtWDgrNGlMLzRNUEU2SUY5?=
 =?utf-8?B?UzBWUFZ1c255bFhIU1FZSFAyVzRaVUVTYWV6TkllNERRWDFpcE9lSnNTWHhF?=
 =?utf-8?B?M1lpVC9paTBCR05LdnhVcGY3UGQ4bndiMVYxaHBVeTE1U0ZxNkRtampHbDNB?=
 =?utf-8?B?WGhkYnBoazB5Mkhqc2tSVXNLU1BHVnd6YnBER0d1SmFSK1hJSER3dHdkV2xl?=
 =?utf-8?B?cUJWQXgvODB6NUdFYWRWVFhpdHZyZWNGeG5ZUGdEQS9ZYU4xZCtHTllBcDhV?=
 =?utf-8?B?elJza2VBZGlidGRJc2RvWitwenVwV1lIaFA5QllpM3hSaDhjVFJnUXhCVmxW?=
 =?utf-8?B?eHBEVU5DcEs3VVNmUTNMR0R0RmYyUVlmU0NNcWFoNm1XLzFGMXp6RkJxSDVO?=
 =?utf-8?B?dGt0NWxUd3JjdDFwUk05MWVJQVlzOGZmN1V0S01lQVJBcmwwSTBIeHBVMjNB?=
 =?utf-8?B?NjF6RVRPWDcvOTE4ZzNDYXRNWHlmMHIxUGlxSHRkd0lMejJ4SVR3UTg5Nmc5?=
 =?utf-8?B?eGhSZlhIWGxtR1NlcFJiNDczVjhRUXJOSUhpeDkrRzRtdDVub092dGEwUHpZ?=
 =?utf-8?B?SXZ1ZEFPT1F1NFlLNXF2YzNLRE0ydU91SnNBZ1Y2WFZnOVptbWIvdDBpM0Zo?=
 =?utf-8?B?S092c0lRRHd6c0FIcjlFTmdNZmZmcmV1NUJXU0ExYU1mODVJamNIbzVQTUN1?=
 =?utf-8?B?WmIvNXNNRXZNbjJqV1JqTFV3V0VxT3M0YnBueVF1UWFENkhOait5QkFjRXZY?=
 =?utf-8?B?d0ZYN2RnczNJSERhS2l1S1RmcE9rYytYQTlTYUtlWWpWU01NNWNlS2Mrb3VC?=
 =?utf-8?B?c1FzUkFiWHNjT25HSld0TnQ3eFh1Qm5SSTdXMWlpK1pTdXZzVjdNem1RSDFZ?=
 =?utf-8?B?NjdJYnRWNlYyM0c1ZE9qcktOdW1GSGkwZTd1RW5rN1dIMnNPOXVpSHNaQ2My?=
 =?utf-8?B?T2k3QnFVQ1duWWVCVC9FaGZPNDJOMEw1NU4rU0FNWU1OVmRocjBOekVNd0xL?=
 =?utf-8?Q?VHGkcUgiPgQ0z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ceaa517-4bd3-4245-bde3-08d96016cbc5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 18:02:07.5206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4TS4Gi0vORuwAEPFETgHqjvZZzZ1aWLyIRC4alduaGEX2imow77W0urCoN3kzY8T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4946
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Paul,

Am 13.08.21 um 13:41 schrieb Paul Cercueil:
> Hi,
>
> A few months ago we (ADI) tried to upstream the interface we use with 
> our high-speed ADCs and DACs. It is a system with custom ioctls on the 
> iio device node to dequeue and enqueue buffers (allocated with 
> dma_alloc_coherent), that can then be mmap'd by userspace 
> applications. Anyway, it was ultimately denied entry [1]; this API was 
> okay in ~2014 when it was designed but it feels like re-inventing the 
> wheel in 2021.
>
> Back to the drawing table, and we'd like to design something that we 
> can actually upstream. This high-speed interface looks awfully similar 
> to DMABUF, so we may try to implement a DMABUF interface for IIO, 
> unless someone has a better idea.

Yeah, that sounds a lot like a DMABUF use case.

>
> Our first usecase is, we want userspace applications to be able to 
> dequeue buffers of samples (from ADCs), and/or enqueue buffers of 
> samples (for DACs), and to be able to manipulate them (mmapped 
> buffers). With a DMABUF interface, I guess the userspace application 
> would dequeue a dma buffer from the driver, mmap it, read/write the 
> data, unmap it, then enqueue it to the IIO driver again so that it can 
> be disposed of. Does that sound sane?

Well it's pretty close. Doing the map/unmap dance all the time is 
usually a bad idea since flushing the CPU TLB all the time totally kills 
your performance.

What you do instead is to implement the CPU synchronize callbacks in 
your DMA-BUF implementation and flush caches as necessary.

>
> Our second usecase is - and that's where things get tricky - to be 
> able to stream the samples to another computer for processing, over 
> Ethernet or USB. Our typical setup is a high-speed ADC/DAC on a dev 
> board with a FPGA and a weak soft-core or low-power CPU; processing 
> the data in-situ is not an option. Copying the data from one buffer to 
> another is not an option either (way too slow), so we absolutely want 
> zero-copy.
>
> Usual userspace zero-copy techniques (vmsplice+splice, MSG_ZEROCOPY 
> etc) don't really work with mmapped kernel buffers allocated for DMA 
> [2] and/or have a huge overhead, so the way I see it, we would also 
> need DMABUF support in both the Ethernet stack and USB (functionfs) 
> stack. However, as far as I understood, DMABUF is mostly a DRM/V4L2 
> thing, so I am really not sure we have the right idea here.

Well two possibilities here: Either implement DMA-BUF support in the 
Ethernet/USB subsystem or get splice working efficiently with DMA-BUF 
mappings.

The first one is certainly a lot of work and no idea if the second is 
even doable and if yes also in a non-hacky way which you can get upstream.

>
> And finally, there is the new kid in town, io_uring. I am not very 
> literate about the topic, but it does not seem to be able to handle 
> DMA buffers (yet?). The idea that we could dequeue a buffer of samples 
> from the IIO device and send it over the network in one single syscall 
> is appealing, though.

As far as I know this is orthogonal to DMA-BUF. Christoph's answer 
sounds like my understand is correct, but there are certainly people 
which know that better than I do.

Regards,
Christian.

>
> Any thoughts? Feedback would be greatly appreciated.
>
> Cheers,
> -Paul
>
> [1]: 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinux-iio%2F20210217073638.21681-1-alexandru.ardelean%40analog.com%2FT%2F%23m6b853addb77959c55e078fbb06828db33d4bf3d7&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C2c62025e34b644b98e2508d95e4f4dcb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637644516997743314%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=vZfslxljjWcXi1RccZcsnKTD8x1CixRN%2Ftk4FMsWN3U%3D&amp;reserved=0
> [2]: 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fnewbedev.com%2Fzero-copy-user-space-tcp-send-of-dma-mmap-coherent-mapped-memory&amp;data=04%7C01%7Cchristian.koenig%40amd.com%7C2c62025e34b644b98e2508d95e4f4dcb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637644516997753306%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=Fn%2B3dO%2B%2F3r0ZpC5oKsQaPN2DREZKVWdVPahYgt2bsSw%3D&amp;reserved=0
>
>

