Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84808477687
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbhLPQBv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:01:51 -0500
Received: from mail-mw2nam12on2066.outbound.protection.outlook.com ([40.107.244.66]:23232
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233061AbhLPQBu (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 16 Dec 2021 11:01:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObURbqPP3jrEadOTebPv/d9cMi+Qt4lNe1OogaQL0KfWs25Raoy9xcUaOBK4KVnYbw6F0BQvr2cXIvEkTR/ipNa/VPtb9C9PJdc2Ld0ivu5WGo1wVOnuC/0yUPBgWfc22/JVdlKZgicusUnn/uituYBGEPg9TU2KzZrKnEHauFrrPQWOGHT8niaaixoN1CpyrTSHJtVMD2hAJPNuXm7d8hbXCxNY3QUf4hrcwLXekKksMA/gRhXxMIJ6jj0BJrRFikXLmuTx6IbvyEjCUAmnxmTq7ilUUbGYndErMEocLc9zzBY3GyhTSgkqzDzEfOy+MW+Z7ZD3NMRoAopDmiDHkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6sB5xA2xeDzZWJlwQ20MHtpxaacJ1ZdL36SZMBHtQk=;
 b=nF4axNhD0grlFBDheCfmHeHul5nNDEUxXcr0aHhPQ64Nd3XZWEnS/98hguWm87ndjO/HCNRs/qiPKxDgDhW2N1kCF7EXw9gtRrPaTDnXKQBM8FrA0Zcy/ByShSMdGTgWSB5rfc2GIK4gq3uj7vtv3tAlBKig1ktbr6noqRBlmsBdCxfBqXW0UrspKQo7Hxemi14+GVH6wSqNZjBrzTCxiTaoX4g+OuXxVtUEp7TTTbgt4vU/4NlFWHuhiuTHf70B6Ij0QiCCw2vec/t/8frs45dfMb4GSmGybSd6BlgDyjuamQSnWMsVqBI4eaZjoryzGlcwYq/1kadywXVDp6y1ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6sB5xA2xeDzZWJlwQ20MHtpxaacJ1ZdL36SZMBHtQk=;
 b=Vzfy4TU/XyV4RrZZ2VCNpYrUmLRmU81s8L6waO4NkSmymyJizGk/WqlCGueriKVD42sQZXUy9pXvq3MkBDetjtgWzxgb89AZOQl0Jd21K+sPMiCBRqut30WBZhJVxt2qH3UNbp7HVgJfu7tcBWEG5KzZEgPThROBgZRuJxtbDj26xwm21PDMvqnnWPcKfqQbJt8qcsyPiFTIH/Jt+d7mG7NRKlIEJqPMRcw05qo7qnAbhjJ4LTgX+BMDzytT0Twg1SBdsfC2Cd3+s5IIB9S1wVNrRQmv49H09rwd5ThJqMY57lZZSXk+bGuy4zKGViFk3db5yGwezeFJHqWdsIJgsg==
Received: from CO2PR04CA0090.namprd04.prod.outlook.com (2603:10b6:104:6::16)
 by CH0PR12MB5265.namprd12.prod.outlook.com (2603:10b6:610:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 16 Dec
 2021 16:01:48 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:6:cafe::33) by CO2PR04CA0090.outlook.office365.com
 (2603:10b6:104:6::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16 via Frontend
 Transport; Thu, 16 Dec 2021 16:01:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 16:01:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Dec
 2021 16:01:04 +0000
Received: from [172.27.15.177] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 16 Dec 2021
 08:01:02 -0800
Message-ID: <9b4202b4-192a-6611-922e-0b837e2b97c3@nvidia.com>
Date:   Thu, 16 Dec 2021 18:00:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC:     <io-uring@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        "Hannes Reinecke" <hare@suse.de>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
 <2adafc43-3860-d9f0-9cb5-ca3bf9a27109@nvidia.com>
 <06ab52e6-47b7-6010-524c-45bb73fbfabc@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <06ab52e6-47b7-6010-524c-45bb73fbfabc@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91a4d4f9-8a60-4ffa-0bdd-08d9c0ad5d9e
X-MS-TrafficTypeDiagnostic: CH0PR12MB5265:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5265FDDBD10CA9BD0FB664FBDE779@CH0PR12MB5265.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O7NbjWHt9Y2G1v0gRwW7VZZABGiQE/UE51dfNBz/kExWkAwNM6qL7gzX8PlG2K+b+uSw+fJBAkzSlEXmWgObxDsBVYZFzI+tVexmUwDWvivYCBezwvOXw1BTqf39ar9ESH/Cv3TfyksU3WUpm42aWypGdaANyZ1bkfRAeH3Um3ztWvo/6A0MWTvzvsU6ewIx42fsAwod5+zf6SWeIUimIvS6ql1PEvmt1FldpYrxWG+ID317MK8h+LQIS1jEOJRQjkImxt+U2/vcug6Vkx8amcyyhWV+RwwzE32UwTYuQie2RD0r+ve+doK+PzESJwxd8oLK2NYeqhdB89FeEr4AVvp+oGS9+KVgnF11bCqKQgOOglxilAPEz6lfM7uYLMzwtzTdEb51uNbqNhpXqDylxa+UdOho0hsT4dGGfFZnRN/hNeu2bQ3LuconCV3WQwi8/C9E7KEOI5VTQKt+mW67G7AMyI3AktSK2jeJSV10uQF4AxXKWw46rmn67KF+ooS1QVhwwt9sKONKW+C4bojMmsWmM+8li22E9aPK4CFfqtY6EeAVj0TXxvl/yrHN/4sav0ewSIya7k+04/0DOK815cgxy05Af9g2BltiFfFopiDGXJJXPLgUpIYO8JGyQ8u24zgIcIMM/EPpQVcA30vx5YArRuQcx+QacHiufDVhojvZDie8017wmJkTxnOqZyTCPO0slBGD6b4nxwcBfNv9YsWRMNle7OoDT0TQ5FKflhcYw/q70n3O3BBGpA/5DVHuQQ7h3Fd72oMRg2uwynnpcftvqHXKRkwX1Yl3ahZbYEZN0dvxcYwL4QppQcmN1oajtvSw/sMLhGDpOEfnQiljMOeWgy5QSvrCRw966LnIDbw=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(508600001)(34020700004)(2616005)(356005)(186003)(26005)(86362001)(6666004)(70206006)(36860700001)(8676002)(47076005)(40460700001)(81166007)(83380400001)(16576012)(31686004)(36756003)(2906002)(5660300002)(16526019)(53546011)(426003)(54906003)(82310400004)(70586007)(4326008)(31696002)(8936002)(336012)(316002)(110136005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 16:01:48.1076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a4d4f9-8a60-4ffa-0bdd-08d9c0ad5d9e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5265
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/16/2021 5:48 PM, Jens Axboe wrote:
> On 12/16/21 6:06 AM, Max Gurtovoy wrote:
>> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>>> +	spin_lock(&nvmeq->sq_lock);
>>>> +	while (!rq_list_empty(*rqlist)) {
>>>> +		struct request *req = rq_list_pop(rqlist);
>>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>>> +
>>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>>> +			nvmeq->sq_tail = 0;
>>> So this doesn't even use the new helper added in patch 2?  I think this
>>> should call nvme_sq_copy_cmd().
>> I also noticed that.
>>
>> So need to decide if to open code it or use the helper function.
>>
>> Inline helper sounds reasonable if you have 3 places that will use it.
> Yes agree, that's been my stance too :-)
>
>>> The rest looks identical to the incremental patch I posted, so I guess
>>> the performance degration measured on the first try was a measurement
>>> error?
>> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
>>
>> But how do you moderate it ? what is the batch_sz <--> time_to_wait
>> algorithm ?
> The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
> in total. I do agree that if we ever made it much larger, then we might
> want to cap it differently. But 32 seems like a pretty reasonable number
> to get enough gain from the batching done in various areas, while still
> not making it so large that we have a potential latency issue. That
> batch count is already used consistently for other items too (like tag
> allocation), so it's not specific to just this one case.

I'm saying that the you can wait to the batch_max_count too long and it 
won't be efficient from latency POV.

So it's better to limit the block layar to wait for the first to come: x 
usecs or batch_max_count before issue queue_rqs.

Also, This batch is per HW queue or SW queue or the entire request queue ?

>
