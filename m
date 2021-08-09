Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3313E4530
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhHIMF0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbhHIMFZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:25 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5793C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:04 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k5-20020a05600c1c85b02902e699a4d20cso761610wms.2
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U4Ht7QY5JC10GhkLZxsr6fpqhYvEYnSztOSugfAmMZg=;
        b=C8bIytp0dCTv5ABiB6ZtR0UwcH3i5n8VzJIGkr7sZljkrXwBepRpZGdiEeHD6SbID5
         YywFZt9PntjcQUcSqqbXkrgVely0+0QYoKmb06+jWfkFoOt1drgtT8VtELFL7I4sG8x+
         gkuho2BUMS+9uScmdSvLWZSlytepvgZc0E1bCdWKBsncW7CyGuNwZqfRNp6+3xsAxE7u
         5IxOUYEZzUFyVUMtPywe6vlom9njpNGNjwNOmX7x6FGKriSE6s1GFjUI0GAAdpR7n0y5
         rUaDcauAVewgxRUL3Z+gGSzQeWJ9pyN/g7J2zgkgjQ7QecTdsUo7HSrkJVAxADzSCW3Q
         8ZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U4Ht7QY5JC10GhkLZxsr6fpqhYvEYnSztOSugfAmMZg=;
        b=luQSJuT5G6EzkMuZ/vpC63uNiwqwxwAq8GHX8Dq4RaEMgtkEOUINugyOLuBf9IobGf
         yFhKQHKChPmdjHhtwPkm/aMqZKrZFuSI8t7CVEZWxVLKRG6YkEz/jooh+/fm4BMweRfF
         HFQeY06B7JpSUyxM5xhbWHaqdMjDDXI0EnapmXJIAU+wwdogrUzMcC7sC8BB4mcXY4Xx
         DtNRH4C9W+Q2zw61F3OHBtHN3ohpBOH/3v85ikexXUEMz+xq1Kh66whhyeHbCF5L6lcZ
         jfR5fAQbdHuy+4GtZT5Y/epsC0MtBPFqa23aVrEGkg/qGTQhU6laeC2VXqme2MjR/LlO
         S64g==
X-Gm-Message-State: AOAM533iMlVkK5583+OfnCLlh+0E+L6PHRWJoPOiKohXxiLfUqX6cOJB
        DEnYhNZHSwZdMBTltPjhmDsvpbFgsKI=
X-Google-Smtp-Source: ABdhPJwinqXSGYNeFBphbtS701HrnHaign9Blzmt/C7/GEdc05Z3qOycrc6lkeqTT0+HalLYQjfHEQ==
X-Received: by 2002:a1c:5404:: with SMTP id i4mr7396368wmb.80.1628510703607;
        Mon, 09 Aug 2021 05:05:03 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 00/28] for-next patches
Date:   Mon,  9 Aug 2021 13:04:00 +0100
Message-Id: <cover.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1,2 -- optimisation with kvmalloc()'ing file tables
4 -- optimise prep_rw() still touching inode with !REG fixed files
11 -- a small CQ waiting optimisation
20 -- put_task optimisation, saves atomics in many cases
23 -- helps req alloc sustainability, also needed for futures features

All others are cleanups, where 6-28 are resends.

v2: added patches 1-5

Pavel Begunkov (28):
  io_uring: use kvmalloc for fixed files
  io_uring: inline fixed part of io_file_get()
  io_uring: rename io_file_supports_async()
  io_uring: avoid touching inode in rw prep
  io_uring: clean io-wq callbacks
  io_uring: remove unnecessary PF_EXITING check
  io-wq: improve wq_list_add_tail()
  io_uring: refactor io_alloc_req
  io_uring: don't halt iopoll too early
  io_uring: add more locking annotations for submit
  io_uring: optimise io_cqring_wait() hot path
  io_uring: extract a helper for ctx quiesce
  io_uring: move io_put_task() definition
  io_uring: move io_rsrc_node_alloc() definition
  io_uring: inline io_free_req_deferred
  io_uring: deduplicate open iopoll check
  io_uring: improve ctx hang handling
  io_uring: kill unused IO_IOPOLL_BATCH
  io_uring: drop exec checks from io_req_task_submit
  io_uring: optimise putting task struct
  io_uring: hide async dadta behind flags
  io_uring: move io_fallback_req_func()
  io_uring: cache __io_free_req()'d requests
  io_uring: remove redundant args from cache_free
  io_uring: use inflight_entry instead of compl.list
  io_uring: inline struct io_comp_state
  io_uring: remove extra argument for overflow flush
  io_uring: inline io_poll_remove_waitqs

 fs/io-wq.h    |   2 +-
 fs/io_uring.c | 700 +++++++++++++++++++++++++-------------------------
 2 files changed, 355 insertions(+), 347 deletions(-)

-- 
2.32.0

