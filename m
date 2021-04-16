Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7F5362A9D
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 23:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhDPVyq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 17:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDPVyq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 17:54:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9D5C061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 14:54:19 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u7so12877316plr.6
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 14:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/UZ3bGMqCNTmS5gXMjjSZ6uNnrBbm3LqPtfDRy5b3Sg=;
        b=M5p5S8NwpXT9boi33eDhomWgSUMKVQpXEvmWNV6xkIUMPBwyISpLuJ2j9XBZhMPG7z
         FqLeADytHHfwT+ZjrNn0UqHrFwnGEGXmT5gXoNHnBWDbPv41/y2KqXmRpDzTNUqurdTl
         klII1zbcDqEky9iAkWqqmcyEfC+I6qshPadWO8NwZd7MF0ub0xpWe3UOJKDp2H2/PrzC
         25bsejk0YPtvPwImPfESin5Xhi5NV2dGuxPwwdm0YRu6nQMlh82tpcwa1Qqfja/oA4S7
         i9jVgsfErQJADi6smYmc4PNA/PAM95evC6xcJOcYui3Lklwj/Swy6mNHOjA/Odp2Oiy6
         mhFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/UZ3bGMqCNTmS5gXMjjSZ6uNnrBbm3LqPtfDRy5b3Sg=;
        b=qtyGRkE5nrD8TVvvFjuos1aV5jQgtcMGo770QJ8S+Oas95iZtY0HaBEEK+qVlRzorI
         UrB07EBNUo6iJf7UYrdJp8sLST0SrzjXYpYm2NAJuD7NCowQstLpdzKKynu+J7/ydQqx
         uBO81Ufe+0dF/+/irPSQyxZ86UaGIWrunt/XVYMKUpQysxsr4f5ogojOC/y1u4UavQ/b
         PnCn57h+MI9XqCAJfKk52mPbz+eq1oH1+JmGUc0M1uo4Rtmf8M/Vz3drWYmXJS3xN8sG
         Lmiot9dU4dmzV0tRa7whujjc9VjXTcI2Dj3+BYFV6ZIRKamuCOg2//uzohQI/MXwiQDi
         Aong==
X-Gm-Message-State: AOAM530tOUfYystF7OTE1QQyzi2ZxLeGvachw8X6WoMGYZUt1xAxiuQq
        aMwza87bBptF/tnYqPYe44gPRN/lsVIhWQ==
X-Google-Smtp-Source: ABdhPJyNFckMAp+BNjReSGxgK2qq+g+ZYSgtoYHDyoYae0KzC6aFnzX+xEP/QeWPpNxrRRxCgsHG8g==
X-Received: by 2002:a17:90a:ea0f:: with SMTP id w15mr11561158pjy.31.1618610057821;
        Fri, 16 Apr 2021 14:54:17 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id gd1sm6199783pjb.49.2021.04.16.14.54.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 14:54:17 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Single io_uring fix for 5.12-final
Message-ID: <e1666240-bf3c-445f-880d-241299211fb5@kernel.dk>
Date:   Fri, 16 Apr 2021 15:54:16 -0600
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

Fix for a potential hang at exit with SQPOLL from Pavel. Please pull!


The following changes since commit c60eb049f4a19ddddcd3ee97a9c79ab8066a6a03:

  io-wq: cancel unbounded works on io-wq destroy (2021-04-08 13:33:17 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-16

for you to fetch changes up to c7d95613c7d6e003969722a290397b8271bdad17:

  io_uring: fix early sqd_list removal sqpoll hangs (2021-04-14 13:07:27 -0600)

----------------------------------------------------------------
io_uring-5.12-2021-04-16

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring: fix early sqd_list removal sqpoll hangs

 fs/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

-- 
Jens Axboe

