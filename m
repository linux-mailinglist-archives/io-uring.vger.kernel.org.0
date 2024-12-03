Return-Path: <io-uring+bounces-5195-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B989E2F35
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 23:46:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D536282317
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 22:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50BB720125D;
	Tue,  3 Dec 2024 22:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="pXMoRmnp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="A5bd26M2"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1671362;
	Tue,  3 Dec 2024 22:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733265983; cv=none; b=ljuAN/vx6ILJJRvsniJjodgOO7uv5mjpU/xH4OczDSzVrxAct/wTiDUiCaqQHesPhwk3GIjipySVHvKOCMpTLmUmtsxwYMmg/0Ec8vuuFF/2p8vWvS2hkikeujaYBSr07X6ymSUoj5QR9OSAba86XCXSel0Fxy4cKN7FXOCFXsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733265983; c=relaxed/simple;
	bh=Pw4Tpjfbr4a7L3MyfK+RcgG3t6ueLZjQVrtRZfJWFRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mHOiufAp7TacNp9ztRHcdtuILEIHK64HZA3z1vbtqO4V7cDDzS8tnUWsGdnYnqSOg5MoTNYOxFgfVZNa9W/fN3fMWetPk1xNlb3Lf8p9qgtMA73/xiwBJ62i1F4/Q6hoojHoNOLQTb6DV1ts/bJcaXPyrIlIHOFZ2sLOLKBmvOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=pXMoRmnp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=A5bd26M2; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C0DA62540176;
	Tue,  3 Dec 2024 17:46:19 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Tue, 03 Dec 2024 17:46:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1733265979;
	 x=1733352379; bh=htbklwOwRf4CH+LSsKIEyTCk4UorTDrkjXku6ATDiFo=; b=
	pXMoRmnpssJZqb0BQzDUrwcT2qv4IjMNXbqH/aGSk34WIHe0PncMgEsOlD1Eet9W
	5ZrPscPmHtk3NFYHBsld3qaHzBIcNwqv246o1s6dtpQWkVscQJHJy8aqfVPhKhkS
	SZgrja4MhQGb/YugfIkJUu8g+vmLax66oPiDm01aHcwYRL4e1aW1D40WmXwnG1sa
	XE0a7WWOsAD51yli5Yio741NuAckQweLxt0jedHHEO/8JWxIdPJMNT5qYXMHn06n
	66jxl+NB++t6A8RSZC+i0wiH2es9h2cDUrx8cSwV0PlyzQgFitVOZgG+rQ+uzv6E
	858xFh7vCNwmmeUvt7OwLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1733265979; x=
	1733352379; bh=htbklwOwRf4CH+LSsKIEyTCk4UorTDrkjXku6ATDiFo=; b=A
	5bd26M2EzTBrdsnYgZ9VQ1iXmdJNztsZNaR++jRiDNGv5drtEDdh+igImbWSwHzn
	G2mEqfS0BHV0oOH5R5CETiEQngLVKrUPF0TrhKBTN1sebuKZ2FMdm5bw7VAsqaBt
	YcztAWwegdxpf5mOPfO+NcrkB9ALqFeswAY+yZpZ/Pps9vea7xAJJISevFCAywYC
	HDoe8HnN48fXkCEHoN+xYwBz3cxY/SWdN10NUFC4FuzNBP5kFj4X3azWhHoYlh2x
	zD2WTDYmlMNpR3QqdFXz+OgPk1weqXTyR2HOzW9wA69RUihuLJIxpIMUT1rpa1DR
	q5X7ObPojndCmwYyY9YJA==
X-ME-Sender: <xms:OopPZ8JpchBcZiO2ItmyAYThZsFyfSTYsBGB5KG70ZgtEHU9JkeWfA>
    <xme:OopPZ8Jvic7LrUXsGTLU23NVUfBcjnQDULJ1TsGHJ16lI1kPoK4_4e4GTo2kxcbpy
    Oc4fLEMvBnI58zU>
X-ME-Received: <xmr:OopPZ8s5JaWUMA1pCpqPh8c8ZwG8zyM5vZ5FOHDW6Nbj_2zr62e7js-OszXlb9-AcqrZqnU3yShMnBSQKxL9EnTfAQBLExbZ_qmjckOw_E8Lu1nNIQxM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrieegucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfurfetoffk
    rfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculd
    dquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhr
    ohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvghrthesfh
    grshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepudelfedvudevudevleegleff
    ffekudekgeevlefgkeeluedvheekheehheekhfefnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhhtsehfrghs
    thhmrghilhdrfhhmpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhhtphhouhhtpd
    hrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrdgtohhmpdhrtghpthht
    ohepsghstghhuhgsvghrthesuggunhdrtghomhdprhgtphhtthhopehmihhklhhoshessh
    iivghrvgguihdrhhhupdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgt
    phhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepjh
    hoshgvfhesthhogihitghprghnuggrrdgtohhmpdhrtghpthhtoheprghmihhrjeefihhl
    sehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:OopPZ5ZpzVhnx475poYFzpnEzKFudPdmIxEw9G8F5XAuoPYTc9c3DA>
    <xmx:OopPZzZ93gITFTogq_4GMszY086G_kyXIgy2_RqjfRpJOO78m03Blg>
    <xmx:OopPZ1Bw6N92TksAlA1REPFhzP7H-byUpdecd9uQ1aS15pg-syE02Q>
    <xmx:OopPZ5ZDPYdwI-P0PSRAFdApa7koEM5E0dPYi4lFdMShypakjkemdA>
    <xmx:O4pPZ3RVuVfWf6AeiLy5rRy8xOhHa5RXq49ecx8fvRu8ibXad3Wca_aS>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Dec 2024 17:46:17 -0500 (EST)
Message-ID: <b54f700c-9c26-4226-bfcf-c121bd9eee7a@fastmail.fm>
Date: Tue, 3 Dec 2024 23:46:16 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v7 11/16] fuse: {uring} Allow to queue fg requests
 through io-uring
To: Pavel Begunkov <asml.silence@gmail.com>,
 Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>,
 bernd@bsbernd.com
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com>
 <20241127-fuse-uring-for-6-10-rfc4-v7-11-934b3a69baca@ddn.com>
 <01f65cf0-19a3-4df1-9fcc-6b0fbc18e536@gmail.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <01f65cf0-19a3-4df1-9fcc-6b0fbc18e536@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 12/3/24 15:09, Pavel Begunkov wrote:
> On 11/27/24 13:40, Bernd Schubert wrote:
>> This prepares queueing and sending foreground requests through
>> io-uring.
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> ---
>>   fs/fuse/dev.c         |   5 +-
>>   fs/fuse/dev_uring.c   | 159 ++++++++++++++++++++++++++++++++++++++++
>> ++++++++++
>>   fs/fuse/dev_uring_i.h |   8 +++
>>   fs/fuse/fuse_dev_i.h  |   5 ++
>>   4 files changed, 175 insertions(+), 2 deletions(-)
>>
> ...
>> +
>> +/*
>> + * This prepares and sends the ring request in fuse-uring task context.
>> + * User buffers are not mapped yet - the application does not have
>> permission
>> + * to write to it - this has to be executed in ring task context.
>> + */
>> +static void
>> +fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
>> +                unsigned int issue_flags)
>> +{
>> +    struct fuse_uring_cmd_pdu *pdu = (struct fuse_uring_cmd_pdu
>> *)cmd->pdu;
>> +    struct fuse_ring_ent *ring_ent = pdu->ring_ent;
>> +    struct fuse_ring_queue *queue = ring_ent->queue;
>> +    int err;
>> +
>> +    BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
>> +
>> +    err = fuse_uring_prepare_send(ring_ent);
>> +    if (err)
>> +        goto err;
>> +
>> +    io_uring_cmd_done(cmd, 0, 0, issue_flags);
>> +
>> +    spin_lock(&queue->lock);
>> +    ring_ent->state = FRRS_USERSPACE;
> 
> I haven't followed the cancellation/teardown path well, but don't
> you need to set FRRS_USERSPACE before io_uring_cmd_done()?
> 
> E.g. while we're just before the spin_lock above here, can
> fuse_uring_stop_list_entries() find the request, see that the state
> is not FRRS_USERSPACE
> 
> bool need_cmd_done = ent->state != FRRS_USERSPACE;
> 
> and call io_uring_cmd_done a second time?

Sorry about the confusion, I had actually already fixed it in patch 14, 
the one that added handling of IO_URING_F_TASK_DEAD and that you asked
to merge into this patch here. Obviously at least that part should have
been part of this patch here.


Thanks again for your thorough review!


Bernd
Bernd

