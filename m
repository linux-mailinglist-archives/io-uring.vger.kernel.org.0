Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F30925DCE3
	for <lists+io-uring@lfdr.de>; Fri,  4 Sep 2020 17:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgIDPLm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Sep 2020 11:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729942AbgIDPLl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Sep 2020 11:11:41 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C23C061244
        for <io-uring@vger.kernel.org>; Fri,  4 Sep 2020 08:11:40 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h2so1312803plr.0
        for <io-uring@vger.kernel.org>; Fri, 04 Sep 2020 08:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=LVv7QjLLBEpSW7WnhjcYOrk1O+Km/9FIYCfDL5fWQAc=;
        b=BAMXWAEtd9yE9CITTwLIjbowcowuh5w5V1KRW9Br4LbOD/CA6G+NRQaGyeIIYdp1/X
         lbAjoYs3DFRUl5YTXHFNz0gdFsuCCOsqmmKh0im2auoKklT/Lcl0iRZDbT7pTEBsND5r
         FKGJkvanG7LKbMDpZB2KsVxqPyX+yFxQxk7pSQqjEtb6kFFkhdzvzzgbxv67VO6sJ8+D
         61UmySXNdTkAMxRTCLo7SCKpMBSC9pnYVnH8keFnoo3IlwwZdTsE9COsS25eimMnfYXw
         4HNHdA+1Mcc7DmnBkBYiwgORsdx+L1au/8ns0ey0mZfRDDxzyY37e2TCOsXrSP9mtUcC
         2AwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=LVv7QjLLBEpSW7WnhjcYOrk1O+Km/9FIYCfDL5fWQAc=;
        b=rK01dWqZa24B31HGiBjswoG4Uh5K/1+X8T9Yw7xcV5soCb730wijk1FMYDUX4GtNP8
         ywXuXXaDOgL83cmQZnOtREIb/1sZ9e+M5ZqGUlsgetVJaqIvAyLRL1QKBzOhNd3Nvgkk
         bFavxlt27blH6MQhVcOAWZ1E2lnZhmKJbzUGPThOWSRCZXwXFl/T4nx+xYOHaReEupP2
         AJri3cQRTtrHwC40pjBOhmvbiSLIi3N6PnBEYvGSNNP0zDJpdZDH4ym/n5Vit0yZH3fg
         dZYbzX1J1LUEelDfzg8dcZfIBz2BF8j+Ik3303hjVVVbyg2ZkzXSIZHVVJUovl9i3sy9
         lb8g==
X-Gm-Message-State: AOAM531EWxYGtLI8/JWGUNlF0MmyXzSET3J9OCuXw+qhVpCVpOrONtqY
        4e2eGpG1J1N50WNgcqB0jbSABi+2JTqTC1LX
X-Google-Smtp-Source: ABdhPJwKd1TBm5RbuwEdsI3gRZra9YD3y0SlNrANrjQ/h2Tkenwtyifhf29MgepF+tWrbN4rKylAwQ==
X-Received: by 2002:a17:902:ff02:: with SMTP id f2mr8902202plj.218.1599232299725;
        Fri, 04 Sep 2020 08:11:39 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21cf::1188? ([2620:10d:c090:400::5:1a09])
        by smtp.gmail.com with ESMTPSA id v10sm6679560pff.192.2020.09.04.08.11.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 08:11:38 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.9-rc4
Message-ID: <b380d9cf-2558-b354-981c-e9e868f9587b@kernel.dk>
Date:   Fri, 4 Sep 2020 09:11:37 -0600
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

- -EAGAIN with O_NONBLOCK retry fix

- Two small fixes for registered files (Jiufei)

Please pull!


The following changes since commit fdee946d0925f971f167d2606984426763355e4f:

  io_uring: don't bounce block based -EAGAIN retry off task_work (2020-08-27 16:48:34 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.9-2020-09-04

for you to fetch changes up to 355afaeb578abac907217c256a844cfafb0337b2:

  io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file (2020-09-02 10:20:41 -0600)

----------------------------------------------------------------
io_uring-5.9-2020-09-04

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: no read/write-retry on -EAGAIN error and O_NONBLOCK marked file

Jiufei Xue (2):
      io_uring: fix removing the wrong file in __io_sqe_files_update()
      io_uring: set table->files[i] to NULL when io_sqe_file_register failed

 fs/io_uring.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

-- 
Jens Axboe

