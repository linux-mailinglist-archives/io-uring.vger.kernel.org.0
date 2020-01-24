Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A75149029
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgAXVbn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:31:43 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:32841 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgAXVbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:31:43 -0500
Received: by mail-io1-f42.google.com with SMTP id z8so3461704ioh.0
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 13:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d2YSBZR7OuqQr70Xp5p6k1DkAjNpo6cwUNurRiskDIM=;
        b=pNsccN73hAnxf2WKp59W17hwvgxMxorgV93iehO0nAnHBFzganZLQ3kfnEwRqovKma
         S01s/5hSSp9M7Z/AROz0wyj1HmbP9+KFtmNfpTiB/LsNHux2VLD43FaodCrUU3CuAqWT
         f1MC5egSt07j9OMCLTDF/UDCmyz1e2qwVI54C+wgxO7s0P/w6Eu23mrHzTsYuF1a7sbE
         8UEuKhcICyNDJokpot+CUQLCL/ONaZifIwuUaHRZdUZB+OjdSadydibNPvfW4wKsXE1k
         iJg59s36Tc/J0OCX+hLjqdn/oFor/+5uBDJdXzeZh6rkmhRDjcC8T9hj/95Z1bsrMo5i
         lX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d2YSBZR7OuqQr70Xp5p6k1DkAjNpo6cwUNurRiskDIM=;
        b=sdkf1MyONZH0SmMxCz44Rveym1wklggoPeSyB4ANvvky0i5gzGUrNbmCrkAPg5h0E+
         ABVZM7YZiuoXKJwZCnAkmR1vqWlCfUEAuQjtlMiPPHY63MAUs2gBtA/z/76hw6GSJQOj
         jX6H+1ENJwWEfh3k2zH9HqtGnbsSL+fS8RrUaBFoT6S9j1KbtgiCvJDr8bus/yjr6XcB
         V0gnzeE9C4ZykUzJMGj6sxsygQiMZ14Z7dPlBKq7q8h7c+/U0QxZYMs0XGoz1T9KI4OM
         q7gk+pQSmwshWpmZimwbL+RVP2jsrTXxtExLYphLtUgWeI+XP/BpvQ/G4UycEANh4His
         QboA==
X-Gm-Message-State: APjAAAWd+09nwRWgF8Vy6+bt70SvIFU+a2NL+fV7GxLSs/SWz5laldWB
        2PtqiHlvdXE/rg7SvmA1Q4qpJQMfbiY=
X-Google-Smtp-Source: APXvYqw3QLiAjr15IVtvVaJDfPvjve8FcTgmMkEWVTmXfJXIOrjavMVWNQnjyJr/s89OJ+sNN0C3Bg==
X-Received: by 2002:a6b:7846:: with SMTP id h6mr4044199iop.224.1579901502171;
        Fri, 24 Jan 2020 13:31:42 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 190sm1322705iou.60.2020.01.24.13.31.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:31:41 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/4] Add support for shared io-wq backends
Date:   Fri, 24 Jan 2020 14:31:37 -0700
Message-Id: <20200124213141.22108-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Here's v2 of the shared wq backend patchset. A few minor changes in terms
of id validation, and a switch to using idr and also utilizing it for
lookups.

Changes since v1:

- Use idr instead of ida, and use it for lookups too
- Rename IORING_SETUP_SHARED to IORING_SETUP_ATTACH_WQ
- Don't allow id specified without IORING_SETUP_ATTACH_WQ
- Use id=0 if we run out of idr space instead of failing
- id==0 is not allowed for attach

-- 
Jens Axboe


