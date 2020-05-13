Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC7B1D1DC0
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 20:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbgEMSpT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 14:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732817AbgEMSpS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 14:45:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84153C061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 11:45:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t9so11507925pjw.0
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 11:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=kedT0HY+ViVEEtnUYs06kmw4y2XfyiFzsbircCs+tYk=;
        b=cYAlDsaVpBMPafQAzVvU4B/DNbXyGA+3quWjCQIXVxgkOq7l6uqWdi8ZUfid4kvAKc
         tnirNQGSwOhgmgDr+svRBYiKmGFSovOGwMDDcZEih9LfSYKEPTZ96/JF6OcfrmWq0NDC
         TIIkJdlfbdJkZw0IqO+nTzjjO9gE+xCoHaUAgTpEWnWttP/hzr/dONvEP846+Jv0NvLo
         VkBa44GBqoPSmsHZ7nLZ1dYXpIyV15iY+LqvuGUwTdIfTxTbuAFWxpxKQdnTGQh1OPPp
         /iyF0lOMYaNVwEd8txIwHwvz3jXmGux7v5mhwp7gpD/wMuWLljN9yrMpbv6bTtMm7+Xu
         p7bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=kedT0HY+ViVEEtnUYs06kmw4y2XfyiFzsbircCs+tYk=;
        b=XX69DlI3B1sJ2ZdSKPaJKgDWxfzYchJShClj8OYQ6oZALwZcV5QSY7BA3JWqsklmm9
         aE+nmnEXFsVYrK0ZO1rtSR8FPYzpnJffnC/KR8wCygKsJZV9z49YOSuMIU3Xhj5UTvtJ
         ismCm3s4PTiHhZspYfqO6iKhM63K8bMnF4W6pSmNv7ViIFK1Zd7SARbyW3bJodajUgz1
         wbRcOo/nG86U/uPnvmiOJUuPZAhGNNJoCe4iqj8z6xweEqVEUmykJ7Q1dKMiUPXDOoWV
         n22PST18mhmGVUrhk4Kq1NxkU9TwF8meXgYRuy1NDXw9BwuDEII5tSsIlnDC/ITsURq1
         K20Q==
X-Gm-Message-State: AOAM531scQLD9XDBIDiYqkHMXNrNfv7b6d7/pDh0J6Xus3YYrqHXP6jN
        aTlqOQwWzjvjuSgNkw8zA1AmfvrFoTo=
X-Google-Smtp-Source: ABdhPJycWFRNDEh+swilCCDkdzzb5JFKOiLEmrG4KNxZxiWVaWmVYTNGuHB8IsWgD9f0mP8tF3SwFw==
X-Received: by 2002:a17:902:d913:: with SMTP id c19mr451786plz.229.1589395516172;
        Wed, 13 May 2020 11:45:16 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:e16c:b526:b72a:3095? ([2605:e000:100e:8c61:e16c:b526:b72a:3095])
        by smtp.gmail.com with ESMTPSA id i9sm220876pfk.199.2020.05.13.11.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 11:45:15 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: regression: fixed file hang
Message-ID: <67435827-eb94-380c-cdca-aee69d773d4d@kernel.dk>
Date:   Wed, 13 May 2020 12:45:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Xiaoguang,

Was doing some other testing today, and noticed a hang with fixed files.
I did a bit of poor mans bisecting, and came up with this one:

commit 0558955373023b08f638c9ede36741b0e4200f58
Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date:   Tue Mar 31 14:05:18 2020 +0800

    io_uring: refactor file register/unregister/update handling

If I revert this one, the test completes fine.

The case case is pretty simple, just run t/io_uring from the fio
repo, default settings:

[ fio] # t/io_uring /dev/nvme0n1p2
Added file /dev/nvme0n1p2
sq_ring ptr = 0x0x7fe1cb81f000
sqes ptr    = 0x0x7fe1cb81d000
cq_ring ptr = 0x0x7fe1cb81b000
polled=1, fixedbufs=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
submitter=345
IOPS=240096, IOS/call=32/31, inflight=91 (91)
IOPS=249696, IOS/call=32/31, inflight=99 (99)
^CExiting on signal 2

and ctrl-c it after a second or so. You'll then notice a kworker that
is stuck in io_sqe_files_unregister(), here:

	/* wait for all refs nodes to complete */
	wait_for_completion(&data->done);

I'll try and debug this a bit, and for some reason it doens't trigger
with the liburing fixed file setup. Just wanted to throw this out there,
so if you have cycles, please do take a look at it.

-- 
Jens Axboe

