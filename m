Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210BF47656C
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 23:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhLOWJF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 17:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhLOWJE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 17:09:04 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3A3C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:04 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g14so78912441edb.8
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cXKWjOWwCKMXPMdaQKcCIj7d9Mfr1wyl2LHyh/AgAGM=;
        b=Kg7ySUBb3T0SepCxXCBlE6Tl5dwhBo80/zDtalnYPLXBb8ibTTaJwq4w2KJ6E484hp
         fK2XrCQHXIhz/YPIEpusUoQ8IkOAeWXHhLp/41I5s1rXmrsw5kykzPcX7f4IF4NSaUNm
         w8x+1S8CCitap/U87roFGJavHVA5fEN2RtaZZEk8lPIZxVm5GM1Db4AvN9mC5wFOtkMq
         mhKW8anDT5nBMS5JlcdxFiF7ZnUEjvUzrdHrVPqBQOQl2s6kwatvfFOI/3Ej2zc0UL03
         AK1MPpEPIYgQ7n1NTYp3Ix3zvRFZgziG0kL3nx/vPpyEJJuV7AcwZmTfxsXVgNr0bIzf
         SUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cXKWjOWwCKMXPMdaQKcCIj7d9Mfr1wyl2LHyh/AgAGM=;
        b=RToGL5N0KX8W3S/tWoJcF17HDGt7jhVC++IrSqRLLKC6nLJ5rh8lDeGJ6g6DSAUDIg
         aCFNpDP529HUF9DaWY6Cid082VRbEW9CsDvA/hXDnlQAykNVVacq++Gx34eoOh3sGCf7
         23TO4lJ2QdNwBIVGxPAEw0SxSgU6yq1UMXqccwffsfb3xnA49TB1asHf/+w5HqXs7PCd
         1522jcZqdy5OTiBCfZ1SleEzVFZrbThEPmx+Slo5hkxaVzkXoCIbPL4dqDzUeIXj4nqf
         hlXZMTMaVtEVd1Rd8IUjeuCpMVWTc0z/mQqK8zZvp4WrttHqaAaaB1tJTpBEJ6NOf0xi
         8ehw==
X-Gm-Message-State: AOAM531yLV+kWLZ3H+0af+9b9B78YXhmvl4TybRJSHBpPQiA6AcUDJ22
        Nv6xNkqBnfBadOukUkpvhZeufwXDRik=
X-Google-Smtp-Source: ABdhPJyYJPlWRKNElilJj7Hk7IR6PZDqg2FHAm/a/t6AbsFg/n+S9OkwBOayXxbGNyWcBpoSnK9E3A==
X-Received: by 2002:a17:907:97d4:: with SMTP id js20mr13210108ejc.416.1639606142506;
        Wed, 15 Dec 2021 14:09:02 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id l16sm1572006edb.59.2021.12.15.14.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:09:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH for-next 0/7] reworking io_uring's poll and internal poll
Date:   Wed, 15 Dec 2021 22:08:43 +0000
Message-Id: <cover.1639605189.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

That's mostly a bug fixing set, some of the problems are listed in 5/7.
The main part is 5/7, which is bulky but at this point it's hard (if
possible) to do anything without breaking a dozen of things on the
way, so I consider it necessary evil.
It also addresses one of two problems brought up by Eric Biggers
for aio, specifically poll rewait. There is no poll-free support yet.

As a side effect it also changes performance characteristics, adding
extra atomics but removing io_kiocb referencing, improving rewait, etc.
There are also drafts on optimising locking needed for hashing, those
will go later.

Performance measurements is a TODO, but the main goal lies in
correctness and maintainability.

Pavel Begunkov (7):
  io_uring: remove double poll on poll update
  io_uring: refactor poll update
  io_uring: move common poll bits
  io_uring: kill poll linking optimisation
  io_uring: poll rework
  io_uring: single shot poll removal optimisation
  io_uring: use completion batching for poll rem/upd

 fs/io_uring.c | 649 ++++++++++++++++++++++----------------------------
 1 file changed, 287 insertions(+), 362 deletions(-)

-- 
2.34.0

