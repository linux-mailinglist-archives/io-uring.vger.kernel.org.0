Return-Path: <io-uring+bounces-2827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52105955E9C
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 20:55:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7774B1C20C8C
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 18:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E646B14EC5B;
	Sun, 18 Aug 2024 18:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Crkih9gn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DD2145A07
	for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724007332; cv=none; b=QDw39t8O/HIS0OczInQ8JohFEiBzfFq/i/4w+QTUybg/v649hgTO1DGk+JiLkpydGF266+JnXBbhvmiwj0Gu0zDeBYa2Pz+u/C4CweUPFz9IKrax2CbjCRuzwPUERCx718Be0EP3eFMgWinKG/Q9cmkI3atLtWXdycMK9+lSr1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724007332; c=relaxed/simple;
	bh=EQ1cVTgvrS1yxyAPhs3J+3/SaP+QHDOB/vB1YXhhe4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3S5i13YDlLG1WJzprM9G6MsEN0FXvjUsuIbiUWGaf6h8HQ6Ru0VU0vu8O56mlpQQUkxxIGXW3IkWamxLcvVYa7bh7EUAudx6zOdWR+FixOqhASmtUI3qHd0ytXY75bMyq4VOnq/WlK9IGfTb859QxlkDo7s9JguTzLfNsBhLzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Crkih9gn; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f0dfdc9e16so42878011fa.2
        for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 11:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724007329; x=1724612129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4sCPII+pcoa6DUxzxkE+8aJquhC6c6yaoUGcQMg4OE=;
        b=Crkih9gnp1vk1DieMOUrY0W11d3JqQjulxwMooJ7j6g5jxjZ9bqYqlLb0L2MQM8lAz
         zzr6qoUma0JssmhdUJqMI/sqcBSd629VgGEsjAQWbVWlf4m+EYzTRSbMMhx/dB2q7ahf
         UxcQVe2U75Z3W2kNUXdIZf7XTRNttYZWnbroQc4r4b57qcJTIl8/R5osq5sK+c7klvBD
         rgu+NoSfYCjpfogIqAHo9r0nfZTaOh/yu2QkWQ0yvPil15VP0+16rOuGoSYWrX0KrD6l
         TrhhJ/hHANaC9wg7syWQj03wYXvbzK76eM0dspouSpHlfudIrYHauZ/7tEBf28LNLqgX
         k8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724007329; x=1724612129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4sCPII+pcoa6DUxzxkE+8aJquhC6c6yaoUGcQMg4OE=;
        b=wr1OknaIkDYGgG2ZgaH+HWSurMAa84bUUpHISvuxVnHqC4z+UFyBpM+jlhAMsXOHK/
         Tl1PgqSo1J64OZu5iVUsfbjsMIdVWvfQIEsr02Xn1e+WyPSSZOZr59CXmJOwARnjw0Hc
         /sJatNVMmmefX+XpTNGx3drqgd58fqmRGDkPuazCEXZd1vP0FNQegUK4GcdeIgG4XugK
         Jurt3oXH+uIKYTfqnp7wYZakD/p/o+XwFv0s9e7L9PtAy9mx3KnoFSeNyw3Q8uRjpCYC
         9dkfto/egWnp0lzgCyKQ5avce31PEFfw/C2nR+jur7SGjDczNAiRbkoc+CcNpvVUmDye
         UJEw==
X-Gm-Message-State: AOJu0YyYK7hXPzGHyVCS8cwwzIXPXh7gwB2/7uAtvRSQ1Af2K18SwEtX
	SNzzhCfftb6HBYxt6LVXwo0uqtvZ1CerpHDSmLd1gykeweOV76DjVfA9OA==
X-Google-Smtp-Source: AGHT+IF5C4MSeAsF30EQjEuT+9sf551D6Xp2Vyc9WtmjSYXKPXV82k5w2jialAxZCSKIq+t4tKkcJw==
X-Received: by 2002:a2e:b04a:0:b0:2f3:b74b:fbec with SMTP id 38308e7fff4ca-2f3c8ed6dccmr32393291fa.20.1724007328336;
        Sun, 18 Aug 2024 11:55:28 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.74])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbbe274asm4867959a12.8.2024.08.18.11.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 11:55:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 4/4] man: document clock id and IORING_ENTER_ABS_TIMER
Date: Sun, 18 Aug 2024 19:55:44 +0100
Message-ID: <24844efb9ef46691fa15a1da5198aaae3f759d1c.1724007045.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1724007045.git.asml.silence@gmail.com>
References: <cover.1724007045.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_enter.2    | 12 ++++++++++++
 man/io_uring_register.2 | 20 ++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 5e4121b..8c79771 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -105,6 +105,18 @@ then setting this flag will tell the kernel that the
 .I ring_fd
 passed in is the registered ring offset rather than a normal file descriptor.
 
+.TP
+.B IORING_ENTER_ABS_TIMER
+
+When this flag is set, the timeout argument passed in
+.I struct io_uring_getevents_arg
+will be interpreted as an absolute
+time of the registered clock (see
+.B IORING_REGISTER_CLOCK
+) until which the waiting should end.
+
+Available since 6.12
+
 .PP
 .PP
 If the io_uring instance was configured for polling, by specifying
diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index 4590588..c8521b7 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -720,6 +720,26 @@ The application must have registered a file table first.
 
 Available since 6.0.
 
+.TP
+.B IORING_REGISTER_CLOCK
+Specifies which clock id io_uring will use for timers while waiting for
+completion events with
+.B IORING_ENTER_GETEVENTS.
+It's only effective if the timeout argument in
+.I struct io_uring_getevents_arg
+is passed, ignored otherwise.
+When used in conjunction with
+.B IORING_ENTER_ABS_TIMER,
+interprets the timeout argument as absolute time of the specified clock.
+
+The default clock is
+.B CLOCK_MONOTONIC.
+
+Available since 6.12 and supports
+.B CLOCK_MONOTONIC
+and
+.B CLOCK_BOOTTIME.
+
 .SH RETURN VALUE
 
 On success,
-- 
2.45.2


