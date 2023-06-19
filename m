Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60C2735B4F
	for <lists+io-uring@lfdr.de>; Mon, 19 Jun 2023 17:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjFSPno (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Jun 2023 11:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjFSPnl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Jun 2023 11:43:41 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B614137
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 08:43:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-25e847bb482so550167a91.1
        for <io-uring@vger.kernel.org>; Mon, 19 Jun 2023 08:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687189418; x=1689781418;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZVJmz3VKpOh6JlqUK3dY5kdfxq6JBueTbyK64FEpWo=;
        b=aUGzZS1U4wAbWzATN9YD5eFpChc9X7Cou5Ht8pv6ngmSvSWSYQFArtFxC9yZsKq1uv
         yJGJMixbe0M33luZP1HndEBRVdZXkdMXDRqDf9HPryVVsgE46zyCFBx+fzs4EOywUMH8
         dM7VB5KhSjoM+cGU6njqIQg84kltMJ9HGqM4MoHTUNYPI7PuIOxb3HSEXYYgWn9Y/bwu
         /OhbvT/ITayHAWxbBlBtEgDzY7Ve9tlcsJeVwSNSouVIRYj2hsrxoG6nqbQTDvK6b5Xc
         lbjn873K7OvKlmlu12JqsTseD0PLbuWMivrOQJixvn49g9xNuu5LZVbme2A/w9Fnffk8
         0ZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687189418; x=1689781418;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uZVJmz3VKpOh6JlqUK3dY5kdfxq6JBueTbyK64FEpWo=;
        b=B8f7dP6N0tlq5KC0Ju4QoM3aNDfeXk0RS5LtDjQS0FNdiLuCGnO0yODmSrNVxXQAkF
         SDfkGTWJemD+2/OjIWE5aJ7mqNy30zqbRIy3XFCoG9fTayCzxJtpgu18ITuQGOb32DFq
         ZCWWtRNgIuwGxLVOcuP/+kMGqhSSSa3T7JUYiLCC0MGoevkCPuZm5c0VDbvIJLEyayYH
         xDCrc3TMuNAD+mvPcN8XQvyjTXN3jSprrto0ITyuvj2Rr6VWC4sX2+RoKWgjDdcW3rJg
         6mQcRbLoGV+UKFX4B2Gn3A1SlskzfWsMDtJm/gMAj4oz2xYUr6lVQFA3akFnQXI4ns4j
         Idqg==
X-Gm-Message-State: AC+VfDxMP/fo4O90dspvCMjREiMObugj5UdnCWvXaLw79ZeJDdpM/WF2
        Ha+EoFFpOl5EL/lc92Gw03Dwr49HzVZnA8kDjow=
X-Google-Smtp-Source: ACHHUZ5j2HnBCjb5xdbYRXS+J7DHvKTOtg43wfNiEZ0sDtGQiKXnOxhkk3KQAJhEwZ2k0svgnqUVZw==
X-Received: by 2002:a17:90b:164a:b0:25b:e83b:593f with SMTP id il10-20020a17090b164a00b0025be83b593fmr12627916pjb.4.1687189418420;
        Mon, 19 Jun 2023 08:43:38 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ms7-20020a17090b234700b0025ea87b97b9sm7273617pjb.0.2023.06.19.08.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 08:43:37 -0700 (PDT)
Message-ID: <472c1b08-0409-bd55-7c4a-6d33f07efced@kernel.dk>
Date:   Mon, 19 Jun 2023 09:43:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Stefan Metzmacher <metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: disable partial retries for recvmsg with cmsg
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

We cannot sanely handle partial retries for recvmsg if we have cmsg
attached. If we don't, then we'd just be overwriting the initial cmsg
header on retries. Alternatively we could increment and handle this
appropriately, but it doesn't seem worth the complication.

Link: https://lore.kernel.org/io-uring/0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk/
Cc: stable@vger.kernel.org # 5.10+
Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index fe1c478c7dec..6674a0759390 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -788,7 +788,8 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	flags = sr->msg_flags;
 	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
+	/* disable partial retry for recvmsg with cmsg attached */
+	if (flags & MSG_WAITALL && !kmsg->controllen)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	kmsg->msg.msg_get_inq = 1;

-- 
Jens Axboe

