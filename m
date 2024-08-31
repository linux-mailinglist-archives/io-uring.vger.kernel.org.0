Return-Path: <io-uring+bounces-2990-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B862966E4A
	for <lists+io-uring@lfdr.de>; Sat, 31 Aug 2024 02:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3014289FE8
	for <lists+io-uring@lfdr.de>; Sat, 31 Aug 2024 00:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870B63C30;
	Sat, 31 Aug 2024 00:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="hAwCMSar";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XBq/B8Vg"
X-Original-To: io-uring@vger.kernel.org
Received: from fout1-smtp.messagingengine.com (fout1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93EE17C9E;
	Sat, 31 Aug 2024 00:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725065362; cv=none; b=rJYdxRDAgKNaVFjsPZ/gG5Gb7Z+vxAnf8QVNO65YUyPR/D7K6XyDy/8hhDBtewM1GbJD/Efoz+8vN4/Mvz5X9BLlB0kEKguV7JFP1cSUzKdinZysOOrrHuZniJzowm9VFofXWzT9+1+/39la50KKxckgPkI5q423C0UYvS3J0/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725065362; c=relaxed/simple;
	bh=CyC9V0hBSyBh/iSEgXhMVNDGBO7w/e96CctN7McN/z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ucUr5uFK5N8I56gj4/shE54Z0WyUxiWec8FGTb4ymT688i9yuqNHLCRbP6dIUQnHRnV8mZRFzW+AFzb4jkFBHQig94FjuGQzI0niE1GoinpAQLcAQ2vFz7w7Mcw7LhgmxjiYJI4UXnXs56zOEGmOSRC6P5u3rM/hKE/X8l/Uz/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=hAwCMSar; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XBq/B8Vg; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-06.internal (phl-compute-06.nyi.internal [10.202.2.46])
	by mailfout.nyi.internal (Postfix) with ESMTP id D1ABE13802F0;
	Fri, 30 Aug 2024 20:49:19 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 30 Aug 2024 20:49:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725065359;
	 x=1725151759; bh=wFQuF8auuWNtfFnKtIsHMiaQNIidnuLH5fOt6gCMkyM=; b=
	hAwCMSar2qs0Tf9SwiSmL8a/ks41tVluxQFeghtT7x4/DaNdBLCMj7opXPi9eMaa
	oW9YxOmd5ry5HYl2nbkGbU8xm+3s+ZEN2QFJZpdMUBiYKNzb+2iPrAn/KjSzFNNp
	CvBG5iEItxkzh5B7YHtMCszwTNrXaZxKuT2CBV/yfR/beKm3V8m0tF/7j3TV9ILp
	YUkmDnDjh1StWWfxE+rbWwXp/YJdko7o5uRFEvEpJael4dQzX5+l0kKMPD/kEVgk
	7WSWyM44Rq56cuh8LeCBG9KbQI9lzAEn6hxZjpFr8W6naEc1hFL0BXbYFPNL/KFI
	Yzfs4JqMidTPHkHYioY5WQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725065359; x=
	1725151759; bh=wFQuF8auuWNtfFnKtIsHMiaQNIidnuLH5fOt6gCMkyM=; b=X
	Bq/B8Vg100AINQmCIUfONrQpdS2HXewY3qq8z6MGImz5ElvF3ioSCvceZdDRxK83
	IWdKeQpCipdGJcZfXiHYOYFIPhXEddpciFMI1XAusGxJkV6eKG1quWCW/T2WTrJf
	24VyFFy73By7aEGlm2QcgbY/PzN+r71x1CyRoyrNv7wZCISI8TAivUGG1wMjW3xE
	rULLpgG/JOht01yygY2b6AnGeOztxlmYB/piFaX6FPjh+aVzo5AD0w48a3WMaN0/
	YZU2Be0sVqoPCgy4WHQGJCer5VeU2nINrZtjk2Xgcxfz7zFIEMKC9UzGCwn2OgFe
	i9egC3AqrRY4jjMO1K49Q==
X-ME-Sender: <xms:j2jSZvPwchP3D1goCyB3J4UmzR5x8Ue8_9uMCevp0gQCmPICEmw_Dw>
    <xme:j2jSZp8FZa4SS7bRwquXZplgDYFoFb-wjm9XipoLdnUuhUM3_r4jes0ghFcgmwXaO
    UY7lyn_5gMBt_wH>
X-ME-Received: <xmr:j2jSZuSWBAziTxQQPihi1DtgmWScEO7eKw_emQYmqAKbzbbO4eeKsldg0E0aNpJUTgYSQwadqGU2Z4HIuxDlmkhGUC6CMcQ0EUGOCUDn5s_5bc38vIkT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudefjedgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepvefhgfdvledtudfg
    tdfggeelfedvheefieevjeeifeevieetgefggffgueelgfejnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnugdrshgthhhusggvrhht
    sehfrghsthhmrghilhdrfhhmpdhnsggprhgtphhtthhopedutddpmhhouggvpehsmhhtph
    houhhtpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegr
    shhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopegsshgthhhusg
    gvrhhtseguughnrdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhh
    uhdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomhdprhgtphhtthhope
    hlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    ohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkh
    gvnhhtrdhovhgvrhhsthhrvggvtheslhhinhhugidruggvvhdprhgtphhtthhopehjohhs
    vghfsehtohigihgtphgrnhgurgdrtghomh
X-ME-Proxy: <xmx:j2jSZjuDmFRxuBtGi_t3VfHc9PiP4HESTxxcI-mnzs5V0FPsyVaVDg>
    <xmx:j2jSZnemfmuLWXUm8oqeAPZ4oEKDR3nf5HWrWcSUCBjTx94V4wPfqg>
    <xmx:j2jSZv1mFrcW_bvIrVfdU69-lwUCDs6qA0GFmgzKkkj302I9Y83Gaw>
    <xmx:j2jSZj-56t6xn4fXlrtDF48C4Csw_CZiXddivXWx7ypyDoUh5h9adA>
    <xmx:j2jSZoXEx-anR2Spdvb6IHrB-wJdhjO22MDHu_ay0lFVKO8ro8oH7hN_>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Aug 2024 20:49:18 -0400 (EDT)
Message-ID: <fb11db2e-63c7-45ee-b1d2-5357e2ee48b4@fastmail.fm>
Date: Sat, 31 Aug 2024 02:49:17 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
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
 <da99afb7-ff6f-4fa4-bfdc-994e34125c33@kernel.dk>
 <05e5a30f-51a7-4e4c-8806-d21d3bff4c1c@fastmail.fm>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <05e5a30f-51a7-4e4c-8806-d21d3bff4c1c@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/31/24 02:02, Bernd Schubert wrote:
> 
> 
> On 8/30/24 22:08, Jens Axboe wrote:
>> On 8/30/24 8:55 AM, Pavel Begunkov wrote:
>>> On 8/30/24 14:33, Jens Axboe wrote:
>>>> On 8/30/24 7:28 AM, Bernd Schubert wrote:
>>>>> On 8/30/24 15:12, Jens Axboe wrote:
>>>>>> On 8/29/24 4:32 PM, Bernd Schubert wrote:
>>>>>>> We probably need to call iov_iter_get_pages2() immediately
>>>>>>> on submitting the buffer from fuse server and not only when needed.
>>>>>>> I had planned to do that as optimization later on, I think
>>>>>>> it is also needed to avoid io_uring_cmd_complete_in_task().
>>>>>>
>>>>>> I think you do, but it's not really what's wrong here - fallback work is
>>>>>> being invoked as the ring is being torn down, either directly or because
>>>>>> the task is exiting. Your task_work should check if this is the case,
>>>>>> and just do -ECANCELED for this case rather than attempt to execute the
>>>>>> work. Most task_work doesn't do much outside of post a completion, but
>>>>>> yours seems complex in that attempts to map pages as well, for example.
>>>>>> In any case, regardless of whether you move the gup to the actual issue
>>>>>> side of things (which I think you should), then you'd want something
>>>>>> ala:
>>>>>>
>>>>>> if (req->task != current)
>>>>>>     don't issue, -ECANCELED
>>>>>>
>>>>>> in your task_work.nvme_uring_task_cb
>>>>>
>>>>> Thanks a lot for your help Jens! I'm a bit confused, doesn't this belong
>>>>> into __io_uring_cmd_do_in_task then? Because my task_work_cb function
>>>>> (passed to io_uring_cmd_complete_in_task) doesn't even have the request.
>>>>
>>>> Yeah it probably does, the uring_cmd case is a bit special is that it's
>>>> a set of helpers around task_work that can be consumed by eg fuse and
>>>> ublk. The existing users don't really do anything complicated on that
>>>> side, hence there's no real need to check. But since the ring/task is
>>>> going away, we should be able to generically do it in the helpers like
>>>> you did below.
>>>
>>> That won't work, we should give commands an opportunity to clean up
>>> after themselves. I'm pretty sure it will break existing users.
>>> For now we can pass a flag to the callback, fuse would need to
>>> check it and fail. Compile tested only
>>
>> Right, I did actually consider that yesterday and why I replied with the
>> fuse callback needing to do it, but then forgot... Since we can't do a
>> generic cleanup callback, it'll have to be done in the handler.
>>
>> I do like making this generic and not needing individual task_work
>> handlers like this checking for some magic, so I like the flag addition.
>>
> 
> Found another issue in (error handling in my code) while working on page 
> pinning of the user buffer and fixed that first. Ways to late now (or early)
> to continue with the page pinning, but I gave Pavels patch a try with the
> additional patch below - same issue. 
> I added a warn message to see if triggers - doesn't come up
> 
> 	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
> 		pr_warn("IO_URING_F_TASK_DEAD");
> 		goto terminating;
> 	}
> 
> 
> I could digg further, but I'm actually not sure if we need to. With early page pinning
> the entire function should go away, as I hope that the application can write into the
> buffer again. Although I'm not sure yet if Miklos will like that pinning.

Works with page pinning, new series comes once I got some sleep (still
need to write the change log).


Thanks,
Bernd

