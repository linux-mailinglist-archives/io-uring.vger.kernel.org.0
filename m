Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248EF35F425
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 14:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhDNMnP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 08:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhDNMnP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 08:43:15 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEAFC061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:53 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id p6so13031278wrn.9
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a/WCucOxjlJy7tcKHxuKnK3ZwEpqpYCo7vgfyWf2mtM=;
        b=q++aIuogjog9W8IxKyJL4DZ8reJQDD/XR51be4kyf+YLUpErtlpNVJq/Msct01UYma
         kx+HiZp9f03nB/Iu/Vm2WS/tjrs6PgUs/PU/OndsZXjvJFrmTvObwb3FMg4BKrENIihi
         drrl8qUvpu4AtdvcT9nPYN3IlJiZ8gyMDoVUJNJ6eIJfrM7Qb2LFTaZQJ+b195IB8LHB
         p2o1MtT3B0jASWyYeJJWJglWYwRriRneKQMlgIRMGzEM9WCy+EZx5BubW6NHLT+0wUwr
         RXhaIC3Bk1YcYjPPqQgOj0xaeh9cNSIG7GwQrMpZ0AGC/yTisykCguV7VYbUJXooZ+9N
         e1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a/WCucOxjlJy7tcKHxuKnK3ZwEpqpYCo7vgfyWf2mtM=;
        b=AKf4USePCTsVL/M1XXC8iNppFcskF+b/V/2RPAJ9t6JkennakDfohmkchRX3bqXkQp
         PJWCsR15X8uAhfm8aj55aVJcXl/nsz5O7lUdlskG9wdhdAQ7nCaRDcdR72vXRPuAFal3
         hsMqpHLntxkVgghB0DtdXDhKA/VhI12UK/CR3fD5EZLUAMq65Z8VEVuSDWeiwa5A7bjB
         1o/wQbOVetvmwCrM6QoRdFanqdo0BgRoPRGD1h4XsOgtjGnXgMmaU/CWX6i80Lwxn8zT
         pzbIH9SV1S3dXdweQlUhzZCYeCNHMTuUBnrJ0039hLinhFk34I4LqZtcDBrJmjqnJWwq
         U+mQ==
X-Gm-Message-State: AOAM532dF0X7ltz9QCQnu70pWZhJHe/5L8SWWeljTzE5Hxb1/18W+mVu
        ONQP/IYOHkCX6spwCsjrK3Q=
X-Google-Smtp-Source: ABdhPJxJQeDlkAP2iPbhL9a1sPGBlqAP885gWz78+QguY8TtDQVN+gvmoHxML0TdNYG7XoSAR3aC/A==
X-Received: by 2002:a5d:5407:: with SMTP id g7mr23068496wrv.149.1618404172754;
        Wed, 14 Apr 2021 05:42:52 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.37])
        by smtp.gmail.com with ESMTPSA id f2sm5179912wmp.20.2021.04.14.05.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 05:42:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5.13 0/5] poll update into poll remove
Date:   Wed, 14 Apr 2021 13:38:32 +0100
Message-Id: <cover.1618403742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-2 are are small improvements

The rest moves all poll update into IORING_OP_POLL_REMOVE,
see 5/5 for justification.

v2: fix io_poll_remove_one() on the remove request, not the one
we cancel.

Pavel Begunkov (5):
  io_uring: improve sqpoll event/state handling
  io_uring: refactor io_ring_exit_work()
  io_uring: fix POLL_REMOVE removing apoll
  io_uring: add helper for parsing poll events
  io_uring: move poll update into remove not add

 fs/io_uring.c | 197 ++++++++++++++++++++++++--------------------------
 1 file changed, 94 insertions(+), 103 deletions(-)

-- 
2.24.0

