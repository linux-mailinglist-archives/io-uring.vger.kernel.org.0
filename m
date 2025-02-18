Return-Path: <io-uring+bounces-6496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9ECA39091
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 02:47:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33A3F16C0B8
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 01:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1BA87DA82;
	Tue, 18 Feb 2025 01:47:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8A03A1B6;
	Tue, 18 Feb 2025 01:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739843242; cv=none; b=gPCabOoZxxgNiWAcXgjL+QdzTJoR2WwlmO1yCy5Zjb9BVTulBLZ/zGJ+W2aKRWKLnlUw7hgx5cqZe4Mh1+oIwDJLvNPi9XbnYw/DcYW9L9xEju03Dd8cpWjmm5XU3+gSCQWwB4aznW6KqPKFBomE8KeMngUmiT6De8HeYxC6tJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739843242; c=relaxed/simple;
	bh=a4vCrPgAH/CQc0B0F3CNtgmIzbEM7spI8PQVPfELnlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jIUsp0vwEwdJ8snUzcYRI8SYwIk8hm2bR0odB2xYvU4DFUoTnyZ9dg6wNezwm7oEEoRLrM4hEWmt22hGICOTDgWxiM0Xbu7qm0S4+WtYO0xsKC3xWQuiKuQa9AyWAvueKw1i5ADtaJ0kz09ztfyc/XLsaLn1jhXNZNR6/sNN4Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Yxj5y5lswzcq51;
	Tue, 18 Feb 2025 09:45:42 +0800 (CST)
Received: from kwepemg200008.china.huawei.com (unknown [7.202.181.35])
	by mail.maildlp.com (Postfix) with ESMTPS id 78BAB140136;
	Tue, 18 Feb 2025 09:47:16 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemg200008.china.huawei.com (7.202.181.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Feb 2025 09:47:15 +0800
Message-ID: <30ac5cb5-ee1f-66fc-641f-5f42140f0045@huawei.com>
Date: Tue, 18 Feb 2025 09:47:15 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH net-next v5 00/27] io_uring zerocopy send
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, <io-uring@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski
	<kuba@kernel.org>, Jonathan Lemon <jonathan.lemon@gmail.com>, Willem de
 Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, David Ahern
	<dsahern@kernel.org>, <kernel-team@fb.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg200008.china.huawei.com (7.202.181.35)



On 2022/7/13 4:52, Pavel Begunkov wrote:
> NOTE: Not to be picked directly. After getting necessary acks, I'll be
>       working out merging with Jakub and Jens.
> 
> The patchset implements io_uring zerocopy send. It works with both registered
> and normal buffers, mixing is allowed but not recommended. Apart from usual
> request completions, just as with MSG_ZEROCOPY, io_uring separately notifies
> the userspace when buffers are freed and can be reused (see API design below),
> which is delivered into io_uring's Completion Queue. Those "buffer-free"
> notifications are not necessarily per request, but the userspace has control
> over it and should explicitly attaching a number of requests to a single
> notification. The series also adds some internal optimisations when used with
> registered buffers like removing page referencing.
> 
>>From the kernel networking perspective there are two main changes. The first
> one is passing ubuf_info into the network layer from io_uring (inside of an
> in kernel struct msghdr). This allows extra optimisations, e.g. ubuf_info
> caching on the io_uring side, but also helps to avoid cross-referencing
> and synchronisation problems. The second part is an optional optimisation
> removing page referencing for requests with registered buffers.
> 
> Benchmarking UDP with an optimised version of the selftest (see [1]), which

Hi, Pavel, I'm interested in zero copy sending of io_uring, but I can't
reproduce its performance using zerocopy send selftest test case, such
as "bash io_uring_zerocopy_tx.sh 6 udp -m 0/1/2/3 -n 64", even baseline
performance may be the best.

               MB/s
NONZC         8379
ZC            5910
ZC_FIXED      6294
MIXED         6350

And the zero-copy example in [1] does not seem to work because the
kernel is modified by following commit:

https://lore.kernel.org/all/cover.1662027856.git.asml.silence@gmail.com/

Can you help me reproduce this performance test result? Is it necessary
to configure better parameters to reproduce the problem?


> sends a bunch of requests, waits for completions and repeats. "+ flush" column
> posts one additional "buffer-free" notification per request, and just "zc"
> doesn't post buffer notifications at all.
> 
> NIC (requests / second):
> IO size | non-zc    | zc             | zc + flush
> 4000    | 495134    | 606420 (+22%)  | 558971 (+12%)
> 1500    | 551808    | 577116 (+4.5%) | 565803 (+2.5%)
> 1000    | 584677    | 592088 (+1.2%) | 560885 (-4%)
> 600     | 596292    | 598550 (+0.4%) | 555366 (-6.7%)
> 
> dummy (requests / second):
> IO size | non-zc    | zc             | zc + flush
> 8000    | 1299916   | 2396600 (+84%) | 2224219 (+71%)
> 4000    | 1869230   | 2344146 (+25%) | 2170069 (+16%)
> 1200    | 2071617   | 2361960 (+14%) | 2203052 (+6%)
> 600     | 2106794   | 2381527 (+13%) | 2195295 (+4%)
> 
> Previously it also brought a massive performance speedup compared to the
> msg_zerocopy tool (see [3]), which is probably not super interesting. There
> is also an additional bunch of refcounting optimisations that was omitted from
> the series for simplicity and as they don't change the picture drastically,
> they will be sent as follow up, as well as flushing optimisations closing the
> performance gap b/w two last columns.
> 
> For TCP on localhost (with hacks enabling localhost zerocopy) and including
> additional overhead for receive:
> 
> IO size | non-zc    | zc
> 1200    | 4174      | 4148
> 4096    | 7597      | 11228
> 
> Using a real NIC 1200 bytes, zc is worse than non-zc ~5-10%, maybe the
> omitted optimisations will somewhat help, should look better for 4000,
> but couldn't test properly because of setup problems.
> 
> Links:
> 
>   liburing (benchmark + tests):
>   [1] https://github.com/isilence/liburing/tree/zc_v4
> 
>   kernel repo:
>   [2] https://github.com/isilence/linux/tree/zc_v4
> 
>   RFC v1:
>   [3] https://lore.kernel.org/io-uring/cover.1638282789.git.asml.silence@gmail.com/
> 
>   RFC v2:
>   https://lore.kernel.org/io-uring/cover.1640029579.git.asml.silence@gmail.com/
> 
>   Net patches based:
>   git@github.com:isilence/linux.git zc_v4-net-base
>   or
>   https://github.com/isilence/linux/tree/zc_v4-net-base
> 
> API design overview:
> 
>   The series introduces an io_uring concept of notifactors. From the userspace
>   perspective it's an entity to which it can bind one or more requests and then
>   requesting to flush it. Flushing a notifier makes it impossible to attach new
>   requests to it, and instructs the notifier to post a completion once all
>   requests attached to it are completed and the kernel doesn't need the buffers
>   anymore.
> 
>   Notifications are stored in notification slots, which should be registered as
>   an array in io_uring. Each slot stores only one notifier at any particular
>   moment. Flushing removes it from the slot and the slot automatically replaces
>   it with a new notifier. All operations with notifiers are done by specifying
>   an index of a slot it's currently in.
> 
>   When registering a notification the userspace specifies a u64 tag for each
>   slot, which will be copied in notification completion entries as
>   cqe::user_data. cqe::res is 0 and cqe::flags is equal to wrap around u32
>   sequence number counting notifiers of a slot.
> 
> Changelog:
> 
>   v4 -> v5
>     remove ubuf_info checks from custom iov_iter callbacks to
>     avoid disabling the page refs optimisations for TCP
> 
>   v3 -> v4
>     custom iov_iter handling
> 
>   RFC v2 -> v3:
>     mem accounting for non-registered buffers
>     allow mixing registered and normal requests per notifier
>     notification flushing via IORING_OP_RSRC_UPDATE
>     TCP support
>     fix buffer indexing
>     fix io-wq ->uring_lock locking
>     fix bugs when mixing with MSG_ZEROCOPY
>     fix managed refs bugs in skbuff.c
> 
>   RFC -> RFC v2:
>     remove additional overhead for non-zc from skb_release_data()
>     avoid msg propagation, hide extra bits of non-zc overhead
>     task_work based "buffer free" notifications
>     improve io_uring's notification refcounting
>     added 5/19, (no pfmemalloc tracking)
>     added 8/19 and 9/19 preventing small copies with zc
>     misc small changes
> 
> David Ahern (1):
>   net: Allow custom iter handler in msghdr
> 
> Pavel Begunkov (26):
>   ipv4: avoid partial copy for zc
>   ipv6: avoid partial copy for zc
>   skbuff: don't mix ubuf_info from different sources
>   skbuff: add SKBFL_DONT_ORPHAN flag
>   skbuff: carry external ubuf_info in msghdr
>   net: introduce managed frags infrastructure
>   net: introduce __skb_fill_page_desc_noacc
>   ipv4/udp: support externally provided ubufs
>   ipv6/udp: support externally provided ubufs
>   tcp: support externally provided ubufs
>   io_uring: initialise msghdr::msg_ubuf
>   io_uring: export io_put_task()
>   io_uring: add zc notification infrastructure
>   io_uring: cache struct io_notif
>   io_uring: complete notifiers in tw
>   io_uring: add rsrc referencing for notifiers
>   io_uring: add notification slot registration
>   io_uring: wire send zc request type
>   io_uring: account locked pages for non-fixed zc
>   io_uring: allow to pass addr into sendzc
>   io_uring: sendzc with fixed buffers
>   io_uring: flush notifiers after sendzc
>   io_uring: rename IORING_OP_FILES_UPDATE
>   io_uring: add zc notification flush requests
>   io_uring: enable managed frags with register buffers
>   selftests/io_uring: test zerocopy send
> 
>  include/linux/io_uring_types.h                |  37 ++
>  include/linux/skbuff.h                        |  66 +-
>  include/linux/socket.h                        |   5 +
>  include/uapi/linux/io_uring.h                 |  45 +-
>  io_uring/Makefile                             |   2 +-
>  io_uring/io_uring.c                           |  42 +-
>  io_uring/io_uring.h                           |  22 +
>  io_uring/net.c                                | 187 ++++++
>  io_uring/net.h                                |   4 +
>  io_uring/notif.c                              | 215 +++++++
>  io_uring/notif.h                              |  87 +++
>  io_uring/opdef.c                              |  24 +-
>  io_uring/rsrc.c                               |  55 +-
>  io_uring/rsrc.h                               |  16 +-
>  io_uring/tctx.h                               |  26 -
>  net/compat.c                                  |   1 +
>  net/core/datagram.c                           |  14 +-
>  net/core/skbuff.c                             |  37 +-
>  net/ipv4/ip_output.c                          |  50 +-
>  net/ipv4/tcp.c                                |  32 +-
>  net/ipv6/ip6_output.c                         |  49 +-
>  net/socket.c                                  |   3 +
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../selftests/net/io_uring_zerocopy_tx.c      | 605 ++++++++++++++++++
>  .../selftests/net/io_uring_zerocopy_tx.sh     | 131 ++++
>  25 files changed, 1628 insertions(+), 128 deletions(-)
>  create mode 100644 io_uring/notif.c
>  create mode 100644 io_uring/notif.h
>  create mode 100644 tools/testing/selftests/net/io_uring_zerocopy_tx.c
>  create mode 100755 tools/testing/selftests/net/io_uring_zerocopy_tx.sh
> 

