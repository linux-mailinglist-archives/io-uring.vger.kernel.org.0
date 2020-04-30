Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DA41C0673
	for <lists+io-uring@lfdr.de>; Thu, 30 Apr 2020 21:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgD3TcX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Apr 2020 15:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgD3TcX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Apr 2020 15:32:23 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5BCC035495;
        Thu, 30 Apr 2020 12:32:22 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e26so3294851wmk.5;
        Thu, 30 Apr 2020 12:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XSDhy1UgSaVZiR7LQEk+1ZlOV8wfY+KtaRK1hgvRZB8=;
        b=D2zxv2qd348r2fIRy+qr1VNRMnM+FSpzGDxLccHam9wO37f/YrodpL5Df35JlEmTEF
         C2VnFLHtMX0wJTOfr3M4Hge5IqTkVQuqHGbGe10u7tMjgBv/SZvWFJEW7dmu1+LFrXX8
         zZHWXUHDKjGD3pGxrawMRVeN3wkPcFQarlSBCH80YHiDIxfffcprFQQ9UyxvPMwgH/E+
         5JvvPmQiNI8Y2/x/9YDtJN/BCDYeLyiC5HWSMlEpKXI0Hc+RWm9ZAhDvoK2p0+AKmX5y
         FQXax0e+Swljc9sg1g4EzN+LMU/hDquNFhFBOjAHUNmaDyAa0jteFqZvXyT08KyYAwQK
         U41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XSDhy1UgSaVZiR7LQEk+1ZlOV8wfY+KtaRK1hgvRZB8=;
        b=EafFSEM7RZUPVUXwO3YkoViaixgVpR8qvSvrzvV7VhzbpgtovUuYOpnaemo47QNvX+
         8yOxh+qmfzMbn8PErm1s52IASmEExmGICrSHvllry4zc++ce5iAMkWbnAt2tnsRfkXtL
         prFGpOM6j5dUyfWHGbpsP/BaucoFq5L+q31xlTJ76fna9+WA4o6R0HT2HhunSYlZibEL
         Dwo+NBf6rEtLtI0mD9+UlKlTPxVv0d/ArQ5K1HoRZJ9A+8tkqJ+YPY/a+2lEqZIdPiOG
         x7U/EgOIS/BuDYLxRKBvIhMU5yQOevKx7TWcxVgZ9wHPKXgEiBOcsrx2rfqaql7LPRwe
         Uvfw==
X-Gm-Message-State: AGi0PuYJc8c8TLtYBD0dxHSeCea9dE6Rnjzt/ZrBDQVhispg+SDgdez3
        WqyYxDvG8ObosKnqtDx2Wx0=
X-Google-Smtp-Source: APiQypKyhkUHSQnDUVnXg36GJuYqe1LWWoyvr/GLx4reSIVrZ7SUzZXpAAjkomhJXELEQ/MtRWQXWg==
X-Received: by 2002:a1c:e903:: with SMTP id q3mr175418wmc.76.1588275141202;
        Thu, 30 Apr 2020 12:32:21 -0700 (PDT)
Received: from localhost.localdomain ([109.126.131.64])
        by smtp.gmail.com with ESMTPSA id h188sm917002wme.8.2020.04.30.12.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 12:32:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] timeout fixes
Date:   Thu, 30 Apr 2020 22:31:05 +0300
Message-Id: <cover.1588253029.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[1,2] are small random patches.
[3,4] are the last 2 timeout patches, but with 1 var renamed.
[5] fixes a timeout problem related to batched CQ commits. From
what I see, this should be the last fixing timeouts.

Pavel Begunkov (5):
  io_uring: check non-sync defer_list carefully
  io_uring: pass nxt from sync_file_range()
  io_uring: trigger timeout after any sqe->off CQEs
  io_uring: don't trigger timeout with another t-out
  io_uring: fix timeout offset with batch CQ commit

 fs/io_uring.c | 130 +++++++++++++++++++++-----------------------------
 1 file changed, 54 insertions(+), 76 deletions(-)

-- 
2.24.0

