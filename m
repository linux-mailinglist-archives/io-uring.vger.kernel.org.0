Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2957666CAB5
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 18:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbjAPRGQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 12:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbjAPRFr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 12:05:47 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1574225E24
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:47:14 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id j34-20020a05600c1c2200b003da1b054057so8312679wms.5
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3JVoTqQERm8IRXFBp8RpceVp31UNQqiXysBPCG30qQ=;
        b=Qc2K/Ox4tfYZIvaI2JnRkBB4qHwXWiRJvsqw5uaoWK+CE8UjeDVACi4HqZPkbPWbvz
         ENdO0b9yj1owvYjEyaYT8ibpKxT7kxJ6LnT65P8XyBrpF/19SFFrlOT+PBMG1oPQ3vpK
         PaulM4NzGwkFUTDi2vKtRd2ATGOxqfJnNvtv7AGciRnZASOHeJI0iwVmrVnVkcECdFLk
         179SpBiAPI85WPmb108BbJvu0ZMbxhNPtHHPvNgOBeq4we75T2xX6RgQ6I4rEZt746kW
         aMLDbqWHvX0VwhsILQshyobitrL8uQnD+KxjpEoFXXOL34TAhBTcDrvUKbQmyG5kPl57
         EsVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y3JVoTqQERm8IRXFBp8RpceVp31UNQqiXysBPCG30qQ=;
        b=t8QQAJHqldeIOcZ1DjbcYMA4612HWfbpqQgu/0og5zK7P9AzN6Pa7uZWdyrDV7hBsO
         L4lh7XlDIPekhMEwRAS7FphP2W5TmfYOVDXJVlXwCl/g7odVX+n2tNWlcmQqE5YXIzng
         6a5rOgPRDsFZ3DbKh6ioVlSOPt8v4jifK2NYK/trwFu/LAcDs9paMP1refj/p1DefOC1
         vtFBi9pamXy8Pd9B69pHgLd4/wA1u/BQ8WhcQFkkmBvxyN51wChxjRiPy7kxqkGGv8LQ
         EhAO6b47VSbVvR06jfz7OU16tEcBsY471ti1aI7oD21c7H7kwPVRZd82/Knr0pyT7tm2
         l6Kg==
X-Gm-Message-State: AFqh2koIzGSGTVCrY4rYbR2Yt8oe5gKbef437mdvWstz2AYcrwffbz+X
        5shm86pP5ff2J2rD4JbuNlfIBt9HAvQ=
X-Google-Smtp-Source: AMrXdXuT1OQs7qE+EdAnPXXAJex+hz7W/OFzm666BbeV/JGTTZnSu2Jco+luWcRXYyD7aLaQ3qEKGg==
X-Received: by 2002:a05:600c:684:b0:3cf:5d41:b748 with SMTP id a4-20020a05600c068400b003cf5d41b748mr8734027wmn.36.1673887632706;
        Mon, 16 Jan 2023 08:47:12 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c444a00b003d998412db6sm42012397wmn.28.2023.01.16.08.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:47:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/3] test lazy poll wq activation
Date:   Mon, 16 Jan 2023 16:46:06 +0000
Message-Id: <cover.1673886955.git.asml.silence@gmail.com>
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

Some tests around DEFER_TASKRUN and lazy poll activation, with
3/3 specifically testing the feature with disabled.

Pavel Begunkov (3):
  tests: refactor poll-many.c
  tests: test DEFER_TASKRUN in poll-many
  tests: lazy pollwq activation for disabled rings

 test/poll-many.c | 60 ++++++++++++++++++++----------
 test/poll.c      | 96 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 130 insertions(+), 26 deletions(-)

-- 
2.38.1

