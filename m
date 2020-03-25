Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027971922C4
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2020 09:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgCYId2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Mar 2020 04:33:28 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:22535 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727291AbgCYId2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Mar 2020 04:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585125207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tPDFlQdj8VYweTPWnggqIKOTLY3z3piVcfXmWCzVRUM=;
        b=QfA0vz8/nIM0g0D7Z9PSrgeBfumCunZln0H126xwGUIk9F+8+oO+Dbzmf+SS02LVc34mNY
        8o+zg2Ho8xcN4HR7dw1ZYX7kOXHDKmuyXA0nujNZmmeRlcgTq4uzDR+mBsUjhUIJvxqFi1
        y1oAqChsNEFdnZTAZFaEe3dU8hdZ0d0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-uc3vxZK8NUiqr7943i_ZSQ-1; Wed, 25 Mar 2020 04:33:25 -0400
X-MC-Unique: uc3vxZK8NUiqr7943i_ZSQ-1
Received: by mail-wm1-f72.google.com with SMTP id x26so111751wmc.6
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2020 01:33:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tPDFlQdj8VYweTPWnggqIKOTLY3z3piVcfXmWCzVRUM=;
        b=JUyv25TlCVh2Y8uCEWGn2A5u6DfXSs0ODyAbWM9fFR3YOnBNUgK1Ww8MJF5jqd5PbR
         uANLFilOHxIlzEg1T+BQIlgjdWVf9lq/Eyi7+JgHp1JLWCy5c+wLBLptpiEY0kz4zFom
         o2z/knLzQrJV2e4Ei3tRJ2xE+HhLwQeZLcg6t7pPyPPrM3zOgRzELmG6Wj2bnTza0GPg
         SQ3V9o9VZl+zId/MDQdBe7bDDk5dVgVHgSbi83BI6BO2vWnjnDzOAZMS1wCs+mjH02rn
         ZD0VPaNYDEWN37B1ySLu0QS++RqJRYV6C1WyGEzC/wjGcADfWzcTZT0GyIDYpFkdIMlA
         Y5UA==
X-Gm-Message-State: ANhLgQ1USNBVE0mKrvoyWuLINiuyPp46qey8dleNw0MarS7yorSazc07
        b32FX9EI9aw9v1+JXiA65MJUKY2XVnSk0IYBQYnUahDUxn43/zLWlC4w5L4IKKnVDNQ7GrQfFCR
        3FzM65SASjCcZxwwUKNE=
X-Received: by 2002:a5d:6a82:: with SMTP id s2mr2183323wru.205.1585125203931;
        Wed, 25 Mar 2020 01:33:23 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vshmYG1TzvBv5lQipVG7VPJtGxrkEtQs4rrYwizw97mhVW/ki+3UHkEOX30POh7LlxcPhqmBg==
X-Received: by 2002:a5d:6a82:: with SMTP id s2mr2183298wru.205.1585125203732;
        Wed, 25 Mar 2020 01:33:23 -0700 (PDT)
Received: from steredhat.redhat.com (host32-201-dynamic.27-79-r.retail.telecomitalia.it. [79.27.201.32])
        by smtp.gmail.com with ESMTPSA id f12sm8236732wmh.4.2020.03.25.01.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 01:33:23 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH liburing] Add test/splice to .gitignore
Date:   Wed, 25 Mar 2020 09:33:21 +0100
Message-Id: <20200325083321.16826-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 9f85a5f..db163b4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -74,6 +74,7 @@
 /test/shared-wq
 /test/short-read
 /test/socket-rw
+/test/splice
 /test/sq-full
 /test/sq-poll-kthread
 /test/sq-space_left
-- 
2.25.1

