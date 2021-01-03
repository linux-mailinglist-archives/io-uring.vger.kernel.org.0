Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5362E8CC7
	for <lists+io-uring@lfdr.de>; Sun,  3 Jan 2021 16:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbhACPNM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 10:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbhACPNM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 10:13:12 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036F3C061573
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 07:12:32 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l23so8814058pjg.1
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 07:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=v+Vgx2uLMkGcXq3qiRsA8HbQnYlfpAH07UvWOWDq37Y=;
        b=Eim5EMTS6x+v/yVivwory/5netFnVUpRWUDtPIOtw0zxN2D/giJVo8WAb/tMdJQfES
         dl0uukuMFk1R3fRYQQj5pngrnXUDSzpU21Aqg5zRSTdFU/e1IXDFjMeOCQ4MSb0gOlDd
         rwAtmbZyXMPY4kbZ3WBH06Z/STU2kOCgr8ZJbQDm6WR983Gpsgn0iujHLe1LnVNGUL3E
         4OL+MglDMMb/53EjXRfLeau85thnnP9+SoMi2JgXQO7BN82LIPseu5XJQfrSRj8Ldm43
         7uQ//xGBYYtFImND/eVAI3/Ff4nFZUXJLQaTVzA5uceRa2ETBfisfxbrAKN91OgN/eF0
         Cbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v+Vgx2uLMkGcXq3qiRsA8HbQnYlfpAH07UvWOWDq37Y=;
        b=SG034FZScZIMwfZFW6oXY0oAeW8XIw0ZSHMAviHXKLnW4Cyozju3ASpUBxNkwFyKag
         Ll5HHo2Eyei6o0bScr8HWVYy8JVC4/1QM1aWLEtjcYYK1lv9mLXzGwxkA9HpqmGYYdto
         1kMK6aq7ERR/5ZxUBtyZ/5exViutR1eDTOin67YKNxnhfLzjq0GfWdX6liynyt2ebCEr
         3N6ON7v2y8D1Q60Shj2pzvNrpV1QOaCY7ncVgHTQHbPnZ2b8LMwHKFHyfxS+MFKZf9FV
         mcz3Q1qrewWm0WUkrRyfOwAxCMiceyV+z8wDMEcuP0ye76Kep2vQmU33MRBBC3cFxddX
         Kocg==
X-Gm-Message-State: AOAM531c6bZBJ0LCenUpwvGc1TZ+YcGRi6WM6Swp3LJXevkuXUxdP1UD
        RLK1F5Z3saLjtQ0jZkz8UQR0bcDAj/u9Zw==
X-Google-Smtp-Source: ABdhPJznpVgJGCs5DxTWGJAwxGJQVDZg0VHsTiSTG0OeuVFd6On5NizSSpwJtC3XblzgMGngRzN0Mw==
X-Received: by 2002:a17:902:aa07:b029:dc:240a:8a71 with SMTP id be7-20020a170902aa07b02900dc240a8a71mr68551643plb.32.1609686751219;
        Sun, 03 Jan 2021 07:12:31 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t2sm47390475pga.45.2021.01.03.07.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jan 2021 07:12:30 -0800 (PST)
Subject: Re: [PATCH 2/4] io_uring: patch up IOPOLL overflow_flush sync
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1609600704.git.asml.silence@gmail.com>
 <716bb8006495b33f11cb2f252ed5506d86f9f85c.1609600704.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ce841f93-8692-892c-15ce-94c0de5d74e5@kernel.dk>
Date:   Sun, 3 Jan 2021 08:12:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <716bb8006495b33f11cb2f252ed5506d86f9f85c.1609600704.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/2/21 9:06 AM, Pavel Begunkov wrote:
> IOPOLL skips completion locking but keeps it under uring_lock, thus
> io_cqring_overflow_flush() and so io_cqring_events() need extra care.
> Add extra conditional locking around them.

This one is pretty ugly. Would be greatly preferable to grab the lock
higher up instead of passing down the need to do so, imho.

-- 
Jens Axboe

