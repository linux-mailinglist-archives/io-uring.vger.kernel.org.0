Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74CA32359A
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 03:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhBXCTh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 21:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhBXCT2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 21:19:28 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98DEC061574
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 18:18:48 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id l2so484029pgb.1
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 18:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=oyXp9zbagz8g1fuzolfwFZ/Ang8mwO9bjcDI4/YWYDc=;
        b=UsGHIzl0zijwgq+lPVtYraecrVH3dFm/VWBqN7m79h4UPJoOUA/vM+xJhgBAsPWKzJ
         fipT3GTkY0ZstNnOrRCedcMRfLljp6Lpj5xsug+dHhHAc6nQny5jAWMLuoGtaXp4p9C0
         fEDhs6kV370/X+z7iR+mX3EfX69VR4GWuxJmwF+rbo9HKz6susm1GvfX/YKoNjwwDakj
         KBKYdyisoVBfAmfr+mu0p+xF5I+j377tSnOwkIhx3aLC0GJG8ilqaXp6J3FQSoyif6LG
         tLODv5UHkMncCoM/Z3HFst2awonSncf0eDgd5/IwqSvB7lY4Uv/CDKmVv0tdRrJi9wbe
         827Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=oyXp9zbagz8g1fuzolfwFZ/Ang8mwO9bjcDI4/YWYDc=;
        b=pW7BAjUHYhjWorAck0xUdJgkc0d2a7uyJiZgP2hjWZrqPA+Y5p8/KLlDyJOlzGcGR1
         f5i1036FH4uQReYBqH+to0vsk1UFgilZFIN4+3SuxLKTefg6QL6L1z2vpWVQB2fsjrhe
         Ou80igpmEyLc/6/jbT7TRXaXb+Ls5nev2wnj+fbVcQevaPp1EYBymng6qSfv8tjcSIvN
         yB3VIXFMKp2TezLWGeg7Ju5yqMBNQMbEYh5spVO8LuvcqBPv600c4a90xx7q+9AlRfD4
         wB4Kpv3bgsj4X0pTv5ay3bpuU3kgB+hKps1CG1BbNk82DgEofjjiV/ntA5Bikr80w94C
         SQcQ==
X-Gm-Message-State: AOAM5322OQj3kuEJKudGOQ/L+QaniFHQ6eNfaH+95f1As8PXXqji0qcA
        zESmjYiBWaJ5kwLekken2qVfG5rMpVAIcg==
X-Google-Smtp-Source: ABdhPJx7WcQWb3Km9n+QRrEV1a9SzS2RwOcBza/faNUx9yUIbsT8/Dvu0Kha232QIbmAJzKrbXR/MA==
X-Received: by 2002:a62:ae18:0:b029:1ed:ac95:d8cb with SMTP id q24-20020a62ae180000b02901edac95d8cbmr11675195pff.69.1614133126884;
        Tue, 23 Feb 2021 18:18:46 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a2sm497503pfi.64.2021.02.23.18.18.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 18:18:46 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't attempt IO reissue from the ring exit path
Message-ID: <c9f6e1f6-ff82-0e58-ab66-956d0cde30ff@kernel.dk>
Date:   Tue, 23 Feb 2021 19:18:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we're exiting the ring, just let the IO fail with -EAGAIN as nobody
will care anyway. It's not the right context to reissue from.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf9ad810c621..275ad84e8227 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2839,6 +2839,13 @@ static bool io_rw_reissue(struct io_kiocb *req)
 		return false;
 	if ((req->flags & REQ_F_NOWAIT) || io_wq_current_is_worker())
 		return false;
+	/*
+	 * If ref is dying, we might be running poll reap from the exit work.
+	 * Don't attempt to reissue from that path, just let it fail with
+	 * -EAGAIN.
+	 */
+	if (percpu_ref_is_dying(&req->ctx->refs))
+		return false;
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-- 
Jens Axboe

