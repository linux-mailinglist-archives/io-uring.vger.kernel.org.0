Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70EBD149776
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgAYTet (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:34:49 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44769 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYTet (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:34:49 -0500
Received: by mail-wr1-f67.google.com with SMTP id q10so6074978wrm.11;
        Sat, 25 Jan 2020 11:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=82JZcqh6qYU+2jSmoXnBYDPtQm7jo0Dy9k4oselAfsA=;
        b=sbKU7ctix9s7eHmwQilaO4kNFWuxNgwBiUTGZfiiY+VO/i5M6ywJIsvZc8ipXCKDna
         LFIG4HV7bAiZX1NKOOrC74zGIAfFe6iXVQPQvrpDHj/yWOWir8zptb+ykdCyvu21B2e+
         mV0bYXGV95qeCSi32pm8Yb4ExRvKlbhar87OpEzUEm9R2JwEqfeVoRirLUOrrf8tESzE
         vPzwNUBMK7sFtX0BtE8JVrr50uaXEuvFNV7jZpXxEt3/4zPvua+joQUpr2jMX7By11lQ
         fB0+T6wpH7b8PalQjf3sUZYCJRCWp3YjJ0ZAI5d5dpz6BAKf8Gj8rOJ3TZst9ocyt+HP
         +QNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=82JZcqh6qYU+2jSmoXnBYDPtQm7jo0Dy9k4oselAfsA=;
        b=T2qb/hK/oKHQvPLAPpQvhAInVXVatoFJw5hAEwnK1H+CJ5k99PZSbjl/GLuHjMYp1Y
         BnEjjcYCRtl4HNNRMh7+TMJyIXCc6gtbxURqKxyhSJoKbkxDjQzg6Z1vZyvMgoiPF3dB
         /lpMKzjc4UjTWttv0iQ2uIVL+L9y3x6WitSmT2mXXLy7muRi6ne+aOvzNQt9OiF6vepU
         8qwN9gGk1I5IIdmmZK95VLZDEVIEKJ1IZ4eQO3VvTmNWe0Hh25hnRELAsrjhMOnvHVIV
         FFunivJQWr+7UomwoKS3Zj/FlNMCvCRyuJmtftOUAfgieQTvsvl9q1+Ww5VeFXPOofAI
         v++Q==
X-Gm-Message-State: APjAAAVj7O1sTX7weMuQlbke8zmle7bNDhqZD00Xla6wRw7rU3DO/8IK
        4DUSA9fmqJECUWsa9fTq89g=
X-Google-Smtp-Source: APXvYqy1Rmc7s5O8QczWwmaQ1K4XBwZSHniHdOJajdSmwK8YdcmwHYHwD5pEGVlI6OnWdSZGysqwwg==
X-Received: by 2002:adf:ef49:: with SMTP id c9mr12296497wrp.292.1579980887112;
        Sat, 25 Jan 2020 11:34:47 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id g7sm12843472wrq.21.2020.01.25.11.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 11:34:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] io_uring: fix refcounting with OOM
Date:   Sat, 25 Jan 2020 22:34:01 +0300
Message-Id: <17022002efedf99758627055901c94d9fa344ec9.1579980745.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <fa69cae513308ef3f681e13888a4f551c67ef3a2.1579942715.git.asml.silence@gmail.com>
References: <fa69cae513308ef3f681e13888a4f551c67ef3a2.1579942715.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case of out of memory the second argument of percpu_ref_put_many() in
io_submit_sqes() may evaluate into "nr - (-EAGAIN)", that is clearly
wrong.

Fixes: 2b85edfc0c90 ("io_uring: batch getting pcpu references")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: rebase

 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 25f29ef81698..e79d6e47dc7b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4896,8 +4896,11 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			break;
 	}
 
-	if (submitted != nr)
-		percpu_ref_put_many(&ctx->refs, nr - submitted);
+	if (unlikely(submitted != nr)) {
+		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
+
+		percpu_ref_put_many(&ctx->refs, nr - ref_used);
+	}
 	if (link)
 		io_queue_link_head(link);
 	if (statep)
-- 
2.24.0

