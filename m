Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B86518C53C
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2020 03:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCTCWZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Mar 2020 22:22:25 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:32840 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgCTCWZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Mar 2020 22:22:25 -0400
Received: by mail-pg1-f178.google.com with SMTP id d17so1731826pgo.0
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2020 19:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCNkHoQNwa71qulU8NIJc7TngKnFoxCGtoO6mKnH3LE=;
        b=q2FrPp+bSs6EwM+SWhOfTDMi8/cRSbXLSdIkkVNkKsD7QW++0nNzsVbUFiEKjbgVJ+
         1vmO15I35ZSrtec0zswcq06Wh/dzj7TNPrz3u0dAkC8dsUx3kYQJHbDnt4Xal0s+bv2x
         ui88+kpfkmQoLEC0il3JgupBG4v0U6+I3wAFE+psOvBGX6GC2JS6GZg6M6zymNqgElsc
         M/0voQt1Q4vFeQhQqbvs6A3bsm1mR92u3leg//Bf7UhyVq32VjdgLh5eydmlvElklTmj
         sI82TdG3LmX3LoFgll3Yme2JDM1sYBqoAEiS9IGDLHVYiyaM1t1vlv7FQ19R3FLHWxLN
         Y8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCNkHoQNwa71qulU8NIJc7TngKnFoxCGtoO6mKnH3LE=;
        b=k/WLEl7faPwC3rh2rfKf9GqN3gZSy+SD1ccNXjBT6KexeWjcCp+kmxOKLP7YZnfzUE
         yRqRTHnYr9kP3iSQcBN/W+Ulfd0WsofIy0t+bQXSrff7sOA2S9GwwbGe/Zci3wdZPBmY
         xDUh7qy2IhjSAnn7XoySxrlX7tdtREnk+eCw6OhNROg+E1h1FzT5s0dJS34egffPJY1x
         llyq7P9a/o9g5IEAQoSIxyhaKSht5fU0Vz3fOnKQLxZgSMEJMzFDaIFznLbOFv4RZY3G
         5/lucy9fPQ9R30vHJjeLJjAllJBqf31c1TmSZvrmpX4YJgPTNP33Fu+X680h7kKZcwpS
         uKBQ==
X-Gm-Message-State: ANhLgQ0fpToiKke9SQhM2ULemK7zi8CeGEq8N+22IPycjlyZAyehTbph
        3S7vu8xcdko/n5EkVhJEkt8ZPzlYxySr6g==
X-Google-Smtp-Source: ADFU+vvDuc7MmazMvf4okj3GW4SYtH4UbV8g2zX3svcSLRTwLfXAGx6L+ggohvSx4m9jIJKXVlBpvA==
X-Received: by 2002:a65:44c1:: with SMTP id g1mr6453673pgs.362.1584670942961;
        Thu, 19 Mar 2020 19:22:22 -0700 (PDT)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id mq18sm3423993pjb.6.2020.03.19.19.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 19:22:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCHSET] Fix io_uring async rlimit(RLIMIT_NOFILE)
Date:   Thu, 19 Mar 2020 20:22:14 -0600
Message-Id: <20200320022216.20993-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we handle openat/openat2/accept in an async manner, then we need
to ensure that the max open file limit is honored. All of these end
up boiling down to the check in get_unused_fd_flags(), which does
rlimit(RLIMIT_NOFILE), which uses the current->signal->rlim[] limits.

Instead of fiddling with the task ->signal pointer, just allow us to
pass in the correct value as set from the original task at request
prep time.

-- 
Jens Axboe


