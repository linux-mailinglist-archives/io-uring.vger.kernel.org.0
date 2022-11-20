Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FF863154B
	for <lists+io-uring@lfdr.de>; Sun, 20 Nov 2022 17:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiKTQ61 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Nov 2022 11:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKTQ60 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Nov 2022 11:58:26 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7168F19283
        for <io-uring@vger.kernel.org>; Sun, 20 Nov 2022 08:58:25 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ud5so23804758ejc.4
        for <io-uring@vger.kernel.org>; Sun, 20 Nov 2022 08:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pXCbfiKhrkLAzEnDRMXHPIIzG27kxiZNXjG1nyHqpdQ=;
        b=kuYbwGbvaItUeqJrY9lLQaHjm+QZXQZsMUH5cHQCAPbq4Z6J1w9fmaTdIk0Z8eCXxp
         ggARNyBiuFqjIoaombk1fB9ynsZ8UjIA0EclxFcwpi56SBnu2SNsc3E72Yt5Df/VXUsu
         O514DVAoqUQlWkEhQsbwOO9bfqZzC/06nPsApvrwXDiICVb4TD/Gfp2wpQ30XiQ8Tm3k
         0DT1Fi7kKdRpijJJHS/+9c9JmJOcEDc807u2zp6hS810sAkYhMhSnnaBMT4AbNXY81/i
         CS8JYdxzS5Y0dZSjx8qKESuxE0jZ2wBrFTakPbEVzed3BsHsieSYikRjMqk0zF9cl1g8
         YVkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pXCbfiKhrkLAzEnDRMXHPIIzG27kxiZNXjG1nyHqpdQ=;
        b=uCL4EwW5kbKfRoCw3bdf8CVXq/GERtcqMegLbOY6wfZ6rNXpDKHp1LyEIVY9XzRuEa
         aw+hFqkJUGBtGdVj0X/lK0GtWbNuD2wtN4ZmDW1dN29pELcHvi+7GXMoidhO5k7KefIK
         QHLmRqJYhTS2ra7jos/q9vxlhYiDHDNYp5tA6nPOdQbjiTYSGG06Oby2Kl7eWPqxtqqI
         o+XBdVkQnr5RnAx+KsG6BPxQG1i7OcUo/ubXqMzlWYjwZA/XZlym7QqQ/6X0P8/EmB4y
         lrCoAv2cCp5lhw7yj8Ka6wyhvZkJkeZn77yfsy7rJy3LjH30up5Zollg2L79+mRSsejE
         gntQ==
X-Gm-Message-State: ANoB5plenwJLdoFu40tQB4bPX6Fe9YGmBA6DTatfSlI/Wx/C563ARfXx
        B1DErdmLN8Eh4z0ikioGUAQRRiMIqus=
X-Google-Smtp-Source: AA0mqf4SMTAl0EA4pua/KVbA+loyZrnc/DSdLnWst0UaQD/4BicOSB6rfcsxDmuIVTMr4c07VeSfjQ==
X-Received: by 2002:a17:906:a156:b0:78d:9b8b:93cc with SMTP id bu22-20020a170906a15600b0078d9b8b93ccmr12895674ejb.529.1668963503730;
        Sun, 20 Nov 2022 08:58:23 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709060cc900b007b47749838asm1904618ejh.45.2022.11.20.08.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 08:58:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 0/2] poll_refs armoring
Date:   Sun, 20 Nov 2022 16:57:40 +0000
Message-Id: <cover.1668963050.git.asml.silence@gmail.com>
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

Make poll_refs more robust and protected from overflows. The mechanism
description is in 2/2. 1/2 helps to make the second patch a little bit
cleaner by tunnelling all edge cases from arming to a tw.

A good way to test is to set IO_POLL_REF_BIAS to 0 and 1. 0 will make
the slowpath to be hit every single time, and 1 triggers it in case of
races.

v2: clear the retry flag before vfs_poll()
v3: fix not handling arm_poll* refs release edge cases with patch 1/2

Pavel Begunkov (2):
  io_uring: cmpxchg for poll arm refs release
  io_uring: make poll refs more robust

 io_uring/poll.c | 44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

-- 
2.38.1

