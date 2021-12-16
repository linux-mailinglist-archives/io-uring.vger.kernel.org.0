Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C709147728D
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 14:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbhLPNCc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 08:02:32 -0500
Received: from mail-bn8nam12on2059.outbound.protection.outlook.com ([40.107.237.59]:21323
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237173AbhLPNCc (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 16 Dec 2021 08:02:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMVYuaf49YWsMq3GuPNs43m4SdM0n7ZtHDoHvPamFx75TtE5YKyqPNNZYzEvaRVtdpLYq9lgHXqoaeYJJiKG1VkYG8OQIMh9TQqIyjsQtJ/RmOI2yOJtzzNxtxti2RpGoFP3B2UMv8UMCoxMLsV54PDJ4knlPuRwpL8xjqJUdQZS9rIpjCsNGKplTYJuh+gS3+gSJP/6ncLCpgOQMtum3R+AIznIQirv96IUGi/23a3iN4sxm3j48etb83DFuAfdsPgnk3kyRAfWsi6aPgfVaVlrGyoWVv3IUUQKQ9wzENrU5UHvXxFoD9TBuiN5Fp0+PcydtCsstwKn32nUvZOwWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F6QGeFy/4zn9ofkcstPcG6vAphCT1fi1rc6byDVd00w=;
 b=Dxi7qr2w6tVsED2I20pmj0B5mnfLuF+OPja17i0pVSc66j79qPibWFQdW/L15A6sa1293J4/BWkl+OsFhYTO5fkRrhVNjwAVIw+rsKMLDAWN5edUUmCw2TrCBJRJyRQbU5RvtporSjxByKLRcQYCE3QdraoCwDi1Wnokm0jZ+CibsMf7Xk+w6+6WYpggzn1PnaT80mn+btVdp4Ty9jGwIOkI2iosPkI24tn0a1imwC4kUnBa2nIZ/xhltJ7gap/e2Cwdt5flKNF95ufyx8W2KWuQNYUvtiWUhH7HuldloYwz8owvrWE2OS4RwOQfXNAdo75ycJujqM/IqLuysrmCHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6QGeFy/4zn9ofkcstPcG6vAphCT1fi1rc6byDVd00w=;
 b=pbSZoTLjkXjUCMSru5GI5MP/hTfpCy/2bGJEtIQ4Zrb7RLbs5mDWVG6x3N4tyLrCupexZ3+eMGUGgmzsVZt7Yd5cgqGqw2e60HCD03Lan8BD9xpTVpMSKGfMERPAgSBi1AXKvpbmR/nmMhL3XiGI/mlaDwlSXGpnVGSPiLQ3sAj7N/L7eNIrEYU/IfEzVh8ZeHYgy7ZWsdi0ZskwmiXCsq0ge8KKIssD4eJKYB4Q8iTBQS2mYhzjKwIUsGSsPMkwZHUu3PgOGcKKts8ZGsCdpxCi+78/Ng/JL3NAuW6ZBxgp6WE9UCL8Q7LwV/ZRVAks67n9WZsjSmkphVEPut4X+w==
Received: from DM6PR08CA0061.namprd08.prod.outlook.com (2603:10b6:5:1e0::35)
 by CH2PR12MB4229.namprd12.prod.outlook.com (2603:10b6:610:a5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 13:02:30 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::8e) by DM6PR08CA0061.outlook.office365.com
 (2603:10b6:5:1e0::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Thu, 16 Dec 2021 13:02:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 13:02:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Dec
 2021 13:02:29 +0000
Received: from [172.27.15.177] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 16 Dec 2021
 05:02:27 -0800
Message-ID: <0c131172-54cf-29f9-8fc6-53582ad50402@nvidia.com>
Date:   Thu, 16 Dec 2021 15:02:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, <io-uring@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>
CC:     Hannes Reinecke <hare@suse.de>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211215162421.14896-5-axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94b53197-4679-40e9-db1b-08d9c0945167
X-MS-TrafficTypeDiagnostic: CH2PR12MB4229:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB42295F011D3B9238F541001ADE779@CH2PR12MB4229.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XfJO+RuhQkEZIpB21yz68bc1tCLpvUnLEAWD27LJRs/PkXcYwn20dgIJrCGA/bE3YYRjP22RaAAp44RaCOjclGpk9GzJeVV7KxL5UaoNA5/XfqOPqugaA0UhCFW8aIAlNN2HvmTSPayP57YIWnMmSCiFdFlDaOIXCFyNMx+J1A5utc65qk4abyKcxQoTrzxOdwVQ7xCxGJG6iUadTRO0egWXU/8E74+SehcjBksTx+J8nikov5svUCUhZP5+n8i8zjpjvQVJ62Ids9Isl9KALTH3Ci86j2XdNuIi+u7JcAmAE7ojJLTaHjk627heEvM+TO49uaAQI5d6HtXCM9t8ThrcrxLsC1u5+gSq5ISiLzSoIVRLqv+Yy4cuNUg9OZGK1DVPchFzn9omyl25ImBkYQI0fvsb8Vq7P+LVOfbxVEOgWzAkScy9vo09/4vLvTvbYBDobJRBLGbiXK+mtG3xMhOwpk1dB3OhWdsIkGSheX9GFOlKNcYSJrnM3jEN5shu1dsSl2RhMVtYop2TQ4tOGfnSrOfUEw6HuhNstcycEg0qGsXxFUKe7c9oJ4TwChemPXoSvU9qSQ1GNKTwEB4bo+yZMN2rWBYIFWAvy+i2ElE+WRGPGR96IyHFsJynPNdGRkeymU0Iy4f1nEqTvP1Ibwt+wH/bQp9TeTFB3gQ66BYGVkseYn0NyWrI5S0PwuDUhHMm7hwAZBgcR5tkQC3LnnJwc47n5GkU4mu5c1nVB4wCp1J3k+p+K4BOLBNIPp0X75XjDrd10sMWU6yo0Ka0ZdwDsKy6jtNZeg4Axgp3BVD6GuPsMhuclVJwZZX4vEUYUtQjTXPFIHVAJXEA6XDhcNOj9GPIprlQrWJ/Ou/fcVeyegPzXaZjJNsoq3WsRYOGdI4qTNYXcNmXj11FX3dLCQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(16526019)(316002)(8936002)(16576012)(81166007)(186003)(2906002)(82310400004)(47076005)(34020700004)(26005)(356005)(508600001)(31696002)(83380400001)(8676002)(70206006)(70586007)(40460700001)(110136005)(4326008)(6666004)(5660300002)(31686004)(336012)(36756003)(2616005)(36860700001)(86362001)(53546011)(426003)(219204002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 13:02:30.1995
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b53197-4679-40e9-db1b-08d9c0945167
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4229
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/15/2021 6:24 PM, Jens Axboe wrote:
> This enables the block layer to send us a full plug list of requests
> that need submitting. The block layer guarantees that they all belong
> to the same queue, but we do have to check the hardware queue mapping
> for each request.
>
> If errors are encountered, leave them in the passed in list. Then the
> block layer will handle them individually.
>
> This is good for about a 4% improvement in peak performance, taking us
> from 9.6M to 10M IOPS/core.
>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   drivers/nvme/host/pci.c | 61 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 61 insertions(+)
>
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 6be6b1ab4285..197aa45ef7ef 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -981,6 +981,66 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	return BLK_STS_OK;
>   }
>   
> +static void nvme_submit_cmds(struct nvme_queue *nvmeq, struct request **rqlist)
> +{
> +	spin_lock(&nvmeq->sq_lock);
> +	while (!rq_list_empty(*rqlist)) {
> +		struct request *req = rq_list_pop(rqlist);
> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> +
> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
> +			nvmeq->sq_tail = 0;
> +	}
> +	nvme_write_sq_db(nvmeq, true);
> +	spin_unlock(&nvmeq->sq_lock);
> +}
> +
> +static bool nvme_prep_rq_batch(struct nvme_queue *nvmeq, struct request *req)
> +{
> +	/*
> +	 * We should not need to do this, but we're still using this to
> +	 * ensure we can drain requests on a dying queue.
> +	 */
> +	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
> +		return false;
> +	if (unlikely(!nvme_check_ready(&nvmeq->dev->ctrl, req, true)))
> +		return false;
> +
> +	req->mq_hctx->tags->rqs[req->tag] = req;
> +	return nvme_prep_rq(nvmeq->dev, req) == BLK_STS_OK;
> +}
> +
> +static void nvme_queue_rqs(struct request **rqlist)
> +{
> +	struct request *req = rq_list_peek(rqlist), *prev = NULL;
> +	struct request *requeue_list = NULL;
> +
> +	do {
> +		struct nvme_queue *nvmeq = req->mq_hctx->driver_data;
> +
> +		if (!nvme_prep_rq_batch(nvmeq, req)) {
> +			/* detach 'req' and add to remainder list */
> +			if (prev)
> +				prev->rq_next = req->rq_next;
> +			rq_list_add(&requeue_list, req);
> +		} else {
> +			prev = req;
> +		}
> +
> +		req = rq_list_next(req);
> +		if (!req || (prev && req->mq_hctx != prev->mq_hctx)) {
> +			/* detach rest of list, and submit */
> +			prev->rq_next = NULL;

if req == NULL and prev == NULL we'll get a NULL deref here.

I think this can happen in the first iteration.

Correct me if I'm wrong..

> +			nvme_submit_cmds(nvmeq, rqlist);
> +			*rqlist = req;
> +		}
> +	} while (req);
> +
> +	*rqlist = requeue_list;
> +}
> +
>   static __always_inline void nvme_pci_unmap_rq(struct request *req)
>   {
>   	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
> @@ -1678,6 +1738,7 @@ static const struct blk_mq_ops nvme_mq_admin_ops = {
>   
>   static const struct blk_mq_ops nvme_mq_ops = {
>   	.queue_rq	= nvme_queue_rq,
> +	.queue_rqs	= nvme_queue_rqs,
>   	.complete	= nvme_pci_complete_rq,
>   	.commit_rqs	= nvme_commit_rqs,
>   	.init_hctx	= nvme_init_hctx,
