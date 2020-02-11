Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91507159A22
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgBKUCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:02:50 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34411 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgBKUCu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:02:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id t2so14094332wrr.1;
        Tue, 11 Feb 2020 12:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=23v7TZXuNq67B9vNMnB2JOzcUNo7fx1FqP4BXdmSU+Y=;
        b=dRCCjuK3T3v/6PPVyqufsmmGHNay2UWxLNFhfwOv1STRrFCXLYMZ/tfOvpS6O5V0D1
         L692vMbe892qCoXbahjvChiR/zqqHRurZzh7Eyqj1EC1aMUHE6Mgoa9q2uqB529/j36w
         Pmv5pLqCY25siQt9fYZHcfXamCxYSB0utVaCuH1QUhZOjrUdNhRXIbliIrf8iHUVfnTP
         OhVKEd5eUSjzAlEalq2bSbqLKRhmB5LhwFwkSt7LtT1oYXCb9ranP9ycsg1rPEJ9Z3nn
         gKqe/qBhSkFuM6fQrnJMCMzxpFQtGJCgI/g9SNHcFSrC/kDLgdTHvifL6nUj4RhqPnXT
         1OvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=23v7TZXuNq67B9vNMnB2JOzcUNo7fx1FqP4BXdmSU+Y=;
        b=b8C2ut4zjV7ijoRY19iGbzi3I6gUEUzBcwpBH7HdwHGi/gOZHx4PR87CMVUiv4hwwj
         Yy1jvd0hhzw5aD/uzxnU1mMMzWCjc3N23NAWRRHEYNhvgPVaO1QvLXHrKvEEurzhX9Qo
         96uCO+VePmuUBUbEOrRr3xLMqmvszavM+VbWeEDOBzcA5r6ThkAMjRhDSPG/PiteG/R5
         v/wIEiyNqXr95tBoys8N0pTrmC9PrPVvBqJ/Dx/q1cv9czItjbc1Ls04OlpI4KndMVXA
         txsnVyRpBugdQ6gtUE3YsG+HdqdvErbqTgPE7Etpvu4IRXmcidL6QTNuEsiUX0lXOOyD
         h8iA==
X-Gm-Message-State: APjAAAVc+0z/FKgTipf7Arzw70y3O4OpvqPjUJLwguWOsapBzU2+7igy
        b9R2ceMszIY7ZifYgsSu2cgxPl7f
X-Google-Smtp-Source: APXvYqyXK2uy4r0ccxX9msxhn2bG71jbWadFAWPP77tGywkKq4nDUndwIfP5GZz1Tv6InMz245X6CA==
X-Received: by 2002:adf:ea8a:: with SMTP id s10mr9880713wrm.278.1581451368100;
        Tue, 11 Feb 2020 12:02:48 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id 4sm4955101wmg.22.2020.02.11.12.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 12:02:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] async punting improvements for io_uring
Date:   Tue, 11 Feb 2020 23:01:53 +0300
Message-Id: <cover.1581450491.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This cleans up io-wq punting paths, doing small fixes and removing
unnecessary logic from different submission paths. The last patch is
a resubmission after a rebase bundled into this patchset.

Pavel Begunkov (5):
  io_uring: remove REQ_F_MUST_PUNT
  io_uring: don't call work.func from sync ctx
  io_uring: fix reassigning work.task_pid from io-wq
  io_uring: add missing io_req_cancelled()
  io_uring: purge req->in_async

 fs/io_uring.c | 122 ++++++++++++++++++++++++++------------------------
 1 file changed, 64 insertions(+), 58 deletions(-)

-- 
2.24.0

