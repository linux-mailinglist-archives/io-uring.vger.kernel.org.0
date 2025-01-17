Return-Path: <io-uring+bounces-5967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A453A14E56
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 12:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 633891888EC9
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 11:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4372E1FC118;
	Fri, 17 Jan 2025 11:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="bR/nFi8M";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="A8YNlNQc"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0583E46BF;
	Fri, 17 Jan 2025 11:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737112841; cv=none; b=FtqbHnunSRUDJ6Yi2Gio6IEQJpmIYJRBUWAleAVCqgi342pBXIeBnZGMt8g24RrTrYtRP1XrcWn+XA356UnIwmzWnHo2CYWSRMGggaUC5RPqnsrRZj1qjOG9uosU67e5xUH4c5Nb/5SIXFuhucdB//WIndUjieseXtolZ86Yy0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737112841; c=relaxed/simple;
	bh=jiDy7/rNAjiu5KCPr3Lhxx2vBmkoHl7ixHBFHaC5hKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DrtvZE9/en+nmRFVg5iGLB8j+v4sZRMgIARNquqT2Emj7Egjx6ZEBe2NQh91YXY5pLVKMGnQebDfCS5ll0mNRjuFubZlAKDH+TxWur1iSIHXlZLQXauWR3NsdnX6sP8jlFXPp7djpu0vyGQ88V9aLZ2K3zgkKsJDzJzdFzW+0Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=bR/nFi8M; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=A8YNlNQc; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CF95E1140120;
	Fri, 17 Jan 2025 06:20:36 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 17 Jan 2025 06:20:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737112836;
	 x=1737199236; bh=BdlLgBmNc9XEOyLA4wNihHLZm0mm1hy0rjCEOMdLibk=; b=
	bR/nFi8M86qG18rB+TFZUA7lscqbR72m9od63vUXfmWQwDlItECvr0hYiMtRTRLQ
	GUS4/8+ss7kD+5QCnjSBBFZdT3+tcLy4GD29AnKZxWThinJ598nMvp8kKyGr3/No
	VW5Ao9QCG72VZqV+48lAM03Vw0Fz7kpLbekb2srPW6McBb8kvUlSoFdOe+/B+O4/
	b+UCzESxCPmUbRatUorLM2M2K2NDNoxyJVFetNqTZv4ldNPkejbcyTqc6EXCyvZ8
	RpqfHoI1ux/Bx/FOu2WeLFp6zLt2BMZwF9437LSldzw9PPpeXaEmE32f3erUB8+6
	K5957PEzeyWh1o4puqUEhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1737112836; x=
	1737199236; bh=BdlLgBmNc9XEOyLA4wNihHLZm0mm1hy0rjCEOMdLibk=; b=A
	8YNlNQcwpL5ldDY7gxx3RG1XYZfSHKTBAs8YyVp93pftTsapB7FxuYqTPl3Adh9q
	v+DYumDQ0n+H5JCE+wqLIGPEvJ1WIbMUTRnbBhy96NmtExPW0Tu/jRxEQ90QjFM+
	fdt1khudyfqclbbtekrEhmAOdhcpoqyI89mU1vacOF0/x1iV3aXObUOsIbKCNjsM
	QOniYTtXoBg0JDoMR8Dzq5cH/LFqI0FBZlisiKoF37hqZGNvnS3oyXiLrYHc756l
	aXGapj7c42tOCArLTxO/GOrsxmWxlsDxeIh9E+7WH+l7WdtrXFqDSo/CnRbEsHpM
	bh1HRmwIu/7OvltkhPjwg==
X-ME-Sender: <xms:BD2KZxUgyHl_C4Q-dGaBz14JtIu2awRF_b4f3YZ0RkUpnDMK57KLXQ>
    <xme:BD2KZxmjWrgWp04FXu0H2-hT3KCLh7vmXKYGjyJGr2NaOucrgykyoi3PENNEHkgX1
    LwILzmpEGoYmu2Y>
X-ME-Received: <xmr:BD2KZ9Y_jO0x9LQG5jroTQN6pQrFtO4GB2H687wR8QfJr9-i-Li5wOwbVRax7uc44aaYXvgJmxiTyAjvM6YE3kR4u8RRsCi7vKYWDiQsvkwrIzfO7wWj>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudeifedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnh
    gurdgtohhmqeenucggtffrrghtthgvrhhnpeefgeegfeffkeduudelfeehleelhefgffeh
    udejvdfgteevvddtfeeiheeflefgvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgt
    phhtthhopeduuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghsmhhlrdhsih
    hlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepsghstghhuhgsvghrthesuggu
    nhdrtghomhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpth
    htoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopehlihhnuhigqdhfshgu
    vghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinh
    hgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhorghnnhgvlhhkohho
    nhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnug
    grrdgtohhmpdhrtghpthhtoheprghmihhrjeefihhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:BD2KZ0XePNjmVMFc5fw89KZHNNxQ3QV3vZ6JaUWkasrbwoVTifryOQ>
    <xmx:BD2KZ7llfLtn5052qpbBFcAmTMg_vdloYeYwnsecuKQTfERFsfiQJg>
    <xmx:BD2KZxcizkzcHA1FW7PVZPPlc1BK4_yzbaMfLrYdtN1kRZqSZ6Jghg>
    <xmx:BD2KZ1G_NrieBNzndcJH9Fs_WNJ-WcNS-im8AkTbjeaPIuEF_HTgBA>
    <xmx:BD2KZ5fonG3UvLguw11iykliqjRTFTocCMLj4NUkFzYLkNE038cD1U9a>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Jan 2025 06:20:34 -0500 (EST)
Message-ID: <87ec5866-0013-4b26-9213-61fb9bc6525d@bsbernd.com>
Date: Fri, 17 Jan 2025 12:20:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
To: Pavel Begunkov <asml.silence@gmail.com>,
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
 <a6eea6a0-f4d9-4af1-b4b0-7c5618bc0cbb@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <a6eea6a0-f4d9-4af1-b4b0-7c5618bc0cbb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/17/25 12:18, Pavel Begunkov wrote:
> On 1/7/25 00:25, Bernd Schubert wrote:
>> This adds support for fuse request completion through ring SQEs
>> (FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
>> the ring entry it becomes available for new fuse requests.
>> Handling of requests through the ring (SQE/CQE handling)
>> is complete now.
>>
>> Fuse request data are copied through the mmaped ring buffer,
>> there is no support for any zero copy yet.
> 
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com> # io_uring
> 
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> ---
>>   fs/fuse/dev_uring.c   | 450 ++++++++++++++++++++++++++++++++++++++++
>> ++++++++++
>>   fs/fuse/dev_uring_i.h |  12 ++
>>   fs/fuse/fuse_i.h      |   4 +
>>   3 files changed, 466 insertions(+)
>>
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> index
>> b44ba4033615e01041313c040035b6da6af0ee17..f44e66a7ea577390da87e9ac7d118a9416898c28 100644
>> --- a/fs/fuse/dev_uring.c
>> +++ b/fs/fuse/dev_uring.c
>> @@ -26,6 +26,19 @@ bool fuse_uring_enabled(void)
> ...
>> +
>> +/*
>> + * Write data to the ring buffer and send the request to userspace,
>> + * userspace will read it
>> + * This is comparable with classical read(/dev/fuse)
>> + */
>> +static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent,
>> +                    unsigned int issue_flags)
>> +{
>> +    int err = 0;
>> +    struct fuse_ring_queue *queue = ring_ent->queue;
>> +
>> +    err = fuse_uring_prepare_send(ring_ent);
>> +    if (err)
>> +        goto err;
>> +
>> +    spin_lock(&queue->lock);
>> +    ring_ent->state = FRRS_USERSPACE;
>> +    list_move(&ring_ent->list, &queue->ent_in_userspace);
>> +    spin_unlock(&queue->lock);
>> +
>> +    io_uring_cmd_done(ring_ent->cmd, 0, 0, issue_flags);
>> +    ring_ent->cmd = NULL;
> 
> I haven't checked if it races with some reallocation, but
> you might want to consider clearing it under the spin.
> 
> spin_lock(&queue->lock);
> ...
> cmd = ring_ent->cmd;
> ring_ent->cmd = NULL;
> spin_unlock(&queue->lock);
> 
> io_uring_cmd_done(cmd);
> 
> Can be done on top if even needed.


Yes, thanks for your review! That is what I actually have in the ddn
branch, when I found the startup race.


Thanks,
Bernd



