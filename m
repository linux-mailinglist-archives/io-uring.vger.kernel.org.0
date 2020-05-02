Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607571C2503
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 14:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgEBMId (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 May 2020 08:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbgEBMId (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 May 2020 08:08:33 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0626C061A0C;
        Sat,  2 May 2020 05:08:32 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d15so15037598wrx.3;
        Sat, 02 May 2020 05:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xLoYbLTnKic1BXSAcGBS2j7bqM5wAxeaIEpr5BTrJ68=;
        b=qzSAYeaDikOs4JK41t0XEb7jYc6Rftfg0AvTJ0SKOKEGZCe3uqBsGMVRzV0HO1XVTh
         8BI8EczU0hpWDuy0bL5qYG/sAWs9O7FtQ0CaRA9pC/7+hl1urmZRATolyZ7fFgkMvKtO
         XrpbpOXwiDEWDgS6PtZA+Oxne3oEqn5GDSLD7A//4yjUGC8AN6S9itvca6WkPirsRxZ/
         ajWXsleAZnfr5Tg5xpvFAnRIfXlRY/xVH5iTAqP9YS18JXpaINaIDZ1vvgiWFRVdKKnS
         FJmLgCIkETm5RfraUORPMh+UQCt/ksTaDJxFQ/kLvk6FCeCvyMr6sfxPRrpgkDR+zetB
         ew+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xLoYbLTnKic1BXSAcGBS2j7bqM5wAxeaIEpr5BTrJ68=;
        b=VxFjaA0kbLSswIvu8VkEVQZrjiQLCj70GmImOC5tp6W5JFgo6Xm7nXlzkmEabyz1gL
         JoShQbjsliChzryJl3N/jDz7z8yDssLboSLoAhn9uQgN2EUn9DbhUYwdPLOlNUQrpGpQ
         WUHLa6ixOAjBaquxrqFJRzkpLHd+hf/SnGrtXRwTdh/wDcdIL3HIE0DJN9g+NvqHqwcy
         NIZE44Oj9WloTIT7nmdevp3JfDF3wBVIYYhEzoJLiVtp2JEgn2p5IIc/Z3++e1P8Hobf
         ElNYkPo2ct0EcidlEBMQO08D2HgEVYfeDRTIgW+QS7taS6rl7PXxbtS08POdqNGrlI0P
         6z3w==
X-Gm-Message-State: AGi0PuZXtNycjxCVw7xojxiVXRnbPKFBFtqv8eKp/8Y2k8OYY3rQz0h3
        SzTQTKhAfH+7kFear1bDmMFDtrUq
X-Google-Smtp-Source: APiQypKseLIEMJJ19rJeHvjGT47NBz1kQhBX5lHoESMOWiFxzv87vehThEGryOowlupK6/8JxvNNAw==
X-Received: by 2002:a5d:68ca:: with SMTP id p10mr9202841wrw.154.1588421311134;
        Sat, 02 May 2020 05:08:31 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id j13sm8930716wrx.5.2020.05.02.05.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 05:08:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] timeout fixes
Date:   Sat,  2 May 2020 15:07:12 +0300
Message-Id: <cover.1588420906.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nothing changed from the last time, just resending.

[1,2] CQ vs SQ for timeout offset accounting
[3] fixes timeout flushing with batched commits

Pavel Begunkov (3):
  io_uring: trigger timeout after any sqe->off CQEs
  io_uring: don't trigger timeout with another t-out
  io_uring: fix timeout offset with batch CQ commit

 fs/io_uring.c | 126 +++++++++++++++++++++-----------------------------
 1 file changed, 52 insertions(+), 74 deletions(-)

-- 
2.24.0

