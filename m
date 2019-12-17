Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61DA4123A51
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 23:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfLQWy5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 17:54:57 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37428 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfLQWy5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 17:54:57 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so63273pfn.4
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 14:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tbxMjSChQoXBEvJObx1sR0MbG6fIkWlSHce+VTD9BPU=;
        b=FnXvsFQ5Q+ZfiXjqLEsfFS/9wHg08d2wDtRMqygMCeksW9YYOMjra/spcAJ5CxcR1B
         NNfyJLJGus2wBvEi2UPl0zb9Af0Yir2nPFe9j9NwA0N42l2rMoFlMqgSZbIu8pX8m3UH
         Hp/Crp7ynTwgECk1kKd3C5J8FGNL1oryHRnGbHOMt8345KDG/WrXflbvF/igq0O0N0Uo
         DzOfX0FXYnTdr89+kHnKIBzU4kDHQm5V9Z9jX5P/2HBB+uvMuGdslVPWHRFPZPNpmz7Q
         cWc38ByY4AkMZUOEJNmXtENLdtsQ91g/uI3m+VmUKM1Ebiwjqf8b/8TaVL01JJqzLuSd
         4ocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tbxMjSChQoXBEvJObx1sR0MbG6fIkWlSHce+VTD9BPU=;
        b=YKSIzimCg526Xqjebpzqx0LRTG/rum21PmO6thvu6CaJ2A8+RNZngZ1JcaUIl7sxT2
         Ix34nn2n3sTlvbSx60Ucj/xi+cZYeLQwM1tbt0Ma3OWkYh0m8WAccZGzADInn4vPW38V
         zxJs1oGO1TD+8fZ3YJfGXGGapCSr/pvrpFckQm+7StpMXFxFIVkwCugsDZ+vaeoOeXrI
         BdG/kPlov2sN+xaQ5YmZpU1Lb9aSZOZ2qYKy2CDMNuDAhIJp8JF1PgVPJbjU+gIuhIfq
         3MrW7FLnVckZFzUTghHyOw70l8Gg5I0VK5kpSgV8MyA4T8obPhZvL0gk+EO8MnwL9D13
         vbnA==
X-Gm-Message-State: APjAAAVsfwnxbG0zkj/wZxpwjAjEnkFUBI/hWnoSkmGxMQlJhn+0+MSL
        l8g42yibJ+36unD+KCoISIXWderVL8B/wg==
X-Google-Smtp-Source: APXvYqzLSXCHp96a6nZlaC9rpgk2Gb2vmfMH+aRDF2eO5FebvnFDBqiWxYzCojJx7yLmIwZGvWA92Q==
X-Received: by 2002:a62:1c4:: with SMTP id 187mr117981pfb.184.1576623295591;
        Tue, 17 Dec 2019 14:54:55 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e188sm59320pfe.113.2019.12.17.14.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:54:55 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] io_uring: make HARDLINK imply LINK
Date:   Tue, 17 Dec 2019 15:54:45 -0700
Message-Id: <20191217225445.10739-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217225445.10739-1-axboe@kernel.dk>
References: <20191217225445.10739-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

The rules are as follows, if IOSQE_IO_HARDLINK is specified, then it's a
link and there is no need to set IOSQE_IO_LINK separately, though it
could be there. Add proper check and ensure that IOSQE_IO_HARDLINK
implies IOSQE_IO_LINK.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 667785634848..5643701d70d6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3693,7 +3693,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		 * If previous wasn't linked and we have a linked command,
 		 * that's the end of the chain. Submit the previous link.
 		 */
-		if (!(sqe_flags & IOSQE_IO_LINK) && link) {
+		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) && link) {
 			io_queue_link_head(link);
 			link = NULL;
 		}
-- 
2.24.1

