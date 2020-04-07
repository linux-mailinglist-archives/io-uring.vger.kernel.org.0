Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C031A10E1
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 18:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgDGQDF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 12:03:05 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:56200 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgDGQDF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 12:03:05 -0400
Received: by mail-pj1-f47.google.com with SMTP id fh8so937908pjb.5
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 09:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TNKxZJmrjHfu+XUeU88xo28pJIKSnJJV0Uga7bioYT0=;
        b=jnWQIpub/ys9PZB1W6WDDOqiaHEo2UEdl4eC2e6OwPn5hhZvl092Mgzv5/bMgSAcwj
         r9WprBM6dumAeDa1zQpcqefkb0jvKNgzLjaBfACXJ1u8FYyhQQMuuX6g+Zx9gMWZv4Bz
         2BwtakeOXZDYloeMXBhHf+Un4S6niSbcvaO90Lp3jt6ZQIbHBz8ejeWGTj4on1kmKPkQ
         MwTDwTrx+S0KpkTOYtM2Tr9IqLJoU1dbAfhW++prpE4k+ZPBiBFZoh4iPfn3fAD/EwWm
         ZJW8+skf2iuT4UkKGra+8G3fwBYFhdGIfrI1z65IhD+ecMi81KUAPWDYRq/5Q6Bx7/Aw
         kJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TNKxZJmrjHfu+XUeU88xo28pJIKSnJJV0Uga7bioYT0=;
        b=Vanzz7dD+Wlf7w4mn0uyFOttaf0abOQ2ggFo6NmaBTu946sOAw2pSA+k5k2b+sfSpr
         aSlQlF4udEntDCG1c+RA7jLJZwO1ipJ8jVR03qPwUEp154rLGEhzvrFkhlt+FonqH7Hc
         Ez6Ia507ITigwZB8/sJeHFt94DHKp/k20HmzFYYkRZtllqMKUODNnzkb8akcV6LP4/KY
         S9XZh8rdoxst/jdLE/1Y/1AWbGWpAtksTiPBRrTSjiIn+4/pnT9rthYrsLpQrMnBN1By
         DHrMLzlN4iqD7Cwh+Q0kbMiF2DfaD+YxxZ9n7Qt9uzLB9W7BiaopSPzdMO5AX5+hFaxH
         bogw==
X-Gm-Message-State: AGi0PuZAYbnm4eIs1XvcZt8pfXmkTWy+3k9eUIZ0Z6nWGW6Sv5T+o9Su
        CmAh5QKwnZRpDndJg5P/J2LjXHIS0SHWYA==
X-Google-Smtp-Source: APiQypJ5UwKiNgv5+PdsUOspeEa8oplOUyeR3vnqp2+InaUdTTKVrWNg5TkDOMZw/vewA3JN2sMCgA==
X-Received: by 2002:a17:902:690c:: with SMTP id j12mr2889127plk.296.1586275381113;
        Tue, 07 Apr 2020 09:03:01 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id y22sm14366955pfr.68.2020.04.07.09.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 09:03:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk
Subject: [PATCHSET v2] io_uring and task_work interactions
Date:   Tue,  7 Apr 2020 10:02:54 -0600
Message-Id: <20200407160258.933-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There's a case for io_uring where we want to run the task_work on ring
exit, but we can't easily do that as we don't know if the task_works has
work, or if exit work has already been queued.

First two are just cleanups, third one makes task_work_exited externally
visible, and fourth one let's io_uring call task_work_run() off the
fops->release() path to fix an issue where we need to potentially flush
work here.

Since v1:
- Don't add task_work_exited check to the fast path
- Ensure exit_task_work() always runs

-- 
Jens Axboe


