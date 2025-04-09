Return-Path: <io-uring+bounces-7438-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E42A8266A
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 15:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 972CA178DAA
	for <lists+io-uring@lfdr.de>; Wed,  9 Apr 2025 13:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3825825FA04;
	Wed,  9 Apr 2025 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zH6QNngT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CFC158218
	for <io-uring@vger.kernel.org>; Wed,  9 Apr 2025 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744206065; cv=none; b=lbrzOmPe6fKKZLjGcwq0v3ZWEqmTPk4S8c3DHb5bZM4pMF7zd7Qyzgw6WmsDsq8B1RGBsyQNtE0Ua6tjRGwLuj2EcruvenMktd/RMbqB8gkuNx9VFaYKfAVQsLe8kH5UJB1HsYfDuhe9sJWSnqFLcLFntzuQCaeMdgs0ULQ/dQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744206065; c=relaxed/simple;
	bh=ToxSAHnav8JY+Fex5fVqXHAbu6f1gtbrYxB5uaOi1CE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OrOGVopuOrfxR+ZupOBVQ3OAbObNLdll0CTatjsFd84CYcKVZBckbXvsh0E/Aed7nOz6z+038a7UpQEr/iIqW8jSFQ4yxw6M+S5Y9Fc4qCzIsIY9UQDxN2xAWBKR48pSG/NKfcSW2KcZ02xI+MayxnuBk9YPjKGvhSm7FWg1cm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zH6QNngT; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-85e1b1f08a5so154526439f.2
        for <io-uring@vger.kernel.org>; Wed, 09 Apr 2025 06:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744206060; x=1744810860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LjRmHokXKtGq8jY3ta25MzQozdS/ikE4p/OHgY5w8d0=;
        b=zH6QNngTxEFXOL4tQ0KXaoSjS1PJh26TTyiDljtJ6hrivav3sazGBPAb/914gdPo9k
         QTeS5RVyMRWlW9yGR71l2XC2UvoFE/qCDhV/Df0F0K28VTcAC7LyFq6pnOjDO6v1HrJr
         BzdTyGX1J7TH3VQ+/wZ4ugEYsKlqS4d2b2mV3BpOxcFt0tCVBcglYjKzPxmqK+tHvB2c
         6DQ3Yso7ct4wWr83ClXScKJJi191tOKqdPxiGg0mvTzgQMa6uVKmc8Bhpd4kfE5+NVwL
         9d12X2Ga0iR1UnpQ7QUw3VnB5mLtCSweCpdz5pZIi6Lqxfp5Lh0xJHv3wb5temvtLxDi
         4Eww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744206060; x=1744810860;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LjRmHokXKtGq8jY3ta25MzQozdS/ikE4p/OHgY5w8d0=;
        b=IxDRkRdCoAADWVdoIGDyVu20GG4SlewmIVAFM5XMhksbGz6QSxGDXcTh1i4q0BuVB8
         S8IAzXSLWqzZBRBrSjL5yVC63xJ6dWvl+APTkkcY09ahqHYMcEEv53xmAkSrusGjat5o
         tv3ag4hTY5epVYSMdo1hZK0iI9pPTcKc19qPdITrEOgoOP4Mqtpy2BQ1jMenuLa1owhS
         T/E+QA/olvgPIoZDAWoe73P65WbjK+oR6Q8c3YcvWASbhdya7ubtARZmrBjWHcrWC2g0
         irDl2IdQEBGN1jqIBuBl5F92KejOXR0Wyr7uS8I2C3splSaZ11ZDuDJP9Xf/GnbyBLh6
         Z+Jw==
X-Gm-Message-State: AOJu0YzLk+fMqOeF8OWoa7Sxb/03yujM07pC7DGo/f2+MHrpA2k+HHZu
	jhZ2RG5dNBeAzlJjivC/xu+IAjWuZ9GbdgTqFRlEvUMgHpGOMqYtkAIC7Tj+iLU4xMCWaAdJ3sG
	Q
X-Gm-Gg: ASbGnctVhux9E4d6fz80TGyzeI9L94F262OlBfmhqkVRtGE1yu/FBgzq50ch1tXHF+F
	f6IZoWNyaE2v6oBJACV3/Q3An4yT9wBd6zLFacp1gWaUy6Q12SLWhOVX0GpDKxIbi7E0jfr7sUh
	ZLFPyX3ohIXN2BMnRc8/HM/tYMoEZCsCUBAemViUdWXKiodCFoCapOxuc2kYxecPYismQ25pOpO
	fH4jEINTR/pPW27bBSGXPyCXjSj7ab0u8+ua8CEUIcqQ2aGP7c7a3KuQrwl6kb244F/sJNGK/L6
	hy9tQKH9pl6OgskizzFp/ApfQnGm4FskYzpPYOabwBMd
X-Google-Smtp-Source: AGHT+IFceys+pXrDkQAjVnC0xLIHJoCAESNX9VhaTheWSjgIQfBO8WOSoThMYZPhTIeixc70eRrFdA==
X-Received: by 2002:a05:6e02:1aab:b0:3ce:4b12:fa17 with SMTP id e9e14a558f8ab-3d77c2b6c0fmr28351475ab.19.1744206059756;
        Wed, 09 Apr 2025 06:40:59 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e2eaeesm242546173.126.2025.04.09.06.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 06:40:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	brauner@kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCHSET v3 0/5] Cancel and wait for all requests on exit
Date: Wed,  9 Apr 2025 07:35:18 -0600
Message-ID: <20250409134057.198671-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Currently, when a ring is being shut down, some cancelations may happen
out-of-line. This means that an application cannot rely on the ring
exit meaning that any IO has fully completed, or someone else waiting
on an application (which has a ring with pending IO) being terminated
will mean that all requests are done. This has also manifested itself
as various testing sometimes finding a mount point busy after a test
has exited, because it may take a brief period of time for things to
quiesce and be fully done.

This patchset makes the task wait on the cancelations, if any, when
the io_uring file fd is being put. That has the effect of ensuring that
pending IO has fully completed, and files closed, before the ring exit
returns.

io_uring runs cancelations off kthread based fallback work, and patch 1
enables these to run task_work so we'll know that we can put files
inline and not need rely on deadlock prune flushing of the delayed fput
work item. The rest of the patches are all io_uring based and pretty
straight forward. This fundamentally doesn't change how cancelations
work, it just waits on the out-of-line cancelations and request
queiscing before exiting.

The switch away from percpu reference counts is done mostly because
exiting those references will cost us an RCU grace period. That will
noticeably slow down the ring tear down by anywhere from 10-100x.

The changes can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-exit-cancel.2

Since v2:
- Fix logic error io_queue_iowq()

 fs/file_table.c                |  2 +-
 include/linux/io_uring_types.h |  4 +-
 include/linux/sched.h          |  2 +-
 io_uring/io_uring.c            | 79 +++++++++++++++++++++++-----------
 io_uring/io_uring.h            |  3 +-
 io_uring/msg_ring.c            |  4 +-
 io_uring/refs.h                | 43 ++++++++++++++++++
 io_uring/register.c            |  2 +-
 io_uring/rw.c                  |  2 +-
 io_uring/sqpoll.c              |  2 +-
 io_uring/zcrx.c                |  4 +-
 kernel/fork.c                  |  2 +-
 12 files changed, 111 insertions(+), 38 deletions(-)

-- 
Jens Axboe



