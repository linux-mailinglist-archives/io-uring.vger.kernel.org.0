Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F542838EF
	for <lists+io-uring@lfdr.de>; Mon,  5 Oct 2020 17:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgJEPEp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Oct 2020 11:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgJEPEp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Oct 2020 11:04:45 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB6AC0613CE
        for <io-uring@vger.kernel.org>; Mon,  5 Oct 2020 08:04:44 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id n6so3008663ioc.12
        for <io-uring@vger.kernel.org>; Mon, 05 Oct 2020 08:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ygm9tOI5Xt1uO5vTjLLaVjSmH29apSK8TYFI2iYmjQ8=;
        b=KzrI7ptH6OVXtQcBwLwuI9qJjwQeBp1wCZhyo7t4OfZoSp8jSgp1I6464fktCwNo+A
         UPsBSjc/CVCqIkxCYKrCy7RwGK+BEQyx5dD+3ZW9pIHSMO/RAYPPuyirlDOkOmnuoFm3
         4LDjaRehvVlW2tTGqIoBKs3SZQXefWNZanOf/LzGzkIuOVh3DfTCclEMAB5SSObsWYgg
         qFGoTPYvMp8Jp7grRQcy8dn1xisVxCpwXqqb4jWfuyjQT3irF17GwMgyYwJe3QD0Ng68
         SeTpjCNYZs1kAHWAoyVi/MhafenupDUe75bEoRw1mydqolhgTitGvJ6TUR4FrxFYqbLd
         O/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ygm9tOI5Xt1uO5vTjLLaVjSmH29apSK8TYFI2iYmjQ8=;
        b=Yl2AA25P5NWJWa30pZeIstDTdqh0Kxa0Q+JdVcUFw8itJIzqpOk81CDIozN8zAYmBl
         rOEXR/cvFtS/LPqu9bpO+IpHs28ocVCWouNpf0rowTgcNGE+wb2wbNtBJcxE90Wv5QDd
         7cb0TOTHHPGnQNQI6eHy2CHeBvoT1EFCE+Z8Inhir0SDxZcFesb8f5h59ihOdgjDzIiO
         dOUV/uTqvgLqKJjaos2JIaaBAB50H/6d7onria81f7zujBSa1Pxcy/Gxv3ZIEqnMqbgL
         3xY1Jwcuzx9nQtJspMG6no82uRO3DWwYlt/7Wg0H3vWEOFyrsvdVYqYB+4TkElb7spp0
         EdDw==
X-Gm-Message-State: AOAM530X5iJ4HnPy2xhv2T1tmXp/cnQjf+RDqwO7ZFGoYuvqZQgTJdaY
        uDz31Jpb9x4QyOaewcNrNkQa3A==
X-Google-Smtp-Source: ABdhPJz9phS5bF37gNvcJ53Bc2xYRCou3ON/bdXJfbQuH4hTa9/6uN6shgizOuJ2MgvU+uBX3rLqSw==
X-Received: by 2002:a02:b388:: with SMTP id p8mr306351jan.129.1601910283681;
        Mon, 05 Oct 2020 08:04:43 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 15sm33140ilz.66.2020.10.05.08.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 08:04:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Subject: [PATCHSET RFC v3 0/6] Add support for TIF_NOTIFY_SIGNAL
Date:   Mon,  5 Oct 2020 09:04:32 -0600
Message-Id: <20201005150438.6628-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

The goal is this patch series is to decouple TWA_SIGNAL based task_work
from real signals and signal delivery. The motivation is speeding up
TWA_SIGNAL based task_work, particularly for threaded setups where
->sighand is shared across threads.

Patch 1 is just a cleanup patchs, since I noticed that notify_resume
handling has some arch redundancy..

Patch 2 provides an abstraction around signal_pending(), in preparation
for allowing TIF_NOTIFY_SIGNAL to break scheduling loops.

Patch 3 just splits system call restart handling from the arch signal
delivery. Only the generic entry code is updated.

Patch 4 adds generic support for TIF_NOTIFY_SIGNAL, calling the
appropriate tracehook_notify_signal() if TIF_NOTIFY_SIGNAL is set.

Patch 5 just defines TIF_NOTIFY_SIGNAL for x86, since the generic code
is now ready for it.

Patch 6 finally allows task_work to use notify_signal to handle
TWA_SIGNAL based task_work.

Changes since v2:
- notify resume cleanup
- split patch series
- improve commit messages and comments
- kvm TIF_NOTIFY_SIGNAL handling

-- 
Jens Axboe


