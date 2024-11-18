Return-Path: <io-uring+bounces-4789-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0B89D1C06
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 00:48:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF0691F225EA
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 23:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5BE19C54B;
	Mon, 18 Nov 2024 23:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="Z+7SCZDs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ANLnZlVO"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DD913DBBE;
	Mon, 18 Nov 2024 23:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731973679; cv=none; b=nxtO5rDKS7/GYIi85/1hQOdh4sz2dXBZuLqWkC9SzdRX6Kvei4GEhez3F/l+mDVL8EFsg2aDy1+3CDZJyErOPRI+szkQWnsCn2f+rpt3KjUEbTNI6++inejHhGDSzhMAYUhLGqUJUCYZ+A7ykeeli6Rp3T0zxbX0Fo94IlWBp20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731973679; c=relaxed/simple;
	bh=iBVHg3IEafuD73dUUWQ5EJGeH3XPwxwEpn7KIG4MR3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tYFHYW0hXCvQ56Ainfl94JNVwrPQ+tspNVrq1t39UGZNqa0L29K7/0TWKxxA2YAOo6Bk9OmlBCdzWHazu6oWvSYslDnmTifiQzPkVAmIfsTRCNdn3N9IIBvfVhE7YPkPay6g+69/hlsNTf1jm4VPOTSHVvf+4bb5QwIIuG+vg7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=Z+7SCZDs; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ANLnZlVO; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id A2C341140196;
	Mon, 18 Nov 2024 18:47:55 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 18 Nov 2024 18:47:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1731973675;
	 x=1732060075; bh=yiuwHaKdpl+mqeAJRbEzrwIkYzdksmHGumHpEu9Fjcc=; b=
	Z+7SCZDsUYXIZqGn2ewETSfSIr+rrKrBc/mqdMtQ6/4Q/NFan7cTcXsVus5qlwVH
	I/ce5hf/FS/0Cb+0bqht/rmBRD+l32eoLLht5DCnR7O9xbKUovW3XKOgtdo4od88
	6TNymwCX8v28BhsB8qORuCSr3iFKvGRknfHTArCH2a03H84FqsNYmIyPJYujvdbA
	JQzKNZFy8uB4D2GERhrHvQl6YJrbceD9dSPX5ikuuSdhmEn5G48kpedi2BHq3vDP
	ZvTx2EVZo1Ng5lNRirI5x4waeAv2pVUNhqh9kAkLixZhzI3DhquIy2Uhj5yjmOHA
	+gLPXpoydv2yKrJd9iJRIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1731973675; x=
	1732060075; bh=yiuwHaKdpl+mqeAJRbEzrwIkYzdksmHGumHpEu9Fjcc=; b=A
	NLnZlVO6mysEa6KUj+OISzrjPsH1h9NxFRY7H+ODp4y3nHj2YOlH/AlNCWK0GE3L
	K0C+s504jzzEaFs87wMQC28oFnpPhLVMcCvy8isUR93zoMhg1DQl8hYoERIq28y7
	2T5aVplN9X52x06verQR/GwW1b1ufXaElifBwcZpDbTTOUReNu8F87r8sf/r5Qlc
	BQ48t5aFSEfyNvpbth9FpoMl5NOJt26WcHEISzPffKjWodJdZRhIk+0Hvhly6/sx
	rQahrhA9aniBuZo+eIKPz+zENVXSnC/LHkoIEn8C3GiaHwHwlVdCkorxaA+7lUTA
	tXT1SMwvE7FDwbP2g9rwA==
X-ME-Sender: <xms:KtI7Z5Gs4Fl-wkopYptinfjuRVo0hSxD3ETR1r0ggnwgfTvspLqOdA>
    <xme:KtI7Z-XbVTt0TBtHmPWzQOQoelUpxPeJp1IRsGj0cE5KLiH3Zwl6kmWFUmr7NUdpR
    2erggvyW_DJB-4t>
X-ME-Received: <xmr:KtI7Z7K2mqvxVoRU2k9pGMPiH0uNphFLZGCxZ_HFEwydselG3-7XZF4su1Y_Dgzl1cOsTAWYlkizgTZCQc2zUOotdbgapH7Ioj3BWN_UxL3ou2wGG_0_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrfedugddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdpuffr
    tefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnth
    hsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthekredttddvjeen
    ucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrh
    htsehfrghsthhmrghilhdrfhhmqeenucggtffrrghtthgvrhhnpeevgfeukedtfeeugfek
    ueeikeeileejheffjeehleduieefteeufefhteeuhefhfeenucffohhmrghinhepkhgvrh
    hnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepsggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrghilhdrfhhmpdhnsggprh
    gtphhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepjhhorghnnhgv
    lhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepsghstghhuhgsvghrthesug
    gunhdrtghomhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghp
    thhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegrshhmlhdrshhilh
    gvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghl
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinhhgsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghn
    uggrrdgtohhmpdhrtghpthhtoheprghmihhrjeefihhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:KtI7Z_Eh_x3nC_u1i514j91XNkyG8sPPosoSEh5gF6zKA6JMm-ryZw>
    <xmx:KtI7Z_W9j4JjXH2C25i8yRBcT1lw6UKzJ20s44TA0IjGlI_bS2P8og>
    <xmx:KtI7Z6OboNCUHWpRkqt1tsFSzTyZxfX_i6PBEUExqt8e6g4U8eazBg>
    <xmx:KtI7Z-1HGGcyxs3kXmxoUjJvzHOKsrfzo1nNMhqu3VllZ1A_mEzjYA>
    <xmx:K9I7Z4sdynvwiWgdEVYlZyQNDzJB1TRe3OPWfqSU4baAGPfJb44re2rR>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Nov 2024 18:47:52 -0500 (EST)
Message-ID: <19af894d-d5ac-4fcf-8fa1-b387c354c669@fastmail.fm>
Date: Tue, 19 Nov 2024 00:47:51 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>, bernd@bsbernd.com
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
 <20241107-fuse-uring-for-6-10-rfc4-v5-15-e8660a991499@ddn.com>
 <CAJnrk1YuoiWzq=ykn9wFKG3RZYdFm-AzSiXfoP=Js0S-P7eKZA@mail.gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1YuoiWzq=ykn9wFKG3RZYdFm-AzSiXfoP=Js0S-P7eKZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/19/24 00:30, Joanne Koong wrote:
> On Thu, Nov 7, 2024 at 9:04 AM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> When the fuse-server terminates while the fuse-client or kernel
>> still has queued URING_CMDs, these commands retain references
>> to the struct file used by the fuse connection. This prevents
>> fuse_dev_release() from being invoked, resulting in a hung mount
>> point.
>>
>> This patch addresses the issue by making queued URING_CMDs
>> cancelable, allowing fuse_dev_release() to proceed as expected
>> and preventing the mount point from hanging.
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> ---
>>  fs/fuse/dev_uring.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 70 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> index 6af515458695ccb2e32cc8c62c45471e6710c15f..b465da41c42c47eaf69f09bab1423061bc8fcc68 100644
>> --- a/fs/fuse/dev_uring.c
>> +++ b/fs/fuse/dev_uring.c
>> @@ -23,6 +23,7 @@ MODULE_PARM_DESC(enable_uring,
>>
>>  struct fuse_uring_cmd_pdu {
>>         struct fuse_ring_ent *ring_ent;
>> +       struct fuse_ring_queue *queue;
>>  };
>>
>>  /*
>> @@ -382,6 +383,61 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
>>         }
>>  }
>>
>> +/*
>> + * Handle IO_URING_F_CANCEL, typically should come on daemon termination
>> + */
>> +static void fuse_uring_cancel(struct io_uring_cmd *cmd,
>> +                             unsigned int issue_flags, struct fuse_conn *fc)
>> +{
>> +       struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu *)cmd->pdu;
>> +       struct fuse_ring_queue *queue = pdu->queue;
>> +       struct fuse_ring_ent *ent;
>> +       bool found = false;
>> +       bool need_cmd_done = false;
>> +
>> +       spin_lock(&queue->lock);
>> +
>> +       /* XXX: This is cumbersome for large queues. */
>> +       list_for_each_entry(ent, &queue->ent_avail_queue, list) {
>> +               if (pdu->ring_ent == ent) {
>> +                       found = true;
>> +                       break;
>> +               }
>> +       }
> 
> Do we have to check that the entry is on the ent_avail_queue, or can
> we assume that if the ent->state is FRRS_WAIT, the only queue it'll be
> on is the ent_avail_queue? I see only one case where this isn't true,
> for teardown in fuse_uring_stop_list_entries() - if we had a
> workaround for this, eg having some teardown state signifying that
> io_uring_cmd_done() needs to be called on the cmd and clearing
> FRRS_WAIT, then we could get rid of iteration through ent_avail_queue
> for every cancelled cmd.


I'm scared that we would run into races - I don't want to access memory
pointed to by pdu->ring_ent, before I'm not sure it is on the list.
Remember the long discussion Miklos and I had about the tiny 'tag'
variable and finding requests using existing hash lists [0] ? 
Personally I would prefer an array of 

struct queue_entries {
	struct fuse_ring_ent *ring_ent;
	bool valid;
}


in struct fuse_ring_queue {
    ...
    struct queue_entries *entries[]
}

And that array would only get freed on queue destruction. Besides
avoiding hash lists, it would also allow to use 'valid' to know if
we can access the ring_entry and then check the state.

Thanks,
Bernd


[0] https://lore.kernel.org/linux-fsdevel/CAJfpegu_UQ1BNp0UDHeOZFWwUoXbJ_LP4W=o+UX6MB3DsJbH8g@mail.gmail.com/T/#t

