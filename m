Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333376CA938
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 17:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjC0Pjc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 11:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjC0Pjc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 11:39:32 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB4110F5
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 08:39:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ek18so37968538edb.6
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 08:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679931569;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A0RMp5AK5onL6sO1Qx5ceWvZGCZkZV15YDzHO0q0Igs=;
        b=QLikhMtq0RX5fx7Yp/539Y30/H3Ktj1G4ew78HmLME2UHPk6AE9EG5bMjygR8habpE
         Jgp+9SGK8Ev4KdMOiqm5AAXv/1GfNSnYq46mKFxblb1ulXlmasTKNpkZR2jxLlHZv03x
         FhWhZDgT7vwyyenCdP0v3b7lAQTmAuawm9Tj6UoiSfqocWVBntsVEJrspFjiYAEbQO/e
         I33JzezRfjWKT2C+35AhkjtXt0pfDVPeW16ODZHno4LKefyU/qZ2w84B7fZ1JHsAAXmP
         04WSyO/WoeyHRvggQW7ZMlnr6L/loPm75sheLh+DGzvWYZKMSBo+kOf6YPcCuoW/uXkN
         sy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679931569;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A0RMp5AK5onL6sO1Qx5ceWvZGCZkZV15YDzHO0q0Igs=;
        b=CNJZYEGmpk7UEVodFVaTlUKnP+EZOdPXNIWC2VK9EtcmBxbHfzK+EIAa7CjF6vDQjY
         rZKA0lHmpBdGsc987qAkqtxGm8T1W4TaNgtXCT+Y1BvEwakspkUApxSLL4AKYP2gKBPv
         qtEpXqsSzrlflF5yXbRtNipKiMBf6o39SP5q93RkU3akSCKKh65ZWyH2eUidUrE2naIk
         yYw1eHazmSw2uxfDuvvjMjIdayt735HlhmyxZm4EJG1zbmk4VppQ6IwaJfT44VNcd9jX
         314Gz/1DSeNnCt3czheGEoNK8/1sjH7bQMs35PLoe+KneTB/aa8uLC+WS0t3uTu+H5JL
         lFZw==
X-Gm-Message-State: AAQBX9cnsp6BlL5PL+Q5qMJpbHhmOtkjLXkM1l5F5vU7DWerGxom/dZM
        ek50XknAKZ7+XTawVav5AUN9zGnnDsw=
X-Google-Smtp-Source: AKy350ZHpG5Ux3Q0m/LzrMLx+oUQvZ1IohAmOHz8PPgDsVJ4VuT/ivIep9hf4wc5HAIyboOip1WYTw==
X-Received: by 2002:a17:907:11cf:b0:93d:7ad:a954 with SMTP id va15-20020a17090711cf00b0093d07ada954mr12939721ejb.37.1679931569467;
        Mon, 27 Mar 2023 08:39:29 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:e437])
        by smtp.gmail.com with ESMTPSA id lx12-20020a170906af0c00b008e57b5e0ce9sm14055073ejb.108.2023.03.27.08.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:39:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/2] introduce tw state
Date:   Mon, 27 Mar 2023 16:38:13 +0100
Message-Id: <cover.1679931367.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a task_work state instead of passing a raw bool pointer. This
will better encapsulate it, e.g. to not expose too much to cmd
requests, and may also be needed for further extensions.

Pavel Begunkov (2):
  io_uring: remove extra tw trylocks
  io_uring: encapsulate task_work state

 include/linux/io_uring_types.h |  7 +++-
 io_uring/io_uring.c            | 74 +++++++++++++++++-----------------
 io_uring/io_uring.h            | 14 +++----
 io_uring/notif.c               |  4 +-
 io_uring/poll.c                | 32 +++++++--------
 io_uring/rw.c                  |  6 +--
 io_uring/timeout.c             | 14 +++----
 io_uring/uring_cmd.c           |  2 +-
 8 files changed, 79 insertions(+), 74 deletions(-)

-- 
2.39.1

