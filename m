Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4732335F2
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 17:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbgG3PqQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 11:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729857AbgG3PqJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 11:46:09 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF46C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:46:09 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id c2so14434039edx.8
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 08:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oTTdrcaTMyHwjr9vV70bBpdiXIVokLVL0baUi9mqkfk=;
        b=iJqU0X9/OX27PYBfkKlPCuAKgln4xl/fLw2XugJ4Z1sLMsrJ11VLk59YEsHc6SV4Tj
         Y1Ugeo+q+PQHUrWdavHGgae84M87R8p4HSIczQAYCuXnayvXjfvnSBkpn3gJU6nYJGmH
         JZ0+4EdoEEtHEYtOwKToKUtLufisXE3WDwwgHEo93CuWM9TjfcWzZaPhS8zUVQ+mYGa5
         yY1gBoUgiiETW7jTqKvm/sCO0S38BM+xC3nt+m8PNRgIpSHGrEgD+K7dpsDikVF5f8Nm
         Mjqd0KKOD6q4RkexmY9ZaED2kSMadNOF2oGIz6noYTJRTWwpjlPkIte+Pk95GO0b4gLV
         8FqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oTTdrcaTMyHwjr9vV70bBpdiXIVokLVL0baUi9mqkfk=;
        b=Fqn9Bjf3xHHiFqfdDAqr9V78OaISoygLG61hD/buoCm57TUO3VIqawOcgm5d2zC7gE
         ILPtYmrBWg7R6U3stOZQZ5dThB18XQpFTePJxzH1uD982QEjiNupfS1FnVRVpjBbvdL2
         KflIPC5hJFEpXYsQoAneDTNCD7JslFM/Gc+0UzSjhIrwuhB9OMRkrv8/vf1e50jTkdgx
         AODRCKhlM+WgjiD4RoDUO+mybJZtTV/3vq5tAPs4MovxQuisA2LLqbr9x5JiQLjlEpUo
         oaNooXd4Y2S6+q+7k8jnfrLd/HdMpTPyedCxWOuugPaFGIdeGLm9yDMx2EAo4+453OAj
         +wZA==
X-Gm-Message-State: AOAM532YIItPrPRC56SSBRkomFfFiis/SzOYCPlyx8SuXK1Zrk/MXCZX
        +irkcOtdgTLv/PfvrdQdyGnlkBKh
X-Google-Smtp-Source: ABdhPJwWBgF/MtdlcbJUIqazjejnjX2Uofbfd9MBfXdG70TtIDKvAJ6IWp6S8BhegfoHxQrD28uh5Q==
X-Received: by 2002:aa7:ce84:: with SMTP id y4mr3314463edv.113.1596123968328;
        Thu, 30 Jul 2020 08:46:08 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id g25sm6740962edp.22.2020.07.30.08.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 08:46:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/6] io_uring: fix stalled deferred requests
Date:   Thu, 30 Jul 2020 18:43:48 +0300
Message-Id: <30e165f10169a0e88a8b052061158b3f8442ea52.1596123376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1596123376.git.asml.silence@gmail.com>
References: <cover.1596123376.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Always do io_commit_cqring() after completing a request, even if it was
accounted as overflowed on the CQ side. Failing to do that may lead to
not to pushing deferred requests when needed, and so stalling the whole
ring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e2322525da6..11c1abe8bd1a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7849,6 +7849,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			}
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
+			io_commit_cqring(ctx);
 			spin_unlock_irq(&ctx->completion_lock);
 
 			/*
-- 
2.24.0

