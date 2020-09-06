Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C478125EED4
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 17:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgIFPqd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 11:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729057AbgIFPo0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 11:44:26 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84B6C061573
        for <io-uring@vger.kernel.org>; Sun,  6 Sep 2020 08:44:24 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id u3so10781721qkd.9
        for <io-uring@vger.kernel.org>; Sun, 06 Sep 2020 08:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Fw4dONbxEBSxfVSF3bRGOCVwjTyZ7CSP2QX/LZxq08Y=;
        b=WKSMWjIxyiI/OkUsPdtub9SdPwERlfpSQdBAItPBvIG1KHIKMQTriu6b65536V8SJT
         D7KfM0wQZ+s+SernKWuLHRV3LXnf45WJ+tav3E1bwxPwTC2yWP/EyD8pVcusiYBekq7U
         rU6KuQVMcm4WtSYdQu3XZ+VUzUwnPH7WS0tuo2ItowDem3lDeqe7ykO28BDAsRqNLHXE
         szeEQzivoL5l80FVmDtUYVgpZxdn4zyq1bfrbVBM/J0iGweHznHNtJFytDCBxZtmVp3z
         PiwFzwXZP6IpE7gURI19DTEd7+q71mpiVxmtXVjqu9XVhn8+NJMsMyOk5yxlVLEeJ1bZ
         TB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Fw4dONbxEBSxfVSF3bRGOCVwjTyZ7CSP2QX/LZxq08Y=;
        b=RVbxWtXciswESwNVmS/KQLNlQErKo4zoKTNRFEemdi/1mIzHV/5ry333qqHH4Xaj66
         x821PoFcX6IA5N4h/za/z0eMD6NYwUh08rykdmrtJPqWfM3Dj341lEpRoJ9UdFPg/GyE
         hM1qJDMOnDgdd3y+XnLXjt+FtBDsqXtnDIXyVO9ilhTWMoXBd3dkJJTw5onGKpOKiwW0
         WUYXtpNYuTxdEU2MMmRsyhtGh/Y/cBciFW2KelGFTcH76w6mknxRX6f58g89nJcyBCO9
         nAQzISvDV/Z8QSCfjKGj3cLva/ZMcOzLm5YPn52L3mE+QXQ/VDOPkDUvHKQPxTsaXAmT
         xx9g==
X-Gm-Message-State: AOAM533oKuJ92gnibOZtYvxhEt8/CmXGBYn74fgztvOSC4zw1BCt/R0h
        yCff/psjmWZ4TMmcxXFnKLL+tHZHCruf5yIi5kz49jO6klzduw==
X-Google-Smtp-Source: ABdhPJwrfSA+L/jMduSjfY0VY5IYafMxHWGSiEczpszi9T38t4RMDmwwp48axmZe0Z+w8Eiz+y3Ihusu0GFQ48EPuL8=
X-Received: by 2002:a37:c403:: with SMTP id d3mr10016712qki.196.1599407063614;
 Sun, 06 Sep 2020 08:44:23 -0700 (PDT)
MIME-Version: 1.0
From:   Josef <josef.grieb@gmail.com>
Date:   Sun, 6 Sep 2020 17:44:12 +0200
Message-ID: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
Subject: SQPOLL question
To:     io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I'm trying to implement SQPOLL in netty at the moment, basically the
fd are registered by io_uring_register(2), which returns 0, but the
write event seems to fail with bad file descriptor error(-9) when
SQPOLL flag is enabled


small example to reproduce it:
https://gist.github.com/1Jo1/171790d549134b5b81ee51b23fb15cd0

what exactly am I doing wrong here? :)

---
Josef
