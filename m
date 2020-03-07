Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E4B17CFCE
	for <lists+io-uring@lfdr.de>; Sat,  7 Mar 2020 20:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgCGTQh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Mar 2020 14:16:37 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:36705 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgCGTQh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Mar 2020 14:16:37 -0500
Received: by mail-pf1-f171.google.com with SMTP id i13so2840166pfe.3
        for <io-uring@vger.kernel.org>; Sat, 07 Mar 2020 11:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=eGcbbDGmdFPg+blpFgNt5fk4FJZSVRnYmpe1I78QzBg=;
        b=OFKiEK9rXwwl0CHY2j3FkIsqxYczJLl5px2s/tJAAAX8dFUu314yr5/3NOOAqz+bD0
         sBgj0hc5+Lq851u8a0oPMrs+VbZNO6/KW4OUwP4TZHlQep5qeOTVoYfdugbDlJoMLCDC
         GsjalZc7eFw9dtwYqs0ykj4QWAXazDJLjFkppHkPLWRRzZ0fMNLyVZI9pI9SA/87siGM
         e9BerHP9tQ6Jy1xNvNbh29FGp4N+mf/JpPRtpKo2iQaVwTKe5A5Pc6p2wPN/wlD+wU40
         7VbC7se+VMkc7ZWLdSbUjwlp0VrIMMioNiQ0ZKaJh9Zo2d4eBbeRI8J5qytsHDwJDe/z
         X0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=eGcbbDGmdFPg+blpFgNt5fk4FJZSVRnYmpe1I78QzBg=;
        b=gryQXBKN3GRGwucpwzQHkEBfD6O4BzLLtPxo25cxXrBcaMN55a8dpJ1BfND6sC3Muw
         wJdGEMmyXmtLy4nbVlucTkPS9vyFG+obVyPO173ravvPCJe6t8itUUuLz8d4r6VOZGQZ
         4WrFMw76A12eCcLxLnYStLKS/ov3vVbsKo56o9zSNH2xuXx3KMhpbviTtOibM+AZnjNu
         wB3NIUSXHnGGh2YbWhGcNVQGngKhsbe+VS0bwO+RsOFu02/dxjCnyS07YmIdvJvA8RLk
         EXI8BSKX5hFfnkuboGf7LsNKaIN8J5x7e/8+a6Gde3qpAVpBROz456GCtd8AE4HPX4Gb
         FdvQ==
X-Gm-Message-State: ANhLgQ0RxqyNoNFaPzqdL2wllHG4j6OcA42+6BiOzHq7cVTxtfh0rBpc
        i9na6XNxFOp9ujJ92hGucx7l1A==
X-Google-Smtp-Source: ADFU+vuhccMaJUQFPMqIN8WhD2HFX3Gl3ECYINAPWasV4myFyKWg48nV0wD9WOuO/TWVjynZIVgnkA==
X-Received: by 2002:a63:8343:: with SMTP id h64mr8751590pge.73.1583608596284;
        Sat, 07 Mar 2020 11:16:36 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id h12sm23741951pfk.124.2020.03.07.11.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Mar 2020 11:16:35 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.6-rc
Message-ID: <b8c32cfe-9bf8-ee8c-a91b-565583a44a8c@kernel.dk>
Date:   Sat, 7 Mar 2020 12:16:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Here are a few io_uring fixes that should go into this release. This
pull request contains:

- Removal of (now) unused io_wq_flush() and associated flag (Pavel)

- Fix cancelation lockup with linked timeouts (Pavel)

- Fix for potential use-after-free when freeing percpu ref for fixed
  file sets

- io-wq cancelation fixups (Pavel)

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.6-2020-03-07


----------------------------------------------------------------
Jens Axboe (1):
      io_uring: free fixed_file_data after RCU grace period

Pavel Begunkov (3):
      io-wq: fix IO_WQ_WORK_NO_CANCEL cancellation
      io-wq: remove io_wq_flush and IO_WQ_WORK_INTERNAL
      io_uring: fix lockup with timeouts

 fs/io-wq.c    | 58 +++++++++++++++-------------------------------------------
 fs/io-wq.h    |  2 --
 fs/io_uring.c | 25 +++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 47 deletions(-)

-- 
Jens Axboe

