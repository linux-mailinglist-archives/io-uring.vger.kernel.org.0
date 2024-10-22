Return-Path: <io-uring+bounces-3897-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C189A9FE2
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 12:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5852A1F235BE
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 10:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47556199FDC;
	Tue, 22 Oct 2024 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="c90OqJmu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="f/y1xkgT"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB97918E02D;
	Tue, 22 Oct 2024 10:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729592651; cv=none; b=KuTpUeSGk3JdrqYw3JR51y8IbsbTwzoGlLEr6DaM0TxYQ7S2K1QWvc1dVWMk/hiclkn2JAyDHZOaqbCx+MwN1jTN9LZ1rbZdE2NGO6IrBmPqYJYyENZCrtro9FOhfSOEO8y0Gds8nOiGYalJA28bM37AQQegRRhPkfzjh6erH7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729592651; c=relaxed/simple;
	bh=TqoIL7qkvE1efBDn2sg+AG4rMacutCBnuMUZJ11NbIA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tyvYh3buXibX75XhiZo/6Zh2NpLDTb27gEmf1hVgSr058DZUjqYdXaIAUs4iwdze0iyPY4G1Ko/wYC5roSu31L9fO7CMD4s/tRMg6m9giKmpqJ8Xsq/kc2+YIwNPXwoEs6ZK2qpn/iZICIh/aq4MJjdEvciFMXzXRSOyWgN3vxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=c90OqJmu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=f/y1xkgT; arc=none smtp.client-ip=103.168.172.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id F0F5711401F7;
	Tue, 22 Oct 2024 06:24:07 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 22 Oct 2024 06:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1729592647;
	 x=1729679047; bh=1u/BH5JUQH8GdhawWY5lWyZYs9/szdOia1VxtUwRudE=; b=
	c90OqJmu+7OrqTi1I7+Akfn4M9CJThhzYCJoErglKxUBuzY/BmX2L399SWPkbzsU
	qH/+QlHaumtVt4rdv/hPIlY6ayQ4YTwQ6qRHladoB+TYBmv/coGogxxy74y0tMQ1
	VspZAQCmcJ7jMwe45MeQEyYRqKlO2AZ6Yy2ngLQUcgokI+KASwNu4Kt2QJNh5DwJ
	ZB9ToD/uiPrgKg6DwYQ4sVHBq/OkeTaTsPv7zlmgZ0k6g0bXczTTpDOV5EvbW+tL
	svGjOCc0aa1Z6FhWje24OrdsOQGBPx8cnhUOIOP92ZO/jZcwBAyoCCKF+HeWMPuz
	+QBz5MQDlSK78Wz8HEOeQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1729592647; x=
	1729679047; bh=1u/BH5JUQH8GdhawWY5lWyZYs9/szdOia1VxtUwRudE=; b=f
	/y1xkgTtLxpBRm5ySUBJCByDWL8dysfFpApO5UAi8cMaGNUKQix0gz7NArKHfGFA
	jpdmBmxsRFIFW+x0EVewINE3la9IeBO7v5lahJM8QqlOkiFCsceWj2VyF8+K+Cmd
	XT+LydjeYylpGFZDg416NtC+BU0iCCmtzc0W79KLj/IupcYyIv3V1OlBp62w71pE
	BKdQ31ACdeJ5p3Wjs3sJBWM+u3McBhaYxp8TkUtbJXQI2Lwm5aiJCJbeZA+a0rT8
	2E5fddIHA7B9oeHnuAJqLuWDo12PYrSTR/LBCHdA2uAB9ASfP3RxpuuNAdPvKQlY
	lHw70XvOhfJwZeihmWDKg==
X-ME-Sender: <xms:Rn0XZ9lgF9X4t284XRdkZl09NQmkC3r3I7-S0y0bm6rP6oIcDpmZ6Q>
    <xme:Rn0XZ41O-XkdkIplDD_eKxLDeD1xVBhnuT3D0D9wFx2j_DZfm4rJx6tt1KjDvJ8sS
    jXlqK4pgIq8PCA1>
X-ME-Received: <xmr:Rn0XZzp4FZMiLQ4UVU6vX-WhoH_FYJbIkksgsvbVEcYf4GU_3KrsxOFe686rArF0tw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeihedgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgurdhstghhuhgsvg
    hrthesfhgrshhtmhgrihhlrdhfmheqnecuggftrfgrthhtvghrnhepfefhgeefueelffei
    hfdvgfetuedufeffgeeuieejteeukeffiefhheeiheeivdevnecuffhomhgrihhnpegrkh
    grrdhmshdpghhithhhuhgsrdgtohhmpdhqvghmuhdrohhrghenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghrth
    esfhgrshhtmhgrihhlrdhfmhdpnhgspghrtghpthhtohepuddtpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopegufiesuggrvhhiugifvghirdhukhdprhgtphhtthhopehmih
    hklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtoheprgigsghovgeskhgvrhhnvghl
    rdgukhdprhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomhdprh
    gtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtohepjhhorghnnhgvlhhkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohep
    rghmihhrjeefihhlsehgmhgrihhlrdgtohhmpdhrtghpthhtohepthhomhdrlhgvihhmih
    hnghesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:R30XZ9m4g1BTzdmkhkqa0MiTpYQHENVKoYShMPuaxJCyVlGsQLzHWA>
    <xmx:R30XZ71ueHIgbOknOZbs6nQZpm1F70DyH16udp4H9x8H8I-E0PcgOA>
    <xmx:R30XZ8uQ523aQbeED9OSTryweh94WH1Vdgg719cLrzxmQPfQP2y6EQ>
    <xmx:R30XZ_WZcM9hfDpOszN_sDFBdqRbYXKJ5AVZSokq72B3mgxwRFxJMw>
    <xmx:R30XZ0sqfJ9bqdXYYRXsIJPQOWlggZ-R-zSoUpq4X2q5wyFEjD-YmTQd>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Oct 2024 06:24:05 -0400 (EDT)
Message-ID: <baf09fb5-60a6-4aa9-9a6f-0d94ccce6ba4@fastmail.fm>
Date: Tue, 22 Oct 2024 12:24:04 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 00/15] fuse: fuse-over-io-uring
To: David Wei <dw@davidwei.uk>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, Josef Bacik <josef@toxicpanda.com>
References: <20241016-fuse-uring-for-6-10-rfc4-v4-0-9739c753666e@ddn.com>
 <38c76d27-1657-4f8c-9875-43839c8bbe80@davidwei.uk>
 <ed03c267-92c1-4431-85b2-d58fd45807be@fastmail.fm>
 <11032431-e58b-4f75-a8b5-cf978ffbfa50@davidwei.uk>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US
In-Reply-To: <11032431-e58b-4f75-a8b5-cf978ffbfa50@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/21/24 22:57, David Wei wrote:
> On 2024-10-21 04:47, Bernd Schubert wrote:
>> Hi David,
>>
>> On 10/21/24 06:06, David Wei wrote:
>>> [You don't often get email from dw@davidwei.uk. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>>>
>>> On 2024-10-15 17:05, Bernd Schubert wrote:
>>> [...]
>>>>
>>
>> ...
>>
>>> Hi Bernd, I applied this patchset to io_uring-6.12 branch with some
>>> minor conflicts. I'm running the following command:
>>>
>>> $ sudo ./build/example/passthrough_hp -o allow_other --debug-fuse --nopassthrough \
>>> --uring --uring-per-core-queue --uring-fg-depth=1 --uring-bg-depth=1 \
>>> /home/vmuser/scratch/source /home/vmuser/scratch/dest
>>> FUSE library version: 3.17.0
>>> Creating ring per-core-queue=1 sync-depth=1 async-depth=1 arglen=1052672
>>> dev unique: 2, opcode: INIT (26), nodeid: 0, insize: 104, pid: 0
>>> INIT: 7.40
>>> flags=0x73fffffb
>>> max_readahead=0x00020000
>>>      INIT: 7.40
>>>      flags=0x4041f429
>>>      max_readahead=0x00020000
>>>      max_write=0x00100000
>>>      max_background=0
>>>      congestion_threshold=0
>>>      time_gran=1
>>>      unique: 2, success, outsize: 80
>>>
>>> I created the source and dest folders which are both empty.
>>>
>>> I see the following in dmesg:
>>>
>>> [ 2453.197510] uring is disabled
>>> [ 2453.198525] uring is disabled
>>> [ 2453.198749] uring is disabled
>>> ...
>>>
>>> If I then try to list the directory /home/vmuser/scratch:
>>>
>>> $ ls -l /home/vmuser/scratch
>>> ls: cannot access 'dest': Software caused connection abort
>>>
>>> And passthrough_hp terminates.
>>>
>>> My kconfig:
>>>
>>> CONFIG_FUSE_FS=m
>>> CONFIG_FUSE_PASSTHROUGH=y
>>> CONFIG_FUSE_IO_URING=y
>>>
>>> I'll look into it next week but, do you see anything obviously wrong?
>>
>>
>> thanks for testing it! I just pushed a fix to my libfuse branches to
>> avoid the abort for -EOPNOTSUPP. It will gracefully fall back to
>> /dev/fuse IO now.
>>
>> Could you please use the rfcv4 branch, as the plain uring
>> branch will soon get incompatible updates for rfc5?
>>
>> https://github.com/bsbernd/libfuse/tree/uring-for-rfcv4
>>
>>
>> The short answer to let you enable fuse-io-uring:
>>
>> echo 1 >/sys/module/fuse/parameters/enable_uring
>>
>>
>> (With that the "uring is disabled" should be fixed.)
> 
> Thanks, using this branch fixed the issue and now I can see the dest
> folder mirroring that of the source folder. There are two issues I
> noticed:
> 
> [63490.068211] ---[ end trace 0000000000000000 ]---
> [64010.242963] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:330
> [64010.243531] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 11057, name: fuse-ring-1
> [64010.244092] preempt_count: 1, expected: 0
> [64010.244346] RCU nest depth: 0, expected: 0
> [64010.244599] 2 locks held by fuse-ring-1/11057:
> [64010.244886]  #0: ffff888105db20a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x900/0xd80
> [64010.245476]  #1: ffff88810f941818 (&fc->lock){+.+.}-{2:2}, at: fuse_uring_cmd+0x83e/0x1890 [fuse]
> [64010.246031] CPU: 1 UID: 0 PID: 11057 Comm: fuse-ring-1 Tainted: G        W          6.11.0-10089-g0d2090ccdbbe #2
> [64010.246655] Tainted: [W]=WARN
> [64010.246853] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> [64010.247542] Call Trace:
> [64010.247705]  <TASK>
> [64010.247860]  dump_stack_lvl+0xb0/0xd0
> [64010.248090]  __might_resched+0x2f8/0x510
> [64010.248338]  __kmalloc_cache_noprof+0x2aa/0x390
> [64010.248614]  ? lockdep_init_map_type+0x2cb/0x7b0
> [64010.248923]  ? fuse_uring_cmd+0xcc2/0x1890 [fuse]
> [64010.249215]  fuse_uring_cmd+0xcc2/0x1890 [fuse]
> [64010.249506]  io_uring_cmd+0x214/0x500
> [64010.249745]  io_issue_sqe+0x588/0x1810
> [64010.249999]  ? __pfx_io_issue_sqe+0x10/0x10
> [64010.250254]  ? io_alloc_async_data+0x88/0x120
> [64010.250516]  ? io_alloc_async_data+0x88/0x120
> [64010.250811]  ? io_uring_cmd_prep+0x2eb/0x9f0
> [64010.251103]  io_submit_sqes+0x796/0x1f80
> [64010.251387]  __do_sys_io_uring_enter+0x90a/0xd80
> [64010.251696]  ? do_user_addr_fault+0x26f/0xb60
> [64010.251991]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
> [64010.252333]  ? __up_read+0x3ba/0x750
> [64010.252565]  ? __pfx___up_read+0x10/0x10
> [64010.252868]  do_syscall_64+0x68/0x140
> [64010.253121]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [64010.253444] RIP: 0033:0x7f03a03fb7af
> [64010.253679] Code: 45 0f b6 90 d0 00 00 00 41 8b b8 cc 00 00 00 45 31 c0 41 b9 08 00 00 00 41 83 e2 01 41 c1 e2 04 41 09 c2 b8 aa 01 00 00 0f 05 <c3> a8 02 74 cc f0 48 83 0c 24 00 49 8b 40 20 8b 00 a8 01 74 bc b8
> [64010.254801] RSP: 002b:00007f039f3ffd08 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> [64010.255261] RAX: ffffffffffffffda RBX: 0000561ab7c1ced0 RCX: 00007f03a03fb7af
> [64010.255695] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000009
> [64010.256127] RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000008
> [64010.256556] R10: 0000000000000000 R11: 0000000000000246 R12: 0000561ab7c1d7a8
> [64010.256990] R13: 0000561ab7c1da00 R14: 0000561ab7c1d520 R15: 0000000000000001
> [64010.257442]  </TASK>

Regarding issue one, does this patch solve it?

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index e518d4379aa1..304919bc12fb 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -168,6 +168,12 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
         queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
         if (!queue)
                 return ERR_PTR(-ENOMEM);
+       pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
+       if (!pq) {
+               kfree(queue);
+               return ERR_PTR(-ENOMEM);
+       }
+
         spin_lock(&fc->lock);
         if (ring->queues[qid]) {
                 spin_unlock(&fc->lock);
@@ -186,11 +192,6 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
         INIT_LIST_HEAD(&queue->ent_in_userspace);
         INIT_LIST_HEAD(&queue->fuse_req_queue);

-       pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
-       if (!pq) {
-               kfree(queue);
-               return ERR_PTR(-ENOMEM);
-       }
         queue->fpq.processing = pq;
         fuse_pqueue_init(&queue->fpq);


I think we don't need GFP_ATOMIC, but can do allocations before taking
the lock. This pq allocation is new in v4 and I forgot to put it into
the right place and it slipped through my very basic testing (I'm
concentrating on the design changes for now - testing will come back
with v6).

> 
> If I am already in dest when I do the mount using passthrough_hp and
> then e.g. ls, it hangs indefinitely even if I kill passthrough_hp.

I'm going to check in a bit. I hope it is not a recursion issue.


Thanks,
Bernd

