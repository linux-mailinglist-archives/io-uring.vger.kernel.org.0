Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7641375D1
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2020 19:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgAJSHU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jan 2020 13:07:20 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:41634 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbgAJSHU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jan 2020 13:07:20 -0500
Received: by mail-pf1-f173.google.com with SMTP id w62so1492690pfw.8
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2020 10:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=e39cdydXyLR8RuoOLhJ0fbywsMBFLKrnu0fhJtzX8yM=;
        b=gVsmFyIUB28ErlHPfrjKDAdDzNO3c7AZ5XN0AQyPEM5E6eLna8SRlTRlCIAtKrfs4z
         hgTOUr9f64QaxSgNvxr+ysysNvsAfjaBqWH6y6lFOnyNk0WQdx8A1DHKOtxcK7flfwxS
         t6sK4RpfjbBNQdlZEF5+lw565zHPivHhLAIiXfmJELrwBqnTOQjBr4aNL5DOYisdVxhW
         fb/pcZi+rIiBfa0ZI78omiAbuq8Rz3aNqztHJvPgPu1+xPMmiS6ZMInv5EuspGEqQAUT
         YG1oa4A1UwQzaUOf843N2Fdvgs0tRuS+OI2SbpsvQ8Pfa+oAMAfYRLb+1SyY6LNKJOeE
         R/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=e39cdydXyLR8RuoOLhJ0fbywsMBFLKrnu0fhJtzX8yM=;
        b=SOdyAXJMZDZzdr8pOe1SlkHDjLTbnHGKPJ2LceePxIJM6hhoN4x6M48BH2wriraXxn
         sndnnNpjPhN5k0lVahnR9X3F5GQuPHabrEYcfHqH3YXQz4UEOs7CIMxEKWGVGML1OanD
         qYQ2/Yd4aXLN0IxK62Gt/WP0FWhqJEGQUa/1MPyiKdrGb5DPfWCTMcywJhkP0KvQQ240
         os6EbyNTff76TlbSlEq+aKaWl9XohQ9lkzSaKi7q6VPUrV1846oQ6j/bFDb744Pa0ni9
         OYMGxUcFT+8WQdLRNwB6e84ex0NP2NE59jJOMFV1DvTKQNPwzBHgZryU/CsmXrdb28bP
         tukw==
X-Gm-Message-State: APjAAAWMnDuMc2HtKhfALZ3yNOlN8nDfBT7dt0yLjAskvoiss8zT8W95
        icbFbH18HG89fhU94b2SBkbbCIez6Ck=
X-Google-Smtp-Source: APXvYqwvA5+q9htzXmACRkAFUn5ItQFtWvyhjISBt/jwVgH+iU2/VNwURUeo/qIzRexlyFjPzbylpw==
X-Received: by 2002:a63:504c:: with SMTP id q12mr5821112pgl.117.1578679639364;
        Fri, 10 Jan 2020 10:07:19 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id j17sm3727584pfa.28.2020.01.10.10.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 10:07:18 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.5-rc
Message-ID: <4f9e9ba4-4963-52d3-7598-b406b3a4ed35@kernel.dk>
Date:   Fri, 10 Jan 2020 11:07:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Single fix for this series, fixing a regression with the short read
handling. This just removes it, as it cannot safely be done for all
cases.

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.5-2020-01-10


----------------------------------------------------------------
Jens Axboe (1):
      io_uring: remove punt of short reads to async context

 fs/io_uring.c | 12 ------------
 1 file changed, 12 deletions(-)

-- 
Jens Axboe

