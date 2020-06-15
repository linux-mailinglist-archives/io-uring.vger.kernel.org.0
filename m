Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106581F8F73
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 09:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgFOHZj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 03:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbgFOHZi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 03:25:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED609C061A0E;
        Mon, 15 Jun 2020 00:25:37 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id l11so15932038wru.0;
        Mon, 15 Jun 2020 00:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NMLq/9XIcyyjvzmMHTslVdNcPYlPlXmCK0RGCpT01yE=;
        b=jdW1SHupzWb9yWtx3UWvAyHXkP8PLIdElohOR9xEDSDXMU6UL9egRUJRg40JUq+B7A
         VQJYZ509JLeMCt7vHsUcNJuaiODuT8ND1lXlRrQN3VljSdWuAe1ZvRefcb2VIszfy/TI
         1A5rM0XJC1w101aGKeUCsrMBVUOlZZuuoo1oBr9wMtXvKtA742idAd3dBoL3iqXv2Ctd
         OnNEQ6/SZt9duX5yS1R3LOkJsPPWKvJy4Ai4hM64R+bmFd8rj+dViLYGBXvhhtYrAJK5
         GdAWPzSf+o1wV9w8nkS/h26+2XDrBzQpK8zO4OjPHpEEEyVfpV+1hyuuWQeomgCuh0sB
         RF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NMLq/9XIcyyjvzmMHTslVdNcPYlPlXmCK0RGCpT01yE=;
        b=pGZCrXMUocrCy7MOF+R0nMJjAl9N1aMdAlb91o2fzbs/h/FPHEvKEfAi2roGUAzh9Q
         AkgeNEwu8L8lBQyGOQu/rJh6zdNTAuccCPfB+tK1FXae+Ef58FTl+LUTjKpUtr6l2tu4
         Yia29B3MGDLlj6uSn9EmWp1Rk28cEykKP/HNqsgclfow80FyjEwSxxEUC4y+KoImcbxt
         7D4DvPfkGJFksbVVcyx1Lzdf2F+FAjjVivSp9tJQeer5NE0+YBNL2EJwGOEbOGRkbaLj
         vM7mC0i8IODpFqF0C3TjIOkm6BYL6RSHyQ1zHtKRMXNDuEukVbtWQvqMjCCkqugAcnKO
         7J7g==
X-Gm-Message-State: AOAM532Z5tyE/jOzOIPKhOI6FPewT7mFjrw5X+35Dc0+tNPgMZkmag9z
        9vfCp3YGIp3ii78AZzn0K5KCU/e+
X-Google-Smtp-Source: ABdhPJw7QNcn4UO8OzvQEpDnbZ2+dLCp9L9OxAwofXDk8ujYEQo+ToGUvRkYkrsK8uzaEQ6l79u0bw==
X-Received: by 2002:adf:9795:: with SMTP id s21mr29213904wrb.166.1592205936172;
        Mon, 15 Jun 2020 00:25:36 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id b187sm21897402wmd.26.2020.06.15.00.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 00:25:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4][RESEND] cancel all reqs of an exiting task
Date:   Mon, 15 Jun 2020 10:24:01 +0300
Message-Id: <cover.1592205754.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_flush() {
        ...
        if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
                io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
}

This cancels only the first matched request. The pathset is mainly
about fixing that. [1,2] are preps, [3/4] is the fix.

The [4/4] tries to improve the worst case for io_uring_cancel_files(),
that's when they are a lot of inflights with ->files. Instead of doing
{kill(); wait();} one by one, it cancels all of them at once.

v2: rebase

Pavel Begunkov (4):
  io-wq: reorder cancellation pending -> running
  io-wq: add an option to cancel all matched reqs
  io_uring: cancel all task's requests on exit
  io_uring: batch cancel in io_uring_cancel_files()

 fs/io-wq.c    | 108 ++++++++++++++++++++++++++------------------------
 fs/io-wq.h    |   3 +-
 fs/io_uring.c |  29 ++++++++++++--
 3 files changed, 83 insertions(+), 57 deletions(-)

-- 
2.24.0

