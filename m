Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C230940A490
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 05:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238998AbhINDfD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 23:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239040AbhINDel (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 23:34:41 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74934C061764
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 20:33:24 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id t190so13206115qke.7
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 20:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=pFa7GQIxXWl0c/uM3483yackGoLHK0NgaO+2cmzz5Nw=;
        b=wEpIkxBpc62PNnC88chQDJ6zl25RE56F/I9noxOjWlQLPwUG7cqnrdLMG7Wlk/LPnd
         Zm0E4bQI9M4k1UtZNyWF7wCSNgsKxaMFD4UNfcxkXMMfDVnjGPQ8M62e5Dnj6Jc6BrpB
         b5LKHdaK4Fq8cywiuL0lJxpzyTt+UP8nP/hFKMZkdqvbul8SNTDL4H34hOfutmA0ICb1
         /410R7ECIcMMAC+kBO8BDZ0co8cHwwCm/YNfySjIvLgDLCHHnV/01gNm1lxD9uFNhedX
         2J9FAsPgQ8h6ts8zlKrCJQXt626+kaQdlnB5snN96wzL4diruTl78Bl8L70wplAugZoJ
         KfMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pFa7GQIxXWl0c/uM3483yackGoLHK0NgaO+2cmzz5Nw=;
        b=Nn7yqapUFyLBsyVIvfVxRxb+gt+5kNAuJrpXI7bj07jzEdENp/EftdzEHM+lrFBD/w
         Bs57XdwMd0vyjKPJTJkC85btqQVw/M22NaLzJop4dbd5FuG4WFHrghzeujypod2aKLRu
         S/7ck8bFmNdPhAXSzuUlCBOc60QzaVzUem/hIJAB/7cOrm852oa8+hLmx+STtvWwyg0p
         L10GA9gTSJvjWL58plkMAmPZafDHFrMZdTEqpYA+zJ303bS6t4tBk2JC4+wwmHi8DYWw
         6a+Pd7rtYhGeF4JUCdX62EwgUZPuCC3SmXfIBLKCQ0T8G/Jge9Ucod1JKhbPbcLYhgg/
         hxBA==
X-Gm-Message-State: AOAM5320VvrkFBIHSDolBLpbXVecLgyNYHsb40m2bOBC9BBL592i9g47
        rJVxAiZ19f5sSeLPKHME5DWr
X-Google-Smtp-Source: ABdhPJw+Gqp/QaKJUPx+eMnsA6HZ3RZzmRCYKVzNF9XtqTZeCyQUZcicJKwDykSIlKMgYCUZ69zReA==
X-Received: by 2002:a05:620a:448e:: with SMTP id x14mr2935347qkp.526.1631590403616;
        Mon, 13 Sep 2021 20:33:23 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id t26sm6530426qkm.0.2021.09.13.20.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 20:33:23 -0700 (PDT)
Subject: [PATCH v3 5/8] io_uring: convert io_uring to the secure anon inode
 interface
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Mon, 13 Sep 2021 23:33:22 -0400
Message-ID: <163159040254.470089.7192304410101378968.stgit@olly>
In-Reply-To: <163159032713.470089.11728103630366176255.stgit@olly>
References: <163159032713.470089.11728103630366176255.stgit@olly>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Converting io_uring's anonymous inode to the secure anon inode API
enables LSMs to enforce policy on the io_uring anonymous inodes if
they chose to do so.  This is an important first step towards
providing the necessary mechanisms so that LSMs can apply security
policy to io_uring operations.

Signed-off-by: Paul Moore <paul@paul-moore.com>

---
v3:
- no change
v2:
- no change
v1:
- initial draft
---
 fs/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 388754b24785..56cc9aba0d01 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10155,8 +10155,8 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 		return ERR_PTR(ret);
 #endif
 
-	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
-					O_RDWR | O_CLOEXEC);
+	file = anon_inode_getfile_secure("[io_uring]", &io_uring_fops, ctx,
+					 O_RDWR | O_CLOEXEC, NULL);
 #if defined(CONFIG_UNIX)
 	if (IS_ERR(file)) {
 		sock_release(ctx->ring_sock);

