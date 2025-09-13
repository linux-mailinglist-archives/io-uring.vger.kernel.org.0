Return-Path: <io-uring+bounces-9785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5487B5610F
	for <lists+io-uring@lfdr.de>; Sat, 13 Sep 2025 15:16:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FFCD3AF6BB
	for <lists+io-uring@lfdr.de>; Sat, 13 Sep 2025 13:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6538A268C73;
	Sat, 13 Sep 2025 13:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="eqYU++Js"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCED1145B27;
	Sat, 13 Sep 2025 13:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757769368; cv=none; b=n5yf9awCAnYKwpRjMC2YmmIkALMJlBnkqLgBxPj+yEvy23Id6u1aZ7GzOveoSMVrWsSY7/OK+njqx0LwmSjMg/EtJKWtKH/gNwgoUFAo6XZQhq6kvHrCRUK+Fme46aY6rX7DYaA6r1OremHKxzAEDVbEEMRRX+bVEDd1bGQNuDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757769368; c=relaxed/simple;
	bh=HEcey3oOKkFMYxoJsTsYPxiXSLPXDv9uKA9bYgH7v9A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=QfN/d9i/Dgq+2cyZjTrhXuKynMlk+JgqocXSocm3btxw70mvpOuMkTJE7n+46EQqpzjX5ZyA/l1rU9rTcsSeATK7l1zC5CCE+pEZK+Nx/QKSPUrc8LDIXRWGGnDxWN1CrpAJp4uxutY/YwSft2uHOb6lYLUquxJvT1z65XdMqQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=eqYU++Js; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1757769356;
	bh=HEcey3oOKkFMYxoJsTsYPxiXSLPXDv9uKA9bYgH7v9A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=eqYU++JslmCu7DoyXBX6i5SPCggPQ4IXTmMJVoJbNGQRsVrsCQNcQigVW8zIE1XGN
	 UjBIwUBdeLgG2L3SY1vvKr2OLXf14siWk9igYOxO6RErF+RHrsLh3GH0Jc/L37zNRa
	 G2ArQMghy7iE3MNbkFqJIsLSKdAaiLLIztvPGMj0awnBFesdtjiFUr+pAbQJ7fJXtl
	 gewXKajXgs6iBn81XVdAmgM4lYlyXI0+8K35aiIrN9FweD2/ip56fOqPXWPI3YEHHW
	 K5Ixdw8GOhJO/Ch22Mji3fSXBF95quu95mYrJozGw1+l48dUByZUl1xJokxMCzdOML
	 ejHjKrF/DdgPA==
Received: from integral2.. (unknown [182.253.126.215])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id 9ECEE3127994;
	Sat, 13 Sep 2025 13:15:52 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	dr.xiaosa@gmail.com,
	Bart Van Assche <bvanassche@acm.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH liburing v1] barrier: Convert C++ barrier functions into macros
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sat, 13 Sep 2025 20:15:47 +0700
Message-Id: <20250913131547.466233-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The C++20 module export feature fails to operate correctly with the C++
version's static inline barrier functions:

  In file included from src/work.cpp:3:
  ./include/liburing.h:343:20: error: \
    ‘void io_uring_cq_advance(io_uring*, unsigned int)’ \
    exposes TU-local entity ‘void io_uring_smp_store_release(T*, T) [with T = unsigned int]’
    343 | IOURINGINLINE void io_uring_cq_advance(struct io_uring *ring, unsigned nr)
        |                    ^~~~~~~~~~~~~~~~~~~
  In file included from ./include/liburing.h:20:
  ./include/liburing/barrier.h:42:20: note: \
    ‘void io_uring_smp_store_release(T*, T) [with T = unsigned int]’ is a \
    specialization of TU-local template \
    ‘template<class T> void io_uring_smp_store_release(T*, T)’
    42 | static inline void io_uring_smp_store_release(T *p, T v)
        |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~
  ./include/liburing/barrier.h:42:20: note: \
    ‘template<class T> void io_uring_smp_store_release(T*, T)’ declared with internal linkage

Convert them into macros just like the C version to fix it.

Closes: https://github.com/axboe/liburing/issues/1457
Reported-by: @xiaosa-zhz # A GitHub user
Fixes: 3d74c677c45e ("Make the liburing header files again compatible with C++")
Cc: dr.xiaosa@gmail.com
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing/barrier.h | 55 ++++++++++++----------------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff --git a/src/include/liburing/barrier.h b/src/include/liburing/barrier.h
index 985569f496a8..9bf1eaf374a3 100644
--- a/src/include/liburing/barrier.h
+++ b/src/include/liburing/barrier.h
@@ -23,46 +23,29 @@ after the acquire operation executes. This is implemented using
 
 #ifdef __cplusplus
 #include <atomic>
-#define LIBURING_NOEXCEPT noexcept
+#define IO_URING_WRITE_ONCE(var, val) \
+	std::atomic_store_explicit( \
+		reinterpret_cast<std::atomic<__typeof__(var)> *>(&(var)), \
+		(val), std::memory_order_relaxed)
 
-template <typename T>
-static inline void IO_URING_WRITE_ONCE(T &var, T val)
-	LIBURING_NOEXCEPT
-{
-	std::atomic_store_explicit(reinterpret_cast<std::atomic<T> *>(&var),
-				   val, std::memory_order_relaxed);
-}
-template <typename T>
-static inline T IO_URING_READ_ONCE(const T &var)
-	LIBURING_NOEXCEPT
-{
-	return std::atomic_load_explicit(
-		reinterpret_cast<const std::atomic<T> *>(&var),
-		std::memory_order_relaxed);
-}
+#define IO_URING_READ_ONCE(var) \
+	std::atomic_load_explicit( \
+		reinterpret_cast<const std::atomic<__typeof__(var)> *>(&(var)), \
+		std::memory_order_relaxed)
 
-template <typename T>
-static inline void io_uring_smp_store_release(T *p, T v)
-	LIBURING_NOEXCEPT
-{
-	std::atomic_store_explicit(reinterpret_cast<std::atomic<T> *>(p), v,
-				   std::memory_order_release);
-}
+#define io_uring_smp_store_release(p, v) \
+	std::atomic_store_explicit( \
+		reinterpret_cast<std::atomic<__typeof__(*(p))> *>((p)), \
+		(v), std::memory_order_release)
 
-template <typename T>
-static inline T io_uring_smp_load_acquire(const T *p)
-	LIBURING_NOEXCEPT
-{
-	return std::atomic_load_explicit(
-		reinterpret_cast<const std::atomic<T> *>(p),
-		std::memory_order_acquire);
-}
+#define io_uring_smp_load_acquire(p) \
+	std::atomic_load_explicit( \
+		reinterpret_cast<const std::atomic<__typeof__(*(p))> *>((p)), \
+		std::memory_order_acquire)
+
+#define io_uring_smp_mb() \
+	std::atomic_thread_fence(std::memory_order_seq_cst)
 
-static inline void io_uring_smp_mb()
-	LIBURING_NOEXCEPT
-{
-	std::atomic_thread_fence(std::memory_order_seq_cst);
-}
 #else
 #include <stdatomic.h>
 
-- 
Ammar Faizi


