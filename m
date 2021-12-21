Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA56947C384
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 17:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbhLUQIY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 11:08:24 -0500
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:47232
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229652AbhLUQIY (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 21 Dec 2021 11:08:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2EmL6Xzc6/RfBfcxKm7nyYJ+UH7/AVg9+h4xntXwjGADhiBK1WFvSJj/Feiw0NJR0f9tnj4gdF/F1KZLm5i8MOM9IAMvNbhE4UMQOI1ufGvaRyC73DnkIiHqp/EgS0eonIoIxisMAbdAvk2VxPZr+0sR53doQ8UEuDEhT9KRPCu969pcIgJzWjmb8SBZNuax77sVsUgA8ASTuFD/L3O3d8gGQSZ00mjQHOkfKs9aiNjPnSBA6UauH8UwAnkfGiSf7DcuNCRvnap4pvX/BfYVwX2ExSEa/bCmQOWxWo8sl//imekKWFvSrpitgZLcXljJNBpIgyOXfjTJ1c/JbtGxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgMyOjanZPJ+LgKHnk4K7m6ZpYaUGU12weGYzjaILFI=;
 b=UcIPMKg9hHxSBvj7dCdZR7D6GEXpPlkd5DwU/22ll6LCfD8blpI6qj8pV0KpfgGGWJVWxAof+z84oxR2IpnRM5E9eBINmrFUJMyeol7l8zQ/aJuGEGW9m7sjPuHuEsGq50YV4HUcqGe6luJtcnjXR8vpSou5rgvLfYf6ok8DulM+vimAPZzJ6hkkbnktyg0/o6lrQUfMqD/AzKA93n62wtgnIvII/gxIiJ7Tm5p8589K3olM8s6AxCu2TvSo0BPD1R1i9mN7Oap2xeDFzty5cuIuQv3dkv6FtAMqLbVF1e9G9ssjCQNZ8a7i1gsaCj9bsRYljA+GzkmT48qc8LG6iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgMyOjanZPJ+LgKHnk4K7m6ZpYaUGU12weGYzjaILFI=;
 b=PPU5iulk3FXmzoL0N9X2q1E3MgVfSgJ3OgBi7TTszWmq16z2Y7Ou8Pm623dMeXFFCmGFh1hsQFKBZAI4o2nYS2wGaDI5EnPZFHsHHAHcK9Kiz2qhd+T+A9XFtrIfhBFATRW7J1FhXEFBZ1XmurBAwzu5RCBhj8zqNl2hrrGHnGB944SSFOZiHWj7ABzPMxbO5w8L+ZbwkMyCQpXNTiLJzP1Rx3yoqRv4NrtgW3NoV1HFrZv8oHIQPb+qfXqxOMbALWT7m3Nw5z9065sUcq36TbaIg3NTxqVN/6LkIs3T9uRtO1KDhgqvmBkpcwjy/PKoKq/z4UhIT7pI3L+c8javzw==
Received: from BN9PR03CA0428.namprd03.prod.outlook.com (2603:10b6:408:113::13)
 by MN2PR12MB4470.namprd12.prod.outlook.com (2603:10b6:208:260::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 16:08:22 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::82) by BN9PR03CA0428.outlook.office365.com
 (2603:10b6:408:113::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17 via Frontend
 Transport; Tue, 21 Dec 2021 16:08:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 16:08:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 16:08:20 +0000
Received: from [172.27.15.40] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Tue, 21 Dec 2021
 08:08:18 -0800
Message-ID: <6229ea66-1526-83c9-7a4e-e6cc32ee38da@nvidia.com>
Date:   Tue, 21 Dec 2021 18:08:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        "Hannes Reinecke" <hare@suse.de>, Oren Duer <oren@nvidia.com>
References: <20211215162421.14896-1-axboe@kernel.dk>
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
 <460ad0f5-7fb5-85c4-2718-20eeefe2050c@nvidia.com>
 <b8b62607-4b2d-9b3f-4cd6-6d66defb078c@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <b8b62607-4b2d-9b3f-4cd6-6d66defb078c@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cea3ed41-f9a9-400d-fced-08d9c49c1c66
X-MS-TrafficTypeDiagnostic: MN2PR12MB4470:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4470560A31D9B87CAEC10CB0DE7C9@MN2PR12MB4470.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0mPGgJF+iVuy09r486O5VBzre9+Yxqv5naG33pODVewdPdqMTSJ5nr1IAOuCbxQtj792pCIyJQEv23LbMCP5hPfHVTtc0Oxu4icWHlJHPiMSwKLBZFRxnawSgBECvAEDMwFfRHey0qFho8kx+OeJkc7TSEduUADHId18Beg3f92xnjtFrpBx4KAKy0Bj+8ClP2Us3iTxofme5ku5Zax3Va3WI55TZk4dvQ1ETa5SmsL2xTpVfDtSyuAw+n/C3zwzVkl1N+AdgbCctP0GHj8/D2xXbjc7/0A5+KvGjj/Ly+ULvZqxb/BJt+9E0fhMmECylmpzoIPcMb7UYJrGk63gzgSg1FsJo9FSjhctuF67Tv3XX0ez02W6+2bnsNYYceJjOX1PKgCE7zrdv5kK0q2Ge3OzuzJXDgSGVfvZukgpHiNm23DrQfDiHvjQiz4AYgjzraVMj2Ejt3fon39SXdEYgyFy3MQDTXVGkTakbeMhg5hCpoDG7AtEKLsfzV442PFmX4NjejpjMz+PjZLh9DlnOWHEwYDCk3VXSA2IZBbfAaOWMUvg0UldH3bxHceJSlID4GjdbokbyzlyRoQSAqavk1FIaWyHXUZSZHF+I7puW6C54LEgnV+4VY/+Tudwyqdj9jX4S1bRdPPcNq4RipXIjfZO2pPg+EGP9KG/cQkHkUDugKtGCEC3Yf5j1VjNSbcXiN2uVCnt7gIec66ZK0vmg9U++V9/pI5pLdEQ15a93cjjy5sL9wTXQXRybxD1aMpTXkOIIIa3GSkZKCtpPxn1oA2qcT6bvUdYkYnwsCGt2g2HR9tUK+JnbXnLlBpN9zeX7l/VDqWEdnvmN/9TI6TRcVGhgkx2gAS/rtwWstPyPlc=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(26005)(16576012)(8676002)(83380400001)(53546011)(316002)(6666004)(31696002)(86362001)(54906003)(2616005)(70586007)(36860700001)(107886003)(70206006)(110136005)(31686004)(82310400004)(5660300002)(81166007)(508600001)(34020700004)(40460700001)(47076005)(186003)(336012)(4326008)(426003)(356005)(36756003)(16526019)(2906002)(8936002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 16:08:21.7589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cea3ed41-f9a9-400d-fced-08d9c49c1c66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4470
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/21/2021 5:33 PM, Jens Axboe wrote:
> On 12/21/21 8:29 AM, Max Gurtovoy wrote:
>> On 12/21/2021 5:23 PM, Jens Axboe wrote:
>>> On 12/21/21 3:20 AM, Max Gurtovoy wrote:
>>>> On 12/20/2021 8:58 PM, Jens Axboe wrote:
>>>>> On 12/20/21 11:48 AM, Max Gurtovoy wrote:
>>>>>> On 12/20/2021 6:34 PM, Jens Axboe wrote:
>>>>>>> On 12/20/21 8:29 AM, Max Gurtovoy wrote:
>>>>>>>> On 12/20/2021 4:19 PM, Jens Axboe wrote:
>>>>>>>>> On 12/20/21 3:11 AM, Max Gurtovoy wrote:
>>>>>>>>>> On 12/19/2021 4:48 PM, Jens Axboe wrote:
>>>>>>>>>>> On 12/19/21 5:14 AM, Max Gurtovoy wrote:
>>>>>>>>>>>> On 12/16/2021 7:16 PM, Jens Axboe wrote:
>>>>>>>>>>>>> On 12/16/21 9:57 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>> On 12/16/2021 6:36 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>> On 12/16/21 9:34 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>> On 12/16/2021 6:25 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>>>> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>>>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>>>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>>>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>>>>>>>>>>>>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>>>>>>>>>>>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>>>>>>>>>>>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>>>>>>>>>>>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>>>>>>>>>>>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>>>>>>>>>>>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>>>>>>>>>>>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>>>>>>>>>>>>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>>>>>>>>>>>>>>>>>> should call nvme_sq_copy_cmd().
>>>>>>>>>>>>>>>>>>>>>> I also noticed that.
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>>>>>>>>>>>>>>>>>> Yes agree, that's been my stance too :-)
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>>>>>>>>>>>>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>>>>>>>>>>>>>>>>>> error?
>>>>>>>>>>>>>>>>>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>>>>>>>>>>>>>>>>>> algorithm ?
>>>>>>>>>>>>>>>>>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>>>>>>>>>>>>>>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>>>>>>>>>>>>>>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>>>>>>>>>>>>>>>>>> to get enough gain from the batching done in various areas, while still
>>>>>>>>>>>>>>>>>>>>> not making it so large that we have a potential latency issue. That
>>>>>>>>>>>>>>>>>>>>> batch count is already used consistently for other items too (like tag
>>>>>>>>>>>>>>>>>>>>> allocation), so it's not specific to just this one case.
>>>>>>>>>>>>>>>>>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>>>>>>>>>>>>>>>>>> won't be efficient from latency POV.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> So it's better to limit the block layar to wait for the first to come: x
>>>>>>>>>>>>>>>>>>>> usecs or batch_max_count before issue queue_rqs.
>>>>>>>>>>>>>>>>>>> There's no waiting specifically for this, it's just based on the plug.
>>>>>>>>>>>>>>>>>>> We just won't do more than 32 in that plug. This is really just an
>>>>>>>>>>>>>>>>>>> artifact of the plugging, and if that should be limited based on "max of
>>>>>>>>>>>>>>>>>>> 32 or xx time", then that should be done there.
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> But in general I think it's saner and enough to just limit the total
>>>>>>>>>>>>>>>>>>> size. If we spend more than xx usec building up the plug list, we're
>>>>>>>>>>>>>>>>>>> doing something horribly wrong. That really should not happen with 32
>>>>>>>>>>>>>>>>>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>>>>>>>>>>>>>>>>>> will result in a plug flush to begin with.
>>>>>>>>>>>>>>>>>> I'm not aware of the plug. I hope to get to it soon.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> My concern is if the user application submitted only 28 requests and
>>>>>>>>>>>>>>>>>> then you'll wait forever ? or for very long time.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> I guess not, but I'm asking how do you know how to batch and when to
>>>>>>>>>>>>>>>>>> stop in case 32 commands won't arrive anytime soon.
>>>>>>>>>>>>>>>>> The plug is in the stack of the task, so that condition can never
>>>>>>>>>>>>>>>>> happen. If the application originally asks for 32 but then only submits
>>>>>>>>>>>>>>>>> 28, then once that last one is submitted the plug is flushed and
>>>>>>>>>>>>>>>>> requests are issued.
>>>>>>>>>>>>>>>> So if I'm running fio with --iodepth=28 what will plug do ? send batches
>>>>>>>>>>>>>>>> of 28 ? or 1 by 1 ?
>>>>>>>>>>>>>>> --iodepth just controls the overall depth, the batch submit count
>>>>>>>>>>>>>>> dictates what happens further down. If you run queue depth 28 and submit
>>>>>>>>>>>>>>> one at the time, then you'll get one at the time further down too. Hence
>>>>>>>>>>>>>>> the batching is directly driven by what the application is already
>>>>>>>>>>>>>>> doing.
>>>>>>>>>>>>>> I see. Thanks for the explanation.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> So it works only for io_uring based applications ?
>>>>>>>>>>>>> It's only enabled for io_uring right now, but it's generically available
>>>>>>>>>>>>> for anyone that wants to use it... Would be trivial to do for aio, and
>>>>>>>>>>>>> other spots that currently use blk_start_plug() and has an idea of how
>>>>>>>>>>>>> many IOs will be submitted
>>>>>>>>>>>> Can you please share an example application (or is it fio patches) that
>>>>>>>>>>>> can submit batches ? The same that was used to test this patchset is
>>>>>>>>>>>> fine too.
>>>>>>>>>>>>
>>>>>>>>>>>> I would like to test it with our NVMe SNAP controllers and also to
>>>>>>>>>>>> develop NVMe/RDMA queue_rqs code and test the perf with it.
>>>>>>>>>>> You should just be able to use iodepth_batch with fio. For my peak
>>>>>>>>>>> testing, I use t/io_uring from the fio repo. By default, it'll run QD of
>>>>>>>>>>> and do batches of 32 for complete and submit. You can just run:
>>>>>>>>>>>
>>>>>>>>>>> t/io_uring <dev or file>
>>>>>>>>>>>
>>>>>>>>>>> maybe adding -p0 for IRQ driven rather than polled IO.
>>>>>>>>>> I used your block/for-next branch and implemented queue_rqs in NVMe/RDMA
>>>>>>>>>> but it was never called using the t/io_uring test nor fio with
>>>>>>>>>> iodepth_batch=32 flag with io_uring engine.
>>>>>>>>>>
>>>>>>>>>> Any idea what might be the issue ?
>>>>>>>>>>
>>>>>>>>>> I installed fio from sources..
>>>>>>>>> The two main restrictions right now are a scheduler and shared tags, are
>>>>>>>>> you using any of those?
>>>>>>>> No.
>>>>>>>>
>>>>>>>> But maybe I'm missing the .commit_rqs callback. is it mandatory for this
>>>>>>>> feature ?
>>>>>>> I've only tested with nvme pci which does have it, but I don't think so.
>>>>>>> Unless there's some check somewhere that makes it necessary. Can you
>>>>>>> share the patch you're currently using on top?
>>>>>> The attached POC patches apply cleanly on block/for-next branch
>>>>> Looks reasonable to me from a quick glance. Not sure why you're not
>>>>> seeing it hit, maybe try and instrument
>>>>> block/blk-mq.c:blk_mq_flush_plug_list() and find out why it isn't being
>>>>> called? As mentioned, no elevator or shared tags, should work for
>>>>> anything else basically.
>>>> Yes. I saw that the blk layer converted the original non-shared tagset
>>>> of NVMe/RDMA to a shared one because of the nvmf connect request queue
>>>> that is using the same tagset (uses only the reserved tag).
>>>>
>>>> So I guess this is the reason that the I couldn't reach the new code of
>>>> queue_rqs.
>>>>
>>>> The question is how we can overcome this ?
>>> Do we need to mark it shared for just the reserved tags? I wouldn't
>>> think so...
>> We don't mark it. The block layer does it in blk_mq_add_queue_tag_set:
>>
>> if (!list_empty(&set->tag_list) &&
>>               !(set->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
> Yes, that's what I meant, do we need to mark it as such for just the
> reserved tags?

I'm afraid it doesn't related only to reserved tags.

If you have nvme device with 2 namespaces it will get to this code and 
mark it as shared set. And then the queue_rqs() won't be called for NVMe 
PCI as well.


>
