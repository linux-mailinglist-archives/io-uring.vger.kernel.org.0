Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD75615FE
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbiF3JRT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiF3JQw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:16:52 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFCC42A2E
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:15:44 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id g26so37722860ejb.5
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y13LZdDXwyzI5GpgQWiyhrtCQWzhj5Wyt1IPZ7GzgMA=;
        b=l0M33G+GUlJm99Af0cR1Eqbz/752L4K7s9KGfnGl6bZrYiDNdn6wTNK726asa5/at6
         HloISILLCbmArlELoFp6PegD+AL0mxBGzDfp/zRc/yuVAsdMioGr5oTRw/2CQvF0c/VR
         H2VUjmtzrGTUOMDNIYeRijbDZSaugFygkv09KAJ6DRoDrJ9b84u/TFdtY3kpWjioln/z
         NlJqwy4fxtHyRpPbMGvv+N3gH+rWRaow8VWH0N8xwDPYf8jfvV5itsFrqAWfxTjcmEqT
         OsQxUcGBQaU/013yDJ1pX1n8+bSztiVebdECuI/ijaLI9/SVyoj3pHyY9BlZtQW2s6F1
         moew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y13LZdDXwyzI5GpgQWiyhrtCQWzhj5Wyt1IPZ7GzgMA=;
        b=d6OPxRKg/AOD/BoC7o+5UEWG5gH61g2xhvzJOI6A9P+XzezoFRIgSzAX5xjMjFj5Ve
         8blV5l0H8ai3Sme1VOO6X6x9v1PQesrWKnnUbnq8xJWHnTO68ruD5b+kpQCBLvpB5e9/
         uhxu7RDpeqpVdQSZCqvSMrVvxaEYnkx/RWf16J3vtN6kHHfmqF7iyHvGyhBvrd+TQGMm
         QaRjEiGwEmS7UB2errVc0sshv5I8nvVMBiFX/2uoCPNEkhjqEqw3HWeC+2FvHUnFmpzQ
         SZjqzC/2JR+wiwnp3Ri7XCdwKjYyINplfSmZ8D55YawZ+m1fvHsl+sVA29S5RWhrrFDv
         CgMg==
X-Gm-Message-State: AJIora9nQyQU3/sQoPqiXqRPC/AglNfEJgK/yuhchnII7QhAOgXVJkb+
        99tn+m3/DFrPnFp+g/EzWA3i72UyjyHzRQ==
X-Google-Smtp-Source: AGRyM1v84Mn6N8WaCZNr7lBF+CktqeiSuv5/sVcFW7TCR+pR/TrS5ipq3eJErKTDZYaYYwU+Ji+eCg==
X-Received: by 2002:a17:907:7ba1:b0:726:4522:d368 with SMTP id ne33-20020a1709077ba100b007264522d368mr7941417ejc.662.1656580542779;
        Thu, 30 Jun 2022 02:15:42 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a3ae])
        by smtp.gmail.com with ESMTPSA id s10-20020a1709060c0a00b0070beb9401d9sm8884925ejf.171.2022.06.30.02.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 02:15:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/3] ranged file slot alloc
Date:   Thu, 30 Jun 2022 10:13:36 +0100
Message-Id: <cover.1656580293.git.asml.silence@gmail.com>
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

Add helpers and test ranged file slot allocation feature

Pavel Begunkov (3):
  update io_uring.h with file slot alloc ranges
  alloc range helpers
  test range file alloc

 src/include/liburing.h          |   3 +
 src/include/liburing/io_uring.h |  10 ++
 src/register.c                  |  14 +++
 test/file-register.c            | 171 ++++++++++++++++++++++++++++++++
 4 files changed, 198 insertions(+)

-- 
2.36.1

