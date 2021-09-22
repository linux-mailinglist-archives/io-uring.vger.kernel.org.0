Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6605B414C6C
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 16:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbhIVOv2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 10:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235464AbhIVOv1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 10:51:27 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2B3C061574
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 07:49:57 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id i13so3017256ilm.4
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 07:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nwcwy9+SEKk0IYBTIx4c6izQ+wfusS08Gk4HpdIOwgs=;
        b=MYmkAjHcfOLyI6DqIxl+HUsdkEcw1FnDzWbK1v1q/AqhhrTqoHk6SY8d4+DYAnIvwo
         QT434HDZkiag/T8wTaTc4SPfIKEv0W2KjPY5apjBDbYM5vCk9H2pe2UFoS2gG3/QvX4S
         x1/UcYfq0GjQYb+13BaEWw09jgzKHJZOUFnDiNwD2Z69vU9esspNKdlAfit6b0LzT92A
         i6jInsRjx7H79/pTkWaH31AWysE4mbYB+gE6xE1SIvwXDNeqy1lMmvOt/cbr74SE9Jn2
         1ByCPx3HZeLwzPNiCb5Ivp0AQXpizUAL6KVRv3q8/nTag75VbMJl/wa1nJfsPOYN5Pd5
         j4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nwcwy9+SEKk0IYBTIx4c6izQ+wfusS08Gk4HpdIOwgs=;
        b=hii7Jq4MIvVtnhM14BR/o00XGskg+yZP0XyulLrfeymWLDkGQXjS0LvNY+qHV60nRN
         ttIZQUwxqhjndOpzQaXzpKZwMNzorasaMgqGO+iA7twWKrKNbjDIyOabXIjs0V4ZF40f
         7qmZzv/PC/NqnIUlSJIkZLtd1kXzVYNED96j0GIrbbsULCSwCDPKAZuVPumR0lcQQeJA
         W3V9BbfBuL7vMhf3GDDu15mR/Fl9edjdN9/Dptio9057XJHZWUZqjVE9c4HbSP0PJ+vy
         Lhh9/JDPDR9GhW+5LKEts9c8Ed3kWih+se+p94oTEvufhx3gYiK/mjv2XtTOpiArPAQl
         6NhA==
X-Gm-Message-State: AOAM5308RKncwgb0gg1RtDNk9L2BZJtjAxKJLEjRLXRS9dea6pNeYbz6
        NYUYq06gL/0iuqONzxi0MO2zGWanrVXBXl0RRIs=
X-Google-Smtp-Source: ABdhPJzOunZ3EgYEBpylmdtP8j9FGpS3Jv2u/4lgTQ5K3DzQcGqKzGmAKemZi6ER65ENMXoFt2frFA==
X-Received: by 2002:a05:6e02:1583:: with SMTP id m3mr13663ilu.265.1632322195871;
        Wed, 22 Sep 2021 07:49:55 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v6sm1092461iox.11.2021.09.22.07.49.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 07:49:55 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: ensure we exit if thread group is exiting
Message-ID: <12d822fd-9e33-d633-5b75-a444596502c1@kernel.dk>
Date:   Wed, 22 Sep 2021 08:49:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dave reports that a coredumping workload gets stuck in 5.15-rc2, and
identified the culprit in the Fixes line below. The problem is that
relying solely on fatal_signal_pending() to gate whether to exit or not
fails miserably if a process gets eg SIGILL sent. Don't exclusively
rely on fatal signals, also check if the thread group is exiting.

Fixes: 15e20db2e0ce ("io-wq: only exit on fatal signals")
Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c2e0e8e80949..c2360cdc403d 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -584,7 +584,8 @@ static int io_wqe_worker(void *data)
 
 			if (!get_signal(&ksig))
 				continue;
-			if (fatal_signal_pending(current))
+			if (fatal_signal_pending(current) ||
+			    signal_group_exit(current->signal))
 				break;
 			continue;
 		}
-- 
Jens Axboe

