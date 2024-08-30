Return-Path: <io-uring+bounces-2984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7959966504
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 17:10:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59070283DC8
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 15:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19381B1D4B;
	Fri, 30 Aug 2024 15:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="MbfFkce7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LtOZjFJH"
X-Original-To: io-uring@vger.kernel.org
Received: from fout3-smtp.messagingengine.com (fout3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9C91DA26;
	Fri, 30 Aug 2024 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725030613; cv=none; b=DN5sj6SRhxaHwXiSbKp3l9pzr3mxd9IGJliAMJVwSpIfFjRdiE76CLttqo4P4P1a9YnajTVvGj3NBPMSUXPr+K2ajuLYmyP0m2jCq2/xmt0H3mBB9ogwGTB9NXM7oaVIeK4oqHf0qcZgCOjovNRmhSvNK2uyalrbWgMfhek7hIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725030613; c=relaxed/simple;
	bh=gylQFwSOuPgdIo7gfs1X4zej315PIvycv1R1t2oJ6SQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y34d2FWd8kc2eKROIDop3AdJ0Eaj2vaMX/zBb8JmAEptJ+WJKrp5FXrhrMb0rPnxNDd//K6yuYeX1fFUMDtEfx5QaUwzmwyu3Ju3lxBgXsrmU4AZ9PGbOxA0f3/XAcf03Ovt1xu9G1PZXq08kJnSjyrztUQKtpTDcoRmZbbZ9A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=MbfFkce7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LtOZjFJH; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-01.internal (phl-compute-01.nyi.internal [10.202.2.41])
	by mailfout.nyi.internal (Postfix) with ESMTP id 9AC0D138024B;
	Fri, 30 Aug 2024 11:10:10 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 30 Aug 2024 11:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725030610;
	 x=1725117010; bh=1nTHDYISJLjRnDgQP0SklgcZi9Cu04kWvom3gwsPERA=; b=
	MbfFkce75Ict5zN5BAXYvgENELxcHpv2wDH4pfzlJnu8F/EPsZivnhLM82zGCr3L
	oMN75i+lNq9BkFgU+AEHqrBgfW3C50c3AoFDrKfON5sW3CvnPjeiBQzZL/OD0uvm
	tVc+jWYMO/iGq0NWj8iKw8g05atUD5qqCjnwjEswYHnow4GCYoeZeIsZrM8HZ9nf
	1vZQO2+pTF+EZaxkNt2P7CPmUkeqsPPMF5l1XTcJSLcM5GuELv/lVCx1LMsVZlr7
	YRQKsp1WFyT12rT8KSvqpTK5V5A8MFrZvSBYDZwaLBedAmDvjzc0Q0FyfALCxRDO
	Orp2cTXo4f5S4Ppxi+FalA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725030610; x=
	1725117010; bh=1nTHDYISJLjRnDgQP0SklgcZi9Cu04kWvom3gwsPERA=; b=L
	tOZjFJHNLeFDzUg9ypQ/0CrjOmYIm2T4nzb35b9JNgdmpYzs9bMhr9WXxAl8tSyw
	Aa/ePAyzHHi568rFDMMsrWi+yeTtfGV71ERfILG89CjOY6CM8x1HjVoF4YbfaNx/
	CTQJdi6KVLnw1IXc9jgkShkkcXryMPDxMTo689Evmd0/41vkEjXv2sH3oZtSltnz
	032uv0r5Np+34aEfUErjK53C/abl+hExzOryJgiqd/c5T401RaFKO4RdwygxcPeG
	Qg1t9hX9y/DaIWqqG4h7xImihcK2hGL6MNtifSkTUrx3nUMd+LwgxK+GvkyRnvPS
	3bFvvLCkqU0c7HQEBHXtw==
X-ME-Sender: <xms:0uDRZhWpk9eE0MxJCJoCjMMYWaNUWUJOv9IMM_1BqTWhNF2Kv13Xxg>
    <xme:0uDRZhn4GdGcd51NEP2AOfF9ALrVum7ciClb8wLaCJ_7bbjPugx1iqbBuVXJB-BWz
    osnbOPeQ4-uGEOq>
X-ME-Received: <xmr:0uDRZtZwYbmvD-s09r7RT7cMolnalLFQpDZBZl2jLob3tmsfeUVF5DUqmrskh4qrlzJz41a0wvZLlwLQPtP-mgLGW7lS7kZtaMsK66wtMnx4wgJgrmha>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudefiedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepudelfedvudevudev
    leegleffffekudekgeevlefgkeeluedvheekheehheekhfefnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopedutddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegsshgthhhusg
    gvrhhtseguughnrdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhh
    uhdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomhdprhgtphhtthhope
    hlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkh
    gvnhhtrdhovhgvrhhsthhrvggvtheslhhinhhugidruggvvhdprhgtphhtthhopehjohhs
    vghfsehtohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:0uDRZkW7CFiPuF_8Cai2Z7BVxJOZOuqdTG7Y6fxW6yYCwSnOLp1Zqg>
    <xmx:0uDRZrl-1wngArOvhWeWcagG0hziCj1hfeXO5wxVdV4nTFeHgEiTKQ>
    <xmx:0uDRZhfHDY53zb_btHui2MKfAVW6q_7yYZPz5Izu8QUGF_xloaPyIQ>
    <xmx:0uDRZlEAjsrxZvzLVYqJd_LhFgKuoD2Gjy3lxg3UXZ-373bFsl0nSA>
    <xmx:0uDRZkcx74r6yiYVBKhKAMUlCdl9x7i87BESeERTM4ssj87xh0ZhnDz0>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Aug 2024 11:10:08 -0400 (EDT)
Message-ID: <fffadaad-266e-4167-ba79-e46ffaa5597d@fastmail.fm>
Date: Fri, 30 Aug 2024 17:10:07 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Josef Bacik <josef@toxicpanda.com>, Joanne Koong <joannelkoong@gmail.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <CAJfpegsq06UZSPCDB=0Q3OPoH+c3is4A_d2oFven3Ebou8XPOw@mail.gmail.com>
 <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
 <CAJfpeguMmTXJPzdnxe87hSBPO_Y8s33eCc_H5fEaznZYC-D8HA@mail.gmail.com>
 <3b74f850-c74c-49d0-be63-a806119cbfbd@ddn.com>
 <7d42edd3-3e3b-452b-b3bf-fb8179858e48@fastmail.fm>
 <093a3498-5558-4c65-84b0-2a046c1db72e@kernel.dk>
 <f5d10363-9ba0-4a1a-8aed-cad7adf59cd4@ddn.com>
 <3ca0e7d1-bb86-4963-aab7-6fc24950fe84@kernel.dk>
 <d2528a1c-3d7c-4124-953c-02e8e415529e@gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <d2528a1c-3d7c-4124-953c-02e8e415529e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/30/24 16:55, Pavel Begunkov wrote:
> On 8/30/24 14:33, Jens Axboe wrote:
>> On 8/30/24 7:28 AM, Bernd Schubert wrote:
>>> On 8/30/24 15:12, Jens Axboe wrote:
>>>> On 8/29/24 4:32 PM, Bernd Schubert wrote:
>>>>> We probably need to call iov_iter_get_pages2() immediately
>>>>> on submitting the buffer from fuse server and not only when needed.
>>>>> I had planned to do that as optimization later on, I think
>>>>> it is also needed to avoid io_uring_cmd_complete_in_task().
>>>>
>>>> I think you do, but it's not really what's wrong here - fallback
>>>> work is
>>>> being invoked as the ring is being torn down, either directly or
>>>> because
>>>> the task is exiting. Your task_work should check if this is the case,
>>>> and just do -ECANCELED for this case rather than attempt to execute the
>>>> work. Most task_work doesn't do much outside of post a completion, but
>>>> yours seems complex in that attempts to map pages as well, for example.
>>>> In any case, regardless of whether you move the gup to the actual issue
>>>> side of things (which I think you should), then you'd want something
>>>> ala:
>>>>
>>>> if (req->task != current)
>>>>     don't issue, -ECANCELED
>>>>
>>>> in your task_work.nvme_uring_task_cb
>>>
>>> Thanks a lot for your help Jens! I'm a bit confused, doesn't this belong
>>> into __io_uring_cmd_do_in_task then? Because my task_work_cb function
>>> (passed to io_uring_cmd_complete_in_task) doesn't even have the request.
>>
>> Yeah it probably does, the uring_cmd case is a bit special is that it's
>> a set of helpers around task_work that can be consumed by eg fuse and
>> ublk. The existing users don't really do anything complicated on that
>> side, hence there's no real need to check. But since the ring/task is
>> going away, we should be able to generically do it in the helpers like
>> you did below.
> 
> That won't work, we should give commands an opportunity to clean up
> after themselves. I'm pretty sure it will break existing users.
> For now we can pass a flag to the callback, fuse would need to
> check it and fail. Compile tested only
> 
> commit a5b382f150b44476ccfa84cefdb22ce2ceeb12f1
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Fri Aug 30 15:43:32 2024 +0100
> 
>     io_uring/cmd: let cmds tw know about dying task
>         When the taks that submitted a request is dying, a task work for
> that
>     request might get run by a kernel thread or even worse by a half
>     dismantled task. We can't just cancel the task work without running the
>     callback as the cmd might need to do some clean up, so pass a flag
>     instead. If set, it's not safe to access any task resources and the
>     callback is expected to cancel the cmd ASAP.
>         Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> diff --git a/include/linux/io_uring_types.h
> b/include/linux/io_uring_types.h
> index ace7ac056d51..a89abec98832 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
>      /* set when uring wants to cancel a previously issued command */
>      IO_URING_F_CANCEL        = (1 << 11),
>      IO_URING_F_COMPAT        = (1 << 12),
> +    IO_URING_F_TASK_DEAD        = (1 << 13),
>  };
>  
>  struct io_zcrx_ifq;
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 8391c7c7c1ec..55bdcb4b63b3 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>  static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state
> *ts)
>  {
>      struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct
> io_uring_cmd);
> +    unsigned flags = IO_URING_F_COMPLETE_DEFER;
> +
> +    if (req->task->flags & PF_EXITING)
> +        flags |= IO_URING_F_TASK_DEAD;
>  
>      /* task_work executor checks the deffered list completion */
> -    ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
> +    ioucmd->task_work_cb(ioucmd, flags);
>  }
>  
>  void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
> 


Thanks and yeah you are right, the previous patch would have missed an
io_uring_cmd_done for fuse-uring as well.


Thanks,
Bernd

