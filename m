Return-Path: <io-uring+bounces-2989-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC1B9966D23
	for <lists+io-uring@lfdr.de>; Sat, 31 Aug 2024 02:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43190B21FE3
	for <lists+io-uring@lfdr.de>; Sat, 31 Aug 2024 00:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21CC2582;
	Sat, 31 Aug 2024 00:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="ta5T3O6O";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JCAk8D13"
X-Original-To: io-uring@vger.kernel.org
Received: from fout1-smtp.messagingengine.com (fout1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEA519A;
	Sat, 31 Aug 2024 00:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725062582; cv=none; b=DYKPUCKCPK41NbxaLY3lg4auAtHzsHwWBU4K1Pcwt1SMnszmmysJnkFp0krNphCfn9V77Wr4nC5sKV96SL8pCVJ+6+hMefyboXxzVuM2nBS9mydJoUdSXy+fRmgc46/BDysp1MpSiY3GhaPLfnMMLpYdMB1/+O+z+ITQzyhwn58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725062582; c=relaxed/simple;
	bh=x6uH14WPiEhlseFjPDvRWfMJfjGuIso2JwrkE1FxaI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hBCNr2H+KhlhDoanBtzqQQ8+AlNkXuZxAdA2Sty35QNbHfxz/v2DGted2VGlqSckLaqVPRb7DT7NMka6oxY5UgVO2YRqSdkAGpkWx64LyHXMYrgABTjhwIkQRp6gazixKCZZnWOesjzeN0r2/UWIZFqSxFVyO8cOdRzrjQUWWls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=ta5T3O6O; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JCAk8D13; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-02.internal (phl-compute-02.nyi.internal [10.202.2.42])
	by mailfout.nyi.internal (Postfix) with ESMTP id BA6A113800A7;
	Fri, 30 Aug 2024 20:02:59 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 30 Aug 2024 20:02:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1725062579;
	 x=1725148979; bh=l6dIz5068/cgeYDFYa3MGBcW5kaVXgJmob2TJJXwkY8=; b=
	ta5T3O6O/9Wlgm9cC8M1dWeVaTfATCQUxkMCow/b42FaTK8AJ2uAoFVaJ/6Zl+gr
	EDrDyUwGqO0zIQye6cT+gSB4Lm3GbYoFdiXZ5OZki+Vp8yHS91UiZKdlWf2bRl4m
	CeeGRoQgv3pY3ENKw0nAvnM+SkeXJmBtuIc5i7c1CcGm8Kry2CTVeqvRmnQ/vtuW
	jqGOjvteuevDn35ykaJUZ195jRleGya1ZPSLtl81airPlHT0nvWWYGcDrBCFCoN0
	Si8AVnhkQ852xOLk6ldIZRrltQX6oyiOHU/ADIXW3nNaB7ZtpheZ2Q83N2QF/Uus
	18aOlBoIOP9s3gRqGYgSeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1725062579; x=
	1725148979; bh=l6dIz5068/cgeYDFYa3MGBcW5kaVXgJmob2TJJXwkY8=; b=J
	CAk8D131Djimi4uvlZFHA7nh/3kLbpnUbbP0SVBFgnuCx9Lpe2Nk7bCq8gZDiSDP
	L6sdJpJpPeADrfm8Rn5nt9ctf/avv6JiZ6YiFtfPSt2z0Hst7sCTEF4LvXO5XObL
	kUuHVEdiWRC73OJ4wYNlgzPPf280v3/nNrpTuQqmiACbpkToqcduXKa4ShMCTBsD
	4jjX6FR8AXiggsxMMG16zWjSEEqyhd1lkxtNQzdjfDm3G+ocELdFuM+Emgtvx9wT
	EDJDpAXi++fHewceROszlYlnMu/exYQWWBKJNygxB3cHhO2gAJS1CCr9BIqqIeS1
	saMPw3ErlHSAnjx0YKKMw==
X-ME-Sender: <xms:s13SZkpuBYywdTLHIzJIMQT5tHj6861PJDKkp9ibe5cUAN1-vPUMCg>
    <xme:s13SZqqNlJ_NvPY1kwFsFC883AXb6kkis5BSNQAAlZEfiyYrWXpz9268GpmaU24mC
    ofRgTLnZo25gU-j>
X-ME-Received: <xmr:s13SZpNln2UMKtoIp29QxDzCL1GYOMVb5lGpA7th73t4MGJiszIcobXytN0Rq6FDrgyJKFFdTcFlJ-KTOn6vO-r-y47WPYkaYmfq2PiKrcoW_47wwL10>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudefjedgvdelucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:s13SZr69h9xOZilSblBuXJndPZB4ImMOP6GN9-ZTS8l1C9SoiCsyaw>
    <xmx:s13SZj5CsMXPKx-cpPavwHaaOvq2oNr-N6IxU_TGhE91w3jA5ebSSQ>
    <xmx:s13SZriEnt2_X6vPSMQnSCeQrDMl-cNryuG-UCFaAzqjuZ1pfJfmng>
    <xmx:s13SZt5j-SN_1ieODr-tmGFU_f7az_KOI009VreNxcfHgFITvgXGBA>
    <xmx:s13SZgzgw2br3WZ1hLBFvOpCXUzZsf5eiLE1NY2qwXs5-KAOsrkPzAqF>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 30 Aug 2024 20:02:57 -0400 (EDT)
Message-ID: <05e5a30f-51a7-4e4c-8806-d21d3bff4c1c@fastmail.fm>
Date: Sat, 31 Aug 2024 02:02:56 +0200
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
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <da99afb7-ff6f-4fa4-bfdc-994e34125c33@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/30/24 22:08, Jens Axboe wrote:
> On 8/30/24 8:55 AM, Pavel Begunkov wrote:
>> On 8/30/24 14:33, Jens Axboe wrote:
>>> On 8/30/24 7:28 AM, Bernd Schubert wrote:
>>>> On 8/30/24 15:12, Jens Axboe wrote:
>>>>> On 8/29/24 4:32 PM, Bernd Schubert wrote:
>>>>>> We probably need to call iov_iter_get_pages2() immediately
>>>>>> on submitting the buffer from fuse server and not only when needed.
>>>>>> I had planned to do that as optimization later on, I think
>>>>>> it is also needed to avoid io_uring_cmd_complete_in_task().
>>>>>
>>>>> I think you do, but it's not really what's wrong here - fallback work is
>>>>> being invoked as the ring is being torn down, either directly or because
>>>>> the task is exiting. Your task_work should check if this is the case,
>>>>> and just do -ECANCELED for this case rather than attempt to execute the
>>>>> work. Most task_work doesn't do much outside of post a completion, but
>>>>> yours seems complex in that attempts to map pages as well, for example.
>>>>> In any case, regardless of whether you move the gup to the actual issue
>>>>> side of things (which I think you should), then you'd want something
>>>>> ala:
>>>>>
>>>>> if (req->task != current)
>>>>>     don't issue, -ECANCELED
>>>>>
>>>>> in your task_work.nvme_uring_task_cb
>>>>
>>>> Thanks a lot for your help Jens! I'm a bit confused, doesn't this belong
>>>> into __io_uring_cmd_do_in_task then? Because my task_work_cb function
>>>> (passed to io_uring_cmd_complete_in_task) doesn't even have the request.
>>>
>>> Yeah it probably does, the uring_cmd case is a bit special is that it's
>>> a set of helpers around task_work that can be consumed by eg fuse and
>>> ublk. The existing users don't really do anything complicated on that
>>> side, hence there's no real need to check. But since the ring/task is
>>> going away, we should be able to generically do it in the helpers like
>>> you did below.
>>
>> That won't work, we should give commands an opportunity to clean up
>> after themselves. I'm pretty sure it will break existing users.
>> For now we can pass a flag to the callback, fuse would need to
>> check it and fail. Compile tested only
> 
> Right, I did actually consider that yesterday and why I replied with the
> fuse callback needing to do it, but then forgot... Since we can't do a
> generic cleanup callback, it'll have to be done in the handler.
> 
> I do like making this generic and not needing individual task_work
> handlers like this checking for some magic, so I like the flag addition.
> 

Found another issue in (error handling in my code) while working on page 
pinning of the user buffer and fixed that first. Ways to late now (or early)
to continue with the page pinning, but I gave Pavels patch a try with the
additional patch below - same issue. 
I added a warn message to see if triggers - doesn't come up

	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
		pr_warn("IO_URING_F_TASK_DEAD");
		goto terminating;
	}


I could digg further, but I'm actually not sure if we need to. With early page pinning
the entire function should go away, as I hope that the application can write into the
buffer again. Although I'm not sure yet if Miklos will like that pinning.


bschubert2@imesrv6 linux.git>stg show handle-IO_URING_F_TASK_DEAD
commit 42b4dae795bd37918455bad0ce3eea64b28be03c (HEAD -> fuse-uring-for-6.10-rfc3-without-mmap)
Author: Bernd Schubert <bschubert@ddn.com>
Date:   Sat Aug 31 01:26:26 2024 +0200

    fuse: {uring} Handle IO_URING_F_TASK_DEAD
    
    The ring task is terminating, it not safe to still access
    its resources. Also no need for further actions.

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index e557f595133b..1d5dfa9c0965 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1003,6 +1003,9 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
        BUILD_BUG_ON(sizeof(pdu) > sizeof(cmd->pdu));
        int err;
 
+       if (unlikely(issue_flags & IO_URING_F_TASK_DEAD))
+               goto terminating;
+
        err = fuse_uring_prepare_send(ring_ent);
        if (err)
                goto err;
@@ -1017,6 +1020,10 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
        return;
 err:
        fuse_uring_next_fuse_req(ring_ent, queue);
+
+terminating:
+       /* Avoid all actions as the task that issues the ring is terminating */
+       io_uring_cmd_done(cmd, -ECANCELED, 0, issue_flags);
 }
 
 /* queue a fuse request and send it if a ring entry is available */




Thanks,
Bernd

