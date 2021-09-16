Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E27F40D288
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 06:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhIPE3I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 00:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhIPE3I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 00:29:08 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A77CC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 21:27:48 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id j16so4758130pfc.2
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 21:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3LAH4N0pSUbqMaoIoAlLsdNT6f8LH/oQjfwjff2nVCw=;
        b=YpMeMww6McUhW3/haeu6sNh9i+8ZR9K2wmHkSMlPddGLHwNYCoA4bHKvxUNS9+lAzh
         Z7GTLzyTh5TLdXxfd3BQo/u/l5BRMCyeKCwElQIsvG5d0YrPtI5cHI0GMeUB3464oONF
         jGYEpMoyKnrRW6IxgZnC1lag/WfwZWWe8d1v85kDalSItY+NeiahwtfZEHOi2EOLcpRD
         9wIgG2Q3tPIFhbq6BVlzR7dziNZRWdwLTIaWPkKk/viGySb8IejeHEvBM07PzpwkZ9UE
         s6wWOyqzD/xdQ/upSiso9yS3cxRTs0f19H/H5Du5ZlZ3WG0Rv7TuPtG5W3tI+KP+vTkb
         Tp4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3LAH4N0pSUbqMaoIoAlLsdNT6f8LH/oQjfwjff2nVCw=;
        b=00fZDAcJHBp9OK0F0XzAkwOA5lJAxqRn93yYoaOnVFVs7IxheC0Fwfzz+9kTxvWIfn
         at1Fq5A3+A1IK6sB6Vg10wy/hwrHTdhVQMhI/2hkEfwIFPeaCe3ytEjtEU96nQ5MwZrC
         pn19UidzFrFos/3D6lY0Rx32VHQqvuHOjpgqrBCAvcr7bcTDiD4XQJMY8bgBn4QXzX9m
         Bobkjy7zjGAbeVvWdRsuEcbRSgM275u6THXub5oPd7IkDtxyMjxC3OY/PDyY0doxrYZA
         vjQv9CbGy+IfSv9TPfoHqIxyjfjpY5UWzbvEg78BcrfIALYxGZjEBVRYoqQasMhOXz6L
         hHAA==
X-Gm-Message-State: AOAM530mGSLZtS3pD372o3yGnC6W3e7ikiSCecwpIpFysf8UssaZdS+5
        qYTHIhK4afYOi/Fg1bLUpNJrIv89D8g=
X-Google-Smtp-Source: ABdhPJw0tmQot71hJ59vkEdsi7FyApXILW/PfFq5J539aRgBaCJcrroau9oFKW2ivL9tNmtDKX6xsw==
X-Received: by 2002:a62:7887:0:b0:434:a96a:e69f with SMTP id t129-20020a627887000000b00434a96ae69fmr2948446pfc.83.1631766467911;
        Wed, 15 Sep 2021 21:27:47 -0700 (PDT)
Received: from integral.. ([182.2.37.93])
        by smtp.gmail.com with ESMTPSA id q3sm1521216pgf.18.2021.09.15.21.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 21:27:47 -0700 (PDT)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] Update .gitignore and fix 32-bit build
Date:   Thu, 16 Sep 2021 11:27:29 +0700
Message-Id: <20210916042731.210100-1-ammarfaizi2@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

- Add test/file-verify to .gitignore.
- Fix 32-bit build

----------------------------------------------------------------
Ammar Faizi (2):
      .gitignore: add `test/file-verify`
      test/file-verify: fix 32-bit build -Werror=shift-count-overflow

 .gitignore         | 1 +
 test/file-verify.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)
 


