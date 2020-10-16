Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225F82908C1
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 17:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408671AbgJPPpx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 11:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410386AbgJPPpw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 11:45:52 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471F7C061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:45:52 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d23so1490876pll.7
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYbQaDMfS+fMZq0SRvCKUeB9Qm+Ttaw/Z4j/8qnPYOE=;
        b=1s+Gq/VoGaNBXHCyTy3bIT3PcIMErPRCTXabyg86Jme4mJeO9Lc49fjNgMUDaPChO2
         G1RJePs8H7z5f444uk+/xlJpDeHbLbiXk7gthvRaa69vJGi32Kj88/HGJd9KNFwr2SlD
         KSFSQBEB1FIhSeXR2jtNkA8VKSfj5R9/AmAlfFd5GWn28p0hR8UBr/zWbJSsk9LDef/3
         MsvvCxVwftCgfRFh2LpJJlqguLWGQgSCdvTzZebQpoh2kp3TUcv/TcoNPQHk5F9LMX50
         WtI4G1pLMyaKVlizw/mFkzp2g7/QMideKKoaTuRgV4vqgdJfvijiKkGE3e1q/c3QW3s3
         cB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYbQaDMfS+fMZq0SRvCKUeB9Qm+Ttaw/Z4j/8qnPYOE=;
        b=Jm+qgt1PpDbwsK5dl8FyrhcdOhF+ihy48W4ydpvVdIobf9T29DIQ9GA2tSAq4W7Xak
         VBDpvm7pqAS3okUM4YLFxdlGyt8snwEJCb8YDIWV2jNIQDGyr6cLUoDKF4UsnNSYm2hw
         01MlY8gtj9B4aZm/NlDWkWgP9JyrPwQmyEFCc0T/rBsbmVKtH0vt2sioGr+ZPE5Gjpel
         sgzmnwk09n/IHnTHLnul/7Rz1dT9mqySsLFYUZwn4Hd8pZN1u9U+Kyaq1zU5PIi2iMr0
         0AfKwrB+szCbHHaf3uXZiYyBlq30eXLCkeFC742n7J2QsFuumfROW6x8BDfkWDmwfiIV
         GHew==
X-Gm-Message-State: AOAM532XVhqspXGytmaf0pWs9/2AR4/3IOfCtRSYKYUQvuV4UMfQ50i9
        L/d5D0e/WgRLULFvguPviY+6Fw==
X-Google-Smtp-Source: ABdhPJwvF9FFrNcgFujKeZXR0opNZ/gKUbtuMLnGZMVFx3YChFqPX9AngahOT8+4q30PcCWhZDlfYw==
X-Received: by 2002:a17:902:ec02:b029:d1:fc2b:fe95 with SMTP id l2-20020a170902ec02b02900d1fc2bfe95mr4839637pld.79.1602863151729;
        Fri, 16 Oct 2020 08:45:51 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s11sm3346194pjz.29.2020.10.16.08.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 08:45:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Subject: [PATCHSET v6] Add support for TIF_NOTIFY_SIGNAL
Date:   Fri, 16 Oct 2020 09:45:43 -0600
Message-Id: <20201016154547.1573096-1-axboe@kernel.dk>
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

Cleanups in this series, see changelog. But the arch and cleanup
series that goes after this series is much simpler now that we handle
TIF_NOTIFY_SIGNAL generically for !CONFIG_GENERIC_ENTRY.


Changes since v5:
- Don't make TIF_NOTIFY_SIGNAL dependent on CONFIG_GENERIC_ENTRY
- Handle TIF_NOTIFY_SIGNAL in get_signal() for !CONFIG_GENERIC_ENTRY
- Add handle_signal_work(), and change arch_do_signal() to
  arch_do_signal_or_restart() and pass in a 'has_signal' bool for that
- Dropped TIF_NOTIFY_RESUME patch from this series, sent out
  separately.


 arch/x86/include/asm/thread_info.h |  2 ++
 arch/x86/kernel/signal.c           |  4 +--
 include/linux/entry-common.h       | 11 +++++---
 include/linux/entry-kvm.h          |  4 +--
 include/linux/sched/signal.h       | 20 ++++++++++++---
 include/linux/tracehook.h          | 27 ++++++++++++++++++++
 kernel/entry/common.c              | 14 +++++++---
 kernel/entry/kvm.c                 |  3 +++
 kernel/events/uprobes.c            |  2 +-
 kernel/signal.c                    | 22 +++++++++++++---
 kernel/task_work.c                 | 41 +++++++++++++++++++++---------
 11 files changed, 120 insertions(+), 30 deletions(-)

-- 
Jens Axboe



