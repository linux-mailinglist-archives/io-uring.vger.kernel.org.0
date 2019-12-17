Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6E1123A4A
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 23:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfLQWyt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 17:54:49 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:32774 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfLQWys (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 17:54:48 -0500
Received: by mail-pf1-f170.google.com with SMTP id z16so74627pfk.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 14:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+6VsXJWqDNiMlOoeqWg8nvDmhkX3xHqydiNsag6VpFk=;
        b=oflzSesVZpoF/8WdswEP1jel2lemiQ4zKtiUefAyVouMfSIq3pjs+psF9I0mX0aHNh
         a4AFi2Ty+6Wcn7ZZ3F4/nA7Ochqexdhup3iNshPyAiSboZe1QzaOJPDmO45pBAlFXD7L
         fED1RcQKzfrT9EithnrLZyOv/YXbn+39Z0ZeAnA4NiMJgv2SXga8We9FdCLyCJ/1cWAD
         UswrRRS7d4B1h00nv+2HLu9UhGEzTFnp7BP6KRPKSlEdWIxfoU/ax3J5+/UT/HAYNHaF
         Iql6SUafNdTy6DxopkvP8SCjlZ365TG0kf0OpMcSRxadC4aX3YrLSfNBM/Bg4u+PjQ+g
         pRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+6VsXJWqDNiMlOoeqWg8nvDmhkX3xHqydiNsag6VpFk=;
        b=Tou20bvY1eyrZTweHf/y7y1Asb/WLCBAdQPVJzTJscLdE82GlFZIaMJzgh+zmNL77e
         K6jq/CA0bBhXMXgIN0jWSu8nGT5BY1MZpfBEboaesIuzGpnH/rGd671F3SsJqOWlilcy
         fWKPifWHc/6dWXbtOLZmswC9aVQ0ETTV7qAr047WXrm2KWVoW7VtbGMcTgxQfRiGhtvy
         2fDEitsIxAkdh2K398b2ooOJzRsZVrEjvAh1Y1wfKV0vltJ/Vn/xfw46HoXYpSOXKxZr
         Ihy9fEiS67949/kT5xwsFMKbC3UB4E35nRLTAt4Sx1V9YTkDPyJs0DUKmKAmanBYPlb9
         CJEQ==
X-Gm-Message-State: APjAAAXRdSt/yiCPYcDb3m7qqySA8wxl6d5548vXjVUSAZyQ+VQIloNt
        n6Cty4l8GEHiM+X/ms+UxiBxXNlhqCpilg==
X-Google-Smtp-Source: APXvYqz+IvYstkGGMwPHXrlalxd0j7COtSCRykG58qcjQRCrZjEfFqPeJbQZzyD7X2u6k2/bbxlQnQ==
X-Received: by 2002:aa7:8193:: with SMTP id g19mr118275pfi.172.1576623287843;
        Tue, 17 Dec 2019 14:54:47 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e188sm59320pfe.113.2019.12.17.14.54.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:54:47 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET] io_uring fixes for 5.5
Date:   Tue, 17 Dec 2019 15:54:38 -0700
Message-Id: <20191217225445.10739-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Mostly minor stuff, the exception is the deferred prep handling to
ensure we have a stable SQE when doing issue. Most of that is just
churn that moves code into a prep/finish handler. I think it makes
it easier to follow, too, and it fixes a real problem that got
reported.

 fs/io-wq.c    |   2 +-
 fs/io_uring.c | 513 +++++++++++++++++++++++++++++++++-----------------
 2 files changed, 339 insertions(+), 176 deletions(-)

-- 
Jens Axboe


