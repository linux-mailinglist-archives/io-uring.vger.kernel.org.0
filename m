Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A437C34E0F4
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 08:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhC3GAo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 02:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhC3GAh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 02:00:37 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E23C061762;
        Mon, 29 Mar 2021 23:00:36 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id m12so21945437lfq.10;
        Mon, 29 Mar 2021 23:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eSZe7qy5irbYceIieVltp7POq2ofcrG7uqpRn8TJqD8=;
        b=pFEPi0KHWu7YdWMEL3o16fSDT0r79piOo4PSTHPR6CJj/+B8lTUGaFH2prjSL3AHtN
         G9b0BKRDV9GqOGmRl275TIvHW0l7IJtbuLq7eQRuVOp8Hy8wl+I2Gf6z23TvdwFNlcfN
         uNxAgeSvFn/l89txTJm3lwP2HLnpJp8B54KonPnhKMFAQpFP4Ibqkfa5GGmN4lFI+omP
         f2mAbFkFQDPJ2nsSlZC+YlKuuqwlbEQcJ4hswJUQ1I0jB/5bWFwVxRmusLDHxDzIgpaJ
         RdsKOpHNlglrg5ggMfMsRDXSqLVxPsbNxdp4g7q390QCmshkVPx7T6tmmwIF+381UbNb
         mxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eSZe7qy5irbYceIieVltp7POq2ofcrG7uqpRn8TJqD8=;
        b=l1fcLRMFZ+miED0/gDyi6wwVscoLbPhezHAOVjqpPnQzx3KiR0EdUj8J1O6Qs/aieQ
         niRb5SVm+vBH2QQiSv4823HuoNoBKzINAh3gRJ9ICV1zIDbIjsIWEy9FRKx9rA5ECPWr
         qbgAdAeMsGYFGUFKIu99JSn4yaIFu+vHeDhwQl4ZqUE4a307NW0ii1HdKu90XGJj93cI
         98aiB51NqtBEF3EsuyFDbwTVIxlN2pCNs8DBomH0dAFDZKV6kmZY9FJYcJg1nKgPYUis
         v2+LrvRbf7j/Qf1V1+twYK3gwRbjGFa5rCTmdgByG3BLDPcxRRE4mbr9vaxB8G/aq7Wx
         Sl0Q==
X-Gm-Message-State: AOAM5307Hf0urEQkQ01cdzXjLwoNappfDPC9+FgnYyqP0ZQovDC0vq3G
        5ny4JdtO5gwLHvjWwrgGDOIpvrccw9g=
X-Google-Smtp-Source: ABdhPJxNxyG9MkMMAx9k7vUcHIjEzFb8obp1d4C9OknXpivI8f2UJitBYVFnJsYi5hb4sB4bxVsKzg==
X-Received: by 2002:a05:6512:4c4:: with SMTP id w4mr19014432lfq.91.1617084035401;
        Mon, 29 Mar 2021 23:00:35 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id e6sm2050089lfj.96.2021.03.29.23.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 23:00:35 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v3 0/2] io_uring: add mkdirat support
Date:   Tue, 30 Mar 2021 12:59:55 +0700
Message-Id: <20210330055957.3684579-1-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds mkdirat support to io_uring and is heavily based on recently
added renameat() / unlinkat() support.

The first patch is preparation with no functional changes, makes
do_mkdirat accept struct filename pointer rather than the user string.

The second one leverages that to implement mkdirat in io_uring.

Based on for-5.13/io_uring.

Changes since v2:
- rebase

Changes since v1:
- do not mess with struct filename's refcount in do_mkdirat, instead add
  and use __filename_create() that does not drop the name on success;

Dmitry Kadashev (2):
  fs: make do_mkdirat() take struct filename
  io_uring: add support for IORING_OP_MKDIRAT

 fs/internal.h                 |  1 +
 fs/io_uring.c                 | 55 +++++++++++++++++++++++++++++++++++
 fs/namei.c                    | 25 ++++++++++++----
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 76 insertions(+), 6 deletions(-)

-- 
2.30.2

