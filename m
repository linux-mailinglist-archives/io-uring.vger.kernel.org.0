Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17345333208
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 00:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhCIXp1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 18:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhCIXpH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 18:45:07 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B77C06175F
        for <io-uring@vger.kernel.org>; Tue,  9 Mar 2021 15:45:06 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id g4so10111411pgj.0
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 15:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MIMPh+SXeRfQ61lkDNTW++4hYt6RRQoL+XmybnY7RLs=;
        b=I+YpJYhj2EeUSjKGcgIJVq8/oUTSiAwvwpzZ6eKYyX100iHQrRlylnHdPqLCigRZ2b
         0IrBclRUcKp55ul/SBpHyHl/X9j4NWK2EdbbcL/igCx8+i60ZywQsUXBlodPBHEAKRfT
         8s9q0SDHKU7rAzlXFRYeIZCAP+8QryVFdLZjvMAENZjn57OeksCoUuHYvDDnEWKommIt
         7x8qKCF+BGiWbuSVEbyAZwi9BIT+LuGY3S8rcWcUsU79kej9oVDsBkWlb7ZezIz8VaMN
         Mf0s3X574Viwzi7/v4lNDF3icsJJlvLxVVApUMyfppG181yVsPqPCYn93UekMMirCGeY
         d/9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MIMPh+SXeRfQ61lkDNTW++4hYt6RRQoL+XmybnY7RLs=;
        b=BOaX1e/WHQkB9N8zLlNJl5CCnSa4EwbHYbP6H/ZKWl2e2Kdfmn1DmIO6FVDKB7S1r0
         2vJCGvVGCEhOCRuBq81KwNncZKJvmcZNFbGzvERbTVFd7585DKPpAQeFE5/VYJFsCF8I
         B9A3DFHEC53reSJK51a+W6SI6XBmc81p3E2KK5Xv2JvR+VsyOrSNxx2EgpeJsC5dHSlf
         4mvOHB50QhQ18d9sVLfSlvd3p7z/AOXRhqzIfkyyQOvOubsDoQS3oSZwPj8AwBpqDdsu
         lCMrBe3WeT3ydP6BxCY3hdGY7BhKokzUjjEfgP/Fgn2ijkGxRfunFj/oFpY/HoobCmcH
         MCLA==
X-Gm-Message-State: AOAM530jw5H1GiwrT/Tpqy4Nzp9k44gMXySy3SGmfTBlignYkr0S1vzf
        wY3iJ4tPnqfcbUColnuJPH4oIQ==
X-Google-Smtp-Source: ABdhPJy9cVefkbidAY/7W1zyfzpv/TtxvoNhA7a4MjDNqx1uxbugQv26rNzUtMCMHzXPxLggLpuolw==
X-Received: by 2002:a62:1d06:0:b029:1fb:94fb:4940 with SMTP id d6-20020a621d060000b02901fb94fb4940mr564306pfd.6.1615333506387;
        Tue, 09 Mar 2021 15:45:06 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id js16sm3880010pjb.21.2021.03.09.15.45.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 15:45:05 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] possible deadlock in io_sq_thread_finish
To:     syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000023b36405bd221483@google.com>
Message-ID: <7dff5f11-817d-228a-5623-1df17b05402b@kernel.dk>
Date:   Tue, 9 Mar 2021 16:45:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000023b36405bd221483@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz test: git://git.kernel.dk/linux-block io_uring-5.12

-- 
Jens Axboe

