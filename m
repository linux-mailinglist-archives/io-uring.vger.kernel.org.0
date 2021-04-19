Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270C1364937
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 19:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240149AbhDSRvi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 13:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240158AbhDSRvi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 13:51:38 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACF7C061761
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 10:51:07 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id g125so7075306iof.3
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 10:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mBPy/kuTJuUrZLkWwHS3lWj/u450VV6pB+rdfegfvjY=;
        b=wGFGo25NU3QUJ9xq/yU8mQlt12iDfbifCsx6oQ3o0IMQe0mbQnhKW477azrdYqkJsx
         0EkErXshYLbgkVSllkG+4V6fDmt/4hD2+9E4tHzD9awbKzFq6NYBTkBjSlTRNJ5urTqe
         srEelnboOvSRbMWiGSE6McaZo5YZc369NeQzT1nmwm2m4PTFV8yxLfiTt4TAUy0Yyyug
         1QHeofzDafyqQjiKuTWSph/S94CjkqeJVBeNLWLuKhnoBavQkNRRSD32pwq7rQWgNmTy
         zX0TcefxLnpIvcS2CcMbzqn0Z+fCTGTitmYaETMl+1EDhJNAWvvnTaTPb55Q9YDbEVic
         zT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mBPy/kuTJuUrZLkWwHS3lWj/u450VV6pB+rdfegfvjY=;
        b=PXjw4nHl/8xsx9EUcKrCj+AO52CwYhJ/3ZjwIX/eFdghrhtAajbx4o5ST4Xn/hZALJ
         3ItS2Z7XIqe6ri8SuHXHNFBO31BwpDjV6mpqtMootImnaFjmqp/ndqYQmoee/UQGZnMU
         wV27eYUU2Ld+oZAYloO4WJ/4Pp4ctsEzDL0wtU1hxJ2X3yv6eWFF9HgvqfNSRC/Vnr8m
         qDyQetXsqKeg9u+EdqBj6kGjKAE1JJZDQYBho7PSt9k0umdyn/H2JUtKOwX36k0TtFKf
         Cad2Gm0ugzhy6lvpIr8NdujufeEfpziSBgCulzX54XvDhWmawRy6ucI18rTPh3k1qJcQ
         wJOA==
X-Gm-Message-State: AOAM530e3xYwYIM1xjNBxBOawcYdqt9dCPvdLrxXy1mqmp9VDbA2+2ke
        oTHSxssao+0Ndh6jOhsDCi/YDQ==
X-Google-Smtp-Source: ABdhPJzU0RP1DjE6xL0Yu1H6Ul3Mx/9UxO3jL5+rkP0peg9JfXJpharVKCTfxx+P/2slMQi+ROXrsQ==
X-Received: by 2002:a05:6602:342a:: with SMTP id n42mr15511410ioz.88.1618854666497;
        Mon, 19 Apr 2021 10:51:06 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b9sm7301940ioz.49.2021.04.19.10.51.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 10:51:06 -0700 (PDT)
Subject: Re: [syzbot] KASAN: use-after-free Read in
 __cpuhp_state_remove_instance
To:     syzbot <syzbot+38769495e847cea2dcca@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, ducheng2@gmail.com, dvyukov@google.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        mpe@ellerman.id.au, paulmck@kernel.org, peterz@infradead.org,
        qais.yousef@arm.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
References: <0000000000000c120805c05452c0@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c46f1e7f-17a5-7739-5290-185226f31c14@kernel.dk>
Date:   Mon, 19 Apr 2021 11:51:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000000c120805c05452c0@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/21 8:41 AM, syzbot wrote:
> syzbot suspects this issue was fixed by commit:
> 
> commit 470ec4ed8c91b4db398ad607c700e9ce88365202
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Fri Feb 26 17:20:34 2021 +0000
> 
>     io-wq: fix double put of 'wq' in error path
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11e89cc5d00000
> start commit:   cee407c5 Merge tag 'for-linus' of git://git.kernel.org/pub..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8f67201de02a572b
> dashboard link: https://syzkaller.appspot.com/bug?extid=38769495e847cea2dcca
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154e360ad00000
> 
> If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: io-wq: fix double put of 'wq' in error path


-- 
Jens Axboe

