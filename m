Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13EA33F582
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhCQQaO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbhCQQ3q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:29:46 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2519FC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:46 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id o11so41682870iob.1
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HOPvjMdEm7C8k6jLpI57WuAERUzO9zl0hbjM69uRvNw=;
        b=pQ/2adj0B+ZUd5Q9ElB0C7yKpJd+EDZiW0wjitzl+ms0IHtK9Q/oXcgixJ1F9L8NbY
         9Op+BhCrMUsPUJm8ghqSqoP4uBvAyegB2LAxKk3fydCezWY6tla4xS0nfI1H+Ac1rgmi
         CYtwPMqMgxNhnhskhSzzmOAjTKOknH2/gluAwcrIB8JzPeCCUwOe9Rj7xEESj02kR8vC
         NUa+U6ivMwKpQdaiuQGeXa6wJ73k3CKySq/SH19muLJ0hhmmZBo4VCwVd8gR2wYGspPQ
         XMFGsBqTUFz7Y4eHpPaBhgrNiuAHj71fLO1I0ZXZw++XQKos4k+/+/IcePN8LLT1IPdT
         Mr1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HOPvjMdEm7C8k6jLpI57WuAERUzO9zl0hbjM69uRvNw=;
        b=ExBUuQizfiuTeV7yLM8Pm0v6GRn9umCAEM4Mr6AGGu2mv9KAyTIwmYUbWKlIqV4aql
         gG1F0nPsQSvTBqQ/q+y9q7IdwqyeRiUWZwqQrZRgBbCPEsonZtGjwhsS7p9o9wLZqsiR
         7dqaZQWgx7VxEPAGOZRUEbACQgKGha3nYEunkd2gMZMYHsqr3vwziyOU3KJzxDYv7EP/
         9yOFsLJ/9xpl7FaaZsfratn91D6u8fpDUKIDT55F3mPf0KJp/FjVxx5XOFvOVkx/hrWh
         MKQAObN5PrP+s7Atvdd7OMZ9kWAMhnKyVqUmy1CiILFkOEmkk4hmw9pzCW6mSE+AKrIX
         CqrA==
X-Gm-Message-State: AOAM533IFskq4Fm564Z47aitps80ZM0m9VI/2FuASA9PWTkabQ/Dd61M
        OsRHn9w8td/3NeVVWPEtpHE9Ju082ldxig==
X-Google-Smtp-Source: ABdhPJynM7s/RAqvSTBuAf+0RqbFxuhWfYpYyK1nt204028JymHiLF3/QQOFYwETvIDlLA+9JsXFdg==
X-Received: by 2002:a05:6638:2101:: with SMTP id n1mr3574504jaj.7.1615998585377;
        Wed, 17 Mar 2021 09:29:45 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm11164271ilo.64.2021.03.17.09.29.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:29:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/9] Poll improvements
Date:   Wed, 17 Mar 2021 10:29:34 -0600
Message-Id: <20210317162943.173837-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Here's a series that implements:

- Support for multi-shot poll. This allows arming a poll request for a
  given event mask, and then have it trigger multiple times. The default
  behavior for io_uring POLL_ADD has been one-shot, where one SQE issued
  will result in one CQE filled (when the event triggers) and termination
  of the poll request after that. With multi-shot, one POLL_ADD will
  generate a CQE every time the event triggers.

- Support for POLL_ADD updates. This allows updating the event mask (only)
  of an existing poll request, both one-shot and multi-shot.

Outside of that, just a few cleanups, and Pavel's change how overflowed
CQEs are handled.

-- 
Jens Axboe


