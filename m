Return-Path: <io-uring+bounces-8651-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3417BB0282B
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 02:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51BBF5870C8
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 00:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2361FB3;
	Sat, 12 Jul 2025 00:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="v8VUc+nn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42546211F
	for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 00:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752278634; cv=none; b=FpBx1lxl70z3EPmsHt4RCJjsi/uKqBnFJxkRfXPmsD5snhL42ANdRfFOIO9KfUVX8zsZ5LCZU2VBDjfI1UOK9Uxb3WQY8cv68lnXk07Wn3+s2i+fRklbmnGaGC8FF0ErI1arciPbxUImY4zbB58bRR6a6JQovDbDPlxkWT3p0lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752278634; c=relaxed/simple;
	bh=Lt3HBl4gbykylAbbxsnqoWpY+oUglvR6LUVxFilBHR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fs2kxjb2PRIKiAzxZaqxSYaZmCPokvzu9SIJx5M6Jsyn65+Cfp33Dj5Zw9ApYE4j3hCxNnHXvlNx5nNthjWFdZ4KOW6m8L9CtSceAsX4BKzL0P/n1nywoX7b0dsc0z7UMLjBliYgamhN/eAcvi/Wr7+yv+4ku+Jzc73Z227VjQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=v8VUc+nn; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-8733548c627so95258439f.3
        for <io-uring@vger.kernel.org>; Fri, 11 Jul 2025 17:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752278630; x=1752883430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDBhjPJAT24egfzh49AuQarxKTVGhHR40jZy0R4STcQ=;
        b=v8VUc+nnbee5YtyWCBsxgoLHPkeD8HskNAu8hSUCgthggYhGj2kEED1EntPO3inxHH
         q5Z7qtY7iPgiCf8gpUOk/LIVOc2xmn88kE0j9zQ93R4VygRJ0b7oDEQi41tKTNCtR2Uy
         I33/hTQqemNgqFAN49afDl2GEqAL7kH06i43JepAf1VJc67v0fzJ0ml6/jQRD4NSVCqc
         13BXNpwfHQyTnZhdinUG0J0xcSmnaW/7pfEN2bY5+g5ECExXMKMucXcjs1RuwXKuYG7Z
         OLnSjPnij3WFzz9SBsK673Stq6I5Ccba7g87kF6HiTqgMyklxJyF5Zi3dMh8BWOLM/hB
         WoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752278630; x=1752883430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YDBhjPJAT24egfzh49AuQarxKTVGhHR40jZy0R4STcQ=;
        b=EUUqVqL0T6psAKuNraV5JacB1TTbkHeehxT569lFQRFe4si6b3n+XJRGE4v2F3Ek8K
         /8MfTPQGxcOFA/b3MR0gO6/tTgjmLGx+E44JvSzl0iJZtbYlc0Gxb1YvdksjGaFfp/uM
         zibnoQGw7GwTdZtJfzmle413FOFbw/LRUvabUH3bQsA3kYckfp7ywhcwr4sGBjypgQWQ
         JGSIXJnuBOmb8fhJy26OiZvWdaQ28O1qC0EnKWwAXx+bjEm4UWd+nAYuLBw3Fjhii33G
         /RW12SFPbiDG7WWWWwCo17MLCFga/KNLCIFlwV4OaR6R8KfRmvwaT0MM/k+dE8Z7HYCa
         +arQ==
X-Gm-Message-State: AOJu0Yw2SfsEh3xW65ZBeTnzZc0YRYOCd+hP2L+uH/KA/97ZN6KwHKtF
	99stzv2FZQ8yQtTwfN8j5ZQhpSj+8NqR0yy889ri9jADiBeolfEmLxN6j8IO2KdYuHNZ8tIWY+5
	Cfuo0
X-Gm-Gg: ASbGnctsPVQx9M8OM9knnvOfrVTL3HiYa9A48rE5qbgVKYZBGgMt7sH48sHn+35yWRY
	mg4Ix8gQNxNf1vb9FIVG1i70F3LGONtAz506X4QAAN5W/Stv+TARez6Kh2OOseM1Vupdfyvuo8I
	YDTmW/+9rb8+W15SxbBiIBjcDseVeQc6WicgHPNLcIXtM/Tl9WxxivmEyBbJ8QglaE0Mi+QHMyL
	ccfFAdI2/HUrOg2kG/xmyOCnSvddduUfa4m1UsfIE/wpO+YE/dk76g8UjQqKpqocMJzSk0x98x6
	b9sS6OX4sg6hArEEpPv5A60OffhdXk+TZ1kY38/mzYJxsTkHf1yxBef/kWzM+c2oB6pNRHZjWKS
	vp7PW94v0wzgAOz/s
X-Google-Smtp-Source: AGHT+IERrFf8UKXR8Da4c0Ve9QfoohL+HhlMxl0mtlv92FjEbBR/hvHhyePRx/0hro5cLKvycYeVTg==
X-Received: by 2002:a05:6602:380d:b0:85d:b054:6eb9 with SMTP id ca18e2360f4ac-87977ff3c65mr684574939f.14.1752278630582;
        Fri, 11 Jul 2025 17:03:50 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc12eb9sm129810439f.24.2025.07.11.17.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 17:03:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/poll: flag request as having gone through poll wake machinery
Date: Fri, 11 Jul 2025 17:59:24 -0600
Message-ID: <20250712000344.1579663-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250712000344.1579663-1-axboe@kernel.dk>
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes in this patch, just in preparation for being able
to flag completions as having completed via being triggered from poll.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 3 +++
 io_uring/poll.c                | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 80a178f3d896..b56fe2247077 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -505,6 +505,7 @@ enum {
 	REQ_F_HAS_METADATA_BIT,
 	REQ_F_IMPORT_BUFFER_BIT,
 	REQ_F_SQE_COPIED_BIT,
+	REQ_F_POLL_WAKE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -596,6 +597,8 @@ enum {
 	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
 	/* ->sqe_copy() has been called, if necessary */
 	REQ_F_SQE_COPIED	= IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
+	/* request went through poll wakeup machinery */
+	REQ_F_POLL_WAKE		= IO_REQ_FLAG(REQ_F_POLL_WAKE_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index c7e9fb34563d..e1950b744f3b 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -423,6 +423,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			else
 				req->flags &= ~REQ_F_SINGLE_POLL;
 		}
+		req->flags |= REQ_F_POLL_WAKE;
 		__io_poll_execute(req, mask);
 	}
 	return 1;
-- 
2.50.0


