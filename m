Return-Path: <io-uring+bounces-7751-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 69DC0A9F16A
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 14:52:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9482A7AD764
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 12:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A121C264FB0;
	Mon, 28 Apr 2025 12:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lJH/4wY/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54E3266B67
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 12:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745844705; cv=none; b=TuXfO4Ah6OLu425tBa5MaiTUm/Upglrol+ht+gM5Oe6syshic4zrXYy6oetJ+wVFZj05KyToB9SsU2XVx95o8Jlv34Tmq2jAQ7sAkZxQHw2CkYy5hZ5uYjLdYlEi7qrTloZASvpoUWMhWDReugz1S4XGtOqrscXNVpYcu04r/rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745844705; c=relaxed/simple;
	bh=TQk/X56ot1sTjRcejKGbtupNrYvX/PICfIti8xLwuZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZASrNODTxVMzr4F/MjFyqrd/CGKPvQ/fcLrs9W2eFgI5JEsK7w2PjXHF3uHTMzRDSOKke4c3JRQsBWJyl9zHekoyU7PGNUXHBOSoiUhSi4x0NeXSxu8/OK0Ns5l9qOAT1tNSeWWNSP/Wewc6lGv0zlSSvsbVuV8iQiVECj70q3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lJH/4wY/; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e5e63162a0so7255830a12.3
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 05:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745844701; x=1746449501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EtvVj/zBSqZbY1iZh17a1VnRFoT399eaRrcfUI0ncmo=;
        b=lJH/4wY/nhGKn8pqYQJ6AjnGyGvrB3fZUzhGvGrtmIQfqUiNsry8UunJPJKvhOUPRs
         CVp1dD0pwagLQlMN57jEMwoHB2Hs3cISJej1lWmESYFNGf4gv/sXHYZsy98C2JgWJIps
         00ifMVUlOM9FSUH6YG3MEjDV8dyXbcdFclkZ1tZQkyiEXNcDB583uBwPCOSbDg8RHp5r
         rx6dloVmAdN7bLWHC9W5oG9VOk4SSbKZtrSQ5mM0tQ9j1d3D0FnscPWY6sn3Q43N+eJN
         wdG65e950G6cYcwEI3RI/ma/npAx6q8IVLAAb1G7hNVfHnUc6O0jjQSBNpYTWL3Ngbuh
         y3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745844701; x=1746449501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EtvVj/zBSqZbY1iZh17a1VnRFoT399eaRrcfUI0ncmo=;
        b=XtwE+MFWhViL0t1NceJLZoIcAmZIwWY7H2ZlyyWJJBKZR19NPnflOmso72EM7DuJAr
         j5RBvM+EE3qMmJ6SqALAolpGK5mcMPB56rqFt9pB7fSEphVMfdoQURxBo/Wn8mkZ0BaP
         X93muVWggUQWcGTw76r4KnHB1pLgHEcpihEZDL2Bu+hghEaT0CkiY7NBo+HnRsgVrT8+
         QAnYE+CKpjYw97UY4izd/nQpFEQFdsCQ4dHMBA68oCKICWQyh7wH1/59TIxuxlCvXVwH
         FUF/UjlxRxg8MLwQe7KoLqeo4Cr03SJKmL4rkuSET++O0RuUYH31ETf8CJd0H3Uf9No7
         Hetg==
X-Gm-Message-State: AOJu0YyBG6PK3Okjcll7khkgtyv5h9Tquj1C5AUcQiSVwY6yDZnstspr
	qXntIlcRSSFOfwrdqVWH6pxkH7pf88UKppDIavH1zMn9TyeZiesCko7K9A==
X-Gm-Gg: ASbGncvK3Ny7KwXdIh5cdVodRyiTmYI+59ZhVzKHuhssfOoXN3sbxXo6Ow5WYuG2Qk2
	MKpOq7Xv19admaGgSeNiBwYPbkqySi6huUwoFwBV/CFgFD/4Y7bnpo19+Y7EvjIoqPHQNPwgAEv
	UPJ0CnWIJBVh/Iqttj4pTdUm74ZcQfu4Ehjco7IRWaHhlINw/B0tXO04eSNfzy5Z/AKrvvSiJXk
	Ub8KsLG6raQK8mj8fV0VBT25WNxwpzWKjlxG3z6+vLCRqmzi38QmaaWl3JYhmDNXE/1ECzqeFad
	wjls+3sK5LNyuaIMC9e+LOqL
X-Google-Smtp-Source: AGHT+IEk0+0JX4mGBXVLunL2FG7dL/Z/Jq6m/iyPMBVb+nrwELsZX8FrmEwAIIzW+3UgIzY+uVj8jg==
X-Received: by 2002:a17:906:c10e:b0:ac7:9835:995 with SMTP id a640c23a62f3a-ace739dce11mr1105317366b.5.1745844701287;
        Mon, 28 Apr 2025 05:51:41 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c92c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e58673dsm613010766b.76.2025.04.28.05.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 05:51:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH RFC 0/7] tx timestamp io_uring commands
Date: Mon, 28 Apr 2025 13:52:31 +0100
Message-ID: <cover.1745843119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Vadim expressed interest in having an io_uring API for tx timestamping,
and the series implements a rough prototype to support that. It
introduces a new socket command, which works in a multishot polling
mode, i.e. it polls the socket and posts CQEs when a timestamp arrives.
It reuses most of the bits on the networking side by grabbing timestamp
skbs from the socket's error queue.

The ABI and net bits like skb parsing will need to be discussed and
ironed before posting a non-RFC version.

Pavel Begunkov (7):
  io_uring: delete misleading comment in io_fill_cqe_aux()
  io_uring/cmd: move net cmd into a separate file
  net: timestamp: add helper returning skb's tx tstamp
  io_uring/poll: introduce io_arm_apoll()
  io_uring/cmd: allow multishot polled commands
  io_uring: add mshot helper for posting CQE32
  io_uring/cmd: add tx timestamping cmd support

 include/net/sock.h            |   3 +
 include/uapi/linux/io_uring.h |   6 ++
 io_uring/Makefile             |   1 +
 io_uring/cmd_net.c            | 177 ++++++++++++++++++++++++++++++++++
 io_uring/io_uring.c           |  46 ++++++++-
 io_uring/io_uring.h           |   1 +
 io_uring/poll.c               |  43 +++++----
 io_uring/poll.h               |   1 +
 io_uring/uring_cmd.c          |  97 +++++--------------
 io_uring/uring_cmd.h          |   7 ++
 net/socket.c                  |  32 ++++++
 11 files changed, 319 insertions(+), 95 deletions(-)
 create mode 100644 io_uring/cmd_net.c

-- 
2.48.1


