Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293C845F101
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 16:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354131AbhKZPtm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 10:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378135AbhKZPrl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 10:47:41 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8DAC0617A5
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 07:39:23 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id w22so11917333ioa.1
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 07:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=274Q/ZAR2tJK2tvrv6ob2tLr8yiaidfzpxRndGsg+Jw=;
        b=VILeHlJ58UYc/45Jyz0QIBZo5je0NWjHDkZc7Slj4nmZOkq6P9/xbXke7Q6zWVZgzf
         CdLMHgGoDy106GlBIwv2PFCrXX+tgUca/8EOoPwZtCvKd4zegO0F6GNS7HcYk1bZP6Uy
         mmRZobVs87Hzz8vPEtgioM6q2d8jILrAX3DsYAGmJs8rjaPVoLul2LYqBuEpPkPthAh9
         ViT8VqvN+rGLebfFYA2FPFY5EypgOjJOSjaFNrKCo++oaZ6sUgIvJ056hmk9ZD6qBmId
         N6N094YWVL3jf6GCAk8gdXH0V3ylTxFhBLfvU88u5Cfjr8NWh3OJNgs0zCJEzo2tjHpC
         mbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=274Q/ZAR2tJK2tvrv6ob2tLr8yiaidfzpxRndGsg+Jw=;
        b=VLWLC+G4WVOvQvaoX//xYqo+qFiVvrau9J02o2Sk3X3YFv4imrY4EuVvBUtHEwzwW6
         hhFy9MwwYOqrhVDlRGz7SUiv8l6GphOuxhzdXp47/iz5ZO09yCPN1dkQQkgQHFvl5wL8
         n93a1ujpPAzOc5ZiX35IOpez41XQrrpJ5wZrxRR1Te7hk+PUbEIFMeJUye12FRe8TpL3
         lpjtE5tdjzReOkHasBsC60p9E/pX923wmr8FvzJ0diVfonWrLW7KObsENlM5Z7ugcx7b
         511dpUgBTA2g5uUfH8e4HcJ4tTYJ8QZy6ExBVHHRqsLuVSkNiIuPyyPGPy+OdS117iHg
         5+CA==
X-Gm-Message-State: AOAM532af3Cq5ohmY4XtJkeDQEFZ9yumkpaq71+6mTQm6s/vlGTly+vg
        czjKcakLFoBR0TSajUX2hKkTyA==
X-Google-Smtp-Source: ABdhPJzQdGcpJo8sMqqf55R9qprT9dw8UY5pSjpXa2ITLDMJZDJcUG2UlSUi12nSVpKZxN+fVT8//Q==
X-Received: by 2002:a05:6638:3182:: with SMTP id z2mr41736223jak.134.1637941162695;
        Fri, 26 Nov 2021 07:39:22 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a4sm3367274ild.52.2021.11.26.07.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 07:39:22 -0800 (PST)
Subject: Re: [syzbot] inconsistent lock state in io_poll_remove_all
To:     syzbot <syzbot+51ce8887cdef77c9ac83@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000c7ba4b05d1adb200@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cc6aeb46-1cfc-ac3e-0764-c2f930b6f28e@kernel.dk>
Date:   Fri, 26 Nov 2021 08:39:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000c7ba4b05d1adb200@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/26/21 2:27 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a4849f6000e2 Merge tag 'drm-fixes-2021-11-26' of git://ano..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11162e9ab00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bf85c53718a1e697
> dashboard link: https://syzkaller.appspot.com/bug?extid=51ce8887cdef77c9ac83
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+51ce8887cdef77c9ac83@syzkaller.appspotmail.com

#syz fix io_uring: fix link traversal locking

-- 
Jens Axboe

