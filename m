Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2C725EE7C
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 17:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgIFPSW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Sep 2020 11:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbgIFPSH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Sep 2020 11:18:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509BEC061574
        for <io-uring@vger.kernel.org>; Sun,  6 Sep 2020 08:18:06 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kk9so2882088pjb.2
        for <io-uring@vger.kernel.org>; Sun, 06 Sep 2020 08:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hDobB/Q998Cw1MxuhqmCwFkS+hu5pJEO8IyhAgTvAlI=;
        b=MNPhg1hCRwPztEXPVJ32uYRRGztBrrTCDbATaRVhxydtdwqZy4uzaDTE38UHruh0dG
         qyLyBtj/9Na4S7cEgXOD3bRsRp/6EBuKxCbnnkAguA+aFhmLH4v7beKgReHfaPdG6ov2
         WZJ5+pyeqoN8jyNIqdQlBQJ8HYDfez71tL7G7V77JbV/eY0AxNTq5TINDbe8lDZmeq9g
         lGEhT9hugBLkqtnmqC6daUpQJx4VFWl0kHGj6G4cppfiRAoMp6Ss/RAe93+mcIGSivgP
         jK3spPraZ5GGWCHRQNmb4nGU+Ih8HNpnCOJMlYJ46L1pR7GEuB5tpNjmsNkrDhLhmSa2
         RpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hDobB/Q998Cw1MxuhqmCwFkS+hu5pJEO8IyhAgTvAlI=;
        b=TiTd4w2od77vVfZhaFHnZv7NG5LAGDRC6cp7VonlM/kwiRBOm+Td13weRxq0XWDkEz
         hE0ZpGq6wfHP1pXXbZ5nafH+OeIWcz0ozVwzbDNJxekkHVJDq1HTuXmv4e82grcYJsO2
         DRbA6LDanrE+TQu/Bl1f8ic9lzfZxrbNCH8yDXajs7nDMcupTowDBgH7EsYcNsBhCJ9L
         SBmltbEQZR7DYQ8SonIDTC6qvCVvjdLs4yJ+tFDWH3byNHK3ZnuMkig+Q3nCMeoC+q2V
         9cLuKR7lyiFaX7Ah9b3uZuWzG6RmTkq82QaCJL4wLb7Fl7y4NvpnqBetVpfVxTKOyDQj
         Wj7Q==
X-Gm-Message-State: AOAM530Z4aQynQhQsFHFqo/UgCPipcpY6MfiWi7uKNDwWbWHD9eG9myg
        hkRQpSAXReHDHQDHra4HLOh38g==
X-Google-Smtp-Source: ABdhPJyQWPg6MrNBPk6LMvvoHz42slrbr34uOXga7IRxI8pKij7PWHF71JjVDX3WZYeOs58bJ7JBRA==
X-Received: by 2002:a17:902:a5c3:: with SMTP id t3mr14183466plq.134.1599405480543;
        Sun, 06 Sep 2020 08:18:00 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d77sm12408690pfd.121.2020.09.06.08.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2020 08:17:59 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Followup io_uring fixes for 5.9-rc4
Message-ID: <7b093a7c-4230-c7b7-8f39-15bb4f18d5a7@kernel.dk>
Date:   Sun, 6 Sep 2020 09:17:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Two followup fixes from the pull request on Friday that were done and
tested since. I deliberated on just waiting with these until the pull
request next week, but I think we should just get them in now. One is
fixing a regression from this merge window, the other are a followup
cancelation fix. Both have gone through full testing, and both spawned a
few new regression test additions to liburing.

- Don't play games with const, properly store the output iovec and
  assign it as needed.

- Deferred request cancelation fix (Pavel)

Please pull!


The following changes since commit 355afaeb578abac907217c256a844cfafb0337b2:

  io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file (2020-09-02 10:20:41 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-06

for you to fetch changes up to c127a2a1b7baa5eb40a7e2de4b7f0c51ccbbb2ef:

  io_uring: fix linked deferred ->files cancellation (2020-09-05 16:02:42 -0600)

----------------------------------------------------------------
io_uring-5.9-2020-09-06

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: fix explicit async read/write mapping for large segments

Pavel Begunkov (2):
      io_uring: fix cancel of deferred reqs with ->files
      io_uring: fix linked deferred ->files cancellation

 fs/io_uring.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 3 deletions(-)

-- 
Jens Axboe

