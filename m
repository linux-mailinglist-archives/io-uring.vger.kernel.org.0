Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2933E4511
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 13:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbhHILxf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 07:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbhHILxf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 07:53:35 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEF9C0613D3;
        Mon,  9 Aug 2021 04:53:14 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l14so4055953wrw.4;
        Mon, 09 Aug 2021 04:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F7px3/RhhfdEQF1GCZtJ+l7Qs0X8n7TnykM1fetOVG0=;
        b=Ip81nm8TIohzme1FL99Mnae76HMIpXm6YRYKJSYKq8a7Xh8bjM5Fml9R4+FLewtWun
         9uomycwLZbn0i4C/UsJKY6h5lNuiy9cRQUEjOij+FNM/BglKG8vPNGRII4yv727yxcg4
         eS8KDezFVDiMFM34MGymXDCenUHhZPaYj0rsbdFqbfUZHMcfTGTZ7JgYw/3nHPKoWRyD
         FrMB6GX/gD5lpSBk5SfaIXhe1k2JF+P6mblrdYiUtPB2CNPEfrNrWwp3RrNR6eLSBQ6D
         6w7ZuG01VoSmLH60kxJqR+XTvfTeTaiq1wdAvPN+is7nbToIC2p0DHIQfUsvFfRAmUfo
         KNdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F7px3/RhhfdEQF1GCZtJ+l7Qs0X8n7TnykM1fetOVG0=;
        b=KEdF5keCk3ZT0TeWSEophFmSj3s1ZmiTJLtAteJC8z0cv+tX08tjXxLq/b+Fv5FBVJ
         0WofNkleo9IYlBx/dj9YOBODN+GsP+tRh+ImT0/VY0225Ou6mw6HQVd9yDKp1G5SndjI
         vwI4fLczkbCMVUMQIk7EDQ1FUy0P+7+dMxtso3b1DI77Rl3MOOKDl9a5G0cqKEF/cX56
         1RWzlKgWuyL5P8kcHwNaRWXW2Du1oMsSK2wkR/+vu0/W2z5AZ0HowQsKbiHU+ARIKT4h
         te7SBUaADVeYp/l5ca2Yd4b4HwdfP2iWGwy9ba+HEyW6bDcnrwL/EAhCcS0UKGBHdwqP
         JHQw==
X-Gm-Message-State: AOAM533nWRWahB6AItpv7XKTR8GplAUyDTM71nULGKZjkM3BN3vsQNat
        L19weuqqvQTqOICRoFOwqOkB5kk80ak=
X-Google-Smtp-Source: ABdhPJwISBEJDYiL9EQjEdEjcWaKg904G1jcSrpfXgLSDjfRcrjAwioIz4x5Dx286nV1QTkGyDHPQQ==
X-Received: by 2002:adf:fb8f:: with SMTP id a15mr24916254wrr.92.1628509993282;
        Mon, 09 Aug 2021 04:53:13 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id f17sm22876828wrt.18.2021.08.09.04.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 04:53:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, asml.silence@gmail.com
Subject: [PATCH 0/2] iter revert problems
Date:   Mon,  9 Aug 2021 12:52:35 +0100
Message-Id: <cover.1628509745.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For the bug description see 2/2. As mentioned there the current problems
is because of generic_write_checks(), but there was also a similar case
fixed in 5.12, which should have been triggerable by normal
write(2)/read(2) and others.

It may be better to enforce reexpands as a long term solution, but for
now this patchset is quickier and easier to backport.

Pavel Begunkov (2):
  iov_iter: mark truncated iters
  io_uring: don't retry with truncated iter

 fs/io_uring.c       | 6 ++++++
 include/linux/uio.h | 5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

-- 
2.32.0

