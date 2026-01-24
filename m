Return-Path: <io-uring+bounces-11917-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gKzOJycTdWkAAgEAu9opvQ
	(envelope-from <io-uring+bounces-11917-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 19:44:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CBC57E869
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 19:44:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4F9753005318
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 18:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0993F26D4C7;
	Sat, 24 Jan 2026 18:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H8ueaISz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com [209.85.210.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAB0201113
	for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 18:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769280288; cv=none; b=gTYfvGqx7lTRwhq30IgSfkifIUHrN+vZoK6mkPlT1Ve7s5sZlMXTl+cvxon2Ewk0rDTBou9za8MMgpka4OMhSm+xhIisuswfsrVUvNvRzQgNTz5C3TJ5I1krNpfN2N5HOOx8YzfP1sPn5NXuNRf5q91TFFL5TBC7NMh8W6EmPv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769280288; c=relaxed/simple;
	bh=XRV0wY84DNHqwS2Fkfs3eMrYuRg8X2+yY55pWgMsCPA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=mnjpnBIubImrvBNA02amN4I8As08nnhnjzGzvh1QlKdpS2OQtlIAYLptJu4MdvkxSM+qX2VYwZJiSRe0ylzp99X2ocUsOrvFFpCy9LEG7zSD/9ueM8L3vCy3U9GZamIs/UAq/wLFPeJvSsU2DxoaRXAZsHSy9KItdWYUBF5kGSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H8ueaISz; arc=none smtp.client-ip=209.85.210.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f66.google.com with SMTP id 46e09a7af769-7cfd5d34817so2332618a34.1
        for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 10:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769280284; x=1769885084; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BkdCHL5Nc4dTASivmLsJvf6EygNmgUuEovaUHWLP+dk=;
        b=H8ueaISz0pnpWSpwNRyBGscmoondWW9eOrrENk2IdQpwOd1+sA6Vnic6BiYR5BZ3wp
         MrYrGieezBQlyZa7dthTFr4JpQ4l21cbhWC+dUOgQ8PZ74vDLluKF4mMW8rs8XSoUpXv
         M0qXO8IPk/uKQI7/ayqZAtiVCkbptQpnAcxZbhFXKBFFkAz93qluEJ6BFr+IU1htCx3O
         q3Y7nvxBdVQkDqBJVfiTqbF2KbViGtx+0zp8d+7o5Yj3gEdLRuPazmVxgKvEGHT1D+NT
         TUWfKCsUENAS0SQg5/+Dc9qW/DRJD3YGQHdsbDexIoX7rYcS2J2VpEjpRKyU2KCXuYDy
         9x7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769280284; x=1769885084;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BkdCHL5Nc4dTASivmLsJvf6EygNmgUuEovaUHWLP+dk=;
        b=B8rackJOzNQjSMwAEBAv0adQssfnaosH1aApTjyHWtX3hp0GI9pvDDReBBk8ytn4OA
         wl9dYbRlLdlAiNzYJIk6abTBKkiAfdLflU/wbFzUEfJonMkEPm/Yh6tPFq1QcGGOnnCb
         uyNkoNw3uMDyARTdNvvP5tSBJ/fyNGZsX2rorEd0YsN9ajPLlz27kCRdN1AWLGeQsprY
         dr2Aj97wt+LG78CKxU36Ik+Y27f89MNx0LHXENmN/uAMEJnLePWGNs0LjO2aEZrsgWgb
         AgoXTPtT6JIQ8IBm7MihLPpk8NuvRGfK80D1qXLnFCrO98AuvxJcMV33DP6VXU7VXkWL
         yejQ==
X-Gm-Message-State: AOJu0Yyfc7225Zv8v9I03bQt1bTX0eTcxHTlPO9vF0br8YKbpddhrAr4
	gG2m6AhPNC3NagodaWl5rC2oiTSKKHIaKIlle5zDerPE0/bblgoQRN03pEnK0sVp8A0=
X-Gm-Gg: AZuq6aITrJ3v89kqb6f2bk45dNs4BWUbXMJnXE4f2bZBJ5LpxQrbwESqb+ifdVzkocp
	ezGLtl7oHqTgNVCmg1an5X4O7MQ1x6UrUTvTpxCQnycDLvwFZg0AdxD7w3CyxAffF34VEu59CEF
	hrgimfTR0Xy/QZhtfyd8tCmWFrsS2OBVWsKIYt9TNJXDFoXVDU+4/eQ348Avxi9sMSGwcyS8Dra
	KsgTid9/kUQokE5vZYQkICet19aOgJdRHePpWYT8SoK8HY+9qJ/Hqp+oY3IAyvDyBZ8UFwdAzZa
	vQOjWuglzmYlKCmKlQy6DAACP2onQbLfnBOHGQft6UoDRe6ymRCW3Dfd6RELNnLsLq6tCXtf4V1
	Ts5AagRG3Fc2qW8GDhB+oAABvjP5//IuN4IQK5evwID/yJekyAZ1cV14L3YbMudarVeF23bap9/
	1TO2umU6C6RfJb51CO1x8m712DcyUu/b39vHh1zwJlyvXkAnZh+AVwUHC8/VdARYtD2PEZ+nI5I
	fx/K9oh
X-Received: by 2002:a05:6830:3741:b0:7cf:da59:9da9 with SMTP id 46e09a7af769-7d15a66595fmr4395256a34.37.1769280284595;
        Sat, 24 Jan 2026 10:44:44 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d15b3d3340sm4465503a34.23.2026.01.24.10.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jan 2026 10:44:43 -0800 (PST)
Message-ID: <adfebec8-e83d-44be-93a0-0b305c85bf38@kernel.dk>
Date: Sat, 24 Jan 2026 11:44:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing
 cross-buffer accounting
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 Yuhao Jiang <danisjiang@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260119071039.2113739-1-danisjiang@gmail.com>
 <bc2e8ec1-8809-4603-9519-788cfff2ae12@kernel.dk>
 <CAHYQsXTHfRKBuTDYWus9r5jDLO2WLBeopt4_bGH_vVm=0z7mWw@mail.gmail.com>
 <2919f3c5-2510-4e97-ab7f-c9eef1c76a69@kernel.dk>
 <CAHYQsXQK4nKu+fcni71__=V241RN=QxUHrvNQMQtPMzeL_z=BA@mail.gmail.com>
 <d8d28435-2a89-4b25-925e-14fdb346839b@gmail.com>
 <8c6a9114-82e9-416e-804b-ffaa7a679ab7@kernel.dk>
 <2be71481-ac35-4ff2-b6a9-a7568f81f728@gmail.com>
 <2fcf583a-f521-4e8d-9a89-0985681ca85b@kernel.dk>
 <d2fc2ff2-98d9-49f8-af95-968100174d55@gmail.com>
 <3b7e6088-7d92-4d5c-96c7-f8c0e2cc7745@kernel.dk>
 <efe080c9-5176-4fa1-9f65-5be44074779e@gmail.com>
 <596bc7ac-3d24-43a7-9e7e-e59189525ebc@gmail.com>
 <fc8664bb-7769-48a2-b470-71fb81828e26@kernel.dk>
 <654fe339-5a2b-4c38-9d2d-28cfc306b307@kernel.dk>
 <eea0d7c3-9aed-4c1f-8146-23b82e611899@kernel.dk>
 <9317bad6-aa89-4e93-b7d2-9e28f5d17cc8@gmail.com>
 <74f2ec89-ca40-44a0-8df7-de404063a1a3@kernel.dk>
 <32b884bc-929b-4b27-ae74-5754fa2473de@kernel.dk>
Content-Language: en-US
In-Reply-To: <32b884bc-929b-4b27-ae74-5754fa2473de@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11917-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9CBC57E869
X-Rspamd-Action: no action

On 1/24/26 8:55 AM, Jens Axboe wrote:
> On 1/24/26 8:14 AM, Jens Axboe wrote:
>>>> ________________________________________________________
>>>> Executed in    2.81 secs    fish           external
>>>>     usr time    0.71 secs  497.00 micros    0.71 secs
>>>>     sys time   19.57 secs  183.00 micros   19.57 secs
>>>>
>>>> which isn't insane. Obviously also needs conditional rescheduling in the
>>>> page loops, as those can take a loooong time for large amounts of
>>>> memory.
>>>
>>> 2.8 sec sounds like a lot as well, makes me wonder which part of
>>> that is mm, but it mm should scale fine-ish. Surely there will be
>>> contention on page refcounts but at least the table walk is
>>> lockless in the best case scenario and otherwise seems to be read
>>> protected by an rw lock.
>>
>> Well a lot of that is also just faulting in the memory on clear, test
>> case should probably be modified to do its own timing. And iterating
>> page arrays is a huge part of it too. There's no real contention in that
>> 2.8 seconds.
> 
> I checked and the faulting part is 2.0s of that runtime. On a re-run:
> 
> axboe@r7625 ~> time ./ppage 32 32
> register 32 GB, num threads 32
> clear msec 2011
> 
> ________________________________________________________
> Executed in    3.13 secs    fish           external
>    usr time    0.78 secs  193.00 micros    0.78 secs
>    sys time   27.46 secs  271.00 micros   27.46 secs
> 
> Or just a single thread:
> 
> axboe@r7625 ~> time ./ppage 32 1
> register 32 GB, num threads 1
> clear msec 2081
> 
> ________________________________________________________
> Executed in    2.29 secs    fish           external
>    usr time    0.58 secs  750.00 micros    0.58 secs
>    sys time    1.71 secs    0.00 micros    1.71 secs
> 
> axboe@r7625 ~ [1]> time ./ppage 64 1
> register 64 GB, num threads 1
> clear msec 5380
> 
> ________________________________________________________
> Executed in    6.24 secs    fish           external
>    usr time    1.42 secs  328.00 micros    1.42 secs
>    sys time    4.82 secs  375.00 micros    4.82 secs

Pondering this some more... We only need the page as the key, as far as
I can tell. The memory is always accounted to ctx->user anyway, and each
struct page address is the same across mm's anyway. So unless I'm
missing something, which is of course quite possible, a per-ctx
accounting should be just fine. This will account each ring registration
separate obviously, but this is what we're doing now anyway. If we want
per user_struct accounting to only account each unique page once, then
we'd simply need to move the xarray to struct user_struct. At least to
me, the important part here is that we need the keep the page pinned
until all refs to it have dropped.

Running with multiple threads in this test case is also pretty futile,
as most of them will run into contention off:

io_register_rsrc_update
    __io_register_rsrc_update
        io_sqe_buffer_register
           io_pin_pages
               gup_fast_fallback
                   __gup_longterm_locked
                       __get_user_pages
                           handle_mm_fault
                           follow_page_pte

which is where basically all of the time is spent on the thread side,
there are multiple threads doing this at the same time. This is really
why cloning exists, just register them once in the parent and clone
between threads.

With all that set, here's the test patch I've run just now:

From 9d7186140889a5db525b425f82e4da642070e82d Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 24 Jan 2026 10:02:41 -0700
Subject: [PATCH] io_uring/rsrc: add huge page accounting for registered
 buffers

Track huge page references in a per-ring xarray to prevent double
accounting when the same huge page is used by multiple registered
buffers, either within the same ring or across cloned rings.

When registering buffers backed by huge pages, we need to account for
RLIMIT_MEMLOCK. But if multiple buffers share the same huge page (common
with cloned buffers), we must not account for the same page multiple
times. Similarly, we must only unaccount when the last reference to a
huge page is released.

Maintain a per-ring xarray (hpage_acct) that tracks reference counts for
each huge page. When registering a buffer, for each unique huge page,
increment it's accounting reference count, and only account pages that
are newly added.

When unregistering a buffer, for each unique huge page, decrement its
refcount. Once the refcount hits zero, the page is unaccounted.

Note: any account is done against the ctx->user that was assigned when
the ring was setup. As before, if root is running the operation, no
accounting is done.

With these changes, any use of imu->acct_pages is also dead, hence kill
it from struct io_mapped_ubuf. This shrinks it from 54b to 48b on a
64-bit arch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   3 +
 io_uring/io_uring.c            |   3 +
 io_uring/rsrc.c                | 218 ++++++++++++++++++++++++---------
 io_uring/rsrc.h                |   1 -
 4 files changed, 164 insertions(+), 61 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index dc6bd6940a0d..69b9aaf5b3d2 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -418,6 +418,9 @@ struct io_ring_ctx {
 	/* Stores zcrx object pointers of type struct io_zcrx_ifq */
 	struct xarray			zcrx_ctxs;
 
+	/* Used for accounting references on pages in registered buffers */
+	struct xarray		hpage_acct;
+
 	u32			pers_next;
 	struct xarray		personalities;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5c503a3f6ecc..dde5d7709c4f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -230,6 +230,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		return NULL;
 
 	xa_init(&ctx->io_bl_xa);
+	xa_init(&ctx->hpage_acct);
 
 	/*
 	 * Use 5 bits less than the max cq entries, that should give us around
@@ -298,6 +299,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_free_alloc_caches(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->hpage_acct);
 	kfree(ctx);
 	return NULL;
 }
@@ -2178,6 +2180,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_napi_free(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->hpage_acct);
 	kfree(ctx);
 }
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 41c89f5c616d..cf22de299464 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -28,7 +28,45 @@ struct io_rsrc_update {
 };
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-			struct iovec *iov, struct page **last_hpage);
+						   struct iovec *iov);
+
+static bool hpage_acct_ref(struct io_ring_ctx *ctx, struct page *hpage)
+{
+	unsigned long key = (unsigned long) hpage;
+	unsigned long count;
+	void *entry;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	entry = xa_load(&ctx->hpage_acct, key);
+	if (!entry && xa_reserve(&ctx->hpage_acct, key, GFP_KERNEL_ACCOUNT))
+		return false;
+
+	count = 1;
+	if (entry)
+		count = xa_to_value(entry) + 1;
+	xa_store(&ctx->hpage_acct, key, xa_mk_value(count), GFP_NOWAIT);
+	return count == 1;
+}
+
+static bool hpage_acct_unref(struct io_ring_ctx *ctx, struct page *hpage)
+{
+	unsigned long key = (unsigned long) hpage;
+	unsigned long count;
+	void *entry;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	entry = xa_load(&ctx->hpage_acct, key);
+	if (WARN_ON_ONCE(!entry))
+		return false;
+	count = xa_to_value(entry);
+	if (count == 1)
+		xa_erase(&ctx->hpage_acct, key);
+	else
+		xa_store(&ctx->hpage_acct, key, xa_mk_value(count - 1), GFP_NOWAIT);
+	return count == 1;
+}
 
 /* only define max */
 #define IORING_MAX_FIXED_FILES	(1U << 20)
@@ -139,15 +177,53 @@ static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 		kvfree(imu);
 }
 
+static unsigned long io_buffer_unaccount_pages(struct io_ring_ctx *ctx,
+					       struct io_mapped_ubuf *imu)
+{
+	struct page *seen = NULL;
+	unsigned long acct = 0;
+	int i;
+
+	if (imu->is_kbuf || !ctx->user)
+		return 0;
+
+	for (i = 0; i < imu->nr_bvecs; i++) {
+		struct page *page = imu->bvec[i].bv_page;
+		struct page *hpage;
+
+		if (!PageCompound(page)) {
+			acct++;
+			continue;
+		}
+
+		hpage = compound_head(page);
+		if (hpage == seen)
+			continue;
+		seen = hpage;
+
+		/* Unaccount on last reference */
+		if (hpage_acct_unref(ctx, hpage))
+			acct += page_size(hpage) >> PAGE_SHIFT;
+		cond_resched();
+	}
+
+	return acct;
+}
+
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
+	unsigned long acct_pages = 0;
+
+	/* Always decrement, so it works for cloned buffers too */
+	acct_pages = io_buffer_unaccount_pages(ctx, imu);
+
 	if (unlikely(refcount_read(&imu->refs) > 1)) {
 		if (!refcount_dec_and_test(&imu->refs))
 			return;
 	}
 
-	if (imu->acct_pages)
-		io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pages);
+	if (acct_pages)
+		io_unaccount_mem(ctx->user, ctx->mm_account, acct_pages);
 	imu->release(imu->priv);
 	io_free_imu(ctx, imu);
 }
@@ -294,7 +370,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 {
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	struct iovec fast_iov, *iov;
-	struct page *last_hpage = NULL;
 	struct iovec __user *uvec;
 	u64 user_data = up->data;
 	__u32 done;
@@ -322,7 +397,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		err = io_buffer_validate(iov);
 		if (err)
 			break;
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, iov);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
@@ -620,76 +695,73 @@ int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 }
 
 /*
- * Not super efficient, but this is just a registration time. And we do cache
- * the last compound head, so generally we'll only do a full search if we don't
- * match that one.
- *
- * We check if the given compound head page has already been accounted, to
- * avoid double accounting it. This allows us to account the full size of the
- * page, not just the constituent pages of a huge page.
+ * Undo hpage_acct_ref() calls made during io_buffer_account_pin() on failure.
+ * This operates on the pages array since imu->bvec isn't populated yet.
  */
-static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
-				  int nr_pages, struct page *hpage)
+static void io_buffer_unaccount_hpages(struct io_ring_ctx *ctx,
+				       struct page **pages, int nr_pages)
 {
-	int i, j;
+	struct page *seen = NULL;
+	int i;
+
+	if (!ctx->user)
+		return;
 
-	/* check current page array */
 	for (i = 0; i < nr_pages; i++) {
+		struct page *hpage;
+
 		if (!PageCompound(pages[i]))
 			continue;
-		if (compound_head(pages[i]) == hpage)
-			return true;
-	}
-
-	/* check previously registered pages */
-	for (i = 0; i < ctx->buf_table.nr; i++) {
-		struct io_rsrc_node *node = ctx->buf_table.nodes[i];
-		struct io_mapped_ubuf *imu;
 
-		if (!node)
+		hpage = compound_head(pages[i]);
+		if (hpage == seen)
 			continue;
-		imu = node->buf;
-		for (j = 0; j < imu->nr_bvecs; j++) {
-			if (!PageCompound(imu->bvec[j].bv_page))
-				continue;
-			if (compound_head(imu->bvec[j].bv_page) == hpage)
-				return true;
-		}
-	}
+		seen = hpage;
 
-	return false;
+		hpage_acct_unref(ctx, hpage);
+		cond_resched();
+	}
 }
 
 static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
-				 int nr_pages, struct io_mapped_ubuf *imu,
-				 struct page **last_hpage)
+				 int nr_pages)
 {
+	unsigned long acct_pages = 0;
+	struct page *seen = NULL;
 	int i, ret;
 
-	imu->acct_pages = 0;
+	if (!ctx->user)
+		return 0;
+
 	for (i = 0; i < nr_pages; i++) {
+		struct page *hpage;
+
 		if (!PageCompound(pages[i])) {
-			imu->acct_pages++;
-		} else {
-			struct page *hpage;
-
-			hpage = compound_head(pages[i]);
-			if (hpage == *last_hpage)
-				continue;
-			*last_hpage = hpage;
-			if (headpage_already_acct(ctx, pages, i, hpage))
-				continue;
-			imu->acct_pages += page_size(hpage) >> PAGE_SHIFT;
+			acct_pages++;
+			continue;
 		}
+
+		hpage = compound_head(pages[i]);
+		if (hpage == seen)
+			continue;
+		seen = hpage;
+
+		if (hpage_acct_ref(ctx, hpage))
+			acct_pages += page_size(hpage) >> PAGE_SHIFT;
+		cond_resched();
 	}
 
-	if (!imu->acct_pages)
-		return 0;
+	/* Try to account the memory */
+	if (acct_pages) {
+		ret = io_account_mem(ctx->user, ctx->mm_account, acct_pages);
+		if (ret) {
+			/* Undo the refs we just added */
+			io_buffer_unaccount_hpages(ctx, pages, nr_pages);
+			return ret;
+		}
+	}
 
-	ret = io_account_mem(ctx->user, ctx->mm_account, imu->acct_pages);
-	if (ret)
-		imu->acct_pages = 0;
-	return ret;
+	return 0;
 }
 
 static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
@@ -778,8 +850,7 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov,
-						   struct page **last_hpage)
+						   struct iovec *iov)
 {
 	struct io_mapped_ubuf *imu = NULL;
 	struct page **pages = NULL;
@@ -817,7 +888,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		goto done;
 
 	imu->nr_bvecs = nr_pages;
-	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
+	ret = io_buffer_account_pin(ctx, pages, nr_pages);
 	if (ret)
 		goto done;
 
@@ -867,7 +938,6 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int nr_args, u64 __user *tags)
 {
-	struct page *last_hpage = NULL;
 	struct io_rsrc_data data;
 	struct iovec fast_iov, *iov = &fast_iov;
 	const struct iovec __user *uvec;
@@ -913,7 +983,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, iov);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
@@ -980,7 +1050,6 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 
 	imu->ubuf = 0;
 	imu->len = blk_rq_bytes(rq);
-	imu->acct_pages = 0;
 	imu->folio_shift = PAGE_SHIFT;
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
@@ -1153,6 +1222,33 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 }
 
 /* Lock two rings at once. The rings must be different! */
+static void io_buffer_acct_cloned_hpages(struct io_ring_ctx *ctx,
+					 struct io_mapped_ubuf *imu)
+{
+	struct page *seen = NULL;
+	int i;
+
+	if (imu->is_kbuf || !ctx->user)
+		return;
+
+	for (i = 0; i < imu->nr_bvecs; i++) {
+		struct page *page = imu->bvec[i].bv_page;
+		struct page *hpage;
+
+		if (!PageCompound(page))
+			continue;
+
+		hpage = compound_head(page);
+		if (hpage == seen)
+			continue;
+		seen = hpage;
+
+		/* Atomically add reference for cloned buffer */
+		hpage_acct_ref(ctx, hpage);
+		cond_resched();
+	}
+}
+
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
 	if (ctx1 > ctx2)
@@ -1234,6 +1330,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 
 			refcount_inc(&src_node->buf->refs);
 			dst_node->buf = src_node->buf;
+			/* track compound references to clones */
+			io_buffer_acct_cloned_hpages(ctx, src_node->buf);
 		}
 		data.nodes[off++] = dst_node;
 		i++;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 4a5db2ad1af2..753d0cec5175 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -34,7 +34,6 @@ struct io_mapped_ubuf {
 	unsigned int	nr_bvecs;
 	unsigned int    folio_shift;
 	refcount_t	refs;
-	unsigned long	acct_pages;
 	void		(*release)(void *);
 	void		*priv;
 	bool		is_kbuf;
-- 
2.51.0

-- 
Jens Axboe

