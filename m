Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B29F145908
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 16:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgAVPve (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 10:51:34 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46951 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVPve (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 10:51:34 -0500
Received: by mail-io1-f65.google.com with SMTP id t26so7051639ioi.13
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 07:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=TQtYIVnmBZTGSPMBAl2QZf/eZ6kMW1F4eBDZ4mB7h6c=;
        b=smcmK0GKN1dQqQgLnBLLzgFICWzT8tPktwwZZh7+jPrIdNJqJF7j4lW7zwkNQsOuhO
         clz/t+48YeHACEJutxBF2IZaExTXRfxxWfAEmw957NVm2sIM1RX+g104hmFKEldVMKJn
         i6y05FaAl2RxRpm7nZCEFJNlGONY0/oOpqDmKogbe58MH4BovaKhNAbjzI0hU3UnKWSL
         tz1dAIc97KYbJZeD9kq9lNdqCVihEk5JZ8Fm+sdhrvRegIoYQ80uGXeEhhy1jlbtNAR4
         mwjNDBMCvsy+cby0PQzMcvqSt+f7L/gKHo9HJVm1cpm061eDKC33R6qH31xEk7/wLA+H
         3ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=TQtYIVnmBZTGSPMBAl2QZf/eZ6kMW1F4eBDZ4mB7h6c=;
        b=KSouC9slhgBjpeIuI/l8Ruayq2YkXw/O/vsrpVLWmAAWF4oxa25HjCGanStOL2h8ke
         iTohIcnmbnHa0hQ2DKXgGbyfYi+EtWluxMTITAvJneW3NR5SYnk/NCyOPXN3USknr6V6
         LdHGLua0ES3I++AemZs+GeviZbFlcmNMubovdUKr00vds8c48L8JlpW7W9KTj3srlybA
         CwbsD+6Agpevxn4xtkFRvf+7/6lkEeGW/nOMmkFavHz4aPnZw7BJ5MC81QVLZ1EGSZOE
         D6swhha7Rg+9i6R3RxIbjRlvQzzclf63zSjNrvaA6+3ZMEZURGfy/BCp1bfDAgERGNvp
         aKQg==
X-Gm-Message-State: APjAAAWCyMbDPcoJzCfqdS6mcRlONrF4OQRShDYqBm5aVsV+vbzpLckt
        V1JfLBgvi1Be/eZX3iE8a3USsrI7F8w=
X-Google-Smtp-Source: APXvYqxQaa00nlD2XddYDdcwY5NC5M4NAEwZjrt0P4xYff3bTELwrx4bQfpIpvbO/lqR4KvFLRrJ3Q==
X-Received: by 2002:a6b:e30e:: with SMTP id u14mr7581903ioc.242.1579708293721;
        Wed, 22 Jan 2020 07:51:33 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y26sm812138iob.88.2020.01.22.07.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 07:51:33 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.5-final
Message-ID: <98957d45-ad2a-9505-9771-63828538f3bf@kernel.dk>
Date:   Wed, 22 Jan 2020 08:51:31 -0700
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

This was supposed to have gone in last week, but due to a brain fart on
my part, I forgot that we made this struct addition in the 5.5 cycle. So
here it is for 5.5, to prevent having a 32 vs 64-bit compatability issue
with the files_update command. Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.5-2020-01-22


----------------------------------------------------------------
Eugene Syromiatnikov (1):
      io_uring: fix compat for IORING_REGISTER_FILES_UPDATE

 fs/io_uring.c                 | 4 +++-
 include/uapi/linux/io_uring.h | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
Jens Axboe

