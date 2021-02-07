Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94558312863
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 00:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhBGXgt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Feb 2021 18:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhBGXgs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Feb 2021 18:36:48 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87364C06174A
        for <io-uring@vger.kernel.org>; Sun,  7 Feb 2021 15:36:08 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m1so11798707wml.2
        for <io-uring@vger.kernel.org>; Sun, 07 Feb 2021 15:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gr7k349o+05vbAElZs2klKnmWkZwmmyQzQjOL8v/ShI=;
        b=P5YFe926cZQfJM7KYp2/wuV/BR2RzbZIFVXILQdHXWcYhWbJxKSAeI057y/NDYMmAj
         7do2u1Ox2QN8EX3u2MTkDWCKDIdjXh5dsj38gbdEqWFAUZo0BAj1TZjnppSEhRKsOuCH
         UCQYGx9qh23T4RHPRY6YOKlKCQRON7DzAHBXizI5ZipE47N1+HtLxmx+vCB+gpNkNc/h
         X0iMLGCZbMGy7IU4mU14KZnc8cO4InaEw61PPMfU3sm/eXg8mnGFQlDy5uGBVoa3MTUw
         pKjDqIlk1TjW21z7nt1OeHyDy3edaYC04+8N58ZfJW51e6oMnbPcf/OMFo/AMCz3IB8x
         +6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gr7k349o+05vbAElZs2klKnmWkZwmmyQzQjOL8v/ShI=;
        b=WeFjRr8Gpk77qo8GojtfuaZoUl9y/NG4GntngJRrrjJLAK/uJ94RjDCDfFWVU+a+0+
         kgXbZFAQjDWgpkF1f7Tw7O5kgu+FfTHEsO8F4/vrAEqqoXL1rTmVTQW+umb9Jgn+ikS7
         cSTeAtoyccuBsh5ZV5FaJoygTqXhMFQk2R5oLGKpCsyZ0AeYuAcs6b7RhdcB344bDwR9
         xmUxSnFPGmB22q19hlYqWbJztuQdM8q8FyzLGYF2LUqTwT/5IG+2LyYrRKgkuyEjBTtj
         shWxQU5XBpQzUR9Jt7c5G/OFA0Lk2Jp5XM+1inH8R6qmw3cmas8dIEMGB5i6SV3xeLg9
         RytQ==
X-Gm-Message-State: AOAM531eSDHliCCsoA64zh5ZSKnCUSBl4Rqqp/w3GeB1clM3ijUWM7PO
        Q1YXzYrjAZ/eRwBsRmoZk1uw4ZDJpP8=
X-Google-Smtp-Source: ABdhPJzL+6SGvw3VLDFEuwAmjJZzVUuQ0/OB51GvNtYd0lehNCSPg68Q/OkUZV0aMHUq63MxICRrMg==
X-Received: by 2002:a1c:720d:: with SMTP id n13mr12199025wmc.103.1612740967327;
        Sun, 07 Feb 2021 15:36:07 -0800 (PST)
Received: from localhost.localdomain ([148.252.128.244])
        by smtp.gmail.com with ESMTPSA id l10sm25453380wro.4.2021.02.07.15.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 15:36:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/3] fix _io_uring_get_cqe()
Date:   Sun,  7 Feb 2021 23:32:14 +0000
Message-Id: <cover.1612740655.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

address live-locking of _io_uring_get_cqe() reported
by Victor.

Pavel Begunkov (3):
  src/queue: don't wait for less than expected
  src/queue: clean _io_uring_get_cqe() err handling
  src/queue: don't loop when don't enter

 src/queue.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

-- 
2.24.0

