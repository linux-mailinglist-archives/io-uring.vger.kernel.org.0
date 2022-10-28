Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11993611C3F
	for <lists+io-uring@lfdr.de>; Fri, 28 Oct 2022 23:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiJ1VMI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Oct 2022 17:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJ1VMH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Oct 2022 17:12:07 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2ED1C69DB
        for <io-uring@vger.kernel.org>; Fri, 28 Oct 2022 14:12:02 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y13so5788811pfp.7
        for <io-uring@vger.kernel.org>; Fri, 28 Oct 2022 14:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCW1xv8kmr/Vi1PMpuVu5hSF3/jz7414gU5nYLIQuwk=;
        b=6Tblmfs0i4Ubg9yjoJinEu1zWGbYkSAb1Qri5RTBKSO5afeKjhp9BElfsUZd5b2Qvj
         PI6bWlrn8N6i8iJ0bLLEK2tQvxIdH1cLt9tLGi/0N/svrSAOoJuzTP4tDxpeakTXC1xi
         HD+uc2C8mDbWq+LKOQkZUc/4MKTJqQUwG2bVZ0VTuD36TtD4uwq2esEcY7OLK7TOE3JP
         wX7DEddUjke2fMRHctRL+dXpYy65eNfNWryNCuiPVX13yFyhu1TrukkDogO62RYq9PrU
         4pRtJplRSS7DcS9t1X/vnJGk70lcfwb6fBDOEti5TZwCu365V2w9ET7ybVscXdnaNe7+
         HyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bCW1xv8kmr/Vi1PMpuVu5hSF3/jz7414gU5nYLIQuwk=;
        b=P3Y9Uh1kcY6VQTaK3RA3O8nYtE1F3Hp7Sd5ybTD4Pk6PSBFAKlYoGPYQbUlyy3i9Wa
         wO8PDQqZ5zSF7wYPZhGiMiT4n6LIMZoF7jFpH4oMJVg8K++R9/63L5WahJgyN3DecQxg
         +48BEe0KXI8IU7p4g1D1/Sa4L2HHT62m2eTsuIYk96Rg0CLxeYNB7r4HOGN485EqJtLw
         WAYfzxKyf92kklnWqqrvRefU8NbGfgiQsKyp4y5Wn2hxxp81A88D9R/jeCRKIdlaYQ9h
         5cAlNmy52cs1JhLRtlhYCHs4iaxN3kuGwEZorYr9ovFjbrNwfiilP+fTJMigyjAB5doU
         VmeQ==
X-Gm-Message-State: ACrzQf3Zx/xoufFfazvP3vp+xepOjSmaq98QylTEdEmPL8QHxsGiDke4
        FgO/lcamvnZcRqCYHxB2mA4LoFeRVuOXaApF
X-Google-Smtp-Source: AMsMyM6KlYVLPUjXgdwwFHAYuRAny9iP6Kse9OmvG0yv8VEc/z+DeOVnT6AjD8efHZEy5AVKLfEnQQ==
X-Received: by 2002:a63:ef18:0:b0:439:befc:d89c with SMTP id u24-20020a63ef18000000b00439befcd89cmr1220065pgh.504.1666991522076;
        Fri, 28 Oct 2022 14:12:02 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id bn17-20020a056a02031100b00460ea630c1bsm3089270pgb.46.2022.10.28.14.12.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 14:12:01 -0700 (PDT)
Message-ID: <0644eeea-0e0a-d09c-2b65-365b7ab823ba@kernel.dk>
Date:   Fri, 28 Oct 2022 15:12:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.1-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a fix for a locking regression introduced with the deferred
task_work running from this merge window. Please pull!


The following changes since commit cc767e7c6913f770741d9fad1efa4957c2623744:

  io_uring/net: fail zc sendmsg when unsupported by socket (2022-10-22 08:43:03 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-10-28

for you to fetch changes up to b3026767e15b488860d4bbf1649d69612bab2c25:

  io_uring: unlock if __io_run_local_work locked inside (2022-10-27 09:52:12 -0600)

----------------------------------------------------------------
io_uring-6.1-2022-10-28

----------------------------------------------------------------
Dylan Yudaken (2):
      io_uring: use io_run_local_work_locked helper
      io_uring: unlock if __io_run_local_work locked inside

 io_uring/io_uring.c | 11 +++++------
 io_uring/io_uring.h | 13 +++++++++++--
 2 files changed, 16 insertions(+), 8 deletions(-)

-- 
Jens Axboe
