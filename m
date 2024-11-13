Return-Path: <io-uring+bounces-4657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1D5B9C7BDE
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 20:03:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D4BBB30C9F
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 18:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF577202630;
	Wed, 13 Nov 2024 18:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="t5TC81VQ"
X-Original-To: io-uring@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C1413AA4E;
	Wed, 13 Nov 2024 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731522848; cv=none; b=INmkkFS+zl7ffodB4fPszO+u5lGbpSlOmDhGcNz52c9EOVyhSkwwG9VPqQD97053dxaYS1w6SkI8MMW8g2JrswPMwUEIqRS/NYZ+t/ywN5C4VAv0WE19m9Me5G9fF2cLW7LqC8q3ZywM4lhX9GjJd2TTS8u2MyBvLyTamtJ3ZUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731522848; c=relaxed/simple;
	bh=R58aAayO/VeQk1q0vJIBfxPUfnWgTtg4dAWrLhvyCYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WLJrHsYP39VJfLS3eANFdoiK7awo5XW75mclgqO2TMwpLClHC2nIJEk334kg0qXNj08j6/OnfDPfYJcFZaNKZHtZlBs4Q9sAc32TK+YZL1tBYXYv6kvtsHEJrPV6IKBT+Lz5xx5c4mbdlq3ZyodYVmazj75oY1CDpz4LtdgnGGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=t5TC81VQ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XpX482BvSzlgMW8;
	Wed, 13 Nov 2024 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731522834; x=1734114835; bh=Md60i28ukD0lfEvSKguY2NCj
	5Myaq2rhrhoA+wvIl/A=; b=t5TC81VQjnB8GAslWw8CoD8HnR0PTQEdw4KyrAnr
	3ZdxAALr5CfnWY5q6VhnCYEBxskYnaBBIL2qVomJgbI0w0FMMkqIQCiYsTfcXJCx
	VseAWXjH84iobkJdq6qNiYZ/N08t5YongPQ8AdGsVTtIT6geT50CXotFvPLXFsx2
	Jt+u5g3VtQh8tFhOALgCKfD3W6yLNYYZ3SXfYliuBUpFGiZ7O2fVvyulBP+OvYWm
	AUw1fylbCy+O/ERktudWo5rdWtTL236zEiPYeD2iPatUudiuinhsKtw9iB8Uz4b1
	LEpcXOr0PcwiFAzyXBn/7QwG3sB7kER5L+scK6y2ZEDlAw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i5ZJ0PUIqGhn; Wed, 13 Nov 2024 18:33:54 +0000 (UTC)
Received: from [172.19.178.167] (217.sub-174-194-198.myvzw.com [174.194.198.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XpX3x1MtPzlgMVx;
	Wed, 13 Nov 2024 18:33:48 +0000 (UTC)
Message-ID: <92954431-349d-4b75-b63f-948b1df9a3fc@acm.org>
Date: Wed, 13 Nov 2024 10:33:46 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't reorder requests passed to ->queue_rqs
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
 virtualization@lists.linux.dev, linux-nvme@lists.infradead.org,
 io-uring@vger.kernel.org
References: <20241113152050.157179-1-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241113152050.157179-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/13/24 7:20 AM, Christoph Hellwig wrote:
> currently blk-mq reorders requests when adding them to the plug because
> the request list can't do efficient tail appends.  When the plug is
> directly issued using ->queue_rqs that means reordered requests are
> passed to the driver, which can lead to very bad I/O patterns when
> not corrected, especially on rotational devices (e.g. NVMe HDD) or
> when using zone append.
> 
> This series first adds two easily backportable workarounds to reverse
> the reording in the virtio_blk and nvme-pci ->queue_rq implementations
> similar to what the non-queue_rqs path does, and then adds a rq_list
> type that allows for efficient tail insertions and uses that to fix
> the reordering for real and then does the same for I/O completions as
> well.

Hi Christoph,

Could something like the patch below replace this patch series? I don't 
have a strong opinion about which approach to select.
I'm sharing this patch because this is what I came up while looking into
how to support QD>1 for zoned devices with a storage controller that
preserves the request order (UFS).

Thanks,

Bart.


block: Make the plugging mechanism preserve the request order

Requests are added to the front of the plug list and dispatching happens
in list order. Hence, dispatching happens in reverse order. Dispatch in
order by reversing the plug list before dispatching. This patch is a
modified version of a patch from Jens
(https://lore.kernel.org/linux-block/1872ae0a-6ba6-45f5-9f3d-8451ce06eb14@kernel.dk/).

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3533bd808072..bf2ea421b2e8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2868,6 +2868,22 @@ static void blk_mq_dispatch_plug_list(struct 
blk_plug *plug, bool from_sched)
  	percpu_ref_put(&this_hctx->queue->q_usage_counter);
  }

+/* See also llist_reverse_order(). */
+static void blk_plug_reverse_order(struct blk_plug *plug)
+{
+	struct request *rq = plug->mq_list, *new_head = NULL;
+
+	while (rq) {
+		struct request *tmp = rq;
+
+		rq = rq->rq_next;
+		tmp->rq_next = new_head;
+		new_head = tmp;
+	}
+
+	plug->mq_list = new_head;
+}
+
  void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
  {
  	struct request *rq;
@@ -2885,6 +2901,8 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, 
bool from_schedule)
  	depth = plug->rq_count;
  	plug->rq_count = 0;

+	blk_plug_reverse_order(plug);
+
  	if (!plug->multiple_queues && !plug->has_elevator && !from_schedule) {
  		struct request_queue *q;



