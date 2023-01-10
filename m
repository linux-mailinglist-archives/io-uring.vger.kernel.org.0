Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDAD66480D
	for <lists+io-uring@lfdr.de>; Tue, 10 Jan 2023 19:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbjAJSDv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Jan 2023 13:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbjAJSDV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Jan 2023 13:03:21 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4138326C5
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 10:01:00 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id b12so8778577pgj.6
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 10:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vu/Z6yAmPBu3xoXiDDiB5o8pwbEv7XatWOfalJ2I4/A=;
        b=rbzCCgmosFG8QtGwSg27e2z23Vww6PYVcK+awmMzkZk2eLgpldWEOaK3kcgEeMDhww
         H80f4qMcTNc6mOLph/zN5NyiuCOyF7RjtQWxa2h1eUrqrcEq5L8u3UYatY2aLhNayc8a
         T6EkVDwWbxPNYaP2RPAJQgkm0ERG2qdo8V6in/0nkuvhFFHwgaUZVmRfso1jYrYCTgWT
         njEiol1PQu23tho8soGW61mKMczKnDYqGzqeb//pp1MCCZGkOQAG8c4N30vT8Z/Hyi8n
         +T2+E/JI9+LyPIQWbtCzb61dbsa/l7xL8aIvko7fq4h1MrUVXwgalAtzMfhhLw+X8+LQ
         OTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vu/Z6yAmPBu3xoXiDDiB5o8pwbEv7XatWOfalJ2I4/A=;
        b=1mtmTJ938a6nPGsYsN6hQMkkkvm0t6UyQB3N1cZavUIjjxmHLjACptfrFAC2jpBVDU
         MoAvH3VoVKHAY51YU1KyO0j5N/TZgNvi5+cnyOLaLwyMEayb2pskEOwRU/eOwz7648gL
         Q/Ywl7EnvPAoaSjmESE1CUZHnP1fZ8ZRpi8+hRNMvJrFjBjOfPNejPj2Qnjf86eFX2HY
         IXwNRDGz/kimyZN0AqRXQ+3DXAHadQ9oGVzBzFNHV4V+dApvsTCFbTQaFNAYJy3gBuig
         e1CyyVdWvrnu6L0jh2ZVpemE1KC2TXgpdFuc2I+TLo/jP9hDc0Jqder5tSZ//hzZJ9PL
         1HaA==
X-Gm-Message-State: AFqh2kpEQAAR4rv2XNkO8DvtkiKKxWnoI0LodqcIxJdLMKDVKZKlGJwm
        oHxZq/0w47prmrBYh9tc7RVaUXgLNDqB8Io5
X-Google-Smtp-Source: AMrXdXv23/rjRqyHDg7YR1hh9bRSvmw/C5qefm4m9n45v0mHx2c0KCWGQmcZyXVVm5l94hK/q5WmEw==
X-Received: by 2002:a62:1484:0:b0:587:9e50:3af9 with SMTP id 126-20020a621484000000b005879e503af9mr2098923pfu.0.1673373659416;
        Tue, 10 Jan 2023 10:00:59 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i24-20020a056a00225800b00583698ba91dsm8405877pfu.40.2023.01.10.10.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 10:00:58 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 0/2] Pol fixups
Date:   Tue, 10 Jan 2023 11:00:53 -0700
Message-Id: <20230110180055.204657-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Patch 1 just adds support for fdinfo outputting state of the locked
poll hash table, something which was forgotten when that support was
added earlier.

Patch 2 fixes a race where multiple requests on the same poll waitqueue
may get woken and not properly retried. This causes those requests to
potentially never get woken again, if we race.

-- 
Jens Axboe


