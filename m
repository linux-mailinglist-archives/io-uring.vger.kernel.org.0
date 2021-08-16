Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D91B3EDF7C
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 23:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhHPVu1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 17:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhHPVu0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 17:50:26 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D59C061764
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 14:49:54 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j1so28643482pjv.3
        for <io-uring@vger.kernel.org>; Mon, 16 Aug 2021 14:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fPCjWgqX+3/mEIfqbp98iVRrYqeF+Ke0tX99HW2DLOE=;
        b=HqGhGXenLqa31YLQmzWywUKVR3MSaGYsx84QL+SGvf6q2e9ul5NVRG0IkOJ1ef3UKJ
         FT5xYWIxUX3p5gDEVoF4NeaRCFHRkVeXVWSXYFILcI/83Fogfg5OLC1rQCbjfVco1wSF
         5aNdZ0t2nhmchiUBdTMHpcSeRukMirVtpn4xljbUzZ8o1OlwcnnUu62z4EppDB7lYD4z
         aDfIf4UtaW5GiutXH2UEm339oKldAZ6DORjgzemb/0Huod+QBq8fKhL4bWEPVs77eCdV
         QRGQoUXWoFAe9mvY056nCX/ndVf9vht1Nl5UCcUnVyou6UFnnRWzg2qat16a+VgwHxrW
         McIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fPCjWgqX+3/mEIfqbp98iVRrYqeF+Ke0tX99HW2DLOE=;
        b=Cm6MXq9z85enmfl0VeYwlDxLvU3t7JvOGnPmh8Wj4KVzmOkr8Oj6ap113Ivw7D8TG0
         72TSBPQMaC/dyOyzW3ZehFxCi8YOvxQoDMCPpqHIF1wv/7XC1nQt1xHs1omBhdbHwQ9n
         2ZLQUxdAEeIxuk3AeWMUxDdKKXzDos/dsDSHLqYWPQTj2YGGODuY3FbmS59DauT+VLRj
         9UkZBb4PRPhrA3AHvlBZrHyKb3YXy1yS10VR9LKP5OZ+/cPA/FG6SAE5/M0uvTqdV0kP
         fA75HNhIOvdKpnBkTDwj/EZf1v1/py0WkIkkhZeTZvzfggmp7grPWVBwAPl2eVclnQiC
         4ysA==
X-Gm-Message-State: AOAM532IAWL+K9VBSm1fywFUO+lQhCp/4dBGdQT+nPDDCp5grLw0HqfP
        3LgDMFvL91hKFo97OLkGGf3cIA==
X-Google-Smtp-Source: ABdhPJwElnQo3mvh8vErvFS5KTctdbkZs49cCpCdIXRupV4fwTZ/oQnioQo294P4UStdwg44I5wWaw==
X-Received: by 2002:a65:6393:: with SMTP id h19mr194321pgv.64.1629150594025;
        Mon, 16 Aug 2021 14:49:54 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id gz17sm109945pjb.8.2021.08.16.14.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 14:49:53 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in __io_queue_sqe
To:     syzbot <syzbot+2b85e9379c34945fe38f@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000011fc2505c9b41023@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8236fd18-bf97-b7c6-b2c7-84df0a9bd8e5@kernel.dk>
Date:   Mon, 16 Aug 2021 15:49:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000011fc2505c9b41023@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/21 3:41 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    b9011c7e671d Add linux-next specific files for 20210816
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1784d5e9300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a245d1aa4f055cc1
> dashboard link: https://syzkaller.appspot.com/bug?extid=2b85e9379c34945fe38f
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17479216300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147f0111300000

#syz test: git://git.kernel.dk/linux-block for-next

-- 
Jens Axboe

