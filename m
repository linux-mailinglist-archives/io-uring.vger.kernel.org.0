Return-Path: <io-uring+bounces-503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B59D842F9E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 23:24:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F5521C24491
	for <lists+io-uring@lfdr.de>; Tue, 30 Jan 2024 22:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DBE7BAE9;
	Tue, 30 Jan 2024 22:24:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5840E7BAE6;
	Tue, 30 Jan 2024 22:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706653452; cv=none; b=nBoFlWDLJgtJvz3mD7YT+RLRjwoAg3gz2Pie5sjh1kCtK21Tt9mh5xeSfuxquK01bGPU/fwdlGzWHso1yI8m3wL4PY7wPC0t9ZXN0rpk4AcSfs2+KY2QYjWqQ/A52FRkP422dnsa4lUMr42bwryJ2490jtyYHDbR5lIkySguLRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706653452; c=relaxed/simple;
	bh=LiN2MbNXo5CJEfTAswYrgrLT7ODnfiJUclQptKx+DYA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g0aIDvyDyNkLkBIOOztYahEeESUBoRK7VPj0FLAVoigQuBIwu7sf8Kic9Q26gRAZPSzietLbNws+mF2FUXi4IeAuJ0DT3iddWuakE2ywbO6s67w495xQzsYQbYhGXcZ81TFNjOTyVyNtLTjJ5htMLSA/ZTd1sUXDsKR+hOCppn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=58108 helo=[192.168.1.177])
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1rUvWv-0000W8-0I;
	Tue, 30 Jan 2024 16:20:29 -0500
Message-ID: <58bde897e724efd7771229734d8ad2fb58b3ca48.camel@trillion01.com>
Subject: Re: [PATCH v15 0/7] io_uring: add napi busy polling support
From: Olivier Langlois <olivier@trillion01.com>
To: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org, 
	kernel-team@fb.com
Cc: axboe@kernel.dk, ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, 
	kuba@kernel.org
Date: Tue, 30 Jan 2024 16:20:28 -0500
In-Reply-To: <20230608163839.2891748-1-shr@devkernel.io>
References: <20230608163839.2891748-1-shr@devkernel.io>
Autocrypt: addr=olivier@trillion01.com; prefer-encrypt=mutual;
 keydata=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
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Hi,

I was wondering what did happen to this patch submission...

It seems like Stefan did put a lot of effort in addressing every
reported issue for several weeks/months...

and then nothing... as if this patch has never been reviewed by
anyone...

has it been decided to not integrate NAPI busy looping in io_uring
privately finally?

On Thu, 2023-06-08 at 09:38 -0700, Stefan Roesch wrote:
> This adds the napi busy polling support in io_uring.c. It adds a new
> napi_list to the io_ring_ctx structure. This list contains the list
> of
> napi_id's that are currently enabled for busy polling. This list is
> used to determine which napi id's enabled busy polling. For faster
> access it also adds a hash table.
>=20
> When a new napi id is added, the hash table is used to locate if
> the napi id has already been added. When processing the busy poll
> loop the list is used to process the individual elements.
>=20
> io-uring allows specifying two parameters:
> - busy poll timeout and
> - prefer busy poll to call of io_napi_busy_loop()
> This sets the above parameters for the ring. The settings are passed
> with a new structure io_uring_napi.
>=20
> There is also a corresponding liburing patch series, which enables
> this
> feature. The name of the series is "liburing: add add api for napi
> busy
> poll timeout". It also contains two programs to test the this.
>=20
> Testing has shown that the round-trip times are reduced to 38us from
> 55us by enabling napi busy polling with a busy poll timeout of 100us.
> More detailled results are part of the commit message of the first
> patch.
>=20
> Changes:
> - V15:
> =A0 - Combined _napi_busy_loop() and __napi_busy_loop() function
> =A0 - Rephrased comment
> - V14:
> =A0 - Rephrased comment for napi_busy_loop_rcu() funnction
> =A0 - Added new function _napi_busy_loop() to remove code
> =A0=A0=A0 duplication in napi_busy_loop() and napi_busy_loop_rcu()
> - V13:
> =A0 - split off __napi_busy_loop() from napi_busy_loop()
> =A0 - introduce napi_busy_loop_no_lock()
> =A0 - use napi_busy_loop_no_lock in io_napi_blocking_busy_loop
> - V12:
> =A0 - introduce io_napi_hash_find()
> =A0 - use rcu for changes to the hash table
> =A0 - use rcu for searching if a napi id is in the napi hash table
> =A0 - use rcu hlist functions for adding and removing items from the
> hash
> =A0=A0=A0 table
> =A0 - add stale entry detection in __io_napi_do_busy_loop and remove
> stale
> =A0=A0=A0 entries in io_napi_blocking_busy_loop() and
> io_napi_sqpoll_busy_loop()
> =A0 - create io_napi_remove_stale() and __io_napi_remove_stale()
> =A0 - __io_napi_do_busy_loop() takes additional loop_end_arg and does
> stale
> =A0=A0=A0 entry detection
> =A0 - io_napi_multi_busy_loop is removed. Logic is moved to
> =A0=A0=A0 io_napi_blocking_busy_loop()
> =A0 - io_napi_free uses rcu function to free
> =A0 - io_napi_busy_loop no longer splices
> =A0 - io_napi_sqpoll_busy_poll uses rcu
> - V11:
> =A0 - Fixed long comment lines and whitespace issues
> =A0 - Refactor new code io_cqring_wait()
> =A0 - Refactor io_napi_adjust_timeout() and remove adjust_timeout
> =A0 - Rename io_napi_adjust_timeout to __io_napi_adjust_timeout
> =A0 - Add new function io_napi_adjust_timeout
> =A0 - Cleanup calls to list_is_singular() in io_napi_multi_busy_loop()
> =A0=A0=A0 and io_napi_blocking_busy_loop()
> =A0 - Cleanup io_napi_busy_loop_should_end()
> =A0 - Rename __io_napi_busy_loop to __io_napi_do_busy_loop()=20
> - V10:
> =A0 - Refreshed to io-uring/for-6.4
> =A0 - Repeated performance measurements for 6.4 (same/similar results)
> - V9:
> =A0 - refreshed to io-uring/for-6.3
> =A0 - folded patch 2 and 3 into patch 4
> =A0 - fixed commit description for last 2 patches
> =A0 - fixed some whitespace issues
> =A0 - removed io_napi_busy_loop_on helper
> =A0 - removed io_napi_setup_busy helper
> =A0 - renamed io_napi_end_busy_loop to io_napi_busy_loop
> =A0 - removed NAPI_LIST_HEAD macro
> =A0 - split io_napi_blocking_busy_loop into two functions
> =A0 - added io_napi function
> =A0 - comment for sqpoll check
> - V8:
> =A0 - added new file napi.c and add napi functions to this file
> =A0 - added NAPI_LIST_HEAD function so no ifdef is necessary
> =A0 - added io_napi_init and io_napi_free function
> =A0 - added io_napi_setup_busy loop helper function
> =A0 - added io_napi_adjust_busy_loop helper function
> =A0 - added io_napi_end_busy_loop helper function
> =A0 - added io_napi_sqpoll_busy_poll helper function
> =A0 - some of the definitions in napi.h are macros to avoid ifdef
> =A0=A0=A0 definitions in io_uring.c, poll.c and sqpoll.c
> =A0 - changed signature of io_napi_add function
> =A0 - changed size of hashtable to 16. The number of entries is limited
> =A0=A0=A0 by the number of nic queues.
> =A0 - Removed ternary in io_napi_blocking_busy_loop
> =A0 - Rewrote io_napi_blocking_busy_loop to make it more readable
> =A0 - Split off 3 more patches
> - V7:
> =A0 - allow unregister with NULL value for arg parameter
> =A0 - return -EOPNOTSUPP if CONFIG_NET_RX_BUSY_POLL is not enabled
> - V6:
> =A0 - Add a hash table on top of the list for faster access during the
> =A0=A0=A0 add operation. The linked list and the hash table use the same
> =A0=A0=A0 data structure
> - V5:
> =A0 - Refreshed to 6.1-rc6
> =A0 - Use copy_from_user instead of memdup/kfree
> =A0 - Removed the moving of napi_busy_poll_to
> =A0 - Return -EINVAL if any of the reserved or padded fields are not 0.
> - V4:
> =A0 - Pass structure for napi config, instead of individual parameters
> - V3:
> =A0 - Refreshed to 6.1-rc5
> =A0 - Added a new io-uring api for the prefer napi busy poll api and
> wire
> =A0=A0=A0 it to io_napi_busy_loop().
> =A0 - Removed the unregister (implemented as register)
> =A0 - Added more performance results to the first commit message.
> - V2:
> =A0 - Add missing defines if CONFIG_NET_RX_BUSY_POLL is not defined
> =A0 - Changes signature of function io_napi_add_list to static inline
> =A0=A0=A0 if CONFIG_NET_RX_BUSY_POLL is not defined
> =A0 - define some functions as static
>=20
>=20
> Stefan Roesch (7):
> =A0 net: split off __napi_busy_poll from napi_busy_poll
> =A0 net: add napi_busy_loop_rcu()
> =A0 io-uring: move io_wait_queue definition to header file
> =A0 io-uring: add napi busy poll support
> =A0 io-uring: add sqpoll support for napi busy poll
> =A0 io_uring: add register/unregister napi function
> =A0 io_uring: add prefer busy poll to register and unregister napi api
>=20
> =A0include/linux/io_uring_types.h |=A0 11 ++
> =A0include/net/busy_poll.h=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 4 +
> =A0include/uapi/linux/io_uring.h=A0 |=A0 12 ++
> =A0io_uring/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 1 +
> =A0io_uring/io_uring.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 41 ++--
> =A0io_uring/io_uring.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 26 +++
> =A0io_uring/napi.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 331
> +++++++++++++++++++++++++++++++++
> =A0io_uring/napi.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 104 +++=
++++++++
> =A0io_uring/poll.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 2=
 +
> =A0io_uring/sqpoll.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 4 +
> =A0net/core/dev.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 34=
 +++-
> =A011 files changed, 544 insertions(+), 26 deletions(-)
> =A0create mode 100644 io_uring/napi.c
> =A0create mode 100644 io_uring/napi.h
>=20
>=20
> base-commit: f026be0e1e881e3395c3d5418ffc8c2a2203c3f3


