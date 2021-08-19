Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC913F1ACD
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 15:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbhHSNnh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 09:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238463AbhHSNnh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 09:43:37 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07072C061575
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 06:43:01 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x10so9197927wrt.8
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 06:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+l7zA0IdTUIZGfRHlcyJaj6V5tclKcq/pyxJMGuHWZk=;
        b=Eemdp4ECZkfBy8JWnnkEBMh/J7cGy3+1CRVewgp85cv3fc8pk2TbjjdiVdOVqrFphk
         BVdjyOtRMtyMOO0fKmEle1E0m2oHxRMhv6SsZcXzs3aMSDLOJPku+KR1hfTbQrR7Rcrh
         7IucKvWsHpLXkyfLpi0uAjKxT048A4dCxpdKPKuRv/8xWcDj7BsITl8kJ4fCjCrKLxmo
         NrcF81b/Q/VDX0wkxVPT0zvMtJ3M07cwdFm+PmjLqHQ3Gf2CQzj8kpIdHU6+EF4q9NER
         WV/63JGv+sL6qVUAdZnpnvOCfmAt4JeZfqYftPgHd+6VZxOC1T5+xhVF2xBN2eXQtSyW
         zUMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+l7zA0IdTUIZGfRHlcyJaj6V5tclKcq/pyxJMGuHWZk=;
        b=PTWEkY5PXTFg4pFbVKdQzi5f33CY/l7Sl9p0HohfsiUwJN8iaoARoEM7wRUQmnaeSo
         /os2lc0t9OOONpvV8SfAMDHQ7/OFIg1ZZ/ksQUd46zWZE1VFRlLHrnJ292e5J/Av9AfH
         Jdyuo+zZG6JEjo2BeDBTdu7Pa3qGuc8UNMNwtDPaVUaSzMYWzYXyeYlRNJvnwZGtLR3j
         RbTUJB1EkV2lWgUk9pQsYnItZuIZ6uvXyZpP1ZMYWomFPMXaEA8C99TkrLTjxAUzrzzO
         ezrHLSWLFpFOfMnwKcpstL9ZzJ7TX+TW/z35UZppQvQhfHwyJhYjssC7JHFkP8R3R++Y
         h7jQ==
X-Gm-Message-State: AOAM53143fGweZU3JiK4i85NmPRXlcaDRnsW7LIj8XPTYTw+C99loR2+
        xmyS2g6+FDbHfsuUq5mo+qg=
X-Google-Smtp-Source: ABdhPJyOzGXHVUPzWp2XDUX/Vow8QG7xhdeqoKDGN/4aZkRNwZKJ8Jq3OuiLFHYejORL06TPYg94Ig==
X-Received: by 2002:adf:d194:: with SMTP id v20mr3970977wrc.126.1629380579656;
        Thu, 19 Aug 2021 06:42:59 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.21])
        by smtp.gmail.com with ESMTPSA id z13sm2939459wrs.71.2021.08.19.06.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:42:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 0/2] rw tests improvements
Date:   Thu, 19 Aug 2021 14:42:20 +0100
Message-Id: <cover.1629380408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Two small patches for read-write.c and iopoll.c tests.

Pavel Begunkov (2):
  tests: create new files for rw testing
  tests: rename iopoll test variables

 test/iopoll.c     | 20 ++++++++++++--------
 test/read-write.c |  6 +++++-
 2 files changed, 17 insertions(+), 9 deletions(-)

-- 
2.32.0

