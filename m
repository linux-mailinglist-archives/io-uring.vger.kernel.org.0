Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4293327B06F
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 17:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgI1PBW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 11:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgI1PBW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 11:01:22 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B61C0613CE
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 08:01:22 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id h2so1531871ilo.12
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 08:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wz4/cJUtcGrHgQdHqiJQL66PoALmhO/Jeqp0NNqQOYA=;
        b=tVc9Ks8AyUnx5Ss4K4lY/dnw7ZGtH8ZOnEEFa2u9Jjf09E8vDx9EKir5p58zO9G8Zz
         cuFKzICCDEomikQ0nnJK2BO2HxwU6lcjema4++Ol0MI0zzfCHyAxGQdjkdbikOqetycM
         5trJgK5UoUBnHeq2nwfJDjpCPLxBwxDmDltnRMiC7AFln4LZbFEEMRAwSviBt2UGqot9
         XVEXuAcmxj7LWRD7pBpCtqrF1zBmoG+XG5vhXEdf/PLYyID9e4UjKi7yDs46nXx72Ayt
         DVY9hFBfRUtF0gNgDak4aAQhWfLa7ftyvFzEHxyhV6kBFl5oeQR8ViB2eCZgq0F8Q6g+
         0Agw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wz4/cJUtcGrHgQdHqiJQL66PoALmhO/Jeqp0NNqQOYA=;
        b=pmGDngzYn0+6CxSR1ZBDfdmEL2aF+HMpCMOicl6z/+8bNo9uBdavCm+xiKcxoygial
         sq7P7C4LkNmbDlqQbX7+qCNHso+y082rjv/M7NDuGF7W57dbMfzWu0SW/z4iZHbC7sje
         bQT6qwIXt9ven54EHxndz6KPLqYiu0m9IvXg//rAdP4lXfvPBEcIkmDtKZLimC2loPYy
         /a/8hqs+JdNqrCUY3LOpRjSzSKWXmmSwMMkPauaKniCdXItotFgGKKIXmyM/oEddj1h6
         PeIBMiIuWeYwfJbUx9gG50nfhUN/zH4laPpImFUc4sma86H1xQrnG1afT9Jd62y43zT9
         bNTQ==
X-Gm-Message-State: AOAM531W+pmhJbJ6guFfHGKIzSxLFJzyJPbtIFuD08YufL31CjweFx9a
        ag0mm3gKqCV+Azk0WIyF8NyjtQ==
X-Google-Smtp-Source: ABdhPJzhsqplk4CkEQgE6tO03x+gt13937ez/h3kCBx/Qs/poGnRb2j4ITML8gMSoKHsg6RduIJA4Q==
X-Received: by 2002:a92:3554:: with SMTP id c81mr1594067ila.265.1601305281132;
        Mon, 28 Sep 2020 08:01:21 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t12sm733682ilh.18.2020.09.28.08.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 08:01:20 -0700 (PDT)
Subject: Re: possible deadlock in io_write
To:     syzbot <syzbot+2f8fa4e860edc3066aba@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <00000000000050a4fd05b05a7579@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <69d85830-b846-72ad-7315-545509f3a099@kernel.dk>
Date:   Mon, 28 Sep 2020 09:01:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000050a4fd05b05a7579@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Not the prettiest solution, but I don't think that's a real concern as
this is just for human consumption.

#syz test: git://git.kernel.dk/linux-block io_uring-5.9

-- 
Jens Axboe

