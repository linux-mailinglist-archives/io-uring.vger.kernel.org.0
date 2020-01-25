Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BD514979F
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgAYTyf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:54:35 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46732 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYTye (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:54:34 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so6096876wrl.13;
        Sat, 25 Jan 2020 11:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8RoD2H7qPI6zulor9SzhU8VE6jlNRdcnq7GpQz8w048=;
        b=bEXIEQYYqfky7P8l5UlFGMVVqyFEMOHehRjw04BkYmM1bsbMyXzgz3lmRhidXnpBkP
         sXftcM7b/ISwx9VV2Zd/TL4yd4+I3lIuROc3ahhG+/89BdN9AfEkSASH1jjMy7UlWRoW
         f4nlCjZV+opqDnK2oIG1hhqPqRtGonTnx4aYtHDcLsv3ujMVoiFcZH7lbt/994wmj/lr
         itRZwSArZSjEScdbPKyKqMgoJ1hNxgWXKvVe1CdsIZ9U3szqAOKaPpJir4Pr7Ym+b1YW
         9RkoLqSWIkKAxkW9/9gdouIV33cpyoLHUegnZRMMcidX7B/D9i72deHQfvsiE5BfEl/v
         Rcmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8RoD2H7qPI6zulor9SzhU8VE6jlNRdcnq7GpQz8w048=;
        b=T1Dn2rNiFSEZf1UlnNZERJBOvjuOtZkKQYjE/Ko6nAhdZxIUsbioKsuRphygZPNQnQ
         OIZ+OPb8Y2bs34jsKqBlZCbG3Sxcs3PkLGiOwzl54dbmVmX7b9I31RPkyV8lS6bAJAh7
         4cAFNUaKL+8Yr/j+7WmnPWfFcq9/Taj4plEdWyO2sutgA5OE6pDQ6cvZmV2X0LJBbmMo
         xb3nlLHBnusb53eOfvNpA8JgML9LEm+IPUhnd+PkYqwam9S01SQ1ffvuSv/okixm+xhX
         xTVvGQ/cIYxAbrmm9N32nNWDqBoyEox4DiStz20uomE6BiFqpcIbYGxwvuIB8TBbkd2d
         HiTA==
X-Gm-Message-State: APjAAAUZoGfXxfVMoMxiqVZWYFG6ybiG8u+3h6tuDTdai0yxE6CxBSPT
        MYfAGm02e3OpWNz9lGv+k6Gk1PGa
X-Google-Smtp-Source: APXvYqzPy0hxvhKLKHBtGZUdTMIUHOKvXj+rY4kSQvCdkNktl4wdwBeP70ll0P2PrkI5Qg6VDUECDQ==
X-Received: by 2002:adf:df83:: with SMTP id z3mr11545495wrl.389.1579982072556;
        Sat, 25 Jan 2020 11:54:32 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id m21sm11883712wmi.27.2020.01.25.11.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 11:54:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/8] io_uring: leave a comment for drain_next
Date:   Sat, 25 Jan 2020 22:53:38 +0300
Message-Id: <fba3559e833b7d220cf6a12ecbf9ac3856154979.1579981749.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579981749.git.asml.silence@gmail.com>
References: <cover.1579981749.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Draining the middle of a link is tricky, so leave a comment there

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e79d6e47dc7b..bc1cab6a256a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4702,6 +4702,13 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (*link) {
 		struct io_kiocb *head = *link;
 
+		/*
+		 * Taking sequential execution of a link, draining both sides
+		 * of the link also fullfils IOSQE_IO_DRAIN semantics for all
+		 * requests in the link. So, it drains the head and the
+		 * next after the link request. The last one is done via
+		 * drain_next flag to persist the effect across calls.
+		 */
 		if (sqe_flags & IOSQE_IO_DRAIN) {
 			head->flags |= REQ_F_IO_DRAIN;
 			ctx->drain_next = 1;
-- 
2.24.0

