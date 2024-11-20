Return-Path: <io-uring+bounces-4861-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 806869D3B13
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 13:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AF742839FE
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 12:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6781A9B45;
	Wed, 20 Nov 2024 12:46:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from michel.telenet-ops.be (michel.telenet-ops.be [195.130.137.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2CD1A7045
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 12:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732106799; cv=none; b=dxY/hjrFSnbw9krR5zNu2Zds4brzZVgSA1BDPu1mmHqDrcsmuGXL8MCLqh65ZwgZFfqOp2ROPIPDgiBG6m0ZuhrforLLuNelP9uHWuOeo5buk1lcTAgmLLGRCnqhOpSMYMRyBMIlSHqumrAqVkt9auqXJDPASYlxAjUZm+XMzBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732106799; c=relaxed/simple;
	bh=jS7aMpa63T45yjLrS+R35Cy/TD0V6z13wR4ZGFUUcdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kZmQO/ewJTgFJNza6ESunVQ6B5/SVCFm8oOgFa+kaqNIiTOxcWKIs+5GSqg27j7nJOx9PX9c0tsaFfvTuWuuIppyzvgjvOW/auyHONJQ+7NdSwXP/RhSAGMM7DPy4OBnjn+H3qZAwOHXqQVTGtQGdmmukjfQBuii3yS46CKBSA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:35da:ab43:467b:7991])
	by michel.telenet-ops.be with cmsmtp
	id f0mP2D00H3gUftr060mPnS; Wed, 20 Nov 2024 13:46:34 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1tDk5o-007c0T-5O;
	Wed, 20 Nov 2024 13:46:23 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1tDk6B-009N9j-E0;
	Wed, 20 Nov 2024 13:46:23 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mike@rox.of.borg,
	Rapoport@rox.of.borg,
	Christian Brauner <brauner@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>
Cc: linux-mm@kvack.org,
	io-uring@vger.kernel.org,
	linux-m68k@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] slab: Fix too strict alignment check in create_cache()
Date: Wed, 20 Nov 2024 13:46:21 +0100
Message-Id: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On m68k, where the minimum alignment of unsigned long is 2 bytes:

    Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
    CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-atari-03776-g7eaa1f99261a #1783
    Stack from 0102fe5c:
	    0102fe5c 00514a2b 00514a2b ffffff00 00000001 0051f5ed 00425e78 00514a2b
	    0041eb74 ffffffea 00000310 0051f5ed ffffffea ffffffea 00601f60 00000044
	    0102ff20 000e7a68 0051ab8e 004383b8 0051f5ed ffffffea 000000b8 00000007
	    01020c00 00000000 000e77f0 0041e5f0 005f67c0 0051f5ed 000000b6 0102fef4
	    00000310 0102fef4 00000000 00000016 005f676c 0060a34c 00000010 00000004
	    00000038 0000009a 01000000 000000b8 005f668e 0102e000 00001372 0102ff88
    Call Trace: [<00425e78>] dump_stack+0xc/0x10
     [<0041eb74>] panic+0xd8/0x26c
     [<000e7a68>] __kmem_cache_create_args+0x278/0x2e8
     [<000e77f0>] __kmem_cache_create_args+0x0/0x2e8
     [<0041e5f0>] memset+0x0/0x8c
     [<005f67c0>] io_uring_init+0x54/0xd2

The minimal alignment of an integral type may differ from its size,
hence is not safe to assume that an arbitrary freeptr_t (which is
basically an unsigned long) is always aligned to 4 or 8 bytes.

As nothing seems to require the additional alignment, it is safe to fix
this by relaxing the check to the actual minimum alignment of freeptr_t.

Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache")
Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 mm/slab_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 893d320599151845..f2f201d865c108bd 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -230,7 +230,7 @@ static struct kmem_cache *create_cache(const char *name,
 	if (args->use_freeptr_offset &&
 	    (args->freeptr_offset >= object_size ||
 	     !(flags & SLAB_TYPESAFE_BY_RCU) ||
-	     !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
+	     !IS_ALIGNED(args->freeptr_offset, __alignof(freeptr_t))))
 		goto out;
 
 	err = -ENOMEM;
-- 
2.34.1


