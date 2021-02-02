Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DB130B9D4
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 09:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhBBI0v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 03:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbhBBIZd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 03:25:33 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D82C061573;
        Tue,  2 Feb 2021 00:24:53 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id p21so26698810lfu.11;
        Tue, 02 Feb 2021 00:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PzOpO4TkH1IxCCsjjxQXmloCyUxjPg7qiXOZoiHDquw=;
        b=a2tY6VnzrcL3n0O+uRi0hlhDurWyHPToUVdtVcXvBfVtUnAbu9jJTwzVtiU+gl2KA6
         3lpZ2YQ0Vn6WWQqu3EcVJWkGNYu2m84V9vGzPTc9INATpV3dWPPLufZeracWhNojOvmD
         GI4+i8GMjhiGvnTA3tYFlSvtD7uKDVV4o9iaMRItg0aUV4KWXyYtISCIgBk32/LExvhV
         WDDeX62zVo3qK4LZyU5nYIKZxxThFMuqKnRNRLm6l+Eskz+Ve5gvf9ZF1FUiwaSwyvsM
         oxm1jUUiNDH/IskNT0stiPicsv+XNLD2zSn1uDZa3wXola36NK2SgpRisuqErVmU5zt4
         w8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PzOpO4TkH1IxCCsjjxQXmloCyUxjPg7qiXOZoiHDquw=;
        b=C/Fq1IpeuanDtF9Qn3LgWLcJH+j0qY6dsaXc701r7bjoxjs77o5FcrRI6gIVUlRsqt
         P5sO68grExKuaAOYKT/r2bZbrvmKHXjHk+fq5DmgeM3DCytgqW1L0zfXWhaq+OzF5O7d
         na22Fpj3bPjSEuOdfxCTVg3yjdFFNBZCIaz0OLGljcYvQT4x/x+FuHellP10QfDnznHd
         7MRN0CoI7nqValuOvOR9wVoUcnmiBbNH1HuS64p28aPvxs/2LPKLj4CB9uaYc3n/RrEY
         vefS0/uXlnmt6dFTSQC96yReAvg9fX7iON7RVgsCQrJKrHJSUf68GRgr3l+bOru+cZKd
         LLWw==
X-Gm-Message-State: AOAM532k+TeKj3BEllNxuIMrGyKH3tzuttiqfdPlwdp2xbFDCwDMG3Mm
        II0AIuas+SP4sooma501KI4=
X-Google-Smtp-Source: ABdhPJwV/k03wSKkT3g1HIM2KZluiSLz9T8zLo65YiDlP0KN1e1sbEOKI1OYJUxcPARYNpp5/puTbw==
X-Received: by 2002:a19:ad47:: with SMTP id s7mr10435255lfd.72.1612254291634;
        Tue, 02 Feb 2021 00:24:51 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id t6sm4195857ljd.112.2021.02.02.00.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 00:24:51 -0800 (PST)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 0/2] io_uring: add mkdirat support
Date:   Tue,  2 Feb 2021 15:23:51 +0700
Message-Id: <20210202082353.2152271-1-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.0
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

Based on for-5.11/io_uring.

Changes since v1:
- do not mess with struct filename's refcount in do_mkdirat, instead add
  and use __filename_create() that does not drop the name on success;

Dmitry Kadashev (2):
  fs: make do_mkdirat() take struct filename
  io_uring: add support for IORING_OP_MKDIRAT

 fs/internal.h                 |  1 +
 fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
 fs/namei.c                    | 25 +++++++++++----
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 79 insertions(+), 6 deletions(-)

-- 
2.30.0

