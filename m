Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92DC301E43
	for <lists+io-uring@lfdr.de>; Sun, 24 Jan 2021 19:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbhAXSx1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Jan 2021 13:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbhAXSxZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Jan 2021 13:53:25 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D9AC061573
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 10:52:45 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 31so6216712plb.10
        for <io-uring@vger.kernel.org>; Sun, 24 Jan 2021 10:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9suUcpFog6aYH11o3wrklhSMh/3uKDLGlHwYbbNhuDM=;
        b=yVPduJJykgaOFlZqdRnzv3iAopADaoxi7+1FvM5F+ezh8hJS0mTmZf5gow1gTnBRe1
         vjMY8jA2Ty8xwxSJGl2LkVBWykFsRKi7+qkDAgw/2DJGIjdXu6DLmLm+mDIRD3YU9Jfp
         PPHhaOmdq2kvqa7HzkpXvWHSfkHask5OZrd9IJm34+FcwRO3a47AzzUlVdw+Oi+b8l4e
         raeDglVkdSkSGjLY9XsowU/dSvRUiFyxIJ5PcifEGJilOKZyLq9YNHxT2MGk+Uy3s1KQ
         ECbvFwkDP5lQyQxJY94wbnatfhNAQqUgO60A0EO6E0NM6p2g+T+cNJSSn5cy3V92szx+
         982Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9suUcpFog6aYH11o3wrklhSMh/3uKDLGlHwYbbNhuDM=;
        b=ro2hnzsD3RTopTDvgZSJiAY++SH3FhkeoICZhO/+8yXcxcJahEqaBuk0IgwHSm2kcj
         mFHE+3bK74fyZjhNi9KCbKItydk4KbuXQeja8QjNUQvpU9LXclG0x95iTD7l7X8vloUJ
         7PgwqzNlIHM3WMkKVuPcd3zyQpl+mnYtlcaH5jKrVpQpR5Rm+IhE2j42licmkp4FvrVL
         cBZ3CwGX3GB//9dfEJ0R+jMefRrbF8HM9XSlQDwsZIsbintcjsphvaK/+vDXB8C5SM3o
         mnlBqjKE7JIL6gCrF4C3w5Px7oDzh+fUQmsONrbVUAasamuhMNbDBx3Aze1TExa5oFJC
         hJug==
X-Gm-Message-State: AOAM532OXOKqqL30sIaE2iCPaI3/mXVnYaSLxowqFegA/CQnUl5RHTi4
        nFCZt/pE8nl9iPZz2KB9gM02NkSKO3Qm9Q==
X-Google-Smtp-Source: ABdhPJz4SOJH2rvVIseZteLKhMo0eLSIf6BGI4GCD44ayHz8criNRkHhln9pl0LwhqYuVLTYmn7wAQ==
X-Received: by 2002:a17:90a:b703:: with SMTP id l3mr17156221pjr.60.1611514364869;
        Sun, 24 Jan 2021 10:52:44 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id y4sm7719685pji.34.2021.01.24.10.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 10:52:44 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.11-rc5
Message-ID: <b0a878ef-29bf-100d-018b-7462535a5745@kernel.dk>
Date:   Sun, 24 Jan 2021 11:52:43 -0700
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

Still need a final cancelation fix that isn't quite done done, expected
in the next day or two. That said, this pull request contains:

- Wakeup fix for IOPOLL requests

- SQPOLL split close op handling fix

- Ensure that any use of io_uring fd itself is marked as inflight

- Short non-regular file read fix (Pavel)

- Fix up bad false positive warning (Pavel)

- SQPOLL fixes (Pavel)

- In-flight removal fix (Pavel)

Please pull!


The following changes since commit a8d13dbccb137c46fead2ec1a4f1fbc8cfc9ea91:

  io_uring: ensure finish_wait() is always called in __io_uring_task_cancel() (2021-01-15 16:04:23 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-24

for you to fetch changes up to 02a13674fa0e8dd326de8b9f4514b41b03d99003:

  io_uring: account io_uring internal files as REQ_F_INFLIGHT (2021-01-24 10:15:33 -0700)

----------------------------------------------------------------
io_uring-5.11-2021-01-24

----------------------------------------------------------------
Jens Axboe (3):
      io_uring: iopoll requests should also wake task ->in_idle state
      io_uring: fix SQPOLL IORING_OP_CLOSE cancelation state
      io_uring: account io_uring internal files as REQ_F_INFLIGHT

Pavel Begunkov (5):
      io_uring: fix false positive sqo warning on flush
      io_uring: fix uring_flush in exit_files() warning
      io_uring: fix skipping disabling sqo on exec
      io_uring: fix short read retries for non-reg files
      io_uring: fix sleeping under spin in __io_clean_op

 fs/io_uring.c | 67 +++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 20 deletions(-)

-- 
Jens Axboe

