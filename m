Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1AA166858
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgBTUb5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:31:57 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:38685 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgBTUb5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:31:57 -0500
Received: by mail-pj1-f48.google.com with SMTP id j17so1361859pjz.3
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TiFv7ZuBo2fPpgOoJMw38WTqwWbgEBUi/rVLzXG1cKw=;
        b=C9fwQbCliBBTLnm7ObaXJ1itkcSGxtDHEdCmArMubeGqCPF+0bucJ43UmP3eDZvm52
         MipLxRROZUAX0UaBZ7pho5W3QIDjhLV4AMm4M8O8y20h23Zaa7chWAKRzTqnMkqrWLIQ
         Xn5o+11pQ5e2Zul1F4ZM0fI4A8R+ObBBbsoAtJim0b3WLJIQ5YJucf61favdu08JFypk
         lz8T4e4EcB5dsTQUmriG/DR9PXx1+8/yCmFVB0Ksnj1+KYOYTz+MKiNt39HCBB0zTQxw
         gRE8OzGQvIkBpwWttK8RbCvaEX12k18QWaBSR7MctkkbSXDPWy1UT4PSE35MogAOVAey
         A6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TiFv7ZuBo2fPpgOoJMw38WTqwWbgEBUi/rVLzXG1cKw=;
        b=RwZwtc5K8RS6jy177+MN36CV7O1INlFf6lL11EwmnTusq2V3zrvNBJMvOf8OEX0qUl
         1PRNqqStO1EoTCQSIDbhORfhMrU+ibYKjrL6Qs6qnogX2V0eLBLOd9UCgBowO/MHSul+
         5gcj8UdgxGcvrd/KJIzg7ouKw7ab3vRyg/wODRWcYh9XGmfIgEhNmOloVEzOsealFm/g
         x0vHEn8NHeh212qMNxyX3LY9IUBybHHny6LbmKyBAU/Gbi7u6MHRyNntdCx2fRHc/vyp
         xtSJY5YXu0YACqCgZv5PswDTVNrnVXWpFoQTYitjHN5YWgvboVqw2j/oAqCDGRt87N/j
         YsZQ==
X-Gm-Message-State: APjAAAXVIdbm5CRr8P+U/QBWug6wU18OMRfYloAtKqU+CFkT6yltHoO2
        OQfeYfdQhK0iR/k6AziF+xOLIdCRacg=
X-Google-Smtp-Source: APXvYqy3GFjMvwmmVvQ1Fj4K3rF2V+loFbMnuJm6CKCBjSWgWn4z8Hqp1w/kps/mejFIHNa7xu+ddA==
X-Received: by 2002:a17:90a:8915:: with SMTP id u21mr5700397pjn.87.1582230714983;
        Thu, 20 Feb 2020 12:31:54 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id z10sm169672pgj.73.2020.02.20.12.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:31:54 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com
Subject: [PATCHSET 0/9] io_uring: use polled async retry
Date:   Thu, 20 Feb 2020 13:31:42 -0700
Message-Id: <20200220203151.18709-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently need to go async (meaning punt to a worker thread helper)
when we complete a poll request, if we have a linked request after it.
This isn't as fast as it could be. Similarly, if we try to read from
a socket (or similar) and we get -EAGAIN, we punt to an async worker
thread.

This clearly isn't optimal, both in terms of latency and system
resources.

This patchset attempts to rectify that by revamping the poll setup
infrastructure, and using that same infrastructure to handle async IO
on file types that support polling for availability of data and/or
space. The end result is a lot faster than it was before. On an echo
server example, I gain about a 4x performance improvement in throughput
for a single client case.

Just as important, this also means that an application can simply issue
an IORING_OP_RECV or IORING_OP_RECVMSG and have it complete when data
is available. It's no longer needed (or useful) to use a poll link
prior to the receive. Once data becomes available, it is read
immediately. Honestly, this almost feels like magic! This can completely
replace setups that currently use epoll to poll for data availability,
and then need to issue a receive after that. Just one system call for
the whole operation. This isn't specific to receive, that is just an
example. The send side works the same.

This is accomplished by adding a per-task sched_work handler. The work
queued there is automatically run when a task is scheduled in or out.
When a poll request completes (either an explicit one, or one just armed
on behalf of a request that would otherwise block), the bottom half side
of the work is queued as sched_work and the task is woken.

This patchset passes my test suite, but I'd be hugely surprised if there
isn't a few corner cases that still need fixing.

-- 
Jens Axboe



