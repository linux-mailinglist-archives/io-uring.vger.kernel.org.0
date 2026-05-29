Return-Path: <io-uring+bounces-13560-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNLAFJF+GWp9xAgAu9opvQ
	(envelope-from <io-uring+bounces-13560-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 13:54:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id F044C601E80
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 13:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 617C2300C310
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 11:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6453DCDBB;
	Fri, 29 May 2026 11:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8VZz9V7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B613C3BF3;
	Fri, 29 May 2026 11:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780055695; cv=none; b=RCHQAIG80pyoqi0oWQmB1fd4Nzb6sjBjcQnES6onov1gmepc2zopST4xwrDl7M9LVokaI8AFfQfmqImTC6P8sVzyKxaFtzxiM4oD9TuOSdGourwEfZ/53GJyXTxlsGnL0opGBQbzth/fZO6E9rconb3PDQF0EaSsUb8mKWfpdHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780055695; c=relaxed/simple;
	bh=CploV4r1XHi0hyyHrOSw/drP95odjiL6JuuR/nNDCpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FAku3iLN1Z4Y4uHRBqm8sIZJNZyi9YYm0r0Vdod70qKhvgVNn//U+a+x5FgdrhTI59B8u3rSDAbJt2k1uQJY6WhxpfucJvH+ZNRiaf4V5nNW3yXJcx/mcqNCG8zd4ccVVxW+pxnE6AQCsBUJj/WYwmk2lcEKymmyd3qCmYZz4Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8VZz9V7; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298511F00893;
	Fri, 29 May 2026 11:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780055693;
	bh=wDOsRW9HSX03yxtZDtOoclJqvTh9mPV1pfPcH0+q2no=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L8VZz9V7K1eN2jdYePACCXZ60MYUhFC1fOihSN+0H+7dhVQgUxdGJ9EQdJmCDTbwW
	 G+lY0xHDWzx6pTWX1lLWl/0EpNCsU5b9yHlXtO5sbBEMs7G5VmlF0dXcZ9v/DGu76f
	 /viJGQXlwamh7rHUkI0iAX99Shho8pimXeoM0y7KNHlU+cpwDo6MSIljUf43lop+B4
	 Y/IKFYrX4MCpwS9OMGK+k+HTotpqSCbAaZXWldCVwdTAjK0G+boxDWKQ2C5xXoy/Dg
	 Frr8k2GRRRiGohLe6GdGc+rFcv3VqLP0ZveFBiJjWHREuNVs5EyBZwfujpGuPitREW
	 03hx7I5WrTEiQ==
Message-ID: <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
Date: Fri, 29 May 2026 13:54:48 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260528093437.2519248-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13560-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vbabka@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,lst.de:email]
X-Rspamd-Queue-Id: F044C601E80
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/28/26 11:34, Christoph Hellwig wrote:
> The kmem_cache_alloc_bulk return value is weird.  It returns the number
> of allocated objects, but that must always be 0 or the requested number
> based on the implementations and the handling in the callers, but that
> assumption is not actually documented anywhere, which confuses automated
> review tools.
> 
> Fix this by returning a bool if the allocation succeeded and adding a
> kerneldoc comment explaining the API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com> # skbuff
> ---
>  drivers/gpu/drm/msm/msm_iommu.c       |  6 +--
>  drivers/gpu/drm/panthor/panthor_mmu.c | 13 +++---
>  include/linux/slab.h                  |  6 ++-
>  io_uring/io_uring.c                   | 23 ++++-------
>  lib/test_meminit.c                    | 23 +++++------
>  mm/kasan/kasan_test_c.c               |  5 +--
>  mm/kfence/kfence_test.c               |  9 ++--
>  mm/slub.c                             | 59 +++++++++++++++------------
>  net/bpf/test_run.c                    |  7 ++--
>  net/core/skbuff.c                     | 24 ++++++-----
>  tools/include/linux/slab.h            |  2 +-
>  tools/testing/shared/linux.c          | 19 ++++-----
>  12 files changed, 97 insertions(+), 99 deletions(-)

Thanks, I applied it to slab/for-7.2/alloc_bulk and merged to slab/for-next
(it's still yankable in case of issues)

Did some fixups below (the comment was stale prior to the patch; restored
unlikely(), simplified one line).

A test merge into yesterday's -next found a conflict in drivers/gpu/drm/
panthor/panthor_mmu.c. Commit 1013bf53650e ("drm/panthor: Split
panthor_vm_prepare_map_op_ctx() to prepare for reclaim") moved the changed
codeto a new function panthor_vm_op_ctx_prealloc_pts().
But it's solvable so no need for a complicated coordination I think.

diff --git a/mm/slub.c b/mm/slub.c
index 6caf6f3ceeed..711df528c9a6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7372,10 +7372,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
        }
 
 out:
-       /*
-        * memcg and kmem_cache debug support and memory initialization.
-        * Done outside of the IRQ disabled fastpath loop.
-        */
+       /* memcg and kmem_cache debug support and memory initialization */
        return likely(slab_post_alloc_hook(s, NULL, flags, size, p,
                        slab_want_init_on_alloc(flags, s), s->object_size));
 }
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 99ab9ddb05e3..dbf0d8eae8d8 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -246,8 +246,8 @@ static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
        int i;
        LIST_HEAD(list);
 
-       if (!kmem_cache_alloc_bulk(net_hotdata.skbuff_cache, gfp, nframes,
-                                  (void **)skbs)) {
+       if (unlikely(!kmem_cache_alloc_bulk(net_hotdata.skbuff_cache, gfp,
+                                           nframes, (void **)skbs))) {
                for (i = 0; i < nframes; i++)
                        xdp_return_frame(frames[i]);
                return -ENOMEM;
diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index e9c3bc9b3272..e0a0693df08f 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -301,7 +301,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
        if (!kmem_cache_alloc_bulk(s, gfp, size - sheaf->size,
                        &sheaf->objects[sheaf->size]))
                return -ENOMEM;
-       sheaf->size += (size - sheaf->size);
+       sheaf->size = size;
        return 0;
 }








