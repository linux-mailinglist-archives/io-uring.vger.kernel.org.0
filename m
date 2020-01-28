Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD1614AD00
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 01:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgA1AQe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 19:16:34 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55275 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA1AQe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 19:16:34 -0500
Received: by mail-wm1-f68.google.com with SMTP id g1so586615wmh.4;
        Mon, 27 Jan 2020 16:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eM3aXMdviE6hTyCVscRclhpEvOjmEe6+yzv4IO5CG50=;
        b=A4FCXU3vjyEJWOe+O4sHm46rFOoDr2hpoOrzOFivFzbn8PW6trEzakSvWlN1gtJCQB
         oF4jvdJ+S74YR1sdfUn2GQQoT/rGzoxRlxdBGHG3064oafaZ3ievuyfKliexo2R2bMwC
         ZaMf1T5Qv+AFAUft7zIEjO5VCifasU+aEQ7of5xF8KHmgglGG6SFu6LUrtSZ7FRHck9F
         rvCpoa3TeNYfPSXSGiJWsht0vNBQH+Akm+ZG+vSAWqeohU5I5I2tWrXe/NX6NUGUd73u
         AH0w47TbrA33V9sS6XCnecK1Qsy+7g9iVkQkFG3UBAEBhbVr0qu0g8tO/6WtDqaNpS3k
         LY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eM3aXMdviE6hTyCVscRclhpEvOjmEe6+yzv4IO5CG50=;
        b=XonipEVtRGfYVGXdjbXLF4V8IEacKi8PiuPb0Qs4gYgEFrfddSK87xaPkq+vy/bOaS
         lcUutCCdlCqo4xl8oD1QSgtNqpFNnIDIeiukfb/My4PQ0wyIHCUllb126Zi4NLzyII+K
         4mziGZAFWAGtFfGatSDVFgvgwoFInTMlMeqJRJzHNqM53SXz48rQVqAUTalP2a9g0JnN
         uSP9VZfUs69DA0UZB4ByBbApwYvNWROGow++EmR51U0EBLRQnJwJ5kaz4hNzQvLKjE3i
         8txFZkowJh/Fh9RL1sJkK6gGNeDzc4KmHl9reWTUgbgax0Mrtdwk5pjoCHqDB5vramNC
         vABg==
X-Gm-Message-State: APjAAAV9TtqR3y99RA/mhSrJrhAZZ9F11V9TVe579lEfT+secCgjCp4G
        vFuDYV3XVvCSiiuDyhp7t9BedhBN
X-Google-Smtp-Source: APXvYqyn5QoZ09WC7hXyqSMC70hZBDNbZL5BUq81/tbwkinFyuoLBrADGdD7qvNrYelOLvUPkPAkQw==
X-Received: by 2002:a7b:cb0d:: with SMTP id u13mr1257765wmj.68.1580170591498;
        Mon, 27 Jan 2020 16:16:31 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id z21sm638426wml.5.2020.01.27.16.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 16:16:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] io-wq sharing
Date:   Tue, 28 Jan 2020 03:15:46 +0300
Message-Id: <cover.1580170474.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580169415.git.asml.silence@gmail.com>
References: <cover.1580169415.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

rip-off of Jens io-wq sharing patches allowing multiple io_uring
instances to be bound to a single io-wq. The differences are:
- io-wq, which we would like to be shared, is passed as io_uring fd
- fail, if can't share. IMHO, it's always better to fail fast and loud

I didn't tested it after rebasing, but hopefully won't be a problem.

p.s. on top of ("io_uring/io-wq: don't use static creds/mm assignments")

v2: rebased version

Pavel Begunkov (2):
  io-wq: allow grabbing existing io-wq
  io_uring: add io-wq workqueue sharing

 fs/io-wq.c                    |  8 +++++
 fs/io-wq.h                    |  1 +
 fs/io_uring.c                 | 68 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  4 ++-
 4 files changed, 66 insertions(+), 15 deletions(-)

-- 
2.24.0

