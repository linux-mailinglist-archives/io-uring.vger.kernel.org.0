Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22229445266
	for <lists+io-uring@lfdr.de>; Thu,  4 Nov 2021 12:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhKDLrP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Nov 2021 07:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhKDLrP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Nov 2021 07:47:15 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B45C06127A
        for <io-uring@vger.kernel.org>; Thu,  4 Nov 2021 04:44:37 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e144so6531753iof.3
        for <io-uring@vger.kernel.org>; Thu, 04 Nov 2021 04:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+xa/K8iZ5H3AOccYQXVWQN+Tt4/PRKVQipZvC6SEJMo=;
        b=S5G5jDlYdCg+ae++459nbhcVQp5WWC/qgUP4SZQLqLM+GY5UcuiNc54H0/RoRxvNXe
         y6hG3p65YdNdivQz2Z21T5OtvrYphfNpdZRKFf+wOEtlc7YPjPYtv7I+LIoDsu9yu/xP
         9WlB6F930p8csoZtf9HAHSM6k04/+2JlyBZdJy/4VXnc2LE8TMizbnvgOeb1ir0wRXs3
         ohhF/qchfe2+UGKmSGEapya64vtRyhbGGFNbilTrk7gKaYxyJXSY/F4mW8g+xaXWqGM+
         wrbh7armt8VraR6hKxRxY2CgFsEG3OOrA/YRaX3HiTgDxD0bfnP0IR0EK5TugKuTsXCZ
         6xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xa/K8iZ5H3AOccYQXVWQN+Tt4/PRKVQipZvC6SEJMo=;
        b=4+2AvttDIdqUDlX/DbRG5hEwMgZ/xeo+5l8KwmS8sM6fDh9kqvyzXhsGH3KxPuEEgp
         J/FkQ85QcStqWxWOdS59JLZgFhB25S6xSQZ+v3rwlz7Qs2RTN6osmcJEyTlx4BQxjkmB
         qwapKDBgBv2cvgKgt+qBijmQzagSx9+P/s9a0fhjle3cVbZyFn7YkwkUlIQXkUjxWyWy
         p1kRoPIZdocODe9A55UwxLdwXh1ThiOzpFsNcoAEqEldyJSmxUHLfOWGnvCuS522bT4u
         BG/7lPtO81V305lGRo4vQrLEuOUZVwZGmAY1RKvCRWplhx5eXUFDwqOXY8MMVvq6QhvX
         m/YA==
X-Gm-Message-State: AOAM531Gx3URoeBJ0deIueqCSTUgr4JyeVnx4GXxrIOm438nzDhyUXSP
        QJ9+T6N80XcgNFnTtpTCZDh9aQ==
X-Google-Smtp-Source: ABdhPJx7p2YYv77/7wwcpEx5ePCK2GPcv203PdvCaEh+RL+mwkU9eA/eT5AgNn7HskkQ8yfJ7ezySQ==
X-Received: by 2002:a5d:9751:: with SMTP id c17mr35566441ioo.61.1636026276916;
        Thu, 04 Nov 2021 04:44:36 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v4sm2524632ilq.57.2021.11.04.04.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 04:44:36 -0700 (PDT)
Subject: Re: [syzbot] WARNING in io_poll_task_func (2)
To:     Aleksandr Nogikh <nogikh@google.com>
Cc:     syzbot <syzbot+804709f40ea66018e544@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiaoguang.wang@linux.alibaba.com
References: <0000000000007a0d5705cfea99b2@google.com>
 <0935df19-f813-8840-fa35-43c5558b90e7@kernel.dk>
 <CANp29Y4hi=iFti=BzZxEEPgnn74L80fr3WXDR8OVkGNqR9BOLw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <97328832-70de-92d9-bf42-c2d1c9d5a2d6@kernel.dk>
Date:   Thu, 4 Nov 2021 05:44:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANp29Y4hi=iFti=BzZxEEPgnn74L80fr3WXDR8OVkGNqR9BOLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/21 4:45 AM, Aleksandr Nogikh wrote:
> Hi Jeans,
> 
> We'll try to figure something out.
> 
> I've filed an issue to track progress on the problem.
> https://github.com/google/syzkaller/issues/2865 

Great thanks. It's annoyed me a bit in the past, but it's really
excessive this time around. Probably because that particular patch
caused more than its fair share of problems, but still shouldn't
be an issue once it's dropped from the trees.

-- 
Jens Axboe

