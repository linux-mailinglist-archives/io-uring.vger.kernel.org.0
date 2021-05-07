Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB654376AD1
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 21:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhEGTmQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 15:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhEGTmP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 15:42:15 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629D7C061574;
        Fri,  7 May 2021 12:41:13 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o26-20020a1c4d1a0000b0290146e1feccdaso7077504wmh.0;
        Fri, 07 May 2021 12:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QMBN8Tzu87TXoXrnymaHyiFE3K8qYGQVXLsHEsQ4PM8=;
        b=Az5G/KWkSaUjdKlRJbJ5sIMQIMeKHXlFUckMG4iDmwaLZnBpAUTx2CQz+DnuMND6Im
         UpVvWDEj/HtEcsMMa+SxAiGQU7YyEBer3d3Y+RLIKD4XqphuJg5MVwLYHvVP0yO054eb
         9VkcDnSgR7zMhcpnwobU0dKit0Z2cG9IwQn+LllGoia1maRoSwgjAfBbnsmwjxR/Pmhf
         GMv4vONT0BqrSeMqRkPTO4Lo+029afglFCKPjSlKt8kcNYA4hjQT04X4FzcYtfhL+Nu7
         esXuvFQnV/yovdT3jCx+oveZMZAE/c5Vdp+oyx+VoV7G8xbT8+6lqeYa6vLLuuYLtv26
         3y2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QMBN8Tzu87TXoXrnymaHyiFE3K8qYGQVXLsHEsQ4PM8=;
        b=Vys9mckjSn0Vwn568XnSEWu0O9cICQvrx0kzAYyPoppTTX8u7lpJoMPhdmJNWtCHGP
         F6h+w2qmi2JW5m+ZRrGYYyF0byWGo6xXnd/JSWVaW7cVuGCn2VL6OD5Ak62nsi48wvhH
         GNpiwubfn/4pggjAeCbVu5Ejcp2lhGkTgyLlAniVdcYde0M2ZggAo3j/fZrpuXeeCoBc
         sSeAKfpzK72zyO4KMQpy6FJlC5dYnMxRpUaU167Tcs+Gse8GeegfxbhjSd2O7lBlTkAS
         NlqHyzEZRn73TFPmxPTW1Nbhhrlfw13EeUBA9VciRelhYW9ytUtnuKBBLOFD4qVUfaQO
         tWpA==
X-Gm-Message-State: AOAM530mH8/++g2QW2gOrPlFbOGuqs3WnnhTuAxkJILDoRCpDt9ceVoV
        rU7C7TTYSxfysxFiEjXPW1Y=
X-Google-Smtp-Source: ABdhPJyFgpJnA4wzYpF16SW9RpI9dHFvLtPShty/dUf9yF3X8dFkaARWyR9O3FDkZiiDBh/3Yt8eYw==
X-Received: by 2002:a1c:c5:: with SMTP id 188mr12011780wma.5.1620416472178;
        Fri, 07 May 2021 12:41:12 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id m16sm9614417wru.68.2021.05.07.12.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 12:41:11 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_uring_setup (2)
To:     syzbot <syzbot+1eca5b0d7ac82b74d347@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000b48d0f05c1207964@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a3ae750d-2588-e84c-8e1a-6ea5b43ce162@gmail.com>
Date:   Fri, 7 May 2021 20:41:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000b48d0f05c1207964@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 7:15 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-and-tested-by: syzbot+1eca5b0d7ac82b74d347@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         0c8ceb80 io_uring: Fix premature return from loop and memo..
> git tree:       git://git.kernel.dk/linux-block io_uring-5.13
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3d4238f574736e51
> dashboard link: https://syzkaller.appspot.com/bug?extid=1eca5b0d7ac82b74d347
> compiler:       Debian clang version 11.0.1-2
> 
> Note: testing is done by a robot and is best-effort only.

#syz fix: io_uring: fix unchecked error in switch_start()

-- 
Pavel Begunkov
