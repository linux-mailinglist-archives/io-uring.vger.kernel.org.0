Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF03A1235A6
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 20:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfLQT1f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 14:27:35 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:44783 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbfLQT1f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 14:27:35 -0500
Received: by mail-wr1-f53.google.com with SMTP id q10so12559543wrm.11;
        Tue, 17 Dec 2019 11:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xEUG81URhogGWuZA8LPYVy7kVF90IzAqZihwg0LU3h0=;
        b=KRKsb9jBr/LuQCoKPkYF4vBZtiJ5xJa95LeQUfcvdwEz2wnXwBRFgO+DGJ2TU5lBUf
         8whgtWhDcScZu4L3utihWI3W3CTu1DWsr2XNBW4dDdEAMdyidsTrJyY73z1BdpOqGXJD
         98cqFMApAKCnsufrsR0zTtZxQ8guNq8OxCUoQR96oPs2TV/G7/c6AGEqnruyG0exSebs
         y78B8/C4VxkgtmKeSQCxS0CM37KdQHseMRpGdg0rnXDuUvsAY0LQKKTTvTg5CHkojvmx
         WQjN1bb3s1JshFma0txoU2rHozm0RDhZLGVK8Q4fqVG76pH58j7po7V1ZBXq6LezBeey
         Upnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xEUG81URhogGWuZA8LPYVy7kVF90IzAqZihwg0LU3h0=;
        b=GdX24PfCo9gnMcaUhTk1W4E2SfM9d/9TLO1b/h13uCcDd8Vv3Oe3ryBnT9NMk0QScr
         XhnYPrCw469lXYMtbq+ZX72iSJ9JLzO2y4UBeNjW25u/xOltmAV3+MDQ1vN8Sedkef1Z
         GnFM5MhRFmlt3B9KjwIza/tzDkSB2aVr+E22gWs3fnSzr58UgAyS2CVhUNrs+NXGN4OD
         XL6cOumHBS4ke5NY8vC2uNI1RGME0iKPrySrMMjJPr2AuUnO8F5SUlENxQe/K1q5Wwvk
         F1rP+Kx1RBUQ1Nl3+NGgE2BY07yjQIHTsB7Nz1RLLubUanUoHKkKj/pSVxcT8ZfjMylL
         CLZA==
X-Gm-Message-State: APjAAAW+upEoz7HqL/xp9zBxoJm7rIIz3/q2rucZ4UTU9V8YGOB582Pf
        Z8dHNCN7gToM0ykKIm1yxzI=
X-Google-Smtp-Source: APXvYqzCF+sd8fQR/RTm9CF4W6DF8PNdlBvLhMGZwhFRiksObjDXkveAncZlVutEcMgiXcCPadwu8Q==
X-Received: by 2002:adf:c746:: with SMTP id b6mr37146849wrh.298.1576610852716;
        Tue, 17 Dec 2019 11:27:32 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id w13sm26711822wru.38.2019.12.17.11.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 11:27:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] io_uring: submission path cleanup
Date:   Tue, 17 Dec 2019 22:26:55 +0300
Message-Id: <cover.1576610536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576538176.git.asml.silence@gmail.com>
References: <cover.1576538176.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pretty straighforward cleanups. The last patch saves the exact behaviour,
but do link enqueuing from a more suitable place.

v2: rebase

Pavel Begunkov (3):
  io_uring: rename prev to head
  io_uring: move trace_submit_sqe into submit_sqe
  io_uring: move *queue_link_head() from common path

 fs/io_uring.c | 47 +++++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

-- 
2.24.0

