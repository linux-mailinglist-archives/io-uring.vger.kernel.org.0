Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC083291694
	for <lists+io-uring@lfdr.de>; Sun, 18 Oct 2020 11:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgJRJUp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Oct 2020 05:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgJRJUp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Oct 2020 05:20:45 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C6EC061755
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:44 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n6so8019710wrm.13
        for <io-uring@vger.kernel.org>; Sun, 18 Oct 2020 02:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NRr9ejYEGdHZy6PgBsIYcJavgQKVfk0XY7my9ClYNis=;
        b=N+cmfY1mdEHQ9f428tB8vLFmxVwvADxHZZLPntDLSe876WVxEGK9AU7cZ6Ca8WAnaU
         nFMGtHfFtM0P3YD0JH70mwsU1/QVrojwHeiJz5yF5GNGeNaw0tknp4YJ5rLbpRQcobOg
         1I1x0Nmu/SqdQukLrb9B0M8pTknOYkDdaPmVeLRMpQZeSOfU2cAmEwKWvUwcofgIMEWY
         zQrSNp4qb3uKgsCiyvWT7t+Wlc6JaYP+gMQqcYjNTfIx7EvVA07Blp9SKtqRKlXas/+K
         njHQk62I1GLlmzZK2oznfcCgXxqf8K7V0dIp20Qyh4KUp4ZHrGRt/9xsitjSWEmv1AOI
         bLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NRr9ejYEGdHZy6PgBsIYcJavgQKVfk0XY7my9ClYNis=;
        b=ctbvDDdifD3NpTX3NofvIgEKrJOd3LUaDc7rIbQ4/sm6UfgOCWlinCZw96Lk3Q04mm
         9yIlRwaQfjQHoVm6OnROjLh052LLNcQXMGAy1rMlbsw8kXv5fkLiFM6npeQdhCg4QgQ0
         4cTkWAA8Rk9n4NQ5UJxD/HenEbgkv1V2vlsTuVPiMWsS3COlJnNtC5jGnskiXRsel9fv
         bTQpxeyBkFebHmJFULW4yr2xo9jolYeiKlu8iAXfsPlEtfaOBwYh2nsOfAswq8bTyBTH
         6VRvzyxCntj3N05EhN5emtVcYsa1SOjQ/9IegX/78k0FKo42wkj6coknWdYb8hucAm2F
         k7mQ==
X-Gm-Message-State: AOAM533abkav/vLgzmDkBHB2dJDEFcWQWg1v3FcqnfKsk2OzQ77ysflx
        IsVPGtoIdMAoHA8oCn1m9BUBrZcxUBbYhA==
X-Google-Smtp-Source: ABdhPJz83nb28rKaaMZOdSnK++7u+AGtytdUIDGNkuBbeF0wO4TjrOzF5pycYOgKZfnXgRGqe/ncGg==
X-Received: by 2002:a5d:4d0c:: with SMTP id z12mr2006567wrt.60.1603012843387;
        Sun, 18 Oct 2020 02:20:43 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id w11sm12782984wrs.26.2020.10.18.02.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 02:20:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-5.10 0/7] another pack of random cleanups
Date:   Sun, 18 Oct 2020 10:17:36 +0100
Message-Id: <cover.1603011899.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nothing particularly interesting, just flushing patches that are
simple and straightforward.

Pavel Begunkov (7):
  io_uring: flags-based creds init in queue
  io_uring: kill ref get/drop in personality init
  io_uring: inline io_fail_links()
  io_uring: make cached_cq_overflow non atomic_t
  io_uring: remove extra ->file check in poll prep
  io_uring: inline io_poll_task_handler()
  io_uring: do poll's hash_node init in common code

 fs/io_uring.c | 77 ++++++++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 44 deletions(-)

-- 
2.24.0

