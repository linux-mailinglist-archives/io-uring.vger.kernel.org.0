Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0902C124EE8
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfLRRSo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:44 -0500
Received: from mail-io1-f51.google.com ([209.85.166.51]:33799 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:44 -0500
Received: by mail-io1-f51.google.com with SMTP id z193so2800172iof.1
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r3vukti+CLw/8JrimF1c/PZLrrkMMeQEGucHUPA8JL8=;
        b=pZ/i7gEKZtUqRTOdkkVusBMkchxIfTqE8AbodBMMZNfHZVRfjzsEChf1ctZ7sIek1h
         PzM+v9Yb7IREcuVDtlZBC/g9ohauyN5y0m03aclm8p+F8y7HQ+o2W6dqtOAqWoZ1GD1d
         Rb9ySznl8RaOy/qhrr0z4hbv6MGJFh7zxOGdqfZsT3ROYcciRj/lfBqqoigLVJL2Ol82
         GAvxZWRHNZUuDqMK68y/Y1ADGXunk3gqKdIyQwYc6QmyaL13IcSsiNCIf1TvRqr139vm
         aaXY5mq8fp7Kc+ucUKr0AdXgzFcq83bTHGi/4GE5lzDqExsUAF7A8+6bRi2tGmfILFva
         kK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r3vukti+CLw/8JrimF1c/PZLrrkMMeQEGucHUPA8JL8=;
        b=VwDAylx9LJhcDdHDPAFwPznToq9eX4uR0JlTNF/ABjPbC1O37GY4aS90Hl2a0ztZCi
         azvNlKiNhRWyI0QT7q8WzuaSOS9YJuV1nuQkN6JpEJaU1os0GpVIpMmXPHuZhr3O6Ucf
         zGOLo7CNWZRedeYJozEG472OKoXwjh0cuxG591Ln1pZDhEnaJjtS377mzwQyU8DVI6NX
         bjmJrx0+uWUaUO14pQhBfO9a3dn7GJj2YPZ699ofqAnumgrDPwanv1zZCdfYRt+WIYIM
         Fe6p3C5c0yd7mFX0Zymj9pa/myGcniVuk0TSr79rTDONIKKnKqcI77LZvR6WzmGHNGVB
         KAUg==
X-Gm-Message-State: APjAAAV/ED2GWbRFl+27Zrg0UVQQr4qEjwX2jfNMokBzVno8bznEpesS
        SCbUXQM6KiEY3Zi9pbTbU7Picj7AgmIiSg==
X-Google-Smtp-Source: APXvYqyBiE5NoYNyprDzsWJXNHzzWY3lGEwcccPUfpnxVBZgXBCNy+Smza04ktblrhHLp/atQEyrEQ==
X-Received: by 2002:a02:c942:: with SMTP id u2mr3402349jao.49.1576689523041;
        Wed, 18 Dec 2019 09:18:43 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:42 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v3] io_uring fixes for 5.5-rc3
Date:   Wed, 18 Dec 2019 10:18:22 -0700
Message-Id: <20191218171835.13315-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This should be final for 5.5-rc3, I've run this through all the
testing and we're solid. The main changes since v2 are:

- Add Pavel's patch for the wait-and-submit issue
- Drop the ->free_req() addition. We can do this without adding
  extra io_async_ctx storage.
- Fixed a missing check for CONFIG_NET

I think this improves it all around, and it makes me more comfortable
with the persistent state. There's three patches that deal with
poll add/remove, cancel async, and timeout remove. Those are the three
commands we still missed that need to retain state across a deferral,
and then a patch that stuffs sqe->opcode in a io_kiocb hole, and
ensures we assign ->opcode and ->user_data when we retrieve the SQE.

Lastly, a patch that adds a warning about new commands that don't
have a prep handler. We need that for ANY command that reads sqe
fields, which is all of them obviously except NOP.

 fs/io-wq.c    |   2 +-
 fs/io-wq.h    |   8 +-
 fs/io_uring.c | 703 ++++++++++++++++++++++++++++++++++----------------
 3 files changed, 485 insertions(+), 228 deletions(-)

-- 
Jens Axboe


