Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4923916281A
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 15:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgBRO1O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 09:27:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55678 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgBRO1O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 09:27:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YS36TkOpB+s1Z6ooC/rDC9dFIpR2y2lNd3Ik+zEuCxU=; b=NhSEsw2lStmnnhLyJ85FT6Sk9w
        tPdddRhOKqK1EeDwUaZXD4Q6R0PkJp5PkBLmBMzxMcXnIj2/chzdrKg4jOTtQtFWask8ZO7g5ge5W
        vjnMhhUtwasWZLuWA/YhJYPjA8kZordg9YlahwINShfH1id6K+7mWBCDbANhisHLbyqBhrxE6aE56
        JZlI3cQ09t8fEMf7Fev8Rdc7IBKRZ+j3hjsOcvOllNBvT20nrOZZ0NZzdqhnCA8KjFd3x1/FQuOOz
        v/1FpnJ320XbjAPikGkw2zxc5mvIKXyHK8EOh6nzFmUwB0h5ijpM+vAqInVrhtcfoWoDBk/6joi1F
        AQ2usvuA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j43q4-0005yV-9b; Tue, 18 Feb 2020 14:27:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6B68E300606;
        Tue, 18 Feb 2020 15:25:08 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 52AC72B92E8B9; Tue, 18 Feb 2020 15:27:00 +0100 (CET)
Date:   Tue, 18 Feb 2020 15:27:00 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>
Subject: [PATCH] asm-generic/atomic: Add try_cmpxchg() fallbacks
Message-ID: <20200218142700.GB14946@hirez.programming.kicks-ass.net>
References: <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 18, 2020 at 02:13:10PM +0100, Peter Zijlstra wrote:
> (with the caveat that try_cmpxchg() doesn't seem available on !x86 -- I
> should go fix that)

Completely untested (lemme go do that shortly), but something like so I
suppose.

---
Subject: asm-generic/atomic: Add try_cmpxchg() fallbacks

Only x86 provides try_cmpxchg() outside of the atomic_t interfaces,
provide generic fallbacks to create this interface from the widely
available cmpxchg() function.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
diff --git a/include/linux/atomic-fallback.h b/include/linux/atomic-fallback.h
index 656b5489b673..243f61d6c35f 100644
--- a/include/linux/atomic-fallback.h
+++ b/include/linux/atomic-fallback.h
@@ -77,6 +77,50 @@
 
 #endif /* cmpxchg64_relaxed */
 
+#ifndef try_cmpxchg
+#define try_cmpxchg(_ptr, _oldp, _new) \
+({ \
+	typeof(*ptr) ___r, ___o = *(_oldp); \
+	___r = cmpxchg((_ptr), ___o, (_new)); \
+	if (unlikely(___r != ___o)) \
+		*(_old) = ___r; \
+	likely(___r == ___o); \
+})
+#endif /* try_cmpxchg */
+
+#ifndef try_cmpxchg_acquire
+#define try_cmpxchg_acquire(_ptr, _oldp, _new) \
+({ \
+	typeof(*ptr) ___r, ___o = *(_oldp); \
+	___r = cmpxchg_acquire((_ptr), ___o, (_new)); \
+	if (unlikely(___r != ___o)) \
+		*(_old) = ___r; \
+	likely(___r == ___o); \
+})
+#endif /* try_cmpxchg_acquire */
+
+#ifndef try_cmpxchg_release
+#define try_cmpxchg_release(_ptr, _oldp, _new) \
+({ \
+	typeof(*ptr) ___r, ___o = *(_oldp); \
+	___r = cmpxchg_release((_ptr), ___o, (_new)); \
+	if (unlikely(___r != ___o)) \
+		*(_old) = ___r; \
+	likely(___r == ___o); \
+})
+#endif /* try_cmpxchg_release */
+
+#ifndef try_cmpxchg_relaxed
+#define try_cmpxchg_relaxed(_ptr, _oldp, _new) \
+({ \
+	typeof(*ptr) ___r, ___o = *(_oldp); \
+	___r = cmpxchg_relaxed((_ptr), ___o, (_new)); \
+	if (unlikely(___r != ___o)) \
+		*(_old) = ___r; \
+	likely(___r == ___o); \
+})
+#endif /* try_cmpxchg_relaxed */
+
 #ifndef atomic_read_acquire
 static __always_inline int
 atomic_read_acquire(const atomic_t *v)
@@ -2294,4 +2338,4 @@ atomic64_dec_if_positive(atomic64_t *v)
 #define atomic64_cond_read_relaxed(v, c) smp_cond_load_relaxed(&(v)->counter, (c))
 
 #endif /* _LINUX_ATOMIC_FALLBACK_H */
-// baaf45f4c24ed88ceae58baca39d7fd80bb8101b
+// 2dfbc767ce308d2edd67a49bd7b764dd07f62f6c
diff --git a/scripts/atomic/gen-atomic-fallback.sh b/scripts/atomic/gen-atomic-fallback.sh
index b6c6f5d306a7..3c9be8d550e0 100755
--- a/scripts/atomic/gen-atomic-fallback.sh
+++ b/scripts/atomic/gen-atomic-fallback.sh
@@ -140,6 +140,32 @@ cat <<EOF
 EOF
 }
 
+gen_try_cmpxchg_fallback()
+{
+	local order="$1"; shift;
+
+cat <<EOF
+#ifndef try_cmpxchg${order}
+#define try_cmpxchg${order}(_ptr, _oldp, _new) \\
+({ \\
+	typeof(*ptr) ___r, ___o = *(_oldp); \\
+	___r = cmpxchg${order}((_ptr), ___o, (_new)); \\
+	if (unlikely(___r != ___o)) \\
+		*(_old) = ___r; \\
+	likely(___r == ___o); \\
+})
+#endif /* try_cmpxchg${order} */
+
+EOF
+}
+
+gen_try_cmpxchg_fallbacks()
+{
+	for order in "" "_acquire" "_release" "_relaxed"; do
+		gen_try_cmpxchg_fallback "${order}"
+	done
+}
+
 cat << EOF
 // SPDX-License-Identifier: GPL-2.0
 
@@ -157,6 +183,8 @@ for xchg in "xchg" "cmpxchg" "cmpxchg64"; do
 	gen_xchg_fallbacks "${xchg}"
 done
 
+gen_try_cmpxchg_fallbacks
+
 grep '^[a-z]' "$1" | while read name meta args; do
 	gen_proto "${meta}" "${name}" "atomic" "int" ${args}
 done
