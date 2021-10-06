Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49335424555
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 19:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhJFR5Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 13:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhJFR5P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 13:57:15 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772C2C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 10:55:23 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id d11so3707676ilc.8
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 10:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LzP/88KrusQ0w58mk5OJSWvFTggsi0OhcfnP+HTJN6c=;
        b=iJyN3HP0JJn6LDNUOeUzuLam0RdidVSOkEMqXwk1oSmzAcmGkRVHaJIe+QtcFAOdmC
         ubDhhmphJfowHsW9UK6Xa3VC8YQSx/Jn9DVEHnuT0wyGP093a+8wj13BxQOu+GYRYVZO
         +/FJ2uKOj5YOj+3Zx3BRbdqu405Vy/qNEb1bp4SYil2Wl+qkG77grCnFl3Bm3utgIMf8
         fsQ3zSn6N5hqpBH7QU+LzYx2yT5A3nO0GhMTs068vKJUtnT1eN3GC1vgqY+gtS5fXvqL
         3RLaDObiHDF11beAtIDDVHYRrDJMVvY6e2ilYHni3vXCPTauTzRwv7RdFOsQ3s+lakxk
         B6mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LzP/88KrusQ0w58mk5OJSWvFTggsi0OhcfnP+HTJN6c=;
        b=k/ZAiZktq+q1zHlh57s6fr8KaZFf8EAE2k1P1Ksn7emid1f1hctgki18wv3nMcP3cE
         Cgm+LZpU3/VPonFNdpSVqBOdoxuP7H0AjWXsh0T2xnau7t47nEeG+5QuElJHDOR2k8R+
         bN2WNtTo56aKYoF3Z+veK0qqkLmpAUaw4MCBMCqYKKb/oydcEb6bHDlz8nuLrk1W7fXH
         VUx8AyGJRUbyqSE8G3vx7nWcHlcWr/GIGQfd27aN5RrN1Hw7uQbx919xnQDzNJMCqXg4
         o0DiAxxxNwtRv3/AtH0KLpr7QiTJYBP/LT5DkQOKQyAKFGyK+sQ/GLxJxKfytHQxVP7O
         j0Qw==
X-Gm-Message-State: AOAM531m9BzrTF3N/+j+owbOgS9g88MsWKqHKr8Q/wGEOG+lVLFFTi/D
        lDUVwNo+ZrviZZYTTBkSS7DHD7Ar2P9QShNPyCA=
X-Google-Smtp-Source: ABdhPJyKDZw6BJKb1oktk4SAfdGcXVbH9R4EjrZ5kfLM2uiK7nDM5vZxWN4haPwjTAZYtW/1nHKsIA==
X-Received: by 2002:a05:6e02:198d:: with SMTP id g13mr8278137ilf.300.1633542922839;
        Wed, 06 Oct 2021 10:55:22 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q17sm12483504iod.51.2021.10.06.10.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 10:55:22 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in __io_file_supports_nowait
To:     syzbot <syzbot+e51249708aaa9b0e4d2c@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000058faf705cdb2d5f6@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c3797510-2fc9-53f5-7984-446159e0374a@kernel.dk>
Date:   Wed, 6 Oct 2021 11:55:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000058faf705cdb2d5f6@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz fix: io_uring: fix queueing half-created requests
-- 
Jens Axboe

