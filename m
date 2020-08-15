Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EF0245343
	for <lists+io-uring@lfdr.de>; Sat, 15 Aug 2020 23:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgHOV7r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 17:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbgHOVvi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:51:38 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B01C0F26F5
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:15:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u128so6106951pfb.6
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BIuH6kISmbFa5kGRXf8C1zMlDZ6CK7mUtowqlOF0/dI=;
        b=N7LAbLrRiARO/ku0BNslWmbNZ5KMCXLYS4qzRJQeD3ePz5Yc0oZPSKTy+Q+tKlLaSZ
         vw4sOnwZUbHIwBkpaULk8Dqk1m0Ks89+CTMi2qyHyNAhT49JzM0/RZm4qt0hZ/wedgnT
         nca35p5YbcomCaOpAzEKL0DcuitU3yNF+7APgnu2ircedVIIIkJb3bDwhLaBmRHPIcvj
         p4Gzixsux1Po9Z+nJQoK/7ZRuqxIibSsvwuMfnEeEiYNN118g0/aECXWk0JIf8Zqmitp
         R4cMpAJMWrzNAoJt+US7GHgi+0ITpXxHm49DrtT77cwixLU8EFf1Q6pad9Pfenz+XvZ1
         sOaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BIuH6kISmbFa5kGRXf8C1zMlDZ6CK7mUtowqlOF0/dI=;
        b=pwKLozHWDIq+9qgnB8rHK2hf4EADRKNZCxGVjJ1sWp59VpG9QtvFbhfcdOy6Sat+rD
         MyMXkg/eQ0JjCyDk/0F/9YpNI1008SS17Daf0iThh5ETTa71xXD5YQ3qXkR7DgBz5C+G
         pwmHlAGOVVayQCpcvVktmcY+nu6J9awNaZSdqquFt1MvHxXc/pDfaiwK+aibqkLxta3u
         aCs3mOv/hCA7fpK3iVxiLm+WA9G5lZbFK/mDkMr0Ie4EP3wb3tvFZX9TLfaAgZgQYuxc
         FZahxvJrgj5iYHy6c04AN91drw80SgVs9DLRB3oU0uXCA/jRK2b+VaPr+WU7tste9/b3
         PJ6w==
X-Gm-Message-State: AOAM532j4pMJvtZmjftDfHXveZu0Vt7EyMbkTL0ukMeqwh9XC9Klg7JJ
        +k14voNz7+InYMDKnN4r0D+yeQ==
X-Google-Smtp-Source: ABdhPJyfy8cQiabf33POMoUVdvZFoEvwy1OBJwtbtdWdmCXbYJDDDjojpV/LcyrdhWnFkCXCxmfsvQ==
X-Received: by 2002:a63:143:: with SMTP id 64mr5167393pgb.343.1597515300385;
        Sat, 15 Aug 2020 11:15:00 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id j94sm11734141pje.44.2020.08.15.11.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 11:14:59 -0700 (PDT)
Subject: Re: possible deadlock in io_poll_double_wake
To:     syzbot <syzbot+0d56cfeec64f045baffc@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000923cee05acee6f61@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e3494c53-f84e-5152-42b0-f8ddd3ad4ccb@kernel.dk>
Date:   Sat, 15 Aug 2020 11:14:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000923cee05acee6f61@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz dupe general protection fault in io_poll_double_wake

-- 
Jens Axboe

