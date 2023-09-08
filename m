Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9DD79896D
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244312AbjIHPCd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 11:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239616AbjIHPCc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 11:02:32 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42731FC0
        for <io-uring@vger.kernel.org>; Fri,  8 Sep 2023 08:02:27 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-34bae11c5a6so1838875ab.0
        for <io-uring@vger.kernel.org>; Fri, 08 Sep 2023 08:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694185347; x=1694790147; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PX7Hx4yVo+m3CpmJCO9GYl/DfTKVFPmdbHU3i52kK3o=;
        b=R2WIeATu1CB0hNbU4h0BOLBCKG44kGOpT81kWuNYDAP9IV8izz6jUvS+SqYxICIynV
         kFCUOm0ifuz1ie0E2Z18W9Hi7k1Gz9RFKAeZbFOnpVUN0WdouoM8w3yVVmXcpAShNJNe
         QrBYqI/gHiuuCbu/skPOJXSZzWCfnLNG/EE4W82Oe0xZ4WAsKWwVFymi4eVZRktVuNYH
         E8JuITv7RPfQi3YEfKjPOY9itx8EQ00Yljr4ZwCzvr6L6N7j5hyM13V1jnW6L2N5CHGz
         rr0uLxj+yI6gv53/aqGVE+5voZEM5Miq8i8grt72ybhIL5VUMDFsqQepoE74ny87Ldhh
         z3Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694185347; x=1694790147;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PX7Hx4yVo+m3CpmJCO9GYl/DfTKVFPmdbHU3i52kK3o=;
        b=iDiJOpYUrCnyWPmh8XbnTugx2PBE5/MmABzLHV1ngu7hzRCvBfrZHcV2dyoimPp56N
         hNyA2sFi0lQy++GV376VJLuFKp4o8BE0nfxvQWOyu4mkFvKx204lbsl4pWlDcd5Vm4xM
         4jcUepo58CJljb5zxLvFJZfzEnckxv5FeyGKFoFY739dEbgODrk/JFyHMYLSxIYGGlXQ
         skJMU045rveAqJIUE/GCIwG7385e4GZtjg97e5P/Ub4s8tj7ykF5TAshauG/ECVwWh6m
         qPB8zGQG2JCcXTqGc4BmdiOrXXV7WUGPkFAr55DVJTMHry244BfN6cGCokTlnZmYBTLN
         chOg==
X-Gm-Message-State: AOJu0YwF6iDw2Ye2DE26rUGwVN8Nf5G/qHQT0odPHlRYTCSltkthVhw+
        w1nW4BM10KwWxkeOn/ZQ4fMKKQ46b0cM5VqRwwCdQg==
X-Google-Smtp-Source: AGHT+IE6libJyLscxmrkiV8jrpe4jbGS5cWesnz9Oqswy7H05xgbe2AT9esq64BVFkcGzkQdnA0wnA==
X-Received: by 2002:a92:c087:0:b0:34f:36ae:e8d2 with SMTP id h7-20020a92c087000000b0034f36aee8d2mr3047201ile.3.1694185347128;
        Fri, 08 Sep 2023 08:02:27 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l12-20020a92d94c000000b0033e23a5c730sm532963ilq.88.2023.09.08.08.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Sep 2023 08:02:26 -0700 (PDT)
Message-ID: <7828a377-ed0c-4d22-8e36-8cf2eaa4f4b8@kernel.dk>
Date:   Fri, 8 Sep 2023 09:02:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.6-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes that should go into the 6.6-rc merge window:

- Fix for a regression this merge window caused by the SQPOLL affinity
  patch, where we can race with SQPOLL thread shutdown and cause an oops
  when trying to set affinity (Gabriel)

- Fix for a regression this merge window where fdinfo reading with for a
  ring setup with IORING_SETUP_NO_SQARRAY will attempt to deference the
  non-existing SQ ring array (me)

- Add the patch that allows more finegrained control over who can use
  io_uring (Matteo)

- Locking fix for a regression added this merge window for IOPOLL
  overflow (Pavel)

- IOPOLL fix for stable, breaking our loop if helper threads are exiting
  (Pavel)

Also had a fix for unreaped iopoll requests from io-wq from Ming, but we
found an issue with that and hence it got reverted. Will get this sorted
for a future rc.

Please pull!


The following changes since commit 6c1b980a7e79e55e951b4b2c47eefebc75071209:

  Merge tag 'dma-mapping-6.6-2023-08-29' of git://git.infradead.org/users/hch/dma-mapping (2023-08-29 20:32:10 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.6-2023-09-08

for you to fetch changes up to 023464fe33a53d7e3fa0a1967a2adcb17e5e40e3:

  Revert "io_uring: fix IO hang in io_wq_put_and_exit from do_exit()" (2023-09-07 09:41:49 -0600)

----------------------------------------------------------------
io_uring-6.6-2023-09-08

----------------------------------------------------------------
Gabriel Krisman Bertazi (1):
      io_uring: Don't set affinity on a dying sqpoll thread

Jens Axboe (2):
      io_uring/fdinfo: only print ->sq_array[] if it's there
      Revert "io_uring: fix IO hang in io_wq_put_and_exit from do_exit()"

Matteo Rizzo (1):
      io_uring: add a sysctl to disable io_uring system-wide

Ming Lei (1):
      io_uring: fix IO hang in io_wq_put_and_exit from do_exit()

Pavel Begunkov (2):
      io_uring: break out of iowq iopoll on teardown
      io_uring: fix unprotected iopoll overflow

 Documentation/admin-guide/sysctl/kernel.rst | 29 +++++++++++++++
 io_uring/fdinfo.c                           |  2 ++
 io_uring/io-wq.c                            | 10 ++++++
 io_uring/io-wq.h                            |  1 +
 io_uring/io_uring.c                         | 56 +++++++++++++++++++++++++++--
 io_uring/sqpoll.c                           |  4 ++-
 6 files changed, 99 insertions(+), 3 deletions(-)

-- 
Jens Axboe

