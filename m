Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C254E35DF
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 02:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbiCVBPm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 21:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234503AbiCVBPl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 21:15:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89F42AE0B
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 18:14:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mz9-20020a17090b378900b001c657559290so1019006pjb.2
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 18:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=negmXwx5l3Q/IGwH1HceiHNQnK1aq2/ZKvisCp/Lb7M=;
        b=zUCS5R50ikSaWb8w/byv7vmlOW23iLqQtomeORU7S+slLVIFkhUd6LDrVyEhaEZ0jw
         X8IouDdsaCNBX3svmXcKPh8QRs/aogMX36l+whplaFgq9PqqfKdtWBJvJ9kF/RWiPhKw
         2eYsad+Yit0Ca27h/aVyufjdcMQt2KVkEiq2W/UgjJKVZkMUB39JXiIQwUN/ORrbqKTA
         fLBGFeWcEa9PkUPkbklqIet6FshkAs1PQf3mPXEDR6D/FDLbaqZb7fQwPnsD/VzrYKIV
         d/VYMVcXDstuWhHGHJJKjpNL/t7nAw0mjtTGnSRfDOQLUvF0sabImk+3b05AdQp3A58c
         uPdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=negmXwx5l3Q/IGwH1HceiHNQnK1aq2/ZKvisCp/Lb7M=;
        b=yheGLR/iGU9RgtbrqlWwt4ietSyVfZSRywuBVZ1f0XDm13nYAeNsiAMG+XWG32svPg
         0wIYWvid7V/0g0CaOeeZbb/Wbtt/icgQ418HMRPJiighhf9cSJLhfS1zmKPTINbDQ832
         zL41opGH49H/h5lPaQYwB0eNPe8bZvxWAzJKTELHaqI5cpq3uOoD5tPOsdOJNRM1tUu3
         q3X59WsiqplhHclsNKA73uPX3tX5LzydNXhnWp+qdDlAJ8pR3WtQdG7CnfPSDwG3YD93
         r3L/duYZXLiqi2c91QgskJK4tctLtH7ZNk+/lhsPfPFofnhr6P49sFX3QswrWUrzQgHE
         MNkQ==
X-Gm-Message-State: AOAM533e3aAx++msQYF20Fofm8UMFl2me3EJPpWOpHQ9gahZbuVGfM4M
        U4bqyD0YWw2FrbnLq7JJySVWvSX0qgOXBzj3
X-Google-Smtp-Source: ABdhPJw0Q42yZ65sF4irrvzCPPkp9+bvMejrMDqLtKyAF1nUozwxTYtIikpns0xipppgkOZIEqHZgw==
X-Received: by 2002:a17:90a:ba15:b0:1c6:7873:b192 with SMTP id s21-20020a17090aba1500b001c67873b192mr2060801pjr.76.1647911654053;
        Mon, 21 Mar 2022 18:14:14 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o1-20020a637e41000000b003804d0e2c9esm15748557pgn.35.2022.03.21.18.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 18:14:13 -0700 (PDT)
Message-ID: <d2c97527-2d98-fd6c-2e2d-45c486674be2@kernel.dk>
Date:   Mon, 21 Mar 2022 19:14:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: remove poll entry from list when canceling all
Cc:     Dylan Yudaken <dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When the ring is exiting, as part of the shutdown, poll requests are
removed. But io_poll_remove_all() does not remove entries when finding
them, and since completions are done out-of-band, we can find and remove
the same entry multiple times.

We do guard the poll execution by poll ownership, but that does not
exclude us from reissuing a new one once the previous removal ownership
goes away.

This can race with poll execution as well, where we then end up seeing
req->apoll be NULL because a previous task_work requeue finished the
request.

Remove the poll entry when we find it and get ownership of it. This
prevents multiple invocations from finding it.

Fixes: aa43477b0402 ("io_uring: poll rework")
Reported-by: Dylan Yudaken <dylany@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 48f4540d7dd5..53bd71363a44 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6275,6 +6275,7 @@ static __cold bool io_poll_remove_all(struct io_ring_ctx *ctx,
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
 			if (io_match_task_safe(req, tsk, cancel_all)) {
+				hlist_del_init(&req->hash_node);
 				io_poll_cancel_req(req);
 				found = true;
 			}

-- 
Jens Axboe

