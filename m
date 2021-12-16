Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2C147717E
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 13:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbhLPMR7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 07:17:59 -0500
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:62336
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234080AbhLPMR7 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 16 Dec 2021 07:17:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOt8LBBmCPp/U9WG4yMPDBdvt9Tzzy1DCOT7AWP1jzObCt9C5SUNNFvhagHzIlq9YBHjspOo6s14WIh8XorZi+yc6MDWjlGn5TSg8LGyi4OSPiiqnmNyGyNfiuNW6fxet2NAQ9r66cU/9gdElyMRvJpleiCBPM4PUI+6A6kalGrgJsoKBrzb/O9d82hajkZKGfY+xXSeItuMAT/+T74Yo7V5bRDV2L3lDWtXTQqBRJL6x7tVCfUddC+j7+rrORMDyDh8HHfm41uenOmNZP8sfXiT6foZfapbjT7DmZe208nX5t7V1M9I02ejLmWLeBE4/HBDBVLsg5UWyTRS4n+ebQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yTMwqMMEXh/W6woSgr8MBSnLa5HYl4PWOGn/NE44GY=;
 b=WvwbSg1o3qZK2q58oTDCpa0Qp6bcQLZPE2Ew5FupBBzGc+97OeKGVH3WWuI5U3/kCcCJIPO8f60i5D8z8IyShJLfNcOidmp1NDuZB7HLZWDc74/60mpHLIR1Wjq/JSYLrRUyOQqv7vRwbF7VuSJHo0YAHiKzGmuoXYCemRHAcLrgUXU9MX5eGc9xHYssrH+Iczhnwj3JJyKIs+G91fK/yicFGtAxxqtf9UaSQ7wLB58wUVr6nUiibeHwI8vp3wY82f0lZcCXsotbf+G8T0rFMGoFv7PZEDLNbee25vMppL1G211Haw37dS/3mp5cRCBJ+mpMAHoZDjbMprpWQ+hl0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yTMwqMMEXh/W6woSgr8MBSnLa5HYl4PWOGn/NE44GY=;
 b=ao6t09fs9xsOJToIOWoQhKWIBpfMbX9CLOFYeuLeK6kYBbEf+3TohpHbDEgVnjkc5KniEfFjzTOzlTzitKfbfhe0vGv6b7y9AzWbgCcUaQkLZhYxdWVl2stn+44DHoj2RrEPRKyQ5ofXPtEEkrPn/DWPAhTJxFpLm7v72xjRMaaTo/3U8QhkXR2bI19JWfl7l8IJrA1u6/oXbkJx/1nJR1ERSYrR8guiqCeD1GQZmHPqmUQfR8stboUMsiv8juNt6a2X9wSGcoGxIwbJn6qoZjNz3dcj6vYWvWmpG/gVGpI5KhKA5Imcm+mt3Tx0kVVVbUzTNPMf5QH4IC5NWxxLBw==
Received: from DM6PR02CA0141.namprd02.prod.outlook.com (2603:10b6:5:332::8) by
 DM5PR12MB1739.namprd12.prod.outlook.com (2603:10b6:3:111::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Thu, 16 Dec 2021 12:17:56 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::93) by DM6PR02CA0141.outlook.office365.com
 (2603:10b6:5:332::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17 via Frontend
 Transport; Thu, 16 Dec 2021 12:17:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Thu, 16 Dec 2021 12:17:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Dec
 2021 12:17:55 +0000
Received: from [172.27.15.177] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 16 Dec 2021
 04:17:53 -0800
Message-ID: <0b5e5c58-0a0f-1112-2ecc-23d28bb24e71@nvidia.com>
Date:   Thu, 16 Dec 2021 14:17:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 2/4] nvme: split command copy into a helper
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, <io-uring@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>
CC:     Chaitanya Kulkarni <kch@nvidia.com>, Hannes Reinecke <hare@suse.de>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-3-axboe@kernel.dk>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211215162421.14896-3-axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a511b08-1bc7-4c4d-063f-08d9c08e179a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1739:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1739A32FDF7654A6AB60ED54DE779@DM5PR12MB1739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfs5rb4pD4gKVu9r9O43va7arBdqVtE9iDACebqveiM1UCiuQ3uf6om3Zxs8upuS6rPW1/Dh8dQ2Mf4KHs7xO3gVETgU9xRGHLXFpaOgxgziG5sEpfNuprkvLySOwY1x/3hYTFKw93OC4/0rQYZF7TX0POVczi9/S01miJep1PILv8ZrpJnOSJHGsbitfWWN9/osEqQ0pIf7V/TYnC6STl/CZzh3td8kWb5kBvt3IGgwGxXAyyXLF+qo5BzDGSooyFQNcX7893supw45wvT/KEs7zZqAD7eNLvsgJX5OtcNsPY0SziXsf3RyfktbrKp6KA9ZrBs3iArOjL/zMrsCihTS+0s4TvRJxiog7Xe2rxW0QjSWt9g50zFzDqrIQT2t7+SShky99dWwIDte+e091Ld66hDYj9AxB4zjKHDn7/TWk1OnJ1gXROy8Q0Ky+fsME4MFBKX+VdgLUoK07PDabvrJmbjKuqAV/3w3rE466kejK9vDIIKdkIecwk4qfwCJtSD4Rza9/uy9a5O5F+fE0CgdGYAoQMV939/hLoV5VZNWqVQEi2E7ztC2iEy0y0mot0zJtcsp0niKpsLBQIqim/jxmvj1EIIKVEuMWvfkXOktyzvojozwLxs2t0QryvR/4S0trgEV/Qjg01dtxyEEknkSCeZqlHV316oAjB50tE6YznczSx0BvOPPO9JDx0RrzuUYc/TX4DdGSdRm08+GnjExrVfVqB7MVfGnyGZVQA9gYCU0DGG6/IBqbhbADM/704zv2m1SPpvrfbfuI/gw/ByO8SdvtloNji4uiicjo5LWAnjfJdfzXWppq5Tt+29kB8XgD51sfeDCPg24IyyAS/Ck81gFN6ViJlyjxJq4Rlc=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(31696002)(82310400004)(8676002)(70586007)(34020700004)(83380400001)(53546011)(4326008)(47076005)(426003)(336012)(54906003)(8936002)(110136005)(356005)(70206006)(316002)(86362001)(16576012)(5660300002)(81166007)(31686004)(186003)(26005)(40460700001)(508600001)(16526019)(36756003)(2906002)(36860700001)(2616005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 12:17:56.2401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a511b08-1bc7-4c4d-063f-08d9c08e179a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1739
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 12/15/2021 6:24 PM, Jens Axboe wrote:
> We'll need it for batched submit as well.
>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   drivers/nvme/host/pci.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 8637538f3fd5..09ea21f75439 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -500,6 +500,15 @@ static inline void nvme_write_sq_db(struct nvme_queue *nvmeq, bool write_sq)
>   	nvmeq->last_sq_tail = nvmeq->sq_tail;
>   }
>   
> +static inline void nvme_sq_copy_cmd(struct nvme_queue *nvmeq,
> +				    struct nvme_command *cmd)
> +{
> +	memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes), cmd,
> +		sizeof(*cmd));
> +	if (++nvmeq->sq_tail == nvmeq->q_depth)
> +		nvmeq->sq_tail = 0;
> +}
> +
>   /**
>    * nvme_submit_cmd() - Copy a command into a queue and ring the doorbell
>    * @nvmeq: The queue to use
> @@ -510,10 +519,7 @@ static void nvme_submit_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
>   			    bool write_sq)
>   {
>   	spin_lock(&nvmeq->sq_lock);
> -	memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
> -	       cmd, sizeof(*cmd));
> -	if (++nvmeq->sq_tail == nvmeq->q_depth)
> -		nvmeq->sq_tail = 0;
> +	nvme_sq_copy_cmd(nvmeq, cmd);
>   	nvme_write_sq_db(nvmeq, write_sq);
>   	spin_unlock(&nvmeq->sq_lock);
>   }

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>


