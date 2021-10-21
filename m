Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C346436E81
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 01:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhJUXub (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Oct 2021 19:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhJUXub (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Oct 2021 19:50:31 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFE7C061764;
        Thu, 21 Oct 2021 16:48:14 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p21so1192451wmq.1;
        Thu, 21 Oct 2021 16:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=atK4MhdI2eitXeDWrKsLiGD2Rj92fEmJFDL/6M3IEL0=;
        b=RFDXr7yZ0IH/6WaE35aNf5F2URcrvXCvcQP/SBgVTyFJtLg70ZwXrJeiy+awzoeTm7
         rGRA797qNkBXJDWEJ3wngVxRAIBQ5ShV5vC7AkGg951m1HM+OJa/KHHiZDWS2UkvhSdH
         uIytTjmKlZa0jnDTxIAeG95W0Na6Pgf4+zYphShXI5OWaBfL1TOvA7xzKaCgC3p2ceI2
         RDxD1LSTJjn0T8sK4Y2R270OuFesZabskVJpIGUelsYWtluhBqElcJ5mR6Hz2FDO9EeZ
         hyqgYHhP1TbGUC1z27xgKi6izDjYnIRfZprQCMwSXinAhRtnp4wGddvKcFgXl3IkL+iN
         ynlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=atK4MhdI2eitXeDWrKsLiGD2Rj92fEmJFDL/6M3IEL0=;
        b=p1DEyabS8oVEJxdNrfRruEg7mDsHJ3MapVL2Jn+gmSq05WS38J6aVaABMWVPWuzu/h
         vMbtr2KqcueJZnwv5uZOx5JUo2L6aNgoY4w9MLnM8x+Diw81ScEPfFXvHowQyfMsp/9k
         tI5jtVrj1AVItnHmxlPtAroL8+ePOW9JvINLynQrG+bDI6Tu27UB3034TRtvyoTGyvDc
         FaavK9UlJT3/6al/VL/cIBGVCc47kxlkpBWV4UHhM2CbDXf7o2WCTqTdrk7/3AWQzpz6
         /SgjiPT/FepX0fyFU/3iu6WM8oKW/vD13dK1Y26Fh+zdDk1TBh0l2HhdX37yWGzrZl6d
         FR0Q==
X-Gm-Message-State: AOAM5315dTAnxh/O2eV7EqFR4f9hunj4uW5Acbe4TeHuJxhA9aoQi33f
        LGfqcHXJrqQbZ51fuJU2J7GHNS+z+J/G3g==
X-Google-Smtp-Source: ABdhPJzatP6oh1wX2X4RrLVxsgsN4nuDq5Md1D8IT+0oXesd8DgCXY/rSOYsfjRP8MFmd6tO8TNA8w==
X-Received: by 2002:a1c:7206:: with SMTP id n6mr6516174wmc.78.1634860093246;
        Thu, 21 Oct 2021 16:48:13 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.193])
        by smtp.gmail.com with ESMTPSA id h1sm6030254wmb.7.2021.10.21.16.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 16:48:12 -0700 (PDT)
Message-ID: <b9863d9b-11d3-8117-256b-714ae38f5494@gmail.com>
Date:   Fri, 22 Oct 2021 00:47:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [syzbot] INFO: task hung in io_wqe_worker
Content-Language: en-US
To:     syzbot <syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000ddc11905cee3521c@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000ddc11905cee3521c@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/21/21 22:10, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d999ade1cc86 Merge tag 'perf-tools-fixes-for-v5.15-2021-10..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=136f87d0b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bab9d35f204746a7
> dashboard link: https://syzkaller.appspot.com/bug?extid=27d62ee6f256b186883e
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d3f7ccb00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15d3600cb00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com

#syz test: git://git.kernel.dk/linux-block io_uring-5.15


-- 
Pavel Begunkov
