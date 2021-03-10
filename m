Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EF533406C
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 15:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhCJOiG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 09:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbhCJOhd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 09:37:33 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35C4C061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 06:37:32 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id k2so15738481ili.4
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 06:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MIMPh+SXeRfQ61lkDNTW++4hYt6RRQoL+XmybnY7RLs=;
        b=S9g4kO3E0n8w2vnulllynPenK5mDsbp+txQ5NiLo4nqV/2xv9P0GptaQZs0dSWVSi+
         qGXGSmY39gt6q0q+MyO4Q17LqeNPZcmRRk8pmFbKWNinbEJvCNzdPHBX3oG7bDv6vFDR
         eea6ZpDfSeGLK8RUUl4NqD4gjncQEIbi1U/2WVioI4z2ZSYohFOAmevF1F3jJ/OoDrYW
         KlrRoF32WXgb/cZK5ahvhqe6fBfu4ZDPqieBOU40+H/SrJpMHClE9PL5U/KqGJpzEJJC
         GpW/qV+wglpcNkfe32ynd0Rw0n5RNoWBQAIu0YuycsXEBygRZ6SmRp1BJ+JATCHs0t/v
         PO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MIMPh+SXeRfQ61lkDNTW++4hYt6RRQoL+XmybnY7RLs=;
        b=P8RBF0T3WF0PiScatFtvrf/2TgNdMFudQrNdrBmm0CDbsNNYLbVY0knRQDAEKqi3WB
         2/42WX4qIvgfXgq3B9LkErILNwi3dJ92Gmz2uJv7fy3+6cGpVUEjTIr/x0GdJ9N/a4Ot
         VkLT5R3QqOpoKQt5url/9QETmtLV08tyXVitAFcQ9c/N1LwEBoOpQB0UpSOcVCmjjAKe
         migTeNKFuz1cbyclibfQwaH0GfDk1n+KnWNooNMfQzZMGu4E9S/JYdbLtOVNWoioay0d
         dY9C0VjHZgI9l/HkpjtNSWrC7OSFTEP/iMc+CmZ9eJQSRQH2E3locJvIWPxM/dz85+i4
         8pqA==
X-Gm-Message-State: AOAM530JlAlAGYSQJEPMMPxKHr5TD4CqH/RJzpbIrtH8whOZi+TX2wNE
        mn1ePL02uxwpYMcWDTgcOWW/0A==
X-Google-Smtp-Source: ABdhPJyKMUyXz5OGdxvqBfmAw8E0eq5KoHU+Go4Xu6XBpYnQyGOyMokfrp85G/cN+uqrsJk4qhC1Fw==
X-Received: by 2002:a05:6e02:1c0b:: with SMTP id l11mr2602853ilh.187.1615387052379;
        Wed, 10 Mar 2021 06:37:32 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v8sm9500077ilg.21.2021.03.10.06.37.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 06:37:32 -0800 (PST)
Subject: Re: [syzbot] possible deadlock in io_sq_thread_finish
To:     syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000023b36405bd221483@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <82aa1cb7-9ac4-6c7f-f6c6-baeca226365f@kernel.dk>
Date:   Wed, 10 Mar 2021 07:37:31 -0700
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

