Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D4454C5F8
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbiFOKXt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348675AbiFOKXd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:23:33 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC9B13CEE
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:32 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id k19so14701414wrd.8
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LbVrXf5rhXw4/xavzQzljVUXEDxNfLPhX4MRmO+maMA=;
        b=WbD8SWXI6DUxHgoOLIfqj3kyBzkEOJp7Okog3V9Kdw0plEdG3PB56XK6YT/VS5nWON
         I0jkuAp/8SnHAPDWCJX7CWjWhvjlfW7lHDsLJAoCLZL1PDbCkrgabknvUGfJdAkE0A6w
         ZXzVmx7LPNrS5Ivo4s6tPw8dfGLiYGcjfHTLwl8pQgHgX/Gu1/9yqeeffCfmByGOR0P1
         KLOSvEa73BQ+4G1dS7gceMrZnYDI7iIdNt0uq+Bc052JQMcvL1a29kzapDlogYL87tMp
         muQjdNhrMqj5Kf3VY6WfiFvDgtpFQxcRjp5a2aLFzqpf6PJGk/fWSxtljTKIzJYL0Q+D
         R5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LbVrXf5rhXw4/xavzQzljVUXEDxNfLPhX4MRmO+maMA=;
        b=APhhpKQz5QBjAdouUmkDJVOqVjl9lBz7Ii1Ha2dTqaZNk1JJL3Gl+VOfkbnEmTVMJ0
         hFSsTAVi7OP2Z1G46WuknPju9b+yWsW07/jAnyGeW1W+lff5xOOdirhPKmwMOYnICG9u
         1dTnWl2B9KHN81jROtG76Avo25tm8m3AVdOZYf1UofUz6AO5uwi5lmk1in929hmOVWIw
         7IUI2TgnjyrcRnl8fzXA+QAIIxBnlm63zdSJsv6q+6L0ZbWf8Zx97MTvPAYNh4gIn3lF
         tjLcTUSFHsoKU9OtoJg1Z3mpjbX0VBlrKgS61OTzDpdiMCTWNkTlUnA/zYm+njDtpeQG
         tHSg==
X-Gm-Message-State: AJIora84/vdi6Ekyw5gUMRZPLzRhejxKnSFQPUJxIg3qz8OSc9iO/vsW
        d8/gyVOnI6x0Bn8AuNFpDtjN6cy/7mGI3Q==
X-Google-Smtp-Source: AGRyM1uYtU8gecyDzXmL8T0yJ+d1pdkAlKQAmULUyq2fEQ3rRJ1lgcjXktV0T+ivEH1zINEyH4IorQ==
X-Received: by 2002:a5d:4f92:0:b0:214:c773:d615 with SMTP id d18-20020a5d4f92000000b00214c773d615mr8842143wru.525.1655288610988;
        Wed, 15 Jun 2022 03:23:30 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id p124-20020a1c2982000000b0039c7dbafa7asm1964984wmp.19.2022.06.15.03.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:23:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 0/6] CQE32 fixes
Date:   Wed, 15 Jun 2022 11:23:01 +0100
Message-Id: <cover.1655287457.git.asml.silence@gmail.com>
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

Several fixes for IORING_SETUP_CQE32

Pavel Begunkov (6):
  io_uring: get rid of __io_fill_cqe{32}_req()
  io_uring: unite fill_cqe and the 32B version
  io_uring: fill extra big cqe fields from req
  io_uring: fix ->extra{1,2} misuse
  io_uring: inline __io_fill_cqe()
  io_uring: make io_fill_cqe_aux to honour CQE32

 fs/io_uring.c | 209 +++++++++++++++++++-------------------------------
 1 file changed, 77 insertions(+), 132 deletions(-)

-- 
2.36.1

