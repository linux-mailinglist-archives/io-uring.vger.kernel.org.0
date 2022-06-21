Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2D4553ED0
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 01:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354327AbiFUXBO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 19:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiFUXBO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 19:01:14 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4513B1C10C
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 16:01:10 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id s1so20901377wra.9
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 16:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cP2bArEMhMxhWs/yR/CvejDiI37/nmvoOs4PcpUr7s0=;
        b=bA6NzJHonezEZ4/BBbTCDbHlDkGBoDPygfAyIqngxPqWZs8ayKaW4EN1I0OnkA1LNB
         H8Jy40grrpey4SlvYIjlZqO8qV6bX+ct1rhOlNhPGYX0iPxF1iW81tlNLRO4ir0KAgrK
         P9m+9hJm589Qo4Z1rFbfID7tL1GdDR0jOOxcnWpNW+FWBmMOUFQZsx2RnqSuycXtUiUD
         BxAQmljorCqBCf3+c8TEpc1fk9atIMsEUCx6phNdD2tOfIElFEl/kVYDKokkN8w/V4Lr
         UL1konqRjr4wnZXd7i1TIjb8CnvhBCJ5HUoKkj9fvHZ5TQdBKRyxQp2fqCPPhySh/yt5
         2s1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cP2bArEMhMxhWs/yR/CvejDiI37/nmvoOs4PcpUr7s0=;
        b=LZ86Zh4F0DXC+UFAc51E2r7+vYXMGMlkVH3f54eKk75zsZPKe+WNCi4Etgr+NNbvdF
         CPELF/1v9bQyL49tbqtd4Gi7j3/uH3SMotNOUZQ9JFZ9qs1oT26X01RqJBWYKrBskZCA
         tIpnIWTTESxZGWYDJDROyRo/eDLJcdtC2PPr0rMr3pIW33iapDPdokbtXUnua1JQfi/A
         kyJ64GLeje6UWoj3H3O4F0QG4b1z4UB4Mr29HLWQETHhhEhYoYtkM9qK3UKBi1SNHpqD
         6fGEb+B1L+ATZ3HCEWL7Fxq79oWpJAeNla3ePt3fa6IMErLxixfgMBRCubpZocyrW0KO
         PvFQ==
X-Gm-Message-State: AJIora++76gXkbWEqSrKboUVOdljxU5sROeu2tmlCmno8eEpsvLfbkPb
        735AfkZ1oO8Y5/CKAludX4WDhNT2PqFgCO0c
X-Google-Smtp-Source: AGRyM1vmuiB9APeQvkbpWLsjdzAGrUo6Zr8sRFXNt0JqGArvLJgM2ydt4FU8g0mDZJjCke84gw7Jzg==
X-Received: by 2002:a05:6000:156d:b0:210:3125:6012 with SMTP id 13-20020a056000156d00b0021031256012mr264420wrz.357.1655852468479;
        Tue, 21 Jun 2022 16:01:08 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id q2-20020a05600000c200b0021b8ea5c7bdsm7630462wrx.42.2022.06.21.16.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 16:01:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 0/3] poll fixes
Date:   Wed, 22 Jun 2022 00:00:34 +0100
Message-Id: <cover.1655852245.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Several poll and apoll fixes for 5.19. I don't know if problems in 2-3
were occuring prior to "io_uring: poll rework", but let's at least
back port it to that point.

I'll also be sending another clean up series for 5.20.

Pavel Begunkov (3):
  io_uring: fail links when poll fails
  io_uring: fix wrong arm_poll error handling
  io_uring: fix double poll leak on repolling

 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.36.1

