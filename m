Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395EC468B6C
	for <lists+io-uring@lfdr.de>; Sun,  5 Dec 2021 15:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhLEOmo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Dec 2021 09:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbhLEOmo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Dec 2021 09:42:44 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC93FC061714
        for <io-uring@vger.kernel.org>; Sun,  5 Dec 2021 06:39:16 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id o20so32319515eds.10
        for <io-uring@vger.kernel.org>; Sun, 05 Dec 2021 06:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G9dGb8Rc+D41L4ghofdZm5DYp0HNPJhArJ2Am+r6QFM=;
        b=Ve2pt2mnCuflzLV36QAo5ckrNBMW/8WVJEQBEJ2rX8IkmvXYgmYRzH+Kq5tgYBDkLc
         LlVDUznIBDeXGTH8Bb3yo3dcnOgdLXf5zoSMfd2PYnwm58xQgZHEWCIUbco561OKHUMM
         nIkreQJZG+q/tqBnwYJbcGidOLcheblLHW5tKDNnN/HITCA+SKa7zV+BmwxUDzGPpHbd
         fPDJMmxZOHd+ibEjC+zp0qlfgMYG60GWJFk4RMMKKC2emHxhxUfNXydxYz/U66X1Ld2e
         xgnUCt0ujg57BvrGVJduaJdIWwAl9K+AHVWnebZOynADhuomD/oqoJ4yvyLUKGEl9oEW
         mA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G9dGb8Rc+D41L4ghofdZm5DYp0HNPJhArJ2Am+r6QFM=;
        b=5B9hrYDOcRpfSbK3Y8u7LaYEuHLHw+YN892pkIvg6oUu4z940AhySu34W0Q0Wor0i9
         VXUyvEOkaxy21NNFpLBc7C5u+bNBKkCBbJ/tD5qmYPIL7MABq45fvSUXhbp1T0HqvJhW
         rbMPRIm02ewAgXB3dRtfFgRP4HDe8XCfVcxFqY1m+FE9gucThZsp+XtRg615l1VJuQTn
         sEMV5PLc6LaWl0rxjzdE9eNgpZlO+I1of1YBTII0XT+sctY4YwAeDBEUrgSEZbqnUk2l
         KVfDGzcTH5pBCGWNFlAb8lfId9v5qrgPFQx3D4rUX07IpPucwp3CdUDpwTC1P+VZhZ6P
         IbTA==
X-Gm-Message-State: AOAM530g48A7pQt9qnrsEX24VpBOjDdcP4X2Y/HFJkICMTGYit4b6yqV
        OxSX/pvLC0p0XvEbEBp6pfDcrj4yUMA=
X-Google-Smtp-Source: ABdhPJw3UNCdqB3U8hDqSyKIKbQgbEwlUM1g0Bkkze7+o2tCdPaEinEVFD59Izd9rAZVPjNYcfOEng==
X-Received: by 2002:aa7:db47:: with SMTP id n7mr45538119edt.303.1638715155432;
        Sun, 05 Dec 2021 06:39:15 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.50])
        by smtp.gmail.com with ESMTPSA id ar2sm5224935ejc.20.2021.12.05.06.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 06:39:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH v2 3/4] io_uring: tweak iopoll CQE_SKIP event counting
Date:   Sun,  5 Dec 2021 14:37:59 +0000
Message-Id: <d5a965c4d2249827392037bbd0186f87fea49c55.1638714983.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638714983.git.asml.silence@gmail.com>
References: <cover.1638714983.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When iopolling the userspace specifies the minimum number of "events" it
expects. Previously, we had one CQE per request, so the definition of
an "event" was unequivocal, but that's not more the case anymore with
REQ_F_CQE_SKIP.

Currently it counts the number of completed requests, replace it with
the number of posted CQEs. This allows users of the "one CQE per link"
scheme to wait for all N links in a single syscall, which is not
possible without the patch and requires extra context switches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 64add8260abb..ea7a0daa0b3b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2538,10 +2538,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
+		if (unlikely(req->flags & REQ_F_CQE_SKIP))
+			continue;
 
-		if (!(req->flags & REQ_F_CQE_SKIP))
-			__io_fill_cqe(ctx, req->user_data, req->result,
-				      io_put_kbuf(req));
+		__io_fill_cqe(ctx, req->user_data, req->result, io_put_kbuf(req));
 		nr_events++;
 	}
 
-- 
2.34.0

