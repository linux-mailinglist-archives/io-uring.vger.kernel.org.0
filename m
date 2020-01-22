Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03370145A0E
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 17:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgAVQms (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 11:42:48 -0500
Received: from mail-io1-f53.google.com ([209.85.166.53]:42318 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVQms (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 11:42:48 -0500
Received: by mail-io1-f53.google.com with SMTP id n11so7256588iom.9
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 08:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+38KoZ4LOlfHsCMrv5MDbJAohwM+DFmbcG7PpNyUiPk=;
        b=R8iLp6XWjWffu+yxUkg43lmBI7nFlQVVZ84FKk7WGgdd65Aj8rTYc7oQkzNmb0jK2d
         EciMSO94BVRpTKXl7Z9KrJRMQPCCZztevhDLwNjOItO767C4RepMX70o+2VZnLHY6pmY
         LKA/L9Fs8pBpgHmzyC/UDefJoC7k6K4zslx+x11Khr6mIAPgetUwExRqDiXYDn8GesZh
         gnUIfvK5QtA+gOUTVQrVJagj1sx6BlXmip6LUC78eau7oEVp5I4qr3yG38bq4upapoAP
         tPfASacc0cJcpR2GZulEI59KvyPXdHSTzx5F33nhQcHF4brygk9FQbIqfC8pKY9cPytQ
         PLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+38KoZ4LOlfHsCMrv5MDbJAohwM+DFmbcG7PpNyUiPk=;
        b=n92z7y7P5cxEWgWMha5MK/oBpHo3O56Dax/fA/ffRYMNGPBbShJQiyapg/iv66sOhf
         qcJl8tlnbPh4iWUd8BMv75h+UbajlU5Kc/IuSvloYYXMzR6u4KyC6x+2iskGMHhVQJa9
         Jqd19k6nR5Hed5fRGcGcwy0JZHByKvQrmHgOH2+A1qhsjwVbNPWAlLLvRTmXwWCdaLCH
         hqWGVoqzObNlmpWJ68VIEt8Fx7N8vz8dzXo+VbAT3Ra7ub13/hfczfIePF0Z/KEp3ngC
         hMbaByEblU8fQM8r4ARp9X6o8KNXWI5iG71hqNwfGe0dEgGq48T8Tato2NYJIVFicqUH
         mGlg==
X-Gm-Message-State: APjAAAU57yOYSshrIiHJ//SQvwEVFIXBwIM++s5tOuerlOSCLmBJLItS
        ZwPLFDJ7n+nOUHOG1mPFXE3Cik+tpbk=
X-Google-Smtp-Source: APXvYqzvQN59P1PlJXDv6H8PrNxhyXOmikny502SB9obSt5aXGSjHYqxdJ9D5MazHmRtNyHEKkrYWg==
X-Received: by 2002:a6b:e803:: with SMTP id f3mr7924877ioh.49.1579711366986;
        Wed, 22 Jan 2020 08:42:46 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o6sm14599681ilc.76.2020.01.22.08.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 08:42:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, jannh@google.com
Subject: [PATCHSET v2 0/3] Add io_uring support for epoll_ctl
Date:   Wed, 22 Jan 2020 09:42:41 -0700
Message-Id: <20200122164244.27799-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for epoll manipulation through io_uring, in particular
epoll_ctl(2). Patch 1 is just a prep patch, patch 2 adds non-block
support for epoll, and patch 3 wires it up for io_uring.

Patch 2 isn't the prettiest thing in the world, but we need to do
nonblock grabbing of the mutexes and be able to back out safely.

Please review, thanks.

Since v1:

- Use right version...
- Fix locking in eventpoll
- Don't EINVAL on sqe->off in epoll prep for io_uring

-- 
Jens Axboe


