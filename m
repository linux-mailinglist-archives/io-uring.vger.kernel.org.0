Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310EF3F21F7
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhHSU5i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 16:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhHSU5h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 16:57:37 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B40C061575;
        Thu, 19 Aug 2021 13:57:00 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so4773865wmi.1;
        Thu, 19 Aug 2021 13:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=K7z0p/jibmo9XkKs22cylHJSL1ZQYrlcqLELAzZjuMM=;
        b=eG8JoX8cndeEjZrNzSeCF9Yr7JodOqglZAT3PGzsDKW1+J/EKI/Q/Sa3L50l3VNvd7
         UkGKia59VUOAuwxuxnhnU14+b8sJFdGTxXQNHHl2U3f4jwTDFvLBASb1Uy6Yfh7JA1nB
         6vKk9InSmR6xXJ2lt8n1+NJycdPF46OTuxsKBNxR+QolBCMuEMhwbn43U4h78h70vhJk
         zz0S36vgpPwfwhOkwinMpBjPKpEXpT1awivQoOJPDVgOl9Eo6ERhkl/4j1Wimo9toqRn
         oYSHQ3ydPnvtH/BA1g4fvK/fsTw72FN1JO+rKl//hIBqc6cEua9u9jcUNNmqBCb/+Hu3
         qPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K7z0p/jibmo9XkKs22cylHJSL1ZQYrlcqLELAzZjuMM=;
        b=SbQInj+DExT5FZzUJ/WxPzMTkXbaOwTlT9F6jpcWx21PF2jBkuTy92Oo55lsNmdP9D
         SeO5KRwPTNQt9nnZq8AexyV8VMVkwhXkuMuPBUqJjZTdD17oWKLyb/yagr+Arg1IvAZ+
         T3u+mOIuSSOVEq4SnQvg0YQ+BwbttFnEWDPmV6vDQpfR0D70XUQGhthgY6eaRLDQ16J7
         lBh8K0himWTavBq2IensLXQkz/W20wOn/XqkFyvYg8+Dn/LE7RPwocKmHzTv396aJw1e
         NzcL1pI2l23YH5LPq7KcapWcAHBWLEbIkH2bN5sYjAPc6VCLaQpD4dDnJJ1lUzGsQj7x
         gyzQ==
X-Gm-Message-State: AOAM5336RLB2kar8cHiNo/R7sXWfbt7xEtS//0dCUhSV6+qUJrp5Wwzp
        j9lQW+H8TSrUlKOT8BEI93g=
X-Google-Smtp-Source: ABdhPJxPtnJFYPoOAx0Ck1vv6n8nnYvS44YlYZUlqOMnqmmsm9eSdYJ+KdF4j19HAIP8kjtwmsutQg==
X-Received: by 2002:a05:600c:4896:: with SMTP id j22mr498385wmp.170.1629406619431;
        Thu, 19 Aug 2021 13:56:59 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.21])
        by smtp.gmail.com with ESMTPSA id s10sm4672972wrv.54.2021.08.19.13.56.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 13:56:59 -0700 (PDT)
To:     syzbot <syzbot+9c3492b27d10dc49ffa6@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000008f3c605c9ecd545@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tctx_task_work (2)
Message-ID: <a8a25b40-90ef-f366-4f5c-1ec95638d725@gmail.com>
Date:   Thu, 19 Aug 2021 21:56:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <00000000000008f3c605c9ecd545@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/21 6:25 PM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue

https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.15/io_uring&id=84a8ffdcd42da1f0710819e863a7db4309d4ceac

Ok, looks this patch broke it. I need to look where I'm wrong,
but for now it should be dropped. 

> 
> Reported-and-tested-by: syzbot+9c3492b27d10dc49ffa6@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         923ffe35 Revert "io_uring: improve tctx_task_work() ct..
> git tree:       https://github.com/isilence/linux.git syztest_ctx_tw
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cb4282936412304f
> dashboard link: https://syzkaller.appspot.com/bug?extid=9c3492b27d10dc49ffa6
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> 
> Note: testing is done by a robot and is best-effort only.
> 

-- 
Pavel Begunkov
