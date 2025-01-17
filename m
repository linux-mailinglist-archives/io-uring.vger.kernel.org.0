Return-Path: <io-uring+bounces-5989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4880EA15937
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 22:53:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97A7B3A73CC
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 21:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9441AA1C9;
	Fri, 17 Jan 2025 21:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="mEfoqriW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OwRT9boD"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0601A83EE;
	Fri, 17 Jan 2025 21:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737150780; cv=none; b=IIT+Rn1/bcVuLw9KuYS6HJdr6tIk/oNmVUGdlx1YcCtF3htXetbiNC2D79E1pcFdz4JnL1MfeBcJIvoB8COmmv+lO5ZWrYt8eILDtykC/T1HetLcV2FdGyOYyZ3cB9cmMT1ktsjd4zwYfjBT4rT2ifMkqRy3atdoOAHW3zGDi54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737150780; c=relaxed/simple;
	bh=7x8MrntCVxpUApdt7UFioHhgzeVhp62ZtVq72wYVsOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WSYU5zzjSAA9HTjABY8n0mDwdLrFcJ7YW859lOl221D29TZLHEfnY1xpS25lA3xnp80oPaJG71sfABcU4WWMQ/JHBQ/avpnqPs10QAy6rhTRtyZG/QauV/UAVKKzMr8bhmid5H6LA2xV5TvLSWtwPiNqasjzy8XcORrxVH+/qZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=mEfoqriW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OwRT9boD; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id F0DBA1140122;
	Fri, 17 Jan 2025 16:52:56 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 17 Jan 2025 16:52:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737150776;
	 x=1737237176; bh=wrUIT8nzmaxyullujPWvw6pCuUlYeJXU7sGZhYP0nHI=; b=
	mEfoqriWeoMaQy4HEOKs8d4pJwFfEAlCn1PQEx04Lu5ogfapaT1/wvINdvmAWgD/
	pL43KaRQR7JiZ1NzwFCqHy/WQzjWx73PNhyVRO9JKHJNAXtLADuc6BDmpH7EYEbx
	vQ0nJC5Hxn5ngvWeLC9vRID8tWRNk5lwHwxaQHkhKUV8XlsNPSXTlYUM3TpMWUnK
	gk0AT9Ha5sjF7BD/sMnsLZBXFZb8WGDeMXl7XWd9zNoCWyV9XtnmfsfX4vGPUrWY
	DfnwFmZYZ69cdXpOqtua202hLJhHnUJqbnUcPu9t25euQGnyRhXH/5Shxn7IcsQO
	EnhlQpYMIpfLJRveONZg3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1737150776; x=
	1737237176; bh=wrUIT8nzmaxyullujPWvw6pCuUlYeJXU7sGZhYP0nHI=; b=O
	wRT9boDnaKIDbUm75Q36wRpF1rq3Ri6btkmh2CehugUtsfnPz5nB+gyPHU+k8Q/3
	K6bSmVgSWkWxzJJcBVFqXOg+1dbvOe/i1aRt/X+3ef4eabJ+X9ArvPdMpooXDhfk
	jsstLjOMtvE5cZSFUNumnKxIypqbr1pDJm1N1y54VKaTfqgODAlG9bLz9fs8ikIO
	FFfOrSP/CLiSoblbG3lzHa6xMkSLTWGSjaU20lIBcxPjY3Aoie/FDp1InvqTuMAf
	ry3KRG0R7h6MSgJGXiaZN9oPhxzkX2ZXwO02PYJ6ukrptcVzZtxrWevw1htiu7sl
	cYslz/NeCJxLeDsTKyVrw==
X-ME-Sender: <xms:N9GKZ3yvmKZu5X_i7HNdMlhFgj1xeH07dHVFJH1hB0wruzNsRyJa7g>
    <xme:N9GKZ_Q78rLm_aWojwlaa2oxWp3kt93GpOpgVIvbvSIhyqWKQRTk58N9HDa89fVMJ
    4uWYrxgRL38G1TO>
X-ME-Received: <xmr:N9GKZxUXUadfUA77zA6Nsh8JP6ms-BknVRVOlqU7kSfCsdcGW7zBxegutfG1dh9zKQHEtC5uMxQQ_4VUAgSe-xHs99KvAuI3R7M8xQFE9am7fKAPOuXi>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudeifedgudehvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddv
    jeenucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrh
    hnugdrtghomheqnecuggftrfgrthhtvghrnhephefhjeeujeelhedtheetfedvgfdtleff
    uedujefhheegudefvdfhheeuveduueegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghr
    tghpthhtohepuddupdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsshgthhhusg
    gvrhhtseguughnrdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhh
    uhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghsmh
    hlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqfhhs
    uggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehiohdquhhrih
    hnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohgrnhhnvghlkhho
    ohhnghesghhmrghilhdrtghomhdprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnh
    gurgdrtghomhdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:N9GKZxgeg9poRDMgA6MuepnTQbrtEiVEG0qBCQbWgXHoY4XYK_R4Sw>
    <xmx:N9GKZ5AkQaEaetq6lXE1V3qWPFZ_cBdl49A3wDNe0fi8HFok5CBR8g>
    <xmx:N9GKZ6KNPEVgSXshl4ErBi2CwycpzGyT3eBo4sRblvWHArBhfMOqDg>
    <xmx:N9GKZ4Br_WHuq987yILVBESwT7NER9Ka8mWqYbCdburNh_QG_ooAOQ>
    <xmx:ONGKZ-JMeTmCCZ3mIOf4YHqhRWkSpK-1HDpvezFkhCuH3LBPxh0v7rvi>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Jan 2025 16:52:54 -0500 (EST)
Message-ID: <5e394aa9-fc7f-43d6-a61a-d02c9e048717@bsbernd.com>
Date: Fri, 17 Jan 2025 22:52:52 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/17] fuse: Allow to queue fg requests through
 io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-13-9c786f9a7a9d@ddn.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-13-9c786f9a7a9d@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


> +/* queue a fuse request and send it if a ring entry is available */
> +void fuse_uring_queue_fuse_req(struct fuse_iqueue *fiq, struct fuse_req *req)
> +{
> +	struct fuse_conn *fc = req->fm->fc;
> +	struct fuse_ring *ring = fc->ring;
> +	struct fuse_ring_queue *queue;
> +	struct fuse_ring_ent *ent = NULL;
> +	int err;
> +
> +	err = -EINVAL;
> +	queue = fuse_uring_task_to_queue(ring);
> +	if (!queue)
> +		goto err;
> +
> +	if (req->in.h.opcode != FUSE_NOTIFY_REPLY)
> +		req->in.h.unique = fuse_get_unique(fiq);
> +
> +	spin_lock(&queue->lock);
> +	err = -ENOTCONN;
> +	if (unlikely(queue->stopped))
> +		goto err_unlock;
> +
> +	ent = list_first_entry_or_null(&queue->ent_avail_queue,
> +				       struct fuse_ring_ent, list);
> +	if (ent)
> +		fuse_uring_add_req_to_ring_ent(ent, req);
> +	else
> +		list_add_tail(&req->list, &queue->fuse_req_queue);
> +	spin_unlock(&queue->lock);
> +
> +	if (ent) {
> +		struct io_uring_cmd *cmd = ent->cmd;
> +
> +		err = -EIO;
> +		if (WARN_ON_ONCE(ent->state != FRRS_FUSE_REQ))
> +			goto err;


I noticed this - this is wrong, as ent would be in nirvana state if
this condition would ever happen.


