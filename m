Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC5C779720
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 20:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjHKSeh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 14:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjHKSeg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 14:34:36 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA28271B
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 11:34:35 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b89b0c73d7so3412015ad.1
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 11:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691778875; x=1692383675;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3ohAdLG+aTdew/mXLsj2pNVmB+jspkk0pcaHxOonpk=;
        b=MeE5WfE+O8DThA++dH5X6Rg0LdozM9bDrjJKp/CphTtjrsiVlJNo1Czct4+BR9W/7p
         EtzIjVMeqionB+Azh9FTMJrrG0PTzbLsNMjH8yWLvxRmkL5bWoFheedL3IKB0YKrAhqF
         +qb+lRIM39c0k2ZS6XB57ZxW8a0u8BPYZ2OdIIhhCq7A3MOPFKFIoQZsyBi6+0MzUUwS
         +Z5Q74lKKITg06qEErVvEMjIzqTKNUb/gnzh902WkzCcPgGCPGp71kMv4yRl+PHci+h/
         b4HsC5R7vxHZMIKnfTQnR6AJg/sxHc1VB0+bV6g/s0U5zCvuuFOPFaL/ebbOWTuu8cvg
         spTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691778875; x=1692383675;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v3ohAdLG+aTdew/mXLsj2pNVmB+jspkk0pcaHxOonpk=;
        b=Gd14934cNatt26GSQgrm9Bry66APyIf1ilMeafSwFNxg74xmsorwRIFYtn4HL0xPqn
         d2kpFKo6YVzafqD46hSX9pNMQx6KLDNqq+Ci22udptc7P8NX0hnxEhs+ev/xoQvHXaZL
         NbWWyzcY/jhSy6Zgu/fWFJxgMVacQGy+jVno3bsF0jJ2XUE/XHy0aR4yFYi6mvJrzZs6
         7NoK3l9GwkenX7JSXcfY3opTfgJqnGQBzv+tF5QNsZqhRK52hxwBgijL9q0ZjU6V+zHz
         JNCKerAehLxu2pbH4n+3k2uHs5X2u9uChanNxjtb8n4CdQ4R7jHJofJyngmU0oZyNS4W
         jgbg==
X-Gm-Message-State: AOJu0YwiNhiI9Dac606klDwg3DL7gSamCLBlXNkgcaQ4EoYhf0wTLp7x
        pcbM3YiONeXjNTfZxEGro2DY4pqdcIr/+QB766k=
X-Google-Smtp-Source: AGHT+IFgayIYOm8zUTXxV5sLs/kpQCAhnjyN7H/dTPO7G5ZER873O1sRay20KkUFYbIV+K6N1g43Qw==
X-Received: by 2002:a17:902:d503:b0:1b8:95fc:cfe with SMTP id b3-20020a170902d50300b001b895fc0cfemr3076849plg.3.1691778875376;
        Fri, 11 Aug 2023 11:34:35 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709028c8c00b001b8b4730355sm4246025plo.287.2023.08.11.11.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Aug 2023 11:34:34 -0700 (PDT)
Message-ID: <3f5e6dc7-0391-47e0-a430-e544c42c86f4@kernel.dk>
Date:   Fri, 11 Aug 2023 12:34:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.5-rc6
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A followup fix for the parisc/SHM_COLOUR fix, also from Helge, which is
heading to stable. And then just the io_uring equivalent RESOLVE_CACHED
fix that went into -git last week for build_open_flags().

Please pull!


The following changes since commit 52a93d39b17dc7eb98b6aa3edb93943248e03b2f:

  Linux 6.5-rc5 (2023-08-06 15:07:51 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-08-11

for you to fetch changes up to 56675f8b9f9b15b024b8e3145fa289b004916ab7:

  io_uring/parisc: Adjust pgoff in io_uring mmap() for parisc (2023-08-08 12:37:01 -0600)

----------------------------------------------------------------
io_uring-6.5-2023-08-11

----------------------------------------------------------------
Aleksa Sarai (1):
      io_uring: correct check for O_TMPFILE

Helge Deller (1):
      io_uring/parisc: Adjust pgoff in io_uring mmap() for parisc

 arch/parisc/kernel/sys_parisc.c | 15 +++++----------
 io_uring/io_uring.c             |  3 +++
 io_uring/openclose.c            |  6 ++++--
 3 files changed, 12 insertions(+), 12 deletions(-)

-- 
Jens Axboe

