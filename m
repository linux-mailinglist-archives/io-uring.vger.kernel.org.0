Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557C0736D27
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 15:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbjFTNV0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 09:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbjFTNVF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 09:21:05 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD24C2D66
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 06:19:55 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-5344d45bfb0so466368a12.1
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 06:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687267189; x=1689859189;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eU9RnZiMJwiRfcP4ZFOmTHKTjOqE0i4uhufE8fvTnow=;
        b=qqCfmawdWjlP0bMaitSq4EF7sOS0arGTcHsnhgch3WTQdWW1WTglzdacE5VQORbtwD
         oHJHOxeusl92GkAEfu1qKj+b5fdBZG/R2r8vsMt5bm91XJQpKRMjoelz6G7SkMqc+cTC
         B4GctLIbM0JP1tu7IZP/vRKK8aevLBIhcAdNQQntdjfUowBsljjyY5BmHZ/5uVKs5QLr
         J/l1AUxzWZLXjb2zBvIKiglRXTncTkzj1AYIkbuK0PfH8NRCMgTxBnzExl0hzHaaskq3
         UKtGVRG2u9/tcc7CVRdcMgJfPuifDKkJFgBEmj7NztRsEQ9VRgU0U9luP2SVQagsQaAf
         2GEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687267189; x=1689859189;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eU9RnZiMJwiRfcP4ZFOmTHKTjOqE0i4uhufE8fvTnow=;
        b=Bk4gamF0CVM3QdzZVidR6SFbN2SkGGq10Wp4BBuuscQb0aJlZREIrIN9SZ6q9Xd7ON
         Yu6Cdw2vXUVTbTKP/KSqEE6juK8Tj3McYfOT6imirY8mAF3scyLaMCzvwpx2YWulx46e
         M6vGEjs9CeK+nOsR+rtvDdvo0gDbRmklzif69hxx+S+JUrgAqsfnF7GNhug7XMZsiUb5
         ePZ4F/GZRMayd6OfmnXL3Hg0+6RKR1ejWHs3rMPG+ChAFwV6ryduChW1p+g6kYy+M+wl
         5zV2fLbnhYskTAji2aBz7j70zbv1FQvcKKu/nkSTgmLaOVNozYfDKh2RJayNe9gahGY4
         knyg==
X-Gm-Message-State: AC+VfDx18PTZ9YDucUv6A+pjuow/SxYQ6ndcgfW8ZRuqHf7GXItj+BuL
        c/XpNLyYiAH6uJnjpQ67ocBBVW3OTqFhetMVGvg=
X-Google-Smtp-Source: ACHHUZ7bnCN/1T9B5q9ngWDbGa4nEpuACtpTMjH7VSS3/WoeE0eJQUfIr2sIU4gHf0Y5jL4mB9QaBg==
X-Received: by 2002:a17:902:f691:b0:1a6:6bdb:b548 with SMTP id l17-20020a170902f69100b001a66bdbb548mr15518545plg.1.1687267189108;
        Tue, 20 Jun 2023 06:19:49 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jl17-20020a170903135100b001a65fa33e62sm1628110plb.154.2023.06.20.06.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 06:19:48 -0700 (PDT)
Message-ID: <312cc2b7-8229-c167-e230-bc1d7d0ed61b@kernel.dk>
Date:   Tue, 20 Jun 2023 07:19:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/net: clear msg_controllen on partial sendmsg
 retry
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Stefan Metzmacher <metze@samba.org>
Content-Language: en-US
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

If we have cmsg attached AND we transferred partial data at least, clear
msg_controllen on retry so we don't attempt to send that again.

Cc: stable@vger.kernel.org # 5.10+
Fixes: cac9e4418f4c ("io_uring/net: save msghdr->msg_control for retries")
Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---

v2: clear msg_control as well

 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 51b0f7fbb4f5..c0924ab1ea11 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -326,6 +326,8 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		if (ret > 0 && io_net_retry(sock, flags)) {
+			kmsg->msg.msg_controllen = 0;
+			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg, issue_flags);
-- 
2.39.2

-- 
Jens Axboe

