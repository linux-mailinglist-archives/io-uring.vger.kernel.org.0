Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A182C6CB6
	for <lists+io-uring@lfdr.de>; Fri, 27 Nov 2020 21:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbgK0Urb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Nov 2020 15:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731306AbgK0UrO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Nov 2020 15:47:14 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F88C0613D2
        for <io-uring@vger.kernel.org>; Fri, 27 Nov 2020 12:47:12 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id b6so5502372pfp.7
        for <io-uring@vger.kernel.org>; Fri, 27 Nov 2020 12:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Su0GTMBbYgG9BsUSBQB5W/DStXNGggt2XCyviFRT4/k=;
        b=jQOibEERmHKfeZ8RiX+ufpZuWEgC5hBXXluKyW9w84EfiU8eeBtXW+dw8F4YPLSm14
         qgr6o6b4wY9sh3KhKECCJiBMVF74y/wxdsI5c3mKf+6ObN+CrNRqb92cTag2GwcX/5rn
         P7q1aGBIe8dR7DvyPcvPS1EqLIzUiLtKrQKRaBB3ai8cTIY6CwU7wYafzUayTQFmcJBo
         iGG8tQ3dbNv4ufjYCg1miBEmvV6Q10iKN+BsZaIfuAfPtcDR1SQSplmV6O52OBZXkD13
         d9omBUdcYgzpdeugmo7Q/EqQh3Q6+IityU3K3xELnUESDZeRgBj/fQv8pjidrjy9p4CD
         4RRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Su0GTMBbYgG9BsUSBQB5W/DStXNGggt2XCyviFRT4/k=;
        b=hgmvhDmoQUQgQtSDH+qsBJyYBlrNfcL4qr6zC4JZrEXSwrJILfE6ZeXd7o7rTzwUC+
         4HDu40suc8KIoILCzPQMj38PAEuL+MWfRwfBJPSyAM4wiJovWVvZsKIW+IT/tU87EqW8
         JPnwwiIfMi1O6D4joURiRNlJDh4shGvsJjkOULbs6t6+XxzBOSbdEXTxjCOJo/wO8QAV
         TdSz6x/PyFlvzv3sOxguowOh7iPG5xYbnNzVo9DZJEMYa4tiEVQ2SKENJp0JQelxfLbw
         vvbw+wV4KFoEtGQtJaaRwfpRcTdJgq8HCWXL1w0G6R0v77tbUXLicOitCByesbJCZJ78
         EeKA==
X-Gm-Message-State: AOAM532+4mHWFYesmwoDt9ZnEEPGaZ2qAUcPs+tRdSwexJEwgkkvbPBv
        E1rchOGp+6NHeYywseiatOPr/78cfeW7Ag==
X-Google-Smtp-Source: ABdhPJxEDNCqyCsHvHDkjGqdShMeS0TGmMdzq/MPnfTuItkajL3Nq1oQyzXxcBvtqtgp2XWOPAX3pA==
X-Received: by 2002:a62:b417:0:b029:18b:8c55:849f with SMTP id h23-20020a62b4170000b029018b8c55849fmr8493446pfn.27.1606510032211;
        Fri, 27 Nov 2020 12:47:12 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:9f8b:f9ad:5d0d:795? ([2605:e000:100e:8c61:9f8b:f9ad:5d0d:795])
        by smtp.gmail.com with ESMTPSA id b14sm8461199pgj.9.2020.11.27.12.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2020 12:47:11 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.10-rc
Message-ID: <f4f5ae6e-8442-74de-73a1-71bc56e62fd8@kernel.dk>
Date:   Fri, 27 Nov 2020 13:47:10 -0700
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

- Out of bounds fix for the cq size cap from earlier this release
  (Joseph)

- iov_iter type check fix (Pavel)

- Files grab + cancelation fix (Pavel)

Please pull!


The following changes since commit 418baf2c28f3473039f2f7377760bd8f6897ae18:

  Linux 5.10-rc5 (2020-11-22 15:36:08 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-27

for you to fetch changes up to af60470347de6ac2b9f0cc3703975a543a3de075:

  io_uring: fix files grab/cancel race (2020-11-26 08:50:21 -0700)

----------------------------------------------------------------
io_uring-5.10-2020-11-27

----------------------------------------------------------------
Joseph Qi (1):
      io_uring: fix shift-out-of-bounds when round up cq size

Pavel Begunkov (2):
      io_uring: fix ITER_BVEC check
      io_uring: fix files grab/cancel race

 fs/io_uring.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

-- 
Jens Axboe

