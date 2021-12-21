Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B46947BE16
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 11:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhLUKUN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 05:20:13 -0500
Received: from mail-dm6nam11on2056.outbound.protection.outlook.com ([40.107.223.56]:5216
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232900AbhLUKUN (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 21 Dec 2021 05:20:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFohu9qaYqejCbP/cjq/jDd3ix+3rs7GKrALjcqZJVdoHcly2mDu8aZUv8uvb6/GX0OSpUC12LKHoJVfyF+d7Yngtg6YHKrxA3aLiXSaxSs0MXXUA2YbEDm7vnzGbeCV/tUKltxKUv5uGBJPgPJ/SRBg0bAgFhHYrzitL3tAXCAg6CG3FHmUB7GAgvRbt4rZFOGNjgeRPl59sA82lLrvfF4GBoBN5HJTIda5NoEP2jHBMbSG5z5dmIVoERzLaKbvoBJIRiGFmayDIsU/v2y30oHWmmT8MwBduMxNNCnsMfV358MznqL7Ij2r3lmrIOfN1/aT0cphUBzEG+crDNjytg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bi6xtaGHych2ZdJianeQ0XN1HnGfSn6NqlkQ3cGaPdA=;
 b=Xgxbgsfso2Vm2y99jcikFiEYeqAzwdePO1PXWieaUXAgAY4p07FyRKNcmhFZMAhvo+AaU0iSwfLDRB2yxyVGc560GnGIhcVEtwSa7VN8VS9P2ewCNi1xFoBHS70dgVpVENGoKF4C4bAzaPBW/qaNBwGUbiN4t3xsE0oW+20iTtvym/RejdZiccn98TOea6Y+jzOYFoZK/wnqobXR0UsJENTZTYzEWeprwuNYAMEILLkpKqyRgTRdp3dNXnMv17ZYTiKO1Y/hDTBzBXxy/IkkKlYyCBeLk3SnL/XsAb8GnzDw8WXUyqlR6f1F5yTYmcjUXcioBFRilKwYGz3nbZwU3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bi6xtaGHych2ZdJianeQ0XN1HnGfSn6NqlkQ3cGaPdA=;
 b=N0LvXoecP5hfE/Zs5s1nnb0fu7Y5sZztbBVA5vYtWbL6mMsCigZpXOYVVYr11Xn7n3WlX7NdGJVu6pI+U2ZpJRK5Qqgi8vl2U+yHnW2gRM/7EN8tIBE/6eWnTNd0Ke9wGvMwC4Tu7ThnhJNn51eZdKuA2adDoac8Q3AQ6aSPL3umR8hpyAnbOf0a2hc6GaPrHTbMuoPW2fZwASKxp5Mrn47xx7MOg3gIfWy80weQzRG+VU8ejt4rkVMNK+Gh5dGw4h4YAyifyyIv6+HICSDLElJWqtkU0GLkO5s2XTt/A/Kv2V3/bEQURLKgWCOXErXNJirVnPiZoamLNDAHKRJahw==
Received: from MWHPR2001CA0005.namprd20.prod.outlook.com
 (2603:10b6:301:15::15) by CY4PR12MB1270.namprd12.prod.outlook.com
 (2603:10b6:903:43::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 10:20:11 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:15:cafe::e3) by MWHPR2001CA0005.outlook.office365.com
 (2603:10b6:301:15::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.16 via Frontend
 Transport; Tue, 21 Dec 2021 10:20:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 10:20:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 10:20:10 +0000
Received: from [172.27.15.40] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Tue, 21 Dec 2021
 02:20:08 -0800
Message-ID: <caee56c1-604a-be64-5b34-93f32c4de621@nvidia.com>
Date:   Tue, 21 Dec 2021 12:20:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        "Hannes Reinecke" <hare@suse.de>, Oren Duer <oren@nvidia.com>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <YbsB/W/1Uwok4i0u@infradead.org>
 <2adafc43-3860-d9f0-9cb5-ca3bf9a27109@nvidia.com>
 <06ab52e6-47b7-6010-524c-45bb73fbfabc@kernel.dk>
 <9b4202b4-192a-6611-922e-0b837e2b97c3@nvidia.com>
 <5f249c03-5cb2-9978-cd2c-669c0594d1c0@kernel.dk>
 <d1613b7f-342d-08ad-d655-a6afb89e1847@nvidia.com>
 <a159220b-6e0c-6ee9-f8e2-c6dc9f6dfaed@kernel.dk>
 <3474493a-a04d-528c-7565-f75db5205074@nvidia.com>
 <87e3a197-e8f7-d8d6-85b6-ce05bf1f35cd@kernel.dk>
 <5ee0e257-651a-ec44-7ca3-479438a737fb@nvidia.com>
 <e3974442-3b3f-0419-519c-7360057c4603@kernel.dk>
 <01f9ce91-d998-c823-f2f2-de457625021e@nvidia.com>
 <573bbe72-d232-6063-dd34-2e12d8374594@kernel.dk>
 <4fbf2936-8e4c-9c04-e5a9-10eae387b562@nvidia.com>
 <6ca82929-7e70-be15-dcbb-1e68a02dd933@kernel.dk>
 <e1afcf34-a283-a88a-fa0b-26c7c1094e74@nvidia.com>
 <92c5065e-dc2a-9e3f-404a-64c6e22624b7@kernel.dk>
 <5b001e0f-cec0-112d-533a-d71684eb1d2e@nvidia.com>
 <7cbaa97b-4d79-82ca-d037-7d47f089ba8a@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <7cbaa97b-4d79-82ca-d037-7d47f089ba8a@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 848edbfd-e1cf-4aa2-bc54-08d9c46b78a0
X-MS-TrafficTypeDiagnostic: CY4PR12MB1270:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB127089933A8D6C7C799AA040DE7C9@CY4PR12MB1270.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FGsXL8N9ysWCFTttueGYfVEK0CUHVkpGgvhuleq+ugrdt1qjPuY2R1fzcu8Sl1MZpBBEK9lPxxXbTYb3Jloxa3fOBUwFHSpSuoNGwMTftrLWuuFfKvlgIGcUXM76O9sfBPgi+7mVfLLTliUk9OMkFwnGrp+bPiMtj7YEO2PDheyFhZ3koygAew0O+27LEEPvLVH6m+EHKBXBw3FcFfMJbnK96hvpKBVyFLjbY5cWhgGIBLOyfzNhzS1hxqbagRxgNDq/Q/KXbJw2NcZr8ZilVhWzEgy7vwA8eUBIh+Gwhg03E6KTs99QrqBkg2vMCfA/4lxaSlrxCywaDAwjACvVfw6AyGpEh//9Zu7rAk8wskzn3O573iUSxbRnx7Il+rPHYj6/Mj30Dk0nEjSCbAYdAkgAcm3mTu9Zj5jWtgIaz1lQnIdah8X6iYtxNre3axoQhFOrMWBuFCXUr8j2E8jNSyzhWy4yVvRdVdQewUqTOr7XTyW6rODLJWdLzOxoxfzpq8UIqVOLibN5IJ6XUEpuUcZ2NPO7vpDa4TB5Q+WGyINEQj2912xh8r4DjtWspnhsr8sjbTn+pv8xJCglcMYNRYRf89vuAgzAwepui5AIsJhoIWKgaJZSCv3NRc4S9q37rNQqBmLBfHpIehR/cl0ccVaB3Bv3G0dgXRb03NJShhiF3JLG1diCeT8dcXzyx52mgdwGD5IpI58iEOMB/UVVdkXIlwxS/Ej2sDwMr6VHoHkdWoWBaIghEUiyvNtlWTV3b+ipAcwc2iM2uQrbs2Ny5i95OgYq1WbWqOFTn1BoQezLAPRyaD0eBihkCLyMHFRTEruS4RoHmisUj91dUKyMlAxcxonebnzoHS8gKuh1LyU=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(40460700001)(186003)(16526019)(70206006)(2616005)(83380400001)(8936002)(70586007)(53546011)(81166007)(356005)(8676002)(82310400004)(26005)(2906002)(6666004)(34020700004)(4326008)(47076005)(107886003)(110136005)(336012)(5660300002)(31686004)(54906003)(508600001)(426003)(16576012)(36860700001)(86362001)(31696002)(36756003)(316002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 10:20:11.2638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 848edbfd-e1cf-4aa2-bc54-08d9c46b78a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1270
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/20/2021 8:58 PM, Jens Axboe wrote:
> On 12/20/21 11:48 AM, Max Gurtovoy wrote:
>> On 12/20/2021 6:34 PM, Jens Axboe wrote:
>>> On 12/20/21 8:29 AM, Max Gurtovoy wrote:
>>>> On 12/20/2021 4:19 PM, Jens Axboe wrote:
>>>>> On 12/20/21 3:11 AM, Max Gurtovoy wrote:
>>>>>> On 12/19/2021 4:48 PM, Jens Axboe wrote:
>>>>>>> On 12/19/21 5:14 AM, Max Gurtovoy wrote:
>>>>>>>> On 12/16/2021 7:16 PM, Jens Axboe wrote:
>>>>>>>>> On 12/16/21 9:57 AM, Max Gurtovoy wrote:
>>>>>>>>>> On 12/16/2021 6:36 PM, Jens Axboe wrote:
>>>>>>>>>>> On 12/16/21 9:34 AM, Max Gurtovoy wrote:
>>>>>>>>>>>> On 12/16/2021 6:25 PM, Jens Axboe wrote:
>>>>>>>>>>>>> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>>>>>>>>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>>>>>>>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>>>>>>>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>>>>>>>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>>>>>>>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>>>>>>>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>>>>>>>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>>>>>>>>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>>>>>>>>>>>>>> should call nvme_sq_copy_cmd().
>>>>>>>>>>>>>>>>>> I also noticed that.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>>>>>>>>>>>>>> Yes agree, that's been my stance too :-)
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>>>>>>>>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>>>>>>>>>>>>>> error?
>>>>>>>>>>>>>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>>>>>>>>>>>>>> algorithm ?
>>>>>>>>>>>>>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>>>>>>>>>>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>>>>>>>>>>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>>>>>>>>>>>>>> to get enough gain from the batching done in various areas, while still
>>>>>>>>>>>>>>>>> not making it so large that we have a potential latency issue. That
>>>>>>>>>>>>>>>>> batch count is already used consistently for other items too (like tag
>>>>>>>>>>>>>>>>> allocation), so it's not specific to just this one case.
>>>>>>>>>>>>>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>>>>>>>>>>>>>> won't be efficient from latency POV.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> So it's better to limit the block layar to wait for the first to come: x
>>>>>>>>>>>>>>>> usecs or batch_max_count before issue queue_rqs.
>>>>>>>>>>>>>>> There's no waiting specifically for this, it's just based on the plug.
>>>>>>>>>>>>>>> We just won't do more than 32 in that plug. This is really just an
>>>>>>>>>>>>>>> artifact of the plugging, and if that should be limited based on "max of
>>>>>>>>>>>>>>> 32 or xx time", then that should be done there.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> But in general I think it's saner and enough to just limit the total
>>>>>>>>>>>>>>> size. If we spend more than xx usec building up the plug list, we're
>>>>>>>>>>>>>>> doing something horribly wrong. That really should not happen with 32
>>>>>>>>>>>>>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>>>>>>>>>>>>>> will result in a plug flush to begin with.
>>>>>>>>>>>>>> I'm not aware of the plug. I hope to get to it soon.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> My concern is if the user application submitted only 28 requests and
>>>>>>>>>>>>>> then you'll wait forever ? or for very long time.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I guess not, but I'm asking how do you know how to batch and when to
>>>>>>>>>>>>>> stop in case 32 commands won't arrive anytime soon.
>>>>>>>>>>>>> The plug is in the stack of the task, so that condition can never
>>>>>>>>>>>>> happen. If the application originally asks for 32 but then only submits
>>>>>>>>>>>>> 28, then once that last one is submitted the plug is flushed and
>>>>>>>>>>>>> requests are issued.
>>>>>>>>>>>> So if I'm running fio with --iodepth=28 what will plug do ? send batches
>>>>>>>>>>>> of 28 ? or 1 by 1 ?
>>>>>>>>>>> --iodepth just controls the overall depth, the batch submit count
>>>>>>>>>>> dictates what happens further down. If you run queue depth 28 and submit
>>>>>>>>>>> one at the time, then you'll get one at the time further down too. Hence
>>>>>>>>>>> the batching is directly driven by what the application is already
>>>>>>>>>>> doing.
>>>>>>>>>> I see. Thanks for the explanation.
>>>>>>>>>>
>>>>>>>>>> So it works only for io_uring based applications ?
>>>>>>>>> It's only enabled for io_uring right now, but it's generically available
>>>>>>>>> for anyone that wants to use it... Would be trivial to do for aio, and
>>>>>>>>> other spots that currently use blk_start_plug() and has an idea of how
>>>>>>>>> many IOs will be submitted
>>>>>>>> Can you please share an example application (or is it fio patches) that
>>>>>>>> can submit batches ? The same that was used to test this patchset is
>>>>>>>> fine too.
>>>>>>>>
>>>>>>>> I would like to test it with our NVMe SNAP controllers and also to
>>>>>>>> develop NVMe/RDMA queue_rqs code and test the perf with it.
>>>>>>> You should just be able to use iodepth_batch with fio. For my peak
>>>>>>> testing, I use t/io_uring from the fio repo. By default, it'll run QD of
>>>>>>> and do batches of 32 for complete and submit. You can just run:
>>>>>>>
>>>>>>> t/io_uring <dev or file>
>>>>>>>
>>>>>>> maybe adding -p0 for IRQ driven rather than polled IO.
>>>>>> I used your block/for-next branch and implemented queue_rqs in NVMe/RDMA
>>>>>> but it was never called using the t/io_uring test nor fio with
>>>>>> iodepth_batch=32 flag with io_uring engine.
>>>>>>
>>>>>> Any idea what might be the issue ?
>>>>>>
>>>>>> I installed fio from sources..
>>>>> The two main restrictions right now are a scheduler and shared tags, are
>>>>> you using any of those?
>>>> No.
>>>>
>>>> But maybe I'm missing the .commit_rqs callback. is it mandatory for this
>>>> feature ?
>>> I've only tested with nvme pci which does have it, but I don't think so.
>>> Unless there's some check somewhere that makes it necessary. Can you
>>> share the patch you're currently using on top?
>> The attached POC patches apply cleanly on block/for-next branch
> Looks reasonable to me from a quick glance. Not sure why you're not
> seeing it hit, maybe try and instrument
> block/blk-mq.c:blk_mq_flush_plug_list() and find out why it isn't being
> called? As mentioned, no elevator or shared tags, should work for
> anything else basically.

Yes. I saw that the blk layer converted the original non-shared tagset 
of NVMe/RDMA to a shared one because of the nvmf connect request queue 
that is using the same tagset (uses only the reserved tag).

So I guess this is the reason that the I couldn't reach the new code of 
queue_rqs.

The question is how we can overcome this ?

Should we create new tagset for the NVMf fabrics connect_q ? or maybe 
not mark the tagset as shared for reserved ids ?

Christoph, any suggestion here ?

>
