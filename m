Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65634778F1
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 17:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhLPQ1V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 11:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbhLPQ1V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 11:27:21 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EAAC061574
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:27:21 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id p23so35907810iod.7
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 08:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qMDw/Ym4MY93W1ZOut1ryrQUY01z644mYIMye2TdMQc=;
        b=OlqRPHCDQxzTO+4Z49dOMTkgstsnfEYexXLcpMTIE6BFt5Gv92Fq7midOXm6VLsLVa
         8xe03Zg2AXE2v7iZ3SuE8u3aaUSSBt0PI4T2G0CalRlSeTARiMhZr11POS1OdAle5036
         qguPPMYbf8QvNXIg9tx1MGNlEAvSPOjlrZbBU6A6WkjmKj60CkYQQlSNkSHm2KW3Q1Xl
         XQK3TSw+An3IGWzixVZsRhPFIBMU7OXzT3m4tbnkzePgZ3R9trLBhJfV4Ww7/sA3XRpq
         J+cVlabPiXF9PvrfGhJiatygu92p+moH6iN4FArApuVJMUBMp4wW0r8YeVPaJF4foCbI
         NQhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qMDw/Ym4MY93W1ZOut1ryrQUY01z644mYIMye2TdMQc=;
        b=7U2WY81D/WZ5zRSgMcxCClUkSwC+35qwG23sp4U/1/6UJdBxz40hRm7x6yqkuCbZ3A
         ImmSNzxprhdzPr7j1cPIRo9MBWsr97aeCGPZFETevgVqgnJjd3KR2rBQc4jYs7FcTZqM
         rtO6Il89N5cuEcSnrhUCc96sQeiylYAEOIGndrW9kQZBlpkImYD/k1QtTuFWWtpa4rmc
         Ns5wF55zl/M89SQuvamzOemSgOj9R7wCApFOcdsKa+hZjmY1CaMpwes1W8dsuRCNSla1
         b+5ZmWjsXhp0uIgc53Qa3UK+ZrklJEkFhRj+hOnz9IoDVrr37P0c6L8egLYkpnTisSV2
         wCZQ==
X-Gm-Message-State: AOAM530jdN3PAYFOE3mFmv0HPcd1TcCQf3NjXnK4e9Z6fa2L+65+FJzB
        3DceOBlJAYOBZTWxf35VtgJcAa3dMCPxow==
X-Google-Smtp-Source: ABdhPJxqrGAco0v7zHeMLWnu0MpK/ofMjy9YyEATfskB1hmNfMsioo4Up0kx5s0F5TKamX82maq0jA==
X-Received: by 2002:a05:6638:419f:: with SMTP id az31mr10073608jab.166.1639672040121;
        Thu, 16 Dec 2021 08:27:20 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m6sm2893544ilh.4.2021.12.16.08.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 08:27:19 -0800 (PST)
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
 <83aa4715-7bf8-4ed1-6945-3910cb13f233@kernel.dk>
 <YbtmPjisO5RIAnby@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <db771bc2-4d7a-ee1c-aff7-f8e37dc964d5@kernel.dk>
Date:   Thu, 16 Dec 2021 09:27:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YbtmPjisO5RIAnby@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/21 9:15 AM, Christoph Hellwig wrote:
> On Thu, Dec 16, 2021 at 08:45:46AM -0700, Jens Axboe wrote:
>> On 12/16/21 2:08 AM, Christoph Hellwig wrote:
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
>>>
>>> So this doesn't even use the new helper added in patch 2?  I think this
>>> should call nvme_sq_copy_cmd().
>>
>> But you NAK'ed that one? It definitely should use that helper, so I take it
>> you are fine with it then if we do it here too? That would make 3 call sites,
>> and I still do think the helper makes sense...
> 
> I explained two times that the new helpers is fine as long as you open
> code nvme_submit_cmd in its two callers as it now is a trivial wrapper.

OK, I misunderstood which one you referred to then. So this incremental,
I'll send out a new series...


diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 58d97660374a..51a903d91d92 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -509,21 +509,6 @@ static inline void nvme_sq_copy_cmd(struct nvme_queue *nvmeq,
 		nvmeq->sq_tail = 0;
 }
 
-/**
- * nvme_submit_cmd() - Copy a command into a queue and ring the doorbell
- * @nvmeq: The queue to use
- * @cmd: The command to send
- * @write_sq: whether to write to the SQ doorbell
- */
-static void nvme_submit_cmd(struct nvme_queue *nvmeq, struct nvme_command *cmd,
-			    bool write_sq)
-{
-	spin_lock(&nvmeq->sq_lock);
-	nvme_sq_copy_cmd(nvmeq, cmd);
-	nvme_write_sq_db(nvmeq, write_sq);
-	spin_unlock(&nvmeq->sq_lock);
-}
-
 static void nvme_commit_rqs(struct blk_mq_hw_ctx *hctx)
 {
 	struct nvme_queue *nvmeq = hctx->driver_data;
@@ -977,7 +962,10 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	ret = nvme_prep_rq(dev, req);
 	if (unlikely(ret))
 		return ret;
-	nvme_submit_cmd(nvmeq, &iod->cmd, bd->last);
+	spin_lock(&nvmeq->sq_lock);
+	nvme_sq_copy_cmd(nvmeq, &iod->cmd);
+	nvme_write_sq_db(nvmeq, bd->last);
+	spin_unlock(&nvmeq->sq_lock);
 	return BLK_STS_OK;
 }
 
@@ -1213,7 +1201,11 @@ static void nvme_pci_submit_async_event(struct nvme_ctrl *ctrl)
 
 	c.common.opcode = nvme_admin_async_event;
 	c.common.command_id = NVME_AQ_BLK_MQ_DEPTH;
-	nvme_submit_cmd(nvmeq, &c, true);
+
+	spin_lock(&nvmeq->sq_lock);
+	nvme_sq_copy_cmd(nvmeq, &c);
+	nvme_write_sq_db(nvmeq, true);
+	spin_unlock(&nvmeq->sq_lock);
 }
 
 static int adapter_delete_queue(struct nvme_dev *dev, u8 opcode, u16 id)

-- 
Jens Axboe

