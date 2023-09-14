Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B23D7A09CD
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 17:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbjINPxs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 11:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241221AbjINPxr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 11:53:47 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326F81BEB
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 08:53:43 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9ad8bba8125so157665166b.3
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 08:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694706821; x=1695311621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EUNTLwjP/RVSOZAk4NlZVbxTSIOLiem1kRXOaXqsgEo=;
        b=YhcplI6vnU2LopDzYJnTQU4dYTxyPt3NUCGmUHKvn/PgW2ivBPLZAPjcl80Nou9Wbl
         SYGWUhzvIIjLf0Kodt4heilo+4LsaTpUBS637IdxS7wLBSD9Bwfs5k4CnlWtQNm2qQr9
         mrOUaaLfq57kQSx8SbyhmwHvpq33Bm/+c24BxAFKLMbZvAoBp7r/lkJceTb8nfSn7WZU
         m+5o5WvSMsFiZFA2L9mGBJgzpM6CfiHY3fPcF7gSRLHM72d6tmwORKIkBbVzYkYJIf5n
         BWeAliPISvTDxtwecTh+mUuU5GDCQ2XeWOWsq4wT0LrYC75+Nxj6dj526yuq1H+PnNMP
         yOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694706821; x=1695311621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EUNTLwjP/RVSOZAk4NlZVbxTSIOLiem1kRXOaXqsgEo=;
        b=e2nj0GLxi6j0CfdEAgj5VfpoTGcugiG1n79K1ZanssOzqCJsXzlBLM/ZYgQIVVFtKZ
         I/8Wq/evGPV1EoG0JHh1WMp17YpB7luJGcANDy2lHx47NyNG/VrnXk6RZsjxAxzBHfyf
         23kJuDI6KVQWfW/moq11pealcEzTUnPdZKaVm40Sj1DAW1HQTa2LvrGIhATdzjzV5c/3
         Vkcbc+eEL0X5YX7NzevO/MZZDrquC+CS5VImFnAaMZbBtks4CeOR3sBqXEVHXR+ice8x
         riU/eukmP6917N8mPctf6sKPimzaT+wTaqDSIFwqkTIgEoQpqXLG+VHyad+XHRdh3ffz
         DYWQ==
X-Gm-Message-State: AOJu0YynWrUizZ03vcWOY1jxAdg8oyCXTp3NcWy8tvnRTAd/eFp63KKm
        AlfdL+e0Ft0rnOaEwQ3KTwIUqV9D/DY=
X-Google-Smtp-Source: AGHT+IFQuJv6vGIEyjETwZTjvWXM3frcTPT2qk1BJr/vQdK+nxg4ykX0DJwkQVi/Q1yZZ41mD9ZWFw==
X-Received: by 2002:a17:906:535d:b0:9a1:f10d:9751 with SMTP id j29-20020a170906535d00b009a1f10d9751mr5020263ejo.23.1694706821252;
        Thu, 14 Sep 2023 08:53:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.120])
        by smtp.gmail.com with ESMTPSA id lg13-20020a170906f88d00b009ad88839665sm1201140ejb.70.2023.09.14.08.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 08:53:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com
Subject: [PATCH] io_uring/net: fix iter retargeting for selected buf
Date:   Thu, 14 Sep 2023 16:51:09 +0100
Message-ID: <e092d4f68a35b7872b260afc55c47c7765a81ef9.1694706603.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When using selected buffer feature, io_uring delays data iter setup
until later. If io_setup_async_msg() is called before that it might see
not correctly setup iterator. Pre-init nr_segs and judge from its state
whether we repointing.

Cc: stable@vger.kernel.org
Reported-by: syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com
Fixes: 0455d4ccec548 ("io_uring: add POLL_FIRST support for send/sendmsg and recv/recvmsg")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Can be cleaned up if we rely on UBUF, but it's easier to backport
this way

 io_uring/net.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 3d07bf79c1e0..7a8e298af81b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -183,6 +183,10 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
 	if (async_msg->msg.msg_name)
 		async_msg->msg.msg_name = &async_msg->addr;
+
+	if ((req->flags & REQ_F_BUFFER_SELECT) && !async_msg->msg.msg_iter.nr_segs)
+		return -EAGAIN;
+
 	/* if were using fast_iov, set it to the new one */
 	if (iter_is_iovec(&kmsg->msg.msg_iter) && !kmsg->free_iov) {
 		size_t fast_idx = iter_iov(&kmsg->msg.msg_iter) - kmsg->fast_iov;
@@ -542,6 +546,7 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
 	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->msg.msg_iter.nr_segs = 0;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
-- 
2.41.0

