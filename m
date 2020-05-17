Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD19D1D6798
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgEQLPE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgEQLPD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:15:03 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5181AC061A0C;
        Sun, 17 May 2020 04:15:03 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id g1so6765689ljk.7;
        Sun, 17 May 2020 04:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RSQAPsgGzrqW7IB05tQeE8zTcJ425e34evOvuPIjr1Y=;
        b=he8AYzJCf7a+a8FS1JLQW3b2YPl7mRZ7Qyy4jwXg8Od4ZSwiz6mpaIhwMAETWoghgQ
         5QUOm976HCJspd/plUq3pBRcvlYoLNmJ439O4na+551VvgS4V1lDBV2P/nqQpSQ0rJoB
         Y8dG4aMB4Dw848h3XZMRDioLvWmnBr4kyRz0lacIPVgWXtcgwcFAh13lQb/wOjFVPK2S
         iiLdItXKDK+h9YG5gtmG7xl6PZVoOeyp/l4JCzvMxQPaVMPdQUqidfXVjrpKeUelElmg
         PP/6YKIVBlSaerEK6HV6AnH8Eg3+HA4mF0arcaoyeRNBJTBv36xHhjYgkrqh/fynVUny
         fuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RSQAPsgGzrqW7IB05tQeE8zTcJ425e34evOvuPIjr1Y=;
        b=Vm6HPpOf18QMdaVMcfM4mWpc9CmjnkMP0EfzAj/kTKvZ5kmxWdKTIgGG8xyuIVkwg4
         kSXCmZZaX7vqpIEzC6mypTFMmfsyupZq6TR/Ej0Ojx62uHLx2YOymtIM5gfiqCqIVajN
         mqtA9mLTHAwNpeWuQT26fY0gp5SLC+uBVzWdMWSC/D2Cb2s65FRqxCkzbEcpdJ325Cks
         ANIy3nGBztzLBAxTwZPFkbz0VQhUwim91Zpmu0rT5V9jUDaRBL3opLEENgyyPozja0uf
         FvozS0YbOtdHFfBTH+B33pN5MVykiUhfoRkALu7gFgQjJaofqKwf+P+mDf8/r5PZMDsY
         8wEA==
X-Gm-Message-State: AOAM531KT1G+0HyBt881qT7ArqUQXhHYJ7C5+oBV7zIxazhtY0ezm8tn
        1tCBo6Af0hCUKdYKPb4Uf7ZQptoC
X-Google-Smtp-Source: ABdhPJzXSNe5kr20fcUecD19L3CoUBiqV0xx3N7mgDQxhdUQt8LPYeZqjBDu7TT7H55+8vfAFsTopw==
X-Received: by 2002:a05:651c:105c:: with SMTP id x28mr7570624ljm.65.1589714101645;
        Sun, 17 May 2020 04:15:01 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id v2sm3970990ljv.86.2020.05.17.04.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:15:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-next 0/3] unrelated cleanups for next
Date:   Sun, 17 May 2020 14:13:39 +0300
Message-Id: <cover.1589713554.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Independent cleanups, that's it.

Pavel Begunkov (3):
  io_uring: remove req->needs_fixed_files
  io_uring: rename io_file_put()
  io_uring: don't repeat valid flag list

 fs/io_uring.c | 47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

-- 
2.24.0

