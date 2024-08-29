Return-Path: <io-uring+bounces-2977-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5BA79652EE
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 00:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A5DF283281
	for <lists+io-uring@lfdr.de>; Thu, 29 Aug 2024 22:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA4F18A931;
	Thu, 29 Aug 2024 22:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="LztweQCm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="emZ/E6WA"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh5-smtp.messagingengine.com (fhigh5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2071D1898E5;
	Thu, 29 Aug 2024 22:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724970742; cv=none; b=ZLXnrdQwF4btAg6I3OMTz60K68paffap/MESBQbg2S07EaODiZyGjWRlYbNSuBmi+BVteOeJycz++w2SmH2kTxY6StJKMKHCFj1qFzr4IUrTDy/eSVOLg4s/i4IuX7me3mzi22TiJxUDvlqELG9H+OgO6lDEZrGC74yPq2FPTKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724970742; c=relaxed/simple;
	bh=XeSWmZDK6YKyj5zn6OGbg9ZlSxFmBV1I0njsAXwSGMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AP3kxLmbLJvJ8oXoxrnmLQYk+TEcbPYL/3QNsjf4N2WUP6pSYBFbJbXIUTdDjqita+9pRJUX+u0Ot9yRSj8H0yODvV+5mVhReQzzz54tXrRec1tABpmd+8NWKS8066n7fCKywfOY2IIuA2D3a7hNm0dJhh/ch4DZS/X+7wjgSlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=LztweQCm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=emZ/E6WA; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-04.internal (phl-compute-04.nyi.internal [10.202.2.44])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 44F951150A86;
	Thu, 29 Aug 2024 18:32:19 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 29 Aug 2024 18:32:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1724970739;
	 x=1725057139; bh=enAOl1YRQVTL+OqgTZ3TNARO/uDTbAsm1Iwz5rGJ2Wo=; b=
	LztweQCmuMCD6adtFs8g60LuNOcAfh5zwJL/tHGWf8brxCvj+y1yie0viNzmwSdz
	4SfiMDBu7dhpTdF96fL2iwF/J1KyAdEGaylLp5iKIbYAE5BgZanTOOk4frCLipeZ
	F6XtKZhSmPMKPDqn5sw6l8M8AN/tRRiY2rsbY5xuOdNRyqGkQ4VKyN63lMNFIGVX
	fsB49BP4h0BXNu8giKthvOBNIh8tnANV2bHpeI//nX/i+4cp4BKzaHLR+h4MKqKr
	wNBjOK/LWhOp1hvOd1EaljZAz+y1x6WsjG9tBro+JBFIyYzp6URwCx9NjQF+YHtv
	PJpEl2mHkOwA32Gw3TvS+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1724970739; x=
	1725057139; bh=enAOl1YRQVTL+OqgTZ3TNARO/uDTbAsm1Iwz5rGJ2Wo=; b=e
	mZ/E6WAx0L3MlsbbUIRIgIPr0hCNtIuv2IAplO1kcYTBP6O/Oi92xLgsbGk3VN1O
	/Hx26a6U1+k5SvbYJLleAXVpmM6PC8HQ/78LQky0w9589gHEfy8Gi3mkXRDY6Xo9
	al42Rp6oWoLBwPH8DTkIpEzYDvGDBnTL1JyUtSp7H7fbu63RchGwbx6/vgf+ODKj
	QlNGAb5DJvSIPHVljoaIMDMrbkSJn6v61wNwEzPi2zrPesu/l6tVNcrS6x4BpKfb
	2dC2OWGkX/5Zbh9cMRDEbQPGl2l1DTsSBLpY9mWm0QLruXU24lbs9loqovSbjHkH
	lJzId10FgL0uSol93N/cw==
X-ME-Sender: <xms:8vbQZqQMjj5l-nuJAd3r3RxGFMUKRwIUv6h2LyfhmoCD0_H66FQhFA>
    <xme:8vbQZvzV_GghBJITEJ-MvuYoMT5Fpb2Rx8GNjQ_sVX3uBdCXsp1gyrmHxAtLZ2FEM
    y35lNjqRnFpeN8X>
X-ME-Received: <xmr:8vbQZn3cl5824JULoDEFLCYbT8uBP0uVuObbiST_YkFEyr8QOlhzrbuwbAIwe5sU2tMWL0-b0usRhd43lm2EJR9ZbbmXSsWYBtFp_kC---6V2lk_nwSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudefhedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnheptddugefgjeefkedt
    gefhheegvddtfeejheehueeufffhfeelfeeuheetfedutdeinecuffhomhgrihhnpehgih
    hthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrihhlrdhfmhdpnhgspg
    hrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepsghstghhuhgs
    vghrthesuggunhdrtghomhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhh
    hupdhrtghpthhtoheprghmihhrjeefihhlsehgmhgrihhlrdgtohhmpdhrtghpthhtohep
    lhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehk
    vghnthdrohhvvghrshhtrhgvvghtsehlihhnuhigrdguvghvpdhrtghpthhtohepjhhosh
    gvfhesthhogihitghprghnuggrrdgtohhmpdhrtghpthhtohepjhhorghnnhgvlhhkohho
    nhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprgigsghovgeskhgvrhhnvghlrdgukh
X-ME-Proxy: <xmx:8vbQZmCb4FHHgFAHd7yOIJ4GMRLUwj1m4PXgo1ajwy4Uwk8TqZ_W5g>
    <xmx:8vbQZjgs_mB80hNExNbVlVu7wTxL6iK85vLeZCB_5czpEH-Fa5NJYw>
    <xmx:8vbQZirAeXzngS0l2v5hiMZIa267l6VGqTOrYL-PYBQ9F46K9Hz3SQ>
    <xmx:8vbQZmgf0mf_aL9PiOuGQj9r2xXvKSvZXIq54KQ8DQwc9l9DuoT1jw>
    <xmx:8_bQZiNU0w_MKghin__tM0plD0svczeJjUCY1I4wrFl_5kNRx6ZR8sr_>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Aug 2024 18:32:17 -0400 (EDT)
Message-ID: <7d42edd3-3e3b-452b-b3bf-fb8179858e48@fastmail.fm>
Date: Fri, 30 Aug 2024 00:32:16 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Josef Bacik <josef@toxicpanda.com>, Joanne Koong <joannelkoong@gmail.com>,
 Jens Axboe <axboe@kernel.dk>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <CAJfpegsq06UZSPCDB=0Q3OPoH+c3is4A_d2oFven3Ebou8XPOw@mail.gmail.com>
 <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
 <CAJfpeguMmTXJPzdnxe87hSBPO_Y8s33eCc_H5fEaznZYC-D8HA@mail.gmail.com>
 <3b74f850-c74c-49d0-be63-a806119cbfbd@ddn.com>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <3b74f850-c74c-49d0-be63-a806119cbfbd@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[I shortened the CC list as that long came up only due to mmap and optimizations]

On 6/12/24 16:56, Bernd Schubert wrote:
> On 6/12/24 16:07, Miklos Szeredi wrote:
>> On Wed, 12 Jun 2024 at 15:33, Bernd Schubert <bschubert@ddn.com> wrote:
>>
>>> I didn't do that yet, as we are going to use the ring buffer for requests,
>>> i.e. the ring buffer immediately gets all the data from network, there is
>>> no copy. Even if the ring buffer would get data from local disk - there
>>> is no need to use a separate application buffer anymore. And with that
>>> there is just no extra copy
>>
>> Let's just tackle this shared request buffer, as it seems to be a
>> central part of your design.
>>
>> You say the shared buffer is used to immediately get the data from the
>> network (or various other sources), which is completely viable.
>>
>> And then the kernel will do the copy from the shared buffer.  Single copy, fine.
>>
>> But if the buffer wasn't shared?  What would be the difference?
>> Single copy also.
>>
>> Why is the shared buffer better?  I mean it may even be worse due to
>> cache aliasing issues on certain architectures.  copy_to_user() /
>> copy_from_user() are pretty darn efficient.
> 
> Right now we have:
> 
> - Application thread writes into the buffer, then calls io_uring_cmd_done
> 
> I can try to do without mmap and set a pointer to the user buffer in the 
> 80B section of the SQE. I'm not sure if the application is allowed to 
> write into that buffer, possibly/probably we will be forced to use 
> io_uring_cmd_complete_in_task() in all cases (without 19/19 we have that 
> anyway). My greatest fear here is that the extra task has performance 
> implications for sync requests.
> 
> 
>>
>> Why is it better to have that buffer managed by kernel?  Being locked
>> in memory (being unswappable) is probably a disadvantage as well.  And
>> if locking is required, it can be done on the user buffer.
> 
> Well, let me try to give the buffer in the 80B section.
> 
>>
>> And there are all the setup and teardown complexities...
> 
> If the buffer in the 80B section works setup becomes easier, mmap and 
> ioctls go away. Teardown, well, we still need the workaround as we need 
> to handle io_uring_cmd_done, but if you could live with that for the 
> instance, I would ask Jens or Pavel or Ming for help if we could solve 
> that in io-uring itself.
> Is the ring workaround in fuse_dev_release() acceptable for you? Or do 
> you have any another idea about it?
> 
>>
>> Note: the ring buffer used by io_uring is different.  It literally
>> allows communication without invoking any system calls in certain
>> cases.  That shared buffer doesn't add anything like that.  At least I
>> don't see what it actually adds.
>>
>> Hmm?
> 
> The application can write into the buffer. We won't shared queue buffers 
> if we could solve the same with a user pointer.


Wanted to send out a new series today, 

https://github.com/bsbernd/linux/tree/fuse-uring-for-6.10-rfc3-without-mmap

but then just noticed a tear down issue.

 1525.905504] KASAN: null-ptr-deref in range [0x00000000000001a0-0x00000000000001a7]
[ 1525.910431] CPU: 15 PID: 183 Comm: kworker/15:1 Tainted: G           O       6.10.0+ #48
[ 1525.916449] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1525.922470] Workqueue: events io_fallback_req_func
[ 1525.925840] RIP: 0010:__lock_acquire+0x74/0x7b80
[ 1525.929010] Code: 89 bc 24 80 00 00 00 0f 85 1c 5f 00 00 83 3d 6e 80 b0 02 00 0f 84 1d 12 00 00 83 3d 65 c7 67 02 00 74 27 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00 74 0d e8 50 44 42 00 48 8b bc 24 80 00 00 00 48 c7
[ 1525.942211] RSP: 0018:ffff88810b2af490 EFLAGS: 00010002
[ 1525.945672] RAX: 0000000000000034 RBX: 0000000000000000 RCX: 0000000000000001
[ 1525.950421] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000001a0
[ 1525.955200] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[ 1525.959979] R10: dffffc0000000000 R11: fffffbfff07b1cbe R12: 0000000000000000
[ 1525.964252] R13: 0000000000000001 R14: dffffc0000000000 R15: 0000000000000001
[ 1525.968225] FS:  0000000000000000(0000) GS:ffff88875b200000(0000) knlGS:0000000000000000
[ 1525.973932] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1525.976694] CR2: 00005555b6a381f0 CR3: 000000012f5f1000 CR4: 00000000000006f0
[ 1525.980030] Call Trace:
[ 1525.981371]  <TASK>
[ 1525.982567]  ? __die_body+0x66/0xb0
[ 1525.984376]  ? die_addr+0xc1/0x100
[ 1525.986111]  ? exc_general_protection+0x1c6/0x330
[ 1525.988401]  ? asm_exc_general_protection+0x22/0x30
[ 1525.990864]  ? __lock_acquire+0x74/0x7b80
[ 1525.992901]  ? mark_lock+0x9f/0x360
[ 1525.994635]  ? __lock_acquire+0x1420/0x7b80
[ 1525.996629]  ? attach_entity_load_avg+0x47d/0x550
[ 1525.998765]  ? hlock_conflict+0x5a/0x1f0
[ 1526.000515]  ? __bfs+0x2dc/0x5a0
[ 1526.001993]  lock_acquire+0x1fb/0x3d0
[ 1526.004727]  ? gup_fast_fallback+0x13f/0x1d80
[ 1526.006586]  ? gup_fast_fallback+0x13f/0x1d80
[ 1526.008412]  gup_fast_fallback+0x158/0x1d80
[ 1526.010170]  ? gup_fast_fallback+0x13f/0x1d80
[ 1526.011999]  ? __lock_acquire+0x2b07/0x7b80
[ 1526.013793]  __iov_iter_get_pages_alloc+0x36e/0x980
[ 1526.015876]  ? do_raw_spin_unlock+0x5a/0x8a0
[ 1526.017734]  iov_iter_get_pages2+0x56/0x70
[ 1526.019491]  fuse_copy_fill+0x48e/0x980 [fuse]
[ 1526.021400]  fuse_copy_args+0x174/0x6a0 [fuse]
[ 1526.023199]  fuse_uring_prepare_send+0x319/0x6c0 [fuse]
[ 1526.025178]  fuse_uring_send_req_in_task+0x42/0x100 [fuse]
[ 1526.027163]  io_fallback_req_func+0xb4/0x170
[ 1526.028737]  ? process_scheduled_works+0x75b/0x1160
[ 1526.030445]  process_scheduled_works+0x85c/0x1160
[ 1526.032073]  worker_thread+0x8ba/0xce0
[ 1526.033388]  kthread+0x23e/0x2b0
[ 1526.035404]  ? pr_cont_work_flush+0x290/0x290
[ 1526.036958]  ? kthread_blkcg+0xa0/0xa0
[ 1526.038321]  ret_from_fork+0x30/0x60
[ 1526.039600]  ? kthread_blkcg+0xa0/0xa0
[ 1526.040942]  ret_from_fork_asm+0x11/0x20
[ 1526.042353]  </TASK>


We probably need to call iov_iter_get_pages2() immediately
on submitting the buffer from fuse server and not only when needed.
I had planned to do that as optimization later on, I think
it is also needed to avoid io_uring_cmd_complete_in_task().

The part I don't like here is that with mmap we had a complex
initialization - but then either it worked or did not. No exceptions
at IO time. And run time was just a copy into the buffer. 
Without mmap initialization is much simpler, but now complexity shifts
to IO time.


Thanks,
Bernd

