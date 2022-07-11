Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC78570A11
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 20:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiGKSnY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 14:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiGKSnX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 14:43:23 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148222A724
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 11:43:19 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220711184314epoutp02b2a93a4057ad1a9dfcfb96d14cab462c~A2pSZwHcS0381003810epoutp02J
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 18:43:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220711184314epoutp02b2a93a4057ad1a9dfcfb96d14cab462c~A2pSZwHcS0381003810epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657564994;
        bh=pXeT62bJC4pXXYJa/wGy/hvxc2AXMxE1Ay45QknV3XE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pKAnuYys+WCNKOcXHfGXP0qlylUfOxgSzVkwpnsAxQdRw1zLNfsQPKrMy1Szsfy6q
         lKAYyvYD/g9zKhZ0+SOC3DHekTLlH7jD3Y/uSQgESxOrx9BDZS8Dwv5d/5Jsw4Dt5o
         gy8XTFpFz5x+KreoYEm1IHCeLpbYSH1C9IE4Jj9I=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220711184313epcas5p26fe6f8f3bfd8c6d29bc667d48e71438c~A2pRwo2Rs1412814128epcas5p2p;
        Mon, 11 Jul 2022 18:43:13 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LhXnq60yxz4x9Pq; Mon, 11 Jul
        2022 18:43:11 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.DA.09566.F3F6CC26; Tue, 12 Jul 2022 03:43:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220711184311epcas5p13268adbd8e81bfe0bc4bb13affe0f80e~A2pPHc87I0453504535epcas5p15;
        Mon, 11 Jul 2022 18:43:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220711184311epsmtrp24fc17e74bb57d9cfc0c23bc199bda00b~A2pPGXLkO3121931219epsmtrp2e;
        Mon, 11 Jul 2022 18:43:11 +0000 (GMT)
X-AuditID: b6c32a4a-b8dff7000000255e-b4-62cc6f3f2f76
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.85.08802.E3F6CC26; Tue, 12 Jul 2022 03:43:10 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220711184309epsmtip1d75c9e9c08fd24ebadef79c437703ffb~A2pNhHl1X1916819168epsmtip1A;
        Mon, 11 Jul 2022 18:43:09 +0000 (GMT)
Date:   Tue, 12 Jul 2022 00:07:46 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     hch@lst.de, kbusch@kernel.org, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Message-ID: <20220711183746.GA20562@test-zns>
MIME-Version: 1.0
In-Reply-To: <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmuq59/pkkg2d/NC2aJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymHToGqPF3lvaFvOXPWW3WPf6PYsDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHpuX1HvsvtnA5tG3ZRWjx+dNcgEcUdk2GamJKalFCql5yfkpmXnp
        tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBnKimUJeaUAoUCEouLlfTtbIryS0tS
        FTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyMw52tjMVTM6u2PD4KHMD4+uI
        LkZODgkBE4n+lpuMXYxcHEICuxkl2k+/ZIFwPjFKNHy7wwbhfGaUeH63hR2m5czlPUwgtpDA
        LkaJdz98IIqeMUr8PvGIFSTBIqAq8evAYiCbg4NNQFPiwuRSEFNEQEXizZtckHJmgReMEgvn
        LQQrFxZIltj0ZBLYTF4BXYkVz1exQ9iCEidnPmEBsTkF7CW6D5xgA7FFBZQlDmw7zgQySEJg
        C4fErCXzmSGOc5F41v2PDcIWlnh1fAvU0VISn9/thYonS1yaeY4Jwi6ReLznIJRtL9F6qh9s
        DrNApsTMswsZIWw+id7fT5hAHpAQ4JXoaBOCKFeUuDfpKSuELS7xcMYSKNtD4uP8ZnZ4KM49
        u4B1AqPcLCT/zEKyAsK2kuj80MQ6C2gFs4C0xPJ/HBCmpsT6XfoLGFlXMUqmFhTnpqcWmxYY
        5aWWw+M4OT93EyM44Wp57WB8+OCD3iFGJg7GQ4wSHMxKIrx/zp5KEuJNSaysSi3Kjy8qzUkt
        PsRoCoyeicxSosn5wJSfVxJvaGJpYGJmZmZiaWxmqCTO63V1U5KQQHpiSWp2ampBahFMHxMH
        p1QDk5ffraud859pbp2s2/H4w8LXDzjXzVxdKBkk89XqSefk6oWRS5y5JiQvW33O2tOXU8k7
        f+LPhMurZKYdr73xUKhx78oEOWWnD7lfDh+u4Xr07Ibe2yLb1+5lH6XLHUxYWJTsG4IcN3hG
        5c67IhhbJ7EvQtBq/ZfeZlHd96/V67a/LXy4zHRD3IEkGanKNw1zX+j9j7Hf7nhz+xrT5zsM
        rZIvffD+e5DrYujk9k0XWudUpzHuvOSTceWH/626q1K/6hPMD/RcOt4S8uVL66qpobf4rr84
        xpBl/nebu9usky1ZRZtnc5zTFTAU+nLbQjeJLYbz++GM91N7vlhc/NVtuvPeul9yGWxPnD5/
        tSw3kFRiKc5INNRiLipOBAB5MgeUQQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWy7bCSnK5d/pkkg1eTrSyaJvxltpizahuj
        xeq7/WwWNw/sZLJYufook8W71nMsFuffHmaymHToGqPF3lvaFvOXPWW3WPf6PYsDt8fOWXfZ
        Pc7f28jicflsqcemVZ1sHpuX1HvsvtnA5tG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZn383
        sxccyqjom3WXtYFxS1gXIyeHhICJxJnLe5hAbCGBHYwSczocIOLiEs3XfrBD2MISK/89Z4eo
        ecIosfe3NYjNIqAq8evAYtYuRg4ONgFNiQuTS0FMEQEViTdvcrsYuTiYBV4wSly8soUFpFxY
        IFli05NJYKt4BXQlVjxfxQ5SJCTwiVFiw4I7zBAJQYmTM5+ANTALmEnM2/yQGWQos4C0xPJ/
        HCBhTgF7ie4DJ9hAbFEBZYkD244zTWAUnIWkexaS7lkI3QsYmVcxSqYWFOem5xYbFhjlpZbr
        FSfmFpfmpesl5+duYgTHj5bWDsY9qz7oHWJk4mA8xCjBwawkwvvn7KkkId6UxMqq1KL8+KLS
        nNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGphsT/B9eWATZ1ZsZra21mbi3QyW
        /nhLg6JvP6fpTKrnOyXrv1Slpv86Yw1PmOm8E4d+vrbiP35A0Sf9663vpira2hp8x/7v9Dr9
        7nn7NLXdOqoZRb1i2svq2abHNSz4ed/tsfft+2YBjjm9W71X8HZGvKy+xtgVv3t+k2HjqrVN
        /PrS5d8mPd4v4jfr0lrpv9KXNxYzz+hcFVfGlFsp+PXGO9uCx2EdWRw/OA9MDsqSS2p/c/sO
        RzXnD+3ZinLWfhm3XVSfLAt66yOz+J3iy7kMjuxZ+xi4XILXc8VXtEyev6LAv23Jl88XMi7G
        H3jcypngtqHiDy9bnMfJJxcmLbbmap971N/vz1wJnp27VyqxFGckGmoxFxUnAgAGg2d9DgMA
        AA==
X-CMS-MailID: 20220711184311epcas5p13268adbd8e81bfe0bc4bb13affe0f80e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_11beeb_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089
References: <20220711110155.649153-1-joshi.k@samsung.com>
        <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
        <20220711110155.649153-5-joshi.k@samsung.com>
        <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_11beeb_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, Jul 11, 2022 at 04:51:44PM +0300, Sagi Grimberg wrote:
>
>>This heavily reuses nvme-mpath infrastructure for block-path.
>>Block-path operates on bio, and uses that as long-lived object across
>>requeue attempts. For passthrough interface io_uring_cmd happens to
>>be such object, so add a requeue list for that.
>>
>>If path is not available, uring-cmds are added into that list and
>>resubmitted on discovery of new path. Existing requeue handler
>>(nvme_requeue_work) is extended to do this resubmission.
>>
>>For failed commands, failover is done directly (i.e. without first
>>queuing into list) by resubmitting individual command from task-work
>>based callback.
>
>Nice!
>
>>
>>Suggested-by: Sagi Grimberg <sagi@grimberg.me>
>>Co-developed-by: Kanchan Joshi <joshi.k@samsung.com>
>>Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>>---
>>  drivers/nvme/host/ioctl.c     | 141 ++++++++++++++++++++++++++++++++--
>>  drivers/nvme/host/multipath.c |  36 ++++++++-
>>  drivers/nvme/host/nvme.h      |  12 +++
>>  include/linux/io_uring.h      |   2 +
>>  4 files changed, 182 insertions(+), 9 deletions(-)
>>
>>diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
>>index fc02eddd4977..281c21d3c67d 100644
>>--- a/drivers/nvme/host/ioctl.c
>>+++ b/drivers/nvme/host/ioctl.c
>>@@ -340,12 +340,6 @@ struct nvme_uring_data {
>>  	__u32	timeout_ms;
>>  };
>>-static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
>>-		struct io_uring_cmd *ioucmd)
>>-{
>>-	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
>>-}
>>-
>>  static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
>>  {
>>  	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>>@@ -448,6 +442,14 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
>>  	pdu->meta_buffer = nvme_to_user_ptr(d.metadata);
>>  	pdu->meta_len = d.metadata_len;
>>+	if (issue_flags & IO_URING_F_MPATH) {
>>+		req->cmd_flags |= REQ_NVME_MPATH;
>>+		/*
>>+		 * we would need the buffer address (d.addr field) if we have
>>+		 * to retry the command. Store it by repurposing ioucmd->cmd
>>+		 */
>>+		ioucmd->cmd = (void *)d.addr;
>
>What does repurposing mean here?

This field (ioucmd->cmd) was pointing to passthrough command (which
is embedded in SQE of io_uring). At this point we have consumed
passthrough command, so this field can be reused if we have to. And we
have to beceause failover needs recreating passthrough command.
Please see nvme_uring_cmd_io_retry to see how this helps in recreating
the fields of passthrough command. And more on this below.

>>+	}
>>  	blk_execute_rq_nowait(req, false);
>>  	return -EIOCBQUEUED;
>>  }
>>@@ -665,12 +667,135 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
>>  	int srcu_idx = srcu_read_lock(&head->srcu);
>>  	struct nvme_ns *ns = nvme_find_path(head);
>>  	int ret = -EINVAL;
>>+	struct device *dev = &head->cdev_device;
>>+
>>+	if (likely(ns)) {
>>+		ret = nvme_ns_uring_cmd(ns, ioucmd,
>>+				issue_flags | IO_URING_F_MPATH);
>>+	} else if (nvme_available_path(head)) {
>>+		struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>>+		struct nvme_uring_cmd *payload = NULL;
>>+
>>+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
>>+		/*
>>+		 * We may requeue two kinds of uring commands:
>>+		 * 1. command failed post submission. pdu->req will be non-null
>>+		 * for this
>>+		 * 2. command that could not be submitted because path was not
>>+		 * available. For this pdu->req is set to NULL.
>>+		 */
>>+		pdu->req = NULL;
>
>Relying on a pointer does not sound like a good idea to me.
>But why do you care at all where did this command came from?
>This code should not concern itself what happened prior to this
>execution.
Required, please see nvme_uring_cmd_io_retry. And this should be more
clear as part of responses to your other questions.

>>+		/*
>>+		 * passthrough command will not be available during retry as it
>>+		 * is embedded in io_uring's SQE. Hence we allocate/copy here
>>+		 */
>
>OK, that is a nice solution.
Please note that prefered way is to recreate the passthrough command,
and not to allocate it. We allocate it here because this happens very early
(i.e. before processing passthrough command and setting that up inside
struct request). Recreating requires a populated 'struct request' .
>
>>+		payload = kmalloc(sizeof(struct nvme_uring_cmd), GFP_KERNEL);
>>+		if (!payload) {
>>+			ret = -ENOMEM;
>>+			goto out_unlock;
>>+		}
>>+		memcpy(payload, ioucmd->cmd, sizeof(struct nvme_uring_cmd));
>>+		ioucmd->cmd = payload;
>>-	if (ns)
>>-		ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
>>+		spin_lock_irq(&head->requeue_ioucmd_lock);
>>+		ioucmd_list_add(&head->requeue_ioucmd_list, ioucmd);
>>+		spin_unlock_irq(&head->requeue_ioucmd_lock);
>>+		ret = -EIOCBQUEUED;
>>+	} else {
>>+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
>
>ret=-EIO ?
Did not do as it was initialized to -EINVAL. Do you prefer -EIO instead.
>>+	}
>>+out_unlock:
>>  	srcu_read_unlock(&head->srcu, srcu_idx);
>>  	return ret;
>>  }
>>+
>>+int nvme_uring_cmd_io_retry(struct nvme_ns *ns, struct request *oreq,
>>+		struct io_uring_cmd *ioucmd, struct nvme_uring_cmd_pdu *pdu)
>>+{
>>+	struct nvme_ctrl *ctrl = ns->ctrl;
>>+	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
>>+	struct nvme_uring_data d;
>>+	struct nvme_command c;
>>+	struct request *req;
>>+	struct bio *obio = oreq->bio;
>>+	void *meta = NULL;
>>+
>>+	memcpy(&c, nvme_req(oreq)->cmd, sizeof(struct nvme_command));
>>+	d.metadata = (__u64)pdu->meta_buffer;
>>+	d.metadata_len = pdu->meta_len;
>>+	d.timeout_ms = oreq->timeout;
>>+	d.addr = (__u64)ioucmd->cmd;
>>+	if (obio) {
>>+		d.data_len = obio->bi_iter.bi_size;
>>+		blk_rq_unmap_user(obio);
>>+	} else {
>>+		d.data_len = 0;
>>+	}
>>+	blk_mq_free_request(oreq);
>
>The way I would do this that in nvme_ioucmd_failover_req (or in the
>retry driven from command retriable failure) I would do the above,
>requeue it and kick the requeue work, to go over the requeue_list and
>just execute them again. Not sure why you even need an explicit retry
>code.
During retry we need passthrough command. But passthrough command is not
stable (i.e. valid only during first submission). We can make it stable
either by:
(a) allocating in nvme 
(b) return -EAGAIN to io_uring, and it will do allocate + deferral
Both add a cost. And since any command can potentially fail, that
means taking that cost for every IO that we issue on mpath node. Even if
no failure (initial or subsquent after IO) occcured.

So to avoid commmon-path cost, we go about doing nothing (no allocation,
no deferral) in the outset and choose to recreate the passthrough
command if failure occured. Hope this explains the purpose of
nvme_uring_cmd_io_retry?


>>+	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
>>+			d.data_len, nvme_to_user_ptr(d.metadata),
>>+			d.metadata_len, 0, &meta, d.timeout_ms ?
>>+			msecs_to_jiffies(d.timeout_ms) : 0,
>>+			ioucmd->cmd_op == NVME_URING_CMD_IO_VEC, 0, 0);
>>+	if (IS_ERR(req))
>>+		return PTR_ERR(req);
>>+
>>+	req->end_io = nvme_uring_cmd_end_io;
>>+	req->end_io_data = ioucmd;
>>+	pdu->bio = req->bio;
>>+	pdu->meta = meta;
>>+	req->cmd_flags |= REQ_NVME_MPATH;
>>+	blk_execute_rq_nowait(req, false);
>>+	return -EIOCBQUEUED;
>>+}
>>+
>>+void nvme_ioucmd_mpath_retry(struct io_uring_cmd *ioucmd)
>>+{
>>+	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
>>+	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head,
>>+			cdev);
>>+	int srcu_idx = srcu_read_lock(&head->srcu);
>>+	struct nvme_ns *ns = nvme_find_path(head);
>>+	unsigned int issue_flags = IO_URING_F_SQE128 | IO_URING_F_CQE32 |
>>+		IO_URING_F_MPATH;
>>+	struct device *dev = &head->cdev_device;
>>+
>>+	if (likely(ns)) {
>>+		struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>>+		struct request *oreq = pdu->req;
>>+		int ret;
>>+
>>+		if (oreq == NULL) {
>>+			/*
>>+			 * this was not submitted (to device) earlier. For this
>>+			 * ioucmd->cmd points to persistent memory. Free that
>>+			 * up post submission
>>+			 */
>>+			const void *cmd = ioucmd->cmd;
>>+
>>+			ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
>>+			kfree(cmd);
>>+		} else {
>>+			/*
>>+			 * this was submitted (to device) earlier. Use old
>>+			 * request, bio (if it exists) and nvme-pdu to recreate
>>+			 * the command for the discovered path
>>+			 */
>>+			ret = nvme_uring_cmd_io_retry(ns, oreq, ioucmd, pdu);
>
>Why is this needed? Why is reuse important here? Why not always call
>nvme_ns_uring_cmd?

Please see the previous explanation.
If condition is for the case when we made the passthrough command stable
by allocating beforehand.
Else is for the case when we avoided taking that cost.

>>+		}
>>+		if (ret != -EIOCBQUEUED)
>>+			io_uring_cmd_done(ioucmd, ret, 0);
>>+	} else if (nvme_available_path(head)) {
>>+		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
>>+		spin_lock_irq(&head->requeue_ioucmd_lock);
>>+		ioucmd_list_add(&head->requeue_ioucmd_list, ioucmd);
>>+		spin_unlock_irq(&head->requeue_ioucmd_lock);
>>+	} else {
>>+		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
>>+		io_uring_cmd_done(ioucmd, -EINVAL, 0);
>
>-EIO?
Can change -EINVAL to -EIO if that is what you prefer.

>>+	}
>>+	srcu_read_unlock(&head->srcu, srcu_idx);
>>+}
>>  #endif /* CONFIG_NVME_MULTIPATH */
>>  int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
>>diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
>>index f26640ccb955..fe5655d98c36 100644
>>--- a/drivers/nvme/host/multipath.c
>>+++ b/drivers/nvme/host/multipath.c
>>@@ -6,6 +6,7 @@
>>  #include <linux/backing-dev.h>
>>  #include <linux/moduleparam.h>
>>  #include <linux/vmalloc.h>
>>+#include <linux/io_uring.h>
>>  #include <trace/events/block.h>
>>  #include "nvme.h"
>>@@ -80,6 +81,17 @@ void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
>>  			blk_freeze_queue_start(h->disk->queue);
>>  }
>>+static void nvme_ioucmd_failover_req(struct request *req, struct nvme_ns *ns)
>>+{
>>+	struct io_uring_cmd *ioucmd = req->end_io_data;
>>+	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
>>+
>>+	/* store the request, to reconstruct the command during retry */
>>+	pdu->req = req;
>>+	/* retry in original submitter context */
>>+	io_uring_cmd_execute_in_task(ioucmd, nvme_ioucmd_mpath_retry);
>
>Why not deinit the command, put it on the request list and just schedule
>requeue_work? Why not just have requeue_work go over the request list
>and call nvme_ns_head_chr_uring_cmd similar to what it does for block
>requests?
We cannot process passthrough command, map user/meta buffer (in bio) etc. in
worker context. We need to do that in task context. So worker is a
hoop that we try to avoid here. Even if we user worker, we need to
switch to task as we do for other case (i.e. when command could not be
submitted in the first place).

>>+}
>>+
>>  void nvme_failover_req(struct request *req)
>>  {
>>  	struct nvme_ns *ns = req->q->queuedata;
>>@@ -99,6 +111,11 @@ void nvme_failover_req(struct request *req)
>>  		queue_work(nvme_wq, &ns->ctrl->ana_work);
>>  	}
>>+	if (blk_rq_is_passthrough(req)) {
>>+		nvme_ioucmd_failover_req(req, ns);
>>+		return;
>>+	}
>>+
>>  	spin_lock_irqsave(&ns->head->requeue_lock, flags);
>>  	for (bio = req->bio; bio; bio = bio->bi_next) {
>>  		bio_set_dev(bio, ns->head->disk->part0);
>>@@ -314,7 +331,7 @@ inline struct nvme_ns *nvme_find_path(struct nvme_ns_head *head)
>>  	return ns;
>>  }
>>-static bool nvme_available_path(struct nvme_ns_head *head)
>>+bool nvme_available_path(struct nvme_ns_head *head)
>>  {
>>  	struct nvme_ns *ns;
>>@@ -459,7 +476,9 @@ static void nvme_requeue_work(struct work_struct *work)
>>  	struct nvme_ns_head *head =
>>  		container_of(work, struct nvme_ns_head, requeue_work);
>>  	struct bio *bio, *next;
>>+	struct io_uring_cmd *ioucmd, *ioucmd_next;
>>+	/* process requeued bios*/
>>  	spin_lock_irq(&head->requeue_lock);
>>  	next = bio_list_get(&head->requeue_list);
>>  	spin_unlock_irq(&head->requeue_lock);
>>@@ -470,6 +489,21 @@ static void nvme_requeue_work(struct work_struct *work)
>>  		submit_bio_noacct(bio);
>>  	}
>>+
>>+	/* process requeued passthrough-commands */
>>+	spin_lock_irq(&head->requeue_ioucmd_lock);
>>+	ioucmd_next = ioucmd_list_get(&head->requeue_ioucmd_list);
>>+	spin_unlock_irq(&head->requeue_ioucmd_lock);
>>+
>>+	while ((ioucmd = ioucmd_next) != NULL) {
>>+		ioucmd_next = ioucmd->next;
>>+		ioucmd->next = NULL;
>>+		/*
>>+		 * Retry in original submitter context as we would be
>>+		 * processing the passthrough command again
>>+		 */
>>+		io_uring_cmd_execute_in_task(ioucmd, nvme_ioucmd_mpath_retry);
>
>Why retry? why not nvme_ns_head_chr_uring_cmd ?

what nvme_ioucmd_mpath_retry does different is explained above. Putting
that processing inside nvme_ns_head_chr_uring_cmd makes the function too
long and hard to read/understand.


------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_11beeb_
Content-Type: text/plain; charset="utf-8"


------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_11beeb_--
