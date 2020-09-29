Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D821127D0A5
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 16:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgI2OIt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Sep 2020 10:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgI2OIt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Sep 2020 10:08:49 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4A7C0613D0
        for <io-uring@vger.kernel.org>; Tue, 29 Sep 2020 07:08:49 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id u6so4910306iow.9
        for <io-uring@vger.kernel.org>; Tue, 29 Sep 2020 07:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=euWnP0EJlqYVaKu5lNq63ImPlulmGIi8tNfvVNhQacA=;
        b=yJ/vStC080VOPuKUMvBTmMUJ1H/SPQ3U7f29zv7UcANL8Z2hrauxe2MtRa6DCJFy/S
         mBWCHeAM2WNCaaA3IlgJVlC45InLmWcqjAsNzgUNikSIiak+4BPAr1Hv50RtsOUyhpW3
         vUZr4FIuyNX8Zw+Olb0YH6UtlxjbRWlg3zcJ9hXWNI8oJzIpyKxYAxBgUWettmTXQDUb
         PgzgiM9klFb1V1fyEOURhsjeES/gaCBo2HManZbKZO6KUkN8z3s+y2w9DtBG4QZD4KaR
         sJNb+ot8MeSxJ5MzQFpgXJTeW6BKHUniIcELOsIHRtuVDRXLsoDrX59RTLFD3G6VSU3J
         7ahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=euWnP0EJlqYVaKu5lNq63ImPlulmGIi8tNfvVNhQacA=;
        b=f0/r+Q9PwOUBNOWbnEHsCwaaI45G5q84kYTiYQCcfp0TVFrklkMLeR3G/wgMRqk9uM
         0VIyQ/T4ZGG5uRkxfNXf1gpVf3c+SwolNrS7lOVobKp9VgoJ/L5rBw9jnnvE/BM3tHP4
         STZrjqRa3us5oeaJKYnEGW1Hi/KbFK7VqkKVvTOxLip1MN2qx2iLcgmJJy+UVhscaV/b
         fgkknqiSzExO//BXVOs8cxavls/4UKyAeT/UbJ2wYaG32EwrjoM0f5aHOlasRULcUIwT
         0OJf7aVyKJDZiMYEfDEamWUufV3UOmfsur8sGXN0U2fky4+0w4XIr5BmZdbhFiud22K/
         bvXA==
X-Gm-Message-State: AOAM531r3aunLWeVJ5AlNwKl6CGwm91THzwrM+6mGZonlVra8uKHP1OZ
        Vjin04Ve99oh98fA4CjUmRPOTw==
X-Google-Smtp-Source: ABdhPJwznZKAEjDwbXPZsPlNS+SrujjBj22UJqCGUldQibpOSN7EhG/+YYv8NUbpjF+Q14qRF0RZKA==
X-Received: by 2002:a6b:8b52:: with SMTP id n79mr2561452iod.122.1601388528281;
        Tue, 29 Sep 2020 07:08:48 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d17sm2470609ilo.3.2020.09.29.07.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 07:08:47 -0700 (PDT)
Subject: Re: possible deadlock in io_uring_show_fdinfo
To:     syzbot <syzbot+d8076141c9af9baf6304@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <0000000000000a315605b06fb13c@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d21299c5-674b-6e0e-bcd7-2b0113b3efa4@kernel.dk>
Date:   Tue, 29 Sep 2020 08:08:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000000a315605b06fb13c@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

#syz dup: possible deadlock in io_write

-- 
Jens Axboe

