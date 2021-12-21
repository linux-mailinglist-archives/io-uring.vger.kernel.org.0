Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DA747C2D0
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 16:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239329AbhLUP3U (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 10:29:20 -0500
Received: from mail-dm6nam11on2055.outbound.protection.outlook.com ([40.107.223.55]:4948
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239307AbhLUP3U (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 21 Dec 2021 10:29:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLCPEI6HkTTFAbvRbBFJjcl/xwRVnFQdbiqjUk95lwLNCUOmb+Q5aJG694rtHpm7ZRdX/g6WVZowfaf51VDUSE01qrzqjPG2mg2Ahj0g9B9ZszalHYZMl209i7OLDFpjvJGQLepzf9lvXZTcjYA18yta1Nfyqys/PkZIaRKwSV5klc4345NoU+RxPQ5CrqakA8HcPRsnXU+YbH3wi3r9KbC74xqVSFYp0iocmf1rfZCkP24VVpc4RakhR5QeccgKfgIdfhljkOYwEUHQ2WnKxin2gAkoji3kDWmisDRiGJztafykhIvuK1oWOdB/a7+Lqz/ekRA0Fte8qGkOqmjS7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14VJokRimDgtOfSb/00s8MNKqNUzjYM8lpQuRwn7LvU=;
 b=k5ov7b3sEj3fue2yl6UZakfJcpX7MM+01zKrJKfJhLT7eguJyUbRAycyPBEIHhR7b+4pC9ACM1mCK1xekcB3SlhrjRfy6l0gzJSWRqQAJGDTlw7xFxOztgvaD+vvzUGGYO//7hUxb76T/v9sfCxnezUGN7N09Feiip1y/yVWZf94FTYleaF+/QCIF7G87tptNsoGB6RjHHarw5oA/vRR6Hxv7UxjBcd7gdE3CCCa7qWIWFaOhvcDA+mxprIc1v8ybjpc8b3mGXmif2uZDVOMrRJkY+FXvTUBJB9p57sBt9GWuQrfOsmVYhfZF6JY2zKM/+C7EhkR6uAW5RnbIvjKFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14VJokRimDgtOfSb/00s8MNKqNUzjYM8lpQuRwn7LvU=;
 b=ojj/im3nLID2gTwwDKMLyZQiPLd5ih9JankNiHYoftaGh5h8uHVA3v3ofXVZVputp3uV8VQCxlLWe9eKV2XW90c5BmOcz9l8RSGN/6tgfD2X0UCYdq/EjBOUBu34qAwZo0hFfp8k69OmFP2mrVaCg9zqca5gwfFAsRAN9mV5oXZqg5Ru0saey9VzOOCeqkMiqaT3wg22pig2ZUy6yun4RcaqqlfZPlVSyGl4Ru370M8uCltOSQSOlKBLCH0Y5uWTMTyErbXxDTgmhTe8NV+8NOSugo+MbWZ/rtpIvuVum3S4MRl2Nk6ociYIkx/72cixv3JwcAAyFRme/DxWTBImxw==
Received: from CO1PR15CA0078.namprd15.prod.outlook.com (2603:10b6:101:20::22)
 by BN9PR12MB5052.namprd12.prod.outlook.com (2603:10b6:408:135::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 15:29:18 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::e9) by CO1PR15CA0078.outlook.office365.com
 (2603:10b6:101:20::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15 via Frontend
 Transport; Tue, 21 Dec 2021 15:29:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 15:29:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 15:29:17 +0000
Received: from [172.27.15.40] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Tue, 21 Dec 2021
 07:29:14 -0800
Message-ID: <460ad0f5-7fb5-85c4-2718-20eeefe2050c@nvidia.com>
Date:   Tue, 21 Dec 2021 17:29:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        "Hannes Reinecke" <hare@suse.de>, Oren Duer <oren@nvidia.com>
References: <20211215162421.14896-1-axboe@kernel.dk>
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
 <caee56c1-604a-be64-5b34-93f32c4de621@nvidia.com>
 <c437d44f-6309-9e18-edc1-7bb0da4a54e2@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <c437d44f-6309-9e18-edc1-7bb0da4a54e2@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cbc760d-f3d5-4105-2fe8-08d9c496a782
X-MS-TrafficTypeDiagnostic: BN9PR12MB5052:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5052725B95DBDA9E8A0AF0A3DE7C9@BN9PR12MB5052.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: asvoZk5NrlkqA43+CxXnhkEWjJTv6getAmLyXPzCiUfxa591R5aiGhx8SFIWG0RJIp9a7/7fJqss7tK6fG6kKcbsC3OeC+FnW6YrivJNyqg5wXG9bYyH304d+Rg5LAOcCE1qlVEjztQEojPdcmNA6YWuM4uRfxtHcmDop08Fdx11hLQ8u0C1zPQ0E981LKxfSNKCQuXX9PrFovOP20joPt7qIC91gQAbAzHSIf5rX4ALrjkDtvwQcCNBEWd+Rk+dS+EGKBH5bQHQyQjS5EXyAXuHoO9+4bXO5BuXfs3+gj9IRyrjzXmo/u43Xtvphy/uKRH+WMdT4C8+PsuLW1bVN8AKvlwt56KrinI1aICbTHJtq7JJtMTLGy1iGqJQgcb7jln8+gtq9+ChAH+Swn82zlVd+1bTb86ZrvfFXuxkJ1gN2XX0Fuy47AGTLqfmtgbSJkipSScdZzRuV6Os256oBlcxDaXhBoSM37mWUl2PFI0WQJ7EtPbTAOW0tTKLwwuwtk7Kx1uWYHdZRUGfHbV5t4ikw9Najo6gdABx9iVuIT4UnuvMuSBJMGUzKQ9WLuBW11ZKXUmyIqlDdalkq/oyKWJB6FMb+rnFFYf0hCyqXW9D8NRaJFDmrsSeK+R1Q2ohMxdy28PdUING7AF2sPJwxy5SSH90l2fCEqTXWbNNTWEiSZ5UV5vJ4q5HltnxU/IvvCYR3qVOjuYo1hNHgPI6JE23kDQs82JSVmQ1rHY9FBgTtd2c4Gl6Xx6cAJTpqfZc8OeumnmLANeiZfXDRkLy4daCQu6jhRTzZQXKPK9p3zXbeOsaFW2OJ1kPg5h3zjuOX0ghuykPkNezd+S8/QBnL4HZ36owqn/JhFb62BLtz0U=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(31686004)(70586007)(110136005)(508600001)(54906003)(26005)(70206006)(5660300002)(4326008)(186003)(16576012)(6666004)(107886003)(8676002)(16526019)(36860700001)(316002)(8936002)(31696002)(83380400001)(34020700004)(86362001)(82310400004)(81166007)(426003)(356005)(2906002)(40460700001)(336012)(47076005)(2616005)(36756003)(53546011)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 15:29:18.2538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cbc760d-f3d5-4105-2fe8-08d9c496a782
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5052
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/21/2021 5:23 PM, Jens Axboe wrote:
> On 12/21/21 3:20 AM, Max Gurtovoy wrote:
>> On 12/20/2021 8:58 PM, Jens Axboe wrote:
>>> On 12/20/21 11:48 AM, Max Gurtovoy wrote:
>>>> On 12/20/2021 6:34 PM, Jens Axboe wrote:
>>>>> On 12/20/21 8:29 AM, Max Gurtovoy wrote:
>>>>>> On 12/20/2021 4:19 PM, Jens Axboe wrote:
>>>>>>> On 12/20/21 3:11 AM, Max Gurtovoy wrote:
>>>>>>>> On 12/19/2021 4:48 PM, Jens Axboe wrote:
>>>>>>>>> On 12/19/21 5:14 AM, Max Gurtovoy wrote:
>>>>>>>>>> On 12/16/2021 7:16 PM, Jens Axboe wrote:
>>>>>>>>>>> On 12/16/21 9:57 AM, Max Gurtovoy wrote:
>>>>>>>>>>>> On 12/16/2021 6:36 PM, Jens Axboe wrote:
>>>>>>>>>>>>> On 12/16/21 9:34 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>> On 12/16/2021 6:25 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>>>>>>>>>>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>>>>>>>>>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>>>>>>>>>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>>>>>>>>>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>>>>>>>>>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>>>>>>>>>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>>>>>>>>>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>>>>>>>>>>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>>>>>>>>>>>>>>>> should call nvme_sq_copy_cmd().
>>>>>>>>>>>>>>>>>>>> I also noticed that.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>>>>>>>>>>>>>>>> Yes agree, that's been my stance too :-)
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>>>>>>>>>>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>>>>>>>>>>>>>>>> error?
>>>>>>>>>>>>>>>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>>>>>>>>>>>>>>>> algorithm ?
>>>>>>>>>>>>>>>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>>>>>>>>>>>>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>>>>>>>>>>>>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>>>>>>>>>>>>>>>> to get enough gain from the batching done in various areas, while still
>>>>>>>>>>>>>>>>>>> not making it so large that we have a potential latency issue. That
>>>>>>>>>>>>>>>>>>> batch count is already used consistently for other items too (like tag
>>>>>>>>>>>>>>>>>>> allocation), so it's not specific to just this one case.
>>>>>>>>>>>>>>>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>>>>>>>>>>>>>>>> won't be efficient from latency POV.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> So it's better to limit the block layar to wait for the first to come: x
>>>>>>>>>>>>>>>>>> usecs or batch_max_count before issue queue_rqs.
>>>>>>>>>>>>>>>>> There's no waiting specifically for this, it's just based on the plug.
>>>>>>>>>>>>>>>>> We just won't do more than 32 in that plug. This is really just an
>>>>>>>>>>>>>>>>> artifact of the plugging, and if that should be limited based on "max of
>>>>>>>>>>>>>>>>> 32 or xx time", then that should be done there.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> But in general I think it's saner and enough to just limit the total
>>>>>>>>>>>>>>>>> size. If we spend more than xx usec building up the plug list, we're
>>>>>>>>>>>>>>>>> doing something horribly wrong. That really should not happen with 32
>>>>>>>>>>>>>>>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>>>>>>>>>>>>>>>> will result in a plug flush to begin with.
>>>>>>>>>>>>>>>> I'm not aware of the plug. I hope to get to it soon.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> My concern is if the user application submitted only 28 requests and
>>>>>>>>>>>>>>>> then you'll wait forever ? or for very long time.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> I guess not, but I'm asking how do you know how to batch and when to
>>>>>>>>>>>>>>>> stop in case 32 commands won't arrive anytime soon.
>>>>>>>>>>>>>>> The plug is in the stack of the task, so that condition can never
>>>>>>>>>>>>>>> happen. If the application originally asks for 32 but then only submits
>>>>>>>>>>>>>>> 28, then once that last one is submitted the plug is flushed and
>>>>>>>>>>>>>>> requests are issued.
>>>>>>>>>>>>>> So if I'm running fio with --iodepth=28 what will plug do ? send batches
>>>>>>>>>>>>>> of 28 ? or 1 by 1 ?
>>>>>>>>>>>>> --iodepth just controls the overall depth, the batch submit count
>>>>>>>>>>>>> dictates what happens further down. If you run queue depth 28 and submit
>>>>>>>>>>>>> one at the time, then you'll get one at the time further down too. Hence
>>>>>>>>>>>>> the batching is directly driven by what the application is already
>>>>>>>>>>>>> doing.
>>>>>>>>>>>> I see. Thanks for the explanation.
>>>>>>>>>>>>
>>>>>>>>>>>> So it works only for io_uring based applications ?
>>>>>>>>>>> It's only enabled for io_uring right now, but it's generically available
>>>>>>>>>>> for anyone that wants to use it... Would be trivial to do for aio, and
>>>>>>>>>>> other spots that currently use blk_start_plug() and has an idea of how
>>>>>>>>>>> many IOs will be submitted
>>>>>>>>>> Can you please share an example application (or is it fio patches) that
>>>>>>>>>> can submit batches ? The same that was used to test this patchset is
>>>>>>>>>> fine too.
>>>>>>>>>>
>>>>>>>>>> I would like to test it with our NVMe SNAP controllers and also to
>>>>>>>>>> develop NVMe/RDMA queue_rqs code and test the perf with it.
>>>>>>>>> You should just be able to use iodepth_batch with fio. For my peak
>>>>>>>>> testing, I use t/io_uring from the fio repo. By default, it'll run QD of
>>>>>>>>> and do batches of 32 for complete and submit. You can just run:
>>>>>>>>>
>>>>>>>>> t/io_uring <dev or file>
>>>>>>>>>
>>>>>>>>> maybe adding -p0 for IRQ driven rather than polled IO.
>>>>>>>> I used your block/for-next branch and implemented queue_rqs in NVMe/RDMA
>>>>>>>> but it was never called using the t/io_uring test nor fio with
>>>>>>>> iodepth_batch=32 flag with io_uring engine.
>>>>>>>>
>>>>>>>> Any idea what might be the issue ?
>>>>>>>>
>>>>>>>> I installed fio from sources..
>>>>>>> The two main restrictions right now are a scheduler and shared tags, are
>>>>>>> you using any of those?
>>>>>> No.
>>>>>>
>>>>>> But maybe I'm missing the .commit_rqs callback. is it mandatory for this
>>>>>> feature ?
>>>>> I've only tested with nvme pci which does have it, but I don't think so.
>>>>> Unless there's some check somewhere that makes it necessary. Can you
>>>>> share the patch you're currently using on top?
>>>> The attached POC patches apply cleanly on block/for-next branch
>>> Looks reasonable to me from a quick glance. Not sure why you're not
>>> seeing it hit, maybe try and instrument
>>> block/blk-mq.c:blk_mq_flush_plug_list() and find out why it isn't being
>>> called? As mentioned, no elevator or shared tags, should work for
>>> anything else basically.
>> Yes. I saw that the blk layer converted the original non-shared tagset
>> of NVMe/RDMA to a shared one because of the nvmf connect request queue
>> that is using the same tagset (uses only the reserved tag).
>>
>> So I guess this is the reason that the I couldn't reach the new code of
>> queue_rqs.
>>
>> The question is how we can overcome this ?
> Do we need to mark it shared for just the reserved tags? I wouldn't
> think so...

We don't mark it. The block layer does it in blk_mq_add_queue_tag_set:

if (!list_empty(&set->tag_list) &&
             !(set->flags & BLK_MQ_F_TAG_QUEUE_SHARED))

>
