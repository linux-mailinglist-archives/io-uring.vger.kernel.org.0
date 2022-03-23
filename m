Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA99A4E5940
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 20:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238553AbiCWTjj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 15:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344305AbiCWTji (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 15:39:38 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCACE0B8;
        Wed, 23 Mar 2022 12:38:08 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g20so3099133edw.6;
        Wed, 23 Mar 2022 12:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=nGTAh3VFxfF30v+szl0C7u8CzPhVgOsJVDuXB5GMlyg=;
        b=UwlRQqOFj6+z4kxoIRPNhz8h13FCSRRYd7y05W7RHmOdYQNAWrdL/VqXbwy4sAqfME
         QiZql6SLAvzWrU6I83Eh0T4L6DXMbP1nkiK8iz/KZF606StrpIDgYfGqLOtv46x4W7Ht
         oIqqaIXXSPvAIf++mtXynMB/o9FmTJZazoXZ2ucUZt/i1qOriC5Emc47egS0pwwayxe1
         pX9Tzlkcp9gv6a9oxjMhPZfIfagTO2kgfwQoYU6SY7bbN7PQGlrTl4ZM7O1rX86hkZw8
         AbSb+V5KxwmRbn0+f4/HFBaEuSHlEv9HhS76VpRT/nRhXN+GQ6giaJD22V+8TWWRGikp
         iVbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nGTAh3VFxfF30v+szl0C7u8CzPhVgOsJVDuXB5GMlyg=;
        b=3OTUMFMOvEqOvjLYv/elo6nQKKqxgBr1U59hMfOuin1d8UzZMUIDcHcsRadz3b/c5/
         14sgzzpUDO1kth41HJo0nJMHi7exbEiO/tKZS8tbWFZQD4mTM42vRA2EnZjiRs1U6352
         N5b1yqthXAThLFRrBr03oiVF4hQx0NYxKWfcq37xWCZxEY56KUuxMZL32FQ4hxO0i7Y0
         zcpnbFIYv6mnjI2tDCZB90YI0zDlCjxHZzbsXY0PjKytrlfS2/S8VAuerMnba366eMby
         A64N8WfersRiMSu56FeV3rzgZDgboM42CfZlsohtF0Y1IFnkbu0gL2+7WyHfKHeCnHk5
         aM7g==
X-Gm-Message-State: AOAM530aWQS/ABJOVBfn32DZJVBt+1apvWfFaDmv5V1bVQCrraX2H26R
        eUwrlxbUEqsAWdYvs8Hdp0A=
X-Google-Smtp-Source: ABdhPJyPQG6hxldJ7qnrkTTN+HIBSIdhpt4u36wU3Yzl9GBmYTF367tK7mivPKqE7rT+s516Ph1LfQ==
X-Received: by 2002:a05:6402:11d4:b0:419:5a50:75a4 with SMTP id j20-20020a05640211d400b004195a5075a4mr2260451edw.226.1648064286570;
        Wed, 23 Mar 2022 12:38:06 -0700 (PDT)
Received: from [192.168.1.114] ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id y14-20020a056402440e00b00416046b623csm430859eda.2.2022.03.23.12.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 12:38:06 -0700 (PDT)
Message-ID: <442f565c-b68c-9359-60d1-dd61213d3233@gmail.com>
Date:   Wed, 23 Mar 2022 19:36:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [syzbot] INFO: task hung in io_wq_put_and_exit (3)
Content-Language: en-US
To:     syzbot <syzbot+adb05ed2853417be49ce@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000099e7a405dae66418@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <00000000000099e7a405dae66418@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/22 17:52, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b47d5a4f6b8d Merge tag 'audit-pr-20220321' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15e065dd700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=63af44f0631a5c3a
> dashboard link: https://syzkaller.appspot.com/bug?extid=adb05ed2853417be49ce
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d673db700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14627e25700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+adb05ed2853417be49ce@syzkaller.appspotmail.com

#syz test: git://git.kernel.dk/linux-block for-5.18/io_uring


-- 
Pavel Begunkov
