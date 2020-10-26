Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BB6299806
	for <lists+io-uring@lfdr.de>; Mon, 26 Oct 2020 21:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732472AbgJZUdP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Oct 2020 16:33:15 -0400
Received: from mail-il1-f177.google.com ([209.85.166.177]:47012 "EHLO
        mail-il1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731933AbgJZUcf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Oct 2020 16:32:35 -0400
Received: by mail-il1-f177.google.com with SMTP id a20so9877260ilk.13
        for <io-uring@vger.kernel.org>; Mon, 26 Oct 2020 13:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ej2GMD3juW/HPbjlUpE3qDooC5R+I0d7dBs1GT637cs=;
        b=vc/H70RYyC5V5F5lu6wLgt7+9bIn1CccBQcJHwMeViRuDSFz1rhLmAjcbeeAq54dWx
         oX0uBJiR2QvZSRMlLdeJiXZujRIE0xfM4u+PoaTHljw5MEB/kanXgmfE2XRvtcIjKNU5
         ZSAwdNgrXvI1c4lN5xFvMO4WgVIoRl49ciHu47462Tcyeg+SXr1SxxofrjylXVRgmI0Q
         K/LLrlg0SV1PECUo0yLIXdiESvvnXfO0iWiz9OHYopQk9HpSifZkCsOp5SB+L7cBw1Eg
         tzjbGDjHelpJ72CVaA5mXiMWzoRFBVYInm5Z78csw0eaKn29OxZQ1rLYjVMG5b10+QXJ
         vacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ej2GMD3juW/HPbjlUpE3qDooC5R+I0d7dBs1GT637cs=;
        b=DDf6r/UHHldwS8rg8KHeV/+Uhadxjc0gTjdPYZk9NN+n7cz8KkJdJWt52qdn+QPh0W
         cYnUpQP5xBZeaprwRKOuHLVhBPBHoXIaG6rsck53zhRWR01mtgSzApLEFSHRg/1kv1gs
         LOhnTbVPlRjOSkymvW330mrWuYVfhJ0aFoxWydL52Hgi+m69pue+UviLZeC3AhMaNBtm
         P8Gu3qelBrBzdjMBr+0xek4vt9NnkqJMx6wZx9oTw5CyKiIixQOfBjo6Fccda5NRw0B6
         RDJWE0e1yszl8l3ScNrNqobD/fH61JT3bhLiJZ6RYwLO6zPpqj0fiR5l6zVj1lSd2DNa
         xqzQ==
X-Gm-Message-State: AOAM531WB4zjg1vB+c1rAhZAgrbH/lfFWHugYFbbdO6O1ysdhielryZD
        TXyo8rljHGByUerToYvminVEclFDyiXsBg==
X-Google-Smtp-Source: ABdhPJwKMl5RhS+cjY9T42TGF/AeVTmX/CoaoNgStOF3T6iQ+IDDnrcU1dRHfbZSsdlfaGFgHUSS5w==
X-Received: by 2002:a05:6e02:f0e:: with SMTP id x14mr11787434ilj.307.1603744353856;
        Mon, 26 Oct 2020 13:32:33 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e12sm6770373ilq.65.2020.10.26.13.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 13:32:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Subject: [PATCHSET v6a 0/4] Add support for TIF_NOTIFY_SIGNAL
Date:   Mon, 26 Oct 2020 14:32:26 -0600
Message-Id: <20201026203230.386348-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

The goal is this patch series is to decouple TWA_SIGNAL based task_work
from real signals and signal delivery. The motivation is speeding up
TWA_SIGNAL based task_work, particularly for threaded setups where
->sighand is shared across threads. See the last patch for numbers.

On top of this I have an arch series that wires up TIF_NOTIFY_SIGNAL
for all archs, and then procedes to kill off the legacy TWA_SIGNAL path,
and the code associated with it.

Changes since v6:
- Rebase to 5.10-rc1

-- 
Jens Axboe


