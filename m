Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85A057E43C
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 18:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiGVQSu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jul 2022 12:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiGVQSt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jul 2022 12:18:49 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA9EFD4
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 09:18:48 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id p81so4001255iod.2
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 09:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=QErZ/mBdyiu2LSWRDiuOIY/xIMRRpCo8YbiGaMGQo60=;
        b=udm11yy4s3/VqQhw5KEZMNM94GcRICpUsYEHmZsoPj2CYQehjbG8+eYtXialCzXQ/J
         IyxW4gafmpttCTWV97M9tB4ifFoC7cqqAgUfaY/6+BOBEE1cZlHHDvwjqvSHuTCkDUn5
         6KNKqg4PUjPQQKkU2DCQ0Bcv49tT4/BFDUcJj4MqdbUGiomvJ/doixWjfKbZi/hSXH/y
         qOGwtCk5SCC52FKuet1gBcCksEap2+Ib/B+itkj1NbWYikF/sQcw3gXgGvEsMiJTPhW1
         F/FumBBlhHJ8MdtQI+v048XNHBOqydEYrtUp5LvbqWS1Q02EbPBHsx2J0wtq8RF6Uiot
         mklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=QErZ/mBdyiu2LSWRDiuOIY/xIMRRpCo8YbiGaMGQo60=;
        b=dcXq5sP4M2N0KftaCQZq2aHfWyUYtt53Q5FMZYp5WBdDResT5bSw575Xk05IiFFysI
         VK34QyrbfUJifSlv7c1H8/m2/EyDKvMno3HrQWkXmFmriFkxed6uLIQf7/hd8P0+8w0v
         ShBkMHJKNQXAGGlBsxjdgvdY3vP+I/SWcPlujLYpjjlra5KddqtB/Y+YuVHzPtxq1+/f
         pMPe16WHMDXNF2cTcB07kdapFbuDwe1CAD2zLjmDa+FX0WOCkfpjxXw22TdjAZWxw17Q
         jLEdgZ588BGAlV82FNJh7yHRCQ+0VTuVWiTJYFcE31KpgjhICtAW+JP/nAWcQwOR2OJX
         6nYw==
X-Gm-Message-State: AJIora8YeyAf3vdtWiTbwAV5gT6mYIMT11pF97BYZcdDN5pHJBoFbczA
        P6VmwZnKnYjmNAZh7hx1/nAci4++x7gp4g==
X-Google-Smtp-Source: AGRyM1vvIOqCoW8RvLhtDcspDL/wYumf7okriWKwGoRcDFdXroa+YiI+su0Lhbe5So6vYDrtXgT8dw==
X-Received: by 2002:a6b:ba44:0:b0:67b:cf5d:4deb with SMTP id k65-20020a6bba44000000b0067bcf5d4debmr186339iof.183.1658506727573;
        Fri, 22 Jul 2022 09:18:47 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l6-20020a92d946000000b002dd042e9b36sm1901079ilq.41.2022.07.22.09.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 09:18:47 -0700 (PDT)
Message-ID: <bb6d41af-7343-a8c5-92c9-100e13fe43a1@kernel.dk>
Date:   Fri, 22 Jul 2022 10:18:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.19-rc8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Fix for a bad kfree() introduced in this cycle, and a quick fix for
disabling buffer recycling for IORING_OP_READV. The latter will get
reworked for 5.20, but it gets the job done for 5.19.

Please pull!


The following changes since commit d785a773bed966a75ca1f11d108ae1897189975b:

  io_uring: check that we have a file table when allocating update slots (2022-07-09 07:02:10 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-21

for you to fetch changes up to 934447a603b22d98f45a679115d8402e1efdd0f7:

  io_uring: do not recycle buffer in READV (2022-07-21 08:31:31 -0600)

----------------------------------------------------------------
io_uring-5.19-2022-07-21

----------------------------------------------------------------
Dylan Yudaken (2):
      io_uring: fix free of unallocated buffer list
      io_uring: do not recycle buffer in READV

 fs/io_uring.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

-- 
Jens Axboe

