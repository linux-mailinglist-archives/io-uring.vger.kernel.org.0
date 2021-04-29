Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D655236EEC0
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 19:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbhD2RVl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 13:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbhD2RVk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 13:21:40 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33A9C06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 10:20:53 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 26-20020a05600c22dab029013efd7879b8so192983wmg.0
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 10:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AcNjvsHTBMMEUinRsX8LFPjNOqBzZPKZgfgLJCjbswY=;
        b=K+WiUcPd4ss++hHciuW50OlvFFb8XG55g6kuwe+NlkfjNhkcMDhUdVO+jcBwv2je5G
         UU2Rv8p4gGIZ18CFzoAWeS1pNVguMDaz3aQZOKma+W63f6w8HOWY81T5qxbvWuLvEi28
         2U9PCqBfuIAJr4+Azxwx2QFhIxY2LpopHkNn0TAWYPWkGRucKKeG/A643KKPXs0kEiVa
         y79T88ILk2STiz5QxbdMSi2oD9O24WDr14033SKc0W9TP90KGm79ep7r6UdXio10Df25
         NpBBLpnjjXjhIybN0tzpkUlRA0R/oqtDOdsWiOsuW3xulxO7NaeVxRhXut1xrRM1mDT0
         kusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AcNjvsHTBMMEUinRsX8LFPjNOqBzZPKZgfgLJCjbswY=;
        b=LBbpZp/9A2T8teDC+/OKJ7k5KmkCIz5ROsa34AAupXJ60Gfr17FcwljCZLAA//aGKy
         7//+XHrO23AI2Ol+TRIb41cUXqUeV/LF25GQxHa8a/cxlN0M+WesEE1deHFMy9pb+cAD
         ksVpmWLx4OBmjzTAGkgTmBhLQvovwMiLBqRGh44GPWa24sNmYXuJ9EtzWwWIvim+Vs6O
         Sre5KC50InbxBOsHMH78o5JXfrFxYzBSTc4QQHae3DM3CU03qOiu5WvJ5zxv63Q7AffF
         YpxfNYzjKxkOwQhup/lja+Jy3FUUXSNcXfWb7lFOIehwZ7t2L6ZYqJ40dh2qxEz4k42k
         PDwQ==
X-Gm-Message-State: AOAM533aALUwUNybeafdiOWoFS3+eatti5vgLSWhgqzTJNZ5EQuBp1eZ
        XvapFvF8molKSVlTyOk7uoLoB6mBcjs=
X-Google-Smtp-Source: ABdhPJxrEK7XE/q0qhfQPTvOY8pZd+/ofEZpFfyN5saF2jp5vEJlUEXiAxiaHk2X8iMp0eF2CtlHwQ==
X-Received: by 2002:a1c:1bca:: with SMTP id b193mr1339149wmb.28.1619716852358;
        Thu, 29 Apr 2021 10:20:52 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id f6sm5498593wrt.19.2021.04.29.10.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 10:20:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC v2 0/2] non-atomic req->refs
Date:   Thu, 29 Apr 2021 18:20:40 +0100
Message-Id: <cover.1619716401.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[knowingly buggy, don't use]

Just a glimpse on the de-atomising request refcounting for benchmarking,
dirty and with a bunch of known problems (in [a]poll and iopoll).
Haven't got any perf numbers myself yet.

v2: wrong patch with inverted an req_ref_sub_and_test() condition

Pavel Begunkov (2):
  io_uring: defer submission ref put
  io_uring: non-atomic request refs

 fs/io_uring.c | 99 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 58 insertions(+), 41 deletions(-)

-- 
2.31.1

