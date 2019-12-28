Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264C012BEA4
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 20:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfL1TTA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 14:19:00 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:41946 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfL1TTA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 14:19:00 -0500
Received: by mail-pl1-f174.google.com with SMTP id bd4so13063739plb.8
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 11:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aZVFYZ2ix4xnCwKfLCgEwjltzlR/+ZI/wJ+bvaP4ffY=;
        b=poEI/7XfbVsUcBKJd4ImALH4Lfg5eudYlIylqdTDj1nkiJ6uWol6noPYBiBe5UbwdS
         Qq9/hb9d+Vrw/DP7oe6JG6Jsr3foXIHTYd0OHxcSdS+0Y47c5fFomXkMKo6jgvsck/xs
         +S0ngQX5gWan1ARvtrAka97AOGNxfmYI0Z7clXA/QXRL9tmapTjAhHA7+9iOzjYFX0iI
         0Ykeg5jwGp7yESSL7zuQgJm1+BaeXVa0KG+FbUxa0002XrKFd8R5DTjPtJ5kqag2/8EJ
         b3XTTsUSQQZOiMelvAWSVZM9PLqS1bMdb4/Py7zsSsNNcE4i2t1O/5xy1N0U7jcc4wyi
         Ap8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aZVFYZ2ix4xnCwKfLCgEwjltzlR/+ZI/wJ+bvaP4ffY=;
        b=NulSS+5UTT03uVJBP2KvIw4erfwCyts0EBa0Gm5tbZxusCRgX9LT+gPxhJDoVSpOz9
         Xls3n1ZcK/gkfhe8Y/Z4p/lKiCuiAQ0xAYSLG+DJJ/x8bwZD++eKMf0pLrnXcel8nfhW
         +fom5oQRDsmJ60I9ESrElGX3sixWObEiQHO2a55VPOVsfRUPGnQ34gFQlJpLwTUGdT10
         kbSzJV4N6RXyR/7eHkq2QnQCFu58nrW/URp4Yv3mbvRqzm9H89aS3eV9FRrb2meMLJQE
         fOEe5WKvfFwIybYnyuLNHbHw0/MHJ80hJQ2aDLs4NyarVDDpO0XKpUjPqOeGLEic7FMN
         5uwQ==
X-Gm-Message-State: APjAAAVMcQtT8I038YbjFLAzC/+8RdIN1OfFlGe3SFEsQSZtoy2BmmBq
        CtYy1wewk2xq0ZVr367Wl0p8XP+iKaWodA==
X-Google-Smtp-Source: APXvYqxJTWfTunoiybyDZ0LWUaSCKP3xqNv4GngxedErCfX0WwZETl75MnC/3mS8hLmkWeGpH6KMWg==
X-Received: by 2002:a17:90a:31cc:: with SMTP id j12mr33938768pjf.103.1577560739096;
        Sat, 28 Dec 2019 11:18:59 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x18sm44988789pfr.26.2019.12.28.11.18.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 11:18:58 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Extend io_uring batch freeing
Date:   Sat, 28 Dec 2019 12:18:55 -0700
Message-Id: <20191228191857.3868-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This extends the free batching, allowing it to cover more cases. It
was pretty limited before, since it required fixed files.

We could go further with this and batch the file puts as well, assuming
we often have batches that are the same file. Probably not the case
from the poll side, so I left it as-is.

-- 
Jens Axboe


