Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923A75AD4B3
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 16:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbiIEOX3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 10:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbiIEOX2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 10:23:28 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DE43B958
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 07:23:27 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t5so11529602edc.11
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 07:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=fR6mPqATEZpkXfdF9pDsObjXBge9zNP3EW+i5TPU+hA=;
        b=cmQWyGKue6iohNsqrMqVbLR+c4UTD1ptdnQww35SuaX81G1379k6ta4fmIol6h0nU7
         JEbKmaNt/CuEOeMOzbZnIoaZSPcE1go0wVsuZCIFA8VIrQqWmWVUykKbSvQ+nK6ubu3a
         sC3QJE0qxCS+J/DoY8IZrO5iLKxRpOkDoDdchn8qOOAQOhhnf9qcwzAnLNSgTAJlA4UZ
         9GEHi/JMFhnK+DX6kBodSn/CWk2TrwC4peQ6Us6t15LMpx5HcKjPIIZupzuKB/iuipeU
         tgXSNBJTEcK6okcg2m6hJIDp2de5Z5Dkl96XqSqn9vZTcbrwINv1UShLWBgd8r2bPqKB
         3AxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=fR6mPqATEZpkXfdF9pDsObjXBge9zNP3EW+i5TPU+hA=;
        b=2kxARUen/BVBnTDSwWQcBIIZPZgK+cmyCSEnJK9FC2u9+uR5OjzS2CpfzF5T7kwr7R
         A3A3EjLzL/nIQ5OPaplQLFERfEpWysz4cODwNWbnPJ9B/kMiypPvcWagL0uQg2HzxC+b
         bIoOOUyGj4r7lFxkSq5dyupRUM8fua2+9iS0+pek9xOZSb91P7DhDVo8jcB6vLkI9Obc
         GyS/sYyLVjiWzHSrcVqiKuw3FPAELWbUOsi3v89oD+wlUNXsU6LmAxPqt5k13bzUiuAE
         miAJMjjl/f0X8n/gpEa7//jtgcsNrY4klMRbhvH7stTboCi142YRBo7uHS0WZBeYVRH1
         Vahw==
X-Gm-Message-State: ACgBeo0e86i8Fl07tzy8uyhqs0dGYc1pLpBdO5aANDo3samDLoPLdU10
        Bw9l7HtoXA1fO9nkcYbdfx51fvmxrtw=
X-Google-Smtp-Source: AA6agR4oNU+OKTbX0OPKTwtn9yOoBoaO+mYDRsH77eT7u/MaLU3fq+a+bKMtcOZtq6tfTsbaDcBCkw==
X-Received: by 2002:a05:6402:2a06:b0:447:820a:1afe with SMTP id ey6-20020a0564022a0600b00447820a1afemr43968339edb.291.1662387805674;
        Mon, 05 Sep 2022 07:23:25 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a118])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709064bca00b0074182109623sm5168799ejv.39.2022.09.05.07.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 07:23:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/4] zc tests improvements
Date:   Mon,  5 Sep 2022 15:21:02 +0100
Message-Id: <cover.1662387423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Return accidentially disabled UDP testing, reduce runtime, and clean it up
in preparation for zc sendmsg.

Pavel Begunkov (4):
  tests/zc: move send size calc into do_test_inet_send
  tests/zc: use io_uring for rx
  tests/zc: fix udp testing
  tests/zc: name buffer flavours

 test/send-zerocopy.c | 133 +++++++++++++++++++------------------------
 1 file changed, 57 insertions(+), 76 deletions(-)

-- 
2.37.2

