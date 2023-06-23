Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8318973BD05
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 18:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbjFWQsS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 12:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjFWQsL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 12:48:11 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A282720
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:10 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b5079b8cb3so1764025ad.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687538889; x=1690130889;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KEleUU+j2wuxiicRZulGjfSldtO2buMUZsi/z4ziK+E=;
        b=lUwhhOHGNXliIYqMP4M9AS8F32+KfVJrqqYAerk19ta9MGYNgQ4htk1CzO2v7JeCGh
         I3keGrbVqpX6cw2VZJQ9mL/K6XoM34Su7DaHj7lsrt1t2K8TIkUSUkyPh1b0YKoHBVCX
         gWfoTNheO8WLET3hsMyo577h9hTLBu0N8VmH2dMQLR5e8RNilvmW1AzipECVa1xGsdCY
         /UBHqjwsCZAgZfUTwez/O5ETuqd06wnVuEGfSMhcKkWxOLoh2F4vEBgWqZg+EMN9ODzL
         zwzAUotjp3imBg3GjACylOrP5VswfAKtC3/6rRJCDMNUsBTOjfyh9z22RHku4lBZeAMq
         u3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687538889; x=1690130889;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KEleUU+j2wuxiicRZulGjfSldtO2buMUZsi/z4ziK+E=;
        b=lHZ1Xz5EXZGvmLSqKk4VV06wE7Y5hFQaPpRrVvW8sN/B87yyqxtoJ1XPgT7qCxruGF
         CphIHAS/0hXkiilacgLkTtGYPOtotnu9l8KkW9QJPuwSB5QlSVcnuGGoGicUv+s+TOZn
         D2Ldv+zxWeG4r5hLjXFfdUZB9+T8QEwUQHmy0aLymLEhFBtwuW9zh2xpUXCXYbtn1ko8
         ERLzVKYpRbyftTvyoLs9q/PrXv0A0hjrhMOleIDe4JchizqAyVNJygpdpSN5mhEFroYK
         3tZE/Mj/K61jrp1Ui/04qe32uAaUHEDzthT7/J1MpGe/WqlenMTrODHATVokd040wf8f
         hUfg==
X-Gm-Message-State: AC+VfDw/PYLMOG7WFml9JE9n0ePwT5t1sQzueKR076cwZxCReLaNI7pp
        P+98pvkmj1CUyNjR59HY+X+jIUu3T+ZX1p3q00g=
X-Google-Smtp-Source: ACHHUZ5etVBpcsLnDO217tueI6QPI71UVFz1G/ZevFM9X3eseHSzrSJysbzm5lL8NgkgyLDR9A3GZQ==
X-Received: by 2002:a17:903:1ca:b0:1b5:32ec:df97 with SMTP id e10-20020a17090301ca00b001b532ecdf97mr25620452plh.5.1687538889057;
        Fri, 23 Jun 2023 09:48:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm7454411plh.97.2023.06.23.09.48.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 09:48:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/8] Add support for IORING_ASYNC_CANCEL_OP
Date:   Fri, 23 Jun 2023 10:47:56 -0600
Message-Id: <20230623164804.610910-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

We currently support matching on user_data OR file descriptor, in
conjunction with the ANY/ALL matches we also have.

This series starts by cleaning up the cancelation support a bit,
most notably using a common match handler to avoid duplicating the
matching code in a few different spots.

Then it adds IORING_ASYNC_CANCEL_USERDATA, to explicitly ask for
matching on user_data. This was the only original way to match, but
we since added FD matching. To retain backwards compatability, we
will always match on user_data IFF none of the other key matches are
set (eg FD and OP).

This now allows matching on any set of criteria that the application
wants. It can match on user_data AND fd, for example.

Finally we add support for IORING_ASYNC_CANCEL_OP, which allows
applications to match on the original request opcode as well.

-- 
Jens Axboe


