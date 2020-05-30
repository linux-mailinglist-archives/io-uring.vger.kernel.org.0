Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A071E9100
	for <lists+io-uring@lfdr.de>; Sat, 30 May 2020 13:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgE3Lzr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 May 2020 07:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgE3Lzr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 May 2020 07:55:47 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193D6C03E969;
        Sat, 30 May 2020 04:55:47 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f185so6736632wmf.3;
        Sat, 30 May 2020 04:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NByTTtqse99foSTtJ0PN7WsIMuAHh/inwPm22WbCS0M=;
        b=iFb2iFZhlBoco9hvlUqBfEfQBvBl8z9lekh+q76owrcO+M8GpGEBgTJkuGiTIRAgYS
         XN6M6qiVoGjXoDG3jG+pg5uS5MC6J/e3BZ67EtL7GrJWFwg3wHizo5tyr2QTOgGWzSrs
         Y9J4GgYv6RP6Y2zXXM2sRZi26AdO7waI8aQjiSMLb022G2a5zAn7OScydjN+o3CXeAbd
         ONBOOMua4WRlkgmpSp32W067jXxi3EbDuCJcvFMRQDKOd95UG9FpJEuWbqNJFjc3yD9d
         TmkQz4I+k7JFYa0T2ZIWB1wq93edowvPhc8h2a5C7yLoQ0rLD+Up0L7sqEZEhUHwTtJV
         DjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NByTTtqse99foSTtJ0PN7WsIMuAHh/inwPm22WbCS0M=;
        b=cEtaEGqsRiemR6ojUhC8RBq/HUwARzUxzzcaQqulzCajQlMvdgGWb+nnLhokkEoDqV
         aGispK3j/49BvhP+zBJVjjBYrH76QCgvmo8RpPum/DYRAh4bV7t8WK1ehTSd34ishse3
         6LqkrMidlVAo/ZNFH7ftyfNwT2UVi1EnHuDcb5Rskllh7mDKfG4dg0DvH+FNVj+Npj/O
         HNqXL+29vTvo3zLKueKBR+WzcpQXLfIFYgJywR0EgKtha+my1aC3QZRg2IIYHBK2QeYu
         R4yaqPKgws5SOc483b2RpJgXgtss8bE2zUhIn2Shin2d6HksNRcb+fnE6aVXlkZhMMMy
         X8ng==
X-Gm-Message-State: AOAM530OaBkqnkErhJZQpOfIk0FIY1Ng4LX/2ozsKe5jmrmcZy33SDY+
        B5ik/D576x5BaWWw4iFX1HRNKC/G
X-Google-Smtp-Source: ABdhPJwMtRkSD7TIPO6ZTiXmxF3r1PAm7TUctbxFQkOFjUe2x6oAR6IQWq5jQAXcDoOeP/0M9WZ6zA==
X-Received: by 2002:a7b:c311:: with SMTP id k17mr12644754wmj.148.1590839745598;
        Sat, 30 May 2020 04:55:45 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id l18sm3405332wmj.22.2020.05.30.04.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:55:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] CQ-seq only based timeouts
Date:   Sat, 30 May 2020 14:54:16 +0300
Message-Id: <cover.1590839530.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The old series that makes timeouts to trigger exactly after N
non-timeout CQEs, but not (#inflight + req->off).

v2: variables renaming
v3: fix ordering with REQ_F_TIMEOUT_NOSEQ reqs
    squash 2 commits (core + ingnoring timeouts completions)
    extract a prep patch (makes diffs easier to follow)

Pavel Begunkov (2):
  io_uring: move timeouts flushing to a helper
  io_uring: off timeouts based only on completions

 fs/io_uring.c | 97 ++++++++++++++-------------------------------------
 1 file changed, 27 insertions(+), 70 deletions(-)

-- 
2.24.0

