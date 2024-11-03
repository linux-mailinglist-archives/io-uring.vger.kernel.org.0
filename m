Return-Path: <io-uring+bounces-4382-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5589BA9A1
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 00:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D304E1F215D7
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8FC165EE3;
	Sun,  3 Nov 2024 23:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=johnandrewmarshall.com header.i=@johnandrewmarshall.com header.b="EVy/v+Jn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="W8GiqfT6"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BFC15B13C
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 23:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730677758; cv=none; b=azpihH1Kax5mDX+qp0ZFzqOEz3pqjP/OWkkTGEQ3wvUcHxYS7a7p4dYXI1uWCTXwPkc53LEiMY43IvGMEm7AFiqXdM70vuzFTOQDuq454TeH6AWL3D8U2fjqyiIXx5VYmP8ji/GfFpt4GXSLdmB5QRnfF/k5iRQQl8CpI7psPs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730677758; c=relaxed/simple;
	bh=UanSEzz7gG4PzWtRz5sO03UGvPzOQYryAGY2flojEAo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:Subject:Content-Type; b=lywQHLnpGGI6ztA1uAW+bqtDO1gwQn687JHU0c8oE7LMtwRkgZ2PZAHyZWlIYhuyfjNQ23uUkEcXwu64RPs/5IN4YTCdVK35TOaS47LAy7SPqlGxejRI3vckxwOM7jNAmAfGvqljCSzj6VGriATp8S6ZvXU6KN9UH+H3iji0y0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=johnandrewmarshall.com; spf=pass smtp.mailfrom=johnandrewmarshall.com; dkim=pass (2048-bit key) header.d=johnandrewmarshall.com header.i=@johnandrewmarshall.com header.b=EVy/v+Jn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=W8GiqfT6; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=johnandrewmarshall.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=johnandrewmarshall.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 81D4711400F3;
	Sun,  3 Nov 2024 18:49:13 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Sun, 03 Nov 2024 18:49:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	johnandrewmarshall.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm2;
	 t=1730677753; x=1730764153; bh=eITs7QWqnB7JyZx7+CxryNrqZA+PDjZQ
	+9TLQJ0jAVU=; b=EVy/v+JnN8A9D/oNw44FrC0mid0e18ryq8mrMfwuVUg0Y+I8
	rr5vslRNRJLm0A/Rz/AdxTMPjiWUho1ynJhWwcfzySh4ZTSpAQfp2xeQzv9/sY6b
	v6EODMvi9H0ywcS+fr++pX5cXFzuDvb7S0isirABVa9+sY7CNATLGH05CfAu7DID
	aSZk1Oce83IjRbxENFjKlcbyQe+epXSvV24y3uY0tVnWrt4oa/Lv2ZeiLI5TFaEH
	wJsx9L7swT9zKD4mjNKp5qeGCHoysqDqveQWgleJO5EuZ1OCpWVwizDMBK2JUX+i
	SWvT2xLS73MIHsEsXiM5ENhc61ACK5NRc9/duQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1730677753; x=1730764153; bh=eITs7QWqnB7JyZx7+CxryNrqZA+P
	DjZQ+9TLQJ0jAVU=; b=W8GiqfT6vsmJH9cabzisXjE1JJSxshDeqBLqVpOpavBw
	/OGTnZZVUFj/VBkK/J7atXhNp0gbuiSjloPugyDFKWt70dBjek4S8UCJSqS/yxL6
	30wEMLs6MIbAGj18D/4awuzGOu0r780vYongzOaEulMBtyD/iBNdMBXdgbw5LaBp
	WiFX9YpGnul5KndOLyNEKut3sxcaJTTM1z93HwbpW9OIUFvpvcKwmI3Jx+tYV+Yw
	c3DQQQAzkC3aPIdBeO1+sKBQL6xi4bl5Q239e3pQ3POrE3KlHmM1ZVoyXGIWobIF
	02Ozn3tQ/2aV5PJ5RtarGnijwaaZVzJOKNz2B0i85g==
X-ME-Sender: <xms:-QsoZwG5msFX11cAx69tGAj_d411Z4sM3Bc_vNB7FE7tRr5fPqoy5w>
    <xme:-QsoZ5XH-SPlgu_DA6IF_sQjOXK9MVAtzEs1vysFZO5nmhV0PT9CezGvllFfSRLU9
    e64GEQvpnQmQNoWxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdelhedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkffutgfgsehtqhertdertdejnecu
    hfhrohhmpedftehnughrvgifucforghrshhhrghllhdfuceorghnughrvgifsehjohhhnh
    grnhgurhgvfihmrghrshhhrghllhdrtghomheqnecuggftrfgrthhtvghrnhepteelledu
    tedtteegvdeuteeghedtvefgtdevffffjeehgeekudffteegteehffejnecuffhomhgrih
    hnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrnhgurhgvfiesjhhohhhnrghnughrvgifmhgrrhhshhgrlhhlrd
    gtohhmpdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtohepihhoqdhurhhinhhgsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:-QsoZ6IwZuVvx86lE1HN7RIxFMzmkSPZ4Epc7Se-i4aJ_JAdcFcAog>
    <xmx:-QsoZyGtbxJUw5N4ziGG--gH0jFFhh5AlVS88vimATpUpMTtbMBHrA>
    <xmx:-QsoZ2UhyKNn_bDxaSUDlrVDdpPlyu84Vw-k409jXh_HlCqU9F9nUA>
    <xmx:-QsoZ1OSOWpgPHkxxQwQyUOpMU8IxfLZnNrIP_9gH2b06EMDKxqMLA>
    <xmx:-QsoZ5fbCF2ZFsbv2F_bOsTDahBv00bzJX-qHQnKetpoChDRYt5iiTqe>
Feedback-ID: i5df14252:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 328B5B00068; Sun,  3 Nov 2024 18:49:13 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 03 Nov 2024 18:47:30 -0500
From: "Andrew Marshall" <andrew@johnandrewmarshall.com>
To: "Jens Axboe" <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Message-Id: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
Subject: PROBLEM: io_uring hang causing uninterruptible sleep state on 6.6.59
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I, and others (see downstream report below), are encountering io_uring a=
t times hanging on 6.6.59 LTS. If the process is killed, the process rem=
ains stuck in sleep uninterruptible ("D"). This failure can be fairly re=
liably reproduced via Node.js with `npm ci` in at least some projects; d=
isabling that tool=E2=80=99s use of io_uring causes via its configuratio=
n causes it to succeed. I have identified what seems to be the problemat=
ic commit on linux-6.6.y (f4ce3b5).

Summary of Kernel version triaging:

- 6.6.56: succeeds
- 6.6.57: fails
- 6.6.58: fails
- 6.6.59: fails
- 6.6.59 (with f4ce3b5 reverted): succeeds
- 6.11.6: succeeds

System logs upon failure indicate hung task:

kernel: INFO: task npm ci:47920 blocked for more than 245 seconds.
kernel:       Tainted: P           O       6.6.58 #1-NixOS
kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this=
 message.
kernel: task:npm ci          state:D stack:0     pid:47920 ppid:47710  f=
lags:0x00004006
kernel: Call Trace:
kernel:  <TASK>
kernel:  __schedule+0x3fc/0x1430
kernel:  ? sysvec_apic_timer_interrupt+0xe/0x90
kernel:  schedule+0x5e/0xe0
kernel:  schedule_preempt_disabled+0x15/0x30
kernel:  __mutex_lock.constprop.0+0x3a2/0x6b0
kernel:  io_uring_del_tctx_node+0x61/0xf0
kernel:  io_uring_clean_tctx+0x5c/0xc0
kernel:  io_uring_cancel_generic+0x198/0x350
kernel:  ? srso_return_thunk+0x5/0x5f
kernel:  ? timerqueue_del+0x2e/0x50
kernel:  ? __pfx_autoremove_wake_function+0x10/0x10
kernel:  do_exit+0x167/0xad0
kernel:  ? __pfx_hrtimer_wakeup+0x10/0x10
kernel:  do_group_exit+0x31/0x80
kernel:  get_signal+0xa60/0xa60
kernel:  arch_do_signal_or_restart+0x3e/0x280
kernel:  exit_to_user_mode_prepare+0x1d4/0x230
kernel:  syscall_exit_to_user_mode+0x1b/0x50
kernel:  do_syscall_64+0x45/0x90
kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2

For more details, see the downstream bug report in Node.js: https://gith=
ub.com/nodejs/node/issues/55587

I identified f4ce3b5d26ce149e77e6b8e8f2058aa80e5b034e as the likely prob=
lematic commit simply by browsing git log. As indicated above; reverting=
 that atop 6.6.59 results in success. Since it is passing on 6.11.6, I s=
uspect there is some missing backport to 6.6.x, or some other semantic m=
erge conflict. Unfortunately I do not have a compact, minimal reproducer=
, but can provide my large one (it is testing a larger build process in =
a VM) if needed=E2=80=94there are some additional details in the above-l=
inked downstream bug report, though. I hope that having identified the p=
roblematic commit is enough for someone with more context to go off of. =
Happy to provide more information if needed.


Thanks,
Andrew

