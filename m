Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B6C4006BE
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 22:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbhICUjp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 16:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238745AbhICUjo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 16:39:44 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75105C061757
        for <io-uring@vger.kernel.org>; Fri,  3 Sep 2021 13:38:44 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id u6so457670pfi.0
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 13:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=O852osv+CkIRpznE2pAKwN7fpf+eNU4GSL2BaYJ+Biw=;
        b=q7teKd3QUB9rL2WzVZQeTIIZXAUgTHS0F/pFTHuxSFmf1F0lfiGGIFvBAG9B9MPjE8
         lhwq7ah+Ck1TdrmD21OAYnJSIuBUqlZbzF6N9ljkg2KM+ZFNH/Pm+CCxp7IHzRqSsjhu
         xHBorM6GwOK8KCy2EF5f8DA9XocNnrh4I/VOO64i/BYps/y54CGMHR697dEBalYE+irc
         W7HdBoLyUeNmLp0rZ8rBVlYMjTIWRhMey2eGW2wp9zEwR+x6GhnPJzn3S6rb7kkKxVOr
         jlmnCK7yOBUaeciQzQIoE+P9ha7pHVZfyntC9jzq3g3KuVM33QvbvvHYT+xuxaG96rnW
         y1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O852osv+CkIRpznE2pAKwN7fpf+eNU4GSL2BaYJ+Biw=;
        b=KGk4ZP6AgFL8tLkthetkFJ3DAjXa2XAHM0QjeKnET1zUmmQe1rff/2WSXfVKzrnKuT
         qR35uOzoavHWmzSwSqGtqsitRXRDmTeKuP2pnjtzOyglZd6NDCe1E07hYAr7+7yDSoAs
         4jas3en5znghHc8nEbyBgJCN06de6onjSv5KkfWTGCo5uCiA3C2I2EtabcFzuHkiY+KV
         4oLNcrQJ2HTaHoI/suhtIs5ho4XBRhLH9Udtxt2Ae9b/Ul4+qyCb996UtjHz6ld5SK7G
         IgFtm93VMZvnZ2l7NxUOVLm/sxur9JyMQWfQZTvB201cdRgZblP15A71khsRpr7Qg+tR
         cFLg==
X-Gm-Message-State: AOAM532payKYAXs3r0nH9NdSuyr58069WiL3EXTy/V5AFSWHSBAjWWh+
        DwaDwQmYnaKNLniVZJvFFxmbPg==
X-Google-Smtp-Source: ABdhPJwiX6QjkoPpWMNIi5Pg8CSYOKKS5d7MUZVleDM0HlJbHkV0ApCQYIBTcI82fGDoyutTPgotQQ==
X-Received: by 2002:a05:6a00:1789:b0:3f9:5ce1:9677 with SMTP id s9-20020a056a00178900b003f95ce19677mr651897pfg.50.1630701523970;
        Fri, 03 Sep 2021 13:38:43 -0700 (PDT)
Received: from ?IPv6:2600:380:7567:4da9:ea68:953f:1224:2896? ([2600:380:7567:4da9:ea68:953f:1224:2896])
        by smtp.gmail.com with ESMTPSA id d200sm232014pfd.127.2021.09.03.13.38.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:38:43 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in __io_arm_poll_handler
To:     syzbot <syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000010f70d05cb1d2407@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2b424f91-0382-d3ab-26c3-52cf03dab999@kernel.dk>
Date:   Fri, 3 Sep 2021 14:38:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000010f70d05cb1d2407@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/21 2:28 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14e6c8cd300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c84ed2c3f57ace
> dashboard link: https://syzkaller.appspot.com/bug?extid=ba74b85fa15fd7a96437
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137a45a3300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105ba169300000

#syz test git://git.kernel.dk/linux-block for-5.15/io_uring

-- 
Jens Axboe

