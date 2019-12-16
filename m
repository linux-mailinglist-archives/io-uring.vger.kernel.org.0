Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B70121EE2
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 00:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfLPXWt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Dec 2019 18:22:49 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:39690 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfLPXWt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Dec 2019 18:22:49 -0500
Received: by mail-wr1-f54.google.com with SMTP id y11so9290652wrt.6;
        Mon, 16 Dec 2019 15:22:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fxKG3traXF8YIKIxBxzCjXEb3tqKGp6fkTjWJYak5EE=;
        b=bG75PKs8MwDHE5E1k/q7tnEGiifHcAwgJxyaAJSejbC6B2hMcRXIrkOSYAtTxx/lUg
         XkMwgToH5uKuGOGzE2TkAO3Lsdm1JDlqdiqn9cClQ1UN17Lxs1mZCVby9mqesfQZggUY
         sBBJ+S1XSzmBnCVI1NLzZbUVxfiDbsvhdod84HA+hMP7Vz7m2NDbbgUIkNuyHqG7aK4l
         S0zOm3fhpq20GgeYDoLbjexaaw1nSVc2Rkqp62QbCVyE70A96a4qSnJzYDIjZWzTjgNR
         dknyw+18tEW3/lEOh81Rx6BSYzU5t5JI1EUNBuu55Qhw22vPo4g/DnLE/70ZBbJzWnOU
         4Htg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fxKG3traXF8YIKIxBxzCjXEb3tqKGp6fkTjWJYak5EE=;
        b=kTsAEWOubYPJtfwcdcavlwv0u8W+x68gnrGS0pmI8YbYs6LcpiSVOuiX64vmF7O1hW
         QZ/io57YEEKBiwXrfnmUsjkn0mqtV1CpGYWSHOAti3t6Ss5OLQP2puJbIoCOTeAsjJsw
         0jRUW5vqIg5POjthlfyQ67/Isb9PCRiant8xueoVORGLH3y5VMV7UD6XFynUYwpQaTUW
         16t0sAqecgWwOmoMOY4adVJbYrYVGf/G526/Jegb01cvwQt24NpQs7C7jXOtk64sbLON
         4G/iTdsIVmj7naj2dgGWASDeu8cwn2NEIu1Tt1Hn2TQhMyMbbiAdxpa4qHHArW1V7EWB
         gEiA==
X-Gm-Message-State: APjAAAUyPqbryaTrnhcsa0vGw4VUNcOKybB6mlfHbH7FOuXiHFKVgirE
        A8+zk/2WJATOb1beETfZJyeKMHwM
X-Google-Smtp-Source: APXvYqwj6RxSsE6t3UYpHDe+I/F0HOlawfmUJB4jTivYialHEtdxBFDcpb54GtWRZoKT7J3ePDcUKg==
X-Received: by 2002:adf:e6cb:: with SMTP id y11mr33954992wrm.345.1576538567455;
        Mon, 16 Dec 2019 15:22:47 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id 5sm23526167wrh.5.2019.12.16.15.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 15:22:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] io_uring: submission path cleanup
Date:   Tue, 17 Dec 2019 02:22:06 +0300
Message-Id: <cover.1576538176.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pretty straighforward cleanups. The last patch saves the exact behaviour,
but do link enqueuing from a more suitable place.

Pavel Begunkov (3):
  io_uring: rename prev to head
  io_uring: move trace_submit_sqe into submit_sqe
  io_uring: move *queue_link_head() from common path

 fs/io_uring.c | 47 +++++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

-- 
2.24.0

