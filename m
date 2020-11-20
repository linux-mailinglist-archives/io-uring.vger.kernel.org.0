Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81732BB43F
	for <lists+io-uring@lfdr.de>; Fri, 20 Nov 2020 19:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbgKTSpf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Nov 2020 13:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbgKTSpf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Nov 2020 13:45:35 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8B3C0613CF
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 10:45:33 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id i18so10977228ioa.3
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 10:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9p6HVvTWyMaxmoezpfttIAofpYXRqeK+9qf/+06wmto=;
        b=ZQqGLnEa7hjw4nR1wm65a+144RSbuyKUPwO7mJsCNe9BQTrxiufHI4og/JdpSYdjI1
         kX/CXhyURpVjT97d7WGHCAudhRvMVg74NGKNEaa/sOF7LAc24Y6Qt37BajlDsSMYymHS
         ZLgHch0yGTU5q5J4bzAdVNxY7a2RiSVfEd1ZT++u56/tQqtsdTx59pXGV4ifIKj1uPXV
         HCn35VsnBPt9DZS6zR23snI0pRiBlP5ANRSfaFdjHedkny0W7qxdbQ3i+2/KAEdFZEa9
         5krjD7SY3fhX/67rgtrlmJQ9tzB589gaAc1cO2i81xv/ao9wfMlOnf+qKid5F9fGjVqu
         ZfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9p6HVvTWyMaxmoezpfttIAofpYXRqeK+9qf/+06wmto=;
        b=jFXcK/9vKjFCYHeexDbTk68gSQGgewW0reSBU9NN+mKwZb6US2c7jNtwba8jP7eWvM
         70Ri49V5JJ2oOlsw7KRpIWihbFvOpR253uGxD7v+3FWolCMCFRy8MxnCU3FpZrYn0h6x
         fCeKmpr6gFE+3FOlmM9y+pfSt8AtP4zNMznnxB8DiP7lAcoBqJntIxhJQW+aL/cJVGiR
         bUYAmHHrFghVOqOc5Fou2pS5HGWZma7y0EdQNIEmZTF9gBInYlnK4/QqJREKCB4LdC6G
         4+MJ9gEAtwJ0w0ILIzY+tHV/rp7VplTPLXGtw5a7I+5yZm5BZbRY46dOkkpPS4o7S1aF
         TBMA==
X-Gm-Message-State: AOAM533BLCbW18FZ2ow8jO+O9x4TR+Q1fMSNC54zZW3F3JuNaHd1MvqC
        iWE0oYiDY9j5fygROxE2Qtjh8w==
X-Google-Smtp-Source: ABdhPJw1cl1IXDp1ajW4jbHHFNzDI3Cw5IX6pUJg6cJNPmgcEAaY516seWCBiyzjiInau09n42lxQA==
X-Received: by 2002:a6b:7947:: with SMTP id j7mr26726951iop.143.1605897933008;
        Fri, 20 Nov 2020 10:45:33 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p24sm2524598ill.59.2020.11.20.10.45.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 10:45:32 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.10-rc
Message-ID: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
Date:   Fri, 20 Nov 2020 11:45:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Mostly regression or stable fodder:

- Disallow async path resolution of /proc/self

- Tighten constraints for segmented async buffered reads

- Fix double completion for a retry error case

- Fix for fixed file life times (Pavel)

Please pull!


The following changes since commit 88ec3211e46344a7d10cf6cb5045f839f7785f8e:

  io_uring: round-up cq size before comparing with rounded sq size (2020-11-11 10:42:41 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-20

for you to fetch changes up to e297822b20e7fe683e107aea46e6402adcf99c70:

  io_uring: order refnode recycling (2020-11-18 08:02:10 -0700)

----------------------------------------------------------------
io_uring-5.10-2020-11-20

----------------------------------------------------------------
Jens Axboe (4):
      proc: don't allow async path resolution of /proc/self components
      io_uring: handle -EOPNOTSUPP on path resolution
      mm: never attempt async page lock if we've transferred data already
      io_uring: don't double complete failed reissue request

Pavel Begunkov (2):
      io_uring: get an active ref_node from files_data
      io_uring: order refnode recycling

 fs/io_uring.c  | 57 ++++++++++++++++++++++++++++++++++++++++++---------------
 fs/proc/self.c |  7 +++++++
 mm/filemap.c   | 18 ++++++++++++++----
 3 files changed, 63 insertions(+), 19 deletions(-)

-- 
Jens Axboe

