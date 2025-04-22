Return-Path: <io-uring+bounces-7612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E134A96D30
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 15:42:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13919189290E
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 13:42:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFCC1EE7BC;
	Tue, 22 Apr 2025 13:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iuONssol"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8F620E703
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 13:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745329343; cv=none; b=EB5ymUB/VeAT5QVspzhPc1jIpS8+GYargNX5IZPEHkPolNlolLWNu8OyZscBAk0FIyjkxYKwTHybdgoVwme1rjC8lIKv7BldQUNht6p6U8L85fPgrdpYCeETw5LB+jAVK99hQVJ+1xsrdz3YOz6jHSzYAUeq1xtSfY5AFaiPuiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745329343; c=relaxed/simple;
	bh=43J95R7UkS9ZHu2TmFroJYkPJAiTXS4NSfCxQK3oim0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jZdmlbwi5px2DE0rbrKPwXDgCmTVH3VcMPzbQ4Uvo6isE+MMIvcUESah7WF9xOm2/TVqc8HRCwDDLqyraM5EVtyWO9XHNih7Pkt3mttzyZYiTThODo8ELAeBmchEK4YMIjMPRK56aNXey/lLpQXUMzg1OjY77juUGrroYG4nBHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iuONssol; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745329340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MfU1WoBfg608dgNwhGpErGuQKN5XxOOIy1gdIjz+LLA=;
	b=iuONssolHZ6O1LBTBRtFxOp/QcB8ErgHcRO1k7anZsd6dhC4KLG39Jvzolm56WGFCAkHbY
	9dW/GsuRlJ7mPwyyz+8VhJNm25SYCB2isw/LADitnishso6ESEvd+KStBvDz+Qd8XA5HSh
	lXipmZ/yqS2mXp96ffwtvqV6MOZVhYI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-SKaJ08JYOOmBLKT0wSU7Fw-1; Tue,
 22 Apr 2025 09:42:16 -0400
X-MC-Unique: SKaJ08JYOOmBLKT0wSU7Fw-1
X-Mimecast-MFC-AGG-ID: SKaJ08JYOOmBLKT0wSU7Fw_1745329334
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C080119560A0;
	Tue, 22 Apr 2025 13:42:14 +0000 (UTC)
Received: from fedora (unknown [10.72.116.15])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1C7F1800378;
	Tue, 22 Apr 2025 13:42:09 +0000 (UTC)
Date: Tue, 22 Apr 2025 21:42:04 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jared Holzman <jholzman@nvidia.com>
Cc: Guy Eisenberg <geisenberg@nvidia.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Yoav Cohen <yoav@nvidia.com>,
	Omri Levi <omril@nvidia.com>, Ofer Oshri <ofer@nvidia.com>,
	io-uring@vger.kernel.org
Subject: Re: ublk: kernel crash when killing SPDK application
Message-ID: <aAecrLIivK5ioeOk@fedora>
References: <IA1PR12MB645841796CB4C76F62F24522A9B22@IA1PR12MB6458.namprd12.prod.outlook.com>
 <Z_5XdWPQa7cq1nDJ@fedora>
 <d2179120-171b-47ba-b664-23242981ef19@nvidia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2179120-171b-47ba-b664-23242981ef19@nvidia.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Apr 22, 2025 at 02:43:06PM +0300, Jared Holzman wrote:
> On 15/04/2025 15:56, Ming Lei wrote:
> > On Tue, Apr 15, 2025 at 10:58:37AM +0000, Guy Eisenberg wrote:

...

> 
> Hi Ming,
> 
> Unfortunately your patch did not solve the issue, it is still happening (6.14 Kernel)
> 
> I believe the issue is that ublk_cancel_cmd() is calling io_uring_cmd_done() on a uring_cmd that is currently scheduled as a task work by io_uring_cmd_complete_in_task()
> 
> I reproduced with the patch below and saw the warning I added shortly before the crash. The dmesg log is attached.
> 
> I'm not sure how to solve the issue though. Unless we wait for the task work to complete in ublk_cancel cmd. I can't see any way to cancel the task work
> 
> Would appreciate your assistance,
> 
> Regards,
> 
> Jared
> 
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index ca9a67b5b537..d9f544206b36 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -72,6 +72,10 @@
>  	(UBLK_PARAM_TYPE_BASIC | UBLK_PARAM_TYPE_DISCARD | \
>  	 UBLK_PARAM_TYPE_DEVT | UBLK_PARAM_TYPE_ZONED)
>  
> +#ifndef IORING_URING_CMD_TW_SCHED
> +        #define IORING_URING_CMD_TW_SCHED (1U << 31)
> +#endif
> +
>  struct ublk_rq_data {
>  	struct llist_node node;
>  
> @@ -1236,6 +1240,7 @@ static void ublk_rq_task_work_cb(struct io_uring_cmd *cmd, unsigned issue_flags)
>  	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
>  	struct ublk_queue *ubq = pdu->ubq;
>  
> +	cmd->flags &= ~IORING_URING_CMD_TW_SCHED;
>  	ublk_forward_io_cmds(ubq, issue_flags);
>  }
>  
> @@ -1245,7 +1250,7 @@ static void ublk_queue_cmd(struct ublk_queue *ubq, struct request *rq)
>  
>  	if (llist_add(&data->node, &ubq->io_cmds)) {
>  		struct ublk_io *io = &ubq->ios[rq->tag];
> -
> +		io->cmd->flags |= IORING_URING_CMD_TW_SCHED;
>  		io_uring_cmd_complete_in_task(io->cmd, ublk_rq_task_work_cb);
>  	}
>  }
> @@ -1498,8 +1503,10 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
>  		io->flags |= UBLK_IO_FLAG_CANCELED;
>  	spin_unlock(&ubq->cancel_lock);
>  
> -	if (!done)
> +	if (!done) {
> +		WARN_ON_ONCE(io->cmd->flags & IORING_URING_CMD_TW_SCHED);
>  		io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
> +        }
>  }
>  
>  /*
> @@ -1925,6 +1932,7 @@ static inline int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
>  static void ublk_ch_uring_cmd_cb(struct io_uring_cmd *cmd,
>  		unsigned int issue_flags)
>  {
> +	cmd->flags &= ~IORING_URING_CMD_TW_SCHED;
>  	ublk_ch_uring_cmd_local(cmd, issue_flags);
>  }
>  
> @@ -1937,6 +1945,7 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>  
>  	/* well-implemented server won't run into unlocked */
>  	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
> +		cmd->flags |= IORING_URING_CMD_TW_SCHED;
>  		io_uring_cmd_complete_in_task(cmd, ublk_ch_uring_cmd_cb);
>  		return -EIOCBQUEUED;
>  	}
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index abd0c8bd950b..3ac2ef7bd99a 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -7,6 +7,7 @@
>  
>  /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
>  #define IORING_URING_CMD_CANCELABLE	(1U << 30)
> +#define IORING_URING_CMD_TW_SCHED	(1U << 31)
>  
>  struct io_uring_cmd {
>  	struct file	*file;
> 

Nice debug patch!

Your patch and the dmesg log has shown the race between io_uring_cmd_complete_in_task()
and io_uring_cmd_done() <- ublk_cancel_cmd().

In theory, io_uring should have the knowledge to cover it, but I guess it
might be a bit hard.

I will try to cook a ublk fix tomorrow for you to test.

Thanks,
Ming


