Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BF8349991
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhCYShA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhCYSg4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 14:36:56 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D7FC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:36:56 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o16so3359690wrn.0
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tvHoPsHlykmB3tsBvouRHNn9J8rs5KuPMplAiRZi9YY=;
        b=gPs/MfERcQFuls/1vBIt6vZWvML7CImkN0gnLxoi8XOZdOC9I9VmjvwHRXRsHrnDan
         RU5nRoTO9AfS5DIPa2ShuFuiOh52htL3UJIjkJCGpnfTO4z9sok6LBEvUMXZrtHlyTHx
         GUh93ELNFbWNeX2WTQikXEaIHQtLvN7Mom5ptTlcfoZZdjitHvaZrqjuyKuHARiAs7uO
         jaJpPNDeM/VijSXEQptqXSj+P2OIDUzEt5IMDbLOcK4nNzNLrXfyieRORfqfX+FaHdzE
         eY5+W6ajX/ZXkyUVpso2J1uxCn/Ew5rC7vuXw+ucNUhA0/DshQCTlVB3KB/BUbWw7URD
         9uUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tvHoPsHlykmB3tsBvouRHNn9J8rs5KuPMplAiRZi9YY=;
        b=CTiSjbGGMekUGIRf/Q7iOleskkcLW/1fFAy5q1myWkJ+zOvyE7ZMor+W9uDbUAXIvj
         TFBnIRneoj3pa9lNHaX8S1ldZ0bFsdcd4FQ6l5iTH5UNBfgMXc/rRJUJd0zKcNrGLN7Z
         t4ABAZ3rEFkj56ytDYjVU3cROxztPmi+SnuSmjyU+ZTthBT79KQpsKyvarFQ21w8kv6u
         uc/Sty4M4RC4NQ/8kMC1q6c6mus0qIi89Fv7g0GFTjGd/KR09lULqh0Ba5iYB9eJQ7bP
         hifnVV11Gbd3gK/udL02KoBomLhnCOo9eUr+Xh78NACVjio+DBNhqmVcekRQcbA3zW1M
         +bMQ==
X-Gm-Message-State: AOAM53336MkDVZbvAcCJ4KjMwSYX5Q7Q2i9Dz+SbWh5JEWkDP8MPfj44
        LFeSHFr3PQrU4/X/5dyCgto=
X-Google-Smtp-Source: ABdhPJwNn3faiN5O2Kudn3ie3kBNz2dxcGg7w7sbs29fv8q0bfUO7L3Q4wzhR3v7l1SrU1UQzTiNkA==
X-Received: by 2002:adf:fa41:: with SMTP id y1mr10277485wrr.256.1616697415330;
        Thu, 25 Mar 2021 11:36:55 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id p27sm7876828wmi.12.2021.03.25.11.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:36:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: don't cancel-track common timeouts
Date:   Thu, 25 Mar 2021 18:32:44 +0000
Message-Id: <104441ef5d97e3932113d44501fda0df88656b83.1616696997.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616696997.git.asml.silence@gmail.com>
References: <cover.1616696997.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't account usual timeouts (i.e. not linked) as REQ_F_INFLIGHT but
keep behaviour prior to dd59a3d595cc1 ("io_uring: reliably cancel linked
timeouts").

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3fcce81b24cd..fabaf49fefa3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5564,7 +5564,8 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, CLOCK_MONOTONIC, data->mode);
-	io_req_track_inflight(req);
+	if (is_timeout_link)
+		io_req_track_inflight(req);
 	return 0;
 }
 
-- 
2.24.0

