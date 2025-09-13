Return-Path: <io-uring+bounces-9788-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6054B5623B
	for <lists+io-uring@lfdr.de>; Sat, 13 Sep 2025 18:26:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FCCF567C2C
	for <lists+io-uring@lfdr.de>; Sat, 13 Sep 2025 16:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0AE27A929;
	Sat, 13 Sep 2025 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="SFye6R3s"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EF27081C;
	Sat, 13 Sep 2025 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757780764; cv=none; b=J09/bk3JQdUOhBBjn3eMRGWvSqcNDS5sFRZaW6WUHQXCLYtVnOh9UNnR/Q7nQTAxP2K85L68vq2HOdFKtNoiJd5jMKoCvB0luktYR77BQHrOIsD/eAzhLyvpDG1t98q+isqjHNB9WEIv8jCY1p7nhUUI4gbcQMoHtp4Ws7WIDkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757780764; c=relaxed/simple;
	bh=jqmCguCF6w7+zUWdO0lUxbyB7PG+vg2lZfZBaxgyL3k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=UikHSfPuUnZr4AWE+pUkx6Kx379ZG++gEG9aScv04lPvUg70V+bs695BpKbNTMKoPvnLebJS+1tetQMTFu3B/NQ4NJcqcZ6a3D/2HDBvOQkREQ8hSbfGGDNuOBz+NOr/6gecgqvfMewWQaTOfnD7gxs4C2nwwVw8K7JPCknJzxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=SFye6R3s; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1757780760;
	bh=jqmCguCF6w7+zUWdO0lUxbyB7PG+vg2lZfZBaxgyL3k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:Date:From:Reply-To:Subject:To:
	 Cc:In-Reply-To:References:Resent-Date:Resent-From:Resent-To:
	 Resent-Cc:User-Agent:Content-Type:Content-Transfer-Encoding;
	b=SFye6R3sMjfBJTZx0PxdtsxuYTypgBGlxJk80sA0SlpdozhUjZ2h6sjgffVNmaFkg
	 uosJp46obeAc2wTEbQfB0vX53PR5I6pfUsS2aqq3OZsJFRUFvFnLVObsludvOYI7oi
	 ofX0mC6p5GcbUc/ljKaO3gnLndw5KeEMaYOcxxg9Rp9GpbYQ8abP/Feh9SYZ802VW1
	 rFmkfAYaUKcT5Cu5WjZCSndVzhKAQU+0wV1/izeMxkGJvRuGwi37LLXJvw2YVvabFB
	 h4eoJkAVcBLH7q+H8uTLlj/kmio6HjZQUqQNVddFa95+xt9PwxDtBG8CLjiEHnkZ0q
	 DXm+y0RYA5tEA==
Received: from integral2.. (unknown [182.253.126.215])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id D691E3127978;
	Sat, 13 Sep 2025 16:25:49 +0000 (UTC)
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	io-uring Mailing List <io-uring@vger.kernel.org>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	Bart Van Assche <bvanassche@acm.org>,
	dr.xiaosa@gmail.com
Subject: [PATCH liburing] liburing.h: Support C++20 module export feature
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sat, 13 Sep 2025 23:25:40 +0700
Message-Id: <20250913162540.77167-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Having "static inline" functions in liburing header file results in
compilation errors when using the new C++20 module export feature:

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

Introduce a new macro _LOCAL_INLINE, which will expand to "inline"
instead of "static inline" if compiled using C++20 or later. Also, make
IOURINGINLINE behave the same way in the same condition.

No functional change is expected for C and older C++ versions.

Closes: https://github.com/axboe/liburing/issues/1457
Reported-by: @xiaosa-zhz # A GitHub user
Fixes: 3d74c677c45e ("Make the liburing header files again compatible with C++")
Fixes: f2b6fb85b79b ("liburing: Don't use `IOURINGINLINE` on private helpers")
Cc: dr.xiaosa@gmail.com
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/io-uring/e0559c10-104d-4da8-9f7f-d2ffd73d8df3@acm.org
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

This patch is a follow up to:

  "[PATCH liburing v1] barrier: Convert C++ barrier functions into macros".
  Link: https://lore.kernel.org/io-uring/20250913131547.466233-1-ammarfaizi2@gnuweeb.org

 src/include/liburing.h         | 56 ++++++++++++++++++++++++++--------
 src/include/liburing/barrier.h | 10 +++---
 2 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index e3f394eab860..f9dcd52c1537 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -17,8 +17,6 @@
 #include "liburing/compat.h"
 #include "liburing/io_uring.h"
 #include "liburing/io_uring_version.h"
-#include "liburing/barrier.h"
-
 
 #ifndef uring_unlikely
 #define uring_unlikely(cond)	__builtin_expect(!!(cond), 0)
@@ -29,15 +27,45 @@
 #endif
 
 /*
- * NOTE: Only use IOURINGINLINE macro for 'static inline' functions
- *       that are expected to be available in the FFI bindings.
+ * NOTE: Use IOURINGINLINE macro for "static inline" functions that are
+ *       expected to be available in the FFI bindings. They must also
+ *       be included in the liburing-ffi.map file.
+ *
+ *       Use _LOCAL_INLINE macro for "static inline" functions that are
+ *       not expected to be available in the FFI bindings.
+ *
+ *       Don't use "static inline" directly when defining new functions
+ *       in this header file.
+ *
+ *       Reason:
+ *       The C++20 module export feature fails to operate correctly
+ *       with the "static inline" functions. Use "inline" instead of
+ *       "static inline" when compiling with C++20 or later.
  *
- *       Functions that are marked as IOURINGINLINE should be
- *       included in the liburing-ffi.map file.
+ *       See:
+ *         https://github.com/axboe/liburing/issues/1457
+ *         https://lore.kernel.org/io-uring/e0559c10-104d-4da8-9f7f-d2ffd73d8df3@acm.org
  */
 #ifndef IOURINGINLINE
+#if defined(__cplusplus) && __cplusplus >= 202002L
+#define IOURINGINLINE inline
+#else
 #define IOURINGINLINE static inline
 #endif
+#endif
+
+#ifndef _LOCAL_INLINE
+#if defined(__cplusplus) && __cplusplus >= 202002L
+#define _LOCAL_INLINE inline
+#else
+#define _LOCAL_INLINE static inline
+#endif
+#endif
+
+/*
+ * barrier.h needs _LOCAL_INLINE.
+ */
+#include "liburing/barrier.h"
 
 #ifdef __alpha__
 /*
@@ -159,7 +187,7 @@ struct io_uring_zcrx_rq {
  * Library interface
  */
 
-static inline __u64 uring_ptr_to_u64(const void *ptr) LIBURING_NOEXCEPT
+_LOCAL_INLINE __u64 uring_ptr_to_u64(const void *ptr) LIBURING_NOEXCEPT
 {
 	return (__u64) (unsigned long) ptr;
 }
@@ -402,7 +430,7 @@ struct io_uring_cqe_iter {
 	unsigned tail;
 };
 
-static inline struct io_uring_cqe_iter
+_LOCAL_INLINE struct io_uring_cqe_iter
 io_uring_cqe_iter_init(const struct io_uring *ring)
 	LIBURING_NOEXCEPT
 {
@@ -416,7 +444,7 @@ io_uring_cqe_iter_init(const struct io_uring *ring)
 	};
 }
 
-static inline bool io_uring_cqe_iter_next(struct io_uring_cqe_iter *iter,
+_LOCAL_INLINE bool io_uring_cqe_iter_next(struct io_uring_cqe_iter *iter,
 					  struct io_uring_cqe **cqe)
 	LIBURING_NOEXCEPT
 {
@@ -522,7 +550,7 @@ IOURINGINLINE void io_uring_sqe_set_buf_group(struct io_uring_sqe *sqe,
 	sqe->buf_group = (__u16) bgid;
 }
 
-static inline void __io_uring_set_target_fixed_file(struct io_uring_sqe *sqe,
+_LOCAL_INLINE void __io_uring_set_target_fixed_file(struct io_uring_sqe *sqe,
 						    unsigned int file_index)
 	LIBURING_NOEXCEPT
 {
@@ -704,7 +732,7 @@ IOURINGINLINE void io_uring_prep_sendmsg(struct io_uring_sqe *sqe, int fd,
 	sqe->msg_flags = flags;
 }
 
-static inline unsigned __io_uring_prep_poll_mask(unsigned poll_mask)
+_LOCAL_INLINE unsigned __io_uring_prep_poll_mask(unsigned poll_mask)
 	LIBURING_NOEXCEPT
 {
 #if __BYTE_ORDER == __BIG_ENDIAN
@@ -1742,7 +1770,7 @@ IOURINGINLINE int io_uring_wait_cqe_nr(struct io_uring *ring,
  * "official" versions of this, io_uring_peek_cqe(), io_uring_wait_cqe(),
  * or io_uring_wait_cqes*().
  */
-static inline int __io_uring_peek_cqe(struct io_uring *ring,
+_LOCAL_INLINE int __io_uring_peek_cqe(struct io_uring *ring,
 				      struct io_uring_cqe **cqe_ptr,
 				      unsigned *nr_available)
 	LIBURING_NOEXCEPT
@@ -1987,4 +2015,8 @@ bool io_uring_check_version(int major, int minor) LIBURING_NOEXCEPT;
 #undef IOURINGINLINE
 #endif
 
+#ifdef _LOCAL_INLINE
+#undef _LOCAL_INLINE
+#endif
+
 #endif
diff --git a/src/include/liburing/barrier.h b/src/include/liburing/barrier.h
index 985569f496a8..0ae77b16ecf3 100644
--- a/src/include/liburing/barrier.h
+++ b/src/include/liburing/barrier.h
@@ -26,14 +26,14 @@ after the acquire operation executes. This is implemented using
 #define LIBURING_NOEXCEPT noexcept
 
 template <typename T>
-static inline void IO_URING_WRITE_ONCE(T &var, T val)
+_LOCAL_INLINE void IO_URING_WRITE_ONCE(T &var, T val)
 	LIBURING_NOEXCEPT
 {
 	std::atomic_store_explicit(reinterpret_cast<std::atomic<T> *>(&var),
 				   val, std::memory_order_relaxed);
 }
 template <typename T>
-static inline T IO_URING_READ_ONCE(const T &var)
+_LOCAL_INLINE T IO_URING_READ_ONCE(const T &var)
 	LIBURING_NOEXCEPT
 {
 	return std::atomic_load_explicit(
@@ -42,7 +42,7 @@ static inline T IO_URING_READ_ONCE(const T &var)
 }
 
 template <typename T>
-static inline void io_uring_smp_store_release(T *p, T v)
+_LOCAL_INLINE void io_uring_smp_store_release(T *p, T v)
 	LIBURING_NOEXCEPT
 {
 	std::atomic_store_explicit(reinterpret_cast<std::atomic<T> *>(p), v,
@@ -50,7 +50,7 @@ static inline void io_uring_smp_store_release(T *p, T v)
 }
 
 template <typename T>
-static inline T io_uring_smp_load_acquire(const T *p)
+_LOCAL_INLINE T io_uring_smp_load_acquire(const T *p)
 	LIBURING_NOEXCEPT
 {
 	return std::atomic_load_explicit(
@@ -58,7 +58,7 @@ static inline T io_uring_smp_load_acquire(const T *p)
 		std::memory_order_acquire);
 }
 
-static inline void io_uring_smp_mb()
+_LOCAL_INLINE void io_uring_smp_mb()
 	LIBURING_NOEXCEPT
 {
 	std::atomic_thread_fence(std::memory_order_seq_cst);

base-commit: 97c596056b81488b86ff300cdbaf06471af3cc6e
-- 
Ammar Faizi


