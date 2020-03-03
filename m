Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4F1178277
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 20:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgCCSeR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 13:34:17 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53990 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgCCSeR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 13:34:17 -0500
Received: by mail-wm1-f66.google.com with SMTP id g134so3105167wme.3
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 10:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0v/hpkdlka9xmvrvwRUendrWGjEfhpHU5vMwDSGb0M8=;
        b=KjsdShcLxbM5MWPWRSNCrlDfFVarvf11lx1hlS1pl0MOELJUQ1OMsaCeDhiuRiihGX
         ArcQl3ZRVF4rS6AbjyRmXKWKvLVw4YqKQzLXe/3iw1cg0sAkdVNQu403680FRXI8N/vN
         +4q/ZrWPvGKHxy/ZHNowca864MUQeZRcoozUXzTo31/LtSfn2Ht9I+zSyCnXKr+4yRiM
         +CWnQMCOmXKV2yzyU5bCVZVV2DhIiKfrAkHH2nv6kk/wfBu67v4q8KUhh2BrRDxB6DJC
         k5bOwYdFQoZyL5WVa1a5VXPlGIwab2vzzyP97d43kVaq3uw1XdTz7VajSIe5OB74ZULl
         Id3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0v/hpkdlka9xmvrvwRUendrWGjEfhpHU5vMwDSGb0M8=;
        b=IbgsPHcIIKJztAERpesW8w6gKwKJTSrz7TtmiAZavlF4l0ZW4o4Ef6eBZhcLgoa3UJ
         Q+S8h9SvikdA9kfP8wiKhU2nDOUb/ulxjLH9KYq8Q4/ZBoBdOmrgT4pCJqPlD0pfNhVD
         xsWMKIxvIYXsOupB0xpg//OB1xVoYxLHS3iZyJ0PHoooPVSF4SYVsdAktdqQd4MNsrKw
         RJHhResckh0Ju1aFzJijMHJ1YQkfYbKf56yiK+6yJTZXShY9XbjKT0z7aglojJgvlvz9
         KWFYLt+p2ji7NobrljCKjX+fiQ9P2KdHm4o+URWdoz6cDaKivcwoyp+1XOZGoYtFnuwJ
         72Iw==
X-Gm-Message-State: ANhLgQ1Llsebq9/j8vAvsDM2uqD6+YSTHatrKWrO4b2UFPKXLaEY5Mnd
        Mqlw+c9Ws5gADcyDaxNx5Rs=
X-Google-Smtp-Source: ADFU+vtIebLXatb/jHLkG2pieB2nHhvp4trSKsszeX9m+XyYCLBK3tzyR7pTB4AqtEn4J5XlUJfZ8g==
X-Received: by 2002:a1c:dc45:: with SMTP id t66mr5550682wmg.48.1583260455542;
        Tue, 03 Mar 2020 10:34:15 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id f3sm4548191wrs.26.2020.03.03.10.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 10:34:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 0/3] next work propagation
Date:   Tue,  3 Mar 2020 21:33:10 +0300
Message-Id: <cover.1583258348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The next propagation bits are done similarly as it was before, but
- nxt stealing is now at top-level, but not hidden in handlers
- ensure there is no with REQ_F_DONT_STEAL_NEXT

v2:
- fix race cond in io_put_req_submission()
- don't REQ_F_DONT_STEAL_NEXT for sync poll_add

v3: [patch 3/3] only
- drop DONT_STEAL approach, and just check for refcount==1

Pavel Begunkov (3):
  io_uring: make submission ref putting consistent
  io_uring: remove @nxt from handlers
  io_uring: get next work with submission ref drop

 fs/io_uring.c | 307 +++++++++++++++++++++++---------------------------
 1 file changed, 140 insertions(+), 167 deletions(-)

-- 
2.24.0

