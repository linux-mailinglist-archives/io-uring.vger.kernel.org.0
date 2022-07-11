Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A365704A6
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 15:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiGKNvv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 09:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGKNvu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 09:51:50 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747235C97B;
        Mon, 11 Jul 2022 06:51:48 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id v14so7111325wra.5;
        Mon, 11 Jul 2022 06:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=N7rRbb6nka5HiUHDU/ccuKUixNcP1c08BJkGM69nChc=;
        b=YKjorxTbBK9mvsIW6kDGwz2YmctIA8NH9nh4K0C6rbec0OC25BMrX738xYYpRICVgh
         +FJWRhMgLgAGf0MBnbxie1AJy/reX7hrXoFsPXQoU/FTv+jsXCQrT6wFHHKT/NIgULHG
         uBT++0lwGGJnh6OwzqNj5B1jOhPDmkIKQrYYgf1sekKgBUxjZyWjRjV6kg/ppKZwIx8g
         y2bxON9/AT+3CkgABzuJwe5JZQLe9TfzLoSv9fmRhPIYpuaora3bkVWfOwUXvOb8O+2M
         KKK6Hw9VOit5BDa7Ns50FqLKWOiO/5B+Qb0l4DJU0fqA4JzRvi1Y3xv/YIRuGenGS9og
         nGCA==
X-Gm-Message-State: AJIora9A+izbWwpvVFkVbbN4tE6BR6PTIBaSpOG2uzQz4lwbphUZe6vP
        1/ezOUW7QIYsPqJcMa/sMD7U+GPv2Ec=
X-Google-Smtp-Source: AGRyM1v0EtOACSU5LddrZs2DRP3avMNqMJhioGo1Y6mdJD4n7+BrV0xErCGzVCeEJmnAqZvSGcg2tA==
X-Received: by 2002:a5d:4fd1:0:b0:21d:64c6:8b0f with SMTP id h17-20020a5d4fd1000000b0021d64c68b0fmr17464963wrw.250.1657547506786;
        Mon, 11 Jul 2022 06:51:46 -0700 (PDT)
Received: from [192.168.64.180] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id 187-20020a1c19c4000000b003a044fe7fe7sm6905939wmz.9.2022.07.11.06.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 06:51:46 -0700 (PDT)
Message-ID: <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
Date:   Mon, 11 Jul 2022 16:51:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, kbusch@kernel.org,
        axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
 <20220711110155.649153-5-joshi.k@samsung.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20220711110155.649153-5-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> This heavily reuses nvme-mpath infrastructure for block-path.
> Block-path operates on bio, and uses that as long-lived object across
> requeue attempts. For passthrough interface io_uring_cmd happens to
> be such object, so add a requeue list for that.
> 
> If path is not available, uring-cmds are added into that list and
> resubmitted on discovery of new path. Existing requeue handler
> (nvme_requeue_work) is extended to do this resubmission.
> 
> For failed commands, failover is done directly (i.e. without first
> queuing into list) by resubmitting individual command from task-work
> based callback.

Nice!

> 
> Suggested-by: Sagi Grimberg <sagi@grimberg.me>
> Co-developed-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>   drivers/nvme/host/ioctl.c     | 141 ++++++++++++++++++++++++++++++++--
>   drivers/nvme/host/multipath.c |  36 ++++++++-
>   drivers/nvme/host/nvme.h      |  12 +++
>   include/linux/io_uring.h      |   2 +
>   4 files changed, 182 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index fc02eddd4977..281c21d3c67d 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c
> @@ -340,12 +340,6 @@ struct nvme_uring_data {
>   	__u32	timeout_ms;
>   };
>   
> -static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
> -		struct io_uring_cmd *ioucmd)
> -{
> -	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
> -}
> -
>   static void nvme_uring_task_cb(struct io_uring_cmd *ioucmd)
>   {
>   	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> @@ -448,6 +442,14 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
>   	pdu->meta_buffer = nvme_to_user_ptr(d.metadata);
>   	pdu->meta_len = d.metadata_len;
>   
> +	if (issue_flags & IO_URING_F_MPATH) {
> +		req->cmd_flags |= REQ_NVME_MPATH;
> +		/*
> +		 * we would need the buffer address (d.addr field) if we have
> +		 * to retry the command. Store it by repurposing ioucmd->cmd
> +		 */
> +		ioucmd->cmd = (void *)d.addr;

What does repurposing mean here?

> +	}
>   	blk_execute_rq_nowait(req, false);
>   	return -EIOCBQUEUED;
>   }
> @@ -665,12 +667,135 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
>   	int srcu_idx = srcu_read_lock(&head->srcu);
>   	struct nvme_ns *ns = nvme_find_path(head);
>   	int ret = -EINVAL;
> +	struct device *dev = &head->cdev_device;
> +
> +	if (likely(ns)) {
> +		ret = nvme_ns_uring_cmd(ns, ioucmd,
> +				issue_flags | IO_URING_F_MPATH);
> +	} else if (nvme_available_path(head)) {
> +		struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> +		struct nvme_uring_cmd *payload = NULL;
> +
> +		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
> +		/*
> +		 * We may requeue two kinds of uring commands:
> +		 * 1. command failed post submission. pdu->req will be non-null
> +		 * for this
> +		 * 2. command that could not be submitted because path was not
> +		 * available. For this pdu->req is set to NULL.
> +		 */
> +		pdu->req = NULL;

Relying on a pointer does not sound like a good idea to me.
But why do you care at all where did this command came from?
This code should not concern itself what happened prior to this
execution.

> +		/*
> +		 * passthrough command will not be available during retry as it
> +		 * is embedded in io_uring's SQE. Hence we allocate/copy here
> +		 */

OK, that is a nice solution.

> +		payload = kmalloc(sizeof(struct nvme_uring_cmd), GFP_KERNEL);
> +		if (!payload) {
> +			ret = -ENOMEM;
> +			goto out_unlock;
> +		}
> +		memcpy(payload, ioucmd->cmd, sizeof(struct nvme_uring_cmd));
> +		ioucmd->cmd = payload;
>   
> -	if (ns)
> -		ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
> +		spin_lock_irq(&head->requeue_ioucmd_lock);
> +		ioucmd_list_add(&head->requeue_ioucmd_list, ioucmd);
> +		spin_unlock_irq(&head->requeue_ioucmd_lock);
> +		ret = -EIOCBQUEUED;
> +	} else {
> +		dev_warn_ratelimited(dev, "no available path - failing I/O\n");

ret=-EIO ?

> +	}
> +out_unlock:
>   	srcu_read_unlock(&head->srcu, srcu_idx);
>   	return ret;
>   }
> +
> +int nvme_uring_cmd_io_retry(struct nvme_ns *ns, struct request *oreq,
> +		struct io_uring_cmd *ioucmd, struct nvme_uring_cmd_pdu *pdu)
> +{
> +	struct nvme_ctrl *ctrl = ns->ctrl;
> +	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
> +	struct nvme_uring_data d;
> +	struct nvme_command c;
> +	struct request *req;
> +	struct bio *obio = oreq->bio;
> +	void *meta = NULL;
> +
> +	memcpy(&c, nvme_req(oreq)->cmd, sizeof(struct nvme_command));
> +	d.metadata = (__u64)pdu->meta_buffer;
> +	d.metadata_len = pdu->meta_len;
> +	d.timeout_ms = oreq->timeout;
> +	d.addr = (__u64)ioucmd->cmd;
> +	if (obio) {
> +		d.data_len = obio->bi_iter.bi_size;
> +		blk_rq_unmap_user(obio);
> +	} else {
> +		d.data_len = 0;
> +	}
> +	blk_mq_free_request(oreq);

The way I would do this that in nvme_ioucmd_failover_req (or in the
retry driven from command retriable failure) I would do the above,
requeue it and kick the requeue work, to go over the requeue_list and
just execute them again. Not sure why you even need an explicit retry
code.

> +	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(d.addr),
> +			d.data_len, nvme_to_user_ptr(d.metadata),
> +			d.metadata_len, 0, &meta, d.timeout_ms ?
> +			msecs_to_jiffies(d.timeout_ms) : 0,
> +			ioucmd->cmd_op == NVME_URING_CMD_IO_VEC, 0, 0);
> +	if (IS_ERR(req))
> +		return PTR_ERR(req);
> +
> +	req->end_io = nvme_uring_cmd_end_io;
> +	req->end_io_data = ioucmd;
> +	pdu->bio = req->bio;
> +	pdu->meta = meta;
> +	req->cmd_flags |= REQ_NVME_MPATH;
> +	blk_execute_rq_nowait(req, false);
> +	return -EIOCBQUEUED;
> +}
> +
> +void nvme_ioucmd_mpath_retry(struct io_uring_cmd *ioucmd)
> +{
> +	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
> +	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head,
> +			cdev);
> +	int srcu_idx = srcu_read_lock(&head->srcu);
> +	struct nvme_ns *ns = nvme_find_path(head);
> +	unsigned int issue_flags = IO_URING_F_SQE128 | IO_URING_F_CQE32 |
> +		IO_URING_F_MPATH;
> +	struct device *dev = &head->cdev_device;
> +
> +	if (likely(ns)) {
> +		struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> +		struct request *oreq = pdu->req;
> +		int ret;
> +
> +		if (oreq == NULL) {
> +			/*
> +			 * this was not submitted (to device) earlier. For this
> +			 * ioucmd->cmd points to persistent memory. Free that
> +			 * up post submission
> +			 */
> +			const void *cmd = ioucmd->cmd;
> +
> +			ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
> +			kfree(cmd);
> +		} else {
> +			/*
> +			 * this was submitted (to device) earlier. Use old
> +			 * request, bio (if it exists) and nvme-pdu to recreate
> +			 * the command for the discovered path
> +			 */
> +			ret = nvme_uring_cmd_io_retry(ns, oreq, ioucmd, pdu);

Why is this needed? Why is reuse important here? Why not always call
nvme_ns_uring_cmd?

> +		}
> +		if (ret != -EIOCBQUEUED)
> +			io_uring_cmd_done(ioucmd, ret, 0);
> +	} else if (nvme_available_path(head)) {
> +		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
> +		spin_lock_irq(&head->requeue_ioucmd_lock);
> +		ioucmd_list_add(&head->requeue_ioucmd_list, ioucmd);
> +		spin_unlock_irq(&head->requeue_ioucmd_lock);
> +	} else {
> +		dev_warn_ratelimited(dev, "no available path - failing I/O\n");
> +		io_uring_cmd_done(ioucmd, -EINVAL, 0);

-EIO?

> +	}
> +	srcu_read_unlock(&head->srcu, srcu_idx);
> +}
>   #endif /* CONFIG_NVME_MULTIPATH */
>   
>   int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index f26640ccb955..fe5655d98c36 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -6,6 +6,7 @@
>   #include <linux/backing-dev.h>
>   #include <linux/moduleparam.h>
>   #include <linux/vmalloc.h>
> +#include <linux/io_uring.h>
>   #include <trace/events/block.h>
>   #include "nvme.h"
>   
> @@ -80,6 +81,17 @@ void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
>   			blk_freeze_queue_start(h->disk->queue);
>   }
>   
> +static void nvme_ioucmd_failover_req(struct request *req, struct nvme_ns *ns)
> +{
> +	struct io_uring_cmd *ioucmd = req->end_io_data;
> +	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
> +
> +	/* store the request, to reconstruct the command during retry */
> +	pdu->req = req;
> +	/* retry in original submitter context */
> +	io_uring_cmd_execute_in_task(ioucmd, nvme_ioucmd_mpath_retry);

Why not deinit the command, put it on the request list and just schedule
requeue_work? Why not just have requeue_work go over the request list
and call nvme_ns_head_chr_uring_cmd similar to what it does for block
requests?

> +}
> +
>   void nvme_failover_req(struct request *req)
>   {
>   	struct nvme_ns *ns = req->q->queuedata;
> @@ -99,6 +111,11 @@ void nvme_failover_req(struct request *req)
>   		queue_work(nvme_wq, &ns->ctrl->ana_work);
>   	}
>   
> +	if (blk_rq_is_passthrough(req)) {
> +		nvme_ioucmd_failover_req(req, ns);
> +		return;
> +	}
> +
>   	spin_lock_irqsave(&ns->head->requeue_lock, flags);
>   	for (bio = req->bio; bio; bio = bio->bi_next) {
>   		bio_set_dev(bio, ns->head->disk->part0);
> @@ -314,7 +331,7 @@ inline struct nvme_ns *nvme_find_path(struct nvme_ns_head *head)
>   	return ns;
>   }
>   
> -static bool nvme_available_path(struct nvme_ns_head *head)
> +bool nvme_available_path(struct nvme_ns_head *head)
>   {
>   	struct nvme_ns *ns;
>   
> @@ -459,7 +476,9 @@ static void nvme_requeue_work(struct work_struct *work)
>   	struct nvme_ns_head *head =
>   		container_of(work, struct nvme_ns_head, requeue_work);
>   	struct bio *bio, *next;
> +	struct io_uring_cmd *ioucmd, *ioucmd_next;
>   
> +	/* process requeued bios*/
>   	spin_lock_irq(&head->requeue_lock);
>   	next = bio_list_get(&head->requeue_list);
>   	spin_unlock_irq(&head->requeue_lock);
> @@ -470,6 +489,21 @@ static void nvme_requeue_work(struct work_struct *work)
>   
>   		submit_bio_noacct(bio);
>   	}
> +
> +	/* process requeued passthrough-commands */
> +	spin_lock_irq(&head->requeue_ioucmd_lock);
> +	ioucmd_next = ioucmd_list_get(&head->requeue_ioucmd_list);
> +	spin_unlock_irq(&head->requeue_ioucmd_lock);
> +
> +	while ((ioucmd = ioucmd_next) != NULL) {
> +		ioucmd_next = ioucmd->next;
> +		ioucmd->next = NULL;
> +		/*
> +		 * Retry in original submitter context as we would be
> +		 * processing the passthrough command again
> +		 */
> +		io_uring_cmd_execute_in_task(ioucmd, nvme_ioucmd_mpath_retry);

Why retry? why not nvme_ns_head_chr_uring_cmd ?

> +	}
>   }
>   
>   int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> index 9d3ff6feda06..125b48e74e72 100644
> --- a/drivers/nvme/host/nvme.h
> +++ b/drivers/nvme/host/nvme.h
> @@ -16,6 +16,7 @@
>   #include <linux/rcupdate.h>
>   #include <linux/wait.h>
>   #include <linux/t10-pi.h>
> +#include <linux/io_uring.h>
>   
>   #include <trace/events/block.h>
>   
> @@ -189,6 +190,12 @@ enum {
>   	NVME_REQ_USERCMD		= (1 << 1),
>   };
>   
> +static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
> +		struct io_uring_cmd *ioucmd)
> +{
> +	return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
> +}
> +
>   static inline struct nvme_request *nvme_req(struct request *req)
>   {
>   	return blk_mq_rq_to_pdu(req);
> @@ -442,6 +449,9 @@ struct nvme_ns_head {
>   	struct work_struct	requeue_work;
>   	struct mutex		lock;
>   	unsigned long		flags;
> +	/* for uring-passthru multipath handling */
> +	struct ioucmd_list	requeue_ioucmd_list;
> +	spinlock_t		requeue_ioucmd_lock;
>   #define NVME_NSHEAD_DISK_LIVE	0
>   	struct nvme_ns __rcu	*current_path[];
>   #endif
> @@ -830,6 +840,7 @@ int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
>   		unsigned int issue_flags);
>   int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
>   		unsigned int issue_flags);
> +void nvme_ioucmd_mpath_retry(struct io_uring_cmd *ioucmd);
>   int nvme_getgeo(struct block_device *bdev, struct hd_geometry *geo);
>   int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
>   
> @@ -844,6 +855,7 @@ static inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
>   	return ctrl->ana_log_buf != NULL;
>   }
>   
> +bool nvme_available_path(struct nvme_ns_head *head);
>   void nvme_mpath_unfreeze(struct nvme_subsystem *subsys);
>   void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys);
>   void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index d734599cbcd7..57f4dfc83316 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -15,6 +15,8 @@ enum io_uring_cmd_flags {
>   	IO_URING_F_SQE128		= 4,
>   	IO_URING_F_CQE32		= 8,
>   	IO_URING_F_IOPOLL		= 16,
> +	/* to indicate that it is a MPATH req*/
> +	IO_URING_F_MPATH		= 32,

Unrelated, but this should probably move to bitwise representation...
