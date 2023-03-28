Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3972E6CB394
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 04:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjC1CIa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 22:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjC1CI3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 22:08:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57017211E
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 19:08:27 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6261eca70f7so501424b3a.0
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 19:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679969306;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6ZnfBksb7Z/DJpKCd1ngs8/H16KO4vYYQn/LlH3SJg=;
        b=4MScGF/4+Al1sWWIMuhdgr45Ug9q2b/7KkWqgCpM4COrsvClFokNiiCi3UBOatBk36
         FUZa01gIuEygTzn6Aq3aHnHIrvA/eEfQ0DmPIje11sj/P0b6oEaLdfdr4fwBO7xxLYIU
         sIgCiz2jCBGl8u/OA4rQmkRpjHu629SzmwQiDNe/FeL/zPewHDhz6/YfOJOqUxfN7d2C
         HnYxRAwmr7Q55l/sQST1iKngA2wZkKoGSo1qn4QHu0WWW3N1uukhfBn0gyPU8tjHax8d
         TZsXJ+ZLcjZ3+Z4tqs/KWeej+PsvwwgbNQicdLIbUN5jMaO9M2fH/CjA//wGZyCbxO+F
         uhYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679969306;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n6ZnfBksb7Z/DJpKCd1ngs8/H16KO4vYYQn/LlH3SJg=;
        b=23sN8TOPZPmxDx6F5HPSDsNuJm1t2V7v06XEPwAnnGgb3mJO3td2vz3dJ7iXGACYrk
         e6JFtbo4e4gvnK2uprAnZWCJkkO/kuyUba28AUm+fwwfAHiHM/lfGb/1RdXWSU/RLC2U
         nOAKYiFBw5cp/3uPO8b6PuKvEudVVgk1hrOsFCf2/p/1k4K7eaKLP51hJQEhm0hxB1ib
         8K6TnifZaEpxXN/iLaibjjABsvKfdYHhlD4XAqoG0ACcXcBhmWiqA4m6OdTDU6HnPKBJ
         bekTvwpTlUKa2ciQlBtvUcHkVrUv7Kq3fpa4n6qLflZ8GEp8SJImVRCCYO89heVM9UNf
         3jhQ==
X-Gm-Message-State: AAQBX9dwaSljtJd5S5VlR6IYpjzrmphsSEUpuirsid0yoiY0Auw6x/1+
        +h1ChpGNdoSgbjVJzUF+kupFsNN5eNGllD7jnN9gaA==
X-Google-Smtp-Source: AKy350ZwSa7XZ2Gq+/maB5e67BYgL/ubf4jacweKJBgOMQo0nWxa2IUAaKlrAR5Y82fQfadP4j59+A==
X-Received: by 2002:a17:902:864b:b0:1a1:d395:e85c with SMTP id y11-20020a170902864b00b001a1d395e85cmr11465252plt.0.1679969306461;
        Mon, 27 Mar 2023 19:08:26 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jo18-20020a170903055200b0019aa5e0aadesm19821728plb.110.2023.03.27.19.08.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 19:08:26 -0700 (PDT)
Message-ID: <61e3fefd-0a99-5916-c049-9143d3342379@kernel.dk>
Date:   Mon, 27 Mar 2023 20:08:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/poll: clear single/double poll flags on poll arming
Cc:     Pengfei Xu <pengfei.xu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Unless we have at least one entry queued, then don't call into
io_poll_remove_entries(). Normally this isn't possible, but if we
retry poll then we can have ->nr_entries cleared again as we're
setting it up. If this happens for a poll retry, then we'll still have
at least REQ_F_SINGLE_POLL set. io_poll_remove_entries() then thinks
it has entries to remove.

Clear REQ_F_SINGLE_POLL and REQ_F_DOUBLE_POLL unconditionally when
arming a poll request.

Fixes: c16bda37594f ("io_uring/poll: allow some retries for poll triggering spuriously")
Cc: stable@vger.kernel.org
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 795facbd0e9f..55306e801081 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -726,6 +726,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	apoll = io_req_alloc_apoll(req, issue_flags);
 	if (!apoll)
 		return IO_APOLL_ABORTED;
+	req->flags &= ~(REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL);
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 
-- 
Jens Axboe

