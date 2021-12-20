Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810BC47B326
	for <lists+io-uring@lfdr.de>; Mon, 20 Dec 2021 19:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240549AbhLTSsK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Dec 2021 13:48:10 -0500
Received: from mail-mw2nam12on2069.outbound.protection.outlook.com ([40.107.244.69]:34912
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239750AbhLTSsK (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 20 Dec 2021 13:48:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eD3L0cD7KANnYOtCnp2S+WzI2Sw/t+Jazssbc2vmydBfCDFaINjnJFSuchBDmC3Bz+MQvvUqeHb0D5q3ZlI9uUt/G1PclOmnaLmL+dRBa01ryW1Gg7IzcId0nqdz2iBtM+6x/V+J/3qhCyBuJuXCWX9OsDMXqU//fgJgIhTCpe8oIUJ9WetYO/0GrfSz2b2ftzatHnHRfnVRyInXELpMolFcJa1+76K8B68k59yuYDS+hjfNUAD6YptCPsImo+2CGH0u6okM6hV8fdPch77r6ywYQaWscKaWzR6B0gvf9lA0Uq9xgXfhw09slmG82mBDVHTEH1yIYg17O+mY94T/9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQq1ry4gRQx5IDmewdwfrc3GAloO34C4IrXf8mTjLgw=;
 b=kvtTbusROIlci8WI6xUci/FXfPHdwJ8Ek/exh30iEy9RgbeRAkZBIkL7S+6+tvxbdXQzk31eyG1VkWbkFMcD+y5E7lYjHx3296pVP6L9ECbAKW5H2T6Gnhz9yaK4vjgD3fHIyo5Ayh3YvkyyMlDCToQEaq+Y/e78popbVIXnd+pNPnlpXvw+TEWlxH6IsXGqnIciSS/Yw4RZfr3DQaBiHGu8c47HevSGuQmc76emU6kjakMdsnNnuUWxwKKsS1QdLSsMg7EUPGH1KyZ9wW9DDveNC4JxkPV4ojFT7wFJWvX3jSNjfLeY5oVNzRQhTTcyx3WwgL9g46I5s5Zf3HzcsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQq1ry4gRQx5IDmewdwfrc3GAloO34C4IrXf8mTjLgw=;
 b=Y0BtFSEcAGn9h2mmdZtdHranNo+pWNCoUKv5tY3HH2zGMQ+QAcsvzURzd5C0qlBTO/r9GB8Tlevn/yQX8S4aSmlFZe6CTggdjg8IModBAdGENCN8vFEX7Hh+6+NV52koX+CpHUj4TckYjqQ8XqjO23iDSeeFagiVnpaO2JyR+l0ylmnH8DriMW1kGJqHJSe3kmRLHjlf9tNpTHrWp0SloLlbZvvYrxBRkFho7p8BSglKxzMobQ2m0C+ZDQS8phUTPZvQE4mMZwuJSGuAmOfagjS742H6QqhxtBh+HUWViT9pXqmIQSQH8bntQGamWp7ymzm57Ftt0GaU2zsz+zsQfw==
Received: from BN8PR15CA0030.namprd15.prod.outlook.com (2603:10b6:408:c0::43)
 by MN2PR12MB3934.namprd12.prod.outlook.com (2603:10b6:208:167::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 18:48:08 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::c9) by BN8PR15CA0030.outlook.office365.com
 (2603:10b6:408:c0::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17 via Frontend
 Transport; Mon, 20 Dec 2021 18:48:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 18:48:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 20 Dec
 2021 18:48:07 +0000
Received: from [172.27.13.95] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Mon, 20 Dec 2021
 10:48:05 -0800
Content-Type: multipart/mixed;
        boundary="------------y0kFtnrHNP8U072UIXlh7kat"
Message-ID: <5b001e0f-cec0-112d-533a-d71684eb1d2e@nvidia.com>
Date:   Mon, 20 Dec 2021 20:48:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        "Hannes Reinecke" <hare@suse.de>, Oren Duer <oren@nvidia.com>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
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
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <92c5065e-dc2a-9e3f-404a-64c6e22624b7@kernel.dk>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38a28b54-3aeb-49d0-2cbf-08d9c3e943b4
X-MS-TrafficTypeDiagnostic: MN2PR12MB3934:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3934D5D3F9A588D97C4C7069DE7B9@MN2PR12MB3934.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uOh18NlsQYnF+SFrwyLv4DR5gtOk3QHmoHKyN4v0+YDlAmJegusYQs5wcTHL/RqcKDZh7icia+20E/6gOt80XIXRhrHykkHlh8pRTLkTH02ovLwKl7HD90mmHG9braqGm9WQc93KxFWwZa5dlMLKcEI7jsVVfYZWAYLfW6bbWIB6VSQjeu8avBsyuUgL1lY3nCrxdbe5ChwpfKjUQ4h04p8e5tW4os5Na+pLTCdcy2m1VaRkcFCNQdRHoUlO6U5TGvaLoo+N0AyRWz0Zf5t96s4ck8Sqg0AKxK9+sP/157QZ1gCw0hut1rgEvTajxgDyR6CI0MTSDM4jw+JjGTqAuVc/yvYoQCn8axGK/lQRRMTyNXjNXDQE2nIPxLkA+kABRDytnofeJusZSNjF62QVfNeXFZi1S0hCC9gwnPMm2pTN0Ex44Hg26aj6opVxVXefZeHVz1+7Y1hEJb3ux8q72ivinHyWOlHmmXHB29HUVtcaxqL6DaxIqpoU/2fgOoDCO/4Rq3VsrrjOGxPb9Z9OVRPfeSbBv/+2xFZ8dY6Ys2OGKkm48RwE0s//aPvF2MnPJNSit4p/uwsmdZxwMwygxf7XiCOgNoHgLUqGbRtwyvOMIR1gKNa0zdh9MSGyLahmIue3ZsYjSBV7zHS6JSxqm0uBgrzspbsKUWAJ03K1uXqfdSLhTcAQ0hcDpnI5voA3FakblZ0+x1ZXrktC6FwT2RKwSE6I3MopXH8C8edBS0Qy4mEhI1/sJGcTVbD1QCpXZ+ulC7WB1MUggfSzkGNcOJi+h0514ospLB85kYze9bkM7yvjEFEQxv5jNinJBx9qQ6AmFlMuWmFdLTT9wpWbKWPkbZoKUfSRSRnNRfdDq0=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(26005)(8676002)(34020700004)(2906002)(16526019)(53546011)(186003)(31696002)(235185007)(4326008)(83380400001)(6666004)(316002)(47076005)(356005)(336012)(81166007)(70206006)(110136005)(70586007)(86362001)(36860700001)(508600001)(5660300002)(82310400004)(54906003)(33964004)(2616005)(107886003)(31686004)(40460700001)(426003)(16576012)(8936002)(36756003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 18:48:07.7893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a28b54-3aeb-49d0-2cbf-08d9c3e943b4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3934
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--------------y0kFtnrHNP8U072UIXlh7kat
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


On 12/20/2021 6:34 PM, Jens Axboe wrote:
> On 12/20/21 8:29 AM, Max Gurtovoy wrote:
>> On 12/20/2021 4:19 PM, Jens Axboe wrote:
>>> On 12/20/21 3:11 AM, Max Gurtovoy wrote:
>>>> On 12/19/2021 4:48 PM, Jens Axboe wrote:
>>>>> On 12/19/21 5:14 AM, Max Gurtovoy wrote:
>>>>>> On 12/16/2021 7:16 PM, Jens Axboe wrote:
>>>>>>> On 12/16/21 9:57 AM, Max Gurtovoy wrote:
>>>>>>>> On 12/16/2021 6:36 PM, Jens Axboe wrote:
>>>>>>>>> On 12/16/21 9:34 AM, Max Gurtovoy wrote:
>>>>>>>>>> On 12/16/2021 6:25 PM, Jens Axboe wrote:
>>>>>>>>>>> On 12/16/21 9:19 AM, Max Gurtovoy wrote:
>>>>>>>>>>>> On 12/16/2021 6:05 PM, Jens Axboe wrote:
>>>>>>>>>>>>> On 12/16/21 9:00 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>> On 12/16/2021 5:48 PM, Jens Axboe wrote:
>>>>>>>>>>>>>>> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>>>>>>>>>>>>>>>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>>>>>>>>>>>>>>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>> +	spin_lock(&nvmeq->sq_lock);
>>>>>>>>>>>>>>>>>> +	while (!rq_list_empty(*rqlist)) {
>>>>>>>>>>>>>>>>>> +		struct request *req = rq_list_pop(rqlist);
>>>>>>>>>>>>>>>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>>>>>>>>>>>>>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>>>>>>>>>>>>>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>>>>>>>>>>>>>>>> +			nvmeq->sq_tail = 0;
>>>>>>>>>>>>>>>>> So this doesn't even use the new helper added in patch 2?  I think this
>>>>>>>>>>>>>>>>> should call nvme_sq_copy_cmd().
>>>>>>>>>>>>>>>> I also noticed that.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> So need to decide if to open code it or use the helper function.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Inline helper sounds reasonable if you have 3 places that will use it.
>>>>>>>>>>>>>>> Yes agree, that's been my stance too :-)
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> The rest looks identical to the incremental patch I posted, so I guess
>>>>>>>>>>>>>>>>> the performance degration measured on the first try was a measurement
>>>>>>>>>>>>>>>>> error?
>>>>>>>>>>>>>>>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>>>>>>>>>>>>>>>> algorithm ?
>>>>>>>>>>>>>>> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
>>>>>>>>>>>>>>> in total. I do agree that if we ever made it much larger, then we might
>>>>>>>>>>>>>>> want to cap it differently. But 32 seems like a pretty reasonable number
>>>>>>>>>>>>>>> to get enough gain from the batching done in various areas, while still
>>>>>>>>>>>>>>> not making it so large that we have a potential latency issue. That
>>>>>>>>>>>>>>> batch count is already used consistently for other items too (like tag
>>>>>>>>>>>>>>> allocation), so it's not specific to just this one case.
>>>>>>>>>>>>>> I'm saying that the you can wait to the batch_max_count too long and it
>>>>>>>>>>>>>> won't be efficient from latency POV.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> So it's better to limit the block layar to wait for the first to come: x
>>>>>>>>>>>>>> usecs or batch_max_count before issue queue_rqs.
>>>>>>>>>>>>> There's no waiting specifically for this, it's just based on the plug.
>>>>>>>>>>>>> We just won't do more than 32 in that plug. This is really just an
>>>>>>>>>>>>> artifact of the plugging, and if that should be limited based on "max of
>>>>>>>>>>>>> 32 or xx time", then that should be done there.
>>>>>>>>>>>>>
>>>>>>>>>>>>> But in general I think it's saner and enough to just limit the total
>>>>>>>>>>>>> size. If we spend more than xx usec building up the plug list, we're
>>>>>>>>>>>>> doing something horribly wrong. That really should not happen with 32
>>>>>>>>>>>>> requests, and we'll never eg wait on requests if we're out of tags. That
>>>>>>>>>>>>> will result in a plug flush to begin with.
>>>>>>>>>>>> I'm not aware of the plug. I hope to get to it soon.
>>>>>>>>>>>>
>>>>>>>>>>>> My concern is if the user application submitted only 28 requests and
>>>>>>>>>>>> then you'll wait forever ? or for very long time.
>>>>>>>>>>>>
>>>>>>>>>>>> I guess not, but I'm asking how do you know how to batch and when to
>>>>>>>>>>>> stop in case 32 commands won't arrive anytime soon.
>>>>>>>>>>> The plug is in the stack of the task, so that condition can never
>>>>>>>>>>> happen. If the application originally asks for 32 but then only submits
>>>>>>>>>>> 28, then once that last one is submitted the plug is flushed and
>>>>>>>>>>> requests are issued.
>>>>>>>>>> So if I'm running fio with --iodepth=28 what will plug do ? send batches
>>>>>>>>>> of 28 ? or 1 by 1 ?
>>>>>>>>> --iodepth just controls the overall depth, the batch submit count
>>>>>>>>> dictates what happens further down. If you run queue depth 28 and submit
>>>>>>>>> one at the time, then you'll get one at the time further down too. Hence
>>>>>>>>> the batching is directly driven by what the application is already
>>>>>>>>> doing.
>>>>>>>> I see. Thanks for the explanation.
>>>>>>>>
>>>>>>>> So it works only for io_uring based applications ?
>>>>>>> It's only enabled for io_uring right now, but it's generically available
>>>>>>> for anyone that wants to use it... Would be trivial to do for aio, and
>>>>>>> other spots that currently use blk_start_plug() and has an idea of how
>>>>>>> many IOs will be submitted
>>>>>> Can you please share an example application (or is it fio patches) that
>>>>>> can submit batches ? The same that was used to test this patchset is
>>>>>> fine too.
>>>>>>
>>>>>> I would like to test it with our NVMe SNAP controllers and also to
>>>>>> develop NVMe/RDMA queue_rqs code and test the perf with it.
>>>>> You should just be able to use iodepth_batch with fio. For my peak
>>>>> testing, I use t/io_uring from the fio repo. By default, it'll run QD of
>>>>> and do batches of 32 for complete and submit. You can just run:
>>>>>
>>>>> t/io_uring <dev or file>
>>>>>
>>>>> maybe adding -p0 for IRQ driven rather than polled IO.
>>>> I used your block/for-next branch and implemented queue_rqs in NVMe/RDMA
>>>> but it was never called using the t/io_uring test nor fio with
>>>> iodepth_batch=32 flag with io_uring engine.
>>>>
>>>> Any idea what might be the issue ?
>>>>
>>>> I installed fio from sources..
>>> The two main restrictions right now are a scheduler and shared tags, are
>>> you using any of those?
>> No.
>>
>> But maybe I'm missing the .commit_rqs callback. is it mandatory for this
>> feature ?
> I've only tested with nvme pci which does have it, but I don't think so.
> Unless there's some check somewhere that makes it necessary. Can you
> share the patch you're currently using on top?

The attached POC patches apply cleanly on block/for-next branch

commit 7925bb75e8effa5de85b1cf8425cd5c21f212b1d (block/for-next)
Merge: eb12bde9eba8 3427f2b2c533
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Dec 17 09:51:05 2021 -0700

     Merge branch 'for-5.17/drivers' into for-next

     * for-5.17/drivers:
       block: remove the rsxx driver
       rsxx: Drop PCI legacy power management
       mtip32xx: convert to generic power management
       mtip32xx: remove pointless drvdata lookups
       mtip32xx: remove pointless drvdata checking
       drbd: Use struct_group() to zero algs
       loop: make autoclear operation asynchronous
       null_blk: cast command status to integer
       pktdvd: stop using bdi congestion framework.


--------------y0kFtnrHNP8U072UIXlh7kat
Content-Type: text/plain; charset="UTF-8";
	name="0001-nvme-rdma-prepare-for-queue_rqs-implementation.patch"
Content-Disposition: attachment;
	filename="0001-nvme-rdma-prepare-for-queue_rqs-implementation.patch"
Content-Transfer-Encoding: base64

RnJvbSAwZGUyODM2Y2UyMWRmNjgwMWRiNTgwZTE1NDI5NjU0NGE3NDFiNmM0IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXggR3VydG92b3kgPG1ndXJ0b3ZveUBudmlkaWEu
Y29tPgpEYXRlOiBUaHUsIDIgRGVjIDIwMjEgMTk6NTk6MDAgKzAyMDAKU3ViamVjdDogW1BB
VENIIDEvMl0gbnZtZS1yZG1hOiBwcmVwYXJlIGZvciBxdWV1ZV9ycXMgaW1wbGVtZW50YXRp
b24KClNpZ25lZC1vZmYtYnk6IE1heCBHdXJ0b3ZveSA8bWd1cnRvdm95QG52aWRpYS5jb20+
Ci0tLQogZHJpdmVycy9udm1lL2hvc3QvcmRtYS5jIHwgMTI3ICsrKysrKysrKysrKysrKysr
KysrKysrKysrLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDg0IGluc2VydGlvbnMo
KyksIDQzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZtZS9ob3N0L3Jk
bWEuYyBiL2RyaXZlcnMvbnZtZS9ob3N0L3JkbWEuYwppbmRleCA4NTBmODRkMjA0ZDAuLjJk
NjA4Y2I0ODM5MiAxMDA2NDQKLS0tIGEvZHJpdmVycy9udm1lL2hvc3QvcmRtYS5jCisrKyBi
L2RyaXZlcnMvbnZtZS9ob3N0L3JkbWEuYwpAQCAtNzAsNiArNzAsNyBAQCBzdHJ1Y3QgbnZt
ZV9yZG1hX3JlcXVlc3QgewogCXN0cnVjdCBpYl9zZ2UJCXNnZVsxICsgTlZNRV9SRE1BX01B
WF9JTkxJTkVfU0VHTUVOVFNdOwogCXUzMgkJCW51bV9zZ2U7CiAJc3RydWN0IGliX3JlZ193
cglyZWdfd3I7CisJc3RydWN0IGliX3NlbmRfd3IJc2VuZF93cjsKIAlzdHJ1Y3QgaWJfY3Fl
CQlyZWdfY3FlOwogCXN0cnVjdCBudm1lX3JkbWFfcXVldWUgICpxdWV1ZTsKIAlzdHJ1Y3Qg
bnZtZV9yZG1hX3NnbAlkYXRhX3NnbDsKQEAgLTE2MzUsMzMgKzE2MzYsMzEgQEAgc3RhdGlj
IHZvaWQgbnZtZV9yZG1hX3NlbmRfZG9uZShzdHJ1Y3QgaWJfY3EgKmNxLCBzdHJ1Y3QgaWJf
d2MgKndjKQogCQludm1lX3JkbWFfZW5kX3JlcXVlc3QocmVxKTsKIH0KIAotc3RhdGljIGlu
dCBudm1lX3JkbWFfcG9zdF9zZW5kKHN0cnVjdCBudm1lX3JkbWFfcXVldWUgKnF1ZXVlLAor
c3RhdGljIHZvaWQgbnZtZV9yZG1hX3ByZXBfc2VuZChzdHJ1Y3QgbnZtZV9yZG1hX3F1ZXVl
ICpxdWV1ZSwKIAkJc3RydWN0IG52bWVfcmRtYV9xZSAqcWUsIHN0cnVjdCBpYl9zZ2UgKnNn
ZSwgdTMyIG51bV9zZ2UsCi0JCXN0cnVjdCBpYl9zZW5kX3dyICpmaXJzdCkKKwkJc3RydWN0
IGliX3NlbmRfd3IgKndyKQogewotCXN0cnVjdCBpYl9zZW5kX3dyIHdyOwotCWludCByZXQ7
Ci0KLQlzZ2UtPmFkZHIgICA9IHFlLT5kbWE7CisJc2dlLT5hZGRyID0gcWUtPmRtYTsKIAlz
Z2UtPmxlbmd0aCA9IHNpemVvZihzdHJ1Y3QgbnZtZV9jb21tYW5kKTsKLQlzZ2UtPmxrZXkg
ICA9IHF1ZXVlLT5kZXZpY2UtPnBkLT5sb2NhbF9kbWFfbGtleTsKKwlzZ2UtPmxrZXkgPSBx
dWV1ZS0+ZGV2aWNlLT5wZC0+bG9jYWxfZG1hX2xrZXk7CiAKLQl3ci5uZXh0ICAgICAgID0g
TlVMTDsKLQl3ci53cl9jcWUgICAgID0gJnFlLT5jcWU7Ci0Jd3Iuc2dfbGlzdCAgICA9IHNn
ZTsKLQl3ci5udW1fc2dlICAgID0gbnVtX3NnZTsKLQl3ci5vcGNvZGUgICAgID0gSUJfV1Jf
U0VORDsKLQl3ci5zZW5kX2ZsYWdzID0gSUJfU0VORF9TSUdOQUxFRDsKKwl3ci0+bmV4dCA9
IE5VTEw7CisJd3ItPndyX2NxZSA9ICZxZS0+Y3FlOworCXdyLT5zZ19saXN0ID0gc2dlOwor
CXdyLT5udW1fc2dlID0gbnVtX3NnZTsKKwl3ci0+b3Bjb2RlID0gSUJfV1JfU0VORDsKKwl3
ci0+c2VuZF9mbGFncyA9IElCX1NFTkRfU0lHTkFMRUQ7Cit9CiAKLQlpZiAoZmlyc3QpCi0J
CWZpcnN0LT5uZXh0ID0gJndyOwotCWVsc2UKLQkJZmlyc3QgPSAmd3I7CitzdGF0aWMgaW50
IG52bWVfcmRtYV9wb3N0X3NlbmQoc3RydWN0IG52bWVfcmRtYV9xdWV1ZSAqcXVldWUsCisJ
CXN0cnVjdCBpYl9zZW5kX3dyICp3cikKK3sKKwlpbnQgcmV0OwogCi0JcmV0ID0gaWJfcG9z
dF9zZW5kKHF1ZXVlLT5xcCwgZmlyc3QsIE5VTEwpOworCXJldCA9IGliX3Bvc3Rfc2VuZChx
dWV1ZS0+cXAsIHdyLCBOVUxMKTsKIAlpZiAodW5saWtlbHkocmV0KSkgewogCQlkZXZfZXJy
KHF1ZXVlLT5jdHJsLT5jdHJsLmRldmljZSwKLQkJCSAgICAgIiVzIGZhaWxlZCB3aXRoIGVy
cm9yIGNvZGUgJWRcbiIsIF9fZnVuY19fLCByZXQpOworCQkJIiVzIGZhaWxlZCB3aXRoIGVy
cm9yIGNvZGUgJWRcbiIsIF9fZnVuY19fLCByZXQpOwogCX0KIAlyZXR1cm4gcmV0OwogfQpA
QCAtMTcxNSw2ICsxNzE0LDcgQEAgc3RhdGljIHZvaWQgbnZtZV9yZG1hX3N1Ym1pdF9hc3lu
Y19ldmVudChzdHJ1Y3QgbnZtZV9jdHJsICphcmcpCiAJc3RydWN0IG52bWVfcmRtYV9xZSAq
c3FlID0gJmN0cmwtPmFzeW5jX2V2ZW50X3NxZTsKIAlzdHJ1Y3QgbnZtZV9jb21tYW5kICpj
bWQgPSBzcWUtPmRhdGE7CiAJc3RydWN0IGliX3NnZSBzZ2U7CisJc3RydWN0IGliX3NlbmRf
d3Igd3I7CiAJaW50IHJldDsKIAogCWliX2RtYV9zeW5jX3NpbmdsZV9mb3JfY3B1KGRldiwg
c3FlLT5kbWEsIHNpemVvZigqY21kKSwgRE1BX1RPX0RFVklDRSk7CkBAIC0xNzMwLDcgKzE3
MzAsOCBAQCBzdGF0aWMgdm9pZCBudm1lX3JkbWFfc3VibWl0X2FzeW5jX2V2ZW50KHN0cnVj
dCBudm1lX2N0cmwgKmFyZykKIAlpYl9kbWFfc3luY19zaW5nbGVfZm9yX2RldmljZShkZXYs
IHNxZS0+ZG1hLCBzaXplb2YoKmNtZCksCiAJCQlETUFfVE9fREVWSUNFKTsKIAotCXJldCA9
IG52bWVfcmRtYV9wb3N0X3NlbmQocXVldWUsIHNxZSwgJnNnZSwgMSwgTlVMTCk7CisJbnZt
ZV9yZG1hX3ByZXBfc2VuZChxdWV1ZSwgc3FlLCAmc2dlLCAxLCAmd3IpOworCXJldCA9IG52
bWVfcmRtYV9wb3N0X3NlbmQocXVldWUsICZ3cik7CiAJV0FSTl9PTl9PTkNFKHJldCk7CiB9
CiAKQEAgLTIwMzQsMjcgKzIwMzUsMzUgQEAgbnZtZV9yZG1hX3RpbWVvdXQoc3RydWN0IHJl
cXVlc3QgKnJxLCBib29sIHJlc2VydmVkKQogCXJldHVybiBCTEtfRUhfUkVTRVRfVElNRVI7
CiB9CiAKLXN0YXRpYyBibGtfc3RhdHVzX3QgbnZtZV9yZG1hX3F1ZXVlX3JxKHN0cnVjdCBi
bGtfbXFfaHdfY3R4ICpoY3R4LAotCQljb25zdCBzdHJ1Y3QgYmxrX21xX3F1ZXVlX2RhdGEg
KmJkKQorc3RhdGljIGJsa19zdGF0dXNfdCBudm1lX3JkbWFfY2xlYW51cF9ycShzdHJ1Y3Qg
bnZtZV9yZG1hX3F1ZXVlICpxdWV1ZSwKKwkJc3RydWN0IHJlcXVlc3QgKnJxLCBpbnQgZXJy
KQogewotCXN0cnVjdCBudm1lX25zICpucyA9IGhjdHgtPnF1ZXVlLT5xdWV1ZWRhdGE7Ci0J
c3RydWN0IG52bWVfcmRtYV9xdWV1ZSAqcXVldWUgPSBoY3R4LT5kcml2ZXJfZGF0YTsKLQlz
dHJ1Y3QgcmVxdWVzdCAqcnEgPSBiZC0+cnE7CisJc3RydWN0IG52bWVfcmRtYV9yZXF1ZXN0
ICpyZXEgPSBibGtfbXFfcnFfdG9fcGR1KHJxKTsKKwlibGtfc3RhdHVzX3QgcmV0OworCisJ
bnZtZV9yZG1hX3VubWFwX2RhdGEocXVldWUsIHJxKTsKKwlpZiAoZXJyID09IC1FSU8pCisJ
CXJldCA9IG52bWVfaG9zdF9wYXRoX2Vycm9yKHJxKTsKKwllbHNlIGlmIChlcnIgPT0gLUVO
T01FTSB8fCBlcnIgPT0gLUVBR0FJTikKKwkJcmV0ID0gQkxLX1NUU19SRVNPVVJDRTsKKwll
bHNlCisJCXJldCA9IEJMS19TVFNfSU9FUlI7CisJbnZtZV9jbGVhbnVwX2NtZChycSk7CisJ
aWJfZG1hX3VubWFwX3NpbmdsZShxdWV1ZS0+ZGV2aWNlLT5kZXYsIHJlcS0+c3FlLmRtYSwK
KwkJCSAgICBzaXplb2Yoc3RydWN0IG52bWVfY29tbWFuZCksIERNQV9UT19ERVZJQ0UpOwor
CXJldHVybiByZXQ7Cit9CisKK3N0YXRpYyBibGtfc3RhdHVzX3QgbnZtZV9yZG1hX3ByZXBf
cnEoc3RydWN0IG52bWVfcmRtYV9xdWV1ZSAqcXVldWUsCisJCXN0cnVjdCByZXF1ZXN0ICpy
cSwgc3RydWN0IG52bWVfbnMgKm5zKQoreworCXN0cnVjdCBpYl9kZXZpY2UgKmRldiA9IHF1
ZXVlLT5kZXZpY2UtPmRldjsKIAlzdHJ1Y3QgbnZtZV9yZG1hX3JlcXVlc3QgKnJlcSA9IGJs
a19tcV9ycV90b19wZHUocnEpOwogCXN0cnVjdCBudm1lX3JkbWFfcWUgKnNxZSA9ICZyZXEt
PnNxZTsKIAlzdHJ1Y3QgbnZtZV9jb21tYW5kICpjID0gbnZtZV9yZXEocnEpLT5jbWQ7Ci0J
c3RydWN0IGliX2RldmljZSAqZGV2OwotCWJvb2wgcXVldWVfcmVhZHkgPSB0ZXN0X2JpdChO
Vk1FX1JETUFfUV9MSVZFLCAmcXVldWUtPmZsYWdzKTsKIAlibGtfc3RhdHVzX3QgcmV0Owog
CWludCBlcnI7CiAKLQlXQVJOX09OX09OQ0UocnEtPnRhZyA8IDApOwotCi0JaWYgKCFudm1l
X2NoZWNrX3JlYWR5KCZxdWV1ZS0+Y3RybC0+Y3RybCwgcnEsIHF1ZXVlX3JlYWR5KSkKLQkJ
cmV0dXJuIG52bWVfZmFpbF9ub25yZWFkeV9jb21tYW5kKCZxdWV1ZS0+Y3RybC0+Y3RybCwg
cnEpOwotCi0JZGV2ID0gcXVldWUtPmRldmljZS0+ZGV2OwotCiAJcmVxLT5zcWUuZG1hID0g
aWJfZG1hX21hcF9zaW5nbGUoZGV2LCByZXEtPnNxZS5kYXRhLAogCQkJCQkgc2l6ZW9mKHN0
cnVjdCBudm1lX2NvbW1hbmQpLAogCQkJCQkgRE1BX1RPX0RFVklDRSk7CkBAIC0yMDgzLDgg
KzIwOTIsOCBAQCBzdGF0aWMgYmxrX3N0YXR1c190IG52bWVfcmRtYV9xdWV1ZV9ycShzdHJ1
Y3QgYmxrX21xX2h3X2N0eCAqaGN0eCwKIAllcnIgPSBudm1lX3JkbWFfbWFwX2RhdGEocXVl
dWUsIHJxLCBjKTsKIAlpZiAodW5saWtlbHkoZXJyIDwgMCkpIHsKIAkJZGV2X2VycihxdWV1
ZS0+Y3RybC0+Y3RybC5kZXZpY2UsCi0JCQkgICAgICJGYWlsZWQgdG8gbWFwIGRhdGEgKCVk
KVxuIiwgZXJyKTsKLQkJZ290byBlcnI7CisJCQkiRmFpbGVkIHRvIG1hcCBkYXRhICglZClc
biIsIGVycik7CisJCWdvdG8gb3V0X2VycjsKIAl9CiAKIAlzcWUtPmNxZS5kb25lID0gbnZt
ZV9yZG1hX3NlbmRfZG9uZTsKQEAgLTIwOTIsMTYgKzIxMDEsMTMgQEAgc3RhdGljIGJsa19z
dGF0dXNfdCBudm1lX3JkbWFfcXVldWVfcnEoc3RydWN0IGJsa19tcV9od19jdHggKmhjdHgs
CiAJaWJfZG1hX3N5bmNfc2luZ2xlX2Zvcl9kZXZpY2UoZGV2LCBzcWUtPmRtYSwKIAkJCXNp
emVvZihzdHJ1Y3QgbnZtZV9jb21tYW5kKSwgRE1BX1RPX0RFVklDRSk7CiAKLQllcnIgPSBu
dm1lX3JkbWFfcG9zdF9zZW5kKHF1ZXVlLCBzcWUsIHJlcS0+c2dlLCByZXEtPm51bV9zZ2Us
Ci0JCQlyZXEtPm1yID8gJnJlcS0+cmVnX3dyLndyIDogTlVMTCk7Ci0JaWYgKHVubGlrZWx5
KGVycikpCi0JCWdvdG8gZXJyX3VubWFwOworCW52bWVfcmRtYV9wcmVwX3NlbmQocXVldWUs
IHNxZSwgcmVxLT5zZ2UsIHJlcS0+bnVtX3NnZSwgJnJlcS0+c2VuZF93cik7CisJaWYgKHJl
cS0+bXIpCisJCXJlcS0+cmVnX3dyLndyLm5leHQgPSAmcmVxLT5zZW5kX3dyOwogCiAJcmV0
dXJuIEJMS19TVFNfT0s7CiAKLWVycl91bm1hcDoKLQludm1lX3JkbWFfdW5tYXBfZGF0YShx
dWV1ZSwgcnEpOwotZXJyOgorb3V0X2VycjoKIAlpZiAoZXJyID09IC1FSU8pCiAJCXJldCA9
IG52bWVfaG9zdF9wYXRoX2Vycm9yKHJxKTsKIAllbHNlIGlmIChlcnIgPT0gLUVOT01FTSB8
fCBlcnIgPT0gLUVBR0FJTikKQEAgLTIxMTUsNiArMjEyMSw0MSBAQCBzdGF0aWMgYmxrX3N0
YXR1c190IG52bWVfcmRtYV9xdWV1ZV9ycShzdHJ1Y3QgYmxrX21xX2h3X2N0eCAqaGN0eCwK
IAlyZXR1cm4gcmV0OwogfQogCitzdGF0aWMgYmxrX3N0YXR1c190IG52bWVfcmRtYV9xdWV1
ZV9ycShzdHJ1Y3QgYmxrX21xX2h3X2N0eCAqaGN0eCwKKwkJY29uc3Qgc3RydWN0IGJsa19t
cV9xdWV1ZV9kYXRhICpiZCkKK3sKKwlzdHJ1Y3QgbnZtZV9ucyAqbnMgPSBoY3R4LT5xdWV1
ZS0+cXVldWVkYXRhOworCXN0cnVjdCBudm1lX3JkbWFfcXVldWUgKnF1ZXVlID0gaGN0eC0+
ZHJpdmVyX2RhdGE7CisJc3RydWN0IHJlcXVlc3QgKnJxID0gYmQtPnJxOworCXN0cnVjdCBu
dm1lX3JkbWFfcmVxdWVzdCAqcmVxID0gYmxrX21xX3JxX3RvX3BkdShycSk7CisJYm9vbCBx
dWV1ZV9yZWFkeSA9IHRlc3RfYml0KE5WTUVfUkRNQV9RX0xJVkUsICZxdWV1ZS0+ZmxhZ3Mp
OworCXN0cnVjdCBpYl9zZW5kX3dyICp3cjsKKwlpbnQgZXJyOworCisJV0FSTl9PTl9PTkNF
KHJxLT50YWcgPCAwKTsKKworCWlmICghbnZtZV9jaGVja19yZWFkeSgmcXVldWUtPmN0cmwt
PmN0cmwsIHJxLCBxdWV1ZV9yZWFkeSkpCisJCXJldHVybiBudm1lX2ZhaWxfbm9ucmVhZHlf
Y29tbWFuZCgmcXVldWUtPmN0cmwtPmN0cmwsIHJxKTsKKworCWVyciA9IG52bWVfcmRtYV9w
cmVwX3JxKHF1ZXVlLCBycSwgbnMpOworCWlmICh1bmxpa2VseShlcnIpKQorCQlyZXR1cm4g
ZXJyOworCisJaWYgKHJlcS0+bXIpCisJCXdyID0gJnJlcS0+cmVnX3dyLndyOworCWVsc2UK
KwkJd3IgPSAmcmVxLT5zZW5kX3dyOworCisJZXJyID0gbnZtZV9yZG1hX3Bvc3Rfc2VuZChx
dWV1ZSwgd3IpOworCWlmICh1bmxpa2VseShlcnIpKQorCQlnb3RvIG91dF9jbGVhbnVwX3Jx
OworCisJcmV0dXJuIEJMS19TVFNfT0s7CisKK291dF9jbGVhbnVwX3JxOgorCXJldHVybiBu
dm1lX3JkbWFfY2xlYW51cF9ycShxdWV1ZSwgcnEsIGVycik7Cit9CisKIHN0YXRpYyBpbnQg
bnZtZV9yZG1hX3BvbGwoc3RydWN0IGJsa19tcV9od19jdHggKmhjdHgsIHN0cnVjdCBpb19j
b21wX2JhdGNoICppb2IpCiB7CiAJc3RydWN0IG52bWVfcmRtYV9xdWV1ZSAqcXVldWUgPSBo
Y3R4LT5kcml2ZXJfZGF0YTsKLS0gCjIuMTguMQoK
--------------y0kFtnrHNP8U072UIXlh7kat
Content-Type: text/plain; charset="UTF-8";
	name="0002-nvme-rdma-add-support-for-mq_ops-queue_rqs.patch"
Content-Disposition: attachment;
	filename="0002-nvme-rdma-add-support-for-mq_ops-queue_rqs.patch"
Content-Transfer-Encoding: base64

RnJvbSA4NTFhMWYzNTQyMDIwNmY3YjYzMWQ1ZDEyYjEzNWU1YTdjODRiOTEyIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXggR3VydG92b3kgPG1ndXJ0b3ZveUBudmlkaWEu
Y29tPgpEYXRlOiBNb24sIDIwIERlYyAyMDIxIDIwOjQyOjQ5ICswMjAwClN1YmplY3Q6IFtQ
QVRDSCAyLzJdIG52bWUtcmRtYTogYWRkIHN1cHBvcnQgZm9yIG1xX29wcy0+cXVldWVfcnFz
KCkKClNpZ25lZC1vZmYtYnk6IE1heCBHdXJ0b3ZveSA8bWd1cnRvdm95QG52aWRpYS5jb20+
Ci0tLQogZHJpdmVycy9udm1lL2hvc3QvcmRtYS5jIHwgNzUgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDc1IGluc2VydGlvbnMo
KykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL252bWUvaG9zdC9yZG1hLmMgYi9kcml2ZXJzL252
bWUvaG9zdC9yZG1hLmMKaW5kZXggMmQ2MDhjYjQ4MzkyLi43NjViYjU3ZjBhNTUgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbnZtZS9ob3N0L3JkbWEuYworKysgYi9kcml2ZXJzL252bWUvaG9z
dC9yZG1hLmMKQEAgLTIxMjEsNiArMjEyMSw4MCBAQCBzdGF0aWMgYmxrX3N0YXR1c190IG52
bWVfcmRtYV9wcmVwX3JxKHN0cnVjdCBudm1lX3JkbWFfcXVldWUgKnF1ZXVlLAogCXJldHVy
biByZXQ7CiB9CiAKK3N0YXRpYyBib29sIG52bWVfcmRtYV9wcmVwX3JxX2JhdGNoKHN0cnVj
dCBudm1lX3JkbWFfcXVldWUgKnF1ZXVlLAorCQlzdHJ1Y3QgcmVxdWVzdCAqcnEpCit7CisJ
Ym9vbCBxdWV1ZV9yZWFkeSA9IHRlc3RfYml0KE5WTUVfUkRNQV9RX0xJVkUsICZxdWV1ZS0+
ZmxhZ3MpOworCisJaWYgKHVubGlrZWx5KCFudm1lX2NoZWNrX3JlYWR5KCZxdWV1ZS0+Y3Ry
bC0+Y3RybCwgcnEsIHF1ZXVlX3JlYWR5KSkpCisJCXJldHVybiBmYWxzZTsKKworCXJxLT5t
cV9oY3R4LT50YWdzLT5ycXNbcnEtPnRhZ10gPSBycTsKKwlyZXR1cm4gbnZtZV9yZG1hX3By
ZXBfcnEocXVldWUsIHJxLCBycS0+cS0+cXVldWVkYXRhKSA9PSBCTEtfU1RTX09LOworfQor
CitzdGF0aWMgdm9pZCBudm1lX3JkbWFfc3VibWl0X2NtZHMoc3RydWN0IG52bWVfcmRtYV9x
dWV1ZSAqcXVldWUsCisJCXN0cnVjdCByZXF1ZXN0ICoqcnFsaXN0KQoreworCXN0cnVjdCBy
ZXF1ZXN0ICpmaXJzdF9ycSA9IHJxX2xpc3RfcGVlayhycWxpc3QpOworCXN0cnVjdCBudm1l
X3JkbWFfcmVxdWVzdCAqbnJlcSA9IGJsa19tcV9ycV90b19wZHUoZmlyc3RfcnEpOworCXN0
cnVjdCBpYl9zZW5kX3dyICpmaXJzdCwgKmxhc3QgPSBOVUxMOworCWludCByZXQ7CisKKwlp
ZiAobnJlcS0+bXIpCisJCWZpcnN0ID0gJm5yZXEtPnJlZ193ci53cjsKKwllbHNlCisJCWZp
cnN0ID0gJm5yZXEtPnNlbmRfd3I7CisKKwl3aGlsZSAoIXJxX2xpc3RfZW1wdHkoKnJxbGlz
dCkpIHsKKwkJc3RydWN0IHJlcXVlc3QgKnJxID0gcnFfbGlzdF9wb3AocnFsaXN0KTsKKwkJ
c3RydWN0IG52bWVfcmRtYV9yZXF1ZXN0ICpyZXEgPSBibGtfbXFfcnFfdG9fcGR1KHJxKTsK
KwkJc3RydWN0IGliX3NlbmRfd3IgKnRtcDsKKworCQl0bXAgPSBsYXN0OworCQlsYXN0ID0g
JnJlcS0+c2VuZF93cjsKKwkJaWYgKHRtcCkgeworCQkJaWYgKHJlcS0+bXIpCisJCQkJdG1w
LT5uZXh0ID0gJnJlcS0+cmVnX3dyLndyOworCQkJZWxzZQorCQkJCXRtcC0+bmV4dCA9ICZy
ZXEtPnNlbmRfd3I7CisJCX0KKwl9CisKKwlyZXQgPSBudm1lX3JkbWFfcG9zdF9zZW5kKHF1
ZXVlLCBmaXJzdCk7CisJV0FSTl9PTl9PTkNFKHJldCk7Cit9CisKK3N0YXRpYyB2b2lkIG52
bWVfcmRtYV9xdWV1ZV9ycXMoc3RydWN0IHJlcXVlc3QgKipycWxpc3QpCit7CisJc3RydWN0
IHJlcXVlc3QgKnJlcSA9IHJxX2xpc3RfcGVlayhycWxpc3QpLCAqcHJldiA9IE5VTEw7CisJ
c3RydWN0IHJlcXVlc3QgKnJlcXVldWVfbGlzdCA9IE5VTEw7CisKKwlkbyB7CisJCXN0cnVj
dCBudm1lX3JkbWFfcXVldWUgKnF1ZXVlID0gcmVxLT5tcV9oY3R4LT5kcml2ZXJfZGF0YTsK
KworCQlpZiAoIW52bWVfcmRtYV9wcmVwX3JxX2JhdGNoKHF1ZXVlLCByZXEpKSB7CisJCQkv
KiBkZXRhY2ggJ3JlcScgYW5kIGFkZCB0byByZW1haW5kZXIgbGlzdCAqLworCQkJaWYgKHBy
ZXYpCisJCQkJcHJldi0+cnFfbmV4dCA9IHJlcS0+cnFfbmV4dDsKKwkJCXJxX2xpc3RfYWRk
KCZyZXF1ZXVlX2xpc3QsIHJlcSk7CisJCX0gZWxzZSB7CisJCQlwcmV2ID0gcmVxOworCQl9
CisKKwkJcmVxID0gcnFfbGlzdF9uZXh0KHJlcSk7CisJCWlmICghcmVxIHx8IChwcmV2ICYm
IHJlcS0+bXFfaGN0eCAhPSBwcmV2LT5tcV9oY3R4KSkgeworCQkJLyogZGV0YWNoIHJlc3Qg
b2YgbGlzdCwgYW5kIHN1Ym1pdCAqLworCQkJaWYgKHByZXYpCisJCQkJcHJldi0+cnFfbmV4
dCA9IE5VTEw7CisJCQludm1lX3JkbWFfc3VibWl0X2NtZHMocXVldWUsIHJxbGlzdCk7CisJ
CQkqcnFsaXN0ID0gcmVxOworCQl9CisJfSB3aGlsZSAocmVxKTsKKworCSpycWxpc3QgPSBy
ZXF1ZXVlX2xpc3Q7Cit9CisKIHN0YXRpYyBibGtfc3RhdHVzX3QgbnZtZV9yZG1hX3F1ZXVl
X3JxKHN0cnVjdCBibGtfbXFfaHdfY3R4ICpoY3R4LAogCQljb25zdCBzdHJ1Y3QgYmxrX21x
X3F1ZXVlX2RhdGEgKmJkKQogewpAQCAtMjI1OCw2ICsyMzMyLDcgQEAgc3RhdGljIGludCBu
dm1lX3JkbWFfbWFwX3F1ZXVlcyhzdHJ1Y3QgYmxrX21xX3RhZ19zZXQgKnNldCkKIAogc3Rh
dGljIGNvbnN0IHN0cnVjdCBibGtfbXFfb3BzIG52bWVfcmRtYV9tcV9vcHMgPSB7CiAJLnF1
ZXVlX3JxCT0gbnZtZV9yZG1hX3F1ZXVlX3JxLAorCS5xdWV1ZV9ycXMJPSBudm1lX3JkbWFf
cXVldWVfcnFzLAogCS5jb21wbGV0ZQk9IG52bWVfcmRtYV9jb21wbGV0ZV9ycSwKIAkuaW5p
dF9yZXF1ZXN0CT0gbnZtZV9yZG1hX2luaXRfcmVxdWVzdCwKIAkuZXhpdF9yZXF1ZXN0CT0g
bnZtZV9yZG1hX2V4aXRfcmVxdWVzdCwKLS0gCjIuMTguMQoK
--------------y0kFtnrHNP8U072UIXlh7kat--
