Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F1A3EF84E
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 04:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbhHRC7S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 22:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbhHRC7E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 22:59:04 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4109CC0613CF
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 19:58:30 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q2so884512plr.11
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 19:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YdmIuyF92LGiV6+vakUJJZRgq/yRSpMjmpEbsFkYVp0=;
        b=EKqkwTTEMNNBAFF+3R0Qo936G9BTekrWtCEpqQLICHJ2cQuyZp0QKf9/pF8tEYK5/1
         OtpZObMcTQyTgswjnHashw91VbnSamMwr5ATlkQcRhSHIPgiLx4+qPXLqg1zq0m3BwXh
         cbyqkmpocLct+z1g+fs9FdMEqiM3uMFgxoznEvvWOYDtt6v2BdoiGCwCRdfwfJRrHW2L
         eR6HUzYqFYOArD2wxHZexnY/2DwuSca7mij+hloGKsLijV+YW54Do35hmSjF5XKpC3zr
         wKtNRMxx902AzeDelruMYoyEaH2SQTls4zmcrsNpyf0CCr2WqIlvCnEAIk02OGuQ409B
         veSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YdmIuyF92LGiV6+vakUJJZRgq/yRSpMjmpEbsFkYVp0=;
        b=VkiwiZKtkZ3Cj8Y1irrGxTQfRdPD+w+AmTX0SLDkVVtkeA5akZ5zGzUF8Dr7sDdYZu
         6JvYW8+lGuKbyLRwR3d7Qnxz3VoiICkf6JA51Z5te1Y2qjJ+oq1Ton0TXWNn161i7bAU
         5MIUWqS3f57rNEOU3amNrg6mmqlQAOEwz7oiKInBK92J3ZYHMb5j7mfqBIe4LKUI5Noc
         7nGmICgjm56tjeinWpK/ACkqSvEq+VcwsHe1XSb17+dCBoLKqATedlXZEs6WHeYJ4EtY
         Qja09wvhJgoo2V5F36OdUWF46SjIt+Dowk9sM58Sr4zvU7j8aWNtVIc0b4yg3KVh2sMM
         Lv8w==
X-Gm-Message-State: AOAM532tKFvtb8AQvRkfkuA7smESV+/U0PGnwq88vGQKhcU5dYQmvV6O
        xJ7TCsYxqTvPSSx33Hrb4nGG9A==
X-Google-Smtp-Source: ABdhPJyy9CJWGbwRitw2QgxNzSiCer2iVaqihxz8Cfeb1xWDFJoq7aO3SRaoVyD94PhspH28aWD6mQ==
X-Received: by 2002:a17:90a:6782:: with SMTP id o2mr6838904pjj.165.1629255509787;
        Tue, 17 Aug 2021 19:58:29 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 10sm3806486pjc.41.2021.08.17.19.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 19:58:29 -0700 (PDT)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
From:   Jens Axboe <axboe@kernel.dk>
To:     Tony Battersby <tonyb@cybernetics.com>,
        Olivier Langlois <olivier@trillion01.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
 <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
 <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133>
 <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
 <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
 <87pmwmn5m0.fsf@disp2133>
 <4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com>
 <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
 <9d194813-ecb1-2fe4-70aa-75faf4e144ad@kernel.dk>
 <b36eb4a26b6aff564c6ef850a3508c5b40141d46.camel@trillion01.com>
 <0bc38b13-5a7e-8620-6dce-18731f15467e@kernel.dk>
 <24c795c6-4ec4-518e-bf9b-860207eee8c7@kernel.dk>
 <05c0cadc-029e-78af-795d-e09cf3e80087@cybernetics.com>
 <b5ab8ca0-cef5-c9b7-e47f-21c0d395f82e@kernel.dk>
 <84640f18-79ee-d8e4-5204-41a2c2330ed8@kernel.dk>
 <c4578bef-a21a-2435-e75a-d11d13d42923@kernel.dk>
Message-ID: <212724bd-9aa7-c619-711c-c156236c7d1a@kernel.dk>
Date:   Tue, 17 Aug 2021 20:58:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c4578bef-a21a-2435-e75a-d11d13d42923@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Olivier, I sent a 5.10 version for Nathan, any chance you can test this
                                     ^^^^^^

Tony of course, my apologies.

-- 
Jens Axboe

