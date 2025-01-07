Return-Path: <io-uring+bounces-5746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 331FBA049C4
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 19:59:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97EBC1883314
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 18:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C1A1F37B4;
	Tue,  7 Jan 2025 18:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="HTxOcFlV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ldMbbGtX"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA681F2C3F;
	Tue,  7 Jan 2025 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736276353; cv=none; b=KMvr5W5b1aAZrmi3cDDHrk8Givuw61tROpCkY+oStruFGPTpDqX7n0Ebw5wNjbLe8eg7QHRdh97ssPfo6nkDiOM5YjVFYEMH+qfkfc0cLG9ThucTLEOElZeILkWQ5/BJCn2aSCPFGVzxNW8MLEOhQYaeARLKx3DJNVfbOzbYY5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736276353; c=relaxed/simple;
	bh=05dXKPp3UeggAAObe7YFouMLps+ul1mZpEJYQEKYVLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rB8Jjf+fI40t2ogQTNrtbcNDYfJtZ35x4B66bGwZ9z2hm3KkDMCoFJlFy9O1G+2gboxSiScWwsy8j7a3soLRwoQv421RahCGHRaj5zruAPu9U4WaNzvFvALV+a5Fk46o8kQreWoj1KYvM1dmEmROHJ8F/0/yarbeilUOGRMpT6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=HTxOcFlV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ldMbbGtX; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 20A7A1380237;
	Tue,  7 Jan 2025 13:59:10 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Tue, 07 Jan 2025 13:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1736276350;
	 x=1736362750; bh=GkQ4VTpp0Z7U0EdUHbP4HtEemK6HZFuRWZwXdkmDPDw=; b=
	HTxOcFlV8+bxWDaDRnenEsiPf2b2x9nECmO2yYgpf45yhWpygbFYjB6ipxK1+89p
	iL7uA0dOpkzUWDIgmuyYh0RNbstUQShH2+NrQjPQIm0eTFDZrY58s/TwGgUrVTfq
	b5BiFWLldUQVQIgX+/11t9ZFDRpkDt11QWf0pRm3cSAqe/xcmFZmMlAfoCUgZr86
	6beVVE6h2bAsFHulo6DHMqy47Evijikod4JdgUqD7y722sxI+vXPlGlp+/DJYGyb
	VhkempmJfwovDMZPW/3NZ6ucLNxQdDNbrr4KygajmKqsNR8VCoPX1Snib8raQY8l
	vK6W2s7AajOnRu3NAuh1dA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1736276350; x=
	1736362750; bh=GkQ4VTpp0Z7U0EdUHbP4HtEemK6HZFuRWZwXdkmDPDw=; b=l
	dMbbGtXpV7cY6uDctTdK9MmTgekVrWdnCmVZzpNLqPqknw1LqrjOiIw4KRW73OBZ
	6dXcxySTydpW78WALLlzrGSUOqidr5bzr56IkpnJ1JvWtubZmMGAfss/3JIdPD1d
	TQukmZaGkjH4rjXCaZGdHG1yuZup6hyoeVGlFt3Z0d4fZNRB4gi3tn7bygwJBgm+
	xr3JSs0iaks9qdJ7onPzY0Nj4o3oAHQ7ibUcFTaeyBLNwhc5t8BLWB+hfEtYj04h
	MIDQl+4rVnM3TrkOHxBL/lRogzaSl0kcMdyABUh/M+y2P9SUFN1YootP/OcpkOho
	QMv+NGQDYkSSXFhrw7Wuw==
X-ME-Sender: <xms:fXl9Z37L9eBxQ4LAzRrVRuZ3g7Q2BOO2PMERWHHfXoZ4Q34xXZkuuA>
    <xme:fXl9Z870mMEQG1rWjQ-sBB7q0N0k1nTeKbHiLOanEMXX4Z8fgXwj1O2BmSV16Pjkg
    StOefvlAGhS8Tw_>
X-ME-Received: <xmr:fXl9Z-enWSPsb_EU1EUjVwP1SwuWBGWuAG3DNjaiB4tn5tGYQ03UrXU31-nWs7GMDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudegvddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrh
    hnugdrtghomheqnecuggftrfgrthhtvghrnhephefhjeeujeelhedtheetfedvgfdtleff
    uedujefhheegudefvdfhheeuveduueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghr
    tghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehluhhishesih
    hgrghlihgrrdgtohhmpdhrtghpthhtohepsghstghhuhgsvghrthesuggunhdrtghomhdp
    rhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtoheprgigsg
    hovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhm
    rghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtoh
    hmpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnuggrrdgtohhm
X-ME-Proxy: <xmx:fXl9Z4Jz3fm7mPnTUHRok_l-bPI11jJs4dhlb_tXgPV81ig8h5ox3w>
    <xmx:fXl9Z7K-LM1xOKnpIE2xROn1XxcZFp2uPVJopFDtPXuSv1lG3A7Kgg>
    <xmx:fXl9Zxy6XzhlwxWH4LroaQPIvzb6zUIDW2yP-KwzXzGQBEEJA4h1SQ>
    <xmx:fXl9Z3L3ZE6bPJIh_goR2qTXTsA0Pj8VroMGBXnnDtB5ckKtHj8FMg>
    <xmx:fnl9Z1C45TcIA-3OPPoeUUJjVPSewX7hpmd5sKJwsAMluSG_CF853w1e>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Jan 2025 13:59:07 -0500 (EST)
Message-ID: <87a9354b-4371-4862-b94c-8797e77b0068@bsbernd.com>
Date: Tue, 7 Jan 2025 19:59:06 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/17] fuse: Allow to queue fg requests through
 io-uring
To: Luis Henriques <luis@igalia.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-13-9c786f9a7a9d@ddn.com>
 <87a5c239ho.fsf@igalia.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US
In-Reply-To: <87a5c239ho.fsf@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/7/25 16:54, Luis Henriques wrote:

[...]

>> @@ -785,10 +830,22 @@ static void fuse_uring_do_register(struct fuse_ring_ent *ring_ent,
>>   				   unsigned int issue_flags)
>>   {
>>   	struct fuse_ring_queue *queue = ring_ent->queue;
>> +	struct fuse_ring *ring = queue->ring;
>> +	struct fuse_conn *fc = ring->fc;
>> +	struct fuse_iqueue *fiq = &fc->iq;
>>   
>>   	spin_lock(&queue->lock);
>>   	fuse_uring_ent_avail(ring_ent, queue);
>>   	spin_unlock(&queue->lock);
>> +
>> +	if (!ring->ready) {
>> +		bool ready = is_ring_ready(ring, queue->qid);
>> +
>> +		if (ready) {
>> +			WRITE_ONCE(ring->ready, true);
>> +			fiq->ops = &fuse_io_uring_ops;
> 
> Shouldn't we be taking the fiq->lock to protect the above operation?

I switched the order and changed it to WRITE_ONCE. fiq->lock would
require that doing the operations would also hold lock.
Also see "[PATCH v9 16/17] fuse: block request allocation until",
there should be no races anyone.

> 
>> +		}
>> +	}
>>   }
>>   
>>   /*
>> @@ -979,3 +1036,119 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
>>   
>>   	return -EIOCBQUEUED;
>>   }
>> +
>> +/*
>> + * This prepares and sends the ring request in fuse-uring task context.
>> + * User buffers are not mapped yet - the application does not have permission
>> + * to write to it - this has to be executed in ring task context.
>> + */
>> +static void
>> +fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
>> +			    unsigned int issue_flags)
>> +{
>> +	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
>> +	struct fuse_ring_queue *queue = ent->queue;
>> +	int err;
>> +
>> +	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
>> +		err = -ECANCELED;
>> +		goto terminating;
>> +	}
>> +
>> +	err = fuse_uring_prepare_send(ent);
>> +	if (err)
>> +		goto err;
> 
> Suggestion: simplify this function flow.  Something like:
> 
> 	int err = 0;
> 
> 	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD))
> 		err = -ECANCELED;
> 	else if (fuse_uring_prepare_send(ent)) {
> 		fuse_uring_next_fuse_req(ent, queue, issue_flags);
> 		return;
> 	}
> 	spin_lock(&queue->lock);
>          [...]

That makes it look like fuse_uring_prepare_send is not an
error, but expected. How about like this?

static void
fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
			    unsigned int issue_flags)
{
	struct fuse_ring_ent *ent = uring_cmd_to_ring_ent(cmd);
	struct fuse_ring_queue *queue = ent->queue;
	int err;

	if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
		err = fuse_uring_prepare_send(ent);
		if (err) {
			fuse_uring_next_fuse_req(ent, queue, issue_flags);
			return;
		}
	} else {
		err = -ECANCELED;
	}

	spin_lock(&queue->lock);
	ent->state = FRRS_USERSPACE;
	list_move(&ent->list, &queue->ent_in_userspace);
	spin_unlock(&queue->lock);

	io_uring_cmd_done(cmd, err, 0, issue_flags);
	ent->cmd = NULL;
}



Thanks,
Bernd

