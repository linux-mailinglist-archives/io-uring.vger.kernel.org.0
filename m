Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37DB667D96
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 19:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbjALSOX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 13:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240548AbjALSNw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 13:13:52 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34FC6DBA9
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:43:17 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id m15so9715238ilq.2
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 09:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dgKrza2NtsFkWIoqInfkYFIF1ejr0kkPFxk6nS4NQjw=;
        b=1FP3lYMDFzpooPWyS6CiSsFyMJB3Z4HPH+Fm+WXhIVpiAH13l1yf70RTXoFEOQ0AiH
         w3T3f9d6cP3OcXoiLTqjvbYjl/WXE+famL6wp/gJ9/np4uZ/nRABO1iHnoCbZkJuk3VP
         bbdqYVbvdhhOreeNnvGOePMKP9+V9FBRfLET/b27tN7MrJVmCAPsVmFxUanaWE/rYbBD
         GoywOO1C2biFiY3nY3yVklHN2Rev7Voj76jPiPYwCptFTK14ceLVJdbDrhm6UpyGcmDY
         cFu7qR88z4FdKVSmJAqtyqBcLzCgdRekRFcJbN5mbh0YRSIWBi1sSRmww//8NWKBPzDm
         YLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dgKrza2NtsFkWIoqInfkYFIF1ejr0kkPFxk6nS4NQjw=;
        b=3FIYc0MFY9YelOQ4u9qrpgfeqepKBtjpqLU3WawG/mSsdV1qLuLy/MZJ+XHYTGgDJ+
         9tWu+6t6dCPRiW5MfyARJANlAIZnIJbsHH2vEdkRR2gOhqhxIz6RAheUO/6PmvAwXkPM
         HM+b1Fx95+t+R7+9RM79Untd3LgcXuxaxYmCqHNoJhvwvifmsnQ/oZ9ngc5erd/6gI6Z
         JavVw8Z/oIp5x10900B7ALKiQaqsDph1XTgnVZfRig8EE7ByXvDJ05/la9HznWyfz3z/
         wzcm7I/29AfWg5suyCmW9hJ7cnDqbfzsoKMBsPFeMjXt66wRT7FyRJ5MJ2z9DFtAOB/3
         s48A==
X-Gm-Message-State: AFqh2krIJr8UmiLPgBgOIIbVARAQuDD9T2Ixgge9Ay4fL9AdUochPnbH
        hNGQrb7kTWzWXK+5U0v5JU/y2Q==
X-Google-Smtp-Source: AMrXdXvclKjcy7OSFpmzvK1g+tr/pTH8hn2p5gv21gwpS+TWX8ENpYOuzI9Tyu6qM5IsG/S8kp3cvA==
X-Received: by 2002:a92:d28f:0:b0:30b:d89f:35b2 with SMTP id p15-20020a92d28f000000b0030bd89f35b2mr8969427ilp.3.1673545397040;
        Thu, 12 Jan 2023 09:43:17 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c72-20020a02964e000000b00363d6918540sm5398895jai.171.2023.01.12.09.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 09:43:16 -0800 (PST)
Message-ID: <b130dd91-0871-6138-9a40-8499fb776875@kernel.dk>
Date:   Thu, 12 Jan 2023 10:43:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [syzbot] WARNING: ODEBUG bug in __io_put_task
Content-Language: en-US
To:     syzbot <syzbot+1aa0bce76589e2e98756@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000098a61b05f20e62db@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000098a61b05f20e62db@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/12/23 3:14 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14d269ce480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
> dashboard link: https://syzkaller.appspot.com/bug?extid=1aa0bce76589e2e98756
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.

I know there's no reproducer yet, but when there is:

#syz test: git://git.kernel.dk/linux.git for-next

All of the ones from today was due to a buggy patch that was staged
for 6.2, should all be gone with the updated branches.

-- 
Jens Axboe


