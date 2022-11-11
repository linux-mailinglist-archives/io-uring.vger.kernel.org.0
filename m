Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7EA4625FD6
	for <lists+io-uring@lfdr.de>; Fri, 11 Nov 2022 17:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbiKKQxK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Nov 2022 11:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKKQxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Nov 2022 11:53:09 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91CD657D0
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:53:08 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a5so8358047edb.11
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nTSoVo5qOjM2nNXLRP0SD7r1MnATBwqiSo09F/XtH+k=;
        b=XSL65kRQ2bTj1k7n+acGX76vCROWTXk5z17STMEJehAlYxTlDNKMlXmgLNqkiJwaRM
         1oofWxvP1VD+6Y76GtXgnG5lUqKj1Ghpk05RfnIFWjxzFLQ1a6jp2fdmhFJu6hyRIp/g
         P0f0LPPHzndsV4YbZqhMGjQpEcLPYpTfZYDOCc8TEZyqamO9IycWPPplsevO9umG2lKR
         vC+Yy4mc8sEqd2wlOcAGqEIRntxZF8vow0YhtxrlW/72IquoUhbkNQ1GnBMd0s5Tq8zr
         kFqraCLC4VxRoqHy/3a4WsDDCDmEmeTGX54eITgGouWsEZhwfmVrfSB4CxR2uZ6GoyAJ
         E92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nTSoVo5qOjM2nNXLRP0SD7r1MnATBwqiSo09F/XtH+k=;
        b=QcFIxaJVPKx3KFmwARWEfj3iwtqmOTrtuAUQB7phRXTpjyajFfhiQ4lXCBlCJShKuq
         67iSDHlSOb6m1H5YtQ4NnaDGUD8jrpip4WSycD9Uea8C8ucXn9hPVKXSLBAfX/JMvE2X
         XMmp7WUhntiV5Geq+yTZ/Jue+Fm2wLhelM9dH0V9TITkm5Uyh1pc+/85OLfXl1IhYlkX
         gVUwfQl8ttdQehxPY4OKOeVG7G++jc3qFRoQrblFL7LKUiqlH1dZ10SBIQ9HfuvKQk/S
         vT2exFQD6VWMxg16Iy90E01JlNA3m305IenY0+ePxrB13qOV8PB0NkUkXBsUnMIn19kA
         eYcQ==
X-Gm-Message-State: ANoB5pnxHUKgAaVo9qR0x8HhBPWmC4oj1RU6nl0azbJiWgJCTHH+qTs0
        Jn++iJujjykmweH+P/9slZKJgYtU2Fs=
X-Google-Smtp-Source: AA0mqf5Ad1KNL5Q3qROEw1CcMqC+azli9lf2h82W9+poGz1C8WMX/Hj8UDClFgmNAcZcbYRpLPjMBA==
X-Received: by 2002:a05:6402:1ccb:b0:458:fbda:c618 with SMTP id ds11-20020a0564021ccb00b00458fbdac618mr2149130edb.428.1668185587051;
        Fri, 11 Nov 2022 08:53:07 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7f38])
        by smtp.gmail.com with ESMTPSA id ft31-20020a170907801f00b0078d9cd0d2d6sm1103837ejc.11.2022.11.11.08.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 08:53:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 0/2] Subject: [PATCH for-6.1 0/2] 6.1 poll patches
Date:   Fri, 11 Nov 2022 16:51:28 +0000
Message-Id: <cover.1668184658.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/2 is a fix following with a small patch adding a lockdep annotation
in one place for io_uring poll.

Pavel Begunkov (2):
  io_uring/poll: fix double poll req->flags races
  io_uring/poll: lockdep annote io_poll_req_insert_locked

 io_uring/poll.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

-- 
2.38.1

