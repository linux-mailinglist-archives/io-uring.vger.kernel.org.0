Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A0520C30D
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 18:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgF0QXQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 12:23:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35785 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgF0QXQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 12:23:16 -0400
Received: by mail-pg1-f195.google.com with SMTP id f3so6391549pgr.2
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 09:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language;
        bh=vqCQSJjCl1be3EO7M9mYmwD5jmS6Nx3C2TK78jm9+bk=;
        b=rOTrrs6SRMR/T0dmVcjPIn7ug4kik+BR949CNGOZP69b8uZjEJHGtqvalJ4LoAwwnm
         pdqiCcSJlJz22fm2jEqJgkc5thSWUy0PQgTSpWi1BjIYB7+O5hMaYHdRIGxmfe0cFGlF
         DhLqIEAlUh/PLyVy5ukhtukOMxhJdVclB5bQbO03fLOcPnYh8MJlSroi1bBtv2LxFsgy
         udRxe7z8E5QTGElZB36tLm7XvS8C6Yqz4KhNEqAir2B01ijKlNheymUSvfsFQedQz4Ev
         Ek9BAfF7+xiA7fEeTqN2VRNmN18O6u3dcLGZWumh0r81+qROEWR18yFE7+H3S3Zejzl7
         D0Kw==
X-Gm-Message-State: AOAM5304l2k3sP+XgTshaSf1nep/A0k5y+ZYyOdhSyG5SWofkAAPas0w
        dAB8gQrpJauzYHDX17FzX8q/ZU5j
X-Google-Smtp-Source: ABdhPJwbMWKRnOVHOM/YSjZfHKTW2kI/1gBzhqLbD95ekwNZ2WPcfzT60atUM2NsynqnvJaGpwhfvg==
X-Received: by 2002:aa7:91d4:: with SMTP id z20mr7229708pfa.153.1593274994391;
        Sat, 27 Jun 2020 09:23:14 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k19sm30213685pfg.153.2020.06.27.09.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2020 09:23:13 -0700 (PDT)
Subject: Re: [RFC PATCH] Fix usage of stdatomic.h for C++ compilers
To:     Hrvoje Zeba <zeba.hrvoje@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20200627055515.764165-1-zeba.hrvoje@gmail.com>
 <b83a2cc5-31ea-9782-1eeb-70b8537f92c3@acm.org>
 <CAEsUgYj6NDoHPHN+i7tsR5P0tj1Dj47ixJFhFf8UVpm7kagfhg@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <c9603711-18c6-217b-ced0-cc1fefec0c6e@acm.org>
Date:   Sat, 27 Jun 2020 09:23:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAEsUgYj6NDoHPHN+i7tsR5P0tj1Dj47ixJFhFf8UVpm7kagfhg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------D425848F4E66FE4301C31EB0"
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------D425848F4E66FE4301C31EB0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2020-06-27 08:39, Hrvoje Zeba wrote:
> Any suggestions?

How about the two attached (untested) patches?

Thanks,

Bart.



--------------D425848F4E66FE4301C31EB0
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-Make-the-liburing-header-files-again-compatible-with.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Make-the-liburing-header-files-again-compatible-with.pa";
 filename*1="tch"

From 2d6b8423ece7f00798d73ede08719d4da6abbd46 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 27 Jun 2020 08:40:23 -0700
Subject: [PATCH liburing 1/2] Make the liburing header files again compatible
 with C++

This patch has been tested by inspecting the output of the following
command:

g++ -I src/include -c -Wall -Wextra src/*.c

Fixes: b9c0bf79aa87 ("src/include/liburing/barrier.h: Use C11 atomics") # .
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 src/include/liburing.h         |  8 ++++----
 src/include/liburing/barrier.h | 37 ++++++++++++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index c9034fc0df1b..76e2b854f957 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -2,10 +2,6 @@
 #ifndef LIB_URING_H
 #define LIB_URING_H
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 #include <sys/socket.h>
 #include <sys/uio.h>
 #include <sys/stat.h>
@@ -19,6 +15,10 @@ extern "C" {
 #include "liburing/io_uring.h"
 #include "liburing/barrier.h"
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /*
  * Library interface to io_uring
  */
diff --git a/src/include/liburing/barrier.h b/src/include/liburing/barrier.h
index c8aa4210371c..5ad337f33262 100644
--- a/src/include/liburing/barrier.h
+++ b/src/include/liburing/barrier.h
@@ -2,8 +2,6 @@
 #ifndef LIBURING_BARRIER_H
 #define LIBURING_BARRIER_H
 
-#include <stdatomic.h>
-
 /*
 From the kernel documentation file refcount-vs-atomic.rst:
 
@@ -23,6 +21,40 @@ after the acquire operation executes. This is implemented using
 :c:func:`smp_acquire__after_ctrl_dep`.
 */
 
+#ifdef __cplusplus
+#include <atomic>
+
+template <typename T>
+static inline void IO_URING_WRITE_ONCE(T &var, T val)
+{
+	std::atomic_store_explicit(reinterpret_cast<std::atomic<T> *>(&var),
+				   val, std::memory_order_relaxed);
+}
+template <typename T>
+static inline T IO_URING_READ_ONCE(const T &var)
+{
+	return std::atomic_load_explicit(
+		reinterpret_cast<const std::atomic<T> *>(&var),
+		std::memory_order_relaxed);
+}
+
+template <typename T>
+static inline void io_uring_smp_store_release(T *p, T v)
+{
+	std::atomic_store_explicit(reinterpret_cast<std::atomic<T> *>(p), v,
+				   std::memory_order_release);
+}
+
+template <typename T>
+static inline T io_uring_smp_load_acquire(const T *p)
+{
+	return std::atomic_load_explicit(
+		reinterpret_cast<const std::atomic<T> *>(p),
+		std::memory_order_acquire);
+}
+#else
+#include <stdatomic.h>
+
 #define IO_URING_WRITE_ONCE(var, val)				\
 	atomic_store_explicit(&(var), (val), memory_order_relaxed)
 #define IO_URING_READ_ONCE(var)					\
@@ -32,5 +64,6 @@ after the acquire operation executes. This is implemented using
 	atomic_store_explicit((p), (v), memory_order_release)
 #define io_uring_smp_load_acquire(p)				\
 	atomic_load_explicit((p), memory_order_acquire)
+#endif
 
 #endif /* defined(LIBURING_BARRIER_H) */

--------------D425848F4E66FE4301C31EB0
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-Add-a-C-unit-test.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-Add-a-C-unit-test.patch"

From 0b896d7bf992caadde8f0c4d57478800b2261507 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 27 Jun 2020 09:09:59 -0700
Subject: [PATCH liburing 2/2] Add a C++ unit test

Since the liburing header files support C++ compilers, add a C++ unit test.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 test/Makefile       |  9 +++++++--
 test/sq-full-cpp.cc | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 2 deletions(-)
 create mode 100644 test/sq-full-cpp.cc

diff --git a/test/Makefile b/test/Makefile
index e103296fabdd..8b81d2d5f67c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -10,7 +10,8 @@ override CFLAGS += -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare\
 	-I../src/include/ -include ../config-host.h
 
 all_targets += poll poll-cancel ring-leak fsync io_uring_setup io_uring_register \
-	       io_uring_enter nop sq-full cq-full 35fa71a030ca-test \
+	       io_uring_enter nop sq-full sq-full-cpp cq-full \
+		35fa71a030ca-test \
 		917257daa0fe-test b19062a56726-test eeed8b54e0df-test link \
 		send_recvmsg a4c0b3decb33-test 500f9fbadef8-test timeout \
 		sq-space_left stdout cq-ready cq-peek-batch file-register \
@@ -41,8 +42,12 @@ all: $(all_targets)
 %: %.c
 	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ $< -luring $(XCFLAGS)
 
+%: %.cc
+	$(QUIET_CC)$(CXX) $(CFLAGS) -o $@ $< -luring $(XCFLAGS)
+
 test_srcs := poll.c poll-cancel.c ring-leak.c fsync.c io_uring_setup.c \
-	io_uring_register.c io_uring_enter.c nop.c sq-full.c cq-full.c \
+	io_uring_register.c io_uring_enter.c nop.c sq-full.c sq-full-cpp.cc \
+	cq-full.c \
 	35fa71a030ca-test.c 917257daa0fe-test.c b19062a56726-test.c \
 	eeed8b54e0df-test.c link.c send_recvmsg.c a4c0b3decb33-test.c \
 	500f9fbadef8-test.c timeout.c sq-space_left.c stdout.c cq-ready.c\
diff --git a/test/sq-full-cpp.cc b/test/sq-full-cpp.cc
new file mode 100644
index 000000000000..ba400996e615
--- /dev/null
+++ b/test/sq-full-cpp.cc
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test SQ queue full condition
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+
+int main(int argc, char *argv[])
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int ret, i;
+
+	if (argc > 1)
+		return 0;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+
+	}
+
+	i = 0;
+	while ((sqe = io_uring_get_sqe(&ring)) != NULL)
+		i++;
+
+	if (i != 8) {
+		fprintf(stderr, "Got %d SQEs, wanted 8\n", i);
+		goto err;
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+err:
+	io_uring_queue_exit(&ring);
+	return 1;
+}

--------------D425848F4E66FE4301C31EB0--
