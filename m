Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8C7735B3E
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 17:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjFSPij (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 11:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjFSPii (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 11:38:38 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DB01AE
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 08:38:20 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-656bc570a05so1083114b3a.0
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 08:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687189099; x=1689781099;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KYui0cO/mnX4mlcqUzNFLaaRNsXRHKME7scln9PwPmY=;
        b=fjYD1sx+OxejY2C68TINyQoPPMAXyKO+R62nTyhUESBn5vwhpX3yr17tAf4H3GUN5z
         A5u+PGi33Xwfs8MTfdH9B2adpw3ogB+yk7McvrpoMUFxVLGlIYyDhpBDlr9F/PRk2+xW
         zWGw6cr/ZFwi0pkv8qyS2aGYwutefd20SYmFOGucfxwQ+sZzwOrFFX8e/cT6PG9vbwKP
         tEl2gMNXSnaDfOE7qbjnJ6joP1n1ZbjlcfVH8cgoiRMGe6VjVM8lmdetZ0HEWXbQqLo3
         PrOBCPwPPVa9HApcVt3+UhyUURYbBi2FSqGAvN7Z7SRqn7D3So9J3eoAybwS319tSD23
         MWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687189099; x=1689781099;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KYui0cO/mnX4mlcqUzNFLaaRNsXRHKME7scln9PwPmY=;
        b=YYmgyMXtsbEIQHerJA4n7YoeeB+74mLQDDaOW+nIkoRHd03/GbnE9ufyx0njJ2D3jl
         jtIQD+D+NFPh6L1X65Ipsf1xV4+9VR/m4W1y+lslV7681cazldEhKbCroVctxtwsho6k
         KRm+a70YtUT1/Dpo+50OJhe6QTpmTVK81p0iqD3+MZ1AHEfd744vLMwSFFQD7eGSdCA7
         fVWZJNCKXVq0YSew8AguiL30elTbAUAuoZ8nWWMR+v7oRwHnXE9haRzgJiIsz+wDvpja
         ZQ6dQ1YoGfKBrnPTIPPplwWn/EyZ+lS+fnORLWAS5NxVbTYRMUzj67jQ4xUlgrgdetyc
         S+jg==
X-Gm-Message-State: AC+VfDxh6gq2TzDwkzlxDEkz45KJrn6muFJkHMDf3omfx997Hvlb21Bb
        ffd86lwkU6DEO7ZE0MRXAptfNRzFrqeEFQ/Gg7c=
X-Google-Smtp-Source: ACHHUZ7xMMlVZeRLl5OEOzqi69yN6wAAPsJyFsjrkqOBXOnolljPZEt3UafO89Zl2Z47QQPkDL+URg==
X-Received: by 2002:a05:6a00:339a:b0:666:ed27:2b96 with SMTP id cm26-20020a056a00339a00b00666ed272b96mr9031954pfb.1.1687189099624;
        Mon, 19 Jun 2023 08:38:19 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x5-20020a62fb05000000b00640f588b36dsm17739414pfm.8.2023.06.19.08.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 08:38:18 -0700 (PDT)
Message-ID: <0fd9ed30-c542-fc18-cc4c-140890da5db4@kernel.dk>
Date:   Mon, 19 Jun 2023 09:38:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Stefan Metzmacher <metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: clear msg_controllen on partial sendmsg retry
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

diff --git a/io_uring/net.c b/io_uring/net.c
index 51b0f7fbb4f5..fe1c478c7dec 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -326,6 +326,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		if (ret > 0 && io_net_retry(sock, flags)) {
+			kmsg->msg.msg_controllen = 0;
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg, issue_flags);

-- 
Jens Axboe

