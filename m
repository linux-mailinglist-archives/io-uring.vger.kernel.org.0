Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D60B255156
	for <lists+io-uring@lfdr.de>; Fri, 28 Aug 2020 00:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgH0WwA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 18:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgH0WwA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 18:52:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5CCC061264
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 15:52:00 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id z18so3414103pjr.2
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 15:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yeJwKaWNK10ypzRQh+IRBqkJ9SDqpdDOq0y4g/Xp7XU=;
        b=2P4HbKqeg7WOH9iehtSrdMoxeyjHyT89h0CuLcO5IqMBRTvOwwlJ+9d5Zp7AySqqCm
         UG+mYOFGW7T9hSAtCis8PSaDJMKyGi4wG7TchnxNpCUljoiYNzAP1VKz9VCY6ynz4jrF
         A2pk4nmxyhq6X3x0GZrYJAS2R+2aBATtuDjAVTOzq9KkhLWqHnauNgTHGSxapQFSdPMB
         /QQPJ5ATuGPOprSPxAwNPqx6zx0vDo7C37s4Yb1uzHTH0EW0itF4zvdg78z5PPETVu2A
         Ydn4yhJ+Q5Ftdil0KOfR+liCt7HmbTQAuSQeEXiupZbMV88lzu1WE5hUnAvBxdCFYOV9
         w6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yeJwKaWNK10ypzRQh+IRBqkJ9SDqpdDOq0y4g/Xp7XU=;
        b=gNTWZFh0gCwnlKK8/oTmOTak5AKQHu/GWXJ5HEA6tqJCWnRr1TW77s4bihlwrZ6oDG
         rNgMTYHZbI7ecieCklTjp5i6rnohzAxKn+jUoPSzQvhbez46VoWjVJxL846VIU8AWmHD
         gprL3C8SJTO1V+Vvo3jthdCMn+qxSVtNdlBo5HqdX314oj96/5fkUl9fx60wgqNgs82n
         OtoohXABTuV2dUusQ19Ml3H4B5NUBsMabxhKci2XJTFrog3IxlvODQJrBs2WKNRds60R
         6HzENfI/vy9M05U/hRVzRmp1trexIb2rOnV0IiiG3zfY6nyVjKoUknztjI0gtLp8WY5S
         UYMg==
X-Gm-Message-State: AOAM531dpDoNC+nV3XJRZ8DpCWOyHIs6ET37AxeugKEUcnYVE998g1eU
        qdjd+nZwla72ZFOJ0um/RlKFlF3T9NMkWb4b
X-Google-Smtp-Source: ABdhPJwe4UXWYbAuywK5gEKXuZ1yn2VTKWfSDC3ylMpu+7xWhsfETVcz9N7SyWYfQly1j7IYJrvcew==
X-Received: by 2002:a17:90a:a081:: with SMTP id r1mr908932pjp.115.1598568718464;
        Thu, 27 Aug 2020 15:51:58 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id js19sm3087868pjb.33.2020.08.27.15.51.57
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 15:51:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] io_uring -EAGAIN IOPOLL retries
Date:   Thu, 27 Aug 2020 16:49:53 -0600
Message-Id: <20200827224955.642443-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First patch is a fix, second one is just a cleanup that gets rid of a
useless task_work bounce for retries.

-- 
Jens Axboe


