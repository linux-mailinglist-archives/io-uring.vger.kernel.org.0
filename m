Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245776D60F0
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbjDDMky (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbjDDMkx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:40:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E6D90;
        Tue,  4 Apr 2023 05:40:52 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id er13so89026210edb.9;
        Tue, 04 Apr 2023 05:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VFnZ12G+y2pitfoZBbnB+ZM2ovZHCmWRqjrP6kGE9HI=;
        b=Q/+I2OSjUmdDmF2Z0eckqlcE3+DXzNFDEvlPF0WKrAVOR4Cz4uHVKw88RejMm+1z/E
         CxLg+1qYT+VTwLo9Ge9WDT5iVCphBlPrcJ+e+19Gj4WtSRe2+yqM8D75NT7JqxdjF/1B
         PCOCBJl0HcEGtyGDqYZEELN4hdydvHOMZXqkfqQVLmpHtoI4ssGr37WuRXA9bwK4wPGd
         9Zp62wMnRptTsFdB9tOujb8QK329xFZ1xCmPwKhkPvQ2IhyNdwZJ9DkSP4q1A3BueCqs
         NXBDxJ1wMdPIyQMH0ayEghouIg97OY1lRNf3edQe4L+coRUyfcgiT/rlvm4Dk2k15Yj/
         zd7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VFnZ12G+y2pitfoZBbnB+ZM2ovZHCmWRqjrP6kGE9HI=;
        b=Q4RJ0nLV3bjMOpIZSDxnK7EQemNzmKysdn06FS1+J345XMaEomYosKK9SzYwXU8up9
         0iGtCC0dKKj906JHPS4Ar/1KnCD0REsd8q5CdRxGpBdYk//PrhthNY2XMYrJcqFyo4k5
         Vve9gf948g9sRhRr42jguGLjgjq83Hhj4oRRqT5OvV4bTnGmZUt1EjaPMzi50yOAt2Gy
         glrzvo4y+hH7LX6kjFYo/R0Hy1Zp4pKLMQYvLjbCFJNdl7iKWVjlpWt/XUIROAeVQrWC
         t1epOc5q3BHhCTeq7Y+7rYzdH7H18gr5oSFKU/pVrwrBUCdDrspaR4aC7CuJuLK5MOIo
         YqPQ==
X-Gm-Message-State: AAQBX9cJDC71VMZ80gQ+N2d612oPtW3MXdjYnrCO6jZCWNme1IgIuHJH
        EgHKeWP60Uusm0rMyvbLEvJaeIpF8x4=
X-Google-Smtp-Source: AKy350bWYnBhr6TR0i0938b3CGOJNIxHCB/FcQ0lnLJ3GesJA8jYpjBP5utiJGlLy6LX7FLe3WfBUg==
X-Received: by 2002:a17:906:bcfb:b0:930:a3a1:bede with SMTP id op27-20020a170906bcfb00b00930a3a1bedemr1858802ejb.50.1680612050352;
        Tue, 04 Apr 2023 05:40:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/13] optimise registered buffer/file updates
Date:   Tue,  4 Apr 2023 13:39:44 +0100
Message-Id: <cover.1680576071.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The patchset optimises registered files and buffers updates / removals,
The rsrc-update-bench test showes 11x improvement (1040K -> 11468K
updates / sec). It also improves latency by eliminating rcu grace
period waiting and bouncing it to another worker, and reduces
memory footprint by removing percpu refs.

That's quite important for apps updating files/buffers with medium or
higher frequency as updates are slow and expensive, and it currently
takes quite a number of IO requests per update to make using fixed
files/buffers worthwhile.

Another upside is that it makes it simpler, patch 9 removes very
convoluted synchronisation via flush_delayed_work() from the quiesce
path.

v2: rebase, add patches 12 and 13 to remove the last pair atomics out
    of the path and to limit caching.

Pavel Begunkov (13):
  io_uring/rsrc: use non-pcpu refcounts for nodes
  io_uring/rsrc: keep cached refs per node
  io_uring: don't put nodes under spinlocks
  io_uring: io_free_req() via tw
  io_uring/rsrc: protect node refs with uring_lock
  io_uring/rsrc: kill rsrc_ref_lock
  io_uring/rsrc: rename rsrc_list
  io_uring/rsrc: optimise io_rsrc_put allocation
  io_uring/rsrc: don't offload node free
  io_uring/rsrc: cache struct io_rsrc_node
  io_uring/rsrc: add lockdep sanity checks
  io_uring/rsrc: optimise io_rsrc_data refcounting
  io_uring/rsrc: add custom limit for node caching

 include/linux/io_uring_types.h |   8 +-
 io_uring/alloc_cache.h         |   6 +-
 io_uring/io_uring.c            |  54 ++++++----
 io_uring/rsrc.c                | 176 ++++++++++++---------------------
 io_uring/rsrc.h                |  58 +++++------
 5 files changed, 136 insertions(+), 166 deletions(-)

-- 
2.39.1

