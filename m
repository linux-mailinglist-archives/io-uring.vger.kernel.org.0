Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F0B36EE43
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 18:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhD2QkG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 12:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhD2QkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 12:40:06 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DC9C06138B
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 09:39:19 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k4-20020a7bc4040000b02901331d89fb83so86782wmi.5
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 09:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7OUK+/w4TRy7Hj8O+HCayNx1GkEsXfma+ZzCcvx9vzA=;
        b=FLTXaacesz9293ZSuogf/YdV+YVObSqa30PwZDTRyK6IknY9gJOEs86gI+DKHa4DLK
         PcebcPHdNLjT3g20ayAPt/NkOTM0e4hIK0Kxue3XRjHRp93hro+Hm5d2kbvN5xy8P3Jo
         puNHelDz+MGJYiqoOgv32xO/7hke0sa+SRRmtPiKqUTpvoWZCvgOIofm6mCZbcnhszLV
         SyNfWSAANS11nYMTXF4b29sr3IuQlTwj2P401N9p10EO3vtGmNc/TwBI2sLwzaeU+BXx
         ddYHnygZ0BFBdSrpwyeGKOr1BxAxMr+ym9EJ101BzGypRu6rmL+cZbSwQjXIJG/CyVVZ
         N4sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7OUK+/w4TRy7Hj8O+HCayNx1GkEsXfma+ZzCcvx9vzA=;
        b=LFPiUveDS06i4xGG1whqU1O0ANrVMwaLSfzqzrHGQTs311VRc61tWMAEPq0hK0Ji1V
         p0LgLdXDDY4XcC7jaxm/SUFrL4u0qd9CimYa4Vs6P9O4uITpjFBV6MuaKtTElM65rBiW
         ghehOmdQvlJpUd8OPVMRcVfvsdGykmaf5mg9ZnKglQrspxHKnHUhy9x9KME4XLfpjxBt
         eYoDh5EmFzjciAr56Doo5swAx5gPNpbGjnsHft3WBm7ihLQSgV2u4oJ5wpqWGmkARGzL
         UiVYtjemGAEvXgQEC0+5E5MDfmek+xT/XKwcQUsZzUJyeP6j0C06AaYV27oxO2Vi5p8+
         1MTA==
X-Gm-Message-State: AOAM533taBvm4UXKswV0JvyGfloNj5U07F3sqb3z0RY7TBJjGe5zq/Mi
        bkjSHE4jbIiD/587ylGTdcN0SFUYYOE=
X-Google-Smtp-Source: ABdhPJxfNs7XIlsRgUQSnMWC3s67uCv9omNXHzjzEU1ntv0ZaJAVG4Hj/BWmv7elaf+0RhSGpN5FJw==
X-Received: by 2002:a7b:c846:: with SMTP id c6mr11226509wml.75.1619714357539;
        Thu, 29 Apr 2021 09:39:17 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id 6sm13578191wmg.9.2021.04.29.09.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 09:39:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC 0/2] non-atomic req->refs
Date:   Thu, 29 Apr 2021 17:39:03 +0100
Message-Id: <cover.1619714335.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[knowingly buggy, don't use]

Just a glimpse on the de-atomising request refcounting for benchmarking,
dirty and with a bunch of known problems (in [a]poll and iopoll).
Haven't got any perf numbers myself yet.

Pavel Begunkov (2):
  io_uring: defer submission ref put
  io_uring: non-atomic request refs

 fs/io_uring.c | 96 +++++++++++++++++++++++++++++----------------------
 1 file changed, 55 insertions(+), 41 deletions(-)

-- 
2.31.1

