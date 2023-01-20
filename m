Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DBC6759CF
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjATQWS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjATQWR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:22:17 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EAE56481
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:22:12 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id tz11so15362182ejc.0
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hVIEAODeh+BuJ1ZwBR6kMLR0WtszaNaEz8LY4h3pa1I=;
        b=CKlK7w14zy2OxDQZkGip+OcoSRGdwkhBXfw8lzxoRHYbb8q6m5iIONzosRu0qkmLcz
         Po7MxILk5JOyKwJ7KozHkLKY51v+u08CHUrd7rUiKTWoBan9399aaPxTcUKAQ0yT0kve
         lIitLnCUbY3tZEi7yU3fFUeJNyYv5z4ssuMVgH/qj9ji5/v2Fq+Z6dDowc345tEUuox/
         SWEslJPU8QqM2pXToB5oK6UeVUHsWu4dn0HELGEe0dqDPissaH9ZyPeVdNjRniODfDcR
         GzBhPmrpWrNQ3/vTlPjg7Y0cpB0LsT9czN/nUw1x1AOFm+GC2L6jg78ECoi6WzWiTt0e
         gz9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hVIEAODeh+BuJ1ZwBR6kMLR0WtszaNaEz8LY4h3pa1I=;
        b=g5y5xZJhS8jW7hBICk+58uLQgzo2799A4GOV5b63uM2n62Tm8J/8DIkQc5RJn2JxL/
         6iJDzNJ5cEm5uEL0fZbacTUkJUDKn4yfmgfQoFvtNUSzyI/y7+6lPJgm2b8HmMvxvABr
         B4QSfA9G1TSfSuq3nIWWTcbaTlim+w7Fp3iV/Lo9jZQSrtlYnTsZkdM7Z5wxT/gq5L4f
         2FjwPPlB6GrnKXJEoiYRmZgZoCz+0dHkE7sRktTef40ScS8sBnyudpLVghaOmP+4Vx97
         EkA7MLMg1Zum9dxcLZ1OGlUz7GJktethjK0r7ApTtsQ6GSR41MAQYt5Yz0jANTp5O54s
         v1iw==
X-Gm-Message-State: AFqh2kpAo9lXn1+Igjnu6OoBOH8cGySerDGNmIVL55UVp3rAV2dixHzv
        1mWYjepcKR/HLcea6G9Ib0VcZWHUYlY=
X-Google-Smtp-Source: AMrXdXumtLihPUkdlipgRXdgGffjWD39xtpCUEtImCMgvjm/HrEU6IDcYkGnUi8+HMBVMpOhVB1GJQ==
X-Received: by 2002:a17:906:25c5:b0:84d:47e3:fe49 with SMTP id n5-20020a17090625c500b0084d47e3fe49mr15895763ejb.39.1674231731330;
        Fri, 20 Jan 2023 08:22:11 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:4670])
        by smtp.gmail.com with ESMTPSA id s12-20020a1709060c0c00b0086621d9d9b0sm11406040ejf.81.2023.01.20.08.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 08:22:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.2 0/3] msg_ring fixes
Date:   Fri, 20 Jan 2023 16:20:58 +0000
Message-Id: <cover.1674231554.git.asml.silence@gmail.com>
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

First two patches are msg_ring fixes. 3/3 can go 6.3

Pavel Begunkov (3):
  io_uring/msg_ring: fix flagging remote execution
  io_uring/msg_ring: fix remote queue to disabled ring
  io_uring/msg_ring: optimise with correct tw notify method

 io_uring/io_uring.c |  4 ++--
 io_uring/msg_ring.c | 51 ++++++++++++++++++++++++++++++---------------
 2 files changed, 36 insertions(+), 19 deletions(-)

-- 
2.38.1

