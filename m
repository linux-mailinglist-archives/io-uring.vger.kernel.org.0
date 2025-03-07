Return-Path: <io-uring+bounces-6982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A2CA56C86
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:48:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B6F07A8EE1
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70ED221D3CC;
	Fri,  7 Mar 2025 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ty7DdBb2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81F6DF71
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362493; cv=none; b=OWdqpPz7fXzkZHHpRi7GX4B1c2BpbldfZV+fkSYVopaXq8OYKShLluZkizlPEu8s2cFsvp1r4OlwY6d4yfQ78C79hlnmF9n86kCxJ6OqS0KjSoadx5CPZqwaa/iM6SnVEPrCtfmvqyCFRzk0ujhu5jehJkqL4u7+jo76Zq4UZuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362493; c=relaxed/simple;
	bh=mgexz3d3FwYsvXFN4YR89OOn/QPCDv67VZ7OrdhMNxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eWNH+rzCD5LCXfLZ1/38dOrOvLWC5kx/5JuSOrVPcfIGrN7bHnT+lMs8Pw2KbMRqe/Mhbabsam+sokOL+yDJtwq2Pq/iyAWAThbarBNj1iZIjjKIbZ8cCgcGcdbSj/Cg2jsYRnlwE6dIa6nnm/6SjocvblCRSgyEeDVeGN5wqMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ty7DdBb2; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5dccaaca646so4066007a12.0
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741362489; x=1741967289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aqDF2QPnoNKfvfNL/OMVYQd2pAAds4QILnJFzvYuYzA=;
        b=Ty7DdBb2sfnionu7OrlGih6JSFX1Y4SMPHvtKzjKRhtAr4XvSDEMqTjG+AHl9DH1zC
         o4d5rfGYE1y6EgCZ5q9C2qV+uJ9htJ2W7ee6Tw4jTDSaAbP2hUGE5b0Kwu6HwnA9NAEb
         tZLQw+OUkP/FJ7nOdLqxZFYDHr4AwbfE/XxwYeo+NWvKREeYnjv3EQ7KyMXnU6FDOJPK
         QafMget6hxzNylafYtQ8UZb5zm23Xc0TkVKHQ78c3aFWBTaBJYuDIL4PMIZejqvJulup
         cLxZba4PbQUU9KCByXkhPIVm7xv8GOFh/2q6FGD1DccyMnIww9Oox4djEkTiiTP34aVw
         wriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362489; x=1741967289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aqDF2QPnoNKfvfNL/OMVYQd2pAAds4QILnJFzvYuYzA=;
        b=SfSIXtXrg4MEZbHXRoyjngVaNwR1RduRDlpVLl6gGSlW++P5ucz5i3/vuOFTkxkyJ5
         p4Jy4z0snl7//UrgALOhP9Uwi4N4bs49K/YhoqH7ZVFiuf86+QztttBngGjuMQxjqYN+
         sycKbA/lnqZUg/44AQx5Jsr06KucRtmv9CPIg50qoXMjWnbosDDguLUCoylLaGFRFp9R
         C9FuFgaPqr9IqrpCRyTJmru3opRRK9cka5HG3S47CBwp3ntEgCCLylIa10SSw2zTtgBm
         VBOdpujy2IWs29wX4pAR1d42ejZg9BuxMNBwcbQYRAtp5YNl4jyZREjHBvR8cdYaKsyy
         DN3w==
X-Gm-Message-State: AOJu0YzK8Pr3NPVByAgy+21vgwDAa+tdRerZo7/Y2UDZWm5msMsay7Kx
	UI2WUr3EAiGOB93tfNORAXtEreXaU1KLIWZf9P0mk3tiSnc+sHrxiIhNlw==
X-Gm-Gg: ASbGncuciAHBLrpea7keV0rrVei6mkDA7B1LjK2SK80QehLeFGErdQ5bGorYrNg8mhQ
	N1A+YVLuG/FGkfIpVOmo6kgF0O1+VC2MazQUmb2ZjCsLyE2c+kuvEF7ojl7k2Z3yRCDyj9oJtX1
	aBVdElGUIB2hLyTkUzd7FDeJSCKDGH5ozZ5MNhrsKGIeiotRiB0iWrC5tBTgInAcEjVckqQfBUL
	OgBqcYS4duDyHQTFTUi/2GHUfAsoelfnop9yUHbLhRRXrMcmHQOsMVbdSFtNeaB1m6eDeKN4cf4
	LGiHpCe2kVpwdyZ7Z0DB0tdSe/Rj
X-Google-Smtp-Source: AGHT+IHIBBB7c4GuLz1AbEB0L98kQ1fSsLdm0agX06z7E+YfbiRFkRkRKonOXe57en2+19ExTGiJ1Q==
X-Received: by 2002:a05:6402:34d6:b0:5e0:8a34:3b5c with SMTP id 4fb4d7f45d1cf-5e614d92d51mr78073a12.0.1741362489304;
        Fri, 07 Mar 2025 07:48:09 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2665591a12.56.2025.03.07.07.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:48:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 0/9] Add support for vectored registered buffers
Date: Fri,  7 Mar 2025 15:49:01 +0000
Message-ID: <cover.1741361926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add registered buffer support for vectored io_uring operations. That
allows to pass an iovec, all entries of which must belong to and
point into the same registered buffer specified by sqe->buf_index.

The series covers zerocopy sendmsg and reads / writes. Reads and
writes are implemented as new opcodes, while zerocopy sendmsg
reuses IORING_RECVSEND_FIXED_BUF for the api.

Results are aligned to what one would expect from registered buffers:

t/io_uring + nullblk, single segment 16K:
  34 -> 46 GiB/s
examples/send-zerocopy.c default send size (64KB):
  82558 -> 123855 MB/s

The series is placed on top of 6.15 + zcrx + epoll.

v3:
    Handle 32 bit where bvec is larger than iovec
v2:
    Nowarn alloc
    Cap bvec caching
    Check length overflow
    Reject 0 len segments
    Check op direction
    Other minor changes

Pavel Begunkov (9):
  io_uring: introduce struct iou_vec
  io_uring: add infra for importing vectored reg buffers
  io_uring/rw: implement vectored registered rw
  io_uring/rw: defer reg buf vec import
  io_uring/net: combine msghdr copy
  io_uring/net: pull vec alloc out of msghdr import
  io_uring/net: convert to struct iou_vec
  io_uring/net: implement vectored reg bufs for zctx
  io_uring: cap cached iovec/bvec size

 include/linux/io_uring_types.h |  11 ++
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/alloc_cache.h         |   9 --
 io_uring/net.c                 | 180 +++++++++++++++++++++------------
 io_uring/net.h                 |   6 +-
 io_uring/opdef.c               |  39 +++++++
 io_uring/rsrc.c                | 137 +++++++++++++++++++++++++
 io_uring/rsrc.h                |  24 +++++
 io_uring/rw.c                  |  99 ++++++++++++++++--
 io_uring/rw.h                  |   6 +-
 10 files changed, 421 insertions(+), 92 deletions(-)

-- 
2.48.1


