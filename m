Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D6C20B96E
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 21:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgFZTmU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 15:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFZTmU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 15:42:20 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6A0C03E979
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 12:42:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 67so982994pfg.5
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 12:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sjZkk2ohguzX2taCj5iKPqcZeXksHN3X9kXAkAwuPs8=;
        b=ZrEhMFIQQ04PvWXlRlUmhNWePiKl2rLmLxp/ffKGPcdncklUGyAnrXT9yEYTj5nyma
         japQJ4dYbwRzpQOEaEqE26M2RNDrqROpFpMU9ZsHyrgFs7leaVqTzIQKWtgf2BG4a7IL
         7HQ085zrbJ6QABjGoLm5/wdKF8D8F9j8hKpfdE5iflRA9zCeA8mgky1GkwyeQYFiYW8h
         nXlIMYoHK0/swhF4J6cp/QHKi/3rcTsObBAZDihY+YTyXObjOcbcLIzUgGC8J5jaM0XK
         4gRI8tNDTjQvEeMZopqGjVpK7Fi0ZVaHB07Q1K0wbrIdridZMe5GHspMUqSpFW5NDz5G
         IO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sjZkk2ohguzX2taCj5iKPqcZeXksHN3X9kXAkAwuPs8=;
        b=oTsEIPabMh/cg4vUThZpeGMJxMoFodj7h1LKzW9GbuGImy51iuKytaAG5SHyau4ru/
         A/8Z3rEoz3zcKYlM/AjSfM/b3DVxTD32qXxu9FubeJZwNdPf4mO9RVfHMh2WXaVV24SJ
         w6zEoTbX/JmUI5LVrAOVxzs2x92pqWycmXtYUiGWDKw8ZRNwFOFRHSuitmfD3UcKfQMV
         kdWe5x0caUXsYfeVl3m1mJ34C6ZkWWmgeyj5sRIphgR6oEd/TdKTj5U4m4Tk0vfhKjEr
         OQr3NtTylnAmhTcQR+EQnj4aeD1Vvgpr4wcZcqhBSPoGlCokTGsSfX/Gw2vTzb+mUxtl
         TC7g==
X-Gm-Message-State: AOAM530DPNfB/APaGaG77/rOh8VlJeCUfMeW4ZQCh7k4XZ4SQ39vUSKa
        yxrVCnHcYIKuwY4+1obDKGsmNw==
X-Google-Smtp-Source: ABdhPJzPZ9cGfujtMwVKZFWK97745rdmhxZ/GVYvUXDmfr1vEqjC7NQ9CNMTYPnBY0aZ7R8+deV72g==
X-Received: by 2002:a63:a843:: with SMTP id i3mr302296pgp.190.1593200540047;
        Fri, 26 Jun 2020 12:42:20 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h8sm22938348pgm.16.2020.06.26.12.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 12:42:19 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.8-rc3
Message-ID: <cbae6931-9653-d051-fab5-08537e1dd1bc@kernel.dk>
Date:   Fri, 26 Jun 2020 13:42:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Three small fixes for 5.8-rc3:

- Close a corner case for polled IO resubmission (Pavel)
- Toss commands when exiting (Pavel)
- Fix SQPOLL conditional reschedule on perpetually busy submit (Xuan)

Please pull!

The following changes since commit 48778464bb7d346b47157d21ffde2af6b2d39110:

  Linux 5.8-rc2 (2020-06-21 15:45:29 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-06-26

for you to fetch changes up to d60b5fbc1ce8210759b568da49d149b868e7c6d3:

  io_uring: fix current->mm NULL dereference on exit (2020-06-25 07:20:43 -0600)

----------------------------------------------------------------
io_uring-5.8-2020-06-26

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring: fix hanging iopoll in case of -EAGAIN
      io_uring: fix current->mm NULL dereference on exit

Xuan Zhuo (1):
      io_uring: fix io_sq_thread no schedule when busy

 fs/io_uring.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

-- 
Jens Axboe

