Return-Path: <io-uring+bounces-10448-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E3DCFC41CC4
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 23:12:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 92773340EEA
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 22:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5B92FFDCB;
	Fri,  7 Nov 2025 22:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="JEddRjL2";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="yGslYY8I"
X-Original-To: io-uring@vger.kernel.org
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE6C23D28F;
	Fri,  7 Nov 2025 22:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762553522; cv=none; b=qynwhO4yOwP3U0tlAG4oKUwPh1+kYRlyo+hb76Advk6lU5gcVxPWW1eO4FU6QkDzL/8Rhi9BsKNIm9kdPsCoT6HlU57ZeTA+WIoPGy/W6vPLKesFFkJmr0lEXUKGY7VdhJBaypWor8fTrlDg0athzTUxq3e7DSJJZHt0L+SvrD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762553522; c=relaxed/simple;
	bh=U8vifoR1nbgkidZhcbE0BnuEbKuLIxpGrMHsQWcxnRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CFsWZ+e97DecsLLTQX4E+uID7WTVWrWETBGGH7Nll8WSfYbhWg70ouyHr64V3IVh5TpyrR2dPJQITPJgvmnj1tmpSEUtdLcacAIkx0/GYdXlsgi+deS+2cSr1BFqfCNQXTp+c1uOK8wyLEon44UrNSvaZY/T1Q/R0DIwmAuTheo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=JEddRjL2; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=yGslYY8I; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id EB50BEC01E5;
	Fri,  7 Nov 2025 17:11:58 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 07 Nov 2025 17:11:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762553518;
	 x=1762639918; bh=skl5UA2/vsrRvlpIP4OCZ5whgX7odV1djdqv3Yfoz1s=; b=
	JEddRjL2Rbhk8hvSZaCeX3dBT47LmrpWTB4KkJdJz5YYuG8oDellJ4y8tvkzokoB
	Qa5MBxpKJrs8bsOclEelYLaUXZI0mBVzpe1iLyEXkndHIKkfUbMhAlZDu+xa3xwd
	WyACX6vbh02MEKvkNQU5HmhCX2LzDJ5o69/k8KKtWbHL3lo9e8F46jblONpR9o3m
	d5gp/IVOX3N3xCE8F4FJFRuBZX/YB0b0XuNMPBLFEiUnMrQLiMd8AHc5Fng3C0q9
	c3NM1YDtsn5m7f4nyMU9tpv2t8yCnPiPu7WF1+DUXkP/w5iHWSyVxCicyCzUIu1Q
	aGOeh7gKNB7i+jP5y0WKag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762553518; x=
	1762639918; bh=skl5UA2/vsrRvlpIP4OCZ5whgX7odV1djdqv3Yfoz1s=; b=y
	GslYY8IQu4Xq0cyONwAtXaD+oCQL6lD/f48CTj3/QbTFt3Xx9uPh05Ukg1cmNz+C
	wxvUwpa6c1ALR2YaP6U6PBblWA+redDrzmqynn414+5133JoDPJwh7XsGcSA/1bf
	ifC7vTpYiQnChenqUY4wGo6Yfe0fXK4SQoZr1rtxS3EYt3x12k3bRvXICK34Ryso
	0PbF5irCO+otZtLQwvQ7NWG+JteV8l0VEB5eOUUvbdFXO+CIk+Aw0ddnzKdJO83z
	X1ymdBRzvfAXC5wwm7mUmmubYzC35bqziEYfzPCAKUW5RddDzxSL+d+sxiw7YwjA
	4KMWgeL4lUcHSc9MbC+AQ==
X-ME-Sender: <xms:rW4OaXU1K7t_9fS2_dk_-NXfsezD-1Q6Z-TvW9P5OU8cN4b-orpINA>
    <xme:rW4OaSrivXHGwbb46xzGEKtLdozh6AV3IeJTpS9G6IrC-t3IuLa75SJN97Y4QoBWd
    NvYHkgSt4iSKJ_ovqZVOgES_oMzDtjTZOO_Yc0aGpqTvO6j_AlSSA>
X-ME-Received: <xmr:rW4OaeDf4E3W-rp_LrCYNJbX_thzM4c1mSh4bj5pa5EPyGb_iRwbi7eXDgeZsMFm55iwUi0hkll551xdBuzKVpsicnQRSLoXDk3jNXW_t0NORoUg-NxO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduledtkeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdejnecuhfhrohhmpeeuvghrnhgu
    ucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnhgurdgtohhmqeenucggtffrrg
    htthgvrhhnpeefgeegfeffkeduudelfeehleelhefgffehudejvdfgteevvddtfeeiheef
    lefgvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgtphhtthhopedutddpmhhouggv
    pehsmhhtphhouhhtpdhrtghpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrd
    gtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthho
    pegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheplhhinhhugidqfhhsuggvvh
    gvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegsshgthhhusggvrhht
    seguughnrdgtohhmpdhrtghpthhtoheprghsmhhlrdhsihhlvghntggvsehgmhgrihhlrd
    gtohhmpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepgihirghosghinhhgrdhlihesshgrmhhsuhhnghdrtghomhdprhgtph
    htthhopegtshgrnhguvghrsehpuhhrvghsthhorhgrghgvrdgtohhm
X-ME-Proxy: <xmx:rW4OaegJZa1rnaRJbCUecxsJDImw13QZOtFKibP_KcluD18x-Jwr4w>
    <xmx:rW4OacYQjID7o4pmKoJngJBqq3c8Raktf8nSQE6VkR9IEPIMtCnuQA>
    <xmx:rW4OafkYr3_YJuovZPE2oK-oElKoq6H49zaJFfZAzi4Gka5dq36HlQ>
    <xmx:rW4OaSgaBCsg0eDXkad1sD9G3zuPKJ_kW3v_p9pcahhE9N9ugAK54Q>
    <xmx:rm4OacP-znN9LJQSaGg8ixgVbVymcmRywXTa4BOBFymC8knyLUEiP7Dd>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Nov 2025 17:11:56 -0500 (EST)
Message-ID: <505ab86f-bf13-41b9-8ccc-6e5cb83ef1b8@bsbernd.com>
Date: Fri, 7 Nov 2025 23:11:55 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] fuse: use enum types for header copying
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
 bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org,
 xiaobing.li@samsung.com, csander@purestorage.com, kernel-team@meta.com
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-6-joannelkoong@gmail.com>
 <f74e1f05-5d66-4723-a689-338ee61d9b43@bsbernd.com>
 <CAJnrk1apBiPMrDZDyVfLeFKLPdPiB=4e1d7D3QHsX5_6ZtFccA@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1apBiPMrDZDyVfLeFKLPdPiB=4e1d7D3QHsX5_6ZtFccA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/6/25 22:59, Joanne Koong wrote:
> On Wed, Nov 5, 2025 at 3:01 PM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>> On 10/27/25 23:28, Joanne Koong wrote:
>>> Use enum types to identify which part of the header needs to be copied.
>>> This improves the interface and will simplify both kernel-space and
>>> user-space header addresses when fixed buffer support is added.
>>>
>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>> ---
>>>  fs/fuse/dev_uring.c | 55 ++++++++++++++++++++++++++++++++++++---------
>>>  1 file changed, 45 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>>> index faa7217e85c4..d96368e93e8d 100644
>>> --- a/fs/fuse/dev_uring.c
>>> +++ b/fs/fuse/dev_uring.c
>>> @@ -31,6 +31,12 @@ struct fuse_uring_pdu {
>>>
>>>  static const struct fuse_iqueue_ops fuse_io_uring_ops;
>>>
>>> +enum fuse_uring_header_type {
>>> +     FUSE_URING_HEADER_IN_OUT,
>>
>> In post review of my own names, headers->in_out is rather hard to
>> understand, I would have probably chosen "msg_in_out" now.
>> With that _maybe_ FUSE_URING_HEADER_MSG_IN_OUT?
> 
> Ahh I personally find "msg" a bit more confusing because "message"
> makes me think it refers just to the payload since the whole thing is
> usually called the request. So if we had to rename it, maybe
> FUSE_URING_HEADER_REQ_IN_OUT? Though I do like your original naming of
> it, FUSE_URING_HEADER_IN_OUT since FUSE_URING_FUSE_HEADER_IN_OUT
> sounds a little redundant.

FUSE_URING_HEADER_REQ_IN_OUT sounds nice to me. Renaming was just a
suggestion. Let's keep the current name if you prefer that.

> 
> I'll add some comments on top of this too, eg "/*struct fuse_in_header
> / struct_fuse_out_header */, to clarify.

Comments are always helpful :)

> 
>>
>>> +     FUSE_URING_HEADER_OP,
>>> +     FUSE_URING_HEADER_RING_ENT,
>>> +};
>>> @@ -800,7 +835,7 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
>>>       struct fuse_conn *fc = ring->fc;
>>>       ssize_t err = 0;
>>>
>>> -     err = copy_header_from_ring(&req->out.h, &ent->headers->in_out,
>>> +     err = copy_header_from_ring(ent, FUSE_URING_HEADER_IN_OUT, &req->out.h,
>>>                                   sizeof(req->out.h));
>>>       if (err) {
>>>               req->out.h.error = err;
>>
>>
>> Reviewed-by: Bernd Schubert <bschubert@ddn.com>
> 
> Thanks for reviewing the patches!
> 


