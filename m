Return-Path: <io-uring+bounces-9631-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44968B48127
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 01:02:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04B723AAD3A
	for <lists+io-uring@lfdr.de>; Sun,  7 Sep 2025 23:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD76B190477;
	Sun,  7 Sep 2025 23:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bB/c+DLt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA2F315D25
	for <io-uring@vger.kernel.org>; Sun,  7 Sep 2025 23:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757286125; cv=none; b=ZK6tOG681xovPzrnaPnky7KEl5PQuQ2BsODcCVduwSFFEY/cRiXt1Td8Qoh8IdKXAWDjgPSj0GFg/3+Q7fNv0of+EqI/HGgQvuey9x19yGPaAi6gSl1TYnhHGRTiE8I/5GvMLWuwkJegJkbS0WdTGVrKyNqIFWOQTsHZJPPQiBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757286125; c=relaxed/simple;
	bh=nIp5J646Qf7GzmM2akhbdFKzP5/TDDCmVKu1RqYrqo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qv0Tdh3CF/gLC1gvhJLDjaytRdErexW58NNqyuF11lq2MJbzwzszUScOynCu5BRe3z1607GvNx4E2NUfJrMbr7ITqnu8zbVLJ8joT7BelXFCuAc8nYbW/FtJ+XXQfmkowfEmIS4aNnu7y+tIK1l8DjKtieTnt45rRP+q50b3P7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bB/c+DLt; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-62757f4a2ddso1092098a12.0
        for <io-uring@vger.kernel.org>; Sun, 07 Sep 2025 16:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757286121; x=1757890921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FbQ9L5keIGmJBX0zdRauDitwLEOGXg4k/cmNpDKZPP4=;
        b=bB/c+DLttSzdmBLtBwCyGFQvFk0c+st9Xt8pxXeAsvrTBcKpMrx8/4wPjJ57Pcs+Y+
         L7BjpPQU58kB6iaBJ3SbGZKdbuiP+GbJaoKdnPuLR4ZhI9nKAv3WwM18WawnA4yM1zBB
         puF2CCBMwJoXZp+WI6j4Y20b4wDVBCgcQKyIy/6bfRU/uWmz5PS4FC8M2RilUzJKzjrI
         h+zyAkWd6c6sc1HRKfAUYO99PhSyp/Zkb2O17ihCZe5VnNMPy7T1DFAVdWabhGG4Y2uN
         DqulEIGo8u+D3y4Jv5/ShS6q947JFvcGQTQ1gICa7XiXaseHqLdVHMOsI5iKrTzOUwUq
         oNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757286121; x=1757890921;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FbQ9L5keIGmJBX0zdRauDitwLEOGXg4k/cmNpDKZPP4=;
        b=MuXwWHDe1mbYjTMaeL7FAnciTzp+6G+IiqMv9oNE2DCVo83iLBIrMDKihh7EWY3TDX
         nCtB9V9LXcDaxDZgMIzA1EgIeDIcZxjrM7cJ9jtRjjEHhIibxf2B7CeaD185ZkiwltJD
         cpRBSID4+PWq/Nhy7tWJ0TVXtVM4UB1b52W+DyLIiST8O8yVhhrrBz45/pL8p5SPnrKb
         qfobK8B+qbStGwP3a0vaNA4eHk5hAo+GLeQ1QJ1y5dvo9XL39mWAKdQW8qXrxprAINTK
         4dNJB52ZFv8l18rggiYQbE+m156fkUBZsRWSdDk77hBzjdTa8ZaaOdIkBwz0zPo40ZUj
         7rWA==
X-Gm-Message-State: AOJu0YyceVUN2FUXFRKjP2p/Co5U0C82UbTM6rHhk3I7sCrPpce99YBW
	ZhUiMlE+0wwOqpszKYK2eIPS4DU6raKGdEZZneUWZm+/TskdLx7PqagKE5zSRg==
X-Gm-Gg: ASbGncsoBAhQAuOhgv5/lWesl/4W4WjvRBDICseChxlrfHikhgL+LVmT0mQ01ovd3Q5
	b6mhRM7PPdDfH0sm6lJlnsu/HovOx63Cs4lDUgg2Ta3ttfMnv30e0mtFtw0dlXepH31AIfylt4Y
	55dWFeM+T5QZDnBjZUBda7Sx8bF8NDuF04iSFCrpDo5U5yTVLZ7m4QilACnFcaUdkDxrPnUC1Fy
	skW3mvWqGqRoT0ESX4pyh0EUW4895n1d13ncAsNL2I8P13N5St/dcbBOWhVtuP/M62YWxbb3anK
	E2I+CBD2dCcvAxSW9l8Xq2C+NzbnM1/b6ewDP3nVvyzyywL9sm9itCmxZsTjqrA0qKwLjac6jEC
	ChyeqCy7AxjphAQ0gA0TUiJA3O+QpN+MJhfrPNFrcQB4bZiA=
X-Google-Smtp-Source: AGHT+IEbjHtEtcGzybh2DLAjOVVlNInIQY0FmD0Wh86Wl6i1nxUL/Pl9J3tkY3Nx95K5Z4DDTaBJSg==
X-Received: by 2002:a05:6402:1ed6:b0:61d:3d89:7825 with SMTP id 4fb4d7f45d1cf-6237826e202mr6039047a12.34.1757286120624;
        Sun, 07 Sep 2025 16:02:00 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.138])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-625ef80347asm3363570a12.1.2025.09.07.16.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 16:01:59 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 0/3] introduce io_uring querying
Date: Mon,  8 Sep 2025 00:02:57 +0100
Message-ID: <cover.1757286089.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a versatile interface to query auxilary io_uring parameters.
It will be used to close a couple of API gaps, but in this series can
only tell what request and register opcodes, features and setup flags
are available. It'll replace IORING_REGISTER_PROBE  but with a much
more convenient interface. Patch 3 for API description.

Can be tested with:

https://github.com/isilence/liburing.git io_uring/query-v2

v3: - Rebase
    - Add review tags
    - Remove copyright notice
v2: - Add enter and sqe flags to IO_URING_QUERY_OPCODES
    - Zero unused parts of user structures (beyond returned hdr.size).
    - Don't colocate hdr and and query specific info. The header now points
      to it via query_data.

Pavel Begunkov (3):
  io_uring: add helper for *REGISTER_SEND_MSG_RING
  io_uring: add macros for avaliable flags
  io_uring: introduce io_uring querying

 include/uapi/linux/io_uring.h       |  3 +
 include/uapi/linux/io_uring/query.h | 41 +++++++++++++
 io_uring/Makefile                   |  2 +-
 io_uring/io_uring.c                 | 32 +---------
 io_uring/io_uring.h                 | 57 ++++++++++++++++++
 io_uring/query.c                    | 93 +++++++++++++++++++++++++++++
 io_uring/query.h                    |  9 +++
 io_uring/register.c                 | 39 +++++++-----
 8 files changed, 232 insertions(+), 44 deletions(-)
 create mode 100644 include/uapi/linux/io_uring/query.h
 create mode 100644 io_uring/query.c
 create mode 100644 io_uring/query.h

-- 
2.49.0


