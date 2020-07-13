Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E4421E188
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgGMUjR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGMUjR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:39:17 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134CDC061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:17 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id p20so18898477ejd.13
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=75ItEEd9I+H43et/2kArBVPFjcY0gQbZSztBnCypFGw=;
        b=Sbq1iSRDSzhHoY2B7IgDuyhyN2CZzrQdX9EWg5W0OPYZhVXdFDYhrdwgyTuYXZJraj
         7oFC0CzLTRbMBZudH/0alXfBSyOibCjcMjwOFqq/mLK7RvLocwGnRilNsEgU8DTIubJR
         ZfGOeXyDAC0UOClmanxDZzvD444mNJG3ROUXw6W8pO69xTTWXnDsCG9Uy7Ji84fj5+zJ
         6am8bZzYQRfTnVU9gDaeLq5TwJBNpp09IsI1Uy7ryGYuzRvpCEbQ4mv/UYpWhsQjmDOt
         AnX780w2kAJDn5RimHRxEn962Amsy8sYdZQfY04gcnrKy1Zokgq1yjD5DWf+co8FGiNn
         V7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=75ItEEd9I+H43et/2kArBVPFjcY0gQbZSztBnCypFGw=;
        b=FvrnXTRVN1vJDBaWBo3YlVtUZ2/QtBN9hQSuRjVz7dmnPeK/JgpaC0IayPCJvy3qSD
         USIyqqtmNiPP30USQrlqMRk1teB0/aRKTRlaKJopRvuXjyCjeYj6J+TmuYDqUcIphujy
         +ZoSMMRRzsua9WJXSozYOnjMNclUbOjqxXzMfY+IbRZBXlpFk9bkHqQeuirPhWBFQ/Z2
         Pdl9LzfNnOSWmWOvTR6L3Mjmg6R+ZSpUBE6tRY6dl+el65637ECwQz4vFoplMRZ+Ww5x
         Cgik7Vg8lArsEQy6LpCMFlFzdQx2Rj/GHHIeMCNOkgsvgCPtcRw9S+9+pdx1VBV9M3fF
         eAHA==
X-Gm-Message-State: AOAM5300dnHlq5UbrpSUJ/PVbko5g3L9ove3E3kxzC8vIYgSzCl5bzBp
        mn31rzZa/GrwRvtH3T1FVkl/96Pv
X-Google-Smtp-Source: ABdhPJyx/VrRJcKrpW69Qa8HuidAnLqOYLigamlY12zrl3zBIgTYtsnyRHNdiwF5hrDPXqSbW5wFYQ==
X-Received: by 2002:a17:906:7694:: with SMTP id o20mr1456563ejm.289.1594672755738;
        Mon, 13 Jul 2020 13:39:15 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m14sm10491855ejx.80.2020.07.13.13.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:39:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 0/9] scrap 24 bytes from io_kiocb
Date:   Mon, 13 Jul 2020 23:37:07 +0300
Message-Id: <cover.1594670798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make io_kiocb slimmer by 24 bytes mainly by revising lists usage. The
drawback is adding extra kmalloc in draining path, but that's a slow
path, so meh. It also frees some space for the deferred completion path
if would be needed in the future, but the main idea here is to shrink it
to 3 cachelines in the end.

This depends on "rw iovec copy cleanup" series

v2: [1] invalid kfree() in the end of io_{write,read}()
        handled by "rw iovec copy cleanup" series
    [1] rename io_cleanup_req() -> __io_clean_op()
    [3] rename iopoll_list -> inflight_entry (Jens)
    [8] correct sequence types, 
    [8] return back sequence-based fast check in defer

Pavel Begunkov (9):
  io_uring: share completion list w/ per-op space
  io_uring: rename ctx->poll into ctx->iopoll
  io_uring: use inflight_entry list for iopoll'ing
  io_uring: use completion list for CQ overflow
  io_uring: add req->timeout.list
  io_uring: remove init for unused list
  io_uring: use non-intrusive list for defer
  io_uring: remove sequence from io_kiocb
  io_uring: place cflags into completion data

 fs/io_uring.c | 198 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 122 insertions(+), 76 deletions(-)

-- 
2.24.0

