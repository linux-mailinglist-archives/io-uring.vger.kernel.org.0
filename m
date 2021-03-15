Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB08333BCAC
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 15:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhCOO2K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 10:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238910AbhCOO1P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 10:27:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E81C06174A
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 07:27:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l12so8801678wry.2
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 07:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ECKn8dytquM6GEG5BL7eyIAPF0+V0auMdhnrbkAsKAk=;
        b=G1MuV8OqoaTbmUsLBXekmRkWMm1Po/zy0yG72wxR/I/3O62D6qLeQFN3EDwR4OpR/s
         5ZiJIM+CqC2hPTRuXNoNf/nJltbugtNWydroUJu+LSvBwmORTj3D/rxdNb7CR7kS4KPG
         4JbZYBfQoxwjLPv/f5jQ0TKaWMUJ820lvhHGcNk0jtJNlb+UrZxwzIgN3/DJ3cujJO31
         OQbt0Riy+7k8bogUQM8K7lvj4/z1MPbiy7Hgs6hfyBPQWWIzcyn7IvwNMmnr28t2PJ28
         bGbBbd/jVJ3FRz7kZ+F/3DF5KrCq2LQ2JcapEJzJaEnIj42qoeDfDUscNLSN2I1Impmi
         jeZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ECKn8dytquM6GEG5BL7eyIAPF0+V0auMdhnrbkAsKAk=;
        b=ASHu/nNYDLtUL7lpzAc0qvtNHa7CowodcrG0jZ/+3DXJhumvjog1+4AgfoTkLVC4Pk
         jhPl4HxSaAzb98hF8auQknw/ZFnU3Ztqn/IYTGlR3lUsjHrJ0dNEimVvi+yNCf087N8o
         S4DgEZuxIY+rGsxFgSSUJQ6Xt3N3VchZIABMv20RBpUJ2BsVgtn1HtdWdQQ504QiuAvQ
         tRMp/9I0MawOP0WpMTnTUE5ATikiSHJ5AsCIcILIqAaZOwTPOZicfOPKyCDMNOj48K5J
         z96FKqacNpZEAaZH1InCm/7NifJXutUuVHvYDUhuzeelawh5r45L+5t9uH67SdFd3TR5
         8luA==
X-Gm-Message-State: AOAM5332wI/WiQMggE1UrMLZiVDlBo1yB9dsx5Hy3SLvbLzZqv2LEHme
        czMUVgQh1VNDcQLMwrr49HuWY5tQpLI=
X-Google-Smtp-Source: ABdhPJx+zEvozIoXa8d+cqlYsiVuxEgjsWDx4Ezlcmj3E1yRvMyXtHSzL+i4qoCyW7nOF1bn3RgWnw==
X-Received: by 2002:a5d:638a:: with SMTP id p10mr28600469wru.286.1615818433356;
        Mon, 15 Mar 2021 07:27:13 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.232])
        by smtp.gmail.com with ESMTPSA id u9sm8782168wmc.38.2021.03.15.07.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:27:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 0/2] fix sqpoll cancellation hangs
Date:   Mon, 15 Mar 2021 14:23:06 +0000
Message-Id: <cover.1615818144.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/2 is a prep, 2/2 fixes the issue. Many io_run_task_work_head()
call sites look nasty, but I expect them all but one to go away
after controlling SQPOLL task lifetime.

Pavel Begunkov (2):
  io_uring: add generic callback_head helpers
  io_uring: fix sqpoll cancellation via task_work

 fs/io_uring.c | 68 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 27 deletions(-)

-- 
2.24.0

