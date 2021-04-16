Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2A3362536
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 18:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbhDPQKs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 12:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236237AbhDPQKs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 12:10:48 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02F7C061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 09:10:21 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id v3so6721458ion.12
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 09:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZd6nXw6oNu1+UoGyXfPYyKeYeL2AA3LGrtrhafTo4Q=;
        b=Dx+zFQk5j77EvwlPnHvjq8PTcCY7Qn5AJD/VfPBvmSNBYVEE8Hhc87MmK7d6fovOPu
         /DoePM5C/DmCu4crznC+02gotbHJ+4M9vF7QtY578UntKamxCwgVe8zrlvUmakpbhCow
         UcDF3Rpwa+Dv/Q1vQxPSKDKDn/laeWFU/LgajlJ1qNUcEKR82q5QkTGRid5nIZkr+6BT
         Mlo0Nug83/jkei+3OfdeZnh7dvoSH5UZVDDSQaY6wGgTW/RXY+6pppnBli/4n10pjKIN
         i6KSG7D0zRwv/MYU7Y31hiAEvbcaWdcEZKcSQETe4erN/6ketao4RXxSetsNQcFFqj6V
         psFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BZd6nXw6oNu1+UoGyXfPYyKeYeL2AA3LGrtrhafTo4Q=;
        b=l076JH6mXa/Pyw4MlLj/IxaElR1HAuYPxQdeky/l1+xC1vZPc1MWNC9aGVYM+OLHkX
         IQxT3jTDBAnO5jzTEZ67JWF0ZHEOB2LsYFAdPSRFhN1vYTE4iUxjbxDAwMhfa/2a+Jjs
         cQ7c7tCjzcGnoOjIKqvbf+zo0txLYzCbEqqii70tGTUwVVILaRWXMLJNDiAC2bOSaDOf
         TayxlnuTs5X8tUHxXcpv58kKD/gDjZ9JWZ3XO4MztDGLLuv8Z6LE/g5Y3IEs9l7Tkv5M
         pvg2Tj3AVBNBCZI5BbMd47TGBikD4YSVTnWyvvKP5u17BaNQKWxtGueFNKkbsLraeZNU
         5Hnw==
X-Gm-Message-State: AOAM531Jjj1mcZCyhh32h94yjTSlLPfA/dwPp1E3AgbQVoXz34lQBLGV
        4fGl5P61R25h4LdDr8XaEQ8SbbeZUIYIkw==
X-Google-Smtp-Source: ABdhPJwOpShkYSFyg1S8GlnM9hkBKD9wafPHoS64VTe+6Pde9UL84Uew4S76TBnKjr1tup7Si0A/gg==
X-Received: by 2002:a5d:924b:: with SMTP id e11mr4099862iol.133.1618589421076;
        Fri, 16 Apr 2021 09:10:21 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f13sm3024641ila.62.2021.04.16.09.10.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 09:10:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCH v2 0/3] Misc 5.13 fixes
Date:   Fri, 16 Apr 2021 10:10:15 -0600
Message-Id: <20210416161018.879915-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

#1 disables multishot requests for double waitqueue users for now, it's
got a few corner cases that need hashing out.

#2 is a prep patch for #3, which ties the ->apoll lifetime with that of
the request instead of keeping it seperate. That's more logical and makes
it handled more like other dynamically allocated items.

 fs/io_uring.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

Since v1:

- Turn double wait multishot into single-shot. The application logic
  won't change for that, it'll just be a bit less efficient as it'll
  require a re-arm for each trigger. It effectively just turns
  multishot into single shot mode for double wait use cases (which are
  rare).
- Add flag checking helper and make the io_clean_op() call conditional
  again.

-- 
Jens Axboe


