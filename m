Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A915F28F2FF
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 15:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgJONRG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 09:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgJONRG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 09:17:06 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2D5C061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:17:05 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id o4so573507iov.13
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gEuPfz0KXA/MgwtC7gp17zj6T5fVm/x6kmNaSJMr43Q=;
        b=OneD/DqISQLZlkUKTVnoMywsjTnsmuOYCeMgQkiwvuxoUVL1kqucRTybCG7aq5Dk0U
         oIhoiAdebgUeWIjfx/T7/+BYoEHIUDXpRJ8lhlRv9RohB21XkQxzXv+GUzMdK9X0Tlmf
         zO9NmAcOcXz2q1wsXzDgT6gtbyd3vMVD5+KK/Ew0ZwmBUUSVD+q9JXU8HUeDuN3iGRCF
         GrYW9cCXEqzTEQXXeHDzn3zhxUK/+nNL/mR38bPfKfMM9HL3KG5KqacokZjRSzxcem7j
         PzJfQUeAkbUs18B+NiqEegv6eyVihxUi4LrBrsEn93OiUPMhxrFRneVb2/U7nBsh5NRc
         ZAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gEuPfz0KXA/MgwtC7gp17zj6T5fVm/x6kmNaSJMr43Q=;
        b=HZPYBUJtbSiOh6CWBC52Sa3DVp8vZL9yHB7imZdHJV8mlCBnYH6T70rQDtzHgE0SOK
         4no2iAIoXwV3Yj0de4ERV5Slr7RB5gmaZRMXQLw8/Cd27JbCAU+RTNHjJToD5SQ0Tr32
         OpRsexD4av1d8BH2X3Fsc3eNJg1NfNIhvtU3hoTI5xvGPG71g8Sh1/VPttKzwHTqoVs2
         87d9HZv6SgkMLbnoCHlpovrV7LH7QE9NmJcnSyjtE25ZOBAa+lfaaAiMLjq0/5fW8H2m
         10Z+g3Djmdo6UjASqQHd5tqTDLqKWcSy0rIcTHKO0yJOlEGc3vqUwoPcSRqFUx+e0q7K
         g9Kg==
X-Gm-Message-State: AOAM532ZK5lFAZF9W6if7yPptn7u2JxhNGDxmAH+kxw+iPkbmEynVALH
        2SQmUk8ZT9J4eFAByPdcmah+NA==
X-Google-Smtp-Source: ABdhPJxY8t3WaBYb0mnx9DojoFwmc78wXA904V7SoKJjZdv30XRMpzPzuPkf/yhMuP3SVCZbgVk7Dw==
X-Received: by 2002:a5d:9693:: with SMTP id m19mr3120512ion.161.1602767825278;
        Thu, 15 Oct 2020 06:17:05 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m13sm2486736ioo.9.2020.10.15.06.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 06:17:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Subject: [PATCHSET v5] Add support for TIF_NOTIFY_SIGNAL
Date:   Thu, 15 Oct 2020 07:16:56 -0600
Message-Id: <20201015131701.511523-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

The goal is this patch series is to decouple TWA_SIGNAL based task_work
from real signals and signal delivery. The motivation is speeding up
TWA_SIGNAL based task_work, particularly for threaded setups where
->sighand is shared across threads. See the last patch for numbers.


 arch/alpha/kernel/signal.c         |  1 -
 arch/arc/kernel/signal.c           |  2 +-
 arch/arm/kernel/signal.c           |  1 -
 arch/arm64/kernel/signal.c         |  1 -
 arch/c6x/kernel/signal.c           |  4 +--
 arch/csky/kernel/signal.c          |  1 -
 arch/h8300/kernel/signal.c         |  4 +--
 arch/hexagon/kernel/process.c      |  1 -
 arch/ia64/kernel/process.c         |  2 +-
 arch/m68k/kernel/signal.c          |  2 +-
 arch/microblaze/kernel/signal.c    |  2 +-
 arch/mips/kernel/signal.c          |  1 -
 arch/nds32/kernel/signal.c         |  4 +--
 arch/nios2/kernel/signal.c         |  2 +-
 arch/openrisc/kernel/signal.c      |  1 -
 arch/parisc/kernel/signal.c        |  4 +--
 arch/powerpc/kernel/signal.c       |  1 -
 arch/riscv/kernel/signal.c         |  4 +--
 arch/s390/kernel/signal.c          |  1 -
 arch/sh/kernel/signal_32.c         |  4 +--
 arch/sparc/kernel/signal_32.c      |  4 +--
 arch/sparc/kernel/signal_64.c      |  4 +--
 arch/um/kernel/process.c           |  2 +-
 arch/x86/include/asm/thread_info.h |  2 ++
 arch/x86/kernel/signal.c           |  7 +++--
 arch/xtensa/kernel/signal.c        |  2 +-
 include/linux/entry-common.h       |  9 +++++--
 include/linux/entry-kvm.h          |  4 +--
 include/linux/sched/signal.h       | 20 ++++++++++++---
 include/linux/tracehook.h          | 31 ++++++++++++++++++++--
 kernel/entry/common.c              |  7 +++--
 kernel/entry/kvm.c                 |  7 ++---
 kernel/events/uprobes.c            |  2 +-
 kernel/signal.c                    |  8 +++---
 kernel/task_work.c                 | 41 +++++++++++++++++++++---------
 35 files changed, 118 insertions(+), 75 deletions(-)


Changes since v4:
- Change ifdef as per Thomas
- Split x86 change from generic entry code
- Pass in TIF flags for arch_do_signal() to avoid doing multiple bit
  tests

-- 
Jens Axboe


