Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51FD0185132
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 22:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgCMVcM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 17:32:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43890 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCMVcM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 17:32:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id b2so7666258wrj.10;
        Fri, 13 Mar 2020 14:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9wJ51KCp6rEFx/7MRIr81Qynm6zR/fN/BKIawyvqU/Y=;
        b=DUnSulN3MNIm1zXI0gP4/pwrdeeLkpDPtgQq/jcX1S7RRBobyJNo8n3L84qrSsBvvc
         D5D+Uy0iglCQG6wj6f70IGaAbB/jraEv5IF1noR2NcnG1OPdGUG2EW3+zS7SOtNN5CSx
         v374gHxbJeXyAGSks0FPbCVF80GaicA1Tgh9tonzpyi594KvLBlM/xSJ0YjO1Rlwl8Vo
         PLXOYuAea3y/C59JxnoPv25qjY7UAYR3B0rSXRWYrD92o1lygTZHweIMdF6RE/qb8uvk
         epT2xEz5fFXj8iQig6flEkkiOQFn2fTibvcPTkorS8AYfUaehOhwh0zddtBnjU343Fkx
         ybaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9wJ51KCp6rEFx/7MRIr81Qynm6zR/fN/BKIawyvqU/Y=;
        b=FMoN+AuH7LVh2f9V9dyQndl8Szp523fMP+oNrlrmH3hqfKZ2G3pg/bF57s1OYpjNq1
         WthCLaEAgUAhIg7dFBwX4FgER4mD8yAUls2/yoXvPP5cHPsKeLtl2Xpc/QtwzZU1Gii+
         UZUPtgkXLcQg2WHmkFZajgs5IK5FG60b9b7preCQCGqNqOkpHTJahJTibPpWGw2VHK9g
         SIOOyXnW1x+v1pEtkBT90a5JvG2Ah7n1Vu5cFpK9/QbJ+q/p7oPbF9UPmaTNpw4s4JVw
         dR0la+d4Xtx5r1G1gkOGMy9+AuqG1AEr0V4a9120hTTQfu+Q/U6NjfVkcG0WlR/tTA1Z
         qw+g==
X-Gm-Message-State: ANhLgQ09t7ea7hvhwp953yS7YXdz0DHptaVxbHr5Kr6hwVA97+VOEk/z
        nqY5o2BiFymOTzr1Pgfa3UE=
X-Google-Smtp-Source: ADFU+vuR6aOJPUZ2AXAS/0xl9okYBRsTq4LPqp3Bilwn0PanSMMQFGAqFdxclOQ+pYzLmlJDEMwvgQ==
X-Received: by 2002:a5d:4683:: with SMTP id u3mr20786289wrq.251.1584135130484;
        Fri, 13 Mar 2020 14:32:10 -0700 (PDT)
Received: from localhost.localdomain ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id v8sm78676011wrw.2.2020.03.13.14.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 14:32:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] support hashing for linked requests
Date:   Sat, 14 Mar 2020 00:31:02 +0300
Message-Id: <cover.1584130466.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

That's it, honour hashing for dependant works in io-wq.

Pavel Begunkov (3):
  io-wq: don't reshed if there is no work
  io-wq: split hashing and enqueueing
  io-wq: hash dependant works

 fs/io-wq.c    | 49 ++++++++++++++++++++++++++++++-------------------
 fs/io-wq.h    |  7 ++++++-
 fs/io_uring.c | 24 ++++++++++--------------
 3 files changed, 46 insertions(+), 34 deletions(-)

-- 
2.24.0

